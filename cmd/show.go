package cmd

import (
	"fmt"
	"github.com/spf13/cobra"
)

type Options struct {
	optint int
	optstr string
}

var (
	o = &Options{}
)

var showCmd = &cobra.Command{
	Use:   "show",
	Short: "A brief description of your command",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("show called: optint: %d, optstr: %s", o.optint, o.optstr)
	},
}

func init() {
	RootCmd.AddCommand(showCmd)
	showCmd.Flags().IntVarP(&o.optint, "int", "i", 0, "int option")
	showCmd.Flags().StringVarP(&o.optstr, "str", "s", "default", "string option")
}

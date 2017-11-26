package cmd

import (
	"github.com/spf13/cobra"
)

func NewCmdShow() *cobra.Command {
	type Options struct {
		optint int
		optstr string
	}

	var (
		o = &Options{}
	)

	cmd := &cobra.Command{
		Use:   "show",
		Short: "A brief description of your command",
		Run: func(cmd *cobra.Command, args []string) {
			cmd.Printf("show called: optint: %d, optstr: %s", o.optint, o.optstr)
		},
	}
	cmd.Flags().IntVarP(&o.optint, "int", "i", 0, "int option")
	cmd.Flags().StringVarP(&o.optstr, "str", "s", "default", "string option")

	return cmd
}

func init() {
}

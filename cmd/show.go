package cmd

import (
	"github.com/spf13/cobra"
)

func NewCmdShow() *cobra.Command {
	type Options struct {
		Optint int    `validate:"min=0,max=10"`
		Optstr string `validate:"required,alphanum"`
	}

	var (
		o = &Options{}
	)

	cmd := &cobra.Command{
		Use:   "show",
		Short: "A brief description of your command",
		PreRunE: func(cmd *cobra.Command, args []string) error {
			return validateParams(*o)
		},
		Run: func(cmd *cobra.Command, args []string) {
			cmd.Printf("show called: optint: %d, optstr: %s", o.Optint, o.Optstr)
		},
		SilenceErrors: true,
		SilenceUsage:  true,
	}
	cmd.Flags().IntVarP(&o.Optint, "int", "i", 0, "int option")
	cmd.Flags().StringVarP(&o.Optstr, "str", "s", "", "string option")

	return cmd
}

func init() {
}

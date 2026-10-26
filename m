Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6056606A325
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 20:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=5G/pFS4k
Received: by kanga.kvack.org (Postfix)
	id EF1746B05B7; Mon, 26 Oct 2026 16:28:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA1EC6B05B8; Mon, 26 Oct 2026 16:28:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB8C26B05B9; Mon, 26 Oct 2026 16:28:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3AC86B05B7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:28:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 62EA6140844
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:28:54 +0000 (UTC)
X-FDA: 85365916188.18.C54EE87
Received: from relay.hostedemail.com (unirelay08 [10.200.18.71])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8F81140009
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:28:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793046532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JOR5bbIbiInINDDKl8udJD2n2rQt1cixikmX67XYQ94=;
	b=lB1I+iGEqS1ebGDxVKM5wTGxG+Sy1rf9vWX7ttS/vsKS6uDC22Gxku1acI7dL1yKnWwpDB
	OM4Zoi6iCZ9CfYxrNs3RjK0N3wop3dW0cg6W0vjqwUJzux441JEDKLpWBC53KEcr9H7GIC
	SFwsLEtCvlBEfNvGlj77LEQu3T6TcjI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793046532;
	b=6EZsmipT5+DBYekrMRk/Yc4KdoER8bSkzIwQ1rcoPTjzkPw3vmcyxGjdU9UNcJZefZc34e
	b7Xt3lFqWiz/5bbJWP3pLa0ZyUUgvr+5xvYMIqrCEtFXivaXy0riuUoGN0vE8j4nMbpclY
	d1hHocyzZ5pClsgoFDs7sIdBmOzdGlE=
Received: from omf17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ECC7D140864;
	Mon, 26 Oct 2026 20:28:50 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf17.hostedemail.com (Postfix) with ESMTPA id 1955118;
	Mon, 26 Oct 2026 20:28:48 +0000 (UTC)
Date: Mon, 26 Oct 2026 16:28:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: BoxStrikesTeam <BoxStrikesTeam@proton.me>
Cc: "brauner@kernel.org" <brauner@kernel.org>, "kees@kernel.org"
 <kees@kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
 "jack@suse.cz" <jack@suse.cz>, "mhiramat@kernel.org" <mhiramat@kernel.org>,
 "mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>,
 "jkoolstra@xs4all.nl" <jkoolstra@xs4all.nl>, "farid.m.zakaria@gmail.com"
 <farid.m.zakaria@gmail.com>, "linux-fsdevel@vger.kernel.org"
 <linux-fsdevel@vger.kernel.org>, "linux-trace-kernel@vger.kernel.org"
 <linux-trace-kernel@vger.kernel.org>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [RFC PATCH] binfmt_misc: add binfmt_misc_select tracepoint
Message-ID: <20261026162846.23686159@gandalf.local.home>
In-Reply-To: <cmtfuzYFZMj7WozUoEjFs3RxYWe9UgdY5rK3ZGT7CPwO1mpemvEwNhG4v5ucoKBgUHMqFa7kSzOvLjFcVcxAybfmKdURZ4h-qoKX1lHXlAA=@proton.me>
References: <cmtfuzYFZMj7WozUoEjFs3RxYWe9UgdY5rK3ZGT7CPwO1mpemvEwNhG4v5ucoKBgUHMqFa7kSzOvLjFcVcxAybfmKdURZ4h-qoKX1lHXlAA=@proton.me>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX193Yt8I2BKFgojrvTfdeQfvY6W/MQa/MvM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=JOR5bbIbiInINDDKl8udJD2n2rQt1cixikmX67XYQ94=; b=5G/pFS4kvRmY+FpqSfvYmgy1VmMMFvFIYFHxl+48nU9Q+OVL316//PslVP42qJzTQy+TJdC59hDbcVyb1GLW1YoUSJhkbm7wiSUUMR9Sjq9f8n1Pm5As6qgNjijzS9k+qBLc2+9PswJgFqS5pc0EMZ49z1Q22DHKMvSYB6pNQBk=
X-HE-Meta: U2FsdGVkX1/JMOcv1OjDojaLV+nCutKkXq36M/X9yG5D2u9mr6nzoEnPM7M+QucS41MT2z3fV9QQaSDEg85HXXiQNmFkcUj/ElBU/bA3Jkb7czxONW7s8b61PU1nZlCTSiML7BF9dwTqD2SZ7yx8ZbmmNRjnv7V3rmABebYT8ErViBrHGIsfMPR7RUNkjGK0k1fFKfcz+Gc+pGArKoXCTiN9yDmPU7zluTP3b7rRr7S1HiOvmwdEPIfrZ3QSWvtB7BOUc0RSnQl0LCaWjyeFkb7lgp/pxtVNMggzodPwzdzG2I/aFD2+mHADp3cLjs25m5aAwMwAAz5VYXAM7zgMk7TUC6+CmMfk
X-Rspamd-Queue-Id: 8F81140009
X-HE-Tag-Orig: 1793046528-319477
X-Stat-Signature: 8fdt9rzqso18roqo9h457p7n3ixym9rk
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793046532-837724
X-HE-Meta: U2FsdGVkX1/a3YKYPTeB4oCHLRuWQRpW7JXepbQPo5yQmIS9nPd4cbdDG3LR5QeORQ8xddYdkcnMjBwD38C0p9NohEAuQDaj/O4R4tic6y4dlD6sog0I8/sxbHk5kbapBk2rHywUYGPdzcm96fc+rvol/Xy/O+bxfBKou/Mz2EglEPXSwerfkzxAYosLEEAArRsKTkPw2JYN5sMsUTz944fMuFjSz/Xf5OirGglUWdKNYAXgKSkgI5AaWJwUGji33DLC4wGhWrbl/Mhhwxa7y4Hqhvg2De9KDlTxudh7FrQYjZ/Ty8M5c6txCNWWZ5q87HxrcFy7l6BmvFyuvlwJsx7LC71RlMkLw/K7uYoGbeCPLucQI0xBzuWZK3nd2Kpm0xCwQWIVoZbe7eJcfBeNp7tTzhDly945JGqn8S1dy3Wgjf9FIls1+8lzZf4YX1cQ5BL9klDcgbG3JA8X3XI7a22+w1GQ/LWp2HD1XVXlcLR9ZMFvHBMKLMy6seInfxUDzjY7yFaw16m0hySPFMCDxHIWW4MxVglD0aFxMF20oaqLrLQcpMZbsc09mlbE8jHwtcIlsbQFYSL+r4As+fbL2of9vCPd/zOGLrxEvo6/5a3CiEsO1eBW2r5eSrkQDTe9fguIFa8bEiI/hmrV60c4ViMqspngoM0Z8uYOLodeavwmYDgl+oPXK4l18mOwnNIBid4cpSgOpHS2RqBHGEfJHyL0vW3oIVXFg+Kqqk+S6Kfs8DuIkJ7GdrM2JUWyiNJaCNpuO4y+wbChQcps5ukFwGrZg0fFHxL14YLKiLFTorfPbCZD0+BOpoU5+8xLBJR4ymqSrkI6taIHeW5AAijLaWUIUEJ0qDSbSDaW4A8eVxweIFdJp08xBNrv6kBPDiJ+KHd7xK/lP+8o/dLNKrkvAeEl9wrnPq3Z1BBgdFesQJrbv/F41ihAZLe5dmCq10qVctKJKRz1FvicsW0Ywtg
 16oHPOT5
 TEZ7SqveeatwpVZnpC/WblBb13l6BIzopCW/zYqhTvjGy+QWdiCeLFbER1xsc3SXIRuJM/dcJ3WFIFa2zDZRsgly/wF99ImLEv8wpDgvsXYSc44Ls2Mgh35hzn9kMsUtZuqnKqxlVZCQet9nl/Acs4k50p1eIQwUnvOfrX+byR/BOEZOJynJFNgeB0S7keBHxLsbpDFKgHWj/+b0HFNnkbUzZKdXwGEC70u03t1mTq1G7C+7f5nXXJVNK1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


You shouldn't attach patches but inline them. Yeah, I know a lot of email
clients can't handle that. But claws-mail can! (and it can also reply to
attachments like they were inlined ;-) ).

I'll let others comment on whether or not this patch is needed, but I'll
comment on the tracing side of things.


On Mon, 26 Oct 2026 20:17:26 +0000
BoxStrikesTeam <BoxStrikesTeam@proton.me> wrote:

> From: Eneshan Erdo=C4=9Fan Karaca <BoxStrikesTeam@proton.me>
> Subject: [RFC PATCH] binfmt_misc: add binfmt_misc_select tracepoint
>=20
> A binfmt_misc entry can select an interpreter for an exec.  With a BPF
> 'B' handler, that selection can be made by a BPF struct_ops program.
> The kernel commits the decision in bprm->interp and bprm->flags, but it
> does not emit an event at the selection point.
>=20
> Existing observers have to reconstruct the decision from
> /proc/PID/exe, AT_EXECFD, AT_FLAGS, or /proc/PID/maps.  These sources
> are mode-dependent: a transparent dispatch still reports the original
> binary in /proc/PID/exe, and a short-lived process can exit before the
> observer reads it.  A classic dispatch reports the interpreter, but
> not which handler selected it or which invocation flags were used.
>=20
> Add a tracepoint after the interpreter and the invocation flags are
> selected.  It reports the binary filename, the selected interpreter,
> the handler name (for BPF handlers), the invocation flags, and the
> pid.  The flags are masked with MISC_FMT_INVOCATION_FLAGS so that
> static entry state does not leak into the event.
>=20
> The tracepoint is observability only; it does not change exec
> behavior.
>=20
> Assisted-by: LLM
> Signed-off-by: Eneshan Erdo=C4=9Fan Karaca <BoxStrikesTeam@proton.me>
> ---
>=20
> This is an RFC.  A small PoC and short A/B results are available for
> context; they are not needed to review the patch.
>=20
>  fs/binfmt_misc.c                  |  8 ++++++++
>  include/trace/events/binfmt_misc.h | 52 ++++++++++++++++++++++++++++++++=
++++++
>  2 files changed, 60 insertions(+)
>=20
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -41,6 +41,9 @@
> =20
>  #include "internal.h"
> =20
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/binfmt_misc.h>
> +
>  /* Entry status and match type bit numbers. */
>  enum binfmt_misc_entry_bits {
>  	MISC_FMT_ENABLED_BIT	=3D 0,
> @@ -644,6 +647,11 @@
> =20
>  	flags =3D entry_invocation_flags(fmt, bprm);
> =20
> +	trace_binfmt_misc_select(bprm, interpreter,
> +				 test_bit(MISC_FMT_BPF_BIT, &fmt->flags) ?
> +				 fmt->bpf_ops->name : "",
> +				 flags & MISC_FMT_INVOCATION_FLAGS);

Logic like the above should be done in the trace event itself. Not in the
code path. That is, pass in fmt and flags.

> +
>  	/* No argv is built for a staged argument to land in. */
>  	if ((flags & (MISC_FMT_LOADER | MISC_FMT_TRANSPARENT)) &&
>  	    bprm->bpf_interp_arg)
>=20
> diff --git a/include/trace/events/binfmt_misc.h b/include/trace/events/bi=
nfmt_misc.h
> new file mode 100644
> --- /dev/null
> +++ b/include/trace/events/binfmt_misc.h
> @@ -0,0 +1,52 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Tracepoint for binfmt_misc binary type handler dispatch.
> + *
> + * Fires once for every exec a binfmt_misc entry matches, after the
> + * interpreter and the invocation flags have been selected. Unlike
> + * sched_process_exec (which reports bprm->filename) and /proc/PID/exe
> + * (which a transparent dispatch sets to the binary), this reports the
> + * interpreter that actually runs, so observers can see through a
> + * transparent dispatch.
> + */
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM binfmt_misc
> +
> +#if !defined(_TRACE_BINFMT_MISC_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_BINFMT_MISC_H
> +
> +#include <linux/tracepoint.h>
> +#include <linux/binfmts.h>
> +
> +TRACE_EVENT(binfmt_misc_select,
> +
> +	TP_PROTO(struct linux_binprm *bprm, const char *interp,
> +		 const char *handler, unsigned long flags),
> +
> +	TP_ARGS(bprm, interp, handler, flags),
> +
> +	TP_STRUCT__entry(
> +		__string(filename,	bprm->filename)
> +		__string(interp,	interp)
> +		__string(handler,	handler)

Then here you would have:

		__string(handler, test_bit(MISC_FMT_BPF_BIT, &fmt->flags) ?
				 fmt->bpf_ops->name : "")


> +		__field(unsigned long,	flags)
> +		__field(pid_t,		pid)
> +	),
> +
> +	TP_fast_assign(
> +		__assign_str(filename);
> +		__assign_str(interp);
> +		__assign_str(handler);
> +		__entry->flags =3D flags;

and here:

		__entry->flags =3D flags & MISC_FMT_INVOCATION_FLAGS;

-- Steve


> +		__entry->pid =3D current->pid;
> +	),
> +
> +	TP_printk("pid=3D%d filename=3D%s interp=3D%s handler=3D%s flags=3D%#lx=
",
> +		  __entry->pid, __get_str(filename), __get_str(interp),
> +		  __get_str(handler), __entry->flags)
> +);
> +
> +#endif /* _TRACE_BINFMT_MISC_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>



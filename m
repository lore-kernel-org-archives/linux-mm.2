Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F21E606A321
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 21:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=RPvtGViX
Received: by kanga.kvack.org (Postfix)
	id 3FADD6B08E6; Tue, 27 Oct 2026 17:02:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ABBE6B08E7; Tue, 27 Oct 2026 17:02:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29A706B08E8; Tue, 27 Oct 2026 17:02:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E69606B08E6
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:02:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1E9D21C4560
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:02:28 +0000 (UTC)
X-FDA: 85369629576.08.21DB5AB
Received: from mail-10696.protonmail.ch (mail-10696.protonmail.ch [79.135.106.96])
	by imf01.hostedemail.com (Postfix) with ESMTP id 444A84000D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:02:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=proton.me header.s=protonmail2 header.b=RPvtGViX;
	spf=pass (imf01.hostedemail.com: domain of BoxStrikesTeam@proton.me designates 79.135.106.96 as permitted sender) smtp.mailfrom=BoxStrikesTeam@proton.me;
	dmarc=pass (policy=quarantine) header.from=proton.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793134946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0gdBK2a/7BtrvxXUlX9He8n64shVCDBHPI0R3YZSOO8=;
	b=Ve1ioxSN1xAbgWUZOddvCtBbp+e1QAVWLNiJWAbutwsLXt6/pNO9VTzeBziB/0APenwgOd
	01qIep3B+hIWJGdp6R+H+oZejx0rtqAA1KdoK7xzg1vYRLjy9LIutWQsLq07mBxWTbjSbH
	58TzOlrgxqz1PIFvlVyP5tcRwkyLJP0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=proton.me header.s=protonmail2 header.b=RPvtGViX;
	spf=pass (imf01.hostedemail.com: domain of BoxStrikesTeam@proton.me designates 79.135.106.96 as permitted sender) smtp.mailfrom=BoxStrikesTeam@proton.me;
	dmarc=pass (policy=quarantine) header.from=proton.me
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793134946;
	b=DVl0AMThuIU905Dpq9nbtJ0xqydhm5ZZDW+/x6W+wLvQyCpXALVhgZFEsrr/WBP1U+8fPH
	0islBRf0yJagrPbb8G91kzqOFhS1sIEPfh4riW6+8QX/6Eemm32RBr4ErxmUsPdnXkm9bR
	LPjOb0QuCiyh/jEST4q/jFyYSgNyi/0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1793134944; x=1793394144;
	bh=0gdBK2a/7BtrvxXUlX9He8n64shVCDBHPI0R3YZSOO8=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=RPvtGViX8DtOI+cYibDYRy7LwnkDbu8zH1jzLEv9eW8+BP0fHvfB4+MkW/x7UxS2J
	 dzER/G6vV7gCCK3TFaFCiuR04uvdpoIh0uQkl4yLM/t1zkehwDOQwXjsBN3Q1XeO9N
	 c3VFwUSEc0XmqrnZd4Vv3KvF8/JNCxePthUV5MFS48HYFmRTZzIH3WnQiZr3zccZ6d
	 hzBYwCs5bqVRt5DKj7qKynQ7BvfBb0WVED7vph2zIkwghsuNdQ6CECjjdXPcOLtrmy
	 BlWFBr8Bx8/H8KUgUQT8NRlFK1PPxWBAWk+taXftlZ/diT6g/c3/iKj6H7QT6uQmj4
	 rrrHzr3ZcXPMQ==
Date: Tue, 27 Oct 2026 21:02:16 +0000
To: Steven Rostedt <rostedt@goodmis.org>, "kees@kernel.org" <kees@kernel.org>, "brauner@kernel.org" <brauner@kernel.org>
From: BoxStrikesTeam <BoxStrikesTeam@proton.me>
Cc: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "jack@suse.cz" <jack@suse.cz>, "mhiramat@kernel.org" <mhiramat@kernel.org>, "mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>, "jkoolstra@xs4all.nl" <jkoolstra@xs4all.nl>, "farid.m.zakaria@gmail.com" <farid.m.zakaria@gmail.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Ynt: Re: [RFC PATCH] binfmt_misc: add binfmt_misc_select tracepoint
Message-ID: <Z3h154GvGuNo0lQQgNCwWxpvOkPCUZblnFrYRF1R9dx3Lqyh7mG96XAdo4GDq2Sy-wjlmqcQKcgmosaapO4gy82voeR2rAerZh9u2LmCEiA=@proton.me>
In-Reply-To: <20261026162846.23686159@gandalf.local.home>
References: <cmtfuzYFZMj7WozUoEjFs3RxYWe9UgdY5rK3ZGT7CPwO1mpemvEwNhG4v5ucoKBgUHMqFa7kSzOvLjFcVcxAybfmKdURZ4h-qoKX1lHXlAA=@proton.me> <20261026162846.23686159@gandalf.local.home>
Feedback-ID: 205449183:user:proton
X-Pm-Message-ID: 9f98da1da7a4f9aead59ee0aee5c9d5707e0cf2b
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 444A84000D
X-Stat-Signature: 6ki5me9cy7qe4nu84p4cp3rnghbmc9eu
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793134946-741540
X-HE-Meta: U2FsdGVkX1+ChZ4IsW89y6Um1fUncl0fZc8sJOXQ78CM3I/XTGhqw/f9qv09nwgzWEcehsC97Pq/p+xSoca7S9fccoOqAfT8TeFaPNjjdSI1OBbYnOPaGVTlEPkrwFUwWRX8D7ocKn4r3NNIJyjGLvvNxPtsXEoviXi5lJEbrw6QewrOCN9Twew2m4Plp59s83u7uGDh4h5dXFKsQ3jatscsO63eNNbpq3oFFclYUzOGsudyFU625KhgM/RhdAhepuWbqE1T7X6xdS9dqgZWID/bPqMMFjk99OVSew4Ou9VAfN3/4EPj4gIejffzoheK0mmsLlj99EwcHsIT6wyN6JzH/7xI8HRhfVtT5cnWOJkOkvS4hYc0hCrZWh8k0nrOsFfv3uPNxZ+Ah4DJ9s4+yytUzWlDzu9turhBBUZnZ2iZ9vYJ3T1N4BWIi4RgDwV6cNw/HuT/zosJQZ3dTL/n+YgGdw6mP+VnfmK6mRv3Nlf1fNBnwB9x4hONiIVL7TKa5MeNQY0CxesaRoZnnWPvl5LiD0Q/qcDQia0JRicdH6DMhxoc3/H1hCrWa59nbVQsuciymdioEp/bQqh5VIWm+cIkq56tw7rOpq+z11c5JmpV0ZCnFeg7Qq6KqkyQP7YCOKXuAUT4sgwq/1KXyxrMJu6PrykUmsok+ldmNB8iCiyNfDrxIzaRxfZUzWBRD1dHjHXuQX1xpIybHdT83y9Tlk5aAoxLAK/YSOD6nvSTYEoRMVrnkk3zJ0X2eVo4+LzzyqDHFHJABqd589lGR6sml+WKR0feDLcC4Arkvbk2A/iDtoFfFUggsolDga1uO54hfWaXu1TLF/KKD0jf6PWvVEWhfP97tohHFBWIQTWfb3VDRWDGz7vDR5+MGL8kf/0ddM1as5pNqNh8Wnre9YEh/5IoKMMCS2kPsv2EjXUhON2Pb//LbJQ98a7i1XtYtMcyN8byxlX2uD78AnXRiDs
 3htMd6cN
 7idmkbc3RbYueo7Cvfu4ZiO24Ir9dWUJAMU2GPKArYTc4Dh9MN/y0X/Xki9aPHV6+CSHhPLLXFfUw0d4TK5CQ+tux9HztpYTmWzmT1bLTsD0ysFCel1ThbU4WDkaEa0OTu6ki5hPi9ovM7Eo/RvkY66T0UA1YIm1PozD/Kh1IwYmPHHG3mCNSg/XURV2WSvxTCk6i/IIbk2LiUNcpI9BtKE5r0dRb6c1L6v1pRj3OkWuzhBgCzLmaSPKIq1HbhqYCNXo+s3msSUQ7Dc2ID9/PJ/gbQUGX+JpKpbIC84zTZJoYnsG1iM6m1WVJNXwLf5VA2mSxzecbTasygeweKLh/kcK13umxgOSFVJJWiZg19bJTqXqDLDWTozvkj9GsWYIznZYDx+zcBfd9hKq2SeUNZ0o1NmTI8SMiYfO/Tgeuf/8dm0iqEEJnfLhROvMl4JFAywvZFRq1+c3IOWn9lLHbRYWKrJTy7QScCQKt0FhHSzwcbBhAlB+TE2+5V1c48ObXK+45RpHmC6MKrot9gj+jzgeR4xziNAz2s6X7cX6s5l/HqOwC4rCaSqR2PfRASIsrdy18Be4RCmSc8er6hhEnTe9L+4eD5HuRFVGl7BDmAk+V+MBM+ZG+Hx71euo5XDPuBH5G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Thank you! Steve, for your suggestions.

I=E2=80=99ll take a look at the suggested fixes for the patch tomorrow. The=
 main issue I ran into was that Proton Mail=E2=80=99s SMTP submission setup=
 requires a paid plan, which caused me quite a bit of trouble. That=
=E2=80=99s why I=E2=80=99ve included the patch as an attachment for now.

It seems that Yandex Mail doesn=E2=80=99t have the same limitation. Once I=
=E2=80=99ve prepared version 2 of the patch, I=E2=80=99ll send it to you us=
ing Yandex Mail.

Thanks again for your help and suggestions!



Proton Mail g=C3=BCvenli e-posta ile g=C3=B6nderildi.

Steven Rostedt <rostedt@goodmis.org>, 26 Ekim 2026 Pazartesi saat 23:28 tar=
ihinde =C5=9Funu yazd=C4=B1:

>=20
> You shouldn't attach patches but inline them. Yeah, I know a lot of email
> clients can't handle that. But claws-mail can! (and it can also reply to
> attachments like they were inlined ;-) ).
>=20
> I'll let others comment on whether or not this patch is needed, but I'll
> comment on the tracing side of things.
>=20
>=20
> On Mon, 26 Oct 2026 20:17:26 +0000
> BoxStrikesTeam <BoxStrikesTeam@proton.me> wrote:
>=20
> > From: Eneshan Erdo=C4=9Fan Karaca <BoxStrikesTeam@proton.me>
> > Subject: [RFC PATCH] binfmt_misc: add binfmt_misc_select tracepoint
> >
> > A binfmt_misc entry can select an interpreter for an exec.  With a BPF
> > 'B' handler, that selection can be made by a BPF struct_ops program.
> > The kernel commits the decision in bprm->interp and bprm->flags, but it
> > does not emit an event at the selection point.
> >
> > Existing observers have to reconstruct the decision from
> > /proc/PID/exe, AT_EXECFD, AT_FLAGS, or /proc/PID/maps.  These sources
> > are mode-dependent: a transparent dispatch still reports the original
> > binary in /proc/PID/exe, and a short-lived process can exit before the
> > observer reads it.  A classic dispatch reports the interpreter, but
> > not which handler selected it or which invocation flags were used.
> >
> > Add a tracepoint after the interpreter and the invocation flags are
> > selected.  It reports the binary filename, the selected interpreter,
> > the handler name (for BPF handlers), the invocation flags, and the
> > pid.  The flags are masked with MISC_FMT_INVOCATION_FLAGS so that
> > static entry state does not leak into the event.
> >
> > The tracepoint is observability only; it does not change exec
> > behavior.
> >
> > Assisted-by: LLM
> > Signed-off-by: Eneshan Erdo=C4=9Fan Karaca <BoxStrikesTeam@proton.me>
> > ---
> >
> > This is an RFC.  A small PoC and short A/B results are available for
> > context; they are not needed to review the patch.
> >
> >  fs/binfmt_misc.c                  |  8 ++++++++
> >  include/trace/events/binfmt_misc.h | 52 ++++++++++++++++++++++++++++++=
++++++++
> >  2 files changed, 60 insertions(+)
> >
> > diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> > --- a/fs/binfmt_misc.c
> > +++ b/fs/binfmt_misc.c
> > @@ -41,6 +41,9 @@
> >
> >  #include "internal.h"
> >
> > +#define CREATE_TRACE_POINTS
> > +#include <trace/events/binfmt_misc.h>
> > +
> >  /* Entry status and match type bit numbers. */
> >  enum binfmt_misc_entry_bits {
> >  =09MISC_FMT_ENABLED_BIT=09=3D 0,
> > @@ -644,6 +647,11 @@
> >
> >  =09flags =3D entry_invocation_flags(fmt, bprm);
> >
> > +=09trace_binfmt_misc_select(bprm, interpreter,
> > +=09=09=09=09 test_bit(MISC_FMT_BPF_BIT, &fmt->flags) ?
> > +=09=09=09=09 fmt->bpf_ops->name : "",
> > +=09=09=09=09 flags & MISC_FMT_INVOCATION_FLAGS);
>=20
> Logic like the above should be done in the trace event itself. Not in the
> code path. That is, pass in fmt and flags.
>=20
> > +
> >  =09/* No argv is built for a staged argument to land in. */
> >  =09if ((flags & (MISC_FMT_LOADER | MISC_FMT_TRANSPARENT)) &&
> >  =09    bprm->bpf_interp_arg)
> >
> > diff --git a/include/trace/events/binfmt_misc.h b/include/trace/events/=
binfmt_misc.h
> > new file mode 100644
> > --- /dev/null
> > +++ b/include/trace/events/binfmt_misc.h
> > @@ -0,0 +1,52 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Tracepoint for binfmt_misc binary type handler dispatch.
> > + *
> > + * Fires once for every exec a binfmt_misc entry matches, after the
> > + * interpreter and the invocation flags have been selected. Unlike
> > + * sched_process_exec (which reports bprm->filename) and /proc/PID/exe
> > + * (which a transparent dispatch sets to the binary), this reports the
> > + * interpreter that actually runs, so observers can see through a
> > + * transparent dispatch.
> > + */
> > +#undef TRACE_SYSTEM
> > +#define TRACE_SYSTEM binfmt_misc
> > +
> > +#if !defined(_TRACE_BINFMT_MISC_H) || defined(TRACE_HEADER_MULTI_READ)
> > +#define _TRACE_BINFMT_MISC_H
> > +
> > +#include <linux/tracepoint.h>
> > +#include <linux/binfmts.h>
> > +
> > +TRACE_EVENT(binfmt_misc_select,
> > +
> > +=09TP_PROTO(struct linux_binprm *bprm, const char *interp,
> > +=09=09 const char *handler, unsigned long flags),
> > +
> > +=09TP_ARGS(bprm, interp, handler, flags),
> > +
> > +=09TP_STRUCT__entry(
> > +=09=09__string(filename,=09bprm->filename)
> > +=09=09__string(interp,=09interp)
> > +=09=09__string(handler,=09handler)
>=20
> Then here you would have:
>=20
> =09=09__string(handler, test_bit(MISC_FMT_BPF_BIT, &fmt->flags) ?
> =09=09=09=09 fmt->bpf_ops->name : "")
>=20
>=20
> > +=09=09__field(unsigned long,=09flags)
> > +=09=09__field(pid_t,=09=09pid)
> > +=09),
> > +
> > +=09TP_fast_assign(
> > +=09=09__assign_str(filename);
> > +=09=09__assign_str(interp);
> > +=09=09__assign_str(handler);
> > +=09=09__entry->flags =3D flags;
>=20
> and here:
>=20
> =09=09__entry->flags =3D flags & MISC_FMT_INVOCATION_FLAGS;
>=20
> -- Steve
>=20
>=20
> > +=09=09__entry->pid =3D current->pid;
> > +=09),
> > +
> > +=09TP_printk("pid=3D%d filename=3D%s interp=3D%s handler=3D%s flags=3D=
%#lx",
> > +=09=09  __entry->pid, __get_str(filename), __get_str(interp),
> > +=09=09  __get_str(handler), __entry->flags)
> > +);
> > +
> > +#endif /* _TRACE_BINFMT_MISC_H */
> > +
> > +/* This part must be outside protection */
> > +#include <trace/define_trace.h>
>=20
> 


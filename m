Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBC2E606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 18:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=yandex.com header.i=@yandex.com header.a=rsa-sha256 header.s=mail header.b=l84f8WVn
Received: by kanga.kvack.org (Postfix)
	id DEA606B064C; Thu, 29 Oct 2026 14:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9B116B064D; Thu, 29 Oct 2026 14:59:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB0AA6B064E; Thu, 29 Oct 2026 14:59:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A17856B064C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:59:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3E9891C3C00
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:59:00 +0000 (UTC)
X-FDA: 85376576040.12.2C230F6
Received: from forward400d.mail.yandex.net (forward400d.mail.yandex.net [178.154.239.223])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3D0B91C0004
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:58:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=yandex.com header.s=mail header.b=l84f8WVn;
	dmarc=pass (policy=none) header.from=yandex.com;
	spf=pass (imf18.hostedemail.com: domain of eneshan-karaca@yandex.com designates 178.154.239.223 as permitted sender) smtp.mailfrom=eneshan-karaca@yandex.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793300338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UfCr7SMBp2MWLVqMbTLms5eQnif5CMZeedqFoCGKq5U=;
	b=6GJurAz2iK408yYOdPEpqbh6m8Ae3RbekTzAxoGBJ2oUmU2fMJpcPfVgXyyQKnv8A/x1L+
	yHeGCOR9tfGp8Eiiv7jQz5wTtkSLXIni//Cbn6ZFtY2kOItBk5JlinnAAMmcPolp3jMkY3
	mwv1bONk0/MptnhIWEbsXe71rpT8cuU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=yandex.com header.s=mail header.b=l84f8WVn;
	dmarc=pass (policy=none) header.from=yandex.com;
	spf=pass (imf18.hostedemail.com: domain of eneshan-karaca@yandex.com designates 178.154.239.223 as permitted sender) smtp.mailfrom=eneshan-karaca@yandex.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793300338;
	b=lB/Y95CIzApO3u6l2pErrgxcwmORxF7DgGLn70yDzra5Q40fE0FQhsyXNXk+8hoG8qP8ub
	iuC5gsmfNbC4Lafxevsx1WuEacxiS9YQOvgEKVgpS+sZaUaIIUG4iqF4KvmftOuxHlDrwU
	nxzhRF9wfA4qgMroYv+ByBW1vTS4AbA=
Received: from mail-nwsmtp-smtp-production-main-89 (unknown [IPv6:2a02:6b8:c0c:1f29:0:640:95da:0])
	by forward400d.mail.yandex.net (postfix) with ESMTPS id 3F3DE81375;
	Thu, 29 Oct 2026 21:58:56 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-89 with ESMTPSA id nwoaPAGntOs0-SbXmwiTF;
	Thu, 29 Oct 2026 21:58:54 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.com; s=mail;
	t=1793300334; bh=UfCr7SMBp2MWLVqMbTLms5eQnif5CMZeedqFoCGKq5U=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=l84f8WVnf0WHjjRwv2BsHGMCY32Tq9OY+zOcb7WWDKUREDKTCRetEM9eTAiV5mTi6
	 y4CEzvWJLMwIbTQH3jg6QlToyw2wtJO9noRgrTD+bLSzO1Bmwp9m8cBzJpa+zdSjqX
	 KARciJ392A+xPz93jkzx1cwIBtcRQz9IlOo5UBdU=
From: Eneshan Karaca <Eneshan-Karaca@yandex.com>
To: brauner@kernel.org,
	kees@kernel.org,
	rostedt@goodmis.org
Cc: viro@zeniv.linux.org.uk,
	jack@suse.cz,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	jkoolstra@xs4all.nl,
	farid.m.zakaria@gmail.com,
	linux-fsdevel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH v2] binfmt_misc: add binfmt_misc_select tracepoint
Date: Thu, 29 Oct 2026 21:58:49 +0300
Message-ID: <20261029185849.8016-1-Eneshan-Karaca@yandex.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3D0B91C0004
X-Rspam-User: 
X-Stat-Signature: pg66q5d9uth65i73aqe1inysuyw7rfgc
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793300338-412526
X-HE-Meta: U2FsdGVkX19PdWZuy0gR5LMaIUyn+LZsjoGy6OpQ3E7DJpeaG7VWlDQ1DkkmYSIPDh/Gg9fFSErS+s9KlEI5r7Alztgra2veZ/o+56x6cPFNzBjAbX240RYfRyZzwnXNZHO3jUbVUZU8yxJJu7ZJM/dcUqjQhPBfrOFsjNehj122TueKvJTtHhNWOmQGas34WlYLftpQ9yLEBpFxy2kGuu3BiOdWwu8pSFhhz5ApzFPGgaB/9UhLcAezRPmUTCe8Ts9sSyQva31gsjfmQrMfQX2waLoFSBgEf8no/rmzxouslsJjWV+ni9DqjOn84v6hJh2ZplTLBEAtAQ9+cApoXLq0rcA22xwb+DpLweHySta0lA3mVneUSGVmcSOrSjK53acK6PKap5KsqS55Z10ilXChTVPkK7VkAQ0nkDTmfiyceEE58katIJdm3JIP0GvvklPY3+D/ytP1Bz32080TdvHvxXU6VTdtzSojkjjx8imF5+jBxBpQMW5hdYMi329wMjBmLJgRfL3syq2i4JGRMlSB6C+eMXfAmVHgW+EVtbXL4lOw8ICt1kCGAzsR1q+unV1wgrm6/uFy2vfM7GVP83Jq1aauE1Zzj76hI/8i4yoLRUnwrN8FyXVy9n59Ux+WZ8KMyXXZ0j6z5RrlSw32hdrZPeJ6HK+xn/yOGj9D74d3+4hBRJSv2jvYWfqf6E9zPjaYTzlp6GSOmhgrMsUViSMqn7Ix92YGEDfun+qyvzMa873BZ/f7CcdNgQil7J9rSEy3OmW+QnQwRZFXy7VAMTq7+doxsRb58I84Wu1zPIH6mQx6IvuycpbouoeYmynx26G4x2xoUNZUonMC85jNWjFtpotAB3Dl7V04T/OUp0Tk4B7jO3Xf+nEJQzFviJz83Zi9JbZRKHxhRhjCS4OTHCAT7i5Lq2yXJw6X12IWQGKLPvPRnRnStUTAUzqOOMqfMYh1BJrwwyiPT98IpQS
 prnYlNMm
 VG7WM1Hb+lb4MZLcM5K/n57TdRSSDMdnuZSkH1wX0rrdEK/bQSxVsH4jSw8P7PJO3ct/3cczxL8PzMe5lyKEtP4YGhaXymEI09aQ9oZ41VrJh/W4rqF/mHzxsSDZ+GCgOxNp4uBD4mSkCeK6lvLjY2cNN8eSObTB7vtfBZWgtM8djgYr4CPcGSRtGEl4wbLCtEXualYHQwY6FMQOVyxBbg87FpmOxL6o+9fdESPZ9GDRENrLsRwF4C3yHzukCzxdP4IaQzpqCNZtIxLLJVGNoncuejljIFiIXM4TX69aMSZFaiL9wExfC0wqUk2qsi1MpGoeGmC7MCj0Mpcf56MFPr5PN4WLCPK3ZcZNmaWzny/b7Tmj7RjpZ/W+rbXXMXErROVMl/dCH2SJBfNjqRLFxRyfZMxba4xW6kEYaZVQlJSC6XtiEIAXXT28WC/WcZt4xlgMkD9xnOKpTk2zRjGKBIAboGPRBvrdDpRkZB2dq0iLsu42wQPTVjqpXPCr5+J2OJcpthZaieUT52v7bBAFxrRTSBCH2QfEYaNOt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Eneshan Erdoğan Karaca <BoxStrikesTeam@proton.me>

A binfmt_misc entry can select an interpreter for an exec.  With a BPF
'B' handler, that selection can be made by a BPF struct_ops program.
The kernel commits the decision in bprm->interp and bprm->flags, but it
does not emit an event at the selection point.

Existing observers have to reconstruct the decision from
/proc/PID/exe, AT_EXECFD, AT_FLAGS, or /proc/PID/maps.  These sources
are mode-dependent: a transparent dispatch still reports the original
binary in /proc/PID/exe, and a short-lived process can exit before the
observer reads it.  A classic dispatch reports the interpreter, but
not which handler selected it or which invocation flags were used.

Add a tracepoint after the interpreter and the invocation flags are
selected.  The caller passes the matched entry and the raw flags; the
trace event resolves the handler name and masks the flags with
MISC_FMT_INVOCATION_FLAGS.  The event reports the binary filename, the
selected interpreter, the handler name, the invocation flags, and the
pid.

The tracepoint is observability only; it does not change exec
behavior.

Assisted-by: LLM
Signed-off-by: Eneshan Erdoğan Karaca <BoxStrikesTeam@proton.me>
---
v2:
 - Pass the matched entry and the raw flags to the tracepoint.
 - Resolve the handler name and mask the flags in the trace event.

Thanks to Steven Rostedt for the review and the claws-mail tip.  The
PoC and A/B results are available on request.

 fs/binfmt_misc.c                   |  9 +++++
 include/trace/events/binfmt_misc.h | 55 ++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)
 create mode 100644 include/trace/events/binfmt_misc.h

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 620da85..58a8283 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -118,6 +118,13 @@ struct binfmt_misc_entry {
        char buf[];                     /* register string, fields point in here */
 };

+/*
+ * The trace event needs struct binfmt_misc_entry and the MISC_FMT_*
+ * flags, so include it after they are defined.
+ */
+#define CREATE_TRACE_POINTS
+#include <trace/events/binfmt_misc.h>
+
 /*
  * Max length of the register string.  Determined by:
  *  - 7 delimiters
@@ -644,6 +651,8 @@ static int load_misc_binary(struct linux_binprm *bprm)

        flags = entry_invocation_flags(fmt, bprm);

+       trace_binfmt_misc_select(bprm, fmt, interpreter, flags);
+
        /* No argv is built for a staged argument to land in. */
        if ((flags & (MISC_FMT_LOADER | MISC_FMT_TRANSPARENT)) &&
            bprm->bpf_interp_arg)
diff --git a/include/trace/events/binfmt_misc.h b/include/trace/events/binfmt_misc.h
new file mode 100644
index 0000000..61a0de0
--- /dev/null
+++ b/include/trace/events/binfmt_misc.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Tracepoint for binfmt_misc binary type handler dispatch.
+ *
+ * Fires once for every exec a binfmt_misc entry matches, after the
+ * interpreter and the invocation flags have been selected. Unlike
+ * sched_process_exec (which reports bprm->filename) and /proc/PID/exe
+ * (which a transparent dispatch sets to the binary), this reports the
+ * interpreter that actually runs, so observers can see through a
+ * transparent dispatch.
+ */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM binfmt_misc
+
+#if !defined(_TRACE_BINFMT_MISC_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_BINFMT_MISC_H
+
+#include <linux/tracepoint.h>
+#include <linux/binfmts.h>
+#include <linux/binfmt_misc.h>
+#include <linux/bitops.h>
+
+TRACE_EVENT(binfmt_misc_select,
+
+       TP_PROTO(struct linux_binprm *bprm, const struct binfmt_misc_entry *fmt,
+                const char *interp, unsigned long flags),
+
+       TP_ARGS(bprm, fmt, interp, flags),
+
+       TP_STRUCT__entry(
+               __string(filename,      bprm->filename)
+               __string(interp,        interp)
+               __string(handler,       test_bit(MISC_FMT_BPF_BIT, &fmt->flags) ?
+                                       fmt->bpf_ops->name : "")
+               __field(unsigned long,  flags)
+               __field(pid_t,          pid)
+       ),
+
+       TP_fast_assign(
+               __assign_str(filename);
+               __assign_str(interp);
+               __assign_str(handler);
+               __entry->flags = flags & MISC_FMT_INVOCATION_FLAGS;
+               __entry->pid = current->pid;
+       ),
+
+       TP_printk("pid=%d filename=%s interp=%s handler=%s flags=%#lx",
+                 __entry->pid, __get_str(filename), __get_str(interp),
+                 __get_str(handler), __entry->flags)
+);
+
+#endif /* _TRACE_BINFMT_MISC_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
--
2.53.0


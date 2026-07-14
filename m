Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0951C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 19:58:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A63BD6B00CC; Tue, 14 Jul 2026 15:58:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ED586B00CD; Tue, 14 Jul 2026 15:58:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B61C6B00CF; Tue, 14 Jul 2026 15:58:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FD9C6B00CC
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:58:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D5BDBA0595
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:58:22 +0000 (UTC)
X-FDA: 84988444044.17.A9EC3AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2C1F71A0006
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:58:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NuMfvKUp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784059101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jdIn5AHlooZhD1sz2RSUUVQOfpEr8yJUCf5hCDznaDg=;
	b=Y26JbN2dvDGuojTe1418w7RFAexLaLcR42HQK150nGVTB6H/oIVI0ZynIxY0RQH5IRxhb6
	/wAM8XcEGIUIARv96VOrZNKbzDWP4fQEMUYLDzrBaKC6riN+5+/l3JPar5Hq9nCmpI6/K7
	5QpPyRaXucLGhq5227ckp32+KPLjdp0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NuMfvKUp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784059101;
	b=Y8WXMCLD6wm49RFpaKSqLVSywNfyW8MQJIX05Tmm+qtN/16abFu7XhbyYQjSPg1Ph+cw5W
	HfLBuChvz+nu+L1xewymdLtb208h4LdWfFhkkEkFwi6NGqEXOMG3HFXYyVxZShPQO0AEbF
	qJxugQ0VvNLEiZO0tSRyQ171NfInqZY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BC1A5601D9;
	Tue, 14 Jul 2026 19:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF5D1F00A3A;
	Tue, 14 Jul 2026 19:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784059100;
	bh=jdIn5AHlooZhD1sz2RSUUVQOfpEr8yJUCf5hCDznaDg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NuMfvKUpRuif84rJCICwZO+gLN3KedxW9zB0faIVPg6JjWBtyedJrUOBYm7GuopoW
	 XtzCd3CX2OmJKg3zL364QJkAjgon1Ah2Zky5sSKcAivPfqISQusif+v0DizphdJ81B
	 r2N7zAW+whc4EdC9fXb8w5Gj0I2OQdfLiQ9+zVdOh0voCKVIATzgjDqUyOqI4zcQq7
	 uoetOuoVZTA8oPAAlR0UEBRUJ0w/WFrf2BJi9InsAkYV3zkW2HYpW8zeSqxbeXWcfm
	 Kr00siciyJZpB42DzVI+MVUDHdga7MXkRqxr+zljHKbupKnWshc3vIEN1eY4z9MIFm
	 VP4jXGtHCzeGA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 14 Jul 2026 21:58:06 +0200
Subject: [PATCH v2 1/9] exec: stash bpf-selected interpreter state in
 struct linux_binprm
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-work-bpf-binfmt_misc-v2-1-57b7529c002c@kernel.org>
References: <20260714-work-bpf-binfmt_misc-v2-0-57b7529c002c@kernel.org>
In-Reply-To: <20260714-work-bpf-binfmt_misc-v2-0-57b7529c002c@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, bpf@vger.kernel.org, jannh@google.com, 
 mail@johnericson.me, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2508; i=brauner@kernel.org;
 h=from:subject:message-id; bh=6Azi4to0L64siZLaQPCVUQz4l3wCCHwGb9UfT2JXkmo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSFTbm8g0viyrzNx0Jn/92z6aK1TSvbdaPCLe2cxoouL
 9q2lPuXdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyErYGRYZ5km4jOHe5bvo5b
 50Z13sz9f1F8k+bx31L24Yb+jsEyfxj+Rxaqmic2V9U6B/88ZfZS+P9O/R3POzlv2Th7xt6dlLu
 dAwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 2C1F71A0006
X-Stat-Signature: nmyqxbwcaq7e1nedwsfgs8etirehixio
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784059101-780867
X-HE-Meta: U2FsdGVkX1+6TwXNO1PNC/5TXZ4vJSHR5E948VAeKdf7cn1+K7oclKrAyr9+2Af6qe/gJISO5GRHS7HQHSRT0kv38zh54eRnNOeoWtUALdIjowDChSvoONm+CB80oA/0YgNQS10OiEhsnovdNa2fPFbEAcQoHVdHyjtzvpKg4e6T80yxOVEqMkAVenxsZb2ca42gBrlCQdH/ubm7CJso614911JL10hXYtlU7ykLL0mWiynBPgGV5xC4g60xS9CQQoYKwcqwOm9rfposOWIJh9ayRdpGkRtNRhKLv1g+BVmxmSnybWcXy3gfxJ5QO6JrFvsXcraIILYcKJcvBhzHNKpB0p/gHm2lH1DfOBm0DesxjIRIRj/W+juxrKrypYkOjGNIa2U/u4Jxybx9qkkA88w5l6+xWvQFAHTt/vkgRKULwvgu2WfghENRMN0hKxtNfmTp+aTuU/c+JiyKVCKVZq8e0WSxuSPfXiM8tU+UJNNlf2qxRwLTqDzMUGUGSmofTyLRLpEThGvqFZrAiTCdpLp7aZRmilyVro8bKSOINVPmPhP6biDDGbf1S2qGg6kCnv55Xm+QfJXJqCmPwQLxGQ9j0pz9uIgnIyaasmIopWB/V+ycE8NJfTYg6hSMHB43QKlTG7cIJjJc5uFxPIJLlgKLyoxHlE2VVaC4OdLHPCQziXmRyjJnqbnDPlEO3NJY/qlrRm/IGEbJoYWxhmb0f3oLtVrvlAsuzc1ZtbFLVb3t9Eg1uDed3tIqu3ZeKxSmJc7x+qdWEwCF6ydyvZ76GfmbLkcuc43nAxD9ZF0Asf13Os7tj6iqpgSBw/zwQMjpRqMC8HNIBnUCg/eZYgeqLIZecSrOQxwdsrMannkhbvoWxq9us178dR4JsGP2zyirTgu9wmFlcbDRpKwGWX340Mq5eI6AhLc1KNEs2dYkZ/sUH71hWoPmoEJqcvpJFf5aclCTmOhQEu5Uf7Pdl/3
 VCwCuJEo
 Cj4L7G38oUYsyZnTT96kDIMtD5is7g2QGOxfJENoND9mOPGV+/kOkD/jyPcFLJ8p/mM2ho5s3bND2MvCHmw6TVqyHB/dBY5DcMVNnb/KnWDpemEGqm5oCDu2F3m9alxiF7FMOqMf+aBZ6rFeQqd7goWB9l5vaSW68Bsiryyg6UvUBqoOjvQVuKHO/3zl7CJLWa3f4D2Rt1T6iuj4wbIImpGlgKl2uiF8L0WTu9jgdCUB8mFfBgkLYISh59VTHuamlqJqWbGwmfEgrxhUSE3ZMrnJjn8r4tPxVgma5Is9chalWHTu8SELxe7VmOP7Fc+IogEG9CCg9DrR9ThGSqtLrrTMLLDuUNJsMV0dDf5KbVmyHbBc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The upcoming bpf-backed binfmt_misc handlers decide how a binary is run
programmatically at exec time: the interpreter itself, an optional
single argument to pass to it, and the invocation flags that a static
binfmt_misc entry fixes at registration time. The selection runs before
load_misc_binary() has copied the binary path from bprm->interp into
the argument vector, so the selecting program cannot go through
bprm_change_interp() directly without clobbering argv[1].

Stage the selected state in the bprm instead, grouped in struct
binfmt_misc_bpf and embedded anonymously in struct linux_binprm so the
bprm->bpf_* accesses stay direct. The bprm is exclusively owned by the
task doing the exec so no synchronization is needed. The consumers
free and clear the fields once the exec attempt that set them is
finished; free_bprm() covers all error paths.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exec.c               | 2 ++
 include/linux/binfmts.h | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/fs/exec.c b/fs/exec.c
index b92fe7db176c..c698aabe9abd 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1418,6 +1418,8 @@ static void free_bprm(struct linux_binprm *bprm)
 	/* If a binfmt changed the interp, free it. */
 	if (bprm->interp != bprm->filename)
 		kfree(bprm->interp);
+	kfree(bprm->bpf_interp);
+	kfree(bprm->bpf_interp_arg);
 	kfree(bprm->fdpath);
 	kfree(bprm);
 }
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 7e7333b7bb0f..03e1794b5cbb 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -12,6 +12,13 @@ struct coredump_params;
 
 #define CORENAME_MAX_SIZE 128
 
+/* Interpreter selection staged by a bpf binfmt_misc handler. */
+struct binfmt_misc_bpf {
+	const char *bpf_interp;		/* interpreter selected by a bpf handler */
+	const char *bpf_interp_arg;	/* interpreter argument from a bpf handler */
+	u64 bpf_flags;			/* enum bpf_binprm_flags from a bpf handler */
+};
+
 /*
  * This structure is used to hold the arguments that are used when loading binaries.
  */
@@ -65,6 +72,7 @@ struct linux_binprm {
 				   of the time same as filename, but could be
 				   different for binfmt_{misc,script} */
 	const char *fdpath;	/* generated filename for execveat */
+	struct binfmt_misc_bpf;	/* bpf handler interpreter selection */
 	unsigned interp_flags;
 	int execfd;		/* File descriptor of the executable */
 	unsigned long exec;

-- 
2.53.0



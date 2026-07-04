Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A7C3C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 21:14:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7B696B00A3; Sat,  4 Jul 2026 17:14:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2B886B00A4; Sat,  4 Jul 2026 17:14:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1A3E6B00A5; Sat,  4 Jul 2026 17:14:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DCA06B00A3
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 17:14:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CA1B01C800E
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 21:14:18 +0000 (UTC)
X-FDA: 84952347396.01.5BAD41B
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0705340003
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 21:14:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GXOX0Qfv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783199657;
	b=v1+yoAxcEfgWsXYExXQsULa5Cg7oC0Y/BJHDAX2DuJJMFeOH7YpM8iwXkBy1gxWZUsoCKi
	uS3BlMGlSUROM/P1P+3ZFUaLp/il+4oU0Ll2SVtSppm4ni/kESZs0rV+qUb58kTzeUNhLw
	bV/0Ou9aDmAClbSKLgsFMG6QPkXf7s8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GXOX0Qfv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783199657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wNObvvCR77mS9Inyq/bIvC7lHlQKSaAhco2QLbfN6gc=;
	b=HuRcYM0nKc76YVo1Dv16Kkest9RqJh5VzF/QKOhzzQuFDz1GSaAXDiZgDVmLbYLdopbDKB
	TpQClI82J2CecjDV2wmx33LA/+NBYPQ5SijUcEB+XOYw4f3nLqFlYePHNg3b7nx5VlddJh
	dkEp+L9p76HNlE6iq9yLiutIOZfky/Y=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c8fee9f63d5so863620a12.0
        for <linux-mm@kvack.org>; Sat, 04 Jul 2026 14:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783199656; x=1783804456; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wNObvvCR77mS9Inyq/bIvC7lHlQKSaAhco2QLbfN6gc=;
        b=GXOX0QfvDIG+rZb4NGR/w+GlDucUS2oor10Tcvux7YCm0L8CiqzeAvyS37Jm0tlFwN
         LejCUZzQWps4O99PHf2fTU6bzPJBpL2D81zdLmlzmtWNwQvnaqKeg2dFT0UWe1B1nyD7
         QNUSNFirtcPIWWec0UY3vFu2LJAfQUbCICJulhNxLpUnwj/idXYXosp+RfTFkpMjb1Qu
         IP73LWb3Px+OSkBnsyRxvChqQEtHLcmMw9oBlzAthryvRnry3SPNp3e7nrpYdp1ZA/8v
         fpgYKheE3sFcImyK+OPhGncp+MUrJZ01V29AtnXJFaPrfwOHjjKm7Y3HH8by3cAPFdFl
         5moQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783199656; x=1783804456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wNObvvCR77mS9Inyq/bIvC7lHlQKSaAhco2QLbfN6gc=;
        b=ittXXpPDn/RIVZWA9y2oxHq6sTplQ7YeHmAQKPpLxn52VVfgod+QKJ2KI4Q1I+LESK
         dJCZIcmylW6vHfsx/2KV+LFWT3fOZCXj3hsHu+67eeI7/PWC4FfvENV9v4ODQ2N0h5Z0
         t2jOmllXYGReqUmml7fTVCFSzZhymS2F/bC06tzKP6eB9SZFt6/f91Bem2lfgjnZa2mw
         8e0LFWRIJTzMs8hFEZVEZOJaFOj2qz0EJoicVrX3XCiuMhGpRezDyG3IfWrMynhVY9S/
         NugeHr+lp3HgVYjrUbMPUe4wAq0z7EkxuObvnz3cRk2YvurACnr6T+sfQdhZ/7aDeT+i
         +FqQ==
X-Forwarded-Encrypted: i=1; AFNElJ9FrqVwc4nzA8e238qVVRCYUjYe6gbqz2eyM3bB5rX5y3Am2g8J2A+sP3EnNW1a0lCeowFT6pXnvw==@kvack.org
X-Gm-Message-State: AOJu0YxCMl1ynzpM6Ahffd/qit/5mE25ovEQlpcj23OFiwfGgh3YWx3Z
	Ebaenot+VUb9ywrN/qAIFHmAYY0L7c2uvNreXjgXn+VRc53R0awXqqO6
X-Gm-Gg: AfdE7cn2L1Alwu5qR2v2eNUyeLhNASFE90LrzrwGBubeuV8wiDPdwFHpwhkRzPRZ1t7
	IKvprVezxv0YuTjuf2Sg2JPlTM6ESsVHYKQBDLqN6jNhF83cSAGB5ZWE/a5CAedRrPB4idLd/4b
	YXe6qFvyilggjn46D11bVOBQKEpnSDISwCllbCOwKri7i7DBpLm89af7JrTmPJpFUkiP9qrW5gw
	f1r4yWhnT6d3ePXkiVdQ6orIRbSLSb3/Z6VL72DWIn5QTQPrA97SKSy5Nb703pDVBVZRtDBdXmx
	aJ1DVdYS+KIS/aJPp6OseGE+UZT86uIUXkqjME86k+VnkJ0umF6Qg6FFPHpQnxI6w6GCWD4M2uW
	wmu00GbpZY8luHcIgRs48ZoOFf+rqwxrmpP307AoyTKYGuAqO08WbpjMerr/HuxvvEeLtn6cm+d
	mN1s7NXbA8qFfUZgkH11VtSmsrQAE=
X-Received: by 2002:a05:6a21:a91:b0:3bf:a698:ce4d with SMTP id adf61e73a8af0-3c03e5ea69dmr4576055637.54.1783199655731;
        Sat, 04 Jul 2026 14:14:15 -0700 (PDT)
Received: from nyx.tail25a6.ts.net ([98.35.8.117])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f38ee1333sm18515569eec.24.2026.07.04.14.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2026 14:14:15 -0700 (PDT)
From: Farid Zakaria <farid.m.zakaria@gmail.com>
To: brauner@kernel.org
Cc: david.laight.linux@gmail.com,
	farid.m.zakaria@gmail.com,
	jack@suse.cz,
	jannh@google.com,
	kees@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	mail@johnericson.me,
	shuah@kernel.org,
	viro@zeniv.linux.org.uk,
	Gemini <assistant@google.com>
Subject: [RFC PATCH] fs: binfmt_misc: introduce eBPF-based matching and interpreter selection
Date: Sat,  4 Jul 2026 14:14:09 -0700
Message-ID: <20260704211409.1978485-1-farid.m.zakaria@gmail.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260704-kochkunst-hauswand-blass-7226e9443a9f@brauner>
References: <20260704-kochkunst-hauswand-blass-7226e9443a9f@brauner>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0705340003
X-Rspam-User: 
X-Stat-Signature: 3o7cx7u7scwug6y8nn83uda8paadokiu
X-Rspamd-Server: rspam03
X-HE-Tag: 1783199656-436347
X-HE-Meta: U2FsdGVkX18QiezUf9kK5qC9GsstNcGqjzufJOrRZFuEfX8n39zy08hw5rNvgCnJ4XwsdrRnau9p4pyB/YnLLMScLNWDRnlX2CPvzSzg3EJ8gDR7ncTOJVqpQDYuoieLL8sW9YEfPLHLuXasRn+/hkw0lYjaQ7FdoSo7cxwy1rIl750nAT15FymWpB8xLTbqgNcBI4/plrgv82X6SfX6rTUErxmsUfzOXxzgr7fo1Uasww5GFUgBolZxOgWCWLD6zm3PpI7pFDtqwsfswGXKK5XNg9ipXCd79pIEJsV6857zv1cWpadnrRdMacMyAYSk7sz2ytfMzevGSziNNCaLS4g7bDtz0vh+3OfacAm0mKr6cu7hwfqe6O8/totcoloTLyi/YRV7o9H6yjMm4dCC5IWzuaMrZmKCFmyOC9KntnoDG7nLfZSC1lKt8FzJDBSKbZD65fnLz4yXnhbnf4DXk1zvXJLHbHbFPnj+5sNyWJdciJ700+ZJlx01Y4REDAiFLREHz5X4K5nh9x4qFz2rB8cn+ymXTHvEI+Erbtkfzl1iTwqrLXq61W5Jzv2iCA4KEL/t8QoelDkzIqPOpxygpdydfXXZ0t2lTpqJm1cA6ityTrBpU+pO0R63bYAP77cMXqWSO+TNWZc7LT4YPvEpTGE90LpWeLhSZKji3sdqX8XOwn1uJvMeZAtSNp5DoqLp8aAI3jpJBCTOeE0YDUATj8jhVBeWJWJvZWX4n2bQW2Pz7ntWRVmJnMW+GV3QfMIu7+3FZ9VdYJMwOsg7/t/zBfyvQwWzCXyGHvA4RSht+N49a+fmqC12xTrPB17oPz35T9SFpp5aEV/jkSYos2yyLYUe5eED1BjHBQ/i/aSsGemYiMrbm5almw6IQ/BUAMzDyS629N1VwX6sboOtFN6uwSMzD/ICqv1scE4koluckocbX1jv9Ms4iZgPr2shLnZ1xKIKu+o6kxdmYp/81Iz
 L5pnTl5u
 RHD0LC8+hyVEOYTy6zLQ09Et5rqFnGyBz4X50fbOJXt1yrrL7eA/HcBl8vCamyfVx1b+aIaQ7b57wFhq3QZgF1D7rGHDaBSnQ7q/0lwTj0ITMu1BCG6yB5IIyWo+aM1aXFx2Rn02Y+6Gfg4qxp9M9epehawLeaRcDwl3aPqgksUuIPUXBlZIsIJPmgvrWSjy5hkfGuzXa+BZhdPsa1SQE1QK2z7HiBVQdvvrvSD49pjxrTVWas8j0M2tQ0oTCtAnqu+f+8FOXC5OlJcLA8q6IwBDGTzyonwmw80Bcs9FzxbL0wVxbSyFgH2XtgdEoQ6f8lIon5fxW+66x+bCmURgg8sBA5bDaPGP3paNf6EM8L55Egrc6cQTBVy6VrJLD/eKDT+7NeJvQOfcEp3zKqI/W45JMAR2PiHVAqJBsy1TKGu1jWYBhJYofzmYWIZbPg85ERtP5wC10Kqdb51pfU/Es0DLgzzCL1ge+Qi6OPpLdKFyVyRWB7e7U9T1FbGw/f9nEPc065r34EG+76zf1TAVzOh32WhGeERYmHr9NTMsPS12mNVxc2eBZgZ8mg1i7Van5A582PzYcZ3towiDTz3rVNmbYwMa18hHAaid2S/uPWMeAsbg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Historically binfmt_misc has only matched binaries by magic bytes or file
extension, and always redirects a match to a fixed interpreter recorded in
the registration. This is insufficient when the match requires parsing the
binary header (e.g. inspecting ELF program headers) or when the interpreter
must be computed per-binary rather than hard-coded.

Introduce a new 'B' (BPF) handler type. A pinned SOCKET_FILTER program is
registered in place of the magic/mask, and no interpreter is recorded:

  echo ':name:B:<bpf_pinned_path>::::<flags>' \
      > /proc/sys/fs/binfmt_misc/register

When a binary is executed, binfmt_misc runs the program with the
BINPRM_BUF_SIZE file-header buffer as context. Returning 1 selects the
handler; returning 0 falls through to the remaining handlers.

Unlike magic/extension handlers, a 'B' handler carries no interpreter of its
own: the program chooses it via a new helper, bpf_binprm_set_interp(). This
lets the program compute the interpreter path however it sees fit (for example
relative to the binary). A 'B' handler is therefore a strict superset of the
existing magic handlers -- any of them can be expressed as a program that
matches on the header and sets a fixed interpreter.

bpf_binprm_set_interp() is exposed to SOCKET_FILTER programs and stashes the
chosen path on a per-CPU area that binfmt_misc reads back immediately after
the run under migrate_disable(); only a match that set an interpreter
allocates.

Assisted-by: Gemini <assistant@google.com>
Signed-off-by: Farid Zakaria <farid.m.zakaria@gmail.com>
---

Hey Christian,

Thank you for the suggestion and discussion on the mailing list. I took a stab
at your idea of driving binfmt_misc interpreter selection from a BPF program
(hopefully this is what you had in mind). The other approach was also to use a
static interpreter during registration but this current approach feels right.

This prototype demonstrates binfmt_misc interpreter selection from a BPF program
so the interpreter can be *computed* (e.g. $ORIGIN-relative) rather than recorded
statically. It replaces my earlier "pluggable ELF interpreter loader registry" RFC.

As this is a first draft, a few things you probably will have notes on.
I tried my best but I am a novice here so I welcome your feedback.

 * The prototype uses socket filter type. This seemed the easiest to wire up to
   start. My guess is it should be a dedicated type (eg. BPF_PROG_TYPE_BINFMT).
 * bpf_binprm_set_interp() is a "classic helper", but that list
   is frozen in favour of kfuncs. A kfunc needs BTF and can't be called from
   the raw-bytecode selftest I wrote.
 * The program only gets bprm->buf today.
   That is enough to match on the ELF header but not to compute an
   $ORIGIN-relative path from the binary's location, which needs bprm->filename
 * I have some selftests that exercises match + program-chosen interpreter. I don't
   include them here yet since it seems unnecessary when discussing the idea.

To demo the functionality, I thought it would be neat to see how this is a superset
and can replace all the qemu binfmt usage [1].

  $ ./hello-aarch64;
  -bash: /etc/binfmt-demo/hello-aarch64: cannot execute binary file: Exec format error

  $ bpftool prog load filter.bpf.o /sys/fs/bpf/qemu type socket
  $ echo ':qemu-bpf:B:/sys/fs/bpf/qemu::::P' > /proc/sys/fs/binfmt_misc/register

  $ ./hello-aarch64
  AARCH64_RAN_VIA_QEMU

All the per-CPU guards were recommended by AI.

[1] https://gist.github.com/fzakaria/bef27d2e21b0e36ffccda1cbf417b636

 fs/binfmt_misc.c         | 181 ++++++++++++++++++++++++++++++++++++---
 include/linux/bpf.h      |   1 +
 include/uapi/linux/bpf.h |   1 +
 net/core/filter.c        |   8 ++
 4 files changed, 180 insertions(+), 11 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 84349fcb9..cf6698d59 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -29,6 +29,11 @@
 #include <linux/fs.h>
 #include <linux/uaccess.h>
 
+#ifdef CONFIG_BPF_SYSCALL
+#include <linux/bpf.h>
+#include <linux/filter.h>
+#endif
+
 #include "internal.h"
 
 #ifdef DEBUG
@@ -41,12 +46,14 @@ enum {
 	VERBOSE_STATUS = 1 /* make it zero to save 400 bytes kernel memory */
 };
 
-enum {Enabled, Magic};
+enum {Enabled, Magic, Bpf};
 #define MISC_FMT_PRESERVE_ARGV0 (1UL << 31)
 #define MISC_FMT_OPEN_BINARY (1UL << 30)
 #define MISC_FMT_CREDENTIALS (1UL << 29)
 #define MISC_FMT_OPEN_FILE (1UL << 28)
 
+struct bpf_prog;
+
 typedef struct {
 	struct list_head list;
 	unsigned long flags;		/* type, status, etc. */
@@ -59,6 +66,9 @@ typedef struct {
 	struct dentry *dentry;
 	struct file *interp_file;
 	refcount_t users;		/* sync removal with load_misc_binary() */
+#ifdef CONFIG_BPF_SYSCALL
+	struct bpf_prog *bpf_prog;
+#endif
 } Node;
 
 static struct file_system_type bm_fs_type;
@@ -78,10 +88,51 @@ static struct file_system_type bm_fs_type;
  */
 #define MAX_REGISTER_LENGTH 1920
 
+#ifdef CONFIG_BPF_SYSCALL
+struct binfmt_bpf_interp {
+	char path[PATH_MAX];
+	int len;	/* < 0 if the current program set no interpreter */
+};
+static DEFINE_PER_CPU(struct binfmt_bpf_interp, binfmt_bpf_interp);
+
+/*
+ * bpf_binprm_set_interp - let a binfmt_misc 'B' program pick the interpreter.
+ * @path: interpreter path, in BPF-accessible memory
+ * @len:  number of bytes in @path
+ *
+ * The program computes the interpreter path however it sees fit (e.g. relative
+ * to the binary). The path is stashed on a per-CPU area that binfmt_misc reads
+ * back immediately after running the program under migrate_disable(), so it
+ * cannot race with another CPU.
+ */
+BPF_CALL_2(bpf_binprm_set_interp, const char *, path, u32, len)
+{
+	struct binfmt_bpf_interp *sc = this_cpu_ptr(&binfmt_bpf_interp);
+
+	if (len == 0 || len >= PATH_MAX)
+		return -EINVAL;
+	/* @path is @len bytes of BPF memory and is not NUL-terminated. */
+	memcpy(sc->path, path, len);
+	sc->path[len] = '\0';
+	sc->len = len;
+	return 0;
+}
+
+const struct bpf_func_proto bpf_binprm_set_interp_proto = {
+	.func		= bpf_binprm_set_interp,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
+	.arg2_type	= ARG_CONST_SIZE,
+};
+#endif /* CONFIG_BPF_SYSCALL */
+
 /**
  * search_binfmt_handler - search for a binary handler for @bprm
  * @misc: handle to binfmt_misc instance
  * @bprm: binary for which we are looking for a handler
+ * @bpf_interp: receives a kmalloc'd interpreter path if a 'B' program chooses
+ *              one via bpf_binprm_set_interp(); the caller must kfree() it
  *
  * Search for a binary type handler for @bprm in the list of registered binary
  * type handlers.
@@ -89,7 +140,8 @@ static struct file_system_type bm_fs_type;
  * Return: binary type list entry on success, NULL on failure
  */
 static Node *search_binfmt_handler(struct binfmt_misc *misc,
-				   struct linux_binprm *bprm)
+				   struct linux_binprm *bprm,
+				   char **bpf_interp)
 {
 	char *p = strrchr(bprm->interp, '.');
 	Node *e;
@@ -103,6 +155,37 @@ static Node *search_binfmt_handler(struct binfmt_misc *misc,
 		if (!test_bit(Enabled, &e->flags))
 			continue;
 
+		/* Do matching based on BPF if applicable. */
+		if (test_bit(Bpf, &e->flags)) {
+#ifdef CONFIG_BPF_SYSCALL
+			if (e->bpf_prog) {
+				struct binfmt_bpf_interp *sc;
+				u32 ret;
+
+				migrate_disable();
+				sc = this_cpu_ptr(&binfmt_bpf_interp);
+				sc->len = -1;
+
+				rcu_read_lock();
+				ret = bpf_prog_run(e->bpf_prog, bprm->buf);
+				rcu_read_unlock();
+
+				if (ret == 1 && sc->len > 0)
+					*bpf_interp = kmemdup_nul(sc->path,
+								  sc->len,
+								  GFP_ATOMIC);
+				migrate_enable();
+
+				pr_debug("binfmt_misc: ran BPF program for %s, ret = %u\n",
+					 bprm->filename, ret);
+
+				if (ret == 1)
+					return e;
+			}
+#endif
+			continue;
+		}
+
 		/* Do matching based on extension if applicable. */
 		if (!test_bit(Magic, &e->flags)) {
 			if (p && !strcmp(e->magic, p + 1))
@@ -139,12 +222,13 @@ static Node *search_binfmt_handler(struct binfmt_misc *misc,
  * Return: binary type list entry on success, NULL on failure
  */
 static Node *get_binfmt_handler(struct binfmt_misc *misc,
-				struct linux_binprm *bprm)
+				struct linux_binprm *bprm,
+				char **bpf_interp)
 {
 	Node *e;
 
 	read_lock(&misc->entries_lock);
-	e = search_binfmt_handler(misc, bprm);
+	e = search_binfmt_handler(misc, bprm, bpf_interp);
 	if (e)
 		refcount_inc(&e->users);
 	read_unlock(&misc->entries_lock);
@@ -164,6 +248,10 @@ static void put_binfmt_handler(Node *e)
 	if (refcount_dec_and_test(&e->users)) {
 		if (e->flags & MISC_FMT_OPEN_FILE)
 			filp_close(e->interp_file, NULL);
+#ifdef CONFIG_BPF_SYSCALL
+		if (test_bit(Bpf, &e->flags) && e->bpf_prog)
+			bpf_prog_put(e->bpf_prog);
+#endif
 		kfree(e);
 	}
 }
@@ -206,15 +294,27 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	struct file *interp_file = NULL;
 	int retval = -ENOEXEC;
 	struct binfmt_misc *misc;
+	char *bpf_interp __free(kfree) = NULL;
+	const char *interpreter;
 
 	misc = load_binfmt_misc();
 	if (!misc->enabled)
 		return retval;
 
-	fmt = get_binfmt_handler(misc, bprm);
+	fmt = get_binfmt_handler(misc, bprm, &bpf_interp);
 	if (!fmt)
 		return retval;
 
+	/*
+	 * A 'B' (BPF) handler carries no interpreter of its own; the program
+	 * chooses it via bpf_binprm_set_interp(). Other handlers use the
+	 * interpreter recorded at registration.
+	 */
+	interpreter = bpf_interp ? bpf_interp : fmt->interpreter;
+	retval = -ENOEXEC;
+	if (!interpreter[0])
+		goto ret;
+
 	/* Need to be able to load the file after exec */
 	retval = -ENOENT;
 	if (bprm->interp_flags & BINPRM_FLAGS_PATH_INACCESSIBLE)
@@ -238,22 +338,27 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	bprm->argc++;
 
 	/* add the interp as argv[0] */
-	retval = copy_string_kernel(fmt->interpreter, bprm);
+	retval = copy_string_kernel(interpreter, bprm);
 	if (retval < 0)
 		goto ret;
 	bprm->argc++;
 
 	/* Update interp in case binfmt_script needs it. */
-	retval = bprm_change_interp(fmt->interpreter, bprm);
+	retval = bprm_change_interp(interpreter, bprm);
 	if (retval < 0)
 		goto ret;
 
-	if (fmt->flags & MISC_FMT_OPEN_FILE) {
+	/*
+	 * The pre-opened interp_file (MISC_FMT_OPEN_FILE / 'F' flag) only
+	 * applies to the statically registered interpreter; a program-supplied
+	 * path is opened here.
+	 */
+	if ((fmt->flags & MISC_FMT_OPEN_FILE) && !bpf_interp) {
 		interp_file = file_clone_open(fmt->interp_file);
 		if (!IS_ERR(interp_file))
 			deny_write_access(interp_file);
 	} else {
-		interp_file = open_exec(fmt->interpreter);
+		interp_file = open_exec(interpreter);
 	}
 	retval = PTR_ERR(interp_file);
 	if (IS_ERR(interp_file))
@@ -404,6 +509,10 @@ static Node *create_entry(const char __user *buffer, size_t count)
 		pr_debug("register: type: M (magic)\n");
 		e->flags = (1 << Enabled) | (1 << Magic);
 		break;
+	case 'B':
+		pr_debug("register: type: B (bpf)\n");
+		e->flags = (1 << Enabled) | (1 << Bpf);
+		break;
 	default:
 		goto einval;
 	}
@@ -492,6 +601,45 @@ static Node *create_entry(const char __user *buffer, size_t count)
 				}
 			}
 		}
+	} else if (test_bit(Bpf, &e->flags)) {
+		/* Handle the 'B' (BPF) format. */
+		char *s;
+
+		/* The offset field actually holds the pinned BPF program path */
+		s = strchr(p, del);
+		if (!s)
+			goto einval;
+		*s++ = '\0';
+		e->magic = p; /* Keep path in e->magic */
+		pr_debug("register: bpf program path: %s\n", e->magic);
+
+#ifdef CONFIG_BPF_SYSCALL
+		e->bpf_prog = bpf_prog_get_type_path(e->magic, BPF_PROG_TYPE_SOCKET_FILTER);
+		if (IS_ERR(e->bpf_prog)) {
+			err = PTR_ERR(e->bpf_prog);
+			e->bpf_prog = NULL;
+			kfree(e);
+			return ERR_PTR(err);
+		}
+#else
+		goto einval;
+#endif
+
+		p = s;
+
+		/* The magic field is unused, must be empty */
+		s = strchr(p, del);
+		if (!s || p != s)
+			goto einval;
+		*s++ = '\0';
+		p = s;
+
+		/* The mask field is unused, must be empty */
+		s = strchr(p, del);
+		if (!s || p != s)
+			goto einval;
+		*s++ = '\0';
+		p = s;
 	} else {
 		/* Handle the 'E' (extension) format. */
 
@@ -524,8 +672,17 @@ static Node *create_entry(const char __user *buffer, size_t count)
 	if (!p)
 		goto einval;
 	*p++ = '\0';
-	if (!e->interpreter[0])
+	if (test_bit(Bpf, &e->flags)) {
+		/*
+		 * A 'B' (BPF) handler carries no interpreter of its own; the
+		 * program picks it via bpf_binprm_set_interp(). Reject a
+		 * statically registered one.
+		 */
+		if (e->interpreter[0])
+			goto einval;
+	} else if (!e->interpreter[0]) {
 		goto einval;
+	}
 	pr_debug("register: interpreter: {%s}\n", e->interpreter);
 
 	/* Parse the 'flags' field. */
@@ -602,7 +759,9 @@ static void entry_status(Node *e, char *page)
 		*dp++ = 'F';
 	*dp++ = '\n';
 
-	if (!test_bit(Magic, &e->flags)) {
+	if (test_bit(Bpf, &e->flags)) {
+		sprintf(dp, "bpf %s\n", e->magic);
+	} else if (!test_bit(Magic, &e->flags)) {
 		sprintf(dp, "extension .%s\n", e->magic);
 	} else {
 		dp += sprintf(dp, "offset %i\nmagic ", e->offset);
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 7719f6528..3aef44b69 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -3874,6 +3874,7 @@ extern const struct bpf_func_proto bpf_ktime_get_ns_proto;
 extern const struct bpf_func_proto bpf_ktime_get_boot_ns_proto;
 extern const struct bpf_func_proto bpf_ktime_get_tai_ns_proto;
 extern const struct bpf_func_proto bpf_get_current_pid_tgid_proto;
+extern const struct bpf_func_proto bpf_binprm_set_interp_proto;
 extern const struct bpf_func_proto bpf_get_current_uid_gid_proto;
 extern const struct bpf_func_proto bpf_get_current_comm_proto;
 extern const struct bpf_func_proto bpf_get_stackid_proto;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 89b36de5f..dce155c5b 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -6142,6 +6142,7 @@ union bpf_attr {
 	FN(user_ringbuf_drain, 209, ##ctx)		\
 	FN(cgrp_storage_get, 210, ##ctx)		\
 	FN(cgrp_storage_delete, 211, ##ctx)		\
+	FN(binprm_set_interp, 212, ##ctx)		\
 	/* This helper list is effectively frozen. If you are trying to	\
 	 * add a new helper, you should add a kfunc instead which has	\
 	 * less stability guarantees. See Documentation/bpf/kfuncs.rst	\
diff --git a/net/core/filter.c b/net/core/filter.c
index 2e96b4b84..187692a4a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8397,6 +8397,14 @@ sk_filter_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_socket_uid_proto;
 	case BPF_FUNC_perf_event_output:
 		return &bpf_skb_event_output_proto;
+#if IS_BUILTIN(CONFIG_BINFMT_MISC)
+	case BPF_FUNC_binprm_set_interp:
+		/*
+		 * binfmt_misc reuses SOCKET_FILTER programs to select an
+		 * interpreter; expose the helper that lets them set it.
+		 */
+		return &bpf_binprm_set_interp_proto;
+#endif
 	default:
 		return bpf_sk_base_func_proto(func_id, prog);
 	}
-- 
2.51.2



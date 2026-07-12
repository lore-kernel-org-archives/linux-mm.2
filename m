Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6703AC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 04:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8F446B0095; Sun, 12 Jul 2026 00:08:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC8916B0096; Sun, 12 Jul 2026 00:08:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A690F6B009B; Sun, 12 Jul 2026 00:08:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 77B5B6B0095
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 00:08:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 07EF740844
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 04:08:56 +0000 (UTC)
X-FDA: 84978793872.08.1C2E7FE
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3995AC0004
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 04:08:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nA7y57Dj;
	spf=pass (imf22.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783829334;
	b=Hu59ZQYtOLIJrCYtRV7wytX49z5xpWu6c24QI/XYQ1OquT+wCAWUhN6+yYAJE7W/78tDUG
	trhBEw8gQI2DErcsinA6IG7ysMpYVHP1qGF/ihMKZ/vpvPOYe32ITMbo0yHgXIL6X4Lf/x
	ee2DmYeRU06CmHkgyz3WuFYjrIJNNkE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nA7y57Dj;
	spf=pass (imf22.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783829334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nSAL3gg/+UGNm6w8OO6Kj1lCK77Tqi4uiJZac+rrH54=;
	b=OP0eP9ZBl/4qVO+82YTBNkwxKD/tiTb1AqrG+oP8lrCJp9k9SCKYB6RLauM4yNn7X5SIk4
	hZYMWthRwEGr/tTv6gDy5oqFsUTpkofYE3DpJlhQkwPX5nMMyR1y0S9+oCCSrVsOo43qzj
	MFMCrWAxVJG51NOzrwYHmSZEDcJ3kp4=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-381216921aaso2379342a91.1
        for <linux-mm@kvack.org>; Sat, 11 Jul 2026 21:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783829333; x=1784434133; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nSAL3gg/+UGNm6w8OO6Kj1lCK77Tqi4uiJZac+rrH54=;
        b=nA7y57Dj0u4sJ5iAe57OisBL6Ih7jqVf22fh5GO/Lh9AVyyCBJP0bwzuGktXbe6jnf
         QbjS9aPlXNEWyRy9AcaNzegWkJ3Eynr1ZxZSVVb8Z4doai0IYQWc0TOCCfmkRbgA1QhS
         +s4fJqxS/1uvCvat34wmy4gNhhjzV4LnqXhvxgwzSM/9F29dS3u7Biuao6odUk/WJn9u
         YDFIO4ZO2ADgZkEn22pjOBjmRyUMzxmQxR/XYkwerrNungkz7WqMFy2tEKwaUey4Zuro
         T36t9Q7GSlPbj2Ky6ns6VN4MPzYJuquolanjO46PNIzGPZtsEYSkEA6YS00Ay02KNpow
         isoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783829333; x=1784434133;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nSAL3gg/+UGNm6w8OO6Kj1lCK77Tqi4uiJZac+rrH54=;
        b=LPOSmRFdyok2+GwsgWDuxJD7wy+HNT2nkV2d7ZT9kdM/4xGqd7LB/w2Bc7mZVM7szS
         QX3iKS7xtOEonCWojfbsUHc2s/LYIcmo+Mp5/pV41hL6fEj+x8Zt5M+Sa7LFMZY8NYL5
         3EbBuLtBMzUNScMPXzQY2+I5qyG9h2KMFkne1PYCXbNPNo4LYFu+jrjUru4pUies9k9W
         J28imz7/XYtlikrsXfFyDqkqOAmQXdpdLN5gjLocXcWXcNgG8DXaCIqDzeM1TDuhKg5M
         5yXGnm8BfRAb8RUiLloP5jrbi2OkNnQ1E5lN8ZAw9ffgjADRb/Hw+dtnWmvD5SAgYN4Q
         pEZA==
X-Forwarded-Encrypted: i=1; AHgh+RqGp5mxUX0my1ud/UgqNf38leRmAEpOMb2n2OROrthLa+2oqFsT+Ib2nawlFm/xSt1zM63xpG5ynQ==@kvack.org
X-Gm-Message-State: AOJu0Yw7q/CJzjt9644MYoq2CcWLYzvNHbkxjPOc2mIS4loq+KWQbgQT
	zPNxnW4EQKAnwk8hAZQZVefhs8I3C42PXRXCscs7HpSkRsfZMvmeZ1Bj
X-Gm-Gg: AfdE7cmX4FERKpXooaKlewca50JMmrAaP9y4kRWVG+kt140yJktuVfFM3uB1BZPfMPd
	yUZ+P+9P6XpU9ald5CBFm5rKlBuiyO0CvuOXfPLDxrTsiiUB6PS6Z8K5Q/IjRpZ050nVnjDdR/d
	htwbEf7gbdOsOtSX9j8lL4m2XyCB67Nehl4+qqG1IlFgtc/g3AJ21eUOV+45FBTYldGES0jLrXz
	k0q4xZdLiNI7zfdhVNHju/a03snoxdXi7vfWmjiyUGLJCfWKbEt/8S5jOZZyt4GjFySIqTVg32g
	PI9K8YcKGiYsUaWApqsFLugoD4DhJXR3kJB7ikHwbQT9iY3aGx+jVHIxzdnuoCEC37CpWDX6Vf2
	fmL6aghgeFfy4EtA7L/tkOWd5EgSKAMQVW2aVhfTOgZUPL42s9io8CWVIKTu0pf3mQjWh41WiTn
	TwSVc/6r3J+GhugIn1
X-Received: by 2002:a17:90b:54c4:b0:38d:b36e:982d with SMTP id 98e67ed59e1d1-38dc777d7ddmr4186175a91.29.1783829333037;
        Sat, 11 Jul 2026 21:08:53 -0700 (PDT)
Received: from [127.0.0.2] ([98.35.8.117])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31174839f89sm56808928eec.10.2026.07.11.21.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 21:08:52 -0700 (PDT)
From: Farid Zakaria <farid.m.zakaria@gmail.com>
Date: Sat, 11 Jul 2026 21:08:15 -0700
Subject: [PATCH v2 2/5] binfmt_misc: add binfmt_misc_ops bpf struct_ops
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260711-binfmt-misc-bpf-v2-v2-2-d6591ceaf207@gmail.com>
References: <20260711-binfmt-misc-bpf-v2-v2-0-d6591ceaf207@gmail.com>
In-Reply-To: <20260711-binfmt-misc-bpf-v2-v2-0-d6591ceaf207@gmail.com>
To: Christian Brauner <brauner@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Shuah Khan <shuah@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, Jann Horn <jannh@google.com>, 
 John Ericson <mail@johnericson.me>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Farid Zakaria <farid.m.zakaria@gmail.com>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3995AC0004
X-Stat-Signature: 91fy93194ozku3ubigetdd6mmyjc8zox
X-HE-Tag: 1783829334-389517
X-HE-Meta: U2FsdGVkX18m7vSyFWe4T2kKvEB3cRW9mHj8MlUmAu76mrkreZptz2nDJT3qcWiNXYL1kLrCCutuM833x3ZZ1cZMOhts87Ib/pLUU57x0VC9fZyIUbl3TAPPuK0Rx1ejpYzceGnBjIwSeOMnxcMpxrW19sgcmW2+dNm7j23QxITVs2nmVhafDpp1Dg08Lno0PZILlwWltJcgJ2NXsyO0nYDrqt9Gv2MuUaKSLT8vFIuQ7g4R1cHiV90H+2zfqQEd8szlDWUb2t03Ta2qATUIOALyaZrFpA1Xc3iPVZwSfUaAy2JMVzxXUplXxlIdmZVgAxP07AuxHyU3GDKrC19zsNEqkPGzzUfadL+3PkNxso1kZQ96u3X7Ea6AyTPKb0NvcoSvr9OQiwKn7uPW16S5ZoQoZoMsaTqyk55FmA0MkwdBbpxjlyvss2/nMtS+AeGfweENasKiGojlK1O2Y5x/nVu0MAAAvS6isVUf3GQPMwXLsvFB+C/ldvlmE4iGjbhoVLlNgwTbUB9H9ajBGVrBmXCzpHUePDQyXa1UvxbCtbDzv/Wk0tmtTfr9CS0brKtZqH+i36ZtngVqCVwntJVSmUxG+1hWpfSmcHciZjWBSxUrLx5Q2XHJq8IY3k+BQakkD0xbNqelcTp519P0TYUR0qrfkiXWt50jVvwETYW1pQEUNxJcuqGMK21qKoo2CCxtUZKo5GMe2+q+a+/j5RNV40W/AJTu8nF85Ry+KZBXmkvlx7nKbpeP6klgh0kG/1fAz7E6wdvnaQmyXtagV7vJ0N2TWfvoIl1NbpXIfDBmFvYRaMU8V16SmGgDuFQhgdbaIEh7qGvLpnXln8oQHLWZSkGUW2+dfAIhovKZrTvw8PbUQjgLvIN6+GAI+LsKdVVkGOCU2q8U5V2JGRJ80uK6q/TOALlcomgcDG3j8k82SEwBOZdjWW/AcrTItOPAE9vf49iQxJnyXCN3Bt7TR4+
 IYb2UcFG
 wLsDAhCwRJwK98+1X+PVdiYh2wOsmPzcoc+tGOWVVb5iGD3jAyRMC3ed71/srikdgWIobgvMShRdC93RI/g5KDv1HMVD8G25t+OeNqKL6K/5fHRqf0nLS3MNOOO0WCBRqtdjtJDOaJHSc2ut9KRjdxYj5Q+SMFVj/oRKZXN7bthjTE8ErulyCXkdQQcG1m9yeZ3PohU2Cqhd+75/O7kFwig3/+KpvoBgCUdPMNelrZHaQF0BzNk+OsKkeweZ9CPUVWm/jEGZ7Gt9ItX4ywmuauKI411uF12uI7u+rEPKP9i/SMAzl17XSSpRxdulF2Bxv+ohzfQhpt0/BToG8tU2kew/k5xY54zjM2v5itGqiJn8OSkEvCg16kplovt2lk1WT1LQjLRcft+UUzjkr78ynlvgvqfPvjYJP9ji2Buykv7IbhCOaklwTAxf1b5YEcj5cznJtwuel4SWWKgH6lME0UrQfkSFg+GYCu1UYMJEyHgIGSBEAF38Ap5o7TtspbGirYEH6Wf3eIorEjxo/qWbfhGtY6f5gIkUkYkeTM0hYzXdtnzkF+jtwb1l8p6r1xCcieiGZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Christian Brauner <brauner@kernel.org>

Add the bpf plumbing for binary type handlers whose matching and
interpreter selection are implemented by a bpf program instead of a
fixed magic/extension and a fixed interpreter string recorded at
registration time. This serves relocatable binary formats where the
interpreter must be computed per binary, e.g. relative to the location
of the binary itself, as discussed for hermetic Nix-style executables.

A handler is an instance of the new binfmt_misc_ops struct_ops with a
single op:

	int (*load)(struct linux_binprm *bprm);

and a name that binfmt_misc entries reference it by. struct_ops is the
sanctioned mechanism for this kind of user-supplied policy callback:
program types, attach types, and the uapi helper list are frozen, and
every recently added subsystem hook (bpf qdisc, SMC handshake control,
io_uring loop ops, sched_ext) is a struct_ops user. The op receives the
bprm as a trusted BTF pointer, so a program can match on the header in
bprm->buf, read arbitrary file content via bpf_dynptr_from_file() to
parse e.g. ELF program headers, and inspect the binary's location. No
dedicated program type, ctx blob, or uapi helper is needed.

The load program is required to be sleepable. Reliable file reads at
exec time fault in the file's pages; a non-sleepable program would be
limited to whatever happens to be resident in the page cache and would
fail sporadically on cold caches. This also constrains the caller:
binfmt_misc must invoke the op from sleepable context, which a later
patch takes care of.

The interpreter is selected through the new kfunc:

	int bpf_binprm_set_interp(struct linux_binprm *bprm,
				  const char *path, size_t path__sz);

which enforces an absolute path shorter than PATH_MAX and stages a copy
in the bprm. The bprm is exclusively owned by the task doing the exec,
so no shared or per-CPU state is involved and nothing here can race.
The kfunc is registered for struct_ops programs with a filter limiting
it to binfmt_misc_ops programs.

Registering an ops instance (updating the struct_ops map or attaching
its link) publishes the handler under its name in a registry keyed by
the registering task's user namespace. Lookups walk the user namespace
hierarchy upwards, mirroring how binfmt_misc instances themselves are
resolved in load_binfmt_misc(). Consumers take a reference on the ops
via bpf_struct_ops_get() which pins the underlying map and programs, so
an activated handler keeps working even if the map is deleted or the
registering container goes away; deregistration only prevents new
activations, exactly like unregistering a tcp congestion ops with live
users.

Link: https://lore.kernel.org/20260704211409.1978485-1-farid.m.zakaria@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/Kconfig.binfmt           |  14 +++
 fs/Makefile                 |   1 +
 fs/binfmt_misc_bpf.c        | 275 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/binfmt_misc.h |  49 ++++++++
 4 files changed, 339 insertions(+)

diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index 1949e25c7..daeac4889 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -168,6 +168,20 @@ config BINFMT_MISC
 	  you have use for it; the module is called binfmt_misc. If you
 	  don't know what to answer at this point, say Y.
 
+config BINFMT_MISC_BPF
+	bool "BPF-selected interpreters for misc binaries"
+	depends on BINFMT_MISC=y
+	depends on BPF_SYSCALL && BPF_JIT && DEBUG_INFO_BTF
+	help
+	  Allow binfmt_misc binary type handlers to be implemented as bpf
+	  struct_ops programs. Instead of matching a fixed magic and
+	  redirecting to a fixed interpreter recorded at registration time
+	  such handlers match binaries programmatically and compute the
+	  interpreter to use per binary, e.g. relative to the location of
+	  the binary itself.
+
+	  If you don't know what to answer at this point, say N.
+
 config COREDUMP
 	bool "Enable core dump support" if EXPERT
 	default y
diff --git a/fs/Makefile b/fs/Makefile
index 89a8a9d20..499c6670f 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_FS_ENCRYPTION)	+= crypto/
 obj-$(CONFIG_FS_VERITY)		+= verity/
 obj-$(CONFIG_FILE_LOCKING)      += locks.o
 obj-$(CONFIG_BINFMT_MISC)	+= binfmt_misc.o
+obj-$(CONFIG_BINFMT_MISC_BPF)	+= binfmt_misc_bpf.o
 obj-$(CONFIG_BINFMT_SCRIPT)	+= binfmt_script.o
 obj-$(CONFIG_BINFMT_ELF)	+= binfmt_elf.o
 obj-$(CONFIG_COMPAT_BINFMT_ELF)	+= compat_binfmt_elf.o
diff --git a/fs/binfmt_misc_bpf.c b/fs/binfmt_misc_bpf.c
new file mode 100644
index 000000000..72da0964d
--- /dev/null
+++ b/fs/binfmt_misc_bpf.c
@@ -0,0 +1,275 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * BPF-backed binary type handlers for binfmt_misc.
+ *
+ * A handler is a struct binfmt_misc_ops struct_ops map. Loading and
+ * registering it makes the handler available under its name in the user
+ * namespace it was registered in. A binfmt_misc 'B' entry activates it:
+ *
+ *   echo ':entry:B:<handler-name>::::' > <binfmt_misc>/register
+ */
+
+#include <linux/binfmt_misc.h>
+#include <linux/binfmts.h>
+#include <linux/bpf.h>
+#include <linux/bpf_verifier.h>
+#include <linux/btf.h>
+#include <linux/btf_ids.h>
+#include <linux/cred.h>
+#include <linux/init.h>
+#include <linux/limits.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/user_namespace.h>
+
+struct bm_bpf_ops_reg {
+	struct list_head list;
+	const struct binfmt_misc_ops *ops;
+	struct bpf_link *link;
+	struct user_namespace *user_ns;
+};
+
+static DEFINE_MUTEX(bm_bpf_ops_lock);
+static LIST_HEAD(bm_bpf_ops_list);
+
+static struct bpf_struct_ops bpf_binfmt_misc_ops;
+
+static struct bm_bpf_ops_reg *bm_bpf_ops_find(const struct user_namespace *user_ns,
+					      const char *name)
+{
+	struct bm_bpf_ops_reg *reg;
+
+	lockdep_assert_held(&bm_bpf_ops_lock);
+
+	list_for_each_entry(reg, &bm_bpf_ops_list, list) {
+		if (reg->user_ns == user_ns && !strcmp(reg->ops->name, name))
+			return reg;
+	}
+	return NULL;
+}
+
+/**
+ * binfmt_misc_get_ops - look up a bpf binary type handler by name
+ * @user_ns: user namespace of the binfmt_misc instance
+ * @name: name the handler was registered under
+ *
+ * Search @user_ns and its ancestors for a handler named @name, mirroring
+ * the instance lookup in load_binfmt_misc(). The returned handler stays
+ * callable until binfmt_misc_put_ops() even if the backing struct_ops map
+ * is detached or deleted in the meantime.
+ *
+ * Return: the handler on success, NULL on failure
+ */
+const struct binfmt_misc_ops *binfmt_misc_get_ops(struct user_namespace *user_ns,
+						  const char *name)
+{
+	const struct user_namespace *ns;
+	struct bm_bpf_ops_reg *reg;
+
+	guard(mutex)(&bm_bpf_ops_lock);
+
+	for (ns = user_ns; ns; ns = ns->parent) {
+		reg = bm_bpf_ops_find(ns, name);
+		if (!reg)
+			continue;
+		if (!bpf_struct_ops_get(reg->ops))
+			return NULL;
+		return reg->ops;
+	}
+	return NULL;
+}
+
+void binfmt_misc_put_ops(const struct binfmt_misc_ops *ops)
+{
+	bpf_struct_ops_put(ops);
+}
+
+bool bpf_prog_is_binfmt_misc_ops(const struct bpf_prog *prog)
+{
+	return prog->type == BPF_PROG_TYPE_STRUCT_OPS &&
+	       prog->aux->st_ops == &bpf_binfmt_misc_ops;
+}
+
+__bpf_kfunc_start_defs();
+
+/**
+ * bpf_binprm_set_interp - select the interpreter for the current exec
+ * @bprm: binary that is being executed
+ * @path: absolute path to the interpreter
+ * @path__sz: size of the @path buffer, including the terminating NUL
+ *
+ * To be called from the load program of a struct binfmt_misc_ops handler
+ * before returning a positive value. The path is opened with the
+ * credentials of the task doing the exec after the program returns.
+ *
+ * Return: 0 on success, a negative errno on failure
+ */
+__bpf_kfunc int bpf_binprm_set_interp(struct linux_binprm *bprm,
+				      const char *path, size_t path__sz)
+{
+	size_t len;
+	char *interp;
+
+	if (!path__sz)
+		return -EINVAL;
+	len = strnlen(path, path__sz);
+	if (len == path__sz)
+		return -EINVAL;
+	if (path[0] != '/')
+		return -EINVAL;
+	if (len >= PATH_MAX)
+		return -ENAMETOOLONG;
+
+	interp = kmemdup_nul(path, len, GFP_KERNEL);
+	if (!interp)
+		return -ENOMEM;
+
+	kfree(bprm->bpf_interp);
+	bprm->bpf_interp = interp;
+	return 0;
+}
+
+__bpf_kfunc_end_defs();
+
+BTF_KFUNCS_START(bm_bpf_kfunc_ids)
+BTF_ID_FLAGS(func, bpf_binprm_set_interp, KF_SLEEPABLE)
+BTF_KFUNCS_END(bm_bpf_kfunc_ids)
+
+static int bm_bpf_kfunc_filter(const struct bpf_prog *prog, u32 kfunc_id)
+{
+	if (!btf_id_set8_contains(&bm_bpf_kfunc_ids, kfunc_id))
+		return 0;
+	if (bpf_prog_is_binfmt_misc_ops(prog))
+		return 0;
+	return -EACCES;
+}
+
+static const struct btf_kfunc_id_set bm_bpf_kfunc_set = {
+	.owner	= THIS_MODULE,
+	.set	= &bm_bpf_kfunc_ids,
+	.filter	= bm_bpf_kfunc_filter,
+};
+
+static int bm_bpf_ops__load(struct linux_binprm *bprm)
+{
+	return 0;
+}
+
+static struct binfmt_misc_ops bm_bpf_ops_stubs = {
+	.load = bm_bpf_ops__load,
+};
+
+static int bm_bpf_init(struct btf *btf)
+{
+	return register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS,
+					 &bm_bpf_kfunc_set);
+}
+
+static int bm_bpf_check_member(const struct btf_type *t,
+			       const struct btf_member *member,
+			       const struct bpf_prog *prog)
+{
+	u32 moff = __btf_member_bit_offset(t, member) / 8;
+
+	switch (moff) {
+	case offsetof(struct binfmt_misc_ops, load):
+		/* Reliable file reads at exec time require sleeping. */
+		if (!prog->sleepable)
+			return -EINVAL;
+		break;
+	}
+	return 0;
+}
+
+static int bm_bpf_init_member(const struct btf_type *t,
+			      const struct btf_member *member,
+			      void *kdata, const void *udata)
+{
+	const struct binfmt_misc_ops *uops = udata;
+	struct binfmt_misc_ops *ops = kdata;
+	u32 moff = __btf_member_bit_offset(t, member) / 8;
+
+	switch (moff) {
+	case offsetof(struct binfmt_misc_ops, name):
+		if (bpf_obj_name_cpy(ops->name, uops->name,
+				     sizeof(ops->name)) <= 0)
+			return -EINVAL;
+		return 1;
+	}
+	return 0;
+}
+
+static int bm_bpf_validate(void *kdata)
+{
+	struct binfmt_misc_ops *ops = kdata;
+
+	if (!ops->load)
+		return -EINVAL;
+	return 0;
+}
+
+static int bm_bpf_reg(void *kdata, struct bpf_link *link)
+{
+	struct binfmt_misc_ops *ops = kdata;
+	struct bm_bpf_ops_reg *reg;
+
+	reg = kzalloc_obj(*reg, GFP_KERNEL_ACCOUNT);
+	if (!reg)
+		return -ENOMEM;
+
+	reg->ops = ops;
+	reg->link = link;
+	reg->user_ns = get_user_ns(current_user_ns());
+
+	guard(mutex)(&bm_bpf_ops_lock);
+
+	if (bm_bpf_ops_find(reg->user_ns, ops->name)) {
+		put_user_ns(reg->user_ns);
+		kfree(reg);
+		return -EEXIST;
+	}
+
+	list_add(&reg->list, &bm_bpf_ops_list);
+	return 0;
+}
+
+static void bm_bpf_unreg(void *kdata, struct bpf_link *link)
+{
+	struct bm_bpf_ops_reg *reg;
+
+	guard(mutex)(&bm_bpf_ops_lock);
+
+	list_for_each_entry(reg, &bm_bpf_ops_list, list) {
+		if (reg->ops == kdata && reg->link == link) {
+			list_del(&reg->list);
+			put_user_ns(reg->user_ns);
+			kfree(reg);
+			return;
+		}
+	}
+}
+
+static const struct bpf_verifier_ops bm_bpf_verifier_ops = {
+	.get_func_proto		= bpf_base_func_proto,
+	.is_valid_access	= bpf_tracing_btf_ctx_access,
+};
+
+static struct bpf_struct_ops bpf_binfmt_misc_ops = {
+	.verifier_ops	= &bm_bpf_verifier_ops,
+	.init		= bm_bpf_init,
+	.check_member	= bm_bpf_check_member,
+	.init_member	= bm_bpf_init_member,
+	.validate	= bm_bpf_validate,
+	.reg		= bm_bpf_reg,
+	.unreg		= bm_bpf_unreg,
+	.cfi_stubs	= &bm_bpf_ops_stubs,
+	.name		= "binfmt_misc_ops",
+	.owner		= THIS_MODULE,
+};
+
+static int __init bm_bpf_struct_ops_init(void)
+{
+	return register_bpf_struct_ops(&bpf_binfmt_misc_ops, binfmt_misc_ops);
+}
+late_initcall(bm_bpf_struct_ops_init);
diff --git a/include/linux/binfmt_misc.h b/include/linux/binfmt_misc.h
new file mode 100644
index 000000000..e1d26c430
--- /dev/null
+++ b/include/linux/binfmt_misc.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_BINFMT_MISC_H
+#define _LINUX_BINFMT_MISC_H
+
+#include <linux/types.h>
+
+struct bpf_prog;
+struct linux_binprm;
+struct user_namespace;
+
+#define BINFMT_MISC_OPS_NAME_MAX 16
+
+/**
+ * struct binfmt_misc_ops - bpf-backed binary type handler
+ * @load: match @bprm and select an interpreter via bpf_binprm_set_interp();
+ *        returns > 0 if the binary was handled, 0 to fall through to the
+ *        handlers registered after this one, a negative errno to fail the
+ *        exec; -ENOEXEC does not fail the exec but moves on to the
+ *        remaining binary formats
+ * @name: name that 'B' entries reference the handler by
+ */
+struct binfmt_misc_ops {
+	int (*load)(struct linux_binprm *bprm);
+	char name[BINFMT_MISC_OPS_NAME_MAX];
+};
+
+#ifdef CONFIG_BINFMT_MISC_BPF
+const struct binfmt_misc_ops *binfmt_misc_get_ops(struct user_namespace *user_ns,
+						  const char *name);
+void binfmt_misc_put_ops(const struct binfmt_misc_ops *ops);
+bool bpf_prog_is_binfmt_misc_ops(const struct bpf_prog *prog);
+#else
+static inline const struct binfmt_misc_ops *
+binfmt_misc_get_ops(struct user_namespace *user_ns, const char *name)
+{
+	return NULL;
+}
+
+static inline void binfmt_misc_put_ops(const struct binfmt_misc_ops *ops)
+{
+}
+
+static inline bool bpf_prog_is_binfmt_misc_ops(const struct bpf_prog *prog)
+{
+	return false;
+}
+#endif /* CONFIG_BINFMT_MISC_BPF */
+
+#endif /* _LINUX_BINFMT_MISC_H */

-- 
2.51.2



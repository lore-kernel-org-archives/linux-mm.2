Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F4DBC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:15:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED14D6B00A2; Tue, 21 Jul 2026 10:14:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B746B00A3; Tue, 21 Jul 2026 10:14:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D23756B00A4; Tue, 21 Jul 2026 10:14:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BAC06B00A2
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:14:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0A5724018E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:14:55 +0000 (UTC)
X-FDA: 85012980150.25.ED127FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3A5DA180003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:14:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="oSWhBb/e";
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784643293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aJFyMzTJ4FolU905whTQ72izW+aZYYQ8/kr3Ly6K5/c=;
	b=0C1HVVUTkWZHns/R8BTYDyKWZVnJJN1RWhSAUwaARAYlI2VITS4deMDM5q7AiR6MYo8rOF
	bkbrrKazj2yGSRQpQkTdoMG7gyuegtMntkrD0L0OtBCtV65ezRIltr9i85KGssc1Oy69ea
	j9NLlqWSPCQSt2lxVtqVWN6oNdKworo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="oSWhBb/e";
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784643293;
	b=ekhNEOKgz4YCgxVry9e0e3PaFApd2k5bBAVZqa+RnqGKy9tihmQaTzHDYcS72QuVpvtFKm
	dgZj2iOO0H6I6U3DeJvadHa1SoCT2auWwrELYqvFNf1k1iXN1PZTIsGxqZIDDdjbpgMKDu
	9NrFl2rIUeBdJbBpqG2LE2wxrZ2hIvs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7AC2B400A9;
	Tue, 21 Jul 2026 14:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D211F00A3D;
	Tue, 21 Jul 2026 14:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784643292;
	bh=aJFyMzTJ4FolU905whTQ72izW+aZYYQ8/kr3Ly6K5/c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oSWhBb/eEZC6UuqZP1IuWojZcpBKT7h33wTakRNloiLoSnl4AnhjwP/O8uzrjLDql
	 Jb5v0LgZh/IVxdGyuMBSZgWTyfGHjCrzhG0dtKzXEQFMsDWVp5htN87Pc5fZ+y5ttr
	 nVqaj0ntKoPD6T1ozecdC6pNuXd6W3uTAZa/sl5955xRskrQ248iEJrgD75Z6+EeWt
	 CwpDA/mHTBIh52+CwiJyK2Kl+ZmnxWk0OlWVyneadTm9Q7XEGH2bYGFQ1PW79VdgW8
	 Wr4AA9qHyUbTFgwprqIoscrgCMToJd9Ptk9ta/737bIIgBeAYbHRr4GWUgIncc3R7A
	 B6sN8bHFIAeHg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 21 Jul 2026 16:13:50 +0200
Subject: [PATCH v2 08/21] exec: add AT_FLAGS_TRANSPARENT_INTERP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-work-bpf-binfmt_misc-ptinterp-v2-8-e57866e4ae0f@kernel.org>
References: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
In-Reply-To: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=5565; i=brauner@kernel.org;
 h=from:subject:message-id; bh=dcn3exS0UqOj46umxFwpcXTiYELp/TCDmqshcuBqt8M=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTF1+2f+XnS6ynL5c49vOmz+cyv1QcmNCdEsO0+tmveD
 dMQ7zvy6R2lLAxiXAyyYoosDu0m4XLLeSo2G2VqwMxhZQIZwsDFKQATYZvN8D+IZ07hNrM94drV
 m+7wvuKpUm971fj/qsD0dZpHNOzcj4Yx/I88vPe7jF/qlV0u7Od23tv7+GHIneZ6+zf734XnL78
 45TIvAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3A5DA180003
X-Stat-Signature: iyefjkaad4ho1u59bkhe61akhauxsrmo
X-HE-Tag: 1784643293-988334
X-HE-Meta: U2FsdGVkX190GuiIlmsKH/2FQMGYurjmZ0bMQcaUXZXvvqCEfH/3eCg7Y/mkJbFQSyErj73x2M55n9zPcjqI+u4Y7MfuUFIGCZ/uj6Ri7loxyD9+keSRzanv8wc24UaJZexaHaojgjzpfNm+R2nRVmCuFrnuEAUtIwWYI5mbVKP8mGcCH+ugDRulMdW2h4TzW574lXNmAfHis4mT9yUiZIn25GTCzHlf892w7poySF/LWe/zDxLaiDQe1RLYnR6cEQEKdFwQ3rW0M2dV490aKinWS5dHyRXD0+N7wtSoaxY50iSLaiTOssxVMgKasYqTuz7pxyXSnJmA+ieUR3CXxIMbsy0sL98Gt9hTEp3aTnnNl8c3jmT6E3doD5k0oE87ZaX6iNDjLExIWGXoPy6V78Zq/7UxGG5SNQfzgWHL/fVp0IXQFSO/Z/LotQ2tHKz841qQCse8B8/VNObnpaK/vZPXksZGqya7HjRyn7TxzWq8RB1uOjxjuJzcKTpzUkZeYNLebLqQ8KKcxl0z0LJwHQ3RlLSnfm+BDSJ9W90ahrvHm0Zi64wuQZGRGqO+N/oNaz7IlXFDJ0slN/FbavgEy0SVZTZOVtMkyahQVhfW9EzT2ZoMkDNRKoV7ztMGdkuvxxhxCB0JjbS8Vs+fDiU7nAG2uzM1aBeXd03Epai0xys7JP1qPOgjgsCHTytM7JzHVFcsTDYofuUOLsiMjBcXwOKLg3Zf6tVGC3r195xYQbZKDGz4qw7AW9UweUuot3EDq4n+YjoC52gAclchkUzpKMGg/WSM+yHFoul+QHBiWbB2GJmEZBdgDlo3jptpgiH3XiuY7hIPCLlRsOEKm1P4h+GhkZkeky9y2veejaanLo4rIjkA6XaHTJ4ZuURdqVyOHXHLcdBSu4MmX5Z994PFOVDCFTv4bqMBXKG9w/OBPDPQK14h6Cudnxro8iQ0ViqVSsTISExNUBJds9W5e/j
 JhgoZRoB
 VkxECvXoxzobbPEmdGN4pZl6RViMyWctSTvlwRvO4II9MfjVM2RscnoREqbZ7cjr94uxg4q0MbuvwyY35V+00tg/TaV+Owz7neAlZDJz4Mw+9FtsPp4jNhUVLh4PcMZzI41ouNoTzNKqeF3K8O7675YYjFypZZAjmNyk/KcddZwMId/lefa7yZqcE0GjQY/enfFe3Wam1Fdgt9PkGkjNmsHzi7pYkRjtmOCVxxsq0XnCZhUHisV3+oa1sv9qL/BqNn+oTG9MiymKzxMDFlBCsOOzRiI1wzMuskbkLBGkqNLXLrmx6eywDfJvP+1kRrHZP3wxq1HJZMtwuUVXet2AIEkwpgWxLgAFxufuoE8482xqQdD6df+oS6k3ILQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A transparent binfmt_misc dispatch hands the binary to the interpreter
through AT_EXECFD and leaves the argument vector exactly as the caller
built it. The loader on the receiving end has to know which contract it
got.

On the classic 'O'/'C' entries the binary's path is spliced into the
argument vector and the loader consumes arguments. In transparent mode
nothing was spliced and argv belongs entirely to the program. This
cannot be inferred from AT_EXECFD alone. Raise a new AT_FLAGS bit
following the AT_FLAGS_PRESERVE_ARGV0 precedent added for qemu-user in
commit 2347961b11d4 ("binfmt_misc: pass binfmt_misc flags to the
interpreter").

The bit also announces that mm->exe_file names the binary rather than
the interpreter (added in the next commit). A loader that sees the bit
may finish the identity polish by fixing up AT_PHDR/AT_ENTRY/AT_BASE in
saved_auxv and fix the code/data markers via one uncapped PR_SET_MM_MAP
once it has mapped the binary. I've got glibc patches for this as well
but it's useful for any loader.

BINPRM_FLAGS_TRANSPARENT_INTERP carries the mode from binfmt_misc to the
ELF loaders. Both had their own copy of the AT_FLAGS translation, so
give them one bprm_at_flags() to share instead of a second copy that can
drift. Nothing sets the bprm flag yet.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_elf.c              |  5 +----
 fs/binfmt_elf_fdpic.c        |  5 +----
 include/linux/binfmts.h      | 22 ++++++++++++++++++++++
 include/uapi/linux/binfmts.h |  7 +++++++
 4 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 16a56b6b3f6c..be8fd437b5a3 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -179,7 +179,6 @@ create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
 	unsigned char k_rand_bytes[16];
 	int items;
 	elf_addr_t *elf_info;
-	elf_addr_t flags = 0;
 	int ei_index;
 	const struct cred *cred = current_cred();
 	struct vm_area_struct *vma;
@@ -254,9 +253,7 @@ create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
 	NEW_AUX_ENT(AT_PHENT, sizeof(struct elf_phdr));
 	NEW_AUX_ENT(AT_PHNUM, exec->e_phnum);
 	NEW_AUX_ENT(AT_BASE, interp_load_addr);
-	if (bprm->interp_flags & BINPRM_FLAGS_PRESERVE_ARGV0)
-		flags |= AT_FLAGS_PRESERVE_ARGV0;
-	NEW_AUX_ENT(AT_FLAGS, flags);
+	NEW_AUX_ENT(AT_FLAGS, bprm_at_flags(bprm));
 	NEW_AUX_ENT(AT_ENTRY, e_entry);
 	NEW_AUX_ENT(AT_UID, from_kuid_munged(cred->user_ns, cred->uid));
 	NEW_AUX_ENT(AT_EUID, from_kuid_munged(cred->user_ns, cred->euid));
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index fe0b5c5ed2bc..0a3cdf280307 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -509,7 +509,6 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 	char *k_platform, *k_base_platform;
 	char __user *u_platform, *u_base_platform, *p;
 	int loop;
-	unsigned long flags = 0;
 	int ei_index;
 	elf_addr_t *elf_info;
 
@@ -649,9 +648,7 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 	NEW_AUX_ENT(AT_PHENT,	sizeof(struct elf_phdr));
 	NEW_AUX_ENT(AT_PHNUM,	exec_params->hdr.e_phnum);
 	NEW_AUX_ENT(AT_BASE,	interp_params->elfhdr_addr);
-	if (bprm->interp_flags & BINPRM_FLAGS_PRESERVE_ARGV0)
-		flags |= AT_FLAGS_PRESERVE_ARGV0;
-	NEW_AUX_ENT(AT_FLAGS,	flags);
+	NEW_AUX_ENT(AT_FLAGS,	bprm_at_flags(bprm));
 	NEW_AUX_ENT(AT_ENTRY,	exec_params->entry_addr);
 	NEW_AUX_ENT(AT_UID,	(elf_addr_t) from_kuid_munged(cred->user_ns, cred->uid));
 	NEW_AUX_ENT(AT_EUID,	(elf_addr_t) from_kuid_munged(cred->user_ns, cred->euid));
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 03e1794b5cbb..62465574e2a0 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -93,6 +93,28 @@ struct linux_binprm {
 #define BINPRM_FLAGS_PRESERVE_ARGV0_BIT 3
 #define BINPRM_FLAGS_PRESERVE_ARGV0 (1 << BINPRM_FLAGS_PRESERVE_ARGV0_BIT)
 
+/* binfmt_misc dispatched to the interpreter transparently */
+#define BINPRM_FLAGS_TRANSPARENT_INTERP_BIT 4
+#define BINPRM_FLAGS_TRANSPARENT_INTERP (1 << BINPRM_FLAGS_TRANSPARENT_INTERP_BIT)
+
+/**
+ * bprm_at_flags - the AT_FLAGS this invocation implies
+ * @bprm: binary that is being executed
+ *
+ * Tell the program on the receiving end which dispatch contract it got.
+ *
+ * Return: the AT_FLAGS value for this exec
+ */
+static inline unsigned long bprm_at_flags(const struct linux_binprm *bprm)
+{
+	/* Transparency preserves the whole argv, argv[0] included. */
+	if (bprm->interp_flags & BINPRM_FLAGS_TRANSPARENT_INTERP)
+		return AT_FLAGS_TRANSPARENT_INTERP;
+	if (bprm->interp_flags & BINPRM_FLAGS_PRESERVE_ARGV0)
+		return AT_FLAGS_PRESERVE_ARGV0;
+	return 0;
+}
+
 /*
  * This structure defines the functions that are used to load the binary formats that
  * linux accepts.
diff --git a/include/uapi/linux/binfmts.h b/include/uapi/linux/binfmts.h
index c6f9450efc12..aafc07d78b80 100644
--- a/include/uapi/linux/binfmts.h
+++ b/include/uapi/linux/binfmts.h
@@ -22,4 +22,11 @@ struct pt_regs;
 #define AT_FLAGS_PRESERVE_ARGV0_BIT 0
 #define AT_FLAGS_PRESERVE_ARGV0 (1 << AT_FLAGS_PRESERVE_ARGV0_BIT)
 
+/*
+ * The interpreter runs transparently: the argument vector and the exe
+ * link belong to the binary passed in AT_EXECFD.
+ */
+#define AT_FLAGS_TRANSPARENT_INTERP_BIT 1
+#define AT_FLAGS_TRANSPARENT_INTERP (1 << AT_FLAGS_TRANSPARENT_INTERP_BIT)
+
 #endif /* _UAPI_LINUX_BINFMTS_H */

-- 
2.53.0



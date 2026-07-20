Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3833AC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B4A96B00CD; Mon, 20 Jul 2026 05:34:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28C956B00CF; Mon, 20 Jul 2026 05:34:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CA576B00D0; Mon, 20 Jul 2026 05:34:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D31616B00CD
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:34:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4F4A91C0935
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:27 +0000 (UTC)
X-FDA: 85008644574.21.260B9C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8857E20006
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:25 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KL9HwLcI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784540065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qiqkk6rXeNnoqsmRilhTR74TetGVo2qWnVY/kCrNM9Y=;
	b=QhsHZ1fS6t+4q4GMFyhgaFviMhFGMdmG7TmpCnr9YH58TBvcg++650zbs1NauNxF82rsBv
	3ewCJcDp2LT91NPUlEN08fl0h/5u6noFrVPQaHzakut88t9u+mxVOGTRudlWcjnzdy/sDa
	1J3G/XBtKj8pHra6zBdUD0GrXTKvhyo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KL9HwLcI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784540065;
	b=xbuUQ5qQpjmf6nQi+AWxc9ps7utNEXBR3t5DUds4MvOwrcwXifGGwyT/XfqmNRcP0B0uz0
	Q8OmYYSGWKBNWAJtMCV1MMCy3hc9cywp3jtV4alIJfW0Ts82gKjp0AMiG5B0yhlY30dPD7
	8OwzgNL3ll1gI/zENbaAyNKimpQLoN8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E3BEA43B5A;
	Mon, 20 Jul 2026 09:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CBC1F000E9;
	Mon, 20 Jul 2026 09:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784540064;
	bh=qiqkk6rXeNnoqsmRilhTR74TetGVo2qWnVY/kCrNM9Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KL9HwLcIv8tVa5sPFjWGyTsjHza2tuUE3dpiQXmXF5Y6K55NFaTwY2sSDcqnTzbHQ
	 bKOWNkU6CGhFzONqd6QNHEDM/4UV3x4tGWZIdmRW/IiAisXLy+YmUFGneBqrGlBIQP
	 DexRGWtMLkDa6ubxnhaqqCMTZhF6hDTUNhrAMw/pRCdjG/yWhcxEzlL8VvtKQQitsy
	 vTV5a1/cMQfqh0OuDM6p97pxEH0uTReOmoDIAuO7ALGRCY0XXiJ6ndUJgfNuqWUZ35
	 1pItIQDNMSBsfh94YEPOxnBIlg83a8DIUQrUazIaOEFrh2OAO+wxn9wn+Sh0ZN1ngA
	 KA0nHZRk3vAHg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 20 Jul 2026 11:33:31 +0200
Subject: [PATCH 08/21] exec: add AT_FLAGS_TRANSPARENT_INTERP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-work-bpf-binfmt_misc-ptinterp-v1-8-ddb76c9a508e@kernel.org>
References: <20260720-work-bpf-binfmt_misc-ptinterp-v1-0-ddb76c9a508e@kernel.org>
In-Reply-To: <20260720-work-bpf-binfmt_misc-ptinterp-v1-0-ddb76c9a508e@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=4399; i=brauner@kernel.org;
 h=from:subject:message-id; bh=HTd4FlQ/ImzVQFbVjYVnYvCT5MQJdjtKW6kGkWqTDs0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTFvm4KV5BpNiyZcrzlW2+61XqH7AVL+Zyn8s6XebLt/
 50pcnF+HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPZGMjI8Ou737uDJs6/tl9s
 0TZMrdH/fPZbgfW8hPl3zdj0V703MWH4H/Tn5s19J6UnMRRbySnOeTyPdYZSgE+Y0hr9DI+j3kV
 L2QA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 8857E20006
X-Stat-Signature: ha8cdmpiyaagtfm6xje6d5eixmyptqtp
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784540065-734383
X-HE-Meta: U2FsdGVkX1/jIBrBk0AfnBue6tvtwlo1RNXJOhba2Ua9k0bAzNlzmp9PCHTPYLA0xbVDQKU7ptfC58YQ7YQ7owB1yLMCZATg63/9wTpEtCWjvd1XuTJQbx4nrMA9Hn4rwbsgs3KEuKezKfXfNFc/Up0bbJsux3M4i019ykO7/EwBnPKoAVS046NzJhd7Hs1jCWhDPCPvSvq/OFb3ExwC5Q6zURpECcF2I/5CLraoYhy1zXjqdb/fGWTK99ffbPI6bvBNifFfQgeeZEC1RDHh5TsZx3373s4Ma8UKIaE5AWIkkw1zQxtA2WytVvNij5HgSg12JMlj1bs3JdlPElyrx1Shp6xSDkH6H81m/W/QfRxmJqTkdM4dXur7+0UNWnYkdu0SvjSBQpRP69v8urbMJjYBF+xzSgXFv90d+YKbM6u84WXSEBDXl9eCstyM5C6H/p4xD2NPkauML8DqoZEuoHhk6W+Hq0K0lsyM5jm0o78d5PD/0DqCGweNApTtD0DpMC/Zzi3bwdar8GU64KUbBA9F0ZV80IUnYLC3onDestTL5z93ofxWlMNCD4g8F64j9IOlV/YX0Lumtrje/1mHFbN3+M6UfYcGngqsWAo1CKt96u4GYYkcsMAtb32ZAS9UkoL+uGxaRcAxSXEXMXIZXfTGyghIlV27Cy4KHGFAgmBQStcb13jUh/eU18FxTjD+BfxFjM3vTbnfOlW3AD9534hI4bVP+WhZ48qEpTeKT63Y/FJPJe/ZI0Zf5tmClq9G6pGyrbVIdWGq/paAb4Td+qzATB8JFx4Ga6x+/lsqcSlxYoxaCq4UgknW856NU0jPjZ9YaOKpKU6FxbusXlwKpp/rHooti0CWjmdN4uKSJCwRjrPfDVHYrp78LblaNZGRGVh6JteLYmfH02UHLnxrcspVlu2VlsC2P1+n+xE/yd/ripks0tXcUREaQMUH+orO9vlkACvg3pq84VdVh0a
 ad8CXjT7
 uehFnyzbr6yWbo6wuuFNlImwT3ubo9mxTgu8e2w4u1UHGn1g/+w5LoS4Gq1EiKXQ/wfbaNCsEN4ZW27D5weR58wRCxmy5zjbGLTqYrcUe2KO0Gqp2/Aux4MskgcnHrT4/I5HofSShPozVSkJO+4nDBgGD8aaunDLVtGGSG7lA2vKp/3pVxbFcJjDh5InE0tHsOt8WRKf0tHHksoGbrGQ+tfXgv4EPEm3xBkHg8QpuFTGL7B3SUN7858JJkBobyJ8lnvz8sLUcM58gG0Mz7nbalhP4dOgqkFCsJMK5Ga006b1BKx81qd6xapWAfgEoMtLqNAGy2XTQm0lhAb6iwYmuMJ2u7lIQjvE67GZdBdODB//Oigqx8uzN24emiA==
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

BINPRM_FLAGS_TRANSPARENT_INTERP carries the mode from binfmt_misc to
the ELF loaders. Both create_elf_tables() variants translate it into
the aux vector bit. Nothing sets the bprm flag yet.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_elf.c              | 5 ++++-
 fs/binfmt_elf_fdpic.c        | 5 ++++-
 include/linux/binfmts.h      | 4 ++++
 include/uapi/linux/binfmts.h | 7 +++++++
 4 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 16a56b6b3f6c..e44230242f3a 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -254,7 +254,10 @@ create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
 	NEW_AUX_ENT(AT_PHENT, sizeof(struct elf_phdr));
 	NEW_AUX_ENT(AT_PHNUM, exec->e_phnum);
 	NEW_AUX_ENT(AT_BASE, interp_load_addr);
-	if (bprm->interp_flags & BINPRM_FLAGS_PRESERVE_ARGV0)
+	/* Transparency preserves the whole argv, argv[0] included. */
+	if (bprm->interp_flags & BINPRM_FLAGS_TRANSPARENT_INTERP)
+		flags |= AT_FLAGS_TRANSPARENT_INTERP;
+	else if (bprm->interp_flags & BINPRM_FLAGS_PRESERVE_ARGV0)
 		flags |= AT_FLAGS_PRESERVE_ARGV0;
 	NEW_AUX_ENT(AT_FLAGS, flags);
 	NEW_AUX_ENT(AT_ENTRY, e_entry);
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 7e3108489c83..3306d21ab738 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -645,7 +645,10 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 	NEW_AUX_ENT(AT_PHENT,	sizeof(struct elf_phdr));
 	NEW_AUX_ENT(AT_PHNUM,	exec_params->hdr.e_phnum);
 	NEW_AUX_ENT(AT_BASE,	interp_params->elfhdr_addr);
-	if (bprm->interp_flags & BINPRM_FLAGS_PRESERVE_ARGV0)
+	/* Transparency preserves the whole argv, argv[0] included. */
+	if (bprm->interp_flags & BINPRM_FLAGS_TRANSPARENT_INTERP)
+		flags |= AT_FLAGS_TRANSPARENT_INTERP;
+	else if (bprm->interp_flags & BINPRM_FLAGS_PRESERVE_ARGV0)
 		flags |= AT_FLAGS_PRESERVE_ARGV0;
 	NEW_AUX_ENT(AT_FLAGS,	flags);
 	NEW_AUX_ENT(AT_ENTRY,	exec_params->entry_addr);
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 03e1794b5cbb..d4f64d143d1a 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -93,6 +93,10 @@ struct linux_binprm {
 #define BINPRM_FLAGS_PRESERVE_ARGV0_BIT 3
 #define BINPRM_FLAGS_PRESERVE_ARGV0 (1 << BINPRM_FLAGS_PRESERVE_ARGV0_BIT)
 
+/* binfmt_misc dispatched to the interpreter transparently */
+#define BINPRM_FLAGS_TRANSPARENT_INTERP_BIT 4
+#define BINPRM_FLAGS_TRANSPARENT_INTERP (1 << BINPRM_FLAGS_TRANSPARENT_INTERP_BIT)
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



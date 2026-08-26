Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2C20C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 16:06:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D62F06B008C; Wed, 26 Aug 2026 12:06:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D15296B0092; Wed, 26 Aug 2026 12:06:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C023A6B0095; Wed, 26 Aug 2026 12:06:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 968666B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:06:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0C132A0188
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:06:53 +0000 (UTC)
X-FDA: 85143899106.14.6FCDC2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2E08F4000C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:06:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nO2pplol;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787760411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EJdDIyy+4lOGAChPUAxt3Ar9H8Z+4DOnnp8qXsWz7tI=;
	b=VmvDO4a1hRVEZNDylQ0zj7HsxLs9RMtXh24AmiqxJH6qeUzJ52U4hb+JshqspVDlvRjR6Z
	+ayjxpTcGqhasrk45AnCSFqb0Zme8isPhDIm8c/jZBr6oTZnjlARmr6coQUwhsUFsE+aJZ
	dwa17yPETs30u+R8S6YtehfMgSVwFWM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787760411;
	b=UyTbCF0VHfo/RBXzWhxMZoNaBej7EPqCCU0EGjxclkBMqCzIieRHiEML0dbpAUDrIMt1rt
	eyTdr7OsKNNrGVnZiiySRBoUaGYSI9qkHues48eMYPGok997FWTkYeU5MSxGuXYYEdSoYI
	ic5yDt/whnYSb5Nwga+SPgscIAPDPXo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nO2pplol;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B0A343ABB;
	Wed, 26 Aug 2026 16:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157AF1F00A3A;
	Wed, 26 Aug 2026 16:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787760410;
	bh=EJdDIyy+4lOGAChPUAxt3Ar9H8Z+4DOnnp8qXsWz7tI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nO2pplolF+QUbDqj2B7pDD8qzcQC4ECFNXA3xKqfgIw5omJwRcDiwDX8qmMQXX+2X
	 8HNuW6MDAL5f5vYzcsSy7sVnBlwRA8LdwUeQKQElISeRtURSAsv8/ZMoU9T1bF39yf
	 nG5WfqrypfDmJlZbZEOyj1uY/YUPxdbGARlg9B1TxGcwjn3OyT55MDjOZzUebcTqkb
	 CREXpRJHaKbKfrzdYMdMHk8XIa3MR8DZAVIfdUj2DcA7T0s5gYg8f3Izetn4enVVjK
	 QGEnt7KbM7QbK4XA/xumyvcXB8cDc0Tbof2dYSOMNzYj3gx59jZXYnfbUdkmOVWeRb
	 xYJAF+CUCGSSA==
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 26 Aug 2026 18:06:40 +0200
Subject: [PATCH 1/2] powerpc: remove coredump support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260826-work-spufs-coredump-v1-1-579e72a7ab66@kernel.org>
References: <20260826-work-spufs-coredump-v1-0-579e72a7ab66@kernel.org>
In-Reply-To: <20260826-work-spufs-coredump-v1-0-579e72a7ab66@kernel.org>
To: linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Kees Cook <kees@kernel.org>, linuxppc-dev@lists.ozlabs.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=18282; i=brauner@kernel.org;
 h=from:subject:message-id; bh=FafsT4csUaf4RxadGRpATHhYJWC0KXpYpHPv3XQsMss=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT18ws7PWR4/tzryMTZ9rMli+Vai/rm804M8lR3tbLUt
 ojoZM/qKGVhEONikBVTZHFoNwmXW85TsdkoUwNmDisTyBAGLk4BmMgXX0aG15I2+w4dTOEtU5OT
 C92bGvHr2I+2iT26tq8+X3D043m5l+F/QKsU70dDrQIPyY/F21/4K2fvr0t6cEtqVtMaw1TFmc2
 cAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2E08F4000C
X-Stat-Signature: 546eummo84ucua74bkg64nux8q5q8z44
X-Rspam-User: 
X-HE-Tag: 1787760411-335668
X-HE-Meta: U2FsdGVkX18trI116XL4QoAvMEfAbfF5tIiAi4dDj8p1xFrf5H3PQg/9fipQQojv8fSlCrMGsacsEmKb+tGCFONOThsXwzeTO0x06/vQE3y9tA9kKT4PeNjXig3Kb5pRk7Pc96KGVc6JCqbDZrm4g28wfx4l60R5Eb96oS0f4Yv8UfPi8TRXy+o5qhGMbftRWwvoy3TcyMOhrFjMAdhyotoTRmYGLM1oaa/X0opktQNl2KSCha8DvcFl6XPNpeSLEPeeZhywLSe1qxonyhH69OpRfacpEFahbXzBm+dn9s0ny4Us8XELCvQA1OdUGn61ojMKm5/nxVfVHXrZModBtdvQNg8cQvcCIsGpLLahkKdhS9mpfnkO+AGpvEcT95GLSPXaLxc1ETnSQH3NNOJAL3bkBootBzlrY1GB5Kuxv3EosPrzZlA0REbqTBT6XYOgasFRjkDoA+EEsv6o1dbT8B6Y1k2xxXSTqyNOTOJOw2NUKA0i+t4Aw+DPREfgF4yoXGZxz83n+/WgrcQ4lv4Sy4v85G0OrGhGc6wsUN/3yi/DYJNJuPW764WDoenoLfH0Ta2G6bQVWi4vMyEYkQj9ShzyuCx3ihkP/IvDc8NKgKPGpZcYDNorYPe45vqdzNCxEIbdQqW9tjSZZXb0KTBGyZyQNEKR4wWd6aSF3OXNfEUdSud2I5wdi9zbJOaFdNU90o0cSkJrw+UDHqWjYcGPihl374uIc+fyzWG+Pxf9pp9IQXFWGEgeCpON83W4QpyotkMBP58T6qNzUImzCMi/UDumGg+odIjTKV+IKYwsIfR0ix6at4Hzf54vLMylrezdoD7tG0Z5TzXwuVyaJhheStoCjiQXwprbjbWyxmMGQbChUGe42LPtK+sF/gdsF9RUubAa48GiTTxpF9MT3ofhPfhsSgQhLzFXcQSKGInWWd5NmV0a24aCX8BNxrTrmHjCZSwVVfMkbCiegf1iykS
 iTc0V46e
 4ZEusfQjlk/+iuUAZ3Y4KH6TwTEJi19TuCC9aImrWB0MDQ8vgyz/pkmml5ZzbxA9STIcPUNxiZAgCRq2d+d9C1RgItveCa3LW5v8adEEeJXIf7Ccgx4hca0Twy9EnlKn9L0XwY1x5uh3A3ADPZcmlU1nd57DiF/v1c5/Fi432Vlc10Bpe3tHlRT+JSFN1CRhwt71i87scBN7jyTSFFTj0xT42C4Qi7vEjZtdx6+91KQhhS6UwAYyuagt0BgARL61mm6JZ18u4fjLWqRA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A task that dumps open spufs context adds a bunch of extra elf notes
describing the SPU state. It is the only reason do_coredump() unshares
the file descriptor table. We could make this conditional on spufs but
eh.

Nothing can consume those notes anymore. gdb dropped Cell Broadband
Engine debugging in 9.1 and binutils removed it in 2.34. That's about 6
years ago. So no program can actually read an SPU note out of a core
file and probably never did in recent history.

Note that the IBM Cell blades that shipped the Cell processor were
removed in commit 05bf59fbeef3 ("powerpc/cell: Remove support for IBM
Cell Blades"). The PlayStation 3 is the only platform left and nothing
there produces or reads these notes.

So remove it.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/Kconfig                         |   1 -
 arch/powerpc/include/asm/elf.h               |   6 -
 arch/powerpc/include/asm/spu.h               |   3 -
 arch/powerpc/platforms/cell/Kconfig          |   1 -
 arch/powerpc/platforms/cell/spu_syscalls.c   |  20 ---
 arch/powerpc/platforms/cell/spufs/Makefile   |   1 -
 arch/powerpc/platforms/cell/spufs/coredump.c | 183 ---------------------------
 arch/powerpc/platforms/cell/spufs/file.c     | 114 -----------------
 arch/powerpc/platforms/cell/spufs/spufs.h    |  12 --
 arch/powerpc/platforms/cell/spufs/syscalls.c |   4 -
 10 files changed, 345 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 2580e27e4328..40c874fe2f53 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -160,7 +160,6 @@ config PPC
 	select ARCH_HAS_UBSAN
 	select ARCH_HAS_VDSO_ARCH_DATA
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
-	select ARCH_HAVE_EXTRA_ELF_NOTES        if SPU_BASE
 	select ARCH_KEEP_MEMBLOCK
 	select ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE	if PPC_RADIX_MMU
 	select ARCH_MIGHT_HAVE_PC_PARPORT
diff --git a/arch/powerpc/include/asm/elf.h b/arch/powerpc/include/asm/elf.h
index bb4b94444d3e..5dc8c4923eb1 100644
--- a/arch/powerpc/include/asm/elf.h
+++ b/arch/powerpc/include/asm/elf.h
@@ -123,12 +123,6 @@ extern int arch_setup_additional_pages(struct linux_binprm *bprm,
 	(0x7ff >> (PAGE_SHIFT - 12)) : \
 	(0x3ffff >> (PAGE_SHIFT - 12)))
 
-#ifdef CONFIG_SPU_BASE
-/* Notes used in ET_CORE. Note name is "SPU/<fd>/<filename>". */
-#define NT_SPU		1
-
-#endif /* CONFIG_SPU_BASE */
-
 #ifdef CONFIG_PPC64
 
 #define get_cache_geometry(level) \
diff --git a/arch/powerpc/include/asm/spu.h b/arch/powerpc/include/asm/spu.h
index 96ad4510c895..7152285b6268 100644
--- a/arch/powerpc/include/asm/spu.h
+++ b/arch/powerpc/include/asm/spu.h
@@ -210,15 +210,12 @@ extern long spu_sys_callback(struct spu_syscall_block *s);
 
 /* syscalls implemented in spufs */
 struct file;
-struct coredump_params;
 struct spufs_calls {
 	long (*create_thread)(const char __user *name,
 					unsigned int flags, umode_t mode,
 					struct file *neighbor);
 	long (*spu_run)(struct file *filp, __u32 __user *unpc,
 						__u32 __user *ustatus);
-	int (*coredump_extra_notes_size)(void);
-	int (*coredump_extra_notes_write)(struct coredump_params *cprm);
 	void (*notify_spus_active)(void);
 	struct module *owner;
 };
diff --git a/arch/powerpc/platforms/cell/Kconfig b/arch/powerpc/platforms/cell/Kconfig
index db65bfcd1e74..6bd26815c331 100644
--- a/arch/powerpc/platforms/cell/Kconfig
+++ b/arch/powerpc/platforms/cell/Kconfig
@@ -10,7 +10,6 @@ config SPU_FS
 	tristate "SPU file system"
 	default m
 	depends on PPC_CELL
-	depends on COREDUMP
 	select SPU_BASE
 	help
 	  The SPU file system is used to access Synergistic Processing
diff --git a/arch/powerpc/platforms/cell/spu_syscalls.c b/arch/powerpc/platforms/cell/spu_syscalls.c
index 000894e07b02..8be81207e886 100644
--- a/arch/powerpc/platforms/cell/spu_syscalls.c
+++ b/arch/powerpc/platforms/cell/spu_syscalls.c
@@ -88,26 +88,6 @@ SYSCALL_DEFINE3(spu_run,int, fd, __u32 __user *, unpc, __u32 __user *, ustatus)
 	return calls->spu_run(fd_file(arg), unpc, ustatus);
 }
 
-#ifdef CONFIG_COREDUMP
-int elf_coredump_extra_notes_size(void)
-{
-	CLASS(spufs_calls, calls)();
-	if (!calls)
-		return 0;
-
-	return calls->coredump_extra_notes_size();
-}
-
-int elf_coredump_extra_notes_write(struct coredump_params *cprm)
-{
-	CLASS(spufs_calls, calls)();
-	if (!calls)
-		return 0;
-
-	return calls->coredump_extra_notes_write(cprm);
-}
-#endif
-
 void notify_spus_active(void)
 {
 	struct spufs_calls *calls;
diff --git a/arch/powerpc/platforms/cell/spufs/Makefile b/arch/powerpc/platforms/cell/spufs/Makefile
index 52e4c80ec8d0..60319d4ff25a 100644
--- a/arch/powerpc/platforms/cell/spufs/Makefile
+++ b/arch/powerpc/platforms/cell/spufs/Makefile
@@ -4,7 +4,6 @@ obj-$(CONFIG_SPU_FS) += spufs.o
 spufs-y += inode.o file.o context.o syscalls.o
 spufs-y += sched.o backing_ops.o hw_ops.o run.o gang.o
 spufs-y += switch.o fault.o lscsa_alloc.o
-spufs-$(CONFIG_COREDUMP) += coredump.o
 
 # magic for the trace events
 CFLAGS_sched.o := -I$(src)
diff --git a/arch/powerpc/platforms/cell/spufs/coredump.c b/arch/powerpc/platforms/cell/spufs/coredump.c
deleted file mode 100644
index 301ee7d8b7df..000000000000
--- a/arch/powerpc/platforms/cell/spufs/coredump.c
+++ /dev/null
@@ -1,183 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * SPU core dump code
- *
- * (C) Copyright 2006 IBM Corp.
- *
- * Author: Dwayne Grant McConnell <decimal@us.ibm.com>
- */
-
-#include <linux/elf.h>
-#include <linux/file.h>
-#include <linux/fdtable.h>
-#include <linux/fs.h>
-#include <linux/gfp.h>
-#include <linux/list.h>
-#include <linux/syscalls.h>
-#include <linux/coredump.h>
-#include <linux/binfmts.h>
-
-#include <linux/uaccess.h>
-
-#include "spufs.h"
-
-static int spufs_ctx_note_size(struct spu_context *ctx, int dfd)
-{
-	int i, sz, total = 0;
-	char *name;
-	char fullname[80];
-
-	for (i = 0; spufs_coredump_read[i].name != NULL; i++) {
-		name = spufs_coredump_read[i].name;
-		sz = spufs_coredump_read[i].size;
-
-		sprintf(fullname, "SPU/%d/%s", dfd, name);
-
-		total += sizeof(struct elf_note);
-		total += roundup(strlen(fullname) + 1, 4);
-		total += roundup(sz, 4);
-	}
-
-	return total;
-}
-
-static int match_context(const void *v, struct file *file, unsigned fd)
-{
-	struct spu_context *ctx;
-	if (file->f_op != &spufs_context_fops)
-		return 0;
-	ctx = SPUFS_I(file_inode(file))->i_ctx;
-	if (ctx->flags & SPU_CREATE_NOSCHED)
-		return 0;
-	return fd + 1;
-}
-
-/*
- * The additional architecture-specific notes for Cell are various
- * context files in the spu context.
- *
- * This function iterates over all open file descriptors and sees
- * if they are a directory in spufs.  In that case we use spufs
- * internal functionality to dump them without needing to actually
- * open the files.
- */
-/*
- * descriptor table is not shared, so files can't change or go away.
- */
-static struct spu_context *coredump_next_context(int *fd)
-{
-	struct spu_context *ctx = NULL;
-	struct file *file;
-	int n = iterate_fd(current->files, *fd, match_context, NULL);
-	if (!n)
-		return NULL;
-	*fd = n - 1;
-
-	file = fget_raw(*fd);
-	if (file) {
-		ctx = SPUFS_I(file_inode(file))->i_ctx;
-		get_spu_context(ctx);
-		fput(file);
-	}
-
-	return ctx;
-}
-
-int spufs_coredump_extra_notes_size(void)
-{
-	struct spu_context *ctx;
-	int size = 0, rc, fd;
-
-	fd = 0;
-	while ((ctx = coredump_next_context(&fd)) != NULL) {
-		rc = spu_acquire_saved(ctx);
-		if (rc) {
-			put_spu_context(ctx);
-			break;
-		}
-
-		rc = spufs_ctx_note_size(ctx, fd);
-		spu_release_saved(ctx);
-		if (rc < 0) {
-			put_spu_context(ctx);
-			break;
-		}
-
-		size += rc;
-
-		/* start searching the next fd next time */
-		fd++;
-		put_spu_context(ctx);
-	}
-
-	return size;
-}
-
-static int spufs_arch_write_note(struct spu_context *ctx, int i,
-				  struct coredump_params *cprm, int dfd)
-{
-	size_t sz = spufs_coredump_read[i].size;
-	char fullname[80];
-	struct elf_note en;
-	int ret;
-
-	sprintf(fullname, "SPU/%d/%s", dfd, spufs_coredump_read[i].name);
-	en.n_namesz = strlen(fullname) + 1;
-	en.n_descsz = sz;
-	en.n_type = NT_SPU;
-
-	if (!dump_emit(cprm, &en, sizeof(en)))
-		return -EIO;
-	if (!dump_emit(cprm, fullname, en.n_namesz))
-		return -EIO;
-	if (!dump_align(cprm, 4))
-		return -EIO;
-
-	if (spufs_coredump_read[i].dump) {
-		ret = spufs_coredump_read[i].dump(ctx, cprm);
-		if (ret < 0)
-			return ret;
-	} else {
-		char buf[32];
-
-		ret = snprintf(buf, sizeof(buf), "0x%.16llx",
-			       spufs_coredump_read[i].get(ctx));
-		if (ret >= sizeof(buf))
-			return sizeof(buf);
-
-		/* count trailing the NULL: */
-		if (!dump_emit(cprm, buf, ret + 1))
-			return -EIO;
-	}
-
-	dump_skip_to(cprm, roundup(cprm->pos - ret + sz, 4));
-	return 0;
-}
-
-int spufs_coredump_extra_notes_write(struct coredump_params *cprm)
-{
-	struct spu_context *ctx;
-	int fd, j, rc;
-
-	fd = 0;
-	while ((ctx = coredump_next_context(&fd)) != NULL) {
-		rc = spu_acquire_saved(ctx);
-		if (rc)
-			return rc;
-
-		for (j = 0; spufs_coredump_read[j].name != NULL; j++) {
-			rc = spufs_arch_write_note(ctx, j, cprm, fd);
-			if (rc) {
-				spu_release_saved(ctx);
-				return rc;
-			}
-		}
-
-		spu_release_saved(ctx);
-
-		/* start searching the next fd next time */
-		fd++;
-	}
-
-	return 0;
-}
diff --git a/arch/powerpc/platforms/cell/spufs/file.c b/arch/powerpc/platforms/cell/spufs/file.c
index de7494748fec..98c47bafaf67 100644
--- a/arch/powerpc/platforms/cell/spufs/file.c
+++ b/arch/powerpc/platforms/cell/spufs/file.c
@@ -9,7 +9,6 @@
 
 #undef DEBUG
 
-#include <linux/coredump.h>
 #include <linux/fs.h>
 #include <linux/ioctl.h>
 #include <linux/export.h>
@@ -130,14 +129,6 @@ static ssize_t spufs_attr_write(struct file *file, const char __user *buf,
 	return ret;
 }
 
-static ssize_t spufs_dump_emit(struct coredump_params *cprm, void *buf,
-		size_t size)
-{
-	if (!dump_emit(cprm, buf, size))
-		return -EIO;
-	return size;
-}
-
 #define DEFINE_SPUFS_SIMPLE_ATTRIBUTE(__fops, __get, __set, __fmt)	\
 static int __fops ## _open(struct inode *inode, struct file *file)	\
 {									\
@@ -180,12 +171,6 @@ spufs_mem_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static ssize_t
-spufs_mem_dump(struct spu_context *ctx, struct coredump_params *cprm)
-{
-	return spufs_dump_emit(cprm, ctx->ops->get_ls(ctx), LS_SIZE);
-}
-
 static ssize_t
 spufs_mem_read(struct file *file, char __user *buffer,
 				size_t size, loff_t *pos)
@@ -466,13 +451,6 @@ spufs_regs_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static ssize_t
-spufs_regs_dump(struct spu_context *ctx, struct coredump_params *cprm)
-{
-	return spufs_dump_emit(cprm, ctx->csa.lscsa->gprs,
-			       sizeof(ctx->csa.lscsa->gprs));
-}
-
 static ssize_t
 spufs_regs_read(struct file *file, char __user *buffer,
 		size_t size, loff_t *pos)
@@ -523,13 +501,6 @@ static const struct file_operations spufs_regs_fops = {
 	.llseek  = generic_file_llseek,
 };
 
-static ssize_t
-spufs_fpcr_dump(struct spu_context *ctx, struct coredump_params *cprm)
-{
-	return spufs_dump_emit(cprm, &ctx->csa.lscsa->fpcr,
-			       sizeof(ctx->csa.lscsa->fpcr));
-}
-
 static ssize_t
 spufs_fpcr_read(struct file *file, char __user * buffer,
 		size_t size, loff_t * pos)
@@ -953,15 +924,6 @@ spufs_signal1_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static ssize_t spufs_signal1_dump(struct spu_context *ctx,
-		struct coredump_params *cprm)
-{
-	if (!ctx->csa.spu_chnlcnt_RW[3])
-		return 0;
-	return spufs_dump_emit(cprm, &ctx->csa.spu_chnldata_RW[3],
-			       sizeof(ctx->csa.spu_chnldata_RW[3]));
-}
-
 static ssize_t __spufs_signal1_read(struct spu_context *ctx, char __user *buf,
 			size_t len)
 {
@@ -1086,15 +1048,6 @@ spufs_signal2_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static ssize_t spufs_signal2_dump(struct spu_context *ctx,
-		struct coredump_params *cprm)
-{
-	if (!ctx->csa.spu_chnlcnt_RW[4])
-		return 0;
-	return spufs_dump_emit(cprm, &ctx->csa.spu_chnldata_RW[4],
-			       sizeof(ctx->csa.spu_chnldata_RW[4]));
-}
-
 static ssize_t __spufs_signal2_read(struct spu_context *ctx, char __user *buf,
 			size_t len)
 {
@@ -1924,15 +1877,6 @@ static const struct file_operations spufs_caps_fops = {
 	.release	= single_release,
 };
 
-static ssize_t spufs_mbox_info_dump(struct spu_context *ctx,
-		struct coredump_params *cprm)
-{
-	if (!(ctx->csa.prob.mb_stat_R & 0x0000ff))
-		return 0;
-	return spufs_dump_emit(cprm, &ctx->csa.prob.pu_mb_R,
-			       sizeof(ctx->csa.prob.pu_mb_R));
-}
-
 static ssize_t spufs_mbox_info_read(struct file *file, char __user *buf,
 				   size_t len, loff_t *pos)
 {
@@ -1962,15 +1906,6 @@ static const struct file_operations spufs_mbox_info_fops = {
 	.llseek  = generic_file_llseek,
 };
 
-static ssize_t spufs_ibox_info_dump(struct spu_context *ctx,
-		struct coredump_params *cprm)
-{
-	if (!(ctx->csa.prob.mb_stat_R & 0xff0000))
-		return 0;
-	return spufs_dump_emit(cprm, &ctx->csa.priv2.puint_mb_R,
-			       sizeof(ctx->csa.priv2.puint_mb_R));
-}
-
 static ssize_t spufs_ibox_info_read(struct file *file, char __user *buf,
 				   size_t len, loff_t *pos)
 {
@@ -2005,13 +1940,6 @@ static size_t spufs_wbox_info_cnt(struct spu_context *ctx)
 	return (4 - ((ctx->csa.prob.mb_stat_R & 0x00ff00) >> 8)) * sizeof(u32);
 }
 
-static ssize_t spufs_wbox_info_dump(struct spu_context *ctx,
-		struct coredump_params *cprm)
-{
-	return spufs_dump_emit(cprm, &ctx->csa.spu_mailbox_data,
-			spufs_wbox_info_cnt(ctx));
-}
-
 static ssize_t spufs_wbox_info_read(struct file *file, char __user *buf,
 				   size_t len, loff_t *pos)
 {
@@ -2059,15 +1987,6 @@ static void spufs_get_dma_info(struct spu_context *ctx,
 	}
 }
 
-static ssize_t spufs_dma_info_dump(struct spu_context *ctx,
-		struct coredump_params *cprm)
-{
-	struct spu_dma_info info;
-
-	spufs_get_dma_info(ctx, &info);
-	return spufs_dump_emit(cprm, &info, sizeof(info));
-}
-
 static ssize_t spufs_dma_info_read(struct file *file, char __user *buf,
 			      size_t len, loff_t *pos)
 {
@@ -2112,15 +2031,6 @@ static void spufs_get_proxydma_info(struct spu_context *ctx,
 	}
 }
 
-static ssize_t spufs_proxydma_info_dump(struct spu_context *ctx,
-		struct coredump_params *cprm)
-{
-	struct spu_proxydma_info info;
-
-	spufs_get_proxydma_info(ctx, &info);
-	return spufs_dump_emit(cprm, &info, sizeof(info));
-}
-
 static ssize_t spufs_proxydma_info_read(struct file *file, char __user *buf,
 				   size_t len, loff_t *pos)
 {
@@ -2580,27 +2490,3 @@ const struct spufs_tree_descr spufs_dir_debug_contents[] = {
 	{ ".ctx", &spufs_ctx_fops, 0444, },
 	{},
 };
-
-const struct spufs_coredump_reader spufs_coredump_read[] = {
-	{ "regs", spufs_regs_dump, NULL, sizeof(struct spu_reg128[128])},
-	{ "fpcr", spufs_fpcr_dump, NULL, sizeof(struct spu_reg128) },
-	{ "lslr", NULL, spufs_lslr_get, 19 },
-	{ "decr", NULL, spufs_decr_get, 19 },
-	{ "decr_status", NULL, spufs_decr_status_get, 19 },
-	{ "mem", spufs_mem_dump, NULL, LS_SIZE, },
-	{ "signal1", spufs_signal1_dump, NULL, sizeof(u32) },
-	{ "signal1_type", NULL, spufs_signal1_type_get, 19 },
-	{ "signal2", spufs_signal2_dump, NULL, sizeof(u32) },
-	{ "signal2_type", NULL, spufs_signal2_type_get, 19 },
-	{ "event_mask", NULL, spufs_event_mask_get, 19 },
-	{ "event_status", NULL, spufs_event_status_get, 19 },
-	{ "mbox_info", spufs_mbox_info_dump, NULL, sizeof(u32) },
-	{ "ibox_info", spufs_ibox_info_dump, NULL, sizeof(u32) },
-	{ "wbox_info", spufs_wbox_info_dump, NULL, 4 * sizeof(u32)},
-	{ "dma_info", spufs_dma_info_dump, NULL, sizeof(struct spu_dma_info)},
-	{ "proxydma_info", spufs_proxydma_info_dump,
-			   NULL, sizeof(struct spu_proxydma_info)},
-	{ "object-id", NULL, spufs_object_id_get, 19 },
-	{ "npc", NULL, spufs_npc_get, 19 },
-	{ NULL },
-};
diff --git a/arch/powerpc/platforms/cell/spufs/spufs.h b/arch/powerpc/platforms/cell/spufs/spufs.h
index d33787c57c39..612b5075d0ec 100644
--- a/arch/powerpc/platforms/cell/spufs/spufs.h
+++ b/arch/powerpc/platforms/cell/spufs/spufs.h
@@ -232,13 +232,9 @@ extern const struct spufs_tree_descr spufs_dir_debug_contents[];
 
 /* system call implementation */
 extern struct spufs_calls spufs_calls;
-struct coredump_params;
 long spufs_run_spu(struct spu_context *ctx, u32 *npc, u32 *status);
 long spufs_create(const struct path *nd, struct dentry *dentry, unsigned int flags,
 			umode_t mode, struct file *filp);
-/* ELF coredump callbacks for writing SPU ELF notes */
-extern int spufs_coredump_extra_notes_size(void);
-extern int spufs_coredump_extra_notes_write(struct coredump_params *cprm);
 
 extern const struct file_operations spufs_context_fops;
 
@@ -335,14 +331,6 @@ void spufs_stop_callback(struct spu *spu, int irq);
 void spufs_mfc_callback(struct spu *spu);
 void spufs_dma_callback(struct spu *spu, int type);
 
-struct spufs_coredump_reader {
-	char *name;
-	ssize_t (*dump)(struct spu_context *ctx, struct coredump_params *cprm);
-	u64 (*get)(struct spu_context *ctx);
-	size_t size;
-};
-extern const struct spufs_coredump_reader spufs_coredump_read[];
-
 extern int spu_init_csa(struct spu_state *csa);
 extern void spu_fini_csa(struct spu_state *csa);
 extern int spu_save(struct spu_state *prev, struct spu *spu);
diff --git a/arch/powerpc/platforms/cell/spufs/syscalls.c b/arch/powerpc/platforms/cell/spufs/syscalls.c
index ea4ba1b6ce6a..b6de37150e73 100644
--- a/arch/powerpc/platforms/cell/spufs/syscalls.c
+++ b/arch/powerpc/platforms/cell/spufs/syscalls.c
@@ -82,8 +82,4 @@ struct spufs_calls spufs_calls = {
 	.spu_run = do_spu_run,
 	.notify_spus_active = do_notify_spus_active,
 	.owner = THIS_MODULE,
-#ifdef CONFIG_COREDUMP
-	.coredump_extra_notes_size = spufs_coredump_extra_notes_size,
-	.coredump_extra_notes_write = spufs_coredump_extra_notes_write,
-#endif
 };

-- 
2.53.0



Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F741607039F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ByuxxP2Y
Received: by kanga.kvack.org (Postfix)
	id 8CC186B05C2; Mon,  2 Nov 2026 09:49:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A3D96B05C3; Mon,  2 Nov 2026 09:49:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BC136B05C4; Mon,  2 Nov 2026 09:49:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4DD1F6B05C2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:49:24 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9EDDDA014B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:49:23 +0000 (UTC)
X-FDA: 85390462206.05.53AAC71
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id EC2A740007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:49:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ByuxxP2Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793630962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jrxxeu9FMCeaH9PPG0vvIdaQylBKAxxjB5EHgDoyGNY=;
	b=sPX1M9tzkX/UIGtVOD2hSauiPmLdVm22pTTUv6zd/LBiS1hWVeUvCLBwvSG5vwyDm2Yp0m
	ma2mVifegPJ+6ej7SDL0Rs6GgsnBiAMw0QZXO6AMf0XBt5b+MLzepaogiKkxABN8VSEujz
	2SiCw+fp6PIsznnMmA7u4bb+vPkmNUI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ByuxxP2Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793630962;
	b=hRbLlxYl+cMGcAqbc8Juhjnt57TYlKxqVajUCJgESiRE282rBFf1maQ7oNi49g7o+xnqac
	LVpBLEbnrDozYGtei1lJnJP/rRIsoGpOCNOmr5Al4uqL65tjdbEwNQ01TQ2qBsE+4JndCo
	FnCpNhO7ANthfNrfzp6ec2xeLNUb64Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 185B1408A4;
	Mon,  2 Nov 2026 14:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D423F1F00A16;
	Mon,  2 Nov 2026 14:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630961;
	bh=jrxxeu9FMCeaH9PPG0vvIdaQylBKAxxjB5EHgDoyGNY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ByuxxP2Y0aL4EQ4HwE1D5VE6bk9SBZU78IecQNaoL/QqN2Y6I7ABFAIAs9mVScHNH
	 SgYUHz+A/rbabkW8D5dGgo432jVpFe7FT/P6H+jA3wauUd5cjNIX0RjXLHQxPeZnwc
	 ZHYHReIZ20MHWB1oFcj0/0Oig7/cat0HqyX7ecJpsbua1wSW9hsT6O0sgpvSBLGhfY
	 xPgK550INOHZoI47HH3iTcy4uMo2SA7+Bla5KpVWGtw3gSqFOEGcd2cLWE8Js/8MoA
	 b91eSZEjTRDcbicVa76y8vSAq+2z0cdK8bBOdtnHVxMyTugmPIsG5XGIzFlkoOVhvM
	 mmiHRSg+JBAAQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:48:41 +0100
Subject: [PATCH RFC 01/16] proc: drop the compat file operations
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-core-v1-1-75df35e4f8b8@kernel.org>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
In-Reply-To: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
 Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
 Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
 Greg Kroah-Hartman <gregkh@suse.de>, 
 Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, 
 Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
 coreteam@netfilter.org, kexec@lists.infradead.org, 
 linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-cifs@vger.kernel.org, linux-fbdev@vger.kernel.org, 
 linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-sh@vger.kernel.org, 
 linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
 sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
 linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, 
 linux-atm-general@lists.sourceforge.net, Takashi Iwai <tiwai@suse.de>, 
 linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
 linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
 linux-debuggers@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Chuck Lever <cel@kernel.org>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: EC2A740007
X-Stat-Signature: n6gczsp4gekghc1r4pc95c8i8qkifpy5
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793630961-552257
X-HE-Meta: U2FsdGVkX18G9OQFIrFyPKt9R8ax5J3XboOkHv6LmqzLCHU++q7/rhQTWg9xPw65sEWGflR+oq3jOgYlPSYs0VlNFxFJonT80FZcqrIQK7ciwDrtFJ60+7D8VkozwX58qeyZNH8+dzNXaCe8XDyn1rv2WFQuZilrcC29g2A4zGiVXSFkrlX5IT9ucpCxjMc2MDoh2030q/6MXLdFF7cnJW+rOyYBB5szttR90gg3i7ol2Tkvzw8BcUe/yXSzHDQSn2L15AkmwQSCJhN+yQDgtDipiGyUMfhR/hiodHKbXUb04quTyF3w7xWzRNNuvep2K577y/Gjo9unmUsyt3Q5Y8foEfBjh8OvDHbO1qskPmuK+FvnXSd/TiV95UUd+EgiFKioYupzwqCKZR+6n6gIaO191SWoqVjtyGDhRmdnSaNsCKyzlJWwR8BOTV/eY7355V6sMby1SAN3chdOeG6rBYLfMf5lub5hehdlJTSnPWnVBSzAzSXp3zV/bdofzCZspLR9F8ZmvsIh20AKAMe5MByddGED63Sfp2rU6XSfyGx+HeJhRoJdsMkioHFxkH+9JByiVJucXGs9Y4GV+7BFbGbMPGb82whQxo5WbjvdoAomecms1GPg7H0mO89ZuwuNNpWEBFJ7ChbBB2dLiHi7QosADTcqhtLPkVDlhb7FJNaTZAneQvje0xdOPgxIJsvqcCsNtv9i0GYnLVYHwcrPxQOPliSbeas0QDTuoyBl5+tQTNbkOX+C3XQBi5N4hEXfqYYGPRJHEaLRbrRr7JqdaU5gxo6BzGFGmzupRWe7eQRG7a6OtvAtyk2UrLz3GMI+uGEuTfgBiWJhxTEJY8//L3erMTOzsAOQGfm20uBvhUnk/xHWKBwWM83WbNmUm8NVFREJNwriQa9LjLi7K/gkLJb+6tVfpHj6NuIM6uguc/UfFcVUY9ceTeYmDcSak6uj4nQCPVYVDxImrkk9DaE
 O0R2rirU
 rgKg1NcorxfzWz/6XSCAqwfxEc3oHbtP7ULEBoKlFa/OIFEppKD6ou7PTT6dM1z2pRghG5ScrILj2G/LdKbJJ0fVXmf8CN5/8gWo3ccTSHfediVy3zvJb/qYzncsSUkvhWhepO3hDMXcJP6Y2r3AHruM62B8z0CZ+gmW8LIMA0GIOaHkUT4NlHXmcU3tkgfRpwZwxgavCel5LF6QW7c1ubm07o9vivtI3ZMI5vCpDeOy9Hx+f+I28vRQ0pWbZEpoVSM/KJXdXjIbaeZc1wCVtfHKCmJFaBT7dIK9O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

procfs has both sets of file operations twice, with and without
->compat_ioctl(), and picks the one with it for entries that have
->proc_compat_ioctl(). That's from commit 778f3dd5a13c ("Fix procfs
compat_ioctl regression") when a file without ->compat_ioctl() went
through the translation tables in fs/compat_ioctl.c and one with it
didn't. Those tables are gone since commit 77b9040195de ("compat_ioctl:
simplify the implementation"). compat_sys_ioctl() answers -ENOTTY for a
file without ->compat_ioctl() now, which is what
proc_reg_compat_ioctl() answers for an entry without
->proc_compat_ioctl().

So always set ->compat_ioctl() and drop the second set of file
operations and the flag that picked it.

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/generic.c       |  4 ----
 fs/proc/inode.c         | 45 +++------------------------------------------
 fs/proc/internal.h      |  9 ---------
 include/linux/proc_fs.h |  1 -
 4 files changed, 3 insertions(+), 56 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 23fc026d7bbb..761f9958558f 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -445,10 +445,6 @@ static void pde_set_flags(struct proc_dir_entry *pde)
 		pde->flags |= PROC_ENTRY_PERMANENT;
 	if (proc_ops->proc_read_iter)
 		pde->flags |= PROC_ENTRY_proc_read_iter;
-#ifdef CONFIG_COMPAT
-	if (proc_ops->proc_compat_ioctl)
-		pde->flags |= PROC_ENTRY_proc_compat_ioctl;
-#endif
 	if (proc_ops->proc_lseek)
 		pde->flags |= PROC_ENTRY_proc_lseek;
 }
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 2d65f3c8ec03..18f6490bfe77 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -410,6 +410,8 @@ static long proc_reg_compat_ioctl(struct file *file, unsigned int cmd, unsigned
 	}
 	return rv;
 }
+#else
+#define proc_reg_compat_ioctl NULL
 #endif
 
 static int pde_mmap(struct proc_dir_entry *pde, struct file *file, struct vm_area_struct *vma)
@@ -569,6 +571,7 @@ static const struct file_operations proc_reg_file_ops = {
 	.write		= proc_reg_write,
 	.poll		= proc_reg_poll,
 	.unlocked_ioctl	= proc_reg_unlocked_ioctl,
+	.compat_ioctl	= proc_reg_compat_ioctl,
 	.mmap		= proc_reg_mmap,
 	.get_unmapped_area = proc_reg_get_unmapped_area,
 #ifndef CONFIG_MMU
@@ -585,39 +588,6 @@ static const struct file_operations proc_iter_file_ops = {
 	.splice_read	= copy_splice_read,
 	.poll		= proc_reg_poll,
 	.unlocked_ioctl	= proc_reg_unlocked_ioctl,
-	.mmap		= proc_reg_mmap,
-	.get_unmapped_area = proc_reg_get_unmapped_area,
-#ifndef CONFIG_MMU
-	.mmap_capabilities = proc_reg_mmap_capabilities,
-#endif
-	.open		= proc_reg_open,
-	.release	= proc_reg_release,
-};
-
-#ifdef CONFIG_COMPAT
-static const struct file_operations proc_reg_file_ops_compat = {
-	.llseek		= proc_reg_llseek,
-	.read		= proc_reg_read,
-	.write		= proc_reg_write,
-	.poll		= proc_reg_poll,
-	.unlocked_ioctl	= proc_reg_unlocked_ioctl,
-	.compat_ioctl	= proc_reg_compat_ioctl,
-	.mmap		= proc_reg_mmap,
-	.get_unmapped_area = proc_reg_get_unmapped_area,
-#ifndef CONFIG_MMU
-	.mmap_capabilities = proc_reg_mmap_capabilities,
-#endif
-	.open		= proc_reg_open,
-	.release	= proc_reg_release,
-};
-
-static const struct file_operations proc_iter_file_ops_compat = {
-	.llseek		= proc_reg_llseek,
-	.read_iter	= proc_reg_read_iter,
-	.splice_read	= copy_splice_read,
-	.write		= proc_reg_write,
-	.poll		= proc_reg_poll,
-	.unlocked_ioctl	= proc_reg_unlocked_ioctl,
 	.compat_ioctl	= proc_reg_compat_ioctl,
 	.mmap		= proc_reg_mmap,
 	.get_unmapped_area = proc_reg_get_unmapped_area,
@@ -627,7 +597,6 @@ static const struct file_operations proc_iter_file_ops_compat = {
 	.open		= proc_reg_open,
 	.release	= proc_reg_release,
 };
-#endif
 
 static const char *proc_get_link(struct dentry *dentry,
 				 struct inode *inode,
@@ -683,14 +652,6 @@ struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 			inode->i_fop = &proc_iter_file_ops;
 		else
 			inode->i_fop = &proc_reg_file_ops;
-#ifdef CONFIG_COMPAT
-		if (pde_has_proc_compat_ioctl(de)) {
-			if (pde_has_proc_read_iter(de))
-				inode->i_fop = &proc_iter_file_ops_compat;
-			else
-				inode->i_fop = &proc_reg_file_ops_compat;
-		}
-#endif
 	} else if (S_ISDIR(inode->i_mode)) {
 		inode->i_op = de->proc_iops;
 		inode->i_fop = de->proc_dir_ops;
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 04f7ce2b24ed..268a0523be12 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -92,15 +92,6 @@ static inline bool pde_has_proc_read_iter(const struct proc_dir_entry *pde)
 	return pde->flags & PROC_ENTRY_proc_read_iter;
 }
 
-static inline bool pde_has_proc_compat_ioctl(const struct proc_dir_entry *pde)
-{
-#ifdef CONFIG_COMPAT
-	return pde->flags & PROC_ENTRY_proc_compat_ioctl;
-#else
-	return false;
-#endif
-}
-
 static inline bool pde_has_proc_lseek(const struct proc_dir_entry *pde)
 {
 	return pde->flags & PROC_ENTRY_proc_lseek;
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 47d7deaeed8f..6ad5150020bf 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -26,7 +26,6 @@ enum {
 #endif
 
 	PROC_ENTRY_proc_read_iter	= 1U << 1,
-	PROC_ENTRY_proc_compat_ioctl	= 1U << 2,
 	PROC_ENTRY_proc_lseek		= 1U << 3,
 
 	PROC_ENTRY_FORCE_LOOKUP		= 1U << 7,

-- 
2.53.0



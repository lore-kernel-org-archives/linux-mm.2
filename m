Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 284DF609175B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BjZ/Zf08
Received: by kanga.kvack.org (Postfix)
	id 316B56B05E4; Wed,  4 Nov 2026 14:29:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EEC46B05E5; Wed,  4 Nov 2026 14:29:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 205DD6B05E6; Wed,  4 Nov 2026 14:29:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E841A6B05E4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:29:49 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 84018C077B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:29:49 +0000 (UTC)
X-FDA: 85398426498.13.0F7C4FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id B09E7180002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:29:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BjZ/Zf08";
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jJveCArfJ4dJAlkDsE+PsTgPNAew1JtEqbKqeEtjh0c=;
	b=IC8LXlCEv/NyOS4whywk2QW216JR1XM/LRKLFODZ1472WzbHu3fxp49gwGNivp3of7wLbs
	t2XE7inIN3FUXH8f2z4f3N5y9cqAN2ASl4ubMqap9m8iChwE1rJUbAzaZqmVokMV+RL/e6
	6MIH6/Qi26lT8Fsj1JIivTEY5+oJQw0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820587;
	b=NLoE965hD3z36wNTJKsHuSxxhPlomZaxaj3h7aYiCf0i24Tt7FvuM1AwVDUeV83+GhRXgy
	s5R+z8vqqUzjtFwk0O/QS4QssposjhaqNcECAqG0baukWMaTYEwGQ7WKGtxBXAzFcqcglx
	W45lCGu+eG/v1L34iIQ+VvXpJpEEt9A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BjZ/Zf08";
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DED9143578;
	Wed,  4 Nov 2026 19:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F0A1F00A17;
	Wed,  4 Nov 2026 19:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820586;
	bh=jJveCArfJ4dJAlkDsE+PsTgPNAew1JtEqbKqeEtjh0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BjZ/Zf08BvWFVtiPIjuPZ7YyWoio1bwIZMMZVBF20DzzjnxA22jWzFxc9KjKjaDvT
	 rViB/7feQqOjmIju1fIMJ4a+1vVMheCQ/Lrk5pNSdEe7937GT4q7VYJRDRZ2FTv2lh
	 C/KvEqXWJmv76siosW+mEyiwP42cccALGsX6OmqEmfv7sn7fyyyEhW4DwY1lepXGap
	 VVEvKtdm//l0UV8A5yXcOdbtJeVrpe0JA8pTZmD3AlPnJBCkqJoqHuJZtDgqSt3khc
	 88vcSfprY+zWqxmh00X2TKAsyOgox1rWtHhY7hk8VIBQVGLti3lb08ZLZo2VrV985S
	 v/G8P54ivmf+A==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jann Horn <jannh@google.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Mason <mason@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Eric Dumazet <edumazet@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Christoph Hellwig <hch@lst.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Joel Granados <joel.granados@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jan Kara <jack@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	netdev@vger.kernel.org,
	ntfs3@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	coreteam@netfilter.org,
	kexec@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-sound@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	ibm-acpi-devel@lists.sourceforge.net,
	jfs-discussion@lists.sourceforge.net,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-mm@kvack.org,
	linux-sh@vger.kernel.org,
	linux-usb@vger.kernel.org,
	samba-technical@lists.samba.org,
	sparclinux@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-doc@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-atm-general@lists.sourceforge.net,
	Takashi Iwai <tiwai@suse.de>,
	linux-input@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH RESEND v2 01/23] proc: drop the compat file operations
Date: Wed,  4 Nov 2026 20:29:32 +0100
Message-ID: <20261104-work-procfs-core-v2-1-76ace653a773@kernel.org>
In-Reply-To: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=5437; i=brauner@kernel.org; h=from:subject:message-id; bh=2wrGueNUlsSX/cB6QD56PXJI32dZ2evqLoQHTbyNmak=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bi80rwldk9xsNCM88cQWmaL5ejXnqpvnZdyZxcf3a JOaS+/cjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgImkRjEyHDk9+33iyk/3v0l/ Pvmv4kDpyx/CU2XYgk81tbCteMR3V57hv3fbzJj2eNeqs4lze0saDYXOKnhp666eWf7l+JJnopF f+QE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B09E7180002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: wf7fz1whc3eh47b6yepdmdmi58nwf3yz
X-Rspam-User: 
X-HE-Tag: 1793820587-183208
X-HE-Meta: U2FsdGVkX1+8Vu+tqkm4VlzLdc1zqwzsY4Klb1LqrrF9IdDGVgCz+2lgzlYhblSupPHBJtr858VRUonqhKID1wn/e/KZ7UO/TWltm9KflW9k5NNWNbcY//BXqnbzDUTCJM+5cqw3Ukq6RfvjozHiI45/fnHrpC4101jOYEfG5sJubeXcLrw25KMchFnv/o+zlcaYtLltXASxD9rYmoNls4oskQRGGovEWkQdcAkEUMZDtrBGzKzMo+uYKh4lHwxU1YMf0tYc28wAKzP6P/AF4ExWFWiOolc/pTTnFzBDb24lcA2WwSFYsLiV/Xl1xbGsfrcr+rXUop1t8J16XAXSCqQ5uViJmsz20gY/vL1X0EWpOvgNVgtZWp6erB8qd1N8PPtYKvxxEYFaUhtoIsmkCwAhHs2SOZBqYTR/t4K0AdVkTkow5vHjTP3DN8biEmT54WAa9hrwNd2Xu8adbkks3TyPpEx5z77lsSkEY4/4LStIXlVCFGQezx47OFZrLLYNCWBunHbC0eoU4AsZ0OHlelA/1Jmiw+215wWE/WodbIxlY2C7VCik7KihTNsqL2EBR3qLRrNugcLbr5r3AFu2GiaUtjeUuQnxvntBZd2tdLMFTiyjFK27Fk6j7GCzHtSMWE3hLrj8omjN3Vv+INgaHx2ohtQekWRrIaqgy9A4cfGAP/v37QLSzZ/wgO4GIsgDLicEr4mPfAS7DKpiFoI4uzAIQPDErDCHBKvysl1dmiSoE49oAZORKM+Qn8YaxD/Vz0g3/UkTMM2snH3FbrE/BQgtCQdZ6XZwWobl33+0oUsRMr0JGY+CTsrD8FxzD3AXIn3ebqxurIM2wKJxXd7dV8z6wuedP6+L6suDldI0gkIgp00qApVVls2qr7nlUgydkbZqZ8fb25Oxn6JcGHpH51hTWGyh8jH+9vJ/KHbCLGCUbeW7rF7TdSe32Zb+2WYgjtkn8sfQcZg+o/2UT46
 yNreKjRG
 zXp9E/ciUx7cRl3k0hXSms87uGTyxGM0bkM2RFKToqFrtGxTxx2DxEha1qtnM5V2FVx9O/rvRy1JkQrrj4R0Dd/k5/99+OSU6YEuKl1sLtCWVvu0204UUFyFjeiqOzuWVDxfRRZEwhZEpZTGJr+BOgC0I/qflBrOGbbvDeqfZcHOmgr3Ke2l92TjByeqZ91PS8dptS5PBxIRyHvU2V8yrzFpNbtTQ0SOQ/zl+nJi+PpNUBvn2uFH3PgR6rs9c8eTbnboyXo2swL/RtcqaRbD0jlsGRx3B71oeHyCcV0UXYcAJK2TguS72nKtZ/LjUnCnBAxtV+LpCEKQ4LSNNrrzSLZKspLWLg6F9N2JjrkWdFEtxa7Em/V2Ag5j6gkSK3wz88XpGPf4N5kjYa7U8wWoJXH/DNw==
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
index 9a0a2fcac7c7..e7264f0cf5ab 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -446,10 +446,6 @@ static void pde_set_flags(struct proc_dir_entry *pde)
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



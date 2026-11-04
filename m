Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2E836073520
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 21:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XsJ9j0H6
Received: by kanga.kvack.org (Postfix)
	id 0D6706B05C5; Wed,  4 Nov 2026 16:15:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AE236B05C6; Wed,  4 Nov 2026 16:15:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDF846B05C7; Wed,  4 Nov 2026 16:15:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D11406B05C5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:15:49 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 689D5A087A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:15:49 +0000 (UTC)
X-FDA: 85398693618.25.7A40C9E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 896CF40005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:15:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XsJ9j0H6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793826947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U0Q59UIduh0leqoTNjBQdzQ852kkwJeXSefjhRMqGGg=;
	b=UaSBxcMlcNr1pslPTj1dAP3WpsTUEQaMCuwp90So/ULAVWy689pxrZkzBe57jNzEc4KLTa
	rFxummdtXS21a7H08mPW/AoVcoCRanzqxIU8y70bNDUIxCyqiYDt4jsV0vpY6pi8B4mBZk
	/HNnEgULmwLK8jOXNSPkv1A4ufh0s5w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XsJ9j0H6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793826947;
	b=jnkjsa/qhBKtL+sayNGlUpk8VYGbgJqchDx4ATzbS0fIEpfNG/14SV2EQISQR6QLsr1RSs
	IC4JVsNjdCJ8mhFREqOwdGW5TscwdBXo0SnAobYk+kEWDBTUqKIbo3yORvnVjRyyfhB/vc
	HjPaVJjg9Yv7GXSHJV25k7uq64eBZyw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D99C0406CD;
	Wed,  4 Nov 2026 21:15:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9556B1F00A17;
	Wed,  4 Nov 2026 21:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793826946;
	bh=U0Q59UIduh0leqoTNjBQdzQ852kkwJeXSefjhRMqGGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XsJ9j0H6OvH2xmul+I8RCLkCIDHwfVS2h1WcR8ex3uR33mFI4dv7bX75u1V/lq9Th
	 e3cQJcDfXH0oBvbVBiCxzCuZBF/kUt7/WGEyFuNmetycA2rp625zCNXEnQWLCsg3vb
	 I3vCa74KtBf7uVyAQYT0U/bAb5WcPqXSOuBrIkM1pihzC2kiTsYexGyr6Ge93glCGP
	 5L96zjzXf89GnsjBkzG+bRkGLqMWnowLYK0X36Pg+BqUFewEuqPfG8BHF8Oj693ReJ
	 Ej3/yIlh72Ot8OQdw0EMP/VkK3jqsSgsLZulOLdCFKl/8ACtguIEQRWl7bcOHj2mse
	 dv1UN/d7yttyw==
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
Subject: [PATCH RESEND v2 1/6] proc: drop ->proc_write()
Date: Wed,  4 Nov 2026 22:15:32 +0100
Message-ID: <20261104-work-procfs-cleanup-v2-1-1e6687e226b1@kernel.org>
In-Reply-To: <20261104-work-procfs-cleanup-v2-0-1e6687e226b1@kernel.org>
References: <20261104-work-procfs-cleanup-v2-0-1e6687e226b1@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2724; i=brauner@kernel.org; h=from:subject:message-id; bh=3hPyxu11MJgR3rDFwzfEyodOiIRJzbX1gGrYBEiGElQ=; b=kA0DAAoWkcYbwGV43KIByyZiAGrroF2jlnE7hOSrOFIlSi09/aWFMXXkeIhD2GSgzI6duNilE 4h1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmrroF0ACgkQkcYbwGV43KJq8QD/Vky5 A2Z8MSQ0aAGkGOqqTwozgfQm5IJyxvXF2YWkxGkBAIHluATSm7ZvI8nyU5xxvJsN4r7sYjGRfY4 pZP42K2gH
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 896CF40005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: wdtapk7fab17wnkz6s8jz9fgccu5w137
X-HE-Tag: 1793826947-957329
X-HE-Meta: U2FsdGVkX1+cyDlLbULMgdPFB5Jx6+wbxth8SDkrsGpCRD1NI+xxlZ9e+ncpyFt54XDC31jV16ukgKZsqCSCDIp6e1lIXKgRfqc+mJKhhOnumtkZ4Ymrem2X30jHGssA54cjO9C2jaD29i2WR2CZHynycaH8icA5wSUbpkPd6yNoQoe7gTvEgjvu+kFxIzY9DMxVfCIzQ61Jv4+sPx5uK1bnC0zwAdItx46NcrUtzkfOKa/lMXJLWw2uWRJegT2uM48yLTB+WbFiMRem7mVxj5wiyNxE66wt+vJ6v2Dm9jXM1qBwvQV2aQspwEd0vA/oIJG20JCRnVLc+OY56wMDyUv3mfzIKtmJbtTTCGT0qrz0hZsc2joyDDkbZMoeXdStkwX2tL6za6M2aEGxio66h3HPOz1Z7BYmoXH7pehEHaCwjijjiYcanwhie6wCT6BbSGM79fIdFVQWGROZ+2juqFG8Rbtf4TkQIKOA9L3ipfUSNmdyQFg6RtLPR4xdhbO668xHYo4812BZJI47YV6emXR9vmjaO/sx20JXUfqnlk/UJ6bPERARS82XM1KlwuDNGZSJUoigamKdxkTtGkQ3gAaia8LAW5/Td3Bo/36XnUhZl4HpgC/7kyoX1QJSgrySHOx3vP0wwAlDJvCV7L+Jb+KWZBVjfRwcTS7XNewGtM8AhDPW1BfcxTlmZNHbdSayvhI30vEIQ4Yvk5mudqYsxW2uxhWP9iuscZz4DGWcecMi0BrUduE8LCaakZMaSGr8SuxYxCfgJRw6xzgxAKPjj+9Pzz0dX+8cD5NX7cTlWMW6UnJFnhFZTC9SaDDzW0cAK0jmhm/5BTlvc5vamAA5iMhDaukbHvB7/ck+NCrjV8pSliXybRYx20eomffxDHfT2QV8Cu7EgRAhHN+cUiKQ4QBbaDz4LLY2lkPti3/BXJoIrcH2M3Vr+drqQMUNfYLavYNqT+airGegI3EkDdV
 Ruf9dFh/
 NzMLDpZd3IY2At4ZKz4fM8kwLCrOc+cj6ptkU7sut4EWTaR1R/oI8uzzPh6DsWJ2+hc5spdt/g4OOsggm4cPUNwDyDA5P4HTucAJoYwxtO3R56hb7a1esD+9sClXiPFs9JoXGHC8U6OiAq7/qYkg/FKDlbMxDLiLkUFhk9PbBEhwnhEIZ+Qf12tE80Dp5xlADCws2fcSOFj5YSYZHURDiNhQumh1NtsnScFyO4srjgeFM19bgDXkI+0fSAFqcj3Ab5gn6KlMZGn088c4bbbx4MEVze8XBX7BhrSc1JBEEuvMZBDdqnEfTXr44Ls7Y53UT3/IW4W9j9y5vEfI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Every writable entry implements ->proc_write_buf() now and procfs
copies in what is written before it pins the entry. Remove
->proc_write().

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/generic.c       |  2 --
 fs/proc/inode.c         | 15 +--------------
 include/linux/proc_fs.h |  1 -
 3 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 9c073cb867e5..e3ae11805c0f 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -473,8 +473,6 @@ static int pde_set_flags(struct proc_dir_entry *pde)
 	if (proc_ops->proc_mmap)
 		pde->flags |= PROC_ENTRY_proc_mmap;
 	if (proc_ops->proc_write_buf) {
-		if (WARN_ON_ONCE(proc_ops->proc_write))
-			return -EINVAL;
 		pde->flags |= PROC_ENTRY_proc_write_buf;
 		pde->write_size = proc_ops->proc_write_size ?: PAGE_SIZE - 1;
 		if (proc_ops->proc_flags & PROC_ENTRY_SHORT_WRITES)
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index ab30a58879d5..a7ebbe334afa 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -508,14 +508,6 @@ static ssize_t proc_reg_read(struct file *file, char __user *buf, size_t count,
 	return rv;
 }
 
-static ssize_t pde_write(struct proc_dir_entry *pde, struct file *file, const char __user *buf, size_t count, loff_t *ppos)
-{
-	const auto write = pde->proc_ops->proc_write;
-	if (write)
-		return write(file, buf, count, ppos);
-	return -EIO;
-}
-
 /*
  * procfs copies in what is written before it pins the entry. A writer that
  * faults on its buffer then doesn't hold up remove_proc_entry().
@@ -550,15 +542,10 @@ static ssize_t pde_write_buf(struct proc_dir_entry *pde, struct file *file,
 static ssize_t proc_reg_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
-	ssize_t rv;
 
 	if (pde_has_proc_write_buf(pde))
 		return pde_write_buf(pde, file, buf, count, ppos);
-	if (!pde_pin(pde))
-		return -EIO;
-	rv = pde_write(pde, file, buf, count, ppos);
-	pde_unpin(pde);
-	return rv;
+	return -EIO;
 }
 
 /*
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 8520b18ce1f7..8c406f4d09a5 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -77,7 +77,6 @@ struct proc_ops {
 	int	(*proc_open)(struct inode *, struct file *);
 	ssize_t	(*proc_read)(struct file *, char __user *, size_t, loff_t *);
 	ssize_t (*proc_read_iter)(struct kiocb *, struct iov_iter *);
-	ssize_t	(*proc_write)(struct file *, const char __user *, size_t, loff_t *);
 	/*
 	 * mandatory unless nonseekable_open() or equivalent is used, procfs
 	 * seeks seq_file entries itself

-- 
2.53.0



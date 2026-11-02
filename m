Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AC96608441D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QF6gmPvv
Received: by kanga.kvack.org (Postfix)
	id 5444E6B0605; Mon,  2 Nov 2026 10:28:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51BCC6B060A; Mon,  2 Nov 2026 10:28:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40B346B060B; Mon,  2 Nov 2026 10:28:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 121A56B0605
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:28:03 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8DC278017F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:28:02 +0000 (UTC)
X-FDA: 85390559604.16.3F9B004
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id C843340009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:28:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QF6gmPvv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bHsrJPm/ZeqC2f4KHWHp4g5ab6c3NA3BCncgylXTsH8=;
	b=j+2klSKI09PgGRUSF94B84fdVwSWYFNdn+TxHiTjPb4z/gCejWtZ4o7SuKeiwhvTwsaLzx
	MUOhr62y5xvIWP+oDL3g5NkGpqK04GWwqjr8q7II0DF5XXoF/kUKYNRKg8r2wM1Lz/aR4S
	Ll2zlMaZC6R6KfFDx0oOEWMvA4y3jmE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QF6gmPvv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633280;
	b=NENm9wS64Pu+n2Mjmtlzrhm6e+F3C6yA+gzWzxbhik4ofFdCv4g0Efg6z6f25mmeYjfg0x
	8UNXLv2KmjA4quly9vdfg1djEbt/xDJUWItzJo/UD4LYYY9s9utm9D8E202aO+Z6GAL2dF
	LhRkNkgBzObZVHbN+kJY3DLjnSXBNVM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5CBB46060F;
	Mon,  2 Nov 2026 15:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6F21F00A1A;
	Mon,  2 Nov 2026 15:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633280;
	bh=bHsrJPm/ZeqC2f4KHWHp4g5ab6c3NA3BCncgylXTsH8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QF6gmPvvMhVIUnvfEWpOhclpup0CA8TlPXjbdyZoJ5eHHottSdWyEB8dnEL8gE+16
	 +NMTcLA+lSyxfB4A2sssxnrjT27TURn+q9fb6EnoUxg8Yyx0e5WuEJiSfN7UK64Yk7
	 M71NEt3PF9V3opwc5qhvB0ySjBgQpSnX6SLvetxtSlWQ7UbJBBm0cEI8Db9z+OfJiT
	 UbqSRDXLlT+u/FwUviVKJjrbliPxSHAfAfK+6Du50Xl8/IUrxGmmj6PAamNXmVtJwr
	 rFI9slgiDJSCwopklmTL0/5bZsDu9nFx5+BzfkNZYS3VgFas5NIMFcrO4XgsNGTkjG
	 Cn31JaQ8gITOg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:33 +0100
Subject: [PATCH RFC 23/27] alloc_tag: let procfs own the seq_file of
 /proc/allocinfo
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-fs-v1-23-d09a996317b3@kernel.org>
References: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
In-Reply-To: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2428; i=brauner@kernel.org;
 h=from:subject:message-id; bh=OegWGZzazPKoDyS3ACH3h7I4I60OObQ5gHBtJminp7E=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG5s+6yxUv34SeXi7J5n7qzCAkVZxT8X/Pb00xL8E
 VB/8254RykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwES0jjP8T/88X+a04N4pxUkm
 8SeS5KbZ9Jb57p5yoEJPwC/q3ENFT4Z/WuFSu3pmln4JyBR9cuVT175i7j0sp/TvFR349iDBQ0+
 JHQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: C843340009
X-Stat-Signature: cgyzfzeuwtnkrku6tnifhiqnfwsn16h9
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793633280-845265
X-HE-Meta: U2FsdGVkX19jtDW2ON1YcVNCjb0fqZtSWpTecIBmJ4oZwMN/Y265dciubTERCKBNwSkWmXKgvbPLt9X/U/3uOPS8xjQqwrhZzzWPsjWd2p9N3K/sw1QD37dwUJpm18Mab+aF9m9KEdxcxXDtwvKpomUpirAEsOoWlmJYvRneuZLEkQZOXBf+s8PA+POfowAlw5DDLBSODtPMT2yaxclz3GHTBtSDTOtwpL+cI7rLOgSLAec5HEOnBXPFG1hPBzCOMULGKnL95sAWWRWr3g0kLMc1yQpCQgqwePyrGVFZjcbdaQO029Kp0E+nSoTjE6A4yrvTsyCnjTxmYqeVM1uUUVcvvlSQHFsRZBo0ZOe4sbiY3zhC8wwc/pdk5ofQacVJQ73wy+VVEXb4BKh9Hu/TCJoWjVJq6Sk+ylenCEctP1gcaVnlno1IgJ+CKGsnA1wZfFIGehBN7FWaKQIzji9fEfNDQNapnfJXdc5ZEeoYAn2jt5oPt2EDFZH4kVkF8tVYmaZoW2S2XxP1mH8Du6xv7JrVOAJ5CCHz1wKvXHMoc8kunT0cNhKkGh1Pn4kQjY2qzV/RSDtE0Z5CQJvLm5+FjTHpDJtSyT7cDtd7G3QfKjcev2V6lISJFfUBrS7prl1eqzsRoIXzUGbpGozU/v05hpXkjoYhLY7Vzcm3bqo8W5u2Wr52fwlUWXYASNCvVp0OnwjtNnSH3zrraPZsuPcun/h1ZgGgiSWTAera2eT2l3L77u/O2yPrIqm+djhIQc3wDlSaedwY1hdH25ktZz6DvUMFRdc5Z7wu1w1vPyeDLSJA3uH7auXN+1ajQuXwshNkx6yL3adknFNfAs/zN4Cm05hzqeHKJL4e11LcNiRiLNTJw+NSkCh+59rK41H5zRygZUjX8AqGueqKvP98A3Sdmn7IJBI/6saT730iKuYM+52N+vB2AcMQc3Vfoza44aL/YjPgcTIEymSZ0yIu/3S
 9Gia3jAD
 brnk7HSqHKv9/bLnraAyk04uPsHZMq3hLY9bF0r7cGyBv1REqlVEIBwWJz6cIAQAVreF7l6vT5z2NzjBc45hS8YLs707AKxik76kzJc6nfXVxMywCjhUilqg0abpc0MDCj5o66Qw81D0ZBLBM0IRCgca2kAJbMjEbj8zbLVHmrLCylt80BYSCX+f/1CG0XszS9blKbZy1EsD+xkZpue8scofJiQAnGae41EDHNktwiYxb/FmEMXpDJ4MkIyEf6fDxfK4H285kD+25rNhUR71OyDpj94nnnPwU6l95FdASSTPBEyc8Qfxaor8+nZhD/DxZfz204zCbpcXQl1A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the seq_operations and the size of the private state and let
procfs open and free the seq_file. ->proc_open() and ->proc_release()
only set up and destroy the ioctl lock now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 mm/alloc_tag.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 82e2c3448dcf..788c9d7f7151 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -151,27 +151,21 @@ static const struct seq_operations allocinfo_seq_op = {
 };
 
 /*
- * Initializes seq_file operations and allocates private state when opening
- * the /proc/allocinfo procfs entry.
+ * Initializes the private state when opening the /proc/allocinfo procfs
+ * entry. procfs opened the seq_file and allocated the state.
  */
 static int allocinfo_open(struct inode *inode, struct file *file)
 {
-	int ret;
-
-	ret = seq_open_private(file, &allocinfo_seq_op,
-			       sizeof(struct allocinfo_private));
-	if (!ret) {
-		struct seq_file *m = file->private_data;
-		struct allocinfo_private *priv = m->private;
+	struct seq_file *m = file->private_data;
+	struct allocinfo_private *priv = m->private;
 
-		mutex_init(&priv->ioctl_lock);
-	}
-	return ret;
+	mutex_init(&priv->ioctl_lock);
+	return 0;
 }
 
 /*
- * Cleans up the seq_file state and frees up the private state allocated in
- * allocinfo_open() when closing the /proc/allocinfo file descriptor.
+ * Undoes allocinfo_open() when closing the /proc/allocinfo file descriptor.
+ * procfs frees the seq_file and the private state.
  */
 static int allocinfo_release(struct inode *inode, struct file *file)
 {
@@ -179,7 +173,7 @@ static int allocinfo_release(struct inode *inode, struct file *file)
 	struct allocinfo_private *priv = m->private;
 
 	mutex_destroy(&priv->ioctl_lock);
-	return seq_release_private(inode, file);
+	return 0;
 }
 
 /*
@@ -474,9 +468,9 @@ static long allocinfo_compat_ioctl(struct file *file, unsigned int cmd,
 #endif
 
 static const struct proc_ops allocinfo_proc_ops = {
+	.proc_seq_ops		= &allocinfo_seq_op,
+	.proc_state_size	= sizeof(struct allocinfo_private),
 	.proc_open		= allocinfo_open,
-	.proc_read_iter		= seq_read_iter,
-	.proc_lseek		= seq_lseek,
 	.proc_release		= allocinfo_release,
 	.proc_ioctl		= allocinfo_ioctl,
 #ifdef CONFIG_COMPAT

-- 
2.53.0



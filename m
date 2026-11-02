Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1AFD6072C60
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VTLKN1wP
Received: by kanga.kvack.org (Postfix)
	id 019E76B05B1; Mon,  2 Nov 2026 09:49:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F33596B05C4; Mon,  2 Nov 2026 09:49:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E49C86B05C5; Mon,  2 Nov 2026 09:49:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C02C86B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:49:44 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 557591C1115
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:49:44 +0000 (UTC)
X-FDA: 85390463088.20.E7EE5F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9723080014
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:49:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VTLKN1wP;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793630982;
	b=xVuIaD4yIawM28/64qcXbu6M9DM4lYQX+HQmVmWzAbMxju96YMx/SONx8Y+yhSUKYpgF9c
	EvhBr9x5PNRJeywomyPC+6EPAwyPZ2E6ogfLAviGFXtgEmi0ek24mLiTZPIfTzcdG9nuEo
	7ZRKr0M3hhtEhPAvUzb7qC18B5PDinE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VTLKN1wP;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793630982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KbfF7FDKuD8IgpxmK4NN79tddC7YrY9Y/+M606VrXfI=;
	b=OYQVfm+9gsyQHmBCuaSZEwdnIBU2BW1rulBs5FrypH1dYW0LvS2IwFc3sBfVIB+M+i/9mf
	UodqilaZeZyXg6N6D3r775PhZD/3qS6RoQuMv8Som9VcrjPbW0FRoJ1Lp5+InhMIzrNPvO
	2R2Bgd1Uy+U4CPj+Nx+2M2B1Hne86QE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CFC6942D8D;
	Mon,  2 Nov 2026 14:49:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6901F00A1E;
	Mon,  2 Nov 2026 14:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630981;
	bh=KbfF7FDKuD8IgpxmK4NN79tddC7YrY9Y/+M606VrXfI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VTLKN1wPsT77GXedBbfUnvAt3ZoU7sew0DlQ6CDb1yQtAYUOGaK37/vahZM8mEt3V
	 KNlm7TNpeloU705YEFADDRXgb1PNF0htEEYt3ZevyltU7KddsRtahLRmp+qVB1QsTd
	 d1RDDQ/dsYO4l943o0Mo5EdJqDBAb7oifdScdluIUo115yD9FyncmfVWtP9AkD23ow
	 tjXAJUkgvsgAuYizPSgyetMJFRgtBO7xSarrqvzcn+4yaB6a8qaJUaOxhh7jACwPeW
	 M76RUCqdpHd1iPp6/uReiis0Y94YYZahNZgzE5Coy02hiikfQy+mq13Dy1CXaqsGBr
	 UxX8A03XOhI7g==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:48:42 +0100
Subject: [PATCH RFC 02/16] proc: add pde_pin() and pde_unpin()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-core-v1-2-75df35e4f8b8@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 9723080014
X-Stat-Signature: 8q98pwnuqetomuqiksc8smqaawuogthe
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793630982-782848
X-HE-Meta: U2FsdGVkX1+/2ebn1YHn32qYdoIfu+GpYCnAWCLEtOY4M+f0P3GIsD2U1wuVspWrPruL2bcF6CdA3qSR6U7zMIC6TOJHCyJBpeMQDeuVG1rmoxi8N33qxg79laCyBSw1TVkM2owusMtuhsLMheXu5sbmdE0V81qzAFFBhswJFMYKjImyGBQ/w7QY0ClmJ1gJj3rll4iU7aFf0U3tkcjClk52kFDIxIngL5WjA3vvkWTI6LR8zG7girAb9a40f5sONgIAyQ5p9BRZZ5tMYkpiaOpcXeRi6DVkBoa5/KotK8PJVXVNHVTtpwCYFBmXffnB4lqKTomQ66OX6S5APpYXGE+1Cxnf9SmRtRy8zmEzyIdZI4ZtwWypSZ3AMiUCJd2bwRTs53fYIUURV67MMKKR5FiBxeyvg9HP7LUUodH7TRR1dSQonaClrZOXiey/JeGVDtWtwVVgWIBcO7LTNBUql2qr9k8kmmE1MsdS3mLAIlDk8U8Lts9OmUs5WdAcg3jmz+5WpOBZekoKfp34wz8zTXrDDYBXSHgOvx69lUuR4WsAY1sN2zZe8OPnjOmOq28t/xIBsYrnrBZzVwOMsK96TDCmQA4kM0jqef9v+6pReBFoRI60dt9i8GBGPt82XqS42uYSGIBgijUKZWS+2BmZiHzOdknId/hDKsGpDbPL4sKEG8uB2jt9Z/fj5OsostfidKeVYp+yRbsri/bwYJA+Sp0IvK6dRlPma32+6vtD0GFblpxAglJqGr9JvITjXNWLEEzKvPKy7/LI6MNg/GvPYMFkdX0o2wGH7sgk6StRX2jB32z1cELfvYzNmdocaGXuRZUU+EIFuA4MphjI1/6gd7HXnmTdTz2roKn7qOcgaV1JO5mD5QH2fv0isv42MGA2mE6IwoRgmVH5ha/bTtyzkTaTnHf12M/Qmn22Vs6QC1wajGlqZvFh3zs0njtlBYyXae0NcV/cuGvg73/Bcct
 tLMcr0N6
 uYIgd/4H6zOY3va0DtFcUUxRYGJ7DJym9FfCqvybmqs/zb09JF/n96iPOEfUnhthrOAJeaOjf2VRUPl5qyT/hAE4/GpicLFFNfj4zbJLVMEnMyP5T4eRcOfZTsINp8OFHJ2eU8pCMwkKmpSys4kIFbyVmuYccF678Xbo3lMDulNc/XpdAt0/mH6u+uf27oEOtVeBZChIlxiUgBUKFsOQYQFFO4sLNckYBlDQ3iuB6DGpNlOSJHq1/U+ik89avw9KDOYh+GRFO2xVFZYJj2xGaqltGtcruyQJ68tp4rb3jbuoSIakbPmZjgR03danc34lrCZV6ynL3S3+DhBQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Every call into an entry that can go away is wrapped in use_pde() and
unuse_pde(), and a permanent entry is called straight away. The read,
write, poll, ioctl, mmap and lseek methods all spell that out as the
same if-else. The next patches add a few more callers. So put it into
pde_pin() and pde_unpin() and use them everywhere.

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/inode.c | 116 +++++++++++++++++++++++++++-----------------------------
 1 file changed, 55 insertions(+), 61 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 18f6490bfe77..66a3688757dd 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -206,6 +206,18 @@ static void unuse_pde(struct proc_dir_entry *pde)
 		complete(pde->pde_unload_completion);
 }
 
+/* Pin an entry that can go away around a call into it, see use_pde(). */
+static bool pde_pin(struct proc_dir_entry *pde)
+{
+	return pde_is_permanent(pde) || use_pde(pde);
+}
+
+static void pde_unpin(struct proc_dir_entry *pde)
+{
+	if (!pde_is_permanent(pde))
+		unuse_pde(pde);
+}
+
 /*
  * At most 2 contexts can enter this function: the one doing the last
  * close on the descriptor and whoever is deleting PDE itself.
@@ -275,14 +287,12 @@ void proc_entry_rundown(struct proc_dir_entry *de)
 static loff_t proc_reg_llseek(struct file *file, loff_t offset, int whence)
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
-	loff_t rv = -EINVAL;
+	loff_t rv;
 
-	if (pde_is_permanent(pde)) {
-		return pde->proc_ops->proc_lseek(file, offset, whence);
-	} else if (use_pde(pde)) {
-		rv = pde->proc_ops->proc_lseek(file, offset, whence);
-		unuse_pde(pde);
-	}
+	if (!pde_pin(pde))
+		return -EINVAL;
+	rv = pde->proc_ops->proc_lseek(file, offset, whence);
+	pde_unpin(pde);
 	return rv;
 }
 
@@ -291,13 +301,10 @@ static ssize_t proc_reg_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 	struct proc_dir_entry *pde = PDE(file_inode(iocb->ki_filp));
 	ssize_t ret;
 
-	if (pde_is_permanent(pde))
-		return pde->proc_ops->proc_read_iter(iocb, iter);
-
-	if (!use_pde(pde))
+	if (!pde_pin(pde))
 		return -EIO;
 	ret = pde->proc_ops->proc_read_iter(iocb, iter);
-	unuse_pde(pde);
+	pde_unpin(pde);
 	return ret;
 }
 
@@ -312,14 +319,12 @@ static ssize_t pde_read(struct proc_dir_entry *pde, struct file *file, char __us
 static ssize_t proc_reg_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
-	ssize_t rv = -EIO;
+	ssize_t rv;
 
-	if (pde_is_permanent(pde)) {
-		return pde_read(pde, file, buf, count, ppos);
-	} else if (use_pde(pde)) {
-		rv = pde_read(pde, file, buf, count, ppos);
-		unuse_pde(pde);
-	}
+	if (!pde_pin(pde))
+		return -EIO;
+	rv = pde_read(pde, file, buf, count, ppos);
+	pde_unpin(pde);
 	return rv;
 }
 
@@ -334,14 +339,12 @@ static ssize_t pde_write(struct proc_dir_entry *pde, struct file *file, const ch
 static ssize_t proc_reg_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
-	ssize_t rv = -EIO;
+	ssize_t rv;
 
-	if (pde_is_permanent(pde)) {
-		return pde_write(pde, file, buf, count, ppos);
-	} else if (use_pde(pde)) {
-		rv = pde_write(pde, file, buf, count, ppos);
-		unuse_pde(pde);
-	}
+	if (!pde_pin(pde))
+		return -EIO;
+	rv = pde_write(pde, file, buf, count, ppos);
+	pde_unpin(pde);
 	return rv;
 }
 
@@ -356,14 +359,12 @@ static __poll_t pde_poll(struct proc_dir_entry *pde, struct file *file, struct p
 static __poll_t proc_reg_poll(struct file *file, struct poll_table_struct *pts)
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
-	__poll_t rv = DEFAULT_POLLMASK;
+	__poll_t rv;
 
-	if (pde_is_permanent(pde)) {
-		return pde_poll(pde, file, pts);
-	} else if (use_pde(pde)) {
-		rv = pde_poll(pde, file, pts);
-		unuse_pde(pde);
-	}
+	if (!pde_pin(pde))
+		return DEFAULT_POLLMASK;
+	rv = pde_poll(pde, file, pts);
+	pde_unpin(pde);
 	return rv;
 }
 
@@ -378,14 +379,12 @@ static long pde_ioctl(struct proc_dir_entry *pde, struct file *file, unsigned in
 static long proc_reg_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
-	long rv = -ENOTTY;
+	long rv;
 
-	if (pde_is_permanent(pde)) {
-		return pde_ioctl(pde, file, cmd, arg);
-	} else if (use_pde(pde)) {
-		rv = pde_ioctl(pde, file, cmd, arg);
-		unuse_pde(pde);
-	}
+	if (!pde_pin(pde))
+		return -ENOTTY;
+	rv = pde_ioctl(pde, file, cmd, arg);
+	pde_unpin(pde);
 	return rv;
 }
 
@@ -401,13 +400,12 @@ static long pde_compat_ioctl(struct proc_dir_entry *pde, struct file *file, unsi
 static long proc_reg_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
-	long rv = -ENOTTY;
-	if (pde_is_permanent(pde)) {
-		return pde_compat_ioctl(pde, file, cmd, arg);
-	} else if (use_pde(pde)) {
-		rv = pde_compat_ioctl(pde, file, cmd, arg);
-		unuse_pde(pde);
-	}
+	long rv;
+
+	if (!pde_pin(pde))
+		return -ENOTTY;
+	rv = pde_compat_ioctl(pde, file, cmd, arg);
+	pde_unpin(pde);
 	return rv;
 }
 #else
@@ -425,14 +423,12 @@ static int pde_mmap(struct proc_dir_entry *pde, struct file *file, struct vm_are
 static int proc_reg_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
-	int rv = -EIO;
+	int rv;
 
-	if (pde_is_permanent(pde)) {
-		return pde_mmap(pde, file, vma);
-	} else if (use_pde(pde)) {
-		rv = pde_mmap(pde, file, vma);
-		unuse_pde(pde);
-	}
+	if (!pde_pin(pde))
+		return -EIO;
+	rv = pde_mmap(pde, file, vma);
+	pde_unpin(pde);
 	return rv;
 }
 
@@ -457,14 +453,12 @@ proc_reg_get_unmapped_area(struct file *file, unsigned long orig_addr,
 			   unsigned long flags)
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
-	unsigned long rv = -EIO;
+	unsigned long rv;
 
-	if (pde_is_permanent(pde)) {
-		return pde_get_unmapped_area(pde, file, orig_addr, len, pgoff, flags);
-	} else if (use_pde(pde)) {
-		rv = pde_get_unmapped_area(pde, file, orig_addr, len, pgoff, flags);
-		unuse_pde(pde);
-	}
+	if (!pde_pin(pde))
+		return -EIO;
+	rv = pde_get_unmapped_area(pde, file, orig_addr, len, pgoff, flags);
+	pde_unpin(pde);
 	return rv;
 }
 

-- 
2.53.0



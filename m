Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E3BF606B1CB
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eyNIQCxY
Received: by kanga.kvack.org (Postfix)
	id 015FD6B05E5; Mon,  2 Nov 2026 10:08:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2F376B05E6; Mon,  2 Nov 2026 10:08:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6C966B05E7; Mon,  2 Nov 2026 10:08:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B89296B05E5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:08:29 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB06140138
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:08:28 +0000 (UTC)
X-FDA: 85390510296.30.AB44423
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E72972000F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:08:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eyNIQCxY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dp7sSooWMguSrSQWYm7n5WBM775aoRxhTJFL+eJzfGM=;
	b=ALltzrwwfcSSPOANCdolqKeKFpgXb3jk40F7G2gG6yrQia0chutyb0oaOzutxW0z8fOXFn
	9LWKPjlTCon089RARICIPImn/g6rU72rfWpVCq8bevKQ7ykoKbaBwurA7JDzkGsHr8Nf0u
	0ZVYEN2s7/7BwPMFIpXiXb0cmyk8dVg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eyNIQCxY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632107;
	b=dLJmKXMH1C+8/Xlvafk5YgnC4rWw4Tr6TJdALRQml9MP9SWCwL2Vop60LgsQrp8nqVJlw8
	VWYFvU/q7yA/ZBw8PZBibLeISEG6VqIwBZMjAaCfcPL8AWTaw4/O2LZXrUyH5oKQyZpHiA
	EsAKsIoK8o/HxrSWmSsRPcNgA1gD82Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 39FC443A0A;
	Mon,  2 Nov 2026 15:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E931F00A20;
	Mon,  2 Nov 2026 15:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632106;
	bh=Dp7sSooWMguSrSQWYm7n5WBM775aoRxhTJFL+eJzfGM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eyNIQCxYEcRLLrGyZcPtIprIvg2rkuSpaKrMvW58hJQxt/VyWt7hS3Qal6zoUQ/gl
	 0f9cCCPMX1bOMUh9BIWeFK5f4ATpN0EM/aPUrffzJ9XwWlsu4eKD6ZgzUlwDjfLjwL
	 Uvn00wNomN8/SMqh9jXER44dMwsdR9yWd6JSqBhqRXPHK14atBxuYmQ+rYaoEBUKUD
	 vDmMOPV29JIfjjL6fBW6U6eWYBA/B7Lc6f6IJGDxAZNs993WFUAYbhkuu/ueCEe0L/
	 Yqu69q4QgN/VaqD5PYjScQjBFfvU4mejG6swjL58FVzjyKA2XiENQnp0sJJnQeShIQ
	 zmvRe7kDYECMg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:01:47 +0100
Subject: [PATCH RFC 20/22] platform/x86: toshiba_acpi: let procfs copy in
 writes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-arch-v1-20-c9492ab08480@kernel.org>
References: <20261102-work-procfs-arch-v1-0-c9492ab08480@kernel.org>
In-Reply-To: <20261102-work-procfs-arch-v1-0-c9492ab08480@kernel.org>
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
X-Rspamd-Queue-Id: E72972000F
X-Stat-Signature: xgsrgqkkehw4uti1mh99zybgp79b7pdg
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793632106-237813
X-HE-Meta: U2FsdGVkX19GdUM/4gfzNu6G/SR8VDlCETkgavQSdT7veu6EqPg5KB1PPhM2nc4te3xVouaRoFyg2q5UlALW+rdZH9nVoqWBYLuzTBytZWphs3u5P/5Ja38QScRib9ng/2stAHI8wTMlqH416MeXZKS56PXrsLOBYCd1lRnk6uF/rjlqsLOEe1QgoPB0/ThvMJh5aBV3lcDDbi0RxHBPiBOVZw9yvb+s6aozRXSFMszMhrKtNSuAGt1zGA9OejoQPUx9w51fgCtr+TfEk0O7qyCZtYZOq/FcNkiV6GddM2aZmLc7eaOsUDhWyGbI2JlMkufBxi5PTJv5OVe9uNzgKHetn0chSkDYQ0csE2XPBjrcALf7Y7KNR3ic8WgIMtvtYtfOhx0eb4nnvyLzWZLVfoIZUr+7fB8+8rnrPUSIRD5AfvXCXKr+nj+5s8DC7/l+2OwAcevTF8opz5ibiLBka8cAWAYQOiYmZZk2oOY9/D/D3yXTcZHh2+Yk4p1/Hx2Affz25Md1ju+DHpmkU/57d01ZWEokMiysD4brIoIJdp2ZZH2lLEP3n5CYj+4LWVLnYNCTE7ZeBe2F8eLqY6WgGhrQlGAfjy0d/6+CRHxpHmO2HNUvXHofeNDbkAYTYsVe72dSnkIki3Q9GsIncQ/4Re/z3Gjb93ORuol9UBKs94c8GRJywf6UArQtc4PUpAFmAxo13r/MWQPufSXCFib2N3YcoUC6SnM8B7UgV9PQ9rN3V9OUYCmBNXJQn2PgtZ9rRkk4lq3bG1/0ykdbTgkxK05a7ZBuwcOCLA1FkX91muw9A6YGAgKXLOB7aKMkGmO2P+o0ZTYGTX6RzUAvY+H832twLkx4AnIN+RK0828qwnoXFv1+IL3t4UyCLoMftrUwDAefjUYn7pC/C9irDqGS/V08zTWnum6lx+hM+Ph5Zdy6sH0qQJ2dYBSysRNAhMkBhx2rVoRheZVb156lyO+
 ujv2ChxC
 qe6Zvtgz0jYUXuzDWqVTY9ye5aFY7pSth5aGWkOl9H6ycR4a8dLiX8qWcObZVD0QR5pOXQ7zEkshwCyXIYo9UrgfADeaD/S0DAXHaOd/6KgdA/GsHfiTGTM92axoGp7TdCi9NRudTj+WBADdY8xuAHXMLQMBrLNKB2ZmdzkQ9qEK4EH44s7Ar61iI16QO2f+2DynHiyLvOrcWTU9cXJAzV+0/yOsCxKuceQPC0fpTFj2PuZclFs+yKeA3VQ6pulFwOwY13LVWSEamR/9FKyM3vMrumTa9miiI4QiRo7KHcna0Ga+L/2dQfyhnf2W/KP0e/mRqxJvB9NKXA6g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() for the files in /proc/acpi/toshiba so
procfs copies in what is written before it pins the entry, and parse
what was written from that copy. Commands longer than PAGE_SIZE - 1
bytes are rejected now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/platform/x86/toshiba_acpi.c | 36 ++++++++++++------------------------
 1 file changed, 12 insertions(+), 24 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 560e62da05a9..895e321ada03 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -1478,7 +1478,7 @@ static int set_lcd_status(struct backlight_device *bd)
 	return set_lcd_brightness(dev, bd->props.brightness);
 }
 
-static ssize_t lcd_proc_write(struct file *file, const char __user *buf,
+static ssize_t lcd_proc_write(struct file *file, char *buf,
 			      size_t count, loff_t *pos)
 {
 	struct toshiba_acpi_dev *dev = pde_data(file_inode(file));
@@ -1488,8 +1488,7 @@ static ssize_t lcd_proc_write(struct file *file, const char __user *buf,
 	int value;
 
 	len = min(count, sizeof(cmd) - 1);
-	if (copy_from_user(cmd, buf, len))
-		return -EFAULT;
+	memcpy(cmd, buf, len);
 	cmd[len] = '\0';
 
 	levels = dev->backlight_dev->props.max_brightness + 1;
@@ -1505,7 +1504,7 @@ static ssize_t lcd_proc_write(struct file *file, const char __user *buf,
 
 static const struct proc_ops lcd_proc_ops = {
 	.proc_show	= lcd_proc_show,
-	.proc_write	= lcd_proc_write,
+	.proc_write_buf	= lcd_proc_write,
 };
 
 /* Video-Out */
@@ -1541,24 +1540,17 @@ static int video_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static ssize_t video_proc_write(struct file *file, const char __user *buf,
+static ssize_t video_proc_write(struct file *file, char *buf,
 				size_t count, loff_t *pos)
 {
 	struct toshiba_acpi_dev *dev = pde_data(file_inode(file));
-	char *buffer;
-	char *cmd;
+	char *buffer = buf;
 	int lcd_out = -1, crt_out = -1, tv_out = -1;
 	int remain = count;
 	int value;
 	int ret;
 	u32 video_out;
 
-	cmd = memdup_user_nul(buf, count);
-	if (IS_ERR(cmd))
-		return PTR_ERR(cmd);
-
-	buffer = cmd;
-
 	/*
 	 * Scan expression.  Multiple expressions may be delimited with ;
 	 * NOTE: To keep scanning simple, invalid fields are ignored.
@@ -1577,8 +1569,6 @@ static ssize_t video_proc_write(struct file *file, const char __user *buf,
 		} while (remain && *(buffer - 1) != ';');
 	}
 
-	kfree(cmd);
-
 	ret = get_video_status(dev, &video_out);
 	if (!ret) {
 		unsigned int new_video_out = video_out;
@@ -1602,7 +1592,7 @@ static ssize_t video_proc_write(struct file *file, const char __user *buf,
 
 static const struct proc_ops video_proc_ops = {
 	.proc_show	= video_proc_show,
-	.proc_write	= video_proc_write,
+	.proc_write_buf	= video_proc_write,
 };
 
 /* Fan status */
@@ -1644,7 +1634,7 @@ static int fan_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static ssize_t fan_proc_write(struct file *file, const char __user *buf,
+static ssize_t fan_proc_write(struct file *file, char *buf,
 			      size_t count, loff_t *pos)
 {
 	struct toshiba_acpi_dev *dev = pde_data(file_inode(file));
@@ -1653,8 +1643,7 @@ static ssize_t fan_proc_write(struct file *file, const char __user *buf,
 	int value;
 
 	len = min(count, sizeof(cmd) - 1);
-	if (copy_from_user(cmd, buf, len))
-		return -EFAULT;
+	memcpy(cmd, buf, len);
 	cmd[len] = '\0';
 
 	if (sscanf(cmd, " force_on : %i", &value) != 1 ||
@@ -1671,7 +1660,7 @@ static ssize_t fan_proc_write(struct file *file, const char __user *buf,
 
 static const struct proc_ops fan_proc_ops = {
 	.proc_show	= fan_proc_show,
-	.proc_write	= fan_proc_write,
+	.proc_write_buf	= fan_proc_write,
 };
 
 /* Fan RPM */
@@ -1707,7 +1696,7 @@ static int keys_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static ssize_t keys_proc_write(struct file *file, const char __user *buf,
+static ssize_t keys_proc_write(struct file *file, char *buf,
 			       size_t count, loff_t *pos)
 {
 	struct toshiba_acpi_dev *dev = pde_data(file_inode(file));
@@ -1716,8 +1705,7 @@ static ssize_t keys_proc_write(struct file *file, const char __user *buf,
 	int value;
 
 	len = min(count, sizeof(cmd) - 1);
-	if (copy_from_user(cmd, buf, len))
-		return -EFAULT;
+	memcpy(cmd, buf, len);
 	cmd[len] = '\0';
 
 	if (sscanf(cmd, " hotkey_ready : %i", &value) == 1 && value == 0)
@@ -1730,7 +1718,7 @@ static ssize_t keys_proc_write(struct file *file, const char __user *buf,
 
 static const struct proc_ops keys_proc_ops = {
 	.proc_show	= keys_proc_show,
-	.proc_write	= keys_proc_write,
+	.proc_write_buf	= keys_proc_write,
 };
 
 static int __maybe_unused version_proc_show(struct seq_file *m, void *v)

-- 
2.53.0



Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CA9C6070CAB
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OWjkcOBN
Received: by kanga.kvack.org (Postfix)
	id 738DD6B05C8; Mon,  2 Nov 2026 10:03:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 710526B05C9; Mon,  2 Nov 2026 10:03:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 627AE6B05CA; Mon,  2 Nov 2026 10:03:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5846B05C8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:03:35 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C14A4120155
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:03:34 +0000 (UTC)
X-FDA: 85390497948.27.88704A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0303D4000C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:03:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OWjkcOBN;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oVeQwusVcdWt+t2MXjuQ/DhAoQowLCWkhlldD+EM/ro=;
	b=jSmh6LUHWrpt9uWrLGmfK0zXvUpHpBiLZx+H1hD+REdyptFysP9dosXn2j3e90zykcATQr
	89Ej68ydTYby/bd9niDnn3v0pjNkzsb6p5e55UvhrYLCsvul95C3PSe6Lq0wh68jdYa/yQ
	tXKTWROy1PiH4q4c2AfXAd0I+eOoniQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793631813;
	b=C/KIGYyFOxFf+u3096vjDAhD5Y6gkaCAjevb8gq4pvthGYy3rGfbNfCcqbjNZCV4T7aCJC
	nQ6DSyA5YGf1OWKTp35LXhaukoal46BGQczCwEhR/GpFGCO9zBg5jP+g65Jj+npj7ZRcBX
	DHhTwOc9tHXghbCzR5wDHYoyVz/Cgd0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OWjkcOBN;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 322F243228;
	Mon,  2 Nov 2026 15:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822311F00A1A;
	Mon,  2 Nov 2026 15:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631812;
	bh=oVeQwusVcdWt+t2MXjuQ/DhAoQowLCWkhlldD+EM/ro=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OWjkcOBNjrMUeTufmvVyzLqLuyvTySsw+dhv5IHxs/hieYtMOgOEszSyAJzpSCxpE
	 ivhlaW3vverSeo9xxXMpCNv4uvFlwTOs2Rxv79ipdQZsAXLlNfjnYXqlikAzK9Rhwj
	 fbSTM45jfTBK7jdKNJHzSS+yPm+jYE9xinTq6+vQkPrWwGMPkbWnlrXkqvWf+SEGzv
	 NUr+FGlXFmobxkkYkI8iFyJMqEYyanfGZehuXpsHLl/Q30PMDmV9NESufDJsqM/FXP
	 RzCWFajSSJkhhGsUeItsbwH1Bh143kv0KKo/cAPN6grVu2VmnCed1H7khCoprygo9o
	 BRZHUp6nTcKrA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:01:33 +0100
Subject: [PATCH RFC 06/22] powerpc/rtas: let procfs copy out reads
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-arch-v1-6-c9492ab08480@kernel.org>
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0303D4000C
X-Stat-Signature: zk138o1tqmeehoax3r34snf3zcrcurj1
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793631812-721164
X-HE-Meta: U2FsdGVkX18SFVWLO+tOX2DqOFx4Ek13ZgPXDlkth/NSCA7HC/y6rgbZlSepCYrtmEwq8qwIprEOMcPagacLf5WI4LSqGOgPxCuS8zE1SHyCL8w1Y7quB4FRUQI/wF0N0XPzPaofEM8pRAse0567lgYz9Ujy/J02BJTO6r0aNsD1LfRngFHet7YHkosWPlijU9IoLVdmn3Bc2X8BIA/II5FYeRe3H6sBsV5MmrG5s5IbkheYtWKok5UyWqDbxQl7lczU7dKYmFIwwiwN0/I/hsARaq4YWHzF++Dx3Liv682b85HFFpEkxLr0csUrApNNMWYSY+jWvvnyWE70KXaI5KsuF519Bwhbx78q2MywfgY/jn2KfUAvCDM7n+upuPz9EUaYymgV6Gr5xejCf0Hb62bOEG9JlfeT/69nXgcKZ1dVgxQGG+06KY4RP12lUZ5TAkZKpFVSX0JUY+oWDieWAPnl99DdrQpVuU8IMO5Lz7qPYaBx3MU44nWWscOgVG272r8BoAgwHeUUYjScXt7ofbqSOrK0SDxCJC0+A+V+B/laGbwq1Q7HlTgwbDCEpeLWRNFxFfohVtBilgaAebqsCeLzj1Ha97ejiPYOtY8a/jbr4IZCySrC+fNLmFMRMGnJ+qs5kT+c69A1+RaxlprqKLmtHoJsB7VBXA/iqDTE0Rp6gdVqKjDMT6rS3GsIlSzDp4Ltm+CFbvdcmgtPZMsZ2Q+QW0lXMXnfqkmNV2ve0ePMSsYcovz572zHnG2/FJU4RqD1wnTwARqQaX0Za8Hc60zfZ5Q7dmpPqDFbo84sgl0nIvDed9QkWWQFWSHhyQZvjY0If0yprrfL/RZ8eeVvnDyQ7cRZ1ep9uPSN83TpW3/3aprAaEQGotwexCdQgrL0P1QG058ChY0IAQ3ep4JuGbD3tk4Aai5nuUqTOOFBHAGzJCruW0g0F136HMiqhPOGL6NEWnTrx8zgRD3XC0v
 WBwaRFVK
 c4zHJWyVZsGCGwG1Hfdd3eJvAc8N9Xcx1kFgmgPRbTRHFXwz2ecqPgp1sUH+ILuRXbiUYPIqqLZY793nHCeBju/OU+VDQxeFBFJFQvwE+qXn/bovY+uXJmo0g4MbpOOHSSX+e+z8X9fu4uulnw0rAPolv9HX3I9yUBbcI3qwnB3qu84A82cCR2/b5euIMZPLh6Aai49OI+OMP45PfRBbIrnNO0EnHAF8q6+3eN/dPE5Gw8XVgAQnWMZULJWHaeWk/C7/3pcfs2z3BNXXrgCnvaQThcGafz1vuRlXw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_read_buf() for the error log and the flash files so
procfs copies what is read to userspace after it unpinned the entry.

The error log hands out a record the way it did before, the record is
consumed before it reaches userspace. A reader that passes a NULL buffer
now loses a record like one that passed a bad buffer always did, instead
of getting -EINVAL. The files can be spliced now, like every entry that
is read through ->read_iter(). Note that a sendfile() from the error log
into a target that fails or takes less than was read drops the records
in between, splice_direct_to_actor() rewinds any seekable file like
that and the error log doesn't hand a record out twice.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/kernel/rtas_flash.c | 24 ++++++++++++------------
 arch/powerpc/kernel/rtasd.c      | 19 +++++--------------
 2 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/arch/powerpc/kernel/rtas_flash.c b/arch/powerpc/kernel/rtas_flash.c
index 77a4627f2507..5ebaee7683ef 100644
--- a/arch/powerpc/kernel/rtas_flash.c
+++ b/arch/powerpc/kernel/rtas_flash.c
@@ -269,7 +269,7 @@ static size_t get_flash_status_msg(int status, char *buf)
 }
 
 /* Reading the proc file will show status (not the firmware contents) */
-static ssize_t rtas_flash_read_msg(struct file *file, char __user *buf,
+static ssize_t rtas_flash_read_msg(struct file *file, char *buf,
 				   size_t count, loff_t *ppos)
 {
 	struct rtas_update_flash_t *const uf = &rtas_update_flash_data;
@@ -283,10 +283,10 @@ static ssize_t rtas_flash_read_msg(struct file *file, char __user *buf,
 
 	/* Read as text message */
 	len = get_flash_status_msg(status, msg);
-	return simple_read_from_buffer(buf, count, ppos, msg, len);
+	return memory_read_from_buffer(buf, count, ppos, msg, len);
 }
 
-static ssize_t rtas_flash_read_num(struct file *file, char __user *buf,
+static ssize_t rtas_flash_read_num(struct file *file, char *buf,
 				   size_t count, loff_t *ppos)
 {
 	struct rtas_update_flash_t *const uf = &rtas_update_flash_data;
@@ -299,7 +299,7 @@ static ssize_t rtas_flash_read_num(struct file *file, char __user *buf,
 
 	/* Read as number */
 	sprintf(msg, "%d\n", status);
-	return simple_read_from_buffer(buf, count, ppos, msg, strlen(msg));
+	return memory_read_from_buffer(buf, count, ppos, msg, strlen(msg));
 }
 
 /* We could be much more efficient here.  But to keep this function
@@ -370,7 +370,7 @@ static void manage_flash(struct rtas_manage_flash_t *args_buf, unsigned int op)
 	args_buf->status = rc;
 }
 
-static ssize_t manage_flash_read(struct file *file, char __user *buf,
+static ssize_t manage_flash_read(struct file *file, char *buf,
 			       size_t count, loff_t *ppos)
 {
 	struct rtas_manage_flash_t *const args_buf = &rtas_manage_flash_data;
@@ -382,7 +382,7 @@ static ssize_t manage_flash_read(struct file *file, char __user *buf,
 	mutex_unlock(&rtas_manage_flash_mutex);
 
 	msglen = sprintf(msg, "%d\n", status);
-	return simple_read_from_buffer(buf, count, ppos, msg, msglen);
+	return memory_read_from_buffer(buf, count, ppos, msg, msglen);
 }
 
 static ssize_t manage_flash_write(struct file *file, char *buf,
@@ -450,7 +450,7 @@ static int get_validate_flash_msg(struct rtas_validate_flash_t *args_buf,
 	return n;
 }
 
-static ssize_t validate_flash_read(struct file *file, char __user *buf,
+static ssize_t validate_flash_read(struct file *file, char *buf,
 			       size_t count, loff_t *ppos)
 {
 	struct rtas_validate_flash_t *const args_buf =
@@ -462,7 +462,7 @@ static ssize_t validate_flash_read(struct file *file, char __user *buf,
 	msglen = get_validate_flash_msg(args_buf, msg, VALIDATE_MSG_LEN);
 	mutex_unlock(&rtas_validate_flash_mutex);
 
-	return simple_read_from_buffer(buf, count, ppos, msg, msglen);
+	return memory_read_from_buffer(buf, count, ppos, msg, msglen);
 }
 
 static ssize_t validate_flash_write(struct file *file, char *buf,
@@ -623,7 +623,7 @@ static const struct rtas_flash_file rtas_flash_files[] = {
 		.handle		= RTAS_FN_IBM_UPDATE_FLASH_64_AND_REBOOT,
 		.status		= &rtas_update_flash_data.status,
 		.ops.proc_flags	= PROC_ENTRY_SHORT_WRITES,
-		.ops.proc_read	= rtas_flash_read_msg,
+		.ops.proc_read_buf = rtas_flash_read_msg,
 		.ops.proc_write_buf = rtas_flash_write,
 		.ops.proc_write_size = RTAS_BLK_SIZE,
 		.ops.proc_release = rtas_flash_release,
@@ -634,7 +634,7 @@ static const struct rtas_flash_file rtas_flash_files[] = {
 		.handle		= RTAS_FN_IBM_UPDATE_FLASH_64_AND_REBOOT,
 		.status		= &rtas_update_flash_data.status,
 		.ops.proc_flags	= PROC_ENTRY_SHORT_WRITES,
-		.ops.proc_read	= rtas_flash_read_num,
+		.ops.proc_read_buf = rtas_flash_read_num,
 		.ops.proc_write_buf = rtas_flash_write,
 		.ops.proc_write_size = RTAS_BLK_SIZE,
 		.ops.proc_release = rtas_flash_release,
@@ -645,7 +645,7 @@ static const struct rtas_flash_file rtas_flash_files[] = {
 		.handle		= RTAS_FN_IBM_VALIDATE_FLASH_IMAGE,
 		.status		= &rtas_validate_flash_data.status,
 		.ops.proc_flags	= PROC_ENTRY_SHORT_WRITES,
-		.ops.proc_read	= validate_flash_read,
+		.ops.proc_read_buf = validate_flash_read,
 		.ops.proc_write_buf = validate_flash_write,
 		.ops.proc_write_size = VALIDATE_BUF_SIZE,
 		.ops.proc_release = validate_flash_release,
@@ -655,7 +655,7 @@ static const struct rtas_flash_file rtas_flash_files[] = {
 		.filename	= "powerpc/rtas/" MANAGE_FLASH_NAME,
 		.handle		= RTAS_FN_IBM_MANAGE_FLASH_IMAGE,
 		.status		= &rtas_manage_flash_data.status,
-		.ops.proc_read	= manage_flash_read,
+		.ops.proc_read_buf = manage_flash_read,
 		.ops.proc_write_buf = manage_flash_write,
 		.ops.proc_lseek	= default_llseek,
 	}
diff --git a/arch/powerpc/kernel/rtasd.c b/arch/powerpc/kernel/rtasd.c
index dd0df5e164a3..360ed2e30fd5 100644
--- a/arch/powerpc/kernel/rtasd.c
+++ b/arch/powerpc/kernel/rtasd.c
@@ -291,26 +291,18 @@ static int rtas_log_release(struct inode * inode, struct file * file)
  * know that we can safely clear the events in NVRAM.
  * Next we'll sit and wait for something else to log.
  */
-static ssize_t rtas_log_read(struct file * file, char __user * buf,
+static ssize_t rtas_log_read(struct file * file, char * buf,
 			 size_t count, loff_t *ppos)
 {
 	int error;
-	char *tmp;
 	unsigned long s;
 	unsigned long offset;
 
-	if (!buf || count < rtas_error_log_buffer_max)
+	if (count < rtas_error_log_buffer_max)
 		return -EINVAL;
 
 	count = rtas_error_log_buffer_max;
 
-	if (!access_ok(buf, count))
-		return -EFAULT;
-
-	tmp = kmalloc(count, GFP_KERNEL);
-	if (!tmp)
-		return -ENOMEM;
-
 	spin_lock_irqsave(&rtasd_log_lock, s);
 
 	/* if it's 0, then we know we got the last one (the one in NVRAM) */
@@ -338,15 +330,14 @@ static ssize_t rtas_log_read(struct file * file, char __user * buf,
 	}
 
 	offset = rtas_error_log_buffer_max * (rtas_log_start & LOG_NUMBER_MASK);
-	memcpy(tmp, &rtas_log_buf[offset], count);
+	memcpy(buf, &rtas_log_buf[offset], count);
 
 	rtas_log_start += 1;
 	rtas_log_size -= 1;
 	spin_unlock_irqrestore(&rtasd_log_lock, s);
 
-	error = copy_to_user(buf, tmp, count) ? -EFAULT : count;
+	error = count;
 out:
-	kfree(tmp);
 	return error;
 }
 
@@ -359,7 +350,7 @@ static __poll_t rtas_log_poll(struct file *file, poll_table * wait)
 }
 
 static const struct proc_ops rtas_log_proc_ops = {
-	.proc_read	= rtas_log_read,
+	.proc_read_buf	= rtas_log_read,
 	.proc_poll	= rtas_log_poll,
 	.proc_open	= rtas_log_open,
 	.proc_release	= rtas_log_release,

-- 
2.53.0



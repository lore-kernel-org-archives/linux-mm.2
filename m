Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE72B607ED4A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EmLpX2ce
Received: by kanga.kvack.org (Postfix)
	id 040C96B05B9; Wed,  4 Nov 2026 14:37:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F33796B05BA; Wed,  4 Nov 2026 14:37:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFA536B05C8; Wed,  4 Nov 2026 14:37:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B68156B05B9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:37:35 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 15872A858B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:37:23 +0000 (UTC)
X-FDA: 85398445566.21.2300F78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4C87B20002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:37:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EmLpX2ce;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lw0Vf60W0kkYzKNtwekBAeKHNzXOwjkfdnOtu269DYc=;
	b=S6HixNl2GwNIDeR28jqLnxTKqlhixOOWks7vV1gOgmlK0+65PvMPQAoRKYBd4/Vx/153Y8
	ba8ssCHSZoWSSV98PkawmN0k3SIHEwfeR/KFiTr4xD1WpNuqn2LYRu5VcdFRoBxEq5V62L
	3s8moaSqTlHAT5ch2IExyz9OH2xtRXI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EmLpX2ce;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821041;
	b=0wet9msBYG824grOFlxd53lpF5VGiq76nuYebtLsurHkElnu+U8pRVZHDr5L5aNsUu253X
	UHfEWFJVkzK4WnFbwd4Qd0Iekh1guUnGa9XCvDjPAxSZGonskR3gyZGGVlXs61NmdWV+wk
	k6pfV3ye494plFc8b1kN7D+QM0E/+J4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 636DD42277;
	Wed,  4 Nov 2026 19:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A211F000C1;
	Wed,  4 Nov 2026 19:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821040;
	bh=Lw0Vf60W0kkYzKNtwekBAeKHNzXOwjkfdnOtu269DYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EmLpX2ce4+xI5YuY9H+E4NAuUJ3qowCmVcYJTCCkVepx/RMmdLMaEsYYMQXsbD1J7
	 WEC9f0WXVzjVi2Oaqshgnqe37kZUh1IU1akR7cldFTA/jCZLnEvU8C/L/bl8X3iKPO
	 KU4iHkCQr+1QB2TD+AiPW+ImkXlcvWBBv4XlNOXYAnqhtkqhclQwG6XgOy0/UmrJy4
	 Zcb2doay1Y5Z5kwFT84RW2EiGnMWXdMVd4hhXqtr4Eqn8vDxqgry++TyUO4qF5xC8v
	 N8gGvGpsKhA7Zf88UIhR+Q037sIBp+ThuFZJJOob3FtbHyenRJkz6zqtZe34+ir1Ad
	 eONuP2AV8VgVQ==
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
Subject: [PATCH RESEND v2 06/23] powerpc/rtas: let procfs copy out reads
Date: Wed,  4 Nov 2026 20:37:05 +0100
Message-ID: <20261104-work-procfs-arch-v2-6-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=7799; i=brauner@kernel.org; h=from:subject:message-id; bh=E607+Ep4BMMhx9MMeSbjVfV7RE8tFFJwzSH0ZS7TsqY=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97vg8d11E6A07Z26pnAtPZ0Vb7HV+t+tHUKjKe485+ +JmMT7R7ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjI9jBGhg1nFC643Hi4/cqP ylZx4bOnIk4rnJrk1nKgPHFfrIqX3WuG/1GOF465ZmXKMD7h/x8/ddKhRcs9FbiPb/4o+kwyt0v KiAMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wfyzm4qqjyxjixom3rsxwicwcuj8sp78
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 4C87B20002
X-HE-Tag: 1793821041-85838
X-HE-Meta: U2FsdGVkX1+aSa46/F1gM7GUzdGs5FYKkiLzwM2KCcjFX3uSYGX3+uzGvnf8zwIG2iLJdyqHyhLhaX+OhxRyQT33QpaJKvX5rlEWgaT/jVVGkod5fJI/UiOYGHOBbOHl/k9LnJr4qidSUAALO6QpUrBV3wtBpC0TPmOwg0/v8Ys6s0bukf6bj4ejhcse+iUUAmbgPH5bcEt6/Tl6J0wZcpyzZZfbRx4OZHzJQVLTgsTMEGspnuSXJWCkgCAKpUWE6E5lMhnVjzFzLMExk2zPiD7QWrFnpTYMv2JVVouFQjdmddvV7ji5MYCOWL9g6uR0qXy56VPs+qANtYqOVubdzt8ctXE5aWpIaHdNm/vBGdaZhYPHx8lHRky/bWCYzo24WNjqDMLeTVcy5adUr6bAKrGh1SgnbjenE070FWUNBl1X9hqs8OZh/Q7q6j/S5QCfRgYlxKHx823JGHEBc0l27MkE49/Yk+g/RdzBQnDRmyUmujn0KLyYzNPZOjQgGMQ+6eqBrj0p+I6013f0e0N3CSBM2Y7ShZXVvBVm9nNKKOxwasTMpSOqD8TgHu7pk3JIN5jkQUajQoJyGbHCAN96Wn0mBejq0fjLhkoJvrIBlb46hgyAbltZU/FO5VTp3556aKXVtCfAlFUgjE4rr9C3sj2N/g/rRHZ3ugYl5gKnrCbfudZvaxy0/nOY0MJi/TUHylMQYGf104sXWPmu4T7Ekl8r8vncP7m1ZFPpEX/EC8LmJbkwQ4XZ9M6J1KhqLACmGQrvV0TKsiJqxu81Qtosy6yB+ulTd3IX/drtpHS2MVLB8/3ZYdn8CaIzcwpRndGBSYpsi/kJhC+oYgljt4ycild8X9BkZoIM+Pqk3PjjH8V13LqDK6A/w3t1KhBhJJrpbrFnT5qyMWdOIytfsPrZUH+S5BsNdHqY9txb8NTqr9/rt9S0bNgf7+XZ1nUgMD7L//G6j/gmWB2gMRvtBso
 F0ECsCp9
 FQQKDGXyjsRYJ3knNDC80TlzCMoSirROJpyWJ+bnEOpNj/1HygdEXTI4lcUHwXziFz7ybgOd6AT9QIWu6X19Xvbwy7su+X2iKDnSnfyPALc3Gvfk5xY3mkUqYnBDtVVfKLT2XCG2qsh+aefKhWo5o6w6qPSisReo9NOovD277UEKgcZPQNdBmQf/JUjnRKeGKrF9SoE6nbq/4d4OZmJ9nJ+N1FUpuK8l5E2q9ljFQL8OGccGm87qi1pxndX6dEGKJBAdkQxvIzHJgqKjnXh9oWGoDCt0mk3yfLGVj
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
of getting -EINVAL. A blocking read still waits for a record with the
entry pinned, as it did under use_pde() before; the entry is never
removed, so nothing waits for it. The files can be spliced now, like
every entry that is read through ->read_iter(). Note that a sendfile()
from the error log into a target that fails or takes less than was read
drops the records in between, splice_direct_to_actor() rewinds any
seekable file like that and the error log doesn't hand a record out
twice.

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



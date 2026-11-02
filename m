Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4B7C60A0CA7
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d9QGwQro
Received: by kanga.kvack.org (Postfix)
	id C092E6B0612; Mon,  2 Nov 2026 10:34:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBA366B0613; Mon,  2 Nov 2026 10:34:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA84B6B061D; Mon,  2 Nov 2026 10:34:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 86CBE6B0612
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:34:41 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0AE40120122
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:34:41 +0000 (UTC)
X-FDA: 85390576362.14.435850A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 425841C000E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:34:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d9QGwQro;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pmnFGMOE2v1+F0PJGOHw4Gdli7q7gPuktrXwX9LNfoQ=;
	b=lY59b+39EhTSzKnyA6gPqp5B6EmZPMRMfjBOSla/PnahKAa+MeKsCzz4lJ6x9AR8G/pCrB
	jvY3GsSn9PgocJD8fEUcHUDY+HOypfRudfJiLAwbt3gRqtiCh94gVkLmtM2lw9PDHoG0qH
	AHHTXeGLTuzhuJgvyp1519vHUX9w7fw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633679;
	b=ImztTRYDF+D2qs408Tnw+kUW5+peQOvovSYYpwHmlxJxjGZXYB1Vv3Q0UoKy96YCIL3cFp
	uAIzwMB54+eVh3Qi4ExOIU+DIChF0Iw+WOm0qoIg9MdUPn4zIAnm2Ls8JK7GlkMbuswMp2
	Ted9J+rGh9lrpGIhjnnwCODwSC602SI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d9QGwQro;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DB41B609D2;
	Mon,  2 Nov 2026 15:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFFB1F00A17;
	Mon,  2 Nov 2026 15:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633678;
	bh=pmnFGMOE2v1+F0PJGOHw4Gdli7q7gPuktrXwX9LNfoQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=d9QGwQrotLscF4xo8DU9S109UjfAgcN4a46hjwVSf3SjqQgEaO4Rv1AEyP5dT4O5y
	 xhGnDHnb/jFSk8D7qKuO+39L5VOpMdQp+GEPoALOWTv2sAj3bbh7bn9Ca6T4Zctpcj
	 fNImnpjl37D5rGo6ytZAGYcvcU7Hs6e2nTEg5V2aQ/mC4G0yjxmcpG1Hu5e0aBYP77
	 YqqQjJjSh1N4cnNNEz/pCqHHyFFMtbDFf9uvFYMyEZgjLi1JBmongPZBS4PXj3B4fR
	 cGUqecnhkpX6QHjYWkx5oNKUT3XrFn+eoX8EGZYKiM0ZGpeR++e3aBl28Ylp4YaymR
	 Z4/Or8kbU/uIg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:24 +0100
Subject: [PATCH RFC 10/11] samples/kfifo: let procfs copy in writes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-net-v1-10-982104a4f592@kernel.org>
References: <20261102-work-procfs-net-v1-0-982104a4f592@kernel.org>
In-Reply-To: <20261102-work-procfs-net-v1-0-982104a4f592@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3950; i=brauner@kernel.org;
 h=from:subject:message-id; bh=wqPh89nrehb8eXTwTved41pSSj+cx0NGgazKeJSdQJg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG5SKeDGcNhJw++9Z7LY3JTfuwQ+VK2efenXodN77
 51lStK62FHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRuBCG/z6xtYb3b823yGzs
 EFIryW+ZU83Lc9Vb497sqedPcyic+MvwP/CknED65Xe3rd5zTJCoDZgg+Puey5sJtRciovqzWZV
 mcQMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 425841C000E
X-Stat-Signature: 1f9yhpkoaspbpj84znonwbf95wartosx
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793633679-535804
X-HE-Meta: U2FsdGVkX19AbEt4B8ejN40Bh0KKY2U33DC1QNsdiaeCEpj4MSnb/pHMX9rjBPNx8/eZs1Bc78IRuHsRIptLLhNKWC0jTFqwJ2bI+jl+OxwZarFXTqmpOymlCyydIptF6xFvKiXRLB0hCoZBu4sMLa44KZfk8mo817DrcO+TwFuUUK+dtTw1R7FEGKAKFyds4TfyLUT0blR5Q8GpfrxHFLBVneYV+UW+kCReHIAmwENq9MmjBp1qNWLnZEliWVnA7oOBCXFOMLcMOvjFm6377o5Jd3xlSI74F32E+UDmuXF4Xb8SwTy232mfiGgiv5JiU+5/95OyimniylPpyoc1NxltT8HE67hK3c3o+upB+TpL+pJSPuVbf03Qm+tdBi6NpTZ5WNsQMmTsyL0vkHSmqP316KuUHrslFsgvNNTZwN56Ma4QtkszV8OX2qAQUi3NBelQUsP21ju5e3Nkv+Sru2COr1h4urjnPhp+4OcaDYZrwGGOVnme0jIHgZxSB7jC8P8jEF63tbG/xQCl7J7bYYjWO/rqIoC2eOnCEMGQ5Buvl6IQEJK0XGTEkmycidNEy6eOTeckLGTKtNmLpX5pbjDITk4q6VQ1rvOtCX43E6hZRRkjzjLpM8zLtiKySUnH8Hmoh+8ueAEhG4z5LSB/FKaLdV2fHd8UzPXkjp8FUMP8P9YWytvyrR0hLY/YDAaFa6qJj5w/hDuD+u8WntIeApPJS0wCzneGwC1l7RkO+eip/zFLUte4HGB3CRBGMqGCVYZ0Lg4X4tOmmUofGqWWwW7TpwCZ8uewHIR+wxCj1Ki2Tk451Q4bDmqJUv1gK8Xxremro835UKjyz+Myfygn/FapG7ImknGg/JxJz2SoRpv4biKKP0JXV4REYDcDmUqbglUKBaj2hv4LFpxYjoWFA044aYFrl+hAD+rFEgojsgrjb5fQZe5Zw+FXl1E+XkdTIugk3Zm855NTP/EIHWU
 kFA45HOM
 5zFqjuVT13UX0mCs0icKfqLs3R66umbg9I4nAVxkMVtCNkfByvl3gT/fS9xTViOv4rmCbVYajUsBHYpl/0D41gvbnr+6189xRPWxA6qU9gI6zbVLyslCQoTJq9I20UGzi/x+ylFZzDp2I4Lf+nj9fYPPbSrkdhEhAhZkZ/wUUTMceQqb8mPUN4Qwh8edrwJgqKJfL7IylTGfLPD2EfmRql5BqE1XdyvlgOxYS4hiMh2ilTSmqcZzfpjTwnKk0je4l6xderhfQDGjZSNttg5eKggEHoj2ujLUKOkmL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written before
it pins the entry, and put that copy into the fifo with kfifo_in()
instead of kfifo_from_user(). Writes larger than PAGE_SIZE - 1 bytes
fail with -EINVAL now. kfifo_from_user() cut a record to 255 bytes,
what the one byte that holds its length can say, so the record sample
keeps doing that with PROC_ENTRY_SHORT_WRITES.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 samples/kfifo/bytestream-example.c |  9 +++------
 samples/kfifo/inttype-example.c    | 10 ++++------
 samples/kfifo/record-example.c     | 12 ++++++------
 3 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/samples/kfifo/bytestream-example.c b/samples/kfifo/bytestream-example.c
index 4ae29a12cc8a..8c58fb46a2bf 100644
--- a/samples/kfifo/bytestream-example.c
+++ b/samples/kfifo/bytestream-example.c
@@ -110,20 +110,17 @@ static int __init testfunc(void)
 	return 0;
 }
 
-static ssize_t fifo_write(struct file *file, const char __user *buf,
+static ssize_t fifo_write(struct file *file, char *buf,
 						size_t count, loff_t *ppos)
 {
-	int ret;
 	unsigned int copied;
 
 	if (mutex_lock_interruptible(&write_access))
 		return -ERESTARTSYS;
 
-	ret = kfifo_from_user(&test, buf, count, &copied);
+	copied = kfifo_in(&test, buf, count);
 
 	mutex_unlock(&write_access);
-	if (ret)
-		return ret;
 
 	return copied;
 }
@@ -148,7 +145,7 @@ static ssize_t fifo_read(struct file *file, char __user *buf,
 
 static const struct proc_ops fifo_proc_ops = {
 	.proc_read	= fifo_read,
-	.proc_write	= fifo_write,
+	.proc_write_buf	= fifo_write,
 	.proc_lseek	= noop_llseek,
 };
 
diff --git a/samples/kfifo/inttype-example.c b/samples/kfifo/inttype-example.c
index e4f93317c5d0..c5d16b815e73 100644
--- a/samples/kfifo/inttype-example.c
+++ b/samples/kfifo/inttype-example.c
@@ -103,20 +103,18 @@ static int __init testfunc(void)
 	return 0;
 }
 
-static ssize_t fifo_write(struct file *file, const char __user *buf,
+static ssize_t fifo_write(struct file *file, char *buf,
 						size_t count, loff_t *ppos)
 {
-	int ret;
 	unsigned int copied;
 
 	if (mutex_lock_interruptible(&write_access))
 		return -ERESTARTSYS;
 
-	ret = kfifo_from_user(&test, buf, count, &copied);
+	copied = kfifo_in(&test, (const int *)buf, count / sizeof(int)) *
+		 sizeof(int);
 
 	mutex_unlock(&write_access);
-	if (ret)
-		return ret;
 
 	return copied;
 }
@@ -141,7 +139,7 @@ static ssize_t fifo_read(struct file *file, char __user *buf,
 
 static const struct proc_ops fifo_proc_ops = {
 	.proc_read	= fifo_read,
-	.proc_write	= fifo_write,
+	.proc_write_buf	= fifo_write,
 	.proc_lseek	= noop_llseek,
 };
 
diff --git a/samples/kfifo/record-example.c b/samples/kfifo/record-example.c
index e4d1a2d7983c..dcc749247c64 100644
--- a/samples/kfifo/record-example.c
+++ b/samples/kfifo/record-example.c
@@ -117,20 +117,17 @@ static int __init testfunc(void)
 	return 0;
 }
 
-static ssize_t fifo_write(struct file *file, const char __user *buf,
+static ssize_t fifo_write(struct file *file, char *buf,
 						size_t count, loff_t *ppos)
 {
-	int ret;
 	unsigned int copied;
 
 	if (mutex_lock_interruptible(&write_access))
 		return -ERESTARTSYS;
 
-	ret = kfifo_from_user(&test, buf, count, &copied);
+	copied = kfifo_in(&test, buf, count);
 
 	mutex_unlock(&write_access);
-	if (ret)
-		return ret;
 
 	return copied;
 }
@@ -155,8 +152,11 @@ static ssize_t fifo_read(struct file *file, char __user *buf,
 
 static const struct proc_ops fifo_proc_ops = {
 	.proc_read	= fifo_read,
-	.proc_write	= fifo_write,
+	.proc_write_buf	= fifo_write,
 	.proc_lseek	= noop_llseek,
+	/* kfifo_from_user() cut a record to what its length byte holds */
+	.proc_flags	= PROC_ENTRY_SHORT_WRITES,
+	.proc_write_size = U8_MAX,
 };
 
 static int __init example_init(void)

-- 
2.53.0



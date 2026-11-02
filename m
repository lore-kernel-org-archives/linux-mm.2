Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 867B9607E0DD
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kIejajPL
Received: by kanga.kvack.org (Postfix)
	id A8D3D6B05B1; Mon,  2 Nov 2026 10:00:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3E516B05B6; Mon,  2 Nov 2026 10:00:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92C676B05B9; Mon,  2 Nov 2026 10:00:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C7CA6B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:00:12 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 02B598014E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:00:11 +0000 (UTC)
X-FDA: 85390489464.22.F292AB7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 119C0180015
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:00:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kIejajPL;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DA4U0m1CHtqk19BjQpd8o6fqolui3N68b+LzMS0kHTM=;
	b=SvVtFCP5iF6sRJDFbXe+BZm25kbP82Tu6EaiFf1YVX7G0z5lBkggVOrCnuFGQbQKqQbJik
	qvptnblADZny6Hxh9y26f6fav0s1IaiaqP7N0hrYo3tvY1JdsSSBonARe2pZvz4xIg7YX4
	wlRMqtM7JjG2O2ERZcItcngMG1hkx/c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kIejajPL;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793631610;
	b=aJtEU8fJoVFfiAq0+MVtaruprUkaNeFGK6efOt1E/9IceKN6sPaHd5kxbSIuLHvSWUMo0s
	yUyze1wF+uPa6yfPOgvI2g1GLi3NW+661keQ3yrhQ60o9RKw6VVD8nvuC2YPHMeXWZ3QbW
	AjtAoFXWj8L9vEzVyuco8LyZQNRz+EI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E70C841966;
	Mon,  2 Nov 2026 15:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C201F00A16;
	Mon,  2 Nov 2026 14:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631608;
	bh=DA4U0m1CHtqk19BjQpd8o6fqolui3N68b+LzMS0kHTM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kIejajPLDhBhNAF+5qAkd+IjamKUOnO1hhgOl6ob3NywfSYo1UCCZClj+UVXxg6hN
	 8GZuczs7QvhEz8GqB31Q0v4Sfe6zaLku1E8g4bV1Nm7S11GUdX9udG3+A+XpQmpG4w
	 SKp3yZE5RKwGE6D9RxNOhr665KUXvrAf7U9EgM6t8GMzBMTN1Hyi8S9DzqCn2e/KFT
	 qYkBu+IipshrjT/yGx4WL5OycQQAysKT17bx+VTU/wQ//N1IctW6952TFgl4pmjQUh
	 Zgj0NC/jh4zpBceIV8H3jC5zH7xmHBcraK25zYbCARrQ8e4MvgCvvVFdA3MjVOm0bI
	 x3pJnolxi8+9Q==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:48:54 +0100
Subject: [PATCH RFC 14/16] fs/proc/vmcore: let procfs copy out reads
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-core-v1-14-75df35e4f8b8@kernel.org>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 119C0180015
X-Stat-Signature: 8ygyijgtm3oirf3gzqr7r85h9twrbf7j
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793631609-188901
X-HE-Meta: U2FsdGVkX1/YweZBv18ABcgDpAe93Wqs1VjfAizpunr6G09yORcCe/kYdEHuo07UYpNA2Z0Aog3ptbzJiWlTpXEltI+ODZbsnWTtpWk5jz1i1N6uN368etBUcgtCd5DbIWw7Hyn95y6uwuVIiBkpcw6Jcpve0Pugw9AvazJap4lSknCtcBdPZWs6iV3kPB2rbK4Za+JttDFiQAFQm7yllsvYCBFFCpA/F4AAI23m2GijYuZz5F46BHjN2jSn5cB99KbMjQVYscACW16dCnC+dbSFRzI0ZE/xoe3+860iFZBvlz1DhKWKiYgGS7M3Iu+4SMw+8E0Jmix0JjtZlhUC+mQBH2KvkjQtsBhFb03jbRpiElHaOlfMilo74DBYV+xqJQ0eWyxMEcI4KSwo9dJ1cfxMwNwAgh84Xa/MRhLTHG7Sqc5VvEROq8wZ+GZDD6/EnoOShNok7VjqlvyUZtPGVKOCQDl7k36UdGLxItgoiFlYvwOG4V0OnYnhMbFr8GOsEgSowpqrKbl2JWzpHRdjVEqleJvOZNnHzHjDWpZda6yuTBoGHDfpvNGn6xQune8iGis0LrNTmXSw1eU69TLdUu1A7QrPnTqWDnLTbuFJ5UtS88Yv8CC7RlPCAMv+nRvGdkSrO2hKy0utgslp2PonJsQGPIfG+QT4KfcqQhZ+DiPv/8Kirj4EYXgH0VwBWSOYBjk1dGfP78juSBvdZmUxhXcLVmE33rxEu0ID1vHo3ZDRzWp8GnL7AG4spgxvXpY9atSbmCqtbnDRxM+WUnz8kOcb87eJP+IsYwqZHoEbCQXMjGJoJZ/BTmu+Kzwx016k2fw4/vsHYs6rkF/kjvbQyAksSg1ny7Hzr8GnJ99OcERzfJ6370eLohAoTus19yK5IKiU9A3SkSmGd9UPe7e/e+/4+sTZFzAeBpS2uAxA2nTJ2GnRTITfOmUM041xgyB7YcAfjHedHAyKrkX3Yyl
 LRRszFQl
 /PFiFie0JXq64OuERo/Eddgl/wbZ0niIwmGXC4COgIvummsB2/vVmcOGZHxfGFVMc6izM+uXS2mGD/m7gKhBwoy6f5upayH4RmG9RHJPKpQi9S03hGfAkRfOj7GvZcwtsmerT+c+fRYmxXQ5rfk07JEbSoe2qsqIFsM/BcuhJhtpDxfJKVvSre8ertHLTmIB/FYe7VBfCZtwlHSYNpIs3JpivUfJHbGoog51+90rKhHNEUHAvEBWSaHsc9m14XdT1GnMuqDJkxFbuxa27tnc47H1NIf5jSBMONaU5nw36+lrJCvopyFQe2qPlF8UyEyI02Fn5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_read_buf() so procfs copies what is read to userspace
after it unpinned the entry. __read_vmcore() fills procfs' buffer
through a kvec iov_iter. So a read goes through that buffer now instead
of straight from the old memory into the reader's, which is what
splice() did already. mmap() isn't affected. On ppc64 a machine check
while reading the old memory used to be recovered through the exception
table of copy_to_user(), by accident. copy_oldmem_page() copies with
_copy_mc_to_iter() now, so a read through procfs' buffer recovers from
it as well.

The buffer is 128k, which keeps the entry pinned for one such piece at
a time, and /proc/vmcore asks for PROC_ENTRY_FULL_READS so that a
larger read is filled in pieces. kexec-tools treats a short read of it
as fatal. A read that faults on its buffer in a later piece returns the
pieces before it now instead of failing with -EFAULT. fadump removes
/proc/vmcore when its memory is released and that no longer waits for a
reader that faults on its buffer.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/vmcore.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index ccb795b85509..1c1e71231f4e 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -27,6 +27,7 @@
 #include <linux/mutex.h>
 #include <linux/vmalloc.h>
 #include <linux/pagemap.h>
+#include <linux/sizes.h>
 #include <linux/uio.h>
 #include <linux/cc_platform.h>
 #include <asm/io.h>
@@ -427,9 +428,14 @@ static ssize_t __read_vmcore(struct iov_iter *iter, loff_t *fpos)
 	return acc;
 }
 
-static ssize_t read_vmcore(struct kiocb *iocb, struct iov_iter *iter)
+static ssize_t read_vmcore(struct file *file, char *buf, size_t count,
+			   loff_t *ppos)
 {
-	return __read_vmcore(iter, &iocb->ki_pos);
+	struct kvec kvec = { .iov_base = buf, .iov_len = count };
+	struct iov_iter iter;
+
+	iov_iter_kvec(&iter, ITER_DEST, &kvec, 1, count);
+	return __read_vmcore(&iter, ppos);
 }
 
 /**
@@ -709,9 +715,11 @@ static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
 #endif
 
 static const struct proc_ops vmcore_proc_ops = {
+	.proc_flags	= PROC_ENTRY_FULL_READS,
 	.proc_open	= open_vmcore,
 	.proc_release	= release_vmcore,
-	.proc_read_iter	= read_vmcore,
+	.proc_read_buf	= read_vmcore,
+	.proc_read_size	= SZ_128K,
 	.proc_lseek	= default_llseek,
 	.proc_mmap	= mmap_vmcore,
 };

-- 
2.53.0



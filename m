Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A6E9606D4C5
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j7j0ZanL
Received: by kanga.kvack.org (Postfix)
	id 651FB6B05B3; Wed,  4 Nov 2026 14:33:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62B4E6B05B6; Wed,  4 Nov 2026 14:33:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 543236B05BE; Wed,  4 Nov 2026 14:33:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 31C756B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:33:39 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B329C80846
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:33:38 +0000 (UTC)
X-FDA: 85398436116.23.25D26CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 23D8820006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:33:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j7j0ZanL;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820817;
	b=1aunjL3iAXu6mtw8zyeNMpmy0UOzuk3V1imnTPF4B0VvpueVWrpm6vou52yMCxGbxpU3bk
	8OcCK9D2OQ/xhYt6o5rTuFojSErklyUYRmbx5ER/YcIMKQqpwrEK+rgmCJqcsiS4nZSKaV
	atfZp7KI2m5zxogqmgJKjZtW1r6PeM0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j7j0ZanL;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DA4U0m1CHtqk19BjQpd8o6fqolui3N68b+LzMS0kHTM=;
	b=Xex676u2z0QKWhefOfc5pHNmv86eQ5VwkWxaWbPH+ybdHPgVblcm/Q8EYlu2C2NCUh2IxA
	TtjNfHU/fESXKITMZhj/m4drAJtJivQpOf5/AyUWicFLxrSdr7i68656Q3HFO4jApI3D6V
	GKYzuTGZa9R6d5Qf7PEtn0S82U87c/Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 43AD840842;
	Wed,  4 Nov 2026 19:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469811F000C1;
	Wed,  4 Nov 2026 19:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820816;
	bh=DA4U0m1CHtqk19BjQpd8o6fqolui3N68b+LzMS0kHTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j7j0ZanLPklc+rmEtTC9tqa+2dSI7D6dXyu+DrqtYaDUdnd/LUj9Nl96xu78fe9Bo
	 ONceYKUXd7LLhykczcAo+XYQQdU9VnrXajvQp3bn0Dx2obQg2y/zyeUEJ6MGrrd+wb
	 VFFMAfxyna6jHA221MxfRrjIXNI6FL+oxmibL6KxIcoNWzorQNT0Y26Aft3Ya4mbr3
	 nEmiL8AySa8xnCAjT+Cv2punHBoTSIUYIamvaW3tloiPYrIvszTdT7r1QGguINjG6f
	 bcI8iyL36J/mqPEgKJA4dznZGpZUrnKnHaFZ18d22HlBAx+3YRJXUlVnXMqpcyi0q5
	 yU4xE/E1WQohQ==
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
Subject: [PATCH RESEND v2 17/23] fs/proc/vmcore: let procfs copy out reads
Date: Wed,  4 Nov 2026 20:33:22 +0100
Message-ID: <20261104-work-procfs-core-v2-17-76ace653a773@kernel.org>
In-Reply-To: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2514; i=brauner@kernel.org; h=from:subject:message-id; bh=4DsZPmVa7FbNwblf9/47/FvU9tv8FcehxAI70fSkduE=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bm8tNg9c6qctsMOowaPB8dhVZm5nNklTraOzXbl+K qxoZzXqKGVhEONikBVTZHFoNwmXW85TsdkoUwNmDisTyBAGLk4BmAjbPYZ/pqcffG5u2ZjJWLlK bcnXA3+MpivM3Mhaxf3f+9SDHRe4pjIy3HaafDysJch9dWB2tJTnbNlTQdMUvf8XW3KJ126efym NFwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9k8drd6izpmoite83t8x74gz3ox1wbgu
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 23D8820006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793820818-816552
X-HE-Meta: U2FsdGVkX1+o1sEbuq+w2SgbZiDR0udi/DoIoqdJho2IOdSKtfp3C7xY4I8eS55tWGOMv580EyHsNv0lRxMDe1fIjkvt55k9UNngF9ozPtPknkXtDXxIE7zP+1XTN3LLpzaDSVaiYKJIJtmsVZGKotGELRSgutPDmeOOrY9ehiDEObipoPsDx2/WVV7BW3Geq2uzpcqTDoQF5eepq1/xJ59KCTTl9lXrdri3X+W2kIx+XhRFjrKNV1qIj2kKcSSVay4DfKHuyln5+HlekeIKYPcDx1ZdYnivo0+90NkJ1S+zOkRUQvOI3iGgABdv8z8WBZ5Umxp+W2xSHzgEw0HvyIfbL6Yo2p0tITooUcbxfOwe/VeEiqkA9apHb9UtDGH9zku5c/FlS+4vwbpoW+2yBW7DljLC/KbJrmqrG5xjpd+vvRuL7jCr6mvGeOaW7OB2gqL7z6FlUIegbXoGS6T18khu1k2atk8VL4goLCXQDspbJMni+RWEJDmGDTHQmD2qXTtBkX1B3wU4E3wacMfzarCmbDLz7xuUEFfAVVdM/Qb7F4HMeJvv2u/qn39hDuoYzMYuah/sbYSpzLuvBKKkBjV3AyAtLoDaZEWm03q99Q/PENmsaOoCwpdYG3PVaWMtDQnhbi+hj1g9+xkjccKs+xo1xq30J99E3dt46o+VHZVowMHbZnLOVQsFHGf2bnHbYnfhV3PtEmaeKFqE48o1UjTFuSO28TmWvM/18/ohGv9TmyxrTAplM3jcbot+E7SrUZOz0gPshbq+LFmhNFn3MKe/Lkkd1dQ2/BAq0fXpIVl3T00Y8nzzNdrIbgb+pR7MIm/OGS0GPmHrIPdC9G0bCD4vU8k4thL9p54xBO6GHZFovNqCg/d0FM1OxSh3Wkt3/Ni4f2l/8ptMBtPE2AJPXV/r183Ezk+nRL+zkT0RKBSGVQawycRb4thIdeRI9EoRjYO7yp4pY+flYeBBkhn
 0K0XMeGv
 wAFozsAL2bEnc9SUxr02JuJZzBmeVS1HtqekNtFU6FM3JhH3EFMt54LYF/V1uMXve3wODxn2+4bAqWzDmikpQVJXGtxqxnPfW2gpKc8b9KRB9tlnOGzOjDFDupxR1AcyRaGby2l+KvT9FTnrUQcPWsJKLfjhaM0TgE/DMoust+HtVOvvfeLZ0czclsK/5gHaVSUyg9vYrc2rP1t2qE7vgA4Jw3C0D60b5jY5o1ejQOt7ET9xUbkx7uI9pOGZt6FbXaeFBXFuD9qBy1YbMnW6z5XmeR5r2RjeqDV4wOmyBBF7uEMDhNeTtumsPkf3DsYfjvX9KPVBD1R/O+k8NQtL2QSS3HjvQ9aZgdBg4Geur9mxDbgs41wtlYZFgczSh4vMLoviksamGukc9KiYwv04G/UTZYGCG2BDCUc9l09TVwJK3ws4cVydidHkvHQ==
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



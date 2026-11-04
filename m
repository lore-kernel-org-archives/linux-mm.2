Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D2F9606C91F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q32w5rFD
Received: by kanga.kvack.org (Postfix)
	id 767916B05DA; Wed,  4 Nov 2026 14:55:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C9756B05DD; Wed,  4 Nov 2026 14:55:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DEB46B05DE; Wed,  4 Nov 2026 14:55:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 363976B05DA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:55:51 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B94481A084F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:55:50 +0000 (UTC)
X-FDA: 85398492060.06.24ECD9D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id E6EF94000F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:55:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q32w5rFD;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793822149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fVQTaeb1oaPXPKdbaoAayfOvKvQGNQ+1mlgyJVhAprY=;
	b=z6ODmSsbMZKopUxR8IUED8Pn3rXNQfW4Hyn6NcbhVxb6607GlwVWHKMD9/S4gno2JyKyCL
	ebIm+go2wtxF5TV3kc0ZVMrLxxFECyKfJK6/kNXipOGVqRi6cNd38Lde0petWtd2FIIKxj
	p9zRTmW/W5xO9bhFCk/BLyjD31F0JBs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q32w5rFD;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793822149;
	b=ndfNN4BNOOIyrt8G5Bs3xBs6tnGF0IXt1ushNnEGlyHDbjeDaxliviLohpxYQpB0E7aoBX
	Onx9Hl0j1g6ssWaMuERICEQ6UqpDl10WtvKCfFCWkNiKLdtVZgk3U61HCBA1U9dc/cFnsz
	JiEbvmd+4h6j/cQodnVrTpmC4Kcreus=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3E94D411B8;
	Wed,  4 Nov 2026 19:55:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2F21F000C1;
	Wed,  4 Nov 2026 19:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793822148;
	bh=fVQTaeb1oaPXPKdbaoAayfOvKvQGNQ+1mlgyJVhAprY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q32w5rFDw7m4TPU///ekwITsZbRvjQsHLd+6HFlNz2/NJu79jBf1XLpN0vUw391T2
	 uw96M48YWvTVTZOd/quiW9tkip+To4fCWmrYtjAqEca7mU3cvv7TLSkJ2I5flbMddx
	 tnPejpzcW7k6dl9zEzi4pAyQEWKRu7sTsR/gjlQf9B6G5OOj4qWhqpT4XCaI3CnMh/
	 hxKIIlGSI2qxyvUVW6X5ewWtQ1YzM/tMkeLctqfK5X9ilrcEsCf6wf/+VMmbGZTiDJ
	 imQFLXZ9BYFgkxP3LT/ycmK7E4KCrG3osBwTZ7XN2hZPdxLRGjjZgnJNCE/fKk2Vgg
	 56mAj3Jb003tQ==
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
Subject: [PATCH RESEND v2 24/30] ipc: let procfs own the seq_file of the sysvipc files
Date: Wed,  4 Nov 2026 20:55:33 +0100
Message-ID: <20261104-work-procfs-fs-v2-24-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1686; i=brauner@kernel.org; h=from:subject:message-id; bh=X6b7xxVI9/mXpsMyNcc27ZCzqI3OxIvLBKPC0zeU++I=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97vFwli/OP28gcU6x0u9Lr20hZ/OW/Ux3Hlh8PSj+1 evPFOuKjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIn4qjIyLNJbG8P2lu3B9+35 Hbo2fLdXVFnr727TUf79truJg3VZOyPDvTu51vy7Xnq5Jd/Q1ROI0K0O+HE2ZInIk8iog5PXrYn lAQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iqqz933der799m5qxwmry8j8pwo6jmmx
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: E6EF94000F
X-HE-Tag: 1793822148-32436
X-HE-Meta: U2FsdGVkX1/i9nu6oSXBgW3v+3Y5n94yhIkeX7H1qLPqEJ/xw+9/fFwNn/Yy0gKyhD1B0ZDKI1BL8aPmSR/bu3DLNIG2q9mCw23ysRuBZSzRVsiv96X8rO5/EGjfWD8CIQBnZkrYIPThJS8Bm1LRgeSznSJsEPByr3k8XYVAbbfGpE+SpTpFMRos6WPeUMajhjba/uK9QWPulhQxMBRyj5yKjUdhp2k0DD81P61xOGpNl4EYh6wvJW9kUXTt8hKV0mlE7QomEne0MWw8ZB7gqC+vudm/Qwxru2xXYuZ4QYqpHZtH/lK7FnLgvPzNlSemmcecEJqOzom2ISiNSufFJa9gpXryvxyOsv8L/rsXLitjcZzJ3Zb9lGqOkMAqy8WRMSFtX9tvvcvCw6V9rre9xejmrqnztyDykXqKGDNSozf8GHNXoUZ80f4K0Y2mJrX8LRXniTU+JZWmdKBGjqjOqrIk6MBJXLqGcwYZIeCdtvEU9Oa07CbBRMEzLWUMPpv8Lpk14YHlYfTKrHCYLf+6Gglzw3nGrXXomYV/E5qDOal/YGC/0Z/hlH9SeAUN0b4uQZMa8Fsh9EtukKq5q9hWFqjeKfdAsFxyrVWFAIx1EZad77czXhShim+P3Irc/xRiWYcPpDRbU4WEKTTRr7yHHqkPpVetdV5NPwDg9x00jSlXfzi6biWevmCd7YvxQCtkVJ8Z1LDA6/6xNObjvWA+UrdrlScCpx0RHE644hi3duiQwHT+VHqLAkewz8ffzbx2OYWaqDRGUH8EfRDzeA00UNAybSXQrj2Cfp8fGlQ5OVUshTUvKtp2B2/UZmpagpWJg05m/65sXj713XvsoaNVD6wzNfFXwqkuIWWYU3j8GFlAdAEtg3y/+gMgLmT2pz23FyboCRthhpi/XQmU5x242P35aTn9fuQjIw4JQFzZIWFuS0PD/FjLAXGSGFY9O6NVM+O9vzFQJd43P0pW0r7
 eVTa+Yon
 DQMQrT9F3u3xe/jxJ9ZIe0yxjPcy2pT7rECxFeovn8qXRpYQ6Zos2jLTSWX9HncQbkqLTotuSIaRAxK+svGyZUZSb5XXGvNr2DfqYoA26MoVCZ3IV0UTsFLTgDPpH7gYPbMV2OTAzq4A6c3HS1g7oTAemd+MN5ovRox3ZluwO3JQPjyCRfE7RNbTMkkzrjdTLQv3sNMVdrCJMrHGUA2gW3mTQLav2xUd4Y1qLBRg0s8Vr/zvrMXeDq7iPmSJO2YVqw4yYolBYrOchJfA9FF0EmqEZMoLtPEyH4iRqhUffOFIXIui4EdIUo1UOrojql/RKqrYvzUCbJYaIVZfThrQqQpJchkD9mD1Kqyrp6HNR3VSO48LRO2VKh9LhhNhBmWTGbbrb1ioK46Mj2jcQdTGfrPRLNrpuIsvtwXXWD76iAgV0BflYAT9y3rsmnIbkgvKD2dJL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the seq_operations and the size of the iterator and let procfs
open and free the seq_file of /proc/sysvipc/*. ->proc_open() only fills
in the iterator now and ->proc_release() drops the references it holds.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 ipc/util.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/ipc/util.c b/ipc/util.c
index 1737d776bc08..8ec3bc328657 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -894,13 +894,11 @@ static const struct seq_operations sysvipc_proc_seqops = {
 	.show  = sysvipc_proc_show,
 };
 
+/* procfs opened the seq_file and allocated @iter */
 static int sysvipc_proc_open(struct inode *inode, struct file *file)
 {
-	struct ipc_proc_iter *iter;
-
-	iter = __seq_open_private(file, &sysvipc_proc_seqops, sizeof(*iter));
-	if (!iter)
-		return -ENOMEM;
+	struct seq_file *m = file->private_data;
+	struct ipc_proc_iter *iter = m->private;
 
 	iter->iface = pde_data(inode);
 	iter->ns    = get_ipc_ns(current->nsproxy->ipc_ns);
@@ -915,14 +913,14 @@ static int sysvipc_proc_release(struct inode *inode, struct file *file)
 	struct ipc_proc_iter *iter = seq->private;
 	put_ipc_ns(iter->ns);
 	put_pid_ns(iter->pid_ns);
-	return seq_release_private(inode, file);
+	return 0;
 }
 
 static const struct proc_ops sysvipc_proc_ops = {
 	.proc_flags	= PROC_ENTRY_PERMANENT,
+	.proc_seq_ops	= &sysvipc_proc_seqops,
+	.proc_state_size = sizeof(struct ipc_proc_iter),
 	.proc_open	= sysvipc_proc_open,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
 	.proc_release	= sysvipc_proc_release,
 };
 #endif /* CONFIG_PROC_FS */

-- 
2.53.0



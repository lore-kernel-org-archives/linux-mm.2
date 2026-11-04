Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0CE16070425
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 21:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HDqRrYE5
Received: by kanga.kvack.org (Postfix)
	id 9FC596B05B9; Wed,  4 Nov 2026 16:14:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D21D6B05BA; Wed,  4 Nov 2026 16:14:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C0E86B05BB; Wed,  4 Nov 2026 16:14:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DFB06B05B9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:14:09 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DB1821406B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:14:08 +0000 (UTC)
X-FDA: 85398689376.20.FDAF6BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1503B120004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:14:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HDqRrYE5;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793826847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pmnFGMOE2v1+F0PJGOHw4Gdli7q7gPuktrXwX9LNfoQ=;
	b=Zmzzt2NvgyG+5fnqmG7mFqdT3LJxglAS/e/cMV4f2HlZIresarhwCW0GpBqqHGtlVq9hOW
	4C+dXJXMmiIn4p08cXhCD7tJVPgrmO5aRLNU0axBrjYMwUNqIbpPNhXvEV69P2j8/6rutK
	NDOc4dx4P0wC8LlEyYiIK+c7RHRP6tM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HDqRrYE5;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793826847;
	b=5DWX7tscMacoaXzd2O1RykGz0VQ/9R+dKVGMV1Hwolj+kgE3XC37WVb0VoHOnxDIBA5gng
	clMtE4hTbabZ6xiGH/Ar5hAgHDOb8K88t3tLs7uHJ3lvJntFlrsvqCeqDvbLhq4Hwxgfgc
	xT+mz/MO2iYEaKr+90P0hCizzwtPpas=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 12C6D43A2A;
	Wed,  4 Nov 2026 21:14:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3161F00A16;
	Wed,  4 Nov 2026 21:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793826845;
	bh=pmnFGMOE2v1+F0PJGOHw4Gdli7q7gPuktrXwX9LNfoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HDqRrYE5SVW+uz41qBUdlkd/AOD1buzc7yItKvdItI4h8/KuGepVfYio6GPLtiP+J
	 fJ+d4qHm1iNZ/NDis/KF73HhMgppcwATjDAXFRShJfdyGVij/MvKpTe6tFtKF741Vv
	 9yp+EZP4p3+D40HqIzZkbNueee34dY/20SfSqgn7hMRMXKqxj+niSBoAZb0ACNJwD5
	 svjcjblOGDnpwrFFpcVVC8ty8x1qq0lEfDdas7ia8TH66801cLAyTfvtLHFeDvwr5b
	 wnb5hluHHKL8qJsYPeHy3t4IGfFFNO/QeKXi/O6wCL4MG4JyRwvT2v3Tf1yj0HE3IE
	 HkKfxGaP/VkNg==
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
Subject: [PATCH RESEND v2 11/13] samples/kfifo: let procfs copy in writes
Date: Wed,  4 Nov 2026 22:13:51 +0100
Message-ID: <20261104-work-procfs-net-v2-11-221e2437fed1@kernel.org>
In-Reply-To: <20261104-work-procfs-net-v2-0-221e2437fed1@kernel.org>
References: <20261104-work-procfs-net-v2-0-221e2437fed1@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3950; i=brauner@kernel.org; h=from:subject:message-id; bh=wqPh89nrehb8eXTwTved41pSSj+cx0NGgazKeJSdQJg=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97jOYLqMh//ThRIEnvPOqE4X+CB0XWpFzR35zdGxZZ Orh2Zc1O0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZSsJ7hv7tH6Z8s80W8RROO rN/N/UIp0stetDs498C/PTpXF150cGL4Z+evlr2YbcZl0dpm/huN/+I/eGm9CCnf3nXvVeRZRhs PTgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dq3qg63c13o6mqesxqkn7s1w3g67p5ep
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 1503B120004
X-HE-Tag: 1793826846-441398
X-HE-Meta: U2FsdGVkX1+pT9y1iM7wLwUKGVS1zbQPWXVSTmp4IQug1SvJJN5JvCUaTEzBd2yUN8T+STJErjog1D/+BuKNNPGvksl3rBn5vD9gAQe6iyyDFi1K7WTZJIWibFJjvZJaZm9cOmrZZpxhAc4b8qJQAKgFcwz+3gYj4CVahYituX6OFF+kVVzoY0TwBMzjo5DVLKqXcMZlBQYNzBUaFOFMDzZX4BznMA3Gh7wBPSYhSZI0Y676wpEI2fLqUqPglsIxBzmNVEBryIWxud17fy9taOyCaoUTTbvK/9MuoNQjeoXQd2j8dfLFXszOEueXwSZ5VLy30Mnt4LwUeCcoeZ5wLsHPZ/1JFppo2gSxGdbJFbIP6tNypJ9LHLkMQ57m9o+rCJq211qwyNpCeyGUk3D2xPrayy4gRxIdPiuJgB/a90R91uWl/VqOw2oDqxTyNWFQypncHSQOFvGPtEz+Ee5FcpluOLYC/FraPr/k6Mw/VMkHFiOIMS56z0nGnmFBVWu5A9TzV0ELAlHUpOA4p+mBGCODss5mqNCFuw77VYOReepKocaLOv/NLADGHAtm9Lmc0G+IgxsjYSegIEZTj3cC6aPLhM81OudC00rWt0kqWW5sbmtTJvL3+gmBFtQoVVd6s5qTLEuURUHCTGaYU3STXuGubndFo3Vw+/ggfjU/x4MFntZYZ0Q63TO75epy70IKUHwXpg6OrZi5hAmXNYbKI/FeLCT9GkdrNG7vKfdleYDXLbvdj8YipGh+Qi9Xgre4MC59rtYjOLAyU1S0XGOsD0yn3DATKPHNOJBH6MguKxoL4Ihpb4VI36T/Y3fmuzsI+WdEnbTu+fifxeaXlfXUVP5ouYc/cVCIpAeY+ydq1G3FU+CB12vXKcWDZ9Sg4lGWmhBUsmrtAaB3prSqpqcvLRZkBU/spgIjSG+L+Si1ya9befHwKubXSAV25BWKXbSEdKpc0CWPEPRQ66k5b7g
 13yot4vb
 /CsMrjjV/VpjsJfWAc0nPSpmuchMoZMR5blO7zt15bqYrMeSRCg8P8fpElEVQVgXmEW+DwhUKzlV1v62IIPFf8xVt6fJfn7nQ/rM7zGtLd31nrp3HHEipnbvGUvo2fztafcfxWE4CVebLOYyWAsFHWRw32fv0Ec9cYHwb7gJjKL0y0LUJLULrwgEe65ocmLwXbKRuwaPlNzYkK+/Fi8Q76JKrCz5ZZbjxC5U1cztLfc2F2ypba7QriyurZV6cpdXqaA/+LaZbc9gmzaa2ylIYH+S3aT4iIuNm5n7h1NWtAnNiNntQLpyerYFoCvXyG5NfnOSgfl+cguNqlV6SMnyw2087FFvek9FgQkoHchFoOaILdLJuGQj8qhq4OETzKQ4cMNuNV3Vqkuhf7a3pEzFm4JAfeg==
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



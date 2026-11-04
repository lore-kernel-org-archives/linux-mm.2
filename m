Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9B136073D33
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nBYfqhzO
Received: by kanga.kvack.org (Postfix)
	id EF3706B05D5; Wed,  4 Nov 2026 14:44:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECC776B05D7; Wed,  4 Nov 2026 14:44:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9ADB6B05D8; Wed,  4 Nov 2026 14:44:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A94036B05D5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:44:42 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 48B2F1A076D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:44:42 +0000 (UTC)
X-FDA: 85398464004.16.C2BBA6A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9719DC0005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:44:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nBYfqhzO;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821480;
	b=RideOF1TSGPazhamn04DX6IWKg0ZCe1ZzOg+BWwBoMa/doNl6uSY8mgdh777vpUwgxVlyU
	sxcbHPCQ7BY8xooR7FCZQcSYww7l01/NSILAL9cHTxLk6GUHNHO7UzUJQEZrDWuqJQzvPA
	m6u1dJpC0CmNV+qLr3nyVleMtS8aoME=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nBYfqhzO;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0F908CJPgWsUmGeEXwOdb+LqVbJ68uHDJ1pDvsTQFww=;
	b=7jr3dGEBTS64T/NhLSj1D4ZY4Md3f3z1rMt53RSNGfukL0cs25j+EBeEZqRB/mIcGZahL+
	QzuRgWP4h8UF71RzIYB4JfuQ2qAPGUxuuRxkbhwPBOAapzly13dOPOLTVAa0E8XB91JjT0
	etKohHZR4DIX3vGf9MXRT0c4H68C3zk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1FE1F60F1A;
	Wed,  4 Nov 2026 19:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72EC61F00A17;
	Wed,  4 Nov 2026 19:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821479;
	bh=0F908CJPgWsUmGeEXwOdb+LqVbJ68uHDJ1pDvsTQFww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nBYfqhzOfWIGHsy8c53G5+e95/eOlSF+s0+PYDPiLShDcgF0zVxjVzadNTSbzeGPS
	 Gev4jrZfOjt5GDc4cXiN0YSRT4TEvVxeJ2FuLYhPV1dedrvI3+Pu2yeGrj82/WNN7U
	 zCQG6VqNrlF0Qr0UfEw+wC6aUxsz8RLux0n+F+FKqEtWOUz0g4EnG8ntHPfCxNd+jn
	 UZguQOMxrmrHjsx8VQXG8JjtzywqCzawniFug93OojMezHRM7T0Hoqz+lfYQibeFF9
	 cZni/cwUgquBfE2XXxNA/dGO3y/WvuRn97YHSCiffyy1RTxslKI+LzMpvfOv8McSjk
	 yCxQsEs373mbw==
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
Subject: [PATCH RESEND v2 09/26] s390/cio: let procfs copy in writes
Date: Wed,  4 Nov 2026 20:44:25 +0100
Message-ID: <20261104-work-procfs-drivers-v2-9-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3388; i=brauner@kernel.org; h=from:subject:message-id; bh=lEA79OgzD1RbbuI3leV0mq7RtW4au2plI+2F9ffJvH8=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97qo1Prvbv2jWnmkmH6pDufs/6rfzTKnoEu5evTnGy 2WLm6V9RykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwERk/zIybEjl+VB/KeuDnbef yim235O4L5f4ub8sDT0fcZyRo2NjBCPDPrXc7kQ1lzbL+Yvap+65J7Y7TdL2ycNNJx9pnjvSsWU KKwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9719DC0005
X-Stat-Signature: bqbj4e5ok8ad8xgy4s4zd5brjockk7zn
X-Rspam-User: 
X-HE-Tag: 1793821480-254587
X-HE-Meta: U2FsdGVkX19l+uPJDMRL/8+Rgkn7uLH+Kiv3qaHecE//IY48LAL3lYMSCLLVUmZjPtDiuEzsCJAudVkeZnpmjSXl9KhnKyX39SoLdLZxSdg16L+yuoVhPkVQM++iq+Fym4cDQrj+9dKZDO+fj+vKGITxE+wrtSAqV6HgW05G1QiTuRPMLpJ6DIrr7udzDfnB98WjX0XCSpEG2xIlI0casThseFf6zV3vRpUJBie2PFXyfuIKKWK+9T11W/dSCvvngWKEVYNNyNfR2vW+9PW/IoDFZlJckXOYEM5fxEeLFhxswdnSVLI7SZ/IkyQFRZh4+5/RuTfZxZsFAFj0Tmvew20TlC99f33E3U1/vFPgf31yMUCKLgpwScSB85JkU6sqLCgKqJ8Fzfi9pjEcofJInA1GF5TjEntlZxQh9Dnr5w83EWvQ9h773wIyrnBx+5SafYMSsijysMo3jCUa+VUx3ww+h5W+Mt48ay40p117iNN+3y+5oHtkKNH8q0J2CUN7OjpaeuCAtiVmH6yWrC4QLGVJJ7tXyqoxNtcGB6KoM2aLVEcYyfrZADOwB0l04tnAvAq0/ggFpiroi8nzNoRYV1gRr8/oY3frrJnni4yge67SKIod4xbAVMJjbvCh95x3SkjY6tVH6FFIRJAD3+sCXKLbqTpgL2K3DpPDxcwymKahjRqt3ZXKCY7650wf00yYp995yWrfHiLALXoyifni2sWMKEi0O+fwpj8/Usn87oCtFJka3w/SKzR/QyWlttJ3VBlhoB652KSQHuB1izLLMtYyD4kkHqfsZRPWWKbkA/6JEa8CBEnCJr1xDaDm5idkxrC2aQOQD/WHFDxi3IofhlMictKgJADhduHK0FfbPtWntnn9FB1tIiuYtZpJVnLwwQR1a7pndI143kS5wEb/QN2vMRyVZ0dXi6NCRlS0/n0mv54kBUS9+Oo/+pyeqfx4MJfepekERjNgbyLpd9h
 sMJAWLjx
 6qZkUWQ36j/N102juKVRRGEssOHR1pPQ1h68k+rDg6dNDPSkIlK4sy6fZ8Qxh6/GOJkDyNnVHja60Wa/Id0JJNaU4Zp2SjZVfrulJfTBs+D5CtiIYI7vEhQ3rdrT9+jC391KduvKPxy1C/HULNQieglQRiPjo6rYYJjzkkXFddz9G5L77TQ4qBfuvdJy+OI2nDwTATS0CfdTmVh2eEIIUHQx2INUlf5SPP6/tTGa4hn7U/+4PY+gJTqNkca9kOq5Ld5P6RRrGohxtJ0VIfnuRwIyds2gdXuvbRcCtYeBgT7br5e3lXA1VWctyldVMr7xTwOqhjRDxTCZ5M8EaxUgfvsGRCl3+RrJBqmMyQ0ebgzn2tdFOxLmrB57MYK0HWomBLqN21A6DslesdV1LBHSRGv3krQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() for cio_ignore and cio_settle so procfs
copies in what is written before it pins the entry. cio_ignore parses
the list from that copy, up to the first NUL like strncpy_from_user()
handed it to it before. Writes larger than 64k still come up short, now
through PROC_ENTRY_SHORT_WRITES. Writes to cio_settle larger than
PAGE_SIZE - 1 bytes fail with -EINVAL now, it never looked at what was
written.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/s390/cio/blacklist.c | 33 ++++++++++-----------------------
 drivers/s390/cio/css.c       |  4 ++--
 2 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/drivers/s390/cio/blacklist.c b/drivers/s390/cio/blacklist.c
index 4e02f78f6102..1ec7915be6b3 100644
--- a/drivers/s390/cio/blacklist.c
+++ b/drivers/s390/cio/blacklist.c
@@ -12,7 +12,7 @@
 
 #include <linux/hex.h>
 #include <linux/init.h>
-#include <linux/vmalloc.h>
+#include <linux/sizes.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/ctype.h>
@@ -355,39 +355,24 @@ cio_ignore_proc_seq_show(struct seq_file *s, void *it)
 }
 
 static ssize_t
-cio_ignore_write(struct file *file, const char __user *user_buf,
+cio_ignore_write(struct file *file, char *buf,
 		 size_t user_len, loff_t *offset)
 {
-	char *buf;
-	ssize_t rc, ret, i;
+	ssize_t ret, i;
 
 	if (*offset)
 		return -EINVAL;
-	if (user_len > 65536)
-		user_len = 65536;
-	buf = vzalloc(user_len + 1); /* maybe better use the stack? */
-	if (buf == NULL)
-		return -ENOMEM;
 
-	if (strncpy_from_user (buf, user_buf, user_len) < 0) {
-		rc = -EFAULT;
-		goto out_free;
-	}
-
-	i = user_len - 1;
+	/* the parser never saw what follows a NUL */
+	i = strnlen(buf, user_len) - 1;
 	while ((i >= 0) && (isspace(buf[i]) || (buf[i] == 0))) {
 		buf[i] = '\0';
 		i--;
 	}
 	ret = blacklist_parse_proc_parameters(buf);
 	if (ret)
-		rc = ret;
-	else
-		rc = user_len;
-
-out_free:
-	vfree (buf);
-	return rc;
+		return ret;
+	return user_len;
 }
 
 static const struct seq_operations cio_ignore_proc_seq_ops = {
@@ -398,9 +383,11 @@ static const struct seq_operations cio_ignore_proc_seq_ops = {
 };
 
 static const struct proc_ops cio_ignore_proc_ops = {
+	.proc_flags	= PROC_ENTRY_SHORT_WRITES,
 	.proc_seq_ops	= &cio_ignore_proc_seq_ops,
 	.proc_state_size = sizeof(struct ccwdev_iter),
-	.proc_write	= cio_ignore_write,
+	.proc_write_buf	= cio_ignore_write,
+	.proc_write_size = SZ_64K,
 };
 
 static int
diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index 54b8b8639694..efd3df3e90ba 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -1278,7 +1278,7 @@ static int __init channel_subsystem_init_sync(void)
 subsys_initcall_sync(channel_subsystem_init_sync);
 
 #ifdef CONFIG_PROC_FS
-static ssize_t cio_settle_write(struct file *file, const char __user *buf,
+static ssize_t cio_settle_write(struct file *file, char *buf,
 				size_t count, loff_t *ppos)
 {
 	int ret;
@@ -1292,7 +1292,7 @@ static ssize_t cio_settle_write(struct file *file, const char __user *buf,
 
 static const struct proc_ops cio_settle_proc_ops = {
 	.proc_open	= nonseekable_open,
-	.proc_write	= cio_settle_write,
+	.proc_write_buf	= cio_settle_write,
 };
 
 static int __init cio_settle_init(void)

-- 
2.53.0



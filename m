Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70AE6607BD32
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ej70vPT/
Received: by kanga.kvack.org (Postfix)
	id 925916B060C; Mon,  2 Nov 2026 10:16:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D5996B060D; Mon,  2 Nov 2026 10:16:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C5586B060E; Mon,  2 Nov 2026 10:16:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5531C6B060C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:16:18 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A53DD12014D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:16:17 +0000 (UTC)
X-FDA: 85390529994.03.AC04B2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id BDF8020006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:16:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ej70vPT/";
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632575;
	b=SHrhNRPQoENVSpBAXjkPX08vUek1hjnBiLCCuONgoWJLFM4VC+4ujReN1xbrOgWLzMlogk
	LBRJq+DNOYT0G0h0CtmWQykFKrSQicgYraYLFV/tYtS041NkD7pbIU/QwhhUMkyIak756r
	yWZYpFSxdBZ2RMZSGVcaCeIsggxH4ww=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=goLGxFor5aDHmq+/63YZ7VsFVk0WPo8/IlwPxf0/q/E=;
	b=gdTFGU9P8GpFASHTMyfIJqI+0p2+KVMi7Q8Kj6aJ0qnulVCntWFaK1R53xL24TMVaoLPG8
	SUcn1lW959BNigjt/80FhVETpsHNddJhe63HiGheNUWku5OtZOZfs/LRazewA5TB/kFep9
	CjtVoxdYkPQ0dgLG5KRZjGg41oZEnx8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ej70vPT/";
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F0CD442A88;
	Mon,  2 Nov 2026 15:16:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B757A1F00A16;
	Mon,  2 Nov 2026 15:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632574;
	bh=goLGxFor5aDHmq+/63YZ7VsFVk0WPo8/IlwPxf0/q/E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ej70vPT/y7NrhBgRnVeJZJCWCJCY4Ir+tDI0qb3+EynguB83LrhQsFn2l3M5OZtXE
	 2VH+S87/JA3tEOQ5oF6NbafdeM5dvCGs7k+Pl66iGGY0VzHGdvfeTuOHMGET++saO9
	 8CMGsO+isRtfapDtsUOvJJ1+uTuGk8RHjvFSx0T6P4hnrtLPTR2SSKodt/mLQIBmk2
	 SzbEgwffy1kv1xXhMujkkGK8afuda14vw1NrfhyqY3qJhPF7pdO3kkpnpsfKhmpNYh
	 jxGaC2jmsD4TftiMbXuIK38lcVEqXr7YxWPTdZiDHhvMHLfLf4/cExgZfn7c5HC9H0
	 J+psMOIMcn0fQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:24 +0100
Subject: [PATCH RFC 17/23] usb: gadget: function: rndis: let procfs copy in
 writes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-drivers-v1-17-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
In-Reply-To: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1569; i=brauner@kernel.org;
 h=from:subject:message-id; bh=saz4p5rW2UOPmCRi+6zEslqjX7E5721ehvji7/y2TLU=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGropzGhaJWnu9+4zvQgXLhUThJNad18i/diIL3NsOXTHFLIm
 Yh1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmropzEACgkQkcYbwGV43KIUZwD+IHp+
 nA7hxed0nI3IkqLBHaX8l90Mx69iUsGXRMOlkboA/3KH9SLJ/MMw6rQ8ujZlKhQxzG1q+lU/vjC
 oZkDuYDUH
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 9a6oohxxdd8wdwodd4zfcykkah9e6fod
X-Rspamd-Queue-Id: BDF8020006
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793632575-176810
X-HE-Meta: U2FsdGVkX18bfSXUQC8frKa4EBwxhW2nby2c4XOxu6XuEBYc8PX8larK9uzmR/WzGo28bYzpi3NmeKhoU/yN5U9wbL7EsEinzIZk9K2AeR9rHXN1Lu51wedWA9EbXaSWU1Qu3oVeFfAFgFhsdoX8aPWYTuORQRvVQcerP0ndLX7GSKmgT4F8ofONImlM+8eznTMH51Eol/WAT24Y0hq8vUdjGPVF9FvBAlhdSy1l+Pt7spoNK95b1bcUOX5yDuIgoTZrgiLUZUFMI91pzyI4oO7Dlmr1BZnqrEAjIlMqc06ZByl+Evfq5/buajwhXJtQYBo+3K4OEic+brbVxQveav5KYh3+hdcb4j57EkfYeaJ0HMpxy/VE9wdUoiovdBw3x6vA/i0GzXGmHlPGcoBaPC+fiu75djD/ikITOUHqRYGGOqEBCJKEhBOUIiixGme+qqW6TX5Z35s1ELDRrb3KrgwSd7dCO6tK1A+w0e2BCmVmI3neHCC8ft4WR6xm2YqiAnkLzCuSPLmGF7/eEwjmpvpuplFtfmHMMzBqIiFjqwpX6lRZ9az7qZdWjmWii0RXaiCc67ar082oIRw+OywyzEf5i+xpcwrP5rrQcy67hX3odF3jvRgCBJSpBopZ8h25zPisVkPbBwuVr2zmzDCdZKZqyaZDujcELEg0oENxBX3+umN8cEtJGgDU4ZYjhViJ8XyzAjiTR8uGswDaMooMe7HT8ywk3CvG0Vk+952wsr+Dv0lXTB3HbJXPi413PMK/ZuZwMQLKPvDQpUdy0SVANOCKTSYXIHmXI2e+mcJRYmaogutpQZB0f7aSG53OVTqBa3eoFGN22Nvsr/a9l2Qmsajv1e6QSv2HdV1DSBS+h+bGACr4DdKd9kSm67Zy8exqZw7OvlGwzuLeRRvay16Y8rTngX4J7E7jAYcUQ9b1Op7wlXneuWcctIDu5oa4Lj7pSKV1t7M6aKleF/WvJpA
 n/ozX/Hx
 O/mo5oGmx/uCRPIAg/hhd5aLpsXgCKcITkxjHxcjspouPJHZo1VY3R8hw6GxaSxSRqBoN8DsWQZUl4a8LgmKoLXVapiBB7mALvu/OKxFc+FQxov/a0OnLuIveAyOIhYrCO/UrjbMj0bd03l5d5zy4yxUIJ/PyXGrfecfzr3MR6/Zbxhlw3uRBq8g3syTG3hreRIVP6Hj8tTnkLJ6PAxKWkf+gD+VrWlgmQeL9th3Ho6NxeqDp9tHergb9X7GuOXW/1f3w3NhIR2o9oURo6y4+jV4RrwCOJRG4FjxfQ0fSWKDu4rxudlsUUFfrQ3EAXoDeZ9lKXZ7ZClxkbaI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written to
/proc/driver/rndis-<n> before it pins the entry, and handle the
commands from that copy. Writes larger than PAGE_SIZE - 1 bytes fail
with -EINVAL now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/usb/gadget/function/rndis.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/function/rndis.c b/drivers/usb/gadget/function/rndis.c
index 3c7bd30b8a3a..e05e0c6ae8fb 100644
--- a/drivers/usb/gadget/function/rndis.c
+++ b/drivers/usb/gadget/function/rndis.c
@@ -1138,7 +1138,7 @@ static int rndis_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static ssize_t rndis_proc_write(struct file *file, const char __user *buffer,
+static ssize_t rndis_proc_write(struct file *file, char *buffer,
 				size_t count, loff_t *ppos)
 {
 	rndis_params *p = pde_data(file_inode(file));
@@ -1146,9 +1146,8 @@ static ssize_t rndis_proc_write(struct file *file, const char __user *buffer,
 	int i, fl_speed = 0;
 
 	for (i = 0; i < count; i++) {
-		char c;
-		if (get_user(c, buffer))
-			return -EFAULT;
+		char c = *buffer;
+
 		switch (c) {
 		case '0':
 		case '1':
@@ -1185,7 +1184,7 @@ static ssize_t rndis_proc_write(struct file *file, const char __user *buffer,
 
 static const struct proc_ops rndis_proc_ops = {
 	.proc_show	= rndis_proc_show,
-	.proc_write	= rndis_proc_write,
+	.proc_write_buf	= rndis_proc_write,
 };
 
 #define	NAME_TEMPLATE "driver/rndis-%03d"

-- 
2.53.0



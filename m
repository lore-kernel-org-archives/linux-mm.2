Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA2C2606D820
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ju9Cdiwd
Received: by kanga.kvack.org (Postfix)
	id DBE996B05B3; Wed,  4 Nov 2026 14:45:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D940A6B05B4; Wed,  4 Nov 2026 14:45:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAA1F6B05BB; Wed,  4 Nov 2026 14:45:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7D866B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:45:41 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 46BDD1A076D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:45:41 +0000 (UTC)
X-FDA: 85398466482.05.50F6B42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 834E28000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:45:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ju9Cdiwd;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oFfWvBKtBhqs+rwLAKfNEZHrMKd6RrVgssTSPyI9nB8=;
	b=jfWKxJTYZ184EN1idV5TihyNtAuZpc7jboNCyrW4Su3wvmnInlKgfnI5QDSewJI3qXWejl
	BVYy/wyZiv9Js+hjRr/1Rr04aDszTX7vHbgIop27SKA11WiZfOlYo1ROn8OTTBf0n5bQPS
	GAgVWbPGw3UdNqPQnsZ3chh3Ff/lwg8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ju9Cdiwd;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821539;
	b=RK6Xy2Tus0juT4UUwCui+jaRlvWHgWnukjlqM4gX+O6qBMBdstZSFFd8BRHQJ4njqfcs1Q
	PWxvyk7L4mnNdYw3A5QxvnE6hCw22cf3rtmjmdud2WrL5AutAeh3qM24QpK1wlU9Eemq4A
	y5ofmvkMyJwRu4EgvghfjCFFeSjXgV0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D2752414AA;
	Wed,  4 Nov 2026 19:45:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19331F00919;
	Wed,  4 Nov 2026 19:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821538;
	bh=oFfWvBKtBhqs+rwLAKfNEZHrMKd6RrVgssTSPyI9nB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ju9Cdiwdukzo03f6p3hrq4bQpCrNgWvbzSyS1vs9NG/W3HaXXkao3M2u4LfrHoe8e
	 wxtviWGSsoNjRsbvKzRys/CwzzFLfUcvMKaGQhYPmPxrbu1L7QiWnV3ZTrh/R1Otfg
	 qrZBJdrHCIeziUsqnpGD0JFkLrcuH8m4/I4Ww7FZSJ/tfeBBZ2ylMzghmAuc9eeX6s
	 vgBVV5T3IgnlsvU9YQnkv2d3jFbbKDOzj/iykYH1zv74/Pa9kQYvwQBnjIDHwdeuOQ
	 S5F8Z7xCaT1zZASn9AYJ/xAtcbrp0J7I7xiLDkK+QT5iUpaPPLtpiC82DCigeWcdXX
	 vjvXnJgaA/cBQ==
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
Subject: [PATCH RESEND v2 13/26] scsi: sg: let procfs own the seq_file of allow_dio and def_reserved_size
Date: Wed,  4 Nov 2026 20:45:24 +0100
Message-ID: <20261104-work-procfs-drivers-v2-13-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3098; i=brauner@kernel.org; h=from:subject:message-id; bh=VSyXtwS/L1yz+NXwjilFwHBHf/9gGBvzhq16zAIuGuA=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97mpK3v7SU35CpJ+xYm16aqH2yss8t52nRXwy2L6hU PiyM6N8RykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEScShgZ/oS0JG41sBdwnT31 V9JTpX/eEnvWXFfxXHvv8uNV8wXXGzL8ZGzdvX7L3xQtdoGX5tttZ9355tPw6sDfkq152YVBvd6 fuAE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sx7u8a1pmnidrnzka3sfnrxofg4hr9ia
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 834E28000B
X-HE-Tag: 1793821539-988467
X-HE-Meta: U2FsdGVkX18OK1lSgg3dQT2El4Xgh/X4aJnzzWeju+QQ7jFdm/Q2R4dTTbClC62NYLRUikCPXYocwWt5LPF+8asv0wv8RX6NfxE99WpKIcVnWMnLPadoFZ/ZIFa3tsc58viLxl6HDX/+Bt+bXNr0czmYvUKiNBGKHWJEmu/VQKscQsmfqyx61pF68xZDmZpm/ZcvMDx7ahCazifoprE2eNbiHgiyoGTHookJhnpToJ3AMqB3ITH6oi82pnWvezMXCZOqabRFjOeGLhHPHes8T1hZXVBQxX17DMJBIhRhnZ8dpvcad4aGO3fuWVLTYfGGXIpMfNqIMMWRmU/yltAVCIotuEP7tJ9SEMqR2S8d3thc5KCLA4df2hLLrlMjHSmYMpc76tlwhOyU/v8OP+K1dhNlwCVNeB2qrTIU8od2GkqkSIHgOC23fDmrCTrRvAo3xO7KexO1g0wbt6jdAccHQ7OdGCbPRIX9/45GMs9aZq0TcO48V9Poqo0E2ALFDMn49Iyg2mNErvxijIFun1HBGJN6C6taQhYCPxlr8Qus/NggzVqQ1D5ZJpUOWN30C+xMnrGh6bx+dGQsygZhfLgMIQ2gae74UpGQrELvkdXl9ozZFZcX1/GjP/BwEKsWsa65Vdb09tt2zXCF1Ux6S1gjxCP+X0LyPk2eo1MTncUlXWIkafHfJA3KUVdlpw4wJ/NF4/WJwGwPYh5fsQhO6VJlUWrrrNzt9IlYshFH5YzQVdP7/ZvFSzi7Y7ZRz5vuAQbov3AiGguR8ffApzFNoHvR4EYex4GF2mJCAkI0TNwujDT6k+Q0d7E1TzJMubKpF9B2y0DdA3NiDldoQQW3gpNlBgN8sd3SBXpYkFW319B1QGml1xc1mC3kt9fyfdWbLaJu6Hq/K/voxmm+/VXDR8SvKNY0nuh2JekARL3tA+1TnuBzuOxxKc5GnXyrKxxdrFlqyuVmJpms7dPhL/SNLLW
 rxPmM6aA
 l6E0WfAGwHryPY1BiQled2aAlfI5kVyBzCJlwbjZBEeJGF5q0igGkdrivSepBSqm5oA3j139S3koVZdQK+ULImBV9LlmVhIjfJLXuWCLsT9sXxTcv6158Fj6sLhHjTq4/M8anX1k3UOBIpfPw/u4VBdENZ9uPNfGQZz/Mm7pt/LrvP4jIj4ItH3TaU5EfQTlyU+gx2n/popQ1p5C35U0YKs6sODdwu9Og9WKWA7qXcUBhK1HO4+ZNLfD68yAtUpgiK3+L1XkZfH/F33McFpHPoSxh4xHGAYMdzaFh8f+SIeLjixgD4Zvwmtut76HsavOTYNO5jpjofz++7eABFMXr6utONhyA3aGyMbokEnucybwWN4hmWndqlfSJYaPtb00PRuQ0pHisBchZNwTuv2QwOccxtzp6EBtq1oR1jHDyV8hn/snS5/1b/CfagX6Gj+RddjtjjEdbI99ayP8g/POC9xAIf/IBxyHWZOibSpzT7vA9LTYSoFZd4rcXCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Pass the integer they show as the data of the entry and declare the
show function, procfs then opens and frees the seq_file. That makes the
open functions unnecessary.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/scsi/sg.c | 28 ++++++----------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 6551f1284d44..fb3ab74e8727 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2288,26 +2288,18 @@ sg_get_dev(int dev)
 #ifdef CONFIG_SCSI_PROC_FS
 static int sg_proc_seq_show_int(struct seq_file *s, void *v);
 
-static int sg_proc_single_open_adio(struct inode *inode, struct file *file);
 static ssize_t sg_proc_write_adio(struct file *filp, const char __user *buffer,
 			          size_t count, loff_t *off);
 static const struct proc_ops adio_proc_ops = {
-	.proc_open	= sg_proc_single_open_adio,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
+	.proc_show	= sg_proc_seq_show_int,
 	.proc_write	= sg_proc_write_adio,
-	.proc_release	= single_release,
 };
 
-static int sg_proc_single_open_dressz(struct inode *inode, struct file *file);
 static ssize_t sg_proc_write_dressz(struct file *filp, 
 		const char __user *buffer, size_t count, loff_t *off);
 static const struct proc_ops dressz_proc_ops = {
-	.proc_open	= sg_proc_single_open_dressz,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
+	.proc_show	= sg_proc_seq_show_int,
 	.proc_write	= sg_proc_write_dressz,
-	.proc_release	= single_release,
 };
 
 static int sg_proc_seq_show_version(struct seq_file *s, void *v);
@@ -2348,9 +2340,11 @@ sg_proc_init(void)
 	if (!p)
 		return 1;
 
-	proc_create("allow_dio", S_IRUGO | S_IWUSR, p, &adio_proc_ops);
+	proc_create_data("allow_dio", S_IRUGO | S_IWUSR, p, &adio_proc_ops,
+			 &sg_allow_dio);
 	proc_create_seq("debug", S_IRUGO, p, &debug_seq_ops);
-	proc_create("def_reserved_size", S_IRUGO | S_IWUSR, p, &dressz_proc_ops);
+	proc_create_data("def_reserved_size", S_IRUGO | S_IWUSR, p,
+			 &dressz_proc_ops, &def_reserved_size);
 	proc_create_single("device_hdr", S_IRUGO, p, sg_proc_seq_show_devhdr);
 	proc_create_seq("devices", S_IRUGO, p, &dev_seq_ops);
 	proc_create_seq("device_strs", S_IRUGO, p, &devstrs_seq_ops);
@@ -2365,11 +2359,6 @@ static int sg_proc_seq_show_int(struct seq_file *s, void *v)
 	return 0;
 }
 
-static int sg_proc_single_open_adio(struct inode *inode, struct file *file)
-{
-	return single_open(file, sg_proc_seq_show_int, &sg_allow_dio);
-}
-
 static ssize_t 
 sg_proc_write_adio(struct file *filp, const char __user *buffer,
 		   size_t count, loff_t *off)
@@ -2386,11 +2375,6 @@ sg_proc_write_adio(struct file *filp, const char __user *buffer,
 	return count;
 }
 
-static int sg_proc_single_open_dressz(struct inode *inode, struct file *file)
-{
-	return single_open(file, sg_proc_seq_show_int, &def_reserved_size);
-}
-
 static ssize_t 
 sg_proc_write_dressz(struct file *filp, const char __user *buffer,
 		     size_t count, loff_t *off)

-- 
2.53.0



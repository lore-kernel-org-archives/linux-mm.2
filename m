Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35110606AB88
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iGHhpB98
Received: by kanga.kvack.org (Postfix)
	id 4574F6B05C3; Mon,  2 Nov 2026 10:25:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42E916B05C7; Mon,  2 Nov 2026 10:25:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3444F6B05FE; Mon,  2 Nov 2026 10:25:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D4876B05C3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:25:55 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8D28912016F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:25:54 +0000 (UTC)
X-FDA: 85390554228.30.2190993
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id A4D43140008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:25:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iGHhpB98;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u3HTYGmb1x7uDyRawit7Dffu0Uk1tIeuw4QH7NxI4G0=;
	b=3cY97TUYdncskd3XmL30IIvMRAgfWUMjI+o/kqwiYkJxU1WtgOsD6afYLf6Ie4H43GvIUA
	DwqpAu4OL5Hzu0zxqB41g6IORHHQUvjXIqR+nZeSOTN97usTSqVHmINPIb5KtUU4/ulGXp
	54RDLE4ZrAVEY1RheUO2AcX2tmKr40U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iGHhpB98;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633152;
	b=f1wR+4SY8LTqJq080rBV9hBGg2o8aqujW3ApkR1LheH1zWQOZvsBNInTg3b+UDADcQabK9
	9rAd4milSb1QkWd6feqAYTjqFHzUO9kJjRfCq0N5FuHyWgjjqfOqkS99seQpnFYqlMOTb7
	vqliHXSdmk78XcO+xQLKJtAy1XPtb2k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E56AA413AD;
	Mon,  2 Nov 2026 15:25:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313B21F00A17;
	Mon,  2 Nov 2026 15:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633151;
	bh=u3HTYGmb1x7uDyRawit7Dffu0Uk1tIeuw4QH7NxI4G0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iGHhpB98VtzSPCbdmRXR/jCaFOOHZgng77vUnXXpa/iWV7qgDLNgW+ckdUHqU4P7W
	 lDMM7rzM9cD98EU9ntqwmlo6AuOoYZdNE3YkTnnk2jPoU8L+XDA+C+OYpRSKBliOpJ
	 Rg/pR2WDpOWUfNwbK2q9lS3ZnE/kvv5zpOAi991IrpIVqPKvYKM9BLNcJnUUC4UvoB
	 LpQiqxDLLPWF2bD3oAhWzx9vrPEIlvXjP3GUu14Y6hE+qmOaf7p2eyQbu01WP23SRb
	 Hyz2xBroBzw/ny6J0hknPSpAtx/1qvcvkfpvBp5y82d9lfWO4ucvYBvmjUl8jn1DSn
	 Ypg4M07MNUeaA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:27 +0100
Subject: [PATCH RFC 17/27] sched/psi: let procfs copy in trigger writes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-fs-v1-17-d09a996317b3@kernel.org>
References: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
In-Reply-To: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3970; i=brauner@kernel.org;
 h=from:subject:message-id; bh=SVvoMFbFBzWPlCiJZBe1GzsxYGasrV4wYLo3Ox4kbh0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG7UxHvptWKC9c35XSF/kpOfaj46/DMkOOHWrllLi
 9QWsUrmd5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwkrYnhr3D29W9/ZF+bKy49
 qjy90y2mc63R6pC8HTt6pc8+Xi//Rp6RYb+Q4b/rejGfVzTHsppfOHRxw+yaxoZfLDYTXlT5z3p
 mwAEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: A4D43140008
X-Stat-Signature: jskwqqwsztcjm5ncg4kzw5mcpnriuc5j
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793633152-907468
X-HE-Meta: U2FsdGVkX184YSZ23pkufKx4sCHEyD34xHXhc6y1Whu3qPVzm/rqUJB9WExIpi65ZWl/qrb5b8KOFHyvjsC8DWwOC8RKtyax257Vz605teMy0ty8huOUkPm153v9Nffh/asXWyMWmL2v4BcyHWpg6tWm/xB8kyuWDdRLzEkVK3Aw5QnW/ppAhx+lpC0Qrmkg7Lo2oegvQm2fCDYOttTS4DT/5GbhcjJv8k/SI1vgmGWb4bdOHMVCs08Mx5BSXvIhqBsZQBL5tiy85+2DWpQP2vHS2xyn3P0C3a7XmevXY08FdJjw74OW7aaqBwz/yd/3GN3NE4TCATKBWa9gTRsldvHGRyrVxIjScgWUTEpfTNtZYOcO2YlMxZnaH0EF41mFCD+PPLgl+XDnrUQqvZ/IJKAlYeF+thqP3z+bQImUlXHq8dDpQf31cPb7UunD0ac7jn4zKx5kGEgi7VamKEviupRMI3AtgzmJU5h80f1YqxlGE+7nBqi+9Wnqf6eJtR26ahaRObotLMJhYJuVNq/+iWlTnSKLnt1Sh1QBEPJKQtk2YpUNAsWLqMoPEDNY+AKC7MThASYUqSeT+CAPO/Nj0gftkqgEB+1YdgrEij1K3/V+R5F0hSlPsCPAEX7qqW6jfTl+NOJtieOMarp/658NwZFev8I9EDpw8UQ2Y8FyT11qQrkbW0UC4ZxECdCxj3qOH8zvn7PoPGpqls2Wk0IId7PEilViXlcMU3fkgevzjchOohjuWQjGcN9fYw3VzgoAhh/ErdHE3IwFLTyP2rDqgA3gtacB6vL4/I6aAu1SI9tWvus/W/1rrSOfA1P17Ec7nnw5ND66FTKgfOYvhvODWVl/kA4DcY0i5DTefSRxY36fOEgzNyd0NnrTQ3HYSNEOEXOinp2Fy3QWxs+xFr+qc17t7u25NFCN1NP+LafdH7UwiEl5XNHVyhgQLAhW35ZDdsKpa45pC7Y10dyIyY5
 iP+BdJ3p
 hZZZqwbDEwr9PCgnKXiB59kISIYGevgokajEXikC11tMUCTZokDqvihtg1kxp7I9kPWrmUbTnv+g4SNqY6osxyR/ApnpigvDEWiejHPI55OETN09j53upHLTp8ieEWH2cPsuSFf/2yC+yBxPSRC2RTZhh3Yajg7cb5HUT8g1YP76O49iQzolD+1Z5EAPTAm8S1vgEQpY+I51/TDZ7s06nIXpwmsRoDvO7QdIXHJlQwjotfcqns4D/lQmnNlKHlCl0ySYIy/9o4mDRnm1ID4ZmXs4hVbRMe+1P7Syv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() for the files in /proc/pressure so procfs
copies in what is written before it pins the entry, and take the
trigger from that copy. Only the first 31 bytes were ever looked at.
Writes larger than PAGE_SIZE - 1 bytes fail with -EINVAL now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/sched/psi.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index bcb8bf4e0b69..3132105bf382 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1535,8 +1535,8 @@ static int psi_cpu_show(struct seq_file *m, void *v)
 	return psi_show(m, &psi_system, PSI_CPU);
 }
 
-static ssize_t psi_write(struct file *file, const char __user *user_buf,
-			 size_t nbytes, enum psi_res res)
+static ssize_t psi_write(struct file *file, const char *kbuf, size_t nbytes,
+			 enum psi_res res)
 {
 	char buf[32];
 	size_t buf_size;
@@ -1552,9 +1552,7 @@ static ssize_t psi_write(struct file *file, const char __user *user_buf,
 		return -EINVAL;
 
 	buf_size = min(nbytes, sizeof(buf));
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-
+	memcpy(buf, kbuf, buf_size);
 	buf[buf_size - 1] = '\0';
 
 	seq = file->private_data;
@@ -1590,22 +1588,22 @@ static ssize_t psi_write(struct file *file, const char __user *user_buf,
 	return nbytes;
 }
 
-static ssize_t psi_io_write(struct file *file, const char __user *user_buf,
-			    size_t nbytes, loff_t *ppos)
+static ssize_t psi_io_write(struct file *file, char *buf, size_t nbytes,
+			    loff_t *ppos)
 {
-	return psi_write(file, user_buf, nbytes, PSI_IO);
+	return psi_write(file, buf, nbytes, PSI_IO);
 }
 
-static ssize_t psi_memory_write(struct file *file, const char __user *user_buf,
-				size_t nbytes, loff_t *ppos)
+static ssize_t psi_memory_write(struct file *file, char *buf, size_t nbytes,
+				loff_t *ppos)
 {
-	return psi_write(file, user_buf, nbytes, PSI_MEM);
+	return psi_write(file, buf, nbytes, PSI_MEM);
 }
 
-static ssize_t psi_cpu_write(struct file *file, const char __user *user_buf,
-			     size_t nbytes, loff_t *ppos)
+static ssize_t psi_cpu_write(struct file *file, char *buf, size_t nbytes,
+			     loff_t *ppos)
 {
-	return psi_write(file, user_buf, nbytes, PSI_CPU);
+	return psi_write(file, buf, nbytes, PSI_CPU);
 }
 
 static __poll_t psi_fop_poll(struct file *file, poll_table *wait)
@@ -1625,21 +1623,21 @@ static int psi_fop_release(struct inode *inode, struct file *file)
 
 static const struct proc_ops psi_io_proc_ops = {
 	.proc_show	= psi_io_show,
-	.proc_write	= psi_io_write,
+	.proc_write_buf	= psi_io_write,
 	.proc_poll	= psi_fop_poll,
 	.proc_release	= psi_fop_release,
 };
 
 static const struct proc_ops psi_memory_proc_ops = {
 	.proc_show	= psi_memory_show,
-	.proc_write	= psi_memory_write,
+	.proc_write_buf	= psi_memory_write,
 	.proc_poll	= psi_fop_poll,
 	.proc_release	= psi_fop_release,
 };
 
 static const struct proc_ops psi_cpu_proc_ops = {
 	.proc_show	= psi_cpu_show,
-	.proc_write	= psi_cpu_write,
+	.proc_write_buf	= psi_cpu_write,
 	.proc_poll	= psi_fop_poll,
 	.proc_release	= psi_fop_release,
 };
@@ -1650,15 +1648,15 @@ static int psi_irq_show(struct seq_file *m, void *v)
 	return psi_show(m, &psi_system, PSI_IRQ);
 }
 
-static ssize_t psi_irq_write(struct file *file, const char __user *user_buf,
-			     size_t nbytes, loff_t *ppos)
+static ssize_t psi_irq_write(struct file *file, char *buf, size_t nbytes,
+			     loff_t *ppos)
 {
-	return psi_write(file, user_buf, nbytes, PSI_IRQ);
+	return psi_write(file, buf, nbytes, PSI_IRQ);
 }
 
 static const struct proc_ops psi_irq_proc_ops = {
 	.proc_show	= psi_irq_show,
-	.proc_write	= psi_irq_write,
+	.proc_write_buf	= psi_irq_write,
 	.proc_poll	= psi_fop_poll,
 	.proc_release	= psi_fop_release,
 };

-- 
2.53.0



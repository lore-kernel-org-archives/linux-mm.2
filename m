Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 781506091CB0
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=inKajwEE
Received: by kanga.kvack.org (Postfix)
	id 8D17F6B0600; Mon,  2 Nov 2026 10:13:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 881DF6B0601; Mon,  2 Nov 2026 10:13:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 771FA6B0602; Mon,  2 Nov 2026 10:13:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C1236B0600
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:13:44 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CC4B91A0187
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:13:43 +0000 (UTC)
X-FDA: 85390523526.01.BB978CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id F1FC1180009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:13:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=inKajwEE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rp3cBypvlPCLWQcsEgZutivLH7EPpJBFO75qhCW/oJM=;
	b=YK3pS38KzYqBs2rjCyTfsHB/+1hbY++gM/37u1eSZ3Xkx9EaunsZLhSRUYFm2MldTXprEG
	B93XOlF3+qs34N/KvSK2uppmf31lUibnRn/39MmOSvc5sfAuRIoVA0Hap5xMOhsbGDRRNV
	W9GjcWh2XsDTscHJ65jLFi30B6Nmrpw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=inKajwEE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632422;
	b=0Ux1rY5HTIaJqGAWtcCr5Hj3+OVNZshSzRQaQxIGlN+jY+Bipvd4eq17ndIZ+uEqDYLXFS
	SwF1GGzv9QciHpqjyb2oLMzy1b9lGw5+BTF43PmrS+ylN55ofF5G+ta8fWnSyr3lwSkW9P
	6+rU6HkUlg15VlPEmjW5FJZPM8MZth8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 54B7E41860;
	Mon,  2 Nov 2026 15:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49A41F00A16;
	Mon,  2 Nov 2026 15:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632421;
	bh=Rp3cBypvlPCLWQcsEgZutivLH7EPpJBFO75qhCW/oJM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=inKajwEEAwMoHnDPteIsszpp+0/UJE+sH1dcRO3L/FVi7pG6bML9PLf7beknb8BdL
	 5MQTx4jDbN6vOHeJxw6i3QBTD/vaTRhHRSBDcIcLXd+3e9HF074pZjh8KpAt9SGtmt
	 JOiGL6Tx8k0xhC/Euwa1o1K150jjjSE7j8GK34RKndNsCPhq4JCoa1y8V/FJaak7tQ
	 sIo7pPqK3wIVaSyqVLUcMOS2/mUFkthHgMUSqu1fTag9cUMixxI0kmyYvEBaUL/61N
	 /p62SUvaIR4X5tJTeFjC9esd/XuiBrsEJMh9ZeLl3eTyrN3FqEcwOKweqLGafV76hM
	 GBi4RyeNSgR4Q==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:17 +0100
Subject: [PATCH RFC 10/23] scsi: core: let procfs copy in writes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-drivers-v1-10-a994bd4d3b1a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5090; i=brauner@kernel.org;
 h=from:subject:message-id; bh=vGFrM/mDJbel5Ek/YnwRAY7y8jtd20EKftAALqu9TzI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG6wbs9mk5mrv0xU3X+16EaLjJbetu1Tahw0NK74G
 XJYrLy2oqOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAi9+8z/NP5dyTkr+Pqgvks
 tmYr2GzsdlxjWTkn2a8rR7w2gk/iwnaGf6oJ7vtUPv35vWtB+q7r99Z2c2x9l6Jyo+P0aQ5b7gu
 905kA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F1FC1180009
X-Stat-Signature: u1wudajdy64yrxrbxgzch3cqtwr3mw1d
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793632421-461704
X-HE-Meta: U2FsdGVkX18dn7XJG9KoySPPgs/C+sEVtMlLqsJFRIxjPOg6H98dxVflGWHt3Of7EF90a0n4rnHhOJ29FCHLp+on/zj2sQCl2vLrDYxYv3Nm6qQl+h/vNMaQteeksPvO6JX/VFhMcCWVSscueeoNzxcUrvFb852gIOhjkVcFMgfJUB0TLivVwnq0UBa4W9xZJIzjp1cu2dj0fpPa0hSJBV4kzCi6OVuvdRhssGcYVU0UJk3xB10efJ5W57iRt0diUZFI3GaB8NMcwqAVcaA+X92B97EGAPFwFmm9AZNM6IPhR/Ghxpr3eT60hL5y/5FrohE0TSfrhebscWMmnPFwizGBxVFDp8kwusO3pRmBhnHMymgbVhuwjkmmtgiS4/ZDuuJcG8t+0DV67DlpTmtOWJXAjFn2UaMKgTvMiWDE84hv2IrRpNR1WQ+cQyWyZSEftWpaYBZtPd+1DWAjzdMKN4u3BKIjL49qPrxNnko152UBS7gJ1FwEWrWOuBIEtUtz1J8oK4NWptygZDUGJNgxwGjmylOzbp3o2phCdgcsHDtu1bTnRF8RfvX49TsZG3LdTSRRVjvfJ3Jc3gWl6jgo40mcByOQNlaKKNzd/ZwasKJTgp9imj586xnFRkH7QQ672zg3xHCr3nBM7OsZ/PXNtuqEP2jwcyPsGfmcRs4PR5dCFiLKMaPUTIURwxoQtLX1mGbQQccSgyCfOu5Dhh75OAjUZiivzWHIs+wafcpBfm+A2GLltoMU3RndYBa31xiC0l1GJe3x4XWg6E7xuT2ptF0z7ILomrclOz2R318kzfmkYmGxkhS+VAYNYFY/uPVGkRSJF0Qg4T9P/IuoIWG+bo2VnYtZkrkJchWSJveV+JN2LJ9zGZIxcMnpiFCz+vNFMSqb2olK4jSKimnSFjqJHEjCwiVRvNaWOLvKc4c5VuHVBo5frQu2WVe4A3VLJ0WV+PX3kNyu9ecHlNQkvPR
 NPqvyRVi
 PeDY5Y+bIKbDmSxCQVD9kAQZN+sFcHJJXbcs0LpGxYYALQS8TMxwjPmKH0pCi2Y/Dy6l8swQeyuIaMftBiGMWI3KPlBzpc0oClk+QCk11gl7TPUnH31HCWBDtW7BHMlhvDTz473YVn2G3Ri+efzvsA2p/5vfDwtOJ+NPjTe6H+bocg/LKOZm/TX4L6AmwaEOwj4zaYMvOlJNJpycZCIGEQDiwO8qnRk7wej2rFXVUFbCsU4hJeRYAFcI/WHhGH+oUvR4Kp0KYcZN1yGJ7ju+Uf1+zxtAm0JgbevKf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() for /proc/scsi/scsi, /proc/scsi/device_info
and the host files so procfs copies in what is written before it pins
the entry, and parse what was written from that copy. /proc/scsi/scsi
and device_info take up to PAGE_SIZE bytes like before. The host files
pass the copy to ->write_info(), writes to them that are larger than
PAGE_SIZE - 1 bytes fail with -EINVAL from procfs instead of -EOVERFLOW.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/scsi/scsi_devinfo.c | 29 +++++-----------------------
 drivers/scsi/scsi_proc.c    | 47 +++++++++++----------------------------------
 2 files changed, 16 insertions(+), 60 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 0b8f5ff40543..d9093851b23e 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -678,39 +678,20 @@ static const struct seq_operations scsi_devinfo_seq_ops = {
  * To use, echo "vendor:model:flag" > /proc/scsi/device_info
  */
 static ssize_t proc_scsi_devinfo_write(struct file *file,
-				       const char __user *buf,
+				       char *buffer,
 				       size_t length, loff_t *ppos)
 {
-	char *buffer;
-	ssize_t err = length;
-
-	if (!buf || length>PAGE_SIZE)
+	if (length == PAGE_SIZE && buffer[PAGE_SIZE-1])
 		return -EINVAL;
-	buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!buffer)
-		return -ENOMEM;
-	if (copy_from_user(buffer, buf, length)) {
-		err =-EFAULT;
-		goto out;
-	}
-
-	if (length < PAGE_SIZE)
-		buffer[length] = '\0';
-	else if (buffer[PAGE_SIZE-1]) {
-		err = -EINVAL;
-		goto out;
-	}
 
 	scsi_dev_info_list_add_str(buffer);
-
-out:
-	kfree(buffer);
-	return err;
+	return length;
 }
 
 static const struct proc_ops scsi_devinfo_proc_ops = {
 	.proc_seq_ops	= &scsi_devinfo_seq_ops,
-	.proc_write	= proc_scsi_devinfo_write,
+	.proc_write_buf	= proc_scsi_devinfo_write,
+	.proc_write_size = PAGE_SIZE,
 };
 #endif /* CONFIG_SCSI_PROC_FS */
 
diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index 59229bf9938e..5962e671cc83 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -62,30 +62,18 @@ struct scsi_proc_entry {
 	unsigned int		present;
 };
 
-static ssize_t proc_scsi_host_write(struct file *file, const char __user *buf,
+static ssize_t proc_scsi_host_write(struct file *file, char *buf,
                            size_t count, loff_t *ppos)
 {
 	struct Scsi_Host *shost = pde_data(file_inode(file));
-	ssize_t ret = -ENOMEM;
-	char *page;
-    
+
 	if (count > PROC_BLOCK_SIZE)
 		return -EOVERFLOW;
 
 	if (!shost->hostt->write_info)
 		return -EINVAL;
 
-	page = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (page) {
-		ret = -EFAULT;
-		if (copy_from_user(page, buf, count))
-			goto out;
-		page[count] = '\0';
-		ret = shost->hostt->write_info(shost, page, count);
-	}
-out:
-	kfree(page);
-	return ret;
+	return shost->hostt->write_info(shost, buf, count);
 }
 
 static int proc_scsi_show(struct seq_file *m, void *v)
@@ -142,7 +130,7 @@ EXPORT_SYMBOL_GPL(scsi_template_proc_dir);
 static const struct proc_ops proc_scsi_ops = {
 	.proc_show	= proc_scsi_show,
 	.proc_open	= proc_scsi_host_open,
-	.proc_write	= proc_scsi_host_write
+	.proc_write_buf	= proc_scsi_host_write
 };
 
 /**
@@ -386,8 +374,8 @@ static int scsi_remove_single_device(uint host, uint channel, uint id, uint lun)
 /**
  * proc_scsi_write - handle writes to /proc/scsi/scsi
  * @file: not used
- * @buf: buffer to write
- * @length: length of buf, at most PAGE_SIZE
+ * @buffer: buffer to write
+ * @length: length of buffer, at most PAGE_SIZE
  * @ppos: not used
  *
  * Description: this provides a legacy mechanism to add or remove devices by
@@ -402,32 +390,20 @@ static int scsi_remove_single_device(uint host, uint channel, uint id, uint lun)
  */
 
 
-static ssize_t proc_scsi_write(struct file *file, const char __user *buf,
+static ssize_t proc_scsi_write(struct file *file, char *buffer,
 			       size_t length, loff_t *ppos)
 {
 	int host, channel, id, lun;
-	char *buffer, *end, *p;
+	char *end, *p;
 	int err;
 
-	if (!buf || length > PAGE_SIZE)
-		return -EINVAL;
-
-	buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!buffer)
-		return -ENOMEM;
-
-	err = -EFAULT;
-	if (copy_from_user(buffer, buf, length))
-		goto out;
-
 	err = -EINVAL;
 	if (length < PAGE_SIZE) {
 		end = buffer + length;
-		*end = '\0';
 	} else {
 		end = buffer + PAGE_SIZE - 1;
 		if (*end)
-			goto out;
+			return err;
 	}
 
 	/*
@@ -466,8 +442,6 @@ static ssize_t proc_scsi_write(struct file *file, const char __user *buf,
 	if (!err)
 		err = length;
 
- out:
-	kfree(buffer);
 	return err;
 }
 
@@ -521,7 +495,8 @@ static const struct seq_operations scsi_seq_ops = {
 
 static const struct proc_ops scsi_scsi_proc_ops = {
 	.proc_seq_ops	= &scsi_seq_ops,
-	.proc_write	= proc_scsi_write,
+	.proc_write_buf	= proc_scsi_write,
+	.proc_write_size = PAGE_SIZE,
 };
 
 /**

-- 
2.53.0



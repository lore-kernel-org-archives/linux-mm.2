Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3000760C41B1
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HQZZk22I
Received: by kanga.kvack.org (Postfix)
	id 494126B05CB; Wed,  4 Nov 2026 14:45:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 472336B05DA; Wed,  4 Nov 2026 14:45:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381216B05DC; Wed,  4 Nov 2026 14:45:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 12E396B05CB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:45:11 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 81C701207FC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:45:11 +0000 (UTC)
X-FDA: 85398465222.17.F93CCA5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id CE8B7A0005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:45:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HQZZk22I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rp3cBypvlPCLWQcsEgZutivLH7EPpJBFO75qhCW/oJM=;
	b=r5uOV+wOWOexuXWC492qcA2FRdoo4Ikku6Ka/yarD3aBKiCsw44Q33y4p4eZ6lfR08C53p
	tyYpsz5BB5JG6gRqQbCC8gI2HgQD/30IzLrQe7enKWQWQ1qOTTajfSd2la3Uwt8j15zpKP
	7CJKmIkeVtvIU/8ctTn/gkjdOeRiUBo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HQZZk22I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821509;
	b=ByysL3pR05zNjkW50A9MJNOpfdDaEGQTfFUdcFSJ6Rpz9YWjfvBrlnJyfKGtouoO7IvLE1
	ofcnPBPEdRfQ8TwufranoYC/9H0RT8Y/mkwO1hxSO3hj4v/gd89FTXIx7pVlWV45H3YhLc
	ORrYYGThWZMyK6x8sITHAq8gIQQP9y8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7818060A9F;
	Wed,  4 Nov 2026 19:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F041F000C1;
	Wed,  4 Nov 2026 19:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821509;
	bh=Rp3cBypvlPCLWQcsEgZutivLH7EPpJBFO75qhCW/oJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HQZZk22IBDSdlRg9+GChLXhspu7iunkZLLfTPZExTpVWSZ10XMRGmnTYlf4TG3XAH
	 1cwjSXYkmlC+l/hnbMTY6YP/Kzl3udvQ65e0OecgcsLuWkW0rAc2mS+7lsMTsFJwex
	 5Mm7xmU/jLtpvu5WcV/D7gF7UYlkqWEYw175OcfKq5UOR7IVWPNSq4SA6IFaxtf5na
	 9paORCG9sxlWn9HEykiPNg6mhlzTVo5kiuDStPCb0diMzwScMmB/UEKOmuTvYKKKer
	 rmzoLKe6KegT6EasDc6fEzLXRRh89qOwFDegOrU9dPoQb3yaDpwnk6UqQg5okye4vV
	 YLTrXAZzXjLgw==
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
Subject: [PATCH RESEND v2 11/26] scsi: core: let procfs copy in writes
Date: Wed,  4 Nov 2026 20:44:54 +0100
Message-ID: <20261104-work-procfs-drivers-v2-11-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=5090; i=brauner@kernel.org; h=from:subject:message-id; bh=vGFrM/mDJbel5Ek/YnwRAY7y8jtd20EKftAALqu9TzI=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97mpQbTp/83Hlrc1+rz/OurT8HMOG96arD+w4Gdd2K pr9ek/Lho5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJBMUz/E+Jqow63i4ukh/z NaPAjPXzm42+O7RrV1sb6zj3n/W84cXwV7CJ58e5Hsv5XGU5lw4fTp7zeKbnjYq6WmGe/zMumlX 84gQA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CE8B7A0005
X-Stat-Signature: bc84otzcq7r4gyc7tmodq87gh4meyhef
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793821509-57438
X-HE-Meta: U2FsdGVkX18o7kgpDqmtbUzOeCv8K+knaupHlwmUXdy7q5tvBLzCuMMNFPQsf+03SqfJ2JHJTCxk0RSqlUgGVBFhE0VLK9WgP66DOT3oCnyqOWE7HEBBICDonQYRziQyNtyD9g881+YFQTH50Ap5YQm5OvFZmdpSkdSxAd3w0FC/qtGGJ4cCyPACN99jEMft8S/nStBIV4/Trn3rAhaDCE4u3WEocHNPh7DnhLzHvWXK8/vAgLTTJHR28kKvSTWTvVzzkn8VJJvGGoT3/JaMuZvYA8uw9Tuq0U5VxOlxEAGBjx/UMZEduZkgPT0b7dvDAhITFHouGBmimiaz0xEcE9qUnmrc/t6OAz11vpsZioBSduwTD8Ghsfxxjt0qBSXzYHDL9NlIaOxTEkl/I3EQAlfVy1rk4PymXEVO0NYYhlGKW1zROp+6mt09o7+n2/+X83eVx193tTgVjYJKIoweEiCDBQiwnrZ6+8JAT9yKFxyJGgSyKAXngO8jsT6COLa9T7fJxdjmbTTqocGnHrBZOZTkDMQxD/zc/3tlY/npRg5qWVXXM1bbH+c2WUffXMPJeAFV/DNHx+iSxaRJZCdAcXdmVKq0tyU/jvjSfdPaZcVMvMjnToeQBDR1FprUbvRvbhXizTkm1Ydmj1GE8VIB/ZcKgjxyqo95mOKZ/GfUGJ0W+4NzJpY07exjlM/8UdOJAPQ6vVy4gxek8aIA3sNlMwtgQakO/4agGFvbbVSTjHjf0Sos8WnJ+QzR5bF+EpqlO0lL/1YRfqJ2KMBNZcvBcE3+RudH3EYIZozTcEd5eO+RL3nUBwothaOcARVLuiYzLYAsx2LTaVOjUmqK61lnwKTep0u0jbksu/2nuv3vXsjGMbWoT+pLI9BX2h13R9gOSggsu22HVNCB0LPgPlyVAUGJS2VtuFaSTlHrautEEKMf3uJLHmQoWCr54/LjTp6CtaPrZ2nrSA3fjDesVcY
 hEUNyzWl
 BpwkJKrMNMnYrv4ABQzzyNM1tI2s2kueVpJQ8LjXB3cUTuzyvEAu0OZ5YOwSgJHeh3MyJBunpcRnKcSsHVf41/bH/69FIBcXMRbbQyCivSF9dZjZZPz1utZkjTQVGn7wqHi7haDRLxdqSmI3KmEodRBCiro/G23K1/7nZvPKbaQz4euWOsRUfVeYoVWzwl/sfErT65velKnP8rwr96jWdIALuOEP5oSifS06xEkIt8SyFblDfZuDM1eJNGssnEpc4cb8TwsKwr9guZoAyr32kq9c5RLGEK7HxGIEUbePmdvrMErOa/WDbkm8dk3N5ph3su0e1/+XaNkTqjIhNbWpkKV1si0EAo/MzQ2gV1WJ09OT/V/mO68tLEuGTovw/zyH6NyFjIijfPCngMmylv5X1r2KddQ==
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



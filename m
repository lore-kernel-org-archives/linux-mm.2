Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 023C460E1D4B
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Eiaz82nw
Received: by kanga.kvack.org (Postfix)
	id 222056B063D; Mon,  2 Nov 2026 10:36:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D2146B063E; Mon,  2 Nov 2026 10:36:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C1CB6B063F; Mon,  2 Nov 2026 10:36:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D722A6B063D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:36:40 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 74F4D16015E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:36:40 +0000 (UTC)
X-FDA: 85390581360.19.ED40DA9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9A5AC14000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:36:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Eiaz82nw;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tjh/IxDo5Afl5YrOen/L0CU1drIc7ik7Sylp2/yruUs=;
	b=O+rCaEUq2JkEGtmhOcC+wgTyWY6FF1Rj+jN0IN9rPx6DCf8iS/+H8M7RZ2D4NsaDYwi6a1
	xgW/5OesOh4X0HYn+h/oOs8IH3GZnFx92DygUVODVMrX4YsahXZS4hLFOoyecTSOurKyQ/
	V+ZMAN/fN9VIsnysHCR8JT8mWNsL+xo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633798;
	b=W+TamyNbvkBpxV6rOxsGq2e3hTbdHMPcCqU5dNvbZaCIPrc/RBXdga2jUmbxwJHgQYAX10
	fA0Lwoj02iVmApxCoCyxKMU3bDYr4mrAmEq8LyZVnfuB6bAjAVdulAvViDULtDMMHbVuji
	pxpqQ22uN9tjxLs6I/UN+p68qBj8AxU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Eiaz82nw;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DC9AB42E57;
	Mon,  2 Nov 2026 15:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CC41F00A18;
	Mon,  2 Nov 2026 15:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633797;
	bh=Tjh/IxDo5Afl5YrOen/L0CU1drIc7ik7Sylp2/yruUs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Eiaz82nwguW2Srh0jIhFPgXUQFrJ99MENrmffX1Dkd/hVvW3S2/Fim1j1/d+jOkt9
	 xasO+DLDNpqy9GW3dR9MQ+CMA98ypToYHpyzqjiDwvtbu44rp0kDDMY91Jwxlw+4E1
	 r9SanOw3MTpqH5hex7Scdb0BnwPziVv3zSd+695bRefvS1jwPfe4LvxX009B9+Chld
	 tA4fGyfB+ynvbJPUI+R3RGzjA4qTrACv4xHX9A2s53poUuAP60b80zUi08gaiNbr5+
	 6g/CYY+IE1hMVnb3EiQ/f/p1q1022JTLA12+EIacxtH3RvwXy/wsrwyjNOTj4wYE6a
	 k1UbfOctr82WA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:15:55 +0100
Subject: [PATCH RFC 2/5] proc: drop ->proc_ioctl() and
 ->proc_compat_ioctl()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-cleanup-v1-2-c40014bc12f5@kernel.org>
References: <20261102-work-procfs-cleanup-v1-0-c40014bc12f5@kernel.org>
In-Reply-To: <20261102-work-procfs-cleanup-v1-0-c40014bc12f5@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3666; i=brauner@kernel.org;
 h=from:subject:message-id; bh=VI/rJgkCNmarVQ2rvUsCUOnWkBPRxSnU+yfrm8hzjLU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WJn6rMTm44zjaqmfmpdMu8TJV2C0zJMxqVgg2eOsz
 5cv0Zd/dZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExk2x5Ghl8NbrkbQqX3O2kb
 f/i8x3/yMUXeK5vW+Zh+sl6fItSsp8vwP17wzrdTnj08oS8UUzfYLRfhCk0VnXDAY7vbm7tT9Rb
 bcAIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9A5AC14000A
X-Stat-Signature: ec3t3en94nk9weqhs6t9ykwoijhijwdr
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793633798-583961
X-HE-Meta: U2FsdGVkX1/EmXyjpWLB3GcAOEq2JZNfut+wQ8r7zVrce7nsZ5vN4PyOZ44M/dkEGtSV/sXW5D+YWOEMGILELr5bUzbqpIIeozqITnDH4LVjI6m+tkZ29dfRbe219XBdGOlNoZjzDGo2nNO5g8U9WkugVbh88o0kKHmBTcISOU+3rmlrBo39+t5EIrT/vkGYddtz2Xj41UfanXSj2C2rTB/J1oCl/MXgwfC+qNsF6q887cCoAq6j+RfM4ZIr8Uv/4rWSD5t/5ig7vBWh5CKy1rcz6ft2HeLzuvVQYHThu4JxV1bpzpPPNn24wtP2eM9WpO/j2YvHO0sP/Mrlm06OWKpCLkK4YzMyi7MjbrI2MpmAy0cMQLL4z/8nvqaXefp20kVLBGyArDSCjQa0rdNWir4IQJZmJLT+gvWXAuIKKi3RaSdkkB7fF9KQ4nxVCvzgvZQKI0sACCewdUxhLjmihiBgblsy1kJ0vG9Hl43veHvF3CKxXtWIexY1YCOQ+ysdsiqciW6ze0Zqkg7SSSG7l3jPmoOXUhnQSvYG14tqoIeR8UQt6Gpu98ORhL9iJqmEm6H3/HMYPm6pyhu9RvGyLNSa+wZHvtsyiQgLxi6b9fcHtSc7F+ZcBDGAns7w99fB/0sbzK6aRtOTqPqsvcfOTXASDVO65Rvp1iUtMKLlsrm+GH/1zOHNFQtig9eWReiPrex5g74oXU5FF09rinlrubmpZ10dkNeh2fbNZcMbObCkyJl2ldtaKU+07iEqmx03WEuTNSBmIsBkXacQNE4Jsr9Et7AggNFRzNwBj5AsF6xzKAHjocinIByCoNftRxmIK8YvdkRgTSar/PzJbYSD3vdbpPltVC2laTG65q5Yor7yjzggJhTOsFi7uhy6SQZYEgCypWBbUy2sTHM7KHdJOxpj9fNsbSn44TobBNJnOxxi6B9ScRkmI4nvGRBcRSPlronpJMyNkwP8wJ/DXaK
 bsod5nMH
 cImb5M03Q3QFfnBdMh56BT8DdtcdFPEv1hi35u2m/0TMSuPdpvVrJJepmWkIyDHNnmmxnKBPwCRx3FJ0e/s14vBDIDVIviGLRHMHKg9LrqCpeGSTwCaGLysq2KKwb2OACZSDJCtPnXBGI2X4qm7QYTea3r87D66gliq4+3ejkQ1dJq+zj5AgS7SknS+xyevY6MoOyiTi3rSO5/fjlwZvZNQdyshiJtFsH/q+cceRQRZqHNtqGny1fYWLrXdwWwIC5uFqA4hPePFU2/U/WMjeXZV+OOvMwYf9OOyhB+30aPiQKn7wMTuUKCdWlbXdbcAoHdLKQWjnrzUjPqYU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Every entry with ioctls implements ->proc_ioctl_buf() now and procfs
copies the arguments in and out around pinning the entry, for 32-bit
tasks too. Remove ->proc_ioctl() and ->proc_compat_ioctl().

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/generic.c       |  2 --
 fs/proc/inode.c         | 30 ++----------------------------
 include/linux/proc_fs.h |  4 ----
 3 files changed, 2 insertions(+), 34 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 7b2ed3c42d32..413382efefc7 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -484,8 +484,6 @@ static int pde_set_flags(struct proc_dir_entry *pde)
 			pde->flags |= PROC_ENTRY_FULL_READS;
 	}
 	if (proc_ops->proc_ioctl_buf) {
-		if (WARN_ON_ONCE(proc_ops->proc_ioctl))
-			return -EINVAL;
 		/* the table says what procfs copies, see pde_ioctl_arg() */
 		if (WARN_ON_ONCE(!proc_ops->proc_ioctl_args ||
 				 !proc_ops->proc_nr_ioctl_args))
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index dac5974d4652..971f2aecc006 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -551,14 +551,6 @@ static __poll_t proc_reg_poll(struct file *file, struct poll_table_struct *pts)
 	return rv;
 }
 
-static long pde_ioctl(struct proc_dir_entry *pde, struct file *file, unsigned int cmd, unsigned long arg)
-{
-	const auto ioctl = pde->proc_ops->proc_ioctl;
-	if (ioctl)
-		return ioctl(file, cmd, arg);
-	return -ENOTTY;
-}
-
 /* the table lives in proc_ops, which goes away with the entry */
 static bool pde_ioctl_arg(struct proc_dir_entry *pde, unsigned int cmd,
 			  struct proc_ioctl_arg *arg)
@@ -615,38 +607,20 @@ static long pde_ioctl_buf(struct proc_dir_entry *pde, struct file *file,
 static long proc_reg_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
-	long rv;
 
 	if (pde_has_proc_ioctl_buf(pde))
 		return pde_ioctl_buf(pde, file, cmd, (void __user *)arg, arg);
-	if (!pde_pin(pde))
-		return -ENOTTY;
-	rv = pde_ioctl(pde, file, cmd, arg);
-	pde_unpin(pde);
-	return rv;
-}
-
-#ifdef CONFIG_COMPAT
-static long pde_compat_ioctl(struct proc_dir_entry *pde, struct file *file, unsigned int cmd, unsigned long arg)
-{
-	const auto compat_ioctl = pde->proc_ops->proc_compat_ioctl;
-	if (compat_ioctl)
-		return compat_ioctl(file, cmd, arg);
 	return -ENOTTY;
 }
 
+#ifdef CONFIG_COMPAT
 static long proc_reg_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
-	long rv;
 
 	if (pde_has_proc_ioctl_buf(pde))
 		return pde_ioctl_buf(pde, file, cmd, compat_ptr(arg), arg);
-	if (!pde_pin(pde))
-		return -ENOTTY;
-	rv = pde_compat_ioctl(pde, file, cmd, arg);
-	pde_unpin(pde);
-	return rv;
+	return -ENOTTY;
 }
 #else
 #define proc_reg_compat_ioctl NULL
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index f21dd826eaa6..64242a9aa117 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -81,10 +81,6 @@ struct proc_ops {
 	loff_t	(*proc_lseek)(struct file *, loff_t, int);
 	int	(*proc_release)(struct inode *, struct file *);
 	__poll_t (*proc_poll)(struct file *, struct poll_table_struct *);
-	long	(*proc_ioctl)(struct file *, unsigned int, unsigned long);
-#ifdef CONFIG_COMPAT
-	long	(*proc_compat_ioctl)(struct file *, unsigned int, unsigned long);
-#endif
 	int	(*proc_mmap)(struct file *, struct vm_area_struct *);
 	unsigned long (*proc_get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
 	/*

-- 
2.53.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB1A8C61DC7
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:46:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8C526B00AF; Thu, 27 Aug 2026 05:46:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B631E6B00B0; Thu, 27 Aug 2026 05:46:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2C376B00B1; Thu, 27 Aug 2026 05:46:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 73F306B00AF
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:46:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB8AB12038E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:46:47 +0000 (UTC)
X-FDA: 85146570054.14.3D21CE3
Received: from mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0E3BA180006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:46:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787824006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FtWYKAW1/LOuneyjz4lv4+7F4jL6mdyulhCLMrJujWk=;
	b=ErCwGTLZCPIfdt8rzjqhteBziw73YC99QZ5+AqjWenp7UrXgSsbSCbk4mAOcGccjo5ytLp
	1BRn428JalJ9RRaGRNKnpCvsn/obsqAHV7vzWKTgMMBhqkk9d9wYZ87IdL0kWMtDHBVgdQ
	G7KqWx2ho9zAtWIp+l/cI2lChpf2rZA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787824006;
	b=DneZquJEJ5tntv3blNz8GMfv2cmRh6ElcbV3GHBId27QHm6e3i4KXn1j8nID6zCYlalGeI
	1gDDuVElN9IXBqOkf/bWeus8y8q+L47b7daUQX3uUAymDR4ZVrLSKLynNwC9xe/ttxFt4A
	3NHj393IyQ27jYR5nkFdNn/TmY/9rC8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 5f4f05cb0b049924;
	Thu, 27 Aug 2026 09:46:44 +0000
X-Mizu-Trace-ID: 5f4f05cb0b049924
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 14/16] mm, swap: refactor swapoff + add xswap_destroy
Date: Thu, 27 Aug 2026 17:45:04 +0800
Message-ID: <20260827094509.1016740-15-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0E3BA180006
X-Stat-Signature: 1d7upi7thpnytfuum1d43bb74j1cs4rc
X-HE-Tag: 1787824005-73904
X-HE-Meta: U2FsdGVkX1/Uc6xK68gZrTw1g/iv91bSfLPFCY5Sz3AFEyRmVtwgCy+aaVhGYqdgAAHm8lZ5lh4BPOePfot4g1f7CvTcf/SuAAumE9TKIaltPERJc3BLg5YHCpUc9/aSsWKypyxHen30P6QbParitY8k8lLmuHTmukjlCc2CAQphlb41BIafIuqfFa+9MHDr9z824hK5BLQiNvz910VrnVyP1o0ppfyBfolpoUa1S11SSjVFgUI7EnsihUjVFncZRa5xV8pTzlrFQ1iWyws+h+DUOCBTfoTYUnXPxpP7kAPK57+ir0Yl1SPg/NycOmqgjwqxYvNdHh6XDo+2UyNVMG0xX6WqoD43Ld/adJMufJRxSGdHTAKoNDmZ9ROOjm4Hl1mCYkcuDLxJfsZRyU+8uptpbE2UAXUwyHKJEEKk/mNPzJt3JhuH9FtfiIQljKR011NukQ/VnGXWSb33LY01uoHGi78edooLQzSCvjVYFC60gu0PTkwKnrA2fPLtp4ijxjqwImMKqaoklvZvx9fxIP8RaDk2aJ7OIuFQqDsvoTaHAFQk+bxwxY4w3oLvFWfZlvAeW8Lxt4EqkfEGgMnGANENQEhtiD6UshuLcxKd7Xz3GGRQ9RUXXGnEOPP5fm22GVq7C4g5pChQ7K/Kz9rbUkFAK2dVi/G+tobcgsIwtQKFPSc2OdUx2jCF7dQUlPhe09E+m4k9ob1SnKVvSdhg7/1mkBv9ULSSYgspkHGAVJ6iHFrMVdxnYk7Zlx/RGeK3i1SRUQUlUceyZteWQ1FDJMvrowUdI4vGjMxCtUlkiW+ZAndiRjXu8tiMhkCmAD4rL6JQsjUTOA9MjMtAGcdoy4RnxzTylEBsLgyWPxaU628Nt2QvH7mE+AExnB8k4dmfgUl273UivWsH4HZADh5MJRxHE24LraOeIo8zKnpMPWi7y4TYzRYMoEWjVuxOZgyVZ7DpcGZmearrbFZm0FR
 BVynS82/
 E4qDZg/YAFtChTjK0oZMVn5UkQr7DJofb9n5bpUg90kFV9ePg/T/pkQ4g149n585eWmQquWEdETeq7AA84wzvr7FOuAYYjk8umxHXZfCRIVTheTa1kXYB42BhQC96fhuuh8R6W7T8YE1J93hE88fDRutvsaWUm9R6e0jL4dj8chGSCOv0CZGkTiDoQOKIx+KfE5aQYUjtZS64oy4HvP0Kg7gCUsdq3scTcI2Hl2tEDRHyglLN4mCSrrCZnxqMd/9nef+NhFMIrWnYzxQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

1. Extract __swapoff() from sys_swapoff(): the core teardown logic
   now lives in __swapoff(), shared by sys_swapoff() and the new
   xswap_destroy().  swap_file operations are guarded with NULL check
   so __swapoff() works for file-less devices too.  sys_swapoff()
   retains file-matching; a NULL guard on p->swap_file ensures xswap
   devices are never matched by the file path.

2. Add xswap_destroy(int type): tears down a file-less xswap device
   by its swap type.  Validates SWP_XSWAP | SWP_WRITEOK, removes
   from lists, delegates to __swapoff().

3. Add /sys/kernel/mm/xswap/destroy: write a swap type to tear down
   that xswap device.  Requires CAP_SYS_ADMIN.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 197 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 136 insertions(+), 61 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index dc112c378489..451b46b747e3 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -160,6 +160,7 @@ static void xswap_debugfs_del(struct swap_info_struct *si)
 
 #ifdef CONFIG_SYSFS
 static int xswap_create(int percent);
+static int xswap_destroy(int type);
 /* /sys/kernel/mm/xswap/: create.
  * Per-device runtime size is tuned via debugfs type<N>_cluster_limit.
  */
@@ -192,8 +193,33 @@ static ssize_t xswap_create_store(struct kobject *kobj,
 static struct kobj_attribute xswap_create_attr = __ATTR(create, 0200, NULL,
 							xswap_create_store);
 
+static ssize_t xswap_destroy_store(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   const char *buf, size_t count)
+{
+	unsigned long type;
+	int err;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	err = kstrtoul(buf, 0, &type);
+	if (err)
+		return err;
+
+	err = xswap_destroy(type);
+	if (err)
+		return err;
+
+	return count;
+}
+
+static struct kobj_attribute xswap_destroy_attr = __ATTR(destroy, 0200, NULL,
+							 xswap_destroy_store);
+
 static struct attribute *xswap_attrs[] = {
 	&xswap_create_attr.attr,
+	&xswap_destroy_attr.attr,
 	NULL,
 };
 
@@ -3361,61 +3387,13 @@ static void flush_percpu_swap_cluster(struct swap_info_struct *si)
 }
 
 
-SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
+/* Common swap teardown after list removal; shared by sys_swapoff() and
+ * xswap_destroy().
+ */
+static int __swapoff(struct swap_info_struct *p)
 {
-	struct swap_info_struct *p = NULL;
-	struct file *swap_file, *victim;
-	struct address_space *mapping;
-	struct inode *inode;
-	int err, found = 0;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	BUG_ON(!current->mm);
-
-	CLASS(filename, pathname)(specialfile);
-	victim = file_open_name(pathname, O_RDWR|O_LARGEFILE, 0);
-	if (IS_ERR(victim))
-		return PTR_ERR(victim);
-
-	mapping = victim->f_mapping;
-	spin_lock(&swap_lock);
-	plist_for_each_entry(p, &swap_active_head, list) {
-		if (p->flags & SWP_WRITEOK) {
-			if (p->swap_file->f_mapping == mapping) {
-				found = 1;
-				break;
-			}
-		}
-	}
-	if (!found) {
-		err = -EINVAL;
-		spin_unlock(&swap_lock);
-		goto out_dput;
-	}
-
-	/* Refuse swapoff while the device is pinned for hibernation */
-	if (p->flags & SWP_HIBERNATION) {
-		err = -EBUSY;
-		spin_unlock(&swap_lock);
-		goto out_dput;
-	}
-
-	if (!security_vm_enough_memory_mm(current->mm, p->pages))
-		vm_unacct_memory(p->pages);
-	else {
-		err = -ENOMEM;
-		spin_unlock(&swap_lock);
-		goto out_dput;
-	}
-	spin_lock(&p->lock);
-	del_from_avail_list(p, true);
-	plist_del(&p->list, &swap_active_head);
-	atomic_long_sub(p->pages, &nr_swap_pages);
-	total_swap_pages -= p->pages;
-	spin_unlock(&p->lock);
-	spin_unlock(&swap_lock);
+	struct file *swap_file = NULL;
+	int err;
 
 	wait_for_allocation(p);
 
@@ -3426,7 +3404,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	if (err) {
 		/* re-insert swap space back into swap_list */
 		reinsert_swap_info(p);
-		goto out_dput;
+		return err;
 	}
 
 	/*
@@ -3469,12 +3447,14 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->max = 0;
 	p->cluster_info = NULL;
 
-	inode = mapping->host;
+	if (swap_file) {
+		struct inode *inode = swap_file->f_mapping->host;
 
-	inode_lock(inode);
-	inode->i_flags &= ~S_SWAPFILE;
-	inode_unlock(inode);
-	filp_close(swap_file, NULL);
+		inode_lock(inode);
+		inode->i_flags &= ~S_SWAPFILE;
+		inode_unlock(inode);
+		filp_close(swap_file, NULL);
+	}
 
 	/*
 	 * Clear the SWP_USED flag after all resources are freed so that swapon
@@ -3485,10 +3465,69 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->flags = 0;
 	spin_unlock(&swap_lock);
 
-	err = 0;
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
 
+	return 0;
+}
+
+SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
+{
+	struct swap_info_struct *p = NULL;
+	struct file *victim;
+	struct address_space *mapping;
+	int err, found = 0;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	BUG_ON(!current->mm);
+
+	CLASS(filename, pathname)(specialfile);
+	victim = file_open_name(pathname, O_RDWR|O_LARGEFILE, 0);
+	if (IS_ERR(victim))
+		return PTR_ERR(victim);
+
+	mapping = victim->f_mapping;
+	spin_lock(&swap_lock);
+	plist_for_each_entry(p, &swap_active_head, list) {
+		if (p->flags & SWP_WRITEOK) {
+			if (p->swap_file && p->swap_file->f_mapping == mapping) {
+				found = 1;
+				break;
+			}
+		}
+	}
+	if (!found) {
+		err = -EINVAL;
+		spin_unlock(&swap_lock);
+		goto out_dput;
+	}
+
+	/* Refuse swapoff while the device is pinned for hibernation */
+	if (p->flags & SWP_HIBERNATION) {
+		err = -EBUSY;
+		spin_unlock(&swap_lock);
+		goto out_dput;
+	}
+
+	if (!security_vm_enough_memory_mm(current->mm, p->pages))
+		vm_unacct_memory(p->pages);
+	else {
+		err = -ENOMEM;
+		spin_unlock(&swap_lock);
+		goto out_dput;
+	}
+	spin_lock(&p->lock);
+	del_from_avail_list(p, true);
+	plist_del(&p->list, &swap_active_head);
+	atomic_long_sub(p->pages, &nr_swap_pages);
+	total_swap_pages -= p->pages;
+	spin_unlock(&p->lock);
+	spin_unlock(&swap_lock);
+
+	err = __swapoff(p);
+
 out_dput:
 	filp_close(victim, NULL);
 	return err;
@@ -4373,6 +4412,42 @@ static int xswap_create(int percent)
 	spin_unlock(&swap_lock);
 	return error;
 }
+
+/* Tear down a file-less xswap device by its swap type. */
+static int xswap_destroy(int type)
+{
+	struct swap_info_struct *p;
+
+	p = swap_type_to_info(type);
+	if (!p)
+		return -EINVAL;
+
+	spin_lock(&swap_lock);
+	if (!(p->flags & SWP_WRITEOK) || !(p->flags & SWP_XSWAP)) {
+		spin_unlock(&swap_lock);
+		return -EINVAL;
+	}
+	/* Refuse swapoff while the device is pinned for hibernation */
+	if (p->flags & SWP_HIBERNATION) {
+		spin_unlock(&swap_lock);
+		return -EBUSY;
+	}
+	if (!security_vm_enough_memory_mm(current->mm, p->pages))
+		vm_unacct_memory(p->pages);
+	else {
+		spin_unlock(&swap_lock);
+		return -ENOMEM;
+	}
+	spin_lock(&p->lock);
+	del_from_avail_list(p, true);
+	plist_del(&p->list, &swap_active_head);
+	atomic_long_sub(p->pages, &nr_swap_pages);
+	total_swap_pages -= p->pages;
+	spin_unlock(&p->lock);
+	spin_unlock(&swap_lock);
+
+	return __swapoff(p);
+}
 #endif /* CONFIG_SYSFS */
 #endif /* CONFIG_XSWAP */
 
-- 
2.54.0



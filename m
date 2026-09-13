Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ECC1C88E40
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 07:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B29646B00A3; Sun, 13 Sep 2026 03:51:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADC106B00A4; Sun, 13 Sep 2026 03:51:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CB246B00A5; Sun, 13 Sep 2026 03:51:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 737156B00A3
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 03:51:15 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A88FFC0523
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:51:14 +0000 (UTC)
X-FDA: 85207968468.24.F97730D
Received: from mta0.migadu.com (out-136.mta0.migadu.com [91.218.175.136])
	by imf02.hostedemail.com (Postfix) with ESMTP id B3D3F80003
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:51:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.136 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789285872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GwTSeJwIM6x+Bs+na6VRTD5epZqml+8JjyWZHctjsZc=;
	b=u0tlui05gu9xVGy1twRFeCcsvmsrjsbQK35TZs/lndChLW9v4FnANZZgHrpFH8iLVMCM/T
	QTAkCkiLYfgL5YFHrEK/txReV84zZpWvrA9sFP/0L3SBLVa3SgSHLGlmanuxIn2AZw6evY
	JFzmfR/Yug+XVzgPmn1sq0fA7lZcTX0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789285872;
	b=bCwubtCTIMusXB9MtqVowordhg1j6l8aZ52Fwd4cRRffe7pfNsTjFquzJ2P1hJxEmImJn5
	hrzN7iJ5fFUE/Wi670n43GYa59KMiCQ8xV594nppc4OfxiFJaqGmwp7tkVfZuG7Fhb3b60
	TDIZJijOofn7PFTU7lAMMOtkdxh44cw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.136 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 694c106e48a1c688;
	Sun, 13 Sep 2026 07:51:09 +0000
X-Mizu-Trace-ID: 694c106e48a1c688
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
Subject: [PATCH v2 10/12] mm, swap: refactor swapoff + add xswap_destroy
Date: Sun, 13 Sep 2026 15:50:12 +0800
Message-ID: <20260913075014.1732524-11-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260913075014.1732524-1-hebaoquan@kylinos.cn>
References: <20260913075014.1732524-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bdwg15qn686a3y5arzsi5k9mwoym336i
X-Rspam-User: 
X-Rspamd-Queue-Id: B3D3F80003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789285872-848380
X-HE-Meta: U2FsdGVkX1+eKJlWNPQhWvOaOS/ir+ezeCM0Jck5QdBgUnO3RrNaRl5dmK0Ezzz92tOwysf6kAfkyn+BLFeg4tygFQAghCwaBjgP+27aWvhgo0qeyoBQklDRj4mbA8JPoK+1Ql33dEN9AwzejQeQRnA516rMDyy8aJh1AtZWyqTCqokztOElf8C9TYgTstA6Q0oApP7JQZBTw+1MxWkGztymiVbZ+6jpJjJIO+T8EH8cVlGLhmCyW+23mt1X2Ujt7iQRcabFK3Hs54uNbKrcVEmcgxaZacks8SV9XcGuo7lINqMb68AkSUn5M2IxUTSYI8bPCTcu9wA4f/5yKxKOXzfUW89tFIeA/Sx8dnjRrxfEy1QRqviHYt6uQ2a9WPTaZNn4/GmGVs6eGPUbB8t0BBzu6/3eLtIcspP5NEv0ocSPIWIKuYGALTO675K27ObTx1THhcPWstlU33DLU4hHu6AZvOs/ltJWc7HNKadWZeAZUxaSxNWYVEVb6YOnL7AB6MgYnP8ooRqz5EWTptz6yCBzpMnTk2osVOBYRlNo2zpofA2EVXvxvy02xAk106iMEkSn8G/s0o1L6jDkeJ5ixT316oN0FHeLMXewcaGS1yg+gYfZCewedsNlHpcnfPFckal4rpMCh+SLL+RaxVAia/7yrLYquPg43cUu5dwkhIdnQJDSQhkMO81oZrFVcMKXUS3cB5zJBz75hDUR/grFMttG6ERxwRqGQl/x7VKWKRc+fvkY8M7vA/gfmv4nP6X6egn5w+UatYiomxqXAZ8jH/Zm4R/CXu0jT5ww4rlLjnpTIi61ETLppeIdyNIkXapsaKt3QbcRzenIyDghu3RABFpGc8XLTQJQpnJp/vdOZYLhhtike9st1GaPwCh//1P8PNaBUofAV5ja7ZADp1fGYKnnQLJjv13lDdDTC/gJ/R9gmyxHQaapS/x4fSOOu4xFxE10QIZl2gHTkHTwI34
 Dl/84pfs
 LvT4J6OxLimMJeI3Enq7Gbkup3HyVNq6Rv2tZ8uf9t+IaIjB8s5dgocLF+2uE2c6SVaomn2ZmMjRC9gbtA2GUTrl+uGlaFP9vw3QbTelQiGPxSrJNyriCn58oqQmlNium+fFGe+QSLm2W5763veJMigWKqRtgRLI2TDO6UdE0Qw/T1EqHDUU69tMUf79CapGG9ZDbuceZP4uoifW6fl+OTOgnPsPZqIIJfvEc54yk0OI6R43DkL28vNTZroy7f4BerBsDkeFRLmBuetY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

1. Extract __swapoff() from sys_swapoff(): the core teardown logic
   now lives in __swapoff(), shared by sys_swapoff() and the new
   xswap_destroy(). swap_file operations are guarded with NULL check
   so __swapoff() works for file-less devices too. sys_swapoff()
   retains file-matching; a NULL guard on p->swap_file ensures xswap
   devices are never matched by the file path.
2. Add xswap_destroy(int type): tears down a file-less xswap device
   by its swap type. Validates SWP_XSWAP | SWP_WRITEOK, removes
   from lists, delegates to __swapoff().
3. Add /sys/kernel/mm/xswap/destroy: write a swap type to tear down
   that xswap device. Requires CAP_SYS_ADMIN. Out-of-range types
   are rejected before the implicit int truncation.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 199 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 138 insertions(+), 61 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index d2a3303b0572..0321b6b0da56 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -74,6 +74,7 @@ static void xswap_try_shrink(struct swap_info_struct *si);
 
 #ifdef CONFIG_SYSFS
 static int xswap_create(int prio);
+static int xswap_destroy(int type);
 
 static ssize_t xswap_create_store(struct kobject *kobj,
 				  struct kobj_attribute *attr,
@@ -104,8 +105,35 @@ static ssize_t xswap_create_store(struct kobject *kobj,
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
+	if (type >= MAX_SWAPFILES)
+		return -EINVAL;
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
 
@@ -3294,61 +3322,13 @@ static void flush_percpu_swap_cluster(struct swap_info_struct *si)
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
 
 #ifdef CONFIG_XSWAP
 	if (p->flags & SWP_XSWAP)
@@ -3364,7 +3344,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	if (err) {
 		/* re-insert swap space back into swap_list */
 		reinsert_swap_info(p);
-		goto out_dput;
+		return err;
 	}
 
 	/*
@@ -3407,12 +3387,14 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
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
@@ -3423,10 +3405,69 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
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
@@ -4322,6 +4363,42 @@ static int xswap_create(int prio)
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



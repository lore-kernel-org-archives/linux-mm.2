Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 911D1CA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:32:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B21486B00A9; Fri,  2 Oct 2026 20:32:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD1CA6B00AB; Fri,  2 Oct 2026 20:32:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E77D6B00AD; Fri,  2 Oct 2026 20:32:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 76B216B00A9
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:32:57 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1D1A01C34C3
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:32:57 +0000 (UTC)
X-FDA: 85279439994.09.8315279
Received: from mta0.migadu.com (out-128.mta0.migadu.com [91.218.175.128])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2099620003
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:32:54 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.128 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790987575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R9IzDvYNhynXTSVIkey3yx0lhYE63W7Gi7YRAHqiM3Y=;
	b=gvOzvF7dSS/OYmdtq75wXAtTG5YEfm51jkh/PsWSRSsk783TUeYa8PrvEoNeIkpxegsL0R
	sBWvydbwuPyGgtL4YkHv4OlUUiS49bSkTsRN615/zxykIgGKgZ0nMRMe519rKhca/LmyfE
	sCfmRLB4QXvE64i+Gn8BJnnI8gfNyUg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.128 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790987575;
	b=Y5uNDbavLMD36an8kX1FuI88qSu4t4lN9iivauyAnjPRxPMRZDjmyD1kbj29pD+qQHAlyw
	jpEM2Ecib9Gkx8sexN99JOmME4MBWgs6htDEqGZyqmxvt7xJZKLF4S7KbYKYKGg4kAqy+Q
	Snv3ki0EatStULp1/tbrUtTAXwo1t14=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 51c88b858efa4a63;
	Sat, 03 Oct 2026 00:32:53 +0000
X-Mizu-Trace-ID: 51c88b858efa4a63
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v4 09/14] mm, swap: refactor swapoff and add xswap_destroy
Date: Sat,  3 Oct 2026 08:31:31 +0800
Message-ID: <20261003003136.750633-10-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003003136.750633-1-hebaoquan@kylinos.cn>
References: <20261003003136.750633-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2099620003
X-Stat-Signature: 1qeiazkjf619cdinuj19fwt6eqwxtft4
X-HE-Tag: 1790987574-85803
X-HE-Meta: U2FsdGVkX1+o3DiixCBf8mRDelDTFkIXnELeDiuZsQNdBjV/IgIpaG41W6MGlLo2FyGWTsOAdEEWYpUim4Wf3g5oxYkSxSx/PcgAHt1djml/VApVSpNOV3JBpI9GqZpM7QYj+DYlVuwejj0AmLOeNrPVYZAYlY0JipBzcoMefO1jQLdnUHwOAuD8LAu6c0fupVMjliu2jrY2TSN+wsa115gBLutDr3suF42MaMxEdYm7vgemyTKQ2exK8+Qt7Tyy11kxYXv/nFepTy4rdxQ8Dc22khz3/fn1XpM+Rh7YRdfXe/pJZ999DwMhnGboYEmbGkBfeZRX1LHH0nyLNXd6mHHbo307Dln6LRQfQCR5mrelPif8CV3NOdi5y7wPlcjy7k2gppjZnO8CGcCDNsM8nMfl9m0OxKOJ//bO81vM4329R0qJn6rgijNgidzCAUxFW9/FBgd93yYuk7hW3Gz+H4D4T/muKn/WgamegFTD1ovPuy8sZ3Rp1u/XxN30i+WzfJhq2RdKJIKIgncoEJT51p6W1IICAU0h6JeXIeVQg4exff+B0xpeCKfyxhRovw+NaYMm+JB3PwK5Eij+JqwewS+UkIEHGloJ7zayqMlzo09iNsbweXZbTwseRr7m6WmqmgshTNbwcCgOZidp+Kqeb1CIQs7+GJbAw/9UHyqsnRj0XC88LFzRt+rMLQYUbvE8o/6i7iWCrWazm4tbMi/BM2fjD7jvOYsXKDu9SrSFWVc06sbdTJdkAcfzErEGggYASR+YFR5o2rkvxhsgnSgq28ZTucI5aq7X9jTEMoAW7kspW5J0VBgVMlu57ix5gxiswG9q/qOJjjfB9/l0sHsL/yWFqmVXIO3E/mQrkvmornS+inXZ9Ol+mUM7IacDLUai4hdXsM5kthedZD0si10GPfpD5v79N/CFXFi1nbLODu+NWpHnNj9wcqLxgy32xznZ7qQ+0DOAcUNWCtl017O
 Any6y+XG
 Kj5U1YVCATCxwzLz1BnhMqiRcm9TIXUC9Ixtf8ERBbIny9yUpLXN4MFUCWp91YByq69PB3WkiaZHDhWl/s/RTauW8ciN7zjsxNUYVgtqNFgLx2PKQm/I8CCsg5gvFq/e/zmEApAv6dCzltR6azTRYTza8RCvORwtzbLy/yYT6lUdjamspyex6/V6T2wpvt3qoW2diidhjZ/yjAbgxU7cPUkFfNko2ukXtWbFAqwJggqnf0VJMqJua86/LhqFfQyjAxHrMSE75T+qSrE+Z8rKe13IdvYQ8N2mtSEzcITwq7mPoITKhkH+m/kah9aPGRRqL4acR/J3BqISnSZqNCs4BxFW+Wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract __swapoff() from sys_swapoff() so the teardown logic can be
shared, and make it work for file-less devices.

Add xswap_destroy() to tear down a file-less xswap device by swap type,
exposed via /sys/kernel/mm/xswap/destroy. Writing a swap type tears down
that device; it requires CAP_SYS_ADMIN.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 133 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 114 insertions(+), 19 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 49703731ffd5..0c8b716ec5ba 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -100,6 +100,7 @@ static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data);
 static void xswap_try_shrink(struct swap_info_struct *si);
 
 static int xswap_create(int prio);
+static int xswap_destroy(int type);
 
 static ssize_t xswap_create_store(struct kobject *kobj,
 				  struct kobj_attribute *attr,
@@ -128,8 +129,35 @@ static ssize_t xswap_create_store(struct kobject *kobj,
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
 
@@ -3398,13 +3426,14 @@ static void flush_percpu_swap_cluster(struct swap_info_struct *si)
 	}
 }
 
+static int swap_info_remove(struct swap_info_struct *p);
+static int __swapoff(struct swap_info_struct *p);
 
 SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
 	struct swap_info_struct *p = NULL;
-	struct file *swap_file, *victim;
+	struct file *victim;
 	struct address_space *mapping;
-	struct inode *inode;
 	int err, found = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -3421,7 +3450,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	spin_lock(&swap_lock);
 	plist_for_each_entry(p, &swap_active_head, list) {
 		if (p->flags & SWP_WRITEOK) {
-			if (p->swap_file->f_mapping == mapping) {
+			if (p->swap_file && p->swap_file->f_mapping == mapping) {
 				found = 1;
 				break;
 			}
@@ -3440,24 +3469,58 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 		goto out_dput;
 	}
 
-	if (!security_vm_enough_memory_mm(current->mm, p->pages))
-		vm_unacct_memory(p->pages);
-	else {
-		err = -ENOMEM;
+	err = swap_info_remove(p);
+	if (err) {
 		spin_unlock(&swap_lock);
 		goto out_dput;
 	}
+	spin_unlock(&swap_lock);
+
+	err = __swapoff(p);
+
+out_dput:
+	filp_close(victim, NULL);
+	return err;
+}
+
+/*
+ * Drop @p from the avail and active lists and undo its accounting.  The
+ * caller must hold swap_lock and have checked that @p is WRITEOK and not
+ * pinned for hibernation.
+ *
+ * Returns 0, or -ENOMEM with swap_lock still held.
+ */
+static int swap_info_remove(struct swap_info_struct *p)
+{
+	if (!security_vm_enough_memory_mm(current->mm, p->pages))
+		vm_unacct_memory(p->pages);
+	else
+		return -ENOMEM;
+
 	spin_lock(&p->lock);
 	del_from_avail_list(p, true);
 	plist_del(&p->list, &swap_active_head);
 	atomic_long_sub(p->pages, &nr_swap_pages);
 	total_swap_pages -= p->pages;
 	spin_unlock(&p->lock);
-	spin_unlock(&swap_lock);
+	return 0;
+}
+
+/* Common swap teardown after list removal; shared by sys_swapoff() and
+ * xswap_destroy().
+ */
+static int __swapoff(struct swap_info_struct *p)
+{
+	struct file *swap_file = NULL;
+	int err;
 
 #ifdef CONFIG_XSWAP
-	if (p->flags & SWP_XSWAP)
+	if (p->flags & SWP_XSWAP) {
 		cancel_work_sync(&p->xswap_shrink_work);
+		/* Wait out a shrink racing us from the sysfs write path. */
+		mutex_lock(&p->xswap_lock);
+		mutex_unlock(&p->xswap_lock);
+	}
 #endif
 
 	wait_for_allocation(p);
@@ -3469,7 +3532,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	if (err) {
 		/* re-insert swap space back into swap_list */
 		reinsert_swap_info(p);
-		goto out_dput;
+		return err;
 	}
 
 	/*
@@ -3509,15 +3572,21 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
 	free_swap_cluster_info(p);
+	/*
+	 * The device is off swap_active_head and no longer WRITEOK, so no
+	 * reader can observe these; clearing them here needs no lock.
+	 */
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
@@ -3528,13 +3597,10 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->flags = 0;
 	spin_unlock(&swap_lock);
 
-	err = 0;
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
 
-out_dput:
-	filp_close(victim, NULL);
-	return err;
+	return 0;
 }
 
 #ifdef CONFIG_PROC_FS
@@ -4501,6 +4567,35 @@ static int xswap_create(int prio)
 	spin_unlock(&swap_lock);
 	return error;
 }
+
+/* Tear down a file-less xswap device by its swap type. */
+static int xswap_destroy(int type)
+{
+	struct swap_info_struct *p;
+	int err;
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
+
+	err = swap_info_remove(p);
+	spin_unlock(&swap_lock);
+	if (err)
+		return err;
+
+	return __swapoff(p);
+}
 #endif /* CONFIG_XSWAP */
 
 SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
-- 
2.54.0



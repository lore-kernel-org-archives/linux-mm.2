Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBE66C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 10:21:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFF836B00A2; Wed, 16 Sep 2026 06:21:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB09D6B00A3; Wed, 16 Sep 2026 06:21:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC7456B00A4; Wed, 16 Sep 2026 06:21:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BFE66B00A2
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:21:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 34AB51604BB
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:21:08 +0000 (UTC)
X-FDA: 85219232616.22.0F3AB78
Received: from mta0.migadu.com (out-67.mta0.migadu.com [91.218.175.67])
	by imf04.hostedemail.com (Postfix) with ESMTP id 41DEB40003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:21:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.67 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789554066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=exQnmu+siJi9uiqAIwgKI8l6Xr6oWUa7Y1zp4oobdy0=;
	b=J19I/v/7vVeIEMMPk/ZASgQZuxP/WOdM7Tq7HxFOD7uSEWYN/DBsIavV2pr9oa82w3gs8N
	HVLp8BqeiC/GDzK6e6gKz6CUIqCbyOiKtPOwG0BeqjWFlMNBxCYtafsM20R3+hJDYtq7JK
	xG/YPYLrPfnYsPssG5UF/jMDNVaJsWk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.67 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789554066;
	b=AL8K2yq6Bdbwpd2NiL8P5AFw1rOBdN8xkOyUCqGbUht/IEySLytWskX5vf20qaqWfOaYvF
	qxQJK/VS2HIjtKwXcwWYJL/wqV7/nUz/g+J6x/cn+8f2L3OGk+xauuYzuz5U4xkQYtMBpW
	Du0xwGs4Xnuu0vv6pI/h2WLyTJn5Cqk=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 42f42ab4e84ad3fd;
	Wed, 16 Sep 2026 10:21:05 +0000
X-Mizu-Trace-ID: 42f42ab4e84ad3fd
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
	kunwu.chan@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v3 10/14] mm, swap: refactor swapoff and add xswap_destroy
Date: Wed, 16 Sep 2026 18:19:17 +0800
Message-ID: <20260916101929.149106-11-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260916101929.149106-1-hebaoquan@kylinos.cn>
References: <20260916101929.149106-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: im6wphgt8a6i9fsgqthjhtohzyaoscee
X-Rspamd-Queue-Id: 41DEB40003
X-Rspamd-Server: rspam07
X-HE-Tag: 1789554066-796493
X-HE-Meta: U2FsdGVkX19eRBtByUoepsadsPOhNxThma+GUrJJJzQEddP2Wi/l3SzdX+kbv6UsifWPXkkJY74L9WPgJVISdN9ImqQeIKjV979MCJnNosq/Jab5AzS5iUkdVp8lYrPXLH+SwokSXm/CY2wx6jOXwOCXwbv5EaK4rRSq5m4qwvlAWKUpak4iAff7EyjLbQfEyQqXAvufphZkazLOjd+x3pbPbL/vTLjT+SA0WZ/AyWOc8I24whWGCzDVLf2Kfsv76nFF9KVHJ53acIOYxf0lAt8uMpuLZWKpc+KzMhRbVIrQr2iEoSdf02eRPvr2Chjrdg0Oa8FfuEv+B2n5indA1A9HK2tdoZSPenryRHYlud+58bPDgD7+qURFHGj54z+VaHuvXMk0BukEkw7LADF2xd9WYb/0DBozf6fxvDDuFVXLKnlc8nInfCv7P/EChALQjdJ7L8+RFS1yR4S+0JbY9WjLzXK3Bz8Wig/NPrn1I25Ojx92S7vN6XNdozgBgpqBUIatE1SWeG7Ukk7tHNCvD4sDyzRrUW8R5jjXNLOh/C2FNAhtEFA5HgHMOoE5Ip30OC2CXYgtwQ585CkDzgR2lpNoZIKJGMxHUhTn/JaIHxvlvuwVeztGxqXlaLXmD5AQ6XmF4G1FHkHMvCIE8Rc6wmSUb8dUSAkt+A8tiot840Yu0/6XMfTcj40k4MkaJ/fTo2FiTTz4eSu+9qBV7YhLFfqbhu2yDYSs9+MqlLjO1qaHJLjN2vCx6zu243ZEIsUh+wU/aukU9SP5zNNKKcZx/XFXzyX4Go5HexuzBaUxzB1OEflRkyHmzZFcT5HMrMrAuAHyvCCMBPovhB0XOJq5VPVwcVzYMqWsz9tLtdNUCKsUco2hn3M8dB+NO9++xHjAIRP2ON7d+SXgvOdTwSPa4T5DfmgtDDLmLkWLoS7QRxX2/y3MyEZzqf5XSz58jCCmbVZHr793tlKeizNiIG1
 G7Ow2vje
 8t6v/IgGQw4+gI3sFPzvLTvewM4i+D0yyFsBy7Lnv3YPBBcNb9e7CVwkJ+C/Ig1cYxZhFz6OSxLlGj4LA+gjhwe48SGwVOPUqO9QhGgpiWwcYXsRMhHOKokmFxR/T1Cu+HBb7oZDORQ09/+mhGsTC4tiG08lIWuxEBVdASqjZxa3BPyKbdltPf5k0ZnTD0RQgxnAdTx/ntRZlnTGOtsfq4YTmgIPCt1CfvzZjLFB9GgcBamS6fnocvL0V5zQ9hW2navV+/VK2fjcqtDd7PF0Rwzik5ZswdRyU3K/JJPPyE41oFrHcx8u500pFVwcISaDP6BjZBYyo0v25co5P/N7Ya955Og==
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
 mm/swapfile.c | 205 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 151 insertions(+), 54 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 351c68bcd70b..cdcbcbaa6d87 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -73,6 +73,7 @@ static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data);
 static void xswap_try_shrink(struct swap_info_struct *si);
 
 static int xswap_create(int prio);
+static int xswap_destroy(int type);
 
 static ssize_t xswap_create_store(struct kobject *kobj,
 				  struct kobj_attribute *attr,
@@ -103,8 +104,35 @@ static ssize_t xswap_create_store(struct kobject *kobj,
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
 
@@ -3399,65 +3427,44 @@ static void flush_percpu_swap_cluster(struct swap_info_struct *si)
 }
 
 
-SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
+/*
+ * Drop @p from the avail and active lists and undo its accounting.  The
+ * caller must hold swap_lock and have checked that @p is WRITEOK and not
+ * pinned for hibernation.
+ *
+ * Returns 0, or -ENOMEM with swap_lock still held.
+ */
+static int swap_info_remove(struct swap_info_struct *p)
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
 	if (!security_vm_enough_memory_mm(current->mm, p->pages))
 		vm_unacct_memory(p->pages);
-	else {
-		err = -ENOMEM;
-		spin_unlock(&swap_lock);
-		goto out_dput;
-	}
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
@@ -3469,7 +3476,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	if (err) {
 		/* re-insert swap space back into swap_list */
 		reinsert_swap_info(p);
-		goto out_dput;
+		return err;
 	}
 
 	/*
@@ -3509,15 +3516,21 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
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
@@ -3528,10 +3541,61 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
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
+	err = swap_info_remove(p);
+	if (err) {
+		spin_unlock(&swap_lock);
+		goto out_dput;
+	}
+	spin_unlock(&swap_lock);
+
+	err = __swapoff(p);
+
 out_dput:
 	filp_close(victim, NULL);
 	return err;
@@ -4128,6 +4192,10 @@ static void xswap_try_shrink(struct swap_info_struct *si)
 
 	mutex_lock(&si->xswap_lock);
 
+	/* A swapoff raced us and is about to walk this mapping. */
+	if (!(READ_ONCE(si->flags) & SWP_WRITEOK))
+		goto out_unlock;
+
 	nr_mapped = READ_ONCE(si->nr_clusters_mapped);
 	if (nr_mapped <= 1)	/* keep cluster 0 */
 		goto out_unlock;
@@ -4435,6 +4503,35 @@ static int xswap_create(int prio)
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



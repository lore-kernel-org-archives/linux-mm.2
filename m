Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C755C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 918BB6B028C; Thu, 13 Aug 2026 06:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F0346B028D; Thu, 13 Aug 2026 06:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 791116B028F; Thu, 13 Aug 2026 06:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 568056B028C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:50:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D52041405D9
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:50:57 +0000 (UTC)
X-FDA: 85095928554.11.13357DB
Received: from mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id EBF7340005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:50:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786618256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UhIJ2PXwPZq0AI4KIfnXwqoDuqcKwpms0bPEDmb+A4k=;
	b=n792DL3KMvK0HmYAhcn1nbEppyEcOuHXTxQCYCicymY2tVh8Tt3QE12HfW7SQaYgHDnNzo
	eEnoapX6P9jynKSunltho3U3VMc4BsQyATtnqUEOapANkp1fWhvhaZfiNo/9B3LCQr+g4o
	thyYZncwzuaFMotucINabqLBttYXhCE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786618256;
	b=vhGUkltFHVoCFZ6kct36rG877AQZ4nrP7f+Pktm8IfV+aptrUG4eTwMaXnu5O7ZL+H7jCf
	qVjnX8citdyQnfdN5AQokbMT1ZY5NnJnmt/AOtWSMRPNPI3mV4jjeO4zLwS9MP8ZVJe0uT
	B71z8+uQwnLQv2CQyC89E9T3qHJbPDs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta11.migadu.com with ESMTPS id 85425f115f72994d;
	Thu, 13 Aug 2026 10:50:54 +0000
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: chrisl@kernel.org,
	nphamcs@gmail.com,
	kasong@tencent.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC v3 14/15] mm, swap: refactor swapoff + add xswap_destroy
Date: Thu, 13 Aug 2026 18:48:53 +0800
Message-ID: <20260813104857.3450386-15-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
References: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: mt4q6hcirwc11acq3e1bn47hhoqiem7r
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EBF7340005
X-HE-Tag: 1786618255-410132
X-HE-Meta: U2FsdGVkX19DsbOttGU9PQOKns7l9gZ0b8NzV32MYw4FerCVJzpE6+WVktvjE2owdN1GNmAERIMU5IXvLQqv55jpIagmENmbSiTz+fXqnb4bsBb0FOM5tk9sb5mydI8fQ6LeA8Wr1pLnawyf/hMztSZ1rCw2NwAGp0neZOaDhHuFWM+QH3J2QZbU5N5FDwQgR7XifUij8GYg3qQ83zYF218+XTTIsgV0NATMlbr7oePmjCH32eL2TyD/n86KQxBZT8d55+3P51b4Z+cPUya7NMjJQE59/WasZwG6vLzXWxpjc00gAFSt5K9Jau9YRW+sr9UZsfx+2DLVE1z+Kz42w812Y4rMiEPpXalfItsep8dvoZGJWf5hgSONx+QcwVUNva3DotNxmnM0wphODZF6tC+Yp5NeEMCTfSgjJ48ZtrL7VK2Y0jF/vKBTRacH7h7OEzr4PPEDmcaEW+pdrjc1mJaMHQuGqB2Yk9aJLYBFfvNJcWg6TIu0ggXt6MT9jjSJ2JKfOgzJ5NASPeGySwKYIMATLkhNAKLDqhfEIlJIa8pZmBYwn/U1qux3nfkgggv+mKRg62zXtTM/0zi412WFISzU/RB02i7tBkI9IVD47bRJm++PJDh0BzvI8mmXOx/zIO8Yq4+30KfeplanTmu0xTcMYAPLcad1hKTl/lAiYhHXz6fYB7q1o38JBhmJeC68SKXgyeaZXUhRhtAuhrHGFjQmyjDRnhwd5zldVnjtfcw65m/qRmVq5UG9Dix2H2hhnHq7ssio7+tpp8x25cfEtdTceARMa+PqHxFDkYUnHdA0szFSTIxW1G0WOT+j6GxAQ2ZgGJLbTLC+o01SxoE2GynYWdpUku46awO7K3g8gVIkP2J+w9Et4J8AZ13oFYJ9wZcxasqdxbQV5EKqebVKlqTGyI93kt0QOEubkjmBNnEZhQ6k0vPYTETXGXSdpx5ufcHEmsb0rR7QyPUi6/W
 K6JF/C97
 wZvfmz5k6Z0s9H+1NYHXsiD7QLlACWEfEYd4NnYy3zMvIiPo0xMuWCAER1CRWHIFCNMS8g6RJxaS+wk96l3AvLHPNagaAVcfIADOlt+nxBdngXZv4+pRSgPe4lp4LjISZuNYEilQhpeKI9Q8VkrREuWurBdcWu/poheMvkDVa2ZRYs5IcAYBXmt/GIZogyYNNWWwaYs8NzplhG0ciPIyv7sFAOdYDR8u3bxDXvd+dqpYGnmfmT4WlprEYuOQr3O0BnxIWdLLclp04MTNkuKzmDfs+F6EOP88ZpVPLjh1nJx293HdgxhYF3pf4iaS7lQlaYySk1Epi6AcSiqQMkhPzSPR+tYJ7R3ckswpCHocktatspmRbdNyoODi4rJf/X1pUes5BTzVdHnYW4LqG5fDg6RUFicp4CUh1ldQA
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
index aa83a76773fe..61c307b6a432 100644
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
 
@@ -3354,61 +3380,13 @@ static void flush_percpu_swap_cluster(struct swap_info_struct *si)
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
 
@@ -3419,7 +3397,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	if (err) {
 		/* re-insert swap space back into swap_list */
 		reinsert_swap_info(p);
-		goto out_dput;
+		return err;
 	}
 
 	/*
@@ -3462,12 +3440,14 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
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
@@ -3478,10 +3458,69 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
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
@@ -4364,6 +4403,42 @@ static int xswap_create(int percent)
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



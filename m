Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1194606A32A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 05:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZhFUqX8g
Received: by kanga.kvack.org (Postfix)
	id C6AFE6B05C6; Mon,  9 Nov 2026 00:56:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C42606B05C7; Mon,  9 Nov 2026 00:56:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B30AF6B05C8; Mon,  9 Nov 2026 00:56:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8DB296B05C6
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:56:30 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2CCFD1A05F4
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:56:30 +0000 (UTC)
X-FDA: 85414520940.13.D4FC7AA
Received: from mta1.migadu.com (out-194.mta1.migadu.com [95.215.58.194])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3594E180002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:56:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZhFUqX8g;
	spf=pass (imf24.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.194 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794203788;
	b=U5kESPg8xZrggXI8qswhxEV+yEuYpcApcua7PL3jCA6df48R5QIbLn5rhCVnt6oc3QOxMV
	iGH97fWWVnMi8ha6YDcRyNmaz19CYMI39Gv8ZST8JY9SvgkbTF4xZUU7LBuuC+des9+M/Z
	ExHbQAiZbupczI2v14+dNmVZ3x6cmfY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZhFUqX8g;
	spf=pass (imf24.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.194 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794203788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cBPK2bWCIiA35KexCp977hu0u4JhPWx94qijTZF4Drw=;
	b=JlWsQ2tHy3VAGoQ7ZjsiMizTQ0uY51TMpkowW9LGXiExasGED8RnS54Y5HMWMAec0OdTtn
	LOtlT0X5GmwBgy/G2SRU/E7CTIur2y3suVTnlZ2TyVqq0/7Ys5Isxy7JajkIOpy/+2lZ88
	iAL4m8ukEtELYqt1bpHNdCYKCbwM9hg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Cu449HxZRkFE3StVJpRmbTVf00lAahvBFPbJvlhsIco=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794203786; v=1; x=1794808586;
 b=ZhFUqX8gDGNnjSGf9QfBSNSoC+er7GXV9CFbaedAQGqn9Kju/YGVV26KlW5tTHOUCiRpZfq9
 LzdjQyZwtWuMaBUE6BcPN+CpTneGR6eAjlcI6Lw0Z5pNTjD4/6kPvDalNSnZ1Lyh9/VTLI7/9nT
 c6IOavo4Bx4cMfP01gevXW6o=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 11e07ec0317c68cf;
	Mon, 09 Nov 2026 05:56:26 +0000
X-Mizu-Trace-ID: 11e07ec0317c68cf
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	corbet@lwn.net,
	hannes@cmpxchg.org,
	chengming.zhou@linux.dev,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v5 07/19] mm, swap: refactor swapoff and add xswap_destroy
Date: Mon,  9 Nov 2026 13:54:43 +0800
Message-ID: <20261109055455.536925-8-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109055455.536925-1-baoquan.he@linux.dev>
References: <20261109055455.536925-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: exrbmnedmz4ooyesmso9txhmnjxbyy1a
X-Rspamd-Queue-Id: 3594E180002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794203787-66370
X-HE-Meta: U2FsdGVkX1/Sm3jNOdk+UM7jP6aaA2KcLuG+NanuYcf8nFqhL9CbpfjFSxj0/lzAHqzSYmhUgLwZHhTwCLiqElvrYfTxXXTZsniyWRex0ODPY0/BfAdX/00ULPKbIM3FuwsUXMhBeW0iO8spVMDQeTTrXDO9eTjju+9aK1RQOcOrFY47IV+fTBdhB9GHEeBXhfAZgx9yqHGHENZLOKvZjgOnLENb3PqxL5zVXsD/ihlOF60Sy/qW6vzDWs3Z5Eb8OJdl7WH8iS4tSf8Tay70DI7mvHjO66h7m9ye2jYKo8bIZQS8gYPaqjWCoSHIYr5kTS5Ih1irF7xnXtz7IVrPmwf8ycclWg9AuVohJjau4Xrzn02D2jCoII7Grp7qQI1L6BfIKsG9TYQpDgOGg+HPTp7/R4QYXN8TCNYFrlHOoNuwqEl69SrNWf9bLi0NlKePBtELcoGmtI7TMOnzy53Frnj8oGh4iN8jtr6GWfti/i7kAi12qJ36w1p4hasdSDs3qsQXyRtedP7afL6h5uKJSuEQbF7xANchvnXxhr64nMAMfvxKNdZVcADypUX5utuCj3uld7UuBUrxgSkqfjT+Nbk6P70RaonVk43fSituDg4ISrgs9RdaWs2C0JNF768llow77r1OlVRLdMrDQiYyY6vsBLGNCvbJd44x543XcbTduf5pImYJyxiWA8Vm61U3x6vwwS080dIir3lNO++oq8Yp9XeAV90vB3PJ9HMbHwM2jsu6w/nl+2+85uwJVQALQN6qrb+oBrxVUyUdQuvyY4zRZNMNojqwRpD+bK5UcBOJ1Zc7NjCwGKpH3T5fC/Q53ulfAD5G0iv6inq3Oy64uVQA9AMkD+aFSWSCTieZ92JYgNOd4dCkbTTCejHkAjzTopAsj2V/1xMp4hJDZ0ooYXbECJUhwOpjyHkmHeSXqUrxktLhPvl/AExOUkzya2LHrMcvGwQVL7ZgPQR52+8
 bHUs77dG
 nFV/rCVzNF5anqIYD6I3LGCV8OZwSlpuKr8wn7uu7T5MaDpZ4/noPGpVegGsNHtXkA4A/fvjM/fSoE+zLvrmfIpFFO68L/l0Lg4ffV9K0geuclbXu5fmPxQIytg34ePH4OUoOPWG72DVuvHQV0p6Af/Do+K1PIJE/ACewDXPSRPlxQmMMg5UIr5YdcTLiTOlmWyNCEVzngVDosA8/NCSrCrSImVkIF8XIhMWJJRgpMBEfWuQJE9qn+ydEY/8BJ7S3n0QbWtIxg7aMBGu8bicO7BpSJtgGjCVFDt1rl3XgiW86lQ6YgfjyfVndstBSoEXN/AnC9sIcAeqRLFRFH8awlhbpI6g/DRuGvVg0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

Extract __swapoff() from sys_swapoff() so the teardown logic can be
shared, and make it work for file-less devices.

Add xswap_destroy() to tear down a file-less xswap device by swap type,
exposed via /sys/kernel/mm/xswap/destroy. Writing a swap type tears down
that device; it requires CAP_SYS_ADMIN.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 127 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 109 insertions(+), 18 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 616adbb298e7..3f2b863f7dd7 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -86,6 +86,7 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data);
 
 static int xswap_create(int prio);
+static int xswap_destroy(int type);
 
 static ssize_t xswap_create_store(struct kobject *kobj,
 				  struct kobj_attribute *attr,
@@ -116,8 +117,35 @@ static ssize_t xswap_create_store(struct kobject *kobj,
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
 
@@ -3365,13 +3393,14 @@ static void flush_percpu_swap_cluster(struct swap_info_struct *si)
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
@@ -3388,7 +3417,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	spin_lock(&swap_lock);
 	plist_for_each_entry(p, &swap_active_head, list) {
 		if (p->flags & SWP_WRITEOK) {
-			if (p->swap_file->f_mapping == mapping) {
+			if (p->swap_file && p->swap_file->f_mapping == mapping) {
 				found = 1;
 				break;
 			}
@@ -3407,20 +3436,50 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
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
 
 	wait_for_allocation(p);
 
@@ -3431,7 +3490,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	if (err) {
 		/* re-insert swap space back into swap_list */
 		reinsert_swap_info(p);
-		goto out_dput;
+		return err;
 	}
 
 	/*
@@ -3471,15 +3530,21 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
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
@@ -3490,13 +3555,10 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
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
@@ -4269,6 +4331,35 @@ static int xswap_create(int prio)
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



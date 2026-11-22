Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70DB9606A33C
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 12:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iomTLabZ
Received: by kanga.kvack.org (Postfix)
	id 8DFA06B05BA; Sun, 22 Nov 2026 07:40:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B6A16B05BB; Sun, 22 Nov 2026 07:40:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F4946B05BC; Sun, 22 Nov 2026 07:40:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 589036B05BA
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:40:46 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A810780677
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:40:45 +0000 (UTC)
X-FDA: 85462714050.01.2A81E26
Received: from mta0.migadu.com (out-39.mta0.migadu.com [91.218.175.39])
	by imf14.hostedemail.com (Postfix) with ESMTP id AC366100005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:40:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iomTLabZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.39 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795351244;
	b=UDnUGv2l9slNLNSs/uxJyfWKRS0kLQS4Wla+E1zabyK1XmukuJ7D2YNFYKzvudp6pdt+gN
	Fm9idIQzTVRhqtvrCBuUDgjOqk7vOpvo8FvER0n7GoYjnmw/UiOmED6v/n8IUYVVwHmO5z
	RouQXqMC1jUj47/vE+DSmjkDKsWSMB4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795351244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cdSgugpkftqzOIkaqIninFyN6NpM7RgXI07YueRjrWI=;
	b=1P3MgHW2C+dHRSCPkXF+3oiCB9h0NKad4/hJ/Ombk6z3RSFo3v03Lz2kkG0SpwocZHWRiO
	3nH7pfDK0ZVR+dFRMb0JFgaemuPm0ZBZ33qm8mgYIbLofm4TKTprMFhG82a/B5hXTJ/tXO
	v3U1AuLE6orti4OFCimiC9qKOPmKAIY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iomTLabZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.39 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6klAZhcqi6Lxv1H5Iuh6bSjCwyF2IL6jR8nNZYpIyqE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795351240; v=1; x=1795956040;
 b=iomTLabZZapAWzU75pBmi+W2o+dH0/elisBPWDbacVp5LVZhs28NAI6bPKI1dyLtlTIdIh9c
 FHWXtpCQfip5mUjf0OKaiO6t2EUE08TzhaB4hdnA0wqpMq149VVqYXI2R9Ea1uoDwvQ68c8yHyd
 DSiDWVN5I4++xNQ3o1ZOIRVU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 5f704cb376f548c0;
	Sun, 22 Nov 2026 12:40:32 +0000
X-Mizu-Trace-ID: 5f704cb376f548c0
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	urezki@gmail.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huaweicloud.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	chengming.zhou@linux.dev,
	corbet@lwn.net,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	linux-kernel@vger.kernel.org,
	baoquan.he@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v6 07/14] mm, swap: refactor swapoff and add xswap_destroy
Date: Sun, 22 Nov 2026 20:39:11 +0800
Message-ID: <20261122123918.3486916-8-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261122123918.3486916-1-baoquan.he@linux.dev>
References: <20261122123918.3486916-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AC366100005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: rgedgh8nmajpcengpn6rm18qhd4qzrcj
X-HE-Tag: 1795351243-199009
X-HE-Meta: U2FsdGVkX1+5IEH2JbnqcnGwcm0kmq5YnXPdGMO9l18hu5PRuhrGhy/ju2A8jt3uKKJplJzAxQGJhSHXTUvY34JK5Yhkl7Ymr6+ooCj/jNAENAMXBJ7Uyu5ib+ZCNckVMuelV/Fib4ghZ0gVx0MvO3k0bOXy2bLY0+G2ALpwzEWU80gGz81VtYK/3UUx3fwYcD6/iQI5pkMa5gKPYZYfBu/m3NOIuTklNXXp/tVw6vh33N1MEg/5gO1K2KirfvqArjYFXIWps8SsrDVr37WYvNXiNzkmnW3XdkJfxQYVjQWBaX2Ma/wA/FBsbAG2gHU++vd5jiE2Pt3uCAhgxsE17/jFYOFEF2lOvLTegcLatI02qdLsUjNuUtNqqVP0Tf5z+IgTYArNAJFqq+AYgAMeCFDDL7yJo4SKebsEjTHmPcQqpt6zco6Lq8ZTP3x/oSFN78afzbqXL4Va7msip7R9xFTERJHeMDcLPcP3wAKlt2bNi+7kRNMBUdNsEol/PbaUx+kvv3mMRHTc+NhIoECEO/7UJ11EYxmSnyQDUHV3ja/unOWLQRFz/DVnSUJ53wQMWKctuix3GbCB42Kgl7mcBou+8F65Pq/HbD+GMcZ9WP3brfBFXFbzMq9Znkakw4p02xdWr5WJzxyTQYOv6ZHQdNrGGlfjU6W7RkswbDFfKhNLePVSyk5HE2lruSQRQ5pPYgCyS9OryuUJscGxdFOnbg/XKg7XJKGWFqU8uoGjlPzQwkRS0SoXZInReahkL3u3FhyguMxMWMfBUyTLDQ6wVtSvSyp+KZKsCBdqJG4mUHf+IvCdp5NmunGvEp/Nuxj0BSCA0srqpPUsNzWdhZBt3iuQZCFLCWa0FSdRdphz8OP+Ed1w/scK/qeqhuwjZnPSZOct5R68ihRz3beSqH9Ik66AOyrlcX8IXXc2mNgnIocOg9WzHViXaQ1qU6OF08t6rkmgUP3ad0PjZlJA9ao
 Lpp8QFZg
 I5vNGQuK/6BzwoERKHGoSdDLbtpvwdCSssEMw5GTouaL3nr9s9Dq8YlOuDbSLRFGNCoTSO2127JoiVr/5C++s2umazmdIMjC0DeG0FqNfT91/TfG5lOw1z7pjBAajY0dZYJvzjJozb6E369OG/qUaLn2ItLqF0Ox5ioKneHD5J/vmp3x06a4B3uBqTmKnYYVn6PEuWl0nUKskS0vjDmtvDI1fg6OVHpRSB4P+CDXEU2stNJ+Zit20OQC+nL6D8hIMNLmharn9QYuJP9ELPezkimWbTaFdZ6jXtXpA9Ojhh7FJmfT5LxJ2Pjjv03ZGgYhtT1lKgAnsTxUhxW+SgQqQ281H09yQeJqRLaBNjJbyCJTAKAwkya/qcXB5h4jItv+pV0lUfaRap6bmKPODx/uTTanKEx7o9TN1UKqQ19F0sEkEKkrgy/Mu3OUMfxGKmlMeCl6H78g8vB4bYeZfyY+TbCuZ6PMEw6I2NGa+ZjdAadFEPAY5taXe0Ds5ZkIKuKNwyUDHPhsnw6NzPmMeXU/GQ5p6LqeDSL7XALNWCeIAAC76546T/JUM1cLbbg==
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

Add xswap_destroy(), reached through the name /proc/swaps prints.
"xswap" is not a path, so the name cannot be opened, and "swapoff -a"
passes it back unchanged.

A real file or directory keeps precedence: only a name that cannot be
opened (-ENOENT) is taken for the device, so a plain file is never
mistaken for it.  The name is compared with strcmp() against the one
name the kernel prints, so there is no parsing.

Destroy is serialized with create by xswap_ctl_lock, and it refuses a
device that is pinned for hibernation.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 148 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 127 insertions(+), 21 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4e598ab8da65..1f319e365b68 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -69,6 +69,8 @@
 
 static int xswap_create(int prio);
 static int xswap_create_by_name(const char *name, int swap_flags);
+static int xswap_destroy(void);
+static int xswap_destroy_by_name(const char *name);
 
 /* Serializes create and destroy: at most one xswap device exists. */
 static DEFINE_MUTEX(xswap_ctl_lock);
@@ -77,6 +79,11 @@ static inline int xswap_create_by_name(const char *name, int swap_flags)
 {
 	return -ENOENT;
 }
+
+static inline int xswap_destroy_by_name(const char *name)
+{
+	return -ENOENT;
+}
 #endif /* CONFIG_XSWAP */
 
 static void swap_range_alloc(struct swap_info_struct *si,
@@ -3360,13 +3367,14 @@ static void flush_percpu_swap_cluster(struct swap_info_struct *si)
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
@@ -3375,15 +3383,30 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	BUG_ON(!current->mm);
 
 	CLASS(filename, pathname)(specialfile);
+	if (IS_ERR(pathname))
+		return PTR_ERR(pathname);
+
 	victim = file_open_name(pathname, O_RDWR|O_LARGEFILE, 0);
-	if (IS_ERR(victim))
-		return PTR_ERR(victim);
+	if (IS_ERR(victim)) {
+		/*
+		 * /proc/swaps shows a name that cannot be opened; accept it
+		 * so swapoff -a works.  Only -ENOENT means "no such path",
+		 * so a file of that name keeps precedence.
+		 */
+		if (PTR_ERR(victim) != -ENOENT)
+			return PTR_ERR(victim);
+
+		err = xswap_destroy_by_name(pathname->name);
+		if (err == -ENOENT)
+			return PTR_ERR(victim);
+		return err;
+	}
 
 	mapping = victim->f_mapping;
 	spin_lock(&swap_lock);
 	plist_for_each_entry(p, &swap_active_head, list) {
 		if (p->flags & SWP_WRITEOK) {
-			if (p->swap_file->f_mapping == mapping) {
+			if (p->swap_file && p->swap_file->f_mapping == mapping) {
 				found = 1;
 				break;
 			}
@@ -3402,20 +3425,50 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
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
 
@@ -3426,7 +3479,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	if (err) {
 		/* re-insert swap space back into swap_list */
 		reinsert_swap_info(p);
-		goto out_dput;
+		return err;
 	}
 
 	/*
@@ -3466,15 +3519,21 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
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
@@ -3485,13 +3544,10 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
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
@@ -4114,7 +4170,57 @@ static int xswap_create(int prio)
 	goto out;
 }
 
-/* A name, not a path: only -ENOENT from opening it gets here. */
+/* Tear down the file-less xswap device. */
+static int xswap_destroy(void)
+{
+	struct swap_info_struct *p = NULL;
+	unsigned int type;
+	int err;
+
+	mutex_lock(&xswap_ctl_lock);
+
+	spin_lock(&swap_lock);
+	/* Only a fully enabled device; a half-created one does not count. */
+	for (type = 0; type < nr_swapfiles; type++) {
+		struct swap_info_struct *q = swap_info[type];
+
+		if (q && (q->flags & (SWP_XSWAP | SWP_WRITEOK)) ==
+			 (SWP_XSWAP | SWP_WRITEOK)) {
+			p = q;
+			break;
+		}
+	}
+	if (!p) {
+		spin_unlock(&swap_lock);
+		err = -ENOENT;
+		goto out;
+	}
+	/* Refuse swapoff while the device is pinned for hibernation */
+	if (p->flags & SWP_HIBERNATION) {
+		spin_unlock(&swap_lock);
+		err = -EBUSY;
+		goto out;
+	}
+
+	err = swap_info_remove(p);
+	spin_unlock(&swap_lock);
+	if (!err)
+		err = __swapoff(p);
+out:
+	mutex_unlock(&xswap_ctl_lock);
+	return err;
+}
+
+/* /proc/swaps shows XSWAP_NAME; accept it so swapoff -a works. */
+static int xswap_destroy_by_name(const char *name)
+{
+	if (strcmp(name, XSWAP_NAME))
+		return -ENOENT;
+
+	return xswap_destroy();
+}
+
+/* The swapon counterpart of xswap_destroy_by_name(). */
 static int xswap_create_by_name(const char *name, int swap_flags)
 {
 	int prio = DEF_XSWAP_PRIO;
-- 
2.54.0



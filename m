Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21117606A331
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 05:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EY+aAeFm
Received: by kanga.kvack.org (Postfix)
	id 31D1E6B05C9; Mon,  9 Nov 2026 00:56:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F42A6B05CA; Mon,  9 Nov 2026 00:56:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20AAC6B05CB; Mon,  9 Nov 2026 00:56:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF9946B05C9
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:56:42 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 64A7E1605A3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:56:42 +0000 (UTC)
X-FDA: 85414521444.11.3108DAF
Received: from mta0.migadu.com (out-169.mta0.migadu.com [91.218.175.169])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5EBC240004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:56:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EY+aAeFm;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.169 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794203800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JlCBONNT+ZbDg6qPytivkskPPXY8kXKDvS7EHo0dVm0=;
	b=Dngwiirc1WUPuisQFc4jfrlVW+Uzs7yoOUEFcbhq0iauWuZB1RBbnHIippCtQp0oa7/gEU
	hIoTpu+8lMbs3tzY6LDHiXJ8WP8vqfCxMmGYn9SyCWkzbEmQXGt5E7rfFm3btlrZedMblK
	Zi8+pbTPnCTJzU9BFq+C+m/205queHU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794203800;
	b=oEwvLsjyKEwJq3kDVuQNW7l9OoB5KyEYLOl8Ppva9pOwNnhf+wzmau/DhEtdaba+a7BbiG
	sRsvBLdTKZJO0HYGrnzv16/Y5PWW2rc+CrtgsRZj8d+G8BXZag5Stu9yMpPObmA6rnb2AM
	9o4I3HxZOCWKUA8vb9XACdHW9nEtaoE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EY+aAeFm;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.169 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MD3o7aNueWGNBNBzZbpbzs78TOr8ucQzwGbCBJTHSEk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794203799; v=1; x=1794808599;
 b=EY+aAeFmmmKxoY2rZCPk8W28WPakqyQXhPFMw1YLdjNis6chIaFn6Y+NBpueTiHDOubo0ou5
 glSObn3VM/Ej4I7sb2rro7mWK76qOb89WbZgly/1RlwyaF2PoOlBhTGT4X755A91CRLfqa8iC/F
 Khcz//NM60VNY4DwJnO7DcKY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 1bb98dd1117171f9;
	Mon, 09 Nov 2026 05:56:39 +0000
X-Mizu-Trace-ID: 1bb98dd1117171f9
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
Subject: [PATCH v5 09/19] mm, swap: use a stable id for xswap devices
Date: Mon,  9 Nov 2026 13:54:45 +0800
Message-ID: <20261109055455.536925-10-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109055455.536925-1-baoquan.he@linux.dev>
References: <20261109055455.536925-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: rm5qe5krmgz1yibfgdp67zshcyh96psk
X-Rspamd-Queue-Id: 5EBC240004
X-Rspam-User: 
X-HE-Tag: 1794203800-130651
X-HE-Meta: U2FsdGVkX1+heoXGuoKIMctE5Su/1AqCegE+BXzAKSBOnPDgVkhl0BPecnQjAZkWmkRgSbq/TXEYjKs6J2lxGatB7YIV+0bUvIkOGdfLJbH9HsEgtbfFBx8gZDn5uMTry7dydqOMjAYxMj61vQzNMyxDbOvUIPJka0gNQnwpA3uhNarqjX0pw/uxcqujHPdvmDk9pcOTPh01ilSK1+BlwaXwdnypA/3uWEx64P4hbtsHVjxiVD9bgMyln90O72MSSqK6+1h5AAR0wFRRADdAG946kiedK6LhoNzaJE1TJ8ADiUksaZ5y+1fYJtPMXky6fQ/svfKj/4qZMG3aiaNQTQArhhKOTkQbiqiuzGuns61e+oaFbgfxpyC4iwype3neoeMIoakujkZ75Q8PHU2BE9gv7Sd9ZHskPjx9nVa2/7xdE+jj9w+/rQvWS5hotXQXg1h7RBMXZHIHnOSoUAJH/Ho+s5cV1XOPC8mTrma85iyJHg/iVTMxcQ5BEzDk4fiHfB+d+269JJPngKzv+CBLWKc4YhOB0K46WPBtZ5FTNnR8QGDj1IkpXkA/T1rIm40Bnyv3tqK2M6GZw40Wh+DQXv6XNBzjFwyJGjmzwJxo8+/ViM3BRzEPnkqH8hJ14edKeoy/sTTNeKY2ym0+AsBgKWHy9j1sf7qaI3cP6a8xMS3x3iD4bVGGl+olAOrfTX6QyBbMP/WUJ5PFBm2OJwKvIf2yg3khZD8QhnY4U93Zw58X0iEJQZoUT6vQqF0suDs6odBc2/tCGeNQUB7Nxrues3xA28yCgfvTTeldiQmLuECJ0527s5kIyDWEhUEvcukB9n4yBVKxw54Tw6qnPRe4SsBRln0FH4/bGsW506Wj8137PRpQIGMA4zl6y+2VHSI/1McARuiKNDK9YEtjAn44evaK0wzgpcGDh4jdG+Fd1aMaDJg2iA7dR66QZbfIDmZjf9ZX2BrWWorwI6k27lH
 ZKCIH1Wv
 CUziVdbbQ2YhV9hsebC9sP/xkKvgLYzYEvJgi4XhVDimNHxdVPIeuN3XOw0IbBpDF1loQoaFwWLiL2kci67kj4PTVcrwixxhLaxxdzj968l4M+8Bc2+1TQYKVYjL17EV9DZRS3qYoGv2f72Bsp9hXagoK5rm6oMh/aoZ0jxSSj8GXGT7K+xbeB2vniZTpv3zxkQVtJwwNyenuAuvm2Df6th+7F1mBCyV6F+AhaCVN66zz/OnKN6MNSFj17b2l9RQSDSL3kEJ4Zp1puAqTzzmMKy1oN8MWFH697/aKuST9FK6MevuvTgvsIbuzmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

Give each xswap device a 64-bit id from a counter. The id is never
reused. Show "xswap<id>" in /proc/swaps and use the same id in
debugfs. Destroy matches the id, so an old name fails with -ENODEV
instead of hitting a new device.

This avoids names based on the swap type, which can be reused after
swapoff. The swap type is still used inside the kernel and in dmesg.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |  1 +
 mm/swapfile.c        | 59 ++++++++++++++++++++++++++++++--------------
 2 files changed, 42 insertions(+), 18 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 569989856c25..f4eb1912d1e6 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -244,6 +244,7 @@ struct swap_info_struct {
 	struct swap_cluster_info *cluster_info; /* array, one entry per cluster */
 #ifdef CONFIG_XSWAP
 	struct vm_struct	*cluster_vm;	/* VM_SPARSE area for cluster_info */
+	u64			xswap_id;	/* stable id, shown to userspace */
 	unsigned long		nr_clusters_max;/* total clusters in the xswap address space */
 	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
 	struct mutex		xswap_lock;	/* serialize map/unmap operations */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 35c8aac1e25d..44b54118d10a 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -86,7 +86,10 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data);
 
 static int xswap_create(int prio);
-static int xswap_destroy(int type);
+static int xswap_destroy(u64 id);
+
+/* Stable device id, assigned at create and never reused. */
+static atomic64_t xswap_id_counter = ATOMIC64_INIT(0);
 
 static ssize_t xswap_create_store(struct kobject *kobj,
 				  struct kobj_attribute *attr,
@@ -121,19 +124,17 @@ static ssize_t xswap_destroy_store(struct kobject *kobj,
 				   struct kobj_attribute *attr,
 				   const char *buf, size_t count)
 {
-	unsigned long type;
+	u64 id;
 	int err;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	err = kstrtoul(buf, 0, &type);
+	err = kstrtoull(buf, 0, &id);
 	if (err)
 		return err;
-	if (type >= MAX_SWAPFILES)
-		return -EINVAL;
 
-	err = xswap_destroy(type);
+	err = xswap_destroy(id);
 	if (err)
 		return err;
 
@@ -3657,9 +3658,15 @@ static int swap_show(struct seq_file *swap, void *v)
 	if (file)
 		len = seq_file_path(swap, file, " \t\n\\");
 	else {
-		char name[16];
+		char name[32];
 
+#ifdef CONFIG_XSWAP
+		len = scnprintf(name, sizeof(name), "xswap%llu",
+				(unsigned long long)si->xswap_id);
+#else
+		/* CONFIG_XSWAP=n has no file-less devices; keep the type. */
 		len = scnprintf(name, sizeof(name), "xswap%d", si->type);
+#endif
 		seq_puts(swap, name);
 	}
 	seq_printf(swap, "%*s%s\t%lu\t%s%lu\t%s%d\n",
@@ -4295,6 +4302,11 @@ static int xswap_create(int prio)
 	si->flags |= SWP_XSWAP | SWP_SOLIDSTATE;
 	si->max = maxpages;
 	si->pages = maxpages - 1;
+	/*
+	 * Set before the device is enabled, for debugfs; destroy only matches
+	 * a WRITEOK device, so the create window is not reachable.
+	 */
+	si->xswap_id = atomic64_inc_return(&xswap_id_counter);
 	/*
 	 * No backing file: setup_swap_extents() is only reachable from the
 	 * file-backed swapon() path, so set ops here.  Only ops->flags is
@@ -4316,8 +4328,8 @@ static int xswap_create(int prio)
 	si->list.prio = -si->prio;
 	si->avail_list.prio = -si->prio;
 	enable_swap_info(si);
-	pr_info("xswap: adding extendable swap type %d (prio %d, %lu pages)\n",
-		si->type, prio, si->pages);
+	pr_info("xswap: adding extendable swap device xswap%llu (prio %d, %lu pages)\n",
+		(unsigned long long)si->xswap_id, prio, si->pages);
 	mutex_unlock(&swapon_mutex);
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
@@ -4336,20 +4348,31 @@ static int xswap_create(int prio)
 	return error;
 }
 
-/* Tear down a file-less xswap device by its swap type. */
-static int xswap_destroy(int type)
+/* Tear down a file-less xswap device by its stable id. */
+static int xswap_destroy(u64 id)
 {
-	struct swap_info_struct *p;
+	struct swap_info_struct *p = NULL;
+	unsigned int type;
 	int err;
 
-	p = swap_type_to_info(type);
-	if (!p)
-		return -EINVAL;
-
 	spin_lock(&swap_lock);
-	if (!(p->flags & SWP_WRITEOK) || !(p->flags & SWP_XSWAP)) {
+	/*
+	 * Match only a device that is fully enabled: one still being created
+	 * is not WRITEOK yet, and one being destroyed has lost it. Neither
+	 * is a valid target, so both read as "no such device".
+	 */
+	for (type = 0; type < nr_swapfiles; type++) {
+		struct swap_info_struct *q = swap_info[type];
+
+		if (q && (q->flags & (SWP_XSWAP | SWP_WRITEOK)) ==
+			 (SWP_XSWAP | SWP_WRITEOK) && q->xswap_id == id) {
+			p = q;
+			break;
+		}
+	}
+	if (!p) {
 		spin_unlock(&swap_lock);
-		return -EINVAL;
+		return -ENODEV;
 	}
 	/* Refuse swapoff while the device is pinned for hibernation */
 	if (p->flags & SWP_HIBERNATION) {
-- 
2.54.0



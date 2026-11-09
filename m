Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F657606A322
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 05:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=r02Jn7yl
Received: by kanga.kvack.org (Postfix)
	id 84D456B05D2; Mon,  9 Nov 2026 00:57:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FDF06B05D3; Mon,  9 Nov 2026 00:57:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ECC76B05D4; Mon,  9 Nov 2026 00:57:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B0DD6B05D2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:57:14 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C2D91805E5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:57:13 +0000 (UTC)
X-FDA: 85414522746.08.B5CD080
Received: from mta0.migadu.com (out-201.mta0.migadu.com [91.218.175.201])
	by imf11.hostedemail.com (Postfix) with ESMTP id C26CF40002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:57:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r02Jn7yl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.201 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794203832;
	b=5iQcAfxfPy4RaWA/asLxIaDkl2uL49ExBpPjB6Xsn8lF0JRKzasj/ZosiZ9erlak3EK4ML
	PzCFTJAu+dPjg5A/OhdHc987LvEPqwwHc45GtGTqQEFVYX/Ay0bfMODtSbGe3rdGr6iD8/
	CVGqoyolgrPKH2ZXDMQmfqwg7a3suT8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794203832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Mcv/XJaMcAv3XMoY0dY+kxAeOd8sz09Ek9mVYGDsbE=;
	b=hDO7V+hYJd9COh5fnMUGJZ+4f9vo6ToO853oSlIbplFfcXC4JzsT5vKiHWCw9lfRmXu558
	4hwKSEnsTbEAryaRSzu4zqRlZzbyW05P+ydR57HO2fHTiacrgE/DGgZO/Q6EoD1Wgdw/I9
	aTv0Cpa2sGaNH7fEhQMesgBnjvkhRZM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r02Jn7yl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.201 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Gk1lEeXwH6beBGZ93Rd5bpmNiJTelW9F3TI6PxqpXmM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794203830; v=1; x=1794808630;
 b=r02Jn7ylr8duxxZ01z3Co9kR29/PZyplz6fdzEbDoXVRk1b7itSxBwQHuG/rZNzcU5fVbOaM
 X5sokBywT9f4NxnM/gg1BvE2dqMSeO81/IJn9NMszB5k8YGA3Ogj45tZhRsozcyndVPe3siwqpl
 owRGf13cl3N53iDdRrMphau0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 8f47b3e4ceaa730d;
	Mon, 09 Nov 2026 05:57:10 +0000
X-Mizu-Trace-ID: 8f47b3e4ceaa730d
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
Subject: [PATCH v5 14/19] mm, swap: add debugfs counters for xswap
Date: Mon,  9 Nov 2026 13:54:50 +0800
Message-ID: <20261109055455.536925-15-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109055455.536925-1-baoquan.he@linux.dev>
References: <20261109055455.536925-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C26CF40002
X-Rspamd-Server: rspam12
X-Stat-Signature: 4oooz369dahz4dg5mce4bxqqt1kbq7am
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794203831-943015
X-HE-Meta: U2FsdGVkX19D6+uTSw4KAWOyl9kz7cr7z6iL+Wr/gIHIfNdGnRbp/86HJISfwYxkaewwQH7/oq90mZsfsje4qURk38V9xpA5IjSkrinFyaZRklhSNDUjHoriGcnIqacOm6bu9NY6taZFix8g9YQHTcb3Fc++NX1KVfA9ZcKe5+bJmbeSr6xCjHyvB2IHk+FTlttvwi7hEru8JFScrCNiggWXnAEw/TSW6mxEtPdd6NYJfrdNlO9GD7TH9DGZiUHYnG7AlqKU/+Jp21baKzozIhj6oDg8wjzDfKbd0iNpspjO4i4S1dkcBgbtjtHLpILYBkgERcbszhratL7DfGxJMeOok0UP/ItxLJH7kijkKNh5ovfnPqtVgYfcyocWCcCC6na5y9bDrz9Mk3KsEy4YV7RBf2m7eUb7j8/c61DStCLkME/JT0ywX8UJW2G0r0/GpBsGA3pqoVcL/X6XN/7p+mNUCpR/y74vQGha+oST3xCceZaX7zL7mQgZ+5gwWAomNsLieOADior1+sTGiqlaugBoIDSJUVDdHNd4qxaquc7Pz9XmIx3fNGIYWkTxSVzGNfi0lBb0NjjuSv/Umt7f/uG4mMx+ubh1CCkzXmAPcrmABa7ry+xOpThPqz7iNmWcGeolDFegs9zOlqe4psLxs8PQ9PYvfLOGMffCYzggzFYSnooSAjHqMF0b+IxVDyKUrjWQmUCHoY3Th16XPhCd6DVbnffQQHZTEVQI8utx4eH0SQQs2zjMCv4QtEVEOa7fV5UQXWyNr0v91XCcRRBQRiC3tKewEqXGW5HqI2tHpkKYykXvcS5A69gkIiOjuAqK0FwmXQ7SaUyBC0RKYps3xUz6XUT6EhUWffPH11+HhEXShpCZgj3Qm17mfaeGmmIfBsSUuE6vBdyHYQaFK8cICz8eam1kFvYWlwFFlUteEqyeSg6n+jGv77Bna758KyogPV4q7da8lNwf/rZ1eLn
 +dERhscb
 2TvxqHmbzZVpMGOai4n8iUv3W3moXURLAik4y0M1D5IEZrCtzVaULohuNXRADoJmUtnR5piv3LI4RRegdWvnncwF0V7KWAc0W/voParAzdFsTqN8I0HEr1EUQpuSlS+w+CkBEb1/s2D3pJSOu9b13HYjVoHWQEkKv3wrKIh3MYpJpEKu3BY+P5yEE4c0WgWuWkUSNeJLOagpntgUPTpgUJ+OYxUhMUEr2IFf2hRBgywDo62+ueMWsEo38soMNo6i853jY/yhCzvkFhQlSlikA+kJAR9nYWpghaaY956mnMIogrSVqOWhdRAloM4uT5qVUOhJeU1bu7c+MYtvRvbWw6uHoSj/Q8B7Fr5N7AA7jqXjKaaGU2/RaNwkTSn4KhFelYXpTwJnEFPx3R2gM0Rpa4fo8ZDpq/nJAECcbVl0ue3m1ds//awnArV/wqbFlVQt6p7ArnKfb+C9ECXGe6+HszEGuptXIhQkYxL/V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

The mapped range and the grow count are not visible from userspace.
This makes it hard to check if the grow thresholds work: we cannot see
how large the mapped range is, how much it grows, or how much free tail
it keeps.

Put this information in debugfs. It is a debugging aid, not a stable
interface, so it does not belong in sysfs or the ABI:

  # cat /sys/kernel/debug/xswap/xswap1
  type 0
  clusters_max 2038783
  clusters_mapped 292
  usage_pages 91456
  tail_free 16
  grows 3
  shrinks 0

The shrink counter is initialized here. It will start to increase when
the shrink path is added.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |  3 ++
 mm/swapfile.c        | 78 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index f4eb1912d1e6..29623c5138ab 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -248,6 +248,9 @@ struct swap_info_struct {
 	unsigned long		nr_clusters_max;/* total clusters in the xswap address space */
 	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
 	struct mutex		xswap_lock;	/* serialize map/unmap operations */
+	struct dentry		*xswap_debugfs;	/* mapped range and counters */
+	atomic_long_t		xswap_grows;	/* grow operations so far */
+	atomic_long_t		xswap_shrinks;	/* shrink operations so far */
 #endif
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index ba730fa19194..2624233b4fc2 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -46,12 +46,14 @@
 #include <linux/suspend.h>
 #include <linux/zswap.h>
 #include <linux/plist.h>
+#include <linux/debugfs.h>
 
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
 #include "swap_table.h"
 #include "internal.h"
 #include "swap.h"
+
 #define DEF_SWAP_PRIO  -1
 
 /*
@@ -92,6 +94,7 @@
 
 static bool xswap_should_grow(struct swap_info_struct *si);
 static unsigned long xswap_grow(struct swap_info_struct *si);
+static void xswap_debugfs_del(struct swap_info_struct *si);
 static int xswap_map_clusters(struct swap_info_struct *si,
 			      unsigned long start_idx, unsigned long nr);
 static void xswap_unmap_clusters(struct swap_info_struct *si,
@@ -3488,6 +3491,7 @@ static void free_swap_cluster_info(struct swap_info_struct *si)
 		 * pages, and the unmap helper handles an empty range.
 		 */
 		xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
+		xswap_debugfs_del(si);
 		free_vm_area(si->cluster_vm);
 		si->cluster_vm = NULL;
 		si->cluster_info = NULL;
@@ -4265,6 +4269,7 @@ static unsigned long xswap_grow(struct swap_info_struct *si)
 		spin_unlock(&ci->lock);
 	}
 
+	atomic_long_inc(&si->xswap_grows);
 	return nr_new;
 }
 
@@ -4336,6 +4341,73 @@ static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data)
 	*mapped_end = addr + PAGE_SIZE;
 	return 0;
 }
+static ssize_t xswap_debugfs_read(struct file *file, char __user *buf,
+				  size_t count, loff_t *ppos)
+{
+	struct swap_info_struct *si = file->private_data;
+	struct swap_cluster_info *ci;
+	unsigned long mapped, tail = 0;
+	char tmp[192];
+	int len;
+
+	/*
+	 * The same scan the shrink does.  xswap_lock is what keeps
+	 * cluster_info from being unmapped under it.
+	 */
+	mutex_lock(&si->xswap_lock);
+	mapped = READ_ONCE(si->nr_clusters_mapped);
+	if (si->cluster_info) {
+		while (mapped - tail > 1) {
+			ci = &si->cluster_info[mapped - tail - 1];
+			if (READ_ONCE(ci->count) ||
+			    READ_ONCE(ci->flags) != CLUSTER_FLAG_FREE)
+				break;
+			tail++;
+		}
+	}
+	len = scnprintf(tmp, sizeof(tmp),
+			"type %d\nclusters_max %lu\nclusters_mapped %lu\nusage_pages %lu\ntail_free %lu\ngrows %lu\nshrinks %lu\n",
+			si->type, READ_ONCE(si->nr_clusters_max), mapped,
+			swap_usage_in_pages(si), tail,
+			atomic_long_read(&si->xswap_grows),
+			atomic_long_read(&si->xswap_shrinks));
+	mutex_unlock(&si->xswap_lock);
+
+	return simple_read_from_buffer(buf, count, ppos, tmp, len);
+}
+
+static const struct file_operations xswap_debugfs_fops = {
+	.read	= xswap_debugfs_read,
+	.open	= simple_open,
+	.llseek	= default_llseek,
+};
+
+static struct dentry *xswap_debugfs_root;
+
+static void xswap_debugfs_add(struct swap_info_struct *si)
+{
+	char name[32];
+
+	if (!xswap_debugfs_root)
+		xswap_debugfs_root = debugfs_create_dir("xswap", NULL);
+	if (IS_ERR_OR_NULL(xswap_debugfs_root))
+		return;
+
+	/* debugfs_create_file() takes the name as it is; no formatting. */
+	snprintf(name, sizeof(name), "xswap%llu",
+		 (unsigned long long)si->xswap_id);
+	si->xswap_debugfs = debugfs_create_file(name, 0444,
+						xswap_debugfs_root, si,
+						&xswap_debugfs_fops);
+	if (IS_ERR(si->xswap_debugfs))
+		si->xswap_debugfs = NULL;
+}
+
+static void xswap_debugfs_del(struct swap_info_struct *si)
+{
+	debugfs_remove(si->xswap_debugfs);
+	si->xswap_debugfs = NULL;
+}
 #endif /* CONFIG_XSWAP */
 
 static int setup_swap_clusters_info(struct swap_info_struct *si,
@@ -4552,6 +4624,10 @@ static int xswap_create(int prio)
 	 */
 	si->ops = &swap_bdev_ops;
 
+	si->xswap_debugfs = NULL;
+	atomic_long_set(&si->xswap_grows, 0);
+	atomic_long_set(&si->xswap_shrinks, 0);
+
 	error = setup_swap_clusters_info(si, NULL, maxpages);
 	if (error)
 		goto bad_swap;
@@ -4561,6 +4637,8 @@ static int xswap_create(int prio)
 		goto bad_swap;
 
 	mutex_lock(&swapon_mutex);
+	/* Two creates would race to make the root directory. */
+	xswap_debugfs_add(si);
 	si->prio = prio;
 	si->list.prio = -si->prio;
 	si->avail_list.prio = -si->prio;
-- 
2.54.0



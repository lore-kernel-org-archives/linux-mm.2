Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3571DCA5FE6
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:33:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BE136B008C; Fri,  2 Oct 2026 20:33:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 294966B0098; Fri,  2 Oct 2026 20:33:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D1F26B0099; Fri,  2 Oct 2026 20:33:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3B366B008C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:33:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 77024A78DD
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:33:18 +0000 (UTC)
X-FDA: 85279440876.24.AB7BD27
Received: from mta0.migadu.com (out-151.mta0.migadu.com [91.218.175.151])
	by imf12.hostedemail.com (Postfix) with ESMTP id 80E4B40004
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:33:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.151 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790987596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9nZq3S+Qdzrv1aG0i9l0JM4CqOUGkZvY2pVSKKWgtbE=;
	b=m6Coqthcg8+KUXuWVcHWeIljapZ8pRasYq8emaC8Du79t3FKhVXVfLfVjbII5Uqre14+UV
	dnd11T870lCm9CSQfUiaQ0CllPvcCMyFXOU4tgmtA3EjVT2T0yjx/N9ws6yvoojskDvFjh
	mVGkVnsJlCdVPnLat5z6kYHRJHEZxEE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.151 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790987596;
	b=itcQdZW76r5+Sq2nbuyVs759KOOOEqVqjDJNg6kWrtRhXuaIfoDcxJUHl5bKpfykrj/Lp1
	Nsji5DIIjEx4IRRwoHyV/is1Cvi5uzGFo0X3C84T8ZriofkINwAFmdj6iEbmGlLrt+7sRq
	AJEO1Kq0TX/Ux5aSI6BAVYZvRxsjhYw=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 894fef0c8ad9ae09;
	Sat, 03 Oct 2026 00:33:15 +0000
X-Mizu-Trace-ID: 894fef0c8ad9ae09
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
Subject: [PATCH v4 13/14] mm, swap: add debugfs counters for xswap
Date: Sat,  3 Oct 2026 08:31:35 +0800
Message-ID: <20261003003136.750633-14-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003003136.750633-1-hebaoquan@kylinos.cn>
References: <20261003003136.750633-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 45ysbmrnenpjqcx71be9en7wscsb7mqr
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 80E4B40004
X-HE-Tag: 1790987596-584008
X-HE-Meta: U2FsdGVkX19WQyWOT2fHPeh8Umg5yT+rqWk3pfgISiTQ4JyWvIvTfAZVw8P6AB0FH5RKmOzB6rDw3OuZwgwWKjoAoEieVjaxsJ4Ezj0T4kBiBxwQy2g4O615vUfGjRRMSioYYHg/9R+9CfQTHvZhg3bG4+gkzOZ1E1kuhPhEHAxq3J1TcYYKXvBRldU5AVbIhrOzqvDtOzySuNrB/h4W8iPoAt+v7L3n9xZ8K6lIcnE7JWplVhWc7XvUmUQLPjgacGg1w3KT67I1Kt1ZYjz9FqfAtuo1c6rJ/kZw60dkWY9YRdoh2TlCxpvSkLVeY7Q6qMK46PUuVSEbDNiTwd8WL8TyljtHQ83qAL8iUPnyb7+VK7vJckgGHz4u6a4us4weji5vrS0IjroLST/6MFsCdw4UkKCPg/0tnWrI/FlsquYdUm3a/2u547Ad3m5W6c+KDmXtiYqVaT2g1uZo+R/UFe7y6U2xoXh+yzWj6XGCn3WvDauz+pKpkcjpr6fs8/SFwDrRehcEvJ4xUYGSWat3GHV3yaZ2OatXFZ22ZpplkAOb7sjxr1mkiOfpKMtHkkc/TQebsnY/rEs635qie0jzvIKtfsQJ7aPQlEWv/Zk1nO4kzyiIFzyZpbI5JKZnAFOAhJMFHChn8GMDQ87FEt46Llee1Uip9u2HDU7uIhvOrMb/BvzM1HOCntgBwedXuetkTc2eYTM/1Pjr2lLk99TWsUE9CsZZ4I82RejKox/8pWmD/8v0XXikGjCfYgTZmpH22BudxvXM2belmYrdx0tEAPVesot8hohf0sbw5kFXdvMyr1QFRHWxuQPugSY4VIHvqPikfXL7V2X85Uf6o/6AaA23aTsx2yGrS7HtLd+EN7hQPTdbSxQvldQUip6PNHlsNokDAwM+/XLtJchR9Wzwmxs9LhpXxR3TZo+c+pQmAB6pmz6kRLWjrJ6gvIRZCm67TzqMeJds3k/d3f8YIZ6
 luRFnA3r
 vA3dJWdAnnPUUdl6jhnV1Xd7Jw7cMMdOjvSZqEody9QWeWuHqfIFkev5697WeG7MhWyzzgEGenBVFCbXXsyVRaSYz9MP9nr5rUME+4MDrtvRL3pS7IOkndJzIHtU+P9RcMxmssirpFdNzLjRwsR79cZOcVuMG49hFvRX3pwUEuWu9Vtv6RooQ1nAd60XZUurPjGMe21ajt/bYqm1pVpXYFRcoQDeZ02hugeEMFCn/YRASnK6kn/24aK+31YyEZDnPPAXEPVTTHUGWiyrkaQIKupil/EYSno5YQEbVThxY7o5TJkE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mapped range and the number of grow and shrink operations are not
visible from userspace, which makes the grow and shrink thresholds hard
to check: nothing says whether the range settles, how often it moves, or
where it lands.

Put them in debugfs rather than sysfs. This is not an interface and does
not want to be one, so it does not belong in the ABI:

  # cat /sys/kernel/debug/xswap/type0
  clusters_max 2038783
  clusters_mapped 292
  usage_pages 91456
  grows 3
  shrinks 1

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |  3 ++
 mm/swapfile.c        | 80 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index c56adbbcfd3b..ae2e49386443 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -248,6 +248,9 @@ struct swap_info_struct {
 	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
 	struct work_struct	xswap_shrink_work; /* deferred shrink trigger */
 	struct mutex		xswap_lock;	/* serialize map/unmap operations */
+	struct dentry		*xswap_debugfs;	/* mapped range and counters */
+	atomic_long_t		xswap_grows;	/* grow operations so far */
+	atomic_long_t		xswap_shrinks;	/* shrink operations so far */
 #endif
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index f823cebb7937..ab040d24bd2f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -49,6 +49,8 @@
 #include <linux/leafops.h>
 #include "swap_table.h"
 #include "internal.h"
+#include <linux/debugfs.h>
+
 #include "swap.h"
 #define DEF_SWAP_PRIO  -1
 
@@ -84,6 +86,7 @@
 
 static bool xswap_should_grow(struct swap_info_struct *si);
 static unsigned long xswap_grow(struct swap_info_struct *si);
+static void xswap_debugfs_del(struct swap_info_struct *si);
 
 /* Batch size for the fallback unmap; keeps the stack array small. */
 #define XSWAP_UNMAP_BATCH_PAGES		16
@@ -3416,6 +3419,7 @@ static void free_swap_cluster_info(struct swap_info_struct *si)
 		}
 		/* free_vm_area() drops the mapping without freeing the pages. */
 		xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
+		xswap_debugfs_del(si);
 		free_vm_area(si->cluster_vm);
 		si->cluster_vm = NULL;
 		si->cluster_info = NULL;
@@ -4134,6 +4138,7 @@ static unsigned long xswap_grow(struct swap_info_struct *si)
 		spin_unlock(&ci->lock);
 	}
 
+	atomic_long_inc(&si->xswap_grows);
 	return nr_new;
 }
 
@@ -4370,10 +4375,79 @@ static void xswap_try_shrink(struct swap_info_struct *si)
 	spin_unlock(&si->lock);
 
 	xswap_unmap_clusters_locked(si, start_idx, nr_unmap);
+	atomic_long_inc(&si->xswap_shrinks);
 
 out_unlock:
 	mutex_unlock(&si->xswap_lock);
 }
+
+/* Not an interface: how far the mapped range has moved, for testing. */
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
+			"clusters_max %lu\nclusters_mapped %lu\nusage_pages %lu\ntail_free %lu\ngrows %lu\nshrinks %lu\n",
+			READ_ONCE(si->nr_clusters_max), mapped,
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
+	char name[16];
+
+	if (!xswap_debugfs_root)
+		xswap_debugfs_root = debugfs_create_dir("xswap", NULL);
+	if (IS_ERR_OR_NULL(xswap_debugfs_root))
+		return;
+
+	/* debugfs_create_file() takes the name as it is; no formatting. */
+	snprintf(name, sizeof(name), "type%d", si->type);
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
@@ -4568,10 +4642,16 @@ static int xswap_create(int prio)
 	 */
 	si->ops = &swap_bdev_ops;
 
+	si->xswap_debugfs = NULL;
+	atomic_long_set(&si->xswap_grows, 0);
+	atomic_long_set(&si->xswap_shrinks, 0);
+
 	error = setup_swap_clusters_info(si, NULL, maxpages);
 	if (error)
 		goto bad_swap;
 
+	xswap_debugfs_add(si);
+
 	error = zswap_swapon(si->type, si->max);
 	if (error)
 		goto bad_swap;
-- 
2.54.0



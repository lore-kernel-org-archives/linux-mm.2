Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EB39C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:50:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34B866B0286; Thu, 13 Aug 2026 06:50:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FCEA6B0288; Thu, 13 Aug 2026 06:50:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23A366B0289; Thu, 13 Aug 2026 06:50:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E85E56B0286
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:50:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7C2251C1783
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:50:44 +0000 (UTC)
X-FDA: 85095928008.29.C81C53B
Received: from mta1.migadu.com (out-169.mta1.migadu.com [95.215.58.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id A616F180007
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:50:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.169 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786618242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L14QovlMJcoch3DgRuQXccmXT86WN7bHa+Dv06AKlW8=;
	b=40b/E0WcTzmrfMxkM+c77/VuO6OX3QgHxJ3nAnW/5KV6xBizzYw7g4We0lYfdAP4IO9E5s
	IZ0077Sjdc3EOxN+l9VuUnLtdgSOxqFgSbr7Zmp5FZCrIRId9OjwCtaIgkcDWFZxO4yJUM
	ch2f6g0Y0zO0NZzbw5uSnB/h7mSdPmU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.169 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786618242;
	b=Wcit3az1wtdUo60TYnkqYjbj26mnT7tj/VYmTqOeUrlPfZ7hdj/GD+NhQa8Mfi/BQ+FgoR
	mDPpEKQDLKzXJJwVZgQfDBLcq2M99wQJkiOCefZSFSdhpDMX2HZtyk4neovtVuJSjP0bTS
	QM6TT8EoBD8OobUDTqjeydc5RKFBo8o=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta11.migadu.com with ESMTPS id 8ab577fd1f3b3491;
	Thu, 13 Aug 2026 10:50:41 +0000
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
Subject: [RFC v3 12/15] mm, swap: add debugfs knob for xswap per-device cluster limit
Date: Thu, 13 Aug 2026 18:48:51 +0800
Message-ID: <20260813104857.3450386-13-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
References: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A616F180007
X-Stat-Signature: 3mqwjsju33tmfwi5iorrdyqbyg1jg1zf
X-Rspam-User: 
X-HE-Tag: 1786618242-390887
X-HE-Meta: U2FsdGVkX1/QhTH7W6vJPmwX+1o3f7gMBicFyA5z0BXnxIg1xh16ejo1MIw70AKdGhr7Xs3bVNo44QUhh8Jhfyq1WOXCvvpGutloPhtm77aglBU+vuwUVLoB+wNtCrYT/qTjD7wHWEgmUwtRO+mbhtdz2cIF1fnm0M0tk38GGHAUlUMbMVLB6XofMwWapnTDW0cJQ2hupE9i5riMU/qQlbvRStKhMLqnvYF8inXFwTPXK3vHLEPblCHEYLoVe+LMAy+rX/gwbfjY+BLprRmQNobkQS7K/OhybPdMvZOivCH0ZdrgyInSah89svUfNxrVVJRS8Zjfm5LMYZexUz1nhN3Rt1HWGjjP99qjoTjp2RErj8q2ajcoXUhayIhmTV8NoF65pGP2dJAgnS2z16KDxzfkwxRi6IVj6/6OffxfhLqeP1GPl87Tb6v8Z5js6w86FFtJtwME8fGTU/wmtuYtunSFwxXx7dZp7Cp6bDiRAWZ3QnpkJZm8SUgfN6kIHF9yPJqBrPdyVANXkS5eK2KBR5w7UO/ktfYv4IkSArWcZtp/hZLQZQt8u6rMsgzOWA7fz/YL+q8Uu0vD1Q9c5eYDCyFresqTRaofGqGIf/yTOclKc/s6MIKPQzwzsaha4yIsGNZ4WMi9bMoF4Tds2N04fpmvIU12Pso1DxQWfl3YR7ByoCKUoc3YSki4QGAUQGSwWQdzgW8isUOYMQzX2eBpuN1T9gO1Ls7cjZR0qTcEjypoxe7fcMNla0ORcCuiTDqaxiyLzTma1z0odXZ3xhX4p9nFjUksrft0XfHAhxKpYW65ryo51AQ6sD8Q8HatfHL7uclW8y6EKzjwBK3e1R5Oyi2FZH4cNBSyMXddw4lK9757ZKnUgw2XjanTnOUgi1bChEMKC5TdD55r5r4AsqqILtNGuwSVSDVPomwardrB9/kKW5R1fzv6avxBFL5e+eCZ9qnUpCgyR7RbPnbqfc0
 jVi2U3cq
 T5oZvIlsocOgrrvOMZn+s1TesIlCInS2CWxWwzpIzAY6iLG83ipD5QfDkShd6vgCHQ+MZ3bMiO2ulWat+3C0b0zq4gazObW1CBs/rVsqtorycuhmqr6tU6te50GLybEz+PF/GVuglYnmi+TIpi65qrJXGnIl8IuCdDTT04ZGc1S+I7uL664RlcIgsq1amWsYH9BUmD/IHi4gcmEUIHNWPIGMpDCq1EjKbH9+PxrRBrSFRaVNjMHjcilWS7lAmXJB+97jXw4aPFaVh+FQ59Y8e9gv1ffarhCGJ+Adf+hcdFnRY/FSiW7aSDH1yPNlpGVEo289bJjzHLI8TpJtvjCiXbnQ14vnwqyS1bMWHjEvnXCiElbJhANK9d7awnSfnj+Xi2sEF3t753MuYQ9E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a per-device debugfs file for runtime adjustment of xswap cluster
limit:
  /sys/kernel/debug/xswap/type<N>_cluster_limit

Reading shows the current ceiling (in clusters); writing sets it
(clamped to [0, nr_clusters_max]). Setting below nr_clusters_mapped
triggers an immediate shrink check via xswap_try_shrink().

The debugfs entry is created on device creation and removed on
destruction.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |  1 +
 mm/swapfile.c        | 90 ++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 88 insertions(+), 3 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 93d7771f2427..4d8ca920d2f9 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -254,6 +254,7 @@ struct swap_info_struct {
 	unsigned long		nr_clusters;	/* current growth ceiling (≤ nr_clusters_max) */
 	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
 	unsigned long		nr_free_tail;	/* contiguous free clusters at tail */
+	struct dentry		*debugfs_entry;	/* debugfs: type<N>_max_clusters */
 	struct mutex		xswap_lock;	/* serialize map/unmap operations */
 #endif
 	struct list_head free_clusters; /* free clusters list */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index be56114a6691..2755a549582c 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -50,6 +50,9 @@
 #include "swap_table.h"
 #include "internal.h"
 #include "swap.h"
+#include <linux/debugfs.h>
+
+static DEFINE_SPINLOCK(swap_lock);
 
 #ifdef CONFIG_XSWAP
 /*
@@ -66,6 +69,8 @@
 	max_t(unsigned long, PAGE_SIZE / sizeof(struct swap_cluster_info), 16)
 #define XSWAP_DEFAULT_CLUSTER_PERCENT 30
 
+static struct dentry *xswap_debugfs_root;
+
 static int xswap_map_clusters(struct swap_info_struct *si,
 			      unsigned long start_idx, unsigned long nr);
 static void xswap_unmap_clusters(struct swap_info_struct *si,
@@ -76,6 +81,83 @@ static void xswap_update_free_tail(struct swap_info_struct *si,
 				    unsigned long freed_idx);
 static void xswap_try_shrink(struct swap_info_struct *si);
 
+/*
+ * debugfs read/write for per-device max cluster count.
+ */
+static ssize_t xswap_max_clusters_read(struct file *file, char __user *buf,
+				       size_t count, loff_t *ppos)
+{
+	struct swap_info_struct *si = file->private_data;
+	char tmp[32];
+	int len;
+
+	len = snprintf(tmp, sizeof(tmp), "%lu\n", READ_ONCE(si->nr_clusters));
+	return simple_read_from_buffer(buf, count, ppos, tmp, len);
+}
+
+static ssize_t xswap_max_clusters_write(struct file *file,
+					const char __user *buf,
+					size_t count, loff_t *ppos)
+{
+	struct swap_info_struct *si = file->private_data;
+	unsigned long val, new_pages;
+	int err;
+
+	err = kstrtoul_from_user(buf, count, 0, &val);
+	if (err)
+		return err;
+
+	if (val > si->nr_clusters_max)
+		val = si->nr_clusters_max;
+
+	spin_lock(&si->lock);
+	si->nr_clusters = val;
+	spin_unlock(&si->lock);
+
+	new_pages = min_t(unsigned long, val * SWAPFILE_CLUSTER, si->max);
+	if (new_pages)
+		new_pages--;
+	if (new_pages != si->pages) {
+		long delta = (long)new_pages - (long)si->pages;
+
+		spin_lock(&swap_lock);
+		si->pages = new_pages;
+		atomic_long_add(delta, &nr_swap_pages);
+		total_swap_pages += delta;
+		spin_unlock(&swap_lock);
+	}
+
+	/* Lowering the ceiling may free tail clusters. */
+	xswap_try_shrink(si);
+
+	return count;
+}
+
+static const struct file_operations xswap_debugfs_fops = {
+	.read = xswap_max_clusters_read,
+	.write = xswap_max_clusters_write,
+	.open = simple_open,
+	.llseek = default_llseek,
+};
+
+static void xswap_debugfs_add(struct swap_info_struct *si)
+{
+	char name[32];
+
+	if (!xswap_debugfs_root)
+		return;
+
+	snprintf(name, sizeof(name), "type%d_cluster_limit", si->type);
+	si->debugfs_entry = debugfs_create_file(name, 0644, xswap_debugfs_root,
+						si, &xswap_debugfs_fops);
+}
+
+static void xswap_debugfs_del(struct swap_info_struct *si)
+{
+	debugfs_remove(si->debugfs_entry);
+	si->debugfs_entry = NULL;
+}
+
 #ifdef CONFIG_SYSFS
 static int xswap_create(int percent);
 /* /sys/kernel/mm/xswap/: create.
@@ -156,7 +238,6 @@ static void move_cluster(struct swap_info_struct *si,
  *
  * Also protects swap_active_head total_swap_pages, and the SWP_WRITEOK flag.
  */
-static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
 atomic_long_t nr_swap_pages;
 atomic_t nr_real_swapfiles;
@@ -3223,6 +3304,7 @@ static void free_swap_cluster_info(struct swap_info_struct *si)
 
 #ifdef CONFIG_XSWAP
 	if (si->flags & SWP_XSWAP) {
+		xswap_debugfs_del(si);
 		/* Unmap all mapped clusters and free the VM_SPARSE area */
 		if (si->nr_clusters_mapped > 0)
 			xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
@@ -4109,6 +4191,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 		/* All mapped clusters except cluster 0 are free at the tail */
 		si->nr_free_tail = si->nr_clusters_mapped - 1;
 		mutex_init(&si->xswap_lock);
+		xswap_debugfs_add(si);
 		return 0;
 
 err_unmap:
@@ -4236,8 +4319,8 @@ static int xswap_create(int percent)
 	/* VM_SPARSE covers full RAM; runtime nr_clusters starts at percent. */
 	init_clusters = div_u64((u64)maxpages * percent, 100 * SWAPFILE_CLUSTER);
 	init_clusters = max_t(unsigned long, init_clusters, XSWAP_GROW_CLUSTERS);
-	if (init_clusters > si->nr_clusters)
-		init_clusters = si->nr_clusters;
+	if (init_clusters > si->nr_clusters_max)
+		init_clusters = si->nr_clusters_max;
 	si->nr_clusters = init_clusters;
 	si->pages = min_t(unsigned long, init_clusters * SWAPFILE_CLUSTER, si->max) - 1;
 
@@ -4615,6 +4698,7 @@ static int __init swapfile_init(void)
 		swap_migration_ad_supported = true;
 #endif	/* CONFIG_MIGRATION */
 
+	xswap_debugfs_root = debugfs_create_dir("xswap", NULL);
 	xswap_sysfs_init();
 
 	return 0;
-- 
2.54.0



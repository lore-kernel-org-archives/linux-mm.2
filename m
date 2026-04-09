Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0913AE98FC2
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 06:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09ADB6B0005; Thu,  9 Apr 2026 02:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 073266B0088; Thu,  9 Apr 2026 02:35:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA3BF6B008A; Thu,  9 Apr 2026 02:35:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CDB3C6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 02:35:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6DA281B7D64
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:35:20 +0000 (UTC)
X-FDA: 84638055600.19.3A63435
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3DB9C1C0011
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:35:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=G80myHrO;
	spf=pass (imf21.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775716518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZFbKr3GihCzBaaD2zmtBk3F7w+WgxVILHWEfG/UdJ5U=;
	b=esjQAxnnG5QO08NEU2OTdO4Fi3CDB1nPk5bOryeDbYL7r4yWDDafKlERvJOygkU2DlLoFS
	07yQs4XtFK7Hw/1xeHUEoswCLyRqJXjv773ej4v+ciwW18BLqmtBXzn3jy43UOhqJZAQ0i
	8AfN2cEVzLuhTLXeAXOfMVOVoWwejNg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=G80myHrO;
	spf=pass (imf21.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775716518; a=rsa-sha256;
	cv=none;
	b=BMMwqrhcrOpzkEDEoQhgU1g+JpPyeCtkV5jRw3TYdo7hvGhssZyIUJ2kbSVmJLMdXGLCDj
	A858UQKWPGJQNRm8Eb8FVvF1/31vAKtjfcrNQTkH4rav3IHvJNy4swLVN4C7cH/W0yzm4X
	F60TXPZ6+0Y7FGrUJVbZXmwoUJv/c3c=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ZFbKr3GihCzBaaD2zmtBk3F7w+WgxVILHWEfG/UdJ5U=;
	b=G80myHrOB8TAkyrs2WEW+wqLv/MDu3xv6lEG/NGNxCeMSRY232mX1Hw0aYmWXj2ul6KPb2UGv
	EIdFT2ic5fatDl+xuVscEeVyYUFnGveGdYEq03bN1DIg8/pvPfUBhkXBhRX3k0nklKK+6C0Wj+N
	05RkbEqE6Gp3yxGa+PA/Ga0=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4frqlG04N0z1cyPV;
	Thu,  9 Apr 2026 14:28:58 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id CF23F4048B;
	Thu,  9 Apr 2026 14:35:11 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 9 Apr 2026 14:35:10 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Christian Brauner <brauner@kernel.org>, Alexander Viro
	<viro@zeniv.linux.org.uk>
CC: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes
	<ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka
	<vbabka@kernel.org>, <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH RFC] fs: drop_caches: introduce per-node drop_caches interface
Date: Thu, 9 Apr 2026 14:35:03 +0800
Message-ID: <20260409063503.3475420-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Stat-Signature: uffhbpxuk56rrrgkuqgcz8zu7omnyoee
X-Rspamd-Queue-Id: 3DB9C1C0011
X-Rspamd-Server: rspam09
X-HE-Tag: 1775716516-642708
X-HE-Meta: U2FsdGVkX194miEC4QxB1CwWYShSXIxaQ1XbUDiyFQ672m3YwEMMXTXsY9r1FJcuIVr64pzojxhozoy+YrJmf7DnQOiV7OtSLbcNLppNXufWz9mfWkJzxdvWTrKH04btut2/V8UTjDEHwSiP0DfjRhmrHIlXyRN51AxSkAd63QJglr8itJtqGRWNdq932xX4bDP6b4Jj7nYXcEwhKb72oFYO4XjnCNUaJqvLgIAZlLtSu9X4hwAWqMa3nQ0Y/LrcnbW7Goojm711p6fqYOeOibX9RbMmrgcsaiQzan5IVGGHrPmCwn1cK1Z4ed4ba26uhlhUK6w9r6b4wNoHkJJisWLUwZ03XpRvmBYv/wvK2nMIstxbqKzTmhqx66S9Gwiry88QesLMGh4JZCAEfXh2KErH2kyu0Q5S7U0DkTC/qaiQ0n4LPQtDOaBX8kFw92AE8Vhw+jmdZpJ3X+dqRjQ0G6fazjcFAMbQYiZ3N+KZ81cyhijJGJevwwTcofi5U70UUJhl6hfiuVc2H9EJR50IuY/HAqzqCyVyZp7Zs8xRGu+sh9nu7giOPnlqh18KUVBJ40PoIdq+F91PSU4TOCnkaIUpeSc1F7K7FO78wKoPc6PzKY+kSMV7nC4u8lAFHiHrp1MKUk9g1LLbwrEg0jFvj844gxSk7ixnDX/itzurRKooIENpVtbK1FC73qC1rGpwsbaI5ue4mP5d26tg/WIcvIvuOAw/d+LYT4tBxZtZex+oPlZjziXLhdhA+qQLDgPIkqr8fTG4XCaiNKfYkicnr06FHxaH1QfFZVHgrimJMRgclWwQ8IDZuNPkV4Xr8ecM2Waxoqv7hqaJZvQybf77SuS887L+C1zYEGONi/7kEKrYkyK/Ooifbgy+K08ErB/y2dLaHWb+8X39wtysBRk0AGOZR8oGMnfXtgmfsZM42BwmEOAKifsBMOSu1EZl5fM16zZ/byx1axsNgH1kxCr
 hTX/006w
 72CSMRjwtwz7Q/aM2dxqYV5/NiTqApj7s2Za2MdYV9PVwSA3n1DbXWgBSyMHVa256PJ44vSjY2Xmqujp/Erk+UTWFwUkMazmLMWXfLML690+fbGD0HJfh6AB/Z5PqDFpWcWxDzAssO+SGDVCXcMOXoJKPIMNzFDsMS8cRzJLnoWCO+yDM2QdFJuGozDZX6MMdynFVEyB9CYhVWPtY/t7LWvppcjaWE80RL5e2NV7kR0xr5SPRzxsSWJHyeW9vEBENjAEleZFU2mecwuH2T90xLVd9gGNozq5tWWlShT1DMMDvJ/XVTOc60jWK8sUyn8aAm5sH6w1NOnx1MKVelnnjvVJYOg3Da3vtIkoerThpqIDIHleDPp6chYH/ARnErGS2alVJJXvVNGEq0kk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a sysfs interface at /sys/devices/system/node/nodeX/drop_caches
to allow dropping caches on a specific NUMA node.

The existing global drop_caches mechanism (/proc/sys/vm/drop_caches)
operates across all NUMA nodes indiscriminately, causing,
- Unnecessary eviction of hot cache on some nodes
- Performance degradation for applications with NUMA affinity
- Long times spent on large systems with lots of memory

By exposing a per-node interface, admistrator can,
- Target specific nodes experiencing memory pressure
- Preserve cache on unaffected nodes
- Perform reclamation with finer granularity

One use cases is hot-pluggable NUMA nodes, during hot-remove, simply
dropping pagecache is far more efficient than migrating large amounts
of pages to other nodes, which also eliminating the risk of accessing
potentially faulty memory.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 Documentation/ABI/stable/sysfs-devices-node |  10 ++
 drivers/base/node.c                         |   2 +
 fs/drop_caches.c                            | 101 ++++++++++++++++----
 include/linux/fs.h                          |   9 ++
 include/linux/mm.h                          |   2 +-
 include/linux/pagemap.h                     |   2 +
 mm/fadvise.c                                |   2 +-
 mm/filemap.c                                |  12 ++-
 mm/internal.h                               |  16 +++-
 mm/truncate.c                               |  17 +++-
 mm/vmscan.c                                 |  11 ++-
 11 files changed, 145 insertions(+), 39 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-devices-node b/Documentation/ABI/stable/sysfs-devices-node
index 2d0e023f22a7..ec282291337a 100644
--- a/Documentation/ABI/stable/sysfs-devices-node
+++ b/Documentation/ABI/stable/sysfs-devices-node
@@ -236,3 +236,13 @@ Description:
 		This interface is equivalent to the memcg variant.
 
 		See Documentation/admin-guide/cgroup-v2.rst
+
+What:		/sys/devices/system/node/nodeX/drop_caches
+Date:		Mar 2026
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		Drop clean page cache and/or reclaimable slab objects (dentries
+		and inodes) on a specific NUMA node. This is the per-node
+		equivalent of /proc/sys/vm/drop_caches
+
+		See Documentation/admin-guide/sysctl/vm.rst:drop_caches
diff --git a/drivers/base/node.c b/drivers/base/node.c
index d7647d077b66..878c2cdef2e1 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -896,6 +896,7 @@ int register_node(int nid)
 	hugetlb_register_node(node);
 	compaction_register_node(node);
 	reclaim_register_node(node);
+	drop_caches_register_node(node);
 
 	/* link cpu under this node */
 	for_each_present_cpu(cpu) {
@@ -924,6 +925,7 @@ void unregister_node(int nid)
 	hugetlb_unregister_node(node);
 	compaction_unregister_node(node);
 	reclaim_unregister_node(node);
+	drop_caches_unregister_node(node);
 	node_remove_accesses(node);
 	node_remove_caches(node);
 	device_unregister(&node->dev);
diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index 49f56a598ecb..af88b24cb94f 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -16,9 +16,10 @@
 /* A global variable is a bit ugly, but it keeps the code simple */
 static int sysctl_drop_caches;
 
-static void drop_pagecache_sb(struct super_block *sb, void *unused)
+static void drop_pagecache_sb(struct super_block *sb, void *node)
 {
 	struct inode *inode, *toput_inode = NULL;
+	int nid = *(int *)node;
 
 	spin_lock(&sb->s_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
@@ -37,7 +38,7 @@ static void drop_pagecache_sb(struct super_block *sb, void *unused)
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb->s_inode_list_lock);
 
-		invalidate_mapping_pages(inode->i_mapping, 0, -1);
+		invalidate_node_mapping_pages(inode->i_mapping, 0, -1, nid);
 		iput(toput_inode);
 		toput_inode = inode;
 
@@ -48,6 +49,47 @@ static void drop_pagecache_sb(struct super_block *sb, void *unused)
 	iput(toput_inode);
 }
 
+static unsigned long has_caches(int nid)
+{
+	unsigned long nr;
+
+	if (nid >= 0)
+		nr = node_page_state(NODE_DATA(nid), NR_FILE_PAGES);
+	else
+		nr = global_node_page_state(NR_FILE_PAGES);
+
+	return nr;
+}
+
+static void drop_caches_handler(int flags, int nid)
+{
+	static int stfu;
+
+	if (flags & 1) {
+		if (!has_caches(nid))
+			return;
+
+		lru_add_drain_all();
+		iterate_supers(drop_pagecache_sb, &nid);
+		count_vm_event(DROP_PAGECACHE);
+	}
+
+	if (flags & 2) {
+		drop_slab(nid);
+		count_vm_event(DROP_SLAB);
+	}
+
+	if (!stfu) {
+		if (nid >= 0)
+			pr_info("%s (%d): drop_caches: %d on node %d\n",
+				current->comm, task_pid_nr(current), flags, nid);
+		else
+			pr_info("%s (%d): drop_caches: %d\n",
+				current->comm, task_pid_nr(current), flags);
+	}
+	stfu |= flags & 4;
+}
+
 static int drop_caches_sysctl_handler(const struct ctl_table *table, int write,
 		void *buffer, size_t *length, loff_t *ppos)
 {
@@ -56,25 +98,8 @@ static int drop_caches_sysctl_handler(const struct ctl_table *table, int write,
 	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
 	if (ret)
 		return ret;
-	if (write) {
-		static int stfu;
-
-		if (sysctl_drop_caches & 1) {
-			lru_add_drain_all();
-			iterate_supers(drop_pagecache_sb, NULL);
-			count_vm_event(DROP_PAGECACHE);
-		}
-		if (sysctl_drop_caches & 2) {
-			drop_slab();
-			count_vm_event(DROP_SLAB);
-		}
-		if (!stfu) {
-			pr_info("%s (%d): drop_caches: %d\n",
-				current->comm, task_pid_nr(current),
-				sysctl_drop_caches);
-		}
-		stfu |= sysctl_drop_caches & 4;
-	}
+	if (write)
+		drop_caches_handler(sysctl_drop_caches, NUMA_NO_NODE);
 	return 0;
 }
 
@@ -96,3 +121,37 @@ static int __init init_vm_drop_caches_sysctls(void)
 	return 0;
 }
 fs_initcall(init_vm_drop_caches_sysctls);
+
+#ifdef CONFIG_NUMA
+/* The range of input is same as sysctl_drop_caches */
+#define INPUT_MIN 1
+#define INPUT_MAX 4
+static ssize_t drop_caches_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	int nid = dev->id;
+	int input;
+
+	if (kstrtoint(buf, 0, &input))
+		return -EINVAL;
+
+	if (input > INPUT_MAX || input < INPUT_MIN)
+		return -EINVAL;
+
+	if (nid >= 0 && nid < nr_node_ids && node_online(nid))
+		drop_caches_handler(input, nid);
+
+	return count;
+}
+
+static DEVICE_ATTR_WO(drop_caches);
+int drop_caches_register_node(struct node *node)
+{
+	return device_create_file(&node->dev, &dev_attr_drop_caches);
+}
+
+void drop_caches_unregister_node(struct node *node)
+{
+	device_remove_file(&node->dev, &dev_attr_drop_caches);
+}
+#endif
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e1d257e6da68..31d8b9b20425 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -72,6 +72,7 @@ struct fs_parameter_spec;
 struct file_kattr;
 struct iomap_ops;
 struct delegated_inode;
+struct node;
 
 extern void __init inode_init(void);
 extern void __init inode_init_early(void);
@@ -3664,4 +3665,12 @@ static inline bool extensible_ioctl_valid(unsigned int cmd_a,
 	return true;
 }
 
+#if defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
+int drop_caches_register_node(struct node *node);
+void drop_caches_unregister_node(struct node *node);
+#else
+static inline int drop_caches_register_node(struct node *node) { return 0; }
+static inline void drop_caches_unregister_node(struct node *node) {}
+#endif /* CONFIG_SYSFS && CONFIG_NUMA */
+
 #endif /* _LINUX_FS_H */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0b776907152e..f252564841b9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4838,7 +4838,7 @@ static inline int in_gate_area(struct mm_struct *mm, unsigned long addr)
 
 bool process_shares_mm(const struct task_struct *p, const struct mm_struct *mm);
 
-void drop_slab(void);
+void drop_slab(int nid);
 
 #ifndef CONFIG_MMU
 #define randomize_va_space 0
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 31a848485ad9..3e1c5b8b5c69 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -20,6 +20,8 @@ struct folio_batch;
 
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
 					pgoff_t start, pgoff_t end);
+unsigned long invalidate_node_mapping_pages(struct address_space *mapping,
+					pgoff_t start, pgoff_t end, int nid);
 
 static inline void invalidate_remote_inode(struct inode *inode)
 {
diff --git a/mm/fadvise.c b/mm/fadvise.c
index b63fe21416ff..60307c505278 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -155,7 +155,7 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 			lru_add_drain();
 
 			mapping_try_invalidate(mapping, start_index, end_index,
-					&nr_failed);
+					       NUMA_NO_NODE, &nr_failed);
 
 			/*
 			 * The failures may be due to the folio being
diff --git a/mm/filemap.c b/mm/filemap.c
index c568d9058ff8..f962f980ef55 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2142,10 +2142,11 @@ unsigned find_get_entries(struct address_space *mapping, pgoff_t *start,
 }
 
 /**
- * find_lock_entries - Find a batch of pagecache entries.
+ * __find_lock_entries - Find a batch of pagecache entries from a specific node
  * @mapping:	The address_space to search.
  * @start:	The starting page cache index.
  * @end:	The final page index (inclusive).
+ * @nid		NUMA node ID to filter entries.
  * @fbatch:	Where the resulting entries are placed.
  * @indices:	The cache indices of the entries in @fbatch.
  *
@@ -2153,7 +2154,8 @@ unsigned find_get_entries(struct address_space *mapping, pgoff_t *start,
  * Swap, shadow and DAX entries are included.  Folios are returned
  * locked and with an incremented refcount.  Folios which are locked
  * by somebody else or under writeback are skipped.  Folios which are
- * partially outside the range are not returned.
+ * partially outside the range are not returned. Only entries belonging
+ * to nid will be returned, pass NUMA_NO_NODE to search all nodes.
  *
  * The entries have ascending indexes.  The indices may not be consecutive
  * due to not-present entries, large folios, folios which could not be
@@ -2161,8 +2163,8 @@ unsigned find_get_entries(struct address_space *mapping, pgoff_t *start,
  *
  * Return: The number of entries which were found.
  */
-unsigned find_lock_entries(struct address_space *mapping, pgoff_t *start,
-		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices)
+unsigned int __find_lock_entries(struct address_space *mapping, pgoff_t *start,
+		pgoff_t end, int nid, struct folio_batch *fbatch, pgoff_t *indices)
 {
 	XA_STATE(xas, &mapping->i_pages, *start);
 	struct folio *folio;
@@ -2181,6 +2183,8 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t *start,
 			/* Omit large folio which extends beyond the end */
 			if (base + nr - 1 > end)
 				goto put;
+			if (nid >= 0 && folio_nid(folio) != nid)
+				goto put;
 			if (!folio_trylock(folio))
 				goto put;
 			if (folio->mapping != mapping ||
diff --git a/mm/internal.h b/mm/internal.h
index 41398ecb2201..3bb88b0017f8 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -553,8 +553,18 @@ static inline void force_page_cache_readahead(struct address_space *mapping,
 	force_page_cache_ra(&ractl, nr_to_read);
 }
 
-unsigned find_lock_entries(struct address_space *mapping, pgoff_t *start,
-		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
+unsigned int __find_lock_entries(struct address_space *mapping, pgoff_t *start,
+		pgoff_t end, int nid, struct folio_batch *fbatch,
+		pgoff_t *indices);
+
+static inline unsigned int find_lock_entries(struct address_space *mapping,
+		pgoff_t *start, pgoff_t end, struct folio_batch *fbatch,
+		pgoff_t *indices)
+{
+	return __find_lock_entries(mapping, start, end, NUMA_NO_NODE, fbatch,
+				   indices);
+}
+
 unsigned find_get_entries(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
 void filemap_free_folio(struct address_space *mapping, struct folio *folio);
@@ -563,7 +573,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start,
 		loff_t end);
 long mapping_evict_folio(struct address_space *mapping, struct folio *folio);
 unsigned long mapping_try_invalidate(struct address_space *mapping,
-		pgoff_t start, pgoff_t end, unsigned long *nr_failed);
+		pgoff_t start, pgoff_t end, int nid, unsigned long *nr_failed);
 
 /**
  * folio_evictable - Test whether a folio is evictable.
diff --git a/mm/truncate.c b/mm/truncate.c
index 2931d66c16d0..09cc50083ac8 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -522,17 +522,19 @@ void truncate_inode_pages_final(struct address_space *mapping)
 EXPORT_SYMBOL(truncate_inode_pages_final);
 
 /**
- * mapping_try_invalidate - Invalidate all the evictable folios of one inode
+ * mapping_try_invalidate - Invalidate all the evictable folios from a
+ *                          specific NUMA node of one inode
  * @mapping: the address_space which holds the folios to invalidate
  * @start: the offset 'from' which to invalidate
  * @end: the offset 'to' which to invalidate (inclusive)
+ * @nid: the NUMA node id to invalidate from, or NUMA_NO_NODE for all nodes
  * @nr_failed: How many folio invalidations failed
  *
  * This function is similar to invalidate_mapping_pages(), except that it
  * returns the number of folios which could not be evicted in @nr_failed.
  */
 unsigned long mapping_try_invalidate(struct address_space *mapping,
-		pgoff_t start, pgoff_t end, unsigned long *nr_failed)
+		pgoff_t start, pgoff_t end, int nid, unsigned long *nr_failed)
 {
 	pgoff_t indices[FOLIO_BATCH_SIZE];
 	struct folio_batch fbatch;
@@ -542,7 +544,7 @@ unsigned long mapping_try_invalidate(struct address_space *mapping,
 	int i;
 
 	folio_batch_init(&fbatch);
-	while (find_lock_entries(mapping, &index, end, &fbatch, indices)) {
+	while (__find_lock_entries(mapping, &index, end, nid, &fbatch, indices)) {
 		bool xa_has_values = false;
 		int nr = folio_batch_count(&fbatch);
 
@@ -599,10 +601,17 @@ unsigned long mapping_try_invalidate(struct address_space *mapping,
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
 		pgoff_t start, pgoff_t end)
 {
-	return mapping_try_invalidate(mapping, start, end, NULL);
+	return mapping_try_invalidate(mapping, start, end, NUMA_NO_NODE, NULL);
 }
 EXPORT_SYMBOL(invalidate_mapping_pages);
 
+unsigned long invalidate_node_mapping_pages(struct address_space *mapping,
+		pgoff_t start, pgoff_t end, int nid)
+{
+	return mapping_try_invalidate(mapping, start, end, nid, NULL);
+}
+EXPORT_SYMBOL(invalidate_node_mapping_pages);
+
 static int folio_launder(struct address_space *mapping, struct folio *folio)
 {
 	if (!folio_test_dirty(folio))
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5a8c8fcccbfc..84eba9ab5d25 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -418,19 +418,20 @@ static unsigned long drop_slab_node(int nid)
 	return freed;
 }
 
-void drop_slab(void)
+void drop_slab(int nid)
 {
-	int nid;
-	int shift = 0;
+	int i, shift = 0;
 	unsigned long freed;
+	nodemask_t n_mask;
 
+	n_mask = nid >= 0 ? nodemask_of_node(nid) : node_online_map;
 	do {
 		freed = 0;
-		for_each_online_node(nid) {
+		for_each_node_mask(i, n_mask) {
 			if (fatal_signal_pending(current))
 				return;
 
-			freed += drop_slab_node(nid);
+			freed += drop_slab_node(i);
 		}
 	} while ((freed >> shift++) > 1);
 }
-- 
2.27.0



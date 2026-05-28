Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F09F0CD5BC9
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 00:42:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDCD76B00A6; Wed, 27 May 2026 20:42:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D659F6B00A7; Wed, 27 May 2026 20:42:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B90CF6B00A8; Wed, 27 May 2026 20:42:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4FB56B00A6
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:42:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 67ED414067F
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:36 +0000 (UTC)
X-FDA: 84814977912.19.2FC778E
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf31.hostedemail.com (Postfix) with ESMTP id B9B7F20008
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:34 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=bds+T53Y;
	spf=pass (imf31.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779928954; a=rsa-sha256;
	cv=none;
	b=AAuDqY758wDCh1b4JEjrzHibAVmWSnOhK5BaVkk+KDU5E9eclmz5B2rKa1N6GcHoL8rwO6
	gt7UPgVFxmugg8CmpxMqAYRjYBmQ6KbbyM8GxoZnbqMw9bqFWdOdyi43sExDIL2cqxIBSt
	hgHaaynrE1ZIsuDm0wLeN45rgZvlWCI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=bds+T53Y;
	spf=pass (imf31.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779928954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lTYSobW1vcaiuFaW/ih0lOZTdJfa7tMYIcB/6JUObEE=;
	b=qAzgHhQY0GDdrWrv2UxCXC/oftqUkX7VyW+wSYRzlA9jtD0AV8C0Oa8qyVIDE7F2PEKeNO
	aoxliWJ+reObAYEFzmhH3nM+dSWy/BT/hblD8ocZQm499nmm62UdZg0J8zmzzqNrDx3oXS
	zt60PIs2QXvynAlyId757GtZrqGlWzg=
Received: by linux.microsoft.com (Postfix, from userid 1241)
	id EC17820B717A; Wed, 27 May 2026 17:42:23 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EC17820B717A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1779928943;
	bh=lTYSobW1vcaiuFaW/ih0lOZTdJfa7tMYIcB/6JUObEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bds+T53YSwua67KRic1D3xTDVI8g2FG5kFyh9yUH+NKfBwH0s5MxGdFticf7R97vc
	 C6Xh5MCYze42oBrgNFWnDpyid/h5MQYDeNPF/7cyO0UVqYZALjK7f4naGCfMw8KflQ
	 CRrvEG5Kw9ij3UM6KLbWJBmrvJ8vse+aL8vwqdDw=
From: Jork Loeser <jloeser@linux.microsoft.com>
To: linux-hyperv@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Jason Miu <jasonmiu@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Baoquan He <bhe@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Kees Cook <kees@kernel.org>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	Justinien Bouron <jbouron@amazon.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Pingfan Liu <piliu@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Kelley <mhklinux@outlook.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Subject: [RFC PATCH 16/20] mshv: Add debugfs interface to page tracker
Date: Wed, 27 May 2026 17:41:58 -0700
Message-ID: <20260528004204.1484584-17-jloeser@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
References: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B9B7F20008
X-Stat-Signature: pmq6nf8zegib8ifpy51tucmfjnnrpq9u
X-HE-Tag: 1779928954-677775
X-HE-Meta: U2FsdGVkX19s1DksDe8/cnCTKoBMYw4M8TGb/laxLUpxOgsqaNWbyJcBn+3UXZvmXPm1cUEZyNnh6eSd+q7MXWtLRTMK5dl90qjz62ao+PN/JFJX7jV/MoIb5YyAnaKGOAWMiCC6FApTLElOZcxE38X5hV5QwR252yr2lLmlfOUppSo2e6Vok3yN2VE5Iw6NubAPkQdtwLM8rRkb3rYONw4ur8y3CxI9EhrQt4JGlONvou/TORFszH1LHKz95WkIhviMCku+MV3ty6V2mWcskos9MO9dQ/A7gnFlt5MaZLxD3dRVE0cIlXpbBE65BwwqlANw7h2rwkp06+opvvoCsJb53Rf1f9YTPDldC5ABhcpdEV8ARjMc3woYseH7DFw9HkvjK/vStx3KoretX0v53PLalZvbqVgoZe82o5oPaTG7+ucAsEJmSeqNtCiLQx25k5myU5TNo+yBtJIuFHQUR3SSkPqOCxdzMPpJtqqnaR27geYcmNVNuX9XrUtJmxuhKjcxDxBdzr41UKD3v7FNsHzaGBMALYsa/3zEVNpUeMrc+yckcqv5Nwu7Ixa2sCpdeAbHtn8EyBkuIImVNsyqeBrcSo3r3kJlaV24yDPvsZzuT9+52ts9WFfqCse4dZ33189Vzz3hI9eY8batU4rS7q2CER/z8F+nDCCQ+jvSU5udTtOLTPuQmBfP72kO9tCWvF8L+qZKqYI8nI2ewNVDUI+jcWwG7+ox2Kgvx0FsL3IOazMp6v5O5bxYmhufE8OyFZiavSLB6+JCkOSXWZavMl/ocfcyf1CsxIsu3ffPLLPpkUKaJU8U5m+C1226KOg9qRrE3Xlyl/4XIynePx+WwZFwpyT5SadbTAqwGJdG6t0RnYDKuytvIV4dStJzlc+/w4k73++1G6yZr87KyQ2kO93u/9oLzQ+mXIBF6Qpx65ytiq6W+aNJLVttofG9kUtwylO2PhFllZbDKv7ZZen
 WxKFS0C6
 rjkMlAqYXwCwI1EoUx5aWZ7y8SbiTucHSp9ci7cCSUJsY7dGxTC8EiYtcPuyj0Oc2ViBdU26HO2j1CXMHU/Bjikrek5IADXBT5OMRqUoywAjJr982Aqu1lPfoX+OUMX3v6R9fNxu5cUuKenQcjZPn/Y8jLWz+bDr62UdKyHNCtK3beT5qGpJy5JfAGuTWtgArvJAw7K4YrWpQkPJ0UTBRJk5We+t0YjKBVDl0X/1reHZ1OpnNNJt4ML8+ayWxHRbt5Rae
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

- expose stats (page-counts for data & metadata)
- expose tracked pages
- expose scheduler type
- add mshv_iterate_preserved() API for walking the radix tree

Signed-off-by: Jork Loeser <jloeser@linux.microsoft.com>
---
 drivers/hv/mshv_debugfs.c       | 99 +++++++++++++++++++++++++++++++++
 drivers/hv/mshv_page_preserve.c | 13 +++++
 drivers/hv/mshv_page_preserve.h |  3 +
 drivers/hv/mshv_root.h          |  2 +
 drivers/hv/mshv_root_main.c     |  2 +-
 5 files changed, 118 insertions(+), 1 deletion(-)

diff --git a/drivers/hv/mshv_debugfs.c b/drivers/hv/mshv_debugfs.c
index 3c3e02237ae9..d79898e21b36 100644
--- a/drivers/hv/mshv_debugfs.c
+++ b/drivers/hv/mshv_debugfs.c
@@ -33,11 +33,18 @@ static struct dentry *mshv_debugfs;
 static struct dentry *mshv_debugfs_partition;
 static struct dentry *mshv_debugfs_lp;
 static struct dentry **parent_vp_stats;
+
 static struct dentry *parent_partition_stats;
 
 static u64 mshv_lps_count;
 static struct hv_stats_page **mshv_lps_stats;
 
+struct mshv_pt_stats {
+	unsigned long count_data;
+	unsigned long count_meta;
+	struct seq_file *stat_file;
+};
+
 static int lp_stats_show(struct seq_file *m, void *v)
 {
 	const struct hv_stats_page *stats = m->private;
@@ -668,8 +675,89 @@ void mshv_debugfs_partition_remove(struct mshv_partition *partition)
 				 partition->pt_stats_dentry);
 }
 
+static int pt_count_data_cb(unsigned long key __maybe_unused, void *stats)
+{
+	((struct mshv_pt_stats *)stats)->count_data++;
+	return 0;
+}
+
+static int pt_count_meta_cb(phys_addr_t phys __maybe_unused, void *stats)
+{
+	((struct mshv_pt_stats *)stats)->count_meta++;
+	return 0;
+}
+
+static int pt_stats_show(struct seq_file *m, void *v)
+{
+	const struct kho_radix_walk_cb cb = {
+		.key = pt_count_data_cb,
+		.table = pt_count_meta_cb,
+	};
+
+	struct mshv_pt_stats pt_stats = {0};
+
+	mshv_iterate_preserved(&cb, &pt_stats);
+	seq_printf(m, "Data pages: %lu\n", pt_stats.count_data);
+	seq_printf(m, "Meta pages: %lu\n", pt_stats.count_meta);
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(pt_stats);
+
+static int pt_tree_data_cb(unsigned long key, void *stats)
+{
+	seq_printf(((struct mshv_pt_stats *)stats)->stat_file,
+		   "data pfn: %#lx\n", key);
+	return 0;
+}
+
+static int pt_tree_meta_cb(phys_addr_t phys, void *stats)
+{
+	seq_printf(((struct mshv_pt_stats *)stats)->stat_file,
+		   "meta pfn: %#llx\n",
+		   (unsigned long long)(phys >> PAGE_SHIFT));
+	return 0;
+}
+
+static int pt_tree_show(struct seq_file *m, void *v)
+{
+	const struct kho_radix_walk_cb cb = {
+		.key = pt_tree_data_cb,
+		.table = pt_tree_meta_cb,
+	};
+
+	struct mshv_pt_stats pt_stats = {.stat_file = m};
+
+	mshv_iterate_preserved(&cb, &pt_stats);
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(pt_tree);
+
+static int __init mshv_debugfs_pt_create(struct dentry *parent)
+{
+	struct dentry *d;
+
+	d = debugfs_create_file("pt_stats", 0400, parent, NULL, &pt_stats_fops);
+	if (IS_ERR(d))
+		return PTR_ERR(d);
+
+	d = debugfs_create_file("pt_tree", 0400, parent, NULL, &pt_tree_fops);
+	if (IS_ERR(d))
+		return PTR_ERR(d);
+
+	return 0;
+}
+
+static int scheduler_info_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "Scheduler type: %s (%d)\n",
+		   scheduler_type_to_string(hv_scheduler_type), hv_scheduler_type);
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(scheduler_info);
+
 int __init mshv_debugfs_init(void)
 {
+	struct dentry *d;
 	int err;
 
 	mshv_debugfs = debugfs_create_dir("mshv", NULL);
@@ -694,6 +782,17 @@ int __init mshv_debugfs_init(void)
 	if (err)
 		goto unmap_lp_stats;
 
+	err = mshv_debugfs_pt_create(mshv_debugfs);
+	if (err)
+		goto unmap_lp_stats;
+
+	d = debugfs_create_file("scheduler_info", 0400, mshv_debugfs, NULL,
+				&scheduler_info_fops);
+	if (IS_ERR(d)) {
+		err = PTR_ERR(d);
+		goto unmap_lp_stats;
+	}
+
 	return 0;
 
 unmap_lp_stats:
diff --git a/drivers/hv/mshv_page_preserve.c b/drivers/hv/mshv_page_preserve.c
index a79725a74663..bc3a3a688f5b 100644
--- a/drivers/hv/mshv_page_preserve.c
+++ b/drivers/hv/mshv_page_preserve.c
@@ -52,6 +52,19 @@ int mshv_unregister_preserve_page(struct page *pg)
 }
 EXPORT_SYMBOL_GPL(mshv_unregister_preserve_page);
 
+/**
+ * mshv_iterate_preserved() - Walk all preserved pages
+ * @cb: callbacks invoked for each key/table entry
+ * @data: opaque data passed to callbacks
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int mshv_iterate_preserved(const struct kho_radix_walk_cb *cb, void *data)
+{
+	return kho_radix_walk_tree(&preserved_pages_tree, cb, data);
+}
+EXPORT_SYMBOL_GPL(mshv_iterate_preserved);
+
 /* Preserve a single page identified by its PFN key with KHO */
 static int preserve_key_cb(unsigned long key, void *data)
 {
diff --git a/drivers/hv/mshv_page_preserve.h b/drivers/hv/mshv_page_preserve.h
index 0609002e5f1d..ac99b4e33285 100644
--- a/drivers/hv/mshv_page_preserve.h
+++ b/drivers/hv/mshv_page_preserve.h
@@ -6,10 +6,13 @@
 #ifndef _MSHV_PAGE_PRESERVE_H
 #define _MSHV_PAGE_PRESERVE_H
 
+#include <linux/kho_radix_tree.h>
+
 struct page;
 
 int mshv_preserve_init(void);
 int mshv_register_preserve_page(struct page *pg);
 int mshv_unregister_preserve_page(struct page *pg);
+int mshv_iterate_preserved(const struct kho_radix_walk_cb *cb, void *data);
 
 #endif /* _MSHV_PAGE_PRESERVE_H */
diff --git a/drivers/hv/mshv_root.h b/drivers/hv/mshv_root.h
index 362768786c17..216053f8e0ab 100644
--- a/drivers/hv/mshv_root.h
+++ b/drivers/hv/mshv_root.h
@@ -379,4 +379,6 @@ bool mshv_region_handle_gfn_fault(struct mshv_mem_region *region, u64 gfn);
 void mshv_region_movable_fini(struct mshv_mem_region *region);
 bool mshv_region_movable_init(struct mshv_mem_region *region);
 
+const char *scheduler_type_to_string(enum hv_scheduler_type type);
+
 #endif /* _MSHV_ROOT_H_ */
diff --git a/drivers/hv/mshv_root_main.c b/drivers/hv/mshv_root_main.c
index bd1359eb58dd..5fbd01c12ab8 100644
--- a/drivers/hv/mshv_root_main.c
+++ b/drivers/hv/mshv_root_main.c
@@ -2134,7 +2134,7 @@ mshv_dev_release(struct inode *inode, struct file *filp)
 
 static int mshv_root_sched_online;
 
-static const char *scheduler_type_to_string(enum hv_scheduler_type type)
+const char *scheduler_type_to_string(enum hv_scheduler_type type)
 {
 	switch (type) {
 	case HV_SCHEDULER_TYPE_LP:
-- 
2.43.0



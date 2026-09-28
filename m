Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 581CDC9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 02:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CECB6B0088; Sun, 27 Sep 2026 22:48:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A6F76B008A; Sun, 27 Sep 2026 22:48:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BBD66B008C; Sun, 27 Sep 2026 22:48:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 296396B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 22:48:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07C4DC0B04
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 02:48:03 +0000 (UTC)
X-FDA: 85261636446.06.08078BB
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7236A1C0003
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 02:48:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=l3T+cw5Z;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790563681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=c136CmkpMKWU27leu2r2jlfnyev322esjkQHfnDrcXE=;
	b=NpjMOpJWtQXXQaFjRZkW0vI7/a38zVNrRgq8nGsyWKPQPeivC/aiimF9ACYBPJ7m1oKUSy
	CItzUszq1dyEKGJL+gTqASdgd9xxnuWm5QYQSkQn4eap0m6+/XYGXhEqkHwcnr+iRw/34H
	tzlq+Z+xK2ZDcHmRxbTbGIU83HwHUNA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=l3T+cw5Z;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790563681;
	b=0Lq6WVIwlT33LdzYXYYvTGz2emVEW7J6nyEJlfPqOE+e5t0NG0sr+hdmSEWfJXgvoC7Ij9
	EVMKFd0PuO4powU5TkXoxqQ0+4ngmqpmex/r43uwYKtpdWZANwgoFRBPpAEUso6vIrsXA6
	rlQTVjOpwH9zjfkkoz6qxyI5F61+vzA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1790563671; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=c136CmkpMKWU27leu2r2jlfnyev322esjkQHfnDrcXE=;
 b=l3T+cw5ZpclThBxh3QFFvmpFZxTJFLGesK5EFVEk5MjxCR8KmC94rQ4eGmz08xz4u1qzy5
 n5wi3HtgXtvadwLlpJyEhIiiszISFtxmS2jmgyqYtlOXt3Ps64Qonsp4F89dYHiCclcWgg
 Lif+7ZwhPZlSTj9eHK0VK3twN6z0d2c7Hb1NcWG9Yj+M8M7ii2M22vjQaF+sVVN6kUWIqx
 g9vNAy+Q1xkuTCV7F0z2p/Z+KTm6B7/o3AZIGClZpMnlP/oOdRNp5DH2pA3cPmuxMIwiPT
 rgf8PbVxmO67DY77ZG2aPdzfbiB2H2/ZwtFeDq4IIQmxsw4cka9SFpuHu+xleQ==
To: <akpm@linux-foundation.org>, <david@kernel.org>, <muchun.song@linux.dev>, 
	<osalvador@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<aiqi.i7@bytedance.com>, <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Mon, 28 Sep 2026 10:47:23 +0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2
Content-Transfer-Encoding: 7bit
Message-Id: <20260928024723.87708-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Subject: [PATCH v4] mm/hugetlb: fix overbroad MMU notifiers for unshared PMDs
X-Lms-Return-Path: <lba+26ab9d555+d7d993+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Stat-Signature: soirfpocya6k6bowacropndhz591fdre
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7236A1C0003
X-HE-Tag: 1790563680-619045
X-HE-Meta: U2FsdGVkX1/aoo0THbL5G7NsUhqfZ0/OiXL4FXMG/Ym8NN1OiCQiWR/P0dQCNgXH4HpSCkg3ICeHBqVIYBVpF03sZBi7hxfWCaET31ICLHRcDspD+/UeBM81fDRYDQ643pAlER/j3nfJrwK6cjh+skNWl8dKPE2+lqDJ74X1xEODlPcgUT/kycGztXKPxNaRNDUm0tcIj8GEE/+j2HgnZXk1fZ/e4gVqaNqbULhj1fdjQN6l+mfMKXG0gANyem5eUlOOd0AWoOjPQdab3+UaQZILc/2FQYzuXLGeOLisYlMBcNMp3FoW9hNSdjiXp2SSZtjfQAvXzTHU5YDhkzyDMDSjhrRixnw/KJ7PB2WT1KG6Jf9lG+KjEvsg49cvOuGhDSdkMCJGt/urPCV+v5T2vDbNXnN4tKnKIUSJJ23LLVuIzSSQmDijIuumK/dCO5OFHppsEdsMPsVETDhw45ksCTyaze5HQs1HV2TG3NRvbtxllRxToevPlJ05JQXOCC8iDf6w7rGwbnfZwh7a5fXDRu3Q7SmyBVF62opHJj51RsBqgLgZ9hHhrvTGVKxbfd0PUFnzTxFugdVsEgKptYBcJzb3iFrfmSZGIJnCRpPbkGoIyG6HpDPde9gJqRwy7LNMt04K8w5l0IquuNQQH/e2r+pQnW0iUN+Inxl1cBXcbxvMwu2/oFnjZb3HX0DgLXavgNFQiWfTCOXYGEYyV6v0PAPr522UrcHfMSrpOCqZe064YIYcMmk7+FJ5JoH8euOxBlSsLQeI49PruKUXUSL7MVrmHuW/zqruils12UVzwN4AUB11XVSY7ZOyBZV8zr5zlGE74PT79VUbLUW3lQJVa/On2z3tatgLUi4o5RQ0QmXqoqNhLnOKRkqApBpz0SutIlcX2KW4kerX3T9T9kR52r80RRM2kQwX5/x2DTKUVinv3HayBrR3vpa8dkZ+3XK8vL1Za1kuF1857cbtnSX
 wH96WC3w
 tZS0nSRcMi0PDaol8S4/rBi5Ly/gXUAexFX1niZG8RqoIR49aEmwjqiFe4BbUYgB6GZDWVG5ILTeT9KcmUTlE/1IJYPWs5hS4cTftx5HQhfJZuLsq0nfXlyYtJBQzOdtWb7L/nX6WcycgU29wdFFK6MXE1LJZQXfM3b2ZEFB7ziQ3PREu34ejFKPc2cfrYHZMq5A/zUFOq+mjrixZynfL1JZ6jKtua4gdDbLUxmEcrGG8ZnAhVGngGlV8ekhmiXgDX+OU8L4qvFc4xyZWUtaSbcaxxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hugetlb currently expands MMU notifier ranges to PUD boundaries whenever
PMD sharing is possible. That is only needed when huge_pmd_unshare()
actually detaches a shared PMD page table, because clearing the PUD
invalidates the whole PUD-sized virtual address range.

For hugetlbfs hole punch, and similarly for other hugetlb unmap paths,
a shared mapping can pass the "PMD sharing is possible" range test in
adjust_range_if_pmd_sharing_possible() even when the hugetlbfs file does
not currently have any shared PMD page tables. KVM then receives a 1G
invalidation for a 2M operation and zaps unrelated secondary mappings,
so the guest has to fault them back in.

Avoid this by tracking active PMD-sharing attachments per hugetlbfs
inode. The count is incremented only after huge_pmd_share() successfully
installs a shared PMD table, and decremented when __huge_pmd_unshare()
actually detaches one. Since huge_pmd_share() can run concurrently under
i_mmap_lock_read(), use a 64-bit atomic counter. A zero count is used to
skip the conservative notifier range expansion only after excluding
concurrent PMD sharing with the mapping write lock.

On a Redis-in-VM workload that punches cold 2M hugetlb pages, this patch
improves P99 QPS stability while punching pages, reducing the QPS
degradation ratio from 7.09% to 1.45%.

Reported-by: aiqi.i7 <aiqi.i7@bytedance.com>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
v3: https://lore.kernel.org/all/20260924082004.82450-1-lizhe.67@bytedance.com/
v2: https://lore.kernel.org/all/20260922090749.24905-1-lizhe.67@bytedance.com/
v1: https://lore.kernel.org/all/20260831091023.66581-1-lizhe.67@bytedance.com/

Changelogs:
v3->v4:
- Use atomic64_t for the per-inode PMD-sharing attachment counter as
  suggested by Muchun, avoiding the 32-bit wrap-to-zero case.

v2->v3:
- Rework the sticky state based on Andrew's feedback: use a per-inode
  counter of active PMD-sharing attachments, so files can return to the
  no-active-sharing state after PMD sharing ends.

v1->v2:
- Rework the implementation based on David's suggestion: remember
  whether PMD sharing ever happened for a hugetlbfs file, and skip the
  conservative notifier range expansion while it has not. This avoids
  the per-unmap page-table walk.

 fs/hugetlbfs/inode.c    |  1 +
 include/linux/hugetlb.h | 37 +++++++++++++++++++++++++++++++++++++
 mm/hugetlb.c            | 13 ++++++++++---
 3 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 7611a8470ea26..78e27ce0a6f63 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -921,6 +921,7 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb,
 		simple_inode_init_ts(inode);
 		info->resv_map = resv_map;
 		info->seals = F_SEAL_SEAL;
+		hugetlbfs_pmd_sharing_init(inode);
 		switch (mode & S_IFMT) {
 		default:
 			init_special_inode(inode, mode, dev);
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 16c4c4caa126c..2a227bfbec1e5 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -12,6 +12,7 @@
 #include <linux/page_ref.h>
 #include <linux/list.h>
 #include <linux/kref.h>
+#include <linux/atomic.h>
 #include <linux/pgtable.h>
 #include <linux/gfp.h>
 #include <linux/userfaultfd_k.h>
@@ -509,6 +510,9 @@ struct hugetlbfs_inode_info {
 	struct inode vfs_inode;
 	struct resv_map *resv_map;
 	unsigned int seals;
+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
+	atomic64_t pmd_sharing_count;
+#endif
 };
 
 static inline struct hugetlbfs_inode_info *HUGETLBFS_I(struct inode *inode)
@@ -516,6 +520,39 @@ static inline struct hugetlbfs_inode_info *HUGETLBFS_I(struct inode *inode)
 	return container_of(inode, struct hugetlbfs_inode_info, vfs_inode);
 }
 
+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
+static inline void hugetlbfs_pmd_sharing_init(struct inode *inode)
+{
+	atomic64_set(&HUGETLBFS_I(inode)->pmd_sharing_count, 0);
+}
+
+static inline void hugetlbfs_pmd_sharing_inc(struct inode *inode)
+{
+	atomic64_inc(&HUGETLBFS_I(inode)->pmd_sharing_count);
+}
+
+static inline void hugetlbfs_pmd_sharing_dec(struct inode *inode)
+{
+	atomic64_dec(&HUGETLBFS_I(inode)->pmd_sharing_count);
+}
+
+static inline bool hugetlbfs_pmd_sharing_active(struct inode *inode)
+{
+	return atomic64_read(&HUGETLBFS_I(inode)->pmd_sharing_count) != 0;
+}
+#else
+static inline void hugetlbfs_pmd_sharing_init(struct inode *inode) {}
+
+static inline void hugetlbfs_pmd_sharing_inc(struct inode *inode) {}
+
+static inline void hugetlbfs_pmd_sharing_dec(struct inode *inode) {}
+
+static inline bool hugetlbfs_pmd_sharing_active(struct inode *inode)
+{
+	return false;
+}
+#endif
+
 extern const struct vm_operations_struct hugetlb_vm_ops;
 struct file *hugetlb_file_setup(const char *name, size_t size, vma_flags_t acct,
 				int creat_flags, int page_size_log);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4f6f58bf3db6c..cb27c06d1f7a7 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5361,10 +5361,12 @@ void __hugetlb_zap_begin(struct vm_area_struct *vma,
 	if (!vma->vm_file)	/* hugetlbfs_file_mmap error */
 		return;
 
-	adjust_range_if_pmd_sharing_possible(vma, start, end);
 	hugetlb_vma_lock_write(vma);
-	if (vma->vm_file)
+	if (vma->vm_file) {
 		i_mmap_lock_write(vma->vm_file->f_mapping);
+		if (hugetlbfs_pmd_sharing_active(file_inode(vma->vm_file)))
+			adjust_range_if_pmd_sharing_possible(vma, start, end);
+	}
 }
 
 void __hugetlb_zap_end(struct vm_area_struct *vma,
@@ -5403,7 +5405,10 @@ void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				start, end);
-	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
+	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
+	if (hugetlbfs_pmd_sharing_active(file_inode(vma->vm_file)))
+		adjust_range_if_pmd_sharing_possible(vma, &range.start,
+						     &range.end);
 	mmu_notifier_invalidate_range_start(&range);
 	tlb_gather_mmu(&tlb, vma->vm_mm);
 
@@ -7006,6 +7011,7 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (pud_none(*pud)) {
 		pud_populate(mm, pud,
 				(pmd_t *)((unsigned long)spte & PAGE_MASK));
+		hugetlbfs_pmd_sharing_inc(file_inode(vma->vm_file));
 		mm_inc_nr_pmds(mm);
 	} else {
 		ptdesc_pmd_pts_dec(virt_to_ptdesc(spte));
@@ -7037,6 +7043,7 @@ static int __huge_pmd_unshare(struct mmu_gather *tlb,
 	pud_clear(pud);
 
 	tlb_unshare_pmd_ptdesc(tlb, virt_to_ptdesc(ptep), addr);
+	hugetlbfs_pmd_sharing_dec(file_inode(vma->vm_file));
 
 	mm_dec_nr_pmds(mm);
 	return 1;
-- 
2.20.1


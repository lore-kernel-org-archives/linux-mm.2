Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFC37C982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 09:08:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB8426B00A1; Tue, 22 Sep 2026 05:08:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B696F6B00A2; Tue, 22 Sep 2026 05:08:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA6FA6B00A5; Tue, 22 Sep 2026 05:08:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 891A66B00A1
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:08:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 86D74A0407
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:08:27 +0000 (UTC)
X-FDA: 85240822254.29.82113F1
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf12.hostedemail.com (Postfix) with ESMTP id BFB8340002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:08:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=cwFQlxgP;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf12.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790068105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=f43TmgQRALeNk9ZBHseTt/FnXdw6N5ADxp4C+n/kWzM=;
	b=BT66IrKr4mXE7n6wQ57andFoiJD8iUFqEdBUb0Stw0qzU9DPI/SQ3nov5kkQN1WEnXzIKD
	BZZpFtIXpiKIGfXDvRDyRuPM/7jLWlmDeAGWzE40+IGg3y1SiqskYwwoF6T1t/1q+y/ja3
	77NFIb2N37kpaGEV4RCjFmQYn6W3SYs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790068105;
	b=FfM8IbuuLy5duHaZ3vc0G6mOsJuvCp1L0TIBqQYJ/T/YkwWwqsMcmRjOj+N+UQyh0nhOG0
	c9GKEz4zcB/bX3MXOrygZjrwtHF3H2iRinUuVE9ErY+bzp/0XNdsQYtZWbRM5bl010Zuss
	N2m9u2Ft0amg5HUu983Eee8BiKirBbI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=cwFQlxgP;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf12.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1790068099; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=f43TmgQRALeNk9ZBHseTt/FnXdw6N5ADxp4C+n/kWzM=;
 b=cwFQlxgPBBPGG89MZ/ACYVuONFqf8GVz2O3zYJ+GCfqY1DSxLsREPGQCPM25j7VMXSKYG7
 EdY40O55XYDtyVUNzZNecy/yJl+wLYtTQpDV1xWUQVafOKhLwBmeSg4IINv1LOqYcc0EEX
 RzuNz2xxDyxjtqcaMgrfFmkj2kGapXihaKtKainPMBEhYvjJOIDmYUH7RThSaNdLP6O1Xa
 RxoKsJc4dGTuJCPfYYSlXqxpdo+e9HLidEcpFI5XumY5mPwIjm30m+YAzEiltzgWcjSya9
 37JypkqVIq8e1n7MlYDlkE7CrceyYwP/26cN5pbBZZsGbPXcb35JjNTTKfk+/A==
Subject: [PATCH v2] mm/hugetlb: fix overbroad MMU notifiers for unshared PMDs
Date: Tue, 22 Sep 2026 17:07:49 +0800
X-Mailer: git-send-email 2.45.2
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <david@kernel.org>, <muchun.song@linux.dev>, 
	<osalvador@suse.de>
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20260922090749.24905-1-lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26ab24581+17e242+kvack.org+lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Cc: <aiqi.i7@bytedance.com>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, "Li Zhe" <lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BFB8340002
X-Stat-Signature: gxx8z3ff93wgbuac86mk7bk1gts6w5ng
X-HE-Tag: 1790068104-484681
X-HE-Meta: U2FsdGVkX18Kqa8kxgr57T/e0P9rmsSnlHU2SzzKRDDU5ir/GLQTEBHlocUSclzMHDz8rr9TqWWTxiLknoQ9M1ZhTZ7m9rttunq6pBqUkVvT7Ha3zoHkkv9ItfHRjuQekpErgpazuJTloSxXqkrQo4LlhhqZvTg5EPkOmhM7BAEiDBKquT37+0EngWjbE0BGj909Tb3mNwE93+7nnnUbgNeH7vQnittTBdzocLEEhXpgYl5a1OXv6v/VG+3OHVEoulbUlV1AqOq9R0xuCMK25v4yoQoEMmjU9Jh0YuTp1WZm/3/uxj8QFWjs/K4YcrK1G/PNig2rIqgLWeQDtEmz/2IaFPgOB3tdl2u7DoXsfd9tHe2tK8J/N4q29OJ/WLSXLXp6Z4POsiFpix0skEM6CRUgXK3TdL625sUatFilyMrRFrlZLxabHqXCdK6GI2MwmLHB0NdKxlQNs2cbhgwvsI2oI69Q5SV1q2kFzoiv8qnHO+b0BjfbRrf9uzFOjUS6/dS/lIquS8TVoZYqJcdd3pVSTUs6ZqM54JeWRi2V14TmxeLCBK+q5VZOYSwe30/4p9gv5zYbeeGYsnZcs9LZiKuceNtDpRscaWJsI923aCtCSMxxfCPOzvRjearXhdeHhb88wcd9HMwkrqbYzf3cq1L7b7hJVpW+sRNfWiVmOFL4c670w++xD9obDaU+O11dIf/L8DwsNzEJl4oHG5Lt+6g1oz7EY5IALJUsceWcRJ4T6oDmNDdG7gupK5yqZuIxXZkAUz+LrHP8YTLNKYv4yEhxCGyiKmj6xHztDeja/b+JQFf+tdB+gofysDvjpjsB7BrQ3S2+nw7hfnwVKcC5b/P0dxSlZxtYm5Z3iPj1Z0vgf+G44mmVm9xCYlVdHGAzI6GKb6z8m8CkhiwgpGChKQVWaS6Ax8zWwQk7Q/9ddsNU85brFcKCGmnrxOl1XFYlJs2DuJ4i3meKO8TrMtk
 GRddkndz
 UpZDv3AhgrBpjs9s/EAtFClzx0lXz2PaEfVRFq4R6bXDoFWDy9J4q2I8eOP4gcTmKkU7GMo5aWkejGzWa+n7QqwV4Z545WTwVww53JWH+KQhdl0uoTayREXk3tf/q5/6hxxwvbonwJd4/e2DZJWYCJJuFr7UX488clx2SRMI5s3NG7VkVcIhFQ4m2lO6WmjDBCGS191S+gLFHdKrxhHWhuik93tDrAcHPkinlHwAm4gPtJzjagJJwF2vCTuDex4warBE+oYPBbrn44M2Oa4WTy7BG1Q==
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
adjust_range_if_pmd_sharing_possible() even when the hugetlbfs file has
never actually had any shared PMD page tables. KVM then receives a 1G
invalidation for a 2M operation and zaps unrelated secondary mappings,
so the guest has to fault them back in.

Avoid this by remembering, per hugetlbfs inode, whether PMD sharing was
ever established for the file. Set the flag when huge_pmd_share()
successfully populates a shared PMD table. For the hugetlb unmap paths,
skip the conservative PUD-sized notifier expansion while the file has
never seen PMD sharing.

The state is intentionally sticky and file-wide. Once PMD sharing has
ever happened for the file, the unmap paths keep the existing
conservative expansion. This avoids the no-sharing case without adding a
page-table walk to every unmap.

On a Redis-in-VM workload that punches cold 2M hugetlb pages, this patch
improves P99 QPS stability while punching pages, reducing the QPS
degradation ratio from 7.09% to 1.45%.

Reported-by: aiqi.i7 <aiqi.i7@bytedance.com>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
v1: https://lore.kernel.org/all/20260831091023.66581-1-lizhe.67@bytedance.com/

ChangeLogs:
- Rework the implementation based on David's suggestion: remember
  whether PMD sharing ever happened for a hugetlbfs file, and skip the
  conservative notifier range expansion while it has not. This avoids
  the per-unmap page-table walk.

 fs/hugetlbfs/inode.c    |  3 +++
 include/linux/hugetlb.h | 24 ++++++++++++++++++++++++
 mm/hugetlb.c            | 11 ++++++++---
 3 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 7611a84..1e24b8d 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -921,6 +921,9 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb,
 		simple_inode_init_ts(inode);
 		info->resv_map = resv_map;
 		info->seals = F_SEAL_SEAL;
+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
+		info->pmd_sharing_seen = false;
+#endif
 		switch (mode & S_IFMT) {
 		default:
 			init_special_inode(inode, mode, dev);
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 16c4c4c..8f1f899 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -509,6 +509,9 @@ struct hugetlbfs_inode_info {
 	struct inode vfs_inode;
 	struct resv_map *resv_map;
 	unsigned int seals;
+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
+	bool pmd_sharing_seen;
+#endif
 };
 
 static inline struct hugetlbfs_inode_info *HUGETLBFS_I(struct inode *inode)
@@ -516,6 +519,27 @@ static inline struct hugetlbfs_inode_info *HUGETLBFS_I(struct inode *inode)
 	return container_of(inode, struct hugetlbfs_inode_info, vfs_inode);
 }
 
+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
+static inline void hugetlbfs_set_pmd_sharing_seen(struct inode *inode)
+{
+	HUGETLBFS_I(inode)->pmd_sharing_seen = true;
+}
+
+static inline bool hugetlbfs_pmd_sharing_seen(struct inode *inode)
+{
+	return HUGETLBFS_I(inode)->pmd_sharing_seen;
+}
+#else
+static inline void hugetlbfs_set_pmd_sharing_seen(struct inode *inode)
+{
+}
+
+static inline bool hugetlbfs_pmd_sharing_seen(struct inode *inode)
+{
+	return false;
+}
+#endif
+
 extern const struct vm_operations_struct hugetlb_vm_ops;
 struct file *hugetlb_file_setup(const char *name, size_t size, vma_flags_t acct,
 				int creat_flags, int page_size_log);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 7857728..e370960 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5359,10 +5359,12 @@ void __hugetlb_zap_begin(struct vm_area_struct *vma,
 	if (!vma->vm_file)	/* hugetlbfs_file_mmap error */
 		return;
 
-	adjust_range_if_pmd_sharing_possible(vma, start, end);
 	hugetlb_vma_lock_write(vma);
-	if (vma->vm_file)
+	if (vma->vm_file) {
 		i_mmap_lock_write(vma->vm_file->f_mapping);
+		if (hugetlbfs_pmd_sharing_seen(file_inode(vma->vm_file)))
+			adjust_range_if_pmd_sharing_possible(vma, start, end);
+	}
 }
 
 void __hugetlb_zap_end(struct vm_area_struct *vma,
@@ -5401,7 +5403,9 @@ void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				start, end);
-	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
+	if (hugetlbfs_pmd_sharing_seen(file_inode(vma->vm_file)))
+		adjust_range_if_pmd_sharing_possible(vma, &range.start,
+						     &range.end);
 	mmu_notifier_invalidate_range_start(&range);
 	tlb_gather_mmu(&tlb, vma->vm_mm);
 
@@ -7004,6 +7008,7 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (pud_none(*pud)) {
 		pud_populate(mm, pud,
 				(pmd_t *)((unsigned long)spte & PAGE_MASK));
+		hugetlbfs_set_pmd_sharing_seen(mapping->host);
 		mm_inc_nr_pmds(mm);
 	} else {
 		ptdesc_pmd_pts_dec(virt_to_ptdesc(spte));
-- 
2.45.2


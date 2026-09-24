Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FDDFC98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 08:20:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65C326B0093; Thu, 24 Sep 2026 04:20:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60C746B0095; Thu, 24 Sep 2026 04:20:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 525576B0096; Thu, 24 Sep 2026 04:20:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31CB46B0093
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:20:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BCC7E40279
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:20:50 +0000 (UTC)
X-FDA: 85247959860.24.0FF9B57
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7F7121C0005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:20:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=liHlDVfe;
	spf=pass (imf21.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790238049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zxzIZ5mEDu53hBL9tVtFRMsrCTu/a/cXLKfvDqCdxFU=;
	b=pznPrRkA14dYV8/9cS0wdLGs06NkkVqQsZqeFt9liDYBiLZAI+NFTzngFTkuUf6kpH/aT/
	pr/+6Vcby8VvnQC+GsOWPbAbVkerdavgswNDBj3bO594wXgG9Yf45Fy8mlXq3T9bt+hDIa
	bmbrxVvHfTaJiepa1mvz/ra84o0ErRA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=liHlDVfe;
	spf=pass (imf21.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790238049;
	b=t6vnUgyZp9LepRHnvC06WFih2GVaiCr8GVbQ/F7v2Wp+D+BlCutwgegMHr6ECjzgonFway
	S8lEnjMMzxwh9//zMsmLIhJCg6YzzA3BVjZDe6MTE7yagAu6PHlk/XFdlM44DgGQ01mHXv
	V8wvw3ejMqcYYOoiXty6/qzLPiMzfg8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1790238037; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=zxzIZ5mEDu53hBL9tVtFRMsrCTu/a/cXLKfvDqCdxFU=;
 b=liHlDVfeJplrJxnGGALb/qZrN1P3+Z3dTZWq/WeU9Sr0bpc5huKbS5L1bmUObZeog396+e
 KspW6oYqjpZjYkgTzITtAm4nIZBrCLdekd+YMLubNIFCht0N/Ok69RXl6p9c6o0bcg/DWb
 hcbeLFAsvXhLJ7O1n91LqFg+0ogmxVjb6Z0dBc0HdrgdSEQWU9mU9F8qf6LzzlKVpbhD3F
 9TULEuVfSCq3L+KjIgIeDuRKjtt3WDQut10K/wGXmkgYqV+mG6Wg4xrq8EBLDKOJ5RVMP4
 9XmATAsmPWB3wwiNt8wP6XmAL6gOE3qoiq5o0Jn+2Z15dUFc6z89jezs4olY8A==
From: "Li Zhe" <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.45.2
Subject: [PATCH v3] mm/hugetlb: fix overbroad MMU notifiers for unshared PMDs
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26ab4dd53+332290+kvack.org+lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <muchun.song@linux.dev>, 
	<osalvador@suse.de>
Date: Thu, 24 Sep 2026 16:20:04 +0800
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<aiqi.i7@bytedance.com>, <lizhe.67@bytedance.com>
Message-Id: <20260924082004.82450-1-lizhe.67@bytedance.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7F7121C0005
X-Stat-Signature: ouqnjmnad5x9q8hmkc97fmb1byb8416c
X-HE-Tag: 1790238048-970953
X-HE-Meta: U2FsdGVkX1/S6mI4dk8L0YMeLfzXDQKUHKMTJzAifaxy1kO8Ax6/Ondgco0Z0UzUEyFzN2FSpIg9fMzMNIloiQYrp+rhBpK8mRD6dF+LZ0Q1OapeDSu2RRm6Dc5AeGSPDiby26X5ZNBFyHRJCLXfOQgJ5WDwmvOPHXIA2aNDSkz6VIxsT3vivbMVEPasgC7YMehSM3fv2xCHgZNfNUt1+cigwMNkjiVTKkKnMBZWGjhVHG6zjh0qeEJb8Cnk8AhuMjmvGWH9asxJTk9IdAwU4hzwwBmcpb+i2Mo5F68Ey8TKSTHvMdxD+nZ5yLeevJf3DVV+tFwshOAjjsTzpgDI8jyrivRW92aMFO01zKAoxnMzPQF3S8m97yHqc3QcJpzB9lSP9PqQ7/jcMZ81Y8RW99J/l3IgZuC6Mb8mORqcL/5ZrHtrT8CDfH5PNcIBngyjPT5koo0RtfkOuABFn0kpdI0dv08owsYvdibz1flbT7HlF059dJQ4OPDnZOsaPXVUUapFgA09/S0Ilo0r1gUoFFNXLBUE3pOp28+9ejVV/4t9mcI/ZffXNLrnmS6JnBUxQ2nzVXpQL4ZOurPCbK89e9A+ryFUY2Qg/20Y2A1QyY8trhaMtPYo+KsHAxIPo3yl62R1g+Ixh3bGaBxdKNEkHK67QLqzbU/bj/jc6kZc9UtAP5tGm9YyJFXoIMXx61sOGKIvIIewUImmzNf0yjTo5Xp/M+xFPgwPY7ewd1xIrf+XoyRoMA8s3xOKrhhVD3eKtU9Z0KRwmr4letJQXDFPRP4kWqAuk1lMukWHXxF9+wzolIZz7F+DzTOpRReWTIP9wZkj9lFIMYTkOr4DM/IPuFFuQIUIrJzFyR86HiiY/mJ9NYT+hQNK8oirjTS5+B9EmYbWmOVHphIj54oHLO4/uvhAchNgpe7/SjvLAo/+c+I8/0yGbGO34O72UDJ53hMRp3W3UqrHlTqB/lGZkbc
 il68An+0
 TgN3fTIeiz7eUk7qsKHdGCOSuq+957ngFIepOeH4QtFXMcLgqFNMDdI+y++I7zwytKu+xn7TgPHdd3RkUSiA2C37n9BOqx/3H0rL/gZMkqt5rk9sPXbPXRxGI86Uit8W1cU0mYaFtyMN0zDuwq0aa3s1EqOJLzW/BswlPP3+8qS6onrO0y+l+RGtEsDKlorBUmA3eOi2SlyBfZp53b9XEFjxHDek1yRQuNFAJoTG6zqbyIyJ5DSZ93qvbJ4KJ3ZYFh6hMWP8XAbCj2qsgPUVUh1obuA==
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
i_mmap_lock_read(), use atomic operations for the count. A zero count is
used to skip the conservative notifier range expansion only after
excluding concurrent PMD sharing with the mapping write lock.

On a Redis-in-VM workload that punches cold 2M hugetlb pages, this patch
improves P99 QPS stability while punching pages, reducing the QPS
degradation ratio from 7.09% to 1.45%.

Reported-by: aiqi.i7 <aiqi.i7@bytedance.com>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
v2: https://lore.kernel.org/all/20260922090749.24905-1-lizhe.67@bytedance.com/
v1: https://lore.kernel.org/all/20260831091023.66581-1-lizhe.67@bytedance.com/

ChangeLogs:
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
 include/linux/hugetlb.h | 43 +++++++++++++++++++++++++++++++++++++++++
 mm/hugetlb.c            | 13 ++++++++++---
 3 files changed, 54 insertions(+), 3 deletions(-)

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
index 16c4c4caa126c..6b4f92b7f7ae4 100644
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
+	atomic_t pmd_sharing_count;
+#endif
 };
 
 static inline struct hugetlbfs_inode_info *HUGETLBFS_I(struct inode *inode)
@@ -516,6 +520,45 @@ static inline struct hugetlbfs_inode_info *HUGETLBFS_I(struct inode *inode)
 	return container_of(inode, struct hugetlbfs_inode_info, vfs_inode);
 }
 
+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
+static inline void hugetlbfs_pmd_sharing_init(struct inode *inode)
+{
+	atomic_set(&HUGETLBFS_I(inode)->pmd_sharing_count, 0);
+}
+
+static inline void hugetlbfs_pmd_sharing_inc(struct inode *inode)
+{
+	atomic_inc(&HUGETLBFS_I(inode)->pmd_sharing_count);
+}
+
+static inline void hugetlbfs_pmd_sharing_dec(struct inode *inode)
+{
+	atomic_dec(&HUGETLBFS_I(inode)->pmd_sharing_count);
+}
+
+/*
+ * A 32-bit counter can theoretically wrap, but doing so would require
+ * billions of active PMD-sharing attachments to the same inode and is not
+ * expected in practice. Treat any non-zero value as active so a wrapped
+ * negative value still takes the conservative notifier range.
+ */
+static inline bool hugetlbfs_pmd_sharing_active(struct inode *inode)
+{
+	return atomic_read(&HUGETLBFS_I(inode)->pmd_sharing_count) != 0;
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


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DADACCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:05:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60B8C6B00B4; Fri,  1 May 2026 17:04:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E0666B00B5; Fri,  1 May 2026 17:04:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E8976B00B6; Fri,  1 May 2026 17:04:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F1E16B00B4
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EA33C1C01C7
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:23 +0000 (UTC)
X-FDA: 84720079206.03.36227E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id BD217160002
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JHlM8jrg;
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669461;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cIctsTM+vet8oZeDf27+dPPD/+17fXmwatLAv9s6Dak=;
	b=aUY2LmhEW4IDjh2IQHukPQl4wyHYVDR1Zoe1YyNdS9eBsuxq/KbxTKYzfQXlkxmb5TOrcU
	HQHSA9/sSbUnhSdmR50AGoDGqzTnxGC5ocyzYKRAeAsoyMjZ1Rj7J7irICKS/ut+s4e7L/
	6N6HmaRxlRhSgVdO4ifwcawskW/HxYg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669461; a=rsa-sha256;
	cv=none;
	b=ivQ5PcEEyxADqe/mzCX/7isdg30LPPHzMyrWvp7XWQVoAz+qN2tAyKCp+NvQ0fPlBbFf8e
	L/azSGiJLiEEugs+hH5MFL337WAuaYR0LXxdTS01fuK55aDZXJMVGOgAnEw+USu2KTmR6c
	f+0eag7sRQkBOG3DWSbqL8EPeddpqpk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JHlM8jrg;
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AB2D044793;
	Fri,  1 May 2026 21:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8C045C2BCC4;
	Fri,  1 May 2026 21:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669454;
	bh=doK35nLkz5KNd5wFsipWvD5mR9lAV1HrW1BUxLjjaQQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=JHlM8jrgo4S1gaO3BtXvkmeotdlraqcQjESCI5XIcy8Q6plVV34YcYFNGwHZDvnlU
	 GBnYJBYfQmlxOFcngT3SqFcRGtv+5HM8c0rlZ8i/BM/C60gYVYd+8RbEoHtcv/i0OD
	 b+iJ1bl7XQjJNOuo8ZWKQDoaOuSl/zQQQbEumqG5dtdX5up0gSK+Nob3MQhaAEUUnA
	 jdC1lbAlxQH9kDZIY53Nj2meIc2ib27DRQ6t86hMs+NsITnsh4OsVzBNfgFoj+SLoT
	 jaXdMAoUR5+aYBV9Pvm2jQemRxkA1sZ/610N8XIHP1tdebyVDGeLm01FCyIFdJOAm1
	 TuBsvBGgCAXPg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8444CCCFA13;
	Fri,  1 May 2026 21:04:14 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:04:18 +0800
Subject: [PATCH RFC 32/32] mm: remove PG_referenced
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-32-913619b014d9@tencent.com>
References: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
In-Reply-To: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=11205;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=g2ZuyybWv1/6mZFk+0JvM1YtPzR/czoYZ6oSGgPM8VM=;
 b=BB/IakPj7gn2GvJbqMjUa/xsbX9CqxXM0JOhr2DmQ3jA/C5RE6ocQAbcrAFp3Jb3uiVnU25Y4
 H8zQijTh9l6Bm18Vt+jYQDKNLoWIROPjzk6QvOFTH1frABIZ0jcRLAx
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BD217160002
X-Stat-Signature: tuhywwz8eiixsp839h6g6xx49adjasdy
X-Rspam-User: 
X-HE-Tag: 1777669461-629641
X-HE-Meta: U2FsdGVkX18+/creghAiXswFAs+f3OasYHCbyfUaJ+ozm5Hlopf23S/s9seUY/NYv2ZkgQYbVzi57VtzKSVLnAv3DJXbLk6Z/ZNuAFtOnheiMjjYnAi/vK16JH1rN4dAaZSSL9cF1VaEPuuV/QIxPG48msNe7vz6u/T7PQSeQenLBM+3wXuUZawT/5kipZANBMIg9w/XFrVyN8d4FnsifM5xncVGwRRV4VZxhXUEcXyKDTuSdaajeNcYt0jUD1+URWrwwB2n6saepmK5uxfsplzAHK1N5N50xx6SZHhd4vFkmsriQO/jzjj0CorlYXQDy4dHj73XIm6diTHiN4wwXw3ixUBIWzSXFWBSfjN07H9rzIPBKyGfk8ZAU82TMAgf8o+dYdIp14oM5KvjHktgJlnwqMkuV0bQXiVeflLDhupb1fQuj+bxeiKftspzvhOhjFWutlnbzxLEIyJ9EYKjqhX4IbKeP5g6k0hCRnDJl+SQaWo+nnokAhoML7/LSA810jpYDAiGCoPGImjFTaBH+RN4I+i3Ll0tU8gf20+X22CWS9UUD/j0uXDZrIQ/Xs6KkCwdgxbz12dVMmzsJOptjf1+Tkk8dmgkVwfeGsd+UoAFxxnCFfSNLs4IvVQyqzDrTZKZq/61XPcNwHNh4ny1RBUZFgohEbKUrAgOQaMQeUudQxgNKGP9V99n3PD3M1tRN8Hwg8/N0BrQPZrucLkF+r5ZvpE4Pvz1udrjVwxFi+fXRC0bcdvZjXFnqpCg7KqP/Q0UnZJ/CD48Sa7j+gp4UWeST8tASNJNDMoCHL6KMSCnuk+ig3IGHPgo0Ud0a/lN0/dj8HM7E7VFR7qm/S3VawHbMYAqQbM+No+qREkeWtHBv1jY7CTn714h0xOiP9w1MHwNl+TIafjTbKoHFDbWCHbLpcglCcfEKu69MmlClGbMgNXijn0ogJmpoJY7id9h0mr2iJUqX2DuuxWLJUD
 YecOiuxW
 lytvKmGrwk52TJPTLQrlBeiS9NAVPOCkUvfmQBExDYO2TDxe+6KiDmDLYaX8Zyy+m4JMSvYPPJ/JqCorL9zpLWFRlEKgmGK5spTBfvDiVgGP4zAwVtX9YyrL8pbJwl7Jor1VMaprljHJW93M3+KtKSfWXApVoJWNgVmTl20lgZsiOWvM3mUPLEzDIdV0xyOAyPuuf2hMsYiqxVwzBc7O1XoJD3ZdezQz5oY5UW3SEqUxoYfpR8iVEm+klKiLcmordNQTJ6iRY85Xo0//8SnXx8hiaZlq71YCl55pGCXvjZoqFNeL95Urd8mJj0IOtVJegzBTOppD8E+S7LCUsdOrwn5P9NQwHodQ3KRhjC0nTJl8Rr/l/f8TVuPLlxjhpnmgZwalErWOjxeq6xtfPzVJgCMmmXA2oDJ0kR8DxdNkSTPku6ZJ1Kkoef6Halbzo5R+d2SK3DxZE6uPk8yA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now PG_referenced is used as the lowest bit of folio's access count
for MGLRU, and for non-MGLRU access to this bit is wrapper by new helpers.
We can now remove this flag to avoid the ugly dance when setting the
folio's reference count. Extend the folio's access count field width
and convert helpers to use the lowest bit directly.

Merge PG_referenced into LRU referenced bits, no feature change.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 fs/fuse/dev.c                          |  1 -
 fs/proc/page.c                         |  1 -
 include/linux/mm.h                     |  2 +-
 include/linux/mm_inline.h              | 18 ++++++------------
 include/linux/mmzone.h                 |  9 ++++-----
 include/linux/page-flags.h             |  8 ++------
 include/trace/events/mmflags.h         |  1 -
 include/uapi/linux/kernel-page-flags.h |  1 -
 kernel/bounds.c                        |  2 +-
 mm/huge_memory.c                       |  3 +--
 mm/workingset.c                        |  8 ++++----
 tools/mm/page-types.c                  |  1 -
 12 files changed, 19 insertions(+), 36 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 12270c5f647c..4fb9d3193ccf 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -963,7 +963,6 @@ static int fuse_check_folio(struct folio *folio)
 	    folio->mapping != NULL ||
 	    (folio->flags.f & PAGE_FLAGS_CHECK_AT_PREP &
 	     ~(1 << PG_locked |
-	       1 << PG_referenced |
 	       1 << PG_lru |
 	       1 << PG_active |
 	       1 << PG_reclaim |
diff --git a/fs/proc/page.c b/fs/proc/page.c
index f9b2c2c906cd..018454279f66 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -221,7 +221,6 @@ u64 stable_page_flags(const struct page *page)
 	u |= kpf_copy_bit(k, KPF_WRITEBACK,	PG_writeback);
 
 	u |= kpf_copy_bit(k, KPF_LRU,		PG_lru);
-	u |= kpf_copy_bit(k, KPF_REFERENCED,	PG_referenced);
 	u |= kpf_copy_bit(k, KPF_ACTIVE,	PG_active);
 	u |= kpf_copy_bit(k, KPF_RECLAIM,	PG_reclaim);
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1d76da6e0791..008bd9187b9d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3570,7 +3570,7 @@ static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long a
 #endif /* CONFIG_MMU */
 
 enum pt_flags {
-	PT_kernel = PG_referenced,
+	PT_kernel = PG_owner_priv_1,
 	PT_reserved = PG_reserved,
 	/* High bits are used for zone/node/section */
 };
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 446597e594e8..7574dd3e244b 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -100,15 +100,11 @@ static __always_inline enum lru_list folio_lru_list(const struct folio *folio)
  */
 static inline int lru_refs_from_flags(unsigned long flags)
 {
-	int refs;
-
 	/*
 	 * Return the total number of accesses. Also see the comment on
 	 * LRU_REFS_FLAGS.
 	 */
-	refs = (flags & BIT(PG_referenced)) ? BIT(0) : 0;
-	refs += ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) << 1;
-	return refs;
+	return (flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF;
 }
 
 /**
@@ -121,9 +117,7 @@ static inline void lru_refs_set_flags(unsigned long *flags, unsigned int refs)
 	VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
 
 	*flags &= ~LRU_REFS_FLAGS;
-	if (refs & BIT(0))
-		*flags |= BIT(PG_referenced);
-	*flags |= (((unsigned long)refs) >> 1) << LRU_REFS_PGOFF;
+	*flags |= ((unsigned long)refs) << LRU_REFS_PGOFF;
 }
 
 static inline int folio_lru_refs(const struct folio *folio)
@@ -199,7 +193,7 @@ static inline void __folio_init_referenced(struct folio *folio)
  */
 static inline void folio_mark_referenced_by_bit(struct folio *folio)
 {
-	set_mask_bits(folio_flags(folio, 0), BIT(PG_referenced), BIT(PG_referenced));
+	set_mask_bits(folio_flags(folio, 0), BIT(LRU_REFS_PGOFF), BIT(LRU_REFS_PGOFF));
 }
 
 /**
@@ -208,7 +202,7 @@ static inline void folio_mark_referenced_by_bit(struct folio *folio)
  */
 static inline void folio_clear_referenced_by_bit(struct folio *folio)
 {
-	set_mask_bits(folio_flags(folio, 0), BIT(PG_referenced), 0);
+	set_mask_bits(folio_flags(folio, 0), BIT(LRU_REFS_PGOFF), 0);
 }
 
 /**
@@ -217,7 +211,7 @@ static inline void folio_clear_referenced_by_bit(struct folio *folio)
  */
 static inline bool folio_test_clear_referenced_bit(struct folio *folio)
 {
-	return test_and_clear_bit(PG_referenced, folio_flags(folio, 0));
+	return test_and_clear_bit(LRU_REFS_PGOFF, folio_flags(folio, 0));
 }
 
 /**
@@ -226,7 +220,7 @@ static inline bool folio_test_clear_referenced_bit(struct folio *folio)
  */
 static inline bool folio_is_referenced_by_bit(const struct folio *folio)
 {
-	return test_bit(PG_referenced, const_folio_flags(folio, 0));
+	return test_bit(LRU_REFS_PGOFF, const_folio_flags(folio, 0));
 }
 
 /**
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index f55d256fd200..575afff010eb 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -522,8 +522,7 @@ enum lruvec_flags {
  * LRU_REFS_PROTECTED. It still considered workingset but moved to a higher
  * gen representing a higher hotness and reclaim bias.
  *
- * Tiering uses PG_referenced as the lowest bit and LRU_REFS_MASK as the
- * higher bits.
+ * Tiering uses LRU_REFS_WIDTH bits in folio->flags, masked by LRU_REFS_MASK.
  *
  * A folio's referenced count never goes backwards except upon gen increase
  * in (7) or a promotion. Passive protect by PID will reset a folio with higher
@@ -536,7 +535,7 @@ enum lruvec_flags {
  *
  * MAX_NR_TIERS is set to 4 so that the multi-gen LRU can support twice the
  * number of categories of the active/inactive LRU when keeping track of
- * accesses through file descriptors. This uses MAX_NR_TIERS-2 spare bits in
+ * accesses through file descriptors. This uses MAX_NR_TIERS-1 bits in
  * folio->flags, masked by LRU_REFS_MASK.
  */
 #define MAX_NR_TIERS		4U
@@ -549,8 +548,8 @@ enum lruvec_flags {
 #define LRU_GEN_MASK		((BIT(LRU_GEN_WIDTH) - 1) << LRU_GEN_PGOFF)
 #define LRU_GEN_MAX		(BIT(LRU_GEN_WIDTH - 1) - 1)
 #define LRU_REFS_MASK		((BIT(LRU_REFS_WIDTH) - 1) << LRU_REFS_PGOFF)
-#define LRU_REFS_FLAGS		(LRU_REFS_MASK | BIT(PG_referenced))
-#define LRU_REFS_MAX		(BIT(LRU_REFS_WIDTH + 1) - 1)
+#define LRU_REFS_FLAGS		LRU_REFS_MASK
+#define LRU_REFS_MAX		(BIT(LRU_REFS_WIDTH) - 1)
 
 struct lruvec;
 struct page_vma_mapped_walk;
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 451e96ca89f7..ba82f5c755f8 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -63,7 +63,7 @@
  * might lose their PG_swapbacked flag when they simply can be dropped (e.g. as
  * a result of MADV_FREE).
  *
- * PG_referenced, PG_reclaim are used for page reclaim for anonymous and
+ * PG_reclaim are used for page reclaim for anonymous and
  * file-backed pagecache (see mm/vmscan.c).
  *
  * PG_arch_1 is an architecture specific page state bit.  The generic code
@@ -93,13 +93,12 @@
 enum pageflags {
 	PG_locked,		/* Page is locked. Don't touch. */
 	PG_writeback,		/* Page is under writeback */
-	PG_referenced,
 	PG_uptodate,
 	PG_dirty,
 	PG_lru,
+	PG_active,
 	PG_head,		/* Must be in bit 6 */
 	PG_waiters,		/* Page has waiters, check its waitqueue. Must be bit #7 and in the same byte as "PG_locked" */
-	PG_active,
 	PG_owner_priv_1,	/* Owner use. If pagecache, fs may use */
 	PG_owner_2,		/* Owner use. If pagecache, fs may use */
 	PG_arch_1,
@@ -543,9 +542,6 @@ static inline int TestClearPage##uname(struct page *page) { return 0; }
 
 __PAGEFLAG(Locked, locked, PF_NO_TAIL)
 FOLIO_FLAG(waiters, FOLIO_HEAD_PAGE)
-FOLIO_FLAG(referenced, FOLIO_HEAD_PAGE)
-	FOLIO_TEST_CLEAR_FLAG(referenced, FOLIO_HEAD_PAGE)
-	__FOLIO_SET_FLAG(referenced, FOLIO_HEAD_PAGE)
 PAGEFLAG(Dirty, dirty, PF_HEAD) TESTSCFLAG(Dirty, dirty, PF_HEAD)
 	__CLEARPAGEFLAG(Dirty, dirty, PF_HEAD)
 PAGEFLAG(LRU, lru, PF_HEAD) __CLEARPAGEFLAG(LRU, lru, PF_HEAD)
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index c13575d8c7ee..b411475e82d1 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -142,7 +142,6 @@ TRACE_DEFINE_ENUM(___GFP_LAST_BIT);
 #define __def_pageflag_names						\
 	DEF_PAGEFLAG_NAME(locked),					\
 	DEF_PAGEFLAG_NAME(waiters),					\
-	DEF_PAGEFLAG_NAME(referenced),					\
 	DEF_PAGEFLAG_NAME(uptodate),					\
 	DEF_PAGEFLAG_NAME(dirty),					\
 	DEF_PAGEFLAG_NAME(lru),						\
diff --git a/include/uapi/linux/kernel-page-flags.h b/include/uapi/linux/kernel-page-flags.h
index ff8032227876..adff709a86f6 100644
--- a/include/uapi/linux/kernel-page-flags.h
+++ b/include/uapi/linux/kernel-page-flags.h
@@ -8,7 +8,6 @@
 
 #define KPF_LOCKED		0
 #define KPF_ERROR		1	/* Now unused */
-#define KPF_REFERENCED		2
 #define KPF_UPTODATE		3
 #define KPF_DIRTY		4
 #define KPF_LRU			5
diff --git a/kernel/bounds.c b/kernel/bounds.c
index 02b619eb6106..4171cf03f296 100644
--- a/kernel/bounds.c
+++ b/kernel/bounds.c
@@ -25,7 +25,7 @@ int main(void)
 	DEFINE(SPINLOCK_SIZE, sizeof(spinlock_t));
 #ifdef CONFIG_LRU_GEN
 	DEFINE(LRU_GEN_WIDTH, order_base_2(MAX_NR_GENS + 1));
-	DEFINE(__LRU_REFS_WIDTH, MAX_NR_TIERS - 2);
+	DEFINE(__LRU_REFS_WIDTH, MAX_NR_TIERS - 1);
 #else
 	DEFINE(LRU_GEN_WIDTH, 0);
 	DEFINE(__LRU_REFS_WIDTH, 0);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f30445c01f18..02d356d38cea 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3637,8 +3637,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 		 */
 		new_folio->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
 		new_folio->flags.f |= (folio->flags.f &
-				((1L << PG_referenced) |
-				 (1L << PG_swapbacked) |
+				((1L << PG_swapbacked) |
 				 (1L << PG_swapcache) |
 				 (1L << PG_mlocked) |
 				 (1L << PG_uptodate) |
diff --git a/mm/workingset.c b/mm/workingset.c
index f9de276a1404..6b0120c3456f 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -215,11 +215,11 @@
 #define LRU_EVICT_BITS_ANON	(LRU_EVICT_BITS - SWAP_COUNT_SHIFT)
 
 /*
- * LRU refs uses LRU_REFS_WIDTH + 1 bit in folio->flags, the extra 1 bit
- * is PG_referenced. But here we record the low bit of refs separately
- * (to reuse pack_shadow).
+ * LRU refs uses LRU_REFS_WIDTH bits in folio->flags. Its low bit is stored
+ * separately as the "workingset" bit in the shadow (to reuse pack_shadow);
+ * the remaining high bits are packed into the token.
  */
-#define LRU_REFS_BITS		((LRU_REFS_WIDTH + 1) - 1)
+#define LRU_REFS_BITS		(LRU_REFS_WIDTH - 1)
 #define LRU_GEN_EVICT_BITS	(LRU_EVICT_BITS - LRU_REFS_BITS)
 #define LRU_GEN_EVICT_BITS_ANON	(LRU_EVICT_BITS_ANON - LRU_REFS_BITS)
 
diff --git a/tools/mm/page-types.c b/tools/mm/page-types.c
index d7e5e8902af8..de5c7b6f3135 100644
--- a/tools/mm/page-types.c
+++ b/tools/mm/page-types.c
@@ -101,7 +101,6 @@
 static const char * const page_flag_names[] = {
 	[KPF_LOCKED]		= "L:locked",
 	[KPF_ERROR]		= "E:error",
-	[KPF_REFERENCED]	= "R:referenced",
 	[KPF_UPTODATE]		= "U:uptodate",
 	[KPF_DIRTY]		= "D:dirty",
 	[KPF_LRU]		= "l:lru",

-- 
2.54.0




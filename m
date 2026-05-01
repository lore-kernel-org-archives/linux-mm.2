Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9C04CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:04:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D84906B0099; Fri,  1 May 2026 17:04:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5BDA6B009B; Fri,  1 May 2026 17:04:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4B2B6B009D; Fri,  1 May 2026 17:04:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B37C26B0099
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 799E11202AC
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:17 +0000 (UTC)
X-FDA: 84720078954.22.B283E31
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8712A14000F
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U2EiVSAp;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669455;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ww6lCPjlaR3D1i2CWeRvKkVHyARnffKcyj82FvPKWPc=;
	b=SBy3vGhgnOC65sYmC7xCAdpnSujrXXdb3/w1ipqOj5IkKSKG90YUHiLJ8kacdauc6YQkrG
	MSIN1kyHXcp5R6Yv9ix7mruiNyldc13BDtM0aQKqkro0JRE5C6McqeB+pHusZYv+hk2yOI
	vRzNSESCyM9XH4uHrpswdL3bRqFFATY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669455; a=rsa-sha256;
	cv=none;
	b=BDwEdGAHkezoh65wUE+ws22ArF2DW6eoddE0L07hHFJHq5CtmyFYxGozuO5L6mxIB/xyia
	MyBtjByM0/zO0RdyVg2o5Ww5jWR6UGEjeSAAO9OaieamzTRkCIj7jl03BnLktTV1GL4MBK
	XpOt+d4YtW6Q0NmpCZe1SlKUxqKmwP4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U2EiVSAp;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CAF866014C;
	Fri,  1 May 2026 21:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7B1AEC2BCC6;
	Fri,  1 May 2026 21:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669454;
	bh=EfYFoJPzrm/LKZNnV8IsPykaRdCK7lu5nugZRzWhxPY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=U2EiVSApD5C5TEkHm24HPGShVRGE0py7AvOwvwpzh5rW1nfFFVgSZtwTFzCMiKd7+
	 KDXIAchOBJ7hHlW6wqQ+SxcnBWaK5JAFlP/DUsJrWF3zqQhY21Vsd63L1qnFa22z1r
	 0ZfZ3Tqeu+1ASmGQCAdf+SsnFRxfWgEYPWVW67RCuGeBjoJnNVOhaK3GjJmfgi8gWi
	 XiWYgAvyaqzMOiNM1WRxFhIlEM2wTwCr4HG3MQfloJhXQAdMZGGFf8YFOaUn5U4f6D
	 /Fe14xFmxRYo83KOIMLmL71L7f7oQHeAi4oBrp62RUkcQqLb44aEqF53mMkpZG320/
	 CefyqHoI7h8bA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7159DCD3427;
	Fri,  1 May 2026 21:04:14 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:04:17 +0800
Subject: [PATCH RFC 31/32] mm: remove PG_workingset
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-31-913619b014d9@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=9202;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=+4Zon/rLWOFCjp3678u/teBTE57oMcI/CfYNFDguoyE=;
 b=hoXxIcA+fm83eacooynsDJqnJlneSepVXkhwliW4wpuEj1vJ4nW6YSdD0HFKLVUk1Vuj7uymL
 5VdUtAhxPBrC7HosG9Cs+h9keewvJQ0YCjrJg7DlMjpcwGqXSD451Jq
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8712A14000F
X-Rspam-User: 
X-Stat-Signature: y91hhmtcdmkyemtjjmdjgdcr5kjy7wio
X-HE-Tag: 1777669455-996106
X-HE-Meta: U2FsdGVkX19nJhmLh8gmvo9ooNX/Rz2QKnvR4b0qmO1XIKw5CKzIVys2VYC6RQGjmkgCA3HimSRWM768CgD8CGpljth+YaYfxzEOCVv7UJwea2+wbUm4WywuZs9pAaMR7aKKjVPgyexfEyhW+1ku5WIbVUclNZWicrDx1dK1GdduDss8NAG0pcRPf5mAhK0j7T9DIYHP0CYbU1FzUSkP2jWFJXzaZ3sKmRUtZ6r89LfFPsRtz6tltWbL+gnNCDNk7yyHy1CK1PHXswLgz2albvWegfoSQl6Kr/9dB1RoTrjVpFy20fIq/RaP7+64JX2HTyaSGw/gO/cRdvyCAQaeDEwoq3TFjN5q7EuACaO70csaosIHaRXkqcc9zMpujVaYvlt/ohzHq50j1B8ggD/lbtjbijqcFTd5Q0QIpLjzFPuRwVqxhBZZ1jcsktu71pAJO9tf5rqCi/3M5xENQKpVRx1T77aDzrGRT+2kP32iDf/eiWJCYW0sPKqurUJXO2EQRQvYE8l7xhszrXQtRM8aLe4yLuQZ3fJYaS6DZaTx/XS8y4NoXdqgAax4zwSCTbvWMZj2zCOd8rZmiuHlhA+dvjT+1UKVozALHpeBrxbvhPPgfTsIxwMLtyhovu0u1IZ7hDOwviZxYv42yCs+Ne/Q3DcwR8+YOG3kfWCiQdiiEbydfg7AnNOSxhjRhd4ur39E2Q5GRya4i4ZbgRxGVAfcM8eIWOPy/w6KoStEsolzBthBULuhNdozR672Pm2Qjg3xlMySofwhWOSs1UOmKjACnsU/XXzDhh9bsEC1SNpBr5spb5JMSZG6IB+2BDDA9A/MUbuolX6LiHP/uOJOWQDlPK77rtTgsxlZ1Eli8ToC7VdS4mRU+cOcRXFybAya00Pb2AviwfLfARwnPUIzEXC3uUeH4/6/BCebKs3x2qPtGqjILwKwrTQtpV/2icCjTXRWFrOUVoKg5PKzVBan6V0
 slbLeKSY
 Z+FaEGduIkL+cPepfdRYTvSuLAzwJmdUbVNO37Zj8LVbTmuHa+ucxpU6h17JtETW2EfNvkoY7K7ct1/whfoNa7lmildINbpt7QKV3VOD0cvYLAANohmAC1uDj3feJEvpIXn7jzqBtmxR5oWPcaHpJ/8F/HjTFI/M8xMYxowcYCgB5DGZnKoR45CG7Cp2DjNsR1tgvwnd/CWDv7bdwzR44DJGhR1u3owbFzr2tyOwjM9mx453F3ftE2dRX0tafDDvG8ZgRWfZwPw18n6yNmrrhXX0QtQDBJDD4AYpgL8Hl3fr1wkFSUDNfBpLt+tb1LohPd4rdFlHiAXU+ydfmnm/IS52lBl3weOc+1iLHAo4dSC+AWf+kFA218YUhBky0ojmGmIJhcT11VANsKd0+rkoAdwbtRP8zT35JvlGb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now PG_workingset is used as the second lowest bit of folio's access
count for MGLRU, and for non-MGLRU access to this bit is wrapper by new
helpers. We can now remove this bit to avoid the ugly dance when setting
the folio's reference count. Extend the folio's access count field width
and convert helpers to use the lowest bit directly.

Merge PG_workingset into LRU referenced bits, no feature change.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 fs/erofs/zdata.c               |  3 ++-
 fs/fuse/dev.c                  |  1 -
 include/linux/mm_inline.h      | 10 ++++------
 include/linux/mmzone.h         | 10 +++++-----
 include/linux/page-flags.h     |  5 +----
 include/trace/events/mmflags.h |  1 -
 kernel/bounds.c                |  2 +-
 mm/huge_memory.c               |  1 -
 mm/slub.c                      |  2 +-
 mm/workingset.c                |  8 ++++----
 10 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 43bb5a6a9924..44bcf16fff6a 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -8,6 +8,7 @@
 #include <linux/psi.h>
 #include <linux/cpuhotplug.h>
 #include <trace/events/erofs.h>
+#include <linux/mm_inline.h>
 
 #define Z_EROFS_MAX_SYNC_DECOMPRESS_BYTES	12288
 #define Z_EROFS_PCLUSTER_MAX_PAGES	(Z_EROFS_PCLUSTER_MAX_SIZE / PAGE_SIZE)
@@ -1734,7 +1735,7 @@ static void z_erofs_submit_queue(struct z_erofs_frontend *f,
 				DBG_BUGON(bvec.bv_len < sb->s_blocksize);
 			}
 
-			if (unlikely(PageWorkingset(bvec.bv_page)) &&
+			if (unlikely(folio_is_workingset(page_folio(bvec.bv_page))) &&
 			    !memstall) {
 				psi_memstall_enter(&pflags);
 				memstall = 1;
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 5dda7080f4a9..12270c5f647c 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -966,7 +966,6 @@ static int fuse_check_folio(struct folio *folio)
 	       1 << PG_referenced |
 	       1 << PG_lru |
 	       1 << PG_active |
-	       1 << PG_workingset |
 	       1 << PG_reclaim |
 	       1 << PG_waiters |
 	       LRU_GEN_MASK | LRU_REFS_MASK))) {
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index a108695424fb..446597e594e8 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -107,8 +107,7 @@ static inline int lru_refs_from_flags(unsigned long flags)
 	 * LRU_REFS_FLAGS.
 	 */
 	refs = (flags & BIT(PG_referenced)) ? BIT(0) : 0;
-	refs += (flags & BIT(PG_workingset)) ? BIT(1) : 0;
-	refs += ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) << 2;
+	refs += ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) << 1;
 	return refs;
 }
 
@@ -124,9 +123,7 @@ static inline void lru_refs_set_flags(unsigned long *flags, unsigned int refs)
 	*flags &= ~LRU_REFS_FLAGS;
 	if (refs & BIT(0))
 		*flags |= BIT(PG_referenced);
-	if (refs & BIT(1))
-		*flags |= BIT(PG_workingset);
-	*flags |= (((unsigned long)refs) >> 2) << LRU_REFS_PGOFF;
+	*flags |= (((unsigned long)refs) >> 1) << LRU_REFS_PGOFF;
 }
 
 static inline int folio_lru_refs(const struct folio *folio)
@@ -253,7 +250,8 @@ static inline bool folio_is_workingset(const struct folio *folio)
  */
 static inline void folio_mark_workingset_by_bit(struct folio *folio)
 {
-	set_mask_bits(folio_flags(folio, 0), BIT(PG_workingset), BIT(PG_workingset));
+	BUILD_BUG_ON(LRU_REFS_WIDTH < 2);
+	set_mask_bits(folio_flags(folio, 0), BIT(LRU_REFS_PGOFF + 1), BIT(LRU_REFS_PGOFF + 1));
 }
 
 static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index aa27627b0406..f55d256fd200 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -522,8 +522,8 @@ enum lruvec_flags {
  * LRU_REFS_PROTECTED. It still considered workingset but moved to a higher
  * gen representing a higher hotness and reclaim bias.
  *
- * Tiering uses PG_workingset and PG_referenced and the lower two bits,
- * LRU_REFS_MASK as the higher bits.
+ * Tiering uses PG_referenced as the lowest bit and LRU_REFS_MASK as the
+ * higher bits.
  *
  * A folio's referenced count never goes backwards except upon gen increase
  * in (7) or a promotion. Passive protect by PID will reset a folio with higher
@@ -536,7 +536,7 @@ enum lruvec_flags {
  *
  * MAX_NR_TIERS is set to 4 so that the multi-gen LRU can support twice the
  * number of categories of the active/inactive LRU when keeping track of
- * accesses through file descriptors. This uses MAX_NR_TIERS-3 spare bits in
+ * accesses through file descriptors. This uses MAX_NR_TIERS-2 spare bits in
  * folio->flags, masked by LRU_REFS_MASK.
  */
 #define MAX_NR_TIERS		4U
@@ -549,8 +549,8 @@ enum lruvec_flags {
 #define LRU_GEN_MASK		((BIT(LRU_GEN_WIDTH) - 1) << LRU_GEN_PGOFF)
 #define LRU_GEN_MAX		(BIT(LRU_GEN_WIDTH - 1) - 1)
 #define LRU_REFS_MASK		((BIT(LRU_REFS_WIDTH) - 1) << LRU_REFS_PGOFF)
-#define LRU_REFS_FLAGS		(LRU_REFS_MASK | BIT(PG_referenced) | BIT(PG_workingset))
-#define LRU_REFS_MAX		(BIT(LRU_REFS_WIDTH + 2) - 1)
+#define LRU_REFS_FLAGS		(LRU_REFS_MASK | BIT(PG_referenced))
+#define LRU_REFS_MAX		(BIT(LRU_REFS_WIDTH + 1) - 1)
 
 struct lruvec;
 struct page_vma_mapped_walk;
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 0e03d816e8b9..451e96ca89f7 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -100,7 +100,6 @@ enum pageflags {
 	PG_head,		/* Must be in bit 6 */
 	PG_waiters,		/* Page has waiters, check its waitqueue. Must be bit #7 and in the same byte as "PG_locked" */
 	PG_active,
-	PG_workingset,
 	PG_owner_priv_1,	/* Owner use. If pagecache, fs may use */
 	PG_owner_2,		/* Owner use. If pagecache, fs may use */
 	PG_arch_1,
@@ -190,7 +189,7 @@ enum pageflags {
 
 	/* At least one page in this folio has the hwpoison flag set */
 	PG_has_hwpoisoned = PG_active,
-	PG_large_rmappable = PG_workingset, /* anon or file-backed */
+	PG_large_rmappable = PG_swapbacked, /* anon or file-backed */
 	PG_partially_mapped = PG_reclaim, /* was identified to be partially mapped */
 };
 
@@ -554,8 +553,6 @@ PAGEFLAG(LRU, lru, PF_HEAD) __CLEARPAGEFLAG(LRU, lru, PF_HEAD)
 FOLIO_FLAG(active, FOLIO_HEAD_PAGE)
 	__FOLIO_CLEAR_FLAG(active, FOLIO_HEAD_PAGE)
 	FOLIO_TEST_CLEAR_FLAG(active, FOLIO_HEAD_PAGE)
-PAGEFLAG(Workingset, workingset, PF_HEAD)
-	TESTCLEARFLAG(Workingset, workingset, PF_HEAD)
 PAGEFLAG(Checked, checked, PF_NO_COMPOUND)	   /* Used by some filesystems */
 
 /* Xen */
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index a6e5a44c9b42..c13575d8c7ee 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -147,7 +147,6 @@ TRACE_DEFINE_ENUM(___GFP_LAST_BIT);
 	DEF_PAGEFLAG_NAME(dirty),					\
 	DEF_PAGEFLAG_NAME(lru),						\
 	DEF_PAGEFLAG_NAME(active),					\
-	DEF_PAGEFLAG_NAME(workingset),					\
 	DEF_PAGEFLAG_NAME(owner_priv_1),				\
 	DEF_PAGEFLAG_NAME(owner_2),					\
 	DEF_PAGEFLAG_NAME(arch_1),					\
diff --git a/kernel/bounds.c b/kernel/bounds.c
index 06a034713b5d..02b619eb6106 100644
--- a/kernel/bounds.c
+++ b/kernel/bounds.c
@@ -25,7 +25,7 @@ int main(void)
 	DEFINE(SPINLOCK_SIZE, sizeof(spinlock_t));
 #ifdef CONFIG_LRU_GEN
 	DEFINE(LRU_GEN_WIDTH, order_base_2(MAX_NR_GENS + 1));
-	DEFINE(__LRU_REFS_WIDTH, MAX_NR_TIERS - 3);
+	DEFINE(__LRU_REFS_WIDTH, MAX_NR_TIERS - 2);
 #else
 	DEFINE(LRU_GEN_WIDTH, 0);
 	DEFINE(__LRU_REFS_WIDTH, 0);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 87a2640e3396..f30445c01f18 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3643,7 +3643,6 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 				 (1L << PG_mlocked) |
 				 (1L << PG_uptodate) |
 				 (1L << PG_active) |
-				 (1L << PG_workingset) |
 				 (1L << PG_locked) |
 				 (1L << PG_unevictable) |
 #ifdef CONFIG_ARCH_USES_PG_ARCH_2
diff --git a/mm/slub.c b/mm/slub.c
index 161079ac5ba1..4b363a81c6b0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -191,7 +191,7 @@
  */
 enum slab_flags {
 	SL_locked = PG_locked,
-	SL_partial = PG_workingset,	/* Historical reasons for this bit */
+	SL_partial = PG_owner_priv_1,	/* Use a flag that is never set for slab folio */
 	SL_pfmemalloc = PG_active,	/* Historical reasons for this bit */
 };
 
diff --git a/mm/workingset.c b/mm/workingset.c
index 25a8eda233ef..f9de276a1404 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -215,11 +215,11 @@
 #define LRU_EVICT_BITS_ANON	(LRU_EVICT_BITS - SWAP_COUNT_SHIFT)
 
 /*
- * LRU refs uses LRU_REFS_WIDTH + 2 bits, the 2 bits are PG_workingset and
- * PG_referenced. But here we record PG_workingset separately (to reuse
- * pack_shadow).
+ * LRU refs uses LRU_REFS_WIDTH + 1 bit in folio->flags, the extra 1 bit
+ * is PG_referenced. But here we record the low bit of refs separately
+ * (to reuse pack_shadow).
  */
-#define LRU_REFS_BITS		((LRU_REFS_WIDTH + 2) - 1)
+#define LRU_REFS_BITS		((LRU_REFS_WIDTH + 1) - 1)
 #define LRU_GEN_EVICT_BITS	(LRU_EVICT_BITS - LRU_REFS_BITS)
 #define LRU_GEN_EVICT_BITS_ANON	(LRU_EVICT_BITS_ANON - LRU_REFS_BITS)
 

-- 
2.54.0




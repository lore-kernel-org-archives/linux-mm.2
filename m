Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04818C88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 11:46:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DBCD6B00A4; Fri, 11 Sep 2026 07:45:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1668A6B00A7; Fri, 11 Sep 2026 07:45:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E60706B00A4; Fri, 11 Sep 2026 07:45:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA36D6B00A2
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:45:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 59BAF1C13B0
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:45:18 +0000 (UTC)
X-FDA: 85201300716.29.DC3B241
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 47B1B160006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:45:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="UtU/t6d2";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789127116;
	b=aeQ/O6EozWcAeI5yzfQXMhpR30kK91kGsQUlSkcf6XvVYvtZZPHJZ5F1lB+CCFrDcTSpqm
	E7Ve7HIzjKVqS+hLJ6yiZCZtQjsfDRMTP26zONMOMQJGWMmfS0y4LXgj67nQ5VrnVNyFsn
	LPf+M2t5MvgK+UZA+EM2B3BTT11/K/M=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="UtU/t6d2";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789127116;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w2aqbOelMZJW7Ik2gAGpMorDYZj5AXFwzeqQ/gwS67M=;
	b=qqI0Fm15YAK4iZfBXDUqsNVuZUNUpj8/8WLLv+Ak0PMVC74Vza14hNl/aUGQHaa0pQc2bV
	Zv8N4l/YuoOIeoscbVq3j+vE2Ga+gUqk1ZSjEezowVJYeOfVraXDeYD7JgAyCMSA1SXrQ9
	PewJOrjhAbCymIPTn+AOylF/cTMxOUk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A4AE44868;
	Fri, 11 Sep 2026 11:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 282D6C2BCF5;
	Fri, 11 Sep 2026 11:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789127111;
	bh=YPH5o67wdhhgZdMY4Rik9ghLMWXdKW5CusrZgPgXiZk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=UtU/t6d2urL0E77fooPeoguqW41XYcXtK4nUxzgIFnuGUUJcCmqL0UObhkP8gcLlr
	 2yrF0i/3Bhqt/Z87ixKyTZCHo0LlFw3gG2jcU13L/JSv/vcLGmkwmdQvDVepLZ3o74
	 U2tGL7JmCo9E/dIlO70Wgh3yoItfFCb7SItdzReYX5qcjZ1S6IEE5+W6rkcIssiVqK
	 sCP/6fxCalko7XY0BTJSXpJTLn6ROJ0L81kmagd945+VnkCD1RVQn8P4WiC4dQLFB5
	 a1WYT5z6QLvHpUURAjMToeCMRORk0kzwKCsa9KQDWpGwgaQp0gpEULOBUp8HIw25TF
	 QYXzqGLYdu68g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 144B1C88E56;
	Fri, 11 Sep 2026 11:45:11 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 11 Sep 2026 19:45:18 +0800
Subject: [PATCH RFC v2 15/15] mm/mglru: make folio_test_workingset() work
 based on folio LRU refs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-mglru-fg-v2-15-f26e5cb26da7@tencent.com>
References: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
In-Reply-To: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Nico Pache <nico.pache@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789127107; l=5993;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=deEdlZTK2eJdMlJCmft+0M6XrLp2DEbeIvYEzIeBHb4=;
 b=8cdpfQ65fKaBOCUvSWeg19Boa12RWupyRJjKI6kQDVsK4M3/UKS0jqTG+T0V0BAYyhk9Fgk3i
 x+1Da0pZfuZBjjHQyy9CjSWnClkZWvECW+2Kcijr5MVykt6+6RCKIHe
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 47B1B160006
X-Stat-Signature: mszzgn8q9mpy1z4z13nua6db3jzhop9u
X-HE-Tag: 1789127116-587930
X-HE-Meta: U2FsdGVkX19wivRo8IzUqe+86S7jzQ3ZX7EG4DgLA59y2iAH9d85XdMDR2QLnCBNqSPB2kUKqGaq+Xa3MBGyjnCjDE4rXkq+LSILsQBiyRCvFicKPAlf8FOTLL6qi51aHRIhyTtp5CbG0QDW0FUfE9ROqNXGc7VkKWnoMModpDPd6JsHer6c/ck86JuLrUKWIna0ujmX6ZAxdL+nT8Qed7ncRw4JpTNWAdi+JyXtbBNdDwLXRj1ODmtDGC0074X9ptfRhLWqxY9TxOwsi/Jfi9nkVF5GIblPGoI0kizd+x98RzN/pMsHJcuYRNW5bhmmoOpPWR8xCBEc2nYMuWCRItaRIlqOttg7zP2FYhb1Hl6jLz52bG/xDglmnznHXCpFt99QrbQPlv5BBJByJGhAwkx0z4Zs2b5lwiyu1A3ytMekHFDppiyR/vh4tBwI2Ohoq6nZl+9pSNRp/BLONSceAx8U1vqa/WYlRFyCybayzJfS8qNv9i9nHW/C/9VmoQoN/S8C/DMEpylC8Auop544uTSXMiUXqXTdB/1TjIu5qJIXeMHNNKHfIxDOwnxjq/tugKGPeVV3H15/vRhpjwvNcK4s8Ytx97qbKW2n+KWezFL7gzbUdbw5zIPwv89ejlR78Td54gubtCfP4wH1LaUA/vlWi8ywRsPm/M5Prh0CFKCkoWlBEXATkrtDnQZFVHGmmn2AjZjsujueZQKP68ENubJEZT5HnYkzKXeCIy2ByBiT55dTiDcDFuMUpdFrCLhlqwHdHuUXABIXuzOBVR3M9+syAWOoESWOJEcZBipV0Bhi21+OrXU6EKCxDN3fyCNA4v1dTWyu+TFlBTfrhnR6/+/pziPwI2AYSCMYzE/+i5bzjBYOCZaXigGf2K+mijTuoHJWX0482sBhai6UJ6sxdMoZgPoEuioJAax223Om8PIQJ2YI3O6GLEy167KXqqjSsXlkMR/8pEfEQU5tSO3
 sc8SCUzs
 ePvjI7P7yR04iS2V3w5R4JDKYR+e31gB3QrgisIWuK5J2kbNKG/7opnths70vjsEdI2cYyf8EdMR2zcSaz9guan59qkMrGasrrr0wmHkwapPvJyyW3uTafvvjwad3dMhulrLl1v36OBlPWsYVo1nF9lXEOcr2z1xWTfIxmxQzsNylWeeODGX0fq60CzpbqJQhRGQaWMWtPD0dQOxcQkKs6sLA3Bns0FDzHXat8H7TQ+tgy+3o4nCbTidFOux455cLpOyohTdpXPCkTnAvyMy3m4F7aPWpb3gXZv1hcT7nIgmEQ7NUjoU31lJjWDVYdst0if6OEwMnX08cvbh0OaXVJCjL7YYVEMqjFNMLIm9Cj+3Hw1D7MFgkR/36LMPlgxRsZbXU5FnvPVUjJAuFNvRIXL/iUm5Ov3P4O36YfYnX0zIOEBmCN3LRRNseMYRCr5lmV/BoaW6sVceMy3U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

folio_test_workingset() currently tests the PG_workingset bit, which
is only the second lowest access bit of the folio LRU refs count now.
Folios with a higher refs count carry it in the LRU_REFS_MASK field
and no longer have PG_workingset set, so the bit test misses them.

folio_set_workingset() currently sets the PG_workingset bit with a
plain set_bit(), which also over-promotes folios at a higher refs
count: e.g. a folio at refs 4 is bumped to refs 6, advancing it
toward LRU_REFS_MAX and an unintended generation promotion on the
next access.

Move the test into mm_inline.h as an inline helper based on
folio_lru_refs(), checking refs >= LRU_REFS_WORKINGSET.  The set
stays a plain PG_workingset bit operation reserved for the
classical LRU: under MGLRU the refs count is maintained by
folio_inc_lru_refs(), and now triggers a debug WARN when called
while MGLRU is fully on (the switching window is exempt, as the
classical paths legitimately run alongside MGLRU then).  The one
PageWorkingset() user in erofs is converted to the folio helper.

Under the classical LRU the refs count is not maintained, so the
test falls back to the PG_workingset bit test, which is the old
behavior.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 fs/btrfs/compression.c     |  1 +
 fs/erofs/zdata.c           |  3 ++-
 include/linux/mm_inline.h  | 35 +++++++++++++++++++++++++++++++++++
 include/linux/page-flags.h |  2 --
 mm/filemap.c               |  1 +
 mm/page_io.c               |  1 +
 6 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index c62b5148d5ac..57d24413265e 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -8,6 +8,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
+#include <linux/mm_inline.h>
 #include <linux/folio_batch.h>
 #include <linux/highmem.h>
 #include <linux/kthread.h>
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index e1e25ca0d190..e326456214b5 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -6,6 +6,7 @@
  */
 #include "compress.h"
 #include <linux/psi.h>
+#include <linux/mm_inline.h>
 #include <linux/cpuhotplug.h>
 #include <trace/events/erofs.h>
 
@@ -1725,7 +1726,7 @@ static void z_erofs_submit_queue(struct z_erofs_frontend *f,
 				DBG_BUGON(bvec.bv_len < sb->s_blocksize);
 			}
 
-			if (unlikely(PageWorkingset(bvec.bv_page)) &&
+			if (unlikely(folio_test_workingset(page_folio(bvec.bv_page))) &&
 			    !memstall) {
 				psi_memstall_enter(&pflags);
 				memstall = 1;
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index bca00599dec6..1dd853c10a54 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -258,6 +258,24 @@ static inline bool lru_gen_enabled(void)
 }
 #endif
 
+/**
+ * folio_test_workingset - Test if a folio is in the workingset.
+ * @folio: the folio
+ *
+ * A folio is workingset when its LRU refs count reaches
+ * LRU_REFS_WORKINGSET.  Under the classical LRU the refs count never
+ * goes above it, so this is just testing the PG_workingset bit.
+ * NOTE: folio_set_workingset() must not be used under MGLRU, as the
+ * folio refs are tracked by folio_inc_lru_refs(), it triggers a debug
+ * WARN instead for MGLRU.
+ *
+ * Return: true if the folio is workingset.
+ */
+static __always_inline bool folio_test_workingset(const struct folio *folio)
+{
+	return folio_lru_refs(folio) >= LRU_REFS_WORKINGSET;
+}
+
 static inline bool lru_gen_in_fault(void)
 {
 	return current->in_lru_fault;
@@ -445,6 +463,11 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 {
 	return false;
 }
+
+static inline bool folio_test_workingset(const struct folio *folio)
+{
+	return test_bit(PG_workingset, const_folio_flags(folio, FOLIO_HEAD_PAGE));
+}
 #endif /* CONFIG_LRU_GEN */
 
 /**
@@ -473,6 +496,18 @@ static __always_inline void folio_inc_lru_refs_fast(struct folio *folio)
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 }
 
+/*
+ * For the classical LRU only: under MGLRU the PG_workingset bit is
+ * part of the folio refs count maintained by folio_inc_lru_refs(),
+ * and a raw set would corrupt it.  The switching window is exempt
+ * because the classical paths legitimately run alongside MGLRU then.
+ */
+static __always_inline void folio_set_workingset(struct folio *folio)
+{
+	VM_WARN_ON_ONCE(lru_gen_enabled() && !lru_gen_switching());
+	set_bit(PG_workingset, folio_flags(folio, FOLIO_HEAD_PAGE));
+}
+
 static __always_inline
 void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 {
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 86dd0470da11..c5a8ac0a1599 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -554,8 +554,6 @@ PAGEFLAG(LRU, lru, PF_HEAD) __CLEARPAGEFLAG(LRU, lru, PF_HEAD)
 FOLIO_FLAG(active, FOLIO_HEAD_PAGE)
 	__FOLIO_CLEAR_FLAG(active, FOLIO_HEAD_PAGE)
 	FOLIO_TEST_CLEAR_FLAG(active, FOLIO_HEAD_PAGE)
-PAGEFLAG(Workingset, workingset, PF_HEAD)
-	TESTCLEARFLAG(Workingset, workingset, PF_HEAD)
 PAGEFLAG(Checked, checked, PF_NO_COMPOUND)	   /* Used by some filesystems */
 
 /* Xen */
diff --git a/mm/filemap.c b/mm/filemap.c
index 00fd89cf6f55..c7dac67a0081 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -21,6 +21,7 @@
 #include <linux/gfp.h>
 #include <linux/mm.h>
 #include <linux/swap.h>
+#include <linux/mm_inline.h>
 #include <linux/leafops.h>
 #include <linux/syscalls.h>
 #include <linux/mman.h>
diff --git a/mm/page_io.c b/mm/page_io.c
index 1da4ff484f09..0fb87ca042d4 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -16,6 +16,7 @@
 #include <linux/gfp.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
+#include <linux/mm_inline.h>
 #include <linux/bio.h>
 #include <linux/swapops.h>
 #include <linux/writeback.h>

-- 
2.55.0




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7301CC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 18:17:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F9826B00B3; Thu, 15 Oct 2026 14:16:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A96E6B00B4; Thu, 15 Oct 2026 14:16:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 398E56B00B5; Thu, 15 Oct 2026 14:16:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0EC86B00B4
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:16:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7540F8010F
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:16:04 +0000 (UTC)
X-FDA: 85325664648.18.59A5F3B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 87CD420002
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:16:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ht2xkvIU;
	spf=pass (imf31.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792088162;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AIzu2ujJ44Sw6TgojThJgxm/ErpHJ4akuQl9TN0iWac=;
	b=ZEMya9WfpZFlT76EXRJNItTfDKZkEsWzENTUWauD4mn2w4U4g5zzIKi2oo6+hNh1P27V56
	L1ZQQJlUOZBrJDB3lr7AFyQPF8mUSG2sdUGJTgxDQOFkWX4gFP34t0S5kS6wmvT5Ni1oPI
	L/XWcYKRttVRs7aq5D2JCDGA/e4xWAw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792088162;
	b=3TlYJy+NP8PmptCASSOgvWcJ1AQq2mQuUcoz9Fe5p1uOQxcY6RgS4zCKpQUzUbZ0oUCpWa
	O638yZ9MGW62a7J5pQnX9Sc9vQOBMR/uPKlU5YLPSU/VxL8T0agyUG2KnJQXUm5aWvM/gm
	Cr4Ojz/FsiYsF3n7naJ+JhwX7uXqJ1w=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ht2xkvIU;
	spf=pass (imf31.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8265A4481E;
	Thu, 15 Oct 2026 18:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 64E3DC2BD00;
	Thu, 15 Oct 2026 18:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792088156;
	bh=8cyXuXR2bejdM1i48YPVGkhrLP7RRhUB+l6kEr3xsS4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ht2xkvIU+2pFwdRFiiZT67dWqOOU2NbdtsTsO+mcr6ItXLYKkzOHivvV4uEEy75Wc
	 UGi5DH10Vmf9Y/Afs/L9gQVbTE8gTNbNOnd1Bkkpt1KCwc/vTD/Fze9lf15isUhPkl
	 prNZng0dfw7jqdCaH/oxyB2rYWijJLoB0vZaxRnc5j8eaO4KoVDajiz4bFa3V1F+ek
	 6OEOTh1cfSXp8RkWl4DUYSFThxsJp0J/tMcac42qQWNGliC8y4ZgCJFLQkuef+tGR7
	 tMneffwZpHlQ3yWFGnuqGEhOWv3BUdRM/p4ZZPjie1XvTF8+Ed4Xk7epcisS4lmUXL
	 CFteevLki/ZeA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50D3DCCA465;
	Thu, 15 Oct 2026 18:15:56 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 16 Oct 2026 02:16:05 +0800
Subject: [PATCH v4 16/17] mm/mglru: make folio_test_workingset() work based
 on folio LRU refs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mglru-fg-v4-16-2106750c0bfa@tencent.com>
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
In-Reply-To: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
To: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
 SJ Park <sj@kernel.org>
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
 David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
 Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 damon@lists.linux.dev, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792088152; l=5718;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=NZRuMZ9DHJqarWmmM6IMbKyXzp6luS4trNdMObpwCLI=;
 b=J/5V4RHF/wLROW7MgcSEu29RNBNNJPH06zH+vQfEGTpFxED4h+RDJibV/v5icelk6NMtSB6tg
 iCohZpXYNmiD81Dr07ISj0ys5x5+g+FdQy/Z62fe2TRmx53BTT8gB4+
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 87CD420002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 8nw9ejnjm7deaqxf9eecaauiyu5iz17h
X-HE-Tag: 1792088162-357207
X-HE-Meta: U2FsdGVkX1/79hvbntAR2mWVO6gf8P0oRG9I0BrL4iuLvYac4pDR+q4LgQMl2LS6kFgHRBOEmV+al+zVWM55JW1S0kiFIK54UqKStzH9rfzxpY+VwxaVkPOXsA1g9S9c5aXa+6pXx++XLso+OFUzUQB3cLh4HhZ50xa4x+JIjLnDFk/V4x7i+izRWuQjJ5u8TlPNywzOrX1JDgjU9d1rcxPZl0JtnGpJFe0SGjRn5wkEenF5Ft1ac+xzIlSN6loOeyo0upGGzkMQJs5q1KFCCbOP9IjqhEUpYChn/2KIvV43/k9MMLJOGZlwQEUEu40kk4SMPC7SG/mfsRC04amBWQWUJTKLG6wovoejDUTTpFI/QR04uYzgOBroT1WcTnWlRMurrUD4vTWfcDIS+vhG/rH0E5pHl4KwWNyJQ4l2P0i3fDFm+qzQyICBy6lCdjEcV3gVAo+4NJ1jWlCPx3jbwDLW1w8m2s5qpM9zvOeIWvjjGxPqZKslzT3JS7zLbB55CzaR5wD9B7YUMUsFpb7xuaoRYEU1mqoKnsls7TAYS/UUi8SV9eaivEUX93GJlA96ZVew25ngo4b48rI2Kmz6lw/NDMd7OezqQQekXEU9oGoobIW5HxUjgJwajc+tvF+CjTf5h2rgoRVDhs9JKeZm3pMER/HTBfNw7hNhje46Xxcbe6Vs9pVlJKXNh7ZiKp3t3hu3EWwMwHiqWIv+zgQoFjPeuM8EvxabF2/GtIFIHLH7K50SnidilGVYi3pVGczzmQu5xsT2G1SNAauwdPxtpxjr+dm4bs8dm6D4X3f44pXpaB6VYWb3pfZuZ52s4DVd6yeJwWdHiq8k2qCsSNX9kQ2M3lhr4MgHPjP7gFKJoekY5EizkZBp9fYyzcuFKj5+Fsa6wKqPUHdlWeLwyvmG7gnp0YilL6CaEedYuXp/4j6St8JUENCatDoklj9H2n9IVXtFm/I0ZZ9NQeiFKE1
 1vdMXxQ2
 3lg1KF5VwZN7/Q4I7A5aPu/g699/0lzEVpLWev/b5D/pmHfttACHoXQ+w0JA6eQdQbAUPdfF9Y7diXlGntGT5TaN8c3ORn/zqe4yGgymBsYEXcjGaBTjtDcPnsrirZGsRY3P+aA/IZfuMQFguSle5grT5K7ZwZuOpyfDi7dCGm1tv8leBYUzx4GKK8/PUGw2HYJVJ92vTWt+1TVmU9oC2wYT0b4C2kgg5bSL3aSGZ+Ox1FzUKhnN2KW33YG6M9obhwXgIlvjQ73qhSLgDIkNpqT9SMS4162RjRMVEXBQSCFJk2fdORZTXG+c1gzZPTj/99StU6UITOVce5roGSy6etRu2gJq0kTzKe6ytkoj9WsHNZYGJIniikI8mk31kOtcCwKdJbe0msvycJabd763kNpkcRtJim8zj2HBIaID/Y3B2abeQMOxtxh+Kc+dy6bY5n+YKnI4oLJBSJDCQg3rIrJmf4ZxMUAes1lK1UF5tVNnrsCmrugOegYZAYq34YwUsVsaV8I8CHHQlPnwY+B6tzOFfMqNjlmckr2OgNxb5V4sGZyr0y5bWH2zv1Q==
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

Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 fs/btrfs/compression.c     |  1 +
 fs/erofs/zdata.c           |  3 ++-
 include/linux/mm_inline.h  | 29 +++++++++++++++++++++++++++++
 include/linux/page-flags.h |  2 --
 mm/filemap.c               |  1 +
 mm/page_io.c               |  1 +
 6 files changed, 34 insertions(+), 3 deletions(-)

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
index e981e371d6c2..34ee41e1ccdc 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -6,6 +6,7 @@
  */
 #include "compress.h"
 #include <linux/psi.h>
+#include <linux/mm_inline.h>
 #include <linux/cpuhotplug.h>
 #include <trace/events/erofs.h>
 
@@ -1713,7 +1714,7 @@ static void z_erofs_submit_queue(struct z_erofs_frontend *f,
 				DBG_BUGON(bvec.bv_len < sb->s_blocksize);
 			}
 
-			if (unlikely(PageWorkingset(bvec.bv_page)) &&
+			if (unlikely(folio_test_workingset(page_folio(bvec.bv_page))) &&
 			    !memstall) {
 				psi_memstall_enter(&pflags);
 				memstall = 1;
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index fd77dbfdaf70..ae50f9880da8 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -288,6 +288,23 @@ static inline void folio_migrate_lru_refs(struct folio *new, const struct folio
 	__folio_set_lru_refs(new, folio_lru_refs(old));
 }
 
+/**
+ * folio_test_workingset - Test if a folio is in the workingset.
+ * @folio: the folio
+ *
+ * A folio is workingset when its LRU refs count reaches
+ * LRU_REFS_WORKINGSET.  Under the classical LRU the extra refs counter
+ * are always zero so this is just testing the PG_workingset bit.
+ * NOTE: folio_set_workingset() must not be used under MGLRU, as the
+ * folio refs are tracked by folio_inc_lru_refs() with rules.
+ *
+ * Return: true if the folio is workingset.
+ */
+static __always_inline bool folio_test_workingset(const struct folio *folio)
+{
+	return folio_lru_refs(folio) >= LRU_REFS_WORKINGSET;
+}
+
 #ifdef CONFIG_LRU_GEN
 static inline bool lru_refs_is_active(unsigned int refs)
 {
@@ -519,6 +536,18 @@ static inline void folio_clear_lru_refs(struct folio *folio)
 		folio_clear_referenced(folio);
 }
 
+/*
+ * For the classical LRU only: with MGLRU the PG_workingset bit is
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
index b0ddc652e76c..f6625dc042da 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -549,8 +549,6 @@ PAGEFLAG(LRU, lru, PF_HEAD) __CLEARPAGEFLAG(LRU, lru, PF_HEAD)
 FOLIO_FLAG(active, FOLIO_HEAD_PAGE)
 	__FOLIO_CLEAR_FLAG(active, FOLIO_HEAD_PAGE)
 	FOLIO_TEST_CLEAR_FLAG(active, FOLIO_HEAD_PAGE)
-PAGEFLAG(Workingset, workingset, PF_HEAD)
-	TESTCLEARFLAG(Workingset, workingset, PF_HEAD)
 PAGEFLAG(Checked, checked, PF_NO_COMPOUND)	   /* Used by some filesystems */
 
 /* Xen */
diff --git a/mm/filemap.c b/mm/filemap.c
index b74bc1e5015c..49e827058e14 100644
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
index c6824fcd483e..540ae8caa932 100644
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
2.56.0




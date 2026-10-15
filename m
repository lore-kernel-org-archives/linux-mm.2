Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CD95CCA464
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 18:16:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ADA86B00A7; Thu, 15 Oct 2026 14:16:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CCA26B00AB; Thu, 15 Oct 2026 14:16:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 545746B00AF; Thu, 15 Oct 2026 14:16:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0821F6B00A9
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:16:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 77C881A0113
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:16:01 +0000 (UTC)
X-FDA: 85325664522.02.22D98CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6C56940008
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:15:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CV8B2hm7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792088159;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CRMQ1PcFZ1KOHweeqsSY9HsQNlavG/+QfwWpQxf/HXI=;
	b=yhCXJ+B4zmg0IWMWrUF0Q59h6iYLXpId+kW26d8/k/HN8GEuDjPuChUHgW3t9Os57efiAR
	9RKz2S/6o9FLzmLkC2uTxBPOJcddyJ6MRUfNPBHWpiISZMw7Z1Zbm/wLWpzRtoiTwL2OEF
	/rx9Xz6gTmh0jugBJtv7ZEs2kMZNjGc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CV8B2hm7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792088159;
	b=FaDip50V83SoUIowKDdDBe40oBgy8H068Pmr26K+Rmdz4eh0lmL2KekKv3jBPVxopZ3lJ5
	tt1bExVJQ8fX9P1TLZt6UgtnNlJhR7GkfETgfFqRcBdSR3ONPNXRI3bS3ZPDkm8y2n6vbC
	WC3r5jNOdflzxfoOGb7eF4m6Zl1Wxrc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D9809447D7;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A7765C4AF13;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792088155;
	bh=U0XTsJ3+hlRGEX8wHc1IuMeoyed0jAtILmjU1NZvH7w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=CV8B2hm79IL3au/BRgJceXAVGFB0b7K12Rr/NWqEyNnbXX7amjLfdm0wluVSsFgRF
	 WborxfzNSPU0rmjfSIWbHFPm8OK1nC7jDJDNiz2+ipusnLqOPJzOHNpxdTfZrjfDE3
	 QFRiOPkJDhbdbSkosH526nz7dxALeVQudDkxv6FzWHJ8nkNXUxeoXZnJLfTnvi9ZbK
	 NwxsO33cRf0ekSetDlPycUKFfGV8L7ifiuaCHjefZ+DJOd/K5MgOQk9YKTAq6Qd0ww
	 ZRSKfCO5DSbv6EfJU5uoOLGAdznGii+X0XmtN9KGamYSDj0f+nLhBh15UXyGnYw6Nm
	 wR7PrHqHy4/Zg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90207CCA465;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 16 Oct 2026 02:15:56 +0800
Subject: [PATCH v4 07/17] mm/mglru, gup: mark folios referenced via a fast
 helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mglru-fg-v4-7-2106750c0bfa@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792088152; l=2648;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ITEZgO0dikHo93wyt9sJ147BaR3AkKEeJae1nLOf4S8=;
 b=m7t9PG61hS7nPGevrgY2lLxFygT2BRwOkANXUPK9pgm7cjzydaFuFNGer2+HyT8kYNrOODT8f
 JQDjMBv3q9CBhHyCf1aD5G9FDxDU4iLASn7H87eMqcXifIm9Voax7yj
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 6C56940008
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: p7fwrmfy7ytnia1comw94jqb5q4y9p19
X-HE-Tag: 1792088159-340670
X-HE-Meta: U2FsdGVkX19i5mBcDDBlyG1GHRw3XKIWT49Y0rOiP0fFwzwwZBEyyvWnG0t9m6XE0D44wj3eyHqe9ACJhBTcoJUvIYJR5FHf1fidvjusPHA1QBATIvMahf0vkY+DxlG4/e/xi/4qfmQ2oy7QTie6WgUDQmNW9OS4b89eRTh9HvK39nY1ZJKTTYnonBKrWB3GTabcEiPSgN0DZODtkTj5TW8i81+LizbEHp+WgstCE4yM3HXd37DvrnZx+9Eau0y9EuTeS5+osNFjw1yCRb5V2iXXObxQ1hkCugh36jH3Cyg4XUPmno1L4RHKVaWmMG6Dvy3eQM30hAeN2LUIa90T8WC0CN6in7FGhdxUDFTeXVp52GMqIdL7NXgT9QHSe5hOZC9CkCIzALiEn52ApnQH03RdSCm68OTtLD63duZJktaChHjVOmAArH0e9yWzfC6D2Ad0w23rEN+1uxR/qWRyVH+PIWlNQhNzzvWoGbzeU24awFsT60W9ArZ2fjVhAizJ/mK+klV+cmOdWJWlRMXLSOl4PgwNG2K99CzQI+rPtg1AeHG9I0QbG6ljD1MoSY0Vy5QrKlibSmnnagMqQTLJin0cpSNIcBon2Mikhn0iaMIjaRbOgJvAUZROiAB+rFnbQJm2Ne7jYgXrO3HEKyrC8Mhe6WAOgk6sZeufla0qEcQqmAKvhLrpm57tfDauXlQfeeOB03mFWLLzeJw7Vd3fyCqlXH6wfKcBfyBwxyA4DScJCwIuRobvP97F/PcqEMVOSjpdwsu320afy+cugaj0ZgFj0HP2shFwcYaCJSxgFH7eXAqvTrdOoWA8tbR5OzQXs2VinwJVjSwxFUDT/z3ggFL8sF2Bp5sdh8EuV+AZTR8zwBXHptzlkMjayLcxUINRYpq8mX6TBYcfd0VRAapDPm+/wXl8a2Sw7hLzC8fxxb7BiiDqwOgTpte0auh6hztLen8hBY3rb5v4TuGcHwj
 zlFTJNX3
 V1+lJqCdOgPvkT8LHf6fLBX0+nSJSZkcHKkUhgbwNjwLc/Busch9GShc16ktvH8VqG/hhtKnsau+u5YfQde6rcfjPttM8i/F38G37qrIcbI7ujdkXaJfn7lDnjSZ8HI6q07RAWqkitGEDLaciIgXlEMbpcB9gBOgzi/a1GfTJgJlQziYl8dhyc78dIPXzeQ/96XS/LJ89QVcbRCZDFcwjPf+2+JQDrbpDJm4IoY/rVdMmJkyzHV+CR6wIWEtNAiYeFIcaSNdUP8BWMKDh4SbhBtvsWQbIk9pJ6/5CopJtWfFLTqvFAiXieaKkF8SxGtuZieC8pSImgzzpDm+fgqnXTo2GA6F4it0QMu1+kVxoWa0OqoC2ZhF+tZVGqYFADjZrLCiPw5OmSF9mZoeGCzU/4clY3rZUTUUr7nCPo5AAY0S2itEcrEFCUUkOxe97OSqjszH+Jh/Vlt95aormLB95I70r5JHdH3966+JXRu/DZGor/YS/38p14ePMgZ9Vqyor/8zQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Introduce folio_inc_lru_refs_fast(): raise refs from 0 to
LRU_REFS_REFERENCED via cmpxchg, or just set PG_referenced for the
classical LRU as before. No counter update, promotion, and guarteens
no other complex operations in following commits.

Convert the gup fast-path sites. No behavior change for classical LRU.

Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 25 +++++++++++++++++++++++++
 mm/gup.c                  |  6 +++---
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 65415eeac802..effa13c63632 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -454,6 +454,31 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 }
 #endif /* CONFIG_LRU_GEN */
 
+/**
+ * folio_inc_lru_refs_fast - Bump folio refs count without promotion.
+ * @folio: the folio
+ *
+ * Raise refs from 0 to LRU_REFS_REFERENCED and leave hotter folios
+ * untouched. For the classical LRU, a plain PG_referenced set.
+ */
+static __always_inline void folio_inc_lru_refs_fast(struct folio *folio)
+{
+	unsigned long new_flags, old_flags;
+
+	if (!lru_gen_enabled()) {
+		folio_set_referenced(folio);
+		return;
+	}
+
+	old_flags = READ_ONCE(*folio_flags(folio, 0));
+	do {
+		if (lru_get_refs_flags(old_flags))
+			break;
+		new_flags = old_flags;
+		lru_set_refs_flags(&new_flags, LRU_REFS_REFERENCED);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
+}
+
 static __always_inline
 void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 {
diff --git a/mm/gup.c b/mm/gup.c
index f166acf794e3..b3f563d41192 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2896,7 +2896,7 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
 		}
-		folio_set_referenced(folio);
+		folio_inc_lru_refs_fast(folio);
 		pages[nr_pages] = page;
 		nr_pages++;
 	} while (ptep++, addr += PAGE_SIZE, addr != end);
@@ -2965,7 +2965,7 @@ static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp,
 
 	for (i = 0; i < nr_pages; i++)
 		*(pages++) = page++;
-	folio_set_referenced(folio);
+	folio_inc_lru_refs_fast(folio);
 	return nr_pages;
 }
 
@@ -3007,7 +3007,7 @@ static unsigned long gup_fast_pud_leaf(pud_t orig, pud_t *pudp,
 
 	for (i = 0; i < nr_pages; i++)
 		*(pages++) = page++;
-	folio_set_referenced(folio);
+	folio_inc_lru_refs_fast(folio);
 	return nr_pages;
 }
 

-- 
2.56.0




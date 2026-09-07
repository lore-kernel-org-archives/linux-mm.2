Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79725C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 18:12:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADBCC6B0098; Mon,  7 Sep 2026 14:12:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3EFE6B009D; Mon,  7 Sep 2026 14:12:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 891CC6B009E; Mon,  7 Sep 2026 14:12:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 59E166B0098
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:12:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD1C6C01E8
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:20 +0000 (UTC)
X-FDA: 85187760840.16.8CC3B17
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id DAE1B4000E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YdrkK4FL;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788804739;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K1dKUIoWyE5sz1E/yPpK1ty2BzWLkfFcL3ztwB8Clts=;
	b=XeFMJ1NlAydLcEFVQUkjT0TjBi+oG2OjXdbgQOj84Jfo7Op8uxZWwSw11Ad5GWAdHoSmTQ
	rxbBqHdvU3wWOhP4mzdWXvwvYRYerhDELE7RpaWzkCXbBGHeEpxQeuxXTefSmVM1iKshcu
	FKmkXOEZQ5JLIFS8r8Ey/meOHoHFKc4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788804739;
	b=SugGkY4cdCP4M6sY+y3zjQ39utUm9v2brdzLhzZLST+RWmnHVPOfEpoB6Jo+qxZ275G+o/
	6Oxa7O2HLlEb/m0s5DWpd09CgcoCsoOpncg76U4Da9wOpqmmTzQxE+PEeV1WzjMuLh2U1W
	FDWYdjjKDWTJr7ulqIfR5W70av9Q/lc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YdrkK4FL;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B2AA4403D;
	Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2C5FAC2BCF4;
	Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788804736;
	bh=Kp+saGqgfVHTFPckrEozr1au3f5YEP3Z32PBrb7701c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=YdrkK4FLFduabVFNi0Q0otWarEOgfkgXLWJURMRHQiKIDrnrcEQtl1vNFiZrVjiMp
	 xcaLkU5uK+jAX9UsHEs2lY2ciexXVitmSn+eLL8wgHTJXyBh0MN32YGsj9j5EFLCNF
	 eJxMRtJ6XTrdvSMlUzBorTBao1iECziRJIQZMh2WS6GKgzpTKNloFuL5ZG6TLtpiJt
	 yPFMi/zAZ+CwmK4sll7MxL35yj+wHgJedm4OXRJrDIm8fhYz8+CvunXCSQQkqljESR
	 JwVB0IKgH333C4HNS378P1EwExehVQRDnnK4doIiiICwLTwtT+oGdtzA3GnzJkQCs6
	 QOnpBRImdlvHQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16331C79FA0;
	Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 08 Sep 2026 02:12:10 +0800
Subject: [PATCH v4 06/17] mm/huge_memory: consolidate irq and locking for
 folio split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-swap-thp-cleanup-v4-6-b532a3f20e71@tencent.com>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
In-Reply-To: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788804732; l=4844;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=53UDy2nNH5r0qRCm1hHT5ySIpLRkBQgkPRBtLrEgdWQ=;
 b=IlEriGK3IEX+/Zbm5O2sbGuRjSFvDExSvyRDZiljCnBM5NTtwFZETi85va12V9lj2yDsmb+Qg
 3jBwUtZzf9VA8ohnJylwlI3k96DzdI6N0Vfbwtq0BfrlB8osxYQto1q
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DAE1B4000E
X-Stat-Signature: ekhsod66qayfahz68r7tmxsqjwsnonoc
X-HE-Tag: 1788804738-76233
X-HE-Meta: U2FsdGVkX1+3Vyf08yx1/6ZUnJ5fjg+/9soHrfNSmUgRejqL6a94x27FfDr6oqhtXu5nok/6ZpgmBKPVutmDWEncwVUAD2IZVX34pioOASAPaHgIKrgwxkYxjxfx1x4TyPt3oTPNfU8z6PbIfc3X/0uazEg33lLRJU7GmR0vImbxeVEu6ks8HnA3kdHZdO4v/q61wg2b/1hoP9fY+XVMhg+2ONMVM+4/2NPlxC3e9D97e/VoV0u7AXZoMw/4YSNjVgng/DxKp0Aa3pfkKKbR8UjveK2seqhbYJnpV4pJmLyH9NNf0ZWMKLyiEbfLwv/It0Ip5VV2ZJUWAh/g+0P/t/Nkhlktfzoa81/d6R8jWzlwbvobmusnhFbHX0S8HkR00pv7Jgy9i24O/Nm8FjQonu54yxlQs2bhgycUNyieK8aD2CMOE7be64KNq/IFR7DIqdTDKVDIHnJvGEFfgXp2VvvfpXjogl3qMA7SgarzmJ+hmIoVQ2cwUB9C3vvPvNtayfj9/5AgTDdQqTadpcwoCUjQ7+2glDdxfLzAQlGQkGcH14lt33WyWtLXMFP8X8DU9Luf908zMgUqmYP+Uwe/olY/V4ThlN5Mg/dFGJqjzlqYmo/B3joi4W9gnoYv8Mc9Vz1kNXzcYHlSqh+tIY1XbQ57uD/jmTr4BeOv0/MF3XMOK2Qdx4Aj5yuL/mqT8mI/1Q2N1A166zwL5k5zBQsyyNPrssFNa5jECPUwHKtMdB3N1kFodh7id6uC683uqkh/DJbYZzw7hsyzXacRzpYfH2EU/ozryuMdt48tkRm/kpb8ZGmpmvFzORxkSQKuNtwCqfdNXWfDpPWGkG2QlJNi9M4QY39D4G7uL/ZncMC8z2nQ3XT39TEatYr6OZXnWGnHbERH2OHpsnPf8demydeQJFU9q2vqYejf3A+LaNl6kMNS9P6dAoND701dk+x+x0icMJZsPn8xYS0XCNMo7fn
 2Yg9NiMB
 jJaaaaJD9h2CDhPvar1HSZU3pU3H0F7xnWflngHECMnw1RkY0WTuJkgWd/7w3Y/WJnkz9JDznh6nDjxYqL/MLw6aqreDdYk/aQy57IiuQvvuUvu/IgcAAtPcFI/+Az+3g0C2BzaAnSquXa9xjKAaBQ4vKaAPxc/84ZTIrxJqNa9/h7ZDjVnvvJjcYER6Ekytk1uZo9lNjRB+Ox0U/5QKwiSeno67I7ffF3C97ZY8g9QKhHJOd6FynRyRjfYPQyzQM+QUxRV2yhZavjohw3ovGNuYvHAFl4jHI+H8Iz10xsKtxHpogim2Oah4qC/IaQGgZjfsGIOMpPr7e4jedE6D3Pq4ROJnKvAvSu2gtmcggQF3ZdJlJJUWAOvjnlL4ihf11C1s/xop89l7M7b+Rtlj5Nz3R7UaEHNmdxebRj8TySsX4Nq5POWUehBgDpPTkn6ubz44lDdmssTWOSXvUm+FrwqHlMcve2rKt2QotccBPr4A1MJ/Lwai4Ytcp7G4ENeG1wxxYH8SccJIekcZmtGU02RhshmMUfaiUtQVXDi79x+4spgQ0ZZW3fn6B2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Let each split helper handle its own locking instead of relying on
the caller, so both helpers manage their own irq and locking state.
This lets __folio_split() drop its local irq handling and fail label,
preparing for further cleanup.

The file path now uses xas_lock_irq() instead of local_irq_disable()
with xas_lock(). The two are equivalent on non-RT, and
TRANSPARENT_HUGEPAGE cannot be enabled on RT anyway. This conversion
also buys consistency: every other place in mm/ that freezes a folio
while it is still reachable through the page cache already takes the
lock this way. This was actually the last plain xas_lock() on
mapping->i_pages left in mm. If we are going to support RT, spinning
on frozen folio refs could be a problem, but it already exists in
many places and should be fixed generically.

The anon helper keeps a single local_irq_disable() as before, because
it has to cover several plain spinlocks at once.

The dropped xas_reset() was a no-op as the xa_state is not walked
before the xas_load() under the lock.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 58 ++++++++++++++++++++++++++------------------------------
 1 file changed, 27 insertions(+), 31 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 80291fac78e2..4ddef481cfdc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3998,8 +3998,12 @@ static int __folio_freeze_split_anon(struct folio *folio,
 	struct lruvec *lruvec;
 	int ret = 0;
 
-	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1))
+	local_irq_disable();
+
+	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
+		local_irq_enable();
 		return -EAGAIN;
+	}
 
 	/* Take off the deferred split queue while frozen and memcg set */
 	folio_unqueue_deferred_split(folio);
@@ -4051,6 +4055,7 @@ static int __folio_freeze_split_anon(struct folio *folio,
 		lruvec_unlock(lruvec);
 	if (ci)
 		swap_cluster_unlock(ci);
+	local_irq_enable();
 
 	return ret;
 }
@@ -4069,8 +4074,21 @@ static int __folio_freeze_split_file(struct folio *folio,
 	/* Currently device private folios can only back anonymous memory. */
 	VM_WARN_ON_ONCE_FOLIO(folio_is_device_private(folio), folio);
 
-	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1))
-		return -EAGAIN;
+	xas_lock_irq(xas);
+
+	/*
+	 * Check if the folio is present in page cache.
+	 * We assume all tail are present too, if folio is there.
+	 */
+	if (xas_load(xas) != folio) {
+		ret = -EAGAIN;
+		goto fail;
+	}
+
+	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
+		ret = -EAGAIN;
+		goto fail;
+	}
 
 	if (folio_test_pmd_mappable(folio) &&
 	    new_order < HPAGE_PMD_ORDER) {
@@ -4142,6 +4160,8 @@ static int __folio_freeze_split_file(struct folio *folio,
 	if (do_lru)
 		lruvec_unlock(lruvec);
 
+fail:
+	xas_unlock_irq(xas);
 	return ret;
 }
 
@@ -4281,32 +4301,13 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 	unmap_folio(folio);
 
-	/* block interrupt reentry in xa_lock and spinlock */
-	local_irq_disable();
-	if (is_anon) {
+	if (is_anon)
 		ret = __folio_freeze_split_anon(folio, new_order, split_at,
 						true, list, split_type);
-	} else {
-		/*
-		 * Check if the folio is present in page cache.
-		 * We assume all tail are present too, if folio is there.
-		 */
-		xas_lock(&xas);
-		xas_reset(&xas);
-		if (xas_load(&xas) != folio) {
-			ret = -EAGAIN;
-			goto fail;
-		}
+	else
 		ret = __folio_freeze_split_file(folio, new_order, split_at, &xas, mapping,
 						true, list, split_type, end,
 						&nr_shmem_dropped);
-	}
-
-fail:
-	if (mapping)
-		xas_unlock(&xas);
-
-	local_irq_enable();
 
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
@@ -4390,8 +4391,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
  */
 int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 {
-	int ret = 0;
-
 	VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
@@ -4400,11 +4399,8 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
 		return -EAGAIN;
 
-	local_irq_disable();
-	ret = __folio_freeze_split_anon(folio, new_order, &folio->page,
-					false, NULL, SPLIT_TYPE_UNIFORM);
-	local_irq_enable();
-	return ret;
+	return __folio_freeze_split_anon(folio, new_order, &folio->page,
+					 false, NULL, SPLIT_TYPE_UNIFORM);
 }
 
 /*

-- 
2.55.0




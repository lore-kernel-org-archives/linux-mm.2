Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA639C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:33:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F29566B00A6; Wed, 23 Sep 2026 17:32:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E64426B00AB; Wed, 23 Sep 2026 17:32:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA0E86B00AC; Wed, 23 Sep 2026 17:32:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93D596B00A6
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:32:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0B5EE140142
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:49 +0000 (UTC)
X-FDA: 85246326858.11.59A3103
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1096E1C0006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZXhznrxP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790199167;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wtAQVfl9CXno9aGhp+r+xNVoQCizXkrriG764xlcu4M=;
	b=voSS04OgIWO2JJdpP8+GAe0IuBlRLdL6eza4a+SIE4h20a5d7z3AnnojN8gvpq9W2HOKhE
	9a1NCZqAdxCSqeGC1V0KwovTqUV060aRLl38ri0WUBQlybfAbJWQ3xHyFBBv/mRg8gXAqd
	SKTD2b0LiZfql172WpbJes7PGVP/KT8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZXhznrxP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790199167;
	b=31LQEkGafnAASXk3l4OUYGuJ2LlvbKVwuViszxoOngweyYd9G7hS309fst5BozfagYEFJ0
	z37yTBBDURY21+Szwk/wdgpV3knTYDoLZzuaxQ6yP+eGZurwxsdWSNzWfPrISFTGT9sauI
	vuSgPUIzzeb1o6MB7y0lqnz00shIagQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A67D44500;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 79EB7C2BCFF;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790199163;
	bh=cBInc2Y150gnR9QShVRFXkTGJvi1jKLY1kMb8gVdedk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ZXhznrxPcf2EstKnav+Pa3DT7m31Go+xL3r5SL3BQBI4zv27ActRYMFiHs0dNP3cZ
	 xfj2BtdiwGLa/ppCC/SRKujeCXImEXws+q8CRtAQsO4PWmcTI+PJcB0huqugQ5nu+t
	 xkwzZU0mFjb0NXumMxDItUfq52YnPJnItGYmPXRDce7hk/eV6Nv34IxMpp9rN6c4c7
	 E81F1kHF/JQPffVdRMmVWMdhI9HNjk9Zp4cSOuD3Gmyb43DinchPrCyNzDL9Lx6YJh
	 xF6Nti8agQnvRzAr8lDwdvfFfXI1uVHdX8ZTAuIwO3g433FDUL+PROlGTw4dL/xpr9
	 vQPL3CplyeXzw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65D5CC98312;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 23 Sep 2026 23:32:39 +0200
Subject: [PATCH v6 08/17] mm/huge_memory: move unmap and remap into the
 split helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-swap-thp-cleanup-v6-8-ba1b4ba72c6f@tencent.com>
References: <20260923-swap-thp-cleanup-v6-0-ba1b4ba72c6f@tencent.com>
In-Reply-To: <20260923-swap-thp-cleanup-v6-0-ba1b4ba72c6f@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790199160; l=3700;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=bG37iOhPck6tDgOBAYXQonkZfp1LV5/lDeTBdSogHrU=;
 b=8K1WXT22OIwKUAR2XaU3sTnYjG39/waxHTBKElGxAkw++akKW5L/02mUG2pKRHVLdsftyZjOA
 cog7IfhNcd+DQDhBoo/MyGV4KGyGgowBxJoahQDy6No6z8kLowN2raZ
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: 6fhw4n4bp85do8rx8xiwdrfxzzsp3itj
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1096E1C0006
X-HE-Tag: 1790199166-757292
X-HE-Meta: U2FsdGVkX18nvqNLxQDzvoXJWNWVRXvbNNTSK585EsN30TE+NeDARxGc+wVB2wA8CIxC51MJUJuJd7lZfupxn3XEM0scCMl8VJIGPjTd+7s0z/bmbZLGkdNR9YxizG7sSf8G/N9RRqaBwOVS1Yxeulsa+r5tgAJ0JAAhXEYXyUb6N52WjnAASvpx5X+0QmUpleyavAlkoNiRiLnVG4TBntF3Q7okvxtfCb0o5fVEsGLc3HOSh4xMDFZSJ2qaD6HubQKmzfuuYde9Dwd6IeoPr+/yf56xfRsg0Ok5U+KEalXzFscVo/cwg69ngM8rlblmMqB7GjzDQ2jdtDf5ZHmk7on6D4h9qiF1r9qZrGFPQCikevUuSlVKbPj6prxB71cZYTmJlEyK5TANNOOqHTxVXn01apf2yYPTGWURl6osg7guZCw/UNPCH/mt2Il7wF6+GdTaPvDD9eBEkvPRx0/UPA6NyEpHyKt0Ma6AJVfMS7DadVFeRHAANW8P9/MLsW9yffK5MzW63KyPFkkPPL/Sw9tex8YoutTAdPUX85VQH8FYiWRGDOSTQN/S+YFqmqYIyX+jScahZ1+tHvAsR8xIDbgQuVGbBB2rdrbVWpFlNRKkuzEQ8lk2pChJNN57Hhi6nCu5z8zn4Jm/dbgQ2N7WXyozfCCdJIHKvhhE05X0+u7Nr/UFgUfJbYErAtOJ6GEfcqoWdNHfN8hEuHWLWcUd3rC67RRmEqSbJbQ4jYn2nFVcb5RTb4rUp+ZHRCwMrqcRGItdc9mj20Je4NsbPOlSjdyHuBSwRqv/rCiv58LT9c6IP/GJwxRzeNlCDChpSBPpRj7C+W/jU3xKB+N/rrdqw/57Hh4S7Q8d16O73WSs+CFTeDuHhwwx8djrHWT6+iUnuNak6tV/orQb2o0hiV5HDjlNZgXdx9iJu8G/qNNl7b8vy0Z903hcSGya+j+Fb9tV9oNDxnKI1dlA4qwW3NX
 TyJoqIf6
 7Xec7zONGf+RVBPMXcGtY+ID7VAFOrrKWyuCN4zdjf7XnT3TYefUyUgvamyH8MwkszBZLBsgaRykGdxDkliogVzgrhlL+L0vQjPa/N6q7YW6EUOpyWiEG04JbLE85aYFR49Ol1dBDe8ZPEeowcv9UN97fSWSbRchqU89LJC5Fvxy9meerr/CEHX4DISLCZwhAODC1kovEWyR5cUGqfgw6lc0ZAfSJH5C3/p1lVhBqoGLDe2I46iViVDtvxBEBxoZ7QdxglcQQhpiH9N4vJF4Q0lexqY+HXsXmpogn3Nld6n3rpDSqFk5vsmkLKQ4GnLcrjuvOWlTd1QlShJx7JiuONsKH8V4uHD4Ptqft68CxvHKuC/Ly4vQ3F2U4T9bE5uC4JXEUta4kGWOSEuXCiRKyaQtr4Tmfy3fvXG+nNqyYncJ1bn1NX41GHVEHFyWFHIklVT64Q9ydFJAzXt3qdKJBaRRQrqsV6pUM1MzbZZJ/OF4aeM8ZrUGnGHIcz664d/v2rhP9jh0wYmSTyvrJ8lQd9J935IEUbsYI4j2jslPx1rqtfxqb8+yNK/qNxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

To prepare for further cleanup, move the unmap/remap handling from
__folio_split() into the split helpers.  Only anon folios need to
be remapped, so remap_page() is now only called for anon splits and
the anon check in remap_page() is redundant and can be removed.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 625e7987ff40..7ee9eb2e1e93 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3640,9 +3640,6 @@ static void remap_page(struct folio *folio, unsigned long nr, int flags)
 {
 	int i = 0;
 
-	/* If unmap_folio() uses try_to_migrate() on file, remove this check */
-	if (!folio_test_anon(folio))
-		return;
 	for (;;) {
 		remove_migration_ptes(folio, folio, TTU_RMAP_LOCKED | flags);
 		i += folio_nr_pages(folio);
@@ -4016,15 +4013,23 @@ static int __folio_freeze_split_anon(struct folio *folio,
 {
 	struct folio *end_folio = folio_next(folio);
 	struct swap_cluster_info *ci = NULL;
+	const int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
+	enum ttu_flags ttu_flags = 0;
 	struct lruvec *lruvec;
+	bool need_remap = false;
 	int ret = 0;
 
+	if (folio_mapped(folio)) {
+		need_remap = true;
+		unmap_folio(folio);
+	}
+
 	local_irq_disable();
 
 	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
-		local_irq_enable();
-		return -EAGAIN;
+		ret = -EAGAIN;
+		goto out_no_split;
 	}
 
 	/* Take off the deferred split queue while frozen and memcg set */
@@ -4073,7 +4078,13 @@ static int __folio_freeze_split_anon(struct folio *folio,
 		lruvec_unlock(lruvec);
 	if (ci)
 		swap_cluster_unlock(ci);
+out_no_split:
 	local_irq_enable();
+	if (need_remap) {
+		if (!ret && !folio_is_device_private(folio))
+			ttu_flags = TTU_USE_SHARED_ZEROPAGE;
+		remap_page(folio, 1 << old_order, ttu_flags);
+	}
 
 	return ret;
 }
@@ -4105,6 +4116,8 @@ static int __folio_freeze_split_file(struct folio *folio,
 	if (shmem_mapping(mapping))
 		end = shmem_fallocend(mapping->host, end);
 
+	unmap_folio(folio);
+
 	xas_lock_irq(xas);
 
 	/*
@@ -4189,7 +4202,6 @@ static int __folio_freeze_split_file(struct folio *folio,
 
 	if (do_lru)
 		lruvec_unlock(lruvec);
-
 fail:
 	xas_unlock_irq(xas);
 	if (nr_shmem_dropped)
@@ -4230,7 +4242,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	struct anon_vma *anon_vma = NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
-	enum ttu_flags ttu_flags = 0;
 	int ret;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
@@ -4318,8 +4329,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		goto out_unlock;
 	}
 
-	unmap_folio(folio);
-
 	if (is_anon)
 		ret = __folio_freeze_split_anon(folio, new_order, split_at,
 						true, list, split_type);
@@ -4327,11 +4336,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		ret = __folio_freeze_split_file(folio, new_order, split_at, &xas, mapping,
 						true, list, split_type);
 
-	if (!ret && is_anon && !folio_is_device_private(folio))
-		ttu_flags = TTU_USE_SHARED_ZEROPAGE;
-
-	remap_page(folio, 1 << old_order, ttu_flags);
-
 	/*
 	 * Drop the mapping while the inode is still pinned. @folio stays
 	 * locked and present in the page cache until the loop below, so

-- 
2.55.0




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0082C5DF86
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 18:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E5486B00A3; Thu, 20 Aug 2026 14:55:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61E6E6B00AA; Thu, 20 Aug 2026 14:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5555C6B00A7; Thu, 20 Aug 2026 14:55:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C1AD6B00A2
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:55:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81AC6C026D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:33 +0000 (UTC)
X-FDA: 85122551346.01.F3D435B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 88F8140002
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Uo+Be2Ps;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787252131;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rd3LJK7L8uJ8Ye4NCYbMcgiyjka9tpqOOG5vckVSzyA=;
	b=oVdvXkdDE98IpwsCQmLYg0ZenzpkRlhWYp39SeOuEeHD/gEdMDhLAs2/hvOWUu4jNST8OR
	65VXXCeFri2zyPkElLMEvp3NZMI+u/MxeSvbNAEEbcZsmHtDMj9jLOMToW7vFgEbaDsJdI
	8dksuNRRGeg8AZ2tZyKoOcz1nOmDM64=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Uo+Be2Ps;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787252131;
	b=PGRVtiZf5Uw56V0cFure4JPJXdl47BIaMnlzTRUOgbwWMmC++rnGQfkq10hTyhLG4s8lYI
	4rzPzGMkNBv6nxCWGc1DzEqW7pDd8P0tHJHXUdCmoMMjoIrEROnnSft1BGVOz2OJBoA8qN
	4Kn+dgY6BOx8MyNiSdI66y6FOPC9MNM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F812440AC;
	Thu, 20 Aug 2026 18:55:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6FA64C2BCFB;
	Thu, 20 Aug 2026 18:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787252128;
	bh=XliG3xrzz9pN6Bq3jcef9F6/PirhKUf7omvzTzDPdXE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Uo+Be2PsQ84iKgIMTOVONuKNsAB9EbnXAvTwTVL8xUqeSqgIKa1VuU54BBwGXYMYE
	 WcnUQYbyTS80bn+0va9KDtHUHp07i7P8Ey5142h1A6tbunUQdRKR/PAjGFx649kSvF
	 GQafhgqXLIb4I+6dnhCcSK1yBGcHSMNObdbyjfh5zfISuhEjjhwKRLSTgJps53+dXz
	 yE+uxUhN7Pj5jhykGdGjWLoUk5Aazlk9GoMzqygkhy0U2mv+eF9RpGmKbFLTc3thAW
	 opkoLtIlCTSqz0GUSjCyHZW89ZgHBUT+63FCEROc8CINyCYZyQAqrFSOMGcPKlZHyi
	 cOU5hWPkFaLPQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53714C5DF8C;
	Thu, 20 Aug 2026 18:55:28 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 21 Aug 2026 02:55:19 +0800
Subject: [PATCH v3 06/18] mm/huge_memory: consolidate irq and locking for
 folio split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-swap-thp-cleanup-v3-6-9b43f5163238@tencent.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
In-Reply-To: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
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
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787252124; l=4821;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=kg6VQFGolmACY/RqrJ4EQVqIYb6qG4JCJfoecxkhaQ8=;
 b=0Gg6pZYKuwo87RQUWCu22J/1MzcNTDa0eVW33D/XV5QjuKjak/B0oiR/Yyrb0uXB6rJzXUXod
 2M8kJx7HXGcAFl6LWyj3H0he4N+ALtRRlguXeqlVnLZ58r1ar9ndSUu
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 88F8140002
X-Stat-Signature: kjf9tbcu94bepti1xqyae7b4ybt3q5fz
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787252131-353187
X-HE-Meta: U2FsdGVkX1/KOGYoHx8NcXzzMveuyBk9hKSCxPiQSxaw2rbgoOl5nhn1KlO1vSJzWE9XKnQgLRV+QvNUQl5yrZCivnKvS6LRq55zNTko3qvphX/UaoBjshQ7Ckf8J3g+UfST4MljNZt//PF7ffvxG0PpinYhstM0f684mJKymsIpRI+Z5U0o/w5cc7zmWTA1dPu9IC6VJBfobfRrWYLKADDAgfg1/anmSyNYKN5P7AXqtCD+r2VMNpm4No3zP7OGAua5eBhsoVcYQVfw8AVcERaczUY1mesJ8r7SsmOs5+bIexY4UYN/ntuOprlrrGyayACGVPVOTw/gKTU/AAm7aD35200BhOwJLJWEgdaYwVZ4sJPJHRuMmv7SucNR1g72FmTZtSorT6FJA+nOvNfPE6u8BOF/WtkQUsCTzvY4/nDmkMY20QGuMG7n2Y74ExBsuPeB6nibg94li64qCyNeewBKCb0x2xcdiVGlgfOvgwN0c8JSdOW/+blcpmzLabgcSG395XrS1Bdnj+zwMr8d/tq1goqtv68L+gtrrJbnnblfSFzSn3ApZr0eW+Knat/YcPIj14Tj7WLwSsWmF8CeYNH23nVHAMNlV3pcDW2s54yD9GB9FAI7RftAyFReFvrIAPESPTRph5MhmmmTWylbtDuZqlsPLX7uGEPJcPrp3eFlTb8RF6HbmUMy6p6HLkS8tVvvVfToDw72aVrNphZNnP4VCYC5NGhmSanPKXKJRwn2F3WrSWZtuJBlgRIimNeotMZ57wJwgPN1PcIU56cO7xjHDRVVcshGNU8yoJdhLrKXEoHVFGBev41b5u+9f/+KPPhp61/ZIWNddJ7zLSK74hl3AVQxyXVLoe0pRVQa+mDIYunlbwshuHYJIa3FbZ8ldTq+e2hKr1vy/0o/aHPc+q9IN6k5tjk30ZxBNC5B1PXAzOn+fQggv2pcv3KYN+kXchC+9KyjvFkh52i79X/
 zwfBLR7j
 392gjhE21GM0SJMn9ujwkgnwMW5/dZKPCAsxhQmIHGN/O4JJwZWROOuFefHH2HU/NgaaiHgl5VKUDsM3Tch14gBPzz76jMtSLl9UQMUzB3WOb9q9fkmImzbWxA1NP+eDeKy4BJe0HEhTqW/UxjwbiCiP0DmIEFy2ndbaM1NGKVyJ027pcZPaZbmWF7iiniUd+jFAYOerAqJgvWKNigd4301Z5ULw4Ydw1/ZpRviZZ84Z9raYa5XfLJ8XOXznq0LF3GMvMnfVcYgU4M1iYu+ma9N3HhmL+phe9i8yf82azzbQEBvYVL5zubrKDI6YabXpiLw2/2ZAexAOCJvqTm7fsH4iq/DiheM9SpUV2ar6Zb9531i7CvfXDZRCslVlZQrdKIa9/SzN5eev3nyP7uYVxX+iS7o7ChCwXlZmxDpl2Mw21oXWY78aS3ITeYHXSqn2+gSA/TTPTn+zl5SK+r36K69RXxotsZgwaMVGN
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
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 52 ++++++++++++++++++++++++----------------------------
 1 file changed, 24 insertions(+), 28 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 427e14d7985a..69d3a6889f9e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3946,6 +3946,8 @@ static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int
 	bool dequeue_deferred;
 	int ret = 0;
 
+	local_irq_disable();
+
 	/*
 	 * If this folio can be on the deferred split queue, lock out
 	 * the shrinker before freezing the ref. If the shrinker sees
@@ -3968,6 +3970,7 @@ static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int
 			list_lru_unlock(lru);
 			rcu_read_unlock();
 		}
+		local_irq_enable();
 		return -EAGAIN;
 	}
 
@@ -4018,6 +4021,7 @@ static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int
 		lruvec_unlock(lruvec);
 	if (ci)
 		swap_cluster_unlock(ci);
+	local_irq_enable();
 
 	return ret;
 }
@@ -4033,8 +4037,21 @@ static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int
 	struct lruvec *lruvec;
 	int ret;
 
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
@@ -4106,6 +4123,8 @@ static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int
 	if (do_lru)
 		lruvec_unlock(lruvec);
 
+fail:
+	xas_unlock_irq(xas);
 	return ret;
 }
 
@@ -4245,19 +4264,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 	unmap_folio(folio);
 
-	/* block interrupt reentry in xa_lock and spinlock */
-	local_irq_disable();
-	if (mapping) {
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
+	if (!is_anon) {
 		ret = __folio_freeze_split_unmapped_file(folio, new_order, split_at, &xas, mapping,
 							 true, list, split_type, end,
 							 &nr_shmem_dropped);
@@ -4266,12 +4273,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 							 list, split_type);
 	}
 
-fail:
-	if (mapping)
-		xas_unlock(&xas);
-
-	local_irq_enable();
-
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
 
@@ -4354,8 +4355,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
  */
 int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 {
-	int ret = 0;
-
 	VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
@@ -4364,11 +4363,8 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
 		return -EAGAIN;
 
-	local_irq_disable();
-	ret = __folio_freeze_split_unmapped_anon(folio, new_order, &folio->page,
-						 false, NULL, SPLIT_TYPE_UNIFORM);
-	local_irq_enable();
-	return ret;
+	return __folio_freeze_split_unmapped_anon(folio, new_order, &folio->page,
+						  false, NULL, SPLIT_TYPE_UNIFORM);
 }
 
 /*

-- 
2.55.0




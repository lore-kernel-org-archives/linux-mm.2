Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06CB9C55171
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 16:27:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 954CB6B009B; Sun,  2 Aug 2026 12:26:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B3EB6B00A1; Sun,  2 Aug 2026 12:26:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A45F6B009B; Sun,  2 Aug 2026 12:26:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 50B576B009E
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 12:26:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C87BAC0504
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:26:44 +0000 (UTC)
X-FDA: 85056857928.23.010E506
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3B04C20006
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:26:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UHv5cTEZ;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785688003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SLM/iGuOERBTFxu8mql/4ATf4p59p9Me6R2GTZoj17M=;
	b=mJDw7zuWP4MDnmOQaKUl7ms/KVcGXjtFc/vng7HyKXcAbC31Nv140SX7S2NuJjx+d7DK7g
	15uUEAjBzv0wvhs3ZcFV2YWh7ZcMxvHOCXEvRjcbMjQR2MGacfxeH71RiFYPYMF82Q+w/+
	XwZwKJ00WMDrb7hkufE8eBh7qHsDN48=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UHv5cTEZ;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785688003;
	b=1dorMrKKcyj7g3Yzjk5bggPGmALCx/c65g1W3+RoUcfHuZ96H4bQEnPGWFJ7EV/cfsqLss
	Hgoia90lGtAXlKjKJH7/g6/RGY7vwpKjYP9KrmSnJXzDm2aNUGpoYs/97i4hQNZsVKbhJ+
	3aroFgzP2fhgOtQGyURI7dZIFqx+6K4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CEC2260DF3;
	Sun,  2 Aug 2026 16:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57BCE1F00A3E;
	Sun,  2 Aug 2026 16:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785688002;
	bh=SLM/iGuOERBTFxu8mql/4ATf4p59p9Me6R2GTZoj17M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UHv5cTEZKzhRB7KsY5VAqfOxGEnCzIj6KjzB0a08BwYuiVUZm5dUk3A9CQ6IYXwd7
	 zKYys125rvcGQqMNhi9zD0aoOaZULn3BZAzEYWybMJEHkYC01ydwu7vj/IeEoLuRKG
	 mTyRuK7EF0pbeTrTAcyX2qbHeMrRsnXkp9FpzACFFHklhZr/RrisibHGmEAd/0KyN9
	 r4v6hmC4t+5ccvvw8aBeGaUR0mHF4A9TsCnPrlzyjSybliWNZa8oeC2V+00ipZ4oII
	 C2MWXntanRysslwPs0u5qSFKfLPZBF6jJzOrg/ZdZvt2RBUUD1gADaAiqBEL6W7Kyu
	 0P/vWXnFhoBsQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 6/9] mm/damon/vaddr: respect folio end for DAMOS_MIGRATE_{HOT,COLD}
Date: Sun,  2 Aug 2026 09:26:27 -0700
Message-ID: <20260802162631.90304-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260802162631.90304-1-sj@kernel.org>
References: <20260802162631.90304-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3B04C20006
X-Rspam-User: 
X-Stat-Signature: dgwqfthker5rx4cw3sudhn3comficm4h
X-Rspamd-Server: rspam04
X-HE-Tag: 1785688003-884689
X-HE-Meta: U2FsdGVkX18pLLfQFfihgGNyneH6La4Tmr0rJbG/aP8hCrClTl90TYGG+/PpAk0UhbQGA5hvg1rIawUiTJdhpbpZ9x7URlK222vxxHEQuv2mVKgB4RY6xQeuqACS8wASQBWmvGuj/CaMwMIZE9WzW6dSINg7IE8mlvyaTWUJ+CSh+RSB5Fqp/1jOnve0pyNxSOSYjPrplzzs1GJ5r6syAck3xwKvNuC7OMee0+jDCfB1g9F5I7s0+uYQF8FV5ZigKhcetzMyrZq0BfCpKIl6DW3NboVT1vGfILx8tqhNa/IC5Geq/jtdPi6VsrByHbOXH01RKcJLNcgMaypr+ApuXgKyNodtfgRhFMJNTWGDlo31w84e2o8OJi81BuKqTKZgAXQ4YwYt5vjypbBm9rWtWtOvP6QN6mQt0Y/JVLELbviwacYeHSIO2aGezMTAIR7giKHm9BzK8/RvYRtn66Bj7tuRlk7vNW0zrSkyTNMFJ9nXwgRP7a0q0kKNNTIPjvVtCaqgQBLyYvOM2QIRRn4NTL6AMseZ/LAKYmZgkicGeFzO85NlTOqgOjOWSyZ9tff0HD1lHvrp/wB/Wh5ZqhdhQLnkWb/RJPS48zF8GC6LfjbMsMMhvhzZGbYB5AEKLZJ9BjdQ209siF6UI3QLvf46deA1cvyQ+pZAVYnVsHFe3DCsE+VOPy46K1XvDPK1oAIHLtM+W/1dMtUG9pmG7d4elws1En8PvxA/WR4ku3pH+eQMkqdNMspMmHGfBqbqSPlHrhzr0X+ey3L9PeZLdwryOpkuFEM6xZhMhUDfMT3Z3V735PXHoAvxnf1jcAwKrzaKMk9pugL99qlmNvuDVSVXWQeVjxmhPFy6AczWwZ47EQIhi5hfJoY14VfKx7fzjifj+Pczydz8Kow7pGDgbvZKUsPqnQG4q4VdG3jW84TjZ3WcnlxS3fjQmuFdZRDKRYUKOTFrBglG7e/EMYf7Kbe
 DQKNNnXs
 wzNC83uk5y4MS7aME91AgF/Tj71EgM9A0PdFQoxIdUTH89mg6rGcNPHeavTAwd4+Tmgg/VTvuLkurnJLXUS1HJ/qgrvD/GZ0yqgShlygQDGGabijebRkaAdNAVcaXSg7cLALAcgOMKM5rX+oLD8pmDKtn4dw/G7BOi6XXQgmGYub/F4j1p5vhFzVIbyuXMu4ivq+9byR8iINxAKi1S8v/E4MyVhQD03odR9/F+6tpENAIhX9+kyBcEQaS8YjoiBkpMaK8nn6l0yc9o8KRiWmHi+aulooJuikbiyTGRfG+vvT1zp1ErDu2X7zYnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For applying DAMOS_MIGRATE_{HOT,COLD} actions to a region, DAMON virtual
address space operation set (vaddr) calls walk_page_range[_vma]() for
the region.  The pmd walk entry function, namely
damon_va_migrate_pmd_entry(), collects folios of addresses of the region
in the pmd.  It starts from the walking address and advances the address
by the size of the folio of the address until it goes out of the pmd or
the region.

Let's suppose it is for the first pmd of the region, and the region
start address is in the middle of a large folio.  Also, the next folios
are small.  Then, some of the next folios could be skipped.  Fix the
issue by advancing the address to exactly the start address of the next
folio.

The user impact is that DAMOS action is applied to less than expected
amount of memory.  Given the best effort nature of DAMON, it is no big
problem, but it is clearly a bug that is better to be fixed.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260514015053.149396-1-sj@kernel.org

Fixes: 09efc56a3b1c ("mm/damon/vaddr: consistently use only pmd_entry for damos_migrate")
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 4b0b5edf67952..c8c32b2ae0402 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -669,6 +669,8 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 		return 0;
 
 	for (; addr < next; pte += nr, addr += nr * PAGE_SIZE) {
+		unsigned long page_idx;
+
 		nr = 1;
 		ptent = ptep_get(pte);
 
@@ -681,7 +683,8 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 			continue;
 		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
 				migration_lists);
-		nr = folio_nr_pages(folio);
+		page_idx = folio_page_idx(folio, pte_page(ptent));
+		nr = folio_nr_pages(folio) - page_idx;
 	}
 	pte_unmap_unlock(start_pte, ptl);
 	return 0;
-- 
2.47.3


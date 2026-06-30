Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 466DEC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:22:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27BB66B00A4; Tue, 30 Jun 2026 03:22:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22CF36B00A5; Tue, 30 Jun 2026 03:22:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11ACE6B00A6; Tue, 30 Jun 2026 03:22:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DAEFC6B00A4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:22:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3030D403D2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:22:24 +0000 (UTC)
X-FDA: 84935735808.16.62BD28E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 762EB80007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:22:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AYkVcW4v;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782804142;
	b=SClfwJaff4TiqIr5F4RfJ+S2TLSfkkrryL2lAKHFRnycnllMaCx+HLG9WlP23tJpkLh24I
	dBUqfn+4r43nkisX28J9mkeWBfEIaTrCTRjj17dXYKnVP/1eGVVJ335lbaIIDYTDH7lXvk
	uT6x2lhedawwDXI7M3GB9jWQrsnV/uc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782804142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oLrSE68xNG5mT8tgW/ijHmTinKP2lAELluUkxa6reBQ=;
	b=oUE1435oc0TnjVtrMFUws0vRlOZ2xbAaTRF9DkT6+v7rlSbty5YezIEkYqfWKITeoY+e5n
	BXOVfcrwHFoIhcyPYFdvrMIjm9t6zPD4mPK7s9O8VkUo4/aQaAJ6NICG3Qo0Xqhgrwo1J8
	gMwD4G9QYwEkGD0q/nPGTYCbEOre2hE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AYkVcW4v;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C80A343BE1;
	Tue, 30 Jun 2026 07:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A841F00A3A;
	Tue, 30 Jun 2026 07:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782804141;
	bh=oLrSE68xNG5mT8tgW/ijHmTinKP2lAELluUkxa6reBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AYkVcW4vLvETM8EM9k6g8TRBEKovdAiH65GAjFHQbeyvFHqjqWoXkn3QmRZ7PH/00
	 Tb8WKGDaVvJi9ya9hB1uXMOtF3Q6RqjaA/exQOsoQQmIGlpg2daX8IbkD2ldOLgX1a
	 6F7D+Fw7fmDyUwDVa5l5D11NQop9CWIjW7uUSsshRFJg7y4xY21KuoPOHMQLLv4HqE
	 NbnKZew5zoxyrJlTPnH/K6Ml8EgKol9UQ40oTWYZSL5Q6WuIPd5PtmM4cYknVpUn5f
	 7bebsE7cZu3Py1vd59obinwsEByOgwHcNEMN7g88533Iz7/YjBtkDQVx8WlKgVgwiV
	 HH5FWuhly1C2A==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Taku Izumi <izumi.taku@jp.fujitsu.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] mm/mm_init: don't overlap NORMAL and MOVABLE zones with kernelcore=mirror
Date: Tue, 30 Jun 2026 10:22:11 +0300
Message-ID: <20260630072212.624305-2-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260630072212.624305-1-rppt@kernel.org>
References: <20260630072212.624305-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 762EB80007
X-Stat-Signature: zex9rbh5gs69w7dfprcr917bpwmknom9
X-HE-Tag: 1782804142-958643
X-HE-Meta: U2FsdGVkX18+L9E5e/vZBXvpEyviPXSMShim6E3H/KUZ/IwLY9V0X+TkwHByDn2A8v1mtss7GsvbhQcJPkGqi1Gm+lqoFVNivjS8AeweEDLFy0hJF/fxTqhG44+SzGYrQ+Xch9FfAbiZywVwDz8xm0hpLj9iw0jOJiu7vDVfFkQUFS8cMoL9lC9b0XWgZR/pQkeAZZ8tlCHIZlfiC9PK+5yshUFVYg5Jfpi7gAzJlYArq8UxRHv3tFxuTq2DLsV6wr2q/mXr+35tx3FP4U0w1j6GBYaptQSTYjk2ldDwYp113/teB8JHAD07l8ntrJUvbN1yMOj6PX4g/vJnzDiOjdgqHtUwnIQFMBJoVs5H1aDRAyXGUAoCpO/cxS0Z6IeVoTSFqn1d3mEJUuCM1zobdY58xEom7Z92mxIqlHcP9wJ5gQbqJCej90G56qu+KuQAqXeOG3GBkdCC1cyHEJrB8/PJogZbGkxkAc+buwJFeCARTOraMYr8MkFarP+tFRT6kGXFMqb7nIwr0rR1+x+aYAFpk0MXpgeP+55AzxomF/ipxslEfNwpUM4Fuwcu/+MNps+DCJAyODjZ6RVfZY19T8tGNbfDuqIbH6vSKzfm+ixACep2STNP0PIDOfq5qzLcBlK/OqIDpyEaRrYSakrZcJcDjEYMzxg/kVw/E2KeMFa63HIkOB2rs2lJyeCHQNC5KqWuQ0W6rL+IIMCyew9bkOcrKieWKpRNHS6Yi/CKZPcMMHhAQWqNjed7aUXzZtqqRK2tJZ0QD921iLKP8k8KOH0HPK8Fqphc91qIoBYqoP+oUgLNdfVO6oav9xTubK4EGahfkMAHeyYdy3kKRq1+giUS7uM/gdNDJU93gwvGIGonTpZSDETqcltHBxFalAqokT1YKvEQ2H02ZoLS0sO9taswhoQwMcm6t3IOLlvouVnZ1Ha2SeMgH7gL568HDz7TpKpaUpn/f+wwwGBhBWB
 S73Gbak1
 XPtFnq0HEug9vKnzdvUFu0yWop4NCmbjFk399v/Vc8i4n6lr3i9odie2Y0BZS5yhzdCFqdoCfP1oYnwz3SHDGnF9Xk/VrYiNg/s0psCmQw9vu48/BX6aslJ7yvzCKGMPRxLsn6K88KpkPPzMNzcijPj6oEYTDgFWal+qPefNck4C54MEGM0zYICPAU1qFVjziFgiFb2EUNv/1Ve7JgTZrqP4dN9UeLnxlcfbCC6wjlfzE5HsIbp5zoGUq8RrCEWZ7v1D3vdyz5q8RlTyUaf240SjTythkbMExau6NKFxFPrDu2tto6MApLJHgAdYA1N9oF7d3ZrH2VrpKtEGoZK7RkAiwDZYB6uy9aZsXTU9ApYUU5IU/hSSZ87Spg8KOO4ud5P/y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

When kernelcore or movablecore kernel parameters define size of the
NORMAL and MOVABLE zones as percents of the total memory or by absolute
value, ZONE_NORMAL is clamped at the beginning of ZONE_MOVABLE.

However, when kernelcore=mirror the ZONE_NORMAL span is not changed but
rather pages from ZONE_MOVABLE counted as absent in ZONE_NORMAL.

Make the behaviour of kernelcore= parameter uniform and treat mirror
just as another way to size the zones.

Co-developed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/mm_init.c | 36 +++---------------------------------
 1 file changed, 3 insertions(+), 33 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 0f64909e8d20..57923dd33d06 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1174,9 +1174,8 @@ static void __init adjust_zone_range_for_zone_movable(int nid,
 				arch_zone_highest_possible_pfn[movable_zone]);
 
 		/* Adjust for ZONE_MOVABLE starting within this range */
-		} else if (!mirrored_kernelcore &&
-			*zone_start_pfn < zone_movable_pfn[nid] &&
-			*zone_end_pfn > zone_movable_pfn[nid]) {
+		} else if (*zone_start_pfn < zone_movable_pfn[nid] &&
+			   *zone_end_pfn > zone_movable_pfn[nid]) {
 			*zone_end_pfn = zone_movable_pfn[nid];
 
 		/* Check if this whole range is within ZONE_MOVABLE */
@@ -1224,40 +1223,11 @@ static unsigned long __init zone_absent_pages_in_node(int nid,
 					unsigned long zone_start_pfn,
 					unsigned long zone_end_pfn)
 {
-	unsigned long nr_absent;
-
 	/* zone is empty, we don't have any absent pages */
 	if (zone_start_pfn == zone_end_pfn)
 		return 0;
 
-	nr_absent = __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
-
-	/*
-	 * ZONE_MOVABLE handling.
-	 * Treat pages to be ZONE_MOVABLE in ZONE_NORMAL as absent pages
-	 * and vice versa.
-	 */
-	if (mirrored_kernelcore && zone_movable_pfn[nid]) {
-		unsigned long start_pfn, end_pfn;
-		struct memblock_region *r;
-
-		for_each_mem_region(r) {
-			start_pfn = clamp(memblock_region_memory_base_pfn(r),
-					  zone_start_pfn, zone_end_pfn);
-			end_pfn = clamp(memblock_region_memory_end_pfn(r),
-					zone_start_pfn, zone_end_pfn);
-
-			if (zone_type == ZONE_MOVABLE &&
-			    memblock_is_mirror(r))
-				nr_absent += end_pfn - start_pfn;
-
-			if (zone_type == ZONE_NORMAL &&
-			    !memblock_is_mirror(r))
-				nr_absent += end_pfn - start_pfn;
-		}
-	}
-
-	return nr_absent;
+	return __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
 }
 
 /*
-- 
2.53.0



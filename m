Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D5CFC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 17:43:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 952036B00AB; Wed,  1 Jul 2026 13:43:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 902AC6B00AC; Wed,  1 Jul 2026 13:43:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3126B00AD; Wed,  1 Jul 2026 13:43:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 589B06B00AB
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:43:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CAE45A0452
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 17:42:59 +0000 (UTC)
X-FDA: 84940928478.12.83789DA
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5AC7240008
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 17:42:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=SSXpINOv;
	spf=pass (imf01.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782927778;
	b=rj7JQkfp3TcVPqRQACKKAXpGaCQCU6x+ar+/k1LVD4b6/cGrzv5rFRi0uJ0lbIWPsFxLyo
	QAUF78Efil2oG0ISTDCr5151Kpodl7gpWEqoPtWYbx4qfDcnQBKgl+wA4QMBNktkcxPL9C
	Y89Sw4j5Bto7PArPspiJEEznASuYLbs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782927778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Hp/MTWF1U4k7tJMPR2GAr/ulpfpcYIO72EJRz51U5t8=;
	b=OF1H4FFTRol391aRhPrMJ5v+bKB2FtI0J7g24wLFRVzFXr1oT0jf7qR/cb7bI4HbYQVSUe
	CbpdZgxScR1JMLrIoT2EKGsC1G2jgXTQEZW4gkzLGSQ+Ut4/cLQudjcZuXLi23+XKNr00M
	s8Sc1jMZTD1ftw2yKLD3Nwcw0rMjoBE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=SSXpINOv;
	spf=pass (imf01.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:Cc
	:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Hp/MTWF1U4k7tJMPR2GAr/ulpfpcYIO72EJRz51U5t8=; b=SSXpINOveD8VhloC7JTauZovRR
	fOUQ5g2Tvtw7dPtYWx05YTxhikBrKzdOzVzx38IdQlHwJKzLqNLjcMd6OekNDacYUNolYyoP1CEAc
	i0VMk9qVe1FU6Mmc2cvxjLNsDgTgZyx6UvBw68jhSV7bQD/Yma5nnsOhKpwZ6jaYmFAzwNGT8w2CI
	fWbFSkGLe/v9FhqoTfQJ146y5fbQOcKRYaN+738hq2KVdQCc9VrinNW/3JLXSn0ryieUnEOuMxSYE
	2f8bhuLEm0eADjplGvR5EdSNoXrr3toaMQU+bLrzVKxxaWt1ZXWXejaOLzYSgJRJysPdLXXh5RleL
	pCPnyTWA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1weyxN-000000001Vx-0nsW;
	Wed, 01 Jul 2026 13:42:41 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	yang@os.amperecomputing.com,
	Rik van Riel <riel@surriel.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/huge_memory: set PG_has_hwpoisoned only after new folio head is established
Date: Wed,  1 Jul 2026 13:42:34 -0400
Message-ID: <20260701174235.3173401-1-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5AC7240008
X-Stat-Signature: gdbzrme9kiy8jmismshz5undzi6t8ie9
X-HE-Tag: 1782927778-633048
X-HE-Meta: U2FsdGVkX1/LK59RbVAU/Mm6XKjPV4G71jmNHda+WrQoqXDxModrV5GKWakfz/R0OhWKSfjlpgIWryepXRAOZ1zoLCDTz5irRH35vqo8msFLCmJWfrNUO+ZlNnA96JhFuiu+7x2I38xRVHvdyI/R9NLO8Nc4zbCXUjjcMKapqGwO3b5ELMK0JpO5X7usNXlypTgm+C/+7lyHAqNVJ+H+hiXOegtRcGrUitbWb8+Z3SKt/DpXGe6+MGlH01WcFg+OOgxmEnLjSUWk1FzmzVaE00+TeU/Rcyz6YY/S4Ya9xx2mgpzqqnyaJWXDLRvo3eaC6FIJFsIb04RGqZNiJ6xDLw+22AKgoH9YxTn+FIuq4vg1cX3TRftyhEjIU227OiYSqExsA0a3kf4ESdvVDuV6zKl+9uNuln5sUQg5a4fZFteCrOjzSrwYE3Rxnano3Z+47Q2rW6zkxN2ajrkOBYf0F9MmVKY2fZ0TfSQzkM7mZUtc5EFtoSWvOUrQeFVSP0AHaqTktkN1lE3FyFr+qOT1r+FEVqKvaU8uch6ySCKHohsyRxYEDr5Uv8RoGGmK0TxObwqPsXBzNPjncUd5VXguiGaQj8O8ov00IVQlFwTZsHVAOo6xsBZ4+lpRRkJrKD+pE217xeHnKtaxn2yWpLegJqxatoXLyDXYBnRqKIdEVzF69w/Od00mdxbK6uLgC7mF4OxkUCJKmzkjdrX41h7Uv+m6Mb2/r5x6wU/BLNh4QzVx2T65rNvZFhpp2YvH9zXaBDP17psff0Jt3wFLHAXGAefIcKHQ+C4n9ZTPG8mCk97A+gun6hbwXXBvfOEm/vwW2U29qvVa3D72ZirRRUQdq2/hEOXfeBveYaxnnDrLQsTpdVJp+E3m330WmSmhCJqa6V/+9HaeEFzFnfGlIwIeaK5dHTiT+1H+J3Cpj55xYY919lVRXCO+EIFFDHsd6ufXD7C/JvwLsQTub4X3VWZ
 VUeodUy+
 kpdFLS3wnyyGN++bvRC2TDrw3+JUixFMTpKAINAaE18K5GEQwG/XY8PEyAHPD3PzL+I/ITPwjfOkS1MJyl4kQ8DVP7STPWSENxKYlJcVuPvCGAGeDkIQh8FHXYQT8qy1JvP2v4I9GeRbgcvLCj2gdl17CECgx02WMrcmRZxEu1YJVzOiHl+/fXWt16aYuSPxrqdNwpiyfMzx5IqweQ3JD7ccUCW17+twkz/tYv/Lo2id5bt6GnElSVxil0+/z+oJm/KdVel/C8GfSa/1LDBu6vM/scGXVvX4Ri/9IPvpPcbGnoBxUs2n8Cin3fnvklWvJwxDsNorMGagDk7X0szsxaeXe5MweHPJEkNBWgHjb5VKLZHY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__split_folio_to_order() copies the hwpoison state onto each new
sub-folio while splitting a folio to a non-zero order.  It does so via

	if (handle_hwpoison && page_range_has_hwpoisoned(new_head, new_nr_pages))
		folio_set_has_hwpoisoned(new_folio);

*before* clear_compound_head(new_head)/prep_compound_page(new_head, ...)
turns @new_head from a tail page into a proper folio head.

PG_has_hwpoisoned is a FOLIO_SECOND_PAGE flag, so folio_set_has_hwpoisoned()
resolves to folio_flags(folio, 1).  With the new compound_info-based
page-flags layout, folio_flags() asserts the page is not a tail:

	VM_BUG_ON_PGFLAGS(page->compound_info & 1, page);
	VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags.f), page);

At the current call site @new_head still has the tail marker
(compound_info bit 0 set, PG_head clear), so on CONFIG_DEBUG_VM kernels
this hits:

  kernel BUG at include/linux/page-flags.h:354
  folio_flags+0x82
  folio_set_has_hwpoisoned
  __split_folio_to_order
  __split_unmapped_folio
  __folio_split
  truncate_inode_partial_folio  (shmem hole-punch / MADV_REMOVE)

Reproduced by syzkaller: hwpoison-inject a few subpages of a large shmem
folio, then MADV_REMOVE (fallocate punch hole) on the same range, which
splits the partial folio to a non-zero order.

memory_failure() tries to split the poisoned folio to order 0 first, but
that split is best-effort; when it fails the folio is left large with
PG_has_hwpoisoned set, the case fa5a06170036 added this hwpoison copying
for.

Move the folio_set_has_hwpoisoned() call to after
clear_compound_head()/prep_compound_page(), where @new_folio is a real
order-new_order head folio (handle_hwpoison implies new_order != 0, so a
second page always exists).  The flag still lands on the same struct page
(page[1] of the new folio); only the ordering relative to compound-head
setup changes, satisfying the FOLIO_SECOND_PAGE precondition.

Fixes: fa5a06170036 ("mm/huge_memory: preserve PG_has_hwpoisoned if a folio is split to >0 order")
Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Cc: stable@vger.kernel.org
---
v2:
 - cleaned up comment (Lorenzo)
 - consistent changelog grammar, plus rationale on why this path exists (David)
 - Cc: stable (Zi)

 mm/huge_memory.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2bccb0a53a0a..b5d1e9d4463d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3587,10 +3587,6 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 				 (1L << PG_dropbehind) |
 				 LRU_GEN_MASK | LRU_REFS_MASK));
 
-		if (handle_hwpoison &&
-		    page_range_has_hwpoisoned(new_head, new_nr_pages))
-			folio_set_has_hwpoisoned(new_folio);
-
 		new_folio->mapping = folio->mapping;
 		new_folio->index = folio->index + i;
 
@@ -3612,6 +3608,14 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 			folio_set_large_rmappable(new_folio);
 		}
 
+		/*
+		 * PG_has_hwpoisoned is on the 2nd page, so set it after
+		 * the compound head is prepped.
+		 */
+		if (handle_hwpoison &&
+		    page_range_has_hwpoisoned(new_head, new_nr_pages))
+			folio_set_has_hwpoisoned(new_folio);
+
 		if (folio_test_young(folio))
 			folio_set_young(new_folio);
 		if (folio_test_idle(folio))
-- 
2.53.0-Meta



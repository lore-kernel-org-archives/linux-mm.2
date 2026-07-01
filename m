Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 289DFC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 13:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA93C6B00A6; Wed,  1 Jul 2026 09:47:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B316B00A8; Wed,  1 Jul 2026 09:47:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4ACC6B00AB; Wed,  1 Jul 2026 09:47:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA1636B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:47:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1AACF140399
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:47:06 +0000 (UTC)
X-FDA: 84940334052.12.4E5F590
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf16.hostedemail.com (Postfix) with ESMTP id C6F8E18000B
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:47:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=AswG+Zxp;
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782913624;
	b=0UD8M3wrKh1ybhLUNYxwJYILkqIRK7kbvCwIPKSfTJvqFnLXu037aFM7Be+A95Qbvlc0Eb
	Ezb79D1gCeosE9xKyeX8Hu0dJyZFnIeljdJpyxbXK7ZFJxgy9Gn4ErtVoj+JSaXF5D6kE5
	o1mb0kI5k5v/eMpvkF4qiesYmwEjxp0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782913624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wO7ZZiQGguH2N/obhhx4w2CpdeZ8/YXIgBvKpNRdF9w=;
	b=nXJL3m66lI0nTwa2DseRmbZnUOSHeYmw5XM2xgBb/kPf8UU6gxyUsx40YgivA9jIQruB1F
	/0FC7viwaDP08KoUUvRnBCLFU677zIXRU+P45qsGb6U8tTRmL8c21xqGtkUXWI2cdwcbEZ
	SH/js9jRAo4cqntzIdW6oZbGh6U78GY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=AswG+Zxp;
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:Cc
	:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wO7ZZiQGguH2N/obhhx4w2CpdeZ8/YXIgBvKpNRdF9w=; b=AswG+ZxpLGFSU/NE8doEBQNmU+
	nt5f4hvHcVNd/0mrbWIx/i/OuSQqdxeROdlx7Zj9hdLlZuTVnHHd23uuAzr5nsSGcCSTeTnQb5fuO
	bRGj0evMTg/WpRAEcVLc8gz8Z7qlTYC4S65bz3K1zXl4f2PtK4Ty3gZFV6ngMUtgtD1QHOC35L33/
	0ZYF//REQgP9/P3njvGHnqPE/NI+8W4tsZrzozJgIv9aE/v/40VKFntkdChKXoE/Yv0ZMkxQHfWX9
	ZC3mqGuyxhvj9XgqDuDHG4VhwM03xqf7qDNeKemsusP7CueD4CiYFabOWDnBvlgii9t3fgIkZO/tt
	0Eyi0hFg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wevH7-000000006qJ-03pK;
	Wed, 01 Jul 2026 09:46:49 -0400
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
	Rik van Riel <riel@surriel.com>
Subject: [PATCH] mm/huge_memory: set PG_has_hwpoisoned only after new folio head is established
Date: Wed,  1 Jul 2026 09:46:22 -0400
Message-ID: <20260701134622.3152896-1-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C6F8E18000B
X-Stat-Signature: wtybn8ox34ionha1qgy9hyhs9r6dnm15
X-HE-Tag: 1782913622-187902
X-HE-Meta: U2FsdGVkX1+7Z+e/GG5cwWrN7/MEFrh9kiXM5KA+SMea8JFd322sH9HE+u0qYFOeasaar+6m34m/lP0Q8r5xuWMG81E6dPvQKtvc8mZej8tHqAI6k7EU1eflAP/GSHgyAkIMQExTjHbGAMlFlCEnKe7+f+3QTwuLJ0XhtZSxf/zmvd0rhtNixxq/wyJAlG+z9voa31KLXfXapv5cdPfdCJpNLRkWUP3vBYJtNnWesqJqM7ZpuY1uy2Z99sjPYThtSgIO7TZMHRu9m3C+K7KlW9IyHWSbFi4vZPoE68gaeSsyqHE8B+6w4f7KO65h8EqlJxkPAAh8rRAPqdz7u2lWNcn2mFWdMkIFjI377d2oJ5Nub+SMUgf20gFf/thHMoznv7CclLIQW/3usL6BlvH+Ea0KYxi3cPL3IxzDxQSAnZNY1TqIsO4/Icuf+py79WfYxijX9mcy6TUOPe1QFHx6n7oc9qVglwgkkH6HlJU5MdS+wQ8k+27/3WYPoRxtClb/aVbprTBjIE5dhArBB/dBS898FmH7QAQyqmA8PV8D/BtxWfVCkS7SSgrhaV5X+vChejRTn3+3/a0enY/mDMBm+dEv+RSlH8SR5VKxdT4aSZ3fg3YP9LtWzSTpYu+rtBWsomIRoqG1rrz9kW153qmwC+QweZL3AuO7q7NgZC7M3ISxJg2LBEtslp1AZs1QMqJoFWZi4o5GjFDn97Qjxcr9EfaPN+NyIGpfKfz7g4xEcninfQk0UyQVgKKRzYNgbPXe+KAA0/cEC0n6jf8KiLAL9Fy4MYgiODgJ5qva/5O5FMvGjL/gXFuaOdIAv3sqOyjwYYACjXu/3tvpz+7ELYDkhXOzcp0sRljuiw16+aZPQgykshllYEEvQdAMrvw9OnIvxy1HUqiAsK5vhU1x6f+eBqHxrtldkDtO3hBxwhKUo7jAjxYRgyKmSWTl92CU86eekwsIt9dBtPkwJdvfMiy
 maBhitfB
 RrdHAUKMBSs1wv6UgNUbsI0bBzfj3DtvICksoH/cn5+PEoxRv07EFtiAEYSeF9TOz+Mj2WT0jNzJ6Ie5QvKpmZAC590Wc+aDOAdYNfi4iemfayN5FGJ4XQ+AHigWU0GC0xgd29SC2pIIJUCdydWpB7+stsXg88GWYqFwYl6B9JU8C4LyFFusTGsiwfFJZNHC0JBLJKHvqjCYWoeZidyDol3+JUhB1KFXLbMrDAl3soMUeD1ycFDkKDikDI506sHWaUe7BXQsD9xAerKHtRDmR/ryjqjpIozFXWkAmNsJj4zHwC5s6IdKSbRPaX+iwov6Am9fN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__split_folio_to_order() copies the hwpoison state onto each new
sub-folio while splitting a folio to a non-zero order.  It did so via

	if (handle_hwpoison && page_range_has_hwpoisoned(new_head, new_nr_pages))
		folio_set_has_hwpoisoned(new_folio);

*before* clear_compound_head(new_head)/prep_compound_page(new_head, ...)
turn @new_head from a tail page into a proper folio head.

PG_has_hwpoisoned is a FOLIO_SECOND_PAGE flag, so folio_set_has_hwpoisoned()
resolves to folio_flags(folio, 1).  With the new compound_info-based
page-flags layout, folio_flags() asserts the page is not a tail:

	VM_BUG_ON_PGFLAGS(page->compound_info & 1, page);
	VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags.f), page);

At the original call site @new_head still has the tail marker
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

Move the folio_set_has_hwpoisoned() call to after
clear_compound_head()/prep_compound_page(), where @new_folio is a real
order-new_order head folio (handle_hwpoison implies new_order != 0, so a
second page always exists).  The flag still lands on the same struct page
(page[1] of the new folio); only the ordering relative to compound-head
setup changes, satisfying the FOLIO_SECOND_PAGE precondition.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4-8
Fixes: fa5a06170036 ("mm/huge_memory: preserve PG_has_hwpoisoned if a folio is split to >0 order")
---
 mm/huge_memory.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2bccb0a53a0a..ee7ecb3b45c6 100644
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
 
@@ -3612,6 +3608,18 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 			folio_set_large_rmappable(new_folio);
 		}
 
+		/*
+		 * PG_has_hwpoisoned is a FOLIO_SECOND_PAGE flag, so it can only
+		 * be set once @new_folio is a real (head) folio.  Defer setting
+		 * it until after clear_compound_head()/prep_compound_page() have
+		 * turned @new_head from a tail page into a proper folio head;
+		 * otherwise folio_flags() trips on (page->compound_info & 1).
+		 * handle_hwpoison implies new_order != 0.
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



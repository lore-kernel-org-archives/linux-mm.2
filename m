Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CC66F54AB8
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 13:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 761776B0098; Tue, 24 Mar 2026 09:36:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 712046B009E; Tue, 24 Mar 2026 09:36:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D9746B009F; Tue, 24 Mar 2026 09:36:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4ADB16B0098
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:36:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E14C8BF81D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:36:00 +0000 (UTC)
X-FDA: 84581054880.01.4C93391
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 211F040008
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:35:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sJeqMj4O;
	spf=pass (imf11.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774359359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uins4GxD15tLNZ3fROzluH1XAWb8vwtaEG+dKzINXqA=;
	b=QAw4ZJeUc4IyQ7XfiILgbIhSxL6ryal+xixv9NxF7b86DWygU5YkF0d24lTgXFXMHYIx8R
	67kgjNmYBGTI1QlRVJ/bW5HoSHWCterkaGaQ+zt9Mq7iR4h0lzUgiEAP9vTdtCMbFLxNB7
	O3aSqGNdqyo7L6YIOM8MQFQOPL1XkTc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sJeqMj4O;
	spf=pass (imf11.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774359359; a=rsa-sha256;
	cv=none;
	b=HvKMwpZx5fZK4YePvK4xuV3k+LuMFE/IX53euLii1NiTfTmHoBEMr0m9LHMe1GyE1EnWhs
	h/VyW3UCxkvzs2a+kLIugIpTbv6g27bM7yjH0YizcxdwSMwosaFZaPek8YfWdaay+1PTiE
	nocL0hQwQajl5TwZoEgLCHsCSNRZH7E=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6612E153B;
	Tue, 24 Mar 2026 06:35:52 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EF4D53F836;
	Tue, 24 Mar 2026 06:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774359358; bh=xADP0rm/5A6J86K27uPWY5WPSf6+n4q5BYJIGjghh64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJeqMj4O98zAEbsTjrVz5tXtlZVYLL4LLuISN8B/lwdt6aWMYBYphHrjL2uArrIyR
	 LloZr+APg0KxpiW113TjXa47nKksNUMIvwhu5ezfLD83yNX8pvq9lu4zA1vSkEBc1O
	 A6YXrN6qCwkkQhwT6Gyi/p9DjKxmpuW1cEbaOT5A=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Nick Terrell <terrelln@fb.com>,
	David Sterba <dsterba@suse.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	Ryan.Roberts@arm.com,
	david.hildenbrand@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH v3 3/3] mm/page_alloc: Optimize __free_contig_frozen_range()
Date: Tue, 24 Mar 2026 13:35:34 +0000
Message-ID: <20260324133538.497616-4-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260324133538.497616-1-usama.anjum@arm.com>
References: <20260324133538.497616-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 211F040008
X-Stat-Signature: jx39iixeocnp4q76hr7soexbpuqyjgoe
X-Rspam-User: 
X-HE-Tag: 1774359358-269731
X-HE-Meta: U2FsdGVkX18dVjFB3wE3jkbz0PeI8LnqqFivaarKhu5n/rv6eEWX2PlQwWjI9gRSEpwzxIwvBE/wWHX+EZIoZx1KX6Cd60a/bFnlgjwQhAy7b/wAdeT1K+khdL3fl6WPlEgCNnHsJX3Kz7+DjBvL1F0iGqTHj+C+ASIwpghpU/Ydw/XDeKXht3P3wMMHOtH8XtaHNRXtZBMQ8KH0xXVLeEwTOt1G29I1e+s0UuppnkVPxp76eE5gMxrRwSQKsDAte86bU5gugmPOGWnbPr7c507NhvkLmEk1D/xeXvQtrPoPAKNgL5PayDacYJqYqojL36rrTcD9AMYL3qCx9IhyKDqiEhwowSbpCLLs1GJC6rXrstakfdLMYfHjIvup2kJtAPsRKDDkiXAQ3vnYMD3Gs4vAAi5oVegROJM7GzF2muS63/4shGvxOxTGjvNYXGhHEASgPNhOwGJwLZA8cpg71GO/eXWTtBo19TXkwJm0wKQWh/C4KmAker7Ql8w39K57o/DCVKWQ3udYEe26ktffTt9mABfxeemYHQEQyMpNKk5dH4iUEdCUmhHiH5r7kmzIBP8zkRnFro5rS2D4sUfsHP6LcWXPOTxJPh+ZQhiVb+dy967N7z9yc95dJcDT6JO/VgbsEAV4hSnD0UlET3FheipG23P/qTFIuHAyQF4hGrV4er0b+3UwqkxC7d4DRNUIAG0gOhbUyRPkPk8hYn3cprHsrtRk+CIMsfI1oZYwATxUHs7wfykxh6ChQzPhCJBTbND1XUhaAaS/P6ZVDrKBKmVAVVioBCzS2zTahOJwNTfdJZWKDONfQYFKRyZCeu/WG5vuPDSdSFmH9PF0B16bmJIzDxaROExGMNuIzsPTgQ8k7Bf48QFq60ZXFpOfF4vTNT0P6YB+MzBxm9F8+xPqbNuMeC8V8yTyk+y4fEkxfWtu05p86cOwZSKPkY+yZUOD6bhGu97Npg696qAVCWU
 c8k6tJ/3
 MJxCQJHTIkuCASfZtJDgSB5Q7dLcm1cy489OBPs2W1DvXwBFdUnBdB/dPEqdXvClPkIDaFS70nGEtcNL6ripH85j9egAGucWXVPWXwk5dTAvAU+fK547GtQKpVowR9thGySCnOl4dsWLJzPP82IX0wa8oG6nlE0CKcvjPcsppyQlISefX8spPWVxnZXKRB7DnSgOz+BBXEDAhNw3Fk7JPxksfo/cjL2our3m7KHH99F2GCz978y+A4H5v6mLbkkjZODXejkYPLww41Z/V12VCN56FEgnr2lrqSz/aTLdKyQbO+uisw+RucOJH2shN5yyd9uatH6vT4Jq6z2sRY77QFDDZtcBGisN9ipupXwdASz0u9zrrH305HJ/yRylcnFgjrTvr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Apply the same batch-freeing optimization from free_contig_range() to the
frozen page path. The previous __free_contig_frozen_range() freed each
order-0 page individually via free_frozen_pages(), which is slow for the
same reason the old free_contig_range() was: each page goes to the
order-0 pcp list rather than being coalesced into higher-order blocks.

Rewrite __free_contig_frozen_range() to call free_pages_prepare() for
each order-0 page, then batch the prepared pages into the largest
possible power-of-2 aligned chunks via free_prepared_contig_range().
If free_pages_prepare() fails (e.g. HWPoison, bad page) the page is
deliberately not freed; it should not be returned to the allocator.

I've tested CMA through debugfs. The test allocates 16384 pages per
allocation for several iterations. There is 3.5x improvement.

Before: 1406 usec per iteration
After:   402 usec per iteration

Before:

    70.89%     0.69%  cma              [kernel.kallsyms]      [.] free_contig_frozen_range
            |
            |--70.20%--free_contig_frozen_range
            |          |
            |          |--46.41%--__free_frozen_pages
            |          |          |
            |          |           --36.18%--free_frozen_page_commit
            |          |                     |
            |          |                      --29.63%--_raw_spin_unlock_irqrestore
            |          |
            |          |--8.76%--_raw_spin_trylock
            |          |
            |          |--7.03%--__preempt_count_dec_and_test
            |          |
            |          |--4.57%--_raw_spin_unlock
            |          |
            |          |--1.96%--__get_pfnblock_flags_mask.isra.0
            |          |
            |           --1.15%--free_frozen_page_commit
            |
             --0.69%--el0t_64_sync

After:

    23.57%     0.00%  cma              [kernel.kallsyms]      [.] free_contig_frozen_range
            |
            ---free_contig_frozen_range
               |
               |--20.45%--__free_contig_frozen_range
               |          |
               |          |--17.77%--free_pages_prepare
               |          |
               |           --0.72%--free_prepared_contig_range
               |                     |
               |                      --0.55%--__free_frozen_pages
               |
                --3.12%--free_pages_prepare

Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v2:
- Rework the loop to check for memory sections just like __free_contig_range()
- Didn't add reviewed-by tags because of rework
---
 mm/page_alloc.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 250cc07e547b8..26eac35ef73bd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7038,8 +7038,30 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
 
 static void __free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages)
 {
-	for (; nr_pages--; pfn++)
-		free_frozen_pages(pfn_to_page(pfn), 0);
+	struct page *page = pfn_to_page(pfn);
+	struct page *start = NULL;
+	unsigned long start_sec;
+	unsigned long i;
+
+	for (i = 0; i < nr_pages; i++, page++) {
+		if (!free_pages_prepare(page, 0)) {
+			if (start) {
+				free_prepared_contig_range(start, page - start);
+				start = NULL;
+			}
+		} else if (start &&
+			   memdesc_section(page->flags) != start_sec) {
+			free_prepared_contig_range(start, page - start);
+			start = page;
+			start_sec = memdesc_section(page->flags);
+		} else if (!start) {
+			start = page;
+			start_sec = memdesc_section(page->flags);
+		}
+	}
+
+	if (start)
+		free_prepared_contig_range(start, page - start);
 }
 
 /**
-- 
2.47.3



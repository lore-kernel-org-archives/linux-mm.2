Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8196109B48D
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 15:22:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CDEC6B0099; Tue, 31 Mar 2026 11:22:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47ECE6B009B; Tue, 31 Mar 2026 11:22:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BBE06B009D; Tue, 31 Mar 2026 11:22:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2CF236B0099
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:22:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E88A5E04AC
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:22:27 +0000 (UTC)
X-FDA: 84606724734.22.52A71BB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 366D680016
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:22:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bpRI+so9;
	spf=pass (imf02.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bpRI+so9;
	spf=pass (imf02.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774970546; a=rsa-sha256;
	cv=none;
	b=3dOf+dm1EYeBo18/XQlcBd2bihW5U325DBrlWoC7Miua1l5KCfm19cBRUNNXjdHVrEM6j8
	L1SxnplRJutS9th/IQUAaCeI3mBwxw1VUj8BWZhuzrlK4sAv8R9DkWG+UERb4JDpg8vLYn
	L36bxa5wazUNMsGEYyfNoBDQUg2v9UY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774970546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dxR14EfNSPOgswogNlfNvobucNrvkEkEYxQfUULs/Wg=;
	b=GHJiEezeKOL8pcJjzvKNXmli3gZPP4cNfNfkXRBY0bSpZUtwXSfbPpaPNAA5358751VRWp
	IWSdq1JX5HYeVxpyq4OckNmZZSGa1oZUowU/3bCJ0Ypbtk0nHiColAHmhlNHZIcDDXJ/kV
	tjEFrD6wfNJZniCBp1JFO3teijiR4H8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 45B602364;
	Tue, 31 Mar 2026 08:22:19 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B29EE3F641;
	Tue, 31 Mar 2026 08:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774970545; bh=vhlrZdxspo58Nxacdcn7UwJrBzvZGGfK9wI9IlW3WOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bpRI+so9x/rCAhu4Ej2MBKLkyBcb6E//csEp3kacMtoOab7qHWImh9qjP7QySIhut
	 KRmHLKfjpBIUHR3SCfXuKbNNhPVQYxGEirGVwJ0vy4H2eGPrBfSxs4UN3pmu5bjtPE
	 99diFpyczO/NIfFrVdz1bDofbZiJ2DjfDHeWMVh0=
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
Subject: [PATCH v5 3/3] mm/page_alloc: Optimize __free_contig_frozen_range()
Date: Tue, 31 Mar 2026 16:22:01 +0100
Message-ID: <20260331152208.975266-4-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260331152208.975266-1-usama.anjum@arm.com>
References: <20260331152208.975266-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 366D680016
X-Stat-Signature: jg84uoon5wgbcwzzs1gbodz9iogm8ic9
X-Rspam-User: 
X-HE-Tag: 1774970546-229569
X-HE-Meta: U2FsdGVkX1+OiGk4ugQhUu5tKLjGoH8aZmPBu9btsLxFyQsbCVT8Zv9DJSQFKwpn+f6inv8uCy50e/fsftuVZVQ/g5bIxh/Tj22Aaz8YrScgfCwzkQCgjgkRl8l7bwwQR6IvXe7g2i1BQSHiLCWr37XdLYf/ZOAeAxn8SB3HSwR0inpamHn8oNM4ZgoWudIkCsayBLNMSiR8yVl57GHguDRj0wOqTaNKgh0x7vzSlyP7Mn4CPp7PvvKmXGPvF3iwQktZ6ZflzA1cxnOzaZwD+aLxr6mzvdzHUuvhxp65pzV5MsUOxdykt68c3aQRwBEZc8LOpa07ZWVqfXn+9xE47eu3ELR4cTqv0cCRm8IhK25+D1wh54nRsI4qZ21CTPYtELX3PSXVM1Df1/JapcgZ98MKPWGgN6IEYugfHoPat6HTq73lT17zaYwRJhHnncI90pYxlHOxUeQsu8jX9n/VNcvITkuAfE+r7NpPbRHfSEW8aOESF/hdFaPoTxqQI+oeX+qOxn0+P9PYutEhLAkmoj3sOSK5apk8KhYBgAJSTX7AXp7LxZZkd8yfvssRnS0oSwSrR1MAXVjRcAJmBss8MJH5KCMdMcXYxCN6oV/n2ZlhRd5AiKU6VxYr3uo4/URrTRLKH5peY5s5VS6hYSVa/R4kCRF72CBdKMFHOv1qJ5JdyacmnKDXkV3K8lYSz53sJKD8kQV+SBHKm8qmTRo6tCsh8ZfoBbZX3VlosAGJvmie1PoPMjbs0OfGKrU3nMu8izBVxM5+N2GCt7LS6sfEf9+/32Qx4cxUbcUJ2BQMP+mUJeDGr7jW61Xrrw4bMWDs80HbrmYX3rZfdo5w4oKQUUo2GvRrR1MRrgirrRDbTdlubo78249LYWjjmvmHf1+q6MPlUF+T9s1edoquFtw91W7o7BdbcEh0MTczQ3GeUVILLXB57dF2JjisvM9xqsvd9cmn8W+uxo14ficWFAx
 LKIvok+N
 ZVfJA5s2Hah+TeiYIceLo8yuYBGUnveipQaY7PSUUJ6cTmW/rU3Pc0WNvCn7jukDgMe2ja8PVLJuWrlnVpGyysftJeYQ9GgBy1McnkfHYmciKiK7j1vpr+DwLXB0z3MEJ1YNQmG0US7T/HobTNQjMTwtod7pmZTYtvdfHn71dF1WwBAdwtmA3W3YKJv6ksugO8mlyoKcbpHxTa7QMAI7cYjx8h+PalMdrQVB31FsEzIJCGfghw9McdOaczmPcxk8Qz3h4e+nbKakvS9MdVcQn1twvF4Sg258E/M3fciB7GebdVjzSjLwJm8dBrG2LW1x7NQtHistlOX8SKQowoC2PXYhZdiccZbGYEJcn+YKIc2TIgorCaf7GwleBnrXj5Ji6r82u5A44OgzG2FxZpgFMEuuC0A==
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

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v4:
- Use /* */ style comment with boolean variable

Changes since v3:
- Use newly introduced __free_contig_range_common() as the pattern was
  very similar to __free_contig_range()

Changes since v2:
- Rework the loop to check for memory sections just like __free_contig_range()
- Didn't add reviewed-by tags because of rework
---
 mm/page_alloc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9218fda8842a6..b043b56f65c57 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7052,8 +7052,7 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
 
 static void __free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages)
 {
-	for (; nr_pages--; pfn++)
-		free_frozen_pages(pfn_to_page(pfn), 0);
+	__free_contig_range_common(pfn, nr_pages, /* is_frozen= */ true);
 }
 
 /**
-- 
2.47.3



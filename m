Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EE2AF46453
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 11:32:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3E786B01F5; Mon, 16 Mar 2026 07:32:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF26E6B01F7; Mon, 16 Mar 2026 07:32:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EBBB6B01F8; Mon, 16 Mar 2026 07:32:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 81B336B01F5
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:32:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4C519B69EE
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:32:40 +0000 (UTC)
X-FDA: 84551713680.23.1F0F84E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9337310000A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:32:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773660758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mST+kfhuqyoIvrJHEleKGrd8Pqj6hTUTVEoHfXDVdJo=;
	b=vGyUG3JqB+6nMttLDOPCS7PKJrCyP4m8fOFcfWUsYpqyLLJCPQJXi5BvReP9Ika9LifiFp
	6hyP0qttby14114+PNl160uGe1ksPGrUkmlpe4R7yTLL6gyopUHBPoHeghBMEY0Tb1hQP5
	7jSrb1zcQ/6p+3kcXN3ZdpekvvMYy9w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773660758; a=rsa-sha256;
	cv=none;
	b=42wAnv/K38LZV46Vsk3Q2Vfy+egBG1jXCGYbou0iBRuu1vELFyUJoXJlUhiLGSCueXLDa7
	MJPtew0M76GccN+QXYy/BHkOHlRUju8AyRVOmggL7siZJoAI1IOSfrOOscRcnws4lgTeW2
	0opj1uHBac0znegbcSdPUkoW58zxHRg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4DD0E1477;
	Mon, 16 Mar 2026 04:32:31 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0BC0E3F778;
	Mon, 16 Mar 2026 04:32:34 -0700 (PDT)
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	Ryan.Roberts@arm.com,
	david.hildenbrand@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH v2 3/3] mm/page_alloc: Optimize __free_contig_frozen_range()
Date: Mon, 16 Mar 2026 11:31:44 +0000
Message-ID: <20260316113209.945853-4-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260316113209.945853-1-usama.anjum@arm.com>
References: <20260316113209.945853-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9337310000A
X-Stat-Signature: 93ijruwag5qzzdhrjihciu5zqqpm6ix5
X-Rspam-User: 
X-HE-Tag: 1773660758-420981
X-HE-Meta: U2FsdGVkX1+WhXxHoqjbjU4R7zALxeR22on9uTJZ8+mHhyFxdXoMEwdqUdD9Ck+J7dH9s/K/l/yIdIEmzrCFgccUONBdkXppkoypkrruspPzVAEErtrJX4XX7n2LjX4dQUm2hPxV6lqVONDrgva3GypwjtVq/lPH73ycZBK8nFXM3AF1bTxOQvdGvTyOBqWb0oCD5TXa8kKWYvuSKgf5Qi80CedZVwtiVwwds9Bau2oqVPOOe8kHR/qLMXOLxkl3JsZRImVdzdj2iHCMfmRm0BV85qEPntZXP2RtSrp4HX2o6g9FZgZ0EDCUpEYbJRhS7SbFT1mh+FJvS4Wk1uqNfK5RpFns1Qaq9ysa4jSFyxd8nHYXzGesFvVOGk8qJCjcA1v84rkrQWuvAXTpz5sSQ5gfKyZriAWsh11r4f05stwqkwNHFJ5qnldPEmlRDhenHcrLhdegyh7ZGfpejFivIjnVab6LX4MmkkL2rr5SyegmVynKZXybrmmvATkrnDvQRGUA86m2lpq1X8B93lgbOBF/bmcIV8IAJk0cpykROAlBXNO1OG4fWSb4y6RjMiPNieyoj7Yiyy6sBNArLOP1zmf+kq5b4OTQHbFPcgiPH6Hu4wZyIy8Q/gag61yExxRoBnRuGw83sLmZYhFd5NKfMJ+64tlAeSnOuiLLQk2tEO/DvsrKKjfy4sLb6Yt7kOosrpmQHKoGtJQTcDsJOy9eEBQko+jBElxSuiwSVHzwsXlF2cZZjDxsGaFSpAyA9JxWo6i3DxMC9zudPTMklRVjX4UThXo3x5ZbG2NojgM4A220WXZSjPtmJXiT2pSyJvPzbtTkzG83+byYMBVmF6g1zDT4asPX2esYU9sQ/twqfI6PwfQPL4+QhKqcIKkpZNZRZdqfgMtFRX9SkbdHdaqZH7fIVq+IpT+rMlkNrI+tP8x2gdwRJut0/yCi4X+5vjsxpUeI80IyDVW8SBxQwdZ
 N2cGp8gl
 kIFTQdXVd40pD6e/rqklhqnV969PiJ5Uzo7otLbhahbC64pN5VGHxPRrmGDB2aLwb+ueZBuMJT1voL6leM+fXMJvGnGSYNX5kaDATNR6qLvUIS4BHxhrDlTlL4JGLAh0Zs1Vr0Znoxpdm4zfOjtO/zNbZpsaeteUEExmQhgs/FBDcexeMQS2OfLBnD91TbZDRaWZ5Tqfad+xBIKq7UYwvNXMR5IkZe8KO8Chsk4UGn/bpqhBeTC5cwgIAhvJNRg0KzBMlJcM9uzoqJlGoYl+1GlFiWTE/+aSD1oE9e8s2Q3bGTeM=
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
 mm/page_alloc.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6a9430f720579..2e99fa85cdc8e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7020,8 +7020,22 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
 
 static void __free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages)
 {
-	for (; nr_pages--; pfn++)
-		free_frozen_pages(pfn_to_page(pfn), 0);
+	struct page *page = pfn_to_page(pfn);
+	struct page *start = NULL;
+	unsigned long i;
+
+	for (i = 0; i < nr_pages; i++, page++) {
+		if (free_pages_prepare(page, 0)) {
+			if (!start)
+				start = page;
+		} else if (start) {
+			free_prepared_contig_range(start, page - start);
+			start = NULL;
+		}
+	}
+
+	if (start)
+		free_prepared_contig_range(start, page - start);
 }
 
 /**
-- 
2.47.3



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A022DC44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A88E6B00AC; Wed, 22 Jul 2026 11:00:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 980D86B00AE; Wed, 22 Jul 2026 11:00:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86F9C6B00AF; Wed, 22 Jul 2026 11:00:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 597336B00AC
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:00:26 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC047140204
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:00:25 +0000 (UTC)
X-FDA: 85016723610.26.34C9649
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf24.hostedemail.com (Postfix) with ESMTP id CB04518000D
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:00:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=SSv4jaOs;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.46 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784732423;
	b=yIoyoZIG8CG0wyPI0Gk84qL8VW28kVwn72rXkgEcQrVjSxq9rTEdtbFWBA19b0Whv80pR7
	hm+gUrJEto3TX5wxpA4gOocULPLyJV8zOhe7SfcHhiB7g6+7XHqL43Q2fI5EclQQrhs8Gp
	WNn9q/anClGFT6FrovdXNNoAiOlwXXg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=SSv4jaOs;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.46 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784732423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ssUPrZXhmKEtcaomL/NSzb6q5Qkj8exc1H0XDUvt4yE=;
	b=d1unzPPSfCgCoiLVfskSUh61Ndr/G9PU6dIAZD/FkobAkIQbIrJZGJWl/WddjwK8PCsoql
	OOc1AA1gJ4lhMTu+0hHNgB8ppaUZWpVPvzh+JJAmCYO9qGZpnago17aeLzX/b7cl3fxDzX
	WRaOlUMeOqOnlSgP//fNOq1qudOq1S8=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8efb708b1a0so124735306d6.3
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784732423; x=1785337223; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ssUPrZXhmKEtcaomL/NSzb6q5Qkj8exc1H0XDUvt4yE=;
        b=SSv4jaOssYGZH+svx2y8iAKEsExRQwxPkLj6indIaePkPzh7xnYGBw6OLmm4DSYSu+
         5E6ECG7B0nfDJfihE9YSZ4KTfuSWkOVCtWauT1LICOMHGPDiRle+C0Wx07rVLTuO+GNC
         VO04U8gV1aAdrnI39ccAnrfnUVwT8t/78zRxkUkCwkUBFEt2mUbEPePfv9dtCuNpJ/nj
         IN1Tg9Z01zS3+j7PDQtBia6yHz6+08Lvg0evLHN1OsqaxOWSys7jiHvRN3wS+hXOInda
         tYfDHHveQgIzF3iUnDxls+X7lnakRMsrqCzyO4H1dpkNT4PbqryIIa621M6+HsH2Qu/7
         n85A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784732423; x=1785337223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ssUPrZXhmKEtcaomL/NSzb6q5Qkj8exc1H0XDUvt4yE=;
        b=oWzApdwfRPt8Hu/J6wuYoisnlstzfVq+ULaKWSR3NrKYi6S63u8XZqoT8Nm+DXPcha
         i7kBD9KjGikjwbluTLCjXYoZL7Cq8JxTBFtF56CxemWO2zwoP3HAK4e5F8ZNBmb53XT+
         g3zMWKSphe2BeXGEbON6Hpo14uT3iyHXS38zRBTXLQJXWPne+IJImwM0F4r2/IWfhsHC
         ynciUacldxjrN5bYV/7aVXMivmoMGP51uxoeCvrYkSQiQESm+Yvn1mYwjF7BE+PqfCRT
         9ub1nGKP9/RiyypZJ/kmQzszMm6VYDmujFb/kkqPiq/3WmOridDIj9eGRUwWhnnn2o13
         jOvA==
X-Forwarded-Encrypted: i=1; AHgh+RqlvWqb9mmhDPwBY/ZCKPsweHY+8BrH3392dusV3seiw/6eoGoTlHOgr1FhFP4wWojiXPdrqhz3MQ==@kvack.org
X-Gm-Message-State: AOJu0YyV770WB87hR7/roeP1d7aMQdI5yeRngF8cWoLDk9KUvq3WWbPn
	s38U2cwOk5Vqsvda+Oiq8/symIJaL+YAxZ5usYgXlDx+5dx+WXQM5fdQyp/LN5LL9Mg=
X-Gm-Gg: AR+sD10YXjnUGsQSjdxpB0JPTSPgHjU4BBkDHI90bhd1tXHF/Ec5XyqtH52VPcbVKGJ
	tJ1B2LIjUMRd9qKdTSsOUChWZliZFaurnwrHhu46/+xeivroWtaHBu2yGIu6OzIzHvwyHF0oe8b
	cfCMweJvr7Z6SEEIbxCMM0X8ZbCMBuDPDMQJwJMFCL3y87/KoVoNH+ROfSFNCPv0JSgNzLqr6fa
	tsWDxq1Vi5zLKRh7Py2k7QOF4T4qF8VkUgoH8PsHFuAiKXrIs0l1NF7G4p/mAvqX6E8rjfF1TKP
	tVBBcfAr5fQjRhn/06JOwglTz2u8axBU6mIWnGkfmDvjt+TZpg4g9ARmH9Nm/WwGbidV/3B+cEq
	FhB4KArZ7Q0v8XPDiw7vsVqm00Wf1nHQY7qudJIIplRcPDX5rFEEBNh8JZNAdlbectzkWQcnDnu
	BP
X-Received: by 2002:a05:6214:3912:b0:8f1:323a:eede with SMTP id 6a1803df08f44-9077835ab03mr252766896d6.14.1784732418083;
        Wed, 22 Jul 2026 08:00:18 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907baa0a146sm22359506d6.33.2026.07.22.08.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 08:00:17 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 4/4] mm: page_alloc: fix non-movable reclaim storm in defrag_mode
Date: Wed, 22 Jul 2026 10:56:47 -0400
Message-ID: <20260722150006.3848560-5-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260722150006.3848560-1-hannes@cmpxchg.org>
References: <20260722150006.3848560-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: g5sdq7racjjxmb8dgqt185d16hqnojx4
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CB04518000D
X-Rspam-User: 
X-HE-Tag: 1784732423-600752
X-HE-Meta: U2FsdGVkX1/IGhZTKfMDiNN9T9fnrs2wFIcX2CDETkV7/2ITjtyLksToAczLrjVVqfKTIxQ4XHwuqf13iaMXHaECIoZsyyh52DlygGOb1OamBzIAWck9RsrVVAWTZOPM1GwSbpbKDtqjBKw91Aoq0Nrg8oVnCBvKJaCdgvqLACSn9UQHS/+eCyACCAL4OjAE0m6bdK6Vf4Dc+eZrsdXbsU5ULm/6OXistGd3KVgtUfaazh/RXvw3WOBmY7hhgEx0sBHx6Fj1YMUuaKVMjWmk61pBgOSf+evMmpjcdU1EK1YvsAvTGdlKy3bZhHZfXBFhgN0Vrxw0WHShOGIBzGPwIgIisZovu3CVWW8nVMBLv4NgNs9Fd2x4jdCQhgGkGm7Ez75NkMbJ7ZdlS3A7ynCjMPysawvk4MnH/9PFO6VCdx5igfu5T0ThU0LBbFLGmzowErbD8Lxd+8PKUCFohbfU6PNLJ4cnjCNvm/tenzwVww3xPLZtIHwCKQhvpj1YbTijx18X0sOdLRVvrKz305Lm44l8fOf2jFmmizsvSdTiGjuURPpGw4URQcdkM15BaYooJYA64pOrGoG15K1tjp47FUr3nrE/7f5t40ngwz++AHsr4euhxNfSBhCGpzHvgThW7BU76QFmms7XaJ9O5L5VMfArqnsuHlzn50t90T4f+f7g8XEEOLKyzWythfvOyPHuqXo6fmM7MUlG+lW4jtowQ+XIDk4U5UkLgixXSmGR0u3Xf/izNGcoJ7ePvE1S25OI80PzM411Ky6M1bA8HxepmV1ATUDdVWTSch4+zVmTHWQYisjzgcIkJhq3POKUfAnEIzHGnZDGctpG4kwn5bQCN4jJPm6VR4qQ4YMl3528P/vLbYSMg2e1cot6D+4UOolcnKO/k06wzwz4rDbyqBbSANbkbBBIauW/m1YDIn9SCN7zYG/ufWxPtYZfORyLLgJsnRS8vT8vtok60sb6ZYb
 wlb8tuNR
 cyr+Ou7gBnn5Clce8Bt31TF/hR3abGhOcYD9hjdEfnm+2XVTXOx/x0bK2tN+fSbNIfGwmYq7IDii1Xc+5/ngsvtbd5SNk6iDv+LyN/FQdAy8f+eEI9zbs0zAErtRdDh6s4z5wK7BgXoTJLX5KBLP1dKSnVwkYIgSSZg6EuuKSnhu3xdIcjAubP8YnrBoymfq1hlfROE5qUDTJy2ioeERnju6IOXnxcwRvZjexhsZHNHDfWlkTSN/e0/VT19JlB3foUZ4qlPg5sJu3gr0/F1yNhYkZcbjyDuWi6WMYS25eZ8D4X15PsxnXGg1mLNgj7M8jOUGlAPcRaI2UHj7kWljkUUipVSIvNYIWRb2QAg5VrpcpasD4+sjHky1tjtGJRqjgKJw585IA461C/UMRvwcXniHLn9nhnguhu5uriBvzpqHYuzI+2UL+ryzyAkpmCCBCnBTLUmepVitbmmA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As we deployed defrag_mode into Meta production, pressure spikes and
excessive swapping were observed on some workloads. Tracing confirmed
that this is unmovable/reclaimable requests spinning in the allocator
and direct reclaim, causing excessive amounts of swap.

The initial plan for defrag_mode was to rely on kswapd/kcompactd to
produce blocks, and if those are overwhelmed under high pressure, let
the allocator fall back (__rmqueue_steal()) after its retry loops.
However, that retrying results in more reclaim on some of these
workloads than we'd hoped, sometimes excessively so, spurred on by the
!costly order conditions in should_reclaim_retry().

The storms are dependent on the request type. Reclaim will inevitably
make room in existing movable blocks, since that's where the LRU pages
live. So if movable requests retry on reclaim, they make progress.

When non-movable requests spin in reclaim that isn't productive. They
cannot use the individually freed pages, and the process is unlikely
to accidentally free whole blocks to meet the ALLOC_NOFRAGMENT bar.
They spin and overreclaim excessively, which tanks performance and
triggers userspace guards like swap exhaustion or pressure based OOM.

To fix this, send non-movable requests, regardless of order, into
pageblock reclaim/compaction. This way, they help move things along to
meet the ALLOC_NOFRAGMENT bar. After this patch, the reclaim storms
and excess OOM rates are no longer observed in production.

The longer-term plan is still to have all requests, including the
movable ones, help make blocks to spread the cost of defragmenting
more evenly and fairly; combined with proper watermarking to reduce
allocation latencies in the common case. However, doing this naively
unearths scaling and concurrency limitations in compaction that need
to be addressed first. Promoting just non-movables for now is the
minimally viable bug fix for the above issue.

Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
Cc: <stable@vger.kernel.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/internal.h   |  6 ++++++
 mm/page_alloc.c | 31 ++++++++++++++++++++++++++-----
 2 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 6d3402001b93..5acba3470659 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1061,6 +1061,12 @@ struct compact_control {
 struct capture_control {
 	struct zone *zone;
 	int migratetype;
+	/*
+	 * Allocation request order. May differ from the compaction
+	 * order: defrag_mode promotes sub-block allocations to
+	 * pageblock-order compaction; capture still matches at the
+	 * original allocation order so prep_new_page() is consistent.
+	 */
 	int order;
 	struct page *page;
 };
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4b9686fedb71..f92055827ae9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4152,8 +4152,24 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 		.order = order,
 		.page = NULL,
 	};
+	int compact_order = order;
 
-	if (!order)
+	/*
+	 * If fallbacks are not permitted (defrag_mode), we either
+	 * need to reclaim space in a block of matching type, or clear
+	 * out an entire block to allow __rmqueue_claim() to convert.
+	 *
+	 * Reclaim by itself is primarily freeing space in movable
+	 * blocks, since that's where the LRU pages live. So this
+	 * works for movable requests, but not for others.
+	 *
+	 * For those, promote the order to help make blocks, instead
+	 * of spinning in reclaim alone unproductively.
+	 */
+	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
+		compact_order = max(order, pageblock_order);
+
+	if (!compact_order)
 		return NULL;
 
 	psi_memstall_enter(&pflags);
@@ -4169,8 +4185,8 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	barrier();
 	WRITE_ONCE(current->capture_control, &capc);
 
-	*compact_result = try_to_compact_pages(gfp_mask, order, alloc_flags, ac,
-							       prio, &capc);
+	*compact_result = try_to_compact_pages(gfp_mask, compact_order,
+					       alloc_flags, ac, prio, &capc);
 
 	/*
 	 * Make sure we hide capture control first before we read the captured
@@ -4215,7 +4231,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 		struct zone *zone = page_zone(page);
 
 		zone->compact_blockskip_flush = false;
-		compaction_defer_reset(zone, order, true);
+		compaction_defer_reset(zone, compact_order, true);
 		count_vm_event(COMPACTSUCCESS);
 		return page;
 	}
@@ -4455,9 +4471,14 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 	struct page *page = NULL;
 	unsigned long pflags;
 	bool drained = false;
+	int reclaim_order = order;
+
+	/* Match the slowpath compaction promotion in __alloc_pages_direct_compact */
+	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
+		reclaim_order = max(order, pageblock_order);
 
 	psi_memstall_enter(&pflags);
-	*did_some_progress = __perform_reclaim(gfp_mask, order, ac);
+	*did_some_progress = __perform_reclaim(gfp_mask, reclaim_order, ac);
 	if (unlikely(!(*did_some_progress)))
 		goto out;
 
-- 
2.55.0



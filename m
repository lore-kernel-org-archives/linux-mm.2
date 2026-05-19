Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43B62CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 01:25:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65EF86B00AC; Mon, 18 May 2026 21:25:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 610056B00AD; Mon, 18 May 2026 21:25:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 525D86B00AE; Mon, 18 May 2026 21:25:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 41A7F6B00AC
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:25:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C2A2D140142
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:25:51 +0000 (UTC)
X-FDA: 84782427702.12.E7DEA7E
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5B13E40003
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:25:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zf8ofgbU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779153950; a=rsa-sha256;
	cv=none;
	b=x4jbeoDdExks6WQP04T8QBYT4kd8hbJT/DgmE34dp/FxnGTberUqSeDfzQKUADAnMdMc5W
	6KLXtWT5kIu+1vYQtiUpUgVAjCYw1FPx8MFxnCh83b+k1u0ITZT6j+NsQGPA0WXWEwwD8D
	qrkpITHExib4sEV0QQG24A8ATP96nwQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zf8ofgbU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779153950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/6vG17en364be4oVrc/061pLrqYUD/S8MrGyGe4hKh4=;
	b=kB5AtjtzhOooWL0YIos3WsIlIfeq+Ai5TXw5Zb1vItZ6VX7wqtn/aeo7pO1jmbdtLvJLd4
	qza67ENlv/6tWuYZtzeTOjLwi6bONNog5ICSN3p2Yk3u7q6ZIr/w9JtGOm0KGUS8izzQaJ
	610MybvfIN5dPwIqfM9O+4/04sQOwLg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779153946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/6vG17en364be4oVrc/061pLrqYUD/S8MrGyGe4hKh4=;
	b=Zf8ofgbU/udYmUnVEAipdw/vDGqJ5paYw532aB40krWQ13PhkAD0tdfoitZ0qbairzlwiA
	XHv0XbX2GtcCX/3Zkqkb3lNgGFu3xc0I97XBwS8M4vlkoGg+8cG171wTOcTlWnogUyUwXh
	+INff1Y+khK3iY6kVEOutIw9Mu5UpQw=
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: usama.arif@linux.dev,
	kirill@shutemov.name,
	willy@infradead.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH] mm/page_alloc: skip high atomic reservation at or below costly order
Date: Mon, 18 May 2026 18:25:32 -0700
Message-ID: <20260519012532.272770-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 1q7t5rzsczyc7hnaoxkdiyhdze9ydxi1
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B13E40003
X-Rspamd-Server: rspam07
X-HE-Tag: 1779153948-374970
X-HE-Meta: U2FsdGVkX1+0Brluot3sZ/Wl4rCHjumD9cRAA5I90ciQQu05NzJv80yzoN3OhQNOpvg325MacsWtFTRzNgwg4WU34I+crJP0bx2tcuSj9UjJefTrIn58HsE1qW7WOfujGINDApyL4kba/pV+eiDNdb0gA01sHW2JefhGzU8DuN65pnA7mNwhVmDOv0u/c5uqREHqe4R7IArqSQHCLoI4XqVLGKIg+LSPUgtWjaje1rNfZ3VZZHwsL7oTQ4F3Z0yW7fRTBjX5AC36czJkKng1vVa9zdxIY6eX08we1WJ8V76fLMXyCH02K+GpVNrEe2bQx5OI3HZ7wkY1i2rOiwlSU2s4fCcSYTrfRmSLJRydtiegIwByk2TkE4DA7Hyk1RyxRhYUiQh6BkG5POmRM87LiwY6aZvrH5dnJmgWDbxADwBEx20kaQSv1ESt7PFHiVHhsOmkVg56+P5wrhgUQHctIMq2EAch060gpw5a6hnQaH/ElMsFYRSeoAZOjDqHUgY1GObRAjLWcJAFyW08ia2+9vVUIKsHPpGhl1xSLKtpjCR89e5OuyNcgcNSBpV0jKSJkIzMb03i7by5EQw2jel7VqFAWa2bRGeLzJJlU25IDvHoWAbgHTYywEdteewvR1DFyQ0+s1GMbM2kQDoFAsXj3jd5radXhqZnLwB0j+yUlBdcD3ES1e2cXIAcoHeMQAqKcZii41ftbRW8n6URNgNxbZ6diG4PhtysD0Ff3K2whxinN8FoMPxDEV1tNxhJijDw28umV0VGAo5b6B0WyAiieEh+gQ0hJHuOSFl1XFJA7A3anquTe3a2y2lOBU2z2PgH8VwIQMf4gpZQp0hWpexM+Y0L+hmintS92IJSi4iySVgBKSXV7vRfxE88PVyw6ja3dRs4TnIJq7NGTsA7Nsgb+Ky+wr9I37p48JSODTOagDUSy3IQnzwz1iGuq6lWwmQYTPBX5sKETc1tuTuZijQ
 9qoxa/dV
 2l8JKglF/c4662r5Fm72mj3k+8qlyfgB8OPNEYBVIZ+ZdjCZKuVJAVxmyTJaZ98ssn002dCX8zy07seh7UkdNEevtrRG1gkjRZYAqOQ+xMoE67X66Z1D3h/bDjSbJMbw+Ozto95kf1l+C6bTEKjsbsIoUz9gHO5LnyskR7CweI6Vp/iKOPdFMNwrD6qamLraYXG+CtCXFX3JzdQ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We're seeing a pattern in production where 2MB THP order-9 allocations are
failing due to fragmentation and triggering reclaim on systems with plenty
of free memory. Over time, the success rate of these THP allocations do not
increase at all.

Inspecting zone->vm_stat[NR_FREE_PAGES] via kprobe on compaction_suitable()
indicated the given zone had sufficient free pages for order-9 allocations,
yet they were going unused. Drilling down into the zone and inspecting
/proc/pagetypeinfo revealed why. Order-9 blocks were accumulating in the
zone's HighAtomic bucket (while zero were present in Movable). THP is
unable to draw blocks from HighAtomic since that bucket is not in the
fallback list.

The heuristic for reserving pageblocks in HighAtomic is that any atomic
allocation greater than order-0 will result in the full pageblock being
captured. This means that an order-1 atomic allocation will over-reserve by
256x, a full 512 pageblock.

Gate the reservation on order. Skip for allocations at or below
PAGE_ALLOC_COSTLY_ORDER. This prevents smaller atomic allocations from
reserving entire pageblocks, and significantly helps when THP is in use on
a fragmented but otherwise healthy system.

Testing was performed using an A/B instagram workload receiving prod
traffic. Each side had ~60 hosts with 64G memory. The patch resulted in
several gains:

Unpatched
HighAtomic pageblocks per host: 309-312 (1% of zone or 620MB),
  ...all order-9 blocks in HighAtomic
THP success rate: 1-6%
Compaction success rate: 0-2%
pgscan_kswapd (total across ~60 hosts, per minute): ~70.2M
Atomic order-4+ allocations: 0

Patched
HighAtomic pageblocks per host: 1
THP success rate: 44-78%
Compaction success rate: 24-47%
pgscan_kswapd (total across ~60 hosts, per minute): ~29.9M
Atomic order-4+ allocations: 0

Note that for this workload all atomic allocations were order 0-3
originating from the network stack, btrfs, and scheduler.

Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
---
 mm/page_alloc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e262d1316259d..45d8f6844f510 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3446,6 +3446,13 @@ static void reserve_highatomic_pageblock(struct page *page, int order,
 	int mt;
 	unsigned long max_managed;
 
+	/*
+	 * Don't reserve a pageblock for lower orders.
+	 * Order 1-3 allocs should not capture a huge page size block.
+	 */
+	if (order <= PAGE_ALLOC_COSTLY_ORDER)
+		return;
+
 	/*
 	 * The number reserved as: minimum is 1 pageblock, maximum is
 	 * roughly 1% of a zone. But if 1% of a zone falls below a
-- 
2.53.0-Meta



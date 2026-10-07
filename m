Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BFFECA5FED
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 02:14:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C5AA6B008C; Tue,  6 Oct 2026 22:14:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A5796B0093; Tue,  6 Oct 2026 22:14:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D9676B0092; Tue,  6 Oct 2026 22:14:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 06A2A6B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 22:14:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 609701C3071
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 02:14:16 +0000 (UTC)
X-FDA: 85294210512.17.9FD40C0
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf10.hostedemail.com (Postfix) with ESMTP id AE148C0002
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 02:14:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="IslIga Q";
	spf=pass (imf10.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791339254;
	b=zL5U2dkJFKQEAh5UuvtmdvhlPxgQBAvPjXbEa7rTjClkn4VhyYAhiHvTKMSXR+s8XPawz+
	VgyRT2WXKgq5bwfUy8iNrZegpK08lfN6vQFTagTYLEhwOKJyBeiEagStBKRZai8cR9w189
	PwI8br/9wvHu4OjxDbACTK5IUfNOge8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="IslIga Q";
	spf=pass (imf10.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791339254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7tBfzHXIi89MaBvjTTf42y7BMLPv9LoC3Ff1kliJK8g=;
	b=l1hX4XVAW59YEs56s7icjN8CpRa/yz3cQxp+1b1TAMBllm0MExUBiFhMruL4XdjUOOe3nk
	lvs5y3hr60Oh35gc8GZrFxCcKgHhj5zExxGmhTtLZY4PAfzaZ32lKJxTIfCIRebabKwxCx
	0vJsCYwkzu+j3kWPq2gcK/XeD9KalaQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=7tBfzHXIi89MaBvjTTf42y7BMLPv9LoC3Ff1kliJK8g=; b=IslIga
	Qs+odbzFKPcR0fw6DynpsbDDgD53St9fs6UBBaCmucilpEpIZ1ak/9mYAUPXiqcbbXCBLYZcnpm6Z
	j8kpvio7JYY+avHxEfTdRHCxtkGtBFi4gj4UOd6d2PAqR9drKptzTfnAiJGKiaXdPFckOHPivTAEJ
	hstKxOT41kcQFEd765WC7rrgpX3YAUyTnZ/ab+BQxpWB+s5KrJkjDI6uda3/xxi05d+29qI2qydEl
	eZAOBSGuehmyiujY+FhL5D9ZIC8DrqQj9xKC89DOiMFsTCVxb29tgGkSHFtATvkmbZX7Bt3jvGBs6
	H6qVaIdS+m4kT7h+Ao179RopBJvA==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xEH9N-0000000B2cT-0AnC;
	Wed, 07 Oct 2026 02:12:57 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 4/5] mm/page_alloc: skip movable blocks during non-movable steals
Date: Tue,  6 Oct 2026 22:12:49 -0400
Message-ID: <20261007021250.1665929-5-riel@surriel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261007021250.1665929-1-riel@surriel.com>
References: <20261007021250.1665929-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AE148C0002
X-Rspam-User: 
X-Stat-Signature: mgn9sms8uxkt8owm8xg43iqpbid3cmce
X-HE-Tag: 1791339254-99205
X-HE-Meta: U2FsdGVkX1//1FqvZ6YnNViO3osmupb01rHiyO6+JTQ0Af+4AZY744XonEtKV3A0qzmmuapkEqL4xQOgzFIgTCRX2YiXQVmrN9qXWbjg2sihzjVXQb0bfYd1gPb7vaVK5jT6mhwPrOnukM2xb6rbirY+VYnbVyQXRl9/oByA8sbO2JDpk7XQsVUCNl70D56/qX3jM979ErnnZxulKaTUHSUFE5JM9h//Pe33bB1jn9XbBZ5JpyajfnBOiErh2s6AjZkSsb5ZLOd3bqjqXllsakET9WfgTrzwp7h/0/ZfLvbxqLiE59Th8ZnK57asoJsDGarFAE5PD7ZG8G5TDU8J983dLgM5AXCPwgit9mHxTtIAMPE+6lS0tkCr/8gRy827M6QydVTyWM3meeHb0ZZ0kZ8z177X3NJ1YRihJhFjhEcS9ABqZZpT8jcu9lbwun81Ta9m18UwcdC/DCXgSMQvoUbAtTpCV0802b9BV2VSTbEq/6lTi5YescmH44wu7ECIczl8Jo8FMT8oTn6yukUsk39hkYyxFpKxZSpG5hc3F7b0Gtc8Irsk/3DGiJIOwq2hXzP5B5yJjdJfGcU7u7Tt/53uIiZopbEVkilK2zbg/rsHYgvwiXvWg08yhQXbqroedngKT/QI7dk7QAkkvMLclmamr+tUbeEjYirPSZ7kUbDzIzhULz79GO6lIWuoTKifQWs1Sfc5RI64v5AZcYlIIH9he/n8uTcWacFO6FLjc5mg23uWcbCxXBC+S7LbyiNMjoOQzzA0eLB0EwgXxP1pzGxFb09vdfr8+/aUX/9wbbo2DOd1TQ9Cm7PLEtojfyeZET8QhCF7a6QKUrvAcdoXrRlgjuEdQ+PLQ6pHiEIiq6qC1K/2n65F7cDvVsw4FddQ8S5X4WZJjxmzTt67KOL0aqGWGAq5wRhhipzb8G8pwoC1mMK/yoggQAYFjUMDOvzUl1YCB/3zGgE38EDpEnf
 UHnIDXUL
 Iq0lmBNpMwkJKBWaegGVLlhLkOMZkLrAvFWB9xpltvomwercePzUzkfzYrNNTsWjTU3Un7Gb8vHRuZ1LslG6yOOY4hHb9t7jzjJK+NrL+Sb2b8nVBIQX+HTh0p71D/TpPqA7xxHEIHVeDypW0gaRzJXZCOmV0kWO9QMskVBeUNkTlHsms35DCR/T7rgmgZuIodcB+8NZ6MEtz2IRJS9w49DEFhWkSkjEzDQL5AlI+E35oPJioJVk+vV2p++wZxNLx3MQ15pUXLDqujhWGrPBwrLizmM6+74yzTU7oZkOUObI2QD90UEu2UGJFVqBJSn6DfVPzpy/Ko5l60pflDSd1r8puaD/YlDffRyiQz0YbM8pG1ROl0wyTjuwmBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__rmqueue_steal() hands a non-movable allocation pages from a
movable pageblock and leaves the block's type alone. Those pages
can never migrate, so the block reads movable to compaction while
holding content compaction cannot move. On a 3 GB guest running
ls -lR / and a 2.4 GB block device read against a fragmenter, a
temporary counter found 2654, 5341 and 5272 such allocations in
three boots.

__rmqueue_claim() runs first and would convert the block, but
rmqueue_bulk() remembers the mode across its batch. Prevent
those allocations from placing non-movable pages inside
movable pageblocks by refusing __rmqueue_steal() for non-movable
allocations in movable pageblocks.

Movable is last in fallbacks[] for both non-movable types, so
only a larger order is left to try; failing that, the steal
returns NULL and the allocation will loop around to a claim,
another zone, or reclaim.

Keep the steal where mobility grouping is disabled, or where
the block straddles a zone edge. A block that straddles zones
cannot be claimed, because the allocator only holds the lock
for one zone, which leaves stealing as the alloc path there.

Movable allocations can steal, because kcompactd can always
move those pages out of non-movable blocks later.

Over three boots allocstall_normal runs 48 to 129 against 32 to
134 on the base, and compact_stall 324 to 415 against 288 to 387.
Neither direct reclaim nor compaction stalls rise beyond
run-to-run spread.

Assisted-by: LLM
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/page_alloc.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9f1520506ae1d..16d3594d913a0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2423,8 +2423,10 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
 }
 
 /*
- * Try to steal a single page from some fallback migratetype. Leave the rest of
- * the block as its current migratetype, potentially causing fragmentation.
+ * Try to steal one page from a fallback type, leaving the rest of the block
+ * unchanged and possibly fragmented. A non-movable allocation must not steal
+ * from a movable block: without converting its type, the steal would leave
+ * non-movable content under a movable type.
  */
 static __always_inline struct page *
 __rmqueue_steal(struct zone *zone, int order, int start_migratetype)
@@ -2444,6 +2446,19 @@ __rmqueue_steal(struct zone *zone, int order, int start_migratetype)
 			continue;
 
 		page = get_page_from_free_area(area, fallback_mt);
+
+		/*
+		 * Do not allow non-movable allocations in movable
+		 * pageblocks; that could break compaction.
+		 * Non-movable allocations should claim pageblocks, instead.
+		 */
+		if (!is_migrate_movable(start_migratetype) &&
+		    is_migrate_movable(fallback_mt) &&
+		    !page_group_by_mobility_disabled &&
+		    zone_spans_pageblock(zone, page_to_pfn(page))) {
+			continue;
+		}
+
 		page_del_and_expand(zone, page, order, current_order, fallback_mt);
 		trace_mm_page_alloc_extfrag(page, order, current_order,
 					    start_migratetype, fallback_mt);
-- 
2.53.0-Meta



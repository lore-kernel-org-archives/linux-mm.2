Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18CBDC5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 08:18:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23FFD6B009B; Fri, 21 Aug 2026 04:18:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 217756B009D; Fri, 21 Aug 2026 04:18:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1547D6B009F; Fri, 21 Aug 2026 04:18:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E82F96B009B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 04:18:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 734FFA2FDC
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:18:04 +0000 (UTC)
X-FDA: 85124573688.08.C089E6F
Received: from mta0.migadu.com (out-156.mta0.migadu.com [91.218.175.156])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7D12940002
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:18:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kyq3VeJX;
	spf=pass (imf04.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.156 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787300282;
	b=xJJMwJdqE6uu6J84CKgeaaRD2HFDxIkLAqKfW8Ph+gdkKMdMt6PIUeE0h8UsR3/+JJlkgN
	gcoA2OTlkCIOKbwN/pJKs7F8DKVUfGskvs/6bnmYHb4WnAfeELQjTN0TlaR4CMf48lJL5N
	WO/5FXz6SiQXPzBZuQSRdY8ioS7UiIs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kyq3VeJX;
	spf=pass (imf04.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.156 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787300282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hbJ6qX8RI3gMK5y4jHxx2USxOUGxbnF2MpuECV9enVg=;
	b=3nmFGypek2XL1PQFmXrz7Y9rlziO2GfqDEiRRpndCe3LZRpiwzxVZh7dILuwJC7JigvbUx
	f97ZI/ObtFRuvP/hzzlCtGPKjZBe0T8ie7aF74AXSuUfiq39RKpD/DA42wi88GLtCBSor0
	s+Fy8qiE/usyWQ1zuPyzWbYwh0GT7RU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=q2LBYSGl4npt3b/U4TgoApNxg/auAjLyjB3dvIGUVCE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787300281; v=1; x=1787905081;
 b=kyq3VeJXQcnnlz5UHJ6NDw98y1YRwhlNRYbFXHEwvNjHJwsMYiv9AQTvnOsqtfBy9O4dgd4R
 H1UnSSI4LZ8kusgMemM5Y139IRV0oMfNSR5Ht5WbaqwgfaJZf/7RP0jIiqKM8jQIspcGCe7G70k
 3BPOBYGngLsH+PX9uS1ZzNvs=
X-Envelope-To: linux-mm@kvack.org
Received: from mi-ThinkCentre-M760t.mioffice.cn (14.29.108.92)
	by smtp.migadu.com with ESMTPS id 89c40d2368cbfa1d;
	Fri, 21 Aug 2026 08:18:01 +0000
X-Mizu-Trace-ID: 89c40d2368cbfa1d
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [RFC PATCH 0/4] mm/vmscan: honour node reclaim limits per type
Date: Fri, 21 Aug 2026 16:17:37 +0800
Message-Id: <20260821081741.1340277-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7D12940002
X-Rspam-User: 
X-Stat-Signature: m8wi6syz3bhoqwhh9qhzophuadw313yw
X-Rspamd-Server: rspam06
X-HE-Tag: 1787300282-405385
X-HE-Meta: U2FsdGVkX1/KnxFCUECWtogw0YVXIi87rXzcqnrZwnK/6hH0QcQAbnL/7GQaHYgK7MObRv131pek5k4TD4DXZs/RWyGVISBCM36CYvinRz8B7ZoOvPuZnNkQGioVPmb1x5BAvoTqPDGEq+R23fb7P6tD7KAiM2qKm/rP35KgPYiUl+pqZV/Bxupwx9VdttcLXGEfhJ+I7vbO3zHZPPtdLcrKqFSPkYv/ek81+fV1uOeJPx1eBG/xuaS/Xh9DxyUy9cRtudCnXu5vXhhzwgVrTFKBZ3boKflDVa2BSJGAAXsrE55BCtOMpTZRixxghYpXJQnwD13hqHHErSKIWhUV10KgFedc/kCUiIFJdQYyyb11tHyaOfa9K38ZXkjQSskninvP0OBF+ImNAG+QoR6S9ML8udhDwwOqylRbqCQ51zvNR2blvfhbp2SOq8AAjHHeXhIZIGXDGR76Zr8OyxBzM0TK5j5q8TaIFhTVmm1yNWBPrUPkvI+kTt4KRcgRJ8Rd2huF9LkOwZa2ZlmFFLjWqGFhDXFv05SxEsxuRlvomcehC2CClhbMCY/1Pnp6goRk7oxRJLb+VdxlqGapnHBVydf5iXkwy4brZXoexgeQT+5i1mPZDCORTr2e7aYruXCtKvwHPP/htuB1m/TvfWf7KSr1wUvg5GFpGf9Ow6Tw+2MKyT6Lix2KLQt/wPPbWHPjKw3ppIKOAqM1pEtLGr6PJDUApsGdHzptR7t03/S8pBDno4wSR5gJTNBosuyoEx7vjToAAinfeFfH45of9hrQjO/QYAIMmZkpYJltAjtynmc9nx48BERNCI2RtmWlEFbZgGdWQQtikezZ4KSD+iXa6moT76NtzRQyP/gNHQFP32GZL9zh2f3FkZO7w6UIOillkGqK5ItHBcVLTZv9IgHnustv/CCTlGoJwDJW8CU8ouo0L/Mw5LKrymDnmq/fXMHLlx3qAscBZPJ0s3SnD+f
 xozic8Tc
 Kb64sGPJr60lVh7JFKgA//AaVtjsmOOyZza16w+DtHEkVzZa5apDQIOV3QxvhfjnDBWqTluq5SCRd4VH7H6uhNm6l9QQL3EwTe5VNkrZ7rK12aVUOA+bi4GrEWXY3z8hpYiC1eTP48sroRXXYhui+SLOIGdo5v9VWJbtcIT9+18lmcTi6Qj029tXhpAmcpv2jwsyQxWbXv5k8w9wI6+akxAE83MO+nBrdoSEouWRG7sPKxmXmiyjfRkT/NbwKAMrg4HZrrDgq0y5ryUYYeM3CdydowOhcgu6HdwK/wQ6U7JzYU1pF6F0b1QiKtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

min_unmapped_pages and min_slab_pages are documented as per-type limits,
but node reclaim treats them as one combined gate: once either is
exceeded, shrink_node() reclaims slab, file and anon together and pushes
the other type below its limit. Per-node proactive reclaim reuses the
same gate and fares worse -- with page cache and slab both under their
limits it reclaims nothing and returns -EAGAIN on an anon-heavy node [1].

This series gates each type separately via two scan_control flags
(skip_slab_reclaim, skip_file_reclaim) set only on the node reclaim path,
drops the combined gate, and extends node_reclaim()'s early bail to check
anon. The flags default to zero, so kswapd, direct, memcg and drop_caches
are unaffected.

Tested on QEMU (x86_64, 2 NUMA nodes), A/B kernels differing only in this
series.

Proactive reclaim (echo to node/reclaim) on an anon-heavy node, file and
slab under their limits:

  metric              before   after
  -----------------   ------   -----------
  pages reclaimed     0 MiB    254 MiB anon
  return value        -EAGAIN  0

Node reclaim (zone_reclaim_mode) with one type under its limit -- the type
under its limit must be left alone:

  type under limit    before          after
  -----------------   -------------   --------
  slab                645 scans       0 scans
  page cache          83 MiB scanned  0 MiB

[1] https://sashiko.dev/#/patchset/20260723045718.2052070-1-ridong.chen@linux.dev

Ridong Chen (4):
  mm/vmscan: only reclaim slab in node reclaim when over min_slab_pages
  mm/vmscan: only reclaim file pages in node reclaim when over
    min_unmapped_pages
  mm/vmscan: drop the combined limit gate in __node_reclaim()
  mm/vmscan: do not skip node reclaim when only anon is reclaimable

 mm/vmscan.c | 89 ++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 67 insertions(+), 22 deletions(-)

-- 
2.34.1



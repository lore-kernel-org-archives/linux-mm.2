Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30DB2606A33D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JAFlrt5z
Received: by kanga.kvack.org (Postfix)
	id 984676B05D1; Tue,  3 Nov 2026 03:01:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9363E6B05D2; Tue,  3 Nov 2026 03:01:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 823EB6B05D3; Tue,  3 Nov 2026 03:01:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67F776B05D1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:01:33 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8B166A7D49
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:01:32 +0000 (UTC)
X-FDA: 85393063224.25.89F422B
Received: from mta1.migadu.com (out-58.mta1.migadu.com [95.215.58.58])
	by imf11.hostedemail.com (Postfix) with ESMTP id 95AAE40011
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:01:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JAFlrt5z;
	spf=pass (imf11.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.58 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793692890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=52KCXwmm9ZCNyw3KBw/dQ/3mW8BHvTfiOxfI1L0wd18=;
	b=Ueb7KzPVDAY/Wmp0MwYFNSYqaFQYDmDNbnQlVi6+B2T64meLaTOIUA4CeJjvcpjbixuOvP
	Xp44OZJFQkRaGJyPQTyWT3Gj6x/0ZsWQq2m/f/bYbuIdMHWmpHEIxrvixUvFVgUTowvRXs
	lDbAj6wTGnJ3f/23Zez5+/jZKQNwZFM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793692890;
	b=IqP1HKY8I8cJLwv/EElmMLaNdOlxElE0k4z/Rzns36mrXspH9wS5axQo+l6aJp6PGTcT9C
	MzwmmZZJMFTrDsLvUCzYd/QY8K/PuLTxHqh8NqVlmxFOTtVxD8fIc+WZU/DYRgKSLv+8yp
	tASNEzP/xxIXfNtZYrsHiGk2c2lC52g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JAFlrt5z;
	spf=pass (imf11.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.58 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=EbWR22LQF8i7FNouXAnt5TAEQhSWkm045nRZT2gB0fY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793692889; v=1; x=1794297689;
 b=JAFlrt5zHrloovNEv52uOljvv8Ada0Z7DmXl4q/UvI0lNWNARHqcLu+tgnoV9smUvNdFtM3V
 ZqFyXeby0JHQ5rDDt1Pv7s7aWv6Nu0Cx953nyDoT0eCc5qxvS27yAKVPRODA7czR+ewk9ypLiBi
 qAXe37CDRVPgZvBo1zbRcPhI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8deed9b99d672b83;
	Tue, 03 Nov 2026 08:01:29 +0000
X-Mizu-Trace-ID: 8deed9b99d672b83
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	azpijr@gmail.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH 2/4] mm: hugetlb: skip CMA allocations under PF_MEMALLOC_PIN
Date: Tue,  3 Nov 2026 16:01:05 +0800
Message-ID: <5bc00742fe249cf09a3095abccf8889d5fa71116.1793692578.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1793692578.git.zhengqi.arch@bytedance.com>
References: <cover.1793692578.git.zhengqi.arch@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 95AAE40011
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: dg5e7mtnak3ttp3xkhdpkunquayu6dzq
X-Rspam-User: 
X-HE-Tag: 1793692890-610746
X-HE-Meta: U2FsdGVkX19jDW6knfPBmRhYlW7YOhQ9V4SotJp2yWi1SbPvnRZlJI7mEO7bNI/kXLpGpWReWsgAErQus4JyCiadrLyq/8RvDhw6mCU0uy4Lo1ZjD4NWgoXUae/5yPWTQU8NW3LBWCZzzBAreip6cjMvh4nFRlcwPpdbGNFOQPvTe//XBSGZFMRnZj6wAHODwOActK959j97/loD7Jk16D17p7UDIdshD6vEY/L+DT26VTNHWruB99ehQsA4ICd87BX9I4Dd2bTntq3TvSgXayUHwFYbHnfmHy4mXmPaZiX5RWHLS+9l7ZZ8Lyyp5gpMB/X9tV7/oUInh2tZHvcP60YNa+6B/8c6RK6MPQ8q68iGY1yDe5x1x1TgwrHD4bIOKqggMdfPUu/3kpGdzOXjMV+/OETVeSwfSF7QvyZE0aUU+UXM/X38XU6QxqrCs7Z6CrHtysqOs5MOlDgsoisGgwXMtokzfEBgDATNbiB6BL7oqNrugmM3NJYBhDGzEy9deoZ69Du8Dyt7CGldRf7+SsGii/HkoEAA1iNILAzTqvFDa5krwjyGjE/SVSuA2jhSjsxX2jFsvba2QqlVeCbMUexVv/pAgkERkvxb3Mh41qvx2AaOywcquOf3QzC+6dXETIHTqP3qnqcvC9X61U66+grx8m4jObNQKIzwB0YXRgVsQdwnKFVuKNJdLR7c1bH2wHqfsgKzhimLrydEvk/Q3fsqCDUceUaQcxS8yHrMCS7TyIHI+H/HgN2ER4FeGk4FLC4jWf5pPS1LetjkWCse36gn/9JvXVjwrejK3DPtTOYbuj9bC+5tTDTztHtiT+qwjrEoQDJt3mjIyK55CQZ3ViGkuHdi7hnnfZfiK6fJYcHdbHdoBJjk8A/eJog6lpc2FO8TFUpooVcP2XMSXYM/UjaV07Pqa/BVXQt13egM7KR9bO3IBDNEOfPMQolFJZD5HyB1Gy74lzBaYou6Jcf
 9C8ARlPC
 7R7AWSU4BEXOaq82lTznxEzFQsz0aWCgIt5maWEdOCwrEjrxTVK37aNeUxdGySllXN4+REAnu7ACyWxa9mHWD3tJyTbE8f8MoeB7do8Btw3/N7xb0F858VhkeRyihQ6zvt6WhrcsgNOnSyYyB9+YDhJV+IV2TZSoj2fEEZCr52NjHjVHAXvvq/OMbTKR+NiGJd4SAL/9THUQIpqPIdmBZ6edbf0tjkvR6vpEDLLZJyEST2bdUsof4He5+mDpGH7Kf7q4mAqFF+taW+AuZYAOJaiOyeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Qi Zheng <zhengqi.arch@bytedance.com>

With gigantic overcommit enabled, a fault during long-term pinning
can allocate a fresh HugeTLB folio from CMA despite PF_MEMALLOC_PIN.

The folio must then be migrated before it can be pinned. However,
fresh gigantic migration targets are not supported, so pinning fails
when the HugeTLB pool has no suitable target, even if the original
fault could have allocated pinnable memory outside CMA.

Honor PF_MEMALLOC_PIN in the HugeTLB CMA allocator so the fault can
try the non-CMA fallback, or fail when allocation is restricted to CMA.

Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages")
Cc: stable@vger.kernel.org
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/hugetlb_cma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 95fd2d190f0d2..dde1c866406fb 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -62,6 +62,9 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 	if (!hugetlb_cma_size)
 		return NULL;
 
+	if (current->flags & PF_MEMALLOC_PIN)
+		return NULL;
+
 retry_cpuset:
 	if (!nodemask) {
 		cpuset_mems_cookie = read_mems_allowed_begin();
-- 
2.54.0



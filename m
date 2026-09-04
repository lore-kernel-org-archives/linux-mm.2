Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 271DBC61DD6
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 03:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC5C06B009E; Thu,  3 Sep 2026 23:35:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCEFA6B009B; Thu,  3 Sep 2026 23:35:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B655F6B009D; Thu,  3 Sep 2026 23:35:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 753916B0098
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 23:35:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F273A1406EE
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:35:16 +0000 (UTC)
X-FDA: 85174664232.26.4339727
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf22.hostedemail.com (Postfix) with ESMTP id 369FDC0004
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:35:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=g2awA3gt;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788492915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qj3Huu9bCMAMtfBo9byDIptTGO/Fh1SmkPuNKeo+iXw=;
	b=WkxIKnAUcuMf1tdr7PgLR9xjziOW/oUxk9nPRnZPH2AcxvyB+9zhtCXlEUtHFSB6KDtKZh
	S7lHAqnUsRKQkTV5tPAOGbCNlm7aGdbdu3ZbhWiUV9FI2K4296a3HP3y5yZkXuOdTQhmjD
	K6VAn66Ilr7BlVgHMr7SL8EUCzvmX5s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=g2awA3gt;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788492915;
	b=rbPyAJDL2ZaQsxJYw3/9v5HzjsRO0R5y0V8zfM0vGFGRZQZRonpECsbXgXN4Bclxnk6J5f
	DsRfr7Y2Fw3cRePo31HR90NXl8tYKkOJ0qovwWdeVhpcVGGVmrcJC5gbzoyqDfXX+tpZmB
	4p4aH9j7RMfNWRs04gEV1AC0yhQLO+c=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788492911; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=qj3Huu9bCMAMtfBo9byDIptTGO/Fh1SmkPuNKeo+iXw=;
	b=g2awA3gthqHz4AZzWn3hgdVl6CIXXUjZ6huLS1D2LMoLiJUQQRRF0TmoOGyk9U3TXRBcfvUNGyX5N2F5UxE2KtFd2qEyPT9a/rpuiMcotxKmKKZbZcgjJsx7ER00qOIWM4ySQ+SRQMkVgnxRvZ1N8/JpNPLf4w4FmTatEh+F+/E=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XAHQrK6_1788492909;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAHQrK6_1788492909 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 04 Sep 2026 11:35:10 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Xunlei Pang <xlpang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH 2/2] mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB
Date: Fri,  4 Sep 2026 11:35:03 +0800
Message-ID: <20260904033503.4067283-3-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260904033503.4067283-1-qinyuntan@linux.alibaba.com>
References: <20260904033503.4067283-1-qinyuntan@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ckdhq8iipqdq4g3hbpazugbijuzbfsn7
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 369FDC0004
X-Rspam-User: 
X-HE-Tag: 1788492913-170612
X-HE-Meta: U2FsdGVkX1/p69zkX723SSUU70q7SNubS002OiLgWDlGFRQdJ3O0KdsgpBRdgDXAIDeFRbPlrT0QYRKHT0OOVScX4lcasprs+Yus9szz1siI5yZ244V1tcezgeTI6cp290lGcn05oYTFSrXSS6QMn++Mx5vNU/jsXxXdvqXdncb+NqbMjm/iPxyPlHwdHg4JOCcksiMWugKE5fxEvKkBOploKrBKmBRaef2vcDh2qKWfQoW5N7lQVEhMHDhBAx73rGEKchNmbZw4QCgC78R1XpHvwETWONh1+VrSwRISiwZ+NyX5k1xOsJENmMf0QhRW4tHAx8+yYG5X6NtYuehwaoEWVKtm9EnVIPsc28PiSHkrmnC8oABsZXCYgx9WCRrdhCwua3Hvy/3ITCky6YlXtJy8+aH4Ruv/S7kljqHR1CTbG9cK9RTNYQj8BX4X0H1g2KM8laHT313lS+VGzi78kvWpfRYr0hNz0HiC5ntCpOiNbw8KeYO4rilNy5kb5soQTmKMWXaeHsLWcI+qokmjyQzzuorTCM/9cjFDxjiOQxB4faLokRkdzChmFU7Ky3+oJhjqWc5PJXkThkrJ/tDVqzlP+IIsyoJgaECxljAwrQCzs1wwsNPCCQmGrpcqpMiOJC3rKtwQnT563TtUpH0E8NRDJ/mTSkvoZI7n3s1FVChd5qzotct6kNxT4H6VMlu2IyZ7J11DT+hxYtq1rMRX4IiPm10BLaJCWRzBfAEP+8kXWhaa2Ue5sH5+3KD6opsXnPgQGfUvN8hj4lKudgk6tPnxUUNE0rJWa+dtuwsi3LpD+VvasbKBmBCfMENsKJ1Bf6KhH0qPqXF8EjgL3sAS5BfihDjWODe3DvJR9jTMDIrJZ+mFOn0sObJsM4tp4qzBuNjSI4EQNiilL2b2bdqRYVTqhHdiya/I9uOfHBZOM1hy9BtGL8kkYrAUNL23m9K9hSYr1AyttS2hAo6Lwv4
 gwmF4WKv
 tDxuhlNuWT++P5vejWnFH84GQMxcXSHjvJ65ZHo0UeEu/Caj2w8j//p3XESMB1sxeIxB4qj1Y81WAXHRHQDIUznQ8eeDLd8HvjXVl7SyRyV/Pc4jRHTUhmPchMq54RB8KbbHgaXhn1WySvt+HwVXSPaQ0xUth9vHWLbRFvgJT0GzTOWHgnLPb9HvWjjLuD+aCobxTnGCylnjpMKqrNKtz6a7oeo4z44AQufcAliiZByE8dOZ5BvjtvLxDPQSvaMo9KgrGwo9XCpva0A1J4rOG84fYtCfU2mdUojN/eqGtNzhNDPuCpG7dR79j9TEG4vpYs5cK139YCSjj/+mP7+I2+K1Pau7oruoC4GSypRWvjVaEDZDWhoUhfKgRE0eXZNfyMuDOBslk6OzrBDnRDNpJTPL4qyKtUjiSZjZ6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With kmem accounting disabled (cgroup.memory=nokmem), memcg reclaim
never invokes the zswap shrinker: a cgroup under memory pressure does
not write back its own zswapped pages to make room; they are only
written back by global reclaim or once the global pool limit kicks in.

The zswap shrinker is registered memcg-aware but without
SHRINKER_NONSLAB, so under nokmem it is treated as a slab shrinker:
before commit 03375203e1da ("mm: do not allocate shrinker info with
cgroup.memory=nokmem") it was skipped by the !memcg_kmem_online()
check in shrink_slab_memcg(); since that commit it is demoted to
non-memcg-aware at registration.  But the zswap shrinker is not a slab
shrinker: it tracks zswap entries and resolves the owning memcg from
the folio's objcg, independent of kmem accounting.

This was noticed by Michal during review of the patch "mm/list_lru:
don't copy stale shrinker id from non-memcg-aware shrinkers" [1].

Mark it SHRINKER_NONSLAB so it keeps its memcg awareness and runs
under memcg reclaim with nokmem.

[1] https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/

Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
Suggested-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
---
 mm/zswap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 761cd699e0a3e..8bcc2997d7719 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1263,8 +1263,8 @@ static struct shrinker *zswap_alloc_shrinker(void)
 {
 	struct shrinker *shrinker;
 
-	shrinker =
-		shrinker_alloc(SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE, "mm-zswap");
+	shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE |
+				  SHRINKER_NONSLAB, "mm-zswap");
 	if (!shrinker)
 		return NULL;
 
-- 
2.43.7



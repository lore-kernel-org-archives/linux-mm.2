Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E678C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 04:38:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2365B6B008C; Tue, 25 Aug 2026 00:38:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20DE96B0092; Tue, 25 Aug 2026 00:38:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 123846B0095; Tue, 25 Aug 2026 00:38:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE79B6B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:38:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6FBD51C1206
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:38:57 +0000 (UTC)
X-FDA: 85138536714.23.1F4A1FB
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id AF38D40002
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:38:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="dRP/5vvk";
	spf=pass (imf11.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787632735;
	b=HvJV51SKKgkSLme13xdIB6/eL3KyxrDE2p1rljMMqCr/YvVJd8jdThyqRTjZ1+flsCy+bM
	iMYVkhJbufb8jhct8jTBBcOE6w6oFEV0UIgWaKJJmpIvi/5XzI66bXF+rPll5xU+INTicx
	khTKRYwPfFqX6iywPDm4/iLdfvO7vJo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="dRP/5vvk";
	spf=pass (imf11.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787632735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WxKMrIReQlVr3GlN6gcG3Xq0u0n+Y7Tf1sth/0rO+pw=;
	b=08nTzyzjchAQOq2R7Zq9vl4rXc400Mk7qkZglAtzz8d5bGBK38FWcX7c1sifm7C1/VBpU/
	ttH2cppsOhz/JLmSGDgq9IeAuvCSqr7a+vjujF/ir0BOtjfLsct074Q+Zu/QZA7FIUyloc
	tLJYAOS6zwV64rIGCw+KrwizBFOjzio=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cacf197759so55827045ad.2
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 21:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787632734; x=1788237534; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WxKMrIReQlVr3GlN6gcG3Xq0u0n+Y7Tf1sth/0rO+pw=;
        b=dRP/5vvkGrcC09Phr63KJzYLylnOyqMSFh03evOAjJnov5Z7EicyUvYLvKg4rOt5C4
         rXPBJdUOKG2YGXti+EW+If7En1hD9FQT97y4jzKQzKeA+NrMAeME4V0A3cSrQVo4aV+y
         uGIrljGAPSZUOZ/wg/hu6foERVmk2SDNF+F7eEOzesMvJcYPHnwY5uP43O6iVjz4kOMq
         cDkaq885T5qeNJDgLhXVjnsSFC6j/KmILJ+NMzeaTQdOpI7SOvrOQ4kZIjukzcQc1MYX
         iWu6sfWjSaf8EzuPJQdwB7cZiM0B5Iind3zXj5PTYq//8zy9/vG7qQdb07luPOUJO24Y
         92kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787632734; x=1788237534;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WxKMrIReQlVr3GlN6gcG3Xq0u0n+Y7Tf1sth/0rO+pw=;
        b=TiupYg5yykE5agpy844xrTm+fmQYXv3rKQo/cHM/VlXS0+fpntS9Upgb3iyWuJ2Xf3
         HU9nZnCqFOxOLnk5/zv+ZeSnKbbd4k/KI9Avg7YzKC9FYck3uugpE0cgRnvVF8YApsaR
         5zvCZTtksDMSXncjVN2WULbo3Etv5PtWyVVKrnc9fu9rlO0cjqLYxFrnh94xoTQwvWO/
         l8x79GMiWhOgsZLBZL15ec3+Ke/3Zrrsh3JFNAtQLBQXDOSFOWQGbkutMH//lSmt6flC
         8vAZ+uRmTkWizfRlocHN40fqtOI8bRU5jnbF0TZiP+GBv6u+cEuhKJQlT11JFFLfaEh+
         WeJg==
X-Forwarded-Encrypted: i=1; AHgh+RoG5uUd+F0xVQNL1Vx7yzzlzFU3wKorXGFuywdH3iMzgTE5gQyDEEyfvQKaZdYxuXkXy+WEw+fxVQ==@kvack.org
X-Gm-Message-State: AFuF++mjB/H/UOAojdoEwqyey2Sq/LPzBjIOZJZ49/yIiFJViG4oPVsV
	wvZqITP58zcem2eCgx5Y7oUThUkIH6YytCvMACoHgc0UI6llze9bUF/8
X-Gm-Gg: AR+sD122RVY3xi6Vy/kOY1VcWsIPvmjU8S/Cly6I8Opu6PehKmq1WEeFw8JLkGPNGs3
	n7NUrJHvcZnOXgQJ9hDLrbUD/yvhlyrmrTR6O+SaXfsOYpsOo1szYqGj4L0WdcblWjffVFxE1O/
	3fJpjXpgmVV6FDd0hz5qRJw7UX5E92sitr9z3gFQIQ1u1TDpEc/Y8+daMHxvm0EIIjLEBBo14oH
	72tGMU8tz+jBajaqBKZ3ro8X/PzkMJq5HV4a54gvR3zUrDbT+D9HLqsMnHXFDGJmegdc8QHekb3
	QufyEiYa2VwUyx29ncS5WXTY6A/CoXY9yCCkkiZFR5OVHIisLZNnjikoAQb2AgXeY+/XqpwNK2G
	uNncHsjuK/CPn+wGG+0/G1aj6w7wSTUVdo4/Gsqdh65bv0ihYzHKSVZZYm6AMWlWkJ2Gf3Ur3jC
	uCecMmQf5l07i1LwEl0wCmcEjt+GKoMDudEjqd1abjG1XCZYjKYB7j76YadQDhhyooUthOCnfwv
	iSWmQ==
X-Received: by 2002:a17:902:ce8c:b0:2d6:2901:6265 with SMTP id d9443c01a7336-2d6dcaddacfmr74895275ad.2.1787632734483;
        Mon, 24 Aug 2026 21:38:54 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d6f726e222sm502155ad.19.2026.08.24.21.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 21:38:54 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	david@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhaonanzhe@xiaomi.com,
	lipengfei28@xiaomi.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Bo Zhang <zhangbo56@xiaomi.com>
Subject: [RFC PATCH 0/4] mm: compaction: mTHP-friendly memory compaction
Date: Tue, 25 Aug 2026 12:38:29 +0800
Message-Id: <20260825043833.2659350-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AF38D40002
X-Stat-Signature: ynqkkhuik1roa5i57699ng6nufosrezf
X-HE-Tag: 1787632735-448448
X-HE-Meta: U2FsdGVkX19OzcHdFbXZErcmVJHyqanu6N4rAdz79Kz9NVNTD3s78IGdFIYkukGt99wAv04bmNbgGlGNmSBntW5TW49iFPU+vq7w2YrSqJJ896SXpWQEu6guFtlmo9bM6nygjnrLs6Uf5zuJ25oF4nQR8eeBdFs5c61PmlTqD9Twr6IzLU/zUyzW61cZwIvZ0fg147KYh2Ozzw/WrAd84RwRj37IJDc5bcRwEHxR9QY1Kcp1nr2mcjsCwcoHW53y7dkOLTQJAtOC8USjv4sqTCwuTrG4E+uglJKEN5T1pOVRZMrm6HumP1X9p9UcEDgnH8hPiG6heCQuXUpu1LxLD79BNQYfcxiVULdSW3yv6ycsan1w+0IIxtjlYEr77L+Y8HkA5ZN+71G1NUdPHgbVj8Fp1P1iZuSILO2PWGsCcv+jSTfbGTy42Ru0fX0hLF1mt4NTiNPr/M9YhBWXV05RzujqLDT4Sh44YwJyVkkufTwsXhlb1Hqfy2SQ7OGOmALMkGLSNCYBNarpATJKBj76JaNs62pRjJvKoP3ql5I398cVNA5bNMrA7I1fPTjSFtMRYyQowmD2L2FhemjYKisGhrAY/mD3/uo/nH38aF/6+0zqnTke+tv83CvDW2OyACTEceJId2Wu5aDHAKMUJMrwh8YT9jDyuf6zTjCKNzq++V5IUQXrW8UzHzeSF2poOq+cVwg5hSlib89jozFAZI/Pq5th1oHeSCvFJbFLMMrqfJDmlcJ8pDhnT9A1BGv6dOO7JE8TH/374xbC5YO1zsOzqTUIYh9mcUtMSHEeXsNlYWZ08uLEEnJBfQbSPwPDS1jpAAthaJBYK7Jqt5jIJ1uhJ0geVKvp+Rcav70CGVqrUcRyUDgsBZJX9wGUJ2zzAdcw6pVf3xhEqo3DlxsAVsCL77ysOZplUZLzr1465AK+2mvESpHUm4DQNKs8u8OQmId0oInG7xa3qdegNLC2Udd
 Bn+StYZR
 XH72AowSL+Igb2hqgWhn43/cPgoZLhqqAVnYOA/vYwkG7a8xNIuiuScaTxNIugC9VpUX08pQBCFQy00+GhIJ74OvRCtiUdGNYRz15vMQta3yDQNIqsNNqlNMDWN0eyoZ+7DBg3YQfEsiIWw+W84N8QJTsulycYIkvP4FN++vLSG2FjuxVO/w4MnEvWapbd3t+90J+dvBG0wZ/YdVH5yCzNmXuc0zqZr4J7kt3JjAQ0phYklRzrfd9k7bx/vZCsiF8vyjJ7sjrZqXv7Tn69EixbZbpqG6ZIlJJeDuXYcJiLgkYiCypUbA+J4vduWSqrYMFCHG7mN542kkYpXcYhnlLel74Rhk9ptqhbQt3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This series improves memory compaction to better serve mTHP (multi-size
THP) allocations, particularly for small orders like order-2 (16KB).
The changes cover the proactive compaction and kswapd-triggered compaction
paths.

Problem:

The current proactive compaction targets COMPACTION_HPAGE_ORDER (order-9,
2MB), which is unfriendly to mTHP in two ways:

1. It migrates folios that already satisfy mTHP allocation needs. For
   example, an order-2 folio is a valid mTHP page, yet compaction still
   moves it around trying to form order-9 blocks. This is unnecessary
   work and wastes energy.

2. Compaction designed for 2MB huge pages is too heavyweight for mTHP.
   mTHP allocations are frequent and only require small contiguous blocks
   (e.g., 4 pages for order-2). A lighter-weight, mTHP-aware compaction
   strategy is needed to reduce overhead and power consumption.

Approach:

This series makes four changes:

1. Generalize the fragmentation score functions to accept an order parameter
   and use the minimum always-enabled mTHP order as the compaction target.

2. During proactive compaction (compact_memory), skip isolating folios that
   already satisfy mTHP requirements, avoiding unnecessary migration overhead.

3. Allow proactive compaction to proceed concurrently with kswapd for
   non-costly mTHP orders, since kswapd reclaim alone may not produce the
   contiguous blocks needed for these allocations.

4. Introduce zone_effective_free_pages() that provides mTHP-aware free page
   accounting for watermark checks, counting only buddy blocks that can
   actually satisfy mTHP allocations.

Test setup:

Boot Ubuntu with 2700 MB of memory, with mTHP disabled
initially and the defrag mode set to defer+madvise.

Then set the 16 KB mTHP size to always and run a kernel
build with -j20.

For both cases below, we run a background script to
proactively trigger compaction as follows:
 #!/bin/bash

 while true; do
 	echo 50 > /proc/sys/vm/compaction_proactiveness
 	sleep 0.1
 done

W/o patch:

*** Executing round 0 ***

real	2m1.312s
user	25m38.968s
sys	5m16.934s
anon_fault_alloc: 6328991
anon_fault_fallback: 214553

*** Executing round 1 ***

real	1m55.370s
user	25m24.482s
sys	3m52.512s
anon_fault_alloc: 6355263
anon_fault_fallback: 108692

*** Executing round 2 ***

real	2m7.579s
user	25m11.530s
sys	3m45.456s
anon_fault_alloc: 6355816
anon_fault_fallback: 107852

*** Executing round 3 ***

real	1m53.824s
user	25m26.774s
sys	3m42.160s
anon_fault_alloc: 6355457
anon_fault_fallback: 107705

W/patch:

*** Executing round 0 ***

real	1m55.906s
user	25m16.985s
sys	4m24.480s
anon_fault_alloc: 6354486
anon_fault_fallback: 109845

*** Executing round 1 ***

real	1m51.303s
user	25m16.456s
sys	3m26.629s
anon_fault_alloc: 6392515
anon_fault_fallback: 69797

*** Executing round 2 ***

real	1m51.495s
user	25m13.075s
sys	3m28.501s
anon_fault_alloc: 6395096
anon_fault_fallback: 67510

*** Executing round 3 ***

real	1m52.980s
user	25m8.217s
sys	3m37.506s
anon_fault_alloc: 6389556
anon_fault_fallback: 72743

Before "Executing round 0", mTHP is not enabled. Therefore, both
cases show a higher anon_fault_fallback in Round 0 than in the
other rounds. With the patch, however, memory can be compacted faster
into an mTHP-friendly state, resulting in a much lower fallback rate
in Round 0. In the other rounds, the patch also consistently shows
a lower anon_fault_fallback, as well as lower sys and wall time for
the kernel build.

Open questions:

1. When multiple mTHP orders are enabled (e.g., order-2 and order-4 both
   "always"), this series only targets the minimum order. Should proactive
   compaction also independently evaluate and serve higher orders?

2. In skip_isolation_on_order(), the filter order ideally should come from
   the compaction control path. However, during proactive compaction
   target_order is always -1 (via compact_memory), and there is no clean
   way to pass the mTHP order down from upper layers. Currently we read
   huge_anon_orders_always directly, but this variable can be changed by
   userspace at any time, making the semantic fragile (the compaction may
   start with one order target and finish with another). Ideas on how to
   plumb the target order through the proactive compaction path cleanly
   are welcome.

3. In __compact_finished(), the original code skips proactive compaction
   when kswapd is running to avoid interference. Patch 3 removes this
   skip for non-costly mTHP orders (< PAGE_ALLOC_COSTLY_ORDER). The
   reason is that small-order compaction is lightweight and likely to
   succeed quickly even while kswapd is reclaiming, forming an order-2
   block requires migrating very few pages. Does this approach make sense,
   or is there a better way to coordinate proactive compaction with kswapd
   in the mTHP scenario?

4. In the direct reclaim path (__alloc_pages_slowpath), compact_first is
   only set for costly orders or non-movable allocations. For mTHP always-
   enabled non-costly orders (e.g., order-2 MIGRATE_MOVABLE), when free
   memory is sufficient (watermarks met) but fragmentation is high,
   compaction is more appropriate than reclaim. Should we also set
   compact_first for this case to avoid unnecessary reclaim?

Bo Zhang (4):
  mm: compaction: make proactive compaction mTHP-aware
  mm: compaction: skip isolating large folios that satisfy the mTHP order
  mm: compaction: don't skip proactive compaction for non-costly mTHP
  mm: adjust free_pages to make __zone_watermark_ok() mTHP-aware

 mm/compaction.c | 83 ++++++++++++++++++++++++++++++++++++++-----------
 mm/internal.h   |  3 ++
 mm/vmscan.c     | 23 +++-----------
 3 files changed, 72 insertions(+), 37 deletions(-)

--
2.34.1


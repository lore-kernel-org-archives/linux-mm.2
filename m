Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 393FCCA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 02:07:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7639E6B0007; Wed,  3 Sep 2025 22:07:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 714AB8E000A; Wed,  3 Sep 2025 22:07:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 602808E0001; Wed,  3 Sep 2025 22:07:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 49F436B0007
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 22:07:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DBDBA1409B2
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 02:07:24 +0000 (UTC)
X-FDA: 83849930808.28.097933B
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2EBDD4000A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 02:07:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nZNNTpZQ;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756951643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=gR054lzuJbAO9UiIik0MBonxHsPRqVCYidSVWmTesKY=;
	b=rp5L64hPWZfZyq8cL4+PZnaSJnIDocMsv0XxrlejKzs318Nq8hS+JiRDp2lywUt4+lMjZi
	1La7YWilt1hyAOBTpytvy6QFiyIgL9CZBH0/JsbZrOFwjvl3me7fBh1grbQB7/WvK7bS0I
	0XP7PSQqLxUdljzZZ/WIzZSkFwpx2ew=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nZNNTpZQ;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756951643; a=rsa-sha256;
	cv=none;
	b=JK/aNFtpHEt08AfcXz9iR0egd4KhAFhFWaLx6ZT2lgR4+tdOExXiF2L7aKZQqkkH8G9Jjf
	Mro6hpnFVszLB965fJAdmeRI4eb6t6MiMxuFJFcAjUBx6mTlPi8VLBigHDLJQ+orEKXmYX
	TTad5kO5sFuc1qs3LDUz4XDg4HujACE=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-aff0365277aso263090466b.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 19:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756951641; x=1757556441; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gR054lzuJbAO9UiIik0MBonxHsPRqVCYidSVWmTesKY=;
        b=nZNNTpZQLDhYb4nxM+OCmYrA6gjoUgpSVd8t0x17EeuUik/obBo8mVEvoTdop2WmP6
         7TTH6e1KMkeW0WcbXACii6CbwRo41EVEUywhCHzVhOporWuypz8YcInluLCzokCb41yM
         o7lKVLsKVFrZfJ3OMD8RyAor54h0PiGp/20AhslxPaduta9xyIWouyDuvAFM9XZf+a9+
         1Fn8v4WZNhJcg4+i4Kjm5UQVqn6vgYmTtTFHITQQYJrcSmVxNv6MGeat1slqHqs9ehj9
         mqoMafBANSRO/U/VhO+3l2hguTgXi4+q5be87aK4LpOat8aTcgtgHOEC2ueBlyWWorkp
         jhhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756951641; x=1757556441;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gR054lzuJbAO9UiIik0MBonxHsPRqVCYidSVWmTesKY=;
        b=qaKY4nL2yqEtUPbnXyRdAEWmHoN0e7D6KG1VVBdq80ASrZ69fL+8Zaa3YIDW+FM9zG
         t/BbmyjlLUst1tmxRnllDDalVGrenuKl+V09yvSb1hP+kT6IiBGZDgCYoYg+mhc6WS1b
         G6oSS6/b30hNB9ToHdzi/Xxa/MhVAmPMKiJGAns5Lnu3N+3Ov7zsBVN8AoiOZNaY//V4
         E6WgqNt2G16IfS4xWNIkYGwqx0idytE1sHL/61/Ijr0uQxQu/8UHiKoCtpPvgdOV6Xt0
         1PIqqJuJk1iqO/X7WNIiAjC7mozC7ZWhqBFij3o7AHYmjOFm/RW3ZEZJHniRn0tAs9QC
         GzbA==
X-Gm-Message-State: AOJu0YwNn6kKMMkVj+rry72uusW7tMXAZ16e9m0j9qSh5vEU2PCGRnme
	CuzvXDKFWPBDTo1xwNlCwIiWqkzLQc/QVXqhc0Va59AimQf7xRzNRFVm
X-Gm-Gg: ASbGncuAkOcvl0cDXQCSoReTwQBjWRQjgcdilTy2vGSYOYeshg2h+PbkenUleB5Z2rM
	mtk+zy/50jHdYxLJaQXmTsCnoGM5bhXsQNv/MvQvm8WelbrACmWGgudAXqkykfSrMP9yJKnx8lu
	9XKfL/5j4ywhedHy6OOj3OMywWzcSHNHUGoF3koRW8kZjXf2n+rfPyN6QAFgOcRTA8AHxuG8vKp
	+bfxjjwWqBFVyNRibNhX53x5pRupAqjdQi9pc2yQ5rUYpXpHOS+zPZc+LMPKgsk2/e2oUhqa0I8
	ZQAnkTEgHAIzkEZu44w6ar8UsxbwhPZItPcgE38TEnmoH7r8OQ6gWDESLhOZRRy9NU104SrlTw9
	HqD0VVLfIVaczWxUNn6QAmQIgjJe3/Cs7fyQ6
X-Google-Smtp-Source: AGHT+IGSGmKLDBS3vvlxz8Ugf9XfqtM7Um+t1P35GAjcobTyWvIspOG9W4fxVKvysr3MyNQUjn/1LQ==
X-Received: by 2002:a17:906:c154:b0:b04:7612:76aa with SMTP id a640c23a62f3a-b047612783dmr270263766b.16.1756951641255;
        Wed, 03 Sep 2025 19:07:21 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b047373b000sm173962166b.68.2025.09.03.19.07.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Sep 2025 19:07:20 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH] mm/page_alloc: check the correct buddy if it is a starting block
Date: Thu,  4 Sep 2025 02:06:54 +0000
Message-Id: <20250904020654.28689-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Stat-Signature: 7t8qbt4rqede3kr7c98csc4d39xcetcb
X-Rspam-User: 
X-Rspamd-Queue-Id: 2EBDD4000A
X-Rspamd-Server: rspam05
X-HE-Tag: 1756951642-754667
X-HE-Meta: U2FsdGVkX19fKNMhZ0mg53YEqFQ1DO25Yd+I6qNYno/tNI0eTnaqwPglO+efAMgL6NpA9MhiCQYZVVQXVc1TKJH60C7aKp6W9hnzLLzsQszRGv9kH9AOk88RyhzRCu0KNgYnIQYh4fE4KpWgvOweV+YLn3N+J/8buGHzmOlaArcah9I2+W7dh6+Bk7tiN2y5o1T4qwS+U+xW0FJtVE3AICieNCEdrHreNLRiXL8LJyuCVCgd3aLVXwHI4x/Sc2wQ+HiPfupeDT8RGB/TWVyrGhjW3Rsbk1/VD6hXSMK0vKjfkisGpIXNgq2AB6Bsj72J2g2hqtY1qZ4RbzeBiL21tEL5DZRkhF9KHe4Wvf1zPAozqffspCfAoQbo/3olp7A+LsWXnDl8TBhz+TFVwxN9BZQejiCeLbxYZLiMIQepvANhKPI6UIge5Qb71ltcuVLwOZ9+8Dm9LXTclm34zIcK1gjDLHYAjwDh1rX4RLayT+wmtxcIJIG8WKa+AirTSFm1MZtVTmD9Q3pKCINBP7khWSMiz90Dx1vhqaqx6hzIm33ZXxoMCSWCEqZwfI3mViMPApk0XGZl9qMqX2kU7dkrwPJu5+RYb4ewyUtZxcTTIpogVHpv+iIwwIW6SbXZ8pFnRKsupcaKDlpkpS+1PtkArH9SiyS/tza4ZhpDTmZKc3dGRBFCT2ZSiBAnzMysrzSPzjyXoojrLT2thpd6uj2EfRjt/U0IPbjHnFa0qvJW4z5llVSjlsmMo+ud6UXLO1V9WFI+XbZvwT9fd/LUcenaaoqeBSsqWsgNtgIl6aNfhgpodZPi5a/4INl2AK0zdJnehu6Al3zNxOOSj7nKdCl1X6pKW7dtuDjfj8lXU8WS+bB25K4PYSmMLytxu9T9UiPtuP06bcFkEytPed9w3XvmqKDedXiLRh0mvQtBrLW2/FMC/DHLW2jiRgAp0oHagcqPT826EFr1H7gedoepcT7
 PFixU8lP
 p9wMq6gEgq8ORVksHv2W630g9v6INbeCkcrnmgEGG79CHIpBYpasVQqEh0wmKEHYv+khY66iV9a1y5qSf6EJtRjsEN1uqRNLbQoyTE73IHJRpZ0HWGLsJHWH7AYPWXQAj7Ze3AbK2hJ7sdzDUmMMzY6vPPRhVepAY2LfgyKhj/MVtkpAxPX5Tzeff71K+bJ9yDhQqjGDaQxl+og3nxkEgS3Ke8DOqIcPuy9fBU0HmITuu1/G6l5QOGCVRng+4bnrnHA8E76/YsCUDSWM+Wf3mLO2FTdZbC+sTm3CDHNHzkM1vrwRnT/fbYxO96qxbVdjAeUWZ60JJp5GfypWT2V6KoEiCP90roZ9a47cAfStJ3yY8Q2fQgrhDidpBWlduFxbBIBOqo5Q4Yvs8BFGfpCtJtcQka19Go9ZdUMAf8vdwSbmOvv2S+efLdI6fZjpO3PpMVetAm0rDQqnh6orsX6hqUxHP86sbsNpBlPSjlqgxDh8EeRTL4mNf6E3w7VROobiuPsI8Deg6FalLTH2lTN0wzuxONAmV50FxdJNmt7dZgWliaRLLln2u3HGlcpnDNPHm2E8IzNnKetLI6FRYSz8R+jWccN15cQRiN8gbWKCVdRjjkcPXMCPIkSw08qJyNb21NQF7gR/ozbXFjSa2x0IN0VUcGehAghflcS2G9qSo8nAUIaapzvZrewK17hmdI4QhUsBAe+SDHSXRkU2h0RxcwWJe/gIPqiWkNhXD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

find_large_buddy() search buddy based on start_pfn, which maybe
different from page's pfn, e.g. when page is not pageblock aligned,
because prep_move_freepages_block() always align start_pfn to pageblock.

This means when we found a starting block at start_pfn, it may check
on the wrong page theoretically.

The good news is the page passed to __move_freepages_block_isolate() has
only two possible cases:

  * page is pageblock aligned
  * page is __first_valid_page() of this block

So it is safe for the first case, and it won't get a buddy larger than
pageblock for the second case.

To eliminate the ambiguity, unify the handling for starting/tail block.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Vlastimil Babka <vbabka@suse.cz>

---
Tried memory online/offine, which looks good.
---
 mm/page_alloc.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5183a646fa09..453cd361386c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2093,6 +2093,7 @@ static bool __move_freepages_block_isolate(struct zone *zone,
 	unsigned long start_pfn, pfn;
 	int from_mt;
 	int to_mt;
+	struct page *buddy;
 
 	if (isolate == get_pageblock_isolate(page)) {
 		VM_WARN_ONCE(1, "%s a pageblock that is already in that state",
@@ -2107,10 +2108,10 @@ static bool __move_freepages_block_isolate(struct zone *zone,
 	if (pageblock_order == MAX_PAGE_ORDER)
 		goto move;
 
-	/* We're a tail block in a larger buddy */
 	pfn = find_large_buddy(start_pfn);
-	if (pfn != start_pfn) {
-		struct page *buddy = pfn_to_page(pfn);
+	buddy = pfn_to_page(pfn);
+	/* We're a part of a larger buddy */
+	if (PageBuddy(buddy) && buddy_order(buddy) > pageblock_order) {
 		int order = buddy_order(buddy);
 
 		del_page_from_free_list(buddy, zone, order,
@@ -2120,16 +2121,6 @@ static bool __move_freepages_block_isolate(struct zone *zone,
 		return true;
 	}
 
-	/* We're the starting block of a larger buddy */
-	if (PageBuddy(page) && buddy_order(page) > pageblock_order) {
-		int order = buddy_order(page);
-
-		del_page_from_free_list(page, zone, order,
-					get_pfnblock_migratetype(page, pfn));
-		toggle_pageblock_isolate(page, isolate);
-		split_large_buddy(zone, page, pfn, order, FPI_NONE);
-		return true;
-	}
 move:
 	/* Use MIGRATETYPE_MASK to get non-isolate migratetype */
 	if (isolate) {
-- 
2.34.1



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D198C531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 07:49:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C079F6B00AE; Thu, 23 Jul 2026 03:49:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDE756B00AB; Thu, 23 Jul 2026 03:49:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF4216B00B3; Thu, 23 Jul 2026 03:49:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 75CEA6B00AB
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:49:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B6DBD1403C2
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:48:59 +0000 (UTC)
X-FDA: 85019265198.10.26A6E8E
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf29.hostedemail.com (Postfix) with ESMTP id 18E2B120009
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:48:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cb599Woe;
	spf=pass (imf29.hostedemail.com: domain of 3aMdhagcKCNcCR7L53L9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jyescas.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3aMdhagcKCNcCR7L53L9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784792938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gusZRfFfKa7qtypbT3scclATimT0ZS8Q0+Rj2BZOw1s=;
	b=r2TtRWNp/9pYySBzY4yO1GHwvI2B/0/eUpo1QRBCr5Jf2lH+37b1Sc26F6LrCnw97WtpKR
	M6iYmaAo/l1LYh+sqdQcJfFu6ptlu/Dv4pI3ftAEEyUDao9I3bLqH0Zz8AugNL7UjJYIl0
	7hSYd3jVCLa7WqK/6ELyEDIuq5qRHok=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784792938;
	b=Q0Hzrl4ey0CCyhpJMUm7Z6WFIhna0RxCKdztopSSsSf/kbQJZfIrwKD8Pr4mOaOMZYSOdY
	mlwHIuUGlCr0FaqrkxPf8idnm4rk8GJbkpr71amXt3dggl7K1mQN+zyj7zfui+TFS4lGok
	VS7tAMFcaUYid3dpnqu3/YDkmYKfR4Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cb599Woe;
	spf=pass (imf29.hostedemail.com: domain of 3aMdhagcKCNcCR7L53L9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jyescas.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3aMdhagcKCNcCR7L53L9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e7ff7b375so589851a91.1
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784792937; x=1785397737; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gusZRfFfKa7qtypbT3scclATimT0ZS8Q0+Rj2BZOw1s=;
        b=cb599WoeU1mYPz1BItABlAjavAOo3qMOlTFzfh+kTiFyp8nhLvtNfSCBVUZPpCbidj
         pd/GicAlHJ2jczaGoZDGjsTRUv8Zr6nXGXb95+yEmRVgVH6BH7ZZzcnaOB1Lb9VAlsly
         WvHrkz41T6FmV8ljCVeDMJuxpKVpfCMNxAPoaKaxSDAtU1k29c/3QvhF5PN5txrAilIv
         QyYti2qtHSYugs9hYmEXgvVsXnzdpc7Q/JgDVJWzlIEcrpH7NuKfiWORwyir7VKjHA5C
         cdtqlzj6u3eYGYkfsLYh99CQguvQ2dHWw+FTiKb/dWTtx8z48OLr2XAr7/B/SAK+rco1
         0pLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784792937; x=1785397737;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gusZRfFfKa7qtypbT3scclATimT0ZS8Q0+Rj2BZOw1s=;
        b=iLnrlx5oNS9vXWUKo5ihfZsDd9c15Cpy/TgUcXwZCJo+Yc3DPDeOWc2hhDZ7HTOFL2
         q0lJondOrtDpSVrjWGsj+JHXdrgaP/uCShcjh4Li/Srs+w7PwRlKRnjyyi4DwBXAK1ik
         vfd3Lf8qJVPC6Od6mYOfNQLiAGkdF27SO2LNwyBIsGnT+2zWOkeczPWfORN8hL9kW2Qr
         svKVmuu4NgKz5dalprM6bvKJ4mAT3yckjqTgWnmDjNvH1z5+R6K4FbEIgcal6WtfmAZc
         4fB4K9xX5LTFDyxxAzIKVgNCd2WX4ZB626DDG+WAv5/gy2v68WmixPrZW7EzYaLMeFYf
         MXLA==
X-Forwarded-Encrypted: i=1; AHgh+Rof3yjI2X2RSvja5IpO91LsdFXT0LFFmknQyTByQAFRDxBAttcmYNv1dbII1ARKBBm5l849jgB84A==@kvack.org
X-Gm-Message-State: AOJu0YxTi2p0deaKMOt3/mJzvC7v/6nOmB/Kxg2slT5C74SUH4/bA+gQ
	FkwbR+rxHGTXIkYsOY817nrt6Su3BzmlwZb518eCFzAsLWrGBbuZG6f7jnY9iVo10/coNEbz6u4
	oFOq0oPr99w==
X-Received: from dlbsj2-n2.prod.google.com ([2002:a05:7022:f902:20b0:13d:210b:71ca])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d887:b0:387:e0db:bc2b
 with SMTP id 98e67ed59e1d1-38ec661c2bemr1938697a91.43.1784792936485; Thu, 23
 Jul 2026 00:48:56 -0700 (PDT)
Date: Thu, 23 Jul 2026 00:47:04 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260723074854.1013941-1-jyescas@google.com>
Subject: [RFC PATCH 00/16] Page Alloc Hogger
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 18E2B120009
X-Stat-Signature: puw46ds4fjuh88w6age8c4zx33fwwbhz
X-HE-Tag: 1784792937-408823
X-HE-Meta: U2FsdGVkX1/WBuQUF31tqQeYCZqtEnVmlFPK75rJXzKxSs0LzOW5/9RRCh/jRy2UCaaDwc6bTOtQj/NWbDXdhdIt2EZUkwbMkdKwE920nRUuNuLQsiUsjNUsHtbwv4WFbiPh/znMAHz/X7YlDGa6XQt29ZxnXA7VV/BD0W6obsvt9rRiNnixJpDuag6Hoavslut6qeH+Nfh/pNwq5bPBDCXogxwph1VivTACUj88dpcMMnSYbfSOAWEb9nKKojsGI8luQUKJSJRdM8zVIA7wVc/yag5KWDBEb/JruMSY2KrhBQ9jofxfkFBiZvtJNSiyEOGoxFhEqEH/6Gdxkcx9uwUn/tBoh9C8pgjmA3LsThsLUFVmfPI/ZdVdWbD5KSmqPs8AKALd5/wmI7KsTG5JAJU/w0q7tcPxjmAXylFcUTHFfpK635BUDkDW6cJO/Bt4SAlzxmuBoKV283CJFdn8uDOStamm/nUMlfIk5UtrjGYl8MDDcvxPGhKZEYMq1VfIf38uI6ZidgxkjsyaMV0aXcqSAI05cyWuqe5laZhlGltD4tjp+OnGz67PTHtHvNOmPAp842vWJCxwBouH81UKNolsM3nwlv0X2fdJXjRGikTjvWMgzOYT5KU9Xl6I6mP8lE8iTasxfvk6YVdPpXyUlk7V3qukODQ/jRmigt2rnpeyzK0c5sZPja/p0LMaoFXWdltnkd9tO+gtEnaBIpWSGFgqLF62n02Xk2h3h3bpUwdwpVOlQQE/GEfb7nEeIEw3iFWe27YiUjPaHPKEpzThR1MCOyf/B0TnqEJUQGSbVDUfkQOyzBZ/p/FGqrmEdbHe1qD1Qxc5CL9Nws3oOjOzVgyGFCPN8+SehWWg+kc3AJUmO2DyX8J3K/KVmf9m0u7QEExxf1wCodYQ9rkzAFTLZuM10xsVuxwxBnPcretZG01bwNl3JXunl30SuW5vcB/Vs7q5qg/pZXt4x4AtmTS
 fWA4NVV7
 A8M0cdv3fBAbnC1bmWg8NfBBxglfnLeBOB4Vz4EH0zmZqViH9W6L3K9nyP/zlcSsnVnAcZaFT2L9HW60j35fovNI/cjVKMnysjZ0J3JOEkccNpEVId84xnhnC+M531LP+/x2oCafv2b5RlEtMjhL4WBvnANhwgraB/4H7zdNXRYhrYz8a1p6F2hmhsJXFcSEh5J+Ydym00aryO/vj9k9ZczhuJLdISOtrjSLtNtA9fcImUDow5EP/FzouCcGmC+C5hjIetoE4hdQDuown5sieVIoo9iVhk+d1ZciJdBpTd18ljqEDYL5eggXwRkA0yvHVv/nOi4f3hskLphp6V6LD8HmhB7X/AwHe7URaUBg0HlBvEP+cK7WAo+YSBGr1tWaan24eyJv9cP/YMLDRpEIOgtRYPaN60z7FDHpMNWUOWG8uxT/gJfS4LCmYSnc+8qkJeuKzK5ZEEBsQ3W62Gn35nquhoQfK6WdV9YEtiLENk7hWRvLnC+3xz39VjoAMA2SYPlnjgeYnx7Ate7J4TAfCzFzJQudbUotdclvpVRTBEsW42oJFGs6+EXcaDehGu7yqpRO5/oxiWRHP+SLwbj1twcrGSgHpBsGLrUtsZpHn4rmgvgg9FjRUpxve1VZPjbQpZ4Ztnegw51Km4bo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series introduces the Page Alloc Hogger. The Page Alloc Hogger
allows you to allocate memory pages from specific nodes, zones, migration
types, and orders directly via debugfs. This provides key benefits for
testing and debugging:

- Reproduce low-memory conditions: Easily trigger and inspect kernel
mechanisms like direct reclaim, kswapd, the OOM killer, and allocation
fallbacks.

- Simplify memory pressure debugging: Debug issues that only manifest under
memory stress without needing custom kernel drivers or userspace programs
to allocate memory.

- Simplify unit testing: Verify that memory management subsystems
(direct reclaim, OOM killer, kswapd) trigger as expected in test suites.

- Measure performance under stress: Evaluate how applications behave and
perform during severe memory pressure.

Usage:

1. To trigger the allocation, navigate to the debugfs path corresponding
   to your target node, memory zone, allocation order, and migration type,
   then write the requested allocation count to nr_pages_allocs.

   For example, to make 3 allocs of order 9, Migrate Type Movable,
   Zone Normal and Node 0, run:

   $ echo 3 > /sys/kernel/debug/mm/node-0/zone-Normal/order-9/migrate-Movable/nr_pages_allocs

2. For each allocation created, a corresponding file named sequentially
   (1, 2, n) will appear in that directory.

   $ ls /sys/kernel/debug/mm/node-0/zone-Normal/order-9/migrate-Movable/
   1   2   3  nr_pages_allocs

3. To free the allocation, write the allocation file name in
   /sys/kernel/debug/mm/free. For example, to release the 2nd allocation run:

   $ echo 2 > /sys/kernel/debug/mm/free

Example:

$ cat /proc/pagetypeinfo
Page block order: 9
Pages per block:  512

Free pages count per migrate type at order 0  1  2  3  4  5  6  7  8  9   10
Node 0, zone    DMA, type   Unmovable      0  0  0  0  0  0  0  0  0  0    0
Node 0, zone    DMA, type     Movable      1  1  1  0  1  1  2  2  1  3  732
Node 0, zone    DMA, type Reclaimable      0  0  0  0  0  0  0  0  0  0    0
Node 0, zone    DMA, type  HighAtomic      0  0  0  0  0  0  0  0  0  0    0
Node 0, zone    DMA, type         CMA      0  0  0  0  0  0  0  0  0  1    7
Node 0, zone    DMA, type     Isolate      0  0  0  0  0  0  0  0  0  0    0
Node 0, zone Normal, type   Unmovable     13  7  0  1  0  0  1  0  1  0    0
Node 0, zone Normal, type     Movable      1  1  1  1  1  1  1  0  1  1 1221
Node 0, zone Normal, type Reclaimable      1  0  0  0  0  0  1  0  0  1    0
Node 0, zone Normal, type  HighAtomic      0  0  0  0  0  0  0  0  0  0    0
Node 0, zone Normal, type         CMA      0  0  0  0  0  0  0  0  0  1    7
Node 0, zone Normal, type     Isolate      0  0  0  0  0  0  0  0  0  0    0

Number of blocks type  Unmovable  Movable Reclaimable HighAtomic CMA Isolate
Node 0, zone      DMA          0     1520           0          0  16       0
Node 0, zone   Normal         12     2530           2          0  16       0

$ echo 1200 > /sys/kernel/debug/mm/node-0/zone-Normal/order-10/migrate-Movable/nr_pages_allocs

$ cat /proc/pagetypeinfo
Page block order: 9
Pages per block:  512

Free pages count per migrate type at order 0  1  2  3  4  5  6  7  8  9   10
Node 0, zone    DMA, type   Unmovable      0  0  0  0  0  0  0  0  0  0    0
Node 0, zone    DMA, type     Movable      1  1  1  0  1  1  2  2  1  3  732
Node 0, zone    DMA, type Reclaimable      0  0  0  0  0  0  0  0  0  0    0
Node 0, zone    DMA, type  HighAtomic      0  0  0  0  0  0  0  0  0  0    0
Node 0, zone    DMA, type         CMA      0  0  0  0  0  0  0  0  0  1    7
Node 0, zone    DMA, type     Isolate      0  0  0  0  0  0  0  0  0  0    0
Node 0, zone Normal, type   Unmovable     13  7  1  1  0  0  0  0  1  0    0
Node 0, zone Normal, type     Movable      1  1  1  1  1  1  1  0  1  1   21
Node 0, zone Normal, type Reclaimable      0  1  0  0  1  0  0  0  1  0    0
Node 0, zone Normal, type  HighAtomic      0  0  0  0  0  0  0  0  0  0    0
Node 0, zone Normal, type         CMA      0  0  0  0  0  0  0  0  0  1    7
Node 0, zone Normal, type     Isolate      0  0  0  0  0  0  0  0  0  0    0

Number of blocks type  Unmovable  Movable Reclaimable HighAtomic CMA Isolate
Node 0, zone      DMA          0     1520           0          0  16       0
Node 0, zone   Normal         12     2530           2          0  16       0

$ for i in `seq 1 1200`; do echo $i > /sys/kernel/debug/mm/free; done

$ cat /proc/pagetypeinfo
Page block order: 9
Pages per block:  512

Free pages count per migrate type at order 0  1  2  3  4  5  6  7  8  9   10
Node 0, zone    DMA, type   Unmovable      0  0  0  0  0  0  0  0  0  0    0
Node 0, zone    DMA, type     Movable      1  1  1  0  1  1  2  2  1  3  732
Node 0, zone    DMA, type Reclaimable      0  0  0  0  0  0  0  0  0  0    0
Node 0, zone    DMA, type  HighAtomic      0  0  0  0  0  0  0  0  0  0    0
Node 0, zone    DMA, type         CMA      0  0  0  0  0  0  0  0  0  1    7
Node 0, zone    DMA, type     Isolate      0  0  0  0  0  0  0  0  0  0    0
Node 0, zone Normal, type   Unmovable     13  7  1  1  0  0  0  0  1  0    0
Node 0, zone Normal, type     Movable      1  1  1  1  1  1  1  0  1  1 1221
Node 0, zone Normal, type Reclaimable      0  1  0  0  1  0  0  0  1  0    0
Node 0, zone Normal, type  HighAtomic      0  0  0  0  0  0  0  0  0  0    0
Node 0, zone Normal, type         CMA      0  0  0  0  0  0  0  0  0  1    7
Node 0, zone Normal, type     Isolate      0  0  0  0  0  0  0  0  0  0    0

Number of blocks type  Unmovable  Movable Reclaimable HighAtomic CMA Isolate
Node 0, zone      DMA          0     1520           0          0  16       0
Node 0, zone   Normal         12     2530           2          0  16       0

Notes:

- The only zone that is not supported is ZONE_DEVICE.
- MIGRATE_CMA will be supported soon

Juan Yescas (16):
  mm: Page Alloc Hogger module
  mm: Define structs for allocation requests and store allocations
  mm: Define the caches for the structs req_alloc and page_alloc
  mm: Define function to create a dir for each online node
  mm: Define function to create a dir for populated zone
  mm: Define function to create a dir for each page order
  mm: Define function to create a dir for each migrate type
  mm: Define function that creates the "nr_pages_allocs" file
  mm: Read the nr_pages_allocs value given by user
  mm: Set the selected zone in gfp_t flags
  mm: Sets the migrate type in gfp_t flags
  mm: Define the make_alloc() function
  mm: Create the file asociated with an allocation
  mm: Free pages, remove files and clean cache when one alloc fails
  mm: Create the "free" file to release the previously allocated pages
  mm: Release resources when the page alloc hogger module exits

 mm/Kconfig.debug       |  12 +
 mm/Makefile            |   1 +
 mm/page_alloc_hogger.c | 611 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 624 insertions(+)
 create mode 100644 mm/page_alloc_hogger.c

-- 
2.55.0.229.g6434b31f56-goog



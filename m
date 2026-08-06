Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97DADC55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 01:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C22BA6B0098; Wed,  5 Aug 2026 21:10:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BACEE6B0095; Wed,  5 Aug 2026 21:10:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A732E6B0096; Wed,  5 Aug 2026 21:10:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D4266B0088
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:10:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 264E7160565
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:10:53 +0000 (UTC)
X-FDA: 85069065186.27.8902CDF
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf18.hostedemail.com (Postfix) with ESMTP id 80EE11C0006
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:10:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=URqd28TU;
	spf=pass (imf18.hostedemail.com: domain of 3Gt9zagcKCAMm1hvfdvjrrjoh.frpolqx0-ppnydfn.ruj@flex--jyescas.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3Gt9zagcKCAMm1hvfdvjrrjoh.frpolqx0-ppnydfn.ruj@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785978651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=aS8xXOT3cwfqq2+uivefl5lw088kY5Aqo4LU/nVZhwc=;
	b=vfeng3sC6R0r+Fx0m9s0eR9q4OHLLsQ6eq4vL8VQJB7SDJN9tY+57yE3POu016C067YJ3n
	+x7N0IArgNqJqE45A0M2VRT1aRBTiraa6LRXfy/gqlb/E5DJDQq+3DIRZtkSwc1psLXhVD
	posg9sk1uOy1RPcGlDGATMW1fchxt24=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785978651;
	b=z0HunLVv6EIfxFnOjDFkA/X2wYTb0Y6WCcqM85j1/BXiImcurhHJ/OFoFSK3+XjBzKs6fY
	I/OX0Bc9NmmB1hSWgxZ4kMnJRfiTPV5NrrFx8PA9/cF04uL5ZRny9qlq80Az7GM637Ki4i
	+zGwB6e56yu5dfGUQHBkPAlK77jHulM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=URqd28TU;
	spf=pass (imf18.hostedemail.com: domain of 3Gt9zagcKCAMm1hvfdvjrrjoh.frpolqx0-ppnydfn.ruj@flex--jyescas.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3Gt9zagcKCAMm1hvfdvjrrjoh.frpolqx0-ppnydfn.ruj@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-caf5fa127d4so2671277a12.0
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 18:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785978650; x=1786583450; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aS8xXOT3cwfqq2+uivefl5lw088kY5Aqo4LU/nVZhwc=;
        b=URqd28TU/S3yPVQnhH9JRj4xpzZFYZebhgn+voRrAkhAij8h37lghpv4k1kLT8nts3
         GZBNcUvWUhIOjCYDSmEnx5cqg9FTZp3JXjcPBnQV4hQCKCCPQpxCG7Ip6BZ1tAcptn6g
         BO4kUvtoZibvCVRGVXt3tle0gxeGq2nfu1tbK6hB9gI3gztGV8jfkQFdnkMlTPZ+UAbS
         nA0pH0dJV/3D4F49v/hzOvrCrZmMbjqfVveRPE3CiF/uFWLKylTHuQMkYFmZ24QeKI60
         6YYUVVOJbdngXsXI2d4K8BCMefW3JRCqeLkYeDSbPKCMHQfJY8UXZitrEsnk3zBbH5Jj
         LeoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785978650; x=1786583450;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aS8xXOT3cwfqq2+uivefl5lw088kY5Aqo4LU/nVZhwc=;
        b=gzTNvf64Or0cEFOvet3sYH+VuII94v2QQ6rwQzNitKj+zlIkMwFPWxTGw91rkoqT1w
         WbR+kO2wjrsZOZHqFuWzHp2w+fLqmAtfMYlJPFFlodpiX9AkWF+Ri++VIxDbOtTUc+uS
         QukNK3JnZ8TFw+yEZ+HHaaZgjcUp2Ij9DT2ENlOUa/bZurIXCtz/knH7Bp8tdexr2j+z
         VoPYpnVMw3n2HuTtTCWNRyfb4cZ531eNzME/cYFU4zMCW8AEGGrm5hQvhifW8PMs5g2f
         bopzu2+v2FvBKWiFi96cBC/8kMoF9xD2aEMqVMC4LI5BrKwjB3szXx++IEoWVAAILiRn
         F+8w==
X-Forwarded-Encrypted: i=1; AHgh+RrV78b/VYIrOlf28D0Yo7F3CkWULmgXHv0vdmt1dGDuPsRKn+BIWFIKOV0RosLvpOF0x6Jygg4MNQ==@kvack.org
X-Gm-Message-State: AOJu0YyDGpg01BJgCk8DNwDa5L9oLQHuenypar6DLw4Lo2MtqRm0XU5X
	qdhGxal/0DHakEwYvv11TgJj85NsF1hPQkO3fNt77R8sQdnOUd6Q+DHEaIFK54Gl/k1KyNIQ9SN
	bNnXAqbErTg==
X-Received: from pgjx11.prod.google.com ([2002:a63:fe4b:0:b0:c9e:d5b:af1])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:7483:b0:3c3:b57b:6285
 with SMTP id adf61e73a8af0-3cb85dcc9b8mr13877577637.13.1785978650083; Wed, 05
 Aug 2026 18:10:50 -0700 (PDT)
Date: Wed,  5 Aug 2026 18:09:01 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.629.g250fe7f194-goog
Message-ID: <20260806011048.517229-1-jyescas@google.com>
Subject: [RFC PATCH v2 00/16] Page Alloc Hogger
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, ljs@kernel.org, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: rsdgjdej44fqxerxggxxx6opqegw1j9j
X-Rspamd-Queue-Id: 80EE11C0006
X-HE-Tag: 1785978651-419004
X-HE-Meta: U2FsdGVkX1/tk2Y7rcOcWU3uArh2V4fsNMXiijYNfaqRAhc/b+ZOV1bXfeBoqNN01LyUTvjFEbicNBbOt/VkBhAIQJQwmUXaH5pWXDG0TWcwFXqr3XEU+S4pBmUJ26877qzvhltknkaGUy2UUyplsj2/78F1uZ6Vye7sGayZ/gf9jfwdDSxqZbgay6vHL7w5YPhwTzL+9quJEi4Oyi/YTdREVGwDjw6QEBtNT42oqUrAqkzELIhbpt4OzuSVC/yOO+nT9mQe6nIRT99EqH7g0+jsx+xC26OF+qxYqBcUTJC2thPpGKoMth35x5kj3pBL/09rw85r5dm9ZBPnSldsnrpY9Z/sicPJF6BslZFtKZASxhZ1wc5/Qzao/+A1PhXPAq+NIaQKPyjT8y2Lb64PZ4hC4cmxduGEuAhRSQJIsKHgnCcnt4wd31ejE1JaYbHRiJsmDpwo5hMvIsD+2sAQzrJmxcylHlK7Y5/cIYFjCu+mgny9taeMMSvixzn5cZagqcAahrHB4VFfazPYJRqo1fcvUa2WaqkUhqjYQwwIllgBuCtjyGxiAgJlkfVVekqrSsGmB4viqsmwnFn8ldMCO9qQpWFrRBExXs5F1HVq2U6SwtDGrFDA1pB6/gdnEaPcBJP7zWifrTSX7vhG+KZ9IrRGukkwLJY66r81kXWfVw07pPrvdW2CUY0+M0qFqPdBNKp4iayfCzCYoVZ0uHlCk+oUZ9WN6YE6+HxaQmQvPzOg/Q49Hxg6TojdOuA5GvxwVkFJkSLk7mfc5gQxpJ9ytmZtbLny7HMPUFkM1DROk0jFePrBLuS9+UOhEdI/znH6/+dW0XYjd382i8u3mFXXbz/hg6gPPOjFqwwC5GSn7JmmSn9T+6BcUX63r2gKR8snLaziiV9rVV6PSjYIU4BkgH4bdBfmyvH1PZWEyxvgXs7u6hikz/xQOcVUGddutkJY7Ah+mdQ17q4YZNioOYn
 CoJawuhq
 1j77fcUvpzm7KJCrBUyUn7cLYCN9LpoXsM4e5M3bvoZtAO/hMseufeOOyEqeRIdcVS7/RLIyZOyzBCmv2KjQk4mcYlDcm5XogvB8TA6JL1SuyDN3Me6jY8yd7RCaxruWC4U0Pa8V1FOj4L8kvA4Q78e9xDib4vZFSjFY7aFv8FoaSBNWjt3LsgK5gs0fwbVwUYOTmw3TP7sCxl5pKt//h78ee2opEO4vrBH73D4HyHGeVbLeZq6aMUiXCpEzbdN04XihbCGo6Rpvmmf6VXlQeTEz0AD2rBTnQ3wOrtoPxco91zUXtmKNLh2eeTZFZlpqoZCH46iFgYQ09TzMUVXPdKzuiZ5CFyZ522b87K/M0rYFx+9s5Q8FaWq3qJJQQ0TCfQrbVazbTRcmukvRri3+LU7Y/5TugYpMmlmy5/P2IMunoDv9es+IPA/kM9CfcIgzYmqeU4Oel4ezgehIslPFfulVYhHaqdtYRQADyauLYCXNIldY60h8JiCz9v66zAEfRuImG8nHCmohgMCGaI56YGrXBxTjEUw43k1CYnlD7JbruuAgonEddLvjagx02yk86nqVoIOZ2sGKmn3rS5IFxrfLNYlcqTvd9pDIu7QFfJqNNOT1CgiVgBv58fbjwKU7xAHWObXPkjk0/Z5c=
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
  mm: Create the file associated with an allocation
  mm: Free pages, remove files and clean cache when one alloc fails
  mm: Create the "free" file to release the previously allocated pages
  mm: Release resources when the page alloc hogger module exits

 mm/Kconfig.debug       |  12 +
 mm/Makefile            |   1 +
 mm/page_alloc_hogger.c | 610 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 623 insertions(+)
 create mode 100644 mm/page_alloc_hogger.c

-- 
2.55.0.629.g250fe7f194-goog



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0B30CA5FCE
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 05:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4209B6B008A; Sun,  4 Oct 2026 01:37:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D1516B008C; Sun,  4 Oct 2026 01:37:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E73A6B0092; Sun,  4 Oct 2026 01:37:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0BEE76B008A
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 01:37:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1421EC0AC8
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 05:37:33 +0000 (UTC)
X-FDA: 85283836386.16.A3D40AB
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0E6A280005
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 05:37:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="XR JBkCM";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf30.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791092250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YZFnl3jt8OwnMFOMa73Yjd8m80iOizAeS0hopGZI1tM=;
	b=qmAacTmKz7icQk4Ani44HyuB6euUwFG76ZP5jEECvIEjN36oWV/f/jkbqdayay/fIrO4W5
	YLnD7LN/1U7oPD4u/pdhOZl5ZiaAP5m0y+1MB7W0RlHBL/17UmdAnXm/gd9a77yVrIiTAL
	d4FjYSmcvV0bdJQXZbsa7YW05Z8HWwg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="XR JBkCM";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf30.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791092250;
	b=TzxQiKtEnLRcDHDdjV0wBMiZT63tYFcdYyRNRB5oSqq83KWXtmLgYXx+C/nZBoZa6wXgVY
	97pMB5DVsAcZNlNIBuinKFPmaWZxNt7UvdhExZZIq+xnuDpjUHXYZyQf1H0yVrDH1d5Ztu
	d9L08Hbec0ZCQ6xL8or37uJ7F/f74Dg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References; bh=YZFnl3jt8OwnMFOMa73Yjd8m80iOizAeS0hopGZI1tM=; b=XR
	JBkCMdz5khA5JPh3KcwxRHjTwKX/1jgsWTJPm88IzzrNTy5WSmmUYQRG2OmPrkzNTIM2bttAIxEyI
	0YcyqpOSc9yORQ9I//RpaVdY+kpG0zGlXtvjtTSUqqpRQtrt//Oqpn8T5d3pEzzEAIofPFuObkiJo
	3AgTPStLt7tN5D3uhRGtXt+9cAR5LHV0jN2z4H6+brZcWoRteLjsKGWGBLOG1vyfYXxNThlBPrl7N
	BxKNb7c97aUED4RWUAxd4JPBIkp6GuWH4YJ4XomqD37vGXF6Jc1tCZxpr+tFVglAMRzAk2cGIzadU
	picTkq00a6OrYhHBPLvDogqbESM+MWVw==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xDEu9-00000005drD-1tGZ;
	Sun, 04 Oct 2026 05:36:57 +0000
Date: Sun, 4 Oct 2026 01:36:57 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, Qi Zheng
 <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Johannes
 Weiner <hannes@cmpxchg.org>, Brendan Jackman <brendan.jackman@linux.dev>,
 Zi Yan <ziy@nvidia.com>
Subject: [RFC PROTOTYPE] mm: reliable 1GB page allocation
Message-ID: <20261004013657.03a63c4c@fangorn>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0E6A280005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: dwt5j8cu5ji3bdqaijmx7uonbby7a63a
X-HE-Tag: 1791092249-918633
X-HE-Meta: U2FsdGVkX1/wjEu4dm8+3TpJ5A+o4MQkzkkO7T/HAx4ioMkySXWa5lH6+3EoItqBhyaQyXDR7SzxZX1I6n/QWPa75u1gQdOYiQfIps10Rg8xYwMaGNjEgi7JtjJHkwtcwNWmShekn7ckh9haiMJg26aXPpUDe1Z82z5MQbe9ct28nGap17XCFzzDpoA5t8OqO7OvCaSe5hj8y0VO24jz4tHGaWcfkzNv+PaZjr0xudeSw/MxPhrqDwF/82zQRCPcsv3HfZJelGMTjZ91GJnVqe9nTs+a3mN044SrqpLJpGKlgvoFsSO57Ht+uWlzGj8hH9gJ3BPCwHebJCQ9onAg3zjFlBPGaC7fGKE1h36Prc+9d+2+MGDRtb2err5C42zwfFuYJCRysbi7+0EFrhyFMnGZnt7ZHTlGuiSLmBTEPbn8H0P0/OIxsE/dE8HQ+j+oMVItzJhJr/LbbZPhyH/caGUMYBvy65Y8K7Yln3BPIRn/6sb0XU3uXaeqWL+B+LjAjLr97aG1cuSI0pIqLiUvdPi+5waJD1bVGxcBcJZHI4cV4oomIZWHY4Ng22OpSdiS2XWo68ibtVKdKxnftfU22xDdMp9JmB5/6QoRN92SCLyAqokuOVn0gk8LyLmDmrXV09vLBW004KvUiF2RMVIISITDuUvHYES8TxB4nmez+M6txyERa547lhz4dbWmHlHS2yIyCmVRN3gw4h2K6e0NuHjwzhA63wPZ9UtbjpAM+coV50RH9IgvhSs8W+aBDJ7C+gkGdTi6FG+Roc53RqRYMK9F7Eljw0wKa/qhWmlH0sKepcrhRP2V58CnZX30r9wDRkxv+glwvjmZt+fyABm+gdTdRmAXhAau8vjcwjHyf+d0G2+JJYgMw5Co1Mzqaq/zTiZx9JB9rIlTJtJVSPOiJJU41WYM0CKSWMzpDCF6uGQz/LxFqkqoMyF/JMhav5G1utuaWWlNYPXPcMNvihd
 XPcflLFJ
 RnfjKh4ldvMTQunMf9gUvgDMkwvCajZYMWv0kwtHD1JZlMHvp/4xjfzr+4zcFIOJEHxG90jxAatLQwqkSF5EHHFmceqMMFhSkofTd5RwHQQyurHZC8pN02nKUOV9zB01sIqlcdvY5UNgfrMjSbOyHJ3WZCZ78rWwQQ7Qj50fB8hrfUE2N7h22jvpAXX/YaRHSdAzjpKtnLSPEOCak0mI5cngk8uJTwV03IM0I6cUZQrgfO2nyLdrvqLp1lEb2kdgv4vfUbsHAXIf7RMUXbPYVBHg9LbvdmdGjPCflCqfY05IREcmONBaZPJAd32pwAtWW/H6ys02A+pzF8XqkhVhUsXvied4tLTu6/B2OorMn6PTToFA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The goal of this series is to keep gigantic (1GB) pages allocatable
after weeks of uptime, by concentrating non-movable pageblocks in a
small number of 1GiB-aligned ranges.

Design document: https://linux-mm.org/GigaBlocks

Code: https://github.com/rikvanriel/linux/tree/riel/gigablock-2026-10-03

A 1GB page needs a 1GB-aligned range in which every page is free or
movable; one unmovable page disqualifies the range.  Over time a small
amount of kernel memory spreads across nearly every range.  On a 765GB
node after 53 days of build and filesystem work, none of 754 1GB ranges was
free of non-movable pageblocks.  On a 253GB test host the same class of
workload mixed 251 of 254 ranges in 9.2 hours, and a request for eight
1GB pages returned none.

This series uses the separate free lists for each migrate type
in zone->free_area[] in the fast path. The idea is to satisfy kernel
allocations from the unmovable and reclaimable free lists, while
movable allocations come from the movable free lists.

For each gigablock, the system tracks whether it contains non-movable
content, or only free and movable page blocks. A gigablock can contain
a mix of non-movable and movable data.

When the kernel free lists run low, the slow path moves pages and page
blocks from inside mixed gigablocks onto the kernel free lists.

Creating kernel free memory inside mixed superblocks is done
by claiming page blocks in a mixed superblock, when the kernel
free lists are exhausted, and a non-movable allocation has to
fall back, or by compaction evacuating movable content from
previously claimed kernel pageblocks that have movable content inside.

Claiming a new pageblock in a mixed superblock is done from the
allocator path, using a bounded scan, only once the kernel free
list is unable to satisfy an allocation.  Evacuation is done by
kcompactd, and kicked off when the kernel free list falls below
a watermark.  The goal is for the asynchronous path keep the
page allocator on the fast path.

Movable allocations can fall back to the kernel free lists.
That content can always be moved later.

Region size is fixed at 1GB rather than PUD size, geometry is frozen
at boot, and a hotplug span change disables tracking for the zone rather
than resizing metadata.

The diffstat shows that this version adds too much code to page_alloc.c,
which is already too large, and should probably be split up somehow.

One candidate in this series is to split the evacuation code and gigablock
slow path into its own file, moving that out of both page_alloc.c and
compaction.c. 

Duplicating a small amount of compaction logic may be preferable to 
complicating the existing logic at this point.

This code is not ready to be merged yet. The full design document has
a list of things that still need to be done.

I am posting this in the hopes of getting feedback on the basic design,
so that can be incorporated in the next rounds of tuning and cleanups.

Specifically feedback on design concepts like:
- Using only zone->free_area by migrate type in the fast path
- Moving pages around in the slow path, to keep the kernel free
  lists stocked.
- Some amount of scanning in the page allocation code if the
  kernel free lists cannot satisfy an allocation, in order
  to claim a block in a mixed gigablock.
- Using compaction to evacuate movable content from pageblocks
  claimed for kernel use.
- The policy of restricting how much kernel allocations can
  claim new pageblocks anywhere.
- The policy of letting movable allocations fall back to the
  kernel free lists once the movable free list is exhausted

 Documentation/admin-guide/kernel-parameters.txt |    8 
 include/linux/mmzone.h                          |   83 
 include/linux/pageblock-flags.h                 |    2 
 include/linux/sched.h                           |    4 
 include/linux/vm_event_item.h                   |   48 
 mm/compaction.c                                 |  170 
 mm/folio.c                                      |    5 
 mm/internal.h                                   |  147 
 mm/memory_hotplug.c                             |    3 
 mm/mm_init.c                                    |  150 
 mm/page_alloc.c                                 | 5553 +++++++++++++++++-------
 mm/page_alloc.h                                 |    6 
 mm/vmstat.c                                     |  273 +
 13 files changed, 5015 insertions(+), 1437 deletions(-)




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D5AECA9EBD
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 21:54:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B8106B0088; Sun, 11 Oct 2026 17:54:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 069946B008A; Sun, 11 Oct 2026 17:54:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC1C56B008C; Sun, 11 Oct 2026 17:54:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B52286B0088
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 17:54:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1E0621607D6
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 21:54:34 +0000 (UTC)
X-FDA: 85311700068.16.340528D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5B83820005
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 21:54:32 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Nrd5Q4bI;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791755672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CjXAODnEAHZt/ze1fUVx1lc4eAYVC7QnfQvq3wkUGQQ=;
	b=IUWsS1HyjM3w5tPQsZn0u7ELfOluBHEBy4TI5My+A22aUcsnHX4RkvrZjr2hLAY+8N6a2d
	PNcjPyWd9xuaoV7xG94IoKQSy0n6dtfBjxhssdF8Q+gognNutnuoXKkFSi8ERJ6++AiAdM
	F9v6ghOnIsmwZ4ZIlnMgUg8nysdIXNI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791755672;
	b=YEQGn4Y1HW/JjoIPgTbcelIFFCOBLKcDrU0iw1AAMxQ+/Uqzp/Vsp5Gj561DhYIH7fYl6T
	fXhkaZT6W5yGRm0GKHKaHaMTJx2srofVfdhN85JrsjiYPhp0Vg0MCTVXWEjdXV5Zg9MOIg
	Y4rYQuAb3EERjgU/laTPRZdqGIe+pks=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Nrd5Q4bI;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E6D371684;
	Sun, 11 Oct 2026 14:54:27 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4CDA93F673;
	Sun, 11 Oct 2026 14:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791755671; bh=CjXAODnEAHZt/ze1fUVx1lc4eAYVC7QnfQvq3wkUGQQ=;
	h=From:To:Cc:Subject:Date:From;
	b=Nrd5Q4bIex4K5sPIo2WaDht5vD3RyakVYy9IJYIO9FKsHf5pHCQgeNYIqobBzV6qt
	 eiK0xJa6NEGswHMWKnHVim461hZYvugiI0n8yMnzJV4YvFeWj0FkHUR0UGwXliHz2n
	 dnLbuGmq6SencPcF4fPUfw63RNMz5p820DS9VWZM=
From: Dev Jain <dev.jain@arm.com>
To: linux-mm@kvack.org
Cc: Dev Jain <dev.jain@arm.com>,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	riel@surriel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	brendan.jackman@linux.dev,
	ziy@nvidia.com
Subject: [RFC NO CODE] [DISCUSSION] Anti-fragmenting ordered buddy allocator
Date: Sun, 11 Oct 2026 21:54:11 +0000
Message-ID: <20261011215412.1181172-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5B83820005
X-Stat-Signature: d8cxxh1xx83sugwztzcqngir5sjmsuxj
X-HE-Tag: 1791755672-689480
X-HE-Meta: U2FsdGVkX18Rr145FM9TA5+radAWay5rrz+4PljRpa7CpgtUXdd2kj0MrClFn0GYYLC+l9JW7QTg4fNVD/TgVZzO7xXuW6fw7f1nKpFh8QTyx2lANMELlLGlIQFz67XL3p7Ktrb6cKN4rRRuVqLDVHzCGIh3OUU6ATmnAZoFbJVT2C0qMiHhnebdmbPjtBczrKbMyBigP8zM0wAaB0ZCLcM2ARgt3PvkPZTMAwxcSt9Lb6LPqEUG8xSvUEI4RFeVGY2EzlMWmqvjvFQM4ItbFAA+DkXPG7/2YAERsVtQNE3pad2czK2LEL9EAiMlx4YYjmTvA1giCvjYH+Zba5jTHHigxdwHXowIEPH5p1ibzsHtExVlI6tCd+DsNfanXCgsL51sPMEBWJIh4WvAvQZpd6t9YuTi8HaS4o3g/Gizpl3y8Ft+3AOo5+Y79dQoU8ql/kTVaYG3/C8BgkhvNOZpbBR99Z+W1FkKr7jqNPugNTlsC2BUYzbsL+79a3bXffT3Vxb3zYqmGpPN0za1Xt63lkFOgS8OuKjs97UOirtT7ir2RO7BfyYGghoqwkpx3ohMl3u8aaqG3+6kXZ11Vcb5sP+Hb8x9bLULUbiJlChBY8Jp0/iqxdiMxI1JcUN7RSZhCjgfetN4dTxVF7VHH5CmVr6za7mefgWPbCuKvn6Jgyu/0rQAVowiaQMeO1Xa3+g7oRbeRmtpOrfgD+TeaBawaYLK7yRE6y2DdbmwxEcbmTl+PUhPslnY3MkFDs3zt0VK2kqaQjLy4iUiGL0FPGPrnRZBkRn4TVjVxd+46dyzfVU0f9d2wmWonv/oxIm56HSZQD9hAob3ktuV20D/hzl4w87thA6kCzd2cb3BzjAX6HLhr4KYK7bAN3cENnuDtqzTLzE9PbZmRFVz9eOYjHoJcfALNy4zhT7Lu6lufk1f27dnxq0xFpvaHa5s5iuAwPijNuFI6WP+Mlo9zULvWPV
 OnVvgCDV
 L+jqaqr8vu+uCrNMkhfl/2Ipq3uxCcluuzs0a75NshDGzycOz4WIoAuevo0AN6LoFHazwjSoIXvNDOI6z6GljCmgCgUify2SI/FVRtVqsBazZfGqlJOllA8PqyPcFnY3styrJ/BSFG4Hu9rGIk4clDGV/0dRxvCvEUkiS2HHPw5d1KT8gl25p8Uyz0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(I am not posting code yet since it is in experimental stage.)

TL;DR
-------

I am proposing "ordered/bucketed buddy allocator": we divide the buddy
freelists into buckets, and prefer lower buckets for allocation.
This reduces external fragmentation (and, further reduces it when we
reverse the ordering for unmovable and reclaimable allocations) at the
cost of regressing the alloc and free paths, which depends on how many
buckets you partition into. I think we can partition into 4 buckets and
do some tricks to remove any regression.

Design 1 is the simplest and the most upstream-friendly method in terms of
allocator speed. Design 2 tries to scale better with the number of buckets.

INTRODUCTION
-------------

Apart from dividing the freelists between migratetypes, little attempt
has been made to change the algorithm of the buddy itself to reduce
external fragmentation proactively (termed as "anti-fragmentation" in
academia). Linux has defragmentation (compaction). The analysis below
is *not* to claim that compaction does a bad job; I just took up the
challenge of anti-fragmentation (because I like to torture myself) and
kept digging the rabbit hole.

There have been academic papers about replacing the buddy with bitmaps -
I did not want a hard NAK from upstream at any attempt to do that, so
I preserved the buddy freelists.

IDEA
----

There is a correlation between allocating from one side of memory, and
reducing external fragmentation. Biasing on one side implies the
probability we fragment already fragmented sections is high. This may also
enable smarter compaction by directing the free-page scanner toward
higher-address regions. This also circumvents the discussion around
a "fragmentation score" which is dependent on the size of the
block we are considering.

The idea itself quite obviously improves clustering of allocations: I
observe reductions in 'compact_stall' and 'anon_fault_fallback', and some
large improvements when the number of buckets is high (like, compact_stall
going down from 4000 to 5 with almost no hit in execution time for a kernel
compilation). The obvious downside being slowing down the allocator (which
needs to be tested more widely). The content below is mainly on how
to minimize that.

PROBLEM
-------

The number of buckets is inversely proportional to allocator performance.
The critical section under the zone->lock is extremely fast.

The overheads are the following:

1) Alloc: What is the first free bucket which has the required order? We
don't want to naively scan across the buckets.

Then, the more surprising one, which becomes more visible as the number
of buckets increase:

2) Free: When we do pfn->bucket lookup (which needs to happen in a
cache-effective manner) and free into that bucket, if this is not the
"active" bucket we were allocating from, then we are going to miss the
cache. The inactive bucket list_head is cold, and the page at its head
is also cold. We are going to perform some cold operations to insert it
into its (bucket, order) freelist.

At least on my system, increasing the size of struct zone did not
contribute to overhead (for free areas <= 64). I may not have
increased it enough.

DESIGN COMMONALITY
------------------

All designs aim to prefer low addresses for movable allocations,
and high addresses for reclaimable/unmovable allocations. The
"SOLUTION COMMONALITY" is: keep things tight in cache. We pay cycles
when the bucket we were allocing from starts becoming empty, and we need
to find the next bucket. The crux is to amortize that cost somehow.

DESIGN 1
--------
We divide the zone into 4 buckets of equal length. Then, allocation first
chooses the migratetype, iterates the available buckets from left to
right for movable allocations, and right to left for unmovable/reclaimable.
When freeing, we do a pfn->bucket index lookup, and free into that
(migratetype, bucket, order) freelist.
Note that we change the indexing to the above: currently the index is
(order, migratetype), making order list heads for the same migratetype
distant. This is problematic if we want to scan order lists for the
same buddy unit.

We may be needlessly scanning the lists when the bucket is empty. So,
we can make a bucket "active" and allocate from the active bucket, till
we cannot. Then we iterate from the start and make a bucket active.

This algorithm does not scale well with the number of buckets, but is
the simplest.

DESIGN 2
--------

The aim now is to increase the number of buckets. Suppose the active bucket
is F, wherein active means, this is the bucket we will keep allocing from
until we cannot.

ALLOC TIME: We request an order-x block, search the order freelists on this
bucket, and can't find anything. Now, we need to find the first bucket
with an order-y freelist nonempty, y >= x.

We can use a "bucket-local" bitmap: for the active bucket, maintain a
local bitmap, kept on the cacheline of the order-0 list_head. On every
pop and free from the active bucket, we will update this bitmap to
indicate whether order-x list is nonempty.

Once this bucket becomes nonactive, publish this local bitmap into the
zone-scoped bitmap, and use that bitmap to quickly find the first
bucket which has a block >= order-x.

FREE TIME: if we are freeing a PFN belonging to a non-active bucket ...
we DO NOT need to free to its bucket yet! Free this into a lockless linked
list kept in the zone->lock cacheline (just like trylock_free_pages).
The crux is that we do not need to make these blocks visible to the
buddy yet either for allocation or buddy coalescing, since allocation
from those buckets is not going to happen until the active bucket
is in use.

Once the active bucket can no longer satisfy the request, we drain this
list (or, when a threshold is crossed, to prevent unbounded
work under spinlock).

So we have amortized cache misses across non-active frees.

The problem starts when this bucket jumping becomes very frequent. It
is a sign we are under memory pressure. We should then call into the
slowpath and free enough pages. But, we really shouldn't be using
huge number of buckets under memory pressure, since there is no point
of "anti fragmentation" now. The bucketed allocator helps us to delay
compaction and reclaim. So we need a way to switch.


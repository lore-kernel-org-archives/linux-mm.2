Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9502DCD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 13:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A4296B0096; Thu, 18 Jun 2026 09:13:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77C106B0098; Thu, 18 Jun 2026 09:13:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 691BE6B0099; Thu, 18 Jun 2026 09:13:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA8A26B0098
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:13:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 51A66C2FB7
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:05:06 +0000 (UTC)
X-FDA: 84893053812.06.7A1290A
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5A1AB1C0002
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:05:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UfxNKBW3;
	spf=pass (imf18.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781787904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ytAGNigD/ebY7+HSKocFsr/g5SytHMyBypUqyWldD60=;
	b=5DO5kLvAjous/T+YunnXLmq1BZqXmQPps4niO8ALjCMTMjr1No9N+yN4MLAYUKsi2wlRFX
	193u7JK/z7P7hMGtE1UNKEVXMlahGOtPqcTIahBleF9aZ/Zc16xgaUb4ED/Xbvnar4W8cU
	PZc9kBsmX2I4JVTEjFy6MBZqZ7Od888=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UfxNKBW3;
	spf=pass (imf18.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781787904;
	b=6LqIWlsIJrDLRnDuI28mZM2IzBQW9YYZuIJni0PBbYi3olYu5IgvyPGyWSP3ecsnGNKluV
	Dr1M7EdFpxXeY2q3nsPFcNKKiAnftONWMz652eqe7WZ/8pNllMwyFwtLfWpb7xx7rf4A5Q
	JCwUFXz4h5L8qlzyO2ejT9BN53wNbng=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781787902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ytAGNigD/ebY7+HSKocFsr/g5SytHMyBypUqyWldD60=;
	b=UfxNKBW3ZvxX3Y4efXgP6bPqMGFKxo+wZInMYG/TecmTDa4ppyPrUmIf4d/EB/QkflZCuJ
	74ENLMnxupJ6dyduJQ8J2OHCkGE9L1v++zezLLrhJcjNivth0SGuLVXmrvuNk/Cm7n9zW5
	v8jOCcyYEgCKnwB9fEbMdho1rsgXUl4=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <kaitao.cheng@linux.dev>
Subject: [PATCH v4 0/4] mm/percpu: Fix possible NOFS/NOIO reclaim recursion
Date: Thu, 18 Jun 2026 21:04:10 +0800
Message-ID: <20260618130414.96383-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5A1AB1C0002
X-Stat-Signature: o88fuzefggaed7o97i6q6najq6nst3kc
X-Rspam-User: 
X-HE-Tag: 1781787904-644074
X-HE-Meta: U2FsdGVkX19QWfMiFm3GLqat93oavxkXIk5QOv+HA0kuU/pnUaWXOqtb/ZgLpgYG5jg8+VuVBRZ12vE6FevOB5ogRSw6Ivx0jjioS+/CIBZ44iI54ts0r1srTEll/nNDs/J3VKlS5CID2HW9H/cCOi96zqdnvZuEQnUSkb357esIdjppJiVEiv9MruLoWG2tQr6Yq7oaFPoyPpnV0HBMS79rwEvN+xpCXXBGkdhVcU+uPbFfpyINq669UcqaYPBi6sLdO85AI1MrGfUwaS5HOBoup05jngg7HLkC+YlYD0oLrdTpzJRb0BrlLCVZ9Zma4ZQQ27N3Y5O5q66M0V7Oux/9seF/+s3lLJco5f2C8jTGhLojrJCz6ntVx37O0YpnYcoa0xHMck49xYtpfIcddETfNAIvznfEGtXU+RhjAFvqoH4KFa4uH3rQ7/8JNcux+oMYcZvncAZp8nrNtrS/Ps0uPnloXL1KIFdxmMskBwDx9sZJHGQcEhnxtd/XGnoLWIHRWaullxJNabFO0KXSIA1887GC/Fe4cWHI+QDuS8nr8lwg2l9TuCa/Qp/FI1a7vnpm5VvlaLJ9b07WP0uYxqeALKTqQagHTqaj++bh3u4N82257wmHbs4C6uvnJAdZnhqoLWqs+24ZcqGi3XAHJOl5k27s11W9/InEwNcOnpBwGBaBmELpMb5mv5VIzAZl43rATerYhNh1Od84QrN0/RL5432Nzdb/tL0JPOG6KmnVgs842Bvd0G5/LVFd7vDDyXXL7QdjW1AqLGp10ERZ+bK9FY5WetiDUAmYoNEhhp6D/RJpocUsytRT9Gfzmd1jiyep2aSXBeU4g1J9ejdBJDusLdxQi/UGOAMV9Zz8BGCeCzAIV784KDo8jfThpxV7KJZ9vmlt50Y7jvq5o0ioSUytN2GuTl3OY4bdmuI0DvV1d3tXp8MjNazAkUcNfSLbKnzea+5lzvQCwCl8PM1
 vwCvT6d4
 9omticvgFUPhxYmzBvNICCJRxofw1Jr042t2tbofyzrIz0ckLO75jJN6p0WaH0yW5ZF31AoO3MeqTbk9SoYtvdzWpaX8qarln/9DFlDtzDyHqE3fFKwI/H4HYUrLQ8CXhamPgIX1p1YVagQWAz+S68V2MJ5NXwDol8jH6BdIpaGzJDQoTt/hGyEoF/0mHJPx7AOUbuMfD0+HIfoJ89jmVkJes3t7jUQ6uqsjk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations
atomic") allowed GFP_NOFS and GFP_NOIO percpu allocations to use
pcpu_alloc_mutex and the chunk creation slow path. This restored the
allocation capability that was lost when those constrained allocations
were treated as atomic, but it also makes the percpu slow path visible
to callers from constrained reclaim contexts.

There are two related problems.

First, the create and populate slow paths do not fully preserve the
caller's allocation constraints. pcpu_alloc_noprof() derives pcpu_gfp from
the caller supplied GFP mask and passes it down to the percpu backing page
allocator. However, chunk creation calls pcpu_get_vm_areas(), and chunk
population can allocate temporary metadata or vmalloc page tables while
mapping backing pages. Those internal allocations can still use GFP_KERNEL,
so a caller using GFP_NOFS or GFP_NOIO can enter unconstrained FS or IO
reclaim while holding pcpu_alloc_mutex.

One possible case is blk-cgroup after commit 5d726c4dbeed
("blk-cgroup: fix possible deadlock while configuring policy").
blkg_conf_prep() now serializes against blkcg_deactivate_policy() with
q->blkcg_mutex, and blkg_alloc() uses GFP_NOIO because queue freeze and IO
reclaim dependencies can otherwise deadlock. If the percpu slow path loses
that GFP_NOIO context, direct reclaim or writeback can issue IO to a frozen
queue while q->blkcg_mutex is held.

Second, allowing sleepable GFP_NOFS/GFP_NOIO allocations to take
pcpu_alloc_mutex means that unconstrained backing allocations made under
the mutex can create an FS/IO reclaim dependency against a constrained
caller which already holds an FS or IO lock and then waits for
pcpu_alloc_mutex.

This series fixes those issues in three steps:

  - pass the caller supplied GFP mask into pcpu_get_vm_areas() and use it
    for vmalloc metadata and KASAN shadow allocations;
  - pass the GFP mask through the chunk population path, including the
    temporary pages array and vmalloc page table allocation scope;
  - restrict percpu backing allocations performed while holding
    pcpu_alloc_mutex to GFP_NOIO, so they cannot recurse into IO or FS
    reclaim.

This keeps sleepable GFP_NOFS/GFP_NOIO percpu allocations working, while
avoiding the reclaim recursion risks introduced by making those allocations
eligible for the mutex-protected slow path.

Changes in v4:
- Make cached pages lookup explicit; (Dennis Zhou)
- Remove the changes in v3 and add a comment explaining why __GFP_NOFAIL
  must not be passed. (Dennis Zhou, Michal Hocko, Andrew Morton)

Changes in v3:
- Allow @gfp to pass __GFP_NOFAIL through.

Changes in v2:
- split the previous first patch into vmalloc-area creation and chunk
  population changes; (Pedro Falcato)
- pass the GFP mask explicitly to pcpu_get_vm_areas(); (Pedro Falcato)
- apply the corresponding memalloc scope around vmalloc page table
  allocation during chunk population;
- replace the reclaim recursion avoidance with a GFP_NOIO backing
  allocation mask instead of only rejecting nested reclaim. (Michal Hocko)

Link to v3:
https://lore.kernel.org/all/20260612022648.13008-1-kaitao.cheng@linux.dev/

Link to v2:
https://lore.kernel.org/all/20260604113101.89510-1-kaitao.cheng@linux.dev/

Link to v1:
https://lore.kernel.org/all/20260528132917.81123-1-kaitao.cheng@linux.dev/

Kaitao Cheng (4):
  mm/vmalloc: honor GFP constraints in pcpu_get_vm_areas()
  mm/percpu: honor GFP constraints when populating chunks
  mm/percpu: Make cached pages lookup explicit
  mm/percpu: Avoid IO/FS reclaim in backing allocations

 include/linux/vmalloc.h |  4 ++--
 mm/percpu-vm.c          | 48 +++++++++++++++++++++++++++++------------
 mm/percpu.c             | 20 +++++++++++------
 mm/vmalloc.c            | 23 ++++++++++----------
 4 files changed, 62 insertions(+), 33 deletions(-)

-- 
2.50.1 (Apple Git-155)



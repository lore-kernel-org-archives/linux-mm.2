Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38714C44506
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 11:09:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C04C6B0088; Thu,  9 Jul 2026 07:09:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 171556B008A; Thu,  9 Jul 2026 07:09:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 060F76B008C; Thu,  9 Jul 2026 07:09:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D3BF86B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:09:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5B7F7120121
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:09:44 +0000 (UTC)
X-FDA: 84968967888.04.04E7C59
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf04.hostedemail.com (Postfix) with ESMTP id 24BFB40007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:09:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TP9Uebt3;
	spf=pass (imf04.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783595380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uImjXXPcL41dSiGErhCZMVoNRrVWs+eZDG6csqO3Dn8=;
	b=6oiHA4h4YF8pAUgX416BtAhUqGlaOCVR/5YqN0v8ux0lT61DiaOLEwO+TxTckUD3zZ0RRZ
	gBFaUtYA9TckI/yW/BJE0fv4lu1hAasi6LJy9AtNdq29eQQGXmT53PCT5iMZA9TYDiA+QE
	TaKG9roSFcEPLoN/K9Cf2kRRBl/HPpI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TP9Uebt3;
	spf=pass (imf04.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783595380;
	b=bGhwUwZJAhZQKie3ZtAHSSus4coEFKGRp4gv2JU5tlvxkpeQDERBiTHdnGeioXKOoSbMY8
	d7A6YLsacksK2gB6LMdWkynffJg3CXrzVVRoTBfhdNUhYf4FBGlplYfpx1n5gkBycxFFFZ
	rPbSCNPrajJGsjw+Jpmhx3ffYwS7jQc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783595374; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=uImjXXPcL41dSiGErhCZMVoNRrVWs+eZDG6csqO3Dn8=;
	b=TP9Uebt3Z88qJmSBwc6JgXQZVr7WT1fYJ7/kCCPrFajLpZtlV/0sLGDzGzNaxTeTcIH8Amsixq4gBrdhJWL6WUltFsGe3WjlGaFzJXcgvX+BTM6qW9DR1eUPrInhCblQ7tRUK4HQVXY5xLU98KtG+0N+VesC1NKqQ1e0YqMQlm8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X6kkhgH_1783595370;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X6kkhgH_1783595370 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 09 Jul 2026 19:09:31 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  linux-fsdevel@vger.kernel.org,  kernel-team@meta.com,
  willy@infradead.org,  jack@suse.cz,  akpm@linux-foundation.org,
  david@kernel.org,  ziy@nvidia.com,  matthew.brost@intel.com,
  joshua.hahnjy@gmail.com,  rakie.kim@sk.com,  byungchul@sk.com,
  apopple@nvidia.com,  Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 0/2] mm: don't apply task mempolicy to unmovable kernel
 allocations
In-Reply-To: <20260701222112.2820098-1-gourry@gourry.net> (Gregory Price's
	message of "Wed, 1 Jul 2026 18:21:10 -0400")
References: <20260701222112.2820098-1-gourry@gourry.net>
Date: Thu, 09 Jul 2026 19:09:29 +0800
Message-ID: <87echco1w6.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 24BFB40007
X-Stat-Signature: 8t974y9t3nuhkauqgfbejgrydjiz4e4c
X-HE-Tag: 1783595378-900884
X-HE-Meta: U2FsdGVkX1+qj1HgjCE9faBIUVqvddEa9G2kDL1G8QeZzo7OWES3z/J1g78jNnNZUYhP3+0McX5v33YF+aqwVrQuR0RhyKa50BAZcOlL5xoMPRky9uE+anAp70BDYNP62IqHlBOd462AviAlakSl8CG0iMqgt5jABLnDgONx3naNpiPitpQ61DovC7jt7DIcGQAeH8ITAm+Bgi/TnW/hieUWP7T/R4+/dPpnGl84ssdteuwhmDiA8sOwWoMi9SKj7t1mFBXWNHZeI+gQbUg48EMHPEjZ6r+QOApMex0G2FMr7CT8ssk+yfJ4fT14Oeu18OL6bkq+9dabe5gcgy1BumN0VjDmiXiZtM4QDNY9/pQgvP48mCLBskl6H497+LNUI+GmDkrz/5YCWk0TLTLmOPzQoVDcwYyphkQ15rfiM7Gv1cp/Z0i1tqnWk/sPl9wqiO5YsU8ADxcB1Rp516+wgxo7ezywvd3gnsPDR1JR6BcRYnMXC38tEYXIDTULCNEAxBc9JlkQAJjJ293CBFTL1D08qNp0n8jxN6ISowp8YKNjVfWn3Yhl3iMztlLxVwDHpyfa9YmDrqE77Bv9P3X8XOie709lW6vR4PadWPDaUP3IWsaIL1cjofRzzllqRXsZziheA0jhdm0VVgLKufzkyBQ0r4jErMyF7QGGdpbX1zFxvBAimG1yJZBqZs6p9VlyjMzAh9bsZO0nX7irp/B95vQwXmVX8YHtTdjt9vFnWQbK1vpAOktTAgZiF1zp4O2Z7L8QspeKbUTEgEFhKqdMeWkuXz1T/DR+UK+R+r2DHkm7meW8bcgusZZabS2r3yn/Xs7zFIW3kVmD6h9O/bThayi8z+jy3HKG4mmJ7/8cJLpowITsc0lad1nk9OY+IudMT5RqHZlDACPYChaptV8McqJbKct7Ifx2hR+6YeNXz6tD8X9nGreLw4VKpmdrVwEVX68ckSVh8zqRvMWHYOr
 TaY+/W9T
 seZbEEPZHA7dUrcQlS/tg0VAAmKgFVsmAgOIHkvd0fFjhQG/s+zKETqkeuvHEP19elZ57kOL6SKhk2t7gYOo1t7NsE9Q5VM3Sz/GsI2C8mqESXK/5W9PK+jlGgSA1d2aXWYEBJlqdDCFrTxYUb4LsytbqpebtzlMNGcii1yvCzxJjVSXCA/1iNB4i4MTxxYQljJam6aLk6cli5z3MC0OMnqLcIz/K4J5EQXot4LgYWUwzkpnPY0WjAWjSseTMt0k49jmrsVwBDSiG/oduJ+9rcjvbfyZT29unmplpvjg6dO3YDd7tMwsIb6Z2RNz5gjIeSZxSPusRJdpBmVkE65gACqcVUu98D22klQL+x4ZpC1ygTdr03AHGPaVm977LFAIbbp22yklnJErOnF3RnZ3IVxIB98J6mLr7EUOkrWwsY7J7oN88rLbdheGPAeuAovePDpB217V0PRWVJL4zwtKJELhC8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gregory Price <gourry@gourry.net> writes:

> This series stops a task's NUMA mempolicy from steering incidental,
> global kernel allocations that have no real relationship to the task.
>
> VMA-less allocations (alloc_pages(), folio_alloc(), vmalloc(), slab
> refils) - fall back to the current task's mempolicy as their only
> placement hint.
>
> This sweeps in kernel memory that is not the task's:
>   - unaccounted slab
>   - kernel page tables
>   - driver GFP_KERNEL buffers
>   - one-off global structures
>   - etc
>
> On a uniform multi-socket system this is not implicitly harmful.
> On a tiered-memory system a task's interleave/bind can push these
> incidental allocations onto slower tiers and cause regressions.
>
> The memory may outlive the task, or be shared by others, yet a single
> task's policy dictated where it landed.  
>
> The fix is to only follow the task policy for allocations that are
> plausibly the task's:
>
>   - movable allocations (mostly user data), and
>   - allocations explicitly tied to the task via __GFP_ACCOUNT.
>
> Everything else (unmovable and unaccounted) prefers node-local.
>
> Cpuset still enforces any hard confinements (ALLOC_CPUSET), and
> fallback allocations may still cause spillage, but this at least
> prevents interleave policies from making poor placements.
>
> Patch 1 makes page-cache placement explicit in filemap to retain
> existing behavior (pagecache and metadata still end up following
> the task mempolicy).  Since the metadata can be significant on
> some systems, retaining this behavior will ensure there are no
> surprises for existing users.
>
> If we want to change this behavior, this patch is droppable.
>
> Patch 2 adds the alloc_task_policy() filter for bare allocations.
>
> Test 1: Page cache follows the task policy (unchanged)
> ======
> A process running on node0 but bound to node1:
>    (numactl --cpunodebind=0 --membind=1) writes a 1.2G file.
>
>   membind=1 (non-local):  FilePages  node0 +0MB     node1 +1200MB
>   membind=0 (control):    FilePages  node0 +1200MB  node1 +0MB 
>
>
> Test 2: Incidental kernel allocations no longer follow it (changed)
> ======
> Added a debugfs interface to do movable and kernel allocations:
>
>  w/ --cpunodebind=0
>  numactl ... --membind=1      echo 100000 > .../alloc_kernel
>  numactl ... --membind=1      echo 100000 > .../alloc_movable
>  numactl ... --interleave=all echo 100000 > .../alloc_kernel
>
>                        GFP_KERNEL          GFP_HIGHUSER_MOVABLE
> membind=1    base:     node1 (follows)     node1
>              patched:  node0 (local)       node1 (follows)
>
> interleave   base:     50/50 (follows)     50/50
>              patched:  node0 (local)       50/50 (follows)
>
> Movable (user) allocations are unaffected in every case.
>
> The unmovable unaccounted kernel allocations stop following the
> task policy and place node-local. With no policy set, both place
> node-local as before.

Personally, I think this should be the right thing to do theoretically.
However, you may need to find some practical issues that this resolves.

> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
>
> Gregory Price (2):
>   mm/filemap: place page-cache folios via an explicit mempolicy
>   mm/mempolicy: skip task mempolicy for unmovable unaccounted kernel
>     allocations
>
>  mm/filemap.c   |  5 ++++-
>  mm/mempolicy.c | 40 ++++++++++++++++++++++++++++------------
>  2 files changed, 32 insertions(+), 13 deletions(-)

---
Best Regards,
Huang, Ying


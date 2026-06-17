Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7FF8CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 07:03:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B11466B0005; Wed, 17 Jun 2026 03:03:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE6CA6B0088; Wed, 17 Jun 2026 03:03:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A24F86B008A; Wed, 17 Jun 2026 03:03:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 790A06B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 03:03:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 005FC1C1A97
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:03:21 +0000 (UTC)
X-FDA: 84888513402.16.F120A5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4C57A4000B
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:03:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ek6qZyIl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of dennis@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dennis@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781679800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FA2Y02eZezagRsG3EdVgIrWy+bRirlt7CeSWEzPBaVM=;
	b=FowZhwuD2BNvagqee5G9GVHEZMUo5XEJlwVFfV+33lA4s7zvajRRe3RcDGlovxU90BSRti
	TQinyfB1aSV+qIq5ETZsnDeXiAUtPpJQQInaSMDJWyf1dGFE3UvUKDAUWjnAJnwLTwTEDX
	AdtDQUMXZTYxS/SYIi6y5P+pm9CWRT4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ek6qZyIl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of dennis@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dennis@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781679800;
	b=oWAwfBTiPJTawESW1DBHpGbC6YU3YPiA6R0pzKtz8kcjvdM4pUBUSsPsxNYgijCzW3kEYT
	suPdJz933RjUU29B4lkp9WOIH7toENsvCMULSQaw42bJQWRJsHbtIHhtgFXMcAPrNpq3AZ
	fX7G/YLtjbIEIe0VuHENa7jKw+QBArM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F44C417EC;
	Wed, 17 Jun 2026 07:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AD31F000E9;
	Wed, 17 Jun 2026 07:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781679799;
	bh=FA2Y02eZezagRsG3EdVgIrWy+bRirlt7CeSWEzPBaVM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ek6qZyIlMX059nAqQp7ILoHOYNVLln8kdnR0ej7fSY8YGO6JdSb9TYTEmaezv9ZbU
	 /cmvc14wGOblMQZEj4ehaH5CVigL0tUh9Lgkt8DOiyy0rbYFsbEoLjAYBFHjrIDFcp
	 ki5+SnK0GnCFdirEhPYzjgf8ymQwyWCi5in8/n1bGOnVWqMz5rlMhsfuR78GWcbimt
	 eJj35PXdbjvX3JEb347otpUmi908r7xOP+Ocmu5XcHo5N3sH3hqfYd6TIYFcEAW1XR
	 +L++LXZN4j01mK4W3F7Zw6gimKV75Z8Z/ZpUX+afwGnLPWgp5C0uIf1PO2NSWgSu5i
	 R4UZi6FSQwhnw==
Date: Wed, 17 Jun 2026 00:03:17 -0700
From: Dennis Zhou <dennis@kernel.org>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
	muchun.song@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, chengkaitao <chengkaitao@kylinos.cn>
Subject: Re: [PATCH v3 0/3] mm/percpu: Fix possible NOFS/NOIO reclaim
 recursion
Message-ID: <ajJGtVDi0rShPfE1@palisades.local>
References: <20260612022648.13008-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612022648.13008-1-kaitao.cheng@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4C57A4000B
X-Stat-Signature: pg45ataszcdb41sofwgx7xu3wrkeqk3o
X-HE-Tag: 1781679800-826731
X-HE-Meta: U2FsdGVkX19Da1m6VvxPhdlXZn/gbNuxjoujPNhnxchg8N/uQdvPAzs0T7a9H1h9EeeIuMZT3oZMGGpNSHOagJpTYq96Tc+xan7scD9B/+423ZDuybQxJmw2JQne7I8552faWhWPZxRwq+AJ2SMj3NAn2eF+gosO++8u6UyzbmKQhHGg2WfCjAmnPYif/TTozJvqIFvVZyFG+A74qQB9bM5WNZO8bWosa9mgq5PBtbHGreL+wwcNQEa/ntyEIyHsKOY/EZiw91ziu/6OIijVea+e1cRvJH8Ihgj6q5UHf3IFHgE1doVqf2SVIOa4RvFqM2L0PcX0cnFof7dYAJWpjM3AWA1E8f9XjH+MbdPBuXjh1YScf8u9k/nu0eBf2mUfYSWE9NrqiDyW30X4t39VNPJJJDgTzgLo45AFm5LwIv4DTZhmFPxFQkckEtXRf3Ealq/qGVOsjluq4S60KyPw8zp5opIAxuCcJqWwdnzRX1kDBzN56se6vyqdFPyo+6OJg68xp23dAc7s0d6QM64aPZl/n8vdmLl/xsWORSngFVQIX+XlrFCwZyCYT9vAt0T6LN8Crp65jnKYUl32cRoXBEb1pjKA7ReMP4pFXjytYpEAzgl8gZNC/Jr03zjjNATYKTXgfmsRaVOl1dVZB5xyGezk8tHaZTsbUAbwSBRvUbe0vMMNamZ1qd7egYRdB2jV8pahHYcuLtaIO2VRkkS7bt/8ZkJwk3r6xtCa1o+lfa49ZgzFdvF+StvnFYJ6a71c2Y9T0v3Wh8gK64OTzvskfjUAXuyQlwG5GYUyO1837kQXljpJxntoZYNlWE9hL4yKwcuMwTOFz9QqzgE6TpaVfi+axKyabcPXsCtDjiP4CTC0dWbDzfTRFiKCtikTFDI7WPXdTqE0lVzY7Or3zffwN/gGxC060+H1APIPW+RMoeJ58+yo511a3Dx/61AvxaE9o4pzkmRNuBgp+eqpUfM
 0IJG+0Rs
 tkp5ecEOyW43ajC/i2IMtmv2jKbSyzOICfXUafmsQP4fsdGHro/PgTF1FwxlAn69oUrbBjNyfRGztsaoZn7SwImO9PYA6GMOrUapYx/u/MwCTHFpVQiSZLADgRxCC8zNakkAKcRwR4A1jSf6iXMQ9yfezqhfiCpqbGqV2URgv7utw1r5TP9NMioHNLSi8jposV9ja/WiWqeWxS5P+wrLT3uU4xB2aMbQMqi/gN4v4p8FJiKA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Fri, Jun 12, 2026 at 10:26:45AM +0800, Kaitao Cheng wrote:
> From: chengkaitao <chengkaitao@kylinos.cn>
> 
> Hi all,
> 
> After v1 was posted, there were many different opinions, mainly around
> optimizing pcpu_alloc_mutex. This v3 is intended to describe the existing
> problems more clearly and provide a conventional fix approach.
> 
> Commit 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations
> atomic") allowed GFP_NOFS and GFP_NOIO percpu allocations to use
> pcpu_alloc_mutex and the chunk creation slow path. This restored the
> allocation capability that was lost when those constrained allocations
> were treated as atomic, but it also makes the percpu slow path visible
> to callers from constrained reclaim contexts.
> 
> There are two related problems.
> 
> First, the create and populate slow paths do not fully preserve the
> caller's allocation constraints. pcpu_alloc_noprof() derives pcpu_gfp from
> the caller supplied GFP mask and passes it down to the percpu backing page
> allocator. However, chunk creation calls pcpu_get_vm_areas(), and chunk
> population can allocate temporary metadata or vmalloc page tables while
> mapping backing pages. Those internal allocations can still use GFP_KERNEL,
> so a caller using GFP_NOFS or GFP_NOIO can enter unconstrained FS or IO
> reclaim while holding pcpu_alloc_mutex.
> 
> One possible case is blk-cgroup after commit 5d726c4dbeed
> ("blk-cgroup: fix possible deadlock while configuring policy").
> blkg_conf_prep() now serializes against blkcg_deactivate_policy() with
> q->blkcg_mutex, and blkg_alloc() uses GFP_NOIO because queue freeze and IO
> reclaim dependencies can otherwise deadlock. If the percpu slow path loses
> that GFP_NOIO context, direct reclaim or writeback can issue IO to a frozen
> queue while q->blkcg_mutex is held.
> 
> Second, allowing sleepable GFP_NOFS/GFP_NOIO allocations to take
> pcpu_alloc_mutex means that unconstrained backing allocations made under
> the mutex can create an FS/IO reclaim dependency against a constrained
> caller which already holds an FS or IO lock and then waits for
> pcpu_alloc_mutex.
> 
> This series fixes those issues in three steps:
> 
>   - pass the caller supplied GFP mask into pcpu_get_vm_areas() and use it
>     for vmalloc metadata and KASAN shadow allocations;
>   - pass the GFP mask through the chunk population path, including the
>     temporary pages array and vmalloc page table allocation scope;
>   - restrict percpu backing allocations performed while holding
>     pcpu_alloc_mutex to GFP_NOIO, so they cannot recurse into IO or FS
>     reclaim.
> 
> This keeps sleepable GFP_NOFS/GFP_NOIO percpu allocations working, while
> avoiding the reclaim recursion risks introduced by making those allocations
> eligible for the mutex-protected slow path.
> 
> Changes in v3:
> Allow @gfp to pass __GFP_NOFAIL through. (Andrew Morton)
> 
> Changes in v2:
>   - split the previous first patch into vmalloc-area creation and chunk
>     population changes; (Pedro Falcato)
>   - pass the GFP mask explicitly to pcpu_get_vm_areas(); (Pedro Falcato)
>   - apply the corresponding memalloc scope around vmalloc page table
>     allocation during chunk population;
>   - replace the reclaim recursion avoidance with a GFP_NOIO backing
>     allocation mask instead of only rejecting nested reclaim.
>     (Michal Hocko)
> 
> Link to v2:
> https://lore.kernel.org/all/20260604113101.89510-1-kaitao.cheng@linux.dev/
> 
> Link to v1:
> https://lore.kernel.org/all/20260528132917.81123-1-kaitao.cheng@linux.dev/
> 
> Kaitao Cheng (3):
>   mm/vmalloc: honor GFP constraints in pcpu_get_vm_areas()
>   mm/percpu: honor GFP constraints when populating chunks
>   mm/percpu: Avoid IO/FS reclaim in backing allocations
> 
>  include/linux/vmalloc.h |  4 ++--
>  mm/percpu-vm.c          | 40 +++++++++++++++++++++++++++-------------
>  mm/percpu.c             | 18 ++++++++++++------
>  mm/vmalloc.c            | 23 ++++++++++++-----------
>  4 files changed, 53 insertions(+), 32 deletions(-)
> 
> -- 
> 2.43.0
> 

Thanks for taking on this work. I definitely missed this earlier.

I acked patches 1 and 2. I think 3 is good but the __GFP_NOFAIL warrants
more discussion. I think my take back then was a single percpu
allocation can trigger a large # of backing pages. As a result, while
the caller may not be asking for a lot of memory, we may need
substantially more to back that allocation. Given the discrepancy,
that's why __GFP_NOFAIL is just mutex_lock() vs mutex_lock_killable().

Thanks,
Dennis


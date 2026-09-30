Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23BA1CA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 11:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31A846B00A4; Wed, 30 Sep 2026 07:26:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CB486B00A5; Wed, 30 Sep 2026 07:26:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E21D6B00A6; Wed, 30 Sep 2026 07:26:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EAE936B00A4
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:26:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6A2FE120779
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:26:27 +0000 (UTC)
X-FDA: 85270200414.18.28E1401
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8EF8D80007
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:26:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lzBmmt1Q;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790767585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TQupl8eDsCF6/sGS+B8O0v2tQta8e38EjGU/FlwQXsQ=;
	b=YcRSN62ET06DUWlwiRavvu5ZtjMP0+y6dB3OESqW2t7o9k2D5QH7D9d93di/KkA1QmX1Gc
	hd+UIiec+xujjF+3ZzbYZfT1OH9SEgTr3V98LjfRaSsYqBCGNDvkRjbczP2Esg6JpVi35d
	8IU/6J0uNDl6CbWtxx+5F5Fc7A92Sfk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lzBmmt1Q;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790767585;
	b=ShOuJeEe+4nInZRTpVUkCOLOpDUOl0grqkXMCy1+CwRETH7ikx21aWs6gvJn+8MsgtdSxa
	3Vt5Lo+jJRWOr7fsi9YGmPs86MPgWAmsJE2rxSXowyEV9tAbnINCBQYyHVK8NSNb7v2wQ3
	su7wFxCazWWy+/U2GH5UlauENJ2xcx8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BEFDC43249;
	Wed, 30 Sep 2026 11:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341601F000FF;
	Wed, 30 Sep 2026 11:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790767584;
	bh=TQupl8eDsCF6/sGS+B8O0v2tQta8e38EjGU/FlwQXsQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lzBmmt1Q/FAST0Wi2RY1i62DiQEBygHqjx2v8wnuJcl6ICW0Ps6adlK6+EWb+vMiE
	 VodX83Zpcs2rnuidX3ntm63FJyCo0vyPZUL3ViPdt9K9iX6TEDe9/ZHPb6lTecB6zZ
	 lpLqeSr46jR/I3pbDE9aczVttQaeIcFU0oV+q+LvThoS1uS4fKWfPbpbjU/P3cIOnh
	 c0YyVdaA6UKNbGHNcIutWDdJI6JyHyLtrp4gwr/VX8SpPGURLPUzpR26GjqLlTvxBM
	 Ae9F6JY2QbfpHpdO/n6qhnjrDn+mWRke1TKRwEID2WI5lUTKAVNSv2iAGoq0yejX5s
	 pEzP3kv9kjHCA==
Message-ID: <cfdcaaa3-a9e7-4352-ab01-4922ebb8e0c9@kernel.org>
Date: Wed, 30 Sep 2026 13:26:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/numa_balancing: allow migrate on protnone reference
 with MPOL_WEIGHTED_INTERLEAVE policy
To: Li Zhe <lizhe.67@bytedance.com>, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, rppt@kernel.org, mhocko@suse.com,
 corbet@lwn.net, skhan@linuxfoundation.org, ziy@nvidia.com,
 joshua.hahnjy@gmail.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260930072617.64665-1-lizhe.67@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260930072617.64665-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8EF8D80007
X-Rspam-User: 
X-Stat-Signature: 91s8r38ridnixgy1ks95q1b1gncqo9xr
X-HE-Tag: 1790767585-632197
X-HE-Meta: U2FsdGVkX1/YHnFF6Ew7leBcfvG7f8P7zNA7JF3cSIQjvYq6G2dZ2M732hYoVxh/LdFJ+jT6AQQWNwhx6cJ9xjussP2G7Y26RdDC27KAL4ch/sNGgnABK1GkHk/6Du2CBB3avif5uMruV812XxGhbbspOu1UhSYWp9jcmq69QhfgjaTq74Y0cMvx+Fuf7iJOVGuJ07aRcjYRfnwxAA1zSPyvLZYJeKLrvxwBooj8dDFSIjZWRwPIc1SmEqtbnyDgNZ35hKUErr1rb5H6mJIU1gn1OEgThkFlonp+wKkRKusQ5p1mrA8WLOgXs9cMAHqB7M1upZEe/j6WJNb+UMvyi5h0qRb1+LiDgOTHN9GBC7mdOEqdNLi36YdnvUP8z3BWfnnD3YhEu/xNvnesD3S5zZzdi4weACYRGKvGcCi138kivsCRapCJ1s/HYU0EEl6RUUWzRQgJUtAaz/91YztP0v/0TvJ1pf8yeRD5zARVlKS7AQfqrhWr/UMgnH2h5y+GxVsra3uT3pdl/phvWQpxOf2wSSBqC1gD64VNr1+0k/60yWSmCFZ3RYKYh1fFHgQS8gMT55z8aK5wVq5VNIkeDQ8qKJHW8Teu4pKCsetmGwNdkVem0XhtXlq+iNpva0OZSjW/UciFFhesARDVp3z6Hf1wy+BDuIeIsYiexwJGvqB7Wud+TQwtYB9kzDyN97D9mWwFaEK5I+t9EdcQcA06CqypszrcnDXjKihQWEWQ0c31Qy1maqBE/gwsbEO6UVWwhRH4zBwy2YlPdat2oN4/+xRYhzAoE0k+Gb7cEts1gtNOOi38sgVF05KkcAdaQnvGQ1Xx+Fd5Rmb4Ld6P6yULplAFJ+cu9hc3gAtWujnY8uRRAJzyrdXDR9VykVitVqhjm8Xwmi6fyBtSQYu+QxpeHat9e2KDrvZ2k6aPnSlWEPXCeWlNWaU9AKttUeKl3IeCxuOQBzWUWhALkEllmEc
 6rgpyLdS
 6Y5+6legnAtqqOjsoRj9bBFdSgFbzNzhSdx0koWpp/th1Psls4YWMXAWfvKjptQNJ5uqNAD0Gb06nxTzED+buavIV9/ht/uGkOQdFFEH9urJLcCOgAyfRfXlnWUsqu2ankPi7DdH38HG8CM9XN5jX3i8lumxsgEDYpVGCiyuHTR18vH2WiePd746SxLLH85fSrNlC1ySjisUdPQ7DaFXLuhoJiJxBxPGI3axduPnu2q35jpUp7QZrRjTiIE8apJyJofG8Jq4zdUgev/7Mf6LMH0JVMWBSUKFrxsXcgz1ya3m8KPvvmtVrjBBqUn++z+bfGMM+IXqxoCOJPVVVFfmxXg2n+Hr9QUVI24dmA1zYCTflt7nh2cysWJB0DI0Jig0RWydq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/30/26 09:26, Li Zhe wrote:
> MPOL_WEIGHTED_INTERLEAVE is useful on tiered-memory systems because it
> can seed a workload's new allocations across fast memory and slower
> capacity memory according to a configured ratio.
> 
> That initial placement is useful for workload managers and orchestration
> systems.  They can take the amount of fast memory and slower capacity
> memory on a machine into account before starting a workload, and choose a
> weighted policy that seeds the workload across the tiers at allocation
> time.  This avoids starting from an all-fast or all-slow placement and
> then relying on promotion or demotion to reshape a large working set.
> 
> After those pages have been placed, however, the policy cannot currently
> opt in to migrate-on-fault placement.  set_mempolicy() and mbind()
> reject MPOL_WEIGHTED_INTERLEAVE when MPOL_F_NUMA_BALANCING is specified,
> so memory tiering cannot promote hot pages that were initially placed on
> the slower nodes by the weighted policy.
> 
> Initial placement is only a starting point.  Pages initially allocated on
> fast memory are not necessarily the long-term hot pages, and pages
> initially allocated on slower memory may become hot as the workload's hot
> set changes.  The policy therefore needs to be able to combine weighted
> initial placement with memory tiering's NUMA fault based hot-page
> promotion.

Ok, so memory allocation will respect the weights but balancing will ignore
them? That really sounds rather odd to me.

And I assume that was the reason why we might have disallowed the combination:
it turns a weighted mechanism into an unweighted mechanism.

So are we really sure these semantics that you would essentially set in stone
here are the semantics we want? (ignoring weights)

-- 
Cheers,

David


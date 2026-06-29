Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07544C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:20:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBAB26B008A; Mon, 29 Jun 2026 08:20:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6BBF6B0092; Mon, 29 Jun 2026 08:20:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5A936B0093; Mon, 29 Jun 2026 08:20:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 80A556B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:20:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 045931C6CA5
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:20:40 +0000 (UTC)
X-FDA: 84932858682.25.22F8BD9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3A22240013
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:20:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IEmZRrWb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782735639;
	b=Y2whXdPuKmjtUbbSdgM0ow1V6xMoAPrXo8uwBgYC8/bVShIeqhwsa7Os8J0FimRj1SmK72
	FxHP+8D1wZzoxlV+OLhmM/vgxevzA1CW90+ZS2k+RU13BD/Y8bv1VQMxA/lubledAVYjGy
	Suh/s27+Sr5fXe4fYntjzIYFLIuXlus=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782735639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qW52UK1dr3P3d92PPvdNNiTT4nLU70XVqDPppL0qUZE=;
	b=Vib4aeGkajPpxSyRnnxmkH9cSFFIoZ4h7+ATWMtH5khfC9+NJ58fhWK2bH3ElSpTsnXfK8
	P+HJmToCJMPFBMU1ytZBGMhXKApx+3GApFxBDFzdjoBWU0mfazVSp7CSvO57tKryf1hq7a
	41p7M4kdl/beZuwn7YaanMZ8cJHispU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IEmZRrWb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9CE8060008;
	Mon, 29 Jun 2026 12:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911AE1F00A3A;
	Mon, 29 Jun 2026 12:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735638;
	bh=qW52UK1dr3P3d92PPvdNNiTT4nLU70XVqDPppL0qUZE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IEmZRrWb7M8v0WBWSW3iwjW79nCYTyzKIFH4scFbAlM0M9UCCIGeDCEsZ2mQr8LdP
	 u/+2l5Ue4tGlEvrRDH7PzalUWvMMfaruuZYwsug6yis+qlhSk96au3uHaTTLNnGuwt
	 IUIwr2l74LmPAA9oieed5dOi5syAOEsfDxkbDrgIGYt/FPAwLmW8BRgOI8gyz+7yMo
	 7gbeFOh8ZD8fB3IfLVlyC3YjdMkXCfJUx0uSkosnkC166ebqn83qh41WBTOYEiJ8Yf
	 zh9IweY2OdiEt+FRINFy2XAjgXQN+vMsCQsDliVRAYxdsRj2/gKrk+JZzzDFmmdJT5
	 5egwUdn85BTaQ==
Message-ID: <e2bd33d5-4de5-49cd-970f-9e80eec91a3b@kernel.org>
Date: Mon, 29 Jun 2026 14:20:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/8] Introducte Reserved THP
To: Qi Zheng <qi.zheng@linux.dev>, akpm@linux-foundation.org, ljs@kernel.org,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, muchun.song@linux.dev,
 osalvador@suse.de, chrisl@kernel.org, kasong@tencent.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 youngjun.park@lge.com, peterx@redhat.com, usama.arif@linux.dev,
 willy@infradead.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1782538002.git.zhengqi.arch@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <cover.1782538002.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3A22240013
X-Rspam-User: 
X-Stat-Signature: zns41xxxh9d8cdqp14xpjj9xkb4x1zes
X-HE-Tag: 1782735639-857842
X-HE-Meta: U2FsdGVkX19CDNt7r4nN814zE6knN2NbyD+6Q0kUZ2TqMDro9DKXAL6eoEJTjemecXqj9cvZmn8DDYMNoVmMWF+nmQIi2RUpKbO6VqeaOCr8f+YKSiQ629eRRMMK/INvt7tZ5oZvZXr/7oHNWgX/cxQ8fTSeQGw/NGhVodvx7w5yHhlMbFC98OXRhYeCfXZdnfDj4uAfR3rB0ciSLlJUDTuZdP1BzV2bZ0DUyHFMgsttMjeBMbDVUX0jSRNCFvD8IxPNB8dgo50cD6pmPjtYfzUdkG6a0/NfBI5PV0+aP/v5UituPF9+YCBE3KXNAEevIG1NeMbfon4gtmbr1znlT9h7PQimuU9ftZPgBrYwa2UK2LP2tYg999xcy+y5j1pc+UaIJ6HVdOCeljkrfAqO7Io2A/fppc4ymat6ko0UlB6Q2ai10LWdzwyScGAuZnH5gytDb+LjJ9gVsO8OIrgjiX0ptL9StgGFmUZnMm9XQKqJL4Z1rjLsSFaAk6laV3ZoLQtghiMdqnXuZxcU1o2tGHzfPPw9rERDYGduO4cc3Ih0k5cIJClC0dBjO/swqHV99EG+Xj+wRMXBt6Aw48YfZrhghRvJhBRqXNN3SGG7RivwMiLEMVEblAu23IXu5LjOcbcwQSi5wQwrhh4cXV9BCrMQsvFvrO1UvRIApWWNRDT/qg16KybsRCdvdHDtDbrXYjXmDz5pZVszJgsKdRqulgcvSZb5VtMcPuVQeHT6icymUIuANfZPaQudbF5hniIX0fK2zBUYvEO1V0eK/B6AMQU48WrNcGV5kUkpwC5as5QtgcHXCqhYxxZH0vYuItAUWCYc5JDy1Yz45Ef6THlorXdptnNht/uNcgIexxFY5erAcWI1fmpoxbeSdR6ISdkXE3L0DCFeZTvJqrDrZaCNqvYLyJYoF2QtpBVXdDG6WI/w3+VCjH+RLbhb2ZGBGQzp5FzYsubTbKc5tgVGwJa
 b1e0TQye
 nYsqcXqv4I8ysihmsXRGiSSafatWLiilR6klvEBYYHANGFP3B9TmuyAT9/U5rHNtEF8D9am2xRaw9Ye5IFZ6IUu9UZic8Se32RuMW0zHgDebgzjs3m5V4iSBVRgTKPJUC8YrEB+D058V74OL3Brbv5zSHN1pBKzTzjTWdRu/5LdEyyZhStcm35MdBusn58B84F3n+0D/UyTmt6/6YNIxVwHcTRKwIvy53REvE7hvOz7o1189UzoEDcQU+nsPuo52r+FqWg7E3mO1nUc2ePwnbPEgiSp4gS0v6lNH7iEzQI2L5CQDrzAeTiqtJKBVEXGP1IyzI+4vbQJiy5CjzP5gup61qx2DBmUxTznfO2DJ0ypPOoMEPcZU25qJbJo1F/hPk9KhrD9o0qF/IOyOrf3Y3UB6GR6VlSyW80RKBiT9DSl9lCQV4sJ7DIAnyNa9DCvvd6b3KHvL5ubOHVlt7fzaGKzAS2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/27/26 09:21, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Hi all,
> 

Hi,

> This RFC patchset introduces a new feature called "Reserved THP", and I'd like
> to open up a discussion on how to use this as a stepping stone toward unifying
> HugeTLB and THP (Transparent Huge Page).
> 
> 1. Background
> =============
> 
> Currently, two huge page solutions co-exist in the kernel:
> 
> 1. HugeTLB: Supports reservation, guaranteeing successful allocation within the
>             reserved pool. However, it does not support features like swap. And
>             it is a relatively independent subsystem.
> 2. THP: Does not support reservation and may fail to allocate and fallback to
>         small pages when system memory is fragmented, but it is more tightly
>         integrated with mm core and supports features like swap.
> 
> Both have their pros and cons. However, in one of our internal scenarios, it
> seems we need to combine the features of both to meet the requirements.
> 
> In our internal scenario, a user process needs to reserve double the amount
> of Hugetlb memory due to hot-upgrade requirements. For example, if the
> process needs 16GB of Hugetlb, an additional 16GB is required during the
> hot-upgrade to satisfy memory allocations. After the upgrade, the old
> process exits and releases the 16GB of HugeTLB. Therefore, in most cases,
> the extra 16GB of HugeTLB is wasted.
> 
> A straightforward idea is to use the Hugetlb CMA feature, reserving a total
> of 32GB of hugetlb_cma. During normal operation, 16GB is consumed, and the
> remaining 16GB can be used by other processes. During hot-upgrade, we could
> try to migrate the memory used by other processes to allocate the required
> extra 16GB of Hugetlb. This might work, but it still requires reserving 32GB
> of memory.
> 
> We also found that during the hot upgrade, about 10GB of the old process's
> hugetlb is actually cold memory, which could theoretically be reclaimed. In
> extreme cases, we could reserve only 22GB of memory and reclaim the
> remaining 10GB during the hot upgrade. But unfortunately, hugetlb currently
> does not support swap, and supporting it seems quite difficult.
> 
> Therefore, we are wondering if we can introduce "reserved THP", which is THP
> that can be reserved. It can be consumed through methods like madvise(), while
> normal memory allocation cannot consume it.

madvise(). Gah. No :)

> This can achieve an effect similar
> to hugetlb. And because it is THP, it can relatively easily support swap
> features, which perfectly solves the above problem.

No, this is the wrong approach. We really shouldn't be making the same mistake
hugetlb did and support reserving of non-filebacked memory (IOW anonymous memory).

And even for files, the hugetlb mechanism is an absolute trainwreck, because
it's not NUMA aware.

This really needs some proper thought.

> 
> Additionally, in 2024 (or possibly earlier), there have been discussions about
> the possibility of unifying Hugetlb and THP:
> 
> Link: https://lwn.net/Articles/974491/
> 
> After all, hugetlb's management is relatively independent and requires too
> much special handling in mm core. The introduction of reserved THP might be
> an opportunity. In the future, reserved THP could be enhanced to support
> various hugetlb features, such as acting as a backend for hugetlbfs. When
> reserved THP can completely replace HugeTLB, HugeTLB could be entirely
> removed, and reserved THP would just become a feature of THP.
> 
> 2. Implementation
> =================
> 
> In 2024, Yu Zhao proposed a similar idea:
> 
> Link: https://lore.kernel.org/all/20240229183436.4110845-2-yuzhao@google.com/
> 
> The idea was to introduce two virt zones: ZONE_NOSPLIT and ZONE_NOMERGE to
> guarantee the allocation success rate of THP, achieving an effect similar to
> reservation. However, it seems there was no further progress, perhaps because of
> reluctance to introduce more virt zones like ZONE_MOVABLE.
> 
> This RFC wants to discuss another implementation:
> 
> 1. Introduce a new migratetype: MIGRATE_RESERVED_THP.
> 2. Introduce two new hugetlb-like kernel boot parameters: `thp_reserved_size`
>    and `thp_reserved_nr`. When set, the required memory is marked as
>    MIGRATE_RESERVED_THP and put back into the buddy allocator.

I'm all for some mechanism to make runtime allocation of large chunks of memory
easier, by adding a pool from where multiple consumers (THP, guest_memfd,
hugetlb, whatever) can allocate memory.

Call me very skeptical of getting the page allocator involved like this. (I hate it)

> 3. Introduce a new madvise parameter: `MADV_RESERVED_THP`. Pages marked as
>    MIGRATE_RESERVED_THP can only be consumed via `madvise(MADV_RESERVED_THP)`.
>    Other normal memory allocations cannot consume MIGRATE_RESERVED_THP memory.

Definitely no.

> 
> This can achieve a reservation effect similar to HugeTLB and guarantee
> allocation success.
> 
> 3. Future Plans
> ===============
> 
> 3.1 Enhance swap-out and swap-in for large folios
> -------------------------------------------------
> 
> Currently, For swap-out, THP_SWAP is supported, but it only tries to swap out
> the THP folio as a whole. It is still possible to be forced to split in some
> situations (e.g., fragmented swap space, memory.swap.max limits, etc). For
> swap-in, it is almost impossible to directly swap in the THP folio as a whole.
> 
> But for reserved THP, splitting is not allowed. We need to ensure that it
> remains a whole huge page during swap-out and swap-in, to achieve a function
> similar to hugetlb swap.
> 
> 
> 3.2 Integrate reserved THP into the common reclaim path
> -------------------------------------------------------
> 
> Once swap-in and swap-out of huge pages can be supported without splitting,
> reserved THP can be integrated into the common reclaim path as a normal LRU
> folio for memory reclamation. This fills the gap of the hugetlb swap function.
> 
> 3.3 Use reserved THP as a backend for shmem/tmpfs
> -------------------------------------------------
> 
> This would allow shared or file-like usage to utilize reserved THP.
> 

Really, any kind of reservation should be file-centric and have some level of
control.

And soon the question would pop up "but how can we control this inside memcgs".

This all needs some thought.


> 3.4 Use reserved THP as a backend for hugetlbfs
> -----------------------------------------------
> 
> This would allow existing hugetlb users or applications to seamlessly switch to
> reserved THP.

You are really talking about a memory pool that can be used by different consumers.

I raised that in the past in the context of guest_memfd, whereby the short-term
plan is to take pages from hugetlb's pool, when really there should be a global
pool that can be consumed by various consumers.

A lot of questions around that.

> 
> 3.5 Add 1GB page support to reserved THP
> ----------------------------------------
> 
> Historically, there have been several attempts to add 1GB huge page support to
> THP:
> 
> 1. https://lore.kernel.org/linux-mm/20260202005451.774496-1-usamaarif642@gmail.com/
> 2. https://lore.kernel.org/linux-mm/20210224223536.803765-1-zi.yan@sent.com/
> 
> Adding 1GB huge page support for reserved THP would be relatively simpler
> compared to regular THP.

And that's what I told Usama: start with 1 GiB THP support for shmem/tmpfs, and
make it configurable.

How we would add a reservation mechanism is a good question. Because hugetlb
reservation is a broken concept. And anything that's not NUMA or memcg aware
will be a broken concept I'm afraid.

> 
> 3.6 Remove Hugetlb
> ------------------
> 
> Once reserved THP can completely replace the existing functions of hugetlb, we
> can gradually remove Hugetlb, leaving only one huge page management system in
> the kernel.

I'm sorry, but no way this will work in any reasonable timeframe unless you
mimic the exact user facing ABI -- and I don't think we'll gain a lot that way.

I know, we all like to dream, but this just isn't feasible.

-- 
Cheers,

David


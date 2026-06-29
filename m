Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D28C9C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 10:13:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95F916B0005; Mon, 29 Jun 2026 06:13:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 910FA6B0088; Mon, 29 Jun 2026 06:13:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FF736B008A; Mon, 29 Jun 2026 06:13:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 483E26B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:13:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B811E40631
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:13:45 +0000 (UTC)
X-FDA: 84932538810.15.509410A
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 74153120004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:13:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NV1Pbfxi;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782728024;
	b=535PhqUif+yKm7KysLw6as14cJVHZ/ITjHafS8xdWcfhoeAlFOISczrNkxe9xam9lAjgx/
	VRYk7oxmAXJ9oxQMwVOwKNVjBsNrUGuiLAFn66JKact1EsS3TKpNng71xADE3sy2c8/39Y
	ygdFLxg2qw7Op5/agySwyMNKn9CEme4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782728024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UKZNVJ/gcxlxQrgjJNu5933Qlj0kKhoGLU19p+IgVJ0=;
	b=T5H/TC4p0FzxW2ggc88BCm6eQp2umEAi5riZkkgsTQNuJ+JhJmJ8KqKrl9jELPzPUDLJu0
	QbzfmBYTyh72L4wiQLIUdm11dz8MEVDuRkeRlUht1/pbPr0iby0jOHY3kJbwUSnxDGsi2L
	aa+KfR+T0juo+gxU6ZmJTG0KVnpc6T0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NV1Pbfxi;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <ae67cdd2-b20b-42cb-836e-ef3bf35a1ad0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782728019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UKZNVJ/gcxlxQrgjJNu5933Qlj0kKhoGLU19p+IgVJ0=;
	b=NV1Pbfxio8gAByYFC1V3qh7csUsoapbjHKidynI0KglNVL3huMMStBYjjzzVXKNgkA6TgN
	P9aW9TVz9lBrBPYMFQc5Y8o8nb6c2kntd8RcQSQd/vZpnJlrDQytD7nIPcIaYW0SVCyTZk
	uwZ38TGk9vXMtq5OdUFLyvF51oZoVfE=
Date: Mon, 29 Jun 2026 18:13:22 +0800
MIME-Version: 1.0
Subject: Re: [RFC PATCH 0/8] Introducte Reserved THP
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, muchun.song@linux.dev,
 osalvador@suse.de, chrisl@kernel.org, kasong@tencent.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 youngjun.park@lge.com, peterx@redhat.com, usama.arif@linux.dev,
 vbabka@kernel.org, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1782538002.git.zhengqi.arch@bytedance.com>
 <akHqebup1xqlgC0E@casper.infradead.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <akHqebup1xqlgC0E@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: bpoojwwf5am1fbkrfh6q4scfwwdbptmh
X-Rspamd-Queue-Id: 74153120004
X-Rspamd-Server: rspam06
X-HE-Tag: 1782728023-588356
X-HE-Meta: U2FsdGVkX1820SKaF5vAC+EeUP3hucnjZNdJagCiMnuRRCgHEoF6coALD+shmZHXOyEGlJH0bpDWS8IQMiiUDr5rjYAHl15dacM8slY5GNPHvpMK8IwJuRl9zHdvG/7KMpuW8BHnEsoypDoe20mupBSwTcei9qztRYefY4fCndJVBBBIC1Uk1MOgidI0WoV9r570Md7DiGTzFPPGPN590QC9joNuWzsgFutDTIYsVR7R3BGPIGRqVVMJ0NsKPmoMmyfW2KALWVBft+WuZ6FHyA4YFh+fsNyYPOIi9i/g4A4X1pcPsA7cIqa5FbETe+I+INl/hcsz6eWC7f0p8pNSF54oUcxfoqFygjsawBkNXzJ40zees7VIc2Q3oLXnMCVnWQ0+sgZY8hy2i3eCPaM7y39j0UbgTRchxGMw4wEZQmxlX9Q15Spzh/tiuLCL8YMG4RSm3QSJz7QivC1qbi8pPZFOPY4E8Loqzlo5WDNcbSwGXBGPLcrJfcRwYvDWUZL5hySm5jIF9X8paGv0vJikSVOiXdT9X0HFXYhvgr+yMl2rEdk+XfgykMJKIhuSoqiH2H4aU5KXH0+E2PW933lT4m3lN8JJ9rvtSi+7HpFd1zKu/uQB+JVYnfH7FCiFbTN6w18Eu3/jBtQyXuHNwFLHhQ9fB4ovRekIOqdOa7u9nWsVVp3Z9DF+kkq5/63gdsagzB+vNQUysMk+3J56TLFTLInXI0MT44xJGj1oSA5KIEuVIVigtA5wQ+tvdlutXMZujyIWHyc69t3HWc3iWkpJ+iAUfgI+gwgpyPEXQxu3p0f+K5mwb7JOkS3+vchvgbMaaYHYVCw+8ZtF8VNY0VvIN/xdJuIgRVE2p6PYjd0qlePCVbcd3Ru72YtHDfLUP5K8vne6FoFPAcUEfzGT/7RatY84NO3F7IMMcIj4f0xPwfNdy4oTdh6fTr3tB+jttX4NUjHBwJtk6UiPoC9nl7J
 EFQPpPQ9
 /2xx7s5yG+f0RQr+f9Aj4lTxNEGtVc+2SJHKzY0pi4ryBTMXAixoBmTkd+2H0OLE2WMnWiNuEYj4LmXlWXu1lHa3ynOKjlOEymX85+F+lsZhV87l1YK8f6VveMr6lgd4EsHIvtKqMoqEMlT7McPVDUoTdNwkgT4xSLQFPn6plmwKw5WEQgwOM3wnCz2M6gYI0fQXfOYZM1nfSZ46XqbBHegpQWui7ApgKjJku47KI6nDh9Dg1hdwvT86zztui9o2DixN2ZDVAY5V9tJE3pXVXbpLECcdA2DQwms4RMl9VHpc+QyqWMGCvy8sfG3N5zQTYwiGo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Matthew,

Thanks a lot for your feedback!

On 6/29/26 11:46 AM, Matthew Wilcox wrote:
> On Sat, Jun 27, 2026 at 03:21:48PM +0800, Qi Zheng wrote:
>> This RFC patchset introduces a new feature called "Reserved THP", and I'd like
>> to open up a discussion on how to use this as a stepping stone toward unifying
>> HugeTLB and THP (Transparent Huge Page).
> 
> I'm really happy you're looking into this.  I'm not terribly familiar
> with the page allocator code, so I don't have any comments on the
> patches themselves, but I do have a few on your approach.

This is also what I am hoping for. The current version of the code is
just proof-of-concept (PoC) to facilitate discussion. The real goal is
to use reserved THP as a stepping stone to discuss the challages of
unifying HugeTLB and THP, and the overall evolution path.

Of course, swap support is a key part too. ;)

> 
>> Therefore, we are wondering if we can introduce "reserved THP", which is THP
>> that can be reserved. It can be consumed through methods like madvise(), while
>> normal memory allocation cannot consume it. This can achieve an effect similar
>> to hugetlb. And because it is THP, it can relatively easily support swap
>> features, which perfectly solves the above problem.
> 
> As I understand it, hugetlbfs reserves on mmap().

Exactly, hugetlbfs reserves HugeTLB pages at mmap() time:

hugetlbfs_file_mmap
--> hugetlb_reserve_pages

and it's the same without using hugetlbfs:

hugetlb_file_setup
--> hugetlb_reserve_pages

Using madvise() as the example is based on the following considerations:

1. It closely aligns with the existing usage patterns of THP madvise
    mode.
2. To properly support swap, we actually need to allow overcommit before
    actual page faults occur. This allows us to perform memory reclaim
    during the page fault, swapping out cold reserved THP to satisfy the
    memory demands of new process. So we can't directly pre-reserv the
    reserved THP at mmap/madvise time.

The second point seems to be a challenge that HugeTLB would also face if
it were to support swap. Perhaps reserved THP could be designed with two
modes:

1. with swap support: using the current madvise method.
2. without swap support: in this mode, we can directly let hugetlbfs
    reserve the reserved THP at mmap() time. The behavior remains the
    same, purely switching the underlying backend.

But this might muddy the semantics a bit...

> 
>> This RFC wants to discuss another implementation:
>>
>> 1. Introduce a new migratetype: MIGRATE_RESERVED_THP.
>> 2. Introduce two new hugetlb-like kernel boot parameters: `thp_reserved_size`
>>     and `thp_reserved_nr`. When set, the required memory is marked as
>>     MIGRATE_RESERVED_THP and put back into the buddy allocator.
>> 3. Introduce a new madvise parameter: `MADV_RESERVED_THP`. Pages marked as
>>     MIGRATE_RESERVED_THP can only be consumed via `madvise(MADV_RESERVED_THP)`.
>>     Other normal memory allocations cannot consume MIGRATE_RESERVED_THP memory.
>>
>> This can achieve a reservation effect similar to HugeTLB and guarantee
>> allocation success.
> 
> I think this is an interesting approach.  I don't think it should be too
> hard to migrate existing hugetlbfs users to it.

That is also what I hope to see.

> 
>> 3. Future Plans
>> ===============
>>
>> 3.1 Enhance swap-out and swap-in for large folios
>> -------------------------------------------------
>>
>> Currently, For swap-out, THP_SWAP is supported, but it only tries to swap out
>> the THP folio as a whole. It is still possible to be forced to split in some
>> situations (e.g., fragmented swap space, memory.swap.max limits, etc). For
>> swap-in, it is almost impossible to directly swap in the THP folio as a whole.
>>
>> But for reserved THP, splitting is not allowed. We need to ensure that it
>> remains a whole huge page during swap-out and swap-in, to achieve a function
>> similar to hugetlb swap.
> 
> So I think the current restriction is something that needs to be fixed
> anyway.  It doesn't actually make sense that a folio must be written out
> contiguously; filesystems do not have this restriction.  I understand

Hopefully, there won't be too much pushback.

> why swap currently has this limitation, but I'm hoping it gets removed
> at some point.  I'm not sure if the people working on swap right now
> intend to fix this.  They're already on the cc, so I hope they chime in.

+1.

Hi SWAP folks, how hard would it be to get this implemented? Are there
any current plans for this? ;)

> 
>> 3.2 Integrate reserved THP into the common reclaim path
>> -------------------------------------------------------
>>
>> Once swap-in and swap-out of huge pages can be supported without splitting,
>> reserved THP can be integrated into the common reclaim path as a normal LRU
>> folio for memory reclamation. This fills the gap of the hugetlb swap function.
> 
> Hm.  Then what does "reserved THP" mean if they can be swapped out?

Indeed, it is a bit weird.

In this version, what's actually reserved is essentially a memory pool.
After a reserved THP page is swapped out, the space in the pool might be
consumed by someone else. So, there's no guarantee that this reserved
THP page can be successfully swapped back in.

But if we don't want it swapped out, it can be guaranteed via mlock or
GUP.

> 
>> 3.4 Use reserved THP as a backend for hugetlbfs
>> -----------------------------------------------
>>
>> This would allow existing hugetlb users or applications to seamlessly switch to
>> reserved THP.
> 
> If this is the end goal, then I think introducing new command line
> options is probably the wrong approach right now.  Instead, "reserved
> THPs" should be allocated from the same pool as hugetlb reserve.  That
> way we're not jerking sysadmins around.

Do you mean reusing the existing HugeTLB boot parameters instead of
introducing new ones? That seems quite difficult to implement during the
transition. My idea is that we can eventually drop the HugeTLB boot
parameters entirely, so the system will still end up with only one set
of parameters. ;)

> 
>> 3.5 Add 1GB page support to reserved THP
>> ----------------------------------------
>>
>> Historically, there have been several attempts to add 1GB huge page support to
>> THP:
>>
>> 1. https://lore.kernel.org/linux-mm/20260202005451.774496-1-usamaarif642@gmail.com/
>> 2. https://lore.kernel.org/linux-mm/20210224223536.803765-1-zi.yan@sent.com/
>>
>> Adding 1GB huge page support for reserved THP would be relatively simpler
>> compared to regular THP.
> 
> Well.  Maybe?  What happens if we mmap() 16GiB,

At least the side effects are limited strictly to reserved THPs, and
reserved THP is pre-reserved, ensuring a higher allocation success rate.

> madvise(USE_RESERVED_THPS) and then munmap() the first 4KiB of it?

Since splitting is not allowed for reserved THPs, the entire huge page
will be freed at munmap time.

> 
>> 3.6 Remove Hugetlb
>> ------------------
>>
>> Once reserved THP can completely replace the existing functions of hugetlb, we
>> can gradually remove Hugetlb, leaving only one huge page management system in
>> the kernel.
> 
> We also need mshare to land ... but yes, eventually removing hugetlbfs

mshare? Do you mean CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING?

> is my hope.

+1.

Thanks,
Qi




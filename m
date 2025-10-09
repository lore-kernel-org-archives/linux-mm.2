Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC172CCD185
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 12:08:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E8798E0091; Thu,  9 Oct 2025 08:08:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 098A68E0002; Thu,  9 Oct 2025 08:08:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA28D8E0091; Thu,  9 Oct 2025 08:08:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D40C28E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 08:08:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 78F004655A
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 12:08:12 +0000 (UTC)
X-FDA: 83978452824.15.8BADFA4
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf10.hostedemail.com (Postfix) with ESMTP id 20502C000C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 12:08:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760011690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mc1TIPZmtb3tKLWmvtpCO9BID0gxh7mz4dL5hPgt17w=;
	b=zA/Hsf/eG7CPizw1G5iTS7QETmCuEk9PDi1jn2CL3goQriPf7YtDPB6x16v4kgKp+R9TNx
	GKwSoEBb2/NULhf0FRqFWFTePXsv4Ecm+NLpUhN2/IwSOFhHIqm5xaaWWdoLZbpZK/Cg4I
	5/7DFVEcFyLVXB/783yCAxqRGlueI2c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760011690; a=rsa-sha256;
	cv=none;
	b=nup+SGv5Mz741zVMzIv+YiiJW2LfICNVcUJN2Qkgg+dOej33E9YGtRA0TYW0D31PSlvQGW
	utUbAXc+yen/4RCpbIvdHikMTQoq8ytaC+uh2BR6qXFti2N9ZEzZOFfgOpGsEqBa6sXoAn
	VDdAqNWmQCZcHc7ST87KpwVdq4+n/M8=
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4cj7tc3BBqz9sSy;
	Thu,  9 Oct 2025 14:08:08 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t-GI2jPxTJia; Thu,  9 Oct 2025 14:08:08 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4cj7tc1MWCz9sSv;
	Thu,  9 Oct 2025 14:08:08 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 08F7B8B76C;
	Thu,  9 Oct 2025 14:08:08 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id dX5DSkuE_w6O; Thu,  9 Oct 2025 14:08:07 +0200 (CEST)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id BC52E8B767;
	Thu,  9 Oct 2025 14:08:05 +0200 (CEST)
Message-ID: <4632e721-0ac8-4d72-a8ed-e6c928eee94d@csgroup.eu>
Date: Thu, 9 Oct 2025 14:08:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (bisected) [PATCH v2 08/37] mm/hugetlb: check for unreasonable
 folio sizes when registering hstate
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-9-david@redhat.com>
 <3e043453-3f27-48ad-b987-cc39f523060a@csgroup.eu>
 <d3fc12d4-0b59-4b1f-bb5c-13189a01e13d@redhat.com>
 <faf62f20-8844-42a0-a7a7-846d8ead0622@csgroup.eu>
 <9361c75a-ab37-4d7f-8680-9833430d93d4@redhat.com>
 <03671aa8-4276-4707-9c75-83c96968cbb2@csgroup.eu>
 <1db15a30-72d6-4045-8aa1-68bd8411b0ba@redhat.com>
 <0c730c52-97ee-43ea-9697-ac11d2880ab7@csgroup.eu>
 <543e9440-8ee0-4d9e-9b05-0107032d665b@redhat.com>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <543e9440-8ee0-4d9e-9b05-0107032d665b@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 20502C000C
X-Rspamd-Server: rspam03
X-Stat-Signature: j114hdfddq4emjqrajb7xfcb1z4yrm8u
X-HE-Tag: 1760011689-421179
X-HE-Meta: U2FsdGVkX191ZrrVP6WL99/OCvXaOJEiXyRhgy2QCB/D7G8spXUR37ZRyaWyBGEVnO9JQ73A5uw9t32vR+OuV2J1h5b6DgXC4xU0Jcc4Kc3YG/PLB44Q5WnjGd/FdYcs6Bxm+TTWBwBb3xCWJj5ieg6UVnTpaJL9E8zp9kVpKly45QNtthuZutrfm8YLPVK1fAufzwcbKKfiOeW0cKG4wLCiNNq+UckEpAEk65xDhhEH8RmCg8GLqCCT6tQNr83KscZBg5MsbcDXMU8R80Acwgm7HbS6RdbkRP44VlIuB43s7B+vRrWUFKlCaFxt8k5KcNjyqe6VJ6MX+TEvDfPWZkj9Sq10GV//Dx5BzuYFAgCKeOiKgz3h8CLN1yS2sgOHK/VH+Ys1V2FYhNWctu3NyUk1GriNtuVE5JSqQgaYWjQcLEtQ6V95d/ORYAdzRFbyfySMRfoubqnRFGG+tRtcabw64yJ63mo98+f5nDcCC2navORYYNNHv9wkWTHxABdqZ2ypzuzdeqFZb20iZYySr2pPVzoFrBgFfb69a9QiZjMi9N91PpYja740UnbAZUx8TkJzpRCfktUOjYQ8hXFbbnN24nRToNDRUPUgOES2IlsSvcvs/0oFQxRngT3T0KKyULp/zQBXeeJL1++d+VPAV8dQ9UIu+v4Mh+g1olGoNWl1t02xueQXB/uKX1fXVAPu8HODzk8KVrdzenxuleoFJjj4GSLeNB2+S1Zgw4A65bhKM9czk4IuipBD5nmN4cAMRRamOv5ZYAT45xcrFKZNw5goxodqVj+E9fh9vE/Yv1u8csa9WhnCUOqtAmVDSu+uYwWAFuCq6+FR1EWIcwRXO2s44gV6b9G0YZacakIzm0k1cXDmO4Z+CU8jFN+C+0Chd7BYWgDBy9bC4p6V8JM8D/7LNK/lOC+d8E+Sgvt8zrieXf+FlQwDgMNZyX9U3Bd0M/yFamjs476kGNE72yL
 j2MxvBek
 ftYQQWdF2i+ioBhZoE0oDEi1MywLIlEU1cVF4LF153beKdW0LlrPuTfs6EmRSr85ORIcL0UshZ35iPtAH6HYOOWifNOwarztjzYUJ+yXKZvztsQ4m5A3J656pN0mAHb6pzxXQEocpMzojvsfwNNvcMjorfyh4+xD1aKppTNM7YUrb+yHL9oWb2sDWBqxaJzNIk9T4Waywu5KtvxVdqjUtqsboQZCG6ry8x3yNV1rskmg8ghzYIgJTZoYjjnfMhBdsqU9JT2cSm8paObQCHbryF60SVNHwebyQRQYn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 09/10/2025 à 12:27, David Hildenbrand a écrit :
> On 09.10.25 12:01, Christophe Leroy wrote:
>>
>>
>> Le 09/10/2025 à 11:20, David Hildenbrand a écrit :
>>> On 09.10.25 11:16, Christophe Leroy wrote:
>>>>
>>>>
>>>> Le 09/10/2025 à 10:14, David Hildenbrand a écrit :
>>>>> On 09.10.25 10:04, Christophe Leroy wrote:
>>>>>>
>>>>>>
>>>>>> Le 09/10/2025 à 09:22, David Hildenbrand a écrit :
>>>>>>> On 09.10.25 09:14, Christophe Leroy wrote:
>>>>>>>> Hi David,
>>>>>>>>
>>>>>>>> Le 01/09/2025 à 17:03, David Hildenbrand a écrit :
>>>>>>>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>>>>>>>> index 1e777cc51ad04..d3542e92a712e 100644
>>>>>>>>> --- a/mm/hugetlb.c
>>>>>>>>> +++ b/mm/hugetlb.c
>>>>>>>>> @@ -4657,6 +4657,7 @@ static int __init hugetlb_init(void)
>>>>>>>>>           BUILD_BUG_ON(sizeof_field(struct page, private) *
>>>>>>>>> BITS_PER_BYTE <
>>>>>>>>>                   __NR_HPAGEFLAGS);
>>>>>>>>> +    BUILD_BUG_ON_INVALID(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
>>>>>>>>>           if (!hugepages_supported()) {
>>>>>>>>>               if (hugetlb_max_hstate ||
>>>>>>>>> default_hstate_max_huge_pages)
>>>>>>>>> @@ -4740,6 +4741,7 @@ void __init hugetlb_add_hstate(unsigned int
>>>>>>>>> order)
>>>>>>>>>           }
>>>>>>>>>           BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
>>>>>>>>>           BUG_ON(order < order_base_2(__NR_USED_SUBPAGE));
>>>>>>>>> +    WARN_ON(order > MAX_FOLIO_ORDER);
>>>>>>>>>           h = &hstates[hugetlb_max_hstate++];
>>>>>>>>>           __mutex_init(&h->resize_lock, "resize mutex", &h-
>>>>>>>>>> resize_key);
>>>>>>>>>           h->order = order;
>>>>>>>
>>>>>>> We end up registering hugetlb folios that are bigger than
>>>>>>> MAX_FOLIO_ORDER. So we have to figure out how a config can trigger
>>>>>>> that
>>>>>>> (and if we have to support that).
>>>>>>>
>>>>>>
>>>>>> MAX_FOLIO_ORDER is defined as:
>>>>>>
>>>>>> #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
>>>>>> #define MAX_FOLIO_ORDER        PUD_ORDER
>>>>>> #else
>>>>>> #define MAX_FOLIO_ORDER        MAX_PAGE_ORDER
>>>>>> #endif
>>>>>>
>>>>>> MAX_PAGE_ORDER is the limit for dynamic creation of hugepages via
>>>>>> /sys/kernel/mm/hugepages/ but bigger pages can be created at boottime
>>>>>> with kernel boot parameters without CONFIG_ARCH_HAS_GIGANTIC_PAGE:
>>>>>>
>>>>>>       hugepagesz=64m hugepages=1 hugepagesz=256m hugepages=1
>>>>>>
>>>>>> Gives:
>>>>>>
>>>>>> HugeTLB: registered 1.00 GiB page size, pre-allocated 0 pages
>>>>>> HugeTLB: 0 KiB vmemmap can be freed for a 1.00 GiB page
>>>>>> HugeTLB: registered 64.0 MiB page size, pre-allocated 1 pages
>>>>>> HugeTLB: 0 KiB vmemmap can be freed for a 64.0 MiB page
>>>>>> HugeTLB: registered 256 MiB page size, pre-allocated 1 pages
>>>>>> HugeTLB: 0 KiB vmemmap can be freed for a 256 MiB page
>>>>>> HugeTLB: registered 4.00 MiB page size, pre-allocated 0 pages
>>>>>> HugeTLB: 0 KiB vmemmap can be freed for a 4.00 MiB page
>>>>>> HugeTLB: registered 16.0 MiB page size, pre-allocated 0 pages
>>>>>> HugeTLB: 0 KiB vmemmap can be freed for a 16.0 MiB page
>>>>>
>>>>> I think it's a violation of CONFIG_ARCH_HAS_GIGANTIC_PAGE. The 
>>>>> existing
>>>>> folio_dump() code would not handle it correctly as well.
>>>>
>>>> I'm trying to dig into history and when looking at commit 4eb0716e868e
>>>> ("hugetlb: allow to free gigantic pages regardless of the
>>>> configuration") I understand that CONFIG_ARCH_HAS_GIGANTIC_PAGE is
>>>> needed to be able to allocate gigantic pages at runtime. It is not
>>>> needed to reserve gigantic pages at boottime.
>>>>
>>>> What am I missing ?
>>>
>>> That CONFIG_ARCH_HAS_GIGANTIC_PAGE has nothing runtime-specific in its
>>> name.
>>
>> In its name for sure, but the commit I mention says:
>>
>>       On systems without CONTIG_ALLOC activated but that support gigantic
>> pages,
>>       boottime reserved gigantic pages can not be freed at all.  This 
>> patch
>>       simply enables the possibility to hand back those pages to memory
>>       allocator.
> 
> Right, I think it was a historical artifact.
> 
>>
>> And one of the hunks is:
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index 7f7fbd8bd9d5b..7a1aa53d188d3 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -19,7 +19,7 @@ config ARM64
>>           select ARCH_HAS_FAST_MULTIPLIER
>>           select ARCH_HAS_FORTIFY_SOURCE
>>           select ARCH_HAS_GCOV_PROFILE_ALL
>> -       select ARCH_HAS_GIGANTIC_PAGE if CONTIG_ALLOC
>> +       select ARCH_HAS_GIGANTIC_PAGE
>>           select ARCH_HAS_KCOV
>>           select ARCH_HAS_KEEPINITRD
>>           select ARCH_HAS_MEMBARRIER_SYNC_CORE
>>
>> So I understand from the commit message that it was possible at that
>> time to have gigantic pages without ARCH_HAS_GIGANTIC_PAGE as long as
>> you didn't have to be able to free them during runtime.
> 
> Yes, I agree.
> 
>>
>>>
>>> Can't we just select CONFIG_ARCH_HAS_GIGANTIC_PAGE for the relevant
>>> hugetlb config that allows for *gigantic pages*.
>>>
>>
>> We probably can, but I'd really like to understand history and how we
>> ended up in the situation we are now.
>> Because blind fixes often lead to more problems.
> 
> Yes, let's figure out how to to it cleanly.
> 
>>
>> If I follow things correctly I see a helper gigantic_page_supported()
>> added by commit 944d9fec8d7a ("hugetlb: add support for gigantic page
>> allocation at runtime").
>>
>> And then commit 461a7184320a ("mm/hugetlb: introduce
>> ARCH_HAS_GIGANTIC_PAGE") is added to wrap gigantic_page_supported()
>>
>> Then commit 4eb0716e868e ("hugetlb: allow to free gigantic pages
>> regardless of the configuration") changed gigantic_page_supported() to
>> gigantic_page_runtime_supported()
>>
>> So where are we now ?
> 
> In
> 
> commit fae7d834c43ccdb9fcecaf4d0f33145d884b3e5c
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> Date:   Tue Feb 27 19:23:31 2024 +0000
> 
>      mm: add __dump_folio()
> 
> 
> We started assuming that a folio in the system (boottime, dynamic, 
> whatever)
> has a maximum of MAX_FOLIO_NR_PAGES.
> 
> Any other interpretation doesn't make any sense for MAX_FOLIO_NR_PAGES.
> 
> 
> So we have two questions:
> 
> 1) How to teach MAX_FOLIO_NR_PAGES that hugetlb supports gigantic pages
> 
> 2) How do we handle CONFIG_ARCH_HAS_GIGANTIC_PAGE
> 
> 
> We have the following options
> 
> (A) Rename existing CONFIG_ARCH_HAS_GIGANTIC_PAGE to something else that is
> clearer and add a new CONFIG_ARCH_HAS_GIGANTIC_PAGE.
> 
> (B) Rename existing CONFIG_ARCH_HAS_GIGANTIC_PAGE -> to something else 
> that is
> clearer and derive somehow else that hugetlb in that config supports 
> gigantic pages.
> 
> (c) Just use CONFIG_ARCH_HAS_GIGANTIC_PAGE if hugetlb on an architecture
> supports gigantic pages.
> 
> 
> I don't quite see why an architecture should be able to opt in into 
> dynamically
> allocating+freeing gigantic pages. That's just CONTIG_ALLOC magic and 
> not some
> arch-specific thing IIRC.
> 
> 
> Note that in mm/hugetlb.c it is
> 
>      #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
>      #ifdef CONFIG_CONTIG_ALLOC
> 
> Meaning that at least the allocation side is guarded by CONTIG_ALLOC.

Yes but not the freeing since commit 4eb0716e868e ("hugetlb: allow to 
free gigantic pages regardless of the configuration")

> 
> So I think (C) is just the right thing to do.
> 
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 0bfdaecaa8775..12c11eb9279d3 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -283,6 +283,8 @@ config HUGETLB_PMD_PAGE_TABLE_SHARING
>          def_bool HUGETLB_PAGE
>          depends on ARCH_WANT_HUGE_PMD_SHARE && SPLIT_PMD_PTLOCKS
> 
> +# An architecture must select this option if there is any mechanism 
> (esp. hugetlb)
> +# could obtain gigantic folios.
>   config ARCH_HAS_GIGANTIC_PAGE
>          bool
> 
> 

I gave it a try. That's not enough, it fixes the problem for 64 Mbytes 
pages and 256 Mbytes pages, but not for 1 Gbytes pages.

Max folio is defined by PUD_ORDER, but PUD_SIZE is 256 Mbytes so we need 
to make MAX_FOLIO larger. Do we change it to P4D_ORDER or is it too much 
? P4D_SIZE is 128 Gbytes

Christophe



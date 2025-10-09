Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7283CCCD188
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 09:17:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADEE88E006F; Thu,  9 Oct 2025 05:16:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A88948E0002; Thu,  9 Oct 2025 05:16:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 976F38E006F; Thu,  9 Oct 2025 05:16:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7F3FB8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 05:16:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3512114058E
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 09:16:59 +0000 (UTC)
X-FDA: 83978021358.03.03A2334
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf13.hostedemail.com (Postfix) with ESMTP id F11C020004
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 09:16:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760001417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SjzO/ywmFDyEDpAIYRGFQ4F67Mu4cfU8z7gpJNsGZLg=;
	b=LrP70ZAeGdYOOFVh5vugPIYJlFmTHXI4WvIUGvaHjdBl22Q1oueDVzx5VqkmRXR+j36wub
	22woGQ+dRkOkpDQ8Y+skkq5JyiPkj2pfh+A3YX/iwQObFYtDqgKU6agwjHW9qqfylgOqgn
	I1q8BKV4h15ntH45Z9ub8YoUdpnu0MY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760001417; a=rsa-sha256;
	cv=none;
	b=KgUj1+7ksooV7LL4E5/aT9OEPrcyHM/AMWSpEnQsDD53XCy75Gh+8pK/ZVXc9vSzHiT5yK
	S2ASqnUNjK7sqjEoyX9flOZmtFGcaQVRG65vH9xCeM7FvauHAE4cRsJ+2nT+/I5ZJJ2Zn5
	gfkpNvaGV2+8RFhdNZbGvTKLa0UcEXw=
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4cj4530nVNz9sSY;
	Thu,  9 Oct 2025 11:16:55 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1xW49BLVjvgf; Thu,  9 Oct 2025 11:16:55 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4cj4526L27z9sSX;
	Thu,  9 Oct 2025 11:16:54 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id BC2658B773;
	Thu,  9 Oct 2025 11:16:54 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id ecZHQXz6ERX1; Thu,  9 Oct 2025 11:16:54 +0200 (CEST)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id BE4258B770;
	Thu,  9 Oct 2025 11:16:52 +0200 (CEST)
Message-ID: <03671aa8-4276-4707-9c75-83c96968cbb2@csgroup.eu>
Date: Thu, 9 Oct 2025 11:16:52 +0200
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
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <9361c75a-ab37-4d7f-8680-9833430d93d4@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F11C020004
X-Stat-Signature: 6wb3bifqihbgx3kkpa6puaygqsrinw7d
X-Rspam-User: 
X-HE-Tag: 1760001416-308034
X-HE-Meta: U2FsdGVkX18+wF3OvBFFTIf3NuNb9UjKa1/ELaEXk8vTLIpCnRf/YmmVWoYCjgvluUDfVawDiM70fWEnP49F1zDDSml1fGj6bp8WeMBValn/YJFhW64ix43BAldyZe5uIoqISCr/n8sfezbSqg7P9oQ2fmoK8ZO04VGidWDy5R/fo/FFfIzbgT2U7wYevgfiKnJw/Pi9GS36qDmbfIPqgZrQVGBL3pEfhZYsJCyDdVxo87uPp2Tl6WERxOFURnXI1M1dwJwT+GPgQuieBWczTRL1xSEswXtOfNd4JKw0kItzWctzS9qlFhzz1SMakCjvhCcovlW1MsaVNffQcb4LkbuAnQ6/8BGbfmN8c04TpNKRff4cWZhhJtW/Zv5dz7xd+8CPzsBzRzDXuQr9OvTz0tqvx0ngYnA0B5DoXKbuNWOK+qP63foRpYkoY1Qg8oAZLQ8ViIq+PeuTtx5E75VlJxtJ1J9g9tsaOq2Z3nNIZA70OWwMZUzRmDbqQdvKw5Me4TTUZwfzXMSHb+LUJTMf3o0x4rr+NNid7MWYP5zZFQ4MwpEM8PfrrBEVVQhF1C1xSKzdTfRqP+iEcFgs1CWiR6DV/HCNgmHy5CI5uZXjdjgX+JwWw+VajV2FQ0DZhlF/GDKyqpe8j5EYnyVGy9F94AvTgRXh1JcVxE9ICmVAVhPGKR8W4suSe/4yXlQYuDskvExaDNz8nB/J6B6MVEx/pYQtOPxxEfvbn6SsNfr+19EmyHwNDA3EPK75XVpfj33lpsZ+E82//Km6XjaqEVFrZxHioRkLJ1l+ejfX/wxgYiK2wc2gdgm7jhATylWwCOSG0MzbbbsOSkKfjPU7pZwLKJLdKbEFYB3Zeuwe/Ew77tAPJZAVMoUomCTVqa5Wco8yULdgX2CXR9NM5Z5aqHpxPuU+zWROAfDUARCHBQsQLlqJzgQpBa0QVDXscX7UXJ3ipiZWSHhxxiBOSyxx1Tc
 QS4DB21r
 PagvcSowmzyuSfgjUeXi/18tVnkPuuIwkV5xJ5EDAU54Py3jVYdcE606b8RFor9oW0YtZMnFjQxtvlXEEtnl3i8JrYNTJ3kaYjfETHjfixXUtdSWeOWcKxh5tSamzpGbQL3dbaoK9qyEKnwA+wAJGqqprR+YuEIv+g8qcigRoypA37yWAEH9vTLRtJTnME7nwuAagR/UnMR/47+cfXUgtgF2VHW1W4zx22GeF2u93+/A+YyY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 09/10/2025 à 10:14, David Hildenbrand a écrit :
> On 09.10.25 10:04, Christophe Leroy wrote:
>>
>>
>> Le 09/10/2025 à 09:22, David Hildenbrand a écrit :
>>> On 09.10.25 09:14, Christophe Leroy wrote:
>>>> Hi David,
>>>>
>>>> Le 01/09/2025 à 17:03, David Hildenbrand a écrit :
>>>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>>>> index 1e777cc51ad04..d3542e92a712e 100644
>>>>> --- a/mm/hugetlb.c
>>>>> +++ b/mm/hugetlb.c
>>>>> @@ -4657,6 +4657,7 @@ static int __init hugetlb_init(void)
>>>>>         BUILD_BUG_ON(sizeof_field(struct page, private) * 
>>>>> BITS_PER_BYTE <
>>>>>                 __NR_HPAGEFLAGS);
>>>>> +    BUILD_BUG_ON_INVALID(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
>>>>>         if (!hugepages_supported()) {
>>>>>             if (hugetlb_max_hstate || default_hstate_max_huge_pages)
>>>>> @@ -4740,6 +4741,7 @@ void __init hugetlb_add_hstate(unsigned int 
>>>>> order)
>>>>>         }
>>>>>         BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
>>>>>         BUG_ON(order < order_base_2(__NR_USED_SUBPAGE));
>>>>> +    WARN_ON(order > MAX_FOLIO_ORDER);
>>>>>         h = &hstates[hugetlb_max_hstate++];
>>>>>         __mutex_init(&h->resize_lock, "resize mutex", &h->resize_key);
>>>>>         h->order = order;
>>>
>>> We end up registering hugetlb folios that are bigger than
>>> MAX_FOLIO_ORDER. So we have to figure out how a config can trigger that
>>> (and if we have to support that).
>>>
>>
>> MAX_FOLIO_ORDER is defined as:
>>
>> #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
>> #define MAX_FOLIO_ORDER        PUD_ORDER
>> #else
>> #define MAX_FOLIO_ORDER        MAX_PAGE_ORDER
>> #endif
>>
>> MAX_PAGE_ORDER is the limit for dynamic creation of hugepages via
>> /sys/kernel/mm/hugepages/ but bigger pages can be created at boottime
>> with kernel boot parameters without CONFIG_ARCH_HAS_GIGANTIC_PAGE:
>>
>>     hugepagesz=64m hugepages=1 hugepagesz=256m hugepages=1
>>
>> Gives:
>>
>> HugeTLB: registered 1.00 GiB page size, pre-allocated 0 pages
>> HugeTLB: 0 KiB vmemmap can be freed for a 1.00 GiB page
>> HugeTLB: registered 64.0 MiB page size, pre-allocated 1 pages
>> HugeTLB: 0 KiB vmemmap can be freed for a 64.0 MiB page
>> HugeTLB: registered 256 MiB page size, pre-allocated 1 pages
>> HugeTLB: 0 KiB vmemmap can be freed for a 256 MiB page
>> HugeTLB: registered 4.00 MiB page size, pre-allocated 0 pages
>> HugeTLB: 0 KiB vmemmap can be freed for a 4.00 MiB page
>> HugeTLB: registered 16.0 MiB page size, pre-allocated 0 pages
>> HugeTLB: 0 KiB vmemmap can be freed for a 16.0 MiB page
> 
> I think it's a violation of CONFIG_ARCH_HAS_GIGANTIC_PAGE. The existing 
> folio_dump() code would not handle it correctly as well.

I'm trying to dig into history and when looking at commit 4eb0716e868e 
("hugetlb: allow to free gigantic pages regardless of the 
configuration") I understand that CONFIG_ARCH_HAS_GIGANTIC_PAGE is 
needed to be able to allocate gigantic pages at runtime. It is not 
needed to reserve gigantic pages at boottime.

What am I missing ?

> 
> See how snapshot_page() uses MAX_FOLIO_NR_PAGES.
> 



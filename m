Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6403CCD187
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 08:04:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39E838E006A; Thu,  9 Oct 2025 04:04:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 354788E0002; Thu,  9 Oct 2025 04:04:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 264658E006A; Thu,  9 Oct 2025 04:04:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 12D238E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 04:04:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9FCD2882B1
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 08:04:40 +0000 (UTC)
X-FDA: 83977839120.10.9A046E1
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6B5B51C000F
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 08:04:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf20.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759997078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xbw+RhCM/KhKNE+NeIDOVsuF3+v6zQfqYVSxtVn6guE=;
	b=Csih3JtFHqaG3oWDsRR23kCRe8PO3YPJ3COxJ5RuqLUnveSOfnoRQ+5avL93093UaA4qb4
	lOM5sH2vqhKQg4FFX1QNTM7RPOSxAOpjf0fcFAErirC73hWX6VIqlPMYwFrylIHSDbuRNT
	uYS6eWgU751bdFxhYSmczzNpRmulgrM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf20.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759997078; a=rsa-sha256;
	cv=none;
	b=N3LewYoq9K3OGeEsXxIOX8su2PwLL5baf3PsxioXCfE+AvzfjqUbM4WQfvboWx7zrlIkIC
	TqKG4UjhM3bxXfZ+V6Tvckj+odm5FCKYFJO53jxpZKXv9k2xLvasxPKyXGD+YcKEZott7r
	fORszGiSljBgHAKKtFGVAvKPmnaB48Y=
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4cj2Td0Mj6z9sSL;
	Thu,  9 Oct 2025 10:04:37 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qQ36Dhni13kk; Thu,  9 Oct 2025 10:04:36 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4cj2Tc5kJ8z9sSC;
	Thu,  9 Oct 2025 10:04:36 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id A8FDF8B770;
	Thu,  9 Oct 2025 10:04:36 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id CnXkw3FAfnqR; Thu,  9 Oct 2025 10:04:36 +0200 (CEST)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id AE04F8B76D;
	Thu,  9 Oct 2025 10:04:34 +0200 (CEST)
Message-ID: <faf62f20-8844-42a0-a7a7-846d8ead0622@csgroup.eu>
Date: Thu, 9 Oct 2025 10:04:34 +0200
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
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <d3fc12d4-0b59-4b1f-bb5c-13189a01e13d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6B5B51C000F
X-Stat-Signature: g65kw6f6u98k1sk6uds3yxoqnuwrhiea
X-Rspam-User: 
X-HE-Tag: 1759997078-712261
X-HE-Meta: U2FsdGVkX19yXSWc1zcW4mXo+6hXFDDbdQ0AiVbuHVMfZV9Wko7YUDqhLb0zQhgXcGEDrs8CT4RYSIsuCNb+eLPDcWZCfSP+SR0mgT44V/7585mX6bvV9ctgCTadQYKVC2DUElK2NKm/Fa0ZzNApJa9U8RKsBTZGmuxrgO4tu9xpbIcHYMwP63sGFSCXd16LH10Y6gs9lrtoyV+ohjQJvxQPw8P8geJEjacAP/tQfy5FV9PbI9VdNfj2z9SBhW8h0eWSMbM34K8MF9KA0H1/NvY6j3/ibwMZkPm9LFfHATsSMWBzIc2Cjtz50HBt4jRt91DUCS136CSMvPltLId25rNOTDEuHERfOD774xgSGbUhTe9XRw0h177JUP/x4TiXp7HEq6I/jrVtjSzfv/38iQnfMAkytfY4ENtMuED82kzTouUZsuMG2WwCJVhFCjGk1mRmZ6mS2QmQX708le8C0wQ6zQ/pATsPIVZBtRSxm0HcrU7glg6LGQ3p29Z9R5KK5RLy8lwImY6iQovGJiPRUBmiz6fsihHEt7juRXQygaGwhuKCd7qkK9eBxmGBxJSAJ39DR1U2tUpRZEEyjabbs9yHl//3K9CxTOK21tPysrSzms5eaA2iTTKuckehCQkMR93BovZiFd/GSldX1uLuAImeOrvR4ThiYM06coA3YPtYtIcLWnJgtfQI0HzSB8LKbOVB3DTg6ELd8nyRU819S+MsIOeX/CNqc4/J6hiH+exum4Wm4qF/1/GobC9l9pD+bO3kOOG/DxqtYWlB3OCQk5yVVU4nZJ2vZ0piRhtX5Zn86ypXuAceS81SV2R9nFIsol5HE8p4M/u+HeCzgDzdKozczonRtQDvTtgGmrkjVpMH4dsO0FAfpTJMgk+zUtovE8kSYHHCwv7SrYun9w2Rq2ci2PCwlN0vMgmgPQvEsiVDKk58aoAaYgDz3G6uU3wxpBlujYFJgZiCwx1S6xN
 +8jzSaJE
 WpGtnlabWcS+5FwYNmnfzMj8LCjQmWeL344+1TkjDxNSii7bgRI4Jxtx0t3qwIUCiGp5OC5J6u29JZ9tYT6Ezvdo4sfUscUDkTJFrL9HZovR2OpBByTV1hiyUT7fs5E2CiQjcN2NvTykbonx5R72lUGlnP8A5zWr7qyieqY0yif/Kx69xz/emdJKWUjCqL3MnWN1Z85Bs0c3S7F+Ga0y4dQovdPIgiqDE8EgH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 09/10/2025 à 09:22, David Hildenbrand a écrit :
> On 09.10.25 09:14, Christophe Leroy wrote:
>> Hi David,
>>
>> Le 01/09/2025 à 17:03, David Hildenbrand a écrit :
>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>> index 1e777cc51ad04..d3542e92a712e 100644
>>> --- a/mm/hugetlb.c
>>> +++ b/mm/hugetlb.c
>>> @@ -4657,6 +4657,7 @@ static int __init hugetlb_init(void)
>>>        BUILD_BUG_ON(sizeof_field(struct page, private) * BITS_PER_BYTE <
>>>                __NR_HPAGEFLAGS);
>>> +    BUILD_BUG_ON_INVALID(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
>>>        if (!hugepages_supported()) {
>>>            if (hugetlb_max_hstate || default_hstate_max_huge_pages)
>>> @@ -4740,6 +4741,7 @@ void __init hugetlb_add_hstate(unsigned int order)
>>>        }
>>>        BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
>>>        BUG_ON(order < order_base_2(__NR_USED_SUBPAGE));
>>> +    WARN_ON(order > MAX_FOLIO_ORDER);
>>>        h = &hstates[hugetlb_max_hstate++];
>>>        __mutex_init(&h->resize_lock, "resize mutex", &h->resize_key);
>>>        h->order = order;
> 
> We end up registering hugetlb folios that are bigger than 
> MAX_FOLIO_ORDER. So we have to figure out how a config can trigger that 
> (and if we have to support that).
> 

MAX_FOLIO_ORDER is defined as:

#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
#define MAX_FOLIO_ORDER		PUD_ORDER
#else
#define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
#endif

MAX_PAGE_ORDER is the limit for dynamic creation of hugepages via 
/sys/kernel/mm/hugepages/ but bigger pages can be created at boottime 
with kernel boot parameters without CONFIG_ARCH_HAS_GIGANTIC_PAGE:

   hugepagesz=64m hugepages=1 hugepagesz=256m hugepages=1

Gives:

HugeTLB: registered 1.00 GiB page size, pre-allocated 0 pages
HugeTLB: 0 KiB vmemmap can be freed for a 1.00 GiB page
HugeTLB: registered 64.0 MiB page size, pre-allocated 1 pages
HugeTLB: 0 KiB vmemmap can be freed for a 64.0 MiB page
HugeTLB: registered 256 MiB page size, pre-allocated 1 pages
HugeTLB: 0 KiB vmemmap can be freed for a 256 MiB page
HugeTLB: registered 4.00 MiB page size, pre-allocated 0 pages
HugeTLB: 0 KiB vmemmap can be freed for a 4.00 MiB page
HugeTLB: registered 16.0 MiB page size, pre-allocated 0 pages
HugeTLB: 0 KiB vmemmap can be freed for a 16.0 MiB page


Christophe


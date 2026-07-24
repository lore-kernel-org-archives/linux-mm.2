Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CA0BC53200
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 16:23:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 529356B0088; Fri, 24 Jul 2026 12:23:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 500D26B008A; Fri, 24 Jul 2026 12:23:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F0276B008C; Fri, 24 Jul 2026 12:23:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18A656B0088
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:23:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 914A780465
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:23:00 +0000 (UTC)
X-FDA: 85024189320.12.C45D3F6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7343920005
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:22:58 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iUC98dpb;
	spf=pass (imf31.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784910178;
	b=g1BMys9+eARMCTkoqwDrceW9icAlPYdRUSxOEnQfwwuuLgrKieJXOEMqR9jwFD6M4ZY3s0
	gFx19HbL/endXFQNGixptMQDw3EfCm1d72TTBwH5OBKV4njzPJAAFStzeovWklg4rEA+yX
	hzxiCUHOrrb2ZQXY/OZw3wInbJNLm0Y=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iUC98dpb;
	spf=pass (imf31.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784910178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R4roeXRjJcUf/JwCqMmQlNS5gCdrtAP9Td7ApgTux+8=;
	b=YG3JfYWygHLuEVvVGR0a3Ai5ryd1yuUSFTvx4Mn6rN7akiCVqI5TZNJNaJ2rPVq1PMAyXF
	DNH0ABZlKXq5LpqylEMyLzTohFB2hCBleOY06KBLH8AMIKWY0g9+Jv1WHlHUYOquEnhwEm
	ErsPdNQcWWS4bFl0dQiLGvV5gKdpWqE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 930E91684;
	Fri, 24 Jul 2026 09:22:52 -0700 (PDT)
Received: from [10.57.0.90] (unknown [10.57.0.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0C7F03F66F;
	Fri, 24 Jul 2026 09:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784910176; bh=C02uWs/fpXnABbH43y4jX8fXPGtwBqhc0kWtZDPeayg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iUC98dpbFgd+i9SnSkYL0GKvWGOk7xpTRmX2UXYjyfh9B/6bLE/WuAx7CloLocREN
	 hl9aaz1HKjYAaCZbwP0FbaUIknYs8KANk5nrYXdBG0Da9JXUPnYnhocq3QUWcdY9Et
	 OVQZdbXfa8qUjKcrVhyZR4pIQLBjcpiml/L4ONBo=
Message-ID: <d312f635-7c34-4452-b879-d29137a7f450@arm.com>
Date: Fri, 24 Jul 2026 18:22:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/22] mm: use mm_is_kernel() in generic page table code
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org,
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-s390@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>,
 x86@kernel.org, tboot-devel@lists.sourceforge.net,
 Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org,
 Vishal Moola <vishal.moola@gmail.com>, Alistair Popple <apopple@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
 <20260714-remove_pgtable_cdtor-v1-4-44be8a7685d7@arm.com>
 <02565237-d777-4c63-8b17-817df59feac4@arm.com>
 <0d75daa4-a034-4094-bce5-57938d294163@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <0d75daa4-a034-4094-bce5-57938d294163@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7343920005
X-Stat-Signature: fba1zihxguu4s948azah3frcgcwda4yg
X-Rspam-User: 
X-HE-Tag: 1784910178-25731
X-HE-Meta: U2FsdGVkX1+NWerHwtl85X12zXVRAsChITymAQ8F4jHothk7uXUJ/NFWpXrQQnOq0bsgKcNwhiDZoQcjq8hukNZbhrHzfibsY30GfdcPEk2xtwBDJYLqxQK6yrfn9qmsdk++hOAinbTw1hTvHonmODJVz2t7FxWFOpMw32JETsbJWkMsQXnpzTbY32RiLAuWM3DnPQoTN49eGDNAOktFNXBuA16gkUXP5D8mcnTDdAO2YVe6aPt9e/+ohrCqkP/15/jXzt87UgNRZ31TkgCmZmP2bbu2hgZu1LNTj2wFFib+qKobyOeHnSqGD9ZJGN1h4M5b4srrAW2m/4je73Jo5XkOXseP1WYJTAqp9COSy4KWOvWj82zZXGfe5OWqezAXJyLOdFJpXtTz/WI9fxRnNTNTAWa9hAPihSkqdeQCLX85z0THOD7fODO3wOZclJQkHCN9JJvZQGzX0UwgOmMkvrNFtegXDuw3bKOsGTbvDmH2reZM4qR9iAOfeUPzoFw4CcY6HCThL9/RIqSKBX9jwKvAghSlmJzOej9dcZa2nADsLvbtDH7+dBgaNiHsY6QgC4Kg23bLw/ZnU5cFoQh0b24i92YgsilwQ76B3wjoxkjXnXBTj+fEpHeTX9t6Gk2uz9omU13YNFkHjx4G3AwBm+2xCHXCbwV14yAja/MPnRHm4iQgjd+GlA6yOgGxEu1LCB/Fc0f8llUQsL1lwkKUwuTLVjmouLEK8ShHYKQcxfRdJ5TWeswQAmddT6DDi0Z3VaBnG8amW5vwZoBUc4Cey0ikE/0XCXUkUkdSqrFiyAsvQ689GBOZN0ypH38DnrdnpQIMux8RJVuJjWpmD9+T7FzL/ZtnDmz+YGhObH+YMrrf+T7feYFEsXXrouLiDuGoXfTcPsaRiO/FAERzkMT6dBT0l1KtnilkNmCVOwUSsc9DZGPKe9At9Jea4coh04VOfIlVFVl+RmP4mjWiG2B
 kMo9DeuQ
 jXXOYWAI48fWg180ehwM4962yagrVKJ08RsGsoxwgMVr22W4SOfdZ/PIB46nxCC+yk5Q/3+0313QJE0WanIxfmmssYzqKYJr57eM1iK7FHcUBfc9FXT1/n6diyLjspgvFlkvzSIVWGWLH9JrWJUgjxFoO2OvqwYE1lp4ps6yz5D60XbldWp115OiB1KZ68lC/OG0cyFL2cw6X96P3K1TKu2fRz56RdlbQQjjEL3VyP+NqTlrYi2CYuKLD2pdwUzTEoMN5/idDgOf88uKlWGmzP3yFsIBY8l+dtuod/OOFIDKx4/zOkX01QquPtqoaFt+khXzPyF4SgUtj/Kf9Rkh9MoRfd3S+L3PtLmaE8+yQpIc7Sa0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21/07/2026 17:07, David Hildenbrand (Arm) wrote:
> On 7/16/26 11:35, Kevin Brodsky wrote:
>> On 14/07/2026 16:03, Kevin Brodsky wrote:
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index d5e87624f692..c0244c0b0756 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -3394,13 +3394,13 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
>>>  	spinlock_t *ptl;
>>>  
>>>  	if (create) {
>>> - mapped_pte = pte = (mm == &init_mm) ?
>>> + mapped_pte = pte = mm_is_kernel(mm) ?
>>>  			pte_alloc_kernel_track(pmd, addr, mask) :
>>>  			pte_alloc_map_lock(mm, pmd, addr, &ptl);
>> As noted by Sashiko, this is a little problematic because if
>> apply_to_page_range() is called on efi_mm, then we will end up with
>> __pte_alloc_kernel() taking the init_mm lock, since that's hardcoded.
>>
>> That probably means we should pass the mm to __pte_alloc_kernel().
> Agreed.
>
> I guess we have to audit all existing init_mm usage?

Indeed, I looked through comparisons with &init_mm but really all
references to init_mm should be checked. Will do for v2.

- Kevin


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84A15C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:32:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85BC56B0136; Thu, 16 Jul 2026 11:32:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 834B06B013E; Thu, 16 Jul 2026 11:32:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7705D6B013F; Thu, 16 Jul 2026 11:32:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 219B36B0136
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:32:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0BD33120114
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:44:07 +0000 (UTC)
X-FDA: 84994304934.16.EB61A64
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf06.hostedemail.com (Postfix) with ESMTP id 410C7180007
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:44:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=MSTbwqnb;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf06.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784198645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4NOe5ksl2vlSwjo56KjbWsmML1a42hyFiwBD/c9eZDU=;
	b=B0mH2GP4G5JzwOQj123+W9F+m4C2Ep2DJn29pyYg94v3kJiA1z33vJ1sg2NGmmJfOGqcxX
	Zl/gToSxdDgu1maUd+Mc4sz8i7oVGZHbnnaIeUBXySlpWFR5UxWXbBfuJLdr/Z5L6tMUZ7
	3XGnUXB5uSp37/oFc0oQzUCBPIRjKBI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=MSTbwqnb;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf06.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784198645;
	b=qr8fFPthEVv5PPVQ0Suagai/xlcCYtnNpV7/TSwmtRbh+SvG3ieBnrR8AF2jsb/eEtr1z5
	afel6Jw+RXISRNUsmUdmboLu5WOQ6/tdlyn9rNLOEOhqQKShbRnnDVUAjqXFpvYETpH7Ek
	bsH2AYOv5DHOfi/sqJ4bG1lG+cK+erU=
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260716104401euoutp0162896187b46659a20abee1581481c5cc~CvzYh7gBq1199711997euoutp01Z;
	Thu, 16 Jul 2026 10:44:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260716104401euoutp0162896187b46659a20abee1581481c5cc~CvzYh7gBq1199711997euoutp01Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1784198641;
	bh=4NOe5ksl2vlSwjo56KjbWsmML1a42hyFiwBD/c9eZDU=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=MSTbwqnbrDKyLKGraNwvsA+y4j51U4MbSsUqWrLD7zYBuseQk2jHYvQzKWIBHlqF3
	 POTrMf4g8ZRPRjBC3B//DjIkSnL2hCqPkA9P1ECuexq2YdaXf+5B3xWtrCF/91gL8O
	 xIohKEswRPMt4SaVihbMOLSt8JqgZ1C22LyTuDUo=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260716104401eucas1p1f2c155f5f3a4655c82e831bffdeeece7~CvzYOfJRQ0283202832eucas1p1K;
	Thu, 16 Jul 2026 10:44:01 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260716104357eusmtip2cc624be619bcd0856727825883ac67e0~CvzVIUrCg2851928519eusmtip2d;
	Thu, 16 Jul 2026 10:43:57 +0000 (GMT)
Message-ID: <1eec88e6-1ea8-4525-bb17-e41444d715dc@samsung.com>
Date: Thu, 16 Jul 2026 12:43:56 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v3 06/11] mm/cma: Allow dynamically creating CMA areas
To: Thierry Reding <thierry.reding@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Rob Herring
	<robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
	<conor+dt@kernel.org>, Jonathan Hunter <jonathanh@nvidia.com>, Mikko
	Perttunen <mperttunen@nvidia.com>, Yury Norov <yury.norov@gmail.com>, Rasmus
	Villemoes <linux@rasmusvillemoes.dk>, Russell King <linux@armlinux.org.uk>,
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer
	<gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily
	Gorbik <gor@linux.ibm.com>, Christian Borntraeger
	<borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Andrew
	Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike
	Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
	Hocko <mhocko@suse.com>, Robin Murphy <robin.murphy@arm.com>, Sumit Semwal
	<sumit.semwal@linaro.org>, Benjamin Gaignard
	<benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>,
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, Steven Rostedt
	<rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
	Desnoyers <mathieu.desnoyers@efficios.com>, Catalin Marinas
	<catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org, linux-trace-kernel@vger.kernel.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <ak_E4UxfnFJywJa7@orome>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260716104401eucas1p1f2c155f5f3a4655c82e831bffdeeece7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260701160902eucas1p1214af933ba0f54b85630a3a4e5a4689c
X-EPHeader: CA
X-CMS-RootMailID: 20260701160902eucas1p1214af933ba0f54b85630a3a4e5a4689c
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
	<CGME20260701160902eucas1p1214af933ba0f54b85630a3a4e5a4689c@eucas1p1.samsung.com>
	<20260701-tegra-vpr-v3-6-d80f7b871bb4@nvidia.com>
	<3f47aeab-33b1-4966-a5ce-5d6d5261e0e2@samsung.com>
	<e212caac-6c30-448a-9e10-32fff8b842f6@kernel.org>
	<83e5e74d-7106-4e14-9d10-56438372f6a3@samsung.com> <ak_E4UxfnFJywJa7@orome>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 410C7180007
X-Stat-Signature: 8or3bmfihpfk5wkxe9gauwz8k8yinah4
X-HE-Tag: 1784198644-303210
X-HE-Meta: U2FsdGVkX1+KpIQOnBmM1Bz0tkRbZTXS4wKwtn2X1sUVRiXJJekB6KCh7NIflUp/lq9fPXozZOGUcX/rEnSDO6JEZrkBgYPB8hcS+eL331m6ZjVHqPJr6nxVTRagDIWobzuveRGNosH4kvUgcZT+1wc86liRW5urqS/Rw0oUT0x+hiBHC4UJULc7s8vRc/oEp6DgNS4zpMvZahH+t8seOPa33OVX0YB/PqgE3PyL7OulBcWNwwR4PbnnYk2BCjpXnmfdoaRDA176Gu8HAYKt9oh9isSWjaH3Ge8QH9Mn/E2XYrOJkdj3iQZzN2VWbn0OmoKUhtCGevW2G1zdaG/xupjNtWx+k5ZPjIt1c2xKMWRblH/W/4GgtnYvxA7Pcsb9cp6c/V1/O9dOX3ZWkX0BjcNXazE75UYwo9UmKKCX7RMIN72Ya41wEZLDujbeg1MYmMhx4yhXEQkfY0VOn2E7VTPeECqwrHlCxDn7byXMryUhrA36u6NtW+EOY0Yr8hISvHWwV7ShE6qrZvXyiuVEnHIEDIS/ce9davM8ZHEHIvyHwvyXfYIDUvY5HrEJtE3O3hqc6Gx0dT2zBcOsjmVHlb4zs/jMV5PnTJqB4V/Bi2BwE/q1tMFiD3XxsMIBNwYJzQ6K8m+WZ/L0NXsjBRPiwzV70xWXeZeez55foIOk3dm/PlwzUxactrW0GM8Cps0Q8MpOtqjkKZOeAMe7DHhdF8Muz8XrUlWgrna6hX3Pj+7FKOrDNrBba4vlqRpYtXDK6jfBSMngPJQKO15NNxnYk4LiU7H6glYvH9tROgFk3NICJ/bePvrl47RchbMO1WbUAVmgqi7Gy2ctsYnobOkEc6livMPP4fmyVJYmygef6AjSODERr7ADV+0gpa6BZ+iPaWhVr/zx5onBrulA03jzdrBfyucLhmWAVsVnSeEugT6SN7jCSspiBtUht7gkX6i7bLsVSNc1Z+NzxVd8G8K
 9MwIHsjz
 10B3rtbTNdi7hm5j5r7Ntd/zR1NlcFDExgN0AWsZEUUzBm4viYVa90OaK+Zy2cFscDHfZnizhrXfInHblbmxrdJAk56DJLXBBn7ie+1KLLnPuzUXQqONdfnP27f/Tr8/TamGsbiN5vmT32W9xAROJwVDmSbwcBXDi6Z3bRwjvGhYZXVc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.07.2026 17:59, Thierry Reding wrote:
> On Thu, Jul 09, 2026 at 07:56:45AM +0200, Marek Szyprowski wrote:
>> On 08.07.2026 10:35, David Hildenbrand (Arm) wrote:
>>> On 7/7/26 12:02, Marek Szyprowski wrote:
>>>> On 01.07.2026 18:08, Thierry Reding wrote:
>>>>> From: Thierry Reding <treding@nvidia.com>
>>>>>
>>>>> There is no technical reason why there should be a limited number of CMA
>>>>> regions, so extract some code into helpers and use them to create extra
>>>>> functions (cma_create() and cma_free()) that allow creating and freeing,
>>>>> respectively, CMA regions dynamically at runtime.
>>>> Well, the technical reason for not creating cma regions dynamically at
>>>> runtime is that on some architectures (like 32bit ARM) the early fixup
>>>> for the region is needed to make it functional for DMA.
>>> Can you point me at the code that does that? Thanks!
>> Check dma_contiguous_early_fixup() and dma_contiguous_remap() in 
>> arch/arm/mm/dma-mapping.c. Those functions ensures that the CPU mappings for
>> the CMA reserved region in linear map are remapped with 4k pages instead
>> of the 1M sections, so later, it will be possible to alter the mappings and
>> change them to coherent when needed (altering 1M sections is not possible,
>> because each process has it's own level-1 array even for the kernel linear
>> mapping).
>>
>>
>>
>> However, in the use case in this patchset the reserved region is only shared
>> with buddy allocator by using the CMA infrastructure, not registered to the
>> regular DMA-mapping API, so it would work fine. I'm not convinced that this
>> is the right API to use for this though.
> Are you saying you're not convinced that CMA is the right API to use for
> this? Or something else?
I read this again and indeed CMA seems to be right solution. I only wonder
why do You want to create the CMA areas dynamically? Imho it would work if
You just create large enough CMA area on boot, what would automatically
share the memory with buddy allocator and then allocate dynamic VPR regions
with cma_alloc(), potentially unmapping or marking the allocated region as
reserved in linear kernel mapping to avoid any potential speculative access
to the protected memory.

In both cases You will probably won't need the DMA-mapping API on top of
it, although it might be even possible to partially use with by
registering custom dma_ops for the devices using the protected region
(assuming that it would support only DMA_ATTR_NO_KERNEL_MAPPING
allocations).


> I certainly don't think we want to get the DMA-mapping API involved for
> this because that always implies that we perform cache operations, which
> we specifically don't want for this memory.
>
> Thierry

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland



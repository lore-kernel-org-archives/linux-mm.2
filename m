Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2162BC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 12:15:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12A986B0005; Tue,  7 Jul 2026 08:15:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B4726B00B0; Tue,  7 Jul 2026 08:15:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE79A6B00B1; Tue,  7 Jul 2026 08:15:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2FD96B00AF
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:15:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3AA968DE35
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:15:45 +0000 (UTC)
X-FDA: 84961876650.02.CE6954B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3CBD5C000F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:15:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TNdO5d+U;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783426543;
	b=wgMu32+6QtjeLFj6DvjlnaY36b/Q6+k16Qb0vYdwqfuV7XxQjKuXslY3ywYyOCu3dniaHL
	ZZGS3SJDdWDHNTa0Xo2icSqWwyHHNa0dg0zb64ZppM8fz+syr279BBnYkF6o21Qo92g9pq
	ONrfZBKRt/IehwCiD+v6S14D6pCfye4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TNdO5d+U;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783426543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ocKywctjcQY25SSdQ6hQvbTazrPnSijqlNNP7l8IjAM=;
	b=xG6P56GcbIBJ9orWbISgMHNbXA1GPrNIc19ylPDg+dchmisiMBFJzFpaC8PMgpthufPg73
	q/dcRxMc3sF50kfRhp9U2ReZf4gmZ1Y3OKQF9F9uF7LZzZGI69xN8hwM0susqMcRWobMPU
	Ev9p1BzUhJglAoZnhUl71bzGcEAYzi8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1AE0B25DD;
	Tue,  7 Jul 2026 05:15:38 -0700 (PDT)
Received: from [10.2.212.23] (e121345-lin.cambridge.arm.com [10.2.212.23])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1FA373F7B4;
	Tue,  7 Jul 2026 05:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783426542; bh=K/4UxBvoLplwP1TnbzWxw3/3TsMxIZDXrC28TvWcMiE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TNdO5d+UTUqiaO2n0m215MtyUHnlvQDgBMAikIE37JFWL924/I6kpflUa5nFhYyke
	 k+JcMLhIlAQbvHvBkEF4SPEAGvyeDpBoepuFrUOEUOC3Cd0e8k86lrEkmzUih1Xbfx
	 dpcXyStBrZwJKsn8m45phGgiYaBsgjGXU6H92Tfs=
Message-ID: <7d969be1-244b-4ff7-a5d4-b20da09f5488@arm.com>
Date: Tue, 7 Jul 2026 13:15:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/11] arm64/mm: Add set_memory_device() and
 set_memory_normal()
To: Thierry Reding <thierry.reding@kernel.org>, Will Deacon <will@kernel.org>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Jonathan Hunter <jonathanh@nvidia.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Sowjanya Komatineni <skomatineni@nvidia.com>,
 Luca Ceresoli <luca.ceresoli@bootlin.com>,
 Mikko Perttunen <mperttunen@nvidia.com>, Yury Norov <yury.norov@gmail.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 Russell King <linux@armlinux.org.uk>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 "T.J. Mercier" <tjmercier@google.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org,
 linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-mm@kvack.org, iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org,
 linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
 Chun Ng <chunn@nvidia.com>
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
 <20260701-tegra-vpr-v3-4-d80f7b871bb4@nvidia.com>
 <akYs91INHMXMTI-t@willie-the-truck> <akZkuwktaXFTrASP@orome>
 <akaSJ5D98w2cHqb6@orome> <akftuw9NyRy36fXA@willie-the-truck>
 <akuvyu1Pq0ZVMZV0@orome>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <akuvyu1Pq0ZVMZV0@orome>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3CBD5C000F
X-Rspam-User: 
X-Stat-Signature: njkkstnmwdxe4h3a4ortgpcnosfknmgq
X-Rspamd-Server: rspam03
X-HE-Tag: 1783426543-74635
X-HE-Meta: U2FsdGVkX19B/jpoJlJn/+YJzok+hH6dx3GaqDMcfcrFzB3jOF74B5ET6bTAurKXEl6ZA/faQH2gkABJ3CaBMLem/8iWMA6jDb2M8QJKwqDYbZM9Rc+calh3mBGVGW5BZ3vDKlA9htXyXcKGJTMcj9fQLbl+Y2Yv3PGgi17t9d0myTOm5wWkyQQwBj+tST4YwdjO+sgryFzP/vFgWTNBziojkBIvI2RFWWp9+OHcpUR4zKrPeYw7bgXtdDaqHS3Bm5EG+SON/2SJGjSIxc3lnmlYctizp2VERIl+ueW+z+24AYWpe4eXoRYCZnakumercstnJH5Fmruyt54ViOVU8p0IM/Cs2fCAV6rrzoenc5A6yL6Lbi5MKaWPbB13jUqdK2RDXNmpo6Xh4N7gtuI5KayXmVfsPNGxpMJaEHAwx5xsld2emATkqQxRLWzdjJTovEHA54NHN0tfsk9b1Vttzt5TmdFSAlA7tnz1eDa5ah5IgQLwhygCsf9BzpYJUUakpdQ+Lt1FOBQEW2glWG1HKV6vWjuZSMKALVxpk23dAoGdxWe5zMeUlhNbdxW/8sItukH/fLxNzIqatwHPHm0Be6Y89a8tgH8IeJQB0z+3zfZKv5EfjATpGBuxckuDns0jLZBSQD2m2LTxl6oip87al4dksY2UeSY/q0QLIX0532oGF9zeDa8Cpe93g+iCRfjo/eZEJ2gFa8JA54lqc22nlCSXIIuMRljj6GZ63k03lF9i2Qk8iRF2DQhUu1UHTvbYyImoFLsMjrVSmS0Uqz524lBr1hQU4b/UBGjWNllEwAesJdx7QVAsdVQscV1Ze8BlVtZp3cAsrTMyABVTK3xVopwPm76uR14dLkqsNyEGJiPcK7xmtiEbZ/eGGgTnbUzESe8DrhK2MSxSC+gRD2MWgBpJ51ay3lAboiZjsTBywLILUlrpEXibAqBQ+pqDn9aA4jiyU74SEq4PHMGHU/1
 cfpliw8y
 Baao4PSMGlTh4uC3fpm+yAjSMf+cTj5cEa/HcvjDz3MMgXXoElJe7l5Zl7DEnQh/yv11FctoTq+gYFTQBmXJGQxoLfLYkDd0EIbkkE3zljtlB0vIcym8Aiy/E6ZdqYRinqmq8A3fd3s60Ded5IyXlSOj7/bql8mF4ymWk3upjOBK4+ziuHx0fC/aIJZ6aNf/AwT0/5n1pMdWQ0IvIoBeoxtHdG5Jhg4gucyw+Xhg57x0FrCbOkWvhMKOGo+4cz09s7Is0H8tgorhSevSrzvV3EEb9teMuhP0fVRiJZV/wnBRnCBZGQ8VgwR11J5jLmq5eQsU4K05CpFWpO3BWSY8I++dS0XOIfRSiLL7YXYG7lMXRjzb6sowDD9CnaRQva1k6G0kytWGTRi1I9kd8KlztBJpRGNc9Gd4z6iRqE4y+xQfevkTwwfo4Gyg7hT/cI5fuekZ0zMExSgmFvRlai/+IDHYB5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/07/2026 2:49 pm, Thierry Reding wrote:
> On Fri, Jul 03, 2026 at 06:13:31PM +0100, Will Deacon wrote:
>> On Thu, Jul 02, 2026 at 06:41:23PM +0200, Thierry Reding wrote:
>>> On Thu, Jul 02, 2026 at 03:46:44PM +0200, Thierry Reding wrote:
>>>> On Thu, Jul 02, 2026 at 10:18:47AM +0100, Will Deacon wrote:
>>>>> On Wed, Jul 01, 2026 at 06:08:15PM +0200, Thierry Reding wrote:
>>>>>> From: Chun Ng <chunn@nvidia.com>
>>>>>>
>>>>>> Add helpers to swap PROT_NORMAL and PROT_DEVICE_nGnRnE protection bits
>>>>>> on a kernel-linear-map range.
>>>>>
>>>>> That sounds like a really terrible idea. Why is this necessary and how
>>>>> does it interact with things like load_unaligned_zeropad()?
>>>>
>>>> This is necessary because once the memory controller has walled off the
>>>> new memory region the CPU must not access it under any circumstances or
>>>> it'll cause the CPU to lock up (I think technically it'll hit an SError
>>>> but in practice that just means it'll freeze, as far as I can tell).
>>>>
>>>> Probably doesn't interact well at all with load_unaligned_zeropad().
>>>>
>>>>> I think you should unmap the memory from the linear map and memremap()
>>>>> it instead.
>>>>
>>>> Given that the memory can never be accessed by the CPU after the memory
>>>> controller locks it down, I don't think we'll even need memremap(). The
>>>> only thing we really need is the sg_table we hand out via the DMA BUFs
>>>> so that they can be used by device drivers to program their DMA engines
>>>> internally.
>>>>
>>>> Looking through some of the architecture code around this, shouldn't we
>>>> simply be using set_memory_encrypted() and set_memory_decrypted() for
>>>> this? While they might've been created for slightly other use-cases,
>>>> they seem to be doing exactly what we want (i.e. remove the page range
>>>> from the linear mapping and flushing it, or restoring the valid bit and
>>>> standard permissions, respectively).
>>>
>>> Ah... I guess we can't do it because we're not in a realm world and so
>>> the early checks in __set_memory_enc_dec() would return early and turn
>>> it into a no-op.
>>>
>>> How about if I extract a common helper and provide set_memory_p() and
>>> set_memory_np() in terms of those. Those are available on x86 and
>>> PowerPC as well, so fairly standard. I suppose at that point we're
>>> closer to set_memory_valid().
>>
>> Why not just call set_direct_map_invalid_noflush() +
>> flush_tlb_kernel_range() for each page? We already have APIs for this.
> 
> Having a "standard" helper with a fixed and documented purposed seemed
> like a preferable approach for this particular case. We also may want to
> make the driver that uses this buildable as a module, in which case we'd
> need to export these rather low-level APIs. And then there's also the
> fact that we typically call this on a rather large region of memory
> (usually something like 512 MiB), so doing it page-by-page is rather
> suboptimal.
> 
>> The big challenge I see with any linear map manipulation, however, is
>> that it will rely on can_set_direct_map() which likely means you need to
>> give up some performance and/or security to make this work. Does memory
>> become inaccesible dynamically at runtime? If not, the best bet would
>> be to describe it as a carveout in the DT and mark it as "no-map" so
>> we avoid mapping it in the first place.
> 
> VPR exists in two modes: static and resizable. For static VPR we do
> exactly that: describe it as carveout in DT with no-map and deal with it
> accordingly in the driver. Resizable VPR is for device that have small
> amounts of RAM. Content-protected video playback will in the worst case
> consume around 1.8 GiB of RAM, so we want to be able to reuse for other
> purposes when VPR is unused on those devices. In that case, the memory
> is also described as a reserved-memory region in DT, but it is marked as
> reusable so that it can be managed by CMA.

OK, so this is dynamic TrustZone, which is essentially identical to CCA 
delegation as far as we're concerned from the Non-Secure side. IIRC 
there was some ongoing talk about explicitly keeping track of the state 
of physical memory ranges in terms of being delegated to CoCo VMs or 
not, so eventually plumbing a "delegated to TEE/other" state through all 
the same mechanisms seems a pretty achievable goal.

For now, though, firstly I'll note we have seen this sort of thing before:

https://lore.kernel.org/dri-devel/20240515112308.10171-1-yong.wu@mediatek.com/

although that didn't seem to need explicit unmapping (likely it involved 
a TrustZone controller that just made NS accesses RAZ/WI instead of 
external-aborting).

If you want to be nice and start trying to build the general abstraction 
for this, then as a first step I'd suggest following the shape of the 
current CCA machinery - build a "delegate to TEE" operation around the 
existing set_memory_valid() paradigm[1] with can_set_direct_map() 
safeguards, and have something like a have_dynamic_tz() that echoes 
is_realm_world() in terms of being set at boot when one of these regions 
is detected by the early reserved-memory parsing, then considered in 
force_pte_mapping() (such that it only matters if BBML3 doesn't already 
have us covered).

Thanks,
Robin.


[1] Personally I'd be inclined to stay away from set_memory_*crypted() 
until that mess gets sorted out properly, but the argument could also be 
made the other way that the "delegated" state is currently mixed up in 
"encrypted", so technically it wouldn't be entirely inaccurate to use, 
it would just mean that we're intentionally adding more to that cleanup 
effort. For now it seems nicer to me to keep a distinct "made invalid 
(due to delegation)" state that can eventually converge into a proper 
"delegated" state once that exists, rather than get mixed up in the 
current 
guest-shared/guest-private/host-shared/host-private/host-delegated mess 
most of which is not relevant for non-CoCo uses.

> The resize operation is fairly slow to begin with because we need to
> stall the GPU and put it into reset before the operation, then take it
> out of reset and resume it afterwards.
> 
> What kind of performance impact do you expect?
> 
> Thierry



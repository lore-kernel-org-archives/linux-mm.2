Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2DCAC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:17:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93BFD6B00A0; Tue,  7 Jul 2026 09:17:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 914796B00A1; Tue,  7 Jul 2026 09:17:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82A2B6B00A2; Tue,  7 Jul 2026 09:17:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C8236B00A0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:17:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0C94AA043D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:17:43 +0000 (UTC)
X-FDA: 84962032806.23.AED0784
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id CB53AA0005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:17:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IDNSpqSx;
	spf=pass (imf15.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783430261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bKSouSqNKBqlXAQvTqZj0ZY5ZCFLZ17vIhIy63u37NI=;
	b=eQmaPWNsNqgVMWVjPh4saGdKPVe2JKK6tcUMaI/w8/miB6G2e9gc1z1Qzefj/4mZMUNMKy
	nToFRyFvTSa9cmp49Ds5KU3OGaxx/t0JuqPGsm0pd0t3zqwo/LZAtHKrEp8g5VyIE4/vt/
	MdxiHmoiB5NGgh+Mlm4PWoETDVn2jtk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IDNSpqSx;
	spf=pass (imf15.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783430261;
	b=YZqgRYVaL+QBOefr87uwM28AHNgf9QULM32LSMHJnJMh3peVTKCGqwPT+wRYW9dfaD4MC9
	DRgWmMW8t8+qJtIusstfDHbbomk0LYKg6msiqAGOuL7vwnTALbxOreMMdPmov7CPXQXAnw
	D+SCCncRrbwRVm5ukV6CHJ+4c/YQQ/U=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6918119F6;
	Tue,  7 Jul 2026 06:17:35 -0700 (PDT)
Received: from [10.2.212.23] (e121345-lin.cambridge.arm.com [10.2.212.23])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 555EE3F85F;
	Tue,  7 Jul 2026 06:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783430259; bh=c4sgJIlp41KnfkxKX5Y8adETb3Yp/G6tgwZ1bFzMLxo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IDNSpqSxtFtaWJyxD6ND7bhZDzkCBdR/qNZC+pDBu9MxOTbdwwuRp2qhdJjRMjzk3
	 YysGDLtP2ZnjwNvmBVMkMDiNbKNdfL4YoCvHcQ3PS8DF8iP9OT/GQsdjdnsUlDzODm
	 pVxQUIhnCsc/b3A1PQmyYi7EofZIIfYSBk4wEIKQ=
Message-ID: <b0a1bdd7-46ab-4025-8775-c9273892444e@arm.com>
Date: Tue, 7 Jul 2026 14:17:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/11] arm64/mm: Add set_memory_device() and
 set_memory_normal()
To: Will Deacon <will@kernel.org>, Thierry Reding <thierry.reding@kernel.org>
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
 <akuvyu1Pq0ZVMZV0@orome> <akzikTrmhMsvkNVY@willie-the-truck>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <akzikTrmhMsvkNVY@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CB53AA0005
X-Stat-Signature: jugcmgzacg1zki4bp87hj15xfdj5zni1
X-HE-Tag: 1783430260-642369
X-HE-Meta: U2FsdGVkX18D4dfo04IByDutv+eEgfEkjZ+YGi87J6R3LNGe69Fgo3Z0Pw0pM47P+CmKJvQgWMriu+iEV5jiN5dQGZMOa9qOAigtVnAp0YWylVCO0UoOnx9d0aeLvxIPYwrBHuYw+Qa70THnKU5TQQGtC/yogMYvWE6jFuQ2bhjta8+ohIes/kQsow4dOJaDx3JjNmo+X7zgJoRNyWj7pS8hk2Bu1VpVqtNlE5TCfu02R1yRlts+l1EOoQiszg5qkzeF4uoXSyVgfg0YNuCuObBU7qOSWEHO+ZpotMRA3c32E8VGlkuAcBQuAp9nyLgGcQuz+HQo5GlZMZ4vRBjSaaZgBIybDtSVeDHsGtVg8d52HKpnvZBdE3WXS/gIwR8pmtIJ0idKP/RdTzuyo8f8jstJa+xG/zpD8B3Yoj9l+YURJoGhL0Asq5S2pxzxKM/dWhSabhiyqvTjkfl3aYAHDi6uQrJJxPSO5FXei7aLAbEPc7g+vK+n1Cmal8w2oHDLuDXC2rESY+ZPx8RPvASjDAIK2rG/1gb07eH8GfeDuhmU4wP4X7Tt9rANRkzkgwKg0pFt2aMppi0EEPOTDHz+HpVdiVb0DSOf9RlshptHOHgbzCH9hXQ1ETg9ntq9qwB4D4Afh0lusgp5MvH4QqG4NcKUwjPR5SZ093iwDd4jZJTjsMAxOdnBZZ/DI8mPopyyzQdwrcalwrkiBs6HXJ6bwBCQWNnOAe72yxeN9Kz8S6tqY2ktiiFSDpqq14Y4BxEkHv0VAeNHtvIX1mOdzaeu1H67oaEqKJvgyn3nTVJ3LqDphv/6yejtFrsc49PMntKAMSehhJ4ZQC/8Jdi1XiuJ1fjTD4JpAMHP1h5fvlaaq/5s3bTvPRgtxmyV/p0u9r0cQf8bHC4XvXiLFndboV+knU6igObPNUe0HssW8CjW1UuVlVPhKNfjqPPDXr4COKwdyi6a/Jiqz3whj7Jk56j
 tKKAXLD7
 lRbMJ+GD+uwkQgFXKNLPo2pv+N6fFZqdVg1Z4YpZuFYsYbjuJaAcfnovCC3gF9jN5XrIgggd6uYlYQoCh3fWwZQqbi+TasNpOUBM7oKtPHWp6BXPTaSl3JoUvUtcindCcxhxsBYqaVQt8z3s6hupYurG0rRbhFG0CN3R0eVn9He3BcUUPvvoIOarLI0CVXT2RjKGUUtZxD2leMT4DV1XtcXeB1OciLwtERX0oqgdn3KOoay7eeM6dyhRZ6G3aiDLTkx4XVnkQWj1rx0v72wzkyyKzVO4eJvBGmipMItKm3qfH3OTLKgKK0it+r5LRVA/Wh3MJWnTpdre8whLbAJwH+F6awZIQS8u79djbyH3CRmrbRir5/qkDitk/+iQ/a7FgXjaTtTyx+cYLmEV4VDVyI3/peBAOZ68mFKtw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/07/2026 12:27 pm, Will Deacon wrote:
> On Mon, Jul 06, 2026 at 03:49:24PM +0200, Thierry Reding wrote:
>> On Fri, Jul 03, 2026 at 06:13:31PM +0100, Will Deacon wrote:
>>> On Thu, Jul 02, 2026 at 06:41:23PM +0200, Thierry Reding wrote:
>>>> On Thu, Jul 02, 2026 at 03:46:44PM +0200, Thierry Reding wrote:
>>>>> On Thu, Jul 02, 2026 at 10:18:47AM +0100, Will Deacon wrote:
>>>>>> On Wed, Jul 01, 2026 at 06:08:15PM +0200, Thierry Reding wrote:
>>>>>>> From: Chun Ng <chunn@nvidia.com>
>>>>>>>
>>>>>>> Add helpers to swap PROT_NORMAL and PROT_DEVICE_nGnRnE protection bits
>>>>>>> on a kernel-linear-map range.
>>>>>>
>>>>>> That sounds like a really terrible idea. Why is this necessary and how
>>>>>> does it interact with things like load_unaligned_zeropad()?
>>>>>
>>>>> This is necessary because once the memory controller has walled off the
>>>>> new memory region the CPU must not access it under any circumstances or
>>>>> it'll cause the CPU to lock up (I think technically it'll hit an SError
>>>>> but in practice that just means it'll freeze, as far as I can tell).
>>>>>
>>>>> Probably doesn't interact well at all with load_unaligned_zeropad().
>>>>>
>>>>>> I think you should unmap the memory from the linear map and memremap()
>>>>>> it instead.
>>>>>
>>>>> Given that the memory can never be accessed by the CPU after the memory
>>>>> controller locks it down, I don't think we'll even need memremap(). The
>>>>> only thing we really need is the sg_table we hand out via the DMA BUFs
>>>>> so that they can be used by device drivers to program their DMA engines
>>>>> internally.
>>>>>
>>>>> Looking through some of the architecture code around this, shouldn't we
>>>>> simply be using set_memory_encrypted() and set_memory_decrypted() for
>>>>> this? While they might've been created for slightly other use-cases,
>>>>> they seem to be doing exactly what we want (i.e. remove the page range
>>>>> from the linear mapping and flushing it, or restoring the valid bit and
>>>>> standard permissions, respectively).
>>>>
>>>> Ah... I guess we can't do it because we're not in a realm world and so
>>>> the early checks in __set_memory_enc_dec() would return early and turn
>>>> it into a no-op.
>>>>
>>>> How about if I extract a common helper and provide set_memory_p() and
>>>> set_memory_np() in terms of those. Those are available on x86 and
>>>> PowerPC as well, so fairly standard. I suppose at that point we're
>>>> closer to set_memory_valid().
>>>
>>> Why not just call set_direct_map_invalid_noflush() +
>>> flush_tlb_kernel_range() for each page? We already have APIs for this.
>>
>> Having a "standard" helper with a fixed and documented purposed seemed
>> like a preferable approach for this particular case. We also may want to
>> make the driver that uses this buildable as a module, in which case we'd
>> need to export these rather low-level APIs. And then there's also the
>> fact that we typically call this on a rather large region of memory
>> (usually something like 512 MiB), so doing it page-by-page is rather
>> suboptimal.
>>
>>> The big challenge I see with any linear map manipulation, however, is
>>> that it will rely on can_set_direct_map() which likely means you need to
>>> give up some performance and/or security to make this work. Does memory
>>> become inaccesible dynamically at runtime? If not, the best bet would
>>> be to describe it as a carveout in the DT and mark it as "no-map" so
>>> we avoid mapping it in the first place.
>>
>> VPR exists in two modes: static and resizable. For static VPR we do
>> exactly that: describe it as carveout in DT with no-map and deal with it
>> accordingly in the driver. Resizable VPR is for device that have small
>> amounts of RAM. Content-protected video playback will in the worst case
>> consume around 1.8 GiB of RAM, so we want to be able to reuse for other
>> purposes when VPR is unused on those devices. In that case, the memory
>> is also described as a reserved-memory region in DT, but it is marked as
>> reusable so that it can be managed by CMA.
>>
>> The resize operation is fairly slow to begin with because we need to
>> stall the GPU and put it into reset before the operation, then take it
>> out of reset and resume it afterwards.
>>
>> What kind of performance impact do you expect?
> 
> You'll need to measure it, but we've seen reports of double-digit
> percentage regressions in performance and power. As I said, the problem
> is that you need to split the linear map to 4k page at runtime to unmap
> the dynamic carveout, but that isn't something that can be done on most
> CPUs. Therefore you end up having to use page-granular mappings for the
> entire thing, similarly to how 'rodata_full' drives can_set_direct_map()
> and the perf/power hit affects everything.
> 
> It's hard to know what to suggest... I wonder if any of the memory
> hotplug logic could help here?

Given the precedent of memblock_mark_nomap(), as long as the reusable 
reserved-memory regions also get split into distinct memblocks, then it 
seems like in principle we ought to be able to give them a new 
MEMBLOCK_PTEMAP (or whatever) flag which could then be picked up in 
map_mem() without needing to override force_pte_mapping() globally?

Cheers,
Robin.


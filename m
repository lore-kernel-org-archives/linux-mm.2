Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEC69FEFB52
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 14:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E736F6B0088; Fri, 27 Feb 2026 09:05:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E21146B0089; Fri, 27 Feb 2026 09:05:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D02BB6B008A; Fri, 27 Feb 2026 09:05:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BDBBE6B0088
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:05:08 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6161AC2601
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:05:08 +0000 (UTC)
X-FDA: 84490408296.01.D2C73D6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 319D71C001A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:05:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772201106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=laQ/37Z8JhyFx50CMhWx7VeAYeTKrxFZTdoUEZCuxGs=;
	b=z06BL4Ujwh3IoGg5jtDF+tpKM9NQr3DxxVsyg8wS2n0NmirPaDMOg+rC9u18DW7/6ehsXt
	woIow91ZzasEVu5GBPQrAET/ULcAb6UYLGjTuc77ioWe83GIwNnh/TjutjYqzoVji/p0c6
	UtHeBq+Y93pZ4g03+KV6ONh50pJ61uE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772201106; a=rsa-sha256;
	cv=none;
	b=QgwLMyzZiflGSRps+tZSG3TtxoUTEsvtoHm+8wpDPoQnkh0GxWlwcX5xgL/ddEI4BRwxE4
	DKTXsodzwgHMSxZy//2BkZART7FMPeOckKpsu/l8nKkwsl8KzpMu6tRpkUJzEiCdYRNlBL
	n/CpG1SKuAt+RZ4GJv+Uihf1XE6iDn4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA3EA14BF;
	Fri, 27 Feb 2026 06:04:58 -0800 (PST)
Received: from [10.57.55.4] (unknown [10.57.55.4])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B70FC3F62B;
	Fri, 27 Feb 2026 06:05:03 -0800 (PST)
Message-ID: <da6db3e2-4d42-41af-b6b5-efa7532ecb7c@arm.com>
Date: Fri, 27 Feb 2026 14:05:01 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] iommu/dma: Validate page before accessing P2PDMA
 state
To: Ashish Mhetre <amhetre@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Pranjal Shrivastava <praan@google.com>
Cc: joro@8bytes.org, will@kernel.org, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org, linux-mm@kvack.org
References: <20260224104257.1641429-1-amhetre@nvidia.com>
 <20260224123221.GM10607@unreal> <aZ4Q1HA9q1ojsVYY@google.com>
 <9d01b4e3-be5b-4c9c-8088-1d10f67f1fd8@nvidia.com>
 <20260225075609.GB9541@unreal> <aZ9Xccnn7JOikudb@google.com>
 <20260226075806.GE12611@unreal>
 <58634d52-5d44-4ec9-b1f6-273b5c32b525@nvidia.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <58634d52-5d44-4ec9-b1f6-273b5c32b525@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 319D71C001A
X-Stat-Signature: c91mqyfbagfx65emujh7mzmtdqw7i34m
X-Rspam-User: 
X-HE-Tag: 1772201105-783311
X-HE-Meta: U2FsdGVkX19h4ATTLJ1Py5iLNCXBS5SiYwmUX9l9hWX5d3/g1ZMRlLw7pXvHebVdVlPYpcM/kk+0q2UZLZibL9gbgE2X74PBbGBcpUHPlfjRIbtECPYF5cZ/nTHC3j6odrDJabfXpjHW/p6Z7UDNWxb22A2eQdp01AWBUBwLKc/XJdGvLfZJzpuLjyzIEFVuPYKfingjWyjQJVfc2PiB2wGWq5F159Mt97cLzCeSgJt86X/OgXlHlo2WOpSat+M/Zknb0TDdEQeWmSwgLvZWWAocTfdA1Ead+PGkSOst7baAhERrN1KLa4HAP0qYkHh7vz9p3Qo25FO9lCEasV9jcn5aI66Z+x4KpQZzsSbqydO2FqCUxSayauEmbmkzk8aF/SPtEo9/+mGOI6Hq6Hk0zadNmw/oR9BmKt7rHxLsBnCHb/MBR5MV55pz8UhZW0fEQrlvL7JxjjweQX1tmRWQkyhjrFTeUjvARzeY7RdDB3WjHWma/vzQEnZviK7m/i2HcrP27EPNs+1NNyN5hlZJY4iudCJuUt/g6yQAQ76ueS+YHNilDdGTy5F04wzp5t/E815W0JmM1ZFByKJp9/vSDGoYHqBVwkXhUDDZyLp0EHwad4M18DY8y86/bPmXxccVrP1kjgl8CBylR1q6PII3fyCy6XSpdnSSNX3tNh8sp/efFu5gZn3gWgnsTtKP51hAsEKoSUwGM6d1I/MJ1GU2tab8Wn2pd72SyYi6F5Hv+jHeurJpkOj4WHYQV3NXr7i3XBG3/ba8SiwK1X4eoND1E9hliFH+l2S+f3ukOKBFTCAu/j23jphNFHwcLeuq5ZHIzZVPgRRMifJqdivgvbdwh8kHqMiGya4ntJRuNpEfYvNwOBBIWet9cBZ9H0z+LEwW1cahEnV6EQ/1dXac0qd/p6BU4czc21fV3v1dK+wnmQLlUkb1ZGzs4wML1uJw5mKDulDoikVGpjvEn+vFLJG
 QF73gGL5
 A2hxr3ENZMRxqWetGbPsGNG4+8CP0aV7tNvibZSvM77TiDdHSyKhIYVA+18YJSk9nbdqGyLqzkcHuO6//5r212u830Q533j131sGyt8f9NwHZbwHG516XRJDBv48tAbjC6att9wp1JSwij0OaqX+TEG8ctfx6paUFkBOUOc68MK5YFDI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-27 5:46 am, Ashish Mhetre wrote:
> 
> 
> On 2/26/2026 1:28 PM, Leon Romanovsky wrote:
>> External email: Use caution opening links or attachments
>>
>>
>> On Wed, Feb 25, 2026 at 08:11:29PM +0000, Pranjal Shrivastava wrote:
>>> On Wed, Feb 25, 2026 at 09:56:09AM +0200, Leon Romanovsky wrote:
>>>> On Wed, Feb 25, 2026 at 10:19:41AM +0530, Ashish Mhetre wrote:
>>>>>
>>>>> On 2/25/2026 2:27 AM, Pranjal Shrivastava wrote:
>>>>>> External email: Use caution opening links or attachments
>>>>>>
>>>>>>
>>>>>> On Tue, Feb 24, 2026 at 02:32:21PM +0200, Leon Romanovsky wrote:
>>>>>>> On Tue, Feb 24, 2026 at 10:42:57AM +0000, Ashish Mhetre wrote:
>>>>>>>> When mapping scatter-gather entries that reference reserved
>>>>>>>> memory regions without struct page backing (e.g., bootloader 
>>>>>>>> created
>>>>>>>> carveouts), is_pci_p2pdma_page() dereferences the page pointer
>>>>>>>> returned by sg_page() without first verifying its validity.
>>>>>>> I believe this behavior started after commit 88df6ab2f34b
>>>>>>> ("mm: add folio_is_pci_p2pdma()"). Prior to that change, the
>>>>>>> is_zone_device_page(page) check would return false when given a
>>>>>>> non‑existent page pointer.
>>>>>>>
>>>>> Thanks Leon for the review. This crash started after commit 
>>>>> 30280eee2db1
>>>>> ("iommu/dma: support PCI P2PDMA pages in dma-iommu map_sg").
>>>>>
>>>>>> Doesn't folio_is_pci_p2pdma() also check for zone device?
>>>>>> I see[1] that it does:
>>>>>>
>>>>>> static inline bool folio_is_pci_p2pdma(const struct folio *folio)
>>>>>> {
>>>>>>           return IS_ENABLED(CONFIG_PCI_P2PDMA) &&
>>>>>>                   folio_is_zone_device(folio) &&
>>>>>>                   folio->pgmap->type == MEMORY_DEVICE_PCI_P2PDMA;
>>>>>> }
>>>>>>
>>>>>> I believe the problem arises due to the page_folio() call in
>>>>>> folio_is_pci_p2pdma(page_folio(page)); within is_pci_p2pdma_page().
>>>>>> page_folio() assumes it has a valid struct page to work with. For 
>>>>>> these
>>>>>> carveouts, that isn't true.
>>>>>>
>>>>>> Potentially something like the following would stop the crash:
>>>>>>
>>>>>> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
>>>>>> index e3c2ccf872a8..e47876021afa 100644
>>>>>> --- a/include/linux/memremap.h
>>>>>> +++ b/include/linux/memremap.h
>>>>>> @@ -197,7 +197,8 @@ static inline void 
>>>>>> folio_set_zone_device_data(struct folio *folio, void *data)
>>>>>>
>>>>>>    static inline bool is_pci_p2pdma_page(const struct page *page)
>>>>>>    {
>>>>>> -       return IS_ENABLED(CONFIG_PCI_P2PDMA) &&
>>>>>> +       return IS_ENABLED(CONFIG_PCI_P2PDMA) && page &&
>>>>>> +               pfn_valid(page_to_pfn(page)) &&
>>>>>>                   folio_is_pci_p2pdma(page_folio(page));
>>>>>>    }
>>>>>>
>>>>> Yes, this will also fix the crash.
>>>>>
>>>>>> But my broader question is: why are we calling a page-based API like
>>>>>> is_pci_p2pdma_page() on non-struct-page memory in the first place?
>>>>>> Could we instead add a helper to verify if the sg_page() return value
>>>>>> is actually backed by a struct page? If it isn't, we should arguably
>>>>>> skip the P2PDMA logic entirely and fall back to a dma_map_phys style
>>>>>> path. Isn't handling these "pageless" physical ranges the primary 
>>>>>> reason
>>>>>> dma_map_phys exists?
>>>>> Thanks for the feedback, Pranjal.
>>>>>
>>>>> To clarify: are you suggesting we handle non-page-backed mappings 
>>>>> inside
>>>>> iommu_dma_map_sg (within dma-iommu), or that callers should detect
>>>>> non-page-backed memory and use dma_map_phys instead of dma_map_sg?
>>>> The latter one.
>>>>
>>> Yup, I meant the latter.
>>>
>>>>> Former approach sounds better so that existing iommu_dma_map_sg 
>>>>> callers
>>>>> don't need changes, but I'd like to confirm your preference.
>>>> The bug is in callers which used wrong API, they need to be adapted.
>>> Yes, the thing is, if the caller already knows that the region to be
>>> mapped is NOT struct page-backed, then why does it use dma_map_sg
>>> variants?
>> Before dma_map_phys() was added, there was no reliable way to DMA‑map
>> such memory, and using dma_map_sg() was a workaround that happened to
>> work. I'm not sure whether it worked by design or by accident, but the
>> correct approach now is to use dma_map_phys().
> 
> Thanks Leon and Pranjal for the detailed feedback. I'll update our 
> callers to use
> dma_map_phys() for non-page-backed buffers.
> 
> One question: would it make sense to add a check in iommu_dma_map_sg to
> fail gracefully when non-page-backed buffers are passed, instead of 
> crashing
> the kernel?

No, it is the responsibility of drivers not to abuse kernel APIs 
inappropriately. Checking for misuse adds overhead that penalises 
correct users. dma_map_page/sg on non-page-backed memory has never been 
valid, and it would only have been system-configuration-dependent luck 
that it wasn't already blowing up before. I guess dma-debug could add 
additional checks on these APIs similarly to debug_dma_map_single(), but 
the fact that we've never even considered checking for made-up bogus 
struct page pointers only goes to show just how wrong a thing to do it is.

Thanks,
Robin.


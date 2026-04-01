Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C236AD3517A
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 12:11:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 235F86B0005; Wed,  1 Apr 2026 08:11:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E6996B0088; Wed,  1 Apr 2026 08:11:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D5D36B0089; Wed,  1 Apr 2026 08:11:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC8206B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:11:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 965CF8C5B8
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 12:11:35 +0000 (UTC)
X-FDA: 84609872550.09.2C09DFA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 556AD40018
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 12:11:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FNDsTbVE;
	spf=pass (imf07.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775045494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iSeb7biapRVrCJpAI3pOdfntjxfozo+70Fxxd4XRkfM=;
	b=TdLKZ9SooriplDcjUzebrMZ4/C2b5XYX6J7SSlnzUEEADnWZ8ZjuvoTl4GRHKU7MC3UlA8
	pJlIxyR0lSFSI7q6zDUlcrmnpkp3ut2St5vR3HLwX6foR9GKIN8TedXRuRikGNDYsA7M0w
	uJ76Gq17XTcP6vn8pUEg9wRiPcRiL88=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775045494; a=rsa-sha256;
	cv=none;
	b=aUQSwfZhBnwAX1p6vlkgR+/oXRdnZ0DNUugU/lUaDoGGQ6s/wDXVeDjtIX7VFA+UeMIqe2
	fc70/Nn4AcvR8Ks31cDDDqqD+PmnkVTIP0L435K0Eqj0rVf8oO3X4mC2LLBpMNXfP7eGNp
	V6r1DJvq6+hAzEo+GlzSznJvMDK1XUQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FNDsTbVE;
	spf=pass (imf07.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 429D31BB0;
	Wed,  1 Apr 2026 05:11:26 -0700 (PDT)
Received: from [10.57.77.192] (unknown [10.57.77.192])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 610EF3F915;
	Wed,  1 Apr 2026 05:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775045492; bh=BE5/nPRKaHRs63cPfmGPfBklsCc8yJVyXPy273mNLyk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FNDsTbVE+dEiFbJpw+3tElXCfZHMBObNS/5oxU0uSjGMnwgeMM/5I47NhEc/4WPmB
	 PnE2ghf/jR8nTm2Dhd2kAQ2b2dWvFR/wyB1eCJYRdAgCyC0HUEbNE3bbZmtG/lGOpQ
	 2XRAycjpy4vEjbPShbCiHyksZ605KXgFH187AaO4=
Message-ID: <c9ded35b-fc10-47d8-bfaa-cecb4fa91add@arm.com>
Date: Wed, 1 Apr 2026 13:11:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] dma-debug: suppress cacheline overlap warning when
 arch has no DMA alignment requirement
To: Marek Szyprowski <m.szyprowski@samsung.com>,
 Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-usb@vger.kernel.org, linux-mm@kvack.org, harry@kernel.org,
 vbabka@kernel.org, akpm@linux-foundation.org, stern@rowland.harvard.edu,
 linux@roeck-us.net, andy.shevchenko@gmail.com, hch@lst.de,
 Jeff.kirsher@gmail.com, catalin.marinas@arm.com
References: <CGME20260327124211eucas1p10425a28f67736d2043e7e4dd77d58e72@eucas1p1.samsung.com>
 <20260327124156.24820-1-mikhail.v.gavrilov@gmail.com>
 <6270d4f0-85e4-496d-8db4-87ccb791ca4d@samsung.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <6270d4f0-85e4-496d-8db4-87ccb791ca4d@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: wsouzdodkz66c9xfnsysm6hghwa84abt
X-Rspamd-Queue-Id: 556AD40018
X-Rspam-User: 
X-HE-Tag: 1775045493-668552
X-HE-Meta: U2FsdGVkX19yfQV8cxHFKKsCYkzrNwYxplZjTwpGo87XMBfs4sM2LE6XFLeE9ekTdeQEt5NP80hd5bmB2V+5nq10fJBv4I/kzQ7Ev8jVBg2Kry1xEmLcMQSWG58bcGZ0vBCw4NsyLF5KqdJsOHyFAXpk5Xf8m8lE8SIR13jhY8fYMEkboFCKwtTXoolQ9txctyNQsXuvrd7hzc+BmAe5mUDLcp8du3umL/C0i4yWnmx/vYjYh+d9LMLQ6U2MrjHLSAZIxtGQ2MqIRCF6wQJVpqVPQUvVUXXKAml2Z9B2gJ9P8YmFh+71/ibLhDkVeReL3fUzYIn2sOpfQn+Rg7H4431uWnNcPckSMIEiGbB0kYOs9nzCVEq/XjzVxrO2XqBEHZPbXxGseIB4J5+jAnKuQsCpZad1XapIzjanyxEFHkh6+4r6+op9V+JsK6CgHhx21zlOBPO4wvyN2pIiwVjwMdh4w7EA5AsOqp3AvGGOI1SpfibCyI6Mz6Gp3Gid8NZvViWiL47M+xfWM+mHqb/hP+6Ndd9BCGUxyElVNGGnnTVqH8/DXUaTcKVGzU5kAA918M2gXusS6sA6evqLhEXbnLtNm3752CPkzi/H0PvcQai7X4zhzRzsmxRddMUBYPr8PhqLw7VkCDiQF4l4qDWnJARQKInjQHcxbL4Jjkon9Se4wTUdE3KNHYcRBvIw2U+9VU+3pHMIGqDGQ8eRK0qfXS1Vt0Ibxun/J3tDQGLyVE6Ur7G/U6FW4PFGpV1+NLwl6mrNCYox65c6vB3JvXnACi1gXSf8FvXHPFH/FCQ1Ku8nnA7xqq8LlRZKAudUz9D9ynXt02a+qvNxSl3Sr0oQlitjgIAlBiZEw9g+WOkwYZQzCVmwmYa8QzmtSkSRxum9Ol7GsgnFGuLFo6J+hPp/3jtxexi7CuEG5R/lJctESYTBjW0v23ESqvk20BQQwLwPbabLhc5TwE7U/dR4a+a
 6z/aAo6Y
 p3Piv5kncI+bvaJEeYChG0mCXIaTHLUJ33MrtSPjoGnXZ/J/l1UinvYqq/lk0mWOPjnzC1F/lRmchNN8SWoghTOptF9ka5sXkcniRezz0VDZ28xKuvnef68O54b+1YCSMBf2RzpS0dS7dScd/rP+RqNYYWfeENKAwzvWkkVNDszoH4d8fN2N/HbZuOh85BSwHUEUMyqgoa88hpTXYcIKtmZS5oiq2dX+EpzoYm4Dyr05qXGuTVCpnEw8IM/mHWjC1aDoRQQaLk5owdns2hjsOWi2qxa36yPgT8p+QSivJnQhGvrGc7GGMrlTIWEOTr62I9vuzGyhyErqaAgSPQWg3sf+LnRce40awoXJJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-30 8:44 am, Marek Szyprowski wrote:
> On 27.03.2026 13:41, Mikhail Gavrilov wrote:
>> When CONFIG_DMA_API_DEBUG is enabled, the DMA debug infrastructure
>> tracks active mappings per cacheline and warns if two different DMA
>> mappings share the same cacheline ("cacheline tracking EEXIST,
>> overlapping mappings aren't supported").
>>
>> On x86_64, ARCH_KMALLOC_MINALIGN defaults to 8, so small kmalloc
>> allocations (e.g. the 8-byte hub->buffer and hub->status in the USB
>> hub driver) frequently land in the same 64-byte cacheline.  When both
>> are DMA-mapped, this triggers a false positive warning.
>>
>> This has been reported repeatedly since v5.14 (when the EEXIST check
>> was added) across various USB host controllers and devices including
>> xhci_hcd with USB hubs, USB audio devices, and USB ethernet adapters.
>>
>> The cacheline overlap is only a real concern on architectures that
>> require DMA buffer alignment to cacheline boundaries (i.e. where
>> ARCH_DMA_MINALIGN >= L1_CACHE_BYTES).  On architectures like x86_64
>> where dma_get_cache_alignment() returns 1, the hardware is
>> cache-coherent and overlapping cacheline mappings are harmless.
>>
>> Suppress the EEXIST warning when dma_get_cache_alignment() is less
>> than L1_CACHE_BYTES, indicating the architecture does not require
>> cacheline-aligned DMA buffers.

Really the value of this check is for mappings of structure members or 
array elements which have no inherent guarantee of being individually 
aligned to ARCH_DMA_MINALIGN, and while x86 can also get away with that, 
it represents a genuine issue for non-coherent architectures. USB's 
mapping of a dedicated tiny allocation is, if anything, rather the 
special case.

TBH I'd be inclined to have CONFIG_DMA_DEBUG raise ARCH_DMA_MINALIGN as 
appropriate such that genuine false-positives can't happen, rather than 
effectively defeat the whole check, but I suppose that might carry a 
risk of tripping up arch code that doesn't expect it... Oh well.

Thanks,
Robin.

>> Verified with a kernel module reproducer that performs two kmalloc(8)
>> allocations back-to-back and DMA-maps both:
>>
>>    Before: allocations share a cacheline, EEXIST fires within ~50 pairs
>>    After:  same cacheline pair found, but no warning emitted
>>
>> Fixes: 2b4bbc6231d7 ("dma-debug: report -EEXIST errors in add_dma_entry")
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=215740
>> Suggested-by: Harry Yoo <harry@kernel.org>
>> Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
>> Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
> 
> Applied to dma-mapping-fixes. Thanks!
> 
>> ---
>>
>> v1 -> v2:
>>    - Moved fix from include/linux/slab.h (ARCH_KMALLOC_MINALIGN)
>>      to kernel/dma/debug.c per Harry Yoo's suggestion.
>>    - Instead of forcing cacheline-aligned allocations, suppress
>>      the warning when the architecture has no DMA alignment
>>      requirement (dma_get_cache_alignment() < L1_CACHE_BYTES).
>>
>> v1: https://lore.kernel.org/all/20260327055846.248829-1-mikhail.v.gavrilov@gmail.com/
>>
>> Reproducer module that triggers the bug reliably:
>>    https://bugzilla.kernel.org/attachment.cgi?id=309769
>>
>>   kernel/dma/debug.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
>> index 0677918f06a8..1a725edbbbf6 100644
>> --- a/kernel/dma/debug.c
>> +++ b/kernel/dma/debug.c
>> @@ -615,6 +615,7 @@ static void add_dma_entry(struct dma_debug_entry *entry, unsigned long attrs)
>>   	} else if (rc == -EEXIST &&
>>   		   !(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
>>   		   !(entry->is_cache_clean && overlap_cache_clean) &&
>> +		   dma_get_cache_alignment() >= L1_CACHE_BYTES &&
>>   		   !(IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) &&
>>   		     is_swiotlb_active(entry->dev))) {
>>   		err_printk(entry->dev, entry,
> 
> Best regards



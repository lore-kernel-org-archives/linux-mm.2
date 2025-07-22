Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA483C83F25
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 10:03:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36A8B6B00AE; Tue, 22 Jul 2025 06:03:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 342886B00AF; Tue, 22 Jul 2025 06:03:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27F466B00B0; Tue, 22 Jul 2025 06:03:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19E526B00AE
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 06:03:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 96C17C02C0
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:03:27 +0000 (UTC)
X-FDA: 83691463254.07.9DED545
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 607FD40012
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:03:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753178606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RPgLZSxsljWC9r85EVDda2I7onvnhohX8QcxVTCFUqw=;
	b=6sojAUr81spUgSVlT8wKGdd3wpsBD4Tfz4IGptzeDHn+xjbKmYYIE57Q+Fn970EWaxc10m
	RtxG1WrpdhfCZyQa3+0hlY556RJMTEGOQqpGaaM7eIXY6tnMh1c07r0GNMf4+kAJIFvozk
	op0jlyPdvQ0LLlSm5ggru3L5Q/fwlJw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753178606; a=rsa-sha256;
	cv=none;
	b=cx7DWcgX4zgQij71LcsVpn5vchnmJHWV7qqgVGnpwlCjC6FVJuB5wiqZRYAD1rjkna+AoF
	A0Cmi3a36oXIaTrUBqOz1p2h8EHJq581C1ZqwKTVWJ/0aKqCs1d2w+VzjXrUcm7cfr2b6m
	2paVHuz1W/ZiTmx35vdXz47onOUAVSc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC462152B;
	Tue, 22 Jul 2025 03:03:18 -0700 (PDT)
Received: from [10.57.0.201] (unknown [10.57.0.201])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E1B363F59E;
	Tue, 22 Jul 2025 03:03:21 -0700 (PDT)
Message-ID: <c93b34ca-1abf-4db0-90f9-3802ac02c25a@arm.com>
Date: Tue, 22 Jul 2025 11:03:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Excessive page cache occupies DMA32 memory
To: Greg KH <gregkh@linuxfoundation.org>,
 Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Matthew Wilcox <willy@infradead.org>,
 Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
 Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
 Manivannan Sadhasivam <mani@kernel.org>, Jeff Johnson <jjohnson@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, kernel@collabora.com,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 iommu@lists.linux.dev
References: <766ef20e-7569-46f3-aa3c-b576e4bab4c6@collabora.com>
 <aH51JnZ8ZAqZ6N5w@casper.infradead.org>
 <2025072238-unplanted-movable-7dfb@gregkh>
 <91fc0c41-6d25-4f60-9de3-23d440fc8e00@collabora.com>
 <2025072234-cork-unadvised-24d3@gregkh>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <2025072234-cork-unadvised-24d3@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 607FD40012
X-Stat-Signature: qzw5jraosw6319wh97kg46jhnd5ix1om
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753178605-705076
X-HE-Meta: U2FsdGVkX18WWBUKkPp9cnqVTawVboxNaoe9CCvHRDn3EdYs2M4nESm5wzR3WRIzVs59EOIrwootLLt0F5AdSPsHgq/R0eyUZQTLvSIzpWqtORIXbOGmH7lAb33qPoQMW7uMaHLxek88xjkiA965nPTmPlgfcNQL31CTxM7ITllAwTL3NVB+VVoQBu39XbJc3/5B8ilzshWyRMtlc7mqTDymD6dAEfNafomYDppm2KDusPA9pp9VmjZ+BnTEkUdf1O0wVRS0CYA7fOcGtshZ/+IcNgyQx4TaQqAVOvXiop3/sIO2xcmofsXmVHlq2EcvJO74Xp0I4m8cqnnH8k0eDcf5706ETMM9TZQATvesIkX3gYaKEQQL76zzAwYNYSykFfaUl9Tpzlu8ItBT7MNisOkstUBPwviAFKq2JA8aZwnHVhBr+AZ71ItsEK4MmAwSC8K9IlI0EIEh/hvkk/ZwvkTnRzUJJ6wDWYf8AqKMi6WvNilt5WJ5W3hI2/VWITd11Ol9pqt324Di2+N79R5l0kROp310CIaIhLbKKWj/lzLi0WL2j3F8M62+08ZyPXOflyaySbc0fab0vqeQDTrXSdehwxQxZwf3hlEcPNeC0m6z2miAqsnMOPxngwNw6/ojVFLW7Zvp4LVc3C1KUy1nyr3tBc6MRgBBGlECmqWsUUP5dN4b0tRMwpBEolmculKo39wOvfAeecnpvkIasVmLyR0VKiLSyCGsCHBFxFv6t208OIjpbVBC+Kt8eS6O+4YnNiDcKt7KAW3xe9iQiKtOmR7xWoMf9HaRde9LCu9jYEt+tY8D4AQ3guiSsNLFu6hyog8PYy/vcJXYyDkGZ1EUImPfuoQRHm6cZymbQjtlLSLskRV8OrIBWzpRzYiHzjH3SggXOby8a4+SMXytFnCDLft4JP3OzOveOsQ9O64+vyS5NxmOCstTPlZea80RbD30XOp0NQcrclI7sHFAgNq
 +8Dv8f3m
 RDPjNFrmEyFWLQsBQI6uLC0Dnpf5Xlm9qD/owQv5PWpudBDihim5ePcMVBDpGBXSbwT8AOUq8QDxQtnlIhkINYtFJwm+v5RyZsh5A4i0DzXHOEiFD6kJu0J8rOzHPg7QfdbEhbwQ5UaRO8yUSAuRNtmT/JUF9CeAeoQHRJ676Fsv5pBw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-07-22 8:24 am, Greg KH wrote:
> On Tue, Jul 22, 2025 at 11:05:11AM +0500, Muhammad Usama Anjum wrote:
>> Adding ath/mhi and dma API developers to the discussion.
>>
>> On 7/22/25 10:32 AM, Greg KH wrote:
>>> On Mon, Jul 21, 2025 at 06:13:10PM +0100, Matthew Wilcox wrote:
>>>> On Mon, Jul 21, 2025 at 08:03:12PM +0500, Muhammad Usama Anjum wrote:
>>>>> Hello,
>>>>>
>>>>> When 10-12GB our of total 16GB RAM is being used as page cache
>>>>> (active_file + inactive_file) at suspend time, the drivers fail to allocate
>>>>> dma memory at resume as dma memory is either occupied by the page cache or
>>>>> fragmented. Example:
>>>>>
>>>>> kworker/u33:5: page allocation failure: order:7, mode:0xc04(GFP_NOIO|GFP_DMA32), nodemask=(null),cpuset=/,mems_allowed=0
>>>>
>>>> Just to be clear, this is not a page cache problem.  The driver is asking
>>>> us to do a 512kB allocation without doing I/O!  This is a ridiculous
>>>> request that should be expected to fail.
>>>>
>>>> The solution, whatever it may be, is not related to the page cache.
>>>> I reject your diagnosis.  Almost all of the page cache is clean and
>>>> could be dropped (as far as I can tell from the output below).
>>>>
>>>> Now, I'm not too familiar with how the page allocator chooses to fail
>>>> this request.  Maybe it should be trying harder to drop bits of the page
>>>> cache.  Maybe it should be doing some compaction.
>> That's very thoughtful. I'll look at the page allocator why isn't it dropping
>> cache or doing compaction.
>>
>>>> I am not inclined to
>>>> go digging on your behalf, because frankly I'm offended by the suggestion
>>>> that the page cache is at fault.
>> I apologize—that wasn't my intention.
>>
>>>>
>>>> Perhaps somebody else will help you, or you can dig into this yourself.
>>>
>>> I'm with Matthew, this really looks like a driver bug somehow.  If there
>>> is page cache memory that is "clean", the driver should be able to
>>> access it just fine if really required.
>>>
>>> What exact driver(s) is having this problem?  What is the exact error,
>>> and on what lines of code?
>> The issue occurs on both ath11k and mhi drivers during resume, when
>> dma_alloc_coherent(GFP_KERNEL) fails and returns -ENOMEM. This failure has
>> been observed at multiple points in these drivers.
>>
>> For example, in the mhi driver, the failure is triggered when the
>> MHI's st_worker gets scheduled-in at resume.
>>
>> mhi_pm_st_worker()
>> -> mhi_fw_load_handler()
>>     -> mhi_load_image_bhi()
>>        -> mhi_alloc_bhi_buffer()
>>           -> dma_alloc_coherent(GFP_KERNEL) returns -ENOMEM
> 
> And what is the exact size you are asking for here?
> What is the dma ops set to for your system?  Are you sure that is
> working properly for your platform?  What platform is this exactly?
> 
> The driver isn't asking for DMA32 here, so that shouldn't be the issue,
> so why do you feel it is?  Have you tried using the tracing stuff for
> dma allocations to see exactly what is going on for this failure?

I'm guessing the device has a 32-bit DMA mask, and the allocation ends 
up in __dma_direct_alloc_pages() such that that adds GFP_DMA32 in order 
to try to satisfy the mask via regular page allocation. How GFP_KERNEL 
turns into GFP_NOIO, though, given that the DMA layer certainly isn't 
(knowingly) messing with __GFP_IO or __GFP_FS, is more of a mystery... I 
suppose "during resume" is the red flag there - is this worker perhaps 
trying to run too early in some restricted context before the rest of 
the system has fully woken up?

Thanks,
Robin.

> 
> I think you need to do a bit more debugging :)
> 
> thanks,
> 
> greg k-h



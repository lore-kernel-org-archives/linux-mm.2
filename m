Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE66CCA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 13:39:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 621F46B0026; Thu, 21 Aug 2025 09:39:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D2516B0027; Thu, 21 Aug 2025 09:39:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E8F76B0028; Thu, 21 Aug 2025 09:39:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B5A76B0026
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 09:39:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 83C471403D7
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:39:58 +0000 (UTC)
X-FDA: 83800872876.08.86BD25D
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8644420005
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:39:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=AcJDthOL;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf03.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755783596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wQvXxO5dPYjb1A4ayy0eUrCJGC/5oVnxQCuKeO+aHuw=;
	b=VmaND3nYwz7jkVsk4qQS2KqNwEos8W+kaec2XcrYEQxEol1ecploZRtGWuWvNyEm0iNIcN
	wIEzkfQqs/2WZLafBjuCG2MP9JH7hGqWD6uizefXsW1yAIi5GrBV0EoK+OHF0YnRkjxXWm
	mi96L3TMireuJIb8BF3ohqacnWkzGtA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=AcJDthOL;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf03.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755783596; a=rsa-sha256;
	cv=none;
	b=8An6BhRHGsCx9Jtk13XYI9XVTeOkRxnZRxxWRXSDFgH9Ws7vNEFVFybTxDBwHYERz/VW+A
	Y2/0SwF0q+afDuwHi4JJB1Cx3RnOhVubRhV12gp8kE9L4qDq+IRqpbJHVLRQ4WuEB+y8td
	ONN6PaZVHDUCDFDlTD+57YWsaxE7/JQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1755783593;
	bh=uzUC6Drx5E9fPQbMQpF5UQNAQ6ITfbcPnHHlGncyJSA=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=AcJDthOL5BgNcTOJkDXW5BLWSl5yfrGZknSSn4ajJvthU7Haulm9UtA/+nqyPKrTq
	 zZjgMmn3JjbBilZsvHMlEO9uhejKeCAeB/6LDXinwHMZ6ukcCWaS/DC6xhIlMHitUm
	 TgEiWM/wJo9/R9r3udp6LZBqbNFV17owfBYKen0E3k9C7sY7B0QCqMUn9ocaI0MjZ+
	 vfTaPXBNxbYMvkFx5uhVHaxRGQr5e/4ooPfadW5sZUApK0PqgL2ZJWqr6DtJ2LxwnV
	 nI+Jx5K3jL8KBoCm5NOvqgKvkd1OX8CsBalzsUHucG3fe4EvgX4CWohSi3tJoqaMY4
	 e4vrEPKyuh+nw==
Received: from [192.168.100.175] (unknown [103.151.43.82])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: usama.anjum)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id A5D7F17E01F5;
	Thu, 21 Aug 2025 15:39:49 +0200 (CEST)
Message-ID: <bdd1efa8-691c-4e84-8977-cdfd48e7363a@collabora.com>
Date: Thu, 21 Aug 2025 18:39:45 +0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: Re: Excessive page cache occupies DMA32 memory
To: Robin Murphy <robin.murphy@arm.com>, Greg KH <gregkh@linuxfoundation.org>
Cc: usama.anjum@collabora.com, Matthew Wilcox <willy@infradead.org>,
 Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
 Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
 Manivannan Sadhasivam <mani@kernel.org>, Jeff Johnson <jjohnson@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, kernel@collabora.com,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 iommu@lists.linux.dev, David Hildenbrand <david@redhat.com>
References: <766ef20e-7569-46f3-aa3c-b576e4bab4c6@collabora.com>
 <aH51JnZ8ZAqZ6N5w@casper.infradead.org>
 <2025072238-unplanted-movable-7dfb@gregkh>
 <91fc0c41-6d25-4f60-9de3-23d440fc8e00@collabora.com>
 <2025072234-cork-unadvised-24d3@gregkh>
 <c93b34ca-1abf-4db0-90f9-3802ac02c25a@arm.com>
Content-Language: en-US
In-Reply-To: <c93b34ca-1abf-4db0-90f9-3802ac02c25a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8644420005
X-Stat-Signature: x4i63fcdm6i71hqxaae8d4jhmy4rg7ge
X-Rspam-User: 
X-HE-Tag: 1755783596-177630
X-HE-Meta: U2FsdGVkX19gYp+ykc928F44102mScihOG52ZMzZeVmMaQ6vIKUms1qpnLp49xWOxAzdNFqCMBvUyhmpioDt9XouPhMhIYScKYnvHItypxWd8a/mr8LyZDQwxst21IWW5+9okUjwZJpV1+6BXAmLcv9YUPB08+ecllg4cOsyDuyFufsmUB5nbKjv5Yny4rbeohNE+WnkOqbkaTqFfC6BtNoym2AFR5F5OUBdpYb/8FIapB1BuPXyIAaX70jPCMnYq6N4efh+ySrUsBLUiaFa5xoaf9s3ZmXZSCV5/u7racJxijNSzE2J62x44gNaPFM+pD2qc6KLe0Eo/UK+UrWwVLO01oSBqqbMsiaZzKstjTYuUs4czFdJVVTrxqfbMyz9jUe6TIMwaKVM/RK039WobxWZ4z6dYC85kdCTEAVNdxOw35csid3fWt8pyTCMtyr9ipnpuKNb4WE+/rHhin/mOox0ksV4iZ4WWdA2246t49obouUOK+Qjwj7x0bwcpDv9aE8RFgj46Mjxb89nd5dteCXp8H1dENInCcca1PugaDvj3YEHhFnPAkL3/oA2d+aDMlALc7e3Nnj/5Kpkdfwxa4bZZzcOnsgU0LfCyGVdiri1BMhJReSk+LHeuoT+4DnrMgWfKzQZZn6cneO3f8eRU7V0J5uTN456lU8Z0G3EigXOfeABPSQUPkhhLFDWoV46zaVcGmmbTGcDEFd37tQur1Iq0SIaQtXjSumyvJ5ozti7EbcS9tk67+64u5qysK4kGM+hPhoJk0RjX1/p/2PIqUXJFWixzGKR9cU9vPjsLfLJWxcKzJn8oyrnHbtLKRk/3fY8K62468AkX3G/yWJf0ru0r1LBxwFFkYLeTkQUlYhdcTnu6lKAUNzUA5SlyNU7YPltb4WTQYJBOH+nH/oK3DHVqSDvYTMXNReDekboVC4pIyhZtRzAd9Kn2RKe74S8mo5Ef749QOzIyt+tuAK
 uNobuESV
 CDq7S8RxYJA9XclEcSlGFh3TG1d66nAT2oD3kwCeZ0uvPvSlOrtvSulDQp/YC3iJBltm//fW97Hzw5BVW+Cn5LDKw9hdm8rK9VpqM4QsVkO0xf/WCfpgqDz0WVBk3ZxxwyWQtGOjYm+kOvSn8hbNVUcnNej6m3vUsJyJ+5/DVdr6DExuHfapPcq8Z63hJ82DJdlmt/xfGNKLw/iqytsEXKJnpWl817X/5zbGrSqUcvpmKq0uNJQgafcRiETy53QnAnEcPMGJ98AjKEiGag617RiUUc0Dm4T+bFzzxZLxXPJSGQrSdSeVha+7R0fIBrHaLqKCW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry, it took some time to investigate.

On 7/22/25 3:03 PM, Robin Murphy wrote:
> On 2025-07-22 8:24 am, Greg KH wrote:
>> On Tue, Jul 22, 2025 at 11:05:11AM +0500, Muhammad Usama Anjum wrote:
>>> Adding ath/mhi and dma API developers to the discussion.
>>>
>>> On 7/22/25 10:32 AM, Greg KH wrote:
>>>> On Mon, Jul 21, 2025 at 06:13:10PM +0100, Matthew Wilcox wrote:
>>>>> On Mon, Jul 21, 2025 at 08:03:12PM +0500, Muhammad Usama Anjum wrote:
>>>>>> Hello,
>>>>>>
>>>>>> When 10-12GB our of total 16GB RAM is being used as page cache
>>>>>> (active_file + inactive_file) at suspend time, the drivers fail to allocate
>>>>>> dma memory at resume as dma memory is either occupied by the page cache or
>>>>>> fragmented. Example:
>>>>>>
>>>>>> kworker/u33:5: page allocation failure: order:7, mode:0xc04(GFP_NOIO|GFP_DMA32), nodemask=(null),cpuset=/,mems_allowed=0
>>>>>
>>>>> Just to be clear, this is not a page cache problem.  The driver is asking
>>>>> us to do a 512kB allocation without doing I/O!  This is a ridiculous
>>>>> request that should be expected to fail.
>>>>>
>>>>> The solution, whatever it may be, is not related to the page cache.
>>>>> I reject your diagnosis.  Almost all of the page cache is clean and
>>>>> could be dropped (as far as I can tell from the output below).
>>>>>
>>>>> Now, I'm not too familiar with how the page allocator chooses to fail
>>>>> this request.  Maybe it should be trying harder to drop bits of the page
>>>>> cache.  Maybe it should be doing some compaction.
>>> That's very thoughtful. I'll look at the page allocator why isn't it dropping
>>> cache or doing compaction.
>>>
>>>>> I am not inclined to
>>>>> go digging on your behalf, because frankly I'm offended by the suggestion
>>>>> that the page cache is at fault.
>>> I apologize—that wasn't my intention.
>>>
>>>>>
>>>>> Perhaps somebody else will help you, or you can dig into this yourself.
>>>>
>>>> I'm with Matthew, this really looks like a driver bug somehow.  If there
>>>> is page cache memory that is "clean", the driver should be able to
>>>> access it just fine if really required.
>>>>
>>>> What exact driver(s) is having this problem?  What is the exact error,
>>>> and on what lines of code?
>>> The issue occurs on both ath11k and mhi drivers during resume, when
>>> dma_alloc_coherent(GFP_KERNEL) fails and returns -ENOMEM. This failure has
>>> been observed at multiple points in these drivers.
>>>
>>> For example, in the mhi driver, the failure is triggered when the
>>> MHI's st_worker gets scheduled-in at resume.
>>>
>>> mhi_pm_st_worker()
>>> -> mhi_fw_load_handler()
>>>     -> mhi_load_image_bhi()
>>>        -> mhi_alloc_bhi_buffer()
>>>           -> dma_alloc_coherent(GFP_KERNEL) returns -ENOMEM
>>
>> And what is the exact size you are asking for here?
512 KB

>> What is the dma ops set to for your system?  Are you sure that is
>> working properly for your platform?  What platform is this exactly?
Its x86_64 device.

>>
>> The driver isn't asking for DMA32 here, so that shouldn't be the issue,
>> so why do you feel it is?  Have you tried using the tracing stuff for
>> dma allocations to see exactly what is going on for this failure?
> 
> I'm guessing the device has a 32-bit DMA mask, and the allocation ends up in __dma_direct_alloc_pages() such that that adds GFP_DMA32 in order to try to satisfy the mask via regular page allocation. How GFP_KERNEL turns into GFP_NOIO, though, given that the DMA layer certainly isn't (knowingly) messing with __GFP_IO or __GFP_FS, is more of a mystery... I suppose "during resume" is the red flag there - is this worker perhaps trying to run too early in some restricted context before the rest of the system has fully woken up?

So GFP_KERNEL gets converted to only GFP_RECLAIM as GFP_IO and GFP_FS
are disabled by the pm subsystem at suspend time and they are only enabled
after the system has woken up.

GFP_FLAGS
0xcc0		GFP_KERNL = GFP_RECLAIM | GFP_IO | __GFP_FS
0xcc4		GFP_RECLAIM | GFP_IO | __GFP_FS | ___GFP_DMA32
0xc04		GFP_RECLAIM | ___GFP_DMA32

Somewhat debugging log:

[ 1914.214543] mhi_fw_load_handler:
[ 1914.220346] [Debug] dma_alloc_coherent cc0
[ 1914.220352] [Debug] dma_alloc_attrs cc0
[ 1914.220359] [Debug] __dma_direct_alloc_pages cc0
[ 1914.220360] [Debug] __dma_direct_alloc_pages cc4
[ 1914.220365] [Debug] __alloc_pages_noprof cc4
[ 1914.220367] [Debug] __alloc_pages_noprof allowed c04
[ 1914.220371] [Debug] prepare_alloc_pages allowed alloc_gfp = c04 alloc_flags = 1
[ 1914.220374] [Debug] prepare_alloc_pages allowed alloc_gfp = c04 alloc_flags = 1
[ 1914.220379] [Debug] __alloc_pages_slowpath [restart] gfp_mask c04
[ 1914.220381] [Debug] __alloc_pages_slowpath alloc_flags 840
[ 1914.220384] [Debug] __alloc_pages_slowpath: skipping direct compaction
[ 1914.220386] [Debug] __alloc_pages_slowpath [retry]
[ 1914.220387] [Debug] __alloc_pages_slowpath wake_all_kswapds
[ 1914.220836] [Debug] __alloc_pages_slowpath: [nopage] no page found
[ 1914.220839] [Debug] __alloc_pages_slowpath: GFP_NOFAIL not set

Just for experimenting even if I keep GFP_IO and GFP_FS enabled, kswapd's
waitqueue show that its already active.

Another hack which I've tested is by adding __GFP_NOFAIL with GFP_KERNEL, the
allocation worked this time. But kernel seemed to tried very hard and finally
found memory from somewhere.

Its hard to identify the actual issue.

Although its hard to reproduce (I've very strange reproducer), I've tested v6.15.11
and I'm not able to  reproduce the same issue there. So something has changed
which isn't triggering this issue. I plan to do bisection now. 

Please feel free to share if you think there can be something better to debug/bisect
it.

-- 
---
Thanks,
Usama


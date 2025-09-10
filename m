Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D5FBCA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 11:24:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C56AA8E000A; Wed, 10 Sep 2025 07:24:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2E388E0002; Wed, 10 Sep 2025 07:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1D4E8E000A; Wed, 10 Sep 2025 07:24:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9ED6B8E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 07:24:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C8BFC089B
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:24:15 +0000 (UTC)
X-FDA: 83873106870.29.A01EBC8
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf17.hostedemail.com (Postfix) with ESMTP id 592BA40009
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:24:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="UtO90H/m";
	spf=pass (imf17.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757503453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hrtmH798Erv7GjJYJan1U4WJPrIPUTjb3v/OuLlj2m8=;
	b=qNFXjUkOV7HvHoU9/eEa7PAtqyWDqSWvw8O6E9DQlXrmA381/Pmt50jZ5cHPGScZ4jbNkk
	qJ4r46lfknIyCqW7s4qvv6Vj6tPdebc7fFd5lhpmW+dEo4WwqNlb2H4tHAY1ENqZAPSUTg
	wTfxLEJtd6BiwpLMXB4q1v8iG23JNwU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757503453; a=rsa-sha256;
	cv=none;
	b=Z3ljdl4013/lgcThuBvNqZyMCMYMYYoPDp7+0chHRC90EtPiapuzf5CJe9LtkeLkWOFLjL
	/Z24TH1Naxx03QsYxILivlxGykLPQ6A9VUNl6V44mUjIT0VfAKqZ3dfzLvjBHyDSnUBVQL
	pfVlfO9/rvN27S700x+/scNZw2RP3dY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="UtO90H/m";
	spf=pass (imf17.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1757503450;
	bh=P2ESJC29I8UnEhT6Pn7PHdZu3AhPIr9M5gqZd4UMXsY=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=UtO90H/meAUnAuODWyWo3Z5NPS7ki/EXV6bucLdaaDj6J7tUVwZrTWSD/J2Xa/eaM
	 NLo7ZPJ03ZKqCd5MI0x9mMMSEBCFyRyt9EE2L6HZS4/khdEe7kYz+Nig99uf015EVM
	 2O/83OL/8MpNVBDDnDum7+fib8EnfOwQV7KK6LL8oIfy46Xn5FZWM4Yl4EFo9zftgi
	 5acqcwwAHl/MApQP09UNjlGl3DuOzdLkoDiDtLzlkincUYQzcmrPzJLSTOpKWmt8NJ
	 5m6bBTlVwjWH+MKOhuT1rai5sV3QmYZguaWo9vPTUgR7j/0bQbNGNFgSNVFtfCLg3u
	 Z1crDKqZnXdAw==
Received: from [192.168.100.50] (unknown [144.48.130.189])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: usama.anjum)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 1B55317E0202;
	Wed, 10 Sep 2025 13:24:06 +0200 (CEST)
Message-ID: <9dc9e324-4a39-43d0-8716-be325fae2247@collabora.com>
Date: Wed, 10 Sep 2025 16:23:37 +0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@collabora.com, Matthew Wilcox <willy@infradead.org>,
 Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
 Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
 Manivannan Sadhasivam <mani@kernel.org>, Jeff Johnson <jjohnson@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, kernel@collabora.com,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 iommu@lists.linux.dev, David Hildenbrand <david@redhat.com>,
 usama.anjum@collabora.com
Subject: Re: Excessive page cache occupies DMA32 memory
To: Robin Murphy <robin.murphy@arm.com>, Greg KH <gregkh@linuxfoundation.org>
References: <766ef20e-7569-46f3-aa3c-b576e4bab4c6@collabora.com>
 <aH51JnZ8ZAqZ6N5w@casper.infradead.org>
 <2025072238-unplanted-movable-7dfb@gregkh>
 <91fc0c41-6d25-4f60-9de3-23d440fc8e00@collabora.com>
 <2025072234-cork-unadvised-24d3@gregkh>
 <c93b34ca-1abf-4db0-90f9-3802ac02c25a@arm.com>
 <bdd1efa8-691c-4e84-8977-cdfd48e7363a@collabora.com>
Content-Language: en-US
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
In-Reply-To: <bdd1efa8-691c-4e84-8977-cdfd48e7363a@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ifqe4p84myo4hn8pfp5eycq3zorm8ojm
X-Rspamd-Queue-Id: 592BA40009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757503453-907741
X-HE-Meta: U2FsdGVkX18+0jBA7JyZO28AlgR8TcimTQZONakGQR1UPc0OcDSchpBa5LcWar08QUtXFOltC2bg46Jhexg032SV0iecRHwguD97/jwdM4ZJVzklK7FZqXVqTC29j1/8+XREDjW9VSn1CieX4kyfFirChaxFBH5dU0bHX24D9ZPUtqsDh7D36MHTemNdOdjI1Ka3IuaW8CDKaOihKgb7ANt6xaDZXAuQJKadWNzRqKtF6+6/KPlQxFBIHBiyxMUrk8DPbSfXfElmiUItBNKBCpxwfj2DzutMZjqe8zB/7AiIw1FVmqw12YpOuyAx9vmQzoL7PKoYB5a9ZQUJOQ5DKYMUZRp+da6TCAMq/snB366Oi/FeT9lpSa5/2Frd1X2uUzcprnrw7PLRu2AT02IhdIbv3zn8pjIpN5PLttZPRr6lshZ2dY6DjfrURg2MwWzDO/GyZ5lX6gBNL/bOhgC37hKJvpvcRouJ3vQ7uem4+qQ1YtskIVMtZLVrOPFa2FYSdfGeZoojDwxoCGEyQU1FkYIO7kUoLjmVJTrREGv7d9jgLT/F59DtoE7QiKn111ecBdXvWid1hUKrFCXhbScFsGB2Wv1ftPceeMHNknZcTLa+ptC6OOsy4uzXUcbFX5Myh2xpe9jP0+3i2dVZv2zTwAAYVsfFwAKCgPutCSUZ9L4NqvQ8PdrmidmoQ3ltTLVaJ0EEGubNIBGuln+lH9BqR12jKpgvZKP8+qazSAf7+RYifWGyAdxCAiWc+AUDgC2/k3byQ6ECM3itK3/gPAIE3rAvyqKB5zbUSRsO/bVCeW8BHIOdwNkWQOsuP4WiWtRJUpQaKPliP7Qxv39HVma3280J7o7QGUH9oagVVXOPyggZs7C//ne6dWgB7ObaiYKANODZzIU/MTN3r3AvHLr2hjx7hv0V9TJLQSVQoU0xrr8IQ84Pd7qkNjOak0xNZqbtQE2ka5QtyZL/RA7g3wZ
 N67HzmOK
 bToy5WMmPdEntGEYXoSgCvJvcXoo5VHaLV1LWrrsFCFVQ3CCZ6ltwqXy4WlFfyS3NSFBY3B37O8Z98mJ2p8pTiD1OWOaeCRsvAcFmNq55aCEgIOqBLm0V2hstcOal9EMs0/I1cgKLhn0DRcaEOC4UuI4U2oCA6SuiLdfcM0inKebK4omJTWUmyHOnuxqQxd5MLO/4g/vjI67xHRxWJyJDin2IGV86c9pqPxLdTI+gulFBp2p25GiR/vNo5nYyw3m0GJAtI5fA8uDBIGSbBvyYVQ5Ms5AATRETAwCpbIRSFiZkxnkNJhImkjhr/5UrCpA6O/bW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/21/25 6:39 PM, Muhammad Usama Anjum wrote:
> Sorry, it took some time to investigate.
> 
> On 7/22/25 3:03 PM, Robin Murphy wrote:
>> On 2025-07-22 8:24 am, Greg KH wrote:
>>> On Tue, Jul 22, 2025 at 11:05:11AM +0500, Muhammad Usama Anjum wrote:
>>>> Adding ath/mhi and dma API developers to the discussion.
>>>>
>>>> On 7/22/25 10:32 AM, Greg KH wrote:
>>>>> On Mon, Jul 21, 2025 at 06:13:10PM +0100, Matthew Wilcox wrote:
>>>>>> On Mon, Jul 21, 2025 at 08:03:12PM +0500, Muhammad Usama Anjum wrote:
>>>>>>> Hello,
>>>>>>>
>>>>>>> When 10-12GB our of total 16GB RAM is being used as page cache
>>>>>>> (active_file + inactive_file) at suspend time, the drivers fail to allocate
>>>>>>> dma memory at resume as dma memory is either occupied by the page cache or
>>>>>>> fragmented. Example:
>>>>>>>
>>>>>>> kworker/u33:5: page allocation failure: order:7, mode:0xc04(GFP_NOIO|GFP_DMA32), nodemask=(null),cpuset=/,mems_allowed=0
>>>>>>
>>>>>> Just to be clear, this is not a page cache problem.  The driver is asking
>>>>>> us to do a 512kB allocation without doing I/O!  This is a ridiculous
>>>>>> request that should be expected to fail.
>>>>>>
>>>>>> The solution, whatever it may be, is not related to the page cache.
>>>>>> I reject your diagnosis.  Almost all of the page cache is clean and
>>>>>> could be dropped (as far as I can tell from the output below).
>>>>>>
>>>>>> Now, I'm not too familiar with how the page allocator chooses to fail
>>>>>> this request.  Maybe it should be trying harder to drop bits of the page
>>>>>> cache.  Maybe it should be doing some compaction.
>>>> That's very thoughtful. I'll look at the page allocator why isn't it dropping
>>>> cache or doing compaction.
>>>>
>>>>>> I am not inclined to
>>>>>> go digging on your behalf, because frankly I'm offended by the suggestion
>>>>>> that the page cache is at fault.
>>>> I apologize—that wasn't my intention.
>>>>
>>>>>>
>>>>>> Perhaps somebody else will help you, or you can dig into this yourself.
>>>>>
>>>>> I'm with Matthew, this really looks like a driver bug somehow.  If there
>>>>> is page cache memory that is "clean", the driver should be able to
>>>>> access it just fine if really required.
>>>>>
>>>>> What exact driver(s) is having this problem?  What is the exact error,
>>>>> and on what lines of code?
>>>> The issue occurs on both ath11k and mhi drivers during resume, when
>>>> dma_alloc_coherent(GFP_KERNEL) fails and returns -ENOMEM. This failure has
>>>> been observed at multiple points in these drivers.
>>>>
>>>> For example, in the mhi driver, the failure is triggered when the
>>>> MHI's st_worker gets scheduled-in at resume.
>>>>
>>>> mhi_pm_st_worker()
>>>> -> mhi_fw_load_handler()
>>>>     -> mhi_load_image_bhi()
>>>>        -> mhi_alloc_bhi_buffer()
>>>>           -> dma_alloc_coherent(GFP_KERNEL) returns -ENOMEM
>>>
>>> And what is the exact size you are asking for here?
> 512 KB
> 
>>> What is the dma ops set to for your system?  Are you sure that is
>>> working properly for your platform?  What platform is this exactly?
> Its x86_64 device.
> 
>>>
>>> The driver isn't asking for DMA32 here, so that shouldn't be the issue,
>>> so why do you feel it is?  Have you tried using the tracing stuff for
>>> dma allocations to see exactly what is going on for this failure?
>>
>> I'm guessing the device has a 32-bit DMA mask, and the allocation ends up in __dma_direct_alloc_pages() such that that adds GFP_DMA32 in order to try to satisfy the mask via regular page allocation. How GFP_KERNEL turns into GFP_NOIO, though, given that the DMA layer certainly isn't (knowingly) messing with __GFP_IO or __GFP_FS, is more of a mystery... I suppose "during resume" is the red flag there - is this worker perhaps trying to run too early in some restricted context before the rest of the system has fully woken up?
> 
> So GFP_KERNEL gets converted to only GFP_RECLAIM as GFP_IO and GFP_FS
> are disabled by the pm subsystem at suspend time and they are only enabled
> after the system has woken up.
> 
> GFP_FLAGS
> 0xcc0		GFP_KERNL = GFP_RECLAIM | GFP_IO | __GFP_FS
> 0xcc4		GFP_RECLAIM | GFP_IO | __GFP_FS | ___GFP_DMA32
> 0xc04		GFP_RECLAIM | ___GFP_DMA32
> 
> Somewhat debugging log:
> 
> [ 1914.214543] mhi_fw_load_handler:
> [ 1914.220346] [Debug] dma_alloc_coherent cc0
> [ 1914.220352] [Debug] dma_alloc_attrs cc0
> [ 1914.220359] [Debug] __dma_direct_alloc_pages cc0
> [ 1914.220360] [Debug] __dma_direct_alloc_pages cc4
> [ 1914.220365] [Debug] __alloc_pages_noprof cc4
> [ 1914.220367] [Debug] __alloc_pages_noprof allowed c04
> [ 1914.220371] [Debug] prepare_alloc_pages allowed alloc_gfp = c04 alloc_flags = 1
> [ 1914.220374] [Debug] prepare_alloc_pages allowed alloc_gfp = c04 alloc_flags = 1
> [ 1914.220379] [Debug] __alloc_pages_slowpath [restart] gfp_mask c04
> [ 1914.220381] [Debug] __alloc_pages_slowpath alloc_flags 840
> [ 1914.220384] [Debug] __alloc_pages_slowpath: skipping direct compaction
> [ 1914.220386] [Debug] __alloc_pages_slowpath [retry]
> [ 1914.220387] [Debug] __alloc_pages_slowpath wake_all_kswapds
> [ 1914.220836] [Debug] __alloc_pages_slowpath: [nopage] no page found
> [ 1914.220839] [Debug] __alloc_pages_slowpath: GFP_NOFAIL not set
> 
> Just for experimenting even if I keep GFP_IO and GFP_FS enabled, kswapd's
> waitqueue show that its already active.
> 
> Another hack which I've tested is by adding __GFP_NOFAIL with GFP_KERNEL, the
> allocation worked this time. But kernel seemed to tried very hard and finally
> found memory from somewhere.
> 
> Its hard to identify the actual issue.
> 
> Although its hard to reproduce (I've very strange reproducer), I've tested v6.15.11
> and I'm not able to  reproduce the same issue there. So something has changed
> which isn't triggering this issue. I plan to do bisection now. 
> 
> Please feel free to share if you think there can be something better to debug/bisect
> it.
> 

Another update:
This issue reproduces on v6.11.11. To summarize, we're unable to reproduce
this bug in the v6.15.9. We wanted to do bisection and find out which kernel
change has caused/fixed it, but it's too difficult considering the complex
reproducer setup (Tekken 8 Demo game + page cache stress). We don't want to
spend more time on something that is very hard to reproduce and is already
fixed in later versions.

My debugging has shown in v6.15.9 that the allocation succeeds under the same
constraints of power management. My hunch is that somehow the dma memory
doesn't get occupied to the extent that dma allocations start to fail at
resume in v6.15.9.

---
Thanks,
Usama


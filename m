Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 489D0D2F33D
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 16:14:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798176B0005; Tue, 13 Jan 2026 11:14:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71C206B0089; Tue, 13 Jan 2026 11:14:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61A546B008A; Tue, 13 Jan 2026 11:14:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53A206B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:14:53 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D33D11AD38F
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 16:14:52 +0000 (UTC)
X-FDA: 84327439224.16.BA82789
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 901B240008
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 16:14:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768320891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=grpK3sKJCCeVUmBCgCUe06IiioitVuAU8ZSO0bfQUTc=;
	b=CVjYOmyA6LUzODkc12r+o2ntgCy8kQIKT5AqAq97mcPeIr9XmR7uu/+QvcDHVD2biW2fdN
	H1/e5VFkzzb55OV7n0wbYWmZovsojUpuAafwTD43kDJ2KF+rXvx9owOqFMP4uEnTMLJ2fo
	IrMIoS+of0GvOJRSYU/yV4RMOLuoDtM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768320891; a=rsa-sha256;
	cv=none;
	b=2r67RbM7dvU48Tpiv2vB+hkzF1UMT1ytXdpXFplTQsJ1BtLCSzYsm01sxGBmhcJ4bzOtwe
	VbVy55bCoqSqanbU2EOvwXp0xzoeNmM+NH/+PiRoJ+MijwXHLv4MqaxpPMmcqSsuu82bPV
	lXAWN4bgZAuFOZSVA8kOgSyE3sOHxhw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B9226497;
	Tue, 13 Jan 2026 08:14:42 -0800 (PST)
Received: from [10.57.46.249] (unknown [10.57.46.249])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 900693F59E;
	Tue, 13 Jan 2026 08:14:46 -0800 (PST)
Message-ID: <8d0c7b1c-fc12-4498-acbb-eaf6cab9ef3f@arm.com>
Date: Tue, 13 Jan 2026 16:14:44 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] dma/pool: Avoid allocating redundant pools
To: Baoquan He <bhe@redhat.com>
Cc: m.szyprowski@samsung.com, akpm@linux-foundation.org, vbabka@suse.cz,
 david@kernel.org, iommu@lists.linux-foundation.org, linux-mm@kvack.org,
 vladimir.kondratiev@mobileye.com, s-adivi@ti.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com
References: <cover.1768230104.git.robin.murphy@arm.com>
 <8ab8d8a620dee0109f33f5cb63d6bfeed35aac37.1768230104.git.robin.murphy@arm.com>
 <aWYbcnglF5P/WhL4@MiWiFi-R3L-srv>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <aWYbcnglF5P/WhL4@MiWiFi-R3L-srv>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cihdwjm5kchyfccmzrjupshfm136aodu
X-Rspamd-Queue-Id: 901B240008
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768320890-175415
X-HE-Meta: U2FsdGVkX180zYNWVMaLsKjbI0iDWt6vG7wUrtcdckPNY2N708M0a6iidmhT0Pxt0DHhIeTmJTscS9tq9CEBSUfP+hmn3SwLQEaOeKg+Vdpic5zmOPhwqyccC6AeDFbTvjByMl0GM0XjYKg7aiMN2zQtLiVfyrM1diWIIAumO0KZCEK25h/0gQLTgqoJyIljOYzyh953psBIGbCovoWQnLks1PHosR6p6ONxHzglH/QoyDaV8D+enBZNXI3yMZJn8cpcUcJ5vHwRx+yTkZwfNjbiYmruZcvJmVLjdvEbqxeQJ85rDQzpmbu9c61H6ofBuBOkTpacq1OBwdm3jPuKFNKXqBqcCvDBP/6bCzQj7aGgZlpLMR8Y1IWQr7ukiA9WsyGMbPDchUtYkjRl2N0wag7fts/IV3IivLjKryZDpYGxrulNI1V97IpUXJV1MWbRaHu6CZH6+v+/UNAfRV5mcBiANjkmzVa2IirHMsZt47Y4+msrSwlmaGw1F6CDyylkhL0wjK4TwCI8lXL6okUyOa8/lcBleZ+R69/QUBzANbc4RjO3RiQ040uVCaAyRkRnr8tcUI/ynFS7BIAG4zcGzSYDScNnYaVcmSjjd2ptwdpndGlnvKSgxnXww28AG662nHvydIrFVMYbIuBDBAIQLoStt1U9VFV3xL4OXCu5ZwiH0u0ov7MNLicqUEaaWR2MqsIWBfxkVXvKpc9xi1j832cEXVeqgK8ObbWBaZ0P0pcErN/Wp9wVn5kueNoWT9JBHAMIWPz7utpCtiSq0viNpSgcu2kodikfUhNLNtHTxQSMPvb9T+1bbi9OX4Q7J3MdFyZaLIgLELJPUq5Y2niNNGRgAySSuq8nwQqDe2dIAfGS+qRV6fHe0aIaU0D73WmDe1IrW9F9ZN534MiUkBSUYc7Pf6PPHmT4z9vA0xaSlYruv0W27Ow992f/2lRmn/HX0FRn8lRXQlK2WmbiKRn
 RXLMOX6P
 y+zZ6bWBYf6DArFCuL8a5nmAliZRwo7VPo7mP4mMbGlmlT0+zKxWUBJaeoycXoZRpzg+v/+ZowAkt/6L6C/IVfh/DuSeNFnwWLPd62qijyRHBHA9kUQE0laqU73rHMG8LnWXJXncYaxkwk4dZY3nC22m4MMFTOGfCJ2fcJwXTMwfPw8kjuk7QLajVHVvan+j/WAC94lFDNZaxteY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-13 10:16 am, Baoquan He wrote:
> On 01/12/26 at 03:46pm, Robin Murphy wrote:
>> On smaller systems, e.g. embedded arm64, it is common for all memory
>> to end up in ZONE_DMA32 or even ZONE_DMA. In such cases it is redundant
> 
> This is true and the whole series looks great to me. Do we need adjust
> warn_alloc() to handle empty DMA32 zone too like empty DMA zone case?

Hmm, I'd be inclined to think that if nobody's complaining already then 
we can probably just leave it as-is. A GFP_DMA32 allocation won't OOM 
unless *both* ZONE_DMA32 and ZONE_DMA are empty, right? At that point 
I'd imagine it's a bit more significant if someone who wants DMA32 
memory can't have any - don't we have a mechanism for reserving some 
"low" memory for kdump for pretty much this exact reason?

A special case for when ZONE_DMA is tiny such that GFP_DMA can be 
expected to fail often seems fair, but in general I'd expect that if 
GFP_DMA32 starts failing then it's more a sign of a genuine mismatch 
between the kernel's expectations and the system configuration.

Thanks,
Robin.

>> to allocate a nominal pool for an empty higher zone that just ends up
>> coming from a lower zone that should already have its own pool anyway.
>> We already have logic to skip allocating a ZONE_DMA pool when that is
>> empty, so generalise that to save memory in the case of other zones too.
>>
>> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
>> ---
>>   kernel/dma/pool.c | 19 ++++++++++++++-----
>>   1 file changed, 14 insertions(+), 5 deletions(-)
>>
>> diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
>> index 2645cfb5718b..c5da29ad010c 100644
>> --- a/kernel/dma/pool.c
>> +++ b/kernel/dma/pool.c
>> @@ -184,6 +184,12 @@ static __init struct gen_pool *__dma_atomic_pool_init(size_t pool_size,
>>   	return pool;
>>   }
>>   
>> +#ifdef CONFIG_ZONE_DMA32
>> +#define has_managed_dma32 has_managed_zone(ZONE_DMA32)
>> +#else
>> +#define has_managed_dma32 false
>> +#endif
>> +
>>   static int __init dma_atomic_pool_init(void)
>>   {
>>   	int ret = 0;
>> @@ -199,17 +205,20 @@ static int __init dma_atomic_pool_init(void)
>>   	}
>>   	INIT_WORK(&atomic_pool_work, atomic_pool_work_fn);
>>   
>> -	atomic_pool_kernel = __dma_atomic_pool_init(atomic_pool_size,
>> +	/* All memory might be in the DMA zone(s) to begin with */
>> +	if (has_managed_zone(ZONE_NORMAL)) {
>> +		atomic_pool_kernel = __dma_atomic_pool_init(atomic_pool_size,
>>   						    GFP_KERNEL);
>> -	if (!atomic_pool_kernel)
>> -		ret = -ENOMEM;
>> +		if (!atomic_pool_kernel)
>> +			ret = -ENOMEM;
>> +	}
>>   	if (has_managed_dma()) {
>>   		atomic_pool_dma = __dma_atomic_pool_init(atomic_pool_size,
>>   						GFP_KERNEL | GFP_DMA);
>>   		if (!atomic_pool_dma)
>>   			ret = -ENOMEM;
>>   	}
>> -	if (IS_ENABLED(CONFIG_ZONE_DMA32)) {
>> +	if (has_managed_dma32) {
>>   		atomic_pool_dma32 = __dma_atomic_pool_init(atomic_pool_size,
>>   						GFP_KERNEL | GFP_DMA32);
>>   		if (!atomic_pool_dma32)
>> @@ -228,7 +237,7 @@ static inline struct gen_pool *dma_guess_pool(struct gen_pool *prev, gfp_t gfp)
>>   			return atomic_pool_dma ?: atomic_pool_dma32 ?: atomic_pool_kernel;
>>   		if (gfp & GFP_DMA32)
>>   			return atomic_pool_dma32 ?: atomic_pool_dma ?: atomic_pool_kernel;
>> -		return atomic_pool_kernel;
>> +		return atomic_pool_kernel ?: atomic_pool_dma32 ?: atomic_pool_dma;
>>   	}
>>   	if (prev == atomic_pool_kernel)
>>   		return atomic_pool_dma32 ? atomic_pool_dma32 : atomic_pool_dma;
>> -- 
>> 2.34.1
>>
>>
> 



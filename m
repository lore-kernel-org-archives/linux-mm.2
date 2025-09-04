Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90108CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 01:15:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB63A8E000C; Wed,  3 Sep 2025 21:15:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E65A78E0001; Wed,  3 Sep 2025 21:15:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA2748E000C; Wed,  3 Sep 2025 21:15:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CB1878E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 21:15:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 80F281A094A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 01:15:29 +0000 (UTC)
X-FDA: 83849799978.24.3A84DF4
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8E91C20005
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 01:15:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="K/WWgiAD";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.219.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756948527; a=rsa-sha256;
	cv=none;
	b=KSOMpnHedQv6fy/uXv2SL6+SXW9yTdzP59jb1DIJHlyyjhuHv/kBJV2ck11fz551S0b4f9
	E4VMI0EyjShiM1CHjRJyQPE2+qm62ywdTg3ml4qGjnjVt9AvfsLoptsCxyj0aBeb6VWOKj
	vlwayQsriat5NhTslUfcoMD83214uUA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="K/WWgiAD";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.219.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756948527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v2bKdcT7iTL0M0foBoGAazsId5D8WGbE87p97GeaaRA=;
	b=ERq/B/JH/X97P8KdSDXuY/KSDijxnay77abqSQvofUPh5QQInLQDJaxWonusssXviOUMAU
	whNn23XxrxsKT1iXAOXgaYHUq4p5Oeh54igAbNbDwVNFfhlzrKeeLU6DWfYYD2YbwobpRx
	36FFfe89GSyvbK0NzsQ9Q8UTbBWgOMM=
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e97021a3695so532017276.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 18:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756948526; x=1757553326; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v2bKdcT7iTL0M0foBoGAazsId5D8WGbE87p97GeaaRA=;
        b=K/WWgiAD4xoATXU+4A2UoJ/WY3+gNbgzn17KFtbXAHpbsJHKT90wbeMlADtRb6XRXS
         57zbqrcBuvjhbzN8TFBE61s26IEAGv/C/OiWjDrCtWGGG9tLaYVxS40a+gOTlk9Uw2+1
         v2zeypnLIQvPBF202DGjIsi4s5TFqbn2CIIc2KoSf9jcBxdG672AIbI28LI2l/S/lPrC
         XkokUke/oGqWZsHmlbkNP7yjNp6xeHjkvSgWaarikMzk3safuZrFieJEFhnoPPiAp0eN
         lOmqF3DCJT9h4qRTC/PQsOW/0fiw5PVLJ/y1se12qGWlhkO11ISj5JRZ1vCqJRajUlwK
         Spdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756948526; x=1757553326;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v2bKdcT7iTL0M0foBoGAazsId5D8WGbE87p97GeaaRA=;
        b=efDXnSFYnjOeMjQqW87midJW7izb47tmraQapLN0fLfLm0p4sQDwgrSO0snta2uqBj
         CHO79Il2p+yqshPldfMI6wMIJcqNFSylA8JfCTjXGorL3G9xzIeYBVaomWwpd4IA2gAA
         ynrwTAZUwSLvG+zzFvCZbLExWFCAH3NMTSFf159gwbYdepieBttlFDeNX/zlW2LFuQcF
         AvaGvdyjxkzKrykk/JnaPyBIRCRxOHgmBi83v33tNaG/f0dJR8Nihvix9S3R6ZodgCtq
         2raemmWqrEqLs57nN+j+gbysQT6jhlF/Jk8d486diNWpOgq6dj5AEhvuYYb8e5SP5Q/q
         4IHA==
X-Forwarded-Encrypted: i=1; AJvYcCXzSRpqGWZzQ3sWNTT60aG9ZTBNiv3sU0QsFMoDkxU1aAH/mCFvDmfBEHY12ZSJClZKyylbP2+ssg==@kvack.org
X-Gm-Message-State: AOJu0YxAVu2THhvbddiMxb5sEjgyg/aSQM2cPoXfwF4PnLNFuBfP5r1c
	GZCP6tG7ClKwHWgL0DAih7SAF9Is14cFeyntqx+T94UtXgpwqvVO/HJQ
X-Gm-Gg: ASbGnct89OPuE5c5vJyFq7W7tf2BKCWgtr4L7hmqDp52btxTZT7Yuodm2YQ/KSwlMmv
	tQc2qtjZQ2aT9SqngHEmQqKaV3rpjuTJFz90VyW/vdVmm76CHX3Dh5WjCrqzuzG4rGOornpxRQj
	xDYZiLPl4ehat1sROkk0uOXkJXrrFTWEI+AviivreS68QuuHshFRoLXBwjVnRZvP5JTK7YDS+uT
	jm4oQ3SKf+KaT7hSNg0Rkgk6XNOxE0em5YyFzUVr+hFPfj+uolQc8gh7MTgyOQboIdnuTGAUBqF
	+AM1/hXzaG6SWq4CmAdKYxI/PeFziQetLP2rLJYIvCfuODTLgCPRQ3VPfTuHnqs+IEp3GK6R44n
	UbKEq7RiPzqhZJqZgAxqe58Fa/fTNPS3UMSFFSHtQtQtr1Kejwjs=
X-Google-Smtp-Source: AGHT+IEk/3J2EywD3d03w2jHZI+Qv8mu+ar25YB1ZQ39f5q83vbIDxKz9WBUw4aesQ9/JWtxW19TvA==
X-Received: by 2002:a05:690e:4107:b0:606:29d6:64ef with SMTP id 956f58d0204a3-60629d669ebmr1846046d50.15.1756948526207;
        Wed, 03 Sep 2025 18:15:26 -0700 (PDT)
Received: from [127.0.0.1] ([45.142.167.196])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a83295b7sm17979517b3.24.2025.09.03.18.15.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 18:15:25 -0700 (PDT)
Message-ID: <6a874eff-f740-4a08-b669-eaa3be3be5af@gmail.com>
Date: Thu, 4 Sep 2025 09:15:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/13] x86/HWBP: Add arch_reinstall_hw_breakpoint()
 for atomic updates
Content-Language: en-US
To: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: akpm@linux-foundation.org, naveen@kernel.org, davem@davemloft.net,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20250818122720.434981-1-wangjinchao600@gmail.com>
 <20250818122720.434981-2-wangjinchao600@gmail.com>
 <20250818122720.434981-3-wangjinchao600@gmail.com>
 <20250901160602.e25f0107e7b0ef4af1078fb7@kernel.org>
 <284d5eef-447f-4e12-a121-3742d708c96f@gmail.com>
 <20250902231152.442041a74774d888cec39201@kernel.org>
 <5a6dde06-11ee-4ce7-9cb5-f0b8096e42ed@gmail.com>
 <20250904100231.e0bb08d069db31520a6e0435@kernel.org>
From: Jinchao Wang <wangjinchao600@gmail.com>
In-Reply-To: <20250904100231.e0bb08d069db31520a6e0435@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8E91C20005
X-Stat-Signature: y8gnxxrf7ku4f8bgepponjyu8quuqgdc
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756948527-275655
X-HE-Meta: U2FsdGVkX1+VYDe+B2H7cv6vrnaDPlPRmB9WSqK5mJ9C0t7SgOZozzQBmEW+EXdkS3omDj6hqvjIewNNz1SLV1Wr2IKNqwg6Lg+gn4E84lRDnxMy4hfyia6mBJVvnT1vfvtm5x/TTHqxOyOb8+Kx/Se0wy5PXLZPB50LIDDP4csCqRcC8FMyjMwKk/nWbrQjO4V1qqe/1GhgXwvC4gx0m8hELLIQuz0pCxgN8knvToTQADb3U1vh/e5mtNdv08YDfzb5qLcqkW1j8qnA+tbAGXkPdGjY22oyDbXDNrA4PeHccRD4UztJ/BUOfUMGTFpiyOD2qlRVdrH73VOx7y+2W7ryNWC5yp3AJV75jGbEDE38rbSJDwH6Mc4+nNrE7mtUreaNfm2KD7EXpEkLvzqI1QBnmd6hw8567jOb900Ew0z/0GAvPVQQ1BdAE/AYpXRuDaZ6XqI6Pq777bJbA59cNLZBTPiuOCOEZjuBqS1IOd6YUiTGr8DGoquc//NNRG3brFUjJ2rIy/lnchBxDnQuZFSWhTMRu/68WrPJemybRxPK2vfFt8eM7kGwVnGClbzeMhrCfY1DWvqD7ZyDSLijOrHLFhQUiSSzx+25JSDtZVIPd107z/2N5NW+yykJJRQomaPGedwZdPB481WFZzeTh4fslt0VTe6qYgRB62bYA3aigca/QR84+dAeNh1ykUY1b6bIbgJ13ZAUvokJpOYci19BQzwBRVLx33SsWWCVK5w5cMD/+wslnCur323+GZkbjy8o9kF+NDIFMIzbgeqc0O/x08Yu0U4qdjFWYByTVk9iX4d176a1VmOSISKAMO57Q/iFmFosgIWcR2OqJRbcw/qpSh9rfS9x5jCaAuts0UsxONp15TQM1U9E3G0B+XnQUavbiGcfMd2rkCRUWyQB0FkDJN0wVkVvatRRfkDeo8WahJ2uyAeBJUTZg6qQEggznw/CFB61+VIl4o/pVNa
 GgoAV7dT
 lJqAQkJRvT1GTZq97NcpxNhp4ZDcDzmvNaD5mo6dBFwrvD6uCxjQyU/c7BtryQX0X6HUlKIy76dLXFVN6wpY6PwJRozZBmxVrw6kq5hMKfwE9TWFJWOmquBmP8p2F3i0sTO0Jdp9sAQZvecbFEz3uGMZWI0lfXlSWhZDSSiiFW421rbcCJVYCn9e4O6o8+gUx4J+l6Ias1KaDOtPTC00W0M0a8vBLIWmTGzJ3Eqsrjfn1+fAsDFbu5m7nrzXTxmwUipau/BO0L9SGgkkg4NFBfNyYrmXaO6EIWQncndcrahf/NbH4/xZVk9Tpc9QjbGLTAykEKGT3DZODiVt1QjG5reJn+XWnLdwKLycbbwe0Cp+2Q7VHfxPM9TqvIPzNOWq1bg/00mp/36cuWE+16JH4AeDSeIsGQ4bI8AhC+syJb0gUWuiMNyHq7jm0NtLGTJQFUuhLOWM9tsfS7uqFRUvOxLCPVBx6RqMjXOwX5DJ7pGCrAhAfl/hUjbadB/HIwD9S1aiENupgN6LYDQc0bRUj5rqN4teZhDn/Nb0VibdsQ0wRsK+01z6fggVKpLGsZCgl80/B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/4/25 09:02, Masami Hiramatsu (Google) wrote:
> On Wed, 3 Sep 2025 15:58:44 +0800
> Jinchao Wang <wangjinchao600@gmail.com> wrote:
> 
>> On 9/2/25 22:11, Masami Hiramatsu (Google) wrote:
>>> On Mon, 1 Sep 2025 18:23:44 +0800
>>> Jinchao Wang <wangjinchao600@gmail.com> wrote:
>>>
>>>> On 9/1/25 15:06, Masami Hiramatsu (Google) wrote:
>>>>> Hi Jinchao,
>>>>>
>>>> Hi Masami,
>>>>
>>>>> On Mon, 18 Aug 2025 20:26:07 +0800
>>>>> Jinchao Wang <wangjinchao600@gmail.com> wrote:
>>>>>
>>>>>> Add arch_reinstall_hw_breakpoint() to enable atomic context modification
>>>>>> of hardware breakpoint parameters without deallocating and reallocating
>>>>>> the breakpoint slot.
>>>>>>
>>>>>> The existing arch_install_hw_breakpoint() allocates a new debug register
>>>>>> slot, while arch_uninstall_hw_breakpoint() deallocates it. However, some
>>>>>> use cases require modifying breakpoint parameters (address, length, type)
>>>>>> atomically without losing the allocated slot, particularly when operating
>>>>>> in atomic contexts where allocation might fail or be unavailable.
>>>>>>
>>>>>> This is particularly useful for debugging tools like kstackwatch that
>>>>>> need to dynamically update breakpoint targets in atomic contexts while
>>>>>> maintaining consistent hardware state.
>>>>>>
>>>>>
>>>>> I'm also trying to find this interface for my wprobe. So the idea is good.
>>>>> But this looks hacky and only for x86. I think the interface should be
>>>>> more generic and do not use this arch internal function directly.
>>>>>
>>>>
>>>> I agree with your point about the architectural dependency. I have been
>>>> considering this problem not only for the hardware breakpoint
>>>> reinstallation,
>>>> but also for other related parts of the series, such as canary finding and
>>>> stack address resolving. These parts also rely on arch-specific code.
>>>
>>> Yes, even though, the hw-breakpoint is an independent feature.
>>> Directly using arch_*() functions (which are expected to be used
>>> internally) introduces a hidden dependency between these two
>>> components and looses maintainability.
>>
>> Yes, I am trying to improve this in the v3 series.
>>
>>>
>>>>> It seems that the slot is allocated by "type", thus, if this reinstall
>>>>> hwbp without deallocate/allocate slot, it must NOT change the type.
>>>>> See __modify_bp_slot. Also, provide CONFIG_HAVE_... option for checking
>>>>> whether the architecture support that interface.
>>>>>
>>>> Regarding the slot allocation, I would like to clarify my point. I
>>>> believe the
>>>> event->attr.type should not be changed when reinstalling a hardware
>>>> breakpoint, as this defines the fundamental nature of the event. The type
>>>> must always be PERF_TYPE_BREAKPOINT.
>>>>
>>>> The event->attr.bp_type, however, can be changed. For example, from a
>>>> HW_BREAKPOINT_W to a HW_BREAKPOINT_RW without needing to deallocate and
>>>> reallocate the slot. This is useful for future applications, even though the
>>>> current use case for KStackWatch only requires HW_BREAKPOINT_W.
>>>
>>> I understand your point, so it also needs another wrapper which checks
>>> the type is compatible on the architecture.
>>>
>>
>> I think the wrapper should handle the type by type_slot, something like[1]:
>>
> 
> Ah, that's a good idea!
> 
>> diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
>> index 1db2c5e24d0e..6fed9521baf2 100644
>> --- a/kernel/events/hw_breakpoint.c
>> +++ b/kernel/events/hw_breakpoint.c
>> @@ -752,6 +752,7 @@ modify_user_hw_breakpoint_check(struct perf_event
>> *bp, struct perf_event_attr *a
>>    {
>>    	struct arch_hw_breakpoint hw = { };
>>    	int err;
>> +	enum bp_type_idx old_type_idx, new_type_idx;
>>
>>    	err = hw_breakpoint_parse(bp, attr, &hw);
>>    	if (err)
>> @@ -766,7 +767,9 @@ modify_user_hw_breakpoint_check(struct perf_event
>> *bp, struct perf_event_attr *a
>>    			return -EINVAL;
>>    	}
>>
>> -	if (bp->attr.bp_type != attr->bp_type) {
>> +	old_type_idx = find_slot_idx(bp->attr.bp_type);
>> +	new_type_idx = find_slot_idx(attr->bp_type);
>> +	if (old_type_idx != new_type_idx) {
>>    		err = modify_bp_slot(bp, bp->attr.bp_type, attr->bp_type);
>>    		if (err)
>>    			return err;
>>
>> For kernel breakpoints, we might also consider introducing a
>> modify_kernel_hw_breakpoint() helper, similar to
>> modify_user_hw_breakpoint(), to encapsulate the kernel-specific case.
>>
>> [1]https://lore.kernel.org/all/20250903075144.3722848-3-wangjinchao600@gmail.com/
> 
> Hmm, it seems that there is *user_hw_breakpoint() and *wide_hw_breakpoint()
> (maybe it means system-wide) so it is better to call modify_wide_hw_breakpoint().
> (anyway it is only for kernel address space...)
> 
> Thank you!

The counterpart to user might be kernel, and wide likely means "for all 
CPUs".

We might have missed each other's emails due to the time zone 
difference. Thank you so much for your feedback.>
>>
>>>>
>>>> By the way, I have sent an updated series.
>>>> https://lore.kernel.org/all/20250828073311.1116593-1-wangjinchao600@gmail.com/
>>>
>>> Yeah, OK, let me review the series. Thanks for update!
>>>
>>>>
>>>> Thank you again for your valuable review.
>>>> -- 
>>>> Best regards,
>>>> Jinchao
>>>
>>>
>>
>>
>> -- 
>> Best regards,
>> Jinchao
> 
> 
-- 
Best regards,
Jinchao


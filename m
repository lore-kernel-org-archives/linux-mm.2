Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02AD3CA1010
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 00:53:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F9008E0008; Wed,  3 Sep 2025 20:53:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D0908E0001; Wed,  3 Sep 2025 20:53:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50DC18E0008; Wed,  3 Sep 2025 20:53:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 412858E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:53:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E375E1DEEED
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:53:56 +0000 (UTC)
X-FDA: 83849745672.01.B4714F2
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf10.hostedemail.com (Postfix) with ESMTP id E224BC0004
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:53:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P2CH+oZc;
	spf=pass (imf10.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756947235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fpt21/2dXymrTrGtlDxkh6WDP5Hwjh1uV/oV9OO6L3Q=;
	b=hGUwVY//bwWqrETGsmo7btV+mjpjAe+W0hrR/fvB0KXTUUqpatpkjf6P61eD0yESXyNRon
	RrNq5uVBiFXPmhlIWJSA0yKbeJqx3XoL0yreY8GSLf+Scc53fJdY+tJV5yc41ZiIkAq0mG
	KnN8xuSaUYU+Qg5CgBSw82TAp9by0To=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P2CH+oZc;
	spf=pass (imf10.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756947235; a=rsa-sha256;
	cv=none;
	b=diDcggGEQn3jWwJPnLSp1YjoKFbBsP2AtjDB+DVEf5PwODV4KNfBQhShwGIS9AEXQ2QIlg
	QL5IaO0sl54O/PdXsM2J1rRQpvPET5AwDhUlUklGjm+mtQcm+qvsAP07XWWewWTnH8FSMx
	fnXDGYQxKBM3hL5MYjgqHpoWaxjMCAc=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-32b590d819aso345768a91.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 17:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756947234; x=1757552034; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fpt21/2dXymrTrGtlDxkh6WDP5Hwjh1uV/oV9OO6L3Q=;
        b=P2CH+oZcn9Ud+i2jSbj8k/2/EvYkwgTeOBN0z7RbIp7Qf8/AjpUq62rLNBm7UrQNyH
         RIJL686K1WCFnecW6UMnpC1Uq+d2YrSbgNRQZVbmdARYNSxwi2aFJBI83RQHcisuKeFd
         jztaKxIbjPj7Go4v9AUIAJRbwse8pnhatWGZ4/vmkq3imAg96rTonkJDhuaWruKNm/5a
         9S8dpJoKyOd79g0XFb3p2UFHJ9CpHK8WwO1z5pupWf+q0FxkWsu1+HmFHU3t6kow4Sev
         vTLopiUEzaVvrOIRWZw27iPhp3UJFzQEiiAxfoe9m+sXd0tdHZdK3lNF+6V5+Nlw78iR
         +E+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756947234; x=1757552034;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fpt21/2dXymrTrGtlDxkh6WDP5Hwjh1uV/oV9OO6L3Q=;
        b=g3U6ddAOWCBzINjtMaJhxk0otvfF16tuSDoFHCAl+caTW+4J2N+YxJVPpI5FympN05
         8uWgiqTN0cWRd+B+vlP+Q1NFz2kRPeluOsIGhb9mkfy1BwCfATOIFyeN8jBFUSZ8l5t1
         EsjBXjV+3o2KqSBL/cqOnI+FoaVxAWBWst4RoWwoJW5iDJhaNeg/G7P+B0F4DDPChpN+
         LlFvVNm+Ya+VgyN3RR93GLlymEUStkrT3s/aLBkY/mAV/DlAmf+6lDL5OlduGyHbzy6c
         Nwsqy9Bfc9Bpii3FKvcte119HC469G/9SO/tDDjF9+xnS1y6O8+SRs9Jmqvq7LsmGA6I
         VoTg==
X-Forwarded-Encrypted: i=1; AJvYcCWipGkZRVD4cqo65Vj+h6tXsJ5AmasnAfrVkXBy4euTWeQYtkQvHLmM4uF4wuxDp0mLH2ChgW8CyA==@kvack.org
X-Gm-Message-State: AOJu0Yz2qQmeMR2cJEl3dsAH8zVUNiMxWbXhtJm59YYfn5nCvcLgculy
	4esBz7OrFFlEILMkgSn0ko130rwY34rLIB0fk7etx19YKeCbci5gLSUz
X-Gm-Gg: ASbGncs6yh12Je13klJ9fYuClZV1PT3cIHOO8tE1P1ktB82GEa+nAoeGTSPeH/XoDGD
	mXAjZooj19vVDQd27xneIigFzsJmat+hNZxNmg/zhxcSCqBuwmYrE4cWKiE5XYZPkXPomjcYUtl
	Ggmiqcdw8SbZwhaBo8oPYe6uPTeDubOVTymPHnoUKDgMSW38TiaPD9t9/7tELXE4OcFZEXvGjBq
	1Fo94LGqaxpMkAD48/VRn9vX6fFeTxoLpqgn5aZLt/NWEwdi8IE+K+UERktvz7pn0aFZy7moGb3
	9LIYtJAWVMwyN0VdYXV+B6nzbEZv40AtNg0QgPE11dYZeY/WrsHjGBAYiYzsm5QwKktprDl9FMG
	hsy8z9GAjc8eNVst/f4fmvmi+ouLUpC2Dhm7s
X-Google-Smtp-Source: AGHT+IFS6U7cNiPi3jk1jx6kSKBR1YaQ2RMeDyXRDytuUUaEbR8NxZhWZ1vHQ4n9l+d2nUGFpF4tHw==
X-Received: by 2002:a17:90b:3bc7:b0:32b:97f8:d3fe with SMTP id 98e67ed59e1d1-32b97f8d486mr180700a91.6.1756947233684;
        Wed, 03 Sep 2025 17:53:53 -0700 (PDT)
Received: from [127.0.0.1] ([45.8.220.62])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3299739e0aesm11478253a91.8.2025.09.03.17.53.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 17:53:53 -0700 (PDT)
Message-ID: <4ed45039-63c6-4639-b73c-7121d419a8d5@gmail.com>
Date: Thu, 4 Sep 2025 08:53:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/13] x86/HWBP: Add arch_reinstall_hw_breakpoint()
 for atomic updates
Content-Language: en-US
From: Jinchao Wang <wangjinchao600@gmail.com>
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
In-Reply-To: <5a6dde06-11ee-4ce7-9cb5-f0b8096e42ed@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wthnizunehtbm54zyh3511k6uyhgr8y5
X-Rspam-User: 
X-Rspamd-Queue-Id: E224BC0004
X-Rspamd-Server: rspam01
X-HE-Tag: 1756947234-656603
X-HE-Meta: U2FsdGVkX18c+EsKw95amGsJpz/gsqrc32aPJRD8aVYZTLLXoQm/mjx7lPhJHwwxI2wGXBbZlVi62kxYkcWM0YA9Qt2NASdGRAadyklImA8Wskuxu+W8ziY3IeVKxzOvqLXF/4GsfU2yEBuSDaKvsXnKkm9Y6puu6gggq9fsYpnKSLNt+TYTfwgE8gjXdqa1K3QkaCrXwDaC7/VZZtp1y10ywEM7ozg82n1dFzEAsXAnK3QMpDI5yI9p41k8dUAltkD/WBdBm+QUdodLuAKPg1RiklPd3H7L0psVohJ0DtUi69+6HZJe2kVt9S/u83HRHFq4IM1OSzwiFvjcPi93p5FzcvCnoR5DrdoH0dyEJmtt3Eu4NO5PLNaT0pM6GcMCzp9uaUeCD1zLjZJP1GureiAZoCJPXd1xzXMvPRclFLj+aqrPrfbmjAyQuFlLKwv24eTo/IzYnDO6sGpZ5GVqu0eG/vg7o2TuKaaUD3yE8DJaEzMId3IJqusrPWyISCc66uZMyU8Xlj5tS40r2qGF8zKU54jYPm7xU/3r3w6MFdEmT4Am50wWlw4k4IY0yy2KF4l5FWirMhu+haVRtUALRtrXL3oXGuJa6z1zdxHvVrtSS3z0Yk1hEqy/fO4hWuEd8vl//rS1304CcHmiaSf41D3cyw+mWz3WFouZLoqX+8COvyzgOTcfS+c/KrEouVtXB4SVthkfYqRBfQCVdVSASdy+RqOguHCOrzQkigEYIEXJEONHt9/PARRSuPgOFzdSAhrOR56ogLyCEBFAHDr/le88NEv9DNsKdDvJIG/ZEU42QosgRBA15JxO2AMEOlQla6EJFuwXOcpSUq90dqyOPlDtTnuKIZPz8XAwYFAMbW7Vt4baZLy9bgfeumdx5y1SDTAD8F/R96JgfYzNZadKo/i+nbiXf3ODOfzyJh3NJiD9czzeWzR5FqS2mGrkUPngQws1ievIDbSI4GLbOtP
 r6UC1lpV
 KcngOvJNQ5wwKXRxSM04Dl9G1Cf0QXKUD+esmIqdccqqyoX2NMi3rZRbE9zwCKpi0ndIX8ZFENdvGjAzxMZ7xyLu8b9rq3ksqDZQygeb6Rn9Sl6iDCVNh/1thZD8E70Pm11ZAdaRBWuTUx4ffSz7MOV3bEgAmHvnFodRab8zukS6fEehqrm29wq7HW1YsEojKVSqJ11f8dDUFVC8kScMAKDa0U1MWWzskve74GUqFcLc+ISoWu+7xm9G2Ce643Y6FgiHf8AFo25F4BXCqOhukAI0j0onG6ZmRKQ9RCPNsF6WXc2+8gtCZhf0tlFVYG7xaIu+yW8uiR0F+JUYRuhFrwowDe1RTEIyfh+2bU01OcNWjfe6i4HqyLf+mAUUNUVMR90sduN+fbMMgOt0f1HJABkHROv2cLEtbZeSWq1M+c2kw0d1TMvU/mOjk932p6fmAwMVdempaVWy9/Rh1btfTWnBWnL+KkPTwh/RQAKppzfdwuBCIUj/z6BimxuV48M+9rfhSO+R4JaKRqO4vkGEI3cQAA6GoFIaU04/3nZqOTLMqrsrC3AHqUKgG07R37YFsHwPUmA5RVoSw5DJV5UTcoJLfeSQxiBPsmniu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/25 15:58, Jinchao Wang wrote:
> On 9/2/25 22:11, Masami Hiramatsu (Google) wrote:
>> On Mon, 1 Sep 2025 18:23:44 +0800
>> Jinchao Wang <wangjinchao600@gmail.com> wrote:
>>
>>> On 9/1/25 15:06, Masami Hiramatsu (Google) wrote:
>>>> Hi Jinchao,
>>>>
>>> Hi Masami,
>>>
>>>> On Mon, 18 Aug 2025 20:26:07 +0800
>>>> Jinchao Wang <wangjinchao600@gmail.com> wrote:
>>>>
>>>>> Add arch_reinstall_hw_breakpoint() to enable atomic context 
>>>>> modification
>>>>> of hardware breakpoint parameters without deallocating and 
>>>>> reallocating
>>>>> the breakpoint slot.
>>>>>
>>>>> The existing arch_install_hw_breakpoint() allocates a new debug 
>>>>> register
>>>>> slot, while arch_uninstall_hw_breakpoint() deallocates it. However, 
>>>>> some
>>>>> use cases require modifying breakpoint parameters (address, length, 
>>>>> type)
>>>>> atomically without losing the allocated slot, particularly when 
>>>>> operating
>>>>> in atomic contexts where allocation might fail or be unavailable.
>>>>>
>>>>> This is particularly useful for debugging tools like kstackwatch that
>>>>> need to dynamically update breakpoint targets in atomic contexts while
>>>>> maintaining consistent hardware state.
>>>>>
>>>>
>>>> I'm also trying to find this interface for my wprobe. So the idea is 
>>>> good.
>>>> But this looks hacky and only for x86. I think the interface should be
>>>> more generic and do not use this arch internal function directly.
>>>>
>>>
>>> I agree with your point about the architectural dependency. I have been
>>> considering this problem not only for the hardware breakpoint
>>> reinstallation,
>>> but also for other related parts of the series, such as canary 
>>> finding and
>>> stack address resolving. These parts also rely on arch-specific code.
>>
>> Yes, even though, the hw-breakpoint is an independent feature.
>> Directly using arch_*() functions (which are expected to be used
>> internally) introduces a hidden dependency between these two
>> components and looses maintainability.
> 
> Yes, I am trying to improve this in the v3 series.
> 
>>
>>>> It seems that the slot is allocated by "type", thus, if this reinstall
>>>> hwbp without deallocate/allocate slot, it must NOT change the type.
>>>> See __modify_bp_slot. Also, provide CONFIG_HAVE_... option for checking
>>>> whether the architecture support that interface.
>>>>
>>> Regarding the slot allocation, I would like to clarify my point. I
>>> believe the
>>> event->attr.type should not be changed when reinstalling a hardware
>>> breakpoint, as this defines the fundamental nature of the event. The 
>>> type
>>> must always be PERF_TYPE_BREAKPOINT.
>>>
>>> The event->attr.bp_type, however, can be changed. For example, from a
>>> HW_BREAKPOINT_W to a HW_BREAKPOINT_RW without needing to deallocate and
>>> reallocate the slot. This is useful for future applications, even 
>>> though the
>>> current use case for KStackWatch only requires HW_BREAKPOINT_W.
>>
>> I understand your point, so it also needs another wrapper which checks
>> the type is compatible on the architecture.
>>
> 

> I think the wrapper should handle the type by type_slot, something like[1]:
> ...
> 
> For kernel breakpoints, we might also consider introducing a
> modify_kernel_hw_breakpoint() helper, similar to
> modify_user_hw_breakpoint(), to encapsulate the kernel-specific case.
> 

Hi Masami,
I have a new idea, indroducing hw_breakpoint_modify_local():
   - call hw_breakpoint_arch_parse to validate bp_{type,addr,len},
     eliminating the need for a separate type-only check
   - use a__weak arch_reinstall_hw_breakpoint for other archs

If other archs require additional checks, they could add that logic to 
hw_breakpoint_modify_local or their hw_breakpoint_arch_parse().

Seems clear and simple enough.

Regarding the arch dependency problems you mentioned, I have solved them 
and sent a v2 series:
https://lore.kernel.org/all/20250904002126.1514566-7-wangjinchao600@gmail.com/

>>
>>>
>>> Thank you again for your valuable review.
>>> -- 
>>> Best regards,
>>> Jinchao
>>
>>
> 
> 


-- 
Best regards,
Jinchao


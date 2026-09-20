Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FA92C982D0
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 08:00:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 172AD6B0088; Sun, 20 Sep 2026 04:00:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 123EC6B008A; Sun, 20 Sep 2026 04:00:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 013916B008C; Sun, 20 Sep 2026 04:00:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C8FC86B0088
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 04:00:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C4C16120407
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 08:00:54 +0000 (UTC)
X-FDA: 85233394428.01.39D1289
Received: from mail-pj2-f11.google.com (mail-pj2-f11.google.com [74.125.227.139])
	by imf25.hostedemail.com (Postfix) with ESMTP id CA024A000A
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 08:00:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="dtIpJtp/";
	spf=pass (imf25.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789891252;
	b=Mk6T5IMvaM2jkeB6QxBdYfWnRIpwA/7QETQpJL8FpCC5J0kwl6zvsMB0uAP+/fobb9bnOc
	0LhseDm2Npin0Pw0pg9VTy0qvOz47zAJ8UMBPtAZdljX12rg2KuEVcNzD0bQ4sgacFPxXD
	NyCEeGZMiM9R4SnlDmwGjDHsfNTTMZs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="dtIpJtp/";
	spf=pass (imf25.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789891252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t8CTYyRXY2aAud9otm1AgJf6WMdrU7YgSbJhEbsEEJg=;
	b=hpcPnqeHXdFMMjqY2f9zLGrLo0ktWt9nx1dvxem6OSpP4Ue2SEVyNTHk+15apUgFVpYCiw
	zsfLQMMd85hPOnnQ6txy9pkdArIXiFVbmRIQSKbt2lnfe3UlcUN4zQWr3nAbzUGtgXKCVh
	ZTh4AhiwYlqkesqSOVI0p8vudyBgY/E=
Received: by mail-pj2-f11.google.com with SMTP id 98e67ed59e1d1-3989fdf58bcso192406a91.0
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 01:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789891251; x=1790496051; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t8CTYyRXY2aAud9otm1AgJf6WMdrU7YgSbJhEbsEEJg=;
        b=dtIpJtp/u4Ar4Z3o7Nc++Uug3beevz9K0qkPFb8iGKT8Ecaqt+/Pn4Mn3g38L/YXGH
         UVXiygexxYpZLaV/k8tRpYR9mMoMbYKMA//YCG5QjE/VP7mwSjTeHT9Z7Hd6LUAyxQFH
         qdVp69m0zNmxZkyW6fCJ61C7d8UuYS4UomEF6aJ3TFbMUENU40Ww1INSitv5g7NTG6XD
         9w/PYQBpbI4JfALdBnE7SrS2KE02Vtb5rIfryCJFohvtb2EKNqIJ7xeVw4a64hrKo4KA
         5HsrFxcJGjIG7j5DW9wwiU7xwxPgG818Tb9Yw6MK0D35gunIkZJ2PsooBFOhuO4fPodD
         bWaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789891251; x=1790496051;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t8CTYyRXY2aAud9otm1AgJf6WMdrU7YgSbJhEbsEEJg=;
        b=mPTifecfxJws9ZVtGr729SonpHpOvrRgptbS24/JxkjtqG/1ODnTNC0B8xe8pq2KOx
         nJNReUqMnbGTPpBNH5P04ivVcOjEnoxGsynKiy0Tn55zoBImt12WVaQ2hQ5y0eGuUpvt
         SCaplkNziP6UzJbfgk+NFxuBLkG/8tr0QUCvEtuLJy1xiUFyq8Kxy4kqtzVP5T2HOl9i
         2uDgOiw4mkDID5ajQ4InKWDorN8hIM7C/fDiFKF+NpKn39TJPyp9LrAmZdciceAuuc4t
         f4Crso8wzFzZnr2gYsJExH53Vs9tywoiXYDS/Tuve96/434uXut2qoBxZZJ1Xy1WLZU9
         P9Lw==
X-Forwarded-Encrypted: i=1; AKwUvBw4EmtJ0qPgkka12hrrJmG+QEKGyCthEd6Wii/eELKEi+jYuw8jiAn4p99p/Zz/QGbsZnmm8Vo3QQ==@kvack.org
X-Gm-Message-State: AFuF++lZP9/mSET4SQJod3iIE6NfB48Wf7RulhjlWNWKNv5fABMKZ+Hf
	HWOSYrbm2djllNZA7UBFr0lyZ3tkyUmpO+Huhqw/YLx5QIiMFyIKtonl
X-Gm-Gg: AYBFou3+YjrVJwTZzg3LMYRcXjlRO8YA05ydMqlxTkEl+V3034Y2Jk9BuwlUMw23gNp
	wHipsOkgWzlvDrd5ceRSxroONK3sfIXutjDHiwGZtOqf7yqgkQsxiPf17qcRPSwGMKUMhSqd+O2
	vL6z2BhrxB2cMqdba5ja65t2XqJeBAFe1iTayuc/jUKeImMOw5LNIZYXVnCdkxrZC1WoYv7AvB8
	PXGUroe+ZxfjKVl1YoSRAHsn58cscPKBG/agKbXSSdLQPGp7ZsBZIXm2erx7TdHjgyrMWWTCmMq
	rd+zH/FknuiRkGo8bCVDT1P3h/7AcTiVO9DnwcGzqK8UX1eunqqXG8cEYfinZn/ew+yr5Li4uu/
	n+sOcHWSV+V68FSXe2uoRuE7xf+U9RYCrFsPp2nVg2GY32ArGXlqdXhQ+GtnJtTBfXt4KrgC1DI
	7BXONdErYiEUC7cYJnVR47E577IdYrOOfkZQHjRwNBBCgkEjWksU/FuQ4+ZyOP9IhxYLulp/CMY
	jB5oA==
X-Received: by 2002:a17:90a:fc4b:b0:3a0:2900:f55e with SMTP id 98e67ed59e1d1-3a02900f85dmr2402815a91.29.1789891251509;
        Sun, 20 Sep 2026 01:00:51 -0700 (PDT)
Received: from [10.125.112.20] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6cae997csm7876986a91.11.2026.09.20.01.00.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Sep 2026 01:00:49 -0700 (PDT)
Message-ID: <32b00102-0961-49e3-b780-74d6db182809@gmail.com>
Date: Sun, 20 Sep 2026 16:00:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/10] memblock: introduce MEMBLOCK_NODUMP flag
To: Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>
Cc: catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
 pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 robh@kernel.org, saravanak@kernel.org, akpm@linux-foundation.org,
 pasha.tatashin@soleen.com, pratyush@kernel.org, m.szyprowski@samsung.com,
 mark.rutland@arm.com, kernel@xen0n.name, alex@ghiti.fr, hpa@zytor.com,
 ruirui.yang@linux.dev, robin.murphy@arm.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 devicetree@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org,
 iommu@lists.linux.dev
References: <20260902073116.802752-1-chenwandun1@gmail.com>
 <20260902073116.802752-7-chenwandun1@gmail.com> <aqzxavL91icLw-Xv@fedora>
 <aq41nFRPtRWTQ7cK@kernel.org> <aq9UGXeqmCfuPHdD@fedora>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <aq9UGXeqmCfuPHdD@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CA024A000A
X-Rspam-User: 
X-Stat-Signature: bzqa8komawdu9ucqe3e9rhmhgkrcyf55
X-HE-Tag: 1789891252-838998
X-HE-Meta: U2FsdGVkX1/m1T4j0919t13TAVip7qP8RYAVSZojD3nUJoUeRaahALyE4qwZpfjL4q1DoJFRtk4V4+huHlzzZRC82MuAxGjJcZGVwenTb6ZFtShFHj7OvgZehnsBBgEReNec0kRgcFPddV0jYNc60f8h+P20stqvYeciNcrBzi519cT3ZtvX/IZf4Sc6r2X2Fk/BhvWLV3LU0WiRoO52knWakkJE7548tgFOG//1ydoE+kYc2qL+rfEoO0QTlud8N2CiK+bYNhgxrNb4FerYlUBzinE8m3VAf7tNoszKlCbDeyCkEuyxsN9/JDLMhYlxG1GhIeQnK0r1WGQeseJxpPXbTR25ddB59yj6LQzWfoTvA3EcMqR7/50vr02lr4GN6vU1BabSnBJiPntYFLaWIyX7fsvzuZnNBw0C/atfLevYKZa/dFtEq7PMgvN/Qdq1zKBW42CxGJr5QGCEn2Mf2ImIC8DWuH3lGf4UTWsRBAtYXutlH+8kMdt0hWUxXAuyrlkzx8gh60Tkj+YKFc+He4Ytm1bFRt537ZUfVtl4u54ZrNJHxeDrEcl9L4kDMf9Z2I0Rx3R0Xxvz+uUvq1DeaDDbCuUgGTeCYM8zrfTQXFFLAlxkSN1AT2zqMwKwVkpTKyEdRl+DccHKPxVMbaHdyGOjBp2a7xZPWAU22OoP3iZujCqrRb6gxLyWgYWBXuEzDSUIuzbQn7idB4wKDrzgr9EOZWIHD6Y5fjkHyvj3uuYVRCf/J7NIHNis0DLkdySKYcWLFHOUXQlN+FFNZ4Xyzevr+e940xRZIbt1Ewu1MbNgQMW9qMozqWs0VmuDO6HlxzpviACs4i03HVbSM8hZXDAoKXSZGq8xt3sdd/DCimb7ca0zYscHbwK0RPlBu/J8q6W/1ATa5qEz8O94fiQk2mrGtxDXxow3miGSnEv7L7KpGSFrsvgJFwjH3eWRFxrR6YLkB71B5UQuRUQCeHF
 fa0PPIUg
 MwN6o6OfMX7reqhzjWIiLOY6u7md1t3Tc9w47uga4nKziJIrUCu4lI3An2oP/H3dU4QOVcX6qff0fXGJ8xZE3oxkvx/TKsCBdm/s0NEIEwauVRIaZKjxwhcFstSo7aUA6ZSivAnWsksAwBgp4LMcf2EnDREdIgLlf4Q+7SPPoeTyUczKBt0lIS0kJsDcW3bCac3bxA/YMtqBv7OB3PwXoQueY4KQV9sJ8pxj9w+lHHfEmeJAXbUbIQnTV+StAsuyaptWGjA2MddDDaLoR0lU3LA7RvE2LOmS9WRp8YOnbREXXNxm9GEtHvaZP/1jsqKCqN80tbPpv1hN/rm/fvgZmVzvXt9eEsoFNKTcwR/lbyk9edSyBjmDHko1LRHIUxAufgBNKB6LO08qnOHGFYTUvH1Lhn1hrQcj/Bj+l9AHL+QfDQjJMuAFhIiap73Yymo5/upSGvXaJ+fpLhUtM2t7Dcv9xWwZQ4brAuUc9eUyHNPe92ik=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/20/26 11:33, Baoquan He wrote:
> On 09/19/26 at 10:11am, Mike Rapoport wrote:
>> On Fri, Sep 18, 2026 at 04:08:10PM +0800, Baoquan He wrote:
>>> On 09/02/26 at 03:31pm, Wandun Chen wrote:
> ...snip... 
>>>> +/**
>>>> + * memblock_mark_nodump - Mark a memory region with flag MEMBLOCK_NODUMP.
>>>> + * @base: the base phys addr of the region
>>>> + * @size: the size of the region
>>>> + *
>>>> + * Mark the region as not to be included in crash dumps.
>>>> + *
>>>> + * Return: 0 on success, -errno on failure.
>>>> + */
>>>> +int __init_memblock memblock_mark_nodump(phys_addr_t base, phys_addr_t size)
>>>       ~~~~~~~~~~~~~~^
>>> Is it impossible to use at runtime even thought it claims to be generic?
>>
>> This should only happen at boot.
>>
>> Allowing modifications of memblock properties in runtime is a can of worms
>> I don't want to open.
> 
> Thank you. This is why I said this can't be claimed as a generic way to
> mark memory region as no dump. The generic way I'd like to see is
> at any time of system we can mark any unwanted memory region as no dump.
> And it won't impact the behaviour of the current system.

Thanks Mike for the explanation and Baoquan for the suggestion.
I'll drop the "generic" related description in the next version.


Baoquan, by the way, patch 2 is still awaiting review. It rewrites
the riscv side of the code that patch 3 (which you've acked) then
folds into the weak defaults, if you could take a look at it too,
that would be very helpful.

Best regards,
Wandun


> 
>>  
>>>> +{
>>>> +	return memblock_setclr_flag(&memblock.memory, base, size, 1,
>>>> +				    MEMBLOCK_NODUMP);
>>>> +}
>>>> +
>>>>  static bool should_skip_region(struct memblock_type *type,
>>>>  			       struct memblock_region *m,
>>>>  			       int nid, int flags)
>>>> @@ -2887,6 +2902,7 @@ static const char * const flagname[] = {
>>>>  	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
>>>>  	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
>>>>  	[ilog2(MEMBLOCK_RSRV_HUGETLB)] = "RSV_HUGETLB",
>>>> +	[ilog2(MEMBLOCK_NODUMP)] = "NODUMP",
>>>>  };
>>>>  
>>>>  static int memblock_debug_show(struct seq_file *m, void *private)
>>>> -- 
>>>> 2.43.0
>>>>
>>
>> -- 
>> Sincerely yours,
>> Mike.



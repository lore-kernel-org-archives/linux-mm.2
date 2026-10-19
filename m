Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CCD5CCF2DA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 09:17:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEC246B0189; Mon, 19 Oct 2026 05:17:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC41A6B018A; Mon, 19 Oct 2026 05:17:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB2FE6B018B; Mon, 19 Oct 2026 05:17:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A73EE6B0189
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:17:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 30FC91405CA
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:17:26 +0000 (UTC)
X-FDA: 85338822492.15.AA0AD64
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id F095610000A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:17:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JTkZgzcD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792401442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r8zI4PFU7+iR63fa7JCvn5GLydDwgCivCmGKOvjvHWk=;
	b=OUPbHkpjT8hXT3aWbjUNfCysBGo510mv1zaGQRUTM9INiPUb3PNDMO5EmMMqelIqxYnz7K
	Nl1CGniZ6NZmivfTrtaaIEqXMeAo8cq7kInIjiBWkePjY8OX6+enqX0FNonya48HUMuH8+
	b1kWJaBylmfH039xrOIHGtSmIXXlR88=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JTkZgzcD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792401442;
	b=VyxLz/6fQkvDG9p7tYuKWjMVyDPIQiIlhyfVkHwGTn62N1a7o75Z/CKehEQRNhYMbCi3rk
	VKJR+T70eU+fFdKVK1zqlmf5ZpMVO4hCvq20pBRLxxaCI6cZraNRcdYl+A9sHi1VYiEV8r
	jN2KfNrM48L8+D+5eD18MfxZcsKCn5Q=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a1ec92f655so3969265e9.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792401441; x=1793006241; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r8zI4PFU7+iR63fa7JCvn5GLydDwgCivCmGKOvjvHWk=;
        b=JTkZgzcDQejB7rDsSYUl8zj1a7Mxa8w4AifTgfa3Tz4DUiOGn/LkV8Slt0IOhcLcGh
         sFnO0K2HYPxTexx2NlZ1o2DXbk4jhbJEVBs72HgHIrHE4aCq5omtX+qkkGRMtcxDkqbB
         i+vI84zCYlVygYqk2dNCNIXKR8cviYxOHHvVjmVBSK4GHQf11gEICTz6AVcGZqosBSDH
         EcCZ23QmpOF1emSimc2P/DewfoXvyYe3Q1ZM02oX3qvSeATPQmp3QNFxlcKFvztw2u8x
         LSM3jJzjTvEj3nBlaet6ONghvK8upa88f01H/kl11dtH1wW2iN4J3252Pmbw/36qkP+H
         +4YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792401441; x=1793006241;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r8zI4PFU7+iR63fa7JCvn5GLydDwgCivCmGKOvjvHWk=;
        b=zvNWm8Rcgun74Nkxo8flw8ZC+3YgpjsZMG304ehmppji+ymQyzbSb48dgiCw+dm3nj
         dZLEkOCh/tuw27tkizEAlBr5rTPX3Dc2RXuVv2Rf10MLv6OsFOrsVuu7zxizmYRcFk0K
         /JWN+GgJMBIQ3n38I52WGgprRBo2Tle5bfS8YpE7glqYi4dTlHGfcVluKTlXm85wFtqw
         iuw7ifeMHnZP56aHAJ037WRBxf7DGgt0sZS1S6tngpL5HFxS+RnkqxomTjh+4WpA7fW9
         nujANXNkcQOMAS+gu+uTmEBqW4yEYHQXgMZHmK0Kjg/htkJ/r5pdPUGbsAcammP/0+zs
         UE2A==
X-Forwarded-Encrypted: i=1; AKwUvBwm/G8w1nR697Qb8HVv1w/V+VbpEstdIdG3MFdMk3xfpHOS8FgxMcN+vRqABNef3V/ErgJAOxsVDg==@kvack.org
X-Gm-Message-State: AFq9FYLrR3/QE/wMxdgJz6/7W67XU1JaP1gLagxhAuuqS5q+RCMR7a6U
	E1P4lCF0kqN5ZkMnZVvXFtGYxzNx1htjv4duw1wMOODE0mohHA4HVfNN
X-Gm-Gg: AYBFou3HSEvAM0fD+KYx1NFrsQ6ZObosfTHWchttDDTxDUvjdRBqO/pVHtZ9CiQLzj5
	pDgn4Q0M/msYaxhbL2JqiQSrQoOd06DWMk4mHqIZDSqc5nI+i9W8kUw17DSR3M+XZKt4KpP0/vB
	X1jwW46vfesfhYYqxYlBKdLVLnuDRxGGseAbgox+tZ3KsjHiOZGB7eEDmTQ8CDTdyI+N+HaB4wm
	iDYo3Fb8FqAJuutTUECaIxEXpQ1LILlGLUGFq+QXGbkRCXtUjI8qU3Tei188SjxPscKC10DcAOO
	pfQPzSbOielql/gIbOWi8l5Bx7efEVHYZDFxD88f8Vs/7lNDSHXVLOAaom/fFNf2LOaTkP6x3OV
	lXJNRUfpWk6zWw97oVJ65G28KhWrSQ3W33gNKFUsbYxWPreClga83A7gE+JdDZ+0j/pIzK9suo1
	nr8oj982eTtXgkVrxXA/H2aF4RaaiMMC93B3+kPu/hmT77Y76QyMo8WLpx4dm+lrecwg==
X-Received: by 2002:a05:600c:6c49:b0:4a1:d45a:3ae9 with SMTP id 5b1f17b1804b1-4a1d45a3b3amr136069365e9.15.1792401441443;
        Mon, 19 Oct 2026 02:17:21 -0700 (PDT)
Received: from [192.168.1.18] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd503a0dsm22612421f8f.47.2026.10.19.02.17.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2026 02:17:21 -0700 (PDT)
Message-ID: <1385f5a1-b842-45e6-8986-fec4123037f1@gmail.com>
Date: Mon, 19 Oct 2026 11:17:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] mm: hugetlb: add CMA support for PMD-sized page
To: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>, Qi Zheng <qi.zheng@linux.dev>,
 osalvador@suse.de, david@kernel.org, akpm@linux-foundation.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1792136742.git.zhengqi.arch@bytedance.com>
 <FA455F0C-0A46-4B5B-AB50-E9968001D2C9@linux.dev>
 <4a7ad39d-fee6-4390-beff-d40ecf49cbdc@bytedance.com>
 <BEADD50D-94AA-4B05-B9AD-136E37247FDD@linux.dev>
 <988249c7-abf0-4f4f-9386-27e835a4d2de@gmail.com>
 <EE02C2AF-E4BD-4854-B235-928842456253@linux.dev>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <EE02C2AF-E4BD-4854-B235-928842456253@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F095610000A
X-Stat-Signature: 71zh78k1f61o6iiew3ehuta61w7a4c6c
X-Rspam-User: 
X-HE-Tag: 1792401442-244311
X-HE-Meta: U2FsdGVkX1/CwFkGLJSZPqVIIQtIzc6cUHXkSYY6bMl2iRN4qxuEPCfWCjpfybSVVK/7c9RrHofke9pkq1YLhp3Wpv6Xa5Dqu0Mps6q/bGvz0TqLNpVbCYST7FGeVN/G0UYKubFggIvJuOpz2405RQJ8RV4o6/WL0zBBeTN5Fpg3dMqxqb9Z8vMz4sTDjtygRj5LF1LuKhdksypKMkHVx7pMXRVkekWsItlXxQYqmMyfELHmXkce3lNziGMoAfcwSdnPoJ0Y3eYoMKxmVD2mFool3NL2GJgGZaAfF4eSPrO+56lLutF60UXOU09YCvXZJuG9LgvK+R6g22WyvRm3JpWZN85EfJPy+wFithU/WarZrCBzNabo9pv0qf/AmYrwwW/j88C0td+M0VSYhxAosr6xBnxeqQ9TJwncWNrDYb2A6ZojiJppCOko8qbP0aQNqmfuSToE/9G+E90Bjb63yyB+Il3fFwIdAskFXy6CxDlKkxtosk6bKktIGY2NPVIvi84PZ6HNIa4iL0o/dKGvjLXmcC46yxnE9Fy/1wp0T+3eiT1JSPFjpqSJhc3SY18CEbRF0XdzqwSMzhpXlQRR1kSy3ScTaODPbapRjPl7EUJIJapfHp+/D8+3aU0vzkixs42VigpM4r/fQwdBzKQe1ekNJjDqQjIM9Lv+oADOcbbVJ+I+AujpyGJDnUyUG34l5hPkY+X69vndRi59UhgFiEhiJjhGaCrG/h1H5Qgj8d2KltT/DS9Vtsr4ZcUgxu0ABmPkRVPEqj+qQ+33tsO5xA6NG8bfBqMjkKzITzAAscqajb2l6/nsbvUMxi4dlcK7hwKt+N85XGDhzyfW+sbSUtJPy1j78UVG7UpiX9m9/EoZFPLeqkj28BvLPMqqS5LgCM1HL7R7Mnvn5pMdKeb4zBBSUnctxay8wGSneEBvXJdl1QYBlQpQQFKtdxs346fHvOkFvktsFQeknF3KXcb
 lMyV41PK
 JoO43TYR2qdDatc396STQmjNutvl8kpGWXe5pqO+bvgw5n0hkh3QVKTOet0gigF27fb04A84fock8BjeF3019eWcZyUobDOFw4SfcT1iUz4Ynmm/JiuoWFm8npEmzubZGmAc/qguo/dHDDPGnvZk33fKB2w28pr1B5yhqBDHQNgetccSivdYZIwU2LTs6wFkK1icKs5fyZLHuD6I4sRC/ZDVGjgv4rEOqsBzHBTLgE4xO/+0pJaYD4gVarFwbwSLLdjM+KqGjiuaGh3u+2ht87UqYBNIY0ZajhyQodseDfyFDDeRecCPURfjD2Bz2HugAhJiKH0BkK1M1xlUUxT+L3DYpfvd8NPGEfsPeoNAcUPg2VLSE6AyDCXR6abglHzd+K0L3hvH1OgwqbJbyLqm8FXWQsoq5/NI9Mmbkyn84I9Jx9ZiGXdx38cNPmbm9HnrHVC469lVBgJDQhux1iKj97JxT0h8bOUVfXP9lAqRX7T1rU2g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/19/26 10:43 AM, Muchun Song wrote:
> 
> 
>> On Oct 19, 2026, at 16:20, Jose A. Perez de Azpillaga <azpijr@gmail.com> wrote:
>>
>> On 10/19/26 9:50 AM, Muchun Song wrote:
>>>
>>>
>>>> On Oct 19, 2026, at 15:37, Qi Zheng <zhengqi.arch@bytedance.com> wrote:
>>>>
>>>> Hi Muchun,
>>>>
>>>> On 10/19/26 2:50 PM, Muchun Song wrote:
>>>>>
>>>>>
>>>>>> On Oct 16, 2026, at 18:07, Qi Zheng <qi.zheng@linux.dev> wrote:
>>>>>>
>>>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>>
>>>>>> Hi all,
>>>>>>
>>>>>> Allocating PMD-sized HugeTLB pages at runtime can become slow or fail
>>>>>> as physical memory becomes fragmented. Reserving HugeTLB pages at boot
>>>>>> avoids this problem, but keeps unused pages unavailable to ordinary
>>>>>> allocations.
>>>>>>
>>>>>> Live upgrades are one example: they need additional HugeTLB pages only
>>>>>> during the upgrade. HugeTLB already supports CMA for gigantic pages,
>>>>>> but reserving a CMA pool for 1 GiB pages can fail when physical KASLR
>>>>>> and other early reservations leave too few suitable 1 GiB-aligned
>>>>>> ranges. At runtime, 1 GiB allocations can also fail when pages cannot
>>>>>> be migrated out of a suitable contiguous range.
>>>>>
>>>>> Yes, that's our use case at ByteDance. Allocating a 1GB HugeTLB page from
>>>>> the CMA pool is more prone to failure than allocating a 2MB one. To improve
>>>>> the probability of successful allocation, we typically configure the CMA
>>>>> size to be larger than our actual requirement, keeping a certain margin to
>>>>> handle cases where temporary kernel operations (such as DMA) prevent successful
>>>>> migration. For 1G HugeTLB pages, since the margin must be an integer multiple
>>>>> of 1G, the extra memory configured as headroom is also relatively large,
>>>>> making it less flexible than 2M pages.
>>>>>
>>>>>>
>>>>>> Extend CMA support to PMD-sized pages so their backing memory can be
>>>>>> reserved at boot while remaining usable for movable allocations until
>>>>>> needed. This relaxes the reservation alignment requirement and reduces
>>>>>> the contiguous range required per allocation.
>>>>>>
>>>>>> The series adds an optional @<page-size> suffix to hugetlb_cma and a
>>>>>> separate PMD-sized pool. For example, on x86-64:
>>>>>>
>>>>>> hugetlb_cma=4G hugetlb_cma=1G@2M
>>>>>
>>>>> Different sizes of gigantic pages already share a single HugeTLB CMA pool.
>>>>> Given that, why not let 2M pages also reuse this same pool? Would that make
>>>>> the overall code implementation simpler? And if it does make things simpler,
>>>>> should we go ahead and do it first?
>>>>
>>>> Sharing the pool would simplify the implementation. My concern is that
>>>> small PMD allocations could fragment the default pool and prevent later
>>>> gigantic allocations.
>>>
>>> Yes. However, the premise is that there has to be a mixed-use scenario.
>>> I'm not sure if this kind of mixed usage is a common scenario.
>>>
>>> Of course, we don't have much experience to draw on, because on most
>>> architectures there is generally only one kind of gigantic page, and
>>> prior to this, mixed-use scenarios could not arise.
>>>
>>> Therefore, I think that before the need arises, a simpler design is
>>> easier to maintain.
>>
>> wouldn't a shared pool still be sized and aligned for 1G? then the 2M
>> headroom stays a multiple of 1G and the 1G-aligned reservation can still
>> fail, which is what the series is trying to avoid.
> 
> If we decide to use a shared pool, I think the current alignment strategy
> should be adapted as well, it should be changed to align with the minimal
> acquirement, like 2M.
> 
> For example, if a user reserves 1G+2M through hugetlb_cma, then the memory
> reserved by the pool is also 1G+2M, except that the starting address needs
> to be aligned to the largest gigantic page (1G). Therefore, this pool is
> suitable for both 1GB and 2MB allocation. The only problem I see with a
> shared pool is that it may not support mixed-use scenarios very well.
> 
> What do you think?

makes sense to me. existing hugetlb_cma= users with WM pages would get
mixed use without asking for it though.

-- 
cheers,
jose a. p-a


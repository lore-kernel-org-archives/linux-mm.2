Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8B01E83F05
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 05:46:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D59A6B0096; Thu,  5 Feb 2026 00:46:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 363836B0098; Thu,  5 Feb 2026 00:46:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22EE76B0099; Thu,  5 Feb 2026 00:46:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0EBEF6B0096
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 00:46:18 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B70E4B913C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 05:46:17 +0000 (UTC)
X-FDA: 84409317594.07.ECECDF2
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id BA557120002
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 05:46:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VbzQtUlt;
	spf=pass (imf29.hostedemail.com: domain of usamaarif642@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770270375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xh8SRryTbBKNPrusvQGIQRE83r+fwBp2qy2Ro8RHIOE=;
	b=KFj61niWMOeR8PpZNh4dKofT9cQrdjWgChDfFwWRdyxZydEzHLyJKzYtgqSP9cB7zdUDXj
	FX9pzZFYkYpOvnVF9FzQc3PH5oplsPJVrREGQ2wMpmgGQQsvIyWJuG8jwjR8craB9haTY1
	jCVZ6DkpKSrnWrWKmDZZQwz1dkqDdGc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VbzQtUlt;
	spf=pass (imf29.hostedemail.com: domain of usamaarif642@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770270375; a=rsa-sha256;
	cv=none;
	b=G/7bU4pyKi2HkLqpMk3/kiPgJKs9F8hRAYhMRi3ZnW419bU+0Hc0WObqfwRRKWRXobrds/
	cwEyRZx+CZIPJxY0pCOhpFJKNEEif40VD/VQiLx6NiqmXifd1lUUuf6b7gMHeC3bcfJMkG
	kEo0bceKrF8v3tnu5YoHx6etXijrqcg=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1233b953bebso1561282c88.1
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 21:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770270374; x=1770875174; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xh8SRryTbBKNPrusvQGIQRE83r+fwBp2qy2Ro8RHIOE=;
        b=VbzQtUltpKEQ/3rzDeNC46sqGnNMidv6cOnnQGLoGr6x6Qik4P/+giyBrQWMpYWEkU
         j9m53Bo0NyIBGmEq2ykfAvX1EXkwc5OrnebfVT9la0x/EhP/zdecNzlhwhGNP2UAs6eX
         E+Kf+ZV50XTcl2dpcJA32gI/iu6gewDvgHK0TKbNP+oxC6009B1DOSnC6mSwJSB96gfF
         0OuAwVqA4e5AcuvckJfHgF9D9Tiy1crAS2yzW7FFLLG3Y+qfMdkIHavhZi6Ia36/zi6H
         mknZm2VNwjaUOnjoFg+m4AL9cwUTety3UDHQ6hUz10Ett0Yala5w7gAjB4EY9yhLY83S
         vQ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770270374; x=1770875174;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xh8SRryTbBKNPrusvQGIQRE83r+fwBp2qy2Ro8RHIOE=;
        b=I3N27AYcyn4MCKTsCEthXVbUp1Pz0+yvifpZLvcp3eQOlrtgV1o8S/ie1LYvGTdfl6
         tneRQHxSZrBY3xNXYwB1hzkzNzDOXxVFgUFBkQBYg5QUIPyT7EKFAYOLaV38ogbg/bwU
         p0BbIkPG0BDSRAeLbvzv7dSPErLTGF5x8/5+oEAMHC+6h7PhzYa1EcDgFkrJDI4Z0iQk
         JrJajYtDEKgpIgvKDiXtmEsmCzAv0A0Xcj28lVRM0QC5drSBxSMHH6Tzb64d5GeMFYwM
         hKZacGkTGI303mSPW/YjjIgxbsRfBudl5QOH5ti7ljH/3TuDgj0FoTHo1cKA5ywvl9AI
         qhgg==
X-Forwarded-Encrypted: i=1; AJvYcCVmaXcXYjeE9VwvlopnLMhadr7lkg9eXBUIAai0AYobL2pg1/CLnyQCXqXZBvDWWpeKVw7uKOWgDQ==@kvack.org
X-Gm-Message-State: AOJu0YxzfEL0xaGEpFK9xEuNS32u9PyaKN4Ez0tcoYLHOlzEZqhi2uTN
	WSfsVsTFFddF05GlQoJOmX8pS11iDn4X8NZ+2Kiir4a0AyRL8QawvwET
X-Gm-Gg: AZuq6aI1rgi+/NxtvJmuJlioDXPzP+9bRN1ShRSCrtiwvYHDaJDvRjLeAa6DI9YSr/Y
	NWzmaRB0GNke1x9iYSV+cmpMBr4kk5kqD+qyd1N4nezfdhlQL1IHBv6k42IuJNa2D816VHZDitj
	HyZTx9tDsxe4bSQ4/U1+63gEGb2Cl/fa1Wws+DzSsYd9yhh8QxM+GOM3VHo8QtORY1JQtvFEqkW
	nSW0FojJifMZTx9hUfIQ39H+r/bQ/VgIlJSegxCbTqo67WI4AOH27EUsg2xZeQ0D5FNYNj0Wqkj
	kSQM2FlTmLIxi4K7H8jrSLvCa+vwZNETn5NeJ20MT6w2M29PdCtUcAhnKZmK/aHTDfNsrLVYZEf
	npuMAVHYcD6zyjfJddw2ghNOml/HD5+hDZx/sa6gLC5vfOwGpuJ651ujpE2lOO2LrScU6BD9wgD
	iN98GSy51NU5hX/fYnA3z6/Dsf+Qhe1PEJgw==
X-Received: by 2002:a05:7022:7a2:b0:122:153:d161 with SMTP id a92af1059eb24-126f477cf4amr2706153c88.17.1770270374198;
        Wed, 04 Feb 2026 21:46:14 -0800 (PST)
Received: from [10.36.158.92] ([50.175.227.221])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-126f4e05ce7sm3514842c88.1.2026.02.04.21.46.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Feb 2026 21:46:13 -0800 (PST)
Message-ID: <582ffff0-c1ed-4a25-9130-1b1c9d290998@gmail.com>
Date: Wed, 4 Feb 2026 21:46:12 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 00/12] mm: PUD (1GB) THP implementation
Content-Language: en-GB
To: Frank van der Linden <fvdl@google.com>
Cc: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, lorenzo.stoakes@oracle.com,
 linux-mm@kvack.org, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <3561FD10-664D-42AA-8351-DE7D8D49D42E@nvidia.com>
 <20f92576-e932-435f-bb7b-de49eb84b012@gmail.com>
 <CAPTztWacSRGa36qv7jmGL9bL600t8K8x+31tbPEsvfY=qrnsNw@mail.gmail.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <CAPTztWacSRGa36qv7jmGL9bL600t8K8x+31tbPEsvfY=qrnsNw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BA557120002
X-Stat-Signature: xsnixrwizeiqqrz6d1o9peecadgurpe3
X-Rspam-User: 
X-HE-Tag: 1770270375-628615
X-HE-Meta: U2FsdGVkX1/jKzenDfmr3DEVy8dQTlUlxketDg55hLkoKE9/+bLspKVpsbkiJjIOu+T516cEz67XsIM3to0zROWl30MG5EFWJsGrs7SaeoxCiVktQQxyLj1sBHhpafVU7ylzfItLo4VpoCwTJNjlivzqiAKNK8ASZcjg5/4MZ3+sl4NRgvE/0Wu7TlcdteL7bw2r5/972qtOrDJMNVEY7kHL3bLv8X4wbleoAxsshtAd8WMqQVVhX/SiYX37qc6U6u2ILOptDsoDSiBGEAX161GpEVi+VwL8hZ8wBXagU0FzSyqtzsTUReRMeJR4TRwkmldxlITqAHbZi3ZzQCKsvokE12IEL/QuOcWpl9V11KzR5Wq0OHRdlVh8yT7Rq/20/uU8eG18++rZxbwOAMqp7vDeMaIQT4ffAbssbOc2FCiXIfJvdj6hlNZloartua5dKKEPal3s5+N4UZUb/01vf2an8JTvb7/6mqD8o9Vppgp8c94rQDtHdf/sTJVzl/MgtncFK98G2iCkSzxcbDLy6TXuveXKy018mcl8x/9DkjnxpDw08usT9+L6yAPZiuUirF+7Hq5DgUaQvhxA0yMeNm/CptWU+Ckkq/MjQaI8WxWy1Dr694EI4rQwzlCMJnFp2ymyxXu1FD+8XJ+5D3vcKCUu8cZKRo40pRkb8dWsjM8ojcAiirG4RqyJJBHE6mTWsXyNtfWiIe+7kIQjLTXhtr0gdw7gItxFnCtOjHDnaUtJsm2KbCP5XwRfv1RQL/Hxo3et2/cZoCOMgkOSu0gm5cj1TnAQ92MbDQpjU2i0TW11nENOyMfErt3/p9BIlWLyHK+VxGgJLs2TxH0c/AsJ65c8P4RpoZzLu7kMMTZOZwtopI2gMR+ZA0T6dIfctaZRka7zBAwlkmbNr6FnNoSEK0724M5qcAREA2kEwor0ZeHxnQ54vWOw63ec29LKHogn5SC32nPtxmmuNM9RNwS
 hi+OCjEp
 5TKhFkTaotlJmaTT1m5pkIs257tI8hJBsljpLmT3mIYJuH3tbg4fSqAKSroo5k0FczqAvVwuIPS/auEF4+oIKWxhomhTJGIpgqbaMmhInQv61rkeK6Qh0LP8yUw0K8y51NOO9W99csdAmHkAZMevLoi7bLj4Q3BzmdEjRJcTXC91GZ8E6Kw69rK0SenELLCGdIfIknnZP2OCtgZxDyDVdKvkg62F7ViywuRq0jQxI1NuL4TV3FgaltKgzdP4cVZsscTD8WLx6GfnBsxEq1bnBRcpGR+m7gLEnGbs3dHYlPY0zzsGHZydcUQgWZ/9xBew4sKZoS3yqCFL4nsqfJjjyDI3gYCijutCefUd8SAVxPmLDm/B5m6gDPYtts6vGPm25ueUEI9TQ5yUO9L/1PcP+1kgh+awulSSCOiyQhW7hujbbmxO77cC9VIa+2OscNQFqSey+C4ZSJc+7IBaw6XKWtnrBpNJgXXw+95HWhK4xU/VzoKvWdrC4pfQ6ymHHPA3ibW8wos3ceveP/w+88yJhij/UhG4lzmW/Z96atAStrBwT5cP5T7k2LeUWOi1K5y6fJHxhK2t5cdmmeZkqhrfZg18COugxkQ2zVCiR2GcqL+VIIsHQwcGRxcSmLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 03/02/2026 16:08, Frank van der Linden wrote:
> On Tue, Feb 3, 2026 at 3:29 PM Usama Arif <usamaarif642@gmail.com> wrote:
>>
>>
>>
>> On 02/02/2026 08:24, Zi Yan wrote:
>>> On 1 Feb 2026, at 19:50, Usama Arif wrote:
>>>
>>>> This is an RFC series to implement 1GB PUD-level THPs, allowing
>>>> applications to benefit from reduced TLB pressure without requiring
>>>> hugetlbfs. The patches are based on top of
>>>> f9b74c13b773b7c7e4920d7bc214ea3d5f37b422 from mm-stable (6.19-rc6).
>>>
>>> It is nice to see you are working on 1GB THP.
>>>
>>>>
>>>> Motivation: Why 1GB THP over hugetlbfs?
>>>> =======================================
>>>>
>>>> While hugetlbfs provides 1GB huge pages today, it has significant limitations
>>>> that make it unsuitable for many workloads:
>>>>
>>>> 1. Static Reservation: hugetlbfs requires pre-allocating huge pages at boot
>>>>    or runtime, taking memory away. This requires capacity planning,
>>>>    administrative overhead, and makes workload orchastration much much more
>>>>    complex, especially colocating with workloads that don't use hugetlbfs.
>>>
>>> But you are using CMA, the same allocation mechanism as hugetlb_cma. What
>>> is the difference?
>>>
>>
>> So we dont really need to use CMA. CMA can help a lot ofcourse, but we dont *need* it.
>> For e.g. I can run the very simple case [1] of trying to get 1G pages in the upstream
>> kernel without CMA on my server and it works. The server has been up for more than a week
>> (so pretty fragmented), is running a bunch of stuff in the background, uses 0 CMA memory,
>> and I tried to get 20x1G pages on it and it worked.
>> It uses folio_alloc_gigantic, which is exactly what this series uses:
>>
>> $ uptime -p
>> up 1 week, 3 days, 5 hours, 7 minutes
>> $ cat /proc/meminfo | grep -i cma
>> CmaTotal:              0 kB
>> CmaFree:               0 kB
>> $ echo 20 | sudo tee /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
>> 20
>> $ cat /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
>> 20
>> $ free -h
>>                total        used        free      shared  buff/cache   available
>> Mem:           1.0Ti       142Gi       292Gi       143Mi       583Gi       868Gi
>> Swap:          129Gi       3.5Gi       126Gi
>> $ ./map_1g_hugepages
>> Mapping 20 x 1GB huge pages (20 GB total)
>> Mapped at 0x7f43c0000000
>> Touched page 0 at 0x7f43c0000000
>> Touched page 1 at 0x7f4400000000
>> Touched page 2 at 0x7f4440000000
>> Touched page 3 at 0x7f4480000000
>> Touched page 4 at 0x7f44c0000000
>> Touched page 5 at 0x7f4500000000
>> Touched page 6 at 0x7f4540000000
>> Touched page 7 at 0x7f4580000000
>> Touched page 8 at 0x7f45c0000000
>> Touched page 9 at 0x7f4600000000
>> Touched page 10 at 0x7f4640000000
>> Touched page 11 at 0x7f4680000000
>> Touched page 12 at 0x7f46c0000000
>> Touched page 13 at 0x7f4700000000
>> Touched page 14 at 0x7f4740000000
>> Touched page 15 at 0x7f4780000000
>> Touched page 16 at 0x7f47c0000000
>> Touched page 17 at 0x7f4800000000
>> Touched page 18 at 0x7f4840000000
>> Touched page 19 at 0x7f4880000000
>> Unmapped successfully
>>
>>
>>
>>
>>>>
>>>> 4. No Fallback: If a 1GB huge page cannot be allocated, hugetlbfs fails
>>>>    rather than falling back to smaller pages. This makes it fragile under
>>>>    memory pressure.
>>>
>>> True.
>>>
>>>>
>>>> 4. No Splitting: hugetlbfs pages cannot be split when only partial access
>>>>    is needed, leading to memory waste and preventing partial reclaim.
>>>
>>> Since you have PUD THP implementation, have you run any workload on it?
>>> How often you see a PUD THP split?
>>>
>>
>> Ah so running non upstream kernels in production is a bit more difficult
>> (and also risky). I was trying to use the 512M experiment on arm as a comparison,
>> although I know its not the same thing with PAGE_SIZE and pageblock order.
>>
>> I can try some other upstream benchmarks if it helps? Although will need to find
>> ones that create VMA > 1G.
>>
>>> Oh, you actually ran 512MB THP on ARM64 (I saw it below), do you have
>>> any split stats to show the necessity of THP split?
>>>
>>>>
>>>> 5. Memory Accounting: hugetlbfs memory is accounted separately and cannot
>>>>    be easily shared with regular memory pools.
>>>
>>> True.
>>>
>>>>
>>>> PUD THP solves these limitations by integrating 1GB pages into the existing
>>>> THP infrastructure.
>>>
>>> The main advantage of PUD THP over hugetlb is that it can be split and mapped
>>> at sub-folio level. Do you have any data to support the necessity of them?
>>> I wonder if it would be easier to just support 1GB folio in core-mm first
>>> and we can add 1GB THP split and sub-folio mapping later. With that, we
>>> can move hugetlb users to 1GB folio.
>>>
>>
>> I would say its not the main advantage? But its definitely one of them.
>> The 2 main areas where split would be helpful is munmap partial
>> range and reclaim (MADV_PAGEOUT). For e.g. jemalloc/tcmalloc can now start
>> taking advantge of 1G pages. My knowledge is not that great when it comes
>> to memory allocators, but I believe they track for how long certain areas
>> have been cold and can trigger reclaim as an example. Then split will be useful.
>> Having memory allocators use hugetlb is probably going to be a no?
>>
>>
>>> BTW, without split support, you can apply HVO to 1GB folio to save memory.
>>> That is a disadvantage of PUD THP. Have you taken that into consideration?
>>> Basically, switching from hugetlb to PUD THP, you will lose memory due
>>> to vmemmap usage.
>>>
>>
>> Yeah so HVO saves 16M per 1G, and the page depost mechanism adds ~2M as per 1G.
>> We have HVO enabled in the meta fleet. I think we should not only think of PUD THP
>> as a replacement for hugetlb, but to also enable further usescases where hugetlb
>> would not be feasible.
>>
>> Ater the basic infrastructure for 1G is there, we can work on optimizing, I think
>> there would be a a lot of interesting work we can do. HVO for 1G THP would be one
>> of them?
>>
>>>>
>>>> Performance Results
>>>> ===================
>>>>
>>>> Benchmark results of these patches on Intel Xeon Platinum 8321HC:
>>>>
>>>> Test: True Random Memory Access [1] test of 4GB memory region with pointer
>>>> chasing workload (4M random pointer dereferences through memory):
>>>>
>>>> | Metric            | PUD THP (1GB) | PMD THP (2MB) | Change       |
>>>> |-------------------|---------------|---------------|--------------|
>>>> | Memory access     | 88 ms         | 134 ms        | 34% faster   |
>>>> | Page fault time   | 898 ms        | 331 ms        | 2.7x slower  |
>>>>
>>>> Page faulting 1G pages is 2.7x slower (Allocating 1G pages is hard :)).
>>>> For long-running workloads this will be a one-off cost, and the 34%
>>>> improvement in access latency provides significant benefit.
>>>>
>>>> ARM with 64K PAGE_SZIE supports 512M PMD THPs. In meta, we have a CPU
>>>> bound workload running on a large number of ARM servers (256G). I enabled
>>>> the 512M THP settings to always for a 100 servers in production (didn't
>>>> really have high expectations :)). The average memory used for the workload
>>>> increased from 217G to 233G. The amount of memory backed by 512M pages was
>>>> 68G! The dTLB misses went down by 26% and the PID multiplier increased input
>>>> by 5.9% (This is a very significant improvment in workload performance).
>>>> A significant number of these THPs were faulted in at application start when
>>>> were present across different VMAs. Ofcourse getting these 512M pages is
>>>> easier on ARM due to bigger PAGE_SIZE and pageblock order.
>>>>
>>>> I am hoping that these patches for 1G THP can be used to provide similar
>>>> benefits for x86. I expect workloads to fault them in at start time when there
>>>> is plenty of free memory available.
>>>>
>>>>
>>>> Previous attempt by Zi Yan
>>>> ==========================
>>>>
>>>> Zi Yan attempted 1G THPs [2] in kernel version 5.11. There have been
>>>> significant changes in kernel since then, including folio conversion, mTHP
>>>> framework, ptdesc, rmap changes, etc. I found it easier to use the current PMD
>>>> code as reference for making 1G PUD THP work. I am hoping Zi can provide
>>>> guidance on these patches!
>>>
>>> I am more than happy to help you. :)
>>>
>>
>> Thanks!!!
>>
>>>>
>>>> Major Design Decisions
>>>> ======================
>>>>
>>>> 1. No shared 1G zero page: The memory cost would be quite significant!
>>>>
>>>> 2. Page Table Pre-deposit Strategy
>>>>    PMD THP deposits a single PTE page table. PUD THP deposits 512 PTE
>>>>    page tables (one for each potential PMD entry after split).
>>>>    We allocate a PMD page table and use its pmd_huge_pte list to store
>>>>    the deposited PTE tables. This ensures split operations don't fail due
>>>>    to page table allocation failures (at the cost of 2M per PUD THP)
>>>>
>>>> 3. Split to Base Pages
>>>>    When a PUD THP must be split (COW, partial unmap, mprotect), we split
>>>>    directly to base pages (262,144 PTEs). The ideal thing would be to split
>>>>    to 2M pages and then to 4K pages if needed. However, this would require
>>>>    significant rmap and mapcount tracking changes.
>>>>
>>>> 4. COW and fork handling via split
>>>>    Copy-on-write and fork for PUD THP triggers a split to base pages, then
>>>>    uses existing PTE-level COW infrastructure. Getting another 1G region is
>>>>    hard and could fail. If only a 4K is written, copying 1G is a waste.
>>>>    Probably this should only be done on CoW and not fork?
>>>>
>>>> 5. Migration via split
>>>>    Split PUD to PTEs and migrate individual pages. It is going to be difficult
>>>>    to find a 1G continguous memory to migrate to. Maybe its better to not
>>>>    allow migration of PUDs at all? I am more tempted to not allow migration,
>>>>    but have kept splitting in this RFC.
>>>
>>> Without migration, PUD THP loses its flexibility and transparency. But with
>>> its 1GB size, I also wonder what the purpose of PUD THP migration can be.
>>> It does not create memory fragmentation, since it is the largest folio size
>>> we have and contiguous. NUMA balancing 1GB THP seems too much work.
>>
>> Yeah this is exactly what I was thinking as well. It is going to be expensive
>> and difficult to migrate 1G pages, and I am not sure if what we get out of it
>> is worth it? I kept the splitting code in this RFC as I wanted to show that
>> its possible to split and migrate and the rejecting migration code is a lot easier.
>>
>>>
>>> BTW, I posted many questions, but that does not mean I object the patchset.
>>> I just want to understand your use case better, reduce unnecessary
>>> code changes, and hopefully get it upstreamed this time. :)
>>>
>>> Thank you for the work.
>>>
>>
>> Ah no this is awesome! Thanks for the questions! Its basically the discussion I
>> wanted to start with the RFC.
>>
>>
>> [1] https://gist.github.com/uarif1/35dcd63f9d76048b07eb5c16ace85991
>>
>>
> 
> It looks like the scenario you're going for is an application that
> allocates a sizeable chunk of memory upfront, and would like it to be
> 1G pages as much as possible, right?
> 

Hello!

Yes. But also it doesnt need to be a single chunk (VMA).

> You can do that with 1G THPs, the advantage being that any failures to
> get 1G pages are not explicit, so you're not left with having to grow
> the number of hugetlb pages yourself, and see how many you can use.
> 
> 1G THPs seem useful for that. I don't recall all of the discussion
> here, but I assume that hooking 1G THP support in to khugepaged is
> quite something else - the potential churn to get an 1G page could
> well cause more system interference than you'd like.
> 

Yes completely agree.

> The CMA scenario Rik was talking about is similar: you set
> hugetlb_cma=NG, and then, when you need 1G pages, you grow the hugetlb
> pool and use them. Disadvantage: you have to do it explicitly.
> 
> However, hugetlb_cma does give you a much larger chance of getting
> those 1G pages. The example you give, 20 1G pages on a 1T system where
> there is 292G free, isn't much of a problem in my experience. You
> should have no problem getting that amount of 1G pages. Things get
> more difficult when most of your memory is taken - hugetlb_cma really
> helps there. E.g. we have systems that have 90% hugetlb_cma, and there
> is a pretty good success rate converting back and forth between
> hugetlb and normal page allocator pages with hugetlb_cma, while
> operating close to that 90% hugetlb coverage. Without CMA, the success
> rate drops quite a bit at that level.

Yes agreed.
> 
> CMA balancing is a related issue, for hugetlb. It fixes a problem that
> has been known for years: the more memory you set aside for movable
> only allocations (e.g. hugetlb_cma), the less breathing room you have
> for unmovable allocations. So you risk the 'false OOM' scenario, where
> the kernel can't make an unmovable allocation, even though there is
> enough memory available, even outside of CMA. It's just that those
> MOVABLE pageblocks were used for movable allocations. So ideally, you
> would migrate those movable allocations to CMA under those
> circumstances. Which is what CMA balancing does. It's worked out very
> well for us in the scenario I list above (most memory being
> hugetlb_cma).
> 
> Anyway, I'm rambling on a bit. Let's see if I got this right:
> 
> 1G THP
>   - advantages: transparent interface
>   - disadvantage: no HVO, lower success rate under higher memory
> pressure than hugetlb_cma
> 

Yes! But also, the problem of having no HVO for THPs I think can be worked
on once the support for it is there. The lower success rate is a much more
difficult problem to solve.

> hugetlb_cma
>    - disadvantage: explicit interface, for higher values needs 'false
> OOM' avoidance
>    - advange: better success rate under pressure.
> 
> I think 1G THPs are a good solution for "nice to have" scenarios, but
> there will still be use cases where a higher success rate is preferred
> and HugeTLB is preferred.
> 

Agreed. I dont think 1G THPs can completely replace hugetlb. Maybe after
getting after several years of work to optimize it, there might be a path to it
but not at the very start.


> Lastly, there's also the ZONE_MOVABLE story. I think 1G THPs and
> ZONE_MOVABLE could work well together, improving the success rate. But
> then the issue of pinning raise its head again, and whether that
> should be allowed or configurable per zone..
> 

Ack

> - Frank



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C59C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 16:26:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B0406B0089; Fri, 25 Jul 2025 12:26:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7880E6B0098; Fri, 25 Jul 2025 12:26:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69E286B0099; Fri, 25 Jul 2025 12:26:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B0746B0089
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:26:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3560E1A0865
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:26:12 +0000 (UTC)
X-FDA: 83703314184.13.896C2B7
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf30.hostedemail.com (Postfix) with ESMTP id 36CAB8000F
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:26:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MvlTQfUc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753460770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gbOyNiEiIJ2e1ejjmOvHbBcnLLMVK4Jw6hEou8tajqo=;
	b=BH2V6TaxzdHVLGgg6SpNg9n11+8KEY5w0yvXdm4bdrnucZPn9OEC2ivU/Az5v0WBotsbRG
	NlYGqA2K97aV5kpuANCN0VuxrRGfuyNwBi97UPLBPo2niQGJzTS026Xe4005B8hddVe3QN
	Vtp+xptr4Jjn0zDSsXRM0J0a8IiqZIA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753460770; a=rsa-sha256;
	cv=none;
	b=cYeiJJTLbkVr0CRw0J0dBoMnEBbyyCxlStGOxYWhSvfSc8ZwKmyxAsUqZPSsCg/MJcx75r
	sMHBWOG5oroDPk94NYAsjWXB210k1QSU+0UolXr9f8n2ltXBuK+3C/kEUrwtNHyvx3haQi
	iZXzNolKbhc7BA22wo/aOFtBzdIJk7s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MvlTQfUc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-456108bf94bso15096915e9.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 09:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753460768; x=1754065568; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gbOyNiEiIJ2e1ejjmOvHbBcnLLMVK4Jw6hEou8tajqo=;
        b=MvlTQfUcsa2MI2ZtVCpO2K9yqpHLmJGJjssNUPLUw8ruzvcY4HSkesoVoGkeBGnyxP
         13Uo7haJJGk2Vy1EsOwL2OqGTLgbHa9MdZIttM5I2WmMERqVsXB7SFWkzYF+Wgdi6hgZ
         KQwRLvRp3rd3su5r3Ue4nOioHaxpQgXqiVvskLX9esFWkGU3drYRXEt0smQaJepIWS/E
         +/Qh1jyBpEQHP97yE+T76wUb8y6NNMDb7pQRCtZv2aw+gmEBoCSnQanRLWb0VwQpzV8c
         rvrIfyqyD0CEgU1iY6kAamHxP18dXYAo/vlhuw198Wwhxo9EHCypSXkRWM/uEYbzR5Ax
         fQRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753460768; x=1754065568;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gbOyNiEiIJ2e1ejjmOvHbBcnLLMVK4Jw6hEou8tajqo=;
        b=Blj/EsrbP1UHShrO3VqaZDYD4m8ibDii4zTWddgNqU27a4HYIKFlvBLyT+P/G8Uerc
         WdO6IFf1D1cJXlO8zQQ71zag9gvcMznbe6/oFHFNsoi7fTKcnsHe9cgufi37a7nDrQV7
         XvsGuNBZzZIFFvMWIEdnuk23GZsZGdYPEC6Lbc2G8gHf73uLAsWXCjKDVBxPUx/G4yM9
         XcsAsEIdNZ5DOiLCAG9hjltWs61m60z80lA/z3OSSq4MOdgMMX7w4NlVxmUWUZv0o0MQ
         18fZNf7SKdW+kp4lx8PczeijVEjM55Jqmr7GDTxwkBXmZGzqBjrPEetEl6l0zmNiisD5
         ming==
X-Gm-Message-State: AOJu0Ywn3Yq4KaBD0OdxsydJ4CoaNmtGDbQMzaHcq4oE+RZEQLCVzGSV
	ts4mw2xKnTrehj2tH4Rlz6DbmVckBTUa4naLIaj2yn8rzqYuJTglFjTt
X-Gm-Gg: ASbGnctHxYg56lZxUPgrf0QPlKCv0xJ4mz5ToqZmIlmJlN9FLma2tWIk1iviGj0rKAx
	JM9etriIqwatxDP/vaPHK1uH+oPbbW8qVg4fPEmRXd0VYmhyTvv7MBmpa0mqtwf0LDQS8x3GjXD
	TVXqtTWNN3rs1Zml9Q7ByzUHgfC0ET8bscGVxOB5uPNUdcL4gtwe+Oe39XXzSFJJ52j4DrgUHGI
	qfztec5IcMACc0ZU2vse4MIEl3AFg52h1vGa+RzGXLycBuVJ8cf35GHXGxxfnrrspQOE0Tn+KOQ
	KccS+pNBlkN13c71HGiMR3fLJL1S//sIgiPQKjViarw0ZaDd54Zc1r4y2oPPj0RQ/Tp3NO0d2++
	O5VTlAsnWTZv/w+smCijkmtdpzPa8uNzylkv9QSs3jtBeo6YBCjH1SqrPlni/Pp8U+KxWYP9ZLC
	d7KAFcFcEtrw==
X-Google-Smtp-Source: AGHT+IGZSDeAO48D3tedMyY+HBSJI/Xp2VnirJeIrAQRbOY2s8lt8ukKFjvdpK871/HD7tUSd8Lkrw==
X-Received: by 2002:a05:600c:a08d:b0:455:f6cd:8703 with SMTP id 5b1f17b1804b1-4587852b2e9mr17701705e9.31.1753460768023;
        Fri, 25 Jul 2025 09:26:08 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e759:7e00:8b4:7c1f:c64:2a4? ([2a02:6b6f:e759:7e00:8b4:7c1f:c64:2a4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587abc2804sm2320855e9.5.2025.07.25.09.26.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 09:26:07 -0700 (PDT)
Message-ID: <2655eea8-e598-4c26-a7dc-a8c6b494a68b@gmail.com>
Date: Fri, 25 Jul 2025 17:26:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH POC] prctl: extend PR_SET_THP_DISABLE to optionally
 exclude VM_HUGEPAGE
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, SeongJae Park <sj@kernel.org>,
 Jann Horn <jannh@google.com>, Yafang Shao <laoar.shao@gmail.com>,
 Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>
References: <20250721090942.274650-1-david@redhat.com>
 <3ec01250-0ff3-4d04-9009-7b85b6058e41@gmail.com>
 <601e015b-1f61-45e8-9db8-4e0d2bc1505e@redhat.com>
 <99e25828-641b-490b-baab-35df860760b4@gmail.com>
 <0905a63e-420e-484f-a98b-19e85fc851fa@redhat.com>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <0905a63e-420e-484f-a98b-19e85fc851fa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 36CAB8000F
X-Stat-Signature: amdmd3ce8nh6qjq7e7wjp6qyy9byqy15
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753460769-859115
X-HE-Meta: U2FsdGVkX1+F3SkOD3ay9Tt1o3KY+S/enxJHu4t0h3mxD94rEsEda0U+2KCnxzkMeu4x8PvkkcQ/UKYjHn5GMNIcnl6XNgYhdkiesVYRGwgpgOKwqARZ4Pu0XovcvtqcGwxyan1bgqTfGWQDF7xNCGxJ+o5Ugm2GJ9QxUWdu1kQVqubUzeSme9x5meFzPjb1MUQer4eI6EacgxW0fAJvtzg+uOoTWfswfpJiQND+kSgHXSIO/yxSN9Pgm2dRB8+5wdPqHYsfPd/fvt5o3jyQaRR6/dMAxybO6RQEoVJZkvinVVG7IJPsFJ1iHZOGcHkQVUZK12GMOfVJLZ/BzOg9y2DBhJhuZA+Ez/esvGQ384T1B1qOBE5z/+8Tflp5qcU1dL8CqAcCIgl2dEEa3WdGdu5UHHl3baXfQz0FSs/8XLlF9Zz9icjp92EskcR3owIhMqYb/Z409iK6MuMqigZ3C3d948DjYgKRbWfIcUAsluPl3XjkyReeMTyvsjeS51SyoxK8hAGSLbNJ8EwuvCz+sU7v5K6hPpaSgfMvElNeC0LXvaOyFahksxKOYoRk37bXBuzmQzTxQRhBf1j0mSDhhN4IyLtsg6iHoq1gH3w3+1gFrn0MgCyfQZfYXWFspUTxKJb3G9Oag+3lYkebgkduo6UI1tY1Lfty0FjVJnJ+ATGl2phJXag1qlegz/b4F6sPJVteSQhYqNxBGGqckO3UXuB/ZFe2SKcOXtyyxrr8UWn1DboE6CWJaRVZZ2SIxfdg5OswS15G6+ShPuHq1yn16E9sVLub+HohUSRPKYdFSGlfcXEKisyKtlL4+aQiVZAOt2pmCPwtbIPvEX2Aq7U7ijXFfsGZvj5iZAJGFqKkOKw7HLtlc2wIOjrkx9jpdSEdjKwK2J7de+nKCd/kbfEJIecFGWaLxnWV2x9SWHwRE+rufzwVf/z/EGEg5QxiQHdZyyZuqoSk0lBcK0p0q2v
 aqwguTqR
 tqoV5ud5I9MFncgAMlj7c4PrsRYXstjgqtO7O3yeSGv0xZJHF0/fkX5KXpU4R9voI+gFzaeNIye6ArOuWqWwMLTwY7d0JssKvFOrJQkJZH0D0opKimzepuP5An8qGNvvp8r9bE0hETEhItn84PinpULXlTpY7CwMgikRWBEoZlzeoEWIoUtM6pXhbRyxJkwL4medy2OHPh7fXrcVlu33oGkBVXI7m7Th2WGt0NzbrLoc06FNt74EkjwwU+zQOWjx3NhAUZtbSrVDGWHnUxZWmdkU/jH72dpYshr+oF9qg94jj1kI7opYyBEED3sB7iw3Qa4I8Cv+ePCYghG6svY69UVUjwYq3UouSJHo+I51G/tc+J8qETgdl4Lf726cq7O43A3URFzKiyuD5UBwytwg3b/EKtXVyym08OBzRUYck8/gqoG64I2Fycvi9FQP2RjAsgzlYfx3+aEg8i3f9MbUxXl/XxnKSPqYfXx6iMeCkiXqbTAc5vQuZ9ouZpPlhciNaMJqMW5oGNgXRIKfOR5kZWm45dzy9SGOKecO1t6B1rb7mdpEuoi+6KozaugbY0xZNd64rXbp/sxheWM6UZOM+l4vPc5GY+NeJIbg5jvqSNGcAkSRkmpdLPGHWbXTQAl22d+tEcaKY0e8lqDphtauM2isTiQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25/07/2025 14:08, David Hildenbrand wrote:
> On 25.07.25 00:27, Usama Arif wrote:
>>
>>> Hi!
>>>
>>>>
>>>> Over here, with MMF_DISABLE_THP_EXCEPT_ADVISED, MADV_HUGEPAGE will succeed as vm_flags has
>>>> VM_HUGEPAGE set, but MADV_COLLAPSE will fail to give a hugepage (as VM_HUGEPAGE is not set
>>>> and MMF_DISABLE_THP_EXCEPT_ADVISED is set) which I feel might not be the right behaviour
>>>> as MADV_COLLAPSE is "advise" and the prctl flag is PR_THP_DISABLE_EXCEPT_ADVISED?
>>>
>>> THPs are disabled for these regions, so it's at least consistent with the "disable all", but ...
>>>
>>>>
>>>> This will be checked in multiple places in madvise_collapse: thp_vma_allowable_order,
>>>> hugepage_vma_revalidate which calls thp_vma_allowable_order and hpage_collapse_scan_pmd
>>>> which also ends up calling hugepage_vma_revalidate.
>>>>> A hacky way would be to save and overwrite vma->vm_flags with VM_HUGEPAGE at the start of madvise_collapse
>>>> if VM_NOHUGEPAGE is not set, and reset vma->vm_flags to its original value at the end of madvise_collapse
>>>> (Not something I am recommending, just throwing it out there).
>>>
>>> Gah.
>>>
>>>>
>>>> Another possibility is to pass the fact that you are in madvise_collapse to these functions
>>>> as an argument, this might look ugly, although maybe not as ugly as hugepage_vma_revalidate
>>>> already has collapse control arg, so just need to take care of thp_vma_allowable_orders.
>>>
>>> Likely this.
>>>
>>>>
>>>> Any preference or better suggestions?
>>>
>>> What you are asking for is not MMF_DISABLE_THP_EXCEPT_ADVISED as I planned it, but MMF_DISABLE_THP_EXCEPT_ADVISED_OR_MADV_COLLAPSE.
>>>
>>> Now, one could consider MADV_COLLAPSE an "advise". (I am not opposed to that change)
>>>
>>
>> lol yeah I always think of MADV_COLLAPSE as an extreme version of MADV_HUGE (more of a demand
>> than an advice :)), eventhough its not persistant.
>> Which is why I think might be unexpected if MADV_HUGE gives hugepages but MADV_COLLAPSE doesn't
>> (But could just be my opinion).
>>
>>> Indeed, the right way might be telling vma_thp_disabled() whether we are in collapse.
>>>
>>> Can you try implementing that on top of my patch to see how it looks?
>>>
>>
>> My reasoning is that a process that is running with system policy always but with
>> PR_THP_DISABLE_EXCEPT_ADVISED gets THPs in exactly the same behaviour as a process that is running
>> with system policy madvise. This will help us achieve (3) that you mentioned in the
>> commit message:
>> (3) Switch from THP=madvise to THP=always, but keep the old behavior
>>       (THP only when advised) for selected workloads.
>>
>>
>> I have written quite a few selftests now for prctl SET_THP_DISABLE, both with and without
>> PR_THP_DISABLE_EXCEPT_ADVISED set incorporating your feedback on it. I have all of them passing
>> with the below diff. The diff is slightly ugly, but very simple and hopefully acceptable. If it
>> looks good, I can send a series with everything. Probably make the below diff as a separate patch
>> on top of this patch as its mostly adding an extra arg to functions and would keep the review easier?
> 
> Yes, we should do it as a separate patch, makes our life easier, because that requires more work.
> 
> We require a cleanup first, the boolean parameter for __thp_vma_allowable_orders() is no good.
> 
> I just pushed something untested to my branch (slightly adjusted patch#1 + 2 more patches), can you have a look at that? (untested ... :) )
> 

Thanks for this!
I tested it and its good, have sent it for review.




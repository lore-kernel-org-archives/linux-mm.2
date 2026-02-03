Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59FFFE8B37E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 23:29:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56C066B0005; Tue,  3 Feb 2026 18:29:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 508DE6B0088; Tue,  3 Feb 2026 18:29:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E7576B0089; Tue,  3 Feb 2026 18:29:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2092A6B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 18:29:48 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C48CB1405AD
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 23:29:47 +0000 (UTC)
X-FDA: 84404740014.27.C1B4777
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf12.hostedemail.com (Postfix) with ESMTP id B2BD640006
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 23:29:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="fEkCy/gN";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of usamaarif642@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770161385; a=rsa-sha256;
	cv=none;
	b=i368q7z+XuQGudaBnnFE4SBaZ8WoEnEtseX/Zzw7eMS7hPhulTfKNLgXN1XqK19kuMPm4a
	LwqqjegxuZwNcPfsKAD0hTgkwUzo8V0cjyH0r/jb6sEHg5I9dQtMQz712HZLgZerCnHu5q
	YI4HXoJVJAcAYS3fUbJDNI5Tdaksc6Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="fEkCy/gN";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of usamaarif642@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770161385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=juBB8LNhNkDs9vaAuLi9ezL0amh+Y4MuqMYlXXPrMXM=;
	b=u323mpQsgSbhw0zf8iq0XzQDiPwpNgwdrQdcGdAIdaeQcsqHOtMF6plqQXgjTdoHvAgNH9
	Gszm8myH1snlp73G6JMjZPPZ1YQWNtX9JhD8EVE3nyUV63gY7MkV3ZfAkCA5ajki9yqrWR
	sSdqug/LxIQnbd3DqK2zP6h+lW5jCxo=
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2b82c605dbdso1354092eec.0
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 15:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770161384; x=1770766184; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=juBB8LNhNkDs9vaAuLi9ezL0amh+Y4MuqMYlXXPrMXM=;
        b=fEkCy/gNTzIHMXqiNUYEzxBmqtekS44qFv3jqcebxxquwYyxnKp/wahsVNO8p0QcRD
         nEydf7jco1Pdiq+PpVetKn0q+dfjj3fQxHWWft0Z3ZHbJFBWoMO2pNdQfKqsR6OOaket
         HjH62ozxhbXuJBvGRcpjDpzwffSrfPkZRnqnnRJKznzewGw2efEQFrqq1evlvLZfMYcJ
         E0IbR+AgZQv8SQB22ub1OawVHAfEa8YNRIHZ1Ivpv55KP1WcgISOETSzQIXBgC63vdjZ
         AptiRIUB2W53VJ430Cmd+Tu+ykMJCGqFR53hs977K/mhRSUUsyeyIA32gt2tdUb53n0T
         P15A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770161384; x=1770766184;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=juBB8LNhNkDs9vaAuLi9ezL0amh+Y4MuqMYlXXPrMXM=;
        b=mx1YQh++YLtsl5hRK4ffzZZcmZQaxbJIjzoUjtGXUuJFqLP3Ztz0QwMZw2K/szrWJI
         oWYzHtVkRQ4bflaNc6mYRrNGH5RYhD+QcJreCGVyNX1rZgb8oLs6xS18MQCUDlSFA8S5
         z7WN0fuL9dPfD3kgq8bD2dDJ+w37i2p0FgX1acM9UNZyIYnsBdIBOOKzXK8RTMTHDJe5
         ap1Lilt3mXZUTWUDJIheEM/s6romZ3/jgOJ0d9w6xOhkTfNGU0Fsi5z7eZcinzc0XoKb
         FIrKlb4+eT2E3vU8sR+MqZKlI4e/94ZtS5K7He0V/qMvPyxHpEY+t2T91D9uqTJzMw4W
         b77w==
X-Forwarded-Encrypted: i=1; AJvYcCUHbRRMWPANknFuBOa4Xh22Wty7mvMjkc7i2VJHqwOz0iUR/UtjvlJBylsG/3nRTfXwyId48faHNQ==@kvack.org
X-Gm-Message-State: AOJu0YyG5TmS3Qyyq0CD3cYG7apGkApo9fRslTp0ERH4sga1pQDUbk5h
	p+I+pMWQLPMN8AJmL8RQgRUhwHyULykVJhzXchqfISXWNpE04dyA2jiw
X-Gm-Gg: AZuq6aJyQU9NM3T6N4ST98XqPXRoa6xhwMZY1Zc8yzDw3Xk57gi9Om/R72lE2XAzXqk
	YgWK52L9YV5bIEO+7KJq9uumzRI4/bcMyCB4kmuzHeBFmvnYkdTBtrvhRZv1UoRh/klekXquWEb
	fFAO6BSbRylVC4MEeuNF0HhbwjVAZUtuN6LNR4+IxXRhK1be66N5Y8vcsNst1LdrhClaHfJ8704
	SkvXjgcvX61FO9LTWOZinWn5xPi0QbhcqlfPMc/IVw896GqKhBQ9+YVNEqVyXuYltKGnYPkVLw7
	iFvjxJmYTvv8kemudsvOKzGexysym+4ouu2Jm4jmPPxJ4NwXy7Xt+sg/wenrneS/ml3uxbSyXl4
	aiGm5/5AznmOii/wiYfS6oT8a1pOyay5dUcZ3m1dbWbEJpq4Nu8V4NaaZBSOlwogUWBY0AD02xq
	MVCvBqORpxJssWviFwJxqk0vMQZ3kFALGxGxu4hDJSnBRXD6Q4WbNrpXAtybQtubQ=
X-Received: by 2002:a05:7300:a54c:b0:2ae:5b01:bfa5 with SMTP id 5a478bee46e88-2b8329d9434mr625155eec.32.1770161384115;
        Tue, 03 Feb 2026 15:29:44 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1151:15:1cc5:26fe:6b00:bcef? ([2620:10d:c090:500::21b0])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b832e1296dsm610825eec.4.2026.02.03.15.29.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Feb 2026 15:29:43 -0800 (PST)
Message-ID: <20f92576-e932-435f-bb7b-de49eb84b012@gmail.com>
Date: Tue, 3 Feb 2026 15:29:42 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 00/12] mm: PUD (1GB) THP implementation
Content-Language: en-GB
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, lorenzo.stoakes@oracle.com,
 linux-mm@kvack.org, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <3561FD10-664D-42AA-8351-DE7D8D49D42E@nvidia.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <3561FD10-664D-42AA-8351-DE7D8D49D42E@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B2BD640006
X-Stat-Signature: hjair4pdbmp1qkddz1oh5zyzijrqegqt
X-HE-Tag: 1770161385-344048
X-HE-Meta: U2FsdGVkX1/u68haisiwUBhkoY84A09JxUFGQi0BV6HyA8HG8DjjNW+BdF5PhuhELs+OUmCuzB6nK2hAflsfwmQCbO/7l77bA+QpUC2drI1gob2ogeJNh43g4fNEXaykK+nPpQ8Lz9C38x40Cbjcb4WUW/vfiyP6u3xziYr79D6AhbOGmW1Pm4diJjnsA2m4imcQwegT02BNUF6KbCExrmrJ8J/xEc43Wq/Nwao4AAD0/uFw3QQS/8zzbrYUMCSgGY+wV8M21Te7cjLJ95q7YoOipZbG+1Uh3XfHoyGjKr75zVlcBxf08pa63ASR0Bsl4YqBHvftsTlGeC6W6L0WaJMhXvNiDpwmKJpIEe8Z+AWxlrO40QC+5HRFcnSQNVxqLk34xcvsuuYuC6YIcLQaJOn8mHQPzYyU5RI6MuFPWk3PSHLyqv8WgMLMv5+R8guDIcj6T6sxevp3jBP9lRdVPnB7KhphdVO0u6SVzPujBezRPudn0BYPefbIexfEK7+H0yQmglmWe8uusmN+XVy6xRURyt0dBQxFm588+A5SglXaM2GcXCxjWl08BxnD+NBHiCRDFOogcnUtwjTUan0VtwXuZdMUtOK+/h+GoiHC6l/ArUaABJX4vtq89grNJQSdKV2f/OBRvbNsEWAMhqIslQ/I12V6RRp3MQ3sne6jF/SQ9HTjqbus8VJRut/IFR9lJMaHVGyNTPX3vnYhIbQmY8K9Gy4Y04jiR3TNKjU1MgWkAp6lbkMZoi7SFs+/KgctmgYZy+9MtXrs/hdvVOlufC/jHcMdsNPv7+s0jxg7KP55luULpuekyHQP5bPpEeru0cp1ULs2Mc0L0f7j+R5pBWiJOxMa7qiACHwO5zmNYuAPzNXr2X2PHuUTwmTqgZduCGmBvLbOOi16gSL8e3Oznm2qsJJDYzqlHuuYiNYvR2mEpXmzv7xRyNY6K6eeXj4Eh1NG9kBNhxobEkKTQP4
 hoAiYVUh
 wVwpVu3SC6A4MCv0hfQ3ZdnGt5RBzEinGDUKR+ylsToEW2cWYFsGUmkP9+P+NcakeyyZtrQWdTumsHDNAp2MtKEP5ZhFV+/clK39AEkNEcxNC06PnzKu5baXa58YzmBb7m0c5Ufy5Mq/x8AbYJrZOwjFzPhmn2iB34LJFEjpI6sNI8o7896AwaFa1XydohQrCNCACfWXZryKFY9zB6GekeaOyo1YyeUWrrMsvfMK1uhW0nGSiPfE0XVI8MIGga+u5aGd0JYyUjIy+LCDP9xmGIqOWN1pOfnJR07eNwiXYfo86EStVmItBqqX05aX5B3s3g150ZdeN2AXcMyjfYp94Ma+WNDPAC+JUt+RK3GJHA+zUjWEjIHhRcuX07h9SC6S+gD7cOyiybIrMI1cw58aHbJHBM0bL6dX7uaVGfYDRNSYxtW+ZUS8jp5sJ9zRgh4xKqNIRuQk46wxPwZnG1pfGvBGFt0J8JmCfzKodk+eZy8MVwC+PhocwOmf57pkuRJDfQGr9AKXvLLTi1KTsh73BnLU9Ag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/02/2026 08:24, Zi Yan wrote:
> On 1 Feb 2026, at 19:50, Usama Arif wrote:
> 
>> This is an RFC series to implement 1GB PUD-level THPs, allowing
>> applications to benefit from reduced TLB pressure without requiring
>> hugetlbfs. The patches are based on top of
>> f9b74c13b773b7c7e4920d7bc214ea3d5f37b422 from mm-stable (6.19-rc6).
> 
> It is nice to see you are working on 1GB THP.
> 
>>
>> Motivation: Why 1GB THP over hugetlbfs?
>> =======================================
>>
>> While hugetlbfs provides 1GB huge pages today, it has significant limitations
>> that make it unsuitable for many workloads:
>>
>> 1. Static Reservation: hugetlbfs requires pre-allocating huge pages at boot
>>    or runtime, taking memory away. This requires capacity planning,
>>    administrative overhead, and makes workload orchastration much much more
>>    complex, especially colocating with workloads that don't use hugetlbfs.
> 
> But you are using CMA, the same allocation mechanism as hugetlb_cma. What
> is the difference?
> 

So we dont really need to use CMA. CMA can help a lot ofcourse, but we dont *need* it.
For e.g. I can run the very simple case [1] of trying to get 1G pages in the upstream
kernel without CMA on my server and it works. The server has been up for more than a week
(so pretty fragmented), is running a bunch of stuff in the background, uses 0 CMA memory,
and I tried to get 20x1G pages on it and it worked.
It uses folio_alloc_gigantic, which is exactly what this series uses:

$ uptime -p
up 1 week, 3 days, 5 hours, 7 minutes
$ cat /proc/meminfo | grep -i cma                                                                                                                                                                                                   
CmaTotal:              0 kB                                                                                                                                                                                                                                           
CmaFree:               0 kB        
$ echo 20 | sudo tee /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages                                                                                                                                                      
20                                                                                                                                                                                                                                                                    
$ cat /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages                                                                                                                                                                     
20
$ free -h
               total        used        free      shared  buff/cache   available
Mem:           1.0Ti       142Gi       292Gi       143Mi       583Gi       868Gi
Swap:          129Gi       3.5Gi       126Gi
$ ./map_1g_hugepages 
Mapping 20 x 1GB huge pages (20 GB total)
Mapped at 0x7f43c0000000
Touched page 0 at 0x7f43c0000000
Touched page 1 at 0x7f4400000000
Touched page 2 at 0x7f4440000000
Touched page 3 at 0x7f4480000000
Touched page 4 at 0x7f44c0000000
Touched page 5 at 0x7f4500000000
Touched page 6 at 0x7f4540000000
Touched page 7 at 0x7f4580000000
Touched page 8 at 0x7f45c0000000
Touched page 9 at 0x7f4600000000
Touched page 10 at 0x7f4640000000
Touched page 11 at 0x7f4680000000
Touched page 12 at 0x7f46c0000000
Touched page 13 at 0x7f4700000000
Touched page 14 at 0x7f4740000000
Touched page 15 at 0x7f4780000000
Touched page 16 at 0x7f47c0000000
Touched page 17 at 0x7f4800000000
Touched page 18 at 0x7f4840000000
Touched page 19 at 0x7f4880000000
Unmapped successfully
                                  



>>
>> 4. No Fallback: If a 1GB huge page cannot be allocated, hugetlbfs fails
>>    rather than falling back to smaller pages. This makes it fragile under
>>    memory pressure.
> 
> True.
> 
>>
>> 4. No Splitting: hugetlbfs pages cannot be split when only partial access
>>    is needed, leading to memory waste and preventing partial reclaim.
> 
> Since you have PUD THP implementation, have you run any workload on it?
> How often you see a PUD THP split?
> 

Ah so running non upstream kernels in production is a bit more difficult
(and also risky). I was trying to use the 512M experiment on arm as a comparison,
although I know its not the same thing with PAGE_SIZE and pageblock order.

I can try some other upstream benchmarks if it helps? Although will need to find
ones that create VMA > 1G.

> Oh, you actually ran 512MB THP on ARM64 (I saw it below), do you have
> any split stats to show the necessity of THP split?
> 
>>
>> 5. Memory Accounting: hugetlbfs memory is accounted separately and cannot
>>    be easily shared with regular memory pools.
> 
> True.
> 
>>
>> PUD THP solves these limitations by integrating 1GB pages into the existing
>> THP infrastructure.
> 
> The main advantage of PUD THP over hugetlb is that it can be split and mapped
> at sub-folio level. Do you have any data to support the necessity of them?
> I wonder if it would be easier to just support 1GB folio in core-mm first
> and we can add 1GB THP split and sub-folio mapping later. With that, we
> can move hugetlb users to 1GB folio.
> 

I would say its not the main advantage? But its definitely one of them.
The 2 main areas where split would be helpful is munmap partial
range and reclaim (MADV_PAGEOUT). For e.g. jemalloc/tcmalloc can now start
taking advantge of 1G pages. My knowledge is not that great when it comes
to memory allocators, but I believe they track for how long certain areas
have been cold and can trigger reclaim as an example. Then split will be useful.
Having memory allocators use hugetlb is probably going to be a no?


> BTW, without split support, you can apply HVO to 1GB folio to save memory.
> That is a disadvantage of PUD THP. Have you taken that into consideration?
> Basically, switching from hugetlb to PUD THP, you will lose memory due
> to vmemmap usage.
> 

Yeah so HVO saves 16M per 1G, and the page depost mechanism adds ~2M as per 1G.
We have HVO enabled in the meta fleet. I think we should not only think of PUD THP
as a replacement for hugetlb, but to also enable further usescases where hugetlb
would not be feasible.

Ater the basic infrastructure for 1G is there, we can work on optimizing, I think
there would be a a lot of interesting work we can do. HVO for 1G THP would be one
of them? 

>>
>> Performance Results
>> ===================
>>
>> Benchmark results of these patches on Intel Xeon Platinum 8321HC:
>>
>> Test: True Random Memory Access [1] test of 4GB memory region with pointer
>> chasing workload (4M random pointer dereferences through memory):
>>
>> | Metric            | PUD THP (1GB) | PMD THP (2MB) | Change       |
>> |-------------------|---------------|---------------|--------------|
>> | Memory access     | 88 ms         | 134 ms        | 34% faster   |
>> | Page fault time   | 898 ms        | 331 ms        | 2.7x slower  |
>>
>> Page faulting 1G pages is 2.7x slower (Allocating 1G pages is hard :)).
>> For long-running workloads this will be a one-off cost, and the 34%
>> improvement in access latency provides significant benefit.
>>
>> ARM with 64K PAGE_SZIE supports 512M PMD THPs. In meta, we have a CPU
>> bound workload running on a large number of ARM servers (256G). I enabled
>> the 512M THP settings to always for a 100 servers in production (didn't
>> really have high expectations :)). The average memory used for the workload
>> increased from 217G to 233G. The amount of memory backed by 512M pages was
>> 68G! The dTLB misses went down by 26% and the PID multiplier increased input
>> by 5.9% (This is a very significant improvment in workload performance).
>> A significant number of these THPs were faulted in at application start when
>> were present across different VMAs. Ofcourse getting these 512M pages is
>> easier on ARM due to bigger PAGE_SIZE and pageblock order.
>>
>> I am hoping that these patches for 1G THP can be used to provide similar
>> benefits for x86. I expect workloads to fault them in at start time when there
>> is plenty of free memory available.
>>
>>
>> Previous attempt by Zi Yan
>> ==========================
>>
>> Zi Yan attempted 1G THPs [2] in kernel version 5.11. There have been
>> significant changes in kernel since then, including folio conversion, mTHP
>> framework, ptdesc, rmap changes, etc. I found it easier to use the current PMD
>> code as reference for making 1G PUD THP work. I am hoping Zi can provide
>> guidance on these patches!
> 
> I am more than happy to help you. :)
> 

Thanks!!!

>>
>> Major Design Decisions
>> ======================
>>
>> 1. No shared 1G zero page: The memory cost would be quite significant!
>>
>> 2. Page Table Pre-deposit Strategy
>>    PMD THP deposits a single PTE page table. PUD THP deposits 512 PTE
>>    page tables (one for each potential PMD entry after split).
>>    We allocate a PMD page table and use its pmd_huge_pte list to store
>>    the deposited PTE tables. This ensures split operations don't fail due
>>    to page table allocation failures (at the cost of 2M per PUD THP)
>>
>> 3. Split to Base Pages
>>    When a PUD THP must be split (COW, partial unmap, mprotect), we split
>>    directly to base pages (262,144 PTEs). The ideal thing would be to split
>>    to 2M pages and then to 4K pages if needed. However, this would require
>>    significant rmap and mapcount tracking changes.
>>
>> 4. COW and fork handling via split
>>    Copy-on-write and fork for PUD THP triggers a split to base pages, then
>>    uses existing PTE-level COW infrastructure. Getting another 1G region is
>>    hard and could fail. If only a 4K is written, copying 1G is a waste.
>>    Probably this should only be done on CoW and not fork?
>>
>> 5. Migration via split
>>    Split PUD to PTEs and migrate individual pages. It is going to be difficult
>>    to find a 1G continguous memory to migrate to. Maybe its better to not
>>    allow migration of PUDs at all? I am more tempted to not allow migration,
>>    but have kept splitting in this RFC.
> 
> Without migration, PUD THP loses its flexibility and transparency. But with
> its 1GB size, I also wonder what the purpose of PUD THP migration can be.
> It does not create memory fragmentation, since it is the largest folio size
> we have and contiguous. NUMA balancing 1GB THP seems too much work.

Yeah this is exactly what I was thinking as well. It is going to be expensive
and difficult to migrate 1G pages, and I am not sure if what we get out of it
is worth it? I kept the splitting code in this RFC as I wanted to show that
its possible to split and migrate and the rejecting migration code is a lot easier.

> 
> BTW, I posted many questions, but that does not mean I object the patchset.
> I just want to understand your use case better, reduce unnecessary
> code changes, and hopefully get it upstreamed this time. :)
> 
> Thank you for the work.
> 

Ah no this is awesome! Thanks for the questions! Its basically the discussion I
wanted to start with the RFC.


[1] https://gist.github.com/uarif1/35dcd63f9d76048b07eb5c16ace85991



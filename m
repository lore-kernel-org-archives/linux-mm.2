Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3A3CEE0AF1
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 23:22:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BB4B6B008A; Sat,  7 Feb 2026 18:22:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 193726B0092; Sat,  7 Feb 2026 18:22:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 075F06B0093; Sat,  7 Feb 2026 18:22:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E7FDA6B008A
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 18:22:16 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5582B8BC66
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 23:22:16 +0000 (UTC)
X-FDA: 84419236272.07.6CE4A67
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4571718000C
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 23:22:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HRLhACNc;
	spf=pass (imf24.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770506534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o7uGbjtIQH97yen8I5Oj6W+pgIraQBUsPcvEBY5QUSk=;
	b=4WcLq5VrxvFqsI56Yhbn0+ig3dTaZ5JGszOBy9UDjF5UZxIY3eCzxSvsMF7zWdcgA+95gV
	TGQGrLkjg5vHKLDZ1BE2UwS5kcvnEYDpandJtXbduC8B4O+KWCUhtIza5u8SCANznapDWh
	l26AsDKt7bvV7/kZkl+ZdKUT3wtGHKY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HRLhACNc;
	spf=pass (imf24.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770506534; a=rsa-sha256;
	cv=none;
	b=w0NOTl+h6IYPZ894N/7lxYBzBHsUJwf4LPlhWmLIZ/hvHmwrqi797+OaGSacbeQIoTxebD
	tPRGRzqh7rvlx+FdhdUbJXZFJ0JPKYBYgATpBtWGZH969yzxOarcNvwlg9TIW9thgjnWaf
	VHQf9qi+C9J1jntta48MvchsQxVGP48=
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-47edd6111b4so44020695e9.1
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 15:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770506532; x=1771111332; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o7uGbjtIQH97yen8I5Oj6W+pgIraQBUsPcvEBY5QUSk=;
        b=HRLhACNcq1u+CuLByjgB5cXZpVg29ImzXFeAewRiBd2aBifMEn8jTvGD1+2OpWtuOi
         sFaytZhKRNZsPwuFinFSPO2w7P0JIQn4DV9CKA9P4+F7kn/NAII4zQjjT7aw5JDpVtca
         DX6OUkXbXPB5zymsFkM8l2eLFCaUZtj1taSd0sQ0A5K4udvfqoBVaJQR5Xh4/fF1TXK/
         KVFX4qehz0NBa1ExBk4Wx82BrTrBe3hTtdI1Z9Xyd7t63yjHrO8UaM9f+UQVKz1slalf
         PCq3aouy7ahl1Njd2vUcASMRZAbeA78BZnvbHP43larS32n7cG/ZN3tEHw+Q/Xtkp+tT
         vVUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770506532; x=1771111332;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o7uGbjtIQH97yen8I5Oj6W+pgIraQBUsPcvEBY5QUSk=;
        b=gB0LGuH8YX80uTCXIj4P+Y9itBIBjpLMAjTFYlDTi8uOARFlrIyW0FjAGQjnWT/slr
         a+2G+Al8QfS+oRKNDnLqFoU4P/C54NPhmNJll2Hnq9fcdnGReSvKl4Od5XgTWGzddj5+
         4uo2E1LvBz8Og/qgKymh0uGh9wfj7LvOJAebh6TA5N2vyXIVyq0UKt7yo/yXO38dKHSA
         84I20JKhwVWySNlLDUgKa/NnNusq85M+ABQ9tB9jc093zDTzI5AWEJKG0/T3wa1NjLxA
         ahA43RW70FmAUlNcz34M/kFauLFyeWKiI0fv2NiHvySpihGjyna2Cuf5VUtMGtw+J7xO
         TXWQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7gFgeOQL2Dtpx4EXgBRcpi0oPOEXuJAUJOx9loZ2GWREnCytSL/022HvLu5+pskAKQP5tvQJH3A==@kvack.org
X-Gm-Message-State: AOJu0YyTmVZoYhXOU8Q1v5F20gYPRYiqDEXut2xwipKGnUWhuiB97CGn
	OxMO5HaUYBv4O5eUVSABJytDf+awPYRLZKtdVmR27fceblgRvF4uFJEm
X-Gm-Gg: AZuq6aLc/yzvNj2yLS9UDWX7KjeTHfmTzttseV/roXpHPxpPhLmYNmRTWHRBBKrUNIp
	EMYHz7WZWDVTSaFJ+9R6DwIwZcaCNyuuTMWy1mKFfCrRwlR3u3jeayOtM7bnJ9omS/+nSugvMCf
	18NpNx27HTx6OfZgd2tYwmLz81kavEu4X9/8TjsFxA037JzcdAGUqfaRMnCKX0dE5LhJ7hkRm2h
	f6Gl24rNJnkUqOWY3Tra74rfRvVKKvwZBnR7QzCe1D//xHdhff+Snov4G213GFo2wZuSlSNeI3c
	8+IKSxJ6U7TUhegLSoXbFJjmE7ekkLbmzI8cJjwg17WUwKM0hAZpFbvvL9DQdY8mpDpICAx/pAP
	fheJncZYxzniZhr6Ojw3eQDSHqBhiHHpJbgXqT1NU5PBruoyDa18lJ+lHUtvzwC09Z+wlnksBav
	p0TayJVWPRwEEY9zLVwpIRbgBU98FcySec/sZo6p7iMAn2vaBA9N7XVNrCQrq211H2NAo7h3n4n
	NSUuKLu8St71vjm1yY55tn5ow==
X-Received: by 2002:a05:600c:1d14:b0:47d:6140:3284 with SMTP id 5b1f17b1804b1-4832022a369mr94704595e9.37.1770506532231;
        Sat, 07 Feb 2026 15:22:12 -0800 (PST)
Received: from ?IPV6:2a02:6b6f:e752:9400:18cf:c773:ee86:c436? ([2a02:6b6f:e752:9400:18cf:c773:ee86:c436])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48317d835f0sm220040975e9.14.2026.02.07.15.22.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Feb 2026 15:22:11 -0800 (PST)
Message-ID: <1ff08fb1-48bd-47fd-bb4b-259521785f1d@gmail.com>
Date: Sat, 7 Feb 2026 23:22:10 +0000
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
 <20f92576-e932-435f-bb7b-de49eb84b012@gmail.com>
 <FADAC452-20B9-49CB-B1AF-E1B7203B66D7@nvidia.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <FADAC452-20B9-49CB-B1AF-E1B7203B66D7@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9teoxjr5sp1kdss9pco8uja97gtfic1g
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4571718000C
X-HE-Tag: 1770506533-513399
X-HE-Meta: U2FsdGVkX1+1ypCOlXz58CpD6EO1NOlUD0AKq3gbdInlPgXZgbSOARAQ/lVpJp1KDRc6r2M5Q+7TxoJdGPq/dyWf2UkuHndgVEIw0tXx5pIT/KKufTgy6PAedUGaI3kR6kpisAgxtAQXWNfQivguoYLpwvhBL5IY+WOCqvJksZ4dG4uS3INJDGhnnDLFqX4mekqBYGLaVjjSMrs2O7JDEG7PkfiKrRcotf0A4ub8zhcvoKwIBRRzeoTvKvBjkC/vWW4pWuSLI958+v2/nQ9vBIbU6znnMdqIB+nu43ggEJTfItpzBg4w7zokbw9baOWTbeAlxlwR+0EDGsEb+LBT13NT0oaImFHHnjEdXxOn7IH9TSyl3B5KIrrJJYdVdHvf2g/Xq3sfuk8ix3WTr9XQzQoG6SIn1NpNUi22sb9efvsHslchmb2/4Jpd2LCIwA7Lo4e66sW1xWHmRN1UFB0TCEZtnPjaXVszrLTcVkCyEmfVU3tPxykeYEffAoZfQSczh2Mrv5h9sNy4E7kSLxxckZSYJa0aAPcrvlAWpX5vEaFqWWgtUNbDLqLpPE5BLwFbi/a49XMoUWMr18fBjwnZKxggIXfo650vFm0zuFPIQDEvGKKTNhHlpNM28lFfRUw9PL2vhBSREeFMLtXpEziusL9STAg/7ZN+uBqrOwlZ13GM0CEs4R9uxdhskGNbVaiDFxOFac6wwC6/Xr65cGEHnzZO0AyveDxOPKFhXB2KzGk3HcvoABtspUZRYuaXNLiR7dDkaG5wQhQYeEypp6rj+V3PmPcSbmcYMSfoYLYHeyjfqgPI77fqd4prH5zwHoAYribGcosDA38JnjhndR7VVleW63VLXoh5MfkoqF72jXmFsokPZFY18VrFPWc+Ua4g918PaDQnc69FYdngxw75/RLJtKHeHdtKazQuuaKNO7gp3C8vzbfjXFG4Cr3NEE5rusAqRm4ppEjHUsUYs66
 qrrnkC+y
 TkJ1nwbHBGOZT2zM1R2BeYaJjDYFdpJZ1t77cz42GjTWSgclJg0UZDBSRBOoQ//uovBgKjm+tSDfZQD4GJLqL0OWZf9GuSUWBPLJlYM3iswJnW5hd67HMnAQR/S3lk3DBCKOiSS1dCmwQImo9c606GGh63K0uPnrFFIShW2xZHK5QixPHQmjrmKzSbHXBESCzJtAGt39xEQ/JytGygIU7iNn0NyvfQ2hQBr3WwNlxb46PuK7m5mQ7zQ1it0S5ILX8In/4kclafnMlybm7fB94+jCbZn/R9L+EcFHqKu7OR4gEI81QQzDFCfBRY3Oj3ZXWtwGwN65G7q/EEhB9CZEsikdXmtFaMkc8wEpxbjj4seW35ODeyI1facI8wEu5XvMQmy06KGitPTOuPww9oaTSmoqZKPDhVgjt6YZtmN4Ya4U1de+TbZHMipsvf2yUoQH0sG7AqcCSac7LYyD09bexDvJHN9alcQxjaqG536nSYFlbPadpEpsHmeU2T5WHYIlhOL5dfBdouBMnsznge40PkGY+hc70p/D/Nk/kVc10NSE6KpJZ/z1KGSkTUCX2bxEkkgZImDdM+6dnF/CTIpaxmHUNqgX404/MB2mDaP0YuPANGPdA4LxQZ/RNmQvxHmpbCEbnERsJeZ40zsefpbLAUhHUxCX6o09nznCf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/02/2026 18:07, Zi Yan wrote:
> On 3 Feb 2026, at 18:29, Usama Arif wrote:
> 
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
> 
> OK, I see the subtle difference among CMA, hugetlb_cma, alloc_contig_pages(),
> although CMA and hugetlb_cma use alloc_contig_pages() behind the scenes:
> 
> 1. CMA and hugetlb_cma reserves some amount of memory at boot as MIGRATE_CMA
> and only CMA allocations are allowed. It is a carveout.

Yes, also there is always going to be some amount of movable non-pinned memory in
the system. So it is ok with having a certain percentage of memory dedicated to
CMA even if we never make 1G allocations, as we aren't really taking it away from
the system. When its needed for 1G allocations, the memory will just be migrated out.

> 
> 2. alloc_contig_pages() without CMA needs to look for a contiguous physical
> range without any unmovable page or pinned movable pages, so that the allocation
> can succeeds.
> 
> Your example is quite optimistic, since the free memory is much bigger than
> the requested 1GB pages, 292GB vs 20GB. Unless the worst scenario, where
> each 1GB of the free memory has 1 unmovable pages, happens, alloc_contig_pages()
> will succeed. But does it represent the product environment, where free memory
> is scarce? And in that case, how long does alloc_contig_pages() take to get
> 1GB memory? Is that delay tolerable?

So this was my personal server, which had been up for more than a week. I was
expecting the worst case as you described, but it seems that doesnt really happen.
I will also try requested a larger amount of 1G pages.

The majority of usecases for this would be applications getting the 1G pages
when they are started (when there is plenty of free memory), and holding them
for a long time. The delay is large (as I showed in the numbers below), but if
the application gets the 1G page at the start and keeps it for long time, its
a one-off cost.

> 
> This discussion all comes back to
> “should we have a dedicated source for 1GB folio?” Yu Zhao’s TAO[1] was
> interesting, since it has a dedicated zone for large folios and split is
> replaced by migrating after-split folios to a different zone. But how to
> adjust that dedicated zone size is still not determined. Lots of ideas,
> but no conclusion yet.
> 
> [1] https://lwn.net/Articles/964097/
> 

Actually I wasn't a big fan of TAO. I would rather have CMA than TAO, as atleast
you wouldn't make the memory unusable if there are no 1G allocations. But as can
be seen, neither is actually needed.

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
> 
> I think getting split stats from ARM 512MB PMD THP can give some clue about
> 1GB THP, since the THP sizes are similar (yeah, base page to THP size ratios
> are 32x different but the gap between base page size and THP size is still
> much bigger than 4KB vs 2MB).
> 

There were splits, I was running with max_ptes_none = 0, as I didn't want jobs
to OOM, and the THP shrinker was kicking in. I dont have the numbers on hand, but
I cant try and run the job again next week (It takes some time and effort to
set things up).

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
> 
> To take advantage of 1GB pages, memory allocators would want to keep that
> whole GB mapped by PUD, otherwise TLB wise there is no difference from
> using 2MB pages, right?

Yes

> I guess memory allocators would want to promote
> a set of stable memory objects to 1GB and demote them from 1GB if any
> is gone (promote by migrating them into a 1GB folio, demote by migrating
> them out of a 1GB folio) and this can avoid split.
> 
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
> 
> HVO would prevent folio split, right? Since most of struct pages are mapped
> to the same memory area. You will need to allocate more memory, 16MB, to split
> 1GB. That further decreases the motivation of splitting 1GB.

Yes, thats right.

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
> 
> Got it. Maybe reframing this patchset as 1GB folio support without split or
> migration is better?

I think split support is good to have. For e.g. on CoW, partial unmap and mprotect.
I do agree that migration support seems to have little benefit at a high cost, so
simplest to not have it.

> 
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
> 
> 
> Best Regards,
> Yan, Zi



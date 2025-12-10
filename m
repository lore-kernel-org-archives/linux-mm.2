Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A4E1D3E77D
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 22:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 589776B0006; Wed, 10 Dec 2025 17:28:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53A126B0007; Wed, 10 Dec 2025 17:28:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4286D6B0008; Wed, 10 Dec 2025 17:28:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 321FA6B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 17:28:44 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A57E716063A
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 22:28:43 +0000 (UTC)
X-FDA: 84205002126.05.9844C8F
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id CB5A3C000A
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 22:28:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iDmm5jbj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765405721; a=rsa-sha256;
	cv=none;
	b=0mDRibAkqdE5vtCkHD5cYDdpaViwTc8vsthwCbOa2Jtfs8ansNmAIsSNzGE9Hb8Ju8Ky58
	cbUtnR3TswyOEWXlL3/5/xbIwwgDa0+l7Bo9LPzEk302HDKEoKG0f5gVW4iCHJsjv1q0lk
	EnP4huoT+xO/Dd3Rop5kxqyqllIeR4A=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iDmm5jbj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765405721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Y4YR3EvZUPa1M0pk6ofj+UMivnBJWFnH2I8aOHSdEA=;
	b=5pP68zQfw3VHWJqBSirG80waI4Muad3xt/oLPwTorVDFr3IlJO49GtJ41mqMKo2ahuBJrZ
	BQB7xVGpPTP3nsWtkAwupvWoW0i5iOqOumyYn6ukb0VFDMVc7gp30VhP6AZ3AyW0drQ66V
	VWtZ+qM4d4HUoI/uUzy2loUPsXJ5myw=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-bf1b402fa3cso333100a12.3
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 14:28:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765405721; x=1766010521; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2Y4YR3EvZUPa1M0pk6ofj+UMivnBJWFnH2I8aOHSdEA=;
        b=iDmm5jbjSX/LBaY16r58Ky3YaeRNGuzLbmfvsgj0uk/UVd5WGX1g5aGWFrLBwzqKlu
         NxfKaUR6ZEJNW4Te7m5CTQYbNNtoyWJX2bJJapCR6fVHa+X6ea0bVs1qOU4Rkg6YCN4j
         TJ7NcYNbafrpkfHcZOqRAO0bsZvaeWfu11c+3BLuhuVdhOosMrE2kWp5/kK43+AKz14r
         w5Ntk8AzMC65vGzVTIEJkK2lrQnt1p+idvJFUmSjlk83COVkwq2aF/s6IMwAjpV2yZb2
         Tyu3Dh/Eb3+RI5zQ+pal+CtiX0C31kLwHbNRYy9Z5u3XbOH7E8hZLNxc3fHYkk0Q5s12
         goFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765405721; x=1766010521;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2Y4YR3EvZUPa1M0pk6ofj+UMivnBJWFnH2I8aOHSdEA=;
        b=L8DsFEdTB8+lpT49BYza+sU+UUGLVUNC1LZZBcqiSqvyDEFH5HINcXykxphpPZQkHR
         GYW9Wose7D6bquiUVHVkjkqc0/T3FS1OGx0ujGpbgRBcPllS435jn4AEZj5ZZuZUn0L/
         xkvGSXsi6yYMAJAxp0APBQU13FDUCGyFzyODjeHuN68LIBTlpH898ivdrN8Ts0Uw7/hO
         7GgVm2tfLv4qX6Wxeo2PdZFkIoo1m+4NEnBoAztGFRW9UscfjIro8XnlbakplPLifvGS
         qs/UYuHmmfG+A2Y388k78289Sy+xVJHEU7lYMYwgqxKlx3IvXfjNbnU6m10PdEoJhZxY
         ePAw==
X-Gm-Message-State: AOJu0YyyaMml/ZMTFYTwfa8UGHA8OAcbEQDrDh/+qnJWP5dXM6PHbAh+
	hj/A/vNAeoonGWfX7ACXYa64eGuY0SyQhcD4o3iQTEJCYFboNzJJ8i8c
X-Gm-Gg: ASbGnctmWSYWm1+duu0AUrVG8fDfYHSxaqIwrTefD2804yGzWQRVrVaoXK6+fSWnHw0
	7pKz8CxOdEB2wxb25flJTOp5dnL5PCGkn4/HLhpMBQ1YCLn8Aq07dljYrdzWhvvQOguC6TTtAuB
	i0TRZoteJTq51OEGiKKPngdx/CbXHaOEH4KdKYoT37FGFfWhMYp+dyo3na3fMkupc/k5kpxr+oZ
	BnBdyRAxbI7qb/KO/1XbLayE0mn/6s6/GLGnLg/Ymh2K6YYSvx06BLe7SQ5JF+tp38VUEDRGiOQ
	bu8eoBo/ri9TTCeLVN29VgPdfoFpBOXQwdpmeILSBXZuukf1HrtoowBEnzu7dYPgq230AeD366c
	QMfa+QrcYHTc+pqq0fSkIFdSmLaLvxBgVoA55xEg5T3CJDNC/uAS/WMEBPi7BxW5XlC7o8iRHof
	/LeE4ZzeAzKnOy/FIAAr/yKeLdtx3lN+f9TnCS7UWtKUE=
X-Google-Smtp-Source: AGHT+IHZ6lBnOUweOAui2ZzJf3TpHq0VX8oilk8s2hjf+9kxfxm8aifawoRpmp/EQn7l9HuOqXwLqA==
X-Received: by 2002:a05:7022:2485:b0:119:e56c:189c with SMTP id a92af1059eb24-11f2966a2ecmr2952426c88.4.1765405720243;
        Wed, 10 Dec 2025 14:28:40 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f2e2ff624sm2090304c88.12.2025.12.10.14.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 14:28:39 -0800 (PST)
Date: Wed, 10 Dec 2025 14:28:37 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm/vmalloc: request large order pages from buddy
 allocator
Message-ID: <aTn0FZig5a_DpTJg@fedora>
References: <20251021194455.33351-2-vishal.moola@gmail.com>
 <66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com>
X-Stat-Signature: sw7wrdfxyat1upmxsk58okaos45rwi7d
X-Rspam-User: 
X-Rspamd-Queue-Id: CB5A3C000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1765405721-162632
X-HE-Meta: U2FsdGVkX18c1nVeDqXPiQ+6cjGakp6+BEu4Cv7TZiljWmQBjOe21bmDDTjB71P16vpTubYieQotNvjuficNErKOtummxJkRjfkCTNTB7sq0Ek7Ll5zdXor4gDo0xISBiq0PmKHd77hWj0Wmvu/pcRbfKtqMZc7uop8FGzUqpTt/TYLCdqz2heqqW7yjdAmBUs0IAd1InbyCkXNO46HoEEQKN99O4YtzV/X6dxTi0ifiEnkfP51OBYXtYOZvLfiMwFz0ApLqQwfmQtYFu9o1BVx1jwKRT+Zy9j5CQnLUwM86+SXI9in1Nd4PUcuuA//JiB3y6pHNp7gzxObUuy8haGzSVv8/9Wsy2S8kg9VVslUVcJ3xBg6WhznT2AxPYZGl1I0RWtNZX1ZZpa09HP+IXREU5onTxnQUJKKrN1HYjKGh5CeB1FchlXxArFU77JKI+ErDesmudBnLdRaUp+yzbCfLmovgdWHZwvnJI4VRm1N1wWrPmn78aUC6UsBByOqPnq7rKX++yMz1ZMhKxHvBDru0JczpWIXN6OtLKepsGXOiEnwpeh3Ukj5v4d2g/Dhmd5MpIY4uEFWxsJWSRQ5+kd+B0bxAPWM9ePYQGOPISMYPBqf7JVMyOKt9Tv4wQHE7vzsm6qYOItONwJl5xZ7e7dyV6xzJA1o0gWibqlpSf6en9BHovXpqnjbVW7gBKDqOXNWorZ+z9l0m1fhDYyRojqBc+vkkS4F8cA4OFIu+WBNBZU4399dC/wXNutI8xVKHq6nPxFbnGDrAdPeeBf9RdcYIBtTCird/TDddmNEC15MeOwctsxTU9yGBfWv+fAnKl9G0bqtk2CmTyLN9NCbu3V/n5rtMT5icVi5G4wTcPumdiiBOCa8zJ4AO+RDgGLZVbj3P96CcEDaXgySatvTwkQp3UNorX1WMnwDRroMqs65nNmQsY6DdMHvF+VdsmxWvxI5JQmjVuxvDGcStDp7
 Ahu5d+/t
 nKpaB4eShun6TEBBDzxKTpMBwRSCI3DgfK3M3XWH+3y/kAMMVB9mS7PJjldSbPNq8o9Eu0zoEK7oIPr6uOL8xgLWx7j9g+QFlW5HBywxEp3j/m6HD0hIGgpqrXpf2b0C4pEAtjIM6iKmhthlqcEdjp/Vg++juw0FC2fO85Go0cUTHI97PRk7wJnNjClNDEtCOKr7WhxKOirqEr+evuIll16UZ+L4Igj4XxdrgbaYfUx9VUCiRfgLIXwMjC2zAS3GJzwUAt+6EO/N2SfwncnCYsqK1ymwwEw+PhE8XTxG0leJbl2uwitReH6jtsMAyztG4plzncSRsEpi0msWERsfLCSb25r2on5sokQwvS/S5RxkUtFiCkSS0yrJ6zaazeFaMOYgr6739njWsI9HHLVNvSzXyrnr0cYiGsOo6CeR6D6JqV0MVxCLEkczl7WQ31V+bbki3UHLgowPvgtcifzGd9VxDUiAkpyG2Jy8HC0+e1PSWU6M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 10, 2025 at 01:21:22PM +0000, Ryan Roberts wrote:
> Hi Vishal,
> 
> 
> On 21/10/2025 20:44, Vishal Moola (Oracle) wrote:
> > Sometimes, vm_area_alloc_pages() will want many pages from the buddy
> > allocator. Rather than making requests to the buddy allocator for at
> > most 100 pages at a time, we can eagerly request large order pages a
> > smaller number of times.
> > 
> > We still split the large order pages down to order-0 as the rest of the
> > vmalloc code (and some callers) depend on it. We still defer to the bulk
> > allocator and fallback path in case of order-0 pages or failure.
> > 
> > Running 1000 iterations of allocations on a small 4GB system finds:
> > 
> > 1000 2mb allocations:
> > 	[Baseline]			[This patch]
> > 	real    46.310s			real    0m34.582
> > 	user    0.001s			user    0.006s
> > 	sys     46.058s			sys     0m34.365s
> > 
> > 10000 200kb allocations:
> > 	[Baseline]			[This patch]
> > 	real    56.104s			real    0m43.696
> > 	user    0.001s			user    0.003s
> > 	sys     55.375s			sys     0m42.995s
> 
> I'm seeing some big vmalloc micro benchmark regressions on arm64, for which 
> bisect is pointing to this patch.

Ulad had similar findings/concerns[1]. Tldr: The numbers you are seeing
are expected for how the test module is currently written.

> The tests are all originally from the vmalloc_test module. Note that (R) 
> indicates a statistically significant regression and (I) indicates a 
> statistically improvement.
> 
> p is number of pages in the allocation, h is huge. So it looks like the 
> regressions are all coming for the non-huge case, where we want to split to 
> order-0.
> 
> +---------------------------------+----------------------------------------------------------+------------+------------------------+
> | Benchmark                       | Result Class                                             |     6-18-0 |   6-18-0-gc2f2b01b74be |
> +=================================+==========================================================+============+========================+
> | micromm/vmalloc                 | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |  514126.58 |            (R) -42.20% |
> |                                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |  320458.33 |                 -0.02% |
> |                                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |  399680.33 |            (R) -23.43% |
> |                                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |  788723.25 |            (R) -23.66% |
> |                                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |  979839.58 |                 -1.05% |
> |                                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |  481454.58 |            (R) -23.99% |
> |                                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |  615924.00 |              (I) 2.56% |
> |                                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         | 1799224.08 |            (R) -23.28% |
> |                                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         | 2313859.25 |              (I) 3.43% |
> |                                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         | 3541904.75 |            (R) -23.86% |
> |                                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         | 3597577.25 |             (R) -2.97% |
> |                                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |  487021.83 |              (I) 4.95% |
> |                                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |  344466.33 |                 -0.65% |
> |                                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |  342484.25 |                 -1.58% |
> |                                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     | 4034901.17 |            (R) -25.35% |
> |                                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |  195973.42 |                  0.57% |
> |                                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |  643489.33 |            (R) -47.63% |
> |                                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        | 2029261.33 |            (R) -27.88% |
> |                                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |   83557.08 |                 -0.22% |
> +---------------------------------+----------------------------------------------------------+------------+------------------------+
>
> I have a couple of thoughts from looking at the patch:
> 
>  - Perhaps split_page() is the bulk of the cost? Previously for this case we 
>    were allocating order-0 so there was no split to do. For h=1, split would 
>    have already been called so that would explain why no regression for that 
>    case?

For h=1, this patch shouldn't change (as long as nr_pages <
arch_vmap_{pte,pmd}_supported_shift). This is why you don't see regressions
in those cases.

>  - I guess we are bypassing the pcpu cache? Could this be having an effect? Dev 
>    (cc'ed) did some similar investigation a while back and saw increased vmalloc 
>    latencies when bypassing pcpu cache.

I'd say this is more a case of this test module targeting the pcpu
cache. The module allocates then frees one at a time, which promotes
reusing pcpu pages. [1] Has some numbers after modifying the test such
that all the allocations are made before freeing any.

>  - Philosophically is allocating physically contiguous memory when it is not 
>    strictly needed the right thing to do? Large physically contiguous blocks are 
>    a scarce resource so we don't want to waste them. Although I guess it could 
>    be argued that this actually preserves the contiguous blocks because the 
>    lifetime of all the pages is tied together. Anyway, I doubt this is the 

This was the primary incentive for this patch :)

>    reason for the slow down, since those benchmarks are not under memory 
>    pressure.
>
> Anyway, it would be good to resolve the performance regressions if we can.

Imo, the appropriate way to address these is to modify the test module
as seen in [1].

[1] https://lore.kernel.org/linux-mm/aPJ6lLf24TfW_1n7@milan/


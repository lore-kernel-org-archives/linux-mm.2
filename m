Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60789C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 16:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CCCB6B0088; Fri, 18 Sep 2026 12:04:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5566B6B008A; Fri, 18 Sep 2026 12:04:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41E976B008C; Fri, 18 Sep 2026 12:04:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1BCF56B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:04:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8D798120716
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:04:04 +0000 (UTC)
X-FDA: 85227354408.22.5A4B83B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7F34420002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:04:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ursaNtXT;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf31.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789747442;
	b=Qja6gDbUspme0OGvQeBe1WwY64dLCc70HV8nXXeR15Dyh48FhomxqzZIY/i0ByTntkFZPW
	rt2hQpeMiVIuFLL4t9cIsXublNxDsd/pNpMR6tBvQJlKXoyvidkHQPZWmAim2fIOAR2dSJ
	Y73cjSyP5IoAQhdNSili0pES61/aX/M=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ursaNtXT;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf31.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789747442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PmurH01F0iDVNZT9cHRzqBUzDEgo/whWV+kg/9eQZSo=;
	b=Tj1NtS6EdAzClTaGn10N5aHoEjQC5j0JIeXRGJnPrqXf1uR4N7RSh4XuefnqE8vhZT2Oz8
	peWL0KCxuwRSVlxg2zmFGgBe+lUOxmSdAi1eoVNBV7/jEk2NyBu/vbFvOLPFLZYoaiXy8n
	cll7pV7mXoXaL1Z83kF0/T5NZbTjKWM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CFE92168F;
	Fri, 18 Sep 2026 09:03:57 -0700 (PDT)
Received: from [10.57.83.108] (unknown [10.57.83.108])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 610943F86C;
	Fri, 18 Sep 2026 09:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789747441; bh=3do1fHEhpJFdddOzJMwgsSk4W5z16/aVCPPb79+UaWw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ursaNtXTCcqbQPlZcHlBtigESNoL8DsKRECG9Iqdkj3jgziA1On9agLeueKYJUzMZ
	 VBJ8HQsbSdEVCjUBsfg35q+YGoQJpkq7G15flXI6Y15UjIywcb2nq3FBSi+KTOFB0D
	 3OmrnfLX3muvFaMq+V/9S6YL7WX2+/DW0/+tjQys=
Message-ID: <829523cd-85a4-4f8e-b9f2-f3c1d7ce4fb1@arm.com>
Date: Fri, 18 Sep 2026 17:03:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] arm64: use hw_pte_t for fixmap HW PTEs
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
References: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
 <20260914-pte0_arm-v1-4-bb53b663e396@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260914-pte0_arm-v1-4-bb53b663e396@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7F34420002
X-Stat-Signature: y76p9q8ar6dnwj48syw5uzsmik3h4xik
X-HE-Tag: 1789747442-398268
X-HE-Meta: U2FsdGVkX184RbWD1EmmQDiO1hKh9FEarqdfNTTG8BUg5D9NK9QNE/i5r1Zdwu7kLIP0OqCwWOF0K5FcSAcqEQuBdtt19DsPQRMhIHBAM7g4kaiACJdhU/gZxFMmYc/G3HTOUmccCPeVLGP1W1CB0ulV9ihIADx8G78iafczAxvsMnFFCDPs7co4m21+ypdSNviHR3zwxJM6jTkScjkO+m7SSGoZJOgk37AtF3me5jwhWgvWYk2VQchMzFr6WSsLUdDqCahZiVyVuMzdU9VL55+I9gAg+kbJ87R7QxIL5UzYP3GVeIDqunRrAaXasKezHsnI+9vHwCp4Z8SNZdk1xVxzrIMu8IwT+Bsoj5s2+ES1OYVY/m09Q5Qo+NMWfkWhBUK88GBegoy6AFovensahMo4pSqbfE4TgCz6M3Zg3o1suKpRAlzbSWnQyilZA4lgMeUC770XU/SrF+4AZdMLHEQMgprgAvILnLuCIsLBuYrZAca2EsZCdhPvA2h8R+RzVszv/PiDFlgI0ns4v1qTwggm/dGGaa9pitLwsL+t122ZA/GjIFUpXb0KEqRAA2nacygV4mxcvZKH/AGQ+qBC1SXTkWmRO2g29NdrzPi1LYtPfWSQVKhB7vB4aBZ4ttNY7/SzwpiMm9XPi5Gfnl/fuOsxF7Cyh3USqQ4zL697GCTy4S9PD07NwtHHIWgSz/EV8mwvjvesF0Oc17cqXDblVpIxVvSlW4yrOhr6l76OR6H64X4bIlWxmifpPbPnMn50VNS3Jkc2RnE58n4ol2LsJyErtYF8dD5y4CcNMuIGG91zJbOm7+0SAHDpN0VGZwOiWnpQgYOqX6fC2MrRuBHGmO5hKbJJsGKZ+hYwpo/CaD5uYf4qiyX/HZkkz3cCt1uuMfZ6Vslugui2CTCKwsOJ2UhBDkhPbmKWR0fC8Wj2Um9FQxo3JyrVNPVkm+px/MC09XtjotqZz6iE2KkfyNf
 wGGcK86V
 CyjB7sp7El6dcuImx+00svDZ5piucJcp3qkjEGB275+xrNZzGS/X+5abU6Z+b8BHHlis2iViAJJJYeM8Rmt8Pt6hpSiHQLWJ72PGWJN0kj6LEtIw1sqADNb/ynnp+D65sUkN6Z0KGYn+H4vfUspWOWPKxwsvdWIGpngd6VIlYnHgEzsiBp9Qa+BOIRaP5t27epY2IOJKJXZ+p2Xg1esvtZYkuuNodtu5aBk+tjBl1R8C9NzaW49m6ulJqEciDXuprUpqsSP6y618IQo4rG2yDZ/GbXHOouHdCMFvbZNnrMiobdkpDOw0z/yKgK/qjo4aXY196+zK9adXxuU1mBLFprP52b0s8ldAtrU38QqGR4Mwt76stOmmHD5t7TTyX2g9QLwc93xpc8q8glDayc6y2BYPALZ37apiMpHTW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14/09/2026 14:51, Muhammad Usama Anjum wrote:
> fixmap_pte() returns a pointer into bm_pte, and early_fixmap_init_pte()
> installs those arrays as page tables. Their elements are therefore
> HW PTEs.
> 
> Change the element type of bm_pte to hw_pte_t so it matches the HW PTE
> pointers returned and passed to the accessors. This is needed before
> ARCH_HAS_HW_PTE_T makes HW PTEs and SW PTE values distinct types; the
> array dimensions and placement are unchanged.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
>  arch/arm64/mm/fixmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
> index 237a9136bc73b..709a97fe327d8 100644
> --- a/arch/arm64/mm/fixmap.c
> +++ b/arch/arm64/mm/fixmap.c
> @@ -31,7 +31,7 @@ static_assert(NR_BM_PMD_TABLES == 1);
>  
>  #define BM_PTE_TABLE_IDX(addr)	__BM_TABLE_IDX(addr, PMD_SHIFT)
>  
> -static pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __bss_pgtbl;
> +static hw_pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __bss_pgtbl;

I think in my original proposal it was impossible to have a hw_pte value; only a
hw_pte pointer was possible. Being able to create hw_pte values means that it is
possible that a hw_pte_t pointer is not actually pointing to an entry in a HW
pgtable. The main motivation for this is that we want to dereference neighbours
of a hw pte based on it's pointer and be confident that it is safe. I think this
removes some of the safety.

Clearly in this instance, bm_pte is still defined such that we have an aligned
page worth of ptes, so its ok. I'm just concerned about the potential for
changes that don't follow the rules (and don't get picked up by the compiler) in
future.

I guess that's the trade off for having something that looks like a pointer
instead of an opaque handle.

Thanks,
Ryan

>  static pmd_t bm_pmd[PTRS_PER_PMD] __bss_pgtbl __maybe_unused;
>  static pud_t bm_pud[PTRS_PER_PUD] __bss_pgtbl __maybe_unused;
>  
> 



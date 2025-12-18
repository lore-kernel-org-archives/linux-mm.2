Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAD03D6ACFF
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 13:02:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 201506B0089; Thu, 18 Dec 2025 08:02:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D0166B008A; Thu, 18 Dec 2025 08:02:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 102856B008C; Thu, 18 Dec 2025 08:02:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 007326B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:02:04 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CBCA01A012A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:02:04 +0000 (UTC)
X-FDA: 84232604568.22.3E31C05
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1C3A21C000F
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:02:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DbQ31GKB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766062923; a=rsa-sha256;
	cv=none;
	b=mh5KS0Lzo2Ui8bxitI9T/qQ7uCqlx8AFdfNyOQ4RTrqdR9tEM5OyizllgZSnZjvUALfTtl
	TlDdrbSD1tJkdmiGM4RzR2MU1eUDlKId5Dp4OdnBKHLdu2R3lLlC6jAhTjdVMyMwXvdeSN
	Wp9VFjQxBy1KVA1uXsF0PflOiAnDgeI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DbQ31GKB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766062923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PoSmTylO4ktyqQFjmCggWb1kCIbgYM9M4LaBYpz8yYA=;
	b=wVQEScOxMKt8/Nl/9XEYNqYBV7AmWa2fI5PUQ6VC5a/RH/nx6Dhgws2N4AYSMLVz5pAJC0
	NM/DZ+e6ZjV8sCY6NEDP5kg3N3V0u/hcoplyeDYbwF4nHwkH2BlR8/yNLN4ALSTFRnIrna
	tU9HehhF2URSh0TC9RnVJ8hoEUiEr2U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 805E060128;
	Thu, 18 Dec 2025 13:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF0FC4CEFB;
	Thu, 18 Dec 2025 13:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766062922;
	bh=5DO6RDJonvikBIJmz3ENuqZ6dln+OBwoslWDMriPCxQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DbQ31GKBFd/oztUBucHbc47Na0LxGXTFx7Pw4Xxwv9sS8M3jt2HPGOLVZmnDoFXAg
	 1lPYxdNXc+mmQETjuJltJAr1vJF0j6466kUMAy5JlN/ZRkJuuZTJxDosJqMv5o4x/C
	 eAJP5rOyEf3PcneZlw0xvV4NbTNPYx7udhFIC8ULB7ljmJrtcZRllxeWEmmiPI0d2y
	 +UagdKor2Ki0nJNKW8wuhmcBpqor2QAHEsRtwemp4FqRFPvBvqLNpC9wbtCxqDW7jr
	 9eSKdG7Xx2CrWyI0COT932fUrYy+93xJaTzkw9EndpEjK9NhLzeOqQulfJ3HHxAsYT
	 Y8VRgutX7DOfw==
Message-ID: <e7c8478b-1ce4-4a15-a185-de9d9121438c@kernel.org>
Date: Thu, 18 Dec 2025 14:01:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmalloc: map contiguous pages in batches for vmap()
 whenever possible
To: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, jstultz@google.com,
 linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
 linux-media@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>,
 Uladzislau Rezki <urezki@gmail.com>, Sumit Semwal <sumit.semwal@linaro.org>,
 Maxime Ripard <mripard@kernel.org>, Tangquan Zheng <zhengtangquan@oppo.com>
References: <20251215053050.11599-1-21cnbao@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251215053050.11599-1-21cnbao@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1C3A21C000F
X-Stat-Signature: 7mixee8bauwb4f5afpsqy35s6ohtf937
X-Rspam-User: 
X-HE-Tag: 1766062922-918340
X-HE-Meta: U2FsdGVkX18ImBFZW3KDeOHIT/c1ZAfaoiev0daU1o/mJjLJ2WQRFVdw2+boOL6il9C8JaRXzfIFgyOtE6grGdR5wWKNCsiQRWnr/KHIXCIql3XcXnipJtc+WX140k0Y940sTuVNhsXYcAzEOePraJHT+Q3vNr2d8O+ADHKv4fkUD7YjH2bXXnnNdcrpASeSfyCPr9IbgkE0ARqrBP+NECxLOGPpFZc2pCeA6zyeW3XQzXOdjeSziDyA4gSd6INKDe6p+VDllz0pYh7JX6cHTq5nf62NrrQ70NQwBwERX9iX56lfw7d0dfBMWkOYsM83cOS1uU9Y+TogXpg5+LXQl/fVIL7u0Uye1UO292LYZ2Ud5i2LESVnFsBxIDzJ3m+BS++R4M2TvV53KEwTZaTO9cn1FD7yPOYtHh8BGmMeT1VkjNU6Zv9JPlCeZZxYlIQ2DmPnFoHqS5ipFvMumS9Jai9CihICYWZm8onqF7NC+kiVwb+Fm+t5zpcqXWRz0Q6kULgWuEatUniGWA+DkDCvqzbxncUIbzEB2SJNkNO7usYodjPo65Td44SFT+D7NK/czKRhHwqXBt4Ac7M3yjax6Ope26MbmDxnE7IQZga9EEeMQ2UUFuzhs4lxFYVdf9uGboa/fYLvPQOyyNlXoNgSZn52gibdbYMmHcwrNV4FaykDi8z91D+9IRcX33HiTmBvzG2MpirQjGFJUlWgHzhPL1IYYV2qi4IRX6zA7neCs6ly0VINwA/QFqiYgiZua1z5MzdBVd422XehYDXCFXOcfhtB9Coyg7g4Q8STCSiOQEdBshHe1tcI3MlHqCLc0JDi8T3vaqTeBSj8ZgTAY1a0SwaBal517Z6mkiV4yFSSJIObosUv3hpRVAqGkbjd8AFiy2Zkx1KCdTnjArSUbKGKttJ6MW9GHC6PQZiUjrQTeJSNogmSBJEab8ORoXGtwN+w5peeLt65Sn79QFKmTCS
 fulx6cJM
 5LTJqdtcvdcT1wpFcmJdQFib544janGXj8Qd7bP+4hT1QAJzotu+9CKi/OWPG7EMJHo+PDGJKrfuj3tFQRe0xMZc+y5CRZlu76q92Hjj/xIW99aDrNtQGrORFsGy/55nUaJ6rQxdDvrZKvhJCnUr96Unqgm97nXZwfUW5s+xe/xJ+sjS3YAubnfWP19g1d+bQjfPU1Fb4epWDXuyByK67T/KjNIPTd3eR7g5J03SM7JlcOxz0c0HYOqVBcbBEuf2UVdsQ8TfNn61shlxXLyp9VhraudBkg4V3bSbMkzbsARsFqPGlJz8GTwcukNstUO70pvqULqfF/rtB2e+UAo4MMARLovcUd7ZZWOEVPU+nKmr8XdvsrEK2f3fY65UQ7KZjVbkRZqaigxlCOYDqTn7bhyiluQid/riEFMYqKHwlGNDxqljVCcfNcAXDCA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/15/25 06:30, Barry Song wrote:
> From: Barry Song <v-songbaohua@oppo.com>
> 
> In many cases, the pages passed to vmap() may include high-order
> pages allocated with __GFP_COMP flags. For example, the systemheap
> often allocates pages in descending order: order 8, then 4, then 0.
> Currently, vmap() iterates over every page individually—even pages
> inside a high-order block are handled one by one.
> 
> This patch detects high-order pages and maps them as a single
> contiguous block whenever possible.
> 
> An alternative would be to implement a new API, vmap_sg(), but that
> change seems to be large in scope.
> 
> When vmapping a 128MB dma-buf using the systemheap, this patch
> makes system_heap_do_vmap() roughly 17× faster.
> 
> W/ patch:
> [   10.404769] system_heap_do_vmap took 2494000 ns
> [   12.525921] system_heap_do_vmap took 2467008 ns
> [   14.517348] system_heap_do_vmap took 2471008 ns
> [   16.593406] system_heap_do_vmap took 2444000 ns
> [   19.501341] system_heap_do_vmap took 2489008 ns
> 
> W/o patch:
> [    7.413756] system_heap_do_vmap took 42626000 ns
> [    9.425610] system_heap_do_vmap took 42500992 ns
> [   11.810898] system_heap_do_vmap took 42215008 ns
> [   14.336790] system_heap_do_vmap took 42134992 ns
> [   16.373890] system_heap_do_vmap took 42750000 ns
> 

That's quite a speedup.

> Cc: David Hildenbrand <david@kernel.org>
> Cc: Uladzislau Rezki <urezki@gmail.com>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: John Stultz <jstultz@google.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Tested-by: Tangquan Zheng <zhengtangquan@oppo.com>
> Signed-off-by: Barry Song <v-songbaohua@oppo.com>
> ---
>   * diff with rfc:
>   Many code refinements based on David's suggestions, thanks!
>   Refine comment and changelog according to Uladzislau, thanks!
>   rfc link:
>   https://lore.kernel.org/linux-mm/20251122090343.81243-1-21cnbao@gmail.com/
> 
>   mm/vmalloc.c | 45 +++++++++++++++++++++++++++++++++++++++------
>   1 file changed, 39 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 41dd01e8430c..8d577767a9e5 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -642,6 +642,29 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
>   	return err;
>   }
>   
> +static inline int get_vmap_batch_order(struct page **pages,
> +		unsigned int stride, unsigned int max_steps, unsigned int idx)
> +{
> +	int nr_pages = 1;

unsigned int, maybe

Why are you initializing nr_pages when you overwrite it below?

> +
> +	/*
> +	 * Currently, batching is only supported in vmap_pages_range
> +	 * when page_shift == PAGE_SHIFT.

I don't know the code so realizing how we go from page_shift to stride 
too me a second. Maybe only talk about stride here?

OTOH, is "stride" really the right terminology?

we calculate it as

	stride = 1U << (page_shift - PAGE_SHIFT);

page_shift - PAGE_SHIFT should give us an "order". So is this a 
"granularity" in nr_pages?

Again, I don't know this code, so sorry for the question.

> +	 */
> +	if (stride != 1)
> +		return 0;
> +
> +	nr_pages = compound_nr(pages[idx]);
> +	if (nr_pages == 1)
> +		return 0;
> +	if (max_steps < nr_pages)
> +		return 0;

Might combine these simple checks

if (nr_pages == 1 || max_steps < nr_pages)
	return 0;


-- 
Cheers

David


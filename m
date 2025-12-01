Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4735D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 10:36:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26FCE6B000A; Mon,  1 Dec 2025 05:36:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 220DE6B0010; Mon,  1 Dec 2025 05:36:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 137416B002D; Mon,  1 Dec 2025 05:36:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0519E6B000A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 05:36:47 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 69755140111
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:36:42 +0000 (UTC)
X-FDA: 84170548644.05.5386E6B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 94CF8160008
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:36:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ttqxnQUl;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764585400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nHgyuftC9WzgM0HN4I5SFZq9q5VLPrk6fd655qc1Je0=;
	b=DB7ajxqZXyt1BNm8EsQuPHgCzxKwZefXkKGravDY04GjAntphLDCLKKVyn5C5RUAL7+TZo
	OpuUwvewNRVnPvsXjUtCnabarmvxglaqurl9/Acf4by+M2XWqwnimo+13faPDFsrmlBaD1
	QqyykbXtXHAzwH/6WeQEF4Qx1JaCe9s=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ttqxnQUl;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764585400; a=rsa-sha256;
	cv=none;
	b=mI53+Tn3nSaS/cAhwB3ZQObjpF1q6Icl+OWeIy1mC2ZbvbmfWp+GyXazbkaFN/JEGpfbSL
	G5EmI0lAagP0LOx0AbPzlGJw6M5kJ8nB8p0h+gNlWh4JqmNcWIj640A20w9DnTMnxlYzDz
	MiOdS1BP9zeKGeGSp5av5AnNW+Ra2kY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5CB7243952;
	Mon,  1 Dec 2025 10:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0535CC4CEF1;
	Mon,  1 Dec 2025 10:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764585399;
	bh=i/3/Rip96GcKSnLsnoJCi2BaWt5AlEQD9LD5Gy2yr64=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ttqxnQUlMyZ735APhYyyPQlNfKCxrJ7vr/YSfKPCFR/vDFgL5eOPDW09v0LT0lpDU
	 ivEril84GprJ+EjxGUybk0u36RrkTSTOptCgRjdaVWZr9v6m4kzG/4rxC7D8gIjlLg
	 x9L89WwPTIOM0SklBRUx3nfizT1F98V85iPW0HzxOWSuSouOGJXt8bSSuie3N6CKQX
	 v0aWu63LNuFVFVOuT6a7PFDevwj8J4ygb9f+9ABPHjimzoxqrBD4txoLI9eR6nynSH
	 LZPhMTEMQ3aGx4iBMHTVXXD89hmehrEftHm/iHMnsfKYW8uDA0XD02v5GozAldSMPq
	 yvKsa4tXDLWbw==
Message-ID: <ed7701d7-28c8-4760-9ccb-f22fc1e9528e@kernel.org>
Date: Mon, 1 Dec 2025 11:36:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] mm/vmap: map contiguous pages in batches whenever
 possible
To: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
 Barry Song <v-songbaohua@oppo.com>, Uladzislau Rezki <urezki@gmail.com>,
 Sumit Semwal <sumit.semwal@linaro.org>, John Stultz <jstultz@google.com>,
 Maxime Ripard <mripard@kernel.org>
References: <20251122090343.81243-1-21cnbao@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251122090343.81243-1-21cnbao@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 94CF8160008
X-Rspamd-Server: rspam02
X-Stat-Signature: e43y5hja8rihnzunpd9u6hdt131n3b9z
X-Rspam-User: 
X-HE-Tag: 1764585400-562427
X-HE-Meta: U2FsdGVkX19kikw/P90hrc3rV8zyQhj+IS4agP/MYBvl/PxyV6ZZ1zL/5yh9yUspZ7qlJD1EsZFTDifUj1mV17TZ2q4kFcNgU49EXhh+QAHvRXxRQbuECZ4VUBfUTrIUh+BuqQZSPSmDnPUOnkaa/XcZctXzL851VhFQAFkhnCWthjoCUsbTejJqobZMsg6gNQHxJn6zIixRRJ2Ag7ain+S9YKs0Ony/o/Rd/crlsHTG6heI+B4hgxQwIMm6NRV6FN6KCydOQ6TNiM9QaysySV0mq0ZEL17wyH9FmVLf8+T/wnRAYmqFJqEVGU1dKTLzQnoZlxpqhsrYVovEYzb1I+6iC6CrQnSfFuTpR3qT1iQ0BVtFHzZn+/novZby+nChNHNCYPL2FUe9WYqEFKe+MpMYU+MPn2So98nfxILN91D3DVIgMEC1gVlIkHOOe97O4DFGF6gSqHE3SYnD4w9QCZ9M5d6gzrmZjfXC/wnpWYBiNcgpa7C9vuwNy9B4u3v87azS5ARo4m4N6gWRWTeLAtRHY3VbAnR1E0Y4k55cyXINoOTpYjJhilheW+ArPHAAHJuHa/IyKlA90tMLawTl/l72LiRnaXtJz/X9MXGcxIf7iaCT3sd1gx7qBSKIc+NoHa0j661azYo0iiTIVl13121iHByUAujkStsTWm91XfjQy79DB7osOy8tqlg7tUXUGMZdWhrGDbFdKS2A5tYPdhUPp8JeFowG1b6dtMPGgmYGB3MMO7G1ZMHtlx+64170HzKWo6yoEfmf8B8xzRQPItGFOmvC0uKnAhGh9iHMTgJkkMl79MLWAQdtGgVNBpbFmurUEuS9FqJRrr50TzcXfIdhEB4Xog9VQZQzVNC2V0PvJQ6EqJuFCgup7pzXfXm+Sog40+84z84VGLUO10yjmtkqla+ow57n2QAtfzPy5J5RIC3bX+ob1iYAurPzCCQjBU1EIhhEoJVZmnWzNJE
 PVZeFjPD
 tuKapC1g38erXrZDOpwZhalpkQfqGNZLKAvAfVICemy4QEoO65wwbR4X3sJUNQFjl/KbMe/o3sLv8o+cYNRbtH8+/ZVvpcGk2Ne0RUY3QKsVsQ0SUfVVLwsbOFMMxZaKCnWT5gnEj6LvEjyXipLioYyh1Iky75XRYeh8KGRXEiRy80gEfBp4p6QVtNA3ZPlzMG0JImcBFKUSDmBhhcKYVcWJZtx6OBrcr3e0/1k4sW8f0s80WvWwE8eFLUZuqjOPZDSuZL3QbsKt/cwkKDKZJXhC8s2zkLnzg771rRpdGtmN8QqBqqx92cwQJ+7bA++Y4Ykxf7ZMK/s4FYinCZISYTU5+hgLUuVHsUMi0qKW6FxapVBBQUTiwmgdIIAoZMPxhBiVbRSc/sq421SZ4CAGCd0BJ7V84tFVf3PRl6k+s3EtAj6cnVWSNdTh7mA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/22/25 10:03, Barry Song wrote:
> From: Barry Song <v-songbaohua@oppo.com>
> 
> In many cases, the pages passed to vmap() may include
> high-order pages—for example, the systemheap often allocates
> pages in descending order: order 8, then 4, then 0. Currently,
> vmap() iterates over every page individually—even the pages
> inside a high-order block are handled one by one. This patch
> detects high-order pages and maps them as a single contiguous
> block whenever possible.
> 
> Another possibility is to implement a new API, vmap_sg().
> However, that change seems to be quite large in scope.
> 
> When vmapping a 128MB dma-buf using the systemheap,
> this RFC appears to make system_heap_do_vmap() 16× faster:
> 
> W/ patch:
> [   51.363682] system_heap_do_vmap took 2474000 ns
> [   53.307044] system_heap_do_vmap took 2469008 ns
> [   55.061985] system_heap_do_vmap took 2519008 ns
> [   56.653810] system_heap_do_vmap took 2674000 ns
> 
> W/o patch:
> [    8.260880] system_heap_do_vmap took 39490000 ns
> [   32.513292] system_heap_do_vmap took 38784000 ns
> [   82.673374] system_heap_do_vmap took 40711008 ns
> [   84.579062] system_heap_do_vmap took 40236000 ns
> 
> Cc: Uladzislau Rezki <urezki@gmail.com>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: John Stultz <jstultz@google.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Signed-off-by: Barry Song <v-songbaohua@oppo.com>
> ---
>   mm/vmalloc.c | 49 +++++++++++++++++++++++++++++++++++++++++++------
>   1 file changed, 43 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 0832f944544c..af2e3e8c052a 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -642,6 +642,34 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
>   	return err;
>   }
>   
> +static inline int get_vmap_batch_order(struct page **pages,
> +		unsigned int stride,
> +		int max_steps,
> +		unsigned int idx)

These fit into less lines.

ideally

\t\tunsigned int stride, int max_steps, unsigned int idx)

> +{

int order, nr_pages, i;
struct page *base;

But I think you can just drop "base". And order.

> +	/*
> +	 * Currently, batching is only supported in vmap_pages_range
> +	 * when page_shift == PAGE_SHIFT.
> +	 */
> +	if (stride != 1)
> +		return 0;
> +
> +	struct page *base = pages[idx];
> +	if (!PageHead(base))
> +		return 0;
> +
> +	int order = compound_order(base);
> +	int nr_pages = 1 << order;


You can drop the head check etc and simply do

nr_pages = compound_nr(pages[idx]);
if (nr_pages == 1)
	return 0;

Which raises the question: are these things folios? I assume not.

> +
> +	if (max_steps < nr_pages)
> +		return 0;
> +
> +	for (int i = 0; i < nr_pages; i++)
> +		if (pages[idx + i] != base + i)
> +			return 0;

if (num_pages_contiguous(&pages[idx], nr_pages) == nr_pages)
	return compound_order(pages[idx]);
return 0;

-- 
Cheers

David


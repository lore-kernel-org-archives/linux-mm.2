Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45570F8FA78
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 14:49:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 711016B0005; Tue, 21 Apr 2026 10:49:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C24D6B0088; Tue, 21 Apr 2026 10:49:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B15D6B0089; Tue, 21 Apr 2026 10:49:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 463C26B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:49:15 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BFDE2161017
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:49:14 +0000 (UTC)
X-FDA: 84682845828.18.714679C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id E8340140006
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:49:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d3DJ1IlJ;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776782952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M4KyndHe1vaRoQjspvRGqIr2c9i9pEhJLM5wajamvw8=;
	b=oV2kbLBV7Y9to47Yri1z+2EmFbNUBv5oDe5hRKlJfmuFG/x3FHxJ3NTbxQspORQ7NGIS0r
	hQ6NZuEdHfKncgLFhpfu35WOQD8Y/hKzp0rREczjLefImpyitHqRQ0/h2a8wubLW3f0d6W
	urEnFAISPzt9AVSCBNtdwzYIcSkUEP4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d3DJ1IlJ;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776782952; a=rsa-sha256;
	cv=none;
	b=EPUQADK6+VC9ZwX9yX4veVnRgQcuDA8EZ/4xrbmt7+KM4sjH+YxCWSFQvbSCd32oh9Cl/g
	6s2bb31WEDeSBB8jCBL7PyQ/uE7NZcQlfob7xsS9g/sNFQrt2Uj/62JajemzHDgcFOrmy9
	K5HAI3pn4sKlBjcMZrTVBsFjqEC171c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 062A66001A;
	Tue, 21 Apr 2026 14:49:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF50FC2BCB0;
	Tue, 21 Apr 2026 14:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776782951;
	bh=9uwj8qyKHyWuxqKz0DOZLf6DqKo3XXWByP91G+ZSUwk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=d3DJ1IlJr2PbIYtyPe1EHjVSNiEkQvbtkz8FxHghXcc6SkoMHCIXfC29zvDQaPl3X
	 hReetQ7y365MhJ8ANoQfUjrbljdM68N/SRI4koZfgHfluUvrDiIDBiSL81YG0UoVmn
	 64z7dgqf/RLdsZjxusvqHbJXptKGLCMGGaRyHPMRTYJAlrBPO+0JahWsEZds5cM+ww
	 FDOYCfOGW8H6YP6QcglJXrqom5no2/bOFbHUV8nRV9wUFC/nHnNk3k1U7ZV1UZdqVy
	 MnruoDufrRoC0lHDNvS4NasYzSvDgMWO7l53s/skajOoE6KewFXRwLOMCk0WDjP5Cf
	 9r5gkzb0zl0xg==
Message-ID: <fa41faf3-2d8d-4c45-9a1d-d67c71db1698@kernel.org>
Date: Tue, 21 Apr 2026 16:49:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/sparse: remove unnecessary NULL check before
 allocating mem_section
To: Sang-Heon Jeon <ekffu200098@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com
Cc: linux-mm@kvack.org
References: <20260419144225.2875654-1-ekffu200098@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260419144225.2875654-1-ekffu200098@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: sxx9oem9ho473kx3ckeknwsnpn7auith
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E8340140006
X-HE-Tag: 1776782952-995342
X-HE-Meta: U2FsdGVkX1////BvLqVApIo82OxWSUg0jl9wgbtk6Bpv9bz7AifKNUW9cw2SqJqIfTF6oPBOt4gZ77Er68GfdFFxpDv/M5GMXL9KNjiucEtz2PEr63F5kkblPwRE4z/j0g+v1/3Fhs3bVW7arp/E66z+zDYOjw4nj3gPlDSmfz+mIjJNQ5hoWV4iXZY8/s7OalJVMpQ0f4HfewbQKWXq/829XlOKL1MjNskjyjU6+P+SC79ecD8bBAUjyh3DHdni5dwEq/xY8lO5rkBlejSRRYVQZV33zlTTX3Fi5YJzm09JECHXEq4qt2Ta+3LjnbcC+DdO2sso/1VRSnLYzsh5mJ97Shg2prGR+osNNQQZndDY4h6xEH42yIM5kmV0WPnHoqrXqrPJ4d7DjA6Sc5zTeEPEQv4kXqfdRY5paP7v4VEQw7iVzZyu+sS50n9kGybmOrFk1ffUVftLz5WBQbOBzhwpQ5impEIcRXGvdUUn5iFY8D3c7/WvVuHYmR14ZxymksSZsLpYMkXLAFaOsh8i1aj9zU0v3GrAQT1CDxp3Ky7OqV2JNoRr/1uIgxcbVcrpeT0bCdwxZuWkEHyGMjqWBMNzzbM7++UEi1J6F1iOhYwiS7Ie4fic66ICeaLK6WDogVzhyR6WTRu+llPdh2r6qzl2OJhrFC0gPoT6Q+xlHQjbFG43Bmbz1mhYtdUl94k4MG2w7P3Tr5xlv57tMlhjmzCpAM77bCjTGqExa/xPuHZW52giDQBzXYY3d4OusXPiewkNYr4n/FTVIV3uZ4lvIbCK0xoo+H7UfiK62YFQOQNW+BCWSnEnS9NOseR4OENfAATILZ1U6pkxVwEWZVTNuaUunb/hgJ9TPtMAquCBQH9ti6MSZJkv6dyrTQnlSJYk9Djw/lE0LTNbG8wGvcl7pi9h4Rns0AOJSnZGI3lcnQscP76MucgKrauMaJ3UuOpbmC1mLwCVTuQPqfcxcff
 fa90jZTU
 ohoLpFL32YqlSWWqciqhgQUjRjrZHpKCI9tFr+dCY9dxom7ySBkhI5PhD/B23HapEhyg2liVR9Lb25gyUz8G4A6SK/mIwNAoeZpjJqMzK6PwX9j4TvLTVxsFGLlGbSSuNo53QMtGV48l0Jz/2soVzw+IoYTxpnsAOlvai87tZBe0c3Q9cC4Zee80iYfHS3zXhiwEiCbAy2qHGc5+VTawHrsLhoibYz+2lf6oyLybDUhopYYBDEFhGPyzTKy0omjyUrPiJ1iK7tTdMUApFtpsMRPjBOmqeRbTKV99AW3jffMAmvTpg4Lx3sFulHMlwvuSnscRUDgcT3ymWSniNp2sC50dNjqmfv6JKZUa5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/19/26 16:42, Sang-Heon Jeon wrote:
> Commit 850ed20539a4 ("mm: move array mem_section init code out
> of memory_present()") moved mem_section allocation logic
> into memblocks_present().
> 
> Before that move, memory_present() could be called multiple times, so
> unlikely() matched the common case, where most calls found mem_section
> already allocated.
> 
> After that move, memblocks_present() is called exactly once from
> sparse_init(). Under CONFIG_SPARSEMEM_EXTREME, mem_section is always
> NULL when it is called.
> 
> So remove unnecessary NULL check before allocating mem_section. No
> functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
> Hello, 
> 
> While looking into boot information, I found a minor enhancement point.
> If I misunderstood anything, please feel free to let me know.
> 
> Thank you for taking valuable time to review this work.
> 
> Best Regards,
> Sang-Heon Jeon
> ---
>  mm/sparse.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/sparse.c b/mm/sparse.c
> index effdac6b0ab1..e13f9f5fa090 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -201,13 +201,11 @@ static void __init memblocks_present(void)
>  	int i, nid;
>  
>  #ifdef CONFIG_SPARSEMEM_EXTREME
> -	if (unlikely(!mem_section)) {
> -		unsigned long size, align;
> +	unsigned long size, align;
>  
> -		size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
> -		align = 1 << (INTERNODE_CACHE_SHIFT);
> -		mem_section = memblock_alloc_or_panic(size, align);
> -	}
> +	size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
> +	align = 1 << (INTERNODE_CACHE_SHIFT);
> +	mem_section = memblock_alloc_or_panic(size, align);

Given that there is no other code that assigns mem_section

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David


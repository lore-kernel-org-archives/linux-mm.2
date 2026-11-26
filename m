Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 241CC606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OBTViuji
Received: by kanga.kvack.org (Postfix)
	id 370686B05B4; Thu, 26 Nov 2026 06:35:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31FF56B05B5; Thu, 26 Nov 2026 06:35:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20ED36B05B7; Thu, 26 Nov 2026 06:35:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA8F56B05B4
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:35:40 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7C07DC0173
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:35:40 +0000 (UTC)
X-FDA: 85477065240.04.B50DCA8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9768418000B
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:35:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OBTViuji;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795692938;
	b=RH3LlQlwGMt5d4vyp9ufZBpp6dHnzyBmoMXmM/gXzLtpFpwSAjaJfVgar3nDbgIGzKX0Fh
	F2ruWXmtll40sfX7/zEDocADuuZK5uF8nBU3BOAa4umlPqN4fNbdmKTIfoz13mF+FlG83w
	4oUMTlPn2kC5Oz0CTOlho6YI8nTd+BQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795692938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=frZQxs7rITnBs9jk9lL+5WWmyeJUszZBy2LKc65ZeqQ=;
	b=7TivAYNNZCbx2kY3lycrh3IIfxsqo9nFKOTVF8QtpqOBbJ6K/rEGqCoBux2LFxpS1cbAvG
	tjcbOgRFbXNBdI7/es5TzYEirItLOHwHMkFk/t5SD3HbkCbO+ZemtVnHdnbrvDpJSfbImx
	pxo+4ZaPL1MxUqwjv8tU/AbaZN+g1Y4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OBTViuji;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CAB0E611E0;
	Thu, 26 Nov 2026 11:35:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0D51F000C4;
	Thu, 26 Nov 2026 11:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795692937;
	bh=frZQxs7rITnBs9jk9lL+5WWmyeJUszZBy2LKc65ZeqQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OBTViuji3/YWrVQHStoV7WVWpuXBl1cgFLBnpsJoCPgNXRPJBn0J+z14D+ZwHn56A
	 2nOqtQzAdJ7qys+mqsKVdlsTpeTk6EBqhOCDXc4at34xawVGua5n1oRibcOQgTuXaV
	 vHk+bjc6F1wc2mQYkYad6FvC9RyVeAxTopE2zLLQnGhl7dlrCNfW5nZaogZxC+50UM
	 PRCLXLDIiwpqJSJMm3CB7LvsiuesRBZt3nqDjw46k7pZxE4ZYnkmf6CkWGQx92lajJ
	 467NDCYyRHyjhx1KwNIp8A+okJjaUEvX65EpBK6nQSjTKiqCm3wdcM75TJRu+Bbq6g
	 K+lrDxwP/7gkA==
Message-ID: <1fa5ac7a-0aaf-4d5e-8cd8-07df257c359a@kernel.org>
Date: Thu, 26 Nov 2026 12:35:27 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/8] mm/swapfile: add batched version of folio_put_swap
To: Dev Jain <dev.jain@arm.com>, ljs@kernel.org, akpm@linux-foundation.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com,
 linux-mm@kvack.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 pfalcato@suse.de, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20261123053543.295467-1-dev.jain@arm.com>
 <20261123053543.295467-3-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261123053543.295467-3-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9768418000B
X-Rspam-User:
X-Stat-Signature: 76ii9s5uuigupx9jywp9jghom4uqqd9z
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795692938-191273
X-HE-Meta: U2FsdGVkX1+VopRv5YVw4AhUzQTB2zgo+QtrzdCJzVD4eq1pNsrb9P1zfN+358XvTCh0MLdyxQAZzUJILCloYgHDLcS0IhrXiHnkNpK3W21jwx/6AAbnEofmPhjxdSyUi6NXw1y2jZd4XIqS6lfZkGXOFzkPM6jpa/FviBkHZRdvypMFRwzMaxHxpq+e/H1lF3my0YLMY3NLa2nos8zck5PwHMnEs5dxAbJAW7AaS5bbJmrUwLLMhBJw8uYESzbwui+BnbjKRbt4SH0Lqeg4R5iZoHQlYi/fAQ4m1A+7PW3BrqQ0Lo5u1kIHf/Q6h00bWgZdcCgNl30aCQBYZNnZXOZ9xE7P4ShWzOpwwEQGDXNF+F4gD6+zrYX/+sXd1WP08HxMyS8mLUE1KzeOB8n5funRnMg9LMDObsTfuyD6tC0imt0ABR0ZXzhOmW+pLnVxwQwutAintPzhWurReWQI+tXZX5RPP36/IyQ4qoBE1WwyRPkIFFbFGj+xjs3vXVOqab0UvyXHsTNP4rCtEdmvELLC6uKqw75cyFQfKsrBxLQT4IH6dnHSzGgTyF/f08XSeU7f/gRetT/Qv50UbLy9sPodhR8tjQLnTC8QS+LU8g+nYQd6D43AwTU5C9AITeK4sFvbIIu6VLbIxSotYu1B2Xq6dRDs969uDr4ON29Xj3CMikuiESq0FGiCbjhQ4dVa0Kb5OoATVla4CIOrhLGY6IwiLEFkkxIvfo8Up2One5Xqw/jBZdrB0PMmoeTkqg9qWZ8BPf7DpFzW3gdhUindEU54+yHg/yWDjLy2bTPUBY6Pb2s0yTMuZxQb+F/+4BuxZr/ZThhb4b1DcPDJeq0NDLCn9H2fxv+GrZKzhaNJem7rHhqBw95N5xF5hEWH1KDrhmjrmLW6zNwAZ5OmNdRQjnw9HrRS7uXmtnHZ1aHXaw/wg6F9Q3lyqloxcO86M1ZI0yaIbuaHNa8ikkLFSQA
 uH3Z7X+A
 s4cvdicGE0fo/CIEl7KpCvuWuD0RyK7Q+TbpjfBhXOmS6b8YhC6lR4bttlVeHFO2oM8LVsr7//KP4WyFnoFq7pSB8ouaSVTK4TTxm2S0A7PA51fBa1guZB9URuLreL6xF+PhtJUmwAcmoHWHsfFOImu9qq7cZJBMJb1DlqnYlINLwuTpmYvA4FQlf6XYYp5am3GDTvbqTYlsU1H9ZUZXl5cUBytYWRYXRKEdBub9KpbdnN/I+wAi94vD4Hfx5jgqx2RLcdk50jZVMmg6dGxmd0NZN00MG+eeM5YAKMPTbN0Vi6XJghBNrQo2p/5GuKlVFvRpcARGt2kJ4/sA6IBToKI9NnNlBeb8LP8fEvT3oYxmUe72M7Ok6bW9XuQq4c5x4NPt055jUaUTIPcuqB7t2ykhn+RYCLfCmO2fPnlTM9XHc3nvqDcwRn+MjBhxcaoVLk/WM77jeaVyoxD3T8rfLwVWliGfMXywLTgsMbM6IAl6jZn4bcc4rJUS01DgG+sJKTFpJSsVlnjobHkWAH5Xh++Koc+rNOTbUpjHP6DtwX7qzoHKVsEDfcgObJr/xtd577bM73KY1ULrBDkpu8WwBP8Tbc1tB11PWqnlh+4yma/IFELAwuhMSxWppMFM0zKKu97Im
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 06:35, Dev Jain wrote:
> Add folio_put_swap_pages to handle a batch of consecutive pages. Note
> that folio_put_swap already can handle a subset of this: nr_pages == 1 and
> nr_pages == folio_nr_pages(folio). Generalize this to any nr_pages.
> 
> Currently we have a not-so-nice logic of passing in subpage == NULL if
> we mean to exercise the logic on the entire folio, and subpage != NULL if
> we want to exercise the logic on only that subpage. Remove this
> indirection: the caller invokes folio_put_swap_pages() if it wants to
> operate on a range of pages in the folio (i.e nr_pages may be anything
> between 1 and folio_nr_pages()), and invokes folio_put_swap() if it
> wants to operate on the entire folio.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Kairui Song <kasong@tencent.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/memory.c   |  9 +++++----
>  mm/rmap.c     |  4 ++--
>  mm/shmem.c    |  6 +++---
>  mm/swap.h     | 17 +++++++++++++++--
>  mm/swapfile.c | 21 ++++++++++-----------
>  5 files changed, 35 insertions(+), 22 deletions(-)
> 

Looking at this again ... :)

> diff --git a/mm/memory.c b/mm/memory.c
> index 6a23198c1c67..ed6dfdb63994 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5327,8 +5327,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  	if (unlikely(folio != swapcache)) {
>  		folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
>  		folio_add_lru_vma(folio, vma);
> -		folio_put_swap(swapcache,
> -			       folio_file_page(swapcache, swp_offset(entry)));
> +		folio_put_swap_pages(swapcache,
> +				     folio_file_page(swapcache, swp_offset(entry)),
> +				     1);

Should we have a simple folio_put_swap_page() wrapper around folio_put_swap_pages() and
then just put this into a single line:

		folio_put_swap_page(swapcache, folio_file_page(swapcache, swp_offset(entry));

(also in other code)

Makes this nicer to the eye.

Apart from that LGTM!

-- 
Cheers,

David


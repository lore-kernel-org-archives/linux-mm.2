Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB8CAC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 10:09:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2A076B009E; Tue, 22 Sep 2026 06:09:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD89F6B009F; Tue, 22 Sep 2026 06:09:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC6DE6B00A0; Tue, 22 Sep 2026 06:09:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6E1AD6B009E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:09:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8B19C041F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:09:20 +0000 (UTC)
X-FDA: 85240975680.11.15A8422
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 11AC8C0005
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:09:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fcPxk3XB;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790071759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M515vgULO6sESHPjvy0cqdT6MwRgWhcOocOQQdC2Amo=;
	b=fbN9faG6/0DXjz835OvfmWXc1VXvMcm4Qk02Biw1eSTyUA9PP7a2ax7R44auQVtyN0OxG2
	KYSBqX9DnqhqlsgI5H1XCsST6Gk0Y8niGqaKLEgcmWOgx5T4IC2teIO3fs3h+1xEzfAeDK
	NIyMeh4YbXpVW1AMJpFlnsk8qfE5Uvk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790071759;
	b=szDAgrSE9TVommCKDK3muG17FFoXk6IhwvRVEo7ZE+U6AI/9FYJOORvVqqetSIDQqj0U87
	SKs2Z3ocCYgWY5H5/WXGKGt8UnE814uBxAqStfCVXxdNwiJoTIW7OIJhpBL5rHKA8z7Npi
	nClDifmTGVly2wBQ0JTi85MVC9+FpvM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fcPxk3XB;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DC32642B9E;
	Tue, 22 Sep 2026 10:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C75A1F00893;
	Tue, 22 Sep 2026 10:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790071757;
	bh=M515vgULO6sESHPjvy0cqdT6MwRgWhcOocOQQdC2Amo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fcPxk3XBeyCU+TYL6/ABeyCZ5xmnCeJqQF+1hREGVIBwOYty7TEWMIygJ0G7kWc4y
	 7JrSJ1qi8Voe0d6ovVhPYaMGwduBb3gV6fUZCL0nA4EIhdFUPjS93z4lc0Ap4jE6oY
	 kkMmg1PMzj20JBAPU3B+2mON1xz6NbYId4b3461xBDcaz3xd+vQqRdQne7Vv3FzYyf
	 5+j6OL6nzzsxPiuUBFvk+4fX7SxYoMOL9J0McXKrtiA7Pkl3ksDoo5ZnXqiHZIrLyV
	 SUdGTJo+r2njBjeQRmLUmaXHqmf0FQQylExGMR2326IWVhiac8E5vvcn7Jbhi2AeKD
	 hgO5m81MjA0Ug==
Message-ID: <f988c1ee-987b-4ca5-a679-bac42f9c91bc@kernel.org>
Date: Tue, 22 Sep 2026 12:09:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/gup: honour FOLL_PIN in NOMMU
 __get_user_pages_locked()
To: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Lance Yang <lance.yang@linux.dev>
References: <20260921-nommu_gup_pin-v4-1-c410041cc479@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260921-nommu_gup_pin-v4-1-c410041cc479@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dnty3ospuzje4jcfh3yiseh93b6rz6rt
X-Rspam-User: 
X-Rspamd-Queue-Id: 11AC8C0005
X-Rspamd-Server: rspam03
X-HE-Tag: 1790071758-404955
X-HE-Meta: U2FsdGVkX1+Jcf5BNQzXRmbXL94X1PTeVA8H8PBxg0WXUYQJueYv+/dfHKgfwIc7UJQuNmSqqqQnrg6wlBnDHt1KtFBIIIW2sQFwn5YHq7LpjErST0xGr0uDTFOlTVHXg6LrRKjy/sZ8Oe/SSrd8cmDLKpk2Y3s5f62MPVRHePIKrTKK8ZZKUN7jHubJFn5WObg7F3IPcuR7SMgrJ7R5gr6qcJsxC38I8aB0mWFlqeENDSmkhFv85RRystpQtWgdjYlmRzK/Im6LhS254+vPG0oocMi41FmtDREH0e2l4wGEmiNzb4qAv+8/2TmUpVLigkEo81TUDdMAiqtOeE0tlLy9PG7WvRzlaj7dtOeVX3zwtP5tZIgw4dkPmoeEy4J2lpaIlmljej7DVXbJO7SUeqLOI5eYmh9mhTssAHP5Ei3EzbtSEwt7xWqQIcUUTQXv5Bl//7OXpUH3+BWoWZN6FtsNKhY229N9+mNW840uh9JIvgQpLbb4WNo861DK6uRvX7t0/HI+ArGoJwbjdmjaZ4oN1jXANAJ3r4BIlUWpDtUHbpleutqfpVq653ZOgY9ZvGU20e+svnfWfnDdiLMNUKERKmLkDst5Ys2uM3X892zJEaUOb3CgTRZYRz7jwAW1NkIdjx5cJCNh1/ve8SEsrUlMwyJHuW1aqOD+9UGijG8D9haY0EeLOkkUgZpXVrwV2wQABTUDibEmPA/oeQODmJPqpcgHE79UfPJTy7NJ2nNZlj+h3c3suQieMkm+yn7Bcf04s11M8CE32NHUp8VfT5KNdERe239kevNCLP51MNTrVjmhzEBmvEFKg3dX2xvGhRLpnqxQfmRFdp8Oxon/dk6SKWbI8WCW0UpnW4MvMrB0pInfR2u4ZQ61TaeVf4REm7OlFtPUixZWAxHHuvv2iSddCwxAIR40CStUqDnN7JrJ0/LOzrkVIrJCEHr729jdXeU4Chl4+kE+aKiDdAX
 ROu7eU43
 YH1W0nbTDgjxijF+eJ3WEqhHZzwM66tJqIF4FQszdPkOLr0N1wbQykwmS/Ye6ElaH2KUVoFe2gofXeIHXc+EmwTEPkHspOMYSSmpWYstT6yNqoGw9Y1gihhwtyXU55Gg5z2nRX/OLv4ZLOG72Ra4uGTCbvHt5IJOOpKMhEezbGeSfQJv9be823zMcSxt+1ZBGY3nwQw2lJTYjnRqB+x2ChxxPtt/Zil7h0vrdE8px3dP/4SSvBC3+Vm/G+eiKhe0H4uN067jaFQrouZbJzk946lovgXd7SV+VITaejYhyfWHHmuy6Vtwhq240kIOsHWaS6QNwv4mW1asjXj51yy2hq+6wQZkcHE7/ydYtYkC/1G7MfVnKETJS9K6MfQ8QI9fy/W5JfsLl3iK7+W7kcTSmRHGlcrz4jn2wgh1VIWtzLDe3ZRs9qjBVqj4nEnLlWqyrwn/P1EmSj1sWrbqpdN/cV1kr1/1qnHvVctJ5aRi/E3b17kzJdpiuIm+4hIjOF89XDtAbelYENjU9UDicTU4CYjN74oG6/lw8xScvHm3/4w80ce8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/21/26 11:57, David Hildenbrand (Arm) wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> The !CONFIG_MMU implementation of __get_user_pages_locked() takes a bare
> get_page() reference for each page regardless of foll_flags:
> 	if (pages[i])
> 		get_page(pages[i]);
> 
> This is reached from pin_user_pages*() with FOLL_PIN set.
> unpin_user_page() is shared between MMU and NOMMU configurations and
> unconditionally calls gup_put_folio(..., FOLL_PIN), which subtracts
> GUP_PIN_COUNTING_BIAS (1024) from the folio refcount.
> 
> This means that pin adds 1, and then unpin will subtract 1024.
> 
> If a user maps a page (refcount 1), registers it 1023 times as an
> io_uring fixed buffer (1023 pin_user_pages calls -> refcount 1024), then
> unregisters: the first unpin_user_page subtracts 1024, refcount hits 0,
> the page is freed and returned to the buddy allocator.  The remaining
> 1022 unpins write into whatever was reallocated, and the user's VMA
> still maps the freed page (NOMMU has no MMU to invalidate it).
> Reallocating the page for an io_uring pbuf_ring then lets userspace
> corrupt the new owner's data through the stale mapping.
> 
> Use try_grab_folio() which adds GUP_PIN_COUNTING_BIAS for FOLL_PIN and 1
> for FOLL_GET, mirroring the CONFIG_MMU path so pin and unpin are
> symmetric. Keep supporting the traditional behavior where users specify
> a pages array but don't set FOLL_GET.
> 
> While at it, don't return NULL pointers in the page array,
> as this is really not expected for GUP users; instead, just fail and return
> -EFAULT.
> 
> [ david: support traditional behavior with no FOLL_GET, extend
>   description ]
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Reported-by: Anthropic
> Fixes: 3faa52c03f44 ("mm/gup: track FOLL_PIN pages")
> Assisted-by: gkh_clanker_t1000
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> v3 -> v4:
> * Put FOLL_GET fixup into the NOMMU __get_user_pages_locked()
> 
> I'll queue the updated version after some more review.
> ---
>  mm/gup.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index eb898ea1ee22e..4e9b5ac2cb62e 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1983,6 +1983,7 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
>  	struct vm_area_struct *vma;
>  	bool must_unlock = false;
>  	vm_flags_t vm_flags;
> +	int ret, err = -EFAULT;
>  	long i;
>  
>  	if (!nr_pages)
> @@ -1999,6 +2000,10 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
>  		*locked = 1;
>  	}
>  
> +	/* See the MMU variant: support the traditional behavior. */
> +	if (pages && !(foll_flags & FOLL_PIN))
> +		foll_flags |= FOLL_GET;
> +
>  	/* calculate required read or write permissions.
>  	 * If FOLL_FORCE is set, we only require the "MAY" flags.
>  	 */
> @@ -2019,8 +2024,14 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
>  
>  		if (pages) {
>  			pages[i] = virt_to_page((void *)start);
> -			if (pages[i])
> -				get_page(pages[i]);
> +			if (!pages[i])
> +				break;
> +			ret = try_grab_folio(page_folio(pages[i]), 1, foll_flags);

BTW Sashiko reports:

"Does this code leak the folio if it is a slab page?" ... "When the operation
completes, the caller releases the page via put_page(). However, put_page()
explicitly checks folio_test_slab() and returns without
decrementing the refcount."

get_page() contains

	if (WARN_ON_ONCE(folio_test_slab(folio)))

for a good reason. It's not supposed to happen. So if we would get slab pages
here we'd be in "preexisting problem" territory.

As slab pages have a frozen refcount, we'd similarly trigger

if (WARN_ON_ONCE(folio_ref_count(folio) <= 0))

Now in try_grab_folio and refuse the operation.

So I'll ignore this one.

-- 
Cheers,

David


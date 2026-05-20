Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39F03CD5BA4
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 08:51:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A413E6B008A; Wed, 20 May 2026 04:51:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1EA56B008C; Wed, 20 May 2026 04:51:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92FDA6B0092; Wed, 20 May 2026 04:51:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 813546B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:51:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 196481201E7
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:51:34 +0000 (UTC)
X-FDA: 84787179708.16.C20307C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 18AC51A0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:51:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YITMVxI0;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779267092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xkHRzme42JJuxy3nJwsuuPvUrnL/cbY5gaMHg394CUg=;
	b=R2kZZKBVZPy3tdXaIodZegSoAh+Wh31m7ULBDYFor8cVkHrri/Z93QwjfneydPbcxbCIoO
	2HGKV33Cjh80IkQv/vsQbpTaVHhemVp9iED6CEY228D5llYfPtaKzV9dDDuInFLuGeb65U
	1gKKaa/QG1wA/wF3+I5uuJvv+IB/ZBI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YITMVxI0;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779267092; a=rsa-sha256;
	cv=none;
	b=vr2trri35IkL0gk5JJTwPmsepxgzUlYnmQKqG3jNCgHrxahUuoTkjBfgFxsUtMN6NlX44g
	LHTC3kWsEVxWYZopfZnml4/Y3K245YfpSNklLoVeK89SNjIpvIi+I8YEnbHJmz2qDYjciS
	U8g0mQC3KNN/3epb+sya9UrsNTMNsjo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 28AC943FE8;
	Wed, 20 May 2026 08:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AD91F000E9;
	Wed, 20 May 2026 08:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779267091;
	bh=xkHRzme42JJuxy3nJwsuuPvUrnL/cbY5gaMHg394CUg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YITMVxI0kmGqk5xyYUEAUISHRK6mrgw8RhS65mTnLFJ707/nzgBozxgQA31Wv1M2E
	 RKD04ao4XcD239NOi0s7HTcxf9e6eziHO+ToRGbCJnyOQ/JGIf8HLPnQm2ZrYvRVju
	 11U4VTdHnusqlsWsrPPgT3MYIwcXOQmKsHP6IjXnCF2r+CAM3YdFYeeooSln7wDkJY
	 T5AIsyCtoRfd1p6gLKlHz8R2w3WOhhUhkCxGfId9AzP8knIfb330KeSHe5ijdqxFS6
	 Fqnqeut2wSxWeUPWsYBBOHBmEhTTrKox4saJLc1cjpA9pXMmz3Zw9aTN/PHxwvQ5aI
	 U4ptrT6sI65vw==
Message-ID: <be89d81b-1912-4a7e-9938-a84debcc5619@kernel.org>
Date: Wed, 20 May 2026 10:51:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: page_isolation: Avoid hugepage scan step underflow
To: Kaitao Cheng <kaitao.cheng@linux.dev>, akpm@linux-foundation.org,
 vbabka@kernel.org, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com
Cc: liushixin2@huawei.com, osalvador@suse.de, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260519121646.40833-1-kaitao.cheng@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260519121646.40833-1-kaitao.cheng@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 18AC51A0005
X-Rspamd-Server: rspam06
X-Stat-Signature: rgqmcfr6pqcq85984bxqebqkbwocgsfc
X-HE-Tag: 1779267091-130151
X-HE-Meta: U2FsdGVkX18BwjbgPoI0vI0i6dr/99F/ZnbkgjCaML7JRkywk0q+ZfUUBEUmUmHjPfFLM5Xk5KeT6FBiFibpz5buSrB6mPk8ZC66gggb2/5CYn33BszJwLd3NqND+cwKtr8818tFv+h1LAqXtuTwNkTZh1oLmLN6njloovRXlzsLTyAOWXgfPrukBDpvV8yK3PZ3hKTqFlcGF26xgJSvlUDZ7LLJUUokmL0p8Cc08oLCn+4ttuRVZHDy+2tcIk/5FSk0j0rdRwNfgjQaBD198U/gwMcZthjt+MAs4gF7hBkPNTUvy9Dkm6n/VngrCWV5vvcgDVrNAlNFXIyDMXscn0IaTXVQ08Li9GFPgXrpw1FmAAr9PQTqzq5cwSkPL9kFpJASs40PHYRSluS0PNTL5Oq8VWz/9C3wAKhUOL85MPxBV+Sy+bgUq60QcFtgVwpzvcP03Pk12UK4ZeLetNQgCLMVPgmsiOzODI90dymfgn4A2HSKfvqgbxcIhj0x3T0Zr+B7hPuVHR8sQewuLzPmQV8//q073DUph1I6hE327hMTRPWF/9L0M1YUHa76p3EJS9R/LBa5s5lN1LnGi0g93MBkPusvBMPYFbm7mZ2/OwWIUysAxdm7WiXDOpL4bqBVb/YQ5vKDAQZxSOd69NobRKSCOFCf9sGLtmR00S4a7Lj+d7lli24EYp7+UnA+KIwmGb8Oft89ZSvsu5On3XkCA/MKI7jCyODhl6YD+TdymnAlWm1ngX4K0vvDsBSA1NhIxBF1BFDFgZGS4Ubc/UvRlz9zjT5Hc46vk8dSUotQEyb2gGQmXsPVXptyJ8haIY9Zxa2F0BCXIxrC6Lxl4Ozm/Nif4fJTStda7A/prjelsuhPC01BbgOEDSwFldNpV1jUkdsV8I+hrNxyP7l6c9PZAUNtmRNTIzXnwQsSR90OtnUDMDRsQO63RB/E81o+1hXmmsX/Z3oQDoV5m6xfNGT
 O8bwwg0Q
 DC5Q+V9kQHujBRmotKt0CC9f7OahqqpHhDLD3r1BF31wpv/cx9nPoHWJ/bFvwhuqx9CHzrJ2lZYWh9FG36xoxwkuEeUB1uIe0ir5oOExfRKcI4vVCfHi3ym4kyjyrhnXNDBDcaebnvHRkDrIWFQ+GUbuYGOyPUMoQNuNIP1YfIxxeDqMTn/nSpwPW8PISF0yiIvoesWwypHW1lw3jHHtJHFNtlyGsdE8y0rHCx/Ky1UNmevEvf2GLuzbBfKtV8qcmy6QpPUxndMyypJYoFKoYg1d9zty2SItl5oexDna6m3qqLZW/ywgfvhEMFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/19/26 14:16, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> page_is_unmovable() checks HugeTLB pages without holding hugetlb_lock and
> without pinning the folio. This is intentional for the pageblock scanning
> paths, but it means the HugeTLB folio can be freed concurrently after
> PageHuge() or folio_test_hugetlb() succeeds.
> 
> The existing code avoids folio_hstate() and uses size_to_hstate() because
> the HugeTLB flag may already have been cleared. However, if
> size_to_hstate() returns NULL, the code still falls through and computes
> the scan step from folio_nr_pages(). If the folio has been freed and the
> head/large state has been cleared, folio_nr_pages() can return 1. When the
> current page is a tail page, subtracting folio_page_idx() from 1 can
> underflow and make the scanner skip too far.
> 
> Treat a NULL hstate as unmovable so the scanner does not try to skip over
> an unstable HugeTLB folio. Once a valid hstate is found, derive the number
> of pages from the hstate instead of reading the folio size again. Also
> validate the page index before computing the step to avoid underflow if the
> page/folio relationship changed concurrently.
> 
> Fixes: a0a9f2180b90 ("mm: page_isolation: avoid calling folio_hstate() without hugetlb_lock")
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---
>  mm/page_isolation.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> index c48ff5c00244..99f0b06efaf6 100644
> --- a/mm/page_isolation.c
> +++ b/mm/page_isolation.c
> @@ -43,6 +43,7 @@ bool page_is_unmovable(struct zone *zone, struct page *page,
>  	 */
>  	if (PageHuge(page) || PageCompound(page)) {
>  		struct folio *folio = page_folio(page);
> +		unsigned long idx, nr_pages;
>  
>  		if (folio_test_hugetlb(folio)) {
>  			struct hstate *h;
> @@ -55,14 +56,21 @@ bool page_is_unmovable(struct zone *zone, struct page *page,
>  			 * use folio_hstate() directly.
>  			 */
>  			h = size_to_hstate(folio_size(folio));
> -			if (h && !hugepage_migration_supported(h))
> +			if (!h || !hugepage_migration_supported(h))
>  				return true;
>  
> +			nr_pages = pages_per_huge_page(h);
>  		} else if (!folio_test_lru(folio)) {
>  			return true;
> +		} else {
> +			nr_pages = folio_nr_pages(folio);
>  		}
>  
> -		*step = folio_nr_pages(folio) - folio_page_idx(folio, page);
> +		idx = folio_page_idx(folio, page);
> +		if (idx >= nr_pages)
> +			return true;
> +
> +		*step = nr_pages - idx;
>  		return false;
>  	}
>  

We have very similar code in scan_movable_pages() that we previously fixed.

Seems like we can avoid folio_page_idx() completely by just doing "pfn |=
nr_pages - 1".

If, in corner cases, we skip over some unmovable pages, too bad. The function is
inherently racy.

-- 
Cheers,

David


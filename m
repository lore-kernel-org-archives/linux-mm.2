Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDC10CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 16:21:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 056BD6B0457; Mon,  1 Jun 2026 12:21:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F22336B0459; Mon,  1 Jun 2026 12:21:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEABF6B045A; Mon,  1 Jun 2026 12:21:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CDE536B0457
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:21:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 643DA1C1A4D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:21:20 +0000 (UTC)
X-FDA: 84831858720.01.595E531
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 909D180005
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:21:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kKxrUQgd;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780330878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UoJTMcm6ZaNDfWUE5LlijECfpdOWKQWYDYlCnlwE1HI=;
	b=wjpYUhkdiSAem2AC6GfaFiXVNapxnnTDa4ePySs2OZ3sxC7K9nvKpAh7hvo3JEoQQFUX/X
	/yKXoqKUGNiqtvpIxCYwlRMSNmqqCOq+cJQ0naTbbSshzcc/N+lTbgz5ov8F1YNbpwuhYr
	CCGfYKY6Cn/Vany+i5t2bqPafQrNA4A=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kKxrUQgd;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780330878;
	b=E9og7f04X6ZYsrNqvakieki0M/hJ9f842+s188Wd4vm7Ip4RC6VCNSmQISfq8+ouy4jYLf
	hKAW+kJQvJfahwqBuC78sApjDSuih3viI6SI1ZnOI1M3iBz4/uS5w4GiH8eJqV3Yv+zvet
	cQZLik7KwmYV9paDwYR11nkT1XGIi+M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BD45F404B0;
	Mon,  1 Jun 2026 16:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14591F00893;
	Mon,  1 Jun 2026 16:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780330877;
	bh=UoJTMcm6ZaNDfWUE5LlijECfpdOWKQWYDYlCnlwE1HI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kKxrUQgdbCyqXXD74CHwzYgpuVJrv4CK0/FjjDUYIIGwJRF+Iy6ZZZThDs7Tce/13
	 JH77VQPXaQ1C1ujjS5cYSM9D8Qf46gH/6/fHprkFELNguGv9ULTnoj2AI59TCTLTKZ
	 gPWwN3GuXjZpfA1sxGC7Yj2GRhiStF+4FAlrp/qgtQDaR02JEejxQ7VsEdsqbrf7NE
	 9o58Yc91zhvfusXivt3JV3YoAelAb/81xp+Q5gule+z2OcqSP7yoK1HOKHhwUrXNYd
	 iB7IisbYoQIHDy97FmDBZGLRz8jvfjilHAGpiTFSuJ092/14ALiaTNFbxP4MHb1inK
	 Ef+7+RTm5IKDw==
Message-ID: <4bfe16a2-3bb9-44e2-8b3b-8c77857a4944@kernel.org>
Date: Mon, 1 Jun 2026 18:21:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: page_isolation: Avoid hugepage scan step underflow
To: Kaitao Cheng <kaitao.cheng@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 liushixin2@huawei.com, osalvador@suse.de, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>,
 Muchun Song <muchun.song@linux.dev>
References: <20260519121646.40833-1-kaitao.cheng@linux.dev>
 <20260519105424.e422131a0ffb49e19ed1aebe@linux-foundation.org>
 <bd3667a2-fd81-4761-a763-f6418d9c09f9@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <bd3667a2-fd81-4761-a763-f6418d9c09f9@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 909D180005
X-Stat-Signature: uchdh7jdcbpwskbawyaowyom94z9y4iz
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780330878-926040
X-HE-Meta: U2FsdGVkX1/4Vu4zyS0Xa9DMnQDxeGNcDfCr+C8e2r68TNCiqTchF+RRxOvwnzLkPmbkzWpJAuSR+2nwBozW7kOlj4aYE2iP4DRzEvjGoFgrwV3ra1dnJZo/DR9sG5uSLAs/wbL+beuuYwXaGgP32alwCE2s6r0C5rGDnmtARNDBHRYw12lt3O6BU6TEHfUmHafDAFcyWYGtTBZlciKL2opK3MnzatEt/x02n9X9dZvA69j2i8u4lz6gzTTE9wKlB/Dk+nzMXCBqbKQNJxfXtUuYJ1kuhuoIm4NtdrLOrCykKhb1ZLgAald1GHhn0NBUyWJGTshqq8bmKD/Xay1qTjhtR1fR2Ynww3T5XNQAf2JOBWq4jgXrRmUWiCb1ksJ7gUhS+xqeuKeLVUGag3C9w9DZhv02v6h4jilcXcdRY19W+/MoBcBk5ew73VU4gT9MDEFKvx/FqhcheYZnbsLvsByChu8LzOziZWyDv64lpB4wPKQoX4ojsZHgCOgYWLHvs8ss1o1nHuJzza/Xc/r65JLmmSFuy1PM6eL3mi1G+KXTxJWPui8UWnhQSULMhf0+lkHyJPYLMNMQ1oepHyeHZAWpJFyKM1+5GmX1QTkwLkPncEJLx+m7oIfpFm03yPv8gg6JjLQXBkwO6bRN7AH1JDokgaYsabeRt+dG4gm2ztywcmyTrJJv7m3EptiGzzlSLnzvfqNLXTqXKkCvxQdRTXv8Nx2ffKeL4a2DFRS0s5FTMqNgjezRjML6PcsK+u9GOHEGF0oDt3Mwthgftb9kF/qv+sW7+iGQCyFW4D3HM1OGGbqYCKdjReK8XkOYSMovYlGu2CsmWsukKnYH52X+0FutCDLnGEHzF63RhEu7U7NBOz3QWmNmRiDSyO1OBfHP5MNhmp3fzQ4c7zSGMbzehWZrnwhHKC/WGFx/Q1OzPb0kv4iSc84YzwXmJtsOCicdpBxfM+5EuiTcBqoe4NQ
 U10/lge2
 /ene4vaPeM2UuTlALlNDDZU6ik6pPPFLN1hJ5RVPaT/xQ6jt1GHZhqprwxahO4IHISVgMWX9t3KsQfoRnFQ/Iq3dOATRFq5RSPRi649/EtGUxJCI3NfjMVMlscYdbs25UlBnzVfDCXOryhfYq4XlJ+p3M6gs9AxvSTpBYEZ7I7JIkjObJDh2BgeAfNtf8lj5pZq/M5Mcj6BhQLM5k7zEm5lUhg92SPDXzHCPmL8jJ++db+NUHN+k1rlj9vpMPqY/fNjekOntYSaMrgdkTrxilYEvK+UHHuE8SmYBXpjqgLUi66GDiRn9pKa9mZIMkBI39oopLqB48/5zeRhDyBU3SFkGEtMPOuIikbRYuzj1NHFWKEax8VpWgDyaSbUFY1Vu9G8nMNg6ZRTPeBmk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/22/26 11:35, Kaitao Cheng wrote:
> 在 2026/5/20 01:54, Andrew Morton 写道:
>> On Tue, 19 May 2026 20:16:46 +0800 Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
>>
>>> page_is_unmovable() checks HugeTLB pages without holding hugetlb_lock and
>>> without pinning the folio. This is intentional for the pageblock scanning
>>> paths, but it means the HugeTLB folio can be freed concurrently after
>>> PageHuge() or folio_test_hugetlb() succeeds.
>>
>> Thanks.  What are the userspace-visible runtime effects of this?
> 
> The direct user-visible effect is not memory corruption, but degraded forward
> progress in the page isolation / contiguous allocation path.
> 
> If the race makes folio_nr_pages() return 1 while the current page is still
> treated as a tail page of the old HugeTLB folio, the computed step can
> underflow:
> 
>         step = folio_nr_pages(folio) - folio_page_idx(folio, page);
> 
> The caller then does:
> 
>         start_pfn += step;
> 
> With unsigned arithmetic this can wrap and move start_pfn backwards, typically
> near the beginning of the old hugepage range rather than advancing past it. In
> many cases this only means rescanning part of the same hugepage range, so the
> effect may be limited to extra scanning work.
> 
> However, it still violates the scanner's forward-progress assumption: step
> is expected to advance start_pfn. If the same transient state is observed
> repeatedly, the scanner can keep revisiting the same PFNs, causing excessive
> latency and, in the worst case, an apparent stall in operations that rely on
> page isolation or contiguous allocation.
> 
> 
> Here is another point raised by AI, the old code also used folio_test_lru()
> on a folio pointer obtained without holding a reference. If the folio is
> freed and the old head page is reused or observed as a tail page of another
> compound page, folio_test_lru() can reach const_folio_flags(), which asserts
> that the passed folio is not a tail page. On DEBUG_VM kernels, that can
> trigger a VM_BUG_ON_PGFLAGS() crash.
> 
>>> The existing code avoids folio_hstate() and uses size_to_hstate() because
>>> the HugeTLB flag may already have been cleared. However, if
>>> size_to_hstate() returns NULL, the code still falls through and computes
>>> the scan step from folio_nr_pages(). If the folio has been freed and the
>>> head/large state has been cleared, folio_nr_pages() can return 1. When the
>>> current page is a tail page, subtracting folio_page_idx() from 1 can
>>> underflow and make the scanner skip too far.
>>>
>>> Treat a NULL hstate as unmovable so the scanner does not try to skip over
>>> an unstable HugeTLB folio. Once a valid hstate is found, derive the number
>>> of pages from the hstate instead of reading the folio size again. Also
>>> validate the page index before computing the step to avoid underflow if the
>>> page/folio relationship changed concurrently.
>>
>> This code sounds rather sketchy, and it sounds like it will remain
>> sketchy after the patch.  And AI review says "hey, this code is
>> sketchy":
>> https://sashiko.dev/#/patchset/20260519121646.40833-1-kaitao.cheng@linux.dev
> 
> Following David Hildenbrand's suggestion, I made some changes as shown below.
> I'm not sure whether there are still any other issues.
> 
> --- a/mm/page_isolation.c
> +++ b/mm/page_isolation.c
> @@ -41,8 +41,14 @@ bool page_is_unmovable(struct zone *zone, struct page *page,
>          * We need not scan over tail pages because we don't
>          * handle each tail page individually in migration.
>          */
> -       if (PageHuge(page) || PageCompound(page)) {
> +       if (PageCompound(page)) {
>                 struct folio *folio = page_folio(page);
> +               unsigned long nr_pages, pfn;
> +               unsigned int order;
> +
> +               order = compound_order(&folio->page);
> +               if (order > MAX_FOLIO_ORDER)
> +                       return true;

Would we also have to care about non-order-of-2?

> 
>                 if (folio_test_hugetlb(folio)) {
>                         struct hstate *h;
> @@ -54,15 +60,16 @@ bool page_is_unmovable(struct zone *zone, struct page *page,
>                          * The huge page may be freed so can not
>                          * use folio_hstate() directly.
>                          */
> -                       h = size_to_hstate(folio_size(folio));
> -                       if (h && !hugepage_migration_supported(h))
> +                       h = size_to_hstate(PAGE_SIZE << order);
> +                       if (!h || !hugepage_migration_supported(h))
>                                 return true;
> -
> -               } else if (!folio_test_lru(folio)) {
> +               } else if (!PageLRU(page)) {

Hm, is that required because we could VM_BUG_ON?

>                         return true;
>                 }
> 
> -               *step = folio_nr_pages(folio) - folio_page_idx(folio, page);
> +               nr_pages = 1UL << order;
> +               pfn = page_to_pfn(page);
> +               *step = (pfn | (nr_pages - 1)) + 1 - pfn;
>                 return false;
>         }
> 


-- 
Cheers,

David


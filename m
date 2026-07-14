Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D871C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 13:01:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11B746B009B; Tue, 14 Jul 2026 09:01:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F3A06B009D; Tue, 14 Jul 2026 09:01:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00B0C6B009E; Tue, 14 Jul 2026 09:01:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B0C696B009B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:01:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD51E12034E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:01:53 +0000 (UTC)
X-FDA: 84987394506.23.D5AD7B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id D7B5C4001D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:01:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k5c7YCIU;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784034111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HuK4P6aqO8DESV6CHxhF1gUmZk/0pbyK+8uhsekdIXE=;
	b=TOAXuW3c0q+4nxpcFG+o/Rsp8zyrRUb8CDxbnaJfxGwX8X2Z7U8bFBRG4qcmH1fRzeW9J+
	Q5Fpc47W77Wh2xSKVIuraxfZKCl8+hi/5F70s7KwAmBAPat9eIUXFNHuGU+8gsfp+1DIDv
	KYjvtOOQg1p1zOUxx2Qea4pO+FbSS6c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k5c7YCIU;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784034111;
	b=4d1ppxlp4nK4xazLYp69g13JUAYBaq72BRhgBGxR1ABGBk6itNjWzHUk4JcVkofzSdtT5V
	TXp+pmMCT1I4Gw3MiQvwrmzoQ7xFmURZxqmsM5hWugu81F0vu/SZvR+ICcQhmuGGGgwpgs
	/thcl8K/5Y2O2xpbkLPoCht3QyI4uOY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6EF9B60120;
	Tue, 14 Jul 2026 13:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4B71F000E9;
	Tue, 14 Jul 2026 13:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784034111;
	bh=HuK4P6aqO8DESV6CHxhF1gUmZk/0pbyK+8uhsekdIXE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=k5c7YCIU9HDxHlg4W4qOo0RvYVF1Yi9F2s+I6qWTMFhO7y5LTv3AAIisV2EWRK7gt
	 G71ZbZF4BS24Cc39/TUyfVc5uhFkyz1eBRQWXthjI6/20woS6JR6HyEDDmL6x8i/2F
	 DcSgKfv3TmJNEK5wNp/jycuq4f8CVqmXXBJZZun553j3NwhJj4KAGuhBwn1OmnwVy4
	 VuiGlTDHXX0ZSUBi3SsBZzNo3DQL4esXhTMzEzjfqW0tCG7qN+LvbgwN6KHFDf9WHQ
	 h/sVeewLC8mS4d+YQIElGTCBmyQUMpOqmwK0Yw7f5mOPS1Udc2KNg1QbwGQlpNOdHu
	 5iV3J2HxCieBg==
Message-ID: <c4aa63df-30ab-464d-bd0b-48dc37c8e6ba@kernel.org>
Date: Tue, 14 Jul 2026 15:01:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] mm/memory-failure: keep the folio, not the
 poisoned subpage, locked across split
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Hao Zhang <zhanghao1@kylinos.cn>,
 Hao Zhang <hao_zhang_kdev@163.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 stable@vger.kernel.org
References: <20260714122344.351895-1-kirill@shutemov.name>
 <20260714122344.351895-2-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260714122344.351895-2-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: r78qkq1z65un6n4c8e37aoiq3b1j6gza
X-Rspamd-Queue-Id: D7B5C4001D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784034111-385714
X-HE-Meta: U2FsdGVkX18O6OooaUt5H3ic1tnBK8blxaOwwlX/Sa2XE1/LSCJEP3jJpLgQcroQUaDJE2EX1W17JfJhLHYyzSS4vmj8IdOo4CaczsnKRBVpjSdPUxCTsEmstr6Id2Y9wv1DpmQTF3PHC4nuRuEH0MOn+3iwWaxmW705xzorEx/UPweT9NrNaWiYqchiNhqA8h2xAnl1tlqBiZ5+6rSClfLM+OmyB4hLtJlaasnUCWg0WPgU+HaAnU5TmKAd+hsN6uWvOLNYG+X86iUNLsqXfxKO2DbGWLZfxlbbI8+J4RlUS1sixZg4r+KKVwYJ0PTxbmcWKigfFbm20azuQgbYY8/kwQ9A7bBwQWwoFFfkOG4LrfD0qLxRdOJrCo2raKaCeMkln906Y4lRYHWrO4xhyXTUMsiRcUdgRI/H3EGRrNi6220OREJZSF99scPCiwRgdIRM7tBHlWVSdXbIi3IQMpk7cTpRuGJs5LN5t6eXVPkPit7OnLvSuElEDbBlhrQE48lAcfV3WindOrcl34W8a4gCrubjnhD4vX+9yEgVOnWwsFfmS8nRP7xJ9vZMFyVtMJ3jjH8O1T1z6TivFAH5BO/iRvrd4WjCJ037JZXx96m5jiPkq0nOMJcUKKu551aVQkntMafXV2Ope67yugB3PuINkCnoEYOFx8Za5Vv2Suz5m7vhnQcSxA3tuJxutORPwSJ2a4cFkD4nCp5AWd3wjcCRFtBn1PIb+Z63XtIKcEdNEO/9glQOlxvjOga1nyyr4fwmwQYOaJ6vpAZ4U4eU6juMYAOwXS5L4smECA/X1luF+lGxFcB7CCjlaBOUNvv0gfMXGtiiOx0RGIjqsrqPcWnTRoZGB00BlIV8JooAo4pKuFxcS0KqA11SoeKv22MRDBH+92ANlAzGoj9D70/d+0Mds6+naxGprmpLpzV913lbW5pf2xpnfZTHHDGvYUtqu7uh3Ue2dESOsEDm5pc
 49vC46nL
 XPOyQkxhMDGYcxHs+t3SRxK40LpiVIJAiyzqD8JgBPHCT0pa3cXkLulJWtRfeBIUDElDSV1MwgsLFwCX1EU5ozO/y03B1Ain56lBKMJRfMs9iUqjMRsSTorozf/APi7KCaQIhhMzMCa+olhHVUveMvyxn3Y0iVjgbzNmC+rtpny2VEwYoJT5ZIZ6NELlDx9pPdmZ4KKoUbqm8FSQTUkh7vF4VpCHQwSr+kL4/IBQRBulYV1Zh+ba16DErsQRjLYMQyApfB6q3oZDXy1PmMqtQszOERXYnYH6c+GmQaG3tUe440rq7AMnMq9+UVUUvbocr2KqeH86M81Sx1Dcn9Apvu7TYBjsqk3+KkwXabI2l9bRKU1FISfMN7lBhaTDfk0c9PeOl+Lujfhp4uto=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 14:23, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> try_to_split_thp_page() locked the poisoned page and passed it to
> split_huge_page_to_order(), which returns that very page locked to the
> caller.  For a tail page that means __folio_split() runs with @lock_at
> pointing into the middle of the folio.
> 
> __folio_split() dereferences the mapping after the split completes
> (shmem_uncharge(), i_mmap_unlock_read()).  The only thing keeping the
> inode alive across that is the locked @lock_at folio: while it stays in
> the page cache, eviction cannot complete.
> 
> But a tail @lock_at can lie beyond EOF -- e.g. part of a shmem THP that
> reaches past i_size while the file is being truncated.  The split then
> drops it from the page cache yet still returns it locked, so the pin is
> gone and a racing final iput() can evict and RCU-free the inode while
> __folio_split() is still running:
> 
>   BUG: KASAN: slab-use-after-free in __up_read+0x634/0x790
>    i_mmap_unlock_read include/linux/fs.h:537 [inline]
>    __folio_split+0x732/0x1640 mm/huge_memory.c:4100
>    try_to_split_thp_page+0xab/0x390 mm/memory-failure.c:1675
>    memory_failure+0x1394/0x26e0 mm/memory-failure.c:2470
> 
>   Freed by task 4601:
>    shmem_free_in_core_inode+0x54/0xb0 mm/shmem.c:5177
>    evict+0x57f/0xac0 fs/inode.c:870
> 
> Split the folio as a folio, via split_folio_to_order(), so the head is
> the anchor left locked.  The head is piece 0, which the beyond-EOF drop
> loop never removes (it starts at folio_next(folio)), so the split always
> leaves it in the page cache and the inode stays pinned for the whole of
> __folio_split().  memory_failure() and soft offline re-lock the poisoned
> subpage's folio themselves after the split, so they do not depend on it
> being returned locked.
> 
> Reported-by: Hao Zhang <zhanghao1@kylinos.cn>
> Closes: https://lore.kernel.org/linux-mm/20260710071344.GA106129@zh-pc
> Fixes: baa355fd3314 ("thp: file pages support for split_huge_page()")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/memory-failure.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 51508a55c405..68d42cbed458 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1657,11 +1657,18 @@ static int identify_page_state(unsigned long pfn, struct page *p,
>  static int try_to_split_thp_page(struct page *page, unsigned int new_order,
>  		bool release)
>  {
> +	struct folio *folio = page_folio(page);
>  	int ret;
>  
> -	lock_page(page);
> -	ret = split_huge_page_to_order(page, new_order);
> -	unlock_page(page);
> +	/*
> +	 * Lock and split at the head, not the poisoned subpage: __folio_split()
> +	 * keeps the anchor folio locked and needs it to stay in the page cache
> +	 * to pin the inode. A tail beyond EOF would be dropped yet returned
> +	 * locked, losing that pin. The caller re-locks @page afterwards.
> +	 */
> +	folio_lock(folio);
> +	ret = split_folio_to_order(folio, new_order);
> +	folio_unlock(folio);

With a non-uniform split it would actually make a difference: we'd want to split
such that we the other folio pages minimal.

 split_folio_to_order() always seems to end up in
__split_huge_page_to_list_to_order() where we do a SPLIT_TYPE_UNIFORM.

I recall discussing with Zi and Willy that in the future we'd want to convert
more places to do a non-uniform split.

So I'm afraid that would just re-introduce the problem then.

-- 
Cheers,

David


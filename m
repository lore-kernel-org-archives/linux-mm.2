Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 362E960A2634
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gyInaQOF
Received: by kanga.kvack.org (Postfix)
	id 8CB956B05B9; Mon,  2 Nov 2026 05:18:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 854726B05BA; Mon,  2 Nov 2026 05:18:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CDCC6B05BB; Mon,  2 Nov 2026 05:18:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40B896B05B9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:18:51 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CA628A8A5C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:18:49 +0000 (UTC)
X-FDA: 85389780378.24.1BC7B9E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 18BDE140003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:18:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gyInaQOF;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793614728;
	b=y/DwmWqH91O+oe7nqRfeU0lMxU/IGymmNFefGgzCorbsQcQZi9xApaLU+rn7+s70UxKIHF
	iS4B6ElGRsYlMdYP/CXGftgvtjG+r2oSHCdmOcEDz+kl59seyuK3MUDNMWBz5uu2bIlNdj
	xuRxMLYfZPAL7zVmby/qVlxmbnYSRhc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793614728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c3eJZ//o+zBRx3n+KRLGGi0fci9Wz/AyVLE2s2T174o=;
	b=iI7l0HsdrUvAzlKNxwK6qksoHi6OFjrSPm29uX2sP7CMYDvpmrcnjJOVRTMcxrG9A66JzU
	TLtWa9yGt1Iqx1ePDEnZ8FQje1UyBvs9gGn/+Ku8Gz8wNqppPfXU/HBJY64Z7srqloaayd
	+EcvNHXBPrII0zj5vCKO6iAwqe5R4ws=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gyInaQOF;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F7FE43CAA;
	Mon,  2 Nov 2026 10:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF8E1F00A02;
	Mon,  2 Nov 2026 10:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793614727;
	bh=c3eJZ//o+zBRx3n+KRLGGi0fci9Wz/AyVLE2s2T174o=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=gyInaQOFfRk2e8yXMRdWTkcW2xNGEoKXhOZcYvM6/2GQKtqSZVoEsnj5gIUQfcCzK
	 p0Bk+llE7u7gMGjxOI5l5DDOSt/dAy9KEyLCodoVh+7CWYZhCIoozanNq8HBEhBnv2
	 1frGVJq2z1DHseRGJ/5WlY2pnzlZQ2jGY8lyEi5NPWt23IX6BEtdIcEPhPBaTt4dj8
	 S/+PYEzRrZpZJvIOc+7blXSJ+XZ43xJv17EUpOZ89UuW4+hKhNiiTpsup1AxsWqe1f
	 zJE2aWk+JidwXS/3ApvchfmM5gClDmwQDXIyHA5iVM0MCCNJZlm2NGsw057Ag/zcKW
	 AGSk5Ll3O/xvA==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 04/12] mm: hugetlb_vmemmap: generalize vmemmap page
 allocation
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Lance Yang <lance.yang@linux.dev>, 
 James Houghton <jthoughton@google.com>, 
 David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261102032525.3597743-5-songmuchun@bytedance.com>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
 <20261102032525.3597743-5-songmuchun@bytedance.com>
Date: Mon, 02 Nov 2026 12:18:31 +0200
Message-Id: <179361471104.1337633.3959715900505206111.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: 77mnhfgtqkmcpbogh6mfto4chwndbuai
X-Rspamd-Queue-Id: 18BDE140003
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793614727-783948
X-HE-Meta: U2FsdGVkX1//4wzfrjauEQDL8fcK/wHYL9QywHyNOkcz4GstSE2jFU2VfT2adtAUJ/bUYhIjujefKBzWky6D8l5WrZcUlesXSUufHejVOkhW3xrwjTuqP+0AZ6d6bZ5zmGwDIHqlh6F6czDSklF3PLhdDeMZRHm06PernXgC9jFCwcIlxzELi4HDdZq0C97gyEp1VAliYIEa/Fa9Mlq6hDDOPLVeb/hSXmuZy2avaso5JmM6xa256OtprZIaT4Tex24OTbfaKcfxbxttXbSm//KtHZrptIGasP0ZRwUMGxwh2FcMgJX937rLdpTgAzJNw4kEePw6eGaRAGtS/REgKr43XuPVJgls+pA1twj0E4tjADMWOjlSHrGshg4YiLKSddjFLsVn+D5OYD7JaXT3NWzqCFASOPc2KpXv8x+kE1eCoeIThBWP+qiys4uZW2JPxsII0guAjm1t8WdqALu+hR8d0frpxXApSx8XpvSJqoOvQVwWSxHucXNUgU1ANWzlPcIl/GLLHWpQYIsH898YVG/dlA3jNZPuKwqzXxqgR0WOStkXhr9m8tEUbkXHuL2C/wCg9O6JGtQuBJAyWVTxYmlkO0Uhm8A83073Hf316w/hNbwPbd7lDcA68ZLUgGrwOSPCIjNL5zIC9eVyfNujI3fy8766RHInSwHZSNhOBcH5OAefxcYNopNHIhLTqmm5kddRyIWzMG4M8FqxYY8BrwS0fILLyRuyDWzhhql5zVgohjO8on4kTnMF8EvYky+4FZCEumHKW6yy3ML7zKv9VW3KRNsUnn3c6JeyaYcyFyUcmnvFG2aeNJJ1sryHd6E0ZA/MlSSKnrtIMDufBYdJLZ6xYX3GlGbb5HbLhM2fT3gvu3LNjvS+0qOPTiGMjGxApGTe8Wg9UitS+M4PFViMvCKX5kiKohFJaZr1YiUOyxSafQlzAR2tFndtAwIfjM8eqYtsjYbmKm4ySEwj7Dd
 K/sWs1AZ
 6TdQJyoCX4glg+bi73orBWJ1ZUSv5e3omNExSknEzwOMe5JiqDx9gU7+KJ7pwjPrv5RZvPBEn4RtgHcL6w5GV1P36cSX5qVglZN1GvyJ4LQ2V9I1jFgvN6XDuTf1DcHle/0JvLCfhRezsTOJGgjRuAHfbrv7XAiQ3s4BP+PdhKtZSYEXr/KYrtKfWC9I8XetWm5M9X41SW9pu2OfA0G+1EVgg8Entw+dStFa89wbXu9IaJv8uO/lxyxG0nVhtZbn9mfHaTl7YWoOiEpHv3ghVOfRdlcr0GvpcnS0DAdMwCsstdKOWdVwmexgC40Pe6utuwipNmAczQHZdLXB4VSjFr13QsyH4+l/UQWigdiXRJTaWkUvox/D31WAu2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Muchun,

> Vmemmap page allocation is currently tied to restoring a virtual range
> and assumes an empty destination list.  These constraints prevent it from
> being reused when pages are requested independently of a vmemmap range or
> appended to an existing list.
> 
> Generalize the allocator and give it an all-or-nothing list contract so
> the restore and optimization paths can share the same allocation policy.
> This also allows HVO head-page allocation to fail gracefully under memory
> pressure without triggering the OOM killer.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
> ---
> v2:
> - Collect Reviewed-by from Lance Yang and Qi Zheng
> ---
>  mm/hugetlb_vmemmap.c | 39 ++++++++++++++++++---------------------
>  1 file changed, 18 insertions(+), 21 deletions(-)
>
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index 0e5b2b182d1bf..4b20a8efc0678 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -334,28 +334,26 @@ static int vmemmap_remap_free(unsigned long start, unsigned long end,
>  	return ret;
>  }
>  
> -static int alloc_vmemmap_page_list(unsigned long start, unsigned long end,
> -				   struct list_head *list)
> +static int alloc_vmemmap_page_list(struct list_head *head, unsigned int nr_pages,
> +				   int nid)

Please indent with two tabs, like David likes :)
Applies throughout the series.

>  {
> -	gfp_t gfp_mask = GFP_KERNEL | __GFP_RETRY_MAYFAIL;
> -	unsigned long nr_pages = (end - start) >> PAGE_SHIFT;
> -	int nid = page_to_nid((struct page *)start);
> -	struct page *page, *next;
> -	int i;
> +	LIST_HEAD(local);

Can we use a better name here please? E.g new_pages?

>  
> -	for (i = 0; i < nr_pages; i++) {
> -		page = alloc_pages_node(nid, gfp_mask, 0);
> -		if (!page)
> -			goto out;
> -		list_add(&page->lru, list);
> +	for (unsigned int i = 0; i < nr_pages; i++) {
> +		struct page *page;
> +
> +		page = alloc_pages_node(nid, GFP_KERNEL | __GFP_RETRY_MAYFAIL, 0);
> +		if (!page) {

I think goto err_do_cleanup is cleaner than ad-hok cleanups

> +			memmap_pages_add(i);

This is confusing. Updating counters only to use
free_vmemmap_page_list() seems worse choice than walking the list and
__free_page().

-- 
Sincerely yours,
Mike.



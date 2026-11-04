Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C54E606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nhj4OfNw
Received: by kanga.kvack.org (Postfix)
	id 6DF296B00EF; Wed,  4 Nov 2026 04:58:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68EA96B05B4; Wed,  4 Nov 2026 04:58:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 595C86B05BA; Wed,  4 Nov 2026 04:58:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 38BE36B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:58:18 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C5D7BA069F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:58:17 +0000 (UTC)
X-FDA: 85396986234.10.73AE0BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 414BA1A0006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:58:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nhj4OfNw;
	spf=pass (imf19.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793786296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HFkLr+PGxIPBaCYrw+OLXdhMvo+2BGgnXZojuZri9Lc=;
	b=y2Y4QQAu9FZ5TTKm9KtwWvfixEMCl7M/DobB5PEkt3iPDsa0quv9iT2KJpr7epUWveLOfK
	JSu0rPAyXAnmv08W3kAp+uXiWGZyNNDPHLQfLlNRxOnKceYJIe9zRtbjGU+sLcSsNdhuQt
	931ikzjahWy58P2xdhHOaN03T025NDY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nhj4OfNw;
	spf=pass (imf19.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793786296;
	b=E27FhwUjYcuB8LfWPAA/n6/b4L6u89yKFf2MG0fGUzXXE5PMylMslVd64tPmTt8BLimz33
	Bf3kaPcsLb/0xbl2pUwNS1B8hJRIQ3bBMOo2EmiBlY/0XHmAaFJ+TxtLzAJ4DdH+Xl/OvU
	10MV5QzYhlDwayFMXa1AgAqYysnozYg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C963A6062D;
	Wed,  4 Nov 2026 09:58:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87CB1F000C1;
	Wed,  4 Nov 2026 09:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793786295;
	bh=HFkLr+PGxIPBaCYrw+OLXdhMvo+2BGgnXZojuZri9Lc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nhj4OfNwTxTqIISwb1/7BNNVD8rohjhM9pLdcxKthdI4PO6G4bQmggZZmO6Yqf2Hl
	 iiq0NHJM446Fdm226XD7MA58n58s3owzOYh+zezXf8OM9v8GRwBie6hEp+SFJfXYFT
	 pR0Ch9lixgBah+4zuiKaOj+XHF5+d5ViNHEgoXK4t5u72wwAceaBPU1Rgx1nHE5Ll2
	 PpLSJVtsgFaaBzH3JaTRwUnpYJ4462xXmI/2/40Jub41vlneBa5tLXlOFGVN4eWBAC
	 vBunu42EA0wKVyr+x3HOjYKJM8x4KArDivx6iKnGJxfPMUEMyttLtOiRlix83DFusv
	 c/Im0HFAhHm2Q==
Date: Wed, 4 Nov 2026 10:58:09 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/12] mm: hugetlb_vmemmap: generalize vmemmap page
 allocation
Message-ID: <ausBsbaw9DNVh4KA@localhost.localdomain>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
 <20261104023510.260766-5-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104023510.260766-5-songmuchun@bytedance.com>
X-Stat-Signature: c1bhgnyhjwyj8xccfzj683e8kg7z71uk
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 414BA1A0006
X-HE-Tag: 1793786296-757648
X-HE-Meta: U2FsdGVkX1+0LK+hMXhAKg6LzHvOy/GKEnL5HRqqMuHa1Jvww02tAWZ3i9iQNnjbQi+G8Ow++9n2oPJfezNq+RA424rkVn/XnrfnSqVvTNGVxkl71Br1PV2t0OXQaLbAEVcTbbh8+jCi7UrnSq3RD5bQTdSCTUoDtAZn7a+jGe3egAd4vJMFPU9xyo6f88nJ4j9s5yr+8UEi/h0iGMeAsKOBWmob0Sj1gmKMtejjpndbqGO9s/iyZQy9e1AZBkU8qWJcAlcoVcyFoBCacEC0OvJPA+cHxHeVyMsdq/Utl+LUtP/Dm3Jk/CU/0TqGTv6Ic6RMqrt+qQVs4CCPwKfYiliXuhryYQQEMxBUuBVLGaKtGNFB4UIyT+O/pv6dTYuJtGVcGgAKEbwg+Fyj5lyLHejfF1MVoSGzKraswo/U2uHfOVSa5Ym54YN8pEEsOhrL6EnaWmA9wlmDtkPvyIQO3xQoUofWebByIKy/GoOzbGIfFsxxZfXA5Ol+SLatdMcoXXnb1/mNLrE4jcEUXDIJQhsz9hn1CX7+iy4iXDNMZGXaJDP4+mxbisza/W7gpw+XnQHPBZ+Iv8YoI7t+9oVDTzzZ3kyl3BsixgP2uEuLyBPi0/OPIP+/FgXJi5RVPzYihNt+NbEY/eldK2Dfbpq9MEAsPE8iy9m2R56ZmKfQMyX2M3sZWa1GLBFZuusRiof26yRyu+mHgaU61Me2gGCNmsMiVxD5JZs8ShBhWiSrQq3dwi5rxyecfKMUFzWMj22GAG3Vug1hPJUH411G3LgqHz9AQ2GfEEFd3KhEp4GqEafQ8fvCVsHbwv51aSGyr9a++LywoRlLs6EcS5WXdue/VHt3KASrSEq67SP8Xg+NLOQUVQr8WxYLb6WdtDsxUGoFHQDGewJeI1ieh1XkOI4Gvo+irnb+4NMotN0EUqfGI24CzRZKEtxiq6pFDrRIG+xBlGrL8qzH/3H6LuSouxf
 82u41FBl
 hOu0KTOyjiX3rwtAQcC3RXwQifNatyr76MlBvSOxi12yJMs2TC31Lr/L1uLqeOm9vP33A38IOnAPbq40W7vKicJLUOQFyPtcq/wAajWoyh34pWjbRYvMg7piA2nJUaacvIMcgyjHcBl/lkJortnxouV2jbLl7Rih15U82fJonQmaxPKkq34ME/QZiJWL+qmUsM8VUZ8tYhX9JATAiWExRJmnpaWQMRquYReby6JursGXYFKo8bXR39kQe8U1rVcdaewGFLTBLEspNSxX/mpxUThi15LV3OvViS57koT+mAiOX5Sj8NQfnHewYAyLr7py5Grcm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 10:35:02AM +0800, Muchun Song wrote:
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

Reviewed-by: Oscar Salvador <osalvador@suse.de>

A small nit below:

> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index 0e5b2b182d1b..d3058e106795 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
...
> +static int alloc_vmemmap_page_list(struct list_head *head,
> +		unsigned int nr_pages, int nid)
>  {
> -	gfp_t gfp_mask = GFP_KERNEL | __GFP_RETRY_MAYFAIL;
> -	unsigned long nr_pages = (end - start) >> PAGE_SHIFT;
> -	int nid = page_to_nid((struct page *)start);
> +	LIST_HEAD(new_pages);
>  	struct page *page, *next;
> -	int i;
>  
> -	for (i = 0; i < nr_pages; i++) {
> -		page = alloc_pages_node(nid, gfp_mask, 0);
> +	for (unsigned int i = 0; i < nr_pages; i++) {
> +		page = alloc_pages_node(nid, GFP_KERNEL | __GFP_RETRY_MAYFAIL, 0);
>  		if (!page)
> -			goto out;
> -		list_add(&page->lru, list);
> +			goto free_pages;
> +		list_add(&page->lru, &new_pages);
>  	}
> +	list_splice(&new_pages, head);
>  	memmap_pages_add(nr_pages);
>  
>  	return 0;
> -out:
> -	list_for_each_entry_safe(page, next, list, lru)
> +free_pages:
> +	list_for_each_entry_safe(page, next, &new_pages, lru)
>  		__free_page(page);
>  	return -ENOMEM;
>  }
...
> @@ -527,15 +526,13 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
>  	 */
>  	folio_set_hugetlb_vmemmap_optimized(folio);
>  
> -	vmemmap_head = alloc_pages_node(nid, GFP_KERNEL, 0);
> -	if (!vmemmap_head) {
> +	if (alloc_vmemmap_page_list(vmemmap_pages, VMEMMAP_OPTIMIZATION_PAGES, nid)) {
>  		ret = -ENOMEM;
>  		goto out;

alloc_vmemmap_page_list() already gives you the error code (ENOMEM), so
it would look more natural to me to use that already and not "overwrite"
it.
e.g: 

 ret = alloc_vmemmap_page_list
 if (ret)
     goto out;

but as I said, just a nit :-)
 

-- 
Oscar Salvador
SUSE Labs


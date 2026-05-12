Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC36FCD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 12:56:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 604886B008A; Tue, 12 May 2026 08:56:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DBC86B008C; Tue, 12 May 2026 08:56:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F1C76B0092; Tue, 12 May 2026 08:56:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 41C186B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:56:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0FD691C0362
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:56:56 +0000 (UTC)
X-FDA: 84758767632.27.2006BF0
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id DE1CB100003
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:56:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ejVJkCEe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=p3uD812k;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ejVJkCEe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=p3uD812k;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf14.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778590614; a=rsa-sha256;
	cv=none;
	b=dVF0eMpzGksnmZEvWmXWhPA9Q3OwsaK78o/XkZM2551+scgxzznL5ZSPxTpt6PfQX7N+CI
	RglEGzGmkqe4gcbJWmBoUyf73KllS6rc+UUGdyu9GCUlnFHTgouUwE5+aaetAEjv3nmVnF
	uxbPTycQvR8NE6t8zmiLyO2KSjQpOjE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ejVJkCEe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=p3uD812k;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ejVJkCEe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=p3uD812k;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf14.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778590614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f6CUZWjX8Zu6dMxEEaiGDxiAJZZDLVMaxZk+TLPcyno=;
	b=RSKZlueb55COertbcB0CTLbQmhn/jMJJv+km/bFBCFwoEjETTjSb0LcCbedPpzOODNHf9k
	lBjYOieTZwvfR25kVTsf4M+S2U2X+QlOb6NESEXGL/Em37WiKUonZH5zrgLXphEZGYTTGa
	0Nas2hS7rxNM4LBaH939tkS/YwzNuf8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6FC236C21F;
	Tue, 12 May 2026 12:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778590612; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f6CUZWjX8Zu6dMxEEaiGDxiAJZZDLVMaxZk+TLPcyno=;
	b=ejVJkCEeU3IaWbLmz31hGsIMN1fSkj9qqRXQAYJf39chia9i8KmJTqbeGnI15K2lYyOCzs
	7Av4ibeZi264HTwkpq+64/H+v8Wtt9UJGgJUbFY0Z/LsnbjTVO8f0CpaYNm2rUhsCOrICG
	z3WPhuWJWBRPIEMjDUIN6JZGZHKPHac=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778590612;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f6CUZWjX8Zu6dMxEEaiGDxiAJZZDLVMaxZk+TLPcyno=;
	b=p3uD812kXuYIxYxvw+BQJcHF1r5EU3vdegqaKdxy7uHfNRhDj4gg7TFuk5aorKQgSzwlnZ
	YneEZJlgJELMiDDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778590612; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f6CUZWjX8Zu6dMxEEaiGDxiAJZZDLVMaxZk+TLPcyno=;
	b=ejVJkCEeU3IaWbLmz31hGsIMN1fSkj9qqRXQAYJf39chia9i8KmJTqbeGnI15K2lYyOCzs
	7Av4ibeZi264HTwkpq+64/H+v8Wtt9UJGgJUbFY0Z/LsnbjTVO8f0CpaYNm2rUhsCOrICG
	z3WPhuWJWBRPIEMjDUIN6JZGZHKPHac=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778590612;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f6CUZWjX8Zu6dMxEEaiGDxiAJZZDLVMaxZk+TLPcyno=;
	b=p3uD812kXuYIxYxvw+BQJcHF1r5EU3vdegqaKdxy7uHfNRhDj4gg7TFuk5aorKQgSzwlnZ
	YneEZJlgJELMiDDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 69EB9593A9;
	Tue, 12 May 2026 12:56:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w2HJF5MjA2oSNQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 12 May 2026 12:56:51 +0000
Date: Tue, 12 May 2026 14:56:45 +0200
From: Oscar Salvador <osalvador@suse.de>
To: ackerleytng@google.com
Cc: Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, fvdl@google.com,
	jiaqiyan@google.com, joshua.hahnjy@gmail.com, jthoughton@google.com,
	mhocko@kernel.org, michael.roth@amd.com, pasha.tatashin@soleen.com,
	pbonzini@redhat.com, peterx@redhat.com, pratyush@kernel.org,
	rick.p.edgecombe@intel.com, rientjes@google.com,
	roman.gushchin@linux.dev, seanjc@google.com, shakeel.butt@linux.dev,
	shivankg@amd.com, vannapurve@google.com, yan.y.zhao@intel.com,
	Dan Williams <djbw@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/6] mm: hugetlb: Move mpol interpretation out of
 dequeue_hugetlb_folio_vma()
Message-ID: <agMjjbWA9Hq9AZYI@localhost.localdomain>
References: <20260506-hugetlb-open-up-v2-0-826a0c5f28fc@google.com>
 <20260506-hugetlb-open-up-v2-3-826a0c5f28fc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260506-hugetlb-open-up-v2-3-826a0c5f28fc@google.com>
X-Stat-Signature: 3dxmfrex7d387y3h8wfqknsg8cjn9rxn
X-Rspam-User: 
X-Rspamd-Queue-Id: DE1CB100003
X-Rspamd-Server: rspam07
X-HE-Tag: 1778590613-966207
X-HE-Meta: U2FsdGVkX1/1l6QxZW4m7Fnc2I1s3+lrn6gdNEQr5x5JHik5EYXEodBfoVboB+2zm11u6yExHRHU0NEG/uAx4ge5mOx47Yi0oBU1tHWhUoC0iWTo1eLVH6DGJaGZWzSt2T8cmLh0aSazBxAudlVABUltDV4p/5bhnpnna8CpARbFFwUAboOLFewFFSRgAd2ByqUGOSsfg8hKXp4E1MZFSQx/mFH3XkmEdsz0NUGjyxoUqT2uYgsWC0DL0dtBShrRbg4A3m5E8S2uqQYaKtMW9wO/+I1sTGkc4dI7HbuFia+bpbOB+WtmZa7TZS3Z/2nn1Af0qLrG3OVPluh/FW0zCybSgGdw/cmKQsHz0ghCF3u+ylWjJLuo3wIy9bOTlXH6qnlZ/JSc1T2LXhbDB75DH5/n4OuB2jbj0BorYGG+46ViBmKrhhEH99wK8uJYeFxWNz9TvIUaGX4SwRFxjWlv6SVhvldpgrLQCfYe471XGq+ocs5C233JtOmtqryi2pWi89uOZwHyWzZH/EV6i6deXPOJGS1dLvwnSKa2KuKtrzioIv7LS/EXfoWUNs9xhbAokyVHbwWxgbhR/4LWc3XABocSytKnX6aPfT6vQwdYja7+AS60m0O3QPjYRJWtvYAqmtiYouiZgF17bhoHtmTu3VRVybIEJfDCMy1Lz4aS8z5lDDAlZSS7zA+VAIMdK5CJl1Uf7j3SKqEgawuGd/cttj3HY9erLszMCwWRJZGPlmSZHEiROuWTKIw1EYH9OuN2GPGsbcDZNXrXlMfZGYr108XQX5gKVC1MDx+H1/BxK48Pjr2nJHmC/5CriKqXsB24tmNUZS8lK2Ayzps6BQaljMTlbRy1DEo6txDg5Yn6RNojjiHtyjtDs06OkgpUFvbVEj0L4n7c3Gk83KC200R73Mwo5nMU/EJVJYJ8pTvk0AAy396mvy1554cEmzJ1uWZcV5NOTO+yhstntto4LQP
 sw1z4/Rj
 uBsPqrwlgL7X+rx5XtrExpceLmJqDWZWswjZwBvJq2/Mt6CNm4Su5grPvD3cjOcVptzBJCjwkXHS+lQksrKpuMZu+8HL26ajGSFOgS2msq+y24aaNtluO7Po4bUUEmfqXb9OK2EwaQA9eDmow3JYkm5eMZI5txD6VbHRwnC3NjvlGzq0BKIYZd9wxr4FXsgIOa8qTT7YLju0KarvA2RtRBOXwlwhcp+v0keoz71tEEVPzSmIw2t7nWyelVM8c3b/qkBESgB4AjLY3RqRi8+eklzfXrPA09JVl/mn9QhKQqCUrND6UoW83cx7nGVM2WXDsas12bLnoL82Xe3ymHeNTSlWRngYv8RGbsG+hr04Ip6WuHmCCxxpqMJCY9nk+XOSP4zHxjbErxO6dfgw12A1FFF81Jw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 06, 2026 at 08:54:39AM -0700, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Move memory policy interpretation out of dequeue_hugetlb_folio_vma() and
> into alloc_hugetlb_folio() to separate reading and interpretation of memory
> policy from actual allocation.
> 
> Also rename dequeue_hugetlb_folio_vma() to
> dequeue_hugetlb_folio_with_mpol() to remove association with vma and to
> align with alloc_buddy_hugetlb_folio_with_mpol().
> 
> This will later allow memory policy to be interpreted outside of the
> process of allocating a hugetlb folio entirely. This opens doors for other
> callers of the HugeTLB folio allocation function, such as guest_memfd,
> where memory may not always be mapped and hence may not have an associated
> vma.
> 
> No functional change intended.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Reviewed-by: James Houghton <jthoughton@google.com>
> ---
>  mm/hugetlb.c | 34 +++++++++++++++-------------------
>  1 file changed, 15 insertions(+), 19 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index ea3bc405b3162..3395de4d0999a 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1334,18 +1334,11 @@ static unsigned long available_huge_pages(struct hstate *h)
>  	return h->free_huge_pages - h->resv_huge_pages;
>  }
>  
> -static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
> -				struct vm_area_struct *vma,
> -				unsigned long address)
> +static struct folio *dequeue_hugetlb_folio_with_mpol(struct hstate *h,
> +		struct mempolicy *mpol, int nid, nodemask_t *nodemask)
>  {
>  	struct folio *folio = NULL;
> -	struct mempolicy *mpol;
> -	gfp_t gfp_mask;
> -	nodemask_t *nodemask;
> -	int nid;
> -
> -	gfp_mask = htlb_alloc_mask(h);
> -	nid = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
> +	gfp_t gfp_mask = htlb_alloc_mask(h);

Same thing here, you already have the mask from the caller.

> @@ -2866,6 +2858,9 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  	int ret, idx;
>  	struct hugetlb_cgroup *h_cg = NULL;
>  	gfp_t gfp = htlb_alloc_mask(h);
> +	struct mempolicy *mpol;
> +	nodemask_t *nodemask;
> +	int nid;
>  
>  	idx = hstate_index(h);
>  
> @@ -2926,6 +2921,9 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  
>  	spin_lock_irq(&hugetlb_lock);
>  
> +	/* Takes reference on mpol. */
> +	nid = huge_node(vma, addr, gfp, &mpol, &nodemask);

I know that before the refactoring we called huge_node() with the lock
taken, but I think that was just because dequeue_hugetlb_folio_vma()
needed that.
Now, I think we can just have it out of the lock.

Bottom line is we should really make crystal clear what needs to go with
or without the lock, because we have some history in hugetlb land about
know fully knowning what protects what and why.

If you think we still need to call it under the lock, I would state why,
but I do not think we do.

 

-- 
Oscar Salvador
SUSE Labs


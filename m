Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F33ABC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 17:57:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15C8C6B088F; Mon, 17 Aug 2026 13:57:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10E0E6B0892; Mon, 17 Aug 2026 13:57:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3F066B0894; Mon, 17 Aug 2026 13:57:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB11D6B088F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:57:44 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2740E808D0
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:57:43 +0000 (UTC)
X-FDA: 85111519206.07.99D7B0E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 324554000A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:57:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ReK/IXSP";
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786989461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i2yF4c1OLwY8lWTysKwC0MTw86KJas6HJqgjleBRs4w=;
	b=QOJE1DFG4y04C03WdRMuDjGxQxvlgORh6sTJgXBubTgCG72844kZaNT7DA4iZcOiT5gm5u
	C6RDHBB3EqcnrQcx7SU3tr1B0162k5OubRBxRFIJnmgrIAWB8FWwKtAUtmms+v8r5KyZW8
	Byy1JfahVz/Zir6h/nd4XOZBYx+yyy4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ReK/IXSP";
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786989461;
	b=aD9SQUZfe9LbW1hxZIxwJfeSFXvWEvA8utDjpayjfZdWtpAqvNtLh2dbAwybYyByEq0WCd
	LJIyGog/COE1T59gRo5osK/hukP4Cfde+axOkj9mA48vIxs9VGO6MGJFYjgSLuzK8MzOOl
	ZP3Hn4VI9fJ3HCta8yB4KLNxzv9N3rw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B0F4F600AE;
	Mon, 17 Aug 2026 17:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51E31F000E9;
	Mon, 17 Aug 2026 17:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786989460;
	bh=i2yF4c1OLwY8lWTysKwC0MTw86KJas6HJqgjleBRs4w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ReK/IXSPH/4YsYTJZkaBfAvgKjwrfynlRf/qwsQFkzdMLro7PTAjFl9rXfwinda3h
	 OoQWPkCFVlEV6OoqID/oSBHI8ah3Fjca17apx3QCIYgKh2gsIKiaUlyN5dcXI/LUJF
	 V1rN0ix1OEhOTAkppuFKARsF75Ifu5mRR+sNJHDfI7Y0ICb8TnOEcnuqx+MskgGzaH
	 xwtxbBHv+KboL/M9Zy5sQ63uKgAFzHv9K1ffro05lDfVoWmBsMZxmEPqm3/3DV7qyL
	 xevV7ckBzNltGWxcfh3NH3aWU+NR6wb8BKE3bE8qmuL2QupgF99sxiHYIsLQolH8P+
	 awDL+LI2VFGxg==
Message-ID: <4e8e208c-3aa4-4060-b0a2-499bc76d19fa@kernel.org>
Date: Mon, 17 Aug 2026 19:57:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/57] mm: add pte_none_or_zero()
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 ljs@kernel.org, nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com,
 rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com,
 usama.anjum@arm.com, agordeev@linux.ibm.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 kas@kernel.org, jannh@google.com, willy@infradead.org, pfalcato@suse.de,
 rostedt@goodmis.org, mhiramat@kernel.org,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20260816224609.308019-1-kirill@shutemov.name>
 <20260816224609.308019-3-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260816224609.308019-3-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 324554000A
X-Stat-Signature: tqb6wg7zabdiwih4gywuums97y475xa4
X-Rspam-User: 
X-HE-Tag: 1786989461-189980
X-HE-Meta: U2FsdGVkX1+I3hNnefFFIXxd/EwESZfL8Ghrka2wOGK03zt4UTVFjRBMts5NgPZeYyCk9ClYxaUdjRjNLG73w9NjGVcHkD9GYCjoKQ59nhWpRgEgoznMeIobmUQurraLfWwUS0e6tsxlf4iuvjGBq0ZbsY0hbDAqIvdhsmrVZD1MNuioB4Gm+q9rCe/cbf2jfofP/xt7mqQ3kiR5R/lohxvsnjliF+blku4olaZUv1iriRwMXTxddykrxfRu3aMrPE++Pb9iyP4MSHYZ98mXPWiLNzCSFUsEdJDDnFC6mLrBvtmEJnTavjhZ+nl4Swhoymv0Al/DOaUWGk8kpPzsPLfszK6aUqWjFrMm6/ZWaIDexOipFUuKL/qR+8z/oezJgtZvcUDT5bspsPasxaaQVUKDVtezSONamundm7m4npLtVaxOJy93Kf/xAYjZOt3YAQc0Bq0hLU+QfgMlprJt32KfaDWMXjle477pkQ24Qzh4tPYaeUPeYnUXXHeupH6/3i1JTZ2tAP6A8uTKSERf3QbvVsPEAHbAvKkQ9hRzHrjv/YCQ0edj3OTVHCizjaigq8+g77tUu+VP6UK9SYzLnFYG1u42etfAUDuZOsKsKyQ1ec3yK/hfw5a7AnuQeodn7Nfzo2DnNyPLkm16jS8VBlKdrWkCJkAWQmpj2zYty7Tfx8N1m5Hu89j4pj5y+EPO4OUvrCbQzYQcsO7V7GMKeecXkgr8PrqRWBPkVBCIG2qVSY87nFhMzhXxgca/oqZA9TXJoqnSfg0ooqRByv3YfGkMkm08xwW8WjhR81RzP9Ub1NjEINwt0ESX0kRVHEGx27QPc6OgsK9SDsFfwzeTU+w8BwBFDdrpqVY44hpOihb8JzacMh5vGSHNu9reLoSi6nAphGwGY5zl+AiwLycE0AXnDe7PRLA4lgo1JApEQuVDFyZdxF2LdDySHV+GXX+6LRdGddS0QIq7MZZqo7V
 O10Ct5cb
 RLp7UDF6bcU0c8/21jvyUd3MMDI8OIdeiva185++MyDakYQ4knHvO11S4glCG2gS6pL28LhgZVpVjHHtzyBAVvcslI03DkOELQfGFTlqTQlscde7k2IQ5btHxNzo2ztbKnQlt+LutJiNkWoAyyQecVBmsH70lZFBVaZVYc/QLLF+Jo3wUEMs9k0zOTOjhIyhMxEn51FPu9KmIfbU+04woBNnkW0frYUhn9GAvEZw+c93CcDFGBhJWqniczm2nPd03jkvcELkE3q8CJNPK6L/51YFc+fu7EEx66jq+75UmF0V39Yl6xmBgkpdRtsWwGOgaCrJ4MksM43fySn4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/17/26 00:45, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> A PTE that is none and one that maps the shared zeropage both stand for
> a page of zeroes the mapping does not own.  Code that cares only about
> the contents can treat the two alike.
> 
> Move khugepaged's local helper for that test to pgtable.h, below the
> is_zero_pfn() it is built on.
> 
> migrate_vma_insert_page() open-codes the same test on the slot it is
> about to fill.  Convert it.  It still tells none from the zeropage, but
> only to decide whether there is an old mapping to flush.
> 
> No functional change intended.
> 
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  include/linux/pgtable.h | 17 +++++++++++++++++
>  mm/khugepaged.c         |  7 -------
>  mm/migrate_device.c     |  9 ++-------
>  3 files changed, 19 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 8c093c119e5a..bbee6d31f015 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -2064,6 +2064,23 @@ static inline struct page *_zero_page(unsigned long addr)
>  
>  #ifdef CONFIG_MMU
>  
> +/**
> + * pte_none_or_zero - Does this PTE map nothing, or the shared zeropage?
> + * @pte: The page table entry to test.
> + *
> + * A PTE that is none and one that maps the shared zeropage both stand for a
> + * page of zeroes the mapping does not own, so code that only cares about the
> + * contents can treat them alike.
> + *
> + * Return: %true if @pte is none or maps the shared zeropage.
> + */
> +static inline bool pte_none_or_zero(pte_t pte)
> +{
> +	if (pte_none(pte))
> +		return true;
> +	return pte_present(pte) && is_zero_pfn(pte_pfn(pte));
> +}

(casually skimming over some patches)

That's just a horrible function. :)

If there is no pte_zero() then there also shouldn't be a pte_none_or_zero().

And in the code-base we have "pte_t pte_zero = {0}" which actually makes sense,
but is not what we care about here.


Just have an additional helper like:

	pte_maps_zero_page()
	pte_is_zero_page()
	pte_maps_zero_folio()
	pte_is_zero_folio()
	pte_zero_page()
	pte_zero_folio()

And let the callers still spell both cases out.

if (pte_none(pte) || pte_is_zero_page(pte))
	/* Do something amazing */

(we have both is_zero_page() and is_zero_folio() I assume "zero page" is cleaner
as this thing might soon no longer be a folio)

-- 
Cheers,

David


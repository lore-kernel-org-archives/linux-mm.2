Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF0B9C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 14:28:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1CF56B00A3; Tue,  7 Jul 2026 10:28:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACE006B00A5; Tue,  7 Jul 2026 10:28:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BE3B6B00AC; Tue,  7 Jul 2026 10:28:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D3546B00A3
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:28:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E27D01A0487
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:28:21 +0000 (UTC)
X-FDA: 84962210802.17.8A13558
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0D5EEC0005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:28:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lLUj0RXq;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783434500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SMQ8K9VfUIpA2XT73iQzn2WJ6V6USrzYPAEG4w2/L94=;
	b=mSLdYnljwK78Wvk4rsSoucZvZON/gRQpSmW0L/TeESzRR5IeQFuT8AlEJhZNBRp3vZT66h
	9Hfri83Qk09gdXzZEqNqJ7AkCSYs48EXN/Cqldh6J5rbfTbV3abLIw7ssBDialT+mtCxWT
	4K21BK6qS18vkx0vxvPDafo6ziDnagw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lLUj0RXq;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783434500;
	b=x4PPYoDWe86PqWmfrlkcCfxG3C440dPoDcW1kBa6+Y/oW+ZxjGaSVNeI5BOjfvbSA3h7Np
	g3DVFX4sF1//JYkyIOdBbYE+9pNhow0ADLKkDccCBqCxizsFPDYdxKcpGUvZ/0hyKktkUJ
	alB10oOWLV9kv2PIvSMO0pTIo4ZJNZM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4099F42ADC;
	Tue,  7 Jul 2026 14:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0412B1F000E9;
	Tue,  7 Jul 2026 14:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783434499;
	bh=SMQ8K9VfUIpA2XT73iQzn2WJ6V6USrzYPAEG4w2/L94=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lLUj0RXqa3eqVSWa8s3jcLRzvPAoxXywuBBbtB7eGxbsslO52vc2uQi76DXyAQ/Uo
	 1k6hzKcGoTWdwSskzPk3fXkyS9wDJBndvI1/c30aawuCArJtFmFwmY9YZgO2W5sYhA
	 VtkeOJPuAyGMaSKSmRPT7NYc5h7dJub2XY4T0rfN9irI/IK/bPx8eTLkcQiHcRn54G
	 e+UzX8IH0ElSGDmyTkrpcdLutlBYQD1dnghqosFDVj3CpzhE6Z8XE+HWqUiG+4qFve
	 LqZ95gSpLLgfHSfmBOupEsM9hAon1Vx2suTZp2jDGzZYloHcDfyZjpnpdTJkeyW3Z7
	 UyXmhFnuBFB0g==
Message-ID: <50b0de85-0bb9-4d09-b32e-31a3a4661379@kernel.org>
Date: Tue, 7 Jul 2026 16:28:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] mm/rmap: add anon folio unmap dispatcher function
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 muchun.song@linux.dev, osalvador@suse.de
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260707121128.373192-1-dev.jain@arm.com>
 <20260707121128.373192-6-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260707121128.373192-6-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cwg668qte6sshox7e6ak51gyahubkfwr
X-Rspamd-Queue-Id: 0D5EEC0005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783434499-799489
X-HE-Meta: U2FsdGVkX1//W+XRs14z0PzTW15TUnn/ZRPOHA5vk3fZl+XUwWXWvC5YCKeFe10korL/ECqnv0s68CSH8yfiru+KLEMdLEymceTQgHpABP1gfhIsb/EwAOmYVN8ATD4ywCD+bSYDh2/LXHZZFFuGZrhQnm46jaa6qVd1P/WttvzxM0NlkUH7W0+6VUfvhqc1rAz7tRiu2obvEJmpjJHVXypwKWiJKarQgsEz+R/P3mAyQKblpIX4O8do11anQxbkLn6T+eolezGn0O7SEhaUOt47UCzQShd9JXYvL0Ml1I5MZU1MyjjQZalQUn6lhG8bYqCtA9A9TI6E5kty94mitXR0XRvKmRr1jHuk/BNH5B2lmZxlEpoREIgULBCQfYo33d2F/rwLYKW9jmwWhewRWqvcAWen4q3e+7ywiw6nOQQgv3/FpQpqhrcB93qhDsAVcRElboS857gIlEsbc28vvUm5mluUQLbDxM9fLMQ1BhTVwxYbUhQ1bNFqJ6WVtnousJWvXv/eDmTetEwJY7JXxhMG2eZR46y3Z4jMn+VNr0/m0CVEa7xQYhtBOIvO3v3SIlt0KoblwMFgD7nQGAF5wqgUUwYOC7Eu3fY4kgT/GoSNHKq0W3mgGBfEHVHq/1zqUtJ4K/1eaPxLyEVueCXZ3g/ZQqZgartj4ylKB9kuo9vGeDbydI5oSFsVuQH7IbI/UcPAuS9pB2QmLpUmazPcMqHGCkIS7fYtAVSFRDksAwMWTvJ6imPavJBEd+h0YR5vTQQaIqZ3OkSU37WkT8zgvgnGkKw8wQ9y+CRribml0O+TxLgmxf26PxaNwUBT0q44mtN9FlbNqKe4hxqdWnV/nBD2GufALcrVtTUrE3G47wpp2nDWoWw0h6/wD6OmWD08BmA66izc+JImajJcOYKjRGtd124NPxTUqqakSa/pus1FyyzdDvCj27wfO0sD0SUeOQskwQwebOlLQw5nBVY
 Qye+C/MD
 Cf6dkISRB4nDu7syqBnaHCv7vIKd9hi+KpnUWebmgizKNGgCuNNAV+TBsshPWGZ3+RmU+l9Pa+5kbpaGysL9sgxd6sf5H3/18wQPiOCJ4wA8ZojNLuIriog9YaNw4x18qtsQNw70w9A8908TpqCDxkTeSxRvszsnE2n/BudiYEPoIbx7bzd8CzZgJ43/6SaRL/GX8DSasvLmJ0QVTrydh1dw5T8AtKNKD6o1sRUVtccI7Meb5u/eT2IHkfGZ659FV5DrbJqbwQuBpHovvjBGiHJNSTcU2+tOoyl6KzgqOfqFdT7iwoB2+ElmiVZGoyFzewPkO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 14:11, Dev Jain wrote:
> Add ttu_anon_folio() as the common entry point for anonymous folio
> unmapping. It dispatches to the lazyfree or swapbacked helper as
> appropriate, and centralizes restoration of cleared PTEs on failure.
> 
> No functional change intended.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/rmap.c | 59 +++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 36 insertions(+), 23 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index ade78df5be2bd..f021ecd51a4a2 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2171,6 +2171,40 @@ static inline bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma, struct
>  	return true;
>  }
>  
> +static inline bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
> +		struct page *subpage, unsigned long address, pte_t *ptep,
> +		pte_t pteval, unsigned long nr_pages)
> +{
> +	struct mm_struct *mm = vma->vm_mm;
> +	bool ret;
> +
> +	/*
> +	 * Store the swap location in the pte.
> +	 * See handle_pte_fault() ...
> +	 */
> +	if (unlikely(folio_test_swapbacked(folio) !=
> +			folio_test_swapcache(folio))) {
> +		WARN_ON_ONCE(1);
> +		return false;
> +	}
> +
> +	/* MADV_FREE page check */
> +	if (!folio_test_swapbacked(folio)) {
> +		ret = ttu_anon_lazyfree_folio(vma, folio);
> +		if (ret)
> +			add_mm_counter(mm, MM_ANONPAGES, -nr_pages);

Can't the be handled in there as well?

> +	} else {
> +		/* nr_pages > 1 not supported yet */
> +		ret = ttu_anon_swapbacked_folio(vma, folio, subpage, address,
> +						ptep, pteval);
> +	}
> +
> +	if (!ret)
> +		set_ptes(mm, address, ptep, pteval, nr_pages);

It might be cleaner to do that in the caller, where we actually removed the ptes
in the first place?

> +
> +	return ret;
> +}
> +
>  /*
>   * @arg: enum ttu_flags will be passed to this argument
>   */
> @@ -2351,31 +2385,10 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  			 */
>  			dec_mm_counter(mm, mm_counter(folio));
>  		} else if (folio_test_anon(folio)) {
> -			/*
> -			 * Store the swap location in the pte.
> -			 * See handle_pte_fault() ...
> -			 */
> -			if (unlikely(folio_test_swapbacked(folio) !=
> -					folio_test_swapcache(folio))) {
> -				WARN_ON_ONCE(1);
> +			if (!ttu_anon_folio(vma, folio, subpage, address,
> +					    pvmw.pte, pteval, nr_pages))
>  				goto walk_abort;
> -			}
>  
> -			/* MADV_FREE page check */
> -			if (!folio_test_swapbacked(folio)) {
> -				if (!ttu_anon_lazyfree_folio(vma, folio)) {
> -					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
> -					goto walk_abort;
> -				}
> -				add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
> -				goto finish_unmap;
> -			}
> -
> -			if (!ttu_anon_swapbacked_folio(vma, folio, subpage, address,
> -						pvmw.pte, pteval)) {
> -				set_pte_at(mm, address, pvmw.pte, pteval);
> -				goto walk_abort;
> -			}
>  			goto finish_unmap;
>  		} else {
>  			/*

Very nice.

-- 
Cheers,

David


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED6B5C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:31:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDCB46B007B; Mon, 27 Jul 2026 12:31:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB3856B0088; Mon, 27 Jul 2026 12:31:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC9E36B008A; Mon, 27 Jul 2026 12:31:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AAE916B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:31:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2DE76C0138
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:31:10 +0000 (UTC)
X-FDA: 85035096300.25.290CB4B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7DA9D40003
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:31:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ei438QZP;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785169868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xD3dgh+LvUBXuj8H0JRUqv8XiAhtAquDiwD9DIx7mY8=;
	b=kzt3s0zdB/WovgvG+sX3MqFx/HMYd23Pssc0G19YWrPJXMXRLFmi/bEC5c3PsRzz6N8g9I
	OweLgayZoYab50V820dBxmgpgUIjnkc+ysTVTYnYJ9Wlig4fKbKnpt99pZxEAzmxTPiq/W
	jRG+VhXDHu1u1JVsEn8MM2Zgn/Wyr/U=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ei438QZP;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785169868;
	b=WGXEoWmaJXfxH3QNmS+EB9o8MY4V352sOnrjizv8qzlmr4zXFaJTFCbhQh2TMc3fG6G25u
	8gLyRYpesIiPJCbkBsBKVVH5Tbb/BQP+kpXNftPk0wQ63U1FwxIXEsCwRgnJCfer2M9wsV
	+fOolyXaS4TJT7SkedN/gWhbx4s8iHw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AAD84434F3;
	Mon, 27 Jul 2026 16:31:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6381F000E9;
	Mon, 27 Jul 2026 16:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785169867;
	bh=xD3dgh+LvUBXuj8H0JRUqv8XiAhtAquDiwD9DIx7mY8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ei438QZPhoA/j4TNX5sKSZg5DC94anuXDfwoCs3yZ2nJ1Oo93Z8QUJh0hP+z8jZfx
	 mvDvVMgJYsQ8OLdhMamWwAEZDxoj7gyp4EdbNObTpzy9Bg8USo+npPQAQuMCrN/RRx
	 58Vb14FKQ+pq8lMWh+GJn5EmAzsQrh7qEucJJNxVf3Rq9Q7MAf/oi7JVeOJtdxjOEV
	 QGnVdcagw3jrjs8gqu7q4xY4E5RkSpPAS2vNOoRYOcqHrN8lM4/EMdx5XhG48/rkwa
	 vrY1+iC3yvCIF7sDeFCS3a17J0J76nGjnXB+FGLpElE1FKSfCksjfAo8RNZq/teTMr
	 UAgmKCVERFOAQ==
Date: Mon, 27 Jul 2026 17:30:51 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH v2 2/2] mm: Extract non-swap page handling to
 do_non_swap_page()
Message-ID: <ameHdtnC4BxjgQGL@lucifer>
References: <20260723030752.16979-1-hongfu.li@linux.dev>
 <20260723030752.16979-3-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723030752.16979-3-hongfu.li@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7DA9D40003
X-Stat-Signature: zng4qpgoqyu6ybct86ka9e7uyt5ud9q5
X-HE-Tag: 1785169868-282903
X-HE-Meta: U2FsdGVkX1/rwOsfeQ7znyEe2Z2GGfqkv254l+UyXvJLXQoqBxyz5ll9W31mdltuXz2soXy5dPJKKkYsI0KbeITKEs+Tk3g+GyzTqMSjWbY4vzHhyoRbfrNdp/CGbplQFFV2eIUkRHknV2xUT73kM+f24M7yKa4kVAqgwa8Rlz6DICjHx2ZPm6ZSYBXNaLHCkgXykPQxXbWYSGcgEBX0kYOICvEkBDapJ8ym/SUaXg+iL9O+kvY96Ca7jAMB8zagZ/sfR13KTE50/XxxcF3yqttT4MrxnnvWUtyGApZe9VrRN0UDXEdXUdnV5CLRCfFPpG2UChMtl4pwBwEQOSvA0lpCkG+zhKToyTdRFOtsLljMHOM9+/gYhpuovmXrif7hCYXG3u2s42rDAhYsUrPHFSoJdP/fYlXYqfqJys0ZI9ktsHTOMnuzJxv6N21AfQX7ggGnKYKFqYAknoRczeYv4iNPv/Nnb2MKXvZUk5pX+1B7G0A+pI5u4FhZpBM75q2O0FDQjzK62vFFAHNNFVGjuiekcvkJfBYpSObpAKmroLMJEiX1cOOeS+wJYJvn/TOzMOYYFJZaRyKn+cQmQfVFZxyBJS/YwMUJ34GFcr9A5+aDBlKNN2Sx27Z3xxsANKg5CHyjNxoc9J9qu2/JUnq7Qs5d3QrWkal7WrKa+zO7Os2q3XVoXpsNixiy5lUvOsVa35DBhbpbqccdglKmUip76Nf/iuco00TsYQUBkIhPURBjGaYTN+30lK2swwhwsEjeQoX1G/StV5h+djtfmzzhOsrv0eFL+0/eXiH3XYV4P1IEVsJqb2qn5xfQKY1C1pra+H+c7+bvKCWpZG2NVUdjiw3eprMxENdHmieOQamKO21o2H+2E+IpzzMcDGiKw6W1Olgcfo7S4/Nd/1AmukX9v7fnR4Jc946AZP22T5c38GbzFBiJ8S9V/Dmmh10tno2tKYxy2l9989QYtw00iHN
 e78SfB2R
 B5lAOfj1dxXg5dL/iPrCref2AYriCgzfNZjqlJl3QGZ8qBopD8I0YNCC0OmTZWDQpsLizUpPNGcQdmdsIx5tV3xIFN5zErhUzdpSaNGcoVV5U8ByUMtl3yYIGp6+Tr00B70FwRGNLaioV/AiPgP5T020sMi+tJ3d6f2h8K6GZPcuYXNpXQ0geE9+9eyIKuCPr67Zct1E6uRc2ekrOU1pqB01xQbv/UenDNwQn0GiYS1kDyrN0eiD3/JiCJG0vxSRQY7tcmmFuwnX4ze/PoxUmNQmRUqKfDs9upXLg6VBnxIUkbtk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 11:07:52AM +0800, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
>
> Factor non-swap entry logic out of bloated do_swap_page() to simplify
> the main swap fault flow and improve readability.
>
> The new do_non_swap_page() handles migration, device private/exclusive,
> hwpoison, marker and bad PTE entries.
>
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

We've already gone over this elsewhere in the thread, we don't want a
do_non_swap_page() (HELL no).

But in general I want to finish what I started with softleaves, which still has
some work to do with swap entries so maybe could you just drop this patch so I
can follow up with that later?

That way you can do a respin of just the 1/2 as a v3.

Thanks, Lorenzo

> ---
>  mm/memory.c | 120 ++++++++++++++++++++++++++++++----------------------
>  1 file changed, 69 insertions(+), 51 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index ae521baa8c84..50d8e92aef91 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4815,6 +4815,74 @@ static void check_swap_exclusive(struct folio *folio, swp_entry_t entry,
>  	} while (--nr_pages);
>  }
>
> +static vm_fault_t do_non_swap_page(struct vm_fault *vmf)
> +{
> +	struct vm_area_struct *vma = vmf->vma;
> +	struct folio *folio;
> +	softleaf_t entry;
> +	vm_fault_t ret = 0;
> +
> +	entry = softleaf_from_pte(vmf->orig_pte);
> +	if (softleaf_is_migration(entry)) {
> +		migration_entry_wait(vma->vm_mm, vmf->pmd,
> +				     vmf->address);
> +	} else if (softleaf_is_device_exclusive(entry)) {
> +		vmf->page = softleaf_to_page(entry);
> +		ret = remove_device_exclusive_entry(vmf);
> +	} else if (softleaf_is_device_private(entry)) {
> +
> +		if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
> +			/*
> +			 * migrate_to_ram is not yet ready to operate
> +			 * under VMA lock.
> +			 */
> +			vma_end_read(vma);
> +			return VM_FAULT_RETRY;
> +		}
> +
> +		vmf->page = softleaf_to_page(entry);
> +		vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
> +						vmf->address, &vmf->ptl);
> +		if (unlikely(!vmf->pte ||
> +			     !pte_same(ptep_get(vmf->pte),
> +					vmf->orig_pte)))
> +			goto unlock;
> +
> +		/*
> +		 * Get a folio reference while we know the folio can't be
> +		 * freed.
> +		 */
> +		folio = page_folio(vmf->page);
> +		if (folio_trylock(folio)) {
> +			struct dev_pagemap *pgmap;
> +
> +			folio_get(folio);
> +			pte_unmap_unlock(vmf->pte, vmf->ptl);
> +			pgmap = page_pgmap(vmf->page);
> +			ret = pgmap->ops->migrate_to_ram(vmf);
> +			folio_unlock(folio);
> +			folio_put(folio);
> +		} else {
> +			pte_unmap(vmf->pte);
> +			softleaf_entry_wait_on_locked(entry, vmf->ptl);
> +		}
> +	} else if (softleaf_is_hwpoison(entry)) {
> +		ret = VM_FAULT_HWPOISON;
> +	} else if (softleaf_is_marker(entry)) {
> +		ret = handle_pte_marker(vmf);
> +	} else {
> +		print_bad_pte(vma, vmf->address, vmf->orig_pte, NULL);
> +		ret = VM_FAULT_SIGBUS;
> +	}
> +
> +	return ret;
> +
> +unlock:
> +	if (vmf->pte)
> +		pte_unmap_unlock(vmf->pte, vmf->ptl);
> +	return ret;
> +}
> +
>  /*
>   * We enter with either the VMA lock or the mmap_lock held (see
>   * FAULT_FLAG_VMA_LOCK), and pte mapped but not yet locked.
> @@ -4845,57 +4913,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>
>  	entry = softleaf_from_pte(vmf->orig_pte);
>  	if (unlikely(!softleaf_is_swap(entry))) {
> -		if (softleaf_is_migration(entry)) {
> -			migration_entry_wait(vma->vm_mm, vmf->pmd,
> -					     vmf->address);
> -		} else if (softleaf_is_device_exclusive(entry)) {
> -			vmf->page = softleaf_to_page(entry);
> -			ret = remove_device_exclusive_entry(vmf);
> -		} else if (softleaf_is_device_private(entry)) {
> -			if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
> -				/*
> -				 * migrate_to_ram is not yet ready to operate
> -				 * under VMA lock.
> -				 */
> -				vma_end_read(vma);
> -				ret = VM_FAULT_RETRY;
> -				goto out;
> -			}
> -
> -			vmf->page = softleaf_to_page(entry);
> -			vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
> -					vmf->address, &vmf->ptl);
> -			if (unlikely(!vmf->pte ||
> -				     !pte_same(ptep_get(vmf->pte),
> -							vmf->orig_pte)))
> -				goto unlock;
> -
> -			/*
> -			 * Get a folio reference while we know the folio can't be
> -			 * freed.
> -			 */
> -			folio = page_folio(vmf->page);
> -			if (folio_trylock(folio)) {
> -				struct dev_pagemap *pgmap;
> -
> -				folio_get(folio);
> -				pte_unmap_unlock(vmf->pte, vmf->ptl);
> -				pgmap = page_pgmap(vmf->page);
> -				ret = pgmap->ops->migrate_to_ram(vmf);
> -				folio_unlock(folio);
> -				folio_put(folio);
> -			} else {
> -				pte_unmap(vmf->pte);
> -				softleaf_entry_wait_on_locked(entry, vmf->ptl);
> -			}
> -		} else if (softleaf_is_hwpoison(entry)) {
> -			ret = VM_FAULT_HWPOISON;
> -		} else if (softleaf_is_marker(entry)) {
> -			ret = handle_pte_marker(vmf);
> -		} else {
> -			print_bad_pte(vma, vmf->address, vmf->orig_pte, NULL);
> -			ret = VM_FAULT_SIGBUS;
> -		}
> +		ret = do_non_swap_page(vmf);
>  		goto out;
>  	}
>
> --
> 2.54.0
>


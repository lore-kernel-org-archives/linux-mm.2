Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0827C606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 14:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mhtq+G06
Received: by kanga.kvack.org (Postfix)
	id 0193A6B078D; Tue, 27 Oct 2026 10:39:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0CB76B078F; Tue, 27 Oct 2026 10:39:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFB926B0790; Tue, 27 Oct 2026 10:39:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B37FB6B078D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:39:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 46F441A09FD
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:39:31 +0000 (UTC)
X-FDA: 85368664542.06.FA59F3C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7F15880008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:39:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mhtq+G06;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793111969;
	b=evP6qYbakwmBhCAVrdayNYTjMWgg0aIwtRc4+CfXg0XB/j9JoY5ugBBNr/+7SOr3d4i0/N
	MQUOj8RAluFCmjWgBKYKHoNuudG2YVdWOVrSap4ll+5EalV0zTdxaKQtAaghLuCv1+YToX
	BGj15Q2+GTS6QZJ7zegeFa7WE+QTiiE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mhtq+G06;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793111969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zWKNZJvS98TaYn91gneC8TBH6IkytbETY3YYVo94WFg=;
	b=8FcXxjMeUpzyjaMIj4+jTCWu2Mtbx5uiwq1zQaCesjhactKT2URCMW2pBj8znmHDh+P0bG
	7+q923JBL0sTPe9rG0FnaElPIrlvOU2uj/S4p8bNQe/CxxxEzsAxrC0FuNamSulPwaqlMD
	djhbY4GD9WG4aqj5W4Vxa6TqoAutjqI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DAD446021A;
	Tue, 27 Oct 2026 14:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A1C1F01828;
	Tue, 27 Oct 2026 14:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793111968;
	bh=zWKNZJvS98TaYn91gneC8TBH6IkytbETY3YYVo94WFg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mhtq+G06kqC3xeB4k1jE+dmZEllYWsCyHRkDYVcdsaBoV8aW199hq1GaHjzFYOz0p
	 vuNdJJUHYSi/oKO4hOgIQ3k/DhuVPlx0CBSsPodt2GfXNCg7s9rnCI9x6Mo3k5rJNx
	 3pbyLKia5J4YIOawICwO5EcvkwibwoPe39YF4zpytydfEtNzz1POphpsG/gvK95orM
	 v25QLAFQvhgys9n5rsJWOHakEo+VPMg7kbTE2WMa3hJ4FIPb4m9GY1TSA9t5Z8EviY
	 k0HqoCHaAfyCbhzNVUM2rosDzTzE+etBEveMz1+Silpow9WeNMVmUBMK6f8Q6m7mt+
	 M6g8TfrvFDmrQ==
Message-ID: <8c164738-8025-482f-828a-3f919150a930@kernel.org>
Date: Tue, 27 Oct 2026 15:39:20 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/4] mm/huge_memory: copy file THPs at fork like
 copy_present_ptes() does
To: Konstantin Khorenko <khorenko@virtuozzo.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
 =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>,
 linux-kselftest@vger.kernel.org, dri-devel@lists.freedesktop.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
References: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-0-66f00b7a564c@virtuozzo.com>
 <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-2-66f00b7a564c@virtuozzo.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-2-66f00b7a564c@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F15880008
X-Stat-Signature: eaawq4h6xfpafpam6bmzxksa3gcgaxzm
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793111969-245192
X-HE-Meta: U2FsdGVkX196oHJ7mhgIZAbOwi9+tzGSIDAvOYzYsd/GB/pRXdSr7/fnOwkuoseImECAeGzat45y6jEZxCGvhmM26MoEdUX/hG65WiIwFBEIyhJkfRhTtvJgw/2YOZGP5zUCGyxCAaTWo2oyhiCi4kfzqPLgoQxLWtKssKBJPm0erU7+4W9USi/vlzvRP5n5hBIQIP75CSx4un9vcjVHm9W8ywhgqkmA2ZIGxU6rnVcM/DvfycIpfG3gVQU2LC90dBMbiSA8Babg2cN+TSaqjjaJ+ns9cUQoafGPBW4YOHguRcQR1XL/YndvdeJIPguWj4t7SXJ2TrzpA6AW2QAPkcmvl7pYAClx/ki5Vkd8rOy8yc/rL4HonIkFwXKBhsXY1XTb3oR4lkAVG2gzv0icQM/NwJ8JCnnYetl3dXUPeCisYGPy6dWf8h4MJhhp0hrT0kVzoLSaLpVJNTVtdiyXfLlIN2OqYFVzo00HErDlQ5jux7Z4JPHOGBFyXj4/D79+lb2y9aHJRGFNLlw+9Lkxhkm8/2EpXGfAS9OPIDvsH07G735Foq91CKjhlgPeQ/G5ZqtMtZNh0irhNPDODsiWyDdrgRraphlYgDAW0a4azpFpHHo0HBEyCeATnAuuvCh1AVQ2+/m+NXkYUacjOsdmnYA+YohzyFBq5CFJaYRcVhOVpbi+f6/373WRyHkW8ohHwPtFRv2nYUCgHtAno7xCA99Z4upHwpid/YJGK6d9bVEpiXwleVRkFtd/oNezwqEVde3coPHT9rphOG5pY8fJu7cumJJzbHRStTM99nCBpwp6hN9bZ9mhC5Exmu3Ob2AlgBME1bgbIWRp2v8C6iKjfSG0ZbDYKrM49FnkzAa+5UaOeBW3ZL5yfinTlFwb6BMsgyuAFc1QV5CNR/gExDQ4j9hsGhQwTTeiLHXdNemeIFinAcsxgwCMxx4vpLonTCCRfUNiRdMB4oo7AH+f//b
 V1WtRz7f
 svI9ztY3mVIqXi346+jOzz7Q31m03sOa3ciPn0dXb4vC+iZ7mB4OQ218Nz7yPHiqBiXvKXxq20WToqrGbGCWM9utmfri1RLOqXCTewv3Vjmnabz5HgSA0cO+AZCNS3qUfZf7107Tx1kcwT9adxDKrW1b6LOetJTNV7ErOYgOC1qIJwGE07Aumbk34yIQ6+1x+QuK654auPDMknhXdfIhl6Rp/HZddDQLDObZp97LOJTjeSfn8v7VyoBKK3kHKfqCUbswV+2XvRRCJAkmbSubTtjN1gV5b+7TL+PXDJ5WfAuATavBAH8iUC0YL6WhiqASomy3gfka0V+IiUm3+wmGTWZQERUZFhlWsWNVC4dj3t6rcgqEZx6nVbumyz/WfAYbpKKj87UFbQ5pe/QLdRKf2IRR/CDFXGzG503Yi3ocnJ8C84Gr10Qwn1U0/REr7xdq6DLLfLWL+naa+xD9vKTStw/0RsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/21/26 22:36, Konstantin Khorenko wrote:
> This fixes no bug: it makes fork copy a PMD the way copy_present_ptes()
> copies a PTE. Until now copy_huge_pmd() skipped every folio PMD of a
> non-anonymous VMA and left the child to fault them in again, while the
> PTEs of the same VMA are copied.
> 
> Treat file folios as the PTE path does: take a reference, duplicate the
> rmap and account them. fork then pays a reference and an rmap update
> per PMD, and saves the child a fault per PMD it touches. The next patch
> sends PFN mappings through the same tail.
> 
> That covers the VMAs vma_needs_copy() sends here:
> 
> - private file mappings with an anon_vma;
> - VM_COPY_ON_FORK ones: uffd-wp and uffd-rwp, VM_MIXEDMAP (fuse DAX),
>   and VM_MAYBE_GUARD, which shared shmem, file and DAX mappings get
>   from a guard region.
> 
> The DAX huge zero PMD is copied too, with a reference taken by
> mm_get_huge_zero_folio() as for anonymous VMAs. A migration entry of a
> file folio is copied and accounted like copy_nonpresent_pte() does, and
> made read-only in both processes only in a CoW mapping.
> 
> The copy then gets the same tail as __copy_present_ptes(): write
> protect both sides in a CoW mapping, mark the child's copy clean in a
> shared one, and drop the uffd-wp bit where the child is not armed. An
> anonymous THP is now write protected only when its PMD is writable, as
> a PTE is.
> 
> A page table is deposited under the copy where the fault paths deposit
> one: in anonymous VMAs, and wherever the architecture needs one.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
> ---
>  mm/huge_memory.c | 60 ++++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 37 insertions(+), 23 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1e5d68acf62a5..13e3674fb6115 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1898,12 +1898,13 @@ static void copy_huge_non_present_pmd(
>  		pmd_t pmd, pgtable_t pgtable)
>  {
>  	softleaf_t entry = softleaf_from_pmd(pmd);
> -	struct folio *src_folio;
> +	struct folio *src_folio = softleaf_to_folio(entry);
>  
>  	VM_WARN_ON_ONCE(!pmd_is_valid_softleaf(pmd));
>  
> -	if (softleaf_is_migration_write(entry) ||
> -	    softleaf_is_migration_read_exclusive(entry)) {
> +	if ((softleaf_is_migration_write(entry) ||
> +	     softleaf_is_migration_read_exclusive(entry)) &&
> +	    vma_is_cow_mapping(src_vma)) {
>  		entry = make_readable_migration_entry(swp_offset(entry));
>  		pmd = softleaf_to_pmd(entry);
>  		if (pmd_swp_soft_dirty(*src_pmd))


Any reason we're not adding the vma_is_cow_mapping() check on the
softleaf_is_device_private_write() path as well?

(I think they are all anonymous ... just for consistency)


Is the fallthrough:

	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR)

really expected?


> @@ -1927,7 +1928,6 @@ static void copy_huge_non_present_pmd(
>  			set_pmd_at(src_mm, addr, src_pmd, pmd);
>  		}
>  
> -		src_folio = softleaf_to_folio(entry);
>  		VM_WARN_ON(!folio_test_large(src_folio));
>  
>  		folio_get(src_folio);
> @@ -1939,9 +1939,11 @@ static void copy_huge_non_present_pmd(
>  					    dst_vma, src_vma);
>  	}
>  
> -	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
> -	mm_inc_nr_ptes(dst_mm);
> -	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
> +	add_mm_counter(dst_mm, mm_counter(src_folio), HPAGE_PMD_NR);
> +	if (pgtable) {
> +		mm_inc_nr_ptes(dst_mm);
> +		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
> +	}
>  	if (!userfaultfd_protected(dst_vma))
>  		pmd = pmd_swp_clear_uffd(pmd);
>  	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
> @@ -1957,6 +1959,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  	pmd_t pmd;
>  	pgtable_t pgtable = NULL;
>  	int ret = -ENOMEM;
> +	bool writable;

Why do we need this variable?

[...]

> +		goto copy_pmd;
>  	}

Likely we should clean this up later to avoid the gotos.



-- 
Cheers,

David


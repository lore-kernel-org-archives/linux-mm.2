Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60460EB7EB1
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 09:00:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97D366B0088; Wed,  4 Mar 2026 04:00:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92AE96B008C; Wed,  4 Mar 2026 04:00:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 836FC6B0092; Wed,  4 Mar 2026 04:00:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 74A646B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:00:10 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 36D4D1604C5
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:00:10 +0000 (UTC)
X-FDA: 84507783780.23.61959C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6FAD2140005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:00:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s1E1RcXB;
	spf=pass (imf09.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772614808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8k5Yev2diQYM+kPrrSqykQkGj4em+aEHEpNJoOvXFHs=;
	b=OB2qj8fqteGb/LQi//lLr9QpF4Sg3SiF38GiFod3FEa3wq522GaIljrNy4YDQ7TyXpOmwo
	p5MNbNr0QWwK5E8dtK7PWsCrYuhcU1QpWw9SnsQQLX13dvOBrAwZtD141whPivMbb+S4Nk
	rtZq47B3S3ZPRXkQ/qk/jQKS4opdDWM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772614808; a=rsa-sha256;
	cv=none;
	b=SKM/wiKQ0ans1yjYUM2hbSgwC3qYd4thAIu/iNEqm3ew5gbdPmv43TpUoPbyzkBWVk1Ysz
	n0NGqoNJjVewj/3VE/wv0llMRsjG7eGD3JfXQughbhcr0ah88P41KqETacLpJAlBV0NhSj
	aO00Sdp81v1Am/DfH25wP52yhYGyHY8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s1E1RcXB;
	spf=pass (imf09.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C3D126057A;
	Wed,  4 Mar 2026 09:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966CCC19423;
	Wed,  4 Mar 2026 09:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772614807;
	bh=gifGbD6JMEv6L9NlQtyraekK4duLMCrGJ52WNb14fOM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=s1E1RcXBmTr/rW3gJAHmwNQJoKtvL+v8v747G71JRzSxTXgoW+GDONtMSk20kLetk
	 7AH8uwWvEQPoGjsuGXGXxWcXOWHpJm5wALSqafUS0AcBkFNVUntTME9KyZLJahOWJM
	 ULDgMDC3uttYxif/9Y0f6PPd0NUx1j62TETbLrUyNnmmuxNPeFNmfr08XSzk4uoA1O
	 ZLKMCrREaVbS2HHUc27Go0ipAJIb3xfm9rKw6yeCIv9KMcl8U8Eut+wPPrlWLx/UKT
	 wyc10bJs0N9jjVbBZvepuSWxI41FXgfj0U9sPrjijWQR4+aJiz5j+W8aNmt56x1hrs
	 o/3VOvOrQsDpA==
Message-ID: <e1eabcbf-40da-4899-9db6-828a7b697328@kernel.org>
Date: Wed, 4 Mar 2026 10:00:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 05/10] powerpc/64s: Move serialize_against_pte_lookup()
 to hash_pgtable.c
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1772013273.git.ritesh.list@gmail.com>
 <dd9b5abdcc56d935681f7f95fa018bd886d59ba0.1772013273.git.ritesh.list@gmail.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <dd9b5abdcc56d935681f7f95fa018bd886d59ba0.1772013273.git.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6FAD2140005
X-Stat-Signature: r6rp1qomq8mxci6jydcnhx5em3p1sxw7
X-Rspam-User: 
X-HE-Tag: 1772614808-260746
X-HE-Meta: U2FsdGVkX1+gS8D2B4+/RPLAHRCHKB8PXi/TsyPpGbiixgeEqwRDHO993FyCrHFaToTnplwKh9MkMwJezeO2hpAeCgve9b8bFgBkkySiYJsjzFR3r9LDi1oDwIjMkGVw+a3LX/uB0cL3PdHnsA2dG0GDj9GRPc3Z7aXtKRmCRs1/mifQDlFI42bNcu7ThJswBaScFGACUvzhrFWznT0kwAsYnuwXOZIBSCfdpJ+n/iUGsn2vJ9lkdtoRqUGnnKmSMrrwl6XKbWOIZVx/kQnOkPkLQ1IHJsN/CT/9RhqswTlBFjEQB7FsNG03Ef2wIhrQWxWUPNDiM790ZfIj3KZWT9LZKIGQJ6tDEo0wU5LLaBQS6I3QjNHARWdO62BdM204/0N7dcfRRyvKbRLNkcKZM/20L3e2ZxWlm7Ei0w3s/3nc9ThrJwESWOeArQ4yzrz3HljbCD762ORgWVkQ8aMN56jt+951FVent1NiQ1uPglDtwzosHpzGICZhC+y4zpAcBPsG9kHqJ9IEcoNUKx1hnMkqElrVCRVfIH3FRXa/QtbBM3liakP8iW8RrY5jI7+qDkcbqrfAyiZHMAP9VMksd4FsHRV7SPPqpXHSMrdAcPfauDGlntDaTRCxgTQgOZfAzpIxiHFul550oaXbfvKsAgDbyZMQcRIhJJLRAreQVfN7PjrxoZJRf/fmMTiewELbNXbp9YJU3pDCv+rW6CtVPD1BQA64F7MW9vn8OXBGc4h8DVF/D3IVuvrDBkQQZaf332GPsyHlHQ+1PRwtGqkY7BhjtTdbTKoxBAtIIkAuE5Bj+GSGiN4C4ru/DRkwFirMVoGs3ldD88W9IcsFV11JQ8lPCCMlnDIgXMF/tVKrFhPqvlI79Fb2rzyMKFu3CulUue1tomDeywqBS/s+ntaQHNUq6mM9FmTtCtL4gi6OBYHf7byUhtLHSGuKaEgtvZ/Qxq0wFnNM5DEBo43h0lZ
 hxEMQtcU
 2/PQLxCh02nFjWjmEKcbxUHHoef1bOhSIrrYYwi4ZugaKsCb1IgISMuDp187r/pEbzJsfm1heGMfm+N+QaCU1GWH1KuM52Cl9y3VIcaLKgaEyWSYHrsf/adIfukdRYonZg2+PNc/5OfQ+MUrZDuh6889YByHVRl7fDGbylZqkW6ixCfbUW9Qb9TCjVlUQ3oFUpOGX2iguYOcqtB2ZETI/EKQn1hDNedqJuvcCwNx38p5UC9Q83V87Jbw09YaMLq50/zCeD2YCD+XRWaLVTJk3y2FHXPwHxsHdaU56hDqD848iz+gSnri9UGLHJNa3EdL4SOKlszfluaLNUk6v5q0xF58QG2QQLspb22MVvjgazs/v5VwYOucEPzXFyY18M+I5aL3VBWl4z+vCc/tEmt5LVOVi/4qjs8mfH1yf1AJqAROHbxdcewKvTsvMSKgjhINzr4VO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 25/02/2026 à 12:04, Ritesh Harjani (IBM) a écrit :
> Originally,
> commit fa4531f753f1 ("powerpc/mm: Don't send IPI to all cpus on THP updates")
> introduced serialize_against_pte_lookup() call for both Radix and Hash.
> 
> However below commit fixed the race with Radix
> commit 70cbc3cc78a9 ("mm: gup: fix the fast GUP race against THP collapse")
> 
> And therefore following commit removed the
> serialize_against_pte_lookup() call from radix_pgtable.c
> commit bedf03416913
> ("powerpc/64s/radix: don't need to broadcast IPI for radix pmd collapse flush")
> 
> Now since serialize_against_pte_lookup() only gets called from
> hash__pmdp_collapse_flush(), thus move the related functions to
> hash_pgtable.c
> 
> Hence this patch:
> - moves serialize_against_pte_lookup() from radix_pgtable.c to hash_pgtable.c
> - removes the radix specific calls from do_serialize()
> - renames do_serialize() to do_nothing().
> 
> There should not be any functionality change in this patch.
> 
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

> ---
>   arch/powerpc/include/asm/book3s/64/pgtable.h |  1 -
>   arch/powerpc/mm/book3s64/hash_pgtable.c      | 21 ++++++++++++++++
>   arch/powerpc/mm/book3s64/pgtable.c           | 25 --------------------
>   3 files changed, 21 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
> index 1a91762b455d..ff264d930fe8 100644
> --- a/arch/powerpc/include/asm/book3s/64/pgtable.h
> +++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
> @@ -1400,7 +1400,6 @@ static inline bool arch_needs_pgtable_deposit(void)
>   		return false;
>   	return true;
>   }
> -extern void serialize_against_pte_lookup(struct mm_struct *mm);
>   
>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>   
> diff --git a/arch/powerpc/mm/book3s64/hash_pgtable.c b/arch/powerpc/mm/book3s64/hash_pgtable.c
> index ac2a24d15d2e..d9b5b751d7b7 100644
> --- a/arch/powerpc/mm/book3s64/hash_pgtable.c
> +++ b/arch/powerpc/mm/book3s64/hash_pgtable.c
> @@ -221,6 +221,27 @@ unsigned long hash__pmd_hugepage_update(struct mm_struct *mm, unsigned long addr
>   	return old;
>   }
>   
> +static void do_nothing(void *arg)
> +{
> +
> +}
> +
> +/*
> + * Serialize against __find_linux_pte() which does lock-less
> + * lookup in page tables with local interrupts disabled. For huge pages
> + * it casts pmd_t to pte_t. Since format of pte_t is different from
> + * pmd_t we want to prevent transit from pmd pointing to page table
> + * to pmd pointing to huge page (and back) while interrupts are disabled.
> + * We clear pmd to possibly replace it with page table pointer in
> + * different code paths. So make sure we wait for the parallel
> + * __find_linux_pte() to finish.
> + */
> +static void serialize_against_pte_lookup(struct mm_struct *mm)
> +{
> +	smp_mb();
> +	smp_call_function_many(mm_cpumask(mm), do_nothing, mm, 1);
> +}
> +
>   pmd_t hash__pmdp_collapse_flush(struct vm_area_struct *vma, unsigned long address,
>   			    pmd_t *pmdp)
>   {
> diff --git a/arch/powerpc/mm/book3s64/pgtable.c b/arch/powerpc/mm/book3s64/pgtable.c
> index 359092001670..84284dff650a 100644
> --- a/arch/powerpc/mm/book3s64/pgtable.c
> +++ b/arch/powerpc/mm/book3s64/pgtable.c
> @@ -150,31 +150,6 @@ void set_pud_at(struct mm_struct *mm, unsigned long addr,
>   	return set_pte_at_unchecked(mm, addr, pudp_ptep(pudp), pud_pte(pud));
>   }
>   
> -static void do_serialize(void *arg)
> -{
> -	/* We've taken the IPI, so try to trim the mask while here */
> -	if (radix_enabled()) {
> -		struct mm_struct *mm = arg;
> -		exit_lazy_flush_tlb(mm, false);
> -	}
> -}
> -
> -/*
> - * Serialize against __find_linux_pte() which does lock-less
> - * lookup in page tables with local interrupts disabled. For huge pages
> - * it casts pmd_t to pte_t. Since format of pte_t is different from
> - * pmd_t we want to prevent transit from pmd pointing to page table
> - * to pmd pointing to huge page (and back) while interrupts are disabled.
> - * We clear pmd to possibly replace it with page table pointer in
> - * different code paths. So make sure we wait for the parallel
> - * __find_linux_pte() to finish.
> - */
> -void serialize_against_pte_lookup(struct mm_struct *mm)
> -{
> -	smp_mb();
> -	smp_call_function_many(mm_cpumask(mm), do_serialize, mm, 1);
> -}
> -
>   /*
>    * We use this to invalidate a pmdp entry before switching from a
>    * hugepte to regular pmd entry.



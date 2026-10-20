Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4698C60A2604
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 10:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=atEks0sw
Received: by kanga.kvack.org (Postfix)
	id 35C9F6B0152; Tue, 20 Oct 2026 06:11:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30D966B0153; Tue, 20 Oct 2026 06:11:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 222E36B0154; Tue, 20 Oct 2026 06:11:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EDB086B0152
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 06:11:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6B0CB1A006F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:11:18 +0000 (UTC)
X-FDA: 85342587036.19.35734B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id B72A5160003
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:11:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=atEks0sw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792491076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UXWZ7sEhNUwUZK56UTebBPaHPaOPjNo4jUMgFuCuhHM=;
	b=TfEjdCwDP6M3+YAQ2Bp8U6l/xp4YIj1WtsLAh1W44pcblEAFp08EvrpGO+wA/KZfpLHq10
	i+S0Fxwd9F9RdahkIk3Jn2+dmK4IMCf1IP2tYnLCqOWAVQNexgbkgJTU3Y0fR//yUvVObU
	GpXff3wEt2NwIQMqTAarlKNgwsI5dG8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=atEks0sw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792491076;
	b=W8o7QGxEijryt+aC2IPbDkcAqd4SRIib4Dd4OxdLG1kMdbQJe48AoM/DfjncqPfvDdMbk8
	ooWCmJHkkMxDjbqWB8Sw5oUeg72eZwvSxHDCCK+nqEziBVKYf2NUhyUMq1mJm1QlWVFhE/
	6zju8o+TVWD6XsiOdjk3tnZZ1L3+X2g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E69EF4195A;
	Tue, 20 Oct 2026 10:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D131F000C5;
	Tue, 20 Oct 2026 10:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792491075;
	bh=UXWZ7sEhNUwUZK56UTebBPaHPaOPjNo4jUMgFuCuhHM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=atEks0sw233tV9WrSZ1An/64slEa4IYaTtsXzU0njX5GdPsbEsdRj/BTYZT8yEPpf
	 5woYJdrsvZYVgJKYQkIY3Occ46yi1VBTXQJmIv13UYexi1B/3XFi3XrBRaCftte7Kb
	 krCcz0amLp1lA+z6CaI8/4DmLsUK73JkZ9H16/BhmXWjOQ5Wtz5ynTDAOrxFriMw1J
	 yHgYWUFgczmB8aPYNmhevH53Vaj9HZjk5IJmFNhcBLNRfTwO0PRDXiGxUk3TmvoclV
	 4bqCYkvis8Y/EF/zNMGBh1Gd0U4F/cP5f/xiBNMXEoHDrocKaE6xcDLG4xeYQ01tGD
	 kmJXQhBvI+WVA==
Date: Tue, 20 Oct 2026 13:11:09 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
	akpm@linux-foundation.org, peterx@redhat.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/3] mm/hugetlb: disable PMD sharing for UFFD missing
 mode
Message-ID: <atc-PW2PirXZzNZh@kernel.org>
References: <20261019113034.97690-1-lizhe.67@bytedance.com>
 <20261019113034.97690-3-lizhe.67@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019113034.97690-3-lizhe.67@bytedance.com>
X-Rspamd-Queue-Id: B72A5160003
X-Stat-Signature: mpmk7thbu4dck7hed1zrj6eem5rdzgkx
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792491076-39716
X-HE-Meta: U2FsdGVkX1/woYG0yUF3mrnHol4eawghnKSowp7LcZUxy4m2cgSC49WDvCDg2/JwxAZFQPU2GtGkrjY/8LbSihedSNry5jrRcjRk/XNMSvWY2OU9MXZ63W9+ocmj88u1pKyBON4/lDUPfTFVKhttY9N1dHXRaNpzHYHus+beh8/5lLIv1ie7T9opR/zNeKezBq/Te/qDqAIWsyvrZ15V3fyqWYsBPuQFvxQ32It7CHBASav2Xr3Cro8TzDls7Xj/cDcUw3ZNjTdX3ZypC0DMfiFUeDhsTVq/7kJgyXZW9jxSxgR+AyZa+6dFUMHYVsnh9p1DfJWxdYHC7miyx4GBYFQBlOeerM4Nf46B2DEc+Cf5ZtJmVp4QK6iJv31X5HrdqmiIIali2UKIwhbOgnkAdT9zqD1mljP0tCDhY3Pr0LWw3x5t3L9r6UCLdgKR2p8kGsCWps7UIBtjqRf1+DfgQHm0Fq7uyC0MJLEPIJhFjMcTnhi28ydosM10L+cKLqUE64DFLzXr2QW/+FKqjb1iSzWpg86E0pHXrCNimAE0+Rydda6awFLwVNid4S/qhQAsgYBxR2pwRk6nJovrA0jlM/mKCBtozpgtekfeYw2mg0Qm2kKKaKtfHX5oYUWbrYoA1I6ooEa1Ynt9QwALhkS1qbURk4UsoWzixvM2x+ONOsxBABeNpYZ/+HFFxTbK/Z1bw3bpJXM/KB/YmKmUfhkL6XZ8DW+0pvP4kME0Zie+wgsmthlxgyWkytcFS8zdVNe3VdtWrIReKvzzyN2oNtOfnfrUYLlAHaZKqF+E3B8KPzWDafmhABfJa9llbO/NcZVd2C6xogMaZpY+TgcKqdTIKOKN55foAj/LW9o5ShsshtRNHtkVAn/13H6nD8gSqxebgWMuq8zohtVE6hgnFnC5tjCmuLdQtaMxjuZdWLt/T8UmmXfbT7JNVA83jfpKYMLuy75ZDGbma2Jky7j1JrC
 la+Ohij0
 CliYj2YTrOMxFVCaILdp/O3RiRli+3oQsFDokLHqiQeP/FOyzNYj+H1BoNdwBvODeHvz5/zrd/xCXD3WMXaDTKu4Syqfdu6uzHacC9pB0poYstIq+TMpTJstKpyNf5a1zPHYfcBRrO3NwfwpErBmAn14QDst+5J6yKxCxDFI5BqSD3tAHyFCPRMNleSlUg3bkBYwzFA5UhgTFFyAq2NDjmwwa0z7C1hJBxPMBN0A2J1q/zQ2fZ+eT6v9KBCKyDYLy0Uk2MIPrSyJxBDP0vqLiLnN10eZHU3VDinpRdeZPbi64Jmk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 07:30:33PM +0800, Li Zhe wrote:
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> 
> For UFFDIO_POISON to install a poison marker in a hugetlb mapping, it is
> sufficient to have the VMA registered for missing mode.
> 
> However, UFFD missing mode does currently not block PMD table sharing, so
> installing the marker will be visible to everyone using the shared PMD
> table, which is wrong as UFFDIO_POISON must stay local to the process.
> 
> To fix it, include VM_UFFD_MISSING in uffd_disable_huge_pmd_share(). Add
> a debug check on the marker installation path.
> 
> The existing registration path will then unshare PMD tables, and
> subsequent faults will not share them while the mapping remains
> registered.
> 
> The alternative would be to unshare PMD tables selectively when
> installing poison markers, which results in way more complexity. Or
> alternatively, simply failing the marker installation, which might break
> some use cases.
> 
> This effectively disables PMD sharing for missing-mode registrations
> that never use UFFDIO_POISON.
> 
> Suggested-by: Li Zhe <lizhe.67@bytedance.com>
> Fixes: 8a13897fb0da ("mm: userfaultfd: support UFFDIO_POISON for hugetlbfs")
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  include/linux/userfaultfd_k.h | 13 +++++++++----
>  mm/hugetlb.c                  |  1 +
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index a4351cffc60c..fe78ba14dc68 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -169,7 +169,10 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
>  }
>  
>  /*
> - * Never enable huge pmd sharing on some uffd registered vmas:
> + * Never enable huge pmd sharing on the following VMAs:
> + *
> + * - VM_UFFD_MISSING VMAs, because UFFDIO_POISON may install markers and we
> + *   want PMD tables to be unshared when installing these markers already.
>   *
>   * - VM_UFFD_WP and VM_UFFD_RWP VMAs, because the write protect / access
>   *   tracking information is per pgtable entry.
> @@ -182,9 +185,11 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
>   */
>  static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
>  {
> -	return vma_test_any_mask(vma,
> -		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_RWP,
> -					VMA_UFFD_MINOR));
> +	const vma_flags_t uffd_flags =
> +		mk_vma_flags_from_masks(VMA_UFFD_MISSING, VMA_UFFD_WP,
> +					VMA_UFFD_RWP, VMA_UFFD_MINOR);

Since this essentially disable pmd sharing for any uffd mode, maybe replace
the flags check with the check for non-NULL userfaultfd_ctx?

> +
> +	return vma_test_any_mask(vma, uffd_flags);
>  }
>  
>  /*
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 2c64ca985dfa..fdd65e019a55 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6304,6 +6304,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
>  			return -EEXIST;
>  		}
>  
> +		VM_WARN_ON_ONCE(size == PMD_SIZE && hugetlb_pmd_shared(dst_pte));
>  		_dst_pte = make_pte_marker(PTE_MARKER_POISONED);
>  		set_huge_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte, size);
>  
> -- 
> 2.20.1

-- 
Sincerely yours,
Mike.


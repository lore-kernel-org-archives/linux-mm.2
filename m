Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5860C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 17:57:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 964336B00C0; Mon,  6 Jul 2026 13:57:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93B6E6B00C2; Mon,  6 Jul 2026 13:57:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 852106B00C4; Mon,  6 Jul 2026 13:57:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FB9F6B00C0
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:57:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D59FC85C9F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:57:26 +0000 (UTC)
X-FDA: 84959108892.28.58A28E2
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id E0A0E80002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:57:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QJG9yFRw;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783360644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jv8C3xh2TimBAFGoLe0GkKPySiDXFlD5GFpnQOyEgnw=;
	b=EVE8YSS4HZMl7ZxnQFjSvNDgr9Cd4u5rHaHExQ+4vt7kjoRd4TN83RcUrlyTc95KJWsim2
	2GYxP0EU63TGn1Svb55fDuQXYFD/WOxHvPUGaaiPA4JFvn7ekURUrPQauu//CRZS+37sFe
	4HFujtCQewG9MneLcZgYzfVEVr1EYQc=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QJG9yFRw;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783360644;
	b=RLrKV9KXBGjqNi2pGvCSBuT/snu/RnqE6RNP2xKYqHpnsh/wt5y5rT3uygdauTbFnN+7ws
	WYSbAWAYmzC0j2khlLsUwFNGdMycfuiwSUKk8DtJJt1R4tUQU5ojLCDaCe0wWaiAlTrmrG
	/zEUbKLChrKmDtyaHiNnsOa67gSKXzQ=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c126eb4e003so354429466b.0
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 10:57:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783360643; cv=none;
        d=google.com; s=arc-20260327;
        b=emPIOZ5NB68OFa+6dqup7YHERpKhBK+ZNrqBKuarnUjS4ttxmBtUhXneuXsLVp+Ru1
         s7HB2kdumdoGN8PPYkh+WrQJbgvvGZjiMBT15+d5Yx8IYBK+qJZixnraWbn8/yDeQiyR
         0R2W0mhqZNswBUmdfLuaZY+E27SukoChFgXODTItwbKw/BgXqkcJnU+lzW42pcZeG5F7
         3F6ouCkshzUWAR6aeilb949M34dpY2hujjaAfB1HSIkNSbado9xDBTP1PwtaB60Ypk54
         2DGRw83Zq0q8ko+lGDaeJUoW+TjPYdkjtbG4IocS47cyw8fkPDDiLTQbrEaryR82tRih
         HGKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Jv8C3xh2TimBAFGoLe0GkKPySiDXFlD5GFpnQOyEgnw=;
        fh=A1zYX8GmlVrUTdtpShwF8KHNWKp+mjjtAVBVECz7OaU=;
        b=i5LZnLB4/l2IfUwhIbUdTVFZRPtMSphhD2R45Ac9u7txQQ/bby8LnRDnqJgMUGYxn1
         dnEFU+Dj/ukF9fG6RudrnJBIcCTe7wrBoM1KiqjV2HnRtTGGsbKCW4gPflTYHCRvT4Bt
         J13T8+rVaV9Hte/A18D1gu1xS4X04/6ZIcNoF/D3VPT0CVSZ0ZNSlhlDN31R5NMyVp5Q
         lWgtDRPzwCNRxp+T09pdE8MdvtKoOplmEMPXcg8KEat20RoAp/aYVWMGc1bjNvnl3wdE
         kjG6ymdfjFdmqOWSS/Fr7/8jP70jVQpFttDJH/V2w6835viDxyzYuNmvT1wPwDeL5ByV
         sdNg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783360643; x=1783965443; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jv8C3xh2TimBAFGoLe0GkKPySiDXFlD5GFpnQOyEgnw=;
        b=QJG9yFRwInmiB03VTbgGG5iedNEzZcdEgzCw6AxagsTEIwefZ6YwIqMlGGEH6Y5gWj
         YFflI+AjqShEegF64fODLb5SMVGwqKG8I7aD2MNo6T4WENF2q34zH4t5Q5WNEb5w8ri5
         TigX3oBkT9UtVwLF0ZV8on3wJjBBddFkdHy+swA0kpUdDxrl9q+Nz4vl68NbqObMTAQZ
         gm9Dwf1CZPjmtyZVQKI4tj9gomc+GCtqxR7ZADSewpt5fzwE2oaIcOa6O3sR3HjfBMmc
         1/0MjfL9Ymo4n3XCnGViLqYtBM7piUrVKBD/mMsrE+QNh++QaD4RfGCXK20CaJNK1WLE
         Y3Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783360643; x=1783965443;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Jv8C3xh2TimBAFGoLe0GkKPySiDXFlD5GFpnQOyEgnw=;
        b=nVYb6ABq9I6gdEvz4mzLLZOGtcWG1YTPiCG+wDPEDNMVN0ply+27pBzJbm3lM39eZg
         tx4yQ5X4hZNcNHXNPU9DJQ45OJTdpqq6HsUTPdFzuymx/8tl6QhqOPthnxKb1oxSy5AU
         6fOwL1qSs94sVxnXIQXMdIHY+k8/CedzldqmDrOI7HYt7Ka4/FHKW/3NzN8MZLqU5Kxg
         ZK8b6L2AeOtK3fEdf3W3yLGpLbCyGBt1c9qKkggQ3IHWRviUik5TqrmXff9A+fKxAj9k
         jC3szZaPC0uYsqigu8cjmQy4RZbiJ3ofzkuihnmwwXjMUTeyS71+8BaAOKY82W8Sw5z2
         YEzw==
X-Forwarded-Encrypted: i=1; AHgh+Rp0Ff5Y/hcrOZAFPGYXyIApRxpkPKN9J3r/DQyPFjdA4hBsy5k+EUViZXK/H6WHBcNf6D6xiktM4g==@kvack.org
X-Gm-Message-State: AOJu0YxV9HoN913lqWG7CY6vEplvHPdW4mQCUxqoeHLvBWRIpWWEUiqa
	W1jaS0dkaG+hcKvJqTTrOMtb9WOgqeB34ZcoZVLve6lmr4FNnHA9/PhdPRlD09JGGScXYcyAz8C
	w7i05fAnAAc0ZnGFPGU14Am1NN3q/1u0=
X-Gm-Gg: AfdE7ck353Sx8rz4kkg0MnIpKBsM3gAlHyNq9c4yrqurHH1eu7wd5QtoB373N0AY4lZ
	oN67YWGEzpvioTOnG/WGHUjH7L10BoR2uldXFdqqFSNDIjOpAESmVm9ucIqT8uLj74mtQduBLYF
	XbRX5tf1TJ/iwOUCJ+H2rAkfEFnWx+DkUUUtbTcB0zqKTFzBavnpq27oyDEd9QpIDGpF8k3+WwL
	Z5s23pBku0iVmGmcfCG2oQoJdfOoJ3DTWzR9qrBbyr9/2G4u8R10Yyn16PTb/yADnuSFI+Skji2
	f3IstOeFD3o3qiwrohaLjaupQuOdLQ==
X-Received: by 2002:a17:907:787:b0:c11:f5dc:22b with SMTP id
 a640c23a62f3a-c15a67988edmr100470966b.14.1783360643347; Mon, 06 Jul 2026
 10:57:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260703173903.3789516-1-usama.arif@linux.dev> <20260703173903.3789516-10-usama.arif@linux.dev>
In-Reply-To: <20260703173903.3789516-10-usama.arif@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 7 Jul 2026 01:56:45 +0800
X-Gm-Features: AVVi8Cd3mvIh2dZJrjG5eUoeG4qlYlk-KbyuIhshYNkrMrE3ly8p22XlCO02W88
Message-ID: <CAMgjq7CQ+1gsptFYH+Y0GEqyYj+5QpAKjtZLekRS4h+k4f8QvQ@mail.gmail.com>
Subject: Re: [PATCH v3 09/11] mm: handle PMD swap entry faults on swap-in
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, chrisl@kernel.org, 
	ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org, 
	ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>, willy@infradead.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, 
	shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org, 
	dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, 
	Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	nphamcs@gmail.com, shikemeng@huaweicloud.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E0A0E80002
X-Stat-Signature: z9ezohrbsjsgidm8xbgzpthyu9s6g4ep
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783360644-855827
X-HE-Meta: U2FsdGVkX197t2M7bsE2U2d8N/mvA+QPmqpRmZsMRF/OTwLpz5OMSJtWaj8SYhHaTID3i3nOG8MNnSsYDT8MmAtWiZEVeQNBVsCSGa021sXhSonVZPvpNHPJreym/DOtrh3gL/m9sqlpYmAzR05vdXRPtrQFhXZpjYYmW7xKsCHabJQuMlMbjXmXcwomlYA5HnxSWURHtNPMfJfnEl/8t/qxzFVpfasVLj6iRbfMjRBNUiSf8u6qti7jxeil0wdcIgCvtIMHnP/nOKk0u9+WVLiHC/yRo4Ap9dvT1FSEIyc40Hjiycst3mTFotNlhTaJqXxVvMHwIr2d3b9D4cAKl8lOG42m07fV1G99Ay5yuhZaGgzXUe2puW/R7pbbqfNAKQ1B+viIYM1Tu2dkAdZmZxgS13H+nzoStU3FESHb99Pr/HW95B/eN/KT7b8PudtbbxRKXx+hF4Tn+Gt8DoK7re9t3FMdNshsfmQ+aT0PSQs13xK5ZLR73y9skFctwjCgg0fuJlJeJg7u4Z8fPDxyW4Vvyg3snvgLzTai7z/OZW5KfAOVCosKbGUrRvKy3f5DJIxYLSyb2RugPaKELDwY99iVdkSBNHzO6rYjJ6s89W50tG84o2RM9++7DxDwMwmnm7YB4hH3F/vvCGkh5+3++wvPSMsf4Y6cvJhe/WDUh1oxHBX4+hyGwo585ALahPTnewCtKLe0DGL1EZ7uQj3VtipQQNVDSSXf3W0W3tCnL9xzZ3ZkVUNjoJvvePKZS+VK30ms9cA4Fnaah+SNT+xIjW7Ule6I4PwjRwARKXTDJhD3ZgkLT9C+eARZR2nuulkKFkAodEw4RMMdYIhE967hf77mvQ1b1+wgCSdjnR7F28tz+t/je8rPQ0VGduZUyEBnkd8oLpuspm/d3AM4Flwk3CwyUmSHOUl49hA1y0k4zv/gB6RjAWDPXLpP+HnD+2sUpG6+cfoPPMNPCNJgjp4
 S40dDuj5
 7r+mU9Tw+f1Ak0hXWxMSsFYjSjdSwmLKsltiwUj6oS21mFIMQjsLQqSHa+dXyCi7iTulnrUOqrnO1kN3npuY+Pj8Ux9dq4iodtM+eHpqUzz16gRHXvban8xsif0plSlQC9Jnfly9aPpONP1HClTnBKwcgiB1473gEN5nZZesLEygAKm15rA8zZJT4ejCekgdd8//JHLzLamj+3cO9zqbIoueIUD/31PDu9c/MhPHhXGxzP78nKRSROhY0Bu86MKH8xS+YtEvOwCh8VlahAAbqTru71CzXfYaRt3vXd8NihYN/kS0p6XDjfvtvElll0TPKrKa2vuaM3s6tPkjU++IfxHSDy5mlRyZDuvo+iHf8K1heDsh15r6OURK/Kd2GBKDZ3y9FuUwOOD1LJ4KLwRrhrMGX6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 4, 2026 at 1:41=E2=80=AFAM Usama Arif <usama.arif@linux.dev> wr=
ote:
>
> Add do_huge_pmd_swap_page() and dispatch to it from __handle_mm_fault()
> when vmf->orig_pmd encodes a swap entry.  The handler resolves the
> entire 2 MB mapping in one shot, mirroring do_swap_page() (PTE path)
> at PMD granularity:
>
>   - Look up the folio in the swap cache; on a miss, allocate a
>     PMD-order folio via swap_cache_alloc_folio() and read from swap.
>
>   - After locking, re-validate that the folio still corresponds to our
>     entry and is still PMD-sized.  Between the unlocked cache lookup
>     and the lock, a racing swap-in on the same entry may have removed
>     it from the cache via folio_free_swap(), or reclaim / memory_failure
>     / deferred-split may have split the folio into smaller folios.
>
>   - Restore soft_dirty and uffd_wp from the swap PMD.  Map writable
>     only when the entry was exclusive, the VMA permits writes, and
>     uffd-wp is not armed.  Drop the exclusive marker when the cached
>     folio is under writeback to an SWP_STABLE_WRITES backend (zram,
>     encrypted) so the PMD is mapped read-only; a later write COWs
>     into a fresh folio rather than corrupting the in-flight writeback.
>     Mirrors do_swap_page().
>
>   - When the resulting PMD is read-only but the fault was a write,
>     update vmf->orig_pmd and call wp_huge_pmd() in the same handler
>     to COW immediately rather than forcing a second fault.  Mask
>     VM_FAULT_FALLBACK from its return: a PMD-COW that splits to
>     PTE-level is normal, but the bit is part of VM_FAULT_ERROR and
>     arch fault handlers BUG() on it without SIGBUS/HWPOISON/SIGSEGV.
>     Requires exposing wp_huge_pmd() via mm/internal.h.
>
>   - Free the swap slot via should_try_to_free_swap() (hoisted from
>     mm/memory.c into mm/internal.h so PTE- and PMD-level swap-in
>     share the heuristic).
>
> When PMD-order resources are unavailable (folio allocation fails,
> the cached folio was split, memcg charge fails, or swapin_folio()
> races) split the PMD swap entry into 512 PTE swap entries via
> __split_huge_pmd() and return 0.  The fault retries and do_swap_page()
> takes over per-PTE.  This avoids returning VM_FAULT_OOM for transient
> PMD-order allocation failures.
>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Hello Usama

Amazing work.

> ---
>  include/linux/huge_mm.h |   9 ++
>  mm/huge_memory.c        | 216 ++++++++++++++++++++++++++++++++++++++++
>  mm/internal.h           |  36 +++++++
>  mm/memory.c             |  40 +-------
>  4 files changed, 265 insertions(+), 36 deletions(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 1487bf4af1a7..9ec475ccfc91 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -531,6 +531,15 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vm=
f);
>
>  vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf);
>
> +#ifdef CONFIG_THP_SWAP
> +vm_fault_t do_huge_pmd_swap_page(struct vm_fault *vmf);
> +#else
> +static inline vm_fault_t do_huge_pmd_swap_page(struct vm_fault *vmf)
> +{
> +       return 0;
> +}
> +#endif
> +
>  extern struct folio *huge_zero_folio;
>  extern unsigned long huge_zero_pfn;
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index fdc1a503c609..5fa60324a2f0 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -41,6 +41,7 @@
>  #include <linux/pgalloc.h>
>  #include <linux/pgalloc_tag.h>
>  #include <linux/pagewalk.h>
> +#include <linux/zswap.h>
>
>  #include <asm/tlb.h>
>  #include "internal.h"
> @@ -2312,6 +2313,221 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault =
*vmf)
>         return 0;
>  }
>
> +#ifdef CONFIG_THP_SWAP
> +/**
> + * do_huge_pmd_swap_page() - Handle a fault on a PMD-level swap entry.
> + * @vmf: Fault context. vmf->orig_pmd contains the swap PMD.
> + *
> + * A PMD swap entry is a compact encoding for HPAGE_PMD_NR consecutive s=
wap
> + * slots. If the swap cache still has one PMD-sized folio covering the r=
ange,
> + * map it directly at PMD level. If the range has been split into per-pa=
ge
> + * cache state, or zswap may have per-page state for it, split the PMD s=
wap
> + * entry and retry at PTE granularity.
> + *
> + * Return: VM_FAULT_* flags.
> + */
> +vm_fault_t do_huge_pmd_swap_page(struct vm_fault *vmf)
> +{
> +       struct vm_area_struct *vma =3D vmf->vma;
> +       struct mm_struct *mm =3D vma->vm_mm;
> +       struct folio *folio;
> +       struct page *page;
> +       struct swap_info_struct *si;
> +       unsigned long haddr =3D vmf->address & HPAGE_PMD_MASK;
> +       softleaf_t entry;
> +       swp_entry_t swp_entry;
> +       pmd_t pmd;
> +       vm_fault_t ret =3D 0;
> +       bool exclusive;
> +       rmap_t rmap_flags =3D RMAP_NONE;
> +       enum swap_pmd_cache cache_state;
> +
> +       entry =3D softleaf_from_pmd(vmf->orig_pmd);
> +       if (unlikely(!softleaf_is_swap(entry)))
> +               return 0;
> +
> +       swp_entry =3D entry;
> +
> +       /* Prevent swapoff from happening to us. */
> +       si =3D get_swap_device(swp_entry);
> +       if (unlikely(!si))
> +               return 0;
> +
> +       cache_state =3D swap_pmd_cache_lookup(swp_entry, &folio);
> +       if (cache_state =3D=3D SWAP_PMD_CACHE_SPLIT)
> +               goto split_fallback;
> +       if (!folio) {
> +               /*
> +                * PMD swap entries encode ordinary per-page swap slots. =
If any
> +                * slot is in zswap, split and let the PTE swap path load=
 the
> +                * range per page. Otherwise the range is all on disk and=
 can be
> +                * read back as one PMD-sized folio.
> +                */
> +               if (zswap_range_has_entry(swp_entry, HPAGE_PMD_NR))
> +                       goto split_fallback;
> +
> +               folio =3D swapin_sync(swp_entry, GFP_HIGHUSER_MOVABLE,
> +                                   BIT(HPAGE_PMD_ORDER), vmf, NULL, 0);

Hmm, so here we always do a sync swapin which means there is no
readahead, kind of make sense since PMD is huge, readahead might be
not helpful and a order 0 readahead breaks following PMD. But maybe
worth mention it in the commit message at least so it's easiler to
follow. (partly because the name swapin_sync is a bit confusing at the
moment, we could change that name as we improve swap readahead later).

And just an idea that will it be suffient if we just use the return
value of swapin_sync directly? If a smaller folio covers the PMD start
entry, the smaller folio is returned and you catched that just fine.
If a smaller folio covers a follow-up sub-entry or a sub-entry is
freed, -EBUSY is returned here and you just do the split. And it
doesn't do the allocation for the first lookup check, so there should
be no thrashing issue.

> +               if (IS_ERR_OR_NULL(folio))
> +                       goto split_fallback;
> +
> +               /* Had to read from swap area: Major fault */
> +               ret =3D VM_FAULT_MAJOR;
> +               count_vm_event(PGMAJFAULT);
> +               count_memcg_event_mm(mm, PGMAJFAULT);
> +       }
> +
> +       ret |=3D folio_lock_or_retry(folio, vmf);

With PMD sized folio on a slower device, this try lock could fail much
more frequently, leading to repeated faults. That's not a new issue
and I remember Barry talked about it at the LSFMM this year, just I'm
not sure if that will get much worse for PMD?


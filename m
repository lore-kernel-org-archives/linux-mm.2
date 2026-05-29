Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADC52CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 19:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD8696B00AD; Fri, 29 May 2026 15:22:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C61DD6B00AE; Fri, 29 May 2026 15:22:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B02CA6B00AF; Fri, 29 May 2026 15:22:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 99AEC6B00AD
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:22:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 46F471C10A3
	for <linux-mm@kvack.org>; Fri, 29 May 2026 19:22:32 +0000 (UTC)
X-FDA: 84821428944.09.64DF3BF
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf31.hostedemail.com (Postfix) with ESMTP id 326AA2000F
	for <linux-mm@kvack.org>; Fri, 29 May 2026 19:22:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oYfVDMeS;
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780082550; a=rsa-sha256;
	cv=pass;
	b=MqgH63IS+9SbLNCE7N7UyQK7mZ4Wo5784oOfVvL5a57oZon1xMl3U/vhxLJgVsl46oiWda
	eRf1ThPySNwyNwxXDt0KtWoogZ28EBGglS8ozb6yd9LqEA74xu4Xr+f9yf7VWVdHRBxff1
	uy9b07ud+p6VTQV+pkJTTmY8sk9N6eg=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oYfVDMeS;
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780082550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/6XCh02b00Qi+J9V1RsLv+n1OUX7vNSIf/jjmHUvXP8=;
	b=ZRhdpJFQ16lCmPQYERAUfj+WeBCfxltGXSM4X6rk1ioHpppaf1/R0s8XFd4j6i3ZtJsjyC
	vATsERf2wyEy1kQzz0NgvU8JYCSuz6c1yu8bnB75hG3MfiPTKm/0hrYUoNDKxRwRuagR/L
	hfOrDElzQiSvEhrP4CjDxb/LukDDdMA=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-45ef56d9b67so486532f8f.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 12:22:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780082549; cv=none;
        d=google.com; s=arc-20240605;
        b=KB0xco8tZK8cR4D492sNj20NzEhXQ7GuYkR9OS90evFyNnRRtFuxApANK7HvR3mj/g
         i/ybcoDrVc0itWOEqM3iHC9JH9ut3YLl/SCwP2VpukOTPC31y2nwA4GTGXL0wCUr6KkG
         PoaABKQj/NK2C/9pYyMGeG7A15ikY5ADqqqSc7Q+6G0ix1vrEdqnffWT4I2ez+GhwJd4
         xfk70O3m7UwltHTBy3xp8DDH8+3UQOuhCy8zfDG9AVmJTr0elYC8ngTArvKjMi7uVP9s
         EGuDlcJre4ufzPvBEVggOVi//zRsEhFCYUoyYVHVPHGOSTZ30SdrA2CVWh8gD3hKcgwv
         KZJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/6XCh02b00Qi+J9V1RsLv+n1OUX7vNSIf/jjmHUvXP8=;
        fh=nMeHfs1qOHPXc5rvJ7woWVyHqKFzYK9Zat5+113cUDU=;
        b=Mu4zTZDAAVGjdJuILTmnmhVfd8mWOe53atmv8hYh+XLa7UWxgPSGFNEHIdWMRvFH8M
         Eyifiv1VSOYJyiFuS7qix17eq/E8F9i0C9Nhtl+Y67J5oMlYjHSKS9g/hE7+JO/41ks6
         JBl3Xz/g7QpOnt2diyjNbEpfAxfO6F/xBp3UzElZ+Xbp2SFvoRorh0+QmVDrjWjqcQLx
         8VHHru6DtCeT0z3CJXFVWoKayg15rHUvo+23LVNFZpixMKprjQ2cFpvbthFfDuqnDDSv
         Kix+C/nhlZHvH1mPC57SrYT00W2Zumw/AIZDdrXIpura+GZ3k9u2ykgeFofT04OnIxzG
         wDTw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780082549; x=1780687349; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/6XCh02b00Qi+J9V1RsLv+n1OUX7vNSIf/jjmHUvXP8=;
        b=oYfVDMeSe5YLAMFyDvw7W3JObvC84zEmO1+Z2EsxfWXT5AtljF/NEiSDCk2Rft+5M2
         lcfimQhcp1DCxnj+3RHf+q2BF+KrFYiVT+ExayvQjVPzEbkW1rGGQQAhCsG8Nznv534O
         eNQHDiCJrTdVVPMkwXB2jfCwZJ6kAgtBsiKRulZpmsxWJ4MfC6odEYtsThiHIX0kdCE4
         omXmDn9rXYpKG4OV0sJUx3EKgKHAUi+SK1QX6jUtc6dwVmaLo2sOlLH8WYeuTOyjv+25
         QmUK4LuxuBtd9VVKVqPkNaF/vb+pCS8I9aZ/+H8n8QbNoevF34yJvwSxnL9mAE3H42AW
         irpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780082549; x=1780687349;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/6XCh02b00Qi+J9V1RsLv+n1OUX7vNSIf/jjmHUvXP8=;
        b=FMC0h1pAv+2NJ6HVPy1Tg9/vOVrcdciy8m6mZHq63AUdirqq2h5XAIYuapCr+tyeOd
         39OGKViRaZPBL4noEuSQRpNaj4YoD4xKHZVLf/gARDdDziEtByoeeNk6Z6U3PLTk9Prf
         2kodjTsNW1OsFsWdcMEGnBFRdCS08/GeokF7lK1MIwqKaX+MKqh74uo1AOgdfRGu+sTv
         0DxSCCLrQN13dn1XxoMp5yumflIy7lpeBGEOUpox8TQJzjeIaH3/lhHhDmPiz9UQdjMp
         QxMk7EKp8Gjh60AyFPQJPiowW/wEWk5eeDMRxe6kDR7UMVBXtbG6MbJBC+qLjuAcKCFn
         fVtQ==
X-Forwarded-Encrypted: i=1; AFNElJ/vqXgak/6PzzvAqe4usE+wy6+OdXciPBpgYBLLOevrcQdFjt0qtt2JT6mlA7OWXeBaFftqeAbW7g==@kvack.org
X-Gm-Message-State: AOJu0YxDQ4/3tqKtYQ9/46KlHs16RmF2QVmwWQTS6MIA8osM+7mSLY4n
	rIpyobOfV/Rw7/pVFJ9USCAaU7T7M+2e97JZ+Ry6MwUfqTF1KT767DC8R4l1LPJrwARQvwlyvLI
	8YHfWRl346QYdhaE64oM1ZVZR4or67wY=
X-Gm-Gg: Acq92OGAEukfcec75EuvnRn6wp+xM4Zs1wvNcDCjr6mvRGf9VTGdjScluDb02wXb6mQ
	wlCJGrL9Y1pkAj7jfif8/34bBVrQ13J5xukhUN7/IJX6SZrnNcCpsY4OWiWmX35bjHJpfgFGyNc
	SMZBDlFj3EEj7WCkFt7o1T+aQDkpTmzJI29DCjkafN2V7oqZuaxXdRgmHCG0jyemA76X2X6OLrj
	XCTBjcsihOxmYgsIYkJqflsoUM2X+vgvSXjkV0hkE06UEOY5W1RdbXb/rCcJZkH7K0iKeFO2wT3
	6iVNFC5xd2oE7eqLlYohmWlF8vVqXFKZNZqlalB2XZ4+BwlN9w==
X-Received: by 2002:a5d:58f6:0:b0:45e:e50e:3bc with SMTP id
 ffacd0b85a97d-45ef6b71573mr1443359f8f.29.1780082548503; Fri, 29 May 2026
 12:22:28 -0700 (PDT)
MIME-Version: 1.0
References: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com> <tencent_913470853E9B289ECF0379248E24DFB4590A@qq.com>
In-Reply-To: <tencent_913470853E9B289ECF0379248E24DFB4590A@qq.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 29 May 2026 12:22:17 -0700
X-Gm-Features: AVHnY4L80PLx_iDOZ80xwVOsu9v7r1-5cHH_ebtBp8oo663yjgvDU9xhef7hoAI
Message-ID: <CAKEwX=MDSwMoU-=h3NOG==-ru+qT3LeTi2_PADLWFXBB9aZZ+w@mail.gmail.com>
Subject: Re: [RFC PATCH v2 6/9] mm: provide anon locality evidence for zswap
 large swapin
To: fujunjie <fujunjie1@qq.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Alexandre Ghiti <alexghiti@meta.com>, Kairui Song <kasong@tencent.com>, 
	Usama Arif <usamaarif642@gmail.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 326AA2000F
X-Rspamd-Server: rspam03
X-Stat-Signature: kncgcn7w68oexj9y63cphjnnzsh5u9h3
X-HE-Tag: 1780082549-456513
X-HE-Meta: U2FsdGVkX1/rGoF+doESw5qs9lTVzjk3vq0oPGPgzD1XN1DGa7uV0n1BbLKSfME1fVuDqyjjTcyp85+WM49Tw2zjbhJEhXqDK708/Ku4hg+g/BmcBr9IRITOolDSt1gOhGPQGsvzOnbdW12ZWGlcWegNYextJf0g5QfwLjJ+K318OpQy7vi8bH/DD2A9e/i2pb5Qgr3WTuojBzEYmWs8+uKwVpTaf0PMivatfrRnT6+U8DFwPvci3FVUORPAk9z26KCUg8tqiDOLNlVtmgbdrk6dppJQZfc+QasIXnwnVfpy1q1Noj2y2tFF9BJVdc76/0q/5j4OzO38UnDU7O41rFg6283eO5bF6XyfRhBqWDwbT0WdyfD/q9vY+m1a4C2emlrO3M/LQl1yRatbUcNCZRfBMdUrDUyZr9XpOYvr8xRXBz5sYYtrhdrT+gSFh/sMIBS8/AjKQOWURxDLCRIbtjBOX47EBOAMcM4CEBE216AXzpyQSIsJqFk0ql36k6Bxkk/QwnrZgS6Njx8szzuxTyZAnXaGJvndF8pOSsz074Z64ay3q2J0yxEtnKtPn+rBXejxkyxfiOkGnQbP6FgNc2z+3nTZZptONP6qVE2ALNym7DqzV/2XTqUl7nO4yFjPI1MlWR1n9u3/8vSkjURYQydtFtobNZXIsgwh0ILQDGrPUECWQJoSw5ti1/Culzp8caDvGR7ggnIn1C5pI5Pkcddz5uhsCgChEjrmy+AKdXMa1QXAMJFCnCary2K4s3t1yVMG8r7htGAh/DJ/C07rH3Z9Nnx4JLT7y/skxUlxPVN4mh8CXe2sojtGq65B+NS3DREaxNuJay+AAXe78ifh3vAfEPTpcjZUiV7az2jFfI2zco0UTltnLmX5f8tQ0VI4MUbwoAlFabTkHfl452qGU4G6gOQbUMV40HAVePRL6SHibPh3al2ogXvSOj7a3tAYbz+XLvKljw3LRRtw4KH
 1o3rhrwC
 /OyJIfMzSpho3gsxyPzPOHtrKdW0wMnT4QSI5TlYuRAy6AjDfcJW9GJcmzTofm8Ydhr3MvECd+2Zfojff1CktUr7MqLcwnlGNfZP4fcx0EtuPLvyzArqS0w4W6HElJhmV/sXSZooXhTObBDIiNsC4tPNpOmIFGER2keAvptUICk6FjV7XV1+TIqZiF6lJiu5GTwiq38BlQcGhe2Oj9x9jCPrg+FETbbNuefL3z0CoKslRj3WcA5OfMxJlfJ7NrcWKLn1uTgH1UlLO5e/1I8EuEKoJjCFbYNdShXalbI93MPdfHq5KFb3QxOoocfsLVh+9KsVZeFN7qZswxg4XMvvwY2+ZcffRwS53F0KBEp7wKIJiiDHH04iCEPY9G1f1ZxEADsvzSQ5zmAcCL8pp9zARrXO3Apc25SC/Py9xD7ctFPVkZgM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 5:19=E2=80=AFAM fujunjie <fujunjie1@qq.com> wrote:
>
> The common zswap large-swapin policy needs locality evidence from
> callers before it can admit a large folio. For anonymous faults, provide
> that evidence from existing VMA hints and from the PTE young state left
> by earlier zswap-backed large swapins.
>
> Keep non-faulting PTEs old when mapping a speculative all-zswap large
> folio. A later fault can then require a dense young previous range before
> admitting another large swapin without adding VMA state.

Makes sense to me.

>
> This also removes the old zswap-enabled guard from the THP swapin
> candidate scan. The common swapin path now classifies the backend range
> and falls back to order-0 for mixed zswap/disk ranges or races.
>
> Signed-off-by: fujunjie <fujunjie1@qq.com>
> ---
>  mm/memory.c     | 234 +++++++++++++++++++++++++++++++++++++++++++-----
>  mm/swap.h       |   6 ++
>  mm/swap_state.c |  15 ++++
>  3 files changed, 235 insertions(+), 20 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 92a82008d583..7bbb89632000 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4556,6 +4556,35 @@ static void memcg1_swapin_retry_folio(struct folio=
 *folio,
>         folio_unlock(folio);
>  }
>
> +static void set_swapin_ptes(struct vm_area_struct *vma,
> +                           unsigned long address, pte_t *ptep, pte_t pte=
,
> +                           unsigned int nr_pages, unsigned int fault_pte=
_idx,
> +                           bool fault_only_young)
> +{
> +       struct mm_struct *mm =3D vma->vm_mm;
> +       pte_t old_pte;
> +
> +       if (!fault_only_young || nr_pages =3D=3D 1) {
> +               set_ptes(mm, address, ptep, pte, nr_pages);
> +               return;
> +       }
> +
> +       old_pte =3D pte_mkold(pte);
> +       if (fault_pte_idx)
> +               set_ptes(mm, address, ptep, old_pte, fault_pte_idx);
> +
> +       set_pte_at(mm, address + fault_pte_idx * PAGE_SIZE,
> +                  ptep + fault_pte_idx,
> +                  pte_mkyoung(pte_advance_pfn(pte, fault_pte_idx)));

Hmm, does this mean that without THP swapin, the faulting PTE is not
marked young, but it is marked young if there is a THP swapin. That's
a behavioral change right? Would this throw off other heuristics
relying on this bit, or any justification that this is fine?

> +
> +       fault_pte_idx++;
> +       if (fault_pte_idx < nr_pages)
> +               set_ptes(mm, address + fault_pte_idx * PAGE_SIZE,
> +                        ptep + fault_pte_idx,
> +                        pte_advance_pfn(old_pte, fault_pte_idx),
> +                        nr_pages - fault_pte_idx);
> +}
> +
>  static vm_fault_t pte_marker_clear(struct vm_fault *vmf)
>  {
>         vmf->pte =3D pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd,
> @@ -4628,6 +4657,157 @@ static vm_fault_t handle_pte_marker(struct vm_fau=
lt *vmf)
>  }
>
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +#define SWAPIN_ANON_YOUNG_MIN_PERCENT          75
> +#define SWAPIN_ANON_MAX_FAULT_SKIP_SHIFT       2
> +
> +static bool swapin_anon_prev_young_dense(struct vm_fault *vmf,
> +                                        unsigned int order)
> +{
> +       struct vm_area_struct *vma;
> +       unsigned int nr_pages;
> +       unsigned int threshold;
> +       unsigned long size;
> +       unsigned long base, prev, addr;
> +       struct folio *first =3D NULL;
> +       unsigned int present =3D 0;
> +       unsigned int young =3D 0;
> +       pmd_t *pmd;
> +       pmd_t pmdval;
> +       spinlock_t *ptl; /* protects the previous PTE range */
> +       pte_t *ptep;
> +       unsigned int i;
> +
> +       if (!IS_ENABLED(CONFIG_MMU) || !arch_has_hw_pte_young() || !vmf |=
|
> +           !vmf->vma || !vmf->pmd || !order || order > MAX_PAGE_ORDER)
> +               return false;
> +
> +       nr_pages =3D 1U << order;
> +       threshold =3D DIV_ROUND_UP(nr_pages *
> +                                SWAPIN_ANON_YOUNG_MIN_PERCENT, 100);
> +       size =3D PAGE_SIZE << order;
> +
> +       vma =3D vmf->vma;
> +       base =3D ALIGN_DOWN(vmf->address, size);
> +       if (base < size)
> +               return false;
> +
> +       prev =3D base - size;
> +       if (prev < vma->vm_start || prev + size > vma->vm_end)
> +               return false;
> +
> +       pmd =3D vmf->pmd;
> +       if ((prev & PMD_MASK) !=3D (base & PMD_MASK)) {
> +               pmd =3D mm_find_pmd(vma->vm_mm, prev);
> +               if (!pmd)
> +                       return false;
> +       }
> +
> +       pmdval =3D pmdp_get_lockless(pmd);
> +       if (!pmd_present(pmdval) || pmd_leaf(pmdval))
> +               return false;
> +
> +       ptep =3D pte_offset_map_lock(vma->vm_mm, pmd, prev, &ptl);
> +       if (!ptep)
> +               return false;
> +
> +       for (i =3D 0, addr =3D prev; i < nr_pages; i++, addr +=3D PAGE_SI=
ZE) {
> +               struct folio *folio;
> +               pte_t pte =3D ptep_get(ptep + i);
> +
> +               if (!pte_present(pte))
> +                       break;
> +
> +               folio =3D vm_normal_folio(vma, addr, pte);
> +               if (!folio || folio_order(folio) !=3D order)
> +                       break;
> +               if (!first)
> +                       first =3D folio;
> +               else if (folio !=3D first)
> +                       break;
> +
> +               present++;
> +               if (pte_young(pte))
> +                       young++;
> +       }
> +
> +       pte_unmap_unlock(ptep, ptl);
> +       if (present !=3D nr_pages)
> +               return false;
> +
> +       return young >=3D threshold;
> +}
> +
> +static bool swapin_anon_accessed_neighbour(struct vm_fault *vmf,
> +                                          unsigned int order)
> +{
> +       unsigned long size;
> +       unsigned long base;
> +       unsigned long fault_idx;
> +       unsigned long max_skip;
> +
> +       if (!vmf || !vmf->vma || !order || order > MAX_PAGE_ORDER)
> +               return false;
> +
> +       size =3D PAGE_SIZE << order;
> +       base =3D ALIGN_DOWN(vmf->address, size);
> +
> +       /*
> +        * Without a sequential hint, require prior young-density evidenc=
e and
> +        * only allow faults near the start of the candidate range.
> +        */
> +       fault_idx =3D (vmf->address - base) >> PAGE_SHIFT;
> +       max_skip =3D (1UL << order) >> SWAPIN_ANON_MAX_FAULT_SKIP_SHIFT;
> +       if (fault_idx > max_skip)
> +               return false;
> +
> +       return swapin_anon_prev_young_dense(vmf, order);
> +}
> +
> +static bool swapin_anon_fault_starts_range(struct vm_fault *vmf,
> +                                          unsigned int order)
> +{
> +       struct vm_area_struct *vma;
> +       unsigned long size;
> +       unsigned long base;
> +       unsigned long first;
> +
> +       if (!vmf || !vmf->vma || !order || order > MAX_PAGE_ORDER)
> +               return false;
> +
> +       vma =3D vmf->vma;
> +       size =3D PAGE_SIZE << order;
> +       base =3D ALIGN_DOWN(vmf->address, size);
> +       first =3D ALIGN(vma->vm_start, size);
> +
> +       return base =3D=3D first && vmf->address =3D=3D base &&
> +              base + size <=3D vma->vm_end;
> +}
> +
> +static unsigned long swapin_anon_locality_orders(struct vm_fault *vmf,
> +                                                unsigned long orders)
> +{
> +       struct vm_area_struct *vma =3D vmf ? vmf->vma : NULL;
> +       unsigned long locality_orders =3D 0;
> +       unsigned long candidates =3D orders & ~BIT(0);
> +       int order;
> +
> +       if (vma && (vma->vm_flags & VM_RAND_READ))
> +               return 0;
> +
> +       if (vma && (vma->vm_flags & VM_SEQ_READ))
> +               return candidates;
> +
> +       while (candidates) {
> +               order =3D fls_long(candidates) - 1;
> +               if (swapin_anon_fault_starts_range(vmf, order) ||
> +                   swapin_anon_accessed_neighbour(vmf, order))
> +                       locality_orders |=3D BIT(order);
> +               candidates &=3D ~BIT(order);
> +       }
> +
> +       return locality_orders;
> +}
> +
>  /*
>   * Check if the PTEs within a range are contiguous swap entries.
>   */
> @@ -4644,9 +4824,9 @@ static bool can_swapin_thp(struct vm_fault *vmf, pt=
e_t *ptep, int nr_pages)
>         if (!pte_same(pte, pte_move_swp_offset(vmf->orig_pte, -idx)))
>                 return false;
>         /*
> -        * swap_read_folio() can't handle the case a large folio is hybri=
dly
> -        * from different backends. And they are likely corner cases. Sim=
ilar
> -        * things might be added once zswap support large folios.
> +        * swap_read_folio() can't do mixed-backend large folio IO. The c=
ommon
> +        * synchronous swapin path will recheck backend state and fall ba=
ck to
> +        * order-0 if a zswap/disk race makes the range mixed.
>          */
>         if (swap_pte_batch(ptep, nr_pages, pte) !=3D nr_pages)
>                 return false;
> @@ -4693,14 +4873,6 @@ static unsigned long thp_swapin_suitable_orders(st=
ruct vm_fault *vmf)
>         if (unlikely(userfaultfd_armed(vma)))
>                 return 0;
>
> -       /*
> -        * A large swapped out folio could be partially or fully in zswap=
. We
> -        * lack handling for such cases, so fallback to swapping in order=
-0
> -        * folio.
> -        */
> -       if (!zswap_never_enabled())
> -               return 0;
> -
>         entry =3D softleaf_from_pte(vmf->orig_pte);
>         /*
>          * Get a list of all the (large) orders below PMD_ORDER that are =
enabled
> @@ -4708,10 +4880,13 @@ static unsigned long thp_swapin_suitable_orders(s=
truct vm_fault *vmf)
>          */
>         orders =3D thp_vma_allowable_orders(vma, vma->vm_flags, TVA_PAGEF=
AULT,
>                                           BIT(PMD_ORDER) - 1);
> +       if (!orders)
> +               return 0;
>         orders =3D thp_vma_suitable_orders(vma, vmf->address, orders);
> +       if (!orders)
> +               return 0;
>         orders =3D thp_swap_suitable_orders(swp_offset(entry),
>                                           vmf->address, orders);
> -
>         if (!orders)
>                 return 0;
>
> @@ -4741,6 +4916,12 @@ static unsigned long thp_swapin_suitable_orders(st=
ruct vm_fault *vmf)
>  {
>         return 0;
>  }
> +
> +static unsigned long swapin_anon_locality_orders(struct vm_fault *vmf,
> +                                                unsigned long orders)
> +{
> +       return 0;
> +}
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>
>  /* Sanity check that a folio is fully exclusive */
> @@ -4777,6 +4958,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>         unsigned long page_idx;
>         unsigned long address;
>         pte_t *ptep;
> +       bool fault_only_young =3D false;
>
>         if (!pte_unmap_same(vmf))
>                 goto out;
> @@ -4845,13 +5027,22 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>         if (folio)
>                 swap_update_readahead(folio, vma, vmf->address);
>         if (!folio) {
> -               /* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devic=
es */
> -               if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
> +               /*
> +                * Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devic=
es.
> +                * The swap device is pinned while checking the flag, mat=
ching
> +                * the existing fault path.
> +                */
> +               if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
> +                       unsigned long swapin_orders =3D thp_swapin_suitab=
le_orders(vmf);
> +                       unsigned long locality_orders =3D
> +                               swapin_anon_locality_orders(vmf, swapin_o=
rders);
> +
>                         folio =3D swapin_sync(entry, GFP_HIGHUSER_MOVABLE=
,
> -                                           thp_swapin_suitable_orders(vm=
f) | BIT(0),
> -                                           0, vmf, NULL, 0);
> -               else
> +                                           swapin_orders | BIT(0),
> +                                           locality_orders, vmf, NULL, 0=
);
> +               } else {
>                         folio =3D swapin_readahead(entry, GFP_HIGHUSER_MO=
VABLE, vmf);
> +               }
>
>                 if (IS_ERR_OR_NULL(folio)) {
>                         /*
> @@ -5110,9 +5301,12 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>
>         VM_BUG_ON(!folio_test_anon(folio) ||
>                         (pte_write(pte) && !PageAnonExclusive(page)));
> -       set_ptes(vma->vm_mm, address, ptep, pte, nr_pages);
> -       arch_do_swap_page_nr(vma->vm_mm, vma, address,
> -                       pte, pte, nr_pages);
> +       if (folio =3D=3D swapcache && nr_pages =3D=3D folio_nr_pages(foli=
o) &&
> +           arch_has_hw_pte_young())
> +               fault_only_young =3D swapin_fault_only_young(folio);
> +       set_swapin_ptes(vma, address, ptep, pte, nr_pages, page_idx,
> +                       fault_only_young);
> +       arch_do_swap_page_nr(vma->vm_mm, vma, address, pte, pte, nr_pages=
);
>
>         /*
>          * Remove the swap entry and conditionally try to free up the swa=
pcache.
> diff --git a/mm/swap.h b/mm/swap.h
> index dd35a310d06d..5d1c81ab49b9 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -327,6 +327,7 @@ struct folio *swapin_readahead(swp_entry_t entry, gfp=
_t flag,
>  struct folio *swapin_sync(swp_entry_t entry, gfp_t flag, unsigned long o=
rders,
>                           unsigned long locality_orders, struct vm_fault =
*vmf,
>                           struct mempolicy *mpol, pgoff_t ilx);
> +bool swapin_fault_only_young(struct folio *folio);
>  void swap_update_readahead(struct folio *folio, struct vm_area_struct *v=
ma,
>                            unsigned long addr);
>
> @@ -430,6 +431,11 @@ static inline void swap_update_readahead(struct foli=
o *folio,
>  {
>  }
>
> +static inline bool swapin_fault_only_young(struct folio *folio)
> +{
> +       return false;
> +}
> +
>  static inline int swap_writeout(struct folio *folio,
>                 struct swap_iocb **swap_plug)
>  {
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 5a4ca289009a..80dff6a1ee65 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -747,6 +747,21 @@ static bool zswap_needs_order0_retry(struct folio *f=
olio)
>                ZSWAP_RANGE_MIXED;
>  }
>
> +/*
> + * A speculative large swapin may install PTEs for pages that did not fa=
ult.
> + * Keep those non-faulting PTEs old so a later anon fault can report
> + * PTE-young density as caller-provided locality evidence without storin=
g
> + * state in the VMA.
> + */
> +bool swapin_fault_only_young(struct folio *folio)
> +{
> +       if (!folio_test_large(folio) || !folio_test_swapcache(folio))
> +               return false;
> +
> +       return zswap_probe_range(folio->swap, folio_nr_pages(folio)) =3D=
=3D
> +              ZSWAP_RANGE_ALL_ZSWAP;
> +}
> +
>  /*
>   * If we are the only user, then try to free up the swap cache.
>   *
> --
> 2.34.1
>


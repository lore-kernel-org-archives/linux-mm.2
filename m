Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB2E2CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:44:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 128F16B0005; Fri, 29 May 2026 10:44:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100316B0095; Fri, 29 May 2026 10:44:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F31B86B0098; Fri, 29 May 2026 10:44:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB3966B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:44:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7674DC0856
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:44:13 +0000 (UTC)
X-FDA: 84820727586.29.9BA3136
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id 61BA6A000F
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:44:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UvNZ6Ny0;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780065851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xee0neRMxkEGWjOCgf0A+ajeM60T1isEWix9DcnYtQ4=;
	b=tY+mRgysc1omDmDiHJHwFtSAWGW/PHWcusKnL40lsP4NaTFuM4APDRfRFDZSDAjoSJHVdU
	FAmyf2nCtCKJWNF1WvqZE30r1r//XYVJh7SxrP3lPv0VhSWiizqKhwUEd1zDhXYDSkT1ZP
	O0VzihjJN6R+qLDSvJ4nU6KF915s1Pw=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UvNZ6Ny0;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780065851; a=rsa-sha256;
	cv=pass;
	b=17iVcU53JQ+QMPjocRTfMxosQjaA1zj0PVhWNfAjsZZmILjCent1OCiNI33Ul8bfHItu6+
	t7raWe6kFzr2Eh9CYCx32B4BXQiNJZaH+i00ANUyKMukSX8wsC2kdA4mgIF4kjG2864ogb
	E0fM6Ohis9aBc+3T5A2xW5bamf5lud4=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-bd4d7f4fa02so2380563766b.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 07:44:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780065850; cv=none;
        d=google.com; s=arc-20240605;
        b=lge73YEDBbAKBQ6dePGkg2jBeOy4QD38unJ6UqkoXlkGJcsWo08XQBGERTDy8UR+kZ
         wtG5k3TTuSaK6DfaIfcAgBgU95zVAbtqoD9fvPDJO1QAARcjAoBb4hE29Fb1tInlyVUQ
         utQnT7+QlLqt0ewGPHiZWVlYVR+CXqiR3jI8YgLzpm1G3Z1rD0/dd+64fJXcBsnUV7S3
         qmAWbjGWgnFP0oi9gx1FLB2TLXtdCCsM62iesoWpOrkq9E4uUl3A03SLrgkEaB/u5vf1
         7MJmkeyQugVRQEdspncb6b5Fe836VCPf2ZtKHGs3cl3/AdEWWG8aVmFDq6Hjkx6EMvTp
         zUlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xee0neRMxkEGWjOCgf0A+ajeM60T1isEWix9DcnYtQ4=;
        fh=52jwbJG9Qk4dxxS3dQGyU2hJrBpk+rCkOCamRvYwlYU=;
        b=C6sUb2LCbwXhOKygi15rpuog91AwfjFSn8zzOXWmaFVnEDoV9I7rfURdAbP5pzP7DG
         H8QOkijhgFMFJdqueSAb/d2B2onGaiGRI7t2IaQUBkR60W4pU9zWsduugcdGJhQO33L1
         ftRgMuoKfS7mbCHPWsN792yFy8IZTMSx3v0jJo2DyOsI5rF0n2d/RqA+cdt5Umfr8f5D
         e57nUhlkq96zQh+rBdwloowj+Ste7ZCfbwCV4+ltrOmWdtoU9br54AL86Ohe2GY5zVBo
         MJw7SkhSd0gAEsEBgn142f8353ogg8pdH6a+edL2osekd3jmoiPa8eydnLQJjGG5Z3Fr
         /VzQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780065850; x=1780670650; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xee0neRMxkEGWjOCgf0A+ajeM60T1isEWix9DcnYtQ4=;
        b=UvNZ6Ny0/lT5CfLo6CuilrRW/QHvFq4Li2YTsl+uLsr0qFe477ytH/Qs4C9mhssglO
         poLiKuqjafc/5klh1AGewMso1g5UdfNPzsVIjeUVNXdiLuuhg73Hz8PhscVPb7UNkfUL
         K+S4K9nLMIk1EjvBzF77siC6MX33OHlFZw2C76q8rFkC2TLkw9a8mUwocrnsdsnmbrvt
         GQGVDuhaAZYa5ZrP+Yh9LN6D1rWYgm9mBnRkXWfgZSoZoci10K60knUQVxltGXeDw3Ec
         ln9iHccuSHEqz3HccjuMYo3hwy37+mp8BSF/0q3AB2LwUzsKP31IAbXEf2jwYWEWvIJ/
         O2rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780065850; x=1780670650;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xee0neRMxkEGWjOCgf0A+ajeM60T1isEWix9DcnYtQ4=;
        b=X2U+trRRICM+F3NlY70T2w7TegJTd5XZADZp90CTkqheyNT4L6DsT9AFyfD6UrCUmN
         G39WMjqoi5fT64+AEgJUlfGASripdJKF+9w9IJaq5hBjo7eImo81OIFPIVKchhofUh83
         VOEjX2I27cUDC5BLFpYmH5vOXE5KWK/Qu7k3s85s0uYfjNe14wp+mEBCP8edzrY6NwT2
         SJVIrPsAi64mN4swnPO5DCmLMoS+QIWFDQoC2DcrdLf/kF9fXSAz3Wsj/in7zWiDaN1l
         cnVM8NFalUBlCcIXXHUspDks5ELfwQ0CNW2GCZLWiGXue43ShouZuI/TkhztTlTpwRm4
         lyIg==
X-Forwarded-Encrypted: i=1; AFNElJ/2o2YjymVWoJ83354b+egEoJyrOSEpiq9yvPWdcOKnhP/TS3ccG/NLa4G5eQ7MT3dZ0QYuROkuTQ==@kvack.org
X-Gm-Message-State: AOJu0Yw+UkES0j/Jhj9gWN0iFW+jKNwoHN0vg9Tb42ptbdcdNTrmbOC1
	3wCQqz8BNm9DLtgBSwgCKwEhXES1jIYQ88yZXJSdt5FN/QMTnQ1Hc89YDnlzFujTfwaOACQlQAE
	wOw1JPrUraXgacNvA/Y3HMO9BvwrLets=
X-Gm-Gg: Acq92OE4NPdi47vaFflEhI4vTASuRAsn1HjG80VtEbVmL2XxrkheY3E+U2qGi3Idscz
	3vrhQseLZs0p8R7B17mBQobHKMuQCaT+C/mH+pKwOQtX8szhT0Sw2MI7WMxpQNuvnHL4vMmyeAz
	bIIWrIQGNzcN18eY7UTf2jC5cAtTMrpEvGknwh9UzwNMPO0sXzJlvA/sBU7ctQCCmRbDbVwH/dR
	crsA+HZyu9WDRDACdymHUyWzcsbPqi/AkcC3VRSBASzZeVPeCZyoUFXBdY2sOeVa6D/c3f5Y5Ym
	wxiZqkxJ77Og6jBtqpc+kt6ape9a7CbwO1xfNJ0ZNSFq01yNDlY=
X-Received: by 2002:a17:907:a68a:b0:bd5:2a43:b471 with SMTP id
 a640c23a62f3a-be9ccb8b34cmr202848866b.48.1780065849252; Fri, 29 May 2026
 07:44:09 -0700 (PDT)
MIME-Version: 1.0
References: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com> <tencent_EB78848E34DC7858C873193D67286ECD4B0A@qq.com>
In-Reply-To: <tencent_EB78848E34DC7858C873193D67286ECD4B0A@qq.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 29 May 2026 22:43:32 +0800
X-Gm-Features: AVHnY4KQ3LS9xvgeQfV41IMJNm14XsvQyrU_7jFjtxnCiD6FZQ0cqNPWPLweRic
Message-ID: <CAMgjq7AA_1esgtA8VyxaBLWBBRM12bCBpxO2Jch5OESBZSg--A@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/9] mm: admit large swapin by backend range in swapin_sync()
To: fujunjie <fujunjie1@qq.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Alexandre Ghiti <alexghiti@meta.com>, Usama Arif <usamaarif642@gmail.com>, 
	Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fbxspp6h5bieqfchqtejfaf15dr558xj
X-Rspamd-Queue-Id: 61BA6A000F
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780065851-565072
X-HE-Meta: U2FsdGVkX1/0OT8ikLsEtG1gPqkEH0lEOGtYK0Ed22pPSNvfrjB4Wba7tEqd0Oqfw/Nr7j7RtmMF7PsIZYQn3NzsRNBA9OKDxI0HtPsqBV03xXKSo1FMYMR4MK79mFfcqcYwveLKNamKAAe5K/3TBnatF9sFZaG84gQLuz0detXKKIBC3PY1mftbsNrym5+Ym1/l/AtGm42aL36mrOJKm1bpy9dIAg1JmoDf8vPmzB/U2tcrhF8F1FtHSlszeOntte/wxpyRBFYtShN/x3gFez98bqZRAXC077zEWlpjctdOXNR2TAu8GslHlvzqm3qkS39s4bOEBinYzJlV2HR6MzAci3bkDWDqth8Kq/6GB5sJXpWSvGWyvxpVSg4OPmO9PnypjQL48q43jgjqQOgbI6JsWOM990r0IOQVXM2uj2mw2ADZxXDXGUNqzJuskGLcbtkDTJrnURA3LrX/B6YYdwxV6BdaA3zWCSf1crvO4IGnCuk+IiLqAie3ctGlKYiqpQ6+Qg3iU7WkAZ4TM+5+te8efxkOJZEh5sxPhgq3FzdDyIP01h4ZZ1FmlujRbeQTNulrBwwKIF0FCs94c13G7kNWJh/xEm0eou4d1uF3zvCpkAXdq6CHmEDiCogf609LBZCW55k6SeduYxF72kEtMKwLkVtQTlYxIWBWpILtl6/LIpaF0GjTTWNCsRwPgAJ3We9DrryAVfKRCbd+sOE8s+je4W3MxLkt6Xu4klLpfx4d47S8dpmgi3KcHXzhW3jm9lkViR6C1lGCkICHZTujYvnavrKfJr1QSPxrDJ67zonLziLvsc77TJU64rFmLi8DB0GCed0+wkhxY6xlIkq1ZWSnWBlC/AfV1SdSiykiSPOXYFnrGWIr+nqEiR2zYmfOd7g/ASngIihJE650Bw+PEN97msNhkQKcjvlw0H1cgK4LBUfEF/xXLO6IhPkeYI11Z7DMz4d/jGK/EEUs6ZX
 6NowDmaX
 s/g+NdBo/5XIId3n4KPaGLe5SUOtuq3GXyXqCFyH6K48DHqPZTCPy6Tq+vNW+0Uzf88j/udAncnYIxxNX04wX8PSxjDDw9M6ifU8dCdJrefG7cVlZCj7Ka2echnJCDEhPSvyBTem/9gOgeT8ZeYtDl+SivqUUlmR2CEOXT5g9rAsTwRFUGWSv8EGhJDUX9eZPXP4IUscLafv30FjMquAt9QPBZTElgOG6E8f/XQZyGInjLgA/fjHrJkTn2S5BZ++ueym5vG7ge8iNKnX7KoxWN2xNpCWfgGP0SWyssdfmJ2p58fGeHbJsM6X5C7q2S3Yo/vmOKyMCEgn7nF6cgEUwR6eBxHuepdY/2+kM32XYzvAkw8JL0HxJuGoZGF+IgO+j+h65Zm8yqI2X5xItzzxKxT1MlMtPSRKZl4eV7hrubdwewpWS4ai5BgIyVUx3NlYTLpVxaSLDkeK8DnjpG1d4dig4jm1eSbIY/mhjkOTQnFlqE6J2pHR3ZULssA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 8:26=E2=80=AFPM fujunjie <fujunjie1@qq.com> wrote:
>
> A large swapin can only read one folio when the whole range has compatibl=
e
> backing. Mixed zswap/disk ranges must not reach large-folio IO, and zswap
> range probes are only snapshots.
>
> Filter the orders passed to swap_cache_alloc_folio() in swapin_sync().
> Uniform zeromap ranges and all-disk ranges keep the existing large swapin
> path. Fully zswap-backed ranges may be tried. Mixed zswap/disk ranges fal=
l
> back before allocation.
>
> After a large swapcache folio is installed, recheck the zswap range and
> drop the fresh folio if it became mixed. Also consume -EAGAIN from
> swap_read_folio() the same way. Both cases retry order-0, where each slot
> can resolve its current backend independently.
>
> Signed-off-by: fujunjie <fujunjie1@qq.com>
> ---
>  mm/memcontrol-v1.c |   8 ++-
>  mm/memory.c        |  31 ++++++++-
>  mm/swap_state.c    | 169 ++++++++++++++++++++++++++++++++++++++++++---
>  3 files changed, 194 insertions(+), 14 deletions(-)
>
> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> index 765069211567..5b11b8055c66 100644
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -682,8 +682,8 @@ void __memcg1_swapout(struct folio *folio, struct swa=
p_cluster_info *ci)
>   * memcg1_swapin - uncharge swap slot on swapin
>   * @folio: folio being swapped in
>   *
> - * Call this function after successfully adding the charged
> - * folio to swapcache.
> + * Call this after the charged folio has been added to swapcache and the=
 caller
> + * is no longer going to drop it back to swapped-out state.
>   *
>   * Context: The folio has to be in swap cache and locked.
>   */
> @@ -721,7 +721,9 @@ void memcg1_swapin(struct folio *folio)
>         id =3D __swap_cgroup_clear(ci, swp_cluster_offset(folio->swap),
>                                  nr_pages);
>         swap_cluster_unlock(ci);
> -       mem_cgroup_uncharge_swap(id, nr_pages);
> +
> +       if (id)
> +               mem_cgroup_uncharge_swap(id, nr_pages);
>  }
>  #endif
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 5a365492a9a2..d73a19692dea 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4538,6 +4538,24 @@ static inline bool should_try_to_free_swap(struct =
swap_info_struct *si,
>                 folio_ref_count(folio) =3D=3D (extra_refs + folio_nr_page=
s(folio));
>  }
>
> +static void memcg1_swapin_retry_folio(struct folio *folio,
> +                                     struct vm_fault *vmf)
> +{
> +       if (!folio_test_large(folio) || !folio_test_swapcache(folio))
> +               return;
> +
> +       if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT) {
> +               if (!folio_trylock(folio))
> +                       return;
> +       } else {
> +               folio_lock(folio);
> +       }
> +
> +       if (folio_test_large(folio) && folio_test_swapcache(folio))
> +               memcg1_swapin(folio);
> +       folio_unlock(folio);
> +}
> +
>  static vm_fault_t pte_marker_clear(struct vm_fault *vmf)
>  {
>         vmf->pte =3D pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd,
> @@ -4857,8 +4875,10 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>
>         swapcache =3D folio;
>         ret |=3D folio_lock_or_retry(folio, vmf);
> -       if (ret & VM_FAULT_RETRY)
> +       if (ret & VM_FAULT_RETRY) {
> +               memcg1_swapin_retry_folio(folio, vmf);
>                 goto out_release;
> +       }
>
>         page =3D folio_file_page(folio, swp_offset(entry));
>         /*
> @@ -5067,6 +5087,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>         if (unlikely(folio !=3D swapcache)) {
>                 folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSI=
VE);
>                 folio_add_lru_vma(folio, vma);
> +               if (folio_test_large(swapcache))
> +                       memcg1_swapin(swapcache);
>                 folio_put_swap(swapcache, NULL);
>         } else if (!folio_test_anon(folio)) {
>                 /*
> @@ -5076,6 +5098,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>                 VM_WARN_ON_ONCE_FOLIO(folio_nr_pages(folio) !=3D nr_pages=
, folio);
>                 VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
>                 folio_add_new_anon_rmap(folio, vma, address, rmap_flags);
> +               if (folio_test_large(folio))
> +                       memcg1_swapin(folio);
>                 folio_put_swap(folio, NULL);
>         } else {
>                 VM_WARN_ON_ONCE(nr_pages !=3D 1 && nr_pages !=3D folio_nr=
_pages(folio));
> @@ -5132,8 +5156,11 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>         if (vmf->pte)
>                 pte_unmap_unlock(vmf->pte, vmf->ptl);
>  out_page:
> -       if (folio_test_swapcache(folio))
> +       if (folio_test_swapcache(folio)) {
> +               if (folio_test_large(folio))
> +                       memcg1_swapin(folio);
>                 folio_free_swap(folio);
> +       }
>         folio_unlock(folio);
>  out_release:
>         folio_put(folio);
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index d37097913b30..f03ad4832f16 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -21,6 +21,7 @@
>  #include <linux/migrate.h>
>  #include <linux/vmalloc.h>
>  #include <linux/huge_mm.h>
> +#include <linux/zswap.h>
>  #include <linux/shmem_fs.h>
>  #include "internal.h"
>  #include "swap_table.h"
> @@ -403,7 +404,8 @@ void __swap_cache_replace_folio(struct swap_cluster_i=
nfo *ci,
>  static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
>                                         swp_entry_t targ_entry, gfp_t gfp=
,
>                                         unsigned int order, struct vm_fau=
lt *vmf,
> -                                       struct mempolicy *mpol, pgoff_t i=
lx)
> +                                       struct mempolicy *mpol, pgoff_t i=
lx,
> +                                       bool defer_memcg1_swapin)

Hi Fujunjie,

Thanks for the update, but this whole defer_memcg1_swapin thing is so
ugly I don't think this is the right way at all.

If you really need this, maybe you can always defer the memcg1
uncharge, I don't see why we need to treat large folio differently.
This charge doesn't effect the memory pressure, the reason we uncharge
memcg1's swap counter is to avoid long pinning swap cache holding the
swap cache of a cgroup so the cgroup will no longer be able to swap
out more folios. Deferring it won't hurt.

>  {
>         int err;
>         swp_entry_t entry;
> @@ -466,7 +468,8 @@ static struct folio *__swap_cache_alloc(struct swap_c=
luster_info *ci,
>         }
>
>         /* memsw uncharges swap when folio is added to swap cache */
> -       memcg1_swapin(folio);
> +       if (!defer_memcg1_swapin || !order)
> +               memcg1_swapin(folio);
>         if (shadow)
>                 workingset_refault(folio, shadow);
>
> @@ -495,9 +498,12 @@ static struct folio *__swap_cache_alloc(struct swap_=
cluster_info *ci,
>   * Return: Returns the folio if allocation succeeded and folio is in the=
 swap
>   * cache. Returns error code if failed due to race, OOM or invalid argum=
ents.
>   */
> -struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
> -                                    unsigned long orders, struct vm_faul=
t *vmf,
> -                                    struct mempolicy *mpol, pgoff_t ilx)
> +static struct folio *__swap_cache_alloc_folio(swp_entry_t targ_entry,
> +                                             gfp_t gfp, unsigned long or=
ders,
> +                                             struct vm_fault *vmf,
> +                                             struct mempolicy *mpol,
> +                                             pgoff_t ilx,
> +                                             bool defer_memcg1_swapin)
>  {
>         int order, err;
>         struct folio *ret;
> @@ -512,7 +518,8 @@ struct folio *swap_cache_alloc_folio(swp_entry_t targ=
_entry, gfp_t gfp,
>
>         do {
>                 ret =3D __swap_cache_alloc(ci, targ_entry, gfp, order,
> -                                        vmf, mpol, ilx);
> +                                        vmf, mpol, ilx,
> +                                        defer_memcg1_swapin);
>                 if (!IS_ERR(ret))
>                         break;
>                 err =3D PTR_ERR(ret);
> @@ -525,6 +532,124 @@ struct folio *swap_cache_alloc_folio(swp_entry_t ta=
rg_entry, gfp_t gfp,
>         return ret;
>  }
>
> +struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
> +                                    unsigned long orders, struct vm_faul=
t *vmf,
> +                                    struct mempolicy *mpol, pgoff_t ilx)
> +{
> +       return __swap_cache_alloc_folio(targ_entry, gfp, orders, vmf,
> +                                       mpol, ilx, false);
> +}
> +
> +static struct folio *swap_cache_alloc_speculative_folio(swp_entry_t targ=
_entry,
> +                                                       gfp_t gfp,
> +                                                       unsigned long ord=
ers,
> +                                                       struct vm_fault *=
vmf,
> +                                                       struct mempolicy =
*mpol,
> +                                                       pgoff_t ilx)
> +{
> +       /*
> +        * Speculative large swapin may drop this fresh swapcache folio a=
nd
> +        * retry order-0 after backend or page-table revalidation. Keep t=
he
> +        * cgroup v1 memsw swap owner until the caller commits the folio.
> +        */
> +       return __swap_cache_alloc_folio(targ_entry, gfp, orders, vmf,
> +                                       mpol, ilx, true);
> +}
> +
> +static bool swapin_zeromap_same(swp_entry_t entry, unsigned int nr_pages=
)
> +{
> +       unsigned int ci_start =3D swp_cluster_offset(entry);
> +       struct swap_cluster_info *ci =3D __swap_entry_to_cluster(entry);
> +       bool is_zero;
> +       unsigned int i;
> +
> +       if (ci_start + nr_pages > SWAPFILE_CLUSTER) {
> +               VM_WARN_ON_ONCE(1);
> +               return false;
> +       }
> +
> +       rcu_read_lock();
> +       if (!rcu_dereference(ci->table)) {
> +               rcu_read_unlock();
> +               return true;
> +       }
> +
> +       is_zero =3D __swap_table_test_zero(ci, ci_start);
> +       for (i =3D 1; i < nr_pages; i++) {
> +               if (is_zero !=3D __swap_table_test_zero(ci, ci_start + i)=
) {
> +                       rcu_read_unlock();
> +                       return false;
> +               }
> +       }
> +       rcu_read_unlock();
> +
> +       return true;
> +}
> +
> +static unsigned long swapin_admit_orders(swp_entry_t entry,
> +                                        unsigned long orders)

And this swapin_admit_orders chunk doesn't look good either...

> +{
> +       unsigned long candidates =3D orders & ~BIT(0);
> +       unsigned long admitted =3D orders & BIT(0);
> +       int order;
> +
> +       if (!candidates)
> +               return orders;
> +
> +       while (candidates) {
> +               enum zswap_range_state state;
> +               unsigned int nr_pages;
> +               swp_entry_t range_entry;
> +               bool admit =3D false;
> +
> +               order =3D fls_long(candidates) - 1;
> +               if (order > MAX_PAGE_ORDER) {
> +                       candidates &=3D ~BIT(order);
> +                       continue;
> +               }
> +
> +               nr_pages =3D 1U << order;
> +               range_entry =3D swp_entry(swp_type(entry),
> +                                       round_down(swp_offset(entry), nr_=
pages));
> +               if (!swapin_zeromap_same(range_entry, nr_pages))
> +                       goto next;

I think you don't need to test zeromap at all? __swap_cache_alloc
handles that already.

> +
> +               state =3D zswap_probe_range(range_entry, nr_pages);

If you just move the zswap_probe_range into __swap_cache_alloc and do
fallback there (or maybe you can shrink the order faster), then this
two new helpers are all redundant.

> +               switch (state) {
> +               case ZSWAP_RANGE_MIXED:
> +                       break;
> +               case ZSWAP_RANGE_ALL_ZSWAP:
> +               case ZSWAP_RANGE_NEVER_ENABLED:
> +               case ZSWAP_RANGE_NO_ZSWAP:
> +                       admit =3D true;
> +                       break;
> +               }
> +
> +next:
> +               if (admit)
> +                       admitted |=3D BIT(order);
> +               else
> +                       count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK);
> +               candidates &=3D ~BIT(order);
> +       }
> +
> +       return admitted ? admitted : BIT(0);
> +}
> +
> +static bool zswap_needs_order0_retry(struct folio *folio)
> +{
> +       if (!folio_test_large(folio))
> +               return false;
> +
> +       /*
> +        * Admission sees only an advisory zswap snapshot. Recheck after =
the
> +        * large swapcache folio is installed; if the range became mixed,=
 drop
> +        * the fresh folio before IO and let order-0 handle each slot.
> +        */
> +       return zswap_probe_range(folio->swap, folio_nr_pages(folio)) =3D=
=3D
> +              ZSWAP_RANGE_MIXED;
> +}
> +

Again, I think you can just probe the suitable size in
__swap_cache_alloc directly, that way, we avoid the diverge of sync /
non-sync device, and avoid the whole chunk making the code much
simplier too, just like what we are alreadying doing for zero map in
__swap_cache_alloc, or am I over simpliying it?


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56C7EC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 21:49:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B848D6B0092; Tue,  8 Sep 2026 17:49:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B355D6B0093; Tue,  8 Sep 2026 17:49:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A250C6B0095; Tue,  8 Sep 2026 17:49:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D7E46B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 17:49:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F3B5CA53BF
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 21:48:59 +0000 (UTC)
X-FDA: 85191935598.17.D9ACE00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 005CE40007
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 21:48:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G+j535yJ;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788904138;
	b=Fpc3vqrawkUJ2qbEYQUke/BXeFD9klRiqKfIIZoTFkWOQvIp/f+F86gRvdNdmAvJXuLv0c
	YblvmEUE2GE2sJt9bO0SNzBeBE5LlUN9iIVtWioNU7PyQ12A6AcMFbfhb7ki4wdne+uV/z
	krrJutagjc3SBenLwiaxP9I2rQAbfx0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G+j535yJ;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788904138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SRj5/+71oEw51fEMN0Yf34skdA28n5/tgdHP34PLH1k=;
	b=Y2uS7SCqffB3dOvvHmETEYyCGwckze5ku3Y7WC8/EEWkX/cQwBS7FHYPxIbL3dcj2Rby5L
	8DfsdGVYTOw2AO254CNEdg4AObPh5tsLxn2FsTqTuSTDLDvmbEa4iLxlqHwQ51o5Pr4VOj
	nyzPTeXOfKix8sDrT79nQBgIgPkCP7k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EFF5343F3D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 21:48:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2321F00A3F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 21:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788904136;
	bh=SRj5/+71oEw51fEMN0Yf34skdA28n5/tgdHP34PLH1k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=G+j535yJmcltZZ4KuVgJdBAs29iJd3/VCpwT8YI7QPtafWJCJ4srDYIjHWMrFLGv6
	 e4eLcO98/6LyQDjdg6YnqwVTFOqVbZSKfViSBpTJUxBzoe2GlOfUvRnArW2bqJfTcf
	 dps7WW3nn4CNrDph4l24OUh6LWZgmkDOfJknWg31sIOAv+9mpSCtsofsBWbCFZzTvb
	 sA6ZDheUcO+dFJScM6pLQ0YCHohOE+zeA6u5AVaWFQcCn6W41r0zywN8JMR9+ZWQq1
	 DP7w42MuRNq6secntB9eZohLhwNdsZm0XJY/oVo3Payzadw7gcN9gX9aLOe9msJtBV
	 aUbDvYk5UpnZw==
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93910cadeb0so41786285a.3
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 14:48:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxokiE0bmmdVRa3liO/aq1NFiaZJFHITRqQ03tQt5T2pnu4EsEOdlNOcIuhO8RVbbhzVtoftySphw==@kvack.org
X-Gm-Message-State: AFuF++nygIQXvQlgx4Glt72WzQLNyD+cGvo2I34ghqcbDiwOjWaFMZr4
	DTAe1RFOOoReSgrFlud5QIU85nxsKVRaubztkK1A/ThoOQoaIcOo6IZSfYQyuONSlmEYOpl+7C9
	embGva/akcgKFHs8viiR+U8FAFJe6duY=
X-Received: by 2002:a05:620a:6887:b0:939:b482:d474 with SMTP id
 af79cd13be357-939c94d1567mr389574985a.35.1788904136079; Tue, 08 Sep 2026
 14:48:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260901054358.4049095-1-dev.jain@arm.com> <20260901054358.4049095-9-dev.jain@arm.com>
In-Reply-To: <20260901054358.4049095-9-dev.jain@arm.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 9 Sep 2026 05:48:45 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yQhafd8zoESxFza3N8kxWxpOpa1Pv-Sf+N=mCPz5or=w@mail.gmail.com>
X-Gm-Features: AcwNN1WplhjIUPyGVS7vzahad1sRXKX0hXs9tSmw_MqKdbFgEAwOX3x96mPKlcA
Message-ID: <CAGsJ_4yQhafd8zoESxFza3N8kxWxpOpa1Pv-Sf+N=mCPz5or=w@mail.gmail.com>
Subject: Re: [PATCH v2 8/8] mm/rmap: batch unmap anonymous swap-backed large folios
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com, riel@surriel.com, 
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com, 
	lance.yang@linux.dev, baolin.wang@linux.alibaba.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, pfalcato@suse.de, 
	ryan.roberts@arm.com, anshuman.khandual@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 005CE40007
X-Rspam-User: 
X-Stat-Signature: er494t5bconsw9tqcanptdpqttc1tn7w
X-HE-Tag: 1788904137-717463
X-HE-Meta: U2FsdGVkX18YFRJNUYIrV6MH1jc0LpZeK7+UAGumVyfXfdxEyXmMqpjj2bwAmqAndyA1UVP+uxZ3840ohhgl7mNOwRzWIb6U/zNmTTx++i95kPCZs0U/yqmNDhtaBWYM/FDj30g6bLTKrSMWW1dOmuAvaDOqCeJJ5jkx9zc3EM1X2wLw3Syak40s9kvBr9XFEHczn1KN4KeGYYMlwdUDmkhv0MK94+Q6GjdPq3YoQnkIzj5a41QBHo/+S3qAM3LAMpTN/Ogj7ILh7Oa+6fu4kMT48RDnrwlSsF96vTDq/YB+1wlr5k2FmWnhNFtebHonegFwprZhSztzxQAs8buejeDrL9+Z/PHWx7eQ/I60Rir3Se4celFXGOxG7nouVbe2r/E2hPWT6vIiy/p0MSQtbN3XwLujX3umirgnCACQskxR10d7zFiv6BGim+XDlFQwNs131Ui4RVTRh1+rAU4qD16nRYHtBqKUEqtxBgKKqEMuINWvCQIBjpFUyraBkgYyZsjA7lmc3woXjQFVaITJGrVmEPMTrZODXbzU/WN2h+ApPZaxIF5tOnhH8bLeE89mAeGPD6yaz4FbPm7F98M6nMnjVCeJFS7hokzWAqI3lhKHDy1g9pyI1fcsdSlX9XNdUNfZB+a2BtGF5KZZkBln06WqMKwyfAecNoIxCtuUuLcoEu0v3FMhuwhDZ3XH3qWPPRVxa3w2UwXGi37QTEa+d9ZklwNhbDlIcGxPgeXGW4fsS/WTkKa/KDEggITIcF0kJwbC80oq9nPcxemkESHb+QEbaNDkZsVoCOV5h5QRM6Dp1ZGJxZbLKPZSjZ4iuHh6NB42RIj19O30H9RE9yIKwzCOhTw6wdKqFs13FKZxbtJbt/tf0fE0M1TNBfZMC5DACYKsAHE7YqcvKIplAUjXEBQmoKNfktdL4MnX+2d/YIZWuEOcv8WTzon0WQai5tjCXC9zI2idr0jLkAbxq0l
 90T03O0g
 xGtvMd/DKDqj70QNH7rImYRo4u8deEEGXjbZMnOKfK18LQ+3fuslYGxKVbMMPDDz1M4m33oaA54OLjUZLqMM7L37yYGPuZZ48f2an5GYvjEj2i6BWMYkQwGn2AvAKI2Y3aGR3pfM/g1vyxnGgdbJOcJDcNYVy7cr3hGwNjuMJ1AywwtXJkSYLegEKXCO1QWDTScc6o6chGZhP3aF7gqghlSwRMoz8+FJeQ4eG9G31qX+5njsZHyA0JzH6w0Dcqt1bQEnam3V5BzNz6hcY1/B1krvRugoMknPLnv6GMl2k8ZO7Rk/cWjb4+Z9W5yzazJOqwNPH1ysu5qGbo+f3GoWxpHtEsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 1, 2026 at 1:45=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
> Enable batch clearing of ptes, and batch swap setting of ptes for anon
> swap-backed folio unmapping.
>
> Processing all ptes of a large folio in one go helps us batch across
> atomics (add_mm_counter etc), barriers (in the function
> __folio_try_share_anon_rmap), repeated calls to page_vma_mapped_walk(),
> to name a few. In general, batching helps us to execute similar code
> together, making the execution of the program more memory and
> CPU friendly.
>
> On arm64-contpte, batching also helps us avoid redundant ptep_get() calls
> and TLB flushes while breaking the contpte mapping.
>
> The handling of anon-exclusivity is very similar to commit cac1db8c3aad
> ("mm: optimize mprotect() by PTE batching"). Since folio_unmap_pte_batch(=
)
> won't look at the bits of the underlying page, we need to process
> sub-batches of ptes pointing to pages which are same w.r.t exclusivity,
> and batch set only those ptes to swap ptes in one go.
>
> arch_unmap_one() is only defined for sparc64; I am not comfortable
> regarding the nuances between retrieving the pfn from pte_pfn() or from
> (paddr =3D pte_val(oldpte) & _PAGE_PADDR_4V).
>
> (And, pte_next_pfn() can't even be called from arch_unmap_one() because
> that file does not include pgtable.h) So just disable the
> "sparc64-anon-swapbacked" case for now.
>
> We need to take care of rmap accounting (folio_remove_rmap_ptes) and
> reference accounting (folio_put_refs) when anon folio unmap succeeds.
> In case we partially batch the large folio and fail, we need to correctly
> do the accounting for pages which were successfully unmapped. So, put
> this accounting code (which is finish_folio_unmap()) in
> __ttu_anon_swapbacked_folio() itself, instead of doing some horrible
> goto jumping at the callsite of ttu_anon_folio().
>
> Similarly, do the finish_folio_unmap() in ttu_anon_folio itself for
> the non-swapbacked (lazyfree) case.
>
> If the batch length is less than the number of pages in the folio, then
> we must skip over this batch.
>
> The page_vma_mapped_walk API ensures this - check_pte() will return true
> only if any of [pvmw->pfn, pvmw->pfn + nr_pages) is mapped by the pte.
> There is no pfn underlying a swap pte, so check_pte returns false and we
> keep skipping until we hit a present pte, which is where we want to start
> unmapping from next.
>
> Remove the label finish_unmap since no goto callers are left now.
>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/rmap.c | 110 ++++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 81 insertions(+), 29 deletions(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 1b9f07d4d1be9..68e0201ffd003 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1964,12 +1964,14 @@ static inline unsigned int folio_unmap_pte_batch(=
struct folio *folio,
>         end_addr =3D pmd_addr_end(addr, vma->vm_end);
>         max_nr =3D (end_addr - addr) >> PAGE_SHIFT;
>
> -       /* We only support lazyfree or file folios batching for now ... *=
/
> -       if (folio_test_anon(folio) && folio_test_swapbacked(folio))
> +       if (pte_unused(pte))
>                 return 1;
>
> -       if (pte_unused(pte))
> +#ifdef __HAVE_ARCH_UNMAP_ONE
> +       /* Add batching support to arch_unmap_one() to remove this */

I'd like to make this clearer. For example, could we say that
sparc has `arch_unmap_one()`, which doesn't support batching?

BTW, it shouldn't be too hard to save `nr_pages` tags, looking at
the code:

static inline int arch_unmap_one(struct mm_struct *mm,
                                 struct vm_area_struct *vma,
                                 unsigned long addr, pte_t oldpte)
{
        if (adi_state.enabled && (pte_val(oldpte) & _PAGE_MCD_4V))
                return adi_save_tags(mm, vma, addr, oldpte);
        return 0;
}
Maybe the sparc folks can handle this.

> +       if (folio_test_anon(folio) && folio_test_swapbacked(folio))
>                 return 1;
> +#endif
>
>         /*
>          * If unmap fails, we need to restore the ptes. To avoid accident=
ally
> @@ -2139,16 +2141,25 @@ static pte_t swp_pte_prepare(swp_entry_t entry, p=
te_t old_pte,
>         return swp_pte;
>  }
>
> -static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
> +static void finish_folio_unmap(struct vm_area_struct *vma,
> +               struct folio *folio, struct page *page, unsigned long nr_=
pages)

We are not necessarily finishing the whole folio here, right?
The name is a bit misleading to me, as it sounds like we're finishing
the whole folio.

Maybe `finish_folio_unmap_batch()`?

> +{
> +       folio_remove_rmap_ptes(folio, page, nr_pages, vma);
> +       if (vma->vm_flags & VM_LOCKED)
> +               mlock_drain_local();
> +       folio_put_refs(folio, nr_pages);
> +}
> +
> +static bool __ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
>                 struct folio *folio, struct page *page, unsigned long add=
ress,
> -               pte_t *ptep, pte_t pteval)
> +               pte_t *ptep, pte_t pteval, unsigned long nr_pages,
> +               bool anon_exclusive)
>  {
> -       const bool anon_exclusive =3D folio_test_anon(folio) &&
> -                                   PageAnonExclusive(page);
>         swp_entry_t entry =3D page_swap_entry(page);
>         struct mm_struct *mm =3D vma->vm_mm;
> +       pte_t swp_pte;
>
> -       if (folio_dup_swap_pages(folio, page, 1) < 0)
> +       if (folio_dup_swap_pages(folio, page, nr_pages) < 0)
>                 return false;
>
>         /*
> @@ -2157,21 +2168,57 @@ static bool ttu_anon_swapbacked_folio(struct vm_a=
rea_struct *vma,
>          * so we'll not check/care.
>          */
>         if (arch_unmap_one(mm, vma, address, pteval) < 0) {
> -               folio_put_swap_pages(folio, page, 1);
> +               VM_WARN_ON(nr_pages !=3D 1);
> +               folio_put_swap_pages(folio, page, nr_pages);
>                 return false;
>         }
>
>         /* See folio_try_share_anon_rmap(): clear PTE first. */
> -       if (anon_exclusive && folio_try_share_anon_rmap_pte(folio, page))=
 {
> -               folio_put_swap_pages(folio, page, 1);
> +       if (anon_exclusive &&
> +           folio_try_share_anon_rmap_ptes(folio, page, nr_pages)) {
> +               folio_put_swap_pages(folio, page, nr_pages);
>                 return false;
>         }
>
>         mm_prepare_for_swap_entries(mm);
> -       dec_mm_counter(mm, MM_ANONPAGES);
> -       inc_mm_counter(mm, MM_SWAPENTS);
> -       set_pte_at(mm, address, ptep,
> -                  swp_pte_prepare(entry, pteval, anon_exclusive));
> +       add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
> +       add_mm_counter(mm, MM_SWAPENTS, nr_pages);
> +       swp_pte =3D swp_pte_prepare(entry, pteval, anon_exclusive);
> +       set_softleaf_ptes(mm, address, ptep, swp_pte, nr_pages);
> +       finish_folio_unmap(vma, folio, page, nr_pages);
> +       return true;
> +}
> +
> +static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
> +               struct folio *folio, struct page *first_page,
> +               unsigned long address, pte_t *ptep, pte_t pteval,
> +               unsigned long nr_pages)
> +{
> +       unsigned long batch_idx =3D 0;
> +
> +       while (nr_pages) {
> +               bool anon_exclusive =3D PageAnonExclusive(first_page + ba=
tch_idx);
> +               unsigned long len =3D page_anon_exclusive_batch(batch_idx=
,
> +                               nr_pages, first_page, anon_exclusive);

`len` is really a bad name, as `len` usually describes a size.
Maybe `batch_pages`?

> +
> +               if (!__ttu_anon_swapbacked_folio(vma, folio,
> +                               first_page + batch_idx, address, ptep, pt=
eval,
> +                               len, anon_exclusive)) {
> +                       /* Restore the remaining PTEs that were cleared. =
*/
> +                       set_ptes(vma->vm_mm, address, ptep, pteval, nr_pa=
ges);
> +                       return false;
> +               }
> +
> +               nr_pages -=3D len;
> +               if (!nr_pages)
> +                       break;
> +
> +               pteval =3D pte_advance_pfn(pteval, len);
> +               address +=3D len * PAGE_SIZE;
> +               batch_idx +=3D len;
> +               ptep +=3D len;
> +       }
> +
>         return true;
>  }

Best Regards
Barry


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD0B810F3DEE
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 18:52:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D5EF6B008C; Sat, 28 Mar 2026 14:52:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ADC76B0095; Sat, 28 Mar 2026 14:52:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C3356B0096; Sat, 28 Mar 2026 14:52:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2AE776B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 14:52:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BBB13139A4F
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 18:52:47 +0000 (UTC)
X-FDA: 84596368374.03.C4A0945
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id C05F940003
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 18:52:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PjIFt2Jm;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774723965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T+SbHaxLmzeFeoT6x/zm21mPwwR0CFdnn7mBNCs6Cuw=;
	b=hLqsbpA90IOIRHEAPc1x2oVATO1+IvYRlPMTTP5EYhaANnMwXHXnAzBPi65qm5REEkFsj4
	9zETlWQqAnTUHxGp2KdyCQIvu7YtCrJBj69qDnmVAJFUKoABdbleR7WkEZ2q0Tq4TAkEFr
	z7LBQ8eAAQUXzJwtRboclawqw7WWio4=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PjIFt2Jm;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774723965; a=rsa-sha256;
	cv=pass;
	b=Fmdye3D5NbOW1QvVfFA1GRQO6nMXmiQvKxuQ2ucVxyqsuaCsVp6r4llRubdi576m+xvrcK
	SfERme8zLt6Wq0lN/q60W9OxLLTnr0pQ0Sc52zmQA9hCVrd3ZGaJpOCwkFbJsFA56wK/Ax
	Iptfxdupbj921fMJxvhUq0hjOjSDCag=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-509062d829dso429651cf.1
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 11:52:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774723965; cv=none;
        d=google.com; s=arc-20240605;
        b=I0Di4ztNxc8nNQqcfRmEuHiYKYJ146qFrXE75k8fpAWmSi5PQsRYp/MCXY7X3Jg/77
         s588NC7jM8kOUz4G61bhEhP9ERKRx7lqt66TLBFFT6kvY/E/g5rk0vYK8vj9y+0Tvufk
         h1AkX9c7XFxpfrz84Aj/fsYwwAixiU/5v8sc1k/EuoMR1fB2UszZ/jXpXN9+KUCMsTOt
         luSB0GSS9BJlfAPgkC2ale5I2gT0IPLZtRzTo1ks1KUL2Q/z8qgfPwQfMBZz4KQi6UZl
         60o2DaN/HvXvr17wybxK5PkMPqtWsux9s8wq9WGIo94JWnMCZckgaUC2Pq9lODn9swIZ
         FGKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=T+SbHaxLmzeFeoT6x/zm21mPwwR0CFdnn7mBNCs6Cuw=;
        fh=uNU+6jk0KDBjd5P2lOfuB8hjVB0jlpQ/zoNzJ6YiA3c=;
        b=W9upylzumKEfpQO6RrcgVTR9YiXFJXa9GR+jubVOfyhi51lFQumpTmUM+2k+R0cRfQ
         0tD4r9hOkCgjiOK7n5eBmiiCbY+98FJYDQKFKRd8o77pQ3RAmR7VnUeMw2T6b70uires
         atNWPNlUtZAU26qEISopgqfbEYmGS9KQKAa4xJCDR/0kHeXG/tDnQiTSiQ3Dys+PCFGO
         Sth+xr9BfjogmUFvctkM1xARWf2K3jf1IRGyhOyOZASx0OibpohlEihcAIoDOQFWeqO2
         wGsmHn6rGape4snXmsHf4kAgXmaCr1BWhSKH8/W5VlJn4vUPX0J5tJaQWEmOyKbRLJ7N
         djiw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774723965; x=1775328765; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T+SbHaxLmzeFeoT6x/zm21mPwwR0CFdnn7mBNCs6Cuw=;
        b=PjIFt2JmFzpuJMAabh71vy5rTT0PhlON+byzT/P3rXh5Lxv8W9lz9znYuz8qupNGt6
         GB/WlmbT9zWVPQwdoRIChz8anCpA4rFeA9TyCyItqN1r2GBGB/OTsAhvApnEzBL9gMT4
         hPPXxmN9fRq1cqAxLIkaQRVlq748hnK7W5CFHZ4KcXuVsCdrKPI38IYsRpyxaATB7zbS
         kYhy3waqlaMhFsK7oP1TLVqopEmv9gxiv/6tXl6lf00ry7EozEM+Mqi84lNO5YGs4P11
         P/ZE2Uif9lmUbQFNLku+BAQj3Mdt634YsF5LEgMoSqwJHC6cfvsfnhSIt2C9tlrOcSmd
         BzKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774723965; x=1775328765;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T+SbHaxLmzeFeoT6x/zm21mPwwR0CFdnn7mBNCs6Cuw=;
        b=K7Rxr67PnnAR6zik/ehdG1a1LPDBaHX4XR3NtMhfowN2nSDiiPBOD9lTWvTK71Hyuj
         cKbmh3kL0fQLZTLCuyom9K/f49dHnV0pCV4/ntNZaEE/kegLXJDmsovchCeZxG7yGqDk
         aw6d1pPO9D6gw00mpHrK8/tN3Xl8sILspxfX1nYTpQTBuhZB7QrN+Efuf8mTk0A8cyQE
         IQTNDnSGH/Nxnyj/JZ8DGTWtJdfmbajYRAHjHMStcFsB0UnqHRU+b5xvKL5P+DLD5o+L
         mYHXkMIkvBAUIMQjWOjLNxNE1ROdmepv7jDO79d98Qma85oJwAyG+gie3QPHh8ar+ttx
         mmtQ==
X-Forwarded-Encrypted: i=1; AJvYcCXsAXJNF2GCy5bI3hB8ceFFuwuJNBWLokuYu5Unwecvg7VFWfyoBq9/2e0hrftUva4jzmCP+dnLHw==@kvack.org
X-Gm-Message-State: AOJu0YyZudb9056roG93lZnsp2OsE9zShE5QzyDyRmaXIrlkpDyycDcl
	PrU/mtnXCQfkIVf72o67ykNWQvQBZXaRRAs5q9K0h4RQ//lrqIxqJDPwpEtO8OhC98qAgJvnBmw
	XpxlHA6htEVEJxJbGmd6DlQGbopWZSP7DoDmRo/eP
X-Gm-Gg: ATEYQzwwMdsUYYP6phnq/q2/Ye6AARgpswiPrgXc8IUusflf9vJvxwFxB0TrEbbmYK+
	T5BPGR6LVSlAqzj8ZQXcMGweCB+Xve/9k5xtILTxv7gDPAaTpVRPKQSBo+eOfTIRiWLdT+k+ELH
	DKr4OS5O3Up/iy6ukir6H49fhuVb/YyRpba0Ennt2liDy/pX7sXAq9uFEvXRUyoGu7IIQaF6Osi
	HI/gg1mKYIMx0faDxnsBuQtqiHbuPbyv6cry10QG8g70sAF5PIX3kWmiifqvGbN+xKVvqtI0nR1
	nprC7A==
X-Received: by 2002:a05:622a:2285:b0:509:15b6:f69f with SMTP id
 d75a77b69052e-50bb263780fmr13296091cf.2.1774723964279; Sat, 28 Mar 2026
 11:52:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1774029655.git.ljs@kernel.org> <6b4d5efdbf5554b8fe788f677d0b50f355eec999.1774029655.git.ljs@kernel.org>
In-Reply-To: <6b4d5efdbf5554b8fe788f677d0b50f355eec999.1774029655.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 28 Mar 2026 11:52:33 -0700
X-Gm-Features: AQROBzAygtVkNPnpzpDdX4RiDr789lglTD-2OhppKjADrwkoIhM16eBDQH8mylg
Message-ID: <CAJuCfpGKrBdhL=puid6SqrmKNrOdnk7ezwbWSD9djJPOC4ySgg@mail.gmail.com>
Subject: Re: [PATCH v3 02/13] mm/huge: avoid big else branch in zap_huge_pmd()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C05F940003
X-Stat-Signature: gxs6q8k3irtc1tfuwn585g1jhqjokxzj
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774723965-345340
X-HE-Meta: U2FsdGVkX1/I7KqFgY5mxVdQAhyYTu/+SEXfdoa6fan9Eo9fRTlfjkZYUoVAUKM+yj5lEVKMpt8OQQm23an4M7UswsR7Tcy0H40LWCU/M7W6RNINdDzICUnIVq97xG2BuU5F9Qzf62HygZ/iKVNUF3CH3Bm4jwrsmdeA7SxbySSiTLqcTQfM2mLQSUspWFIVVwSjDBxJ42JzR9BnKDFN2KeX4Rp+nZVZgtKJsE8hHJlcnPQxNJXFf6EqqLZHU0NZL0W51pop5F4xU7tduGJ9fEOOMX6bjD3rJC6Cv4VFs2Bh/SR03Pt4I27MwY85YY6yOBLIaUwJLnobShnb7xWBzM4kMQaPZfuJaV8KKVb+AXP6tg0Pb1y0M2jIT63OEZ/XBDuAdUvPlZQSlp31tDIHhqWtm4fm5s1qtzWRnTTIBVkZCX/U8dRmeupcsH+smQEwoxSWMCqARkZ9Iq4v4m+dMwNEEl+1wdt+jk6exENMDPT0dP214X+llxlkcK5xD67O0FNdCRcze+8GPsPoFAlFk+DD3grh7bmVdnioU8DYdkudHlVE7EwkzaVwEnpCPNfzmct3RtjxtnBTmFJ7dVXV8kW1IMNaMvi/N9QhM0wrWJjijxrUTu+lGLbmGEQbN/oVwqK+c/UBQCT7YAuYSM3paKJ8xA9z8YnMDmZhkKdEhB89GBUyGieF1yWE7vLJbNvbN7/zqndgnbkpy4XUhZk6lkvmd5jholBlUp9zhwnUIbB6imDeDE2/bJEJwCoUYJ2WdI+XBc9aCocTjgd2zlf2qnc9xmf/sAFcvAzauR6zPc5sF9bo1Ll0pELq1dqdmYLcRrLTG16IPKykGuepnMo+VZug6FS8mvHOz23zDRzMUTNMieJziblaToyn3bKSiu8ORNwq0QjbRxX17KN/2kZXKvnCbxNK/9K6kqjcCQ5khGfhUoLGyYGR2qHrW/5cWRCvfc8L8XAf0rQKD7DmDVF
 1mL7LZTW
 6facmZxyfv5eaXrABzI/dIXAKCaAAJYdAw64haNAN7eURuCSGOs6x3defLj8et/SCEZDi+3E2TQtO/z7zqzsUD2KLqKsuz4Ibldj7kj91IMr6Fv/I6eDr0+9ps7X+6iHBp7cQfnxwSBwJd+pDxZCRIQBYHFvwsOJC6tZw6MXaoML+2zBj5+k27BJm4AJARjNvdbmpH8b/JaUWCeA8+UN1REZj4zXBK6nKHAMF1pXcU4DhrhAJ+Ui5rpsDeGGALY+z6PyXTf1dqY6IRuS4glTwrEjVVtIoRJb2hl1OixCYR+2R3zfnD33PhJ4ZDji8kTwIEwCypXICgfCMpGegL6C9f55R5AG8ucCRj1g46cPzlDFNSSTJEYQCO9kJBPxhXxNQZaTv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 11:07=E2=80=AFAM Lorenzo Stoakes (Oracle)
<ljs@kernel.org> wrote:
>
> We don't need to have an extra level of indentation, we can simply exit
> early in the first two branches.
>
> No functional change intended.
>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/huge_memory.c | 87 +++++++++++++++++++++++++-----------------------
>  1 file changed, 45 insertions(+), 42 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2775309b317a..4e8df3a35cab 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2328,8 +2328,10 @@ static inline void zap_deposited_table(struct mm_s=
truct *mm, pmd_t *pmd)
>  int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>                  pmd_t *pmd, unsigned long addr)
>  {
> -       pmd_t orig_pmd;
> +       struct folio *folio =3D NULL;
> +       int flush_needed =3D 1;
>         spinlock_t *ptl;
> +       pmd_t orig_pmd;
>
>         tlb_change_page_size(tlb, HPAGE_PMD_SIZE);
>
> @@ -2350,59 +2352,60 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct v=
m_area_struct *vma,
>                 if (arch_needs_pgtable_deposit())
>                         zap_deposited_table(tlb->mm, pmd);
>                 spin_unlock(ptl);
> -       } else if (is_huge_zero_pmd(orig_pmd)) {
> +               return 1;
> +       }
> +       if (is_huge_zero_pmd(orig_pmd)) {
>                 if (!vma_is_dax(vma) || arch_needs_pgtable_deposit())
>                         zap_deposited_table(tlb->mm, pmd);
>                 spin_unlock(ptl);
> -       } else {
> -               struct folio *folio =3D NULL;
> -               int flush_needed =3D 1;
> +               return 1;
> +       }
>
> -               if (pmd_present(orig_pmd)) {
> -                       struct page *page =3D pmd_page(orig_pmd);
> +       if (pmd_present(orig_pmd)) {
> +               struct page *page =3D pmd_page(orig_pmd);
>
> -                       folio =3D page_folio(page);
> -                       folio_remove_rmap_pmd(folio, page, vma);
> -                       WARN_ON_ONCE(folio_mapcount(folio) < 0);
> -                       VM_BUG_ON_PAGE(!PageHead(page), page);
> -               } else if (pmd_is_valid_softleaf(orig_pmd)) {
> -                       const softleaf_t entry =3D softleaf_from_pmd(orig=
_pmd);
> +               folio =3D page_folio(page);
> +               folio_remove_rmap_pmd(folio, page, vma);
> +               WARN_ON_ONCE(folio_mapcount(folio) < 0);
> +               VM_BUG_ON_PAGE(!PageHead(page), page);
> +       } else if (pmd_is_valid_softleaf(orig_pmd)) {
> +               const softleaf_t entry =3D softleaf_from_pmd(orig_pmd);
>
> -                       folio =3D softleaf_to_folio(entry);
> -                       flush_needed =3D 0;
> +               folio =3D softleaf_to_folio(entry);
> +               flush_needed =3D 0;
>
> -                       if (!thp_migration_supported())
> -                               WARN_ONCE(1, "Non present huge pmd withou=
t pmd migration enabled!");
> -               }
> +               if (!thp_migration_supported())
> +                       WARN_ONCE(1, "Non present huge pmd without pmd mi=
gration enabled!");
> +       }
>
> -               if (folio_test_anon(folio)) {
> +       if (folio_test_anon(folio)) {
> +               zap_deposited_table(tlb->mm, pmd);
> +               add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
> +       } else {
> +               if (arch_needs_pgtable_deposit())
>                         zap_deposited_table(tlb->mm, pmd);
> -                       add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_=
NR);
> -               } else {
> -                       if (arch_needs_pgtable_deposit())
> -                               zap_deposited_table(tlb->mm, pmd);
> -                       add_mm_counter(tlb->mm, mm_counter_file(folio),
> -                                      -HPAGE_PMD_NR);
> -
> -                       /*
> -                        * Use flush_needed to indicate whether the PMD e=
ntry
> -                        * is present, instead of checking pmd_present() =
again.
> -                        */
> -                       if (flush_needed && pmd_young(orig_pmd) &&
> -                           likely(vma_has_recency(vma)))
> -                               folio_mark_accessed(folio);
> -               }
> +               add_mm_counter(tlb->mm, mm_counter_file(folio),
> +                              -HPAGE_PMD_NR);
>
> -               if (folio_is_device_private(folio)) {
> -                       folio_remove_rmap_pmd(folio, &folio->page, vma);
> -                       WARN_ON_ONCE(folio_mapcount(folio) < 0);
> -                       folio_put(folio);
> -               }
> +               /*
> +                * Use flush_needed to indicate whether the PMD entry
> +                * is present, instead of checking pmd_present() again.
> +                */
> +               if (flush_needed && pmd_young(orig_pmd) &&
> +                   likely(vma_has_recency(vma)))
> +                       folio_mark_accessed(folio);
> +       }
>
> -               spin_unlock(ptl);
> -               if (flush_needed)
> -                       tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD=
_SIZE);
> +       if (folio_is_device_private(folio)) {
> +               folio_remove_rmap_pmd(folio, &folio->page, vma);
> +               WARN_ON_ONCE(folio_mapcount(folio) < 0);
> +               folio_put(folio);
>         }
> +
> +       spin_unlock(ptl);
> +       if (flush_needed)
> +               tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
> +
>         return 1;
>  }
>
> --
> 2.53.0
>


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04F18CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 13:38:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BBD48E00DF; Tue, 14 Oct 2025 09:38:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 445788E0120; Tue, 14 Oct 2025 09:38:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30E7D8E00DF; Tue, 14 Oct 2025 09:38:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1909C8E00DF
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:38:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE0A04774E
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:38:30 +0000 (UTC)
X-FDA: 83996824380.19.D1F5E2B
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf25.hostedemail.com (Postfix) with ESMTP id AF0C1A0007
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:38:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RdWvm1vG;
	spf=pass (imf25.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760449108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A085BtH7ekRyYK8/+lQK6CtKf8LhcnavzYT4kIWkbTg=;
	b=w5DBv7OWSj+Nx/BhwC4HWp3EiD0R8cE4Bg5S816+MXF9mm0NbbmXBslvCbyvaMxjjd/hQM
	6nQytOXianCRyAFUmxoDrgUlU5p03+DmxKFI8y1kt8sAGnw4Vmz8Jq4ZUqTR/BFCfGboGu
	I4vM0tCCAxyDRgXHuPlRpLPbseRc8do=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RdWvm1vG;
	spf=pass (imf25.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760449108; a=rsa-sha256;
	cv=none;
	b=UMVGveFBu9YUX60PR4JW/dTjUtaWiIq4oDDEMKrJkxqMmL9jYLT7jg3YsMrUfWeYKisWbo
	Sh9nusec89fU+A7LPCqMau5w6TzFiCICHtLDDVsm/skMK88bMVZ6E9AM+GzNL7KL/lyrYy
	loUfdaKq08psjWaeIgJzYrvk4Kovhs0=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-339d53f4960so5603536a91.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760449107; x=1761053907; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A085BtH7ekRyYK8/+lQK6CtKf8LhcnavzYT4kIWkbTg=;
        b=RdWvm1vGoCx8vLGU5KN8TsaT8lmrpBuW8cmEZmOMIjLlH7tN9FkIxQoXqox7WQmToe
         cD/4xK+pET12TgHxjhd5Ef4yLShTIr5psI+WY1/vPSsNZIfokgl8p7bNxhDmVfMfxzOZ
         rNVcITu1GQPtxoAe+7QjI/5vdVE2XyuKIbJZSsScv5QIl4po8iAubmvT9OR5e/EX2gBc
         psq1c06gAgCRa/p07kQJ2YFEA0pI++PwyLFG9MeN/bjjOe99+ITIEZFS/1y991vx87TD
         9O2LyjuZ8173KHIu3iTtd/lkQ7j8wbJ2FL6J2N1Q7NdiCfO3r3eHXNyiO0xIRu9S5Uc3
         rKvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760449107; x=1761053907;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A085BtH7ekRyYK8/+lQK6CtKf8LhcnavzYT4kIWkbTg=;
        b=XBe1ovZsTW8LFnZA1o/Wn5cOfxmImSRytflupiCc33dCG6WKhMYWlrlM0ONja+u0/2
         GOAPMTYVNEYAJerfjPPZ9/SlUb0pD1hKQzdv7lMekyNl3YVvOv9JPgtdTg7VT5ZSKRu6
         lgWBthfEpX5zrBgAb8yAQJVmtHX4+qBHQPRhLuUJpesUcZNY3tEEqtxLmgkDbzNaY6Ug
         EGsSEC1LkQaEwBxt9xCQbl8ETKOK6FQIjf9aUurzP1Qmz8WeidDXrpuT6bQiZhxot8d5
         0iqubm5FtpBPlg8FJr9i6zWoTuSabz0v1y1gWKHuOdR0tgzsLyk6kC+cecbTZcC32nEz
         Ci3g==
X-Forwarded-Encrypted: i=1; AJvYcCXvlIhG5FCvmKbKI16DwBpsKhABlhnjXHpWzP3pM1p41w1T95AmmqmqNsjkejiUbBqIbYlHUBAO1w==@kvack.org
X-Gm-Message-State: AOJu0YwqNlMvcg+kovxY18N4TmVdxOxpRUgtm+ulqaBctsLA/Akkqvd/
	ojDcKLlWjcVZd1ZuhyoDBXbZrdjWPZR1r2Kq9yk7cJydA/j2RaKseQXr
X-Gm-Gg: ASbGncuHOzEREU5U/psZTViv1lBlmZ2RLCDeCFm4lf5czwzo5g14J6U2eIUKwy9+B0n
	fKaHfgIdTXrVk/TTHxP414goTTxJ3KEuflmwhXhdgcv4p6pr7UuhgLj8ytqarv6ENx5jsSLQGqt
	9bIIuHnwKVFJCGYD7w2nYnZEFbaDdSipDnlWsTuBjFp6SgOEon87PQwhICvfh6rlleBO/bUTQL6
	iqhaoPe0O1B6dgbgRzVNMURq/JbskupQY8Myv7PEu/XbKMhjbOA8WDrhn1JYG2Jxm20KliGL6bj
	tDdmRq8OENSXBLRmbOEizqRfN4DiXWu9pfzezRzSsbhObRbbJi8s1rdRJl1Lni2/Jyg9P52uITH
	Rw+A6jLPHqX0XKtpTVoIPITnUI6+8ScKsasluA0RyRG901b/6/9bVXT+KScwKdy3BDCk=
X-Google-Smtp-Source: AGHT+IHZoEpNtqb3Er/H8rHrHDUjXVXuJ/umcp1U+VvoRsZ+h9SpEmOctIzSeP+NFNUAR2TR1CliKg==
X-Received: by 2002:a17:90b:3511:b0:32e:5646:d43f with SMTP id 98e67ed59e1d1-33b513b4c25mr34617827a91.19.1760449107333;
        Tue, 14 Oct 2025 06:38:27 -0700 (PDT)
Received: from weg-ThinkPad-P16v-Gen-2 ([2804:30c:166c:ce00:5a20:94db:a4ce:661d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b61a3cbf2sm16117618a91.8.2025.10.14.06.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 06:38:26 -0700 (PDT)
Date: Tue, 14 Oct 2025 10:36:49 -0300
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, craftfever@murena.io, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ksm: use range-walk function to jump over holes in
 scan_get_next_rmap_item
Message-ID: <qrf6mertexxf3hcazexkv6jxokdg5jnsbuixih62w2peq3ooyl@u3mhuopdjrfc>
References: <20251014055828.124522-1-pedrodemargomes@gmail.com>
 <90ed950a-c3bb-46d5-91f9-338f5ca15af6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90ed950a-c3bb-46d5-91f9-338f5ca15af6@redhat.com>
X-Rspamd-Queue-Id: AF0C1A0007
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: z8zqfwq1oedc3bbzjuke8ptromo1mns3
X-HE-Tag: 1760449108-602827
X-HE-Meta: U2FsdGVkX18p1pXOAUGfWuTaWVSn0xE8ybYcnl4A2fYcrx7tsinTfvIofbM/pKyfCRJHl3F18DEuPY5nOEYZfstyve0VZPCHDbohHlkaAtG3z6GdBKQkuK9X/oxCANiyl7nmOYt56drLUOPu+xioEqtwLVxHoLNCqaWm7cTyuxGXmBiUqoY2vCGIu1SeSrKAZFKdfQ17PBhWMAOQ/g1ou0enG4BhT9TiIU5YKdbuJkR9pWhwoqcyRz7bw8rjOqx9V+cAgDSG6M4T6lcwI8taiz/JILMbgJ0MvDW0GoUppwAZOiQYc6h3GPhCkR3Nl76bzT3bz1ZQsedHjH0eT7X5ihKDha/QfIysX3DzNPpX2g6e2CU2Uo1o2nm7Tp5WAgvSOdlBC+yFPaV07mxdlohuHobSrBuD68EeF9k+OHEMtl9EdDbtXo686yrUa7o8BJpWS0D4PzfDPWYwrp97ItJgYMLlJhf3ywsthE8vnDDcU9/64OHcAdVnFboNDDePSDuVKlfXDTZ9sw++aYQi/Qsd5XfvZqy1Ouh7nv59zX/8hqBlKvcqLd71seOrnPts1ipup93jS1wCrdFFQeDF1dKTpUP4oJSRDsVSN+/souRCx2IF1PsMY2h3avnthdNEE/EeoNUU73gKmnPMYKro2ic9H3ER55PWgxqA2+kv6Q00d2wQBr/ypVs8HHdKrFupEZa2I+9GV9ItBJP/yHZug+PsKjoVo57g+d8Wu8pnWMl4Jprj3QLgdTOGYuQlPuxc/l73U9Se6KPhEKSJQwaft8hbEu2cFHlMpD/arh37Ny0EuByoaVTKVbXJ38JPhQg8gBBmTQCy+vzVxVMi4l65VwHoRDuCxjGeVIZI5o+ijX9oj8M+nva3+z2zW5o/rW0Rv7dipG4v3nLeI3F5QylFjVuH48lxlxpKE2HRedb+/zT+O/h3NJI4ZqcmZ4nBQ+15O8iAprZjgjsRHpQu0iHZOfJ
 hoX7xWNN
 YjFQul7rEiSmytCXYopmK1KUgxgxamTa9INuwDAiInRVpy+fRCJ6AOMjFBOQxhPhRTjvZkG4IY2hfwT+LgezPBYojW7A4IFI6f6QTDxy+bgrZZhWD9J+tEENeUe2ItM54kBvM9iKzXvNPDVvUGCGi/xZoCKQ5C9JWLcWG3Bw0oM9pFJZzEhJ5P/pF+EGOBlvOmA2l5U8y4/2Gz0bjGt7a0Wjl9G5X+WqOOPcjcqBRUqPExTXU/tEBklhu1iBZWRzMI2XyI2DgOPlJi3QCPbJ0q5n/9xpjWwEXCEQop3H5cy1rLPt/MYrrfdnXDWYwlb/WF99s5/Z9GT6dVGdJBM4DudF/dmIXJkRu41dgHZCiKtOqhKPfbormvl89YVsjUTBBZr/98eM/KTFi13quDirMSsg5YtF2CjF4CxrXWf0lw2ZLD08IULYSxr/CSMmtxE3jaAGW7WDXzjZqBaFETlQzynv+9VBLt9elFh4UjviH9hIndNDF1V+Uakn2LR003lYlykBLEFqYWt7+E5NfFi82rsjINAlP5cTZdskDPV7z9Yb75GE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 11:26:06AM +0200, David Hildenbrand wrote:
> On 14.10.25 07:58, Pedro Demarchi Gomes wrote:
> > Currently, scan_get_next_rmap_item() walks every page address in a VMA
> > to locate mergeable pages. This becomes highly inefficient when scanning
> > large virtual memory areas that contain mostly unmapped regions.
> > 
> > This patch replaces the per-address lookup with a range walk using
> > walk_page_range(). The range walker allows KSM to skip over entire
> > unmapped holes in a VMA, avoiding unnecessary lookups.
> > 
> > To evaluate this change, I created a test that maps a 1 TB virtual area
> > where only the first and last 10 MB are populated with identical data.
> > With this patch applied, KSM scanned and merged the region approximately
> > seven times faster.
> > 
> > This problem was previously discussed in [1].
> > 
> > [1] https://lore.kernel.org/linux-mm/423de7a3-1c62-4e72-8e79-19a6413e420c@redhat.com/
> > 
> > Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
> > ---
> >   mm/ksm.c | 136 ++++++++++++++++++++++++++++++++-----------------------
> >   1 file changed, 79 insertions(+), 57 deletions(-)
> > 
> > diff --git a/mm/ksm.c b/mm/ksm.c
> > index 3aed0478fdce..584fd987e8ae 100644
> > --- a/mm/ksm.c
> > +++ b/mm/ksm.c
> > @@ -2455,15 +2455,80 @@ static bool should_skip_rmap_item(struct folio *folio,
> >   	return true;
> >   }
> > +struct ksm_walk_private {
> > +	struct page *page;
> > +	struct ksm_rmap_item *rmap_item;
> > +	struct ksm_mm_slot *mm_slot;
> > +};
> > +
> > +static int ksm_walk_test(unsigned long addr, unsigned long next, struct mm_walk *walk)
> > +{
> > +	struct vm_area_struct *vma = walk->vma;
> > +
> > +	if (!vma || !(vma->vm_flags & VM_MERGEABLE))
> 
> The anon_vma check should go in here as well.
> 
> How can we possibly get !vma?
> 
> > +		return 1;
> > +	return 0;
> > +}
> > +
> > +static int ksm_pte_entry(pte_t *pte, unsigned long addr,
> > +			    unsigned long end, struct mm_walk *walk)
> > +{
> > +	struct mm_struct *mm = walk->mm;
> > +	struct vm_area_struct *vma = walk->vma;
> > +	struct ksm_walk_private *private = (struct ksm_walk_private *) walk->private;
> > +	struct ksm_mm_slot *mm_slot = private->mm_slot;
> > +	pte_t ptent = ptep_get(pte);
> > +	struct page *page = pfn_to_online_page(pte_pfn(ptent));
> 
> Oh no.
> 
> vm_normal_page()
> 
> > +	struct ksm_rmap_item *rmap_item;
> > +	struct folio *folio;
> > +
> > +	ksm_scan.address = addr;
> > +
> > +	if (ksm_test_exit(mm))
> > +		return 1;
> > +
> > +	if (!page)
> > +		return 0;
> > +
> > +	folio = page_folio(page);
> > +	if (folio_is_zone_device(folio) || !folio_test_anon(folio))
> > +		return 0;
> > +
> > +	folio_get(folio);
> > +
> > +	flush_anon_page(vma, page, ksm_scan.address);
> > +	flush_dcache_page(page);
> > +	rmap_item = get_next_rmap_item(mm_slot,
> > +		ksm_scan.rmap_list, ksm_scan.address);
> > +	if (rmap_item) {
> > +		ksm_scan.rmap_list =
> > +				&rmap_item->rmap_list;
> > +
> > +		if (should_skip_rmap_item(folio, rmap_item)) {
> > +			folio_put(folio);
> > +			return 0;
> > +		}
> > +		ksm_scan.address = end;
> > +		private->page = page;
> > +	} else
> > +		folio_put(folio);
> > +
> 
> You're under PTL, get_next_rmap_item() will perform an allocation, so that
> won't work.
> 
> Observe how the original code worked around that by performing all magic
> outside of the PTL (folio_walk_end()).
> 
> When you switch to .pmd_entry() (see below) you will be able to handle it.
> 
> What you could also try doing is returing page+folio and letting the caller
> deal with everything starting at the flush_anon_page().
> 
> > +	private->rmap_item = rmap_item;
> > +	return 1;
> > +}
> > +
> > +struct mm_walk_ops walk_ops = {
> > +	.pte_entry = ksm_pte_entry,
> > +	.test_walk = ksm_walk_test,
> > +	.walk_lock = PGWALK_RDLOCK,
> > +};
> 
> It's more complicated: you'd be remapping each PMD to be mapped by PTEs
> first, which is not what we want. You'll have to handle pmd_entry instead of
> pte_entry.
> 
> > +
> >   static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
> >   {
> >   	struct mm_struct *mm;
> >   	struct ksm_mm_slot *mm_slot;
> >   	struct mm_slot *slot;
> > -	struct vm_area_struct *vma;
> > -	struct ksm_rmap_item *rmap_item;
> > -	struct vma_iterator vmi;
> > -	int nid;
> > +	int nid, ret;
> >   	if (list_empty(&ksm_mm_head.slot.mm_node))
> >   		return NULL;
> > @@ -2527,64 +2592,21 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
> >   	slot = &mm_slot->slot;
> >   	mm = slot->mm;
> > -	vma_iter_init(&vmi, mm, ksm_scan.address);
> >   	mmap_read_lock(mm);
> >   	if (ksm_test_exit(mm))
> >   		goto no_vmas;
> > -	for_each_vma(vmi, vma) {
> > -		if (!(vma->vm_flags & VM_MERGEABLE))
> > -			continue;
> > -		if (ksm_scan.address < vma->vm_start)
> > -			ksm_scan.address = vma->vm_start;
> > -		if (!vma->anon_vma)
> > -			ksm_scan.address = vma->vm_end;
> > -
> > -		while (ksm_scan.address < vma->vm_end) {
> > -			struct page *tmp_page = NULL;
> > -			struct folio_walk fw;
> > -			struct folio *folio;
> > -
> > -			if (ksm_test_exit(mm))
> > -				break;
> > -
> > -			folio = folio_walk_start(&fw, vma, ksm_scan.address, 0);
> > -			if (folio) {
> > -				if (!folio_is_zone_device(folio) &&
> > -				     folio_test_anon(folio)) {
> > -					folio_get(folio);
> > -					tmp_page = fw.page;
> > -				}
> > -				folio_walk_end(&fw, vma);
> > -			}
> > -
> > -			if (tmp_page) {
> > -				flush_anon_page(vma, tmp_page, ksm_scan.address);
> > -				flush_dcache_page(tmp_page);
> > -				rmap_item = get_next_rmap_item(mm_slot,
> > -					ksm_scan.rmap_list, ksm_scan.address);
> > -				if (rmap_item) {
> > -					ksm_scan.rmap_list =
> > -							&rmap_item->rmap_list;
> > -
> > -					if (should_skip_rmap_item(folio, rmap_item)) {
> > -						folio_put(folio);
> > -						goto next_page;
> > -					}
> > -
> > -					ksm_scan.address += PAGE_SIZE;
> > -					*page = tmp_page;
> > -				} else {
> > -					folio_put(folio);
> > -				}
> > -				mmap_read_unlock(mm);
> > -				return rmap_item;
> > -			}
> > -next_page:
> > -			ksm_scan.address += PAGE_SIZE;
> > -			cond_resched();
> 
> You're dropping all cond_resched(), which will be a problem.
> 
> > -		}
> > +	struct ksm_walk_private walk_private = {
> > +		.page = NULL,
> > +		.rmap_item = NULL,
> > +		.mm_slot = ksm_scan.mm_slot
> > +	};
> 
> empty line missing
> 
> > +	ret = walk_page_range(mm, ksm_scan.address, -1, &walk_ops, (void *) &walk_private);
> > +	*page = walk_private.page;
> > +	if (ret) {
> > +		mmap_read_unlock(mm);
> > +		return walk_private.rmap_item;
> >   	}
> >   	if (ksm_test_exit(mm)) {
> 
> 
> -- 
> Cheers
> 
> David / dhildenb
> 

Thanks for the explanations, I will send a v2 shortly.


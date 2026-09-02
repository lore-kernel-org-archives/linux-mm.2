Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19BFAC61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 04:01:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19E6E6B0088; Wed,  2 Sep 2026 00:01:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14F946B008A; Wed,  2 Sep 2026 00:01:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03E886B008C; Wed,  2 Sep 2026 00:01:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8816F6B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:01:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 019A1120719
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:01:11 +0000 (UTC)
X-FDA: 85167471984.30.2A7B7D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3FE9A40003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:01:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UHe6kNZf;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788321670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wt1NDs6v7QlaW4AX3BZSW4pHiL3RYherAJk3Zng4lw4=;
	b=l1kDMYFZG69mT4DNwN3f9514I7l6UKjNjZj98wvW9PugOl8F/b+u9g3FWRhA0mjtruUd2z
	7IyCm0zQMpoulWqvIv0QTXTtuFltU8gEDZ3Laqi0NGEgpsqsP+Pgh2ahPZ3rQsynQy8Tmq
	TQFRAFQw3P8o01RD4k0JvVsYUSKuiCA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788321670;
	b=W+VGGFbVM8il3llVcdTUXp1nfq1FyUS3BadG5I3D2y7keMo+X7dQVK2gpxH3qHx/HaWmgP
	6ppgT3LkXzy/guNeSXS4JkLMZ7iS3J5Zorqp2/dF5UurGPJkdcaYq8f57CuTMpHlFXdnm3
	WBBCVmYLZMbe7aafGoIe9Eu7Jbr12+c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UHe6kNZf;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D891643C83;
	Wed,  2 Sep 2026 04:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FD21F000E9;
	Wed,  2 Sep 2026 04:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788321668;
	bh=wt1NDs6v7QlaW4AX3BZSW4pHiL3RYherAJk3Zng4lw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UHe6kNZf5rmhs+WiJaE82J7FaSKP8wwhWRLqIqODlnTNAtAdWzKDqJDhpZ7the4gb
	 BySaOQHTe4g3MPz73i3oFeR+EbkrOkUWYsXkG1tl7JBaS1H2v5d/chbemHYKc6WlBn
	 9uB0iJT5Qh3ImL8n1gbAsrOpqoG2RQB3puVsguSFmSWSEZbs1WUxm6jbB82TZaiPIs
	 YCVtCDh6wfFGeE4zr7CnK8sTKWRgDdtHElW0YpvwGYu6R7/F9BrF2T3yeBgMyBfXnT
	 buYjrwIukzSISdTA3Ma1Tfratnah1sTjb1caM3mtRH4o7VCRiubTycz/9lQlgLDm0v
	 vIcTaWdhpFnwg==
From: SJ Park <sj@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: SJ Park <sj@kernel.org>,
	Nathan Gao <zcgao@amazon.com>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	david@kernel.org,
	ryan.roberts@arm.com
Subject: Re: [PATCH v3] mm/damon/ops-common: use a page-aligned address in damon_ptep_mkold()
Date: Tue,  1 Sep 2026 21:01:00 -0700
Message-ID: <20260902040101.83573-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <ee0f3f47-f6c0-4b3c-807c-db80385db3b8@linux.alibaba.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3FE9A40003
X-Stat-Signature: tbx7f4rrnjpkq8mkxrsf7fi4nr3nsuzi
X-HE-Tag: 1788321670-755598
X-HE-Meta: U2FsdGVkX18brsPcCtcgFRCVEcU0MGnfb1sFS3AKGB1AJvMTQmrdKBNjM3WEjL7zUw2IVw8qbnILqGCn5X3LB98SyLwD1k3d9g+RulKq84ufs9b49q30H1OLGaJq1m6eQTkn2M2jNEQGkhBl95FAqlPiUEBUMCQ2nH+7H+uWKI9oWaO9zSNdV4PGX7Q4G6C5FZUm6wyLbytfA8vUW9OCuy7ynd45+K92GLxyvX7Up5SlZ/S0+ZFp4cSedr8Q8TJUgEQ+7U406m2VAE1yCfQ+4LP9GFQMdfTFUBca/mUbp0Bwbg+c+nb3EpDRhssbO9OwiSkGZ+fi6D1nUJzVemGtps1n/VUNYu/iPKiJpmyBUvcB32exsYJUJ/lVxNpWpvf98Y/sslwClHogMC7Yqjpnelu1uQOzS6TiI/bgPvcpCdMTd5t/de6hcCKwbp1Fdshr4x/apvJqh8EjvphSKvxij1/rFncgPGF5yLnCr5b9Ml7YtL69SylpcHU9SM6kr7Sj4K7UX/znVytsSWbPw212DRMPryugWQtqb6IqdXjYitpSI2rdC4J/cf5CS+bZn4k77L8xlClRX5Xu7oqWFLU9s0nMNr0OWFskf5c6bYgxqMQZgSGEVAadCSNt6fzXGB32AbqEQFqHIVTOqti71hH+O/SwADWXmGsJvTr2/d6eoQOPlF4Dyu70Y4dL28llG3a5f+ZDzkxeVTnk8mHRnw5B2bBw6EjSy4wReLr7jeglVqAXYxhEPAbbjQn1l0CAni0B355dnrCBoP5c6x/fj8i7NOVjnqwyPHWJDCGaNqBGIPab1vicF+9i4GNOAaXS607eNmQ3kuz6AEJsLePNXsKOt0B7Ody6+BhmlDhi8ypM1zSLVXCOdr80VAQxrAhRNe+4EHpXKOKi2WTuDWvUGtZulWAk653xZC8STgeRovzcUIIU/6ZazE7V62uR9+8Mls26V7OpCIVAHUOZFEaI7pn
 EguFqVVi
 CUwn2KY4YeyVvFjT/XR9HA92s5u6nDXMxVQajTTfEhk1JMTdHqrUYDRiE2XX2uWfd+YCEBhUyTu59DVz90kC0v6+TRkYAhIAsX/YZyXEaDwjTWl7u4/KFN86My2VSrsuMvJL9j69uwaDzZtWYyrzEvfBtQpo+Bu6Zto9WZHirzQvhV3B2v2HfUXTkoOQLNbF/mF+/Q2CfeBI9qAIehnDKduS1uRWzAbyZmGXpUjxvaUQLZQstqlihahAAc/EAaf61AHkR1/YPCUTY1M1rDtLkUkWoxTrU1YTiNGk9flAGPlqth33akJecqzx6hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2 Sep 2026 10:34:39 +0800 Baolin Wang <baolin.wang@linux.alibaba.com> wrote:

> 
> 
> On 9/2/26 8:11 AM, SJ Park wrote:
> > On Tue, 1 Sep 2026 13:10:01 -0700 Nathan Gao <zcgao@amazon.com> wrote:
> > 
> >> __damon_va_prepare_access_check() picks a random byte address within the
> >> region and stores it in r->sampling_addr. damon_va_mkold() passes it into
> >> a page table walk, which hands it to damon_ptep_mkold() as the address of
> >> the page to sample:
> >>
> >>    damon_va_mkold(mm, r->sampling_addr)
> >>      damon_va_walk_page_range(mm, addr, addr + 1)
> >>        damon_mkold_pmd_entry()
> >>          damon_ptep_mkold(pte, vma, addr)
> >>            ptep_test_and_clear_young(vma, addr, pte)
> >>            mmu_notifier_clear_young(mm, addr, addr + PAGE_SIZE)
> >>
> >> For arm64, before commit 6f0e1142173a ("arm64: mm: support batch
> >> clearing of the young flag for large folios"), the contpte helper walked
> >> exactly CONT_PTES entries from the aligned-down page table pointer and
> >> used @addr only to pass down to each entry, so an unaligned value was
> >> harmless:
> >>
> >>          ptep = contpte_align_down(ptep);
> >>          addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
> >>          for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)
> >>
> >> Now the range to walk is derived from @addr instead: end = addr +
> >> nr * PAGE_SIZE, rounded up to CONT_PTE_SIZE. For a sample in the last
> >> page of a contpte block, the sub-page offset puts end just past the
> >> block boundary, so the round-up lands a whole block further and the
> >> walk clears PTE_AF in CONT_PTES entries beyond the sampled block. For
> >> the last block in a page table page, those entries are past the end of
> >> that page, so the walk writes into the page that follows.
> > 
> > I just wanted to call out again that I'm wondering if we could restore the
> > unaligned address support in the helper.  E.g., as a very dirty hack that I can
> > imagine off the top of my head,
> > 
> > '''
> > --- a/arch/arm64/mm/contpte.c
> > +++ b/arch/arm64/mm/contpte.c
> > @@ -30,6 +30,7 @@ static inline pte_t *contpte_align_addr_ptep(unsigned long *start,
> >                                               unsigned long *end, pte_t *ptep,
> >                                               unsigned int nr)
> >   {
> > +       *start = PAGE_ALIGN_DOWN(*start);
> >          /*
> >           * Note: caller must ensure these nr PTEs are consecutive (present)
> >           * PTEs that map consecutive pages of the same large folio within a
> > '''
> > 
> > I and Nathan have no strong clue, so we are looking for Baolin and others'
> > opinion.
> > 
> > While waiting for the opinions, I and Nathan agree we should stop bleeding with
> > a pinpoint hotfix change in DAMON.
> 
> Thanks for the reporting.
> 
> IMO, we could let the arch low-level functions handle the alignment of 
> addr, but that would also require changing functions like 
> contpte_clear_young_dirty_ptes(), contpte_set_ptes() and so on, which 
> would cause a lot of churn? (they also assume that addr is page aligned).
> 
> Since the arch low-level functions basically assume that addr is 
> page-size aligned, and the addr handling in the mm core is also mostly 
> page-size aligned, I think the caller guaranteeing that addr is 
> page-size aligned is a reasonable fix. So:

Thank you for your opinion, Baolin.  That makes sense to me.  I will try to
further revisit DAMON code to make alignment be more complete and consistent
whenever needed.

> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>


Thanks,
SJ


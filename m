Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA5BC87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 22:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 489DE6B008A; Wed, 30 Jul 2025 18:24:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 422AB6B008C; Wed, 30 Jul 2025 18:24:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 311216B0092; Wed, 30 Jul 2025 18:24:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F7FD6B008A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 18:24:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9476E13474A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 22:24:42 +0000 (UTC)
X-FDA: 83722361604.18.E62FC5E
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf12.hostedemail.com (Postfix) with ESMTP id C47FF40009
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 22:24:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hfmcTtKa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=pyyjason@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753914280; a=rsa-sha256;
	cv=none;
	b=euV97GwCvPiVCCRfITZIjZWI5P2JFsfYESluPGiTRccMCW+syitJ90BJK/LrAbYUF0rkma
	BL2t/YrTs2par8tV92HL6H37mNo2YMTRItySJWJRHnfRnDWe7zSXKcNpNnDM3iRmoOJL82
	VUeUykp9b5IByQIHyEh/hLKJutAitYA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hfmcTtKa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=pyyjason@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753914280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OCbT9/cz+rXGQ8ARnOwy7QkIK/KpaHmQmlR+7AOK0Pc=;
	b=L1lZ+3kL4yZxgIC/lkpSC/69DAhc5fHQeRJY1hNcICsTaUwNLC1Qc99/QFUQcSLpW/crHe
	VG1tWhpxaeToDR7uj/Gx6vqDAiye9Mbf+Y9UQYumdHmWRpxKoBqoRZmuNuOxBKymbCRed1
	NDrvf6aWbUgkFGdccRgWeAUl+NVy5WM=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-451d41e1ad1so1948945e9.1
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 15:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753914279; x=1754519079; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OCbT9/cz+rXGQ8ARnOwy7QkIK/KpaHmQmlR+7AOK0Pc=;
        b=hfmcTtKa0tSRo+iGtL3MzOvBqSSv+njR2/h5r9SkYJ/T0tFSwBzy7JMpsFgPNVsJN7
         oPOzruCy5c+6Ci7v4A5gx6Ov67MCMFs5g9AbKGha/xs3+oGNyRCQl8jlDIML7QHlze5/
         6dgEwgIUnO6INjTAzwffzzKsqRYMmeogLfYWuHKNK13sqdm1YByg0ohW0Y/DxgHpLy/q
         mmu3C1GM2THMKxhKXcWJRXkC1BZsI2+0/fQple2zSymyiari0nk3fo5MUFDtAYiT8/g6
         d7+e+qatMmLM8fFo9MSm4gsRQiddjgXIGUolIJ9BXefVaFNIKADaUaSH0/G7TGRcj7Lp
         gRKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753914279; x=1754519079;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OCbT9/cz+rXGQ8ARnOwy7QkIK/KpaHmQmlR+7AOK0Pc=;
        b=ThyaS5R2X3EEilTwDEfkg7ZgLTp1Hir3HfV4d1rdoEEIcv+QSc5XfLO7tRc2uLZcyu
         NuFjWW3bD/8AtreC8CyNLygShQ/fcE9/dZ3BcHU1Q4IAfnidcnnXWgkVN7WwLzMENVVy
         xcAxhhLo+20IUz9DcRTK/e72vuyMsv9WgUmaabsde864qSvHVKqC+roiMxathaA2VlJo
         zEQwY8Q/W23Of4S/aJwGZipYg32WIiRNlA5kzOG4LtPd+9s+yu19YPcE1+R+xjrZdAXD
         CX98VpOCZb9Gm8B+kcEMkEH/p4wdWGr+MapalqNcNA3sNEYXh6jFT74kyZlGZF5g9y1X
         2iRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXidBXoJ+Al2ovsH4BaEj8VBVGuOgspYK3MMVLOX/Ju4hv26rrNL6xH158JZqne/SFvpA0Hv2qvUQ==@kvack.org
X-Gm-Message-State: AOJu0Yx0FIrIDR+pgDnChlIALOSgHArZlBcQ7V91SF3vNBlJInDPxm+t
	+kJIAH2mUCkFecWR+BtzMA4zeAfRducX4Y0GhvrWnIC7YCZO+jVNaOqH
X-Gm-Gg: ASbGncuFXhNLbuzStToffsRq1Rg35WHXce/xzIAz/4PANDdxxY8ioW/zOKCi96Tk8Ri
	khkGNlPRpIo01R0qP6q5iatuFnKLTGXdVvo0tr5NS5QkT052KyIdJvukHzbdvlOf0ARBPp8SEfG
	zIfd+fBo+nyDRMGSpVFLbYGBhtuPE9wsnU2zCKqMZHigYitJgoUNEBgw+sdBi9V+DGVvE5annnS
	o4WGZKPJEy+/5NlgSM2piSmNvuJEbhvPU+owWowRZ+ok9zvJZxfXwRIlrZpqER11xJ1vr/IgwHd
	Zq/ntWjDhUW6iHJ3kVCEbljsQNcRwjhWLBE4N2TDZHQ4k61qVs/t725sroJtBFo8hEWVjeSM6lO
	YMIAyFnzASyVB1AE0np0BweBkcbzuwjRM9MBiTw==
X-Google-Smtp-Source: AGHT+IEHwJ0OF/CEB1lfb4+OzjypEm8jkKSqIIDGkUMeRFWaULpe2YCUA7fNQcqZpUUGznElVR0FJg==
X-Received: by 2002:a05:600c:4fd3:b0:453:697:6f08 with SMTP id 5b1f17b1804b1-45892bd1a95mr42393275e9.26.1753914278856;
        Wed, 30 Jul 2025 15:24:38 -0700 (PDT)
Received: from devbig569.cln6.facebook.com ([2a03:2880:31ff:3::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458953f8e0dsm41450315e9.31.2025.07.30.15.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 15:24:38 -0700 (PDT)
Date: Wed, 30 Jul 2025 15:24:36 -0700
From: Yueyang Pan <pyyjason@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>, damon@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] mm/damon: Add damos_stat support for vaddr
Message-ID: <aIqbpFsoqbt77j8f@devbig569.cln6.facebook.com>
References: <cover.1753794408.git.pyyjason@gmail.com>
 <44a30f700fdcf4470318ef5cd248ba98c59b77a2.1753794408.git.pyyjason@gmail.com>
 <0cb3d5a5-683b-4dba-90a8-b45ab83eec53@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0cb3d5a5-683b-4dba-90a8-b45ab83eec53@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C47FF40009
X-Stat-Signature: wjaa77ht48anhm69hiafdc5xrrgf5yiq
X-HE-Tag: 1753914280-774175
X-HE-Meta: U2FsdGVkX18Lr+aqn64S0PtjUXsz1iAyE9DT/yJgOvIPV5gT+nOMtOabtyIcKrPlxktCcu4HbIY582HC9GPcZGJT1oautRttIFu8EhgNCmW77s6sc4oYy2POzLouka4+0JrXdR2SzrSBGtP7QpabG2hkC8kfq4fHJg37WS+d1mPpgJxhjO07RLSzrR6I4sM5YJ5n3W8w/6hMY8lhP4Ad9PtqDp8S2PQvXWLeNujOXhVQRvjK2kGmyZJpvwtHULNVOV/z+GDwFaZg+9aQWitLHqsxqTlWDaYqvktvLNCaDNanJfqtpr+joxzRLQbVaeCXRiaR1kBwxFz+ILWmpfCLHJ1fAIHaVLUnJfbdclQYaYmSjUSYQEsUt2VvuPnV/aSr1MhC5m+HxIzPW3ceepYsbofT3drpBhDjWxthAECV6EOG+8XC6a7a6wPREaaLHlIPUi58gwKvlC609j47q85+dsGdEm0H8jn7yEcCQQhBJn+aVBpmIyfQGnD5OexkbwIBc0CB+o9XeHz9EYy61sPsk2pdgcPxDlxbQLnc+N/6kXCT/TvN9xB3PQ7xnLyKFknYFBiO/Sm65uUrrEr9+2RxpTuH6crODBxlMX4Ee6ItEh7Ov9Nx87Gr2Z+WmlvwcU45mQP3svlSdYcc16bd6ZyURKnK7UmdGYHGuItQl/A/5VJUMilnWB1otZq9yvuKDv5A/MWlOgFnfZ3494cuBsF3wsM1WmbZP/jxt0/JlEcjHQYo0v8knLyGzj3Ef+Z3fSpK7+wj5X3Dy3k62QtGGLl42c0FxTdO0f4SmLaR6HkSWU2Rr889k5hzzINaFnFYa5XItrot9ukTpP4STo0tvxCKsC+t7E8KWdSs6VGv4kWco+dTfDDnWtCRHE+b42gRLO0LNkSJFUN5qMjRvyjcYupiOceF0BzVvu1to7n59aiXgblMdiArZLa6SYN5NLY86qcb3QxbHGgK3HJRtVc8rAL
 nsNV4ssV
 Y5Q8OvNH4W0Nlx7f+GpfL4qtYGmEBysdvLPOQY6Xe7l8QEKgysQhCtdkC/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 04:11:32PM +0200, David Hildenbrand wrote:
> On 29.07.25 15:53, Yueyang Pan wrote:
> > From: PanJason <pyyjason@gmail.com>
> > 
> > This patch adds support for damos_stat in virtual address space.
> > It leverages the walk_page_range to walk the page table and gets
> > the folio from page table. The last folio scanned is stored in
> > damos->last_applied to prevent double counting.
> > ---
> >   mm/damon/vaddr.c | 113 ++++++++++++++++++++++++++++++++++++++++++++++-
> >   1 file changed, 112 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> > index 87e825349bdf..3e319b51cfd4 100644
> > --- a/mm/damon/vaddr.c
> > +++ b/mm/damon/vaddr.c
> > @@ -890,6 +890,117 @@ static unsigned long damos_va_migrate(struct damon_target *target,
> >   	return applied * PAGE_SIZE;
> >   }
> > +struct damos_va_stat_private {
> > +	struct damos *scheme;
> > +	unsigned long *sz_filter_passed;
> > +};
> > +
> > +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > +static int damos_va_stat_pmd_entry(pmd_t *pmd, unsigned long addr,
> > +		unsigned long next, struct mm_walk *walk)
> > +{
> > +	struct damos_va_stat_private *priv = walk->private;
> > +	struct damos *s = priv->scheme;
> > +	unsigned long *sz_filter_passed = priv->sz_filter_passed;
> > +	struct folio *folio;
> > +	spinlock_t *ptl;
> > +	pmd_t pmde;
> > +
> > +	ptl = pmd_lock(walk->mm, pmd);
> > +	pmde = pmdp_get(pmd);
> > +
> > +	if (!pmd_present(pmde) || !pmd_trans_huge(pmde))
> > +		goto unlock;
> > +
> > +	/* Tell page walk code to not split the PMD */
> > +	walk->action = ACTION_CONTINUE;
> > +
> > +	folio = damon_get_folio(pmd_pfn(pmde));
> > +	if (!folio)
> > +		goto unlock;
> > +
> > +	if (damon_invalid_damos_folio(folio, s))
> > +		goto update_last_applied;
> > +
> > +	if (!damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd)){
> > +		*sz_filter_passed += folio_size(folio);
> 
> See my comment below regarding vm_normal_page and folio references.
> 
> But this split into two handlers is fairly odd. Usually we only have a
> pmd_entry callback (see madvise_cold_or_pageout_pte_range as an example),
> and handle !CONFIG_TRANSPARENT_HUGEPAGE in there.
> 
> Then, there is also no need to mess with ACTION_CONTINUE
> 

Hi David. Thanks for your comment. I was not aware of the convention so I
followed the existing code. I had a discussion with SJ today and in the
next version I will change this by combining *pmd_entry() and *pte_entry().
We will also format the existing code in future patches.

> > +	}
> > +
> > +	folio_put(folio);
> > +update_last_applied:
> > +	s->last_applied = folio;
> > +unlock:
> > +	spin_unlock(ptl);
> > +	return 0;
> > +}
> > +#else
> > +#define damon_va_stat_pmd_entry NULL
> > +#endif
> > +
> > +static int damos_va_stat_pte_entry(pte_t *pte, unsigned long addr,
> > +		unsigned long next, struct mm_walk *walk)
> > +{
> > +	struct damos_va_stat_private *priv = walk->private;
> > +	struct damos *s = priv->scheme;
> > +	unsigned long *sz_filter_passed = priv->sz_filter_passed;
> > +	struct folio *folio;
> > +	pte_t ptent;
> > +
> > +	ptent = ptep_get(pte);
> > +	if (pte_none(ptent) || !pte_present(ptent))
> > +		return 0;
> > +
> > +	folio = damon_get_folio(pte_pfn(ptent));
> > +	if (!folio)
> > +		return 0;
> 
> We have vm_normal_folio() and friends for a reason -- so you don't have to
> do pte_pfn() manually.
> 
> ... and now I am confused. We are holding the PTL, so why would you have to
> grab+put a folio reference here *at all*.
> 

Thanks for pointing out. I thought someone could still change the folio and
realized it could not happen with PTL. I will use vm_normal_folio* in the
next version.

> -- 
> Cheers,
> 
> David / dhildenb
> 


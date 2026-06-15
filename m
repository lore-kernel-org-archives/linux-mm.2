Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24102CD8CA8
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 02:03:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 817B96B0005; Sun, 14 Jun 2026 22:03:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EFC46B008A; Sun, 14 Jun 2026 22:03:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B7626B008C; Sun, 14 Jun 2026 22:03:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5AA356B0005
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 22:03:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 230308EE9F
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 02:03:56 +0000 (UTC)
X-FDA: 84880501272.12.5C12504
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0F1584000A
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 02:03:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aaPPRjIz;
	spf=pass (imf11.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781489034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=faXAzm7lu2fEE9XNMZTzBIJDaawJFMH4g9weyrPtzws=;
	b=s8LQa6N9v3NCH7XtG7bSYxCWzGUfJ2gNgMftRyrJT0cAY7cT6MopeTkmFp2lRmfEGD10QA
	CRLcbfiXXKG2+MbD/DqX1DTyNA+enWvTNHXkkVr361NteOHc2E/YbhXCTQyi5ASMFZXlV8
	4hYr6w0vD4e0i4K25JBx6X9BqH6aM7A=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781489034;
	b=nBESbKXg0VS2wba2MlQeHczLVLgef4F0Q9DCx5/0Ww0f/Uadd0fMAIlMF2MsWnpQZu1OUO
	yB7FuPrpEyD02MgPT32F18WRymaiIEl84nPkUrwuw08t72zV6e+jWSOCV94Q98/XK8jSnG
	H55dvF7JX4uH4Ug7v7Zb08uBueAhDuE=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aaPPRjIz;
	spf=pass (imf11.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4891b4934ffso75665e9.0
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 19:03:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781489032; cv=none;
        d=google.com; s=arc-20240605;
        b=bi+VeS9ghzgBy3yzuVQf8DwDS+/7QVwYrIIK2aFVrrJFkE032ECHj6fC8Ksz0Y3HxL
         ZqNNF7NC5ugdHakF4p/Dl/q4/BwhilGqcrAf7YAz6YVfUVwueYf28BqemNq8z8P3ZHfL
         ptHwvoIOFjzUs4uinFAUMI4BLbJdd4Mimi3sNpKJ3jTrhrD151x9QmqJahatKJg7vBri
         plLQXhdixmJOeHKi68NbC2ZIXMLqoDHAonTuU9qXL0t928LE81BJkMSHgt/Un4GS9czp
         PBAWOZn2W3cw83bgcivbGXFpYY0YulQTnZdcT1gCPoFy9Reib5ONOFf6Ruihi9bnwnYG
         gnog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=faXAzm7lu2fEE9XNMZTzBIJDaawJFMH4g9weyrPtzws=;
        fh=Rq32/AfTDexGNkC/HMXiXIgY3WWFxjU8xML2IF6+Nvg=;
        b=A/X/DwD4qOBR0uBj+irsI7FVhwOB7Z+wQ1fgAm2nvg3F7xFBtIRv6yY0dFZl64KAAt
         beLCgBbHro73+JgbG2Ta5ZEZQL1tHxFuhl6z7u2sIRwZfX4GDcEgo7W4jGGyplzcKApr
         1zyqhgEmxt3cEgia8KPiO/0TXHMVuuEwzG+nizo3FtGmYqetmJksetI3Q2/l5nNOt/is
         6vZmiU4ZDo0/c69Fn0CEE38AJmdkWMYUhvRtAvopyFhMvxWEniVrKlHRaqqCE9KCL1fW
         Gr/M/sDKKNTOVo495kjLsSQ1+DmC6/w6BBmf3Qoa2PQ3htDGXwM+tVQT92K/rzuHmkgP
         Fg1Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781489032; x=1782093832; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=faXAzm7lu2fEE9XNMZTzBIJDaawJFMH4g9weyrPtzws=;
        b=aaPPRjIzJw30rmS+sDadjvj79Xx0VWVl2K/bCPE9qVbTL3YzbPDIsB1BPkfw6L1Hci
         GkdLz0NOKMk9WfjE2FPqFazVlNUmvUTyD8XNeEXTQi2B2wsoIKfJFN8KC5kX+yxTg+lH
         1iZCZLM7m4rVm4EEmyhELWxVSzdBIVx/6gz6OJMnQARpn6dCFNV5uHln60uzuHD3x07W
         ue75GeyzVaJWhvmpGrSSWbAgfH/89pq6NszRf9Azsahq/xYK+fBmJUJzpgtS8PP9YLkY
         MJAw6R3pS6Wyum1UIHrZobOgLmuYEt/D5V56HhjAPE6/JMIjMQN8he6Iq4X6D2DPatXz
         h1JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781489032; x=1782093832;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=faXAzm7lu2fEE9XNMZTzBIJDaawJFMH4g9weyrPtzws=;
        b=SYTn2dc+5WVMTlwOIFOh6B0VE0UZPQuPquO9NCY/dKbzwrKBM36yCUUECYGc/EWYEG
         qwXgdOSvcGfTchubrLeVlSgdvJn+B1UT/lxX/oeI97Nr5RTxb3xGpQDOgIQD4KAamCTc
         165M8BJGkETY8tDcVQBiQ+ElFZ0/1AIvtn5pibasNtAhcf/zA9t4PZycmZPIZu1XXO1H
         Whd03WWSdiPsH0utSFZ69WQ5p1UDb7q8UbKUY+MwSindUXJBG5lkgnvGG6hh4XrpDmvb
         zIQbSGHU8OmIFZua4TN2ijHzqangDNQ+cBuUcSTDxgGGDWPLLUy8nHVMX+4uR92QY2zT
         R8ZA==
X-Forwarded-Encrypted: i=1; AFNElJ8XLt42RV1AKC+qiBze+vTEH00Ifc1lUMRf5Sig95Dzsly0iEq07cpVwCOwq/yF9bFFuK5TFTULqw==@kvack.org
X-Gm-Message-State: AOJu0YyuMm7pWp+ibFfxTn6VRvpD8fxYZMNPtu5njbAsL+BMGgQaL+hW
	ldFiZxbPxdpoDjylu/+2gIDo6isrnpeX77OY1dLLrLTzRnOwhPJTIKfG6OI0ZynNg/7/hTCbSVa
	p7a+6RI+2RCblMoNKImWNvSNw9pVs094U86VIhXz7
X-Gm-Gg: Acq92OHUnMNXsMz1eEAbSES6lKxURa7OSzwmDeNZGLV//2uESXrwWUpF6d4Qzj32Lm2
	9nrUFDpZS18N5jrPcFTVqFLd2i7HWHGvo2BFxNx9VQ40TZORoart2+Eju8RwemmKeLaQXkW0VpV
	mi5QdmHbynO2tlxhsa27Li9XV2D03Dn6VMeqsd+zW7bkOw0czlmy/aWJSqX+yLaSodWVDezImS4
	3f0ir2CwJXMuERXos1iBHZKGgGjbxQn11jzHgR5t6i/Xs3+syy3s2TrBBN5TyL1srEr490lcjQA
	eR08s+HquHBPqqqIXGEKI4Mrdabjyr0efrRS/wU=
X-Received: by 2002:a05:600c:1592:b0:490:af6a:562a with SMTP id
 5b1f17b1804b1-49221859859mr1274595e9.9.1781489032029; Sun, 14 Jun 2026
 19:03:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260531055829.3636554-1-jiaqiyan@google.com> <20260531055829.3636554-2-jiaqiyan@google.com>
 <84a0b176-8534-e03a-9e6e-400c74ddab0b@huawei.com>
In-Reply-To: <84a0b176-8534-e03a-9e6e-400c74ddab0b@huawei.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Sun, 14 Jun 2026 19:03:40 -0700
X-Gm-Features: AVVi8CdOjOUJMugqpGddZ9N1HeHgKh2UNdb4GB5bnvXAiFzAbt5AUcrIgs1OxJE
Message-ID: <CACw3F52=BSgQwsgVXAVDov3JGBfUC_LSZ6cz8ixSYeLVB6iT0A@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] mm/page_alloc: only free healthy pages in
 high-order has_hwpoisoned folio
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: osalvador@suse.de, lorenzo.stoakes@oracle.com, jackmanb@google.com, 
	hannes@cmpxchg.org, nao.horiguchi@gmail.com, david@kernel.org, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, muchun.song@linux.dev, 
	liam@infradead.org, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	vbabka@suse.cz, rppt@kernel.org, shuah@kernel.org, surenb@google.com, 
	mhocko@suse.com, boudewijn@delta-utec.com, ljs@kernel.org, 
	osalvador@kernel.org, ziy@nvidia.com, harry.yoo@oracle.com, 
	willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0F1584000A
X-Rspam-User: 
X-Stat-Signature: y1o66hzxnrmhc5hcgyhfk5xi3dhzgzbk
X-Rspamd-Server: rspam08
X-HE-Tag: 1781489033-450345
X-HE-Meta: U2FsdGVkX19cnecIzrWuYprIzUONVrtMYLhBPSWstxwnMXlSNn/32s/vucsZ5i/aIvd1Jlbj3Ie5Dqxc3V5IWwpYv45yt4AX6EFCrhQJrtIPuyY6UDA8tnuMlP4UfeTGqDDkGSPZCLvMDs41rI/s0TaMNI3gv5FrK//GIFat7BcDoTSVySiJkc0v2IGzI3xlLx0cwxYROQjba+vpgbFfdbAHitq5RwlH/yZz631vfj5/zfCyoyusV5vi75T0D6DYbm7iLsC+KlWSpxg94/9qGaXqsrr8vZoKGDkHA9/kBinzcEja4nSnGTKfQZGKULn58Q/1Wgw/F8NA1zf2mVGzNU0GssG4KaZJa9bxrAZuHir3ufwc6w3EfdH1tKGqhFxhdCxmOOeDKSXoBILJF1Bx9OLQaeO/cH3DcbIZT+NaJMucNEVbDwjkw/GeMEQ66+XhL/Bk+EUwvn20C/3gg3wtP8+rc7yq+mR87AcIrJgeUO5t40m23QqXJRCxtyeq5P1atG4vgrx8s4gYPMS/TDvh6ggd+b5UVfl6ILJyXpEXzdkLfVNS+eRVQdHwJMdNnumuDRQnJi7KcN+E7UePPLvNbBImcSiQQnzGCHL+Ky57buqk9GcgWzHSuXFawgkdaoQzWUD+31zZu5XaEFBLz+ctXZBLPfu8DsSUYHAK9dOYISid0MyohMnijhQuZvQ2S69ooFg3AQQmAytYLzK8MlAbFHVAWpNY98WeZwDSG7LQrZ4Ik0b0eZatMdwWXSc7VCB5BPDroJiYgjg3u1HlWrycyVbovx4futYZm8GJg99oQDWhD5jy3XQBVirebf4wUD/k1vzx3ACJ0AEq3aA1G+6eG3ZBCOudzF+ZKYqQq/2uwYC/Fb+rLXyDIybdTxJLKvgl55JBJflISJFCh5jw/SsMd9++uQOtq1UM0ogr3m0lQoRz8TGvy1B6GyoS13WM2wnN13efY+hXBcSfiYG/uMv
 QEm2jiQi
 vV1YGZv0/uwblVSE62ybkizCJyowbF3T6eEUVqXoqAS/fbGdxHxv56DaxOUgzCyfs2phRKF0sbAKjrlR1KVpD4tQUq84mn2yhwDGSARBouuiimYHqLVGbrlJ5GRo69KF11LMspL3KUh8RCsSjcc4XYErA0V5mYM0TVeRHjheRT+S1hxcnxwJchny12wJVer1AfpeQaJyiykzQPaEFHSxuq2ZYDsvw2Ak/gGzueMN4bmPH9nliJoRbCoNDruG7C8749rC3P/VR0G6MGocow2xOCFSNzfDh8taEcbib2mfrc0FKJiBxFSn9c7pI0ioimVqtMDh2KxOxzVJwhuPXpBp2+jBcAEJU1Rp7+mcMMgRERRPWkOeGCCu0iV08Atg/+8KJnNAYWP9yDI6Aa3yoTnIGrlNu45QI3tdYgJYX85I4RtDzVrQknLivqEnx+3VP2fxI3txbovsMxzsNhHr/9U5LNYowgeoOMk3mVkQ4kpmp3XN2MB9a4dmXwqj5WcT+b3c4i/cked3by+oySYfkwYVUrkDBS3Wc8zDGsrG02W9M3bkB114=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 8, 2026 at 8:44=E2=80=AFPM Miaohe Lin <linmiaohe@huawei.com> wr=
ote:
>
> On 2026/5/31 13:58, Jiaqi Yan wrote:
> > At the end of dissolve_free_hugetlb_folio(), a free HugeTLB folio
> > becomes non-HugeTLB, and it is released to buddy allocator
> > as a high-order folio, e.g. a folio that contains 262144 pages
> > if the folio was a 1G HugeTLB hugepage.
> >
> > This is problematic if the HugeTLB hugepage contained HWPoison
> > subpages. In that case, since buddy allocator does not check
> > HWPoison for non-zero-order folio, the raw HWPoison page can
> > be given out with its buddy page and be re-used by either
> > kernel or userspace.
> >
> > Memory failure recovery (MFR) in kernel does attempt to take
> > raw HWPoison page off buddy allocator after
> > dissolve_free_hugetlb_folio(). However, there is always a time
> > window between dissolve_free_hugetlb_folio() frees a HWPoison
> > high-order folio to buddy allocator and MFR takes HWPoison
> > raw page off buddy allocator.
> >
> > Another similar situation is when a transparent huge page (THP)
> > runs into memory failure but splitting failed. Such THP will
> > eventually be released to buddy allocator when owning userspace
> > processes are gone, but with certain subpages having HWPoison.
> >
> > One obvious way to avoid both problems is to add page sanity
> > checks in page allocate or free path. However, it is against
> > the past efforts to reduce sanity check overhead [1,2,3].
> >
> > Introduce free_has_hwpoisoned() to only free the healthy pages
> > and to exclude the HWPoison ones in the high-order folio.
> > The idea is to iterate through the sub-pages of the folio to
> > identify contiguous ranges of healthy pages.
> >
> > free_has_hwpoisoned() is added in free_pages_prepare() as
> > a shortcut and is only invoked if PG_has_hwpoisoned indicates
> > HWPoison page exists and after checks and preparations in
> > free_pages_prepare() all succeeded. free_has_hwpoisoned() then
> > can re-use free_prepared_contig_range() [4] to decompose healthy
> > ranges into the largest possible chunks of different orders.
> > Every chunk meets the requirements to be freed via free_one_page().
> >
> > free_has_hwpoisoned() has linear time complexity wrt the number
> > of pages in the folio. While the power-of-two decomposition
> > ensures that the number of calls to the buddy allocator is
> > logarithmic for each contiguous healthy range, the mandatory
> > linear scan of pages to identify PageHWPoison() defines the
> > overall time complexity. For a 1G hugepage having 8 HWPoison
> > pages, free_has_hwpoisoned() takes around 1ms on average on
> > a system having 56 Intel Skylake physical cores. This is
> > 15x to the case of freeing no HWPoison page. The cost is far
> > from triggering soft lockup, and fair for handling exceptional
> > hardware memory errors.
> >
> > [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-=
mgorman@techsingularity.net
> > [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-=
mgorman@techsingularity.net
> > [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> > [4] https://lore.kernel.org/all/20260401101634.2868165-2-usama.anjum@ar=
m.com
> >
> > Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
>
> Thanks for your update. This patch looks good to me while some comments b=
elow.

Thanks for your review Miaohe!

>
> > ---
> >  mm/page_alloc.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 85 insertions(+)
> >
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index e47679e7a9db..03df929abca6 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -208,6 +208,7 @@ gfp_t gfp_allowed_mask __read_mostly =3D GFP_BOOT_M=
ASK;
> >  unsigned int pageblock_order __read_mostly;
> >  #endif
> >
> > +static void free_has_hwpoisoned(struct page *page, unsigned int order)=
;
> >  static void __free_pages_ok(struct page *page, unsigned int order,
> >                           fpi_t fpi_flags);
> >  static void reserve_highatomic_pageblock(struct page *page, int order,
> > @@ -1309,6 +1310,14 @@ static inline void pgalloc_tag_sub_pages(struct =
alloc_tag *tag, unsigned int nr)
> >
> >  #endif /* CONFIG_MEM_ALLOC_PROFILING */
> >
> > +/*
> > + * Returns
> > + * - true: checks and preparations all good, caller can proceed freein=
g.
> > + * - false: do not proceed freeing for one of the following reasons:
> > + *   1. Some check failed so it is not safe to proceed freeing.
> > + *   2. A compound page has some HWPoison pages. The healthy pages
> > + *      are already safely freed, and the HWPoison ones isolated.
> > + */
> >  static __always_inline bool __free_pages_prepare(struct page *page,
> >               unsigned int order, fpi_t fpi_flags)
> >  {
> > @@ -1317,6 +1326,15 @@ static __always_inline bool __free_pages_prepare=
(struct page *page,
> >       bool init =3D want_init_on_free();
> >       bool compound =3D PageCompound(page);
> >       struct folio *folio =3D page_folio(page);
> > +     /*
> > +      * When dealing with compound page, PG_has_hwpoisoned is cleared
> > +      * with PAGE_FLAGS_SECOND. So the check must be done first.
> > +      *
> > +      * Note we can't exclude PG_has_hwpoisoned from PAGE_FLAGS_SECOND=
.
> > +      * Because PG_has_hwpoisoned =3D=3D PG_active, free_page_is_bad()=
 will
> > +      * confuse and complaint that the first tail page is still active=
.
> > +      */
> > +     bool should_fhh =3D compound && folio_test_has_hwpoisoned(folio);
> >
> >       if (fpi_flags & FPI_PREPARED)
> >               return true;
> > @@ -1443,6 +1461,16 @@ static __always_inline bool __free_pages_prepare=
(struct page *page,
> >
> >       debug_pagealloc_unmap_pages(page, 1 << order);
> >
> > +     /*
> > +      * After breaking down compound page and dealing with page metada=
ta
> > +      * (e.g. page owner and page alloc tags), take a shortcut if this
> > +      * was a compound page containing certain HWPoison subpages.
> > +      */
> > +     if (should_fhh) {
> > +             free_has_hwpoisoned(page, order);
> > +             return false;
> > +     }
>
> When the code reaches here, the hwpoisoned pages have passed through kern=
el_poison_pages,
> kasan_poison_pages, kernel_init_pages, arch_free_page... These functions =
might write to
> the hwpoisoned pages. Is it safe to do so?
>
> > +
> >       return true;
> >  }
> >
> > @@ -6936,6 +6964,63 @@ void __free_contig_range(unsigned long pfn, unsi=
gned long nr_pages)
> >       __free_contig_range_common(pfn, nr_pages, /* is_frozen=3D */ fals=
e);
> >  }
> >
> > +/*
> > + * Given a high-order compound page containing certain number of HWPoi=
son
> > + * pages, free only the healthy ones.
> > + *
> > + * Pages must have passed free_pages_prepare(). Even if having HWPoiso=
n
> > + * pages, breaking down compound page and updating metadata (e.g. page
> > + * owner, alloc tag) can be done together during free_pages_prepare(),
> > + * which simplifies the splitting here: unlike __split_unmapped_folio(=
),
> > + * there is no need to turn split pages into a compound page or to car=
ry
> > + * metadata.
> > + *
> > + * It scans every raw page of the compound page and cause nontrivial o=
verhead.
> > + * So only use this when the compound page contains HWPoison page(s).
> > + *
> > + * This implementation needs rework in memdesc world.
> > + */
> > +static void free_has_hwpoisoned(struct page *page, unsigned int order)
> > +{
> > +     unsigned long curr =3D page_to_pfn(page);
> > +     unsigned long end_pfn =3D curr + (1 << order);
> > +     unsigned long next;
> > +     unsigned long total_freed =3D 0;
> > +     unsigned long total_hwp =3D 0;
> > +
> > +     VM_WARN_ON(order =3D=3D 0);
> > +     VM_WARN_ON(page->flags.f & PAGE_FLAGS_CHECK_AT_PREP);
> > +
> > +     while (curr < end_pfn) {
> > +             next =3D curr;
> > +
> > +             while (next < end_pfn && !PageHWPoison(pfn_to_page(next))=
)
> > +                     ++next;
> > +
> > +             if (next !=3D end_pfn && PageHWPoison(pfn_to_page(next)))=
 {
>
> Check next !=3D end_pfn should be enough. If we have next !=3D end_pfn, w=
e must have PageHWPoison(pfn_to_page(next))
> or we can't exit from above while loop. Or am I miss something?

Yeah, next!=3Dend_pfn is simple and enough.

>
> Thanks.
> .


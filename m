Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F56CCD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 10:17:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EF986B0005; Fri, 29 May 2026 06:17:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 979276B0088; Fri, 29 May 2026 06:17:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 840736B008A; Fri, 29 May 2026 06:17:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 700826B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 06:17:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3F3441C0B25
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:17:01 +0000 (UTC)
X-FDA: 84820054242.10.0064921
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5E83140002
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:16:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cFko8Ntd;
	spf=pass (imf07.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780049819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PChq7lVk0cZN2Il3vhZJBZZET0uiB5y1SQ5YG4ON0U0=;
	b=apWm5Dt6mqvII8m8C4RxilKyrpxyv1mtUywJ4Ve0ESqsO+cEWX3eht69+gdZGr4A3ikIIl
	JOQ84hhiMKs019kHF+gwm/5kBi7CZNzFy4ECmDUBF8SvmI3xqEaHZMgAK+4/U4j21QznIF
	D6aabA7oAVSxbpnjJS8872CYXW5dnGQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780049819; a=rsa-sha256;
	cv=none;
	b=yXsOwE4e/pnSos7V2aqYbOVGRwWDlFuc8cC4bJI26EJIrTwPdE7tDSTAd5a/LGb1F/onNn
	6bD8MhF0D02ULvqI2bb6BsW/5y8wUz7XcKeSK+Oiqvzquv7B+NMEMC/xWuUBGvg8BXl3CQ
	cnE/XBsnmzldN2H4QtXmA3To3MraXV4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cFko8Ntd;
	spf=pass (imf07.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49050ff7cbdso63249365e9.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 03:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780049818; x=1780654618; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PChq7lVk0cZN2Il3vhZJBZZET0uiB5y1SQ5YG4ON0U0=;
        b=cFko8NtdZTndSeV4N5DdqRxOroimPJ564MJot+KOHWukSTL1PxTPFBfnziypelcFm9
         UwzWC1LRsMl8JZeVKJwyKwkWIUlzKfuALwzh9LQhXVNw1lJIdu/e0TpcU0ur3ih0oWih
         WvxH99ZklcD2CWHFmT0kYKDrctNgngEAS43c1aKRXsmMe0bYKS2z9kXU3bEi+1c0j7Ow
         2cRTO/ujE0vZT1ZrYJehaR9hccysGcwaOUMJefxczQ/UHcYXk2QWhcX4quj4m0BDo2Xo
         T9cFAcosPpvewGnPE7iiXADEclKd2Seam7R7D86MpsW6R9nDMV+1cck7MS2nmZi/9+uh
         pcaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780049818; x=1780654618;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PChq7lVk0cZN2Il3vhZJBZZET0uiB5y1SQ5YG4ON0U0=;
        b=iZzetksDckBc+zauy2BFsCDDFbV653KWo37PYIyY2Cr64K7oLdzx4Oym7PAxpjOnpf
         Adaz5nNdzLgqCBGmzZM41/Uo4CZ1J5GRJhdrkRRUj4yRgwtjKgjf0OTl4pSLIPXpUa3m
         jM817dFcw7w2Dv6NsOkutcGB6uPS3lM4rBFkh3e3Z39eUczOnF7rHJ2IDKKZRUuH34fn
         FHvNJxNCo6sdMZSH+R2xkaab2tn/B/HJsOILxgNdxIKYCE3uKjfJV1P9ueJ5iUqDXMi0
         NZCbqhnENXPCeMX7CQlIM1g81Gwu4nE4lMt5vQITP0GewOPJbNSrLKEQyVGUA7EW4A+L
         QEFg==
X-Forwarded-Encrypted: i=1; AFNElJ+GuO5Wv7zlLcCCc9B1Lre7MvFunUc2Fy0vkIC43qqGrLJ66BrKOwpsySQJmfGlRmFpTbA8cAzcZA==@kvack.org
X-Gm-Message-State: AOJu0Ywlm3neCjfU4xqGGtnZxNWXBfqdb66x4k8gG6jo5l3TDAT3zv79
	qST7GyCCtICom/6zT/7qTb4fgFQubOefwX49NO416hXJtoInLm0qBJt0
X-Gm-Gg: Acq92OFUEZ7GGvI8/LUEpTx0t+F2CnzPVoN23UeRljzM24d9wWBmGA4jjORAg5pMUA5
	sp0X2mx1dNaP6zefx2QJRK+yUAu387UL6IpwQZ7Jc+6cXTOcYMSOsVBtcKg5RWbWCrwawZhFuT/
	sTMWDakmb4E+BbCff0idH50YeVP98WB6o2AGvOu0cYyMIsI6qUaNf8HNw0YYilXeYD6+m/FVMQ2
	ZWx7xyhvlSUuc8Ty/VJ6WeO/7NYREBEWIxNIX8srobEhrggdU7v8tOW+j8SBOGV3+9jAyYQHeT1
	X7SPr0UiECGtyBA76MAltrPjdGHjvtF9NR1Wz7QCgXH/VQeJL6HIl2FKIY4OMj1g8wVvL0UKfZj
	ocUSLXBZCK3wMvQjaR/6cFMqueuPZnJSRSile9Vbyk21/PSVzCMYWs6ewk9oW4nO+U8lLiwi8jF
	Wns6caPjOhxGZzF4YNviEiDiUiX9BSxxWNnLuAdXczRBshqM+/35tCZbK3JsJ7MF6gi2/cXfli4
	RGZ0U6QTkzG+I6+yDYpN/Hf4At57Yrha0vBteDpMGG1
X-Received: by 2002:a05:600c:1453:b0:490:50ff:7943 with SMTP id 5b1f17b1804b1-4909c0773a4mr26720375e9.5.1780049817498;
        Fri, 29 May 2026 03:16:57 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909c13276dsm11265945e9.36.2026.05.29.03.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 03:16:56 -0700 (PDT)
Date: Fri, 29 May 2026 11:16:54 +0100
From: Vishal Moola <vishal.moola@gmail.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, david@kernel.org
Subject: Re: [PATCH] arm64: mm: call pagetable dtor when freeing hot-removed
 page tables
Message-ID: <ahlnltbpnoWcEtEj@fedora>
References: <20260521032730.2104017-1-apopple@nvidia.com>
 <20260521153130.d7d5cd060f7522f894252333@linux-foundation.org>
 <ahACfQ6kCfONqz5h@arm.com>
 <ahAjudlB32VbkKbG@fedora>
 <92450154-e1ab-46e4-b23d-eaa59c9cdd3b@arm.com>
 <ahW3QYiYjjVB4Knv@willie-the-truck>
 <423a2656-e1a3-473e-abeb-5e301c6f7c2a@arm.com>
 <aha5w_WRTmtb6O-B@fedora>
 <83d168c1-fed9-4301-8d0e-ffd133df90bb@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83d168c1-fed9-4301-8d0e-ffd133df90bb@arm.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: qxw7z9n6jgbeqr8jihu18ik8d7x61nnw
X-Rspamd-Queue-Id: 5E83140002
X-Rspam-User: 
X-HE-Tag: 1780049819-392515
X-HE-Meta: U2FsdGVkX1+Vn7Sz7G9MuZysNDmS091baCNNJtSQAcL7v0OPTgaub4C1vc/UI3EWILE447FLkTIIxW069Dro145u3SaJAwJIbEhxKPJ7yfI9qtMcUeFTZmSS+kpaTGtz4gyM/Au6elXOzKz/+wshLAke+Gr0NileMHJQHL5QR3f7/s/e5TG34VSL1a4vkl8JWAMvFzxCME6NMuWyuKFp9MK90GlCX8t8gS2fkfcjic8Fp5bzSdaug9KtpG6U5XObgWcczX2bXNipWpCNa2O9nRa0I8JaIPYsnbwH2iLVuQOxHOgUS0qsWnM5qsS5xiPWctkqdzrf+wBTbRiol3KOhxW1wywzF3o8vVfSTvAcSQO4YREuZJN6UuhN4XU8SsBuAjvFZV6SlQUQ1HaSfimPqzklRk/T6ntQnPQotsZrYXk0JXOm0D24EVCdD9nbeHhkbFCGcW4MMnlDdYSSrTJTVexMzV7NxfdBjqL9tCYt5SdurNqfbM0uCFhTeqyZbZJ2HnaJgB7KV79jDb5tBGTlLhlMs8VlhRvVXW/YDjPjZykobQER64nezXu+f50Fp4SvwAh/BnIZCMBf9LAa2aFYpjuuuwawerIokUINutsJiOryBw1ShI32dWI9j8HtmLRNDAM1IoaRPO+iATkd1FXJDNiGG4lvxpr1pwj82tsVvGVAmZCVjMENci3tDGc41yySqjHE7O+H8/NllwfP9yyZkpQRjkHb+xummeUEvZ1KAnj5jYl9ec62swUDNCLDTwMOwLUUCZ9oVkprwLJxTCgkjU95MyoK/lBO14KCoB4UYdaTHRluXnJofP6SC/M5QNcwu9Uur5WTmD0zI5N0TtX8X1PPs549fCMekxdsHXpjGDEt4pOWMEjB0GraRg3jT0ijiTT8KfbATjhmgZ9bK141/3fWiWUkoozM9XUN8O6mZXL1f4xBxfEX12lcsE3wXxpJIyIIFa/NY78vArFzHE0
 zLbd+B4J
 v80ymi3KMhaxQR1vyXGon55ATKhu5FMi4a872pf1wwrS3IEyY+bCEZ/zHDNihofiNqOjBaoSHS1nCY5uShKk/ACXxnNmDR8k/rNHuelLsRm4r63qkHumOIyyGn+uCLpckVr2kcBjl+Q6dPltA3V4aVLps8koKvnaLcYwipHZ6ERdAM9M+dw44pvxa6koFBZRx4j3wdPeJk+GESQOzP/Cq8kgbjrI83Fl6oPazj2fq2PWWjVo4KAQNhx/P0zRfWDcnuXAyfhalXQ/1Zy38sFez+pbxH4H8G88qtr8PNWUHSLuirJ1CshT8BGZA6YTp6gNozoaa+PxpdQKmeSOssM3o2lhJpQJexNmUtPtynuuEuKDeO37NBz/iWDv6aVxYkVTJTQbeKGp2yuIL3wBKC8/y1XOpNyh4mGkvWUnhMoIbCRFnBPbnClvE6Noo+jvlIqEQ9WH2DYpBBusgDlhR2K/EQ0Tctw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 10:05:22AM +0200, Kevin Brodsky wrote:
> On 27/05/2026 11:30, Vishal Moola wrote:
> > On Wed, May 27, 2026 at 09:35:50AM +0200, Kevin Brodsky wrote:
> >> On 26/05/2026 17:07, Will Deacon wrote:
> >>> On Tue, May 26, 2026 at 01:54:00PM +0200, Kevin Brodsky wrote:
> >>>> On 22/05/2026 11:36, Vishal Moola wrote:
> >>>>>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> >>>>>> index 4c8959153ac4..9d42cbddce27 100644
> >>>>>> --- a/arch/arm64/mm/mmu.c
> >>>>>> +++ b/arch/arm64/mm/mmu.c
> >>>>>> @@ -1441,6 +1441,9 @@ static void free_hotplug_page_range(struct page *page, size_t size,
> >>>>>>  
> >>>>>>  static void free_hotplug_pgtable_page(struct page *page)
> >>>>>>  {
> >>>>>> +	if (folio_test_pgtable(page_folio(page)))
> >>>>> This should work.
> >>>>>
> >>>>>> +		pagetable_dtor(page_ptdesc(page));
> >>>>>> +
> >>>>>>  	free_hotplug_page_range(page, PAGE_SIZE, NULL);
> >>>>> In the case we presumably have a page table page (ptdesc) at this
> >>>>> point, we should really be freeing it with pagetable_free() as well.
> >>>> Agreed, I think this is the right thing to do, something like:
> >>>>
> >>>> if (folio_test_pgtable(page_folio(page)))
> >>>> pagetable_dtor_free(page_ptdesc(page)); else
> >>>> free_hotplug_page_range(page, PAGE_SIZE, NULL);
> >>>>
> >>>>
> >>>> Strangely enough x86 calls pagetable_free() in both cases.
> >>>>
> >>>> My series protecting page tables with pkeys has a patch [1] to get
> >>>> vmemmap to allocate page tables with pagetable_alloc(). The diff above
> >>>> will require pagetable_*_ctor() to be called as well, but I think that's
> >>>> the right thing to do anyway. That could be posted as a separate series,
> >>>> but I'm hesitant due to the lack of NUMA awareness in pagetable_alloc().
> >>> I agree that calling the ctor()/dtor() functions consistently is the
> >>> cleanest approach and that will need something like your patch to call
> >>> the constructor from vmemmap_alloc_block_zero(). Trying to elide these
> >>> calls for the page-table pages used to map the altmap just feels odd to
> >>> me, as there isn't anything particularly special about them afaik.
> >> I don't think they're really special either, most likely they just got
> >> missed/ignored for the purpose of ctor/dtor like many other kernel page
> >> tables (until recently).
> >>
> >> I'll prepare a series refactoring that code then - that will also
> >> require changing most arch implementations of vmemmap_free() to call
> >> pagetable_dtor_free().
> > Take a look at Matthew's series[1]. I think thats the ideal approach for
> > page table accounting. He hasn't had time to iterate on it though. I
> > doubt he'd mind if someone picked it up.
> 
> I recall this series. Are you suggesting that we would no longer need to
> call the ctor/dtor for kernel page tables with this approach? That
> leaves us with the weird case of ptdesc_set_kernel(), which is called
> from *_alloc_one() while ptdesc_clear_kernel() is called from
> pagetable_free(), but that's only an optimisation so we can probably
> live with it.

Pretty much. The ctor/dtor do things that every single page table should
be doing, so it makes sense to move them to the allocation/free sites
instead.

Kernel pagetables are a subset of ptdescs, so keeping those where they
are makes sense IMO.

> If we go down this route, I would suggest we inline what's left of the
> ctor/dtor, i.e. ptlock, in {pte,pmd}_alloc_one() and {pte,pmd}_free().
> This way it is clear that everything applicable to all page tables
> (kernel+user) should go directly into pagetable_{alloc,free}.
> 
> Happy to post something along those lines (patch 2/3 of Matthew's series
> + removing ctor/dtor completely) if that sounds sensible.

Sounds good to me :)


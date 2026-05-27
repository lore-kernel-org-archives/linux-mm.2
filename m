Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F06CCD6E41
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 09:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFB526B0005; Wed, 27 May 2026 05:30:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AACC56B008A; Wed, 27 May 2026 05:30:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 998AA6B008C; Wed, 27 May 2026 05:30:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85F9E6B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:30:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF170161920
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:30:49 +0000 (UTC)
X-FDA: 84812680218.29.C75404B
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf31.hostedemail.com (Postfix) with ESMTP id D994F20004
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:30:47 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iAn2tyN3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779874248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UeNp5zNgXhh9w9gen/mqg7KXpKPshnm2ZyOIypYk7Gw=;
	b=eYmGi/NCHT3hxydivij5U8MlGnYCg7DYwOtvPseCefqHa/FoOM2U1I8E8kkaeF9eN3dL9o
	2HrRfZm6gsoYTFrrXJOMzlIs/8TVTFJGlBgTX0ah/l4W/CBsNJtVoXLWauuFOa+b0EESwR
	zYyGfcpipL29r3BZz++uZyPJnG+cIYw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iAn2tyN3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779874248; a=rsa-sha256;
	cv=none;
	b=aTbbe7mX0pvyje9D7yXD8mT0Vuf46cLUdnesW1Zs5wMawRZ7KN9keEnzw9xZnwo0zcJoY8
	otDzhVxQvc49gAawpF20+ttrpObO+qTY11PJjMbRGxFlyDad22TVROtPjOvFoFuWF9Rkw3
	/c72121Qkisf3D5Vb0xf7ipXpr9ywmo=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49050bfe053so19041715e9.3
        for <linux-mm@kvack.org>; Wed, 27 May 2026 02:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779874246; x=1780479046; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UeNp5zNgXhh9w9gen/mqg7KXpKPshnm2ZyOIypYk7Gw=;
        b=iAn2tyN3jzT+xdlmXoEw6sRsPQwP1s5awaO4U1GQYUFfOBqhQPwdURkQ6b5m1i+UvP
         9rEToT0kT3hmtirVOewbTYWVFZFqnrt8i7RUhgqNFZuhiVQwIyd+CxCF0wHvbFvpKC11
         xBfIjTsVqx+Gm2C/0KuDJI9GhUO4BFO0wh4WvTnb4FfpaI4U254rr+41HQ6iYdFfv9ez
         cK30WqZWF544tdwrwWq8cjkgrh9QZAvSYlsnGcBDnrlAp4FTmHieUErzq+1Oh+kZEo1S
         XmwAcHZ7gj9EMLZwU1ypazbbhIABeZ9cysAs/zGDxS7LgZXiUucuHtBQ3zsEkNy8PndW
         YHyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779874246; x=1780479046;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UeNp5zNgXhh9w9gen/mqg7KXpKPshnm2ZyOIypYk7Gw=;
        b=PJVJLcpnvgGfaUCkhjzHIalzh5fJEUq2XiLyhA76S+QMxc4IbwgdYDUM1xbk4V5Eev
         1U0yWWBWw6M0z1lqhMuKt+oDOiChRvFrlI/O/zUjB19rgoLxZ9XfK8afpQxOfejHqDpv
         iHPPtt9BkPPaqXLqaPW+4bkPUiGxQ1hAbYe16FRg70b4DOxdjZdZ/Cmfg9madum9ha7h
         PHK/3R1woqGc4KBy1cywDj5m9F8e3in8CB8RfywxjYyJ1VCJBw8KxQdKgA8dTRTOU+jM
         tPk+M2qj4xxBxVCIdHhu8sMelos4OKeTCtUt+LdVDgcjmW2HdNeSRY5JgGbERPlqPOGj
         61SA==
X-Forwarded-Encrypted: i=1; AFNElJ+ujg7Dlk+hos5XUhDwo2E6rSvT0rePMlbs0s0Q00EItQePrXyURj6/+xttqmtbAh2y0CSo7k7aMg==@kvack.org
X-Gm-Message-State: AOJu0Yw0KBszP5hLEAthXCz+8ona7VdK/R9bO8JmSg9SxoYXRpwtYef+
	JCX+xEJf1NaGkk5qjjYbpokr2T0uxn0X4OxP2k0z2LNybWS8DHMPqINw
X-Gm-Gg: Acq92OGJO809j1wzId+HeGdfaPUT1VKNn5FAQHrFLVxZtwCItnkfunmP5h40kMHksDg
	WYGVhVr8bQr3Pjt0IvqMrPvVb9RN34zNiboShsF2p/y7chkfcNBiIT1Vy7r9K3jApdRTNLPEbye
	boRV7TA/eGtPSCrhQctF6LrAsC2ffvwYpcQTperpykwR1hrRFLtdkSBvF+Fs37gzFwCrVBbLvlf
	CQJAFlRxJ/wr8bx9zrW9QXM5jrnGAL1ZDKUppyx16nv8YQORvrBnK3Y+Zo5bT3eqrPSB5scOKhH
	KgNq0ZrAV1KVDGt+7dEDp5XCU+CKpYOM9XCsfOVCvzdyW3q3p2WiPk4ZXcbpUmviWHDY2tm6e64
	XT+dObYg0q9/squ493QO6s7HSQgZigJGvJGtmxbIHJrOchiEyvXXs4nk9t9+f1rqS+wmkTcv0IX
	5karDXGAIhnNByN1fplkBzDlLzwTj1DVJAgs3449YlBccV9EOVVNc1ejZqctl1PnrfY0JJFWWIu
	qz74VXt6VEMHARjsynANPL+u6Ry/FXu2A==
X-Received: by 2002:a05:600c:8b23:b0:48f:d5b2:7c1a with SMTP id 5b1f17b1804b1-490425aa7a4mr390195565e9.13.1779874246051;
        Wed, 27 May 2026 02:30:46 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49045282201sm427410665e9.8.2026.05.27.02.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 02:30:45 -0700 (PDT)
Date: Wed, 27 May 2026 10:30:43 +0100
From: Vishal Moola <vishal.moola@gmail.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, david@kernel.org
Subject: Re: [PATCH] arm64: mm: call pagetable dtor when freeing hot-removed
 page tables
Message-ID: <aha5w_WRTmtb6O-B@fedora>
References: <20260521032730.2104017-1-apopple@nvidia.com>
 <20260521153130.d7d5cd060f7522f894252333@linux-foundation.org>
 <ahACfQ6kCfONqz5h@arm.com>
 <ahAjudlB32VbkKbG@fedora>
 <92450154-e1ab-46e4-b23d-eaa59c9cdd3b@arm.com>
 <ahW3QYiYjjVB4Knv@willie-the-truck>
 <423a2656-e1a3-473e-abeb-5e301c6f7c2a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <423a2656-e1a3-473e-abeb-5e301c6f7c2a@arm.com>
X-Stat-Signature: eg91n6aa4k195jzsocanj6758xxnqr3k
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D994F20004
X-Rspam-User: 
X-HE-Tag: 1779874247-266696
X-HE-Meta: U2FsdGVkX18iQuUmMFK8jYongUBEIeKmAfyI+wZaRG4M+3qZlMuZjrQz6UH0GG5hGrjIGUVJnxcL27Om5R+jyG/bICTzD+x3q71nBDsZ8wCT5jIlKVAVWYnuURW12rcmxcBjwbKcYUS9hQIhsbBUOgI7KcxV78kBSD86STHCb4rwMvFbmCBMcc+SRnr/UhAtXnBBH7DM1m8zeV5fxbAmPVWs5SpcllYsnSdNUH1V4Fr8r0e78py0oUynUZmRs6k76lcAAr3wQbrxil/iJb3EQ9sr2YD2Q+84USr+cBB9hlHk05h3XEeSC82dZ607znJyEmcnUuBQGEkF9tLtjeiNP6jWkJgxfIPuaa3zFE0z6Y1mnccCIRKzop6QZBK+gIgGuBG3LCwHytCNiG47fvgmP1x6LYZUd8V9pnRqTgV9PIFnabQwHKxJHgDgJlNidk+DEfLqvYIZZqsBNniP9TFKVINLZISWiuWzJ1TIMlp/FBZi6WZoGM3cjDvobuzVj+2uVVXtUr3KvlA4eZ1+v8sqVOljQ8QacFyVQXpBYoNjp6ul2eaBbOO9SpEMcDnSKecSdy7rdfHqgv52ZhAlNcDETzaU6B6KXzVicxMBPeqI2WvopgQ3lfiDk0kYTwBnzBWlFMZkYlLC77tJFFEZJeSJoKgfC6f/P2u87UySjB+L2QVxhha9ApeiHRjlkA7F+UC5LDb1KizN5QIMaB+ckGUCJ7ESvL+sfx3WVu61WmhOhk4pOBZvrFvWvZ18iW8Wi+KCio7PPyvZ++rx5iR9TSwD6Gd1hfZNZrGHqwKYR6txLqFQ3Cw97qCID4YB/JboCObRMV/poZ1JJhQiCGWcUTzqA+0j8F+IluEbMXqeb6rpIN/xvf7Al1dNQlR7b42FJznyYNqk0sfUcChYQPBsyxSt4dkIISHoDuUyKIdvRHVEe3W4P1eUwsoOmkPU7Q5x6cVN0OQAhN5nPEVEmkSSrPL
 jOM4eXaB
 q4W19ZUOuf4vS/4DX8CB219jf3n0FbDLtuUwXy+Tqyv9Nha2i+nQ9YD7/5/sTpVkfBI14lNJr3FgiV4lGUAhV6uHYevj9TvntXYdNcDfOiLyAA8pqGKoOURpWaHz2W1n8SZSnKq5HBLWTMRhVi+xqQm8+7vE64X9flwP1hY8F0CqOFQJ2OcJPAtXfaWV+Z41jkp1nWiRkvjb6fdE7W6qnXTNiQ2/U9BBgER+rbDOwUua743+EzoaMq1NumwYVJjaizdkWx+CLJw4pUhrLgGtGh+zFtE2mlfXyixe8+GoTQ2RUqTZl46YDFVdIHy9JLH2qX1gksgzCFkJI07tS3dS6dovgASRl2FTiJidu6fMwJJTjPp9i1OrtejHBeGcndzdh9mukX0PGNm3FGuqglRqQ0AJEYvarRGBo72JyBAI9yO2/UG2ScKhy1L2PMK7Hzj2P8iPBMzB4cxdykgkUSe0eCXBSSCXZ3N/Rygq3Sq0CISLdMuUu0C6T8k/LfAFG/mQs7xno74r2s+9ZX1CCz8rF21rOlJ/tooLQoA4Bwc6etXh5/60=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 09:35:50AM +0200, Kevin Brodsky wrote:
> On 26/05/2026 17:07, Will Deacon wrote:
> > On Tue, May 26, 2026 at 01:54:00PM +0200, Kevin Brodsky wrote:
> >> On 22/05/2026 11:36, Vishal Moola wrote:
> >>>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> >>>> index 4c8959153ac4..9d42cbddce27 100644
> >>>> --- a/arch/arm64/mm/mmu.c
> >>>> +++ b/arch/arm64/mm/mmu.c
> >>>> @@ -1441,6 +1441,9 @@ static void free_hotplug_page_range(struct page *page, size_t size,
> >>>>  
> >>>>  static void free_hotplug_pgtable_page(struct page *page)
> >>>>  {
> >>>> +	if (folio_test_pgtable(page_folio(page)))
> >>> This should work.
> >>>
> >>>> +		pagetable_dtor(page_ptdesc(page));
> >>>> +
> >>>>  	free_hotplug_page_range(page, PAGE_SIZE, NULL);
> >>> In the case we presumably have a page table page (ptdesc) at this
> >>> point, we should really be freeing it with pagetable_free() as well.
> >> Agreed, I think this is the right thing to do, something like:
> >>
> >> if (folio_test_pgtable(page_folio(page)))
> >> pagetable_dtor_free(page_ptdesc(page)); else
> >> free_hotplug_page_range(page, PAGE_SIZE, NULL);
> >>
> >>
> >> Strangely enough x86 calls pagetable_free() in both cases.
> >>
> >> My series protecting page tables with pkeys has a patch [1] to get
> >> vmemmap to allocate page tables with pagetable_alloc(). The diff above
> >> will require pagetable_*_ctor() to be called as well, but I think that's
> >> the right thing to do anyway. That could be posted as a separate series,
> >> but I'm hesitant due to the lack of NUMA awareness in pagetable_alloc().
> > I agree that calling the ctor()/dtor() functions consistently is the
> > cleanest approach and that will need something like your patch to call
> > the constructor from vmemmap_alloc_block_zero(). Trying to elide these
> > calls for the page-table pages used to map the altmap just feels odd to
> > me, as there isn't anything particularly special about them afaik.
> 
> I don't think they're really special either, most likely they just got
> missed/ignored for the purpose of ctor/dtor like many other kernel page
> tables (until recently).
>
> I'll prepare a series refactoring that code then - that will also
> require changing most arch implementations of vmemmap_free() to call
> pagetable_dtor_free().

Take a look at Matthew's series[1]. I think thats the ideal approach for
page table accounting. He hasn't had time to iterate on it though. I
doubt he'd mind if someone picked it up.

> In the meantime we should probably use the logic above to avoid the BUG
> that Alistair reported.

Agreed.

[1] https://lore.kernel.org/linux-mm/20251113140448.1814860-4-willy@infradead.org/


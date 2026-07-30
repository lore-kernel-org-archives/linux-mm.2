Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2943C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 10:48:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E4146B008A; Thu, 30 Jul 2026 06:48:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86E4F6B008C; Thu, 30 Jul 2026 06:48:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 736386B0092; Thu, 30 Jul 2026 06:48:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 409106B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:48:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A8C06160941
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:48:46 +0000 (UTC)
X-FDA: 85045119852.28.5872DEC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 05B8580008
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:48:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y76z3oa0;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785408525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kVy+pgbqI4QWKEoRnRNzNjmpy2u8mTwUktiTnZ07/f0=;
	b=D7N9gXLEE6A+jLlWbq0SfWqOx+F3d/EULeOS0cDBSUMAj1zVseADj/IRgUBgZnpjItjo+N
	vC7HutkgHafjb1INhcVcuQ/qH5xYQ8900xMaT/wneRPA6A96hhHyPHTnO3gd1zTD33JWeX
	+qObuFBQwqyiKYg0fERunhpW/T2aNcw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785408525;
	b=sWzB4he7ZYpV8Gwap4b5cQw5iFiiRFXdhg3ke36216AzhBhdjwc0MTRxYBTxp9MJrK4E2N
	8+a2Ecverni/kREZn4pcXgzCVa+NHdVrGnEtaQLb6ZcrYLO890KoKt54YO27Y/k9K3v8qo
	FK+/PzWVd9Igxh04G6nEzCreqpEG2tU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y76z3oa0;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D7EC041464;
	Thu, 30 Jul 2026 10:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E211F000E9;
	Thu, 30 Jul 2026 10:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785408523;
	bh=kVy+pgbqI4QWKEoRnRNzNjmpy2u8mTwUktiTnZ07/f0=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Y76z3oa02KUAdto51pAl/hznZ7L7UZc5ehVoUoccJgEfD3An0EvioxSEj/HKodqsP
	 P0Q6Q8N1ojeA4cbQT7fCt2ywUyrjkYTHSiO8GA5HZkvlmZYP9u5spFWXSrEe8NMd0w
	 97zr19PpsR8Ib4z+ku8axs7xGsPZg0OvkMBApvrS5smy+3J7YvzmLPUi55ftQnN5wO
	 8xhhYQ9PgPszdJBxkGTEbrQZzrDhoqedbja85RjqDFHXng8jescgXu3wTE9JIEw+H8
	 KMWtycPrYV7qrm5HIoOJdXOUmu9BxeF4Yl8ltRvrrTy4EmahDY56/LZxbI2yb/2RXM
	 2E8JPEmNLbTlQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 03/17] mm/mm_init: skip initializing shared vmemmap
 tail pages
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <5005C7D3-B3ED-4C62-B611-8465D2BC69FD@linux.dev>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
 <20260720093127.540540-4-songmuchun@bytedance.com>
 <5005C7D3-B3ED-4C62-B611-8465D2BC69FD@linux.dev>
Date: Thu, 30 Jul 2026 13:48:38 +0300
Message-Id: <178540851830.2154539.6359871825839331816.b4-reply@b4>
X-Mailer: b4 0.16-dev
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 05B8580008
X-Stat-Signature: 5hdfb1iciw1t6tdidjzwdgbtk7is6sg4
X-Rspam-User: 
X-HE-Tag: 1785408524-625601
X-HE-Meta: U2FsdGVkX19uOlpUkFOWGjimQ3zEATDTMCa4l+nm0zegwL8qsfZ2CQbBgjoAPfij6OMgJc0ihP+f37Tz1+BLz2YVXRGl4Wv0mUmcLvJUefVTPDhmv7EHMTncu+OWl9aAhyDOWBH3hEO6rXM23dszd1h7GUk/wzq7H3jVUfUasFJFn80BXyfc81R1jhC/vnlDdh/DJZZWQEdPePfXAzwVWWCcj+YcSKlpfF8yb3HqzdFc2/TpvWOyGekJIVXLda48h7WBpgwfchfwVSANzBch4bDbBulrTEu1HXDVE6ZenUTJ7ubq2/08q2Fb778vWMezl2p/jqXHSW23JI+da9/lByWwtlsBLCLquDtpumv7ZxBJ/tWkjtRyPpIAgL64ViVWfCX5Lv3AY79NSE1ENfwgCqlHZb/WGAqiTfJ+jt2rbDSln3EJAir5qWXqXz+i16tsaWMyueI5IJtZy5SMFPBkPFXvA5ZEByDRzILa+BUDg/aixowzKmCfOgI/JCO1GU4WAFcbXu07ABZSieofJnWd4cpVIejYQeYEUA58Prr5WklP3pLexaTH4ViHZ1b36t/TgP/cNvUv0SB7CF1kA5EwpgwRSEI18a7OTs3Qr0p0iXndkSJXWR1xb2BtQ+v574WyZxGcYgRSSZcbQhGgrxwLyxdzZ6B27Ur3o2mMes0hfU3YhjRtnyUVzI/A879Mq4TFUKZA6d+/ZbdfwJf2LnDabBihiCSLuCa9pUlmB763/fjSEDtmd/Zg36PvL89g6i8rdl0RTcOWNsPlZVK5fSGGlPPV2GlG/Nq19WsEIYx2HlvOofUcgB+iUIUDW7mVd4YXCtuMdwvVACyt5qpPGVyE/r7Mo4yxzvPfne9TNwqdUgjIfq4G4jGbiQ5BPIVuLELTyiVL3/YtBSOz3NGVFtD+HNPoLTgMA05wHXSwRt7Pi0jizDgBPZlLUoZGNkxOjBf1WRvil1i8nmkztmatH+6
 cpBhQHNF
 DDKGnN8TkY0/Igxvw0XjoS9Y6IRFhucze0F0/Ldvak7hNxM41SKO4a/3+judKo73hd/4yl3FKIr+edwFdA3VfSPbcvfD4uy3pnBVZN/5yWjzDajzC+GolYw01sdJJkFbVm79i4MwItMges2Q+QKY510BTQotGHYVg9vg7vRyb0euz7nEQORqMkh40r81PNW4zJr3IUFAy1CupE2G7FjmK+T+AcwdjgSnylm67Gaha3EDGzCC/mrn2BVtw38PbpQveV7mTh+7v4Qalz6GYc2DAKi7wVzLpy8cDzebK2cHcPEtUwhe8JkBJe6T6EMAgT9N1G3l4+yR6t+7XHRCZ/gXtvD2iIuJaq8f8b5AvgX+bmKiFyalpIUpJH0BTFW4r3qOOA0ZcaRv/3qKjzoE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Muchun,

On 2026-07-26 12:30:17+08:00, Muchun Song wrote:
> > On Jul 20, 2026, at 17:31, Muchun Song <songmuchun@bytedance.com> wrote:
> > 
> > memmap_init_range() initializes every struct page in the target range.
> > For compound pages with vmemmap optimization, the tail struct pages are
> > backed by a shared vmemmap page.
> > 
> > Initializing those tail struct pages would overwrite the shared
> > vmemmap page contents, requiring users such as HugeTLB to restore the
> > metadata afterwards.
> > 
> > Track the compound order for HVO-backed sections and use that metadata
> > to detect struct pages that fall into the shared tail vmemmap range.
> > Skip those shared tail pages in memmap_init_range(), then initialize
> > pageblock migratetypes for the processed range with a helper after the
> > per-page initialization loop.
> > 
> > The !SPARSEMEM __pfn_to_section() stub is needed only for the build:
> > memmap_init_range() references __pfn_to_section() after checking
> > pfn_vmemmap_optimizable(), and !SPARSEMEM builds still have to compile
> > that code even though pfn_vmemmap_optimizable() folds to false.
> > 
> > This is a preparatory change for consolidating handling across users of
> > vmemmap optimization, and it also avoids redundant initialization of
> > shared tail vmemmap pages during early boot.
> > 
> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > ---
> > v2:
> > - Fold section order tracking into the first user instead of keeping a
> >  standalone API-only patch (suggested by Mike Rapoport)
> > - Rename page_vmemmap_optimizable() to pfn_vmemmap_optimizable() and
> >  pass a PFN directly (suggested by Mike Rapoport)
> > - Initialize pageblock migratetypes from a helper after the per-page
> >  loop (suggested by Mike Rapoport)
> > - Use a 1G PFN chunk for cond_resched() in the pageblock helper
> >  (suggested by Mike Rapoport)
> > - Guard section_order() with CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP so
> >  it returns 0 when HVO is disabled and lets the compiler optimize the
> >  code as much as possible (suggested by Mike Rapoport)
> > - Explain why the !SPARSEMEM __pfn_to_section() stub belongs here
> >  (suggested by Mike Rapoport)
> > ---
> > include/linux/mmzone.h | 14 ++++++++++++++
> > mm/mm_init.c           | 33 +++++++++++++++++----------------
> > mm/sparse.h            | 23 +++++++++++++++++++++++
> > 3 files changed, 54 insertions(+), 16 deletions(-)
> > 
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 82b0155d886f..2a32101d55e6 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -2011,6 +2011,14 @@ struct mem_section {
> > unsigned long section_mem_map;
> > 
> > struct mem_section_usage *usage;
> > +#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
> > + 	/*
> > +	 * Normally, sections hold regular (order-0) pages. However, for
> > +	 * sections with HVO enabled, this tracks the compound page order
> > +	 * to enable deduplication of redundant vmemmap pages.
> > +	 */
> > + 	unsigned int order;
> > +#endif
> > #ifdef CONFIG_PAGE_EXTENSION
> > 	/*
> > 	 * If SPARSEMEM, pgdat doesn't have page_ext pointer. We use
> > @@ -2365,8 +2373,14 @@ static inline unsigned long next_present_section_nr(unsigned long section_nr)
> > #endif
> > 
> > #else
> > +struct mem_section;
> > +
> > #define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
> > #define pfn_in_present_section pfn_valid
> > +static inline struct mem_section *__pfn_to_section(unsigned long pfn)
> > +{
> > + 	return NULL;
> > +}
> 
> I'd like to propose an alternative implementation that doesn't require
> exposing the mem_section. The idea is to add a new helper function,
> pfn_to_section_order(), so that for non-sparse-memory configurations,
> the mem_section concept stays hidden internally. I'd really appreciate
> any thoughts or concerns — if everyone is comfortable with it, I can go
> ahead and implement this in the next version.

A helper that keeps mem_section hidden from !SPARSMEM makes perfect
sense to me.

I'd even take it one step further and make it return how many pfns
should be skipped in pfn_vmemmap_optimizable case.

> Muchun,
> Thanks.




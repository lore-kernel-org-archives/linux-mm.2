Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15650E674B2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 14:03:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A79F16B0092; Mon, 22 Dec 2025 09:03:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3B466B0093; Mon, 22 Dec 2025 09:03:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9465B6B0095; Mon, 22 Dec 2025 09:03:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 826916B0092
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 09:03:32 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2BB56567E5
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:03:32 +0000 (UTC)
X-FDA: 84247274664.14.EF3F0E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id EA1C640018
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:03:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qJVIkQqx;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766412210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vhEC8ggzbBT6U4JRIvHd1qk27mSYmAZuwU/aQsINmx0=;
	b=iQOT98JOdhE5FZgpSzAsINl0EY5+GQj20HocztlwF6Su9QQWbTsl0zlNWDxc+MAT0kO138
	OIVxAnESy+pXl049hQUpsq+/rOyNKU83ul4Ta0FcKuVc4EIoMJ0EUki0/LAQUXqjK8ZSrD
	duqQDeHWy1V5Ynh1Mepe/74lmzWahzs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qJVIkQqx;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766412210; a=rsa-sha256;
	cv=none;
	b=hT/LmL1NF+22Vm2+ADJW5AshrWSmb6C1Q7QdcUlSA22Q3827kGzmOKF5EWhDwG+HFFkU4K
	TSs7p2W38DdX7IPkyBNpKOqPymDGV8HX0HevtO8BZa4d/s75sLd2WU8h5YvFLZxPiR4Dvn
	QYLJFxsDhzP+km0/t2UVQ+yj3XRrPpU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F174941E5E;
	Mon, 22 Dec 2025 14:03:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F15DC4CEF1;
	Mon, 22 Dec 2025 14:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766412208;
	bh=9DgOj5Gptqy76zjThDN8kQAxpjk/REjj41+b5ZSphmE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qJVIkQqxueJVr8Er6rLQT+vAg35JFvsMDpoSGVj9/qfxJqlf85F8qD95Z/ZP4GIn5
	 kPZula/WqjNUelaeSmnjf2gQxs+Puo+w177JAOYTyZ3WnorRDWqXikDbBxoy6d20p4
	 2IkqTm5nfX70w4BEj4PdJLUJNjEbUKPLONBQIlK77Trs5ss+kdPqx28+i52hDUWFya
	 sjjtehNAbtXOgQCAj7X5qkwzp7Ncp3aAlHZa9Utz59KHEnTflivV+iMrascux5bsfz
	 mooxyWDFKHvoMO/PatKQqql47d0Zrf1SVOwFGwXww7nfrjw9dV1aHvkmpcbi5eQ9i3
	 ZHbjO32dJQJLA==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 8AD5FF4006A;
	Mon, 22 Dec 2025 09:03:27 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 22 Dec 2025 09:03:27 -0500
X-ME-Sender: <xms:r09JaYhAmSRKPUlPB3BoDqrrIbqOl9wEMMStQD_JUGHsLIaZtnGX6Q>
    <xme:r09JacbI2dCUOJNCCf3bLh7e3fLkW8EWcryrz558T-81Epo2H7RZnUf0Q44JTRTDF
    sdu6wkXJ_uWo4iymHMBkLeZm1Xtl9w5drLySza6YCzhhZHmQuraMYE>
X-ME-Received: <xmr:r09JaZdmVY7xd7-ysD7ZCHGGX300vEJqIU2cct-wbmZ716u9RNU_yBsJJuVpfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdehjedufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeehieekueevudehvedtvdffkefhueefhfevtdduheehkedthfdtheejveelueffgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeefkedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopehoshgrlh
    hvrgguohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopehvsggrsghkrgesshhushgvrdgtiidprhgtphhtthhopehlohhrvg
    hniihordhsthhorghkvghssehorhgrtghlvgdrtghomhdprhgtphhtthhopeiiihihsehn
    vhhiughirgdrtghomhdprhgtphhtthhopegshhgvsehrvgguhhgrthdrtghomhdprhgtph
    htthhopehmhhhotghkohesshhushgvrdgtohhmpdhrtghpthhtohephhgrnhhnvghssegt
    mhhpgigthhhgrdhorhhg
X-ME-Proxy: <xmx:r09JaRCgJ039la30vo_qqr-9kOQP0qCiXjx2GbIQcf3hF-_ftldq5A>
    <xmx:r09JaRVyFujtE5uiO6E2PKZjUuXhjJlWhm1EWw3UG9pkob4PR4WHJQ>
    <xmx:r09JaeWazvttAo1_43_twks3uTrkiC1KiryBBeiMigwccGCLKawbRA>
    <xmx:r09Jac97X_9X381pbCn2ATFmED9uoemQlsTqhhjrTECjiv9jnCzVJA>
    <xmx:r09Jac8LHP2VjBiMnCs_9LObcgdLVnUppshRM_ODIXVHFL60Ii8YRuyw>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 Dec 2025 09:03:26 -0500 (EST)
Date: Mon, 22 Dec 2025 14:03:25 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>, 
	Frank van der Linden <fvdl@google.com>
Subject: Re: [PATCHv2 06/14] mm: Rework compound_head() for power-of-2
 sizeof(struct page)
Message-ID: <jre3fk4ojcw4qbnp2feq7ed4iwo4zjj5leehv6l6jtw6soigm2@iybzeqz7jyi7>
References: <20251218150949.721480-1-kas@kernel.org>
 <20251218150949.721480-7-kas@kernel.org>
 <bde227ef-b072-4f48-ab68-bf184dfe7421@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bde227ef-b072-4f48-ab68-bf184dfe7421@linux.dev>
X-Rspamd-Server: rspam02
X-Stat-Signature: arf6sgnhrf8kjy5qkjyumyjxi3a1dhtq
X-Rspam-User: 
X-Rspamd-Queue-Id: EA1C640018
X-HE-Tag: 1766412209-635833
X-HE-Meta: U2FsdGVkX1+3NNdXFv7Mmf+mxCzmdwb3bDiOWCLs/hVxMXCcrZJSJhcjIdyDseOjCwwmZjvb8WTTxzD1FT0R0ptJj5D5/4v1yUEN4bT40iyBbrgxpdzsPEn6A4wLbR2SvCXmoMAdoEdXE6RFe1i111WRoLvIj2NhvVBYttP64F05FGmjZJ27XRcAonOyBJNdlp6LnDzNqozbhbntPZ8ubvuNwxvoK5qFK90vVl8TS/MscwleO+F3z+A2BqO3NtdSr4rkMSX1NAM9yYU6MhZoLCjzJFgZpyoRG2E5tyAnHBKMZODz1bLO8MRFNVEzljKFxQllVj6YjqroGqLH3rUELEw7OhKTh5SenB7jClZ19HxrBK7O15xaSp22O2XrfBK1CSM78vpDe4RiLCu/Tvox8oLCGUrrDZlzTk5WYZBAe3Zk7+x2q/8exdSgAYaiLxsrLnxNfo3mb5GHApY1mSa6edVMEPV0vhJBn/0ndCDLEhHpAx6kMR/LeuaabNCbHY3EC8sf1Bt40z2jJ3EqizqOGCtnIxXp1FJ8XhgLE89a4XqIDU0JsvYrec4mSysI9661ZJvZrcScgQMvgX6919tvfltbxQjvHO0UL7LEULOldE0++bczQCrfLnjXPVfv+togZ2VrUoB8AFAOVWaz3pQLsJD2dQxcBocLxIWpSl95KXKZpfXexKlTm5JO3XC0ZUR2BRzY/R7tHmxQTr3SBmNIB8kqoYvuoSZXO+euwb/Dwvxkb80qauLxH8VLjP5/BvQodMyHdRHeIOD5n4SCu1vCF9adYQShxmBEuwfReVhrDUG8f3zywK6B855NB4QGaTRuPfXfo3gZ6EHKA15/k2VIE5v/hTDGeTfv2wrts1qLqI5PBZSRkP8IxtgT7/Pah44WA8nN6ovO/TsxKRUZTiP/U2GIPiU0I5eB4jtRiaBQzzIrGkGbq0tRqzJxdipLr3gDBrbN96i5kVh7VPqKl4S
 OGwzdlkW
 5Nhxdor+QLnrX979PXyvkhEwN9kD0ZepHNcfm7ZQ8GRTO0k5jfABD/QrIjB362X1bM0ubIs9gLgtIx1YZ9SXNxupWkWVG7O7RHsEocdB440F6ZSMnK5gKSp5EZQIiv1UE/X/3ZHNpwokk6kgu/NrSqxqbVK6CDNxmbt7kLIlwn4cUYHJjCzflrBvKz84/Mrz93Y90ibCqOHg+fmwmGC57F+q905m0Vckh6Y2zsF7pFVppAOuUt3qxf4vYsBPP8qG0qe91GdG9dzKJjJW4s/NE67zLj1TVZYy2a/VRbTwT/E0Nral40XN0jPaymgNoREebvqKisHnHYSyuV9Qu5in1F9/DEmmFCIrzi0bN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 22, 2025 at 11:20:48AM +0800, Muchun Song wrote:
> 
> 
> On 2025/12/18 23:09, Kiryl Shutsemau wrote:
> > For tail pages, the kernel uses the 'compound_info' field to get to the
> > head page. The bit 0 of the field indicates whether the page is a
> > tail page, and if set, the remaining bits represent a pointer to the
> > head page.
> > 
> > For cases when size of struct page is power-of-2, change the encoding of
> > compound_info to store a mask that can be applied to the virtual address
> > of the tail page in order to access the head page. It is possible
> > because struct page of the head page is naturally aligned with regards
> > to order of the page.
> > 
> > The significant impact of this modification is that all tail pages of
> > the same order will now have identical 'compound_info', regardless of
> > the compound page they are associated with. This paves the way for
> > eliminating fake heads.
> > 
> > The HugeTLB Vmemmap Optimization (HVO) creates fake heads and it is only
> > applied when the sizeof(struct page) is power-of-2. Having identical
> > tail pages allows the same page to be mapped into the vmemmap of all
> > pages, maintaining memory savings without fake heads.
> > 
> > If sizeof(struct page) is not power-of-2, there is no functional
> > changes.
> > 
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> 
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> 
> One nit bellow.
> 
> > ---
> >   include/linux/page-flags.h | 62 +++++++++++++++++++++++++++++++++-----
> >   mm/util.c                  | 16 +++++++---
> >   2 files changed, 66 insertions(+), 12 deletions(-)
> > 
> > diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> > index 0de7db7efb00..fac5f41b3b27 100644
> > --- a/include/linux/page-flags.h
> > +++ b/include/linux/page-flags.h
> > @@ -210,6 +210,13 @@ static __always_inline const struct page *page_fixed_fake_head(const struct page
> >   	if (!static_branch_unlikely(&hugetlb_optimize_vmemmap_key))
> >   		return page;
> > +	/*
> > +	 * Fake heads only exists if size of struct page is power-of-2.
> > +	 * See hugetlb_vmemmap_optimizable_size().
> > +	 */
> > +	if (!is_power_of_2(sizeof(struct page)))
> > +		return page;
> > +
> >   	/*
> >   	 * Only addresses aligned with PAGE_SIZE of struct page may be fake head
> >   	 * struct page. The alignment check aims to avoid access the fields (
> > @@ -223,10 +230,14 @@ static __always_inline const struct page *page_fixed_fake_head(const struct page
> >   		 * because the @page is a compound page composed with at least
> >   		 * two contiguous pages.
> >   		 */
> > -		unsigned long head = READ_ONCE(page[1].compound_info);
> > +		unsigned long info = READ_ONCE(page[1].compound_info);
> > -		if (likely(head & 1))
> > -			return (const struct page *)(head - 1);
> > +		/* See set_compound_head() */
> > +		if (likely(info & 1)) {
> > +			unsigned long p = (unsigned long)page;
> > +
> > +			return (const struct page *)(p & info);
> > +		}
> >   	}
> >   	return page;
> >   }
> > @@ -281,11 +292,27 @@ static __always_inline int page_is_fake_head(const struct page *page)
> >   static __always_inline unsigned long _compound_head(const struct page *page)
> >   {
> > -	unsigned long head = READ_ONCE(page->compound_info);
> > +	unsigned long info = READ_ONCE(page->compound_info);
> > -	if (unlikely(head & 1))
> > -		return head - 1;
> > -	return (unsigned long)page_fixed_fake_head(page);
> > +	/* Bit 0 encodes PageTail() */
> > +	if (!(info & 1))
> > +		return (unsigned long)page_fixed_fake_head(page);
> > +
> > +	/*
> > +	 * If the size of struct page is not power-of-2, the rest of
> > +	 * compound_info is the pointer to the head page.
> > +	 */
> > +	if (!is_power_of_2(sizeof(struct page)))
> > +		return info - 1;
> > +
> > +	/*
> > +	 * If the size of struct page is power-of-2 the rest of the info
> > +	 * encodes the mask that converts the address of the tail page to
> > +	 * the head page.
> > +	 *
> > +	 * No need to clear bit 0 in the mask as 'page' always has it clear.
> > +	 */
> > +	return (unsigned long)page & info;
> >   }
> >   #define compound_head(page)	((typeof(page))_compound_head(page))
> > @@ -294,7 +321,26 @@ static __always_inline void set_compound_head(struct page *page,
> >   					      const struct page *head,
> >   					      unsigned int order)
> >   {
> > -	WRITE_ONCE(page->compound_info, (unsigned long)head + 1);
> > +	unsigned int shift;
> > +	unsigned long mask;
> > +
> > +	if (!is_power_of_2(sizeof(struct page))) {
> > +		WRITE_ONCE(page->compound_info, (unsigned long)head | 1);
> > +		return;
> > +	}
> > +
> > +	/*
> > +	 * If the size of struct page is power-of-2, bits [shift:0] of the
> > +	 * virtual address of compound head are zero.
> > +	 *
> > +	 * Calculate mask that can be applied to the virtual address of
> > +	 * the tail page to get address of the head page.
> > +	 */
> > +	shift = order + order_base_2(sizeof(struct page));
> 
> We already have a macro for order_base_2(sizeof(struct page)),
> that is STRUCT_PAGE_MAX_SHIFT.

I used it before, but the name is obscure and opencoded version is
easier to follow in my view.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov


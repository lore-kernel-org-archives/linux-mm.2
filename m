Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 619F6C5DF81
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 19:45:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37C756B00A2; Sun, 23 Aug 2026 15:45:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32DE06B00A3; Sun, 23 Aug 2026 15:45:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21CA76B00A4; Sun, 23 Aug 2026 15:45:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0C7C6B00A2
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 15:45:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 72D1E14035E
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 19:45:03 +0000 (UTC)
X-FDA: 85133562486.01.675B61D
Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7D7031A0006
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 19:45:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="i BG4CWT";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=gqFPsMeW;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787514301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B84SOBpXfchnbFJACUkoJj9mcWI8juB/tA+PVTwP76c=;
	b=hk8PAsF0xYpA6mjf2dXjG+nS0645erg4wpLVEdM9iadPC9mLrFRGCsD+lsxi7o9rPEpLYH
	9+UEszQRJBvYsBjFGVNsp1bfj6azezi3oeLj0Ep3HhSfWnaFWWhGj447SUnRjSPNoMW5Fh
	rylTNiZeOdXtKdXKKmz3tUqcJg+KAtk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="i BG4CWT";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=gqFPsMeW;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787514301;
	b=pYJ0sAxv5KSlHVrYrOxEJBHJoDK7PSeCCt2BBEH2j5Cwr4HLFYbrFP5AU8MwMeuAwtcxTs
	R293rGyS/HgEamDpafwXV5REF0vl4JpjoelAJH7k5ThA/ypYbcoywUPQTeykyT/V4gup2s
	gDvrp3HC+HHx+Y4Gqk8Sff5ObJGNTKI=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id 6F6111300087;
	Sun, 23 Aug 2026 15:44:58 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Sun, 23 Aug 2026 15:44:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1787514298; x=
	1787521498; bh=B84SOBpXfchnbFJACUkoJj9mcWI8juB/tA+PVTwP76c=; b=i
	BG4CWTAP7+gUYMgy9z5g4eejHoYHqYLzpMEXMvwc8rEEcV65F2hT1DyQ58OF8l8R
	WgZY5XnxgvH/HxEs0uw2gvpsHM4SCToVZVU91zpFUmrwDlXU4ZWHBRoY2OqDbHQD
	eRbIIkEmJp2qUYwwDw3DgMODVKW/xDi7pu/Tni5AQnASVWblTYLIRCFbIA79zrUf
	0sSjsG9mcfoW5SQX0n068Nh7idswA0izC0oeJ0vcQtLPDlZQTuB0Om40UxQD+kVW
	Y4cFRWFSPSV8OWCYX4/KsHWJFeqIYdGJmg/iCLX26Ex+70g/fKaMV3r51FTLY3aq
	MIYyZCKlzZSu5f+bK8XPA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787514298; x=1787521498; bh=B84SOBpXfchnbFJACUkoJj9mcWI8juB/tA+
	PVTwP76c=; b=gqFPsMeW+Z9xupKErzuF9zglO8p5tDXIu1unCaMFm/mG3ChAcdg
	QUv+NbVH1O5bayIwEw3wwy/EzZCYVIn2mrtK+ca66ks8vL2/30T6Z1foiwaE5t0I
	vXWWDOeHRDJPGmrDfJha2NbPyXUGz3a7eKHN/RbQJ2iTvAAorLYyBTNIySY2kUGy
	URRFbGBupkdvw3E87RUrHLylS4ktDl9LHqYJqXVtFYuCjUhHGFB6qukmIi3CYGFk
	k7g96DLhIDYj+ziRC7AfnTdpFoSB31oO2y7J2OK+5F/TMnpR0o2OVum4K+wg/7J1
	sTHEUzLao5kLp0XDuLveg3ZRREr4TTV4l0A==
X-ME-Sender: <xms:uU2Lat0wwgOYyNH0K9VuC1lRAv689_RmKhkIqm4CqaCq147FfNhjqQ>
    <xme:uU2LatEhyBrFCKxS4JhVXdR0aHUlmuf1MOInhugHgEWxaixPjGAJv_UP7YRRt_9on
    lrNtqcNeJOKSzWv2s0XJdPDnUnEslohFaF79Jm2lLG9Ag0LPuKodBc>
X-ME-Received: <xmr:uU2Lank_IVdvePPLo4gh0sd42cewsq1AWTLujf7Km2MIdfc_XJiBJpzsErs>
X-ME-Proxy-Cause: dmFkZTEF7/FO4zwyXX9a2VYUo7USSjPaeOP+cnpDM+WG0kKCq3cXs8+WFpXJLKiQaM6AFB
    9Jti1uPrb10pgcdMGQXlIi3HP2Xg0MT2tStA7MuH7LdjIKrsMlonkxDg7jHKTi6a1zBPyy
    gO0cPC/y5rpJbbvFWttg6jBkX7OJkcZGzLR/50kzal4cv+JmXzi3e+TymywizE9AYOviSN
    IWms+Rhycc4UkGhTZKJTm/xBReiFWIGw27IETfSNdWlcewX8droIaCy5QGmUYxVn6kD1qu
    LiobeL4lQDfnZGe2uscBDnio72jOq+cmJmGjj+aRP9+C4oAnw85Aug9+KQB2/HFi4pWzKD
    4g4mXewx2n7bApMhnOofVrvj3xCgxDEVO5MVTiYYK4narHoKgK/KdKYbz96jrf01MZA4jS
    cYp75MXnPj02AGJQkR359A0gixsHp7BzZIqP9OoYzY0PikQSY3NORG6m2qGqtsQJvHCvJe
    OIGMYyi1ivJRawkUzaAWyFgnhP2tJmATDXhLa0EwKmPQ7Gkk1JaIoeASbQp7LZEaSFpc17
    Rv/qMMi5Bj/OR8qCIyRBwa5Zh6y9xYxEoHDuhJ2XFE81usGGzlHC4Liq8u5y8fQ/Rc6gch
    +eAg3S6bawkpoEetyA5akZ3epiU/rK3dzHeUEbuTAZzafH55pvfnIdDHC+fQ
X-ME-Proxy: <xmx:uU2LahwMB45LiF7mqN6T3AUsJtdvv-ZIWd7ZXOZz3uMmqZZBXgyu7A>
    <xmx:uU2LaixseAHrYKsZEVxpe4ktK9xHMA0LIUv-kGZ0hcwmHMau5sZ4Lw>
    <xmx:uU2Laj8lHmf9-wuI84TQo9o7OR3A8Hi0ISCkIYwjqU7UQr242DGPLA>
    <xmx:uU2LaliIuTrmZf3sz4Vgby9rdhlSXXamo96Cw9BbkHnPSVTsqs6rNQ>
    <xmx:uk2LauR-8uC652xrjTvHDb96PrqUVHOAVMwQbuXXofXp7KTmMPlJPl54>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 23 Aug 2026 15:44:56 -0400 (EDT)
Date: Sun, 23 Aug 2026 20:44:55 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 04/19] selftests/mm: skip khugepaged page cache cases
 without a PMD folio
Message-ID: <aotHcV0a4bTMdX7Y@thinkstation>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-5-kirill@shutemov.name>
 <aoQuhSq-2Bd3Kz67@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoQuhSq-2Bd3Kz67@lucifer>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7D7031A0006
X-Stat-Signature: w73dy6qkxqg6w9413m68pb68pyak8pn5
X-Rspam-User: 
X-HE-Tag: 1787514301-92413
X-HE-Meta: U2FsdGVkX1+3sjcKxjNNW7Z2X/4RRI/IeHQTA1uEaYoVG4qYJI476eIBYwv3wn/AYFK3gCjfw41wqI9aFOf74F2TQSfI06nrNYmnROFeJvi1XywDXScZgdfmmkvbBKSLXCQEiSeUtVxqajDXBApUzmpkBEzCLIslDDLiAreaqsDz2sd6Y1RPvU1VCMYAT1wOFK482ft0deoGxRVZr28cn3zbAX6PVfxxBO77jb1jvWy8+Gwo1K3lAj+LMOTn+tdvoasjWV1k4uAqvPhTnF1kFBZI+0aLLlYhixlZdVRhJNNhltSMhpKw4QA++Nh6Sxpzh/pO/ERkfcAhbizNMAoM3ZnluYNAK0Zln++TlUbta3jv1I9yC5vnL0BpQpew6TufdB9a1aUR3s2UakgO61ImRWik8Q5tOrK693UoH799OGX6c8oZyjWBY7ax1Q2qYa2xSxX0tRl1t60VfaFjDqi+lqTwv6SGNpDwNeoM6e8Vq48zFkOttJCoos/yTIemDYDF2Hkb8quqaGQOqisOIhnJ4VZq54hEIFRrQRdIRdNXsx7GD1dt6hXG1XqFZ5RWl39SzagI1CDQ8/np3ojCOKNbCqLZ1f+DYSNn8y1B6WkyZkN+ngG16yiCj01pCLgKoUgV6uWjAi9CMIngnl8SIzZxEfR9f2sI0tNFGna6UTQW8A7uzLCJJ3+aM+yNsjMA6bpq/4SuDuRapEBpKNXLCsUxhiQPfVm1ezjOhbQx7twnyHawkJa2LZBVzNW3syD8UzhsqNUn+b8nYRjt8WmAJynscUIyqP0X1FBoM5disp1gsP6wf2zzPfEg5gLACh6hP2DegFPtsYvebpbWqPQelasP3C+sdWV+adriD1FTC2UoclfiOIsNk3Ze8umvWxH8kxZ6wQo9F1IXoaBHiQD0yyBABaS2A0YvEGqLvkFFZEiBHJKfQxN6x2rSVUnhJAuJiZMNAItEE/dLMWPPD/bBvrk
 mmewfqiG
 KX/NpvSGKPiXDc2wCcsVdQIHlHEoRulWzcxxh/8aAt+ve/NQNwzNbHrr40d+L8dZcTDMODjBZrmgqcAVYhUI1QFXcLJqGVCjYTz29hzBSS4rqU9qm71x4uy3UnRvkLIzGcWirgbD5vFYizO7YhtlA7l9WlUkh65BTkHY2FO41okdmoIzTHg6RtBVwKJ5CPUq/+TZDV/RXP2v5cR3JFeEg7cO3SWlmp9Lvj9YqtdUUWViuquo/Dw/bi4USENQcxhehNfJf2suCubgWIBauzRfroSW5GF/z6+SNTxU07/ICcHqQkpu6+7GxBTtdrzXnhfcgKjz6xdClEbWi7LggYj0VxXHQ6lpMiZnT/grTrxQgBYc4opxL/9Oj8aHcCLHg9xfudy/294UxUjTC3Rm3el1YCTYd+rZ6h6GQrmeQQlB4HtAXk1tZ2Yy1zIOJguldylCwoMYO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 11:07:55AM +0100, Lorenzo Stoakes (ARM) wrote:
> > diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> > index c499804a0ec4..ec5c36a19d92 100644
> > --- a/tools/testing/selftests/mm/khugepaged.c
> > +++ b/tools/testing/selftests/mm/khugepaged.c
> > @@ -1357,6 +1357,30 @@ int main(int argc, char **argv)
> >
> >  	setbuf(stdout, NULL);
> >
> > +	/*
> > +	 * The page cache caps folio order at MAX_PAGECACHE_ORDER, which is
> > +	 * below the PMD order on arm64 with 64K pages.  A PMD-sized page cache
> > +	 * folio is impossible there, so the kernel refuses these collapses by
> > +	 * design and there is nothing to test.  The cap is not shmem-specific:
> > +	 * it rules out regular files too, and the per-order shmem_enabled
> > +	 * controls exist for exactly the orders it allows, which is what makes
> > +	 * them readable here.
> > +	 */
> 
> This is a very schloppy comment. Can you trim it please?

Will do.

> > +	if (!(thp_shmem_supported_orders() & (1UL << hpage_pmd_order))) {
> 
> Is this inferring file-backed khugepaged behaviour from shmem? That seems iffy.

The helper is named after shmem but the sysfs set is the page cache one.
`thpsize_create()` creates the per-order `shmem_enabled` attribute under one
condition:

	if (BIT(order) & THP_ORDERS_ALL_FILE_DEFAULT) {

and that mask is orders 1 to `MAX_PAGECACHE_ORDER`.

So hugepages-<N>kB/shmem_enabled exists means "the page cache can hold an
order-N folio", for regular files as much as for shmem.

thp_shmem_supported_orders() name is confusing. I think, I will add
`thp_file_supported_orders()` over the same sysfs walk and use that
here.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov


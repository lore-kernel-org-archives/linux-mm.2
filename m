Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29064C54F54
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 19:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 143456B00A0; Tue, 28 Jul 2026 15:29:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F4436B00A1; Tue, 28 Jul 2026 15:29:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00AAC6B00A2; Tue, 28 Jul 2026 15:29:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D481D6B00A0
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:29:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 69F1CC030C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:29:49 +0000 (UTC)
X-FDA: 85039175298.10.CAFA1FD
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8F642100002
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:29:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b=0UgSYZNZ;
	spf=pass (imf14.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.4 as permitted sender) smtp.mailfrom=guillaume@morinfr.org;
	dmarc=pass (policy=quarantine) header.from=morinfr.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785266987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y3L93q//hccP4d99K2UqkC3//9C+6Pyu5JHp7SMLhSY=;
	b=c8GKsXMKQC2UjOGEDMsYGErSbvzhNGzD+fM+JHhkWx/vVnyr4RxsE8XEMeDLl7Gez3y094
	WvtDChiNOzYEKBYQ65MLWu25imXAguKVhWeZoQF3JfH5QQiWGa/5YrURJsXkVtO35ijmP8
	N3M2AFBCP7Wqd7bsn/AXSKg+RH/ddnU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785266987;
	b=7rKyuZ54fX7CBTo4LHZaMcVZqmQfhAkVkfWOBqNEUhBURGhaFBkMsrcnJODiKO57gVDQee
	4nux7Adm74yuilPmF9C7g0OCeqpJEKZQ31mbGoEQPJo2Jr/jWlKvoY5BveRS6KPw9ghyYZ
	ws9Sp16QsFJJBJw9EDMjpl4uj3hcPkU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b=0UgSYZNZ;
	spf=pass (imf14.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.4 as permitted sender) smtp.mailfrom=guillaume@morinfr.org;
	dmarc=pass (policy=quarantine) header.from=morinfr.org
Received: from bender.morinfr.org (unknown [82.66.66.112])
	by smtp4-g21.free.fr (Postfix) with ESMTPS id 37ABC19F59C;
	Tue, 28 Jul 2026 21:29:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
	; s=20170427; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Y3L93q//hccP4d99K2UqkC3//9C+6Pyu5JHp7SMLhSY=; b=0UgSYZNZRgTg2rOiBOFAQcN6gh
	0U4mGK7jUlRAxmG4DWaksFHpHM2ZpRsrnC2asLRMbb27KQTA6yY0ZuPozTtnaHY6c7YgontOVusOM
	XxiOns0aesiOYD3cPdBewHNEE6l4JeODm8ehScvrgSaNsBQCeEypFEcRagD0XQgfulx0=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.98.2)
	(envelope-from <guillaume@morinfr.org>)
	id 1wonUk-00000003rDC-2isY;
	Tue, 28 Jul 2026 21:29:42 +0200
Date: Tue, 28 Jul 2026 21:29:42 +0200
From: Guillaume Morin <guillaume@morinfr.org>
To: Rik van Riel <riel@surriel.com>
Cc: Guillaume Morin <guillaume@morinfr.org>, linux-mm@kvack.org,
	Breno Leitao <leitao@debian.org>, muchun.song@linux.dev
Subject: Re: [PATCH v2] hugetlb: only adjust reservation during unmapping if
 mapcount is 0
Message-ID: <amkDJlXL9y49jYC-@bender.morinfr.org>
References: <amH3AeO-PeAQoc34@bender.morinfr.org>
 <4439df28abd5150ac587b6a27ae51fb78bf8d340.camel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4439df28abd5150ac587b6a27ae51fb78bf8d340.camel@surriel.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8F642100002
X-Stat-Signature: wag9kfuqxgw9uqa8skxbgwm69yg33wwe
X-Rspam-User: 
X-HE-Tag: 1785266987-697929
X-HE-Meta: U2FsdGVkX19OWHvW7e/bnL0+KcZfvWBP/h8gR6iBqPvjxMDtw15M3bcqZ/Oia/ZHSZ5jruUAcWKRnUXPal+nOD+OaCDWm9wvcCvtENX6RKEp11e85H6WZ4QgGCzyjPx0hfXCgIK+7AcuGTAQTbrXqNucSvp7Aa3hNmdGKZmu8fotI7sLzJTSElCQ0pr/BZrWsz4PjLhjx+AVQzKC6l0LYKpyQCiHjJqTySwxJWMio3oLnm9Jp+7m0TO1Z26u7qj/hxalehdRguqsJY2e2tzEQusodY99F2wi0YNjvEOQThxJmLZ67+v6DvtvcCRliBiiJB43qU9bJsTuqY/V0Wql+qpVxc214q9SM29+N19N4mQRnODZ2JEvYDr365o1YsGJNhcrHAiGCWZoN6MzvvLo//pYHHKT5SLZfRvZcIEOkjVG+t8PeRm2Jyg0lPGxte4J7zmLfHNqj6OukCT+Oxv6g6A1BwQNO/EJTd5PkNu7QpCQiROC8uxqH6tWubmk0/HpPPg0MedsQlQEQY/C1Nm5nQaff+qWuG1jB9x1PUvgPLHpQhH6FayvzFUoH/cdWP3H2bUiMBr9Oc3jHHSbQrtjoUmFGQF77tUiEF8cQVIG7Ak8HVlxL3h6Ct6RKw8i4PpX96xb99QzAuOw4uwj1QI9gVhdH+TyqU04dGEF6pQTuvltsq/BbYB2cj2VkFF+5nnrsRi/S3z7rv3t3B9YuFLLCKGBKBeRPXvhWKqlTaHT0AKJTcR5JsKWWVraGuzrRIT9OrtnJaAAA6REqGPNz5/MwHO1GvEBnxXYwjdai9Fio98qJXWPthKBfHduEf9X8MhiF8ca9ANtIuuGMizSLhzvanG1Y7C2XjOlOFGGOlcT5BHUEzqwdoQKzw3U0i4DmEx+pLJ+KmDQcRUdALRt6ydrqdZjxz7xkeVePQBdtk09aD7ID3aXIICM8VeMbSwvWF3diYCmGw1jGbcehPRlHdT
 +ah7UTf7
 N/C1tzuI+5BWIiqY9TNQP+IGERyysKzlDkT/eO42H2Wu/y6AuzVVe223cU0ooNx7ZNKiIGNIjbOEPwBUOQUg7zpRJ+G9+GmoYRfAlElrU/BT2W9QjRHSy9w848tJWBmIBWKydZI3374Eb9NHV4JpStgqfES4LJ3qjq2NCQXcD2lQd/8XZHSocSpAhApx7TqqyUTeaYFA93t26GGEyweXxqu9sseFjJlcJyTgLq/eC+EyahF8wwEKvNXpNy96k5Lfg5OdPqRIaX8LI3EiHqnlecHdYnAgKGX5Um1XV4qSqGiCsn9U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23 Jul 10:23, Rik van Riel wrote:
>
> On Thu, 2026-07-23 at 13:12 +0200, Guillaume Morin wrote:
> > 
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 571212b80835..3feeac0f8eca 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > 
> > @@ -5252,7 +5254,7 @@ void __unmap_hugepage_range(struct mmu_gather
> > *tlb, struct vm_area_struct *vma,
> >  
> >  		spin_lock_irq(&hugetlb_lock);
> >  		if (!h->surplus_huge_pages &&
> > __vma_private_lock(vma) &&
> > -		    folio_test_anon(folio)) {
> > +		    folio_mapcount(folio) == 0 &&
> > folio_test_anon(folio)) {
> >  			folio_set_hugetlb_restore_reserve(folio);
> >  			/* Reservation to be adjusted after the spin
> > lock */
> >  			adjust_reservation = true;
> 
> The safety of this seems to depend on the caller of
> __unmap_hugepage_range() holding i_mmap_lock_write(mapping)
> 
> Could you document that with a quick comment above this
> block, and also add a lockdep_assert to the start of
> __unmap_hugepage_range() to make sure that the mapping 
> is indeed locked for write?
> 
> This seems like a fairly fragile area, and the locking
> requirements should not be left undocumented.

Fixed in v3

-- 
Guillaume Morin <guillaume@morinfr.org>


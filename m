Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D71B1CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 16:43:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38B2A8E000C; Tue, 11 Nov 2025 11:43:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33B728E0002; Tue, 11 Nov 2025 11:43:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 251BC8E000C; Tue, 11 Nov 2025 11:43:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 11EB58E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 11:43:44 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95F5316012F
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 16:43:43 +0000 (UTC)
X-FDA: 84098897526.16.A248AE2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id EEAFCA0003
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 16:43:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=A4MiOq+W;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762879422; a=rsa-sha256;
	cv=none;
	b=lTar6qZY5a1ge6SRR4gfBaAl2PKN8hh8EMRORzjHYL3wh0Prd8qNywpHTbDSCXFi6qCpI3
	ybt1/lAuBy0KHtv6J3CLLzwIv6L6aq+U0RsYgCoXI1cJBfjGFpWHPFdnOosbRR0EYYYCFv
	uUtFSe6kVgukK1mwr1wNbSSeqEEENhA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=A4MiOq+W;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762879422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7kUONsnFg9eyKhe0+h2kxSQHVhw/rjfrzCjpIXpzzs=;
	b=OjvYcMz8dwAj/YS1t1qwRQYSMT7O81pQlw4c+MrhDZccUBDoVZs8Pxo7QdfruSJSo3D2sL
	XZB7xmTnm+ATbBK+N4HH5YjJQt4gc7+Ra0GzFNi98ZA6eBKx4mdgFD+Re2aChtEwvJbQpY
	9ycqRANj7AUJb4KK8wvlqJjdrMPs5no=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=s7kUONsnFg9eyKhe0+h2kxSQHVhw/rjfrzCjpIXpzzs=; b=A4MiOq+WYSb0RAhEkMnN8EsCit
	dpjqJfnxKobjERQWzXOX1P97oI8t3Rkj/8CE3d1+JOtm0bwgwqqRRNbpANSXpBDXKBqfpqM5f04CG
	s9QkSFEAnB+r6CQxfkw85KinUlNPmfbzgCK1CxJ8z7pApRfX4KNZQq+ysPbI90960Kc732MTdPJq7
	hFr9/qEzvxczZCZy93mbzwanvF9trY+N1LvM5PqT5MRUdCyNWzS9QrCnkndgwlmd6miTroB+qbMzt
	5eyqd5xtK8Kr6tH9MJxAk1nOlo8aw3muGqGrWf1iCIywtqq/t0brE4M5w5hn1OFr8W2BOVdYzATiI
	Vz7YuO0A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIrT0-00000004ZcC-2bHY;
	Tue, 11 Nov 2025 16:43:38 +0000
Date: Tue, 11 Nov 2025 16:43:38 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, Vishal Moola <vishal.moola@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC PATCH 2/7] mm: Account pagetable memory when allocated
Message-ID: <aRNnulWuk3TO7VB1@casper.infradead.org>
References: <20251020001652.2116669-1-willy@infradead.org>
 <20251020001652.2116669-3-willy@infradead.org>
 <d71ad346-e88b-45a8-b873-c7a3def197a1@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d71ad346-e88b-45a8-b873-c7a3def197a1@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EEAFCA0003
X-Stat-Signature: 1ysi18d8th4dfyixgke8cuf1rmtcjq3h
X-HE-Tag: 1762879420-968445
X-HE-Meta: U2FsdGVkX18BDfyeF7Umgf+kYcXcXRwvPBDCUjtNfa+lb56iDKkS6+7X7i3Y3hC94saVuKk4NnptUQGYBy35QV8DVXE5bdXJw84+/s+R0WRrJQLxqyEInrocqK6klR7rwGcwVqyhPViwnHyve+cLCzBeGIiblRfIawtHEIPJ+q2N7owIXka34wA4d74FXs597AEczmnhiK5Os/Lm55cKDSzZ/Uku6AFAoR19cFzkuQo5djN3dXxm2qMwY98RFGH2tpHyPceo7fzpSa2wHNynSqbjND/fXBkBlC4I896eM1Chhutvw+CgYgg8GgcsAdTuBEZGEGhJzOV0EyPVgOYEnHeX88S1wmTUCRu4Ow/WQTQmXD3hk7jFhIPQyKX5HF4BHOwf7rfe/FanxG5J7IfCBMlWvRHMjCfEcxr02sA/N+KhbeECzUqrugXudfC0GTbO/Va+g911eFvo/QXV4UOfRkHaA+F4/uHUoknLvAKIJCW2lVninbtz43RzLYVaeQHzZAxW3xvQfDNqGjDnzzkqCiJGdJL3/tzd9J7DklK03OyjwWhY33iXtWIswiFBKuV9D4UkGvgaNA3KNKxV/06lY0cogHovUPoi/mFKfRMCud5l0f45lKdOUj10QFBhg2xKjQuuffeshI9lDdSWCdlNtJBo1Cjhk3iiAnb5BhrHXI27CfJgnY3atWxjUV9d9wzWtMdrcAOo5hisFh4eyGOegPIZm8USQ39zwthEVb5yRXmvrkjGmj2FaFxtsmh3QH5Pw9zfQLF+iM14AdPoiwFi3s3snn19DB0lMp0yx16D5h/cUmNkwyDcfz2+zDM5LacpD/JzeFUoaXqMofQzaki8KP9clxnlwjeS4KaKAEDSAY4dgBBIc/Y07vB/bxU5r/nXTFRC3aluJqA16553dQcO1yhcfQeRDIRNh/oEzHVP9rAQGJOQgmQiP8K9VxqFaDbBeu53i7M0RhLWxCTvo4I
 AM+0Jmzd
 4Kzi7uknynRovVtnXUk7LIGn/o2TDjlaKMk4Fc5MuzsEQqlM18bgkKMUgevgoFWHuz+wGBxzzMRMce20fxM3w6MwKiYaen+H7f65fJoP73pjpjm6M/sZTbzkYifJy5KqtUAbeHAlcKoPgINEjlOTmkcDoO0N/cfN0ewQT3E9eIb/BTkNROz7OKPiw97vAiEvSOgsCRR+7mrVZ+F91SFFiT2z0RH6iZSTyVgJvhzzPqKwJBnIv5wY+Knpm4AePX+c+SeW9i3MY1n9ZdORSHVyXOCSdFgoQi71+WS4oxKz2g1qn9NGA5bysvT0l3OFcvYQOkf8X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 12:39:19PM +0530, Anshuman Khandual wrote:
> > +++ b/mm/memory.c
> > @@ -7280,7 +7280,13 @@ long copy_folio_from_user(struct folio *dst_folio,
> >  struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order)
> >  {
> >  	struct page *page = alloc_frozen_pages_noprof(gfp | __GFP_COMP, order);
> > +	pg_data_t *pgdat;
> >  
> > +	if (!page)
> > +		return NULL;
> 
> Should not this check be moved to the earlier patch instead during
> the page allocation ?

We could, but since page_ptdesc() is only a cast, there's no need to.



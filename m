Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8648CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 15:45:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B8F78E0026; Wed, 10 Sep 2025 11:45:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 190D88E0005; Wed, 10 Sep 2025 11:45:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A6CC8E0026; Wed, 10 Sep 2025 11:45:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E92CF8E0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:45:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A5609160128
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:45:03 +0000 (UTC)
X-FDA: 83873764086.24.93B87F8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0FD5A10000D
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:45:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FSMyqJWa
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757519102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R4SFRua4tQ0Gijz9/yISvfIst143Bm6fRH6N/9ViY+I=;
	b=z1MkG7XSiuBrkd41LnsUvHBqoPANXK1Yp49BBOSpLU+M8By4hNcPlXugrnaiV6CdPAQqO4
	2g/ym52GsK0J4IUchPOIcFMcJe+rqUcjDpcvKND7sOl0Iw02WsdxKbAtbc1S+F3s8Bftqu
	RHzc0f3h+QFhb4L34tJNE2Gm3+KqPII=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757519102; a=rsa-sha256;
	cv=none;
	b=WrX8+piCet3OLuwjC9Z7VynX006cwKoi6PeJJ3iCL3XVBvPtI3gOO3KLzokbKkz7klwvtT
	AKh2wlZjRtB+alS/vyFnkktVAFoJdRbRFnT/p01CmdDPUl3cdqQp/J26vIoT6V8oGaNyrZ
	wDi/7O/64ECC9VqT9sx+yZL++XoBzJ8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FSMyqJWa;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=R4SFRua4tQ0Gijz9/yISvfIst143Bm6fRH6N/9ViY+I=; b=FSMyqJWavJW0jS2IPwJx7uChbi
	cZ/019mkqwHp/YhwTm1qRUdfMyJY9tfXzu0mC/NzBeOJFfIA59vSJAdJxdqLJK6oDI6Id4Qw5shm+
	EGZiLadAf3XGfTFRCJCKeMVaFYgWw+XMUP5m5Si0tifUSxC0YG9mbTVuIIXqPeaemUgEpx2D1C17z
	BwwCct5LxRl8l6L81FM8dFyJjfrfcRIyripTxvuwz4DynYz9Ue6lWf+I1/ZBlIDye77tvLB4H+dBC
	LLhp11tT9dma8uO8uhPwbRFjSv9IalKx2GOEyK6UfkQhuF6KeLuHFr4msk8nsTEaAULjpxK14OTXr
	omP5A99g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwN0C-0000000BKmy-3NsY;
	Wed, 10 Sep 2025 15:44:56 +0000
Date: Wed, 10 Sep 2025 16:44:56 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Chris Li <chrisl@kernel.org>,
	Jason Miu <jasonmiu@google.com>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH] kho: make sure folio being restored is actually from KHO
Message-ID: <aMGc-ExhkqwAyY_C@casper.infradead.org>
References: <20250910153443.95049-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910153443.95049-1-pratyush@kernel.org>
X-Rspamd-Queue-Id: 0FD5A10000D
X-Stat-Signature: 74gkh7kx961ma7erx75asc7c7qb3sysq
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757519101-967769
X-HE-Meta: U2FsdGVkX18vFCACOFtndSVlMXzvNPiyRVkUHcWWQG0Qr3xDyRYCAtS/rO9XIeSEaePV9hTJFVXs0pn/qpXrduvzGpBwuGTN+05aBr0b8N3jSmXUe6VEm31tNftDbAjbNkx23JdmCNmvTiI7YM6x0p0KY3PjGgBBH4adr+3OrVMLHuKMpZR6M9uQXWrO2aFZoU4CWCIzYvlC5+6AZsvOZ4ItwLRqc3c+Pr5NmBLlb39Uxo12WQwudOSMHXNge03gC7t+ixNSWV2iofGYHtbkKS1WkYKIENM1H1L3sGFEEB92c8Q3LGCMDnMCPWkugAdIhgi/aDdbYF5aMCAPszf9FD6Hcda6TZ2LFxYeVtO6w3PbP4vynANHrzuwmDYC0S5gQ3yj4IEgTnKqNe4RW/vmpV3o9ZBytoIFE5QL/IJYQMvQZVOMPABTu8or6wOs+7gfM6nrLxXBMjoEgmuAqj3U4jSDzrtpQiAG2J+qMB7Fhj3hZZU9mCADJwp3HSYx1bzZqsMFT+bvXAuyi6Q2EfCQZ9kYOZZs/sZTpH2EzCJxPaP8q0jeQV67B9C1MZHjCk9/VpxMAUKxZROI256LEWhJVugztJK8OTFbigHYJwjo0cjHbFwDHqG2tP0vrX0ctI+UvSRfaXxwmyubRaeBHC0R7tt0RBTipz+ZtWR9OfQ/2sho7rGKqceFyQOrScIJI0FflpiiQb/m+9R4nNej4BwReouzjxtY7GL2YL6OSQ2HdZx+E6XUntqlFle6LljS0e7VM9ixjmIggdBDMxidq8I3YiA2OmARLW6aEnYDl93dexsAK21f0DOhTh1H1ygmpNYxtArqjz9tMbulrGHSNbaaeUxfZ9HGlrFUHYkufY2Ao6vOPeg47H8n44hg4e4Y08/IxgCBlGTQFhFjqXfd/MmEkOqmJ+nb0+PBDs3Ebb6Uh9ylwyicK1gkcDmO+woGk3JCTmH7uSiG16Ni+dlfAv3
 Zw6r3Lrz
 SVPwj7BZMZLIdgsEEgpaUqMj9AmAJX0WdSxJV02yJNnv8qhCh9N4SgmH6CcGTgt1mplCl44LbSo5RgMnLguPdsseKoe2EexbFPOhmsxVt0jal8DtE+pWC2CCAgHlwT9BG6pFWlZoW9reG3LU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 05:34:40PM +0200, Pratyush Yadav wrote:
> +#define KHO_PAGE_MAGIC 0x4b484f50U /* ASCII for 'KHOP' */
> +
> +/*
> + * KHO uses page->private, which is an unsigned long, to store page metadata.
> + * Use it to store both the magic and the order.
> + */
> +union kho_page_info {
> +	unsigned long page_private;
> +	struct {
> +		unsigned int order;
> +		unsigned int magic;
> +	};

KHO is only supported on 64-bit?

> @@ -210,16 +226,16 @@ static void kho_restore_page(struct page *page, unsigned int order)
>  struct folio *kho_restore_folio(phys_addr_t phys)
>  {
>  	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
> -	unsigned long order;
> +	union kho_page_info info;
>  
>  	if (!page)
>  		return NULL;
>  
> -	order = page->private;
> -	if (order > MAX_PAGE_ORDER)
> +	info.page_private = page->private;
> +	if (info.magic != KHO_PAGE_MAGIC || info.order > MAX_PAGE_ORDER)
>  		return NULL;
>  
> -	kho_restore_page(page, order);
> +	kho_restore_page(page, info.order);
>  	return page_folio(page);

This all looks very confused.  Before your patch as well as after it.
I don't see anything in the current KHO code that requires the
phys_addr_t to be order-aligned.



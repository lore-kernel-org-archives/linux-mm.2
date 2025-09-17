Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04563CAC599
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 14:31:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 488118E002B; Wed, 17 Sep 2025 10:31:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45F218E0003; Wed, 17 Sep 2025 10:31:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39C018E002B; Wed, 17 Sep 2025 10:31:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 284418E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:31:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C097286ED0
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:31:53 +0000 (UTC)
X-FDA: 83898981306.07.85A91B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5835B16000A
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:31:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sQEqNcn0;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758119512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IQjHIFDkC1WkWh0EEfJ/NlvfY0iZZfOI5h7O8E+zWgQ=;
	b=P8Bar41gonLjmzllrlu/UNJZF7KNaSg9ABRuNS8eCWbJaE1xkG1rmhZqnC7Y97lQv+Rh2r
	DrwzW5/PmUxaKaLf5Bcfu92IbePjjVcJTAp/CN8W3UB18Sv8zG4igS6sQCB57Xu2hLPtDZ
	9/X2HuGhOlDo+xVJiQVBWX6rkrynyac=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758119512; a=rsa-sha256;
	cv=none;
	b=rPyn3svDdOfGhHldXIy/Y+dChlqk5na3D2S5saBDcym4vCae6wP11/54OdVnCLU0F5DuhD
	Ce9V1bfMUu1HICu0JahGBSjDFptJAFOPOuv2rVzZM9VHshOcnzeohWo8bTu4Jvu3dctEGl
	iaC8m+8RPWo0k+2dYcM0KRIyfqevVz4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sQEqNcn0;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BC83860240;
	Wed, 17 Sep 2025 14:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FADCC4CEF5;
	Wed, 17 Sep 2025 14:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758119511;
	bh=k9cG3kz/ofV3MOY4tO3NxTa8C0lQ0KwhYvMThaTJklY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sQEqNcn0RVU/IcZMKtRGuPfTEkCa0ftTy/KsYvzMc3vySV8NIyQSfoyOOB2AZ0qf7
	 uvKDbh8G2D1egXCoXYyAkAROQqrV/L6uYZ7WwgHjGV6vU8XN/U2gdNN/81/ykgz74x
	 BKM5zcBdLMGa9+WaH5hvAylH3sHfMjkc4ahHvOAvCLfYgVwBPOFIVTbNicQsvWEIor
	 nkYqUQw2pr2C/CaUkc+/SWb3ZjvoyWXxJZ8jQhUlkTcGlL0mShtgbI6PzxxuQVbuiO
	 duNhZzx8ephb7lWkr8DQmTnrYbA5pTXGmjtpRlB4u3M1eBQqoK/0aWk+CWHFSahNCV
	 GweR5D4v6nbEA==
Date: Wed, 17 Sep 2025 17:31:43 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Changyuan Lyu <changyuanl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Chris Li <chrisl@kernel.org>,
	Jason Miu <jasonmiu@google.com>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/2] kho: move sanity checks to kho_restore_page()
Message-ID: <aMrGT9IyHBFe5-nH@kernel.org>
References: <20250917125725.665-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917125725.665-1-pratyush@kernel.org>
X-Rspamd-Queue-Id: 5835B16000A
X-Stat-Signature: owdqdxt95w5d958jwy888h9m3b1g9f5k
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758119512-485226
X-HE-Meta: U2FsdGVkX1/+FmXPFYW8tzYieTE3R9pUqubyMVu4emPrLVRCZ9qyUtaHgMdOu0kzBC4H2HSAmP9sPcAMjCxuO7mx3iUaWKyYgtfYCpGLbWn1DpdrKnIHqtmJ82srZZnFhYakV0CfVd9UX5Iy27I52whzZupz29vlwKN56MI+VVWxJISUL4WrgPj6x6LMv8cp4b1+Z+YTBi6nudm6xeBvpXWfNZj+NMRrJQnV+0XmRj8cj8A9dlcXu31VeozHEE2fLiENGzyF8N6xWrGypm7+zfyaVXkWxU1A7JztLqqKmpPjuHaNoIryMWQvjyoMQDtO3H4F+vJOhOPCFDSw9tR/CHwx+wv56NKj1zN6uCGkSzfRbPROtftSvp+MZJ6gB+clBIWrzT+BfEUYEClDG80l9qFASMDFOdOiobpnfZ0m/zt3M+jLu3OUCfA4eW3Kj4BFEeSoojcx0Wr1F2QxnQ2UfF8XJEEUEbG9dLFo4HbFvLI48ymiZ5qI1+Ex6xRq8uksbnvPTUk04soyjw5fRV8CfxKeD8vhzPVDPMaLwvYcBmv/W52u+6gA0LrrT2am4KGvhM8RF4Q5J3Wh/UVPMI24rCFB3hlwDzshHjqrCr2BgZYcm/SVGmOWEoLVxJ8377XQfLd7/1YIhj5YBUZhBEWnS7376dVHllLqngo51rXtImDLwDCKbwsLpug55627D41+SaWoo12h4V+LUhgTRKhnMiFVszQj1NjnR0eHyiR34kKQMUXWuU5boVQ05iaq7F/8NuS/+i5ATsULNfRr42by5PXYpN0XfSQgu+b7lx1nm64aZ8plOzVN1WrBKbNCQYFJMLhvUVS166XmP1h0hJoKLLA3LkS4bpAoi4rtmI0UNZHVo2PoQQDPLFWgeICT7RUVdY7J4YFNjmCz2Pm/s72aQrVN+lDvR2TcJghYcKNmQJLKb1znOQsUm18HgCEINYx9QjevDiRYTyElsp8FBoD
 9LxsJmml
 14BFC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 02:56:53PM +0200, Pratyush Yadav wrote:
> While KHO exposes folio as the primitive externally, internally its
> restoration machinery operates on pages. This can be seen with
> kho_restore_folio() for example. It performs some sanity checks and
> hands it over to kho_restore_page() to do the heavy lifting of page
> restoration. After the work done by kho_restore_page(),
> kho_restore_folio() only converts the head page to folio and returns it.
> Similarly, deserialize_bitmap() operates on the head page directly to
> store the order.
> 
> Move the sanity checks for valid phys and order from the public-facing
> kho_restore_folio() to the private-facing kho_restore_page(). This makes
> the boundary between page and folio clearer from KHO's perspective.
> 
> While at it, drop the comment above kho_restore_page(). The comment is
> misleading now. The function stopped looking like free_reserved_page()
> since 12b9a2c05d1b4 ("kho: initialize tail pages for higher order folios
> properly"), and now looks even more different.
> 
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> 
> Notes:
>     Changes in v2:
>     
>     - New in v2.
> 
>  kernel/kexec_handover.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
> index ecd1ac210dbd7..69cab82abaaef 100644
> --- a/kernel/kexec_handover.c
> +++ b/kernel/kexec_handover.c
> @@ -183,10 +183,18 @@ static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
>  	return 0;
>  }
>  
> -/* almost as free_reserved_page(), just don't free the page */
> -static void kho_restore_page(struct page *page, unsigned int order)
> +static struct page *kho_restore_page(phys_addr_t phys)
>  {
> -	unsigned int nr_pages = (1 << order);
> +	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
> +	unsigned int nr_pages, order;
> +
> +	if (!page)
> +		return NULL;
> +
> +	order = page->private;
> +	if (order > MAX_PAGE_ORDER)
> +		return NULL;
> +	nr_pages = (1 << order);
>  
>  	/* Head page gets refcount of 1. */
>  	set_page_count(page, 1);
> @@ -199,6 +207,7 @@ static void kho_restore_page(struct page *page, unsigned int order)
>  		prep_compound_page(page, order);
>  
>  	adjust_managed_page_count(page, nr_pages);
> +	return page;
>  }
>  
>  /**
> @@ -209,18 +218,9 @@ static void kho_restore_page(struct page *page, unsigned int order)
>   */
>  struct folio *kho_restore_folio(phys_addr_t phys)
>  {
> -	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
> -	unsigned long order;
> -
> -	if (!page)
> -		return NULL;
> -
> -	order = page->private;
> -	if (order > MAX_PAGE_ORDER)
> -		return NULL;
> +	struct page *page = kho_restore_page(phys);
>  
> -	kho_restore_page(page, order);
> -	return page_folio(page);
> +	return page ? page_folio(page) : NULL;
>  }
>  EXPORT_SYMBOL_GPL(kho_restore_folio);
>  
> -- 
> 2.47.3
> 

-- 
Sincerely yours,
Mike.


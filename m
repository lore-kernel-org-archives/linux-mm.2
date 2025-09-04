Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F22ACA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 11:54:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5FCD6B000D; Thu,  4 Sep 2025 07:54:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E38006B000E; Thu,  4 Sep 2025 07:54:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7A426B0010; Thu,  4 Sep 2025 07:54:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C63716B000D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:54:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 56167138F32
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:54:35 +0000 (UTC)
X-FDA: 83851410510.12.3772130
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id A3C6940007
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:54:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BTJP35JU;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756986873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d3eb554Z7Ch0HcrIOHymmXDKFwkxTvkgcWCnRMUziz8=;
	b=jkMtSU54nNcFJI/96m7jISiJwoYDDhxHWA3g6L1Pg7ktGIOVcreIxOdE6OySvHbu/bd4FN
	AqFYUUGxLSS3HuKEXoo7qqIMmfQfh8YsOPuQ79qZdK6J13UHcFutG7q+cRWBBtbkz2NYqu
	FzWvZ12gKJPFwjt42ve02DAiE54g6sQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BTJP35JU;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756986873; a=rsa-sha256;
	cv=none;
	b=ogT1c3An9pcU51mdc0TA38ceO5Rsq6lTlngIViQkXooghiAkyXiDqeMisJQrIBPHsxNqJA
	XsKjMu8vy6eHcTzDLB3/2IH14fCtufbQ6HMi3DwvN83aFy1ncOTY+4aLuIZzrr5fUmFBL7
	8qQnZ3GbgrG3YXIFSzDhtp9+IJB/dfE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F212409D2;
	Thu,  4 Sep 2025 11:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDABC4CEF0;
	Thu,  4 Sep 2025 11:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756986872;
	bh=XNw4rOgmiaWNTpi2TJxzNFfkmGLCRGvr1utyFAJh0o4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BTJP35JUbDeQc+Ux8kuW6NTKeHZlYtCpvd5Y8hwmpXzhYILW8ENPq6hqSReA5g5/6
	 hOGPCxSKn2qv5RUsEt5nNpjBiltFo/1MRjz68DyYzmcbGjr5igdtoLfs5ouTlPr4Ee
	 3yDV37FRzkBEVcqKKTjw4tgWqJgRTwgLMYbPrk0/OXslt07SIo25uSg/GlGwm0iAhF
	 pGn8i6YHMAWNn5ahy/gQXK67j3TEuBgFMnVlMDIkSZ2wMzzU19AdJHnrvY5CVqAFpe
	 kdWJ/VlmVVSdDdbkfxzS3KlHP63+mdVglkhuJwMdFlFFV6c6uz6NkFHArciCBPeJX8
	 R5uzN9QaWbXIw==
Date: Thu, 4 Sep 2025 14:54:24 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
	linux-efi@vger.kernel.org, virtualization@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 3/7] x86: Stop calling page_address() in free_pages()
Message-ID: <aLl98MQs-FlHo6bW@kernel.org>
References: <20250903185921.1785167-1-vishal.moola@gmail.com>
 <20250903185921.1785167-4-vishal.moola@gmail.com>
 <aLl9KneqOYTujcCh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLl9KneqOYTujcCh@kernel.org>
X-Rspamd-Queue-Id: A3C6940007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: yyc69xfc5uya46pdcqaf7ioh3qe3888m
X-HE-Tag: 1756986873-694173
X-HE-Meta: U2FsdGVkX1+udzYO2RXFnSrhUpPDLN3ZUq5EGc7gpDpjLB5BaoUsWpiVuiYntLc1/YtzuqB56RNSF2EMbI49Nr4G0WGvfOMwXmpc1eDBVjVN2+ZmTSTp+GyaKR69YfqP5Uj9vcJ7hLqmKVWbMimKEkzroxDmPmPE5OjuhSj5Xsd0EPRBFCUTScyJfDWNfu0seJkQVsBcohqPmrpgTsnyidjaMEc/3jLlO8vOFBVuhjFmysSecRuugTNs2VJKF4AylB+SqZDcu+bShL9sIqqNpV8Zbe8+7q+p4m33Uh8z9LEYzMBBsn/kzQaYXktDh/XbxUaudsC+p3xAib5DU30HwDZV1DKaTdJ66zTV5ttKVOXSHHqPG+zWaK+SzofUrblndeEXrdWxBfhf5lYWiB4S/CE9083KMfQZvZdKrTODbqGbzrfoD1y/tfvUg87e/yTx8pt+v2Sac21tHWCdLQ1jhZm5v7aOerh6gpMWoOj9IMghGCMMpai9VHQngeL1xNtTAFfGU83HYQK5haQWtpoAvovb2EAC+8QTOAMi4ikq3LFqbLnxEcyHvATxc8kC7JpR523/Q6rRASxiohDQhBh3gRXNtMb/aMHsir1cJizGW3wHwjeo20RPucM9rsRu1yZYybRNRkweD1/mgElYGqFHnLxZDMlaKpDjR7iLGOPh1fGdS6M4ipcEZUc8DrYCwm+tuR1x5iQdNgsQfWSXN5wjGy2Cg9yhz1eTixpbtnOfJzS+81x0ESt8VUgFjka0Wvsi8h1Cvr6u94xNU/KOrG156lRmXwOeLgGtuq6aD3J1qR/BqyQXGZE3PFW2FUJCoNgNNyV8TDtzd9Z/qInr+eyzQUPeP1+GnoQiCHgdIlEiXeeC25HeSJo6nwYH8tIdjye5TbuszGeWuUI8zuC2GJKm+QAPmxcY6ssy5ezqsDN1/DSWREJnkylDAwr2Xe733YwjtBG2NkUfW0q9TnUZ3Oc
 6lTDf49e
 fuetdszcKR48bjXyX5IroH5RXtIln90cZDot6SGE8w9Sx9eTaifBvIVCvwHRcHpUp8dFgLNjPW4efmvxIIG9RHYo3bnqswy34/f+oNcZzY5Ejfgd2WRaZxmW85uYpxshU/gNkzDMo2qoV7CcbXP+JXwnVGdTHSVA8UKme+946/BwN0DSV1COHBu9cMNWJc7FCiP73bCxgOfcgpnV028GRfmaxc3Ys2WZDTW5EJgStr5nXpz+kw+zfpipz2+TxiXcotpIrnTE5WqIK3F4aXkmMtHfcaU1UMtohe0+vrYMOOvyEb0apuFwr1ezIOGyRidYiZSSHvOtRfKW68zNJOOgI3j0UFvUnLbGTb6tRvCfT7p19eHLUO4heEitjYKbFtoAUCmZDjvVCI1pigR7Y9BFaXvv9BYRY7P8eiR3S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 02:51:14PM +0300, Mike Rapoport wrote:
> On Wed, Sep 03, 2025 at 11:59:17AM -0700, Vishal Moola (Oracle) wrote:
> > free_pages() should be used when we only have a virtual address. We
> > should call __free_pages() directly on our page instead.
> > 
> > Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> > Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> > ---
> >  arch/x86/mm/init_64.c          | 2 +-
> >  arch/x86/platform/efi/memmap.c | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> > index b9426fce5f3e..0e4270e20fad 100644
> > --- a/arch/x86/mm/init_64.c
> > +++ b/arch/x86/mm/init_64.c
> > @@ -1031,7 +1031,7 @@ static void __meminit free_pagetable(struct page *page, int order)
> >  		free_reserved_pages(page, nr_pages);
> >  #endif
> >  	} else {
> > -		free_pages((unsigned long)page_address(page), order);
> > +		__free_pages(page, order);
> >  	}
> >  }
> >  
> > diff --git a/arch/x86/platform/efi/memmap.c b/arch/x86/platform/efi/memmap.c
> > index 061b8ecc71a1..023697c88910 100644
> > --- a/arch/x86/platform/efi/memmap.c
> > +++ b/arch/x86/platform/efi/memmap.c
> > @@ -42,7 +42,7 @@ void __init __efi_memmap_free(u64 phys, unsigned long size, unsigned long flags)
> >  		struct page *p = pfn_to_page(PHYS_PFN(phys));
> >  		unsigned int order = get_order(size);
> >  
> > -		free_pages((unsigned long) page_address(p), order);
> 
> Could be just free_pages((unsigned long)phys_to_virt(phys), order), then
> the page is not needed at all.

Or even __free_pages(phys_to_page(phys), order);
 
> > +		__free_pages(p, order);
> >  	}
> >  }
> >  
> > -- 
> > 2.51.0
> > 
> > 
> 
> -- 
> Sincerely yours,
> Mike.

-- 
Sincerely yours,
Mike.


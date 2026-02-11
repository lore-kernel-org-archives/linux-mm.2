Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30017ECD6F1
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 21:54:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 700C16B0005; Wed, 11 Feb 2026 16:54:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AEED6B0088; Wed, 11 Feb 2026 16:54:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BB396B0089; Wed, 11 Feb 2026 16:54:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 495EE6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:54:16 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED5331B3EBA
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 21:54:15 +0000 (UTC)
X-FDA: 84433529670.09.3352855
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id BAFC640007
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 21:54:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=t1oDornp;
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770846854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KUh3UhYVLxnVGTyEmDq0tNLkmtCDXwkX7nTOeGCvg0k=;
	b=4gM6GjX7zJJZ7vIl4T1om3fMZwlyAXEOfgAU1FUVg5WVjcM4jTjs4KiMPBCOVgksLO6evn
	6NacSPKLYc8dO4jSB5nKj+nwITlUC2lxf/FO9NCseeeyoiaJ/+yJJMuSP6T4SP5B0JMIoW
	IVZbEBsEO8ZFXmPLJeruqpAgf/Torsc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=t1oDornp;
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770846854; a=rsa-sha256;
	cv=none;
	b=x4xPOFmmuxY3RmnjpRYZgdLpbab6jIyHVU+oSFrt21Gqtn17ILudlww1q9AtlDgoTJajbJ
	rfzkS21I/gGfMHUVrHpnmUAH888eVoEg5i6znzOfGuj0nW1UN1XxeiFRhth/bKqBaxPonW
	4hIA0PDOcyoqAfhVxfKbnKnHv8qw6yo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KUh3UhYVLxnVGTyEmDq0tNLkmtCDXwkX7nTOeGCvg0k=; b=t1oDornp7NQDlvItNaK0tqP4+v
	dDfyikSSCatEOuKB//PS8L4sy6+ijCSZrj5cqDxoJ7kxuA0/sBFeN741bW0slQvw+1Wf3+ooLYW1y
	qr4quly/0bRP8/NYGBV5/2p4kR3jVOyWJxgNTyKxvjZK/FeY2lRs93Y0OM58F1QoGJwV/mhaay1eh
	HrHdvqJegXe0krBO/xwuqhPox+abwr7Czp863ILjN5RRHEKgWRuMDUmhl9mDnuY8TNVpPXcxsidTW
	05WVf6COxElwMYLW34hOzWOfInJwZedzgRn7zm83a336GvJ7BtG+9byWqMKsYGDgCP/PPHAG2VbNQ
	UoXvgOGw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vqI9y-0000000DF6Q-0X5i;
	Wed, 11 Feb 2026 21:54:10 +0000
Date: Wed, 11 Feb 2026 21:54:09 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	akpm@linux-foundation.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v5 1/4] mm: Add address apis for ptdescs
Message-ID: <aYz6gUzhQixi3LFL@casper.infradead.org>
References: <20260211195233.368497-1-vishal.moola@gmail.com>
 <20260211195233.368497-2-vishal.moola@gmail.com>
 <0ead4a2d-c88c-4c89-b1dd-5954c28edb99@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ead4a2d-c88c-4c89-b1dd-5954c28edb99@intel.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BAFC640007
X-Stat-Signature: rgref6yg4c5kg14ecttiw16ogensxd4a
X-Rspam-User: 
X-HE-Tag: 1770846853-289436
X-HE-Meta: U2FsdGVkX19C1s9e9aM7uXczEZC8gt/SrpmTNVWdUVAXnNqpnTIAwkkjNQ0xG+YGMPwUD1Yk6FH0223Gwsg3EJTsMBduNfl+vT+n8QS18z6OhI+Ec3DS3VHLOO0CjGaeffaRVUfYhEbkiyYuXanroHRTur2ZK+eK9UlkC28YChyy6cFUgRTA4auDYhkckM9O1ZWRZdY8FJ7nIbixkW9AxE7SWJU+bHSb79VkrrawelLyGnV/Dkd0vETd9JH1k4Dg4bLZtiK2fv0QvF5u4xhZV9pAGqyTSur8mWTcActTd9zfp0SzucEgjmDpw1oaMLO1j4Wn45fdETHc/AYDvOvO8/Oo4PmTsigIpIMTnOLVFELMU4Raw2rx9dULY+dUD5XsyZtO9dWr7DPrHKrBuUA3OL+o2/LwqukAC7XEc5j1KGxa4khMKclxCEsbmnKyqNiGjx1OvcELnRpthLpuILPPc8T8xc+t+emyrwDyoBMBStvWoukPc96d3lWVJt503bhrgb4opQCIhJBjldeIH0M7OKYnnl1mg5HjIDB+wzIZOj0fyNdiwcdrg2LYx5DIU+xaIDl7XK4PdYrm1Gv7EyDz3iXfoVtpxv8tSW75WqvJZydqA1klvOz2bi4c2h1i9wiXyVIAu12JDAkqeLo0XAIwOXkCuIX/WUVBhQFK6xBropiJyPXBLklr0q8zctk7DGIx8mhcmmZxAYj2dKdgokT9Nt56Ttp0ozXhRCHEs6M5cQF3WmnRwnUkBWP8IbNrSTS9PvorSf2FQKGIvmP5QSjsCP66bZqCnLrBhz3rjzC5A5peM77D78or+UA+88+qEUJXKVSazN75PrWcpG2FWCaAdwsfJweHHpR79A9BY9xSc+Vly7w7fymTVP5JptJ6k/DAg/RjvxBZmbqwY9YmQE+isYKI0Qcc6zxOx98oZtbWZz+cqz3HZVVmz3ALGF/XzugzIpEIPVZass2MA8zO5hO
 P6Kaqm2Q
 G1q7ZpgWK6pswyeLZigf3u+yI/2ZapvcvYWf31Zgg/DwIMuoZT2pnllsfDgtQO1W8Z2ZPjhBTuzZlBAoqshViBGBU1VgqYgSTOwXpR5g0Cq/OGbv5k9uWZ+fxmfBfW2p9fTNIPyB0sR85h1uv7RihKweMssKxGhS0+q7rGAud0V6IWL8QLBHl7L7DJl660syH5pxprLrc9ysmseAZmmE9zNSPnwPr02//xGa38vDWVk7BgFLuD2NaZ9YwAW26iwO+gP7vgW7uHHRlcAGZJsqRoWA5aSwPefSc2jXl3smQZUp64gWwKWTGMyWtbGmnR446+oSa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 12:13:10PM -0800, Dave Hansen wrote:
> On 2/11/26 11:52, Vishal Moola (Oracle) wrote:
> > +/**
> > + * pgtable_alloc_addr - Allocate pagetables to get an address
> > + * @gfp:       GFP flags
> > + * @order:     desired pagetable order
> 
> FWIW, I don't like how pgtable_alloc_addr() looks in practice. It reads
> like it is: "allocate a page table address", not "allocate a page
> table". I don't have a better suggestion other than having:
> 
> 	pgtable_alloc()
> 
> that returns a page table pointer, a void*, and:
> 
> 	ptdesc_alloc()
> 
> which returns a ptdesc*. But I suspect that would get confusing at the
> point that ptdescs _themselves_ start getting allocated.

I think that's fine and consistent with folio_alloc().  Internally to
ptdesc_alloc(), it'll use a kmem_cache_alloc(), so there won't be
any confusion.


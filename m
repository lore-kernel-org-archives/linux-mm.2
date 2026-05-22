Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59215CD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 03:14:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43D7E6B0093; Thu, 21 May 2026 23:14:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EF3F6B0095; Thu, 21 May 2026 23:14:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32B556B0096; Thu, 21 May 2026 23:14:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2083D6B0093
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:14:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AD03B40457
	for <linux-mm@kvack.org>; Fri, 22 May 2026 03:14:38 +0000 (UTC)
X-FDA: 84793588236.12.13FF706
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 878941A0004
	for <linux-mm@kvack.org>; Fri, 22 May 2026 03:14:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Rx0VF/cm";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf19.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779419676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UDJQJ2SWRuuTm3n45a6ixiISyrnNrJNCHrAU5RDL+Ws=;
	b=SEuw0oHyeCSsUx0gQwTWhyUkkW5BKrM0TCHo0PtcHQw01BLq4rLbepvSz9m89tU47swZEl
	b4kJrbH99YJK+PZZjbDV4zU0oOpZwFaKFbXfU/EYSi6Ug0T5z/r1XXJk1pgjnF6oTehxps
	3IAK71paFhItGp3+ACzv3KIjefeprFE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779419676; a=rsa-sha256;
	cv=none;
	b=b8EQv+oWoasmw2R/wNBQB78u2egf/0y2T+3YkOKqGoDx1mr+jHHBfOkmhtJuUD3gPMsa5g
	4sCw/sGGbzvbv3aQS0sgfg8PYOczylPTUcee0RlNwO4a3dXSDxouG0BoLa+Lo1VrAma1Bj
	OFnpLv/qCeIyVitC5mTEYqj4ECPxelI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Rx0VF/cm";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf19.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UDJQJ2SWRuuTm3n45a6ixiISyrnNrJNCHrAU5RDL+Ws=; b=Rx0VF/cmGYIABTDNVZaHGF2h8h
	f8rOwshu2WOT6h/1ynFiMa8JD9zcIguI1b4skLFnBRToF9eitmRt3+jJP5X59L4mQE4f0gMhd0C8V
	/IPZHZezqCnIDx2rLK/lBDpzvk2Er0buQDZlpMliX3HBHEbfiMgTZp+N5uQHTuSHr32wQb97z3sBu
	3Z1WJDWAgb8hK+IpqbngemQKa0rGkzy8rlNQhdXeEBri3ghqDiXd0DnjN/2/UNwnrGEoy6aBEeD15
	8Wfqc6jgvQhNxVWfC+xs7Mq+8wS7G3WmRfaTOG9RRyHJ3jkhZjUx9SatrLZe+xUoUDf5dxQKlN5bc
	WTOEgrRw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wQGLI-00000009Sdy-3FpN;
	Fri, 22 May 2026 03:14:32 +0000
Date: Fri, 22 May 2026 04:14:32 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Kameron Carr <kameroncarr@linux.microsoft.com>
Cc: akpm@linux-foundation.org, urezki@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, rppt@kernel.org,
	catalin.marinas@arm.com, mhklinux@outlook.com
Subject: Re: [RFC PATCH] mm/vmalloc: add vmalloc_decrypted() and
 vzalloc_decrypted()
Message-ID: <ag_KGA4ej9isaQfx@casper.infradead.org>
References: <20260521205834.1012925-1-kameroncarr@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521205834.1012925-1-kameroncarr@linux.microsoft.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 878941A0004
X-Stat-Signature: cqzk8xswnndmdgaiufn6pje5jsapes97
X-Rspam-User: 
X-HE-Tag: 1779419675-859350
X-HE-Meta: U2FsdGVkX19LD1vgZfscLgxA+tt7s9dnKGvtLvyDgQboNChqFDdPc8DvasPysri2Fe+v1Sd4T/Uw1ZuFAIjXwzqcJAYGQSISsdmMPf/hlTllCN2BaA0Uu4amUFp+iZlAHfa8oLLw0ghzm06OwUdnEDGnGE9ClH+wPF0kpLVs2acxZgSFgiVJtHmrM0HN2cHjIs889+ShwammuQfpGySMyrYGSweYceEhQRG0mCOIl+m/BjEcIaM/aQsbljhgWPI7Htjx4x7g+3nJ5BgM/zkZrYY59DCpEbNoEDFfRFvdc04QGGkqiXl4BiPWqTBgV0fsQq87lqRT1rzzp4quk8hPIdvYHPEYrj8fQBqq1bfQM95fk2iu4mGx1qfXs4tMmcq1lSIkiKFPn+o9f1GqA6b5/V8qL+LrFn8RHxnX328qF3Vc/k5iM/brNNlBDjs/nxN25D0Wtq6pNhkWW2QpmrCaMWQjp0JbTxS4vaMG0Dhn+FngbXQjX04wU2Uiv4tWX9Rf+/LMCKiEx0xicL+pVTDW9GOSkFfCMfBubKz3guZmgeQLqPUT/m+srxEQOuqAG/SfnE9BMKsz5wF5k5z1zUBTKyW42zAyH54ns84Bd/EaoYdM3jnH/hBk9Ca1RjJYQxdFkZUCrJlTTypIhXMyMA3uzeT3Acc5phOBRDVgDSFFQnByQnBIcy+1pd3PzpZrZk5TbFZkGwnjtLbQQcz3Ik/udZF23mtoxeo6aw3P052oFgtDeDWr21Yy/u/sHDgdT1Q97NUUKpb72ZHbBlVsnkO6++QKLG8AObJGUvUmCLOR+L1nmi/NOl64NQItuI2RchgDNQ1aVjPXKWNWDAgeLABcwwvbZZ01CToAp7mpFj3Xg74RAqu2hILiiNE4NjN89vmTog+fs6sHIV7wH/EbI7YTwEfFqjgDNFfcGWcrV3V8FRq38nLBDQ6IHC5JE0rOP73DmhAhz2I30dKImLhhyAc
 ird2rN3P
 5ylL8mWnUaoWvsQqLPQ78e0gcT4dBAmUflAjt8/HINsDCwM1F6fhna8839OWUX0eZMYQpCEWpZoVl3CJlKBnfgkyAzKpzC8Hu1hafOLQRgXRhIe1VudSfwWAL5sp5ZKLWVfvwInuiF6wkQG3PxxVkbUxGQCPEYO56W3W8t5cwFVr2Ufaf37gfxdaeAOGOfPhf6ihykURBr73XHd3LXkDM69aBhl5cEkhAQnsXbHNoGkVUidIcWjc/7wQetLSRwu6V3TW7mZERRusHayk7HX6MEgnb9x57J7fR94vy54P8clnkTYQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 01:58:34PM -0700, Kameron Carr wrote:
> +/*
> + * Transition a single contiguous block of @nr pages at index @idx in

There's no parameter called @nr_pages; you probably meant @nr.

> + * @area->pages to encrypted or decrypted state.  On failure, the block's
> + * page-pointer slots are cleared so the standard free path will not return
> + * the pages to the allocator (they are leaked).
> + */
> +static int __vm_pages_enc_dec(struct vm_struct *area, unsigned int idx,
> +			      unsigned int nr, bool encrypt)

This 'bool encrypt' parameter is an antipattern.  Just split this into
two functions.

> +{
> +	unsigned long addr =
> +		(unsigned long)kasan_reset_tag(page_address(area->pages[idx]));
> +	int err = encrypt ? set_memory_encrypted(addr, nr) :
> +			    set_memory_decrypted(addr, nr);
> +
> +	if (err)
> +		memset(&area->pages[idx], 0, nr * sizeof(*area->pages));
> +	return err;
> +}

Does it really make sense to pass in 'area' and 'idx' rather than
passing in &area->pages[idx]?



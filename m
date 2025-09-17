Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0531CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 21:44:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2561E8E0082; Wed, 17 Sep 2025 17:44:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22D2D8E006B; Wed, 17 Sep 2025 17:44:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16AE88E0082; Wed, 17 Sep 2025 17:44:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 07EB28E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:44:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A123B11AB86
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:44:22 +0000 (UTC)
X-FDA: 83900071164.22.CAE5A75
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D563E1C0009
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:44:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aPYcJuS1;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758145461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PT/myCM0L/pLqrjDHb6kd35wSNTpuzFAV5Ca7FxmafM=;
	b=lzkaUi2DIHFAGxOkHWpwZUSYFoQzczq/YJRYisnpzEzRr69i6oL5u1ex/HswoHlVnoSfIB
	XQ7Erv4f0M2j4UvkSq1agwv1AoEp6V9+yqicaNb9eEen24c2sXaAZoq9ne6vCqz9d4C6Lb
	DlWC/KxacGkoeaU5hsEgRbHcowetnYc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758145461; a=rsa-sha256;
	cv=none;
	b=zljtstgqKiFZVNuPHECn/zvERk+C3CGv/Oc9UzyYCNCht+1dv+yQWPw8jUAdeIx7mA1EE2
	6nNrubrewFG6g5FKmgvR6hcDv/Q4XGNziCc081EIRbgLcwWEi76W745XlGQaHCKfWmlpUL
	/BshPjdS2Ml7dc6O7G1yvoOxxF3mkKc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aPYcJuS1;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C6F6743E48;
	Wed, 17 Sep 2025 21:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D692BC4CEE7;
	Wed, 17 Sep 2025 21:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758145459;
	bh=Y/JCpR1xXuoBkwljLMibP0v4lm/i2uaaBybKIFHkiFI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aPYcJuS14avROKNJKvC5vVXubfl0lbQC93Dl8gbsR6nw1YWYh2GRbNGWKNRDA5FYD
	 c2qpMAHwc9MpBCw13voMdBlmJpmhcrCbzC8cSqgsPJWGJhoGQou0RXoQEsRY+D/fIT
	 ujpQjQg2UNq4OTHkNSX30wpJRmzuB4CJB7HxQyAU=
Date: Wed, 17 Sep 2025 14:44:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 david@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
 acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
 willy@infradead.org, raghavendra.kt@amd.com, boris.ostrovsky@oracle.com,
 konrad.wilk@oracle.com
Subject: Re: [PATCH v7 13/16] mm: memory: support clearing page ranges
Message-Id: <20250917144418.25cb9117d64b32cb0c7908d9@linux-foundation.org>
In-Reply-To: <20250917152418.4077386-14-ankur.a.arora@oracle.com>
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
	<20250917152418.4077386-14-ankur.a.arora@oracle.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mm5stsqi46ofszqiox8iwzc6kfs6e9b3
X-Rspam-User: 
X-Rspamd-Queue-Id: D563E1C0009
X-Rspamd-Server: rspam10
X-HE-Tag: 1758145460-257676
X-HE-Meta: U2FsdGVkX1+CRoKkFXpUz7OjuBReGYADLyvRQv8QhjB/2VzQ3RO3xgL9NaMG9tHl/X0JW4/aEm1XdWoSpI9RpdzD3i2SDT6yARD6hR4dqb3fXeLs9AAjSo5RdfI64DLEr/yjDdbO6pTqzuevQlFIBPEfCYqZaeY/NFa9lZPBZcw8TdSrIjXG8MUu4cys4w68OozPaudZ4UYTR0t9o58uIGBKrQzfXcMqM8/BZJ85ZHHa1jl9ksmxipYhKqLUFzSC9aUnlljRMWkkMuwM54tgmnTQEPYuCBL7QiPpv5XwhGeTA3u/YLNCuIuNBMxGMes7CKfqtEwqFolvTmBH4h3icDF8+O71BwQ25UXNsowAa13cSK2IfvxaNUa8xm7xqg90YGa65vz4bnHewgANef1id5Q9+WEifdSkWYIX2tsg3kXRX5crfIEvphOrcaqDOyN63nQ9Y15Xss9t1iAvhscCduGp6oyOcttpQnaldcHYtFDf0nln0ZmQx1zXLfIRuTGcOo/cn3AmIwiFPe4B5qVvleyuptxMWooFU4qIburEsnLkfqB3YWODPKfaWZg7o/37F0CDlIVIOlCLvHQORFJvvgn6Kj9+khLSYKcjxLaevP6/fjqnaIlQUA2VjrmGupqIWBn0/OvW1frILY6p5zgoQ4LfE9oCxfIEd5F+VndoQoucQU9DUyoWrnWdr2UvVD8zDbJ+5bewwGyb343UW6V5l+0UvPUYD3VRmNGMssrHnygT7EfvTYCNVXOUIKs4N8PivrfRybWYCnVrltl7IlA2tytGyR/FwF5ksFEYRlEpqz8PRT34WdDZXjD93Twz+gu9WlqgBWyX+caKse3D+zYycXWcpgNivnLfaYS/7LrJxMnuqv9ozqlVKIiteLq1hfAiPdC9iTTW8DlNLxjnJKx+Ek6/6aYyg+x94OHnMWI9ZgzRXPgKJJ+ZrvIl9bGi9qiCvszuNBQB4PHr6GwVXRP
 H90mhNzM
 OWl/2YEa0708nXaNcnAtjZ1WHB2I8iFHkwRwBLrMMI9yp4fbM7HycrSUzIcQkTF3A4OGXvpCi/1lZ0fpdk1JSBIV+wr7RAFcFLROLfgZtOW6yvERkg4cRrFuoGzvsLr0yuGQIdU2/9mDC09HvlPMEngxesIjA3IL3lbpcDIR9R7iSRYNl6/ycN/0WW4x2BGVx+faNmn2aMyLw/+JzhvrrV1WGZ7y3CZuzB1Va3mpdlxNbSFA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Sep 2025 08:24:15 -0700 Ankur Arora <ankur.a.arora@oracle.com> wrote:

> Change folio_zero_user() to clear contiguous page ranges instead of
> clearing using the current page-at-a-time approach. Exposing the largest
> feasible length can be useful in enabling processors to optimize based
> on extent.

This patch is something which MM developers might care to take a closer
look at.

> However, clearing in large chunks can have two problems:
> 
>  - cache locality when clearing small folios (< MAX_ORDER_NR_PAGES)
>    (larger folios don't have any expectation of cache locality).
> 
>  - preemption latency when clearing large folios.
> 
> Handle the first by splitting the clearing in three parts: the
> faulting page and its immediate locality, its left and right
> regions; with the local neighbourhood cleared last.

Has this optimization been shown to be beneficial?

If so, are you able to share some measurements?

If not, maybe it should be removed?

> ...
>
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7021,40 +7021,80 @@ static inline int process_huge_page(
>  	return 0;
>  }
>  
> -static void clear_gigantic_page(struct folio *folio, unsigned long addr_hint,
> -				unsigned int nr_pages)
> +/*
> + * Clear contiguous pages chunking them up when running under
> + * non-preemptible models.
> + */
> +static void clear_contig_highpages(struct page *page, unsigned long addr,
> +				   unsigned int npages)

Called "_highpages" because it wraps clear_user_highpages().  It really
should be called clear_contig_user_highpages() ;)  (Not serious)

>  {
> -	unsigned long addr = ALIGN_DOWN(addr_hint, folio_size(folio));
> -	int i;
> +	unsigned int i, count, unit;
>  
> -	might_sleep();
> -	for (i = 0; i < nr_pages; i++) {
> +	unit = preempt_model_preemptible() ? npages : PAGE_CONTIG_NR;

Almost nothing uses preempt_model_preemptible() and I'm not usefully
familiar with it.  Will this check avoid all softlockup/rcu/etc
detections in all situations (ie, configs)?

> +	for (i = 0; i < npages; ) {
> +		count = min(unit, npages - i);
> +		clear_user_highpages(nth_page(page, i),
> +				     addr + i * PAGE_SIZE, count);
> +		i += count;
>  		cond_resched();
> -		clear_user_highpage(folio_page(folio, i), addr + i * PAGE_SIZE);
>  	}
>  }



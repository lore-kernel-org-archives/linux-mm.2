Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6275C531D0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 07:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5D7E6B0092; Thu, 30 Jul 2026 03:28:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0CD46B0096; Thu, 30 Jul 2026 03:28:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4B226B0098; Thu, 30 Jul 2026 03:28:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 980546B0092
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:28:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2CE57408DF
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:28:21 +0000 (UTC)
X-FDA: 85044614802.02.427A3BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8547610000D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:28:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JfpZcsTI;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785396499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U+Tn6v+fwIrJojcp6KTc+RNYg06A/2SJBiLKpI3895M=;
	b=rcGjwXhr/1fleS5BEzXrf1K1c4JgMGkBiZ+rK5gUQV2P7ixJrb1MAvc9A369SzzwOpRIcu
	otFTKNua7J+DZeWeApJKEjI8AYHjg6JTyI2XUrxc0hEFzUOiAimxEOoS29/k4Lh2NbC9F5
	5BYggiruX6BhWqGAqKgKoxDbW18Pmz0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785396499;
	b=53fFYNhNqDRT2JnY+cj2pV48IE3g9+zYlvF/n03jGghGa+PwN4HEqzCXW0+Y+0mVWbII4U
	1QpzeqSWART4xur2nn+hWtcOdG4heI/O5BhPAlGFS62TSNIryUG1pPkNTBdp+RLxlzk90F
	QtTOyG+DtkQAqbNAxT6E1hFA2HsH298=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JfpZcsTI;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ABA4D408E1;
	Thu, 30 Jul 2026 07:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184871F000E9;
	Thu, 30 Jul 2026 07:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785396498;
	bh=U+Tn6v+fwIrJojcp6KTc+RNYg06A/2SJBiLKpI3895M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JfpZcsTIi4Hst6B2IIzM18A8fKqpm49BKKL9gLMgWdsPlDnjn7wbKb1muCUmGrGiv
	 mMyoSW9FQkCXNid8xKZQqGzFZORSD/nN+VeXAR1Rpm5ritRgWobY86FqWrvJgasIPi
	 XszO0IBd0BWXSk1RjnXzQMwp5esqTrWO1aEDeUO0KtPtQFcCQ+P5E7LtaTz2T+Vhb9
	 5WWSBDEx/F6nGQZhYXvDcUo1bj04TESx1O2/Xs2sKq7tTJmDJTjdzEQI0/qsGYMuqH
	 60Dl10CCNSD1uxJrJyXgpZNFLeFzJZfMnooq+37x5XJJgGXwrD5UH7UfbH9K6V1q0d
	 sVvpTRO0rQM4g==
Date: Thu, 30 Jul 2026 08:27:59 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, xueyuan.chen@vivo.com, 
	linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Bob Liu <lliubbo@gmail.com>, 
	linux-kernel@vger.kernel.org, Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: Re: [PATCH] mm/huge_memory: fix huge zero folio publication race
Message-ID: <amr1tqBj9ec57xwa@lucifer>
References: <4ee89c27873fb4d9e598f8a5cfe71d700ecf894e.1785300563.git.xueyuan.chen@vivo.com>
 <37c40d62-51e2-45b4-9837-a4b96d1640b3@kernel.org>
 <20260729180241.2b8bcb2379b975b22c48d251@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729180241.2b8bcb2379b975b22c48d251@linux-foundation.org>
X-Stat-Signature: byhbu9hhw1pqmj6z4e331nxqx8p7b3yt
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8547610000D
X-HE-Tag: 1785396499-410580
X-HE-Meta: U2FsdGVkX1+mEMNdzsykc27666hg35dmT72t1L0I52ikQRxWJT0kdJCsfn1dVZ3ifKpkfJRE7rfxiwZDIkkp3h4Ii+ALW2R/4Gi7cUREfM5GFqbfstJYPqMBY4eEJqC/C7JnjfqavzvNOGRlsOT+JzyASRrbNyGkNaej1/erxHEhnj++TbdYfcPw/DXVexZxZjRiKdmCUG4oDWeHwYnC6IQzQHlJcYNB/w0uEKZEX650em/bUOcH7WqxBcB688FFPdgVhd+Gs05Q6SVC0r47S+buEziUllVEDnsYb5RLEB49lYpjoGMvzab0i0y9vQHa7YO3OC+NgbPsDuvw6Q+6hcrlzCcAOMK8i7k54H1Y73N/mOGlFQ4E/Mg0Zbnvlz+Nf0k03Pu0OA5aaS5/lrgYCMo0HfTcWeWwVrt5iQJM1T4Uq2ZD+10IaHHswfv9cjUg4Z3Pi2z1qYIqjrGo89/FrqOwJF7veTlMVpwdJ8hyMm8mq3iOS9ON/Tc0mI/ZrHYS76KLAUL/ePuh3ADBCcCSgsLN8KQJsqnRV3EzZOjObuGcZM7j4rbAuH8bd932Ote3DkDiCbc4D8BF0T17oV9H/UE7peLtOsg9TXCLnI74Dlny5oe7eI/Hg8oQRxlpV1cXVUjM4C/N00YYp2UTqvPmLaeArjnYicBjzfORtbTKtBJ+yysuKH36acKFHwhNvpj2Pl86qA7E69ooTTBwrjBKBLOiUseewRImyViLbpVw8S1ZtGGfIrft7JPsVFxpaG9/Q1mdNKxvCPWvStge29LpKEIZ5lFcVBa2qfB2ZXlAFPeUZPDcApfr/oseFTemkUkEmTnLY6+byL5xIRqTE1EKK2CUMYFz80+734c086y+B5jrOqyuZN0t8cFWoT+Sd6PQ3w+adSEU8mA9iHp5M16yTe5OBDVUyahmNMWX8Z7DERv8zKeH3E5LmRL3QwExoQC/KgffQBaXTsSnMLs4Z0X
 v1cVH33v
 YIIN08AtZ0IJ7ZCUMEDnjcr3aDx8tv9AO0I8DqlHBMZxNEHR5diwvXgqXnBP/VWyfAUbvpPaFbOMzG1GoO72cAgI944vdshkS/xn2OpT76CCdz2dEPcmSDVLyAzaEMOSjMRELm0267UKfjvGtXvGBqCX24Om2wQMUDA5QjJyazs3OaSM4EARo2xwh2S/GjfQibq1rnwqduzpItS1BogJcfhmaFRCiH/3li+tFjpheFqGZjJ2XxoJ9+2zenjflO4i6hpjfLyfEo2e7zS0+RhJAXQeMRCzlCcDyDZAfII7TxRQd57VVKZMWfiIu77JAAreDKwZCD03wCukM88fm1Cf6WShlu498P4TXa6C2wA2dSWBBapzIkrtYRgiVJAbWNKMqB9TxYF7WeEuEfoQw8BFmk4v84g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 06:02:41PM -0700, Andrew Morton wrote:
> On Wed, 29 Jul 2026 08:44:12 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
>
> > > --- a/mm/huge_memory.c
> > > +++ b/mm/huge_memory.c
> > > @@ -245,8 +245,11 @@ static bool get_huge_zero_folio(void)
> > >  	}
> > >  	WRITE_ONCE(huge_zero_pfn, folio_pfn(zero_folio));
> > >
> > > -	/* We take additional reference here. It will be put back by shrinker */
> > > -	atomic_set(&huge_zero_refcount, 2);
> > > +	/*
> > > +	 * Publish the folio and PFN before making them available to lockless
> > > +	 * users. Pairs with a successful atomic_inc_not_zero() above.
> > > +	 */
> > > +	atomic_set_release(&huge_zero_refcount, 2);
> > >  	preempt_enable();
> > >  	count_vm_event(THP_ZERO_PAGE_ALLOC);
> > >  	return true;
> >
> > https://lore.kernel.org/r/20260728-fix-refcounted-huge-zero-v1-0-3f261f5447b4@kernel.org
>
> Does that actually fix the same thing?

???

This patch was sent after mine and tries to change code that doesn't exist?

If you look at [0] you will see:

+	/* Paired with atomic_inc_not_zero(). +1 for shrinker pin. */
+	atomic_set_release(&huge_zero_refcount, 2);

Which is... doing what this does anyway?

(I don't actually think this patch is correct anyway since the cmpxchg() is
fully-ordered with a try loop and the issue with PFN vs folio publication still
exists.)

BUT it doesn't matter anyway.

The race is fixed and I went into great detail in [0] and [1] explaining why and
how. If somebody can poke holes in that then go ahead, otherwise I'm not sure
why David's response didn't suffice here.

>
> Is so, Xueyuan's Fixes: is 97ae17497e99 ("thp: implement refcounting
> for huge zero page").  Which to believe?
>

Again ???

3b77e8c8cde5 is where the PFN actually started to matter, before that the huge
zero page was compared directly.

The patch proposed here says the PFN is the issue so it already had an incorrect
fixes tag.

Cheers, Lorenzo

[0]:https://lore.kernel.org/all/20260728-fix-refcounted-huge-zero-v1-2-3f261f5447b4@kernel.org/
[1]:https://lore.kernel.org/all/ameC4IWCOVBGlXZu@lucifer/


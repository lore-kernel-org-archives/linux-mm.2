Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD2C2E776F8
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 18:07:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3F736B0088; Wed, 24 Dec 2025 13:07:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CED7C6B0089; Wed, 24 Dec 2025 13:07:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C230A6B008A; Wed, 24 Dec 2025 13:07:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B3C626B0088
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:07:06 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 363A516050C
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 18:07:06 +0000 (UTC)
X-FDA: 84255146052.30.B62DB30
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id EA5F01C000B
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 18:07:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hme0MOhh;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766599624; a=rsa-sha256;
	cv=none;
	b=B5dxxBNC6Z9spev3scq7YZh6WZBnb69TH5t204LZINUxBnz6sJMAly+1i9jDHG1azxK70W
	Bh+86mlHzI8dPjPquUGSsN5cN5qz/M7ogapJBoBIODc8VDd6nn5vlGpYwUCZpIq7AjxR3C
	EOZfQ5RIDnfeQD/U0ROGhOrKzmd0xzY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hme0MOhh;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766599624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BQKGjyZDvWvZ8jDpsdKnYLCVOQ+GPoRi6k3p/8BF64o=;
	b=jzYtcTtmluQWMH9gdG3psbrGHk8BSnY3VzBMLWgtApAGSNY1D7nytXgyxJFCFMTOkkkAEL
	83nsyDa1KALdtF9BTYGrxicPHELGBKbki+TqThFVX+73Wo5TiWZos677GcywU/iPOkVKNP
	4sUYqvy78NRA1KTS4HUETWfetmg54/4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BQKGjyZDvWvZ8jDpsdKnYLCVOQ+GPoRi6k3p/8BF64o=; b=hme0MOhhI8LkoVY2AKAI83bY+f
	bYGIZe2Psau5T4X/Mq5qWfMaSaNnf7PBGt9n6fieHQPZeonQVA7bO4Ch3IxwnduJly1SOxD8PVmYz
	mz8Y656AkSwn62wrheMHcaPvmfdgEO79CE/j4eFJzXcsuHe8kkHFPb001ggiwjnhcYwFy4eVWxcto
	DTKJjAMriEkEtEwqRnhY9KLYqGXooxFaSeb7kE1Eyp9M7F5StcbvJwNXhWpNLI83TLVnalli83fAD
	LcCxfhXHM26IkNGnUvr/V/oJbya7RQKcNzgHtn/wACQ9NP5JMeQRUdDI/gbM8w1SmARm3VMn9rpbi
	G8+i2ZpA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vYTG4-0000000EYJO-32YH;
	Wed, 24 Dec 2025 18:06:48 +0000
Date: Wed, 24 Dec 2025 18:06:48 +0000
From: Matthew Wilcox <willy@infradead.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Lance Yang <ioworker0@gmail.com>, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, akpm@linux-foundation.org,
	axelrasmussen@google.com, chandna.sahil@gmail.com,
	chengming.zhou@linux.dev, david@kernel.org, david@redhat.com,
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com,
	nphamcs@gmail.com, rppt@kernel.org, shakeel.butt@linux.dev,
	surenb@google.com, vbabka@suse.cz, weixugc@google.com,
	yosry.ahmed@linux.dev, yuanchu@google.com,
	zhengqi.arch@bytedance.com, Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v4 1/3] mm: pagewalk: simplify hugepage boundary
Message-ID: <aUwruMji4MCNaOPi@casper.infradead.org>
References: <62a2d7ba-e7c3-4153-b227-c08802ca9e1c@linux.alibaba.com>
 <20251224092332.53214-1-ioworker0@gmail.com>
 <20251224140829.2ec7bbae@pumpkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251224140829.2ec7bbae@pumpkin>
X-Rspamd-Queue-Id: EA5F01C000B
X-Rspamd-Server: rspam03
X-Stat-Signature: 698rreyjs16rk5i8skor9rr8n8cyb4wt
X-Rspam-User: 
X-HE-Tag: 1766599623-147395
X-HE-Meta: U2FsdGVkX1/DLT6fF62bsCxTaDoEk84wxLNCD3CjO5Qwi+/zIircKT55dNNGop7VQZb98wgCV0YlEfosxouUGmEVoFG/3jQxtkMbtqmmFtyL/8ES9PTh9ezCS9wnOPJARU3heoe1VhX359RKa2ucaWM5dGP3AMYSnFIXQGjArz7EHL9uE1H4MmbTnoK4Pmk8OJEtehqd90HFYx+hB2r+EfKgp1YL7QVuu2t1v2nNUfzirFmnZotWL0uNQRBto9c1OfrK7rvTR7b/OgpLleZywTzl/pviZmdNmPAZTrmwxmkcwPztjzCbI4ZulUbGzhiKRMFikemI1Zqgrg3G4dSps3cTtZ0ABIN+1uVvCJ9LXgQCQcZcRsrjccBKru0oudmJih3qRX/PN6iolE7aLYygBx44xVKooT7YHKfjykGNeJS/oYPYeU8lcM3M2Sz2jCEV90raR/6knH/h8I0eb4bB3AX0WZeZGf9xfTxGO5u7EgMvZmB/Zp6+cdwsGwT6bx3B6pkIXv0YJs7mWBS7KHJTzHik7lOjtoJoGIImJUYHf9Oh08ymqsheUcTOkdtUZiewemiGWZfKz6Pau6voTO5h19EaEdf+X/1slHe6ib1ifAdXg8hHcYJiJ/qPc4W75LhBkt1lHp+OpIkjFnOV8L9cEmFEAUN1+j5cFUToK5JGEfoapGDgHJQMkRbBbMhDnLsFwKyAW7/Z+FHK7NQADQ3J7E0GIK4aelu4+eIRVz6TPXICpBBYCoRTcov3NbUNkMnGoR0AMrd1+NWbXPce9RuOyrDMRNmmMGZR8Gzszw90Pr7nOuR4g9xoXBKVgIiebq+6NHOD3DayipulovLhqz+oYU/O56EdrsJH5V2S2K4F5Ec71JEnmVswZ1OfqDCn6KrRKGpERPHVwOz3lmBL9yZfvQJTRe3ciwJaZqVpWG0s+5LtDaBtojfg0Z+Z1FVMiHD1nRxj9yxI1tObizB6qpf
 irbWsH5Q
 q+sJWAdnBbm/H9HtsbcQ9ELFf+cF6FJF8WcZ0GHI3XJJgM9SP5x79tUM3C3AAvUxb3Eow1+vyXKWyVXIae4C3iGA7BNQkROnXdFKePpOro3qNPM3bR+/hhi04XjmGMcM/OeC/NNfWlomFiAUuv2n7nz4mcMfMG4YyNSS15jRvhVt9gX1tiVq4V2klUMnTYUZp6rWFH4i82Y5CG+AH2JWCcCZwwrVZC1iYDPBAZwUKIAfDdY6EJc34FLskeZOax/CDdqLR/++vcuCMqF+k3bmyWhkNwUUqAzJ+4MkQfKlra34YR2htVmVlW8nsVAN+Cwpp0DBgMxG2JJfwhUalV59gNePHimoJRm0T0boHrgQuGoZTQV/ykSHwLhXJervIG/O2Vk5fURDVRGf6EI01mcKw06T+90iV2HhuPM/yfTB/0pLX92M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 24, 2025 at 02:08:29PM +0000, David Laight wrote:
> > > > +++ b/mm/pagewalk.c
> > > > @@ -312,8 +312,7 @@ static int walk_pgd_range(unsigned long addr, unsigned long end,
> > > >   static unsigned long hugetlb_entry_end(struct hstate *h, unsigned long addr,
> > > >   				       unsigned long end)
> > > >   {
> > > > -	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);
> > > > -	return boundary < end ? boundary : end;
> > > > +	return min(ALIGN(addr, huge_page_size(h)), end);
> > > >   }  
> > > 
> > > Please drop this patch from the mm-new branch, as it causes 
> > > 'run_vmtests.sh' to hang. Specifically, it leads to the system hanging 
> > > when executing hugepage-vmemmap test, because the program falls into an 
> > > infinite loop in walk_hugetlb_range() and cannot break out.  
> > 
> > Good catch! The problem is that ALIGN() returns addr itself when already
> > aligned, causing the infinite loop ...
> 
> Using ALIGN(addr + 1, huge_page_size(h)) would work.
> Although it could be (addr + 1) & ~huge_page_mask(h) which is probably
> the easiest to understand.
> Some of the 'helper' macros don't really make the code easier to read.
> (And that includes a lot of uses of min().)

Or we could go back to my original suggestion.

https://lore.kernel.org/linux-mm/aRyOWrARRlUCeEz6@casper.infradead.org/

which was in v2:

https://lore.kernel.org/linux-mm/f802959f58865371ba1b10081bced98e3784c5e4.1763796152.git.chandna.sahil@gmail.com/


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E67F1D609A1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 15:19:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4973D6B0005; Tue, 16 Dec 2025 10:19:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 445736B0089; Tue, 16 Dec 2025 10:19:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36E366B008A; Tue, 16 Dec 2025 10:19:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 228B76B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:19:37 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C1A45136541
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:19:36 +0000 (UTC)
X-FDA: 84225693552.26.2EBD3F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 27F47180022
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:19:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nBLlXIJz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765898375; a=rsa-sha256;
	cv=none;
	b=n5R23ify9loukOmKzWUuH98B2uQyYJlJI9dr6Yg4x1tc2I3U5617WjkfCtiK0dkxlJE08v
	a6kXkVozyOq5t11diuzw4T4QeI8R0jPccGXwvv4R4qrR+XN91LHV6PH9lhv4Eeon6M24Bv
	xkJGKVNR5MJz//0/KlF2/oOqKzP3he8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nBLlXIJz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765898375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JHJ7no1hZB1d020eOjoHel8dcWh1hLCizfZ5kLv5nWA=;
	b=gacHtXxkCz6dadLaqQttat2HLAwBuZD6EWXAUsMdXToPXa6qCnmU4ML8cptxJSvK1Y6vXW
	qzaiAve/B9Opp2KrUHCSOw04Y+kW53oLuPP+RsTyqrPo3JXPTTstz6U3v/dx/+t7ed6XPc
	GBk8LGr1eWGudAkB8SoqAOEB3G//zas=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8301C60187;
	Tue, 16 Dec 2025 15:19:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4CFC4CEF1;
	Tue, 16 Dec 2025 15:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765898374;
	bh=1C3O1RJhSl5a7OnhBSz/2GvP934zpCWD3sNtHJ+8dxY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nBLlXIJzdfgq1Dnn+DyMW+MquYwEJofXKI4D2doa79u6kD0MRYJb6l1wAT6BKDb4s
	 XkpwiiFiqbKfGMVfvT8HoBcPne3ZtUfGcQMHgNMjZOdEox5BZGDjUu6NLw/q73HkDN
	 KIcn8FPQaV0jrEW+3EZd6+NHCZ/C7oJrgbMiniwrgh/D+B2YyTkzf9rkuWnnrw5zNV
	 oExQ+29v47kcWhJnY1/nU0WUAgIKX8vBNRqiM1O/2Zuj8ibSW0Yxgw1vrdCldKRTfW
	 8MoQF0Q/RYYNs23aF991zxpDZQRIciTAlIu5nMZBXmqE3+uw9puCKIyTokUzycVfJk
	 GwSD2QuKfRARA==
Date: Tue, 16 Dec 2025 17:19:26 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	nh-open-source@amazon.com
Subject: Re: [PATCH] kho: add support for deferred struct page init
Message-ID: <aUF4fsWwD9BswkFh@kernel.org>
References: <20251216084913.86342-1-epetron@amazon.de>
 <aUFJH9xzJXYOt_X8@kernel.org>
 <CA+CK2bDGvgcGJijAtSSa2k_FWjnZXm2jRiFd6Z9-XjEQ-Y68DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bDGvgcGJijAtSSa2k_FWjnZXm2jRiFd6Z9-XjEQ-Y68DQ@mail.gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 27F47180022
X-Stat-Signature: hkbbxz3i1ogme9586bomf3ug3w18pf7m
X-Rspam-User: 
X-HE-Tag: 1765898375-593842
X-HE-Meta: U2FsdGVkX1+1ffNzdnPUsmpKpetus6TMQtbBxHyoX+OR9KhgQseFV+fjMPDpSMlzgb0i55SKF1W3mv14omnOynOZZK5yczB2YuSLuBdKOGu/sIwxZp6+nHMHywDkgcXq8izIMQ+aMSgyeYaBNiugMeCW94AE1ppKTkC4666fSAlV3fU1gsS0KxdtWtP+1PkDUzLjDnTS4KmMJbuDSvQhSnF5Uunhx9XQGg6G3y90kRbtu15QdnWNDAeROa7oETbedU2fo+KIJxM7if4QUQsNswpamJNpvJ+94yUBTmwpSXidxkZzuC+0TDG3oNzlWgGg8J7PvqX669mNHS2sJqBouAirQiGHumG8LgwgBNCI4BR3aGW1iPN06fTOcw2E6KX8oWwB9l/aRYzX261ILJg57PwUGkDxbGWeZEBkY0V2/PoboW5+vczfzSBoXUryTM/G0ieHUZz45ZeEVoKnBSBs27Yjx5gGmS+SQ1esAH+Uk7XKsIWjSuqnWfIgraaTEmirgdQsj0hUaFZ57gp3FeM0KqYZuKApAT334C72/LWdU1lSa6GH2APH9b5whnRafsCiZnX2TawRnv/ooKcf2/+AHhFruuetDoQFt8K3RBpppl0vHcdyb2us81en20xqSLdbYd0/ngdUXPjP1l7FuA3UriE5w6i25JgoVmx3HLbG+1QPfUQKLMpvTCbqJj3LZtQUTKCg95D4dKuS3DUh7oGPHIaQlLClkbb7RYe5t2kCJtYs4ch8r7U3Q0VKEXhDnU9hdr6/UYPgMg3HdyDthqbKgQEXugDp3pzjpXtb4NcN/kEHiLhPgYieIoFmwAEE+MXTcIlmZTsCJU/iPUsNI/jeAESS4MaAIXfpY2b0LJNVtftA/via2xjN79VeK6Ql/xaYQpOoMEToGeC0PY2y8Lf7NCHfreMZRDH8geq/msOtS/5CjJdFMBcQPlXHxfV5bM00Bv6xvQFU/ij/na0xm1a
 zjpIv1/2
 IVbrXLh9ugXm5fj7qbr+op++MY0Y22QAquGycje8JfBOZP4mllNcJa5bu6rYFmYwjx7Wvv1iDg75V11Cm7n9llEwJwFv7HRE2Isb+g4Wj9mAXZUA/4N+Z0LnAcWiTL6Egl8Z/tJgJ4zS/IeKIM+r1VZKX9c1yo39PcFvor3rlE+kCPReBqBjnS+G1mT5DtjTI5IOHAoOQXyUQ0OqOvL+glGE/iX25VmdrEpM2hvemfg5sGWCcXOjp5cwC+FwQKzlmZCg7PrZ0T2tqE9S16rH7AiwsjA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 10:05:27AM -0500, Pasha Tatashin wrote:
> > > +static struct page *__init kho_get_preserved_page(phys_addr_t phys,
> > > +                                               unsigned int order)
> > > +{
> > > +     unsigned long pfn = PHYS_PFN(phys);
> > > +     int nid = early_pfn_to_nid(pfn);
> > > +
> > > +     for (int i = 0; i < (1 << order); i++)
> > > +             init_deferred_page(pfn + i, nid);
> >
> > This will skip pages below node->first_deferred_pfn, we need to use
> > __init_page_from_nid() here.
> 
> Mike, but those struct pages should be initialized early anyway. If
> they are not yet initialized we have a problem, as they are going to
> be re-initialized later.

Can say I understand your point. Which pages should be initialized earlt?
And which pages will be reinitialized? 

> > > +
> > > +     return pfn_to_page(pfn);
> > > +}
> > > +
> > >  static void __init deserialize_bitmap(unsigned int order,
> > >                                     struct khoser_mem_bitmap_ptr *elm)
> > >  {
> > > @@ -449,7 +466,7 @@ static void __init deserialize_bitmap(unsigned int order,
> > >               int sz = 1 << (order + PAGE_SHIFT);
> > >               phys_addr_t phys =
> > >                       elm->phys_start + (bit << (order + PAGE_SHIFT));
> > > -             struct page *page = phys_to_page(phys);
> > > +             struct page *page = kho_get_preserved_page(phys, order);
> >
> > I think it's better to initialize deferred struct pages later in
> > kho_restore_page. deserialize_bitmap() runs before SMP and it already does
> 
> The KHO memory should still be accessible early in boot, right?

The memory is accessible. And we anyway should not use struct page for
preserved memory before kho_restore_{folio,pages}.
 
> > heavy lifting of memblock_reserve()s. Delaying struct page initialization
> > until restore makes it at least run in parallel with other initialization
> > tasks.
> >
> > I started to work on this just before plumbers and I have something
> > untested here:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=kho/deferred-page/v0.1
> >
> > >               union kho_page_info info;
> > >
> > >               memblock_reserve(phys, sz);
> > > --

-- 
Sincerely yours,
Mike.


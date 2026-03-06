Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA148FCC076
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 20:58:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32C2D6B0005; Fri,  6 Mar 2026 15:58:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 303846B0089; Fri,  6 Mar 2026 15:58:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 202E36B008A; Fri,  6 Mar 2026 15:58:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0ABD16B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:58:35 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B7292160546
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 20:58:34 +0000 (UTC)
X-FDA: 84516851748.15.958CD5B
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id F1DC4C0004
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 20:58:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=LbdIf5os;
	spf=pass (imf10.hostedemail.com: domain of carges@cloudflare.com designates 209.85.167.180 as permitted sender) smtp.mailfrom=carges@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772830713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FNZo5NfTBFF4m06mr7OPW9uWWiG3NXNEdjw76uLifcY=;
	b=H3mC5MJDW9Savrcq2Yr/WGnpOuQTIVOsL2CvxPEu/FM8XT3wufBMuK5kX6iO7PQvgNtbxE
	L+Pk0NZ/Q5nO3A5Ae8who/GcqWdwO6NZpH+a1+VkOOw0qzH143DWDY/EVQ40sqqAT1JPPD
	R8dXl4J59xq3KHTekWB7w/yLyRNYPm4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=LbdIf5os;
	spf=pass (imf10.hostedemail.com: domain of carges@cloudflare.com designates 209.85.167.180 as permitted sender) smtp.mailfrom=carges@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772830713; a=rsa-sha256;
	cv=none;
	b=A0ka4dV9QkSI2kX/1e8j6m1jHiHg1EJs57ew2Bc8FUb5h79irgJUft7JN6WFAKawmQTid6
	vJOJ0V9D1TM8zUao1D+hKQFiRs3eomMQr1qFmdBQFXZsZ8xhuEqmqUakRjM3VaUuJtm2L0
	Lo33O3mSdkDZkkao3Y4pnTQ+7TtUuEI=
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-463a94f8475so6947069b6e.0
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 12:58:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1772830712; x=1773435512; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FNZo5NfTBFF4m06mr7OPW9uWWiG3NXNEdjw76uLifcY=;
        b=LbdIf5osg7JDSeflIkAL8HRI+2pUTuWF9HfxryhQ6ZjFxP1DrWEr1x3qaNw8aaKLzy
         xPpvMtYTy3kf8i8DXGe2vpph/hhe5h8vAoWa4VdSH0DkyCeRk1cW6Q80AsO3eUHVYzbs
         9UD2mRVj9fr1GUWUq2lpdyhZHiCXjnbsCa7fV6bqO//SsVG+DnK1GIRsrsESxhkTdK9q
         LY9lMvFwiy4dYGro8igY4vSlW60kUNKKgs+admN8WV/t6K84fgetdLiYpGoXuXxVAhzr
         OgKEw3c4DH4KtNT2wa6cPm4WBAhZE0y4MTKM7hTgaOVPcYErMCsQbeFhmATxCzD9z+D/
         tRcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772830712; x=1773435512;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FNZo5NfTBFF4m06mr7OPW9uWWiG3NXNEdjw76uLifcY=;
        b=Hbzx/b0X2KCCFEh/1kWqje/UkTaur/vGIkrNH4ZQSxASZupV+qfQergCPsF4gNtHBs
         8B0VLeBKuKyv/67Yr6LSHZveGm77qVW7YCyQLrjv0AsXzreyPRchPNxHanvoAwwkT6cl
         4gCc1cPKlL0m8Ky8FELXw4zdTJvZ0KuZfOSqIfw/jPTEpQTxytUgbC5ZQhazK+Sts18Q
         SZ3+O4A1LuveSx3R8HZHKKAvazEapppIpetlWFqpOn6C3SNnuJx8K9pZ5tdfiDKzv3Pk
         Cp0soqcQSIcZGbQNWbL+aXEMCoxQz6f+sXixRgxg3IF08cnHhTrXs1EuYZ8C8x341SrD
         Jw3A==
X-Forwarded-Encrypted: i=1; AJvYcCX1dP1evPJuz5q2Nttiit60g63GQEO5Dr+/9CkmW+sCv4gc2AdpYjo+Q31BGRJA4Mmb0F88hzVMww==@kvack.org
X-Gm-Message-State: AOJu0Yyo+XcCxL/0RKmCtWKA9n1SvuO1EaB+X/4bizUK3lPXGmP2Hm4J
	7FMb8wV84eVkZLglr9hlLrJLZ5Ep1ifpM2YVal7RrBcIBjE2OQu92BXOtcHTLAyeWCc=
X-Gm-Gg: ATEYQzwpsI42g8pjmC/xkVaW0eNkugYLEYQFTAKIPhE4542WQ2+itOiM+wRNB3clh4J
	mzzbwyShQ/JMmezunQZaknrkStnJsHqUIlXndaek4gV+qQbMDp6x2v0hyTT7BTX5cDx4IgM66+U
	11yvinASbKTfmOnLcdBMnBHyHtH1tkgcPaB+LlcXxXR+JTCTfNGOZGWI0gajNLcnwua/5UqYvqj
	vVMsZZ2P+DPQQ14Z02BL32DG/TrA+n602MG+iIoO14QOD8SvGzm4DGYv7uwEFDdCgSUXgwp0qoo
	IntYTjZrbYTzpQTCIIgemHac83WVGrLTMkkvKgAGebeXLKaeczgzrJhz8e75pgnobzjEgqQBi9d
	qyfnhwUpSXHlUKf+JMNCB6b+KjRh8WAO3faA5izD6hIfUrcRjn+a5eHF262wZoGwMLZxDOq8yO3
	ZyhJX7IQ==
X-Received: by 2002:a05:6808:1b29:b0:463:a42c:503a with SMTP id 5614622812f47-466dd0f8eeemr1809910b6e.14.1772830711654;
        Fri, 06 Mar 2026 12:58:31 -0800 (PST)
Received: from 20HS2G4 ([2a09:bac1:76c0:540::3ce:23])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-466dfa96903sm1318842b6e.13.2026.03.06.12.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 12:58:30 -0800 (PST)
Date: Fri, 6 Mar 2026 14:58:27 -0600
From: Chris Arges <carges@cloudflare.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org,
	william.kucharski@oracle.com, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@cloudflare.com
Subject: Re: [PATCH RFC 1/1] mm/filemap: handle large folio split race in
 page cache lookups
Message-ID: <aas_88rB4HX2C93R@20HS2G4>
References: <20260305183438.1062312-1-carges@cloudflare.com>
 <20260305183438.1062312-2-carges@cloudflare.com>
 <aanYdvdJVG6f5WL2@casper.infradead.org>
 <aarVMrFptdXhHsX1@thinkstation>
 <aasAo8qRCV9XSuax@casper.infradead.org>
 <aas06mfCrJuzZd0-@20HS2G4>
 <aas3E9P0BP03O8ma@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aas3E9P0BP03O8ma@thinkstation>
X-Rspamd-Queue-Id: F1DC4C0004
X-Stat-Signature: p6n59wgifjzycxsize8uk3pwsxz79cod
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772830712-881105
X-HE-Meta: U2FsdGVkX1+uz+ALFYK+cMZF0hVpQdTPychrwcBUD74GAaanvv0xGKlk4mjWNOVyx9c6fRjIKbIAeBbpqmH8SwdqHaaqpKdyTfIVDbttHtYSqnnsMagJCOvvmyglU6Pg87UNDRHd80tGnFsBb1rvmWA4stVtrhfFsGoUrEl8OzYMzwYEPVHOEuhImXeHIRs82ZZIH5IF8VzlDWB2Qzg93pXSwv1qOl4v6cn+ID5iu/5oim0eZZVVyb7SOO1/u9WPfURzjEgbfynE2E8lFe/ObSZG1i7AXIKP5j4UzyFDQe7zmfu/xG6wlnPsckbcrmdfxaeRjTUoLjMK5ZZc4MSHnv7kzJQizFd2EdFYIGEWzUBukgTXuYSF7q85IQVpqtBXOg+2nwyH9FR56u3e+SvNF5Z8LKjRL4JY1aLr8IWGpN+zKv0gY3kxfOB06Cr1jFiTndJKBq2l+zxdV1yn/JjrO3815rVB2v23Zz/y3B4G+yilaVZs6juGnOoyr2W5YBqtTDrO3A9yd8HpyUCppOGXbYLQh8C1QscBVz6t3/HXAaNfv4xEwzZbCyuEmFgu8SPYLmh6XbiYp9lczOaAe+Ms7vN8pamjSUn6E2CJd4X8+ATNSSynPBHt3wAkDByqxXivGxNSZhYTBBMmwwDO9MBjpyPX8RrlJRlGkxfwhiezd/iddXedxr4O79RFyYU9lJeASYsTsIjY99A826Cf+C8Bh02ePmoXTURSxn7JEhlIESVwCyZC2Wd8ulvclfEuiyH/cWT1ewlR8TBCuahkBTeT2q9+OXeBVE9uS9fp9yhhgFXcDhwoPSFLXr9eQaa/lnczYc0xzobIM2L6YRmYPKyR1EEHQL7IwDTpxvXMlrISpmo/+7g3hpA/HE7ExD1hp4yCITx5PTNmqMfmshQg+Dln73GN65HYMwvsC7bsIsLs2TOwA9kIFmNq41CcUZyDbSfm5gJ9UxIew0mYV/MzYjc
 PFGWA6Lu
 7znTQwYEA8ZZvD9radcpajTKJJHYVrAoqYcGk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-06 20:21:59, Kiryl Shutsemau wrote:
> On Fri, Mar 06, 2026 at 02:11:22PM -0600, Chris Arges wrote:
> > On 2026-03-06 16:28:19, Matthew Wilcox wrote:
> > > On Fri, Mar 06, 2026 at 02:13:26PM +0000, Kiryl Shutsemau wrote:
> > > > On Thu, Mar 05, 2026 at 07:24:38PM +0000, Matthew Wilcox wrote:
> > > > > folio_split() needs to be sure that it's the only one holding a reference
> > > > > to the folio.  To that end, it calculates the expected refcount of the
> > > > > folio, and freezes it (sets the refcount to 0 if the refcount is the
> > > > > expected value).  Once filemap_get_entry() has incremented the refcount,
> > > > > freezing will fail.
> > > > > 
> > > > > But of course, we can race.  filemap_get_entry() can load a folio first,
> > > > > the entire folio_split can happen, then it calls folio_try_get() and
> > > > > succeeds, but it no longer covers the index we were looking for.  That's
> > > > > what the xas_reload() is trying to prevent -- if the index is for a
> > > > > folio which has changed, then the xas_reload() should come back with a
> > > > > different folio and we goto repeat.
> > > > > 
> > > > > So how did we get through this with a reference to the wrong folio?
> > > > 
> > > > What would xas_reload() return if we raced with split and index pointed
> > > > to a tail page before the split?
> > > > 
> > > > Wouldn't it return the folio that was a head and check will pass?
> > > 
> > > It's not supposed to return the head in this case.  But, check the code:
> > > 
> > >         if (!node)
> > >                 return xa_head(xas->xa);
> > >         if (IS_ENABLED(CONFIG_XARRAY_MULTI)) {
> > >                 offset = (xas->xa_index >> node->shift) & XA_CHUNK_MASK;
> > >                 entry = xa_entry(xas->xa, node, offset);
> > >                 if (!xa_is_sibling(entry))
> > >                         return entry;
> > >                 offset = xa_to_sibling(entry);
> > >         }
> > >         return xa_entry(xas->xa, node, offset);
> > > 
> > > (obviously CONFIG_XARRAY_MULTI is enabled)
> > >
> > Yes we have this CONFIG enabled.
> > 
> > Also FWIW, happy to run some additional experiments or more debugging. We _can_
> > reproduce this, as a machine hits this about every day on a sample of ~128
> > machines. We also do get crashdumps so we can poke around there as needed.
> > 
> > I was going to deploy this patch onto a subset of machines, but reading through
> > this thread I'm a bit concerned if a retry doesn't actually fix the problem,
> > then we will just loop on this condition and hang.
> 
> I would be useful to know if the condition is persistent or if retry
> "fixes" the problem.

Fair enough. I suppose it's either crashing or locking up. Will deploy early
next week and see what happens.
--chris


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAB34E6BF11
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 14:00:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E00726B0005; Fri, 30 Jan 2026 09:00:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7CA36B0089; Fri, 30 Jan 2026 09:00:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C88D56B008A; Fri, 30 Jan 2026 09:00:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BA5C66B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 09:00:03 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4CBF1D4940
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 14:00:03 +0000 (UTC)
X-FDA: 84388789086.11.ECAC9BD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id A61421A0002
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 14:00:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UV732Ang;
	spf=none (imf19.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769781601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HcJmdxSvqWEzU//m1LGFL/kB93exgThHvyaA0D7uV74=;
	b=HlsLBQiY8SNocvK4fJJNVt52LZfwnlSpDdvMAOE9g410AFyPixBHyyFDQXW2RMIIdIl7zy
	4E9kPDuj4fwZ929ERL98uKxsTUA469WUwmsujeK3jd3JAetduekhoHGgrCC4rtWkn868fr
	7YNVkhD3XAnQKNpxTOlPUAiv+8wMhB8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UV732Ang;
	spf=none (imf19.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769781601; a=rsa-sha256;
	cv=none;
	b=d1s0C95KA014dWFRTKtgbXeAWbct/Xt91Av3licnLzwKFHRlblTO1UbEmQMavVjT1kMLGJ
	t0X9dZs9jxTZUpBNIKGr9i8TumgMAy1NVNJAwnow2HjWYxpssD/NhzG6XJHpdFjCoZ/Gfq
	MzLs1M1KcuOARaAJfiayD5WfKnAStGk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HcJmdxSvqWEzU//m1LGFL/kB93exgThHvyaA0D7uV74=; b=UV732AngBxl4nOFV5ith9MbWcj
	EmxzPUpAJWnAg7dRymg8SEErx1xVd5yUJJSRcbpw7QDIEWhc6GsArwVTYMrqTG6jN3s5uHLBAPlUs
	WsHxGelPGsHkBdoTlGmnNrwdesxtoUrvJn9jBDqDnzzgRrbSNgF+1GGojB9hQFo4GHXrW3FfmHRT9
	vUOZL0AGbYEbRK2Jt8iqWp9LUqszPJDj6fByv7gFPhReRPqYW+hP7+kxz7lAni/TCnXCLCU4BAMgY
	tEuIXsTMiPlEPRAM43j/7FsXs8Ox7Z1xpmFouQZ8Uuff1KTBXMK4PVXZyrEHy1N1d/zcpcauR/EiY
	FT2iqUdw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vlp2J-0000000CI4f-1Vq1;
	Fri, 30 Jan 2026 13:59:47 +0000
Date: Fri, 30 Jan 2026 13:59:47 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
	Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, chrisl@kernel.org,
	kasong@tencent.com, Hugh Dickins <hughd@google.com>
Subject: Re: [RFC PATCH] mm/page_alloc: fix use-after-free in swap due to
 stale page data after split_page()
Message-ID: <aXy5U7XJSoSG5HpE@casper.infradead.org>
References: <CABXGCsNqk6pOkocJ0ctcHssCvke2kqhzoR2BGf_Hh1hWPZATuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABXGCsNqk6pOkocJ0ctcHssCvke2kqhzoR2BGf_Hh1hWPZATuA@mail.gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A61421A0002
X-Stat-Signature: 41afs4wf7s6tsf5rdwkyromkoznqpcf6
X-Rspam-User: 
X-HE-Tag: 1769781600-643808
X-HE-Meta: U2FsdGVkX18ebUk8C/B/+H7YPH3kyA6NzCziDceyvM8/3d3VGGdi8rsji04POmSUI1fzVZs2SZIwd4efO5UR84cFw86VY80DsciFXo92Wpbj+5MBl41PT02Xi/N4cTGdV7gxpixW6VTJyCjVIkvpJAEq+jjsWmUx5indrDH4JWTeTtMlFL658KDbuKlAPLBfuhSG61pQ4+t/K8B0lGA3OUUmF8mN/PePwz1/fFF9KakEtlx7IYpf3VPj3mRP+ZeDPeKDLhyeP/EbOGRpmRB04ADQFI965FhhlXKw1b7GkLYY+QuNcO47/iLWUz5V/B8e6IJyuElMbi2pjV6qJbqCL9Btkg58JZ8DougsTnTQG0tmuzsS2dz3flMlq9guQ+lGewIY4CTFN/Ouc7BtEihvPCIuflSaW72HOLwRnVSB24wJF/jn9bnEpkU04DQZpkMV3BVRnfzWIl119KQy9bzy9jJr1OHRojKxkFMq6nXHK1ReJKBB2kbieczAih0V/4Ad0NmIoQFIma4EbNK99k2cbNCUBgBSqDi4TzrKLJHFSi4db/ASZSzy0nBckgoTYePePStDDA3Wzn5NvwXAPA2JlNQ6qSsVmEPCo/ra6Dy9Em886OZ9bNZUZGTf7VjvlUtq4CGwvdXnnPSPm6O6DvNQHGazWeRZ9ivoBPC6tNHGinxhFkKnivdn8lsoO/wxsU+ntSuc7ScVKMawsaahoc+VYBKyv3331foSDW8POJnB1TQjRALKUvt1FQgRSGoofwwJKEMLJNDCLHXLzfOsQ4YqjoPIkO1k2dYdhxTpNMEIsRMHr9zp5iANEP/9Ffp6w9ufuDQgn/2PyxMs/TpoqtVuBP0pZAL/uqa9Nn8Pj0ylmPu2Di6pzPpaeR4heNZD69V73GawZJHUpB+PFerLULMg31woGGNEcpk9Q1+iodIM8rDXSteC6n5ebQDsJE1wMMkkOejF5TNJ4qHb4YUv4jn
 sIEbvPCu
 fCiAB1rJrRrZGsh+xEGRBVuFzxTLgPBzJmRhZAIhINgj6e8mK0VYs2VI7DzYYsEnW9sRZdnynUzJZRFv5P+kzde7wSydbo0nzo/um7cwjV69bEW1B9opcM6TYBteGEtYXVHoi0aECLzxCCUFMJFCMsG0+NS5W0SdKIqf3b7gGAhts58nRACGpNrtkG9K06TkrjFpssEPsIE3OsCZIhFMMr3u9Os5JCfgaUUdLr/XQIyWaBiFHTZ6EtGUP8bWvLQ+irqNd5G0RBzmfZjVhUZRVBlWQCH1dnhLyoY5qiWaZMImyhC+SPwUJzOILGL/gPH8CrId1mm1i8vQD+QofLYhtOdcLd3FfvTi39H8JUFoqDHqhwIOBVeh3XMzY4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 06:49:00PM +0500, Mikhail Gavrilov wrote:
> +       /*
> +        * Split pages may contain stale data from previous use. Initialize
> +        * page->private and page->lru which may have LIST_POISON values.
> +        */
> +       INIT_LIST_HEAD(&page->lru);
> +       for (i = 1; i < (1 << order); i++) {
> +               set_page_private(page + i, 0);
> +               INIT_LIST_HEAD(&page[i].lru);
> +       }
> +
>         for (i = 1; i < (1 << order); i++)
>                 set_page_refcounted(page + i);
>         split_page_owner(page, order, 0);

Why add a second loop instead of using the existing one?


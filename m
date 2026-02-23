Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19262EC1118
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 18:18:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CEA96B0005; Mon, 23 Feb 2026 13:18:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 486076B0089; Mon, 23 Feb 2026 13:18:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A60B6B008A; Mon, 23 Feb 2026 13:18:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25B016B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:18:22 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B2E2C8AB0A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:18:21 +0000 (UTC)
X-FDA: 84476531202.27.7CF015B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9EBF140007
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:18:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DwysRZ8w;
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771870699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FfglRdAZ7//oiLVr9rHZZA3KADO9fxzVK1RtdGfizyk=;
	b=wUt5ugO8bhZFdRbv37jmb/hlSTIGPchNwkAmXhOTaEKn7ZIx4Me3hcp9llFzXQI+XhMusT
	DUWBz29kdyr3OQCBCKQVu1MVsG65nBX2kMc3G+tX6y+VcR5zD39AjLsqdVwwp+nRWlOTOI
	xOawpug1HGpLhZIlgPeuWZeaLsdOG90=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DwysRZ8w;
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771870699; a=rsa-sha256;
	cv=none;
	b=H0mrDZqw7VgRh+VX5PLNhZlGW3GQA81crNC7Ww+ZJPfZYu6x8h4khZFJSjqsm1X00cmgnd
	Ck92J7X8RY9B+Rw80ghonP/rzIRm+KvlT7r2myPsb7stNG4C0dhFYvUeqiygrjfFHTe+kC
	+B4SPqcD2gdAOxOyB2rw3yZVBV66qCw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FfglRdAZ7//oiLVr9rHZZA3KADO9fxzVK1RtdGfizyk=; b=DwysRZ8w8bsWlmYNGYULfAJmG7
	hSJNuNbMf7YB6Bw+2+sdN+gpEHiWW8es4C0T6zJwktdLc3RhPZw2vHww2zYIaIWd9OMMo2f0GMQGB
	+o+JmrdW5o641PR1oftCRk1CdSsMCxhp4d9yPIn62FPbQm05ucvWkQHqdVdKmus/qgvGWHPyoTMq0
	Bi0bMdMVoMOK4+Y5UeEhXVzRwRMx69dUFCB7knGSbhp+g85lK+Ftmjm+AdVAocCgB4qJLd5e7BYXG
	DwhcEFl1UkLOZyTvFO6oylY9vWhv/isIrE2AqJyzG9EjoCNjXR2fZEj1huiJ1sS22n3Y0H4myV9zV
	XW3KWFzQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vuaVP-0000000Et8q-2Mg0;
	Mon, 23 Feb 2026 18:18:03 +0000
Date: Mon, 23 Feb 2026 18:18:03 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	kernel-team@meta.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
Subject: Re: [PATCHv6 08/17] mm: Make page_zonenum() use head page
Message-ID: <aZyZ2-7Xr-zUnInC@casper.infradead.org>
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-9-kas@kernel.org>
 <aZJTLwV2SaaKu1k_@casper.infradead.org>
 <ec4a9a1e-8c08-4879-a787-3b9e0bc38160@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec4a9a1e-8c08-4879-a787-3b9e0bc38160@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 9EBF140007
X-Rspamd-Server: rspam02
X-Stat-Signature: e1pnyqeg71d54wnzhd94e9pbcwie99dz
X-HE-Tag: 1771870699-954388
X-HE-Meta: U2FsdGVkX18CvNdfRXUFFX5wOinMjToSYbF+rbnPpNrqQn8k3O3cVXDXSrYhL/AlTO4sr21qsyI70+H9+HPNMD6N819HGRWi0uxUe1fwhNizcsnA+VEieTn0HBtQ8E0UNyw9tGLKKdfSsupPRf8xYBjQIJNfIdSPGfSy+irDn/NTkN6I9QkplpFttpppZPIyUz03ycjAy+dT0pXk7tQuD8H0Xuzk5KTxvu+C5Lh9eRCGcjiiTekt2xPQSpXog3E3OOASdPFBZeVdNiPxck/U4SGHcEIoMm0UJ2tB14HZOqji9AjHGT0oh/fazsX0oeFMUovThurHold7drKaHDquHPMZIV8CJKTVcqHYUbJmgE2SF9/CnbMKZycM77KPtZI8fGRkWvlY1Ri3wjYG9ewj9qyoQh9aoRAWsBookX0rYtpCsQHzMMoxQsyIIPGGXJIuXH3ZldCrXYMRxplfnPXzelr73CWwQEI5T1oO3MY/ShLjliLyzb3yYxn+TO75wf2RaQbebyKMws8mgHPrDi8XHsoEupfZpSI/pB8bCFiZ0sYRLFmhRFuWYyevIfGtQDAzuhJQT+ukuwATZBv0XLU93jhIS0voVNhwRACR63H5qd+GiBL9aybCQGP1sd+1pHEEmfc9cjMCMGhQGkvJazCqi7l38wPzBMUZEvG2z9LefC9gC7rAHXE5cbJ1+f61NwX2HogYc2e1tSXu3kEdQZksRBl0bqZh7nSXt9KnfpVsxCs1TTYm20FnbwtXCyno/WsP83fSWj+l8LfdB4rtl/iQmwXpZjw0iFeKcngToTyyop2iJzcRaEeJx62MgG0wUp7Je8JC9aeP0Awv+EeV3kk4CqN1H4ygjd3Zmwk6BhVOvLcE52M1ovkGXHNHnXQm4qsMw2e1r4dCKfRnKH+HBl9fNDX/p0U3K7zKk2YEa0OojcsPgWO3daLYsBmWiRW+CZNkbO0vN6+4fS1lEOZG4d0
 GcLe1dnP
 UnbgoAF22v07HBgU/iQEzvwcl+fvJk0jH8V6Vy/gjUiYkH7hEjClwTxLKFE9fWktIVN897VDf4BcNe5PtTxW9NSaQm0jGgvKLvqXAMXjvn/5e8l590Ch0A1TrXhKqTE7xQtq/0SbTSeOZK8Xr8sDS3WsZ65HPuOc8C3JCaKnkBxmzNcIGtZ1GDbt0SCc6Ztb3/EN3ZARPGCR2yzwozlUYmiagPYVfx3XA+fjAyPVjD3HgsHCSqj1K6JnLmoNmd+f5d8in3Im4QSnobBFYTu8Vm+YJ3RsuapwW8YJLkpe1wgSErJM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 10:06:57AM +0100, David Hildenbrand (Arm) wrote:
> On 2/16/26 00:13, Matthew Wilcox wrote:
> > On Mon, Feb 02, 2026 at 03:56:24PM +0000, Kiryl Shutsemau wrote:
> > > With the upcoming changes to HVO, a single page of tail struct pages
> > > will be shared across all huge pages of the same order on a node. Since
> > > huge pages on the same node may belong to different zones, the zone
> > > information stored in shared tail page flags would be incorrect.
> > > 
> > > Always fetch zone information from the head page, which has unique and
> > > correct zone flags for each compound page.
> > 
> > You're right that different pages in the same folio can have different
> > zone number.  But does it matter ... or to put it another way, why is
> > returning the zone number of the head page the correct way to resolve
> > this?
> 
> How can a folio cross zones?

I thought 1GB pages in hugetlb could cross zones?  Maybe that used to be
true and isn't any more, or maybe it was never true and I was just
confused.



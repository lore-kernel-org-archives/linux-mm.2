Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C3E5C88E7E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 09:16:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ED316B009B; Mon, 26 Jan 2026 04:16:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69B256B009D; Mon, 26 Jan 2026 04:16:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A6FC6B009E; Mon, 26 Jan 2026 04:16:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 45BCD6B009B
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 04:16:56 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DDD22160640
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:16:55 +0000 (UTC)
X-FDA: 84373560390.08.E02A3B3
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf09.hostedemail.com (Postfix) with ESMTP id B0AF1140009
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:16:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769419014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z3yuS2RWD2DS7ylhisA1mm6557h1K5XVtnYxf5BpIXc=;
	b=4Sb41ceu492y6lVT4xWSeaaweQVPRlA/HwyZiuuTh+1W6UOHTE90rmlw1G3fxFpUvgyUuU
	L9W/Fzs8VN6cEj77RjeDR9wj39u0MPauVpLLaG6Pc7YUXP4CwUInNjdWvjHFHL33egDhHl
	j/+jkaH4nw7GHpWGGkMYyaWzJRPJseU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769419014; a=rsa-sha256;
	cv=none;
	b=iRcefpk2dnAg+Edzz+ZjH5gqrKvHKcpDMSdzqzXImUKziLJGGUSR+7SdkL4y86t3Xgu8Ro
	cwUHrQL7VpdlogoTJkBLJoLmwqfw1D2ppe79MIDwuOIiIuHkF2MGjH8vqrQsnhMkWzJJO5
	MRonrY2QYew4RO5laqMns59v5Aff7G8=
X-AuditID: a67dfc5b-c2dff70000001609-18-697730ff2573
Date: Mon, 26 Jan 2026 18:16:42 +0900
From: Byungchul Park <byungchul@sk.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
	David Hildenbrand <david@kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
	kernel_team@skhynix.com
Subject: Re: [akpm-mm:mm-unstable /301] net/core/page_pool.c:713:71: sparse:
 sparse: incorrect type in argument 1 (different base types)
Message-ID: <20260126091642.GA62597@system.software.com>
References: <202601161606.8RuyUh2k-lkp@intel.com>
 <20260116151500.b56d0cc2525072123ad2d86d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116151500.b56d0cc2525072123ad2d86d@linux-foundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsXC9ZZnoe5/g/JMg8YTqhZz1q9hs5izahuj
	xfOtvxgt7q35z2rxqvkRm8WhlVeYLC4dfsTiwO6xc9Zddo/Fe14yeWxa1cnmsenTJHaPEzN+
	s3i82DyT0eP9vqtsAexRXDYpqTmZZalF+nYJXBmn7neyFlwUrvje28vewLhMoIuRk0NCwERi
	7q8Z7DD2vEMfmUBsFgFViSlLu8HibALqEjdu/GQGsUUEdCVWPd8FZHNxMAusYJLYv/svG4gj
	DDRO4sX+e0AOBwevgIXE7amhIA1CAkUSf95PYgGxeQUEJU7OfAJmMwtoSdz495IJpJxZQFpi
	+T8OEJNTwFviydJwkApRAWWJA9uOM4FMlxA4wCZx6PpcJog7JSUOrrjBMoFRYBaSqbOQTJ2F
	MHUBI/MqRqHMvLLcxMwcE72MyrzMCr3k/NxNjMCAX1b7J3oH46cLwYcYBTgYlXh4f5iVZQqx
	JpYVV+YeYpTgYFYS4eVfVpopxJuSWFmVWpQfX1Sak1p8iFGag0VJnNfoW3mKkEB6Yklqdmpq
	QWoRTJaJg1OqgdFiVs7t+1s+f/d/tsXi1yylrU2bJF+def/sSuFtqx2Tbe5rnY39z2wZwlUy
	q7eYpyFCWc7+x/N1osL3GKTZHh2fr7Dij/CP4JdvLMuznq588/+nf1biMr4vr3ct0la/cH6f
	zbf2lTeX7Q3R6vPhbXncIrF42qElE4R1EiceXO9ad2pOxQ2zw6t5lFiKMxINtZiLihMBMNsw
	nXQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsXC5WfdrPvfoDzT4PgTcYs569ewWcxZtY3R
	4vnWX4wWh+eeZLW4t+Y/q8Wr5kdsFodWXmGyuHT4EYsDh8fOWXfZPRbvecnksWlVJ5vHpk+T
	2D1OzPjN4vFi80xGj/f7rrJ5LH7xgSmAI4rLJiU1J7MstUjfLoEr49T9TtaCi8IV33t72RsY
	lwl0MXJySAiYSMw79JEJxGYRUJWYsrSbHcRmE1CXuHHjJzOILSKgK7Hq+S4gm4uDWWAFk8T+
	3X/ZQBxhoBESL/bfA3I4OHgFLCRuTw0FaRASKJL4834SC4jNKyAocXLmEzCbWUBL4sa/l0wg
	5cwC0hLL/3GAmJwC3hJPloaDVIgKKEsc2HacaQIj7ywkzbOQNM9CaF7AyLyKUSQzryw3MTPH
	VK84O6MyL7NCLzk/dxMjMHyX1f6ZuIPxy2X3Q4wCHIxKPLwf9MsyhVgTy4orcw8xSnAwK4nw
	8i8rzRTiTUmsrEotyo8vKs1JLT7EKM3BoiTO6xWemiAkkJ5YkpqdmlqQWgSTZeLglGpg7Kj8
	lt1i+df/0wKF9/WOD/dKRu96aP1dNnHGup2XvJ9OW5Jeknrt+caDFxaHme8yzDoXUfKAp3rB
	seN9cjW2yw5dEOBdO6fvdJP0006xQnarzJB5yckKd2yeLzno6W/FvmLdqyoTjxNOmiZrIheG
	Fa7eW/+8TDIymnXSc+uvcsKGIveUn9zxV2Ipzkg01GIuKk4EAH1IdQxbAgAA
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Queue-Id: B0AF1140009
X-Rspamd-Server: rspam07
X-Stat-Signature: 3ebf5hg9idzo5kpu8759oty44s48u6mg
X-HE-Tag: 1769419011-163278
X-HE-Meta: U2FsdGVkX1/WRWfD7xB5SpdU4lTc9h0CRS6GrDx9xf40mKvCfxO5Xsb2xpFpRQBrafGAIkHZ+EpOomB/Hf/MKDfaa6WA4JcnKrLtiFIJHMSA8ZS5y1wfGeJvqFotJxiTvhpBtKNo8xKl9HK44H6Qr30S5BHOBn9CEg8e6W6QRIfsO/Yip4qpMrKQRWyBQubXHXZGVbL3J3IQYZr9JFvTtW+48ITdNcoGZFkwGoEjydBPLmGb6dFm5wlimtzuVz5xFhIiokh7PKbGnu3rSdSog4SCSbGrurOZ66lTRmC/CCrR8ObN0p5OQjVmWTyrY9YHU12JjWgk37NJ0SDAqEfoHa2R+LAaYKQNI/Gtq86WlGF61QCM+AYV5QJeCN/iRH1Rj1diskp/Y1sPS3HyFKmeltJF/UIhxfhSvPHQL5eATLc/JP0yz7rIjoXbOV3POB52ID7RHce5YybFGR3m/sO85AH7dsrJx9lja0yLXY1XHGhhEsqQSPHlWdJRh75UewdILbyEAy7sdmYRIoN4rUN+bOF1zZ485Xn9b2N80s6ScJwZO6EgbZKjFsOb7jQjtzZj++CvHPFBiY3ib3ECSn2zYBaweFwDhXoRzoYwcoPnNl7OiV8Cw9s0bkBRGbqHFDuBRXdoa8am/L3x2h/qqeeOUeGJ7OYg7TXWcsrTw8dASTAL/ZnsHUD8MF7kINiIydbiMobRcmIljJxU4TMgEdbASbL9LFKsKxbeKdUcmwHQbVBsK2vpcCpBYihsQAD3WKjqf3Kd42KFq+A/zAjWT9GKujjqJRIbcBT4P2ncxbZKR90dMs5xNmv4lT+Lkqod6rRW/KcsEhjhpW1PlWUWrE9ZXegOincqI5ALtmnsclmvDNsBPU17ftGg7KmnABjUMuxGINcrSI7QjitiSpdd9JRf5XKCLP7D551qiwxUUVL4CKRSW7jUSduB4LJhsDEUi1wZ3pxBA1vWaTohBoJEKZF
 xGwsI1tx
 J1bMuiG9yOubntWnjuEhSRWg1R/nMPKMMZKeLU9Ef6duSHpsyhXkU7XR8dlu0ZzWP10xz0wBxQxE7UJC8AxVHrHAgwRcHSJ7DwftNBgN4Biw4uoRnCFvCel2yvOZ+J57HTSABbSmpG4rrNhmGJbAEOrdu3YY1e2tb+ojXl7aoWYDCt92z1+40e2wEpdMr1osTjH7X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:15:00PM -0800, Andrew Morton wrote:
> On Fri, 16 Jan 2026 16:41:32 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> > head:   fe2c34b6ea5a0e1175c30d59bc1c28caafb02c62
> > commit: 7699fe82442a62ea29a3745b29dbb8ef8c42d8db [/301] mm: introduce a new page type for page pool in page type
> > config: x86_64-randconfig-122-20260115 (https://download.01.org/0day-ci/archive/20260116/202601161606.8RuyUh2k-lkp@intel.com/config)
> > compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260116/202601161606.8RuyUh2k-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202601161606.8RuyUh2k-lkp@intel.com/
> >
> > sparse warnings: (new ones prefixed by >>)
> > >> net/core/page_pool.c:713:71: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected restricted netmem_ref [usertype] netmem @@     got unsigned long @@
> >    net/core/page_pool.c:713:71: sparse:     expected restricted netmem_ref [usertype] netmem
> >    net/core/page_pool.c:713:71: sparse:     got unsigned long
> >    net/core/page_pool.c:734:73: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected restricted netmem_ref [usertype] netmem @@     got unsigned long @@
> >    net/core/page_pool.c:734:73: sparse:     expected restricted netmem_ref [usertype] netmem
> >    net/core/page_pool.c:734:73: sparse:     got unsigned long
> 
> Oh, OK.
> 
> Byungchul, please remind me why I'm carrying a page-pool patch?  I
> applied it because email headers and because Suggested-by:David, but
> these things are usually carried in the networking tree.

Sorry for late reply.  This patch changes both mm and network, but I
aimed at mm tree since I thought it's more about mm - Jakub also think
so.  See the following link:

  https://lore.kernel.org/all/20250813075212.051b5178@kernel.org/

> And I never applied [patch 2/2]
> (https://lkml.kernel.org/r/20251215071001.78263-3-byungchul@sk.com)
> because "kernel test robot" reported a build error.
> 
> In fact, I'll drop the patch - please let's have a redo.

Okay.  I will retry.  Thanks.

	Byungchul


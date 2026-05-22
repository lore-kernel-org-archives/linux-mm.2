Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94C12CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 07:32:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 998F06B0093; Fri, 22 May 2026 03:32:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 948886B0095; Fri, 22 May 2026 03:32:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85EF56B0096; Fri, 22 May 2026 03:32:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 70D106B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 03:32:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F334DA08B7
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:32:39 +0000 (UTC)
X-FDA: 84794238438.08.57391CA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3C71680007
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:32:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QpHEifDJ;
	spf=pass (imf30.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779435158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pATE+Ad7Nds5gmErVpuSATD83acq6VMYYKTG/ZdFY5Q=;
	b=tNLm6mzcJAlaaeRoVVqrBWRsWUI4LUsBgfBaVb03m0QpNJQtH1vKc6vHU4MDw34E+s/yrX
	ejHaQ4UEooskBIff9srsH+nHQ5HEyoTbceYl80vzmY2LToQOUBIHNvwCinrrSL87yW1tgK
	4AO6Q2HSxyEfFxJeXHxLQgJ6dsC0G1M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QpHEifDJ;
	spf=pass (imf30.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779435158; a=rsa-sha256;
	cv=none;
	b=GXRSP3SrTQoY6kxhhS0Wmquf9xZfhXfdi64uzwY8OojAuEFGDm2qh97WVBFjcKQrdXJkGQ
	3zgIbmlCPZwLx1fNm4sBTdeSGTdhmDWB6AHCgFvlejjERl22GoVgMaKW3KEYEctrhihN2a
	am54wO93RxmKB+DEFHk5U/ynktsmn3k=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9A3442574;
	Fri, 22 May 2026 00:32:31 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F2463F7B4;
	Fri, 22 May 2026 00:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779435156; bh=3d3lTmEURd/s07njkMR0R2cb+D6d2JS94gvx6IsOI/k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QpHEifDJbgVhH/FbE5O0tpIXxsvMB47wdM593PGMnmQanoMSTBbiEPX2maCRxsBUs
	 fZkGyr5T099jvPZAfGd9nmhPSc9f7fvb1hz6r7hBJ5IGSaax4dG/m+T2eAH3FPViAU
	 p/2UhypX/wOyuGz0tnzS/YUocstlUGo0fIbzc9Es=
Date: Fri, 22 May 2026 08:32:32 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alistair Popple <apopple@nvidia.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, will@kernel.org, david@kernel.org
Subject: Re: [PATCH] arm64: mm: call pagetable dtor when freeing hot-removed
 page tables
Message-ID: <ahAGkM_I30ruK3tN@arm.com>
References: <20260521032730.2104017-1-apopple@nvidia.com>
 <20260521153130.d7d5cd060f7522f894252333@linux-foundation.org>
 <ahACfQ6kCfONqz5h@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahACfQ6kCfONqz5h@arm.com>
X-Stat-Signature: xtxz47oae6d6iudu8yopi1gk7wq3pmjm
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3C71680007
X-HE-Tag: 1779435157-720159
X-HE-Meta: U2FsdGVkX18YKj0OKbME/KCV6o6IvsMqTdc7l01ICmra2fAbNLLGgXe7kSNWOj8Ior7NKaLpUpAqMZs1FPwuwOaTEVXMC7SG6LW8uvuXZp1j+8mA5hmnw7jzq+etx/fyqT5MYmmu5xV+bhKqv0O6U9wEole0Y6Yylpm6G9Sezh6G4joSBsH5OUC5q2dTQ/h3mwVxID3SiInJrkVjUV2vkVscBDpgp7lvpupGNpbKZYUNTcNF/5zQbu1ghTBgxTO6qkw1tfbjdGfapdLeUyV0Vy//ytTMomR4gr90dShgszmsFpuqXI7wm0ABvWRRcERhN1FYxjHfXqO4FHNneWHQ01vSxwNaXRnigdAFGXC4sMK0UCcDEziS+c+2fAlNVB3NktueXUfHS/ZfwJa8Vsc14AoX4neNmVE3uSkNgmGlUsJjWNfYhMwYIrZ1CqYTCTy8HBJUDqPn6C7Z1XiNQmgPHB1EVAQBdBPqntzr8J6iAW+Pncbptc9WEH5yChwlNFwQOqDaJeVViP9aKv8g+sDkV7r7vqRGRaf9zTNyqVEui1D1SxTvZGLZX3rHPCmo9hAqDurcYQrpw0cufiEBRUiMuKc2BZSgXNOdY8sF7mi5J6dOrIJq+oJcTM8wKkS40TL3882FH3gl7+O/RbffUwdl5//ypL+JjcdcyeXERNfG2LXC3F6kf6DEeCDMBTVHvfamVWHmeovug9k2QcBS1CDlQRT7eH5BCUGe2f0ut8u/9hVUUYvqSoM6IKPEro5FkK5fGuN+BIy4P8F38qltPloTad2VSjZhDLziR44vhC5Jd69JWY6BIx1Zh2yUxycdzxujmBMs8uXK3I4BkgaSnq25SR4pY9VojyW9BlQgbO5GUw5KSZJFR5j/NHbMqHfchaheYxtiAAeRoOcw7ymoTfNDgTM7Okh8IW8Xy939knjGaLSa+XyGiBo8XJc2MAfvw0YkDm5tKeidWwkHd7ao+1P
 IZvv3END
 v6zJ4lr54qoUSOTJcWsJy1qQVy7vuAPBI2f+i0X+CUtkFIG1FK0nsRO2f35l0TbcbBaNBGtycAKnoRL1fYVlJCvMyJCXIBEEVS0RksJvw5TiKRmn+K5QKqak4EL9QVBBVmhNOm8v1LQLjVa7vgxVZ7kGMLSvXAWZL5ICGAXMDld1uWFkbWKHxB4LZ7Im/rgF5CGajPu1CkitAaJ7ySY8juwT2Ss1w/lVhMKfu0df8NhDU3yhe+sQ5g69T24Yi9v0Dl7nYZxQ/h8jjtcvONif83mUcog/cSX0Kly8BSmGCBdOyg5/Msx7QINpYzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 08:15:09AM +0100, Catalin Marinas wrote:
> On Thu, May 21, 2026 at 03:31:30PM -0700, Andrew Morton wrote:
> > On Thu, 21 May 2026 13:27:30 +1000 Alistair Popple <apopple@nvidia.com> wrote:
> > > diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> > > index 8e1d80a7033e..0c24fe650e95 100644
> > > --- a/arch/arm64/mm/mmu.c
> > > +++ b/arch/arm64/mm/mmu.c
> > > @@ -1422,6 +1422,7 @@ static void free_hotplug_page_range(struct page *page, size_t size,
> > >  
> > >  static void free_hotplug_pgtable_page(struct page *page)
> > >  {
> > > +	pagetable_dtor(page_ptdesc(page));
> > >  	free_hotplug_page_range(page, PAGE_SIZE, NULL);
> > >  }
> > 
> > I'd of course prefer that arm maintainers handle this.  But
> > 5e8eb9aeeda3 came via myself so convention kinda-dictates that I get to
> > fix it.
> 
> That's fine but Sashiko has some points:
> 
> https://sashiko.dev/#/patchset/20260521032730.2104017-1-apopple@nvidia.com

The other Sashiko find looks like a false positive. vmemmap_*_populate()
do not allocate the page table from altmap, only the page pointed at by
the vmemmap pte.

-- 
Catalin


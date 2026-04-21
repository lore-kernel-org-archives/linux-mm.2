Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD9E7F327A9
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 06:08:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05C5D6B0088; Tue, 21 Apr 2026 02:08:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00CE46B0089; Tue, 21 Apr 2026 02:08:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E65046B008A; Tue, 21 Apr 2026 02:08:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D87786B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:08:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8ECF0140C93
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:08:39 +0000 (UTC)
X-FDA: 84681533958.07.7FC2914
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id BA670C0009
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:08:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mxpOYq0q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776751717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1aRMmUIunY2D6/F9pOtV5sNBSuLNQ6TBWuB1f9eyf3A=;
	b=sTo6pXfvPVhkP1Aa4kMqiPwCWZLRglvqyE9PPBaPG+RTORMZc9qthhC3n9MVQb3kELeahz
	0SBBxfmC/fsL7Ma4jwdhrwFvtvmbB2HZKBXfVrcTn3mNjXd7xCI4vdxlYFrghDLUt0Bz2W
	OY58IXLI+V3Uv9deu+FaAozoas4/uuU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mxpOYq0q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776751717; a=rsa-sha256;
	cv=none;
	b=dylh/U8WGgxqFzSGiZk3aIGvxFtmaQ2oDbBO33y+gfj8guVyLiW2wao8W07vAApZCjHGLz
	G6yoMBqXlv0s9UY4mKhMMsiHuhaaP2zs/XCydYFIlpy8R1mt+/Dqs4Z/FJtyhvsyqL9NBI
	q28iy6JAqkq5sTxv0kPEllVaDgUUK8E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8CC9D41B09;
	Tue, 21 Apr 2026 06:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402A3C2BCB0;
	Tue, 21 Apr 2026 06:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776751716;
	bh=W/hzbip07LNU/tDJ2aO3ZCidj5JMSONEyovcM7R7tZM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mxpOYq0qMk/X+UYLwyY+5jPb27dG3yNzGaRGqgOSBB6EGi0gmlrWIwn7HZ/lBe3lu
	 2sehwQcnzYl2XIlQQqfBpoirREgd4El6lkSxTo4Rt3YDaeRdze7PVcExaIUVo+FuJD
	 hPQg2l62q4NOQ8v6SlErDOF1hWWn1jfhQVuHqn77E21IsRN+yfx8/HViLmi2yIyU+D
	 Osqj/aZeE32cgTH9AkM1ZRYuhvwJb1+sA+kfNSYEJ2+eAH7VelseY7ukM6u/ZZyJXZ
	 aKJl3xSyRlc67o/CeFYGxzS8PV01KjlFDcv41EJyCMu5+d5IILkH9aKyRtxw5SvxTc
	 W/oC5ziCgPafg==
Date: Tue, 21 Apr 2026 09:08:27 +0300
From: Mike Rapoport <rppt@kernel.org>
To: =?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v8 1/2] kho: fix deferred initialization of scratch areas
Message-ID: <aecUW-Xgm5MPMyVr@kernel.org>
References: <20260416110654.247398-1-mclapinski@google.com>
 <20260416110654.247398-2-mclapinski@google.com>
 <aeD2Fzr6yr4pu9-X@kernel.org>
 <CAAi7L5d-ujEa7R21Lmd37X9451KBmK8ZhagSKbJde15aQLi2MQ@mail.gmail.com>
 <aeEKksfLxQ0A7Jun@kernel.org>
 <CAAi7L5cp3B0DFEQex5EqFdLDkqVWwRw228-pgp0PnhfgLP=e6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAi7L5cp3B0DFEQex5EqFdLDkqVWwRw228-pgp0PnhfgLP=e6Q@mail.gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BA670C0009
X-Stat-Signature: rpejmb4hhdndqow7oigsf6qauze1jkot
X-Rspam-User: 
X-HE-Tag: 1776751717-666438
X-HE-Meta: U2FsdGVkX1+9suZIjdT8qdF6yvxjMeMCDRRKciC3SYBnnr2SFtTZnzFQhiGrnWaGWu6BW9HStVipJeGshVZ1fYeNFXhMkqeOWcFJKolZwlqXFi7dEyuFtpkHRpOkFwpCOVCGFDVjblE9Y91w5VuG8mMaw27UO8Rb1BtNZfIaJfylTrgHBWpBgr2rTX0NmKMxCS3w/0XUtnw+0AKraTCe0PJ/H/4zVYpMosAT34cZPxF3ez8SCtkro5M0cLrxAf6rRrFdQ7086HZF0hRtDrxqGzjsc2bMibjk5UYvpvIWVcDQPu1+vluNg108RhLNG5ZbaNaYhqCoh1xz07bMMGtmsEckdj50cDi6jjHj4kLZkb9y256H4Kwt+DhdGDOhApTu5S4VoVcTe+LiNsV3SvBDDck3qvGZcZkn+2+ZJdc6qYDEcfK60REOdu6cXSJT+LE6r7tBvWnhACrGJn4HTA7zyT2sLVt6/pc9Uu1qZLCz3+/DRH/VOjgx4tY3pT/8QdgWBz4IoRIOXSEOGVxfeSOxkdMNgMbKBsu7y7AfGvxkg/gHDsd1Sg+saIsRio/WGnFCcDWbI8YX0RnF96eMWEVdnhiAMA6KyOS2zxq8VFKevtdDFHV6JPlgdjy3NeaPnTzQBgaxHHHwCES7c7VQ5/MHtKrzQ29Fnvu2So0OeNDsg6vrqRFpP8+7d/yFCLi3N1IOjfIIZbVbIwjUD63SAdMOG4fjk2+FYH3614nlCMzeJKXfPHhqu/uovU3qukV9dS3VjHuPnkXIyLurJQI7Lm+W17Qs0viZTIy3G8i7CeoF+wPPa5J6/r95oNZTM38mmqsYDU0UnJyLc38gm8LK0wF331ZpYrT8K3WIRUguOFDqfczc7CSiiwwLZw43DV3ksCVGa5FgPe0SPa4EOvHWdE8+ukJvE4vFXUEj7/+siNQvs3YL23YF+UPWfD+YcsTbjgBYB/wTbfNmGjab7aR44v2
 FYDWYwBu
 OmvWIMNkL4FKuQbnJz9Oc5piVtME6iHtHNlVgDy4NhVRC/nuUXPCG/RXqkQkeiJ8EmErNcSW3bf/FO2BiNRzyPUwigXzL1M0qYHCRkyihr3RIeo+PGimaIQfAbcsP4BO8Zq5C8bHGpRNGwFrqTbsMOgmvDjolqDO85ujl8xML72zRt9yZIE536gy81Vd1wR4NZVQJ+dAvxp8o1mWgl19KLBq8jXDr1iHeysEjAbGMs111PGoHpTq6aGvkVqsKCj+S6TI8Z9M5vMEXyiH4N9XbZuzzf+faNBCUrj7q0Cow3PwDKGM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 03:11:03PM +0200, Michał Cłapiński wrote:
> On Thu, Apr 16, 2026 at 6:13 PM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Thu, Apr 16, 2026 at 05:06:10PM +0200, Michał Cłapiński wrote:
> > > On Thu, Apr 16, 2026 at 4:45 PM Mike Rapoport <rppt@kernel.org> wrote:
> > > >
> > > > Hi Michal,
> > > >
> > > > On Thu, Apr 16, 2026 at 01:06:53PM +0200, Michal Clapinski wrote:
> > > > > @@ -2262,6 +2253,12 @@ static void __init memmap_init_reserved_range(phys_addr_t start,
> > > > >                * access it yet.
> > > > >                */
> > > > >               __SetPageReserved(page);
> > > > > +
> > > > > +#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
> > > >
> > > > No need for #ifdef here, there's a stub returning false for
> > > > CONFIG_MEMBLOCK_KHO_SCRATCH=n case.
> > >
> > > In all 3 places the #ifdef is there because MIGRATE_CMA might be
> > > undefined. I already broke mm-new branch in the past because of that.
> >
> > Hmm, that hurts :/
> >
> > The best I can think of is to add a static inline in memblock.h and ifdefs
> > around it.
> 
> Sorry, I don't understand what you mean. What would that static inline contain?

Something like this:

#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
static inline enum migratetype kho_scratch_migratetype(unsigned long pfn,
						       enum migratetype mt)
{
	if (memblock_is_kho_scratch_memory(PFN_PHYS(pfn)))
		return MIGRATE_CMA
	return mt;
}
#else
static inline enum migratetype kho_scratch_migratetype(unsigned long pfn,
						       enum migratetype mt)
{
	return mt;
}
#endif

Can't say I'm happy about the name, but could not think of something
better.

> > > > > +             if (memblock_is_kho_scratch_memory(PFN_PHYS(pfn)) &&
> > > > > +                 pageblock_aligned(pfn))
> > > > > +                     init_pageblock_migratetype(page, MIGRATE_CMA, false);
> > > > > +#endif
> > > > >       }
> > > > >  }
> >
> > --
> > Sincerely yours,
> > Mike.

-- 
Sincerely yours,
Mike.


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23A72FA3728
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 06:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 527796B0088; Fri,  2 Jan 2026 01:59:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D5276B0089; Fri,  2 Jan 2026 01:59:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B6D96B008A; Fri,  2 Jan 2026 01:59:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B5426B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 01:59:39 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A96E5140335
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 06:59:38 +0000 (UTC)
X-FDA: 84286123236.10.61CDDF1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id F41C2120005
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 06:59:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JURDexdX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767337177; a=rsa-sha256;
	cv=none;
	b=oUfAuk+RPITvIMt9WyFdGAFSH8TT1AgiNgR/9Puu1vnHaVbOQI/1gFztFKs0SpImJ94ziU
	wbbzdCclp85Un8sZZ46yXiuJoor0fX6LWMqRZla474D97dDCRFjU/GuZq2pKv1R5EG33Av
	Tb5/ey254TgqbD6WOc9xQE50sowA2YM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JURDexdX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767337177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I0saHnqZE8DNUz3Eq4POw6LWeguXVeLKnWvje6WQ15M=;
	b=DkA3EY+ZnVBoryCziATyiGECA5zBGSGySjZpusUFigpF2fr06YNk+/FWhNt4reHuSRdA0j
	+A5GI/Mw5c1D2FZKEqQhRRLUr7oVmywG672MNxM/vuE28/aPafJtcLrkMlwJVvXbk/N5TE
	7NI3EnriWLAy68c8TVWlFFteUAm6f1U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6490F439EC;
	Fri,  2 Jan 2026 06:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B4AC116B1;
	Fri,  2 Jan 2026 06:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767337175;
	bh=6UamW9ypeYvnLArvWXDR1zXy9G1XczNWSIs66XcI5UY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JURDexdXezRaYfVCWbUaXW3lzvXlm31RIqEgAxJWeFjD7mvppUL+nB5Q6DW/syoE7
	 9KCN3XX0+IFrZ6lXHKvj23Zbubf1juMpQoyVR3R5K+W0wTXoTePytdymIvKf7/FuUt
	 b7F7Op6aP4W0iuoMzjx2QqloKghcV05PUK7YhWlqmCDHRezSFJ5+E+XxOvd9U94KrO
	 yMpXKhnr9xm6zugptlmyDIWLkIzbYaeb0b/lyAP5EPPZjPoSkHAZCyI/7qGe07Bh3c
	 ZF/OMYqQXU+WaQeAzqytLFSZafleWXTxSNL1jQdGV6O5YweZiL0UFX3Jm+OycztA8g
	 kFuOhUi2qJ56g==
Date: Fri, 2 Jan 2026 08:59:12 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Shi <alexs@kernel.org>, Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Borislav Petkov <bp@alien8.de>, Brian Cain <bcain@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guo Ren <guoren@kernel.org>, Heiko Carstens <hca@linux.ibm.com>,
	Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matt Turner <mattst88@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	Stafford Horne <shorne@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vasily Gorbik <gor@linux.ibm.com>, Vineet Gupta <vgupta@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
	x86@kernel.org, linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
	linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
	linux-mm@kvack.org, linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-snps-arc@lists.infradead.org, linux-um@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
	sparclinux@vger.kernel.org
Subject: Re: [PATCH 00/28] arch, mm: consolidate hugetlb early reservation
Message-ID: <aVdswNM9PUN6Kr8Q@kernel.org>
References: <20251228124001.3624742-1-rppt@kernel.org>
 <20251231172714.a7fe44e856c14fdc8fe1cb43@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251231172714.a7fe44e856c14fdc8fe1cb43@linux-foundation.org>
X-Rspamd-Queue-Id: F41C2120005
X-Rspamd-Server: rspam03
X-Stat-Signature: agw8um4n1njryfped1txzidbugdxwbcs
X-Rspam-User: 
X-HE-Tag: 1767337176-839692
X-HE-Meta: U2FsdGVkX1+rm8KNAudXILwwPNz/QmqxylJhOOCY+m13a/52e6fvya5BiidVWPdDXLw+TB/a8F9BD0SD4IPF7CJ6NFnqUXiV5EPsk/SjrpG1cxISCJQPo2EwUhzuPvBfJdU79nqL66AX28/8vqPycOLPfx0NsVlRMdCObtSZ7Sxc7vjxEqjTAY/1EwPx0rQUHUNnP6EgMAe+FjrabzQwT7Z5dqacBVTYFXXxPfP3kXDyq8i+54hhjBQQG48NZ/AHlyl6HPswZUFcUiagNIcGefktl1hfEZwGdwN+gHKKUwUUQFu8SQFVqQIYxkdVTNuPkvUNfI3JLLNJbyYHkZzm3wkW87N0NshbhxT5VyabLgK6ssLTTi0nglzbJ3Wl44IvlSdpX/+atC4/RqVzqzuUB3HzhHjlTgJeM/1I40RM5k72cV9694hze9YSrpaukrLuTEWsr8Vl/Cm9UjvcndCLHoD4ZMutXOvN4qXjn+jDv0FjnYy6S4hyb/0FCq0wFSkqWmn819KkF3StKgBjRo/Qschg0+OIzLwnooIZMPderUphgFZDUkXfndU6ouRjyNiYbdPiBJ6vriU6cGg9H9pSG9tBZ3RaL8zsNow/UGaWkY1pEulBFzzj0X8DaonsK69whstvq15B2cAJHsoH4JXYSCMmuaLyyA7I5p2z5bfA+u1Azynp8xDkxSo9h69NXydp+8Xy2JSEIbCvRwUuOiJk0pSWZTJ1EwUS3MdxUMosHZSifImsR4HPENBGu1xslhHj92+SbTeiKGFU8BiCqumUvP4Jnp1pdpd9pDIltp+2IVJGB+IVH35UQkArt9mxmyNW5id9Ps5GSsAvhrbk/wMD5+5DKCMCRHfN6hKtKKSuhUmQzEoOgHFs6XDwle0d8TXKMzVwNpMQTL6o08TIq/xrCojDuxhzREWDSAWdFJ9tZYnM3IFQ77RmxThpq0VIuLfDDVMXFbvpoCYH/l/0TpX
 A4QeDdB6
 UEEvL1GN+d0bgkj4KhULdDGxEPoJavRs4v3ZlaYAdiGthrkaGf0LKq34DVAIjLXCdu7J3lgLDWX1NGfgR4aZiicgJrcmctD3i7DzKvsndFDaDdtW5Kp6pHJAXoygRFJWrXBcX1bWFnCINrBJ8koEURvxaBioeUBuy8R7nlqp1CVkGuMv7eljfMVcm/6NQCU63IfSTnmO+4cEvt4Y4S+Y+5A6zztXh9kmRwFtSapevOYuptY0ecMGjugxQe9z7HI2dmSKuYQo9W+Dl+HXpH9BB9HfTgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 31, 2025 at 05:27:14PM -0800, Andrew Morton wrote:
> On Sun, 28 Dec 2025 14:39:30 +0200 Mike Rapoport <rppt@kernel.org> wrote:
> 
> > Order in which early memory reservation for hugetlb happens depends on
> > architecture, on configuration options and on command line parameters.
> > 
> > Some architectures rely on the core MM to call hugetlb_bootmem_alloc()
> > while others call it very early to allow pre-allocation of HVO-style
> > vmemmap.
> > 
> > When hugetlb_cma is supported by an architecture it is initialized during
> > setup_arch() and then later hugetlb_init code needs to understand did it
> > happen or not.
> > 
> > To make everything consistent and unified, both reservation of hugetlb
> > memory from bootmem and creation of CMA areas for hugetlb must be called
> > from core MM initialization and it would have been a simple change.
> > However, HVO-style pre-initialization ordering requirements slightly
> > complicate things and for HVO pre-init to work sparse and memory map should
> > be initialized after hugetlb reservations.
> > 
> > This required pulling out the call to free_area_init() out of setup_arch()
> > path and moving it MM initialization and this is what the first 23 patches
> > do.
> > 
> > These changes are deliberately split into per-arch patches that change how
> > the zone limits are calculated for each architecture and the patches 22 and
> > 23 just remove the calls to free_area_init() and sprase_init() from arch/*.
> > 
> > Patch 24 is a simple cleanup for MIPS.
> > 
> > Patches 25 and 26 actually consolidate hugetlb reservations and patches 27
> > and 28 perform some aftermath cleanups.
> 
> Thanks for the diligence - this can't have been the most exciting thing
> to work on!
> 
> > I tried to trim the distribution list and although it's still quite long
> > if you feel that someone was wrongly excluded please add them back.
> 
> I'll add these to mm.git's mm-new branch for some testing.  I'll
> suppress the usual email storm because 41 * 28 is a lot of emails ;)

kbuild reported failures on some configurations so I'm anyway going to send
a lot of emails for v2 :)

-- 
Sincerely yours,
Mike.


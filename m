Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43430CD5829
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 10:20:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DC326B0005; Wed,  7 Jan 2026 05:20:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B2B36B0088; Wed,  7 Jan 2026 05:20:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D6916B0093; Wed,  7 Jan 2026 05:20:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2DC3E6B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:20:47 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE5241A029A
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 10:20:46 +0000 (UTC)
X-FDA: 84304774092.25.82D9F66
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4A3E2180002
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 10:20:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HG3UgZmi;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767781245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YAjWTfL5/3oXi6ADzeSFQa0DHNLHQ/Gxlrenv2YfAWg=;
	b=QffWTUBYUO4a8PvT3o60bNIJ1OwAypI2lFYT1gOKUUkicP4pC4ZHwpIBk+PDFio8orn/xG
	5JattatpNdT2pDh5l4CBtnsf6AK6y3WhdC+zOmk9wAY0EaBeLd34dtUdaNqcTzd4qBUMCS
	GDV+sNW1/RAxM3UQpTGGR18jFUNtcYw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HG3UgZmi;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767781245; a=rsa-sha256;
	cv=none;
	b=7NJUfdKBV0UFJyY9cZ7IcS+DHknWI/nWqp29pOyaLcR6iWCXNtxeXBgGAJqDcW5osXdL4A
	H+QcGWr00joWG6MBFsGcyTwN14IM7TjyKsScPqSbFa0uvp4QsG4PthaQXLoHi14D3MUWuE
	zSW/J46GOsihaTnFK6a5aqX7cp/Wd+Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3697D60007;
	Wed,  7 Jan 2026 10:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332F3C4CEF7;
	Wed,  7 Jan 2026 10:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767781243;
	bh=2N7QgaN9sMjltiFqaQG4UkyiWR5RDDQ2n4IgHLPouW4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HG3UgZmir72YPYFm/emlV/3aORPdbjLAnBvpX04p5XtFP762LStn/wPAzNuqOQyK8
	 k7OnYBM5tMSwl6jbeHb8PLi19AGtC/53sTnfGuvHRwU1J5fTUCYLII+PuhChCRsuuP
	 lesNvqozgo8UJHTVTNpJsDervk1O2VsPtftbzvVYNlT5k9C+Ou7zoWZDNLa9w7OL7l
	 1I+dvThsPPRQrJPx2bNt/P7eQY786Hlh4y2DUZqzVomuI/Tc2vep7bqbTNymx1RDAb
	 W1AWrPHPHnhn5oDQwiHOAOhH7g90DnMJIt+6Fqkfre323p/NzMyoEh/2zKKa/f4rTg
	 6GL2C2ybj5rcA==
Date: Wed, 7 Jan 2026 12:20:23 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Shi <alexs@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
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
Subject: Re: [PATCH v2 14/28] powerpc: introduce arch_zone_limits_init()
Message-ID: <aV4zZ8D5eaLC6K-w@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
 <20260102070005.65328-15-rppt@kernel.org>
 <87ldia9he1.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ldia9he1.ritesh.list@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4A3E2180002
X-Stat-Signature: cww1yoxaciwaabyf7wrbex9kixz48bzg
X-HE-Tag: 1767781245-202197
X-HE-Meta: U2FsdGVkX1/j/biQ+s2WS8jOlnALtzYola8zp3a67hvh3W7rf4r/LJdA+hKRmER3+61vUGs77ZHcOcEBCjdmyEukEd/AxZydHJc+qAVU6n0e5CcDuzMgC2CBlQ9XrMBpyh6POBeXytwtNjY857NNr7/mL7N0xseTZB3jIkXnz7IljYzUPQMjQzGw1y+wtQQqpaClmaKQsyjDkJ5il3k0KjbYasi/66eQY0Dk+8WOTDMN/MY0KekSxFLEizbQVZtdwDQJt/Kl+QSk6n3/mlrkkmV4hLQy5LzQltwOVy1JQ5ixxytvK1uDKuG0zhw5ZE8v+friuovZt9qB+8k3p5eucvKH/MC3FoXajBftbimI5UdJXxsHBSzn2pbZCqidYV31/D0t4NEPqavX4egdJudfmh6vKJn8RSBxwEHVEODDUQ9JJK9QTEUTw3Fyl6WxOgyebtsfHDQVnbWoeI3+c7nFHeIpmJrBjPIP2/zlANp34YR2RzMGuCOuIb6BwgLOXUjdHb+L9pXav9Hklc9cVm7dtGrV5y9V6Z0E/AGjOWbQdl1KxgL3RfuzwF6su4SKADheb6XJoK3EvLfXWMvapyAo+1pbEiOfS1FLMkZf3xJC1hsK8moTUnMx5V/T6Pw+LuqHcm0zywRFltGSdkqeLCrbWCpvBE60v/KTdtbdanHmYsQ5oQiOlNQk+uixVYtF6Jab+ZBpOG0G4322hmKWBUdIwAvFvkFVxiE8WjYmenRZnI11FtgUlwbPQKufS/Kk2Sl2t7o1HwDlX4czqc7WjDpJ5OhtRlWo7IRpNsw4l5u8dDUwmyYmSp8J2RFOEs+ucd/eEA8N7w8Uj71OY4IdXaNDNMxr9Nu90ShzU7vCcXyLpKs6pvvrMLkGloTDI/NHrPZCMUx1+qluTZla4QREhq++LZWLfk5RJiFani7Y4wVAz2gURSVAym0Ub9wO+TAJd7WjF1ZqQYQYiYKHGvT9T0F
 yipLtO59
 UhGUdKfcr7tLPOikvvk+obf2R4QPjwqmGoyAO6GwTQ4W/dOsb3rX16KyNd5aDBGAeEdsNYlorUnl/pTUsRDhD8LnqbJKYX6zX/jVY5NR4SPvuUvasSsoIsspRExlUfTmM8j5D3JKHbaaAM1hRnnQYa/pmtIZEH/y1l6FoH8e63zvQJefMrvew6g7bnNl25Z+HV2ZiPiJrzL98B29yRwJ74NiJ6qYrD8YEJ6Immb/ZtRb6kF/LHOJ9xpP/K+BYDod02aR1uyzD+1xgz4KSvvNTeR0YzcMAUx2bTd6S0w8vy2opHBRzV33t5nK/Alc2DyDWRtN8TYu5sIup0rVhuEqgl9eV5ZZnmTfUQQKK3AVCLX5VV5n7O9HIVDo/hyXetvAKSACxiYFJr1v+GZY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Wed, Jan 07, 2026 at 09:57:34AM +0530, Ritesh Harjani wrote:
> Mike Rapoport <rppt@kernel.org> writes:
> 
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> >
> > Move calculations of zone limits to a dedicated arch_zone_limits_init()
> > function.
> >
> > Later MM core will use this function as an architecture specific callback
> > during nodes and zones initialization and thus there won't be a need to
> > call free_area_init() from every architecture.
> >
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  arch/powerpc/mm/mem.c | 22 ++++++++++++----------
> >  1 file changed, 12 insertions(+), 10 deletions(-)
> >
> > diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
> > index 3ddbfdbfa941..32c496bfab4f 100644
> > --- a/arch/powerpc/mm/mem.c
> > +++ b/arch/powerpc/mm/mem.c
> > @@ -221,13 +221,23 @@ static int __init mark_nonram_nosave(void)
> >   * anyway) will take a first dip into ZONE_NORMAL and get otherwise served by
> >   * ZONE_DMA.
> >   */
> > -static unsigned long max_zone_pfns[MAX_NR_ZONES];
> > +void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
> > +{
> > +#ifdef CONFIG_ZONE_DMA
> > +	max_zone_pfns[ZONE_DMA]	= min(zone_dma_limit, max_low_pfn - 1) + 1;
> 
> Hi Mike, 
> 
> This doesn't look correct. Isn't the zone_dma_limit value in bytes actually?
> Shouldn't it be -
> 
>      max_zone_pfns[ZONE_DMA] = min((zone_dma_limit >> PAGE_SHIFT) + 1, max_low_pfn);

You are right, I'll update it for v3. 
 
> -ritesh

-- 
Sincerely yours,
Mike.


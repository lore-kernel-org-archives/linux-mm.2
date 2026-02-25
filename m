Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5381CFD3773
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:25:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A075A6B00B8; Wed, 25 Feb 2026 11:25:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A49A6B00B9; Wed, 25 Feb 2026 11:25:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87C836B00BA; Wed, 25 Feb 2026 11:25:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 722936B00B8
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:25:48 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F37CBA14C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:25:48 +0000 (UTC)
X-FDA: 84483505176.12.509C290
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id A169D1C0009
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:25:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cULZ5qEP;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772036746; a=rsa-sha256;
	cv=none;
	b=VETQJ30xD81ujcRYC6+pJZInbkZl8X66NFJRg3BLW+3j6nkEFNm2yyiG+0BH3QX8RUDzYu
	BnTr1U1kQGlkOcp5HP7N3GAG8RlEzXxtUGsFfbgkuAj1ZQaLqriGeOGvYkTq/W4g+RLkWC
	OWM/sbtdlC8lxZJ/iDF97rkRV2FfxPo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cULZ5qEP;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772036746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ho7oD4oPu5/eYCdKSOQS6EY6Lbkwk1pVey6+CNgj1os=;
	b=cs1e0OqN4xz6I3gRBzAy9b4G0FQ8B8jhc2nONb0GbyKvOjiKT84mDejkznVqAbgWSNnBLx
	tW06zyoIAJv3FWURSMwTgx+sZzlRgoBdygby3iZD4AAkzRD/qOB+XPx/nXXseAaWVdwEnw
	pohqkRAr31LNrRRxNdP2yuGpSMp5KtQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DCF4660126;
	Wed, 25 Feb 2026 16:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3776DC116D0;
	Wed, 25 Feb 2026 16:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772036745;
	bh=guCbsIDgg8ayG9mMMymVvi9nZm4Jxc5WYXcp2FwHotE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cULZ5qEPz3eS7I+Fsxr6miX8AP+0kVboSS3w9recg6hIWBQu8d492aJMKFAtePr5C
	 Yxw6zeIYl0NzkVTqOY+rZ3drD+EwjqMadIeU3+bhyJFoPCMVo0RZaVEqrkGtGCEwa4
	 bcriv7DhH2j0T9uGVeVdL+y8N8zL0iY2hVFSWAbADuMDI7VU71xE8IuqKkYJ+gZCsQ
	 xR3OY+ov4QmLACxJ9gpX2X8RBJq46iAC34jhNq6rOPIAXeo23p3YGZbABHQNK9QxkC
	 B70PkGx9oFgxrBgyJwJJ0C90f4GZTWG9hD7VkXOtmEBOVrFFkcSQg/ezo7Ywq0Uean
	 YvcAIzi1k5CAg==
Date: Wed, 25 Feb 2026 18:25:24 +0200
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
	Klara Modin <klarasmodin@gmail.com>,
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
Subject: Re: [PATCH v3 24/29] arch, mm: consolidate initialization of SPARSE
 memory model
Message-ID: <aZ8idANginXzhf0_@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
 <20260111082105.290734-25-rppt@kernel.org>
 <87tsv5h544.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tsv5h544.ritesh.list@gmail.com>
X-Rspamd-Queue-Id: A169D1C0009
X-Stat-Signature: tdipy9ncotbgwj73esz8egn5ccxufm6k
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772036746-496759
X-HE-Meta: U2FsdGVkX18AUyPqLXBwpe3C67/3nv3igRzgZ23QHirMjCFCnFf2FvmMx8gkkhnFqmdF0QJmemC4qmwPISLDi+7SWX+8aV8kllM5K91IigPIe5v8gld0GkLi2FWuMcjIuwtwSo1HKYPJbjPG7r6jkc/PBAX1LqLOKkLRShZA5A8aVzpP9CnM6cIk735a3wevs+eUXRj6yjyiHBcNWHP/w7xo/Czpq9yH+UB1UlOojzphVqVUINbsGb17QbrC2FG+xcWo+7pXg9KRqmhRG/fgUwVeG4QAxJlCZ7AxRdnKqxDuG5XuP1mdxNSkJKYLeFBaY1k7z3VjOgMDzyoXZyw1aWwWpEuaiDy7KiaDZGeX9jYV9vt37Gf/T9r2MfvefqRNBUJFBjOcLpyvPk0+gChI+pYmBXFe1KyXshAvey4j3zzg1ptGBdIOGpCdvdNzuoLOq2IoY3fvk7bnECVPt/ZB/xpop4r1pVvEmlWpn1Dr6RTlZBBSe6di0mw4Wnv0W6wWokMGYMS7ZVVT7BCaDj3KLzEOZMLgOsYlEmaxvWoHCPRVuNvmf+SNwdxdwWEv2CXcIZTp/UVLET//fqaA6dZ7qVsXJs1AW+Az6/fahC4qdmLv1/Mgk7sMkm9XYnhSpFRo1MGPOTfc6xloL2FU7aqNhm/XzaRgNkICKKuS7RpKRKYoNKlZs4tIH0FLVJ3Ht0zXvSrZK3JljVv3rO6Afzp08tV/Z/KmcU6MAG0ugPsAPikJxf1UwWbOQWPznXTIPtW1/HWOOQ16mjAFIW35YGrGDFf3TnEuMPdk4exTMluFLU7+W3OjA+he8B5DEcEgwn0POcNYGeeUyybTb+e+PdQaRSe7QWxHJ+K4NmX9ESD6D218P5g7BpNBkJQD8CXbJWZfQ+4XFhcg3MD1ccnLsEPMn91plt9yKk/2m0BLX+DMMqO2Ppw3coN1/MhANCPfexj1WRCcFWJeqAwPgzuH/Ku
 zuO+qdHr
 nUicitg0qj38h60Hdb53CDE/lROIXkP70op+CeTKx3dtInNrXWIyDHRu+54M1rEYSBMJC+UBHSseOMjv8/IQnHzF2nXe54zi72Dzj/MA/fjHKvnXTKTDJ++NMTjLmiGmb5BN5oZ7sWB5N2IxGTEi6CeVuJtD3qj+TMMe1CTC2xa85vwKCuoHXm1nxucorZq6x5zd1DBHjR2gVq1HIdgHc4RoZD0U0c+n5WSmKU84scSPFMjWS6p8EiN8vs7YXbMRX06eqycjYWkKNmWR2MRKyPja3IvgCIozeBMK0gAd0cxEZ4Gyz9hyOVb7vcEcw+cxdRWIN81b4s0FtAtjAcojq/oqtHnglDi6QT7wlUmBzwEI+eLq1vvCpZ06Lks1q48hR1sj/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Ritesh,

On Wed, Feb 25, 2026 at 09:00:35AM +0530, Ritesh Harjani wrote:
> Mike Rapoport <rppt@kernel.org> writes:
> 
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> >
> > Every architecture calls sparse_init() during setup_arch() although the
> > data structures created by sparse_init() are not used until the
> > initialization of the core MM.
> >
> > Beside the code duplication, calling sparse_init() from architecture
> > specific code causes ordering differences of vmemmap and HVO initialization
> > on different architectures.
> >
> > Move the call to sparse_init() from architecture specific code to
> > free_area_init() to ensure that vmemmap and HVO initialization order is
> > always the same.
> >
> 
> Hello Mike,
> 
> [    0.000000][    T0] ------------[ cut here ]------------
> [    0.000000][    T0] WARNING: arch/powerpc/include/asm/io.h:879 at virt_to_phys+0x44/0x1b8, CPU#0: swapper/0
> [    0.000000][    T0] Modules linked in:
> [    0.000000][    T0] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.19.0-12139-gc57b1c00145a #31 PREEMPT
> [    0.000000][    T0] Hardware name: IBM pSeries (emulated by qemu) POWER10 (architected) 0x801200 0xf000006 of:SLOF,git-ee03ae pSeries
> [    0.000000][    T0] NIP:  c000000000601584 LR: c000000004075de4 CTR: c000000000601548
> [    0.000000][    T0] REGS: c000000004d1f870 TRAP: 0700   Not tainted  (6.19.0-12139-gc57b1c00145a)
> [    0.000000][    T0] MSR:  8000000000021033 <SF,ME,IR,DR,RI,LE>  CR: 48022448  XER: 20040000
> [    0.000000][    T0] CFAR: c0000000006016c4 IRQMASK: 1
> [    0.000000][    T0] GPR00: c000000004075dd4 c000000004d1fb10 c00000000304bb00 c000000180000000
> [    0.000000][    T0] GPR04: 0000000000000009 0000000000000009 c000000004ec94a0 0000000000000000
> [    0.000000][    T0] GPR08: 0000000000018000 0000000000000001 c000000004921280 0000000048022448
> [    0.000000][    T0] GPR12: c000000000601548 c000000004fe0000 0000000000000004 0000000000000004
> [    0.000000][    T0] GPR16: 000000000287fb08 0000000000000060 0000000000000002 0000000002831750
> [    0.000000][    T0] GPR20: 0000000002831778 fffffffffffffffd c000000004d78050 00000000051cbb00
> [    0.000000][    T0] GPR24: 0000000005a40008 c000000000000000 c000000000400000 0000000000000100
> [    0.000000][    T0] GPR28: c000000004d78050 0000000000000000 c000000004ecd4a8 0000000000000001
> [    0.000000][    T0] NIP [c000000000601584] virt_to_phys+0x44/0x1b8
> [    0.000000][    T0] LR [c000000004075de4] alloc_bootmem+0x144/0x1a8
> [    0.000000][    T0] Call Trace:
> [    0.000000][    T0] [c000000004d1fb50] [c000000004075dd4] alloc_bootmem+0x134/0x1a8
> [    0.000000][    T0] [c000000004d1fba0] [c000000004075fac] __alloc_bootmem_huge_page+0x164/0x230
> [    0.000000][    T0] [c000000004d1fbe0] [c000000004030bc4] alloc_bootmem_huge_page+0x44/0x138
> [    0.000000][    T0] [c000000004d1fc10] [c000000004076e48] hugetlb_hstate_alloc_pages+0x350/0x5ac
> [    0.000000][    T0] [c000000004d1fd30] [c0000000040782f0] hugetlb_bootmem_alloc+0x15c/0x19c
> [    0.000000][    T0] [c000000004d1fd70] [c00000000406d7b4] mm_core_init_early+0x7c/0xdf4
> [    0.000000][    T0] [c000000004d1ff30] [c000000004011d84] start_kernel+0xac/0xc58
> [    0.000000][    T0] [c000000004d1ffe0] [c00000000000e99c] start_here_common+0x1c/0x20
> [    0.000000][    T0] Code: 6129ffff 792907c6 6529ffff 6129ffff 7c234840 40810018 3d2201e8 3929a7a8 e9290000 7c291840 41810044 3be00001 <0b1f0000> 3d20bfff 6129ffff 792907c6
> 
> 
> I think this is happening because, now in mm_core_early_init(), the
> order of initialization between hugetlb_bootmem_alloc() and
> free_area_init() is reversed. Since free_area_init() -> sparse_init()
> is responsible for setting SECTIONS and vmemmap area. 
> 
> Then in alloc_bootmem() (from hugetlb_bootmem_alloc() path), it uses virt_to_phys(m)...
> 
> 			/*
> 			 * For pre-HVO to work correctly, pages need to be on
> 			 * the list for the node they were actually allocated
> 			 * from. That node may be different in the case of
> 			 * fallback by memblock_alloc_try_nid_raw. So,
> 			 * extract the actual node first.
> 			 */
> 			if (m)
> 				listnode = early_pfn_to_nid(PHYS_PFN(virt_to_phys(m)));
> 
> 
> ... virt_to_phys on powerpc uses:
> 
> static inline unsigned long virt_to_phys(const volatile void * address)
> {
> 	WARN_ON(IS_ENABLED(CONFIG_DEBUG_VIRTUAL) && !virt_addr_valid(address));
> 
> 	return __pa((unsigned long)address);
> }
> 
> #define virt_addr_valid(vaddr)	({					\
> 	unsigned long _addr = (unsigned long)vaddr;			\
> 	_addr >= PAGE_OFFSET && _addr < (unsigned long)high_memory &&	\
> 	pfn_valid(virt_to_pfn((void *)_addr));				\
> })
> 
> 
> I think the above warning in dmesg gets printed from above WARN_ON, i.e.
> because pfn_valid() is false, since we haven't done sparse_init() yet.

Yes, I agree.
 
> So, what I wanted to check was - do you think instead of virt_to_phys(), we
> could directly use __pa() here() in mm/hugetlb.c, since these are
> memblock alloc addresses? i.e.: 
> 
> // alloc_bootmem():
> -   listnode = early_pfn_to_nid(PHYS_PFN(virt_to_phys(m)));
> +   listnode = early_pfn_to_nid(PHYS_PFN(__pa(m)));
> 
> // __alloc_bootmem_huge_page():
> -   memblock_reserved_mark_noinit(virt_to_phys((void *)m + PAGE_SIZE),
> +   memblock_reserved_mark_noinit(__pa((void *)m + PAGE_SIZE),

It surely will work for powerpc :)
I checked the definitions of __pa() on other architectures and it seems the
safest and the easiest way to fix this.
 
Would you send a formal patch?

> Thoughts?
> 
> -ritesh

-- 
Sincerely yours,
Mike.


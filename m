Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C309FC6182
	for <linux-mm@archiver.kernel.org>; Sat,  3 Jan 2026 20:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A39D6B008A; Sat,  3 Jan 2026 15:32:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57A886B008C; Sat,  3 Jan 2026 15:32:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45C896B0092; Sat,  3 Jan 2026 15:32:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31AC66B008A
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 15:32:33 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A90021A08F0
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 20:32:32 +0000 (UTC)
X-FDA: 84291800544.23.F905CCD
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9AC5B140011
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 20:32:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Uir8r56Y;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of klarasmodin@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767472350; a=rsa-sha256;
	cv=none;
	b=OX0HFBiJiagkh3eKfPn3Ova9kcUwcKXChaYlFEbmVYfg4t+sUV8Wc3UjI2wujSbgwoIuQY
	ZGcOHVaR9Xbhb2bLrVUI4d7na7WfshNjpAgjYn+HfOxPCTfTLR7BeevA5lOEH3aP5H3WTh
	32pTZU0hoLStZUn+MFkrmuEuZUZW4Nw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Uir8r56Y;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of klarasmodin@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767472350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7o+8V3bXuMIGcHyQUku83CYs/vu8fbyRY+Gob8yvlG8=;
	b=iHGPnB1wWFEB56gH7gzn4c+qjROL0hjJphvyesfmBL2wt4/TjbhALcIItKQWi4vkkcFq/a
	bdsEbh+zL1tWotWol3/kqOYKtYsNtw2tjauPPq8qR9MbkpsNzkoBUDLyXGnO3AwPTkLc5u
	Ha7ummhBM2YH+ut6B7YOPEgJFb7HgPY=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5959d9a8eceso14666188e87.3
        for <linux-mm@kvack.org>; Sat, 03 Jan 2026 12:32:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767472349; x=1768077149; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7o+8V3bXuMIGcHyQUku83CYs/vu8fbyRY+Gob8yvlG8=;
        b=Uir8r56YZ2PcCKAbMh2jF45ASwOpBxVHyraa5VYbwRTmL9aLXWqrqLQVZheCuXVDoA
         qt37x266kaqDY1wB73xA3aGCQAAaORDtiStXB4ZVZ+8cjg4UL4bZai6Ml3zi+0WlL9rE
         7iTJ6Dlxzq9FBxevMDiDDYZ78N3kwKJdmbkZjo160DsY1YSeeJTnzXmPJv5/Cv1NIcfi
         QCvJUm4wLF99GKjYW3PKBLpYLgVkDg42eiPM2ELHo2xw4voW5WQ2Y6Gy5DzAYUlmsAQr
         wqwEgmIowNzoH0RiuukUrgoy6bu8hOfo/G+LIz3yE8xi80rNbKxSZFXwtp5smsdy3UdJ
         eDiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767472349; x=1768077149;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7o+8V3bXuMIGcHyQUku83CYs/vu8fbyRY+Gob8yvlG8=;
        b=bXKPjyDKMy3Y0txvRylU1j+/78oB59R1CccZDnq/AK3JDftv8JBpZVgaHku4RiWgPu
         0TYF5lf1shFVZ3FgJTd1bnhVpIvgbNryJaU3qlCzxo0L2Rm4A54e760gl3u2BaRroSbn
         CgpP//QNL1OUuz+dJNYFaTz21tDuRO1clR2A6DBlzLaPeXZKh/SLwmZGEWyuoIJasj6S
         mk1h7UZrQVDYLvI7JhGuo0em1Qq4E+ky8PKcPDvRft2nbTcm7/daKTQadzeuglzS/wBe
         HKxIRbrtFYx+95gnG9H67p2yCpM3WpgUt/7EXhEcHu2fBWqBwuW1B0ftKuTcOwb0v4eR
         7SSw==
X-Forwarded-Encrypted: i=1; AJvYcCX4LTZJ+CCcWIeEt3a0Tb99dXuxPO8NPtKfPKxxntc1QkfTN6vVYk6LjYiNKw6IBhXjl3C59uyTyw==@kvack.org
X-Gm-Message-State: AOJu0Yyc8Kw4fd+5PmnSgmZoub0VVYvG9exdwArlfKR5cxriFzMP0mJg
	M9IX88Nz+IZUKu/42GV1yaJUbyuoo7hXxKFyI7D6PoQ0UPSsg/AF19pW
X-Gm-Gg: AY/fxX6v2KuxpV6DwcLfYxG9DmtZG5XWqu13n6cev8hjxKt/fZHyTIRmg/aBNw221G2
	y9ok1rJ7KKev6TirmoOStSYWLBEYLDKUDAUBajbiCjB0d0FJwTGmSVt4LrnZUyVAkI5YCYolgH1
	kWq3p0S7iPpWmlUT3d/1fu37ZDSDhrgCqO1dcOZ75Rj8fn4c36aVUFiFaJQdPbpDJXzxROfwLvf
	VHfv3ndmSgv2iuHnhaesr8F7nyEfHwVm+6xLZBCBBNnuBWv7flNYnk3oMC9XQVigj2rLNAEV7Go
	OtWIIfKmdvGz68RDGtsfviw+eBrtq0WYnKHcoruY3pMUpcjmK9r8VE4cogsA0gbrROuqwPcvKPB
	I/FQCGbq3ksNwKEhod/mL3a7cCcv8uNZrp/isjk8elMPkeVkszWb4fmEBls7GaDmXEHTTDyAu51
	IqnQnbptcF7EuygVCkuI6BhfYnpz0Y8uwwv5jNQWE1TQ==
X-Google-Smtp-Source: AGHT+IEnoPR3bLjgiHz8V/D0bqIfe+KGL8qN+8iViiiSSYeZJp9K5TsXzLfWqe+YE0ZXBkQi72/slw==
X-Received: by 2002:a05:6512:401b:b0:598:fabf:afc2 with SMTP id 2adb3069b0e04-59a17d77697mr15522207e87.14.1767472348240;
        Sat, 03 Jan 2026 12:32:28 -0800 (PST)
Received: from localhost (parmesan.int.kasm.eu. [2001:678:a5c:1204:126f:f00a:513f:807b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59a185ddc12sm13314957e87.37.2026.01.03.12.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jan 2026 12:32:27 -0800 (PST)
Date: Sat, 3 Jan 2026 21:32:26 +0100
From: Klara Modin <klarasmodin@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Shi <alexs@kernel.org>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Andreas Larsson <andreas@gaisler.com>, 
	Borislav Petkov <bp@alien8.de>, Brian Cain <bcain@kernel.org>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	"David S. Miller" <davem@davemloft.net>, Dave Hansen <dave.hansen@linux.intel.com>, 
	David Hildenbrand <david@kernel.org>, Dinh Nguyen <dinguyen@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Guo Ren <guoren@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, 
	Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Johannes Berg <johannes@sipsolutions.net>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Magnus Lindholm <linmag7@gmail.com>, Matt Turner <mattst88@gmail.com>, 
	Max Filippov <jcmvbkbc@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Richard Weinberger <richard@nod.at>, Russell King <linux@armlinux.org.uk>, 
	Stafford Horne <shorne@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Thomas Gleixner <tglx@linutronix.de>, 
	Vasily Gorbik <gor@linux.ibm.com>, Vineet Gupta <vgupta@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>, x86@kernel.org, 
	linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org, 
	linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
	linux-mm@kvack.org, linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-snps-arc@lists.infradead.org, linux-um@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	loongarch@lists.linux.dev, sparclinux@vger.kernel.org
Subject: Re: [PATCH v2 22/28] arch, mm: consolidate initialization of nodes,
 zones and memory map
Message-ID: <aVlwOyicOLPB9SOa@parmesan.int.kasm.eu>
References: <20260102070005.65328-1-rppt@kernel.org>
 <20260102070005.65328-23-rppt@kernel.org>
 <aVhN2NgQEKe0yzva@soda.int.kasm.eu>
 <aVll339wim7dCIaQ@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVll339wim7dCIaQ@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 9AC5B140011
X-Rspamd-Server: rspam10
X-Stat-Signature: wd598mspcb9ssyygn31txutc1rxiq185
X-HE-Tag: 1767472350-303664
X-HE-Meta: U2FsdGVkX1+HDw50Ug+5FxZ6XCeMbPI9wOOcM8RRgSSsbInMyQSB1cvaUQTOTDRkqtBsNU4Q97RZB6GPZAnhUA9gbiq/aHX4E5adGpZZKHkplFAFZr+DgHwvLLt27G/JTTYauDEa0P/YKlmrDuI+rOeO+GmqH9txoxUOAPmIzZx7PyTvYyU8pmKRADhVNkqBz81XT3dQ74MIPSSsycBuDZns8H1mImGViWSPaiiAllYXwPl8LjjAmFDhrVgjBzPm9g/qI4PSzZz7R7VATUrRZ27Ekx6RAA92zPCjeqPKteSuqlKZ44aefddGhhsVrz9faNKjoTSYp6n4Mp6/mNYBv0CUa+rnQ1CFwkaND/UyIS1tHs33J52XV/ogxoUd01c2nYmFWIJ35SLy4YrP9Z5nL3iyNs0EENwAKzfzlVFmsDzLPQLSAWTmSN21DkgUnBi3hfgk62IE0Ot/8kO2XNSnnhI+AEKs3hcPI59hYXORm6Dsubh8CkgoSgqfBGRmLXxGjqCphbOwAplxKpaoQbE8jG5QQFB5NJzMILdPGZW87wUqxdEZAqkw+s8RUzcCi1DWQPYAukWvTkON9oml99329Pb4HXFLXAg6esgK1++eOfmbt4UJxnjJlbX3fg2lJMTqqFwSNK+DD0pJeFxAE7gCdRmWu0dGFDd4KpsL+rv9w15AekO721lrUhWZ0GSr6wtGSAHDJS1di+Eax7KntXEGLUEy4hzR62JPYW5OjnFkxGIO0dHvE1YF7NCGw1Qzypfr18BSVUPvd0rXEMOLv1AnbUlQFhaq4khwbOrBP8sN0p769we+TjSXMviHxr25bHYjkUH4mL9IIE56NmokxKoONvthm+lDOPF1Ifr9v3J9apNu1ck35ljObbgJOQXUnne50w1CsrTEStqWDc6YUKYSNG2jkt7vBkGxkRQrFoDtGiGCE2Te39lcDziA6SZCi42knG6sTEi54YtlxIOCUlg
 Qz/F+EGu
 Yjw5PgNwMzLcfmbg+sPi9sF+l0uNdYt6fmF0ULyOUkhfjQuZf9uakBl8NSkJdOKP022YNhUiDWrf1syAFGh/wtkKFwl+wDgIuhGeMfRIoPPDGJEXnPMJnp1kXGeAQnJmBTC1kpde2cvmH5ifNiHURyNmna+kxd4823SdRyYt/52B0ath6Dztpu1NYlOE7qa/OlpvO2pdQpmE/zIy9oFbYK5zitUbOX9Zzgp3wmwWp55XYSpuIEbhavDJ2jex+lOg0iks/QEqTbG2c7lltjQbf86fGiC1fZHMYTgJuJldMfbiCUdbW4jicwwcd39u3hhfQVDKoNnfUTzAf0VH0fJ8SQBVMC9ujsA9/HGTwPFIuPpuTbS8c3+uCmCczm1OErJmu6VFmClm6a78o0YyMtCE83ug1PO6X6YBFTE1AF3PgY6jc11uZGNq0bzD4oG/K4+YapqjiVLo2txthqjbrhkprta495WRtLjUNCBnZ1SK3X2CFdmpgdERBXO5YYbXGWhDYigjhYV1okBXu/7ykNC9emM3/aQNT0MZjougu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 2026-01-03 20:54:23 +0200, Mike Rapoport wrote:
> Hi,
> 
> On Sat, Jan 03, 2026 at 12:33:29AM +0100, Klara Modin wrote:
> > On 2026-01-02 08:59:58 +0200, Mike Rapoport wrote:
> > > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > > 
> > > To initialize node, zone and memory map data structures every architecture
> > > calls free_area_init() during setup_arch() and passes it an array of zone
> > > limits.
> > > 
> > > Beside code duplication it creates "interesting" ordering cases between
> > > allocation and initialization of hugetlb and the memory map. Some
> > > architectures allocate hugetlb pages very early in setup_arch() in certain
> > > cases, some only create hugetlb CMA areas in setup_arch() and sometimes
> > > hugetlb allocations happen mm_core_init().
> > > 
> > > With arch_zone_limits_init() helper available now on all architectures it
> > > is no longer necessary to call free_area_init() from architecture setup
> > > code. Rather core MM initialization can call arch_zone_limits_init() in a
> > > single place.
> > > 
> > > This allows to unify ordering of hugetlb vs memory map allocation and
> > > initialization.
> > > 
> > > Remove the call to free_area_init() from architecture specific code and
> > > place it in a new mm_core_init_early() function that is called immediately
> > > after setup_arch().
> > > 
> > > After this refactoring it is possible to consolidate hugetlb allocations
> > > and eliminate differences in ordering of hugetlb and memory map
> > > initialization among different architectures.
> > > 
> > > As the first step of this consolidation move hugetlb_bootmem_alloc() to
> > > mm_core_early_init().
> > > 
> > > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > 
> > This breaks boot on my Raspberry Pi 1. The reason seems to be the use of
> > page_folio() when initializing the dynamically allocated zero page in
> > arm, which doesn't work when free_area_init() hasn't been called yet.
> 
> I believe the reason is rather the use of virt_to_phys() that now happens
> before the memory map is ready.
> 

Right, that makes sense, the fault just becomes apparent when
page_folio() is called on some bogus address then?

> > The following oopses are generated:
> > 
> >  8<--- cut here ---
> >  Unable to handle kernel paging request at virtual address 003dfb44 when read
> >  [003dfb44] *pgd=00000000
> >  Internal error: Oops: 5 [#1] ARM
> >  CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.19.0-rc3-03898-g7975b0084358 #451 NONE
> >  Hardware name: BCM2835
> >  PC is at paging_init (include/linux/page-flags.h:284 (discriminator 2) arch/arm/mm/mmu.c:1790 (discriminator 2))
> >  LR is at paging_init (arch/arm/mm/mmu.c:1789 (discriminator 1))
> 
> ...
> 
> >  8<--- cut here ---
> > 
> > and the second one repeats for some time afterwards.
> > 
> > I experimented a little by allocating the zero page statically as many
> > other arches do which fixes the issue as it does not need to be
> > initialized at this point anymore, though I have no idea if that's
> > appropriate.
> 
> Do you mean putting the zero in the BSS like, e.g. arm64? I don't see a
> reason why this shouldn't work.
> 

Yes, exactly that. The diff I had was:

diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 86378eec7757..6fa9acd6a7f5 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -15,8 +15,8 @@
  * ZERO_PAGE is a global shared page that is always zero: used
  * for zero-mapped memory areas etc..
  */
-extern struct page *empty_zero_page;
-#define ZERO_PAGE(vaddr)	(empty_zero_page)
+extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
+#define ZERO_PAGE(vaddr)	(virt_to_page(empty_zero_page))
 #endif
 
 #include <asm-generic/pgtable-nopud.h>
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 8bac96e205ac..518def8314e7 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -45,7 +45,7 @@ extern unsigned long __atags_pointer;
  * empty_zero_page is a special page that is used for
  * zero-initialized data and COW.
  */
-struct page *empty_zero_page;
+unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)] __page_aligned_bss;
 EXPORT_SYMBOL(empty_zero_page);
 
 /*
@@ -1754,8 +1754,6 @@ static void __init early_fixmap_shutdown(void)
  */
 void __init paging_init(const struct machine_desc *mdesc)
 {
-	void *zero_page;
-
 #ifdef CONFIG_XIP_KERNEL
 	/* Store the kernel RW RAM region start/end in these variables */
 	kernel_sec_start = CONFIG_PHYS_OFFSET & SECTION_MASK;
@@ -1781,13 +1779,7 @@ void __init paging_init(const struct machine_desc *mdesc)
 
 	top_pmd = pmd_off_k(0xffff0000);
 
-	/* allocate the zero page. */
-	zero_page = early_alloc(PAGE_SIZE);
-
 	bootmem_init();
-
-	empty_zero_page = virt_to_page(zero_page);
-	__flush_dcache_folio(NULL, page_folio(empty_zero_page));
 }
 
 void __init early_mm_init(const struct machine_desc *mdesc)
diff --git a/arch/arm/mm/nommu.c b/arch/arm/mm/nommu.c
index d638cc87807e..7e42d8accec6 100644
--- a/arch/arm/mm/nommu.c
+++ b/arch/arm/mm/nommu.c
@@ -31,7 +31,7 @@ unsigned long vectors_base;
  * empty_zero_page is a special page that is used for
  * zero-initialized data and COW.
  */
-struct page *empty_zero_page;
+unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)] __page_aligned_bss;
 EXPORT_SYMBOL(empty_zero_page);
 
 #ifdef CONFIG_ARM_MPU
@@ -156,18 +156,10 @@ void __init adjust_lowmem_bounds(void)
  */
 void __init paging_init(const struct machine_desc *mdesc)
 {
-	void *zero_page;
-
 	early_trap_init((void *)vectors_base);
 	mpu_setup();
 
-	/* allocate the zero page. */
-	zero_page = (void *)memblock_alloc_or_panic(PAGE_SIZE, PAGE_SIZE);
-
 	bootmem_init();
-
-	empty_zero_page = virt_to_page(zero_page);
-	flush_dcache_page(empty_zero_page);
 }
 
 /*

> I also have a patch with some minor changes that still keeps
> empty_zero_page allocated, but avoids virt_to_page() and folio_page()
> dance. Can you please test it in your setup?
> 
> From 8a213c13211106d592fbe96b68ee29879ed739f8 Mon Sep 17 00:00:00 2001
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> Date: Sat, 3 Jan 2026 20:40:09 +0200
> Subject: [PATCH] arm: make initialization of zero page independent of the
>  memory map
> 
> Unlike most architectures, arm keeps a struct page pointer to the
> empty_zero_page and to initialize it requires conversion of a virtual
> address to page which makes it necessary to have memory map initialized
> before creating the empty_zero_page.
> 
> Make empty_zero_page a void * to decouple it's initialization from the
> initialization of the memory map.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  arch/arm/include/asm/pgtable.h |  4 ++--
>  arch/arm/mm/mmu.c              | 10 +++-------
>  arch/arm/mm/nommu.c            | 10 +++-------
>  3 files changed, 8 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
> index 86378eec7757..08bbd2aed6c9 100644
> --- a/arch/arm/include/asm/pgtable.h
> +++ b/arch/arm/include/asm/pgtable.h
> @@ -15,8 +15,8 @@
>   * ZERO_PAGE is a global shared page that is always zero: used
>   * for zero-mapped memory areas etc..
>   */
> -extern struct page *empty_zero_page;
> -#define ZERO_PAGE(vaddr)	(empty_zero_page)
> +extern void *empty_zero_page;
> +#define ZERO_PAGE(vaddr)	(virt_to_page(empty_zero_page))
>  #endif
>  
>  #include <asm-generic/pgtable-nopud.h>
> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> index 8bac96e205ac..867258f1ae09 100644
> --- a/arch/arm/mm/mmu.c
> +++ b/arch/arm/mm/mmu.c
> @@ -45,7 +45,7 @@ extern unsigned long __atags_pointer;
>   * empty_zero_page is a special page that is used for
>   * zero-initialized data and COW.
>   */
> -struct page *empty_zero_page;
> +void *empty_zero_page;
>  EXPORT_SYMBOL(empty_zero_page);
>  
>  /*
> @@ -1754,8 +1754,6 @@ static void __init early_fixmap_shutdown(void)
>   */
>  void __init paging_init(const struct machine_desc *mdesc)
>  {
> -	void *zero_page;
> -
>  #ifdef CONFIG_XIP_KERNEL
>  	/* Store the kernel RW RAM region start/end in these variables */
>  	kernel_sec_start = CONFIG_PHYS_OFFSET & SECTION_MASK;
> @@ -1782,12 +1780,10 @@ void __init paging_init(const struct machine_desc *mdesc)
>  	top_pmd = pmd_off_k(0xffff0000);
>  
>  	/* allocate the zero page. */
> -	zero_page = early_alloc(PAGE_SIZE);
> +	empty_zero_page = early_alloc(PAGE_SIZE);
> +	__cpuc_flush_dcache_area(empty_zero_page, PAGE_SIZE);
>  
>  	bootmem_init();
> -
> -	empty_zero_page = virt_to_page(zero_page);
> -	__flush_dcache_folio(NULL, page_folio(empty_zero_page));
>  }
>  
>  void __init early_mm_init(const struct machine_desc *mdesc)
> diff --git a/arch/arm/mm/nommu.c b/arch/arm/mm/nommu.c
> index d638cc87807e..f80ff5a69fbb 100644
> --- a/arch/arm/mm/nommu.c
> +++ b/arch/arm/mm/nommu.c
> @@ -31,7 +31,7 @@ unsigned long vectors_base;
>   * empty_zero_page is a special page that is used for
>   * zero-initialized data and COW.
>   */
> -struct page *empty_zero_page;
> +void *empty_zero_page;
>  EXPORT_SYMBOL(empty_zero_page);
>  
>  #ifdef CONFIG_ARM_MPU
> @@ -156,18 +156,14 @@ void __init adjust_lowmem_bounds(void)
>   */
>  void __init paging_init(const struct machine_desc *mdesc)
>  {
> -	void *zero_page;
> -
>  	early_trap_init((void *)vectors_base);
>  	mpu_setup();
>  
>  	/* allocate the zero page. */
> -	zero_page = (void *)memblock_alloc_or_panic(PAGE_SIZE, PAGE_SIZE);
> +	empty_zero_page = memblock_alloc_or_panic(PAGE_SIZE, PAGE_SIZE);
> +	__cpuc_flush_dcache_area(empty_zero_page, PAGE_SIZE);
>  
>  	bootmem_init();
> -
> -	empty_zero_page = virt_to_page(zero_page);
> -	flush_dcache_page(empty_zero_page);
>  }
>  
>  /*
> -- 
> 2.51.0
> 

This also works for me.

Thanks,
Tested-by: Klara Modin <klarasmodin@gmail.com>

>  
> > Regards,
> > Klara Modin
> > 
> 
> -- 
> Sincerely yours,
> Mike.


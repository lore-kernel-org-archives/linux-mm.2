Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E493FFA3727
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 23:33:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 040E26B0088; Fri,  2 Jan 2026 18:33:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F31B26B0089; Fri,  2 Jan 2026 18:33:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2F4D6B008A; Fri,  2 Jan 2026 18:33:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CE60F6B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 18:33:35 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D61778DAC0
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 23:33:34 +0000 (UTC)
X-FDA: 84288627948.08.2787214
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id DA19DC0003
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 23:33:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WnBoNwtj;
	spf=pass (imf28.hostedemail.com: domain of klarasmodin@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767396813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7oJkD+3I1ySqG2dU6TJV84R7uGtBSIJL6aFjqNNbCRs=;
	b=FZ14td0gDYctEDA9M0tVs3n74CtfDYbgkWQEAvOV9gsP+hZCwiBEu/WhLk9LOwEV/uUouA
	JzkVExqissfgBRqOXU+pUQDF6hdfVkkAt6oQ26fHjB89nIDcqzRnTwPjKDfd2FsP8l6f8Q
	KeTkazPUDBNEPV86GP6vLpKYVeTOSZQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WnBoNwtj;
	spf=pass (imf28.hostedemail.com: domain of klarasmodin@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767396813; a=rsa-sha256;
	cv=none;
	b=eOikghRJDPjqrIhMznV0qrYTbif1dqMd1E/hMzIlx9YBBmDO4dxW23gMT9xU5xIjMHcotO
	NHFmiXMHvJAe4kNdUWs3n4mICxYuOenKYKMeDSzKwtUz1WbAPDEptiZpaSvIrR+jXR101/
	5Bgq8Hhvns4bU9fml4JDvsiSzbqQYEI=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-594330147efso14532631e87.2
        for <linux-mm@kvack.org>; Fri, 02 Jan 2026 15:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767396811; x=1768001611; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7oJkD+3I1ySqG2dU6TJV84R7uGtBSIJL6aFjqNNbCRs=;
        b=WnBoNwtjzynD9/bAajaI3jsF7jslrhfuOxKjcGD1aMRJSdqvD6QdtBTggmksU8gOJj
         zz3g3MVlRoKn5H0bAH36O5JT/Gr9G2JZ0O0LQM1WeLjTFddmsSmjqz9asvni2+NFetYQ
         XCY/ACMtLmQP/6Db0NIXyUEZBiQf19tWCpvR430iq3b21SLkrMdKtuxsmoF7vpIa/Vul
         wv7aNuCFNcs4pbEhgfca+UN15zw8lcX6SM774LN1bzQJ7/c5cHJ52E/Xm8wD2gXmC1/z
         mQ4G8zbOsQeVLHc8W8eocODpckOME3o+zEVjgwMo+4IZcruFkm9xL5/4F1JJXVMuGsp5
         wtPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767396811; x=1768001611;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7oJkD+3I1ySqG2dU6TJV84R7uGtBSIJL6aFjqNNbCRs=;
        b=GR/fyC2hf6A+ohNCr2yK+H0tol+V+MHH8aldDNBlKqga3Kf+6LzfQkZS1Bla8s/7vn
         ItrOZ5EKwhV0K0KZbwDxUJXK5dNi+DNrxjbxEfIF1DX8cq6EyhfTPMUfgd8nREQdj8yJ
         hGsz3mjQblRSjsof4aw55HhR9l2RtqjH6L9WvPmhOP3XVZu/Z7P9MWxaxSeCXZZAVDoB
         dwDzoIlp4hZSqM2AGty2RcOsZXB/C/EVmAIQZB4j1iZzEqXDE+jrnQfdgenGLqH5WbNd
         09toLvrroiE0jTsPcM9DFbZz32RW2lmKxd7XaUHAMFVwT44CkiHra+owniSz9oGqjgeu
         CSsA==
X-Forwarded-Encrypted: i=1; AJvYcCWxAdWXQCfr/RGz7iMdbJ+LN60HuckHQZI8JGA/rft8GI6Yxkrt1TVF/N+NTd4fmzVkPaQVJKp3Dg==@kvack.org
X-Gm-Message-State: AOJu0YyqhllIcFXdB1h7hZnC0VqP3CRk6dhuAhMQs/m/Uy7DIHKxhICP
	zcZQ9vIrN//vR/Zo2aLj4YGBUHsaePsSU0mTWJAky+eOkIut66ppOfaM
X-Gm-Gg: AY/fxX6fgECDUydki5OLQJwBk6ixAeD5a6u82LakB3flAibruxvkbNtyrgmEdNm9SkJ
	z2nRytJTrRoZaSQJvdDIQ4Pez3BAdIfdykzvJeYX3J+How6pfXfTbBF4q0Jl60WZXh5SIoUo5ok
	DeUskghYTrnsJ81JFrpNubRQYPpxsghQeSkNbmDbglct5y6f6ngi9a4S4Qrxj7EthkKXqlgyof6
	ISKcgsWD8QUYL+YGK5MTu2AiYoEOG4Bbyzg/aZnLZXA2IC2E1GNWf/AT98Zfq3KriqEufv1H26T
	XFJR3pctWh1H15cq+J691H24uq+N/sLwNah+apMjHoz3DbHFKT7SK81Og+NXZqi+ya3qQ8CLpTb
	aQzPXLgjFJdZx/5tlLuJPRApQ8UAHwNCw+z5nsLnJy8FK5gW6EeF6FqIUrcbBNd1Wz/n7gGFTJU
	muOm+vAhJVXh6SMKsmoaeX4OCc
X-Google-Smtp-Source: AGHT+IH2H1z9QVIhTu3A3MPtZYT5DDmpE6MbcXNtDvemf/egyv4QEgcDqeHHJdIO1qKRKt95zoj43Q==
X-Received: by 2002:ac2:4e08:0:b0:594:93b8:88b6 with SMTP id 2adb3069b0e04-59a17db705bmr11802619e87.38.1767396810454;
        Fri, 02 Jan 2026 15:33:30 -0800 (PST)
Received: from localhost (soda.int.kasm.eu. [2001:678:a5c:1202:4fb5:f16a:579c:6dcb])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59a185ea248sm12368060e87.43.2026.01.02.15.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jan 2026 15:33:29 -0800 (PST)
Date: Sat, 3 Jan 2026 00:33:29 +0100
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
Message-ID: <aVhN2NgQEKe0yzva@soda.int.kasm.eu>
References: <20260102070005.65328-1-rppt@kernel.org>
 <20260102070005.65328-23-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260102070005.65328-23-rppt@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DA19DC0003
X-Stat-Signature: s3pj1zexsoipy4ncdpxbd6x3srwt4bde
X-Rspam-User: 
X-HE-Tag: 1767396812-269562
X-HE-Meta: U2FsdGVkX1+4puuu4QSZ5OibmIQJd8uQITe1ui8dkGmP5NttWEp2kAk+E3V3WtKNlsg/5EzcrQpByUXu3QsVVsq5SW1KhMj7GwHSMEfaPSaWqhbuDgOdMwZbNu8wkmBi0+Cfxyo67BJnV7FRuJXrYrXbOHjJxN1muxDR9NXgYhcROaZA5ndQmP8egFmx92MZp3FH3KLq9eKO8YRDlzk8FqSEVfK95sjNzqgUkHAcIeRsNPIh5qblTG8c92LHpCJa8i+p1c5FsV2HHtCgyVPKh0X0QPMIMRN3gEN6WUKmgGV0LCjdR7vMvUOvgpu1955NBe6Ghx4IbJyRNlrSWWqAtarZLj4u7uAcvJ8VdsxuNgZ5ecjweLcOswO8G7C5h5oYh936Qo1hMA0JTKxFuEPORU1p9fCCBZTUq4Ha35MmMy+60VP4y3ohcVYv9pn7PQKG6GuEhUKzWn3UmGxMtRYsdLpjcJC6AInpGZjYC7RWYiyEHSflfHYmhIjSa/6oZp0tNvc9Q3DpH1B6rH44N80vArcrvenCJft000BuqaPQQPSDns4y/QgetU6LGOYliYxPsdpSJLWnvGBDbPL0kz0pEtyYuRWxQVEIylmI5vBEYj1ysNk6vsTEDHlzcdLKr6RrrZ2bebE7NBeubAFNu1+STYfoN3S506hUJ/J/hIEoApar/c1WdUH8i9VI82KaR5pef1Jumv6hC3V78ST08Clf9Xj3tLgH20ZLVD8ilmm4gLKVBERIGY+WYUP8y1aIMDhjfrBOFLTAbprXfrDpdfkAsu+cDeE7KZAihTwSApOApdFyyem52tOz852lE3+RefWmBMIry50YTR+ARgHa1NXwO7Flfz16CX0Uln6ws+39UPcmGk+JH6RknnJDC99bBxrY1mlWofa8Cv1JlgM6KXjwwVdZznr5zjh/dfOmWH03Ws297Gog897x1wDKXeErQHyNQFjScV/QfUQsP+EphOZ
 c+9E5lIw
 WrZKJOx/vghU6Rj2C+uyn4jtIZTfCcJ5JV1v60dCT/09HNKcA/Mcmv8oXiUDQOxkwtHM/GfXUYDPQm3ggmAMmLFvS3xaYf+eh7BGBNkZy1HidQhnByZFN/Az3d2taxJjq1bNdzuERrqJEfOhyXfSrLsZqKf4zTbJsCoCT6Yx2eA9628wtUFosc76/0L5SOtCVeudF1rdntQ6qr1+rCTfTgwia2ZOBAXlKsJh/RZ/5+x+9VteicEsM7lDx09cwytP5Q94a3bPVQJH1wE9soig7O9pw+o8NIVdyesDWP8CunJUHQ/4t4lIOZD7ZBc2RDCLEPYRVpVGg+sWnVjeOS8zC0ysK/OyQRLW3xpS0qGKi6Ks1DRG6dSutKICfvalif2/iDapYqOFMzoQa7Q542kJ1yAxErFWfF6mZ2t5HdML8bhi6Ijf094XeiApqJSoNeIOsdja3ew6mjLk8vm0dRx/CiSaIocYTMeIm+nxqnBXVyJgipMnKjfcPa6lUbN2RD2gVZckxBo4OAYI1VMYCV4nAJjE5fzNVWbrzjwWUVUXlwauG29OXV+hGFwTix8ec9pNnJNah
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 2026-01-02 08:59:58 +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> To initialize node, zone and memory map data structures every architecture
> calls free_area_init() during setup_arch() and passes it an array of zone
> limits.
> 
> Beside code duplication it creates "interesting" ordering cases between
> allocation and initialization of hugetlb and the memory map. Some
> architectures allocate hugetlb pages very early in setup_arch() in certain
> cases, some only create hugetlb CMA areas in setup_arch() and sometimes
> hugetlb allocations happen mm_core_init().
> 
> With arch_zone_limits_init() helper available now on all architectures it
> is no longer necessary to call free_area_init() from architecture setup
> code. Rather core MM initialization can call arch_zone_limits_init() in a
> single place.
> 
> This allows to unify ordering of hugetlb vs memory map allocation and
> initialization.
> 
> Remove the call to free_area_init() from architecture specific code and
> place it in a new mm_core_init_early() function that is called immediately
> after setup_arch().
> 
> After this refactoring it is possible to consolidate hugetlb allocations
> and eliminate differences in ordering of hugetlb and memory map
> initialization among different architectures.
> 
> As the first step of this consolidation move hugetlb_bootmem_alloc() to
> mm_core_early_init().
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

This breaks boot on my Raspberry Pi 1. The reason seems to be the use of
page_folio() when initializing the dynamically allocated zero page in
arm, which doesn't work when free_area_init() hasn't been called yet.

The following oopses are generated:

 Booting Linux on physical CPU 0x0
 Linux version 6.19.0-rc3-03898-g7975b0084358 (klara@soda.int.kasm.eu) (armv6j-unknown-linux-gnueabihf-gcc (Gentoo 15.2.1_p20251122 p3) 15.2.1 20251122, GNU ld (Gentoo 2.45.1 p1) 2.45.1) #451 Fri Jan  2 20:26:00 CET 2026
 CPU: ARMv6-compatible processor [410fb767] revision 7 (ARMv7), cr=00c5387d
 CPU: PIPT / VIPT nonaliasing data cache, VIPT nonaliasing instruction cache
 OF: fdt: Machine model: Raspberry Pi Model B Rev 2
 earlycon: pl11 at MMIO32 0x20201000 (options '')
 printk: legacy bootconsole [pl11] enabled
 Memory policy: Data cache writeback
 Reserved memory: created CMA memory pool at 0x19400000, size 64 MiB
 OF: reserved mem: initialized node linux,cma, compatible id shared-dma-pool
 OF: reserved mem: 0x19400000..0x1d3fffff (65536 KiB) map reusable linux,cma
 8<--- cut here ---
 Unable to handle kernel paging request at virtual address 003dfb44 when read
 [003dfb44] *pgd=00000000
 Internal error: Oops: 5 [#1] ARM
 CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.19.0-rc3-03898-g7975b0084358 #451 NONE
 Hardware name: BCM2835
 PC is at paging_init (include/linux/page-flags.h:284 (discriminator 2) arch/arm/mm/mmu.c:1790 (discriminator 2))
 LR is at paging_init (arch/arm/mm/mmu.c:1789 (discriminator 1))
 pc :    lr :    psr: 600000d3
 sp : c0d01ef8  ip : defdb000  fp : 0000000b
 r10: 00200000  r9 : d9400000  r8 : ffe00000
 r7 : c0d09050  r6 : c0d0902c  r5 : c0d43d40  r4 : 0001efda
 r3 : c0dab20c  r2 : 00000000  r1 : 003dfb40  r0 : 00000000
 Flags: nZCv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment none
 Control: 00c5387d  Table: 00004008  DAC: 00000051
 Register r0 information: NULL pointer
 Register r1 information: non-paged memory
 Register r2 information: NULL pointer
 Register r3 information:
 8<--- cut here ---
 Unable to handle kernel paging request at virtual address 0001b564 when read
 [0001b564] *pgd=00000000
 Internal error: Oops: 5 [#2] ARM
 CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.19.0-rc3-03898-g7975b0084358 #451 NONE
 Hardware name: BCM2835
 PC is at kmem_dump_obj (mm/slab.h:142 (discriminator 2) mm/slab.h:178 (discriminator 2) mm/slab_common.c:609 (discriminator 2))
 LR is at 0x1
 pc :    lr :    psr: 200001d3
 sp : c0d01cc8  ip : 00000000  fp : 0000000b
 r10: 00200000  r9 : c0dab1dc  r8 : 00000000
 r7 : 00000005  r6 : 00000dab  r5 : 0001b560  r4 : c0dab20c
 r3 : c0dc2058  r2 : 1f000000  r1 : 00c00000  r0 : 00000001
 Flags: nzCv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment none
 Control: 00c5387d  Table: 00004008  DAC: 00000051
 Register r0 information: non-paged memory
 Register r1 information: non-paged memory
 Register r2 information: non-paged memory
 Register r3 information:
 8<--- cut here ---

and the second one repeats for some time afterwards.

I experimented a little by allocating the zero page statically as many
other arches do which fixes the issue as it does not need to be
initialized at this point anymore, though I have no idea if that's
appropriate.

Regards,
Klara Modin

...

> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> index bdcc3639681f..a8f7b4084715 100644
> --- a/arch/arm/mm/init.c
> +++ b/arch/arm/mm/init.c
> @@ -118,15 +118,6 @@ void __init arch_zone_limits_init(unsigned long *max_zone_pfn)
>  #endif
>  }
>  
> -static void __init zone_sizes_init(unsigned long min, unsigned long max_low,
> -	unsigned long max_high)
> -{
> -	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
> -
> -	arch_zone_limits_init(max_zone_pfn);
> -	free_area_init(max_zone_pfn);
> -}
> -
>  #ifdef CONFIG_HAVE_ARCH_PFN_VALID
>  int pfn_valid(unsigned long pfn)
>  {
> @@ -222,13 +213,6 @@ void __init bootmem_init(void)
>  	 * done after the fixed reservations
>  	 */
>  	sparse_init();
> -
> -	/*
> -	 * Now free the memory - free_area_init needs
> -	 * the sparse mem_map arrays initialized by sparse_init()
> -	 * for memmap_init_zone(), otherwise all PFNs are invalid.
> -	 */
> -	zone_sizes_init(min_low_pfn, max_low_pfn, max_pfn);
>  }
>  
>  /*

...

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 628c0e0ac313..64d6f9c15ef1 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -45,6 +45,7 @@ struct pt_regs;
>  struct folio_batch;
>  
>  void arch_mm_preinit(void);
> +void mm_core_init_early(void);
>  void mm_core_init(void);
>  void init_mm_internals(void);
>  
> @@ -3536,7 +3537,7 @@ static inline unsigned long get_num_physpages(void)
>  }
>  
>  /*
> - * Using memblock node mappings, an architecture may initialise its
> + * FIXME: Using memblock node mappings, an architecture may initialise its
>   * zones, allocate the backing mem_map and account for memory holes in an
>   * architecture independent manner.
>   *
> @@ -3551,7 +3552,6 @@ static inline unsigned long get_num_physpages(void)
>   *	memblock_add_node(base, size, nid, MEMBLOCK_NONE)
>   * free_area_init(max_zone_pfns);
>   */
> -void free_area_init(unsigned long *max_zone_pfn);
>  void arch_zone_limits_init(unsigned long *max_zone_pfn);
>  unsigned long node_map_pfn_alignment(void);
>  extern unsigned long absent_pages_in_range(unsigned long start_pfn,
> diff --git a/init/main.c b/init/main.c
> index b84818ad9685..445b5643ecec 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -1025,6 +1025,7 @@ void start_kernel(void)
>  	page_address_init();
>  	pr_notice("%s", linux_banner);
>  	setup_arch(&command_line);
> +	mm_core_init_early();
>  	/* Static keys and static calls are needed by LSMs */
>  	jump_label_init();
>  	static_call_init();
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index fc2a6f1e518f..ffc4a0f1fee9 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1810,7 +1810,6 @@ static void __init set_high_memory(void)
>  
>  /**
>   * free_area_init - Initialise all pg_data_t and zone data
> - * @max_zone_pfn: an array of max PFNs for each zone
>   *
>   * This will call free_area_init_node() for each active node in the system.
>   * Using the page ranges provided by memblock_set_node(), the size of each
> @@ -1821,17 +1820,14 @@ static void __init set_high_memory(void)
>   * starts where the previous one ended. For example, ZONE_DMA32 starts
>   * at arch_max_dma_pfn.
>   */
> -void __init free_area_init(unsigned long *max_zone_pfn)
> +static void __init free_area_init(void)
>  {
> +	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
>  	unsigned long start_pfn, end_pfn;
>  	int i, nid, zone;
>  	bool descending;
>  
> -	/* Record where the zone boundaries are */
> -	memset(arch_zone_lowest_possible_pfn, 0,
> -				sizeof(arch_zone_lowest_possible_pfn));
> -	memset(arch_zone_highest_possible_pfn, 0,
> -				sizeof(arch_zone_highest_possible_pfn));
> +	arch_zone_limits_init(max_zone_pfn);
>  
>  	start_pfn = PHYS_PFN(memblock_start_of_DRAM());
>  	descending = arch_has_descending_max_zone_pfns();
> @@ -2681,13 +2677,19 @@ void __init __weak mem_init(void)
>  {
>  }
>  
> +void __init mm_core_init_early(void)
> +{
> +	hugetlb_bootmem_alloc();
> +
> +	free_area_init();
> +}
> +
>  /*
>   * Set up kernel memory allocators
>   */
>  void __init mm_core_init(void)
>  {
>  	arch_mm_preinit();
> -	hugetlb_bootmem_alloc();
>  
>  	/* Initializations relying on SMP setup */
>  	BUILD_BUG_ON(MAX_ZONELISTS > 2);
> -- 
> 2.51.0
> 


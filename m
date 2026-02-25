Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0A3AEFD210
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 09:34:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B131C6B00C3; Wed, 25 Feb 2026 04:34:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABDB76B00C9; Wed, 25 Feb 2026 04:34:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97F056B00CD; Wed, 25 Feb 2026 04:34:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 858546B00C3
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 04:34:17 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 359271B6CBB
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:34:17 +0000 (UTC)
X-FDA: 84482468154.17.B92322C
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id 62736140011
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:34:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YCHEKnIB;
	spf=pass (imf09.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772012055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JxnsaOQZey5wMq56BxN2EdEuMBW71mGq+RSuzcss/8M=;
	b=4NsLrDxGoX8j5y4pZabwcAeXLVfB55K+lEsD6okGiX3XupCZ2AWpGYWsgBFD0nL35Qz1UA
	XXdYJqJx59RIuCgvZeXoC3Dv9BEeIZkP7DWYUtuwTiTayKJOdTN0wTQ+n94og/CtN9RxaH
	WDIy1p2A9oqeyc3AevCPsEY2EkaMXsM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YCHEKnIB;
	spf=pass (imf09.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772012055; a=rsa-sha256;
	cv=none;
	b=e2TGNPRna9mCKJ6N56qd9iEytj+nuu0yUpi+wdzQh7p5G5Y45CRT6t39LH3uhvORrVZosH
	5wzl/RjqaZetgLnkgydEYuFiZPpk5avg+0oQtPJ7fwnyW3xlCPz23Ho1nPUaMaNAZw3JIo
	D+r+0gNpXLdvwGcu/0jxsF4+XViseNo=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3590408a093so512453a91.2
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 01:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772012054; x=1772616854; darn=kvack.org;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=JxnsaOQZey5wMq56BxN2EdEuMBW71mGq+RSuzcss/8M=;
        b=YCHEKnIB6ijW+BBv8O/1l1bax5tdaMSQBaTwrog72IHSMOuGZdFf0ZnMHjoxw9mUpU
         9v1O2DAfVb5cwUwKbewZC0Swq6yUKQDZt1+xpOu+LtYeKoh9db1aPk/vx3K8yQ8jJXVC
         bMbAEjjm9XgiJ5yu5F5YswAvtruYRILJl1Lxs21VOrq6L6Ei6w5sXeVuPtOYcJKsO/E2
         5hnEHCXQoKB25VUQy0AdYqdKvgWuhrsM/isijyCdG7x7eKtNhDVP/DSq03h8hf71Rz11
         EoWVOgEv9966Aao9revAMBPJzV8SBmtdHn2O57N0WvMphu1qCtwc05RIXm9e+7uLYWCy
         X2Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772012054; x=1772616854;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JxnsaOQZey5wMq56BxN2EdEuMBW71mGq+RSuzcss/8M=;
        b=aV0L6xgyUsOb565SUqRpTwn8kD5aS5L+8Z7UkU2Jq3wb3nfJKBMDjLwhjewe2J33e6
         TtzHYwuVJttigDZTsr5Z0FVs3FxVjWrUUX9m2iJJaZX/PyBXH5OKlsJr0AYnBf+R5ZB5
         8/pLJ1fDVNrQVHihN5+JuKuV/V/LrroLnVtuPIKhzYxBzByO8LlL9TZFgmUVNYaVOA5g
         cFJK8L+x40XQ90SaqXi8pyQoWzf9TCjc6RysM8oiaAYn2d94q4t7/rAyUl5yXTD+WgU4
         oAjmfZDf5gqcAT/sh/IjkwKQNqrP2O2UZIeWm9FGrHqzX12K5TixUDDujjSyHt3Qahy+
         B2rA==
X-Forwarded-Encrypted: i=1; AJvYcCVU0XnJp6u3D8Iyq6vzUN0BwhRjAwfjAa3QBgqS51vfcPEnFvAKLnB9dTMZKzAbxVW2Q8SKYXxnpA==@kvack.org
X-Gm-Message-State: AOJu0YzJ7uCGzQGXoD1TmqPeDrtLqRL+ePBrMeL5dYxjFdlZoef1sKBY
	djRy684d086Ee6B1jJ10K3aqK3ppX2nKRYqkhmlSTMOnImZAJaY3tksS
X-Gm-Gg: ATEYQzxHWUtdEpz7LiSqKZI+keOOiJWsk21e/yqU1c2D8nXli+sq3e6THckzn7GQ24V
	K7GhfiXogfe3my9/tp/Q2FRSNyxEHJScKaEMdMvwlLQRIMNuh+u9ECaJp71pr9NH5Il/mMP7vgi
	m3+4askkpD0HegDmYgSEj8JT05UMZcF6A7JdmIc5gCRZyDC1x7vvvM2J+b8aT13LkLlEq/5VHht
	MAxDxZHFpm6jo15TSkG9U8ubVpvKibVi4ooWWg3mtzhpbaHJUWrdGhOuIULeVM9DEg9N5x1f1iq
	mYcGnmBt77vt4CikjwmBx3Y9FG6JDB2PBt7oYsJyJC9wF1Mz7p0uedHlt7/3KnQ90VT5I9/m0bw
	suTxMmotYW9C2Yp7g9RYnhC4nJUBefIZz1dkoWbWnliEa3z1akA/TwzoGa+/WQsKFrB0pFTqJUt
	84zVO4S3H/2VPnkUpnFA==
X-Received: by 2002:a17:90b:3dcc:b0:340:c60b:f362 with SMTP id 98e67ed59e1d1-358ae7c6ca9mr13087754a91.6.1772012054135;
        Wed, 25 Feb 2026 01:34:14 -0800 (PST)
Received: from dw-tp ([203.81.242.210])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3590188126esm2256635a91.6.2026.02.25.01.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 01:34:13 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Shi <alexs@kernel.org>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Andreas Larsson <andreas@gaisler.com>, Borislav Petkov <bp@alien8.de>, Brian Cain <bcain@kernel.org>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	"David S. Miller" <davem@davemloft.net>, Dave Hansen <dave.hansen@linux.intel.com>, 
	David Hildenbrand <david@kernel.org>, Dinh Nguyen <dinguyen@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Guo Ren <guoren@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Johannes Berg <johannes@sipsolutions.net>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Jonathan Corbet <corbet@lwn.net>, 
	Klara Modin <klarasmodin@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Magnus Lindholm <linmag7@gmail.com>, 
	Matt Turner <mattst88@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>, 
	Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Richard Weinberger <richard@nod.at>, 
	Russell King <linux@armlinux.org.uk>, Stafford Horne <shorne@gmail.com>, 
	Suren Baghdasaryan <surenb@google.com>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Thomas Gleixner <tglx@linutronix.de>, Vasily Gorbik <gor@linux.ibm.com>, Vineet Gupta <vgupta@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>, x86@kernel.org, 
	linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-csky@vger.kernel.org, linux-cxl@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
	linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-sh@vger.kernel.org, linux-snps-arc@lists.infradead.org, 
	linux-um@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	loongarch@lists.linux.dev, sparclinux@vger.kernel.org
Subject: Re: [PATCH v3 24/29] arch, mm: consolidate initialization of SPARSE memory model
In-Reply-To: <20260111082105.290734-25-rppt@kernel.org>
Date: Wed, 25 Feb 2026 09:00:35 +0530
Message-ID: <87tsv5h544.ritesh.list@gmail.com>
References: <20260111082105.290734-1-rppt@kernel.org> <20260111082105.290734-25-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 6cub7okam9y3j6eqh8dzsge6diwqag5x
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 62736140011
X-HE-Tag: 1772012055-265013
X-HE-Meta: U2FsdGVkX19Zr7ILU4EXK0cfPNGRO6N0lflYaqGpvcki+SXCZsR20me3756weJ9/uHO33ksdYDRgXHB27HsWgI9/V25J7C0c6DZlkyh24FHP5kYGsYdmGD+Orc2V1Tqljy7BKsB8UdfchWG68Zdwfuldy0mZr0tto5yYqSdcn6MIos2eu9R5H7Aw7FunsfJ+3KzDl5HZMVra0iiCFckCbpiI/Rs/8HkDke8nZMqRCUNX2OctonCDgHJ1TaAKWxHvsgv/SozXzEAfQNNtpulWebrxDplzeeRebii5FGlbddqcep029xy8P55NT8cW4I0E6+z/UDPSPq0YZTgVMo0VsC1XRQb/55/oypU2eLBsUw4wmE2COwkvvHXLLKxFXZVUKWOjHU2HUF3bYEURnYwfHXZPhjvISb7DN3g5pNKZ37XEOvDALsu6B7d9Ab7EIPrMgDI7VoUy6GgY1zU3YldlVGpj1Ssz9X8raOyDiJN0B0udABFfqdxHii0Ds3G3V0nMke4DKm+Yi9xBlk2CRNe1VmM0ysYzH5TxslYi6aa4TcUWNcT274uEE9JdqYVpUqTshHlu3nk+Q/25oUYRqIB8RXetan6+b3opFQUObQtUii3/O1kK7lyBDJuLsbuiCJPaYW88t3JONKigzXU+hYZtuGwGf0AJ6VqCgY/odt+YD1PaSSEQCEP8HP+MCSkG/4p57vvA3C3rzmiC13X9oq9+o5naT19h7fhYx+UXAaxLxLUcwqIpMHih0BgqXp9GMbsoVj6nqA3MXqUr84RPmw6V7JyUiPdlb/saTS5SOH9UGU+0l7hSH3JwRInN87wvv4Pd2gfEFg6K9KxyA0XEZH0gTvTMcmndjhOjfuRqBd88PQg+p9W//GZD3oN0qU/fwOq2TTnM4KFsIeGxKZ7p597vpAw1VYAWejn2q/01hR859z240ySaDVpGWBSJlydF4LjSXGNyD+gXCONdhq08nzk
 8oInDgik
 G6lfPk/yhzTKOnNbviyusLu1+5xD2jgDH0J4qlTCSxeKPaZAJaM4HI4EHy6/tS5J8fzNhAUqEejy1UTfGXx7+E7DjwcLizok0ie0xj5V8WEPKAWP2Hlcqhct1uo3qfGt3ezVd7gYfIQTRtBKFAczgtswGLgE/cnFucsR8yKESTheoJBdhr9B7qOFWaLrdKIHkG3m1Ci3iwCfeaVJyE/lhq3JvLGTvB8DFulJno2/xIDopHfqPftOXk5X2sgTQYeB365VZDQrH+PF8GBuD/if4MtjFuDM72aB8YCnjAWIepD19jX84qoCEdOZGrz01smveU+IrabDqwdWexvkEtnKTIj0Fjj4YMndw0bKCrOGXk8HhG9ETUvi9zTWLxpul5x6lweyQWkbeawASWK/lQFLkHUwOq7jjHdUrWyPdyRoYSej7voSfqWjyHGc05g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mike Rapoport <rppt@kernel.org> writes:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Every architecture calls sparse_init() during setup_arch() although the
> data structures created by sparse_init() are not used until the
> initialization of the core MM.
>
> Beside the code duplication, calling sparse_init() from architecture
> specific code causes ordering differences of vmemmap and HVO initialization
> on different architectures.
>
> Move the call to sparse_init() from architecture specific code to
> free_area_init() to ensure that vmemmap and HVO initialization order is
> always the same.
>

Hello Mike,

[    0.000000][    T0] ------------[ cut here ]------------
[    0.000000][    T0] WARNING: arch/powerpc/include/asm/io.h:879 at virt_to_phys+0x44/0x1b8, CPU#0: swapper/0
[    0.000000][    T0] Modules linked in:
[    0.000000][    T0] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.19.0-12139-gc57b1c00145a #31 PREEMPT
[    0.000000][    T0] Hardware name: IBM pSeries (emulated by qemu) POWER10 (architected) 0x801200 0xf000006 of:SLOF,git-ee03ae pSeries
[    0.000000][    T0] NIP:  c000000000601584 LR: c000000004075de4 CTR: c000000000601548
[    0.000000][    T0] REGS: c000000004d1f870 TRAP: 0700   Not tainted  (6.19.0-12139-gc57b1c00145a)
[    0.000000][    T0] MSR:  8000000000021033 <SF,ME,IR,DR,RI,LE>  CR: 48022448  XER: 20040000
[    0.000000][    T0] CFAR: c0000000006016c4 IRQMASK: 1
[    0.000000][    T0] GPR00: c000000004075dd4 c000000004d1fb10 c00000000304bb00 c000000180000000
[    0.000000][    T0] GPR04: 0000000000000009 0000000000000009 c000000004ec94a0 0000000000000000
[    0.000000][    T0] GPR08: 0000000000018000 0000000000000001 c000000004921280 0000000048022448
[    0.000000][    T0] GPR12: c000000000601548 c000000004fe0000 0000000000000004 0000000000000004
[    0.000000][    T0] GPR16: 000000000287fb08 0000000000000060 0000000000000002 0000000002831750
[    0.000000][    T0] GPR20: 0000000002831778 fffffffffffffffd c000000004d78050 00000000051cbb00
[    0.000000][    T0] GPR24: 0000000005a40008 c000000000000000 c000000000400000 0000000000000100
[    0.000000][    T0] GPR28: c000000004d78050 0000000000000000 c000000004ecd4a8 0000000000000001
[    0.000000][    T0] NIP [c000000000601584] virt_to_phys+0x44/0x1b8
[    0.000000][    T0] LR [c000000004075de4] alloc_bootmem+0x144/0x1a8
[    0.000000][    T0] Call Trace:
[    0.000000][    T0] [c000000004d1fb50] [c000000004075dd4] alloc_bootmem+0x134/0x1a8
[    0.000000][    T0] [c000000004d1fba0] [c000000004075fac] __alloc_bootmem_huge_page+0x164/0x230
[    0.000000][    T0] [c000000004d1fbe0] [c000000004030bc4] alloc_bootmem_huge_page+0x44/0x138
[    0.000000][    T0] [c000000004d1fc10] [c000000004076e48] hugetlb_hstate_alloc_pages+0x350/0x5ac
[    0.000000][    T0] [c000000004d1fd30] [c0000000040782f0] hugetlb_bootmem_alloc+0x15c/0x19c
[    0.000000][    T0] [c000000004d1fd70] [c00000000406d7b4] mm_core_init_early+0x7c/0xdf4
[    0.000000][    T0] [c000000004d1ff30] [c000000004011d84] start_kernel+0xac/0xc58
[    0.000000][    T0] [c000000004d1ffe0] [c00000000000e99c] start_here_common+0x1c/0x20
[    0.000000][    T0] Code: 6129ffff 792907c6 6529ffff 6129ffff 7c234840 40810018 3d2201e8 3929a7a8 e9290000 7c291840 41810044 3be00001 <0b1f0000> 3d20bfff 6129ffff 792907c6


I think this is happening because, now in mm_core_early_init(), the
order of initialization between hugetlb_bootmem_alloc() and
free_area_init() is reversed. Since free_area_init() -> sparse_init()
is responsible for setting SECTIONS and vmemmap area. 

Then in alloc_bootmem() (from hugetlb_bootmem_alloc() path), it uses virt_to_phys(m)...

			/*
			 * For pre-HVO to work correctly, pages need to be on
			 * the list for the node they were actually allocated
			 * from. That node may be different in the case of
			 * fallback by memblock_alloc_try_nid_raw. So,
			 * extract the actual node first.
			 */
			if (m)
				listnode = early_pfn_to_nid(PHYS_PFN(virt_to_phys(m)));


... virt_to_phys on powerpc uses:

static inline unsigned long virt_to_phys(const volatile void * address)
{
	WARN_ON(IS_ENABLED(CONFIG_DEBUG_VIRTUAL) && !virt_addr_valid(address));

	return __pa((unsigned long)address);
}

#define virt_addr_valid(vaddr)	({					\
	unsigned long _addr = (unsigned long)vaddr;			\
	_addr >= PAGE_OFFSET && _addr < (unsigned long)high_memory &&	\
	pfn_valid(virt_to_pfn((void *)_addr));				\
})


I think the above warning in dmesg gets printed from above WARN_ON, i.e.
because pfn_valid() is false, since we haven't done sparse_init() yet.

So, what I wanted to check was - do you think instead of virt_to_phys(), we
could directly use __pa() here() in mm/hugetlb.c, since these are
memblock alloc addresses? i.e.: 

// alloc_bootmem():
-   listnode = early_pfn_to_nid(PHYS_PFN(virt_to_phys(m)));
+   listnode = early_pfn_to_nid(PHYS_PFN(__pa(m)));

// __alloc_bootmem_huge_page():
-   memblock_reserved_mark_noinit(virt_to_phys((void *)m + PAGE_SIZE),
+   memblock_reserved_mark_noinit(__pa((void *)m + PAGE_SIZE),


Thoughts?

-ritesh


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 726D9C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 22:27:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 232056B0088; Tue,  1 Sep 2026 18:27:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E3106B008A; Tue,  1 Sep 2026 18:27:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DA346B0092; Tue,  1 Sep 2026 18:27:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E2FA16B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:27:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4BD5112053E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 22:27:23 +0000 (UTC)
X-FDA: 85166630766.03.E2E856C
Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
	by imf18.hostedemail.com (Postfix) with ESMTP id 547631C0006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 22:27:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of tsbogend@alpha.franken.de designates 193.175.24.41 as permitted sender) smtp.mailfrom=tsbogend@alpha.franken.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788301641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zae8tiSxXCtBNDL+lr61VCCw+KU4n2tutpFXky24SA8=;
	b=nOZH/JO3jYZR1lfnc/ifXa8AvtgBKmF8YWay2m1ZwsglD5Hbx5zj0sEYGbmTfgFMZJUm1F
	wyZm+N3eZm3PznhcSW/xrt+pABU7+qnl3H5S/mvrCB6Hx5qFbjfGCUqC/jeHeOrTGe7DeL
	yln5zSdh09+IxcN5m1fmfP7F+tcaKQ8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of tsbogend@alpha.franken.de designates 193.175.24.41 as permitted sender) smtp.mailfrom=tsbogend@alpha.franken.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788301641;
	b=uUPHtJpNFyn/dtyscragUWO1Ipmo2moDtR6Lw/rLYQ8uO5dLwYIOGt5cHi43FBbxL/5X4i
	0ow1EukqtU3QAD9objKCeMKHCflFS4bGyBfj0t2eWFNyxAZNcmDm3pKtHXrXK8nhASBlbN
	b+muqr9sSBkKUUNsyvfrWdQ7MVUoxjY=
Received: from uucp by elvis.franken.de with local-rmail (Exim 3.36 #1)
	id 1x1Wwd-0006bb-00; Wed, 02 Sep 2026 00:27:07 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
	id 439D4C0121; Wed,  2 Sep 2026 00:25:28 +0200 (CEST)
Date: Wed, 2 Sep 2026 00:25:28 +0200
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>, corbet@lwn.net, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, maddy@linux.ibm.com,
	mpe@ellerman.id.au, agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com, david@kernel.org, hca@linux.ibm.com,
	gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
	mingo@redhat.com, bp@alien8.de, hughd@google.com,
	linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com,
	djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	akpm@linux-foundation.org, yintirui@huawei.com, dev.jain@arm.com,
	usama.arif@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH v7 10/14] mips: move has_transparent_hugepage() out of
 THP guard
Message-ID: <apdQ2FJrLhkdjh_n@alpha.franken.de>
References: <cover.1788232334.git.luizcap@redhat.com>
 <371e2d3a7bcac265ac748ad3c67b74abfa238422.1788232334.git.luizcap@redhat.com>
 <f4c568ad-a17a-4982-b8d2-d5852a789a4d@linux.dev>
 <00eb76eb-c330-4662-9ca9-1e89fbc1e4ce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00eb76eb-c330-4662-9ca9-1e89fbc1e4ce@redhat.com>
X-Stat-Signature: p4owfmotm4nkzdyy5fmmud4k8rwi5i4k
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 547631C0006
X-Rspam-User: 
X-HE-Tag: 1788301640-569537
X-HE-Meta: U2FsdGVkX18IJzb8BkWO4+hXPWqTaQI+ZnqSDGwYtfxF8sNbuXu6yVZobCvZRFxuMQNNoqRTf1Mh+8JE5WDnlyxPZ5cfCYO8qyqJo5ti+AaS0C1nktT3TkrQE6UBVPhUPVn59bNGBSa9ysFQZbm2d29zQQuomrwzGWNmezn5r6uE6EdGcowP95n288LWR5P4M1JOjzBYoCHx1g9t8pLWLD3D3NYVQifO5G9VqBRZwEe76ya3GuxJ28m+lvnMldQk3M6E4Dqe5qhz8sEofhGtMnyLl9kxfHos8a4v3kLOrWyNIduAsrOdLWIafyNzoYmF6AN3mSIlM9stb/Yv/j363ln6TFw422k0Hujwc0XC1jvjctxq2vST9AHSgjBdeORVO8OPRzvEpW29DU10eRqgbDV18qr7Y8ZvQuZ1LkrSeUTjBYACJg8+Enq9ajQICIgMAbgfeArDp7RaHPnmmjqVstz7aHphfuznX2SZQKP2toScQg3GhBHzaD+19iSBDLtw7wRRugzyTqxKlQFj8EwjI/k4BG6IaBy2Gxuc75l3vLaleEEyIkhsuYGQkteAqKN4T5xzpnEKJ1hzsvNyi4508YzwCDQAqh2CSZKol3IzUufKxmT9Tr9bREJ7K5Jus+prB6jP5pX7wRfj1l9BwMcPrkVCqQR62h5vPXxmyM8GiHkmTEnKptfAqNvOQRAjlrPbi/VNxr410rXGE+mFDjCDRc6TxrE7v/N885ucptSoEDuXSsjC8txSf414jVy61NqXWIXniqP/obam39G44trpuJCHqI7tKGaYS8GP7yY6bDn3Efs0wQ+IJZ0LEAeAIdOxmJAJz9EvJyfaGo7kbfjPf53/DAvC0C+sHOoo3/PiQPYQjlBnbWXOn/l7VJll3xTZ7sOxPYqz3QHLznoiEH7d1kfvcU43UxPeP08lGZpE6QOSwyC9qBIJIsxiEOfFt1z4SqZeE6tJQEm3iszYySj
 +HpW/wfw
 fosHqj5askdGRQaQOjBBZVyiGsbHTllF8rLtHqXhIR31VXORnnpz4DXMQTbVvrcc6BWPiHEc7Cko2fmXz3IKNbN8C6tgAXcNXYxr3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 03:53:18PM -0400, Luiz Capitulino wrote:
> On 2026-09-01 07:42, Lance Yang wrote:
> > 
> > 
> > On 2026/9/1 11:12, Luiz Capitulino wrote:
> > > A future commit will introduce a kernel API to allow for checking if the
> > > CPU supports PMD-sized pages. This API will be based on the
> > > has_transparent_hugepage() implementation but will be orthogonal to THP
> > > and therefore must work when CONFIG_TRANSPARENT_HUGEPAGE=n.
> > > 
> > > Move its definition out of the THP guard.
> > > 
> > > Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> > > ---
> > >   arch/mips/include/asm/pgtable.h | 6 +++---
> > >   arch/mips/mm/tlb-r4k.c          | 4 ----
> > >   2 files changed, 3 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
> > > index fa7b935f947c..b038da872ec6 100644
> > > --- a/arch/mips/include/asm/pgtable.h
> > > +++ b/arch/mips/include/asm/pgtable.h
> > > @@ -615,9 +615,6 @@ unsigned long io_remap_pfn_range_pfn(unsigned long pfn, unsigned long size);
> > >   /* We don't have hardware dirty/accessed bits, generic_pmdp_establish is fine.*/
> > >   #define pmdp_establish generic_pmdp_establish
> > > -#define has_transparent_hugepage has_transparent_hugepage
> > > -extern int has_transparent_hugepage(void);
> > 
> > Assume a decstation_defconfig build. CPU_R3000 selects CPU_R3K_TLB, so the
> > Makefile builds tlb-r3k.o but not tlb-r4k.o IIUC ...
> > 
> > The only MIPS definition is in tlb-r4k.c, so R3000 would fail to link with
> > an undefined reference ... no?
> 
> Yes, you're right. I can reproduce this. Would the solution below be
> acceptable?
> 
> diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
> index fa7b935f947c..b038da872ec6 100644
> --- a/arch/mips/include/asm/pgtable.h
> +++ b/arch/mips/include/asm/pgtable.h
> @@ -615,9 +615,6 @@ unsigned long io_remap_pfn_range_pfn(unsigned long pfn, unsigned long size);
>  /* We don't have hardware dirty/accessed bits, generic_pmdp_establish is fine.*/
>  #define pmdp_establish generic_pmdp_establish
> -#define has_transparent_hugepage has_transparent_hugepage
> -extern int has_transparent_hugepage(void);
> -
>  static inline int pmd_trans_huge(pmd_t pmd)
>  {
>  	return !!(pmd_val(pmd) & _PAGE_HUGE);
> @@ -743,6 +740,9 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
> +#define has_transparent_hugepage has_transparent_hugepage
> +extern int has_transparent_hugepage(void);
> +
>  #ifdef _PAGE_HUGE
>  #define pmd_leaf(pmd)	((pmd_val(pmd) & _PAGE_HUGE) != 0)
>  #define pud_leaf(pud)	((pud_val(pud) & _PAGE_HUGE) != 0)
> diff --git a/arch/mips/mm/pgtable.c b/arch/mips/mm/pgtable.c
> index 10835414819f..3a5b411493d9 100644
> --- a/arch/mips/mm/pgtable.c
> +++ b/arch/mips/mm/pgtable.c
> @@ -23,3 +23,30 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(pgd_alloc);
> +
> +#if defined(CONFIG_CPU_R4K_CACHE_TLB) || \
> +    defined(CONFIG_CPU_SB1) || \
> +    defined(CONFIG_CPU_CAVIUM_OCTEON)

I guess using CONFIG_CPU_SUPPORTS_HUGEPAGES is a better approach

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]


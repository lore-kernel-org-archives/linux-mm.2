Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 672C5CF6BE4
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 04:58:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 585096B0092; Tue,  6 Jan 2026 23:58:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55C496B0093; Tue,  6 Jan 2026 23:58:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43DA66B0095; Tue,  6 Jan 2026 23:58:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 358276B0092
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 23:58:25 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B07521AA3EB
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 04:58:24 +0000 (UTC)
X-FDA: 84303961728.01.752A6AF
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0F10F100006
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 04:58:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=atgLP4Tt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767761903; a=rsa-sha256;
	cv=none;
	b=GZhdmB5OgcpQHK7fVWf30sb2qmnOs7lIWeHNpGungg+aMvjvf1LzREkGB+TQIrYK1173xg
	bFHyTxrGWO0CYv25kajyT7R4M6GfPfaP8C5FHw9/zEb7G+gpOPXRNiZiRjUXRVdCgNdu4P
	pfPdFDpRGllLFCN5sdkpFrpfy61diJs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=atgLP4Tt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767761903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nurUXHNs091EaceKYt0jtxQiBJ2IaAdTDr7CGJ+zWBU=;
	b=r9vvDpNLbjse67OvLeQX5Tx+HOgszkdL4avDHHSgJY+AaGjdaDbzzJkywBGrBbCCTgYzG9
	KblsyLlnhHhTkEoqG5/b9/xxXWJFSCr/lOFL6aStsoSzrBW64VZMgn2NHPwBXooOTGvwux
	4wReMZyw7WntXfwqqxTR9EIKYnGkpEg=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-34c71f462d2so1618982a91.0
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 20:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767761902; x=1768366702; darn=kvack.org;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=nurUXHNs091EaceKYt0jtxQiBJ2IaAdTDr7CGJ+zWBU=;
        b=atgLP4Tt4iRpSGZQd3q9PFZ/pb0PShymFvPAt9CQjYbCubGAClVpFv7xqL2x1s9RkY
         +Ut3ZhLRAi4ey6ETKGJYWyKKQwP0Nv206eVjdlHCATgOac6FyzXP0IiQytFdR1uapOqA
         appLOI4oqZ9L5nvMsZIXRH7+pNlSQRCHKrTgqi7jsIAERDz9AGphb/L05h6n8g0sNliy
         tb5kP2zRjWAQevyQQ0Q3bmJlC8PjfXu0Q+co63KptFTz6YrmM6HKCKKpNT/c3gixQzIR
         bkLmma7cnq2N5M+nwNnj941xXZELoB/4W50lsyhU+lh7dhIeHeL8oBKhRO6WkQpgX8TH
         /L3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767761902; x=1768366702;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nurUXHNs091EaceKYt0jtxQiBJ2IaAdTDr7CGJ+zWBU=;
        b=WZwoESx0a9GJfiILjVPFm/wQM+gtwYDQA/xFlNzndVvTbuTL9i4C3keORjX67yJ4CX
         UQ3uXNrseJpAKtRqPB+5TcaWXr4GRTmiUCKLbgwsljIGaQBNb6XoOQDVUmsyGLgw/vE9
         wiMPze8bmY4DBqMIcONibaV0Nmsvcs9OqtaFQxTUyCBmyrozNtV6vOBpSi9T+4/Fw61t
         ohKHx28lnMnaFm2Eto217oPyeE6mgWg5heT/GUVziviSqdbEJ6hUIo8H9L4JrGNEDYIH
         xtFLhRaE+h73172hVW8pLs40u0AudMeleKzmF+BZTJkVaswbDeLFa8v51oeGGqnAqZcZ
         VddQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0zu2fOJns8Skf8cI5V5jswM4hlhxEq1mlExvb0Qmv+yoW8GsG6pYGLpODJGAitV0hoyechhpF4Q==@kvack.org
X-Gm-Message-State: AOJu0YwTo/Ggiwadr18f2jfSREX45swCx8MElRqGT60h8klzibgiEtY/
	Eb9a2nKijVrK45uc4xBvpS6s/yZwCBxb93lG1gmMEba1iiR/ISWjtSYF
X-Gm-Gg: AY/fxX5POGNyR4HV6TAQJncpdBcLsod87nyPZSt/mdpfRlRL9OHdgypO1cViWvr9v3W
	hYAZaYORDkEZKwAjSx8h68SWfzBSreHuXnrgcfYZz2lCBH+11kqVHH8Bj0IO1ObmaZLDEh/rdN4
	AAW5uKWOghOR7E8RAr1eusSEFWi3rDLb5f67gpQsowEC0oBAKG7pMdeWG1/YxV/hOxHcSEgGD5H
	adAKIaAywomyCxD2fHL3LcbC5dKP4SoamdVxANoR9CUoUqQHR16ZJx+R/FSIxUXdWM18mshrOlg
	OGNlSMDwqErxgKNq/7kqorwOi+CXVIx2W7QKB3bZh+Li4vG8hvzaDGMYyAQh1QqUyYvGWDsxkau
	G5/q3iGUBp6X1lKVYrYJ2JSQ159PCl0S1w2D/6z7+OCaKjdmaw6gnDXGtCdnnss/XWD8arLhkg3
	5OqGOdGQ==
X-Google-Smtp-Source: AGHT+IE3iEJ4twso46GOnqJPDopUox2qFLaKHiDPKI95vlPPxjV/F7mxvaI/CeOE2s8GrRHRScEd6Q==
X-Received: by 2002:a17:90b:6c7:b0:335:2eef:4ca8 with SMTP id 98e67ed59e1d1-34f68d3b4a4mr1191743a91.33.1767761901762;
        Tue, 06 Jan 2026 20:58:21 -0800 (PST)
Received: from dw-tp ([49.207.192.172])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f5fb75902sm3622895a91.16.2026.01.06.20.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 20:58:20 -0800 (PST)
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
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Magnus Lindholm <linmag7@gmail.com>, Matt Turner <mattst88@gmail.com>, 
	Max Filippov <jcmvbkbc@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>, 
	Michal Simek <monstr@monstr.eu>, Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
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
Subject: Re: [PATCH v2 14/28] powerpc: introduce arch_zone_limits_init()
In-Reply-To: <20260102070005.65328-15-rppt@kernel.org>
Date: Wed, 07 Jan 2026 09:57:34 +0530
Message-ID: <87ldia9he1.ritesh.list@gmail.com>
References: <20260102070005.65328-1-rppt@kernel.org> <20260102070005.65328-15-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0F10F100006
X-Stat-Signature: b6uzh653mbi6fn1b3k8topoec65brimu
X-Rspam-User: 
X-HE-Tag: 1767761902-671199
X-HE-Meta: U2FsdGVkX18yJT/rcnMxQ+la8FAOtL+L+4pUe9IZegSjNXzftPBoPzTtQL/Wf0JsKhAU1VR7+trcIrMvTj6ES4JE0fj7+x7yzDhzLQuygfS3c7iYyMUvm+SSxCnCJ+J6/8R8cDglhEdDkH0aYXPMwm1msenOpOhhNU5aWvTsNkhJ+kh4wbmiOz286aTV2pwY44tQl10nxd1MfXe54f2Cv2q7mKh5l+jQ9Y8T4g2Pfdtx2gH4elvitNPN+vOFIrsZkiq8T3s3aD01eE/IMwcVgMIvy/i/QFlfzBMQyBLaAflPgYMYpp3lLqq1jIGbDFRv5cl/SV0LtW5vFy/hOHlE9tTi84THjUyY1L4qcd/bE0sguDKLFirgt5swUAIJtT6hqSeFkyAZmFLEK6mDKC+S5y3kVFdnThvnhqSVgf3MOcgB3lV7u4Spq/SOTWZkAzby/klkeERDprNTbrz9b3OvFizVrxR29UDf5QBnhVRLCTtxcjLzUGdhTHGBfrtPAjqwlRPaGa0zz2uNw/9m0I2U/fAJbd6j69AHdRbHBduAfFIXqbw+8Hv2cw9Jddcz/pOR30A7HjnacPBUx1a1D13GGCijGq4QXi+KFfYS2cZcT0OShk6lZJ4TYQ2jh6ayWfVNBZvJ//Wno9S3UGvKQeKrUmPnUIpLhBPJCoPI2md6Z/tKNyt+VebEfE7wsFrcmqhMkYMt1/8k7bChjMDhEtKIwdi0Opq4KB1u0dKd4x7/j6TnplAaOpSE0IXcNDdzCuEc3fNFnpJIPdNzKFbqHplbNM1Ro7yhnlHdc4onJ8YBcQUA1Bj4C+RyHtLf3YZ5Q0bRH1XiwafKMmypO6s1EFpgGF9LFWUIrqN9AMiD0mxevybbvXmEB/i059RT4KsSYMbnzXTvXqeqKZmIPL/3dvtDzO7tRQhRA1i+DWIXUg+pDb7fUvbPEhHajNKCkPKMfjyHE2wASmDfLtGlngD0GTU
 ygBFwtlP
 8uIg3IPxD4WruN6wtCDnCcyDP7xVloV6jripdj1w9ev7NZWfEs9j2aWAP3LNmsjzdF3/r2J/jkR67d6mQ2ENO5htU7bjh+KOOir7s4YGIYLylFmxkcTqWP6Io9yG1nNFGM7p+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mike Rapoport <rppt@kernel.org> writes:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Move calculations of zone limits to a dedicated arch_zone_limits_init()
> function.
>
> Later MM core will use this function as an architecture specific callback
> during nodes and zones initialization and thus there won't be a need to
> call free_area_init() from every architecture.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  arch/powerpc/mm/mem.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
>
> diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
> index 3ddbfdbfa941..32c496bfab4f 100644
> --- a/arch/powerpc/mm/mem.c
> +++ b/arch/powerpc/mm/mem.c
> @@ -221,13 +221,23 @@ static int __init mark_nonram_nosave(void)
>   * anyway) will take a first dip into ZONE_NORMAL and get otherwise served by
>   * ZONE_DMA.
>   */
> -static unsigned long max_zone_pfns[MAX_NR_ZONES];
> +void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
> +{
> +#ifdef CONFIG_ZONE_DMA
> +	max_zone_pfns[ZONE_DMA]	= min(zone_dma_limit, max_low_pfn - 1) + 1;

Hi Mike, 

This doesn't look correct. Isn't the zone_dma_limit value in bytes actually?
Shouldn't it be -

     max_zone_pfns[ZONE_DMA] = min((zone_dma_limit >> PAGE_SHIFT) + 1, max_low_pfn);


-ritesh


> +#endif
> +	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
> +#ifdef CONFIG_HIGHMEM
> +	max_zone_pfns[ZONE_HIGHMEM] = max_pfn;
> +#endif
> +}
>  
>  /*
>   * paging_init() sets up the page tables - in fact we've already done this.
>   */
>  void __init paging_init(void)
>  {
> +	unsigned long max_zone_pfns[MAX_NR_ZONES];
>  	unsigned long long total_ram = memblock_phys_mem_size();
>  	phys_addr_t top_of_ram = memblock_end_of_DRAM();
>  	int zone_dma_bits;
> @@ -259,15 +269,7 @@ void __init paging_init(void)
>  
>  	zone_dma_limit = DMA_BIT_MASK(zone_dma_bits);
>  
> -#ifdef CONFIG_ZONE_DMA
> -	max_zone_pfns[ZONE_DMA]	= min(max_low_pfn,
> -				      1UL << (zone_dma_bits - PAGE_SHIFT));
> -#endif
> -	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
> -#ifdef CONFIG_HIGHMEM
> -	max_zone_pfns[ZONE_HIGHMEM] = max_pfn;
> -#endif
> -
> +	arch_zone_limits_init(max_zone_pfns);
>  	free_area_init(max_zone_pfns);
>  
>  	mark_nonram_nosave();
> -- 
> 2.51.0



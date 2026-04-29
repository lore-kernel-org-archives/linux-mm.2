Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18BD8CCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:52:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82BBF6B008C; Wed, 29 Apr 2026 09:52:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8032A6B009D; Wed, 29 Apr 2026 09:52:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73FAD6B00A1; Wed, 29 Apr 2026 09:52:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 67CF56B008C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:52:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 10C401402B3
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:52:42 +0000 (UTC)
X-FDA: 84711733764.23.584AD04
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4F1EDC0002
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:52:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HgLY0Rjc;
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777470760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lm1+A0qDgefDwn4bp/M3ryUm2rKD42TYqLTCfsQDJ2U=;
	b=iJRDwgn47x7MGdotUVweEIq0BO98Ps7iYkzBL3Z/ykVQmNm50VBvb9M0No9qDUFscKyIMO
	W+C5p/da6qX26pxgDblsB1gyXDYxOmk8ZpUvppeUkpdktzRk4Yb2NFvqtkQtZOTQixTy7b
	oEfRCqBKhKpn90gQ/t4eZAHWM4utFNA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HgLY0Rjc;
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777470760; a=rsa-sha256;
	cv=none;
	b=MQ9Wx+WGetOrsXLq8hDn7xB1q9ylMshS+XwGi1DT0mc65I+2EpGjfmhSMm0Q4uo5cvGypN
	MAjABZ9xc3JIaxeTMGWoaGiJ2qdE0NShw6s6n5MM0fuq0SmHjDWFHID+xg29mLrK5AMlcx
	KPaxZD4ApeWs5grIFzQRaB0fK6UwRnQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A548C1C01;
	Wed, 29 Apr 2026 06:52:33 -0700 (PDT)
Received: from [10.57.62.76] (unknown [10.57.62.76])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D42303FB90;
	Wed, 29 Apr 2026 06:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777470759; bh=s0tgitch6tjt2iSC+ew5SbhvP7lh6LqBU7/+wo85gzU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HgLY0RjcX26UI051X7p0jTvCIxdqYVMTsc8814Yedfgp0bzVK7UFbv8tvL3cLRx6u
	 iDWC3D+nLEDNCb2TZLk5lDi5Udldgc4oVV5EETWkYfWURPnuXnXWyavWHFha+ew//E
	 2S5LwNp+WnBIoW+zr84x3BSUsI6BHHiVLKyfK5Og=
Message-ID: <382872b6-748b-41de-b3f5-728964bbd82a@arm.com>
Date: Wed, 29 Apr 2026 15:52:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/15] arm64: Move fixmap page tables to end of kernel
 image
To: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com,
 mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>,
 Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-27-ardb+git@google.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260427153416.2103979-27-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4F1EDC0002
X-Stat-Signature: oikj3jfhzs6d7roqnojs9g9d93hkptae
X-HE-Tag: 1777470760-107388
X-HE-Meta: U2FsdGVkX18FpsahcBJWytmcVqRvQfunfkYEMIr6s+1LBbgoO/L4sfsW3BvrCuapEXeWUTd2QAOpyiCcjJEssm+kiU5OXnK39Q9E+QGCIY2nD+M6SpH1nquX6x6P18+p+RWA8maJJ7mWmNjZi5sPIxY4TSUMMaSJHmOegvx/7ILAwe/anoz1F1N1jkCNs14EQNAkmWKDIVlBKSkfP8Od14fiCMtANLLBrITXrXJWbdEBwTOtp2FOwwBsb1ZyHKhBXvNfFyZ58Nfx9+TZS40LL4On2A/yDlYhduNUbXdTtVed6eWsRQft5ByM0NT+Ic4l5Tax3fSQyPUDXetLJWcX8RdDlk1GssDT+DXmvUD+vPIn6PaWxX6nrtUb+5BAowK5kg5jEJSPsfiMk64YY+Qkyx/63R5c76DXS2OgusDBDu/nPgwqI0CxFqdF497ALnD4me5VoZPFSMsWeu+jjllHzOyrIdcR3nTENQbNMUrv5OC7+hKTWLpedOoWp0ZaSFeZKb72m89V+S02THrpqW3urh6fpkYr0EYBXf0fsrDUHNzu8dwTSvCO+aB48ZXTSUybFStJLy90c+c3iQNRrxN1x/VwcESDaQ+8fMpZlgpBGaaAkj4hnJ3iI//gklFcqQp5hpb8ra/UlBQ39eCgO6TIpMqryyJeLJNvnEU9WNOjLHu2ThWIwg+3uctFJa2qlvFAIn6UadpAC39vbk4yjS/2uO14h/CDdtsNSilSEb+tIsaqcbK6jOnbqB0lBFKtcSyrjMCY2Iy2zx4Z4UKYHqfZBWWmAoUaDxDms2QjdNXDeFqGPyJ8iwRFkI/ldyjEW+Y7UdPe/TadBJRKUpc1eigk3rdiiQ1q548rk2YA5DedJYjPDF4PoUykc3yT9rI1a0I4UjO438xOH7OOeZzDMEOC4Guz4m/J4LQTOA1bWLfcFiH0jv3nhelLQvjXZqzFaACDz7xvelKJVNrdsLwXoOz
 kFPOWLhu
 9R1Y4haw1hExyGU6H4x571OXQhYNLeQN7AQl6pKWvZjTzk6gPaIRo5DaaNwWlT/eGuELge4XnE7WecjR+nyTsWLWHCjTvXSUaG34zC+bHmeb27401kin5QSp2Knt070ILV3p5IV9+fCSpbZXTr+t829eZb7egjSpB243+D1bGa2WgHG5pknRFAXjEjLt6f1faPr190b7ILhatxt4XPV6dacgRReY4hlrw6dTu26QjWqMgIQGKcPNH4PtjIDtQ5YwXN1B+ZKsQcPgn0NgQD2c9l760fvSfhKQhtKp0POSPfv9xVypFK8rN9/PKeRrN9xVqV6dykkvlJmvxx+IfizKLa2tSdyEtaaNLFoKF6TcJDPBGCDYY7qS0PuFNmuMpLcJEC+RbPaAQQJqe2xY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/04/2026 17:34, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> Move the fixmap page tables out of the BSS section, and place them at
> the end of the image, right before the init_pg_dir section where some of
> the other statically allocated page tables live.
>
> These page tables are currently the only data objects in vmlinux that
> are meant to be accessed via the kernel image's linear alias, and so
> placing them together allows the remainder of the data/bss section to be
> remapped read-only or unmapped entirely.
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

> ---
>  arch/arm64/kernel/vmlinux.lds.S | 5 +++++
>  arch/arm64/mm/fixmap.c          | 7 ++++---
>  2 files changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> index e1ac876200a3..2dca18574619 100644
> --- a/arch/arm64/kernel/vmlinux.lds.S
> +++ b/arch/arm64/kernel/vmlinux.lds.S
> @@ -353,6 +353,11 @@ SECTIONS
>  	__pi___bss_start = __bss_start;
>  
>  	. = ALIGN(PAGE_SIZE);
> +	.fixmap_pgdir : {
> +		__fixmap_pgdir_start = .;
> +		*(.fixmap_bss)
> +	}
> +
>  	__pi_init_pg_dir = .;
>  	. += INIT_DIR_SIZE;
>  	__pi_init_pg_end = .;
> diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
> index c5c5425791da..b649ea1a46e4 100644
> --- a/arch/arm64/mm/fixmap.c
> +++ b/arch/arm64/mm/fixmap.c
> @@ -31,9 +31,10 @@ static_assert(NR_BM_PMD_TABLES == 1);
>  
>  #define BM_PTE_TABLE_IDX(addr)	__BM_TABLE_IDX(addr, PMD_SHIFT)
>  
> -static pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __page_aligned_bss;
> -static pmd_t bm_pmd[PTRS_PER_PMD] __page_aligned_bss __maybe_unused;
> -static pud_t bm_pud[PTRS_PER_PUD] __page_aligned_bss __maybe_unused;
> +#define __fixmap_bss	__section(".fixmap_bss") __aligned(PAGE_SIZE)
> +static pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __fixmap_bss;
> +static pmd_t bm_pmd[PTRS_PER_PMD] __fixmap_bss __maybe_unused;
> +static pud_t bm_pud[PTRS_PER_PUD] __fixmap_bss __maybe_unused;
>  
>  static inline pte_t *fixmap_pte(unsigned long addr)
>  {


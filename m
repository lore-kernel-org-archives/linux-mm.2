Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84D9AE78D40
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 08:41:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D5866B0005; Mon,  9 Feb 2026 03:41:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 583906B0088; Mon,  9 Feb 2026 03:41:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43A9A6B0089; Mon,  9 Feb 2026 03:41:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 336056B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 03:41:16 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BCD15160701
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 08:41:15 +0000 (UTC)
X-FDA: 84424273710.02.30E9FC8
Received: from smtp-out3.simply.com (smtp-out3.simply.com [94.231.106.210])
	by imf11.hostedemail.com (Postfix) with ESMTP id A6F484000A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 08:41:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=OzGhPxF4;
	dmarc=pass (policy=none) header.from=gaisler.com;
	spf=pass (imf11.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770626474; a=rsa-sha256;
	cv=none;
	b=rV0cHZJ72bqVkahgoASsLHgUX2WThwp/HzLAajQijELMEVKhQjoh+Bzu3Iopo+7kTazurZ
	a5TyTxFeS/v17LkTGRjU97y2o7n9bBfSvn3fSqQTzE7k9BcokiGcCCukdfcUbr4ztMuqgY
	VW1NwiZ3Illo3bSKsW2dEHvSHK+ep9c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=OzGhPxF4;
	dmarc=pass (policy=none) header.from=gaisler.com;
	spf=pass (imf11.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770626474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RbC+RKpRL3vyZA9rhFwXc+s3LnlBOMIWZ1+a+rfNhok=;
	b=uZU2HEMsLYGERKSaYEAqg9v7ThQA1pB0smbK+07mscedDKfoXcjhbitxXaeCMciMd4CAv5
	RjPSXJPraSOUxu+MTkLV6cldciqw05VIsrOI3ZCvXIfGt9/djR5LzWwtyExBcJ9dUxtlM3
	r7YEuW8J2BNQc/SvKyHGkChTBTxZ01s=
Received: from localhost (localhost [127.0.0.1])
	by smtp.simply.com (Simply.com) with ESMTP id 4f8dT36VdGz1DDdY;
	Mon,  9 Feb 2026 09:41:11 +0100 (CET)
Received: from [10.10.15.18] (h-98-128-223-123.NA.cust.bahnhof.se [98.128.223.123])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by smtp.simply.com (Simply.com) with ESMTPSA id 4f8dT110xZz1DDXf;
	Mon,  9 Feb 2026 09:41:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gaisler.com;
	s=simplycom2; t=1770626471;
	bh=RbC+RKpRL3vyZA9rhFwXc+s3LnlBOMIWZ1+a+rfNhok=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OzGhPxF4b1JTlL0uvUgojBuLGl/d8Dy9MJzVSCLeT/MydG7knOZy+3rxTsSLXE0fa
	 Fe8HpYTWVqRUTnGYcY3oAZB1G1mG+IVuTFOS7+WqJBz1ilC5nvTR8TovjKYRzf+P2w
	 Ww4xwxi029qA+7zIuREjyi1oyTjnneeeu19Nl05HHLco+NvnhYBsugXIxVmZ8+yauy
	 xXkbpOW82Lh5ONVHEwDikWUcNveQWPl7uCMf/FTqxIDhDMLT/JU43EG3ChwZ3W9qcL
	 8U/FowPM9gwj9XED74iSkSmiVCadg33Ys0HHbcY4Truz0z7WWFA4WvlePWVs4XcxTs
	 tU6jXEQEdNbzw==
Message-ID: <55bef6c2-de81-4b60-b6df-5ef733b54dee@gaisler.com>
Date: Mon, 9 Feb 2026 09:41:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable] arch, mm: consolidate empty_zero_page
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov
 <bp@alien8.de>, Brian Cain <bcain@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 "David S. Miller" <davem@davemloft.net>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>, Dinh Nguyen <dinguyen@kernel.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Guo Ren <guoren@kernel.org>,
 Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Johannes Berg <johannes@sipsolutions.net>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Magnus Lindholm <linmag7@gmail.com>, Matt Turner <mattst88@gmail.com>,
 Max Filippov <jcmvbkbc@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
 Palmer Dabbelt <palmer@dabbelt.com>, Richard Weinberger <richard@nod.at>,
 Russell King <linux@armlinux.org.uk>, Stafford Horne <shorne@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Vineet Gupta <vgupta@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, linux-alpha@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
 linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-sh@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org
References: <20260124095628.668870-1-rppt@kernel.org>
 <2157220c-0394-40fa-9918-a8514171bd10@gaisler.com>
 <aXj_x5CyUeys7ONM@kernel.org>
 <ec965a79-dad8-4358-a8e9-ebc9f330b67b@gaisler.com>
 <aYcVu7gs65S1CeST@kernel.org>
Content-Language: en-US
From: Andreas Larsson <andreas@gaisler.com>
In-Reply-To: <aYcVu7gs65S1CeST@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A6F484000A
X-Stat-Signature: kk64bwetyjh8uc34nmwhshgmrxf61br8
X-HE-Tag: 1770626473-681557
X-HE-Meta: U2FsdGVkX18c1HTpYLp58BbmmAXKRPMTZTyr30aQAIvYJnaYVINc7CmlN6bF+bOwGTTsrF7z5KZeAr9nfiDbyz1IGSNcCDKSHF3H1AMN6NfQesLVkTpe9uF/0d3lh1n41fjZOtJbXuobkS7cpDiRMLP8jLUCEBh4zbSzq5QwPtj3pVlt19+DpDSO4PuPPtFkKquOqISas3tfY9NpH7KnyRQJVO3QPG5HFhauIneHdStGQcxBKM8W+YjVv8z1WzQcpuFvjOCj/NPQsYRCgK3/bm1XKetMBxtwYSqPvySOsv3M3NbudqRFHY6p3M1XfF1qMGwqa7xXAAbH6N9AWlidbTzdTJJnhzDzSG/6Zxey2aTf9+E03wzAiPApNV1n0H4NKqNb6Pbu0sSA2dZqo+qafzNMUxOuc7FPVZKab+WAaxxUjOu18otOMbjM+w6HZEXWmp5NUltAySEyjOec9MzhIYNMt9I/gqc8Vo0KQ1Hss7hEZgxTWoaw0nPGV4ZNciv9Sd+Tge2YiSmEBVDURTSzEUeOkQ9GBcqxfPLhkc0dVWcrcbjNZgn8+lBltKv4q8MDHzEHLPeMz+Qdz9AVIv4J4O3v03MXmTXokvOZXgg8UidDxvJR9EjxFIjJIbKa4/zeIqdJ4tyg1hYDFEGZUCS7Q6OAkqAlYQFhTdoNkLGkbibYX3qWpQJk84K7nTUozhsrFP0ouaU26S1C7XZNvIlh4jFn7qguphLue7JoXPQozc/pnGvYuVnWW7zWLBmwR9rb8aF4kJwE2O50rxkug8HGYlBmN/ZfWBfwh83EdtJlZWOhceGH2bWZfk6FMUokBJOeIX4XmwIPZ0wPiAsSknZ6EvU8un72G/a+lfTFqRnNqzNtX3Xaq+1bv9yurKnoIMfxWvmv0BxH7mU63hXD33/LUgSGV1Gn6cObT9Hx3JBfbHm1RzHFdWPzn4y4Ett0qdaqfZfHsnZC1owKpRjyA+Q
 mM2NknCh
 jH7+pmXJ8RCGwMVJfKXr4I7biPnI1w0eQ6vB+ZY+6T1J4Yax+/QekSmsXwxR06GQqHEd6+HfGBSNJk8tWfUKAAqwtfJLprsXkj9W218vcKl7LE7DPwdVjWbZ76JsV1I36OZwN4qnvJNvjiapoZv6yQL/j/69FvGFRfBvI28Geg57dhb1YfaHeWIP0fZCpyuLOh9GzdAaw4gJUn+GKAH3a5VjGkYj9L/H3CpTW98rhrQyAlvb3s+uarAKIDv6Vbagvb06DNpWEAXNw2+MPFKP5jNCLN8aQcZ9p/Fzk28eGmbORYprYmRI+6OR8834SeaTDnyJ9BRXZhkkU+M2MWCTrk+sCw057MOGIdnfQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-07 11:36, Mike Rapoport wrote:
>> Unfortunately, that does not help. The LDOM goes down in the same fashion.
> 
> Apparently something is wrong with my pointer arithmetics :/
> 
> Can you try this one instead?
> 
> diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
> index 74ede706fb32..615f460c50af 100644
> --- a/arch/sparc/include/asm/pgtable_64.h
> +++ b/arch/sparc/include/asm/pgtable_64.h
> @@ -210,6 +210,9 @@ extern unsigned long _PAGE_CACHE;
>  extern unsigned long pg_iobits;
>  extern unsigned long _PAGE_ALL_SZ_BITS;
>  
> +extern struct page *mem_map_zero;
> +#define ZERO_PAGE(vaddr)	(mem_map_zero)
> +
>  /* PFNs are real physical page numbers.  However, mem_map only begins to record
>   * per-page information starting at pfn_base.  This is to handle systems where
>   * the first physical page in the machine is at some huge physical address,
> diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
> index 2bd99944176d..aa1f9f071fb2 100644
> --- a/arch/sparc/mm/init_64.c
> +++ b/arch/sparc/mm/init_64.c
> @@ -177,6 +177,9 @@ extern unsigned long sparc_ramdisk_image64;
>  extern unsigned int sparc_ramdisk_image;
>  extern unsigned int sparc_ramdisk_size;
>  
> +struct page *mem_map_zero __read_mostly;
> +EXPORT_SYMBOL(mem_map_zero);
> +
>  unsigned int sparc64_highest_unlocked_tlb_ent __read_mostly;
>  
>  unsigned long sparc64_kern_pri_context __read_mostly;
> @@ -2495,6 +2498,9 @@ static void __init register_page_bootmem_info(void)
>  }
>  void __init mem_init(void)
>  {
> +	phys_addr_t zero_page_pa = kern_base +
> +		((unsigned long)&empty_zero_page[0] - KERNBASE);
> +
>  	/*
>  	 * Must be done after boot memory is put on freelist, because here we
>  	 * might set fields in deferred struct pages that have not yet been
> @@ -2503,6 +2509,12 @@ void __init mem_init(void)
>  	 */
>  	register_page_bootmem_info();
>  
> +	/*
> +	 * Set up the zero page, mark it reserved, so that page count
> +	 * is not manipulated when freeing the page from user ptes.
> +	 */
> +	mem_map_zero = pfn_to_page(PHYS_PFN(zero_page_pa));
> +
>  	if (tlb_type == cheetah || tlb_type == cheetah_plus)
>  		cheetah_ecache_flush_init();
>  }
> 

With that one, things work fine.

Cheers,
Andreas



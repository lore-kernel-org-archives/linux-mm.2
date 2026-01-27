Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB386D34098
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 16:02:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5185B6B0088; Tue, 27 Jan 2026 11:02:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EFE26B008A; Tue, 27 Jan 2026 11:02:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EF9E6B008C; Tue, 27 Jan 2026 11:02:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F0236B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 11:02:46 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EFBF01AFDAE
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:02:45 +0000 (UTC)
X-FDA: 84378211890.16.2C3DA78
Received: from smtp-out3.simply.com (smtp-out3.simply.com [94.231.106.210])
	by imf23.hostedemail.com (Postfix) with ESMTP id C049D14000B
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:02:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=nF1rwIiB;
	spf=pass (imf23.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769529764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XjNhgAV5Uc7zjxVMNfRjSJ4NulgkiTn1O8FFUA42SJ4=;
	b=w1Klo8Pdd8vsM/+K51TRCr3n2d8whWwQ8m51u0LlYIfqc4Ts1ULfVKQtnenpvYQ8HqCOCW
	tbjsu0fdVmgENA+vRYD6ucDOdv3mPJujzmthG4mu4JtuTfvfxSDeWnurvSZdWkHTSNqt2Q
	S/WWQanAEggJ76c90NY8lpqwHEXcXVc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=nF1rwIiB;
	spf=pass (imf23.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769529764; a=rsa-sha256;
	cv=none;
	b=WsRG5DLOFApXtCMZn0pJR/ehtb0wCB1k+O12xibL3FTMEt3V4jlZdQ2feoGuF9LeJFbnt1
	3jToxQ6FWyRjRr9+9BazhTTOd6LKeGp1Vcor/1EHcF7N2MIEz4DHTV2ZMBt+BMAnEBnoM1
	GTu/J89vcr+LakMQ6vlP7sZbgcXvWwQ=
Received: from localhost (localhost [127.0.0.1])
	by smtp.simply.com (Simply.com) with ESMTP id 4f0qtT3pH1z1DPkw;
	Tue, 27 Jan 2026 17:02:41 +0100 (CET)
Received: from [192.168.0.25] (h-98-128-223-123.NA.cust.bahnhof.se [98.128.223.123])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by smtp.simply.com (Simply.com) with ESMTPSA id 4f0qtS1KPDz1DPkR;
	Tue, 27 Jan 2026 17:02:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gaisler.com;
	s=simplycom2; t=1769529761;
	bh=XjNhgAV5Uc7zjxVMNfRjSJ4NulgkiTn1O8FFUA42SJ4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nF1rwIiBmdMccnC6GLsJ+1cTxVIoLNBWUK2hRgllWz+vqzG3zn6qSGadd3ql/fc/j
	 wftmmd9opEasAb176XRKPUE8StMbl/6p+SplfVp5nf9nN1Js2h0Lp8VSMmtcQE30aH
	 Bl1zEaQxtIRA2e3e+l06MPu18XvsS1MAwBqoUlTwwd2s8vpthHuAcTJvSs6AHdaqC9
	 IvGbmsJblv3nhY89l91lTlG8IritYfepiywoeUokkcFJYOBd8jK3YPlU2kPdjCdp4y
	 HkLZ042uE8RsQsy76g2JHghhGJKUQuKXN/sEzVbuaQAH2qMCw8MbIO603QZ3+XYxw6
	 58WjXFSREqUIw==
Message-ID: <2157220c-0394-40fa-9918-a8514171bd10@gaisler.com>
Date: Tue, 27 Jan 2026 17:02:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable] arch, mm: consolidate empty_zero_page
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Brian Cain <bcain@kernel.org>,
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
Content-Language: en-US
From: Andreas Larsson <andreas@gaisler.com>
In-Reply-To: <20260124095628.668870-1-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: u8tpoianz8u8a84ggtfbqjk6co64z3yi
X-Rspamd-Queue-Id: C049D14000B
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769529763-747303
X-HE-Meta: U2FsdGVkX1/K/KdXrNRK/xTYgEZ0dv+cXgrhOwwPGjqQdhX3MlGXqt578PaKAo4p8/VxSTkeo2kIiyAZXl+ndoZELKY0Jlp5wnCrTvQdK1ZAruuui4vQDam7VvF0nZ2ItbBBZzpHtJwUWTRE2cjEYGtx4qy8EyBWEb9Z/to0uxLuvHROOyvyQSRXYI47woeYl8OPapjJUsLPZpv/SgVZdYnTZ1uMUCOiUFjiz7T4+GExTq1qGeXxluBVtFqp6/WuIo5mb9scRyeYYUUdAXVeDtG/befPceePLjSGizYKIMkI4A/A8whCENLmlE+UxU750AqjSnqsImqFblLRdkO6UXX6nvRJnRebd5XeL3L2HnW7oEoWCrZ75tevOinKHxclrJYvSSakhSp0urddspcQaHwsEzMvXNuUIj6XdMNVqy7grUBuX70zBu0PXs7fxYSK5EWHEu2DhPhtddBgPeAzWoyfHP4gwtLhK0aC7Fa9GMpXcrEu5QNdMT9wbsXol6aV/7r9c/CrvbKV12ucBl9UHdQ65sd9kdjYztkPURdsDwWzJIg/dFWJ/tPLspK3xCly//dYTb0GsBRiKC5a1RL5N3vsFnXBvvj3IqCfsp+Y7kwF9Xu6b88IHdwQgz+csxzPIaBPC+OsBZk/vGRMS1y4713IksARJILlRrV7FDPdhHX/dzjbSBsyd6a7XzgPOs7JEv4tNk1NRFXqXbLSoBz9KfKTw6qCPJmbhU6w4nAeTq6rx5vMwCwhXyCGUpVvXSmJxPkcGMsaaG1ql+6irdfQtxsNFvF68FIkWIempvAk1TLlBzwYrWlJjccZITPGm0BISnjZs+1G/sACnzXWfVkBHu+jCD2vwOn3+sR2pPaLr3rNSXfQ713aTb6O67640wkPlW92tILDOEZJP9B2QzGCj2+YvNUNiJQnyv/j2L+xD4zuxd2waLfMjxxlzi3OfQp2P1v5xUYkw6+8ooTbW3j
 HuvWz7DW
 CxQ9h1Jffb7Mj1Ll2/2hVQ3t2KzY9zPIsxhz2xiKN3zf9YiKmJc8WY43ZyD6j+ndoZp9NE1nxZ5eNxjka37GGxvxbuWsUKkwBRQmYWjGs+7Zux9u+RuzfpAnGSUHiYoE1pAecOqOu9sd5fAPItABEz2r1J5udbONm8G9Xr7RCSCeHHOniXPwsnM2+pzHI0YrOzrbem1HgmB3fzqdfAcjgto/lhGn0t9K3RnGP7X1S8AYYijw4dGJkheofPizCYv6ABxv9lj/FmURTILFPzOx8d74I/aJRlOxJHRVFV95384C5Xh/YSIVb9uMuTkZTMG26slnZmDaUf5O/rqvPz+Isj4cYb2by1NEL25VOGWhHysocqQ5fdZkrPJwESw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-24 10:56, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Reduce 22 declarations of empty_zero_page to 3 and 23 declarations of
> ZERO_PAGE() to 4.
> 
> Every architecture defines empty_zero_page that way or another, but for the
> most of them it is always a page aligned page in BSS and most definitions
> of ZERO_PAGE do virt_to_page(empty_zero_page).
> 
> Move Linus vetted x86 definition of empty_zero_page and ZERO_PAGE() to the
> core MM and drop these definitions in architectures that do not implement
> colored zero page (MIPS and s390).
> 
> ZERO_PAGE() remains a macro because turning it to a wrapper for a static
> inline causes severe pain in header dependencies.
> 
> For the most part the change is mechanical, with these being noteworthy:
> 
> * alpha: aliased empty_zero_page with ZERO_PGE that was also used for boot
>   parameters. Switching to a generic empty_zero_page removes the aliasing
>   and keeps ZERO_PGE for boot parameters only
> * arm64: uses __pa_symbol() in ZERO_PAGE() so that definition of
>   ZERO_PAGE() is kept intact.
> * m68k/parisc/sparc64/um: allocated empty_zero_page from memblock,
>   although they do not support zero page coloring and having it in BSS
>   will work fine.
> * sh: used empty_zero_page for boot parameters at the very early boot.
>   Rename the parameters page to boot_params_page and let sh use the generic
>   empty_zero_page.
> * hexagon: had an amusing comment about empty_zero_page
> 
> 	/* A handy thing to have if one has the RAM. Declared in head.S */
> 
>   that unfortunately had to go :)
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Running this in an LDOM on an UltraSparc T4 sparc64, the entire LDOM
hangs after a while during boot.


> diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
> index c2d19c9a9244..2bd99944176d 100644
> --- a/arch/sparc/mm/init_64.c
> +++ b/arch/sparc/mm/init_64.c
> @@ -177,9 +177,6 @@ extern unsigned long sparc_ramdisk_image64;
>  extern unsigned int sparc_ramdisk_image;
>  extern unsigned int sparc_ramdisk_size;
>  
> -struct page *mem_map_zero __read_mostly;
> -EXPORT_SYMBOL(mem_map_zero);
> -
>  unsigned int sparc64_highest_unlocked_tlb_ent __read_mostly;
>  
>  unsigned long sparc64_kern_pri_context __read_mostly;
> @@ -2506,18 +2503,6 @@ void __init mem_init(void)
>  	 */
>  	register_page_bootmem_info();
>  
> -	/*
> -	 * Set up the zero page, mark it reserved, so that page count
> -	 * is not manipulated when freeing the page from user ptes.
> -	 */
> -	mem_map_zero = alloc_pages(GFP_KERNEL|__GFP_ZERO, 0);
> -	if (mem_map_zero == NULL) {
> -		prom_printf("paging_init: Cannot alloc zero page.\n");
> -		prom_halt();
> -	}
> -	mark_page_reserved(mem_map_zero);
> -
> -
>  	if (tlb_type == cheetah || tlb_type == cheetah_plus)
>  		cheetah_ecache_flush_init();
>  }

This just removes the mark_page_reserved(mem_map_zero) without 
replacing it with something corresponding to that. Perhaps part
of the problem?

Cheers,
Andreas



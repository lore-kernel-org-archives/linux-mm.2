Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51250EF36F7
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 07:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67BA96B0088; Mon,  9 Mar 2026 03:35:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 629666B0089; Mon,  9 Mar 2026 03:35:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 535666B008A; Mon,  9 Mar 2026 03:35:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3F8CC6B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 03:35:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C1E168D2AA
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 07:35:00 +0000 (UTC)
X-FDA: 84525713160.07.6F35F25
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf05.hostedemail.com (Postfix) with ESMTP id C9A10100003
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 07:34:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=S82gM2Jx;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=37sFK1ih;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf05.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773041699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=erREKkXABbkGYvmxVpdti4swV6Ha5+3/x20eD7gFqSI=;
	b=knE6pQdmzfpaXq28YfPauOVLb2xzR4p3hKova9Gj11Kwu6gJPVp/tO4MoIali7jx+lK7JQ
	19RFRKkoZ2yqYjGrBvvh+usAR61tCK6RYbRVxf3hxEi4rvJCb6a6Be6D5kq8pbDzMWRcV7
	eGgi6cQ/r6RXbbFMquQ3Jq+Jr/F+5Uk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773041699; a=rsa-sha256;
	cv=none;
	b=jXDb6ie5P5Vd39rfJ1w2I9U+nppUgiD8MbbtD6gnI4nUEEHwvdk+jjM+vwqG0xWBNqKvXC
	C3kuOsweOiwgUgW0E+xvB5AlMTcKMVH2RjTUwTTOti6P2d9ZAU7yIyK4bDDLYE3wFvQucS
	9UGJXEfFOhepZshZhZ/3gx0lqe8Z4bI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=S82gM2Jx;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=37sFK1ih;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf05.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
Date: Mon, 9 Mar 2026 08:34:55 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1773041696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=erREKkXABbkGYvmxVpdti4swV6Ha5+3/x20eD7gFqSI=;
	b=S82gM2Jx+axPsYux9DiBRFecth8F0F6P8ysrYnlCfbt665ZpbroetIAWoRB+ultVzvox9E
	2A2O+wcDkjsYuXODYk4wdb6QLz23loYpzJMh4tJnltuEC3Qv5OI2Cnf1SYukYX1VjmTsqO
	nV0OtuPZzg9lIxV0VvH/w7H2sZQihooaFoSniWYRPSQJfjLxH6GvwV6ctowvGXzZXGu+Yy
	j7dhtqnclxQniHEC3dboVtkziP9VtKNdinqJavgcYnaGNwbaWR4ouSrMCGDL1u8OuJ6YI/
	A/9Xh7qjs5OGXLUNGOw44da+mPmxp2Fyl2ADfEHkFaUqyc5uhzMbM7zHwdjZsw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1773041696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=erREKkXABbkGYvmxVpdti4swV6Ha5+3/x20eD7gFqSI=;
	b=37sFK1ihP0FLGdk850YWQdPbPoi9LKffiG59KV702LXIQaaljdobZkiJ5LO1vpUlnMsovj
	6K00gNZqnwUXabDg==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Mike Rapoport <rppt@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org
Subject: [BUG] SPARSEMEM broken on RISC-V; was: [PATCH] arch, mm: consolidate
 initialization of SPARSE memory model
Message-ID: <20260309082841-9c542a85-073d-4d08-8b8e-a56621a13c91@linutronix.de>
References: <20260111082105.290734-1-rppt@kernel.org>
 <20260111082105.290734-25-rppt@kernel.org>
 <20260223144108-dcace0b9-02e8-4b67-a7ce-f263bed36f26@linutronix.de>
 <aZytSwzGj24lqkLU@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aZytSwzGj24lqkLU@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C9A10100003
X-Stat-Signature: txeec8yzkjrrqj15djoncniywr7em7f1
X-Rspam-User: 
X-HE-Tag: 1773041698-931059
X-HE-Meta: U2FsdGVkX19u45fawnfgkPvgIzieWiRHHFAISzIf1+HYfpll1dVOm9VBRA+wPF/SPsBmaJnUNI+eFAPZv/FrUVo78Uw7wsMqtsO5hFDAxoXRCZBOnO/IpZLD5MLa0JTc8mhrk5Bz+PB9i8om6cfbBn8g1Xj46tnGktMQpTr8j8/WEWSwWQM0/6JCM8p2b7f0+A4x86HGbfIqURtEKat+seR9sqqq/lRTXsDtc+AcXJrKt5P9MpWkuxXIz6UvMQH6jVD1e3p8Rtrea/4cQB6YThcy2gADY39h1h2RRZq6TRRnzYeoQ4sIyKWNBfPjk5bStJhbpRkEs1P1E3ZaY2anwmZcU+72dAmTiiTdE6ymB6r2An2r9eR51ew0Lhp8ItM6vDBeNLTwrntBrJYAIwsXZd8tll3mY4HosX/sHVWH5yTXq1jZlue0CmnC98LFx4SfW6uZNP44y1Bh5/AdInyFWmbl5DREPPU0aJBs6jLiw1Vy9fBFKf2c95qC7job1j7ZmqPuUyHAU+MkDIMNm0QWLj1gSohpoa+aoWjLuTuXHBrkHy3JUC/36vDuntEI2KuX95mdp71iwmePzXpWGThhyMo5f1Qyi+HYVPdeTpcoxxXa082slp+x0AFPmjv6Svr5oeMU7lzewRYq4aWJPg45+XChFuMkprvjbkKl741lRMFqQywT/9OW0CBg/Wk9XhsVBgqneY+uthp5e6u72IbhKC8Yks33b5un+BoNqjgPJeUYBmbtG8dQtDdV46sWs7h6G++UZF6KSZ3u2ugoVG08XXxFmYet+lqvJ8WVBKJp+JmeEIm2H1B/BHHuttSrTP0ao4AIqOdapVMViOAH+DyoG2u+4lt6f5EHoibrlLDpQ8WN8iudzDBe6oy86ZI1/whhBIXn8nViBimbZIwyu8gDbOJuW6wWX5a68e4Is6bAWvMSmFmwHzxMw4dgOKVZGtTtk8KCEF7vDTIIC0R87tl
 69RDOFek
 ZDPEEonDXTrcwo3v9vZURr2EZeilSrjRC8k2zQ7zpOozNrr+i+nWJuuKYtIidO+wFg6jRWzOn31wWJRyHRSY1QRiWX57xVpUkthvVxNOPEZL4MJhgacJ5g2OtqVZMUHVKbPNCZE5q7JkKoZSm7h6WSdmHXclF08/wIGLzD7S8uBCSQuaUXBnbx6I67LOhBGYl2M5xrTr18Mn0bRyMAV/WqO+Zv4pd9BgLuLwnavGqr0RakMStclzna5qAtJ9y90MKzSykcniJhjCMWMHNGzyxWsVnO4FaDJ9c4OzaO2emz1DLPRDS+4369fo/JQ3Kz5uqxdMAaZXeAASBxGPhelo98xdZCF5c36KpLV6XOI9BytuMh7lDoD66/JCkub6IgsWjFt9hRSeXaxjZFfrbeYO8d5Ovgm8FUliUCj7BGXG/YNvGluo2IyGsYrV/Xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi RISC-V maintainers,

SPARSEMEM on RISC-V is currently broken in mainline.
Could you take a look at my report and the suggestions from Mike below?

On Mon, Feb 23, 2026 at 09:40:59PM +0200, Mike Rapoport wrote:
> On Mon, Feb 23, 2026 at 02:52:45PM +0100, Thomas Weißschuh wrote:
> > On Sun, Jan 11, 2026 at 10:20:58AM +0200, Mike Rapoport wrote:
> > > Every architecture calls sparse_init() during setup_arch() although the
> > > data structures created by sparse_init() are not used until the
> > > initialization of the core MM.
> > > 
> > > Beside the code duplication, calling sparse_init() from architecture
> > > specific code causes ordering differences of vmemmap and HVO initialization
> > > on different architectures.
> > > 
> > > Move the call to sparse_init() from architecture specific code to
> > > free_area_init() to ensure that vmemmap and HVO initialization order is
> > > always the same.
> > 
> > This broke the boot on RISC-V 32-bit (rv32_defconfig) for me.
> > 
> > Specifically if sparse_init() is *not* called before the following callchain,
> > the kernel dies at that point.
> > 
> > start_kernel()
> >   setup_arch()
> >     apply_boot_alternatives()
> >       _apply_alternatives()
> >         riscv_cpufeature_patch_func()
> >           patch_text_nosync()
> >           riscv_alternative_fix_offsets()
> 
> Hm, most architectures do alternatives patching much later in the boot,
> when much more subsystems (including mm) is already initialized.
> 
> Any particular reason riscv does it that early? 
>  
> > Simple reproducer, using kunit:
> > 
> > ./tools/testing/kunit/kunit.py run --raw_output=all --make_options LLVM=1 --arch riscv32 --kconfig_add CONFIG_SPARSEMEM_MANUAL=y --kconfig_add CONFIG_SPARSEMEM=y
> 
> Looking at patch_map it's quite clear why movement of sparse_init() cased a
> crash:
> 
> 	if (core_kernel_text(uintaddr) || is_kernel_exittext(uintaddr))
> 		page = phys_to_page(__pa_symbol(addr));
> 
> phys_to_page() with CONFIG_SPARSEMEM=y will try to access memory section
> that are initialized in sparse_init().
> 
> What I don't understand is why patch_map() needs a struct page for kernel
> text patching at all, __pa_symbol() should work just fine.
> And the BUG_ON(!page) is completely bogus for phys_to_page() conversion,
> because that one is pure arithmetics.
> 
> If moving apply_boot_alternatives() is not an option for riscv, something
> like the patch below should fix the issue with access to nonexistent
> memory sections. But I think moving apply_boot_alternatives() later in boot
> would make things less fragile.
> 
> diff --git a/arch/riscv/kernel/patch.c b/arch/riscv/kernel/patch.c
> index db13c9ddf9e3..89b3c13f2865 100644
> --- a/arch/riscv/kernel/patch.c
> +++ b/arch/riscv/kernel/patch.c
> @@ -43,18 +43,19 @@ static __always_inline void *patch_map(void *addr, const unsigned int fixmap)
>  {
>  	uintptr_t uintaddr = (uintptr_t) addr;
>  	struct page *page;
> +	phys_addr_t phys;
>  
> -	if (core_kernel_text(uintaddr) || is_kernel_exittext(uintaddr))
> -		page = phys_to_page(__pa_symbol(addr));
> -	else if (IS_ENABLED(CONFIG_STRICT_MODULE_RWX))
> +	if (core_kernel_text(uintaddr) || is_kernel_exittext(uintaddr)) {
> +		phys = __pa_symbol(addr);
> +	} else if (IS_ENABLED(CONFIG_STRICT_MODULE_RWX)) {
>  		page = vmalloc_to_page(addr);
> -	else
> +		BUG_ON(!page);
> +		phys = page_to_phys(page);
> +	} else {
>  		return addr;
> +	}
>  
> -	BUG_ON(!page);
> -
> -	return (void *)set_fixmap_offset(fixmap, page_to_phys(page) +
> -					 offset_in_page(addr));
> +	return (void *)set_fixmap_offset(fixmap, phys + offset_in_page(addr));
>  }
>  
>  static void patch_unmap(int fixmap)


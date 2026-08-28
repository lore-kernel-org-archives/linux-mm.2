Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88485C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 13:59:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2D2B6B0088; Fri, 28 Aug 2026 09:59:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A04406B008A; Fri, 28 Aug 2026 09:59:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91A9A6B0098; Fri, 28 Aug 2026 09:59:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 752986B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:59:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0659BA3D48
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:59:54 +0000 (UTC)
X-FDA: 85150836708.14.7D2D30C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 23C9640006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:59:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lDLgEYHx;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787925592;
	b=rIUz6AZ+BbmSATON0newGkaDSMEJKw0F1sB2nhIyTxJGxY/g6ZhgjN39O9RtiaT3QBVmob
	uUilSzTSdXqB6LlMze668bD8d9Q2FnVPakb72SedlH13CER01N7Nof7fxaW6fBXzmEPBWW
	3K2l5TW1bRMCA+tauAQjjYyCe0O1iRE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lDLgEYHx;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787925592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GMsq4s9H5sslOOoHpaDnzK693uMuIdL+zLKvHUgSCOw=;
	b=aAuxGnky6WUG/V5lyllcPYW9Odb9MGpDpUX/t4Ip3NwwDYD1FodSFn64SJSEjAHZgYKgzl
	pOsSI9Rmd12lmC6WJLxwAlc5bNKg7RoM9zzABz0JTrIZmNgl76MffUEJ19ABDIHyVsE7ce
	jZs1qRuindr9lRj3X00oj3/PrGGBka4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A9D5260208;
	Fri, 28 Aug 2026 13:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122FC1F00A3A;
	Fri, 28 Aug 2026 13:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787925591;
	bh=GMsq4s9H5sslOOoHpaDnzK693uMuIdL+zLKvHUgSCOw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lDLgEYHxqyMExx7XGHQ1jMOssFVfuXXHoEzbBFpy5flN3Ib4Bd3XgGWIWJMp6arLJ
	 uQVbfv7J5ZyA4dhS8/bZdYE+uBBMnrDV8e0fo5PloBITeSUDghfkfYw1D9c5wdWYwu
	 XZQit9lHQy1bSrPTtaQxgXbGCzJ7ybYZKFJ2vKJmyZ3gfcQ9S9Zux7MV4EHTe8WKIF
	 cQvwZk10zsIwVNSeF02O73cQgZkIW8VKvcKbmR4S3FO1bWytcWw/EKysYqo2DV0DeN
	 8tK1MPeAD1ya67qILgrYnKWGC/cyVNaPzFTPrj302CK1H26FHwBHo62CzeDmiZRHiZ
	 FnDhPRSM8Ictw==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.ams.internal (Postfix) with ESMTP id 8F1C61980045;
	Fri, 28 Aug 2026 09:59:45 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Fri, 28 Aug 2026 09:59:48 -0400
X-ME-Sender: <xms:UZSRapkyHK92xpfCc7gC34L_khXR3QDyMijHbidWAs220sKQ8lkFUg>
    <xme:UZSRan8Dpwoy1eVqQ6ejwtpK5aDyWpuAHSF3GZvcF9ux2kRifDcfxgdrhN5UbMiT2
    kcCkZeB7jDWyXr2cnergQkITcqHPmjzoSUgbqYkVaV59rMStIDBniI>
X-ME-Received: <xmr:UZSRatEolRX4Ox6wFQ1OGkjYzS9-u6dOHl9Sw-ITv6dXf-KAx_Tttsv0TF8>
X-ME-Proxy-Cause: dmFkZTFllgFcBPPxWyh7H7Ya97cPF2z+CaYPZAeFHJRUEOI7iP7NbK/RD+h7m0XG7mWy16
    fIZCnkd80l4AcUG6PCl7E90y1FlqRmxxmociQ31S8wZQTE+r/ShOn2X3FGZoq2J0Vdf97p
    nuFw4AqeM/WomfxoyRgLOaOyXPCImUEPhxoNz4O6fJf9J9swOyN5utIVT2r0XabJbA4HxF
    oILQMURKy3DfTYUUGeeYdtTqPn4upMBcTfKSGqNc5c6xt9AM949lwP1kFNdph86l+6pYNc
    RLrozyUVEmo7eSsWX5/dVPnhXM37BJYxN8ROLEVvUcuC0Xxxx2BGLKc00OiMUuXhlN+6X0
    1vEX6V9DH/wtIWZy7pT2JUHc34pYq9bNE1mhzx6gPcCLaoh6ZOIx6UPo5fsw2jPVelT/oM
    +RkCwxR1y6cCiBY7aJLTWgDUQPbYSswR7CrwcwhuhPYs7IJmoS7+ghC4sDkXaU/AkAnIJc
    Gu0NQkXGvpCFrPL0K1sJJ0/HBEE6GTdYLrk1kEZpfjVXn0h1VASbWIyC8kJ92dmWrjl1FK
    b/EgQHbOIgf+5hE5GMQ3LfKop5IEUj8L2oPdH4UNTLw/ZUAu52OAWj7ERMa3mq8u4Fpfvf
    n43K7EzhAX+ZsBpBswrS7KKCqwtaiiqzNVHDXonWeXfntyQUnXrftzSFTLNg
X-ME-Proxy: <xmx:UZSRauKl_CC_sQ4ifO52hn5UJgg2-F_7akOIxsy_CfM2VI_jq2wh2w>
    <xmx:UZSRamfb0Cvb9NxgQOQKnEarX-NxrqGf7K4MrHcRGhmLSPArbpa-Mg>
    <xmx:UZSRamXYit9R7Sub6lx6kW99a3nAu5AU_EaeCy2263Rn6OZWl3cyFA>
    <xmx:UZSRauCS1sl_ngYBSDZMZE-MXPsW_dD3EDJf5Eky0u9G8cqeVWsMZA>
    <xmx:UZSRat9eai9o-Upb0C9Q7D893HN4Q13Z1LausSAOpkC8N-eK7DnIl2aI>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 28 Aug 2026 09:59:44 -0400 (EDT)
Date: Fri, 28 Aug 2026 14:59:43 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-efi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
	kernel-team@meta.com
Subject: Re: [PATCH v3 2/5] mm/memory-failure: libstub: install the
 poisoned-memory EFI table
Message-ID: <apGSy78NoCov0MWr@thinkstation>
References: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
 <20260826-hwpoison-kho-v3-2-6f79c4b605bc@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826-hwpoison-kho-v3-2-6f79c4b605bc@debian.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 23C9640006
X-Stat-Signature: io1kroo4jn6f8ds4zeuthsdsuoxhd1o6
X-HE-Tag: 1787925591-816101
X-HE-Meta: U2FsdGVkX19L1+3+3PKwMnyJH2D46VVFdHcdxyxv5yCdQ2FNFYEfzxQoCil15YC9FkP3JOvScImg7vQdwzibDzTB55sRYOpuPHnrdOHfu75KXmzXchWabguySoNs9egXjGGpYheVkvd3LxLSWz63YamXhfNvV9xOvG8CT4oVIwsHa2Qvveho7yxPZz6t8HusoqC6MuTHntW5jcEvPlnb15JgOKWg7T3/l25f6BZe4ifTR2qMTDVh29I5mffZ2tm0aiSa90NqChS+AAnax7hwfTY15YsxNiahrrRz81Xsn7DKvgoRWRqXeDZ23o8zTHvZnsm5UIbLyG/W3xfxeHkAd8zeBFYl1dKhfiPphTyLBJCjAEE22V686WsNZUmnP0PRlKB5HNGZanLh2uLmxiKxSYfFmks1KjBJr6SU/6kndEMj1MhrYRrWxxmuuHLDYk5WsDtYSnMj6DdxVj/itRNgeM4ix1oo/qpbkPAhR6CSK7CE8dzaxqXVeHJzmw9t3Eof7bQwnNAbaEZXMTIYRixzT/we26lXPkUN3kBXYOeD+vSrMmJN6fLOD5JPyzWR3cEMyYomFBNj6YifCUMc1boRxHah6s7+60pqEUGtXfgt/++ADI+oTLFzDh2byN0T3I2X7PF4IJOL82X4eEY7XZ4CTPvY2gt+efT1rSnWGIpehtR5pFj7iSB+n+bOFlKQ5i57/XxgLNhRZ1Q7PjwmDKkhDFjMDaEgZQB5YSUMOhO1HieHhJTf3+0vu/zIZOVvSDSJ1Hxe+noWG7/zH92aQDQ3Zq0ufEHBUBNyB30H0FxRwQ/uxL0RJJ0nBT2cpIIwmhS2cmKCN+3DK18aZ+8mv4HntHBIOH6HFDgG69/vvx28I5/lKMoyzLbgnPNTH8DhBUiPpOzfKvogNHyfaH8kTWx0/2bX49VEuT8XEUjOgq/9I+SkqjeCzb/DZ8yOYrU6wCVwuyD8sO4wFHOY28M+Ktn
 /hGJlxZZ
 IE4WDo62ZPeEaJRsV3IGxY1OwEhzSmF/OYI9YfirALi68lW9cQaPQ97A0UKWVEZfVnp7F2BRnFb+Wb6B9WFDIXNH6PrLhTlwUIkgc/IoDkufU580vbdtaiD3kxfy/gM+SaXxwhB5EGYrucK5MOHrsR3nue8Rm8yrwxB/H5MrE4zfTEcbjonyEej1IiWXOB/cZe0HviZKsKt0TI6cn6FTuuL37XTCD4owSjWe67BSlLeTCnGfwRc6Pt8cLlSY05D9/p7/vZlp9IpPJeqd0JUGaWObXLfNgIVNJkuKBwyLHEVEkOYLT0zuC6zhkOQoeDLv24IMNXBcq1qhEUajVWjZZx8lczLpL3Vtf0cEq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 05:03:53AM -0700, Breno Leitao wrote:
> A EFI config table can only be installed while boot services are still
> up, so the stub has to create it; the running kernel can only flip bits
> in a table that already exists.
> 
> Size the bitmap from the top of usable RAM, which efi_get_ram_top()
> works out by walking the UEFI memory map, since the stub has no max_pfn.
> Bit N covers unit N counting from address 0, so the table tracks
> max_pfn. Memory the firmware hot-adds later sits above it and is not
> carried across a kexec.
> 
> One table has to serve every architecture, so efi_get_ram_top() takes
> the union of the memory types they turn into RAM: what setup_e820() maps
> to E820_TYPE_RAM on x86, plus the EFI_ACPI_RECLAIM_MEMORY and
> EFI_PERSISTENT_MEMORY that is_usable_memory() accepts on arm64. Sizing
> wide only costs bitmap bytes; sizing narrow silently drops the records
> for every frame above the top.

x86 and ARM doesn't seem to agree what RAM is. On x86 it is by ->type
and on ARM it is by ->attribute (anything WB/WC/WT).

is_usable_memory() only decides nomap. Everything is_memory() lets in
lands in memblock.memory, and max_pfn is PFN_DOWN(memblock_end_of_DRAM()),
so the top of RAM there can be a type that is not on your list.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov


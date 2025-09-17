Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2513CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 17:52:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07B62280007; Wed, 17 Sep 2025 13:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02C19280002; Wed, 17 Sep 2025 13:52:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5DAF280007; Wed, 17 Sep 2025 13:52:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D1712280002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:52:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 863E61DF8EF
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:52:42 +0000 (UTC)
X-FDA: 83899487364.22.AA3548A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id CA7FD180012
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:52:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="EcN9R/Tr";
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758131561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9TFvqjlh2RTZrYKeLF5M597y/SnnQIvAiFkoD/c1uFE=;
	b=ka4jf/NfT8v+qnUsd4RaqeHpU6ElixYt3SjYEaBj9hEoMUA1hePwUCdgsOvBoR0vJI69UH
	uOgPGjEFFqoxYtU8XlylyVeufW8nAw+hO/oW+bUNal3r9y+Ka/fBlo8+CVUZlLAsOaOxbs
	2Q1QaXZT33kW8D1JdGT1YOazAFVUg6k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="EcN9R/Tr";
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758131561; a=rsa-sha256;
	cv=none;
	b=BXYGG9tFm7lFa7kSM8UOGtzrFKWa/Ni/SbxYLvdZIfT5OZHfpZLTlujBdsSOAgXteE7+Yf
	Qe+D7WlCese8/uMSfbFpGwFob0qoayuEQTtGACgHxfL1ti9LCMkFGTOIMdtaPtwFF7VJFf
	ug6h0SHRYROrj+Lb5vEP+cdH78HzYUA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B93C41831;
	Wed, 17 Sep 2025 17:52:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9E5C4CEF7;
	Wed, 17 Sep 2025 17:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758131559;
	bh=0SeyaT8+bz/I8XaOI5kg2LZdHBHQvUyjeoTzR45r53g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EcN9R/TroM+76zuwCRHHlFotgG8u6yNOacYJ/E+M27GlY7UvbEFph9bmCBH5FY0Wv
	 ZaetVpZzXhfM+zYpEfmtcfxYS0uojPUXq16GufgOBUnOKp1t4oZ6g6zdFECD5yYs2c
	 TjQAAv1NiqWkSOmcfxuDp77119G5Xmvkk7UTllZwFnb1hMs6maVdA+Ia5SyiG2HllO
	 qAIFTvFFaiwGIndHs9Jc5s3HK2CNXQ91I+1JQKbrigfQd4RsYibZTPUDIB3luJhX9E
	 eWhX6/q5eaaai/G5QCu5V4R8p7dFvt5w7NkodxOBhMkEYZomBskwmVV090EUefDbsT
	 8we5SSr+BgiwQ==
Date: Wed, 17 Sep 2025 20:52:28 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jason Miu <jasonmiu@google.com>
Cc: Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joel Granados <joel.granados@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Petr Mladek <pmladek@suse.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	Steven Chen <chenste@linux.microsoft.com>,
	Yan Zhao <yan.y.zhao@intel.com>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC v1 2/4] kho: Adopt KHO page tables and remove serialization
Message-ID: <aMr1XAKmyfzM8RCc@kernel.org>
References: <20250917025019.1585041-1-jasonmiu@google.com>
 <20250917025019.1585041-3-jasonmiu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917025019.1585041-3-jasonmiu@google.com>
X-Rspamd-Queue-Id: CA7FD180012
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: skjkiynbgqe99jj5h619rqctzos4yzgc
X-HE-Tag: 1758131560-971763
X-HE-Meta: U2FsdGVkX1+o2mUz+dMSvE4RUE6Q4K2uw33T8lUldPtBStVp/LgCLb7Lou2OFPyQcha/9roifvh2qZye0Arb6D+zm3MnKPr8Z1LAxTA/SocLJK0qCZ5egXSS4T6NoWmuoTS6BkSorEiY3ByLc/HVeiW+dvcxPyUgYfF4UEMv9l5If3bM3bPZydbhVnhlSaULuf76TbWdpkQMpDkCbPrJC37v3l4DhGbGW3zlH/3aaK5XnAKEJ2Ro94El+KXDUTie/12JPSEJ5KnZiJ4w+LZ4LQJgioNQ2Jy3HZ3ng96fZpeesru/Xzbfpbn73uQNSD3b1IoJXPOTSu+YnRi3qN+KWGHouCSVANw68oOulqvXPWUYqkCqafriZVPFcSab+hHiHyE32S3ZYBgO4Ru3p0eMiaO+DTkZOYnfi6Qttke/mkrCJg5Q79YlflC8DaVKhLJmUMRxrZKrpgBkZFuEglekkFwgt2wAF5SeTBlaUk+Q5wAznh7AxABpQEGrv+tbA+sDgFAZfGecnHLH86O0IxqCdeUZN4rQBIBx5vjuW9JEVRnvSd8L4PqM0gd2nLQyG1g8QOeGk8PCVf4H95Unm/HwANz6v6AiLIxOQK/7zH5lTUBuKfBtbGnJfrCKo2RpPZZnKxje0U94E6uM8KxbXtheLJLFnkyHTlml18D/Y3sBm2H41x5nNnpav6Z0yX5AjiHeDQwnXlQi/AKi4wVd4cMRZA1RPah4kH9AgOGiUFm2w3RKEwCfReEoLgDXgp92HVABJnIblDwF3x5PZlMbpX0xK2FiyYV+qMOvA+q99x7195YBwnK+M3kqvN3IbRv4IXaonYhETySWMrqaZYumIe96JS5yEe/N+0oJqbSXO1ccMP6PXEpdhGFbRa5cgnmeblGl+FU7+i6wwmGxMRKa/NmunqwGqzfUqahSswd7IUrQq5dQ3tXCGf5GPg44bL+8NX6Sap1hw8N0941YIK9KSCH
 FOh5SEg/
 OONmaWGlKkhhXvH4lWzOK/syjNl5eVZbekJVrnlKSC2MRUGpJTWSmxR6Ve2QwcSKfysEDP3wQQGZUvn+RdC4cvmp6Ekw/ioYlmO3YbEqS452gTiGlgOnta5Qgg7I6TIeUb3LbHzeP8YzB7F3AaiVhCvncWwcLnTtjxL2dt8LNU+a+F5oEJG52RqW3sUzqJzLbNayVZjwn+kK7oZY4r0RRgvOxPSn3neRmvaZP7YrmfH8I0lazg4m6N7Whx8wVcVyFEWytZHgnBxYvC2ZrTj37lGSEjg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jason,

On Tue, Sep 16, 2025 at 07:50:17PM -0700, Jason Miu wrote:
> Transition the KHO system to use the new page table data structures
> for managing preserved memory, replacing the previous xarray-based
> approach. Remove the serialization process and the associated
> finalization and abort logic.
> 
> Update the methods for marking memory to be preserved to use the KHO
> page table hierarchy. Remove the former system of tracking preserved
> pages using an xarray-based structure.
> 
> Change the method of passing preserved memory information to the next
> kernel to be direct. Instead of serializing the memory map, place the
> physical address of the `kho_order_table`, which holds the roots of
> the KHO page tables for each order, in the FDT. Remove the explicit
> `kho_finalize()` and `kho_abort()` functions and the logic supporting
> the finalize and abort states, as they are no longer needed. This
> simplifies the KHO lifecycle.
> 
> Enable the next kernel's initialization process to read the
> `kho_order_table` address from the FDT. The kernel will then traverse
> the KHO page table structures to discover all preserved memory
> regions, reserving them to prevent early boot-time allocators from
> overwriting them.
> 
> This architectural shift to using a shared page table structure
> simplifies the KHO design and eliminates the overhead of serializing
> and deserializing the preserved memory map.
> 
> Signed-off-by: Jason Miu <jasonmiu@google.com>
> ---
>  include/linux/kexec_handover.h |  17 --
>  kernel/kexec_handover.c        | 532 +++++----------------------------
>  2 files changed, 71 insertions(+), 478 deletions(-)
>  
> -/*
> - * TODO: __maybe_unused is added to the functions:
> - * kho_preserve_page_table()
> - * kho_walk_tables()
> - * kho_memblock_reserve()
> - * since they are not actually being called in this change.
> - * __maybe_unused will be removed in the next patch.
> - */
> -static __maybe_unused int kho_preserve_page_table(unsigned long pfn, int order)
> +static int kho_preserve_page_table(unsigned long pfn, int order)

Just merge this and the previous patch so that the patch will replace the
current preservation mechanism with a new one.

>  {
>  	unsigned long pa = PFN_PHYS(pfn);
>  
> @@ -365,8 +357,8 @@ static int __kho_walk_page_tables(int order, int level,
>  	return 0;
>  }
>  

...

> @@ -1023,12 +752,8 @@ int kho_preserve_folio(struct folio *folio)
>  {
>  	const unsigned long pfn = folio_pfn(folio);
>  	const unsigned int order = folio_order(folio);
> -	struct kho_mem_track *track = &kho_out.ser.track;
> -
> -	if (kho_out.finalized)
> -		return -EBUSY;
>  
> -	return __kho_preserve_order(track, pfn, order);
> +	return kho_preserve_page_table(pfn, order);

I don't think we should "rename" __kho_preserve_order() to
kho_preserve_page_table(). __kho_preserve_order() could use the new data
structure, or call the new implementation, but I don't see a reason to
replace it.

-- 
Sincerely yours,
Mike.


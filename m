Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D6CDEA8126
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 15:09:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DE236B0093; Tue, 10 Feb 2026 10:09:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76AD16B0095; Tue, 10 Feb 2026 10:09:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 660046B0096; Tue, 10 Feb 2026 10:09:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 51BD76B0093
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 10:09:38 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 04BF61603CB
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:09:37 +0000 (UTC)
X-FDA: 84428881236.22.D9BF051
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 402CB40010
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:09:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VdoawcPU;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770736176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tZqWOn6nM7zDPbQvvqMXHKEeR4Bn050FwLe6HRcqGmU=;
	b=o1jv9MngIsoMTdNUmXm5PTL+ycKXEJUdw1Zq06a/Rwq6cvwF/RKRg97L1yFbh+51Jlo+FL
	YnnM2tBZ+ApFY8silFAQTObvN30ZfdxEaiBg6kO6YCVtGL+xA6bLPJHyGyxBPf1IljHRc8
	PmhAcax6vITURV/T1txOJ+3lEABMIR8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VdoawcPU;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770736176; a=rsa-sha256;
	cv=none;
	b=Zjf9wvLSk8bc8n0wrchzZfxtkwwZAro0O4Lronf5qGGDXMAnuoOXbjUrIauHvr/YBw5lx2
	FZSrJuNMMrbv+sUCd4a/dc3V7iJBlF+dgq5XLGFLkn1vM7E9w3/YQ3T0CcD+WFgbN95+0z
	af6YKRxb3Amq09nC6bf7ctc+eKJPyGk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 12A3A443A9;
	Tue, 10 Feb 2026 15:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA02C19421;
	Tue, 10 Feb 2026 15:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770736174;
	bh=s/009tO/uoAW8gW8CH7txHUInh05s9+ISLI8TUUR38M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VdoawcPU3pX+D8rF50VjcDAndYGaq86GorjJ9aukdRXku0zA3Fw6p2dOwqQtRNiSv
	 tgVK7NwQMvx3J20AB/r8Q3AGl02aw+fUizk+J/c0haKUfWpBnffZ9goqRWMnI9fkGY
	 P/JgUk3ev+ul4M6bvVbqWwu1W5D0T7/58XChisOa3QEcxa2sWJnYIbX4db2ilQ75xB
	 EZBehxpuhgZ181BYTfo2FdPCtz43kPHHhxvF8fDRPlFenll9X6bMOr3+vbMslvLi7V
	 Cq7F+fQ93cyTcBC+yxjG8aoLExRhaq6Z/aK5/q/x/Nw5F5UCptpkZHqBFiijoKDMkG
	 2idMLHv2Ujf7Q==
Date: Tue, 10 Feb 2026 17:09:28 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Michal Clapinski <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] kho: add support for deferred struct page init
Message-ID: <aYtKKB-yKu-fwp3j@kernel.org>
References: <20260210130418.297153-1-mclapinski@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260210130418.297153-1-mclapinski@google.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 402CB40010
X-Stat-Signature: n9w5a6yoqaaje5y8my8stfod4cm9pic3
X-Rspam-User: 
X-HE-Tag: 1770736176-268600
X-HE-Meta: U2FsdGVkX19D0miIK4Fehx7ovdM/yRLmbn6uMWSpuG/aP3MmreUucsVSJTDsW2aFH83FTn+QRBB403GGtuOTN28xHz+P6XO27V3EfqpYkYgVX9MmjvWr8Y6jfMu/jbRzy671cF4sXEcpAqcfjq4Bw6GntV/VLws5qdHwE3WOxiCsKBSImObrrG5UST8GUYvOGiJHyf8ObbJ2AuHW8K0/Cxwy5jv4W8Iywube/n7u5qa1PApDlD/XEEVplNOq1Hqqh2ibFelLBRHxSwgJbXwddiQLSb2I6eBLmtxxOJLq9oydxymGB/8D1ZCG9DQ3vJjyKU368F/m7JjhA7zrvEcTpLW/lsKc5EjtsXcATQuOzSzeP3Ei0oVzrtSnkHdM7e9c6vLZKizDOpVk7X3Or7dOtf0deOiSExXGCgmBZ8Uno4nTiLJSbJfUJ3u0Sx+Tump3oMdNP4WSr4sfiWCW2IzbQ07zf8pTH+C3VwC0uJh51hA0BjyXT/Hj/c1PSNoqsd3RBG0WY+L3EWojd93YSIFxxeJhZlQeOVNYkvb76GcDKZJE+UZLMOeeaw8inWD1/1DEEaR37dAI940zf2O6tPnAAl4yvd/MIsX9drBuuS5F8yo9sq0cZBs66iQDnvscNlkurN8bxr+/Jj9PEu8Yjkru+ixHrAOMvHlQ6k2MVHafjxHV5qeEjX8h8ltNwQIYX3vfU2Os4RLwNt2qtU4Zwyp6YR/2UOEahySeGVFATV+eblHkbmv23h+O8iE/5t49OG3LXKnln3MleOvdqn5lSTWrYoJj2SbEd0R6zPpLIAaWJ8Wi4FrHqt/6l6q4liUV1o2xFlNVz2EHKy2caFPnTQAOJSSHYFB4nIHJJ06gcrYgvQ2Pjsxl5ZHE1fAv2bkMPG06Ixtsw9aKWVezJiXLWn7Lw2kXwQLK2jz46/CkGxJYnwwrAOy/VWNaWger9PmR3sNd2lo5rvssocWen/zomh9
 Aj5ZOrj3
 yyRimdrP42JMfCObzO5EHVzv/TlCW7WG7JV/O3nWDCoT4zQbdT1te1YkyahUksu5itNyodi0Je7OeqZ+2oGtb531jqa/Tm0ojJvNXRbufBqB3UHnpWdxMCFBYqRY3ilgd4JVrGjqXYQM90th1p1V91wz0vHEXK8moB0AZT84oH9m+zhiw9bZiikQqfTMY3KxS8WG2iQ+u/pN0mb4wk68b+XC0E6krO4Ijr2DXrVwhKuAF2nfPgUv3h0yTiq0FXgHaUw4ATGyDFum/I4Ft73cn20UlERRfqeKfFne/3SiqARzxNcLJ8G+mqs34M9tTRV5dWwsvdYMm85hBv3IM08xdYsCMFw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Michal,

On Tue, Feb 10, 2026 at 02:04:18PM +0100, Michal Clapinski wrote:
> When `CONFIG_DEFERRED_STRUCT_PAGE_INIT` is enabled, struct page
> initialization is deferred to parallel kthreads that run later
> in the boot process.
> 
> During KHO restoration, `deserialize_bitmap()` writes metadata for
> each preserved memory region. However, if the struct page has not been
> initialized, this write targets uninitialized memory, potentially
> leading to errors like:
> ```
> BUG: unable to handle page fault for address: ...
> ```
> 
> Fix this by introducing `kho_get_preserved_page()`,  which ensures
> all struct pages in a preserved region are initialized by calling
> `init_deferred_page()` which is a no-op when deferred init is disabled
> or when the struct page is already initialized.

Please drop md-style markup, plain text is fine :)
 
> Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
> Signed-off-by: Michal Clapinski <mclapinski@google.com>
> ---
> v2: updated a comment
> 
> I think we can't initialize those struct pages in kho_restore_page.
> I encountered this stack:
>   page_zone(start_page)
>   __pageblock_pfn_to_page
>   set_zone_contiguous
>   page_alloc_init_late
> 
> So, at the end of page_alloc_init_late struct pages are expected to be
> already initialized. set_zone_contiguous() looks at the first and last
> struct page of each pageblock in each populated zone to figure out if
> the zone is contiguous. If a kho page lands on a pageblock boundary,
> this will lead to access of an uninitialized struct page.
> There is also page_ext_init that invokes pfn_to_nid, which calls
> page_to_nid for each section-aligned page.
> There might be other places that do something similar. Therefore, it's
> a good idea to initialize all struct pages by the end of deferred
> struct page init. That's why I'm resending Evangelos's patch.
> 
> I also tried to implement Pratyush's idea, i.e. iterate over zones,
> then get node from zone. I didn't notice any performance difference
> even with 8GB of kho.
> 
> I repeated Evangelos's testing:
> In order to test the fix, I modified the KHO selftest, to allocate more
> memory and do so from higher memory to trigger the incompatibility. The
> branch with those changes can be found in:
> https://git.infradead.org/?p=users/vpetrog/linux.git;a=shortlog;h=refs/heads/kho-deferred-struct-page-init
> ---
>  kernel/liveupdate/Kconfig          |  2 --
>  kernel/liveupdate/kexec_handover.c | 23 ++++++++++++++++++++++-
>  2 files changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> index 1a8513f16ef7..c13af38ba23a 100644
> --- a/kernel/liveupdate/Kconfig
> +++ b/kernel/liveupdate/Kconfig
> @@ -1,12 +1,10 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  
>  menu "Live Update and Kexec HandOver"
> -	depends on !DEFERRED_STRUCT_PAGE_INIT
>  
>  config KEXEC_HANDOVER
>  	bool "kexec handover"
>  	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
> -	depends on !DEFERRED_STRUCT_PAGE_INIT
>  	select MEMBLOCK_KHO_SCRATCH
>  	select KEXEC_FILE
>  	select LIBFDT
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index b851b09a8e99..26bb45b25809 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -457,6 +457,27 @@ static int kho_mem_serialize(struct kho_out *kho_out)
>  	return err;
>  }
>  
> +/*
> + * With CONFIG_DEFERRED_STRUCT_PAGE_INIT, struct pages in higher memory regions
> + * may not be initialized yet at the time KHO deserializes preserved memory.
> + * KHO uses the struct page to store metadata and a later initialization would
> + * overwrite it.
> + * Ensure all the struct pages in the preservation are
> + * initialized. deserialize_bitmap() marks the reservation as noinit to make
> + * sure they don't get re-initialized later.
> + */
> +static struct page *__init kho_get_preserved_page(phys_addr_t phys,
> +						  unsigned int order)
> +{
> +	unsigned long pfn = PHYS_PFN(phys);
> +	int nid = early_pfn_to_nid(pfn);

Getting nid when CONFIG_DEFERRED_STRUCT_PAGE_INIT=n is a pure overhead
because struct pages are initialized before KHO kho_mem_deserialize().

Other than that LGTM.

> +
> +	for (int i = 0; i < (1 << order); i++)
> +		init_deferred_page(pfn + i, nid);
> +
> +	return pfn_to_page(pfn);
> +}
> +
>  static void __init deserialize_bitmap(unsigned int order,
>  				      struct khoser_mem_bitmap_ptr *elm)
>  {
> @@ -467,7 +488,7 @@ static void __init deserialize_bitmap(unsigned int order,
>  		int sz = 1 << (order + PAGE_SHIFT);
>  		phys_addr_t phys =
>  			elm->phys_start + (bit << (order + PAGE_SHIFT));
> -		struct page *page = phys_to_page(phys);
> +		struct page *page = kho_get_preserved_page(phys, order);
>  		union kho_page_info info;
>  
>  		memblock_reserve(phys, sz);
> -- 
> 2.53.0.rc2.204.g2597b5adb4-goog
> 

-- 
Sincerely yours,
Mike.


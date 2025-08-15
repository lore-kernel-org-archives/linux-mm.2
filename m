Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C13CA0EE6
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:12:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C81E090023F; Fri, 15 Aug 2025 05:12:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0C6D8E0002; Fri, 15 Aug 2025 05:12:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD39390023F; Fri, 15 Aug 2025 05:12:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 98B648E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:12:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F2F411815B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:12:37 +0000 (UTC)
X-FDA: 83778426354.29.F25ABCD
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf03.hostedemail.com (Postfix) with ESMTP id BC4B12000C
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:12:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k64qKfJ6;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755249155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z6jMVoNjuLExgM2DNeijTwj09vj8ODT4Hf5Hk3P1Q4M=;
	b=pIKjKNtqT6/cRo9TYYf6QFVG/s3bZMTgD6Mb+kskRUEaRZ2Cyk1R+TtEU1YAeAs6jHXLu6
	eG0XPjrRmd06cF3zNQpbme4t5DZnmGdPl2l+XS1APKw3mVOPBLRcG9tXijotymcSd15uvD
	qlGeVzDzWWXvpBCd87gHIPN5yEqmzE4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k64qKfJ6;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755249155; a=rsa-sha256;
	cv=none;
	b=y8iaTL3t7B6N2w8sch88K1Ey2DxSaxkC8dFAEUra65NeE9aDIJnLMerSU2PqUpiV7s/1EE
	ad8jNIx/u3daPcvr5C+tBDO/bv1Sk8CpHphUp6tOLy/T4vuUnEe4hEddqsgOgjQO4kVnYC
	rXxDa44fcgv0xjlzdZseilpGiV61J8s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 7B78F5C48E2;
	Fri, 15 Aug 2025 09:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36ED2C4CEEB;
	Fri, 15 Aug 2025 09:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755249154;
	bh=NCVfEVQN6LHwkNoCyqO9selISDvFLOPAgNrIg0ejz0k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k64qKfJ6zNJDhsnuWxR0fgqX3BVaqQwvdZElR/klQAEoCxi1g56cxeHTAZN0/wswK
	 Pq+3GThmFMau+x8U6BogKChu5yqp5BwT3RbxGdJVY+yxVsA/3n3361XvguUQYtAzo0
	 CwsxkbStJHs9RAUy1BQLHDF5j08YA23EQWtialVtSTBmcZtV4ZgvbsnBJMyvgGhChp
	 CJH00Qs5o00iwlgrtxYWMVa2jp4VjDFoGjgtjzcCsiVePDp+01FqKPujeYxhNnJ5cJ
	 L4zaOZ7N9WkPfF3VfgjAaCkkSQpngOXjnWintiz60FKc8w0raVBwqKL8kvbukYzLFm
	 Bt1jthD93yq4g==
Date: Fri, 15 Aug 2025 12:12:10 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, pratyush@kernel.org,
	jasonmiu@google.com, graf@amazon.com, changyuanl@google.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com,
	witu@nvidia.com
Subject: Re: [PATCH v3 07/30] kho: add interfaces to unpreserve folios and
 physical memory ranges
Message-ID: <aJ756q-wWJV37fMm@kernel.org>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-8-pasha.tatashin@soleen.com>
 <20250814132233.GB802098@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814132233.GB802098@nvidia.com>
X-Stat-Signature: zdhbwpamfddk99b5wmbxr1mefxnpo3cd
X-Rspam-User: 
X-Rspamd-Queue-Id: BC4B12000C
X-Rspamd-Server: rspam05
X-HE-Tag: 1755249155-336238
X-HE-Meta: U2FsdGVkX1/W+GecRMBZlzxlKBG2wyATnKF0S0ViV2x0O1uiW7KcHYdHApFpM3VeUmHw830pMXnSlAoeBmab54L9VIgHEl3ZiW8O7rf0mi6e/jF4VNIsoaj/GKAxvU/o35kqCCVb+DodmWBQoClDy+svHcRM2CAO7qtryVqvCwnX/Sp5NZj9CnkWFov+QMABUkHHk3UBD7HZKl21BjKmnDhgxouUYwg6W7teLOKKV3Ei7zGIKlEcjgQk6x5+2lrg03Toz7WdiNsYVqsJzzIa1VY111dzrXwwBh+51ILT22+u3yWJJrIGWye7Pd6bB62YHnK60TIPpllHwQ4/sRgdwgAXa+kt65ULDkLSlnf4OEi/t4cPyqsTqHDX73mJWwvRgZo715tajs3cSAkWjHN+G6GYdLqrepTfMyTKFPx7dMLXmJADMXfty9oA54WSo/DlHS/awJHPIK4Xp01VUMw42P2uRvUxBgx6OOb4zuuTQwfcXyLAm1hd6T3F658uC3PHs4IFvNKFENPRgTXUB7/xJZnlWP65G00MNYFr+epXEnoX6EcoTepfnBuUYteg80DxRfKKSKdgsxjz9+u3Sppptws7Fi/STxlgZVpF6LC3NhyJdG/Fnp/C8X5XYk6f4IF04nHS4nSW3dD/09YrEWfA4v3n2zmkZHJkotxNFB8aaiFmTg+zabZzcbtQHNk0vyva11ZRHaSJUvUU1kHhwtckcsiCmM6bRvY0HiSBfLl/jOSeKddy8WPipUH9+Paetq00W64Oy0FZI0FujjmASeeDzEsnVrZIAPnnL5Ixut6GLL9QW5DKqSni6Xp3wy3kytYfxCG/txmDinONvKWx60/jS/PnxiRO9eR0OGrkS0lWcWSRNLJcy1LypuAlkkgEAGqN+TaH84MqcfGxyvUpInxOUdrNrYvvHTCgBxlXOj+dJNVfKh98f0yKj0AoDvNJ/Pis0KcIOmr9Ua1x0YbeTKB
 fMtjC4ZV
 i/LoS0DxoHk7odkvdBVw465t8sds5PVQGkP8eYOaQ1E5NNWiOlNL9IlAwn/3d2d8FWc1B2p7ITXhSkQMm8GNgPn+DZ4sj2fjWX9rdOWVpyHWGDgKB/LGd85zRFBybGPmD5T0fgcHRo4TdCkfIlDdThDGqW5YDued8VyAuzetxGIQxyqg+8C45p3Tv5w2fXvlpU36m0QygUEoALm7DZ2YKgx37rzajuaoLNOOhjbZGlBG4MiA9AF5RKeY0zQb4jl3Q4v22/kYxAmBrJAdVa8yJIq8vux62YGS2prMA5VQOqoGOFWMve7U2sa4DRTzZETc1xUR7VuQ6Fd1FaJc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 10:22:33AM -0300, Jason Gunthorpe wrote:
> On Thu, Aug 07, 2025 at 01:44:13AM +0000, Pasha Tatashin wrote:
> > +int kho_unpreserve_phys(phys_addr_t phys, size_t size)
> > +{
> 
> Why are we adding phys apis? Didn't we talk about this before and
> agree not to expose these?
> 
> The places using it are goofy:
> 
> +static int luo_fdt_setup(void)
> +{
> +       fdt_out = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
> +                                          get_order(LUO_FDT_SIZE));
> 
> +       ret = kho_preserve_phys(__pa(fdt_out), LUO_FDT_SIZE);
> 
> +       WARN_ON_ONCE(kho_unpreserve_phys(__pa(fdt_out), LUO_FDT_SIZE));
> 
> It literally allocated a page and then for some reason switches to
> phys with an open coded __pa??
> 
> This is ugly, if you want a helper to match __get_free_pages() then
> make one that works on void * directly. You can get the order of the
> void * directly from the struct page IIRC when using GFP_COMP.
> 
> Which is perhaps another comment, if this __get_free_pages() is going
> to be a common pattern (and I guess it will be) then the API should be
> streamlined alot more:
> 
>  void *kho_alloc_preserved_memory(gfp, size);
>  void kho_free_preserved_memory(void *);

This looks backwards to me. KHO should not deal with memory allocation,
it's responsibility to preserve/restore memory objects it supports.

For __get_free_pages() the natural KHO API is kho_(un)preserve_pages().
With struct page/mesdesc we always have page_to_<specialized object> from
one side and page_to_pfn from the other side.

Then folio and phys/virt APIS just become a thin wrappers around the _page
APIs. And down the road we can add slab and maybe vmalloc. 

Once folio won't overlap struct page, we'll have a hard time with only
kho_preserve_folio() for memory that's not actually folio (i.e. anon and
page cache)
 
> Which can wrapper the get_free_pages and the preserve logic and gives
> a nice path to possibly someday supporting non-PAGE_SIZE allocations.
> 
> Jason
> 

-- 
Sincerely yours,
Mike.


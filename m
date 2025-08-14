Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 242B4CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 07:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B512E900104; Thu, 14 Aug 2025 03:26:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B28CE900088; Thu, 14 Aug 2025 03:26:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A66BC900104; Thu, 14 Aug 2025 03:26:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 92BCF900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 03:26:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5EEDF1DD828
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:26:52 +0000 (UTC)
X-FDA: 83774531064.12.E45401C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id C5FA04000B
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:26:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R6qffIlo;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755156411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CfApIHI972kWbSR3U0B1BpYQYv1HxE5zGDXKDQ24uLE=;
	b=abxNidTjqEo1vWWzM9KcQy9Gamhzv/KPQt9sdqGo5VW7kqY2qFYjt8MB3Ss48rZBY/JCml
	rb11nSM+MVVtGmJbWPp0/bZvpA1FZShpvlgaTwbqHHwbuv8dc30g88kmanGbNCtPvswraV
	ZfT+GGEmX5YXHkjn2aL3XWJ9HhIkKH0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R6qffIlo;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755156411; a=rsa-sha256;
	cv=none;
	b=HwzHvgfPmfVnCdpvySzyKQlh3e8V7R1D9J11c/T8/f6Hluw73Ps2xSAybDyHtwvEEltD2I
	s+RIbxhUEUPmcwhXrDMbxysDGMrflf+JJ0H7Hmzs8d9s9SZ4KMQEIVpDaFPUp1pc95ABiY
	YK5wgQwrb5GBZ8gEEbQCJDNywMFxb1A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F07043F72;
	Thu, 14 Aug 2025 07:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D17C4CEEF;
	Thu, 14 Aug 2025 07:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755156409;
	bh=fNi6Y02rVH9GqePGaiKxiM3IrThq2pypq4fbfTCXcIE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R6qffIloCujxWq1ip65cWS3DUXGF0vDFCOVAKKUf8dUEKnZHbCtDzDN6Fh/Qzl1+q
	 7OGbYD93LFNJPFpntW5RFnE8JywzXL5Ckz4lVfMZU6MxSPh05+YSdtNjDQm7glR+ok
	 JOr0rMid4vgaJMdUkGNCQ8142UcJgMi28wZ3Os/ODI7B6GePUisO/y5I9E6foeXnv8
	 p6oBgT5M3QILhEaKo3iPanGLegAZn2HLZ0xykFdtRNaWiKUGgoCwssM0F1jm2hGjQW
	 N9zX0NHCwgVshW3h0rsCcOzl6kK17FwQ/KHlj2mQlzZGb5QfCHShBisy9DevjRWiwo
	 I26/phH7ruVXQ==
Date: Thu, 14 Aug 2025 10:26:19 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: nathan@kernel.org, arnd@arndb.de, broonie@kernel.org,
	Liam.Howlett@oracle.com, urezki@gmail.com, will@kernel.org,
	kaleshsingh@google.com, leitao@debian.org, coxu@redhat.com,
	surenb@google.com, akpm@linux-foundation.org, luto@kernel.org,
	jpoimboe@kernel.org, changyuanl@google.com, hpa@zytor.com,
	dvyukov@google.com, kas@kernel.org, corbet@lwn.net,
	vincenzo.frascino@arm.com, smostafa@google.com,
	nick.desaulniers+lkml@gmail.com, morbo@google.com,
	andreyknvl@gmail.com, alexander.shishkin@linux.intel.com,
	thiago.bauermann@linaro.org, catalin.marinas@arm.com,
	ryabinin.a.a@gmail.com, jan.kiszka@siemens.com, jbohac@suse.cz,
	dan.j.williams@intel.com, joel.granados@kernel.org,
	baohua@kernel.org, kevin.brodsky@arm.com, nicolas.schier@linux.dev,
	pcc@google.com, andriy.shevchenko@linux.intel.com,
	wei.liu@kernel.org, bp@alien8.de, ada.coupriediaz@arm.com,
	xin@zytor.com, pankaj.gupta@amd.com, vbabka@suse.cz,
	glider@google.com, jgross@suse.com, kees@kernel.org,
	jhubbard@nvidia.com, joey.gouly@arm.com, ardb@kernel.org,
	thuth@redhat.com, pasha.tatashin@soleen.com,
	kristina.martsenko@arm.com, bigeasy@linutronix.de,
	lorenzo.stoakes@oracle.com, jason.andryuk@amd.com, david@redhat.com,
	graf@amazon.com, wangkefeng.wang@huawei.com, ziy@nvidia.com,
	mark.rutland@arm.com, dave.hansen@linux.intel.com,
	samuel.holland@sifive.com, kbingham@kernel.org,
	trintaeoitogc@gmail.com, scott@os.amperecomputing.com,
	justinstitt@google.com, kuan-ying.lee@canonical.com, maz@kernel.org,
	tglx@linutronix.de, samitolvanen@google.com, mhocko@suse.com,
	nunodasneves@linux.microsoft.com, brgerst@gmail.com,
	willy@infradead.org, ubizjak@gmail.com, peterz@infradead.org,
	mingo@redhat.com, sohil.mehta@intel.com, linux-mm@kvack.org,
	linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	x86@kernel.org, llvm@lists.linux.dev, kasan-dev@googlegroups.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 07/18] mm: x86: Untag addresses in EXECMEM_ROX related
 pointer arithmetic
Message-ID: <aJ2Pm2XzcM3H4aTN@kernel.org>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
 <aa501a8133ee0f336dc9f905fdc3453d964109ed.1755004923.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa501a8133ee0f336dc9f905fdc3453d964109ed.1755004923.git.maciej.wieczor-retman@intel.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C5FA04000B
X-Stat-Signature: d5qeyqdjxjdr3w51fm4yuicsg94eyodm
X-Rspam-User: 
X-HE-Tag: 1755156410-810807
X-HE-Meta: U2FsdGVkX1/coYb6bsAitnhxrSZYi7RTdOUe36aToGtq4uekOAOOlXYSnI0vP87lQtYHP0b12jk711zlJnoYkySoYSQJIyOG5UtGKpjgCqwR6GakwwNY79JgfOuD1JeYM5l5Eq0d3kR+8yD5x4N4oU2iGo9oD5OQftx8qaxLrHK18H6EqeIYzeCy+VUBCrsuBq8bcHC2/m3V9msPxvJ9EF/HdWBV3Ss0cW+DwpRb54rVIq3WXK9o9tg8FM8S1ZGKBfSm33nRSgLI+IaH+vseJUw2e1k1uGXMYbOZp2kkEPZeGDBbo97CHp2hgu9/7cHgij0qlyIBg7KYmhMRu4B5hGONkCMaf6RQsb79s5rRtzuVDDBfQQBQltYPMesWIJq5lyOYT9icvONJ3C5JqVJY3Wj7fy6VupBtXzIsAv8+ahHF5sSGbrKMF9q0xEGOJHStjDASKB0SOBmnzCCv3AyLQu3gecSMFj+09JSX0/ik3CXi0cLWgdxwoiMVx59vopYKMmHfCEo3Lq10dFc/Qt64XCm8v/q2wo3VXFjG014g1X4ORAMmI+9KBvtXgN1M+YUE2Svwt7+UhwbCY+QXTQyQo3q06DgF2bc/1f/Iw/nqETv61Ep8w/OyEuUzV/CJtBjCwj5mXcfJYdHai0SF6Lexa9Ww2PrDBs7LXOA8ea8dyd9CBTd26LI02F2xZq1QkuNENfgZxP3n1Zg2WZTQkZqUItPKiiuFI1Zw4UI3Jqtl6sMmxIb6OMso4VtsystcWYKlMoQV+49zN+WEY/ZsVUZ5xLl21FNciv8fiO1x09YXtyJ22GJ5T5I3G4LbDcLJhmfoOZoPpWCPFe8M4/lD+DGNc0oAAt3qNE42f5qWD6ORt5chs2lml7VwOGoqvEzAh+tH140GPdFSYaCRAGi7m1HVBTvM8DQdA/QYybQ70w9az+lIZ85uN2bc6pbLfTqRExJPscIBUokakIBu8VsmE0V
 njue/OrE
 EENLpudaHaO+yhlEaNLoNaA7bg88xN+65btfzH5Jold6ICJ6+RdreaW+ii3PRYs7J9LP/NgNN5w4vfy8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 03:23:43PM +0200, Maciej Wieczor-Retman wrote:
> ARCH_HAS_EXECMEM_ROX was re-enabled in x86 at Linux 6.14 release.
> Related code has multiple spots where page virtual addresses end up used
> as arguments in arithmetic operations. Combined with enabled tag-based
> KASAN it can result in pointers that don't point where they should or
> logical operations not giving expected results.
> 
> vm_reset_perms() calculates range's start and end addresses using min()
> and max() functions. To do that it compares pointers but some are not
> tagged - addr variable is, start and end variables aren't.
> 
> within() and within_range() can receive tagged addresses which get
> compared to untagged start and end variables.
> 
> Reset tags in addresses used as function arguments in min(), max(),
> within() and within_range().
> 
> execmem_cache_add() adds tagged pointers to a maple tree structure,
> which then are incorrectly compared when walking the tree. That results
> in different pointers being returned later and page permission violation
> errors panicking the kernel.
> 
> Reset tag of the address range inserted into the maple tree inside
> execmem_cache_add().
> 
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> ---
> Changelog v4:
> - Add patch to the series.
> 
>  arch/x86/mm/pat/set_memory.c | 1 +
>  mm/execmem.c                 | 4 +++-
>  mm/vmalloc.c                 | 4 ++--
>  3 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 8834c76f91c9..1f14a1297db0 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -222,6 +222,7 @@ static inline void cpa_inc_lp_preserved(int level) { }
>  static inline int
>  within(unsigned long addr, unsigned long start, unsigned long end)
>  {
> +	addr = (unsigned long)kasan_reset_tag((void *)addr);
>  	return addr >= start && addr < end;
>  }
>  
> diff --git a/mm/execmem.c b/mm/execmem.c
> index 0822305413ec..743fa4a8c069 100644
> --- a/mm/execmem.c
> +++ b/mm/execmem.c
> @@ -191,6 +191,8 @@ static int execmem_cache_add_locked(void *ptr, size_t size, gfp_t gfp_mask)
>  	unsigned long lower, upper;
>  	void *area = NULL;
>  
> +	addr = arch_kasan_reset_tag(addr);

Shouldn't this use kasan_reset_tag()?
And the calls below as well?

Also this can be done when addr is initialized 

> +
>  	lower = addr;
>  	upper = addr + size - 1;
>  
> @@ -216,7 +218,7 @@ static int execmem_cache_add(void *ptr, size_t size, gfp_t gfp_mask)
>  static bool within_range(struct execmem_range *range, struct ma_state *mas,
>  			 size_t size)
>  {
> -	unsigned long addr = mas->index;
> +	unsigned long addr = arch_kasan_reset_tag(mas->index);

AFAIU, we use plain address without the tag as an index in
execmem_cache_add(), so here mas->index will be a plain address as well
  
>  	if (addr >= range->start && addr + size < range->end)
>  		return true;
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 6dbcdceecae1..83d666e4837a 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3328,8 +3328,8 @@ static void vm_reset_perms(struct vm_struct *area)
>  			unsigned long page_size;
>  
>  			page_size = PAGE_SIZE << page_order;
> -			start = min(addr, start);
> -			end = max(addr + page_size, end);
> +			start = min((unsigned long)arch_kasan_reset_tag(addr), start);
> +			end = max((unsigned long)arch_kasan_reset_tag(addr) + page_size, end);
>  			flush_dmap = 1;
>  		}
>  	}
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.


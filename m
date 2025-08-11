Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3478EC87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 08:13:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7AF58E000F; Mon, 11 Aug 2025 04:13:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C52CB8E000A; Mon, 11 Aug 2025 04:13:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B684B8E000F; Mon, 11 Aug 2025 04:13:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A332C8E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:13:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5257816073E
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:13:38 +0000 (UTC)
X-FDA: 83763762516.10.CF1F01B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id DD09A1A000E
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:13:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NabTfTob;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754900016; a=rsa-sha256;
	cv=none;
	b=2v4A7by+LKaVOkigmX6YxcwIi7eoHM9iR3isL1iWf7Pxu4cq2eKUQ4EATPgGJL6D+kmCm4
	p6i9CP94qyMVWe8i3cJrWSWUJHvk7/sO5Zb/zD+yUyWnQCdJNG30KH10nA166LNX5V0yT9
	LsVojRrePzh5QV5uEQmHW+AizZ2D914=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NabTfTob;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754900016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f3sDw793CPWAS611HTtLYr5SWDtvHzlJoLtJhvY+jFs=;
	b=hVOi5vqJ1+ivag5t648XJG93D88s0XhPjY3F4Wv3E+lXRThVVSyhr1G7T+La4l0+MP8F1N
	lS/9GM+hR66X4ycXKRoCojDi1LtN3wLH3FUzBcrsx2rXeKXEDykB1Ts7sA50lkSgJOpPaQ
	xh7RX4LHDukiWVUxG5sMddDjEGH0mhA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1ADCA601D1;
	Mon, 11 Aug 2025 08:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FDBC4CEED;
	Mon, 11 Aug 2025 08:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754900015;
	bh=nzI5taL8qhPmC3JnPTSLMBB3YPH8YS1XTL1Z0gmrNgU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NabTfTobkl+gvZ2itLU2X50GU6eoZs66ZpRb6DppIdkRXLv5WbfpPJ4R16/nmKpEA
	 wN0varhSZT4szpiXSnj6Pe9XvVhQ+y3c7GWi+NLr4ESBeGsKZ+2QEW4cpYCF0DlJj3
	 7E2/ts0/YGOPebJqAiJO2K+8J6j9jCUX8CYdQubGEiZK3vHB22W5mLeBwVWSzeTK3/
	 nhtzFZB1dYXwpdRrsAi78p2t1j1q02yAx97a5yKJtBpohccnSWNi8VR94dGiMYDpGx
	 oNMC+kjTxp2UM5E0+Z2CZG9s/QV595hCmSg3XhmNVJsD6lGY56P68wwmzf57fEIuQ/
	 es2yfYSsruz4g==
Date: Mon, 11 Aug 2025 11:13:19 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Dennis Zhou <dennis@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, x86@kernel.org,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Hildenbrand <david@redhat.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	"H. Peter Anvin" <hpa@zytor.com>, kasan-dev@googlegroups.com,
	Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
	Dmitry Vyukov <dvyukov@google.com>,
	Alexander Potapenko <glider@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Huth <thuth@redhat.com>, John Hubbard <jhubbard@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
	"Kirill A. Shutemov" <kas@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Jane Chu <jane.chu@oracle.com>,
	Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Alistair Popple <apopple@nvidia.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	linux-arch@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH V4 mm-hotfixes 3/3] x86/mm/64: define
 ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings()
Message-ID: <aJmmH40sV0Ig8YFr@kernel.org>
References: <20250811053420.10721-1-harry.yoo@oracle.com>
 <20250811053420.10721-4-harry.yoo@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811053420.10721-4-harry.yoo@oracle.com>
X-Rspamd-Queue-Id: DD09A1A000E
X-Stat-Signature: p7wi9rqrsjjd6xk6esnoj6rk5c45x344
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754900016-917528
X-HE-Meta: U2FsdGVkX19YxHfNHY1WZ4wht7otc/WqbKToN76v7SLsgO2cnGfD24NA5mJZjTb5f2Ao1mFQRfNnfGwgr81nO+kFjPCXVp5IVbg+g3vEGxrbCYE41zUyb1tKmWK+HD1QXkFlF5dMFU+neLQrzI8ZiZexWVJxkMvk+ykT9+6nUVqoQrSnqG1g+/6CdJGuK1pbL8hh7H55xir2EimuCwkyc5ltDn+PmtADB/K5yA4ixYWVbdXMlp6CrQSHW4hRfg3kmOFr6WrGbh08LsRTMQMYSssT5pSShb3HKMFyFx5GzSDDs180Vxm/uqicWKjYueLSx9duphBoQzeqOexcnOBsR6WuamZjrTytTLdTR2eJq7GxYfIv1MZhHLYjNS5hEzAhkv08Q5mQUYlRyqEoqesbhUEjnFBVAvm5acV+GizDmshVA0ChT20YTwwlBNxXytOmf9KC2Hy289B/ZsTbUhGyJJdEMieVmjIJrLx5NepXSY4bGEt3hKco92PckacGv6ckQBIGEr9al5PVuCAugsGeH7HOp+f5+wNf0DRygnbm8hmXaRdXKPJSrhyiiVXQT/jCkYB8qav09kdjaEYGpYLqe3/bXHxoDEXfdPDZTeICP8DoYx4eK6mbvJih5k8J3EyYetoNn1E+78BkvlNfQ9ZOw4dYKHjqKwRxYkz1Q/qb/SHMDqBwRGpwRApOyfIhMZfMIteeKe5ajdnnVZUP44JKZ93rXqqL0igNz3uQOGOmUZyoq9kv3wVH/p2cmyU4lnEx35eqBNHC6ydhTNd1FKTmLZgitOnLEyTfQa4b9bFGDJJJ4kQrwHsFXcENAjWa5N5yYMzynDdBhFnDzA8uedfg4alZKCWAIbwxuzRSQNBG05r69Sv1xlro/tPZ+Cg8e2mI4NvHnEzMizV3limjEs/PhJ1GWRIYIeP9s1fEdjyflvpZqywHdzErMIPdfbSr0SLiyNOw2KcRAHi1Lkbv/A7
 Zoqt7wca
 nA74bnuanaLb3YDhNR+owOpy1uUTf5SEOyk8aEYYczVgIjbu09BvMFTuyxiXaUssj6fLToZI+onu/Leg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 02:34:20PM +0900, Harry Yoo wrote:
> Define ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings() to ensure
> page tables are properly synchronized when calling p*d_populate_kernel().
> It is inteneded to synchronize page tables via pgd_pouplate_kernel() when
> 5-level paging is in use and via p4d_pouplate_kernel() when 4-level paging
> is used.
> 
> This fixes intermittent boot failures on systems using 4-level paging
> and a large amount of persistent memory:
> 
>   BUG: unable to handle page fault for address: ffffe70000000034
>   #PF: supervisor write access in kernel mode
>   #PF: error_code(0x0002) - not-present page
>   PGD 0 P4D 0
>   Oops: 0002 [#1] SMP NOPTI
>   RIP: 0010:__init_single_page+0x9/0x6d
>   Call Trace:
>    <TASK>
>    __init_zone_device_page+0x17/0x5d
>    memmap_init_zone_device+0x154/0x1bb
>    pagemap_range+0x2e0/0x40f
>    memremap_pages+0x10b/0x2f0
>    devm_memremap_pages+0x1e/0x60
>    dev_dax_probe+0xce/0x2ec [device_dax]
>    dax_bus_probe+0x6d/0xc9
>    [... snip ...]
>    </TASK>
> 
> It also fixes a crash in vmemmap_set_pmd() caused by accessing vmemmap
> before sync_global_pgds() [1]:
> 
>   BUG: unable to handle page fault for address: ffffeb3ff1200000
>   #PF: supervisor write access in kernel mode
>   #PF: error_code(0x0002) - not-present page
>   PGD 0 P4D 0
>   Oops: Oops: 0002 [#1] PREEMPT SMP NOPTI
>   Tainted: [W]=WARN
>   RIP: 0010:vmemmap_set_pmd+0xff/0x230
>    <TASK>
>    vmemmap_populate_hugepages+0x176/0x180
>    vmemmap_populate+0x34/0x80
>    __populate_section_memmap+0x41/0x90
>    sparse_add_section+0x121/0x3e0
>    __add_pages+0xba/0x150
>    add_pages+0x1d/0x70
>    memremap_pages+0x3dc/0x810
>    devm_memremap_pages+0x1c/0x60
>    xe_devm_add+0x8b/0x100 [xe]
>    xe_tile_init_noalloc+0x6a/0x70 [xe]
>    xe_device_probe+0x48c/0x740 [xe]
>    [... snip ...]
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 8d400913c231 ("x86/vmemmap: handle unpopulated sub-pmd ranges")
> Closes: https://lore.kernel.org/linux-mm/20250311114420.240341-1-gwan-gyeong.mun@intel.com [1]
> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  arch/x86/include/asm/pgtable_64_types.h | 3 +++
>  arch/x86/mm/init_64.c                   | 5 +++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
> index 4604f924d8b8..7eb61ef6a185 100644
> --- a/arch/x86/include/asm/pgtable_64_types.h
> +++ b/arch/x86/include/asm/pgtable_64_types.h
> @@ -36,6 +36,9 @@ static inline bool pgtable_l5_enabled(void)
>  #define pgtable_l5_enabled() cpu_feature_enabled(X86_FEATURE_LA57)
>  #endif /* USE_EARLY_PGTABLE_L5 */
>  
> +#define ARCH_PAGE_TABLE_SYNC_MASK \
> +	(pgtable_l5_enabled() ? PGTBL_PGD_MODIFIED : PGTBL_P4D_MODIFIED)
> +
>  extern unsigned int pgdir_shift;
>  extern unsigned int ptrs_per_p4d;
>  
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 76e33bd7c556..a78b498c0dc3 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -223,6 +223,11 @@ static void sync_global_pgds(unsigned long start, unsigned long end)
>  		sync_global_pgds_l4(start, end);
>  }
>  
> +void arch_sync_kernel_mappings(unsigned long start, unsigned long end)
> +{
> +	sync_global_pgds(start, end);
> +}
> +
>  /*
>   * NOTE: This function is marked __ref because it calls __init function
>   * (alloc_bootmem_pages). It's safe to do it ONLY when after_bootmem == 0.
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.


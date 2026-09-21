Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB6DFC982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 05:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BC696B00D9; Mon, 21 Sep 2026 01:48:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9948F6B00DD; Mon, 21 Sep 2026 01:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D1836B00DF; Mon, 21 Sep 2026 01:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6C54E6B00D9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 01:48:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1CE8AC055B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:48:42 +0000 (UTC)
X-FDA: 85236690084.09.9A80355
Received: from mta1.migadu.com (out-148.mta1.migadu.com [95.215.58.148])
	by imf22.hostedemail.com (Postfix) with ESMTP id E9985C0004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:48:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="wsWyZ/it";
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.148 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789969720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DfKCxDkGmiGAvVKE3w2w5luUgwycfNwU8vR07vCusUo=;
	b=cEl00iciX630rMo2Ii6GoN84FnyIncZyKu2W6BzMNDojnTYUUvFi8vpsVYxc/n0LQUdVuj
	wh9HK+cQuRN2a1eg+cvS44GtHyU6sC7Xt+wbF44SxZYFGkpRpb1mHX3jPNZszkBq1Ov6qH
	6UUSPnk6bjN2gEBe3rquqksikCsesbU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="wsWyZ/it";
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.148 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789969720;
	b=gpXBY16SOjW8bfOCX7o7g1hHn7MSxZphvF1GJYRnGmtDJbgmpD0xkfzWq/g3ztq3/KT31d
	Wc2/j6QGuKMiAfX+s2STIKHspdnUqJyYt/Q7xpLuaRaX90dSgfX708/jIP0ZM8ZxEDNLMa
	LBsadrAR0rItFQuhecZycJQxRNIUOIs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jhV/vw4+vWN8dqMOnDQNzr0Wd/YKWAZ5SZrLjVrKgJI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789969718; v=1; x=1790574518;
 b=wsWyZ/itCi6fu86wCCcJ0RZGEFvh1E6p15NlDx9Adkkv4ElC8H2tSzAL4teGcsjDOD6R85qz
 ElMAx70yL56Y1inpsiwWZHt2hrRRGoQ/lXhLrDGO15qK0CXIIZPbnue43uUKvmPYjDQXRaCwlcP
 2RBx/KWVKMVfSuslG0ikOMXY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 417d6ee2dae11de6;
	Mon, 21 Sep 2026 05:48:38 +0000
X-Mizu-Trace-ID: 417d6ee2dae11de6
X-Migadu-Flow: FLOW_OUT
Date: Mon, 21 Sep 2026 13:48:34 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Wandun Chen <chenwandun1@gmail.com>
Cc: catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
	pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, robh@kernel.org,
	saravanak@kernel.org, akpm@linux-foundation.org, rppt@kernel.org,
	pasha.tatashin@soleen.com, pratyush@kernel.org,
	m.szyprowski@samsung.com, mark.rutland@arm.com, kernel@xen0n.name,
	alex@ghiti.fr, hpa@zytor.com, ruirui.yang@linux.dev,
	robin.murphy@arm.com, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: Re: [PATCH v6 02/10] riscv: build crash_mem ranges from memblock
 instead of resource tree
Message-ID: <arDFMqcUr6xkTn-h@fedora>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
 <20260902073116.802752-3-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902073116.802752-3-chenwandun1@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E9985C0004
X-Stat-Signature: nzzmu7ozfbz5jx5qpobpoomgxscdqaq9
X-Rspam-User: 
X-HE-Tag: 1789969719-65040
X-HE-Meta: U2FsdGVkX1+8EsCGuPFBxh2lo+Bp6lD/H8qvJd9CgjdaexgEAiZsnHOHISC3VaQyYKrmJIVSTu9mdXibyv0NF8R5UWGYTIMSgUolAwvGnfroqMWsjawzepKZY41aGqbyJQwGoDIa+fv/oZj8AIdd46UXyZLPpZytrnPNtDMIjb5EyfCRj9g3w7j/8K42lw3sxe4ggQi+OkssEQpRlCwgvU+POtsnf6wfBCy02gdaAKKnLHTGwrTYVXHaKnDBLbnwA5uV2LAeNPFndzZZld3VOsmbxKHYu+8Id9ZNaIPXIxbfvt8epAiJd7J2zmgQz0wAjXjfzmu/ISJJ7B0P3hbH00AXwjwzAztZryncs4DpAOOSN8+Ky4sT1vjGvxsuLYdcmq7ZAPYe3w2YBHYtMef0H9BsDCbkPeswyDZeo1TSWCrgjERTye8WVer07j172GWdvoQZT8hI3Zm+eATbztpXjJHDrdANorCsTXE62Ogorny7CgftjucPb/gxJYkkeaD8oMigyX1ZhVyE/Dqy0YenJZ/cpRogtqmUoAqQOZRIt8GTW4SpDVa5FpxOnC5P1YZvHbiijJojCq0yn1iLx6ZcEu46g0a5gwb8QkT+Wh/gU7AsgKKU4TRKHfeQlLBJUEyzKo3yono6OrqS/Zv5oQcRfsHpVIsVVqXKk4YtUxCEozn7aJSEg5SepRxPKf7wsMC0WSTKeti0eq85k1XJvATFVUPQnOpI8LWqAgABOfGRiV6WY3iPDEru2pB5FMWvhy6diwIHRsk+vS9m/NGPvJ+ZsHYN8fMPDgW2SJTYI8BSFzPFIFm8NIGDapG2d/mUTqd8/3WWP1ULZyiF1qyrx/BawSJf8i4q9jIWuWWzR5PaMIUH5RlYYYKkUr813T3TfAs0Oz8n9JEXD0VIUCN4e8VKRA13YxkIGQ2i/+dspe7TMHxocyJuSnG5rC9nOkruF45sLcbP9vJjm5jsR732uZo
 y2qx5MDp
 KMR8otzCIXbbxKTqjwruoO1aKWzVD+HvmZYB8cnrpPLw9CZ5IyGSm1UeCISQGGq8l9jKfKtxyNOc82C1JL+zktsXI4B52jxOZERo3gQE5DmlnXM5tYrhWt3S8aDM6Eke4oj3WPRnpoXmLnYYjLRKuDv677PZKE1A5ujxgAjsWPtdIHbx9a5D7Pg39PgV4XC1lNzD5tDBZeZwEVAfh6hYJBRohvK5o2wPk8YlsPPdYqOYEuPkXDXdzpymOBwppzQzfsL0S191DVGMkcYTRB8XCQZM5Wv0AfNlkUAWY/miW02e1r0eYtw45bNM6ngFw8eQX8GCNRH4vOpy2BWVIzjhLt2zAuPLwI75HSlqfxc0if8fnZZ28ugWarlehA+WWz3st6wFUKE+XnWnxR7KZkiMJ0Uj7AbMAj+P/nW9O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/02/26 at 03:31pm, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
> Replace walk_system_ram_res() with for_each_mem_range(). A later patch
> introduces MEMBLOCK_NODUMP in memblock, the reserved-memory regions
> marked with MEMBLOCK_NODUMP can be excluded from the vmcore by walking
> memblock.
> 
> for_each_mem_range() iterates memblock.memory, which is freed after
> init unless ARCH_KEEP_MEMBLOCK is selected. riscv needs ARCH_KEEP_MEMBLOCK
> to filter reserved memory from the vmcore, so extend its condition
> (ACPI || KEXEC) with CRASH_DUMP. arm64 and loongarch already select
> ARCH_KEEP_MEMBLOCK unconditionally.
> 
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
> ---
>  arch/riscv/Kconfig                     |  2 +-
>  arch/riscv/kernel/machine_kexec_file.c | 31 ++++++++++----------------
>  2 files changed, 13 insertions(+), 20 deletions(-)

This looks good to me, FWIW,

Acked-by: Baoquan He <baoquan.he@linux.dev>

> 
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index d6c2dbf8455c..1de14a2d5aba 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -58,7 +58,7 @@ config RISCV
>  	select ARCH_HAS_UBSAN
>  	select ARCH_HAS_VDSO_ARCH_DATA
>  	select ARCH_HAVE_NMI_SAFE_CMPXCHG
> -	select ARCH_KEEP_MEMBLOCK if ACPI || KEXEC
> +	select ARCH_KEEP_MEMBLOCK if ACPI || KEXEC || CRASH_DUMP
>  	select ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE	if 64BIT && MMU
>  	select ARCH_OPTIONAL_KERNEL_RWX if ARCH_HAS_STRICT_KERNEL_RWX
>  	select ARCH_OPTIONAL_KERNEL_RWX_DEFAULT
> diff --git a/arch/riscv/kernel/machine_kexec_file.c b/arch/riscv/kernel/machine_kexec_file.c
> index 26cd2a8bd0cd..808e872f4063 100644
> --- a/arch/riscv/kernel/machine_kexec_file.c
> +++ b/arch/riscv/kernel/machine_kexec_file.c
> @@ -37,39 +37,32 @@ int arch_kimage_file_post_load_cleanup(struct kimage *image)
>  }
>  
>  #ifdef CONFIG_CRASH_DUMP
> -static int get_nr_ram_ranges_callback(struct resource *res, void *arg)
> -{
> -	unsigned int *nr_ranges = arg;
> -
> -	(*nr_ranges)++;
> -	return 0;
> -}
> -
>  unsigned int arch_get_system_nr_ranges(void)
>  {
>  	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* For exclusion of crashkernel region */
> +	u64 i;
> +	phys_addr_t start, end;
>  
> -	walk_system_ram_res(0, -1, &nr_ranges, get_nr_ram_ranges_callback);
> +	for_each_mem_range(i, &start, &end)
> +		nr_ranges++;
>  
>  	return nr_ranges;
>  }
>  
> -static int prepare_elf64_ram_headers_callback(struct resource *res, void *arg)
> +int arch_crash_populate_cmem(struct crash_mem *cmem)
>  {
> -	struct crash_mem *cmem = arg;
> +	u64 i;
> +	phys_addr_t start, end;
>  
> -	cmem->ranges[cmem->nr_ranges].start = res->start;
> -	cmem->ranges[cmem->nr_ranges].end = res->end;
> -	cmem->nr_ranges++;
> +	for_each_mem_range(i, &start, &end) {
> +		cmem->ranges[cmem->nr_ranges].start = start;
> +		cmem->ranges[cmem->nr_ranges].end = end - 1;
> +		cmem->nr_ranges++;
> +	}
>  
>  	return 0;
>  }
>  
> -int arch_crash_populate_cmem(struct crash_mem *cmem)
> -{
> -	return walk_system_ram_res(0, -1, cmem, prepare_elf64_ram_headers_callback);
> -}
> -
>  static char *setup_kdump_cmdline(struct kimage *image, char *cmdline,
>  				 unsigned long cmdline_len)
>  {
> -- 
> 2.43.0
> 


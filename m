Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BC06606A31A
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 03:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gQRE8BJc
Received: by kanga.kvack.org (Postfix)
	id A36256B05B0; Sat,  7 Nov 2026 22:15:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E7826B05B1; Sat,  7 Nov 2026 22:15:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9002D6B05B2; Sat,  7 Nov 2026 22:15:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DF0D6B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:15:35 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D2B06A7FC5
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 03:15:34 +0000 (UTC)
X-FDA: 85410486588.05.2C8FED3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2640A120005
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 03:15:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gQRE8BJc;
	spf=pass (imf29.hostedemail.com: domain of jszhang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jszhang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794107733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a/bZ5iXP4DDa9C3rE1j+9R8AKF/7AKe9/pell36SluI=;
	b=u/1KPXO+v3lHeeNtYLlCoZZqvXNXez6wu1968hPzsI7sDy/tqYLJUs6TdbzBrKoZRMKetj
	RLnHcH8/wLPiP3+vnf7/ZvS1aBdRadZJaBOcWRTFBhDEpVXtp97qwJ1AxOiBb5IZT4mfSN
	QlS0ZI1gTUoyRC7+GoGJq4fLX0esxM0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gQRE8BJc;
	spf=pass (imf29.hostedemail.com: domain of jszhang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jszhang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794107733;
	b=NPqMN/SUqYd9OxKihijo9R6zuOHr/nK+y4ScE5cpz1S/77c2T/XKdDbQy1al8B0+EkGkmS
	M0VtWgmZKoxtYUYndu7Db8oULNP5JATw23vyuZoUQ77snqfcts67PsFkew/68wuQ0W3LLN
	9hsHwe8kjuBPo3paV17Vk1qurUq3MPE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 514E644806;
	Sun,  8 Nov 2026 03:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788341F008A3;
	Sun,  8 Nov 2026 03:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794107732;
	bh=a/bZ5iXP4DDa9C3rE1j+9R8AKF/7AKe9/pell36SluI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gQRE8BJcf8LvyLbU47fcRumukgkMk2dqVAt4858j0hUiHCefBAFkrZdi+AsmTUQpM
	 REhZREwjELCnrvmjsck9IssG56NK7j45N6PlBZwUQI4HE8GD8GThzFGrJwatPFYveQ
	 WUYJQ3kzP0NS3TlardL7VE0gJhHe+YXtLVveZ54B096kZV2NYo+n9PrdQ/Io8BHiRY
	 pwzdVWv9Dmbnmp8idhvLp37xFaPETNxvefnR5wlk+o0Pr7NiNKkKinqIL3LPiavF2l
	 kNmbqZshDFTAKlrtFQHiGT1UsyjKasBC/viuUerMhAO+8RxwoOyQyGpxQJ4H6S+SXT
	 c4/hVjEF/2okQ==
Date: Sun, 8 Nov 2026 10:55:19 +0800
From: Jisheng Zhang <jszhang@kernel.org>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Waterman <andrew@sifive.com>,
	linux-riscv@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] riscv: mm: Skip the icache flush for special PTEs
Message-ID: <au_klz4_971bxJ_c@xhacker>
References: <20261017013634.792220-1-nickolai@csail.mit.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261017013634.792220-1-nickolai@csail.mit.edu>
X-Stat-Signature: q8koirf78ina9iw7a8et1wb4tdbd7tun
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2640A120005
X-HE-Tag: 1794107733-492547
X-HE-Meta: U2FsdGVkX1/tgmLPlkHv9XTgHFYPFNIodMEU2I29L25//CEXZkZULHzx9iqmuIKDNg64YAAPYfv9Snve6nlu/Gp2mNkZR0y9tjVgbmebFnWHS6RsiGe7rtmL/oceg88LIJTfFZx7+JKc76T1x9oDwotepflTBCUpDs3DhTDM6FDUbQG032mrg04RTWxjCp6clbUUucpAT4NamR9Zse4ztpK7AdqDbkauW9bHPeQvwvoBvsVvM2fJ9NSIFFUKcvHzF8QCI8t8p+12zBgfCFiDutcqk8gApmR4Sr9i9SnxjDMWZknVCnBNrCa9LXDVdRot1tjOjkNdOZBLbf9yz1+WZLt3gi+rsNFmbNoxPxp0xaVTPxOx91YBhMy4vxfz51vdLO0Yopiazq/2xGAccPclKqOJZvvZmFi21VwnRFag37q4eKiANFR1622fOLcO74AXXpgHZ+8fVFgg7Tat/fgm+TPGLpUfi6t0n8WRts47LrH793BrDyy8ubeW761+dSAcP4CrhgqYf3WfERU028PfxIZy1fnmqRZfbf6h6NgA+vnWJ0mGl6s2EwLeoufEqFDkTIHgeDgb5ReC6FvJJpw4dOM99hY97SXWuiadOGK30rALUEGiUl4FvTK5rIZY6XqiD2HugVmZX2Q5QrXPX2xPZeEq1YS5mRq7L2fLjeIfj2hgEJrgS5TBTlxrFBHb4NrQsAmofEDKJy0LYeNAkk9jLChQLNG9Bh6Xz35sgytY35XqObUas+LhVfIf1YdkW6isUS8q21vj5O8hQ53/TybnHWyGHbigYo7BPYX2ctR+Yp/X2gMbkmKQXNibG0kOsY2OOSYh+iGlqP3Jvko3u2OXNAvY6t4Q7gMUHctG2BmA6Hj/NPEBKvY1fvU/8pi4gIIgxgCFMulukGrVsc+HpvB4NM/9b3yTQsoe/Pm/nqKBSfomsfNkfr1GxwEOsEn/bx4ChNfA/6wUIyERXjvEN/x
 z+MPsCpU
 Lb/qscOYunm4w13WeZ6R2EidjDWpnWw5erEiw/gtmahZup5T0TJD3OSMNDyjponlZOJsfIXsbal3Zj/74aHDSlg+BkYUo1nQmaaujjaGw9WTIC1dfh+qEDH8fV/N/sNVBkH/U7nNwp/zeRyKgIFG5upA2Y6+735Mwm4VMr9QVWggt4BKk/40AWCntIIOYOR/X96wZr2oMG0n1YDfO+tK8rJps+TjacqI6BKWQKaWHZFoWSr1NLrd0EIKUt/ynXHqr3asFFWDGJ0F6XMKGxMiu4LM0L6alaEoYyZq0j+aOMJHSYq8oT36jJDJqHR3CV/jfvUJuStQj43WsrjRFWmzpKfVYJgQntDbQZ5Vks858Uz8LB0Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 16, 2026 at 09:36:34PM -0400, Nickolai Zeldovich wrote:
> Mapping device memory executable crashes the kernel: an mmap() with
> PROT_EXEC of a physical range outside RAM, from /dev/mem, from a PCI
> BAR's sysfs resource file, from a frame buffer or from any driver whose
> mmap() uses remap_pfn_range(), io_remap_pfn_range() or vmf_insert_pfn(),
> oopses in flush_icache_pte() with the page table lock held; the task
> never completes its exit and its parent's wait() hangs. On QEMU virt
> with the riscv64 defconfig of v7.3-rc7, mapping the PCIe ECAM window
> from /dev/mem:
> 
> mmap(/dev/mem, phys 0x30000000, PROT_READ|PROT_EXEC, MAP_SHARED)
> Unable to handle kernel paging request at virtual address ff1c000000c00008
> Oops [#1]
> epc : flush_icache_pte+0x74/0xa0
>  ra : do_remap_pfn_range+0x2b2/0x3ee
> ...
> note: test[52] exited with preempt_count 2
> 
> With CONFIG_FLATMEM (32-bit, or a 64-bit configuration without
> SPARSEMEM) nothing faults: pte_page() of a pfn outside RAM is a pointer
> outside mem_map, and flush_icache_pte() tests and sets a bit of whatever
> memory it lands on. The privilege needed is that of the device file
> (root for /dev/mem and the PCI resource files). Present since the port
> was merged (v4.15).
> 
> __set_pte_at() calls flush_icache_pte() for every present executable
> PTE. flush_icache_pte() does the flush once per folio: it takes
> page_folio(pte_page(pte)) and tests and sets PG_dcache_clean. A special
> PTE (pte_mkspecial(), what remap_pfn_range() and vmf_insert_pfn() write
> into a VM_PFNMAP mapping) maps a frame the kernel does not manage as a
> page: there is no struct page behind it, so pte_page() returns a vmemmap
> address with no memory section, or with FLATMEM a pointer outside the
> array.
> 
> Skip the flush for special PTEs, as arm64 does since
> commit 71fdb6bf61bf ("arm64: Do not synchronise I and D caches for
> special ptes"). These mappings are device memory or buffers the kernel
> never wrote code into on the user's behalf; a user that writes code
> into one and executes it has to flush with the cache flush system
> call, as for any memory it writes itself.
> 
> Found while formally verifying remap_pte_range() against the kernel
> binary.
> 
> Fixes: 08f051eda33b ("RISC-V: Flush I$ when making a dirty page executable")
> Assisted-by: LLM
> Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>

this patch looks good to me, but the comment needs updating, see below
With that,
Reviewed-by: Jisheng Zhang <jszhang@kernel.org>

> ---
> 
> Notes:
>     Every pte_special() PTE goes through this path: remap_pfn_range() and
>     io_remap_pfn_range() (remap_pte_range() writes pte_mkspecial(pfn_pte())),
>     vmf_insert_pfn() (insert_pfn()), and the huge variants through
>     set_pmd_at()/set_pud_at(), which also land in __set_pte_at(). The
>     pte_special() bit is _PAGE_SPECIAL (RSW bit 8) on every riscv
>     configuration; ARCH_HAS_PTE_SPECIAL is selected unconditionally.
>     
>     Non-special PTEs are unchanged: anonymous, page cache and
>     vm_insert_page() mappings keep the per-folio flush. A RAM-backed
>     VM_PFNMAP mapping (dma_mmap_coherent() of an allocated buffer, /dev/mem
>     over RAM) loses the flush it used to get; nothing in the kernel writes
>     instructions into such a buffer for userspace to execute, and the
>     PG_dcache_clean state of those pages was never maintained for that use.
>     
>     Reproducer (QEMU virt, riscv64 defconfig, as /init with /dev/mem c 1 1
>     in the initramfs; the PCIe ECAM window is at 0x30000000, any non-RAM
>     range does):
>     
>       riscv64-linux-gnu-gcc -O2 -static -o test exec_mmio_mmap.c
>       qemu-system-riscv64 -M virt -cpu max -smp 2 -m 1G -nographic \
>           -bios /usr/share/qemu/opensbi-riscv64-generic-fw_dynamic.bin \
>           -kernel Image -initrd initramfs.cpio -append "console=ttyS0 rdinit=/init"
>     
>       unpatched: Unable to handle kernel paging request at virtual address
>                  ff1c000000c00008, epc : flush_icache_pte+0x74/0xa0,
>                  ra : do_remap_pfn_range+0x2b2/0x3ee; the task never exits
>       patched:   mapped at 0x7fffab55d000, first word 0x00081b36
>                  (the host bridge's vendor and device ID)
>     
>       #include <fcntl.h>
>       #include <stdint.h>
>       #include <stdio.h>
>       #include <stdlib.h>
>       #include <sys/mman.h>
>       #include <unistd.h>
>     
>       int main(int argc, char **argv)
>       {
>       	unsigned long phys = argc > 1 ? strtoul(argv[1], NULL, 0) : 0x30000000UL;
>       	volatile uint32_t *p;
>       	int fd;
>     
>       	fd = open("/dev/mem", O_RDONLY | O_SYNC);
>       	if (fd < 0) {
>       		perror("open /dev/mem");
>       		return 2;
>       	}
>       	printf("mmap(/dev/mem, phys 0x%lx, PROT_READ|PROT_EXEC, MAP_SHARED)\n", phys);
>       	fflush(stdout);
>       	p = mmap(NULL, 4096, PROT_READ | PROT_EXEC, MAP_SHARED, fd, phys);
>       	if (p == MAP_FAILED) {
>       		perror("mmap");
>       		return 2;
>       	}
>       	printf("mapped at %p, first word 0x%08x\n", p, p[0]);
>       	return 0;
>       }
> 
>  arch/riscv/include/asm/pgtable.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index 40b1ed4f3ea8..7a4d60ccabb0 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -628,7 +628,8 @@ void flush_icache_pte(struct mm_struct *mm, pte_t pte);
>  
>  static inline void __set_pte_at(struct mm_struct *mm, pte_t *ptep, pte_t pteval)
>  {
> -	if (pte_present(pteval) && pte_exec(pteval))
> +	/* A special PTE has no struct page for flush_icache_pte() to track. */

what about "Special PTE mappings are not intended to be executable and
may not even have an associated struct page"?

> +	if (pte_present(pteval) && pte_exec(pteval) && !pte_special(pteval))
>  		flush_icache_pte(mm, pteval);
>  
>  	set_pte(ptep, pteval);
> 
> base-commit: 70dd4ee72eb2d5793c62e71c14e3aba78e5a4e56
> -- 
> 2.53.0
> 
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv


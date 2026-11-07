Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19E7D606A334
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 06:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=PLiMgy2m
Received: by kanga.kvack.org (Postfix)
	id 1B3176B05B2; Sat,  7 Nov 2026 01:45:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18D466B05B3; Sat,  7 Nov 2026 01:45:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09FF26B05B4; Sat,  7 Nov 2026 01:45:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D31A76B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 01:45:36 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 564981402B9
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 06:45:36 +0000 (UTC)
X-FDA: 85407387072.02.DFE7024
Received: from mta0.migadu.com (out-85.mta0.migadu.com [91.218.175.85])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2FB2340005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 06:45:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PLiMgy2m;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.85 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794033934;
	b=SAgk4yKcHdVNbD0Cqogwaaso//oBPe+SB0scgax2OYSk74hghcmRHDScv5cyN9L8HiV8h7
	ThRiAWD2GwZBbfvpyqzMSphkr0rqp7IdEJFcaHanE/Rxnokmw+LhwBO+QdFywg5151R7Du
	KOz/5rzM57Bcw74sIlCeGbrpXTOwgN4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794033934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p0Q+aPh9FXmspSlImRXpx816BsnlvW0umQZjVoRPYEU=;
	b=6Ul0bLngxJr/BxyvZdjOc/u/Mpg32LAi2m7chaF+dQtavbMAhaafrEJfcesNaeLnY00QDC
	ou5a8pn65ZEqD8Ul1rOjc+UPgHM5avFcbvv1T9opm01p2qUjF9p0Io/VQUdu2st8V9yrqT
	GV4nhxoNVTxvrTQH+78hmFm9f9r/a+E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PLiMgy2m;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.85 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=l8FwMw+tmHQ7yeBnzjT9XdJgKx4elexMVrnBE3P9GII=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794033932; v=1; x=1794638732;
 b=PLiMgy2mkCsCeBwAzcCbel54H98GbsWHqYUPAwA5TRiOgHIetnjEEAApj6O5kb7uV3oKEhxR
 LGsMaFY4sLqQldb0T6GTheqink0+up+b5DfPjNWpu057NaTIe9xJfNGONa4kUuFMRghIbI0vCPD
 uLnvROtZzHXdMzbJHO5d1TDk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id c05da5992c7d8cdf;
	Sat, 07 Nov 2026 06:45:29 +0000
X-Mizu-Trace-ID: c05da5992c7d8cdf
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 13/20] arm64: Support hugetlb vmemmap optimization
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261003002123.505555-14-jthoughton@google.com>
Date: Sat, 7 Nov 2026 14:45:11 +0800
Cc: Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>,
 Linu Cherian <linu.cherian@arm.com>,
 Mark Rutland <mark.rutland@arm.com>,
 David Hildenbrand <david@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Nanyong Sun <sunnanyong@huawei.com>,
 Yu Zhao <yuzhao@google.com>,
 Frank van der Linden <fvdl@google.com>,
 David Rientjes <rientjes@google.com>,
 linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <CAF9824D-CDC5-48E6-A1F6-840CB299EADB@linux.dev>
References: <20261003002123.505555-1-jthoughton@google.com>
 <20261003002123.505555-14-jthoughton@google.com>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Queue-Id: 2FB2340005
X-Rspamd-Server: rspam12
X-Stat-Signature: rzzdidpxt3scnb3g34qx4docnnimeosd
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794033933-894104
X-HE-Meta: U2FsdGVkX1+7dmtbTcuZkg6uXcfQUET9I+LDr9s+3e8bYu+0YTo4VXZrzjJt9q6If//6yLSlEA5jnz1/1dx+5ClHak+X+EPjeVoIb/qc54fWXnZlLQIrMuKz0Zah64owG4ZelsTpmNRVEDutXU+VqKAGB9UyQagJB6MQKbZ4uh5OfTicFKV5TSMvaCfUIwK9LTOPyT7iO2w3xfoAMWNWTJ3fmocvWaP95oDlOboR5n1tEZeDRkblsDDRweAlHWDHkzGBRU2IHqmhg3cpFUIC9XCBSyrjmEJdxEWww/YeAbBXJnaAnmaetk7mGu4gEGYtJOgLsDZWuO4VAWPMdKm4G+W0X0zIjpGGSqGGppayL+//rriEFAcu9g0Mw47nBog6KhBQ1fx+vbmkCF6bj6hvXb8ip2EUYP83NRHozyAAEo73kZNbrCjuR6fG+kHQWEcUcfuLSqBhBZqwyNTKv3vRrQs9T8LT+k3reBMbHzpTrjKfy0K1UDOm7zE1+0HrA/vZmwG3gLipgRy5PBwkp/6PG0cFbMCkptwT3JhinXCfxmiAbvdsBGUL+3/7hJHPg5pTN5A5n+hNemj+XiZSMbBs9OlYX9wgJMZBZYs+20AN6K17UXc3GebShaBhDcDnb0wpn0UU9TIOrYVG4FE+a00gzphMfMbKxt+5V4eHzvaLxVGFn1jXmrBaLIM6Haw5605+J05Ycugh17eEkzTUrpWqR9mqNEwhsVR4Z1TeQWsAY5m+Sl0MJ+daAfuibDTWRyyoyQvs2+Dkw/4K9tCa0HED9S1DTtAS8LjSxeHOUDbMblOMP9XFVa2idhBqBT9Phf3bOc2m6+4LTbAG8rQTjkqHKVPvqugpER8WhhP4fpKDcGltSQIyGOSMi206x8zErRlDDnP/jWnSoGWK3WonOGFQ2JOBIxxDyHClcsTV/guJiALVegWYy2xKx42Hqi18RlR9BZKD+iFfl6gQA+zgR/v
 CnjmDUFI
 /SBHJQuYusojIk/9X1uxYvtJmmvdUBEP2qZ9HOEpsi7mvvmTVg96ZmFVO0NWi2B1400IsYC+NUfTa3QOKMi3Yh8LgwBGekxQHKCuXW2gVKXycyVTxsc+T6B1dC4KYxXwWMUiE6GljQvi/zXYuNFSbnfGFV4xvVveO56qgxzXjKPU8/XPKheaTv2JPBdGShszXIgWXGxMC5I4E3WbRHAzVn+gSMJk5VIT3hFZNu+mj/Hiv3f3OM0BdDuTCpe5k7H0AWlmCjCSKzycQo7NevGUyFTV+lzCzvLT41LS+DqnWhl0yxGQsnLhIrT5wcxCKpkADFToSvaTuTLVGbFzlKUJfUxwSFw1HNBzHIcL/kCIp3sT5opOJKD7NJDz+HboOGq7DF3MrQiWMPj/4fzYWGm1mHwf0Av1lfeglp88dpZ5tFNC5YJv3mr18dEfi3tpzqU0DsY3P9WKAhOyyDYkbzXsMjCxcRw9mmmx5x/cxA282LjMsQX7rYdSgwf8TkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 3, 2026, at 08:21, James Houghton <jthoughton@google.com> =
wrote:
>=20
> Support HVO if HW AF and BBML3 are supported. These are the required
> features for the vmemmap to be modified in place.
>=20
> On arm64 systems that do not have the required hardware features to
> support HVO, the HVO sysctl will not appear, and any attempts to =
enable
> HVO (either via the command line or via
> CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON=3Dy) will have no =
effect.
>=20
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
> arch/arm64/Kconfig               | 2 ++
> arch/arm64/include/asm/hugetlb.h | 7 +++++++
> mm/hugetlb_vmemmap.c             | 4 ++++
> 3 files changed, 13 insertions(+)
>=20
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index b51d23a62c92..e4c87487bc7f 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -92,7 +92,9 @@ config ARM64
> 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT
> 	select ARCH_WANT_FRAME_POINTERS
> 	select ARCH_WANT_HUGE_PMD_SHARE if ARM64_4K_PAGES || =
(ARM64_16K_PAGES && !ARM64_VA_BITS_36)
> +	select ARCH_WANT_HUGETLB_VMEMMAP_RO_AFTER_INIT
> 	select ARCH_WANT_LD_ORPHAN_WARN
> +	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP if ARM64_HW_AFDBM

Because vmemmap optimization depends on compound_info_has_mask(), before
enabling HVO on arm64, its vmemmap start address needs to be aligned to
MAX_FOLIO_VMEMMAP_ALIGN. Therefore, a prerequisite patch is required.

Thanks,
Muchun

> 	select ARCH_WANTS_EXECMEM_LATE
> 	select ARCH_WANTS_NO_INSTR
> 	select ARCH_WANTS_THP_SWAP if ARM64_4K_PAGES
> diff --git a/arch/arm64/include/asm/hugetlb.h =
b/arch/arm64/include/asm/hugetlb.h
> index d038ff14d16c..938d7896a31e 100644
> --- a/arch/arm64/include/asm/hugetlb.h
> +++ b/arch/arm64/include/asm/hugetlb.h
> @@ -11,6 +11,7 @@
> #define __ASM_HUGETLB_H
>=20
> #include <asm/cacheflush.h>
> +#include <asm/cpufeature.h>
> #include <asm/mte.h>
> #include <asm/page.h>
>=20
> @@ -65,6 +66,12 @@ extern void huge_ptep_modify_prot_commit(struct =
vm_area_struct *vma,
> 					 unsigned long addr, pte_t =
*ptep,
> 					 pte_t old_pte, pte_t new_pte);
>=20
> +#define __HAVE_ARCH_HVO_SUPPORTED
> +static inline bool arch_hugetlb_vmemmap_optimization_supported(void)
> +{
> +	return system_supports_bbm_through_af();
> +}
> +
> #include <asm-generic/hugetlb.h>
>=20
> static inline void __flush_hugetlb_tlb_range(struct vm_area_struct =
*vma,
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index c1c736dd08b9..fabf2b25fe59 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -85,6 +85,10 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct =
page *head, unsigned long start,
>=20
> 		/* Make pte visible before pmd. See comment in =
pmd_install(). */
> 		smp_wmb();
> +		/*
> +		 * On arm64, this requires BBML3. Its support has =
already been
> +		 * checked.
> +		 */
> 		pmd_populate_kernel(&init_mm, pmd, pgtable);
> 		if (!(walk->flags & VMEMMAP_SPLIT_NO_TLB_FLUSH))
> 			flush_tlb_kernel_range(start, start + PMD_SIZE);
> --=20
> 2.56.0.rc1.315.gc6ed9934b7-goog
>=20



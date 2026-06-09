Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07FBCCD8CA8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 06:22:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DD796B0005; Tue,  9 Jun 2026 02:22:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B5DD6B0088; Tue,  9 Jun 2026 02:22:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CB7A6B008A; Tue,  9 Jun 2026 02:22:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1D1706B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 02:22:34 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8B8D2C1BD6
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:22:33 +0000 (UTC)
X-FDA: 84859380186.15.D58AD8B
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf29.hostedemail.com (Postfix) with ESMTP id BC2C9120002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:22:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=kEkid4Lc;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf29.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780986151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QNLMOTRHBXi4Z84O461LhX+rEh9cZpG943Cj00l7pcg=;
	b=f4zSkrSkZTTSx64wrdkQCHQ/KY96Q1vh/Dystp7zy9gh4lVwtlCiY5pQfGz/5PxhEm8l/5
	pB03lGISv/QIuyTW4MaR8k+qUBsu8SeR4imKfuB/s2XOH471MB4XU0eTXmJ55zGq7EhlF7
	sspRL3nr+w8V9dD7QSCIEnFyjknxEhg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=kEkid4Lc;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf29.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780986151;
	b=JVtmyKkARD8AVlRXb014ehHDguktpGtKCN3wpGubN9Hqq/BGS1eWNmlrPxXDDDN/08k4Z3
	Y/a64ewe5M9XRsPsiK6lwFY6kHMTumt3nV0QHtoE5Kw9+ImUJd+phPRu/STuLmIlED8hcq
	AHunbwxxqqTS/VACvnmUtYupvZQhoeY=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260609062228euoutp02879bb71d17241973df547c0d26ff679d~3VXdYRxiV0754207542euoutp027
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:22:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260609062228euoutp02879bb71d17241973df547c0d26ff679d~3VXdYRxiV0754207542euoutp027
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1780986148;
	bh=QNLMOTRHBXi4Z84O461LhX+rEh9cZpG943Cj00l7pcg=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=kEkid4Lc9CpRO/3yyOzVz5QUMceUdCkVZHKebqPeaNlT6tnzDo5I4F3ZPZBXOk8On
	 5gBBhxvU8QM/nU5ODXUfDdfNgxHBxvxHcEGaliaAtVjJolwf72MxHzOQWCQV2TKj7I
	 EB7BWOaYJ7qI4rHEe7WKsSSL3IF4YpJayVXGNTyo=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260609062228eucas1p211850bcf6ea79ef270bc6fbe29ffafdb~3VXdClAs70378003780eucas1p2G;
	Tue,  9 Jun 2026 06:22:28 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260609062227eusmtip2cece3df82958ee4950f41c056ec8da55~3VXb-fGd70969909699eusmtip2E;
	Tue,  9 Jun 2026 06:22:27 +0000 (GMT)
Message-ID: <a1b27e97-182c-485d-a448-56c19c5de2c2@samsung.com>
Date: Tue, 9 Jun 2026 08:22:26 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v7 15/15] arm64: mm: Unmap kernel data/bss entirely from
 the linear map
To: Ard Biesheuvel <ardb+git@google.com>,
	linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com,
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts
	<ryan.roberts@arm.com>, Anshuman Khandual <anshuman.khandual@arm.com>, Kevin
	Brodsky <kevin.brodsky@arm.com>, Liz Prucka <lizprucka@google.com>, Seth
	Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, David Hildenbrand <david@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
	linux-mm@kvack.org, linux-hardening@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20260529150150.1670604-32-ardb+git@google.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260609062228eucas1p211850bcf6ea79ef270bc6fbe29ffafdb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260609062228eucas1p211850bcf6ea79ef270bc6fbe29ffafdb
X-EPHeader: CA
X-CMS-RootMailID: 20260609062228eucas1p211850bcf6ea79ef270bc6fbe29ffafdb
References: <20260529150150.1670604-17-ardb+git@google.com>
	<20260529150150.1670604-32-ardb+git@google.com>
	<CGME20260609062228eucas1p211850bcf6ea79ef270bc6fbe29ffafdb@eucas1p2.samsung.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: gt8w1ze55xq6zxxsr3x8zycjubsw93wq
X-Rspamd-Queue-Id: BC2C9120002
X-HE-Tag: 1780986150-6336
X-HE-Meta: U2FsdGVkX18nYheFuHCiLRvowcJaRdwdKYf121MdPHub+VXtib/3WRFB9EVqgjx+R+GLqEn3+bcpjgFZ3UsembL1EDCUU1ps+dklDscvxUdCb/OrAt3eh98mZYyiJLu+V/FRJ2UXyFuY0cH4RFuNCJxIj7QWpvfFi2OMxrMB8XjzZNe885/yP1UoL8zQC8G32R5wF2BhNFxguZeM3qi/CfXmKeshiTaVQIDIPTd1tTuvJHbHQCMAX2tDhT4OwvR8PkSULw32aat0O+c2HjHi738Ewu+vSPa10t5GBSVPm6WHHRlAUgSA8LkB6787dFVjJIjViPNm2hO0c//+GBQ7hBcO8uP7YSxcEt7AAvtp1vU+Bv+q25OrUoX+QpIk80RGf6bb9/kMYLfF+5/VTwROIqKmX3PHE1J3b4YCjHTe9FeiGYK/pH3YNoB7DNIWJxaj20uKmZdf+1WYXzJH1Qn+lTm+feNg6RQc8mRf+X1x8tgynY1JyaqwbDcXeyTkYBmIYg/4UUbHpOwqZu9Cf34MjkuGgOoFIEThuyDDn7UgCBELZ9xQC8Ew2AnROzXwgrETTDREDfJEe0cBp0G5BfN+7jiRZ62AKWJLxP8u8WG6RytMxqyLjru3//oPGmGcS7KMwI/o0dlVFvgv3oQyns5bh8FzG/g812uQQLuO6W5qSIbl9JkbZCX3Rxu1hZzXBTffGR8ChtO0mAN1/CsBnvrTZk0sAxxEFOwgMdUVheT+Rrc1r3lA8c4fIa4HFyu80iSELG+ZokpvJSKzU0aZzE/hYdN3L73PKP7Srldcjk9L7AjAmQajyub3C6XmCSNhWXJJZD5qkNZ9h0rTxi3se1fP8OxX4ZpeCKK+PVf7tzkRKY2GumjGKdUqlF/vUQlYkjr7qVIKyx5FffGxFjocSCAaZRoF21sdZJBV+SmDAP/uwQVqgANBzsuUUdqxHLY2pvYlqgnzytgBawLpL4WdXuf
 v8C6hz3x
 RRndUEnb4F1wk/lqyeUQl6rl6450sIm60SYZYdfHspxnR1t55BA3cCCNg0E2PnfIEFNH8W8a3NVYPqK5o90WvIMuTvW4WySo6DZqcM9Dg4l3tQQ0NI80Z2oUq5rOGEMCeAAkKXgpoNqwNwDMfBmEUI6Vl973f/IWXsH6vfTlo2ggGhf2bgKVWNmT4Y0dT4KdFOL1ypOK30yifd+svlEzDat/1wbI0eELKUYzwg2i9ImCmSS36FyNPwVUJLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dear All,

On 29.05.2026 17:02, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> The linear aliases of the kernel text and rodata are also mapped
> read-only in the linear map. Given that the contents of these regions
> are mostly identical to the version in the loadable image, mapping them
> read-only and leaving their contents visible is a reasonable hardening
> measure.
>
> Data and bss, however, are now also mapped read-only but the contents of
> these regions are more likely to contain data that we'd rather not leak.
> So let's unmap these entirely in the linear map when the kernel is
> running normally.
>
> When going into hibernation or waking up from it, these regions need to
> be mapped, so map the region initially, and toggle the valid bit so
> map/unmap the region as needed.
>
> Doing so is required because pages covering the kernel image are marked
> as PageReserved, and therefore disregarded for snapshotting by the
> hibernate logic unless they are mapped.
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
This commit landed in yesterday's linux-next as commit 63e0b6a5b693
("arm64: mm: Unmap kernel data/bss entirely from the linear map").
In my tests I found that it breaks booting of RaspberryPi3 and
RaspberryPi4 boards with the following kernel panic:

kvm [1]: nv: 570 coarse grained trap handlers
kvm [1]: nv: 710 fine grained trap handlers
kvm [1]: IPA Size Limit: 40 bits
Unable to handle kernel paging request at virtual address ffff000003a23000
Mem abort info:
  ESR = 0x0000000096000147
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x07: level 3 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000147, ISS2 = 0x00000000
  CM = 1, WnR = 1, TnD = 0, TagAccess = 0
  GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000002609000
[ffff000003a23000] pgd=0000000000000000, p4d=180000003b3ff403, pud=180000003b3fe403, pmd=180000003b3e6403, pte=00e8000003a23f06
Internal error: Oops: 0000000096000147 [#1]  SMP
Modules linked in:
CPU: 3 UID: 0 PID: 1 Comm: swapper/0 Not tainted 7.1.0-rc1+ #16768 PREEMPT
Hardware name: Raspberry Pi 3 Model B (DT)
pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : dcache_clean_inval_poc+0x24/0x48
lr : kvm_arm_init+0xa8c/0x165c
sp : ffff8000844bbd00
...
Call trace:
 dcache_clean_inval_poc+0x24/0x48 (P)
 do_one_initcall+0x68/0x4f4
 kernel_init_freeable+0x24c/0x360
 kernel_init+0x24/0x1dc
 ret_from_fork+0x10/0x20
Code: 9ac32042 d1000443 8a230000 d503201f (d50b7e20)
---[ end trace 0000000000000000 ]---
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
SMP: stopping secondary CPUs
Kernel Offset: disabled
CPU features: 0x00000000,03000008,00040000,0400421b
Memory Limit: none
---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b ]---



> ---
>  arch/arm64/mm/mmu.c | 45 ++++++++++++++++++--
>  1 file changed, 41 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 7b18dc2f1721..07a6fa210171 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -24,6 +24,7 @@
>  #include <linux/mm.h>
>  #include <linux/vmalloc.h>
>  #include <linux/set_memory.h>
> +#include <linux/suspend.h>
>  #include <linux/kfence.h>
>  #include <linux/pkeys.h>
>  #include <linux/mm_inline.h>
> @@ -1056,6 +1057,29 @@ static void __init __map_memblock(phys_addr_t start, phys_addr_t end,
>  				 end - start, prot, early_pgtable_alloc, flags);
>  }
>  
> +static void mark_linear_data_alias_valid(bool valid)
> +{
> +	set_memory_valid((unsigned long)lm_alias(__init_end),
> +			 (unsigned long)(__bss_stop - __init_end) / PAGE_SIZE,
> +			 valid);
> +}
> +
> +static int arm64_hibernate_pm_notify(struct notifier_block *nb,
> +				     unsigned long mode, void *unused)
> +{
> +	switch (mode) {
> +	default:
> +		break;
> +	case PM_POST_HIBERNATION:
> +		mark_linear_data_alias_valid(false);
> +		break;
> +	case PM_HIBERNATION_PREPARE:
> +		mark_linear_data_alias_valid(true);
> +		break;
> +	}
> +	return 0;
> +}
> +
>  void __init mark_linear_text_alias_ro(void)
>  {
>  	/*
> @@ -1064,6 +1088,21 @@ void __init mark_linear_text_alias_ro(void)
>  	update_mapping_prot(__pa_symbol(_text), (unsigned long)lm_alias(_text),
>  			    (unsigned long)__init_begin - (unsigned long)_text,
>  			    PAGE_KERNEL_RO);
> +
> +	/*
> +	 * Register a PM notifier to remap the linear alias of data/bss as
> +	 * valid read-only before hibernation. This is needed because the
> +	 * snapshot logic disregards PageReserved pages (such as the ones
> +	 * covering the kernel image) unless they are mapped in the linear
> +	 * map.
> +	 */
> +	if (IS_ENABLED(CONFIG_HIBERNATION)) {
> +		static struct notifier_block nb = {
> +			.notifier_call = arm64_hibernate_pm_notify
> +		};
> +
> +		register_pm_notifier(&nb);
> +	}
>  }
>  
>  #ifdef CONFIG_KFENCE
> @@ -1193,10 +1232,8 @@ static void __init map_mem(void)
>  			       flags);
>  	}
>  
> -	/* Map the kernel data/bss read-only in the linear map */
> -	__map_memblock(init_end, kernel_end, PAGE_KERNEL_RO, flags);
> -	flush_tlb_kernel_range((unsigned long)lm_alias(__init_end),
> -			       (unsigned long)lm_alias(__bss_stop));
> +	/* Map the kernel data/bss as invalid in the linear map */
> +	mark_linear_data_alias_valid(false);
>  }
>  
>  void mark_rodata_ro(void)

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland



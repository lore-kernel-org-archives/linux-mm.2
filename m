Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F005EE0AC3
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 10:37:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52C146B0089; Sat,  7 Feb 2026 05:37:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AF506B0092; Sat,  7 Feb 2026 05:37:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 383ED6B0093; Sat,  7 Feb 2026 05:37:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2649E6B0089
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 05:37:06 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AED65B920D
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 10:37:05 +0000 (UTC)
X-FDA: 84417308010.23.4D74852
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 02FE1100003
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 10:37:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cfYuL09Y;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770460624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FSUDcBsri7qYzrRkXH9I9k/QM3kDOL2TH7o2w54VR4A=;
	b=eA9UwTP3UsntyUrk6vGouEu6D+tQqo0BSD9/dTQ89M6o9rIl4Pfl6OsSAsoesnEeYhYy/y
	2D3kNmZZW9RrnE1BDOG4JcDch+OfNgkL5y7ZQb5zdue4kA/Qkscy3ZE1+6SX62rcgyxP0z
	EuEq+6zzINWiAax81rBNLOs6Jx5jSp8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cfYuL09Y;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770460624; a=rsa-sha256;
	cv=none;
	b=LLBJZ1J/dfABv7Gd3OvlzyK+prk+oQpyqrFNVRmC3tzgHzXJP2nCUbroOOp8uQIPfuEavO
	Kj9RFTLu/ThYKM9wjI6jVRYdAyBJ/XV7ozWyQTAo9NemvESAMI+WfXj77DWAGK9OaVzlRx
	yd9hJWsBckBEI7sVOkQMrDBgV+FBWuQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B848344328;
	Sat,  7 Feb 2026 10:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2BFC116D0;
	Sat,  7 Feb 2026 10:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770460622;
	bh=5txootZk9XnxQipltUnu1uJG2kCaI77i7XiNzSKLg6I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cfYuL09YPhGMJd7P35kyjr0lAxa/iHu/YfsEkzH8LubrxmisxkzKdBFcs1Y2N2MU2
	 dvs+BpQiIMu7RNuFgOa2U4lhfkQQMWEApPyUIFI4G5jPDx5SxM7vGgvEgcMaAZR3wb
	 b5TmWeYHqGOnIP6RUJQS0EZeSOfMx7DmDO3xOwzBoST0J5Zd5mVF9jwQn1yVKcNfBE
	 uWSTfKP2vKbdUd2LRGCkPloiDZT2rrMv/eHBuetCIurcEWl+GxWXDT1apLvIJsW7lK
	 ecWz7qUsRKRAGOnHYFNSzWF/NyB7DB8z+ZPDngeTtgHQpWl15K7AQ1eM41lt8lTvb6
	 U9okHU4kls45Q==
Date: Sat, 7 Feb 2026 12:36:43 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Andreas Larsson <andreas@gaisler.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Borislav Petkov <bp@alien8.de>, Brian Cain <bcain@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guo Ren <guoren@kernel.org>, Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matt Turner <mattst88@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	Stafford Horne <shorne@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>, Vineet Gupta <vgupta@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
	linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-sh@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
	linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH mm-unstable] arch, mm: consolidate empty_zero_page
Message-ID: <aYcVu7gs65S1CeST@kernel.org>
References: <20260124095628.668870-1-rppt@kernel.org>
 <2157220c-0394-40fa-9918-a8514171bd10@gaisler.com>
 <aXj_x5CyUeys7ONM@kernel.org>
 <ec965a79-dad8-4358-a8e9-ebc9f330b67b@gaisler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec965a79-dad8-4358-a8e9-ebc9f330b67b@gaisler.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: rfyx6o5n7wetw94xjpwhbs1b6cdc6xe1
X-Rspamd-Queue-Id: 02FE1100003
X-Rspam-User: 
X-HE-Tag: 1770460623-827122
X-HE-Meta: U2FsdGVkX18EdRsgUgFZ5QH7pqgswPu6Mq+arXu0ZRYIYA1kINnj9NiCxamR4xzoovifaN9+cVYvOD6y7xfxy6BVMiu0IGghtUvI6St8C/nvisNQCAUzWn6DBRUySjpGGc58yNQJ7c4JpJVpeT+GMHuPtpof6t5xdqxs6aVCVcDHalernsuvK5+d5ugMFA7ix3Hvu/EkATPeeGreKYD+7CV9IDP+Lv6UA9ajyC59bHUthdV54NQzKganTy69t5D7+RkszSV2TasNhZWHI1hnvi4x7DvKCNqU0cYnD62w+fpWwKvaX4PEKBsw0eleEasKVfLfeVbqUmZpSEF/a8irw/ruW4eRpAA4Graoqgc2hLa/aWaukz68VBe1QyyCQeBSwjSpn6TxnUsEOf7M0M+qWlKGwVHDtvqHmEJHzjDYb1F2UAJRUxwAHXC6pY7rziDgTjUwtG8WxN/nDWqd6kRTzl3LS9k+GFig1OU1mhwJYpwJoSxEh21hqUIZt6nJXHq/VzQlxsqzCUWndAZzlDr46JL3qTE7xxVoqwPeciiW/FhD5hT1nCoXApXqU6+KiAEYbRihELL8H5gF9o796U+ottPXMyLtum2WGfjENgwq3kPVVZkRsp1VRaNzxTQRTb+b++1/mZN/EWH/aEdJeLmHCxKoEJn6+owf3JHl4wIhurFfuSFn0VRmigZv1bLvVUmxEUUyVA4CMXPFa0Opg/u/gZeLLr+EEhIdaXMV3kxA4WYjhXf17SrTRB3t4cybmzAs2fbVT/AToOSOlctwUhU2jCuKIcy2rMHPdY0ZsAfaXHLSglD0MUJJREJLGxXqsIOOiFM2x1a+IHGZRF9RwJqxypyRsKt98Wv5Nhnjer2qnwQz/oAjPFABO27w6QTMnv5RY3VMOotf1IOAU+3LPjt8QLhdZbF4s5gowDIHjPWBLUORu0Zid0IY7s8dPOCKsLdMq/DQRT8zlJHs03sLitH
 r4WoXrqP
 sMj6x
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 11:17:08AM +0100, Andreas Larsson wrote:
> On 2026-01-27 19:11, Mike Rapoport wrote:
> > On Tue, Jan 27, 2026 at 05:02:39PM +0100, Andreas Larsson wrote:
> >> On 2026-01-24 10:56, Mike Rapoport wrote:
> >>
> >>> Every architecture defines empty_zero_page that way or another, but for the
> >>> most of them it is always a page aligned page in BSS and most definitions
> >>> of ZERO_PAGE do virt_to_page(empty_zero_page).
> >>
> >> Running this in an LDOM on an UltraSparc T4 sparc64, the entire LDOM
> >> hangs after a while during boot.
> >>
> >>> diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
> >>> index c2d19c9a9244..2bd99944176d 100644
> >>> --- a/arch/sparc/mm/init_64.c
> >>> +++ b/arch/sparc/mm/init_64.c
> >>> @@ -177,9 +177,6 @@ extern unsigned long sparc_ramdisk_image64;
> >>>  extern unsigned int sparc_ramdisk_image;
> >>>  extern unsigned int sparc_ramdisk_size;
> >>>  
> >>> -struct page *mem_map_zero __read_mostly;
> >>> -EXPORT_SYMBOL(mem_map_zero);
> >>> -
> >>>  unsigned int sparc64_highest_unlocked_tlb_ent __read_mostly;
> >>>  
> >>>  unsigned long sparc64_kern_pri_context __read_mostly;
> >>> @@ -2506,18 +2503,6 @@ void __init mem_init(void)
> >>>  	 */
> >>>  	register_page_bootmem_info();
> >>>  
> >>> -	/*
> >>> -	 * Set up the zero page, mark it reserved, so that page count
> >>> -	 * is not manipulated when freeing the page from user ptes.
> >>> -	 */
> >>> -	mem_map_zero = alloc_pages(GFP_KERNEL|__GFP_ZERO, 0);
> >>> -	if (mem_map_zero == NULL) {
> >>> -		prom_printf("paging_init: Cannot alloc zero page.\n");
> >>> -		prom_halt();
> >>> -	}
> >>> -	mark_page_reserved(mem_map_zero);
> >>> -
> >>> -
> >>>  	if (tlb_type == cheetah || tlb_type == cheetah_plus)
> >>>  		cheetah_ecache_flush_init();
> >>>  }
> >>
> >> This just removes the mark_page_reserved(mem_map_zero) without 
> >> replacing it with something corresponding to that. Perhaps part
> >> of the problem?
> > 
> > I don't think so, empty_zero_page is in BSS now an it's reserved as a part
> > of the kernel image.
> > 
> > I suspect that virt_to_page() does not work BSS symbols on sparc64. Can you
> > please try with this patch:
> > 
> > diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
> > index 74ede706fb32..0578c5172d4e 100644
> > --- a/arch/sparc/include/asm/pgtable_64.h
> > +++ b/arch/sparc/include/asm/pgtable_64.h
> > @@ -22,6 +22,7 @@
> >  #include <asm/adi.h>
> >  #include <asm/page.h>
> >  #include <asm/processor.h>
> > +#include <asm/vaddrs.h>
> >  
> >  /* The kernel image occupies 0x4000000 to 0x6000000 (4MB --> 96MB).
> >   * The page copy blockops can use 0x6000000 to 0x8000000.
> > @@ -210,6 +211,11 @@ extern unsigned long _PAGE_CACHE;
> >  extern unsigned long pg_iobits;
> >  extern unsigned long _PAGE_ALL_SZ_BITS;
> >  
> > +extern unsigned long kern_base;
> > +#define ZERO_PAGE(vaddr)						   \
> > +	(virt_to_page(empty_zero_page + ((unsigned long)__va(kern_base)) - \
> > +		      ((unsigned long)KERNBASE)))
> > +
> >  /* PFNs are real physical page numbers.  However, mem_map only begins to record
> >   * per-page information starting at pfn_base.  This is to handle systems where
> >   * the first physical page in the machine is at some huge physical address,
> > diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
> > index 2bd99944176d..d2d724ba4f83 100644
> > --- a/arch/sparc/mm/init_64.c
> > +++ b/arch/sparc/mm/init_64.c
> > @@ -170,6 +170,8 @@ static void __init read_obp_memory(const char *property,
> >  
> >  /* Kernel physical address base and size in bytes.  */
> >  unsigned long kern_base __read_mostly;
> > +EXPORT_SYMBOL(kern_base);
> > +
> >  unsigned long kern_size __read_mostly;
> >  
> >  /* Initial ramdisk setup */
> Hi,
> 
> Unfortunately, that does not help. The LDOM goes down in the same fashion.

Apparently something is wrong with my pointer arithmetics :/

Can you try this one instead?

diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 74ede706fb32..615f460c50af 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -210,6 +210,9 @@ extern unsigned long _PAGE_CACHE;
 extern unsigned long pg_iobits;
 extern unsigned long _PAGE_ALL_SZ_BITS;
 
+extern struct page *mem_map_zero;
+#define ZERO_PAGE(vaddr)	(mem_map_zero)
+
 /* PFNs are real physical page numbers.  However, mem_map only begins to record
  * per-page information starting at pfn_base.  This is to handle systems where
  * the first physical page in the machine is at some huge physical address,
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 2bd99944176d..aa1f9f071fb2 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -177,6 +177,9 @@ extern unsigned long sparc_ramdisk_image64;
 extern unsigned int sparc_ramdisk_image;
 extern unsigned int sparc_ramdisk_size;
 
+struct page *mem_map_zero __read_mostly;
+EXPORT_SYMBOL(mem_map_zero);
+
 unsigned int sparc64_highest_unlocked_tlb_ent __read_mostly;
 
 unsigned long sparc64_kern_pri_context __read_mostly;
@@ -2495,6 +2498,9 @@ static void __init register_page_bootmem_info(void)
 }
 void __init mem_init(void)
 {
+	phys_addr_t zero_page_pa = kern_base +
+		((unsigned long)&empty_zero_page[0] - KERNBASE);
+
 	/*
 	 * Must be done after boot memory is put on freelist, because here we
 	 * might set fields in deferred struct pages that have not yet been
@@ -2503,6 +2509,12 @@ void __init mem_init(void)
 	 */
 	register_page_bootmem_info();
 
+	/*
+	 * Set up the zero page, mark it reserved, so that page count
+	 * is not manipulated when freeing the page from user ptes.
+	 */
+	mem_map_zero = pfn_to_page(PHYS_PFN(zero_page_pa));
+
 	if (tlb_type == cheetah || tlb_type == cheetah_plus)
 		cheetah_ecache_flush_init();
 }

-- 
Sincerely yours,
Mike.


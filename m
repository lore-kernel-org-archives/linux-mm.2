Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85B25D2FECD
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 18:11:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C7546B0088; Tue, 27 Jan 2026 13:11:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 574966B0089; Tue, 27 Jan 2026 13:11:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 455816B008A; Tue, 27 Jan 2026 13:11:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 33EC16B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:11:41 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99906C182E
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 18:11:40 +0000 (UTC)
X-FDA: 84378536760.12.1FED591
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 12A8040016
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 18:11:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ByaWjtsS;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769537499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2GTgDTMSjRtu9XA/FLPKOljq2ml0hMhzhLI6yqYD4CI=;
	b=EFb9qxQUV3czWI3Y+abwyULuvLxNnwWcSU1jJcX8Q+sGUzIDHwbgt7U08WiRO8ZGOMBkul
	awfNCx61DSrlU1nZT1OTQDfCxpiioXZnDOmQRkk2iRTzbwKwT4leWYjVmQe+zcmr8CpIV5
	J0I9KODb8Ij1dFybDhVtdXsjU4xVcIw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ByaWjtsS;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769537499; a=rsa-sha256;
	cv=none;
	b=X+opd8ByNKvaiF09HJiFEhdAZ2aUfzqTd4+x7Gkl/QGMR90SZqeclWmou4dzVGzAZHWmuG
	1RiBEE7dckmCqbpc2ziqqhQG4Qaj5gkCQx70fP/fUoG6vUWSCCc2dkkBojDrBOUJxOveF9
	wu4c8KtqgABRvd/lo/Bd0buEYvVVRF0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 503606013B;
	Tue, 27 Jan 2026 18:11:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4A5C116C6;
	Tue, 27 Jan 2026 18:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769537498;
	bh=esR6CFIdT2IldE04x541sMjzg2hM0kwiBu50M1Q4i6U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ByaWjtsSvwoLSW/kNH7xWLyVjxxz5GlRC8jYXsgV/gqb4/lcnR/DbPtvL6ZsfFpSk
	 UMuJqyvtKtohQKsmQxoM99rDtG1O4GqRTw9ZhQsEmWLSfLiBrUcxYInGfM89HyeRgM
	 CxuZITcoVajun6fKU8J38DnbH8BoWcjGzNDWtXdHngn0Bx8YWSVtKYdo5/nJpd1YVl
	 JH22ZwPPk16pgnbMx9Vr3rouzXVb84WvDBKXKk6PK90HPv2OIOvHU6AimhWntYIXkX
	 +GnE9E9QwmWlr81X+KXfieSH8beDfJtCHQfJLkjpSxZ2STIQw2Fz3NkhSNYKoguw1h
	 QmmKWVv1yE1UQ==
Date: Tue, 27 Jan 2026 20:11:19 +0200
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
Message-ID: <aXj_x5CyUeys7ONM@kernel.org>
References: <20260124095628.668870-1-rppt@kernel.org>
 <2157220c-0394-40fa-9918-a8514171bd10@gaisler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2157220c-0394-40fa-9918-a8514171bd10@gaisler.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 12A8040016
X-Stat-Signature: khxst6ie8phgxku5xxwabptz8y5nhjss
X-Rspam-User: 
X-HE-Tag: 1769537498-878693
X-HE-Meta: U2FsdGVkX1/J+OoNo9TqXLmwv/Q5LWCkGExCqfGzprhoT2d/KVb3o4azXSTEzJ+wyYwTCvMR6mWL3ldSHg8dNotRjN3y4yWrUIn17SyYrZCHpESraluQlBb93cbXQ4lnuPFAVkvXgVWC7uegxpoJVldIXSSQC+CCWRM6N+ny6RRseGPTnh3v/EeQMiTseZkllUXNwDDdR3V7QN9EPB16Zqt7zJARzXwwUFLoIAosH8nL+LXOcZR33fAluoIqKoQYcNOJFKosDZMlI7JYPtjr4Rc6+UWZ2xRhUhfYsy8PqWgo392eExZQhtqzSSbRSFhJzvln67ow1fQc+MTKmJ8MAN2LePYlfSa0yNBMDy/pBm4hzXU6lcDX2mMqORn2EjKxnKvoKZEJd1Ub+3dRIcwNKK95vJ7reKMwrGli0TvQAj6ZxkuWljkVIIPGNvxv8TzNiHZewAx8gX6MlBOzFjDBvnBGR7jgmfomN7n3dQR9wXdP6tM1Z6qenUc7lqP4gi2jtFNO8bz6IXbshKpvBkuChluWo7q1EKkbdDjmKzQbmD8pwMFAu5+q0CG1x/99+NwI6ujYHjteKVwz8Oe+vC0HcfT/rrNIQHAjV3J1EXcx0xDP5EKSPXGYlU4YQklGK1eoXeHAelnmva1JryUdp0LfkC+mnzqBYZiM6+3IwIgTuZn8WWvTaBmcLfzz7i+HSaiRSunXI4k5tRfaisCB0HjwSc9IU3F1q1RNEGtM0UJSzqP+Y+H05x5tOXN8897jj9Hobksx1BxzrykrW23bOQn0/C2kFkjEEdhtJr2EtrzQZzJw8Ig6vUpmYA2SS1P3DHmtnqlJSpIyNsv7Gy0ER/1L3mpPxizTrahW10G4cBZkKu7kLoYI2fhXR0oUkbDMXtgZqKgWNYRkjmt5S06cZxUmX6J18FlujS73xqsgSJ0d5vDYvea/4rHWtVp+MIwq3fotlxZfNiMIMnemKOGLjjQ
 5Qbi/8gq
 0quUJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Tue, Jan 27, 2026 at 05:02:39PM +0100, Andreas Larsson wrote:
> On 2026-01-24 10:56, Mike Rapoport wrote:
>
> > Every architecture defines empty_zero_page that way or another, but for the
> > most of them it is always a page aligned page in BSS and most definitions
> > of ZERO_PAGE do virt_to_page(empty_zero_page).
> 
> Running this in an LDOM on an UltraSparc T4 sparc64, the entire LDOM
> hangs after a while during boot.
> 
> > diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
> > index c2d19c9a9244..2bd99944176d 100644
> > --- a/arch/sparc/mm/init_64.c
> > +++ b/arch/sparc/mm/init_64.c
> > @@ -177,9 +177,6 @@ extern unsigned long sparc_ramdisk_image64;
> >  extern unsigned int sparc_ramdisk_image;
> >  extern unsigned int sparc_ramdisk_size;
> >  
> > -struct page *mem_map_zero __read_mostly;
> > -EXPORT_SYMBOL(mem_map_zero);
> > -
> >  unsigned int sparc64_highest_unlocked_tlb_ent __read_mostly;
> >  
> >  unsigned long sparc64_kern_pri_context __read_mostly;
> > @@ -2506,18 +2503,6 @@ void __init mem_init(void)
> >  	 */
> >  	register_page_bootmem_info();
> >  
> > -	/*
> > -	 * Set up the zero page, mark it reserved, so that page count
> > -	 * is not manipulated when freeing the page from user ptes.
> > -	 */
> > -	mem_map_zero = alloc_pages(GFP_KERNEL|__GFP_ZERO, 0);
> > -	if (mem_map_zero == NULL) {
> > -		prom_printf("paging_init: Cannot alloc zero page.\n");
> > -		prom_halt();
> > -	}
> > -	mark_page_reserved(mem_map_zero);
> > -
> > -
> >  	if (tlb_type == cheetah || tlb_type == cheetah_plus)
> >  		cheetah_ecache_flush_init();
> >  }
> 
> This just removes the mark_page_reserved(mem_map_zero) without 
> replacing it with something corresponding to that. Perhaps part
> of the problem?

I don't think so, empty_zero_page is in BSS now an it's reserved as a part
of the kernel image.

I suspect that virt_to_page() does not work BSS symbols on sparc64. Can you
please try with this patch:

diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 74ede706fb32..0578c5172d4e 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -22,6 +22,7 @@
 #include <asm/adi.h>
 #include <asm/page.h>
 #include <asm/processor.h>
+#include <asm/vaddrs.h>
 
 /* The kernel image occupies 0x4000000 to 0x6000000 (4MB --> 96MB).
  * The page copy blockops can use 0x6000000 to 0x8000000.
@@ -210,6 +211,11 @@ extern unsigned long _PAGE_CACHE;
 extern unsigned long pg_iobits;
 extern unsigned long _PAGE_ALL_SZ_BITS;
 
+extern unsigned long kern_base;
+#define ZERO_PAGE(vaddr)						   \
+	(virt_to_page(empty_zero_page + ((unsigned long)__va(kern_base)) - \
+		      ((unsigned long)KERNBASE)))
+
 /* PFNs are real physical page numbers.  However, mem_map only begins to record
  * per-page information starting at pfn_base.  This is to handle systems where
  * the first physical page in the machine is at some huge physical address,
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 2bd99944176d..d2d724ba4f83 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -170,6 +170,8 @@ static void __init read_obp_memory(const char *property,
 
 /* Kernel physical address base and size in bytes.  */
 unsigned long kern_base __read_mostly;
+EXPORT_SYMBOL(kern_base);
+
 unsigned long kern_size __read_mostly;
 
 /* Initial ramdisk setup */
 
> Cheers,
> Andreas

-- 
Sincerely yours,
Mike.


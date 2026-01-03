Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A256FC6174
	for <linux-mm@archiver.kernel.org>; Sat,  3 Jan 2026 08:39:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF76C6B00A2; Sat,  3 Jan 2026 03:39:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA4CE6B00A3; Sat,  3 Jan 2026 03:39:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A2C26B00A4; Sat,  3 Jan 2026 03:39:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 891B76B00A2
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 03:39:26 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E7A9BC03EF
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 08:39:25 +0000 (UTC)
X-FDA: 84290003490.10.82C2D81
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf12.hostedemail.com (Postfix) with ESMTP id D4D1740002
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 08:39:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iEJvQZUc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767429564; a=rsa-sha256;
	cv=none;
	b=6G2Uo6XElNkQsoYuHooaDNwwH+zeqnqB3I+HrqQ25kyAKazs/9Q9TCHj2tLAuYD5ItrgBg
	MBV3n4u0Ig5wGMTs/GIRVFa+sgxg5K2g+NoGfhcJvI/CHCQ559JdEt+uvS/r/DX8PP9/4D
	65Uzao0PAyNr+GlaWn+VvWAIH8Rdmsk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iEJvQZUc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767429564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7OjfT8QygV/9IkypXdM6tQtyzkm4OsqeUOl80eRwm6A=;
	b=FH+kefO/p1eiEhfxIg8WCffJr9kKeewNp4xnU7+go/lsWW5zYklFEJta+kB582xEWY/Mqb
	4j6AaD6tq32w5K5ZC4CPEyHCIW7a/Pr1OkNRjivE5mwPRhVLcS7ZHGzZ7dZbXJzy/7Li5U
	Y8P//OS4nmCw4JF07eM7iFsgiKvUrg4=
Message-ID: <fc3c20a9-69a2-41eb-9f22-8df262717348@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767429558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7OjfT8QygV/9IkypXdM6tQtyzkm4OsqeUOl80eRwm6A=;
	b=iEJvQZUcy26Jx3TS6d3XXtQYn84JrNobUoTRlR6pCcevu4gIgJIFSBZjboXngtDewNWvfm
	q6p9kLkt1xS5lXfjlJQQ2GcFLg9mnUTkyK54pe5uONlgnCmGX11O21bt8AGqeP5g3JpRlH
	UPrWXG4RvDBbm24m2wekcLwZ/mgJ1s0=
Date: Sat, 3 Jan 2026 16:39:06 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 0/3] skip redundant TLB sync IPIs
Content-Language: en-US
To: Dave Hansen <dave.hansen@intel.com>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, ioworker0@gmail.com,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20251229145245.85452-1-lance.yang@linux.dev>
 <f81b98e5-87c0-4c21-9a75-ad5f9b6af6aa@intel.com>
 <1b27a3fa-359a-43d0-bdeb-c31341749367@kernel.org>
 <cea71c01-68e7-4f7f-9931-017109d95ef0@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <cea71c01-68e7-4f7f-9931-017109d95ef0@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D4D1740002
X-Stat-Signature: y89mz4cc465gzsuqzucsx3xupec9wprs
X-HE-Tag: 1767429563-67366
X-HE-Meta: U2FsdGVkX186VxOE12A/wGpKapWgbj9wFfAWwcnkDzObVQkYpKGEXD59rmSaT9Li5Vu3l+95LRRooUCajWdzMlR5aZrPaOcts+ZxI8yGqtL/2azbb289lb+jd0s6W4GKBkgLtxIbYOis5FtDTrM6unqkTXnB2yNWViK3fusacdFn8tpGM/PNM+SDfSKghskjAnHBlJDgyXoLBfdIpQeQlx85DkHoLr7t2yVAobO93haTk14qu5msCSov3qKJ5NmvhTzxorDTsAIm3GVouvQ3Z51hlPUIfumFFcgAhvqIIJDBp4bspxEhKIc9SY8XcGxbKweLA84q/0xmuAgTs6flmVfa/GmF2MWGxy7t8/0MpApTmH6qAsWsGdbx9iZ0hxM7hauM3O3kpKdOHhs90tSuIi4dYhN4coCkQWh5Xv2Wmwy2Qv8BuWBDlwTo5j4GE0MqhuKCkTK2UTGjGlfXmoaJmRgWXWROCyqA3klDlB7CZgt6mc4y/8y67wo4lvWpjOLbAOBH2fCGkXAwCRMN3co+YEFXdMy5V2vS0L65XvnSEVfYsU8qeqI+U72/mMQ6NRvMAQ5rpdtcNVp0lD/KbCJxp2/itt1kbX2jhyX7wv6krY5PKHOvI2/3FNOW6XpGKziQ8I08J0+QtKqAzGqO8NWDyWCJq6Pn3ePURu8brq8FPNOyS+eexm++X4oGObLYPfHTQOFzbZ7eAjVG5/TuPVtq15N2lVmb1pJiLeNDajP+dfZ5c6BUO3TMrYjO8tEB/1i0MvZz4/H5M6FejkYtgicbDmC/ucgNq6Z/Qzi3BBuZ8LoQT1c4totecg/Dsjnztp8rcyBInp0+YtYnR3XAF8X2rq0XWvP9Z6Dc+PRbNQBhDvrxgHr93JKUBY4BCyFFS0Sq2l8gUVeOkNod4gviuTEr7R8auyGbWjG/FxJyRMKbG5JNEb6b2SyL9tYidB38NljB7yoyYA3XeMxDZWDNXk3
 n8UaryeC
 dx2JJO2cWiWoNOIYrNqGPVOuFQCqi66ueRvm85bamRN1ZB01rsio9alaP6wKnwUPRRgLotyC4FdCs/ZYTimSOp2MJEM5Dz/TiLeesgItpq6o/vJGQr6Er/d3mzRjrhsqBJQ/8tBU+CyA6a1YsZWeSBxG/Dc1I00eWQtrZSk0gDMTLVkqu8XfoWxcyAh7+aF49mWJDP9Qxs64LvOqKtQLQvvwyrJFMBkfRnilCH20CgYNs5Cs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/3 00:41, Dave Hansen wrote:
> On 12/31/25 04:33, David Hildenbrand (Red Hat) wrote:
>> On 12/31/25 05:26, Dave Hansen wrote:
>>> On 12/29/25 06:52, Lance Yang wrote:
>>> ...
>>>> This series introduces a way for architectures to indicate their TLB
>>>> flush
>>>> already provides full synchronization, allowing the redundant IPI to be
>>>> skipped. For now, the optimization is implemented for x86 first and
>>>> applied
>>>> to all page table operations that free or unshare tables.
>>>
>>> I really don't like all the complexity here. Even on x86, there are
>>> three or more ways of deriving this. Having the pv_ops check the value
>>> of another pv op is also a bit unsettling.
>>
>> Right. What I actually meant is that we simply have a property "bool
>> flush_tlb_multi_implies_ipi_broadcast" that we set only to true from the
>> initialization code.
>>
>> Without comparing the pv_ops.
>>
>> That should reduce the complexity quite a bit IMHO.
> 
> Yeah, that sounds promising.

Thanks a lot for taking the time to review!

Yeah, I simplified things to just a bool property set during init
(no pv_ops comparison at runtime) as follows:

---8<---
diff --git a/arch/x86/include/asm/paravirt.h 
b/arch/x86/include/asm/paravirt.h
index 13f9cd31c8f8..a926d459e6f5 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -698,6 +698,7 @@ static __always_inline unsigned long 
arch_local_irq_save(void)

  extern void default_banner(void);
  void native_pv_lock_init(void) __init;
+void setup_pv_tlb_flush_ipi_broadcast(void) __init;

  #else  /* __ASSEMBLER__ */

@@ -727,6 +728,10 @@ void native_pv_lock_init(void) __init;
  static inline void native_pv_lock_init(void)
  {
  }
+
+static inline void setup_pv_tlb_flush_ipi_broadcast(void)
+{
+}
  #endif
  #endif /* !CONFIG_PARAVIRT */

diff --git a/arch/x86/include/asm/paravirt_types.h 
b/arch/x86/include/asm/paravirt_types.h
index 3502939415ad..7c010d8bee60 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -133,6 +133,12 @@ struct pv_mmu_ops {
  	void (*flush_tlb_multi)(const struct cpumask *cpus,
  				const struct flush_tlb_info *info);

+	/*
+	 * Indicates whether flush_tlb_multi IPIs provide sufficient
+	 * synchronization for GUP-fast when freeing or unsharing page tables.
+	 */
+	bool flush_tlb_multi_implies_ipi_broadcast;
+
  	/* Hook for intercepting the destruction of an mm_struct. */
  	void (*exit_mmap)(struct mm_struct *mm);
  	void (*notify_page_enc_status_changed)(unsigned long pfn, int npages, 
bool enc);
diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
index 866ea78ba156..f570c7b2d03e 100644
--- a/arch/x86/include/asm/tlb.h
+++ b/arch/x86/include/asm/tlb.h
@@ -5,10 +5,23 @@
  #define tlb_flush tlb_flush
  static inline void tlb_flush(struct mmu_gather *tlb);

+#define tlb_table_flush_implies_ipi_broadcast 
tlb_table_flush_implies_ipi_broadcast
+static inline bool tlb_table_flush_implies_ipi_broadcast(void);
+
  #include <asm-generic/tlb.h>
  #include <linux/kernel.h>
  #include <vdso/bits.h>
  #include <vdso/page.h>
+#include <asm/paravirt.h>
+
+static inline bool tlb_table_flush_implies_ipi_broadcast(void)
+{
+#ifdef CONFIG_PARAVIRT
+	return pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast;
+#else
+	return !cpu_feature_enabled(X86_FEATURE_INVLPGB);
+#endif
+}

  static inline void tlb_flush(struct mmu_gather *tlb)
  {
@@ -20,7 +33,8 @@ static inline void tlb_flush(struct mmu_gather *tlb)
  		end = tlb->end;
  	}

-	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, tlb->freed_tables);
+	flush_tlb_mm_range(tlb->mm, start, end, stride_shift,
+			   tlb->freed_tables || tlb->unshared_tables);
  }

  static inline void invlpg(unsigned long addr)
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index ab3e172dcc69..0a49c2d79693 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -60,6 +60,23 @@ void __init native_pv_lock_init(void)
  		static_branch_enable(&virt_spin_lock_key);
  }

+void __init setup_pv_tlb_flush_ipi_broadcast(void)
+{
+	/*
+	 * For native TLB flush, if we don't have INVLPGB, we use IPI-based
+	 * flushing which sends real IPIs to all CPUs. This provides sufficient
+	 * synchronization for GUP-fast.
+	 *
+	 * For paravirt (e.g., KVM, Xen, HyperV), hypercalls may not send real
+	 * IPIs, so we keep the default value of false. Only set to true when
+	 * using native flush_tlb_multi without INVLPGB.
+	 */
+	if (pv_ops.mmu.flush_tlb_multi == native_flush_tlb_multi &&
+	    !cpu_feature_enabled(X86_FEATURE_INVLPGB))
+		pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast = true;
+}
+
+
  struct static_key paravirt_steal_enabled;
  struct static_key paravirt_steal_rq_enabled;

@@ -173,6 +190,7 @@ struct paravirt_patch_template pv_ops = {
  	.mmu.flush_tlb_kernel	= native_flush_tlb_global,
  	.mmu.flush_tlb_one_user	= native_flush_tlb_one_user,
  	.mmu.flush_tlb_multi	= native_flush_tlb_multi,
+	.mmu.flush_tlb_multi_implies_ipi_broadcast = false,

  	.mmu.exit_mmap		= paravirt_nop,
  	.mmu.notify_page_enc_status_changed	= paravirt_nop,
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 74aa904be6dc..3f673e686b12 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -51,6 +51,7 @@
  #include <asm/olpc_ofw.h>
  #include <asm/pci-direct.h>
  #include <asm/prom.h>
+#include <asm/paravirt.h>
  #include <asm/proto.h>
  #include <asm/realmode.h>
  #include <asm/thermal.h>
@@ -1257,6 +1258,7 @@ void __init setup_arch(char **cmdline_p)
  	io_apic_init_mappings();

  	x86_init.hyper.guest_late_init();
+	setup_pv_tlb_flush_ipi_broadcast();

  	e820__reserve_resources();
  	e820__register_nosave_regions(max_pfn);
---

> 
>> But maybe you have an even better way on how to indicate support, in a
>> very simple way.
> 
> Rather than having some kind of explicit support enumeration, the other
> idea I had would be to actually track the state about what needs to get
> flushed somewhere. For instance, even CPUs with enabled INVLPGB support
> still use IPIs sometimes. That makes the
> tlb_table_flush_implies_ipi_broadcast() check a bit imperfect as is
> because it will for the extra sync IPI even when INVLPGB isn't being
> used for an mm.
> 
> First, we already save some semblance of support for doing different
> flushes when freeing page tables mmu_gather->freed_tables. But, the call
> sites in question here are for a single flush and don't use mmu_gathers.
> 
> The other pretty straightforward thing to do would be to add something
> to mm->context that indicates that page tables need to be freed but
> there might still be wild gup walkers out there that need an IPI. It
> would get set when the page tables are modified and cleared at all the
> sites where an IPIs are sent.

Thanks for the suggestion! The mm->context tracking idea makes a lot
of sense - it would handle those mixed INVLPGB/IPI cases much better :)

Maybe we could do that as a follow-up. I'd like to keep things simple
for now, so we just add a bool property to skip redundant TLB sync IPIs
on systems without INVLPGB support.

Then we could add the mm->context (or something similar) tracking later
to handle things more precisely.

Anyway, I'm open to going straight to the mm->context approach as well
and happy to do that instead :D

Thanks,
Lance

> 
> 
>>> That said, complexity can be worth it with sufficient demonstrated
>>> gains. But:
>>>
>>>> When unsharing hugetlb PMD page tables or collapsing pages in
>>>> khugepaged,
>>>> we send two IPIs: one for TLB invalidation, and another to synchronize
>>>> with concurrent GUP-fast walkers.
>>>
>>> Those aren't exactly hot paths. khugepaged is fundamentally rate
>>> limited. I don't think unsharing hugetlb PMD page tables just is all
>>> that common either.
>>
>> Given that the added IPIs during unsharing broke Oracle DBs rather badly
>> [1], I think this is actually a case worth optimizing.
> ...
>> [1] https://lkml.kernel.org/r/20251223214037.580860-1-david@kernel.org
> 
> Gah, that's good context, thanks.
> 
> Are there any tests out there that might catch these this case better?
> It might be something good to have 0day watch for.



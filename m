Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C460C2A062
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 13:23:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 427006B0092; Sun,  4 Jan 2026 08:23:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FF956B0093; Sun,  4 Jan 2026 08:23:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D4B86B0095; Sun,  4 Jan 2026 08:23:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 13A796B0092
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 08:23:28 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 98B57160B92
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 13:23:27 +0000 (UTC)
X-FDA: 84294348054.02.B2D9AEF
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5FC5B40004
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 13:23:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YEXSfE6G;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767533006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C8lByYb+6jQGQIWP4dIKjgreuMHG/LkQwoaWsBGcroc=;
	b=MNQfew6FvPIxPNUCmGe1ZTc3u+JJNFOqz1xVdniF/DO5EsbHEFDvwmZvVMy0obKYSBH0mR
	cOg7kQpBq4U3XpbVqiFJSVdx6H9V42w5rMTGI0SvnefunPrZa+bSHeqIhfhnrrHp+IQlZe
	8YWFCr7P7z64YJ0P/IPUB5yMb41lKTU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YEXSfE6G;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767533006; a=rsa-sha256;
	cv=none;
	b=IwYzZZWCEb4EloO+ROBrI5396Jx5CcaS4CLejhNj9io7wY3VvL038nbCoZfW6N7GzzLxFz
	vCOR1dbB8mZv4P/gLI7BbisXvUSYCnBOL7ixlcou6/tY+Pa9JzWrTmOnCR5VFL+vcRAMml
	9ITTuPXzjee2WyFLWMJa/fekc1vlT2I=
Message-ID: <73737138-1740-49be-86ae-79c872fab1bc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767533003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C8lByYb+6jQGQIWP4dIKjgreuMHG/LkQwoaWsBGcroc=;
	b=YEXSfE6GD4EBoiqIevr7Uyb1cCWsCtsV8lM1q+/TvPlNbXILVx1aAomHfBy1g+8a/jo8V0
	OcrNwHIZbJA3JeZrsWxfhBTh68MO3Yo5Hk2sMJguqa/OcxP7vGtkQrrMKFPeMFefGIdpDm
	t3Hdq21N3ZrSwXpGYdpQ/+ckkGBjQR8=
Date: Sun, 4 Jan 2026 21:23:00 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 0/3] skip redundant TLB sync IPIs
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
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
 <fc3c20a9-69a2-41eb-9f22-8df262717348@linux.dev>
 <f920487a-632c-407b-b092-7de87f66f4bb@intel.com>
 <60b0c7e2-4a04-4542-a95a-00e88a0cf00d@linux.dev>
In-Reply-To: <60b0c7e2-4a04-4542-a95a-00e88a0cf00d@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: z8two6mwxoi31u3zpzok6ehsydrhm8oz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5FC5B40004
X-HE-Tag: 1767533005-519049
X-HE-Meta: U2FsdGVkX18V5YoJrUxWB73EETwRafA35mk5jS42Ow0H8SAFewBPeQRGATSdBoCP3oG/s3CerWjQBcfSvDkOSnyzZuH6lOCnu2TUnXNhO81/h0tvJJ171jWBzfc82kQUZV3opiUyCLe/EKyzd64iIh640ksY+Nr7VSRHhppIbD4IUie4hMwV5n5Uhj3hu1yYfffleP4yLzrWqpUX3JKX95MSkW2lE4s0UpQ9tbeFvIWaKIRFANrbl8WxGzeaR5tLsFgRd7HRdJpqywdjwuFbIudqsi8yhMrfskhCJymRzoqnNfOi2tFk2xnI7Vc9Df8cGYluUjKzrKc1MnhSqt7cMB6cjsQQ24eInghcEFvTofLKf3NECavV8xbFctQlpmy9eRkQts/FUMXOCppwkc6rrT1qIJGSxz4JMpCQZ0gRchKE3P5kjewHJbz+Vit3+C2nknLcyDSVDB8899WAyMFXTUrzFQOeehHmT8TQbgnE7ddWUSXDFoTjCussL8IFEBxSS4EcFEMJ2dnmXLCJv+njmmG7CcWn5vPhm9180/XXi/ii5EjLCWdsIVQpe/omDFy9/jppVBayQ/uolwJe1NXU8YCIsBnkg3Kuvhhj7NO9v6WlyhiTd7lJ9R8xrkE4QkE0Zq4NJ9Z9eC/kzbW+6hPIp0eua05Iq344kCJKTB5ousAnkgyJ44Mb1OcZwGzKxUP+CkmOo3WaYMbUbS560OHIVp6gn3Na4ouXtjJl51C+Qe/rZd8NmrZooTyj/8xe8KMach/Z5p/cRqGCbgeXcWLNq4LjrCT0rR1dgII3s3Zw+neEs8uYPxcqyg//lcMqV+CVtqGKr+VsJh6mXB8LmAL2av+SsSAvTsFThV6LSzUkZIaqw6SFbxyP9at5XXcoONnpxaRzZP8+x/48hkUuMGhnuVkhgstmv010NYRktDwvp4/NKxDjL9DbwK0uyI2tamsO/m/vWKiy7qFOjM/CaCf
 LQ80PPH3
 D0kgqHNeDMAlndybvLQd7DCB8wDpIIH/KYdIOrxBxPnVuwl9dCkgAk9u/NNHiBVW3rKMxsIB8haWPFzAhc65dPYXoelNYl87IzleDTyMbNwFYpdETN6lxJ3jg9cTAgidIJO6C+LrgpZjwBiW5445lgqH3lYtoSadKbUBPqNLBf6Lq+qH/5wqJ5sxfL3fQmr3AxJmJWxA22AzaGAMGS1hY2GcNVNzrBGMR7rZGHGByW5vbbUff9bWWvdFmmbUPlSJ4x6q5OlVkF9FPAmNEp4WFd5gXl+PTndbft93n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/4 15:42, Lance Yang wrote:
> 
> 
> On 2026/1/4 01:06, Dave Hansen wrote:
>> On 1/3/26 00:39, Lance Yang wrote:
>> ...
>>> Maybe we could do that as a follow-up. I'd like to keep things simple
>>> for now, so we just add a bool property to skip redundant TLB sync IPIs
>>> on systems without INVLPGB support.
>>
>> It's not just INVLPGB support. Take a look at hyperv_flush_tlb_multi(),
>> for instance. It can eventually land back in native_flush_tlb_multi(),
>> but would also "fail" the pv_ops check in all cases.
> 
> Thanks for pointing that out!
> 
>>
>> It's not that Hyper-V performance is super important, it just that the
>> semantics of the chosen approach here are rather complicated.
> 
> Yep, got it ;)
> 
>>
>>> Then we could add the mm->context (or something similar) tracking later
>>> to handle things more precisely.
>>>
>>> Anyway, I'm open to going straight to the mm->context approach as well
>>> and happy to do that instead :D
>>
>> I'd really like to see what an mm->context approach looks like before we
>> go forward with what is being proposed here.
> 
> Actually, I went ahead and tried a simialr approach using tlb_gather to
> track IPI sends dynamically/precisely.
> 
> Seems simpler than the mm->context approach because:
> 
> 1) IIUC, mm->context tracking would need proper synchronization (CAS,
> handling concurrent flushes, etc.) which adds more complexity :)
> 
> 2) With tlb_gather we already have the right context at the right time -
> we just pass the tlb pointer through flush_tlb_mm_range() and set a
> flag when IPIs are actually sent.
> 
> The first one adds a tlb_flush_sent_ipi flag to mmu_gather and wires it
> through flush_tlb_mm_range(). When we call flush_tlb_multi(), we set
> the flag. Then tlb_gather_remove_table_sync_one() checks it and skips
> the IPI if it's set.
> 
> ---8<---
> When unsharing hugetlb PMD page tables, we currently send two IPIs: one
> for TLB invalidation, and another to synchronize with concurrent GUP-fast
> walkers via tlb_remove_table_sync_one().
> 
> However, if the TLB flush already sent IPIs to all CPUs (when freed_tables
> or unshared_tables is true), the second IPI is redundant. GUP-fast runs
> with IRQs disabled, so when the TLB flush IPI completes, any concurrent
> GUP-fast must have finished.
> 
> Add a tlb_flush_sent_ipi flag to struct mmu_gather to track whether IPIs
> were actually sent.
> 
> Introduce tlb_gather_remove_table_sync_one() which checks
> tlb_flush_sent_ipi and skips the IPI if redundant.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Suggested-by: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>   arch/x86/include/asm/tlb.h      |  3 ++-
>   arch/x86/include/asm/tlbflush.h |  8 ++++----
>   arch/x86/kernel/alternative.c   |  2 +-
>   arch/x86/kernel/ldt.c           |  2 +-
>   arch/x86/mm/tlb.c               |  6 ++++--
>   include/asm-generic/tlb.h       | 14 +++++++++-----
>   mm/mmu_gather.c                 | 24 ++++++++++++++++++------
>   7 files changed, 39 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
> index 866ea78ba156..c5950a92058c 100644
> --- a/arch/x86/include/asm/tlb.h
> +++ b/arch/x86/include/asm/tlb.h
> @@ -20,7 +20,8 @@ static inline void tlb_flush(struct mmu_gather *tlb)
>           end = tlb->end;
>       }
> 
> -    flush_tlb_mm_range(tlb->mm, start, end, stride_shift, tlb- 
>  >freed_tables);
> +    flush_tlb_mm_range(tlb->mm, start, end, stride_shift,
> +               tlb->freed_tables || tlb->unshared_tables, tlb);
>   }
> 
>   static inline void invlpg(unsigned long addr)
> diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/ 
> tlbflush.h
> index 00daedfefc1b..9524105659c3 100644
> --- a/arch/x86/include/asm/tlbflush.h
> +++ b/arch/x86/include/asm/tlbflush.h
> @@ -305,23 +305,23 @@ static inline bool mm_in_asid_transition(struct 
> mm_struct *mm) { return false; }
>   #endif
> 
>   #define flush_tlb_mm(mm)                        \
> -        flush_tlb_mm_range(mm, 0UL, TLB_FLUSH_ALL, 0UL, true)
> +        flush_tlb_mm_range(mm, 0UL, TLB_FLUSH_ALL, 0UL, true, NULL)
> 
>   #define flush_tlb_range(vma, start, end)                \
>       flush_tlb_mm_range((vma)->vm_mm, start, end,            \
>                  ((vma)->vm_flags & VM_HUGETLB)        \
>                   ? huge_page_shift(hstate_vma(vma))    \
> -                : PAGE_SHIFT, true)
> +                : PAGE_SHIFT, true, NULL)
> 
>   extern void flush_tlb_all(void);
>   extern void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
>                   unsigned long end, unsigned int stride_shift,
> -                bool freed_tables);
> +                bool freed_tables, struct mmu_gather *tlb);
>   extern void flush_tlb_kernel_range(unsigned long start, unsigned long 
> end);
> 
>   static inline void flush_tlb_page(struct vm_area_struct *vma, unsigned 
> long a)
>   {
> -    flush_tlb_mm_range(vma->vm_mm, a, a + PAGE_SIZE, PAGE_SHIFT, false);
> +    flush_tlb_mm_range(vma->vm_mm, a, a + PAGE_SIZE, PAGE_SHIFT, false, 
> NULL);
>   }
> 
>   static inline bool arch_tlbbatch_should_defer(struct mm_struct *mm)
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index 28518371d8bf..006f3705b616 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -2572,7 +2572,7 @@ static void *__text_poke(text_poke_f func, void 
> *addr, const void *src, size_t l
>        */
>       flush_tlb_mm_range(text_poke_mm, text_poke_mm_addr, 
> text_poke_mm_addr +
>                  (cross_page_boundary ? 2 : 1) * PAGE_SIZE,
> -               PAGE_SHIFT, false);
> +               PAGE_SHIFT, false, NULL);
> 
>       if (func == text_poke_memcpy) {
>           /*
> diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
> index 0f19ef355f5f..d8494706fec5 100644
> --- a/arch/x86/kernel/ldt.c
> +++ b/arch/x86/kernel/ldt.c
> @@ -374,7 +374,7 @@ static void unmap_ldt_struct(struct mm_struct *mm, 
> struct ldt_struct *ldt)
>       }
> 
>       va = (unsigned long)ldt_slot_va(ldt->slot);
> -    flush_tlb_mm_range(mm, va, va + nr_pages * PAGE_SIZE, PAGE_SHIFT, 
> false);
> +    flush_tlb_mm_range(mm, va, va + nr_pages * PAGE_SIZE, PAGE_SHIFT, 
> false, NULL);
>   }
> 
>   #else /* !CONFIG_MITIGATION_PAGE_TABLE_ISOLATION */
> diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
> index f5b93e01e347..099f8d61be1a 100644
> --- a/arch/x86/mm/tlb.c
> +++ b/arch/x86/mm/tlb.c
> @@ -1447,8 +1447,8 @@ static void put_flush_tlb_info(void)
>   }
> 
>   void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
> -                unsigned long end, unsigned int stride_shift,
> -                bool freed_tables)
> +            unsigned long end, unsigned int stride_shift,
> +            bool freed_tables, struct mmu_gather *tlb)
>   {
>       struct flush_tlb_info *info;
>       int cpu = get_cpu();
> @@ -1471,6 +1471,8 @@ void flush_tlb_mm_range(struct mm_struct *mm, 
> unsigned long start,
>           info->trim_cpumask = should_trim_cpumask(mm);
>           flush_tlb_multi(mm_cpumask(mm), info);
>           consider_global_asid(mm);
> +        if (tlb && freed_tables)
> +            tlb->tlb_flush_sent_ipi = true;


Oops, I missed an important piece here! The sent_ipi flag needs to be
set in native_flush_tlb_multi() when IPIs are actually sent :(

The missing part is as follows:

---8<---
diff --git a/arch/x86/hyperv/mmu.c b/arch/x86/hyperv/mmu.c
index cfcb60468b01..95b62b7afec1 100644
--- a/arch/x86/hyperv/mmu.c
+++ b/arch/x86/hyperv/mmu.c
@@ -17,7 +17,7 @@
  #define HV_TLB_FLUSH_UNIT (4096 * PAGE_SIZE)

  static u64 hyperv_flush_tlb_others_ex(const struct cpumask *cpus,
-				      const struct flush_tlb_info *info);
+				      struct flush_tlb_info *info);

  /*
   * Fills in gva_list starting from offset. Returns the number of items 
added.
@@ -57,7 +57,7 @@ static bool cpu_is_lazy(int cpu)
  }

  static void hyperv_flush_tlb_multi(const struct cpumask *cpus,
-				   const struct flush_tlb_info *info)
+				   struct flush_tlb_info *info)
  {
  	int cpu, vcpu, gva_n, max_gvas;
  	struct hv_tlb_flush *flush;
@@ -170,7 +170,7 @@ static void hyperv_flush_tlb_multi(const struct 
cpumask *cpus,
  }

  static u64 hyperv_flush_tlb_others_ex(const struct cpumask *cpus,
-				      const struct flush_tlb_info *info)
+				      struct flush_tlb_info *info)
  {
  	int nr_bank = 0, max_gvas, gva_n;
  	struct hv_tlb_flush_ex *flush;
diff --git a/arch/x86/include/asm/paravirt.h 
b/arch/x86/include/asm/paravirt.h
index 13f9cd31c8f8..9a46b3cb4799 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -68,7 +68,7 @@ void native_flush_tlb_local(void);
  void native_flush_tlb_global(void);
  void native_flush_tlb_one_user(unsigned long addr);
  void native_flush_tlb_multi(const struct cpumask *cpumask,
-			     const struct flush_tlb_info *info);
+			     struct flush_tlb_info *info);

  static inline void __flush_tlb_local(void)
  {
diff --git a/arch/x86/include/asm/paravirt_types.h 
b/arch/x86/include/asm/paravirt_types.h
index 3502939415ad..6a639da384b7 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -131,7 +131,7 @@ struct pv_mmu_ops {
  	void (*flush_tlb_kernel)(void);
  	void (*flush_tlb_one_user)(unsigned long addr);
  	void (*flush_tlb_multi)(const struct cpumask *cpus,
-				const struct flush_tlb_info *info);
+				struct flush_tlb_info *info);

  	/* Hook for intercepting the destruction of an mm_struct. */
  	void (*exit_mmap)(struct mm_struct *mm);
diff --git a/arch/x86/include/asm/tlbflush.h 
b/arch/x86/include/asm/tlbflush.h
index 9524105659c3..db7ef8e13024 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -227,13 +227,14 @@ struct flush_tlb_info {
  	u8			stride_shift;
  	u8			freed_tables;
  	u8			trim_cpumask;
+	u8			sent_ipi;
  };

  void flush_tlb_local(void);
  void flush_tlb_one_user(unsigned long addr);
  void flush_tlb_one_kernel(unsigned long addr);
  void flush_tlb_multi(const struct cpumask *cpumask,
-		      const struct flush_tlb_info *info);
+		      struct flush_tlb_info *info);

  static inline bool is_dyn_asid(u16 asid)
  {
diff --git a/arch/x86/include/asm/trace/hyperv.h 
b/arch/x86/include/asm/trace/hyperv.h
index a8e5a7a2b460..30f31e6746c9 100644
--- a/arch/x86/include/asm/trace/hyperv.h
+++ b/arch/x86/include/asm/trace/hyperv.h
@@ -10,7 +10,7 @@

  TRACE_EVENT(hyperv_mmu_flush_tlb_multi,
  	    TP_PROTO(const struct cpumask *cpus,
-		     const struct flush_tlb_info *info),
+		     struct flush_tlb_info *info),
  	    TP_ARGS(cpus, info),
  	    TP_STRUCT__entry(
  		    __field(unsigned int, ncpus)
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index df78ddee0abb..57c24ae6e10c 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -649,7 +649,7 @@ static void kvm_smp_send_call_func_ipi(const struct 
cpumask *mask)
  }

  static void kvm_flush_tlb_multi(const struct cpumask *cpumask,
-			const struct flush_tlb_info *info)
+			struct flush_tlb_info *info)
  {
  	u8 state;
  	int cpu;
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 099f8d61be1a..39bfbac82255 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -1345,7 +1345,7 @@ DEFINE_PER_CPU_SHARED_ALIGNED(struct 
tlb_state_shared, cpu_tlbstate_shared);
  EXPORT_PER_CPU_SYMBOL(cpu_tlbstate_shared);

  STATIC_NOPV void native_flush_tlb_multi(const struct cpumask *cpumask,
-					 const struct flush_tlb_info *info)
+					 struct flush_tlb_info *info)
  {
  	/*
  	 * Do accounting and tracing. Note that there are (and have always been)
@@ -1374,10 +1374,13 @@ STATIC_NOPV void native_flush_tlb_multi(const 
struct cpumask *cpumask,
  	else
  		on_each_cpu_cond_mask(should_flush_tlb, flush_tlb_func,
  				(void *)info, 1, cpumask);
+
+	if (info->freed_tables)
+		info->sent_ipi = 1;
  }

  void flush_tlb_multi(const struct cpumask *cpumask,
-		      const struct flush_tlb_info *info)
+		      struct flush_tlb_info *info)
  {
  	__flush_tlb_multi(cpumask, info);
  }
@@ -1433,6 +1436,7 @@ static struct flush_tlb_info 
*get_flush_tlb_info(struct mm_struct *mm,
  	info->new_tlb_gen	= new_tlb_gen;
  	info->initiating_cpu	= smp_processor_id();
  	info->trim_cpumask	= 0;
+	info->sent_ipi		= 0;

  	return info;
  }
@@ -1471,7 +1475,7 @@ void flush_tlb_mm_range(struct mm_struct *mm, 
unsigned long start,
  		info->trim_cpumask = should_trim_cpumask(mm);
  		flush_tlb_multi(mm_cpumask(mm), info);
  		consider_global_asid(mm);
-		if (tlb && freed_tables)
+		if (tlb && info->sent_ipi)
  			tlb->tlb_flush_sent_ipi = true;
  	} else if (mm == this_cpu_read(cpu_tlbstate.loaded_mm)) {
  		lockdep_assert_irqs_enabled();
diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
index 7a35c3393df4..7a24f89ecd47 100644
--- a/arch/x86/xen/mmu_pv.c
+++ b/arch/x86/xen/mmu_pv.c
@@ -1320,7 +1320,7 @@ static void xen_flush_tlb_one_user(unsigned long addr)
  }

  static void xen_flush_tlb_multi(const struct cpumask *cpus,
-				const struct flush_tlb_info *info)
+				struct flush_tlb_info *info)
  {
  	struct {
  		struct mmuext_op op;
---

Thanks,
Lance


>       } else if (mm == this_cpu_read(cpu_tlbstate.loaded_mm)) {
>           lockdep_assert_irqs_enabled();
>           local_irq_disable();
> diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
> index 4d679d2a206b..0ec35699da99 100644
> --- a/include/asm-generic/tlb.h
> +++ b/include/asm-generic/tlb.h
> @@ -249,6 +249,7 @@ static inline void tlb_remove_table(struct 
> mmu_gather *tlb, void *table)
>   #define tlb_needs_table_invalidate() (true)
>   #endif
> 
> +void tlb_gather_remove_table_sync_one(struct mmu_gather *tlb);
>   void tlb_remove_table_sync_one(void);
> 
>   #else
> @@ -257,6 +258,7 @@ void tlb_remove_table_sync_one(void);
>   #error tlb_needs_table_invalidate() requires MMU_GATHER_RCU_TABLE_FREE
>   #endif
> 
> +static inline void tlb_gather_remove_table_sync_one(struct mmu_gather 
> *tlb) { }
>   static inline void tlb_remove_table_sync_one(void) { }
> 
>   #endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
> @@ -379,6 +381,12 @@ struct mmu_gather {
>        */
>       unsigned int        fully_unshared_tables : 1;
> 
> +    /*
> +     * Did the TLB flush for freed/unshared tables send IPIs to all CPUs?
> +     * If true, we can skip the redundant IPI in 
> tlb_remove_table_sync_one().
> +     */
> +    unsigned int        tlb_flush_sent_ipi : 1;
> +
>       unsigned int        batch_count;
> 
>   #ifndef CONFIG_MMU_GATHER_NO_GATHER
> @@ -834,13 +842,9 @@ static inline void tlb_flush_unshared_tables(struct 
> mmu_gather *tlb)
>        *
>        * We only perform this when we are the last sharer of a page table,
>        * as the IPI will reach all CPUs: any GUP-fast.
> -     *
> -     * Note that on configs where tlb_remove_table_sync_one() is a NOP,
> -     * the expectation is that the tlb_flush_mmu_tlbonly() would have 
> issued
> -     * required IPIs already for us.
>        */
>       if (tlb->fully_unshared_tables) {
> -        tlb_remove_table_sync_one();
> +        tlb_gather_remove_table_sync_one(tlb);
>           tlb->fully_unshared_tables = false;
>       }
>   }
> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> index 7468ec388455..288c281b2ca4 100644
> --- a/mm/mmu_gather.c
> +++ b/mm/mmu_gather.c
> @@ -274,8 +274,14 @@ static void tlb_remove_table_smp_sync(void *arg)
>       /* Simply deliver the interrupt */
>   }
> 
> -void tlb_remove_table_sync_one(void)
> +void tlb_gather_remove_table_sync_one(struct mmu_gather *tlb)
>   {
> +    /* Skip the IPI if the TLB flush already synchronized with other 
> CPUs */
> +    if (tlb && tlb->tlb_flush_sent_ipi) {
> +        tlb->tlb_flush_sent_ipi = false;
> +        return;
> +    }
> +
>       /*
>        * This isn't an RCU grace period and hence the page-tables cannot be
>        * assumed to be actually RCU-freed.
> @@ -286,6 +292,11 @@ void tlb_remove_table_sync_one(void)
>       smp_call_function(tlb_remove_table_smp_sync, NULL, 1);
>   }
> 
> +void tlb_remove_table_sync_one(void)
> +{
> +    tlb_gather_remove_table_sync_one(NULL);
> +}
> +
>   static void tlb_remove_table_rcu(struct rcu_head *head)
>   {
>       __tlb_remove_table_free(container_of(head, struct mmu_table_batch, 
> rcu));
> @@ -337,16 +348,16 @@ static inline void __tlb_remove_table_one(void 
> *table)
>       call_rcu(&ptdesc->pt_rcu_head, __tlb_remove_table_one_rcu);
>   }
>   #else
> -static inline void __tlb_remove_table_one(void *table)
> +static inline void __tlb_remove_table_one(void *table, struct 
> mmu_gather *tlb)
>   {
> -    tlb_remove_table_sync_one();
> +    tlb_gather_remove_table_sync_one(tlb);
>       __tlb_remove_table(table);
>   }
>   #endif /* CONFIG_PT_RECLAIM */
> 
> -static void tlb_remove_table_one(void *table)
> +static void tlb_remove_table_one(void *table, struct mmu_gather *tlb)
>   {
> -    __tlb_remove_table_one(table);
> +    __tlb_remove_table_one(table, tlb);
>   }
> 
>   static void tlb_table_flush(struct mmu_gather *tlb)
> @@ -368,7 +379,7 @@ void tlb_remove_table(struct mmu_gather *tlb, void 
> *table)
>           *batch = (struct mmu_table_batch *)__get_free_page(GFP_NOWAIT);
>           if (*batch == NULL) {
>               tlb_table_invalidate(tlb);
> -            tlb_remove_table_one(table);
> +            tlb_remove_table_one(table, tlb);
>               return;
>           }
>           (*batch)->nr = 0;
> @@ -428,6 +439,7 @@ static void __tlb_gather_mmu(struct mmu_gather *tlb, 
> struct mm_struct *mm,
>       tlb->vma_pfn = 0;
> 
>       tlb->fully_unshared_tables = 0;
> +    tlb->tlb_flush_sent_ipi = 0;
>       __tlb_reset_range(tlb);
>       inc_tlb_flush_pending(tlb->mm);
>   }
> ---
> 
> 
> The second one optimizes khugepaged by using mmu_gather to track IPI
> sends. This makes the approach work across all paths ;)
> 
> ---8<---
> pmdp_collapse_flush() may already send IPIs to flush TLBs, and then
> callers send another IPI via tlb_remove_table_sync_one() or
> pmdp_get_lockless_sync() to synchronize with concurrent GUP-fast walkers.
> 
> However, since GUP-fast runs with IRQs disabled, the TLB flush IPI already
> provides the necessary synchronization. We can avoid the redundant second
> IPI.
> 
> Introduce pmdp_collapse_flush_sync() which combines flush and sync:
> 
> - For architectures using the generic pmdp_collapse_flush() implementation
>    (e.g., x86): Use mmu_gather to track IPI sends. If the TLB flush sent
>    an IPI, tlb_gather_remove_table_sync_one() will skip the redundant one.
> 
> - For architectures with custom pmdp_collapse_flush() (s390, riscv,
>    powerpc): Fall back to calling pmdp_collapse_flush() followed by
>    tlb_remove_table_sync_one(). No behavior change.
> 
> Update khugepaged to use pmdp_collapse_flush_sync() instead of separate
> flush and sync calls. Remove the now-unused pmdp_get_lockless_sync() macro.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Suggested-by: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>   include/linux/pgtable.h | 13 +++++++++----
>   mm/khugepaged.c         |  9 +++------
>   mm/pgtable-generic.c    | 34 ++++++++++++++++++++++++++++++++++
>   3 files changed, 46 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index eb8aacba3698..b42758197d47 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -755,7 +755,6 @@ static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
>       return pmd;
>   }
>   #define pmdp_get_lockless pmdp_get_lockless
> -#define pmdp_get_lockless_sync() tlb_remove_table_sync_one()
>   #endif /* CONFIG_PGTABLE_LEVELS > 2 */
>   #endif /* CONFIG_GUP_GET_PXX_LOW_HIGH */
> 
> @@ -774,9 +773,6 @@ static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
>   {
>       return pmdp_get(pmdp);
>   }
> -static inline void pmdp_get_lockless_sync(void)
> -{
> -}
>   #endif
> 
>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> @@ -1174,6 +1170,8 @@ static inline void pudp_set_wrprotect(struct 
> mm_struct *mm,
>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>   extern pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
>                    unsigned long address, pmd_t *pmdp);
> +extern pmd_t pmdp_collapse_flush_sync(struct vm_area_struct *vma,
> +                      unsigned long address, pmd_t *pmdp);
>   #else
>   static inline pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
>                       unsigned long address,
> @@ -1182,6 +1180,13 @@ static inline pmd_t pmdp_collapse_flush(struct 
> vm_area_struct *vma,
>       BUILD_BUG();
>       return *pmdp;
>   }
> +static inline pmd_t pmdp_collapse_flush_sync(struct vm_area_struct *vma,
> +                         unsigned long address,
> +                         pmd_t *pmdp)
> +{
> +    BUILD_BUG();
> +    return *pmdp;
> +}
>   #define pmdp_collapse_flush pmdp_collapse_flush
>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>   #endif
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 9f790ec34400..0a98afc85c50 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1177,10 +1177,9 @@ static enum scan_result collapse_huge_page(struct 
> mm_struct *mm, unsigned long a
>        * Parallel GUP-fast is fine since GUP-fast will back off when
>        * it detects PMD is changed.
>        */
> -    _pmd = pmdp_collapse_flush(vma, address, pmd);
> +    _pmd = pmdp_collapse_flush_sync(vma, address, pmd);
>       spin_unlock(pmd_ptl);
>       mmu_notifier_invalidate_range_end(&range);
> -    tlb_remove_table_sync_one();
> 
>       pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
>       if (pte) {
> @@ -1663,8 +1662,7 @@ static enum scan_result 
> try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
>               }
>           }
>       }
> -    pgt_pmd = pmdp_collapse_flush(vma, haddr, pmd);
> -    pmdp_get_lockless_sync();
> +    pgt_pmd = pmdp_collapse_flush_sync(vma, haddr, pmd);
>       pte_unmap_unlock(start_pte, ptl);
>       if (ptl != pml)
>           spin_unlock(pml);
> @@ -1817,8 +1815,7 @@ static void retract_page_tables(struct 
> address_space *mapping, pgoff_t pgoff)
>            * races against the prior checks.
>            */
>           if (likely(file_backed_vma_is_retractable(vma))) {
> -            pgt_pmd = pmdp_collapse_flush(vma, addr, pmd);
> -            pmdp_get_lockless_sync();
> +            pgt_pmd = pmdp_collapse_flush_sync(vma, addr, pmd);
>               success = true;
>           }
> 
> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> index d3aec7a9926a..be2ee82e6fc4 100644
> --- a/mm/pgtable-generic.c
> +++ b/mm/pgtable-generic.c
> @@ -233,6 +233,40 @@ pmd_t pmdp_collapse_flush(struct vm_area_struct 
> *vma, unsigned long address,
>       flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
>       return pmd;
>   }
> +
> +pmd_t pmdp_collapse_flush_sync(struct vm_area_struct *vma, unsigned 
> long address,
> +                   pmd_t *pmdp)
> +{
> +    struct mmu_gather tlb;
> +    pmd_t pmd;
> +
> +    VM_BUG_ON(address & ~HPAGE_PMD_MASK);
> +    VM_BUG_ON(pmd_trans_huge(*pmdp));
> +
> +    tlb_gather_mmu(&tlb, vma->vm_mm);
> +    pmd = pmdp_huge_get_and_clear(vma->vm_mm, address, pmdp);
> +
> +    flush_tlb_mm_range(vma->vm_mm, address, address + HPAGE_PMD_SIZE,
> +               PAGE_SHIFT, true, &tlb);
> +
> +    /*
> +     * Synchronize with GUP-fast. If the flush sent IPIs, skip the
> +     * redundant sync IPI.
> +     */
> +    tlb_gather_remove_table_sync_one(&tlb);
> +    tlb_finish_mmu(&tlb);
> +    return pmd;
> +}
> +#else
> +pmd_t pmdp_collapse_flush_sync(struct vm_area_struct *vma, unsigned 
> long address,
> +                   pmd_t *pmdp)
> +{
> +    pmd_t pmd;
> +
> +    pmd = pmdp_collapse_flush(vma, address, pmdp);
> +    tlb_remove_table_sync_one();
> +    return pmd;
> +}
>   #endif
> 
>   /* arch define pte_free_defer in asm/pgalloc.h for its own 
> implementation */
> ---
> 
>>
>> Is there some kind of hurry to get this done immediately?
> 
> No rush at all - just wanted to explore what works best and keep
> things simpler as well ;)
> 
> What do you think?



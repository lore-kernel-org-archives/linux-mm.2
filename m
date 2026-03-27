Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3700210BA447
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 08:34:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DDDF6B00CE; Fri, 27 Mar 2026 04:34:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B4E76B00D1; Fri, 27 Mar 2026 04:34:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CC3F6B00D2; Fri, 27 Mar 2026 04:34:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 784F36B00CE
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 04:34:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 25E7F1A0CBA
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:34:13 +0000 (UTC)
X-FDA: 84591180786.11.D0AF5EC
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9ADA480007
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:34:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IMUCoa3K;
	spf=pass (imf02.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774600451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VXu/xT4gQehyAnYhgh8ayFce4aBDZfXhACmtlpO07r4=;
	b=KZ/LWG507H98cp4yxC9G/PCTYZI63ILHy1ltvX+v/T2vxiRn5P2xjzYCx5R79cMVhbovEN
	z0eLz6zSCJXnqEo45Rv+j0twvV0G3xaQDKyOmdhLnqncSiBwa/hr1Tn2p/9m/AF1jCMVqU
	HGJPg8RT44VQceCzEovKGcH8N2NmYK0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774600451; a=rsa-sha256;
	cv=none;
	b=iNlDgMd3mvgbfoEQUzREvT+dpU2m1Br96MhSLV+3OA/ubiFNNbcRTvYMMd6nrXcrHVicRB
	kYC7t3HzFrXu/BtKrWWu3pIVlLmRXpkyxo0ASd1qZRpz/mA83tNkXblZv/ykXtj4BJkrHr
	dgLFYQsUq9aRIZKwiiRuUZxYfWO74GY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IMUCoa3K;
	spf=pass (imf02.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <0f9f84b3-7815-4fbb-bf6f-f82403e8b05f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774600445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VXu/xT4gQehyAnYhgh8ayFce4aBDZfXhACmtlpO07r4=;
	b=IMUCoa3Klzu3sifHZm5U7wDHarQGk3askvFX/v/ioU8wUT+yxNUVV28vKnEt1DPJTJABjv
	gcPuzgQNrQyAQ7il7haPSmjlUQQ/g5YzlmwfZBqZ2J3PNG2b9XUy1ctB5CRItfD5b2SoiR
	mP85kUvU9AOI8IwUWEsqEHMKgDMRIK8=
Date: Fri, 27 Mar 2026 16:33:14 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm/alloc_tag: clear codetag for pages allocated before
 page_ext initialization
To: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260326140554.191996-1-hao.ge@linux.dev>
 <CAJuCfpG3w0-m_BAhvRj0Mo2cCeWmD3UaEMa=gd=tvT7hrL=mqA@mail.gmail.com>
 <CAJuCfpF+6zKxWdKxd3jFYPzYmVWh54gCibLy9hBX0YyLYeSRaA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpF+6zKxWdKxd3jFYPzYmVWh54gCibLy9hBX0YyLYeSRaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9ADA480007
X-Stat-Signature: k545pkeaquun4gxqockp6tjrsu87pq18
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774600450-468338
X-HE-Meta: U2FsdGVkX18DNTv1lNuwbUmd4s9MjMfSs5Tgv8RuF32XiH54PwI8iKcotUu/jcusAebICbiARUzV8gj3OswhBQcn0Fl+YL9wvd0Hl8GgVcpQZS3B9hCqgfBn1smjp3cYNYti3Vy9wXzapaRqTThRaFsIdv37oAEay/RSCsAfgKQXdNapxxRXcXiSaTDmZACFqv+s3t5+Th55t70jzrTEosec25WXQlVygWnoPwe6ltHdGANfl5ygv/KTG8vGoJlfUtz8GKnVG5qs1/uq9+sEOU04URrUfZ3V9b8o2qQvDVO08S8SRjYLoyXUWKz1QrudFkamkTy069jDnZEYHFh6Jj9zLlDl3GqmLyv4qxJFJP0Q/uNAb1CfmhiGFTRJq1qo27WboUSA9EDXBZ4EgQkHKSbq0DnBS95BIVYNRQOVi8IujmG9aFqRgtLCoMCFlP/mwf6kKAT3BVtqpuGWrmW8mOg3sWbqNeM0Phjv40CrRiDWd6vfI8/G6w6mQ4Xv16EeIlpcvGIFh873pTsuOsl/foAOXVFK2on4+bO0udTQc8gQAEhhzYLKoH1Pku0XLPiQARBKzZjOMOK8p1e2HOHe3I8VB8TMNfsDtLcYxS/x64IqmHpoa+wm3hUaAVgpbrbpMcdlajP47WOiQNEzRQjR+F89yO4VNpxvHbqOKrmZtw9BwCL5rZLnqO6WLlM9cc3QJoB/88k2y/HXK86DPN/hZKwTcu25XaCVJ17C52TZaPkP5ORqRrNUB1EC4cW1V4ee1h/uS1p3XE1C4Z4q7w/v0XTR8yaa6ob/zavY/+v8j6BzLfdVPCmHH8arH+mVvoqNXclF0lED06PvIUuAisyHVFHEoEr6MAzs+H14AN/2tKE5/6ytOQpUIm/JYthf7hc2wqSUPmSe3EDNI/KHCjCQVs0CnMeovODWeDp8ksqLkS5STTNSoQp3I/Xo74Y7PGNSIvZyZNSQEJKNhIEHT0u
 QKLQDMgY
 ZssX3br+fwabyImzk9v5EpMqwqHy97OzocYWB8njV+QN7NlCgwDSNhCSOv9nPtjrVk6GjnEM2gwE8BWD5anmZ6IGtdBibMcJSHbvjWD/B69tHvdhefuGyG/3CKKIqrwZ9f2K3M1kAPt+xQvfKPdBkY4FNw/QrHb0gQLO4BbRunxDR52+JGoKpryQzIQhCKYMwoGFmGX+QZqocZEKQHhuXFipCqhPzc8RbAJlXk8lQfhsV2Sg/Qhkg1vbR5OW5dMATyI7z+QaUnstZYLBLAtZSkCGxU3o74l92k2V9CjtntOO1U/2jRgB3TXq1QPfTPotkRcqojRsB0x3+WAoSbDJxGcPpHUT4fKjQX4YNBVMpby41d+k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2026/3/27 12:39, Suren Baghdasaryan wrote:
> On Thu, Mar 26, 2026 at 9:32 PM Suren Baghdasaryan <surenb@google.com> wrote:
>> On Thu, Mar 26, 2026 at 7:07 AM Hao Ge <hao.ge@linux.dev> wrote:
>>> Due to initialization ordering, page_ext is allocated and initialized
>>> relatively late during boot. Some pages have already been allocated
>>> and freed before page_ext becomes available, leaving their codetag
>>> uninitialized.
>>>
>>> A clear example is in init_section_page_ext(): alloc_page_ext() calls
>>> kmemleak_alloc(). If the slab cache has no free objects, it falls back
>>> to the buddy allocator to allocate memory. However, at this point page_ext
>>> is not yet fully initialized, so these newly allocated pages have no
>>> codetag set. These pages may later be reclaimed by KASAN, which causes
>>> the warning to trigger when they are freed because their codetag ref is
>>> still empty.
>>>
>>> Use a global array to track pages allocated before page_ext is fully
>>> initialized. The array size is fixed at 8192 entries, and will emit
>>> a warning if this limit is exceeded. When page_ext initialization
>>> completes, set their codetag to empty to avoid warnings when they
>>> are freed later.
>>>
>>> The following warning is observed when this issue occurs:
>>> [    9.582133] ------------[ cut here ]------------
>>> [    9.582137] alloc_tag was not set
>>> [    9.582139] WARNING: ./include/linux/alloc_tag.h:164 at __pgalloc_tag_sub+0x40f/0x550, CPU#5: systemd/1
>>> [    9.582190] CPU: 5 UID: 0 PID: 1 Comm: systemd Not tainted 7.0.0-rc4 #1 PREEMPT(lazy)
>>> [    9.582192] Hardware name: Red Hat KVM, BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
>>> [    9.582194] RIP: 0010:__pgalloc_tag_sub+0x40f/0x550
>>> [    9.582196] Code: 00 00 4c 29 e5 48 8b 05 1f 88 56 05 48 8d 4c ad 00 48 8d 2c c8 e9 87 fd ff ff 0f 0b 0f 0b e9 f3 fe ff ff 48 8d 3d 61 2f ed 03 <67> 48 0f b9 3a e9 b3 fd ff ff 0f 0b eb e4 e8 5e cd 14 02 4c 89 c7
>>> [    9.582197] RSP: 0018:ffffc9000001f940 EFLAGS: 00010246
>>> [    9.582200] RAX: dffffc0000000000 RBX: 1ffff92000003f2b RCX: 1ffff110200d806c
>>> [    9.582201] RDX: ffff8881006c0360 RSI: 0000000000000004 RDI: ffffffff9bc7b460
>>> [    9.582202] RBP: 0000000000000000 R08: 0000000000000000 R09: fffffbfff3a62324
>>> [    9.582203] R10: ffffffff9d311923 R11: 0000000000000000 R12: ffffea0004001b00
>>> [    9.582204] R13: 0000000000002000 R14: ffffea0000000000 R15: ffff8881006c0360
>>> [    9.582206] FS:  00007ffbbcf2d940(0000) GS:ffff888450479000(0000) knlGS:0000000000000000
>>> [    9.582208] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [    9.582210] CR2: 000055ee3aa260d0 CR3: 0000000148b67005 CR4: 0000000000770ef0
>>> [    9.582211] PKRU: 55555554
>>> [    9.582212] Call Trace:
>>> [    9.582213]  <TASK>
>>> [    9.582214]  ? __pfx___pgalloc_tag_sub+0x10/0x10
>>> [    9.582216]  ? check_bytes_and_report+0x68/0x140
>>> [    9.582219]  __free_frozen_pages+0x2e4/0x1150
>>> [    9.582221]  ? __free_slab+0xc2/0x2b0
>>> [    9.582224]  qlist_free_all+0x4c/0xf0
>>> [    9.582227]  kasan_quarantine_reduce+0x15d/0x180
>>> [    9.582229]  __kasan_slab_alloc+0x69/0x90
>>> [    9.582232]  kmem_cache_alloc_noprof+0x14a/0x500
>>> [    9.582234]  do_getname+0x96/0x310
>>> [    9.582237]  do_readlinkat+0x91/0x2f0
>>> [    9.582239]  ? __pfx_do_readlinkat+0x10/0x10
>>> [    9.582240]  ? get_random_bytes_user+0x1df/0x2c0
>>> [    9.582244]  __x64_sys_readlinkat+0x96/0x100
>>> [    9.582246]  do_syscall_64+0xce/0x650
>>> [    9.582250]  ? __x64_sys_getrandom+0x13a/0x1e0
>>> [    9.582252]  ? __pfx___x64_sys_getrandom+0x10/0x10
>>> [    9.582254]  ? do_syscall_64+0x114/0x650
>>> [    9.582255]  ? ksys_read+0xfc/0x1d0
>>> [    9.582258]  ? __pfx_ksys_read+0x10/0x10
>>> [    9.582260]  ? do_syscall_64+0x114/0x650
>>> [    9.582262]  ? do_syscall_64+0x114/0x650
>>> [    9.582264]  ? __pfx_fput_close_sync+0x10/0x10
>>> [    9.582266]  ? file_close_fd_locked+0x178/0x2a0
>>> [    9.582268]  ? __x64_sys_faccessat2+0x96/0x100
>>> [    9.582269]  ? __x64_sys_close+0x7d/0xd0
>>> [    9.582271]  ? do_syscall_64+0x114/0x650
>>> [    9.582273]  ? do_syscall_64+0x114/0x650
>>> [    9.582275]  ? clear_bhb_loop+0x50/0xa0
>>> [    9.582277]  ? clear_bhb_loop+0x50/0xa0
>>> [    9.582279]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>>> [    9.582280] RIP: 0033:0x7ffbbda345ee
>>> [    9.582282] Code: 0f 1f 40 00 48 8b 15 29 38 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff c3 0f 1f 40 00 f3 0f 1e fa 49 89 ca b8 0b 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d fa 37 0d 00 f7 d8 64 89 01 48
>>> [    9.582284] RSP: 002b:00007ffe2ad8de58 EFLAGS: 00000202 ORIG_RAX: 000000000000010b
>>> [    9.582286] RAX: ffffffffffffffda RBX: 000055ee3aa25570 RCX: 00007ffbbda345ee
>>> [    9.582287] RDX: 000055ee3aa25570 RSI: 00007ffe2ad8dee0 RDI: 00000000ffffff9c
>>> [    9.582288] RBP: 0000000000001000 R08: 0000000000000003 R09: 0000000000001001
>>> [    9.582289] R10: 0000000000001000 R11: 0000000000000202 R12: 0000000000000033
>>> [    9.582290] R13: 00007ffe2ad8dee0 R14: 00000000ffffff9c R15: 00007ffe2ad8deb0
>>> [    9.582292]  </TASK>
>>> [    9.582293] ---[ end trace 0000000000000000 ]---
>>>
>>> Fixes: 93d5440ece3c ("alloc_tag: uninline code gated by mem_alloc_profiling_key in page allocator")
>>> Suggested-by: Suren Baghdasaryan <surenb@google.com>
>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>>> ---
>>> v2:
>>>    - Replace spin_lock_irqsave() with atomic_try_cmpxchg() to avoid potential
>>>       deadlock in NMI context
>>>    - Change EARLY_ALLOC_PFN_MAX from 256 to 8192
>>>    - Add pr_warn_once() when the limit is exceeded
>>>    - Check ref.ct before clearing to avoid overwriting valid tags
>>>    - Use function pointer (alloc_tag_add_early_pfn_ptr) instead of state
>>> ---
>>>   include/linux/alloc_tag.h   |  2 +
>>>   include/linux/pgalloc_tag.h |  2 +-
>>>   lib/alloc_tag.c             | 92 +++++++++++++++++++++++++++++++++++++
>>>   mm/page_alloc.c             |  7 +++
>>>   4 files changed, 102 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
>>> index d40ac39bfbe8..bf226c2be2ad 100644
>>> --- a/include/linux/alloc_tag.h
>>> +++ b/include/linux/alloc_tag.h
>>> @@ -74,6 +74,8 @@ static inline void set_codetag_empty(union codetag_ref *ref)
>>>
>>>   #ifdef CONFIG_MEM_ALLOC_PROFILING
>>>
>>> +void alloc_tag_add_early_pfn(unsigned long pfn);
>> Although this works, the usual approach is have it defined this way in
>> the header file:
>>
>> #if CONFIG_MEM_ALLOC_PROFILING_DEBUG
>> void alloc_tag_add_early_pfn(unsigned long pfn);
>> #else
>> static inline void alloc_tag_add_early_pfn(unsigned long pfn) {}
>> #endif
>>
>>> +
>>>   #define ALLOC_TAG_SECTION_NAME "alloc_tags"
>>>
>>>   struct codetag_bytes {
>>> diff --git a/include/linux/pgalloc_tag.h b/include/linux/pgalloc_tag.h
>>> index 38a82d65e58e..951d33362268 100644
>>> --- a/include/linux/pgalloc_tag.h
>>> +++ b/include/linux/pgalloc_tag.h
>>> @@ -181,7 +181,7 @@ static inline struct alloc_tag *__pgalloc_tag_get(struct page *page)
>>>
>>>          if (get_page_tag_ref(page, &ref, &handle)) {
>>>                  alloc_tag_sub_check(&ref);
>>> -               if (ref.ct)
>>> +               if (ref.ct && !is_codetag_empty(&ref))
>>>                          tag = ct_to_alloc_tag(ref.ct);
>>>                  put_page_tag_ref(handle);
>>>          }
>>> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
>>> index 58991ab09d84..7b1812768af9 100644
>>> --- a/lib/alloc_tag.c
>>> +++ b/lib/alloc_tag.c
>>> @@ -6,6 +6,7 @@
>>>   #include <linux/kallsyms.h>
>>>   #include <linux/module.h>
>>>   #include <linux/page_ext.h>
>>> +#include <linux/pgalloc_tag.h>
>>>   #include <linux/proc_fs.h>
>>>   #include <linux/seq_buf.h>
>>>   #include <linux/seq_file.h>
>>> @@ -26,6 +27,96 @@ static bool mem_profiling_support;
>>>
>>>   static struct codetag_type *alloc_tag_cttype;
>>>
>>> +#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
>>> +
>>> +/*
>>> + * Track page allocations before page_ext is initialized.
>>> + * Some pages are allocated before page_ext becomes available, leaving
>>> + * their codetag uninitialized. Track these early PFNs so we can clear
>>> + * their codetag refs later to avoid warnings when they are freed.
>>> + *
>>> + * Early allocations include:
>>> + *   - Base allocations independent of CPU count
>>> + *   - Per-CPU allocations (e.g., CPU hotplug callbacks during smp_init,
>>> + *     such as trace ring buffers, scheduler per-cpu data)
>>> + *
>>> + * For simplicity, we fix the size to 8192.
>>> + * If insufficient, a warning will be triggered to alert the user.
>>> + */
>>> +#define EARLY_ALLOC_PFN_MAX            8192

Hi Suren


> Forgot to mention that we will need to do something about this limit
> using dynamic allocation. I was thinking we could allocate pages
> dynamically (with a GFP flag similar to ___GFP_NO_OBJ_EXT to avoid
> recursion), linking them via page->lru and then freeing them at the
> end of clear_early_alloc_pfn_tag_refs(). That adds more complexity but
> solves this limit problem. However all this can be done as a followup
> patch.


Yes, to be honest, I did try calling alloc_page() myself — it was 
immediately obvious

this would lead to infinite recursion since alloc_page() would hit the 
same code path.

I've already noted these in our code comments as TODO items.

I'll also try to work on an implementation as a follow-up.


Thanks

Hao

>>> +
>>> +static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX] __initdata;
>>> +static atomic_t early_pfn_count __initdata = ATOMIC_INIT(0);
>>> +
>>> +static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
>>> +{
>>> +       int old_idx, new_idx;
>>> +
>>> +       do {
>>> +               old_idx = atomic_read(&early_pfn_count);
>>> +               if (old_idx >= EARLY_ALLOC_PFN_MAX) {
>>> +                       pr_warn_once("Early page allocations before page_ext init exceeded EARLY_ALLOC_PFN_MAX (%d)\n",
>>> +                                     EARLY_ALLOC_PFN_MAX);
>>> +                       return;
>>> +               }
>>> +               new_idx = old_idx + 1;
>>> +       } while (!atomic_try_cmpxchg(&early_pfn_count, &old_idx, new_idx));
>>> +
>>> +       early_pfns[old_idx] = pfn;
>>> +}
>>> +
>>> +static void (*alloc_tag_add_early_pfn_ptr)(unsigned long pfn) __refdata =
>>> +               __alloc_tag_add_early_pfn;
>> So, there is a possible race between clear_early_alloc_pfn_tag_refs()
>> and __alloc_tag_add_early_pfn(). I think the easiest way to resolve
>> this is using RCU. It's easier to show that with the code:
>>
>> typedef void (*alloc_tag_add_func)(unsigned long pfn);
>>
>> static alloc_tag_add_func __rcu alloc_tag_add_early_pfn_ptr __refdata =
>>                  __alloc_tag_add_early_pfn;
>>
>> void alloc_tag_add_early_pfn(unsigned long pfn)
>> {
>>          alloc_tag_add_func alloc_tag_add;
>>
>>          if (static_key_enabled(&mem_profiling_compressed))
>>                  return;
>>
>>          rcu_read_lock();
>>          alloc_tag_add = rcu_dereference(alloc_tag_add_early_pfn_ptr);
>>          if (alloc_tag_add)
>>                  alloc_tag_add(pfn);
>>          rcu_read_unlock();
>> }
>>
>> static void __init clear_early_alloc_pfn_tag_refs(void)
>> {
>>          unsigned int i;
>>
>>          if (static_key_enabled(&mem_profiling_compressed))
>>                  return;
>>
>>         rcu_assign_pointer(alloc_tag_add_early_pfn_ptr, NULL);
>>          /* Make sure we are not racing with __alloc_tag_add_early_pfn() */
>>          synchronize_rcu();
>>          ...
>> }
>>
>> So, clear_early_alloc_pfn_tag_refs() resets
>> alloc_tag_add_early_pfn_ptr to NULL before starting its loop and
>> alloc_tag_add_early_pfn() calls __alloc_tag_add_early_pfn() in RCU
>> read section. This way you know that after synchronize_rcu() nobody is
>> or will be executing __alloc_tag_add_early_pfn() anymore.
>> synchronize_rcu() can increase boot time but this happens only with
>> CONFIG_MEM_ALLOC_PROFILING_DEBUG, so should be acceptable.
>>
>>> +
>>> +void alloc_tag_add_early_pfn(unsigned long pfn)
>>> +{
>>> +       if (static_key_enabled(&mem_profiling_compressed))
>>> +               return;
>>> +
>>> +       if (alloc_tag_add_early_pfn_ptr)
>>> +               alloc_tag_add_early_pfn_ptr(pfn);
>>> +}
>>> +
>>> +static void __init clear_early_alloc_pfn_tag_refs(void)
>>> +{
>>> +       unsigned int i;
>>> +
>> I included this in the code I suggested above but just as a reminder,
>> here we also need:
>>
>>        if (static_key_enabled(&mem_profiling_compressed))
>>                 return;
>>
>>> +       for (i = 0; i < atomic_read(&early_pfn_count); i++) {
>>> +               unsigned long pfn = early_pfns[i];
>>> +
>>> +               if (pfn_valid(pfn)) {
>>> +                       struct page *page = pfn_to_page(pfn);
>>> +                       union pgtag_ref_handle handle;
>>> +                       union codetag_ref ref;
>>> +
>>> +                       if (get_page_tag_ref(page, &ref, &handle)) {
>>> +                               /*
>>> +                                * An early-allocated page could be freed and reallocated
>>> +                                * after its page_ext is initialized but before we clear it.
>>> +                                * In that case, it already has a valid tag set.
>>> +                                * We should not overwrite that valid tag with CODETAG_EMPTY.
>>> +                                */
>> You don't really solve this race here. See explanation below.
>>
>>> +                               if (ref.ct) {
>>> +                                       put_page_tag_ref(handle);
>>> +                                       continue;
>>> +                               }
>>> +
>> Between the above "if (ref.ct)" check and below set_codetag_empty() an
>> allocation can change the ref.ct value to a valid reference (because
>> page_ext already exists) and you will override it with CODETAG_EMPTY.
>> I think we have two options:
>> 1. Just let that override happen and lose accounting for that racing
>> allocation. I think that's preferred option since the race is not
>> likely and extra complexity is not worth it IMO.
>> 2.  Do clear_page_tag_ref() here but atomically. Something like
>> clear_page_tag_ref_if_null() calling update_page_tag_ref_if_null()
>> which calls cmpxchg(&ref->ct, NULL, CODETAG_EMPTY).
>>
>> If you agree with option #1 then please update the comment above
>> highlighting this smaller race and that we are ok with it.
>>
>>> +                               set_codetag_empty(&ref);
>>> +                               update_page_tag_ref(handle, &ref);
>>> +                               put_page_tag_ref(handle);
>>> +                       }
>>> +               }
>>> +
>>> +       }
>>> +
>>> +       atomic_set(&early_pfn_count, 0);
>>> +       alloc_tag_add_early_pfn_ptr = NULL;
>> Once we did that RCU synchronization we don't need the above resets.
>> early_pfn_count won't be used anymore and alloc_tag_add_early_pfn_ptr
>> is already NULL.
>>
>>> +}
>>> +#else /* !CONFIG_MEM_ALLOC_PROFILING_DEBUG */
>>> +inline void alloc_tag_add_early_pfn(unsigned long pfn) {}
>>> +static inline void __init clear_early_alloc_pfn_tag_refs(void) {}
>>> +#endif
>>> +
>>>   #ifdef CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU
>>>   DEFINE_PER_CPU(struct alloc_tag_counters, _shared_alloc_tag);
>>>   EXPORT_SYMBOL(_shared_alloc_tag);
>>> @@ -760,6 +851,7 @@ static __init bool need_page_alloc_tagging(void)
>>>
>>>   static __init void init_page_alloc_tagging(void)
>>>   {
>>> +       clear_early_alloc_pfn_tag_refs();
>>>   }
>>>
>>>   struct page_ext_operations page_alloc_tagging_ops = {
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index 2d4b6f1a554e..8f9bda04403b 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -1293,6 +1293,13 @@ void __pgalloc_tag_add(struct page *page, struct task_struct *task,
>> In here let's mark the normal branch as "likely":
>> -        if (get_page_tag_ref(page, &ref, &handle)) {
>> +        if (likely(get_page_tag_ref(page, &ref, &handle))) {
>>
>>>                  alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr);
>>>                  update_page_tag_ref(handle, &ref);
>>>                  put_page_tag_ref(handle);
>>> +       } else {
>>> +               /*
>>> +                * page_ext is not available yet, record the pfn so we can
>>> +                * clear the tag ref later when page_ext is initialized.
>>> +                */
>>> +               alloc_tag_add_early_pfn(page_to_pfn(page));
>>> +               alloc_tag_set_inaccurate(current->alloc_tag);
>> Here we should be using task->alloc_tag instead of current->alloc_tag
>> but we also need to check that task->alloc_tag != NULL.
>>
>>>          }
>>>   }
>>>
>>> --
>>> 2.25.1
>>>


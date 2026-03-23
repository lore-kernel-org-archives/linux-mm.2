Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEFDAEC01A9
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 09:16:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3871D6B0092; Mon, 23 Mar 2026 05:16:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 338176B0093; Mon, 23 Mar 2026 05:16:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24E916B0095; Mon, 23 Mar 2026 05:16:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1330C6B0092
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:16:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B5BA58CB47
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:16:43 +0000 (UTC)
X-FDA: 84576772686.11.00D9BE6
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9E1291A000A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:16:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UYDOwHRz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774257402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=REM58bo0VD/AcwqlNlr8RJcJ4IWBzemIVbI7XkgsT08=;
	b=V+rwsXa1/1uXF4ocd3BmPDaoRqGhwKa97YNLUC/CvRRs3MWJf8uMYWc7Pt5dPrBzrsvhhe
	jBHYLOj2+y/vl/XmaqIKgPNwOg1w0WGc28VI6CbVWmDTnUyjmZJ0sD11B/+EIIfUGpXC7i
	5aES07DJXqdxg0IVQNHQdcXfjJg09ho=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774257402; a=rsa-sha256;
	cv=none;
	b=7c85RMtZ1S260Js3rKkzh+LbkemUzWG1fd6fmRC5reTybySoJaXYYWV3H8S1+VajhTTaR7
	IrUoNyDVTUftliUqsAbuNSPuqIU3ST5FKVL62Elx1r9uWJ/9JfrasMMWmnmdmlsRkzzUu6
	iI5KpLPL5v8VoFFtaM7b1l77Foa5GzY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UYDOwHRz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
Message-ID: <575e727e-cd47-41df-966a-142425aa8a8b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774257398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=REM58bo0VD/AcwqlNlr8RJcJ4IWBzemIVbI7XkgsT08=;
	b=UYDOwHRzKCnHPRsIw/JfPPKVSyHx3gCX77EfPQd5Ipkvv4gp1qAnNR/XU3Xh4eWrF886cQ
	n5f0TZWREM5X1wRtLgV6YwWyELe88BPSEVTi/Aga8zSxYIh9cdFsOBFvxOufTqzYJjAO8l
	pTJHl2E1cYlsruGqETrFa6+XJYzJeuk=
Date: Mon, 23 Mar 2026 17:15:45 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/alloc_tag: clear codetag for pages allocated before
 page_ext initialization
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Kent Overstreet <kent.overstreet@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260319083153.2488005-1-hao.ge@linux.dev>
 <20260319152808.fce61386fdf2934d7a3b0edb@linux-foundation.org>
 <CAJuCfpG5OG66mgfn3ez5ZXTjj7VC8yuK3L2u83uOZhyBbRH2Lw@mail.gmail.com>
 <CAJuCfpHD4SB30oP7Bdm=ey+2W7CAsFPruedEbqgR5OumrQErxQ@mail.gmail.com>
 <9ef1c798-a30f-4458-9684-900136ae8b7d@linux.dev>
 <CAJuCfpEt1EwS4_kiTbger7sBGFKKhi+6PBjrYrTK1HEJzxOTGg@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpEt1EwS4_kiTbger7sBGFKKhi+6PBjrYrTK1HEJzxOTGg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9E1291A000A
X-Stat-Signature: zcb1ep1unkymy1yzxs3z8qtormic1hga
X-Rspam-User: 
X-HE-Tag: 1774257401-461221
X-HE-Meta: U2FsdGVkX1/A0n1U7IwZndWInO6IKzjVFBOBCpdSt7l5D4vTDFHnBWk7dAqhjTyXQ7RYOp1J8TTi9CfpBsIJaNll7Gjy1YfcNvhwQNE5x70hMA0z/LMpeRUV6NrHURXX6l5UKhWOZUVbEaz0OGuHhNelV03L54j5aqOS1Rwyw6sAM9DM3efMi3RDwuFstD81/RHaeRs4XwLCUrJgOqBs9aF/KzFQT5N0QT1nkGtki80E5JbTrluVddxcoHW+m4lAJEZXixBOyFp8qVCoe5ah0+ChKWgj1lmH2sJpvzIv5DP943DE7qp4q+TttiI8JdGAitGyCwnEtTRj/K9LH4NKiTErevF2Ue8iPYODeok3/Rr1EHuBC5fnLy0LvFtdu/nwpwncMQf2NRyj6WR63ASdZOROAcIP+aYWmIGFNXWHoH0y2e4DxIlfOEOqgV2g9oT3eFUxFCXfgweg6Ymz9gZGLiUsBQa+5HeopdTg5naABp9EZ72mPm9FxGc+ZwD5d3Li/aOOXmUUf1zXc2G42r7Ghmx744pTlGVzn7fQjzULo4ofKj7IeMJdoTpPrCG5tHH7KxTUbk1UffnWKSJIXUKB7v6wzdiBjRz0jnHxOBf1IQo817O41k8G/LoFSz82bGUpAnl41AvubbeMouSX14G44qLsJz+MKx8mvjFgwgW/uT9fHujyIfsRGvHfQxavhEGRd5sEX74WDIQZjznY/3Mf9N5UMkcr0lhtJjcCPsKWuUPCbCfmn1HTzk/7TW/a9GpOgxL1W5MNtzADYa+39Zh+HHGcDoyGp0ilwFlPEO4L8Wf7d0tK+6qcVdiFIrSA2l5fgHnWlY6IIYYP2jeocIMoDfW0zmmb74H2QDE/Sj17AeKatIfdPJlc58trx1vDLZ3cTh28ilO5WZcdy3MPh6HMWsa0z0N38hBVmvH2GANpXHCSKD8CcjGYbyGqfFr4BAz4/1Tq66mr21VV1jnNZb4
 bZnfc8b8
 rNOl5Bhdts9spVN2M99n90GYirHL+8Qgpkk40wuVpRFm0CBljwwVEAgRhhE7Y8wTOVEdpx6zD4VsDZbrNwkFJ2vh1NxrcKE8SDyi7CCReVYcuZb+l6xzWX1KPpt5ZDhSMVKIrGrQzxmOWs0n5b/k9XP9ezp+PfvL1FPbhtSA2HCaEGOOtjqDYqPFAwGDmypZ1G/3LFf23AUZoZaJhGq8J/Iai+l5YVvH/YVY79H5wuq/B9h5v4uefSVnV9TaNog0WVXTgRky8kXNLAtjSVugmxWwplztvQibNXqDktrXWfcX4z7zXcS3RtgMDIlnAfIfoOLAgSs3u0xzwZ4OTW1ZhviPWaJiP5EfaVlrUlN+ovk1lnvdBb3ba0UTLUWu8bhaaZ6AFm0K3lKY0o5u9wkM9kJvlodIlqLM/IBOHyef1swQIn3A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2026/3/20 10:14, Suren Baghdasaryan wrote:
> On Thu, Mar 19, 2026 at 6:58 PM Hao Ge <hao.ge@linux.dev> wrote:
>>
>> On 2026/3/20 07:48, Suren Baghdasaryan wrote:
>>> On Thu, Mar 19, 2026 at 4:44 PM Suren Baghdasaryan <surenb@google.com> wrote:
>>>> On Thu, Mar 19, 2026 at 3:28 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>>>>> On Thu, 19 Mar 2026 16:31:53 +0800 Hao Ge <hao.ge@linux.dev> wrote:
>>>>>
>>>>>> Due to initialization ordering, page_ext is allocated and initialized
>>>>>> relatively late during boot. Some pages have already been allocated
>>>>>> and freed before page_ext becomes available, leaving their codetag
>>>>>> uninitialized.
>>>> Hi Hao,
>>>> Thanks for the report.
>>>> Hmm. So, we are allocating pages before page_ext is initialized...
>>>>
>>>>>> A clear example is in init_section_page_ext(): alloc_page_ext() calls
>>>>>> kmemleak_alloc().
>>> Forgot to ask. The example you are using here is for page_ext
>>> allocation itself. Do you have any other examples where page
>>> allocation happens before page_ext initialization? If that's the only
>>> place, then we might be able to fix this in a simpler way by doing
>>> something special for alloc_page_ext().
>> Hi Suren
>>
>> To help illustrate the point, here's the debug log I added:
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 2d4b6f1a554e..ebfe636f5b07 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -1293,6 +1293,9 @@ void __pgalloc_tag_add(struct page *page, struct
>> task_struct *task,
>>                   alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr);
>>                   update_page_tag_ref(handle, &ref);
>>                   put_page_tag_ref(handle);
>> +       } else {
>> +               pr_warn("__pgalloc_tag_add: get_page_tag_ref failed!
>> page=%p pfn=%lu nr=%u\n", page, page_to_pfn(page), nr);
>> +               dump_stack();
>>           }
>>    }
>>
>>
>> And I caught the following logs:
>>
>> [    0.296399] __pgalloc_tag_add: get_page_tag_ref failed!
>> page=ffffea000400c700 pfn=1049372 nr=1
>> [    0.296400] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted
>> 7.0.0-rc4-dirty #12 PREEMPT(lazy)
>> [    0.296402] Hardware name: Red Hat KVM, BIOS
>> rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
>> [    0.296402] Call Trace:
>> [    0.296403]  <TASK>
>> [    0.296403]  dump_stack_lvl+0x53/0x70
>> [    0.296405]  __pgalloc_tag_add+0x3a3/0x6e0
>> [    0.296406]  ? __pfx___pgalloc_tag_add+0x10/0x10
>> [    0.296407]  ? kasan_unpoison+0x27/0x60
>> [    0.296409]  ? __kasan_unpoison_pages+0x2c/0x40
>> [    0.296411]  get_page_from_freelist+0xa54/0x1310
>> [    0.296413]  __alloc_frozen_pages_noprof+0x206/0x4c0
>> [    0.296415]  ? __pfx___alloc_frozen_pages_noprof+0x10/0x10
>> [    0.296417]  ? stack_depot_save_flags+0x3f/0x680
>> [    0.296418]  ? ___slab_alloc+0x518/0x530
>> [    0.296420]  alloc_pages_mpol+0x13a/0x3f0
>> [    0.296421]  ? __pfx_alloc_pages_mpol+0x10/0x10
>> [    0.296423]  ? _raw_spin_lock_irqsave+0x8a/0xf0
>> [    0.296424]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
>> [    0.296426]  alloc_slab_page+0xc2/0x130
>> [    0.296427]  allocate_slab+0x77/0x2c0
>> [    0.296429]  ? syscall_enter_define_fields+0x3bb/0x5f0
>> [    0.296430]  ___slab_alloc+0x125/0x530
>> [    0.296432]  ? __trace_define_field+0x252/0x3d0
>> [    0.296433]  __kmalloc_noprof+0x329/0x630
>> [    0.296435]  ? syscall_enter_define_fields+0x3bb/0x5f0
>> [    0.296436]  syscall_enter_define_fields+0x3bb/0x5f0
>> [    0.296438]  ? __pfx_syscall_enter_define_fields+0x10/0x10
>> [    0.296440]  event_define_fields+0x326/0x540
>> [    0.296441]  __trace_early_add_events+0xac/0x3c0
>> [    0.296443]  trace_event_init+0x24c/0x460
>> [    0.296445]  trace_init+0x9/0x20
>> [    0.296446]  start_kernel+0x199/0x3c0
>> [    0.296448]  x86_64_start_reservations+0x18/0x30
>> [    0.296449]  x86_64_start_kernel+0xe2/0xf0
>> [    0.296451]  common_startup_64+0x13e/0x141
>> [    0.296453]  </TASK>
>>
>>
>> [    0.312234] __pgalloc_tag_add: get_page_tag_ref failed!
>> page=ffffea000400f900 pfn=1049572 nr=1
>> [    0.312234] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted
>> 7.0.0-rc4-dirty #12 PREEMPT(lazy)
>> [    0.312236] Hardware name: Red Hat KVM, BIOS
>> rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
>> [    0.312236] Call Trace:
>> [    0.312237]  <TASK>
>> [    0.312237]  dump_stack_lvl+0x53/0x70
>> [    0.312239]  __pgalloc_tag_add+0x3a3/0x6e0
>> [    0.312240]  ? __pfx___pgalloc_tag_add+0x10/0x10
>> [    0.312241]  ? rmqueue.constprop.0+0x4fc/0x1ce0
>> [    0.312243]  ? kasan_unpoison+0x27/0x60
>> [    0.312244]  ? __kasan_unpoison_pages+0x2c/0x40
>> [    0.312246]  get_page_from_freelist+0xa54/0x1310
>> [    0.312248]  __alloc_frozen_pages_noprof+0x206/0x4c0
>> [    0.312250]  ? __pfx___alloc_frozen_pages_noprof+0x10/0x10
>> [    0.312253]  alloc_slab_page+0x39/0x130
>> [    0.312254]  allocate_slab+0x77/0x2c0
>> [    0.312255]  ? alloc_cpumask_var_node+0xc7/0x230
>> [    0.312257]  ___slab_alloc+0x46d/0x530
>> [    0.312259]  __kmalloc_node_noprof+0x2fa/0x680
>> [    0.312261]  ? alloc_cpumask_var_node+0xc7/0x230
>> [    0.312263]  alloc_cpumask_var_node+0xc7/0x230
>> [    0.312264]  init_desc+0x141/0x6b0
>> [    0.312266]  alloc_desc+0x108/0x1b0
>> [    0.312267]  early_irq_init+0xee/0x1c0
>> [    0.312268]  ? __pfx_early_irq_init+0x10/0x10
>> [    0.312271]  start_kernel+0x1ab/0x3c0
>> [    0.312272]  x86_64_start_reservations+0x18/0x30
>> [    0.312274]  x86_64_start_kernel+0xe2/0xf0
>> [    0.312275]  common_startup_64+0x13e/0x141
>> [    0.312277]  </TASK>
>>
>> [    0.312834] __pgalloc_tag_add: get_page_tag_ref failed!
>> page=ffffea000400fc00 pfn=1049584 nr=1
>> [    0.312835] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted
>> 7.0.0-rc4-dirty #12 PREEMPT(lazy)
>> [    0.312836] Hardware name: Red Hat KVM, BIOS
>> rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
>> [    0.312837] Call Trace:
>> [    0.312837]  <TASK>
>> [    0.312838]  dump_stack_lvl+0x53/0x70
>> [    0.312840]  __pgalloc_tag_add+0x3a3/0x6e0
>> [    0.312841]  ? __pfx___pgalloc_tag_add+0x10/0x10
>> [    0.312842]  ? rmqueue.constprop.0+0x4fc/0x1ce0
>> [    0.312844]  ? kasan_unpoison+0x27/0x60
>> [    0.312845]  ? __kasan_unpoison_pages+0x2c/0x40
>> [    0.312847]  get_page_from_freelist+0xa54/0x1310
>> [    0.312849]  __alloc_frozen_pages_noprof+0x206/0x4c0
>> [    0.312851]  ? __pfx___alloc_frozen_pages_noprof+0x10/0x10
>> [    0.312853]  alloc_pages_mpol+0x13a/0x3f0
>> [    0.312855]  ? __pfx_alloc_pages_mpol+0x10/0x10
>> [    0.312856]  ? xas_find+0x2d8/0x450
>> [    0.312858]  ? _raw_spin_lock+0x84/0xe0
>> [    0.312859]  ? __pfx__raw_spin_lock+0x10/0x10
>> [    0.312861]  alloc_pages_noprof+0xf6/0x2b0
>> [    0.312862]  __change_page_attr+0x293/0x850
>> [    0.312864]  ? __pfx___change_page_attr+0x10/0x10
>> [    0.312865]  ? _vm_unmap_aliases+0x2d0/0x650
>> [    0.312868]  ? __pfx__vm_unmap_aliases+0x10/0x10
>> [    0.312869]  __change_page_attr_set_clr+0x16c/0x360
>> [    0.312871]  ? spp_getpage+0xbb/0x1e0
>> [    0.312872]  change_page_attr_set_clr+0x220/0x3c0
>> [    0.312873]  ? flush_tlb_one_kernel+0xf/0x30
>> [    0.312875]  ? set_pte_vaddr_p4d+0x110/0x180
>> [    0.312877]  ? __pfx_change_page_attr_set_clr+0x10/0x10
>> [    0.312878]  ? __pfx_set_pte_vaddr_p4d+0x10/0x10
>> [    0.312881]  ? __pfx_mtree_load+0x10/0x10
>> [    0.312883]  ? __pfx_mtree_load+0x10/0x10
>> [    0.312884]  ? __asan_memcpy+0x3c/0x60
>> [    0.312886]  ? set_intr_gate+0x10c/0x150
>> [    0.312888]  set_memory_ro+0x76/0xa0
>> [    0.312889]  ? __pfx_set_memory_ro+0x10/0x10
>> [    0.312891]  idt_setup_apic_and_irq_gates+0x2c1/0x390
>>
>> and more.
> Ok, it's not the only place. Got your point.
>
>> off topic -  if we were to handle only alloc_page_ext() specifically,
>> what would be the most straightforward
>>
>> solution in your mind? I'd really appreciate your insight.
> I was thinking if it's the only special case maybe we can handle it
> somehow differently, like we do when we allocate obj_ext vectors for
> slabs using __GFP_NO_OBJ_EXT. I haven't found a good solution yet but
> since it's not a special case we would not be able to use it even if I
> came up with something...
> I think your way is the most straight-forward but please try my
> suggestion to see if we can avoid extra overhead.
> Thanks,
> Suren.

Hi Suren

Thank you for your feedback. After re-examining this issue,

I realize my previous focus was misplaced.

Upon deeper consideration, I understand that this is not merely a bug,

but rather a warning that indicates a gap in our memory profiling mechanism.

Specifically, the current implementation appears to be missing memory 
allocation

tracking during the period between the buddy system allocation and page_ext

initialization.

This profiling gap means we may not be capturing all relevant memory 
allocation

events during this critical transition phase.

My approach is to dynamically allocate codetag_ref when get_page_tag_ref 
fails,

and maintain a linked list to track all buddy system allocations that 
occur prior to page_ext initialization.

  However, this introduces performance concerns:

1. Free Path Overhead: When freeing these pages, we would need to 
traverse the entire linked list to locate

      the corresponding codetag_ref, resulting in O(n) lookup complexity 
per free operation.

2. Initialization Overhead: During init_page_alloc_tagging, iterating 
through the linked list to assign codetag_ref to

      page_ext would introduce additional traversal cost.

If the number of pages is substantial, this could incur significant 
overhead. What are your thoughts on this? I look forward to your 
suggestions.


Thanks

Hao

>
>> Thanks.
>>
>>
>>>>>> If the slab cache has no free objects, it falls back
>>>>>> to the buddy allocator to allocate memory. However, at this point page_ext
>>>>>> is not yet fully initialized, so these newly allocated pages have no
>>>>>> codetag set. These pages may later be reclaimed by KASAN,which causes
>>>>>> the warning to trigger when they are freed because their codetag ref is
>>>>>> still empty.
>>>>>>
>>>>>> Use a global array to track pages allocated before page_ext is fully
>>>>>> initialized, similar to how kmemleak tracks early allocations.
>>>>>> When page_ext initialization completes, set their codetag
>>>>>> to empty to avoid warnings when they are freed later.
>>>>>>
>>>>>> ...
>>>>>>
>>>>>> --- a/include/linux/alloc_tag.h
>>>>>> +++ b/include/linux/alloc_tag.h
>>>>>> @@ -74,6 +74,9 @@ static inline void set_codetag_empty(union codetag_ref *ref)
>>>>>>
>>>>>>    #ifdef CONFIG_MEM_ALLOC_PROFILING
>>>>>>
>>>>>> +bool mem_profiling_is_available(void);
>>>>>> +void alloc_tag_add_early_pfn(unsigned long pfn);
>>>>>> +
>>>>>>    #define ALLOC_TAG_SECTION_NAME       "alloc_tags"
>>>>>>
>>>>>>    struct codetag_bytes {
>>>>>> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
>>>>>> index 58991ab09d84..a5bf4e72c154 100644
>>>>>> --- a/lib/alloc_tag.c
>>>>>> +++ b/lib/alloc_tag.c
>>>>>> @@ -6,6 +6,7 @@
>>>>>>    #include <linux/kallsyms.h>
>>>>>>    #include <linux/module.h>
>>>>>>    #include <linux/page_ext.h>
>>>>>> +#include <linux/pgalloc_tag.h>
>>>>>>    #include <linux/proc_fs.h>
>>>>>>    #include <linux/seq_buf.h>
>>>>>>    #include <linux/seq_file.h>
>>>>>> @@ -26,6 +27,82 @@ static bool mem_profiling_support;
>>>>>>
>>>>>>    static struct codetag_type *alloc_tag_cttype;
>>>>>>
>>>>>> +/*
>>>>>> + * State of the alloc_tag
>>>>>> + *
>>>>>> + * This is used to describe the states of the alloc_tag during bootup.
>>>>>> + *
>>>>>> + * When we need to allocate page_ext to store codetag, we face an
>>>>>> + * initialization timing problem:
>>>>>> + *
>>>>>> + * Due to initialization order, pages may be allocated via buddy system
>>>>>> + * before page_ext is fully allocated and initialized. Although these
>>>>>> + * pages call the allocation hooks, the codetag will not be set because
>>>>>> + * page_ext is not yet available.
>>>>>> + *
>>>>>> + * When these pages are later free to the buddy system, it triggers
>>>>>> + * warnings because their codetag is actually empty if
>>>>>> + * CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled.
>>>>>> + *
>>>>>> + * Additionally, in this situation, we cannot record detailed allocation
>>>>>> + * information for these pages.
>>>>>> + */
>>>>>> +enum mem_profiling_state {
>>>>>> +     DOWN,                   /* No mem_profiling functionality yet */
>>>>>> +     UP                      /* Everything is working */
>>>>>> +};
>>>>>> +
>>>>>> +static enum mem_profiling_state mem_profiling_state = DOWN;
>>>>>> +
>>>>>> +bool mem_profiling_is_available(void)
>>>>>> +{
>>>>>> +     return mem_profiling_state == UP;
>>>>>> +}
>>>>>> +
>>>>>> +#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
>>>>>> +
>>>>>> +#define EARLY_ALLOC_PFN_MAX          256
>>>>>> +
>>>>>> +static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX];
>>>>> It's unfortunate that this isn't __initdata.
>>>>>
>>>>>> +static unsigned int early_pfn_count;
>>>>>> +static DEFINE_SPINLOCK(early_pfn_lock);
>>>>>> +
>>>>>>
>>>>>> ...
>>>>>>
>>>>>> --- a/mm/page_alloc.c
>>>>>> +++ b/mm/page_alloc.c
>>>>>> @@ -1293,6 +1293,13 @@ void __pgalloc_tag_add(struct page *page, struct task_struct *task,
>>>>>>                 alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr);
>>>>>>                 update_page_tag_ref(handle, &ref);
>>>>>>                 put_page_tag_ref(handle);
>>>>>> +     } else {
>>>> This branch can be marked as "unlikely".
>>>>
>>>>>> +             /*
>>>>>> +              * page_ext is not available yet, record the pfn so we can
>>>>>> +              * clear the tag ref later when page_ext is initialized.
>>>>>> +              */
>>>>>> +             if (!mem_profiling_is_available())
>>>>>> +                     alloc_tag_add_early_pfn(page_to_pfn(page));
>>>>>>         }
>>>>>>    }
>>>>> All because of this, I believe.  Is this fixable?
>>>>>
>>>>> If we take that `else', we know we're running in __init code, yes?  I
>>>>> don't see how `__init pgalloc_tag_add_early()' could be made to work.
>>>>> hrm.  Something clever, please.
>>>> We can have a pointer to a function that is initialized to point to
>>>> alloc_tag_add_early_pfn, which is defined as __init and uses
>>>> early_pfns which now can be defined as __initdata. After
>>>> clear_early_alloc_pfn_tag_refs() is done we reset that pointer to
>>>> NULL. __pgalloc_tag_add() instead of calling alloc_tag_add_early_pfn()
>>>> directly checks that pointer and if it's not NULL then calls the
>>>> function that it points to. This way __pgalloc_tag_add() which is not
>>>> an __init function will be invoking alloc_tag_add_early_pfn() __init
>>>> function only until we are done with initialization. I haven't tried
>>>> this but I think that should work. This also eliminates the need for
>>>> mem_profiling_state variable since we can use this function pointer
>>>> instead.
>>>>
>>>>


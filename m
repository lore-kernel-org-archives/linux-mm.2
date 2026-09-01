Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 909F0C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 21:05:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 877C06B0088; Tue,  1 Sep 2026 17:05:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8019C6B008A; Tue,  1 Sep 2026 17:05:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C9276B008C; Tue,  1 Sep 2026 17:05:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2D7AF6B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 17:05:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9819440556
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 21:05:34 +0000 (UTC)
X-FDA: 85166424588.06.F4C0D49
Received: from one.firstfloor.org (one.firstfloor.org [65.21.254.221])
	by imf09.hostedemail.com (Postfix) with ESMTP id D5BDC140003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 21:05:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=firstfloor.org header.s=mail header.b=R6K8JbWq;
	spf=pass (imf09.hostedemail.com: domain of andi@firstfloor.org designates 65.21.254.221 as permitted sender) smtp.mailfrom=andi@firstfloor.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788296733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0amkNp5RI0DW0hNNVcgDro4Avoj7XJu0eIgpn5v1EZk=;
	b=8rYxEGxwAejuJRw+W7JWl/aOQ4ZjD4gpRXY7qpVH/A+Npz5bXKFyPt9VNMz++5nLRGDiz1
	BJvY6M8ioHP4P4NS3p2rHuZr2rERGtek4aFM5XgjhWY0vp3q7bkUoYRGxBsVX8GNldMREr
	wqLExZp8Q1T5GmTrETF0/3khwk4fGhM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=firstfloor.org header.s=mail header.b=R6K8JbWq;
	spf=pass (imf09.hostedemail.com: domain of andi@firstfloor.org designates 65.21.254.221 as permitted sender) smtp.mailfrom=andi@firstfloor.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788296733;
	b=oJwN5KH/q0m8Ra+GrEUOzHj9FZfTpuasRCh2cxIpjofdJQ8ox2IBwJcT3ATJiNexN2XAcg
	GjYPaBWt2CmVaJUT5nPRxGbozYcxp6K4JoKls1+eIHFFdZE0fvtQ8ExRalRPkSew6l94XE
	smXtiEwfatNsNDdFUiyvwMss09lwlic=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=firstfloor.org;
	s=mail; t=1788296728;
	bh=mikHWBVHwPIngy7AjWPfkAKPtZLQnacwYBEPka6Yk9s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R6K8JbWqPrEfWCqyPS5qBeb05fyg0HokwPX9IsOBMDQ/m/EKW+jTOYGFey1m0RLm4
	 AqjKbFyIcO/fHJlzrKCRr3kjmnfGgYDh+uHpIeFIHN4lRmWQL1pOKPT8wwGi4j2Sab
	 FTO0DYwmstnvXSeeGcZNs5Wm3NVzA7NO6bl8OP6k=
Received: by one.firstfloor.org (Postfix, from userid 503)
	id D61A95EA51; Tue,  1 Sep 2026 23:05:27 +0200 (CEST)
Date: Tue, 1 Sep 2026 14:05:27 -0700
From: Andi Kleen <andi@firstfloor.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Andi Kleen <ak@kernel.org>,
	akpm@linux-foundation.org, liam@infradead.org, jannh@google.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RCU safety for vma maple tree walks
Message-ID: <apc-F_D5mWwWL74i@firstfloor.org>
References: <20260831143511.1133029-1-ak@kernel.org>
 <apWUsc-a6k1YkuMv@pedro-suse>
 <apXXgimKxgJl57qo@firstfloor.org>
 <apXaTN6o5YaEO8FR@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apXaTN6o5YaEO8FR@lucifer>
X-Stat-Signature: cxa9j4womft3jp1inhj5c651n9b54937
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D5BDC140003
X-Rspam-User: 
X-HE-Tag: 1788296732-273069
X-HE-Meta: U2FsdGVkX1/d3Uu1j+HgT/VmFL8co200Zvx5EgfgY5dIWeG+DN4+dFt4pLDE5IOoo6qusSj2jykdMA2U458+/BXOdC/wTHb9/Sfqh6D1oAo7anG4Fp/W/uzgOMO51zpXvgIGVrBrm1Erj3VRHnepHW7RZvpJ9ESzp+p3mP0rFD/lHqHsf8yHuI0GfvxCRoAy4SbZGrJ9ICyq657oMV+9doAmFMr7LjmB0OfJkrKqaiXdwc/3vDFj6KHlwE/YnzxUgmq/CmTIAzMIEihit2keTfcA8NhjyBNbT+EwXsujbxDymr1qqz5EPwPYFV36uy16j/5o0l1yqs2/K0MSiGQhVcjyHC+CiUIQJzqOg4ik4bitjUOC7tNPw4Zq/41oxuRQ2LyfuUIYuUnQlDKVZ1Pc0VNwjfFemW2xcfQM1AdinOU1yGVCQkY15KZUwHIhQ+77s+l/qImwOtDi6vtp9PTubKc0LAQ5Zc2k6W/fa2lopuV32PCSO2ysTAtvAChOp3671Iv7VZ1tYmbaAe/ktTy6g14pO/WZldLN/xJN49F+0t7EBq1Jo78deDnSBeW3YTarOg7N31tyIGg6fbbf0n33Vse3lWrsOQCzNuiQxjOrKif++aXPDRLPodVNugvAsFD0KOuP7/ynFz9/W3o4aFImkNR041Y0dLwbcYXmahI9l2kvOB1D1qQikXfxOsJLWLcfJZ4e72jY4jpImvlrwL++KcBcW/lqwdv4M28hw2jhhKBi2HsgO96Ry0Bp79zoHj5CgTQZyq8nYJKrQnOv3j+/1Ds5TGpsDY8kWBEp1PrrhjnWPyxIL8eJ5/NKj0UneoGjrTEJSqZ2Lwm4SbJOZf5ZltbMvxHL/LntVVE8rPMyH6kVU0wRJMFOl1C+BFlfute4/2QRi2roALI5FqhreSOBlwFxsFR925K97M7ol7XaF8jwWmTHDOp0r0d2p30GgtI/99DHfMlJDABlSlmiYiz
 FoI9QmoD
 +wF8nP9+5Uz9f9Fe1FHpiSm/bk4EquUV2f0oNj3yVxCpQJnUOabDsmZ4rEz13UuJLzVcNRQl3RShYfBfPLGqveBSQ9N/5Iv0LpIixeNGnHZMo9oAyK1ayVTz7uAC8SccIu0DhS9meK2bXWgWIq20iVind0HBHF2bm6yw1OpsOzL2R3Y5yNfctolbjj5FqpOjbP2OLa8DTnh2mvCkp/6cs8gbZuryL8xE0YVuBLSPX0tfHfqJoeBhBWKvBiLL1JB9WT8wLR8qc/pGUyaahpTq95ranWwdmYB78SgYgw3ahdKdBRrh477ZU9KD1uki/X5A1EXN7fI7VnzaG8CO7/IvzZktZhq3n7dAYJsUItNXN5AOnK3sBhPfrp/RHbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 08:55:37PM +0100, Lorenzo Stoakes (ARM) wrote:
> I mean what actually modifies the maple tree nodes here?
> 
> __split_vma()
>   -> vma_complete()
>     -> vma_iter_store_new()
>       -> vma_iter_store_overwrite()
> 
> Right?

The crash was on the walk, but yes the modification likely causes it.

> 
> But I see:
> 
> 	if (vmi->mas.status != ma_start &&
> 	    ((vmi->mas.index > vma->vm_start) || (vmi->mas.last < vma->vm_start)))
> 		vma_iter_invalidate(vmi);
> 
> Which calls mas_pause() which sets mas->node = NULL.
> 
> So I mean, presumably you are saying this doesn't work correctly or this
> criteria is wrong, I can't really see how else there could be a problem here,
> could you explain exactly what's up here?

I can't explain it currently, but yes something wrong with that logic
is a good theory.

I have a (somewhat garbled) processor trace log of the failure, but
it doesn't quite have enough information to untangle it completely.

The original bug also happened in a very memory constrained environment
(4GB guest), but it's somewhat hard to reproduce it in a setup
that still has enough memory to do useful debugging.

I'm currently working on the reproducer on the vanilla kernel.

So far I made some progress to get something that looks closer to the
original trace, but I need artificial sleeps at the vma allocation point
and it still didn't fully reproduce the original scenario yet. 

There was actually one crash with a different
signature, but I haven't analyzed it so far [1].

The WIP stresser that forces something that is close to the 
uprobes is here: 
https://firstfloor.org/~andi/madvise-dontfork-stress.c

> Also why is the solution to insert a whole bunch of RCU read locks everywhere so
> we can keep on accessing a node that we've already decided to free?

I may have an old school understanding of RCU, but I was always
thinking that the rcu read sections are needed for any readers with
preemption. The walker is clearly a reader.

But I guess in this particular case it's not true because
the writer lock and the invalidation is enough. It still seems a little
dubious with all the preemption cases, but at least I cannot see a clear
hole.

> 
> I mean surely the solution really ought to be simply invalidating the iterator
> right?

Yes I guess. It would certainly be simpler.


> 
> Also again, could you share the patch you've applied to the kernel you're
> actually seeing this bug in, given you haven't reproduced it even once with an
> upstream kernel?

Sure it's this patchkit on l-k that adds some new functionality to
uprobes: https://lore.kernel.org/lkml/20260831150651.1134594-1-ak@kernel.org/
(or for more information
https://lore.kernel.org/lkml/20260831150651.1134594-16-ak@kernel.org/ )

I don't think it actually changes any core VM locking or really how the uprobes
interact with the VM code, but it changes timing and makes it easier
to have some obscure DONTCOPY VMA setups. The actual VM code is not
changed.

The code that changes the core uprobes behavior is 5/19, but it can't really
be fully exercised without some of the later patches.

Also the posted version has some issues (at least Sashiko pointed out 
some real problems), but I don't believe it affects this.

-Andi


[1]


[   66.689807][  T532] BUG: unable to handle page fault for address: ffffebde00477288
[   66.691116][  T532] #PF: supervisor read access in kernel mode
[   66.692227][  T532] #PF: error_code(0x0000) - not-present page
[   66.693267][  T532] PGD 0 P4D 0 
[   66.693841][  T532] Oops: Oops: 0000 [#1] SMP KASAN NOPTI
[   66.694596][  T532] CPU: 1 UID: 0 PID: 532 Comm: madvise-dontfor Not tainted 7.2.0-1-debug+ #2 PREEMPT(full)  967bbfd33d6729a809cf8db6188ec03a118152c4
[   66.697960][  T532] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
[   66.700523][  T532] RIP: 0010:qlist_free_all+0x93/0x130
[   66.701296][  T532] Code: c2 4c 01 f2 0f 82 a3 00 00 00 48 c7 c1 00 00 00 80 48 2b 0d b7 c9 34 03 48 01 ca 48 c1 ea 0c 48 c1 e2 06 48 03 15 95 c9 34 03 <48> 8b 4a 08 48 89 ce 83 e6 01 48 83 ee 01 48 09 f1 48 21 ca 31 c9
[   66.702949][  T532] RSP: 0018:ffff8881097a7478 EFLAGS: 00010282
[   66.703474][  T532] RAX: 0000000011dca450 RBX: 0000000000000000 RCX: 0000777f80000000
[   66.704728][  T532] RDX: ffffebde00477280 RSI: ffffea000447ad40 RDI: 0000000000200000
[   66.706497][  T532] RBP: 0000000011dca450 R08: 0000000000000001 R09: ffffffff9a58ccfe
[   66.708160][  T532] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[   66.709799][  T532] R13: ffff8881097a74b0 R14: 0000000080000000 R15: ffff888111eb5d00
[   66.711393][  T532] FS:  00007f2990b12780(0000) GS:ffff888228ea7000(0000) knlGS:0000000000000000
[   66.713158][  T532] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   66.714486][  T532] CR2: ffffebde00477288 CR3: 0000000103565005 CR4: 0000000000f70ef0
[   66.715595][  T532] PKRU: 55555554
[   66.715972][  T532] Call Trace:
[   66.716320][  T532]  <TASK>
[   66.716629][  T532]  kasan_quarantine_reduce+0x19a/0x250
[   66.717190][  T532]  __kasan_slab_alloc+0x6a/0x90
[   66.717706][  T532]  kmem_cache_alloc_noprof+0x214/0x6b0
[   66.718285][  T532]  ? vm_area_dup+0x2b/0x970
[   66.718763][  T532]  vm_area_dup+0x2b/0x970
[   66.719211][  T532]  ? msleep+0x1b/0x30
[   66.719625][  T532]  __split_vma+0x32e/0xbb0
[   66.720086][  T532]  ? __pfx___split_vma+0x10/0x10
[   66.720596][  T532]  ? __pfx_mas_prev+0x10/0x10
[   66.721095][  T532]  ? lock_is_held_type+0xfa/0x1c0
[   66.721613][  T532]  vma_modify+0x1a50/0x24e0
[   66.722087][  T532]  ? __pfx_vma_modify+0x10/0x10
[   66.722593][  T532]  ? lock_is_held_type+0xfa/0x1c0
[   66.723110][  T532]  vma_modify_flags+0x2ed/0x4e0
[   66.723594][  T532]  ? __pfx_vma_modify_flags+0x10/0x10
[   66.724144][  T532]  ? mas_prev_slot+0x328/0x1d30
[   66.724655][  T532]  mprotect_fixup+0x226/0xb90
[   66.725142][  T532]  ? __pfx_mprotect_fixup+0x10/0x10
[   66.725696][  T532]  ? mas_prev_slot+0x328/0x1d30
[   66.726195][  T532]  ? lock_is_held_type+0xfa/0x1c0
[   66.726706][  T532]  ? mas_next_slot+0xa7a/0x20a0
[   66.727200][  T532]  ? lock_sequence+0xd7/0x180
[   66.727676][  T532]  do_mprotect_pkey+0x81d/0xb40
[   66.728167][  T532]  ? __pfx_do_mprotect_pkey+0x10/0x10
[   66.728702][  T532]  ? rcu_is_watching+0x16/0xb0
[   66.729193][  T532]  ? do_syscall_64+0x203/0x6a0
[   66.729696][  T532]  ? lockdep_hardirqs_on+0x95/0x140
[   66.730226][  T532]  ? entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   66.730811][  T532]  ? do_vmi_munmap+0x159/0x2e0
[   66.731226][  T532]  ? __vm_munmap+0x1dc/0x360
[   66.731635][  T532]  ? __do_sys_mincore+0x4b6/0x6c0
[   66.732129][  T532]  __x64_sys_mprotect+0x78/0xe0
[   66.732616][  T532]  ? lockdep_hardirqs_on+0x95/0x140
[   66.733140][  T532]  ? do_syscall_64+0x83/0x6a0
[   66.733611][  T532]  do_syscall_64+0xf6/0x6a0
[   66.734068][  T532]  ? trace_hardirqs_on_prepare+0x13d/0x190
[   66.734650][  T532]  ? lockdep_hardirqs_on+0x95/0x140
[   66.735185][  T532]  ? entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   66.735786][  T532]  ? do_syscall_64+0x221/0x6a0
[   66.736264][  T532]  ? rcu_is_watching+0x16/0xb0
[   66.736746][  T532]  ? rcu_is_watching+0x16/0xb0
[   66.737233][  T532]  ? do_syscall_64+0x203/0x6a0
[   66.737721][  T532]  ? trace_hardirqs_on_prepare+0x13d/0x190
[   66.738302][  T532]  ? lockdep_hardirqs_on+0x95/0x140
[   66.738820][  T532]  ? entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   66.739924][  T532]  ? do_syscall_64+0x221/0x6a0
[   66.740457][  T532]  ? do_syscall_64+0x203/0x6a0
[   66.740934][  T532]  ? trace_hardirqs_on_prepare+0x13d/0x190
[   66.741518][  T532]  ? lockdep_hardirqs_on+0x95/0x140
[   66.742038][  T532]  ? entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   66.742638][  T532]  ? rcu_is_watching+0x16/0xb0
[   66.743115][  T532]  ? do_syscall_64+0x31/0x6a0
[   66.743582][  T532]  ? trace_hardirqs_off_finish+0x13d/0x190
[   66.744172][  T532]  ? lockdep_hardirqs_off+0xb3/0x100
[   66.744717][  T532]  ? do_syscall_64+0x64/0x6a0
[   66.745212][  T532]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   66.745834][  T532] RIP: 0033:0x7f2990c22667
[   66.746301][  T532] Code: ef e8 dd f9 ff ff 84 c0 75 b9 31 db 48 83 c4 08 48 89 d8 5b 5d 41 5c 41 5d 41 5e 41 5f c3 0f 1f 44 00 00 b8 0a 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 79 77 0d 00 f7 d8 64 89 01 48
[   66.748156][  T532] RSP: 002b:00007fffb8fba1e8 EFLAGS: 00000202 ORIG_RAX: 000000000000000a
[   66.748885][  T532] RAX: ffffffffffffffda RBX: 0000000000004000 RCX: 00007f2990c22667
[   66.749575][  T532] RDX: 0000000000000001 RSI: 0000000000004000 RDI: 00007f2990af6000
[   66.750260][  T532] RBP: 0000000000000008 R08: 00000000ffffffff R09: 0000000000000000
[   66.750942][  T532] R10: 0000000000000022 R11: 0000000000000202 R12: 00007f2990af2000
[   66.751948][  T532] R13: 0000000000020000 R14: 00007f2990af6000 R15: 0000000000000001
[   66.752777][  T532]  </TASK>
[   66.753093][  T532] Modules linked in:
[   66.753516][  T532] CR2: ffffebde00477288
[   66.753935][  T532] ---[ end trace 0000000000000000 ]---
[   66.754496][  T532] RIP: 0010:qlist_free_all+0x93/0x130
[   66.754503][  T532] Code: c2 4c 01 f2 0f 82 a3 00 00 00 48 c7 c1 00 00 00 80 48 2b 0d b7 c9 34 03 48 01 ca 48 c1 ea 0c 48 c1 e2 06 48 03 15 95 c9 34 03 <48> 8b 4a 08 48 89 ce 83 e6 01 48 83 ee 01 48 09 f1 48 21 ca 31 c9
[   66.754505][  T532] RSP: 0018:ffff8881097a7478 EFLAGS: 00010282
[   66.754508][  T532] RAX: 0000000011dca450 RBX: 0000000000000000 RCX: 0000777f80000000
[   66.754509][  T532] RDX: ffffebde00477280 RSI: ffffea000447ad40 RDI: 0000000000200000
[   66.754511][  T532] RBP: 0000000011dca450 R08: 0000000000000001 R09: ffffffff9a58ccfe
[   66.754512][  T532] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[   66.754513][  T532] R13: ffff8881097a74b0 R14: 0000000080000000 R15: ffff888111eb5d00
[   66.754515][  T532] FS:  00007f2990b12780(0000) GS:ffff888228ea7000(0000) knlGS:0000000000000000
[   66.754517][  T532] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   66.754518][  T532] CR2: ffffebde00477288 CR3: 0000000103565005 CR4: 0000000000f70ef0
[   66.754524][  T532] PKRU: 55555554
[   66.754526][  T532] note: madvise-dontfor[532] exited with irqs disabled


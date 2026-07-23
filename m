Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A606C531D2
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 14:19:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5732B6B008A; Thu, 23 Jul 2026 10:19:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5228F6B008C; Thu, 23 Jul 2026 10:19:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EB616B0092; Thu, 23 Jul 2026 10:19:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 019406B008A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:19:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6FC16C0532
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:19:03 +0000 (UTC)
X-FDA: 85020248166.21.85ACA01
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id CC38940010
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:19:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784816341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WSN0r+iT6SfaE/qckT8h1gzZOTA2ZajGVSqgCAGFe7M=;
	b=ANjhFMLB/NcopuEAY9dRZj3RlcX0qHpUF3ybH8sckFULlEpK10xtv78a3bjv7jqKBWyzj0
	XDBHeD0jVkKHez9LpgIEwf0VhUDYrYlsuewYSVzCMAVmefdiqukW/8foJ9YhYYPkXmE0pw
	pNbZyOwFYWhAxrR0kaVmAp90Byv7QAA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784816341;
	b=ib7KtRuBWwSO70er9sPiOJgHCh+XYoDoNUTc8miKSrWaPU4hLdr7nrYc5oX8/XKZJAx+Wu
	hdHGNmHeKZna+wWTd8/ottsLlOAuBmgfLWfDx36NQWW1DQg5pOSxiEWJWZJusroSD6IHUQ
	TZnvXTclmHEEwjQFQFl7sh8pXaIqKDw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F9D9600AD;
	Thu, 23 Jul 2026 14:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5040D1F000E9;
	Thu, 23 Jul 2026 14:18:54 +0000 (UTC)
Date: Thu, 23 Jul 2026 15:18:24 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, David Carlier <devnexen@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	"Denis V. Lunev" <den@virtuozzo.com>, stable@vger.kernel.org, 
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>, 
	"intel-xe@lists.freedesktop.org" <intel-xe@lists.freedesktop.org>
Subject: Re: [REGRESSION]: [PATCH mm-hotfixes v5 3/5] x86/mm/pat: acquire
 init_mm read lock on attribute change to avoid UAF
Message-ID: <amIEC1qDW3kfeuHd@lucifer>
References: <20260717-series-vmap-race-fix-v5-0-606a0ac6d3e5@kernel.org>
 <20260717-series-vmap-race-fix-v5-3-606a0ac6d3e5@kernel.org>
 <80993b70-352f-4069-84c7-39a04c061e98@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80993b70-352f-4069-84c7-39a04c061e98@intel.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CC38940010
X-Rspam-User: 
X-Stat-Signature: hhjzckibq53wgiuyhxeemc7njj5h6z4f
X-HE-Tag: 1784816341-552809
X-HE-Meta: U2FsdGVkX18Yv/qBIS1fitYcwfaKtGEh68996qBTZa27o9kXvZjB0Ak7IupVEFjtW03/hNxQbN0JY1INXr7hClgdcd4iWaecyb/2Y4+rRVwxO2PKB+WfE/E1tKVUidkZuM45goI+us00ewtaYwY8MpMMJ+3VqH47hN4dfZhXaZNAhdfd3jcJvL5A8gxVuclXfbB2vvIUTRoggD1CaLXf4y/ZYz58y53xZ9E5vDBsVuVYUgiCIasPp+LEq2bQj6b18KLP3Ljlixb/VR/nF89DV/ThGC34S+/aKDJUO/zxDPmB2CaneUWZdqnxJ9gKWqqAG8v2jO1b2318MM4unpEU1GMCa4SRcWVHzJPFPSRcijxuySllfwm99yJ70c5dSYXWXYtBTKqomiFTo39ADIuTjP6fpZp5HtEq84xmWYLIiihANLbIf3r4I242HmPAUGdsRA/Evqr6iqWFlIMoLSSyh+546Xa9yYbECUHOCnYoRJBDSPAckg64JYx9/Kp1uZz6OwZGMofVyErz2be7OaBNu1/MBcFKJxqevGgoleHy2KQ99Uq9F6G3Gd7mss8IssYavh1x9vYpTSX5/3mNrbPbiCMTYeMWCVkfT4LLU3jeSQPqi28jUSW8xkkWVSA33zsF9j05UnJ6Y6q3BfuiGELm0dLn1QOkCA++2iy5t+Q8J8OnYvEhztfV9NJTUWJancwq4L8KtQMUCcoJyeHKrEgJg6JCxn7lWF/FmXqP5KnQyAXeHnuT0LAZpoVFSzdVcjtcPAa96X2WNJLLwMlWbf80o/HjP6loKT6H7SuioF66wBc6hYYaBtDEgdsBAHvBus1xktCp8yrWIYiXzMgZu7NhBePZxD7gEWYvlqEpi/xuYm/ziAvO5FYvpfm5tl45I4J33QyW2apsfS0gtXypL8xLPrz4PhZXbA9fa1eZ59P6fXj3BXGsvJz6uR/FHpUMwRtj0nKh4x8BVO9ZoxVunI1
 0I0eIUTI
 JuJbzHHGLtcrMwsaraT2HZ+ligA1pePz2VDzNSW22sjkQLv5/GtS9t3jLBWH1TTgxCOjjG1vdHW8EuRXP/YeiSPrGk6avYJyfO+jXOeqQKJOMe4yYygkL1mMKI6bXwfOaRpfPW6Wefhi9rp1EN2ibQOvPr+GOP1xDsQdFgQmvQ12yTVHzVdn2TETv26CN2HqnZBfew2AP7CSFV0mqTqPdDC9cOAQQhNmPJb33sYpho1l12rpDZXGyrluk041J7R8iUAa56RaGyRBl59gAYEIx7hTE0M5YT8cBi29fkWAvVxlFGmRCLtBX+Fp29xQhVQx6hKv9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 12:00:42PM +0530, Borah, Chaitanya Kumar wrote:
> Hello Lorenzo,
>
> On 7/17/2026 11:00 PM, Lorenzo Stoakes (ARM) wrote:
> > A previous commit protected us against races between ptdump and CPA
> > collapse, however one still exists between attribute changes and collapse
> > as reported by Denis V. Lunev (linked).
> >
> > When an attribute change arises, a lockless page table walker obtains a PTE
> > entry, which is later written to via set_pte_atomic():
> >
> > ...
> > -> change_page_attr_set_clr()
> > -> __change_page_attr_set_clr()
> > -> __change_page_attr()
> > 	-> _lookup_address_cpa()
> > 	-> lookup_address_in_pgd_attr()
> > 	-> [ lockless page table walker ]
> > -> set_pte_atomic()
> >
> > There is nothing preventing a concurrent CPA collapse which can free the
> > PTE that was retrieved here, resulting in a use-after-free.
> >
> > With the mmap write lock taken on init_mm over CPA collapse, we can now
> > resolve this race by acquiring an mmap read lock on init_mm over
> > __change_page_attr_set_clr().
> >
> > This locks across the whole operation over which the walk and the PTE entry
> > write occurs, solving the race.
> >
> > It is safe to do this here, as no spinlocks are held upon entry to
> > __change_page_attr_set_clr().
> >
> > The CPA_COLLAPSE flag is only set by set_memory_rox(), which exclusively
> > operates upon vmalloc ranges, and on x86 only within the module mapping
> > space.
> >
> > This is important, because some callers directly invoke
> > __change_page_attr_set_clr(), bypassing this lock. However, none of these
> > operate within the module mapping space.
> >
> > * cpa_process_alias() - a recursive helper called by
> >    __change_page_attr_set_clr().
> > * __set_memory_enc_pgtable() - operates on the direct mapping and (via
> >    __vmbus_establish_gpadl()) the vmalloc mapping space.
> > * __set_pages_[n]p() - called by set_direct_map_[invalid, default,
> >    valid]_noflush(), __kernel_map_pages() - operates on the direct map.
> > * kernel_[un]map_pages_in_pgd() - operates on EFI ranges.
> >
> > This work is based upon Denis V. Lunev's excellent analysis of the bug with
> > gratitude.
> >
>
> This seems to be causing regression in our linux-next CI [1] on some of the
> older machines (fi-elk-e7500, fi-ilk-650, fi-pnv-d510)

Thanks for the report!

A small note - it'd be useful for you to clearly point
out the revision of next to make our life a bit easier :)

I can see from below in the stack and the URI it's next-20260720. There was a
broken merge in linux-next for a while but it's fixed by 20260720 so that's not
it.

>
> <4> [196.236867] ======================================================
> <4> [196.236878] WARNING: possible circular locking dependency detected
> <4> [196.236890] 7.2.0-rc4-next-20260720-next-20260720-g3fe08b9796f3+ #1
> Tainted: G S   U       L
> <4> [196.236906] ------------------------------------------------------
> <4> [196.236916] core_hotunplug/5687 is trying to acquire lock:
> <4> [196.236927] ffffffff839048b8 ((init_mm).mmap_lock){++++}-{4:4}, at:
> change_page_attr_set_clr+0x10a/0x220

This is the result of my change indeed.

> <4> [196.236958]
> but task is already holding lock:
> <4> [196.236969] ffff88810c852238 (&vm->mutex){+.+.}-{4:4}, at:

So this is a lock dependency issue as this is obviously an entirely
different lock.

> i915_ggtt_driver_release+0xab/0x260 [i915]
> <4> [196.237572]
> which lock already depends on the new lock.
> <4> [196.237585]
> the existing dependency chain (in reverse order) is:
> <4> [196.237597]
> -> #2 (&vm->mutex){+.+.}-{4:4}:
> <4> [196.237617]        i915_gem_shrinker_taints_mutex+0x35/0x70 [i915]
> <4> [196.238267]        i915_address_space_init+0x226/0x2a0 [i915]
> <4> [196.238961]        i915_ggtt_init_hw+0x2c/0x140 [i915]
> <4> [196.239638]        i915_driver_hw_probe+0x208/0x380 [i915]
> <4> [196.240260]        i915_driver_probe+0x113/0x5b0 [i915]
> <4> [196.240883]        i915_pci_probe+0xe0/0x1d0 [i915]

(another small note - running scripts/decode_stacktrace.sh would be hugely
useful as these offsets aren't so useful unless I have the exact kernel
binary you have with debug symbols :)

>
> Detailed log can be seen found in [2]
>
> We confirmed that reverting the patch solves the issue.
>
> Could you please check why the patch causes this regression and provide
> a fix if necessary?
>
> Regards
> Chaitanya
>
> [1] https://intel-gfx-ci.01.org/tree/linux-next/combined-alt.html?
> [2] https://intel-gfx-ci.01.org/tree/linux-next/next-20260720/fi-ilk-650/igt@core_hotunplug@unbind-rebind.html

<snip>

So looking into it we have deadlock potential here:

1. fs_reclaim -> &vm->mutex

< device init >
-> i915_address_space_init()
-> ...
-> i915_gem_shrinker_taints_mutex()
(mark the dependency in lockdep)

This is presumably because the shrinker needs to lock this mutex.

2. init_mm -> fs_reclaim

This was introduced by my patch and there we have:

< caller needs to set memory, e.g. BPF >
-> set_memory_rox()
-> change_page_attr_set_clr()
-> [acquire init_mm lock] <-- my change
-> __change_page_attr_set_clr()
-> __change_page_attr()
-> split_large_page()
-> pte_alloc_one_kernel()
[ allocation ]
< trigger direct reclaim >

Thus init_mm -> fs_reclaim becasue in split_large_page() there's:

	if (!debug_pagealloc_enabled())
		spin_unlock(&cpa_lock);
	pte = pte_alloc_one_kernel(&init_mm); <-- allocate
	if (!debug_pagealloc_enabled())
		spin_lock(&cpa_lock);
	if (!pte)
		return -ENOMEM;

Note the CPA lock dance, will come back to that as that's how to solve this
issue...

3. &vm->mutex -> init_mm

< device remove >
-> i915_ggtt_driver_release()
-> ggtt_cleanup_hw()
-> [acquire &vm->mutex lock]
-> ggtt->vm.cleanup == gmch_ggtt_remove()
-> intel_gmch_remove()
-> intel_gtt_teardown_scratch_page()
-> set_pages_wb()
-> set_memory_wb()
-> _set_memory_wb()
-> change_page_attr_clear()
-> change_page_attr_set_clr()
-> [acquire init_mm lock] <-- my change

This &vm->mutex -> init_mm

And so there is a circular dependency:

 	&vm->mutex ---> init_mm
	      ^            |
               \           v
                \--- fs_reclaim

(lockdep should totally do diagrams like this :)

In reality to hit this you'd need something to be doing direct reclaim on
allocating a split page table during a CPA operation with a simultaneous
contended init_mm lock.

But this issue is broader than that really - we can't be holding init_mm
over an allocation.

split_large_page() calls __split_large_page() after dropping the CPA lock,
which opens with a revalidation:

	spin_lock(&pgd_lock);
	/*
	 * Check for races, another CPU might have split this page
	 * up for us already:
	 */
	tmp = _lookup_address_cpa(cpa, address, &level, &nx, &rw);
	if (tmp != kpte) {
		spin_unlock(&pgd_lock);
		return 1;
	}

There's also revalidation in __change_page_attr() on every split:

	err = split_large_page(cpa, kpte, address);
	if (!err)
		goto repeat;

(Where goto repeat entails a complete rewalk)

So dropping the init_mm lock here should not result in any problems with
being raced by a collapse and was something already accounted for.

So the broad strokes of the fix is to eliminate the init_mm -> fs_reclaim
dependency and thus break the dependency loop.

I'll send a respin with this addressed.

Cheers, Lorenzo


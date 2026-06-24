Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BEEECDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 13:40:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66CD06B0088; Wed, 24 Jun 2026 09:40:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F8DB6B008A; Wed, 24 Jun 2026 09:40:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BF066B008C; Wed, 24 Jun 2026 09:40:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16F686B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:40:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8C3F81C5B9C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:40:09 +0000 (UTC)
X-FDA: 84914914938.19.EA3DB3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id C4BD218000B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:40:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FJLyC/lX";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782308407;
	b=c1xGKNk2wIrGe+lwXZzyKFWqFUh83mWOxYT57iw3hDkbA0g+v7YfURkBjkVxXmhPN2H7It
	jrf29UFfRUFZ975vbpQ9Kmxram5IoVQjkzkSZCs5+zKNWJjCytNlHH5jxV+Q7OT6tatNak
	I34u3FavN1inY3AWlt+2OQzxTo9KXUM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782308407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oSmnVUDEowNS7nXYHo4vlbwaFGW/DKpjdODnzdWCEgM=;
	b=lLfa4ALschnNM++DSgAXipZpKawlmpzaqz+TMT9auYLP5qwk4T0CtumITcU+ao6fCI/Sje
	dg9IODPVqZqIW/Y87FzMX7iSHG3F+FMZeBoqVn7vwY3lLTGH6OjS8xKuPJK0P6TMmsXo5r
	gd+L1hSnJtvuDhgypxPhtFM3iGUJTVw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FJLyC/lX";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D6A5D43C7E;
	Wed, 24 Jun 2026 13:40:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE201F000E9;
	Wed, 24 Jun 2026 13:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782308406;
	bh=oSmnVUDEowNS7nXYHo4vlbwaFGW/DKpjdODnzdWCEgM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=FJLyC/lXcGVoAgDPm/MD2U/3XWT73nrQxL90QOkHUYXK5sQEQHTDjeJD+Nl87FhMr
	 f0KGAs6COTewuS2gTfRSFXBfuqpPtGxhBoWuAEkV23kxmgX2gCQI2yVJxj38/kg+8M
	 jKhkeb2z4nbAiMyCnuzzZZuUpLv17TpqMQn2yv+4HgB/Seqywxhdq3iuk4Uve8Kpf3
	 Msz7r39Av4nCwic8Fu95AC28lsndXWtzv1Y8Nt4RFzWD+0hPyRbgiMimoIQfURvbgI
	 lnc8FZzgrVtFxC4lW8Z0hUcRB1uDtgDO0f5RtkgRqL7VmAa/H5sX116+HRrpFu8OH7
	 XSRQFHl4sDmWw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: nao.horiguchi@gmail.com,  linmiaohe@huawei.com,  david@kernel.org,
  lance.yang@linux.dev,  akpm@linux-foundation.org,  baoquan.he@linux.dev,
  rppt@kernel.org,  pratyush@kernel.org,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  rneu@meta.com,  riel@surriel.com,  caggio@meta.com,
  kas@kernel.org
Subject: Re: mm/hwpoison: persist poisoned PFN list across kexec via KHO [RFC]
In-Reply-To: <ajut_LDQGYCShApx@gmail.com> (Breno Leitao's message of "Wed, 24
	Jun 2026 03:39:38 -0700")
References: <ajut_LDQGYCShApx@gmail.com>
Date: Wed, 24 Jun 2026 15:40:03 +0200
Message-ID: <2vxzse6ckqfg.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C4BD218000B
X-Rspam-User: 
X-Stat-Signature: 4u69d3scw48ad97pj569mqqn8nu44cck
X-HE-Tag: 1782308407-236432
X-HE-Meta: U2FsdGVkX1/XMONNAaHDrVd+B+r0mQsVUlX980XKEOdmFY2fr7EOz3rS93Yw5PuoaBhFL0R5cvXMyD6GOP0ttgk9ZtHXndB2MpC5gs54adXt/yeMMzOFj7EyS51vz79TqZ4BDTmMDMJNqUfj7Qugawpv6s6ugZn7AaDT2fWqXeD7HnL/5RPgdkmL2qDkw2I1zUWGYqubSBpFhRddGdoaCSJdt7uh6YevMZCOg0D+oaeBI/OlVExNypzO+9olhHCwnGGgOdqrJPMgZKqr/FWvVMrZIakX8LRxcutJXuX2G36iNn9UPA9b18i3BIb/KoxgLGkEmZrDsQ96GxKPV90etdhOINMwSVpIv04n8E7DOrD1m5aaU0A5ef+NjqeWZ+1L52wcgaBzZl+1zC9M/9HDV7GFJymX44sDVQxg5QQgRYv+HMeNvOQXgWrllFQD6SPokNQis9Ug2Dy2buEp1RQPOfq8+mMs21DYvWbAZBUXZA3hw3q+9fl8Dn7+s3KXsrX9mA4hUHUPh63SmsZ+mcYjivOlxt4Pg/eSSRMrmjGLojfT/41eZhlfaVOSCOpgraFukLKhP/5IA1epMTQmguX/EvQiwjiLtLR7p9e9wbqeNrE553CFjIp8HKwGp2fTMhYeeprV4ov0jMdVy4cEA3fDIeWcQVP0JB+guVeKlZFHJ0xB5gxFykFuTujhkoozdJDQuRZskTAvPhNE9lkSieSpZeite7krzxAIyrWUu6m874R4F+jE4FOLSesnp3MoseZmySYC09FvIcywpWbdz9yGqGKWqeHSOzCO7uGRbZzqZdnz/CktY9RD35ug+KXcaXRhz58LKVFQ6x+eAuoEZHNk+1e1mQ7cVUdONYvs4oN1809bJ0QZDtZRTASeaHYnQp7zCHt+o/cNOrVMSP+A/UMBTU7jY6BcwP4ajdQtwK+zzOagKG3enrjdEGvIUdvbdvDyO9CNtMs5CrF/6rTYe/m
 dtCZNBYd
 gskLivJw60DbOpd9UEN69nN7JzPFUD9FLZuxKnxpEnqQdVtXdZccROaSDkdR9xq56+BYEVVicNAZ+lbAGL3Jhic+hdul22OvamQW3IYfqjcpAHW2LLBux8PWsWT+CWYOtE3omc8MhmjiAPa0B6WCa5/YBP7QF6PaTS1ne7dD/BYOHxsYN/qxVrxVG16kUcrS3DHHiwn6pkBTlrEB0gw9F+NW+xsBxuI+hroqYY6mnUHGLZr2K6RNSgUUVNcADTXeT8TP8kLHjlLmXk84de9jyw+yqYP6tdV8Z/EJpU/ORFJ3Z27eTxwH9iyoFapETolgE8PvMSdC9X43tDikH+tpFni6gkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24 2026, Breno Leitao wrote:

> TL;DR: carry the hardware-poisoned page list across kexec using KHO, so the
> next kernel doesn't hand out known-bad RAM.
>
> The problem
> ===========
>
> When a page is hard-offlined due to an uncorrectable memory error (multi bit
> ECC), memory_failure() sets PG_hwpoison, unmaps it, removes it from the buddy
> allocator and accounts it in num_poisoned_pages / HardwareCorrupted. All of
> that lives in the running kernel's data structures, not in the hardware.
>
> A kexec replaces the kernel image but not the physical DRAM. The next kernel
> rebuilds mem_map[] from the firmware-provided memory map, sees the bad frame as
> ordinary system RAM, and the buddy allocator hands it back out on the next
> kernel. The known-bad cell is silently back in circulation, and the next
> access faults again - potentially in a context that is harder to recover than
> the original (e.g. a kernel allocation rather than a killable user page).
>
> This matters most where kexec is frequent and machines are long-lived: live
> kernel update on large fleets. Poison knowledge accumulates over uptime and is
> thrown away on every update.

I don't know much about hardware page poisoning. From what I understand
of your description, it seems like the hardware fires off an event that
the kernel receives, and then the kernel stores the state, and hardware
"forgets" it. So what happens when something accesses the poisoned
memory anyway? Do we get another hwpoison event?

Also, what happens on cold reboot? If the HW does not remember bad
pages, won't the kernel be in the same position? How does it know the
bad pages on a cold boot?

>
> This is the case at Meta and in many hyperscalers.
>
>
> Possible solutions
> ==================
>
> 1. Do nothing (status quo). The next kernel hands out known-bad
>    RAM, and hope for the best. 
>
> 2. e820 / EFI memory map (E820_TYPE_UNUSABLE). Tempting because the
>    frame would simply never become RAM (no allocator race at all).
>    But: it is x86-only (no arm64 equivalent in the same mechanism;
>    this series is tested on arm64);
>
> 3. Firmware / platform page retirement (PPR, BMC page-offline, CXL
>    device poison lists). This is the correct layer for *cross power
>    cycle* persistence and is complementary to this work. But it is
>    per-platform, out of OS control, not universally available, and
>    cannot carry OS-discovered or software-simulated poison
>    (MADV_HWPOISON, the injector). kexec can also happen long before
>    firmware retirement takes effect.

I don't know enough about these two to say whether they are a good idea
or not. I'll let more competent people comment on that.

>
> 4. reserve_mem= / memmap= on the command line. Automatically sent reserved_mem=
>    for the next kexec kernel cmdline.

Does this scale at all? How many poisoned pages do you expect to see on
a big machine with say a few terabytes of RAM? Won't the commandline end
up being way too big?

>
> 5. A bespoke kexec segment / setup_data blob. This reinvents what
>    KHO already provides - preserved memory plus an FDT handoff to
>    the next kernel - which is the upstream-blessed generic mechanism
>    for exactly this kind of state.

Yeah, at that point you'd be better off using KHO directly. You won't
have to muck about with architecture specific bits.

>
> This PoC
> ========
>
>   * Makes hardware-poisoned pages survive a kexec, using KHO (Kexec
>     HandOver) to carry the poison list between kernels.
>
>   * Producer: hooks num_poisoned_pages_inc()/_sub() - the single
>     chokepoint for every poison/unpoison event - and records each
>     poisoned PFN into a vmalloc array that KHO preserves across the
>     kexec, described by a small versioned "hwpoison" subtree.

More of an implementation detail, but with vmalloc array, what if you
have too many poisoned pages?

We have two alternative data structures in KHO: the radix tree [0] and
KHO block [1]. I think the radix tree will be inefficient unless you
have a _lot_ of poisoned pages, but KHO block is likely going to work a
lot better because you don't have to define the buffer size up front.

>
>   * Consumer: early in the next boot (fs_initcall_sync, before the
>     buddy allocator has handed anything out) it restores that array

Why do you say so? Buddy is up and running after memblock_free_all(),
which happens from mm_core_init(), and memblock goes away entirely in
page_alloc_init_late(), which runs right after early initcalls but
before any other levels. See kernel_init_freeable().

Concrete example: hugetlb is initialized at subsys_initcall(), and
allocates all its 2M hugepages from buddy.

So I think you probably need to do this somewhere in
page_alloc_init_late(), after all the deferred struct pages are
initialized.

>     and re-runs memory_failure() on each PFN, re-offlining the frame
>     and rebuilding the full hwpoison state (PG_hwpoison, counters,
>     HardwareCorrupted).
>
>   * The replay feeds back through the producer, so the list
>     re-publishes itself and survives an arbitrary chain of kexecs.
>
>
> Open questions
> ==============
>
>   * Is there any alternative I am not seeing?
>
>   * Is a dedicated "hwpoison" subtree the right granularity, or
>     should this live under a broader RAS/KHO umbrella?

What's "RAS"?

A dedicated subtree sounds the best to me, but I think an alternate
option is to stick it into kexec-metadata. But I don't know what we'd
gain from doing so.

I _don't_ think it belongs in the base KHO ABI.

>
>   * Trusting the inherited list: should the next kernel bound the count /
>     validate PFNs against its own memory map before replaying?

Normally with KHO you assume the memory map does not change and the
previous kernel is trustworthy. You can try to do basic validation of
the memory map to ensure correctness, but I think in the end you just
_have_ to trust the previous kernel.

>
> Limitations
> ===========
>
>   * Poison events before KHO init (fs_initcall) cannot be published;
>     academic in practice as MCEs do not fire that early.
>
>   * Per-page only. Cross-power-cycle retirement of a whole DIMM
>     is not covered.
>
> I've got a PoC working, and it is available in here, in case you are interested
> in the details I am playing with
>
>   https://github.com/leitao/linux/tree/b4/hwpoison

[0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/kho_radix_tree.h
[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/kho_block.h

-- 
Regards,
Pratyush Yadav


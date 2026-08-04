Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01189C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 13:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F19E66B00DD; Tue,  4 Aug 2026 09:49:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF1676B00DE; Tue,  4 Aug 2026 09:49:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0A896B00DF; Tue,  4 Aug 2026 09:49:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ACC4B6B00DD
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 09:49:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 59655A0C2C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:32:15 +0000 (UTC)
X-FDA: 85063524630.28.661FFC1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id B7639C0007
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:32:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ordwT8pS;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785846733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U5x7PU4tajN+OzVyyExrO4LhzbuDHOH3zboIPNV375E=;
	b=cfInneziIX1gYlvhqqTnJjO3EjrDXS/MaAd93Mn66O184CXake/LjhFaVp+yqdJewSlkVR
	GE7rKJAhouFumSt5VMnfvBgXO/d9u/6iGjngWFCxtRz7SNNJF+5N3pWlLeXIJHcJKMqSkh
	rH7PEfQT204TRApLOOb/Afx0ba2D6uk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ordwT8pS;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785846733;
	b=gPt0uF9dobXDjCwjF1/E68ksZFK9+iMOFyVAgoEgS/pWCR8o/9DOG4Tl9wdQNts/JdTIBY
	G/96xxwSUqrEzWx2CaIsBvOX25xNQp9afboCt6/NFJvgURSAnXEwa4FckrR9P8dppfuGj9
	CNMvpRyYsY98k6fi1K1jQVWY49DsF3A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2135A60A59;
	Tue,  4 Aug 2026 12:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C541F000E9;
	Tue,  4 Aug 2026 12:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785846732;
	bh=U5x7PU4tajN+OzVyyExrO4LhzbuDHOH3zboIPNV375E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ordwT8pSrqM9CSvRGW3lq6NbNWUGzhBOjA6zIEqlzfZpK824FsmDGUp8FnIOWWq79
	 qmt/PstyxBInN4z+sCZ9MwWcFdvtGHgqLXcusEdEKqAZatWPkBxJxxLxD0BMerTocH
	 /vCn30tR4t+q4DrfJMbLsivqGl2A8poYVFNLk1QJR4Idml2fK73CXQc/40XeA0jhHn
	 zs4A1Z+lXzBmDGXjvLIE1aIOOLjKNPdUPOb196PZB0rf/kPooxxGuAl0F7cOqfxwKd
	 /ww5Rz9fnOjIOzV8OWT9iA3tjfuo+ohopc11d+/eBqaEMWl1n7Orsvj0sqRAziBRNf
	 p/72aXMqyxVDA==
Date: Tue, 4 Aug 2026 13:31:54 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hongru Zhang <zhanghongru06@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org, 
	liam@infradead.org, linux-kernel@vger.kernel.org, baohua@kernel.org, mhocko@suse.com, 
	rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com, vbabka@kernel.org, 
	willy@infradead.org, zhanghongru@xiaomi.com
Subject: Re: [RFC PATCH v4 1/3] mm: allow page faults to request VMA-lock
 retry
Message-ID: <anHMe4jFT9EIQe5q@lucifer>
References: <20260804095219.46213-1-zhanghongru@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804095219.46213-1-zhanghongru@xiaomi.com>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B7639C0007
X-Stat-Signature: ihsaeyk1gk6o5q7hq4k31si7ucyo9sxg
X-HE-Tag: 1785846733-323511
X-HE-Meta: U2FsdGVkX18wzgHSRJGrCIKQ6z/gJa/oLiwv199WI3VTrZO/rGV9F00ACffjboA/MNZ7xXi8DGOARtozp2Hl9gT6LAhoYlqtDXSR8VP8BLNQX5Eho7nYBgFZEx8Y3jrWe4of0i7Nwgz5icQhkrznOvZFBU1t8Boyv139MkNqHXBsa4qmOW9IzpH558W3t4ymGaTpS8ODsWmZHyBDqBl9h3BMc97GYpCSMOmi+FCfZgEDGcRY36mZL/SbATbDg3bC6MW9aGK6sGVmI0rjeC68CzZ37NtEiSmia/qIXLqHsuk+G+KLcRbe5Lgu9k2xOv+i8axatyLw+/dOEXXvFpO8v1KgPwPi9iayi7turmXesSLLUVvx7z4q+xc092VWYYwBcm39QM5QUBOnZEcpZh3vtJoX+6msCM6ts6tLbJSuBEc+Tv12N6U8aFUp5+MOW1d5Zg8zNUZCxIhYnD+2Sht3G7e+6F+Q5Diq/yNce3nh5TLBnpAltwV3964iBesZ7x96BEzAmGm1AXHFwa+EaTIslIs9/3kbd/JGpFA5Vu1STuW6zRfpwlfKQEoTgVo9TiGnqF/Biu3phSutHr/hsj9lSjYTMHI5NTmT74Juni8cTm1a3KeYstGvKHts1uB7OPWdyzXFzmYOF2JdzQO85ickU1WRKRXrQHeDe1R4LRF4rMDkrf4605rvRu3nxL/kjtzwKgwQ9MeyJ+CvGOIeqWPJNdTfYzZF3SIY9Pqj2Sxd6qllHs1WC5WF+49StzQSM6gTEgx570JJHnKxwECSunwrJAaRaMKq7QL28LX2J+S3/svmBD6r+EMHsxXC5Ch1V6pU7GTXms/Xguzt4bwEBDodHwG4i3YfljBacVXZu0siNRebr1kh8pMsj/8sDWIwUGTfLRh56a9E6iMI9J5gHF/Spkf9VQgsvp6LbiedkSJ6QVRgrSXW7VPxP+XnQP1jwRcA+dqJK3vvRfJ4ClSxrPD
 N1jv5lgJ
 yl3kWlbzfx/JkRpo5INnFJ2hFgjXsPf6S/+rvUUe4OaEaHe/VP+qNQrTK7YPb2mZfor7/aF/HYuyXd6UUVnqwpGgV9t3S33WsrJ/50/ZBhOZldlcouAjBqxqsZ4qGmN7iDcf7u6tUXuo54ScDPaD2W9W6et+rLwvV9QD2UwqEC/GqQ8AYNa+s9Xl2m1sNwWNXIpZeJZFkkas7nk3WDQCBSeXSOY/PIisFYkd2V/U/sXjm6ypNQMz7tW7K7cqUzTB0iBQgWkM8eJ7QeLDKRMObprknghpbvA/VYyM5L9nQsrSF5t70+IvFxVv23FWs5m23D00UYf/nsc1+Wfc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 05:52:19PM +0800, Hongru Zhang wrote:
> From: Hongru Zhang <zhanghongru@xiaomi.com>
>
> Page faults handled under the per-VMA lock currently fall back to the
> mmap_lock path whenever handle_mm_fault() returns VM_FAULT_RETRY. This
> means that lower-level fault handlers have no way to tell the
> architecture fault handler that the retry can safely continue under the
> per-VMA lock.
>
> Add VM_FAULT_MAY_USE_VMA_LOCK as an advisory bit that can be returned

I don't love that name or that faulting retry behaviour is _modified_ by a
value that indicates fault resolution state... ugh.

It's kinda confusing things 'VM_FAULT_RETRY' is 'you have to retry this
fault'.

'VM_FAULT_MAY_...' is starting to bring in effectively configuration
options into it and that's kinda horrible.

I mean is there any reason we shouldn't ALWAYS do this if a VMA lock was
used?

It's not too expensive to do a single retry with the VMA lock before
falling back to the mmap lock.

So maybe simplify like that?

And like that this series becomes a single patch right?

Though it seems the reticence is that you might end up waiting with the VMA
lock held.

If that's really critical then I'd drop this whole thing of referencing the
VMA flag in the name altogether, it's confusing and you're left wondering
why it's needed when the fault is already specified as allowing a VMA lock
via FAULT_FLAG_VMA_LOCK.

It's not at all clear it's _only_ for the arch-fault-handlers.

I'm curious anyway as to where this waiting is actually happening? Is the
waiting not _already_ happening with the VMA lock held on first attempt? Or
if not there then where? [ the fault code is such a mess don't really have
time to figure it out myself ].

Anyway if we _have_ to have this flag, then something that actually matches
the semantics here is better like:

	VM_FAULT_RETRY_WONT_BLOCK

Which is informational, doesn't add any confusion about the VMA flag, and
makes things a lot more self-documenting about what's going on here.

> together with VM_FAULT_RETRY. Architecture fault handlers use this bit
> to allow at most one retry under the per-VMA lock.
>
> This preserves the existing mmap_lock fallback behaviour for fault
> handlers that continue to return VM_FAULT_RETRY without
> VM_FAULT_MAY_USE_VMA_LOCK: major retries still enter the mmap_lock path
> with FAULT_FLAG_TRIED set, while minor retries still enter it as a fresh
> first attempt.

Yup this was a concern I think I raised in a previous version that you'd
get infinite VMA lock retries.

>
> The difference is limited to fault handlers that return VM_FAULT_RETRY
> with VM_FAULT_MAY_USE_VMA_LOCK. For them, both major and minor retries
> enter the VMA-lock retry with FAULT_FLAG_TRIED set. For major faults
> this follows the existing mmap_lock retry handling, but the retried
> fault runs under the VMA lock rather than the mmap_lock. For minor
> faults this replaces the fresh mmap_lock retry with a VMA-lock retry
> that has FAULT_FLAG_TRIED set. This can avoid an extra retry round for
> short waits. The cost is that a retried fault that blocks for an extended
> period may wait while holding the VMA lock. Fault handlers should return

Where does it wait?

> VM_FAULT_RETRY with VM_FAULT_MAY_USE_VMA_LOCK when that tradeoff is
> preferable to falling back to mmap_lock immediately.

This sentence is completely unreadable :) Too. Many. Words.

It's really hard to follow too. Was this AI-generated? Totally understand
if it's to help with prose in general but what we end up with really does
have to be clear.

Something like:

	Minor faults are retried indefinitely with the mmap lock held,
	which guarantees some forward progress, however this isn't the case
	with VMA locks, so set FAULT_FLAG_TRIED for minor faults if the VMA
	lock is used.

	< discussions of tradeoff, where the waiting actually happens >

Maybe?

>
> No current code sets VM_FAULT_MAY_USE_VMA_LOCK yet; this patch only
> prepares the retry plumbing for later users.
>
> No functional change is intended.
>
> Signed-off-by: Hongru Zhang <zhanghongru@xiaomi.com>
> Suggested-by: Barry Song <baohua@kernel.org>
> Suggested-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  arch/arm/mm/fault.c       |  6 ++++--
>  arch/arm64/mm/fault.c     |  7 +++++--
>  arch/loongarch/mm/fault.c |  6 ++++--
>  arch/powerpc/mm/fault.c   |  6 ++++--
>  arch/riscv/mm/fault.c     |  6 ++++--
>  arch/s390/mm/fault.c      |  5 +++--
>  arch/x86/mm/fault.c       |  6 ++++--

Really badly need that code to separate out fault handling code. Matthew?
:) Or perhaps he's waiting on this to land first...

It does seem that these are the arches that use VMA locks though.

Suren - is there any reason we shouldn't just enable VMA locks for every
CONFIG_MMU arch now it's headed for being default-enabled?


>  include/linux/mm.h        | 28 ++++++++++++++++++++++++++++
>  include/linux/mm_types.h  |  4 ++++
>  9 files changed, 60 insertions(+), 14 deletions(-)
>
> diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
> index e62cc4be5adf..158923b70901 100644
> --- a/arch/arm/mm/fault.c
> +++ b/arch/arm/mm/fault.c
> @@ -391,6 +391,7 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>  	if (!(flags & FAULT_FLAG_USER))
>  		goto lock_mmap;
>
> +retry_vma:
>  	vma = lock_vma_under_rcu(mm, addr);
>  	if (!vma)
>  		goto lock_mmap;
> @@ -411,8 +412,6 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>  		goto done;
>  	}
>  	count_vm_vma_lock_event(VMA_LOCK_RETRY);
> -	if (fault & VM_FAULT_MAJOR)
> -		flags |= FAULT_FLAG_TRIED;
>
>  	/* Quick path to respond to signals */
>  	if (fault_signal_pending(fault, regs)) {
> @@ -420,6 +419,9 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>  			goto no_context;
>  		return 0;
>  	}
> +
> +	if (fault_should_retry_under_vma_lock(fault, &flags))
> +		goto retry_vma;
>  lock_mmap:
>
>  retry:
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 0b52557652be..b17986b40ac3 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -678,6 +678,7 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
>  	if (!(mm_flags & FAULT_FLAG_USER))
>  		goto lock_mmap;
>
> +retry_vma:
>  	vma = lock_vma_under_rcu(mm, addr);
>  	if (!vma)
>  		goto lock_mmap;
> @@ -715,8 +716,6 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
>  		goto done;
>  	}
>  	count_vm_vma_lock_event(VMA_LOCK_RETRY);
> -	if (fault & VM_FAULT_MAJOR)
> -		mm_flags |= FAULT_FLAG_TRIED;
>
>  	/* Quick path to respond to signals */
>  	if (fault_signal_pending(fault, regs)) {
> @@ -724,6 +723,10 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
>  			goto no_context;
>  		return 0;
>  	}
> +
> +	if (fault_should_retry_under_vma_lock(fault, &mm_flags))
> +		goto retry_vma;
> +
>  lock_mmap:
>
>  retry:
> diff --git a/arch/loongarch/mm/fault.c b/arch/loongarch/mm/fault.c
> index 2c93d33356e5..6a946838b54b 100644
> --- a/arch/loongarch/mm/fault.c
> +++ b/arch/loongarch/mm/fault.c
> @@ -219,6 +219,7 @@ static void __kprobes __do_page_fault(struct pt_regs *regs,
>  	if (!(flags & FAULT_FLAG_USER))
>  		goto lock_mmap;
>
> +retry_vma:
>  	vma = lock_vma_under_rcu(mm, address);
>  	if (!vma)
>  		goto lock_mmap;
> @@ -256,8 +257,6 @@ static void __kprobes __do_page_fault(struct pt_regs *regs,
>  	}
>
>  	count_vm_vma_lock_event(VMA_LOCK_RETRY);
> -	if (fault & VM_FAULT_MAJOR)
> -		flags |= FAULT_FLAG_TRIED;
>
>  	/* Quick path to respond to signals */
>  	if (fault_signal_pending(fault, regs)) {
> @@ -265,6 +264,9 @@ static void __kprobes __do_page_fault(struct pt_regs *regs,
>  			no_context(regs, write, address);
>  		return;
>  	}
> +
> +	if (fault_should_retry_under_vma_lock(fault, &flags))
> +		goto retry_vma;
>  lock_mmap:
>
>  retry:
> diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
> index 806c74e0d5ab..e2a128fba408 100644
> --- a/arch/powerpc/mm/fault.c
> +++ b/arch/powerpc/mm/fault.c
> @@ -487,6 +487,7 @@ static int ___do_page_fault(struct pt_regs *regs, unsigned long address,
>  	if (!(flags & FAULT_FLAG_USER))
>  		goto lock_mmap;
>
> +retry_vma:
>  	vma = lock_vma_under_rcu(mm, address);
>  	if (!vma)
>  		goto lock_mmap;
> @@ -511,12 +512,13 @@ static int ___do_page_fault(struct pt_regs *regs, unsigned long address,
>  		goto done;
>  	}
>  	count_vm_vma_lock_event(VMA_LOCK_RETRY);
> -	if (fault & VM_FAULT_MAJOR)
> -		flags |= FAULT_FLAG_TRIED;
>
>  	if (fault_signal_pending(fault, regs))
>  		return user_mode(regs) ? 0 : SIGBUS;
>
> +	if (fault_should_retry_under_vma_lock(fault, &flags))
> +		goto retry_vma;
> +
>  lock_mmap:
>
>  	/* When running in the kernel we expect faults to occur only to
> diff --git a/arch/riscv/mm/fault.c b/arch/riscv/mm/fault.c
> index 04ed6f8acae4..87b061feba51 100644
> --- a/arch/riscv/mm/fault.c
> +++ b/arch/riscv/mm/fault.c
> @@ -347,6 +347,7 @@ void handle_page_fault(struct pt_regs *regs)
>  	if (!(flags & FAULT_FLAG_USER))
>  		goto lock_mmap;
>
> +retry_vma:
>  	vma = lock_vma_under_rcu(mm, addr);
>  	if (!vma)
>  		goto lock_mmap;
> @@ -368,14 +369,15 @@ void handle_page_fault(struct pt_regs *regs)
>  		goto done;
>  	}
>  	count_vm_vma_lock_event(VMA_LOCK_RETRY);
> -	if (fault & VM_FAULT_MAJOR)
> -		flags |= FAULT_FLAG_TRIED;
>
>  	if (fault_signal_pending(fault, regs)) {
>  		if (!user_mode(regs))
>  			no_context(regs, addr);
>  		return;
>  	}
> +
> +	if (fault_should_retry_under_vma_lock(fault, &flags))
> +		goto retry_vma;
>  lock_mmap:
>
>  retry:
> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index 028aeb9c48d6..8e90e522436b 100644
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -294,6 +294,7 @@ static void do_exception(struct pt_regs *regs, int access)
>  		flags |= FAULT_FLAG_WRITE;
>  	if (!(flags & FAULT_FLAG_USER))
>  		goto lock_mmap;
> +retry_vma:
>  	vma = lock_vma_under_rcu(mm, address);
>  	if (!vma)
>  		goto lock_mmap;
> @@ -310,14 +311,14 @@ static void do_exception(struct pt_regs *regs, int access)
>  		goto done;
>  	}
>  	count_vm_vma_lock_event(VMA_LOCK_RETRY);
> -	if (fault & VM_FAULT_MAJOR)
> -		flags |= FAULT_FLAG_TRIED;
>  	/* Quick path to respond to signals */
>  	if (fault_signal_pending(fault, regs)) {
>  		if (!user_mode(regs))
>  			handle_fault_error_nolock(regs, 0);
>  		return;
>  	}
> +	if (fault_should_retry_under_vma_lock(fault, &flags))
> +		goto retry_vma;
>  lock_mmap:
>  retry:
>  	vma = lock_mm_and_find_vma(mm, address, regs);
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 45b99c3b1442..53c8f003fe53 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -1331,6 +1331,7 @@ void do_user_addr_fault(struct pt_regs *regs,
>  	if (!(flags & FAULT_FLAG_USER))
>  		goto lock_mmap;
>
> +retry_vma:
>  	vma = lock_vma_under_rcu(mm, address);
>  	if (!vma)
>  		goto lock_mmap;
> @@ -1349,8 +1350,6 @@ void do_user_addr_fault(struct pt_regs *regs,
>  		goto done;
>  	}
>  	count_vm_vma_lock_event(VMA_LOCK_RETRY);
> -	if (fault & VM_FAULT_MAJOR)
> -		flags |= FAULT_FLAG_TRIED;
>
>  	/* Quick path to respond to signals */
>  	if (fault_signal_pending(fault, regs)) {
> @@ -1360,6 +1359,9 @@ void do_user_addr_fault(struct pt_regs *regs,
>  						 ARCH_DEFAULT_PKEY);
>  		return;
>  	}
> +
> +	if (fault_should_retry_under_vma_lock(fault, &flags))
> +		goto retry_vma;
>  lock_mmap:
>
>  retry:
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 7fabe6c66b4b..27ec6673acfe 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -727,6 +727,34 @@ static inline bool fault_flag_allow_retry_first(enum fault_flag flags)
>  	    (!(flags & FAULT_FLAG_TRIED));
>  }
>
> +/**
> + * fault_should_retry_under_vma_lock - decide whether to retry with VMA lock
> + * @fault: fault result from handle_mm_fault() under FAULT_FLAG_VMA_LOCK
> + * @flags: fault flags for the current fault, updated on retry
> + *
> + * Architecture page fault handlers call this after a VMA-lock fault returns
> + * VM_FAULT_RETRY. If the fault result also has VM_FAULT_MAY_USE_VMA_LOCK,
> + * allow one bounded retry under the VMA lock and set FAULT_FLAG_TRIED.
> + *
> + * When the fault must fall back to the mmap_lock path, preserve the existing
> + * VM_FAULT_MAJOR behavior by marking FAULT_FLAG_TRIED before the retry.
> + *
> + * Return: true if the caller should retry under the VMA lock, false if it

Oh good half of the kdoc comments in mm.h have Return and the other half have
Returns: :)) OK I guess Return is fine here.

> + * should fall back to the mmap_lock fault path.
> + */
> +static inline bool fault_should_retry_under_vma_lock(vm_fault_t fault, unsigned int *flags)
> +{
> +	if ((fault & VM_FAULT_MAY_USE_VMA_LOCK) && !(*flags & FAULT_FLAG_TRIED)) {
> +		*flags |= FAULT_FLAG_TRIED;
> +		return true;
> +	}
> +
> +	if (fault & VM_FAULT_MAJOR)
> +		*flags |= FAULT_FLAG_TRIED;
> +
> +	return false;
> +}

I really hate this function. It's not doing what it says it is (it's
modifying fault behaviour too via the flags parameter AND setting state for
major faults), it's combining VMA fault path handling AND mmap major fault
handling it's doing ugly horrors with an output parameter.

I think it's better just as a straight-up predicate. Yes there'll be
duplication on setting FAULT_FLAG_TRIED. It sucks, but you're _already_
duplicating every single invocation and goto anyway.

The fix for that is finally de-duplicating the arch fault code properly.

So it'd be like:

	< kdoc etc. >
	static inline bool should_retry_fault_under_vma_lock(vm_fault fault_type,
			unsigned int flags)
	{
		/* Don't wait holding the VMA lock. */
		if (!(fault_type & VM_FAULT_RETRY_WONT_BLOCK))
			return false;
		/* Already retried the fault under the VMA lock. */
		if (flags & FAULT_FLAG_TRIED)
			return false;
		return true;
	}


-	if (fault_should_retry_under_vma_lock(fault, &flags))
-		goto retry_vma;
+	if (should_retry_fault_under_vma_lock(fault, flags)) {
+		flags |= FAULT_FLAG_TRIED;
+		goto retry_vma;
+	}
+
+	if (fault & VM_FAULT_MAJOR)
+		flags |= FAULT_FLAG_TRIED;

This way also you explicitly see where FAULT_FLAG_TRIED is set.

> +
>  #define FAULT_FLAG_TRACE \
>  	{ FAULT_FLAG_WRITE,		"WRITE" }, \
>  	{ FAULT_FLAG_MKWRITE,		"MKWRITE" }, \
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index b5d4cd3b067b..46a832757109 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1684,6 +1684,8 @@ typedef __bitwise unsigned int vm_fault_t;
>   * @VM_FAULT_NOPAGE:		->fault installed the pte, not return page
>   * @VM_FAULT_LOCKED:		->fault locked the returned page
>   * @VM_FAULT_RETRY:		->fault blocked, must retry
> + * @VM_FAULT_MAY_USE_VMA_LOCK:	->fault blocked, retry may be handled under
> + *				the VMA lock
>   * @VM_FAULT_FALLBACK:		huge page fault failed, fall back to small
>   * @VM_FAULT_DONE_COW:		->fault has fully handled COW
>   * @VM_FAULT_NEEDDSYNC:		->fault did not modify page tables and needs
> @@ -1707,6 +1709,7 @@ enum vm_fault_reason {
>  	VM_FAULT_DONE_COW       = (__force vm_fault_t)0x001000,
>  	VM_FAULT_NEEDDSYNC      = (__force vm_fault_t)0x002000,
>  	VM_FAULT_COMPLETED      = (__force vm_fault_t)0x004000,
> +	VM_FAULT_MAY_USE_VMA_LOCK = (__force vm_fault_t)0x008000,
>  	VM_FAULT_HINDEX_MASK    = (__force vm_fault_t)0x0f0000,
>  };
>
> @@ -1731,6 +1734,7 @@ enum vm_fault_reason {
>  	{ VM_FAULT_FALLBACK,            "FALLBACK" },	\
>  	{ VM_FAULT_DONE_COW,            "DONE_COW" },	\
>  	{ VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" },	\
> +	{ VM_FAULT_MAY_USE_VMA_LOCK,    "MAY_USE_VMA_LOCK" },	\

This makes the naming confusion even worse - because now we have
FAULT_FLAG_VMA_LOCK and this which 'specifies' may use VMA lock whereas
really it means 'may use once on retry'...

So again, as per above, I think it's better to actually have this
communicate the _reason_ why it seems OK to use the VMA lock on retry
rather than actually specifying that the caller should.

>  	{ VM_FAULT_COMPLETED,           "COMPLETED" }
>
>  struct vm_special_mapping {
> --
> 2.43.0
>

BTW in sanitize_fault_flags() there's:

	/*
	 * Per-VMA locks can't be used with FAULT_FLAG_RETRY_NOWAIT because of
	 * the assumption that lock is dropped on VM_FAULT_RETRY.
	 */
	if (WARN_ON_ONCE((*flags &
			(FAULT_FLAG_VMA_LOCK | FAULT_FLAG_RETRY_NOWAIT)) ==
			(FAULT_FLAG_VMA_LOCK | FAULT_FLAG_RETRY_NOWAIT)))
		return VM_FAULT_SIGSEGV;

Except now VM_FAULT_RETRY doesn't drop the lock :) I think the comment
needs to be updated to say 'dropped on VM_FAULT_RETRY after one attempt'.

Also I think there's an issue with major/minor fault counting as a result
of this, in mm_account_fault():

	/*
	 * We define the fault as a major fault when the final successful fault
	 * is VM_FAULT_MAJOR, or if it retried (which implies that we couldn't
	 * handle it immediately previously).
	 */
	major = (ret & VM_FAULT_MAJOR) || (flags & FAULT_FLAG_TRIED);

	if (major)
		current->maj_flt++;
	else
		current->min_flt++;

Now you're getting minor faults being counted as major ones?

If intended, that's a user-visible change that should be documented and
defended in the commit msg.

If not, you could do some REALLY gross checks making things _even more
complicated_ here.

But maybe something like:

	< kdoc comment etc. >
	static bool is_major_fault(vm_fault_t fault_type, unsigned int fault_flags)
	{
		/* Explicitly marked as major. */
		if (fault_type & VM_FAULT_MAJOR)
			return true;
		/* If no retry occurred, minor. */
		if (!(fault_flags & FAULT_FLAG_TRIED))
			return false;
		/* Quickly retrying fault under the VMA lock implies minor. */
		return !(fault_flags & FAULT_FLAG_VMA_LOCK);
	}

	Then the code above becomes:

	if (is_major_fault(ret, flags))
		current->maj_flt++;
	else
		current->min_flt++;

--
Cheers, Lorenzo


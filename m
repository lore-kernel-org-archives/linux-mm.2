Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AF41C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 16:52:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB3D36B009D; Tue,  7 Jul 2026 12:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D64D36B009E; Tue,  7 Jul 2026 12:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C53796B009F; Tue,  7 Jul 2026 12:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 906B56B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:52:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20AC7A04EE
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:52:45 +0000 (UTC)
X-FDA: 84962574690.20.7473E12
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 741F914000E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:52:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OH2QxANL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783443163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qk//09EtIPajv3gERjiseYeNxcnN5wsTH51V+MfmwU0=;
	b=3O8yckSI4dhnNW5UY9P2lQ+UxwuaIAhZt3B6mpOvKTkMWk/l2fdQwPgjSr6ehLn2UBOa0q
	BlFa5A/W7vyZogLmzbg6Va4Ksd4xOeBw8lIT8f9cFdX9/SY0cz6I1N96zfDZdnIX4iWJ2r
	9jjpXisU6XOOTlZbCra2zjYpGVBxKes=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OH2QxANL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783443163;
	b=svqq4nrwAmk7+Ke75XCx2IAY2Xh9llt0wbWSSdgl0WjqzB5rZLW7vcwTNcPkkFyF7gDPa6
	uPTzPrfwa5ITDBdIE94v67OHZJMQDR3FZ1k2KJlK6GMZCBKB9bwvWPP8n0CDi0szh/aQSB
	iQqWmedVJK25D2kScX/5xZH03LzOcfU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B6DAA600FF;
	Tue,  7 Jul 2026 16:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A13B1F000E9;
	Tue,  7 Jul 2026 16:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783443162;
	bh=Qk//09EtIPajv3gERjiseYeNxcnN5wsTH51V+MfmwU0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OH2QxANLH488i0P0fzQaQR9NVvqArl9H7O1rDpZpeFsgoJTilKR2doHMHjv2yAUb3
	 6B7egqO4o1tVnr+/h4/sYPb4Lj3GmsuswBxccfd8hTl8OyZJPUWtNXr1UoVUjjYbHv
	 HSYJ5x9KB6cKLoTINlqAPUixqL6zUQ8pT6aUTzDcy3NPp7WxtzBFRiLFYZOneIbt5G
	 6YSAxHhM0hMZnNl7sP5gp0b+LVIkGHR/P3tvwHtQr1Xs9o5YUiXeIs0nHfa12swHpB
	 zasSbJ2ZxBp+pL/GGGIBNBEsr4WPfYSVVVoeRXhL75V5e56u6VGmtk+YBQTPyGlbox
	 19Jic1cyv/UDQ==
Date: Tue, 7 Jul 2026 17:52:31 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Hongru Zhang <zhanghongru06@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, baohua@kernel.org, shakeel.butt@linux.dev, 
	linux-kernel@vger.kernel.org, Hongru Zhang <zhanghongru@xiaomi.com>, willy@infradead.org
Subject: Re: [RFC PATCH v3] mm: retry page faults under per-VMA lock when
 mmap_lock is not required
Message-ID: <ak0Xl6q52exX9sBH@lucifer>
References: <20260626075019.1833065-1-zhanghongru@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626075019.1833065-1-zhanghongru@xiaomi.com>
X-Rspamd-Queue-Id: 741F914000E
X-Stat-Signature: 3papp6e4895x8osm5go3hou34xsfdseb
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783443163-332537
X-HE-Meta: U2FsdGVkX1+4IpA+6ntRwV7sjPVWF6AGhNz+SU082E7QZzRtMGbiO25/nwPzsdtEpUoAiIwiFdrqJInPWBchmCKDEq/wU/odg3OCvL/DP0yBHTDwKTI6hltdf4aLA0SFduBXnDeajCv5Is4tKvjNlSAwNg+gzULu/eCeGc+d23F3ortCiDV0Vq6I8Gs/gx08Dh9peBRf7RBd240VGMKy7O7nlhPTV5jSLuhsqTibaWZpvJGaLyI21KVe7MXJzxRtx94xddP9OBXauDxylWvMHsKBf2Lsy8BDecB5no1IJ8rZX7OoopHWAp28a3dJZgHVq0VRTpnK0ziTj40FP9kuPek/1PQrCUJAK60lLR6ggZm8FGxeSSKYu2G6ipKc5nikY6FSY6WVgYJHWNLP0pH3eDY44e1k2SyVHImtxc74T6EBkN/SS41cYLAcEeiX0b+f9L7rPD0Km1xA0MxxxY8Ld6kmN3eo3qOItPQPDbrBHGiVSav65YCwdtoHzYHLiOcm+ZrUBgzuHjVTsv3zxARnE79UTzSK9WSO5FNtAPeXJ7vJJk2xifLsY0NZ8MdVsm7XbvyyWddUw0d8yVhjYhMZLuAUP8WFUGrqUA1PTMYpOv68ubWEQ8Qc0MU9IV2j3toSm4QwUaFJgx6vHTFXEuhed/kmSakrOq6yMdjHUK+MErVZ9DK4AmHENOaGyueWZnKpIw+e3zX6sdX8qWVK9pEZcgddwppSGiPuKE+CZpfdA/If3uEPnvVtZD+uoF4R7WYdyPDHTL6Jr9Cw3RTwYoyWkfQlEFXyENlnfN5fis20eKCJrN5O1YzrUKE+P3OhLuQMUeREiR0GNHryoeYIwzjizBxUgBm0h++q1TxWN+Ehv1C18yYfTgDuiw89DImpw7ig+UbwHJvyVWCozse6PyHnB5WzVtkAneq2cFinYjdYFjOVWGKWw19/WJBYpQIui2N613SiVIOzzLd1uNULAwt
 PNvitSsT
 lzphpIlNpLjz5+vGGGHQviGZ0ddQXIt09B2VdkARPmxF4JF8yzbT3lk8oWPko0OYu+maXKyGevh4ehGBo/Sq1wJI599O8Y/yETTU21qzq5qDRk4qrFp9ZZkwqdLT8TWilOBItNK48nPuT59D4wHu2O1pdyXMNKfN3ZjldpEVZR7Ad4VuAsbMtr9306EDyb9RGdYfJUTq7IWeqY6ZcGAOtnj/hQqu+x9M9h+Ai0Uq955hWNDt6Z6zO8Ov2fWVBs+n6Acj4y4tsgUb9rtQs8+h/Ph4Bert1guEkZcdMSx3NUf12Z2mIx9lAKTBC+8mjG5QuZq/is38mYMObroNlY/8yp4Mb5kcoAYpikn8lyZVYNIIrWazSFNPfu/VzkZzE0zzNndqZdXi/ig0zTlPPVyVFmWbRwK8dFbeAfXSN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Vlata, the only one from the MEMORY MAPPING - LOCKING people excluded,
and Willy as he's been heavily involved. But see below you need to cc- way
more.

(nitty I know) Maybe subject should be 'mm: default to VMA lock on
VM_FAULT_RETRY' or something just to make it clear it's about the retry
path?

Also I guess you and Barry agreed to you taking this over? :)

You missed a million people from cc- by the way. This time I really cannot
be bothered to add them all as I usually do, but it is MANDATORY to cc
maintainers and really you should be cc'ing reviewers too every time.

Again I feel I need to write a bot that just autoreplies about this :)

$ scripts/get_maintainer.pl --nogit --nogit-fallback your-patch.patch
<... ~36 people in total ...>
< lists >
< etc. >

Please fix this on respin.

On Fri, Jun 26, 2026 at 03:50:19PM +0800, Hongru Zhang wrote:
> From: Hongru Zhang <zhanghongru@xiaomi.com>
>
> Currently, when a page fault returns VM_FAULT_RETRY under the per-VMA
> lock due to folio_lock() failing, mainly because the folio is under
> I/O, the architecture fault handler unconditionally falls back to
> retrying with mmap_lock. This leads to mmap_lock contention.
>
> This patch introduces VM_FAULT_RETRY_HARD to mark the paths that

I'm going to have to bikeshed the name :)

While I like the idea of 'retry hard' like the movie 'die hard' :P I think,
since this is explicitly about the mmap lock, we should reference that?

So maybe VM_FAULT_RETRY_MMAP?

or VM_FAULT_RETRY_HARDER_WITH_A_VENGEANCE? ;)

> require mmap_lock. Retries now stay under the per-VMA lock by default,
> and only marked paths fall back to the mmap_lock retry path.

I think the commit message should be much clearer about the logic here.

You are making it such that VM_FAULT_RETRY does its retry pass using a VMA
lock, but it retains the same 'retry and set FAULT_FLAG_TRIED' logic as
before.

HOWEVER.

On the VMA lock path the retry flag is only set if VM_FAULT_MAJOR. So now
you're allowing _unbounded_ VMA lock attempts (which is concerning and I
don't think intended by the lock code).

None of this is clear right now, you need to documment it.

>
> Based on the stress model from Kunwu Chan and Wang Lian in v2, we
> adapted a benchmark for a 20-core desktop environment (reduced thread
> count, adjusted memcg limits, 20-core Intel i7-12700). The benchmark
> uses concurrent page faults under memcg pressure (forcing reclaim and
> VM_FAULT_RETRY) with parallel munmap to amplify mmap_lock read-write
> contention.
>
> Throughput (higher is better):
> +---------+------------+------------+-------------+
> | Threads |  Vanilla   |  Patched   | Improvement |
> +---------+------------+------------+-------------+
> |   40    | 1071.11 /s | 1301.11 /s |   +21.5%    |
> +---------+------------+------------+-------------+
> |   60    | 1043.15 /s | 1472.36 /s |   +41.1%    |
> +---------+------------+------------+-------------+
> |   80    | 1049.39 /s | 1665.65 /s |   +58.7%    |
> +---------+------------+------------+-------------+
>
> mmap_lock contention count (lower is better):
> +---------+-----------+---------+-----------+
> | Threads |  Vanilla  | Patched | Reduction |
> +---------+-----------+---------+-----------+
> |   40    | 3,217,904 |  51,201 |  -98.4%   |
> +---------+-----------+---------+-----------+
> |   60    | 4,419,149 |  55,711 |  -98.7%   |
> +---------+-----------+---------+-----------+
> |   80    | 5,395,730 |  66,184 |  -98.8%   |
> +---------+-----------+---------+-----------+

Yeah I worry a bit about the unbounded nature of things here, the fact
we're seeing such a difference could also be offset by extreme busy waiting
with the unbounded VMA lock retries.

Let's experiment based on limiting this surely?

>
> Benchmark and test scripts:
> https://gist.github.com/zhr250/c36c2c54d9351df37e12fd072d4926ef
>
> Suggested-by: Barry Song <baohua@kernel.org>
> Suggested-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Hongru Zhang <zhanghongru@xiaomi.com>
> ---
> Changes since v2:
> - v2 required each retry path to explicitly opt in to VMA lock retry
>   (VM_FAULT_RETRY_VMA). This patch inverts the logic: retries default
>   to VMA lock, and only paths requiring mmap_lock opt out
>   (VM_FAULT_RETRY_HARD)
> - This patch corresponds to v2 patch 1/5; the remaining optimizations
>   will be submitted separately
> - Rebased on mm-unstable
>
> Link to v2:
> https://lore.kernel.org/all/20260430040427.4672-1-baohua@kernel.org/
>
> Link to v1:
> https://lore.kernel.org/all/20251127011438.6918-1-21cnbao@gmail.com/

Hmm it's a bit odd for you to send an independent series and link to
somebody else's series as v1/v2 but anyway as long as Barry and you agree
with that approach that's fine!

>
>  arch/arm/mm/fault.c       | 4 ++++
>  arch/arm64/mm/fault.c     | 4 ++++
>  arch/loongarch/mm/fault.c | 4 ++++
>  arch/powerpc/mm/fault.c   | 4 ++++
>  arch/riscv/mm/fault.c     | 4 ++++
>  arch/s390/mm/fault.c      | 4 ++++
>  arch/x86/mm/fault.c       | 4 ++++
>  include/linux/mm_types.h  | 9 +++++----
>  mm/huge_memory.c          | 2 +-
>  mm/memory.c               | 6 +++---
>  10 files changed, 37 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
> index e62cc4be5adf..2f909fb4f7db 100644
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
> @@ -420,6 +421,9 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>  			goto no_context;
>  		return 0;
>  	}

OK so this is really important - and it seems to be the case regardless of
arch.

When VM_FAULT_RETRY is encountered under the VMA lock, we do:

	if (fault & VM_FAULT_MAJOR)
		flags |= FAULT_FLAG_TRIED;

Which then allows _under the mmap lock_ 2 more retries.

You're now (silently!) going to:

	if (!(fault & VM_FAULT_MAJOR))
		/* unbounded infinite VMA lock retries */

This seems very unwise (TM).

We should bound this somehow. A maximum number of retries? Only do the
minor fault thing once?

Could you benchmark how it looks at different retry counts? We could also
consider other strategies, but unbounded attempts here seems not good.

Another thing - is there any way to dedupe this code...? We're open coding
a lot of crap now in each of the arches and it's not good.

A series like this is the place to fix stuff like that, not keep adding to
the technical debt.

Hongru - could you see if that's possible as preceeding patches please?

> +	if (!(fault & VM_FAULT_RETRY_HARD))
> +		goto retry_vma;

Maybe it's worth being explicit that this is the VM_FAULT_RETRY path? Otherwise
it's not so clear.

You happen to only fall through here if VM_FAULT_RETRY is set.

So e.g.:

/**
 * fault_can_retry_vma_lock() - Are we able to retry a page fault holding
 * only the VMA lock?
 * @fault: The fault to check.
 *
 * We default to performing the VM_FAULT_RETRY/FAULT_FLAG_TRIED dance under
 * VMA lock. This allows us to avoid mmap contention on the likely case
 * that we encountered an ephemeral inability to VMA lock (e.g. the VMA was
 * write locked at the time).
 *
 * Returns: true if we can retry under the VMA lock, false otherwise.
 */
static bool fault_can_retry_vma_lock(vm_fault_t fault)
{
	VM_WARN_ON_ONCE(!(fault & VM_FAULT_RETRY));

	return fault & VM_FAULT_RETRY_HARD;
}

And put that somewhere all the arch fault logic can access.

Then:

	if (fault_can_retry_vma_lock(fault))
		goto retry_vma;

Is self-documenting, and the assert assures that no mistake was made with
it.

Same comments for all the arches, obviously.

> +
>  lock_mmap:
>
>  retry:
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 739800835920..695a09486795 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -673,6 +673,7 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
>  	if (!(mm_flags & FAULT_FLAG_USER))
>  		goto lock_mmap;
>
> +retry_vma:
>  	vma = lock_vma_under_rcu(mm, addr);
>  	if (!vma)
>  		goto lock_mmap;
> @@ -719,6 +720,9 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
>  			goto no_context;
>  		return 0;
>  	}
> +	if (!(fault & VM_FAULT_RETRY_HARD))
> +		goto retry_vma;
> +
>  lock_mmap:
>
>  retry:
> diff --git a/arch/loongarch/mm/fault.c b/arch/loongarch/mm/fault.c
> index 2c93d33356e5..d7dd55722e52 100644
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
> @@ -265,6 +266,9 @@ static void __kprobes __do_page_fault(struct pt_regs *regs,
>  			no_context(regs, write, address);
>  		return;
>  	}
> +	if (!(fault & VM_FAULT_RETRY_HARD))
> +		goto retry_vma;
> +
>  lock_mmap:
>
>  retry:
> diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
> index 806c74e0d5ab..65ec9a8252e7 100644
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
> @@ -517,6 +518,9 @@ static int ___do_page_fault(struct pt_regs *regs, unsigned long address,
>  	if (fault_signal_pending(fault, regs))
>  		return user_mode(regs) ? 0 : SIGBUS;
>
> +	if (!(fault & VM_FAULT_RETRY_HARD))
> +		goto retry_vma;
> +
>  lock_mmap:
>
>  	/* When running in the kernel we expect faults to occur only to
> diff --git a/arch/riscv/mm/fault.c b/arch/riscv/mm/fault.c
> index 04ed6f8acae4..6c68414a1224 100644
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
> @@ -376,6 +377,9 @@ void handle_page_fault(struct pt_regs *regs)
>  			no_context(regs, addr);
>  		return;
>  	}
> +	if (!(fault & VM_FAULT_RETRY_HARD))
> +		goto retry_vma;
> +
>  lock_mmap:
>
>  retry:
> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index 028aeb9c48d6..45a6c35044cc 100644
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
> @@ -318,6 +319,9 @@ static void do_exception(struct pt_regs *regs, int access)
>  			handle_fault_error_nolock(regs, 0);
>  		return;
>  	}
> +	if (!(fault & VM_FAULT_RETRY_HARD))
> +		goto retry_vma;
> +
>  lock_mmap:
>  retry:
>  	vma = lock_mm_and_find_vma(mm, address, regs);
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 63de8e8684f2..cb80070271d0 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -1322,6 +1322,7 @@ void do_user_addr_fault(struct pt_regs *regs,
>  	if (!(flags & FAULT_FLAG_USER))
>  		goto lock_mmap;
>
> +retry_vma:
>  	vma = lock_vma_under_rcu(mm, address);
>  	if (!vma)
>  		goto lock_mmap;
> @@ -1351,6 +1352,9 @@ void do_user_addr_fault(struct pt_regs *regs,
>  						 ARCH_DEFAULT_PKEY);
>  		return;
>  	}
> +	if (!(fault & VM_FAULT_RETRY_HARD))
> +		goto retry_vma;
> +
>  lock_mmap:
>
>  retry:
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 5ef78617ce93..58db6f0af6fd 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h

Please also update the comment block to add the new flag.

> @@ -1665,10 +1665,11 @@ enum vm_fault_reason {
>  	VM_FAULT_NOPAGE         = (__force vm_fault_t)0x000100,
>  	VM_FAULT_LOCKED         = (__force vm_fault_t)0x000200,
>  	VM_FAULT_RETRY          = (__force vm_fault_t)0x000400,
> -	VM_FAULT_FALLBACK       = (__force vm_fault_t)0x000800,
> -	VM_FAULT_DONE_COW       = (__force vm_fault_t)0x001000,
> -	VM_FAULT_NEEDDSYNC      = (__force vm_fault_t)0x002000,
> -	VM_FAULT_COMPLETED      = (__force vm_fault_t)0x004000,
> +	VM_FAULT_RETRY_HARD     = (__force vm_fault_t)0x000800,
> +	VM_FAULT_FALLBACK       = (__force vm_fault_t)0x001000,
> +	VM_FAULT_DONE_COW       = (__force vm_fault_t)0x002000,
> +	VM_FAULT_NEEDDSYNC      = (__force vm_fault_t)0x004000,
> +	VM_FAULT_COMPLETED      = (__force vm_fault_t)0x008000,

Hmm I suppose there's no harm in renumbering here to keep the retries
together :)

I wonder if we shouldn't invert this VM_FAULT_RETRY | VM_FAULT_RETRY_HARD
thing though and instead have:

#define VM_FAULT_RETRY_MASK (VM_FAULT_RETRY | VM_FAULT_RETRY_MMAP)

And convert code that checks VM_FAULT_RETRY to check VM_FAULT_RETRY_MASK
instead, then there'd be no need for an awkward check/or confusion around
the need for VM_FAULT_RETRY to always be set in both cases.

You're already basically touching all the files that reference
VM_FAULT_RETRY so it's not actually much more churn.

>  	VM_FAULT_HINDEX_MASK    = (__force vm_fault_t)0x0f0000,
>  };
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 94bd656eeaf8..ad0129d579bc 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1398,7 +1398,7 @@ vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf)
>
>  	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
>  		vma_end_read(vma);
> -		return VM_FAULT_RETRY;
> +		return VM_FAULT_RETRY | VM_FAULT_RETRY_HARD;

Why are we specifically wanting this for PMD device private entries?

You should add a comment, and the commit message should say why.

Actually, maybe in this common case of vmf->flags & FAULT_FLAG_VMA_LOCK ->
harder you can make a helper?

Like:

/** blahhhh some kdoc comment */
static vm_fault_t retry_under_mmap_if_vma_locked(struct vm_fault *vmf)
{
	if (!(vmf->flags & FAULT_FLAG_VMA_LOCK))
		return 0;

	vma_end_read(vma);
	return VM_FAULT_RETRY | VM_FAULT_RETRY_HARD;
}

And:

	vm_fault_t ret;

	ret = retry_under_mmap_if_vma_locked(vmf);
	if (ret)
		return ret;

Or something like this.

>  	}
>
>  	ptl = pmd_lock(vma->vm_mm, vmf->pmd);
> diff --git a/mm/memory.c b/mm/memory.c
> index ff338c2abe92..7f2a30b5efca 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3797,7 +3797,7 @@ static inline vm_fault_t vmf_can_call_fault(const struct vm_fault *vmf)
>  	if (vma->vm_ops->map_pages || !(vmf->flags & FAULT_FLAG_VMA_LOCK))
>  		return 0;
>  	vma_end_read(vma);
> -	return VM_FAULT_RETRY;
> +	return VM_FAULT_RETRY | VM_FAULT_RETRY_HARD;

You could use my helper like above.

>  }
>
>  /**
> @@ -3824,7 +3824,7 @@ vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
>  		return 0;
>  	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
>  		if (!mmap_read_trylock(vma->vm_mm))
> -			return VM_FAULT_RETRY;
> +			return VM_FAULT_RETRY | VM_FAULT_RETRY_HARD;

This really makes me think VM_FAULT_RETRY_MMAP or something explicit would
be better, otherwise you have to add a comment explaining you're doing this
because you need the mmap read lock here since the VMA lock + speculative
mmap read lock acquisition didn't work out.

>  	}
>  	if (__anon_vma_prepare(vma))
>  		ret = VM_FAULT_OOM;
> @@ -4778,7 +4778,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  				 * under VMA lock.
>  				 */
>  				vma_end_read(vma);
> -				ret = VM_FAULT_RETRY;
> +				ret = VM_FAULT_RETRY | VM_FAULT_RETRY_HARD;

Again, helper above self-documents.

>  				goto out;
>  			}
>
>
> base-commit: 81652c5a65d4ae28e9b18c16ef917a40025c3653
> --
> 2.43.0
>

Have you audited every single VM_FAULT_RETRY case? Because getting this
wrong could be a serious problem and break things. You should include a
list of call sites in your patch and explain why it's fine in each case.

One case I noticed is uffd:

	ret = VM_FAULT_RETRY;
	...
	if (unlikely(READ_ONCE(ctx->released))) {
		/*
		 * If a concurrent release is detected, do not return
		 * VM_FAULT_SIGBUS or VM_FAULT_NOPAGE, but instead always
		 * return VM_FAULT_RETRY with lock released proactively.
.	...
		 * If we were to return VM_FAULT_NOPAGE, it would work for
		 * the fault path, in which the lock will be released
		 * later.  However for GUP, faultin_page() does nothing
		 * special on NOPAGE, so GUP would spin retrying without
		 * releasing the mmap read lock, causing possible livelock.
		 *
		 * Here only VM_FAULT_RETRY would make sure the mmap lock
		 * be released immediately, so that the thread concurrently
		 * releasing the userfault would always make progress.
		 */
		 release_fault_lock(vmf);
		 goto out;
	}

The comment needs updating (Suren?) to reflect the VMA lock, basically with
VMA lock held this is meaningless.

We're actually safe here in general as if the VMA lock is contended on a
competing write lock we drop to mmap lock.

A racing uffd release thread does an unconditional vma_start_write()
_after_ setting ctx->released:

static int userfaultfd_release(struct inode *inode, struct file *file)
{
	...
	WRITE_ONCE(ctx->released, true);
	userfaultfd_release_all(mm, ctx);
	...
}

userfaultfd_release_all()
<mmap write lock>
-> userfaultfd_clear_vma()
-> vma_modify_flags_uffd()
-> vma_modify()
-> vma_merge_existing_range()   -> vma_start_write() LIVELOCK
OR split_vma() -> __split_vma() -> vma_start_write() LIVELOCK

So yeah, not sure on this one, maybe we're fine just to use VMA lock still?

Suren - any thoughts?

You definitely need to explain your reasoning in the commit message at
least.

Also commit 29a22b9e08d7 ("mm: handle userfaults under VMA lock") did fail
to update this comment to reflect VMA locks - we should fix that too -
Suren? :)


Also another thought - should we allow FAULT_FLAG_RETRY_NOWAIT to retry
with the VMA lock? As this could also be some unbounded spinning? But then
again, if we bound the spinning that might be ok.

Thanks, Lorenzo


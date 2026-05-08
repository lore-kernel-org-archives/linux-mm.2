Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13A42CD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 16:53:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77E746B01FB; Fri,  8 May 2026 12:53:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 756AE6B01FC; Fri,  8 May 2026 12:53:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6942A6B01FE; Fri,  8 May 2026 12:53:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A62D6B01FB
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:53:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08674C0D9D
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:53:04 +0000 (UTC)
X-FDA: 84744847488.23.4B71F9D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5C1DE180008
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:53:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HfLRkJRp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778259182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=17uTrTFgY70hDP923yRzXCwsWwXnKCwoQwW4tj8xaGU=;
	b=UX1+D6jSTzOPlHWNnW+Tbxo/bVwXBhp16S6Occy9VEGXC0gt60PcTI3vGYBDi49gMzaVy0
	tOztEZQ57rNIqY6mLb9Ad/K6OPzqo48nLTcg4OR/0EkzgkQMNwKmbnfVv5qP6WXSl3BvBO
	nqN990BGP/KjU6j1MQIRaNr3NRVxYzg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778259182; a=rsa-sha256;
	cv=none;
	b=C+Ixlv8ch7+SWGgRE+wf9QGAkKO1VRdDpAAdnMnrdbGmYhuSrQg9jI6E+DyDa60mZFXwDc
	feHN5LKvS9x1r2gUr/4mqmgEzpu0mbBw/wys1H7vuX/6b08QhMfzTlRVC4eQ66mG6F/gXq
	Au3kLsfr7GRBJmv54wW1/aSrthXD6D4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HfLRkJRp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A44E60052;
	Fri,  8 May 2026 16:53:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34282C2BCB0;
	Fri,  8 May 2026 16:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778259181;
	bh=4MDk5NZ1XxKFL8fmd4JnOeZWI7qWd3z6NK+jJrIZHC8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HfLRkJRpbISH//Zr0O1feN91Bz7B9madopm6wHy3EcCpiQ0DQGEXXawbo9Qm3gPCt
	 WI5Vq1oiKY1Cft7fv2trK1lApA4q0Cx5Y/6s/n7iYmLvAhMNEeopsW395poPhYtZ74
	 YEtYQoJbV6xbAsToVodNn5hupiWeJU7jMSojPbrKmR0tCtNViCCbj105LiWD4ZYfy1
	 dNLLVu7YayjD3QIbTWez7OfGEVKUpWwpbchK3g+PEqMig3nXGDbousGpG0om9BZ3oy
	 6re1isgvvlr5+l6KnoV7RCAXeznxcJYXYLdmUTZNtqv6+3m9PhrcymLQScRCL602pl
	 NsCTgKsNO5TQA==
Date: Fri, 8 May 2026 17:52:54 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH 0/6] mm: Make per-VMA locks available in all builds
Message-ID: <af4QC2It_jgSgCGd@lucifer>
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5C1DE180008
X-Stat-Signature: 5cor5ozdmpmy9pybf8a84bpb3twmi7ku
X-Rspam-User: 
X-HE-Tag: 1778259182-23982
X-HE-Meta: U2FsdGVkX19o8Ion6Bbjd+Lxy/IAHQmo+XgbMB4TSoJ8SF0b6bOgR+0OwHF0pcARNxBFKcTaiOjqtMjpClTpDO/OaXD1plEMdYF50lOj/359lqfaVjSoyYDKmFnViUCJEo0mj88+XDtm0DBamiFix/j8CyMf4NZQf75Gm2IR21X1Og2ENcgxh8x7+Viz7VcdDVD+xDg7WY8TWbe78NApqvbSjstKyNQ6abdoKMDx/hYVxjhddyGCTZkMM6qjGfQvYySPo5a0d6ZBXdDDMq6+38FfTGL0zHPDomE6x/bwzvU4R0e4M1gpcx/O95iIWeMXN/3dQ5ucpeVYLlaOZx6WbrTxDnKUmgX3ezNAuGkvJN7PZ0SB2ooF7zOPUxGB8B7OHRYKXgXDpTn+5qqASyKWa9AQTBb5ERHTiUbZK/QZFLq9pipgfxhnrBjvZ2Mqv9IK9lYLhkTdTNRZe0pOpcH8pIYlmAho944pUpP24IdyzW1VrAjTexsxt0BljkxwxMY30LYTxjHTfqmhaLLRF+JFoFpA4uoN/29ovoWscOTjjI8UO6X9NOY273CJSdN4GoMdXt5RW4KKXLbDx4ddFclvZSrkE7B6dwulpCv82AuaeY4Je+v4rmHlGry2MhScWf9MNKfTW/a+Z2uu9/PwC652D4qmu5tM5eAIt33bxi9XQf6eyyzhCMdYDOc8I0soxEGO+gqtHDVcT2kJqzid5E5Tjf8ed0TH1lIFIXtMXQD7Y4Zdm8MneZxl/CXFyBeFb1I2VhYcHg1eY7zGjZqUYNiIrHiZu9RoZ7MRYb1JxTOvKQpOCYONWAlvM2MtRzVZwouTrAVORBZYQ+RqUg4KMkjZNMH425aKDXTPQE6JCV/hC7ofcunKX70KH/HIcH2YiNqZ6N3MMd1NJd0r5am2NcclsvJRc+mZdVRK8blbwZbwi7zv4WX5jv5xYydeIoR3C8d3AaxWNBG7scfnwpkMRz0
 aNKFcm4i
 Zvf1NXYHl+wSEHWCT1tVWTrLGyQCkR084m4tzxouUM5F67/u3nV/dGAZZeOaEd7iNoZ3F9DlXynif6wfWi7n7SuKSNWjb/mpR0U97rLCrGGDI7flySzUwBEwerFwxutE2ihwtpf9YO76Scd2gvXNR390eXuQPiRJCemlHcQksUD9BxTd0QWSTrCnxbiflOAeoiETZ3Z3XytLI2NQdQfMCfiqnq+fDjJCcqAx81ff70vsgeXiNJXa7HtlV7k2ybRSeCJkasaAFwwO7eNjZ7Sclwc+LXRbukVcszHLaNlKAFb7OInDZ77G8mewEwsmtiPsv+VlGM/Ip8RoJesy8fveV5WKOXWYj3wLSpYr5iIohK3LnazjhqZSP31GWQxuYhvBAXB9tTinB6GRX/vNVWrTprRI2Hvodb5Pjo2zDK+CdSjJ6T+t15c/3tpc0yg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I'm guessing this is kinda an RFC? :P

On Wed, Apr 29, 2026 at 11:19:54AM -0700, Dave Hansen wrote:
> tl;dr: I hope I'm not missing something big here. The basic
> observastion here is that forcing code to account for per-VMA lock
> failure adds a lot of complexity. This series theorizes that with a
> some Kconfig changes and a new helper, many callers can avoid writing
> code that falls back to mmap_lock.

In general very much in support of this!

It'd be great to just know that this is available and frankly I think it's a
critical part of the kernel.

Obviously Suren needs to have a look through, most important of all :)

>
> --
>
> When working on some x86 shadow stack code, it was a real pain to
> avoid causing recursive locking problems with mmap_lock. One way
> to avoid those was to avoid mmap_lock and use per-VMA locks instead.
> They are great, but they are not available in all configs which
> makes them unusable in generic code, or if you want to completely
> avoid mmap_lock.

Yeah, lock ordering is a pain.

>
> Make per-VMA locks available in all configs. Right now, they are
> only available on select architectures when SMP and MMU are enabled.
> But all of the primitives that per-VMA locks are built on (RCU, maple
> trees, refcounts) work just fine without SMP or MMU.
>
> Their only real downside is that they make VMAs a wee bit bigger
> on !MMU and !SMP builds.
>
> The upside is much cleaner code, lower complexity and less #ifdeffery.
>
> Building on top of universally-available per-VMA locks, introduce a
> new helper. Since the new API does not require callers to have a
> fallback to mmap_lock, it's much easier to use. Callers could
> potentially replace this very common kernel idiom:
>
> 	mmap_read_lock(mm);
> 	vma = vma_lookup()
> 	// fiddle with vma
> 	mmap_read_unlock(mm);
>
> with:
>
> 	vma = lock_vma_under_rcu_wait(mm, address);

I will look at what you're proposing but this seems a bit like something I
proposed at LSF (but was probably not the right solution for what was under
discussion).

Doing this 'right' would require quite a bit of engineering effort. The VMA
locks are pretty bloody complicated :) so we have to be careful not to spread
the complexity around too much.

But I guess you could 'wait' by doing it in the slow path and then using
vma_start_read_locked()...

Of course that'd not help you with any lock inversions though!

Anyway need to read the code :)

> 	// fiddle with vma
> 	vma_end_read(vma);
>
> Which avoids mmap_lock entirely in the fast path.

Yeah it's nice!

>
> Things I think needs more discussion:
>  * The new helper has a horrible name. Suggestions are very welcome.
>  * I'm not very confident that this approach completely avoids the
>    deadlock issues that arise from touching userspace while holding
>    mm-related locks.

Yeah we have to be careful...

>  * Can the helper avoid the goto, maybe by taking the VMA refcount
>    while holding mmap_lock?

Surely that'd defeat the purpose of VMA locks though? you'd hold the mmap lock
for less time but you're still contending vs. _any_ VMA write locks whilst
trying to get a VMA read lock?

Unless it's on a slow path... hmm :)

>  * mm_struct and vm_area_struct "bloat"

Probably not a problem really. For any modern system you're using the fields.

>
> I've included a couple patches where I think the new helper really
> makes the code nicer.
>
> I'm keeping the cc list on the short side for now because I'm not
> actually proposing that we go ahead and do the ipv4 changes, for
> example.

Ack!

>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: linux-mm@kvack.org
>
>  arch/arm/Kconfig                       |    1
>  arch/arm64/Kconfig                     |    1
>  arch/loongarch/Kconfig                 |    1
>  arch/powerpc/platforms/powernv/Kconfig |    1
>  arch/powerpc/platforms/pseries/Kconfig |    1
>  arch/riscv/Kconfig                     |    1
>  arch/s390/Kconfig                      |    1
>  arch/x86/Kconfig                       |    2 -
>  arch/x86/kernel/shstk.c                |   47 +++++++++++-------------------
>  drivers/android/binder_alloc.c         |   39 ++++++-------------------
>  fs/proc/internal.h                     |    2 -
>  fs/proc/task_mmu.c                     |   51 ---------------------------------
>  include/linux/mm.h                     |   12 -------
>  include/linux/mm_types.h               |    7 ----
>  include/linux/mmap_lock.h              |   50 +-------------------------------
>  kernel/fork.c                          |    2 -
>  mm/Kconfig                             |   13 --------
>  mm/mmap_lock.c                         |   45 +++++++++++++++++++++++++++--
>  net/ipv4/tcp.c                         |   31 +++++---------------
>  19 files changed, 82 insertions(+), 226 deletions(-)


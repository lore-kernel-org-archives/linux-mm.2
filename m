Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34391C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 18:57:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 013076B00C5; Mon, 21 Sep 2026 14:57:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F05E56B00C9; Mon, 21 Sep 2026 14:57:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF54E6B00CB; Mon, 21 Sep 2026 14:57:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ACCAC6B00C5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:57:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B8272140286
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 18:57:32 +0000 (UTC)
X-FDA: 85238677944.25.5E52705
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3BD40100002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 18:57:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=i07QEUr7;
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790017051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9czfARorSYkXhn7wtuTfT0BpH91+/rvPllJAwe14Ukg=;
	b=Z6hc6ZrUHMQZ7IdSAXoC5hbJBy0N18M9wTigOWId7UTH85gitwFu3eV7hkNzajQ4YcA1Uh
	5GIWQMr1J6nflamM3ZRUMkkHCE9IOG8aU9ryfCKKeE+t79swNtoLBd33bPzI249D1k4AVV
	vxm71uREhi2aym58icYLzWD9jVYk6+E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=i07QEUr7;
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790017051;
	b=lP90wfB7E0rhIFBr2iiJJDKlFGykvPomiAOXz72JUVOnLakqAl0rXDurzc7QF3mUmMmcis
	FNAh96S7MXg4jT1JSocW3QNLCISA38Jm0LCvSs5NJFvNes+tE45B/CMzEDDzMW4+PNSoMv
	rUmUAsifZ+2pkd84UO9drEDjDvv5lA4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9czfARorSYkXhn7wtuTfT0BpH91+/rvPllJAwe14Ukg=; b=i07QEUr7FLrPNOasfEwFBQXlUm
	R1FAx/bprujw+QWlcEP1wKK2utSRNCm6Mg8mI1/NCcBmOt+MIfycEGWY2mOLy3WjtOt9bAO6jeil5
	ddfvZ4bYMZ+vykKvCJVEkNA1Ashmbg/kQxveGBb1l8ejcILd77zkYO70Lk1IsIo8OOvu+SR1lNSgi
	wSm3i7/AVKsyc8U9vsa8i10CgDa/W+91OL6ReG9VjqtconeMcEWRBUIos9N2Iug5cAu6uPQrciUZC
	P0JHDC3c+7azzmazJKmBqnrj9lYDDuScU6QAYzE/ubDDgwDXKcd1B6TvhcvGIi+8Jthe8rrPfPtFQ
	unARWs7g==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8jCd-000000054KL-1SFt;
	Mon, 21 Sep 2026 18:57:23 +0000
Date: Mon, 21 Sep 2026 19:57:23 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Hongru Zhang <zhanghongru06@gmail.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, baohua@kernel.org,
	surenb@google.com, david@kernel.org, liam@infradead.org,
	mhocko@suse.com, rppt@kernel.org, shakeel.butt@linux.dev,
	vbabka@kernel.org, zhaonanzhe@xiaomi.com, linux@armlinux.org.uk,
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, chenhuacai@kernel.org,
	kernel@xen0n.name, loongarch@lists.linux.dev, maddy@linux.ibm.com,
	mpe@ellerman.id.au, npiggin@gmail.com, chleroy@kernel.org,
	linuxppc-dev@lists.ozlabs.org, pjw@kernel.org, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, alex@ghiti.fr,
	linux-riscv@lists.infradead.org, agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
	borntraeger@linux.ibm.com, svens@linux.ibm.com,
	linux-s390@vger.kernel.org, dave.hansen@linux.intel.com,
	luto@kernel.org, peterz@infradead.org, tglx@kernel.org,
	mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
	Hongru Zhang <zhanghongru@xiaomi.com>
Subject: Re: [PATCH v6] mm: retry page faults once under the per-VMA lock
Message-ID: <arF-E3Nsw9ZliH0t@casper.infradead.org>
References: <20260911025613.1220845-1-zhanghongru@xiaomi.com>
 <arFYRAa-i7CIwmHL@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arFYRAa-i7CIwmHL@gremlin>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3BD40100002
X-Stat-Signature: byh1c5r4fn7tfhrobwztmdx8qjhub1nn
X-Rspam-User: 
X-HE-Tag: 1790017050-527463
X-HE-Meta: U2FsdGVkX19we36NkIuzVTgEEes/Fjp1uhnA7dcWvg0sB/EVHGJ3JoUCn/zEzqNVKYFXnYLm3Xbos0g+yT2JC20Yq8Vfsmdpa6dVMW5BylZvthregIzF/crD6iMuwq5fiN2m47LJ04XBLja+Tf/rRjAzY+1cC4TjFACJl9L+bDI3UTO6c5d3MnPy+V28ljAK2pXLZpulOJByY/8pNjFcdiFEzj8nX7s8e7t/W0lJfwYUrXDbZ0/SycLwxLZ1DYziCXi00QU743AzcEb/ojlXuCfaHOQB3KN6UToSsKlELzU7cGPiUBfGFsR4EIOJFaIzbxlWMKzhkjUbiWKwqRPTbwvuppKE6dr5Ct71kQKtpGkw2iwinXGdjJOpguYzytVaNIt3Sxv1etHED3h3xgxCKFBTRfnFBOoOIkBQf5qUQVwVrt1y3ZvWiXoF6Z5bXyMZw2gzIdO8Yd5Q31ZA7dXdPOkuGkiy8KGmxXMFKjbzdi1c3ncJDPiVTEs7p9Z8ctAQdPkD4v3YsV9EhtJsNb4kOhC/L2ioc/83z4BivI4keGy2ZH33Ig4MCluWCARey3kIfGDAF6DlJixvSnQq+Ee9/7g+lm/5zJgl4poRB8yzxuuUMFzYP55VPTlF6tgWDlS4txDrL9XS6IfLD46Jmb1qvMT3gG8NNXJHDsmuAog0aZ4MhtctT8C4BPHHnsVA+fRwmx19y6ZH6xudRERjRQd07Dm21JOmzZ3T52TSz9/YGoqtM2BY2fq3o4c4rV3ibiiE6wB+9u4ka8LQ9CWkKPBbRPb7mMmM/VeB/B75cw5fCpLZeS0WaXGBCs9bUcYZ4etuvuTWw112hZZRUO+sRsC3C4NNQUupX9jtHe49uELdMTxYveF1k0xiKZTXgTeXoPKnCj/+0Aou6eidEmuqXkd9JvRjSxd5Oo2+PCMiFj3GOBrFiDOEz4Vt1XPp/1J71xdWo20jwLrzaV9uI7PlEvZ
 q/DiDKvq
 j8fi4t/ASdsro9A13hhI3rFJzsByS9+/iDQkPbicAT6BnAKb1xbm1TgjWu093ANQCdfPnXuRChTcY53A2JpPvIHHLgLsaTIxvmlGrU9ImKnRJvZBuPhIAFH+jkQGUayto9IQNGm7YfpM1Rn1twkeDEaqAPg2webL1osMbJ677wQlPM+Wolo4Euj566TWqzTFk9EcjjJgHerM8aRjaQdo90ZtxKCLgzdl4i5Z7ji475VUliiiaczB9lLbEpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 06:54:25PM +0100, Lorenzo Stoakes (ARM) wrote:
> OK I finally got to this...

Brave ;-)

> I fear we're going to go round in circles on this/have endless revisions of
> the same thing.
> 
> So 2 things the patch needs to answer, more or less right away:
> 
> 1. What are you actually optimising for?
> 
> 2. Where does the hurt happen?
> 
> Your patch does neither, then goes on to arm wave away all the complexity
> and presents a 'simple' solution that I feel brushes a lot under the rug.
> 
> Answer to 1 is 'cold app startup time for a specific set of apps'
> 2 is filemap_fault() AFAICT.
> 
> You should definitely be stating this upfront.
> 
> And I also seem to remember that zygote + multi-threaded apps = fork
> blocking is part of the problem here, which is why there was push-back on
> just holding the VMA lock over I/O.
> 
> Looking through filemap_fault() makes me want to cry and looking through
> the other retry logic in the fault code makes me want to live on an island
> with parakeets and coconuts forgetting any of this even exists...

I think that's the right response.  It's why all the feedback from people
who haven't even tried to follow the fault path (eg the session at LSFMM)
is completely useless.  The fault path is WAY TOO COMPLEX.  I'll have
more to say on this in two weeks at Plumbers.

> VM_FAULT_RETRY can mean a million different things:
> 
> 1. I dropped the lock and waited for the folio to be unlocked.
> 
> do_swap_page(), remove_device_exclusive_entry() -> folio_lock_or_retry()
> 
> 2. I dropped the lock to start I/O it may or may not be ready when you come
>    back.
> 
> filemap_fault() after do_sync_mmap_readahead() or page not uptodate
> synchronous read with lock dropped <- what you are optimising for, or
> shmem_falloc_wait() waiting for a hole punch.
> 
> The maybe_unlock_mmap_for_io() stuff.

I think these two are the same case?  At least by my reading, case 2
also waits for the folio to be unlocked (ie the read completed).
do_sync_mmap_readahead() doesn't do that, but we then call
__filemap_get_folio() which shuld return the appropriate folio,
then we call __folio_lock_killable() or __folio_lock().

> 3. I dropped the lock and nothing was waited for, OOM me on retry!
> 
> filemap_fault() allocation failure, gotta retry because we dropped the
> lock!

Oh, yeah, that's icky.  Hadn't even crawled onto my list of problems
with this function.

> 4. I can't do this under the VMA lock, use an mmap lock
> 
> vmf_can_call_fault(), any vm_ops without ->map_pages, __vmf_anon_prepare()
> when mmap_read_trylock() lost, also hugetlb_fault() horror shows.
> 
> Also device-private swap entries.

This one really is my fault / Suren's fault / your fault ;-)

We should not have overloaded VM_FAULT_RETRY for this case.  We should
have had a distinct VM_FAULT_NEEDS_MMAP_LOCK code.  But I am *scared*
to try to separate the two at this point.  It was hard to make sure we
got all the cases as we pushed it down, and now it's going to be worse.

But I don't think that hugetlb_fault() deserves any stick here:
         * We must check to release the per-VMA lock. __vmf_anon_prepare() in
         * hugetlb_wp() is the only way ret can be set to VM_FAULT_RETRY.
is the comment on the only two mentions of VM_FAULT_RETRY in hugetlb.

I do have a plan to get rid of those two mentions actually ...
but let's talk about in in Prague.

> 5. Userfaultfd! Because of course!
> 
> Userspace has to do something.
> 
> handle_userfault() after sleeping for uffd handler, retry should succeed.
> 
> ctx->released -> yield to releasing thread.

I find it really hard to reason about uffd.

> 6. Fatal signal
> 
> Arch handlers rely on this, so retry also means 'check signals'. Fun.
> 
> 7. Some driver insanity
> 
> It means all things to all people. Used for waiting on stuff like
> 
> LLM says:
> 
> - TTM at drivers/gpu/drm/ttm/ttm_bo_vm.c:62 and 144, dma_resv contention
>   and GPU idle wait. Consumers in amdgpu, i915, nouveau, radeon and vmwgfx
>   re-derive "was the reservation unlocked" from ret == VM_FAULT_RETRY &&
>   !NOWAIT.
> 
> - xe_bo_cpu_fault_fastpath() at drivers/gpu/drm/xe/xe_bo.c:2021, where
>   RETRY is the default return value, including for "runtime PM not active".
> 
> - panthor at drivers/gpu/drm/panthor/panthor_gem.c:831 onwards, where
>   dma_resv_trylock() failure is RETRY and the same error is NOPAGE, SIGBUS
>   or RETRY depending on mmap_lock_held.
> 
> - sgx_vepc_fault() at arch/x86/kernel/cpu/sgx/virt.c:91, EBUSY from
>   __sgx_vepc_fault().  All of these call mmap_read_unlock() directly rather
>   than release_fault_lock(). They are only safe because none has
>   ->map_pages, so vmf_can_call_fault() bounces them before ->fault
>   runs. The VMA-lock design rests on that proxy.
> 
> So yeah. All that. Wow.
> 
> 8. Nothing!
> 
> LLM says:
> 
>   - page_mkwrite() returns in fs/exfat/file.c:951 (inode_trylock lost),

That's just wrong.  It turns the pagefault path into a spin on
the inode lock!

>     fs/nfs/file.c:699, fs/netfs/buffered_write.c:576 and
>     fs/orangefs/inode.c:635 onwards, including the combination
>     VM_FAULT_LOCKED | VM_FAULT_RETRY.

I think your AI is confused.  I don't see how nfs_vm_page_mkwrite()
can return VM_FAULT_LOCKED | VM_FAULT_RETRY.  Nor netfs.  Orangefs
is wrong and needs to be fixed ... once I figure out what it actually
wants.

>     do_page_mkwrite() at mm/memory.c only
>     passes through ERROR and NOPAGE, and do_shared_fault() and
>     wp_page_shared() then ignore the returned value entirely. The write
>     fault completes as if page_mkwrite had succeeded.

That's probably OK.  I think?

> And maybe I'm missing some stuff too.

There's also the VM_FAULT_COMPLETED insanity ...

> But I worry a LOT more that it's just a HACK (and I know Barry was nice
> about the idea and I appreciate it but I have to be honest).
> 
> Instead of dealing with any of the above, we just leave the mess in place +
> just retry the operation under VMA because we happen to know, for this ONE
> workload, it works out better.
> 
> And PROBABLY it doesn't add too much overhead to anything else.
> 
> SO.
> 
> I've written too much again, let's sum it up.
> 
> 1. WE HAVE TO DECIDE whether we want to accept the hack because it
>    helps in a known case and probably doesn't harm any other cases.
> 
> 2. WE HAVE TO FIX THIS DAMN MESS. Even if we take something like this WE
>    HAVE TO FIX IT.
> 
> I'm inclined to rip out the whole retry thing altogether one way or another
> but I leave that to Matthew to figure out :)

I think there's a bathtub with a baby in it over there ...

There's considerable scope for simplification here.
lock_folio_maybe_drop_mmap() makes my eyeballs bleed every time I look
at it.  But we do need smoe kind of restart-the-fault mechanism.

> If we decide we DO want the hack, then DEAR LORD can we not have this
> horrible duplication across arches? I seem to remember you agreed to take
> that out ([0]), and maybe it's pending what Matthew wants to do, but is
> there not a way to avoid that?

We desperately need to move more of the fault handling path out of the
architectures.

> I REALLY want to hear from Matthew on all this, I don't think we can move
> ahead without his clear feedback.

Thanks for dragging me back into this ;-)


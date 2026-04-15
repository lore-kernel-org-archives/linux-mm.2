Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D627AF428C6
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 18:45:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460146B0089; Wed, 15 Apr 2026 14:45:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 410EE6B008C; Wed, 15 Apr 2026 14:45:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D9696B0092; Wed, 15 Apr 2026 14:45:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1BAE46B0089
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 14:45:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D35A61405BD
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:45:02 +0000 (UTC)
X-FDA: 84661667244.12.06CAA17
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 39AAE1C0008
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:45:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qO9SVw+N;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776278701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E4pmEkuk5oDOMwwUx+WjjBHbjlhLXQBBrR52wnjysAo=;
	b=RP6qjXV0Sj2JE40PPH2NVHZqWyzrYOpcK9wF5/dZ1EgWuXaLBqhn/U/z3PyxVaqyEZWhqw
	yz8iPa9yMLeWBKJc+Pn49abHEY9KjUN+eKxBoddF5cD4V3sXxFqg49wIct+ff5/f41StaO
	OemplHqQbCenwYx0FS8q1Sr8VAsKPZw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776278701; a=rsa-sha256;
	cv=none;
	b=ZzKfA0NHUC7nm9EIH227LTXb7749ksN53LcTNNZBIF4yvLPrq4hBMbWM5RvGzHRwKTyaF5
	4Ma46lIwJYjjJnPYA2jCvdvUwcFBVD8z7N/PdS9V+Y91HLzhendoS4VHoZ45JWgKdyM+aU
	HuAvInLP+ZtPU0PgmIEFFdcuzWaBBIY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qO9SVw+N;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F32060120;
	Wed, 15 Apr 2026 18:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89997C2BCB5;
	Wed, 15 Apr 2026 18:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776278699;
	bh=XAfQ0bL3NpB5tOlCtbFHon/YF6wvabOfkQ0Eik0WVWU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qO9SVw+NS0+8QHr+Kg40fx5suUaeQg5hjXBYMqz9paenf1AHJTuxlwEkrflMLVR0/
	 dbb2RqcsGk6r4mmHByx7xrGDGGeY2DbjvJEc5Xz5cIc8fxX+WkiHq0+sRIuAXp3hu1
	 PO9nmTCIDbkVtQV7VSxqgzaOChTS6D/r2QZWx/ZjcF2X2y9z9SxBZ36TfLePCrbIFT
	 OA1QI42HyB7ig41P5owNG+tkKB6Bnypo3SCiOvAF9oZUWGkHh334b9/rqbi041FnX6
	 XXmxfCQbnNUm9XCNrb0jDXRSgVK5cAEeC/UFMwoqYoIgvDa5zxLVPcI7iJQa/5Fhtt
	 TRAIyp2sT5ORA==
Date: Thu, 16 Apr 2026 03:44:57 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Waiman Long <longman@redhat.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Steven Rostedt <rostedt@goodmis.org>,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Hao Li <hao.li@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [RFC] making nested spin_trylock() work on UP?
Message-ID: <ad_cqe51pvr1WaDg@hyeyoo>
References: <d762c46b-36f0-471a-b5b4-23c8cf5628ae@suse.cz>
 <aZAWGwZP_Z75YHKt@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZAWGwZP_Z75YHKt@casper.infradead.org>
X-Stat-Signature: m9mbzd5z5p6f1g4uqtdx86a5p7sg6ah1
X-Rspam-User: 
X-Rspamd-Queue-Id: 39AAE1C0008
X-Rspamd-Server: rspam05
X-HE-Tag: 1776278701-976025
X-HE-Meta: U2FsdGVkX1/PDfNKT0i4LxR+EJmlvag9Nmz4J3jCuqk/Ddhmz+ElLvgmMzYrcoXJpncxmp04E7nmVXpAhj2LJ/3f3aVYmIG2FHXYrwVL8wwBI283L8YgPUcyeT/xY30s+vEvjj0HAau0GKnB16E4H/LWTwAeJhXhKaQfjobtVIu6/dZ+0Z714+TA4iUcYfnAqCqkIwXPcVYWuJaOiCI06pX8QkuaVnoqD6Y05ZCQeKghQQGCIiRWwPECI5wiaDTVSKl2/xQBqxk6MFdKpsQCvCdsnw1EeDrvUebjnbnDpj5gczSFh45VLlf/sXhFSuPaMVijKkGnCRcqAoZHbWoIgmo/THqASHsbX8QjIr4H1IcnnASyfCzcWhjMsbeJhmEzKLKo8OMA4VwQo+kSVpitHnmt0R6oeagyfVn7ogHcUqr2DBTOAJtxcGoRspb+7/U/ae0WcNCr4puSaYZtF0Vvk02HwlmZsRNxeowxhLEf694Fsx6BzdKAqRxMIi759rQVFGMg2DBOdsd5EY3ElUDqsm3QeegHcm9Rx8BBWGEvXr3pgqF+rnBkk7dZvmw+ShTwnkW8CCBDNdzqrj3JCYjneHUBCzZi0MLQ5O6MDuK1ZlNWqNLqKtdLBbLg9wXr6q8aXn0+w1DCh57ua/Oq/v5ngaMIKTMY9iMZO2V4FS1mzs7leYvWJ2Lhjut0GkOboxKsDEgDkLtp/kzj5yRy/ssvLIWGxDR1h/PzBxUYswgq8363/mXZz7WNUTvXFTb4qdlwXbbkchLPvpuSHC8SdUrfQzKmUBT8AYSTKVZn5/XXfkQBHKbycwKCCxB97SJBxrtvUElbY1D53c7bXEw4pIw/MGtPJ+2kzfGAXmDCQlPgpXw4QOnHocltgqkzoQF1pSmsOl1cUu4HlxKW36+gLYGS71l+Lc92Zpyqf29GSnM2ZZ/c+DAD7Yduj/R4CPX/9lfo1UsLscF5TCDKZSiyvvm
 4Jc24gM0
 hQPrGtufj/194nSwRVnIVEcN2wZZ3CCdXmJdGyxWonHdZ77+WemicIkMn8D6V7yYPvhtPI2BP7ohWOFK4SYxmVJbSYnoP+Gf98lv7lI71TodariQcmW454rpX8NX9bae9Z4TQd5kEZt6p+rWYWG2tceEUx5pBnbvMyqWuvFfTmd1sdRh/oe8A/6yJjHNjRnTjhU6LT5YNhfLotqYkvzKnK74t3JEVgABbR74BO+TouxtCtIj8nCclFjcl1STAkbNDkOuwREynI/bp7wr5E+1exmnOb2ORQrH91Hajr3wUsGNTbXCfaKSxKl+8p9aLc7qhXWGb5XmuJbqoJWXs72WF+feTXMjHy6KkfUL8LttbvcbtQ/hwNteKpu7q1KJlLHYZDGy7YdACFl8myuRF9JEnc0KQOPVS9yt78Xv8A9z+0OgGHtADp1MFSfHpI95xqDA477mtCWxkk2REeMSAGN90jF8FSY+WQMVDsboB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[+Cc Alexei for _nolock() APIs]
[+Cc SLAB ALLOCATOR and PAGE ALLOCATOR folks]

I was testing kmalloc_nolock() on UP and I think
I'm dealt with a similar issue...

On Sat, Feb 14, 2026 at 06:28:43AM +0000, Matthew Wilcox wrote:
> On Fri, Feb 13, 2026 at 12:57:43PM +0100, Vlastimil Babka wrote:
> > The page allocator has been using a locking scheme for its percpu page
> > caches (pcp) for years now, based on spin_trylock() with no _irqsave() part.
> > The point is that if we interrupt the locked section, we fail the trylock
> > and just fallback to something that's more expensive, but it's rare so we
> > don't need to pay the irqsave cost all the time in the fastpaths.
> > 
> > It's similar to but not exactly local_trylock_t (which is also newer anyway)
> > because in some cases we do lock the pcp of a non-local cpu to flush it, in
> > a way that's cheaper than IPI or queue_work_on().
> > 
> > The complication of this scheme has been UP non-debug spinlock
> > implementation which assumes spin_trylock() can't fail on UP and has no
> > state to track it. It just doesn't anticipate this usage scenario.

This is not the only scenario that doesn't work.

I was testing "calling {kmalloc,kfree}_nolock() in an NMI handler
when the CPU is calling kmalloc() & kfree()" [1] scenario.

Weirdly it's broken (dmesg at the end of the email) on UP since v6.18,
where {kmalloc,kfree}_nolock() APIs were introduced.

[1] https://lore.kernel.org/linux-mm/20260406090907.11710-3-harry@kernel.org

> > So to
> > work around that we disable IRQs on UP, complicating the implementation.
> > Also recently we found years old bug in the implementation - see
> > 038a102535eb ("mm/page_alloc: prevent pcp corruption with SMP=n").

In the case mentioned above, disabling IRQs doesn't work as the handler
can be called in an NMI context.

{kmalloc,kfree}_nolock()->spin_trylock_irqsave() can succeed on UP
when the CPU already acquired the spinlock w/ IRQs disabled.

> > So my question is if we could have spinlock implementation supporting this
> > nested spin_trylock() usage, or if the UP optimization is still considered
> > too important to lose it. I was thinking:
> > 
> > - remove the UP implementation completely - would it increase the overhead
> > on SMP=n systems too much and do we still care?
> > 
> > - make the non-debug implementation a bit like the debug one so we do have
> > the 'locked' state (see include/linux/spinlock_up.h and lock->slock). This
> > also adds some overhead but not as much as the full SMP implementation?
> 
> What if we use an atomic_t on UP to simulate there being a spinlock,
> but only for pcp?  Your demo shows pcp_spin_trylock() continuing to
> exist, so how about doing something like:
> 
> #ifdef CONFIG_SMP
> #define pcp_spin_trylock(ptr)						\
> ({									\
> 	struct per_cpu_pages *__ret;					\
> 	__ret = pcpu_spin_trylock(struct per_cpu_pages, lock, ptr);	\
> 	__ret;								\
> })
> #else
> static atomic_t pcp_UP_lock = ATOMIC_INIT(0);
> #define pcp_spin_trylock(ptr)						\
> ({									\
> 	struct per_cpu_pages *__ret = NULL;				\
> 	if (atomic_try_cmpxchg(&pcp_UP_lock, 0, 1))			\
> 		__ret = (void *)&pcp_UP_lock;				\
> 	__ret;								\
> });
> #endif
>
> (obviously you need pcp_spin_lock/pcp_spin_unlock also defined)
> 
> That only costs us 4 extra bytes on UP, rather than 4 bytes per spinlock.
> And some people still use routers with tiny amounts of memory and a
> single CPU, or retrocomputers with single CPUs.

I think we need a special spinlock type that wraps something like this
and use them when spinlocks can be trylock'd in an unknown context:
pcp lock, zone lock, per-node partial slab list lock,
per-node barn lock, etc.

dmesg here, HEAD is a commit that adds the test case, on top of
commit af92793e52c3a ("slab: Introduce kmalloc_nolock() and
kfree_nolock()."):
> 
> [    3.658916] ------------[ cut here ]------------
> [    3.659492] perf: interrupt took too long (5015 > 5005), lowering kernel.perf_event_max_sample_rate to 39000
> [    3.660800] kernel BUG at mm/slub.c:4382!

This is BUG_ON(new.frozen) in freeze_slab(), which implies that
somebody else has taken it off list and froze it already (which should
have been prevented by the spinlock)

> [    3.661674] Oops: invalid opcode: 0000 [#1] NOPTI
> [    3.662427] CPU: 0 UID: 0 PID: 256 Comm: kunit_try_catch Tainted: G            E    N  6.17.0-rc3+ #24 PREEMPTLAZY
> [    3.663270] Tainted: [E]=UNSIGNED_MODULE, [N]=TEST
> [    3.663658] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [    3.664571] RIP: 0010:___slab_alloc (mm/slub.c:4382 (discriminator 1) mm/slub.c:4599 (discriminator 1)) 
> [ 3.664949] Code: 4c 24 78 e8 32 cc ff ff 84 c0 0f 85 09 fa ff ff 49 8b 4c 24 28 4d 8b 6c 24 20 48 89 c8 48 89 4c 24 78 48 c1 e8 18 84 c0 79 b3 <0f> 0b 41 8b 46 10 a9 87 04 00 00 74 a1 a8 80 75 24 49 89 dd e9 09

-- 
Cheers,
Harry / Hyeonggon

> All code
> ========
>    0:	4c 24 78             	rex.WR and $0x78,%al
>    3:	e8 32 cc ff ff       	call   0xffffffffffffcc3a
>    8:	84 c0                	test   %al,%al
>    a:	0f 85 09 fa ff ff    	jne    0xfffffffffffffa19
>   10:	49 8b 4c 24 28       	mov    0x28(%r12),%rcx
>   15:	4d 8b 6c 24 20       	mov    0x20(%r12),%r13
>   1a:	48 89 c8             	mov    %rcx,%rax
>   1d:	48 89 4c 24 78       	mov    %rcx,0x78(%rsp)
>   22:	48 c1 e8 18          	shr    $0x18,%rax
>   26:	84 c0                	test   %al,%al
>   28:	79 b3                	jns    0xffffffffffffffdd
>   2a:*	0f 0b                	ud2		<-- trapping instruction
>   2c:	41 8b 46 10          	mov    0x10(%r14),%eax
>   30:	a9 87 04 00 00       	test   $0x487,%eax
>   35:	74 a1                	je     0xffffffffffffffd8
>   37:	a8 80                	test   $0x80,%al
>   39:	75 24                	jne    0x5f
>   3b:	49 89 dd             	mov    %rbx,%r13
>   3e:	e9                   	.byte 0xe9
>   3f:	09                   	.byte 0x9
> 
> Code starting with the faulting instruction
> ===========================================
>    0:	0f 0b                	ud2
>    2:	41 8b 46 10          	mov    0x10(%r14),%eax
>    6:	a9 87 04 00 00       	test   $0x487,%eax
>    b:	74 a1                	je     0xffffffffffffffae
>    d:	a8 80                	test   $0x80,%al
>    f:	75 24                	jne    0x35
>   11:	49 89 dd             	mov    %rbx,%r13
>   14:	e9                   	.byte 0xe9
>   15:	09                   	.byte 0x9
> [    3.666437] RSP: 0018:ffffc9d4001d3c80 EFLAGS: 00010282
> [    3.666865] RAX: 0000000000000080 RBX: ffff8990fffd2e20 RCX: 0000000080400040
> [    3.667440] RDX: ffff8990c0051c48 RSI: 0000000000400cc0 RDI: ffff8990c0054100
> [    3.668018] RBP: ffffc9d4001d3d40 R08: 0000000000400cc0 R09: ffff8990c0051c40
> [    3.668628] R10: ffff8990fffd2e20 R11: ffff8990fffd2e20 R12: ffffec0e04031cc0
> [    3.669222] R13: 0000000000000000 R14: ffff8990c0054100 R15: ffffffffc04e8174
> [    3.669815] FS:  0000000000000000(0000) GS:0000000000000000(0000) knlGS:0000000000000000
> [    3.670475] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    3.670960] CR2: 00007ffcf4c95a68 CR3: 000000001f052000 CR4: 0000000000750ef0
> [    3.671554] PKRU: 55555554
> [    3.671799] Call Trace:
> [    3.672012]  <TASK>
> [    3.672199] ? test_kmalloc_kfree_nolock (lib/tests/slub_kunit.c:357 (discriminator 4)) slub_kunit 
> [    3.672704] ? test_kmalloc_kfree_nolock (lib/tests/slub_kunit.c:357 (discriminator 4)) slub_kunit 
> [    3.673211] __kmalloc_cache_noprof (mm/slub.c:4722 mm/slub.c:4798 mm/slub.c:5209 mm/slub.c:5695) 
> [    3.673595] ? srso_alias_return_thunk (arch/x86/lib/retpoline.S:183) 
> [    3.674003] test_kmalloc_kfree_nolock (lib/tests/slub_kunit.c:357 (discriminator 4)) slub_kunit 
> [    3.674475] ? srso_alias_return_thunk (arch/x86/lib/retpoline.S:183) 
> [    3.674869] ? test_kmalloc_kfree_nolock (lib/tests/slub_kunit.c:357 (discriminator 4)) slub_kunit 
> [    3.675354] ? srso_alias_return_thunk (arch/x86/lib/retpoline.S:183) 
> [    3.675754] ? srso_alias_return_thunk (arch/x86/lib/retpoline.S:183) 
> [    3.676144] ? srso_alias_return_thunk (arch/x86/lib/retpoline.S:183) 
> [    3.676535] ? __switch_to (./arch/x86/include/asm/cpufeature.h:101 arch/x86/kernel/process_64.c:378 arch/x86/kernel/process_64.c:666) 
> [    3.676848] ? __pfx_kunit_generic_run_threadfn_adapter (lib/kunit/try-catch.c:26) kunit 
> [    3.677395] kunit_try_run_case (lib/kunit/test.c:441 lib/kunit/test.c:484) kunit 
> [    3.677802] ? __pfx_kunit_generic_run_threadfn_adapter (lib/kunit/try-catch.c:26) kunit 
> [    3.678355] kunit_generic_run_threadfn_adapter (lib/kunit/try-catch.c:31) kunit 
> [    3.678857] kthread (kernel/kthread.c:463) 
> [    3.679130] ? __pfx_kthread (kernel/kthread.c:412) 
> [    3.679442] ret_from_fork (arch/x86/kernel/process.c:154) 
> [    3.679759] ? __pfx_kthread (kernel/kthread.c:412) 
> [    3.680071] ret_from_fork_asm (arch/x86/entry/entry_64.S:255) 
> [    3.680397]  </TASK>
> [    3.680585] Modules linked in: slub_kunit(E) kunit(E) intel_rapl_msr(E) intel_rapl_common(E) aesni_intel(E) ghash_clmulni_intel(E) kvm_amd(E) ccp(E) kvm(E) irqbypass(E) input_leds(E) i2c_piix4(E) i2c_smbus(E) mac_hid(E)
> [    3.682187] ---[ end trace 0000000000000000 ]---
> [    3.683108] RIP: 0010:___slab_alloc (mm/slub.c:4382 (discriminator 1) mm/slub.c:4599 (discriminator 1)) 
> [ 3.684032] Code: 4c 24 78 e8 32 cc ff ff 84 c0 0f 85 09 fa ff ff 49 8b 4c 24 28 4d 8b 6c 24 20 48 89 c8 48 89 4c 24 78 48 c1 e8 18 84 c0 79 b3 <0f> 0b 41 8b 46 10 a9 87 04 00 00 74 a1 a8 80 75 24 49 89 dd e9 09
> All code
> ========
>    0:	4c 24 78             	rex.WR and $0x78,%al
>    3:	e8 32 cc ff ff       	call   0xffffffffffffcc3a
>    8:	84 c0                	test   %al,%al
>    a:	0f 85 09 fa ff ff    	jne    0xfffffffffffffa19
>   10:	49 8b 4c 24 28       	mov    0x28(%r12),%rcx
>   15:	4d 8b 6c 24 20       	mov    0x20(%r12),%r13
>   1a:	48 89 c8             	mov    %rcx,%rax
>   1d:	48 89 4c 24 78       	mov    %rcx,0x78(%rsp)
>   22:	48 c1 e8 18          	shr    $0x18,%rax
>   26:	84 c0                	test   %al,%al
>   28:	79 b3                	jns    0xffffffffffffffdd
>   2a:*	0f 0b                	ud2		<-- trapping instruction
>   2c:	41 8b 46 10          	mov    0x10(%r14),%eax
>   30:	a9 87 04 00 00       	test   $0x487,%eax
>   35:	74 a1                	je     0xffffffffffffffd8
>   37:	a8 80                	test   $0x80,%al
>   39:	75 24                	jne    0x5f
>   3b:	49 89 dd             	mov    %rbx,%r13
>   3e:	e9                   	.byte 0xe9
>   3f:	09                   	.byte 0x9
> 
> Code starting with the faulting instruction
> ===========================================
>    0:	0f 0b                	ud2
>    2:	41 8b 46 10          	mov    0x10(%r14),%eax
>    6:	a9 87 04 00 00       	test   $0x487,%eax
>    b:	74 a1                	je     0xffffffffffffffae
>    d:	a8 80                	test   $0x80,%al
>    f:	75 24                	jne    0x35
>   11:	49 89 dd             	mov    %rbx,%r13
>   14:	e9                   	.byte 0xe9
>   15:	09                   	.byte 0x9
> [    3.686093] RSP: 0018:ffffc9d4001d3c80 EFLAGS: 00010282
> [    3.687036] RAX: 0000000000000080 RBX: ffff8990fffd2e20 RCX: 0000000080400040
> [    3.688128] RDX: ffff8990c0051c48 RSI: 0000000000400cc0 RDI: ffff8990c0054100
> [    3.689244] RBP: ffffc9d4001d3d40 R08: 0000000000400cc0 R09: ffff8990c0051c40
> [    3.690353] R10: ffff8990fffd2e20 R11: ffff8990fffd2e20 R12: ffffec0e04031cc0
> [    3.691476] R13: 0000000000000000 R14: ffff8990c0054100 R15: ffffffffc04e8174
> [    3.692864] FS:  0000000000000000(0000) GS:0000000000000000(0000) knlGS:0000000000000000
> [    3.694016] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    3.694997] CR2: 00007ffcf4c95a68 CR3: 000000001f052000 CR4: 0000000000750ef0
> [    3.696109] PKRU: 55555554
> [    3.696834] note: kunit_try_catch[256] exited with preempt_count 1
> [    3.696910] Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: vprintk_store (kernel/printk/printk.c:2358) 
> [    3.698650] Kernel Offset: 0x1d000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)


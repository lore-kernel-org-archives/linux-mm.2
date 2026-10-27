Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 566A1606A322
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 18:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m+FWkWEB
Received: by kanga.kvack.org (Postfix)
	id 5E7E06B0895; Tue, 27 Oct 2026 14:48:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BF9D6B0897; Tue, 27 Oct 2026 14:48:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D6B46B0898; Tue, 27 Oct 2026 14:48:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2090B6B0895
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:48:35 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CE9BE80AAB
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:48:33 +0000 (UTC)
X-FDA: 85369292106.19.2935076
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id F2F2610000B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:48:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m+FWkWEB;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793126912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MSzB1XWASGH+F7ssMzwnZlz8Zn+bsl00gQcZ/N0JfEg=;
	b=zs/pz+1A21sqk3D3Y9TeG5a7dhvAQsqIOVlswzKq/EAusZCvNfJM/HXCbJ1vJ/dt1C2kfd
	Mxc6eOVg7a05Sw39Cng8gM3eC8GoDLf63KJAXIfokaCdincQERzkxibh3GG5nZZ8HCM8E7
	NOac21pNTfvz6sdFDz0hXTr4/89MrRc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m+FWkWEB;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793126912;
	b=hvwsIwmzQ8QgSx/85IV7e8bv09Lo7IM46zzHGnZIzt0y/AcdGtINi3xwmwug8GQINkYPWw
	2xaxU/9/piocNwitC1U9w1GNgQ9rivHBn0p60GkZx2zhP5EbtPVgbjlkeKEbykrKZInsci
	hT1tUbAoxXXcC5MoRRnFUXncLcujIi4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8FC3943E61;
	Tue, 27 Oct 2026 18:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0263E1F01828;
	Tue, 27 Oct 2026 18:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793126910;
	bh=MSzB1XWASGH+F7ssMzwnZlz8Zn+bsl00gQcZ/N0JfEg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m+FWkWEB/usHjPgd/HeHjF823K6Da1+GalSCzv3haIPJi5KfmpeQJB0ZZL9Bw4yFC
	 GCYznMARAi2DJUTxSqGHOk1FCUCfbAluSRAD+TqgTIQFx9G+JlOAVN32JloPdigHLk
	 PIPOa7QskktQpkB3A7SC3OJthyWaq8LG0k/4YKNoqkQcVO8rJeaS8/USENaAr2ZXRB
	 sUDcRWopH82ZACGF75E9XXpgxKEkzvI97x9s9iser5Jnp/xuyd92sc6BiU/y5WwkNU
	 O/LUPQBHCsY5rp6UXBRpZn5yQw+hO3HoeP6cErD2I84I1gSLeHDo9gariXwMrVxSQh
	 IpGPUzlHwsSEg==
Date: Tue, 27 Oct 2026 18:48:28 +0000
From: Harry Yoo <harry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Hillf Danton <hdanton@sina.com>, Boqun Feng <boqun@kernel.org>, 
	syzbot <syzbot+f11512d1e5878ba5e60e@syzkaller.appspotmail.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, syzkaller-bugs@googlegroups.com, 
	Vlastimil Babka <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, linux-rt-devel@lists.linux.dev
Subject: Re: [syzbot] [kvm?] WARNING: locking bug in __refill_objects_node
Message-ID: <auDvUyfzg6nLtVox@thinkstation>
References: <6adf2939.67317f00.38c4bc.00ae.GAE@google.com>
 <20261026224305.1254-1-hdanton@sina.com>
 <auCucDdZb8mig7UZ@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auCucDdZb8mig7UZ@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F2F2610000B
X-Stat-Signature: b5u18w9ekmry7hznbonexkj46ymrnkwt
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793126911-451726
X-HE-Meta: U2FsdGVkX1+llFvb/Gw+rmhvms4YAXyvC9eY+wJoTQKBh/jyOnWaT+SXFZHsNLKTOvn4YWTnDtHVsOWjkr4Fh55MsMZVn6VH+WqMfDhcyhYs29zQleWTiyexXyxKi3yg7oeOucf+optqNhjLOjAyzxb+nLLdNSFtb7IUaJBxNOi+qB5QYGOdgdiobYq62eNdG9VJTx6+8ylxYXV2lQ54zsu93BtF1WXfseJfT5emW/IC3IgvUEbUeq3u9KSOREqISpb82alkYlTqoNDYLltfzPs1FKLliTpj2Dd75zUwdrzF8NDTWLM5cPfVRpUGP9pXg133jptBZbnaechzEuzWQ5eNlnCIMZckwDRdrBBHiyCS82mg+fcu5WNLUnywDenggwLnSZNLNGZ72FtV51lwHn+cUVWAyObi89ojczjU1UxNipNvVN2wDksx0JbBUTJtmlcrmnzEHuvo1ToxDynUWRINtdNxZNQ73G2io5hLZcFBWaR71KUnATM8UdZEhITMTwBuOWtVAzyBbgdAg0EQcVxODLtJTOQf8+QE7hzhrU9SKcNiG5L8/oJk660kFdRN4YkYFV3IB7sYoaHAJ5XwbCVSJgTaQS5iUrjWW88Zff5+DDumZMWRstLJD9Ov9LMLZMKghyBFHOMXJA87VMkbGN3meaeLkWr0vVVB8NYOiSXYMossy4ntuT3pZ3Fh1nt+Tn8e2wOKxCjk7rBN59a07CDyCkrVlgl95gFOffpqrQlKBRXzoNdQxmiLa7LdcdTnlGYPQ5LW6npvYfGHfP3jnHfvRwn3rtUXpW2P5V78zluV/9LiBr+EYR92cKa8rRN+H3NVW8nUr//LxbhUmjrWNtIJ6VuxNmrcczZSQtwhppS0VLY5rSWO2u8vgT8Hzh4zkOs6n5IhE3qDMk1yuMqxN3kK2tipnc8KMZZcePUFh+EaMZsk5YxvnXFRjPcppnPRJ7rhy0IT2z5gjQ7SE4z
 8gXwq/pa
 HUHD2NDB5jOQOtPDTU1n2Nv1zyAAVEvOMzcfVKfQY5j5InudkFeYthXh6hMirxSoF749cCY2iFTqgW5W/ScmNYKJHSS17owUMHZxTe2fDjYet5FVY4jVBq2/fQg6tKq/tcvI7StY+tQ1Vf6cDKDoBulta+bUumcVRvvyB6a5jYQLNpjqLeviIGSaN3bsGZRdRQrof51HWWGVoawMskx4zEDkGVubdh1vS/5AZjeYNk5w+GYYGJHQL/U6Huqg+ms+qwY+FrMX3fsXKbJbJW+KHHeHgzictLaloIwR9wv2gOCw0XOaO186T2MuvjGwP6ba1G7xiQtQBncY5dSsCMiJ3hsUAuBdpTJhEcnofIugxeXJhtpgzAQO08fixNzk6X/YGCCoFqNEoYoOFA1mMVsmZF313K+EfcG0yiOsg19qbk7gSP29oSufsa79UVZsdazTleQTAMoF/5hviX9npBARPBxqV51oyx9nlLIFmkhOmE6olYu5nFrNxKast4+7GPkGKP0keWGtT9jgLuKf32G0r2yP0lBiUxysjC1b3fIpNG1nj25zaTGrJIDH79JUgrAG1UvB2RLhnhxpSWeOzmRbv3fCgresc+e7tqHrpumUFu0NIZC5fl6JCLEYggoLKdxgxZL3+dgJtP8CW3HLp+U49kH4NzHr07kGBwXB2aVz1T4J4eN5B9G6Xkf1VAumjuihtbONerqQYMlMROq03nP7JEqNKv2WrHOUbThTxufz+aS2c/k6ODrCwGhdmt7khPhGXqDIF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

[+Cc RT folks]

On Tue, Oct 27, 2026 at 07:00:16AM -0700, Sean Christopherson wrote:
> +slub folks
> 
> On Tue, Oct 27, 2026, Hillf Danton wrote:
> > Ask the locking people to shed light on the warning.
> 
> get_partial_node_bulk() is waiting on a non-raw spinlock while in hard IRQ context,
> and it looks like __refill_objects_node() would do the same later on.  On PREEMPT_RT,
> those spinlocks become sleepable locks, which is what triggers the splat.
> 
> The alloction coming from KVM-as-a-guest code is GFP_ATOMIC, so I think that wonky
> code is fine.

But memory allocation w/ GFP_ATOMIC is fine only on non-RT?

From the documentation:
https://docs.kernel.org/core-api/real-time/differences.html#memory-allocation
> The memory allocation APIs, such as kmalloc() and alloc_pages(),
> require a gfp_t flag to indicate the allocation context.
> On non-PREEMPT_RT kernels, it is necessary to use GFP_ATOMIC when
> allocating memory from interrupt context or from sections where
> preemption is disabled. This is because the allocator must not
> sleep in these contexts waiting for memory to become available.

Here it mentions GFP_ATOMIC allocations in preemption disabled
contexts on non-RT, and...

> However, this approach does not work on PREEMPT_RT kernels.
> The memory allocator in PREEMPT_RT uses sleeping locks internally,
> which cannot be acquired when preemption is disabled.

it says we shoud not allocate memory in such a context on RT?

> Fortunately,
> this is generally not a problem, because PREEMPT_RT moves most contexts
> that would traditionally run with preemption or interrupts disabled
> into threaded context, where sleeping is allowed.

Not sure if this applies here as I don't understand what's
going in in KVM world.

> > > Date: Mon, 26 Oct 2026 03:19:37 -0700	[thread overview]
> > > Hello,
> > > 
> > > syzbot found the following issue on:
> > > 
> > > HEAD commit:    c03c1a14507d Linux 7.3
> > > git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=128d8ca5580000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=129d675874dbf896
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=f11512d1e5878ba5e60e
> > > compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=168d8ca5580000
> > > 
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+f11512d1e5878ba5e60e@syzkaller.appspotmail.com
> > > 
> > > =============================
> > > [ BUG: Invalid wait context ]
> > > syzkaller #0 Tainted: G S                 
> > > -----------------------------
> > > syz-executor177/6041 is trying to lock:
> > > ffff88801d040618 (&n->list_lock){-.-.}-{3:3}, at: get_partial_node_bulk mm/slub.c:3831 [inline]
> > > ffff88801d040618 (&n->list_lock){-.-.}-{3:3}, at: __refill_objects_node+0x104/0xab0 mm/slub.c:7279
> > > other info that might help us debug this:
> > > context-{2:2}
> > > locks held by syz-executor177/6041: 1, last CPU#1:
> > >  #0: ffffffff9090b438 (tomoyo_ss){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:198 [inline]
> > >  #0: ffffffff9090b438 (tomoyo_ss){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:305 [inline]
> > >  #0: ffffffff9090b438 (tomoyo_ss){.+.+}-{0:0}, at: tomoyo_read_lock security/tomoyo/common.h:1112 [inline]
> > >  #0: ffffffff9090b438 (tomoyo_ss){.+.+}-{0:0}, at: tomoyo_check_open_permission+0x169/0x3c0 security/tomoyo/file.c:772
> > > stack backtrace:
> > > CPU: 1 UID: 0 PID: 6041 Comm: syz-executor177 Tainted: G S                  syzkaller #0 PREEMPT(full) 
> > > Tainted: [S]=CPU_OUT_OF_SPEC
> > > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> > > Call Trace:
> > >  <IRQ>
> > >  __dump_stack lib/dump_stack.c:94 [inline]
> > >  dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
> > >  print_lock_invalid_wait_context kernel/locking/lockdep.c:4874 [inline]
> > >  check_wait_context kernel/locking/lockdep.c:4946 [inline]
> > >  __lock_acquire+0xfcc/0x1f40 kernel/locking/lockdep.c:5238
> > >  lock_acquire kernel/locking/lockdep.c:5942 [inline]
> > >  lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
> > >  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:155 [inline]
> > >  _raw_spin_lock_irqsave+0x3a/0x60 kernel/locking/spinlock.c:181
> > >  get_partial_node_bulk mm/slub.c:3831 [inline]
> > >  __refill_objects_node+0x104/0xab0 mm/slub.c:7279
> > >  refill_objects+0x58/0x410 mm/slub.c:7405
> > >  refill_sheaf mm/slub.c:2885 [inline]
> > >  __pcs_replace_empty_main+0x35e/0x650 mm/slub.c:4774
> > >  alloc_from_pcs mm/slub.c:4850 [inline]
> > >  slab_alloc_node mm/slub.c:4984 [inline]
> > >  __kmalloc_cache_noprof+0x4f4/0x6d0 mm/slub.c:5559
> > >  _kmalloc_noprof include/linux/slab.h:991 [inline]
> > >  _kzalloc_noprof include/linux/slab.h:1312 [inline]
> > >  kvm_async_pf_task_wake arch/x86/kernel/kvm.c:224 [inline]
> > >  __sysvec_kvm_asyncpf_interrupt+0x334/0x610 arch/x86/kernel/kvm.c:338
> > >  instr_sysvec_kvm_asyncpf_interrupt arch/x86/kernel/kvm.c:327 [inline]
> > >  sysvec_kvm_asyncpf_interrupt+0x9e/0xc0 arch/x86/kernel/kvm.c:327
> > >  </IRQ>
> > >  <TASK>
> > >  asm_sysvec_kvm_asyncpf_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:753
> > > RIP: 0010:memcmp+0x156/0x1d0 lib/string.c:665
> > > Code: 0f 86 fb fe ff ff 48 89 d8 48 89 de 48 c1 e8 03 83 e6 07 42 0f b6 14 28 48 8d 43 07 48 89 c1 48 c1 e9 03 40 38 f2 40 0f 9e c6 <84> d2 42 0f b6 0c 29 0f 95 c2 40 84 d6 0f 84 45 ff ff ff be 08 00
> > > RSP: 0018:ffffc90003ab7538 EFLAGS: 00000297
> > > RAX: ffff8880220be413 RBX: ffff8880220be40c RCX: 1ffff11004417c82
> > > RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8880220be40c
> > > RBP: ffffffff8c58a940 R08: 0000000000000001 R09: 0000000000000066
> > > R10: 0000000000000066 R11: 0000000000000001 R12: 0000000000000012
> > > R13: dffffc0000000000 R14: dffffc0000000000 R15: 0000000000000000
> > >  strstr+0x109/0x170 lib/string.c:743
> > >  tomoyo_add_entry security/tomoyo/common.c:2157 [inline]
> > >  tomoyo_supervisor+0xf47/0x1340 security/tomoyo/common.c:2238
> > >  tomoyo_audit_path_log security/tomoyo/file.c:169 [inline]
> > >  tomoyo_path_permission security/tomoyo/file.c:592 [inline]
> > >  tomoyo_path_permission+0x270/0x3b0 security/tomoyo/file.c:577
> > >  tomoyo_check_open_permission+0x37f/0x3c0 security/tomoyo/file.c:782
> > >  tomoyo_file_open+0x6b/0x90 security/tomoyo/tomoyo.c:334
> > >  security_file_open+0xb5/0x1e0 security/security.c:2739
> > >  do_dentry_open+0x588/0x14d0 fs/open.c:973
> > >  vfs_open+0x82/0x3f0 fs/open.c:1101
> > >  do_open fs/namei.c:4836 [inline]
> > >  path_openat+0x1a23/0x2450 fs/namei.c:4999
> > >  do_file_open+0x20e/0x430 fs/namei.c:5028
> > >  do_sys_openat2+0x10f/0x1e0 fs/open.c:1417
> > >  do_sys_open fs/open.c:1423 [inline]
> > >  __do_sys_openat fs/open.c:1439 [inline]
> > >  __se_sys_openat fs/open.c:1434 [inline]
> > >  __x64_sys_openat+0x12d/0x210 fs/open.c:1434
> > >  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
> > >  do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
> > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > 

-- 
Cheers,
Harry / Hyeonggon


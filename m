Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6803606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 20:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=X6TQOCuX
Received: by kanga.kvack.org (Postfix)
	id A86A66B08DD; Tue, 27 Oct 2026 16:39:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A38E46B08DF; Tue, 27 Oct 2026 16:39:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 926F46B08E0; Tue, 27 Oct 2026 16:39:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 611F16B08DD
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:39:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D485440B32
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:39:40 +0000 (UTC)
X-FDA: 85369572120.26.AFBEEAF
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf08.hostedemail.com (Postfix) with ESMTP id 06679160006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:39:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793133579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PU/57JgArN8vZg/+OmfFVNbEDBtbhMB2t+hfWrt0DCk=;
	b=nlbQ9Xo2qRWpa0mdSQAJnBdQwm8x9+AwDvtyIwN58C+3wcW5pZ6Hcwwbx4SOi6Z2lq/B4f
	zQMlG2ym/9d/Lw+/7JevUAzpap1KQDpyrzDE1ddkmPMBtUt60oTpd/Q57kiLgnIHmAi1b+
	viSitWQe7vgrsapP8815TsN9QU7REjY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793133579;
	b=gFEfvCkc5ikh35dhdouVUKMLj+/0oJF1oFznqnhI5+uogHJONLIEIgiAJ/dqtYaIevFlZu
	Ecc10JCMETvlyMUEUh0fbHXsLD0/iLD85PUrw2Co1uBxETIa4SmJcrcujU3NJCVaF0+Wcg
	jCmbR2+/dtyuX3L4HOsT7ddA/7T4z+Q=
Received: from omf10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AC9B1C0AD2;
	Tue, 27 Oct 2026 20:39:36 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id E53A032;
	Tue, 27 Oct 2026 20:39:32 +0000 (UTC)
Date: Tue, 27 Oct 2026 16:39:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Harry Yoo <harry@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>, Hillf Danton
 <hdanton@sina.com>, Boqun Feng <boqun@kernel.org>, syzbot
 <syzbot+f11512d1e5878ba5e60e@syzkaller.appspotmail.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Tetsuo Handa
 <penguin-kernel@i-love.sakura.ne.jp>, syzkaller-bugs@googlegroups.com,
 Vlastimil Babka <vbabka@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, linux-mm@kvack.org, Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>,
 linux-rt-devel@lists.linux.dev
Subject: Re: [syzbot] [kvm?] WARNING: locking bug in __refill_objects_node
Message-ID: <20261027163929.2bb28d5b@gandalf.local.home>
In-Reply-To: <auDvUyfzg6nLtVox@thinkstation>
References: <6adf2939.67317f00.38c4bc.00ae.GAE@google.com>
	<20261026224305.1254-1-hdanton@sina.com>
	<auCucDdZb8mig7UZ@google.com>
	<auDvUyfzg6nLtVox@thinkstation>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19Ldja3aL00IVo0m19FVtsYl3nWaEoYns4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=PU/57JgArN8vZg/+OmfFVNbEDBtbhMB2t+hfWrt0DCk=; b=X6TQOCuX6HY8UuLPJKhZELCrhP44xJqMxzfzL2+ztGf3IByei8fpiiT1ZEws9aWOLnW8kSkpa0UjfCPFcyWg9jpmR3F40c11qrutkSjoEcbAqlr8jfKEayHwf/xdt8rWDLtuS1DAwSqBSUG2rZm0ZfNag49zetLEpH83o+XiZgg=
X-HE-Meta: U2FsdGVkX1871MrZb0tFG/W2SlYb1SjhIrGoSAvboTl6u8SaPNgiz5BOiVch1cvc0Qbf4ADrK5lONedBMZm25LrUJz8QavUN1j5JXBAE7n+VSxahxbdOqagmMhZqQrsP6uPSodnDGcVrfOKIomnCaeotGRJOjK8HNkD25W+2YwtKH1wPqFVI8B1wfX4bhVjz71mVKzXoE+cfnAQHjgUba4+o3mDe/0lRn7D6pdJ+Jte1wwdlNCMhxaCNzrE8SofbaYxvrsl/8k+hbAQZ8+7QJGZI5XlRMfLp2izbfp6vMhqBGfhKtSQUUPw3Qp0gKV+cxeLwP+ilCnZKrgYqG3iqTSuxSYBL0JB5yJrR47ClhmGqs6SA4ZLrbnzFjhd/50EKOHuJ1sGvdMF747dl2CjBIRkE1SP49IsLg/5I/TnsbnHpK2wFU3qr7YFO+ueri1TgRNADnIF/OuBMS04xTdprp6HkOIt0fDmam8S09544yNE=
X-Rspamd-Queue-Id: 06679160006
X-Rspamd-Server: rspam06
X-Stat-Signature: 3f57e8x951dh1yau1ujtzp5h68dfia1m
X-HE-Tag-Orig: 1793133572-819488
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793133578-298060
X-HE-Meta: U2FsdGVkX1+xJ3TG7c1oShh9twPMTfvALMFjbmUGF4Sq60Ky9Io8e4VqzE9Luo0bte3+lMfmCWFGsYXqsgJzXbIkcVm79oc/wzcjIw7hOn9TTt0g6UvovF9Vwx6W8yW9l6ODbYeFYFyL358Cl8u+8O8UGq87v4a2CdbdsYFn3PMkn6tcBi8XMuPfDSRTQ3oGABvQKJfuO1pMt4x3ErWe5wjr7teOrVMtydWTEtFClQGpzsrFbGOtdnCFmGg7pthNlGSBoC78E91f5mAdGYma97jPQZNVoyM+Sf6n8t3Gb7CHBPkztVhUf0KrotJRG2vcEl7VGM2ChtZjbpxSmCo7wjarCCtY5tINHYaPHsscHrFGrBwnUEd0uRQ47dMNWnig2hVlxWqYdyatSJXTDBSiZ0ReHPX0zEfZkLQ77qww+VCpfxCFCY4cUmhCE9pMU3dNp9wtJiQy5OnLJRDLayMJmeb6yKAKf+hs7QydEfm/anqHqK9RO9rSIMAWMwjYG5YlDNLmA9Cw4nrawjrSVp0j+XLZrRozi+E+Jzuc5Y55OQA6sKILHSL/aUO1afNqEJHiHsW9duaee2aKAXOt7ecnGSWjivO/n+NSuTTuVQS5bVB4wsQMqqvJKbP2mRS7KxQsyzYJQyT4SRs/fJgd2rpQw+Fy5pnOY+zGfHQG/3YaPXqYjeNNphmB9bh2VJi4hBUCuFhPLkTC740evqb83XzjZrnbwBO/BADXRHKk+zScwXsCQoeG5h1s7tKgi1Rpa+GQuc++JcKykfh76Nz37ooTvv0n7xAfaABGyP29pnyoVUu5bkyz72Hz+zg93jw05bSkmN8Sk1otg5f7BRxxC10YirUOPR8BSFLq7l+Ipx9FDpoixjOJ4q2zVOOx1zhTeD20d0HvTASt1tCBa9jQaSXPLRvBiUkT3tKWowHnDZ/Unx5Bflj48R+OiBhxkg2mqKvD4w8GRtD5ttfoJ/USiXW
 dtn98Y0m
 5vu0fbLkI+KpU6Y4Lc6xGvZEmFC+r30IVFpuimtS5/c727T4jLojzq401XBpqLsquPDXE5lSHm5mCLhNdnhgZ4KJHa44rsNIVioGNNoBHWbeSZaJgk2/mzpgJA1EnWfxq+uJxeL3qy8WIrIaYNghEZnG5cKghijmpEnSJyRfFxb5ywwD8aDd1zc9AU5RfI+71El4l73mEcauaT0bO1wiFmccU4VKWwmI8kF6DZPgapbSLCc7LO5m6YlvvN3fTkfKPGLG9x1aLIsui9h8nUQPKNK0TpIoDiLERLAT+8NfuhQSxYY6xnydTCifLkpkbtwledv3Us9bwHB0Ff00zQ8068Fqfxx3CDAipPIzg0mCOzGIqc29l1Y6xawC/cUwfViyCYQ2RelbGHmdfFVidDrkMYSlUfdmFFuG8H6N/j8Qo5y/d8ULj6sCmVGPcjYiCcRrST2K2rI72b3sLysMyzHnDcCyS6JcpCKvGn/ddImm0XYN8G9HCbEgsgRZXBdEZ9PoIJh0ruV2zTM+7eC8cfTIkrlTFxItZl3pSjlpA2baWFOjklf0YcoXZDgPAdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 27 Oct 2026 18:48:28 +0000
Harry Yoo <harry@kernel.org> wrote:

> [+Cc RT folks]
> 
> On Tue, Oct 27, 2026 at 07:00:16AM -0700, Sean Christopherson wrote:
> > +slub folks
> > 
> > On Tue, Oct 27, 2026, Hillf Danton wrote:  
> > > Ask the locking people to shed light on the warning.  
> > 
> > get_partial_node_bulk() is waiting on a non-raw spinlock while in hard IRQ context,
> > and it looks like __refill_objects_node() would do the same later on.  On PREEMPT_RT,
> > those spinlocks become sleepable locks, which is what triggers the splat.
> > 
> > The alloction coming from KVM-as-a-guest code is GFP_ATOMIC, so I think that wonky
> > code is fine.  
> 
> But memory allocation w/ GFP_ATOMIC is fine only on non-RT?

Correct. GFP_ATOMIC is meaningless on RT. It still cannot be called with
preemption disabled. Most places that disable preemption in the non-RT case
do not disable it in the RT case. For example, spin_lock() disables
preemption on non-RT but does not in RT. Same for interrupt handlers, as in
RT interrupt handlers are run in task context.

That is, in RT only "special" places disable preemption for real.

> 
> >From the documentation:  
> https://docs.kernel.org/core-api/real-time/differences.html#memory-allocation
> > The memory allocation APIs, such as kmalloc() and alloc_pages(),
> > require a gfp_t flag to indicate the allocation context.
> > On non-PREEMPT_RT kernels, it is necessary to use GFP_ATOMIC when
> > allocating memory from interrupt context or from sections where
> > preemption is disabled. This is because the allocator must not
> > sleep in these contexts waiting for memory to become available.  
> 
> Here it mentions GFP_ATOMIC allocations in preemption disabled
> contexts on non-RT, and...
> 
> > However, this approach does not work on PREEMPT_RT kernels.
> > The memory allocator in PREEMPT_RT uses sleeping locks internally,
> > which cannot be acquired when preemption is disabled.  
> 
> it says we shoud not allocate memory in such a context on RT?
> 
> > Fortunately,
> > this is generally not a problem, because PREEMPT_RT moves most contexts
> > that would traditionally run with preemption or interrupts disabled
> > into threaded context, where sleeping is allowed.  
> 
> Not sure if this applies here as I don't understand what's
> going in in KVM world.
> 
> > > > Date: Mon, 26 Oct 2026 03:19:37 -0700	[thread overview]
> > > > Hello,
> > > > 
> > > > syzbot found the following issue on:
> > > > 
> > > > HEAD commit:    c03c1a14507d Linux 7.3
> > > > git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=128d8ca5580000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=129d675874dbf896
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=f11512d1e5878ba5e60e
> > > > compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=168d8ca5580000
> > > > 
> > > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > > Reported-by: syzbot+f11512d1e5878ba5e60e@syzkaller.appspotmail.com
> > > > 
> > > > =============================
> > > > [ BUG: Invalid wait context ]
> > > > syzkaller #0 Tainted: G S                 
> > > > -----------------------------
> > > > syz-executor177/6041 is trying to lock:
> > > > ffff88801d040618 (&n->list_lock){-.-.}-{3:3}, at: get_partial_node_bulk mm/slub.c:3831 [inline]
> > > > ffff88801d040618 (&n->list_lock){-.-.}-{3:3}, at: __refill_objects_node+0x104/0xab0 mm/slub.c:7279
> > > > other info that might help us debug this:
> > > > context-{2:2}
> > > > locks held by syz-executor177/6041: 1, last CPU#1:
> > > >  #0: ffffffff9090b438 (tomoyo_ss){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:198 [inline]
> > > >  #0: ffffffff9090b438 (tomoyo_ss){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:305 [inline]
> > > >  #0: ffffffff9090b438 (tomoyo_ss){.+.+}-{0:0}, at: tomoyo_read_lock security/tomoyo/common.h:1112 [inline]
> > > >  #0: ffffffff9090b438 (tomoyo_ss){.+.+}-{0:0}, at: tomoyo_check_open_permission+0x169/0x3c0 security/tomoyo/file.c:772
> > > > stack backtrace:
> > > > CPU: 1 UID: 0 PID: 6041 Comm: syz-executor177 Tainted: G S                  syzkaller #0 PREEMPT(full) 
> > > > Tainted: [S]=CPU_OUT_OF_SPEC
> > > > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> > > > Call Trace:
> > > >  <IRQ>
> > > >  __dump_stack lib/dump_stack.c:94 [inline]
> > > >  dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
> > > >  print_lock_invalid_wait_context kernel/locking/lockdep.c:4874 [inline]
> > > >  check_wait_context kernel/locking/lockdep.c:4946 [inline]
> > > >  __lock_acquire+0xfcc/0x1f40 kernel/locking/lockdep.c:5238
> > > >  lock_acquire kernel/locking/lockdep.c:5942 [inline]
> > > >  lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
> > > >  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:155 [inline]
> > > >  _raw_spin_lock_irqsave+0x3a/0x60 kernel/locking/spinlock.c:181
> > > >  get_partial_node_bulk mm/slub.c:3831 [inline]
> > > >  __refill_objects_node+0x104/0xab0 mm/slub.c:7279
> > > >  refill_objects+0x58/0x410 mm/slub.c:7405
> > > >  refill_sheaf mm/slub.c:2885 [inline]
> > > >  __pcs_replace_empty_main+0x35e/0x650 mm/slub.c:4774
> > > >  alloc_from_pcs mm/slub.c:4850 [inline]
> > > >  slab_alloc_node mm/slub.c:4984 [inline]
> > > >  __kmalloc_cache_noprof+0x4f4/0x6d0 mm/slub.c:5559
> > > >  _kmalloc_noprof include/linux/slab.h:991 [inline]
> > > >  _kzalloc_noprof include/linux/slab.h:1312 [inline]
> > > >  kvm_async_pf_task_wake arch/x86/kernel/kvm.c:224 [inline]

Hmm, this part is OK:

                if (!dummy) {
                        raw_spin_unlock(&b->lock);
                        dummy = kzalloc_obj(*dummy, GFP_ATOMIC);

As it releases the raw_spin_lock() before calling kzalloc_obj().

So something else must have disabled preemption/interrupts.

> > > >  __sysvec_kvm_asyncpf_interrupt+0x334/0x610 arch/x86/kernel/kvm.c:338

DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_asyncpf_interrupt)
{       
        struct pt_regs *old_regs = set_irq_regs(regs);
        u32 token;
                
        apic_eoi();

        inc_irq_stat(HYPERVISOR_CALLBACK);

        if (__this_cpu_read(async_pf_enabled)) {
                token = __this_cpu_read(apf_reason.token);
                kvm_async_pf_task_wake(token);
                __this_cpu_write(apf_reason.token, 0);
                wrmsrq(MSR_KVM_ASYNC_PF_ACK, 1);
        }

        set_irq_regs(old_regs);
}


Is that run in hard interrupt context? If so, we need to make that a thread
for RT kernels if you want to call kzalloc_obj().

-- Steve


> > > >  instr_sysvec_kvm_asyncpf_interrupt arch/x86/kernel/kvm.c:327 [inline]
> > > >  sysvec_kvm_asyncpf_interrupt+0x9e/0xc0 arch/x86/kernel/kvm.c:327
> > > >  </IRQ>
> > > >  <TASK>
> > > >  asm_sysvec_kvm_asyncpf_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:753
> > > > RIP: 0010:memcmp+0x156/0x1d0 lib/string.c:665
> > > > Code: 0f 86 fb fe ff ff 48 89 d8 48 89 de 48 c1 e8 03 83 e6 07 42 0f b6 14 28 48 8d 43 07 48 89 c1 48 c1 e9 03 40 38 f2 40 0f 9e c6 <84> d2 42 0f b6 0c 29 0f 95 c2 40 84 d6 0f 84 45 ff ff ff be 08 00
> > > > RSP: 0018:ffffc90003ab7538 EFLAGS: 00000297
> > > > RAX: ffff8880220be413 RBX: ffff8880220be40c RCX: 1ffff11004417c82
> > > > RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8880220be40c
> > > > RBP: ffffffff8c58a940 R08: 0000000000000001 R09: 0000000000000066
> > > > R10: 0000000000000066 R11: 0000000000000001 R12: 0000000000000012
> > > > R13: dffffc0000000000 R14: dffffc0000000000 R15: 0000000000000000
> > > >  strstr+0x109/0x170 lib/string.c:743
> > > >  tomoyo_add_entry security/tomoyo/common.c:2157 [inline]
> > > >  tomoyo_supervisor+0xf47/0x1340 security/tomoyo/common.c:2238
> > > >  tomoyo_audit_path_log security/tomoyo/file.c:169 [inline]
> > > >  tomoyo_path_permission security/tomoyo/file.c:592 [inline]
> > > >  tomoyo_path_permission+0x270/0x3b0 security/tomoyo/file.c:577
> > > >  tomoyo_check_open_permission+0x37f/0x3c0 security/tomoyo/file.c:782
> > > >  tomoyo_file_open+0x6b/0x90 security/tomoyo/tomoyo.c:334
> > > >  security_file_open+0xb5/0x1e0 security/security.c:2739
> > > >  do_dentry_open+0x588/0x14d0 fs/open.c:973
> > > >  vfs_open+0x82/0x3f0 fs/open.c:1101
> > > >  do_open fs/namei.c:4836 [inline]
> > > >  path_openat+0x1a23/0x2450 fs/namei.c:4999
> > > >  do_file_open+0x20e/0x430 fs/namei.c:5028
> > > >  do_sys_openat2+0x10f/0x1e0 fs/open.c:1417
> > > >  do_sys_open fs/open.c:1423 [inline]
> > > >  __do_sys_openat fs/open.c:1439 [inline]
> > > >  __se_sys_openat fs/open.c:1434 [inline]
> > > >  __x64_sys_openat+0x12d/0x210 fs/open.c:1434
> > > >  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
> > > >  do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
> > > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f  
> > >   
> 



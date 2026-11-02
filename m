Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8A06606B1C9
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 17:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=B71LjEG0
Received: by kanga.kvack.org (Postfix)
	id 1AAAE6B05B4; Mon,  2 Nov 2026 12:43:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 183BC6B05B5; Mon,  2 Nov 2026 12:43:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 072E36B05B6; Mon,  2 Nov 2026 12:43:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CF5A26B05B4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:43:39 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 779EA401E5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:43:39 +0000 (UTC)
X-FDA: 85390901358.22.518E88D
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf25.hostedemail.com (Postfix) with ESMTP id C3CA2A0008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:43:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=B71LjEG0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3yMvoagYKCGERD9MIBFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--seanjc.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3yMvoagYKCGERD9MIBFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793641417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=raeJlK9yYBGSF7+QYGBqsG5Ux8i2znTMcBRplAhhHPo=;
	b=7yb53bG8gFxtsyJfIWveCVaWxSSGjDV9IEqUciY3Px62sZLzNbowB9on9MRlcaxT3ZdcA/
	J0oFzaHUcad4ArtzUtDat7Jt9FjgtQsi+8VfwkDWdjQZgc+o2nTSsLaNxQnb4VBDYyMrlw
	VGBCCV3CeYdTKfTod0Ec3sKdz+xH9xI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793641417;
	b=0upc7COZyTobK/8ARPmQtOiIZXumlg2uyyQImAhWZ2dTZYp2gRWmVKOSehh4fe9y1GcVH8
	KY5quqHk1udJlZQXLqYH2GZyoGe+Dd44tBx/8A1MxPF94Gvmz4PDoxOD55B0bCGPptCnpR
	gfHMpNGYszc/G1pBhQC7aGdHOqKDw4o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=B71LjEG0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3yMvoagYKCGERD9MIBFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--seanjc.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3yMvoagYKCGERD9MIBFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--seanjc.bounces.google.com
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e869e00005so51783095ad.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 09:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793641417; x=1794246217; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=raeJlK9yYBGSF7+QYGBqsG5Ux8i2znTMcBRplAhhHPo=;
        b=B71LjEG0zACe4SHG6h+kIEI5HjEsshaqVSy9ITaE4fEkkzepcOs3N3EEEMbP0S6UIq
         IP8Fy0EEKLh4tOHS/4CRmIEUyzYDqAM2kPRg8/0j3upwsNPpyAwGsM97BSXVYnSAOrkB
         Q0E3YwJGrj1boHfryThRW5G04Sa1F9MPhgVolSrkiSVfuUp3TmShDC7mlpSIG+v2vl44
         CT0w+IhFLEc5j5VFzfIZnDssi37XnBs6CeHTa2oNbRctfCdzAPk+oHbmB9/cTjUvCac6
         1LyvHRNuWahw9dJxO+rB0X10e4XNP+8JQtStfqsFwiNlbXJVABVf1WnSxMhCCixrN/lG
         pwPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793641417; x=1794246217;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=raeJlK9yYBGSF7+QYGBqsG5Ux8i2znTMcBRplAhhHPo=;
        b=0SaS29UkxYImKWr8fyslE5cq9X4LgAW/1LkqKrw8WENGoV5xTWx3KwTKOj99jClUxN
         3DWBQsojAVONvX0Fu9x7c0DzrVettI+Mdv3XKM1XxPNF2FHjZYcW2Hf1WTz2oIJtRSyt
         0qPKldDAyd4kxfdMXfyWIVqX2gKRc4vq9+e5SCpbXCEONU0ILA2TdZreKo429ahRHHJB
         404FxrrD5gqK6s3wE8VQwhBte3eoGJ6z2+8HwK25d9xrH0JtQxlwuT5RZzUoqXFx9SlX
         n0tejRkTTwqSc0t5yVLLpiMHIVAsGK/jppMtiNbnMGJnh+swnsgitI3y1Odh84y6sVB5
         6TDQ==
X-Forwarded-Encrypted: i=1; AKwUvBxh9JzYp5LuUQeYq/9nerG7MfHImGZavOx7EWmxatWrVToRhjwrE+nH08qholIjhZYaqHHvABHbbw==@kvack.org
X-Gm-Message-State: APuU4Z8pf3Ge/NKRIxY8IHZ0VkffyD6KQ1CiUA73DYp9Alfs5Ydh00Pn
	AMEwi5mMocGX01MqeLyOXRGxVDFzszLfcocFvtY+s165DHSoO6Dg2phpfilC3hDteA6id4wlG8N
	c90Q9YQ==
X-Received: from plkg13.prod.google.com ([2002:a17:903:19cd:b0:2e8:1f84:7c18])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ea0d:b0:2e8:1d5c:f6f9
 with SMTP id d9443c01a7336-2eb364715ddmr105628745ad.46.1793641416165; Mon, 02
 Nov 2026 09:43:36 -0800 (PST)
Date: Mon, 2 Nov 2026 09:43:35 -0800
In-Reply-To: <20261027163929.2bb28d5b@gandalf.local.home>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <6adf2939.67317f00.38c4bc.00ae.GAE@google.com> <20261026224305.1254-1-hdanton@sina.com>
 <auCucDdZb8mig7UZ@google.com> <auDvUyfzg6nLtVox@thinkstation> <20261027163929.2bb28d5b@gandalf.local.home>
Message-ID: <aujLx1FOc12E72rF@google.com>
Subject: Re: [syzbot] [kvm?] WARNING: locking bug in __refill_objects_node
From: Sean Christopherson <seanjc@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Harry Yoo <harry@kernel.org>, Hillf Danton <hdanton@sina.com>, Boqun Feng <boqun@kernel.org>, 
	syzbot <syzbot+f11512d1e5878ba5e60e@syzkaller.appspotmail.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, syzkaller-bugs@googlegroups.com, 
	Vlastimil Babka <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	linux-rt-devel@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: 73t9ccnnd3duz14cdr7rptiaqcgmkm6p
X-Rspam-User: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C3CA2A0008
X-HE-Tag: 1793641417-667160
X-HE-Meta: U2FsdGVkX1/X6sKvtMtb1zxSLNx6YPsoq8W9Hzs/elOhwuyiVpgZseA8UamcOpsXEIzb+IGJ+BDiRLyyGGQwMuYfSVCbrCnbK9vZdJZJi733uHAlZZreFFPrb+savI8JVVdBzU4gM1gThQ3p9cDN1Hc0W1PPwjAEWse/JB3WZXtXYTmlKkeahc/JftSulapDUsO01OzUyQJmgDaq9SwaHcPuHsn0xjm95IICPrRkMTaEcC5/kxk8y8001t0TNKCu6yMf/ei+OiNZy86b5GOUWiszB5Ly0xqRcxPY6Rj93MqeJWZgDSaLCZ0NHxZrKtNVhAU/qWphALxPKSJewmq/DFizFUTQUFmLusVMWveY45kmaA10my4sDSDEzBY0mgOx11Bfy92C6boTnIux4qhJqnq1jDq6R/Q41DMn40unsbEOlvD6TM3GYsx9LfkrGXeAho6FeE/sYBRood+cD9hOy4vMOpH3+8eQzKa0LtFsv3UxZ3fGAjCpISNslx85bn6n8Eyhpv3l4DGpwEcoPLFKoESIfpNz8gtJdvI9c/bYcVg21v8uM1ewNa/9yUkSp0tA70S03goMXeXqJj9EtjlWGosq7Yavrvi0YVOnarItaURnEJ6s93gGUdUSOI+66pujMn7/L0zdYtkUOq4PIfPVzhARBYglk3dJ1g2z1IGMWd5jn882Dc29i9mgsP8R+m4CT6NGudQXMLA1vQtfXBopqmYmR1k4uf8vIMDmr02FqqJbqCAbgyv9699t/ET+7xbf/0VQODRp8oDKEfkzK1QR9HkgTSC2dBkSOtWUZPwdO5EdUZIilbwCk5x8jH56BaFKlTW4/Yx91mSbPBBozHR8Armjj3JqXWNhPOQ6KmbKNoM2qpOGpyVfkMpVpptbk4KQPgI807TElzPThV+fj39I9iagpl1oXtEa8rQ7bDyBQLmT/0vQfDmlA6t11T0c3sfrvDxe8VECdze670l+LmL
 G/1GP9hz
 8dcuq3Rhk7nPpx8PDcR9O2MT+qK++SwTECl1LQ1+QhDM0zDzHr4y8ourW4F0bXiorhSPNkWrBVy7lT1QwqAqwzLrmZAmiUKH1F8cDCk8WQItPCZzrSlnIBm4i+wuecsDtvl9rSEbv49vxdaPPBqJ3euRhyx6juX6EXLQGRDTYVUwree8azWXlX3HBQ5lp8nWQszUYldpKk9c3wYrcmzbU51elerpsRXph38G0sMkFs2r/piyNmUWRR8ApW55REl+7NyjDFJEYLScjKJnnihhpsP5B5pZgeYxtSOKVZ3Yy4N9DNaKPbC8CqzqSWyaF+oNHq0vZ4EnY7c9Waty+Ki1lzvInjXEi1WLyPBFNHLj/Y2WLBoitn82abFtG5Cx3fnA0PTOKdYVAbQdpb4LBVDkmzxtOCfqHSPLQnw6K4tTd56Wqcr5VNgdtnQ0iZXzIdMjxPSguWcRLwsbpOtoj5d/RjP2uVmRxclgfS0WntTtiLs7BDBkWgjQBBZdf2RienLJIJz/NiuF9pnz7BoK4Hpt2MoAZMamZYCUj1OxAbwzYkCRvtgFvoSFftTVNIJh2sbZFUC5aaaToe4zleYFQ6BgUwO0QPR2V4bN/jLKYzNW8tHvd9CBdQhOZ+a7vZARjbmDQZrSgiS/O8LKJxnCDbkx0Mke/XwR+xPHE1aGnqvCRoHroE3DG5SOZHXQNEo2on1hHof2Sx941jbdMV7uytTpsBmfneAt7/02hP/X25uCRv7rnW2QcEiCHuozDeMv7DHcyH6230+9DgW5YoVIuob9nTDvs49RnTqrAD6sPUoH7J8/K1T+0rE51NvwEQmo0ZbPM4NQd3iZiVFby4lewV6dFPf1zfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

+Paolo

On Tue, Oct 27, 2026, Steven Rostedt wrote:
> On Tue, 27 Oct 2026 18:48:28 +0000
> Harry Yoo <harry@kernel.org> wrote:
> 
> > [+Cc RT folks]
> > 
> > On Tue, Oct 27, 2026 at 07:00:16AM -0700, Sean Christopherson wrote:
> > > +slub folks
> > > 
> > > On Tue, Oct 27, 2026, Hillf Danton wrote:  
> > > > Ask the locking people to shed light on the warning.  
> > > 
> > > get_partial_node_bulk() is waiting on a non-raw spinlock while in hard IRQ context,
> > > and it looks like __refill_objects_node() would do the same later on.  On PREEMPT_RT,
> > > those spinlocks become sleepable locks, which is what triggers the splat.
> > > 
> > > The alloction coming from KVM-as-a-guest code is GFP_ATOMIC, so I think that wonky
> > > code is fine.  
> > 
> > But memory allocation w/ GFP_ATOMIC is fine only on non-RT?
> 
> Correct. GFP_ATOMIC is meaningless on RT. It still cannot be called with
> preemption disabled. Most places that disable preemption in the non-RT case
> do not disable it in the RT case. For example, spin_lock() disables
> preemption on non-RT but does not in RT. Same for interrupt handlers, as in
> RT interrupt handlers are run in task context.
> 
> That is, in RT only "special" places disable preemption for real.

...

> > > > > =============================
> > > > > [ BUG: Invalid wait context ]
> > > > > syzkaller #0 Tainted: G S                 
> > > > > -----------------------------
> > > > > syz-executor177/6041 is trying to lock:
> > > > > ffff88801d040618 (&n->list_lock){-.-.}-{3:3}, at: get_partial_node_bulk mm/slub.c:3831 [inline]
> > > > > ffff88801d040618 (&n->list_lock){-.-.}-{3:3}, at: __refill_objects_node+0x104/0xab0 mm/slub.c:7279
> > > > > other info that might help us debug this:
> > > > > context-{2:2}
> > > > > locks held by syz-executor177/6041: 1, last CPU#1:
> > > > >  #0: ffffffff9090b438 (tomoyo_ss){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:198 [inline]
> > > > >  #0: ffffffff9090b438 (tomoyo_ss){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:305 [inline]
> > > > >  #0: ffffffff9090b438 (tomoyo_ss){.+.+}-{0:0}, at: tomoyo_read_lock security/tomoyo/common.h:1112 [inline]
> > > > >  #0: ffffffff9090b438 (tomoyo_ss){.+.+}-{0:0}, at: tomoyo_check_open_permission+0x169/0x3c0 security/tomoyo/file.c:772
> > > > > stack backtrace:
> > > > > CPU: 1 UID: 0 PID: 6041 Comm: syz-executor177 Tainted: G S                  syzkaller #0 PREEMPT(full) 
> > > > > Tainted: [S]=CPU_OUT_OF_SPEC
> > > > > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> > > > > Call Trace:
> > > > >  <IRQ>
> > > > >  __dump_stack lib/dump_stack.c:94 [inline]
> > > > >  dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
> > > > >  print_lock_invalid_wait_context kernel/locking/lockdep.c:4874 [inline]
> > > > >  check_wait_context kernel/locking/lockdep.c:4946 [inline]
> > > > >  __lock_acquire+0xfcc/0x1f40 kernel/locking/lockdep.c:5238
> > > > >  lock_acquire kernel/locking/lockdep.c:5942 [inline]
> > > > >  lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
> > > > >  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:155 [inline]
> > > > >  _raw_spin_lock_irqsave+0x3a/0x60 kernel/locking/spinlock.c:181
> > > > >  get_partial_node_bulk mm/slub.c:3831 [inline]
> > > > >  __refill_objects_node+0x104/0xab0 mm/slub.c:7279
> > > > >  refill_objects+0x58/0x410 mm/slub.c:7405
> > > > >  refill_sheaf mm/slub.c:2885 [inline]
> > > > >  __pcs_replace_empty_main+0x35e/0x650 mm/slub.c:4774
> > > > >  alloc_from_pcs mm/slub.c:4850 [inline]
> > > > >  slab_alloc_node mm/slub.c:4984 [inline]
> > > > >  __kmalloc_cache_noprof+0x4f4/0x6d0 mm/slub.c:5559
> > > > >  _kmalloc_noprof include/linux/slab.h:991 [inline]
> > > > >  _kzalloc_noprof include/linux/slab.h:1312 [inline]
> > > > >  kvm_async_pf_task_wake arch/x86/kernel/kvm.c:224 [inline]
> 
> Hmm, this part is OK:
> 
>                 if (!dummy) {
>                         raw_spin_unlock(&b->lock);
>                         dummy = kzalloc_obj(*dummy, GFP_ATOMIC);
> 
> As it releases the raw_spin_lock() before calling kzalloc_obj().
> 
> So something else must have disabled preemption/interrupts.

Heh, yeah, the IRQ that kicked all of this off.

> > > > >  __sysvec_kvm_asyncpf_interrupt+0x334/0x610 arch/x86/kernel/kvm.c:338
> 
> DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_asyncpf_interrupt)
> {       
>         struct pt_regs *old_regs = set_irq_regs(regs);
>         u32 token;
>                 
>         apic_eoi();
> 
>         inc_irq_stat(HYPERVISOR_CALLBACK);
> 
>         if (__this_cpu_read(async_pf_enabled)) {
>                 token = __this_cpu_read(apf_reason.token);
>                 kvm_async_pf_task_wake(token);
>                 __this_cpu_write(apf_reason.token, 0);
>                 wrmsrq(MSR_KVM_ASYNC_PF_ACK, 1);
>         }
> 
>         set_irq_regs(old_regs);
> }
> 
> 
> Is that run in hard interrupt context?

Yep.

> If so, we need to make that a thread for RT kernels if you want to call
> kzalloc_obj().

Eww.  I can't imagine there's a sane usecase for memory overcommitting a real-time
guest.  I'd rather just disable PV async #PF support, e.g.

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 6b0a5861ccb8..b14b03720525 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -51,7 +51,7 @@
 
 DEFINE_STATIC_KEY_FALSE_RO(kvm_async_pf_enabled);
 
-static int kvmapf = 1;
+static int kvmapf = !IS_ENABLED(CONFIG_PREEMPT_RT);
 
 static int __init parse_no_kvmapf(char *arg)
 {


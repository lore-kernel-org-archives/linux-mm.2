Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 855C3CE7B13
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:02:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA0DA8E000F; Fri, 14 Nov 2025 10:02:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B51508E0002; Fri, 14 Nov 2025 10:02:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A19228E000F; Fri, 14 Nov 2025 10:02:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 82EEA8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:02:35 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 056F114040B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:02:35 +0000 (UTC)
X-FDA: 84109529070.03.DA69EE3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id EB4251C0012
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:02:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SLgY1OQk;
	spf=pass (imf18.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763132553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VPEKe2aWeJhzTD94BJG7E3UwaiNGJjDSNBJQGboK2dY=;
	b=EJau2ZAvQ1jbw2F3M8u0MxRwWgooDaMSTGb+/QaciQ4694/+kSHwoVv6FoOPJl1C8DOVvN
	7Kx1FNDAWJ+cyZdw9AXyoEas47eqV16TNUzJSz8hF3hQxUGRERNW0ug+P5Oib/byI0m475
	Z7mzYpXONxgoJkPICgK1ciuAQN94L90=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SLgY1OQk;
	spf=pass (imf18.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763132553; a=rsa-sha256;
	cv=none;
	b=69P6e0PQIqNt/ifydSqQTHKEY7q/wiFVo8fraRDOYcG9O4RqZ/n+sPJq3hxI4Ku/nE4hGk
	IWlD9ZDRoYhE0awOZuaZ/ZAUI4m625wmjPxQP+8VPCXZvWbMsEksDl6q0FBlklKalRJ9e5
	EuSbe3IYJRQMBUmo9vU7CtITRo8ZfCM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763132552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VPEKe2aWeJhzTD94BJG7E3UwaiNGJjDSNBJQGboK2dY=;
	b=SLgY1OQk4TDp3P9uY9OdMUZCT/98z642rKSCQxGD9PxRMxdzCpmjpeAgRzGWInxS6IG76r
	3FkK7TrsUYoxUKOKH8SSp2QAFGYlQ9E6jLT72T8+5IXtya48/mFO3+VyRffl+7E4qMoGk8
	CS4PLlREoL7BEnhRPTEw1qkGLbQhzE0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-680-G-Yg8Hl9PEyc9x_-gEcoyQ-1; Fri,
 14 Nov 2025 10:02:28 -0500
X-MC-Unique: G-Yg8Hl9PEyc9x_-gEcoyQ-1
X-Mimecast-MFC-AGG-ID: G-Yg8Hl9PEyc9x_-gEcoyQ_1763132541
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6936B1956070;
	Fri, 14 Nov 2025 15:02:19 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A031E1956046;
	Fri, 14 Nov 2025 15:02:01 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rcu@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Han Shen <shenhan@google.com>,
	Rik van Riel <riel@surriel.com>,
	Jann Horn <jannh@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Clark Williams <williams@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Petr Tesarik <ptesarik@suse.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: [PATCH v7 00/31] context_tracking,x86: Defer some IPIs until a user->kernel transition
Date: Fri, 14 Nov 2025 16:01:02 +0100
Message-ID: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EB4251C0012
X-Stat-Signature: xx6emp3nd9huxshw48gwzb5ismmhgmkx
X-Rspam-User: 
X-HE-Tag: 1763132552-935503
X-HE-Meta: U2FsdGVkX1/PVeFm+nvRvmk4la/+X2p6IzR6MSucJfn2fCDB4rDT6CcQUfnpkjeKVPiGQB6mRl2wu5AMOWj3U3llY42fRkPeAaxprctN3vERvW0h5ymkevNMQxMeDy/EaIWn66m5hoBWhLFqQrkrw6K0Z1z+UzBya8+8ua1UoiiNQ92+715czgvo7NTjz5rnu8v2NLBcDVYGxCtyTppg2w6b/MyneF7iYRWFYwLX33GXOEL03OpzpLJLVb29NwhT05BkksIIeZi09XKt6NCDzz/rkEMZ7juVv/MEmwCwDhaUnSt0lvcKLA+byPRCAZ7ATsa28/ue2L/KDkUg1Vc+siCuDwK81nwxoCOIBxnECnWg2LWz4ehZJUrM3zY4xB2IMsIWB6T8JfH87H1RU8RNcaiVaFy2hDge7k6tHwXl1hNaE6OlQzYhtoZ689AgcQb0z26OfW3GnnaxMJ+je3pG5jai3sNR59jBANmJhbHcKnNRuxuCz2+Aipmpf0rssTisnS7keeRPKztc+rWBId88fA+Aq5h9HFFF2NwT+EutfKkH8RSZbX3eQKlZqoDbRQXXdqSXQ5hgSoZp1YTQ6CZRvQxrr/KvcsKuGEElXs0k1nTMuO9WMIAS5Nc6lJRQQLs6TOj7jf7O8EMlbeOYp3EekS02jNG/pui+ko8AmLegnVA5qJgQyH74CnyyF6pZT5vKRvPC41O9CAgc7MCBcp/h4+GtAPk34MDDibY9QylkyUkbxXIExaS7hiyl5Cm489aYhRC1Bkz/wnsw9hGDLKBRGkBjcuy2H2IouQ+PRhK4PL8w+2H53APs+SNbnQ3X8P8Cs+nLA/3lCc5qMLTgKuiZOVKRzSc2ffBvl4DxoAINMTkbTbsV2Gyn0Ocqrx83pzwCm+qX09wWiC1yuzwEkMuYYIUIKEgzDo5wAoj70fNT6N4HBiFpdbHENd81nUacjMdF6Q2xECbcFFw5GPxEaog
 +q+yVFFQ
 S7Dyus6k1agRdJ9SGT+z4wR9790WY/tDIai4aMzxbc93DI+YCwTtv+shWsi0xGqhuAbXhuJJwOTNv0jJIMIbgrREUz0TmToWLXj5F/lMMKkjGiaCPyDMNwC21CDztpwgOkvYOBOFJIFJLEJ5IoYLRDrKEjGTzAkX222AmqNUSLEvU7K0Q7qTHtUeplf+i0+kSkvNfIf7Owt5iWcWeEcg0rBFI59Ac58onbCpUy2Hix0zXfdZEg6GPrRV05SWMt5IT4zQBggAKcv2RT3wPBhsazJL0zYGdR4BmAcREqYa6PQRhoBVUE8MKSV+dOpREqAlO/X68Cij8vRbRrh+dmI7MMn4WlV5dpaGMSp8+OGngAGlZsgodG4HPel5c2YMpGHmgjCOI/wrcGhk1Abq+lc1IcpEGKw0hJobXwNmBnhADlx3ZS+o3CHnbzLircUDK+DLFUUgGdKJihw6zkjZwryWVZ5HVaigdNbkT+17u5buuriyXM+V5EM1wSEc9BzfAPGDrYzOOJSRj0N2bMJenfDssE9XADdcyi5bfzggpz9883mABY4vHEHg1d17F+LRhwaGlPcuuqychfsrAGcfPgbV77T2+VAsJxMq06z6rbiK2nBCbCCq/ASNsvNGu/yBtgmVqQplPGjPj2vPnq9nU9bLfO4U24FvDhvm5ujUhRB0DdrPA8xxhAhqrIO1hPwmbrtEAI2c1dYHeAOACDx0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Context
=======

We've observed within Red Hat that isolated, NOHZ_FULL CPUs running a
pure-userspace application get regularly interrupted by IPIs sent from
housekeeping CPUs. Those IPIs are caused by activity on the housekeeping CPUs
leading to various on_each_cpu() calls, e.g.:

  64359.052209596    NetworkManager       0    1405     smp_call_function_many_cond (cpu=0, func=do_kernel_range_flush)
    smp_call_function_many_cond+0x1
    smp_call_function+0x39
    on_each_cpu+0x2a
    flush_tlb_kernel_range+0x7b
    __purge_vmap_area_lazy+0x70
    _vm_unmap_aliases.part.42+0xdf
    change_page_attr_set_clr+0x16a
    set_memory_ro+0x26
    bpf_int_jit_compile+0x2f9
    bpf_prog_select_runtime+0xc6
    bpf_prepare_filter+0x523
    sk_attach_filter+0x13
    sock_setsockopt+0x92c
    __sys_setsockopt+0x16a
    __x64_sys_setsockopt+0x20
    do_syscall_64+0x87
    entry_SYSCALL_64_after_hwframe+0x65

The heart of this series is the thought that while we cannot remove NOHZ_FULL
CPUs from the list of CPUs targeted by these IPIs, they may not have to execute
the callbacks immediately. Anything that only affects kernelspace can wait
until the next user->kernel transition, providing it can be executed "early
enough" in the entry code.

The original implementation is from Peter [1]. Nicolas then added kernel TLB
invalidation deferral to that [2], and I picked it up from there.

Deferral approach
=================

Storing each and every callback, like a secondary call_single_queue turned out
to be a no-go: the whole point of deferral is to keep NOHZ_FULL CPUs in
userspace for as long as possible - no signal of any form would be sent when
deferring an IPI. This means that any form of queuing for deferred callbacks
would end up as a convoluted memory leak.

Deferred IPIs must thus be coalesced, which this series achieves by assigning
IPIs a "type" and having a mapping of IPI type to callback, leveraged upon
kernel entry.

Kernel entry vs execution of the deferred operation
===================================================

This is what I've referred to as the "Danger Zone" during my LPC24 talk [4].

There is a non-zero length of code that is executed upon kernel entry before the
deferred operation can be itself executed (before we start getting into
context_tracking.c proper), i.e.:

  idtentry_func_foo()                <--- we're in the kernel
    irqentry_enter()
      irqentry_enter_from_user_mode()
	enter_from_user_mode()
	  [...]
	    ct_kernel_enter_state()
	      ct_work_flush()        <--- deferred operation is executed here

This means one must take extra care to what can happen in the early entry code,
and that <bad things> cannot happen. For instance, we really don't want to hit
instructions that have been modified by a remote text_poke() while we're on our
way to execute a deferred sync_core(). Patches doing the actual deferral have
more detail on this.

The annoying one: TLB flush deferral
====================================

While leveraging the context_tracking subsystem works for deferring things like
kernel text synchronization, it falls apart when it comes to kernel range TLB
flushes. Consider the following execution flow:

  <userspace>
  
  !interrupt!

  SWITCH_TO_KERNEL_CR3        <--- vmalloc range becomes accessible

  idtentry_func_foo()
    irqentry_enter()
      irqentry_enter_from_user_mode()
	enter_from_user_mode()
	  [...]
	    ct_kernel_enter_state()
	      ct_work_flush() <--- deferred flush would be done here


Since there is no sane way to assert no stale entry is accessed during
kernel entry, any code executed between SWITCH_TO_KERNEL_CR3 and
ct_work_flush() is at risk of accessing a stale entry.

Dave had suggested hacking up something within SWITCH_TO_KERNEL_CR3 itself,
which is what has been implemented in the new RFC patches.

How bad is it?
==============

Code
++++

I'm happy that the COALESCE_TLBI asm code fits in ~half a screen,
although it open-codes native_write_cr4() without the pinning logic.

I hate the kernel_cr3_loaded signal; it's a kludgy context_tracking.state
duplicate but I need *some* sort of signal to drive the TLB flush deferral and
the context_tracking.state one is set too late in kernel entry. I couldn't
find any fitting existing signals for this.

I'm also unhappy to introduce two different IPI deferral mechanisms. I tried
shoving the text_poke_sync() in KERNEL_SWITCH_CR3, but it got ugly(er) really
fast. 

Performance
+++++++++++

Tested by measuring the duration of 10M `syscall(SYS_getpid)` calls on
NOHZ_FULL CPUs, with rteval (hackbench + kernel compilation) running on the
housekeeping CPUs:

o Xeon E5-2699:   base avg 770ns,  patched avg 1340ns (74% increase)
o Xeon E7-8890:   base avg 1040ns, patched avg 1320ns (27% increase)
o Xeon Gold 6248: base avg 270ns,  patched avg 273ns  (.1% increase)

I don't get that last one, I did spend a ridiculous amount of time making sure
the flush was being executed, and AFAICT yes, it was. What I take out of this is
that it can be a pretty massive increase in the entry overhead (for NOHZ_FULL
CPUs), and that's something I want to hear thoughts on

Noise
+++++

Xeon E5-2699 system with SMToff, NOHZ_FULL, isolated CPUs.
RHEL10 userspace.

Workload is using rteval (kernel compilation + hackbench) on housekeeping CPUs
and a dummy stay-in-userspace loop on the isolated CPUs. The main invocation is:

$ trace-cmd record -e "ipi_send_cpumask" -f "cpumask & CPUS{$ISOL_CPUS}" \
	           -e "ipi_send_cpu"     -f "cpu & CPUS{$ISOL_CPUS}" \
		   rteval --onlyload --loads-cpulist=$HK_CPUS \
		   --hackbench-runlowmem=True --duration=$DURATION

This only records IPIs sent to isolated CPUs, so any event there is interference
(with a bit of fuzz at the start/end of the workload when spawning the
processes). All tests were done with a duration of 6 hours.

v6.17
o ~5400 IPIs received, so about ~200 interfering IPI per isolated CPU
o About one interfering IPI just shy of every 2 minutes

v6.17 + patches
o Zilch!

Patches
=======

o Patches 1-2 are standalone objtool cleanups.

o Patches 3-4 add an RCU testing feature.

o Patches 5-6 add infrastructure for annotating static keys and static calls
  that may be used in noinstr code (courtesy of Josh).
o Patches 7-21 use said annotations on relevant keys / calls.
o Patch 22 enforces proper usage of said annotations (courtesy of Josh).

o Patch 23 deals with detecting NOINSTR text in modules

o Patches 24-25 deal with kernel text sync IPIs

o Patch 26 adds ASM support for static keys

o Patches 27-31 deal with kernel range TLB flush IPIs

Patches are also available at:
https://gitlab.com/vschneid/linux.git -b redhat/isolirq/defer/v7

Acknowledgements
================

Special thanks to:
o Clark Williams for listening to my ramblings about this and throwing ideas my way
o Josh Poimboeuf for all his help with everything objtool-related
o Dave Hansen for patiently educating me about mm
o All of the folks who attended various (too many?) talks about this and
  provided precious feedback.  

Links
=====

[1]: https://lore.kernel.org/all/20210929151723.162004989@infradead.org/
[2]: https://github.com/vianpl/linux.git -b ct-work-defer-wip
[3]: https://youtu.be/0vjE6fjoVVE
[4]: https://lpc.events/event/18/contributions/1889/
[5]: http://lore.kernel.org/r/eef09bdc-7546-462b-9ac0-661a44d2ceae@intel.com
[6]: https://lore.kernel.org/lkml/20230620144618.125703-1-ypodemsk@redhat.com/

Revisions
=========

v6 -> v7
++++++++

o Rebased onto latest v6.18-rc5 (6fa9041b7177f)
o Collected Acks (Sean, Frederic)

o Fixed <asm/context_tracking_work.h> include (Shrikanth)
o Fixed ct_set_cpu_work() CT_RCU_WATCHING logic (Frederic)

o Wrote more verbose comments about NOINSTR static keys and calls (Petr)

o [NEW PATCH] Instrumented one more static key: cpu_bf_vm_clear
o [NEW PATCH] added ASM-accessible static key helpers to gate NO_HZ_FULL logic
  in early entry code (Frederic)

v5 -> v6
++++++++

o Rebased onto v6.17
o Small conflict fixes with cpu_buf_idle_clear smp_text_poke() renaming

o Added the TLB flush craziness

v4 -> v5
++++++++

o Rebased onto v6.15-rc3
o Collected Reviewed-by

o Annotated a few more static keys
o Added proper checking of noinstr sections that are in loadable code such as
  KVM early entry (Sean Christopherson)

o Switched to checking for CT_RCU_WATCHING instead of CT_STATE_KERNEL or
  CT_STATE_IDLE, which means deferral is now behaving sanely for IRQ/NMI
  entry from idle (thanks to Frederic!)

o Ditched the vmap TLB flush deferral (for now)  
  

RFCv3 -> v4
+++++++++++

o Rebased onto v6.13-rc6

o New objtool patches from Josh
o More .noinstr static key/call patches
o Static calls now handled as well (again thanks to Josh)

o Fixed clearing the work bits on kernel exit
o Messed with IRQ hitting an idle CPU vs context tracking
o Various comment and naming cleanups

o Made RCU_DYNTICKS_TORTURE depend on !COMPILE_TEST (PeterZ)
o Fixed the CT_STATE_KERNEL check when setting a deferred work (Frederic)
o Cleaned up the __flush_tlb_all() mess thanks to PeterZ

RFCv2 -> RFCv3
++++++++++++++

o Rebased onto v6.12-rc6

o Added objtool documentation for the new warning (Josh)
o Added low-size RCU watching counter to TREE04 torture scenario (Paul)
o Added FORCEFUL jump label and static key types
o Added noinstr-compliant helpers for tlb flush deferral


RFCv1 -> RFCv2
++++++++++++++

o Rebased onto v6.5-rc1

o Updated the trace filter patches (Steven)

o Fixed __ro_after_init keys used in modules (Peter)
o Dropped the extra context_tracking atomic, squashed the new bits in the
  existing .state field (Peter, Frederic)
  
o Added an RCU_EXPERT config for the RCU dynticks counter size, and added an
  rcutorture case for a low-size counter (Paul) 

o Fixed flush_tlb_kernel_range_deferrable() definition

Josh Poimboeuf (3):
  jump_label: Add annotations for validating noinstr usage
  static_call: Add read-only-after-init static calls
  objtool: Add noinstr validation for static branches/calls

Valentin Schneider (28):
  objtool: Make validate_call() recognize indirect calls to pv_ops[]
  objtool: Flesh out warning related to pv_ops[] calls
  rcu: Add a small-width RCU watching counter debug option
  rcutorture: Make TREE04 use CONFIG_RCU_DYNTICKS_TORTURE
  x86/paravirt: Mark pv_sched_clock static call as __ro_after_init
  x86/idle: Mark x86_idle static call as __ro_after_init
  x86/paravirt: Mark pv_steal_clock static call as __ro_after_init
  riscv/paravirt: Mark pv_steal_clock static call as __ro_after_init
  loongarch/paravirt: Mark pv_steal_clock static call as __ro_after_init
  arm64/paravirt: Mark pv_steal_clock static call as __ro_after_init
  arm/paravirt: Mark pv_steal_clock static call as __ro_after_init
  perf/x86/amd: Mark perf_lopwr_cb static call as __ro_after_init
  sched/clock: Mark sched_clock_running key as __ro_after_init
  KVM: VMX: Mark __kvm_is_using_evmcs static key as __ro_after_init
  x86/bugs: Mark cpu_buf_vm_clear key as allowed in .noinstr
  x86/speculation/mds: Mark cpu_buf_idle_clear key as allowed in
    .noinstr
  sched/clock, x86: Mark __sched_clock_stable key as allowed in .noinstr
  KVM: VMX: Mark vmx_l1d_should flush and vmx_l1d_flush_cond keys as
    allowed in .noinstr
  stackleack: Mark stack_erasing_bypass key as allowed in .noinstr
  module: Add MOD_NOINSTR_TEXT mem_type
  context-tracking: Introduce work deferral infrastructure
  context_tracking,x86: Defer kernel text patching IPIs
  x86/jump_label: Add ASM support for static_branch_likely()
  x86/mm: Make INVPCID type macros available to assembly
  x86/mm/pti: Introduce a kernel/user CR3 software signal
  x86/mm/pti: Implement a TLB flush immediately after a switch to kernel
    CR3
  x86/mm, mm/vmalloc: Defer kernel TLB flush IPIs under
    CONFIG_COALESCE_TLBI=y
  x86/entry: Add an option to coalesce TLB flushes

 arch/Kconfig                                  |   9 ++
 arch/arm/kernel/paravirt.c                    |   2 +-
 arch/arm64/kernel/paravirt.c                  |   2 +-
 arch/loongarch/kernel/paravirt.c              |   2 +-
 arch/riscv/kernel/paravirt.c                  |   2 +-
 arch/x86/Kconfig                              |  18 +++
 arch/x86/entry/calling.h                      |  40 +++++++
 arch/x86/entry/syscall_64.c                   |   4 +
 arch/x86/events/amd/brs.c                     |   2 +-
 arch/x86/include/asm/context_tracking_work.h  |  18 +++
 arch/x86/include/asm/invpcid.h                |  14 ++-
 arch/x86/include/asm/jump_label.h             |  33 +++++-
 arch/x86/include/asm/text-patching.h          |   1 +
 arch/x86/include/asm/tlbflush.h               |   6 +
 arch/x86/kernel/alternative.c                 |  39 ++++++-
 arch/x86/kernel/asm-offsets.c                 |   1 +
 arch/x86/kernel/cpu/bugs.c                    |  14 ++-
 arch/x86/kernel/kprobes/core.c                |   4 +-
 arch/x86/kernel/kprobes/opt.c                 |   4 +-
 arch/x86/kernel/module.c                      |   2 +-
 arch/x86/kernel/paravirt.c                    |   4 +-
 arch/x86/kernel/process.c                     |   2 +-
 arch/x86/kvm/vmx/vmx.c                        |  11 +-
 arch/x86/kvm/vmx/vmx_onhyperv.c               |   2 +-
 arch/x86/mm/tlb.c                             |  34 ++++--
 include/asm-generic/sections.h                |  15 +++
 include/linux/context_tracking.h              |  21 ++++
 include/linux/context_tracking_state.h        |  54 +++++++--
 include/linux/context_tracking_work.h         |  24 ++++
 include/linux/jump_label.h                    |  30 ++++-
 include/linux/module.h                        |   6 +-
 include/linux/objtool.h                       |  14 +++
 include/linux/static_call.h                   |  19 ++++
 kernel/context_tracking.c                     |  72 +++++++++++-
 kernel/kprobes.c                              |   8 +-
 kernel/kstack_erase.c                         |   6 +-
 kernel/module/main.c                          |  76 ++++++++++---
 kernel/rcu/Kconfig.debug                      |  15 +++
 kernel/sched/clock.c                          |   7 +-
 kernel/time/Kconfig                           |   5 +
 mm/vmalloc.c                                  |  34 +++++-
 tools/objtool/Documentation/objtool.txt       |  34 ++++++
 tools/objtool/check.c                         | 106 +++++++++++++++---
 tools/objtool/include/objtool/check.h         |   1 +
 tools/objtool/include/objtool/elf.h           |   1 +
 tools/objtool/include/objtool/special.h       |   1 +
 tools/objtool/special.c                       |  15 ++-
 .../selftests/rcutorture/configs/rcu/TREE04   |   1 +
 48 files changed, 736 insertions(+), 99 deletions(-)
 create mode 100644 arch/x86/include/asm/context_tracking_work.h
 create mode 100644 include/linux/context_tracking_work.h

--
2.51.0



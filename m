Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25448CD3430
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 08:24:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19C256B0005; Tue,  5 May 2026 04:24:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14D346B008A; Tue,  5 May 2026 04:24:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03C0B6B008C; Tue,  5 May 2026 04:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E56336B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 04:24:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9BE2BA041D
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:24:44 +0000 (UTC)
X-FDA: 84732680088.05.F249459
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id BCA9EC0008
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:24:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B9fcYtvO;
	spf=pass (imf10.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777969482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kORdjQPn63LWaaFhY19G65hNhcG7RJlj2m9p0fDlNwk=;
	b=8a5YuRI7ae8+8PF9B0yPubEGg7AxV64nvVjONPtVF+U/pVjx/5VH6hNlJ/RdojTxVOvugF
	LIpGlc/CUY8zRP/KD7N4zoqDYylA7Dra/RrS4jhl+nk91Fu8Zgn3OqURiqFzI1ZUg0Ttv2
	2XITETR+L7w+GQCt7uZYRamcljFdXxk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777969482; a=rsa-sha256;
	cv=none;
	b=j/Aw2fnug1GtrkFloa68ZYQh2Q5Ufw7k2r7J1QBXZSmhlZRyuDOzYiU3BX85cvGJBRM0Kr
	eGUDBlFBMZeLf41Fj2MHvzVHxxptMwRqSYmffZLROETtBGvgmO0dPxRAILtgAzOfpY7q+v
	76OqPBpAuBA/wCorOATmRKtTyJ3f5BA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B9fcYtvO;
	spf=pass (imf10.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777969482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kORdjQPn63LWaaFhY19G65hNhcG7RJlj2m9p0fDlNwk=;
	b=B9fcYtvOBo2qEP2KJKdhL3zdmVSniSGhNifbMVFFfQ9EuIiJL2toozr3vSJcnJVk79wVHz
	cLAdJG8HMkm6JytoZUBYgxl4OU5LNVXp2KeLSUOHMybYQcRBmaPSPNpp5s86lVdFECUM0I
	r7LVctrHpwx26n+i5gZmnEqpg4R/1mA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-679-KRy-BHOFPeubO0yAAkoC4A-1; Tue,
 05 May 2026 04:24:37 -0400
X-MC-Unique: KRy-BHOFPeubO0yAAkoC4A-1
X-Mimecast-MFC-AGG-ID: KRy-BHOFPeubO0yAAkoC4A_1777969473
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 618601800366;
	Tue,  5 May 2026 08:24:32 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.44.48.109])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F16330001A1;
	Tue,  5 May 2026 08:24:14 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org
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
	Tomas Glozar <tglozar@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Petr Tesarik <ptesarik@suse.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: [PATCH v9 00/10] x86: Defer some IPIs until a user->kernel transition
Date: Tue,  5 May 2026 10:23:45 +0200
Message-ID: <20260505082355.1982003-1-vschneid@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: Ib7-o1f15A-dh44L4EHqB1PwLHpmgGbbdGjgakijqzc_1777969473
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BCA9EC0008
X-Rspam-User: 
X-Stat-Signature: dmuxoe6wcd7pwqg7kuxqmgibaa7zk5is
X-HE-Tag: 1777969482-627822
X-HE-Meta: U2FsdGVkX18lzBdY6szH7RTDAmMrXZa91d2KrfDk8QRUDHjMCqUaDHfHpZrFawmNuyCKbF6XW/HBqcKgOGoWOMVPezRK4CbbH0qvBELm2bEHvFwFc7A2s+l1O2Zcv7JzJpvmXlfHPp0H/W9nBSl0mc/+ig/v484/4zq+OAdLSnbL1tz7LONc2GUaEq777YvcREMULa1s0eSX3VdAIc8O8WtX7nHpoTv/mbLgtv+TxX7gTZpyYxqXKzfH0jlZJXP98pnEDSbewqi5v2i2fYPXhtmdsgUSWqpFWSpVRv6Zo46Us0Y+vwaZblIKJXZ2zqoAebZeuIX3XCgskE8xKGfAYY1wcrMfo4P+FsUMSWT2BnX+Rjp+roRc/XTjbTgbCq/VOGux7Fs9+fMTE5zFNy7aj2Nu5nfqqVPY2EcfEq5vPDPA0JL3HXOgzCL80kXNHZesQwv16uUq4qD+h5FjDJ5ah7CK3ZuSUnWXV66i035wYEOsHrNGztP24sQAKw1y4HdwpZ8edpVdjWTDZTc4pOW/prafGYAJ9o2CapgFR5FRlxqapjcW6W34PQxaj2OADLF/ErJNYXFX0+Sr5OUXqTjEZhh/toVLYhNMOxncdsyJE3Ht+GHxnMUIYd2oIZC5F2sDupR9Xh1Yr6cYIhC3zCi5pHT1K6Jzj4bjp/Jqt1hVCVBjwXTRpRCSAlz0a5avrqZSlZ65NfxvSkQZ++PtMpHKu3P/XmNQxFipfddA6in25aXu9JxStZE1XPFItXaOBO9Enp10gGuwy3/4yTfFz54eren52lic5xJfKqrwJ8VmlmW0Dk3sncdn0itdYrdmR0im+0TcLgMMu5APAe0IQm7sB2CvA2ZCkpwhhBakebdpaJDZoIBgOWVbcYgw30U7Qy3VNAgJ6Y2Vo9+eLYADcEFUWY/jT6cF4wee3Fg+zuKSyl8kW3JNdLbGwO3BGccDxYQRQQUuef5nMzIycpllrFn
 EVsIpVDV
 J1Pyhpmeq8ryjmLPLctmls2YMuPy37SINYP1nVpkZgwS+Cm5YVuE2Agnoj2lWXN+CDPehIX/0hvrCAt7f71vtQ7lCWKB3cuQbRTBMwiWaNrYi0Dz/BVchRcMUvxzSwylglW2BUqBjXG31yvT4Xs+wknKj56q/v0bPeGXF/d+6Tq1IZmHuahePFPuoXK3187cPaxPSeHHmUzRO1nujD01wP/FEhm2GHbeFUZ1oYOxYyGHSGkdjj2ocSKvuH/rRfAPrv6tH8KSRD1IVwYJ0U2wAVfLOrr/kKfRY+W47KoXXINnchse37pkCOREBraDLDeQH2GGm0LXautFyJrGrfUFXYk3z/hePAKLyPLAfRNkE56vBKtcVDBmyCmMrWKO6LwJ1XAI+tae0tBFkyG7o0czbKnRgFlVpjRslBCCdjMYZlJwHRIm1en2Ze3qjY9l1bQ8J+FggdpCrcA70vcyJyUubnzqGAoGvjThwE1aemTkgjfKk4E1LY9b0J0TY12bBlh39061IDim8PwrwT9sRZcFGcXOY//Nqzwl8p7MBupMQ22pjyNeV1Sv3YFCr70aA2bVxPVQUq9HEVv/oLXtz7NcCqM+ATXfxawOUyKgq77UgYQHDDK4xa2AZ0Vs67RCc3UYViE0M/HLaCuamA/w1ubb98gI7Qg==
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

Previous versions would assign IPIs a "type" and have a mapping of IPI type to
callback, leveraged upon kernel entry via the context_tracking framework.

This version now gets rid of all that, and instead goes with an
"unconditionnally run a catch-up sequence at kernel entry" approach - as was
suggested at LPC 2025 [3].

Another point made during LPC25 (sorry I didn't get your name!) was that when
kPTI is in use, the use of global pages is very limited and thus a CR4 may not
be warranted for a kernel TLB flush. That means the existing CR3 RMW used to switch
between kernel and user page tables can be used as the unconditionnal TLB flush,
meaning I could get rid of my CR4 dance.

In the same spirit, turns out a CR3 RMW is a serializing instruction:

  SDM vol2 chapter 4.3 - Move to/from control registers:
  ```
  MOV CR* instructions, except for MOV CR8, are serializing instructions.
  ```
That means I don't need to do anything extra on kernel entry to handle deferred
sync_core() IPIs sent from text_poke().
  
So long story short, the CR3 RMW that is executed for every user <-> kernel
transition when kPTI is enabled does everything I need to defer kernel TLB flush
and kernel text update IPIs. 

From that, I've completely nuked the context_tracking deferral faff.
The added x86-specific code is now "just" about having a software signal
to figure out which CR3 a CPU is using - easier said than done, details in
the individual changelogs.

Kernel entry vs execution of the deferred operation
===================================================

This is what I've referred to as the "Danger Zone" during my LPC24 talk [4].

There is a non-zero length of code that is executed upon kernel entry before the
deferred operation can be itself executed (before we start getting into
context_tracking.c proper), i.e.:

  idtentry
    idtentry_body
      error_entry
        SWITCH_TO_KERNEL_CR3

This danger zone used to be much wider in v7 and earlier (from kernel entry all
the way down to ct_kernel_enter_state()). The objtool instrumentation thus now
targets .entry.text rather than .noinstr as a whole.

Show me numbers
===============

Xeon E5-2699 system with SMToff, NOHZ_FULL, 26 isolated CPUs.
RHEL10 userspace.

Workload is using rteval (kernel compilation + hackbench) on housekeeping CPUs
and a dummy stay-in-userspace loop on the isolated CPUs. The main invocation is:

$ trace-cmd record -e "csd_queue_cpu" -f "cpu & CPUS{$ISOL_CPUS}" \
                      -R "stacktrace if cpu & CPUS{$ISOL_CPUS}" \
                   -e "ipi_send_cpumask" -f "cpumask & CPUS{$ISOL_CPUS}" \
	           -e "ipi_send_cpu"     -f "cpu & CPUS{$ISOL_CPUS}" \
		   rteval --onlyload --loads-cpulist=$HK_CPUS \
		   --hackbench-runlowmem=True --duration=$DURATION

This only records IPIs sent to isolated CPUs, so any event there is interference
(with a bit of fuzz at the start/end of the workload when spawning the
processes). All tests were done with a duration of 6 hours.

v7.1-rc1
o ~6000 IPIs received, so about ~230 interfering IPI per isolated CPU
o About one interfering IPI roughly every 1 minute 30 seconds

v7.1-rc1 + patches
o Zilch... With some caveats

  pcpu_balance_work sometimes shows up, and isn't covered by the deferral
  faff. Again, sometimes it shows up, sometimes it doesn't and hasn't for a
  while now.

Patches
=======

o Patches 1-4 are standalone objtool cleanups.

o Patches 5-6 add infrastructure for annotating static keys that may be used in
  entry code (courtesy of Josh). 

o Patch 7 adds ASM support for static keys

o Patches 8-10 add the deferral mechanism.

Patches are also available at:
https://gitlab.com/vschneid/linux.git -b redhat/isolirq/defer/v9

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
[3]: https://lpc.events/event/19/contributions/2219/
[4]: https://lpc.events/event/18/contributions/1889/

Revisions
=========

v8 -> v9
++++++++

o Rebased onto v7.1-rc1-ish (507bd4b66c85)

o Caught up to housekeeping_overridden now being dynamic; revived alternative.c
  code that deals with static keys in early entry code (Shrikanth)

o Messed about ordering of @kernel_cr3_loaded accesses (Frederic)  

v7 -> v8
++++++++

o Rebased onto v6.19

o Fixed objtool --uaccess validation preventing --noinstr validation of
  unwind hints
o Added more objtool --noinstr warning fixes
o Reduced objtool noinstr static key validation to just .entry.text

o I've kept the "simple" __ro_after_init conversions 

o Moved the kernel_cr3_loaded signal update to before writing to CR3

o Ditched context_tracking based deferral
o Ditched the (additionnal) unconditionnal TLB flush upon kernel entry

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

Josh Poimboeuf (2):
  jump_label: Add annotations for validating .entry.text key usage
  objtool: Add .entry.text validation for static branches

Valentin Schneider (8):
  objtool: Make validate_call() recognize indirect calls to pv_ops[]
  objtool: Flesh out warning related to pv_ops[] calls
  objtool: Always pass a section to validate_unwind_hints()
  x86/retpoline: Make warn_thunk_thunk .noinstr
  x86/jump_label: Add ASM support for static_branch_likely()
  x86/mm/pti: Introduce a kernel/user CR3 software signal
  context_tracking,x86: Defer kernel text patching IPIs when tracking
    CR3 switches
  x86/mm, mm/vmalloc: Defer kernel TLB flush IPIs when tracking CR3
    switches

 arch/x86/Kconfig                        |  14 +++
 arch/x86/entry/calling.h                |  18 ++++
 arch/x86/entry/entry.S                  |   3 +-
 arch/x86/entry/syscall_64.c             |   4 +
 arch/x86/include/asm/jump_label.h       |  33 +++++++-
 arch/x86/include/asm/text-patching.h    |   5 ++
 arch/x86/include/asm/tlbflush.h         |   4 +
 arch/x86/kernel/alternative.c           |  57 +++++++++++--
 arch/x86/kernel/cpu/bugs.c              |   2 +-
 arch/x86/kernel/kprobes/core.c          |   4 +-
 arch/x86/kernel/kprobes/opt.c           |   4 +-
 arch/x86/kernel/module.c                |   2 +-
 arch/x86/mm/pti.c                       |  36 +++++---
 arch/x86/mm/tlb.c                       |  49 +++++++++--
 include/asm-generic/sections.h          |  14 +++
 include/linux/jump_label.h              |  27 +++++-
 include/linux/objtool.h                 |  16 ++++
 kernel/sched/isolation.c                |   9 +-
 mm/vmalloc.c                            |  30 +++++--
 tools/objtool/Documentation/objtool.txt |  15 ++++
 tools/objtool/check.c                   | 108 ++++++++++++++++++++----
 tools/objtool/include/objtool/check.h   |   2 +
 tools/objtool/include/objtool/elf.h     |   3 +-
 tools/objtool/include/objtool/special.h |   1 +
 tools/objtool/special.c                 |  15 +++-
 25 files changed, 414 insertions(+), 61 deletions(-)

--
2.52.0



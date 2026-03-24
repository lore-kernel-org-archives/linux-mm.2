Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 224ACE9A74B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 09:48:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A83B6B0005; Tue, 24 Mar 2026 05:48:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 658CC6B0088; Tue, 24 Mar 2026 05:48:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 520346B0089; Tue, 24 Mar 2026 05:48:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 390AA6B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:48:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D6BD91619AB
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:48:54 +0000 (UTC)
X-FDA: 84580482588.15.1B47FAD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id CDDE3C0002
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:48:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZsRZqBXo;
	spf=pass (imf22.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774345733; a=rsa-sha256;
	cv=none;
	b=SNXaokDR5ghU9ogjC2M7GS+bgvx17uTmc0gOe6uPIMmoI6wQVbYirMMKphmAa258Qy+sM6
	KEFYsk7P076lWIEkGQAkKnHITx50T7/M1MdZe5YyJKiBklFiqxfbQWEKrdocdEBMOFE9N+
	tB/X4Yoqwlzk6TMj6h/l9IvgAXYvPws=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774345733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=r49OgRNq7GpU7SB98x5c9ZEXeRkE2i//VurMbe1j5qY=;
	b=H9kVHkVjhVzXp8dmFduV/2BCu6d58CxpGtkqF4cGQbYdZIKd/w0I6uu8/87Atws6ofIdxd
	dA+oWYxBbvOr0lowlqvJXdHmMOjGxQoVO04DJq1sGRbyZPhnHqXsPeL+WMXtyzmTJei6YV
	nTS7AmN3F7kxjNdvqsZa4vXs2V/wwLc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZsRZqBXo;
	spf=pass (imf22.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774345732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=r49OgRNq7GpU7SB98x5c9ZEXeRkE2i//VurMbe1j5qY=;
	b=ZsRZqBXoUjrJY6Ba6d95GOLRVXif2Bn9byw13OsnDjuBIDy0u/iGRE/sk0Jy+OGfg7GxWd
	bg5LzzAbqqBhfOBbkHBSTrWJ+18fdcjyP1P0Pe3KWBuR6ZLNEvTlf4P+A1f4/M7daMyVaJ
	bsCu9ZVQI9bt+5fxyh3NbPWl1FQ78V0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-112-pKMJZhEbOnudYi5scFYu9Q-1; Tue,
 24 Mar 2026 05:48:48 -0400
X-MC-Unique: pKMJZhEbOnudYi5scFYu9Q-1
X-Mimecast-MFC-AGG-ID: pKMJZhEbOnudYi5scFYu9Q_1774345724
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7D4BE19560A2;
	Tue, 24 Mar 2026 09:48:42 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.44.34.246])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 94DCA3000223;
	Tue, 24 Mar 2026 09:48:27 +0000 (UTC)
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
Subject: [RFC PATCH v8 00/10] context_tracking,x86: Defer some IPIs until a user->kernel transition
Date: Tue, 24 Mar 2026 10:47:51 +0100
Message-ID: <20260324094801.3092968-1-vschneid@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: PLmfX6AMFe8AW-h6e93zUAMtRkPHEzdhOBThLyXgLw4_1774345724
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CDDE3C0002
X-Stat-Signature: exrg9748qdsnbtx48ezf8tucd6pfmd7b
X-HE-Tag: 1774345732-660958
X-HE-Meta: U2FsdGVkX1/MIOQQPzwRUtEhxgloo0rR/Pzp9OLL/ONhrZ/+HS8RysDIDBmzd0+HyUvOD1V9WOwvS9nw+WbOr/wzm4Ta+D6ObFeUmlUHJoutDMU/39Z53eOcN9IuLJxielieTpD9qsQT3bFIcCnnEB7DS9BJdsHUZ6OqKSAcfM3mV2BquHZNcnnyaDHIckU7dHGXD5wEgKID5+Cmzc5Sa2xwov0gsV5O1k4u0pBcCDkEomU/nhXXv2d+Aq6ofDcI9QIyeBoWMmUnoaLsy3EioTnuRqHMeLQ1n+qnLUsPRM/0sgmod+OM6x/GFOiNHbaKTca/Xh///KUqLLc1pq7igcHIdOUsH5gArTKoQ+CUx8Y23/9OBGxLQ8ZoSrQe/81/hZvKxp1qeoNAhQj83gs7/zmexdcqNe/uPCENIPTC6ZRTvgx4nXDSY+Gl+KeVzN/z5cL3eGVonrbo/KkM2aZMeepXCWc7BdD6DO868gw/xwIzrvOuWXE2DJRefRbCyssl34T7WWxZjBCi3ifAj0NMwLUMlWqrBxxGxizxQPCUXA+MEI9+YesPKKiK8wie+GjKdYvUEM/dkDCG9D/in02oKoJxZwOzUWlACZMBBMmfLdNwMY/0lQmhUv9PJsFHOR4gYRKu5ihmX3FV1S+rl7M+ZF7LxCx03386eL2+FFccmXc3dWBkwl1BwyylzbHEI5W7lcI9rJjnGQVsIWrNd8t89/h8s4vZ6KPp1XYr+w8DYHjxckjDsfokp/ka9w/Cp4rmQN1Up/8dyTKYdrzGdIPszkyM3Ixoz2xDee5ciG8G5pwZdW6efBNjjnthS8jvD36F2uJozqB6QAAVn3judBhfAIeXalmJm+z2Oc0w+H70t2rMG8hND2+FgVxP6+2mBKIu7E7zYkoWl4MDIQnX+cagEPYbhdtfgvJ7gceB3nvE3iZJb2nIDHR3EI1FFHWLMPR26YH/af55jZQcymSSE5A
 RUwHtlzk
 GxPCqlA4Dg1QktbaHEBQbdwafFYY6VjfYS6/ZSY3qH1ytIwU4U7tdv+EgfAjxk5+MAvniMrZp9eth3MnyuBb92K2rErSkPFFrhVZtH1rHVIacACpxzTDTf+e+s6Lxto3k3c9ICIVIBsmewyHYAf6NCqrvOyN9UZC5AeF/eWcQ2nQoX+yNv+dnhPKWV/m6UbGYiNPPBLe6HubLhfgPmAu2KlLNp+Kvirib7pYGndhT1/w55ieLHmyxk6CLwFkra9Uav7mHXOwpZjHFUYpJOjmI7U0CO2asJMq9W5DbbHkGVmPlowu1AkL731FPQxlvHkKeF8sRsv9mnrK71dZnyiRCdvq6vYyR0Z6ADl4mR9yKMT3A1XCpLFP8qYhOrxpkC0zQckb9g2gP+pWvf+5kOHzh0MHOG78Q0FOMWdWfHmjmb26UdMOwO65Gp5QFFJqyUlehd2xWJHvOhhT3bMki/hVbeJ7ywmNM44hKZNUx4P0e3g9dOMyTgOUuoI6vP5Kio559pbVyZMuGT5QRxGXNdqHgrP1iIis1Y/bVKrZLrW0ExKUF2vmF8PMrQhRYlLpmTGvjwqWHkbWehlUKCQPHoImH6W9VPxZ0KGIDf1AyfkP0wfCz6M0AGLDb0xh3YkksgrLE90J/cKceLrj36Ljebvah4vI3F6fGU46zIQ/7yUtpfW1cUirMP2o6iVJjthOrbJOk1FNH
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

v6.19
o ~6000 IPIs received, so about ~230 interfering IPI per isolated CPU
o About one interfering IPI roughly every 1 minute 30 seconds

v6.19 + patches
o Zilch... With some caveats

  I still get some TLB flush IPIs sent to seemingly still-in-userspace CPUs,
  about one per ~3h for /some/ runs. I haven't seen any in the last cumulated
  24h of testing...

  pcpu_balance_work also sometimes shows up, and isn't covered by the deferral
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
https://gitlab.com/vschneid/linux.git -b redhat/isolirq/defer/v8

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

v7 -> v8
++++++++

o Rebased onto v6.19

o Fixed objtool --uaccess validation preventing --noinstr validation of
  unwind hints
o Added more objtool --noinstr warning fixes
o Reduced objtool noinstr static key validation to just .entry.text

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

Josh Poimboeuf (1):
  objtool: Add .entry.text validation for static branches

Valentin Schneider (9):
  objtool: Make validate_call() recognize indirect calls to pv_ops[]
  objtool: Flesh out warning related to pv_ops[] calls
  objtool: Always pass a section to validate_unwind_hints()
  x86/retpoline: Make warn_thunk_thunk .noinstr
  sched/isolation: Mark housekeeping_overridden key as __ro_after_init
  x86/jump_label: Add ASM support for static_branch_likely()
  x86/mm/pti: Introduce a kernel/user CR3 software signal
  context_tracking,x86: Defer kernel text patching IPIs when tracking
    CR3 switches
  x86/mm, mm/vmalloc: Defer kernel TLB flush IPIs when tracking CR3
    switches

 arch/x86/Kconfig                        |  14 +++
 arch/x86/entry/calling.h                |  13 +++
 arch/x86/entry/entry.S                  |   3 +-
 arch/x86/entry/syscall_64.c             |   4 +
 arch/x86/include/asm/jump_label.h       |  33 +++++++-
 arch/x86/include/asm/text-patching.h    |   5 ++
 arch/x86/include/asm/tlbflush.h         |   4 +
 arch/x86/kernel/alternative.c           |  34 ++++++--
 arch/x86/kernel/cpu/bugs.c              |   2 +-
 arch/x86/kernel/kprobes/core.c          |   4 +-
 arch/x86/kernel/kprobes/opt.c           |   4 +-
 arch/x86/kernel/module.c                |   2 +-
 arch/x86/mm/pti.c                       |  36 +++++---
 arch/x86/mm/tlb.c                       |  34 ++++++--
 include/linux/jump_label.h              |  11 ++-
 include/linux/objtool.h                 |  16 ++++
 kernel/sched/isolation.c                |   2 +-
 mm/vmalloc.c                            |  30 +++++--
 tools/objtool/Documentation/objtool.txt |  12 +++
 tools/objtool/check.c                   | 108 ++++++++++++++++++++----
 tools/objtool/include/objtool/check.h   |   2 +
 tools/objtool/include/objtool/elf.h     |   3 +-
 tools/objtool/include/objtool/special.h |   1 +
 tools/objtool/special.c                 |  15 +++-
 24 files changed, 331 insertions(+), 61 deletions(-)

--
2.52.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95812CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:41:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F24E38E0011; Fri, 10 Oct 2025 11:41:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED4EC8E0003; Fri, 10 Oct 2025 11:41:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC3918E0011; Fri, 10 Oct 2025 11:41:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C698F8E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:41:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6706D119C1F
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:41:07 +0000 (UTC)
X-FDA: 83982618174.23.9914F48
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 62CBA180008
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:41:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="jIS6/Lhi";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760110865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Fyc/O040ioe2LeCss0F0AJFhQQxKnCcKYI13CFwyqX8=;
	b=AVdfpxi79PusDOlw1BqYO4lATAJcmkjyNh5unWI6ak3novsWiTIJT/1MjSuCazCOdxFf3l
	qQBb3xVKKAk/Gga3s8OCwl7fBQB3rMsXGHWS9d9uAnXM9nc0zq3p7aRYzZWK27DJZR7sdN
	IRuwsreIHFAZWwZTvdPlgclIv2C8Q3A=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="jIS6/Lhi";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760110865; a=rsa-sha256;
	cv=none;
	b=Xku4Od0N4tMLPq1WXY1cZNCRZzXos8A23LzXPo1gMQNfxndnGeYNeleJMORzy7T2hi8/lH
	qywrRadgJjGjQiI028E1nUXwdIHI2oiz6BDyXfsO4HhhoimVcDpABkYITxqMBTbCMCVd7q
	8gnJja4FuCauE1jrmyWfSivV2/cNcVI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760110864;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Fyc/O040ioe2LeCss0F0AJFhQQxKnCcKYI13CFwyqX8=;
	b=jIS6/LhiHkRbXxp21vrWDTttqw8uDTrSgp9BrpgXniS0LPOv3Miog/GKHH9SdkG0cp6jgT
	5WsWU9SSng/2NEJmKesJA3uFRxIjGXvc+47pQufeVNHcTBbc667XXckKD9yNqOAw+v/op4
	arF7kWCrq8RKq3p5w08a1CJMT9XwA9E=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-322-pJcu7FHtPGSeetPSPwFhxw-1; Fri,
 10 Oct 2025 11:40:58 -0400
X-MC-Unique: pJcu7FHtPGSeetPSPwFhxw-1
X-Mimecast-MFC-AGG-ID: pJcu7FHtPGSeetPSPwFhxw_1760110846
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 71FE31800576;
	Fri, 10 Oct 2025 15:40:44 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.224.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CD83E18004D8;
	Fri, 10 Oct 2025 15:40:25 +0000 (UTC)
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
	Petr Tesarik <ptesarik@suse.com>
Subject: [PATCH v6 00/29] context_tracking,x86: Defer some IPIs until a user->kernel transition
Date: Fri, 10 Oct 2025 17:38:10 +0200
Message-ID: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Rspamd-Queue-Id: 62CBA180008
X-Rspamd-Server: rspam03
X-Stat-Signature: z41m8ju8otd9p8b7tyz5erm4i8bzen71
X-HE-Tag: 1760110865-343450
X-HE-Meta: U2FsdGVkX1/Z3zfJysKZRnges2k2hYgxahKKuvU/QOqBPmQq5hX3JabWZ2ykeJtlls3ypfEGyQhP0Hlt6KWy//zGoPdetRvWrx4UwkSvGgJZ5ddE5t6MOXeRN49EV6pbfDADDVbu845qztg70VdnNGdtZq7YhlD1nJjlhQm+FUS6zYWsTiWlCgMOmZ4Vu032uXiO7jPrNjpaKciJ4JsMwsbUpHhNVveu1D4fssoEMsENJsAvsoAtFqKSVrzElZlsmkt/dXHbl7zdYR30sMPg21F1TrsSMmD0x6aLCGhjk+lVrI5TWwIdQouLnRr7tsCANbYdJG/t19mVZxDLJWGMDxQ00wFLEnRUn7B++BnnoQcdeNdbNEnW4lVOi8JF6xyF4/nbxLRZI9b7TR89yjabd5YHbgcfw1p/jNFd9m9m+FMoJ7IQcgHBHbiwwEFbXzd9A+TNXXX2zIGaxTIgM9NcEGvTMJIrKo7XHQPlXqZAMfcIxvuyLNWhQrhTZ8CYcNyX54IXERIkDvX/QyE2z1SCt+lprtrhpm2QgfTqkBEMnXpO70akQL+rPfV/xs88R0E5rCPG4q3JXSWlNhMWWdpoEYRQAXMJlE/Z0gYH9uGnlRHNxxmDHA47UuX9DZZDFRZHHE2398MLLO4BRqizOKTmx3N0BWo0JOfOlUB2bDSeuZuyivLIlNtOwJ7ibcw+Silzg3Xt2Exjeb2CiMEypH1/EFWbyHcrRnbHuOrdNcCvZlHYquYUaCBgq+Zpesd/n0eaRA66mEDTst7tK1c+0xEIdqWGX4CRAkLzujZyUhov0RDfVWjUyOZm9NJYSA/ZizDogipLANJpSSBjBr0lkFmO4dU6MMGR2xD3vC+zpylG7Xh2/JSWx57tzvpCk0ecjxpFro/a8ELPDeLyiUjD2wGt/YzqsZ2xSwgTD9aeOYbB9Mi2CFYfmn0pAjJRvp7nRsQcAerNyDDpbPPr0x4M54r
 4QmU9GCl
 aZcun5dgihQvCvGqFNYaMwv/uhu5PMCuYUIw5phfTul4T8O2bnsTT6/LLQ3OYVERvnaFKVASmQBCiqJRH/P2ZTb6U1CStJxfXk/67i4/ubR3QaK2PBxajDU8wUggB7eHeXaT9qtm7AwBlt3w0AGWt6p0DmWywoespr8RKVZnUjpljnMJaEVWZS+WAj4NiL8vX93kSHlVnISbSCBGa+VMXJYeqa/K5phiB4pXX04ONCbHMbFXUqu6XgCbIgTjvmPV8/KLubq7a2jHJLW5YcdOoNJWVsjPlleDYeBSmtl2qlfNhhGdt8KktzPqiGNhuw1SLxR2EHw/NETTyqgofnvKNLncnZ9Pf3B7s8Un867VLfkaTy7Opse6gmTMihIMLBqt3lolaQeHyOa7hEMXLwkaYBqx0gvRNN9TF9Ge4GGGIGmhLnVQXQWC0qMoR1rPOZOT6Guz5bmiezaBAuY7aATcQybdX2W6Bj0emn2NgZLltfGXp3apw8zIZUYz6NTg6F8ndLAzZX4uJ+hw8R4SGqjoDX4EEILTz3/fxqUbz6ZJngCFWm2CdDeH0OcIzUpLBbDP3XF59vY7OSn7unCj0nR89/mMOZAXLuAI+N55Uv5uZutYLIwlw/NULvinXD6LFUbzCfMDqNJ+GU1kBy+nhcIN9wTrYpEInEb8Z1dXj6zj+a7q9c664tQdnqNoWGip8TLD8jvtxe5VkyU5iBd4=
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
o Patches 7-20 use said annotations on relevant keys / calls.
o Patch 21 enforces proper usage of said annotations (courtesy of Josh).

o Patch 22 deals with detecting NOINSTR text in modules

o Patches 23-24 deal with kernel text sync IPIs

o Patches 25-29 deal with kernel range TLB flush IPIs

Patches are also available at:
https://gitlab.com/vschneid/linux.git -b redhat/isolirq/defer/v6

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

Valentin Schneider (26):
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
  x86/speculation/mds: Mark cpu_buf_idle_clear key as allowed in
    .noinstr
  sched/clock, x86: Mark __sched_clock_stable key as allowed in .noinstr
  KVM: VMX: Mark vmx_l1d_should flush and vmx_l1d_flush_cond keys as
    allowed in .noinstr
  stackleack: Mark stack_erasing_bypass key as allowed in .noinstr
  module: Add MOD_NOINSTR_TEXT mem_type
  context-tracking: Introduce work deferral infrastructure
  context_tracking,x86: Defer kernel text patching IPIs
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
 arch/x86/entry/calling.h                      |  36 ++++++
 arch/x86/entry/syscall_64.c                   |   4 +
 arch/x86/events/amd/brs.c                     |   2 +-
 arch/x86/include/asm/context_tracking_work.h  |  18 +++
 arch/x86/include/asm/invpcid.h                |  14 ++-
 arch/x86/include/asm/text-patching.h          |   1 +
 arch/x86/include/asm/tlbflush.h               |   6 +
 arch/x86/kernel/alternative.c                 |  39 ++++++-
 arch/x86/kernel/asm-offsets.c                 |   1 +
 arch/x86/kernel/cpu/bugs.c                    |   2 +-
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
 include/linux/context_tracking_work.h         |  26 +++++
 include/linux/jump_label.h                    |  30 ++++-
 include/linux/module.h                        |   6 +-
 include/linux/objtool.h                       |   7 ++
 include/linux/static_call.h                   |  19 ++++
 kernel/context_tracking.c                     |  69 +++++++++++-
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
 47 files changed, 682 insertions(+), 96 deletions(-)
 create mode 100644 arch/x86/include/asm/context_tracking_work.h
 create mode 100644 include/linux/context_tracking_work.h

--
2.51.0



Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05F7F606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 20:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Sn6zu03L
Received: by kanga.kvack.org (Postfix)
	id 9C9EC6B05B8; Fri, 27 Nov 2026 15:13:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9536D6B05B9; Fri, 27 Nov 2026 15:13:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A63F6B05BA; Fri, 27 Nov 2026 15:13:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38CC96B05B8
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:13:04 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9A376A76D9
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:13:03 +0000 (UTC)
X-FDA: 85481997846.10.3377BBB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6E11E12000C
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:13:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Sn6zu03L;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795810381;
	b=7WASUer7PsMlr98SJrRJkMWGblVhYrAs5jqxVxzKd+MvhMDtv3mrVqR3v4/W9oZkjnkzGQ
	tKlvWstKNJ6M7ir/ZrfTpob2b52RcLCbPWfx5/3FQw7TZY0sWuJ9VOoEb1F+6qM0NPwlOC
	XvSpH9aUEqkakmme65Sq27TL+zFIB5w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795810381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=g3eiI7I16rUioI8+dk24LEsq8qaT5Fx0uLzV3PX8YGI=;
	b=2m4m2vqHFkcCw8dE0V0p0VHeJ4IflPqefAZrCPozxbMNBm8I2CkVNvU1MsUJDvfb4iwN/b
	IaD3LDCVwAEUr4TFORq8Ng7Klt6KKQUzgXVaED+deVwwOzkwFKRaqORx9b27OY2zqe6npi
	UJgAXNiP0H/OqEmvK/rnsDtydGpk0Cg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Sn6zu03L;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795810380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=g3eiI7I16rUioI8+dk24LEsq8qaT5Fx0uLzV3PX8YGI=;
	b=Sn6zu03LAuSSjAomXcJnEntqruQvFP2QLWLnuNnIcdhvDhfLee8Lys9ac0gaxQBTR1zlLx
	JI4pE9SaDhAU+xEeJ5rVxYDXMjJgLnahA9HJ+ySoVDD7vtqaGqmgvlUuX+i0OaOI/TDYW3
	YVmjs0mrYXPbi1QkGc36+OxlPXZiB00=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-589-B9v4suzoNzm1EagrMFprFg-1; Fri,
 27 Nov 2026 20:12:56 +0000
X-MC-Unique: B9v4suzoNzm1EagrMFprFg-1
X-Mimecast-MFC-AGG-ID: B9v4suzoNzm1EagrMFprFg_1795810373
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 78E0E195605C;
	Fri, 27 Nov 2026 20:12:51 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8240B589;
	Fri, 27 Nov 2026 20:12:39 +0000 (UTC)
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
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Dan Beimborn <Dan.Beimborn@qube-rt.com>,
	"Pak Hung Vincent Chiu" <pak-hung.chiu@qube-rt.com>
Subject: [PATCH v10 00/10] x86: Quiesce text_poke() IPIs
Date: Fri, 27 Nov 2026 21:12:11 +0100
Message-ID: <20261127201221.434876-1-vschneid@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: TzvBJ4N5wW5RnrX2og3DWPL2HYmCFQ16-cCMLQz3Uog_1795810373
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User:
X-Stat-Signature: kc1dm1jy1k5uhkaw4zmygzg96wzoacmd
X-Rspamd-Queue-Id: 6E11E12000C
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795810381-283443
X-HE-Meta: U2FsdGVkX1/652Wa0QeVVdYHgwOcra8NVqpU7umfTRkBhFeZvClHEv4bcvpxdLX4Wpu39lIj3tcFxMjcoxQRmVwa8/Nz3e7yOjsES6ZbQtgcmQxUdXClbHGov7mviPAiEejewNUF1AagCbkGweeqIWggk4HyHvpNchniVvaTw6FW1JIgI9ffVJDrMJc3lSJ8eSYOAkolPDA81ymFYy76mFmtW6Xqh6rtI5nKk1W5Bx6VLLR9IEZV+UR0RU+44ubB0Sj6w0W+ijHZDmhmWY1sAOnYFfOSQg2H1QhoIFtjoWcZYr8kqGE5Tg8ETb3MJMM5ODSLO0FwmeHtQGpqsINOpDAhfjgMJeE4AyCPnaUnHSV8c8eaTyrwLzHPvV+vV28wRCRHZzyt1imcgVlmE0mtxeYym+PXlaqms6yl73+NM5gPwKPKV//M9LvwPH0FmGRc+TnIFeujgof17DqyOCo+rcKB5qVvVZt3eJtPJ1eq/9uAjHt1QpgktVvUUu8vDvPO52Ct0MPNSwVY9RHuV2Mdov8Evr/bNrxWQg+AyABRo7l+NQY2z18icPR+FrGYaFwHcY9G8GtpFHhBTqCnVE8TOtzpVhr3zFB3SXfi5PCKQ9EKs/8Qv8KIFQC95ZjX/oy3rlO4qDNAA/MQ+B8ind8up1zbz3CmQe1tEczdjB+plZLxusVpvy3RgPHg8BLD89oKaeuM7aTnw+MWE0NpLDkwWMEN6NXaI4+gz9rZq1r9x55GbEMU0QkWh/psFruCEV02klvLMnAoMgQVceV/Wc+MFB0WVIywEy4hqzI0rbctV3u/oCVPQnIZGun7zdZDAhd1zVLvrjpTNmHiPAJgmQxO3lnbgvuGt0Ub2B61Y+sTBKQsK0TZJIJZwasqhDEleBDw9Kgwdc3wwuiRoX5Cyxp0EfNLfP+cphwnA5+ojfwcjiW8fGL8mmUocPnAYNeLRdoa4OTgZypQ/x0s1mL8+Ox
 qMheKg/B
 xlAKBIydQj4HkgGptgiYJhnWPwCVs4g/niOa823YWkg8G6+Mzfc6bdUUJqJYBufIpte6uiVCEHwPwA30VxlOaniiJiH0aLC357EBNLRMGqu6/yEyf9RLbLItdS35eHV32KC/OMFTTlIxUcnvN1bsULmWQE9KoZQj77Xb04/1hTjPNqXc7eLaG/pgEfGFQiGQFtlfp0DMH4s+gur6fK3PP6ghIWkpyJ9Ta0B7HdV5J3g5TRFJPyrsaeY76IZz09kO+toE4+V9kJh25i53vTGJeTgGO/5vxOe0P+pMYDpjDYCwmAwVcKG46ee167OrGnIeEM0HZXy7QJ4omdHZYtrQQhYv9izl3mo/KA+cXaNMBHiS1NeH63dMn21TlLRD0HVQ0Tf6b0h6vwthXxVN0+x74uMOUGG+b+/eOlR6+7XfYDGEylprU9f4AfNFGsXB2xAV/FT0iG3lt/yHYZSKC5QfZPHhEI7TY44Mo2iG5iCKG75JYCerM0YzYmdp/a2x5Isk08f1QQERfYf+kJmOA2lvAcwTruSwIFvUOu9fgW3hqqpP42dNMil3KVm2sPiyV21Kx/XC2MdBXcfsXRKoIedGRZM7DlnOnfEJ0+sQ2oNSo/49zmIUftHYXVXsuotKak/0NIZOr+NhK2q+dXBc+ZhgDEsFRML8yK6WHiPaD3HQB5p3NVCHSFou8ib+5nLJSPfTbzbACaxbqcQeB43dCBTQGDWMSx70XA6PxjKt3K1VAe5dM9EaZJQSfed8oqvLlyR6N6SHSpGgUMB+hX3N53AnwioCfp+MuOtsSAuSOF3ndRQyg4ITkN0j18enYlPqu9yhwOsbLN2taaVabQO7QTaNhBWuewGw8ihmbbYHQhAvL0CZXXnOpnY2bsu4gSquAnjIIKbDABjwlgU9ZJj2KuR09FgLQQJOL4GwP10ClIZoIn5JJP/wK6aqL1Npsp2fcb6xkwXwnrFez62fXRvA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Christmas comes early this year, here's v10!

Context
=======

We've observed within Red Hat that isolated, NOHZ_FULL CPUs running a
pure-userspace application get regularly interrupted by IPIs sent from
housekeeping CPUs. Those IPIs are caused by activity on the housekeeping CPUs
leading to various on_each_cpu() calls; this series is tackling the ones coming
from

  smp_text_poke_*()
  `\
    smp_text_poke_sync_each_cpu()

In the wild we mostly see these from static key updates and BPF JIT'ing. All
sorts of kernel text updates can trigger them:

  $ global -v --result=grep --color=always --path-style=shorter --from-here=3136:arch/x86/kernel/alternative.c -- smp_text_poke_single
  arch/x86/include/asm/text-patching.h:47:extern void smp_text_poke_single(void *addr, const void *opcode, size_t len, const void *emulate);
  arch/x86/kernel/ftrace.c:194:	smp_text_poke_single((void *)ip, new, MCOUNT_INSN_SIZE, NULL);
  arch/x86/kernel/ftrace.c:198:	smp_text_poke_single((void *)ip, new, MCOUNT_INSN_SIZE, NULL);
  arch/x86/kernel/ftrace.c:507:	smp_text_poke_single((void *)ip, new, MCOUNT_INSN_SIZE, NULL);
  arch/x86/kernel/ftrace.c:601:	smp_text_poke_single((void *)ip, new, MCOUNT_INSN_SIZE, NULL);
  arch/x86/kernel/jump_label.c:105:	smp_text_poke_single((void *)jump_entry_code(entry), jlp.code, jlp.size, NULL);
  arch/x86/kernel/kprobes/opt.c:486:		smp_text_poke_single(op->kp.addr, insn_buff, JMP32_INSN_SIZE, NULL);
  arch/x86/kernel/static_call.c:142:	smp_text_poke_single(insn, code, size, emulate);
  arch/x86/net/bpf_jit_comp.c:657:		smp_text_poke_single(ip, new_insn, X86_PATCH_SIZE, NULL);    

  global -v --result=grep --color=always --path-style=shorter --from-here=2846:arch/x86/kernel/alternative.c -- smp_text_poke_batch_finish
  arch/x86/include/asm/text-patching.h:50:extern void smp_text_poke_batch_finish(void);
  arch/x86/kernel/alternative.c:3120:		smp_text_poke_batch_finish();
  arch/x86/kernel/alternative.c:3139:	smp_text_poke_batch_finish();
  arch/x86/kernel/ftrace.c:61:	smp_text_poke_batch_finish();
  arch/x86/kernel/ftrace.c:258:	smp_text_poke_batch_finish();
  arch/x86/kernel/jump_label.c:146:	smp_text_poke_batch_finish();
  
Approach
========

The heart of this series is the thought that while we cannot remove NOHZ_FULL
CPUs from the list of CPUs targeted by these IPIs, they may not have to execute
the callbacks immediately. Anything that only affects kernelspace can wait
until the next user->kernel transition, providing it can be executed "early
enough" in the entry code as a postponed operation.

The original implementation is from Peter [1]. Nicolas then added kernel TLB
invalidation deferral to that [2], and I picked it up from there.

Previous submissions included mitigations for both text_poke() and
vmalloc()/vfree(), this time around it's just text_poke() - I have updated code
for vmalloc()/vfree() but it's really fugly, and the text_poke() stuff is more
pressing. Also, that's enough assembly faff for one patchset.

text_poke() requires executing a serializing instruction on all CPUs, thus its
postponed operation must be a serializing instruction. Turns out we're in luck,
as the kPTI CR3 RMW is just that:

  SDM vol2 chapter 4.3 - Move to/from control registers:
  ```
  MOV CR* instructions, except for MOV CR8, are serializing instructions.
  ```
That means we don't need to do anything extra on kernel entry to handle quiesced
sync_core() IPIs coming from text_poke() (other than leverage kPTI).
  
Kernel entry vs execution of the postponed operation
====================================================

This is what I've referred to as the "Danger Zone" during my LPC24 talk [4].

There is a non-zero length of code that is executed upon kernel entry before the
postponed operation can be itself executed (before we switch to the kernel CR3),
i.e.:

  idtentry
    idtentry_body
      error_entry
        SWITCH_TO_KERNEL_CR3

This danger zone used to be much wider in v7 and earlier (from kernel entry all
the way down to ct_kernel_enter_state()). The objtool instrumentation thus now
targets .entry.text rather than .noinstr as a whole.

kPTI woes
=========

I only learned today that even with kPTI enabled in the Kconfig, a lot of
hardware does not actually require PTI and disables it at boot. You can imagine
my reaction to this if you look at the amount of faffing I've done in the kPTI
SITCH_TO_*_CR3 code.

Buuut there may still be some value to it - I'm using the text_poke() stuff as a
foundation for the tlb_flush quiescing, and that *does* require *at least* a CR3
RMW. Again for that I was relying on kPTI limiting the global pages to not have
to add a pure ASM CR4 sequence. So I should be able to reuse a lot of that code,
but that puts me in a bad spot where I'm submitting quite intrusive code for a
feature that isn't even in the patchset...

So yeah, thoughts welcome here!

Testing
=======

(May require pti=on depending on your hardware setup)

QEMU
++++

Tested with GDB single-stepping to check the ASM static key behaviour.
Used the 'nmi' command to trigger the NMI entry paths, although I couldn't get
NMI nesting to happen.

Real hardware
+++++++++++++

Tested on a dual-socket Intel(R) Xeon(R) CPU E5-2699 system with SMToff,
NOHZ_FULL, 26 isolated CPUs. RHEL10 userspace.

BPF kselftests, the fentry one:

```
cleanup () { kill $(jobs -p); echo on > /sys/devices/system/cpu/smt/control; }
trap "cleanup" INT

echo off > /sys/devices/system/cpu/smt/control

ISOL_CPUS=5-17,23-35
ISOL_CPUS_ARRAY=(5 6 7 8 9 10 11 12 13 14 15 16 17 23 24 25 26 27 28 29 30 31 32 33 34 35)

for cpu in ${ISOL_CPUS_ARRAY[@]}; do
    echo $cpu
    taskset -c $cpu bash -c "while true; do continue; done" &
    chrt -f -p 1 $!
done

trace-cmd record -e "csd_queue_cpu" -f "cpu & CPUS{$ISOL_CPUS}" \
		-e "ipi_send_cpumask" -f "cpumask & CPUS{$ISOL_CPUS}" \
		-e "ipi_send_cpu"     -f "cpu & CPUS{$ISOL_CPUS}" \
		./test_progs -t fentry_test

cleanup
wait
```

*Most* of the smp_text_poke_batch_finish() IPIs are gone with the patches, the
one or two that remain are due to other, preceding IPIs forcing the isolated
CPUs out of userspace, making the quiescing condition fail.

Running rteval I mostly get flooded with =flush_tlb_kernel_range()= IPIs, which
season 2 of this should take care of.
		  
Patches
=======

o Patches 1-4 are standalone objtool cleanups.

o Patches 5-6 add infrastructure for annotating static keys that may be used in
  entry code (courtesy of Josh). 

o Patch 7 adds ASM support for static keys

o Patches 8-10 add the deferral mechanism.

Patches are also available at:
https://gitlab.com/vschneid/linux.git -b redhat/isolirq/defer/v10

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

v9 -> v10
+++++++++

o Rebased onto v7.3-rc4
o Overall renaming of "IPI deferral" to "IPI quiescing" (nikbor)

o Now handles NMI entry!
o Ditched the flush_tlb_kernel_range() stuff this time again, for now


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
  x86/mm/pti: Introduce kernel_cr3_loaded
  x86/mm/pti: Drive kernel_cr3_loaded
  context_tracking,x86: Quiesce kernel text patching IPIs when tracking
    CR3 switches

 arch/x86/Kconfig                            |  14 +++
 arch/x86/entry/calling.h                    |  71 +++++++++++++
 arch/x86/entry/entry.S                      |   3 +-
 arch/x86/include/asm/cpu_entry_area.h       |   4 +
 arch/x86/include/asm/jump_label.h           |  34 +++++-
 arch/x86/include/asm/pti.h                  |  11 ++
 arch/x86/include/asm/text-patching.h        |   5 +
 arch/x86/include/uapi/asm/processor-flags.h |   3 +
 arch/x86/kernel/alternative.c               |  59 +++++++++--
 arch/x86/kernel/asm-offsets.c               |   3 +
 arch/x86/kernel/cpu/bugs.c                  |   2 +-
 arch/x86/kernel/kprobes/core.c              |   4 +-
 arch/x86/kernel/kprobes/opt.c               |   4 +-
 arch/x86/kernel/module.c                    |   2 +-
 arch/x86/mm/cpu_entry_area.c                |   5 +
 arch/x86/mm/pti.c                           |  40 ++++---
 include/asm-generic/sections.h              |  14 +++
 include/linux/jump_label.h                  |  27 ++++-
 include/linux/objtool.h                     |  16 +++
 kernel/sched/isolation.c                    |   9 +-
 tools/objtool/Documentation/objtool.txt     |  15 +++
 tools/objtool/check.c                       | 111 +++++++++++++++++---
 tools/objtool/include/objtool/check.h       |   2 +
 tools/objtool/include/objtool/elf.h         |   3 +-
 tools/objtool/include/objtool/special.h     |   1 +
 tools/objtool/special.c                     |  15 ++-
 26 files changed, 428 insertions(+), 49 deletions(-)

--
2.56.1



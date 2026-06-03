Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B810ACD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 12:08:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDEF16B008C; Wed,  3 Jun 2026 08:08:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB5DD6B0092; Wed,  3 Jun 2026 08:08:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF3606B0095; Wed,  3 Jun 2026 08:08:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF5BB6B008C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:08:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87ED3A0362
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:08:25 +0000 (UTC)
X-FDA: 84838478970.05.F996AC0
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf03.hostedemail.com (Postfix) with ESMTP id BC79A20006
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:08:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=d5SmmfEf;
	spf=pass (imf03.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780488504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BjZzErQAmk+oO+4E0XcjmiW9hmCrWCk9t8jkFgLyPC4=;
	b=VK+9bt7hKIt+062bR90215kNpcndPHpuliB9+JZ8jbP9DRWmnvVGmzs8E9+Y60BRcv+7Fm
	KfDajiCA0m9Sp3KCen6yNXBWBI/i4r22GGMdbAjZheHFoD3fV5FMjBGBubJlB5Re7P4GFB
	17rDGRo3lLPi83G0FLAZfycaXuSsXbw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=d5SmmfEf;
	spf=pass (imf03.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780488504;
	b=lcw78gkyXzUmfJhRpqvd2JlO/B7dycFhhkVIN4K0QUfF2J/RrLVcEwnmhTjxHDtjeOqOUf
	CF3NRYGZkRW91e+dOZlhUhb30Y21aKQ4+7bytJ3zjyhmmErqRQ+rfZJRBb58eidIgICBCc
	m37NcEPixFiYXG63WsthX/GHiwIwD9Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BjZzErQAmk+oO+4E0XcjmiW9hmCrWCk9t8jkFgLyPC4=; b=d5SmmfEf7raSFzg4vFDuRz3coH
	z+67jG4KbJDEQovNpX0QBLbtbh5tdhne1+qs53r3XBtvymPRPtmo6uHSxh9oTTahgs8dAc3hjubVH
	TjxIyF2tByPYK1SNwdAus4bunqc+oiQhx3KaDikJD7OR0bH0zHwcXCFc9PxzwQo2USWMY6gaz+gax
	psOIEAn7ENGHGHDIPOHAfDrAgVYPG6MBJtugLGYM7rNY0SHSlYJY1ZLW248a62PrBMjvpfpPST3Ww
	bn+ca1kNG1zCTGcCom57PuIUIbLXrVuU18Xy917FFvYAMb+dhQxvJQYnGRos24DqYx2XD0xeX8VK0
	H/LTg4FA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wUkOK-0000000C4nY-1pBX;
	Wed, 03 Jun 2026 12:08:12 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 7A6863007A4; Wed, 03 Jun 2026 14:08:11 +0200 (CEST)
Date: Wed, 3 Jun 2026 14:08:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
	virtualization@lists.linux.dev, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com, "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH v6 5/7] locking: Add contended_release tracepoint to
 qspinlock
Message-ID: <20260603120811.GW3493090@noisy.programming.kicks-ass.net>
References: <cover.1777999826.git.d@ilvokhin.com>
 <5d7ea75ffe74a785e6b234ada9f23c6373d4b4c1.1777999826.git.d@ilvokhin.com>
 <20260513193342.GB2545104@noisy.programming.kicks-ass.net>
 <agXBb0ga_6HJrrnm@shell.ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agXBb0ga_6HJrrnm@shell.ilvokhin.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BC79A20006
X-Stat-Signature: kzc1pi7qgb37tunux6k9t6wmj8tefz9a
X-Rspam-User: 
X-HE-Tag: 1780488502-564336
X-HE-Meta: U2FsdGVkX18lFnB5VMfYvWhdcf5ClBcBl1DAJHT0DlBEtyQDsXpK6byMuvupp2k6vu9kVUqaCyA8eJLlpde1Wrt//X4sdXCdF5WA5H13TSY0PN3EE7mES/2owKDJYZNKVSIB2btYKa9o7haIHLhMdh5/NZqGdYym8G1R2cTwXUYbrt385uh4O6s5MHqe9N6guJepHjC41XbG/QD6amCeL3qgVYYL2NSG6lYVYxYhTQrvKWB78Ru2lSdb3rmKoNHo/UdYlL1Zn0HycusNFNbbT575UxvYsDPkDEuXfn+RwHEdUShzGuLJvxbdog3VWCiwTF/clyrccF418nO/aDT3F+C4yUVry1ULWXclsUAoVdX4uvqK6iuXGwRQNUyGCXzp6c//TNTsGWunuQtaDrLGPSZ1SGin+Qbr3Y8acVp4oVd12MFJB1eeQvFDsQcjrNfN8FjP0fusGovIEaR9UzX4YRR3Cdtmp9l0JYMAn0uu3xckiwBvlKiWDPS28siVEN6OXh03g2/Xqy0XuTojymA2nB6DjLAJKRkum0qI9xKfXT3/Kf9XitRoezbJ6WPJRnEi//bxmPeQUkm75daKXJOgtmravDxRunu/DcS7YzPET/9j6XAJcUSTC4IZzjmQjxDjorcyu/rGrCvdhAq3ZLpGKrbtwt8eyhmgdAuf2UxRK8hS6J5d411RtCVcBuSpLWEPk7onO7r8MS/5/+csWqC60cEXY//Ab1uoqgR1Apfor/dscTBLFX5YZBaJoGwFbxhfh7pMwHWR2XyMEEnPlaP1Lnwd+2eVSr9k3TD8H2q5qqg3h5ZwVXjsFMFQDg6UEP+k8n2mGwncvWfFc/Bn0ty1uUowwcRZUy/k14VqfgWfyngzBDQ2xg//DOH/SqDImaY2RXYx/ruaMBl88lRGe9l5uf/9qiix7cYBtuQ66rGRaj7DFwNhsIpK7cXa72qWYJn0afe4XNmXDdAIYEsXZ3u
 +3aZMmHt
 sUzFGu1lJGjny3o7wfRfKavZ0kAHQFEjM5yQM6WlHT3epHiA4bSc70BtcfctC61+Sk/edHuIRDg3pCNehmTh3F5mxazma2SLmP2ZkXKP/Tcsja9sqwwNWvA8aPAHi/gg/MPTYdmv1MzZ+wpG6DL9Gny912lFr/XKLvfOUdnXgJyVRj12CWpR+/C3Fk2lKIDHwyeYdBfjcluGk2bZ15JFQNhHV3PJ1Nm9qtTHhfXj2m2FmNHTlxyyHN14kvUPDKxegOtSHi8Fs+VC+Q1e9GqO3Bb7mvJrmpLzbZix0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 12:34:55PM +0000, Dmitry Ilvokhin wrote:

> Baseline, in best case scenario of least number of executed
> instructions.
> 
>     3e0:  endbr64                          ; 4 bytes (always executed)
>     3e4:  movb $0x0,(%rdi)                 ; 3 bytes (unlock,
>                                            ; always executed)
>     3e7:  decl %gs:__preempt_count         ; 7 bytes (always executed)
>     3ee:  je   3f5                         ; 2 bytes (always executed)
>     3f0:  jmp  __x86_return_thunk          ; 5 bytes (executed if above
>                                            ; je is not taken)
>                                            ; rest is not executed
>     3f5:  call __SCT__preempt_schedule     ; 5 bytes
>     3fa:  jmp  __x86_return_thunk          ; 5 bytes
> 
> Tracepoint (again same case of least number of executed instructions).
> 
>     bc0:  endbr64                          ; 4 bytes (always executed)
>     bc4:  xchg %ax,%ax                     ; 2 bytes (always executed, this is an
>                                            ; only addition on the execution path).
>     bc6:  movb $0x0,(%rdi)                 ; 3 bytes (unlock, always executed)
>     bc9:  decl %gs:__preempt_count         ; 7 bytes (always executed)
>     bd0:  je   bde                         ; 2 bytes (always executed)
>     bd2:  jmp  __x86_return_thunk          ; 5 bytes (executed if above
>                                            ; je is not taken)
>                                            ; rest is not executed
>     bd7:  call queued_spin_release_traced  ; 5 bytes
>     bdc:  jmp  bc9                         ; 2 bytes
>     bde:  call __SCT__preempt_schedule     ; 5 bytes
>     be3:  jmp  __x86_return_thunk          ; 5 bytes
> 

So I've been playing with this a bit, and it is all really sad.

Now, since pretty much everybody+dog will have PARAVIRT_SPINLOCK=y, the
'best' solution would be changing that paravirt call with a
static_call(), that actually shrinks the code by 1 byte.

And then this tracepoint nonsense can simply use a different unlock
function, just like paravirt.

0000 00000000000001d0 <_raw_spin_unlock>:
0000  1d0:	f3 0f 1e fa          	endbr64
0004  1d4:	ff 15 00 00 00 00    	call   *0x0(%rip)        # 1da <_raw_spin_unlock+0xa>	1d6: R_X86_64_PC32	pv_ops_lock+0x4
000a  1da:	65 ff 0d 00 00 00 00 	decl   %gs:0x0(%rip)        # 1e1 <_raw_spin_unlock+0x11>	1dd: R_X86_64_PC32	__preempt_count-0x4
0011  1e1:	74 06                	je     1e9 <_raw_spin_unlock+0x19>
0013  1e3:	2e e9 00 00 00 00    	cs jmp 1e9 <_raw_spin_unlock+0x19>	1e5: R_X86_64_PLT32	__x86_return_thunk-0x4
0019  1e9:	e8 00 00 00 00       	call   1ee <_raw_spin_unlock+0x1e>	1ea: R_X86_64_PLT32	__SCT__preempt_schedule-0x4
001e  1ee:	2e e9 00 00 00 00    	cs jmp 1f4 <_raw_spin_unlock+0x24>	1f0: R_X86_64_PLT32	__x86_return_thunk-0x4


0000 00000000000001d0 <_raw_spin_unlock>:
0000  1d0:	f3 0f 1e fa          	endbr64
0004  1d4:	e8 00 00 00 00       	call   1d9 <_raw_spin_unlock+0x9>	1d5: R_X86_64_PLT32	__SCT__queued_spin_unlock-0x4
0009  1d9:	65 ff 0d 00 00 00 00 	decl   %gs:0x0(%rip)        # 1e0 <_raw_spin_unlock+0x10>	1dc: R_X86_64_PC32	__preempt_count-0x4
0010  1e0:	74 06                	je     1e8 <_raw_spin_unlock+0x18>
0012  1e2:	2e e9 00 00 00 00    	cs jmp 1e8 <_raw_spin_unlock+0x18>	1e4: R_X86_64_PLT32	__x86_return_thunk-0x4
0018  1e8:	e8 00 00 00 00       	call   1ed <_raw_spin_unlock+0x1d>	1e9: R_X86_64_PLT32	__SCT__preempt_schedule-0x4
001d  1ed:	2e e9 00 00 00 00    	cs jmp 1f3 <_raw_spin_unlock+0x23>	1ef: R_X86_64_PLT32	__x86_return_thunk-0x4


Something a little like so, which is completely untested, except to
build kernel/locking/spinlock.o (with clang-23).

Also, I think someone should go do some performance runs with
ARCH_INLINE_SPIN_* set for x86 just like for s390.

Of course, this is only x86 done, and it doesn't nicely tie in with
tracepoints, but it does give the sanest asm.

---
diff --git a/arch/x86/hyperv/hv_spinlock.c b/arch/x86/hyperv/hv_spinlock.c
index 210b494e4de0..6b4bdea18218 100644
--- a/arch/x86/hyperv/hv_spinlock.c
+++ b/arch/x86/hyperv/hv_spinlock.c
@@ -78,8 +78,8 @@ void __init hv_init_spinlocks(void)
 	pr_info("PV spinlocks enabled\n");
 
 	__pv_init_lock_hash();
-	pv_ops_lock.queued_spin_lock_slowpath = __pv_queued_spin_lock_slowpath;
-	pv_ops_lock.queued_spin_unlock = PV_CALLEE_SAVE(__pv_queued_spin_unlock);
+	static_call_update(queued_spin_lock_slowpath, __pv_queued_spin_lock_slowpath);
+	static_call_update(queued_spin_unlock, __raw_callee_save___pv_queued_spin_unlock);
 	pv_ops_lock.wait = hv_qlock_wait;
 	pv_ops_lock.kick = hv_qlock_kick;
 	pv_ops_lock.vcpu_is_preempted = PV_CALLEE_SAVE(hv_vcpu_is_preempted);
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 1d506e5d6f46..52e7ce10df57 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -225,7 +225,6 @@
 #define X86_FEATURE_EPT_AD		( 8*32+17) /* "ept_ad" Intel Extended Page Table access-dirty bit */
 #define X86_FEATURE_VMCALL		( 8*32+18) /* Hypervisor supports the VMCALL instruction */
 #define X86_FEATURE_VMW_VMMCALL		( 8*32+19) /* VMware prefers VMMCALL hypercall instruction */
-#define X86_FEATURE_PVUNLOCK		( 8*32+20) /* PV unlock function */
 #define X86_FEATURE_VCPUPREEMPT		( 8*32+21) /* PV vcpu_is_preempted function */
 #define X86_FEATURE_TDX_GUEST		( 8*32+22) /* "tdx_guest" Intel Trust Domain Extensions Guest */
 
diff --git a/arch/x86/include/asm/paravirt-spinlock.h b/arch/x86/include/asm/paravirt-spinlock.h
index 7beffcb08ed6..553910f92906 100644
--- a/arch/x86/include/asm/paravirt-spinlock.h
+++ b/arch/x86/include/asm/paravirt-spinlock.h
@@ -3,6 +3,7 @@
 #define _ASM_X86_PARAVIRT_SPINLOCK_H
 
 #include <asm/paravirt_types.h>
+#include <linux/static_call_types.h>
 
 #ifdef CONFIG_SMP
 #include <asm/spinlock_types.h>
@@ -11,9 +12,6 @@
 struct qspinlock;
 
 struct pv_lock_ops {
-	void (*queued_spin_lock_slowpath)(struct qspinlock *lock, u32 val);
-	struct paravirt_callee_save queued_spin_unlock;
-
 	void (*wait)(u8 *ptr, u8 val);
 	void (*kick)(int cpu);
 
@@ -26,20 +24,23 @@ extern struct pv_lock_ops pv_ops_lock;
 extern void native_queued_spin_lock_slowpath(struct qspinlock *lock, u32 val);
 extern void __pv_init_lock_hash(void);
 extern void __pv_queued_spin_lock_slowpath(struct qspinlock *lock, u32 val);
+extern void __raw_callee_save___native_queued_spin_unlock(struct qspinlock *lock);
 extern void __raw_callee_save___pv_queued_spin_unlock(struct qspinlock *lock);
 extern bool nopvspin;
 
+DECLARE_STATIC_CALL(queued_spin_lock_slowpath, native_queued_spin_lock_slowpath);
+DECLARE_STATIC_CALL(queued_spin_unlock, __raw_callee_save___native_queued_spin_unlock);
+
 static __always_inline void pv_queued_spin_lock_slowpath(struct qspinlock *lock,
 							 u32 val)
 {
-	PVOP_VCALL2(pv_ops_lock, queued_spin_lock_slowpath, lock, val);
+	static_call(queued_spin_lock_slowpath)(lock, val);
 }
 
 static __always_inline void pv_queued_spin_unlock(struct qspinlock *lock)
 {
-	PVOP_ALT_VCALLEE1(pv_ops_lock, queued_spin_unlock, lock,
-			  "movb $0, (%%" _ASM_ARG1 ")",
-			  ALT_NOT(X86_FEATURE_PVUNLOCK));
+	__STATIC_CALL_MOD_ADDRESSABLE(queued_spin_unlock);
+	asm volatile ("call " STATIC_CALL_TRAMP_STR(queued_spin_unlock) : ASM_CALL_CONSTRAINT);
 }
 
 static __always_inline bool pv_vcpu_is_preempted(long cpu)
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 29226d112029..5908d9fd94bb 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -1135,9 +1135,8 @@ void __init kvm_spinlock_init(void)
 	pr_info("PV spinlocks enabled\n");
 
 	__pv_init_lock_hash();
-	pv_ops_lock.queued_spin_lock_slowpath = __pv_queued_spin_lock_slowpath;
-	pv_ops_lock.queued_spin_unlock =
-		PV_CALLEE_SAVE(__pv_queued_spin_unlock);
+	static_call_update(queued_spin_lock_slowpath, __pv_queued_spin_lock_slowpath);
+	static_call_update(queued_spin_unlock, __raw_callee_save___pv_queued_spin_unlock);
 	pv_ops_lock.wait = kvm_wait;
 	pv_ops_lock.kick = kvm_kick_cpu;
 
diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index 95452444868f..28407304f123 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -25,9 +25,12 @@ __visible void __native_queued_spin_unlock(struct qspinlock *lock)
 }
 PV_CALLEE_SAVE_REGS_THUNK(__native_queued_spin_unlock);
 
+DEFINE_STATIC_CALL(queued_spin_lock_slowpath, native_queued_spin_lock_slowpath);
+DEFINE_STATIC_CALL(queued_spin_unlock, __raw_callee_save___native_queued_spin_unlock);
+
 bool pv_is_native_spin_unlock(void)
 {
-	return pv_ops_lock.queued_spin_unlock.func ==
+	return static_call_query(queued_spin_unlock) ==
 		__raw_callee_save___native_queued_spin_unlock;
 }
 
@@ -45,16 +48,11 @@ bool pv_is_native_vcpu_is_preempted(void)
 
 void __init paravirt_set_cap(void)
 {
-	if (!pv_is_native_spin_unlock())
-		setup_force_cpu_cap(X86_FEATURE_PVUNLOCK);
-
 	if (!pv_is_native_vcpu_is_preempted())
 		setup_force_cpu_cap(X86_FEATURE_VCPUPREEMPT);
 }
 
 struct pv_lock_ops pv_ops_lock = {
-	.queued_spin_lock_slowpath	= native_queued_spin_lock_slowpath,
-	.queued_spin_unlock		= PV_CALLEE_SAVE(__native_queued_spin_unlock),
 	.wait				= paravirt_nop,
 	.kick				= paravirt_nop,
 	.vcpu_is_preempted		= PV_CALLEE_SAVE(__native_vcpu_is_preempted),
diff --git a/arch/x86/kernel/static_call.c b/arch/x86/kernel/static_call.c
index 61592e41a6b1..1268b7dc93b1 100644
--- a/arch/x86/kernel/static_call.c
+++ b/arch/x86/kernel/static_call.c
@@ -3,6 +3,7 @@
 #include <linux/memory.h>
 #include <linux/bug.h>
 #include <asm/text-patching.h>
+#include <asm/paravirt-spinlock.h>
 
 enum insn_type {
 	CALL = 0, /* site call */
@@ -31,6 +32,15 @@ static const u8 retinsn[] = { RET_INSN_OPCODE, 0xcc, 0xcc, 0xcc, 0xcc };
  */
 static const u8 warninsn[] = { 0x67, 0x48, 0x0f, 0xb9, 0x3a };
 
+/*
+ * ds ds movb $0, (_ASM_ARG1)
+ */
+#ifdef CONFIG_64BIT
+static const u8 unlockinsn[] = { 0x3e, 0x3e, 0xc6, 0x07, 0x00 };
+#else
+static const u8 unlockinsn[] = { 0x3e, 0x3e, 0xc6, 0x00, 0x00 };
+#endif
+
 static u8 __is_Jcc(u8 *insn) /* Jcc.d32 */
 {
 	u8 ret = 0;
@@ -78,6 +88,10 @@ static void __ref __static_call_transform(void *insn, enum insn_type type,
 			emulate = code;
 			code = &warninsn;
 		}
+		if (func == &__raw_callee_save___native_queued_spin_unlock) {
+			emulate = code;
+			code = &unlockinsn;
+		}
 		break;
 
 	case NOP:
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 83ac24ead289..f718e535ea7c 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -134,9 +134,8 @@ void __init xen_init_spinlocks(void)
 	printk(KERN_DEBUG "xen: PV spinlocks enabled\n");
 
 	__pv_init_lock_hash();
-	pv_ops_lock.queued_spin_lock_slowpath = __pv_queued_spin_lock_slowpath;
-	pv_ops_lock.queued_spin_unlock =
-		PV_CALLEE_SAVE(__pv_queued_spin_unlock);
+	static_call_update(queued_spin_lock_slowpath, __pv_queued_spin_lock_slowpath);
+	static_call_update(queued_spin_unlock, __raw_callee_save___pv_queued_spin_unlock);
 	pv_ops_lock.wait = xen_qlock_wait;
 	pv_ops_lock.kick = xen_qlock_kick;
 	pv_ops_lock.vcpu_is_preempted = PV_CALLEE_SAVE(xen_vcpu_stolen);
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index 86d17b195e79..61541f042f74 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -225,7 +225,6 @@
 #define X86_FEATURE_EPT_AD		( 8*32+17) /* "ept_ad" Intel Extended Page Table access-dirty bit */
 #define X86_FEATURE_VMCALL		( 8*32+18) /* Hypervisor supports the VMCALL instruction */
 #define X86_FEATURE_VMW_VMMCALL		( 8*32+19) /* VMware prefers VMMCALL hypercall instruction */
-#define X86_FEATURE_PVUNLOCK		( 8*32+20) /* PV unlock function */
 #define X86_FEATURE_VCPUPREEMPT		( 8*32+21) /* PV vcpu_is_preempted function */
 #define X86_FEATURE_TDX_GUEST		( 8*32+22) /* "tdx_guest" Intel Trust Domain Extensions Guest */
 


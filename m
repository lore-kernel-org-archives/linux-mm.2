Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8C06CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 12:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15F8D6B0088; Thu, 14 May 2026 08:35:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 110846B008A; Thu, 14 May 2026 08:35:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 026686B008C; Thu, 14 May 2026 08:35:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E64C46B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:35:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C816160215
	for <linux-mm@kvack.org>; Thu, 14 May 2026 12:35:01 +0000 (UTC)
X-FDA: 84765970002.09.8C19551
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf12.hostedemail.com (Postfix) with ESMTP id 558DA40007
	for <linux-mm@kvack.org>; Thu, 14 May 2026 12:34:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=TPhTdjRF;
	spf=pass (imf12.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778762099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y+NhCJjnIZyhnFujkvatnyre5bEmJDwtE/E2M912hG8=;
	b=z0CfKG0IXsEdG1FDT+RPTo5aFgOUUmqlQVndx02AQr4aXNEkwbvxj8UB0/ZV/0ZO53TUrt
	vrG6bAsmce4cDMubW4m9Kmry5X5gUI3B5QB0x03hB1eekXbS5d1N5yhIDR7X/LYDKHFdnZ
	n7STEVaN5UNRaHnopUnph6MdbHo9PCg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778762099; a=rsa-sha256;
	cv=none;
	b=6wdgb3tS85S4lCOvhnWgtpk/YpAHpGBzoP720qYJkrMFSS2zCOQAQ1I50sEvZ3YNvvrzHC
	bCeEPjxDHXX4XrlNrcYIhV7lw2Mk6+r6uNM1tiTUwj6mMy8s+vDBp0QqOBjwqveAvNlHvD
	uNsTeFAPXauBEZspBR9girym6JPVsp0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=TPhTdjRF;
	spf=pass (imf12.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 1CA72D0561;
	Thu, 14 May 2026 12:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1778762097;
	bh=y+NhCJjnIZyhnFujkvatnyre5bEmJDwtE/E2M912hG8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TPhTdjRFI6bMS/OOKJ54lvD0Jdu5GlRo183R5LUgQF8SFnSSgF6fvmv9sUFJ1/TQa
	 X1WeGQhCjDPJ7i1MJ3Ykh9XzBWrgV+6lsqXU+f6jXBVEPbYIwq/a70DQrmXtQhv+Iq
	 TENdnh+SCz5u1nhJ8ccEuUihtJsrMS8emVKDMXAU=
Date: Thu, 14 May 2026 12:34:55 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <agXBb0ga_6HJrrnm@shell.ilvokhin.com>
References: <cover.1777999826.git.d@ilvokhin.com>
 <5d7ea75ffe74a785e6b234ada9f23c6373d4b4c1.1777999826.git.d@ilvokhin.com>
 <20260513193342.GB2545104@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513193342.GB2545104@noisy.programming.kicks-ass.net>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 558DA40007
X-Stat-Signature: 96cqbgbqcpjn3efhtnjzgrqjdbkn7khf
X-Rspam-User: 
X-HE-Tag: 1778762099-382595
X-HE-Meta: U2FsdGVkX19w3Did9q8YtPHbVoLYbMH/qiV0mPv+X4BNykJlJS34a271+JR4POYm9UOXXs40uHqgKMA4cFLLjsnwtSrsfYd2ELOmucCPGzKjN+LeixmJKNGJH05juxyZ5ZE8UUOMX6U0EwK5TptQg9SABFLNrCthISjsbAUfUV67x0Wa9aH4Ypx8cegdt1+BOLIJKNE+71NJOL7mQsI6i8U57OJw9dqxXrRlvaD4w1DSdBsLNv2vvFDz2K1fCB4ej5Mo9r/WmsZGenexVrIu32A19yqzmny4UZ2uVrdnA3++WLzHELmqqsmYgodP7AcZViV/B7Ts5vsMqIjWEFLTD+kYh/xEhoVoZqTfcwscEov3nO0FYvPZpSnyK44jamKa4tCOoQn0A328gVsU0o/SI2GXp29Zj2FeUGGfujshgrvhbeTn7bVC8Q2KicvEyuqkWgTjkvryMLOBN+Lm95rG/hgG+2CaI/XF50stEqYpjhtm5kvgIwtBrPcXk533gXg/VhHSuFloTSFhaJl3f3VxVGPEpI25RXw64elE56+TxZvYOYsfazxokvk1DqOp5kOPLQtWinrQ+LgjYFQKL4Nh5LEHxV7WUnh+hbVeI81QQ22Q61Xip5i6ih1Xy+/BH1/PUCrH/sdzLMwU91SgyC4+CjAQFgpO5jl014jo8SPp75TcA0lSD1g1Hx0AenQ6LJhPyy34+hlHT/OPsqi8gF/wu/eWIq28MjBlhlnlQ0kBcPQdAfhEJZnhirBNKEC1Cmbj06DdlG+0IqSjiHQqFm2IAZxujcXATuBWDmPH7v9spvPcuBY+6Z6U/bxwRtDPaDAA54Y0D4HAW6BtLm05wahZCGPm4x+ejkkQG3tAVWz5q+oU/pdWjMnOL0JE2yp2mtEZfdlXzps+luI1I+vVoHYQTcwsuqeCt5ObY5lQ8bsPghgnYvQph5Vjeb8kEtXtBgwg/KFPxFr4Kg3b/+H7KSx
 JiTJf7tJ
 45tKK2Sk+xDTPddLrt6HLlN9HaJcSEVFvjtQ2TZrfo+bxFPO1H7GDV2vHqrNapfW5Hj0JXdYrjWHE7K/MaO2vgJIE5piPHQxlBdOBdXWdJISQPJ+TA7NrzSs18AZtK8M/Yj7WYDIVPnSt3mMybA11tLio632UTxT0r/fdDZrJv67iGy7KrwCe/LY6C64iOISg8f4aSZ5tGUKrlI4BdelyV1TzOUzwzy9+/LpmfxjHzYVI32BeLhAY1XJJCeRov1l8I0I/EFwvfYuGGk5M1YzwJUS0yS+2JN1FX+8p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 09:33:42PM +0200, Peter Zijlstra wrote:
> On Tue, May 05, 2026 at 05:09:34PM +0000, Dmitry Ilvokhin wrote:
> > Use the arch-overridable queued_spin_release(), introduced in the
> > previous commit, to ensure the tracepoint works correctly across all
> > architectures, including those with custom unlock implementations (e.g.
> > x86 paravirt).
> > 
> > When the tracepoint is disabled, the only addition to the hot path is a
> > single NOP instruction (the static branch). When enabled, the contention
> > check, trace call, and unlock are combined in an out-of-line function to
> > minimize hot path impact, avoiding the compiler needing to preserve the
> > lock pointer in a callee-saved register across the trace call.
> > 
> > Binary size impact (x86_64, defconfig):
> >   uninlined unlock (common case): +680 bytes  (+0.00%)
> >   inlined unlock (worst case):    +83659 bytes (+0.21%)
> > 
> > The inlined unlock case could not be achieved through Kconfig options on
> > x86_64 as PREEMPT_BUILD unconditionally selects UNINLINE_SPIN_UNLOCK on
> > x86_64. The UNINLINE_SPIN_UNLOCK guards were manually inverted to force
> > inline the unlock path and estimate the worst case binary size increase.
> > 
> > In practice, configurations with UNINLINE_SPIN_UNLOCK=n have already
> > opted against binary size optimization, so the inlined worst case is
> > unlikely to be a concern.
> 
> This is not quite accurate. You add the (5byte) NOP for the static
> branch, but then you also add another 5 bytes for the CALL and at least
> another 2 bytes (possibly 5) for a JMP back into the previous stream.
> That is 12-15 bytes added to what was a single MOV instruction.
> 
> That is quite ludicrous.

Thanks for the feedback, Peter. This is exactly the kind of feedback I
was looking for.

I understand your concerns and initially I had exactly the same
thoughts, and after I looked into the generated code more carefully the
impact on the executed path is smaller than the total size increase
suggests.

Generated code of _raw_spin_unlock() for baseline (before the patch) is
31 bytes in total (x86_64, defconfig, GCC 11).

    3e0:  endbr64                          ; 4 bytes
    3e4:  movb $0x0,(%rdi)                 ; 3 bytes (unlock)
    3e7:  decl %gs:__preempt_count         ; 7 bytes
    3ee:  je   3f5                         ; 2 bytes
    3f0:  jmp  __x86_return_thunk          ; 5 bytes
    3f5:  call __SCT__preempt_schedule     ; 5 bytes
    3fa:  jmp  __x86_return_thunk          ; 5 bytes

Generated code of _raw_spin_unlock() with tracepoint (after the patch
applied) is 40 bytes in total.

    bc0:  endbr64                          ; 4 bytes
    bc4:  xchg %ax,%ax                     ; 2 bytes (NOP, static branch)
    bc6:  movb $0x0,(%rdi)                 ; 3 bytes (unlock)
    bc9:  decl %gs:__preempt_count         ; 7 bytes
    bd0:  je   bde                         ; 2 bytes
    bd2:  jmp  __x86_return_thunk          ; 5 bytes
    bd7:  call queued_spin_release_traced  ; 5 bytes
    bdc:  jmp  bc9                         ; 2 bytes
    bde:  call __SCT__preempt_schedule     ; 5 bytes
    be3:  jmp  __x86_return_thunk          ; 5 bytes

It is 40 bytes (+9 bytes compared to baseline, 2 bytes for NOP and 7
bytes for CALL and JMP).

But if we look at the executed path the picture is a bit different.

Baseline, in best case scenario of least number of executed
instructions.

    3e0:  endbr64                          ; 4 bytes (always executed)
    3e4:  movb $0x0,(%rdi)                 ; 3 bytes (unlock,
                                           ; always executed)
    3e7:  decl %gs:__preempt_count         ; 7 bytes (always executed)
    3ee:  je   3f5                         ; 2 bytes (always executed)
    3f0:  jmp  __x86_return_thunk          ; 5 bytes (executed if above
                                           ; je is not taken)
                                           ; rest is not executed
    3f5:  call __SCT__preempt_schedule     ; 5 bytes
    3fa:  jmp  __x86_return_thunk          ; 5 bytes

Tracepoint (again same case of least number of executed instructions).

    bc0:  endbr64                          ; 4 bytes (always executed)
    bc4:  xchg %ax,%ax                     ; 2 bytes (always executed, this is an
                                           ; only addition on the execution path).
    bc6:  movb $0x0,(%rdi)                 ; 3 bytes (unlock, always executed)
    bc9:  decl %gs:__preempt_count         ; 7 bytes (always executed)
    bd0:  je   bde                         ; 2 bytes (always executed)
    bd2:  jmp  __x86_return_thunk          ; 5 bytes (executed if above
                                           ; je is not taken)
                                           ; rest is not executed
    bd7:  call queued_spin_release_traced  ; 5 bytes
    bdc:  jmp  bc9                         ; 2 bytes
    bde:  call __SCT__preempt_schedule     ; 5 bytes
    be3:  jmp  __x86_return_thunk          ; 5 bytes

On the execution path we are getting 21 byte worth of instructions on
baseline against 23 bytes. The only addition on any executed path is the
2-byte NOP, that has a special treatment in CPU, cheap, but not entirely
free.

From a total size perspective it's 9 bytes, but on the executed path it's
a single 2-byte NOP.

Does this change the picture for you, or is the NOP still a concern for
this path?

> 
> I disagree that UNINLINE_SPIN_UNLOCK=n opts against binary size. For x86
> the unlock is smaller than a function call.
> 

Fair point on the UNINLINE_SPIN_UNLOCK characterization, but
UNINLINE_SPIN_UNLOCKis always "y" on x86_64. The inlined case only
applies to s390 (unconditionally), csky and loongarch (when
!PREEMPTION). I'll remove this, thanks.

> 
> I really don't see how this is worth it.


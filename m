Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05DBCC4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 19:08:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0CE26B008C; Tue, 21 Jul 2026 15:08:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE3F56B0093; Tue, 21 Jul 2026 15:08:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFBE56B0095; Tue, 21 Jul 2026 15:08:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8CFE76B008C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 15:08:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 12F67140283
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 19:08:31 +0000 (UTC)
X-FDA: 85013720022.11.A74CDE3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id E6F7DA0013
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 19:08:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qtmSlt+Y;
	spf=pass (imf25.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784660909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PdTw4Ljy/iEi6EJKnYY/hTaPD8fG2xXNmAjMarXklqU=;
	b=dgeY3VFgc9wL1Uf6Jjq+/NV95AUQX/aE7uZD1TJ+UbaxFdyf5fVdceizKeeAt+pclg5gje
	GvQQyY1LS+JFLho5B9fJf3agzSP4fBx4OEzRv+KXzi8kAJ3nrmpdNn1NmkHqYZXVXb2ia8
	qVDuqqzf5is7+EsrC5zoIWw0qd8W0R4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784660909;
	b=V7YjZfBk+wGGPnXV2xPJupymZMs7Bc1aeiSiO13jABgUMpc+iwLNT2oPi7RyPR/5gL5xVE
	J8OfTh4UwgbmzA9SGCsaXFttuRBYipSk2zEOUOS+uGNi/qZn/1LOUs+oCOkndlIAiButWT
	0mCk1qDI1Z7aGXNwxsxKPcbwotAsf/w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qtmSlt+Y;
	spf=pass (imf25.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2EFF152B;
	Tue, 21 Jul 2026 12:08:23 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 10ED43F58B;
	Tue, 21 Jul 2026 12:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784660907; bh=6TZNhGMiK6SIIRkXwPe07Z1IbHnyi9FAC1oXtous4SM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qtmSlt+YSuFKMmK97ciSuK0jD2TtFWOpJZ/4+0L3kKd7p/KzmZprjUDCL50RIJ4su
	 jZNtWdT21n9OWv405MRaEowPh4FZPtevxz8huBWMZJf7WNjfNsCKsiaSOFHzXji5nU
	 xWcioUiVkpu9s1lxQsD58gdsiYwJyJCjV8aeTl9Q=
Date: Tue, 21 Jul 2026 20:08:20 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>, cl@gentwo.org,
	dennis@kernel.org, tj@kernel.org, urezki@gmail.com,
	catalin.marinas@arm.com, will@kernel.org, david@kernel.org,
	akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com,
	agordeev@linux.ibm.com, linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
Message-ID: <al_DpFJFcmVhxpvW@J2N7QTR9R3>
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
 <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com>
X-Stat-Signature: 4zegtrb6jfn3emqu64ihht3uxisnd7hz
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E6F7DA0013
X-HE-Tag: 1784660908-155152
X-HE-Meta: U2FsdGVkX1+STiVrCdRetQFA+SiSPZdl+2YFdZDUcCwBEO4Wgc5g7MWRMgB7Caj99jKJE9Uc/tntYUEze9x/CKGBvbZl0e1hl+9P1jv1XlLlwxFYPuU0AlzKbYxD7tRPa+QyOCJ3+4TVfmvIENJ4aYm5XabqcBTH3hAD9Twjlatmvwpk6CXYhOUNyLMqGrE7juL27WdxUGk06ZKGelopw+W63S1lXR65jbQ/3h1ji9TjbqykTCxDItGowpzpKCe4hF503cTg4ICObJD/RTbEcKpMA6pB5NPjK5hpkKH10N2SQTQxVdxXD3lSFgJ+noUAnVZqnFE1WrDa90cVDCpCRzDDcEDnAVl47g2/RXkzBrzYDKX8GGfkbeQ2vSGpoAdOiiBVhU0bTlBWWSud/MkaTMRlRkXI9hqOEDRH8kAIJEoAhpfg7tgtBUZ3iui0ZOqQaxIoSbJf1NubcxQsStt800tA/loq1RpphhFjaxbaSXpi1TPMOyZvHUfSti7ZmD/kYBJYhvvRROQC17p/eoyf0a+gzjgzAoq+Sn171CAcfhBq40NhCj3OgLwAr3oGOp+4Qc/GYjlD47PB72L/w71tJpd1ONSA/a44xVN6NIqtZTi/czInxCedx5uDwfwRaGp1eBFSjVKvQhVRUCmf3/J/X8TdlSD2hVlOTIGdLGnhB4CC+/UxXoYjbz6Tx6SJe2pi1oxk3Ej2KK/LoiLyW2WGwTDyLUwrbFPzjjDV6ZZVNK/Gd16oWHtJ6eqfoN7Qo6wZI/jECgjM085VOuigxF9Nma94pP2H37kpCCCrll1YH1KpzzeFug2b9MMVtWavDjISvC8/M9Msq2+L44FcHaaOMCj6fpUJC1En876UeMEttJEnIEYO0pV75Ka4WeW/xcmX+802KwfTeD5tfvBAXMBD4mDvQWivZGnmIWe2ZUNWg0FQ3RLlgouBLakwYjrMPzL0xeTjLi10ARb5Baw8QJd
 oJA1hndj
 O+6m8zhU4Zevvva9/0WT9rm8fr6UcztA24h+bbch+BfANLQmQ6/FF4heguuB4mK2rysUGII/DS/FIKgksCC8ONw2FueBI+cQPGOdOzhdPkP9JFkc/X1l9EnMsjBqXtkc5EzaF8VZ7sz8osYuRK1dYpeAhnQGl24+ScxLSFrGOJ8eTIOOLfGaUUluoZxL/w3EWszPLOoM53M0yBJlGzOgGU45QWkarHAOHaPgUxwCxED2duCdnrGfcZb67N/cwuXw6nsZRLU/ACAK9toanCfNcKuLzEraHXrYYWWCzbUSCD5QvRbD+eBpF4MTQySJ/+jzKgGd3VWKSYuRXuVy/aFtiYzh96DiCjzvmoEHdLT7hFVJeoI10PDmA4I2z3KS+qEV8oMu1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 02:23:33PM +0100, Ryan Roberts wrote:
> We have observed a few performance regressions recently, for which the
> root cause is increased use of this_cpu_*. We have somebody at Arm
> about to start an investigation into whether in-kernel rseq can solve
> the problem.

FWIW, I had a look into something rseq like (resetting the PC upon
preemption or any exception), and I ended up with a GPR fixup scheme.
That avoids the need to disable/enable preemption, and only requires a
read of current and a couple of stores, which *should* be cheap.

The approach is similar to Peter Zijlstra's in-kernel rseq scheme [1],
and Heiko Carsten's approach for s390 [2]:

  [1] https://lore.kernel.org/lkml/20260223163843.GR1282955@noisy.programming.kicks-ass.net/
  [2] https://lore.kernel.org/lkml/20260526055702.1429061-1-hca@linux.ibm.com/

A key difference is that I ignore the PC entirely, and *only* track whether
GPRs are in use by a critical section. The GPR fixup is idempotent, and
can safely be applied anywhere in the critical section. Ignoring the PC
means that (in theory at least) this should work with kprobes, etc.

I've rebased and cleaned that up a bit, and pushed a WIP version to my
arm64/percpu-fixup branch:

  git://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git

I'll aim to have a more complete/polished version out in the near
future.

The key idea is that every percpu op has a critical section during which
it maintains three distinct GPRs:

  <pcp> : The original __percpu pointer.
  <off> : The percpu offset.
  <addr>: The final pointer (<pcp> + <off>).

Whenever the kernel performs an exception return back into a critical
section, it can fix up <off> and <addr>, as described below. The
critical section is roughly as follows:

	/*
	 * Prologue.
	 *
	 * At the start, <pcp> is already set, but <off> and <addr> are
	 * uninitialised.
	 *
	 * After this STR, upon an exception return into this critical
	 * section, the kernel will:
	 * 1. Update <off> to the current CPU's offset.
	 * 2. Update <addr> to be <pcp> + <off>.
	 */
	mrs	<tsk>, sp_el0
	mov	<tmp>, ENCODE_REGISTER_NUMBERS(<pcp>, <off>, <addr>)
	strh	<tmp>, [<tsk>, #TSK_TI_PCPU_GPRS]

	/*
	 * Generate the address. Any preemption within this critical
	 * section will result in <off> and <addr> being updated to
	 * match the CPU that this is resumed upon.
	 */
	mrs	<off>, TPIDR_ELx
	add	<addr>, <pcp>, <off>

	/* The actual operation, e.g. read/write/cmpxchg */
	DO_SOMETHING_WITH(<addr>)

	/*
	 * Epilogue.
	 *
	 * After this STR, the kernel will no longer apply the fixups.
	 */
	strh	wzr, [<tsk>, #TSK_TI_PCPU_GPRS]

To handle nesting, the exception code is updated to save/restore the
register numbers in pt_regs (and clearing the active value at entry) so
that this safely nests.

With that, a simple test case such as:

  u64 outline_this_cpu_read_u64(u64 __percpu *p)
  {
          return this_cpu_read(*p);
  }

... is reduced from:

  <outline_this_cpu_read_u64>:
         paciasp
         stp     x29, x30, [sp, #-32]!
         mrs     x1, sp_el0
         mov     x29, sp
         ldr     w2, [x1, #8]
         add     w2, w2, #0x1
         str     w2, [x1, #8]
         mrs     x2, tpidr_el1
         ldr     x0, [x0, x2]
         ldr     x2, [x1, #8]
         sub     x2, x2, #0x1
         str     w2, [x1, #8]
         cbz     x2, 1f
         ldr     x1, [x1, #8]
         cbnz    x1, 2f
  1:
         str     x0, [sp, #24]
         bl      0 <preempt_schedule_notrace>
         ldr     x0, [sp, #24]
  2:
         ldp     x29, x30, [sp], #32
         autiasp
         ret

... down to:

  <outline_this_cpu_read_u64>:
         mrs     x2, sp_el0        // Prologue
         mov     x4, #0xc80        // Prologue
         strh    w4, [x2, #20]     // Prologue
         mrs     x4, tpidr_el1
         add     x3, x0, x4
         ldr     x1, [x3]
         strh    wzr, [x2, #20]    // Epilogue
         mov     x0, x1
         ret

... which is clearly much better.

As noted above, the branch is a WIP. There are a bunch of things to do
(in particular, factoring out the xchg and cmpxchg assembly), but I
don't currently see a major technical blocker for the fixup approach.

Mark.


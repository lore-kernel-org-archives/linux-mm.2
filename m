Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 823E1CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 16:03:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECFE46B0005; Thu, 14 May 2026 12:03:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA7866B0088; Thu, 14 May 2026 12:03:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE4AD6B008C; Thu, 14 May 2026 12:03:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CD6826B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 12:03:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B10E1603A0
	for <linux-mm@kvack.org>; Thu, 14 May 2026 16:03:56 +0000 (UTC)
X-FDA: 84766496472.29.394CB6F
Received: from relay.hostedemail.com (unirelay02 [10.200.18.65])
	by imf16.hostedemail.com (Postfix) with ESMTP id C004918000A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 16:03:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778774634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q+YetlaZHNTtWqI7zkRQOPJWd9d9vKs3Lj1Uanwbri4=;
	b=3+vFOmtsl/fW/vESGzbly+sNyQMMGoVwYdWFMDUGwTnCzX6riKFDmCEx68xKaDFl5dg2jv
	RGC0qgdg5qAc3+NfHIV61cZSVUvvceYqBeW3+lenCOVA0hwuXBue7Os0vmWFO7t0AuizC0
	fzAWqqMNLwKLpJe7mrAVuv0AqEfORv8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778774634; a=rsa-sha256;
	cv=none;
	b=FxYAr6DvffJdIBfANhTPH9sts+rJe/+kLlFsaRZ2zCSScsAUy37+3h9h3iL/hHQ7Y8r+U8
	VOl3qD4gpc5zxvAkenyT3lbUkkf+1F3Da5j9tIhasx9FgsrYhMAenr6gaQWkjabBk9yXHR
	XvS+a0kw+dku4JEyDp/XUdwntP5P7r0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	none
Received: from omf19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4F1EB12032B;
	Thu, 14 May 2026 16:03:51 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf19.hostedemail.com (Postfix) with ESMTPA id 3251B20028;
	Thu, 14 May 2026 16:03:45 +0000 (UTC)
Date: Thu, 14 May 2026 12:03:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>, Waiman Long
 <longman@redhat.com>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Juergen Gross <jgross@suse.com>, Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>, Broadcom internal kernel
 review list <bcm-kernel-feedback-list@broadcom.com>, Thomas Gleixner
 <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, Dennis Zhou
 <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter
 <cl@gentwo.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org,
 linux-mips@vger.kernel.org, virtualization@lists.linux.dev,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, kernel-team@meta.com, "Paul E.
 McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH v6 5/7] locking: Add contended_release tracepoint to
 qspinlock
Message-ID: <20260514120348.7a64facc@gandalf.local.home>
In-Reply-To: <agXYjw3GM15WtC-H@shell.ilvokhin.com>
References: <cover.1777999826.git.d@ilvokhin.com>
	<5d7ea75ffe74a785e6b234ada9f23c6373d4b4c1.1777999826.git.d@ilvokhin.com>
	<20260513114102.50f4ca68@gandalf.local.home>
	<agXYjw3GM15WtC-H@shell.ilvokhin.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18+AovYNGIlALhyn+K5C/7gpJOZfNyJEu4=
X-HE-Meta: U2FsdGVkX19HQDyuK5W1sWFaIilY7bm7Gf/MZYHKwmEDTE3ZbhyKfVzPtSNaRvRwwLibMDr+clEajGn4IMslvXyWRSAtdRw7n20LqpU/ZL1JRwQy7RM1IZ8C/G8JiCKlU7NLZxt8T0jLkJLCLpPM7qJ+dpyaKbSRbUbJJ9wssRC6BHcQX6wyCcVcl8zzZF/OVyWwMsrTKquwAEsHp9WwFxub5w8dGBF9fpamxEC5Vrgn4VfpydBb94gT6qa9OETZ2G0tA+8SrtKJggxMx1uuZ2LNQUPr2vuo/NU83uN08IiVbeRQ5csVSw+NNSzK03CbEK4AKDmVTf9PZCF/6yk3hM3689icTTPJeoQXH95ipe2RYbbc23zucZ9uSvKuke71iwqS2WK43PR19rLABJH2Mw==
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C004918000A
X-Stat-Signature: buuxgtcqdf9hr38h7teah8p8j8cig556
X-Rspam-User: 
X-HE-Tag-Orig: 1778774625-341613
X-HE-Tag: 1778774634-363589
X-HE-Meta: U2FsdGVkX19DuAKAKvjzlFl/rSUoAzc5nKXnboAKc4Je5YOGQNoqpf286myaMJWS+B36L8564v2Cx36C42M2YBkeUDjqwXVSJhauINPEWejhaKAzO63+jbAeFpeR09/vU0zm4L2c22cs9hRBPf7addazusEJS20H+ADridD7oFTwB7owfWMg+KTBcctuFoUixyenpfmQ4W5NnJLbnqFb16i9kofmqUS+NU398XlUs5Z1FRPLZtpypgWczN6klDYawbDEP0MflVLjPsRoE5pGNE8w0TKFD/7hTpRAULs3sh1NffL18qwWdbb+rbvxB//yQvrPaxWeS7TQvYF3oAFLVYKjQHHhYBIVrZa8eKTZ8WJyJwuYL9MV7OJly5lCCn9rLQXdgBkhJKrcTqefpySfGfCKpUFfwkgWzODSOfHUObOZY4Hsf5BJQ+JOfvRjZNce3gcoEIiySSs7F7PssC0ki8ssdJwv0iEF4st8CaZIl3FxjGaGO792XyXyLLUWByW0uA79jtwGijhygU7qNroI1NEgMgRFgd+42AWgyEvLVQX/3spJabHaaihrraG4kcDjuVxDeWx98ql11al84EqSlVvNPvbjwtoW0EvLBs087CVRwZ/Gtu58ukxXJC6LHde3KTH33dPbqe4/JFayzQCNbk1g9fU4ioAqcE5+Q3Fuj9AdAfG22/9PU2i59eWCydIROhUA4Fk26ECOMipElMX6pD9b0Q8to3aLdK5YpGZ4KYzORDeEk7gcDfC1FiQcpvin6/oal0n9Cv+XTc8mZ0+CAuEII2kl12fIdgYQeni7ms8nH9AYi8Z9IpnAgf7CYxJCmAJToo89Tb9+69mJk306LkG4Uhxn4AYKGTPMI2H4P5cxNT02eCRen4Bij0fW6SnZj6YxqGUu87AF27VXBIav2kYSdt+8JHRj6MUfvCfFTp4j/jykalMQmjePp+M31KVMzRtmNDIB+zsc2wcyDru
 sms55MX4
 1P0m5K+HhseHP77Fq4MnX3zNCUVygcdzsh7yQLiRHt6qe6kTwXyJ37HCzBb61/8zML5Y4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 May 2026 14:13:35 +0000
Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> > > +void __lockfunc queued_spin_release_traced(struct qspinlock *lock)
> > > +{
> > > +	if (queued_spin_is_contended(lock))
> > > +		trace_call__contended_release(lock);
> > > +	queued_spin_release(lock);  
> > 
> > And then remove the duplicate call of "queued_spin_release()" here.  
> 
> This is the scenario the comment above the static branch describes.
> Here's what it looks like in practice on x86_64 (defconfig, compiled
> with GCC 11).
> 
> Current design (trace + unlock combined, with return):
>   
>     endbr64
>     xchg %ax,%ax                     ; NOP (static branch)
>     movb $0x0,(%rdi)                 ; unlock
>     decl %gs:__preempt_count
>     je   preempt
>     jmp  __x86_return_thunk
>     call queued_spin_release_traced  ; cold
>     jmp  preempt_handling            ; cold
>     call __SCT__preempt_schedule
>     jmp  __x86_return_thunk
> 
> With the trace-only function (no return, unlock after the call):
>   
>     endbr64
>     push %rbx                        ; saves callee-saved rbx (!)
>     mov  %rdi,%rbx                   ; preserve lock across call (!)
>     xchg %ax,%ax                     ; NOP (static branch)
>     movb $0x0,(%rbx)                 ; unlock
>     decl %gs:__preempt_count
>     je   preempt
>     pop  %rbx                        ; callee-saved restore (!)
>     jmp  __x86_return_thunk
>     call queued_spin_release_traced  ; cold
>     jmp  unlock                      ; cold
>     call __SCT__preempt_schedule
>     pop  %rbx
>     jmp  __x86_return_thunk
> 
> Three extra instructions marked by "!" on the hot path (push, mov, pop),
> all wasted when the tracepoint is off. That's the main reason for
> combining trace and unlock in the same out-of-line function.

Ah, because the return makes it into two tail calls.

I still don't like the duplication, perhaps add some more comments about
needing to update the other location if anything changes here? And perhaps
comment that this duplicate code helps the assembly.

-- Steve



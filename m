Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A642FCD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:13:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17DD76B0092; Thu, 14 May 2026 10:13:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 155F36B00CE; Thu, 14 May 2026 10:13:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 093216B00CF; Thu, 14 May 2026 10:13:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE51D6B0092
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:13:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B8E101C0FBB
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:13:40 +0000 (UTC)
X-FDA: 84766218600.26.CDE5303
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf20.hostedemail.com (Postfix) with ESMTP id A78341C0013
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:13:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=2LqHdCq5;
	spf=pass (imf20.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778768019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CEtEQitvr5ZkBK9ei+U84T7UAt16YdxOYlqifuRSuCs=;
	b=nAkq+XYlvzj/Fh6SGxr6V3qUQ5iH9Dclcj681ySZmWfuDjlLOrTGE3HTQ0NrztkRuNLVBA
	4w0sAEZeVxrGo9mP29r4JIZH1o7hAVt80JCJ1BMVjfOPJW30yUw4Hog5cW8jraai2j1vxp
	5gn0ODoDo3j1uPQ9aAwEQY8TgHzFRhY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=2LqHdCq5;
	spf=pass (imf20.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778768019; a=rsa-sha256;
	cv=none;
	b=CpfYfHKv98NQuvQzDgb1oD6H5xHdvs7HCFL3mi0fF9/zdIwUHmvCSjbBHhMs0TMxdQqbyc
	O3tiygRGMywATGon9YJqMIN+XGF7p77e3bBGkb6e0B2Hv/gqdyWAidGxbdfBZZYaQp+B3K
	gvTSJjGNAKx+4obS6DlMJRDKi+rGyaA=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 92774D0572;
	Thu, 14 May 2026 14:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1778768016;
	bh=CEtEQitvr5ZkBK9ei+U84T7UAt16YdxOYlqifuRSuCs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=2LqHdCq5tSBQ3BZqU0GmdOcvGsRqUa4wcPdAHu8hjvMz6CYEy0/FcUOv3IiSY6ajb
	 LJ3OiABsNiurRx+c2LFTGtfo/wrG5XGj49b8jVqXLWLHz8oq3JNDQsDBaYJg6nMv4k
	 SnM09PPyXc4AO4h3CaPUrJA/LHwqYctv2hZXMW48=
Date: Thu, 14 May 2026 14:13:35 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
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
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
	virtualization@lists.linux.dev, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com, "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH v6 5/7] locking: Add contended_release tracepoint to
 qspinlock
Message-ID: <agXYjw3GM15WtC-H@shell.ilvokhin.com>
References: <cover.1777999826.git.d@ilvokhin.com>
 <5d7ea75ffe74a785e6b234ada9f23c6373d4b4c1.1777999826.git.d@ilvokhin.com>
 <20260513114102.50f4ca68@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513114102.50f4ca68@gandalf.local.home>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A78341C0013
X-Stat-Signature: k13xc6p3gy85om8firwkorwyod4frdpd
X-HE-Tag: 1778768018-275781
X-HE-Meta: U2FsdGVkX1/pT2b5PrvQhD7r0hyZHe3/y8PAW8wJLmjYG/RtwZwVehVvHOFqmXjL2Z+MJPeoP12FOFe+dtDVMJ9vJiWrYfbA8csnxYzsASEcc5dX9wJsL5Ng1WL1SfcLIOfB2vcy01VKYJOkNjxd+Qb4/iywkOw3lub5jdo/eBMxyxCJsjsH3l9inVbHwdcvqR85CrFe03mU25U2nGeRlU5ZYJv6hPMdbVq3WOuf/eKW3Il2fZWHWor0sO7jZPY3z6yZG+PO0Z5iYKGADMQC0CDo/TMvWcIoEJErblSQONedlUKV9/T7aXWQo3gnARjj4AYy3xEK7fRUIO4RpHX1Seii0mvbg2wRIn442rDbxo7BWp1n7HVZSw80D5CMy4777XXFn+Po6GGp0LIg191qq3drh7PRvdsUJHO2lMbFvJeejjgkCu+9VIjowbSZJoLb49PJ0x/syfRz2zVNz7JxAmFxU+a69zmwDfw7Oyh17TTAxBqRoDZ/c1wZegUfnwLHBVK6oocNIPolV00vBBOvHP2daBNuUwVDA6IWIxd1Sh3dLrrJ5PQYLzDjUph+q/p53V6iiSNQYTO0egj8KOEMtNR40MXMUH/h807Wa8NZsQjLopjVGPzh6zh6Plc/XY0goNT+e4M3hFtExLjWsy/X2wUHPBNAKoTtCAawn+R5/v2D+eilvmhmUwmk83njTpylcRO+7ivDCZtw2q35vG5hRdjxl/0LQ05X4RLRcBUvaGr04SQRHaLhVGMSdJRFpMJXsG6BEIjfzgGWUuaPckkpZo2eOudHoRzZYydVqIslHeObRIHBwZRSzodNkaRcGL+XhH1eXuzq2an73sXHzaVhBsYffiWKXre9SsqtYDtGburQ6xtiuu89ZmBPTYhq/AHAk6n+rgx/fdR+gkAiQfsyN4xKuz2q4aOlkmFlNVGqAQYJ5sN+2EzQd/Au2I0p7QJFTMds4ZR4OAayuB0Xl+R
 L84DToxz
 dfgtJlzkNp4+aZZMceUu5B3dPU9CThQRddGpe0hMvM4ZcMJ8kcdDiWr9dyHYCdvxjoEGuCP1s18Zi4y1g+YjGSGydWL06UC9wS8ewVjFQa8ly7+g9ugzr6wTwPbVLAtOKKsxO7qQ0ObRhOv7wnWlcCOZ/ZmxyHjY4O0NUks+XMVP2bNeUa3i3UEZwffdarXreh7oy7TMFjma/ZtDbtZ5FNrAmOITPHEvYKkmEj6kqkNqrJHapvPW46wCFMeLFRrC9x4zN+90PONiaMHaoznPflDpV5L2IpNJTqcmXiWOYgRc/83JCASapM1J8D3R75RVgxeYltxfLrBsg4nGKzq2d/Al/X5JYF8QveyEkN0kQKOOMLJ6bRb6Hp1aovEc1nseNsatd3kzvWKiqa2pgWbFPn9cSGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 11:41:02AM -0400, Steven Rostedt wrote:
> On Tue,  5 May 2026 17:09:34 +0000
> Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> 
> > Use the arch-overridable queued_spin_release(), introduced in the
> > previous commit, to ensure the tracepoint works correctly across all
> 
> Remove the ", introduced in the previous commit," That's useless in git
> change logs.

Thanks for the suggestion, will do here and in other places.

[...]

> >  /**
> >   * queued_spin_unlock - unlock a queued spinlock
> >   * @lock : Pointer to queued spinlock structure
> > + *
> > + * Generic tracing wrapper around the arch-overridable
> > + * queued_spin_release().
> >   */
> >  static __always_inline void queued_spin_unlock(struct qspinlock *lock)
> >  {
> > +	/*
> > +	 * Trace and release are combined in queued_spin_release_traced() so
> > +	 * the compiler does not need to preserve the lock pointer across the
> > +	 * function call, avoiding callee-saved register save/restore on the
> > +	 * hot path.
> > +	 */
> > +	if (tracepoint_enabled(contended_release)) {
> > +		queued_spin_release_traced(lock);
> > +		return;
> 
> Get rid of the "return;". What does it save you? It just makes it that you
> need to duplicate the code. Even though it's a one liner, it can cause bugs
> in the future if this changes. You could call the function:
> 
>   do_trace_queued_spin_release_traced(lock);
> 
> 
> > +	}
> >  	queued_spin_release(lock);
> >  }
> >  
> > diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
> > index af8d122bb649..649fdca69288 100644
> > --- a/kernel/locking/qspinlock.c
> > +++ b/kernel/locking/qspinlock.c
> > @@ -104,6 +104,14 @@ static __always_inline u32  __pv_wait_head_or_lock(struct qspinlock *lock,
> >  #define queued_spin_lock_slowpath	native_queued_spin_lock_slowpath
> >  #endif
> >  
> > +void __lockfunc queued_spin_release_traced(struct qspinlock *lock)
> > +{
> > +	if (queued_spin_is_contended(lock))
> > +		trace_call__contended_release(lock);
> > +	queued_spin_release(lock);
> 
> And then remove the duplicate call of "queued_spin_release()" here.

This is the scenario the comment above the static branch describes.
Here's what it looks like in practice on x86_64 (defconfig, compiled
with GCC 11).

Current design (trace + unlock combined, with return):
  
    endbr64
    xchg %ax,%ax                     ; NOP (static branch)
    movb $0x0,(%rdi)                 ; unlock
    decl %gs:__preempt_count
    je   preempt
    jmp  __x86_return_thunk
    call queued_spin_release_traced  ; cold
    jmp  preempt_handling            ; cold
    call __SCT__preempt_schedule
    jmp  __x86_return_thunk

With the trace-only function (no return, unlock after the call):
  
    endbr64
    push %rbx                        ; saves callee-saved rbx (!)
    mov  %rdi,%rbx                   ; preserve lock across call (!)
    xchg %ax,%ax                     ; NOP (static branch)
    movb $0x0,(%rbx)                 ; unlock
    decl %gs:__preempt_count
    je   preempt
    pop  %rbx                        ; callee-saved restore (!)
    jmp  __x86_return_thunk
    call queued_spin_release_traced  ; cold
    jmp  unlock                      ; cold
    call __SCT__preempt_schedule
    pop  %rbx
    jmp  __x86_return_thunk

Three extra instructions marked by "!" on the hot path (push, mov, pop),
all wasted when the tracepoint is off. That's the main reason for
combining trace and unlock in the same out-of-line function.


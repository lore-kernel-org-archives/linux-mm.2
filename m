Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E860CD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 14:40:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 510686B008C; Fri, 15 May 2026 10:40:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E77B6B0092; Fri, 15 May 2026 10:40:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 424716B0093; Fri, 15 May 2026 10:40:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 34CD96B008C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 10:40:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CA04F1A0150
	for <linux-mm@kvack.org>; Fri, 15 May 2026 14:40:09 +0000 (UTC)
X-FDA: 84769914138.04.3B01304
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf09.hostedemail.com (Postfix) with ESMTP id E754B140014
	for <linux-mm@kvack.org>; Fri, 15 May 2026 14:40:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=RRKzNl+V;
	spf=pass (imf09.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778856008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LjG5aYhzzCdGlhgt68FcixNTeEbd8ZYVpF7B/Blnyp4=;
	b=TT9XOY4HPXnbvs0oopdgLGoYnvI1EqUiGNDIUd3DdYjvpI9+s7cZGDWqr9p3ekJ0k0xK2H
	6Z5sXU5lKtlR/9DmxMEbp6L4C8ErkMOYfFdqie+INBh93B/swFUsD0AUlpqAlzcN/pMRh5
	h7b3xZldvRcKlXpEO7D/ylR+fbzZ4eQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=RRKzNl+V;
	spf=pass (imf09.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778856008; a=rsa-sha256;
	cv=none;
	b=sqLIK93iptRQMr9381LFvoJCuOoZSncM+d1kU/Xec8VG5PPwJPVXUCtx5DJsjGapOV3BFH
	zV6/h6KztPG2mAIWhhIbUfcMyecwRarb2OExs2rjdU3aHrZDgbTzCe0o7XVZsDX8MeNGwe
	RiU2CIZ/PrlHqmlHcCoeY64pvEdGPm0=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id A6BBDD05D9;
	Fri, 15 May 2026 14:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1778856006;
	bh=LjG5aYhzzCdGlhgt68FcixNTeEbd8ZYVpF7B/Blnyp4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RRKzNl+VV4JDQiTUTKJ02htUMGGPz54aJtGB88rZY2lugizfNL4xXA0Miw5TsKpcf
	 D4TSVDE/+biY08/6wdh797My6cEELDA9ZfGm2JSTat+ZT93VbFxGJpNSW1q6kQ8PKV
	 QKxA7ZfwkUZg+o+FdxV6aIyGaEILsAXINCAZcSpI=
Date: Fri, 15 May 2026 14:40:04 +0000
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
Message-ID: <agcwRNNgoYVSpDKq@shell.ilvokhin.com>
References: <cover.1777999826.git.d@ilvokhin.com>
 <5d7ea75ffe74a785e6b234ada9f23c6373d4b4c1.1777999826.git.d@ilvokhin.com>
 <20260513114102.50f4ca68@gandalf.local.home>
 <agXYjw3GM15WtC-H@shell.ilvokhin.com>
 <20260514120348.7a64facc@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514120348.7a64facc@gandalf.local.home>
X-Rspam-User: 
X-Rspamd-Queue-Id: E754B140014
X-Rspamd-Server: rspam06
X-Stat-Signature: bq56i34f549df69f1q7yjmabiwkhu4s8
X-HE-Tag: 1778856007-37168
X-HE-Meta: U2FsdGVkX19kl1YxfufiHXuBWee4jYbSz6RU4/DXNkPs1JdheodCXfhO4MjT7GW/jQO07ymGdhFpFcA0XdK9x5v5JfMGMGIpsAs64T8cCbzp6zXMxQDW10WPjGaou9QHKPZ3HMtE8nkQx3lUnGh8iI79FQzdh5rOMuWmvf2XoTEj6/rvT6Ar2Ci+PfI4+sd4gYSdcO/k10fEvCC7eFW+3XOE5OkFUMhhUc0Ul2aDNTUt7cwgqKWgny3q21g96sM4t0+MKJ/Fwuv5jOGtXJ7SGaMtGg1cegL+p9kNcxLJqNJ4kBbSC2JRwUatHkdugFhRoKCPJ6h7uQBaTlhUNlNudFe/+QE3+r/oeOnP+RH+NTZs9nCbBdPgwoNOkeiGnaesf2Si+T9Qa/Pdeiu0lCl57X5JP+pZrvh+VJZX6PavQwKRGSrtKzc1KxhMZLOH5swBrvE2EeMZc+RudWJqlwvbYkhFdsr1ZANdaTUv97RZLSN3Z0Qif2ufJyt7rqMVySR0pEVxc1E8RnjyzhADHsJEv7+Rbv6kMH8N/j4CYxfkfOwptvH6VhyoOFhPkK4G1JPYszysXq5l58IoVmSxQVtFDzW2c0IDUJHpPECxp5AqB+fk/Je+8QJq76gbJlXNqYk1UKSXSqmsnoQBYimmf3PeNhRpcz44Xij2OHDL3A3e0WG6sRmUENrxBNhcneUcaGwwAkLYHtkyyIq3cGPEPGdKH4KWTJfEUzGk/R7UznKi43sQ9G2bqM4rxQcEUZlxvvSnrunsu+dsaMvrM+qeZ5jTBGLDKUDia7htkv1XvZsgGEW4EqLNzDqaiN8yj2Kv5k3sSjw7F8O+K6ia4SCkewD3WseWBd2UCvcOUXvWj6V4pK8qbxGIqIzxFFjotYQkJJaEgVpK6JQuAIsPltNpUwX35IG+hoW8QB2SnGIqdOTKHENm0MrBJIKrIoo2GVyrsrpi7ABPJQPn7dZLt4JekrD
 mVLjdkMS
 j0J1BGaSyhEDxCxbvEYj5LPNsscoG5Xg8wNR7GvJsrNOvDNSW9O6xxCe0Q4DaV3VEI/qn8G86FsLtAWL1F3gOXF1eiiAFe12BP4gJ9k6FUVndq2b/fEJzAFE/pGEg3fG4+DWifiOy08HbL/gx4s5gDG1GSgdUOcaQnB+8cWd1krDjGLH0TXXjtDqXfSUljHHv3d5hTOQBWnFuboACFV5/PyhXibidAq/XK5AhrsZM8pidfcKdLTCVUaypaOO0TGA+7Pr8eebsiMVi4M5vQZkY71UCjiKzsGyRXauWVJUm6n7je0FWh8xs3vJU1DvByr/TE0DR3Co8LjLYhD436rd58aK8c8NwjSgJJks1g/GoWuuwQtWBGcHO7nvwOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 12:03:48PM -0400, Steven Rostedt wrote:
> On Thu, 14 May 2026 14:13:35 +0000
> Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> 
> > > > +void __lockfunc queued_spin_release_traced(struct qspinlock *lock)
> > > > +{
> > > > +	if (queued_spin_is_contended(lock))
> > > > +		trace_call__contended_release(lock);
> > > > +	queued_spin_release(lock);  
> > > 
> > > And then remove the duplicate call of "queued_spin_release()" here.  
> > 
> > This is the scenario the comment above the static branch describes.
> > Here's what it looks like in practice on x86_64 (defconfig, compiled
> > with GCC 11).
> > 
> > Current design (trace + unlock combined, with return):
> >   
> >     endbr64
> >     xchg %ax,%ax                     ; NOP (static branch)
> >     movb $0x0,(%rdi)                 ; unlock
> >     decl %gs:__preempt_count
> >     je   preempt
> >     jmp  __x86_return_thunk
> >     call queued_spin_release_traced  ; cold
> >     jmp  preempt_handling            ; cold
> >     call __SCT__preempt_schedule
> >     jmp  __x86_return_thunk
> > 
> > With the trace-only function (no return, unlock after the call):
> >   
> >     endbr64
> >     push %rbx                        ; saves callee-saved rbx (!)
> >     mov  %rdi,%rbx                   ; preserve lock across call (!)
> >     xchg %ax,%ax                     ; NOP (static branch)
> >     movb $0x0,(%rbx)                 ; unlock
> >     decl %gs:__preempt_count
> >     je   preempt
> >     pop  %rbx                        ; callee-saved restore (!)
> >     jmp  __x86_return_thunk
> >     call queued_spin_release_traced  ; cold
> >     jmp  unlock                      ; cold
> >     call __SCT__preempt_schedule
> >     pop  %rbx
> >     jmp  __x86_return_thunk
> > 
> > Three extra instructions marked by "!" on the hot path (push, mov, pop),
> > all wasted when the tracepoint is off. That's the main reason for
> > combining trace and unlock in the same out-of-line function.
> 
> Ah, because the return makes it into two tail calls.
> 
> I still don't like the duplication, perhaps add some more comments about
> needing to update the other location if anything changes here? And perhaps
> comment that this duplicate code helps the assembly.

My idea was that queued_spin_release() serves the same role that the old
queued_spin_unlock() had: a pure lock-release primitive without tracing.
That was the primary motivation for extracting queued_spin_release() in
the first place (it is just one line of code), so the common release
logic between the traced and non-traced paths is shared explicitly
rather than duplicated semantically.

I agree that this could be explained better. I'll add more comments
there to clarify the rationale. Thanks for the suggestion, Steve.

> 
> -- Steve
> 


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25473CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 14:27:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89A346B0096; Wed,  3 Jun 2026 10:27:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8721D6B009B; Wed,  3 Jun 2026 10:27:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AEC56B009D; Wed,  3 Jun 2026 10:27:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A3A66B0096
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:27:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 210171A0276
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 14:27:13 +0000 (UTC)
X-FDA: 84838828746.17.B52937D
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf22.hostedemail.com (Postfix) with ESMTP id 069B4C0009
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 14:27:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="mXm4zhu/";
	spf=pass (imf22.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780496831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=os4aRjDnafKUzup1QuKJHbiKJ+/dQN99U138wr5Ge48=;
	b=OROXSoUikTeVbIuk8JNGXDx/wuRDvZvJeRBWOkdh7K5C8UNW4LnwRY8Dk/3SjJ91sZgQjE
	1CGIvGM3Z4JstGlNhOn7rhe4Gnhtz+RE2G81RG5kdeqFCWkN4l62ik+PLHXeZJ0MzpZ40M
	7r0ogFdueqBPR7WBQd80/j7+8YegOTI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780496831;
	b=CAE9TXC89D9RoVdly8ZbwlLUET+d7G1Y50EP6yBGRC7lkp7O+raR76HS4qs5O/x2he6oBv
	Z/Vc6gN4bRbKe12eo468Ue8OIyW32eILKAH1l4+iuoGc8gXYLblUkHR4LjsP8snmtWe7SW
	wU0dwKqodA3jql3qyuH34m/WTubWBLM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="mXm4zhu/";
	spf=pass (imf22.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=os4aRjDnafKUzup1QuKJHbiKJ+/dQN99U138wr5Ge48=; b=mXm4zhu/Rg+tWnyBEHPAizygP+
	MokSQOOwsmHArQ5zsrd7YX3dwe41qJEnF1l5tg9WYaOHQgJI7SXdYYZZQyEz4Rtg697HMdeiKdyNY
	V6QXv/NtFvmWLicZFBildOj3UogNmhtP8Ig6qT0IAl6uvnLiEBLKWu1anuSJI+qD+b8E9YGOA5KnK
	AD/mZR5Hl1ie8T7XhS/5kg/3/z3q/me369Frj+mf4355m7BAd1/WiLPkkTV+l9MyKXB24EQCXsLht
	mZny4wOhaOGbHX+TMYQmQ1cefA+QUrDIee5OqkmMyL0JDD02lRozDH6sryst0Ib0jaTxT1G7v7bpu
	7mO+FzAA==;
Received: from 2001-1c00-8d85-4b00-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:4b00:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wUmYe-0000000CPBt-2ufD;
	Wed, 03 Jun 2026 14:27:00 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 67A053007A4; Wed, 03 Jun 2026 16:26:59 +0200 (CEST)
Date: Wed, 3 Jun 2026 16:26:59 +0200
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
Message-ID: <20260603142659.GW3102624@noisy.programming.kicks-ass.net>
References: <cover.1777999826.git.d@ilvokhin.com>
 <5d7ea75ffe74a785e6b234ada9f23c6373d4b4c1.1777999826.git.d@ilvokhin.com>
 <20260513193342.GB2545104@noisy.programming.kicks-ass.net>
 <agXBb0ga_6HJrrnm@shell.ilvokhin.com>
 <20260603120811.GW3493090@noisy.programming.kicks-ass.net>
 <aiA3dzjKVq2_cpSY@shell.ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiA3dzjKVq2_cpSY@shell.ilvokhin.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 069B4C0009
X-Stat-Signature: qr4bghmdxjept6wbitrcswtnn3f97qqn
X-HE-Tag: 1780496829-982535
X-HE-Meta: U2FsdGVkX1+DdwsjMRLLiL+tCmtfsraKT7TAbn46fDhJkeuI5H655fAWvtX/MAGmxiAKH6ygzxl+VZpOLgy5tUqwe08yv28eKR5nunZBxPxzDB6alDQHc+DgpJexCCFY9J3F6rCRGLJVfu15QK/cMgUSmgMpMlLjx9gJK2tydnH4rCrjnnb9I+y6rSWzvcxTBgA2UhNUvJAUI+Sw/FRU9Rt2EVvoKGhEl5Sm4zVo8/RwyW4eY0P6lFYHMCASAd1wkQARrqMKav1hvBmCqkdAzYNxsgiDSalLS0UhW5ShNsm8VWcWUT/bFwyQR4PlpfbBnP3hGCMCbiri8surdiRx0pitJI3Ghitw7+DrEbTk2y21FZTOUoBebzToEShE6nBInkLHMxGr2Q1wC3YPZ4fffzLM2BtRyfOk3HG/9Gvo9t9Zm6c4jcVpk+CMO1WR3BUo7q9kWt8PI/F/SAmFDz5GckyJe3j0D7MooyirOGcukT6rO8sSzYhHtxkd/unaYLlFmjl2gr5/6qjUgrba37QDSGWjm9DIzZkxrh07tFm5M3TiNeLBQ4fXb4vTbc2ylBQOEvA5Ut5j4ankzHaoWcoYLle2mXxRudxdvoLC/D65lY3g7cHcMRZRGM65S++EMIRif0NfE9el8vtZk4Pk4vsy3EOiy3Et9+6R7RZA4u4QPYmo8BRsIDZX+y9LHpIcwyty20TrfYbGXeR2GGEPxO7owesLAH14uru3NZhqG87LTUodGxVG+xUpOVkVWdh/he/SS7i3Jw5xm8sU17QsVON4cb52zK7U+Sn9cGpCbqjPPiq9WHwhQ00cfHfUm9IXS1N1YKmJlm2YftbPyz2UDO1dCIiA3YH7NKpkn8SCWUvWb6dyBS94/2sMBloX44fUfGQLIUZ3AztGCPiRKNqG1oZ0XIkH5UgqggdQXjWal3/zGDhDGpFkVbnW7P6vKqueaTZ6JxQ9NU+eGN0a+pJFEXh
 stnkDe3K
 lEOyzQY5y+OYH3V65fVJQxhTpeIQH6GmCc5Ec6SEdU2T6YUjtgi32YG+Fyr362TAl658p7gJXF/SMjH+i+2Mv5Avj3YBk97In6KeCaa2OFISHihNhwqB+oQ5z0/iivj0XW5v6THnZ3EWNiZ+SYf9ZkHUDgJ/GPmzP3FjQHibNEBxnQqrl40/rEAZs11vSr+vbv2sER6OaDznOlZqGlPsbiw0QZys7AQYGOqu18OGxJidebfdrvcbFfZvShiTyR40zd+2WBr4U4/J1YtaMmLFUBLtRQ693qEQ72+aakdjEHp18gLazqTOGa917tQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 02:17:27PM +0000, Dmitry Ilvokhin wrote:

> > Something a little like so, which is completely untested, except to
> > build kernel/locking/spinlock.o (with clang-23).
> 
> Thanks a lot for taking a look, Peter.
> 
> I like the static_call idea. It's truly zero cost on x86 (and, as you
> note, even a byte smaller). The one caveat is that it relies on
> HAVE_STATIC_CALL_INLINE to stay free. 
> 
> So my plan would be: static_call where HAVE_STATIC_CALL_INLINE is
> available (x86), and a static branch fallback elsewhere, gated behind a
> default-off config so it imposes nothing on arches/kernels that don't
> opt in. I'm mostly interested in x86, but would like arm64 to work too,
> which would use the fallback.

(i386 doesn't have STATIC_CALL_INLINE, but nobody cares about the
performance on that target, so anything goes really ;-)

> 
> Concretely:
> 
> 1. Split the sleepable-lock patches out and send them separately.
>    They're independent of the static call work and look far less
>    controversial.
> 
> 2. Convert the paravirt spinlock unlock to a static_call, as the
>    foundation for the unlock tracepoint. I'm happy to take a stab at it.
>    Let me know if you'd rather do it yourself.

Yeah, I think that patch as-is *should* work, but like said, I haven't
even tried it, so it could be terribly broken :-)

> 3. Build the unlock tracepoint on top: static_call where it's cheap,
>    config-gated static_branch fallback where it isn't.

Right, so I think we need some sort of custom callback for tracepoint
enable/disable. Its been a minute since I dug through the tracepoint
code, but I don't think it provides that with a convenient wrapper, but
it should be doable.

One thing to note is that when you set the tracepoint unlock function,
it should either tail-call into the original function, or you have to
create two unlock_trace functions, one for native and one for paravirt
and pick the right one.

> Does this plan sound reasonable to you?

Yeah, should work.

> > Also, I think someone should go do some performance runs with
> > ARCH_INLINE_SPIN_* set for x86 just like for s390.
> 
> That's a good point, I'll run benchmarks and report back with the
> results.

Thanks!


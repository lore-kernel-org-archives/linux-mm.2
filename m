Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2641F1061B2E
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 12:16:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69EF16B0092; Tue, 31 Mar 2026 08:16:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6760D6B0095; Tue, 31 Mar 2026 08:16:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58BF46B0096; Tue, 31 Mar 2026 08:16:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 44A376B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:16:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD35113890B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:16:50 +0000 (UTC)
X-FDA: 84606256980.06.693D705
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf13.hostedemail.com (Postfix) with ESMTP id E0E332000B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:16:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=E9ChVItp;
	spf=pass (imf13.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774959409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fmOnVSldgMRg/8pGDKo6wUzrYFaZS5iOwP+Hm7ivSzc=;
	b=RUbLGjbWJ6ZbsdSZX9KolOYkrppEis8vVuZtMg2Ooxr/8gE8MuULLhF4N0TzjqWZXtODcE
	loUcC5wQojCAF+ojd33qOMAfrvqxjde27mSbw8qZiHVvB2UhJprUVwp9VSKg2050nYm29X
	a397ao6oRgaxBLdNCEre92/7JKAjXzU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=E9ChVItp;
	spf=pass (imf13.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774959409; a=rsa-sha256;
	cv=none;
	b=AWj8+KuX/vh5G0p9OflDhdMLkQbRV34ILgSvpOVlhns+4w5EvCvYietlDHkgeZF38O8UGn
	U8cE2/v6C4Sa8Qf+QJ+uWnjHam92LuCGz/e6RNsWfI/hJcUWkcPSL9OUJqKWRI6lH2CelH
	A2p3Pm2djgblYGS2YU460B5MCcivIIM=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id C7DD3BE242;
	Tue, 31 Mar 2026 12:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1774959407;
	bh=fmOnVSldgMRg/8pGDKo6wUzrYFaZS5iOwP+Hm7ivSzc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E9ChVItphVkjUtNNOlIsaXKqbJIKHVd05tZl9VjsTincvkl4+6OIMtozfMyTd9khm
	 wG63Wu+eCzPfC9aBKGIUFKss7uZL7kLRRjZxL80a35fei1ME7K/m2xG6Ft5zImKYdQ
	 nXNrJwdEjYs6yNqfZ5evrY6xy632+Hfb5anmMfN0=
Date: Tue, 31 Mar 2026 12:16:45 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Usama Arif <usama.arif@linux.dev>
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
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
	virtualization@lists.linux.dev, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 3/5] locking: Add contended_release tracepoint to
 sleepable locks
Message-ID: <acu7LdegiZ5_-dEW@shell.ilvokhin.com>
References: <d2e5763278812499335b22a013aafb4979e3324b.1774536681.git.d@ilvokhin.com>
 <20260331103451.1070175-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331103451.1070175-1-usama.arif@linux.dev>
X-Rspamd-Queue-Id: E0E332000B
X-Stat-Signature: fko79ik5gtrh3kqyp1jy7ibnxy7ohoap
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774959408-950269
X-HE-Meta: U2FsdGVkX1/Y2up+yXCL/kd3sRR/0XAV7ArGs5EDCEM879X+WiF3O2bDnmS7XPN6lt2sF0UYTCTTXi87O4YulI5orRNXXVWlobq0oRXCTR/IJ3i0yLNgj6w7m/sLyFzkIhFdtDVwD48/wIkQSLvbkYbKHHg4RXaj5eebj+k71QzLoa+d1h9Gtdlbx7MMZ6voCndsutJ31VVxdcSRKYX5ujUEa+f0QUCzIf2YY4DqEGorjXO7kD2RFc6APKvkvBVeb+o9GI4eYOzxk8FTA6GFoRCJPLGxbRIXgap7JxwHdJ4zalD6effPIGOH0EJlRLFixQg3YuMVDjCUsV97RUMUNYgDe6NpF7Hab1y/ykNHRKhanW16IysTp7S0s5QCzB/oOZMUR7rHDa6BorMITprdHqSW29MmFWhzWMPeDHmC4u6kCEjUjJbPKsbTmAuUPr57nD5TlNS3A2zVTR0dLJ9KsTixgiTPmbRtxZv3g0Z/zQrV/R91X5JxzsKERF+4LcA69y2U4Rx3VoXhO0MEjJzoavOmKhaP4681HU/nlTN2qo83ab8dIr1F6Ut266k+gPTvfeAEuVQZwuQPsec5T2W1zWSVIPg+8P07ulMQgAISDKzYeu/dCyhccsvjScLQkar4Nlnn8XFk1hAlJoJQQgjzqu4Vc3m8IN5BK8KOB0g95tnrpxSVkCWMqkLPkArlyR4y04hHctQOMCa83IOO+jUyg05ABH+CtQ+XY3D3M3/bguplf2YUOuxnDtKVx8q8zgAfiJdxdfooRXcATPjcplxFjuuMrqbGmQxloVi3+oLu4touJPzY6+TuuI2bnYCav43UQCEA8/eB6DbJEkWJL+PdDb0bvnZMiETRC7jcrFilm5u56DnjteObYC1fCgMoZrhrQOeNQqqm8y2aA3IMK/bXwDtmSlerw8cfBKZSMSyHNuliGFUU/pqQ2D6TrN/aA2XAdUFfaWm2sjtqqnYVdO9
 nagPGTZj
 PpxQZ6dSOUVs45yQRlHVs1ehQUHYzN0LRxtPFi9NMCpG5Pxl8caYJe+GAFGCFPOrSN5EkgI+34atMvWtfHxfQ1jvkOiuBlFXMEHj/E0+3m8LB7fjX7OdhaFJL5H+cC/XuShw8L8xIcYRlIT7K58iLOob0aXWhGlsPvkvHRuOs7j8W3KmyMWnv5/SEKK186vYRflaf23OyiqACMOMy43An8stXdwusO3/mYi0OdmkLowJaLPdOQUBNUxv3PnWIg/lyyKh9UPNXla5fCdVocE5cPEIzfi+KFioBYbtq7JkGweL4Mj8qdA/8C1iSkTwMA1TEOZaAxU8PVD2n1bYrCJF/sbRUxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 03:34:50AM -0700, Usama Arif wrote:
> On Thu, 26 Mar 2026 15:10:02 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> 
> > Add the contended_release trace event. This tracepoint fires on the
> > holder side when a contended lock is released, complementing the
> > existing contention_begin/contention_end tracepoints which fire on the
> > waiter side.
> > 
> > This enables correlating lock hold time under contention with waiter
> > events by lock address.
> > 
> > Add trace_contended_release() calls to the slowpath unlock paths of
> > sleepable locks: mutex, rtmutex, semaphore, rwsem, percpu-rwsem, and
> > RT-specific rwbase locks.
> > 
> > Where possible, trace_contended_release() fires before the lock is
> > released and before the waiter is woken. For some lock types, the
> > tracepoint fires after the release but before the wake. Making the
> > placement consistent across all lock types is not worth the added
> > complexity.
> > 
> > For reader/writer locks, the tracepoint fires for every reader releasing
> > while a writer is waiting, not only for the last reader.
> > 
> > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > ---
> >  include/trace/events/lock.h   | 17 +++++++++++++++++
> >  kernel/locking/mutex.c        |  4 ++++
> >  kernel/locking/percpu-rwsem.c | 11 +++++++++++
> >  kernel/locking/rtmutex.c      |  1 +
> >  kernel/locking/rwbase_rt.c    |  6 ++++++
> >  kernel/locking/rwsem.c        | 10 ++++++++--
> >  kernel/locking/semaphore.c    |  4 ++++
> >  7 files changed, 51 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
> > index da978f2afb45..1ded869cd619 100644
> > --- a/include/trace/events/lock.h
> > +++ b/include/trace/events/lock.h
> > @@ -137,6 +137,23 @@ TRACE_EVENT(contention_end,
> >  	TP_printk("%p (ret=%d)", __entry->lock_addr, __entry->ret)
> >  );
> >  
> > +TRACE_EVENT(contended_release,
> > +
> > +	TP_PROTO(void *lock),
> > +
> > +	TP_ARGS(lock),
> > +
> > +	TP_STRUCT__entry(
> > +		__field(void *, lock_addr)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		__entry->lock_addr = lock;
> > +	),
> > +
> > +	TP_printk("%p", __entry->lock_addr)
> > +);
> > +
> >  #endif /* _TRACE_LOCK_H */
> >  
> >  /* This part must be outside protection */
> > diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
> > index 427187ff02db..6c2c9312eb8f 100644
> > --- a/kernel/locking/mutex.c
> > +++ b/kernel/locking/mutex.c
> > @@ -997,6 +997,9 @@ static noinline void __sched __mutex_unlock_slowpath(struct mutex *lock, unsigne
> >  		wake_q_add(&wake_q, next);
> >  	}
> >  
> > +	if (trace_contended_release_enabled() && waiter)
> > +		trace_contended_release(lock);
> > +
> 
> This won't compile? waiter is declared in the if block, so you are using
> it outside scope here.
>

Thanks for the feedback, Usama.

waiter is declared at function scope, right on top. It's also assigned
before the if block, so it's still in scope at the tracepoint.


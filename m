Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7705FF53D69
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 15:32:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA93F6B02E4; Mon, 16 Mar 2026 11:32:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C28E66B02E6; Mon, 16 Mar 2026 11:32:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5FBD6B02E7; Mon, 16 Mar 2026 11:32:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A379D6B02E4
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:32:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 733DD1C2F7
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:32:14 +0000 (UTC)
X-FDA: 84552317388.17.6FED460
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4655F18000F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:32:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=EDifI+bq;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf06.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773675132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z7lLkAHeLGSHr1ZiNnNC5vKEy7HRABxlzZYRGN1R9Ko=;
	b=Rg7MX9ijUUXJO+wOaEKspA6tFxLSdXdv/g9HdqE/iVONkvd031QFAfgNS7RHwecAIS8xsW
	6Il6YTloyy1Nb6cDFwZ2HlV/2Xwvkty1cBachl4590C0ps8oF52YsBOxVY8U946o0kpF1T
	a1sCUXHlnxZ08FcKBmVQfLVQyv/GncQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773675132; a=rsa-sha256;
	cv=none;
	b=S3rIhnbJ8ez0pCHJQsvjzNvG8Sio5qODBLJ4t7fz/1YME1b+QOypcHzAs+jMq23048S3Dc
	ZwuJl8gHwrEkcw7RDLM6+6XRLmykSEHE0Z/82tHOJyvpClLMO1H5HvTBaKDwiAjp1kUGlQ
	mv+rnj6jCGmQ5zcPkNoBOpQI+5SG1qA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=EDifI+bq;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf06.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 96513B3C3A;
	Mon, 16 Mar 2026 15:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1773675130;
	bh=Z7lLkAHeLGSHr1ZiNnNC5vKEy7HRABxlzZYRGN1R9Ko=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EDifI+bqJWjIpRUPhvq5Kq4913/23Qez627nTi2AuX1yqmD1y0HHxvbDQ5k+/Qloj
	 DgZlV+vg+osCbj4k/Qg+UMc9RNVHWi4408Qw0NIafP7VLI9p4xK7i7j/QN7dX/V6On
	 sS1ijjJGrNsqj8L1QiY4a3OWhsKxqzLeRcX96Ea8=
Date: Mon, 16 Mar 2026 15:32:07 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] locking: Add contended_release tracepoint
Message-ID: <abgid9TwAaPJVw1b@shell.ilvokhin.com>
References: <cb89caf58885858433711f0ed6238484f5f1a67f.1773164180.git.d@ilvokhin.com>
 <20260312113815.2107882-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312113815.2107882-1-usama.arif@linux.dev>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4655F18000F
X-Stat-Signature: da9ajyfnfr4nwumsit3sgya5dfxbocmz
X-Rspam-User: 
X-HE-Tag: 1773675131-898223
X-HE-Meta: U2FsdGVkX1/jpc3c2MQG/W/mYIOlQQkO5OSvoEWyWUKGVoLToyS7rFmyoA4noPgb2mWhUIhmoI1jHnSrJ89AkhEfHbGckbacJ6oC7XWHswqKd9fMwD1o/kbtHjzCmQQCJFM6GrAhGxYfQfVTB+/Zg9GxfntPLfQLdXuKEK+2o5WbB+iBArk8u+KqgkL4ZIePBQCUvEH5l5NQkD/7uQd0MZpCnMtjzCRdZqjydSsqeY9uMPe7nfCiT08TtJCeDfrKVL5EQgGC0P96MUxIMJhUcNEy4SsQuj8wucavYXVyPY35cf6KCaFQmhG8TcxEh1URkuExsPKmekLepYthFarPbReG8OFbvOAChf9D0wEdtiMOh8o8bB7/AvBiEGegnd/BAjVFxhIyGXKHcv+Vr40mRr5GQN9D/JeVQyMeLHxJwz8phN3rbU8jWqUh2rq6VSldwGB7KXXVo3GEmFwzhS2IenjNjRe/PL4jGWN2fxbfz0vcQTVawYhDHhXytHQy3OoEMEybJnpQPZe1fA/dukSnWElKyRhsjHPdjVv09aE73g7MFKTGJzUOUa7pv71wk1usrh29kRfntO1C8fhQgQS3is6Ee3y5cWOMUuLamASp4r4fe4kpVkxTqrlYRT4SAaTWeUHtA16o+ojcvlp6xvVOabtZmTE8jzQ+0/rh03pr5NUsEkEggJVULV0BzRDvR1z4oG+dN/UH+L1K/lu3IFvVbVSXKI9LaAoHJtRWcMWXQvLa+90WUYip95HdYRz2baBQGbgCS6ZS23g2EDevy+6r43qcbU0qSXUANOYlLO2XaWxeQSfwUYc1WgMZ6UwbOjYjORf/kGn8Rnk8YSCNzTHIVdZWoQykVFMQlLSa1T6ONdKRzWKbgRW5mCmHATn6xiSUeyCHQIEvICTMC8xuSZ5dm48dIi6HUZy0+/UoTGOhF++B1pCvQHpkkdmIWxVCQa9yplqKKl2amuRRDUT2vM1
 NsWNDWD+
 51FzVY5byoSMbA/34GGtp/dwNZ3zfDJHpoTWYA2SL2qej2flBxTefT+ioQkQNWRAAfc9zpuDb1Q4fpsQcoY3vZjD1h0yDnCSS4/V+YhEZaJZ3JH/+AEoHnzI7waUkn0up2ubhbk5U9DGFQ+hEo7j/uQoW1Fedd7OdnxhfSRMatJO9sPs3kVhYjabUbzOPCBJYsfijLtLR/5JQ3PYx0O1Xmn1qDavsL+UphzMjbLXzZGRJoMxvohPFL4YPtNgfnohNfxP7LEz2i5kVCv0oqC6pAhM/9yow31FvLrIZ4zKOThMoSPXrsCOCUIroxE2PQoAM6QrBu/EgGHpqGyHctnP50zEXvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 04:38:14AM -0700, Usama Arif wrote:
> On Tue, 10 Mar 2026 17:49:39 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
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
> > RT-specific rwbase locks. Each call site fires only when there are
> > blocked waiters being woken, except percpu_up_write() which always wakes
> > via __wake_up().
> > 
> > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > ---
> >  include/trace/events/lock.h   | 17 +++++++++++++++++
> >  kernel/locking/mutex.c        |  1 +
> >  kernel/locking/percpu-rwsem.c |  3 +++
> >  kernel/locking/rtmutex.c      |  1 +
> >  kernel/locking/rwbase_rt.c    |  8 +++++++-
> >  kernel/locking/rwsem.c        |  9 +++++++--
> >  kernel/locking/semaphore.c    |  4 +++-
> >  7 files changed, 39 insertions(+), 4 deletions(-)
> > 

[...]

> > diff --git a/kernel/locking/percpu-rwsem.c b/kernel/locking/percpu-rwsem.c
> > index f3ee7a0d6047..1eee51766aaf 100644
> > --- a/kernel/locking/percpu-rwsem.c
> > +++ b/kernel/locking/percpu-rwsem.c
> > @@ -263,6 +263,8 @@ void percpu_up_write(struct percpu_rw_semaphore *sem)
> >  {
> >  	rwsem_release(&sem->dep_map, _RET_IP_);
> >  
> > +	trace_contended_release(sem);
> > +
> 
> Hello!
> 
> I saw that you mentioned in the commmit message that you do this for only
> blocked waiters except for percpu_up_write(). We can use
> waitqueue_active(&sem->waiters) to check for this over here so that
> its consistent with every other call?

Thanks for the feedback, Usama.

I thought about it and even mentioned in the comment, but I forgot what
was the reason. Now, I think you are correct. I added wq_has_sleeper()
locally instead of waitqueue_active() locally, since we are not holding
the lock here and waitqueue_active() requires a barrier based on the
comment. It might be not very important here, but I'd rather make it
correct even for tracepoint.

Note that __percpu_up_read() doesn't need this guard. Maybe I was
thinking at __percpu_up_read() part before and just made it symmetric.

Anyway, thanks for suggestion.

> 
> 
> >  	/*
> >  	 * Signal the writer is done, no fast path yet.
> >  	 *
> > @@ -297,6 +299,7 @@ void __percpu_up_read(struct percpu_rw_semaphore *sem)
> >  	 * writer.
> >  	 */
> >  	smp_mb(); /* B matches C */
> > +	trace_contended_release(sem);
> 
> Should we do this after this_cpu_dec(*sem->read_count)?

Good point. I moved it after this_cpu_dec() so the tracepoint fires
after the lock is released but before rcuwait_wake_up(). I also went
through all other call sites and made the placement consistent where
possible: after release, before wake. It should be fixed in v3.


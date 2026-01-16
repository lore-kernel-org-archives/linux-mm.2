Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 170A8C982DB
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 16:41:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 791306B0092; Fri, 16 Jan 2026 11:41:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 765526B0093; Fri, 16 Jan 2026 11:41:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6714A6B0098; Fri, 16 Jan 2026 11:41:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 573466B0092
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:41:44 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 10E7F140191
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 16:41:44 +0000 (UTC)
X-FDA: 84338393328.15.913FE10
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3E4D1140011
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 16:41:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ljkU0wOj;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=vb3vzNeB;
	spf=pass (imf23.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768581702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VBUoLPWSKpuo6CuQ7wHh1j/tBavqQozUcWFWj2skMc4=;
	b=TKU1n5tO+xDMEkFFQAQewyF/26lwjMvik3TaIhk2NkjcXkC5WRbAZEFdyUMv2BmYnZvuiR
	PPODA8yDYMf19ld0Up0JrtV6udVJOBSFr+DfsHNzsCoRwtkQlLJDXG7d02BLG9doX7dRPz
	wHqoL3Vt3GBHH7MK3GDTqs9K++g6zto=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ljkU0wOj;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=vb3vzNeB;
	spf=pass (imf23.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768581702; a=rsa-sha256;
	cv=none;
	b=3v3VcUud2CdO8x6n8PEDXNoJEXduLVTcL0OjxBAN6j4OwLmxMUxcNWX4XicOfBzhJnqpEg
	tntTEf8z3dl5Ku1amQSTVj5YcIgHDx6U31UB3WIzXvX6/Kt9+GHP7lqTiwo0zfpVL+B+1H
	LLgGpQD0qXZ2uQ0gHWzWaxkxmnTvyVo=
Date: Fri, 16 Jan 2026 17:41:39 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1768581700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VBUoLPWSKpuo6CuQ7wHh1j/tBavqQozUcWFWj2skMc4=;
	b=ljkU0wOjmbbu5GdN+yCB8VOn1tVFTyrVsfDFIMwgb33xhlIGtrAsyj8g0auZ3q+LoaM4uL
	0C/Xm6SsCSRGHmedgnJzPcPWMuVQlJsOTm7syhXXp0ypY9dH6ORAh+pqzwQeWZdt8m0cbs
	4yxNneclfyIyuWWCPvszFVmcaENUkMFD+nEhAr9lhbe7VTlLNJ+9i0U4kAo9ZZ4wT7ca/w
	ZyB73DkJitApkow0nL4ODJUJcETrPV4iLXTzExafkOUIC28RUsJgYZQZnbGxxljscvpl84
	mZFS//ohc80U2Ji4TT1ABDqIdADQiLuSve3Xis8y1dr/8ruKtGn4covJmZa1eQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1768581700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VBUoLPWSKpuo6CuQ7wHh1j/tBavqQozUcWFWj2skMc4=;
	b=vb3vzNeB7UJoIXhaDc97Gvm0agwiYu0/lVifQ07a84Kj9AcG9tGBrGCwRN29Plw4/ZnUDr
	Wnzhe/NmnNWTvjDw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev, Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	Waiman Long <longman@redhat.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RESEND 1/3] locking: add rwsem_is_write_locked(), update
 non-lockdep asserts
Message-ID: <20260116164139.8Sm2sJxG@linutronix.de>
References: <cover.1768569863.git.lorenzo.stoakes@oracle.com>
 <8e343ccb9319433364f5949a69519f1bb521fc8a.1768569863.git.lorenzo.stoakes@oracle.com>
 <20260116151215.GH831050@noisy.programming.kicks-ass.net>
 <99818e30-9f88-4751-af82-0bed019156eb@lucifer.local>
 <20260116155743.AuMKcTAO@linutronix.de>
 <5ca7b2a2-1e9d-4d90-8459-1aa35b30b49c@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5ca7b2a2-1e9d-4d90-8459-1aa35b30b49c@lucifer.local>
X-Stat-Signature: 6rd8bsjmpbwoh9fk38puintqsmx1adtn
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E4D1140011
X-Rspamd-Server: rspam08
X-HE-Tag: 1768581702-687512
X-HE-Meta: U2FsdGVkX1+nCbiP721upGoBzOZwj16/90wUVTtgr8RNvJ40oWqr7dmp0ZIkyYoBbmNGmu/VonlG92jsbJnX3mhuCJiBXqU1OgAQ8DiXm5gpcvfTxF/xavsttqFAT6u75K4K9jeRxtU/mfPPuEup80pxlz0sdQ5NMGVxkDJ7w9iIYTW+tf/793M+xwHqkrOi8i32JvZgEIVqCRKh1gULubAr+YqvMzic3ryQTFCj0Ss3BLo1qSUgVEryPRu0mbLb81AvdIN9P4o4JF0Ip/DK6j+1I40+BIgbyP4zeu/ToelMLCrQIQS/Gm3HlDaDFoeHpxnprYqCZksjC46LtH4LB2CKY28NH1OOQgGfMAbb5uzMJQ7X3x4I37+fIjieggL3/oFsN+YB2L87X1C7KnsFi/DVLsuFKQL1WsEHVpTJHdqVQXEiPQWJk1b35IORaMsv9ONBPRKz+zEYQszCeWoh085Jij9MrckK/cmLw5HwuZynCL33FU+9o7XNLAoErh+Dd6oUtmy8uuQ7uaXi74pq4XMxFTNNXXSI99LAwY9QSvLhEVCvFTjkACPqxqS9f8RXSkrxX4EXqX+AvSWMYo2d1jiR5udhUkPd0VbJQcB4noy+O3M6UqUWWgs/mI37DZyI9ZHqK7gmiuu8lH1+FEgXdVCiTi/J1ol81V0YU+NBSsF+lrUi65fiEyrM47p8bQOregnTWfmxmidu/qmFUJZFHfg6B+GuKU39rkFCXbG27EeujPWtjWHMf8Ot38HDmMI9q9zdsXjzP6MzsDkXx8llN2QbTpiCk7xnX7fw4tr36mMyam6hQlCg7Qjfi0IFj1cvUPToU2GKuulTq1fm0N/O8kUAO5bpVH0tFwznR+YWG2v9OV4t01dc2L0M9+G9uHKbFZB9DtZnR2r58KUVgpwI2zBG87IbefH5HoLYWIXqwUlqHhGY0apc9pvr98eARHQh6FxJjjg1lANnbP/Al+p
 ThdqGsmd
 EJRdNODy/T+3ifId0sU8fK3eN4FaF1vCxw34pUqhJZrq4XCZvW1+zqv5lLezcgh4hvXqMiZZ3ppA88hR1B+zHWyaqvHk0jHOFO84lm3cGjG/uuFzpFF1FKJw0GvdjJ5NM60165p1kCoM0hE6dPwtfgqw/DHKzpi8akqFwxJsFXZRWaOifMOjeBas7xbehEKWy4PsRRgTGR2GbapJpwd1PphPCjQh/7qTomcRDX1pxRg1YCgDwgmFVFukrwpjVtybhvtjB+CENEgG8asy/p1C5rpYu4PmKy7F56z7MIMxry+AG1zM1FIlzq3f1cA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-16 16:21:29 [+0000], Lorenzo Stoakes wrote:
> On Fri, Jan 16, 2026 at 04:57:43PM +0100, Sebastian Andrzej Siewior wrote:
> > On 2026-01-16 15:50:24 [+0000], Lorenzo Stoakes wrote:
> > > No, but we need to be able to assert that one of two locks are held and we
> > > don't want the failure of one being held to cause an assert when the other
> > > isn't.
> >
> > But why don't you use the lockdep based check? That assert only ensures
> 
> Not sure what you mean, the checks I'm adding don't exist yet.

The checks you add are not lockdep.

> > that it is locked at the time you did the check. This does not mean you
> > are owner - it could be owned by another task which is unrelated to your
> > cause.
> 
> Yup I'm aware that lockdep tests more than a simple assert.
> 
> I wasn't aware this was possible with the lockdep primitives, mea culpa.
> 
> Also this came out of a previous discussion where I added a similar
> predicate vma_is_detached() and Suren suggested similar for the locks.
> 
> Anyway, I went and looked and yes I see there's lockdep_is_held() for
> instance.
> 
> However, I'd STILL need to do what I'm doing here to account for
> CONFIG_DEBUG_VM && !CONFIG_LOCKDEP configurations right?

Without CONFIG_LOCKDEP the locking view is not really accurate. So maybe
it is not worth doing it. The complains are that lockdep is too slow but
the other checks are just "is it locked by someone? - fine". 

> So I'll respin later with if (IS_ENABLED(CONFIG_LOCKDEP)) ...
> And sprinkle with some lockdep_is_held() and see how that works.
> 
> I mean rwsem_is_locked() is already specified, so naming is going to be a
> thing now but I guess:
> 
> static inline bool rwsem_is_locked_nolockdep(const struct rw_semaphore *sem)
> {
> 	return rw_base_is_locked(&sem->rwbase);
> }
> 
> static inline bool rwsem_is_locked(const struct rw_semaphore *sem)
> {
> 	if (IS_ENABLED(CONFIG_LOCKDEP))
> 		return lockdep_is_held(sem);
> 
> 	return rwsem_is_locked_nolockdep(sem);
> }
> 
> And obviously equivalent for the write case is what's necessary now right?

I would drop the rwsem_is_locked.* and just go with
lockdep_assert_held()/ lockdep_assert_held_write(). Unless you want that
verification in production because it is important and false positives
(as in held by other thread and not caller) are zero.

> Or am I misunderstanding you?

Sebastian


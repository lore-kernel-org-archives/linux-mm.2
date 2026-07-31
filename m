Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54297C55176
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 18:19:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62CE86B00A1; Fri, 31 Jul 2026 14:19:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DDCF6B00A2; Fri, 31 Jul 2026 14:19:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F4816B00A5; Fri, 31 Jul 2026 14:19:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BA416B00A1
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:19:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B9054804B0
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 18:19:05 +0000 (UTC)
X-FDA: 85049883450.05.BE0F139
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 17D9C4000A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 18:19:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J0b7YZk7;
	spf=pass (imf12.hostedemail.com: domain of "SRS0=Tn6V=FZ=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=Tn6V=FZ=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785521944;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nSWPqMz7Q6UQotLRcbGZUaRbsx3pPGFQF/kK6NROqrA=;
	b=pueaGhB7E57vIBU9QNaPCwyL1t0zdsxkL5vRQRvzUIaJt63opFCI50+3BbdfpRrerOK4hJ
	xQwgn1OfORS515EREAG3qK26ArrEdr+/WyYU2SpzNd4jV4ogtrSW3I7BNUD5bLM7GAS6AX
	/lyil2xoMRp1l3j0f2jc+z0ip22+/Dw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785521944;
	b=S66rkdLmAexP0ETS0a5/Jse3aQo7uPIskJz7Yzk+VtLeKUvGGkc9+tfO4DZMWusbu5JTvs
	20Erdp+StTcOI3f8Y7+yoxe9+vnDp2ZhRWlsKrpz0+JCXo/ZJNklDonXB+9CSfJxHyY+mw
	SVYvWVYOm01LUaxxnhCryljGQTaZsr0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J0b7YZk7;
	spf=pass (imf12.hostedemail.com: domain of "SRS0=Tn6V=FZ=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=Tn6V=FZ=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 83B5760A5D;
	Fri, 31 Jul 2026 18:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353101F00AC4;
	Fri, 31 Jul 2026 18:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785521943;
	bh=nSWPqMz7Q6UQotLRcbGZUaRbsx3pPGFQF/kK6NROqrA=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=J0b7YZk7aQZOrwvpJjnA8XFX5gO2kMBIu+uo7OflScYO/Ba8XfcsEAp1dXrZVYXLr
	 lOG7b3fk0d5WW2lmxsSS+d2CTBzpG5TYqXdnxUBy6MPBuz8lSJE31nfZIB2rbKRWJF
	 TqSinhyHjnMd8O7Uh9+CRQ/+A0pGGcPItg895F8TiG3I3qPuyCMRr28Kr/byrTypGS
	 e91TCJzVOCmpZjG01MvicwJQ38eTgg/a2ubLgUKeGw526Hig21KjDBkke28+J+hchJ
	 3AIF3z4FafdEvrnUVlQLQNXxkmKx1F9O7cxa8ASSngumXrVim+vw2B8lxH4DBVIuil
	 pPth+Z83pNiKA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id D7D73CE11BE; Fri, 31 Jul 2026 11:19:02 -0700 (PDT)
Date: Fri, 31 Jul 2026 11:19:02 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: rostedt@goodmis.org, pjaroszynski@nvidia.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>, puranjay@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org, kernel-team@meta.com, dcostantino@meta.com
Subject: Re: [PATCH] mm/kmemleak: report RCU-tasks quiescent states during
 the scan
Message-ID: <23a60deb-c73a-47da-bd5b-4bf3c1c1bc8a@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260720153917.2e428e489cd0873ac6d4e6da@linux-foundation.org>
 <5b83b0a0-708a-458a-bdbd-41c6d4610349@paulmck-laptop>
 <amCT9QEgJRsLIb_y@gmail.com>
 <ffa5d8d2-1157-4a30-995c-ddae3566e3a4@paulmck-laptop>
 <amM1xUOhcpGpqIpe@gmail.com>
 <39c90e82-f785-4b47-9571-dd4b1339d685@paulmck-laptop>
 <amdWVTs0WKOxguxP@gmail.com>
 <amtZNwxZ3gpOsPER@gmail.com>
 <743bf971-b4aa-416b-b72b-88b538be727a@paulmck-laptop>
 <amzjjjZrseO-jMJL@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amzjjjZrseO-jMJL@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 17D9C4000A
X-Stat-Signature: iq3fkrq7gawobejdcupsxyh4z58d7jb9
X-Rspam-User: 
X-HE-Tag: 1785521943-196956
X-HE-Meta: U2FsdGVkX18GaTsZBj7XNBwpL0vDNaNHGRQySk+PrXcNFnBbNBYrli6QoatYsASRwO1y9AjipAXDy6uqF9pKCJ9fYaL8AKpfxJFBsscz1PEHqKZFVXJ/N75aLL5IK9wbkqMdghXGAh7S6Ap6kIBGZryJc2NFSHnPKolacjwQEhh6FyV7CV1jl1ex1Y8B3gceYGc1iw720v1F7XA0j33usYcVRJxO92l6ui8eiNs+GQF2LZYDgzy1zj567MkCAkf/ImXA3oIPnpHL+9U0kKkklyhO/iZZg7vow6XmJATNkaSaXlM78ZRW8qaEOMA4mLsMbLYvaqQIFZftfC/h1UlSt27dM60NdbZQks4mVZ5/7l4G2tbhfVUO0o9Gqtn1m39yDg5kB3i2u5RasDQKqHlG5SCCaVBTxoQvgFzBAGdDQFwKuaK4DIM5chpw98A3eVipgkUgKUPzg0uOyr4qxe+u3X12TXVmy63ax6Uay5jwHsQ8c6yT00HWhlyvXCnr4BhFBhbTI3aCoYy2XRrFo0R2T1ZnY6MKcQx7XjYR4RS4xM8U+20DBbTrfdMeFPj1z5KeDYbrlybaPkKY5If0+IQKlz061aOCTNEQ3icSV7a8r2gwmyizQhWsygheOrQQzZJgEfDd99YXN5vl9BSnXnuu5/UyEDu9KACb3F2dWwvlZe4/XKiFD5bBiHGZq9qQ8zQuLegnjrPOOiotgoFbGrH6eOpMq6puus3+7LRKuVKuSyOib/QGXOOT5k7VsqlqOjcWJ/Bs4rk73zei2OsAiRYlZORzcp7nB4SkOqObCgFtNt1pyrDssLNkxnMSY6ktWKAGvXJMfZhyuFKEzDaVho83+e7vIEVjt6nO51K0+rIjVqMjhzaiXFdfNJsvejkjNi8Nb5no2dDr4EnDS5HE0DnUQJai4mCz3vepcBrafIahGLwnrYxpy1K1p/7TX3LzmmGU7QFt/0fg7kc10MKlwq6
 aP88CIv0
 cXc9suzCdy04Ba10kwrmlzWg183cmPsyxLPdmKYAc3RDHdC/sRqT8g7d+H76SHgn3h0J2YB9pDqSfVwj5hOaFL03pMj9ls0+Fmpqcgd3b2Hdo018etOyUnP4tuJ4kxXqNoxKqfNp66H25bTA+rYkBjssT+pBBExBu+nnaYBjk+W0RFy4aGG4q7bdtse9xrHyuCSYpKZGfVR8ed+/ZBJ+/YOo9rsowKi5IjbLXmvk1wY4+lRRZXYkBFJ3ruZyWFc22OmpmBJdRysuP9bpeSEdVFVmj3Z5NMQXOtM3KvE0XpAUfnTVAGAKCmn+XJI8yawQzqlbtQy+wfMN6gPfUMbvWiI6dfJxykR1/u+ejsqQV/vvVpAUHp1nSJlPpVjO/AbdFeCVpDb8X6IpFLoMsdECEVMcjeT7rSbnHKgO5eWGgFQ5wsQnjmidB2YONY7m1rSBZaeumcLprVYxgYtUQUqAF/jAoVI0gB6cWo109mojnpCWkNNdZaySOpe2ya6G+qUbGNHEgjWAIqyIzXCxp6Qq5KDKb4/C/oh/lbm9aB1DuM0HQ48fdf3kOKmLpUd8/AR5T7r9FnssnHeIqU6Dq6iJ6UMW3PahRBj4dleXZRlrlVAC3fBxiKToWxRFwx9M2KZw8OaOOfHJd/s6DMflPIDhEJrli4OFkY2myT6a5PYjaxqlU3MGN2cqVxvHP8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 11:07:44AM -0700, Breno Leitao wrote:
> On Thu, Jul 30, 2026 at 07:57:22AM -0700, Paul E. McKenney wrote:
> > > I suppose we want two things:
> > > 
> > > 1) change cond_resched() with cond_resched_tasks_rcu_qs()
> > > 2) Avoiding holding the ftrace lock while calling
> > >    synchronize_rcu_tasks()? It can take up to 10 minutes on a healthy
> > >    system to be releasd, right?
> > 
> > I do very much like both of those options.  ;-)
> > 
> > If #2 is impossible, would it make sense to have a mutex_lock_idle() or
> > similar in order to sanctify the lock synchronize_rcu_tasks() latencies?
> 
> How would mutex_lock_idle() differ from a regular mutex_lock() when
> sanctifying synchronize_rcu_tasks() latencies?

It would sleep at TASK_IDLE instead of TASK_UNINTERRUPTIBLE, as shown
below.  This would cause it to be ignored for hung-task purposes.

For a similar example, RCU uses swait_event_idle_exclusive() instead
of swait_event_exclusive() to avoid its grace-period kthread getting a
hung-task warning when the system doesn't need a grace period for more
than two minutes.

Yes, I did learn about this the hard way.  Why do you ask?  ;-)

The downside is that if some bug somewhere else under one of these mutexes
caused a too-long sleep, that too-long sleep would be silently ignored.
As always, choose wisely!

							Thanx, Paul

------------------------------------------------------------------------

static noinline void __sched
__mutex_lock_slowpath_idle(struct mutex *lock)
	__acquires(lock)
{
	__mutex_lock(lock, TASK_IDLE, 0, NULL, _RET_IP_);
	__acquire(lock);
}


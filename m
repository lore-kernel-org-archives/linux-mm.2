Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EACF7EC1429
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:55:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E92B6B00E3; Tue,  3 Mar 2026 05:55:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C13D6B00E4; Tue,  3 Mar 2026 05:55:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295CB6B00E5; Tue,  3 Mar 2026 05:55:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 118286B00E3
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:55:36 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D29C28AC4F
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:55:35 +0000 (UTC)
X-FDA: 84504445830.15.59C61B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 43D3540005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:55:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CTywvoTU;
	spf=pass (imf12.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772535334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nulqQXVbm/tta0xYlvsLJ/zpT+F0prfhS1wwLafHlrM=;
	b=MdwKFgWm0ewISkIoNpXcHTmaGq6gyyFS52mRRVxhweugWXk8bLL5YjVQgVgfd96IzDFjRR
	LFga2TOgPoHUBqEaGKYt0bS5FIeaUsiQ6YX299We27cmgQqt9yqv0l6/fK2Pn/wsottV0T
	ihv00ApbC9oB04Kerp65+SwHfLjWGRM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772535334; a=rsa-sha256;
	cv=none;
	b=uV37MPlZi3waUkXXRb8tQ0lvTF9iGPoj3Ui+qAx40Ic/oHEnLiIle+w8eHfxAKKMYXa6rW
	3ecMZYU849F5qqOyM8QmOcwz9IsetRQdUmujm0N/+JE1FIXN/3DoxkMjI6/EhmEvhix15P
	lziFCvD1nUcBDM24IHVHrLhUXyv19hU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CTywvoTU;
	spf=pass (imf12.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A42B660123;
	Tue,  3 Mar 2026 10:55:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4113C116C6;
	Tue,  3 Mar 2026 10:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772535333;
	bh=U1ApVomksiqWCT2sGpijV9kFi6nnWZi4UHDKMufxrYI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CTywvoTU6cn+uM30VZVVIsd89qPxICra9DYBbl9Ildtr1jSFikkTARJliSVvZKVf6
	 zfAYc86OX6AyqBRnBO/XTTZjxQg853ye6++NvPL6ZFDirfLACYqxSGq8WTMdrk4sRM
	 t6l7JGjTdTdGfk/sHQqVnnnXq2rf3hf4/Fzr1USPi0kYn2uXb+ew9t1vdJ/LsTW9QN
	 yK+XPHM+HclEwMgLLIvVQfPmP66LqKYDONlupzJIrZbS1fbTWUcRE8KF7RnXFdK84U
	 arBwHJkqPOnTL21B+1onE17zYIxUNVdVmARnknVyxN2XXyzf2xYhngXWXFWWBWVcW2
	 WoMrAD6LtymPQ==
Date: Tue, 3 Mar 2026 11:55:30 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	Leonardo Bras <leobras.c@gmail.com>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Message-ID: <aaa-Ig5gKeU1PV4D@pavilion.home>
References: <20260206143430.021026873@redhat.com>
 <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash>
 <aZL45yORfkNvS9Rs@tiehlicka>
 <aZcr255pGT3B/eaL@tpad>
 <aZdk19MqYhWK90Do@tiehlicka>
 <aZhv+Bw7nKKmbFdq@tpad>
 <aZwbcKeO-59l0UOC@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aZwbcKeO-59l0UOC@tiehlicka>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 43D3540005
X-Stat-Signature: ihwz9cdxxpyr379i9w8886m6eo6cidyu
X-HE-Tag: 1772535334-976543
X-HE-Meta: U2FsdGVkX18TtwFhPtVJO4Zt787Sdg2YJG6Mri+wd9aaZd4OelJ7veOgt/+LJzeUycyYxbO3+FQUAol9hVp2ynRpUzcgxxUWCF+qKQcI1Var0D3PjwMvrGVtNW+foNf+83WaeLQrg4qfgeZvstYpDOHXOxcHexwhnQZ7KwgnrgQQLG6jG1q9pJRoi+6aKsF5h9gcgZ4/KDTeE5+O4k3Kxwx3bUNqfJezLV7tg3DFYkY4Q8qFgZegUZuysFvGFbD1ydFNMI/UyOxvLN0eA4agw04aTFjVxI+q3d2PjV7LqtOR0Of6xUOOLMfTHHY6lrhgR9A+RCoe+bqztXbJAQmYNI0vq21bXd0JK6HZ//q3QvGMkaPR1Fzw4/PwJGCdUZy44IILlhZ8fvZCWcTIPFkJzFdWFrdYUkCxhDoi4qH1Zypi4pm5o+K1W0FZUNW7gyQntymrXqYKkvHLq3trjxfXa8+BAGadhQxRMkpacacadVZZdOqHmqRo9UrTeuLXmK7BHoiCpQuWi2+RbGcN7WMFx43eth/xVp1ywANbHGnII1+V4tMOruzjceZdCWdVLcHgJYAtaYM3SNy6LI57do3Gc90WEpVzuM5N4QoWlqREWP1qRHZMc9b+Q9ubiWddWEYZfTfuAUhBJFXBUVa10P9I9DKBIVfSljOOrSiMSQQULOlATcSaeXpVZblbwlYK8BsPYdqBkwrGSdW4DGH2k/6T77MkFfC7/+sjUcFr6s33Sk4Y4i84cblnyBkP+Gi6bhJc3lvJ7lhO2SaEuJ4nLg5LDY3VeWwycOS3h5U8eE2pLr46zKqgm79ySvmFayKzD2Um4V7zzN0dXRJXI4caEZGwRe3frOmgHkrVnTm3JxVc7YV84pwm0EJ16BqeFUyAFjZpS2Jwm363vtn9NoYKR1RE2+GfKDMYcGjZ2jnRqYKVNfNJ2liyjikuqB0CST3JIMmereIZJUMYxu20HZdWunu
 EBSDUt+n
 MbvE6KDWRuh7MiHvHj+5X6tnizEfVi2Ik0u2iUYUpFn2qVC7riJTwuY70QSIuweLIsjUS9v6ajehU9FwlEa2zB1oQI18Amaobon1r1sr+3mZqwnPUTyUYEXuLTR/iHcIp6ElJkgK49MMAdZ3Mdl73cPUnbI8sJ4cGEvP/0+JW3n9zqsqNaV/nrpu7lrHMqQjVWGO28E/3x/FHkK+tRzteE/KSoPA4uzlRx0QIXi2Au6nDjrWJHnCw9yQ+nNXxN0bs8owP08dyLfgGMmnmca/UeW+V1r+sLptRiPTZ6Rr4BnzmYeIlHRfjRUBJFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Mon, Feb 23, 2026 at 10:18:40AM +0100, Michal Hocko a écrit :
> On Fri 20-02-26 11:30:16, Marcelo Tosatti wrote:
> > On Thu, Feb 19, 2026 at 08:30:31PM +0100, Michal Hocko wrote:
> > > On Thu 19-02-26 12:27:23, Marcelo Tosatti wrote:
> [...]
> > > and delayed pcp work that migh disturb such workload
> > > after it has returned to the userspace. Right?
> > > That is usually hauskeeping work that for, performance reasons, doesn't
> > > happen in hot paths while the workload was executing in the kernel
> > > space.
> > > 
> > > There are more ways to deal with that. You can either change the hot
> > > path to not require deferred operation (tricky withtout introducing
> > > regressions for most workloads) or you can define a more suitable place
> > > to perform the housekeeping while still running in the kernel. 
> > > 
> > > Your QWP work relies on local_lock -> spin_lock transition and
> > > performing the pcp work remotely so you do not need to disturb that
> > > remote cpu. Correct?
> > > 
> > > Alternative approach is to define a moment when the housekeeping
> > > operation is performed on that local cpu while still running in the
> > > kernel space - e.g. when returning to the userspace. Delayed work is
> > > then not necessary and userspace is not disrupted after returning to the
> > > userspace.
> > > 
> > > Do I make more sense or does the above sound like a complete gibberish?
> > 
> > OK, sure, but can't see how you can do that with per-CPU caches for
> > kmalloc, for example.
> 
> As we have discussed in other subthread. By flushing those pcp caches on
> the return to userspace. Those flushes are not needed immediately. They
> just need to happen to allow operations listed by Vlastimil to finish.
> Or to avoid the problem by not using them but that is a separate
> discussion.
> 
> I believe we can establish that any pcp delayed operation implemented
> through WQs can be flushed on the way to the userspace, right? The
> performance might be suboptimal but correctness will be preserved.
> So doing this on isolated CPUs could be an alternative to making changes
> to the pcp WQ handling.
> 
> I haven't checked the WQ code deeply but I believe it should be feasible
> to flush all pcp WQs with pending work on the isolated cpu when the
> isolated workload returns to the userspace. This way we wouldn't need to
> special case each and every one of them.

If you look at flush_scheduled_work(), there is a big compile time warning
to prevent from using it because it's too deadlock prone.

But even if we flushed only some specific relevant workqueues, I'm not sure
that would help. The problem is not so much about locally queued workqueue
handling. On a preempt kernel, that would most likely issue a context switch
right away to handle the work. The problem is more about remote queuing while
the CPU is in critical code in userspace.

Also such a flush or local queue would involve multitasking and tick restart.
We could handle that with forcing to be stopped on userspace entry but that
doesn't simplify the picture.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs


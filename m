Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16763EB1076
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 21:34:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEC9F6B008C; Tue, 10 Mar 2026 17:34:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9AA26B0092; Tue, 10 Mar 2026 17:34:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9CA86B0095; Tue, 10 Mar 2026 17:34:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CAE526B008C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:34:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B4CB1B7873
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 21:34:27 +0000 (UTC)
X-FDA: 84531457374.15.6095226
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id F208CA0014
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 21:34:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XqGOoHJ0;
	spf=pass (imf25.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773178466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kN4LxTQv0yEvEUYVTk4wDtrXEmPb+E5bctm5CirlZuU=;
	b=ydGjCQFVyuorGZhKXhoos55bwzBGTOZA9urXXhpjYZENKxIQ9zntG0xVfyNXxkJgyp3p04
	u6wZ/wH5hMj4GNH02fdqWrFuEBLdF7CMuj8ZOMelnfYx7GvBuc1p3nBKElH5NVSHv9B6+T
	+o5RxQwS9fCkU/fAwB6MCfYNDkcq1eM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XqGOoHJ0;
	spf=pass (imf25.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773178466; a=rsa-sha256;
	cv=none;
	b=sx7dMuNVtivwAiBgO2vijVLJehYL5gAE+f7Ec3V9Vn8ucw9mSOKsSoVQDNrVZKimyBdlf+
	r8M/p9TfHQjB3eX9Y8xZKtUrQpK3qx8GQW8TllbkewRFOsCoDaXtGmaSv89dsroD0xJ5xp
	HG0nPSjWm2k4VZaAzvOyCWMxK3Y4HTk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4965D6012A;
	Tue, 10 Mar 2026 21:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1859C19423;
	Tue, 10 Mar 2026 21:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773178465;
	bh=anu5ccVYq0VybeUWOWkYcT+XFVzew7g77Ym8dOjH0AE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XqGOoHJ0fvSL0gcNZ2Mxqk/lyN0hXZ6pJ5ewKL7Esv/H3WIzCPXa8WFvP9FE2mT7w
	 uu39pd6fmw5uNktb/vrLS1971pwCqjGXhGaA11BLUk6zM6fbypj0ZR7Owo4Oq7Mnj8
	 LbvZqmUX/v1dmjhGMzmzkS69287Y+RAWbpAFg9RZgDbTTpjkNct6i5o82Ks+XRpU+F
	 i0z0owJw+UyzHgiFtz6t4lkCKPqbFBcNyuLH9zkxAXVCOViFU5F0D2XoNBeU81TlAo
	 vC7IqLop2H4OPVSQFMUxFzT2r/hERvL5lxQ2SNDeRkV6iseD0XeZSPizEZ3cjO8Di9
	 JLW75b+6yCOtA==
Date: Tue, 10 Mar 2026 22:34:22 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras.c@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feun <boqun.feng@gmail.com>
Subject: Re: [PATCH v2 0/5] Introduce QPW for per-cpu operations (v2)
Message-ID: <abCOXjSPbxNxa0f6@pavilion.home>
References: <20260302154945.143996316@redhat.com>
 <aam1cHq3_fb-T1HH@localhost.localdomain>
 <aaoyFClXLEYNzzBR@tpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aaoyFClXLEYNzzBR@tpad>
X-Rspamd-Queue-Id: F208CA0014
X-Stat-Signature: spemcdn5xto1ur46tghpd17r8koh9ayh
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773178465-728395
X-HE-Meta: U2FsdGVkX1/q8vLHP3+tS5zXFWmYAsEGH8ZNFxautUNDWkvOQN+C1UllsEQFkrFbEUVLAVVv7iferASRQqjBLD2CprAvARvd+vn67xQgcLE2MSV4FKwVtiDLW+bfOA5lq81Nq7y5DmD8pdH1IVtqfiuKBQPE2Uu6mOat/Ikoar9qrN4Kta2N743VSYAzU+iJB8iqZoYw7bHAGgDQA2A7IEU7OAC0ak/UB3jH5RpjU6tHsWRFLttn6drkUrO400brIly3pPvfzwQsmMxinRqDa89YcmSdRgStGaQ55KUSKInnvyz2J5e60i0QzQ28inaf99LnVe3YXWKrUJGPGRBV365l1EVDcaz9S+Vf5FQmQWA1QB5qaLpA0rF3LlSHpj/Be+tjhPLSbzUvdEExT3IgwhblYKATmpgU4nXPrUV/FAHi+MvgoQ21uHrEaoieBrvLvrWyZFvMyLznmC4Pyu5K1V43jR3r00UFFGvvM3aw/RwSHgGEziCs43wfRS2bhhRLoZQLUKMA4sI210Y4z2ttzEX/rLAxnG+gVUu4ufUAmjEhD/dHOu3r2iVdZtK78uTK+6DLGZBSSJwv7sxdjT887jXRLdAWWJru1Y7Aevc04bpuXopzfOHCVV5u3Au5AGYdRMIKHpqJxNdgNVTdQsMbyQLINrIg6r/UeDNJ5jz0YQB2sTOn0/ncZJYsRNg5vKy8Ey5b69MlX8mE7B0mq9zrHWgZJo/sVdhL4hWVm8zxhPUnSziVhj/U2jA+y8OKpqyeQs3a/7Km3mdAr7fwHWOBlTD0IdDiGa3ZJyWsEuunzHAbr4j1yEMas9QhsnEyNmjEVo/M+bEqxilIuQRt19LUGjxCJo73NPVlSM4MwfBjHf6d0CDEvb42+n47QAjbCXAbRYV9Xyrd7Fsd7Xq8PbnEe36+JZcVhtXJFngXrvuCgboLWGXhcipo9rV/ByxjMLdq0VTKpuOL5S8lvNaGUDO
 pTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Thu, Mar 05, 2026 at 10:47:00PM -0300, Marcelo Tosatti a écrit :
> On Thu, Mar 05, 2026 at 05:55:12PM +0100, Frederic Weisbecker wrote:
> > So let me summarize what are the possible design solutions, on top of our discussions,
> > so we can compare:
> 
> I find this summary difficult to comprehend. The way i see it is:
> 
> A certain class of data structures can be manipulated only by each individual CPU (the
> per-CPU caches), since they lack proper locks for such data to be
> manipulated by remote CPUs.
> 
> There are certain operations which require such data to be manipulated,
> therefore work is queued to execute on the owner CPUs.

Right.

 
> > 
> > 1) Never queue remotely but always queue locally and execute on userspace
> 
> When you say "queue locally", do you mean to queue the data structure 
> manipulation to happen on return to userspace of the owner CPU ?

Yes.

> 
> What if it does not return to userspace ? (or takes a long time to return 
> to userspace?).

Indeed it's a bet that syscalls eventually return "soon enough" for correctness
to be maintained and that the CPU is not stuck on some kthread. But on isolation
workloads, those assumptions are usually true.

> 
> >    return via task work.
> > 
> >    Pros:
> >          - Simple and easy to maintain.
> > 
> >    Cons:
> >          - Need a case by case handling.
> > 
> > 	 - Might be suitable for full userspace applications but not for
> >            some HPC usecases. In the best world MPI is fully implemented in
> >            userspace but that doesn't appear to be the case.
> > 
> > 2) Queue locally the workqueue right away or do it remotely (if it's
> >    really necessary) if the isolated CPU is in userspace, otherwise queue
> >    it for execution on return to kernel. The work will be handled by preemption
> >    to a worker or by a workqueue flush on return to userspace.
> > 
> >    Pros:
> >         - The local queue handling is simple.
> > 
> >    Cons:
> >         - The remote queue must synchronize with return to userspace and
> > 	  eventually postpone to return to kernel if the target is in userspace.
> > 	  Also it may need to differentiate IRQs and syscalls.
> > 
> >         - Therefore still involve some case by case handling eventually.
> >    
> >         - Flushing the global workqueues to avoid deadlocks is unadvised as shown
> >           in the comment above flush_scheduled_work(). It even triggers a
> >           warning. Significant efforts have been put to convert all the existing
> > 	  users. It's not impossible to sell in our case because we shouldn't
> > 	  hold a lock upon return to userspace. But that will restore a new
> > 	  dangerous API.
> > 
> >         - Queueing the workqueue / flushing involves a context switch which
> >           induce more noise (eg: tick restart)
> > 	  
> >         - As above, probably not suitable for HPC.
> > 
> > 3) QPW: Handle the work remotely
> > 
> >    Pros:
> >         - Works on all cases, without any surprise.
> > 
> >    Cons:
> >         - Introduce new locking scheme to maintain and debug.
> > 
> >         - Needs case by case handling.
> > 
> > Thoughts?
> > 
> > -- 
> > Frederic Weisbecker
> > SUSE Labs
> 
> Its hard for me to parse your concise summary (perhaps it could be more
> verbose).
> 
> Anyway, one thought is to use some sort of SRCU type protection on the 
> per-CPU caches.
> But that adds cost as well (compared to non-SRCU), which then seems to
> have cost similar to adding per-CPU spinlocks.

Well, there is SRCU-fast now. Though do we care about housekeeping performance
to be optimized on isolated workloads to the point we complicate things with a
weaker and and trickier synchronization mechanism? Probably not. If we choose to
pick up your solution, I'm fine with spinlocks.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs


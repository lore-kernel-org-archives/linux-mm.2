Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4018BC61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 20:51:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E32376B0088; Tue, 25 Aug 2026 16:51:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE29C6B008A; Tue, 25 Aug 2026 16:51:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD14D6B008C; Tue, 25 Aug 2026 16:51:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 97BEC6B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:51:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EDA86A0144
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 20:51:17 +0000 (UTC)
X-FDA: 85140986994.29.4979372
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3B5D2C000E
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 20:51:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="URS/D749";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of "SRS0=fj1m=GS=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=fj1m=GS=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787691076;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i6BE0nH5fKyGi4DIZ+qOoMqZyC6oX0Uqj521Z9Rq1wI=;
	b=KoNLfR7O0tcjSFVBxBrM9pNeePumu0yp3rzAR/QCuhc3Y9WZgVsOGw+r/7F99UfKqCUMke
	T1BZd0ZKoBmITfd80q6aBdTOw5ABK904CxkVpPVj4SFhVwYtmGRmrTDdCn7lIj7pkZeybM
	NcbVYPccolQb1isDLSin3SIKS6/HU1o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="URS/D749";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of "SRS0=fj1m=GS=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=fj1m=GS=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787691076;
	b=yw2Rxo7wAshimOHRRtp49mayNgpf3bIEdUB5Lzh5A6HMP+GqyAZTrZX4fKLk+X24nLwrxW
	1LRRO9W4lwblq64qFwzRIJmlByl36JIUJM1IdkBM+TyM4aLW14BdqNRvhi9MBp1IxV9E0t
	QFEjJkpeUL3fIyd32shPoAANBB2srpM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 629E560053;
	Tue, 25 Aug 2026 20:51:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F661F000E9;
	Tue, 25 Aug 2026 20:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787691075;
	bh=i6BE0nH5fKyGi4DIZ+qOoMqZyC6oX0Uqj521Z9Rq1wI=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=URS/D749ZpGm5+vV0slOT5ZirKgXoYaeoaJBkyKND2mNiINk9MzqmrtQrnzu0q0qJ
	 jz5mny2czckBcRW/92+lp3pXWYi2zVAkC3M3sJW+I5mE5/SoKvAzLuqO46loVuqhIk
	 fEU72r5t+R9iFblU7J4y9KTT2YPIRa/Cpq/A2ePCRGaqw59SDj6tpnjQUTVcBp2AVX
	 4m47/8WW3ibuZem4FHWW8PmvLPznqy1NA0/rgYlkutlJzPdSEXw/LsYeUrsAjUAjrE
	 vGkWAoplG2/n3eeEI1ylgeR/poOvq5A99VIQQpusmzUIJYBPjqd+ri6HpMGcl/qiux
	 BHcwxygcx+7KA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id C275BCE1DA2; Tue, 25 Aug 2026 13:51:14 -0700 (PDT)
Date: Tue, 25 Aug 2026 13:51:14 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Michal Hocko <mhocko@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Jerome Glisse <jglisse@redhat.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
Message-ID: <d4f8ff92-08ac-4253-b647-f9e95c66698d@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <333c4cdb-8f34-4e3f-a47f-961f47e089a0@paulmck-laptop>
 <11dcf5a87125451897982f728c1f65a5151987e4.camel@infradead.org>
 <69567965-48fd-48c5-abb6-0699d7f5bd16@paulmck-laptop>
 <124af87fb49c267eeb26b8b4d952b9b1a5b3fb68.camel@infradead.org>
 <9427a8e0-3ba6-4f31-a35d-54429bd7e071@paulmck-laptop>
 <3d0463b6099d4fcde9a025a2f9e231d75303b61c.camel@infradead.org>
 <b0be19e9-b0ae-48de-bef6-d905ee007c8a@paulmck-laptop>
 <ao3z7Rtw2FROkVpy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ao3z7Rtw2FROkVpy@google.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 5cmr4e99c8piscqy5k5ukn1n9ogqr9ok
X-Rspamd-Queue-Id: 3B5D2C000E
X-HE-Tag: 1787691076-437727
X-HE-Meta: U2FsdGVkX1/jsoh8XkEwP5KQbBXwrzgk+Us+bq6ETFj/sYApVUOGifiSY/lLD434p6gm3uefhZ7uhOy7EjiJ3SHgbm3jcWaWoxlxGlvyC1k6s+50i0rjARAZfX808+ZL8jrTcT2itmgL7ZmIkmJolhmVozLpcWJ0V+TsONluCxQbJcRHfX5UjbOlnanzmZPOReWj7qFRMNsSKeX5g5tCGLZ2omgzsu6mJ9pRAe3bRHZSaNU4e0nM6XThuyQj4gMXItJ8/n6qtg2+kjwbGawMCA7wiJHr1Fqb95c9ocLYQFXeOAPoHs5j9qhgQ1zvZAxNTMjokKJ4o0ANT51Chroid47k6bxo69ClnEtxDOtvttxJm4piOg4YxMBpE00Ni6MuPoKLFMWs6rX+N4LbSZ7IOHaFyGG8gRdWLTp0p0Zp3noCfrO7LFLxoi4/ycy950SJwzC1NGnYnGeL8hkXcFyKIUuSKA8BvfbHaZKqPyHuCqGeM9/OywdDzdPoYg4rarXz/PcSjQZgOAkl8pBItBMRyb4wVdYH8MGz2RGakAYcaOW/Y465xrIZpexw25CFfmpqlm8tEfQ2e7U+BfkWqbAu7vW5dDGlUSGYA4omM/tWH8ZHzrzYpKxvEioHGPrm2tz/aIenobxIaCV/+M9xm/oO9tLju/mHh4B2p6wka9vkrrP8woe7/Y/8ek3Zz2i54vmBbI+T+z2+7JN3ctlQAqrvTJEi3hXHZY1mZ//9z1Oup7OPvbDE6MjiWCvomrpbWjDrgKRtOh9Z4Gg3YWCZ0X7g71lZvCaIuGrarX796JzPBjbxv+uj5omz4ILfrHT57XoTXDABFKjJUWgnM9Roqh8Vv5qheg43LmCPVnk5n4oxrtyZ1DXqP4eoBolWscPn7otlXx0Fn8FGIQKDck4xx4poNb/9GjBJByTz+O3pID65CBHZl8aaLQE3ViWI1mcxgxLdLxy7w/oqKtKzatjJl+h
 uGkMtOnW
 4hLzyS34DmOXUd6+U9siQih0tWb3nOfsn/z7kqAbt81OhRcTlThwbJxoyLZawwBPU2J5QGR5gCymfFiKOvj5AaO8SCeUZkdvSRcCeSRwNRlyiURHuNrFy5AwJ1/bhPIMGBFw23vCy5MN+6F3QcANzmjQREYJROPCrx/0503hXWidsXzkpLs76q9htmuhXU0KtlbnN+A7s8lF4xunULXVbaM7pFgQ0ojkx1UrWeiKY7aTJ6A1KbEwcJQArRM5MIZ6Uf/Yl+XgqWbgh3MnALiRVLut7u8G8f6bPfc9v5UvyU/LqYmdlkogFW6uOtH2D1SuV9cKtDTQ/wYauyIT9fVRGWWjfJa+UwjwXCBaRB+5UzHO3+SIihI5sfgUw0kmQtdxHmJ+NOK3+RQjtlgyj+1t6nzAaT22fd+6w6CKEFVezMRrlOHRBVb71augf4lBmnV6xAtr+Olaf1pyjvfUuDRxoRMe3LEdKwWcFjMqYT2IcD5JVb8iCBH7/7/7YCQZeEHkaqpcGvcE2tqpB0bAvteR7PkaIw2Mhk9o838cnGaxfL7iL710NzfA15MifPXiu3sGRMRrBYUfdUI7OfrSvqZgfHekWqSQzly0typxRV4jlOnJejVskbZkc4zpqhF8LM7Igq3hG3Hpi72mo/0joGJTsswJuRfsaDJlA1sdyBTvuLb+z5m5Y0gVAJks7wamia3Amjr1CglhHUx8ItnXOuUM13xnQd1Lzwdgf9khVpQKTefqQMD0Cp6GZB8dBwj0r6jt2AyJFmrhrXT9zPm8Z4GBLhXCcdAofewmbqGf+zy7AOpUzZq55aCFsqFz3PizATSm3frAb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 12:58:37PM -0700, Sean Christopherson wrote:
> On Tue, Aug 25, 2026, Paul E. McKenney wrote:
> > On Tue, Aug 25, 2026 at 06:48:08PM +0100, David Woodhouse wrote:
> > > On Tue, 2026-08-25 at 10:19 -0700, Paul E. McKenney wrote:
> > > > On Tue, Aug 25, 2026 at 06:05:54PM +0100, David Woodhouse wrote:
> > > > > On Tue, 2026-08-25 at 09:47 -0700, Paul E. McKenney wrote:
> > > > > > 
> > > > > > On the tail latencies...
> > > > > > 
> > > > > > The easiest way to reduce them is to require that preemption be disabled
> > > > > > across srcu_read_lock_atomic()/srcu_read_unlock_atomic() regions and
> > > > > > across all calls to synchronize_srcu_atomic().  Without that, the problem
> > > > > > is that the scheduler does not know that the spinning is pointless,
> > > > > > and we cannot use the blocking primitives that we could otherwise use
> > > > > > to tell it what is going on.
> > > > > > 
> > > > > > So, is it feasible to simply require preemption be disabled as called
> > > > > > out above?
> > > > > 
> > > > > I'd experimented with disabling it around the GP driver loop in
> > > > > synchronize_srcu_atomic() as seen in
> > > > > https://git.infradead.org/?p=users/dwmw2/linux.git;a=commitdiff;h=07165e79340e
> > > > > and that didn't seem to change anything (which seems reasonable, as
> > > > > it's the *waiters* that were descheduled, not the threads driving the
> > > > > actual GP). So your suggestion that we do it around the whole function
> > > > > certainly makes sense too. I'll test it.
> > > > > 
> > > > > I do wonder if we're really doing the right thing here by selfishly
> > > > > blocking preemption because we want a specific tail latency to remain
> > > > > low in a contended system. Maybe we should allow preemption and trust
> > > > > that the right thing will happen?
> 
> In my experience, preempting MMU operations, especially mmu_notifier invalidations,
> is rarely a good idea.  E.g. see commit d02c357e5bfa ("KVM: x86/mmu: Retry fault
> before acquiring mmu_lock if mapping is changing"), which worked around an issue
> where KVM would drop mmu_lock and yield in an mmu_notifier callback on preemptible
> kernels.  We "fixed" the issue by avoiding mmu_lock contention, because it was the
> easiest fix and benefited all setups, but the underlying problem that made us take
> action was very specifically yielding mmu_lock on preemptible kernels.
> 
> This isn't exactly the same, but it sounds quite similar: being greedy and hogging
> the CPU to complete an operation can actually be beneficial for overall throughput,
> not just for the immediate operation's latency, by avoiding trash and overhead that
> is incurred as a result of yielding or being preempted.

Very good, preemption disabling it is!  It is quite possible that the
PREEMPT_RT guys will need something else, but one thing at a time.

> > > > > Maybe the p100 isn't the right benchmark to be chasing... I'm looking
> > > > > at it because Sean expressed concerns about it, but it's not the only
> > > > > consideration.
> > > > 
> > > > My concern is algorithmic, not benchmark optimization.
> > > > 
> > > > Suppose that there is only one CPU, or, alternatively, that one of the
> > > > atomic SRCU readers is pinned to the same CPU occupied by the (higher
> > > > priority) task running synchronize_srcu_atomic().  In this case, the
> > > > call to synchronize_srcu_atomic() uselessly burns CPU time until its
> > > > priority decays, real-time throttling kicks in, or in some configurations,
> > > > maybe never.
> > > 
> > > I certainly have no problem with a blanket preempt_disable() around
> > > both sides for algorithmic reasons. As long as we aren't *just* doing
> > > it for the selfish reasons I described. 
> > 
> > Suppose I simply disable preemption in srcu_read_lock_atomic(),
> > enable it in srcu_read_unlock_atomic(), and disable it internally to
> > synchronize_srcu_atomic()?  It might be against all RCU tradition,
> > but might also be easier to use.  ;-)
> > 
> > > > Requiring preemption be disabled across both the atomic SRCU readers
> > > > and the synchronize_srcu_atomic() avoids this, at least when running on
> > > > bare metal.  My (perhaps naive) hope is that guest OSes get some use
> > > > out of those cpu_relax() calls.
> > > 
> > > Yeah, an overcommited guest vCPU should be able to get preempted there
> > > by the hypervisor, allowing other vCPUs to run.
> > 
> > Whew!!!  ;-)
> 
> Ya, and on KVM x86 at least, cpu_relax() => PAUSE will conditionally trigger a
> VM-Exit after enough spins that causes KVM-the-host to try to yield the vCPU to
> another vCPU in the same VM.  The intended use case is to detect when a vCPU is
> spinning waiting for a lock, to try and give cycles to the vCPU that is holding
> said lock.  IIUC, the same principle should apply here.

Again, whew!!!  ;-)

							Thanx, Paul


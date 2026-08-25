Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E317DC61DBC
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 17:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D91186B0095; Tue, 25 Aug 2026 13:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D42F76B0096; Tue, 25 Aug 2026 13:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C57C46B0098; Tue, 25 Aug 2026 13:19:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A09326B0095
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:19:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 44F7E1C00A8
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:19:27 +0000 (UTC)
X-FDA: 85140453174.10.90CBD36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 65D7020005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:19:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YDDYGtp0;
	spf=pass (imf03.hostedemail.com: domain of "SRS0=fj1m=GS=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=fj1m=GS=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787678365;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N+z+EWfwawr13AA/05vPGZDapLHVer9oJUDN4V4rsvc=;
	b=ciTQyU9iIOZvxyd/KVz9s84ONYgq/7TvDPjdWhrN0MwSXzDLKdzZAcLAIrY2P6G6N80Wt/
	YEZxGFWZ7u0hqk3MM80qbIVMu8M0LRm7D3oV1nRWKQAearoKaZpPOed5mqIXytigB/T/Rk
	WCnIjexXEmpvd1neXioY7J6301KoCRk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787678365;
	b=Lg8BmstLIck18wzfwnhWdFVktZJIcsM+2Lyfmpf6WR6jJpRUjjvh0ZduWPiH5UFDWiEyJl
	JNqdbKfALVij5IzJB0T4XzPd9/I2VQcRAb+cFkR9MEXT0+c8YbIlgHHKTxByG6gwqqDyY6
	NFQI5yXLRWkb1XFl7W/xBLU4Skb0FzE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YDDYGtp0;
	spf=pass (imf03.hostedemail.com: domain of "SRS0=fj1m=GS=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=fj1m=GS=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8104E409B9;
	Tue, 25 Aug 2026 17:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6380E1F000E9;
	Tue, 25 Aug 2026 17:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787678364;
	bh=N+z+EWfwawr13AA/05vPGZDapLHVer9oJUDN4V4rsvc=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=YDDYGtp07+d2njAvClMBj9eUXdhAJfOASpMOQdvz2AI7peJccpWljTKoDa+NMAnlf
	 ugIt4e4STr6xZMh9SV+b1bqcGzUZV1X3kT2lg/rFRnPTyRkW2gMViFeu7HPVeN3SVT
	 s5YpOpQBJQTDRSIF2J6R4a1bGI7QdKpz4K8S9+HwLD4SJ31y1vQAk8u4QHrA3uYZl/
	 Hd8HtWbZSiCK6Cl/qpnmaZ5Ls3z8oGCeC7x2cWsTLUurqrHXH4b4JxMq6d725X0miu
	 ooekQNlwnEVBBGhMnHhtegiomTApUtyyiaKRXLHCXLTSqMbcmPpiL3aIaLnxZWBiU4
	 VeXhxQusnn0nQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 272C5CE098D; Tue, 25 Aug 2026 10:19:24 -0700 (PDT)
Date: Tue, 25 Aug 2026 10:19:24 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
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
Message-ID: <9427a8e0-3ba6-4f31-a35d-54429bd7e071@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <333c4cdb-8f34-4e3f-a47f-961f47e089a0@paulmck-laptop>
 <11dcf5a87125451897982f728c1f65a5151987e4.camel@infradead.org>
 <69567965-48fd-48c5-abb6-0699d7f5bd16@paulmck-laptop>
 <124af87fb49c267eeb26b8b4d952b9b1a5b3fb68.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <124af87fb49c267eeb26b8b4d952b9b1a5b3fb68.camel@infradead.org>
X-Stat-Signature: fnmtbcj1nybi5ahmsrqs1rdasa64awn5
X-Rspamd-Queue-Id: 65D7020005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787678365-605182
X-HE-Meta: U2FsdGVkX18PIZpLs/2Z3orKyVYwnwapp1lr+SEw7gxdPGLAhgSUyzAf8St/rd/bkgTFvU/2CQjqSE0b5EYruUsccU1gYRZoVcqX1K8UsorZArI9PLF90f7uqwACNhSzX28L2mQbUMT0Y5jSC85B/QyGZSK8nhiGpJPk5tJs2IbMAKQtTlZ4JKWL0uZT9HENPbH8i/Q8soa2qM6TTiLUA8Tn+FusiPmS4et9FRXINEVbdvs+ZxwjLfecho83izVjvFGOyRrvt316KGyfNLlAJlwAi1DDjKN18a9zX5VPXcH9rgT+iiUdKXFgb/WVHK/9cg5JJQ0YtRMBQsG+3Ese9bAiWu21L9XCMj29xxdal0aDyzhG3Lqk9c+ZwlUY0doNP5KvUtEWs5lJWDCyMvoYTE5VfqMSa8DUU5GdNErgnMCWcUi7VKCjH+eAaMx40r1hV36m685E1eJHhiOO9A9Lf7j4UqOpYmLdxrLnqvy7JeBbbFTgAdaS2UU+zX+2oSW5S+JM6j+aJyg4Tg7IeB9SBYB2vkPKSSHpIahG9l9ofCd+xbnLqbv5aExBJJhQNwYH0eN8hDUPSFZwa6OfEKHL2BKZfuvcNSEKS67lJaujbyzcVdOkpGDtu4DA4LgHgMcJEFjudAAZaSkc8DXSiveMC85qA4v7uIbdCW4XDsYSiz8x8zbE1AbXnZSN38s7/aRYz1iSF985mWo7KxKvUtGWxCwSjpt20SXHeqNPSEETplLglPU6eU+LuHR2ICpuJ6AcfRT/GZXc72Q9H9gmeLGMDKtO6MGQ/VfLq07VDb24dtb5xkznAmA9e3SQxQ5a9281A+IIV1LGWcodu0lB1n4iBIteFxscyq8giOlF7b0oj9TpGOQO+Gr7eLigCfmd9fhvCzoiMiir2xObuZorSnmT19ENvjZ/Exui11UtK9aI635urATO6gQ///YSwNtZrtm9nZRcXGM2sUTPmH1pwO/
 0ckY24ov
 e7XX6/6mBnrQelTCWhnUrZqpAWtjt/CSkxVpLPeWzL2ZOrden7VusVjWGSJ7i0q2dCr3L6w3xIqBu5HS4aQQDh8NYTdGe/MtxRfR9vWJiqGf2SAimQinK4f4aa2f9jd4iFH2LskKE7gqJWX5gVTf90EzjLFNokOXCKd/mp0IMV35rjVSCZJhBojiVemMt1hEl2e//6nCoUGqF49f+3hU9gGQqadfQi+ytLOmX9vmgAXmCzc/AS25mRxzDzvq8BXT1R0pKovWB0sENhzkjeu3FcC9P6zUzVQbtQGrxI7xZO+yGYefsTArg29ymOdA1tZheiaOdFhuEWKJ7lKLj6y3Gf8/bCOC2Q875ADw+2llElOgj05xnXqDG8OeeFq23or8c1YdQrwCH1xgePdHAmXAdFILzfa755TgCbHnJlvMOnSO2NrjKViF/x+Ffsz2Pmqu2lXkOnDctlvMeozrkEz+R+0JGbzVASL7ZqpSPAEp4/XnUk/pyjLkr0NpYn/AT4d2i0fvHbDPL0frvn2tHvrDo/ju+QQo0OKWjdQJzqoiCrXdA8xnALBe9+rNoGKtf4/UjO54bkzubZdPrCth30heIz4jsDFeZvR5cpVbDcehnBt1DLRIxWcUkP4pl5llvP4gIYeEuGPFoSO40n2tuJccXfdcYL4TwjWsiwWWWruvwtViVETqwU2p0Zpq9zBwf6eOC0h7WKBGIRho4Jg4FK4d+tLfih1funGo9r1zSt2QnUxikd2xjTRXFzUW61m+5ATGPmVmOPV51cBsx2ytEmp+xa2TQncC8ZSBsh54iIPM1dlpEdMsSZwKLr1boTV7pvhTS3A+7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 06:05:54PM +0100, David Woodhouse wrote:
> On Tue, 2026-08-25 at 09:47 -0700, Paul E. McKenney wrote:
> > 
> > On the tail latencies...
> > 
> > The easiest way to reduce them is to require that preemption be disabled
> > across srcu_read_lock_atomic()/srcu_read_unlock_atomic() regions and
> > across all calls to synchronize_srcu_atomic().  Without that, the problem
> > is that the scheduler does not know that the spinning is pointless,
> > and we cannot use the blocking primitives that we could otherwise use
> > to tell it what is going on.
> > 
> > So, is it feasible to simply require preemption be disabled as called
> > out above?
> 
> I'd experimented with disabling it around the GP driver loop in
> synchronize_srcu_atomic() as seen in
> https://git.infradead.org/?p=users/dwmw2/linux.git;a=commitdiff;h=07165e79340e
> and that didn't seem to change anything (which seems reasonable, as
> it's the *waiters* that were descheduled, not the threads driving the
> actual GP). So your suggestion that we do it around the whole function
> certainly makes sense too. I'll test it.
> 
> I do wonder if we're really doing the right thing here by selfishly
> blocking preemption because we want a specific tail latency to remain
> low in a contended system. Maybe we should allow preemption and trust
> that the right thing will happen? Maybe the p100 isn't the right
> benchmark to be chasing... I'm looking at it because Sean expressed
> concerns about it, but it's not the only consideration.

My concern is algorithmic, not benchmark optimization.

Suppose that there is only one CPU, or, alternatively, that one of the
atomic SRCU readers is pinned to the same CPU occupied by the (higher
priority) task running synchronize_srcu_atomic().  In this case, the
call to synchronize_srcu_atomic() uselessly burns CPU time until its
priority decays, real-time throttling kicks in, or in some configurations,
maybe never.

Requiring preemption be disabled across both the atomic SRCU readers
and the synchronize_srcu_atomic() avoids this, at least when running on
bare metal.  My (perhaps naive) hope is that guest OSes get some use
out of those cpu_relax() calls.

> I'll have another look, but right now I'm in the middle of rebasing
> onto kvm/next and the whole nested story has fallen apart and I don't
> know (yet) what broke... :)

No hurry.  I am allowing preemption (but dangerously as noted above)
for the moment, and can easily add lockdep checks if and when.

Plus I need to turn my rcutorture changes from shameless hacks into
something maintainable.  And find and fix the inevitable remaining bugs.

							Thanx, Paul


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65A2EC61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 18:17:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D9196B0088; Tue, 25 Aug 2026 14:16:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AF656B008A; Tue, 25 Aug 2026 14:16:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C57F6B008C; Tue, 25 Aug 2026 14:16:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E48CA6B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:16:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E191DC016E
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:16:57 +0000 (UTC)
X-FDA: 85140598074.15.3FF4284
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 281EE1C0005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:16:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IAf83z3g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of "SRS0=fj1m=GS=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=fj1m=GS=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787681816;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DzVEjVkRW6HxHuHwKFpTtnTA+OQV/p8rhJpcnutWj+A=;
	b=QsBrDy1ikuiNz6V8OMVuWmK9CCPn4lX4Sib8t8X47uVye0FENcQ/TBn+3SZLwTdjiXMGgv
	MP0hbPulSkuaIUxNtlpxUf6PzJGkIJjeXtDp+5mKoBtuqNIDdBDNO9qEHAq6jYJS6ieDPk
	5gqeAgOQUqXOaRxbyravn1NJ4O4X8+o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IAf83z3g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of "SRS0=fj1m=GS=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=fj1m=GS=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787681816;
	b=Rlgh/9UP0xmZ4pPY5nsoPb9NqFBEE4ggh0HIBads2rngxzJbc+HFMhpPqIat2VNbi+jzPE
	HezXMYsHI7EVxcuB4bFafu81QlfFWBEz97z8yL+EaGzYR+pd4T4vofamCCxgJ/yLQzwbys
	XhAkox/m13bG8EOOL4GeKW4i8/QmoXc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3919B6011F;
	Tue, 25 Aug 2026 18:16:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC4B1F00A3D;
	Tue, 25 Aug 2026 18:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787681814;
	bh=DzVEjVkRW6HxHuHwKFpTtnTA+OQV/p8rhJpcnutWj+A=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=IAf83z3giM+IdSU1Wx7HPfLxMgJ1LuLBEYyP1tz0NRK0xkqPtMZfhzBeIJbewdCr4
	 EvaB18dUYG6KIagSmlgJkM5HsyvuZUWiBi0kiLXp4XcB3WYQv+io6Amn5wlp9wm44U
	 40VlLgFO0y0TTuvhlPZsjX9Wyv+1BP5i+5+D28x+BNrMT7Ey+SD6c81cvID0Nmwp52
	 ZHeU9vcQ81wMIc3M7aPp+OVOdB/O3tI64i4Mu8xXgG/Iadtcb/X/v/C0d9hGGduQDn
	 X2MqaclqUquFCmBk9Sz/TNudKA0RJcO8ARwIEl1Rd6wHltYQAC5JO/X992KSgdWPnp
	 NKPcnzRi46p5w==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 98437CE098D; Tue, 25 Aug 2026 11:16:54 -0700 (PDT)
Date: Tue, 25 Aug 2026 11:16:54 -0700
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
Message-ID: <b0be19e9-b0ae-48de-bef6-d905ee007c8a@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <333c4cdb-8f34-4e3f-a47f-961f47e089a0@paulmck-laptop>
 <11dcf5a87125451897982f728c1f65a5151987e4.camel@infradead.org>
 <69567965-48fd-48c5-abb6-0699d7f5bd16@paulmck-laptop>
 <124af87fb49c267eeb26b8b4d952b9b1a5b3fb68.camel@infradead.org>
 <9427a8e0-3ba6-4f31-a35d-54429bd7e071@paulmck-laptop>
 <3d0463b6099d4fcde9a025a2f9e231d75303b61c.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3d0463b6099d4fcde9a025a2f9e231d75303b61c.camel@infradead.org>
X-Stat-Signature: tphazsuw9ss7pchs63eyf9o3j5578693
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 281EE1C0005
X-Rspam-User: 
X-HE-Tag: 1787681816-776748
X-HE-Meta: U2FsdGVkX19DAIUWtkmtGK/fN8tGNsFUAY/Ko71s7ttk5OfkJYk60S8sux8QUGxFFPBX4+4rCyP/lTHg6NqGXwiugi4BzdvkcTvoonmz6A6WiBFL/fV1b+eRfyDAXa5mdO5FdZ42xdFUOKoWT661WwsaNlIgZDc6Vz3iHL/Qa8g/KzllupYZzgyLNm91H+g8jhRmIAqyWTFNPGQhpeR8pUiLuukoGSbAxduA0ODlDsDMk5IF6ifzjc1u0yr4qS7qijxWYTSHONPg51+NrDsKgYk6RYfv5EQJbuNVOoUcN+1e54pLNbJbkRw7lCA69Dw00WRH0nYPMttfAmkxh171lJP8meA/R1vLMA/3QlxsbVjVXxH56/CYRIgCqnOfa5CHF4ZtaVr+8V6Ax3LNiaOUv0A2FjOC9FnOaRkLsRxDS3dCAe1ucDcD2YVEPde+4AjcQmJSFV3xPfSgoxkGqlcHSv508bqQ4KS6fL9UltuSog3N0zaqlnXaxb1tnI8AySaG/IoV4QPfceOOrRTo41AHVtkgcr7rpDQkc0m0aGFHTW5WjtIZpmpWyN4OuY7fWidW1nJyPshVqwhl0b4jCBQMD1TA7+6YSA6R727g+lOL4XAViWEypbrzCki6YuUbR2pCb3rPPvgcUHsrBLtSpQFDWcb9hhxarvsRu40pQXFM4eQiCY7L26t++vn/iunQwGEYBVfsIIxwTy2Mw2GmNv0PbIBLNKP8JyoxeOApr52g9IAyislmGcfE9spAeiyGXcP2E+vtYmQyTZfWPtAUSt1FD3DfH4+9Z624VzVW/cy/PKRBHr+zTyUe7qCgr/ohu6BWh3baH1SS9LuzJvqfbycUuJICVlOactbS1MOE1p76rhSXlkC+nzipy0uJAY2bMYVxRGAR/5522KjZc14KPJ2nRU3XnqtBMz45IPVNOXQJQr4VjI4I5278LHZBKLaI2VVnV0hnlHcyUBGilTaLTDE
 pQ34oE9+
 ZOsgsR4pf1YZNf0zay+BkTVhIvXwUIGSyuZSQ156zd50c0IDF6m+6ARPsXVufn/z0DAgmuwOnpqkTYcO5Goh0zCICwaR8qxRUj3eDigX4MVdxO+LoxbkjOdOhJVeMvK7NHdETIqcMEg/vy3CLlyQy1xbcBgtwevVm0IPGZWC5It5Kc0uEW4h5F8UdxZiKmFw79gZPGYxwRzKiaUQh9pDvEPPU3cV7zKGulsSuhZ/FwfO2nX0SYCVo+PCHJ2D5sIwzHg1+eecWW48Mr8kp4h3a8KHhqOQhe4bKqUTVInfDO9qNNDL1r8KqJAuwPr+pdbIwI1/03I0j2++wACzmkmTzj5NEUSwea7yHMCvPuSeiP6znKu4TvXUF3VoFHIPkdLFbB5BTqZZuhzWOCeAsf8+QcfOGpyLfTvOFQyxd/YRthyIRX+v5oDIkL+nf2qdPmSD5kHQ+6ouFvkS74DoS19chmLXNqc+AIchxXFbpt7GDuooLhakoh/XSm79+44H2ftp8FcduufZT7v060q4Fwkdtbr+/LduAaCnoUjjyQ9N6bT6lmUHYT47LYq/LkBVRAzW/Fnwr9PvGRNdGbial1C7hFp4tcNDHqZwRApv4f0B+LMMInHf3rqx8r1J0YyJoWEmY4utVzvwFTaTCj0jfitvmZueZHI9fTpmSJn/paa8eH6/zDD/KwAnKPa9dd5LgMKcoJRP3LRpGFp06OTYo3swll+LTPGfgCyDXPqGc601YjEELHBmg8LS20MbpRLTr6pfdNlRW3mM5GPvwnfdO7lHKvtmXs0IgDlb/kPHcC6C2+D0t4Hpl0RPWQvYaKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 06:48:08PM +0100, David Woodhouse wrote:
> On Tue, 2026-08-25 at 10:19 -0700, Paul E. McKenney wrote:
> > On Tue, Aug 25, 2026 at 06:05:54PM +0100, David Woodhouse wrote:
> > > On Tue, 2026-08-25 at 09:47 -0700, Paul E. McKenney wrote:
> > > > 
> > > > On the tail latencies...
> > > > 
> > > > The easiest way to reduce them is to require that preemption be disabled
> > > > across srcu_read_lock_atomic()/srcu_read_unlock_atomic() regions and
> > > > across all calls to synchronize_srcu_atomic().  Without that, the problem
> > > > is that the scheduler does not know that the spinning is pointless,
> > > > and we cannot use the blocking primitives that we could otherwise use
> > > > to tell it what is going on.
> > > > 
> > > > So, is it feasible to simply require preemption be disabled as called
> > > > out above?
> > > 
> > > I'd experimented with disabling it around the GP driver loop in
> > > synchronize_srcu_atomic() as seen in
> > > https://git.infradead.org/?p=users/dwmw2/linux.git;a=commitdiff;h=07165e79340e
> > > and that didn't seem to change anything (which seems reasonable, as
> > > it's the *waiters* that were descheduled, not the threads driving the
> > > actual GP). So your suggestion that we do it around the whole function
> > > certainly makes sense too. I'll test it.
> > > 
> > > I do wonder if we're really doing the right thing here by selfishly
> > > blocking preemption because we want a specific tail latency to remain
> > > low in a contended system. Maybe we should allow preemption and trust
> > > that the right thing will happen? Maybe the p100 isn't the right
> > > benchmark to be chasing... I'm looking at it because Sean expressed
> > > concerns about it, but it's not the only consideration.
> > 
> > My concern is algorithmic, not benchmark optimization.
> > 
> > Suppose that there is only one CPU, or, alternatively, that one of the
> > atomic SRCU readers is pinned to the same CPU occupied by the (higher
> > priority) task running synchronize_srcu_atomic().  In this case, the
> > call to synchronize_srcu_atomic() uselessly burns CPU time until its
> > priority decays, real-time throttling kicks in, or in some configurations,
> > maybe never.
> 
> I certainly have no problem with a blanket preempt_disable() around
> both sides for algorithmic reasons. As long as we aren't *just* doing
> it for the selfish reasons I described. 

Suppose I simply disable preemption in srcu_read_lock_atomic(),
enable it in srcu_read_unlock_atomic(), and disable it internally to
synchronize_srcu_atomic()?  It might be against all RCU tradition,
but might also be easier to use.  ;-)

> > Requiring preemption be disabled across both the atomic SRCU readers
> > and the synchronize_srcu_atomic() avoids this, at least when running on
> > bare metal.  My (perhaps naive) hope is that guest OSes get some use
> > out of those cpu_relax() calls.
> 
> Yeah, an overcommited guest vCPU should be able to get preempted there
> by the hypervisor, allowing other vCPUs to run.

Whew!!!  ;-)

							Thanx, Paul


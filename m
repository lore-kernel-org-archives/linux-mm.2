Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2FDCC61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 16:28:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B41646B0088; Wed, 26 Aug 2026 12:28:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B19016B008A; Wed, 26 Aug 2026 12:28:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2DC86B008C; Wed, 26 Aug 2026 12:28:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 851626B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:28:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1690D1A015B
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:28:30 +0000 (UTC)
X-FDA: 85143953580.24.9E14DDD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5FF471A000D
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:28:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GKQYZxJK;
	spf=pass (imf19.hostedemail.com: domain of "SRS0=KFgM=GT=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=KFgM=GT=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787761708;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H+8RJcHYuvgzjE0Wp/aIuWWk301iPXwhRKQVqXWTdEk=;
	b=TPwD8lazszT1iYspPXvpLjURGfZQqE2yigTskPa8mEyI60kGkNb9U5m+EO+dOche7b4lva
	KrNONXS39uzsT405m8y1e1ES+gLEUAuvuK6rIikhPxWjjMVI0L83v95AmrJ+wliT+qzys8
	jrk6ZBkWsPoYbarkDep2/Wju4dIRD/g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787761708;
	b=QhsDbs0pE1yGGxTb2g65/C97esXMM3kuMW+3/Msu7RTSZ+1KrCRcdikcNVSd1BxTKtL8cT
	FHMvIRF9+vWs4/LIT2vf+iTuMMnl1vcvLdnWkE2tz06jNiqnWtDYsyLd8gDK21KWFH++1m
	m64GUMMwIjHub3sMS1jIm/NAbZeOaB8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GKQYZxJK;
	spf=pass (imf19.hostedemail.com: domain of "SRS0=KFgM=GT=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=KFgM=GT=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C356D6001D;
	Wed, 26 Aug 2026 16:28:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758081F000E9;
	Wed, 26 Aug 2026 16:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787761707;
	bh=H+8RJcHYuvgzjE0Wp/aIuWWk301iPXwhRKQVqXWTdEk=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=GKQYZxJKcQmnvwN68lqseYEgoh5n3xMKVr0SKHGlTy/Axf4GEb87KhMzLY2yTiYyD
	 kNGnShWdpnCJrR3n3EtyhantGf/89bsfc/kndaqZQOCjRCB0lt2cjbfDSUjE63/r7i
	 9FC7uzMO3wbOYQzVf2qI0SLLBypn+P5UiwdkmPhOBpEuHubCsa1raabO02RT2lur9l
	 gH3e/uKAqyrLP+R+aqSfo6/ZEl8E5RVCdE1pOXq1CphaYspJLne8c+/8iTvgYvkxM2
	 VL4deB4phqGtWvPokNdlv++5mXW1OFjCOh7HXxYWLul6N76NpEitBOsbZMxOlUTFku
	 ryILv6/aPMoiQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 332E5CE0505; Wed, 26 Aug 2026 09:28:27 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:28:27 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sean Christopherson <seanjc@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Michal Hocko <mhocko@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Jerome Glisse <jglisse@redhat.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
Message-ID: <98e123c9-3dc4-45fb-815b-881b3346741c@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <69567965-48fd-48c5-abb6-0699d7f5bd16@paulmck-laptop>
 <124af87fb49c267eeb26b8b4d952b9b1a5b3fb68.camel@infradead.org>
 <9427a8e0-3ba6-4f31-a35d-54429bd7e071@paulmck-laptop>
 <3d0463b6099d4fcde9a025a2f9e231d75303b61c.camel@infradead.org>
 <b0be19e9-b0ae-48de-bef6-d905ee007c8a@paulmck-laptop>
 <ao3z7Rtw2FROkVpy@google.com>
 <d4f8ff92-08ac-4253-b647-f9e95c66698d@paulmck-laptop>
 <20260826073233.T-KtFXmj@linutronix.de>
 <da5ee56b7d082abfbb20f71be99a6885247e9811.camel@infradead.org>
 <dbbd6634-4da9-4ecc-9fb2-d7430e2743ca@paulmck-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dbbd6634-4da9-4ecc-9fb2-d7430e2743ca@paulmck-laptop>
X-Stat-Signature: 5yjgmmohskgadkmius7rwcz7zs8j87jw
X-Rspamd-Queue-Id: 5FF471A000D
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787761708-610127
X-HE-Meta: U2FsdGVkX19R5SxyvxqGHUVrXux/ZXy7GxttsXVbWk4+KKFgbJUNLjFA/6JO6HGdFrK1EsEzDdsqjXZPaSoR0IQ38gYA5s+3T+ZjbrMu1Darp2WwAMQq3fBLoJLq0MwMdMibmhiIPdGmXzwDY9CaDSxqJ2ucbCf4Go9YroL1/DlDwh+C/BC/p1NPG3urWsWDMEJr86V21ESjfak92s1dFAFiPgA5uYAJfpx1KgPxjGmujaDW4+fGkJNxQ9uNBNYnZTnwGGMhhege+WQ3VveJsa3cIRd6jwEI0C4xq4nwbeomNBpaCfhpxjtSjAIWLAxRApazMqkIvKHispxvtkdyNxRb89YJuD+wjdXdseBjnldyXu/cVT9c39e5vgb7YLHXj+gTAs6jxrtbam2lIpX8aprdQ+7AAF39JqyrkR7qISLtYYnWugqqOa/ZDrvEJ9rQM8bC20i0NJ0OHcMg4yXix9lRUzZCGi/jHa7AZ2e5vqy1eUfd9HmhKV9iiszOcOyUgzRgSjTAYuOvy5XjbiQM4yf7qpRlgiOro+/45SLDqmbf8TCp5k9a7ifYR+0zN2IlK+hegJfK9B09MvR1CFZLHISdXQIeYVYkziIl7kHUXGoZ2KvV74HzBpZJa2Q/UAkSRmsiVytVaEL4sE6qoeMqz0hyO4eqhxNzwiVyCrTVrp4LLSzvgMOqw8lyxSn3WtoF1CrwemxAZlyh+Y1+dgl89yT/EFBEYRD0CY9DD5XVhyiZjIkZeihLT5MKicv7u5dIhIAysMelo/5huLfGL4G0HThK0zNwTVjXyi2/QTDl9oCSXRwbsq61mLq59IuMZ89W0KSRsG8NWDaewP3/9Hs8TZX2GNP5tohIQD0Nr7VQEwMD59YZnRlywx8gmbhbuSX5AkE6yBjNNYK0PmwYvXi3LQCRSy6X/W+HtXcbf3mJRqboUbBZ67fXQSCNH/YhPARdK8OnDy7zwEqr0QLr+2Q
 jGWv3G73
 jRBL1Gsj8bY3AkOr0+WWkk+vV1aS3IJADw3iKSNP2yiXkpsbw0PIzEw3gRjOfpNdEvkJxFQLYKPvPfpNSu1NbO2inHged1y6Fm3p0ZZYlRyP06k2d80jFiwHST7sFGi9cAmdP4uhz8+ibU7sNUc8KZEimGmbaBa323uppDcupxkvWb1H1kV94LvFRLEEK+x8BpScFVuXib+lj+vCJy87CCylz7P6Cv+LblyEcq1HXNC7xBPDLZeY6U0ou/LFx+A+8GN9B7qZ9RFAxQ75KkjvNMP9/KhRojrkXNnRfVkGaghuFRb0gGy4stI6ztojM6d2Sl0xdrrcKKPayIzz4ju4qI9/c8T5Ja81B4l7HOgWnilETtS75UIsITbWQDSntF4KppCQO8A4blvLucxZ9Rl0z0lGAqTrXk0Blw3vHxQu2qFbKFCurAUunZOR6Qcxlv6pzL4m5XsNpCWfzjQg4pLdZcoyktRF5u4cIy2oPsuTSxJ8NoYsaJYLWxPtDsIc2ZsP7LXL0QbIe7j37G99uXW0nfRtKmEbd8oY1DES9P94AxgfEGiGOO3hswxqEAf/yo279Af2++gLwJPR5/54KBm7ixXfUyKtl1vMQc7KE8u/L2xGfg1YOhjLoyHFyLxrRlX+yU5M1fNrC5Ry50ne4lklMkZ/aQgV9OVAsfO3XKtUPxMizgAqDvP3xt65gLT+8nps9deVsvLGbsqpY8Kp8YWEDcmUP/vSUHfWOduiZ3r2Oti9u7G6dfKAWwn/ZxayZmN8312Bi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 08:05:06AM -0700, Paul E. McKenney wrote:
> On Wed, Aug 26, 2026 at 08:38:27AM +0100, David Woodhouse wrote:
> > On Wed, 2026-08-26 at 09:32 +0200, Sebastian Andrzej Siewior wrote:
> > > On 2026-08-25 13:51:14 [-0700], Paul E. McKenney wrote:
> > > > Very good, preemption disabling it is!  It is quite possible that the
> > > > PREEMPT_RT guys will need something else, but one thing at a time.
> > > 
> > > This reminds me of classic RCU ;) It might work in this use case but I
> > > am afraid that other users might come along where it actually hurts.
> > > With PREEMPT LAZY the preemption within the read-section should
> > > hopefully be the exception.
> > 
> > Given the way that PREEMPT_RT treats other locks like spinlocks and
> > rwlocks — turning them into sleeping locks — I suspect it makes most
> > sense, and is consistent, to also turn rcu_read_lock_atomic() and
> > synchronize_rcu_atomic() into plain rcu_read_lock() and
> > try_synchronize_srcu()+synchronize_scru_expedited().
> 
> That makes a lot of sense to me.

Another option is to instead fall back to non-atomic SRCU.

> For that to work, we will need a wrapper sort of like what we have for
> synchronize_rcu_tasks_trace(), but one that does SRCU for !PREEMPT_RT
> and vanilla RCU for PREEMPT_RT.
> 
> Sebastian, thoughts?

Everyone, thoughts?  ;-)

							Thanx, Paul


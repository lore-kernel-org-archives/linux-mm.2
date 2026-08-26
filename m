Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9AF1C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 15:05:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 521D16B0088; Wed, 26 Aug 2026 11:05:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F9836B008A; Wed, 26 Aug 2026 11:05:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40F8C6B008C; Wed, 26 Aug 2026 11:05:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D1D36B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 11:05:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9219B40164
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 15:05:09 +0000 (UTC)
X-FDA: 85143743538.02.6C929BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id B36FC2000C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 15:05:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h8bDSvms;
	spf=pass (imf13.hostedemail.com: domain of "SRS0=KFgM=GT=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=KFgM=GT=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787756707;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P++naScNZowUvRJGvpwZuOXHFESG3Sw1NB7yivdb/jg=;
	b=nH8iEHEAYTl78LosEcHco2ypB45kYnBjvDtqVSwZqbUJ8MtgzCfUysjK9+kZqMk/LowyTL
	rSjt4FO7+W4Cc0ItHlDgnjDkbIeP5PsIR64uemPAxw2O5WowJtw30mZTNn3JnIWSDUaiHv
	4SxS9n20aYpWBhbWTqUyMy2WCkfBON4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h8bDSvms;
	spf=pass (imf13.hostedemail.com: domain of "SRS0=KFgM=GT=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=KFgM=GT=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787756707;
	b=kK0QiGErWSAzV774YgrQ73WHepb6bRDw9sJ3rUz1Ozt8+WG7h9yz2DzVjn7R+qkWRhTrMi
	aBALL5dYVFlkMadvsx4cm7tlz8Y+IbRJ1AQFPnH0atyvG5zBKcqFQjjODDcJtO8w0EXhFo
	RWOO6kcI55LEQe6rWXHcZi0sOxWn7Aw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CAEF2413C7;
	Wed, 26 Aug 2026 15:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A481F000E9;
	Wed, 26 Aug 2026 15:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787756706;
	bh=P++naScNZowUvRJGvpwZuOXHFESG3Sw1NB7yivdb/jg=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=h8bDSvmsmumTK1wPZfvvnD6Mh7l4lkruuUlW4NmjgzaGmgJ59OW6MHEVHxbpSn93i
	 nb7BjisVl9X6I5GXUN/85C7ho409ilqX7Mu8P+jxd6Id9mAkDC5Lb4q5ezn3SYXrAF
	 /yl7HMA7m8r2fWSi22hFgiLA3eKzuUoVYKfc85y4HWs2pU3FEfr4QHQp6uWKoDLNOZ
	 M7ICBWkKbd6Ypel4vrldLgXEuNM5iTJsfU8yg2YDh+RAVQDiRNAkhtEC8A2cwevHo6
	 ZorGmhZu4xIbuEvFYl0z7cSprK8zR9wsNpFjMwVVrzjoldxui6KlMckMwAQbuoO1x7
	 tAN2oODb3bjEg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 693BECE0484; Wed, 26 Aug 2026 08:05:06 -0700 (PDT)
Date: Wed, 26 Aug 2026 08:05:06 -0700
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
Message-ID: <dbbd6634-4da9-4ecc-9fb2-d7430e2743ca@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <11dcf5a87125451897982f728c1f65a5151987e4.camel@infradead.org>
 <69567965-48fd-48c5-abb6-0699d7f5bd16@paulmck-laptop>
 <124af87fb49c267eeb26b8b4d952b9b1a5b3fb68.camel@infradead.org>
 <9427a8e0-3ba6-4f31-a35d-54429bd7e071@paulmck-laptop>
 <3d0463b6099d4fcde9a025a2f9e231d75303b61c.camel@infradead.org>
 <b0be19e9-b0ae-48de-bef6-d905ee007c8a@paulmck-laptop>
 <ao3z7Rtw2FROkVpy@google.com>
 <d4f8ff92-08ac-4253-b647-f9e95c66698d@paulmck-laptop>
 <20260826073233.T-KtFXmj@linutronix.de>
 <da5ee56b7d082abfbb20f71be99a6885247e9811.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <da5ee56b7d082abfbb20f71be99a6885247e9811.camel@infradead.org>
X-Stat-Signature: ychr1imdxbg6ho8z4rip7kk53jj5r9yn
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B36FC2000C
X-Rspam-User: 
X-HE-Tag: 1787756707-730576
X-HE-Meta: U2FsdGVkX183/mEZSiJVNr2BW7lRAa7zTIv0xqg32gbflwvs1cgG01sP1HbcR/aGxBiQHX96BHVcbM1rACP4xaBt67inLB3VJv5qDv/R8zDyqZlmzohURzSJJdsEAk1exiaZj5YD1hpttxI0XEHUzeJBNQFuEaPocYF3fKw2zbQpCKpBfPK56gi71MGieEM+wrch2KJnvcURcgd4V5qoCcB4gfPRLZBQTgzos0RYg4eYA9bUG8hJwlhvn7HdNQTIysoyZauiNnVtX8AQfmMuT0drbmmHFESXf4ahlnN3cye1oFnPvDlUNlHuaVe/gCjsh4LQo1EO/uWaK3gmyF5pvcd9JC6K/YDe2R9xrLWt5h504LAFMCO93UxcFvbrwzOR/nyGdmH0pQVZ7N0ybIfM8nvRKi4SSSxZ/wp1mZOuR5Isi9gVAG6P7HAFEIlIhykGhW4B+irwFR5wIB1jsO1RbnsfAVP+v85WLEgRrY6/6zNjuN3GX+kZiVM+zNGaZJsL2Afo4UxY+wyBEbV1Z4OAJZlX6bqPDZBuMQik1PDqdahoEsGWGFi1RWqT4WDOaeGwCm2I9A2DMmvj+7s9Irs3UF2SYh3euWu+AzFFt2Eooa3K9C2HGkI4WF6PsrJPf0bQjbRymgrs8s7idMxqyj5j+plTVSKBbpouH63ZrcPrWrDMjntbu7pjSEl/hxu0UvAJf7Ph9lWcM03F7nh/mGCJoKIqVscCuoBHmA3k5L4dUuvS3GtibFe1ai6XtD7LbDuxwBK9b0vsZs3OQ87QWRV4quBkxEIimtWjW+iLD+Z8qtw7ASIbodQlQbpgDWSKqzLXDEwWouXmu72W4RnafepWlkKwMVz5zoKgJnwWXcOnUYGfCElYJQoTtfXu6CkptEmv0LRhoyT7i6nn0hnjGA20d9Bfv05pC58kpcAYNB3dnEAe+MJJpydutCksEMsuqUE7L0EyX5abwGUEuRZ4dC0
 fo77fPXS
 u2RNETpFN75UFXC04MudphzTMbnfn1+WmFFNUNbcWdUqGm+K/rG3oWZ0yWjM5uLQv/XfsTq/Avunh6trhE0new2qPOOASUZhyuX6tMj1eEFhoVq9laO+ltbHYINj0siXX1SHPsRIqyslCtLs255nCH9+XKsCThVHv4LKnMfT7RKvaTSKpccWgWwCbpIUqzieuR0tgs00ggcB7BFVg+q3kfulPEyV7qpvrk7bctbxu89lupCmJ0UFshyiLUSY14f4I6SPevcvzGUklGGxC5ZU/klbwGxrmK+81mjV7Z1pfEiVF0kH8IvzZa/gKHoKm/H6IZjBrwJwiLATXt9EetEpQncLOgMC1YuqQbzHlGAoSKSmAl6aVkbeMovzUohFmwSQHOZ2e17dCeUFY+sZRFEMEK1rU+03AFcwqs2Gj2f0XCLTOKWBZXuRA0YIAl4ZGz3bQXLGNkINBXZm6Ro5TJpLTjbHlfa4M0He+w4rT7t2BwoIGS2iNNgsUvJ2xL4XI/TegnPW7kTZRzQ3BTYq30+loQ/OOawOkQxz/r2XnbNIkwa1tiRdThok0TJMho5OY0VfSO+gu+6s29PKFqgU0ramo8r5LIp9VEcdax013Iu10G+JTYKMUo/Eq7r91+J8Bd4YwHxQA2jVAELxrhbwzTwrYFV19EyzY0dNqLhp7nmUyW/cPxYQj0BdU92WMDdE+PyiwMaCaXTumF2h6kVJUsNLt9NmUm/AKWkn48oTpcVErr3vkhX4W+M+i165z7jw/X0ErFlUR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 08:38:27AM +0100, David Woodhouse wrote:
> On Wed, 2026-08-26 at 09:32 +0200, Sebastian Andrzej Siewior wrote:
> > On 2026-08-25 13:51:14 [-0700], Paul E. McKenney wrote:
> > > Very good, preemption disabling it is!  It is quite possible that the
> > > PREEMPT_RT guys will need something else, but one thing at a time.
> > 
> > This reminds me of classic RCU ;) It might work in this use case but I
> > am afraid that other users might come along where it actually hurts.
> > With PREEMPT LAZY the preemption within the read-section should
> > hopefully be the exception.
> 
> Given the way that PREEMPT_RT treats other locks like spinlocks and
> rwlocks — turning them into sleeping locks — I suspect it makes most
> sense, and is consistent, to also turn rcu_read_lock_atomic() and
> synchronize_rcu_atomic() into plain rcu_read_lock() and
> try_synchronize_srcu()+synchronize_scru_expedited().

That makes a lot of sense to me.

For that to work, we will need a wrapper sort of like what we have for
synchronize_rcu_tasks_trace(), but one that does SRCU for !PREEMPT_RT
and vanilla RCU for PREEMPT_RT.

Sebastian, thoughts?

							Thanx, Paul


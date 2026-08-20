Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08F6AC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 13:30:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0107B6B009B; Thu, 20 Aug 2026 09:30:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2A596B00A0; Thu, 20 Aug 2026 09:30:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E198F6B00A2; Thu, 20 Aug 2026 09:30:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B41756B009B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:30:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 44500120149
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:30:26 +0000 (UTC)
X-FDA: 85121732052.29.70A1420
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf30.hostedemail.com (Postfix) with ESMTP id 88D1980002
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:30:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ElP4FyOS;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="j0/TWGAJ";
	spf=pass (imf30.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787232624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ASNA2n2ULlXCgF/csvU3xJ+NVPUzckfBtl899VP2uQ=;
	b=E/pwjmJvEyNmIzHVH8ijRPBtwfrqtaPi0KdxHYyPlz+i+YMLH9pMMaC5580qC23IX6qiyc
	Hs79M3nqoEo8WJT8oNCMzdwuxGxSElTgXmNeU40H1KhKRrQuMOirphQbEPQb2hu26vokXF
	rFOfHlqWpsIZuJBM/k5ySIOXsxqbA/0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ElP4FyOS;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="j0/TWGAJ";
	spf=pass (imf30.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787232624;
	b=fyKyL8TQETDd8BP3s/Y5FGtxAp9pwtC+xgjaif9l5DOX6S5DhoONvK1njQFmUsfXpEnCpC
	sRmj+87D9NZCGjn3Bb/4Mhk7Lpx1ZpqlD04EThufdd0p7CtWzcyn0k8Zp0a9DLetPq9NOe
	NFODbkNzFZ1WcxsBKWbIrSk9oVgStkQ=
Date: Thu, 20 Aug 2026 15:30:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1787232622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2ASNA2n2ULlXCgF/csvU3xJ+NVPUzckfBtl899VP2uQ=;
	b=ElP4FyOSCqRqb+Pz69s3P2eYfQne5TxOixt6SdH8S2CopMBSZftuRFoSbGEy++xou/Yghi
	538wjhY1axt5CUInvKs6ZQ1MRy6ycYWKzB6ZupFgJiMo25KIAm2K7g13UPevbLKjFVzD45
	pcCNpr0cwpPtzfnRW2H/O29HtPhDYt004+TGnyvA4nIX0TgoLnmTYcQoEw8w7+3+/bru9T
	QNU5TLPExroibLaHPbe52kdIkgEnUlCPoEuUoBlxf25kD+Bg4x9/jBEHgm9vt3ATMBxi6t
	YmpdFraagC0M6kKHnxW+8i1Wv/yI6rexAV5dqA1rpNH68Rbme9mH83I8A/smjw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1787232622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2ASNA2n2ULlXCgF/csvU3xJ+NVPUzckfBtl899VP2uQ=;
	b=j0/TWGAJFkzJNx7Du3miqrUhSBSiWlaEQe10/wRY+y/76Ymy8VShiRRORIKazfzuJVO2sp
	lscicN1nOj4GtlCg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Michal Hocko <mhocko@suse.com>,
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
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sean Christopherson <seanjc@google.com>, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
Message-ID: <20260820133020.7ZCRIhwX@linutronix.de>
References: <anwraNIKJV8zwrNT@tiehlicka>
 <44c51ace9b0dc44b795f6f48c91cda440eed910b.camel@infradead.org>
 <20260812122759.GA662699@ziepe.ca>
 <c41c52f02f033ea980d4b5f9b8239d5e9411a03c.camel@infradead.org>
 <20260812134934.GC662699@ziepe.ca>
 <a48e6e7063122b22a8083bb0792984a204f316e6.camel@infradead.org>
 <fb87f673bf290cad133d113dbb0750a7752b9d30.camel@infradead.org>
 <a94b75e8b9b1d2191f365c0f4275fd5082332df5.camel@infradead.org>
 <CABgObfYjdQ13Gd9AH-kck85ZWch7j_E00rajawFuRdt5D=m3Sg@mail.gmail.com>
 <5364F424-42B7-4D1B-BE55-B6F9E68B0F2B@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5364F424-42B7-4D1B-BE55-B6F9E68B0F2B@infradead.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 88D1980002
X-Stat-Signature: gpkco8fztrgzzd7p8x41pyrc4zj3fnbi
X-Rspam-User: 
X-HE-Tag: 1787232624-920717
X-HE-Meta: U2FsdGVkX1+Qb4EadJq9Zx4xMu7vuLlpKAGsDzz852pdxHlVpAg2RwaSWeYPqyj4N+vVmqvPm072Sq8v7XdBvpYNPP6tHthq4zRICuGBFQMTZXFKg26TneLTTD0ORr4ekbnGoP/ETmcUmObW+waYecMpwB6drJm0+DqIRruQPFD6j037/OLJri4oC33DYI8vVsGMBt2i2jv9L8ztn4BsHB3SFSO5Wt0jnILQnRU50Cpa9eAL5wOad9hLTq8GC3IZ/aJlCYWLgObQa3ccoi5FEN2YM1MfxFSUYrDsRSuzIprIHxdHgDnwvnJ/9JEUbdm4SttVDCgW3SWlcMkvCZreykBixui6gUojTEqpPymtPQSJJPvaCC18xYrgUlLcCLG8sEEM8saVMlAa0OA5yCTU4h25zpFei6ppTadyklceXOqN0CAm0spQJ4QrDNrjsN60xEkPfC4r5SnwDk5N/HLs59Uzv14MZdWsaH8graU4dygEaBuoYy9QjZ+sO04t948e25ai+G6mi86OeOYOtf5h3wgs74bzUaISeZFqRUYoiJCo4uwDCzO8CkS2xwJsV2w1Leh8hRz++5RRg6iw4bslP/rl8OwkzsicMvBSNkAAx5gHu4hjLmOZ35ezrBW9vFGeMDODNMi0mOLy0CEAw7OrFFM6lOLv2cCauoSN9+Sy1MfmsYiSsO/QHQfIAUdxhs4gKy1wJQwS9THrwxv6xQxmyEQt/nYo0XpND34j8oxHHMoMR3PRo0ffsPU2yP4R75HXUeY+o+Whtol61DuyZLh2kUXg+6pDz/AKP1KDRgahne5mCStI2+JYUeFNHm3Y6gTjv6f3JaqJLQzc/+a5CyPE5DfcWzGaSv8mlqAD3o5FpoVOyAxsHRJMG9nnt6/m0Vtqt8nTtvH5UIAGXrNN8auKBA29JPUTSFpDRjZ7fML+I023c9rwE06oNqmBKLrkAM36pEcmzpWjNIrhwsF+2Bj
 N27QDB53
 nSh2wFK+nOLtk7Gj+mgNF67JvI6GDUV1KdElH7euZ6wYtE4I0s0HVTsKmWB0xRTLCwbemcN5rJVz8Np4XMFS7jSDN5wEQFNbaY0ftGZEUuyK3Lcvgd5EH8oymUyFZRkJ2fuabWp1ykgTvu1eV5/3MkDduqpMZ5lO5RQ75x0aSr/gkUakYCLLUs73egiBzJxQgCmn7Wy5fCvUT5e5IRkS0JQb3D0LcWZUQBqoGqkYzfKk2PvWzne5/WVdcAapXXbuPwkmwrMkxuZW3p1N0YMtyWdiLA6GQa9oZSEneljVrmhM1jCopSp/cqhkw6zXBg940E6tB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-12 18:49:50 [+0100], David Woodhouse wrote:
> >Making synchronize_srcu_atomic() spin in CONFIG_PREEMPT_RT is a
> >slightly tall request - it's basically putting it on the same level as
> >raw_spinlock. But if the MMU notifier guys really want to make OOM
> >notifiers atomic, this would be basically the only way to do so.
> >
> >If instead it's okay to remove nonblock_start/end under
> >CONFIG_PREEMPT_RT, for RT kernels I'd rather avoid
> >preempt_disable/enable and only make synchronize_srcu_atomic() try to
> >skip the index flip:
> >
> >   if (!try_synchronize_srcu(ssp))
> >      synchronize_srcu_expedited(ssp);
> 
> Yeah, so in the normal case it's truly atomic but in the RT case both
> readers and grace periods quietly start to sleep again... just like
> spinlocks in RT. That seems reasonable.

I just caught up with the thread.
The task_struct::non_block_count is not properly defined IMHO. It talks
about sleeping and atomic but it is fine to acquire a spinlock_t which
is a spinning lock on !RT.
The other user of non_block_start() is pwm_set_waveform_might_sleep()
where it is used if the pwmchip's lock is a spinlock_t and not a
mutex_t. Again, it seems fine to acquire a spinlock_t.

So it seems if a lock is acquired which is spinning on !RT and part that
these locks are turned into sleeping locks shouldn't lead to a problem.

The splat referenced in
	https://lore.kernel.org/all/787aa26cf62dfd361eea8ed19f384fc517892501.camel@infradead.org/

complains only about non_block, the other fields are zero.
In that case it is just a question of how might_sleep() is implemented
and we could skip the warning for the few locks that sleep on RT and
spin on !RT. (FTR: There is also no RCU warning on RT if we sleep
(schedule()) within a RCU read section while blocking on a spinlock_t
but there is a warning if we block on a mutex_t).

In
   https://lore.kernel.org/all/a94b75e8b9b1d2191f365c0f4275fd5082332df5.camel@infradead.org
there was a suggestion for "srcu: Add an ATOMIC reader flavor and a spinning
synchronize_srcu_atomic()". This one had preempt_disable() in
srcu_read_lock_atomic(). This is bad as not only forbids to acquire any
sleeping locks (such as spinlock_t) but it also does not allow any
scheduling of any kind within this section.

So if it is *just* the annoying splat on RT, I could try to teach
might_sleep() no to be upset here.

Sebastian


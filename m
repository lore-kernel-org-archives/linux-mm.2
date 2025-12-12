Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C72ED4415B
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 10:00:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EDE66B0005; Fri, 12 Dec 2025 04:59:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99E726B0006; Fri, 12 Dec 2025 04:59:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88C866B0007; Fri, 12 Dec 2025 04:59:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 70CF66B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:59:59 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E63FE1404A0
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 09:59:58 +0000 (UTC)
X-FDA: 84210372876.02.E6BD6B5
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf21.hostedemail.com (Postfix) with ESMTP id DCC2E1C000E
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 09:59:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=q4PvE8q1;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765533597; a=rsa-sha256;
	cv=none;
	b=h3IHF08eXgFwigx7sgHY7IRrsdmjtt3IqYGPgQhgs1dxRPxByMOjtSlfbdl4Lz+fjCEwWK
	Pb/p/Fg1kRQIplXVMfHLDVRwBtMH40/UUJLhfJhXETkItZQI8hi9yJ9dzoSwdW2BgamWhy
	0IQBRPbGkdy0DqslqguykwHRkJYyQVE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=q4PvE8q1;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765533597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KSM4F9EPA4VrHSATWZaVBC81vHU19MDt0Mi2nP4hTcc=;
	b=T2QpXR86+Fe41Z5Kas5xvQ7rPHqd81KRipzszxbocEOeeF3C1mh6JLRJJTA72V8OlmYlLk
	RYp3gxYnqFN5aN2b+ht72m0os9mxBNhoW1OhzyXNuxrGX3M917srbXoUm7mRFCPzg+SNr0
	1FXaUAkkH6MQX40cFvLZoNkbXhllFhc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KSM4F9EPA4VrHSATWZaVBC81vHU19MDt0Mi2nP4hTcc=; b=q4PvE8q1MvSUiSan/OQUGVyWjB
	ey3Vrr3EGE7ZCZmMa2Q5RwD0Szf9yfpU9MDTOfKLxI7g78pi/86AKrvVEuYcUelT9SACClEtReQ4X
	YNEkxxEaf7Hj9lNNnecfwhhDw1JKhrgqon3hzMPEHvfRHMJXy1vuCRSOG+gKzHjH2areb2zIxNWHh
	qOvFVdyLVG1PxCmb11XYlPZWPjNmgL+p7J2n6WI3MKlwAD2OTti/zPQ4/lFxl9n6UUlXKAIOqZVnk
	2PnlnDVtTKp1PmPbGh5hRrZJfLK1yNLydbSCrVXlmnCktKj94YkiTNcHA+X+aMnJQX32qELAPOp7s
	fhefkUvA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTz4d-0000000GRLd-1uSY;
	Fri, 12 Dec 2025 09:04:27 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id C2F3930041D; Fri, 12 Dec 2025 10:59:43 +0100 (CET)
Date: Fri, 12 Dec 2025 10:59:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Marco Elver <elver@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Will Deacon <will@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ian Rogers <irogers@google.com>, Jann Horn <jannh@google.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
	Uladzislau Rezki <urezki@gmail.com>,
	Waiman Long <longman@redhat.com>, kasan-dev@googlegroups.com,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	linux-sparse@vger.kernel.org, linux-wireless@vger.kernel.org,
	llvm@lists.linux.dev, rcu@vger.kernel.org
Subject: Re: [PATCH v4 07/35] lockdep: Annotate lockdep assertions for
 context analysis
Message-ID: <20251212095943.GM3911114@noisy.programming.kicks-ass.net>
References: <20251120145835.3833031-2-elver@google.com>
 <20251120151033.3840508-7-elver@google.com>
 <20251120151033.3840508-8-elver@google.com>
 <20251211114302.GC3911114@noisy.programming.kicks-ass.net>
 <CANpmjNObaGarY1_niCkgEXMNm2bLAVwKwQsLVYekE=Ce6y3ehQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNObaGarY1_niCkgEXMNm2bLAVwKwQsLVYekE=Ce6y3ehQ@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DCC2E1C000E
X-Stat-Signature: 1tp3y6sdod3fye3qdtr34dubosaym8td
X-Rspam-User: 
X-HE-Tag: 1765533596-476328
X-HE-Meta: U2FsdGVkX18a4fe6eGPVhXD+ERoqWRa1o2rPB5NVFm3hp9wDyEP8fxQpefZpFyJSBHPPfp3rg9XBJ0eRDS+aR9DJmKfqe23BnqFyh6CdPn4OvzLtmXwzUblCYJeiOpmlm2yWyFayQXDs9TiYvR5jrgomNFrh5YltcE7jJq6GvpF+XoX3PxV77Al5RaF2X+IM3gfcKORgrGS5vEtKYSFINE0MfBN1/ICniZnvftPThRbTpfLnPrdhqzaptfhiJDprUE5su6GrbH8kO0oc8KdOtxofpnLUnHmolNGgESrB7qbC7NJE3CY2EUv8FVewFrJkEkI8Vg8x77QeVBh/PRd9CqlRv/Vi5NCzKr6cte+cnL6sg44d+5WB3XptCPS2Zkia3HfBXnjM6xPZBNLV7Z17ZKrr+Tds8O9CUHHGOwaoXOODYESKWCe0UjJR1G2CB27hNQXI3hyBfaRmccO4bmeCstJZX7EDNnodIdrzhkghauY0JWfR3dTvBupGZSsZDi9+M2IKPTC3/Y1sN3P9u9nxLG0AhQkJFlbVfYcuLLcjhe/lOfbHBLugIP5cVXI0E+mZaYP7bHuLlhsRhTw4wQHeM0NqkRhE6yTtydkN2kK8Y+5sR/KbizRnweEPDrP2eamBFIUxE8eQp/byyaFcC3w/wPkGoWxxR91qE51l1xY/vBw6RegyQohMXrEYROvZDf0Css3vmW8UvCfUncvoLVwbsXw7SQisfEXIBY4AATc0UtIXsC8X9VKIMudStWPVqev3jCfKijNr0s+O7ztmcOTRNs6i4Ewiwhr9tkY/otMXe468zkFRUWUjlICYb0qGDd2humyhOyT5qQMVViCRdO8NkdfI+diqJ0OUHvDKgWIuq2GEAOYRKCZXWnkFLX98255dYrwc0fVZUVh52afveY/CUQ8X5B6OGYYqqtD9soncy02GWD4ijFx16M/dgr9q62Wpdj2lfCLKkvr0exvYRzw
 wTZujDyR
 DTsVtQFW4coB9lh6D6KeDF1ZEDpNfstAWubqCWTY8NaUexIB75y2zeMvpKEUA0NS7n57s1QObBbOlDTIaiy+yIvJU4yMGm6vE6pEm7NSZJGcRx2yjw2KW0u2T8jGK8OCh3zP5fNzwHU/f6H9S0Mwtk04UBCxCOyQy590VOfyx2VRRtIzsCaSvIbkI3NK6daXjYLiKqXwRwP8/ZRGC/Q7MTZG49LIx1/vr6kuTB4BwM/Yd+I0JAPoDsZmQzmE7iu8b5zCYgqlWNueGcWx3iaFBZn5HLehJZkaa3PVg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 11, 2025 at 02:24:57PM +0100, Marco Elver wrote:

> > It is *NOT* (as the clang naming suggests) an assertion of holding the
> > lock (which is requires_ctx), but rather an annotation that forces the
> > ctx to be considered held.
> 
> Noted. I'll add some appropriate wording above the
> __assumes_ctx_guard() attribute, so this is not lost in the commit
> logs.

On IRC you stated:

<melver> peterz: 'assume' just forces the compiler to think something is
  held, whether or not it is then becomes the programmer's problem. we
  need it in 2 places at least: for the runtime assertions (to help
  patterns beyond the compiler's static reasoning abilities), and for
  initialization (so we can access guarded variables right after
  initialization; nobody should hold the lock yet)

I'm really not much a fan of that init hack either ;-)

Once we get the scope crap working sanely, I would much rather we move
to something like:

	scoped_guard (spinlock_init, &foo->lock) {
		// init foo fields
	}

or perhaps:

	guard(mutex_init)(&bar->lock);
	// init until end of current scope

Where this latter form is very similar to the current semantics where
mutex_init() will implicitly 'leak' the holding of the lock. But the
former gives more control where we need it.





Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CB9DD4415D
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 09:44:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A1E06B0005; Fri, 12 Dec 2025 04:44:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 052B36B0006; Fri, 12 Dec 2025 04:44:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E832D6B0007; Fri, 12 Dec 2025 04:44:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D58F06B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:44:03 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7D7D9135073
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 09:44:03 +0000 (UTC)
X-FDA: 84210332766.01.816EEAD
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf27.hostedemail.com (Postfix) with ESMTP id D0E8F4000A
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 09:44:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=Ur4V8SWv;
	spf=none (imf27.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765532641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J0s9Z/Nw7eH3J6mljMw45LY45lUZplaK/cGrdA/YkXU=;
	b=S6hCc1ZSpVuHFpbiU9MuK3TSaxBQBc+DIwIelz+HAROtnO+KpvofK9fy9dMviFfJqE6XXk
	8BOxfU3PaEPdct+ng5uzowNuNlbTY9yYFdVq/+hK7PSNNaRK9jXJCBShlcrKucbTPzmMa1
	Fm5n74qPOfWvZQi28zS2FGazkKLndOg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=Ur4V8SWv;
	spf=none (imf27.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765532641; a=rsa-sha256;
	cv=none;
	b=S3PHgpdM6bsUJOWdGAgygM2+qhVpXbpRJ9dkwPv8hcez2oivejy2lXWncuQguyX8DYSuw0
	uAAYWiCduUxyPQ73pjM/mEy4KRAXiN5YP/xfwHHbJTIiLBut4sP+F4m6iR3V6vDokGYeT9
	npKUdsUOpqh3Z5t5CN4VbpQXEw/chVM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=J0s9Z/Nw7eH3J6mljMw45LY45lUZplaK/cGrdA/YkXU=; b=Ur4V8SWvfQ6bSD1Jimbf2HVssZ
	qtgtHbkdLRensVt0bGd9gmnk/6zpXiAQtBkoWUfgwj4Bf/1keaOG6pYGijSTHKAdKaLFq2VZYbFRA
	hQ5a0RAvYfnxCKTYdyOPpUiIlu4T6yPz6EeldvhXavFMh83NzCTTWjQ0QSmqfAcLMgExspdRiuu5s
	BCFQ5Us9cj0ZfN9IYbcwtcnFZDXYb59kyvH8kVVPhxxLkfxE2EPtxm4CVlUKWo7JOzF42LHRLV+VF
	vLvu3eTnH3zISwXdT9whryYHXL8nvHtiIVOsIgPDjAPaaAgTfdwEXYqdH/6qEhUzMqg86r9b9ud4/
	/tVR2YOQ==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTypH-0000000GQ2D-3yf4;
	Fri, 12 Dec 2025 08:48:36 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 2F0AD30041D; Fri, 12 Dec 2025 10:43:52 +0100 (CET)
Date: Fri, 12 Dec 2025 10:43:52 +0100
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
Subject: Re: [PATCH v4 06/35] cleanup: Basic compatibility with context
 analysis
Message-ID: <20251212094352.GL3911114@noisy.programming.kicks-ass.net>
References: <20251120145835.3833031-2-elver@google.com>
 <20251120151033.3840508-7-elver@google.com>
 <20251211121659.GH3911114@noisy.programming.kicks-ass.net>
 <CANpmjNOmAYFj518rH0FdPp=cqK8EeKEgh1ok_zFUwHU5Fu92=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNOmAYFj518rH0FdPp=cqK8EeKEgh1ok_zFUwHU5Fu92=w@mail.gmail.com>
X-Stat-Signature: ymz5s11ddozdtbc6hecndzr7rghpkh7i
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D0E8F4000A
X-HE-Tag: 1765532641-460256
X-HE-Meta: U2FsdGVkX1/elQq+uUhkU0yqg8QYVQ16feYVeWJ3H2WEelQkfe1fiBxZy5mtsLuHHKaFd3T1na689JaCdjWcXSnyBKdGSFprVBG2O62OXUvO3uDjqg0HyrA1w1KgSAVtjCpyzOxd3Yk2U8fzeaLUe/h7ERDQlxZrCJE+e1a5wGyvlXZehv5BYj/+CN3PyXGzxAoAyr093krc8uss1+GfeUJqangDPDeuXeOGxKzsQjGna0jy/OW+Z4kR+uHf2I9iJaOtVEgVwGHLRuPEH1Ho+iuEIURdNm97NrifTTso+xVISkQD3YCZc5ReBML02M6SddmSVXINXe4L3E7ioMsqURi8w/WIwN9NdJeHOk3mQaZ6vgrbJyfLF8J0L0dCrwXsZOygnK1vcnxZbNYDFctvKergHyBohCcD9aQhvuQHZtsbCo+YNvtHEBueJePsVxvwcNiiBLmy01medf0wk3Kh04XuwaH4ad+HqYh5YUH+HAA9LEP4lYyy/N48awv1T6y7MGYTpASZdSwbA6ESQs36xKs3lkDxwajKFmLu4uoLIUpB7vDy2XNJAXyJkoYJOhcx2eBcIyx1wOr8gTeECGHeqrSzi4zgyVB0EHL4l9CNHkzG6wJWv+ZZ1aJLxVlIB2pLevA8GYC4F7Vhr08jEPosRfrAjLEIMJdDr3uBPCV9Ze1A1lFvRkYjeTuCAOWFeljslB8jxRVgr/A3gRprWAVVJoWR5xE4UwbqVB0agOabueLxyoqKItKSySzW6dZa/+143Z2KJJQIna4DmyTgiuILV79TPNUpCbsUstijqcXyQsHs5w+nJbVmJ1X3e1/Jf+/0Yz4ux48wirWyFuuAYLNIpP7QqYr5yo7GEg930q8IUq4ySu+oB/KBoP0fANoquZh2IjOxE44wshf66Y833Y/vlxkV6cWcfOR7mzC6vMzWEUM35AHSaQDpUKSe04V/obP9No7nrtW4tVkKkuARyy+
 vuPgmt94
 Vp4nDXKjz7McdqjEPBE6eez2zbSptG7BUVcdD5x8L6VrEa5Cfll8MGZlUifkLiJS1eTzvsAOgLjGyDqlzJTXsL+HC9+3zzLvQ+0INvy8C3ONrhMyMixVQ+ntObaTvTlWPnJYg521Z2ncgDp2Xa4khf40QgTwbzSJHKJ+TYqXQfO8HEgrbxJTq9MhvRrq4vE3m3ZLegRvT7tPrfaV043Fk+Wd8EbNgVuGfAK6y7bM8+4swvVTnVGIe1+931ECXSzB5tCLOpmmNQFik3it/Kfdj30MqqoSBVDp6L3kh26Lssk/zbsrcd+bjcoORPQrJX7PXj93chY7Ou4ap6zOsQGUW4UV1C6E3l1jFhnfQdjNkpjLK9oJFPL8Agy97/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 11, 2025 at 02:19:28PM +0100, Marco Elver wrote:
> On Thu, 11 Dec 2025 at 13:17, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Thu, Nov 20, 2025 at 04:09:31PM +0100, Marco Elver wrote:
> > > Introduce basic compatibility with cleanup.h infrastructure: introduce
> > > DECLARE_LOCK_GUARD_*_ATTRS() helpers to add attributes to constructors
> > > and destructors respectively.
> > >
> > > Note: Due to the scoped cleanup helpers used for lock guards wrapping
> > > acquire and release around their own constructors/destructors that store
> > > pointers to the passed locks in a separate struct, we currently cannot
> > > accurately annotate *destructors* which lock was released. While it's
> > > possible to annotate the constructor to say which lock was acquired,
> > > that alone would result in false positives claiming the lock was not
> > > released on function return.
> > >
> > > Instead, to avoid false positives, we can claim that the constructor
> > > "assumes" that the taken lock is held via __assumes_ctx_guard().
> 
> 
> > Moo, so the alias analysis didn't help here?
> 
> Unfortunately no, because intra-procedural alias analysis for these
> kinds of diagnostics is infeasible. The compiler can only safely
> perform alias analysis for local variables that do not escape the
> function. The layers of wrapping here make this a bit tricky.
> 
> The compiler (unlike before) is now able to deal with things like:
> {
>     spinlock_t *lock_scope __attribute__((cleanup(spin_unlock))) = &lock;
>     spin_lock(&lock);  // lock through &lock
>     ... critical section ...
> }  // unlock through lock_scope (alias -> &lock)
> 
> > What is the scope of this __assumes_ctx stuff? The way it is used in the
> > lock initializes seems to suggest it escapes scope. But then something
> > like:
> 
> It escapes scope.
> 
> >         scoped_guard (mutex, &foo) {
> >                 ...
> >         }
> >         // context analysis would still assume foo held
> >
> > is somewhat sub-optimal, no?
> 
> Correct. We're trading false negatives over false positives at this
> point, just to get things to compile cleanly.

Right, and this all 'works' right up to the point someone sticks a
must_not_hold somewhere.

> > > Better support for Linux's scoped guard design could be added in
> > > future if deemed critical.
> >
> > I would think so, per the above I don't think this is 'right'.
> 
> It's not sound, but we'll avoid false positives for the time being.
> Maybe we can wrangle the jigsaw of macros to let it correctly acquire
> and then release (via a 2nd cleanup function), it might be as simple
> as marking the 'constructor' with the right __acquires(..), and then
> have a 2nd __attribute__((cleanup)) variable that just does a no-op
> release via __release(..) so we get the already supported pattern
> above.

Right, like I mentioned in my previous email; it would be lovely if at
the very least __always_inline would get a *very* early pass such that
the above could be resolved without inter-procedural bits. I really
don't consider an __always_inline as another procedure.

Because as I already noted yesterday, cleanup is now all
__always_inline, and as such *should* all end up in the one function.

But yes, if we can get a magical mash-up of __cleanup and __release (let
it be knows as __release_on_cleanup ?) that might also work I suppose.
But I vastly prefer __always_inline actually 'working' ;-)


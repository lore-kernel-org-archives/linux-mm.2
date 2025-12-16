Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AAAED5E133
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 12:24:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED7CB6B0089; Tue, 16 Dec 2025 07:24:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B9E6B008A; Tue, 16 Dec 2025 07:24:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2FDB6B008C; Tue, 16 Dec 2025 07:24:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD0026B0089
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:24:18 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5D20513B4D7
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 12:24:18 +0000 (UTC)
X-FDA: 84225251796.13.8FDEEA5
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf15.hostedemail.com (Postfix) with ESMTP id CE797A000C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 12:24:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=g637eP12;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf15.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765887856; a=rsa-sha256;
	cv=none;
	b=SRpTooVOmRrcoqP/rx7I895aWlTyYLu6sxZVrUWisEbTtNqxAxGnlZIWfwUNVJAmEJpLyE
	+sDNwH60ffhkzc6urRul9cDwRntO79IOQXq3Pf1HvRCHGVeSJm4tZGOULALsXaWjxGyBZR
	U6TUwN1My2crekVEKg1+zo3ORlqqLwU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=g637eP12;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf15.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765887856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lLRQaT+PfrlE09N+ydMoSz7Mn4llxrI8kjoKOroo6L4=;
	b=k94ACWrkUYIGmT85Pe1Oi2ZhApgHA7X5sGhJ7W3kzcosD3B0jRDM4k09UYPYUkwR+BBl7o
	3ruGzvyR10Fb5NoX+IlqE6nIAJrScsDOck4eQSBLuxyAKwd9uhIYdvyth5jGA6cFbSzJHH
	pef8ypcGZ+liIcwdLc6oPGWElVYaG2E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lLRQaT+PfrlE09N+ydMoSz7Mn4llxrI8kjoKOroo6L4=; b=g637eP12cSdDeAwjLUJVp9bFxA
	NCfokUWkyh4uqLE48N1Kt6KCkC0EROAHECKL/1Pfv7IamNv287e7/ZRrq31y34dK3TYBeWd+ECvxs
	L2SBBUq1PaIzX16nemfVr+aLsuXjWsLOgrSUi5KRBcSlf5V/ymVNJIDj3BrGeJPcaT2nC099cRgIH
	jZMyRMXi3Rdob5lJ/38vx25CRMg8UqRuY8Ehd0Lf01AEduHpm4wgTpBdsE5z9c25E0Q1CoPEhtZ43
	C3TmwnFQoLCm3OgM+z6Aor54f4zuN6+7brFHBUbgoXnQ1ypFdhfOMuTF5UMymOEpBLnFKLBNM9Sfb
	JfHr4YQQ==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVTES-00000004hkA-3IWl;
	Tue, 16 Dec 2025 11:28:44 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 60ABA300220; Tue, 16 Dec 2025 13:23:59 +0100 (CET)
Date: Tue, 16 Dec 2025 13:23:59 +0100
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
Message-ID: <20251216122359.GS3707837@noisy.programming.kicks-ass.net>
References: <20251120145835.3833031-2-elver@google.com>
 <20251120151033.3840508-7-elver@google.com>
 <20251211121659.GH3911114@noisy.programming.kicks-ass.net>
 <CANpmjNOmAYFj518rH0FdPp=cqK8EeKEgh1ok_zFUwHU5Fu92=w@mail.gmail.com>
 <20251212094352.GL3911114@noisy.programming.kicks-ass.net>
 <CANpmjNP=s33L6LgYWHygEuLtWTq-s2n4yFDvvGcF3HjbGH+hqw@mail.gmail.com>
 <20251212110928.GP3911114@noisy.programming.kicks-ass.net>
 <aUAPbFJSv0alh_ix@elver.google.com>
 <CANpmjNNm-kbTw46Wh1BJudynHOeLn-Oxew8VuAnCppvV_WtyBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNNm-kbTw46Wh1BJudynHOeLn-Oxew8VuAnCppvV_WtyBw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: CE797A000C
X-Rspamd-Server: rspam10
X-Stat-Signature: b3n1ry43k6orek4bczhp7rkmjnwfo314
X-HE-Tag: 1765887855-691440
X-HE-Meta: U2FsdGVkX198FZUbVE3VWy5iIgDB9C3PT/17/qjO3lZfrqz1jm6rpBgLSjU59rf57pyBxUzDW8r3osLycnTjtj3VG8Kjf49+hfNoevFjZjZOnPJIKoFloa5ilaonCXxU+2UrAVrIfx+bvexM+t2+XNO5LqEUiXUgCCTtm8ZS+4eSaA/2b2uNccRi53EnS3ttxsdbtchuST+LkxI8wrlFQR1enHX1xK6FhS9z9RuypA3vsIyY6Mc8Zq+HcqE+aNJlITr36Ur2m1eLdJGyHOIgBB6O0nZhTX3KYtbCdGrtCCvBYDX4Cfo7wJ+/D6oFQ0eXnxWCorm8WvscwUyAtSB/AWTmQGAO5An3CJ2lB9D/TKaYecNuteqJF+ayTimhX+CA6aKTkGVUyu3LWDjUv8ZT81wz3GKToYMyjhjRfJyKkiM77HKryhxe9ZQmF77GI/wsQwnymG1/9c2DKN0ySshHN31JbmCEMKq24ezrvtyKyGCp5HOct6zmjYD4g4fnDwDZpy/FvDljdWBftoIbovCkA3/C8hBAgOSbQPBl0oJsNVGoEyfdvrKRSLx6m5nym9fDpoX3YX9PfrRvYUXuA73DL82iN/uAA+NS/O+IXF/pRsXDp+/oXM27rX1gTEcM6sKNyUSgEj6zIOjAZTCe87WN0OXf4CZ44gVZvjQSRrnlEzArTjhoYFSwLWN7+9o6bHutReaCwSpFVLWilX2+uxaWtZqKdGI+WbcE8++eKRgFLNR5Jokl9q/JagIEQsnq2YG9iSF9k8NHnNCBymobvvrBBs3VA1YgA9sycVQQkHpxpwfYtrFNJUzDxT22/x0lMkGrGpzikxwy7EXqXMwsQKX9yKwWxaxi5d8QSryHE0ukbdau7mWiEjVPKUSuMBRqiUU7XQSGW4MUNIWH9wF0EFIFc0UByP4kMz+PJxkp7dl1OjDzUWS9QdoCq9FzcffW6qI0kVBj5EO/3W7YBgIhkTT
 5OtnBy19
 HFGlZlGjiDCBnGtsJxNrnhmp9+3rDZJSKpo+Gd296u6j3QsXAs9xwY/6V+jPAtlxtyGjvJ/JXRx1Fx9QQeYNJN0NRHBUmJvE9+I+b8xL8l56SvE0NAY4VdGeEputQorAodigLmFAbIiWBh9OQepNMXJPiyS4acNOsWqTnj4BsvhROXHhgMsa9gYWEAj2sEOJY9e4UdMivxyr4GN2zg7exZGUz2ATIU2NmERT7pRtTekZjHCqdJiuizoOtlBBjM9jknxkSmA1K9RFIGLn1yAdjAtxeUpHfFFikoRXTi+kYy66J5rOx6u0ccdlQoA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 04:53:18PM +0100, Marco Elver wrote:
> One observation from the rebase: Generally synchronization primitives
> do not change much and the annotations are relatively stable, but e.g.
> RCU & sched (latter is optional and depends on the sched-enablement
> patch) receive disproportionally more changes, and while new
> annotations required for v6.19-rc1 were trivial, it does require
> compiling with a Clang version that does produce the warnings to
> notice.

I have:

Debian clang version 22.0.0 (++20251023025710+3f47a7be1ae6-1~exp5)

I've not tried if that is new enough.

> While Clang 22-dev is being tested on CI, I doubt maintainers already
> use it, so it's possible we'll see some late warnings due to missing
> annotations when things hit -next. This might be an acceptable churn
> cost, if we think the outcome is worthwhile. Things should get better
> when Clang 22 is released properly, but until then things might be a
> little bumpy if there are large changes across the core
> synchronization primitives.

Yeah, we'll see how bad it gets, we can always disable it for
COMPILE_TEST or so for a while.


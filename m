Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F137D4417D
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 11:09:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 866F16B0005; Fri, 12 Dec 2025 06:09:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 817DF6B0006; Fri, 12 Dec 2025 06:09:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72DCF6B0007; Fri, 12 Dec 2025 06:09:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 628EA6B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 06:09:50 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DCDB860319
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 11:09:49 +0000 (UTC)
X-FDA: 84210548898.17.D9BA54E
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3F48320012
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 11:09:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=h0RqJPJB;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf03.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765537788; a=rsa-sha256;
	cv=none;
	b=zGw3HpaQAPbnw2qMfSH0CEjT815ti8CBa//Q6gP0iSMnT7rCFDYnRQtCcZ/x5gYjE/nDoV
	/WdRek0cburmOsQ2p8aAialy5C4borV5Fc3J/r0Vv5Ody8zEkB4+G2Kz8lKuK8uhOKrU5J
	FR8iirZ3wzTr57LiRBEnfuD+8e7tbMY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=h0RqJPJB;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf03.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765537788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sAhBWDHUpHF5PVStWIyQEDmT8IbGgPASZMaiPzih1nU=;
	b=uQjET2qphh/QOTye+tRjW0klKh9bRR9D0kMn3QPgphNbkffgLqNkd5H8RlFMMS++vJ6fGa
	YpkMh+FEgoqW3P/ntRgV4xul9IgrVqmhGB1g979yV/18XJ9Vdik+ISEL1SOWZ+JmruBuIs
	fxDG+Y7lZOvGUhz8vfBo00GoIE7pHT0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sAhBWDHUpHF5PVStWIyQEDmT8IbGgPASZMaiPzih1nU=; b=h0RqJPJB3EslZXH+NrQY8Oawml
	xVZKoRMlILjKuWofLcV230Ra6sSrB2+xJvvgUEbp5EFV/Ksdl7n8uO/wv7F0hgMeWOXRU+OD2v1g6
	YTKEG10gwSh9bsJkLhxckP/d9wbsNQ6ayLlXDhf9hOmuRnj+WLStfaeCkHyhmMouC5a1H04FluZox
	r6CS1zDV7kB+xQmqonG5Xik2CYfRMXdrWt5KAW/Un4rc/os3/oSKhHMXr/E94yHUZ9ZNmv3taEqmo
	3yjzq0lkadR8xVmJOPsHrod0+96Cr641yagkt0pGVO0wgWglc8UyMpb3Fhnw4TDxwjAf9cwJOj3Ec
	NuZNKjag==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vU0A9-0000000GVlg-2EQb;
	Fri, 12 Dec 2025 10:14:13 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id C422A30057C; Fri, 12 Dec 2025 12:09:28 +0100 (CET)
Date: Fri, 12 Dec 2025 12:09:28 +0100
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
Message-ID: <20251212110928.GP3911114@noisy.programming.kicks-ass.net>
References: <20251120145835.3833031-2-elver@google.com>
 <20251120151033.3840508-7-elver@google.com>
 <20251211121659.GH3911114@noisy.programming.kicks-ass.net>
 <CANpmjNOmAYFj518rH0FdPp=cqK8EeKEgh1ok_zFUwHU5Fu92=w@mail.gmail.com>
 <20251212094352.GL3911114@noisy.programming.kicks-ass.net>
 <CANpmjNP=s33L6LgYWHygEuLtWTq-s2n4yFDvvGcF3HjbGH+hqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNP=s33L6LgYWHygEuLtWTq-s2n4yFDvvGcF3HjbGH+hqw@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3F48320012
X-Stat-Signature: a9pfgi8tbqhyutdn9am3rpunauernngx
X-Rspam-User: 
X-HE-Tag: 1765537787-195191
X-HE-Meta: U2FsdGVkX183ge0GwzFHdbWMBIXkmtRiFiOBNZE6KuSJeI0nKd/jyG/hybR/d5j9bIXml8jTKqttE7NeBlADIJBT3yTkKTGboc4ZV++1rEb/8sxwM/sDyNSToHmUN7brMRfa9evdUvxCE1hT9rH8NkA31ot4VONhrpqn4pgp/YEc86QyRE03TViaE6okg9bk4V70n/CObaL7xUZHZ1N4vMauz3K7lASUMUbguxtVds793WAcmpqU+yJk97DbGKW2WSY3yY3Gz3l54GXM6fd+r/Xprrll+152NGgP25aISTXpYg4s9uz9Eu2OY0TtLnoBhCxlimHO8jLIJh28MqZkGLYciQT0dTJAtm76R+MS96DzQPZvLVkhpz1CcvlA8hJgB1vWXGBxpHTSR8OLCgsojXW7GuovJ47CtKScbrH7hubbUHm8bY6KTxbEfSljNMG152Jalu3XSSPmGaUndgmaGVuY4upk04EId/O3zOOLFcpvYStAQFlc/avBFFxnqdbtUyf3sp7Cqcvrj+BoY8BuULXHXhJbW6oKvWkgdji8cNuOdLRQVfkWKz8PLDlmCL2CM05eK9V4E1C10Svz0hIZvG4jieJ2FvPqP+QzKYrdT4kCKk3UITxSs3J69Ei9WSGSJm18b7Zkl9e802yl3zILkjfVwWODpxAf0TyZt37zB5MLXBZNIXCL64lQvKbEPnYIxqWU3u/FRHgLIHEHS838HXGvOEjHBIJeUwOpuw15Ng85NQsqlJeFOfvzAFyjbibKHsmWa3yGOp4rIKwMxovFkFEi5tdy7cRIWRZcgkOashSrqkh+hndnL3/CcprmPoEHcKanCZKAU+QjyxTJHt+8uvC57n9lsUy2swVFFROclnaG/dBOHPyS8OxmIRRZUW5DqvjgWkr56BarFVDGzf54EId0m0Gdn+kLV+LJZEw7ivolCKI3al4gf3llwWbI91wIqt4/FpLdtY2XwUAixik
 yaUNJNRa
 ewFE7uHLYDdBr9Rte71cLObY2Z8Oubn27fuVWhE3tJNe0RApHz9yCH6OZ6mqV36qSx2CO+Quq1niT9o3zLhuRrjZ7ilwaZ2PZQcj1B7uuRNINQ/TivjTIKtqBmjrmO2DyGgnWToNEuj8trZ5HNOwWTbwnEPKmEajRhOU7GJIDD+sW8xo4pTA+pLZ74GgLEvX5i+D2enlUx/sqSsl5ZcSsX4Ob4lhvNIp92rpTsfg+uFkwzV1KJl2FdFAgz56sxJyx1QdwDc92tU9Cz0wyNmeVfKYFpTr0wg84QpvhITaAS05p4nK/SdatqqUiXvmqPNf7bNUIkmk6cIwzmSBh6pn7yKk1HoBD+bc/DXdvZfSulpM8InO97ZD3isLd5DNHzCz2c4eE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 12, 2025 at 11:15:29AM +0100, Marco Elver wrote:
> On Fri, 12 Dec 2025 at 10:43, Peter Zijlstra <peterz@infradead.org> wrote:
> [..]
> > > Correct. We're trading false negatives over false positives at this
> > > point, just to get things to compile cleanly.
> >
> > Right, and this all 'works' right up to the point someone sticks a
> > must_not_hold somewhere.
> >
> > > > > Better support for Linux's scoped guard design could be added in
> > > > > future if deemed critical.
> > > >
> > > > I would think so, per the above I don't think this is 'right'.
> > >
> > > It's not sound, but we'll avoid false positives for the time being.
> > > Maybe we can wrangle the jigsaw of macros to let it correctly acquire
> > > and then release (via a 2nd cleanup function), it might be as simple
> > > as marking the 'constructor' with the right __acquires(..), and then
> > > have a 2nd __attribute__((cleanup)) variable that just does a no-op
> > > release via __release(..) so we get the already supported pattern
> > > above.
> >
> > Right, like I mentioned in my previous email; it would be lovely if at
> > the very least __always_inline would get a *very* early pass such that
> > the above could be resolved without inter-procedural bits. I really
> > don't consider an __always_inline as another procedure.
> >
> > Because as I already noted yesterday, cleanup is now all
> > __always_inline, and as such *should* all end up in the one function.
> >
> > But yes, if we can get a magical mash-up of __cleanup and __release (let
> > it be knows as __release_on_cleanup ?) that might also work I suppose.
> > But I vastly prefer __always_inline actually 'working' ;-)
> 
> The truth is that __always_inline working in this way is currently
> infeasible. Clang and LLVM's architecture simply disallow this today:
> the semantic analysis that -Wthread-safety does happens over the AST,
> whereas always_inline is processed by early passes in the middle-end
> already within LLVM's pipeline, well after semantic analysis. There's
> a complexity budget limit for semantic analysis (type checking,
> warnings, assorted other errors), and path-sensitive &
> intra-procedural analysis over the plain AST is outside that budget.
> Which is why tools like clang-analyzer exist (symbolic execution),
> where it's possible to afford that complexity since that's not
> something that runs for a normal compile.
> 
> I think I've pushed the current version of Clang's -Wthread-safety
> already far beyond what folks were thinking is possible (a variant of
> alias analysis), but even my healthy disregard for the impossible
> tells me that making path-sensitive intra-procedural analysis even if
> just for __always_inline functions is quite possibly a fool's errand.

Well, I had to propose it. Gotta push the envelope :-)

> So either we get it to work with what we have, or give up.

So I think as is, we can start. But I really do want the cleanup thing
sorted, even if just with that __release_on_cleanup mashup or so.


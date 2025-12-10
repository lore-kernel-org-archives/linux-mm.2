Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05FD8D3E781
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 22:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49F626B0006; Wed, 10 Dec 2025 17:50:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44F706B0007; Wed, 10 Dec 2025 17:50:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 365216B000D; Wed, 10 Dec 2025 17:50:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 25ADB6B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 17:50:05 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D07D1603A6
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 22:50:04 +0000 (UTC)
X-FDA: 84205055928.26.55F4B48
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 364D2100002
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 22:50:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AO3exkGe;
	spf=pass (imf14.hostedemail.com: domain of "SRS0=0X6L=6Q=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=0X6L=6Q=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765407003;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6FoZNt0nK3YYBtmZQJhBvmqydOQpluIdlIFzCbdFNYI=;
	b=vUF6rZBm8xWKOukSJfBq3bfH+8WC4qsD/T3R2k0GixUm+YkYlO9XsyoP/QIFlNR9491hNd
	k9xFZs9dDeOA3Z/ilaOYCWwhtuw9OXi0Ys0DlkzKGMVWLku195CQXcLzXSyuQB06J8uvUB
	T3U+AcSazqtgre/cm17EjrStpeGsoow=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765407003; a=rsa-sha256;
	cv=none;
	b=KXKtBBut4KeXgput3/ZnvQXT6wLG4mqZ2n5mZmi38DTz6tbHNM2yVNIRWRbTgeiM3uicPt
	+32KNiY2WAAR+oz1nxb/PZ4067PCyHm/YRx3I9AsWqzTqCt2b8OpIAalc02IMSRq4UPRGl
	KQkEJiPeTYxgWJ7jhFfjdBG1s7dlY2c=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AO3exkGe;
	spf=pass (imf14.hostedemail.com: domain of "SRS0=0X6L=6Q=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=0X6L=6Q=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 113DC6011E;
	Wed, 10 Dec 2025 22:50:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D001C4CEF1;
	Wed, 10 Dec 2025 22:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765407001;
	bh=qW/tF+X/GtmF1/qBlEvZg0QJgsmBQoUZONiEY+CGh0s=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=AO3exkGe9nKbfvet6/zsxhBl37cIXDnVvN50TlnHA29GEmWWrfZrAHmxs281V3PcM
	 w8i9dwQDFrIKGbj1buQnqWIBRdY+OQV/RidCp4SikXk7xFANcs4g9bOE44rMROiXA9
	 5indEXpSk9hqMDmVgEXdZ5jhDcB7nJqL81Y2A56028sG+Dflc31Gve7lsV5ALgl5t5
	 Nx/7m9WMWKbuuj4Gkh9Am3GzzLgxvfLNJ9ZlQz2t15+5qEeAUhhnP+3aXxrpxulf5/
	 8+AxuKQXlUFczaJK6RjgBZIlaSv1k70gFjf5NOILerGsKTul7tXvrQxQTt/8MFZcYh
	 dkvcoQb5zDo4w==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 31591CE0CA7; Wed, 10 Dec 2025 14:49:59 -0800 (PST)
Date: Wed, 10 Dec 2025 14:49:59 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Will Deacon <will@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>,
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
Subject: Re: [PATCH v4 14/35] rcu: Support Clang's context analysis
Message-ID: <31a77eff-5295-48a9-96be-ecc7ff416317@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20251120145835.3833031-2-elver@google.com>
 <20251120151033.3840508-7-elver@google.com>
 <20251120151033.3840508-15-elver@google.com>
 <98453e19-7df2-43cb-8f05-87632f360028@paulmck-laptop>
 <CANpmjNNsR_+Mx=H6+4zxJHwpRuM7vKUakS8X+edBD521=w4y_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNNsR_+Mx=H6+4zxJHwpRuM7vKUakS8X+edBD521=w4y_g@mail.gmail.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 364D2100002
X-Stat-Signature: 9kzfdhi78wbujtddimskihjiio5yzwds
X-Rspam-User: 
X-HE-Tag: 1765407003-886359
X-HE-Meta: U2FsdGVkX1/VxHOdJ5hMqzOwm1VZZehKwVi0o1fqX2U17l5gBbO6C9nPuERicjeCjL7LGYj1yxIZLwE+GUgI9kn5Z5tjEtql5kSpn2zRAWqYxsno/CxTKwUhXC+5O9EHwCPYBi6Qww1IjKmZekekPK32IZ7b0luuNowRg1khNtKF/JspVs77NKv6BmGkJK3ydQSIndHBfLac12SM5Cs7ThVUbgO3omk7DNCNFSZoRrYG9Y1npPgavxCVq5FPR3go70LTJ7Y8Rjn2eWtg76OshqH8278P27ShvyNRo33OCAsPyN2wfe2mfT24MBXnmMeC6LupaNmJES9Wss1fu1NM9ty+zk658PnLJexsRaB4Q6PYI76a6NcIWaQh7WH3p/eNIEL941CM0qLHSmiGBb/NZVKphAsRo++0bJtQ2RgOKorFi+bPw/Po8MLvsjyTkr8IheQqtydbXu//TbHEtnwxcCaK8Pi/ILBhdNrJnZROzTfXF0fwMWJw6iaY98z8wT6tA5gTT54STyOOKg2AP8oaMjBuk3ZVn9oMy+9wDOZJVue98O9Pib13D0NVD0FzPVZUmQqmHzWvz8/SvBNsxCaQTE+zAXmkJNC79QNmcPfU5cj8B6Uo/CQi9UKPQPqZYuBcNzTJhQw/zPAnszPgj7VWDaOeeFwPpIUCpm8vMIANViJdgqFADRVvtWJ56+Lj6vmIfXdu9Ilp2gS5VYTPFEbpYEQdGQ2hL1oOszkmFoxqDgAdHU9eFoNr+52QApKbQTbOXEgSJfWHXUXgGflIcwQ4wvIkES/NNWHSYn/jB2/CYFpdIslIPF9PVuT92YQD/q0zFSWFbxB2Q0rO1ND6P+UUZmef3zMgo0Pi0ag3LPmh3ecWXi6gPINInv8iTR3BHswI1w6QeAsi6ARqEdKS+VkZv8dYZemskPcU5KT4jryK/cF9Y9R1xfG5Eeey0rj9csEICfkYjmjrbzDBtjfl+QV
 xLRYeZZx
 aaatBVnh3tGPupaFBMty72XlOSpF7sbjrBXbUNwe7o5blKTLKWwawDMdG5MRkXdhgitJo5mlUCoNArZvR1AeNjFUDei1anBOJ/bx0soChkjANebGsl9EMTq55Ghvkm0s1tarnQt5FtWAywMZt9qhWZvFle+QVXnksK9JT2LOCk8X5CpGjHcZKzZkCDImkJ0gOU/rZ1aGxKedplqNBQa+q5RFsuTn+YmlVo2pft4RtTrRJNWA1Tvu3czgJumsIYpnkEo6+7Yb8H0rm3IVuKncS8NGkEjt9g7HqmT5YaTltdXoq34fnlCZpdt7rXtcMOVnfvTmYTw3WxMYFwQB1+NCIOBFfjMCp3uI9e1DIpBbLR7jLSYj1NetgTqBpfse9cLLoeuT/n3JUyp8z9mEoi0Py1vy9Thmex8L9AWWZAf7bBFGe2vjnsTOmvq1jQt+qGv5qWO7EUWuPcceTdd1/YqEeW9eTXjhN9PV9rVEu059tTLoNREoSoVQVdE+pBkSHCm3AcpDeJazWtTCYB+kJresvIgAczBZvpMehyTXiTLKi9ppbmgt1tpncHs/Gso3CWli+5A9B3HL3vsXNdb0qU7yrm1Jwcj2nDTygPqcjPsQ09mfFsABqXm+nX93/CNTE/ipLd/OSM1RuR36Z0OCURa8mC7oVff06VCjFtJnaV29G0xHLpKTBVpFNQWOy+bdWg5izOfIiU6gmEr8xs5kbYjC3sSDNpAJZ8D2QmLbwAbwCvvL0UMG4qg4HznVzQFgs5cCS6rLJhG5LSYdQXIw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 10, 2025 at 10:50:11PM +0100, Marco Elver wrote:
> On Wed, 10 Dec 2025 at 20:30, Paul E. McKenney <paulmck@kernel.org> wrote:
> > On Thu, Nov 20, 2025 at 04:09:39PM +0100, Marco Elver wrote:
> > > Improve the existing annotations to properly support Clang's context
> > > analysis.
> > >
> > > The old annotations distinguished between RCU, RCU_BH, and RCU_SCHED;
> > > however, to more easily be able to express that "hold the RCU read lock"
> > > without caring if the normal, _bh(), or _sched() variant was used we'd
> > > have to remove the distinction of the latter variants: change the _bh()
> > > and _sched() variants to also acquire "RCU".
> > >
> > > When (and if) we introduce context guards to denote more generally that
> > > "IRQ", "BH", "PREEMPT" contexts are disabled, it would make sense to
> > > acquire these instead of RCU_BH and RCU_SCHED respectively.
> 
>  ^

"I can't read!"  ;-)

> > > The above change also simplified introducing __guarded_by support, where
> > > only the "RCU" context guard needs to be held: introduce __rcu_guarded,
> > > where Clang's context analysis warns if a pointer is dereferenced
> > > without any of the RCU locks held, or updated without the appropriate
> > > helpers.
> > >
> > > The primitives rcu_assign_pointer() and friends are wrapped with
> > > context_unsafe(), which enforces using them to update RCU-protected
> > > pointers marked with __rcu_guarded.
> > >
> > > Signed-off-by: Marco Elver <elver@google.com>
> >
> > Good reminder!  I had lost track of this series.
> >
> > My big questions here are:
> >
> > o       What about RCU readers using (say) preempt_disable() instead
> >         of rcu_read_lock_sched()?
> 
> The infrastructure that is being built up in this series will be able
> to support this, it's "just" a matter of enhancing our various
> interfaces/macros to use the right annotations, and working out which
> kinds of contexts we want to support. There are the obvious
> candidates, which this series is being applied to, as a starting
> point, but longer-term there are other kinds of context rules that can
> be checked with this context analysis. However, I think we have to
> start somewhere.
> 
> > o       What about RCU readers using local_bh_disable() instead of
> >         rcu_read_lock_sched()?
> 
> Same as above; this requires adding the necessary annotations to the
> BH-disabling/enabling primitives.
> 
> > And keeping in mind that such readers might start in assembly language.
> 
> We can handle this by annotating the C functions invoked from assembly
> with attributes like  __must_hold_shared(RCU) or
> __releases_shared(RCU) (if the callee is expected to release the RCU
> read lock / re-enable preemption / etc.) or similar.
> 
> > One reasonable approach is to require such readers to use something like
> > rcu_dereference_all() or rcu_dereference_all_check(), which could then
> > have special dispensation to instead rely on run-time checks.
> 
> Agree. The current infrastructure encourages run-time checks where the
> static analysis cannot be helped sufficiently otherwise (see patch:
> "lockdep: Annotate lockdep assertions for context analysis").

OK, very good.

> > Another more powerful approach would be to make this facility also
> > track preemption, interrupt, NMI, and BH contexts.
> >
> > Either way could be a significant improvement over what we have now.
> >
> > Thoughts?
> 
> The current infrastructure is powerful enough to allow for tracking
> more contexts, such as interrupt, NMI, and BH contexts, and as I
> hinted above, would be nice to eventually get to!  But I think this is
> also a question of how much do we want to front-load for this to be
> useful, and what should incrementally be enhanced while the baseline
> infrastructure is already available.
> 
> I think the current series is the baseline required support to be
> useful to a large fraction of "normal" code in the kernel.

Makes sense to me!

> On a whole, my strategy was to get to a point where maintainers and
> developers can start using context analysis where appropriate, but at
> the same time build up and incrementally add more supported contexts
> in parallel. There's also a good chance that, once baseline support
> lands, more interested parties contribute and things progress faster
> (or so I'd hope :-)).

I know that feelling!  ;-)

OK, for this patch and the SRCU patch based on a quick once-over:

Acked-by: Paul E. McKenney <paulmck@kernel.org>

							Thanx, Paul


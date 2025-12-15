Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F615D5B16C
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 15:53:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 560186B000A; Mon, 15 Dec 2025 10:53:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 537806B000C; Mon, 15 Dec 2025 10:53:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44DBF6B0010; Mon, 15 Dec 2025 10:53:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33FB66B000A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:53:59 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DAD3E13A574
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:53:58 +0000 (UTC)
X-FDA: 84222151356.07.C3361CC
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0D889100005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:53:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qndgzwdc;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of elver@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765814037; a=rsa-sha256;
	cv=none;
	b=jGTLrPUpo0Zh0I03W8wbTIWi5yvEaHbvrglTTHjMmmewEGanhHa4eVVMi4N7VPhFmXbmXE
	AnoXcs5xKiCSpEVinCe4/lzUd13U7SaeG88wINK/Q4DiPPK7iLwuomjok++vskH/3Xiafi
	Ij4Ta8Q2sG1jY9RjOOKN9C3B9qf6K+Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qndgzwdc;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of elver@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765814037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ROScw7LkVEobmMJDTvBXmeogZcMVtVRNIb25XYU/aOk=;
	b=hM5qkWuYXYTQT4q9TZMNpANW6yyQFr1K/ZIum5+kfx5eBZHc9lu+91puBCHmprgA+4eprW
	cSZ8MgdbVcsiujPUW4CkleWDc3hYkBkVrBQuJpNNPf123la9uv2Q9ipuk4eJYnq4lWa/6B
	XMHDYhvtF4mr8kmT+Q6Te0kKqrQaRA0=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a087b2a9c0so26289515ad.0
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 07:53:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765814036; x=1766418836; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ROScw7LkVEobmMJDTvBXmeogZcMVtVRNIb25XYU/aOk=;
        b=qndgzwdcKHpWqWUdZUOfa9tDDXpOw8mJ7Xu1rGDprhOC1iO19ih84ymhuzYAfdib8T
         gDUQiTmoXEgna7SfdpcchsIS2mrCd+l9hR3jw2j64HajxMUnIiDv22DqUw66mWNNn/P9
         SeeQkqZMhnuAWOG6+UDssGYVm3E6mQqYJYLfRZzRVoYPWgp0b7we3WymRvLkcyu7r951
         kROrTMveG8V8f+mk8G3keiwrVWK9KmKi1y6/O0FczcWFJyedUkCAPjbhvpqAp2sQsSrs
         MuZG6ve5Lq25BMtBe8sKtQG5bqanXJvGG+45c5jWiSlWPl8jOuTpqPdd/J5fUMxBNZA1
         9Gfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765814036; x=1766418836;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ROScw7LkVEobmMJDTvBXmeogZcMVtVRNIb25XYU/aOk=;
        b=PU37TQnCHIkc71TsnoQ6rqwOvFXWttJ6xYFuSVyByxgzjZfXIlgLcj6fTpe9H3XWzW
         T+utxnUcJQhtbXcn1vl5ZW8LhvzUMCqrT7j3jUFW9FGW5ulkwvCZKLGvzXYyurdPh5Wk
         PJHMTPrk+L3/Dk9/c3cNkaFbLTZos2oVhpKG0QzEtRG6n5xWAw0Nec2c2CKfT6o4UQB4
         XADcKK6t39YtqWSQlECm1HFkXJoGIRZtyLsvMgQPIvezH2DEeV0LHp6HRZRszOf6xQ8L
         Ts9FV5GKrGgjj1qp5skC9Wsd8aXIAKqGbf10GaIEcFHtdHnI9W8/ps/rhJIP1U/o/njY
         O7/A==
X-Forwarded-Encrypted: i=1; AJvYcCWKwHZ/YkdOPI0pv+rupprg3CmZGx7wIk2Gs7cju3Q529YTPLLelAwxrAFhyR6TAA8SrTWBS/gbEg==@kvack.org
X-Gm-Message-State: AOJu0YwO3VH6GSFmPqD3ynpKKg4eqsSEjUgG/g1+zi0krCDj4QJGf1FA
	8bs+LOMiyC7AaddBib1zbpRCSqnSrriYQDOpIWhaXS5vGKixDN8iaMsiQVFPx5SS/5hrXp3LlCL
	wpphS3UtIek7ZjYwKMHjgh/1pbsvTGIvcZLyVaUO9
X-Gm-Gg: AY/fxX67utjML6zGucVgZJgiaEz4/D0CeIzOzl52x6Y/H4Fc3ogjITLLiXHnVozSRxH
	lHp4GKb2MMyyg3gT7AaeWOyF/f4hjXJbnrQ+B8rnottIdUdNrepVYLTTVZ3wdKBePEd9UMZ84yg
	9+1xDtOvPTDvd8Trh+BlpUj0/3jdYblGjwLv+fWqbfTnBdF9koMQ4NzhG5UFJ/lS+cMz8VGrtLc
	z3F9jt2bXeE3ntFUXKC3Ov+hnAh9EwJTzMeXXronq4iZgpo5Q/H6MOWOT107uwsH9+5pkEGoJUQ
	XUF0GNqSkqjymgKEPXHuPbyFLQ==
X-Google-Smtp-Source: AGHT+IEqHtbIkXeCrxZ7N2Is3Z0BKjAm77k3VHnhb//Mc2q6P3kqxs3MPR3a7KluXzGQE7f0g+lEq90Z0zzfwOCm1e4=
X-Received: by 2002:a05:7022:1b0c:b0:11a:3483:4a87 with SMTP id
 a92af1059eb24-11f34be9ca7mr8171406c88.13.1765814035105; Mon, 15 Dec 2025
 07:53:55 -0800 (PST)
MIME-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
 <20251211121659.GH3911114@noisy.programming.kicks-ass.net>
 <CANpmjNOmAYFj518rH0FdPp=cqK8EeKEgh1ok_zFUwHU5Fu92=w@mail.gmail.com>
 <20251212094352.GL3911114@noisy.programming.kicks-ass.net>
 <CANpmjNP=s33L6LgYWHygEuLtWTq-s2n4yFDvvGcF3HjbGH+hqw@mail.gmail.com>
 <20251212110928.GP3911114@noisy.programming.kicks-ass.net> <aUAPbFJSv0alh_ix@elver.google.com>
In-Reply-To: <aUAPbFJSv0alh_ix@elver.google.com>
From: Marco Elver <elver@google.com>
Date: Mon, 15 Dec 2025 16:53:18 +0100
X-Gm-Features: AQt7F2oxzebZt0rcTkreaKMT4PDBgj_kZoo-YwczNEo1aa0S6zPi6Xbs61JFiQg
Message-ID: <CANpmjNNm-kbTw46Wh1BJudynHOeLn-Oxew8VuAnCppvV_WtyBw@mail.gmail.com>
Subject: Re: [PATCH v4 06/35] cleanup: Basic compatibility with context analysis
To: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, 
	Will Deacon <will@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, Chris Li <sparse@chrisli.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>, 
	Eric Dumazet <edumazet@google.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Ian Rogers <irogers@google.com>, Jann Horn <jannh@google.com>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Johannes Berg <johannes.berg@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Kentaro Takeda <takedakn@nttdata.co.jp>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0D889100005
X-Stat-Signature: pfspidjdt4mqi4ww1ag5eiw5cusa99mj
X-HE-Tag: 1765814036-268012
X-HE-Meta: U2FsdGVkX19/OoNcIVBrgXVwUFWC755SQCs8CsWLc8+u165gAkTbxHfKBq4iIh3N52WrfEScH+dlNOnDJP8yRvkYuRtQ9vLY2DReBTHhHhhfsChzyLaRxbO+DRwKvcA5M7Yt6P1yHf8vg8lObWjReyOp2kmDUzxac6q2L4mYfwkAluYyMJx7KcPQqjkc6YVG4DjuSC3XZAbdD7qgDcfbVOMwklLowGFszWyKymfBxDXDDRS7ktpPtiE2izMa0zOlGXgvqtRJQ7nbdVJFjUUvRXkf+Imbfl91c/qkkVDlmshma7S8rhhDLKpmn3C+DMs4Bq1DeeXuuNtMpzvlm92aX4BcLFNSBGIwKfJNv56RtW7E9JtENcSgrLAudr0IYaKMZ5cZEeD1CSCw4TsNc2R7dCxNSzm58LS9cCZrIkJGikw2U3jsK+7HXXHll5E9ZS2YIeJbZD3iLp5tQm+gntwdI5IaXHOHmn+v3dmeei40q3K5fUTMrb8Nbvby/lYwR1WRoJTO/cmOGaqUy/pvSQ3xRCQGkkLERuDtn7KxG8q5262XVXDPfTz29IDvVhERHOgVOHnanqrhytD2OZVZYgvoZImrAOKTbEIt+pNCtXya79abd5HayXyZjF7ucXoHDLEMotCtkfdZx3eS2LN7Kx/J6uQxUNkr4xrmSxwqGpGnsgczoPtLQdUOd5C+FQTB5tRp6qGzBIqe8CKR9M11ypQRYW/9iVuLweoYOIlJwGigho4agOi3lyoQIiZ5hbDNhX+CoCk+8jr777d0IJ2IVVwodIcSC+M2jIt41R7U1y3DUzX72F18MXZV3Dttlm56adEh8wDO7Qu5g3ryswrvumjBLHNk+CPjHTtnu2UFQ6BeXxO/rjp1NkYWwOUeLYohoiGCm2gdDsWW9LmVyHFIFuE7Je2QISRPF4j1GmfQ4b3X40RAOhlyapigeGgz7rX5yXGAvE7q2PURTHrY4vtGL+U
 NNAJpGHH
 HGVWmGF4ni1dU7eCnJJbMYQ6mHgdoGAFQf4ynODBCGzUx3BNKnvhwO3ZGInmCSJd7FAwNtMuO2/rIOiZGnEqEKxK8luaqoD4JuVnvXurUTqjDJ0mpsJeZcUkPim2druEP28SQdE2JG1WQ5LPNf+jXMqSYd/3tLf7gXcaBMirZij02Mxvrxx4F4DG5+6KKkPu1EQNsi92U0lHgpIqu9Ac1T6clnHZ/odB2b88qogjk9pVlzlstfacVNOPPY3gV3q1bTlPAH86Jq39zrRHXeNHmSuXuEECTdvCXMCA7l0xTX7Dvr0zkf7YpIIO9dHmhFARRp0sSVvsO+vxuWTnizYiaIFB910oNU7BZj8kv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Dec 2025 at 14:38, Marco Elver <elver@google.com> wrote:
>
> On Fri, Dec 12, 2025 at 12:09PM +0100, Peter Zijlstra wrote:
> > On Fri, Dec 12, 2025 at 11:15:29AM +0100, Marco Elver wrote:
> > > On Fri, 12 Dec 2025 at 10:43, Peter Zijlstra <peterz@infradead.org> wrote:
> > > [..]
> > > > > Correct. We're trading false negatives over false positives at this
> > > > > point, just to get things to compile cleanly.
> > > >
> > > > Right, and this all 'works' right up to the point someone sticks a
> > > > must_not_hold somewhere.
> > > >
> > > > > > > Better support for Linux's scoped guard design could be added in
> > > > > > > future if deemed critical.
> > > > > >
> > > > > > I would think so, per the above I don't think this is 'right'.
> > > > >
> > > > > It's not sound, but we'll avoid false positives for the time being.
> > > > > Maybe we can wrangle the jigsaw of macros to let it correctly acquire
> > > > > and then release (via a 2nd cleanup function), it might be as simple
> > > > > as marking the 'constructor' with the right __acquires(..), and then
> > > > > have a 2nd __attribute__((cleanup)) variable that just does a no-op
> > > > > release via __release(..) so we get the already supported pattern
> > > > > above.
> > > >
> > > > Right, like I mentioned in my previous email; it would be lovely if at
> > > > the very least __always_inline would get a *very* early pass such that
> > > > the above could be resolved without inter-procedural bits. I really
> > > > don't consider an __always_inline as another procedure.
> > > >
> > > > Because as I already noted yesterday, cleanup is now all
> > > > __always_inline, and as such *should* all end up in the one function.
> > > >
> > > > But yes, if we can get a magical mash-up of __cleanup and __release (let
> > > > it be knows as __release_on_cleanup ?) that might also work I suppose.
> > > > But I vastly prefer __always_inline actually 'working' ;-)
> > >
> > > The truth is that __always_inline working in this way is currently
> > > infeasible. Clang and LLVM's architecture simply disallow this today:
> > > the semantic analysis that -Wthread-safety does happens over the AST,
> > > whereas always_inline is processed by early passes in the middle-end
> > > already within LLVM's pipeline, well after semantic analysis. There's
> > > a complexity budget limit for semantic analysis (type checking,
> > > warnings, assorted other errors), and path-sensitive &
> > > intra-procedural analysis over the plain AST is outside that budget.
> > > Which is why tools like clang-analyzer exist (symbolic execution),
> > > where it's possible to afford that complexity since that's not
> > > something that runs for a normal compile.
> > >
> > > I think I've pushed the current version of Clang's -Wthread-safety
> > > already far beyond what folks were thinking is possible (a variant of
> > > alias analysis), but even my healthy disregard for the impossible
> > > tells me that making path-sensitive intra-procedural analysis even if
> > > just for __always_inline functions is quite possibly a fool's errand.
> >
> > Well, I had to propose it. Gotta push the envelope :-)
> >
> > > So either we get it to work with what we have, or give up.
> >
> > So I think as is, we can start. But I really do want the cleanup thing
> > sorted, even if just with that __release_on_cleanup mashup or so.
>
> Working on rebasing this to v6.19-rc1 and saw this new scoped seqlock
> abstraction. For that one I was able to make it work like I thought we
> could (below). Some awkwardness is required to make it work in
> for-loops, which only let you define variables with the same type.
>
> For <linux/cleanup.h> it needs some more thought due to extra levels of
> indirection.

For cleanup.h, the problem is that to instantiate we use
"guard(class)(args..)". If it had been designed as "guard(class,
args...)", i.e. just use __VA_ARGS__ explicitly instead of the
implicit 'args...', it might have been possible to add a second
cleanup variable to do the same (with some additional magic to extract
the first arg if one exists). Unfortunately, the use of the current
guard()() idiom has become so pervasive that this is a bigger
refactor. I'm going to leave cleanup.h as-is for now, if we think we
want to give this a go in the current state.

One observation from the rebase: Generally synchronization primitives
do not change much and the annotations are relatively stable, but e.g.
RCU & sched (latter is optional and depends on the sched-enablement
patch) receive disproportionally more changes, and while new
annotations required for v6.19-rc1 were trivial, it does require
compiling with a Clang version that does produce the warnings to
notice.
While Clang 22-dev is being tested on CI, I doubt maintainers already
use it, so it's possible we'll see some late warnings due to missing
annotations when things hit -next. This might be an acceptable churn
cost, if we think the outcome is worthwhile. Things should get better
when Clang 22 is released properly, but until then things might be a
little bumpy if there are large changes across the core
synchronization primitives.

Thanks,
-- Marco


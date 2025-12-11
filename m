Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EEC0D41C38
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 13:54:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A8C36B0007; Thu, 11 Dec 2025 08:54:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6801A6B0008; Thu, 11 Dec 2025 08:54:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56F586B000A; Thu, 11 Dec 2025 08:54:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 46B2D6B0007
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:54:48 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E51F9C01A2
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 13:54:47 +0000 (UTC)
X-FDA: 84207335814.07.1FEACCC
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1B9E0A0019
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 13:54:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DD178Nk6;
	spf=pass (imf25.hostedemail.com: domain of elver@google.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765461286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aWRPRAJ89lgq7qGLYK1gyasHO8BcBnTXm3hkZRbZKOw=;
	b=jX/HcgTNbnSFKgPWsGLuVn3r+g/QqfLETXakweqLZ2sypDRoMDNpOU5FFY0ad9HA9JUl3L
	EP0VgZDfy8PawnWcCImIjzwIZ5lFWYixJa2BP9AYxPcCkMZK6VOCSJB5ozWgx5wIIgh85h
	hiATnqDvhWVV5VT0PTEAuzFW1oSrwzc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DD178Nk6;
	spf=pass (imf25.hostedemail.com: domain of elver@google.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765461286; a=rsa-sha256;
	cv=none;
	b=elRsdun6f69PgZV5E2P2kKfKXLVyrI/TdggFO5ZH60KEYFxBbpqxV/9I/q8DvOGXGt2chy
	KQgB1hH9xKYklpjZBdSqVnjzWmn6QaXm4GjQfwoOnH7CsOLA5oNWRi7DoAa+NGVCxt/0x/
	Jw+63YSQK3SnhuI6R7YV9dna0VM+En4=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7aae5f2633dso95200b3a.3
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 05:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765461285; x=1766066085; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aWRPRAJ89lgq7qGLYK1gyasHO8BcBnTXm3hkZRbZKOw=;
        b=DD178Nk6EwAv+ghim8T2/cQyV539YwpJ63NZbd81pGVkyX3DRsE29ZriwBPiIUMHvB
         xDsZmoUCR6Z8Cx/l/tI0IbWU2hkDNyK1QDCTmHbI0VPujrmGmbMPuWFy9cfAPitE17Qw
         ZzBKSuaPPvUqOZD0Y8NRxwWb4XuzXVFaJgcLeeP2elVISv84rVQZl9LlairS6hWKsFFi
         k1JlzmXBZMunHU1vWM42Qq1vPcyzZzLAY473IrUyE40YVpi4fwWe16/tVxp4mj/nTfwZ
         /brTNEzsCd953CMk6G9xbY+8R9nCm0CGsLJ+wP1tIsElY7hTy0nDvgfHx/Mm541QPWqE
         MlHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765461285; x=1766066085;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aWRPRAJ89lgq7qGLYK1gyasHO8BcBnTXm3hkZRbZKOw=;
        b=R5TjpopHySPbxu1r+2alKB/htrlTOMb4ujV0UHw+OGIqpNRKfq08DLRFEat24Ll7XD
         w62BPeX7YlY9aIZmibMdxjlappvaaevyVrKAuXE1xqsMl7lajsRmfCyLxUKcMkM9BA6h
         nQF43C2eq+cb89phNKwJrYtPoxrVfWE0J9j7S81QDluC0vrkB2ya+ATqBdJZX7BuJdNc
         La1pXYg+fNbsmuMPg7HU55lJW1UAyT6QN9dep0gEKkLQzr120JkQWO6jaGjyG9xTjDuQ
         W6Q1zyxBfDnyGll9lJvzpFeZDTenoqDykdariSWs8e+Qg1PHTEAwxfVRwytIvZXWT0R2
         vlkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWTknOuSZ3VJBesUO3F3n+uY8IvhKQYeIBp95jXFtzuGUctNb9OqSWXmTdpbiw9J20QLAae7ud93A==@kvack.org
X-Gm-Message-State: AOJu0YxASz82u23NyMYV9NGyIOx5haEkc5J8jpiNmky7+bUEggptsF01
	FFmUWVZEQN60lWLKpEfLM3HxHryOtd3AUG1+aFPAPU/xLrT7RBlIi2GqAzBI9RO5q58jNVvJ4vJ
	hHO7fty3Dk12SUxHgK9/niwKpod1l1wwxCsWZC/n0
X-Gm-Gg: AY/fxX4gF+UlM3E6yAHmX+bDXnEb0P73i5A7dnnVPYqBixZNQ/aSJ/MgrnVeYWYNnut
	cCaME1f7XQkIi9AIzCUTD8Y71RwokIO9+pgZNOet7obzXQNXJcaLEFqSx37zZE9V7yNQlpwVVFE
	h9WSMJHhhnWsx95eVpsgDDV3ETuV0IsGN5DnHJtLoecN4ctZWQxTUisxffAiIs6H9niDw2IYEO8
	Ri2sRYjMWqmGVDiviGcx1IAH9aIZcFBeEttLnjRGnASI9s5d99eIzI4Gv9DriOpk8OPkRlVpETc
	bwf5FTl6x4Ie5tM9wUtd1AGO
X-Google-Smtp-Source: AGHT+IEaaruplzdVpdnApdH4OVSrHUz40RptUVIyI3MxrgnCoT6vGrQB2vef/vIeMxQHfT2Nk7cub+UMnQmlsyGPvik=
X-Received: by 2002:a05:7022:2219:b0:11b:bf3f:5208 with SMTP id
 a92af1059eb24-11f296558d9mr5045780c88.1.1765461284380; Thu, 11 Dec 2025
 05:54:44 -0800 (PST)
MIME-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
 <20251120151033.3840508-17-elver@google.com> <20251211122636.GI3911114@noisy.programming.kicks-ass.net>
In-Reply-To: <20251211122636.GI3911114@noisy.programming.kicks-ass.net>
From: Marco Elver <elver@google.com>
Date: Thu, 11 Dec 2025 14:54:06 +0100
X-Gm-Features: AQt7F2oz75av79IX-Fsq5GL2dibuf0pX45-76DYGUr2aahssaITkwrN9Ju3gYq8
Message-ID: <CANpmjNN+zafzhvUBBmjyy+TL1ecqJUHQNRX3bo9fBJi2nFUt=A@mail.gmail.com>
Subject: Re: [PATCH v4 16/35] kref: Add context-analysis annotations
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
X-Stat-Signature: 9ruatqb8yuwrw9job9dyyi89kja465ax
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1B9E0A0019
X-HE-Tag: 1765461285-974755
X-HE-Meta: U2FsdGVkX18D0ikDUTr2LO19oLxj8X9QySHHLUlg+Di2cOgM8C+7jGYu7yKGMyt7VPuEPmCN78v6OreIGDGw2NW9h2m8++kv1Fc0yxGi4TifinrW8FwdHWG/cIYkquCen712JWJDR8maNxj7AR1ar75D/Vmy88YQ88fs1gf7tnB71yGGITMi5zELGiThBFTm4APKWAfuJ0X7ROBwWky8qP4cA3KRpsZtg1ACPRzQIwT1CXMCTktfwWLA7P926p0GOixI0YRMnKA8VjEiJw1oCijdznZwDK9FU4wA7UENdv+uoKC6BnD+nsBZLAIEZDZVOlcGT1WvLjxkNhFopLqv3Gnyd8wNM91DVVTPzea3lu3YYXvBmNlOXLngjdMtd7fGgxEdSahcw9v6MkPPblqFxnyojhKu621pA9R5bLL3nQ+LvNfCyJRVrsGETCHWT+R+pFx5OJPk8lrTI8D4M9HXlI8kp6SisZGoJ8PtEkGcubr96PHt9McluFmj0tt4uYhVJxeKTwcEzY3SAogX0R9E60f3nF7GXgjOY0o8xu5VbiAbxXDM/ZnzqXhBKvNmBlTLRkNVvkes0osfFvWaZM5xmmGC8NzFwgny1JO9Bs99ZsQp+bc9U3GtRrWFODu8N33lUuCXJhJgmB1wFzydM06ivf4Pdb7vPeN9g2GzR8CqoQkNLd8McaG9kxNChcZGAybsuc/JfBN6EmwnAy9TCfIdUfB7f8BhjAAFz7DU3VSJQ9stinPpvnIrr/OzJbtkfBCtw4x1f7n0yeO+gtAbBCkmYGZyjqSe0eheqD0dl8R7VZxcgIqkpIay0LZmPirJJ0PceGx26GZTF1S2ampzOMJklcC7/d8HVGP1BHLwq6CNYX95oYzJB5XczoVP/3KqIbtwy3NG1XLnnK7WpyhpMaIo0dmPzn4Cwjs5swTPLCWQbdC5JItcnYfqun2Hk9ZS/TgWlo1rrPPC+S4Z0x1EBUe
 hetJUZiB
 ejwpsFJa2f7sX4lcQMFL/mLA2Ht38TFgtVaxmBDwo512hPg4OLsusykhJsQK2LQFt7QEuOADYMZh0+eYNUwJX+fSCapWoMVMwLkSNpu9qmLFi032VrbN85bJDAGgeBmlRwvz06HmAVewmVkKv+hA9eqBvPJ1AEOZpZDWe+G2siQVVL1Se09sQ7F2L5KNppEsgadmgbemhhbEsWA5wJVBJ5z1o1pcBDIOwoCXKk7gTZTPq4lnODpepBnRfz9LlEIgvvznxjC7kh1CtHNEAkYTBs1IwZBwOKVxw8HIdxz33BBkCqO3Sv5xUt4gh7Q2kmxlPV3YsB0Vo6rNCsmfVjlYLkg46r4ih0r6mkuKP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Dec 2025 at 13:26, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Thu, Nov 20, 2025 at 04:09:41PM +0100, Marco Elver wrote:
> > Mark functions that conditionally acquire the passed lock.
> >
> > Signed-off-by: Marco Elver <elver@google.com>
> > ---
> >  include/linux/kref.h | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/include/linux/kref.h b/include/linux/kref.h
> > index 88e82ab1367c..9bc6abe57572 100644
> > --- a/include/linux/kref.h
> > +++ b/include/linux/kref.h
> > @@ -81,6 +81,7 @@ static inline int kref_put(struct kref *kref, void (*release)(struct kref *kref)
> >  static inline int kref_put_mutex(struct kref *kref,
> >                                void (*release)(struct kref *kref),
> >                                struct mutex *mutex)
> > +     __cond_acquires(true, mutex)
> >  {
> >       if (refcount_dec_and_mutex_lock(&kref->refcount, mutex)) {
> >               release(kref);
> > @@ -102,6 +103,7 @@ static inline int kref_put_mutex(struct kref *kref,
> >  static inline int kref_put_lock(struct kref *kref,
> >                               void (*release)(struct kref *kref),
> >                               spinlock_t *lock)
> > +     __cond_acquires(true, lock)
> >  {
> >       if (refcount_dec_and_lock(&kref->refcount, lock)) {
> >               release(kref);
> > --
> > 2.52.0.rc1.455.g30608eb744-goog
> >
>
> Note that both use the underlying refcount_dec_and_*lock() functions.
> Its a bit sad that annotation those isn't sufficient. These are inline
> functions after all, the compiler should be able to see through all that.

Wrappers will need their own annotations; for this kind of static
analysis (built-in warning diagnostic), inferring things like
__cond_acquires(true, lock) is far too complex (requires
intra-procedural control-flow analysis), and would likely be
incomplete too.

It might also be reasonable to argue that the explicit annotation is
good for documentation.

Aside: There's other static analysis tooling, like clang-analyzer that
can afford to do more complex flow-sensitive intra-procedural
analysis. But that has its own limitations, requires separate
invocation, and is pretty slow in comparison.


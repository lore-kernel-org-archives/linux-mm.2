Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94BA0D5B16E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 13:39:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1E716B0006; Mon, 15 Dec 2025 08:39:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCF646B0007; Mon, 15 Dec 2025 08:39:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABDEC6B0008; Mon, 15 Dec 2025 08:39:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9A54F6B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 08:39:04 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 408D2135142
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 13:39:04 +0000 (UTC)
X-FDA: 84221811408.03.C9E9BEB
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id 258C9A0016
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 13:39:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bNtsXmlk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of elver@google.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765805942; a=rsa-sha256;
	cv=none;
	b=JfyVJtvo7Ke0rAKG+xIapFjD4Wa/GzXkN7MEp4i42MWOsSDbl3uB0Xl06zp5Bvcb3rf+Km
	+e5JtdqOs/rhSQZSo328fnGTEVS1xneOt0HnaBz3IX9hWt8hsmRNKUDWYkhayXh5+48VoR
	ZbsKWKp5aJHntMGRXd5CROpUQkJpQPU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bNtsXmlk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of elver@google.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765805942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HP7wXZoAxj3YG64MFXhffqc9TkW1sld9ucKsb/6ZFh4=;
	b=505EnWFGeyKouKYL3lYU2gsrR70MBqHqQSGHSuAbTyfe90gd44aHK9Hyo0R0x8luLuzTzW
	NpG/r9e2+GtwjeYKpMuu3lmLfqMSpSC3njxM9zvJs24a8wldHBMU1wwijaeEgPK5TxHnWm
	fuM+M7knUH6ixxZW3uZQBdDd6Yp5J+I=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-42fb3801f7eso1693712f8f.3
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 05:39:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765805940; x=1766410740; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HP7wXZoAxj3YG64MFXhffqc9TkW1sld9ucKsb/6ZFh4=;
        b=bNtsXmlkzNYfWloHSCeu6B8MPCvvN/t+LvsUzoGFP9x0UaI7AVdH9aBDo9E+1eihHn
         9DHt+m48SaKBCp8d95Z3utDD1H/yqjZpvrliv5wA6/gUBJx8g5wXsFDyB1XDcfhDzh8Y
         pK25RVQW4U0WW9v7gyB7rODz53ekQbcCmzo/tB0QkLI+aFKTYfJd4xykyWkxGzTC3MN8
         FBZjVfAiwonvPKFwvzZ3FSlba63JnR28z77FQ/A75aFtj55xsJfonlE6FStpwFEMkYqO
         lnQaQh57wbSmts5XgAfoRVCmArncSxOykikT/PBrFVbT8//+0CpLl5R5xlZj2h8Kvt8I
         NYtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765805940; x=1766410740;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HP7wXZoAxj3YG64MFXhffqc9TkW1sld9ucKsb/6ZFh4=;
        b=r9f0U6mA7JXwKZrPJlX6aoCsCnJPzaV5L7Ku6G05t9vGfjakB0486qMP2aShqDbGFX
         f6LB6EViWmXP8xFunjE+x2JP/uBDZ/lk1t7gomLbxgVg3iPCtxiwnzMmfpU2ojXJcV0X
         sKCqjEAVKJM56Vl1F/lHLJS6GXTiwdAfGLtyoNLO84IPdbJtJKtkjYxOSuwgecxLzCk0
         prgjI2bdogSvzNXGfMmYhEoK0lRkok5lPK6VzbhWxZ0Y9n7Cd3dxI2SyrbbQ5TtIV2LX
         Ty4EeOwIazrbDszSc3w4QJfalimgdq2Xt0vceE9q5nup+eugqmDQh+5HfHPdtEI5pCGw
         Zkog==
X-Forwarded-Encrypted: i=1; AJvYcCVFFToYP6bpes+p5P+C5FKL8tedXpRfvYkKMomVOYmmvjn8c2UXkZVWhNOe/LvksG9WpdS97HVjwg==@kvack.org
X-Gm-Message-State: AOJu0YyLNIkArZMs/NUs0OeRxXebS1q/57FCfCJ9CuGM8VsPCISPfm/Q
	cQotp3MhWtWXHz2T+yOolFCNqxJz32lDxvBtMYYf9Y7imqbAXSz1JrDFCSpqqT+w0Q==
X-Gm-Gg: AY/fxX46YW3xX7gNUfDA77xFpqLV+iUdpSBBngCGY4mPLcNjTENbklkE+yQ+WPC/T6C
	2xUinpPnW5evvewkBto1H1hT3tRcQfKJOUrPvY2v47XhmCb8MXZjVZGc8CDc4vVxhBkdQSXV9Z6
	AEChudwY+dfOXsgZqXMNeiYeVRyuqxakWrzWezrgm52m0vVnqvZHbe1YtYkQAU821b/+rlO5JBI
	kJrzbYOCWW63g9uSXUcWLw0UV1X6j8KPyO7kAUAku4OGG3eswy5U5pP4aD/eVl67ooLgUmwmQx9
	6KkhSi9QjSu8tep+ArKB2Hhxmq3cSItX0uLKUMS17hioKRfoMDZeKxtFd5deKtmavz14LAU9Ijj
	OVTUCzomd+PNNk4PZ4fARI2DvYhy9P5l6ru9D1DLt3Cvh5XHrangzMdt6FvmSer8DvfbaI86iT8
	eS9TfzpZrVpnIM5y+X65o6PK+g4VU/CJC8YQSfE4+TO8x72LQI
X-Google-Smtp-Source: AGHT+IH6RRE6qce8+BKlIh2iGfXIIE/0drfAuueOfe5s5dH/DcFdShyJ99GxaUFmEfIgshY9jhag6g==
X-Received: by 2002:a05:6000:310f:b0:430:f7dc:7e8e with SMTP id ffacd0b85a97d-430f7dc809cmr4594614f8f.34.1765805939977;
        Mon, 15 Dec 2025 05:38:59 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:2834:9:5741:4422:4d1d:b335])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42fb68866f3sm21319081f8f.36.2025.12.15.05.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 05:38:59 -0800 (PST)
Date: Mon, 15 Dec 2025 14:38:52 +0100
From: Marco Elver <elver@google.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <aUAPbFJSv0alh_ix@elver.google.com>
References: <20251120145835.3833031-2-elver@google.com>
 <20251120151033.3840508-7-elver@google.com>
 <20251211121659.GH3911114@noisy.programming.kicks-ass.net>
 <CANpmjNOmAYFj518rH0FdPp=cqK8EeKEgh1ok_zFUwHU5Fu92=w@mail.gmail.com>
 <20251212094352.GL3911114@noisy.programming.kicks-ass.net>
 <CANpmjNP=s33L6LgYWHygEuLtWTq-s2n4yFDvvGcF3HjbGH+hqw@mail.gmail.com>
 <20251212110928.GP3911114@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251212110928.GP3911114@noisy.programming.kicks-ass.net>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 258C9A0016
X-Stat-Signature: ykgeigaq6ym3iifbfaef5mc3jgfzhwg4
X-HE-Tag: 1765805941-2882
X-HE-Meta: U2FsdGVkX1/nJMlTm46Vc3gOuNkhQa2AajtN7Kg0YymyUp1GO9z0cvWb+RFso+qdDgLmE+8mw+pEwLn8Eul1PEL2uqUR3aLvYqGvbGFebp0ueb8X5V2IWTc9zcBdRLkPjdou1epP8U65z9PrVlWySdm1xd3d/Cds0L7P5autrv2s43NE4sneTDaqfd+jgOBl6hIv0mb2BBWQ8fHKfwMgyBRJNhPDP40GwvN83HvMK3thqChBw4nSqR5A6XI0STzffXkhAcCayY+WKGfPJFWaxqo9v0ttipRUD7V/87oXjNVbnMpIdgCTM/BkcRQMT/DTWs34MWXW21zjjQZiXcUahkmSe253O+39HCXdAyKHYjD6RbQ+zoo+9SGgqDZsoafeUwx6hTPtH/7HMtCt+WLB5ehOR54zel2QBTlGKz1+uQnWOvYlU+d4qTX3aRrqGOXQQLG1M4tNsVNFmujTHtW3fh3D3Lx/al6qrFkRbSaBS8hEZw40OoGNtDJw8/gcevOS+Hany/WMAEv4XpKuMUZoyHmrVUjF93+/tL0Y4NtZ+hr5RItrf9vYl3GWYsdavaG1zUICooCIaAjpYmBdxL3sODHWAPf3dCpoKWIQWY+P3iFsS5cD9bMns3+34Gqns8JFpT1ez9Z4wDR3kZG1cx2ZZSVMT59O5VV8E5bbRp4xTpQ3f6/sToSAHBo1NQiiQ58f0LZd/BAJiKNBqBcuGqh66ff4kSRCbEjZBQwPmi0Z8mNQ0Xy2HAVLMlm7y1rCu/CroiTmuczpGVxBBjz4XyQG43odVwjo3PEejVjCtucQcs7gitDjt8gprDjCwTIDO5lpsJYSrMGzQgRn6Z32l9bU7OHnbPmzMWULpYFlmgKzp654IchEQq90+D89dBfQgKpUJfBAcmmBmuGlfknCXSEYsrjhXdLLQv7ZIGjX8Kigu/AwqkgoQw4iR9XuiAg5EMJyB8ix8dzd0r5A6iyopmG
 cuo4I51U
 NaqdOoqO6ew91ILpchj/8EOcL79Drd6/HQvjpuBY53qyJYEyfahL5Tg52mR3EwcOL6hPk9FrSFAmV+Z23rn+rG+QRcP3YUVas4PgdFBneKbdkHVntRrGRSVKowJHNXUXrGvJwA54Qx5mZH2qbYgBtSuES/JbOzRip/TUoZpLPHt0XF+izd5kTABAKtBTzjTK6815+GlP3mlsYByyRxQmpY/y7aBoxlNTNLkczrJSL9g/gHaOtoBa/gfqdpc/h0zP6Fg2oig13+LaHcdXwwmcf5Q+agRlxBizewvuHbzyHl0b6O4p3cnbvkAb3RC+DLqHQWPg2+flHGMI3CmmRb24Ybv7KLGczCj8EuvBvDvuof+ymniianJARZsvjsKBWgkGpUdv9HmyfqnMJF4KEvgCjVe5REsKiuQ/Uos52Md6xJXptv+P+9jqbk+hWdIfqjmMj4u11McqWiNqI6XPRvJQ0UgVkRIsJMwz2F30y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 12, 2025 at 12:09PM +0100, Peter Zijlstra wrote:
> On Fri, Dec 12, 2025 at 11:15:29AM +0100, Marco Elver wrote:
> > On Fri, 12 Dec 2025 at 10:43, Peter Zijlstra <peterz@infradead.org> wrote:
> > [..]
> > > > Correct. We're trading false negatives over false positives at this
> > > > point, just to get things to compile cleanly.
> > >
> > > Right, and this all 'works' right up to the point someone sticks a
> > > must_not_hold somewhere.
> > >
> > > > > > Better support for Linux's scoped guard design could be added in
> > > > > > future if deemed critical.
> > > > >
> > > > > I would think so, per the above I don't think this is 'right'.
> > > >
> > > > It's not sound, but we'll avoid false positives for the time being.
> > > > Maybe we can wrangle the jigsaw of macros to let it correctly acquire
> > > > and then release (via a 2nd cleanup function), it might be as simple
> > > > as marking the 'constructor' with the right __acquires(..), and then
> > > > have a 2nd __attribute__((cleanup)) variable that just does a no-op
> > > > release via __release(..) so we get the already supported pattern
> > > > above.
> > >
> > > Right, like I mentioned in my previous email; it would be lovely if at
> > > the very least __always_inline would get a *very* early pass such that
> > > the above could be resolved without inter-procedural bits. I really
> > > don't consider an __always_inline as another procedure.
> > >
> > > Because as I already noted yesterday, cleanup is now all
> > > __always_inline, and as such *should* all end up in the one function.
> > >
> > > But yes, if we can get a magical mash-up of __cleanup and __release (let
> > > it be knows as __release_on_cleanup ?) that might also work I suppose.
> > > But I vastly prefer __always_inline actually 'working' ;-)
> > 
> > The truth is that __always_inline working in this way is currently
> > infeasible. Clang and LLVM's architecture simply disallow this today:
> > the semantic analysis that -Wthread-safety does happens over the AST,
> > whereas always_inline is processed by early passes in the middle-end
> > already within LLVM's pipeline, well after semantic analysis. There's
> > a complexity budget limit for semantic analysis (type checking,
> > warnings, assorted other errors), and path-sensitive &
> > intra-procedural analysis over the plain AST is outside that budget.
> > Which is why tools like clang-analyzer exist (symbolic execution),
> > where it's possible to afford that complexity since that's not
> > something that runs for a normal compile.
> > 
> > I think I've pushed the current version of Clang's -Wthread-safety
> > already far beyond what folks were thinking is possible (a variant of
> > alias analysis), but even my healthy disregard for the impossible
> > tells me that making path-sensitive intra-procedural analysis even if
> > just for __always_inline functions is quite possibly a fool's errand.
> 
> Well, I had to propose it. Gotta push the envelope :-)
> 
> > So either we get it to work with what we have, or give up.
> 
> So I think as is, we can start. But I really do want the cleanup thing
> sorted, even if just with that __release_on_cleanup mashup or so.

Working on rebasing this to v6.19-rc1 and saw this new scoped seqlock
abstraction. For that one I was able to make it work like I thought we
could (below). Some awkwardness is required to make it work in
for-loops, which only let you define variables with the same type.

For <linux/cleanup.h> it needs some more thought due to extra levels of
indirection.

------ >8 ------

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index b5563dc83aba..5162962b4b26 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -1249,6 +1249,7 @@ struct ss_tmp {
 };
 
 static __always_inline void __scoped_seqlock_cleanup(struct ss_tmp *sst)
+	__no_context_analysis
 {
 	if (sst->lock)
 		spin_unlock(sst->lock);
@@ -1278,6 +1279,7 @@ extern void __scoped_seqlock_bug(void);
 
 static __always_inline void
 __scoped_seqlock_next(struct ss_tmp *sst, seqlock_t *lock, enum ss_state target)
+	__no_context_analysis
 {
 	switch (sst->state) {
 	case ss_done:
@@ -1320,9 +1322,18 @@ __scoped_seqlock_next(struct ss_tmp *sst, seqlock_t *lock, enum ss_state target)
 	}
 }
 
+/*
+ * Context analysis helper to release seqlock at the end of the for-scope; the
+ * alias analysis of the compiler will recognize that the pointer @s is is an
+ * alias to @_seqlock passed to read_seqbegin(_seqlock) below.
+ */
+static __always_inline void __scoped_seqlock_cleanup_ctx(struct ss_tmp **s)
+	__releases_shared(*((seqlock_t **)s)) __no_context_analysis {}
+
 #define __scoped_seqlock_read(_seqlock, _target, _s)			\
 	for (struct ss_tmp _s __cleanup(__scoped_seqlock_cleanup) =	\
-	     { .state = ss_lockless, .data = read_seqbegin(_seqlock) };	\
+	     { .state = ss_lockless, .data = read_seqbegin(_seqlock) }, \
+	     *__UNIQUE_ID(ctx) __cleanup(__scoped_seqlock_cleanup_ctx) = (struct ss_tmp *)_seqlock; \
 	     _s.state != ss_done;					\
 	     __scoped_seqlock_next(&_s, _seqlock, _target))
 
diff --git a/lib/test_context-analysis.c b/lib/test_context-analysis.c
index 4612025a1065..3f72b1ab2300 100644
--- a/lib/test_context-analysis.c
+++ b/lib/test_context-analysis.c
@@ -261,6 +261,13 @@ static void __used test_seqlock_writer(struct test_seqlock_data *d)
 	write_sequnlock_irqrestore(&d->sl, flags);
 }
 
+static void __used test_seqlock_scoped(struct test_seqlock_data *d)
+{
+	scoped_seqlock_read (&d->sl, ss_lockless) {
+		(void)d->counter;
+	}
+}
+
 struct test_rwsem_data {
 	struct rw_semaphore sem;
 	int counter __guarded_by(&sem);


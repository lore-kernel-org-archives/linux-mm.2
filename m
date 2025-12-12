Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CF79D4415F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 10:16:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D2BA6B0006; Fri, 12 Dec 2025 05:16:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AA0D6B0007; Fri, 12 Dec 2025 05:16:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C0456B0008; Fri, 12 Dec 2025 05:16:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6E5246B0006
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 05:16:10 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 14FD58A8AA
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 10:16:10 +0000 (UTC)
X-FDA: 84210413700.24.D543CEE
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id 356201C000F
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 10:16:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=spMUWl13;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of elver@google.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765534568; a=rsa-sha256;
	cv=none;
	b=Ct+0zADq9F+/XMZ7E1Zfl+5yiE6CH7hWNhT6lErLMB9Rr2h21ff+gWNdxfo73fAhWQOoRL
	2Cg3uw3IPJKhxUXkKK5dEhwB7ikTUzj/2MhtX1kw6XNd6U5W6Aa/eHdBNeWzqP4kcjnzZ4
	68qee+VTp4IW5vQtmGxa0pVmzFnJFqw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=spMUWl13;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of elver@google.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765534568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yy8AVUr1WzoEhC0gwViTyIIecU1pDeO+TdO72jBT6kg=;
	b=DkKBsEgyNoYgeKRbhHQdWkxEwIZWaezEOC7sItA42I4ibIaIwM03pQcFXSE6YC84cC7CmQ
	rKqZHEge4E42ZjTDrY/nbj61gBcpuKLglSqZ/6FmXouq7tiW5+1BZ2z9QP1cp05hjCvzFj
	qHplNupAVNsiwDPSYe9HZMWOV+HEWK4=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c03ec27c42eso635440a12.1
        for <linux-mm@kvack.org>; Fri, 12 Dec 2025 02:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765534567; x=1766139367; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Yy8AVUr1WzoEhC0gwViTyIIecU1pDeO+TdO72jBT6kg=;
        b=spMUWl13Y6I3laBCC7i+8RD2Gc8yIeqtrRkIzzKgXuV7spIRpBhHeel8IrwcpCTv/F
         YQboWuLkem4fOLS9RgE0Ehd6S3QqNIbe3zZTlK62OtOkZOdVa5kSn1xeK+cmXc2Zbx6+
         NpU/Fky+6x/ozxwjgoHdYaql+PZYtRfuRE5J/jOVtAiH2+w8SlLdigZqDkkKUWt7hDlE
         AeKX2eKbWaji2qYTlky3ocb9P9QyxmBh6nq7Ox0CdMDELqYbQN6nsj6BqMAxwqK18c/c
         KyPG7hngRSI2Wdk/6M7kPMSsWNrUuOciukC+a02kvsCrV85c0RoLVSTwfUemDU5bx7U3
         eDEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765534567; x=1766139367;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yy8AVUr1WzoEhC0gwViTyIIecU1pDeO+TdO72jBT6kg=;
        b=fZ8IzV/hX4vsvMFQ+ejIAZ2FCmgowF4b9t9OS22IA5gCuoyYl0Zvlh18yqmAQ3u0Un
         kT1wzeCJmQ9PuSVnBiYDqCSZnyFVm+JjIDe855Wk3k2/sFRswFwQs8sH29g3Ip+DLoR+
         AG8vE36UBY42rQN5EZGKOXsyJa3foQw99CuIfbhtsElHx57RpIKXukoBup1hR1HTc3NN
         yL+oU4u86gFGsooZKu7Wi60PYhpXUwHRGqspkU+s09exT3oMLP3TGbnFDRrvQ3pLhrHJ
         d4xyMxBhDLNc4+q8zcU1JsX8s+hZmLgeyvdR5hCZ/+hT4dmloFCsphdZxRpX2wkVJCuV
         j4iA==
X-Forwarded-Encrypted: i=1; AJvYcCWRuG7YdIGXlmgZ6sb8w6jfG+eEh7eHza8DLa2nesE/eXiTiMWIid8pMSRGS1l8rgpv1u45BoXMBQ==@kvack.org
X-Gm-Message-State: AOJu0YzSJQFrJlcci3kfSKSyrQEE4uMsdIycOTWWCVGj9JtqvaB4uNn3
	Y47NJ1GOyNQr6jIJ1vC6XIOVJeSxJDWWhbWW/wu1QPND5VtgT9cHrkNGrP0XBOIy4rhNWbc2p93
	iVUZvnpLTBopxOpnibFlOHU8skqHgfdg+PoqtHLV7
X-Gm-Gg: AY/fxX4FdPqHujJEg0ieFB1QIR4Z/vvzV28r8wtpZ2YrPLtAKZwfaekdMqvtqHFtLy0
	u88OR3XeSwMkw1YBCLxVlhaqE7/10kOhMmt6Ctr5CEw70wDCPx6tuSQCptFH51hVErAIjjXHJPf
	eyuMVtT8KTYp5Gf+Usu9Yb5+DPsB1ewv0B3P6gQbphi3i1iWJwuUOUnPqr/CDqCsJf2x2TVMQth
	xcINP9ktqU4dS9hPvt9f2XMgVO+KMqbwDvh6Ry6WzQspygseTEoYCgD6e9tdBzkHAKH9iZ4dgrD
	SYJeE+H9s13WlAvVoV5m351Hnri+oiHEHNxjzQ==
X-Google-Smtp-Source: AGHT+IH8fq53xzz4VEeZIfjpPn2aDZft0vSRUPpE08Jgar7Bwxv93jAlmI/oD2Bc5sYJ04yKuPnrNx+rDd5kmEFlwB8=
X-Received: by 2002:a05:7300:2aa5:b0:2ab:ca55:89b4 with SMTP id
 5a478bee46e88-2ac303f2fbcmr872533eec.43.1765534566419; Fri, 12 Dec 2025
 02:16:06 -0800 (PST)
MIME-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
 <20251211121659.GH3911114@noisy.programming.kicks-ass.net>
 <CANpmjNOmAYFj518rH0FdPp=cqK8EeKEgh1ok_zFUwHU5Fu92=w@mail.gmail.com> <20251212094352.GL3911114@noisy.programming.kicks-ass.net>
In-Reply-To: <20251212094352.GL3911114@noisy.programming.kicks-ass.net>
From: Marco Elver <elver@google.com>
Date: Fri, 12 Dec 2025 11:15:29 +0100
X-Gm-Features: AQt7F2qb9ENq_mtkRfqCrKNBJnxHOwKNFDuSBIrcF4bjbeWckbG0712gmoUp-Ao
Message-ID: <CANpmjNP=s33L6LgYWHygEuLtWTq-s2n4yFDvvGcF3HjbGH+hqw@mail.gmail.com>
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
X-Rspamd-Queue-Id: 356201C000F
X-Stat-Signature: sn6uaqyn95rckkykgng86dpoi5ghi5od
X-HE-Tag: 1765534568-990621
X-HE-Meta: U2FsdGVkX1/4p+L6oB2ZKPSkgN4mLeb2P+KKrh94YAYIiEj2UpD3dgszFATd9XYhHtFWsXDtcbBSmx8QAQBT7HBpK3BUOC6+zJn0601qTYzgvoISl3Glt5A42rWYJaQJK/K4EQIzNaFqMlv+z07OxbPKMOD77WxXULUfjvgdfhhcWDVGgjQ8XPaesYKn1xPF3zj0IxypYvYVF1PpgWHYqMMRJQgZbRqocRaeR16yUEmbGiFi2waPPTdHN+7N2Fy4hJ2OmfdPDVlLszaTSlBzH9EEsUMNxsaRDJQ5+LM9rRNHDJsEf/zpG/bHwHM5WB3YkoN4CJwnFEwGJ/RGUOMjoKRUxtoW3pvU4pNXCkgur1mvxBtS4CzAScWontinGjte/Xu3LoocsxVylUQimZMH0K+7fuVKYqyUH8yljNBvStT99TqLBrsxQxV1zcG7tYzKYl/dC2xJgQcpO3lp/w2Ki/pAVGxJmFDZ5nR7XuVN9tvR2IMzXG/WMb6hJ7Y8y1IUMPcSPgugueDlWrutObVG/m6J+eXbAQGiVo9YwnZqOf9StzAxrEW5jAN4wq0ywPLCnLwACwoKMXQ4A51SsGcEAJx5drWlD2TaJ5i8mcUDTlPCFwNNQDLXwUOALxrlOK71zQSEIIt5m9sBA1sqe3M7Qk/itUhc0M48I34J0eQJaehXQO/RZ0hf7aSMjdVdcIK/VoIcr/P/PkHM2IxqtivJJB3Z1RsJZZ2dmLVvotRFkB/QZzJkdHO3NtnwGJlH8YgS7tGPoNLAcv/6ZRzrVLvExXeOeEIKjU4jnFM/IIO1CrCB6cXIl0ASh+d0dg2Qyw0u25/q27ZdvzaM2lqzNG0rPs688EfLMTKOBIVws+KJGDiL2TM6jDlK06OeVmlQNi8WokjQrbCX1oKGldrb19LU4cr4UaR5SnQ4M6r3PHLa8L0AFcIjIpcj9CAjepIQ0g2SP7WSZRdDU2oDiAxcUCc
 cxPM4ukF
 SAOcVvtyXAZvDAyn/rBRkla0xL1k/VLA7CtZTYUCKR7qwJm7aifqKePH28Sx7Ev2shG3bcfV5gbxhoGqgJYN7GJcCkv05HoE9Wvl+kqO6fkOq7y/bysIwVrA67gVjzkJjxBJLbgx6Mr3RQs2YG+A6sIVzpLik+ZHQjhVc+gdN3tETfbD5GZf3tm/8J21V0A3V1ZM3BpMt5fEEyiiLGrHkA4ylEwApyKDUOmGOEFLbHfmmZ6yQKk1/1UDXmMPWawCnwhBHeFvrz6+TQqXHaVwyUBhxqHAOhNXWkjhixW4crVKC9bCKDuNLF3F6PtleoF5qC/CT2hAT+XccmdU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Dec 2025 at 10:43, Peter Zijlstra <peterz@infradead.org> wrote:
[..]
> > Correct. We're trading false negatives over false positives at this
> > point, just to get things to compile cleanly.
>
> Right, and this all 'works' right up to the point someone sticks a
> must_not_hold somewhere.
>
> > > > Better support for Linux's scoped guard design could be added in
> > > > future if deemed critical.
> > >
> > > I would think so, per the above I don't think this is 'right'.
> >
> > It's not sound, but we'll avoid false positives for the time being.
> > Maybe we can wrangle the jigsaw of macros to let it correctly acquire
> > and then release (via a 2nd cleanup function), it might be as simple
> > as marking the 'constructor' with the right __acquires(..), and then
> > have a 2nd __attribute__((cleanup)) variable that just does a no-op
> > release via __release(..) so we get the already supported pattern
> > above.
>
> Right, like I mentioned in my previous email; it would be lovely if at
> the very least __always_inline would get a *very* early pass such that
> the above could be resolved without inter-procedural bits. I really
> don't consider an __always_inline as another procedure.
>
> Because as I already noted yesterday, cleanup is now all
> __always_inline, and as such *should* all end up in the one function.
>
> But yes, if we can get a magical mash-up of __cleanup and __release (let
> it be knows as __release_on_cleanup ?) that might also work I suppose.
> But I vastly prefer __always_inline actually 'working' ;-)

The truth is that __always_inline working in this way is currently
infeasible. Clang and LLVM's architecture simply disallow this today:
the semantic analysis that -Wthread-safety does happens over the AST,
whereas always_inline is processed by early passes in the middle-end
already within LLVM's pipeline, well after semantic analysis. There's
a complexity budget limit for semantic analysis (type checking,
warnings, assorted other errors), and path-sensitive &
intra-procedural analysis over the plain AST is outside that budget.
Which is why tools like clang-analyzer exist (symbolic execution),
where it's possible to afford that complexity since that's not
something that runs for a normal compile.

I think I've pushed the current version of Clang's -Wthread-safety
already far beyond what folks were thinking is possible (a variant of
alias analysis), but even my healthy disregard for the impossible
tells me that making path-sensitive intra-procedural analysis even if
just for __always_inline functions is quite possibly a fool's errand.

So either we get it to work with what we have, or give up.

Thanks,
-- Marco


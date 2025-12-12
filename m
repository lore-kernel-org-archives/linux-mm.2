Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5BEED44166
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 10:49:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28ED56B0005; Fri, 12 Dec 2025 05:49:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2189E6B0006; Fri, 12 Dec 2025 05:49:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E0BF6B0007; Fri, 12 Dec 2025 05:49:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EAEA56B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 05:49:10 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 96829B9A29
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 10:49:10 +0000 (UTC)
X-FDA: 84210496860.10.3F0EBD9
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id CA3A0180008
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 10:49:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=e8IFWdZh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of elver@google.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765536548; a=rsa-sha256;
	cv=none;
	b=rcDS5ttW7PDbvdxHVFWG3YQSauFjeUukvXsjhpWOWdjKSwj4PAWpveB47gne6Ec+Dl3YnO
	ROKjf8BImWgpRF1TCUNuxnFd1PhGoV0fE+3GD6fj0+SIZlcQbsa0cYC164jAlSb0MQR2ua
	mLEbFJeCtsozIcXngFo5l8IoXzhTjMw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=e8IFWdZh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of elver@google.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765536548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SA48npp6esm0XDSNny8uE3VVilMK0KzCGLSxi6mYbKY=;
	b=i/cbfpheCdadVhJcLasnI2I7MjByQ4V40uslv57L5Y82rUOo9BMDA4ypQE0g4PxXJYVHni
	WODmqvjBpkSi9hS0nVRF4CicpdsR+hhpl4v9E5TTf9CGNvJcLhE5DIABJPD3IjE0aRV9qi
	uH+BZdb6iBLCG2zhN9Guy0KgpQPf3BU=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-bf1b402fa3cso1033856a12.3
        for <linux-mm@kvack.org>; Fri, 12 Dec 2025 02:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765536548; x=1766141348; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SA48npp6esm0XDSNny8uE3VVilMK0KzCGLSxi6mYbKY=;
        b=e8IFWdZh9QPZkR050vvPd5BZHmLKVxPqZVeB/4bAgpoXDSEJIRL9igvBE9ylMZaEfo
         bXMe4nobXR0Nzru1FMHMdeUnMkflZHVuIXT2XyAiok+gEheGGcVBVK+p1teIki6r+XWu
         0sUhYaMqV17qrS9C61fCaRSDs0ntoOR/pWp/G9hP2NAVpAWKGTbGaOoVEfYIuB52C+ef
         EI2dgV7WyEKu8hWdgmOQtjIR22IgRpWxqgCMxwjEF3xfNVqIg+ZYTsHhstjedEohmLnS
         HADFm0P4VwHSnYcQV6TQsZzhMNfo7PWyhynQ6O+edL3N0sS+/VBd7aI6vs+UVKUbcg68
         FRog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765536548; x=1766141348;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SA48npp6esm0XDSNny8uE3VVilMK0KzCGLSxi6mYbKY=;
        b=ng1HON8nomJJTggGX9aupB1u7C2yRXojXL5dFJDGVhf/jO0pw5/8WE0F4xnmjZS5oh
         5WXCQeGJXnGmcNeXgZ9DNa4T4e8oi24txT6bCqIWFAALtO3h84F5PZKEeo2V4ypcmuw5
         wzbbG53EZCKZ/XOCkCG6zg1elgc/FkgaQd0HdNemKqmbj2gVc3Z7m2/ThGlbwI20BH/Y
         fyXLFRR9W2mu1dyRYHHAiMnuFuxcQKVQSFgmL+ycwoqe5xDBgtAU/XSJ4dgCKGPTBqgn
         vvL/Q3BmM7DV5oN/pvzUVN5kXlAhjzHwv//NmTWWQyRTgt/0t+OTitwYBjnGPwlLgJ8b
         Nkxg==
X-Forwarded-Encrypted: i=1; AJvYcCWRFL8hYdlXbTgntmStW/VTJbM3dHhWbFGb5obIS0HX7Q7v5MlFcOoHkvpvBMSWhE9NzuKa5xYAXQ==@kvack.org
X-Gm-Message-State: AOJu0YyC8kEmYbhrHCOaM8XNxKnkSWE7dw6JTILZ60qlRJ4SACuMsvVb
	ft4hR2139+o15KUf49pLYV+wD3LWJQPq7GStIk1TVNyFWf559En6PJ3XgDtVNJJT5sedkcuNj1g
	0e9OWPwXV4ioXMmi8ymS0Arm5qCM5knN9+zyyXMu/
X-Gm-Gg: AY/fxX5GEW24LMjrZ4RO1U1U1Cp5haG3wm/NsWePOnPlTEEveHUXHvvWRLs+FhRhT+j
	vy3RNrP4hC+B0+qBIaPst2mdsawJKs9p82I1E0O6HBj0cxjFuSQnucNd3m2feDNZU0nEfR4tARs
	IA+hTpOFXC4aTausxK8HCIJXzjALInjMqh3F8UPA9BwGlSdaTS/XdP5rGFUx+4eLoBoCpFZ0jL6
	L8yytr28MEzTjQnmvg8oLj813EJpf9GOJL6h2Vroa+Z44vt5/m7wtJrmt3YSwM+RccXhCLN5Eaw
	i4m39pVxa4IGf6eUImAxxN5hw48=
X-Google-Smtp-Source: AGHT+IEmwt/cYGSRMcLEQwRoz4IOBPZmG6ZdFUXvSQgttHHtD3I/ZoiZY45lTyY+63ShMc7m2jk9oXMIHs1yDaFc4yU=
X-Received: by 2002:a05:7301:6781:b0:2ac:2e93:29bf with SMTP id
 5a478bee46e88-2ac300f946dmr1219192eec.22.1765536547134; Fri, 12 Dec 2025
 02:49:07 -0800 (PST)
MIME-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
 <20251120151033.3840508-8-elver@google.com> <20251211114302.GC3911114@noisy.programming.kicks-ass.net>
 <CANpmjNObaGarY1_niCkgEXMNm2bLAVwKwQsLVYekE=Ce6y3ehQ@mail.gmail.com> <20251212095943.GM3911114@noisy.programming.kicks-ass.net>
In-Reply-To: <20251212095943.GM3911114@noisy.programming.kicks-ass.net>
From: Marco Elver <elver@google.com>
Date: Fri, 12 Dec 2025 11:48:29 +0100
X-Gm-Features: AQt7F2qCLUKQusRsTOkfVyHaXl__KgFtQ_SoVZmDpwKuRXcKmzXhASdee3aZVrU
Message-ID: <CANpmjNMY55ytuWPh15O-tTe5zEQx3AN6LqrvB9NJ6dm6BsPnsA@mail.gmail.com>
Subject: Re: [PATCH v4 07/35] lockdep: Annotate lockdep assertions for context analysis
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
X-Rspamd-Queue-Id: CA3A0180008
X-Rspamd-Server: rspam03
X-Stat-Signature: peraiqyt9ax3gezjtarbech6ozksrm8q
X-Rspam-User: 
X-HE-Tag: 1765536548-634343
X-HE-Meta: U2FsdGVkX18wFynNItfg+A0Zg/AFyI01F34YNyU9E6zm4VcK8OBJLQr6233wuR6r3Zb8cMLTOg0DSRYwrCXy55b9f6akIVXBKCamkm6w4PPjl6mOM1JrmK4Du2duMTeLRVoEDbWulUVZTBhbN+2KH0HvdHUlWmSWFY1f3iQMZN2P9KHmt+PDpSQaSbUxg9k8oi75JiKNeHBDFJdO9wLaZyU912oUm6WKkNQnsysIgNuwl2s6nz+fdbyuQBijT6R6OUGkSdTS9nS3OPrC2dVrK23XL0XksUiYMJqOlML9u1GpOsQE0mmq6r4Jz5O3wGjKfAjS0/Orlkrb3VMJnjsf7ef1dDMw4xIDjTgd+XkD2i7aNwfPZlDXIl4q91qaWqcvd7ISscblWIA7gN6f/5k4Rr0yBzs0jvuR7e+BwMk5raIqlU26XSjaes18Trb0lke+ZNE5a0KErQI+g8B8trPKj3zIicrIlH/WTfKB/6dh1o/O/cULO8JnufIzh7wBghG+lSCW5/pA9WXEHpMjx43n+lf7B5Rj1jREsVBdtoc+nQmefGyoL0biDKGzhyM8UI1vDdvcoISQqD3vvrHr60yLKbSevvLZEXTXuLSHooDmTzgkE1dk3lEnBw55ucwrcfccSRs8fBq+E2htBDM92wnD+VVEwn/U5mKAW4Zw5QSYbqG4413nWElqEywZn3XtPuKz4tHgNKZzVNBoTjYNkRDJo+fTMm28Rp84zzZWf93VmjZNot4xGKsmaRgkUqUAUyLVU9I1c2Gx2Qo4g6yx5nTWd6OB3LzgCGDMsSpaz5Xf4Ms1XrJy4QGkltgCxZj4Nzh/WQiADV30Xx3HopmGhi6gY+ON7eRf/OjUjSsdeMQUGYYXqkxQABnyI2uJZahG089oX+JUre7EdRrHajqGj5Vf/BWpvWkndIN1zykgY97gojHtzplxIRHqLz3lApuPjTQJoDjuDA+p6xXqn+WBI68
 nzqx+Ed5
 8Jme6rmCHs29Of3xqCFb1ZuHlwjRdLt0Lmxyxcqe4DBU0afME0nR8xtMt3TA2PVyr1nmctgwCOgS04z57xMoLC0V8H9tMSnJtJdxOXMFrtd7+NvR4smEmkUNFHEYvZYHqd4nfOe+DWeuMifunWzkfOudz8DhJlljwsVWiiMW/rKj+KGPNkuZNLN2OPjUjkyhiZiy6dZL8EVbCYHD+gy4oppXmj0kGcEAoQkNzH21PHuRKIXPAvdj4KZG+ArvFHizr+gBNhwufaBhuDyS6UFg+MCS655nJSK9WEiWO9TD6kZkdj0OXDxgLLzZi28dw7k+MuNkVkKfx5UsXHd8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Dec 2025 at 10:59, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Thu, Dec 11, 2025 at 02:24:57PM +0100, Marco Elver wrote:
>
> > > It is *NOT* (as the clang naming suggests) an assertion of holding the
> > > lock (which is requires_ctx), but rather an annotation that forces the
> > > ctx to be considered held.
> >
> > Noted. I'll add some appropriate wording above the
> > __assumes_ctx_guard() attribute, so this is not lost in the commit
> > logs.
>
> On IRC you stated:
>
> <melver> peterz: 'assume' just forces the compiler to think something is
>   held, whether or not it is then becomes the programmer's problem. we
>   need it in 2 places at least: for the runtime assertions (to help
>   patterns beyond the compiler's static reasoning abilities), and for
>   initialization (so we can access guarded variables right after
>   initialization; nobody should hold the lock yet)
>
> I'm really not much a fan of that init hack either ;-)
>
> Once we get the scope crap working sanely, I would much rather we move
> to something like:
>
>         scoped_guard (spinlock_init, &foo->lock) {
>                 // init foo fields
>         }
>
> or perhaps:
>
>         guard(mutex_init)(&bar->lock);
>         // init until end of current scope
>
> Where this latter form is very similar to the current semantics where
> mutex_init() will implicitly 'leak' the holding of the lock. But the
> former gives more control where we need it.

I like it. It would also more clearly denote where initialization
start+ends if not confined to a dedicated function.


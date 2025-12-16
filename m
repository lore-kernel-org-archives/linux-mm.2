Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E14B1D5E14E
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 13:26:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50CF86B008A; Tue, 16 Dec 2025 08:26:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D7716B008C; Tue, 16 Dec 2025 08:26:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E3D36B0092; Tue, 16 Dec 2025 08:26:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 276B46B008A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:26:41 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F15001A0663
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:26:40 +0000 (UTC)
X-FDA: 84225408960.21.CC5EFB4
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id 047AD1C000B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:26:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rLbZ1bIX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of elver@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765891599; a=rsa-sha256;
	cv=none;
	b=znKR6HIheUQ1DFUktG5uQMKx9j5l2NuV9cwe7eYQi9h+smSWqQd4rZYfdtd0cb2Em3S22j
	Kyf6A5PnqTTWrLUxqVwSNzQUhnDjGVLxu4D3cyBIyZlvKgZsxZ0o5zvG5WmSnGqDiMh/s1
	jzyXXFptuQWbYSPS5AieHiwhyfMVu+4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rLbZ1bIX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of elver@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765891599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3V/ozmG0P6zbhJMhekfGn6dV/6uy4a54Tyfq8of8mrw=;
	b=neIiByW9Hmou2YXc4K53LD3/adMZwFCP8luW3/qhHT9AIsA8bbTq25fg5JfJqo5QdsjodU
	bLNEMKUtss+4UrtbxO1UvaEcDZiCAeh27BoQ+XcF73SxkI9tdKMsdX8JKbrmNT3pXys5zr
	HjEJY8IT5T8XRt8u5mLSXPPfBkWlmXM=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6495e5265c9so6971891a12.0
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 05:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765891597; x=1766496397; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3V/ozmG0P6zbhJMhekfGn6dV/6uy4a54Tyfq8of8mrw=;
        b=rLbZ1bIXKDxKu5c71bNX6W5R6VbaAHceaFIQRsK/agv/lusRhZHvd9AdB8SB7Ps9sJ
         RE+z3CzI4FxeEkr1G9CWG5O5HAoxFMKhx39UM43PSuxUjsxXLrSzw9e5s6Z3y8O6zzMY
         wcN1kMJ7miBVd0q6Boi5RjTCUxVa+bUPCFGvD/l9r/6efNDKTWj0Z9fQqzIb/jS7pKoo
         nwXcDzy0g8Li38QqUY4X30gzR0x7e8g1JakyVbp+0xSZy9rCA/CB2mKZIz1d0mggwq9Z
         Jh9mZz04ynhsZmOTCj3rCYE9UaTzH2ALZkXf3JE2iD7epgO5Y+Wimh2M8hmPUO/7aTFm
         4cTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765891597; x=1766496397;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3V/ozmG0P6zbhJMhekfGn6dV/6uy4a54Tyfq8of8mrw=;
        b=XoHjIt7X0Qe8uMk9Lr2zOfUqCyc5zDSI6xXkhWHrHqbvZ2MhaQyG/dkTUepuiTtsv5
         yzTbTDmOgO7yo+p4aVpEtzQcwkgrXEmsO2MKsbWX+PfQ/BuaLiW9v99p+0oVDMj2WF6t
         7Kv41oO6EZtCSqPJpCzdw1ijXHcGm34WvVHWNoF+IcBxlliTc5EbNiXqgdJsA/EuBCsw
         FIGRV4Yg89pIKuDOybo3nof0xIG4wIzeKhoqLhVKGIh7sZqiTRKIHYpzrWb+h5aFU7rl
         WNl7wuCHiDvtBcncDM6RvPJHk7M0vCzMAwuMfiUMQmSDMGQm/9XZ/KfjnbPuH6zZBn62
         XMoA==
X-Forwarded-Encrypted: i=1; AJvYcCWDqCN72s77zB72A1F4XKr941SEZe/hr0RJqpbvzIftFcFqX75RP86ifogDCKhcXj6h2wySSBubpw==@kvack.org
X-Gm-Message-State: AOJu0Yz+TFUax8W2ERTGNdOAhmBl4PyLgprWElZQy53cPmlvXd85eVPv
	7QKZabBBAW5M9i2IrsrE/BA8NJlQRwx4a5KM3H+PRHX77WSs82R2AFL78gMbF3ryeQ==
X-Gm-Gg: AY/fxX6EL0/oYn+IzEg5KZMhhpusY72kmG/3Feb4apATyGLF7w/8OY4G//HYmTMqh/Y
	nTKI++cVDmGdWHrQTFn7ssJI6QZVslWl16h5BOpj36FC5/CwI4c9qdxPMemKHH/4irE5TaJj8v0
	Zt2JkPJ0iIqJ4THqO9SLWwiFDKac3ZpuNjpgR9FFq3rZD2ngkeX7V5vGOIjSglWGCX7TMmNhc7a
	G37P686l93yGC0NGjtlVpN92WQM4+STuI+NJ0CTisR0OJUubS2TvRxBI9phj/BHOLnw57Aj84IQ
	sQHB/9/OGQViy91xOnKMW6f47rBgt940FZlzc/80y4R1+9r2R556mcxdjFWlGz1j580me4p6hdl
	7cmoM09bsU0NE6eyadiXIvCYCxg9DDCCj/4BOAFq5kTCQ5wjqPHZGQWu12rrJZIKuc5cOjUMuJT
	lbNYh0q5U4QC4x2/Dpr4NOtfy08pW4paP6LzypTI1RT8B1DvD7
X-Google-Smtp-Source: AGHT+IEXN8c4l2W138SpFxaraGM3jOuuGwcwQYafzXlaDOwN/Hd+sEz4uwdMcyiAnZ9D77N2tR3XDg==
X-Received: by 2002:a17:907:72c7:b0:b6d:9bab:a7ba with SMTP id a640c23a62f3a-b7d23a97591mr1453601666b.42.1765891597176;
        Tue, 16 Dec 2025 05:26:37 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:2834:9:ea4c:b2a8:24a4:9ce9])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7cfa5d0b0dsm1693444566b.67.2025.12.16.05.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 05:26:36 -0800 (PST)
Date: Tue, 16 Dec 2025 14:26:28 +0100
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
Message-ID: <aUFeBHuBJr-Y512D@elver.google.com>
References: <20251120145835.3833031-2-elver@google.com>
 <20251120151033.3840508-7-elver@google.com>
 <20251211121659.GH3911114@noisy.programming.kicks-ass.net>
 <CANpmjNOmAYFj518rH0FdPp=cqK8EeKEgh1ok_zFUwHU5Fu92=w@mail.gmail.com>
 <20251212094352.GL3911114@noisy.programming.kicks-ass.net>
 <CANpmjNP=s33L6LgYWHygEuLtWTq-s2n4yFDvvGcF3HjbGH+hqw@mail.gmail.com>
 <20251212110928.GP3911114@noisy.programming.kicks-ass.net>
 <aUAPbFJSv0alh_ix@elver.google.com>
 <CANpmjNNm-kbTw46Wh1BJudynHOeLn-Oxew8VuAnCppvV_WtyBw@mail.gmail.com>
 <20251216122359.GS3707837@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216122359.GS3707837@noisy.programming.kicks-ass.net>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Rspamd-Queue-Id: 047AD1C000B
X-Stat-Signature: ofco9mcjigsoxr55zkjw68xh1hxxh4uw
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765891598-341808
X-HE-Meta: U2FsdGVkX1+LdFl89moYFuVRmHigJCMxJcwhUP0FaBzc5TYbWWyWAGuhSd7BmbB51GvcW+KXFd2/9xrRoJvlIz5RpJDRL5PcEh379Q87ZJyLDd1Bt3GDPjWYqNwY64mKYa34xmgIolIUAycz87z/oov0WeSLQ2fTmXu7w/qXfL7JZciMPntpKuwjMKJrq1EcIr8tAq2GzujGyDixB6CJPgX5GvD7RQ2agOFtq+z1vrQaT/thMHa8boVIro1d+O/AXHWO9W0o/4TctB7QNKfOkiIOsSnfkJZuBr6nUDzck2efQTXEzcAujGMT5KqGj5KTMNhJwswdzatDHQDY/HQvPnGSey/UqEtH29Z+YwhgmpZKFAfda2cdz4PPdC8oyQR8yl2yWJz8cl5LcBC4j/wefBP2eIlCI0vHdna8uKrqmg/IjSYTlrYFZzYNzpJNlOgU6SMybP5nTQKVectOuHj6V5l5mzAX/XrYpyg50RRrNJrVOKk3QXgXC8faC07zUMAO+j7sOTsNhRd8yYaYx/G8JIT99i2cdmVnBYVtjGbiVi/rv84udH5ESaK8OAgv+OKGWD9bkYXUt+rlSHdVkauRiQLwq2zC1A3lzNp/0n6yZYHkxH/U3hJAAcTva3kZoqR0KkzjLNKktaKCKJuzHIYVyvtAivgw+oZzXGv5uRiqSoLdFdrXZifmwAMeppu+GvfWyTZBsXIEaHTNYabM+OD4Qn0b9w7DMGpz4fCtJzwKn83aJb5rC62xahYSMq4bz69kDHbb1ojLfOSj58A0SCqf7I+cspfRS+cRRcfnHrUMrbV/4rxgU2Hdwe6OyWoE8pp/JCrjP7K4e6721Bz8uDr3mC8CDjNxdJvy2p0kLa+D5sWpq9StBsF5WDhVVlMWay09/XHX5tCpVzqniHqi97CQJPFsZje7oTs5TXokaB+5XX9gqYVPKocg2IflGqPCbBmoJzz+mQfukEYhELrY8DP
 b3h5Y10q
 sN1rSkxsSXziQI+XMAyLKFj78xpxcH1xsMYppZiLefpkzTlezp4+1Ff7O8NMnGcX7OkVpidToQD6Ts38MszoJT4VjFqrJqiZBtcYNbU3O8AyHYxeQNhl6MyPz8RPRj4xvONyP3Y5Frk6DAlQyWLBPA2jlthutxpNkbOi+6kwqWZzFX7UxBQdjr1Wpa6mxeZyFeWK/TTZ4oaavi9/HPhMMB8xMnEbVsp7V8CS3OmYzHjgF8NTSvwbOqLzU5Onk7TOb0SE/cxNHqvCNyHgOl1VDO5fJZFwaRrDql7xztf5YwViUjuoF2RN3Jf/1rQ9I1X1fwMn86HJKoaVXHvh7fh5vUQ1Z+Pmh/Jl8DCLW9fwxYsryEybM6kkH76BSY5mgeafbUlFHygxSTOQiWy7T0NBIrZzhNhzRQlvACWJtDHKulw7V3HsCil6Kf/drRg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 01:23PM +0100, Peter Zijlstra wrote:
> On Mon, Dec 15, 2025 at 04:53:18PM +0100, Marco Elver wrote:
> > One observation from the rebase: Generally synchronization primitives
> > do not change much and the annotations are relatively stable, but e.g.
> > RCU & sched (latter is optional and depends on the sched-enablement
> > patch) receive disproportionally more changes, and while new
> > annotations required for v6.19-rc1 were trivial, it does require
> > compiling with a Clang version that does produce the warnings to
> > notice.
> 
> I have:
> 
> Debian clang version 22.0.0 (++20251023025710+3f47a7be1ae6-1~exp5)
> 
> I've not tried if that is new enough.

That's new enough - it's after
https://github.com/llvm/llvm-project/commit/7ccb5c08f0685d4787f12c3224a72f0650c5865e
which is the minimum required version.

> > While Clang 22-dev is being tested on CI, I doubt maintainers already
> > use it, so it's possible we'll see some late warnings due to missing
> > annotations when things hit -next. This might be an acceptable churn
> > cost, if we think the outcome is worthwhile. Things should get better
> > when Clang 22 is released properly, but until then things might be a
> > little bumpy if there are large changes across the core
> > synchronization primitives.
> 
> Yeah, we'll see how bad it gets, we can always disable it for
> COMPILE_TEST or so for a while.


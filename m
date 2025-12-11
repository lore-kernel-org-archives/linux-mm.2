Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A94BFD41C27
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 11:43:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 997A26B0005; Thu, 11 Dec 2025 06:43:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 948C96B0007; Thu, 11 Dec 2025 06:43:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 836E16B0008; Thu, 11 Dec 2025 06:43:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7278F6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 06:43:29 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 28947140870
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 11:43:29 +0000 (UTC)
X-FDA: 84207004938.01.DCE6AAF
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 77B6A1C0012
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 11:43:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gC2D4Nn6;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf20.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765453407; a=rsa-sha256;
	cv=none;
	b=UBw4hJN6kuJmwNeHrCLe3SYRQh///W7HqADkFrG431dL61bY+SRN9TC2axa2owstvXLXyh
	RdD8QcuetOIYA7xdh+ska3VvYa3DfZOR/uzrK9DsbBrbE2ZPoJE2NU36vlmq7erQgXigbR
	h4CTRrhz/B0eQXgDHYzGfL/S9YjVT7g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gC2D4Nn6;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf20.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765453407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uQ1t1in3MNz+55jGFoFlKgze5NqUmk6ITua4X7r2Yeo=;
	b=BqDE09GnKplGqG6uhXFU3FGjp3LFc1LOgROzToHchLELxw4aUU5n8XO5vfllxliYSVt3MY
	1QuQnavAVjSYaTL54baosCjyMnLsYCBbUdKfF9f+DXP331hK8UN3CMj949TX+FH4e870oL
	gtP7vU3Z8WLeYIXzR9gcbrtEiD1Ecm4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uQ1t1in3MNz+55jGFoFlKgze5NqUmk6ITua4X7r2Yeo=; b=gC2D4Nn6TBsE1we2zbHDdyJ5qr
	5r1+OVFGLSNem72JBqMo7iaGapPFi38ZsC431uA0Y92pG++DHkKwM6qgaxASR7JF02WkWrLSxu5+T
	N3/tUOuTVCAuPcWK7WW4QJzL5miwWBfBEAMHMwQukxzLV6StP8KclJid86BDcgk1KFVqtTOelz1kd
	TolBaeGejJh9I7Y8FKRhnFLoXnHKynMZ8pOcGBXC/qbeFfGKC2iBQZuL3ekazEAAlTEOBWJm7fS8T
	J3o7cDROPeRxtK+aKww43zCeRFqCeJc5r66NPdNWBNRSxKG6yWR1CYSIMJYOGRg0Rqn2M6aowIXJf
	TJ3ogtvg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTf4Z-0000000EBFr-2coJ;
	Thu, 11 Dec 2025 11:43:03 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 29E1230301A; Thu, 11 Dec 2025 12:43:02 +0100 (CET)
Date: Thu, 11 Dec 2025 12:43:02 +0100
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
Subject: Re: [PATCH v4 07/35] lockdep: Annotate lockdep assertions for
 context analysis
Message-ID: <20251211114302.GC3911114@noisy.programming.kicks-ass.net>
References: <20251120145835.3833031-2-elver@google.com>
 <20251120151033.3840508-7-elver@google.com>
 <20251120151033.3840508-8-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120151033.3840508-8-elver@google.com>
X-Rspamd-Queue-Id: 77B6A1C0012
X-Stat-Signature: w4c35ezw9o9ehrjhiezaisjw3rpib6qa
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765453406-117154
X-HE-Meta: U2FsdGVkX18hLlLAuCQLfVw8peHT1W4OKfUOBEEHCoVpuML+rRsfr2AfZWTUKrDMrePuISvVVH+NS3F8qH2OkOg9ODFSQqzWWBkf6vuDD0qkLLRfeh6RhJYOPMz//zGzvS7Vi5W2sU1yXoHa3fqdgO8iW6jIbmW0pAf7K/xPcq+kCCi2gxAWkNNZUi1msM9MwaOBjiR1o9LD9Z1Ev9hTS4PNY1fa2n4+lnkmff+TI4v1q6eh0Ucuy6kuv2L9tTG5DNmbW2qgDOOa253nNaAZiLrkp1alEcdMMMW+N/RZkBgLwHDVseR4ItMvsKAbuANo/kqSIIM/p2gyKgqlIkGQ4R4tepAtZx8A647QenenC+nJWwbOWdHojUacml+DL1eiq5he/MtnRGdPVXq86ELVCj3Gq2Iy892YmpUDcidjG741dYTI4Rv7Sgs6Jcc5UP5TOfxbxoz0cH90yjjY+pKjm8d6FnF4wAkBqZq9YdArQ/AeXvkqhg/eMU8TdjW/gGYEtn013DoKa/2DSZkF7su8vrzVTIO7OOGvxlUvvyZSLxY5olq8z5ONjEvDOGKZPvCeZ6P/vWPWOQFHoo4Yk4dk+xFUJ9w2CiaQ8mLeFSA/ypsqQuqzzvXwcwmlUTEZMxhT6/3Eue82hSQs09cFmzsxFKJL+0BOOsF67Vs/9FWAjlmcJLhNXubNPYATk08vGI3Wztq5pJfWCXK4C2qwlupGzh5sHrg33XXVqUUH4zFXjAucxZX05+MyBZErk9bC7SGwa2/0ulZyfiFVWcDkGuBgWCe0wGW8Hk+MWzxGJW75KszEgGULeMPx36Ea2xz2IL3FYS4cA+mi2EEDbusPqUryBYNNvG9QthlTq9WwmOwDk+GoFbfB5WKj9Jf0a2gY5sOk6x4FrZPU4oIz5PU7a0bb49jZnaGSqulKe63CfWvvLRPIn18eQJhix6OzxjX0xfsJpGkDBRAsbnUR1hiCsru
 9Q4Jo5X3
 TStS0kOEXWfyp9rJw+41IWLZc9bLX0/Hbl//Grlv84iQvTikd5R/nLmIMmjM5q2Xb4dM3ccyVdVZ1Vx9tXTt/PK2UFDv6gzp1pGGAUhoTE3M6kRnrS5HaWvSHM1A6Fqi62+Ud3DU099FsV0xt+E4KIvYbdAFnEqBk5FBLWOTbInoNuSobbWpxvxePzY9QmQsMx0vZVO2amoFuSjC5A8wa/l8SUoi8KXVtBbXXZV+VD7wJKzKiPx7wVU7VgJH+6KsdK36LKrV2ldUtPXYki9Fch0YBAR0fWy9quD9S7NCZogRJdcvGua+yrh3g9goP5M4uvnK1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 04:09:32PM +0100, Marco Elver wrote:

>  include/linux/lockdep.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
> index 67964dc4db95..2c99a6823161 100644
> --- a/include/linux/lockdep.h
> +++ b/include/linux/lockdep.h
> @@ -282,16 +282,16 @@ extern void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie);
>  	do { WARN_ON_ONCE(debug_locks && !(cond)); } while (0)

Since I typically read patches without first reading the Changelog --
because when I read the code later, I also don't see changelogs.

I must admit to getting most terribly confused here -- *again*, as I
then search back to previous discussions and found I was previously also
confused.

As such, I think we want a comment here that explains that assume_ctx
thing.

It is *NOT* (as the clang naming suggests) an assertion of holding the
lock (which is requires_ctx), but rather an annotation that forces the
ctx to be considered held.

>  
>  #define lockdep_assert_held(l)		\
> -	lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
> +	do { lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD); __assume_ctx_guard(l); } while (0)
>  
>  #define lockdep_assert_not_held(l)	\
>  	lockdep_assert(lockdep_is_held(l) != LOCK_STATE_HELD)
>  
>  #define lockdep_assert_held_write(l)	\
> -	lockdep_assert(lockdep_is_held_type(l, 0))
> +	do { lockdep_assert(lockdep_is_held_type(l, 0)); __assume_ctx_guard(l); } while (0)
>  
>  #define lockdep_assert_held_read(l)	\
> -	lockdep_assert(lockdep_is_held_type(l, 1))
> +	do { lockdep_assert(lockdep_is_held_type(l, 1)); __assume_shared_ctx_guard(l); } while (0)
>  
>  #define lockdep_assert_held_once(l)		\
>  	lockdep_assert_once(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
> @@ -389,10 +389,10 @@ extern int lockdep_is_held(const void *);
>  #define lockdep_assert(c)			do { } while (0)
>  #define lockdep_assert_once(c)			do { } while (0)
>  
> -#define lockdep_assert_held(l)			do { (void)(l); } while (0)
> +#define lockdep_assert_held(l)			__assume_ctx_guard(l)
>  #define lockdep_assert_not_held(l)		do { (void)(l); } while (0)
> -#define lockdep_assert_held_write(l)		do { (void)(l); } while (0)
> -#define lockdep_assert_held_read(l)		do { (void)(l); } while (0)
> +#define lockdep_assert_held_write(l)		__assume_ctx_guard(l)
> +#define lockdep_assert_held_read(l)		__assume_shared_ctx_guard(l)
>  #define lockdep_assert_held_once(l)		do { (void)(l); } while (0)
>  #define lockdep_assert_none_held_once()	do { } while (0)
>  
> -- 
> 2.52.0.rc1.455.g30608eb744-goog
> 


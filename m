Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78F85D26D9D
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 21:07:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB4FA6B0088; Fri,  9 Jan 2026 16:07:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C62EE6B0089; Fri,  9 Jan 2026 16:07:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6E0A6B008A; Fri,  9 Jan 2026 16:07:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A5F426B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 16:07:02 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4ADCC160ADB
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 21:07:02 +0000 (UTC)
X-FDA: 84313660284.29.79CD503
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com [209.85.221.66])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3C2C01A000B
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 21:06:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ufPWwSPa;
	spf=pass (imf19.hostedemail.com: domain of elver@google.com designates 209.85.221.66 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767992820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5YiRRXuPlaLabH8Y/4leOeBvuw8o8W+AqfnKT5Dc7EA=;
	b=n402kziVRS5Dvkg4yJDV5UigheeWIYLjFkna9mBUb4Z5zjMF063xKrEIllzf+2tBNofo3G
	ZvXaJFQvH4Wxc0WKRxX9huPUMxAfYLzvyB1QWlGCBsnTTQfOdf+9rlB22Q94hByeyIH+XF
	oebyetGY5/2IOz0bjTI2CQsBeZSRUAA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ufPWwSPa;
	spf=pass (imf19.hostedemail.com: domain of elver@google.com designates 209.85.221.66 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767992820; a=rsa-sha256;
	cv=none;
	b=KkQNUt33uP7qsZRKBOr3GaFrgMFvl7U42QYx/UaBxF9YiM+pF//AbCxHRxKXWtJbh+gId2
	21SzXDHZ2VcXvboIfQx7oK5sDaLfgp6Oo9XCzC5LbWg+r55W+Hg62+8HQcFhr6KeeZAPFz
	Uf/6nqr44cqJBEZHqnftA11OGC5+pik=
Received: by mail-wr1-f66.google.com with SMTP id ffacd0b85a97d-4327778df7fso2896828f8f.3
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 13:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767992818; x=1768597618; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5YiRRXuPlaLabH8Y/4leOeBvuw8o8W+AqfnKT5Dc7EA=;
        b=ufPWwSPalbMXKR/dBvYZUGFF+D9wv+sDeGgIMWL6klOt2sn7AQhrhGcKIIoovD50fX
         tUOQ2mMcFUS3UcakpcCQOcsqjprIBcP/mGH8CQTk0/woh7NpLC9XPgi0KL+aseTDw+Zo
         mo0gpLH3f/ME8I3AvfIja9XH/r1hzXa6VljkeGpQ/l73kwQuZRm0cjPqwT0jPuiro2U5
         cJCsdXJUtMgZavXphmjh9iGz1t/ClRMOfrX1JPp3iCTD3drSMTf0fBC+IfnbyN0fPUVD
         gB7IV8GXkv2kHLC5r8d08Hxsd7RX7Y1/sBScLWHqzHRTwTtjT0kwqGFZuGpQ3/k5qiHm
         b1gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767992818; x=1768597618;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5YiRRXuPlaLabH8Y/4leOeBvuw8o8W+AqfnKT5Dc7EA=;
        b=KZW1aUcpaau/NVZfp9JJxoF7gId0PyIdM/g5V9hkyy176G9hQTNkU3nxib7M9b/788
         zCHQ35HsC8JnwohxjRigUKr+i7y657VOYLKshIB47zIIPzAPi9m0G3ftF9SN9iLuhMwF
         VH7K51aUk+1H670OdKIZvLWaW/TMrFzrQlh6mh4nS6A+TgQY+lj662mtBeJPt4qPj7uJ
         Tal1IsLbd/XAQiDTv1DM+2G6Bel1Ej/maOLG7um4eKM7m562TEei/TeumvuU6PeZztS6
         nLCb7JKP5QVMqFJcN5bgpzIT8yK5Ez5PN8QQHp2/iMTU1DZLFzzYAeKQx9+MMfU1gE/s
         S6QA==
X-Forwarded-Encrypted: i=1; AJvYcCW799C2+lsVOanpSklW2a2TUmVLonam4jCzWm03aBXPXe0hUB5fy+wiEc/CPrgX15KscT51X7QiyQ==@kvack.org
X-Gm-Message-State: AOJu0YwAw73AfgrGWDf41iGwgaENRb5jzwoIt3WWMb+ITmAwoFh9EHwB
	wuLlXuOK4KSI+wTvTZJ4T0gKxlHZ8D+jzMdMP8PkPbByiUJ/96fQmsyvHlmVcll0bQ==
X-Gm-Gg: AY/fxX5KmKtDi7wH7pD0QpZMQHmCF6IO4awc3Rl6qrhtiuhOgEa+gvwNiO4Iihm1aHN
	/FMkeAzT0tZvzMCqOdzGg8ZCAp1GHsX7cezHN9paXtr+bB2Tn3vOwDYfz9lnKtblwTjVmKVMl+T
	i+2FmAV9oJoskj0L4h9oRXJ6Psr9XDFwne+77wBMFUEAulxpDpakobEYqjOgFJQVH8kFN5Owbu7
	Ou+1Tx+yFUOXjwamSzPCI4zWEBdQbvFeg72GLqLyRDgQE24vDm5Z61U3plqtmYeA/dYEdcLg+kI
	kYJT1S4gcz6S7DLEZbWDjS4dBZHkaGO+a8hvHtjzRcS3BKFudD8Lpoh6ThrDuo+UuniGGrF3Bgd
	OosY6wbYslx8kvhH6pdWwTEcpdhTkg0V5lmttwzb5bdZItVSQJSZcdLzBSIlFM7eI07Q0W6V/9d
	gEgOe6MwsZUxuXwvqo8NxrdcGFRXc6rcvDZholfFRPtUSP31Qy
X-Google-Smtp-Source: AGHT+IGq/RRhgqPG360sNev62yK5kDA+HwwG1xM6/+WULZOG4/KY3n5LdCQUAGWoCEcUzU7iAOtzbQ==
X-Received: by 2002:a05:6000:4023:b0:432:b951:e9fc with SMTP id ffacd0b85a97d-432c37636b0mr12665932f8f.47.1767992817879;
        Fri, 09 Jan 2026 13:06:57 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:2834:9:2965:801e:e18a:cba1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5df9c5sm25214398f8f.22.2026.01.09.13.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 13:06:57 -0800 (PST)
Date: Fri, 9 Jan 2026 22:06:50 +0100
From: Marco Elver <elver@google.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Will Deacon <will@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
	Dmitry Vyukov <dvyukov@google.com>,
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
Subject: Re: [PATCH v5 20/36] locking/ww_mutex: Support Clang's context
 analysis
Message-ID: <aWFt6hcLaCjQQu2c@elver.google.com>
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-21-elver@google.com>
 <05c77ca1-7618-43c5-b259-d89741808479@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05c77ca1-7618-43c5-b259-d89741808479@acm.org>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Rspam-User: 
X-Stat-Signature: yg6ckkkmux6e5hefm6iecz9qakifk4t1
X-Rspamd-Queue-Id: 3C2C01A000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1767992819-97429
X-HE-Meta: U2FsdGVkX19xP+t0591fI2PvybUUlB1wH02sIPVLpM441EmdelVkEhbNIcaToMXVTRYirLz5ZDog0Tp8f5HRWSEP22uia0OOEV3fZIWXabb/JVcSC74nbnDFtCjvSIeEV5WWTfj+zpWWYIwxEnC96rc+mw8kZLSKfxxdG1YrY+feKnx77iiCwNeV2bmJ2cBRUSk/+FFJgPCERalzS2dHGnoiPrfJKqWX37ydMZJ8tp6AiDNg709fdMnBXW4mn/Xzf46+LNntjlpYo07mIQjIy32O8drtcslCYpOd6uFH7p6+RhcP/DRib+pMC8Ifw1gIuQlYTJZZMZLLlVa79R/pyx4DTs5ou4EIJBVQgPWlBZUq9EPM0eAsLduOG2+/O56Rsrp4jHqwuB0anHKR1HMR7pEC9rCiHbUKeDDxrQ6utRtnO335lJ7TEgwnvFo+RrtTn/FoRRhT4F6gl9xj/ypCqMpFbmq4bqJlFmJ1yvW9Gj73MHanV4RRmoWUidIhSUJp7gNx5NMBu0A3Q9sRn2pq2mqmN/PdYtv+LpR9qljdLqiLwQ162xo+vRG9lizlfgMwjOCnGkGI/0JiRrl/DQKvwtxsgkBkQAi5o/imZYVuahAhYUCGYxGk5ZvgDKC2hMxVj2iP+aHjGkplbVXfm8uBDg/q2m9y0VsU9KzVkbX0FXl+zt+CIm3JiSLAK4crjAf9qmalCQFpgbYdFJp7R6si5A+PxNuSNGUnmKAg1x2INBAkMCVjdigCVVGILjmkacClvaxLPZPFQWNTYvNSB8ny3ev2DNVuICLL8Db+hQXMcxV3DAWZOmfbG9ILUYgUI5dA8vSjkctQrRqp94ejou6uK1AENoBoUOw1hGpTeRyxacxG/GNJtYr0AAuHDvVtFntHOCyBGrDVVP6BCoGEA81mEvM8JXlTgxO1jMYzCvX3EybU+pF7t3jCcv6qMp8SZ6N5GzaU9rSEx+hb0w+h2nC
 7iAMCAQ6
 WVaNTtL+MLZ8go6FE8YsD0goUbM0fRsSTxFJp+TuocFXD9cBmm9SvRp1e8YtEb6IJvHmopnV2Gts3b0IY835mtskcIzzMFZV+gcb/9T+xgwkJn/m+V5Ir0/PrC5RZh6cEQxlEoiYCUlpsCdzeS7Tu8xtDswbC0xwI6gDljJMJhVsLz83vg19RDJsPlOg48WEtmu9jy2H/YSDqfXXklqe11Yt4EDzQHTuL82auA+MC4eL3v1mH2jxEq0UzRTlUdBLixCBInq/uCGuk2XdhBMmqzK0z6m1s+yAJyNIV4yV4IzIwocDs4W6znjwIB7lQyNjJfja8G0cbPFE4u/LD4LknL+jhVc2UJaP3dcQchkz0Cx/1Kfg0GoeKxWt8rPs279U1mS66Hm0DmuntOVhvrKLxNfI4le9MtVMqGUFfg8Jc1WCIEn+Xg8H8AfR8470enB3gGac9C+W0bMqxSP6FjuQJYxRp2fMQUqL04DpuOMK3Upz416iZexdNPg6MPhWvC4bKmqODeDd5ypvHdHCtQDuLmUFXjb5VdJiWWYRqnD7f1wFtK/8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 12:16PM -0800, Bart Van Assche wrote:
> On 12/19/25 8:40 AM, Marco Elver wrote:
> > Add support for Clang's context analysis for ww_mutex.
> > 
> > The programming model for ww_mutex is subtly more complex than other
> > locking primitives when using ww_acquire_ctx. Encoding the respective
> > pre-conditions for ww_mutex lock/unlock based on ww_acquire_ctx state
> > using Clang's context analysis makes incorrect use of the API harder.
> 
> That's a very short description. It should have been explained in the
> patch description how the ww_acquire_ctx changes affect callers of the
> ww_acquire_{init,done,fini}() functions.

How so? The API is the same (now statically enforced), and there's no
functional change at runtime. Or did I miss something?

> >   static inline void ww_acquire_init(struct ww_acquire_ctx *ctx,
> >   				   struct ww_class *ww_class)
> > +	__acquires(ctx) __no_context_analysis
> > [ ... ]
> >   static inline void ww_acquire_done(struct ww_acquire_ctx *ctx)
> > +	__releases(ctx) __acquires_shared(ctx) __no_context_analysis
> >   {
> > [ ... ]
> >   static inline void ww_acquire_fini(struct ww_acquire_ctx *ctx)
> > +	__releases_shared(ctx) __no_context_analysis
> 
> The above changes make it mandatory to call ww_acquire_done() before
> calling ww_acquire_fini(). In Documentation/locking/ww-mutex-design.rst
> there is an example where there is no ww_acquire_done() call between
> ww_acquire_init() and ww_acquire_fini() (see also line 202).

It might be worth updating the example with what the kernel-doc
documentation recommends (below).

> The
> function dma_resv_lockdep() in drivers/dma-buf/dma-resv.c doesn't call
> ww_acquire_done() at all. Does this mean that the above annotations are
> wrong?

If there's 1 out of N ww_mutex users that missed ww_acquire_done()
there's a good chance that 1 case is wrong.

But generally, depends if we want to enforce ww_acquire_done() or not
which itself is no-op in non-lockdep builds, however, with
DEBUG_WW_MUTEXES it's no longer no-op so it might be a good idea to
enforce it to get proper lockdep checking.

> Is there a better solution than removing the __acquire() and
> __release() annotations from the above three functions?

The kernel-doc comment for ww_acquire_done() says:

	/**
	 * ww_acquire_done - marks the end of the acquire phase
	 * @ctx: the acquire context
	 *
>>	 * Marks the end of the acquire phase, any further w/w mutex lock calls using
>>	 * this context are forbidden.
>>	 *
>>	 * Calling this function is optional, it is just useful to document w/w mutex
>>	 * code and clearly designated the acquire phase from actually using the locked
>>	 * data structures.
	 */
	static inline void ww_acquire_done(struct ww_acquire_ctx *ctx)
		__releases(ctx) __acquires_shared(ctx) __no_context_analysis
	{
	#ifdef DEBUG_WW_MUTEXES
		lockdep_assert_held(ctx);

		DEBUG_LOCKS_WARN_ON(ctx->done_acquire);
		ctx->done_acquire = 1;
	#endif
	}

It states it's optional, but it's unclear if that's true with
DEBUG_WW_MUTEXES builds. I'd vote for enforcing use of
ww_acquire_done(). If there's old code that's not using it, it should be
added there to get proper lockdep checking.


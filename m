Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55265D3E792
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 11:49:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A3846B0005; Thu, 11 Dec 2025 06:49:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 954B66B0007; Thu, 11 Dec 2025 06:49:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86A776B0008; Thu, 11 Dec 2025 06:49:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 76B5D6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 06:49:19 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0BE19BB9B0
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 11:49:19 +0000 (UTC)
X-FDA: 84207019638.01.0C45795
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id 432C41C0008
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 11:49:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JVN1AzMs;
	spf=none (imf18.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765453757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+OT4ivkTtGpyfGWvpgrf0Vr9j9IriXFLaXkwu0GJ6bw=;
	b=ZvXnEusH8yctKgG6zECokrDsd0OglZbR5DE19gGckjo6BG3jAJKY3qduKKgt1LOOtII70C
	SaRmAAAg7HjnPXi+pqP2ZzG9ys6dtA4uWXUaNU/Xpf0GW0RdtMs+8W7n0RhPgBR1rhPLoX
	ShYpOAGXq1Ow0rDVmNDeLpR8h+TuYqw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JVN1AzMs;
	spf=none (imf18.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765453757; a=rsa-sha256;
	cv=none;
	b=VmJVhq4cDxdYR/Mh6sa7tZ11KxpDyYvMRCanXh4aznCmwH1WLWoueWWmpuYlzXIXjYPm/7
	GOGW3kDrZvUt+ucltdkGKXdZHJLRsn2l3ADL8FN/AJH6KyTiqgRiNfVxKlCNjUm7kpnnQK
	zCCWS79xlZxJSRQU6StwfY63lLOzgKA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+OT4ivkTtGpyfGWvpgrf0Vr9j9IriXFLaXkwu0GJ6bw=; b=JVN1AzMsYXKkNnwNeBL1OpOC2M
	usRg9+5aFTrJDHOxEclPH1av467Fb3Bj3rPgMyCbJ5gZYycl9Gw6AjdhzpiLl3C0V9sb1i0yaQfRK
	mOf5ZYG2z9itaINLA0tfLNeKZSZyiW/C+oVjaNH6gOgA3m+gKuZvovx8NVkI5qpnHg6IQDV9R9c1T
	fyzEc9WqyUb15CtUOl/P9FkFgRDq1JVhxqr2lfHMG4MfmM6gG4CgJ90xouVD4A2O/wBERNIxj9gwr
	pYbXQ1fHOXH+zv5KIkiK43jA/QtjxQp5F0m7a8f08ERF19UcmgOhPesOMjYZXmUqtsp+gyMa2Aosq
	y9tldtSA==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTfAP-0000000EBca-31xd;
	Thu, 11 Dec 2025 11:49:05 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 2CEC930301A; Thu, 11 Dec 2025 12:49:05 +0100 (CET)
Date: Thu, 11 Dec 2025 12:49:05 +0100
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
Subject: Re: [PATCH v4 08/35] locking/rwlock, spinlock: Support Clang's
 context analysis
Message-ID: <20251211114905.GE3911114@noisy.programming.kicks-ass.net>
References: <20251120145835.3833031-2-elver@google.com>
 <20251120151033.3840508-7-elver@google.com>
 <20251120151033.3840508-9-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120151033.3840508-9-elver@google.com>
X-Stat-Signature: bems68mqfy75hwfapew3dghjjbnfrbq3
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 432C41C0008
X-HE-Tag: 1765453757-673782
X-HE-Meta: U2FsdGVkX1/CKsf/np+S+RYNSh+ZEH6InpEnQQd+QczRZw2YUWIuw4ylXPrlMBqXOnh85+9lY7FYu3xPs+0nC1UR4EuPu33DEr3AtNJTv6Vz3qf3xmkYZ+mTR+zgvbZXS4KPBIWrkVOtqpq6axOeVxF9ih5ppZeoJj5oLuFcJVqLhK35ZlTefzH76ITWDHY3N8ZTeDGnmAnHN1ag9c0ccaSJzd4X73tLCpc/1Mx1EI6EaQbcFNU6nIWfmlYX+0gt5Be5xMLmKsi8Hq1Hhh2FHfaZ04Uvl2rSBZOJOQedAze6CImR31tD1W/g+9I4Am7F87wQOYqp48dvp6TzVD+MyP1RoqQQC9eNX5kE0yBHHLId1AyQVbD9AbwSlwlndn99aezcFy8O7EihW5gHnIBGaQkrOmJx8D5joqjbX50BhIy/iA618x6ErgRg2Wr47scyUMNDKnRto7Y4MASaQlfuXjJrlyHIevIXHbNXqbXvR7jykceUS0lFbyMohte+Jb4vkgwXJQN5I0PiTu9pBBu45k1cHFJLk+WfW21FoomM8/+x1YXl3XNQe+buDFlHESwt06v8m+IE+TEJZQWyLLT90YuWTPeh0O/KLlGJJm3zaKjW8uRkHAafHDRUnvFXk/T+qa1zyUZQxyoA366NqtVmt6HC7KOcSucMhZNQgQW5kmIjio+hRF3ZUsapS7uR4kXxs6zocuxDWOqu+Oy20E5SJ5eiJ2vkhzeXunJ0jTLZ1JpCnxPCZM1M9W9aPjyUNhST7/h4NL49hRpz/I99hFiB/kGZ1Ecr7+EkilHAJUQJ3m33hpiJERwm077Tfyh2frni0iEAcdzpk7Nb4JLHdxyg/FYI3qPY+g6Svhzl7l29AtG512vK5cttwUYtIsOo0q6LzcZ40d5c+KAbao4codLqAZlv5dHXBZXdpI6P4BDTv2dV6yMwdyUtWjR7pM9RAleczmoSOXHpdIlvxaA/CDj
 slgkvc59
 Cg+6ZLHa0jf6Atp6becqNFQQ7KxeDqwA6XO3uVxcICrDcm0SUPUJrnOWXuvoLQOuoq4H556TcHgkjOcDZPrW81uslAEYJL50QRurlz+uvXzBZgFcYj+/GvDt8s+aijU2V3RV9Z3QwRYcZXO8rsM58YCmMwxT1ScU1fKcTgZ4L6aVQZ2gWr6uxZHLyUsVZFKPipGMbrHPm+02tsXz6vWom5Cj/XSgYUvQseJOqTkAUkXlDFB3TmjJhCCm5quY/I2HS/KmLJmUV+IDvU20AaxZHY2xHKA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 04:09:33PM +0100, Marco Elver wrote:

> To avoid warnings in constructors, the initialization functions mark a
> lock as acquired when initialized before guarded variables.

> diff --git a/include/linux/rwlock.h b/include/linux/rwlock.h
> index 5b87c6f4a243..a2f85a0356c4 100644
> --- a/include/linux/rwlock.h
> +++ b/include/linux/rwlock.h
> @@ -22,23 +22,24 @@ do {								\
>  	static struct lock_class_key __key;			\
>  								\
>  	__rwlock_init((lock), #lock, &__key);			\
> +	__assume_ctx_guard(lock);				\
>  } while (0)
>  #else
>  # define rwlock_init(lock)					\
> -	do { *(lock) = __RW_LOCK_UNLOCKED(lock); } while (0)
> +	do { *(lock) = __RW_LOCK_UNLOCKED(lock); __assume_ctx_guard(lock); } while (0)
>  #endif

This is again somewhat magical and confused the living daylight out of
me. I know (from having looked back on previous discussions) that I was
confused about this before, and clearly it didn't stick.

So obviously I'll be confused again when I look at this code in a years
time or so :/

Can we get a comment near this __assume_ctx_guard() thing (because
putting it all over the lock initializers would probably be duplicating
things too much)?


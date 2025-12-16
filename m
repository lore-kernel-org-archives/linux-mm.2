Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B776D5E146
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 12:32:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EF306B0005; Tue, 16 Dec 2025 07:32:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986186B0089; Tue, 16 Dec 2025 07:32:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 868846B008A; Tue, 16 Dec 2025 07:32:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 75E836B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:32:26 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6E9ED1A064E
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 12:32:24 +0000 (UTC)
X-FDA: 84225272208.06.FFA7C7A
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf29.hostedemail.com (Postfix) with ESMTP id BD17D120011
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 12:32:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=aULM0WOR;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf29.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765888342; a=rsa-sha256;
	cv=none;
	b=UwJLBjG+RpbtnUyuFDlpfDxyEKvV44qZaPQGoageFpYXAePgz0uBoJz0h4iMfqCrJFCLfC
	5dwCfJF1Prm3gIwj4TvrcJJGzYhm4AX4GnMqIFdeykvg+5rH1NVCBqpV3ObhCfKbOKI3Wz
	FqN/fiEJP91JgdfFKrXDFXYkZOFyyBM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=aULM0WOR;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf29.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765888342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PT+1SSkmSVMS0Ka1JPI8XlGmFQ/04yBEbtnblqzrJZU=;
	b=OwE/9pkq5v7ZE4VnxKwVdhCkqoZLNuS+IlG3TezpUSMVDXUPB6bn9TkVfhVG9rkKNPUUhk
	wdtx53ZVK/MZuwhPTgNM0PWmYUdXQ5x1i+ppWl2pSjr/dKu0Ap8OjXiuWWIYt1uiOz8NAj
	yUWNcqnEPOR+vqP3ehuPQtJJ8C6G91U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PT+1SSkmSVMS0Ka1JPI8XlGmFQ/04yBEbtnblqzrJZU=; b=aULM0WORyMyG1V7q67HHf8Pnaa
	NC5JgDx3xvq8f+F5KNJZu8KWF3bk3QdZNq9mAaJd4kCIL2Ga28adix+Urc5e4fLYxU69ezBB7gY58
	5lm8yjCsk3qFLmry+oBd0hT3UqC3563GeqMBjfc+GBTZ6vxxwamfPdEiVrKRP1twYbsECNhYm8tFP
	sFyalImbKjiTayr5QZxW7qOk8cNg8AiB+WgzHpnpuzEegTlZ8ErrdxvnCefnRvUGHiPZe3bf4KPr4
	MzBHq7NI02WHXEqjGEvQA1Grvv3OmLz94h3Ff5gqAXkM0itxSMmOPBVBsR/Oc3Uew3hsmaYs3hWiz
	WDe7RvXw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVTMO-00000004iUO-3Ujr;
	Tue, 16 Dec 2025 11:36:56 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 9425D300220; Tue, 16 Dec 2025 13:32:11 +0100 (CET)
Date: Tue, 16 Dec 2025 13:32:11 +0100
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
Subject: Re: [PATCH v4 06/35] cleanup: Basic compatibility with context
 analysis
Message-ID: <20251216123211.GT3707837@noisy.programming.kicks-ass.net>
References: <20251120145835.3833031-2-elver@google.com>
 <20251120151033.3840508-7-elver@google.com>
 <20251211121659.GH3911114@noisy.programming.kicks-ass.net>
 <CANpmjNOmAYFj518rH0FdPp=cqK8EeKEgh1ok_zFUwHU5Fu92=w@mail.gmail.com>
 <20251212094352.GL3911114@noisy.programming.kicks-ass.net>
 <CANpmjNP=s33L6LgYWHygEuLtWTq-s2n4yFDvvGcF3HjbGH+hqw@mail.gmail.com>
 <20251212110928.GP3911114@noisy.programming.kicks-ass.net>
 <aUAPbFJSv0alh_ix@elver.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUAPbFJSv0alh_ix@elver.google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BD17D120011
X-Stat-Signature: 1eixmbn8ehiwcbmeps97nyqsmook1xh3
X-HE-Tag: 1765888342-321082
X-HE-Meta: U2FsdGVkX18uUcRRM9kMw1iQ+z5I2JLHvQEp3USeEL3cSj3UEY0F96tiQaZqo4kBmg9/82PROei8ORUcQmZR7hwT9+t4QpLHGWVwUdOXlwljHQgcFP4E2ARa4Qum6FIJnVeRNRfITUk8cHxFX1NpXsFdC7LLn0tTorWG5HFxfBzkCSOq/R5wFXO/hb1drY/EnzMIAzDfni1ypQctI+TsTz7XFbJ5q+MgVXRmRPTNVKyEf4ohR5mcywxaEopV16b+4xeEJHFTEHbg/VoIKVZJIIz9LSI4eCEuCRUz7UIwVHBISAbLg7vfdXKuHVxtwilECBD+NtrmMSFwCHsUthEIRmOcTDZSRyBRnAlDyocfQZJhGzG1yb/aiaPX/PsNeD2n7oZsPyVv0CbiILNV8VcE+YsDy+myiWAzL9mtE4PI3a4gvtE3YX7zLXZL5xHCda+aJCc/fDhRaGyyRhydS8EbvkNogAEbAdFkXH/bf4YA+vbluGyqHhKCbmtRb29PkNv9pGIf0dkMjPttDKpIR8xaP2G6yrEYXQpwtRfCw+ruKjFQuCvwB3C9ZqmoOsZcRokfIKImcP0UPUgBIY5l/gYr+26QBys/smd8OkexqQuevdfIdKqUhOJMLYaM5KCHRM+ypOL9FzfVIcTIKUopgExc3t0zsnzHWe4yXpdHTzO8bM+k16UPfKP4PIpN32Fxoyq6jalxDEwLR4PcKnOj2B9Ftw5P16DpwVn31Lz3COq4W9fHnyiejqv0S4Tx6qJcG3zwlkZTA5Ud01okKU6M7h8j5zYnVQfmgxNSMAig8qrxDKD5yE0lCudbL3Q0BNPlNQ/T4nIiRk+tX+fYKlakgxndtHOkhqlAaGmzEUNvUisYsjFuGD/uho0zi0rR21D1Kfd9yW1pa3Cyg+5FTVBzh7hNfl3HQgjEDykJSDLooDSFz8MEJix5Wl6uVPPuqb1BrB5lhHcTopjgADrQ++oBKLx
 YorS62lW
 PQnOl0Qxhfp1h5DAxl89HdyGmkzXaFIzxN8vdv0ATS6qiKE5vdUzhLwdhjOPK9sD5/vJI9G6+N/rEiGAIm/J0NTaQWriDLO5qjzqaMyHrCferpJ+JiL59mJtNgTMMrkDhnQmIBGM4E//VxqJeKdV3a/23mMYjvjA2uqVjTCaa7e0+yaJaNoY/ibIdbcNOs8kdRwN9WBCedM+F3M21Dz5L5Vr2e00TceEkI1PSOe0qdICJwhU8d1ETrfwUTcmOD08Uv8WlqJdAiGxRMPE2xP5LLmuR4RfAAPEL1ib/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 02:38:52PM +0100, Marco Elver wrote:

> Working on rebasing this to v6.19-rc1 and saw this new scoped seqlock
> abstraction. For that one I was able to make it work like I thought we
> could (below). Some awkwardness is required to make it work in
> for-loops, which only let you define variables with the same type.

> 
> diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
> index b5563dc83aba..5162962b4b26 100644
> --- a/include/linux/seqlock.h
> +++ b/include/linux/seqlock.h
> @@ -1249,6 +1249,7 @@ struct ss_tmp {
>  };
>  
>  static __always_inline void __scoped_seqlock_cleanup(struct ss_tmp *sst)
> +	__no_context_analysis
>  {
>  	if (sst->lock)
>  		spin_unlock(sst->lock);
> @@ -1278,6 +1279,7 @@ extern void __scoped_seqlock_bug(void);
>  
>  static __always_inline void
>  __scoped_seqlock_next(struct ss_tmp *sst, seqlock_t *lock, enum ss_state target)
> +	__no_context_analysis
>  {
>  	switch (sst->state) {
>  	case ss_done:
> @@ -1320,9 +1322,18 @@ __scoped_seqlock_next(struct ss_tmp *sst, seqlock_t *lock, enum ss_state target)
>  	}
>  }
>  
> +/*
> + * Context analysis helper to release seqlock at the end of the for-scope; the
> + * alias analysis of the compiler will recognize that the pointer @s is is an
> + * alias to @_seqlock passed to read_seqbegin(_seqlock) below.
> + */
> +static __always_inline void __scoped_seqlock_cleanup_ctx(struct ss_tmp **s)
> +	__releases_shared(*((seqlock_t **)s)) __no_context_analysis {}
> +
>  #define __scoped_seqlock_read(_seqlock, _target, _s)			\
>  	for (struct ss_tmp _s __cleanup(__scoped_seqlock_cleanup) =	\
> -	     { .state = ss_lockless, .data = read_seqbegin(_seqlock) };	\
> +	     { .state = ss_lockless, .data = read_seqbegin(_seqlock) }, \
> +	     *__UNIQUE_ID(ctx) __cleanup(__scoped_seqlock_cleanup_ctx) = (struct ss_tmp *)_seqlock; \
>  	     _s.state != ss_done;					\
>  	     __scoped_seqlock_next(&_s, _seqlock, _target))
>  

I am ever so confused.. where is the __acquire_shared(), in read_seqbegin() ?

Also, why do we need this second variable with cleanup; can't the
existing __scoped_seqlock_cleanup() get the __releases_shared()
attribute?


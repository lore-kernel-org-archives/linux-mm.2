Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19E14D26D94
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 20:17:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59B9C6B0005; Fri,  9 Jan 2026 15:16:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 579846B0089; Fri,  9 Jan 2026 15:16:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47BF56B008A; Fri,  9 Jan 2026 15:16:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 33F4B6B0005
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 15:16:59 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 398B38C839
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 20:16:58 +0000 (UTC)
X-FDA: 84313534116.27.53203CC
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3C7CC16000A
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 20:16:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=RjLtkJa1;
	spf=pass (imf08.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.14 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767989816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MWWlok8ve6te0Z1LFT3tDlJ2/NkqaoxHzzfJCelUW48=;
	b=Sv9QlZ7rrb4e4fKt7LDwEvTThJocLvWR6qoK/+xsW5S3ZGsKR8EB1NHxF35IS8TqFjmOsg
	zG3pCd12In/bLzFE/9sPX35ZWC5u9WZIQ4Nft/5mWoh5KqB7yVDPcQZDf2rx6VGMPm4Tpi
	br6o0XmZrw/Ymdos5S6vLKvFypnviJ8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=RjLtkJa1;
	spf=pass (imf08.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.14 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767989816; a=rsa-sha256;
	cv=none;
	b=pykjXHDnQzQlC+IKxN8llyTl2VgloezIaaK1binCV8zF5IjpfMsKL72TpBb1flvoEb/RIc
	RZOKRhKUsslDzf/X+WCYyzJLeiVY75tZ5B3HJ++9tSqlGYtZLNMwBVQWuJqv1c0l9XLC3g
	NzAG48AoPgC3O3ACwMpXecsKCuDqnvM=
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dntN66qC7z1XSVtL;
	Fri,  9 Jan 2026 20:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1767989807; x=1770581808; bh=MWWlok8ve6te0Z1LFT3tDlJ2
	/NkqaoxHzzfJCelUW48=; b=RjLtkJa1D0QD6TAtBF7G2Jt4AHXQc+brZdc/5Tt3
	jLo0eDAvbJmHIgNEXvLWEKHxTHRyVyb8D/Q06Ur+0T8jENUFddkat1ZKTy3z3SCC
	yDf86qyZn7Mw6O42JTSazct3a+5P6OhdLUxYoG2N+K1nLDa+zdW6XgfbDJXsR7ng
	jwo0GO2ay6yXtRwcQHBbI2rYmhtkOiawoqZQXc3Ti/WgrYqhAEUZOdNAs9KC7uUn
	Qq0xxt6q5wZuMIdq5Cl7pFCXgskRMzaEvQTOGgVF3O1ctVoejnnjZWNZJ35Ht4/9
	VhXFXR50Omzjcooxo8ojFKm5X7x9JePv61sq2YtntHteEg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JY_Dc9oQqhZL; Fri,  9 Jan 2026 20:16:47 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dntMk3WPZz1XT1Zk;
	Fri,  9 Jan 2026 20:16:33 +0000 (UTC)
Message-ID: <05c77ca1-7618-43c5-b259-d89741808479@acm.org>
Date: Fri, 9 Jan 2026 12:16:33 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 20/36] locking/ww_mutex: Support Clang's context
 analysis
To: Marco Elver <elver@google.com>, Peter Zijlstra <peterz@infradead.org>,
 Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
 Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
 Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
 Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>,
 Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>,
 Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>,
 Eric Dumazet <edumazet@google.com>, Frederic Weisbecker
 <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>,
 Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>,
 Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Josh Triplett <josh@joshtriplett.org>, Justin Stitt
 <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
 Kentaro Takeda <takedakn@nttdata.co.jp>,
 Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland
 <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
 Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>,
 kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org,
 linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-21-elver@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251219154418.3592607-21-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kiqzuc413kz794m5keac16cy465jpnbs
X-Rspamd-Queue-Id: 3C7CC16000A
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1767989816-674768
X-HE-Meta: U2FsdGVkX18pupdgGXwwkQynv2cUhvMVc4lptWzlRDbraRp9CWz4fW8/54vNj933lsGT4GWlGVGVX91hnb9ZFbUfl6YUvl9GjIXqv3ptR5REmhB5GjdXGMhJterJ6fk+ISMYbW5OpIgF4JFWgyLMehOxOD3l0yc0+rjWZv4stxOu4V8BbAGLm0MBq3bk40DeoUXxq4l/Bh1OVzTkkqJHSCEo2gFQMgqs051FyQJkZhaNmoi0yASVzR2l7MWIhAcEUM0Pk5qay+08Wi+sygVfAmvmFBmGy3kykKG9XY6vOQE9C1Itrr/3qZiAcuCplzTj7+EkLDI5mgaI30LFz42n55zbf4/MklUWey96MA8NGHYyQa6ktDUSrJGSz/W477F7dJsFCow/rgx8qdZM4YCnkJrwNn2o6EvcHunrhLQzj3yiFkiF4fFSx4wB5+7RjdnDX5Ytdr3nnNAWcTM0lDpaRdRM84i+nekiXwEWTHpY9eCtbCZ1p9exBnva3PjKDIYWStIgRPE2Ik/4YMexZ504QClriJEx3mjPX3g2PuYzHlx0od7LuN1oAZ+bRfxHjX2YGRdKRmm4tBZpO7smcgWScxs5KNW0MjayyXBH5MgVlrwRKwbbJAypUI+THcJwa8y6eAP9+4DU8Qgq+dzrDAHUgRG3b/ma/etoX+4UFpzqRYFa/iwTEitqRvmnyCNtTESainFmQqP0ppEDldKANjOHwKWiAyxGs6HQwKHgH50Oc160njsVghQiMpoTdSQQv4z7WAnBzzgF0cR8/yVtM6QM1zFWg+R2ZXvgbzkrF3zp57jrKXk/wCO5D0D7YTxa4mDgm1hhEB9AE+nLzVtzd7lAhalRbPYVPRBaSo/+Pu1jl6Peq5eEM4JRDEuI9yoASVHmpEzkP2aauUUbhy9+1Qv89l7kTI6rlFHOtTdALbM3R72wKGpXn6FV4xJ8CejCe0DpFcBQNN5UZhLHyjTCOuP
 pXpfx3U2
 M0xASv4fZx+o6XKHYEPAnEGFWG44c0jo/HR6OQKOC6rwIlVd2wlVwzlDNzvTfzs4aAAGJgqVP7M0aY5KrlAZrpGoYd0UBhPgw74ouJmupmIt3sebwlfQz1MDng3LL9k7sj+WDbd93QK6+SR55ZYfHiFkfQBvGV8G2QjEOfO3e46YTRNS31xOe70rLXDqDwmYqlSngVr64VGBXQ9VehzxGEO4y9qAPkgqoIAtG5wPv+Zn0TUKjzql7Vp81+G6bgpm8L1S9n7NUeQElob7BxLiePJlktO7sM0/6bD9/MWeAW+S2BBc5BeTGtb18cd1pjO4QLSlJR6+ll6Wz+j0ymXDFp+lHqnxLyM/JCUBiKYz3NYD9FdXb5AjEIgyltRocRpfyc0ycMU7GPygmg47XyqAJwQY/wg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 8:40 AM, Marco Elver wrote:
> Add support for Clang's context analysis for ww_mutex.
> 
> The programming model for ww_mutex is subtly more complex than other
> locking primitives when using ww_acquire_ctx. Encoding the respective
> pre-conditions for ww_mutex lock/unlock based on ww_acquire_ctx state
> using Clang's context analysis makes incorrect use of the API harder.

That's a very short description. It should have been explained in the
patch description how the ww_acquire_ctx changes affect callers of the
ww_acquire_{init,done,fini}() functions.

>   static inline void ww_acquire_init(struct ww_acquire_ctx *ctx,
>   				   struct ww_class *ww_class)
> +	__acquires(ctx) __no_context_analysis
> [ ... ]
>   static inline void ww_acquire_done(struct ww_acquire_ctx *ctx)
> +	__releases(ctx) __acquires_shared(ctx) __no_context_analysis
>   {
> [ ... ]
>   static inline void ww_acquire_fini(struct ww_acquire_ctx *ctx)
> +	__releases_shared(ctx) __no_context_analysis

The above changes make it mandatory to call ww_acquire_done() before
calling ww_acquire_fini(). In Documentation/locking/ww-mutex-design.rst
there is an example where there is no ww_acquire_done() call between
ww_acquire_init() and ww_acquire_fini() (see also line 202). The
function dma_resv_lockdep() in drivers/dma-buf/dma-resv.c doesn't call
ww_acquire_done() at all. Does this mean that the above annotations are
wrong? Is there a better solution than removing the __acquire() and
__release() annotations from the above three functions?

Bart.


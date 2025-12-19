Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2303EE6688C
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 20:55:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89E526B00A1; Fri, 19 Dec 2025 15:55:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 875956B00A4; Fri, 19 Dec 2025 15:55:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7817A6B00A5; Fri, 19 Dec 2025 15:55:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66DCE6B00A1
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:55:26 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 36ADC13A5D0
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:55:26 +0000 (UTC)
X-FDA: 84237426252.07.A87EE98
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2C75F1C0016
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:55:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b="iY/ltKNs";
	dmarc=pass (policy=reject) header.from=acm.org;
	spf=pass (imf18.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766177724; a=rsa-sha256;
	cv=none;
	b=ZTdzIviAZuwkrjQ3sGZHnsM0Dv+15u0TEZlhaJIRmaUSt3Om+wDA+BPCpDX5sQTrLGbYbh
	Q3dGUEjxuq/CwrE5W6uGHCT+49VmlH0qK1ZernzlBtRirdqKu2HB5ZOcWMYmlVO2YcM+tE
	ewfKvTpd6GkkgO6tczhDWLx6DeJGZdA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b="iY/ltKNs";
	dmarc=pass (policy=reject) header.from=acm.org;
	spf=pass (imf18.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766177724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XdZxKJLVv/us0MhlURSAieVC/jzQimy4qD0cHcgmVzU=;
	b=avzhptdMk9cjcLBjtZEjHIfZsI/BfTfoH6ha/FuKoFp4aGAnP+sjBWxBVNWgb6QtNPEgsu
	+SJi/3NemoX7xabjlf6ytRSD6is95AUpHAnLsefcFNO2QZjuFZp5K9mn7x+7bZI7cQBM1M
	1pGGOCFhHSt9PG+c8d9quAnQgYPi6zc=
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dY0DC1g6NzlxTSc;
	Fri, 19 Dec 2025 20:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1766177715; x=1768769716; bh=XdZxKJLVv/us0MhlURSAieVC
	/jzQimy4qD0cHcgmVzU=; b=iY/ltKNsXjZN2SOn/7Mgk2nBiIFfkhQl9wu1rxsY
	gqMl8gzI4Fdl7lRwvuyzu7BWqPG53SnYRBw92pU/YfkNHA1oj26W7lr6+j5RR0uF
	yIO6LZVQLnDdYtCKFJK2JKXsUbas5xX9N0Cd4MqfHLRdUuyQFIFHBeQ4g++xzSQp
	gU0eJDXxLL9HnDwtcV2Is8KV5H4vPha7HstD2vRL0jPgV4n/YaDhiqi6j32BHDhA
	klf/01+b+GILMZcS2Xt+ypFduBskYOaif+4ge3c/WrC+gq03AbnGqHj3Xw4Txc6v
	eiaB6hoDKfyCfX8yrnN20mCQbhQQgqc7PGjrVHpqbn8r2A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qbQZoCDMrrgt; Fri, 19 Dec 2025 20:55:15 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dY0Cp5nntzlwmHT;
	Fri, 19 Dec 2025 20:55:02 +0000 (UTC)
Message-ID: <81d2defc-8980-4022-a464-3d285aff199c@acm.org>
Date: Fri, 19 Dec 2025 12:55:01 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 17/36] locking/rwsem: Support Clang's context analysis
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
 <20251219154418.3592607-18-elver@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251219154418.3592607-18-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2C75F1C0016
X-Stat-Signature: qtnk93oc85xm66j3nrcxj7bp7q1rjdhq
X-Rspam-User: 
X-HE-Tag: 1766177723-83043
X-HE-Meta: U2FsdGVkX18px9Qtjn2bmiiLUHump9sqQ4LdocwORdNylwzc+ioSo51o7eBpm3NFAdlJ12980d0P9PxKUUNncezfbq0d87eTVeP9y2VW4yXOjuMs/vOMc8AikQwwsXDUUF+pU0vTTVHkXCZvdyL+vm4a1hTYGVM/ak7CJJVUGRnb8HZ7jtEjxSu8ou99k+Mo3qPYhYYORh2lKEQ781kAH0lXslprpUbDgT2JcAxwgY38LtZnYbxmyqqsH0YefkSxMviKt/TyuaoePnyS324DL0OinUqMjB2StBgcGAn2FHjaCSL+vH4o2Djf6kv3ZhEuOhlbY6yJlwgOYME7mcSNreUZdYi7lEEj1CjFNUb2zHHjol56ocB7kCJp0bI/s1DPHtp3jwuepIuQCGAoCZCgSRJQYQ6do1UcRjiHg70lcmpbfozBpiZtdusgqfKBnrlzQTPDuYbK+j3g6ckR+lDtBiLfpN+JMHiIsrPSRlvyGeF0ls035adHYENlX4qw3M8CSyWiiMmGgzLGRukqwkdZ+zK9Agtp7a64g+difevGi3DfdEddNZhWjWrY4pVv2E98/h+6WdXn2LxSOnW2lI3fslM28BlKmpODp02QqKeQsArq85T+292W+8QGB/E1hjR+4KJ6wl5slEx9+EYEwOwB4tmB07yJu+HqzFqyrvll11iUC5O5rFBepfWQHXjZhajJr1PNNDx286AATCQMQ9FGGT+HJ5utXMMFZCkTHh4v+PyZyft0Jzk8O2FV/xgm0MVRRIsEJUWP+vhNTuxgXH3c81pMhs7Qw3ORMPVK84WM6T+bp2+wnIcq+/Db3/A9Aw6zQAAdaSyHn+mSolXDoH8h5NRcv/dgATAbL8opb3wq5UpdEw17JvWdmdpBUqD6nn/i/c36uNYirn3ltDmBZ5/kNxrt1QT1yaaPh3u4urJlU8YoPAL2cZRrW2+sMKJwKkt2r9xGacJiq4+nzfbb0fo
 Gt9ZHuPl
 KcYzAM1jFfZIh9ZCxVAv/+/B9Ei/3tIrbVUSiOOyhMdV2m4cI/ixs69F4vF4qZruQGAQfxF2KdT7uF5JYQymzikZQBvLXJBU7BaCYnISZ7LtIUM0H2FGxm07VSp+bZD95pyeSR6cnMhdTLz/sVLRbqVsdcRIdXFJ2Og53e/QcJZf0M2BLbuPyaUrPYCz4zxV8Qr9KzuQlvqWzVvw/nItvWUjVuV8ydn4Z3vQc9y0g6Omn4YDnnoP/Y70KQWjOQXujG8r0JZ/MqSsp7pQcbIMsEwjhRR8E6tSvsMgafPTyOxGBP1OXQw/Aa5hdzqe7uxnjY2WihMUX0Xb/WPhnhoqT3mLXbjUVS+9ZtwMqZu7kAxeiQtGzCHI5cWwtpr9fmvzkk3UT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 7:40 AM, Marco Elver wrote:
>   static inline void rwsem_assert_held_nolockdep(const struct rw_semaphore *sem)
> +	__assumes_ctx_lock(sem)
>   {
>   	WARN_ON(atomic_long_read(&sem->count) == RWSEM_UNLOCKED_VALUE);
>   }
>   
>   static inline void rwsem_assert_held_write_nolockdep(const struct rw_semaphore *sem)
> +	__assumes_ctx_lock(sem)
>   {
>   	WARN_ON(!(atomic_long_read(&sem->count) & RWSEM_WRITER_LOCKED));
>   }
> @@ -119,6 +121,7 @@ do {								\
>   	static struct lock_class_key __key;			\
>   								\
>   	__init_rwsem((sem), #sem, &__key);			\
> +	__assume_ctx_lock(sem);					\
>   } while (0)

Just like as for lockdep.h, I think that the above annotations should be 
changed into __must_hold().

Thanks,

Bart.


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A385EE66882
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 18:51:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C01EC6B0088; Fri, 19 Dec 2025 13:51:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAF826B0089; Fri, 19 Dec 2025 13:51:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB2056B008A; Fri, 19 Dec 2025 13:51:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B1116B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:51:49 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DBF83160388
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:51:48 +0000 (UTC)
X-FDA: 84237114696.16.E64BA9E
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	by imf15.hostedemail.com (Postfix) with ESMTP id CCF9EA0016
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:51:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=DGiVeMQc;
	spf=pass (imf15.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766170307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PA/EzXjpJ9iY5HMhsPBqLPtFiBx7PkN32m/6FP5Ts4o=;
	b=Ft1J0/qV1+e5EAqZgsxvafn9526HLy4UG74yywq7Ip10kwsxAmQImABh/H0749AOEe7r2/
	ljiMWXUKiW6pOWAPgsa8LxpqF1NT+RIPNCHuK9wMH7FbfTo7wg42r4lC10GZsDe2YyHtLK
	Zw1pVe0Mn0RVvmypg7Ga4wSAfBSX+l8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=DGiVeMQc;
	spf=pass (imf15.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766170307; a=rsa-sha256;
	cv=none;
	b=ANN7vr/Krn9Zg9P0wZ9o46+ecUIvE2O7x2DPAL3H+9axM6vpI4g+q3rPZQnIL0St5xl4ld
	LGOw+NxgwdY3awitF8or1/5utcJ9l/8U0ugXKtttNPlc67Avf/v23mG4eAevaU7oqXDq3i
	sa4t71ZBkcizJwi4lN+U6Ti++XYSA7o=
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dXxTY58fYzlvwp3;
	Fri, 19 Dec 2025 18:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1766170297; x=1768762298; bh=PA/EzXjpJ9iY5HMhsPBqLPtF
	iBx7PkN32m/6FP5Ts4o=; b=DGiVeMQc27vIAkTr+oE0kIyoezO0CIZ3uglO3WtJ
	LoZXPEXhJiVO1JCUrScuvS7qvU+uRn6X+Kb7xZwlKMOgn2npeoIYNVY5uS1UYRJo
	JW8DigHXgILJKnHf4xx2ecGeuZdmV7atZxPWuGHzCIoqbXehZUidk6kSuTLRGG3S
	pJoa006KPcCxUTMPNW/YnCdN6+/o/0KttYQAp3K5VGbcN/mo0mEEVqBVjWrKQJtc
	BS7kDQHYw1E9oFwjlOuyxGCgejvmHM9N8pdC+zeULsamrdEnTacXamB2bUhMpRVy
	eWIW6WA1xRvLCO7HjuQsVasNbMeuVKqCE2VqJhnIBAO9Qg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VtZoOLR-Tx06; Fri, 19 Dec 2025 18:51:37 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dXxTB01wHzlqg85;
	Fri, 19 Dec 2025 18:51:25 +0000 (UTC)
Message-ID: <3abc886c-aa3b-4816-9ea9-b1b2e7888225@acm.org>
Date: Fri, 19 Dec 2025 10:51:23 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/36] Documentation: Add documentation for
 Compiler-Based Context Analysis
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
 <20251219154418.3592607-5-elver@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251219154418.3592607-5-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: 7x6t7tgyphmcc1hbbodi3gq5htpozsdp
X-Rspam-User: 
X-Rspamd-Queue-Id: CCF9EA0016
X-HE-Tag: 1766170306-830978
X-HE-Meta: U2FsdGVkX19oGhUmVVsJwZippnf7jTQBJJA1xoOKqoG/XjXIciYn2f0ejYcQH71/ntLaNAU09U3vweXKuMoyHOhQJHvQ47cVJ/Ii9cm0xz5yCGcJGyIi+Rs6hbGu8Elk9iCDu3DnucglwE9cZ4xYouid9L9a9j3NHN7qvdfFte+mVmaKALDSItn37OlZfjzH2LWKXqGM3qigEYtKM8DC1/EJGza+XiepR7nMkXsbl41ve4NjEYTK2wz6qNzq0JAbOEWMc6dWh7rQUjSLV2fKKSSBsztEQ8l9qvHfEWSKoUrvkfCZZMKkVM2GzuxRvZKMqLp0FlBHuy9FtK+CGCACb4tk/h4wCIZEg1O3Y12yixqo1SrQeW85sLMc7+NeIFOmBSDkTUUoqo/EYH/gXyX3bGqwRiBkMTihQYO8MRtHYioSrB3Ih6iz+7P/B3MNzM1TN33AtlIAIBvqkyDSMqFQgoUG0twztqjU+6GFw+/wBZEBolmPzpaqjqnkdbygNVSIyUwBCjxGCuedapBOmWkt+9F7OGKfIS8hIE5+zUbPIbpn5h4UJO6VYVR0lIQ/OfsLDqZ2cTFn2/qC6jgb2VHIA4mmQj5LJVVKcTpWNXxR6hNL7UWPg0R1yhuYF3YbYpKhMePveKKqbXjMze5EwyByd8e27hTjf1CORbv2XQqsWdfcabkPJGJMSn32guzIUdl6FrkvH+kr7h/xSaCfD+huZxO2VfyN/ktd6pR5/hDK7B33u7hul+rs8lZAVZ2r5p83pkCMNbp72F0OvnSNPUXeeQ1cYNQMobxF2K8eONiOlk7Bpi3WpjUj1JEj5BXLd4a0Jw+M50/RF5XaHJizq/Z7D6tFolRWyYAIS+ZTlPckqPJXM/NSYnWOeGg5zUel3prxB6nI8L1Z9lXRwIL7NIKxPWqCLJ414G/Gss29JnivLz+naoE4dIPskDp8QYMMx2QQgXzjrLPoW6W5Njn6aIr
 YXtG/s2f
 WB6nZNPQ3BGcLUPolJ+ef2nEJOTF2mxpyV58wjg66KTMHwoTYkApYSdRF4jYDZIh6b9J5yDBboQCOddL2O47iKkew/kg/dxpRisFg3rrl3WxtmLw+WIzgGNA5xMDBx/uL0V7Fj/uj7X+sPxDqkK1CKQgtcd08BjWzAfo1nFQG1JVljyP66oYyfv7ipzqnGvWkjq00Nyzlg8WYwJxuxEU+PjLs8sF1VmkaFP3lILFli5h1/+45J+SJmBIjs3BsYeBP5WLvKez2Q3VhUeL/NW4W6o4JuP4ZvNiWRO6yuiIZDRS6Do/e473gelmUy6EIal1xzyM7dd1U5A/gzxsfySSXgd+uG1GzjSFNTfiWbwDjzMhHdtvVaZgoaNU1iKKDiOFFhEcSNI7qQzFOYaskkDatRiuCnPxKv30wkQvGsQbHM43L3UGp/hvmzAkjmqFjMVPAoDPCUHBs3znjvaA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 7:39 AM, Marco Elver wrote:
> +Context Analysis is a language extension, which enables statically checking
                                            ^
My grammar checker tells me that there shouldn't be a comma here.
However, I'm not sure whether the software that I'm using got this
right.

> +that required contexts are active (or inactive) by acquiring and releasing
> +user-definable "context locks". An obvious application is lock-safety checking

Please improve clarity of this text by adding a definition for "context
lock", e.g. the following: "Each context lock has a name. A state is 
associated with each context lock. Supported states are locked, 
unlocked, shared locked and exclusive locked. Functions can be annotated 
to declare what lock state is expected upon entry and what the lock 
state will be upon return. Members of data structures can be annotated
to indicate what context locks should be held upon access."

Thanks,

Bart.


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A339DE6688C
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 20:48:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C22FE6B009D; Fri, 19 Dec 2025 15:48:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF1116B00A0; Fri, 19 Dec 2025 15:48:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACFB66B00A2; Fri, 19 Dec 2025 15:48:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A00D16B009D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:48:05 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 65782135C67
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:48:05 +0000 (UTC)
X-FDA: 84237407730.05.DEF9086
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8CCD820012
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:48:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=yvRF6QOZ;
	spf=pass (imf03.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766177283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RpTDLGmqmvX91HRlulscWF8eEEmxcYbVfxnBODEf7Fc=;
	b=VyRIZ8eVc2Nmkha05DMTDE2GBTflwLIkt4Q4RTutbkLER4ouGRyIA6TGZGviAT7x7gkMw4
	rhHFNIkXjrATd/oN8sseRCbKIg5gO5ZwUHmTSi0/8H2Y6cMDeRXraDVS/7YwyTJo4FH4AX
	V5ZG6+IK3vwQ1MSHehNhySAUzwjyyIs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=yvRF6QOZ;
	spf=pass (imf03.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766177283; a=rsa-sha256;
	cv=none;
	b=1vFnSnD7JXy+KA+jrbyFtATa6RI8Q++CCVPTix3cR0IGc0qKXPXAonRJg9oOm+W8meMAXd
	8OWyCmYw8VjSriek7yifDJVcimEBC3Yq0DWtLSVqTtAneTgv/DYwDr9jBD1QrajOrSRuxL
	IhlXJjT5/XjBX9o3x+wxPMsdAtlC0bc=
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dY03k3PBFzlqfwx;
	Fri, 19 Dec 2025 20:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1766177275; x=1768769276; bh=RpTDLGmqmvX91HRlulscWF8e
	EEmxcYbVfxnBODEf7Fc=; b=yvRF6QOZG6UHkzlDEI+784Z3F6GrQK/qbhDhyH/q
	M0VmZ1z5qrHfAYDtPV8Dk/4in6+gahQxa1lbZ1Jo6c9wtCyIYJGMKW//Odp+W+WN
	kP75zw9/8DlRJ+zhV6IQnwokulJ8QNP5RFHBufnRbn7Bu+UomFMF1zl0CcA6lGHQ
	qNkHLoupGo+gAFxdviBTwFsmv7lpmbSZGX3B0nYorvFBAjGXtIEDutsEekW/XB+L
	aBqbyKoEpOUB/D4Xqjq9vrPvyll5guVFPGo5cn7XZCahnqCDjsHt/bWPsvysAyBk
	i+SiyJwUkfkxqvnCbKDjxUarusC1UNbaLpXOezGEXmcqGQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RwSAk9NGYx7Z; Fri, 19 Dec 2025 20:47:55 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dY03N45hpzlvrT5;
	Fri, 19 Dec 2025 20:47:44 +0000 (UTC)
Message-ID: <3b070057-5fda-410e-a047-d9061d56a82f@acm.org>
Date: Fri, 19 Dec 2025 12:47:43 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 13/36] bit_spinlock: Support Clang's context analysis
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
 <20251219154418.3592607-14-elver@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251219154418.3592607-14-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jr9rc4sroj3uyk3f3jgzxgqxjkrqdfe3
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8CCD820012
X-HE-Tag: 1766177283-724515
X-HE-Meta: U2FsdGVkX1+qmQApOjvYGN2kDqoymyFL9f9/GFyVCI+PQglvTqoUM9J7zS70MkGiuB49WMCZzR7ydJgBTma8ujlt+PfkROKl+iz6A/qiSn1+S3sjRhQrVSMcH+qLL6gwljZzydrCiAcAiRhQBF8ZNG+ytxhs5VcS2MBdkzDcrjCS/XK5kuuzQ7q7isbNtrqDg8gf7x9B/flvMnxF0Qn0Q8yQwmOBbDyBtmqIn+n/kBOzLyaf2j3J+W5TsiHQ/JgHjtb0NvQZ/7nOdaYxlnLjsu8pjoGzrib9P75x23EO0g97vBS0yljTZCIip9Z6/Slml3Bt0PCTRPSc3tN0Fb+eCDnGdHekQGIdjCTE/ipZOdmUQHgVKvcklxeMYibee+G1tGs713ID+3CpcjaAz8C783NUW/O6QZ4iQcnIR8rfqqgNF4QZfQ7diSclyUOsOk8JgKrUi4gri/p/d1T4eLkrNSiDkFFUgo2VP24mWojAv8YxiNhmOPerfltnttBczhteFiRc7awiTG1v4veTLQqsape60Vdp9xd1lG7xpVx1aG7wClW2h16TpIaCRGIRw9EPAH5yvP69xgujQR6v6Xnhm3IISIb/HMzrOVoK+OPmTLwgbZfbq05VYENPgG2M314ByIeQp4SYoM8Q1PwuWywpEXEs/wSGEjVhEIposaZ6o8F1W6JMp2Tlqgb6k1MQU6PAfmrO0DRDPZRXpdKGk8UlgarjJBiDa9IWm3XyTGVAttjpTH9f2qSfsGHlinyEU9HBqbgJI/pLlIYwwLHodTvlYQ0NYApHY389t75cEIcqmBenp8wpIr0bpUa23HDPc3juRm0k7ljkNfs94kT4CIrwhHq/rXoayVRjGHXvHVkYGNZptO5FwNZGrCU34LDVqLbdvYkiWFh+xtGzw5kmyB4XqK63yofZXkx5fo2gCK0tYpEVm76gFzSIg/z2aDAouNhQ/HgOeIsPgWotG/MIqbJ
 ZM0DnvPP
 Vy1UIkGYeeTnsZjcUK+/UW0zEEN+vDTsSfiUJG0mPeMJ7Ta2v312j6oT6GTwGI785wzYujh8kHxnutwG+tmk8xbx2YEEyGa0M5nro2bkPfmVgzLI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 7:40 AM, Marco Elver wrote:
> +/*
> + * For static context analysis, we need a unique token for each possible bit
> + * that can be used as a bit_spinlock. The easiest way to do that is to create a
> + * fake context that we can cast to with the __bitlock(bitnum, addr) macro
> + * below, which will give us unique instances for each (bit, addr) pair that the
> + * static analysis can use.
> + */
> +context_lock_struct(__context_bitlock) { };
> +#define __bitlock(bitnum, addr) (struct __context_bitlock *)(bitnum + (addr))

Will this cause static analyzers to complain about out-of-bounds
accesses for (bitnum + (addr)), which is equivalent to &(addr)[bitnum]?

Thanks,

Bart.


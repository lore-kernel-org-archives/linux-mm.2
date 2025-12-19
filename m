Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28FE5D78770
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 19:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 811A96B0089; Fri, 19 Dec 2025 14:00:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E2616B008A; Fri, 19 Dec 2025 14:00:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70EDF6B008C; Fri, 19 Dec 2025 14:00:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5E8B46B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:00:24 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E6EAC138D7A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:00:23 +0000 (UTC)
X-FDA: 84237136326.04.93E8163
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	by imf26.hostedemail.com (Postfix) with ESMTP id CB28C14001E
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:00:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=UjD9F4cw;
	spf=pass (imf26.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766170822; a=rsa-sha256;
	cv=none;
	b=Dbx0heqGQMEBuslQtR+lMdazoMfN6XqibKb58ID6ixEq39/g2M2PFVKJgS0S3RqmGQmVev
	vKw2YMQE+6/GjJxw2MrgIsEhGp+CIKEj2uL2rrDyprfX49jJk02wQIEyclVLRGdFvvZMaI
	0eWlshLafDHBi9m5DnVXWV4YjyaEdiE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=UjD9F4cw;
	spf=pass (imf26.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766170822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ePVSZjUMvM5UwcnAVR7UWrqjg1Vrw8j5vSX/Uk6yy0Y=;
	b=AU1MhBOCiXSDsNKTWpV+T+dO2BIClIVPzlRGkMspY+G4zDEvFgmVfjF553gBvEdo60gsKG
	ZMYPI4eSzj7AH7qEGL1sSfli8zwrJuQgZ1rP8GK9pn2aV6oA1no3y5RSErPNvCWtTaktmM
	mzIDRLwSkuHal8eWYFnqLfuChtgA6uU=
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dXxgS5FtLzlvrT5;
	Fri, 19 Dec 2025 19:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1766170813; x=1768762814; bh=ePVSZjUMvM5UwcnAVR7UWrqj
	g1Vrw8j5vSX/Uk6yy0Y=; b=UjD9F4cwVPH0tWHDaelPuqlhc+2YTxTbndSefpWT
	po3XBept/JAFVJlKDP0H+iWdyE9vzebm4zie+0CTa+RCNEdUNPw56SgQTVCCE5Fe
	VVrq/ZYjIVLlOn4zsgLjPAU6gEetYUkmXEx+IlbFWuAQjhniwyCqudbL49xsJV5s
	V3fezX1THeOXM767I+teAsn088t3APhcDxHPLaXnNFkoJuGfEOlrNd4Sc41SvPmI
	He5W0DOYCpNqfvJ6nHco8LxDf8cRtI39bsR3f8T3akCr/vM4Ao3/Y0X/wqah9zGY
	cIse1t6O/qxZcmsN2ajDouGqT+5p6mlzod3Nak5uvCrQiA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id XxrjPaU1Y7x5; Fri, 19 Dec 2025 19:00:13 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dXxfz4M91zllB6t;
	Fri, 19 Dec 2025 18:59:55 +0000 (UTC)
Message-ID: <1df1695e-778a-45da-9348-61f9ea34a862@acm.org>
Date: Fri, 19 Dec 2025 10:59:54 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/35] cleanup: Basic compatibility with context
 analysis
To: Marco Elver <elver@google.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
 Will Deacon <will@kernel.org>, "David S. Miller" <davem@davemloft.net>,
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
 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
 Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
 Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>,
 kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org,
 linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
References: <20251120145835.3833031-2-elver@google.com>
 <20251120151033.3840508-7-elver@google.com>
 <20251211121659.GH3911114@noisy.programming.kicks-ass.net>
 <CANpmjNOmAYFj518rH0FdPp=cqK8EeKEgh1ok_zFUwHU5Fu92=w@mail.gmail.com>
 <20251212094352.GL3911114@noisy.programming.kicks-ass.net>
 <CANpmjNP=s33L6LgYWHygEuLtWTq-s2n4yFDvvGcF3HjbGH+hqw@mail.gmail.com>
 <20251212110928.GP3911114@noisy.programming.kicks-ass.net>
 <aUAPbFJSv0alh_ix@elver.google.com>
 <CANpmjNNm-kbTw46Wh1BJudynHOeLn-Oxew8VuAnCppvV_WtyBw@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CANpmjNNm-kbTw46Wh1BJudynHOeLn-Oxew8VuAnCppvV_WtyBw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CB28C14001E
X-Rspamd-Server: rspam04
X-Stat-Signature: 67o1qguberibs39op6xz1o8ysrdaoh4c
X-HE-Tag: 1766170821-254956
X-HE-Meta: U2FsdGVkX18vFLNehQ1RNqwt28bShR7KcXmTMj7xWgFv/6sC0EVZT88b+kh4uiPRsvf6jCGx5O+U3ejcJ8YfuaboBnKFrITOQl2oVdGDOuteG813G/jusYFrTPfS5cLw21SwfWxrkqjPdgNfmLocl9fMntaqSEqlWKcfCmVfgZu2nJYBy57wTvv6lMEJ6mCvixlwroFjjiZTNsp8diJgrfFmbkHeNZRR5omgocwvuup4LxZlUiERgkrghUim8TNnjYCaiI5gJGWHoI0QaFn0/dTmp72Uzz6FF3C5rrYX5g7jtXXEp29Vp/4eimQ3/LUC72E+KVKNeewSuk0SJqlI4gGnNFP74VnuZH8/bImz8n9YgPH/vk39w+Jp2tux+BaAxV27IaQ78AdOCzV6t70qB53b+hnQhzKlWIH6JLJxTA7QLbfU0/e+tynHwsgU4w5sFJ7Onin4XO7gseHeK9sEBodG0xrjmfcVxggaDyP+/g3k0L+0i5G3rqOFVVymyrI8fQ0bqc3T2tsv+tIiKa5U20pUX4BLEnsObOhigOT2/Pdlu3u0lIwkHwSVGeOzQoq9+KEkeRsIJHS2NTnSre+PaDxNoS/So27DCrtbXdOUs2AJV1uFJstBSIgYvmObfanQ2ZSB/1UJC7fuVhLk6v8syVV2tqycqUeGYRs9MmqoiDFlIe8MWjvjGzD+iyeExfUelDAjFqZ0JlVdqqPnHurL/me17jVd730HpF3wqUghGUOeD4f3bQE0ZCQfzHb12UFm1wxzS2E1rzNGHsz4i+nm8XhKhf5qa9g6wLv0XjCLJIvRzDZj6ThPhMWIjw5r1f0jWPA9uQUTKJcXMyP4pR6e44zxf8M8wYfuA9Qw+uliQJmq8Ho+MGxRAiqWNTsz37A/dW1OBt6ROKxhBrHzXwcc18FmShm8Bt8licSssK5hMOYgSRDuqmSnN+jSwdRmAY12A+HEdwjdQZxpxWaXVeM
 C64evSTc
 mZ4+kivVjN0waLQ0ya1A8qCdndCdRdX7XsPi8YbsZ6ESxTThk/vvGBMypm8aXi9oagYdIgdEIu9K9wQw4j7+1a2g8HUStLCfmlKtkJp9zRSujGh8ficYO1KD9y7LqIe2rPlBILIjysOork/8IVVFQJrOzgwny3pSjFNYIkgFwWSLhGCfIYKr5f77PNu3lwMQVHOn6G7dAagGqAlNMVFPIbJlWzCosm7lCj1sxXnDxyyNdECXe/xNtmfLNNwzBDZCKHycbnMHQjtpGcGpWcKLnChFt9MYL0mhUojtQ5SX9mRybsEdAaBrI4eL/BEIsOE2r2k3XfNIfGQP/it6SV2GOyijHXz0uME+yKU6W0pu6tqk7uU1CPueu76uVWx2uhYKs8Yjs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/15/25 7:53 AM, Marco Elver wrote:
> For cleanup.h, the problem is that to instantiate we use
> "guard(class)(args..)". If it had been designed as "guard(class,
> args...)", i.e. just use __VA_ARGS__ explicitly instead of the
> implicit 'args...', it might have been possible to add a second
> cleanup variable to do the same (with some additional magic to extract
> the first arg if one exists). Unfortunately, the use of the current
> guard()() idiom has become so pervasive that this is a bigger
> refactor. I'm going to leave cleanup.h as-is for now, if we think we
> want to give this a go in the current state.

Peter, has it already been considered to make the guard() and
scoped_guard() macros more consistent? If there would be agreement that
guard(class)(args..) should be changed into guard(class, args..), I can
help with realizing this conversion.

Thanks,

Bart.


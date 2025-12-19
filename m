Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 677BEE66890
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 20:38:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B98996B0088; Fri, 19 Dec 2025 15:38:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70456B0089; Fri, 19 Dec 2025 15:38:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAF5E6B008A; Fri, 19 Dec 2025 15:38:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9B7896B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:38:55 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4A3F8136EA4
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:38:55 +0000 (UTC)
X-FDA: 84237384630.07.35C7AD9
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2FE241A0003
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:38:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=23ejbMoW;
	spf=pass (imf19.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766176733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M2FKNH25BsSSupvqYh8XNhufT7PJPLlufiLItK/K4/Q=;
	b=JKbeaDe4amST8cRdvreMHTgCHRnLAl12KnXkEI7Tc4YT7sImMaM31ydsbOoBkcY9fw/rsT
	ud1n6pnIssMz4s6oE3AYr8N4itPStHKLNTjUXnt70AtX6/47SsXCWpSJwqVdCXiqUG+N++
	lJfWEZ3q8CZlSeMD2C7FU9wCx9BzNS4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=23ejbMoW;
	spf=pass (imf19.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766176733; a=rsa-sha256;
	cv=none;
	b=AQfGdCg0A9pDGC8ZR7XhrXci6h0mliOjfSDn8Bs/zjKR65EeV8H4SPuioH2RwggSBDJTI5
	OF6I/NAH0MbVKQfcNpDlG45QyA91zJ/xAFcReMGOgcXJC5geK1QNYG3eWT8KfLkRgJdBuS
	mpouEfwU557Ztnz1JLDTao3RPbrGEbs=
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dXzs815rqzlwqPy;
	Fri, 19 Dec 2025 20:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1766176724; x=1768768725; bh=M2FKNH25BsSSupvqYh8XNhuf
	T7PJPLlufiLItK/K4/Q=; b=23ejbMoWSMGXSBFPZlmUzRtGna4H5HROcPKMbUup
	V/WdRBWbup4GDNoX4ZzYi/+9a2QxQyjFpfuEdRS5ewl/8ts1Xxp1RTcZSs54u6Ol
	V4+ys1ry+a515MDuanbl0Ud7DP9g1ofFdkwrrR83EYCeIoXuBBDi8v0Mx6Otj3WI
	eXu2aS2vAeC+/lTfWViepaxFvMNipVgj+00o7/6Ytj/CfDmAbV43JA319Vk62LAg
	y8BnF8cLm6gyyRXsKaD6m8R0XZAZMGGmDVyQ2i904nnISBAr0ieu6hnDNx9oLGke
	a0C4gG35l9QIBTC0Lq9pBQ+IlBmqQe7BkmR8IZhBjfK2WA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id MkJHsfOVfhWT; Fri, 19 Dec 2025 20:38:44 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dXzrm6hBtzlwqPY;
	Fri, 19 Dec 2025 20:38:32 +0000 (UTC)
Message-ID: <61037092-ddfb-4504-9351-7f6a3e5e4616@acm.org>
Date: Fri, 19 Dec 2025 12:38:32 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 12/36] bit_spinlock: Include missing <asm/processor.h>
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
 <20251219154418.3592607-13-elver@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251219154418.3592607-13-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2FE241A0003
X-Stat-Signature: 8hpd4jqaj7f7suubzj747784z4apoknu
X-Rspam-User: 
X-HE-Tag: 1766176733-989372
X-HE-Meta: U2FsdGVkX1+0J91CBA4ViO6qQztR4vLh9BLKtsQeb9ewmQrRlFaEPkIlrwdHcXNL1rn0+Hu1/eoTpmLuT6pP4HhWtHffb41u0xWRqLhtQ9cymF3DR6mIBQ/m1F4RYVlo9lKKffQaOYBXM1u6kruNbLxN17UQcnwhpA0cOY2ADqY+UUEwI7KLZwblY6SbphasZmoedw7t1yHvGF5H76SdALbXlqlB3fBOtJ5S7JoGlRm5qJx4zldEp2zHf7joSc7IIsxndR5q4wYQ1KX30DArHAmSAqFYBV3xULdSEB5ZE0TD5tAlUlDWd07hLa6HUEeTu/ETE+PFdjl2UdfRQZ5TfrXg6hz+zcvyyuohgwMy7edL0gkuPRoOKzSqZuC/BDukF2vnA8ScZejoHAEohEWbOo3cjkkyaFn6fBaA1ELfs4SbXfHIRGqUthTCHAXOluwSPgq3kMh3Za316z+pnbLN+CY1FtT4iowpGqkwKLtvHSK8hMLXw3unPGzWdBkAM6hewZ8UYEqNozwuETDDdxyMCm2MCmXq3oYMSo6r/FzHvm4TX0yl/gxGp8Bujtxngjkpz2L9pscTH566K++QUEb0P9PIq1eNftswE8KflzIB9BoH8L9rL3gu9+9iV4R52BWU3nOEe0jOrAj9AqOdkpIpo45AIhAL2vMdvcC1XbvyGHSz2o2QbVBkFBwO7LLPqum6+kYrUW8SIdE/vWVnnH7DL5vgb/wOIq2mTCU/QzVnzF6TFkHH2WJdAf3IpjZG3rO2PJYD+7puf0QfKnAnlet0K8ZAJjI7O2qRqxYuc10R3EF35rdF9nOpu1OeEJ5vrm/R+BRhnImCaOicuEOPsgRSx+9v/aBVhjzJ7AypkQU2JpV0sSgi09FWRQtfG1Owm5ZOrcJ/hp52kMwKHrt3KQJESt9efF2a/rrceYnYGWsdnoIUOR/H/kSH6I1/pBIudfLkWXLCpcHw9nfOv7MiGBr
 J55rGrON
 qsq8UIUEkUO2P+5fF1OnN2PaKG1L3kbjcWKicwYBLKA9PwUYKvUMQiJo2CD5lHPT+YVdcTESh53JDw+anpM3bYUIMvT5hdYyZWbVjKRk2k2xUzITD1+FCz9GDJZJ9PGHv7xv/X5aoEu2ht2LfXX6rnUD4SfB3Zi8tSCAI84hag1y3jFmQ4vn0hvICyhwJBVP0cDR/wXr8uEyXP/2wXy/U5x7P7NCr0gRkYKrs5pjU/9AJDaQyFQnaegCS4fPxm6G0Fxh4SJpCM2S6a3vWMpihy7KUaawl6Bs1LrSSGtZRDdqlNbs5xQDUdsADeUuRc8DyTMUMaCh8q1LxNHK5UKax1JqjU8yQhdB1yzRrKOvzN3rUIqQAgBKp08fexLIR3EzGUbs7XGQJ7mb9WxGk2RmpNaiHV0i08KXHEoHdh/ZcSALT2CptImAByntSQVtm4AbSoKHyUW/HFtEcnbjw9bALANTgemHPosiPdOC6Hc4MYXas4UBIZER/Ux2F6RKWNmvwpfYq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 7:40 AM, Marco Elver wrote:
> Including <linux/bit_spinlock.h> into an empty TU will result in the
> compiler complaining:
> 
> ./include/linux/bit_spinlock.h:34:4: error: call to undeclared function 'cpu_relax'; <...>
>     34 |                         cpu_relax();
>        |                         ^
> 1 error generated.
> 
> Include <asm/processor.h> to allow including bit_spinlock.h where
> <asm/processor.h> is not otherwise included.
> 
> Signed-off-by: Marco Elver <elver@google.com>
> ---
>   include/linux/bit_spinlock.h | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/bit_spinlock.h b/include/linux/bit_spinlock.h
> index c0989b5b0407..59e345f74b0e 100644
> --- a/include/linux/bit_spinlock.h
> +++ b/include/linux/bit_spinlock.h
> @@ -7,6 +7,8 @@
>   #include <linux/atomic.h>
>   #include <linux/bug.h>
>   
> +#include <asm/processor.h>  /* for cpu_relax() */
> +
>   /*
>    *  bit-based spin_lock()
>    *

The abbreviation "TU" is uncommon so it's probably a good idea to expand
it. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>


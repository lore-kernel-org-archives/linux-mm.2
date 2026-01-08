Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36470D185DC
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 22:10:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8959E6B0088; Thu,  8 Jan 2026 17:10:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 843976B0089; Thu,  8 Jan 2026 17:10:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 725AA6B0092; Thu,  8 Jan 2026 17:10:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 627956B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:10:49 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E8A9C13A88C
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 22:10:48 +0000 (UTC)
X-FDA: 84310192176.22.05E1B06
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	by imf05.hostedemail.com (Postfix) with ESMTP id 187B8100002
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 22:10:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=y3DnIpMC;
	spf=pass (imf05.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.14 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767910247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9wcZSTi8w0Set4rh18vUE4zPr/D6QOeIA+Se4D2Yz7E=;
	b=VuGDvZnUfXtxvWsh0Z+93sq1rdngKAcOQcMpfKWVxV/EPWiQ6vK/Vz1Clj2+YwAaB5yAF0
	y7qwJivYtYlvGSxntGQwO8yFKN0e/edV1Y2ZYtgwnVZgRoygivoMgnqViqPg5/RKMusUv8
	+hZK8G/M4xrH+X4UKY+PZoydmGZyFZU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767910247; a=rsa-sha256;
	cv=none;
	b=ekex93uBgyVK0HBKVWUp5cYa/zk1DHPKQ0U7ZoN3oo1EHfSJ14KL3M8fO5uWjWwHKAJtba
	zdx/A3/24skaew5ycJuvV2xh5wbrZFOdQ+SOZNRWmCr/RrJBC4BDiOkqDhlJVivcQDAgPh
	JcAyJXVwqqbKWOA1Ucw4wKJ+f3QRUZQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=y3DnIpMC;
	spf=pass (imf05.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.14 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dnJxx5cFFz1XT1Z9;
	Thu,  8 Jan 2026 22:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1767910237; x=1770502238; bh=9wcZSTi8w0Set4rh18vUE4zP
	r/D6QOeIA+Se4D2Yz7E=; b=y3DnIpMCSQnKfEQcNUdJmBRbcLno92oeKfo+WMYi
	GH7blNKN0irLymfpBF3Hg2QDn+bUOND9Ph7+2f+3JOuxuWVyZeHsX/eUX6nr4u42
	Xo2+GsL+38yL5abFm2PTOhHHNbpFxaViFrEYePNdHtMs7t66UhI3rEcsqAbQ0git
	yvIzwW2Puf3sh2g2Yh6ypqckaBLqa3pUBV8iuttx96qnQS6WndngwpK8KdYd2a1p
	gWKipnbDHZpiaajmh8SgTT8KCPLDjeAtbIOlGRsmWTvjAkHdDpnNsQrr3OZChyg8
	yuKl6RyxlRCmlJ0VSvSzQ99QFu2RTNvj4T9gnBxHCvPCnw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2VIQQt_5Aq81; Thu,  8 Jan 2026 22:10:37 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dnJxZ1xlYz1XZYyy;
	Thu,  8 Jan 2026 22:10:26 +0000 (UTC)
Message-ID: <57062131-e79e-42c2-aa0b-8f931cb8cac2@acm.org>
Date: Thu, 8 Jan 2026 14:10:25 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 10/36] locking/mutex: Support Clang's context analysis
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
 <20251219154418.3592607-11-elver@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251219154418.3592607-11-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 187B8100002
X-Rspam-User: 
X-Stat-Signature: tiss77o4i13awer1s71gswy5u8eu8ehe
X-HE-Tag: 1767910246-626011
X-HE-Meta: U2FsdGVkX19UAY1Mn20IbSiI/z0WzQ11NHyFPG0rSE972pGwmPXCmIJ7Xfnuc038MQsbeZqP6CqTjMEHSZqMZM/5KA2R7a6lfHnsCdA24GHEbCCFUGRqtaUSqPL/CRuStIEHcgbmAnsevKA3RQ8xRayPKMPVbM13zehetoZOckFH/abDd1jB2y7vtdh/zO1yGG9HOMGQYSo6uNXkOeJWiMZmPTCrxJbomaBh8/XZWIg7nFfSlAHpyAvOhuWonAL+AbPLZGHkNHvscjnyS53haau0I+xntIkkYuHRf/EIGz8OfO/uWQgQVSCkZrFfCBFeI4P2/kGxcdMhYSIjLB3YWY7lQPO0fTVAmNAu5V87izU4v3kXnv1kzQS20T0PERtUTakN5oj91N0GIph806jhxsGbYEGRs5chgGb6ozZwn8UlOMWM6ms6ZrNAp141X0RrTDemVnsnSKQy6uWqquVVZ4nIYnvd6MmAE3Vae1O2oyBHWNoa/8urqoBsOoO1loH9Fph8wxA4T8wQDAfCW+L5wcL626egIhHdLXy/xbj79j4rVEXnFWcDYjByClI4fodpJko0kclWO9ezBaIgjEL0QMaXG7WX/UDgbaxHERh/H3naflDbIw9UlqStobnJVctPIZ8a0zkuDly1woMzTyK8ytqEJ+P8OV7FV9ejsRaU94cYh2Mw8eAt1YaMoH0p/PVjOk5kbeM926FE38vKkTe4Q3zBnQ3BG9QJo+nUjPIAIDluG6WRqKseUVP99b5ynr6PPBnHmFiP6KdwXHlPBpAODS1GfblgeWRYTXxjDZgHke2JzIMbbGkvPTIX1tcRI3C1k2gw5gjWCQ2EeDdBk4svz5N09ZOmDsfQWkX53tUZT2VwA2qNBVCr7HX2QKVxiUnWjJXLAA19BrCBL8rUtjyaMdTJWbGc8y1Hr44YsKQjUf1dR7lBCJW7+YFBHfnaSPEMBr1JfDLg/J10yBTo87+
 yMR/kNp1
 s4F2WosHW/4zGpLYBVA/qPEZik7QrVympe2ZW6nitm9qX5yNfuWzxEgqXFrm0nm/1CCXh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 8:39 AM, Marco Elver wrote:
> diff --git a/include/linux/mutex.h b/include/linux/mutex.h
> index bf535f0118bb..89977c215cbd 100644
> --- a/include/linux/mutex.h
> +++ b/include/linux/mutex.h
> @@ -62,6 +62,7 @@ do {									\
>   	static struct lock_class_key __key;				\
>   									\
>   	__mutex_init((mutex), #mutex, &__key);				\
> +	__assume_ctx_lock(mutex);					\
>   } while (0)

The above type of change probably will have to be reverted. If I enable
context analysis for the entire kernel tree, drivers/base/devcoredump.c
doesn't build. The following error is reported:

drivers/base/devcoredump.c:406:2: error: acquiring mutex '_res->mutex' 
that is already held [-Werror,-Wthread-safety-analysis]
   406 |         mutex_lock(&devcd->mutex);
       |         ^

dev_coredumpm_timeout() calls mutex_init() and mutex_lock() from the 
same function. The above type of change breaks compilation of all code
that initializes and locks a synchronization object from the same
function. My understanding of dev_coredumpm_timeout() is that there is a
good reason for calling both mutex_init() and mutex_lock() from that
function. Possible solutions are disabling context analysis for that
function or removing __assume_ctx_lock() again from mutex_init(). Does
anyone want to share their opinion about this?

Thanks,

Bart.


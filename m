Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57D6AE66892
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 21:06:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CC796B00A2; Fri, 19 Dec 2025 16:06:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77A2A6B00A4; Fri, 19 Dec 2025 16:06:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67CAA6B00A5; Fri, 19 Dec 2025 16:06:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 541546B00A2
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:06:21 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F090E13263
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:06:20 +0000 (UTC)
X-FDA: 84237453720.15.80BE1C1
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0A5F4100006
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:06:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=biL2fFLA;
	spf=pass (imf14.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766178379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=smhZ+HMOPx/2qzqSsA1Ia7Ur+56UUYwNTrJDmSp3Lho=;
	b=IJHUjMFfoYh3mg7ajM+sbUCOOU70TshBKG3VI0KsCfii1ry4vldo+rMz5UDKpoSPgwPG+T
	YCfhNM4HynSQOYwN65/x0OUZk+n6WaMmvhtQTxpz6AVBOOi+2iPMOrrl1ql6DgLJxmpT9T
	lbIvqhdmto/jqbldZZ3YtQ46iOVRlHs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766178379; a=rsa-sha256;
	cv=none;
	b=Zo1gk//U+4GcZxw8bTq/olAiY5YkRPdLWTg/nFQrxMtCn7H3YcyXABLXPTVTTyWPMDYE9B
	WwAixLtBXf0Dt+DfWlkNzkbfE36OnZet5nfhbOHpNM+YY8/x9R63D8OAvpipOQPW8ztaGz
	XG+wwNo5m3OuADv19wI2GEG4BfbdXvk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=biL2fFLA;
	spf=pass (imf14.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dY0Sp0FgnzlwqPk;
	Fri, 19 Dec 2025 21:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1766178370; x=1768770371; bh=smhZ+HMOPx/2qzqSsA1Ia7Ur
	+56UUYwNTrJDmSp3Lho=; b=biL2fFLApXPBmQ8TkRiQaN7joqG7DMeHj6mylEkD
	tBlkgGUzRoC9PLYlhABCpwHU2kS/gcSVCoHuSawmvmv9A+1ZB6+DzaHAtAtJr0Vy
	Gaw2/ivM9zN+LSh5+NNmhdaNX0vgalSYo7eljPfVpvrgPReDXQnD4sdGtTGVaz9z
	Umt7RruBkXjgNb6vOZRtw7fRLVHhFXClAviuwN2fuGGoSbXWAzM1RGdqWYqf2Gnq
	lkb7sLgp+Rc36kuO9w/2+dhSaDlkra7TX68tuxqKu4/a6scJfx5XonCslZVz57gx
	Ubj0Ir+QQt9kHEnwxXlB8oeIRqIUDvcEmp3KYmWisFVRDw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id EEu5ZjhUq7eo; Fri, 19 Dec 2025 21:06:10 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dY0SP39w9zllB6t;
	Fri, 19 Dec 2025 21:05:57 +0000 (UTC)
Message-ID: <8086c568-9386-4231-b928-3e887c8679b4@acm.org>
Date: Fri, 19 Dec 2025 13:05:56 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 22/36] um: Fix incorrect __acquires/__releases
 annotations
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
 linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org,
 kernel test robot <lkp@intel.com>, Johannes Berg
 <johannes@sipsolutions.net>, Tiwei Bie <tiwei.btw@antgroup.com>
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-23-elver@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251219154418.3592607-23-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: inm894rmew4mstk3ukt3nzpbnhtasufw
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0A5F4100006
X-Rspam-User: 
X-HE-Tag: 1766178378-877349
X-HE-Meta: U2FsdGVkX1+bQLuSjIjAXD6Ta6YIyMeoDOaFMTmwmECs55K4ZeUJNv8D1Q7erFLeuZowf9xnDlTT4N2+XCUptXrUJryT/9c3hCYY6mC7srqu0rPooMKm3dapeiqmrlSSViEhi2aCDGFJutzYFgMeOxVfazWgPsS46Af1H4z7mexXPrScUeQVDsTmuxoGWw+soEz3xvBN+jPDKNjSj7mwx+B0/FX1++8iojadw4NSvB/Q7uVJHEU8jZrRtakcP1P2QUoyLBxxKCKsTkYzxw3wN0GGBZ/2YG+v4dTR+gLJKNS6su1OVU2LmLuwkjSx7nnZRk3ktlvkwUTMY9e+OMff1+K8h0XYdyIspy/UJlh10DpBgV1T6IB8Ff+CR+SOtb6G0UeL4eWz7eFq+cEth21c4eYyuCI6RIbVDlxtMnuwVYF6MYHEQi/Tf4cgEKEdYl1l3JwNp7GCT+L1Q/Ekn8ncL2jAcbTOipLzAbHPn9FJ3hK284fezqlqnpGuz09oV7MywKcEgB9UduspXL12bzJYcLA8386EySvOhPp3Bo1cMGIzwCVRq3hK67ztmJ66iAuLyHXTFaAt5b2jfsg8dBHN8ItbVLn8GfjM4ZoNJAnyPfgCyNRZLaCjmGMVqhHGSgiWv0Fcl8hKPXpqvkJRl1KkXwEW3cMp1Clk4Dw1S8GYaS0d852+ixXgp1eSyvsl39CG0FqHU0utZJOOm7jPbGyPiQXuAcMOiqMoCs0m+xM/KvifA2KvMI11VE9DsCfcjDaY150VF6Dc8sPwETopM9FcSKqi+BtxeRmKfaCbS6/yDAIAkrx/vyoIWVtPX95b9l74wBTBO8n4h+WzVvDmEM4i91Xo5mnWWu5mVTspGZ+KJhOfK64g1HpWd0g8xr5kfP1YaX9G6EbMqESwG0y1h21C98F0gpdBsx/lYgM0L3UmyWj58gY5t4vINixuwQqJiY37puTUVKsC2pHWimNfq+x
 IJgaMbYm
 enBxVf7YcnAAaurnlQg9PNFMDPO7/twTPAqpgxXfSZAVnaaobJqceXwmCe494Ikq3NRHXvsbq9kUnlBrpmNa+1Vzob9FA3zdByQGpgydTd1DECWDO9CoCPO+pMq7EvR+kpkyrTwIabr45rI+QtWbUchq/JpBjlCndKIlRbc4nWDxu/fSJz4RyjbOtyHMzJtcKg+55n3Y5ozdeydGy4MHyA5HXLu/lSYJ3IKZPdX0BnZFBT9U0hXk1GHrJOCjxlqzJxDlIOp2oy1bMzi1uZy+uxPp/8WUh0v2miNAMRB5OvdDk+JT5C2vKMF/deveGRZxIb7XZM200/CxM/NNXQdMg7BXLEY2ButxC9TbTqIegGaZCiU8cdgGuITNPrReFnuhH9D+KhjYqHlKdBBZ1zCl9CF5SvfvI1wdTiyASlk/Lf3wLCRDiUhsOwU1Dvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 7:40 AM, Marco Elver wrote:
> -void enter_turnstile(struct mm_id *mm_id) __acquires(turnstile)
> +struct mutex *__get_turnstile(struct mm_id *mm_id)
>   {
>   	struct mm_context *ctx = container_of(mm_id, struct mm_context, id);
>   
> -	mutex_lock(&ctx->turnstile);
> +	return &ctx->turnstile;
>   }

Many "container_of()" wrappers have "to" in their name. Please follow
that convention and rename this function into e.g. mm_id_to_turnstile().

Thanks,

Bart.


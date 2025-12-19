Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23D3CE66882
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 20:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C5516B00A0; Fri, 19 Dec 2025 15:49:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8932F6B00A4; Fri, 19 Dec 2025 15:49:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AA4A6B00A5; Fri, 19 Dec 2025 15:49:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B89E6B00A0
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:49:57 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 49F47B8BF9
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:49:57 +0000 (UTC)
X-FDA: 84237412434.28.A4B665D
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	by imf22.hostedemail.com (Postfix) with ESMTP id 70773C000B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:49:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=AywLvfsv;
	spf=pass (imf22.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.14 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766177395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rM/P2MMDWg56fhUQ0iWC3oQCnvFdb3z2dk9Gbl198tE=;
	b=ZIJSRcuPJTBghHKCgMaurLrkhPphPHNzSTF6Sd9pvtdOKiwKfyG+uAa/brqEp9N5N7Z/30
	dUPE6FR58uH947wwTPPWzk1PfDyZz2cRR6XPa19g1yUMhOMt9qRRvIyCXb6ppcQphCDhz6
	dHXiS7vqM0x/WTRKJ/K6TaZnXFgpwL0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=AywLvfsv;
	spf=pass (imf22.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.14 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766177395; a=rsa-sha256;
	cv=none;
	b=xH4HxSISjzhvLAwPRRDZw2QO2gBlEfwyyD4+0BoyWfj/hkP6cIngqdJiXjnwrxQvAlemDi
	1FgXqUhfjwf5ZzVloPJeLUBh3AxlD0FQCXYYB4Qy64CEebtv2kBTzW1VtDY3yjQSOd8TTK
	4rQufrduiR42dPxHHaU3bnqTm2Oo0vA=
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dY05t3Kwcz1XM6Jk;
	Fri, 19 Dec 2025 20:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1766177387; x=1768769388; bh=rM/P2MMDWg56fhUQ0iWC3oQC
	nvFdb3z2dk9Gbl198tE=; b=AywLvfsvVLx/i9HVA554oOttiBclTTktfo8LV6uY
	KH2pYANUiLBah4PvzKlrzruwMuc1XpaO56swS1WExytL6MULjFVfxZsQbBajFwgp
	zW0qmXouKxO5n01EHKjv9GJGuJQKgRMEcgB5t1a1AUpnYRlS1AxBkebt96jnYCPv
	byD+Pb6L33rxcWeqx6MQ6lTl1244BPYjsUlYWoFuJJG436/ET2zvmSUnHlaliZWH
	tk2S6maSDZXH+YLWrbEdlElDgYD3GKbaVnIKSn0V6n9rcYU4mXNzl+JSU0bb7hDg
	bDs/34sNoKeOu+ohplnNqaSFvhaFbHTV0CPd5Pcdj1hTcw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id oFKrgFOoi46b; Fri, 19 Dec 2025 20:49:47 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dY05T54J7z1XM0pZ;
	Fri, 19 Dec 2025 20:49:33 +0000 (UTC)
Message-ID: <3fb5a98d-d44e-4edc-8220-149d411c1ab6@acm.org>
Date: Fri, 19 Dec 2025 12:49:32 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 16/36] kref: Add context-analysis annotations
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
 <20251219154418.3592607-17-elver@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251219154418.3592607-17-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: qtfxua1pgu4twbik1wdhpomrzcfztnza
X-Rspam-User: 
X-Rspamd-Queue-Id: 70773C000B
X-HE-Tag: 1766177395-794790
X-HE-Meta: U2FsdGVkX19OhGT7CC5PSKLn9aZRimpnYfR1DwmMbBImnwBFW9Orz8U4/7HwZzporF7nNKJcTEIMhii+Cpbs8iC2Z3rPRBP8ndgVSEh+DnVUgJOMqSf3jfqwNLhH6QGnXgrSFe3F7kfsmeuqFnqpJbWR5Y8kLrslvMoTcuu2CTQYqRJ9GKzmX9Vp2rKBQ+IHCw9Ru5nGeIcrNzlB/SvAfyNNjOqkFP90o3PuX1ftIKgjoNqT4Z4lgZXicJYc13I7gPbXGx5sWdJyVVvY3syhQyLvU4zWRovjp0GncGNuMd6pHTAQ6CbzD4l2VQuR5bjPpX0glfXP6XSRx+YvkHHnm6F7GWJDKALcI0/yKwEYvwrY7JWzJvE2xO/ajts0jXGirWCF7liJdW4br+MeCrYfREmEaROreFYCD5uzx1lkpBshD7wrAjefuDb35R20TaWHWfJzOajYcp3uMnOlF+V2bFKCML50QMyj9/Yne+8hi0QcaHF2GqGDIKz6emy+u2jZt5hCA8MhJk8s34iXEVMQ2JTeWkeqmPiIHk7xNw5onRhE6q88umOcjAqhbEMEcQNHY44hFDwn51BG53EHK7vxPKSdu/N8AjduhNF9p6LqmEP+sz0dTucW1Bk3PCyWQhqOoCSYni70INNUf3SAF698/y1t1x3ZSCYHctWeujcQKxx524Q7LU2r2CIAycLV453MW9QRw90LPRf809lHi3Oz25xuQj9Okg46T+y5NtFiR94wSJY3bsEcocWAHPDc0FxwFRNgmbFDegblP11eJQ/AvHp0NMCUCC3IEFqmgVoiEOslN5AvKTqQSvwIoip1ojfYt4pTvDDqIRmn/Bi+vZaEXes9HYcVnD0Y/f8V9/Eb1SJP/TREh7hL2DbagAagAYJJZF91Tbb286KFvotZAk6V199IDHZTnIBGnduYE7AJuLAm2p86wdFMV7Ux/BjPE7E1/huKqNL3XLljfGLkBzv
 lJI3F23w
 MTPIlNbfMhL5Gidslf90XBq7pBfE/PPbWWrsBZUyP3CArOS1/UgnzMqFQ0OPMCrcHYdAnYN9NOOauANvoIVneYm6KretsAj0qn3JpYBlgtvF1Ipxv7M9+gxW03VgcZEhTOABkk0u99gXNVeRGsbfDKv5XzPOG9IjR1M585RBJAjcQZSc6+833ccm2hDZWuO8d8LMPolY9YaDhCs2CfOKVALVYRbnc083VpIy2+TRPLYOAB1rNb6qW/q5p1yZhpW56Pxwd3aA38qfBdI601H31V+rPG/bddlMVMvioTp2uP9p+UrHbe+91AWuQNW9gdYn08S0tC0ndLdn8/al/RPcLI51CHIWzXGWu0MIVoeUvyRdfvf+wJaUE+21k2gWg4wn2SgA297bk2msyN/v7sbQ0/7Ti/X+RQx+k8idXY3NDKLPhVfxCDtXzK5fKgg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 7:40 AM, Marco Elver wrote:
> Mark functions that conditionally acquire the passed lock.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>


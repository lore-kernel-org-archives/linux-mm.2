Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0169ED3E792
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 12:17:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 298036B0005; Thu, 11 Dec 2025 07:17:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 248CA6B0007; Thu, 11 Dec 2025 07:17:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15E9B6B0008; Thu, 11 Dec 2025 07:17:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 070576B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 07:17:14 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 958DA14010D
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:17:13 +0000 (UTC)
X-FDA: 84207089946.14.B384F3A
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf21.hostedemail.com (Postfix) with ESMTP id D4F0E1C0010
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:17:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=JQUFeVK9;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765455432; a=rsa-sha256;
	cv=none;
	b=4CScXk3nxg2tE/Y6z5pUesqrlruCtrVauPTc7BzrGseLqdLMV3GAmMfzPTnKSkZpXYqsHo
	9GbYMXE70sC7NA4w5LzH28NWnE717PDQxxK8ZVAIFAgGbnsTm+GKQ76lhkrIdIcMnQRyHH
	V2EgjSyWpelL1ysBESVOXgmMVD/MdME=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=JQUFeVK9;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765455432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=39KoR5/fOj3fCtjlvg+DfDvWOhyBBWrm+m1GgO5bCLU=;
	b=YBXErNZrvJ5caCakghNE5mZPx64KR9m/Vk6sO5qp0m4pbi19LlaJcPV/ID4AZZb/Jsn+cI
	V46Xw29CZNeqfpSNPpykAKAXKj2yBBPOH2FPQ8jvqaN9+ZkN/z8OSrWOjIf1SRFQwIlMm1
	cezRorg8w7zeK5/N1T3XBk+qSp9RJ7c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=39KoR5/fOj3fCtjlvg+DfDvWOhyBBWrm+m1GgO5bCLU=; b=JQUFeVK98tjeYpfU93rMF2ZY19
	bAsRE3AVzS8uNN1rSyDutKu3gLcTtuHvhuOJj2RMhmQzVgJBqfNeXxKO/clvF8DQvLMATUDN6SZSF
	84MZfyjGW1SaTQ7YLkmKmz/YSI0c950DbeuGKK2uP2GEGewedHgITujDipZ3yrY2OErO7bzvUh+53
	epSXiiwAKohLvCwEGDmc3375iypbRIz1SRqd35HtDzlUf39T0ZEBBWihSj2EaefFEM2dQV63abUjL
	PWkRyBu9U/Gxl4sIlvsl14hULIsz6Dv3HCQUcTGP2JFZGKEYcvUu5cS5HGNjTnYLmXrec2cxusQUB
	jigfaTgw==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTeju-0000000Et79-48aq;
	Thu, 11 Dec 2025 11:21:43 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 87A0730301A; Thu, 11 Dec 2025 13:16:59 +0100 (CET)
Date: Thu, 11 Dec 2025 13:16:59 +0100
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
Message-ID: <20251211121659.GH3911114@noisy.programming.kicks-ass.net>
References: <20251120145835.3833031-2-elver@google.com>
 <20251120151033.3840508-7-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: D4F0E1C0010
X-Rspamd-Server: rspam10
X-Stat-Signature: tnokwah3wyct7serpitc9iy5yefatc5n
X-HE-Tag: 1765455431-398613
X-HE-Meta: U2FsdGVkX18duu8Qau5v1CJJmGquHR5oK1KDuD4tH98NA/k3V4IHdV7ji7/N33tEKob4gcoAnel63Za+1FJgbqbf3ihHyuEKLvEKSaJ8R1p9SpQ1gcpeNmDQo1caTFbVT/j3azkjMjCm6vVRJrIWDLeFmI+6KdfSvxvi0QmKcUZSTYLhIrgUZC2gknyHQpAfLhVikFNpa2OQJEUdLPoeofcEofae1Tlvf4UhKwjCSpEPBu4nTc1djTjCoeYcNsGMfohbSPGXF+/FKhPEgO6POwZU31VQaKdfVO1sJ5YqwpZzjY4y21MW4acW7gMapb6ugw3u3763My7OngOimqjmlZ03DoZbdD5K3Lf+dREznVfWKcf7GtqdgjFyKS+n2yTP59eV2qWXTajTxE2nntcPGZI1lHOyNW20Pk2VVngxTVPSkuTjzi19BJ/GbFkwwKCt3rv3rSDjGsyvD9kEdas6xZCfMlibxWAYfe+VUgDTX9AnEWfuyUm5SGTT2wCvQIMTg/ssZyjaLOl9A3jQEk4xrZSVOLZPjrw5uwbc7sk1j3kmBaKBAoa0gYvdEirYMRE1+kwz+MO4BfjBOdMbftdIr/uHU9r6GH0uiYLyXQJW2JzTp433IOYJP1Pu/9qwIrzUZvEwzFr1nzs94RdJnsO8VRPbjlhB1PrbQcV012p1gEryzczN6NcRCnbG4wAbtxkD5GjP0dEFGOmUxVebbd3/Vhotnjnn5aIlZ28PF6gQ3Tu7tWqPkScKMNE8E5B7ZRQ1BoBt/Q+7n3YnTnlmi7RV4eRlNMk6u1RnfVYYLAdXp9N23pe1FTM22/Zy10Ej62e0lGfljWXqiYUsaIuDOK8l/pb7GykougC92iaUMPs4VBtmErY7UW2Kp83rdJAHsRimlGcqWNILafqf292ssjp6mcjh+EtOK7GkmFq4Oozw99KQ/+sdlSROFC5XG6C7yGa668xN8pkiRjT93YvcPF6
 CsROmh9y
 ZAp80eXtZu29t9zFD3TipKTlKcNme/PCPnKAnWZfACPUFL1Sgv4ZFevO0EtqTr74QA6CS64vvt9XjPk8cmwc0g2wLYaUr0BuOsLCnVE/ya7QRXWN8oAf+YcIfSj1XvASJkk+civprmy4e3tz+A9WeLhL/Xyygk4Lw8kL681scmCEFnmRJS4Ghl4WFpR0bBpJZyXvfClYlrGt164MwhaOwNec1ZWGs15/po87DcETyXs6tD+gk6F5atIgWDaix7Jkh3+3P62bKYzhNEmZWdclbeH54fvSMR2c3PUcpngNKAQOBSj6gl/ZAEfnstA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 04:09:31PM +0100, Marco Elver wrote:
> Introduce basic compatibility with cleanup.h infrastructure: introduce
> DECLARE_LOCK_GUARD_*_ATTRS() helpers to add attributes to constructors
> and destructors respectively.
> 
> Note: Due to the scoped cleanup helpers used for lock guards wrapping
> acquire and release around their own constructors/destructors that store
> pointers to the passed locks in a separate struct, we currently cannot
> accurately annotate *destructors* which lock was released. While it's
> possible to annotate the constructor to say which lock was acquired,
> that alone would result in false positives claiming the lock was not
> released on function return.
> 
> Instead, to avoid false positives, we can claim that the constructor
> "assumes" that the taken lock is held via __assumes_ctx_guard().

What is the scope of this __assumes_ctx stuff? The way it is used in the
lock initializes seems to suggest it escapes scope. But then something
like:

	scoped_guard (mutex, &foo) {
		...
	}
	// context analysis would still assume foo held

is somewhat sub-optimal, no?

> Better support for Linux's scoped guard design could be added in
> future if deemed critical.

I would think so, per the above I don't think this is 'right'.


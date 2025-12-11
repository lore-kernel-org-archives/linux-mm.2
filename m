Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EB59D3E792
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 11:51:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FFB66B0005; Thu, 11 Dec 2025 06:51:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5897E6B0007; Thu, 11 Dec 2025 06:51:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 451316B0008; Thu, 11 Dec 2025 06:51:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 305F66B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 06:51:51 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D6D3C140880
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 11:51:50 +0000 (UTC)
X-FDA: 84207025980.13.8C750DF
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3D03D40002
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 11:51:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=YCtHfTx7;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf17.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765453909; a=rsa-sha256;
	cv=none;
	b=vWMJ3DKUUah1nMnewNjUHLOun6P61ZthM+Do9Zyl4lqlbtZS2liOnorxAQlfdayLSipKsN
	3a/D5RxvJxTafvvgfmfKONz2uVv1IPUzPC0+rQC/Z6NC6ZG3G9Y8sDVX94Dk8yN2L5TGiG
	HKciOi2o7pIwxI+OEFHikOvMlJyFKNk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=YCtHfTx7;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf17.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765453909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ruouxJOUh2d+f+e8HHYpqnGoZEuPo3luh7bn7bAHeI=;
	b=JesE1r7dE+a4zrhI8eWnpLm9nSxWUfKyHY7kRpLeizRR/CWs2cVAX2qwnpm08h0eouqAWA
	qIqkD4gsa6Nap7nghsArCk1qfMlKfrpvmMui6HWkUr3SKGuXZH1TtZiQoAwRiFXbTwJf6Z
	P94aeQ4GfbZnR4g+jAQhMwfYa4sbrBo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+ruouxJOUh2d+f+e8HHYpqnGoZEuPo3luh7bn7bAHeI=; b=YCtHfTx7RoM+FUijwKYs4TN7la
	V38IiN6UXEJqoevDxSusV4xIKVmpUvu7bxeHyT1ebhxYje8Y8ewjpnUYe/AwPBWps727+uIgDIxGh
	gHylwobYVFURCe1AhaSiscraq4UreJJ8qzq798CHWb/cBBob/1iZKF377N3zfzcIJ0TOPZsrSel9n
	6sEuHcwYOL0ArmngL2gHZ2LsDyvZyXXzu1RFeIcoPmnUV1UOXv6jd2LeqmWmL1Yf8zM1kQcwdf6KN
	3gr5k3gALYgZb+dCe5b//7iQ82XTD18jysr8AvEqOPt1OtNyHnlF7O1kL1V4e/6nZWZZvwAcoAjKU
	8Sg8GQrA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTeLL-0000000ErCa-0UbQ;
	Thu, 11 Dec 2025 10:56:19 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 3748730301A; Thu, 11 Dec 2025 12:51:35 +0100 (CET)
Date: Thu, 11 Dec 2025 12:51:35 +0100
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
Message-ID: <20251211115135.GF3911114@noisy.programming.kicks-ass.net>
References: <20251120145835.3833031-2-elver@google.com>
 <20251120151033.3840508-7-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3D03D40002
X-Stat-Signature: rgynudh4w84iyuzpptamazhxnko5wt8u
X-Rspam-User: 
X-HE-Tag: 1765453909-825389
X-HE-Meta: U2FsdGVkX1+/JFXzH+/i4gkH4cEA36w4nNE6NmjI3kRlZ/gpwe/r6QJWb5VmmmRE8HsH69Cck3qspBN7fiTGExMV8PVETspeLthRDzxvveIy+dmEHaogsktOUkyXS+ewmNo+Rg83usA33NcCjIBaTe0100w8avcPy8i4wmDSUFN+G2XR6GzF8/h0l/AxnXEW0BCPyfMer2KukWtL10m2+2Gd/QzzieifQbPnl6hVzUWD+Q+5gQAzib1Jy/PlTe2UHwi9LMIhOgbRozTZOgRXcgElxtde71ol2N4LvU5ItZA8LrCskkfG9t2HHtTpnLKRiyOufLnx+5961UT3VzaqxM+ErfDiOT+voHjTH0eecY51I2fgd/atUm2BQUYaKqtTz9FXmMv0XllLyJ6FdGOt6fVI27cLeN9CG1OrC8S//VkjJyGYkajU6bq6CCI6E5RyQPmGh42CmRv8feXKEqRzi111dFL1lIiCGX6tRJgWqj3BNVOG82UGtqJpVgzJ+dHnrWblys87I6eAdiOBBXeHgL+sdPzx0g+j9wBpSF5oZvl5xExn76NsO5VUbdPaV9M30TugQ7qtU4Z8Jh7gRbuGU5zYz1xC77qlpAzo74deT5fz50uXnjwewJExBzTvu/DavzUYlbBX4UBp6gfiG8AltASYZf0fOboaszoXaFeo5DAzcGn9/96YcSeSi0Xevf8aa5kqbMCzh/krhc/UTB2KArpDJg+QmVYVHfvZ5Gk1oDO7XTnEUT1fSdFGqdm6eOPsZoZRWGTMDL2fFcj4U7Ucdx8HAZvBQ8sSGZDiZczOdsggSCs1cNBbtH3ErqQ9fbvXXHLIMPRpBOLsurO8Ke6WGs23/Cd7VIGjdOPIkiD/snzw/GiCSMvpCEqEhFWBJmQf/UEWaZDHn33/YCT8NH55t9400aqTkQT3OaLiKe2FZgzaNe79DCcH3YTsT4yFOiHLrGcMxflHQoSbPrD1hls
 5NtUp6Rq
 KjMwgb3QDf2mVS8sgv6zmS7wtgTnKOIyXd3gQcfucky0H9kWwUUJel4STmhbypEF5zTAn/BAqejvi3I1X1YHeh2hc58iKsp7P0c/key+HNnE3qXEDtwrRj9cy79onYKzqA3PSr4qkzwOQz8Kf/jEhM9KrpU/ypTQIDWa6M8HPFC4rMCIOxc7IdHnev7TOdQAFeBf+djwlsDHb3AdOTttjxC3QDOoqph7/VUXWG6lv++uc99Qs3g/oSRKj/ztDzBT+WtcM9HrQU6X6v7U4xtogFmOGxslZiKv3nCFx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 04:09:31PM +0100, Marco Elver wrote:
> +#define DECLARE_LOCK_GUARD_0_ATTRS(_name, _lock, _unlock)		\
> +static inline class_##_name##_t class_##_name##_constructor(void) _lock;\
> +static inline void class_##_name##_destructor(class_##_name##_t *_T) _unlock;
> +
> +#define DECLARE_LOCK_GUARD_1_ATTRS(_name, _lock, _unlock)		\
> +static inline class_##_name##_t class_##_name##_constructor(lock_##_name##_t *_T) _lock;\
> +static inline void class_##_name##_destructor(class_##_name##_t *_T) _unlock;

When you rebase this series; you'll find cleanup.h moved to
__always_inline (because compilers are weird) and these should probably
also switch.


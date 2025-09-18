Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EE44CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 21:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89D958E00FB; Thu, 18 Sep 2025 17:48:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8755C8E0068; Thu, 18 Sep 2025 17:48:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78AD38E00FB; Thu, 18 Sep 2025 17:48:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 67A748E0068
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 17:48:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01A0A119D56
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 21:48:03 +0000 (UTC)
X-FDA: 83903709288.13.DE3993B
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id CCF2D140007
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 21:48:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=HKnIAr11;
	spf=pass (imf09.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758232082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mLiszfQw8YctXWgw7Rv1CzeIAYsEhv/enJDimwborHo=;
	b=73mALQcC9FEMxhyKnS4BzloW5iojolw5AsjfkVerKceAEb7oTWOLzq3m9TZV9Wq6bt0H9L
	cBco/56W5OL+pEPBA+nOHKb6PY/kyn4+xI+xPUC4y7qbnBuRZraf0cQC7yF4wQfXeKsl/A
	MQYKDCj4d5YT1+5sCm8lXETYw2nHnqM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=HKnIAr11;
	spf=pass (imf09.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758232082; a=rsa-sha256;
	cv=none;
	b=I0POEIcvAGm/r9tU3pHL0leKec6x8R4rOedLsvCBuQH3Jgyen96nuwPOsrH8+ucWyON5tt
	TTGFOwShURPYtSzPop4IVu+BnkYu5XXc2zfTF4PRUukJ+58z1ZS4nYci1E37QN42FL/LsP
	qyiDyvHi/O0uHDxmCvOUXMaV+DF2ZfE=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b2400dcc55eso99635166b.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1758232080; x=1758836880; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mLiszfQw8YctXWgw7Rv1CzeIAYsEhv/enJDimwborHo=;
        b=HKnIAr11wsu8e4fGCAil9QgbVhDz/L6Y7cMTo1AdCkfp++AUZAtuj870ru4mKxJ2fv
         DSGoEjUADQNBQQqMFQvBnHt4qH+oo2AASwxpIMxmVBF1HddrpWhxIFq3fX1SE5eNIF1L
         TOJAoQLW13eMdVJsld3zTLYba0vbfeKFKa1DE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758232080; x=1758836880;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mLiszfQw8YctXWgw7Rv1CzeIAYsEhv/enJDimwborHo=;
        b=YS7yX5t7ZJta1lACWRcxDkVoTzFc42bkqFh2msRa+9hGao1nHHMLr5Jny7JjMMxeD0
         jhLE+teGIsvUa/LOfgxjx1cXwyg6VWuhJX1lG84HkbYcUlpurhayAC3lD0EyCAgX/zMv
         L2oMhPxDV03S2px99mMc8Z0rJR4gbi7dGA7CmTVbBIJ9hUW7/b9XtIakSi9cyHM5Ej53
         dO/qdkn76g1Y76XQC3XOoqaRwUuBS0ZAiLH2fACL6Ax8C6JF1cKOfucKiTtGB16Ppimg
         g/xCTXzQDcciNHC+qX5cZcpWp6Kbu3q3sxQ3c6StWYFtMzuvnPWt4dsnAFLyL3pJnuSn
         8O2g==
X-Forwarded-Encrypted: i=1; AJvYcCVW3hYchZdpd5A5yHLHsb7eqyUoy1RPzaYsMbJBNiSQruBLIHRDjnxAN5O91shGFztD8ue9fidRmw==@kvack.org
X-Gm-Message-State: AOJu0Yx5Hntf6Xt0N2VFTSDWC5d7Wt6Rv2puWvl6bwXm/o++pAWzEUgE
	MLeAzjeUYCsk3EAEIinJRau4Ca+9pKUrLuAK4oDb87ia1YlIO9Iq+PHgLc11wFPt21ZGpurz1xn
	43M+fSW2Ahg==
X-Gm-Gg: ASbGncu3eHZzgyAhXhBCr+tB/fWq1qvSKJ3j71htigA8HqJG66g7fxL92e/KHEiJ0RE
	b3Iz8K24sJcoG97/IfrH3OkTI7zGarBmYwBRMs5bZ9EoDCyPhKYhceFl7Db8ye9CXsAljCtE9UH
	MPJGUnIB5ZWyfDySGPLHnuS5w9Dl4aMFQQv6c3p5qhI4JtjAkkeZy/XFDUQTw0l2kNNaVaJKOk+
	JEQUi5omKuS1Dq35pSu43jII+HvGQH06R9ocqfJexGK879sWzhSvLXTrsgm6lt6UtiEWfF2eem8
	6bV6J1aQgjZ36SYK3JAvtRIUWFfAvvvV0BWhlvMhKLIMMPgW/vjwbrRXI9oQ6c/BDvf+uZ7KhId
	8f6MRVvubxMK3iY6ADD+kAzR2Fk3sn5y3jCD+Rch+EiUT5Kdon6nixzH/i+AgzeGHeOQ5OnOX4Q
	/wIe7m5Gu1bt07bLs=
X-Google-Smtp-Source: AGHT+IEwlCysc9umR8UQ/6RdDRKC8Se6idSa+fBeX7+pQcZDBNzEit8/vyebs9UnYd17P62ns9hHJA==
X-Received: by 2002:a17:906:d551:b0:b04:854b:bcf6 with SMTP id a640c23a62f3a-b24f004e112mr77329766b.24.1758232079829;
        Thu, 18 Sep 2025 14:47:59 -0700 (PDT)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com. [209.85.218.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b1fd14d5f56sm277853466b.74.2025.09.18.14.47.58
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 14:47:58 -0700 (PDT)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-afcb7ae6ed0so215862066b.3
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:47:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUAHWxOB1qrCagX7Mp5IOn368nuxFCGwi6by7Bapm781wpy/iPc+3E5WWAH+KoeAvB/twhDKCya6A==@kvack.org
X-Received: by 2002:a17:906:dc89:b0:b0f:a22a:4c30 with SMTP id
 a640c23a62f3a-b24f5685fdemr62738866b.47.1758232077501; Thu, 18 Sep 2025
 14:47:57 -0700 (PDT)
MIME-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com> <CAHk-=wgd-Wcp0GpYaQnU7S9ci+FvFmaNw1gm75mzf0ZWdNLxvw@mail.gmail.com>
 <aMx4-B_WAtX2aiKx@elver.google.com>
In-Reply-To: <aMx4-B_WAtX2aiKx@elver.google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Sep 2025 14:47:41 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgQO7c0zc8_VwaVSzG3fEVFFcjWzVBKM4jYjv8UiD2dkg@mail.gmail.com>
X-Gm-Features: AS18NWBxHuMwwtU-EoNbPFA3uJ1YRJkAKqdurj12n-PWNJgH6ecKwZ8QZrX3P28
Message-ID: <CAHk-=wgQO7c0zc8_VwaVSzG3fEVFFcjWzVBKM4jYjv8UiD2dkg@mail.gmail.com>
Subject: Re: [PATCH v3 00/35] Compiler-Based Capability- and Locking-Analysis
To: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, Christoph Hellwig <hch@lst.de>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Kentaro Takeda <takedakn@nttdata.co.jp>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: CCF2D140007
X-Stat-Signature: ae9sdgiyi3f1cqud9m31p9dwx6qn3keq
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758232081-753580
X-HE-Meta: U2FsdGVkX19DBWMeIVjV2aNnjQJG/jdLlgr73EK1qED4PR7o8dncrchZo0q77CWkDAo1vj+5ZiAyiFY5X77XvvF1oimLn5wZW7yYj2eMxfKBy6qu+k6wVn64UC95E2ZCIr7FLhy0fu3QKfYmc0G+UX+gpgzamIQWibSfkDjXry9yik8QQptmx6ZeZyP1SS+F1deRkteqAnnGp3vyC+baEjnS6wE1pQFb8DbUtuEuZRahW0DScFaH7YK29QbvmHIwHFfT7i2AYIuU4zL276jur52xriBsFEnNG3eBq4aOHCrAfG4YpEIYTXs7fd9DaEDhJR7gR0zY4nMF19fICQzD+vZVQTILl1V9SANFmlWMcnasVL5nKD652asXovUsikSltRkfX5k9GjgS5nS0SgkNTEI95biBwmUZCgGACo5G4g5eIsKUX9ji/tVKsy6orniltpJx2vV5yeEnZAT9l/Ag1vQzhIOQ+sRsPSWKVf7UeR/ARBmWY8a+CL2iE7Lfr5qvh+MRUUflXmj7TZwyOJniJNcc6ZjUJ5psCW7WAleOzBnhU6Y3kIn57EpJuf+IqsSmI0oDxu3tewl34slFqfZDSl2TZjXwNWGFTiJpdr0pfU+bXJVr/J+Zqga/AD47xDEZBYbwWADkMnAwaR5sbP1xR9OTjhlixl9uVtKxmEvljCBt411HzZ7DVhBm/Hp1jezleB+3X+09ggEz8DGqQS94T3LvHxBmAXHA4CjVgXPl5Z+gn7ygmHBLqs3I0EaFnYK/eWIN8ysTu+JK6Fb+wKFd23GVLPMVEJmQzGSHlohxSz0VI4HnKZAKFbWtsQwqM77vORUfQl+zIQ03rqOWJ80E4rnsjSUq1TGo43FfpCHmvzS65ev23Gy6MOqk3EjpPODpK/LstwSCehEBv8NVeNN+KlvyEU7de0yTjrrucqMFILo/mjQf85mrb8KV0jPhn6yjJfLsAEzjf0g7aHDS4P/
 VtuOGa8Y
 ubwpu521zcJ4cHAQf1SglU5ZauMfivVrSWpeRZRlRe1vJcLdBRJSdm8F06oAnsOs1EA5nQVC2qZCHvftzq8SQd+n+/paNvA7UCnS0G1pZ09V77DCfp086rCilyz+C3I5jebLY5mWiCBd5kZU0kaksG1CtBdDZVxEJC8oEmF0yjGphTcHpgBpuIUTCWgeUv/lgwqdQkhGYFEnSemgCWhCo9OgpJXfJeI/e3clU14FUPEEEO6Sh0zWzxNSEVsFr0jLHoSTLzq9lHS8nK2RW5JWDZl3g3lUWzHhvjAwnPMza8ZRMIW0PN2PtLwnaw+3yGDrmVDWqY9tp2GCl8FA38mQulvUyQ/rTGIoQQWC3DfZ2Z+k3TuSbyNNNl/k+dkfX175nsgt5iUZEwqFbrbNtLo0E1WFbBj0/ZQ5c0LCzyCG7LRH3672FC/IMVHkpP49QXJ2UEUeCa3s+QIEF0aLH3lmnH46doEoSrBJXpn8a+gy/djy6L4uaUSVCenn+G+quXr2dJfRvCbIxfqMVnfLb3MuYhJxkWsNpUKX5237wULcClkbgHVP4PRx6xBEbYlas+eUrCaoWP1tvjrYwmfFohPiiWP0EAMq8G2W0VYnL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Sept 2025 at 14:26, Marco Elver <elver@google.com> wrote:
>
> Fair points. "Context Analysis" makes sense, but it makes the thing
> (e.g. lock) used to establish that context a little awkward to refer to
> -- see half-baked attempt at reworking the documentation below.

Yeah, I agree that some of that reads more than a bit oddly.

I wonder if we could talk about "context analysis", but then when
discussing what is *held* for a particular context, call that a
"context token" or something like that?

But I don't mind your "Context guard" notion either. I'm not loving
it, but it's not offensive to me either.

Then the language would be feel fairly straightforward,

Eg:

> +Context analysis is a way to specify permissibility of operations to depend on
> +contexts being held (or not held).

That "contexts being held" sounds odd, but talking about "context
markers", or "context tokens" would seem natural.

An alternative would be to not talk about markers / tokens / guards at
all, but simply about a context being *active*.

IOW, instead of wording it like this:

> +The set of contexts that are actually held by a given thread at a given point
> +in program execution is a run-time concept.

that talks about "being held", you could just state it in the sense of
the "set of contexts being active", and that immediately reads fairly
naturally, doesn't it?

Because a context is a *state* you are in, it's not something you hold on to.

The tokens - or whatever - would be only some internal implementation
detail of how the compiler keeps track of which state is active, not
the conceptual idea itself.

So you name states, and you have functions to mark those context
states as being entered or exited, but you don't really even have to
talk about "holding" anything.

No?

               Linus


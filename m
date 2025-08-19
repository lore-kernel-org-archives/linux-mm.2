Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D54CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 18:03:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABF418E0056; Tue, 19 Aug 2025 14:03:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A70398E000F; Tue, 19 Aug 2025 14:03:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986AA8E0056; Tue, 19 Aug 2025 14:03:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8733C8E000F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:03:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3415156B7B
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:03:31 +0000 (UTC)
X-FDA: 83794279422.04.EC1E94C
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3F225A0016
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:03:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iyLyhwdM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3b7ykaAgKCMYvmowymzns00sxq.o0yxuz69-yyw7mow.03s@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3b7ykaAgKCMYvmowymzns00sxq.o0yxuz69-yyw7mow.03s@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755626609; a=rsa-sha256;
	cv=none;
	b=yP0WDZgMhsXK1T0apdz9yhEn0vTxmuSPSL2cOgWx9RlsjWJ58CepcBJZHNQG/4vMz1UGQK
	M1oCSCrzqY/tEhu487erEJvmiiugpWfXgR+RYvKbVtRVOt8DbjUtgIg+e5VmO49gvrO61S
	E1x7GMieHhapKzBnU/KYqh4yKLrABEo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iyLyhwdM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3b7ykaAgKCMYvmowymzns00sxq.o0yxuz69-yyw7mow.03s@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3b7ykaAgKCMYvmowymzns00sxq.o0yxuz69-yyw7mow.03s@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755626609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KF6Ep2y33XCgTx+h8iRawRIyytqbsVvE9Zs0AVU//wM=;
	b=RSaxgbmzVq7q+v/pZHDDERxzyKc09ebCZurZrlb5D4+f8BDMi9N8nhHPQGkmwo93nVXD4O
	CDhDkEaHPtwGYlrMhRCioE49D7i9TOhqi7LpJkAV62p4zyxY+IGRL8p+qu58Gm6iX9lbkd
	i+xRrZJosYtwjEnhSsFCdWQZbnkAU2o=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45a1b0d221aso23759555e9.3
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755626607; x=1756231407; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KF6Ep2y33XCgTx+h8iRawRIyytqbsVvE9Zs0AVU//wM=;
        b=iyLyhwdMDWI271Ch5MXF1KOjO+IYkiyKmuG4moPxgs612SQHW+zWNPlydqdRiuYsIv
         iTel6T1EWoDCQDA1gp/xjUWGlARU9f5QB2DONYb5hFNuqYhr6i5tUaCNJMvp2DsCHs8N
         2VEYS8+UQk9v7Db2D3Kqv/jwgFZ8iw5Q9j6m/IMyCNyaOiW7cKSp/SKaATIB5v9BxsPp
         dGRC32U5TsTtkPy7BlOPFg+/SMqxlOwRnDp4EltGHqv6SlZ5Yxhm0aDb9gcwNB5gsMgF
         coZKTJWAzdvrZ8xs653Pn0So8MKz9xSkULPFILuDSula5AK+qCcV8PaShcJXOpytIBLK
         kj6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755626607; x=1756231407;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KF6Ep2y33XCgTx+h8iRawRIyytqbsVvE9Zs0AVU//wM=;
        b=NO8k5/HA7yT1hHvY7ZW71+1Zlc0et2OBHlNBH1CAO/rqtvJKxlOADAGAc4cXA6uozi
         IdaCNJYvsyjYHBImdE3WEfifrih58k1KYuf0y5NKQWdQob9vO2pqpBqv5rGjxnwlKnKx
         GbuLo+k0BE+Vg3QvUdCmxnCm6aejzhVb+oqlUdxTffYB1lNAQRY5Rql901EADmxapLCv
         vt2FRKQLXRbSCYXvwKHxOlRRBpHj6lm6KibUz7tznorWVUlf7uWsSeW5EysNSwNMGt5M
         0baD1y0v5LawKNC7JGwYVP2ZZ+pUfxHhFZZETZU35wPzhav3CTqVLCcFtcra3EzclFgP
         vwJQ==
X-Forwarded-Encrypted: i=1; AJvYcCWer91sH59rLx0SROSPk91Z6LFXSNycqKA8wG7rfsm6KmHsOnP+PI5hlj/K/8rzEx/r9p2wmu6g+w==@kvack.org
X-Gm-Message-State: AOJu0YxLnFgH9sem7rUpQ7O3LWIdJqyPgBLW+0BsTZuLaNttwi1NwU9+
	2xKt1MR+5EoOjtrlojONzk7fM+A5NJmE0H0RAQdpW+gpMJV777y2s3xuLNMx5NxvY1pSkx+aNyn
	91Z7Ff9b0D+wEvw==
X-Google-Smtp-Source: AGHT+IGAP/5kOUw2xl88tGIMUg+2rJWqwENGYoQPUjN+xF7n1jDCKhH55XKAw9uS4xoVCgiwisZ9ko0ZaQaaQg==
X-Received: from wmqa17.prod.google.com ([2002:a05:600c:3491:b0:459:7c15:15b9])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:474e:b0:453:5a04:b60e with SMTP id 5b1f17b1804b1-45b43e0eed4mr28241025e9.26.1755626607329;
 Tue, 19 Aug 2025 11:03:27 -0700 (PDT)
Date: Tue, 19 Aug 2025 18:03:26 +0000
In-Reply-To: <20250812173109.295750-1-jackmanb@google.com>
Mime-Version: 1.0
References: <20250812173109.295750-1-jackmanb@google.com>
X-Mailer: aerc 0.20.1
Message-ID: <DC6LOWXFIPGQ.1RKZL23ZW0J73@google.com>
Subject: Re: [Discuss] First steps for ASI (ASI is fast again)
From: Brendan Jackman <jackmanb@google.com>
To: Brendan Jackman <jackmanb@google.com>, <peterz@infradead.org>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <mingo@redhat.com>, <tglx@linutronix.de>
Cc: <akpm@linux-foundation.org>, <david@redhat.com>, <derkling@google.com>, 
	<junaids@google.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<reijiw@google.com>, <rientjes@google.com>, <rppt@kernel.org>, 
	<vbabka@suse.cz>, <x86@kernel.org>, <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F225A0016
X-Stat-Signature: oxmkeakgm13gteyrrj8ukwruy341ffti
X-HE-Tag: 1755626609-122108
X-HE-Meta: U2FsdGVkX1+TDFO6ysm9t2xWHAdnYeihBEdtsyf5axaH5ygh7wGkypXWISJn2JLTbyyyNanA5yVqXyC9l8Q2ztBaPavUfEOHCaA5ZEqYwQh4LqxKS6WrL18ke+YIUgYAscnf2/atJdatv0vyCtBFfZneW9/ZqI7fDYM3h4knRR3ofxjvKUjlDMM3wKwUzt5D4/Tm0Q6mt2aRH5SW/fnqdVLv+8tU6P8GLJX0YNUhAqP0n8Lux4aatQZmNa2bPVM7pbK7b/W0v/4HPxVoNCIs1GWlzEBYv9aH+kLsBBLGYe0NVdFqXNGb63QzCs64msG2DyiYtT4iWUkJT2udvkBnjxIo4J7GyXtUJEK+BrL/QXVyJ3oNct6ehZCM1jwRJLZRzWawN9gJwBJwIM6T2RdnoocJp/N9SCu2RlWbRisYLMUEpLJRO3vXQ5nolcdZTJmuRbtdP0uqvjomhUAsdks7ZPnqPJRNwUZXn/ZnPATOrO6ooUfqv5JybRUIqNbe6W8hoipVgu53QN43h1xbAksyrI3MXIWsMTQO2bdFYuYkklZBjwqeS8yuZmmGmg9PaS+SjoUwa8vtag/uk7y/Br3fOE8zYCtX/mdmpPRtjTnz9Frc4tnRPfk79qpR2OCZRHtvEZTdGIQ6jOUHJc7YOv2YfzCb4ZRj6lmRdz4dYzjE903sA9OewgvE8t5a2G2KxRRjFuehjTNlpHLW+Y6PMzfi10ftyEGmZwpqiat1Q/jzGhxpiKxgOnYfNcKZP6s47xTBshDMSnU+jrqgOfb/xzsQTC7SW1MFB1GtKArSJwW0VhDgRp3RII6qCwcZbErUwSRNzvbENBsnw+Q77sQCD3bNxBcyj6czZsJKYFhfeWK2vdIsT/QToDov2PZa3s1jP5rtYQU5AVOwjiRX4HMZd9Istt45bFrGhTybjM+n7110NkG9B59dI3KEowMZfInO10bjw9fDCpnoybz2Zkvz3oq
 V3Hqjq8M
 saFygJ9I+D46BB/EawLA4D4rfB7vFp6YQPsuKcT4WOdiXYjkISS29kPHSIBfR7dNhXpVwUFPTjqBJ7NfdmJKALFLPemVZoXI2S7K38XI63JbhacnrTutc10mKqhYLpf2XginUiGaOICo7sHe1QUEja1NWx4tfbSKJpf9ed2JTran+BaDcyrZ21zulCAO2rZn8Fuvfu5HyU7KSf6xom8YgnqyiutoRlwuk6dMk9wBmklbXSr62JD3PEihH9CFfCZ8YK+BDEiYE4i01pV95cnW0hkc3DSFjzfyuHhdFyPqLuvu8j3ERqjElj6f+SyIQyaTn46G9AGxsHQKuTazJcF04XugZlyvSlDshk/OAkHWJp5bcvghnA8j1nB0/tUwJxoQpVNeoORTCitqHetipS0fMIgQRZNFsM0CxkBEkhuTHQlif59Fx/3aGppO6onJL3Rp4Wp02RQPQOOjTdMYtTkBb+cjLAwXieZGYyj4gjKYGneRd77gyFIpP0BIEHOsRAnPlrSjk2S9CJpsRB4PsiC1AoCsJu3GZpcVoOfSi9Vm2jSfNyS7Yo+uHGvhEh+D7HOjVg+yb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 12, 2025 at 5:31 PM UTC, Brendan Jackman wrote:
> .:: Performance

> Native FIO randread IOPS on tmpfs (this is where the 70% perf degradation was):
> +---------+---------+-----------+---------+-----------+---------------+
> | variant | samples |      mean |     min |       max | delta mean    |
> +---------+---------+-----------+---------+-----------+---------------+
> | asi-off |      10 | 1,003,102 | 981,813 | 1,036,142 |               |
> | asi-on  |      10 |   871,928 | 848,362 |   885,622 | -13.1%        |
> +---------+---------+-----------+---------+-----------+---------------+
>
> Native kernel compilation time:
> +---------+---------+--------+--------+--------+-------------+
> | variant | samples |   mean |    min |    max | delta mean  |
> +---------+---------+--------+--------+--------+-------------+
> | asi-off |       3 | 34.84s | 34.42s | 35.31s |             |
> | asi-on  |       3 | 37.50s | 37.39s | 37.58s | 7.6%        |
> +---------+---------+--------+--------+--------+-------------+
>
> Kernel compilation in a guest VM:
> +---------+---------+--------+--------+--------+-------------+
> | variant | samples |   mean |    min |    max | delta mean  |
> +---------+---------+--------+--------+--------+-------------+
> | asi-off |       3 | 52.73s | 52.41s | 53.15s |             |
> | asi-on  |       3 | 55.80s | 55.51s | 56.06s | 5.8%        |
> +---------+---------+--------+--------+--------+-------------+
>
> Despite my title these numbers are kinda disappointing to be honest, it's not
> where I wanted to be by now, but it's still an order-of-magnitude better than
> where we were for native FIO a few months ago. 

Some people have pointed out that I'm treating ASI pretty harshly, I'm
comparing mitigations=off vs ASI, while the "real" alternative to ASI is
whatever the kernel would do by default if we knew about the vulns on
this CPU.

We don't know about that so I can't do the exact comparison, but I can
at least repeat my compilation experiment on Skylake, without ASI,
comparing mitigations=off vs the default:

+-----------------+---------+--------+--------+--------+------------+
| variant         | samples |   mean |    min |    max | delta mean |
+-----------------+---------+--------+--------+--------+------------+
| baseline        |       6 | 54.15s | 53.94s | 54.36s |            |
| mitigations-off |       6 | 46.53s | 46.37s | 46.71s | -14.2%     |
+-----------------+---------+--------+--------+--------+------------+

So that's pretty comparable to my ASI results above.

(I'd love to just run ASI on Skylake and show you those numbers and go
"look, it's faster than the default", but the implementation I've posted
doesn't actually secure a Skylake box, we'll need to add more flushes
and stuff. So that would be unfair in the other direction).

Anyway, I'm gonna crack on with preparing a [PATCH] series now...


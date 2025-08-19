Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C52CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 04:10:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C43B36B00EE; Tue, 19 Aug 2025 00:10:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1B6D6B00EF; Tue, 19 Aug 2025 00:10:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B587C6B00F0; Tue, 19 Aug 2025 00:10:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A46B46B00EE
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:10:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27E2CC0259
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:10:26 +0000 (UTC)
X-FDA: 83792180052.05.FCD8C2F
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6C4FE1C0003
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:10:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fN1CDyAa;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755576624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qmfjQGAu0x2ySawLGEMEIwfKVI9I0tFjLrH0aQjhiHM=;
	b=uTdVRdpvGjixGFgkMAPNcEoKqfhQxjSl3KGXYeQGFwFIwS2d51mElyZcyl7zORKeVxT3Tz
	K/XpCXemaq7Ro8Lw/h/bsiUswKUiA45ADNQNSE6oyK3Q/vahpa8W2LNhT5ZVZsqBs6wTDM
	BmAbzO3NhrHjYfgTDVBo3NX1vZkJvUQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fN1CDyAa;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755576624; a=rsa-sha256;
	cv=none;
	b=hN+Em0X3QUUmLf/ImQZ0bYPLFuvTs1kwz77eBjy1nKxmV77vwfd8qYrXqGLJJXlePaJae0
	Iil9ILwh7d8dSLJOuAOoRPxUXNhcKDNeb5tR2GgZj0QzUAGaqfYj8ZobOcQ35p9a59IgYD
	wXzUYHOBYcVZOgGqYke7XUefR4uBTdk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 6141F5C586C;
	Tue, 19 Aug 2025 04:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDDBC113CF;
	Tue, 19 Aug 2025 04:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755576623;
	bh=Ct8DYP4h7623FT1CRn0CsCdshuMSx0q1mS+4qwcuxzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fN1CDyAaGE0qO2+jq0hLxayWgaJoaVi82Uus2oAxxH8wd1MOJlCgropkYU/CtEzuX
	 iZMyYl+txKaTLb5k8buB8BcQf1NU5xcYzAY63yH1QZTR7AVh+RcMWsUyeJPxPGlHLc
	 EzFbJj4SKJiteAmgPaAj+ZjtzAj0bD/ooFv2gT55xMII7VrRR9XGOW8gx+Rh42PtLj
	 tSMzc7AWX+6Oec2sEOsRhvQtSoRXyOTfjbtCgNMLGg6bmKbRcyaK3m5WpNUHxFw+qW
	 +cXPC/CSobhPW7j/ii5Waetb6FPQ8hgeCUYVHy+jYgVuHqNhKR+v3gIzw8det0X5mT
	 xpbfihN0yVwiw==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/core: set initial quota->charged_from to INITIAL_JIFFIES
Date: Mon, 18 Aug 2025 21:10:20 -0700
Message-Id: <20250819041020.37596-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CABFDxMGRO_Mh-c1RvB3-SWAN2SJZK64qb==sOqb-MhtX56_E-Q@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6C4FE1C0003
X-Stat-Signature: r5uj9kj38qhw8zocj6o3mps8wmmkd9ae
X-Rspam-User: 
X-HE-Tag: 1755576624-121427
X-HE-Meta: U2FsdGVkX1/I+GG2qTeJ7GW1t8fqu72r9HXb5z+dRgtPDq/vs9OwIIaTKWkHIMZwqaww+2dlVPKTcj4j1vmY4Ff1RxtNsSS5hgmL3Xohwd2eBs0/twH3rJbmzBoEJmxfEbud1LIjOtqKp46C1k2GwcoHqB1LfzqcYbcFg9IX0wZMDYKPwTEiqKn3kZh12grd49T86wlawpqrNQj98acviWzEs7ObjytKYFwxcYl4H9u48l8gYRNR/UVo/E6GUGmoRchurKcMw/nZKZTE8/TiZcgEImJki9vbYYV7zjMft9z6ZWBD8rFCcN1t/9WsecsMpGrBc4DMm27OEx54c08hNIxmaHFSTcFMIKdwxwsfSqngnW3wXGpXe2rblRQzgg9RciMYrcggmdyrB/lkIvcSIZKf/sZmQ3P1qBtKfmEy5jWYlREa3M4vJImEzYfDWvq42CXgTqOeOoy0OXby1hJjRFr7O7abCDZ42dDfMuy6mydNT7NwsfwWZFo0Fs3oFRifKNsDFfvM3N9ScrzhwiOIY1a7qUKIP7DxpEAGzLf8sVka1Ki8mSIyliGHw8P1XzB3zYkjD5g0huGXwZkzVFX+Cc9/6hoaXsiTvjcMQyQWKWJ6Tb8Fq2eOUtWSleY6zykBsdcYoM81P1Ml3IEbnsRALL6MBozR7xQRQoICgTae8PBJ2wmfRy6mfKJUdyLde6Ui5KET7b9MA2VKWxM1TQHt3ms+pG7ZqFjnHLMOP89OIpo2SGb9DPeBRVDkg9OMMZe5A/aPin1MBt4D5jrRn8n7TcIqqXF6fJHKVlF78FnUghEmx1UYjOOCmuC7ojiGGq6c5t8qUzljcVS2lyYW7vAexR9zlCk5zUaXVKYMWY2pX2WDVl43WSNeC98+G9C8UmJrL2Br15Ut0ZLdDIt1k3l+1osZYi2nY3xOTVwSKBcTO1CxDmFcarPrNfwNLlbQfzS/nO1Y8R8sivt8EpZUNqp
 Qs2svEmL
 uiEBX6kJLrCtbDIoV5C3Em61cYuVHmqUgj/cUwn/0nTBwvEG6pntyVdDmeqjgkgx/xxNcQlIbf7kxI5cQFdLZj/9rYCaDWcN7HipXH24UTL5+pa8LfdV2Cpj+J0+FeXGB5raUh9sj2tqb2fA15QKaQQUKqKZ0qrQL7yy19bJ2PswOGmvX8mwMtC0i/mq7osoufqCjmSPytxrDL6l7SGCKwJI9EPEYjTHWgezmgLQI4nZSywXQu98MEkvqEQFCdKHamjz0zGmzrDyR/rKdlK62vVpfMhCzFgS++YeTZDdO/vFDTYyqGbWNnAok8r4hU6eWOmS5jyYk51/CCJImN3JCU1/QIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 Aug 2025 10:52:02 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Hello, SeongJae
> 
> On Tue, Aug 19, 2025 at 8:01 AM SeongJae Park <sj@kernel.org> wrote:
> >
> > Hello Sang-Heon,
> >
> > On Tue, 19 Aug 2025 03:38:03 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> >
> > > Kernel initialize "jiffies" timer as 5 minutes below zero, as shown in
> > > include/linux/jiffies.h
> > >
> > >  /*
> > >   * Have the 32 bit jiffies value wrap 5 minutes after boot
> > >   * so jiffies wrap bugs show up earlier.
> > >   */
> > >   #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
> > >
> > > In 32bit system, if quota->charged_from is initialized to 0 as it now,
> > > it will not adjust event if reset_interval_ms passes for the first 5
> > > minutes.
> >
> > jiffies is unsigned.  Hence the initial invocation of time_after_eq() in
> > damos_adjust_quota(), which is the only place reading quota->charged_from, will
> > return 'true' and the quota adjustment would be done without delay, unless the
> > scheme apply interval is unrealistically big.
> 
> Yeah, jiffies is unsigned but to cover wraparound in 32bit,
> `time_after_eq` casts intermediate value to signed value.
> 
> #define time_after_eq(a,b)    \
>     (typecheck(unsigned long, a) && \
>      typecheck(unsigned long, b) && \
>      ((long)((a) - (b)) >= 0))

Oops, I missed this part.  Thank you for clarifying.  I still have a question
about the fix, though.  I will reply to the original mail.


Thanks,
SJ

[...]


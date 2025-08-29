Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD6D7CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 11:20:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0BFC8E0002; Fri, 29 Aug 2025 07:20:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E93898E0001; Fri, 29 Aug 2025 07:20:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D82AC8E0002; Fri, 29 Aug 2025 07:20:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0FB58E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:20:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36063BA743
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:20:41 +0000 (UTC)
X-FDA: 83829552282.30.88281B5
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4C045100011
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:20:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=a35nDChx;
	spf=pass (imf14.hostedemail.com: domain of 3BY2xaAgKCDIXOQYaObPUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3BY2xaAgKCDIXOQYaObPUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756466439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AMZx+r0Hud3j//XxrS83eFfSTnjOGkzpkCOkpFgd4O0=;
	b=P4QYBlezgtFtnTURVQmDl6TysiB9+mzcoRb5r1XS027wJ+v4m1+A3r6a0WGZaifwCmGl8j
	AItlMEr3dfCJMupRinR6vMm9hTnD9uA2LpCygaVJhLkcLCD3on5Y0sytZ4+d8e7n63u+rQ
	+95UuZqiALT9o8kNlSpuWEfpL9lupkc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=a35nDChx;
	spf=pass (imf14.hostedemail.com: domain of 3BY2xaAgKCDIXOQYaObPUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3BY2xaAgKCDIXOQYaObPUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756466439; a=rsa-sha256;
	cv=none;
	b=5s8YTxfvPYbUYikZdv2lZrkKvfWmRz9jlRhY/5EeEoiUJf7s8vramf/kYh8yF6w0TDzAd5
	NdL/8uC1ZlHKjdENa/XGhTTwb+wtG8NBp64jpT5SHej/MNc6B8FJnIcxBTN4gc+EBmxg4/
	QzAReoaoa48GheqYR2RQ0vuJO2irrwQ=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45a15f10f31so20705655e9.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 04:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756466437; x=1757071237; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AMZx+r0Hud3j//XxrS83eFfSTnjOGkzpkCOkpFgd4O0=;
        b=a35nDChxR2BQM+xqZ01De1zxhJmdrHItAc4oQKqJYFqCkIkH46mnKpHR5ddQIdj6ur
         jr/Rrx8x8FNmK/yvYo4KI5tRNZYwa5KTODIAPvWTtb47oWnOdWDJlm66Ps6M48WNC4KP
         DLcMqWJS8DD+ZFPVlORmAr/VEQESIEaHCmTDEiLjJtiN9wW4Okz1SAvg2ihssYfL8//a
         ZlJ4adWOKOt1q9FI8hoJ0AsawrAT36OZ8ipWKi7H0iymMy0vLnW/ww234/Nzb7L2YNyS
         b/IrufdjuEV8YdfMe4+mAF6obr1JS4ESAwmCnNVf6IGilg+Ckj52m0G7pKdu/1ZIxBA2
         a0WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756466437; x=1757071237;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AMZx+r0Hud3j//XxrS83eFfSTnjOGkzpkCOkpFgd4O0=;
        b=O7O+QAx/tJ1kiVTG2Zl1YeDkbRPvYsRux8Cs0Ly5l5E7czmRRcNWNpaUKTQx2fQfIS
         Fox1hsOf40lT1i+1RABVU4RCso0cFCmH7IvnEms6JfAjKOOz07oJVYWHOhdLIqJ59hG1
         2r/czECLHW/VP3VMWGTo3aWMiJJpJc505yKxrMNb7F9WJ3VWW8O1mQAljbwm67Xb6fTM
         j6Pq27m02BsDo+hnxlGf/19YVdZjtAHYAHz5DcZJgV7fOgjXokSlXqZQ9vZ0JGLJdKeG
         4lysGNS/u3j0Hr10rvKsxBvd9SNKWpYXjgkRw3OKmTcgleHFOascLMmrUI+wliKgEMgc
         CpcQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUabcJXdlXmMgSA+PyOyQa87T+bfJhDLP/318UITcGhqABEJcitqhK2jTeCLC4JJxJPy5GZox0mQ==@kvack.org
X-Gm-Message-State: AOJu0YyuxIj9OiTYpPvRaZG44EzIP97sCLjcIJeFIa4f8iwqvcvCySQv
	yDEwZm2rlQAG1cB7di8d0WnuKwKqhlZHNH87Vuw9gLzNUlkM4MMddxL2XupxAAnShO0QaUPfmSP
	U1Bem7bYLXAEQYw==
X-Google-Smtp-Source: AGHT+IFoJKnXd+Meni3wLFOMGsEYNQl20W186Gg6WN3MmwOInaFlSnun4yJtYAcqczMV8kqIowcrP3+LUood6Q==
X-Received: from wmrm4.prod.google.com ([2002:a05:600c:37c4:b0:45b:6360:643f])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5c84:0:b0:3ca:b6da:a5ce with SMTP id ffacd0b85a97d-3cbb15cbcf3mr9482921f8f.23.1756466437518;
 Fri, 29 Aug 2025 04:20:37 -0700 (PDT)
Date: Fri, 29 Aug 2025 11:20:36 +0000
In-Reply-To: <a6571b18-a63a-4e9f-b911-7cc10c72a4c1@suse.cz>
Mime-Version: 1.0
References: <20250826-cleanup-should_compact_retry-v1-1-d2ca89727fcf@google.com>
 <20250826191320.d5aa551eb5abef316de41175@linux-foundation.org>
 <DCDBG4WR1ZDF.23COVR1IO2OSJ@google.com> <a6571b18-a63a-4e9f-b911-7cc10c72a4c1@suse.cz>
X-Mailer: aerc 0.20.1
Message-ID: <DCEVDXL7WZYH.320PPWEYJI0NN@google.com>
Subject: Re: [PATCH] mm/page_alloc: Harmonize should_compact_retry() type
From: Brendan Jackman <jackmanb@google.com>
To: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4C045100011
X-Stat-Signature: 1tr4busht9cruegca769b4jmjhjj6a4s
X-Rspam-User: 
X-HE-Tag: 1756466439-591382
X-HE-Meta: U2FsdGVkX19G24kwt0kPp0ckzzo6CzLHsWWnfczkbOOerHwkk2rhtpvO702gRgVEIBU2LByutSYiszOZryiJqaIjmsbus/UlDwRoW/VV+zqHxQawc4tfn6afyowlZd6+i1wWzgiBoiDGO/K/piJKNmmaqJbTGZiC7LfhnYlDH60wGWrTOefRmelQW/EWM7lPo4fmS9VjtpmCbfbsrj5klN/52+O89RwfRSE5ga0PSaj9TLlMFryqlIcSIYRLXp7bhl1QcCrhL01djLLq72xTF5CHrtl0JfXXegEfF20HtkCBm9bXeiU1f7PudV5tPwkF/7goss13it4rf6oSLRbNLUnj+Bivsr9AMUE4rHo3W47kHGDYaXiVU2f1cz1nArXPYcHDIdPq175GqPOTxO80RpVF7XFqT3ppuVdwxME/TqaUKDzJAlIVtcipoI9hsNpbezeo+kYIVu8LOumIvH5L6OlBEFV5IMp/6aEv4PNy2biFs2qsmc3A786hvlSqapZXWdAiO2g44lGHxruLb9GyVSuyasZMkLFqESbNgFgxo4o6yddAHlXiAnyW0FJ3xfVy2Ogoi5XdrchTajkTLfwJEyKWbkdFCCueAPr9X/xNzQsg68jEEP/rihw7mbfDBSHVk2zE/VgTbDnwRgktukffdpzPxaOLP3RRR+F1+3xaJA3KPOLQfe2yFaTznQomJ+BEAUDlS5JP00ksQ0K29CQeDr+S5+Ri8qbQLgbcJy5RumtbL2w1ZO/qL5D0hrqqvdGJLs26OViLDeRfVAP1bodHywfwXvyYJezbrO309JSJajNbublqxL0zFzheWOcZuk1BfJQAdz4gkIaJwOP/3KkSqWWZnParHZXm/xg78NUw6FSlCXPiPfw8n/we0Q9Tr5TpVaM+ZJ8VgYxW8tR8VAJaC1cLiDkH/jT34FpVof26Luj6P/gevZ/D4xojZUBwtvIRkfeROJxcLK/ghsEZHpA
 m7V7LxPN
 4jTOyjQnA7JHYpi1/0g35MuuKdL9jfa45jtim0CneD4LpK5nMUglaPWS+DBwEVhT90aL1SqO+6CC2WhLjb2HegBZRog4/ytBQan/3PdUPf+aCG3lMjGzJ/OEhBCdaTS55u09M76ECJVSH95b4LQE8tfrH42G8uocb8jPL5pCHMCoO3Q7m9Ty4XH16mUI/bfRrKJqcIDDnTP7S1naSfHEwU6yO6IlxR9/iflgxACHtm33lpQkyep7lM/w48tt+XObO9Xqe8I2ddI9A4dAN6dYNdxOR3i3wTxLe4nr1tcec0lEY9LE+RukRAe0pGMQyKS0NSrQIXeoKBqfGClC5XDuhdRWRLp6YGxXh60RTBOIvj17LKqV+j/AcfwnGQS5WvsqHx9+oZr/b+c/hxltTH4dUZK3ZkV2s2tJ6qSYvjR6pE2xuGxfJ+1VlPb/JbZ0fr7Trc25KwFUvkSIQBCl+AuEqWf4YOLLjyQ7nKhEjiOQMBfuHrLG5CMQCMPFOQ38QWiVSN6sQu0rI8KPr+83tSzczPx4KQKpWCjenH5jsxkWsWoL5+S7BQ3zHVnCEAek9e7J1vcPoluaflH0c/fvxXV7bmNO9E36PF39nHYY1KAU+IG35McZFfl+DniJ+U6KrETKFYupu2+DbVh/nwJ0sZBAOZ4sceWk5S0lskq1W792B8ljxywmVxG0f8sD+w6GU1O/zuYLTcbDpvFzvJ0DiyIM1LPCuG8rxsVfrP4nf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 28, 2025 at 6:31 PM UTC, Vlastimil Babka wrote:
> On 8/27/25 17:30, Brendan Jackman wrote:
>> On Wed Aug 27, 2025 at 2:13 AM UTC, Andrew Morton wrote:
>>> On Tue, 26 Aug 2025 14:06:54 +0000 Brendan Jackman <jackmanb@google.com> wrote:
>>>
>>>> Currently order is signed in one version of the function and unsigned in
>>>> the other. Tidy that up.
>>>> 
>>>> In page_alloc.c, order is unsigned in the vast majority of cases. But,
>>>> there is a cluster of exceptions in compaction-related code (probably
>>>> stemming from the fact that compact_control.order is signed). So, prefer
>>>> local consistency and make this one signed too.
>>>> 
>>>
>>> grumble, pet peeve.  Negative orders make no sense.  Can we make
>>> cc->order unsigned in order (heh) to make everything nice?
>> 
>> I think we can't "just" do that:
>
> That part should be easy to convert to a compact_control flag.
> Zi's point about going negative seems like more prone to overlook some case.
> But worth trying and the cleanups I'd say.

OK, I can take a look next week. From a quick glance it does seem to be
worth having a sniff, there could be bugs in there where code is
expecting non-negative and doing stuff like using it as a shift index,
in cases where it can actually be negative.


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9BC7CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 15:22:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00B686B0096; Tue, 29 Sep 2026 11:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F263D6B0098; Tue, 29 Sep 2026 11:22:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3BDA6B0099; Tue, 29 Sep 2026 11:22:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B27AB6B0096
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 11:22:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A00E1C338B
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 15:22:56 +0000 (UTC)
X-FDA: 85267167552.29.F4DCDB3
Received: from mail-oo2-f41.google.com (mail-oo2-f41.google.com [74.125.231.169])
	by imf09.hostedemail.com (Postfix) with ESMTP id BB2A6140004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 15:22:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=esJ+FdPy;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of torvalds@linuxfoundation.org designates 74.125.231.169 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790695374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9eZZFPBNxtfOlsCifhs9U8AcK3CT+8uiPgj0yDOTXkc=;
	b=FO0ZTcxkq/i4NaB2BvsVKB4qOWHKBpJ4m0P3xKiFUnQNAVMZYqZXAj7qholdtt7qoDcvzw
	YJQheIzq+id2iKexiokKNfhnaLbz2vnX54iowtQkuHQP0Lhnm87L4ca8+IVKXqHLal4bnX
	qSUNzLCLIlBPl0U4hOwcx3rSPzaCShU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=esJ+FdPy;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of torvalds@linuxfoundation.org designates 74.125.231.169 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790695374;
	b=AKnfeNkvQ4IzLL9h1Ms8U5cTl3wdl2GmsfXA7IMoH08ERe9mL76Rl01isajygRM9Yu6+Lf
	8B2AHZP2CYm3C8RPVfWqxCM7Noua4Kz/nGTW1Kwq7L4oIIBUc9VewxQPyg3pjHxSv8nijG
	rKwAoczwVBn306b0tH7Br+T7FNHMxLA=
Received: by mail-oo2-f41.google.com with SMTP id 006d021491bc7-6d33d80855eso2977078eaf.1
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1790695373; x=1791300173; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9eZZFPBNxtfOlsCifhs9U8AcK3CT+8uiPgj0yDOTXkc=;
        b=esJ+FdPydzmDC0H0KYKY/QIwl/IRjpcRwDkxZJyiv233WgV1+uGqCaXJOTVmc7A3UA
         I7haFO4UW//EQ6kzZnuGE4Xeb0wYTrOorR9GRCphOQp73ZJ0uBWYL2eqpg+vSaL/4J3t
         ZeD3bL+i+HzMxVZoxdAWi3r+6R3khL9tpkRZo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790695373; x=1791300173;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9eZZFPBNxtfOlsCifhs9U8AcK3CT+8uiPgj0yDOTXkc=;
        b=H5OcIMlekaNKYXMMSd8di/NH96GfYzIg0Syox1sxFGrUBuiEmFVCMtRYfuYSEyODuQ
         X4CivehpF55Kax+g7RI5pk9iVy6XJasEUXjhJY4VVrv2Wv8kDHavnA60ibkn4I/9EOct
         kMiTZuJhlpWYjlBTL3/dwBdLTYwZ7SmXveVjS8rSWJ1PwfI0hcrCVV74/HSP+3hAra8H
         NSZF7cOc/NoATumg2JSkFcEazmMMOGO1mhAn+Tj5zTr0qE63dlCRB+rgCtNFTkYcty3W
         TBGcbK+e2eKrxQd8UI59E2eqlID5t6cHOIdlZ2v0tFi4oLOG4eF4Hki2jb+EsagWgCH9
         k96Q==
X-Forwarded-Encrypted: i=1; AKwUvBzAyR5u3++0r6xJeCsPdYikvsMHP7hpZ6Aq9RHkE6XDmILEqiIemFEl3uyuERd0q0vV8i87PAcRWA==@kvack.org
X-Gm-Message-State: AFuF++nOEm1v9GPDPm757hnwkW3ASJBA97t0FLgHGvnMOdsa5r5UMt84
	zhmTojfz5H2QFCi7nNBPMTbqD4VOHQTPxntm7HnKTQVaq97nbiYEANLVc2e54EKUCk077WULWRO
	S5MRL9CgDIw==
X-Gm-Gg: AYBFou1q7Mi6hQF9YFteqe9OKFw46I2BTCfqCSZ9jpEnGq/HMl/AhG81grY/3+j/BsU
	riGLhF8QreVf35YrS37kXWsEkWqofdzlk3w8uCmnSvtvgD/NHIDWQNHGxbZOKJmlS3k8mvCc39j
	j2EuHuDIVgYLx3zvGU2gkKKvf68PwMdrDz7ofZcKIcxAUks5uLofgpNYrDf8U0nGphukQ/kFhn6
	h/cc3Qlvkj1uXqEUyzNkZpb8xF+/CGRAQL8A72ED+8A4fcypMixQFRgvFjbLiJxVRl3MueAYzrR
	oPOq8CTZKMyaF+g69swPYRo8cKwgH1YUEbnbaYZeJp61IO8vkB3NFkUTgew6nPH0fk7QZ3g9KMo
	RqjSB5QdvxYvLcXi7yqRPQ2+61kBPfqzY5ixnbtVyduuxo/gxOgNDsraqnShNEMF41wr0pdNFIW
	D4PMW541TywzahukSZBSHWS9bWuMH9Lyd4yb6nUE/nMf/CkFoWtKPArOK764ahMKv/5cTa9Ssqn
	jZsysxTJhlLPmDjY9pTmTimPnnb5H3Adx35QUePjjqQFai/Xw==
X-Received: by 2002:a05:6820:188a:b0:6c7:6c8c:14a7 with SMTP id 006d021491bc7-6d43f2c43cbmr14412464eaf.5.1790695372597;
        Tue, 29 Sep 2026 08:22:52 -0700 (PDT)
Received: from mail-oo2-f40.google.com (mail-oo2-f40.google.com. [74.125.231.168])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-81faed3199dsm115618a34.9.2026.09.29.08.22.52
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2026 08:22:52 -0700 (PDT)
Received: by mail-oo2-f40.google.com with SMTP id 006d021491bc7-6c72bd8a02fso2386768eaf.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:22:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzO9ydbRii24qaNfafUducQ5ur04yO8RdxMzJiGiYDj0MYUb0RPDSsj8GqeXSEFv9/Yp1l3ZmiAkg==@kvack.org
X-Received: by 2002:a17:902:d483:b0:2dd:ad73:5b68 with SMTP id
 d9443c01a7336-2df7da85639mr143411375ad.24.1790695032383; Tue, 29 Sep 2026
 08:17:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260927155134.4740-1-mathieu.desnoyers@efficios.com>
 <20260927155134.4740-3-mathieu.desnoyers@efficios.com> <CAHk-=wgQyCdrWH3ZuSajOxZqiups6jYbPtqY8JR8OeS7yi49Mg@mail.gmail.com>
 <133ca8de-cf30-4bf5-9539-d0b73e347b22@efficios.com>
In-Reply-To: <133ca8de-cf30-4bf5-9539-d0b73e347b22@efficios.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 29 Sep 2026 08:16:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi7BkCuzMe_zWi6KHUs09UQWJpCVNvuFg5wh_CAu5dgow@mail.gmail.com>
X-Gm-Features: AclHuK92qcnFUvMDyEty0mgzRt4zpmui3HdPCBaHPsJjfcUlLFRzvquKppDzHHE
Message-ID: <CAHk-=wi7BkCuzMe_zWi6KHUs09UQWJpCVNvuFg5wh_CAu5dgow@mail.gmail.com>
Subject: Re: [PATCH hazptr 2/4] compiler.h: Introduce ptr_eq() to preserve
 address dependency
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>, linux-kernel@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Joel Fernandes <joel@joelfernandes.org>, 
	Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, John Stultz <jstultz@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Josh Triplett <josh@joshtriplett.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang1211@gmail.com>, 
	Ingo Molnar <mingo@redhat.com>, Waiman Long <longman@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Vlastimil Babka <vbabka@suse.cz>, maged.michael@gmail.com, Mateusz Guzik <mjguzik@gmail.com>, 
	Gary Guo <gary@garyguo.net>, rcu@vger.kernel.org, linux-mm@kvack.org, 
	lkmm@lists.linux.dev, Nikita Popov <github@npopov.com>, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: cxci953xr8qjh1xg3habdpequyczwy7x
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BB2A6140004
X-HE-Tag: 1790695373-876832
X-HE-Meta: U2FsdGVkX1/Yi/9vqf7O9YBQOh92zTKlk3RZ5/9jOKGGE/DCldLe4UB06VBSPyLkoxaxa0H6Kxez+GJ0gbxLGc3mAFibyAM+p9RkFAyphDsSLJA9tVPXmRrAmcapPMZr+/950e1OzTGTq/Pz+CsJMz3bGxl400nxjyHV2UtzOr6JMgAzL0OLHlPFQ4/9KE7KHNldmIPMdQhjehzm4kgXy0oxELEQPoLoSQqOLciwfvUZ5uDD9V7BzwFLB93YJUWkryQQ/XtssKWf/3wRNwJoqUC6zUHDHRcLD+EOUFegJe/GmXemBXH/1EQZZHACrELu//+NB26fQJGuWbof5LTt2VEnmGuaaRoWf+2zRG8k5PM0YtO9QiWsud/6LNXNsD2tHDFrDOwjvcMvqS5VRzC10/qwbEaE+WuA+qizOcNMAzJItXe+sawwiSCfIe3Ae+M6v97c9bNNm2tS9MJzbBY8tI3wAqdMuQ8cDBep75SPQ/mITtOdksRaQ4JAHklwUeye8XdzsGiRwx6pfg/9Q7mT+SfgT8Tjp7E3e43HkEenbGjms5cVbbNaiZ/J5LFqRX9Vi066iVh102KXkbEI+B7ozwUmfuTCJ7giDd7kRRimIDm+iUO4ZLMODGKxjHx266rJr/Tc00TXCLk0V27InXXRU+SOqNGqyYHYYX2y8MZ5E1VuqUjbgP0SVP5gxEMiWo/zVo902XUo9Fb6mNWRCzIZYqiKg/Fmlz89Imel+lQmthWXyWEh+CUq6dAzVt2cHUWt0JlUDcLT+zaK8Gl08U4MX3qWPZCO3I2ZA8+AedQzJ1Mc1NEiaLIX3eWdTS6UwYsQnsSzLVL6YEU14Y5POOo+vweUvpSJKXxbphiym3gUiF/mQhKqyoRkQLvyll85L+77SvxJKaJgMXXr+aGm/+96D8F5hiePvG/BaIAL2UeaKUKfnT34c/hfUXE09DxrLMQm6c6PYq2yEbbcEjQz/UX
 3T71xHif
 DaZPDlASGwyX1ZvnXWwpO8S7puyascbaGFI6NStjV4xwHkHvL70ht07qg9UCQ68JRJrlOcUV8YgPDi5Tmv/piejXS/yXaOyGOZvgdGtHtmNbiudsdUMzSGYaBrWIH9VVQspjX+3NOkEZm/HtWRiDqah9vhSPgkZjZpDxFtJnaRMUxMVNWOCX4CRWPaORH1vN8SUR7wSxhMuGSh8dm9c6uNLniiEraL26swbmX6X/HH10pyHCKb7C/YjXg2C+vYdHZL4PXXMBcw9ArS4H2WURd54GSnzWMQ2/dd8KnSbEnwwRQt6A/YY01p42FbQwR+BmSxM3NvhJuW8jFXyQdU/9a1F5CqJL+6GvNZHxFWmsRaxkLDBm1tacFI+GZzqT8qJrOhytbmd20tayWrZ2Mhnk3VpuYcZF1EZspQG/BthViUYrVMwCotbmt+JPawTRSEtDGidO3ce2OQxRfoQsReEgqWhllwcplr5SfcuapqJPVpy/V4ZbmYi6FQxquh4Es9jigvzzolYhUjIFXc4Z/g/b1Ig3AKqjuChtQpZvzm0FQfDzt5gl5fwwbuO/9Fd/EeAjQ4kk/uEH40VcmahKBb5bn2URlIft6aFc8eiMXupbg4alPNLhSDitXz7Fpp/I2x5BnuRvFIf1uzcFCXDK8wM5rWmF4J2uSU5yngDKrUl9XPOoAfxUEDdfw5X7yrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 29 Sept 2026 at 08:04, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> I agree that doing it in asm would generate better code. Also, I've
> been told that clang now preserves the address dependency in this
> scenario, so perhaps we'd want to use preprocessor conditionals to
> select how to implement ptr_eq based on:
>
> - architecture (allowing asm implementation overrides),
> - compiler (e.g. if compiler is clang >= version X, just do a plain
>    comparison). Likewise for gcc if it ever decides to fix this
>    behavior.
>
> I think this "hide var" hack is a fallback which can be used as a
> starting point, and then we can specialize based on architecture and
> compiler.
>
> Or do you prefer this in a different order ?

Oh, if there's some sane way to tell that the compiler already honors
address dependencies, then that should be done first and the whole
thing should just become a simple

 (a) == (b)

for that situation - allowing the compiler then the freedom to do
whatever (which can involve not using a register at all, but a compare
to memory, or whatever - the compiler might have reasons to avoid the
'cmp' and use another sequence entirely)

Then a "if we have an architecture fallback".

And then that OPTIMIZER_HIDE_VAR() thing as a last fallback.

               Linus


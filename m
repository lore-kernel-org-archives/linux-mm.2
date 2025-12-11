Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A317D3E788
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 03:30:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82C356B0005; Wed, 10 Dec 2025 22:30:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B5AE6B0007; Wed, 10 Dec 2025 22:30:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6839F6B0008; Wed, 10 Dec 2025 22:30:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5352E6B0005
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 22:30:14 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB0431A0443
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 03:30:13 +0000 (UTC)
X-FDA: 84205761906.18.EFB7210
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1800B10000F
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 03:30:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VemsgVHa;
	spf=pass (imf05.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765423812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A+kgBa13isDA0TWyZlnig6dj5RwcTvhBOmcf0rRVr9A=;
	b=6Z842K0xsfvJQhNX+p85OBMqGLbyxTl+D8ms0BFq3kWFJU2UL+rd6lJ2e3ZiyCC9DYawvu
	+BNGlJafGQIfBFDR5xoP60HzpB8CDVv+96eUNSgDKIMCfAv8S9TZEhQ9pDFnYz00GbLO7E
	Cpo2uwiN4EO1NEOr5Uw28b19ho44Was=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VemsgVHa;
	spf=pass (imf05.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765423812; a=rsa-sha256;
	cv=none;
	b=hw5H+/n+1TkuBBV04isV+bN/nVYIbhRmAwjcUvi8VMar0fjhluaOF+h9UIHmQrUlZ0I9Bn
	CYrT4Emow16u3+DJfeyj4OFJPnXykeDeMOorZFGxGa6vleK1FTSVD6bC4UElLBuEdv3MM/
	kygO4ISyvmLAIOmI2hC+hVuIDwhIDUE=
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-6446c924f9eso470087d50.1
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 19:30:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765423811; x=1766028611; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=A+kgBa13isDA0TWyZlnig6dj5RwcTvhBOmcf0rRVr9A=;
        b=VemsgVHanELHi060gwvm7/fTA+YTTjt3kZzhJ+YTekATzqgrvIyQu4GAnrkwMQK8fg
         qPtO6WgG08QequoXSE3pQZULAyZXfcysFpYWD9i8aZKMyL1JCJB0MLDP6UZhZm2diWhA
         TN39KHjyP13GwdiqArAvDAYXIhHXEYzMmUTH7Sl70I8sYFreG4mj0dMPxnELID7e57pR
         pDGrkehfRSLbRTy6Ye3vnowUwJOozPoa5kJOZorivQHToSRSw4U2pgX9Yfx1IxqHwBo/
         eWhyh3+Ror3dZ8eqQUwRrpRqMnkMJNAZircC7W8CjvJYc3lA2e62xsBmV7+sqUWQI1Cu
         ezdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765423811; x=1766028611;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A+kgBa13isDA0TWyZlnig6dj5RwcTvhBOmcf0rRVr9A=;
        b=rUJsr/CRsrVvmt5lZGu/o3WoiW3BskHOpcltqBLbYR4us5s14FESYO6hfqsGqCUuBf
         qvZTlCbMMuT7HHyR4jQmixGMpBzmsAuaKoPm8Eq5B7lm7o7HAD6ypQHITqQPegHWDmFN
         IyQJM3C+ffRizCsRpOHFpE4sWGNecgxxT8rAK7XACYgof2YKUFn9IksDEey8K+GJBt8/
         Rn4cFPvBj96maTW/Mc+YuCGytowh6lIU1TeH+/yHS6MedEj+Pv7eAJyeOdE8KsA0rZvn
         xWyA9xDTUyWMl2BBTeyqzZJvpIGwcgKj9InxtwypgQDHpCgyGRhD8zBl7CkvEgrt5uRh
         UK0w==
X-Forwarded-Encrypted: i=1; AJvYcCVMK4ljl8sNJUDUdo26mxxQ1tg1UaXT2ZBQ3Tc29nV47EK0up8BuJ1ACKJ3jNSHaXsaJqMjAYpZ2g==@kvack.org
X-Gm-Message-State: AOJu0Yz79iK7ZDU0nu7NpbRSL0TqR/+ND6rZfjlEkMoxMNzurnH2ULHL
	Bs3Kw/lUFkhPZ+jBkdaFBriCOkX3BAPnaEsxO/Em/wT/OkG9DLzLT5DlZMMthiK9SuJqi48+HAg
	afbEUtDm4YsT2QS0cY9xWTN8qzQDllbk=
X-Gm-Gg: AY/fxX6eE+4E+pDxaTX0LghlmihoWuA4mnakL4UfWKo7m2gq+fe6tyjTYi9Y9U2m5d1
	aEuTpv3eVIy82Ll7cORq0vDbFopiQeUlGcB9qB+cBktP2qr4QJ+CzEAZnw/l3FciIjlEgV3f1NE
	yb6ReQG0v6e57yikalfvQ16XorNaEZ8/ATLT0mdW75QOb7QmjXJVAZakjFiMm3pEXCGnCA6Je95
	lnvA5niDh4rA2rpfUFyvZl/ZH9V+87OwQv6wJ6fTlwE80H1HqbRegadfuMJ1KDJ6jE/xg/K
X-Google-Smtp-Source: AGHT+IGx1i/hmxNAhGumNMn4ohfzd7BdjnbBCPqjWbQs+69758IpzoHPpanbHngMm3xv6KkbqhaIcmYer50SEAgvZm8=
X-Received: by 2002:a05:690e:190b:b0:644:60d9:7507 with SMTP id
 956f58d0204a3-6446eb5e004mr3726542d50.87.1765423811010; Wed, 10 Dec 2025
 19:30:11 -0800 (PST)
MIME-Version: 1.0
References: <CAHOvCC6_-h1jQkZMbtYDC_jrB490jzp1t1Fx-_mhYnE7tqvzbw@mail.gmail.com>
 <20251210025400.51467-1-sj@kernel.org>
In-Reply-To: <20251210025400.51467-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Thu, 11 Dec 2025 12:29:59 +0900
X-Gm-Features: AQt7F2oJTFEnWJmg4wO_UeTkwCp5xM6MSBqPed-yCVo1NfNtcF-iEdE1q61GoxY
Message-ID: <CAHOvCC6bJLf=LuBpm90n5poz8Sqhz9wjXtk5ypbPwkvhb1ptag@mail.gmail.com>
Subject: Re: [PATCH] mm/damon: modified damon_call_control from static to kmalloc
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: htfz5thwpcxb6oc898gt9m8izq9pygd1
X-Rspamd-Queue-Id: 1800B10000F
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765423811-790637
X-HE-Meta: U2FsdGVkX19LiFVnerz3g/8MulQ0PgIxSO845En9dJPD1gR8CnHGxpyGhQYw3/UlAtoS1At4MfZcS1Jjs+QpZEw8NC6w4hylrnY+cSJEmOmOvuzRAci4QwKedB25o0KZ/DJkgK4tY0JEhM7Hd++h0nLGimsggh7T2vGVDZoHEaMlNy+4YVkSz5cdJzv4j0SB/PQFYdD4iF0OfyT24fLY3H4HwrawJKvdx4W0nWfCb+HnChFmhk2p3S3fLMnUrGqirHP+WJ/oWFcl40JKx8doP5aKsy9EJ7m85wlkQN0u6whQ1jPvDwQJXjjZrvTNWqbhC2zBxYoECV6yPAmQjdPB38RQLE+bBQ6WNx2womJRVzWevsllof5lEkR/wxRlz82A4icS7piyBsOCwyVRuI7q+18KIMWNg/zvDFmxtvRkZL+JbtZxlP1a6zZIrpyQTMau/OiLhTAeIls++76uVfB86RePlDjjOtVs1RgPH+pWaQEcxTH/U8flJ/1s7dhZmCUfgUJSNOgu+fEBxaVbCXm5QLZAIyA+2L6MhwwABXPT6DxTza4v1uB5t77Bj6RtfN4vFga5DgpN99k9xJZOemMpNjgxOPzR25eXhaUUaCH7E+s1Dt1bPZQU8G7kznARrqcLJtiuqb/Z3Ti235Kxjt6MnLO5vtufMez5duZmXoYPc3U7MyvB2CAtEsj9haQ9gFkSYXQlAt2tWaZE5bw+rCJ+1LvqXidsbWBdxYs0vaJMC0zs6CXMx3mAqJGp+wOtM69zvQbR7MDBYYmurwxVJy4BBeCjPx6CT63i+Zr+YsVQBNIoa32wQLKjBYKwJ9ns8IO5lDZGs6qtomDoiz+OmeOJUsbXzzMhoOitFlU283Z0rlEvawqWDBFfxO0gAeMwE17LkIw8goLpKksHG1sqsdtrNC9SSU431ob5Q+cE+vCOV9YR7Q9DtmN18ITjHEYYDuK6OoBPfcBA9DQ5rK3i1z4
 KZ9p37um
 stVlvG1osJL5G6YQLv5obPO/rD8jjf6YU0ySejdq9srzNS8y6caQAOcFocsPCAbCsKUo8odB7k3OFrz0NkI9lTuHrLSZ2+ULEGh1bALakhvRRioBd6deN5gTUAhrRZRRwAU6UzoJ8BObqrFsd36wZn5xdzNFvXJ8QcP8QKQeself9m5AM2mfjScFjFlSWtwytINOe33hCAz1+9Pk0L1HAhs2hSmtgB0jw5zifdUdwKNSw/FchUV3eNoCNEuNf+JYV7z7MkJ3UXUieKv5hjhZ3l3EduPJrv7vG8Nw+NMLrPaTHRx+DCKEIWB9p1+r66jTh0qsgap0gPMR4d/Cn3/dSKeByeR0E1ITSmweVSR/QkXp2FOGzbBNq3domWOrNoqouTH8A+6o2TJBXrSpSnOBlBdW/ayhW/+bLBTVeaRvXSs/hOIeFPTsSoxQtZ0hQBjMzmGLX5r7y/ZZjemkO8WsV8u1JNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Dec 2025 at 11:54, SeongJae Park <sj@kernel.org> wrote:
>
> On Tue, 9 Dec 2025 21:20:42 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> > Hello, SeongJae,
> >
> > Thank you for your detailed feedback.
> > My patch has the advantage of removing the use of
> > the damon_call_control.dealloc_on_cancel variable.
>
> Thank you for keeping this conversation for enlightening me, Jaejoon.
>
> Could you please elaborate why you think the removal is an advantage?  I
> understand reducing code is good in general.  But that's only if the code is
> unnecessary.  dealloc_on_cancel is there for real use case, so I don't clearly
> see why it is an advantage.

I suggested removing the dealloc_on_cancel condition from the patch.
When using the damon_call_control structure, if you only use kmalloc()/kfree()
when canceled without dealloc_on_cancel.  However, currently, in other modules,
since it is static struct damon_call_control { ... }, kfree() is not allowed,
so dealloc_on_cancel condition is additionally required.
Because kmalloc()/kfree() and static are mixed together,
dealloc_on_cancel condition is required.
As you pointed out in the previous email, kmalloc()/kfree() has the burden of
memory allocation and deallocation, and static has the disadvantage of
increasing
the code size.  Both have their pros and cons.
Among these, I proposed unifying them into kmalloc()/kfree() methods and
removing the dealloc_on_cancel

>
> Meanwhile I find the feature might look complicated, or not well documented.
> Specifically, dealloc_on_cancel should be set on only dynamic-allocated
> damon_call_control object, but that is not well documented on the kernel-doc
> comments.  Are you saying removing it is an advantage because it makes reading
> code easier?  If that's the case, how about improving the documentation?
>

dealloc_on_cancel is only used in mm/damon/sysfs.c.  Here, since kmalloc
the damon_call_control structure, the dealloc_on_cancel=true condition is
required.  If you want to keep the current code as is and only change the
comment, it would be clearer to comment it out like this:

De-allocate when canceled.
--> To perform kfree() if allocated with kmalloc() when canceled.

> Btw, please consider not doing "top posting" [1].
>
> [1] https://subspace.kernel.org/etiquette.html#do-not-top-post-when-replying
>
>
> Thanks,
> SJ
>
> [...]


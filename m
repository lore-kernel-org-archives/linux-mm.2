Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FB8FCCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 22:56:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A0DA800A4; Mon, 27 Oct 2025 18:56:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 878098009B; Mon, 27 Oct 2025 18:56:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BB02800A4; Mon, 27 Oct 2025 18:56:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6A14E8009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 18:56:45 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1245A8776A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 22:56:45 +0000 (UTC)
X-FDA: 84045405570.08.513636A
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3B9DF4000B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 22:56:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CrAuQ85H;
	spf=pass (imf27.hostedemail.com: domain of dmatlack@google.com designates 209.85.217.44 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761605803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gPeAjFqslzZO/jSSiFFpijfK5Ylwqu6hbia6gADtquA=;
	b=xZlTt+QOYqx9kXdbzOsTQUvxKNAR8wScegh4Mvjm8Ios0mRbrPwF3M112o7N1y/P0yC77L
	uhtD7UCniQ8KY0qWl2M3OC1QW5+Am5aHG9mUOqD/zTG8vxOzZnlQobo5OOQy0P2OBvaJz6
	A53CkXEXzELmy7hBWKYaw4OwsoLxEE4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CrAuQ85H;
	spf=pass (imf27.hostedemail.com: domain of dmatlack@google.com designates 209.85.217.44 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761605803; a=rsa-sha256;
	cv=none;
	b=uYb48+EDewwiaV7Nlh6qTAm6vKLs+tSkdvXXW+z6pinpmgmpCsszCxmY//7qWFJfW2nirO
	g8yWoByiirOleioxdaDgIH/8CPX8rs55KnkLhRMpBx081OgfzqtXktg8A1f6WNvWoXU5o5
	yu1Ywv1HjZT1cdkacC8lNtnnGmjSIoQ=
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-5db308cddf0so5509651137.3
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761605802; x=1762210602; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gPeAjFqslzZO/jSSiFFpijfK5Ylwqu6hbia6gADtquA=;
        b=CrAuQ85HQSCTx+TSSTulP8M2VQjfcMr2v6IABUP0JPoTYHLMNViXLtwd5jKYfb5BvX
         rUb32fEWcY5Mf70HJGbChjFsfPwxALWBM9gVy9j7Q/zJJufGurhQPbC7yeEXd8IokMbj
         EyclI+WcedtRuvlSBtQlVf7obpTr70/BNGWFxTh0VpYa1x638wjfaoY/JCPg5a5KxPWA
         ujow0yQi5bGo4WS5vG2i+XeGOysNGrQgsbdHG7LsV6SWxgaN+UQI8mSmrQyPU76u8rAY
         6pYH6RhpQLerp9iFJHSanRPNdG1yyFkJ3j/2N5TqV313wDfJTi5lNmtI9gtsG8+okthk
         8bZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761605802; x=1762210602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gPeAjFqslzZO/jSSiFFpijfK5Ylwqu6hbia6gADtquA=;
        b=kHBmd/P+mMRXEI/84uAG+YJbQbZ58FOuXb6Fj2lX655K8s3AMF8UbZnMkWEI0RJtcZ
         qCuin79UzCEARVECuRf8InuLCS4ObtdQmRezDKF2qyZJ5ME7UjFMoVzOC55E4oMb0mb2
         854qOh8Zh2atU8vHxZ7d4VKP39+lysyHtqDrcRjM/2ePIRwwdbS7Qg3MoO+vqSJl21jJ
         canj2K4SBYALmi7j2TVGhG3kfLtcxCnf7Q2XF4dRKYdnoiCp8plNjZy6kvWTl/AZZyIN
         2F1SsURmb3nWEN2TG5yrjo+UFxbNZxzqTYRvVBQo4K5CwsvACRtXEoe2t7OuW5UZEPmS
         Skvg==
X-Forwarded-Encrypted: i=1; AJvYcCU0n07/Ks2sr28/LfWK9b5avnh9+wUA2ULwxqX7DiKP4wQkWfz3EgIv/2IAH7zj8R9LtZjCgwgp6Q==@kvack.org
X-Gm-Message-State: AOJu0YwDvaxYjW0L1Rug20rUHt6y8zgTyPIqYT32+hwjjndmdgkiFirc
	w9dPCo9eYeQqa5fTYAOD91o6fjJXhIYq9lyo+dMjJrr9A5MYLX1lqPGM92QON1jBdhrIXaa5ud8
	79Dw+1UYIq5SINes8pjKu7o1U5499X0AVzryyZgqO
X-Gm-Gg: ASbGncvIt7hwYi4QcA/OFxkZb1UcHvWIcKtY8rVz00pTRwKxA6lXi1E0gBKQEYyj8xj
	X1cOAXts+WDESd+z1Y14je2/UOZQYtb4o/rUM9+UutSnj38AZPgZSfaCC3ddppw86WVKDXHDj9Q
	zHN+zT/mAFrpdkM2s8Q015EeYVmbIZqspUEwx+oBEFSOaI2VKSBCNSi3eV559hsOIhHvLDopFSQ
	cYMQ4tS/vdhgV4JtvYFTRhP7Wi/B1CarG48I7pM7KEtByxzrjk2XX6zRrtZ
X-Google-Smtp-Source: AGHT+IE3NFl5iYKq1PKDn7984d3rHdCJwN7ZaruqOg19O2RBjeN4yB6Xb2hcCCtJPpgY1XGOlB+vycOpSxjLw3zT+e0=
X-Received: by 2002:a05:6102:dca:b0:5ca:a978:8a with SMTP id
 ada2fe7eead31-5db7cbfa794mr691226137.33.1761605802055; Mon, 27 Oct 2025
 15:56:42 -0700 (PDT)
MIME-Version: 1.0
References: <20251021000852.2924827-1-pasha.tatashin@soleen.com> <20251021000852.2924827-3-pasha.tatashin@soleen.com>
In-Reply-To: <20251021000852.2924827-3-pasha.tatashin@soleen.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 27 Oct 2025 15:56:13 -0700
X-Gm-Features: AWmQ_bkdfG5WJtpo7e9nvseFiej50xxYP8fjah3qsHcyMXn4OpZPKxHD4gTCAdo
Message-ID: <CALzav=fmTVGDxAUcuqmcegAtd8gEW4F3Zp3AGMQBtXrCQgp+aA@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] liveupdate: kho: Increase metadata bitmap size to PAGE_SIZE
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org, rppt@kernel.org, 
	tj@kernel.org, jasonmiu@google.com, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3B9DF4000B
X-Stat-Signature: ktmi35qgj69r8wf7md14f7fiuxi43ta6
X-Rspam-User: 
X-HE-Tag: 1761605803-852679
X-HE-Meta: U2FsdGVkX1/82XjaaBV3fxViSDBWTTjTl4Jd5Ml2cuw6+uWyegsjvUhXGqSN9LcOxOlkSZ8kN+dqWGOjCrNolx8crKyN80j6Glmj9/dnGOVXHq2q7CODP78g0wcT877XVnaX7m/yBxz+uewz+HNwaTvKH7MEDuYp2s8AH2W3DjR5p6F6XJ8vs/t8ssDw4TBZRSPPSHxsRryoGszgAcbfTCoUdlZ6/+kgh3g6p+Q3ZqelquEj8jF8mPmvL6Of+6FuNfStTZ3Oy6NoEhwoOeXvIF9N9yinXAwRZCeBjhFdbvR78rSB4bYe6OPkFIJvKHsQn4WOgRufAvvQO9olWYuXcO9KUTPK9UxvyPx9cK+vL9f6FL6R89KE3v+B7UEUyfNFQxAseyMpi5DkF8S7+KRY+iUNrNwasKkKx2jzZIwXA1onnZ8jnEkaNnhCWhCMOJ9G2RUWZOOZrbSOkgQP4AWNxx2ihf2AGOLKjyDMZ0p1CTkHfvk+vfjEqm8vfuzvi3h1rETvwT9l3JG14eqhst7AxZx95gkbGpmSrwXp1OOrGTYVD6rSsJFiXHEQSPE7fR69X/+WStoYCPWhCf16lA+J5ObYJbV7sCWul6Yn1zAWKL0RbBhHU4Zu+KQGVnt4CoNT1LXqHmmOUNPUFjh0OL4PdaggSUTN4aUcDr30FGksKuP/aZFOIEL2fThgeXT/gTgt7sKxBrBk4lOqIBusAQkcbMftymKxH6SvTPRKtDsE3yxKbEObN2/AnIHYMU9GD1qyl2wneB+zobyfp5nBd95UkgL7BEodvSmW/Y12rlvOt8nYD71c8bQrTeHo6/kXoBkXmolghZw52Goavu0Wm+ua3Q9QakNSl3qahAT+TT85Fl3Ph2PdY6pdwWpJgHduN+uz8H9kNoNWDpyOsDcN3zwCnqf9r6kG5+cVE/6Q9f7V0ZZuqJvSeqZAb7zGPHBUAlNiYdqUMZWU9pcgPuZhq3m
 KxBvrzUT
 IefLnHKd5+4pFmHAsSZknE9hkWl0jR6RuhBOlpYtSPxSQSN2Qx3VTW0qo0MBL9negbRNn5EAJTwOnwcyDUdFQvi/NSpY/pDqmV1brQI6MnlRyqS+Jtf4KA8IOxbaqxyfsfhTq1qru5ru1teOidEWd1SsGaokIEtWu7ulEiQu27MC7TTQYCaCRHlAZnicnwVkpcX2ngEIQ0hDAb2AVm0J3UtiQrMJm1iqIn1I/O6WILwGjScdHtjFUlYQ1auyTWASo+QhG+fQB2s5eDsf8TONcfC0JMYeW6J7aHpBGzhcuIP7cqsg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 5:09=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:

> -static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, si=
ze_t sz)
> +static void *xa_load_or_alloc(struct xarray *xa, unsigned long index)
>  {
>         void *res =3D xa_load(xa, index);
>
>         if (res)
>                 return res;
>
> -       void *elm __free(kfree) =3D kzalloc(sz, GFP_KERNEL);
> +       void *elm __free(kfree) =3D kzalloc(PAGE_SIZE, GFP_KERNEL);
>
>         if (!elm)
>                 return ERR_PTR(-ENOMEM);
>
> -       if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), sz)))
> +       if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), PAGE_SIZE)))
>                 return ERR_PTR(-EINVAL);

Reading xa_load_or_alloc() is a bit confusing now.

It seems very generic (returns a void *) but now hard-codes a size
(PAGE_SIZE). You have to look at the caller to see it is allocating
for a struct kho_mem_phys_bits, and then at the definition of struct
kho_mem_phys_bits to see the static_assert() that this struct is
always PAGE_SIZE.

I would either keep letting the caller passing in size (if you think
this code is going to be re-used) or just commit to making
xa_load_or_alloc() specific to kho_mem_phys_bits. e.g. Change the
return type to struct kho_mem_phys_bits * and use sizeof() instead of
PAGE_SIZE.


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A066D2168E
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 15:36:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C57B6B0023; Thu,  4 Dec 2025 10:36:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A2EF6B008C; Thu,  4 Dec 2025 10:36:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B4106B00C4; Thu,  4 Dec 2025 10:36:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56D846B0023
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:36:24 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E379B57902
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:36:23 +0000 (UTC)
X-FDA: 84182190246.29.237E590
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id 044FB8001B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:36:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Qu5F04TJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of elver@google.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764862581; a=rsa-sha256;
	cv=none;
	b=v7OmFfLoP8bkrlWTU7i6/i1gAViLB+YmxUw5D+m+Di884QEgRs0LjfLhPLX0hYUDnniKfs
	0Zx1FJfroDPdpXtVvyx+iR/CEZ0+8yLZx87JJZ9cdDlP4hhwgv5zgKkiEojrOk0YoEiy07
	qA45IjtOH4xzJACrcXzSXQOvnFyk79o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Qu5F04TJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of elver@google.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764862581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LWBFD2aC28ujRjWCANBBdmEOHCG4fNF+CSlRr6FISyA=;
	b=l0CKFGIJNb+dst5RUZ4of+TrbtJOVLyAexGBS4clAUPwSV0h/Oaik4enG4b7z+f64XV//S
	cGbuqY41cUym/1N6wnUQ4FQ0Mw1SvSfUFqfiZ0BeLNdSbiLPMDG4E5DHyzKtVmPKdKk1FB
	CXgP0doA/YnU9dZoMGQQKElhla6u7Fg=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7aace33b75bso993588b3a.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 07:36:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764862580; x=1765467380; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LWBFD2aC28ujRjWCANBBdmEOHCG4fNF+CSlRr6FISyA=;
        b=Qu5F04TJfsqkS3r3EEEFr+ub9A8Hq6MhGpUF5vwozUk8o+1A/jwJP5zRd0a3XaB+aS
         RjjYIXlWT11wkxi16WOxCwnf8leXNlVruvT7+dD8cIjedYhlvCRGgsFqPZw9GhiPHcvy
         QnLeFRv7VEqVSJgJfJkTNtpAhrv/fLYdw8nzfzZ2VADZ8/LQMpIi3Ql5cizynhl2oAxx
         cK56/AkbuHEyxSKjVpOrbpOMM2c3k5kCO3lWLIsAntxUIs1Em8ZKsIBOVMsU2qPgoS2F
         2uIMyEup6r2b65tLMgpcWoNg7O1anhM7iqzgoa6eLtBvqQkp7jwKRy4TU7czVCvU+K1b
         gG8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764862580; x=1765467380;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LWBFD2aC28ujRjWCANBBdmEOHCG4fNF+CSlRr6FISyA=;
        b=YhEv3VrWRQDPUs7uOCekC5KIDKq9733ET0wBGoxLV4SZV+vEtgK3Wu6cHhqSA7VY+8
         0RQONt15B0IJgU0Hk3uicU0qz6klePMhm1YbqRYzvTrM7IBNFXQ9OuRnWVIOmiAbonL2
         M/OLJH1CBN6XVNrRb9kamVDQeGnPbhKwKv/6ZSuBrUYdgfFuTIRKJXbSVHL4D+h6eG7X
         DtMA4EK13/GIWIzTU0bDSASXpT0hzef5PeyAg//fgNWgjXDne0nv73PDOqwWBnifO9AK
         OMF0nc+JNK0HaZUVXgZlCgAHf+mYXiwXdoVKbtK5orhyRZLjD3WOVy0ZvdWVPsjte4oB
         rF2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUNaTK+x8IqvzKND8utJ4AEq6bPp7bKHvG5KLNWtJuzifvpjhp2JNyE7NSEz9wKEEBQX5Dr5ErybA==@kvack.org
X-Gm-Message-State: AOJu0YwKoqj6z2HvMC2u5qB33mSGAP3TPmCQGNOmNqhzsNEgYMcPBSa8
	Y+VWoEiV8hw7nOqtj8D18wmgq5AroM0OzaOFieUJGnnmlZX+BnRzTOZhEDAVnUod4/gL8jEm0sr
	UCS6dsZURlERoCThnfef6OmOrQGt3X4kYeqJqcFnL
X-Gm-Gg: ASbGnctxHk8O27gJuVHoUsXIC1Xu30VtB6KzxxlevlfM1vUXqte7UAfzkwMXFmA/dpg
	nHKqAByk+oba1yLpS4Vo4yrskgUvL/1YlKQR+kr3gh9rcA8hNVUavFKwSb9TkgfYEmK8xLSib3Z
	uLZ/bo5hus5Z7hBctqpRMRFCSB+2yEslWttTRe21WvSJsoXJsNlNTsUFc1XUAF2lU1pEsU5uf17
	MTHwvAmxkZaqWZg1xLwaQnZMoWub8k4B9QNrMFyJjvTzHAko8JgV5Ad4o51iTEnUtfxnuyU87oR
	W7I9TDyT5ZW7XiMy+iKXibXsag==
X-Google-Smtp-Source: AGHT+IGBl6pFyllPB28xMA+DusowF0FZL/6bu20YQM6WiubZmRKCdd7ntPDUD3kgpQhMnE6Fh5MlZMr8FMe2M5WQkqg=
X-Received: by 2002:a05:7022:2584:b0:119:fac9:ce12 with SMTP id
 a92af1059eb24-11df0bf6409mr5437809c88.13.1764862579414; Thu, 04 Dec 2025
 07:36:19 -0800 (PST)
MIME-Version: 1.0
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
 <20251204141250.21114-10-ethan.w.s.graham@gmail.com> <CAHp75VfSkDvWVqi+W2iLJZhfe9+ZqSvTEN7Lh-JQbyKjPO6p_A@mail.gmail.com>
 <CANpmjNMQDs8egBfCMH_Nx7gdfxP+N40Lf6eD=-25afeTcbRS+Q@mail.gmail.com> <CAHp75VfsD5Yj1_JcXS5gxnN3XpLjuA7nKTZMmMHB_q-qD2E8SA@mail.gmail.com>
In-Reply-To: <CAHp75VfsD5Yj1_JcXS5gxnN3XpLjuA7nKTZMmMHB_q-qD2E8SA@mail.gmail.com>
From: Marco Elver <elver@google.com>
Date: Thu, 4 Dec 2025 16:35:41 +0100
X-Gm-Features: AWmQ_blR-jXZjBSUNwkZ-Kj8R77y7Gb2w-LzAguJomE44k13qlmxusnxd-LQq3I
Message-ID: <CANpmjNOKBw9qN4zwLzCsOkZUBegzU0eRTBmbt1z3WFvXOP+6ew@mail.gmail.com>
Subject: Re: [PATCH 09/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Ethan Graham <ethan.w.s.graham@gmail.com>, glider@google.com, andreyknvl@gmail.com, 
	andy@kernel.org, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, shuah@kernel.org, sj@kernel.org, 
	tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 044FB8001B
X-Stat-Signature: bzrgokrzkbzkdso3xawke5p9kfs7mk33
X-Rspam-User: 
X-HE-Tag: 1764862580-452948
X-HE-Meta: U2FsdGVkX1+6qwkg5qWFQ85oq/rRvO3NPNaXGbHEp/d7IOLE/TITvLRVQuNyJYiEtmhvb1TEU72+g3o1TwyyN4ittmm+cvgsWVk3NSQC35ezGYq9EMwKbIcCS7DnR9ytrH2gqQ44fD9NcGIax3BTpd4mCec/lDnebR7/0entSm9DIBcpbvs7IE3TFuVo63TJJCzFxO4WodSjdJEuKiH/oGqfQ7DzQ/yWWWkKzn9sOlVmeR5R6+ocQH1Fmv8Cd9aqww+nrv0BsqXvxTBtOl68aGJWPTtZc3Ls7LzIOQa8bu3zjoCkFtlyri6XxjRxMm+VrB3wFO6kycysLiaRynwlHxTKZF0D5EQIBPb5dUI/mrlJcrRqPIGqlRriUFZsLkEXAx4WVk6uR6XpYrOo3Ko6XUluSKD3lqI4vvUmFcKpb6lGhbr9mObpGwp7B0JVEX09jXgMEYaqjj1XNykapw+T4TeDSEemEecK6PVBDp05Eu96eM0p/dkqKBtvCRt06GVovNTKd/naorWL5rLez0Sbn6sWSZBgUIieLOjO97Ei+X8XGGoziBLOI8t5+ZQudbPVwOCueQKv/PuCZDA0AsCp9VPPIXxKNOJPfWRoCYUYxHCT8To0LwQ0EvmY2CjX8Z6VvEV6zEwY+qkWRTUs/Xp6kiKDRJujQwHl6IAjVIx4U98Auc6sHHpMhgpWxwyvuxn0CdA11ZdOrfqJG98xrrB2M+N9eOcDYrU3jKCVI31cVIOQqFwxWeWmC0avda4v5b3gfu+hZfq11azi2LIHhDeF3d7Y4UFfE4BNMpopEGYlSmrKieUerypr7gneqyoCqz9AzU4Rj5JaG2bI08mkAxyo39CV47BUNcsKEKRw7JWyDI9ugTs+zyYwby+0uYkKU/QBUgSwe0p3Yv4fp2Mvq4e/TvfbeJURuwzlnyYIpqrXuC5HMKTsiNpjturfGrQ/dA3MpBYJTLHUH8P5lZuyqRj
 IDOBTksv
 wjnliqdTd2PAFjgU2HpV7eCAsKLjdxQXr8Rz2xcb0KnEFMlXMbDIhteegHkI1sVSrzNB3n8t1Yq8mRgZeLQeqDfc2MB/rrIzs3ybVnLblE8SI9MvCYV4ysMIB5zCuXv7vmeAZ6Y2MxpAZlP9FCgZTU9/XRDrpLeSu5zScWqUp048QTgtEacJKrMVGR3vlNyKTLw0DvmBNZU/3nB1YpNpKFq70WGtrWJvnFdlCf8rfbRb0G8eMD5aBSnglsdJM+7DUo4pgrHDUdWyjPfAzLuXGwULM3WUkYfCgx9oDpcj+4eUErnggdN+h34HhWkHYG0zaOHrxQzPRGhHh9LrUaGEnVYHwtEFTL/A8lK5pruYuJz++CbVqMy7N+sjHp9Jsgo66XCBElButKiovd6IWe9F6ZFSISw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Dec 2025 at 16:34, Andy Shevchenko <andy.shevchenko@gmail.com> wr=
ote:
>
> On Thu, Dec 4, 2025 at 5:33=E2=80=AFPM Marco Elver <elver@google.com> wro=
te:
> > On Thu, 4 Dec 2025 at 16:26, Andy Shevchenko <andy.shevchenko@gmail.com=
> wrote:
>
> [..]
>
> > > > Signed-off-by: Ethan Graham <ethangraham@google.com>
> > > > Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
> > >
> > > I believe one of two SoBs is enough.
> >
> > Per my interpretation of
> > https://docs.kernel.org/process/submitting-patches.html#developer-s-cer=
tificate-of-origin-1-1
> > it's required where the affiliation/identity of the author has
> > changed; it's as if another developer picked up the series and
> > continues improving it.
>
> Since the original address does not exist, the Originally-by: or free
> text in the commit message / cover letter should be enough.

The original copyright still applies, and the SOB captures that.


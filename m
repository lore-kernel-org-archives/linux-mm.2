Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B468D216A5
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 15:43:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA07B6B008C; Thu,  4 Dec 2025 10:43:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77A16B00B8; Thu,  4 Dec 2025 10:43:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB49A6B00B9; Thu,  4 Dec 2025 10:43:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E5146B008C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:43:17 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 48BD9160263
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:43:17 +0000 (UTC)
X-FDA: 84182207634.30.5C6DE4A
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6853440012
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:43:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KLNPxY18;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of elver@google.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764862995; a=rsa-sha256;
	cv=none;
	b=Dh1UaTJnJTa68NyKXP6ZQK+gQL429U8+up5joihQlZIgm5mAOqPAfuxhCLdtOKWZjq18WD
	Gp+BapBgn3u9eMoWbevzL0qu+k09QezIdrf34wn0wpcsNrYJB3dBXM0JVwBCUr/YiDR/p9
	pIZ0b4+v45fLygjoUIjP9K0YjipdUkY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KLNPxY18;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of elver@google.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764862995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wMOP4GkDr5ijMp2y62W7yYKXyYdN/GF/oZk8QJQ4apc=;
	b=ycqNGcEDocpU5H5n5vJawXfYjV6HcdN7/R/KtdnHmpzOZEbvzmqsg5MxwRlQIR4NocC+Fk
	NbKkhn+E8wulD8mBmPG9SJbk3fHQpf5vcg17JqPeq5ZjKs2WBE6TV+txraZ2R9bdn89sqx
	/zPQPiYWz16S1kgKkaU3nPi35bMNIww=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7b9215e55e6so791576b3a.2
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 07:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764862994; x=1765467794; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wMOP4GkDr5ijMp2y62W7yYKXyYdN/GF/oZk8QJQ4apc=;
        b=KLNPxY1871REqUdIT5psVyEwMKKiHINyS4tjEBKmjrwGSnRv9XEs6apO8FBUUd1O2t
         EuNrWbdakn9ObJkjmpz+R7ClNmuLJ7RL1u7WB+eyPSix0DcEeiS+KSq/iQV+K7BLLU+t
         mqKEGn12TphkCEu0aHe221tqej2tK7avu/lMccjg8eViDOEn6QnKy2Ntlc6thtVMSev9
         UjJ5KAAQU+U3FbiWDfqsbJD7OMzD3iYMIS+3VsG3CJkVm6eN8+O0bxn4Ea00LIyyFaMA
         hzYokjgEG1TpRWXs61niGM07OIeWdZ8K/MUf8r9Rt3thVwB/n4i1j2B7VXM3kCfB5luW
         mYiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764862994; x=1765467794;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wMOP4GkDr5ijMp2y62W7yYKXyYdN/GF/oZk8QJQ4apc=;
        b=ZW1pTYa9cJjClh7Gbn+2tgxxxvgbZAHRpfFemN1jYqkov18qCmh4NZ08Z4fI6dcC2m
         LvzM0b7ig/Ds5UqGn+O4GPEfHC/pWOoD+VK00SFG784Fe3FqxhtY95mSEfFICOsR02lb
         kjrd+4UYVS08IzGO+XLEDPffSmhiJ4UWoILa3ELfqARrGO6VMWS/GxTfh6NK0PGYi4p9
         IMktmxyCl3YCXcRgRg4ihyEu3ZMMhC7vby2a8nYiRGMZirLBXd4rTa8PSh/1AzpTYdlB
         4mkwFk2pvGUps1MqY+Ka76puXonk5L1chK/59kl9V7xIB2YDPhCQOVfnGKEtdL+DNOb6
         ru8g==
X-Forwarded-Encrypted: i=1; AJvYcCWQSCd16UUQUusSsIvN2cupB3pfTEFyAYSvylT4J7pqtWr5k2fNcmFKCTtN633gBRMhjcsYdGEiWA==@kvack.org
X-Gm-Message-State: AOJu0YzCWVtocMsSZZwGpAn/s03gSIn+on98urb1EWu9Wv0ss9hRQz+c
	3EIE4ry069DSxb1GCowHpIIkKPo9ll2+ZcWCsWiZi9Y6+MB/xvpRztzrKAP+FfOn3rXDdbftI6U
	bj918hl1pWMqfpaIkFjofgs4QrD1BJAmDp2IINeg3
X-Gm-Gg: ASbGncuQES6Tbxq+SGS3NDb2s1imy2dCDeBcyqegX11ymz2yNBCKNWwFn1w6kPHlnc4
	KWcw/i9DeHFWAytX8AMWWarc8IMfAzXmDJdXa2fU4Gc40TZF9YQC+jQgwu7+Ejb+llDN3900bjc
	ZupEKJFGaZ21gUdOk9HEx6wdxpX+KavTluxahkabeWem0W3m/JenxZJ1+hgu7irwXIAVC+vinrD
	cttAqM18jf01iMwZj14EiQTuUQl+oOCjP9T1CmTuw9PR8tTqK9+npXi2nntmNpxPsf27iP1QLzA
	aC46RWc4qcU7HlTLXuWOjOzbtA==
X-Google-Smtp-Source: AGHT+IHs2lXL9r27Oj25OTPLwrUpq+WjBSPrEBWJDAz2naZgENCLRnceIe8m1HwqG+PReSfilUhD4oQEt0040SIknFU=
X-Received: by 2002:a05:7022:f511:b0:119:e56b:98a5 with SMTP id
 a92af1059eb24-11df6463cf7mr1323360c88.12.1764862993857; Thu, 04 Dec 2025
 07:43:13 -0800 (PST)
MIME-Version: 1.0
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
 <20251204141250.21114-10-ethan.w.s.graham@gmail.com> <CAHp75VfSkDvWVqi+W2iLJZhfe9+ZqSvTEN7Lh-JQbyKjPO6p_A@mail.gmail.com>
 <CANpmjNMQDs8egBfCMH_Nx7gdfxP+N40Lf6eD=-25afeTcbRS+Q@mail.gmail.com>
 <CAHp75VfsD5Yj1_JcXS5gxnN3XpLjuA7nKTZMmMHB_q-qD2E8SA@mail.gmail.com> <CANpmjNOKBw9qN4zwLzCsOkZUBegzU0eRTBmbt1z3WFvXOP+6ew@mail.gmail.com>
In-Reply-To: <CANpmjNOKBw9qN4zwLzCsOkZUBegzU0eRTBmbt1z3WFvXOP+6ew@mail.gmail.com>
From: Marco Elver <elver@google.com>
Date: Thu, 4 Dec 2025 16:42:37 +0100
X-Gm-Features: AWmQ_bnyN22mbvWc2oz66fpJ7IbcLfdYObxM0FDhKEtXf6ssNmrNTIWoxgBISDw
Message-ID: <CANpmjNNqCe5TxPriN-=OnS0nqGEYd-ChcZe6HQxwG4LZMuOwdA@mail.gmail.com>
Subject: Re: [PATCH 09/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
To: Andy Shevchenko <andy.shevchenko@gmail.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6853440012
X-Stat-Signature: jc7nar1iauk7ubx8iz8za5en3wkey9n5
X-Rspam-User: 
X-HE-Tag: 1764862995-194771
X-HE-Meta: U2FsdGVkX18MB9luVn0cWicn/3uAiSEQvIC3oh8HyBqx1MD18W4fyv78H/yt8DmSBWH5130cn5uekMmDMIjKmp/VG5HxBWZo/PGY98Iz6OF39eQb4W1Iv6/4R+BsjABGNzdUQm+pflvYNa5iPh3E21+5RUpEPuHxmFCg+HOJmz2LLLGMQvjU6mcHnzj3yNLBvB8K3Py+pgALRcJjojSLx/CoEJTfhgEmcb1Bey6usMNKIGh+ELiCTDYMXIGoICVBFnCwPXPh5X2GQGhmDpTj7OfaTDi23izMKUnebS1GVKyaK148N/5n//+C0osfo8LqKVgvHH/Mk622Q2afvy1Vf2PlR6j5knkPLYqHazvfbURCx9TlRS8cR1mbrGzQsjAOaDghdVnGZExxPn2Vg1my6hv4eDNvnpz1UKVcUBSuyJPE2nl3UxUwaA6ptuwN5C46OZl3Wg6JwKPyRAK+K3h1NdlgJG4HHU0ZHcMJC18+QHkRo9rpDMnArmBQJ+8ugVgoMVVoL8quXhQjXQgrTMYflL8QI2VOEygWvAzm6nTryuGKcqgwBRab7t/onjTBNCFZ0z9e0m7NVaPQaz6gTLR50aVPmvY7lKqOSZ3swz8szSbEkyqkhsrSJSYxmEJlvPL3T8JO196PUN3fQdq2xYXzH7W0l09SBX2OlcdXXmiv04KGBPDgfm0q9vLhCs/oEFBWNhhqJDDMqgSoFG9FuEP/B2Fgr1eBOs8FcvtdsE01IkyIy3hp6M0W9EFeG8G5R5OwX+HqZM7aIjIFzrhoEaZ5m/26VzSSFgefwqpu9IGJ24RsWMLDVDt+OH8F78tKhJnQQZMAlCtzZA6AAowluKD0XKVB3lUi7oL9qe61aP5z6tOp34byzhtjYnxrWCtVuskNcNph5yPSHsmUn2/QbQYmlab/+gT9ztF1ykvY36DRv/pd91SnDSuGWZkCjlRK2M//f1c6+E5Ou1gu+T6X52w
 sazSV6kq
 5ZLz4wy0A5dRLN7RkUnAARg91fat6JHSZ9r4UqN4y92s/ZGl7PyjbtStkSduhYsuwTCply4ZrOlvQjHesW6Wr8R8shyNz+HR3yJdFESt38R4Usk7AzvKLtTipg0oyhJCv9pUhfUzGfYQ/dtwvjIyHqfY5CxyQ7bIAcyezHKi1QftdRq3sPDMpHgvIB6ZXWR82bgs/zx3TLx//25q+88FExrGgE1eMDWvzWSCR1XBKXuYZxVIUMH/RFWzLTD/hxK0r8NamO4t6f747F0x8g5JAufnhhOcDa8Jcfp4n94T5EvEpOuUokw4CnviMdMENlwjCk2Vvc+AFdyBaPtocc8ofYWi34DKsAGgpBIdRPQBFIQyv3Wg314NHjea29ReqJOMrLiEAz8rRSqFbzLW8ljal/5yU+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Dec 2025 at 16:35, Marco Elver <elver@google.com> wrote:
> On Thu, 4 Dec 2025 at 16:34, Andy Shevchenko <andy.shevchenko@gmail.com> =
wrote:
> >
> > On Thu, Dec 4, 2025 at 5:33=E2=80=AFPM Marco Elver <elver@google.com> w=
rote:
> > > On Thu, 4 Dec 2025 at 16:26, Andy Shevchenko <andy.shevchenko@gmail.c=
om> wrote:
> >
> > [..]
> >
> > > > > Signed-off-by: Ethan Graham <ethangraham@google.com>
> > > > > Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
> > > >
> > > > I believe one of two SoBs is enough.
> > >
> > > Per my interpretation of
> > > https://docs.kernel.org/process/submitting-patches.html#developer-s-c=
ertificate-of-origin-1-1
> > > it's required where the affiliation/identity of the author has
> > > changed; it's as if another developer picked up the series and
> > > continues improving it.
> >
> > Since the original address does not exist, the Originally-by: or free
> > text in the commit message / cover letter should be enough.
>
> The original copyright still applies, and the SOB captures that.

+Cc Greg - who might be able to shed a light on tricky cases like this.

tldr; Ethan left Google, but continues to develop series in personal
capacity. Question about double-SOB requirement above.

Thanks,
-- Marco


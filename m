Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 559B2CA0EED
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 10:08:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECC7E8E002A; Tue, 19 Aug 2025 06:08:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7D0D8E0002; Tue, 19 Aug 2025 06:08:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6BDE8E002A; Tue, 19 Aug 2025 06:08:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BBDE58E0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:08:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 65F94138F99
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:08:47 +0000 (UTC)
X-FDA: 83793083094.10.372F980
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id A57DE180007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:08:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jh3bl9xJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of elver@google.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755598125; a=rsa-sha256;
	cv=none;
	b=kS3jcvNGJB9jOV8nUkSTetqpLKfa0ihIWYpxNFQJUDQDohn2qOedaoX9/kufvvUzdEAVgd
	waKJaYiricbE6D0dj0TPVwe1QRZvX7Kdywu5fBbbw2WtgWpY3nKGJk5lsp0lDb2Efpjzes
	w/Q8oaR17LcDC4ZzA7ru9yG6OX3RR2A=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jh3bl9xJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of elver@google.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755598125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xtwFnGhPjZbaJZhKpnnfvoiBniYG8b/g2aN0jXq3ohM=;
	b=1vuvwNXQGt/n6EOanjCl/D+qtFK2PK55r4ZYF3Z+HqKfssaxMjygLGAzlXOfyOUTgDuk6j
	GBF49BBh30PeRTtQEDF+DA3wVDR+3OW56vb+cSF1AXBsLMQsobzr1F32BMVdAeg1D9B6iX
	4OGX/ul9PXOJAHahHER9taGWdavLp8g=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b472fd93ad1so2412263a12.0
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755598124; x=1756202924; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xtwFnGhPjZbaJZhKpnnfvoiBniYG8b/g2aN0jXq3ohM=;
        b=jh3bl9xJS52os58u9M/sDGnOF2tI3R1B1wDvol2GQABzmIsnzLlAnrEqXA18oN0YZz
         mJLzGXBJtXbCZalMzkWKC0ITEQnFQPLxmREIoQxZiSaq1P2JPMrHGybikaK1/0FxEGQM
         6BkunuY3wTE9PJ0Nm0AIx0bveFCoK0WeWe6Bmt0kVN+ZI6oGv6dmw+gCEd1+kMMECwGJ
         MX+gUuGC3upJ5n+tM/fCyr+gLX68U2d7TOl2VgPd0BNSKJIOet6dmwt3i32gooYx9NXn
         rNHoYCPyLhW3NFU2WijPB+p/87vBQMhmXf+TJgQ88bmx/Ps323xSsafNB2Fk6mUTrg+n
         Y1cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755598124; x=1756202924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xtwFnGhPjZbaJZhKpnnfvoiBniYG8b/g2aN0jXq3ohM=;
        b=nS77kq7wb3nxrq6qCX/d3SQawXrO7QJgpoo/j1PbDVjMly0h5OBSOH4QVa13tHeRS3
         yRW9G3Gbo0v3xIPTvhixLi7C9cUXACqzIwigRwp108shN01Duzr9eWcxCZ92Zzn4A5OI
         eeRDymJGN4ovrnEXw9lQ/eJgO/XhgPsNOY3kOWpRN+6QuVKbdFZVSR6C6ugyi4oFJjku
         g3MZDWOYyKS99/X50jDS1DAWI+64XokE+XJfnKZWgT2QWiHKFcVcNAijCj7LPv2WBMxb
         pLdAsXl1oscwuVik+XAcaK8hd4u2UWvLbc6jxwu5KwQ5UpPAoF73/LMdMZenb8AL9c5a
         t76g==
X-Forwarded-Encrypted: i=1; AJvYcCUw7UlS+8jATfGSGGizQKhzuOZmtwndnTCELfGu/7UJo3FMN+ZDHDV26dE7WQrQRD6v8j4VlsOBPw==@kvack.org
X-Gm-Message-State: AOJu0Yz+27kuo++qPZnrZiHV3jnV5fq07yiuMhecUMVuZLZv4Mb1sDw/
	CvPiLQ7Z4krpEy0VwyXLWIUiGPP5ONxJHCuWtoh+cPyU499s7Po6WgWZm99OvRxULdGiiUcGQ0O
	I/1EC4SPTlvMaX9axtAf8UlUyhaT2iv76GInBkLuk
X-Gm-Gg: ASbGncuASf1joeZl2X+MNO8FbhOB6wV5kv/zBPFG0GTebxCDZphhd6FibwtNwebb+Bi
	oNTWf4e4SRyZ6MvkXVCM90M34dUA0mVvtLaYO73bHHx4nFWeaMOY1a3+Zven1HjntwwJNWIyzgv
	+loaxfbHl5SwTEcWA85RD9pJrW8VsRL6vBPyZj9JIlRVgoeL+1hoJESs8Jmc9VmizHUfXcZtOuy
	wkqeoqoZM9LS+DFBxB8uVyVO2QOWg42xhJibbbdceIdCBuJASioNfEj
X-Google-Smtp-Source: AGHT+IFfS3hoyBOLwpuKJXoUxE2vzo2ehfwwl1HfDsRL4hlNcLRt9FGWFqIWmbr8FvaOXyY0AViqmicQfnfpexeRIec=
X-Received: by 2002:a17:902:da92:b0:242:eb33:96a0 with SMTP id
 d9443c01a7336-245e0328fc4mr25769245ad.25.1755598124032; Tue, 19 Aug 2025
 03:08:44 -0700 (PDT)
MIME-Version: 1.0
References: <20250813133812.926145-1-ethan.w.s.graham@gmail.com>
 <20250813133812.926145-7-ethan.w.s.graham@gmail.com> <CANpmjNMXnXf879XZc-skhbv17sjppwzr0VGYPrrWokCejfOT1A@mail.gmail.com>
 <CALrw=nFKv9ORN=w26UZB1qEi904DP1V5oqDsQv7mt8QGVhPW1A@mail.gmail.com>
 <20250815011744.GB1302@sol> <CALrw=nHcpDNwOV6ROGsXq8TtaPNGC4kGf_5YDTfVs2U1+wjRhg@mail.gmail.com>
In-Reply-To: <CALrw=nHcpDNwOV6ROGsXq8TtaPNGC4kGf_5YDTfVs2U1+wjRhg@mail.gmail.com>
From: Marco Elver <elver@google.com>
Date: Tue, 19 Aug 2025 12:08:07 +0200
X-Gm-Features: Ac12FXytHPioqIN3_h6-8LrUsWB3kDPFRbJegFs6XnxZaSOjKS1ectEm86g1kAE
Message-ID: <CANpmjNOdq9iwuS9u6NhCrZ+AsM+_pAfZXZsTmpXMPacjRjV80g@mail.gmail.com>
Subject: Re: [PATCH v1 RFC 6/6] crypto: implement KFuzzTest targets for PKCS7
 and RSA parsing
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Ethan Graham <ethan.w.s.graham@gmail.com>, 
	ethangraham@google.com, glider@google.com, andreyknvl@gmail.com, 
	brendan.higgins@linux.dev, davidgow@google.com, dvyukov@google.com, 
	jannh@google.com, rmoar@google.com, shuah@kernel.org, tarasmadan@google.com, 
	kasan-dev@googlegroups.com, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	"open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A57DE180007
X-Stat-Signature: gph3a31zgtnhbt6hpeqgbs7cdfifjnkp
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755598125-640084
X-HE-Meta: U2FsdGVkX1/1vEtdvwOfhHdVD4a1RC9rhibkwZUq1nNvNBWvFnOa5mk47LOKtqsSEMRM1VspIqLZLI8mpMfru5ErfyR6OoBWYfZmwOSZ3Uk8ERpcGkYesh5IPuA0LCb75KHYmEdSnSM279DE4OHTdDDbhPUyWTNhHjnXzfEJ01VodFk5QKfw0zdxTxVhULscEjbRlfqzM2PiNkJHq9NfOlnKWJzgsaRTdb/kv1oE9AVI0kqTOOCtMFfP9VdD/ou/w/iLfzWfwIzTlBOX/+XXRBX37HM7rhTayY1kLhyD4GjvqSRiD7JB/Wp8ZkSTEI6PxdfiCwBA8LeyDlVDQp0RN3cYCGF92eSljPaqh0IiA92mF5x2VLwSMCI5yx56WcG5zg3fyf3Xf06aauGCAetb81uEZfyyouiZRWC4FzvMqgOmmnVJcyfHwDn1Sy6dxsKY++cAXm2aZsoSTkVV2uZJvQTkYt5gCo24VX3YGX46wD9GHoHkXGH4lmPTlnulvgE2ScZZM+jXRI0X1O9LsHM1zXdGPqlC8wz+G9lK97wVzWvGXI7b7iZ2k3HBM0vXMJkxpE6FK8MAU8gbN3heqXms4wLexCS35XZ6+j9dsLOtKU1qAwrOJ5toW/DDErTA4rP9vpMXpK+A+6xYNM2plMbNzBnHrB3tVmoWD91Hnz1OQzFpT4PcmIWzyyfo88nIbqCyaM9/pj6RdT+PPzlTQQDJxYk3KqKOOJblwrsLgOlcLY3izOWTu16bI2gerrRVnlgoms2w8/CaYTLyq015BctjMFT5xl37WLRjz06vuVG5dfBmra5lmxsRUH73hdXV5i0pfMSwRWMdYwgzKg/lG7OUikG4M3FJlzz8Uln21kIAUyGEVtqoqX/rnxnVA314qWLp60eYoKevufAnl15OAZu9RAwlRJNejIhapt8iYK7P5r50/+zXpFmxCqGRy6JUXvnwHnKozO2qXRnJnIR1bK7
 2Ahgy9k3
 0B0sfEetyloAqhvk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 Aug 2025 at 15:00, Ignat Korchagin <ignat@cloudflare.com> wrote:
>
> On Fri, Aug 15, 2025 at 2:18=E2=80=AFAM Eric Biggers <ebiggers@kernel.org=
> wrote:
> >
> > On Thu, Aug 14, 2025 at 04:28:13PM +0100, Ignat Korchagin wrote:
> > > Not sure if it has been mentioned elsewhere, but one thing I already
> > > don't like about it is that these definitions "pollute" the actual
> > > source files. Might not be such a big deal here, but kernel source
> > > files for core subsystems tend to become quite large and complex
> > > already, so not a great idea to make them even larger and harder to
> > > follow with fuzz definitions.
> > >
> > > As far as I'm aware, for the same reason KUnit [1] is not that popula=
r
> > > (or at least less popular than other approaches, like selftests [2]).
> > > Is it possible to make it that these definitions live in separate
> > > files or even closer to selftests?
> >
> > That's not the impression I get.  KUnit suites are normally defined in
> > separate files, and KUnit seems to be increasing in popularity.
>
> Great! Either I was wrong from the start or it changed and I haven't
> looked there recently.
>
> > KFuzzTest can use separate files too, it looks like?
> >
> > Would it make any sense for fuzz tests to be a special type of KUnit
> > test, instead of a separate framework?
>
> I think so, if possible. There is always some hurdles adopting new
> framework, but if it would be a new feature of an existing one (either
> KUnit or selftests - whatever fits better semantically), the existing
> users of that framework are more likely to pick it up.

The dependency would be in name only (i.e. "branding"). Right now it's
possible to use KFuzzTest without the KUnit dependency. So there is
technical merit to decouple.

Would sufficient documentation, and perhaps suggesting separate files
to be the canonical way of defining KFuzzTests, improve the situation?

For example something like:
For subsystem foo.c, define a KFuzzTest in foo_kfuzz.c, and then in
the Makfile add "obj-$(CONFIG_KFUZZTEST) +=3D foo_kfuzz.o".
Alternatively, to test internal static functions, place the KFuzzTest
harness in a file foo_kfuzz.h, and include at the bottom of foo.c.

Alex, Ethan, and KUnit folks: What's your preference?


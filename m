Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29879CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 11:41:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0ADE6B00FD; Tue, 19 Aug 2025 07:41:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE2986B00FF; Tue, 19 Aug 2025 07:41:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F85D6B0100; Tue, 19 Aug 2025 07:41:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8FB046B00FD
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:41:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 288F1160699
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:41:16 +0000 (UTC)
X-FDA: 83793316152.25.A5C0BE6
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	by imf01.hostedemail.com (Postfix) with ESMTP id 302364000E
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:41:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=MUqxMNc9;
	spf=pass (imf01.hostedemail.com: domain of ignat@cloudflare.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=ignat@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755603674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tuib0sswv+oZbbdQrooeXCEG/zbTBeXmUDDIjBMwhc4=;
	b=VhqZCS3hvspBEtJRc4FWzV7yYfJcjyq2uUIbWPwWSJD7UbouHIadCXY39tLul6vuI0RYi/
	Zc9qeZhSQ4jQZEJyMgfhNJ3KeD0qA5ZygwfgjUzvpc2xh87Hgrsh3ZvPKMk8qdpA35A3XS
	bE+bH0vMFNi+YEx85t9z/5gh5Ixt08k=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=MUqxMNc9;
	spf=pass (imf01.hostedemail.com: domain of ignat@cloudflare.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=ignat@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755603674; a=rsa-sha256;
	cv=none;
	b=DJHH6rll4QaqtLH4GcNHCxhhhBQEjy+9EN5Apa8LyOXkpMix5xCPG+r8O1bJOszBauheIY
	H9Vfatp82tAXYh8y4LJ21gEqqEu6hKKuZ+aUcDuBlHEWe6TcKlVgT8x6MTOL6d0Fp9D+EA
	oogEbi6EByVHahQK5Lu2HsTjN0c5o7k=
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-333f8d3be05so35797201fa.0
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1755603672; x=1756208472; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tuib0sswv+oZbbdQrooeXCEG/zbTBeXmUDDIjBMwhc4=;
        b=MUqxMNc9YWjddu8POyylO7nhObRGgnlgk5IkYjJV+muG7hfm1yehYNQ0WfWL151m1c
         0VFnygqpaISCnbsMz54EavWe/aFTDpFEKqSY4s6tbkHabqsbFKw03f3NwvoGM7173mWv
         0RPrUE6mIXb4uMOOhmDV8sewUGZMRP7rvj8MmIG7RuZbr7lkpscBv4W9cMoPdsKtPaw+
         HAvKczLeCkcUrr/T8/CQXlqy2+u2x0M0UkL6TAIZXxcQFKC+NEwIkY14svQyL2KnR8qi
         i3QE8V3RLaw1f5MY8HrF1XFQTMtJmJYdqOSs4lOAqzfewOLDy4oHpSlaR15Ca4BybYXt
         9vjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755603672; x=1756208472;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tuib0sswv+oZbbdQrooeXCEG/zbTBeXmUDDIjBMwhc4=;
        b=c8x+l75iOLbSWekVIynjgS7wQHyJqyf9OB2YM7fUKtoT4TQQsj17YcLwXsHvngtpCN
         j0p7Eq1WTWtaMuwlxD5IWIumCMp2swGnZtWGEM9dyFgHHMFOUGW14M6LQf+KYAepY4GZ
         DrbDNx4KTRb3HTB3qfGz1APhcdYCemMzQeitK0jOJKWm0CdhCd/Fd9/booJ5F8Fideeu
         AGxA5vCpDs6KYspepUaIrsEpFggnNW4s/UEI2fs3Su1nRbdhUT3+ReRN27gb+HQh5VLp
         bH2Ghh70Tf1QMtriQ9Y+xMRwnQQQ2nx/0KC8ZgLh22kuVHlc6l4/MOc0VxBF4TNRXFOm
         mLLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrSSqwL2DNE5dcZZ4H22AF/rKj7Q5ZBg3DF1cisTeIldMeYqtXyvvc55nB4y4l5KqHHupcCVfMIA==@kvack.org
X-Gm-Message-State: AOJu0Yz/Y+nsgvU0PciGh71i2QPc2tSqq22ffnXWdE+IgLo/Kv/KIQmB
	/+8B4bieNzHsYOwY+Q9+mCy+AbBPwk2HiZDhBMXLGGtnlKEDTnYSvJydF2gmM+JnooTFRARR9Xv
	1rEaD+dYQBkzHSvqnOxQAG+tDCAXXA57S8VHsSNH24Q==
X-Gm-Gg: ASbGnct8/2nDT09bSwvpXDDu04lRtoYURSmSOMG62brPu0wUjL2DGSGObal4S+lY9AO
	ly4DgEAw9bLTGwCTF/Ol8cmWPuAjNNZWM0QBGyN4+6bAr8q+M99K+BebRs7Wo5jdHBDwEidCT75
	PVFNJok9/G5ov6gclnczmqGdQle9TkoErAaUr6l2kNiEqqTojsWPa3Ioship4TRzSpKOyI/7FEQ
	NzPjMnV3S22inKv2DHM5Gxnag==
X-Google-Smtp-Source: AGHT+IGg10HeIEFBkgRlEcrjp/4T0XRDRw8xEDhjciR9L/zoe5JsrLo73GKK91+2b6uQCDMymTwKOwp13xMAHOXQleo=
X-Received: by 2002:a2e:a98f:0:b0:333:9b93:357f with SMTP id
 38308e7fff4ca-3353078bda5mr5810661fa.38.1755603672094; Tue, 19 Aug 2025
 04:41:12 -0700 (PDT)
MIME-Version: 1.0
References: <20250813133812.926145-1-ethan.w.s.graham@gmail.com>
 <20250813133812.926145-7-ethan.w.s.graham@gmail.com> <CANpmjNMXnXf879XZc-skhbv17sjppwzr0VGYPrrWokCejfOT1A@mail.gmail.com>
 <CALrw=nFKv9ORN=w26UZB1qEi904DP1V5oqDsQv7mt8QGVhPW1A@mail.gmail.com>
 <20250815011744.GB1302@sol> <CALrw=nHcpDNwOV6ROGsXq8TtaPNGC4kGf_5YDTfVs2U1+wjRhg@mail.gmail.com>
 <CANpmjNOdq9iwuS9u6NhCrZ+AsM+_pAfZXZsTmpXMPacjRjV80g@mail.gmail.com>
In-Reply-To: <CANpmjNOdq9iwuS9u6NhCrZ+AsM+_pAfZXZsTmpXMPacjRjV80g@mail.gmail.com>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Tue, 19 Aug 2025 12:41:00 +0100
X-Gm-Features: Ac12FXy2y5KT1jl8o7nCrDwuS7gusbjmLZ1TSw-6nmPiK4uS84cdgeiBBwhyLx0
Message-ID: <CALrw=nGo5CfZseNwM88uqoTDwfmuD7BgXaijpCU-7qefx8+BZA@mail.gmail.com>
Subject: Re: [PATCH v1 RFC 6/6] crypto: implement KFuzzTest targets for PKCS7
 and RSA parsing
To: Marco Elver <elver@google.com>
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
X-Stat-Signature: eiqzus7myjkefnwdks713mfox8tc3n81
X-Rspam-User: 
X-Rspamd-Queue-Id: 302364000E
X-Rspamd-Server: rspam05
X-HE-Tag: 1755603673-436597
X-HE-Meta: U2FsdGVkX19vbCrPNiwbND2kNzMrWRS5Rbk4OlwGyOqIaCDvyuPZA6T1j/ueoOmbU06hJ+FDZSR5pKNqURGJ8yjspfOhFiyoI4EXd22y+4/UdUDTBqJ3EJLaMkseJKY/ywb6U562S3O2rOFw0E7OwtFhCCbOlLcI72G4TX/qMASNHUWRaYDdQvl3EPF6UL8HDU5kvNNjQV/Ii+S3V7QHA1RlEr0C3Obi4MSMadJQFALGQR7cb5Nyo+/GajHtigqtr7AWgd8FkgBI81V/2rjq6lnUm8LL5OJ6etD1oaX5VV2oXEUJ4OyoTAVZtjul9UHBKv7qApeHKK/61njxFCjylOVof7pWCcex2N1iQbyKvNgBmlJB9egs/EPJbR9LyoXMVu03KFLlHUpks9ofESIZ9QyvOimUQOxQezZOhgkcnhxOY6Fpapfv2V6uL9sT0m4Os8TWiF9YBhH6ItwaWjiIOY5X5EfHhBYjJqQz+NBERgAScoDxnc30eAS9COdy7ew6YX3I2Mkr3rLUj6dGEavN1ipCuTTyjNlZkJhGJ9aHjsCpW/DUwiBl9iPz7upe2oU4OBQYp/Y6D3pobkmM9Gc2nCEJF59aN6ubkWEz9odfDkWdfCe57aNkIrP7x+Noddwy4LLEVTqTavEfO4fFj0nOwpahwYKNbko3o4hc8FmCQ39nrzlbuVarrwbk2LVZ4g8HPm60S+1IfGrk00NEyMyc18/ggrCpxvhD9FEVRpBJdOjxniF0Mo7j2hAW5OEAquZetY8d4Vu/o8aKBYv5pgv+5NurSkl/iE7+orRZJqBg01rBoeJ2yKJfXsEQ18wfU2w6Zut93S1uCi4PoputW5n1IUi/Tgm0A78FRBmT+K1ejLMJWLPaFrZgPUEImIJBjVb9z+imsxjYFE4YimwxYKrenYMYzZUCFviYTK3RQKZGuG5n3jqZI23eBAhIR5NqOUtekxAI49W+7+DjAsSKd+R
 VeJFH32P
 0S/LntKqssOooH7ORxpEoQJh4e8in13gzK+iL6YEArYDzy/GuYsDhcROmdV2iaXQihGnpb70nD5VbIcVGpci8bNFhtGERRltYbBwo8LWyN0JeNi8rRMKsgwQp1QJOOe5/aYvKFyL03r9EifCuqWt6SCj1bIr7p9QbURWZFvC7wcDs4GI7qa55hIydEzMPVYAKWKjpkgOIv8cAzBbgvPjt5mg2F1jYh9sCcvT2IWVM97xS9tSDPska3nLvOfDi5S+TCkXx25XWKGhW8J15jXljuzoVxVSVcNXp4fJ7z0ZtjxuFo/RzMNwBpovWObXlx8Yio7R69Ca/UTLuagxReb2FEpwO20jHtRluMVgAaNaxBWg0AIE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 11:08=E2=80=AFAM Marco Elver <elver@google.com> wro=
te:
>
> On Fri, 15 Aug 2025 at 15:00, Ignat Korchagin <ignat@cloudflare.com> wrot=
e:
> >
> > On Fri, Aug 15, 2025 at 2:18=E2=80=AFAM Eric Biggers <ebiggers@kernel.o=
rg> wrote:
> > >
> > > On Thu, Aug 14, 2025 at 04:28:13PM +0100, Ignat Korchagin wrote:
> > > > Not sure if it has been mentioned elsewhere, but one thing I alread=
y
> > > > don't like about it is that these definitions "pollute" the actual
> > > > source files. Might not be such a big deal here, but kernel source
> > > > files for core subsystems tend to become quite large and complex
> > > > already, so not a great idea to make them even larger and harder to
> > > > follow with fuzz definitions.
> > > >
> > > > As far as I'm aware, for the same reason KUnit [1] is not that popu=
lar
> > > > (or at least less popular than other approaches, like selftests [2]=
).
> > > > Is it possible to make it that these definitions live in separate
> > > > files or even closer to selftests?
> > >
> > > That's not the impression I get.  KUnit suites are normally defined i=
n
> > > separate files, and KUnit seems to be increasing in popularity.
> >
> > Great! Either I was wrong from the start or it changed and I haven't
> > looked there recently.
> >
> > > KFuzzTest can use separate files too, it looks like?
> > >
> > > Would it make any sense for fuzz tests to be a special type of KUnit
> > > test, instead of a separate framework?
> >
> > I think so, if possible. There is always some hurdles adopting new
> > framework, but if it would be a new feature of an existing one (either
> > KUnit or selftests - whatever fits better semantically), the existing
> > users of that framework are more likely to pick it up.
>
> The dependency would be in name only (i.e. "branding"). Right now it's
> possible to use KFuzzTest without the KUnit dependency. So there is
> technical merit to decouple.

Probably strong (Kbuild) dependency is not what I was thinking about,
rather just semantical similarity. That is, if I "learned" KUnit -
KFuzzTest is easy to pick up for me.

> Would sufficient documentation, and perhaps suggesting separate files
> to be the canonical way of defining KFuzzTests, improve the situation?

Probably.

> For example something like:
> For subsystem foo.c, define a KFuzzTest in foo_kfuzz.c, and then in
> the Makfile add "obj-$(CONFIG_KFUZZTEST) +=3D foo_kfuzz.o".
> Alternatively, to test internal static functions, place the KFuzzTest
> harness in a file foo_kfuzz.h, and include at the bottom of foo.c.

Having includes at the bottom of the file feels weird and "leaks"
kfuzz tests into the sources. Perhaps we can somehow rely on the fact
that kernel is a flat address space and you can always get the address
of a symbol (even if static - similar to how eBPF kprobes do it)? Or
have a bit more complex Kbuild configuration: for example
"foo_kfuzz.c" would include "foo.c" (although including .c files also
feels weird). If CONFIG_KFUZZTEST is disabled, Kbuild just includes
"foo.o", if enabled we include "foo_kfuzz.o" (which includes foo.c as
a source).

Ignat

> Alex, Ethan, and KUnit folks: What's your preference?


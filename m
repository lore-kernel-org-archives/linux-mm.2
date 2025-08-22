Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE09DCA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 08:16:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 085B96B0173; Fri, 22 Aug 2025 04:16:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0363C6B0175; Fri, 22 Aug 2025 04:16:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E67326B0176; Fri, 22 Aug 2025 04:16:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C4FED6B0173
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:16:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8A9751182A5
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:16:07 +0000 (UTC)
X-FDA: 83803685574.01.AE232C6
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf30.hostedemail.com (Postfix) with ESMTP id AD11380005
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:16:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cVXwTvwW;
	spf=pass (imf30.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755850565; a=rsa-sha256;
	cv=none;
	b=r5uGa1q3grCQvYdGws0PPodaSAyDwGBsibQMXOeb+VSX2UXFOehqonHCXZ1HeafiOegkDe
	/M0Pn/dL9VcM2SX4ogbICAWjXJg+nqXApXGSuLLu2Ro7LlrMVxHiRCVduyvtVe4kWFsTL7
	yZbMqjU0yJeiz8YkSUNU+7E0YUCXdtw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cVXwTvwW;
	spf=pass (imf30.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755850565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YVeh8OFS3+/IlZrjuSBDy6MWR0SMYXgiYrxYee0SPuc=;
	b=0UjGARzZRnLuPAldk1ZCVnAvFW4D/poqiasc3OEavrGPlcmSEd0Cmhqv+6d3nG3GiuojKc
	Ju1m4DY3he9XFuDJ2EC2dj5d523koupO2kGwtv8WZpEbcPX/NToNuV1urVufoPvLlLci4z
	RpC0w4YRzp55LAJpHC8xXRY/tJRDssQ=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-244581c3b43so17467285ad.2
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 01:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755850564; x=1756455364; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YVeh8OFS3+/IlZrjuSBDy6MWR0SMYXgiYrxYee0SPuc=;
        b=cVXwTvwWJHZqvMlmdDWkUPZFiXSZR4F/h3+HykYing9eRjxDHQhee8n3c+CVJt6NdH
         +BojL1Pt1Nyz3zLdl1+/pbZe1mEg24gRVQ836tmrFjFQAah5QzPJss7HZBzKoBjw8sj2
         oBiSzVRDdiIpp5L02NrZpK9H3n5nF+RRzgBKRfkLrhmv+w1z2tyLOBtCRuSEZ0y9+7Qa
         h4HnPz+nlkHbwDiHDqT2uonp9C+DTcwLaVto4DgUGxRPxMnZ8CaV2MI7VP+LKy8EbfH0
         Mq9ZrgVNVmoYhlkAUduNr2wQ3HKxulSGaW6TRwpyjhQO3GuriuY4xYfTX55eoWnZViA/
         G4fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755850564; x=1756455364;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YVeh8OFS3+/IlZrjuSBDy6MWR0SMYXgiYrxYee0SPuc=;
        b=w/wcZhG+PzAebbWJqy+/lOLCqumIfYTsA1MuUd/3V8kivBtQLI6EYjjs+1XCIhsXXt
         fa111DStfW9rLYTaFeVGzDehAhrrOspOTScyufFFyJ7cJaxcBoc4sDrGLZ/bjS6WVHGw
         FqQsYs5Y8+Aj4QUSml7NJx5efvxYlE1pROU1wRMwr+c+W1Lut9wuROy9JRjmXNDmQ8ZT
         bhbecBUGpYj4CtlKdZXDY2NicLK4Vc9UibMu/EKDDbUQi0MEl0RLtg3lG+8OhI8r6kiZ
         cy3lhKDbpf/Sbwd9htWeAfSbIlTFbKD2SerJjZ/ml6ygsJCe5u0iw4PgZWNRzK5WOYS+
         KyJA==
X-Forwarded-Encrypted: i=1; AJvYcCWWI25I4TofClOMD8dF/OrOeL1JjNlUYamAp1Mop1SUva4BhZVTpzRLd0BXcdxawhpw04CsdXWiWw==@kvack.org
X-Gm-Message-State: AOJu0Yx2tULM34z7rPCGvvArLZxKL5LE/z45vAqFUguNgEFaOgCO54f5
	D1U2bSEryWVToE37DgX3PRMCnqIXSlpNl0zTXDM/uvfjUB93PBbL3gebiSX1WiGoPjFUo4HFZzy
	HaqNUz9T0UcnI2dDltyAhvZSb4wzaZNY=
X-Gm-Gg: ASbGnctYzjnKAwiBT7E/iZqYoqEtbq9nQxgOrhJty/66BgDqKZ66ThwKpFUbsm82U1b
	bq/IsSjNDU6DgJs6HNjpEAYDY93ZHdYUl//pVTt3i7GhpLnPOFriIISfCrM4jrWHluU3Urfa41e
	gulq1IfHkVl7PZ83nB8LmdT7uXYzF6f6euCLI/t93+/LEJ2nPgashsN5EMb47faA+tX15awWb13
	wiOM+Vw2ypZDBvWm8NJKnhuOkvy1dGQ8w5f
X-Google-Smtp-Source: AGHT+IEOJXf+AeVA8GJXSwtIVDCbutsD9QgyfyAJ5PaMZOWfwJZDQTuqMWKOpwuzJZN4EkQir8nz/hEMiI5zBLDIKNU=
X-Received: by 2002:a17:902:ea01:b0:245:f5b8:87ab with SMTP id
 d9443c01a7336-2462edd7d9dmr29942155ad.3.1755850564406; Fri, 22 Aug 2025
 01:16:04 -0700 (PDT)
MIME-Version: 1.0
References: <20250813133812.926145-1-ethan.w.s.graham@gmail.com>
 <20250813133812.926145-7-ethan.w.s.graham@gmail.com> <CANpmjNMXnXf879XZc-skhbv17sjppwzr0VGYPrrWokCejfOT1A@mail.gmail.com>
 <CALrw=nFKv9ORN=w26UZB1qEi904DP1V5oqDsQv7mt8QGVhPW1A@mail.gmail.com>
 <20250815011744.GB1302@sol> <CALrw=nHcpDNwOV6ROGsXq8TtaPNGC4kGf_5YDTfVs2U1+wjRhg@mail.gmail.com>
 <CANpmjNOdq9iwuS9u6NhCrZ+AsM+_pAfZXZsTmpXMPacjRjV80g@mail.gmail.com>
In-Reply-To: <CANpmjNOdq9iwuS9u6NhCrZ+AsM+_pAfZXZsTmpXMPacjRjV80g@mail.gmail.com>
From: Ethan Graham <ethan.w.s.graham@gmail.com>
Date: Fri, 22 Aug 2025 10:15:51 +0200
X-Gm-Features: Ac12FXwnoEYMnSaKSxMxoYPh7b4TsxXD4qJ__w-NoWUUMjPmRTgOxfHSPEf4r3U
Message-ID: <CANgxf6xCYE4dQQ9=UDotB351wxs46=ZUhWz4zfrROH5nNsSBRg@mail.gmail.com>
Subject: Re: [PATCH v1 RFC 6/6] crypto: implement KFuzzTest targets for PKCS7
 and RSA parsing
To: Marco Elver <elver@google.com>
Cc: Ignat Korchagin <ignat@cloudflare.com>, Eric Biggers <ebiggers@kernel.org>, ethangraham@google.com, 
	glider@google.com, andreyknvl@gmail.com, brendan.higgins@linux.dev, 
	davidgow@google.com, dvyukov@google.com, jannh@google.com, rmoar@google.com, 
	shuah@kernel.org, tarasmadan@google.com, kasan-dev@googlegroups.com, 
	kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	"open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AD11380005
X-Stat-Signature: sn4o3toxx7mftb7knhphutwkrgqbqko8
X-Rspam-User: 
X-HE-Tag: 1755850565-139039
X-HE-Meta: U2FsdGVkX1+5dUtdY7heNUoj/CTjktHof3V68NYHqgJu8a6NHuDqKMMdzWnsQZ7lj3FE/p6tHtPyfXLRf+ULSO2hQzD2SWoQuJirIiE7Jr1KtLw+2lQJx5/Vo7FmIS5yofpdf02DipMYXvxJyen5DGNHZ7ZnFt/fh78pyYSpNHpCeCfEbi2SJKVbcHxCGeR2ERCm2aHCcykNTF8sRZRIjxpCCXPZ0g1CSnnEDpsJiI7Spsg4pjS77TbT31Dw0/q26EMwQ12OdYf1wpEfLlw3jMoOT7fHhJvrTrddre5ZptRk8jt6w+PQrhSmusPT/SvrfST2SMaPpl9hzyYnemMkpL72GYOU13G9/myzMYlURZ6/RxyqSoszPrkqtP78oDysxfQWFslqBzeE7YDw3PhJq7xGuNNFsJsRUGhDTq7RL5JLtQmE1+4ZNNtYGxA2lDwcrDNXu0O3Hht1I8y5JpEliArirsj5xneKOy2xke8wZiw4uBEMXiCrGqTB0ImG6qNAjak/pFJk2ImoUc4QZgD/RCLxfx/fXUmm/Vzluu27s8ncvos2OANdYIZsux8q45QGMU8XVTJRw/IEcWuis1eVzqVlOUiHjxfCQKAcTVVs5CzUnARduIPOmLldVG3RxDJbUUZbyM4TZq1ivLGzUK193A7I2zFw79b6NIOEyjTsXSo0xWef9A4pSrYaT0N/H+UokqXfZzvGiD4cv16BgknufALL+3ZZ+cmx/cRs82WhKC9FSe16pQXgvxmbRW4wXOskoeOi1bKDkfseXrtjHBUubqM3IInVv5xVPn+3GHbBlUXeBAj/oFa7s4O4PK6jwg/P2T+28ZjQvjZ8h/PkJEZb9CSjRTY6WdNcwR8npKpKbw5f7J6ldSTkfYbo6NO3qpT58lBFNtqIMWNjrL/uPFKIuy8fi6s4pvYpippf5cr8twBFTC0Mv2ficd4RgqejyrdFKGo7PlBMsSaupF+lHAE
 KECah3rA
 vpUcMmrKzeu72Ahxc7ZPfG/3pLK0MjYRO57kn0HJkHrSfT6p3evbey5JYTSZVwalZUk6ak0binUtZZXPRs13qKK2Y02IacsgzHG+iinHu/e0i+A5zmrTAUIYxCurV3B4yyNWdL35zIfR8CjJ+VIdhjwXNqrlvKHJyflhMe6ysRxyup7ozOBmW7yQxsiC8JcGbgEzncZk5BdMVicMkM7pjaBaDizPRI+6lr1Uv6m1AQ3DAm3p3FmrIkYahBRlOIUZ48StF7S8WuZkySQtUN8ZJHIovalkBU9+kL9tKOMdKuoPOrPORbtSK/fjj7DxhVyD7ccAHr4P67CQJyFvB7NXy61JSfFN+8fvKFzLz2FfC9zyBc2C6g55Gn2qTCzUx96cWcCGySgAtZb21LjhKGgOFzgpeQ210SQLeS6jG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 12:08=E2=80=AFPM Marco Elver <elver@google.com> wro=
te:
> For example something like:
> For subsystem foo.c, define a KFuzzTest in foo_kfuzz.c, and then in
> the Makfile add "obj-$(CONFIG_KFUZZTEST) +=3D foo_kfuzz.o".

I agree that fuzz targets should only be built if CONFIG_KFUZZTEST is
enabled. Building a separate foo_kfuzz.o is probably ideal, but will
need to think about how to cleanly handle static functions.

> Alternatively, to test internal static functions, place the KFuzzTest
> harness in a file foo_kfuzz.h, and include at the bottom of foo.c.
>
> Alex, Ethan, and KUnit folks: What's your preference?

I think placing fuzz targets in separate files is a step in the right
direction. Including a foo_kfuzz.h file inside of the source does still
pollute the file to some extent but certainly less than having one or
more KFuzzTest targets defined alongside the code.


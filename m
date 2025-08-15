Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 456A0CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 13:00:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADE8D6B02BE; Fri, 15 Aug 2025 09:00:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8E386B02BF; Fri, 15 Aug 2025 09:00:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CAF76B02C0; Fri, 15 Aug 2025 09:00:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8C3646B02BE
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:00:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3D1DF16014C
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:00:54 +0000 (UTC)
X-FDA: 83779001628.13.71533DE
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1D87018000D
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:00:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=Arc7qU6c;
	spf=pass (imf06.hostedemail.com: domain of ignat@cloudflare.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=ignat@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755262852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M5aKJ6EuhxrNInhVNv1lAb8m/GnY8B+pF9rLGMgta08=;
	b=n0/JVxf/rzPFHBtvWc3mJIf3kVu2NNtX06l7OvU0yC+CM6zOPNPiUFlUImEmbHndFtENDj
	uUWSwNh/Ykmsg6Ra9mfxpCmvJcgYXahXcgf5YP3BbjUfXlaoJWOWLC7HA+lA314edgqZ1Y
	iWpayEu49A/JcjNrodlrDpb/xbORMWM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=Arc7qU6c;
	spf=pass (imf06.hostedemail.com: domain of ignat@cloudflare.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=ignat@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755262852; a=rsa-sha256;
	cv=none;
	b=23eizISXM4rFnFYIMG1KgHR8eGXAp9z25qH/H0QoCd+8QaGoky436UzybErIZcLsjJ12tJ
	THLQi00zSlehwl+k/5SWJ2Z80DQwnLknilX75yFAbBQT8pZ64UlvW2Cn5ZzQsjw74Eo2ZL
	WJ/KQOR7v4nsJW+ZcCGPrtBT9TXUwXY=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-55ce52ab898so2264354e87.3
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1755262850; x=1755867650; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M5aKJ6EuhxrNInhVNv1lAb8m/GnY8B+pF9rLGMgta08=;
        b=Arc7qU6c6qGFBGBj4xmqT26uctaDwe7N1rwpt2mJx73LuK3DPD+aZQyYIpuM1S4RlE
         Z3nG/2WZlkuS85uL+7b9FjpmKs9oMqTmVLMfsR6pRQOATjIWGU/WkT/nfQYeHNyHGvoR
         QzSnXHUtBOmlCN/mnTYYy4Iu4ep7o0uVINH68TOoxLT+ooYDny9lP1DbsGLspq9jk0Gm
         urJiDF8+Q9ovpJgB0ktLwM123DeDwmlRGH8WMGALu8cMlL6NipqNAVMhZA4IftZSHH6O
         +PyrRy8lxZ4TcdhaO0tW1dJqBpmuQ2eWjDgXH/VLKmr+saqVYzBFAKDl5Wzc/sClDyr3
         BZFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755262850; x=1755867650;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M5aKJ6EuhxrNInhVNv1lAb8m/GnY8B+pF9rLGMgta08=;
        b=VHwyzRisiNsXtQE1PK75MoOJvBWv0fPGtpJXaufBdIYquW/Z+MPsqxKiv5/G3ANn2d
         So1ys+UtIrZJdT4Z/fEma3lGvvxRs6PFUik7V6f9VkqjJDRsW5R8wbfFbO2OaEBEjoeX
         hGXW+ox/n3MtN7zofMLgFSATTD7dB/WfYiW9XyUpaHPKCiMTUJeG+7TPImEH5QLbxeTv
         qchOi17mO2TPr7si4KniuXloR+8qQ7yE2i0zI0PgJPVkgxlgGISl6ASMUuGc2hxZFgBt
         dmZSRlckYL/E0wJHth+Yaut574gzThk08oaogAhwXqg2ZLpa0mXyofPqMzhImqtme+4F
         1UwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVl3EewJLeaNVaJpbmWDZSDaWXx1093qqzKU3RICjADxfJyJPO+EQVVCYFKm5A5NeOrQjtR9OFkBg==@kvack.org
X-Gm-Message-State: AOJu0YzoleeLAr1CVJdlq3ICj+oheEWGgGMxaiGip774IvunOBBltySs
	EyK+PFuQ3tn5dYuqIp6CzCE+aiM37+eB1eSwhzN/PV1B74UH6vW0qdY6RdTe7atO/pKhJ0yD0eC
	YlGCJ79Qe7dcM5WaKCUuaUStzsjtEP9IIv9UkASSgyw==
X-Gm-Gg: ASbGncvE1YZj3oCar7HhCWmzLtNIzs/Jx3lhABhNVuAlCk7VxnnLRDZNzAFLfYqZVyv
	/knVHVK+zbOtAr3AsuUDzMAA5mM6QPc4Kzl1uD7vsbFjvKF0u3xu/FOkwwdvauqzKjU2vA/+cUr
	/XjpQ20HsdAhTQ1JO5+2LJG19mkaj/FE5W75g7LgRsm0ZrIzIwpRHqs3hBZFpyiyyhuGR/JQwFo
	FkPUiITGg55g1uC2v4+j+aGkQ==
X-Google-Smtp-Source: AGHT+IFNKOB1rrD+w7VKvQTDOwyeOYLz2abWlq0iGeI3es8w5nvcHLIOmT4MUBEah/yIuNYyhBR1ZRVJ1G+8nKdddYc=
X-Received: by 2002:a05:6512:3c81:b0:55b:8e2e:8cc9 with SMTP id
 2adb3069b0e04-55ceeb2d2c4mr585014e87.33.1755262848871; Fri, 15 Aug 2025
 06:00:48 -0700 (PDT)
MIME-Version: 1.0
References: <20250813133812.926145-1-ethan.w.s.graham@gmail.com>
 <20250813133812.926145-7-ethan.w.s.graham@gmail.com> <CANpmjNMXnXf879XZc-skhbv17sjppwzr0VGYPrrWokCejfOT1A@mail.gmail.com>
 <CALrw=nFKv9ORN=w26UZB1qEi904DP1V5oqDsQv7mt8QGVhPW1A@mail.gmail.com> <20250815011744.GB1302@sol>
In-Reply-To: <20250815011744.GB1302@sol>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Fri, 15 Aug 2025 14:00:37 +0100
X-Gm-Features: Ac12FXxJSZN0OfDcjS8s6OFmiOlXF2SG0blAOcgASCk44-lWBGEmHN2xDuaUJKY
Message-ID: <CALrw=nHcpDNwOV6ROGsXq8TtaPNGC4kGf_5YDTfVs2U1+wjRhg@mail.gmail.com>
Subject: Re: [PATCH v1 RFC 6/6] crypto: implement KFuzzTest targets for PKCS7
 and RSA parsing
To: Eric Biggers <ebiggers@kernel.org>
Cc: Marco Elver <elver@google.com>, Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com, 
	glider@google.com, andreyknvl@gmail.com, brendan.higgins@linux.dev, 
	davidgow@google.com, dvyukov@google.com, jannh@google.com, rmoar@google.com, 
	shuah@kernel.org, tarasmadan@google.com, kasan-dev@googlegroups.com, 
	kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	"open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1D87018000D
X-Rspam-User: 
X-Stat-Signature: nzg3kgp9bq7azb6ayr6btp59ebz31xob
X-Rspamd-Server: rspam09
X-HE-Tag: 1755262851-927570
X-HE-Meta: U2FsdGVkX19HBqqgT2ypwoJs0LRjd8GMU+09UwaKeX7NAJg/2WhiYYitv54/kh9Ccnzf4P6cWw+NAXdVehYWVt9CeM+uuDSJHdQOFr8TVRkKf3NC3JiSCQYMSN7e+4+QjZxT5CnbPbg7ysZ2obSeYLL98qjuYEX7KhBaYxKii6idYSefepWFJYup4wrVd91BDHI65yoffjXqOlj00Tz0EmQ8gVlU+QXtLAsJezArZVjsF/3fX0wByztoyIEIwn75LGu18+CmS94KrgvcEl14UN9CNcuhR5gIKMI6YAxFLx3KRDr1PsQMhuGE0maxeK61yknrrBen9fc41E/21P7hAqb5rM1S9JAsa80ZewnRKPd+nd57wyG2rFSqbLSTNCh1JJwVp5LnFgGmdQr0MWdeVERH9TCf/U0oBLpx7IJFdGIW7K9yhNd2288dTFMIcu0eI4OZPZRmbbcXsbR5t/tYapEnrS909poT14TPlfjDDrEJTcW+6MrgIIO0Hjhk/76KB+mfkpsN90rmrPp9pfi90Jd2IKHHFvze75dZ4DISIWARaz5eIA6JlUWDC/x9FdfNujDRruGbWOqn0vn+ppYcEAdIM+0NbZodhDYWq7Yc683GdDLR0VtcuQXQwavyrCz6RAqUNwMAcuboTbvqXcDZGQZ0VgTlqA+jaXNL8fuxADZjg0xCXyqrJz0hlxZ+thTw5Dqe6tKvIlsMnE5VNauIRw5Ye33LeISnks9+qPWx1EDoQy+UG4W1fFpW12BQaDugLtE9zx3Ou3K7emRjOJkHDt/zWujIaXhCxGndgS5kBDWo+4n0lIKw8A/jAeACAKUoZTYYbZdJWiTBSlmWN/92qurFrgmu92MN34vrKE3dm5EBHYQcCrFnWUHXVHXbAwU/kuNYfiy8M2izYNuQUw/fPJSMJ0rY0mL9/zSUzfA0brz2904ln9Vv1LeX1D7b6Wn01jnDmQpnrNqkq5KILnp
 FWeSEka7
 WD8rjRFaHVBuHIOE6ZVUkrHAjzGPivzCWQr5UqR7br4k2ccJ/nfrjvonksPX8Qp+GiJf8xIYv6KN94QPbQM1VJbzOzCFavIwSEj8EDH7pNjAKn4xLQPMMAyxY/mF4a3xJhLMj0Ec5dKUynwtqWf1QdaLDb1LOhaz2X79Sz2YPZ11qmzRuNq68ZKuqDS+am7wtTkQXFtvqoGPcIYRAy1REv3oBYhqyPhWV77vBe/h4vEmkAP3wwBjj30qBCf04es3pZYLxPZA7lo6SdZcyV+D6dLNZCf7W/b0ShJ9dlQbra8FcQ9jCN0TTliD21Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 2:18=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Thu, Aug 14, 2025 at 04:28:13PM +0100, Ignat Korchagin wrote:
> > Not sure if it has been mentioned elsewhere, but one thing I already
> > don't like about it is that these definitions "pollute" the actual
> > source files. Might not be such a big deal here, but kernel source
> > files for core subsystems tend to become quite large and complex
> > already, so not a great idea to make them even larger and harder to
> > follow with fuzz definitions.
> >
> > As far as I'm aware, for the same reason KUnit [1] is not that popular
> > (or at least less popular than other approaches, like selftests [2]).
> > Is it possible to make it that these definitions live in separate
> > files or even closer to selftests?
>
> That's not the impression I get.  KUnit suites are normally defined in
> separate files, and KUnit seems to be increasing in popularity.

Great! Either I was wrong from the start or it changed and I haven't
looked there recently.

> KFuzzTest can use separate files too, it looks like?
>
> Would it make any sense for fuzz tests to be a special type of KUnit
> test, instead of a separate framework?

I think so, if possible. There is always some hurdles adopting new
framework, but if it would be a new feature of an existing one (either
KUnit or selftests - whatever fits better semantically), the existing
users of that framework are more likely to pick it up.

> - Eric


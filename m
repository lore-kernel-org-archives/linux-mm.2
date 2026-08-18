Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E94A9C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 16:28:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 993AA6B029D; Tue, 18 Aug 2026 12:28:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96BFE6B0577; Tue, 18 Aug 2026 12:28:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85BB06B075E; Tue, 18 Aug 2026 12:28:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5EB556B029D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:28:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CDDDCA0215
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:28:28 +0000 (UTC)
X-FDA: 85114923096.19.C097BDE
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id E65ADC000A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:28:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="JR1Fw6E/";
	spf=pass (imf22.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787070506;
	b=D1i5LmI4M9iLE3F8gP7blXSamFVuJQHS7rPO+CQuyqEJWqPFiqPxz+xfq19Xed5xsCGFwR
	ta2XVrRDPxZVIENjLqOc5mYEWTyP4Tb3Y1wRGrQoaucP/SYBR1eYDc79YKRCbq5JbIcOnw
	Gd/wmgJzQpJDU8VjJwDzhzmWJ0hUkHY=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="JR1Fw6E/";
	spf=pass (imf22.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787070506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dbZZ5Qry6yuxXO6bvmRGRdac1xpDRPzYGMineWgO9R0=;
	b=ZXzoEaIyA+/5b+ynFoY7yFmk0WISnPDm04Glhmwd11jgX1KNX43gBGiDDyid0Am3qIGNzC
	xfOymCMM5URyfgzPUABEXjRqJhCUJVXOvuvuogc0IBmx6kcHtuDPUECFQVf8Iex7SkTpSt
	9v0IbcZlujM7kABSFS0K5nanf/NPFC4=
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-39fa5e3a428so10542831fa.1
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:28:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787070505; cv=none;
        d=google.com; s=arc-20260327;
        b=CvIaF/D2N3M/DRVSoYcPT2gz0q7Gn91zJaazKAVie8RkldEq4N2Ud9J1L+xMVINzte
         EPfFWB5dsa+0Shj6/iPFLtmQl2noX4FDSfj6P3TJFuEVNWkZW8k0DMvbiW3r2YICI30G
         QQRdEgF/C7PK1rWNXboTSWK1M+SiBd7eV0O0OIOCRvR7KOh2RovVFCrJv3YHHjT6JbIs
         3TbmtKQtpE+cIjB9llgNmQlb2CpaNdelttmHXqZ10UIUmAWLTeQfaQLkQBFQIjlCxWNL
         mGsmCb6FSBJqJhSog2d5htH63x/rxy/iH4Ye6wNBgDq9+dDj7VWuUFiwfYxm+ks9SSTZ
         hDKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=dbZZ5Qry6yuxXO6bvmRGRdac1xpDRPzYGMineWgO9R0=;
        fh=HxPuHCG8efBaIO/t0CExSdyupDUWsQY9LDGyj52+RHc=;
        b=F7xUC6F9ZgzlDRh1c0v/PHo2fcCW+f/PZhDeJoQo1DW5nto04riQ9jUM0K0T+884zE
         gF+8S7JpLx2YocPuN7tsG8Iv/NExvvN/EML8Zb8UWfQCcOFE5V4zc54+JtugvvF1Ka4I
         WV5kkgHVIQB2h5yZ5YuKfKNzqBxdZGyYXDD6iFhkWK6vUCISFsTYgZsjooT6cGe3JhDC
         DKLlL/GE2Fn7tod3Kahrv7tC3kcB/C9Ylnll7hGZDJe1FXNH6wc+EyZm5c/3mpXQedGv
         WFnuoXiUdQaMpURoC8DrDNQDmyBLLWDmr5ODSpDjVvnw1lU3AQhB8/SILKQ1ru9YDrA+
         m+gw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787070505; x=1787675305; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dbZZ5Qry6yuxXO6bvmRGRdac1xpDRPzYGMineWgO9R0=;
        b=JR1Fw6E/FkGzSD8TEjvxnBvlViDdeXyhaGH3eAN9s2c6U4aTe7g2k4iPpUFh0WjiyA
         +I5g6uBtFTbfOt7LtLaO8YaXQqr4gTNGdbNhGiCCQfsIzMabMTf+Ucs5ZWkxs4lNPW48
         s1M3MOwrd5JdzQD/mhaj4NY1sWB0JFcFB2gCeGSCuxoKK4L289ew0JdDY430AnoTMAvO
         +NotobO2p83XL/Z1+o/2DfdlVAP3TJzI6wHJckU6OePHX6+4h3DYAgvW74DyuA8IsS3X
         BUTtpz7O+ZsYvVxCQRDi7KORMsCDlURyg1tlKHIWX6eBqFJnLDHBzwakw6BKpDebs8Z0
         DaLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787070505; x=1787675305;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=dbZZ5Qry6yuxXO6bvmRGRdac1xpDRPzYGMineWgO9R0=;
        b=EVtev5q1JqII8uhgqx3r198iyyo1kAP2H83px53fFpGbtzQN3oX9IQh41aMb/1E4pl
         HrzSZS7rMuMPacf8mr4Lpiami4TRYAVfJWD4qfPiLN8/tEkPDGvt2jkVGLVGWBgBnUM0
         yPa662rGry6rGm4/olvrAOGH4JfU4bRLhMr7EJqbIiBHaX1c1JsISa/695AOtJRFvx+4
         YSk5BCXf8r5H/ZuBw+GTP4PpgQZG+Yyi78ILfZ4ntNwfh7iEg879AkY6nV1PMaENRPUr
         OTtCFfqCaatqYnsr/CulOQjc6+jCG1u2+LIdKGxH6h6POV1lviT/JtA5mM6lhEKMsAGM
         Toww==
X-Forwarded-Encrypted: i=1; AHgh+RqLp1e4QBcZhw+lOndqfLR3w0C+QUQ46SnKUOux5mtjLH+UqvAAMhn3HjSh+a39eZJbHY/nG5sTJg==@kvack.org
X-Gm-Message-State: AOJu0YwPSy0oJ7C1knppkeC6fDQbelfSCQzXQLu3KdOO8q53TauW4Tum
	/R+AwAH09CLJspsmsM/HPjOtQvrK5rCPU56Du2DWKDq6iqITSNJOZS6UHm1IkhTLJaZQtQT2nHB
	AArLAWLgJrJKdWub8Zk5uPvzzAAV3RPw=
X-Gm-Gg: AR+sD10XMpt5e0GAEckNz8Q6af440uhps4XRw1fAT03CNZ2J2haAE8ZaPYs9qy7c3ds
	vIhmr0ccZIuI6ub3SUf3gnJUDUUMY41cG8FL6hEvDVWUqPMogmmNUmuZIjy/tY6cLXxGafROZwj
	8jJHg6Ebm6f8ZSjoB9SQbohBaUePCwZoS1A8MTu31Nf4bJRmu6EvhK9OGHJRbFbcMtHTjRSsqfA
	A8TmGMQA1tsRB6VSEYKLcK14a7RwthCxojKaAkdFSee1lG0pVVqLSXH3lQ3xjuU5m8+ejbrcX2V
	v1wtxkFDowDs/uTEDILeQ0X9yd1L5b8rORhgX7PTmGvwOFmXU9hssZ7ob4BTPQ==
X-Received: by 2002:a05:651c:a394:20b0:3a1:7927:c302 with SMTP id
 38308e7fff4ca-3a17927c534mr9424561fa.2.1787070504773; Tue, 18 Aug 2026
 09:28:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260817-stackdepot-trie-v1-0-53870ca1651b@cloudflare.com> <CANpmjNP4T=bov8gHN8cd7WwvE3daRGuwK+CmC4aEueCi20xRyg@mail.gmail.com>
In-Reply-To: <CANpmjNP4T=bov8gHN8cd7WwvE3daRGuwK+CmC4aEueCi20xRyg@mail.gmail.com>
From: Caleb Kan <calebkan1106@gmail.com>
Date: Tue, 18 Aug 2026 17:28:11 +0100
X-Gm-Features: AcwNN1Vz3DBmYRHZD_Q2DVfMCsbDVHhO9AT7M1dfD6y7lugpOHTU_T9MTzNQN38
Message-ID: <CAB4F_Jn97AXhhen9ZVkzQmctToLn-=e9_CPC-_8-HZAZz=WoVg@mail.gmail.com>
Subject: Re: [PATCH RFC 0/9] Path-compressed trie storage for persistent stack
 depot records
To: Marco Elver <elver@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	Vlastimil Babka <vbabka@kernel.org>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>, kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E65ADC000A
X-Stat-Signature: 4gssc1q4wecbc85xoepif76xpdbariqb
X-HE-Tag: 1787070506-946963
X-HE-Meta: U2FsdGVkX18GKjJIJ/59uo5XcNWbj7ZhoRCKzDCTdaqvUDXmEw/aXSBEolkxOaMHBNzArdjyszOmrWcxbL2IHw9F3TNMrhxR6dcHbv+3hOnY6JHtWNBJ9HqyomifATM5TtTWVvRt4a+Axccppui6gbCH3piQEsAeVkZxPNqbqsGvUO+UfL2sVqrJx+wkrkoUyd/DBbw0pPXdvpDtw/uKG/jyfpW7KnTLYbwdhVoskEPGvtmPDHiqUg9k+qjtSKmD+mh36ys6QOacDYGNVlf2zsoXuQKn8eSDqFuIbxFIfMrjeQQ5K0zUrKgY1h1a8DFXsVQ6YCd7ROlBa6PhdYevAA5jADurPRrvprayheyFL2wmuxQgG/BaRJ+0BlQLkgSZ+qsPDluMEp7tDQkD0cvIJwHmfizwQbn9BplRVhIiHvqwF88NEhI75uDrooXI+lCcN25q5+jZazJSclJit89FG7E5+pBbETZUSzdQd7Y8/gVIceTLNebqM0p3IKbMCk4pJwubnUF9IcjLVfEVc/iGVHCGPe2BmaGMNGgMOYkf1kaUWKqGJqfLV8k2Ipnk3w7ULrpdl+FijWtQfB16TBiECSJZe1dou26gg0GQA8NTGFyBBmNL5fs4C26D0zQK11FM1753DcC/vXGa62NNnMY82ORhoHaV8EbV7WnbiX6+U8p8stTv/UuXE9n0/ur9kh2TFX6NZaqwOs5CyU33kdiaBtAZauIJUtlYwbJyIEC9GA5p2gnSK4mT72Q8vtVsEtTDflF5ttbrWHjZj4Nz8RiTvnkbjp5rXhfQ7B2zM2W/LcYEVOrgB6shZeu5syhygdmeE9cl4NYzXsdQkVTLkYMlSGl37G4225fseUfY1aB1Yj0vL3tdj+15SuvoY9222W8APNcBLZTFfJLL1nPXXfPpVUIH2Np0EcSuS7x5i0JN1YKwdEEZwKCEMDI4dGxh2Yh1l79bntTKqjeZXakjWy0
 d5103JaW
 TotX2AnI0P4JzxfoFn5fh9vhQwPl4ipgEY9jd+slFNFQuLYFE9Y58pbTSCzINTFw0vMyqOaMS/Cy88xspCpnac1HfKd1efvVkN+7oqou9QQn/xUUw8VoXvijGAXKb+nbg8zyzlJVWt20RyRMeHmyB0u1xNVLe0Ud5IRyzieiH6M02lDYsexJamQv9uFKMmO4EHIcO8PdPh/X2XLwjNVMz1G7F5wY6Wnlk/3M5vpVFc90mxia+Ml6m6WHpasoYXJosgKhhNwLnXbbwnsDXGzgEkotdt4+67RW5KQIVvhO2PbQLr36ffHCIDeH7ozcA/DDm5f6fmEk43LudylEpX1ZIdDYwi017Y17V1/MuQKjEbkQmN5AdhNvSDy7Hu5L+ADjmpzQCw89QqYSIpAG0D9oKOvYg6iey7IcpKmwpdwCaYeu9xSc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Aug 2026 at 14:18, Marco Elver <elver@google.com> wrote:
> Stackdepot's design involves several trade-offs. Changing that needs a
> clearer motivation, in particular, which problem did you run into?
> Which problem were you unable to solve due to stackdepot's current
> design?
>
> The fact we potentially exhaust the pool is known, and the easiest fix
> is to increase the max number of pools. Compressing the records
> introduces a lot of complexity, whereas the simplest fix is to just
> double the pool size. Which environment are you targeting where
> doubling pools wouldn't work?

We ran into this on Cloudflare servers running Generic KASAN.
Stackdepot exhausted its pool budget even after we raised the limit
from 8,192 to 32,768 pools. Increasing it again would buy more time,
but it would not change the linear growth from storing each distinct
trace in full. I'll make the motivation and exhaustion evidence clearer
in v2.

> It sounds nice in theory, but you omitted the most imporant question
> most reviewers would have: what's the performance overhead?

I do not yet have direct measurements of save, lookup, or fetch overhead.
I'll add controlled hash-versus-trie benchmarks, collect data, and include
the results in v2.

> Not great; I'd expect changes to stackdepot internals to retain
> feature parity and no changes in observable behaviour.

For v2, I'll add a best-effort constrained insertion path analogous to
the hash backend, using only immediately available storage and without
allocating, waiting, or blocking.

> I don't see a better option. One issue is that we're increasing stack
> usage where stack_depot_fetch_into() is used, which in some contexts
> is already very constrained.

I'll measure the compiler-reported stack growth for every converted
caller and reduce it where necessary, then report the results with v2.

Thanks,
Caleb


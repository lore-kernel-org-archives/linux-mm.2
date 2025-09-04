Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A1D3CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 09:59:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A06DA8E000E; Thu,  4 Sep 2025 05:59:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DEFB8E0002; Thu,  4 Sep 2025 05:59:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91C328E000E; Thu,  4 Sep 2025 05:59:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F4918E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 05:59:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E80A61A0AAE
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:59:49 +0000 (UTC)
X-FDA: 83851121298.05.17C009B
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0EF6E14000C
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:59:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1hyc3iTF;
	spf=pass (imf26.hostedemail.com: domain of glider@google.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756979988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MHOpn0x1n+X9bJMJ6KJ/yl+og8/86ttoBXUy6mB0ey0=;
	b=gZhD+zyNAp04viqsNg04T2P4h2NZgULCov4npYoLYFaahIKZVllfHLQjQZqrehbH5k8IM1
	6Dad5gM6HkrIGPeWJXOkZZd0M6nxqgOdYR1j90kwiBGPN4qjbSpcOhVLs+phE9h+FQ+OiH
	4TXXbLP4CAtQg/lKJh/8bU6/aHPSrl4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1hyc3iTF;
	spf=pass (imf26.hostedemail.com: domain of glider@google.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756979988; a=rsa-sha256;
	cv=none;
	b=A7dkRLo8xxl8YGkTuwL/jXxWCkUfy0xWsIk9CpBxjdpWiwpvVMAye9yW7Enob03s6Z263B
	sSSdAGlhkKEcqKeeIZ4glGEqbuNOl8JiwtcCmxmIFEGHXRG0ZffLtAOi13ecy0MwUj1A3l
	V++SNDwsWrWF9hG/goiF8ayDvLn+9uU=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-72631c2c2fbso9552006d6.1
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 02:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756979987; x=1757584787; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MHOpn0x1n+X9bJMJ6KJ/yl+og8/86ttoBXUy6mB0ey0=;
        b=1hyc3iTFFffKM0lFFadknrCWGgslUzNz3HLWZHEXqbM/QiZ6M6MnyRryzIc66VTJtU
         6+TJ3IavwXhlj1fkJAO//sXvlx+ZdV0RR4peU3zKWjXVOTR2U/bpKOMwLORskD8Kfcmu
         y/KtulelbLD38yTJMcnvmfaf/vqY67MozLPBPTah5dtaYpbagqW0y1JfB2GEest1iQWN
         D/HeHdpYsTUS9zHH5ggkze0OoykMbjjhEHQKvKd0xTJYQBNOcSEAnyV2tIemPmfr8icw
         Ni+nwDGLgqvBY+juFLD54t2YW8sA6W4cIAvHui90/di8Cm7uYpmX7YZV3+g0mjDfOmRy
         GkbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756979987; x=1757584787;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MHOpn0x1n+X9bJMJ6KJ/yl+og8/86ttoBXUy6mB0ey0=;
        b=jb03om83cH/MIcnbt7bvVBfm6czjkB31UWDP0HVx/wqLuXAAFVUPm/FoeaPBOG3Vnz
         mK0r/fEWyITmm9FaD6wv/HWPTFLIT1kvVyLjR+ru9UxjGXmQCE6iPdkFTFTq780rkx0Y
         LI1TaDQ6u5oSpiYvIAGSvq8IfssvqG6SskgzMtKeyFKPbIBdKbOes2JSS3XYBFFMVyX3
         sUr8tzjfoJN3Fp6WsTVOZUBmAbXuRtR+ZdiChfqqJC0/XuwT5El7ljAPEwDe/zEbTNxb
         imztwS2Hl2ARUNUuGqV0I4phptDiTaOhLnqPQmpo0dUBBIlJKOiwd86rbiaEvT9T0eb2
         MJxw==
X-Forwarded-Encrypted: i=1; AJvYcCWJbVAIm2gB3TBvHnl+BRKQkN851G3J7+jUUcgpw+Uac+/x9ZxSq4HJl15tcUx/2CBd26kDY/AB2Q==@kvack.org
X-Gm-Message-State: AOJu0YxwZVNk6G8jaChxsN2aNv8jSuD66NgtjtOTVkdseFs1fEQvNfez
	znIciOR+vOnpoPxvlVyhQ4IhyufnTP84dM7HRtFLi1NXecngGd3g/N4RwErhUIjVWqL0UJqzR4z
	s0bLQR78QNqwgmeAhVaI9wswH2tDWHTICYoj1pkZA
X-Gm-Gg: ASbGnctLOaQMDZSr2jLfSSpt9a2nnDMG5V/UTb/GvZlumMLOomtMzyTv0SWuOWh8wph
	hqGtWArTit+oEdLJEMJkuKPMmTPj1VaeJ4gTnmDMwN/hGg1wYiIBpR5AxV6sS7nMQQ5oIhn1Ob6
	8BfD3aNP3OH1ktwRJ2tvRFed3rpNRuJLQLqmt4fQiqTqUg9FLoTHJjQ8XGRskCJz2xcoV1aitNk
	H6Cj+a9EFqVEOY+gTCpOD+Irxgc4bVpfgJ4HC+EWl7TxTtPLwAM3w==
X-Google-Smtp-Source: AGHT+IGT4Lm1UEnlQ2bizwHe4ELvu4hzuE9iFObagSCtHAbdLbsZpQZ4v6gnTYWZ5T4wkKXfEhUwpiekj7TMD6WN37U=
X-Received: by 2002:a05:6214:e41:b0:709:c7de:ce70 with SMTP id
 6a1803df08f44-70fac700db8mr222215406d6.10.1756979986529; Thu, 04 Sep 2025
 02:59:46 -0700 (PDT)
MIME-Version: 1.0
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com> <20250901164212.460229-7-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250901164212.460229-7-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 4 Sep 2025 11:59:09 +0200
X-Gm-Features: Ac12FXzQlIV_NpJ1rduhtC1FclDh1AxIHe380g_TpXDcw3vnB7j2ZNk2kb8WbdI
Message-ID: <CAG_fn=WJrdSr_6u770ke3TxyFimuMXXeTSQhsDR73POy4U8iug@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 6/7] kfuzztest: add KFuzzTest sample fuzz targets
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, brendan.higgins@linux.dev, 
	davidgow@google.com, dvyukov@google.com, jannh@google.com, elver@google.com, 
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com, 
	kasan-dev@googlegroups.com, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, dhowells@redhat.com, 
	lukas@wunner.de, ignat@cloudflare.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9manew6rsi9cc1d9ha4tct4e8ywm7yae
X-Rspam-User: 
X-Rspamd-Queue-Id: 0EF6E14000C
X-Rspamd-Server: rspam05
X-HE-Tag: 1756979987-415210
X-HE-Meta: U2FsdGVkX19uN0pA5+51R+zZjxbzhE1SzQvmXy30rt8a1Lqd8FjSCcP2ylXcuNhNQaNgk6EZTffOqyxX6iT/Nd/Ed9PChORDHXcw1AP75zQtwKtN/2G2g7EVgeJBmAqazqKZKaCt8F0Dv7brmtIwiBVk1VQXoUrukrQmgoZlyvYwZkZsWrftldFeyfRIqP37z+Jd41L11no3iB7DdX0HXEJefy84ber5iTdR/n1M2OottKDk3OgI8eOpcvQWHq7rEb+cy/W/6xsVeT7idw/qxPglW6dz2+C5r4IZvqQSAKOzjiIxw5HTUUn7+NsLyPcwaxZibLiQaEHFNzU3pQ/PvkI6FMgrbHonpLAcXXp4sm3//e9PPUY2P1jjRDPCRouOUxtVcw0dXptMTdphTuywDbK2rLcQN6biQNxKXUzoUp/SZ9UDKrG2y8uZJeRgrh6OUu7IpJHV+h0VwyKJ866luoaC8aDQ5kBFBjFPI4gplVOSJrl5Nk9PGCK1X0VU7p/wqnWJoKSYyFOjHsZnl3d77XrKBtoBLbtv9bG1qw6kCNxs//XKV0lpA22tTnrJdR7jZmMgtOfNeyexjD7gf+27oxLKqTbe/AgBgKYtyBAVmJjgv/VyIYUm0MUDaT1dERnSh9iJVRZMO8eKehUdww+ustoG0yS4ccZ0mP+DO9k40VUv6mTF1mqZZ5573v3P67iThTFeTyZnwbFGpQw8xXIW5xx4yO3zbry4dZFfAv95FrdgjK4gwOneNfc729ivJ+j2tcptV2dpYupzK2cHJNGxUy3rLrZ5/Gkpnqhl5Y02xuhE5wIXKx5VlieGiMYSyqr+KdJAKsgv2dVELB9+uaIJnVPNAoiFuj+pCmTGyCBW1vZos69OvI0EcAgxVwwOUnbYoRi+CUhG+Vnlc8MUEqcWug+xZXya5qIWhKYwphDPEWtacm26fN3OvictWFLI2IzJw7IAxOg3hd922qpnVNS
 ILlIIRmG
 Y22frr6r/uf4ofib6cOCH5P1TUBMtlr6CO/Sh0DxgDblbhBPaoddZDAW6X5pBpsKTUkVe/cn3Ov/p2L3hiv2a+srdzil1HyXMQXvg79TRqFBFsOzmrZD7uJvfwWw7hfunU2BSf8FOfxrIqpISzvGd8HsQjQTwNcf3l8Ab7NdMSRMjgmmHbV+HznrYZJu2RY7BBcsu/hEaCMBbJGx2AUhwbYZx9cDEzT1kJJnsKUQ7osPScqKGhEKTTJYhUxnlf61r4Cc5OCawj+KxIbhJvwKcwD5FRrLEzcYwL9dKcvSzUTCcn6flQ0NDsqwmog==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 6:43=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmail=
.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> Add two simple fuzz target samples to demonstrate the KFuzzTest API and
> provide basic self-tests for the framework.
>
> These examples showcase how a developer can define a fuzz target using
> the FUZZ_TEST(), constraint, and annotation macros, and serve as runtime
> sanity checks for the core logic. For example, they test that out-of-boun=
ds
> memory accesses into poisoned padding regions are correctly detected in a
> KASAN build.
>
> These have been tested by writing syzkaller-generated inputs into their
> debugfs 'input' files and verifying that the correct KASAN reports were
> triggered.
>
> Signed-off-by: Ethan Graham <ethangraham@google.com>
Acked-by: Alexander Potapenko <glider@google.com>


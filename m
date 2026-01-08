Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 279BCD1D46C
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 15:10:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42B2C6B0088; Thu,  8 Jan 2026 10:10:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F55E6B0089; Thu,  8 Jan 2026 10:10:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E1206B0092; Thu,  8 Jan 2026 10:10:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1CAD76B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:10:47 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C67F389A22
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:10:46 +0000 (UTC)
X-FDA: 84309133692.06.D64A13D
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf06.hostedemail.com (Postfix) with ESMTP id CCE4418000C
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:10:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=gakdwiuj;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf06.hostedemail.com: domain of debug@rivosinc.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767885044; a=rsa-sha256;
	cv=none;
	b=ipf4YFcNVqtfFyyZoUGxL1egNKQEDND3XAaZZrwU2hm35QKie1Jh+gwapZipqUUouXXZMv
	Np8BDKfY/ODWpg4JJhEOXMsRy3AfurB6/KTAMVjX/xM9VZFy7ZbxqG3skFW1gb0Eeouu6d
	WOiKEa2CVnBXLxBrJO5ID8w8I2VkkJ0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=gakdwiuj;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf06.hostedemail.com: domain of debug@rivosinc.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767885044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QTkbey9LWC4b27P/G+EnN+lFuImbI+lYFoSxJEGXtiI=;
	b=hZvOqbjdW4Q2BJ6Dx1C61usNqd8WFCSkKNf1Tt43rZO2CQW1dZeaLzwTWYKBfsrcft99jl
	bUObO9vZxy6pD5I5fPSWeYjF5H2bF78WkGhYRxolZ/q8b8kRjbNFUZGeqfZUvnJxTeO0gP
	oKefUCbF+p4xUbZt3Wc5f7AOR1KNodU=
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-6446fcddf2fso3505050d50.0
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 07:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1767885044; x=1768489844; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QTkbey9LWC4b27P/G+EnN+lFuImbI+lYFoSxJEGXtiI=;
        b=gakdwiujc3MNIVWkLIVx8DiMBlg9l+a4p0w+rxiMBZFxgZs6gZzKM4xkryuwHfPfSi
         VCG/CpWA+Mi6rm/Z+rtpQao6N0aSIRF+AwuoTG9zuOQshlmFoUc5iA/G+EUOVKtmezsX
         LJ3unIiP7UvM2Rd6MB0DoDLjB6qeKDqxiADOc7O7fRLA6+9oVH1xG/R1fpIDX20J1xMV
         HPuLfdK3BvllWMU/BOa1BLYiWMbjFx15XGm3nNY+asZtlpOm9toUntshWr8Gq/dQVujc
         LCUpwkI7sUyRlZD5wtHXrRKREnQkRVRBQkb28RtrN8H8TZ9SzUOGNtmRZF7CzDCjDDdu
         JM3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767885044; x=1768489844;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QTkbey9LWC4b27P/G+EnN+lFuImbI+lYFoSxJEGXtiI=;
        b=sEKnLGLK8zt55V83oPaWhfIctjePMFfAGTM0juXWAp6eoNUpnsR883olMCjwU6R16S
         lP835nFndTcV2gBecMsurAD0Uf0802R5l0A+kVcNo6A5uU/OVleCc3orV3HdSDx/UtR5
         xZFPTRXOiFJFkAlGZ4RMagPPfEFafsRDC07d9jDhjvVr/qezvZXZdSwbkdOmYvjcH1Y6
         EyXgQDthw6NXWtnizxruLg2C/q3HtlpGnigYAF2C/szFj0D68teIeq7c9JsI5Pcu7g33
         ha7bxf5teJfMWKbgHTve+O37jdhPfBwsPSqGzcZHZPEpazv4CDQClMfYDswWJ8e2AilA
         xkiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWk39+bF14jIrKA0OiHVvWWrte9nyrd1NXv5leCVyz1TwRoWGl6EwJ0emEpL3zdUpFKavpIH1ptYA==@kvack.org
X-Gm-Message-State: AOJu0YydOTtksvCR4+VcB0Qz1GjuATAFfO85+Yj4oZ47Iq+tnuPk+zHF
	GKXqi77hIsHIFXDUt7JuX4WI0RmLkKKsd2dZPZVbTxykz9BP8QSMY1NUzzRPlHEGX/+YTiYONVz
	ZthJqj9MbHXdyByVpG8X2WUFGWNs8emRcHh93+DqF8A==
X-Gm-Gg: AY/fxX4JwS/IpvUJ9eJRAismJpHcSnn+02twdzSyr9fgKSM9A6tTYw7YCMAIYzymMdz
	BPzqnHysUHe1TU2FhsE1BRq2JQnirYjnuRV2uO26KrFBp2NPVoE4Qrdzf6QVlsF6PTpdymtAZVZ
	XaadjXjP+fni3fom6cvMO1pZVzgweeSL5uGTKqgZUoQnZM1ArL7dAEd1ZDY4M8iyiiM6Uz7YS9p
	ZXP/XhHrVaLVBvog60gzb5ZvF2o5wRZOVjrPIDfTgecm8diSWCOgFvoeDhEOJdT1pslLw==
X-Google-Smtp-Source: AGHT+IHwlV11mJiZRvrc0ba9gyUKkJLs3Ivv5ZO/Sp66Caj6iICdWSs+vjcbtX7JeT7w+lz4Sr6DicIt8PKx9jaUzQk=
X-Received: by 2002:a05:690e:b88:b0:644:6ad4:fdfd with SMTP id
 956f58d0204a3-64716c14086mr5723963d50.71.1767885043558; Thu, 08 Jan 2026
 07:10:43 -0800 (PST)
MIME-Version: 1.0
References: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
 <e052745b-6bf0-c2a3-21b2-5ecd8b04ec70@kernel.org> <aTxf7IGlkGLgHgI2@debug.ba.rivosinc.com>
In-Reply-To: <aTxf7IGlkGLgHgI2@debug.ba.rivosinc.com>
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 8 Jan 2026 07:10:32 -0800
X-Gm-Features: AQt7F2r-MFLse9aM2Y-9SmWOvFLm93MsLbBkGvYnQc0D6QLcC_Q6_utP6Kihh0s
Message-ID: <CAKC1njQ-hS+kUJ0C_v0oqZW1EZw2zAXMp-SnnA-ZXh_H-SoVdQ@mail.gmail.com>
Subject: Re: [PATCH v26 00/28] riscv control-flow integrity for usermode
To: Paul Walmsley <pjw@kernel.org>
Cc: x86@kernel.org, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Brauner <brauner@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Oleg Nesterov <oleg@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Jann Horn <jannh@google.com>, 
	Conor Dooley <conor+dt@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, alistair.francis@wdc.com, 
	richard.henderson@linaro.org, jim.shu@sifive.com, 
	Andy Chiu <andybnac@gmail.com>, kito.cheng@sifive.com, charlie@rivosinc.com, 
	atishp@rivosinc.com, evan@rivosinc.com, cleger@rivosinc.com, 
	alexghiti@rivosinc.com, samitolvanen@google.com, broonie@kernel.org, 
	rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org, 
	Zong Li <zong.li@sifive.com>, Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
	Valentin Haudiquet <valentin.haudiquet@canonical.com>, Charles Mirabile <cmirabil@redhat.com>, 
	Jesse Huang <jesse.huang@sifive.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: rabynpxfjdw41aaaiyphnswmwqapdyf3
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CCE4418000C
X-HE-Tag: 1767885044-114305
X-HE-Meta: U2FsdGVkX1/iy6F0tgggV8uQXS6R9PKMoazuFjipRBqLuURmpKfud4epav/+/JP/vHXRPQ6PHD7Wut0E1J0L4+86gnEogQTn/PFO10Qqjos2v4WxmigmzzCc8PLyXpXT5XK2d5qkIYggDARZ2SwLSjCauAw8pR45Y6tuF/m6Q31KCWnjc7VMuk+2c5JopeKRBDK+2YHwlI8SicpgAFiXstNN8S1X8/tt97NAFcNosL6vHpoOiv9fF8pxf2L8x91tM61ZATYIwv75JtRwiO74rxrStqt3UGpbMw6LWPcoEwrSGgKy/z4kykgenYFT0TtAeA9Vb0t85q9eWy4QMABR3TrtWAKm7TzS688gR3O8SaH4VMehAcD2xqnEWdp8rNzRCxb5r9Pd6KrrdDx54aqQu05j5LyKEwty4oNIUaiNiTEitTuH3r1K5Xt+uMj9NF6uoxIEoHSJzKhPJpzeVDii/FiuAg3YaQZTS+zFxD2vI4nFPHm1ff7GZtKAsZCYAS7VL5eT5gmoVAz8RPlIg/7c80eo4TyHif8aFj9b5cbpOTC0BUwCKXRXbPe/V3d+4aJe3NzO16vkxKJSysoHq5Pz8k4dg6mAKR1ideeyhxRRnF3DZ4y/mNtvacZt8yjTB8yJ5syvx6v/WN7bIhhNHSrLfLDlOY69GQVoPUnmNtkpIdPpoPV05Hs5LL7YBDLU1nzxyVMpkopi9HjD+ZBvRtLiVWAS7lNAxFcOZ1hJhFCfvOwL4uoN//H9UbD1mWgTuasHE990HcEmEXXZv6bICqsjo+KMwRW1OWDyR8aBuvmJVflimEpdefyQ0Xn4r4aBeRjQ1sMoQXM1Y+qEkx0wmpq5pcJrXP4bADcvF57esoER/CaXMulryC3a/mTANOYrbomEXBqORL6naAHluL+0KZGnKRoPhnfLNgCJGrnj3fX+zw3YcBExdSOskvjBNi0LpZjceLy79U+qmpZbaLFRWH8
 /EtkuKdO
 bV0FEDd/kMZrmfE4Zm6AHsyTDsGVJKLxOGvECiOyCfVNtgqoleAZPp1e1Yb/qA6C4XnSbMOlgFHwM4Vzcr1Q3e0ijxA3XEATO3GO0yW6hjwdKwrhBO+ZhuU5Fq4t2eILiLBdWIlmsZGYVYVLpYeIUOup76+snlCvKRPXSTTnCcMevJQVAmVIxQ1p0BZWdp22/IMDjeGMkyc5JrD38vZziguNG29JwnpmMYczFpmMGIiB4bBv6qw6Oeh2VtjT1JyR0xEIVZ0m4NKs8mgJ89t+ZBgYkpEyBk20jtQaz7V4fc+p1URcLxhsaJobj6BoBwDBy/B7lCnOzTrastoE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Paul,

I have a bugfix for a bug reported by Jesse Huang (thanks Jesse) in riscv
implementation of `map_shadow_stack`.

Should I send a new series or only the bugfix-patch for implementation
of `map_shadow_stack`

Let me know. Thanks.

-Deepak

-Deepak



On Fri, Dec 12, 2025 at 10:33=E2=80=AFAM Deepak Gupta <debug@rivosinc.com> =
wrote:
>
> On Fri, Dec 12, 2025 at 01:30:29AM -0700, Paul Walmsley wrote:
> >On Thu, 11 Dec 2025, Deepak Gupta via B4 Relay wrote:
> >
> >> v26: CONFIG_RISCV_USER_CFI depends on CONFIG_MMU (dependency of shadow=
 stack
> >> on MMU). Used b4 to pick tags, apparantly it messed up some tag picks.=
 Fixing it
> >
> >Deepak: I'm now (at least) the third person to tell you to stop resendin=
g
> >this entire series over and over again.
>
> To be very honest I also feel very bad doing and DOSing the lists. Sorry =
to you
> and everyone else.
>
> But I have been sitting on this patch series for last 3-4 merge windows w=
ith
> patches being exactly same/similar. So I have been a little more than des=
perate
> to get it in.
>
> I really haven't had any meaningful feedback on patch series except stall=
ing
> just before each merge window for reasons which really shouldn't stall it=
s
> merge. Sure that's the nature of open source development and it's maintai=
ner's
> call at the end of the day. And I am new to this. I'll improve.
>
> >
> >First, a modified version of the CFI v23 series was ALREADY SITTING IN
> >LINUX-NEXT.  So there's no reason you should be resending the entire
> >series, UNLESS your intention for me is to drop the entire existing seri=
es
> >and wait for another merge window.
> >
> >Second: when someone asks you questions about an individual patch, and y=
ou
> >want to answer those questions, it's NOT GOOD for you to resend the enti=
re
> >28 series as the response!  You are DDOSing a bunch of lists and E-mail
> >inboxes.  Just answer the question in a single E-mail.  If you want to
> >update a single patch, just send that one patch.
>
> Noted. I wasn't sure about it. I'll explicitly ask next time if you want =
me to
> send another one.
>
> >
> >If you don't start paying attention to these rules then people are going
> >to start ignoring you -- at best! -- and it's going to give the entire
> >community a bad reputation.
>
> Even before this, this patch series has been ignored largely. I don't kno=
w
> how to get attention. All I wanted was either feedback or get it in. And =
as I
> said I've been desparate to get it in. Also as I said, I'll improve.
>
> >
> >Please acknowledge that you understand this,
>
> ACKed.
>
> >
> >
> >- Paul


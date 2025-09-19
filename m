Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF821CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 15:08:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22FEC280001; Fri, 19 Sep 2025 11:08:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E0E98E0019; Fri, 19 Sep 2025 11:08:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11DBB280001; Fri, 19 Sep 2025 11:08:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 017C78E0019
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 11:08:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C34D7BA636
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 15:08:16 +0000 (UTC)
X-FDA: 83906330592.26.43D308E
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id DD82E160016
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 15:08:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kxyHzReA;
	spf=pass (imf08.hostedemail.com: domain of glider@google.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758294494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LFmZTAQu6xp1H90eoajASSZ3CmnWB3SEwm5mOewzT+c=;
	b=uXw3VLHH39Jrwd0e3PLAoKet1MVCUNl+KbzMH4ZSOIlrZI9tJ5JqRZN92Aovgkhd+2vqQT
	f2ot7MF0FcqCDOW/p+nbFUE4UsEz0TzjPITudGK+L/0B8Fr2PwLQFKq+8UiCaf2bMxvkD9
	zePM8ytw6kosgo9A3Fy4R3qURcRTRBU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kxyHzReA;
	spf=pass (imf08.hostedemail.com: domain of glider@google.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758294494; a=rsa-sha256;
	cv=none;
	b=Ly7QUk6RVrhQegsIcn357oodSrcugg/UF9y+XvK4Dj/aPVDuE6n9wVlgfxftoJaTSveuZ/
	ndIfLjX7TsGumjIUyMC9WOzbq4hmEt0sj1PTAqxi5tXqvZouPHURvMHi1jxYsp2NleIwYc
	ypsFnXboFfy5zcY529AbjKJNwoLr8g0=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-826fe3b3e2bso235930285a.0
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758294494; x=1758899294; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LFmZTAQu6xp1H90eoajASSZ3CmnWB3SEwm5mOewzT+c=;
        b=kxyHzReANyEfV7EMmuaRDJo4sWeYQIcRbQMWOpBJ2G+UInJSa9GM6S15AFMj5lzWRf
         PArKXxo28qL6GPJu4Z1cifXF2j+Pdv/48h8rxENc0yuYez5WmMcotE8NAAB3ewy4gG4M
         IgzwIogBZluon2IQKCq0qIeEyPXpapH5BYKN3NWLZ6qfGOW/mKJbUeDo0ID2xut2crLH
         owu5fQ0TrifSWyxHjOwbV22/M5DQOvrBuu4N8GbJtzlMX1pNAPAHTTQi62/+qtvg9IFl
         q5gOXKVrVMUjZh40qgop2SZd6nGcTF/pLl4lSmKrQXWmb0gX1h/w1SMu1GE+bYUTrXpY
         81Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758294494; x=1758899294;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LFmZTAQu6xp1H90eoajASSZ3CmnWB3SEwm5mOewzT+c=;
        b=suALN80O6mv2S11jQ8DCnPTg1kg+G0+puSB7AP0ZXO+1h+M5pCWam7iIkTN3Rv/b2z
         JPZQc2pw+MKLUAOM9aNKH09h7yr+XkSC8nfNSWhzapGbReIZZ1RcR6OdzN7ts3aB0h2f
         uUlRKk88CxL2E6lD/mDq08HbWoPQwENe4yAiT/sJVYMQ8VCbgc3uAn5fND5nc0vOEubX
         7UD9w9yDKxQcoevXGravbGmo63UY51nKL1RoMtf3XgCI3TDt7sbJCxZvVdmlX2sew7gG
         rvUgdKyZLfoTEzpnDMMpiJdp/59+mRvvMxdQk9OmxTlvv6YpSgAQdn1yZlmkD9hk2Kks
         OMnw==
X-Forwarded-Encrypted: i=1; AJvYcCUiFum3+yg6ucX7prIuMKnzfzyMuMgD1JoLHjkCtXiTayrHUAip9KymtdxdHfMGyXTi9+T+xlkLGw==@kvack.org
X-Gm-Message-State: AOJu0YweqkCvVErTuN/NgMBFiCyjOwvnCowdttsSgJZ+G66Q42Clko+4
	WzYfA3qxFdLCIAr55hLGtjulh3VkHoHK03HySSUeSlszgdYvnmr8FaQcek+39gki7cHqNSOHsKT
	BRQV1YWyFFjdBsOpFI2ntuAcj55j/MYcY7c0UzKrN
X-Gm-Gg: ASbGncuns964dGl/rKZQvW4WFz5KSIb7BEzJmfWAlWa+9e0aM9q01MMI82STNiNcbLV
	NIIvs7ZwS6jI4qg7gVsUIEBKRQkVTWOE9ou6iTtEq1mdOElYb9N+jUiec5UrZMh6eNT7em73cr4
	jL8vZtlbCwCG3yEiVfJ2qqO5JQ+SsqovXYLUb8jan1PNpBvFywqkrHQWU1qpyP2mGlyvnppxmzn
	J8SQkrGQ3rDqEwZMDgidxp034ToIYVDWhzDVQ==
X-Google-Smtp-Source: AGHT+IFR40Mffz39BAytKY3HCLacxnJ1WKp/TI2KMqqv5ab7iIIVbpHo/r7oLhpjnTyf+invw9UKbqtbStpZDWCH5zU=
X-Received: by 2002:ad4:5d66:0:b0:710:e1bc:ae42 with SMTP id
 6a1803df08f44-79910e91071mr49973476d6.10.1758294493230; Fri, 19 Sep 2025
 08:08:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com> <20250919145750.3448393-10-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250919145750.3448393-10-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 19 Sep 2025 17:07:36 +0200
X-Gm-Features: AS18NWA8NT9J6yW558WFqJ9v7KlWvLUFu5ioEKltNkloZ03huDtjBzwZEdnYYKc
Message-ID: <CAG_fn=VVWKR0JLCTZ8HvB51UX3EYrFg1s_xD-ohOKDQwDHOxHQ@mail.gmail.com>
Subject: Re: [PATCH v2 09/10] fs/binfmt_script: add KFuzzTest target for load_script
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org, 
	sj@kernel.org, tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ps9hd5gefehyzys9nx9cxe4ibc1cfm6u
X-Rspam-User: 
X-Rspamd-Queue-Id: DD82E160016
X-Rspamd-Server: rspam04
X-HE-Tag: 1758294494-888638
X-HE-Meta: U2FsdGVkX1+sreVx6BbTjNJugA6ErPZdh9xvilsCllbOMQDZrOgLuc5v11X3d2rJGQEsK+uTwL7MFHpYKtqEGwpkrrpevjefn4j8ecOEobPnVF3W6ywmiXoVRV+EMViUxd8Rd2LXapIddktfQpUo6vcHbKa974pAMuFlHFHFWM7LgeYfzlLbsxGGREpMnB/oFAMmRb511nlMcTWNCKp+OhpRUzdfYCKVl4uSvXNhQ7vh/h+NbOClRNWe5TxfCTGNieDAYiBy3WALVoMjKmp/6D8AE0nOUmXas65TACNY0P+bTtJPswAFNR3DEDxn5H78Xx7Yz4jNy/ai6X4ho4Xwzi7IqxQVmHBCrCtObB9oDBJ7Ue3gQiL6tb89HIfr0d+rGeTvh7oXidvKVT922dah9AU/q3aMz6FyGy4YebvS/+l4MTNWOR9bAOETvZmGTM9JU1H6zUw0MjqcsGesY+F4L3xCIDTVjXq9/baQOB8f210TDGiGW7jPhO1/vmMbdDxBYnmECon/5BQ8DQSY07KP9M0xK0MOozEJc4mCwO+byBr/WECFpPLuvlQYUXJD8KYgxZRzCJWy+C0f5OuZMDZG8sitqW48h6fT5/oYohDjsltvz8eekIRUwo6xqvsjh2ocp2HRA+p/P6K28pwHOrsd5hFRCF0Qty3Xh1NlGvu4glpj++nD2sqXzwctPzLb78+jHh2SIsOSDlA3MT5mtBxyNHP5yJ7RWUy1PeDRBPBGw6pdpBFVGDE9uwfNql8MohR1WKQRPPt/5ZFCLPrRcuiRhyYF+XKP0NYYw6jXRdJ/y26e/p1F2tWjDNrFHHet8U/50iMYQaKk0NaBtENYEbQKRhvqmy/fvfTcM1KpIBbgxEIJkJYkIY415kLVarENZmizopda3kPXkhk5/rNXUF0ElKFBZJvGjVS0uLycMZWQM/0ZrfwrVRfxKr0qB/FP29yXxVa8NqWnM9UPAdEtt39
 FBW+xzlc
 +CnKf/lD2K1Di0aMTKJsI5fMpKS33gCE6ZC1OnP2isZ2djmKslvcYwHhylRb1oj3ydTDGXrevKhhKuakmvESwtTiW1jJW96LfuB9+982C60Kx/r+rVGdEybhVrLm9SROOA56CVq8lbECN6uyt5TXjUjHkCl+uMGXf75bTFT5h0ndOwBqDVpXWq0J1K7zmL17qjAtY0BD95zJjvG1s8ognjBYA8V6s4GD02jv8S3yjRF/ASiaMBCmo3u6aH979wz1dx5P6GvjzDtx+vYHewvxyPRBse+NNU3CSuhWbf51edE3GlI7ofoAMheGZns/R8NQwtKUArHJc2VPr4VTRZFTej5iSVajB6IhV7G7tcAnh1fMh3To=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 4:58=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> Add a KFuzzTest target for the load_script function to serve as a
> real-world example of the framework's usage.
>
> The load_script function is responsible for parsing the shebang line
> (`#!`) of script files. This makes it an excellent candidate for
> KFuzzTest, as it involves parsing user-controlled data within the
> binary loading path, which is not directly exposed as a system call.
>
> The provided fuzz target in fs/tests/binfmt_script_kfuzz.c illustrates
> how to fuzz a function that requires more involved setup - here, we only
> let the fuzzer generate input for the `buf` field of struct linux_bprm,
> and manually set the other fields with sensible values inside of the
> FUZZ_TEST body.
>
> To demonstrate the effectiveness of the fuzz target, a buffer overflow
> bug was injected in the load_script function like so:
>
> - buf_end =3D bprm->buf + sizeof(bprm->buf) - 1;
> + buf_end =3D bprm->buf + sizeof(bprm->buf) + 1;
>
> Which was caught in around 40 seconds by syzkaller simultaneously
> fuzzing four other targets, a realistic use case where targets are
> continuously fuzzed. It also requires that the fuzzer be smart enough to
> generate an input starting with `#!`.
>
> While this bug is shallow, the fact that the bug is caught quickly and
> with minimal additional code can potentially be a source of confidence
> when modifying existing implementations or writing new functions.
>
> Signed-off-by: Ethan Graham <ethangraham@google.com>
Acked-by: Alexander Potapenko <glider@google.com>


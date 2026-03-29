Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DF60F3D616
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 17:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FEDB6B0092; Sun, 29 Mar 2026 13:34:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AF236B0095; Sun, 29 Mar 2026 13:34:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79D6C6B0096; Sun, 29 Mar 2026 13:34:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 63A476B0092
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 13:34:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0CD8858F81
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 17:34:01 +0000 (UTC)
X-FDA: 84599798682.13.F7B73F1
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id 13102180005
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 17:33:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VU6WbQ7N;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774805639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QkCmTI7yYjAJjvmfpeVl++cohGyuqaJEN8ofoKb3dzU=;
	b=fNCSylCPpP0/4Er9FKIDvCwlIK+MXZijCkrptTggErMZVHxaBG3pDGx99zrE0XlLFLtA/B
	0e77lts5+7pYbYcYoGFmiHH+azlR1/GqgwidThI0D8gXrffUsZ/kHweMNiw/9oZ8zy9hAv
	Ay9QJy49VkdV+FOSWX/ycXkSi46G87I=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774805639; a=rsa-sha256;
	cv=pass;
	b=Lo5/It2WlfuMR1IgNSWXOiiJMKXqHlb7ARijxVS9CCe5R1od+LB/7zEhSHZ+ATd7rcUkLy
	UXs+EDm8TK6tRLDEgwbMSmDvqpA/oTfauBasy+A3U+p60CDmHwFQQ0UCold9Of4ZOolyqJ
	BY702vKiGpa31z0GZjqizTneLSX/emU=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VU6WbQ7N;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-2c16cdf31cdso131554eec.3
        for <linux-mm@kvack.org>; Sun, 29 Mar 2026 10:33:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774805638; cv=none;
        d=google.com; s=arc-20240605;
        b=PUIk9ooQBG3HQeYmSFwTeRYvgqOGLul5k22FzjMmBsoyRQoamOhJvGqz8L9XHLZ1WW
         +0WMnkTPz3eMtM36ozdRLqO80I19Hyg2W1g4IoYlPptivPQ4MlzLoEoz7NxFq27hG7U2
         FKPv39hQGxtjt2zqYCMb19D2qrT4R6Cm1pukPiyNzrOLoIg0IfHS1UczvpiPLrdj45PK
         gSjr5YfrlquT0IHtB9q905QgBvEDpWdnN9MamXYEZSos158yPAKCNRdKpFRC/Q4SjnRq
         Dg6q+auguuhS+WiOGMz3b9k6lpy723rgsxF9Snb2aJHjuSxNQ6DePlP5NdJfT6XhNK7C
         zOnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QkCmTI7yYjAJjvmfpeVl++cohGyuqaJEN8ofoKb3dzU=;
        fh=odTcYtmP0HRbVHGc3eaxELjrLEOwT8Z64IOSVdetUB4=;
        b=Nelzsp8uSeb9yKcPsVV5odcSAW2+t0YWc3qrhkSMv5pofWZoaatc1enVGvfmzdft+G
         4IK7bbVhV4xwFe3nGWER7Qb45AgWCNi0WDGRwmmfEEbPnli1Nt9I0pOWq66s4P8ikwfZ
         WOq0mEEMskLfb5Fn+NLmm/xsxGA4eougki+tG1U8pKjxaSwLKK64beqp//keqVFIEJ18
         kB0HAw2NW83apgX5gkrRHTznNE26EGmjJcO03agAjrpkKyR283yiDynVLqK8hrbkNj0u
         ox4bHn5fgJ68X9cVxXpND5+bHNOpYioHQEP4dIX2APjl2cxbPK81uHgvd63LvRs2EyuN
         DY/w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774805638; x=1775410438; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QkCmTI7yYjAJjvmfpeVl++cohGyuqaJEN8ofoKb3dzU=;
        b=VU6WbQ7NitdJDlM5paZf8CU60PBNqfkIgaoGdG5C8My0vyAn1S0qC4siAOjz9woZ3V
         UMAytO3fF+vQB226B2zYkHV67IcWY0bY4tELVgumFRZAZuo84S223DR7BGuBovJgyFf0
         V4f89T+MKNWmxf8jVquAUKHF8YZfDcbR2r7nmDCIUVq2qDZuAHMDXdYmQqr7Cs0Cg8Dt
         bbPucV3geAJPOkiT86JzBwA/UekrRV4a8mG9R9iFxVm05oxFo5yBYn8/cHt6ZxaNFBGD
         QXFKutrzk4xyAE/Ii+gJAau8uXVFjvnCEw/7b7PjJyduUis/ShEpmwOVwtrUtdA7yWcH
         N3NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774805638; x=1775410438;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QkCmTI7yYjAJjvmfpeVl++cohGyuqaJEN8ofoKb3dzU=;
        b=GlKba4g0+YQRjuyIWhSI6KpGN41hCfatJu637du5jGMaE1hC/eesIpVUh5AozugH64
         f4c3W6ztRDgmjKlML5asDXoM0+knoDdYydQ1K6gsPlGt1xejIwtrAc9UX/ZWc/8B4V4W
         Vf0tANUk/lgY7chgcZgjWd9IOa39atCbo700X+ss8n3v/LryfaxAGEYOEnpaK1jg8MNq
         eXJxF05Tn6u9j2/7XDjJaNYi9lgUUsYp0TLTEQURTqns091WZVrZhPwXLBiRZ+XBaWLm
         Dr+ce66zkZEbpRgICa2OhmNu6TMmR5IcVMxvYsiZffFW1WJP1YZy95KWO0lECUuXAxFh
         s9IQ==
X-Forwarded-Encrypted: i=1; AJvYcCXK+MDcB4bCnoOTB5DTTGzxT8o7CIqh4hIRATu+ad/pwOaHoPX4Zy2cO+N4+Fjts16vOBy08igC4Q==@kvack.org
X-Gm-Message-State: AOJu0YwM6JWKjjrhKyDemnsIziWMkh6NGsz1DxffyAzHBZXdS5DHf/Qz
	ePWb1Z2ElHLDQl9L285S7RkRsgXYaHMUo+Eg7MhzVwBfRMpoSeiL7CJBcDU+bhinblsgzMNNuzf
	H1LoO7CT8XTorSJBgG3l9zFQsLhhzN7Q=
X-Gm-Gg: ATEYQzzcn0g5WAR5+WDahdlhXZttL/RZaOFomruo9D3cxkQpxcYfa0IdGB/SSZ/cetc
	o6UhWDRlQt3B5HSy0+h4wfY2NnyreApBDQy51uzH1xRYoAaYckYQ6dnBPQ8iukWLXjcSgBnPE1r
	wFGtdFSdF2/cbPuVb8oJ3wizRI79hVZtxbPSmhkbY9nUIVtN04abbOKRM2rS6DdVVBshp/ENv7g
	h9+VIkdQRsklIasoT3pe9K+awKbQSnsna0eebk1aCgZnzmh/CAsGqRO7YudeiEpPsmim4SyL1xQ
	U53X9vLKfbrIMkas4IRjUaM7zWPerxTTxaDJGWxF3cTQzmoEhr5wvrYmdrRQ4HBb90fZm84HInQ
	8ENT+RMjguQD/Lm89QL+LC54=
X-Received: by 2002:a05:7301:129b:b0:2c1:7ca:cec2 with SMTP id
 5a478bee46e88-2c185f3463bmr2051760eec.8.1774805637680; Sun, 29 Mar 2026
 10:33:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260203-inline-helpers-v2-0-beb8547a03c9@google.com>
In-Reply-To: <20260203-inline-helpers-v2-0-beb8547a03c9@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 29 Mar 2026 19:33:45 +0200
X-Gm-Features: AQROBzAbWz3xOUBnSqR2d9NqgOZyOCJXfUW2zEO1m7L8IHXJSZ_QeR_z2lJXCRY
Message-ID: <CANiq72=ns52NksGEj-5kBCkD0RxH12wKawr2pH_QvHshSsz6Kw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Nicolas Schier <nicolas.schier@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	Matthew Maurer <mmaurer@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 13102180005
X-Stat-Signature: cfrdtqy9pbd18znng9oqobtfx13hci5o
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774805638-165730
X-HE-Meta: U2FsdGVkX1+S0qFm3vCvWDXuCvxKLO5advk1lrSxNozkzyc4oPrxDXe6LTvZWAUiuEXSq7fhaRaPaem56fP2Yy6vlZeOuaUaLGMRoQuTUYf3Wr4LsPaQ2s1Mb+nJAWFuq1YZj7mJ4/u2jbyic/qGx04/AdDIrBZZPvyS662nyh7yPGlMSrLjm0EtW58yc53xwuX++Z7P3NoszmwpLTWmXKgkJVEuTTXp3B5gQqeJ9YsxTpxGboWNf/rgLVipV3PXW/zFMAU08W6AqZtRgi4Pk6oVhAZWSxjG/G8VWZN/dr4Ewswr9AAyUsGyVOHrSc9nmSJBjFsBKwX7vja24R+wREJUgGUqFotO87R0Uk3W/Iu5Y6R7rsihXlzeKzEiCC5FYDwoxOfiM5+1BtoAa1ZN8+NhltMBiwjDgX8FvpP3Tyqh8CNv6ieVVjlLNGYSMJioH91/zJNb1jPPtPDai+HSmsJMjCaeDf188bXHTxttls0lvv1mm057nbGNFWrrjTmT2tsTWasfMz5HN6IgCdouuATBkxyZi7ul2M9lJSJ0GuAvGZ0Tu+XdesnfT8FyDf5HmKOHbcuW0FW3AY7vrtqKNMpjro9FmZtoIy0g+F84H4LRsWLCvQesAoq8vHDXRTdXiydavaIY/OGX0CD8+IQ37vRZzfS+qJzA7Z5E/akIUyIxMuwz28kQlbxOm6YYvCwa0u3HNhHUt+WY2o5Yh8uYMhF8zaaiyBcwMyWEdL3syfx8X5vdj4nAedJS/KEPb1VuLHJEVexP0VLbN/NI8kn7nP3WieFXXGYdjsOb8m7lUyHi3bIcQnMFGMBm4IQLtc7nhzy5PUYVvgkavpe/p8UubjJvG6lKIPPK8OtCSt588TrLP9oj3pNVN16ZYIy3SOv0cOOEqwNmzheEo6G7E6fZR24vW8DpqV/owrvWoEPWqwn9WtnEqCwt8QOpkhLlM5nYCv4V5aHNzcZdPUCnsgK
 X47MHaRQ
 Es3zFLQIoas5Lpe0kc9MV1nCQ8/Jedo0LgOeDKhANzOsQppgLIiWYkvOZdyUjBuAqME86E71huj5gg5NqX7V+XVV0phXAMF6+7luoVgSNFkNAmNkNs0+iByx/YZrDDkpGD4GcQp/tDetomgpLY3sxY21/mkqsE0tketGw97g+8ZviHd7q12hsSTpqlZM6Z6mVw0SnBqM6CuC43i5sN2LIq9LBe5wkXd8RV+I9Jtual1JacQo5vzm3lzjTUNrM9YqU6BJkVW9qBGqeRCi5P+kZxo0iqFNbWtwb6P1J1SeypFJMWeGQoe7LfRid0ho9fQHkgAyWzrH4a9j+SpOQ5HRyhMMpqlCeaUQpYH/XoxTRoPTh744B4+4zhBKnSC8tea6o7AnBECkaAsuljtptAvFPGYWkcpxugDMhwXljhlQdCwkhApJQoWUCMjtwfZM56veEgYkU99SFT7jhgSjf+U2/E88vZqy9i4Jg+OrHiYTIugV+7IS9c0d9AzKNBTPgZ3YzEiU4TCJ6SblNRfOy3wbFzvaaeqQqQCjRpUaG4DQaWFIewF+akjh0hwLFNCzc5rnd1DaRNyhkAbuhois9Gjkn/i4+nA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 3, 2026 at 12:34=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> w=
rote:
>
> Currently the only way for Rust code to call a static inline function is
> to go through a helper in rust/helpers/. This introduces performance
> costs due to additional function calls and also clutters backtraces and
> flame graphs with helper symbols.
>
> To get rid of these helper symbols, provide functionality to inline
> helpers into Rust using llvm-link. This option complements full LTO, by
> being much cheaper and avoiding incompatibility with BTF.

Applied to `rust-next` -- thanks everyone!

    [ Fixed typo. - Miguel ]

    [ Andreas writes:

        For the rnull driver, enabling helper inlining with this patch
        gives an average speedup of 2% over the set of 120 workloads that
        we publish on [2].

        Link: https://rust-for-linux.com/null-block-driver [2]

      This series also uncovered a pre-existing UB instance thanks to an
      `objtool` warning which I noticed while testing the series (details
      in the mailing list).

          - Miguel ]

    [ Some changes, apart from the rebase:

      - Added "(EXPERIMENTAL)" to Kconfig as the commit mentions.

      - Added `depends on ARM64 || X86_64` and `!UML` for now, since this i=
s
        experimental, other architectures may require other changes (e.g.
        the issues I mentioned in the mailing list for ARM and UML) and the=
y
        are not really tested so far. So let arch maintainers pick this up
        if they think it is worth it.

      - Gated the `cmd_ld_single` step also into the new mode, which also
        means that any possible future `objcopy` step is done after the
        translation, as expected.

      - Added `.gitignore` for `.bc` with exception for existing script.

      - Added `part-of-*` for helpers bitcode files as discussed, and
        dropped `$(if $(filter %_module.bc,$@),-DMODULE)` since `-DMODULE`
        is already there (would be duplicated otherwise).

      - Moved `LLVM_LINK` to keep binutils list alphabetized.

      - Fixed typo in title.

      - Dropped second `cmd_ld_single` commit message paragraph.

          - Miguel ]

...to boldly go where no Rust build has gone before.

Cheers,
Miguel


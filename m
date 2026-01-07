Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACAEFCFD62E
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 13:42:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 119356B0093; Wed,  7 Jan 2026 08:42:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09D966B0095; Wed,  7 Jan 2026 08:42:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB6D26B0096; Wed,  7 Jan 2026 08:42:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D80336B0093
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 08:42:42 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7AFE81A0317
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 13:42:42 +0000 (UTC)
X-FDA: 84305282964.29.C1C37B6
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id 65DA5180003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 13:42:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ddNOvFUN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=aliceryhl@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767793360; a=rsa-sha256;
	cv=none;
	b=Q2tRAp3WpWH+hNuEvpXFgWQGUSE1xr57qWBTFjsaBYoJ7EQqKswc6/bE6xDkHcjRu2OuYw
	XoVOcnQ3UJ7FVtlIeFEMgYswHEqYddbMQAMKijC0vmquKO/4b1NlMDssOZzNzlkj3ezijk
	ZTEU7f0GfJ1GAjgfPEJTozl8oM+6zao=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ddNOvFUN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=aliceryhl@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767793360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VuezIgzsAyyNB5F641/r8/tOCfKBUN9xZVmivfP98JU=;
	b=nOGHNIj3UyCN8x/ujZqpGYpOhaxWVGFY2sGzYYJ5XZiLE+xE/q4l3U7SKoOfIHPA5gfm2x
	yNlFmzIpP1bSXTwW0LmSng1R325OTxMrnS9WDaB6sXoWG1EROlQspkezitFU5+k2gc8nU9
	y7eHxzRWiHYipZUqRd9BHOegbFrb9Kw=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-42fb4eeb482so1132749f8f.0
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 05:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767793359; x=1768398159; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VuezIgzsAyyNB5F641/r8/tOCfKBUN9xZVmivfP98JU=;
        b=ddNOvFUNVaw2WbdfCujjJTI7smg/YUf0C54SUjngTWSwXMfnmlFWkw51ho651ZBi0T
         KrPJFbbc+sU5aKqfzpjvyoaSpBUhAI0RFtqn1ltyKvNsq5O7fgokkx2Z9yVbQrFDt0lq
         WISkzdYyRpg4CVStgnyTi/WmiMM23eWMoO3gkNlbidGOOG/eQnLYHiM4zTAqjnd3GYwv
         CneKZ65wcrZZod2Ug4UrNz2n4UCvtEFJoPZ+Uq93o/X6YGqbMs5zEMPwClr8Y18B2bKp
         HtHqxqjILSlbbcyq69aUwxRa7iuN+OpUpZqMcrf3f74nqnQI6bmGLw+cQE2pqODzEEhz
         UhzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767793359; x=1768398159;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VuezIgzsAyyNB5F641/r8/tOCfKBUN9xZVmivfP98JU=;
        b=cD2OZW77g/KNbE0P/zX/o4lmBIo9n+aLmizQYZS9LTWzSijVJwAMb9Ayttpxsa2XLS
         FEIY8q8A/glP107nJ2n/IXAb9NXOfblQvm0BF0devGmWWlsUfQe1pip0IIrxOg04iFC1
         wrILgiLXBTJ7OAD+YiMlmFRaaObpJqVJliMhUSHBn/D1S+qDAg3SXr3rmkBl6SAslKw7
         48/lRAzxrAIv7426udhdWdr4uegnfYtSVhLi/p/3Wa6oFCU03U0ZIBvXkEZLXpooc0uE
         9gDbh6XUsRoBRJQfhZFHfPFnTCrY/43uGaOYYuq2hwAjMwr9OAtNq4ruTluITprGPd4h
         1bog==
X-Forwarded-Encrypted: i=1; AJvYcCVuHpP3w06jNkWvBLT4wqxZ1TSfUkskgzB0iaBoNJpItOYS3nrC+GKbUCz9Jupfy6YxSO/Yfp3HpA==@kvack.org
X-Gm-Message-State: AOJu0YxL77YvqmBdLYPXYqwhLB1KXEQ7FZFFco/d2bfulgTu70F+QwUu
	Y428N2bnfIOBukQjJF8xfAyjkHynL+W61f0+PoYAzwaXoNWmxCpopXXUqaIJR3Vu3MT7/p4QQ7U
	2CDhL1b37Ma56kCpNRdwuhGq0ONGRP7czIbZxBNNV
X-Gm-Gg: AY/fxX5t13B9toxmZ0LHy8wO1pRg3NTlbJjDH6aal2+ZPnwweWsH+KuxMTIe+ZIocOi
	tRKb7S3U2Tx6YoZRynSuK7UvtFn1q6HG+t5rfMj2dXIDPGa8E42eGfEMXVjBHow9kvRat/OP+FG
	iOR9G0ihWJpwpiLi5ORGcgspp8Dri0SXwgvcaOGLSEfHLrh2vEsAJPNq/r/vEuP8O2E1LN7ukzw
	83sVEgauBie7kHrrtib//WWTQbO073mW9UzyGxdHVDHZEGIFUHw/d/hosZ9RfvSIjLuiPdT1vi9
	N2OitXqEISsQEmhIc9dcgpYYKhFuleR+50B+Qrk01V4k9pbpaw/Qy0kR1Q==
X-Google-Smtp-Source: AGHT+IEAUc1mXQn7QPlaWNlhB+oC5uC/VKZi1CsDAujRYSITqdy4Y0I5rdAfjg0XLN3IVv+rgZqfa1hd3+1gv9RykyI=
X-Received: by 2002:a05:6000:4301:b0:42b:5592:ebe6 with SMTP id
 ffacd0b85a97d-432c32f701cmr2574852f8f.0.1767793358358; Wed, 07 Jan 2026
 05:42:38 -0800 (PST)
MIME-Version: 1.0
References: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
 <87y0m9har9.fsf@t14s.mail-host-address-is-not-set> <QViERQV7XT0BjTfSSyP6vzQc4AYxosyF5TEZ5kRu8AVWjmGCP_5n5V2AV2hjqVza8-jvzyquH3JLJA1zvbRD9w==@protonmail.internalid>
 <20260107123528.GF2393663@noisy.programming.kicks-ass.net>
 <87sechh8id.fsf@t14s.mail-host-address-is-not-set> <un386uEr3TEFzLpGCdZg_Tzm63zO7Ze6IZN16Cz79EfWmEI_hZXbBvhG2enZmUXJ6DUnCMNm7QIz-agEYIDr9A==@protonmail.internalid>
 <20260107131822.GD3707837@noisy.programming.kicks-ass.net> <87pl7lh77v.fsf@t14s.mail-host-address-is-not-set>
In-Reply-To: <87pl7lh77v.fsf@t14s.mail-host-address-is-not-set>
From: Alice Ryhl <aliceryhl@google.com>
Date: Wed, 7 Jan 2026 14:42:25 +0100
X-Gm-Features: AQt7F2pAZcR9-cuXntjPdly3bLnSH5zqd4_0Qf_i4GvgVh-5nOmI2NH4hmtXZLU
Message-ID: <CAH5fLgjmjjroRf-eU+4UrTPeq3HJ7QoWoCimBW-Occf_f22ARw@mail.gmail.com>
Subject: Re: [PATCH 0/4] Inline helpers into Rust without full LTO
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Nicolas Schier <nicolas.schier@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	nouveau@lists.freedesktop.org, Matthew Maurer <mmaurer@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 65DA5180003
X-Rspamd-Server: rspam10
X-Stat-Signature: 8druhgbp1dfu56nx16yz45gadfeb964e
X-HE-Tag: 1767793360-825591
X-HE-Meta: U2FsdGVkX1+a54/2BaVytwt5Ea7/JZY+5HqIl9mbHgqtveDIGlj6nYBi1O1UgycVg6b3UOlWFIPZ/8iq5o4Uo3dWia/kmKKLfM6Bu3tcASsI6cnQ/7qunjNS7sdtzohiTBcRQKfi0zFs/teDWmYEiFUDAIA4zVwXbYp2/ryMOaUUXwS7m2O5jY9QzoTUD174FLUq0VgDuAjd6E6bKNfvffZ5dT83g9gQ2MWdmEd4S/Uze60zphUv/885wBtIicOrlNtRavsovFNSCSG6Ha32LFI+cJDjT4djMroLOpKOshTWG4/OPVCgwR4Bq33yOP4wm5fQR4GxiRkd+P+7LhrESaYrjOqbqZBzi8GPH/MSIq9/yhGRRNi5t9PHL97v8Pfq4fdrge75bt8MDh6sx8g/tDZOByfty3bVNriQhYcnbNRiBxTozGcL+Jg268Qxmp8WSqrufqTzMm5DUrEHSoPgU9/+yDIZCysFPZKZnReguTt01yJQL55Jg2nWg9BSK27L/f14OaWipSl5kmHZh3VvlNeZ3DLQHO/LcmaBZ3nS4DnAox+8AaDYt/bkMpMd32JD9MqpTIEM+AG/S61kZlGLogVhUjjguMcgb3HX5RAHdUfPkMHD1cL+jY1guYC0K5Z3i5yeEDUk3ivhuPyOPi4+qoinUPvZ8vauV93ptuQUPPkec+xzDJysKw3pn14L4nSOi9UbDJoxXAiMP0jNb/uomegHsxv1D8vRi2chGO1/9Hn9WhCELUlehjL8SzdPk/aBE1EQFCy/PU/19DQ2XhoyT7yIQTn/2pOSAfXG/+S8YWCOsapRsSwkcu7MDYPA9seNpnDTrgQGGLxK7BT/J5SyTy3erux+VX0C8pwmkeauQH1rYOcSr5Wl2aSSj6RFsPve2mnZx7xYQvMPuUzPLQ0J/BXWes3RmjGGlkS7Q0hhIaQ3rusKypCipk21LCebgRucnmMTJaDXj+q+BpGPBLc
 PR7MpJE0
 x13RANtMlIotTzvGlONrqnwB6AuwRHZLZqnxaqNWrqZnKGakXQSGKxWCVyF/HvXifJ7BxYNPu80zxKge9Itjtxre/PLucBRrYx9oh5TvGKtOUXZ4ptM2UBaqVDVJUqHxH73pe345Atuvp10I8mXEEA9NjudMjA98wOWAnZccZFeU8o/y2OYwdpbrHIm1B5esJj6fhWMNgMRu3/RqDasEmoHRKbj1Im9HgEx0Yg66OCPw78gXxjEgEadT5IXn8eLFS+ARGT0/+aRtLNpbxZoLKJkRhp1KKWqSrxTgh171ZrfYZ4LO5UgmhlQd1wS4Td1J24Fg4RekCQLCf78XkMHdq0UtROD5V74qHUzXKk7D5sMJdknkoInzGnYCPQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 7, 2026 at 2:40=E2=80=AFPM Andreas Hindborg <a.hindborg@kernel.=
org> wrote:
>
> "Peter Zijlstra" <peterz@infradead.org> writes:
>
> > On Wed, Jan 07, 2026 at 02:12:10PM +0100, Andreas Hindborg wrote:
> >> "Peter Zijlstra" <peterz@infradead.org> writes:
> >>
> >> > On Wed, Jan 07, 2026 at 01:23:38PM +0100, Andreas Hindborg wrote:
> >> >> Hi Alice,
> >> >>
> >> >> Alice Ryhl <aliceryhl@google.com> writes:
> >> >>
> >> >> > Currently the only way for Rust code to call a static inline func=
tion is
> >> >> > to go through a helper in rust/helpers/. This introduces performa=
nce
> >> >> > costs due to additional function calls and also clutters backtrac=
es and
> >> >> > flame graphs with helper symbols.
> >> >> >
> >> >> > To get rid of these helper symbols, provide functionality to inli=
ne
> >> >> > helpers into Rust using llvm-link. This option complements full L=
TO, by
> >> >> > being much cheaper and avoiding incompatibility with BTF.
> >> >> >
> >> >> > I ran a microbenchmark showing the benefit of this. All the bench=
mark
> >> >> > does is call refcount_inc() in a loop. This was chosen since refc=
ounting
> >> >> > is quite hot in Binder. The results are that Rust spends 6.35 ns =
per
> >> >> > call vs 5.73 ns per call in C. When enabling this option, the two
> >> >> > languages become equally fast, and disassembly confirms the exact=
 same
> >> >> > machine code is used (in particular there is no call to
> >> >> > rust_helper_refcount_inc). Benchmarking Binder also results in an
> >> >> > improvement from this change.
> >> >> >
> >> >> > This patch is complementary to:
> >> >> > https://lore.kernel.org/all/20251202-define-rust-helper-v1-0-a2e1=
3cbc17a6@google.com/
> >> >> >
> >> >> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> >> >>
> >> >> I get the following modpost errors when building with this applied =
on top
> >> >> of v6.19-rc4:
> >> >>
> >> >> ERROR: modpost: "__SCK__WARN_trap" [drivers/gpu/drm/nova/nova.ko] u=
ndefined!
> >> >> ERROR: modpost: "__SCK__WARN_trap" [drivers/gpu/nova-core/nova_core=
.ko] undefined!
> >> >> ERROR: modpost: "__SCK__WARN_trap" [drivers/block/rnull/rnull_mod.k=
o] undefined!
> >> >> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_minimal.ko] u=
ndefined!
> >> >> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_misc_device.k=
o] undefined!
> >> >> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_print.ko] und=
efined!
> >> >> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_dma.ko] undef=
ined!
> >> >> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_driver_pci.ko=
] undefined!
> >> >> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_driver_platfo=
rm.ko] undefined!
> >> >> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_driver_faux.k=
o] undefined!
> >> >
> >> > Looks like it used the wrong static_call_mod() version, was MODULE
> >> > defined?
> >>
> >> CONFIG_MODULES=3Dy, yes
> >>
> >> I built without the patch first, then applied the series, enabled the
> >> option via menuconfig and ran the build. I thought maybe some dependen=
cy
> >> check is messed up so I retried the build from a clean state. Same
> >> result.
> >
> > No, I mean -DMODULE. Note how the quiet_cmd_bindgen target has -DMODULE=
,
> > but the new quiet_cmd_rust_helper target does not.
>
> Ah, that did the trick, thanks!
>
>   diff --git a/rust/Makefile b/rust/Makefile
>   index 5365d53b6cf96..08d3dc1038cf5 100644
>   --- a/rust/Makefile
>   +++ b/rust/Makefile
>   @@ -483,7 +483,7 @@ $(obj)/bindings/bindings_helpers_generated.rs: $(sr=
c)/helpers/helpers.c FORCE
>
>   quiet_cmd_rust_helper =3D HELPER  $@
>         cmd_rust_helper =3D \
>   -     $(CC) $(filter-out $(CFLAGS_REMOVE_helpers/helpers.o), $(c_flags)=
) -c -g0 $< -emit-llvm -o $@
>   +     $(CC) $(filter-out $(CFLAGS_REMOVE_helpers/helpers.o), $(c_flags)=
) -DMODULE -c -g0 $< -emit-llvm -o $@
>
>   $(obj)/helpers/helpers.bc: $(obj)/helpers/helpers.c FORCE
>     +$(call if_changed_dep,rust_helper)
>
> Is -DMOUDLE always appropriate to pass to the helpers? The helpers are
> also inlined into non module code.

With this option, helpers.bc gets linked into every Rust object file
separately (and symbols are internalized). We might want a separate
.bc file depending on whether the Rust object files is part of the
core kernel or a .ko file.

Alice


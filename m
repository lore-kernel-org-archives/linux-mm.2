Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8927FD20682
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 13:03:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7C4A6B0029; Thu,  4 Dec 2025 08:03:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E522F6B002A; Thu,  4 Dec 2025 08:03:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8F7A6B002B; Thu,  4 Dec 2025 08:03:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C7B6D6B0029
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 08:03:39 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7C2FC12F96A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 13:03:39 +0000 (UTC)
X-FDA: 84181805358.22.D12DFA4
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8431A160008
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 13:03:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=T90G3V1L;
	spf=pass (imf08.hostedemail.com: domain of 3p4YxaQkKCMoq1ysu7Ex1w44w1u.s421y3AD-220Bqs0.47w@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3p4YxaQkKCMoq1ysu7Ex1w44w1u.s421y3AD-220Bqs0.47w@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764853417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XHv3hl5kxLsYbFyLkQO+405gPeY3rXV12cSRgU/67FU=;
	b=vnOK3OfU6uu2kCZ06pWR4T8+g6KYIWc/yPvD/r65i1I7X+ubnYCcilJXjo1FAuQD6eaC26
	koWshZWIjJqeKfgvxU3No5w2JqzKCELWh3LckQ80gB+ZaWFf0BZrDJ3QAefWyZzj6kVMaE
	K38uyvV0AB/m4Wfec0ElfedyJOTsJs8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=T90G3V1L;
	spf=pass (imf08.hostedemail.com: domain of 3p4YxaQkKCMoq1ysu7Ex1w44w1u.s421y3AD-220Bqs0.47w@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3p4YxaQkKCMoq1ysu7Ex1w44w1u.s421y3AD-220Bqs0.47w@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764853417; a=rsa-sha256;
	cv=none;
	b=139eGykpD+cbpF3NvQF8qhAGH6NLVBmApVgXJXbfdfOZncPoI+qpk31hafFJHKpeyErIPm
	9f2ZyMMn9CHS/UdV2Z6lWN5d47mgsI2BqJZQuI0LXz3qrbzbR2kntlRrU48Eqr+jF3LaLL
	BWC8rgsofFlNlom7b5EfrTc6QkNSM+A=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477563a0c75so5220305e9.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 05:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764853416; x=1765458216; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XHv3hl5kxLsYbFyLkQO+405gPeY3rXV12cSRgU/67FU=;
        b=T90G3V1L6Ky2i6OsFMPGfBpmtqHXE0cD6QxbVGSXcRCWxk13PFa2tHAL820Pg4QTYr
         5woaieSoM2ckcs/l3z3g8kSr4y0YjdYWgKLVibM/At+kbjCHv/XHOyZco8Zb5Y4bPQbf
         HRdFwfO20pNUUSMSY3z9kDbFDVO2KrfSWTCN2GXMJ1vUlbwSx3YdKd85XjjutM+IKt/t
         2kQlaEtXlRlX5J8mQkMx7PbRofdC2YXP2rB76QXVFnXfPvEmYvtM14m+Q8GvuWfwa1ww
         WwjOlu8DQ+kaFJ+CyuisGBLXAjnn7qaqJoUPrr44bSds5qhDPnB3Ld1UMq0r/ctLL8YN
         kj9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764853416; x=1765458216;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XHv3hl5kxLsYbFyLkQO+405gPeY3rXV12cSRgU/67FU=;
        b=ET+aR/iWbpnL9IBRcZ1DpUdRRCYzu6LJCy7uVSwrhtddgnH9dtDphUW1rh5qSYO7W6
         aI1cybVnK2I9v5RcpFpLflAZhopCJe1u6Frea1jb6AqbuCd0D5YF7X+WHPnTG+p7yEJe
         FrvPBkFNyG9mAly9TKXXn4I2zb0zHlp3/Pnkla/Nr3laaIF5bwDPT8e9cbnT/NthYATr
         EqzR4D7xKlQ2h6+0qOahu7e5F9u6qgPZLGGVXimGhXqYDJktd/ObDtkasQvHM3mmXt3k
         Lfj97z21ecfQTV1fL8jHzvESeM+7183jifqXv9W1S+Tteexmg9zszBCec64WoRaoHE07
         XWpw==
X-Forwarded-Encrypted: i=1; AJvYcCUH1Vxp4YJfzghKD6K3QgWnUjj+hZ4vQ4b7+0V2S6omkLlb7jbVVYolkQ8q9iWUJrdQxvhOPw/xFQ==@kvack.org
X-Gm-Message-State: AOJu0YysfMfOxqCDrBwN41n5aRKcaKUmvhwpFBm82f3C0ymlpDps6bem
	8ntU/8WsK00vNL46Jbh9hRK5DLMHdrt78VLgUx3oSVTBI2FGJvHygbi5Pb2TjHRevd7pcREZgf2
	nLARZHsHVkOtpMF1c0A==
X-Google-Smtp-Source: AGHT+IHesTuadwDk2buktyr5KdT759hnUgQEo1wC+McdN7/pwalBTRVnkgrSBeIn+Q+0wMXJFuvSYefcIW+twrM=
X-Received: from wmlu6.prod.google.com ([2002:a05:600c:2106:b0:477:5c35:1b95])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5246:b0:477:641a:1402 with SMTP id 5b1f17b1804b1-4792f244c5fmr28025045e9.4.1764853415686;
 Thu, 04 Dec 2025 05:03:35 -0800 (PST)
Date: Thu, 4 Dec 2025 13:03:34 +0000
In-Reply-To: <20251204123906.GL2528459@noisy.programming.kicks-ass.net>
Mime-Version: 1.0
References: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
 <20251202-inline-helpers-v1-4-879dae33a66a@google.com> <20251204100725.GF2528459@noisy.programming.kicks-ass.net>
 <aTFhFXCqvy7nmDOp@google.com> <20251204111124.GJ2528459@noisy.programming.kicks-ass.net>
 <CANiq72=r+Fmu0uuNF=6x36GWWQZGZk9gApnMZxakJavviwG+ug@mail.gmail.com> <20251204123906.GL2528459@noisy.programming.kicks-ass.net>
Message-ID: <aTGGpsbIYm1tXMDY@google.com>
Subject: Re: [PATCH 4/4] build: rust: provide an option to inline C helpers
 into Rust
From: Alice Ryhl <aliceryhl@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Antoni Boucher <bouanto@zoho.com>, 
	"Emilio Cobos =?utf-8?Q?=C3=81lvarez?=" <emilio@crisal.io>, Arthur Cohen <arthur.cohen@embecosm.com>, 
	Gary Guo <gary@garyguo.net>, Josh Triplett <josh@joshtriplett.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Nicolas Schier <nicolas.schier@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	nouveau@lists.freedesktop.org, Matthew Maurer <mmaurer@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8431A160008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ft1emno6w9n1ykiy3ihwdsggdq9oohtp
X-HE-Tag: 1764853417-407042
X-HE-Meta: U2FsdGVkX182AcfW65yatgIgfAPon5mBsqYPMGc5pK+P2qfebs+IEwMauz58RUCRP7CNkqBhfTiiHzNEImIyYOp2CfYJPHOAEvjnjOlIoRTAcCCJzSPFOmd7JSl7a4K3tPbfH/VEUIZsxijidhPPZy04KkStZB95Cm/7UoHrlP7nRkXx8v2jJEfv2Ph726YLCBWtjCHNcOf/iB7UM14BUlcAHjwrpP0byZfQpatRF4aQiC1L++slQvksX1aO5b6tAJW2O6/fCED35K7m8oj4zfA4YuVxiXVS2AZ6j0b/0TkFlOqByGmltAMsd1V3PakZSwnTH2I+3XnL8eQ+yjqrMHEqwGMocbXpyc/GP2l8XV2TC99MAtlBEuJRZxVDl6vNDF/TgWy0nVLd4Q3wWpbsJ/myli/ThGdpk8Tjf0ACL2ZKB0DyDntgD3/VIc7YG0B2ZDG5q7bykSCMCA7+cI/EjXuHYV1vVfwA/QvskraqiomCIV5F/qkht5J5w6IC92trTjAzGDdMw3ExjjHmYqW04GaOwn9vpBjpAngf3VT1oFqL2z8QlgAAstKxZyY+qZd33y28w/O2sRqA9GulByy15oxQtzKeaIWtp3E7fZ3mvDQBphGu7wL8k1xZIdjFleLUAxqDZI9RHpSJth7jAtzMvbR+sGAPuZoSAcml4vLaavnNRTlCrojlvhObPDwrLA645KVcC+KRAIUY2tx2P/jdYSviwM0L6Y1sSEDWkvi0Vv/4QjqZELfGdxPi4fY+siu+oVXp1xMxZ3V6BeRe1Jjf5lznw1TMFeTfThx9iYK3xh3roYxGweo15fhWwRgujKtIBjelk1lIx8puYrRUIc7o9jIZjuwPH4qxcmB+TL03ZMedQGb+9m1ILQV3OUPLQb5hzyYA3IPVnBYjenOwcGdPfI/yTISiFKVN/l1zqRBWFkQitbmlsKTqTYtYhBGSwKmPzkdyuKHn0JD4RyQGuQ+
 Aj7/NlYG
 NJmLIB3hIa/68AqdIi/DOmRL5s2UQdRkcgEWK8Qhxo4A80qw1qyn/A3t8mpH4SIjOr7itgmIGppAevYHnV4lrCGHPEQCCTMnIkkaNfr9gzfItFwJ+G+14oDcPPxzZFdARtjnph3fExKAjHFTu6C/PJlgMqKOSPvKZKWTPAHsosMZUSiLNkgT1ptsb4YPPm7XjdHzu56F64AHKhCEy/08TjLPHnNKDupyPAOA+IvH2KWwcjVIDhCnzpbdJ/wuBq9akMUQrdXfAB/h2J1eG1IEWbbD9uGCEl29JaX2sAt7aozmO+CmAtawtIe7Mtg8uS9H0Zx8AnqgMgmkDZekOMDVkVdAxGuiwClVqDFXXS1StTrvGPpAwSRyhfUdbck8+AC8s9jEAItm9+tvNl8fml6kWz0uUqXJbesBMYnS7JAFwQkXFXtUgJHcGTTRNklJmKZVjpX095hE+lq3OReY5qKH/am0lxkyZIvrL6HjRNaFJKRiFI6l+45iUp3Z+WQXI9bCO/sei9/YEe5ErW5eY/9ceVrmXCH7ghiK8TIf1P2XPTLQMIJt4Cc0usuYvYeLW/i77xnfr3ebMlY7utuOoE8pJURnMnj0SJB4/WSo7fFouYKa8ZN7A0KQTKphuAK7Q74U4pKwa5JJUzHbQnb6SU7EzVpfpiEgr6wWTwolG5e10ifYMhuZS870XnkR2Gfogrc0cqLGPBh+hY2REHrvXAxYcUxCKfzeMS1fQaIFmP8uPz2YOEuU9EnDR96Zn9fYcKW8mBC1XX9OxJ3VyJLo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 04, 2025 at 01:39:06PM +0100, Peter Zijlstra wrote:
> On Thu, Dec 04, 2025 at 12:57:31PM +0100, Miguel Ojeda wrote:
> > On Thu, Dec 4, 2025 at 12:11=E2=80=AFPM Peter Zijlstra <peterz@infradea=
d.org> wrote:
> > >
> > > Right. Earlier I also proposed using libclang to parse the C header a=
nd
> > > inject that. This might be a little simpler, in that..
> >=20
> > Yeah, that would be closer to the `bindgen` route in that `libclang`
> > gets already involved.
> >=20
> > > ... if you build rustc against libclang they are necessarily from the
> > > same LLVM build.
> >=20
> > So currently there are 3 "LLVMs" that get involved:
> >=20
> >   - The one Clang uses (in LLVM=3D1 builds).
>=20
> Well, being on Debian, I'm more likely to be using LLVM=3D-22 (or whateve=
r
> actual version is required, 22 just being the latest shipped by Debian
> at this point in time).
>=20
> >   - The one `rustc` uses (the LLVM backend).
> >   - The one `bindgen` uses (via libclang).
>=20
> These are not necessarily the same? That is, is not bindgen part of the
> rustc project and so would be built against the same LLVM?

Rustc and bindgen are both part of the Rust project, but they're two
different repos:
https://github.com/rust-lang/rust
https://github.com/rust-lang/rust-bindgen

Generally you need to ensure that bindgen matches clang. This ensures
that bindgen and clang agree on the interpretation of C headers.

> > If that is all done within `rustc` (so no `bindgen`), then there may
> > still be `rustc` vs. Clang mismatches, which are harder to resolve in
> > the Rust side at least (it is easier to pick another Clang version to
> > match).
> >=20
> > For those using builds from distros, that shouldn't be a problem.
> > Others using external `rustc` builds, e.g. from `rustup` (e.g. for
> > testing different Rust versions) it would be harder.
>=20
> Make rust part of LLVM and get them all built and distributed
> together... such that LLVM=3D-23 will get me a coherent set of tools.
>=20
> /me runs like crazeh ;-)

Maybe clang itself should have an option to emit Rust headers, taking
over the role of bindgen?

/me runs like crazeh ;-)

Alice


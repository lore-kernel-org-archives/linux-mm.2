Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF9E8D20682
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 13:15:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28D306B000D; Thu,  4 Dec 2025 08:15:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 217076B000E; Thu,  4 Dec 2025 08:15:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 105C66B002B; Thu,  4 Dec 2025 08:15:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F0B416B000D
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 08:15:38 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9270C130AAB
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 13:15:38 +0000 (UTC)
X-FDA: 84181835556.03.D0A5583
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf08.hostedemail.com (Postfix) with ESMTP id AD68316001E
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 13:15:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UeAfr6rg;
	spf=pass (imf08.hostedemail.com: domain of 3d4kxaQkKCKAALICERYHLGOOGLE.COMLINUX-MMKVACK.ORG@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3d4kxaQkKCKAALICERYHLGOOGLE.COMLINUX-MMKVACK.ORG@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764854136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wny4M191Yr6Td48Z53labtwrelyi+1dAudOVsu2AK4M=;
	b=sYDtksT3poyInzAG8uSWLj/rzAkjRwvgegUSM7NWWfJy3vlkj/f9IaL+QFyw/KPzR7u5h1
	LL2KLlGOGaGg3Pp8XqJaTaFXpPTV0WEL53xR42CFYShLCKRq4NU1iLAlRSvZbbK6NZUTTt
	eY79griBA3SXaEdX6H92akaX8jIBQFM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UeAfr6rg;
	spf=pass (imf08.hostedemail.com: domain of 3d4kxaQkKCKAALICERYHLGOOGLE.COMLINUX-MMKVACK.ORG@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3d4kxaQkKCKAALICERYHLGOOGLE.COMLINUX-MMKVACK.ORG@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764854136; a=rsa-sha256;
	cv=none;
	b=4HuGNxKDduzhMY4R6yEp7G2ekhOXgUX0416CO4+LOaaDjsU+BeT9sC9Ct+wyA1DPAJO/ZA
	+ULxZH4N2AfVY2R0Dq3qNBQSfZtM49opGHLXy0QyQH+1e5uiE9HhVSmj16On8aN9r+QwFe
	aTPcGsjhgYyrWNynhz36P3xrK323djg=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4779edba8f3so5976485e9.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 05:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764854135; x=1765458935; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wny4M191Yr6Td48Z53labtwrelyi+1dAudOVsu2AK4M=;
        b=UeAfr6rgCYQCpLcS1fETHjiQZrzFtm6eY6hHAJILeMNXnByDOpJzFnwl9dD8F0fbNg
         bxmftAwDDy4oI+zqCAfcfHIjUSKxVOvQnl6CihMKzmT+wyxYhxSYQIt9rFqZeeEHcBZ+
         O+mIMTzsZoQmCzusmGvBtaeBWCfqWnxzZn9ja6oPyxFkzMELMUz4vmpfV7aZaUf4WBfj
         hoasIkBcxUhKQHbaEO3zCJUJTWrMu4VS8SAQj9VC8dSXjVZlnhXfwlUbAJ1KbZeJ2v3n
         ejlsj7+5OioS69pd3li7SGE6zfWBhGYycw0y1ygqoE0G+bENwtwk9XlXnMnbSwkoL9U0
         K06g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764854135; x=1765458935;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Wny4M191Yr6Td48Z53labtwrelyi+1dAudOVsu2AK4M=;
        b=pLG71ZqmUkShZWXyy5h32vjemZebsoVia8Mu+awpa92yyx3qnBjvRBlg46sOOfBeUM
         uY6/VzOx3nD+NmH0ol0EZ/AcLPZMYzF7NrsScuS3X+mdZ8p0dWvJbUuxHJEAnF/17S7d
         ri5O0fjCqa/Vrpb+MX+qIbcC7A4LHns0mj168M+Pzx3Obf/SlnDtSlVnlOgI3lNjFsic
         aqCdsrpEHlbewCNAEFY3C4fborDFr0uCYRU7jMaHR7S6IUbYO863Od+rOOJ6Kuap6EnV
         TiabyTB94/XSq6m305O4KElQsEw+04g3zzmYZb6VxPNCT4q2qzr3KP9UILntEbJYNMTD
         6eWA==
X-Forwarded-Encrypted: i=1; AJvYcCUrAUcYXSUz8nsY5j9GP79MkFPnWlmOpuOh0tkESjdAqyulys03GEC7HemdqQhp4LDFIMntOPQUJQ==@kvack.org
X-Gm-Message-State: AOJu0Yx1tw+HE6oEbgC/9rGPi5iUpbxVGXLWI3AJwLoJGiGBe36KnnIS
	ferVXz6VBiadiWkLwrd3HVuhYlW+mXg+5T/GZWmluA0D4yv6uTJvRElbKnTNLp2MicMxGeKsDWZ
	oRBUbcZTdAanuzk0eAA==
X-Google-Smtp-Source: AGHT+IHhq1jpZSgsrG7+u70UeMI118GpL4lyrcZgSJfzAV0BpquOo2d1tIrYUXW40rz39aPBfrTMkT06vKIZZ8M=
X-Received: from wmbjj12.prod.google.com ([2002:a05:600c:6a0c:b0:470:fd92:351d])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e89:b0:477:55c9:c3ea with SMTP id 5b1f17b1804b1-4792af485a4mr64437335e9.35.1764854135213;
 Thu, 04 Dec 2025 05:15:35 -0800 (PST)
Date: Thu, 4 Dec 2025 13:15:34 +0000
In-Reply-To: <dd5856a8-e120-4884-8828-9d0c9edc60f0@crisal.io>
Mime-Version: 1.0
References: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
 <20251202-inline-helpers-v1-4-879dae33a66a@google.com> <20251204100725.GF2528459@noisy.programming.kicks-ass.net>
 <aTFhFXCqvy7nmDOp@google.com> <20251204111124.GJ2528459@noisy.programming.kicks-ass.net>
 <CANiq72=r+Fmu0uuNF=6x36GWWQZGZk9gApnMZxakJavviwG+ug@mail.gmail.com> <dd5856a8-e120-4884-8828-9d0c9edc60f0@crisal.io>
Message-ID: <aTGJdlwMRxGg2iZ1@google.com>
Subject: Re: [PATCH 4/4] build: rust: provide an option to inline C helpers
 into Rust
From: Alice Ryhl <aliceryhl@google.com>
To: "Emilio Cobos =?utf-8?Q?=C3=81lvarez?=" <emilio@crisal.io>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Antoni Boucher <bouanto@zoho.com>, Arthur Cohen <arthur.cohen@embecosm.com>, 
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
X-Rspamd-Queue-Id: AD68316001E
X-Rspamd-Server: rspam02
X-Stat-Signature: ccdqfcyz8yh7mhrti4kghrqdhap84df9
X-Rspam-User: 
X-HE-Tag: 1764854136-618251
X-HE-Meta: U2FsdGVkX1/k/eNzC9iFKKTJBEi3co1cW+woK60xgL5KdU9uOPZaNp+SB4xJUUXnSthHGBZ+/EbG31T5s213pZkaSvhCDIHAmViDRB9nAUWjHD6p+zq4ijh0doC+K4OdsYQAeZ8CuYpaAZ+cCI+18o2ytitU68RjoXa+sSEl8D//PqPHW8MBY3jSmQjBVhE8+drfoDgezm9bvB1apGYl+B1ugg86MfD5uwx70kmbFv3+pQagzEfHndkcA3LQs/rSN2qCTvngZJqEr24TZZyMDAtB6PH0mkndjxeP0NHV8G2qnccrvgX18EU+mqtQpWfLt4eX5HOqbikLu48LkbWal2qXUe41ejCO5z0c+pwZW7/9FCcVebcRQPsIUSbjXAVCvxPyB27hYG09i/k6RDjYP/HgFIaECu0efwPt/U7VsU2kpJzMF59j1fEWHN6ZUMFAS/hm0pMN+Vo401jqfdgVyxg7cb/YAb2uRVBArn4i74u89z8LA8xq1MyU/bKqWq1IZAaY0uVGSqK/pVtdq6c0TfS4zWXjJ3MazgglkZ5oXjKulWxyDhLMURegIV1RaHAsjTlP6Q6tN4vyMD/BCPqOcxDKtgBDk0Uem/83Hoiv8FLlpi/N78Dl9uXhdJ7yoXB7yXOXTDki/naFLo8VXroU7dO3679f4bR2DGyHtKzS/QBkrEKD6/8ExgzTO6/mV54UQPUHZFSd4uiQzshJoeQUN4M5UBzU56i4kCxhQfgk8UtXPDHuVWq3GbVmoGTnOcEbLKMdOq9dNgKZ7AfmHouvTdrSWTm1q9w42NfUfIzM+4BZpP1hNH4JxjQFUN7E1sE9nG1K9mCscxX7CiML2mULomw1wWQ9YS9VWMBRnPkxORi4q4RzSIA35vuVyMPGxpVZxVfVG3tqX/o37l3XACq+tfULdq3+21+oppW9BytODA7KqN+zfq1dS3Of36Lj9aAcEUh6+m6ilnufJqRxLza
 1AkYemtS
 2L9DYFZsUBXoZkOLAWBC4sy8qcKWekJcwARaXnHJjNxaY1uXH6GT7WaFl4fbYn7jcNdYQiBjWHnXv5/vR3WQhagY+m1kHu5dcXtv64pay3yAnVcW8J7b2v3oBozhs9oiUCwuO2cFRbCyzqkCVVp2TTuMBh9aR7Y+zIPGRsmNCBlXfvGIS9k6jXeUg00RJ9cIsdc7Zad3gC5tD3nEod8mYUp3n1UE9yos6c/mkmMG6P07Mid9D/ahGo8dm7AUKyL8pSgJKoFwwsXombKvJ7S1/NeV7nDyXMwQ88SXKnXB4iYkgho4RH71ImU5SPeGnkk6oGPsdmZfDIy6HawAgJLcBZoWdYO2nn1QVao3W31Dw6g9fH7Aix9HKw3tGGRdN4sqj3QFNaPpvm+l/4XScuWH+PkiQoBpFA0fnpPU0Z58jFViWxdAoYztPeSMBRcHsX6vo9T5MIPegtdXtXlOOrKLKcCiZoqb/U78WG8WiCVPi6bvC15lu7/x3mEIAiowInCLrMpq8dz/kUMN8mJDAH9g84q3tows2I2no4/Q0GflXK9c9wxp66nlvKJl+CDwNuO/sYwYO9zgIEUiWdpETAStkdIPI6yIkxZ94LVgMGl7yBIInzEMGYmRmxaXZl+rze+k8jZfjDYMJugI5gjuL2P8NVXhQe8Mnv0ZAevOq1uBPhQHb7XzLkZC6xP5b7+2mW6yKsVYGJW1UjYVGmoFtcgmfyVv4MKD0nAFGJFKlT3SIw7NzmBQ/fQ/zbeNRww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 04, 2025 at 01:49:28PM +0100, Emilio Cobos =C3=81lvarez wrote:
> On 12/4/25 12:57 PM, Miguel Ojeda wrote:
> > On Thu, Dec 4, 2025 at 12:11=E2=80=AFPM Peter Zijlstra <peterz@infradea=
d.org> wrote:
> > >=20
> > > Right. Earlier I also proposed using libclang to parse the C header a=
nd
> > > inject that. This might be a little simpler, in that..
> >=20
> > Yeah, that would be closer to the `bindgen` route in that `libclang`
> > gets already involved.
>=20
> Yeah, so... there are existing tools (c2rust [0] being the actively
> maintained one IIUC) that in theory could do something like that (transla=
te
> the bodies of the functions from C to Rust so that rustc could consume th=
em
> directly rather than via LLVM LTO).
>=20
> I think the intended use case is more "translate a whole C project into
> rust", but it could be interesting to test how well / poorly it performs
> with the kernel helpers / with a single header translated to Rust.
>=20
> I personally haven't tried it because for work I need to deal with C++,
> which means that automatic translation to Rust is a lot harder / probably
> impossible in general. So for Firefox we end up relying on bindgen +
> cross-language LTO for this kind of thing, and it works well for us.
>=20
> If I'm understanding correctly, it seems the kernel needs this extra bit =
of
> help (__always_inline) to push LLVM to inline C functions into rust, whic=
h
> is a bit unfortunate... But this approach seems sensible to me, for now a=
t
> least.
>=20
> FWIW Bindgen recently gained an option to generate inline functions [1],
> which could help avoid at least the bindgen ifdef in the patch series?
>=20
> Anyways, it might be interesting to give c2rust a go on the kernel helper=
s
> if nobody has done so, and see how well / poorly it works in practice? Of
> course probably introducing a new dependency would be kind of a pain, but
> could be a good data point for pushing into adding something like it buil=
t
> into rustc...

I already tried c2rust as an alternative to this patch. It works okay
for many functions, but it's missing support for some features such as
asm goto, though this is fixable. But a larger issue is that some things
simply do not translate to Rust right now. For example:

* Atomics use the Ir operand.
* static_branch uses the i operand.

neither of which translate directly to Rust.

Alice


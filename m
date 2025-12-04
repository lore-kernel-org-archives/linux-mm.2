Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BF79D29FBE
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 19:29:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C676D6B002C; Thu,  4 Dec 2025 14:29:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3F816B0032; Thu,  4 Dec 2025 14:29:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B55486B0062; Thu,  4 Dec 2025 14:29:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A422D6B002C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:29:30 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 35F1056163
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:29:30 +0000 (UTC)
X-FDA: 84182777700.30.709CAE9
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id 76FA818001B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:29:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gtc7ECqm;
	spf=pass (imf16.hostedemail.com: domain of mmaurer@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=mmaurer@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764876568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=li2jOPCpnZmjfOxkVB/u3Ntjt/9n1Mv+93gAuK1nZY4=;
	b=CIRmQ81cZRu+uG13elI/H+r6WBQs0KFAo/c3zM5SYacPo8X2USin45JufXzVRElz6tzPGQ
	fZQQ12DEZuHbJXDj7O02Vy+M3462Kwdm0GjVf6SHW0KFuoXJMgIeTZiPThRL817lkw5FIl
	o/EIcmo5Oig8Kzpe6KWFhEcvkxYTnAQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764876568; a=rsa-sha256;
	cv=none;
	b=e/rYObdhRS0L4DdBo/tAbYKL4v6oQxbldUK88xmYclcur6e/CxiAjFpKrxDvKmvlbSBq2M
	Y7uk9bSLGegMdi2T8KW4dFItNpdrXrImRNT3RHsHwhkTM3NbQlbgH8E+dScRLbgRjHHWjb
	dWB2nOWfEMHnIVF9Istu13K3Q9TQXq0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gtc7ECqm;
	spf=pass (imf16.hostedemail.com: domain of mmaurer@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=mmaurer@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4edb8d6e98aso83621cf.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 11:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764876567; x=1765481367; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=li2jOPCpnZmjfOxkVB/u3Ntjt/9n1Mv+93gAuK1nZY4=;
        b=gtc7ECqmiHE8Nss5DOVQkLsC8S4h9auet2eELkr6MHCYXW0TJRNVuD5JyWf6/EFNDo
         5EXPXzUUuuL9UbjR6QpyU6oF4hh8PegOgN2UF7FJUAr4OS0oRr2dM3G4wJsRIJcd90fl
         Fx/KotqmEODzHl7obkOsDIfeTfDGdBKhe8SnXKKD7jNdXixdWZ+sOteGiMZyu4CmLClD
         fSlpTL0Zv2Rj7StIAcAO1ZfzE5KUAIoLPbHt674sLaid7OZgzh3Q7puMoK20GOgqvfhv
         uOImwRiviAPYfe8D0hHY9B2yEyVpcJo3ecMmA8X7tjgF88zKF5ai8jV4g6iVgngSmTSk
         SVqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764876567; x=1765481367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=li2jOPCpnZmjfOxkVB/u3Ntjt/9n1Mv+93gAuK1nZY4=;
        b=MQdIjR9XmnjD+hKcXUSGD6D4Gd+xSbD8h/xqUCEh8ZzdscuJWhtvRWJ2GFkJ7wZ/un
         ztKnPelMJgT/WDgH7vuNN5wUpAffV6vmd+F14QxIeW2ynAu2MQU0E56bWuOo6QXdIASt
         HGet9LEIYm+TYUIAjg0FvVOcOaVgzp2EESTquWkEb4/m4aG8E7QaPvW8QxsbNfNmfN6U
         /VAGhfgPXE7itdFnKGl5BZnAH5Blri3gtEn5VjckQbGRggdC7JjSfMBKWSLSOZLCxTQv
         8HX921O+lnL13+JiwWATaHOsTJEONAgVwWhiW8O6MhHAXOL98aA1/RfN2uhPijq1bocx
         3tbw==
X-Forwarded-Encrypted: i=1; AJvYcCVLhIcYvAjAPCGDpsdkw69K0j37iIYcXIm+HUvMRvHXECLNh0Fk5pbfYob9hMm0Hb+PmgocTLKFZA==@kvack.org
X-Gm-Message-State: AOJu0YzjFk4lTwWbvJ/RoPAxQ+8/WgivymlgpOqSy8lJ1Wd7Dom+Qia9
	f73n9qbWKfe8yxiiA7W5w7MM3ci2FJu88Fscbhpejqey5vG5qGYLaklNEXm30T3PPwYYoJ369cR
	AddEUrIJOqd7Ykq0+B+zgkAhIy+NLC/4dg4XqUeeU
X-Gm-Gg: ASbGncscYwsxkj2mF4joUKJIF0uBJDvOeN9/iMVDTErfhoFIM+c0RUyMHFdNukRtoVv
	sgC4jFWTiECrzQWJ5khp4DbQhc284FmWdv23UH9AyBcNdweMqQlgvFU5vEx39xSFlGp0a09+8El
	kk3g1xr//tn/5o7FwW5qTZhhwatPPNgBZKs8duawBcQv2JbYnUVjyBUpvLfCuI8wGVJcWdK1AZC
	jN1iz/DnxYoReAzpwmjwN5ihF4hASC0aKVejbciIb/WY4PsSQ70Pr3KlXH14RNxk68oj6/08gV7
	VBW0TFP2vKtQ5y+a8MW89S+xKg==
X-Google-Smtp-Source: AGHT+IG/7kUZxd/9UMd9RxOWK7oRJw6LsWkyhbSwzHRq9dv3XGK3gE0ZwwYu8Q59dnHZWlQ+QWACJNmSaDdEdt4GFj0=
X-Received: by 2002:ac8:7d91:0:b0:4ed:ff77:1a87 with SMTP id
 d75a77b69052e-4f0310036bbmr1019101cf.19.1764876567093; Thu, 04 Dec 2025
 11:29:27 -0800 (PST)
MIME-Version: 1.0
References: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
 <20251202-inline-helpers-v1-4-879dae33a66a@google.com> <20251204100725.GF2528459@noisy.programming.kicks-ass.net>
 <aTFhFXCqvy7nmDOp@google.com> <20251204111124.GJ2528459@noisy.programming.kicks-ass.net>
 <CANiq72=r+Fmu0uuNF=6x36GWWQZGZk9gApnMZxakJavviwG+ug@mail.gmail.com>
 <dd5856a8-e120-4884-8828-9d0c9edc60f0@crisal.io> <aTGJdlwMRxGg2iZ1@google.com>
 <20251204142742.GM2528459@noisy.programming.kicks-ass.net>
In-Reply-To: <20251204142742.GM2528459@noisy.programming.kicks-ass.net>
From: Matthew Maurer <mmaurer@google.com>
Date: Thu, 4 Dec 2025 11:29:13 -0800
X-Gm-Features: AWmQ_blF4lJt3BfO2o2NOJRf3_Ss0kAS-vrqLdfp0qFcfHcQVmwUbXFySwWbsjc
Message-ID: <CAGSQo01Am_rNeZqnqZU3hY7SwWG=dTHtzcksPSHUTiasgex+cA@mail.gmail.com>
Subject: Re: [PATCH 4/4] build: rust: provide an option to inline C helpers
 into Rust
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alice Ryhl <aliceryhl@google.com>, =?UTF-8?Q?Emilio_Cobos_=C3=81lvarez?= <emilio@crisal.io>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Antoni Boucher <bouanto@zoho.com>, 
	Arthur Cohen <arthur.cohen@embecosm.com>, Gary Guo <gary@garyguo.net>, 
	Josh Triplett <josh@joshtriplett.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Nicolas Schier <nicolas.schier@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	nouveau@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 76FA818001B
X-Stat-Signature: hxpdad4zzzf43yfuf4carbttk9hqgstz
X-Rspam-User: 
X-HE-Tag: 1764876568-338087
X-HE-Meta: U2FsdGVkX1+Wh+tU9MG6Fl2L+SdVlKR1lnu7PeZ+uOvl5l4sSUWdSE3n9L6t4WipAF9MO0DeFpXHVnpT8mMeazBGjwiT/GKTtO2nFgo4AhcGrOJNfkvylYvNXF+TtZP/dX7iHIspAiwRpxy07lTtcbjWQGLoevrJ6It+Z+n4RrTGICT2lrEAkxbbvaj3uM5xjC+RMOKgxIWNnJqbdcvXcQdhseNZtwE5/PGS0yoaUAdWWROPZl/heibWWeYXLoYcmFbLCa2ROR21e75Y9S/tNMW4lWBWLTqz+07BkzQvnkwsSL3C0WIHyCoTCv2G2Za4a1pTLO4cLhV0DkK3qaHCOks89NPK/Vblt75GZnD8xK848wBZmkak2GbybinNtOE2sMZ5tirh0VdYc3McbCoYqObRK97jPf3BzmRAwgSnj/anJu+1t08yQZAt6IbUZiZb+p0FewRiVFsIozHatJJ6esaqCU8hgcRxl68m0gu1oyewrr/vxeOc6lwnwODNXaLQrqMEOmd/BBoN99AR7Btn28bONRijueysYrSqBzM1IlgJQYYJw9XRh8VHxiK217+EUDzXvKfKxbGXoYZQ4bSrbIy2co5t4Oy/AYn0vYT9HetsRhs1RiXbxdqZXq5HGxUfzfuAbjfjQgWf9wFZGihYnaqezcoJkQV+pkfn+fH3Srj8EdEgDRaX6HoS6GOZDpr/uwMMTQU4Qy9s9Eo4q2eyVdP9mQpfiQ+Reidcc6F5Rzz0CXsXQGvG5/twL2CPg4KJCaNPeEH6R1cV/3Tffgl4/grGsIfszo07XNi44r+DCHYKuccqmG9v1cPLrlUi2LYQxNJR50UR3NHZG3WVB1sbTdxLHZ1LjOtW26MvCfy3UZRTl1A71zarV1vhGwgG4v29wlIWwyUDpvTl8QCK2K3keVjVnhQpudlW0s6IM/Y2UCfqYHajIaofV69Z+Ct+M/AZrpDAT48+4db+WiEbzwL
 Hcp03jg6
 HUUGMbjQaZollfxk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 4, 2025 at 6:27=E2=80=AFAM Peter Zijlstra <peterz@infradead.org=
> wrote:
>
> On Thu, Dec 04, 2025 at 01:15:34PM +0000, Alice Ryhl wrote:
> > On Thu, Dec 04, 2025 at 01:49:28PM +0100, Emilio Cobos =C3=81lvarez wro=
te:
> > > On 12/4/25 12:57 PM, Miguel Ojeda wrote:
> > > > On Thu, Dec 4, 2025 at 12:11=E2=80=AFPM Peter Zijlstra <peterz@infr=
adead.org> wrote:
> > > > >
> > > > > Right. Earlier I also proposed using libclang to parse the C head=
er and
> > > > > inject that. This might be a little simpler, in that..
> > > >
> > > > Yeah, that would be closer to the `bindgen` route in that `libclang=
`
> > > > gets already involved.
> > >
> > > Yeah, so... there are existing tools (c2rust [0] being the actively
> > > maintained one IIUC) that in theory could do something like that (tra=
nslate
> > > the bodies of the functions from C to Rust so that rustc could consum=
e them
> > > directly rather than via LLVM LTO).
> > >
> > > I think the intended use case is more "translate a whole C project in=
to
> > > rust", but it could be interesting to test how well / poorly it perfo=
rms
> > > with the kernel helpers / with a single header translated to Rust.
> > >
> > > I personally haven't tried it because for work I need to deal with C+=
+,
> > > which means that automatic translation to Rust is a lot harder / prob=
ably
> > > impossible in general. So for Firefox we end up relying on bindgen +
> > > cross-language LTO for this kind of thing, and it works well for us.
> > >
> > > If I'm understanding correctly, it seems the kernel needs this extra =
bit of
> > > help (__always_inline) to push LLVM to inline C functions into rust, =
which
> > > is a bit unfortunate... But this approach seems sensible to me, for n=
ow at
> > > least.
> > >
> > > FWIW Bindgen recently gained an option to generate inline functions [=
1],
> > > which could help avoid at least the bindgen ifdef in the patch series=
?
> > >
> > > Anyways, it might be interesting to give c2rust a go on the kernel he=
lpers
> > > if nobody has done so, and see how well / poorly it works in practice=
? Of
> > > course probably introducing a new dependency would be kind of a pain,=
 but
> > > could be a good data point for pushing into adding something like it =
built
> > > into rustc...
> >
> > I already tried c2rust as an alternative to this patch. It works okay
> > for many functions, but it's missing support for some features such as
> > asm goto, though this is fixable. But a larger issue is that some thing=
s
> > simply do not translate to Rust right now. For example:
> >
> > * Atomics use the Ir operand.
> > * static_branch uses the i operand.
> >
> > neither of which translate directly to Rust.

I took a shot at `c2rust` as well, the summary was that `c2rust` was missin=
g:
* Asm goto support
* __builtin_types_compatible_p
* Deduced types
* __count
* _Generic

I was adding hacky implementations along the way to see if things
could be made to work, but the %l and %i missing in Rust itself that
Alice pointed out were not things that could really be worked around.

I also think that the bitcode-based approach is more future proof -
the kernel may pick up new C features that `c2rust` hasn't yet learned
about. If `clang` is in charge of generating the bitcode for the
to-be-inlined helpers, we don't risk any desync in terms of what
features are supported either by `c2rust` or by `rustc` relative to
what's in use by the rest of the kernel.

>
> Right this. AFAIK Rust simply does not have feature parity with inline
> asm. Them having picked a wildly different syntax for inline asm didn't
> help either of course. But Rust is Rust, must have terrible syntax :-)


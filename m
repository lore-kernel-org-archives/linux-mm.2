Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 551BCD1CDAB
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 23:25:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BD286B002B; Wed,  3 Dec 2025 18:25:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 846F06B002C; Wed,  3 Dec 2025 18:25:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70F776B002D; Wed,  3 Dec 2025 18:25:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 536286B002B
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 18:25:31 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C6FBA1334E3
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 23:25:28 +0000 (UTC)
X-FDA: 84179743536.19.A37932E
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id D54BFA0019
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 23:25:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xnz6kfYy;
	spf=pass (imf25.hostedemail.com: domain of mmaurer@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=mmaurer@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764804326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a6uoVhNguoRPRGf5uoEhquoFovSI0B7deZMJWzTJLAU=;
	b=thKlPOA0tq+D99fR5/BMozPlrGVfqp+kkHpdh7XdNEJzKxv8RMDR6Labj5Jxpmj4UipsdD
	wCPWrSUvRDr4ORVE8Z4O7PqiQvOBl6PgsspJOFa4LrUxPzdqYTeXy2Jbn5NG1otrZm6WxG
	h3g43KG9HLwmys/MBW+xsdjbgdBD8Qo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xnz6kfYy;
	spf=pass (imf25.hostedemail.com: domain of mmaurer@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=mmaurer@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764804326; a=rsa-sha256;
	cv=none;
	b=DiGBBaoBxwpAyqJgI+e2Yah3S6FU5KelD7W7m4BCqsMIWSNBWs+OShT7Rot5zoj8uygdc0
	Jmjm8swSY2onTzsUBirt3+k7tAkIRPQxELpiaDfPQO1z99nWzBf5zPjTcBf1AjOXRtMUUl
	w+tY7s6VVG06DLDUNyS0PxkMwCdxLFg=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-644fbd758b3so4096a12.0
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 15:25:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764804325; x=1765409125; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=a6uoVhNguoRPRGf5uoEhquoFovSI0B7deZMJWzTJLAU=;
        b=xnz6kfYyGHZxK12t4NxaQ2lgllgL8YfU7N5p34RwN+ZXjebK1+csBd+Lw5Ucpepzvc
         zO8yC+7Acjqy1vX8keaoO2cWpiZH5y411nOqqxpvjiSi0e6YKeQUNA1b4CwSRZy0HKtX
         Rm8Ed+O4do3CJZMK3EZoueG53w9n94u4drGkCepcZxcDODT4QOBAwyKr45vy+UnkzcUj
         uosZwzvbKpznugTVjOlYByfQa75UFjEskji0Aibyo0GYCUMPNLmySIT1yf/GRWB+D8WR
         ACYQ20skJJIH0CSpj8dHBd1oaQEqGDMqnkFtFe+kI6wVSNFAzehnAyO5FYdBzZwf5qLg
         7N5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764804325; x=1765409125;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a6uoVhNguoRPRGf5uoEhquoFovSI0B7deZMJWzTJLAU=;
        b=Xq1j8PzE4p/3+lyn5e6dhq2RBi1cA/9mbrUB3OsVgwYdd5npbKismjLMyJ/tqFC51d
         OnbMQV6zuYLYrXV4OPlV143G60dWi5S0SGsE7dxWydmASH0HqCF4hT8fppBZxaXvxMQF
         YBXxYdEg+I62EVNrY4YhI5+MrJEkEGFqtbCNZj2a8ygmSz5pyZJjGHtzN/kOSFpvKrkM
         nf7HT4rZJlIgypy5gy5vEXFH+PRSpEWW33FyEk/nHzPh7GwP8jxGvfQIYs0DgfKC6ZtY
         kJPgS8+htGrMpoqj2a0G2UVFGOnlgnfwUSmkvzRhjBSklMCNdLg+aP6UH/vRgd6xVWuY
         kmUw==
X-Forwarded-Encrypted: i=1; AJvYcCUzkqf7BRc+OUdtnoIiQLBCTGAe631obmH2ZKXFEe+wmrzO+OLC2GiJ79fZgZeXWH/rlv2p7nZylg==@kvack.org
X-Gm-Message-State: AOJu0YwlkD7mf3/uaE6iXDTdhLCWn2OBkWxyTntqVJpIobZX9tk6rpeg
	xVXKycD7pm1rFagStftvgtjdgXfKphtPjQbqRZ5rdN6rewQbDbEt0uGc/gXqF4nAcokl36ptkGi
	leIYZPYR/lbvSAwL3wDvUz1M4lU4c2mS2b7jHKT5e
X-Gm-Gg: ASbGncsZjlJAFBIwo/nxgn1hJfi/v3DKj82+1rLN+kDN2ziDdtMQG/k2eaKoztIqaFG
	YXMPtaYWgfKcbQI6xguPOBFupSXdewH+ddBEY1A06Ktp4IUWIoQ7Gg+/mPf9lPXgh++ycKj0w3G
	UtTfwz8mzEENZK5HW3QvuG62moSnh4X5+NMXpLrkYAgQoZ/VXl3S0+szc2YXH2vHhlxftQjYUwe
	TJb5dgyDynoF4w7/HtO7KuOW2DuYQv4ERffEBLkxjK1IqiSk8Nhr95ZlZxbD/H8GPDQwPu2WdQS
	j/ytcJc3G+kjKlrsaME1aA2u
X-Google-Smtp-Source: AGHT+IEXEQTgoa3Tuakna4skmZg2pw/mrECwMwVvdW0fQYVmXvi58ZGexwzvZpC2XAuu5b911WZjF7TrDbbogWoEqU4=
X-Received: by 2002:aa7:cf02:0:b0:640:8f9c:af3a with SMTP id
 4fb4d7f45d1cf-647a7728a14mr14606a12.6.1764804325007; Wed, 03 Dec 2025
 15:25:25 -0800 (PST)
MIME-Version: 1.0
References: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
 <20251202-inline-helpers-v1-4-879dae33a66a@google.com> <20251203212558.GB3060476@ax162>
In-Reply-To: <20251203212558.GB3060476@ax162>
From: Matthew Maurer <mmaurer@google.com>
Date: Wed, 3 Dec 2025 15:25:13 -0800
X-Gm-Features: AWmQ_bmE-9G2UW0Equri3aRgg0NngGho89_DAwKEs6T1gQOz1p2ws5lgLkHiDf4
Message-ID: <CAGSQo00bG7QF+u2WJQwMTiq6iGATcSfaAurkkppykkn+yTL-TQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] build: rust: provide an option to inline C helpers
 into Rust
To: Nathan Chancellor <nathan@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Nicolas Schier <nicolas.schier@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	nouveau@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 6y1fehr777y1xpsstfx4bnfg5mddybqu
X-Rspam-User: 
X-Rspamd-Queue-Id: D54BFA0019
X-Rspamd-Server: rspam09
X-HE-Tag: 1764804326-248550
X-HE-Meta: U2FsdGVkX1/NxlvjoF7q3mX8xSwk68TVvQAGKWm6Do7lu8A3P3ryFkYSZ2hwJAKs60rgiBzF1i5YrzHadrrhZIWDXcPio1lydx4HTzFwHbbG17nY9rrdg3Y2FmrSTwKcDgvoCI923uAUrVq57VcUrgPPMs9Z714+7ZHNn/FmuPkN4Tjc17p7TXQbaNuQx5dUfPZsq7a43lARQBf7YuoB+sGVUfw2P7c5DF8UL+C9OhhMPKxwtkPg7DOwkTVLEt/JmROdYljT3HEeW02ON9V/XyaD/6I1YTlCJUvAm1THRwCdSAtosj0rR+Sqq3dyh+OGULVKhkmvXLJuvRnCSfM+R/Xk+PyefF+3Z2ilTBtGS4Ws+VZCAHVUT5WPpayzyjsqGZayNUsVP2w2M+LUmGgTJVsb3sGw0pnyXOad1gyIYowTieA3BKt3dr0YlIeqC4s+iOjJlOMMA06QjnSH5cbcIz8ETYFVpWnxHyvnk9QkRZUy60vNL+RX7LUTI0yQlHJXjP0m3R73hr+HjDtCqIjhOCv8NHkMmMEK8qaO02XwrN95zSZLfK0wifD+QbtfTRS2usHXQdjB138RwdqojO9l6ss6M+42jBpRxZfhpkpyJ2B5BGcvKQS8GGcZE4N/ir69ZY4tV155jHle7r90FJrNIJOSz/OcBdncL5DXTWlYmhyPtlL96Y77x8SS4/8vbOz/zoRvEq0jHj6c67glZBU2VsBf+oQLK+V/0BUgrm5lJkWsIoG5duQlOIipSIbqGbk1MJC5UTc1MFETm9AYI1jVS8OG1RAFUsEcBceusar8HXEt9OtiZpEy+fv86DPCXIgMJYMVyX4gftlwDDa8LrVU4IcTPBWDbw5vzijRA8B08Ks6re25hbxs0jvrKor2Dotc/4pj5/5OGJx24617fCNEinfMurMqNkSf14suvRiynah7w1KERlVKWHeiX7hCWR4w8hFloiDK7Ih8/wb9SGH
 Mw6Rc3D4
 OT3AIkNi+zkfvO+hqufFPbv9FQ0mOj6jH6jAU72+UU1AWU3hObsgGCeuAsyKpA+PlZthkrt4XE68CuG6Y0xtZcEfBzjPGBcCY64GMtITAIP8/UyBxR5HG2d212oEe2xjvF7A7DuqwCxJZ29EG9icO71sshAGsRLCkskXS3WLOvPbzCrTanvzxg8f4aKSOzhI24xx73RlNSS/SsU0JWJ4hZSsxkP/FadXn7G4lDJOC3LpXlWXMmHBQ3HOW7yAZ5NGO03/qrvH+9aljBQ4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> I am just curious, why would someone want (or not) to do this? This help
> text does not really indicate the point of the option, just what it
> does. Is it just the standard tradeoffs with inlining (potential
> improvements in performance due to better optimization opportunities
> versus text size increase and icache pressure) or something else?

The main situations where someone would want this off are:
* Not using `clang` (should already be covered in config logic)
* Out of tree module build without the whole kernel build tree (the
`.bc` file produced here would need to be shipped to your out-of-tree
module build environment - it essentially becomes like a header file
for purposes of building an out-of-tree / DKMS Rust module)
* Don't have matching `rustc` and `clang` LLVM (kind of covered in
config logic - if anyone is using a non-release version of LLVM, the
config may indicate them as compatible incorrectly).
* Requires out-of-tree / DKMS Rust modules to build with the same LLVM
revision as the kernel was built with - may be a packaging concern

While the usual inlining tradeoffs apply, all of these functions have
been explicitly marked `static inline`, which indicates those
tradeoffs have already been thought through.

I think that if we had a reliable signal of "`clang` and `rustc` use
compatible bitcode", turning this on by default would be reasonable.
As-is, we have a mostly-reliable signal, so defaulting it to off seems
reasonable so that people don't get surprise miscompilations if they
use a `clang` or `rustc` which are not using precisely a
release-boundary LLVM version. People who know their toolchain story
for x-lang is squared away can turn it on.

>
> Cheers,
> Nathan


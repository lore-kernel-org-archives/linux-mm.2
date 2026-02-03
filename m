Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12A02E7FDD6
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 12:02:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5610B6B009B; Tue,  3 Feb 2026 07:02:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 518ED6B009D; Tue,  3 Feb 2026 07:02:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 445726B00AA; Tue,  3 Feb 2026 07:02:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 31D3E6B009B
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:02:30 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 80668C1DA0
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 12:02:29 +0000 (UTC)
X-FDA: 84403008018.20.45F4774
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id BA4CE1C000D
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 12:02:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=odtoUEjf;
	spf=pass (imf21.hostedemail.com: domain of 30uOBaQkKCPMVgdXZmtcgbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=30uOBaQkKCPMVgdXZmtcgbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770120147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HcL6kf6GDnL4z3aaa3ZQiFzxve6GNyY/d0R1gVrt74Y=;
	b=Wt9n9vDOGutmMA3hpXuUjDxwY1M3/AmrYwSVuFfEFQT34ljMPk4j3zjH8SuGlXGstfalfT
	y4xEyNe3WibdOyPnP5hzhJYP1iz3N/PNSvf0Y8zyNe94ZGKcvU5E9G1RViluEBVZlRL6er
	Hk8ipbdxgML7h/eHnhpJiHy9EbzclBo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=odtoUEjf;
	spf=pass (imf21.hostedemail.com: domain of 30uOBaQkKCPMVgdXZmtcgbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=30uOBaQkKCPMVgdXZmtcgbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770120147; a=rsa-sha256;
	cv=none;
	b=Gj/D1fNGAlqnKfqt7tN+KgqmN8mINVDsCSiIl0KyopBIa4E8Iw/Wl5XvSc3tDXsaoWV2L+
	zPKc5LHagwhKgyELjoblZOx1w2TPr+DtL2sSI0D4UcwzugnBrdbKm14ZKHLqszewR2g/H6
	xOrrOWGepohx/gWnj7Yf5THAA4lTyCU=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4806fce5ab1so35800915e9.2
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 04:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770120146; x=1770724946; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HcL6kf6GDnL4z3aaa3ZQiFzxve6GNyY/d0R1gVrt74Y=;
        b=odtoUEjfiHgl/UHGyRYfzW82kXX5SbncTEgeWlpyXJhzBhGEakATeGJKk1wKwQjdBC
         pgt5KoTH0pt37NB225keurJzRT821j8ax+N/ztwf5hzPfDgs9aTCnN/hhiyrDpru3Rs7
         Ub3fuPPc4ieCD5axTYR2Kjc3lEbZNY9k+rODGzmJqPPsYv5qfm0mP0ygSuJB0/wUPHVS
         /5UORGjS0UaN2kqNa65qb93UUbbPTCFdjqqLcCS7NMp1DoavJUoSTlNCU8Zhn2hv24be
         AHqgDGOHNxqu4QoRSaiQEayal6Q7AwTmd5DxucM2qWjTiXCtzuOYMRwhCscOHQL6YV+Q
         aE6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770120146; x=1770724946;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HcL6kf6GDnL4z3aaa3ZQiFzxve6GNyY/d0R1gVrt74Y=;
        b=jqGmiodbUzbmBE06vzkAXsXR1eOvdvb4heHLryuxEGpTC9rghzyYINhvdPWwocVc5a
         Oq8uJJfWEUwCCdW+3lKswXUXCfuMiidF05qGrp8xF9llo7zUWcbHeBjwOJIaRwK1kSwm
         xjb+qpGJjIVzAGz/b1NLwW7VuyMIUOmVFlPs6w5GB5V45Rf/QXH/JI1BjD5dWaBOZmpu
         ssgPDMd2u4pWHjyQpD5gbubDuoOdbCzSY3tRFcJo/Z/p882MFfJF52lxqqGopSsnazKX
         xsYcN6/WcrH4mWqAO2v1ZfO/VDLe2+wt3mCzN4UD6ODJh1Tz2H/2HdpLr8PSdbKTLgsx
         egPw==
X-Forwarded-Encrypted: i=1; AJvYcCWQu/d1MzYNZFdg0oAelw3yTI9d7FqKmRXh0KfEE5fH1249xdvjBuxjvjS6mKBBkWpaSiErMrJKVA==@kvack.org
X-Gm-Message-State: AOJu0YxdB/mQx9Sn085KT7HnC8FpcGlrGAaqTvsx3XO8hXVOURkLtFi8
	jXaM5/XMZQUomD1tUaiZOsLDvRP0vEsCZhpl/5soy9LbRBU0WuyooDtZIdGIZZEIcS0KSD0oStv
	2yMIplE7FoCpWa0jGCQ==
X-Received: from wmber11.prod.google.com ([2002:a05:600c:84cb:b0:47a:8fa6:6a57])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:34ce:b0:47d:25ac:3a94 with SMTP id 5b1f17b1804b1-482db491e61mr218064275e9.17.1770120146251;
 Tue, 03 Feb 2026 04:02:26 -0800 (PST)
Date: Tue, 3 Feb 2026 12:02:24 +0000
In-Reply-To: <aYHgtJ_xLeo5W-lZ@willie-the-truck>
Mime-Version: 1.0
References: <20260203-inline-helpers-v2-0-beb8547a03c9@google.com>
 <20260203-inline-helpers-v2-1-beb8547a03c9@google.com> <aYHgtJ_xLeo5W-lZ@willie-the-truck>
Message-ID: <aYHj0EbrMWMornMj@google.com>
Subject: Re: [PATCH v2 1/3] kbuild: rust: add `CONFIG_RUSTC_CLANG_LLVM_COMPATIBLE`
From: Alice Ryhl <aliceryhl@google.com>
To: Will Deacon <will@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Nicolas Schier <nicolas.schier@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	Matthew Maurer <mmaurer@google.com>, elver@google.com
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BA4CE1C000D
X-Stat-Signature: jd9aunkn7xcpdbsnyjj9yuttgnznx9g5
X-Rspam-User: 
X-HE-Tag: 1770120147-527543
X-HE-Meta: U2FsdGVkX18cmU9Nm+54dOXUEu+fmAImnvppcfVNNpxccAfaA7E5pMs8gKRfX3AK8f1SEB5It+D1WusafvbRbeRBrJzvECuJaHIYrDOjIJ0Irzu1QwP5TqbnVorfhjHsNshnmxN+GD6wA6J2bll9RUUrWd1fawKUFTzMPkk4XTF1XlTdf1duSXuaSqpgog3LYQWKuxetbi23xfh48IgJaFukMASTllgXq0JjS/HPhPz7x8IkO1uJevjkUFya6MDsgsYATMKDngGUUrtNa4zYYDZXfkgULAE4A5snXwI1ZOJJTjKpEFsNKBGMyx1v2t1FVtMWRsOfI55sFVoJXgSjo9NCGhMgGsnupmEQVrKBkiTs8DeXILlNTwiTA8n5CzH4j7737+FNGYfMGpkMPhM+HF78icrJJzW+Eag5nakSxFVh1JUI9mpU1WpNgvlb43jQkMosQDmMTY8eyahn2rYqvQeTvBmTnLr+OtFuMhutiBFY6qTl7sA4v+xKPvBVq93SYgkPVVPBPsqoiukXaHeKFHA5tol3yU5nMt/h9PLC2E+avh17TqV0SwpvHdTAhNDuzNKtMiBIELhjdHkgWnJjjVimX5qD7y+K/Y67dChbPdML3sMFYyfeE9NIJw1S5mukT23xxcZPMr4QAnoXGDmPnQ2fezrrpht993BkXhS0no4VbBgWB3v9xV6VPx+96WKa7cdBXddPUTKJmbYUFLPfr4JXzJujO83NtnwMNUUzSxJFU/RW/7R3wYeljhmrrw48aiBMk0dU+MrT527xMve8kJKw1LH7zIb/NBD/iDvxGPrx4lX60vamK3LhkLwKdEt1GDN7kU31IFm0BPG/byFG9HIwrjZyWe29M++lLf1h6ayuc/mExjoEnjVSKZGcKSz72ahIj9zb52vHoOso6jtBwYNY8xggmIzDQN1g1yoeYMhPzpJhr4VD983/h+MhC0w4vPZ0GV5lh5EOUMhGuF1
 aMBNAwrA
 lN/fzvxJ/ew59LETLqtlmLo9U2Dk5pn6JnKE2yVjlt0opFyny5RU22UEvYXG7ocReWCDkMDlEpNHUVbuGcG9sdQP9hbswmH3kLLJM9RL7OH+qX4wFu9r8+Pq61Qm00JHKj3TLwEIyecjUxsKpoGnuDpjt6tXxr6x/9PuRjCeK41h5cO8c6LZossdXTQ3LyiyPp8F0Bhoujm9a5N1Kov4Nu2Z3l/EeCrlkCLaNLpEmlJaDDRuCByaNv5aoMAbXz9UzZWeT8yp2cABpv8v5BFcGoExZ26W00KpP7kufI7qQWeDqNpvTzmXTzl5rpkCC7dDAepHSm3SS9EAl8C/XBhU91lSznA3W7FikoWmM6CVvvnUvTVXO3WhNvSQ3YhsGFaQXo3sVNllRGxog5k5EIyeZG1vSB8XxyjG6j2MiNzJOUI8wlzR1or0KiCuDDvmmUczBUCyBBV91TpCGpEKQlZ6tq5o5TDSegdiBOwj963HU3eyz9c9QEhjr3gqVLqJ3ncsb3PymQsNnwMB50FQGk0xLQbeRqlbG+v6VnEWK5gxu6G5fY0NCyVORI31/X2mLzYnNPq/XssZA+5ZPzvgd+RU06n3a89qhfNrH6IzcL9Khg7OBfUWtQ1rs3oa9RjTfSSi2U0kzapv9fP2xGCpBwLodT2h7batn9KenrmQYr4tQQrTjUYPIiWikyFZDP3+rV7WBEa5P3hM6g5t2gs6astHS8X1+p2B0k4y0kpKQrS7oYPaQAULcE804/tVtUvlHm1s1I4pGwuDSCvEp22CHz2lxqz1saGLa5c8yjIQ8zxSsT1t6KIW7AGI7SPIU8iXsJLyoFuNtGi+FsFobM7UXsph7qGnnqp96CqkzDAXZqP1rq4nO4Be1yhU594ACGUTwMqEVmeSq+bBQrPFKA5U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 11:49:08AM +0000, Will Deacon wrote:
> On Tue, Feb 03, 2026 at 11:34:08AM +0000, Alice Ryhl wrote:
> > From: Gary Guo <gary@garyguo.net>
> > 
> > This config detects if Rust and Clang have matching LLVM major version.
> > All IR or bitcode operations (e.g. LTO) rely on LLVM major version to be
> > matching, otherwise it may generate errors, or worse, miscompile
> > silently due to change of IR semantics.
> > 
> > It's usually suggested to use the exact same LLVM version, but this can
> > be difficult to guarantee. Rust's suggestion [1] is also major-version
> > only, so I think this check is sufficient for the kernel.
> > 
> > Link: https://doc.rust-lang.org/rustc/linker-plugin-lto.html [1]
> > Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>
> > Signed-off-by: Gary Guo <gary@garyguo.net>
> > Signed-off-by: Matthew Maurer <mmaurer@google.com>
> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> > ---
> >  init/Kconfig | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> > 
> > diff --git a/init/Kconfig b/init/Kconfig
> > index e95d43457851862afc8313389777e4dd9348c178..0e900d3d8be7874a33e0f44754a8d038e68d7e65 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -82,6 +82,21 @@ config RUSTC_LLVM_VERSION
> >  	int
> >  	default $(rustc-llvm-version)
> >  
> > +config RUSTC_LLVM_MAJOR_VERSION
> > +	int
> > +	default $(shell,expr $(rustc-llvm-version) / 10000)
> > +
> > +config RUSTC_CLANG_LLVM_COMPATIBLE
> > +	bool
> > +	default y if CC_IS_CLANG && RUSTC_LLVM_MAJOR_VERSION = $(shell,expr $(cc-version) / 10000)
> > +	help
> > +	  This indicates whether Rust and Clang use LLVM of the same major
> > +	  version.
> > +
> > +	  Operations involving handling LLVM IR or bitcode (e.g. cross-language
> > +	  LTO) requires the same LLVM major version to work properly. For best
> > +	  compatibility it is recommended that the exact same LLVM is used.
> 
> Is cross-language LTO something we're actually looking at doing for the
> kernel, or is this just stale help text given what you're using it for
> in this series?

I would like to see CONFIG_LTO actually perform cross-language inlining,
but it'd require doing something about both:

1. The issues mentioned in patch 2 of this series.
2. The issues mentioned in commit 5daa0c35a1f0 ("rust: Disallow BTF
   generation with Rust + LTO").

As for whether it's stale help text ... CONFIG_RUST_INLINE_HELPERS works
by performing cross-language LTO too. But I can see your point that it
would make sense to improve this wording given that we're not making
CONFIG_LTO work now.

Alice


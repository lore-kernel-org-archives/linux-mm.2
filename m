Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56CDD107BCEA
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 00:26:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92CDA6B0088; Fri, 13 Mar 2026 20:26:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DA756B0089; Fri, 13 Mar 2026 20:26:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BC216B008A; Fri, 13 Mar 2026 20:26:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 66C666B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 20:26:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DE45F13AA05
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 00:26:16 +0000 (UTC)
X-FDA: 84542776752.25.51ACB3F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5B195C0003
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 00:26:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YfELWr6x;
	spf=pass (imf22.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773447975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Tu+BvloNR7tPSfHXVaUwhCscAdCNFI//yZQeEfUbIc=;
	b=axM2k/ON2R06Ri4ksGqvvBG+df+G15VH6AM1tDPtakHAOTAorhKqMf52b76ABoVPNR/KUs
	rEJwlkZotmCm5HQI4rnQcfIzwiLP25w8QRx9RHFjUwkPk2zy82ugRdVTGKpyZLf5VtKi01
	NCyg7XCsH0D2XG0VX08W8ecGUD49WNM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YfELWr6x;
	spf=pass (imf22.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773447975; a=rsa-sha256;
	cv=none;
	b=qzxr2vtsp5hY0B0O7o2J0vZP1KsNqManl9pvWxawrafND3D32V55+T15DnuCnsuvrel9HP
	BinmkMWhY1tibJH+kNgU+SrU76LF1IRK0ubTSGZchLSnXHx3trGmtesEYEPFzKOdQPdKHZ
	ASEQhlNBPFziek3ZsCUuHbIUMVkhUnk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C92EB60008;
	Sat, 14 Mar 2026 00:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C00C19421;
	Sat, 14 Mar 2026 00:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773447974;
	bh=WNfONBSSwZlJ93h+nb5fE553EGLxDy6HctjwVBRE1ng=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YfELWr6xe8ogQ1Dzt1ph1Or4CkDZzba6Dj0w7TfjGFx7fqwjvcmAVVVT0R/DPqd9m
	 0zfwGJ9/PfYd8hnArBJWqLzO8abNX4kfpLdlAoysNoHk9ciuYiB0zrH5APEC+yfDKY
	 i/tbaAiM3xx9fNSd9SYdf8zHtsa5KM10xK+IK0E0s2czV/4ieNNF14jcmVew8CvxhE
	 FxoqUTcKnqL0ahxZjyf6Px/jGf0wbNIEvXaSRnIT/BGKMNNlpkLZtReXfoF8LKAjAF
	 4xr+PT3o09wfsIrp4m5CXbX0OWHNRIwgixKLFri8JEjhqYCYEkVXL1LSOLh0/pw5ZJ
	 UQJipt2AFo4Gg==
Date: Fri, 13 Mar 2026 17:26:06 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
	Matthew Maurer <mmaurer@google.com>
Subject: Re: [PATCH v2 1/3] kbuild: rust: add
 `CONFIG_RUSTC_CLANG_LLVM_COMPATIBLE`
Message-ID: <20260314002606.GA534169@ax162>
References: <20260203-inline-helpers-v2-0-beb8547a03c9@google.com>
 <20260203-inline-helpers-v2-1-beb8547a03c9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260203-inline-helpers-v2-1-beb8547a03c9@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B195C0003
X-Rspamd-Server: rspam08
X-Stat-Signature: jrggm5rz395zhjak88spcec8jsksiprr
X-HE-Tag: 1773447975-149535
X-HE-Meta: U2FsdGVkX19lddslpJcNsZ/aUrLlOGyc5VHXu5iOZdZDcP4wDWfn6GpS+woOoRVS1H5VY5oxRulc0A6cvK7DYJpsL46QZAQ/veqw5DtLnctaoDt8Bqr1Ve4ZcRsWH9cZmr+Arx6eQWJjP7QxTWtyBi3JreUK8IZGRVB08lBpz3lwePe7+w/jTktS7Rpu1tt5hDWEDdIB8q1NPZ+nidrUKDUyZ2EFbHxu9d/CVXbvqJ67kTWe4mmgye3fwjnyTvfizhP5hiLT2W1nUTMsUz2LPUKB/ZOWFpvLe/bxhis6cbHrFaqYKtddMyLRCq60noGcra3kMpF3ru/agopzSXCPwwiD5dVIhdMD7t1lM8GcuwCAIuO64FKqC/zu8hLqUxwgjrHLj58qDTCJbJ4wqE3MPnSJDD6bxbblXdtAP5GlMQu4oIypPNvSdoqjQypWlwxE3Y8zC4hZ4bP/613HUHf2a8exjjX6e+9bqhO3GOp+Gz2LU5aE1PrdM7eh3bs9/uoEGV47NmARltzlk+lagP3XEG+7cm4kxcIdiIW/RicnYExYW+GxYKhFLXGlGk8Z0vCasJEjADqrTu+rs8QT3ljzckuz0XjhhP0jzlC1mFM6vQGcT4FSfcd5zIZZgiz8mJTw8fPaefNjusITPdXDG6KZMM8xLKkmSMtQeIloMMSx9ivqlDYZtigOOdl2HpBEq6hLdbApAqnVV7OKR8Fsh4iI6H1fdftz2/PQhgF14Hv4aEr4ILVb2fZuGe9G88U+9hfO6RBRuYFOFVBbRJoo+kq4S2VucLzz5zCEnWeMRhcbunSiFJl7bW7LQDRBzjMWc/FsByglrfQLKSHNQbdtzoRZA2ByyHtkBmN/7aFvfdM0nPJ46rlRa+X1IZrDyA2DKWOj6GOsthNwh9v/eV0TdleeTVy6neYmh+vFMwrWVLvdibee3wX6ylhJsGQZU4pAoy+EmPInctUiNEOuebgXQ14
 +8oG9EEO
 YJIOZ0NaMfCctPRhCqG8LWEX/w477R/GKl2//fcGyJ+3+uugncW3+aIjdLu5dnAEaPPsGOkYQkv6fKRDKSLIjRwOXi01yX+VbBu4BMLiSJPu27hOi92rYVYfwhu3BlgjHSy6OgJ3uhaMyFUJK9JimrBJ/guvwPuw/3Aq/lrO8Zj7CvVpzpYnAK8ujb7PhMFO7Di4t9OIUaB0dOcEVxEN6AlqvhYc8ZwpbPjvQmF6mI5V1Uma6lOEFiPpoLLHX2aexZzfiHjNm9D45ykdWo/7Z0QKNju5qQ8L8NATULQtZeSKEMW8EP51+UlauoWvGSfvYvJkvd7gF4pzOvSAVQCg8HUBZ4+kcBsE/B7YbQDqhCMQ/2udIzBZGXB+AvJV9nH/RmRhO5Uss5quaDwSRlOzCa3ik6wIOAf4y3wxUARBc3mgAociH8XGOPCgx9SuNLnpYOjgAn6OpVi1pARkX47jT1eJ30cWtuBzhGlxmU6fFtdQoaYClJIh+rsHM2+85vzycKm2lvFelU+z2Ltc+25ii5X0nXkzC6MWr2278JNsdfbgImnCJxJca58FC/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 11:34:08AM +0000, Alice Ryhl wrote:
> From: Gary Guo <gary@garyguo.net>
> 
> This config detects if Rust and Clang have matching LLVM major version.
> All IR or bitcode operations (e.g. LTO) rely on LLVM major version to be
> matching, otherwise it may generate errors, or worse, miscompile
> silently due to change of IR semantics.
> 
> It's usually suggested to use the exact same LLVM version, but this can
> be difficult to guarantee. Rust's suggestion [1] is also major-version
> only, so I think this check is sufficient for the kernel.
> 
> Link: https://doc.rust-lang.org/rustc/linker-plugin-lto.html [1]
> Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Matthew Maurer <mmaurer@google.com>
> Signed-off-by: Aliee Ryhl <aliceryhl@google.com>

Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  init/Kconfig | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index e95d43457851862afc8313389777e4dd9348c178..0e900d3d8be7874a33e0f44754a8d038e68d7e65 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -82,6 +82,21 @@ config RUSTC_LLVM_VERSION
>  	int
>  	default $(rustc-llvm-version)
>  
> +config RUSTC_LLVM_MAJOR_VERSION
> +	int
> +	default $(shell,expr $(rustc-llvm-version) / 10000)
> +
> +config RUSTC_CLANG_LLVM_COMPATIBLE
> +	bool
> +	default y if CC_IS_CLANG && RUSTC_LLVM_MAJOR_VERSION = $(shell,expr $(cc-version) / 10000)
> +	help
> +	  This indicates whether Rust and Clang use LLVM of the same major
> +	  version.
> +
> +	  Operations involving handling LLVM IR or bitcode (e.g. cross-language
> +	  LTO) requires the same LLVM major version to work properly. For best
> +	  compatibility it is recommended that the exact same LLVM is used.
> +
>  config ARCH_HAS_CC_CAN_LINK
>  	bool
>  
> 
> -- 
> 2.53.0.rc1.225.gd81095ad13-goog
> 


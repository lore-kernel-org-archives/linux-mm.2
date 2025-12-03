Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CCB7D1BDE4
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 21:26:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D7926B0028; Wed,  3 Dec 2025 16:26:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AEFE6B0029; Wed,  3 Dec 2025 16:26:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C4D96B002A; Wed,  3 Dec 2025 16:26:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B70A6B0028
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 16:26:09 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DBB031407D3
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 21:26:08 +0000 (UTC)
X-FDA: 84179442816.01.3B0D65E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5727418000D
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 21:26:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zd86bIpv;
	spf=pass (imf24.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764797167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/rnXb5GTN6C5/4ob20LSalNmgpma9QfbcoP9c8gcDE=;
	b=FuzhAIEr7bqS8Cyy+VuLAgbV7l93GlHCZ7W8ZlCFgGiNpINCzIYH5YbWOeCpojNpStOgj5
	qZx9Vl8FokAJB0/5nX6Zp9OQWAB8cWYvlE0FRv+SBdPPo88bmDw+7G3PuxmOtPGWmEJtx0
	idx5IfNgYoTnFz4ZdmGzlA91r0CtRSo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764797167; a=rsa-sha256;
	cv=none;
	b=3Nt1GjSnqEqOK5pnTxKEXvuJSoBv0OSilOdMebJhIe1gQ7BSoiNiW61KASeYLB32f208SO
	FZrxA+HKLBvfWoMN0ln68vxBr7ZUWx9uGPjCBjE3auKacOx3EFZfdEuZYVPLdYuLaKOn8O
	eso+7FezsXMK4MdvULmZ7La/v1bRE9M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zd86bIpv;
	spf=pass (imf24.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 79BB360125;
	Wed,  3 Dec 2025 21:26:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5D0C4CEF5;
	Wed,  3 Dec 2025 21:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764797166;
	bh=GFgAqj8UfGyBUyXfv+53BPOejR4vlRFgXnL4TObOzNM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zd86bIpvg86iAEPANnDmH3QLfW8yzPG0kdsDWe9N2/EYvP4E4L9o550SSI8Yv4LVZ
	 URMQb7wPkrwy3laoLMkOWv9kZRBo6Y6BMGYa1zv/UOiYIVd1BsnWue8Z1t9ELX7Jve
	 6i57FY+s0dGa6aljNBsNu9O6zTwIzP+xAhmeuUtOYebVtJKIiCI5TmZbU3HciuuTbq
	 3UT5mzV9hDBwXBm5TipT1YTZHmVTV25YbGoONGYQG43tNFbqqBdZ7TDqbUQlxvv7+L
	 O2McGBanr21d+vpA/GHY1azbF8OM4IyeLD71qJhNjGEEKRMZVCNJVT0wfcoaUBZnmc
	 sCIvRJ6Q37TLw==
Date: Wed, 3 Dec 2025 14:25:58 -0700
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
	nouveau@lists.freedesktop.org, Matthew Maurer <mmaurer@google.com>
Subject: Re: [PATCH 4/4] build: rust: provide an option to inline C helpers
 into Rust
Message-ID: <20251203212558.GB3060476@ax162>
References: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
 <20251202-inline-helpers-v1-4-879dae33a66a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251202-inline-helpers-v1-4-879dae33a66a@google.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5727418000D
X-Stat-Signature: 54ii5miqwwgbh6nkx75xp9wjir6kcbya
X-Rspam-User: 
X-HE-Tag: 1764797167-682439
X-HE-Meta: U2FsdGVkX18l/wmjrd3oPV9l5U14PwSl2oqIoEZWwoDPIdavl1BcThK/irr5rbOS+ylxhnHH5sF6fG01olByHfKCw2s3pqStBbB8CgyOActjXJ23fKeM/Fi8ciFA4qkeipUFqmDvLuHVVE8TECBnYRhIb6jeATkhn2yK2e3zCL3vv4asy/b7H3mraFt4qEXMPr2xSxO7piiZObCEfZG7ptR59WxXN3ig+DYmqO9CsC5qmBXfmwRPAHddi9P7c/ajllmSw9hZz0XX0YttxrzPQWbARXOY5vl8xTur9yhUxO5Iwp1jmoL7bb+hUJ4DEdY7wMbA/39KKogPk+vEbPj2I9eLmcPauB9fQttwrQyPfCovo71MoqrlOKx3cVMnTUe0Syh9J30KrbIQ00zOK6VD8pHyf14eb4PKgA2cWHJVIoM85QdapE2bLxWpLtgr/aArYcrWP0fnroEX3c95EAnrtZWCvp0zZ+Sa2BUN8xnJgSEHaQTZ8qhx/lrX7CzKwzQ9jWjygCjTWK75OvBVG3VaOxfSkKhMJ5kcqrXX1+KNWY+atl6+VWSYY062msL+ngiVTX94OcYi4kkC2Au22y8Z7XrEH3EmHvVOG2diaZ/F9MWwXhERWlpfXeOjCKaGSvak4po66e8Hs1eXIVzQUxYFfccA57KN2+eo1GzVNWXY3bTZTbHmSn/gT5W2dyij0dEPQzncWFVgjFlEmeWQ1pFrtAhBmD1EgIW4lvBFuOy8WuSCk+G8a4CT85lLdB3PhVxzzX3036l6rfQYJziwMg8MnOykjTJQjS7hfmyo4YDQIR9iTE6+aYfKCTYuwnUs43cthJb/183sqggx2Z4R+YhLtp4svPWhRJvMC9pcKcaP4WRnn2aN9C87EFCKuPPtgHlwomUcPHRzyv6gb3ICx4TzVh+SWSuA2fvLWJMqUSwAHvwcQjGogAZj1bAds4fHICBb/pi6JuHy6Mwn76WOEtX
 5TJmN0zn
 8VvAO8EspLq9rZ6Q36WVT+BAM5eLOiygw6eZz7dbyhrL6zhQauPSf85dTEzl1nptaUGi771HKEmBKGLi2F+d5qD0+rSFL1fvjMwnByvFo1zcRJvNCjdQMizdQzCrwgykIeN+CADRAbObzuDr0pNeZRl72LBPFBxeADHFFr0BqwYLplhh3qxVDws5liDPaDNV27mDKvY/6SAR/EfckIL5lW/HaSCO5cvn3xJi6FXGxzKG+GJCjO8GckSKwbuAkE8YUjeUeeoCtngdOqAnA20tFUs3i5dbzT85+knD/8LZOkFjnDmNRbMI6LeNWUX4GrogIXR4+ETGhbcmKS6Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alice,

On Tue, Dec 02, 2025 at 08:27:59PM +0000, Alice Ryhl wrote:
...
> diff --git a/Makefile b/Makefile
> index 96ddbaae7e12de71bcfabef4639de3a13a6e4815..5834bfd568548d1bee34b328dccce5d60f85526f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -517,6 +517,8 @@ OBJCOPY		= $(LLVM_PREFIX)llvm-objcopy$(LLVM_SUFFIX)
>  OBJDUMP		= $(LLVM_PREFIX)llvm-objdump$(LLVM_SUFFIX)
>  READELF		= $(LLVM_PREFIX)llvm-readelf$(LLVM_SUFFIX)
>  STRIP		= $(LLVM_PREFIX)llvm-strip$(LLVM_SUFFIX)
> +LLVM_LINK	= $(LLVM_PREFIX)llvm-link$(LLVM_SUFFIX)
> +LLVM_AS		= $(LLVM_PREFIX)llvm-as$(LLVM_SUFFIX)

Please keep the binutils alphabetized (i.e, put LLVM_LINK between AR and
NM).

Other than that, this seems fine from a Kbuild perspective (but I did
not look too hard).

>  else
>  CC		= $(CROSS_COMPILE)gcc
>  LD		= $(CROSS_COMPILE)ld
> @@ -625,7 +627,7 @@ export RUSTC_BOOTSTRAP := 1
>  export CLIPPY_CONF_DIR := $(srctree)
>  
>  export ARCH SRCARCH CONFIG_SHELL BASH HOSTCC KBUILD_HOSTCFLAGS CROSS_COMPILE LD CC HOSTPKG_CONFIG
> -export RUSTC RUSTDOC RUSTFMT RUSTC_OR_CLIPPY_QUIET RUSTC_OR_CLIPPY BINDGEN
> +export RUSTC RUSTDOC RUSTFMT RUSTC_OR_CLIPPY_QUIET RUSTC_OR_CLIPPY BINDGEN LLVM_LINK LLVM_AS
>  export HOSTRUSTC KBUILD_HOSTRUSTFLAGS
>  export CPP AR NM STRIP OBJCOPY OBJDUMP READELF PAHOLE RESOLVE_BTFIDS LEX YACC AWK INSTALLKERNEL
>  export PERL PYTHON3 CHECK CHECKFLAGS MAKE UTS_MACHINE HOSTCXX
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 3034e294d50df55c4003c5fa5df442f59e711bd8..e63c5eb57b049aff988419ccd12dfd99d59f5080 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -3427,6 +3427,21 @@ config RUST_KERNEL_DOCTESTS
>  
>  	  If unsure, say N.
>  
> +config RUST_INLINE_HELPERS
> +    bool "Inline C helpers into Rust crates (EXPERIMENTAL)"
> +    depends on RUST && RUSTC_CLANG_LLVM_COMPATIBLE
> +    depends on EXPERT
> +    help
> +        Links C helpers into Rust crates through LLVM IR.
> +
> +        If this option is enabled, instead of generating object files directly,
> +        rustc is asked to produce LLVM IR, which is then linked together with
> +        the LLVM IR of C helpers, before object file is generated.
> +
> +        This requires a matching LLVM version for Clang and rustc.
> +
> +        If unsure, say N.
> +

I am just curious, why would someone want (or not) to do this? This help
text does not really indicate the point of the option, just what it
does. Is it just the standard tradeoffs with inlining (potential
improvements in performance due to better optimization opportunities
versus text size increase and icache pressure) or something else?

Cheers,
Nathan


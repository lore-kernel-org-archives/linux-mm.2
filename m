Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A482EE7FDCF
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 11:49:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B15CA6B0098; Tue,  3 Feb 2026 06:49:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE9EE6B009B; Tue,  3 Feb 2026 06:49:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A171A6B009E; Tue,  3 Feb 2026 06:49:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8E66B6B0098
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 06:49:19 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 49E66140414
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 11:49:19 +0000 (UTC)
X-FDA: 84402974838.24.6A3E8F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8E26680012
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 11:49:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lXE8xwf0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770119357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h1c18SRLvnc5AeuNR31YPFtEP/qORyfNfe/vNc33tuM=;
	b=1Il4Fgsz14WKqXkyBJkSycrDCf9300kOWRPCCNgmsFV9pKsfE3QS1Hi3B3JpNx31oqfnYW
	Nu3BwlrvtJIHno0zCRbSBbWVpZrkBSz+ds3ExWEaM/sYe1uLtdo/SKq2rhcYREGJtHDwHJ
	KYXRGoKTzR4ZzeWBZqmjWyAIBm42SPU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770119357; a=rsa-sha256;
	cv=none;
	b=inc+r3jfRTegmiyLnOmi2ZN46dqIjBX19ztYdsbKKqE4Akj/mAws7qzGcvyWWQ2MaBpnm7
	e9asFODtk34obwLSwJIcwtPn0553/uD9XkIUzVPRkKSr09z/uDpleXJVcEGqHQVsVnBNUk
	OM5VZH1Yrnn1g1IfYbfzRV+dD0ZI+8c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lXE8xwf0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 467BA44186;
	Tue,  3 Feb 2026 11:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BBCC116D0;
	Tue,  3 Feb 2026 11:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770119356;
	bh=7ILxXahiaRMCy7sKKUTza8oVYDmH7ThnLjrpTuldxdU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lXE8xwf0Zxg7pR6+SwMV7ZeqkDpDkpFRX72NUdtij1MSMa3eH1pD4d4O9NBz0c97d
	 Zw0puwGCIdDoNCUr53faZV3Eqigm7YApD1DLt235tCF/X48vqHB39XlTPTcvOIGNui
	 CVQj9IwB9GzGjEwGbBpIhsyxzj5VBzzvQVUwfTM2NpKnoEjsn5iREidDAhemHufU/i
	 P3e9ywqpC3FU2jT6L/O0i55jYqnuKXN+3yqNmiva/WPCXVnAbi9IZPbHMoIwQicXy4
	 vM4x3xccLWokfQ1mlHqS4/YtVcqaUFUvVA0d4gTFX4d4UJ1pzXm4eBBJewlTPQsQab
	 Ot5sdSVYUgSKg==
Date: Tue, 3 Feb 2026 11:49:08 +0000
From: Will Deacon <will@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
	Matthew Maurer <mmaurer@google.com>, elver@google.com
Subject: Re: [PATCH v2 1/3] kbuild: rust: add
 `CONFIG_RUSTC_CLANG_LLVM_COMPATIBLE`
Message-ID: <aYHgtJ_xLeo5W-lZ@willie-the-truck>
References: <20260203-inline-helpers-v2-0-beb8547a03c9@google.com>
 <20260203-inline-helpers-v2-1-beb8547a03c9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260203-inline-helpers-v2-1-beb8547a03c9@google.com>
X-Rspamd-Queue-Id: 8E26680012
X-Stat-Signature: 9mzaipt84w67o8o8iwpucjuj6796guyk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770119357-143554
X-HE-Meta: U2FsdGVkX19oBJQMCWSmlfGr2bjrN/h21muUSZKsIITiBqSa2SGFFIvkV9ZHlu2pXIWSHsJCRlXGs/DzrLi4UKxBD8FVpk9dwAFlZ2403VnNxuwRbqeNVcFyHuy9rlP/Pi/5PSF+VlBgLAmLyksFGa2yARW3g7dhqeqSu0uZ2foMYuY7DsPPheBVApBsjDeERGVl9OXXuIwcH4KTWdnGWKWevMxGRXQYLrSNDXVTiJrUy8lyiea9NwBMm8NxWny8Qzxnd1r8TSl2Jgj8nvYHtRHdfECRnE0V9eqU7S8K4+smXNCIZ0qyjqMN+qxiCubdGwzO22QcJZQLbXUesZDiRgga0Ped6pKAvPe6zn4bC6REWMItabK7DPwdwlyuLGjSB9Tw5WiiwMgtiajMOgHbSP37UQNNP/+8I0sBAxYl+rZGLXSnRc8mCk4K0OJXPpwEzkzS2J9+9eSs7cv5B+sUy3vqIBeeSIpqKZoOynI1exyjY4kqBbIce03lG/feN2RVRS0T3PL4Qg7DNlfrmICzRxy+L31faHg2lM5JYXqRbeDy3g6vNjqTvN2x1WmBS55yhYMKJHHATrDSkluaUyQuso14BNlXpu4b7bSgkIZ0VmYH9n2/A5dVR++DYP0XiQUD2C+KUiwTYLKoeoPhJDhllGVRnKq7QLdkerQOEva7b3b+lvHARPYAGzsZE/hKm+k5l6cQdj3ztqtCNENPBrIry37kEYiA+OFI8h/ngxBum1X1hH7DfTEh2yDt0A7vuU0SEVFMyJRICr2gnN+0egDeWHNlFrOX9m9C9gMhzQ42Ny9PYCSGVmOonq12HSJVQa7WxxQCbxO2ID/8RfSpu17cuvZWyI/+pecGBHGK0Lk9TWnAR3hTqepS3YlmRoepeUMs+SHF/zBSM0MEoooYquTwXAjZVOtkSA1wts1OwtKED36yV1z9yqq9DN6HIwPoregMlIIplaKsMFs8VkhHUAt
 IXktwG1U
 cajqdCmS276O2x4TXujwEI5R0ETqBPhz3sS7zU/H/DR7FMFrqo86vIeZhd+nYfK/KiRRfhFhMIzjcazQF89ZNpFuE/5c1riClKqNQMRdhF/A7fVjDPJTlQi37sONwZ3R0aHWHQ8XKWfFug2n6JkZOGT7FSy7AMNy4P9eGuRJSZgilNJkoW/oDhhWZabhf5ZBC03SGGMNiT726sKso1ZdpeQKUMEdo7P/5M0Lj7SZxdPUdVhS98tSLCEL6FmwxBzDDr+Imehu57nZ+b4rLtN7DABgHh3Wk4Q3iaF4UxzUZYM/uyblhK/zO6pWsn606b2UVw+gdnJ4AV7z8g1p6PFH743qxEev1srlO4O3QB+yXUUWUEVInfQ+ndLi+j7Kr2aBXkDSxOAqOdXHBC4ullx2ITAWBABd1Lqq3xLAqmZbP5B/YFG575cJ9CC6yj25JWXttdqLwixspjVfeLPYVWm+Nr6IS+I0yHrnSALxTcZHJ+4cJaIVMlGAw6e2RYXhM9s9u+EGmq2tlmXHPDaxF+ObnPHGn8ZMEIlFGw09g2pQcXcq1bW83+gtlji2u8ixVEHjDw3iN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
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

Is cross-language LTO something we're actually looking at doing for the
kernel, or is this just stale help text given what you're using it for
in this series?

Will


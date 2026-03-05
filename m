Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1038F3092D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 10:26:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10E106B0088; Thu,  5 Mar 2026 05:26:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 091EB6B0089; Thu,  5 Mar 2026 05:26:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB5966B008A; Thu,  5 Mar 2026 05:26:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DA64F6B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:26:12 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 49A4613BD98
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:26:12 +0000 (UTC)
X-FDA: 84511629384.21.F6609C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4E1EA20005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:26:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GxKcrp1N;
	spf=pass (imf13.hostedemail.com: domain of nsc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nsc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772706370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=59shWrvzCYPy216TExIvl9Ztd39FVTGLj/jal3ckZ/8=;
	b=Pj/xeDSeuTJbI5RP1dv0yDYksr0MESjEFUOVAulSNr0WsvOg/zEpzsX/GealWCkKacXEUA
	CLqS3K8RUG01JmcXpKe/wKKLRbbWRqVqaFRUq0JTDWWTJ2dAAu0BdG7R4YjdSJN7LoAP7+
	TMLovUpA1r88qjPT4D96/IbdSUO2MCM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772706370; a=rsa-sha256;
	cv=none;
	b=XArDjwdHgbxQGzQixD7YChpZfuMwAYvkej9Vhz4oEPyBvPlP+ni54oY0bm+GsBN+C8/vvx
	P2KyyLykQcKhNWpmPhENF5FwV4OrWUxj9NVx4qstLfPuSuC8/0/ceSu5/GYS28RCczrduL
	TJEMlcRHn/4GQWL449Brd9lYd4IPHH8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GxKcrp1N;
	spf=pass (imf13.hostedemail.com: domain of nsc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nsc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0AF834429B;
	Thu,  5 Mar 2026 10:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D2BC116C6;
	Thu,  5 Mar 2026 10:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772706368;
	bh=mopNjxyGlc1UwRsEKNs25RNJFEbs0dSzzcVn/5Lrcpc=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=GxKcrp1NjpcJWIlYGOBMnLhrtZ6KW4d3Q0AsVsyUvzolHHPP6pu6s51wSMSIwgRS8
	 yRiD27V16apOqOOtv2fOISUXuKvkHACUrrPlr6xBqZFHu5ciJuhbc9UhQ9orhkEWDf
	 II0Y3z566YoYLMtSeEE9GRld5OIGUZcnuIdMzeiLhGWiIXEfNzNmYiMrI0B0EAL1Xk
	 iINr1gmDzlK2m7I7Eiqkt2q86r0lyXIrXhW6Vrmbz/UKLfzkURGwvNibTBARbSaz8d
	 /j1S3OI9ZMKfFUyrzCZbD+54Rz097Q/i7rTizm7UWSUaKwbdTfdVatnF8a2lHxsm+T
	 DqI3xJSMJJdfQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/3] kbuild: rust: add
 `CONFIG_RUSTC_CLANG_LLVM_COMPATIBLE`
From: Nicolas Schier <nsc@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, Will Deacon <will@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Nicolas Schier <nicolas.schier@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
 linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
 Matthew Maurer <mmaurer@google.com>
In-Reply-To: <20260203-inline-helpers-v2-1-beb8547a03c9@google.com>
References: <20260203-inline-helpers-v2-0-beb8547a03c9@google.com>
 <20260203-inline-helpers-v2-1-beb8547a03c9@google.com>
Date: Thu, 05 Mar 2026 11:12:59 +0100
Message-Id: <177270557911.104478.12699746103670684667@derry.ads.avm.de>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=1892; i=nsc@kernel.org;
 s=20250924; h=from:subject:message-id;
 bh=mopNjxyGlc1UwRsEKNs25RNJFEbs0dSzzcVn/5Lrcpc=;
 b=owEBbQKS/ZANAwAKAQdSCnAWJhJpAcsmYgBpqVctnTqdxXgENccjqWqtvxCvG/SQspXXSTbSz
 a0dBSGX4x+JAjMEAAEKAB0WIQSHQTenhzckp4G+wsYHUgpwFiYSaQUCaalXLQAKCRAHUgpwFiYS
 aSYjEAC16lSRDiDLSgS1R1i3F1HH9EHYStgMq9R4oaJFqofyb5aAQRP8jrKAFe1mp6cWxOA0IeB
 mh5i++AsAHMpukhZv3VRXZLkHM0d2mDOuk+pbPy7aw0LoDEiyOlgbVVFsyj0kuKTBkuBIVKJTZK
 fGE5bfqFJBo+MVbilCgJly6KhHcNxCAZXSSeI1It6+/NGO6HNGXferB8ZrS+DAAeTenWZSaGVYU
 F3e905Fv3wZtrGgwiGOxvGrJcWVr0hLfCuKGbIcdDpcsN4OmSOdQwQHdE1b5PJgv2t9Q18rcpv+
 XMZi6XKwTbymtUtRPAERCs/Pd6gBQAcXkjidQJ4wq2fAAr7gei5qkkU+XwWI1Z/RjSzFx0NrTdo
 7eFqBttsygDVM5ztwdUQZ/4bely1jDEISSokiyW+dNxfZnmtnxZhSWeObmg0/51QnFa5Kw7/gT2
 VKiZcDFuH+jJ/OHm2glGJYJzfybNdorAtzoxBxDkG6jchRm92ljqGoAlfVXq9PHE89oTkQKnhdh
 wOZDoD2nuxE+DkzXvIhyqA6FnrO40hUs2si+NP0diQ9AHyl9I7GuajKEqXyGv2JO7e7NDuBIuJ7
 f4AlvYDcrwpdvCyr+bk3qp+MH+w9ChuQ/AycvODpM7aWG+KMFujj2LOmi97wm0m523zi825m5LX
 jenBOCuvsxI9Oag==
X-Developer-Key: i=nsc@kernel.org; a=openpgp;
 fpr=18ED52DBE34F860EE9FBC82B7D97093255A0CE7F
X-Rspam-User: 
X-Stat-Signature: qm8h4gek7e36534kz5h55nrpfobofgnh
X-Rspamd-Queue-Id: 4E1EA20005
X-Rspamd-Server: rspam03
X-HE-Tag: 1772706370-131747
X-HE-Meta: U2FsdGVkX1848yXtg64xxSs3F4LqIy+H+IKalz1DqrF9S0059Rz3bu9atvhACEWqB2lmJc7dbPDVUIpf5m+4/46uGgbdiOdV0RESSdWIZBGKguL6A8fWZYSDlRi7bJowH5Yj28odOWHJdn1q0GyQJ44rA+BLehK6Rzbj1Nva7IZVkIn7ixQ9ibUOWjFelZnQFX7M+el+Rph4Oe8ctAMjLBjkCdDd7hmooJsONppZa0Jl6hUONFBkWotQf0JwlFJwH0LEHTZUsFnLzPyRzZbMyP/Jbp6Cp7fw3ZamFB8vuoSnXL0Nj9iovhPqL8kLTallVRb0eLhoSuAjRE6K09qKYTN6kl07sAPVvDlwip9GG0Ut0sk+YMtob/j1tNh72lkAq2VzBhRmByhQdZ1lO784dY00WBMp2lzm3C/NVsaEyArHgtSxo91IiZRrypI14SrhmrtTjlrkCudv/Ym4mgiCbjmY9rWQyYcfIcU+qx5NyIphdOsTm4jhCyjI3LsNoink7BDtDisqgE+kaXT2sfNZTqbKk0TcM8lYkj+hus1iGuUjwGJYFquCP8XihlYuKrlWxgp4tj03gzjw+jsqQRlOVTxpiiZ3M/+B5hZmm3Xx82cSYtn13v2H1oudKxjHkq/xFQvguemJfIS4hHQsLRwLS6Kg0fdw9UjWGPL7X1GCJEoL+AcuUbZoTm3Pd4Rs63O7qqr4aPHlbpwaJIXR8woZ/2hS4+lHvdnkhfg4cG2z5RuRynZ73iJF1/keq5oCWIHxbwXYWmN8W1f3z1I8kOe8Om7NLsFxeMOoCPJBNWjwgq30Oa1PeOE0feCoISgn/O7opJZC22cPsUjGGoW08+uDaP6l1pfOhFbYWKExxajjcYwxdlK0P/ApnlLYLlumDqk2kUnRBh7GW6NWF23VAvJzzG/CUmqu/X+apnPcIOwBsCPLqvMtOYuZ7IBfbD6GA/j6z4jnobSBdng+fmUNRt1
 S4JjBhuY
 /8zvmBtZtyOqzj8Uv48B1GjvCugtj/vyt0ajQonrkIOwkGSFWBbPdgkzUZRVtiC2evvza1TfWrEoNqDlj9dWmJN/h+WMmCghaasn3JQwkEPivTGF5wOQ3sby5AuAb+3dSa0XHjXRN/ngwpQ+YLAkSlmraOpJJgREUoN57kYXxldxSNR/Kd+IHKxvXi6pyDwFp1MaBxAoldXYHyDHzYnCIvheNpI+E02FoCoIXp7FPTJJ+7s9bk9khBFE7hALmzrZ3QP5tO9oDyprtBT5V85FBrXelOyN1Abd/chyEVV6+mwPtnxqpoFGxaBhxbj2VCHcGVDC5g7IaXeXGHUOzEJseLdfa4tOXueYJFpmgqYJsN+C8fSFqbsIoXjpyzoPk9SFcN+yocXQxvU5N/ee77OGO9EJXzZ7YWE5WcDfG6jpD84Icylve2onccEE+H1y099xZ9+HeRg/RlvYsmzbUb/+svweDE8GlRY0CxktPs3FbzklZpg5gzHYFflaEHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 03 Feb 2026 11:34:08 +0000, Alice Ryhl <aliceryhl@google.com> wrote:
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
> 
> ---
>  init/Kconfig | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index fa79feb8fe57..06f6b23c9fde 100644
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

Reviewed-by: Nicolas Schier <nsc@kernel.org>
Tested-by: Nicolas Schier <nsc@kernel.org>

-- 
Nicolas



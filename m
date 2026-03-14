Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73C60107BCEE
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 00:29:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFBE76B0089; Fri, 13 Mar 2026 20:29:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6186B008A; Fri, 13 Mar 2026 20:29:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA88A6B008C; Fri, 13 Mar 2026 20:29:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 991426B0089
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 20:29:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2610D1B7C23
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 00:29:00 +0000 (UTC)
X-FDA: 84542783640.06.31F0704
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7242B40012
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 00:28:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="oWVm/e4O";
	spf=pass (imf11.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773448138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0trvoHM0jecele2tx1jJwL3bhFrAh6Rs/TWW139lmaU=;
	b=lCwgYGTeZVkjt48kyLdg89WvQyDYjgWyUrogQmjvi/JI9SjBZJhzI2/GvxEHXHcX/aUTz7
	IWqVrO6JdzYY6XDIxfsA/bXe+qvklXXI+9hQwzEdEZ4I7SnCrmq21gS1s6DnjkpMYuEpQ1
	d/eidi+gvudvmPtUi9n3sSxcKJQFY7k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="oWVm/e4O";
	spf=pass (imf11.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773448138; a=rsa-sha256;
	cv=none;
	b=LIgd0zS2o6ZPClDVoRu7iMXefhuZ1776dYLauqRVPPkdSXEtaA+tAjfNZ5IHAPqZGeHQlI
	4yRaf4K4Sps0SKiyPE6/eV1/hDD2rW+ObLQnfMCozdEsjxNQTwJeiVNUvN5iUDq4aW1Tqz
	UCE5fWp2FItbqhXuOLhC3lZQMfRPnaI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A370437B1;
	Sat, 14 Mar 2026 00:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BB0C19421;
	Sat, 14 Mar 2026 00:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773448137;
	bh=zSE9ZGweC+SFIsH032TFQbSFVYRUcYwmPoW4bQHRezM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oWVm/e4OUxlj/A92kYR7Y/AIT1DbGO1/YYGUMfnA/Z/uWpoy8U+OO3g0PasfcD1sn
	 1dkin4Lmf3Mod70C/Y01YmcJKM9KZSkO2dO6hAGVwnwK97nD36PrbfDgVVGUUESddP
	 Y86zcX1El3g7ubhIuj7U3VROlk/TtvAv+BRfc6Rx8w1dJ6sd6r+JFNQ17QHRo6uA8F
	 JCc4Pb3SC53TsksyfFaZmu6jl9zTJ9TTBtu91xxeV/1WYuFwNtPdSOyGGYhIbtaaRf
	 sefWI5TJq8oIxMw7ucBmA/efI7ew9xTcs9/3yYg8J+sjUgn9KwVwqXoFRKD0yVWZls
	 qy9BslFYHmsgA==
Date: Fri, 13 Mar 2026 17:28:50 -0700
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
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/3] rust: helpers: #define __rust_helper
Message-ID: <20260314002850.GB534169@ax162>
References: <20260203-inline-helpers-v2-0-beb8547a03c9@google.com>
 <20260203-inline-helpers-v2-2-beb8547a03c9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260203-inline-helpers-v2-2-beb8547a03c9@google.com>
X-Stat-Signature: 5zdu83ndecgbbcngftsugnf9awfzw4y6
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 7242B40012
X-HE-Tag: 1773448138-877390
X-HE-Meta: U2FsdGVkX1/pt3FFXTK9zkLFqROI61vTJfVVPmM0UAKV+1UNEiPcNa6JqD+wAs6UoojcBbNbgzvu14nw9gm/V99dOsooJrjgvs+elAMhnkso2CigHlFQWMNA13Anux3s9I/6LYgjH0bAjDEhgZwmU7ZNLjRwABiylqOTA8FiUN4LSlUGZ0d7lgDFwjJSlsfBP8YWO8Eg7yYXJqb0aFIdZ80hOfCHejwcFgo4hPEA4sjD1ypW9prZIuZHtC3MNGN6PTuzy6LCJ+GAiirmNiEOvcEVdpOF2RLuMXLCDNbTG/VTyAI0sqRyYagLdEbKozlHLJxCZ06i0xtPrZtN4fwq4mO3bRELmwRTWDsq1owmzKcwfEY/49GWa0vQBCr617ZxDu0dg9lxoDeWzYXz4PjY6IWpvwbOiajgvJb9RPQilzo5MTdDYQR3fYE8vY1kFYqXWd2It0kPYSmMdkeQc9d/PiToy19dBvyGdryInzsCgSPPSXGWWEVIHUsZulPEW846+aY7fiAU5feXRAfG82rt4fL2VaZWIdlCgk8A9piWr9farxjebUkgF9evZKjmCMqHkR+yqZjDvlAu3mt1/Do57czo0aFOuH2U2IYJDFdwsYlMG2JOC8doREc0ut9ieTQZrFPolZPgXW4Fpfy8BKCnV7qDcBVjIVuDvpgPlQSiUXj4uoT6b+DoUUGZwiq/j9+4aTjLzglljIogjTyl9ILibGdf/uP559qRv9Ahkn7DknjrFxwILF5waSA8qwQ+9bLwS/alZBBfhCr/y5rx1A3vvXQrmktCn7SR5Qei/BeBNLLrHE9u9P4e3DNg+URXKK/bwT3S3EyktOW3T32k3ebF+kAIFUhZPKuKRRCkrgCadhVx9XvQe2u3WIHpqCa56KEvOXa7yxwdYrXhmm2iJxNDbrVIAED7nF+v14AQ3tCF6uBHOeO7/SU6FMhvArxEl9fVWws0rgTLoQayWPfs6jl
 zfL++NVE
 Egs2+IZSj9ULV/zkxDIjnhRMA2UBh9hQWthES8ukyoQbPULz/dY+9FHLD/gRvT/4yKmdMt0T7JZ2WNfM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 11:34:09AM +0000, Alice Ryhl wrote:
> From: Gary Guo <gary@garyguo.net>
> 
> Because of LLVM inling checks, it's generally not possible to inline a C
> helper into Rust code, even with LTO:
> 
> * LLVM doesn't want to inline functions compiled with
>   `-fno-delete-null-pointer-checks` with code compiled without. The C
>   CGUs all have this enabled and Rust CGUs don't. Inlining is okay since
>   this is one of the hardening features that does not change the ABI,
>   and we shouldn't have null pointer dereferences in these helpers.
> 
> * LLVM doesn't want to inline functions with different list of builtins. C
>   side has `-fno-builtin-wcslen`; `wcslen` is not a Rust builtin, so
>   they should be compatible, but LLVM does not perform inlining due to
>   attributes mismatch.
> 
> * clang and Rust doesn't have the exact target string. Clang generates
>   `+cmov,+cx8,+fxsr` but Rust doesn't enable them (in fact, Rust will
>   complain if `-Ctarget-feature=+cmov,+cx8,+fxsr` is used). x86-64
>   always enable these features, so they are in fact the same target
>   string, but LLVM doesn't understand this and so inlining is inhibited.
>   This can be bypassed with `--ignore-tti-inline-compatible`, but this
>   is a hidden option.
> 
> To fix this, we can add __always_inline on every helper, which skips
> these LLVM inlining checks. For this purpose, introduce a new
> __rust_helper macro that needs to be added to every helper.
> 
> Most helpers already have __rust_helper specified, but there are a few
> missing. The only consequence of this is that those specific helpers do
> not get inlined.
> 
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>

>  rust/helpers/helpers.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/rust/helpers/helpers.c b/rust/helpers/helpers.c
> index a3c42e51f00a0990bea81ebce6e99bb397ce7533..e05c6e7e4abb7e6a4c4a3a417e35022dac1d9c58 100644
> --- a/rust/helpers/helpers.c
> +++ b/rust/helpers/helpers.c
> @@ -7,7 +7,36 @@
>   * Sorted alphabetically.
>   */
>  
> +#include <linux/compiler_types.h>
> +
> +#ifdef __BINDGEN__
> +// Omit `inline` for bindgen as it ignores inline functions.
>  #define __rust_helper
> +#else
> +// The helper functions are all inline functions.
> +//
> +// We use `__always_inline` here to bypass LLVM inlining checks, in case the
> +// helpers are inlined directly into Rust CGUs.
> +//
> +// The LLVM inlining checks are false positives:
> +// * LLVM doesn't want to inline functions compiled with
> +//   `-fno-delete-null-pointer-checks` with code compiled without.
> +//   The C CGUs all have this enabled and Rust CGUs don't. Inlining is okay
> +//   since this is one of the hardening features that does not change the ABI,
> +//   and we shouldn't have null pointer dereferences in these helpers.
> +// * LLVM doesn't want to inline functions with different list of builtins. C
> +//   side has `-fno-builtin-wcslen`; `wcslen` is not a Rust builtin, so they
> +//   should be compatible, but LLVM does not perform inlining due to attributes
> +//   mismatch.
> +// * clang and Rust doesn't have the exact target string. Clang generates
> +//   `+cmov,+cx8,+fxsr` but Rust doesn't enable them (in fact, Rust will
> +//   complain if `-Ctarget-feature=+cmov,+cx8,+fxsr` is used). x86-64 always
> +//   enable these features, so they are in fact the same target string, but
> +//   LLVM doesn't understand this and so inlining is inhibited. This can be
> +//   bypassed with `--ignore-tti-inline-compatible`, but this is a hidden
> +//   option.
> +#define __rust_helper __always_inline
> +#endif
>  
>  #include "atomic.c"
>  #include "atomic_ext.c"
> 
> -- 
> 2.53.0.rc1.225.gd81095ad13-goog
> 


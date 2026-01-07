Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 592BECFD620
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 12:24:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C484A6B0088; Wed,  7 Jan 2026 07:24:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC85F6B0092; Wed,  7 Jan 2026 07:24:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFEC96B0093; Wed,  7 Jan 2026 07:24:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A09236B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:24:05 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A919B7FF9
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 12:24:05 +0000 (UTC)
X-FDA: 84305084850.22.1D36999
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id BB7AE4000F
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 12:24:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BlxGzu6R;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767788643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7UcQNwJkF+MbVdWe7DyVVQMh+eIC4Yr7T83ZlhmMUc8=;
	b=7s+DdMvTa+OytSZMbSb4gmhK6RQ88cXWa5RAgWOZ/rnwa+fP02iYmXqp+tJ2IM3aSBUOxj
	JIADVpLVsiEhNQDTyhp8/eWk5hhlsIeva1mykTFNiFj6VGQ2H5Oh8wIUorQ3mqMYb94N+S
	4CzIKjxSE6J9kEcHr/S6GTOpogShv0o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BlxGzu6R;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767788643; a=rsa-sha256;
	cv=none;
	b=vmKBEpC2veWEfo5au/lPuWipFPK8BD9cThHyPJyrUK5w6UPn0zT7Kg+BE1gp0Al4xeqJ3M
	Cof0mznq9oLbfRDOg+mMeS9WmubGWRi91fOs5ZHB7h7cNZV3ZjSDOyGYMnUrPtV1GNvtHh
	85zdu6t7w07JAF9Qn0yVbAK8/cUjXPI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C8D8460145;
	Wed,  7 Jan 2026 12:24:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A924DC4CEF7;
	Wed,  7 Jan 2026 12:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767788642;
	bh=Bvupu5pKUncAhUJLwMsrNMafTyDGF9I/qKF4dtQzIQo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=BlxGzu6RX/AW2lkS5MSu6xZbB2eEgdcN+jse48bS4whRSSv2gXFzrGqnwOdjnT+HF
	 lNJoKD1g8jKBEA2Ba5fUCq1PURT3ARECFeQH7UH+I2hSuHX+xuHbMJucbYvK8jAiD5
	 vvlA/RaA+em7AaVAdk11OllE9r8e6oAEQ9Ya/kFTUda5jKRkaHNufwgwbuBBcSRASL
	 QtfYFxiHK4610hJBt39SFuFQcEd4LrhtviMsDshaFDyKbN07U51gDpOk1X84POnO6k
	 UJvR8c1yqoaEWmS3SotJ9ymLG76mFHUtkEvALM9tt2q9jXsUpzg1rBn4cpkF1fdKJL
	 tiAr5va5WK6og==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Gary Guo <gary@garyguo.net>, Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 =?utf-8?Q?Bj=C3=B6rn?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin
 <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, Danilo Krummrich
 <dakr@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, Will Deacon
 <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Mark Rutland
 <mark.rutland@arm.com>, Nathan
 Chancellor <nathan@kernel.org>, Nick Desaulniers
 <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>,
 Justin
 Stitt <justinstitt@google.com>, Nicolas Schier <nicolas.schier@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki
 <urezki@gmail.com>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
 linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
 nouveau@lists.freedesktop.org, Matthew Maurer <mmaurer@google.com>
Subject: Re: [PATCH 4/4] build: rust: provide an option to inline C helpers
 into Rust
In-Reply-To: <20251203180955.20b41904.gary@garyguo.net>
References: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
 <20251202-inline-helpers-v1-4-879dae33a66a@google.com>
 <20251203180955.20b41904.gary@garyguo.net>
Date: Wed, 07 Jan 2026 13:10:07 +0100
Message-ID: <87344hipy8.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BB7AE4000F
X-Stat-Signature: xr31w7rr7fwyaqyop8f3qzw9o6ihnpt7
X-Rspam-User: 
X-HE-Tag: 1767788643-330060
X-HE-Meta: U2FsdGVkX18MtqtJg+sYulvhN1odDWsGt1xynu/mv77LiRXoc7xp5Bb70ThJkfgL1kerxUB5eds6nVoKM+Dv5jiiJtHQ9F09jsFeDYiLSK/0EEcfummtm9lJNFknQJnntKvdnELLChu2jaiOO9nqjBe8mmSNJ78xe2ShLUi9DuQuyuuf3INqPA2Plx9fpVI/L4E46B2utteRmrOfkXuhCDmvBhWP7PfpUIbhFYM3w2AlsTnubdjr7U6yQC5aejcUjFv1bRkg3tV1+TkBGhNodbEeFbEyxcHpR7PQ/GC4usRqBOJKcNXf+1aC2f5O/rhbdLfaL9qepH4+WMZu5W3vpY2j6rVD+xizGkBKtt9MlcnsYi3OAN63InbFifEHh01yq8HWZdDgL/ne1YPidxElnjrYh9Uz2rlX0lsWZBwSq3bDnDX/FFVZwxW3P4Ov0y+OWKicFlMcVHxyEQy0HYyjmD+hztGBYJnGMOFaVCIc0XLV1TBQT9HIFDNm9YTiQRocMj3G/aw2w5nDO0uCz4sOHgROY1sSjqbIMP8+uKtIE5j6prdHN90+9qu9N9EyEmZH9QsNhgHfJo1kpfTKp/cHvE8PRasyQn8/PAfR4CYeW7Jq1WFaoqsUO8HywnK6/0OFLrOq+07w3Pvpz9Nl2OMfxp8m7jd9qLCnJh6EEFxEhA9Vo31p2lzmbbnlQosI/GjX1tfOC1syDyx2NKsj83P6mB+AjEoyWJTxR/GlFos1pyVU+y8mdJPhFZ3cXImORUffaAafpVCvLuC2KHXBBvnwoVHzI6+SdQ2+LTvZ2NMVNXcM6OMOWsYzRWi3W65zakMFao3B5aJFB1zi5Ul9PqqZNkCrl+RWUrteJ06vT9fYjP4x7bBK0n+/zs8hdlMIDmQizPPLfj0pWBK/AQHgHdh7tHd7WFLPrtmKrJV+yWuDPCemNDyQbcsl0KuQl/bVBLuGLYM6UvWrU75OItkom7h
 6Sii+rqS
 5pxfeLzIVG0SGMYIT53hy8MQMtB6iQ8xRBC9fFOvpUOkkQRX40rMc0wukBC0i5mD8oCUtETFM4+o2FCScpyl62mXLbXUnVzuH6Bys+YJZigYcxUgBTgen5MR8WTEJpM8VH0RfLZnf0eehfB2chhQAIy96Iax9oLHnzW1WDBxVwQqP23LMeOPtpMEJsJtRBfG/G81TSlmwYRf9ktVxAhEyx/o9v4dxC+CuzzJ4DItlQou24QcDfFxmQV1eqYQ2ltp6tjtmhaANFlGLYbevSDu8kI41Ea2ZOoOIM5twXxBEiNDkyV+YCqN6bl2QXr79gcbnMpIRS+eIerXW1OeFtswVEOdetw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gary Guo <gary@garyguo.net> writes:

> On Tue, 02 Dec 2025 20:27:59 +0000
> Alice Ryhl <aliceryhl@google.com> wrote:
>
>> From: Gary Guo <gary@garyguo.net>
>> 
>> A new experimental Kconfig option, `RUST_INLINE_HELPERS` is added to
>> allow C helpers (which were created to allow Rust to call into
>> inline/macro C functions without having to re-implement the logic in
>> Rust) to be inlined into Rust crates without performing global LTO.
>> 
>> If the option is enabled, the following is performed:
>> * For helpers, instead of compiling them to an object file to be linked
>>   into vmlinux, they're compiled to LLVM IR.
>> * The LLVM IR is compiled to bitcode (This is step is not necessary, but
>>   is a performance optimisation to prevent LLVM from always have to
>>   reparse the same IR).
>> * When a Rust crate is compiled, instead of generating an object file, we
>>   ask LLVM bitcode to be generated.
>> * llvm-link is invoked with --internalize to combine the helper bitcode
>>   with the crate bitcode. This step is similar to LTO, but this is much
>>   faster since it only needs to inline the helpers.
>> * clang is invoked to turn the combined bitcode into a final object file.
>> 
>> The --internalize flag tells llvm-link to treat all symbols in
>> helpers.bc using `internal` linkage. This matches the behavior of
>> `clang` on `static inline` functions, and avoids exporting the symbol
>> from the object file.
>
> Huge shout-out to Matthew for discovering this option, this makes thing
> so much nicer and it feels way less hacky and more reliable now.
>
>> 
>> To ensure that RUST_INLINE_HELPERS is not incompatible with BTF, we pass
>> the -g0 flag when building helpers. See commit 5daa0c35a1f0 ("rust:
>> Disallow BTF generation with Rust + LTO") for details.
>
> Again this is a much nicer way to workaround the issue than changing
> the language name in the DWARF info using text replacement that I come
> up with :)
>
>> 
>> We have an intended triple mismatch of `aarch64-unknown-none` vs
>> `aarch64-unknown-linux-gnu`, so we suppress the warning.
>> 
>> Co-developed-by: Boqun Feng <boqun.feng@gmail.com>
>> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
>> Co-developed-by: Matthew Maurer <mmaurer@google.com>
>> Signed-off-by: Matthew Maurer <mmaurer@google.com>
>> Signed-off-by: Gary Guo <gary@garyguo.net>
>> Co-developed-by: Alice Ryhl <aliceryhl@google.com>
>> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
>> ---
>>  Makefile               |  4 +++-
>>  lib/Kconfig.debug      | 15 +++++++++++++++
>>  rust/Makefile          | 26 ++++++++++++++++++++++----
>>  rust/exports.c         |  5 ++++-
>>  scripts/Makefile.build |  5 ++++-
>>  5 files changed, 48 insertions(+), 7 deletions(-)
>> 
>> diff --git a/Makefile b/Makefile
>> index 96ddbaae7e12de71bcfabef4639de3a13a6e4815..5834bfd568548d1bee34b328dccce5d60f85526f 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -517,6 +517,8 @@ OBJCOPY		= $(LLVM_PREFIX)llvm-objcopy$(LLVM_SUFFIX)
>>  OBJDUMP		= $(LLVM_PREFIX)llvm-objdump$(LLVM_SUFFIX)
>>  READELF		= $(LLVM_PREFIX)llvm-readelf$(LLVM_SUFFIX)
>>  STRIP		= $(LLVM_PREFIX)llvm-strip$(LLVM_SUFFIX)
>> +LLVM_LINK	= $(LLVM_PREFIX)llvm-link$(LLVM_SUFFIX)
>> +LLVM_AS		= $(LLVM_PREFIX)llvm-as$(LLVM_SUFFIX)
>
> I think this is no longer needed as we only use LLVM BC now without
> having to round-trip between LLVM IR.
>

We should update the commit message to reflect this as well.


Best regards,
Andreas Hindborg





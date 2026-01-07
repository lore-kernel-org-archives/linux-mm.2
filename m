Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCEF9CFD626
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 13:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 210F26B0092; Wed,  7 Jan 2026 08:12:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BEA66B0093; Wed,  7 Jan 2026 08:12:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BE906B0095; Wed,  7 Jan 2026 08:12:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ED5946B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 08:12:30 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 20D9E587C8
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 13:12:30 +0000 (UTC)
X-FDA: 84305206860.26.A8F49BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8A8FA18000B
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 13:12:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SMpNz00V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767791548; a=rsa-sha256;
	cv=none;
	b=mrF37E7153pMXkG3KjkGnLYTaOJjEJSYZCmnE4PeJKnFwGOPDBen8i25D4nlRQTIu1tQD7
	YI3RXS+rtheFp1qpzf9Pmvk/7W2PjGS1rhNnZyUDKbB95sesWbZGnllniUYMoi8rRo4UTq
	/5W6Wz18FCod8Z4OdeI0ex1MQL07UAc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SMpNz00V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767791548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nH1lIKowpY71IyFBqdjo2R6v53N3f0jy/DRCKOUdr3Q=;
	b=IpruEt9GtyUeWFNT6kKWZvZkFuIGsDAPSWzQOqifBBMgjZ0Z5iKRqygrUCqWe0EELLLBud
	yzQB62PszWPcsbcF8bhJQrlB0fZSlPFCQJ/apkxWex65Sz34ry4VpD/g+lfWO8UpatmVLd
	8wO7TYbjvuII88OAGeM+9Mx/8vuyb+A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ADD756001A;
	Wed,  7 Jan 2026 13:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04516C4CEF7;
	Wed,  7 Jan 2026 13:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767791547;
	bh=nH1lIKowpY71IyFBqdjo2R6v53N3f0jy/DRCKOUdr3Q=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=SMpNz00VTY3IuWA9a30byLgzg6Yh6ZcTskIv7FxF7xT2ePEReH5jjvCRfdAV+cLh5
	 LwAzR/q1D8c/FAIqW0CctIwkKCcYV6SSZp/DKqTOsxpizdy5ADaYtVVgm3hwilByhW
	 6Fz3VwIocRheTWtQhyXxMg7P7dM5WD9EXcnxEEM2eo9l7W6/S5Qms6cPOtnDtXX9J5
	 VQh0/DfofvY8PKQQYfwzzs3swf0Yk+8tqNOpKKvQo2PzBoOFcbTvvimJ+onwZYWKIb
	 B/tUp3pqY5pcDKygMahUQ+grzc1hNfzFT5Q/CkPIpGCm/dXEEJTXTTNOlB67ZEwOPV
	 8nTNltf5UqWUw==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Alexandre
 Courbot <acourbot@nvidia.com>, Will Deacon <will@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, Nathan
 Chancellor <nathan@kernel.org>, Nick Desaulniers
 <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>,
 Justin Stitt <justinstitt@google.com>, Nicolas Schier
 <nicolas.schier@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
 linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
 nouveau@lists.freedesktop.org, Matthew Maurer <mmaurer@google.com>
Subject: Re: [PATCH 0/4] Inline helpers into Rust without full LTO
In-Reply-To: <20260107123528.GF2393663@noisy.programming.kicks-ass.net>
References: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
 <87y0m9har9.fsf@t14s.mail-host-address-is-not-set>
 <QViERQV7XT0BjTfSSyP6vzQc4AYxosyF5TEZ5kRu8AVWjmGCP_5n5V2AV2hjqVza8-jvzyquH3JLJA1zvbRD9w==@protonmail.internalid>
 <20260107123528.GF2393663@noisy.programming.kicks-ass.net>
Date: Wed, 07 Jan 2026 14:12:10 +0100
Message-ID: <87sechh8id.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A8FA18000B
X-Rspamd-Server: rspam10
X-Stat-Signature: 4h7sbrfrf33e17y69st5sa6wrd5wzerd
X-HE-Tag: 1767791548-324564
X-HE-Meta: U2FsdGVkX19LeacjXBMei6TrkajRczYIFp/MT5lNMtTx6jzg03ea03InGOj8G74H7DNBd+QYsmIrCs9TTpjnSzU0QXSjvKCBxJT8aguZGfbXEpUVo0xk2+aZUZn6OF2XVQlDjSHaDFa9e7bg4FqEB++tLPb8tVn0lDSH+EnSQiH3pV6oPYeNti3wwJ+unONPLib0xM+FTdVYgm1vuKGcWwldCLYNsLcxBRLEwww7hR2cX/YsMlYg88s768Y5XIb0ND089JU1y6zjqSLBjc3O+d+8lICogHQ5m6bU1Eg05Xor3ou55UmCPyE088+SMdU/GnkhOGN2oNXgk9VKLXbKRoKNnTkc6wEiRpOwhDtFJcRBwM0n7Et7mUfpMJ/7eZQB1Xhkdpf9Tg01qDwwWM6vhojQSBMKkgKo89g5nQx6ZwKJ1zcM62B1Q2BLzLv4mFvyZ6AiaftAqRoFMys+O+BpN5G1+AJ2PRUsfCgH/k9e1wENoYcdv73Azh1TmS2PVxbHDDizC6cpBhOor9VovdGpa//Cnj+rjdTxjiDaRiTgy7aeGCgFGGHS6SmW2Vh1gyYEAUCgot65LK8ZNj+m4AG48ZduK/dhUfhsw4Rk67msa0ja7tL0aBbPvT5W2hrG8HFmFio8fV+qDyGp1mRk3Qyg7G8/hKkmTABEU2+LeRdGnOVLMuVeXdR7kNAc+jHSy0NurP12bKAqJePKuj1p4lPN12rSWgxMMSkjXXsYndi9mr38i+g5f6/Pwi9aam5v/JrdWK7xWlv573Mp17mnrbyeK7jqN6+goF17hamqxS7+QjQCb6Xq4Hi5pMUajcnzR5BadrfH47+b2aOms/xKAKqs4mNWRtlUr8iweYljMjJMwsgSh/HmMDqlB8PKCvfzXnFuXK0M+wbP+xFyzszJwh9bOE3D2EUaB4CawRKbr0i4YHEkMb8xnmZTFadLQX/5RuI1hkPdjLPsyU4Wl3xhwEa
 vev2Z8ub
 6FcB5xjbJINjsgNkdehRJiD+R4MWkTmiPetxvi5dDof2EgXLZ6f9q+dWgt8kSn6GArRSftikp4JKqYQGStME23ETEdc6Ad0fSbMxKzGedg8AH62YWCu5QX896AZh6IdK9a/KuJyL11L7y5FuV6zAAbX2NepVeR64ZKDSGbIzrmTWtLjYey8kVcsqQteSG5qPuzNPEmoY2rHzk8fet2DzXI5snb1Co2DIFjdsrqhTak5V/rlseUqH9CdxHCzMQSIbPLAEcXjfPEvm63cMqzWOSvlCFFWaHZ4qcfxyP4HQD0YGm8+SSVk32hnn0TYtGoG3HXkHXsGQ5XpsPg77u31O1qJU0yA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Peter Zijlstra" <peterz@infradead.org> writes:

> On Wed, Jan 07, 2026 at 01:23:38PM +0100, Andreas Hindborg wrote:
>> Hi Alice,
>>
>> Alice Ryhl <aliceryhl@google.com> writes:
>>
>> > Currently the only way for Rust code to call a static inline function is
>> > to go through a helper in rust/helpers/. This introduces performance
>> > costs due to additional function calls and also clutters backtraces and
>> > flame graphs with helper symbols.
>> >
>> > To get rid of these helper symbols, provide functionality to inline
>> > helpers into Rust using llvm-link. This option complements full LTO, by
>> > being much cheaper and avoiding incompatibility with BTF.
>> >
>> > I ran a microbenchmark showing the benefit of this. All the benchmark
>> > does is call refcount_inc() in a loop. This was chosen since refcounting
>> > is quite hot in Binder. The results are that Rust spends 6.35 ns per
>> > call vs 5.73 ns per call in C. When enabling this option, the two
>> > languages become equally fast, and disassembly confirms the exact same
>> > machine code is used (in particular there is no call to
>> > rust_helper_refcount_inc). Benchmarking Binder also results in an
>> > improvement from this change.
>> >
>> > This patch is complementary to:
>> > https://lore.kernel.org/all/20251202-define-rust-helper-v1-0-a2e13cbc17a6@google.com/
>> >
>> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
>>
>> I get the following modpost errors when building with this applied on top
>> of v6.19-rc4:
>>
>> ERROR: modpost: "__SCK__WARN_trap" [drivers/gpu/drm/nova/nova.ko] undefined!
>> ERROR: modpost: "__SCK__WARN_trap" [drivers/gpu/nova-core/nova_core.ko] undefined!
>> ERROR: modpost: "__SCK__WARN_trap" [drivers/block/rnull/rnull_mod.ko] undefined!
>> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_minimal.ko] undefined!
>> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_misc_device.ko] undefined!
>> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_print.ko] undefined!
>> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_dma.ko] undefined!
>> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_driver_pci.ko] undefined!
>> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_driver_platform.ko] undefined!
>> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_driver_faux.ko] undefined!
>
> Looks like it used the wrong static_call_mod() version, was MODULE
> defined?

CONFIG_MODULES=y, yes

I built without the patch first, then applied the series, enabled the
option via menuconfig and ran the build. I thought maybe some dependency
check is messed up so I retried the build from a clean state. Same
result.


Best regards,
Andreas Hindborg





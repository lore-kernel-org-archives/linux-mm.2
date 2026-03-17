Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFA12F3380F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 08:26:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9630E6B008A; Tue, 17 Mar 2026 04:26:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E6626B0092; Tue, 17 Mar 2026 04:26:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AD826B0093; Tue, 17 Mar 2026 04:26:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 67AB66B008A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:26:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 18A2259671
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:26:03 +0000 (UTC)
X-FDA: 84554872206.07.F9CF3A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 95A34C0003
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:26:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="eUcG/RcM";
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773735961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6HCO5uPSGeOaMZcJw6nr0BVRKGBfSPMmN8QCDipCPTc=;
	b=QFsniY/MLRCvgm8CUHKKx1mo2M975Qux7nOiebxKt+QHsCmwFs56XMI5Q6v/GXoF/28P2f
	3OlQsTLWkYPMcdu/X9yWLmislpVZMWm5KrtqTZHP93Yt0fDA2X2Ou3GIXGaWIbNxtacTrM
	g3dSXJB3WmlMIfPVCpfbzeX/5hNJ0KQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="eUcG/RcM";
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773735961; a=rsa-sha256;
	cv=none;
	b=zupt1G9vh2skc6DZCLEpyKPFMHw1qWsTmsR0+Ziky8AW5mi65PNJcpVJWts/G/9i2gXekT
	XdCpjH97Xkva7CJg1kVFt59VR9Bmzjyh21VCZw+x1JzXrm0S7zyi+8VNIScNXq1MLfXzOB
	TJFUWRTlVlIfynXRhRi2E5e7nKQW88o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 00F2A60133;
	Tue, 17 Mar 2026 08:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B294C4CEF7;
	Tue, 17 Mar 2026 08:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773735960;
	bh=6HCO5uPSGeOaMZcJw6nr0BVRKGBfSPMmN8QCDipCPTc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=eUcG/RcMZtaj14Gihl0G/ahNqH+BeBeIakaQmbDtYO95yN5aBqlhS17SCZzXnqzSK
	 tt4jainE8Ae1JjEz4Bx8Txdi21R2Cxvbv4UFiCLGf7S/Ii3s130y0a+ef53ttNF6j8
	 oyWVVSe++PFiYUTROTpRvwUfy/XNQ8hxvxAl+Oa3lvFmbbkqz2PRmBzn8Kvxu6U4Qt
	 /FQIywhewBIhiwmhr4xFiRqep87IBrnz3mMnEUrUbVTBmqrVfE8Q5PJ4Z115yrGWCP
	 gCNlJlV+Cu9SKs8x55zjEd2KAfQCjuzWT7rRhxMYULSWdOXlpAL89d8jKX8EOtcufk
	 /w0Pdf6T7O37g==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Alexandre Courbot <acourbot@nvidia.com>, Will Deacon <will@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Mark Rutland
 <mark.rutland@arm.com>, Nathan Chancellor <nathan@kernel.org>, Nick
 Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling
 <morbo@google.com>, Justin Stitt <justinstitt@google.com>, Nicolas Schier
 <nicolas.schier@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
 linux-kbuild@vger.kernel.org, linux-mm@kvack.org, Alice Ryhl
 <aliceryhl@google.com>, Matthew Maurer <mmaurer@google.com>
Subject: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
In-Reply-To: <20260203-inline-helpers-v2-0-beb8547a03c9@google.com>
References: <20260203-inline-helpers-v2-0-beb8547a03c9@google.com>
Date: Tue, 17 Mar 2026 09:25:42 +0100
Message-ID: <877brasvzt.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 95A34C0003
X-Stat-Signature: p3de5w5dh5ax79cnz7f5mpzd8cup7yyr
X-Rspam-User: 
X-HE-Tag: 1773735961-955787
X-HE-Meta: U2FsdGVkX19Ueflzp+f1pf9cZGSBAk5Xl5jiH2Pnnk5+kG/oPwXla9W3sqbAvLQRvHLBIbZCOE34PSLoNeceOPqi73xXcrqTXzEOFkbRn95YyAyToyaTp5tqdaWO+ENk+W+y0rPyoL7BZkIRSPNexgzNc/yjNzBrVlhwh6TitAjEWqJT1fl9Rs/QwG0Q6Y1sf/mdfwufc3ZmrPcqt3yT12BWMCgTGLVz/b0vsgjwF4+Sadr6J0kv5vi3YxbhbaBPKU97qPxejgdybdBRKstyV9ejnvgEfhucR8/dtAGw1NbjfJNWCMH39ZsQK0nHis/g7pgPpRSyPIClVrBvcfArCg85/RBSXnNC3NrT4o0NT5XeaOLm7C7m5zQ9WFofgKktXPuiB41uQbqj5nSaOngTm88LU02SyfjUbJ/a64iNK3MVBs28P3LOb/R7fuLtpuyTMPFcA42j7D8OBtgtsRnVYSNx8A/sWpdJ4Ru57im7caPFn8tWLACXg3Tnn3993w6w8Vf7EgiMxM93wGjPbae2RFAwU62quDOrxAxU77MQ/4JhtJsyl3lsCGUmhLSUrf1QcbPJzPVV/Tn7SY3bIgp45j6jil1tPl46qFRM3pZeBHXrjOHSk8Ubt9PQNrg9quOr87mWM21pZ4KBj2SCJqgpMF6jqpo4YHYaC3K8xOAZTlMPJw68L+1gHFigJ0rdqGimWDEdka1tYeVfuEN7qFp9eoh1YeOVjsdZXMC91BAwQf0WllwmfeCDTX30IzQdzTzPyUwZqfocI6SEm2hxBGqUOho387GrJTILgnGFXWBph62EJvIJa0JnSeN9E059IM6KYBKQS+wKa5YJfUmHOUfZcrLOsFlPYutUL6m0IpHyhihvQmpLLI/YJcwNq/mUB7E2KPtwCbZFmFPQHFLu/s8aAw0GHbd16P9k6nhziHKEQEyjFbLM/+h3932O7HPTl8bYLrRQJ1wXDXfEmRiEoP7
 2NIb03W3
 y+FU40ZHX/xjQpwqmYTaHl+Iv17jRe9c5ME3tRw72vqNIGP9Ns3okLPM9A4lhAr3Tj+EXwe27g4HjT1vJ2DabV7/DdRAVaET4GlPUY5pFN9Zsv204gxdNFDpVotgALTCHna711MmEot5C77IHHi7Z5PdO+bykxnoJUOiShs7IwNhle8eej+3wrUi1CDnl9Onvyhn3nroa9Rqcl3BX93tYuag3DDstxoFZ6s801BInC1fRAXAJc469jtvanzx1W86Yvm0t9rKIx8U/VbTwMdUwAKgq8ceQ9O8LBzy8fmWq41x7qCWosz6sArrU5MoVxcxuAm0HePdR8lKTlzNvr3aSBa6AfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alice Ryhl <aliceryhl@google.com> writes:

> Currently the only way for Rust code to call a static inline function is
> to go through a helper in rust/helpers/. This introduces performance
> costs due to additional function calls and also clutters backtraces and
> flame graphs with helper symbols.
>
> To get rid of these helper symbols, provide functionality to inline
> helpers into Rust using llvm-link. This option complements full LTO, by
> being much cheaper and avoiding incompatibility with BTF.
>
> I ran a microbenchmark showing the benefit of this. All the benchmark
> does is call refcount_inc() in a loop. This was chosen since refcounting
> is quite hot in Binder. The results are that Rust spends 6.35 ns per
> call vs 5.73 ns per call in C. When enabling this option, the two
> languages become equally fast, and disassembly confirms the exact same
> machine code is used (in particular there is no call to
> rust_helper_refcount_inc). Benchmarking Binder also results in an
> improvement from this change.
>
> This patch is complementary to:
> https://lore.kernel.org/all/20251202-define-rust-helper-v1-0-a2e13cbc17a6@google.com/
>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>


Tested-by: Andreas Hindborg <a.hindborg@kernel.org>
Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>

Tested with the rust null block driver patch series [1]. I did a
few functional verification tests and a set of performance tests.

For the rnull driver, enabling helper inlining with this patch gives an
average speedup of 2% over the set of 120 workloads that we publish on
[2].

Best regards,
Andreas Hindborg

[1] https://lore.kernel.org/rust-for-linux/20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org/
[2] https://rust-for-linux.com/null-block-driver



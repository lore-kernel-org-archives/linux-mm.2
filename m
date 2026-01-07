Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B12FCEFD1E
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 12:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E9DD6B0005; Wed,  7 Jan 2026 07:24:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6945F6B0088; Wed,  7 Jan 2026 07:24:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A4296B0092; Wed,  7 Jan 2026 07:24:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 482506B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:24:00 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1508B8B340
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 12:24:00 +0000 (UTC)
X-FDA: 84305084640.06.A6E8FC4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 59AF910000E
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 12:23:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jsilMsD9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767788638; a=rsa-sha256;
	cv=none;
	b=CQXGLME4yqgFKQhyi2ZkaBnGrqGFg/+iC0YIqNkz4q8GPFsOUi7X85yGTTIsGX9XB93aRe
	jE5/IVz7JhHGH6kNPo+sSpzO03yP7/DSLesxuz7hfHOT/iUu6bedfgHU2AJO3RoxlCn01g
	ktuNsxVAqz2FuY/5THmsY6Zh+ZkcpWQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jsilMsD9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767788638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZtM1KRXrNZPIjs0BP4nXfJn9/N+qtrTbb5tiAYIPzg=;
	b=faZjRnR6DrAIGVI4NohHTOrHlGTgntD60mrcwONV17a5dmsN0rGzLYft0oiBsDzJRzHkai
	xs+MMs7ft5xShewyVc2EjNXVyrPycnQh6DcUnJyzTCnqm+Ja6dmjVaDxcm1xOiOpbUXVep
	/Gxbgl6W7BeH5il4Ojaawg47Mh+kKVE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 33A9B43403;
	Wed,  7 Jan 2026 12:23:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0535EC16AAE;
	Wed,  7 Jan 2026 12:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767788637;
	bh=mZtM1KRXrNZPIjs0BP4nXfJn9/N+qtrTbb5tiAYIPzg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=jsilMsD9MU5vYOo+CLDlCD4K1PG/wWHtloGE+yTehzPOpuQxbC4VkaA5SDbLGwG+8
	 NoGTAZRmkN3B/N39tcHxDRacYTzE26znGZWG6DK9P1a24yxnyGqNw0NGTEOhL1cCDn
	 dVkYCJTcJdvV3AnC31ROUCNjK4WzEK0Rk0A3pfxYacTnTIJob6V5LNMiBdaFubd085
	 h58fmGlG/jR4aWt0H5ONm3dEZ3oYNYGVyM2DPPqpSr3sUsMbKs8GEZ9tdE6s4vMFND
	 iGZ/LYsMAQDMLzqD2kCZmCnwKYXfvcW8VkBSm798XIEDL42GwbPYWgMt8mfXEV8FTI
	 M5SK7HdQJxaaw==
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
 linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
 nouveau@lists.freedesktop.org, Alice Ryhl <aliceryhl@google.com>, Matthew
 Maurer <mmaurer@google.com>
Subject: Re: [PATCH 0/4] Inline helpers into Rust without full LTO
In-Reply-To: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
References: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
Date: Wed, 07 Jan 2026 13:23:38 +0100
Message-ID: <87y0m9har9.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 59AF910000E
X-Rspamd-Server: rspam03
X-Stat-Signature: f1tod9gmjqt6nwdtqqnpg8r4k4pe7cwt
X-Rspam-User: 
X-HE-Tag: 1767788638-32597
X-HE-Meta: U2FsdGVkX1+Prh5N3nSHTfRAVYBgFPiGDiKmiTrZhbkDQ8WQYB2w8atxlwVBc1eQDVe8QBjmevJONfL0jLvna894yc6F9CtMtY2nbvJjB5DH8BYj2Zvz2PBXFK5T1KrfNv3u1VQcyqczfrRIfDrB0l1OCYWWe+ugA+RKhF3/A7lx9LNu9wNAXE8ZDg4l87/uPHBkUJYLyEHOp48VhOoqr0MXuvlbhQe4beGSCRb7N7tCQVrxpoRWSGngMpW3Sd6Bcfm4fYUKpzRIlIEkODH+lBbzvNlO/L/B5SgFnYzUmzke4p7bVGBk4cxXWz4v2i3FBxqElRNDIsYVCG3mv2s+dSznqrPj/R9dF2XBu217AONGnwl25/sG/irWMF45WtTypEmjjgcQEgM5oX4NeTHlRFW2rruPbvNQAC3v37ufefYLXevMxJHxicsoDRJ7Thu+c2wcHp9s5yxEaRU6m3zyFF9uF/yXJLQMt8US0kUHx9X4Q4YsPV7v+PHnbqW1mtXjEaJlv8bBR6q7vOHDePB6qB0y1kQORR5mtQ+jSLJJjTuqknmnfCE3G9aw1Fp9jayf4kEQAWqRJkSaM4+NOCVWLEk2bUY+h5pRz7MUvGQrYF2P8235YEnUirM0zYYY9Wcz31sPM/fO6cr9IbyhfNkVvY47T65QTmtI2hPYEH0wv2fVQHo8QYTaVqGcRwo1e2aBeS+HVllWfe/8NXU5ji3vtuePUkHNEXOIXqTk70txdK8UpZsHlTwqzNvHh6nIkmaj/QH1k2AMmxeKt44hufD7d4VKLZYBNBxsp/26M0f4vo8S5E4qaDSfJZMo6yFMjbKg9CP/rIyqIVoPBB+xYSNMc57zw7zP0ICa4JF3A9vOM2FnACvOVgBD5ox5XQ6+z1pC8O7J9RtPuEy4YvG1yDcYVsDVdqY2JJ3muhRCjDvhA/yjEiaevZgOZZ/Krt6gYJ6Jhwsl0gkva6tIQ6IKz1b
 S6rREix/
 7cgZgL2UfEqnwqrocu/19oyskgBwNY5PqwyufoQxQwjEi9ROCfhtPBeBHYx4GsXmFcgqPOw+3MC6TeHnEJtonkQrT0j8YLpnoJOaIrflg1S+YS9JnjwyBA3CewXnwahYj0J58WDKMDV5UAzJvFdqG3Qlt26/08fGDHywZA7bxX6zcTHBY2l1a2Z2Vcgfg2tm7SdSJEtR/tXDrJR58/ryFTnjzr+ONb3PJkvmpZg7n0lx9tAep5OXeUrpzDVrMp3v8QLtt84qn47Ui3lXFeyGTZI0gBqJmwGBuI/gs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alice,

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

I get the following modpost errors when building with this applied on top
of v6.19-rc4:

ERROR: modpost: "__SCK__WARN_trap" [drivers/gpu/drm/nova/nova.ko] undefined!
ERROR: modpost: "__SCK__WARN_trap" [drivers/gpu/nova-core/nova_core.ko] undefined!
ERROR: modpost: "__SCK__WARN_trap" [drivers/block/rnull/rnull_mod.ko] undefined!
ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_minimal.ko] undefined!
ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_misc_device.ko] undefined!
ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_print.ko] undefined!
ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_dma.ko] undefined!
ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_driver_pci.ko] undefined!
ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_driver_platform.ko] undefined!
ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_driver_faux.ko] undefined!

I also applied the series adding the inline macro [1].


Best regards,
Andreas Hindborg


[1] https://lore.kernel.org/rust-for-linux/20260105-define-rust-helper-v2-0-51da5f454a67@google.com/



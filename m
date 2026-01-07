Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C220CCFD620
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 12:24:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 361C06B0093; Wed,  7 Jan 2026 07:24:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 315D46B0095; Wed,  7 Jan 2026 07:24:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 218BD6B0096; Wed,  7 Jan 2026 07:24:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0E85B6B0093
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:24:11 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A8A92C17EB
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 12:24:10 +0000 (UTC)
X-FDA: 84305085060.15.D5B4E0A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 01373180003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 12:24:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YT7lKsIL;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767788649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rpMX6bcbnkjTfRRLH8ed45IhO+hjVV00iT/F+u9RrCA=;
	b=J0KYwDWQviIVQBwhVu1LwR0pSa0WueUk0/jT68UThLwtwwwSCvHYu9TLYJxQ3Fs8H7kK18
	KiejFsFilRWZ9ctL2mIvqSrrImd53/WkCZ5123Mflh3CAXMoDepOrY/15ORLMd+tElzVym
	cMxIZ8km/J4YC7H4lSp/LIpIBLBtMI0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YT7lKsIL;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767788649; a=rsa-sha256;
	cv=none;
	b=q7kE8J4WoGC3He3DFWxNdyZngSpUbM7VK2bj7iexH2XNRdaKEqKw9PBm28iLvLRIy8pnYO
	ZRm6sGFHabYg588P6vwxoU7TY1lPI5eUpaqHQrSVTE8qm7yFofGNZ8JAkmSR0/mvQ2T7qD
	9BxgteSq2K+aCXCiF/Ol5rG2jj9ER2U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 202C74377E;
	Wed,  7 Jan 2026 12:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE2BC4CEF7;
	Wed,  7 Jan 2026 12:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767788648;
	bh=Lq+qb8p/JeZZ24gFARiIHk8jb++YEHQT5hO3qTQR3Dw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=YT7lKsIL4LmNfK9eUGj51kaYJfJfLQzVlgoMitV0b19j0lcJZ8troi/+V49jjtdUJ
	 qhVMSF80VQrUlyyAhJwQc2IzYUIlOLo2VDSrj1XEjU0g8O+ChiZCM3BDVuGsi1BF3Y
	 1PIoqO1gZIdKT5botN3Lx2oAI6RUWiqgz2JMfxfZXgDzXM6MZWVOLrMnva9Ht7gPCE
	 IucAai8tLwT+XJiV3oTKnnWrsVZfIwKkqNMLWTtjnE4rk3t236XwAOj1hIxddYxk9I
	 R1q9plGRjwg8Ov3p/4r52h8vTA3+lBwQ2EEtzawKcAkPycVlW/BGSpYf1dZO5C6NKF
	 OvK3Y9zEcICiw==
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
 nouveau@lists.freedesktop.org, Alice Ryhl <aliceryhl@google.com>
Subject: Re: [PATCH 2/4] rust: helpers: #define __rust_helper
In-Reply-To: <20251202-inline-helpers-v1-2-879dae33a66a@google.com>
References: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
 <20251202-inline-helpers-v1-2-879dae33a66a@google.com>
Date: Wed, 07 Jan 2026 12:49:32 +0100
Message-ID: <875x9diqwj.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: j498foobbnsxom1kea3k5zgadcetk34d
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 01373180003
X-HE-Tag: 1767788648-375560
X-HE-Meta: U2FsdGVkX19HPvz+34u6y8fmJ7zKMl9pK5pJkDRw+ksYCHGFqiP9pF9V2Q3RaWg/mipPkU9SBD74D/tl12tIsSHgjxpTpNaeHh/tHEvNmNtjU3CRRUp78sJdGqPv1Aaf7PTA3oAXycv4/vc2MIu1pCg72LNSH5938O0Msy1nqcHJ7cW4OXrCRPTWuTNU/6reFEibYdvd4GKjmR0JEmM/vuKKzkkpSm7KQYNESXJVs/NK3ObUxjzxcpIhn91axkfO32d98ClcmS2LdfhG2FgPdvN+113i8AOPeZ8+agGWX1jlMmoLBC1rrOWyj+1Idt5ZLv4zLivxIyOJ26tcAIlIB7hkhlCe+vxGU4C88/yLDyb8LZDlVIRjLHsYj5z888FGCiUcd57UHUtP8AVHFfOB9E4uZMI6g/XrJJis/rWb1ys6g+qt7wQwtI01zFpXMzEgqNDzym3sE3FVR5lxdLtY0LrZW/cSkmwYSrKmPeNBHt0h5s1i6XsByXL1AlZTOytIVBx14eN7cstAWgVJFdzYJ+CQYswtRvCksxc6n0fWTkG6QpAulMhUwWSivZiXMwaYVggO//0HvfyWFstQbhNuvDcN3M2ThXQIcvAc6uefHgypDK7/+kYc8N7TeCbo56H3KYALi8OIvWFz7xTWGqfu18wGTCJ8uQpj++j1kX+G0Gweyc4Qzf8Gs7MBYlEQcFkqPv3zDT36iDodOXFUi/fgcQvzaN5tzyEDhDFfp0EHRAtNIfbDTTlNmp8U+669dDa27CZVD3Y38jqj3Xy1F9tpnGgVnl2U0reBantEpmaqtOiEFJcLoULnbiAWL0B/as59+gGxBkl2M0TJljFByhqPKQMU6XNGFlqC2Y4WXjJghN1BeY1ekt91loI1yG/8GVOxHZAg1B9rFSat+pubgM/q9fVyMorQdfv1hkwQPA4ClWDEf6hbdqyYYjrltnhRtWGCALHUlIVEpwWk/n5Ljod
 pQTwf24M
 kyOkf9rg81Q0wY5lNgglp/IFcirQ78x9gQNsEZAVXSpUW3iLGk3LcokpIyOpmVlCRIFlV3ADiGFZuqL/ADFaBw/m+6QkeGpQPQV1zI6XkDdk5ZOy9TXrMHuoLvTtn4YwN92VX7TaXRjD2iX7RpOGTJUxvi42iB5npJgnpMcpUsCc6UunW90a7vXTRrt9fFD1A7f7LvYdC+rcups+TRFCmnWl4pgm/jnwHDvcWk6VA8y7XTt4c/ZEYmmUWAvAJyLPTeSHHw28nnrqBuTPuzKtTKI5wX/hzaPLSDfsIewNO2sDW5LmYHwtZHqqjmzjThl7tPL5q5/gFgJ3E1tCnoPtEPhPCCEqJtaKMdGJ38LskgmaVvxiG+dqu/8Mul+sp2k1ze8jbNX88I4Btfl0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alice Ryhl <aliceryhl@google.com> writes:

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
> The actual additions of __rust_helper can happen in separate patches. A
> "flag day" change is not required since missing annotations do not lead
> to anything worse than missing inlining.
>
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>


Best regards,
Andreas Hindborg




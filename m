Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EC8FE68172
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 12:03:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2F646B0005; Tue, 17 Feb 2026 07:03:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C6526B0089; Tue, 17 Feb 2026 07:03:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D56C6B008A; Tue, 17 Feb 2026 07:03:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 776496B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 07:03:05 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F166A1BE7D
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:03:04 +0000 (UTC)
X-FDA: 84453812688.06.ECEEAB1
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1B7EB40002
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:03:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0GiHci2b;
	spf=pass (imf01.hostedemail.com: domain of 39ViUaQkKCEwozwqs5Cvzu22uzs.q20zw18B-00y9oqy.25u@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=39ViUaQkKCEwozwqs5Cvzu22uzs.q20zw18B-00y9oqy.25u@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771329783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cSYPA86nwp+xl2HbEhm6RzJ3nbGdQs2CfGN2qiozLlw=;
	b=G8u4ddq9b+nRNXQILExyhiz7ooYFC90fq1gu76UCbettecLI9etFeuH9PH/G0sXiUP0DSc
	9fE0YhslFZNe4diEH0gTipCuW/+ka1K88YZNPJdJv8H9l3R6e0Mq2Eg+PqPSHUbrerWT62
	chN4IKGYVgJCg2+QuVgcCMn8SDZBhLQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0GiHci2b;
	spf=pass (imf01.hostedemail.com: domain of 39ViUaQkKCEwozwqs5Cvzu22uzs.q20zw18B-00y9oqy.25u@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=39ViUaQkKCEwozwqs5Cvzu22uzs.q20zw18B-00y9oqy.25u@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771329783; a=rsa-sha256;
	cv=none;
	b=7pA0liU3lK7YKDbXo1RPHrNMGGEV+psDyKTa7Hk9VdRGpgeGzv8hLoKOFUjngPezie6HcA
	oxhuwokCBoP/P5z29Ch6hgHKh2iaXvPAbgg5y1IQ4Qs+WdWiiTWwW7L37lwGXK8Ly9C20Y
	fcxBzGo1Dn3xeR12+HKKllF40zfeR6Y=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4836fbfa35cso25382825e9.1
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 04:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771329781; x=1771934581; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cSYPA86nwp+xl2HbEhm6RzJ3nbGdQs2CfGN2qiozLlw=;
        b=0GiHci2bn7VznSWtfjcOCMnbD2vpXqj6QsSnCVQni6uhzLRDPABIeWE8QB/vjbtveW
         QJMBI+BRzq4DrMr/1jKSjzvRDJlt7b24QcFvLgHt0In+Q43QlL+4v5Qbvgk2UDquMeKF
         IBDQMg2wL6GeQjt1coCMAlZBwUDuhG8U40DZKywKXC5x+gLm2wc7tGhV/Wl1QamXB4vZ
         Ca8vpU9cuJp/C78nZO1HM4QV7HDlUcK7x3O764fR7+Scrxt95YEf4GtFjrc2lfcqpIpP
         CRQRAX1qWRtm9o4UWn4nWlw6Ql5vpC/pB8q2PvQOspXIJdrj1vh6T7BuqG2ZH0/vvDNx
         0cig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771329781; x=1771934581;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cSYPA86nwp+xl2HbEhm6RzJ3nbGdQs2CfGN2qiozLlw=;
        b=LOxc6vDjkIoX5NnuqCsBACtQNkgYplloRt3bnOauCWxUBqCRjlYpX6ClINmB1f1B6l
         PL2RHPqVtf2RbytO7riqLZnW6fDNffPcUXhkW5DdNXiu/n3Levuwen2fucnv7R42kdMj
         /s74Nloa0HKkcTSB+VIkzuJeXySWL3wSUBp9bw70c6yppQ93FFreJUK9q+KKvHExOKjh
         /cXVjw1Mds5pAHlwpOV1OI9D8b+XN1pygsqsbT/CffUXuUQ8xLj00nBFOnbRWju9Oxq1
         2fldQ98h0o1/onQmyzFuaG2dUvNlFC0S2lawy3tkwA6P2c4pb/kuS+OHu1h1/eOSx1Ju
         5h8A==
X-Forwarded-Encrypted: i=1; AJvYcCWOzn+i5kQuWKxe79pRve0AsFzmKlcPORnu9+CplnowPqnVyVb9644UHDdamlEXZUUtmIGx95KnjA==@kvack.org
X-Gm-Message-State: AOJu0YyeEaJu81RzpM3z0+4rvewagunbMj6pBkL/cRVHLz8iCfTPwX0z
	Zq0CzTKf7Gbhgcrct4qGQF9H0XzPwuEkixnmiabtb5ZQunOOHOVRSPzg1vU/fMw3v4XdzSWRgka
	2xl/p+qErvFQUogdIUw==
X-Received: from wmdd14.prod.google.com ([2002:a05:600c:a20e:b0:477:5a4b:d57f])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3e8e:b0:483:6f82:9719 with SMTP id 5b1f17b1804b1-483739fc775mr180697485e9.2.1771329781211;
 Tue, 17 Feb 2026 04:03:01 -0800 (PST)
Date: Tue, 17 Feb 2026 12:03:00 +0000
In-Reply-To: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org>
Mime-Version: 1.0
References: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org>
Message-ID: <aZRY9HthKwVJrAf1@google.com>
Subject: Re: [PATCH v3] rust: page: add byte-wise atomic memory copy methods
From: Alice Ryhl <aliceryhl@google.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B7EB40002
X-Rspamd-Server: rspam02
X-Stat-Signature: oyfxs6j435mopne4gu89qxthycnijd1j
X-HE-Tag: 1771329782-384463
X-HE-Meta: U2FsdGVkX1+Ub7Q+pR9CiutB6NLQGug9+48FHgG9zBlhmdjIFJ35KGSVM6AHgPVVRV9J2uSxgL8so+nHDoMQ+kczwTwLWYjZbFRyyamHgDjGX9EeSXppcJjYsiP1PwiJN+TI71toxj3UMds1aX83LcUqv9HD7SqhcTh2qbAw/NLrHuwO9StjlyNdt5flyJr7V4WQMDYya27YqZzV/e4QxaXw1OHBXb42XNVF6FmKljWVlunRCkILlfognDHJSfnbMAIoYpQVyrz4APLvlQWg6IJKo5lBWO7nazEvkZT0o+i3B0j9qXQyfVlvdJh1AORb3ZEZNhCFt9cIfVpNfQW4HMQz6Ymv0vzHCflDD1mlVEHS0oiG/kEL7aU14Gvwv15AlSKZ04ZG02oroS+oxAqZmWumekOvT8vxWDbux/m8hI2BxzaXgjaIxxrWSOLWULsVjFeGR8XypNf1ACMhefArl/Xd7FtoH+OXsAa6pmAlEqfylAVPI8FqAtaeLx2xbYZbd8POEw8eYnfMTAfWHPS/ADxmBaXOisIdwR3y2OG48ChBdY/u7xrDFeeux8dZzEIn+K0lche0IMhZlnnjEuTJuoV7oBv66LtTRQ/zLTukMwA7rBtuhSNw+RJQg2a6Pj7IqXD/LZY4Wmyz4qfJIjKQMEPd/pKb4iiqsbZMXuzR7fdM4Sbx72SeJV3L29U/jUarsNoVMmGXw17V46v/hSTuwxXi2P+kwL31B3ZG4ezKH68lt/IcicJ7i3RfSZhbdSPqvWN464SaXqEqEveW5FySANmL/nKWAKan9dbwBOVcnVOB4nq1PmESYnadg8Uj3znGLQ9ivpIDjT1V/iavHKf+AcIq8wnYykUWwJ1YzPj3HiAL9AGXyeFjd7tnTJIZ6D4FrCVjchJcTf2WjUKocxe2IcnHdYYXbQIFdauqteqT76Reqzad7KQLwGn4rBWvnhb3rndif3jinLyaKbHzLzp
 8Eh7pIS+
 QcvHp28YoU3x/boAGZu5e9fBKa6YqTc3K5jooYDrxx4IHHzJvx10LLZIcleQPFPTVKNwmqSwq8Z2ZmQ97q5JXzp16fyycYi6QGAFIQKh3Cy2zniKCtMUUKp2KaFtIRZQlLOm60/RDAC96uaXRfEF97cLvaJh8i6KzBsNH/9vuDl704cwjIyVMG3+YMeLA5vZcynw+MECN4g1hPA1IB7VzfsS9vaRzy0i1MnlYTo0pYNTmb5L7eCPuqF9cXQvw/BiYgkVanFdt/SWB/XnAtpNzF6hIuW9zPpO5ZQtZblvifTRctDVUm2Iz+GmqujNuhfHg5jIB39B6ooG+/chAUHgk7DO1nK6sTXxqv8BFrs2qlCE1DE/cRTTz2xSV3lgBa4496vVIs7RQfdwsZCOzT0sNuaTii6MHiB3wuub30TU9rq4Yd7zUSNWVwQO5RCR7oSYJGtdotMbqR38CaOe5ZeW7lDiOrndyaF2XZVlka6xW26Qwl5rbITqKBSh+PTiNK9j75gKVFwsRQZ5AFwPuDevVZmcFB5IJAg7FUC6Xw2IcXsIrUhsEIQOuadLLLW6P0VHLGTz1r/CfSM81KsqJBg5kJuTTS7h+HmrUY3yD4lhStgpVrMfLsTyrzWsO3FyKnvo+3Zd+oYN1KBjyHiF+dUo/7adn6vhW4rnZMNRiLz3IH6Gm7lHv8LfGtzSPjq2leggnSNCTud6KRNkz6a4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 07:42:53AM +0100, Andreas Hindborg wrote:
> When copying data from buffers that are mapped to user space, it is
> impossible to guarantee absence of concurrent memory operations on those
> buffers. Copying data to/from `Page` from/to these buffers would be
> undefined behavior if no special considerations are made.
> 
> Add methods on `Page` to read and write the contents using byte-wise atomic
> operations.
> 
> Also improve clarity by specifying additional requirements on
> `read_raw`/`write_raw` methods regarding concurrent operations on involved
> buffers.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

> +/// Copy `len` bytes from `src` to `dst` using byte-wise atomic operations.
> +///
> +/// This copy operation is volatile.
> +///
> +/// # Safety
> +///
> +/// Callers must ensure that:
> +///
> +/// - `src` is valid for reads for `len` bytes for the duration of the call.
> +/// - `dst` is valid for writes for `len` bytes for the duration of the call.
> +/// - For the duration of the call, other accesses to the areas described by `src`, `dst` and `len`,
> +///   must not cause data races (defined by [`LKMM`]) against atomic operations executed by this
> +///   function. Note that if all other accesses are atomic, then this safety requirement is
> +///   trivially fulfilled.
> +///
> +/// [`LKMM`]: srctree/tools/memory-model
> +pub unsafe fn atomic_per_byte_memcpy(src: *const u8, dst: *mut u8, len: usize) {
> +    // SAFETY: By the safety requirements of this function, the following operation will not:
> +    //  - Trap.
> +    //  - Invalidate any reference invariants.
> +    //  - Race with any operation by the Rust AM, as `bindings::memcpy` is a byte-wise atomic
> +    //    operation and all operations by the Rust AM to the involved memory areas use byte-wise
> +    //    atomic semantics.
> +    unsafe {
> +        bindings::memcpy(
> +            dst.cast::<kernel::ffi::c_void>(),
> +            src.cast::<kernel::ffi::c_void>(),
> +            len,

Are we sure that LLVM will not say "memcpy is a special function name, I
know what it means" and optimize this like a non-atomic memcpy?

I think we should consider using the

	std::intrinsics::volatile_copy_nonoverlapping_memory

intrinsic until Rust stabilizes a built-in atomic per-byte memcpy. Yes I
know the intrinsic is unstable, but we should at least ask the Rust
folks about it. They are plausibly ok with this particular usage.

Alice


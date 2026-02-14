Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA008EDF142
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 08:18:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9906A6B0005; Sat, 14 Feb 2026 03:18:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93E1B6B0088; Sat, 14 Feb 2026 03:18:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84A116B008A; Sat, 14 Feb 2026 03:18:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 74BCB6B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 03:18:34 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C42EABB3E2
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 08:18:33 +0000 (UTC)
X-FDA: 84442360506.09.28C8B8F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4606840006
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 08:18:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jphuTcDA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771057112; a=rsa-sha256;
	cv=none;
	b=MfHVgScft01dQYOBHyV2WYxt70rgHkcXl/4a7idsLisgrEeBsef7nq8IeIqpIfMlp+TXuD
	oE4x6TGH5stnn2IPhasPmMrd6ujFmWl4G7shjrXDAK4WwWhXW2zOf6zZC7dvRU5t2gA7Hu
	yURWMQFU8ycdtk6TLsPJW/FBD4Kq1/Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jphuTcDA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771057112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DWbVINSvTzYEejUpJ2rsFdWdLNPJCskedeMucZVpbOc=;
	b=6IrhnHJ+azcbWBVxh8uYl+rXHuNeccBvGdjAdBMRnR6NZJcKj5sbPA1s5TXn7LUczV5Pf7
	FOy8lFfyR0OeHNTQe7yqhD7dnK4BqXmrXAplo/opDhBvFLhcYIsy3U4ckwU76SuZ2RNqA6
	tPF1Jx/o2Ej2pzuqD93fpPC28qb1MJ8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 813F061335;
	Sat, 14 Feb 2026 08:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B9AC19422;
	Sat, 14 Feb 2026 08:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771057111;
	bh=O8x1zhA6Vi8ynCREZI3k2t41Zy8F2bQqNAoQ3vIS1d0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=jphuTcDAy5Kdn63OCdQdo3hS88GeN50loPFKsDm367J1Ae8LIoTFuV9m/wIFndl1r
	 oPrst4EpmqLmkPQeMnCkyxDf3BevPduv7e/pYWtKwV5bYUy1ZdH21G1R5kI/Bn2RUb
	 moguguPAnELKphe89Os9NnIAku04ER+ls5Hwts8SbbLz9DZ3ThOnsteukrR1EG342N
	 I/eYYmsAIHhLhdPvqgrVzvosRbLhFIjbjxLCylsu70mBUeGFMXTZx3Bf4A62olg2Mr
	 17P9XyBfBWUpKKRB0PCynhXj4dv2zJoJ6/K9JP0MVTCDqtmhE4NLyWPe8rgob/IBkS
	 iEOW4OW+me2RQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Boqun Feng <boqun@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary
 Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, Danilo
 Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>,
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rust: page: add byte-wise atomic memory copy methods
In-Reply-To: <aY9i8rbvnxdOA9DV@tardis.local>
References: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org>
 <aY9i8rbvnxdOA9DV@tardis.local>
Date: Sat, 14 Feb 2026 09:04:56 +0100
Message-ID: <87wm0fsqc7.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4606840006
X-Stat-Signature: z3khsff66by8e76tuwbox44kbafnjgsx
X-HE-Tag: 1771057112-374353
X-HE-Meta: U2FsdGVkX1/5VrsS3TcadgqtSEEo9tSV72VQWzaPLMqfP0q6GHERi81dTjOCq+qNyzmQhnyTb5IIkz8hosGSKbt5sZum8eh1zwkvYm/Qd5+NXyikxR8tiC8fJSCC87TGytwHurOUUr0ik0gjslXzRu4xlQdUF6HFA5vuGKB/fFNLqkkYwFrOkhT89HJBgC65wSd+d/MMK9jKS1H+VANh4ciNomhee29p3ynfpwciICCjt3FsYI1JUsiGkN3lEuGLKPuv+pPJAPL132Yk8cStRqGpEfzss+nXi4a9o5hO/YFWFELUlHVPjKPQ8Lfz4D0HDf8n5H1NKY5X9V/Z9vzxGS65rq49zAp2Hvmt6/sxVoMXTO9fqGioFphVokG3JlyreQZN6II3WdJAJu5dzlhCxYUvokNNhMxDycndkYKaeTwUNBEvpblqcQ+z2oO48HLlm1gJm5pFcn9ERnJBfF3E73bMT+c5ZDuISGoIJIZ9mxbkvToPMkNQtc4Obg8pL2jrXB0qKmbedAho5ZcigNTSAm9+8xv16Rfm7O0sDDyYi7f0WnljCp3MATBhs5oSMN29pJzFJ224HQ12PtKf4IWMYynNl/D4Y8nudpaLivzNF4nSAJqshLVClkeBe2e6O+jLKvzwkQkAfvvUz5iXpDqyu/q5d5al/DAfm/sw9MRpZRX8BsBqJkHe2lnfs5lnViMbChxpvcq7/Ng5El3ZyzwC7BfpsRH/VhItliNuugV4Dun/Wa9OBxT5yEXFFrxIjgpZtEbfVF01P/Fx+48VzyuIwrJ6BlzSePhb9kjc+jzl0cQmQbFKnBQKM7WGkwt7jPf7KO4UJCC+xJwku16ja+SI51mbQ9MyL3aryc50sR1UbnoR5OV6D1AeVxZ6Pkaeji5f6nVca7WcKAHYKV9wT0exZrBoMds3u7om+fRpb8m1kkSeFB45F00CP40WuzPJ/97va/vddRFS5gKU8zRrxhc
 2SW2Ia5X
 9O8QWGL7W8wdit2FYoBM3rSvQshUSiny51GJJV29Tf+Q0pw6eCcXsCueiR9/Ov9Evi7ReXioTaZiAMPwanjTCTX0ZHUkgWNNxzT/WYJ1usmXDMIEv7AIjS66FMZ+eMK9uMCdHaG7AJQquAh4r6pWz46fKXcvaUfFQLHH6uweOoGxlu3oCq8fSu5dOTTIJPfyIs4S1ok7NfPJjkXagqKKBwfSWjldAEjefFLM1yUwWAtMOiXpQcZU/7jxaWLx9z8bs4m1U8eph4ama8Znaz/vS2IIxKXXZdA7BXQxRFPy1MJNX+gE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Boqun Feng <boqun@kernel.org> writes:

> On Fri, Feb 13, 2026 at 07:42:53AM +0100, Andreas Hindborg wrote:
> [...]
>> diff --git a/rust/kernel/sync/atomic.rs b/rust/kernel/sync/atomic.rs
>> index 4aebeacb961a2..8ab20126a88cf 100644
>> --- a/rust/kernel/sync/atomic.rs
>> +++ b/rust/kernel/sync/atomic.rs
>> @@ -560,3 +560,35 @@ pub fn fetch_add<Rhs, Ordering: ordering::Ordering>(&self, v: Rhs, _: Ordering)
>>          unsafe { from_repr(ret) }
>>      }
>>  }
>> +
>> +/// Copy `len` bytes from `src` to `dst` using byte-wise atomic operations.
>> +///
>
> Given Greg and Peter's feedback, I think it's better to call out why we
> need `atomic_per_byte_memcpy()` and why we use bindings::memcpy() to
> implement it. How about a paragraph as follow:
>
> /// This is the concurrent-safe version of `core::ptr::copy()` (the
> /// counterpart of standard C's `memcpy()`). Because of the atomicity at
> /// byte level, when racing with another concurrent atomic access (or
> /// a normal read races with an atomic read) or an external access (from
> /// DMA or userspace), the behavior of this function is defined:
> /// copying memory at the (at least) byte granularity.
> ///
> /// Implementation note: it's currently implemented by kernel's
> /// `memcpy()`, because kernel's `memcpy()` is implemented in a way that
> /// byte-wise atomic memory load/store instructions are used.
>
> And probably we make it a separate patch for this
> atomic_per_byte_memcpy().

Sure, I'll queue that.


Best regards,
Andreas Hindborg





Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32D49606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 19:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P0TEn7bo
Received: by kanga.kvack.org (Postfix)
	id E0A776B05B8; Wed, 11 Nov 2026 14:43:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBB1E6B05B9; Wed, 11 Nov 2026 14:43:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C35066B05BA; Wed, 11 Nov 2026 14:43:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E69E6B05B8
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:43:54 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3395716013D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:43:54 +0000 (UTC)
X-FDA: 85423863588.24.28AA1F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id A5286140005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:43:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P0TEn7bo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794426232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Uj72/TkNOSKLa/NvnCJF39YYiorN2RudsmWa61UIzo=;
	b=IgSrX/A6uoFwFidlgg6wrZWDG5GCv8cp4H7I7sIoVNnmhPsG2yEjQYcvzq0JTOHDbUgQkT
	Ndf3V63EyotHRLc/YiNS5LV7Lc3kfOaIDRpTYRcjcUtZNXD3zXuX86T1VXA7/6iVMvRbzq
	HfXUGMUC8I14q89rtTxDa1wDE/bp6Gk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P0TEn7bo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794426232;
	b=necR87PgXuprBxeNVQpnbwhl4Ktqd2sstNhoYolMMmK5/rVsIYJoK5yGHGfbNBpXFctcoJ
	sGDyEwhK4uBmkmgoeA4cGJ55Vnbki6Z2lpAm/JGIdgOTn8bcYIaMQtvAsdkbM1q4l1F+C9
	o9oVfJI4mxW+7QsCbDduZndem4t67+0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 41D4065551;
	Wed, 11 Nov 2026 19:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E45F1F00A05;
	Wed, 11 Nov 2026 19:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794426232;
	bh=6Uj72/TkNOSKLa/NvnCJF39YYiorN2RudsmWa61UIzo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=P0TEn7boxctwTXgjGvCCkHxSFAxUViGYhYp2RLKQzv3rCLNSA9j279J2TO4qYMp5M
	 Are//SoG1FmYXNapiCZqdhWYiptsMIgQVO1lTTOcfRSG3Ngr8pS1xp3NKwMV63Sp1/
	 ILvCg4F1GN7zIr0CNUUa9nq3jTAzTPvsDojCOcb7xaEakPpVeVCQCpcQ+LCe7uhZfd
	 8na3XgjuKauR1u4s1VYEfS+qGSXxY3ponUyIJqkyh5kPRIcjudRYcSDfgzpPN510Of
	 QAq69VbvOi8R/nnWj9AFrjeutEq6c9wSpVK8LpB4uIJB0YuvnhWk67PDa8JgxwBWTP
	 XWHeMILzdw1Hg==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: sashiko-reviews@lists.linux.dev, Alice Ryhl <aliceryhl@google.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, Boqun
 Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6r?=
 =?utf-8?Q?n?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor Gross
 <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Will Deacon
 <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Mark Rutland
 <mark.rutland@arm.com>, Daniel
 Almeida <daniel.almeida@collabora.com>, Tamir Duberstein
 <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, Onur
 =?utf-8?Q?=C3=96zkan?=
 <work@onurozkan.dev>, Lyude Paul <lyude@redhat.com>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v5 2/4] rust: sync: atomic: add atomic_per_byte_memcpy
In-Reply-To: <sashiko-outbox-209187@kernel.org>
References: <20261110-page-volatile-io-v5-0-a91ef252c24b@kernel.org>
 <20261110-page-volatile-io-v5-2-a91ef252c24b@kernel.org>
 <zJFQbYV67YWG-NtiQ0DX5nJ_8ddkkCuW7PYYnJDTumjlWS9_CnUvPigc1ieKk9xUcTCPH85viXhev1LXc5mMXA==@protonmail.internalid>
 <sashiko-outbox-209187@kernel.org>
Date: Wed, 11 Nov 2026 20:43:39 +0100
Message-ID: <8733t7w3v8.fsf@t14s.mail-host-address-is-not-set>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A5286140005
X-Stat-Signature: oakgqmafk37tk6easj66u6g9498wg5ap
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794426232-651506
X-HE-Meta: U2FsdGVkX1/mMeGumEIF/pYuivNuaSSfzC6ZIVOtz4KR1zNaWDeefHmSzEZdpgbUPQJOwkOt6gcwzI29JRcojJb3fYEvc4qgaImj+6nqy2rSfbz55IZ7Emja64OnzUBJHHYdd1rfAXYxFv3zOygB2j5WmHfYP9c51Ci8WWy8Prw+8ycqqHpxGxxs6pJ1PX22zSpp0a/rL7YmqCqFaQkCv5jq5/FdmvR4H3bSLXM+Bq+/GBlQkoqewd6p5YCVzhPS3CH0Cl/Dh4GxRA3auhnNCKSBEbY5rzFOiTtTOYz5FCVVurWtvBJiLZCuguVY/HgiG93QOG15oGSqD/uzEFejrkSCLrTxpHKxvrwqbWEC3O05WOUZz2yUeS+//9GJDUMyD3MMqnWIPu4ezINj+MDrOWVMeHTNuqlanqyLtbrOmZLMHqMCDMBQAB2KDsdN4tfc/48CupGNxxMPSbw6dHJv4fnZzkJGhqKd8E/GwzUBsIIG8YQUg1uOg28dNbsA44SLK53QnpKHutlfPvgnUeuIwwgP0hIhCliNx7dJWszXYm9+ul2emovDU3PNEWBsFuRwAaZpLE2nuzo9I+/9c8QSOeTTJibVqqi1KePLFtte2oNT26rmjoR/74SXnyQakiJkZ7LUPKudww9AXVCHisnwIkrU8fNOgpAHNW0iYEq06kkeBZIpZIIZ4BL3EeG7T85FFJJXKWhdrST0F+AZJD9vn+nXgAGikTwc0pSjhTjVfp5mYZBtrS+QIPdP69uUwzh3s66egsab2yjuRK++xSFbdXamjLBMZFH3mqmqkwqp4sdUEa/KLn7DUXOSPx6bA9zipYu2MOWTjLzlPEeDY6cyDy0KveVpPVsgiwM+9zNI26UjbMXUAVAq9VCjtyA4nxIjXlQ83W5wrNhPfdoge+Xy8ZtB7/6+GcxHSF2C7v7RmtT4UzFSbJdGfQqXrhFrCN6PzqQcOvplNIeEU/735f2
 QMT7/JeI
 S8KsiPh6M/YNcoe3Ae3503V30lXsbt1I//24Wg4DKQgctwMNJxfx8ODqyFEXgEhjKXHqLSc65FoqecfMhalM0+K6FNEKzU9I4fx/cKQunljBOVetNnML0QWs9gIkrMG93cIihO46yQoErHExsdSz1WjTkusbIRD/wZB2JkvgiJ7tA/Hen2jb4YBcc5mLsr4NORA5yzsiD9eQQCIT6h+sLyRMcXQXRrrfroUGiqetFuaVzjdncewoUFlVQSuMKGjDh6jNZPioHnonhcj3l6pEAz2kdP7G2q/BPqnkIuNqwGqmIhFeZMdzGL0+9yw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

<sashiko-bot@kernel.org> writes:

> Thank you for your contribution! Sashiko AI review found 2 potential
> issues to consider:
> - [Low] rust: sync: atomic: missing #[inline] attribute on
>   atomic_per_byte_memcpy()
> - [Low] rust: sync: atomic: wrong core::ptr::copy() doc on
>   atomic_per_byte_memcpy()
> --
>
> commit cade864abc69fc627ff4e6283efdc3170c94fccf
> Author: Andreas Hindborg <a.hindborg@kernel.org>
>
> rust: sync: atomic: add atomic_per_byte_memcpy
>
> This commit adds atomic_per_byte_memcpy() in kernel::sync::atomic, wrapping
> the kernel's memcpy() to perform byte-wise atomic memory copies.
>
>> diff --git a/rust/kernel/sync/atomic.rs b/rust/kernel/sync/atomic.rs
>> index 6d27898add42c..cbcb081d8674e 100644
>> --- a/rust/kernel/sync/atomic.rs
>> +++ b/rust/kernel/sync/atomic.rs
>> @@ -848,3 +848,38 @@ pub unsafe fn cmpxchg<T: AtomicType, Ordering: ordering::Ordering>(
>>      // per LKMM.
>>      unsafe { Atomic::from_ptr(ptr) }.cmpxchg(old, new, o)
>>  }
>> +
>> +/// Copy `len` bytes from `src` to `dst` using byte-wise atomic operations.
>> +///
>> +/// This is the concurrent-safe counterpart of `core::ptr::copy()` (the equivalent of standard
>> +/// C's `memcpy()`). Because of the atomicity at byte level, when racing with another concurrent
>
> [Severity: Low]
> Should this documentation (and the commit message) refer to
> core::ptr::copy_nonoverlapping() instead of core::ptr::copy()?
>
> core::ptr::copy() is the equivalent of C's memmove() and permits overlapping
> regions, whereas core::ptr::copy_nonoverlapping() corresponds to C's
> memcpy() and matches the safety requirement below that src and dst do not
> overlap.

Thanks, this is correct. I will fix this.

>> +/// atomic access (or when a normal read races with an atomic read), or with an external access
>> +/// (from DMA or userspace), the behavior of this function is defined: the memory is copied at
>> +/// (at least) byte granularity.
>> +///
>> +/// Implementation note: this is currently implemented by the kernel's `memcpy()`, which is
>> +/// implemented in a way such that byte-wise atomic memory load/store instructions are used.
>> +///
>> +/// # Safety
>> +///
>> +/// Callers must ensure that:
>> +///
>> +/// - `src` is valid for atomic reads for `len` bytes for the duration of the call.
>> +/// - `dst` is valid for atomic writes for `len` bytes for the duration of the call.
>> +/// - The memory regions `src .. src + len` and `dst .. dst + len` do not overlap.
>> +pub unsafe fn atomic_per_byte_memcpy(src: *const u8, dst: *mut u8, len: usize) {
>> +    // SAFETY: By the safety requirements of this function, the following operation will not:
>> +    //  - Trap.
>> +    //  - Invalidate any reference invariants.
>> +    //  - Race with any operation by the Rust AM, as `bindings::memcpy` is a byte-wise atomic
>> +    //    operation and all operations by the Rust AM to the involved memory areas use byte-wise
>> +    //    atomic semantics.
>> +    //  - Copy between overlapping regions, which `memcpy()` does not support.
>> +    unsafe {
>> +        bindings::memcpy(
>> +            dst.cast::<kernel::ffi::c_void>(),
>> +            src.cast::<kernel::ffi::c_void>(),
>> +            len,
>> +        )
>> +    };
>> +}
>
> [Severity: Low]
> Should atomic_per_byte_memcpy() be marked #[inline]?  It is a non-generic
> function in the kernel crate that forwards directly to bindings::memcpy(),
> so without #[inline] callers in other crates cannot inline the wrapper
> unless LTO is enabled.

I will add the inline attribute.

Best regards,
Andreas Hindborg




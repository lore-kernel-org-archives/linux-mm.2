Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53B48606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 14:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BT7B77hi
Received: by kanga.kvack.org (Postfix)
	id 6AEE26B00EF; Wed, 11 Nov 2026 09:46:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 638226B05B1; Wed, 11 Nov 2026 09:46:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FF856B05B2; Wed, 11 Nov 2026 09:46:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1EFAF6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:46:36 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BC02A40303
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:46:35 +0000 (UTC)
X-FDA: 85423114350.01.BF99613
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 233D180012
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:46:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BT7B77hi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794408394;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lur2StVqHRA8qjndKnNWa31IDau0Z9n5RgQpwnH5R2w=;
	b=JZHBJ6/Dj+rymX0UTRTPHih0B+nEYmSuM4nyE5w6KIeGm/8k+YMY9+u0fAiqJ8xfz8tXjT
	aYg7v7z+j3c+nxyR7YzrQrgrf1O0sUhWV587vRCjQevsuTPB7IxCH+sAOsbUDHgPcJpprt
	MJ5Y8eMbVzMAOYA0ihQBeKc8aQdY2RM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794408394;
	b=xNIs7HAiAvqDBpR7QRSjKS3qLaz5mmFThckLWF09uebxKdxCRctAMBtsZHFIJriZk9n4yO
	Ffy0Cjc66qM3vPcwc0TwP9Bss8V7n6xRBno16N1mEUokw9DuBMfmEAoDadZioQBzmSDceG
	2u6zvXj1R6kysbsjBlVowPc/kz5MECQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BT7B77hi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A48726341F;
	Wed, 11 Nov 2026 14:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CDE1F00A05;
	Wed, 11 Nov 2026 14:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794408393;
	bh=lur2StVqHRA8qjndKnNWa31IDau0Z9n5RgQpwnH5R2w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BT7B77hiom5jUmd+wctMuN+GaOD4AFaC+sb2NQYj8uqw4okEgwwsbgJS3QUVUeUXW
	 dRt7PJhBk9P/Q4pyHCC5qyVwFOLakGiVCeg9eXUWQaLrjruA6h6euBzpatKlB29aoI
	 6YiALjBMUWRLVuP6FPuhH8e42KcQg/+Dj2L5HbJvMRra+1srwu327pqYoIhFe2g8Vh
	 dXib9P/yznSXnXuNfjvUIQqvOiUfTPNcti5fDuRXwuibQ1AUkCPMAc08cck8nM3F6i
	 FgDyxP1BwtIv4ziuU5yL8fTEX4wUn/FYOVkqFdhLk4FnqT+TBqPDyK9IaBkXg7K0av
	 wKJUTzNHaKzbw==
Message-ID: <sashiko-outbox-209187@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 2/4] rust: sync: atomic: add atomic_per_byte_memcpy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andreas Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Miguel
 Ojeda" <ojeda@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?b?QmrDtnJuIFJveSBCYXJvbg==?= <bjorn3_gh@protonmail.com>, "Benno
 Lossin" <lossin@kernel.org>, "Trevor Gross" <tmgross@umich.edu>, "Danilo
 Krummrich" <dakr@kernel.org>, "Will Deacon" <will@kernel.org>, "Peter
 Zijlstra" <peterz@infradead.org>, "Mark Rutland" <mark.rutland@arm.com>, "Daniel
 Almeida" <daniel.almeida@collabora.com>, "Tamir Duberstein" <tamird@kernel.org>, "Alexandre
 Courbot" <acourbot@nvidia.com>, =?utf-8?b?T251ciDDlnprYW4=?= <work@onurozkan.dev>, "Lyude
 Paul" <lyude@redhat.com>
Cc: linux-mm@kvack.org
In-Reply-To: <20261110-page-volatile-io-v5-2-a91ef252c24b@kernel.org>
References: <20261110-page-volatile-io-v5-0-a91ef252c24b@kernel.org>
 <20261110-page-volatile-io-v5-2-a91ef252c24b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 14:46:32 +0000
X-Stat-Signature: i3xuy4do56hotjiya4xswc1w84jecj4a
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 233D180012
X-HE-Tag: 1794408393-497018
X-HE-Meta: U2FsdGVkX1+jqaJVfhKs9SDMGuZypwmHsu3kQMiVOyhYNmD1tbp08ZKz4KyeIi8QlG0UYU8+KY9QCKrvxQ6vH7tJblVAWa/F3iV/Kq4zRT6oYO1wRApBKVvyZQKwevM1EN6hWx1IvirLnpEniozvyitoh+Bi5gYi14ZAGYMXrluhhdtZhKY5kXuQLrJZ33C043msXu7xcwDYLwKOLsjGCswN+I3bT/BjQJ95HiI7hZCW+u1B/abGyZipbBcD6+DTZmH+F4S5bj+fhF8gjWuovEFbMNaMwBnsaLb89D6uSX+m6jiSFG42SWfktGum/ggw7POb2Z06Pd7LSvQyzDLCQS8gn5lSxc1XVP5D56dfnI0S1kTkw5MeKk4Z0qny9EC7Oacnye3U+IseZrA57vNlTUxT1i3F9EY4IiNryzUVusQelSNMYqQoVeZQAjbB5LeiUPQYmWOP0H5dYHWzhOxx+zLaJfFJN/MiuLPBI1+CxTKDBBPWDkeJcccI68/KsYPB5kiiJZ2+Hybj8GPrufWvbjzCAiZRBXGl+WXsg33kQEGKWXh+gJBKYj6odg3fEoVF/4F0sivVvstjorukwAPitaEaPr5RfFG2B8CW0ltYyrKJ2l2qz5nbC/8kqyz2PajpMFcKXQHLWVj2MrTJ+YsDYe5XA7XEqhYvBukhe/47GjiW/TB5qWoqjywBr+gkUg3pIrUM2RAMJzkmYkmAsWHcWFxNOSP8fJdN1U7GGWxo8AsLe5QV5m3bEabckaLyqZbc9BjJulFhP2QtO4e/PaAJFB7/GZW3DYo8xM6WJyEBGbFFwt31+MnTw1Npj+EqU0ABUVEFmw9zT1sHloV4ApYV3mWtyh+3cc8Si0QLUQb4kOHV0ZNblBtL9x4oRd/95P8m146or1oYAkPYiZodjDicBCruy37hf2Ow18tVyP8uZZ+KD/Ofhv0kx+ce2/Jlf5DRjT/n57YnMASPK6OpE57
 VteaZJfE
 CJ+d37wIlNmqdl4zRaW/m/jnNQlVFJWXsd/BOjTrEkAWaBi+o+LFfwRXIGrdl/Gzmq3syelLFVIRPZJmXtl7xB4YtiQnah8+NaUMgy4XQ2/bR352KeMTH0KYE4M+TK+zrSqjPxU1rknUFkcjgdPiNorMY8S+2q3yZoXzBXmYgZmgndEUXiHCaCI7Wj8F7UbAomTGxlZHt5CHUmiUTnU8qv6fL3x/9mGPsKIEYb8kJFm1+ZknGfPQaHCJcRNeqSM9QVEoqUGxmxXvouanRyUN60eGWwRDE04Ad8D5h65J7qhO7ruALOeDPv2B90Y3mp0v5Wt+pa4kK5F4E/TbMpjKXt1neQ4TCtlc4qa4XUipMM8BECXibJgRscuTgCQ+0hw/Xl31YJtiIKK7fr4rAvRott+5KTO58Umm780bnoRANqmfWusG47a3Hs62ZiuK6LtXASq8ToIsuRQU3xhykTPiVJWc9nXUye8Aqp4nzOnd2+FE9fvGTj/83+HDmGJW4gLhsmVjjFI9wp0iS6fJS783zIhZBh+MektTbxbW4gSV2HfRkAV/df/lul9ZuDMAgv63o9TIm+6M/3j4ETWIm2TfGVeZJfTyAgyeg78h1tWLkfd5sS3B5RjpD9d9VmG/D/kN9hc4Au1XzMwTscyM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Low] rust: sync: atomic: missing #[inline] attribute on
  atomic_per_byte_memcpy()
- [Low] rust: sync: atomic: wrong core::ptr::copy() doc on
  atomic_per_byte_memcpy()
--

commit cade864abc69fc627ff4e6283efdc3170c94fccf
Author: Andreas Hindborg <a.hindborg@kernel.org>

rust: sync: atomic: add atomic_per_byte_memcpy

This commit adds atomic_per_byte_memcpy() in kernel::sync::atomic, wrapping
the kernel's memcpy() to perform byte-wise atomic memory copies.

> diff --git a/rust/kernel/sync/atomic.rs b/rust/kernel/sync/atomic.rs
> index 6d27898add42c..cbcb081d8674e 100644
> --- a/rust/kernel/sync/atomic.rs
> +++ b/rust/kernel/sync/atomic.rs
> @@ -848,3 +848,38 @@ pub unsafe fn cmpxchg<T: AtomicType, Ordering: order=
ing::Ordering>(
>      // per LKMM.
>      unsafe { Atomic::from_ptr(ptr) }.cmpxchg(old, new, o)
>  }
> +
> +/// Copy `len` bytes from `src` to `dst` using byte-wise atomic operatio=
ns.
> +///
> +/// This is the concurrent-safe counterpart of `core::ptr::copy()` (the =
equivalent of standard
> +/// C's `memcpy()`). Because of the atomicity at byte level, when racing=
 with another concurrent

[Severity: Low]
Should this documentation (and the commit message) refer to
core::ptr::copy_nonoverlapping() instead of core::ptr::copy()?

core::ptr::copy() is the equivalent of C's memmove() and permits overlapping
regions, whereas core::ptr::copy_nonoverlapping() corresponds to C's
memcpy() and matches the safety requirement below that src and dst do not
overlap.

> +/// atomic access (or when a normal read races with an atomic read), or =
with an external access
> +/// (from DMA or userspace), the behavior of this function is defined: t=
he memory is copied at
> +/// (at least) byte granularity.
> +///
> +/// Implementation note: this is currently implemented by the kernel's `=
memcpy()`, which is
> +/// implemented in a way such that byte-wise atomic memory load/store in=
structions are used.
> +///
> +/// # Safety
> +///
> +/// Callers must ensure that:
> +///
> +/// - `src` is valid for atomic reads for `len` bytes for the duration o=
f the call.
> +/// - `dst` is valid for atomic writes for `len` bytes for the duration =
of the call.
> +/// - The memory regions `src .. src + len` and `dst .. dst + len` do no=
t overlap.
> +pub unsafe fn atomic_per_byte_memcpy(src: *const u8, dst: *mut u8, len: =
usize) {
> +    // SAFETY: By the safety requirements of this function, the followin=
g operation will not:
> +    //  - Trap.
> +    //  - Invalidate any reference invariants.
> +    //  - Race with any operation by the Rust AM, as `bindings::memcpy` =
is a byte-wise atomic
> +    //    operation and all operations by the Rust AM to the involved me=
mory areas use byte-wise
> +    //    atomic semantics.
> +    //  - Copy between overlapping regions, which `memcpy()` does not su=
pport.
> +    unsafe {
> +        bindings::memcpy(
> +            dst.cast::<kernel::ffi::c_void>(),
> +            src.cast::<kernel::ffi::c_void>(),
> +            len,
> +        )
> +    };
> +}

[Severity: Low]
Should atomic_per_byte_memcpy() be marked #[inline]?  It is a non-generic
function in the kernel crate that forwards directly to bindings::memcpy(),
so without #[inline] callers in other crates cannot inline the wrapper
unless LTO is enabled.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110-page-volat=
ile-io-v5-0-a91ef252c24b@kernel.org?part=3D2


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAFD8CD8C85
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 08:14:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3E866B008C; Sat,  6 Jun 2026 04:14:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEF866B0092; Sat,  6 Jun 2026 04:14:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E04B76B0093; Sat,  6 Jun 2026 04:14:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CEE6E6B008C
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 04:14:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6B02C8D9FD
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 08:14:48 +0000 (UTC)
X-FDA: 84848776656.04.9240370
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id D31E1C0009
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 08:14:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k8U2GTfh;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780733686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fr6szU5JrgZeoEMxPVTiNKODySIrvXOrHp4spLaAgmg=;
	b=26BuVJXbhJEov7xHDifkaprtasG4mrJcWBW8iRPSvhq9HKx83o62OVTu7yhKkoYyAPXhHy
	IYWdeu82td/AvYR+S9bomRgztBRftgfq5K98V4V7f2/wUdQh91OIAazSW5WDsaUWsRx7NQ
	yUVc3R9LPwkoMwQWf/cwaw7L5KKOrMg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k8U2GTfh;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780733686;
	b=08nN3N2oOUTT+ERIvRQpslt48vfGzZYJaHdgeqGRlexJCslTvl4lAu/xJkSfSMbOas9vho
	szX9p8HNqOxoHti4e2taq4MPX1nnDf5DNpjvspiTqXDYak0aYPxFQwyL62BiHCyhbGHyaJ
	Soc2ofT1VE021UYcB2Rwxe5Ncpbtbqk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2EADB600AE;
	Sat,  6 Jun 2026 08:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159A11F00893;
	Sat,  6 Jun 2026 08:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780733685;
	bh=fr6szU5JrgZeoEMxPVTiNKODySIrvXOrHp4spLaAgmg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=k8U2GTfhHYwFr++KszIsCZK1krSuJaFk3fhELgPqkF6jmWZefSKerAWd1MFqAZRgW
	 Ig5RkK6/sCmCQgO1dwRlkkm0p8A5VJ5XdZGeNFdTlGFZhRy/aq8dZygy1UkfAg2/fk
	 u7CaDWv5xPsBCQeDndGiNpzScC30PhqW+xWY5jg5vZiX+Jl8woYcJhkQftUREvSYEg
	 DbMPyfGn5ld06+EtaZOT0KywJvGpzTQROjH5TdRTutLNkGEmtaCrdi/7QyOhl2KV84
	 bNoA2wVQxJ9ovnJmOW03WsEJIeXdIHhH7rfgx7JvKbEj+ZDeS8qV66HPn98ItWwadi
	 6j63WQvs0ogZA==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Uladzislau
 Rezki <urezki@gmail.com>, Boqun Feng <boqun@kernel.org>, Lorenzo Stoakes
 <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] rust: alloc: add per-task memalloc scope abstractions
In-Reply-To: <aiK3R1yRHj8zcGuh@google.com>
References: <20260605-gfp-noio-v2-1-cfa2e236c2a3@kernel.org>
 <aiK3R1yRHj8zcGuh@google.com>
Date: Sat, 06 Jun 2026 10:14:38 +0200
Message-ID: <87ecikhyq9.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D31E1C0009
X-Stat-Signature: jt8kn3kspfwjwjax53pekij7m8tprqfd
X-Rspam-User: 
X-HE-Tag: 1780733686-568892
X-HE-Meta: U2FsdGVkX18e7suuF8KH84SFl/2yyhpzPoxieMp0FPRPECf53B5lkVJXnJTwIgR/nY3A/XCGKfQT/PKWB6EAQ0g9dGrfIbzcPubk89zNA9jEXOR3UQ3+X1bnprHko1viVU8hUX/7buLDMVQGibb1vURx04HdwmYqJ0nCgD8YfAA+GdtHkbNpAR9EPUa1fCZLhNtYe4kWCCxTf1/mT4Q0M3ZGFVySzg+fXhBuR4zmRmwAWR0IPtx7Pjwd6FBVM3aNBXVkbjdyPoZ+Ed59kZWaai5S51GFxQDPdXrEKure9pD1tmui8SCtKnDm09Gei/7z0nPlviCenYdNV1XVYEIHnptHJfefG1OHRjI6+8+FOoKsZHWCML2jCF3tb/PFoObvzy1buyiTTv1xWmQyjleulSqVzpUT/Hso9k4Wpz3eHVMpk4Q6TlMGcKc7xfCAlMJYWS+JbQOOasd2Cqd+yr1Lv0HBbQJqfvaS5K1mkMtUtOHdJSBOSkBiJ0IrdsgJ3+lhmmy56Ql97kVQGiSzwRirwbhwQCfb780/oBheaOgD3LvtZj8ulMwKkk5JI2QiipJLV1GMYa2gXVOFJi6OIo+aNwWELSdy0wV3REE6wHwDHPj4OJqeRwWouLzly+S0rC/aORBrn1KVv6PSTZRhqGQ1MBKYm6yZmsTHkoddovRYjFrHVy3KxDPv7ytuUP8CNJFjoCRg/OO3Trzl+PefuMmqqFQxNSUcOxPTATul7h/3m6g9rG2ZUpZQqmwo5TqhTylhQDn/7waVrcPkeP9ePUg+TiYjNpElE5XXz6KZfQF8h5WlZ/AQenmGhWlPQN7tXDlSxfstvmkDRK05q2Q+ZMh9Obs2g7/zGpsdno4NA0jh4WscGYZH1eP5CqqFO9k+x+WRIlo6zhJ2w8d6JfSurvM5dY+1rnbeMT4m1u8JfYkdOHXYQXM7iTGjrHFhhrHePbvMfABco8xXEityxFkyqYw
 x7MNjJXi
 QE9VfuHglMrGSZlefIQiJg0d3a95nPtrm1ZJgx5Ydw8uHBUEYjoc+t2XChrufFF60bY0ae76Rb6tVYItZKSRzIcXECNtxvTBy/qZjxan/0RaD/YTt0Y/JOAalOzLvyfcdBt/V+hV7QO/V5H3tzinTUdJWOd/4Y3mw6tnQyTgrmrgiajlivWpTkHsSEJchDUz9Lcogg68PmdyjJtmIlCb8gaVpPZRZc98+IALGImNyUC1eSH/RBMs8yfnfStxEoO5SpNnI7kybSzpDPCq9AufKEgBZJ2reExCFPitGv8libognVrIIi0Ed3DTQvToVPu/7ly/FauS+mXI5sRLR2ceH3aR0rwf1uTLUHBlGBED5Q3MqDmMHQVz5ZzyxxLoMVk9tsekaNLKyHL+KmsA3sWBsRACCpwwk/D6ea1egk8tCLc2y0SCLagqBCXyjKSNIBbAzC+zMQSkELaZBYakPUNBGuxas0rTpZuxeoU4MHVIMNkUrwcwMj+G0oJyL38bsfl9c0mwl1XnxPcynKaEniG0GKpXO2lCiiB/15p5N1DsJgWMF/+mEkVLSh97Dlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alice Ryhl <aliceryhl@google.com> writes:

> On Fri, Jun 05, 2026 at 12:54:41PM +0200, Andreas Hindborg wrote:
>> Add an abstraction for the per-task allocation policies exposed by
>> the kernel through paired save/restore helpers in `linux/sched/mm.h`:
>> `memalloc_noio`, `memalloc_nofs`, `memalloc_noreclaim` and
>> `memalloc_pin`. Each pair toggles a bit in `current->flags` and
>> returns the prior state for a later restore. The pairing assumes
>> strict LIFO nesting; restoring out of order corrupts the per-task
>> state.
>>=20
>> Wrap the four pairs as a generic `Scope<K>` guard with a sealed
>> `ScopeKind` trait. Tag types `NoIo`, `NoFs`, `NoReclaim` and
>> `MemallocPin` select the underlying save/restore pair. `Scope` is
>> `!Unpin`, `!Send` and `!Sync`, and is only constructed through the
>> `memalloc_scope!` macro, which binds it via `core::pin::pin!` to a
>> hidden stack slot and hands out a `Pin<&Scope<K>>`. Safe code
>> therefore cannot move the guard across tasks, drop it ahead of its
>> lexical scope or otherwise violate the LIFO save/restore discipline.
>>=20
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>> ---
>> Changes in v2:
>> - Rewrite the patch to use scoped allocation flags instead of exposing
>>   a `GFP_NOIO` flag constant.
>> - Link to v1: https://lore.kernel.org/r/20260128-gfp-noio-v1-1-9a808fc49=
b44@kernel.org
>>=20
>> To: Miguel Ojeda <ojeda@kernel.org>
>> To: Boqun Feng <boqun@kernel.org>
>> To: Gary Guo <gary@garyguo.net>
>> To: Bj=C3=B6rn Roy Baron <bjorn3_gh@protonmail.com>
>> To: Benno Lossin <lossin@kernel.org>
>> To: Andreas Hindborg <a.hindborg@kernel.org>
>> To: Alice Ryhl <aliceryhl@google.com>
>> To: Trevor Gross <tmgross@umich.edu>
>> To: Danilo Krummrich <dakr@kernel.org>
>> To: Lorenzo Stoakes <ljs@kernel.org>
>> To: "Liam R. Howlett" <liam@infradead.org>
>> To: Vlastimil Babka <vbabka@kernel.org>
>> To: Uladzislau Rezki <urezki@gmail.com>
>> Cc: linux-kernel@vger.kernel.org
>> Cc: rust-for-linux@vger.kernel.org
>> Cc: linux-mm@kvack.org
>> ---
>>  rust/bindings/bindings_helper.h |   1 +
>>  rust/helpers/mm.c               |  40 +++++++
>>  rust/kernel/alloc.rs            |   1 +
>>  rust/kernel/alloc/scoped.rs     | 231 +++++++++++++++++++++++++++++++++=
+++++++
>>  4 files changed, 273 insertions(+)
>>=20
>> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_he=
lper.h
>> index 446dbeaf0866..1931b131345f 100644
>> --- a/rust/bindings/bindings_helper.h
>> +++ b/rust/bindings/bindings_helper.h
>> @@ -83,6 +83,7 @@
>>  #include <linux/refcount.h>
>>  #include <linux/regulator/consumer.h>
>>  #include <linux/sched.h>
>> +#include <linux/sched/mm.h>
>>  #include <linux/security.h>
>>  #include <linux/slab.h>
>>  #include <linux/sys_soc.h>
>> diff --git a/rust/helpers/mm.c b/rust/helpers/mm.c
>> index b5540997bd20..b8e7492512e8 100644
>> --- a/rust/helpers/mm.c
>> +++ b/rust/helpers/mm.c
>> @@ -48,3 +48,43 @@ __rust_helper void rust_helper_vma_end_read(struct vm=
_area_struct *vma)
>>  {
>>  	vma_end_read(vma);
>>  }
>> +
>> +unsigned int rust_helper_memalloc_noio_save(void)
>> +{
>> +	return memalloc_noio_save();
>> +}
>> +
>> +void rust_helper_memalloc_noio_restore(unsigned int flags)
>> +{
>> +	memalloc_noio_restore(flags);
>> +}
>> +
>> +unsigned int rust_helper_memalloc_nofs_save(void)
>> +{
>> +	return memalloc_nofs_save();
>> +}
>> +
>> +void rust_helper_memalloc_nofs_restore(unsigned int flags)
>> +{
>> +	memalloc_nofs_restore(flags);
>> +}
>> +
>> +unsigned int rust_helper_memalloc_noreclaim_save(void)
>> +{
>> +	return memalloc_noreclaim_save();
>> +}
>> +
>> +void rust_helper_memalloc_noreclaim_restore(unsigned int flags)
>> +{
>> +	memalloc_noreclaim_restore(flags);
>> +}
>> +
>> +unsigned int rust_helper_memalloc_pin_save(void)
>> +{
>> +	return memalloc_pin_save();
>> +}
>> +
>> +void rust_helper_memalloc_pin_restore(unsigned int flags)
>> +{
>> +	memalloc_pin_restore(flags);
>> +}
>> diff --git a/rust/kernel/alloc.rs b/rust/kernel/alloc.rs
>> index e38720349dcf..8ebb8c9f3e67 100644
>> --- a/rust/kernel/alloc.rs
>> +++ b/rust/kernel/alloc.rs
>> @@ -6,6 +6,7 @@
>>  pub mod kbox;
>>  pub mod kvec;
>>  pub mod layout;
>> +pub mod scoped;
>>=20=20
>>  pub use self::kbox::Box;
>>  pub use self::kbox::KBox;
>> diff --git a/rust/kernel/alloc/scoped.rs b/rust/kernel/alloc/scoped.rs
>> new file mode 100644
>> index 000000000000..0251792c9f3c
>> --- /dev/null
>> +++ b/rust/kernel/alloc/scoped.rs
>> @@ -0,0 +1,231 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +
>> +//! Scoped allocation policies for the current task.
>> +//!
>> +//! The kernel exposes several per-task allocation policies through
>> +//! save/restore pairs in [`include/linux/sched/mm.h`]: `memalloc_noio`,
>> +//! `memalloc_nofs`, `memalloc_noreclaim` and `memalloc_pin`. Each pair
>> +//! sets a bit in `current->flags` and returns the prior state, which a
>> +//! later call restores. The save/restore APIs assume strict LIFO
>> +//! nesting; restoring out of order corrupts the per-task state.
>> +//!
>> +//! This module exposes the policies as a generic [`Scope<K>`] guard,
>> +//! parameterized over a [`ScopeKind`] tag. The type is `!Unpin` and
>> +//! constructed only through the [`memalloc_scope!`] macro, which binds
>> +//! it to a hidden stack slot via [`core::pin::pin!`] and rebinds the
>> +//! handle as a shared pinned reference. Safe code therefore has no path
>> +//! to either move the guard or drop it ahead of its lexical scope, so
>> +//! nested scopes always restore in LIFO order.
>
> Your scope trick only works in normal fns, not in generators such as
> async fn.

Could you elaborate what would happen when this pattern is applied in a
generator? I don't immediately see how the LIFO drop order can be broken
when this is combined with a generator.

Would a closure based approach have the same problem?

Best regards,
Andreas Hindborg




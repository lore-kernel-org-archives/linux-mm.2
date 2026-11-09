Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5E68606A325
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 13:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aAyxcFZx
Received: by kanga.kvack.org (Postfix)
	id 88E246B05B1; Mon,  9 Nov 2026 08:51:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8369D6B05B2; Mon,  9 Nov 2026 08:51:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FF336B05BA; Mon,  9 Nov 2026 08:51:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B5BE6B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 08:51:35 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A6B61140691
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:51:34 +0000 (UTC)
X-FDA: 85415718108.28.95F5790
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 158BF140002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:51:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aAyxcFZx;
	spf=pass (imf23.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794232293;
	b=1do+pX7uYThFG7ei8vhMYwgiuif0KAIOxKfydeLlCInN1ROfi44R8pEQiR1Sa9wpp+IGpV
	nwr7vfg+9meRORp12UnywXxsdhh3gqCOAT7nyZQlgq7eIDKl+Zsxf9aaJp/mWYBGpqE67T
	aLRZXL4NeJ0V53+J9Ld1LFRcv3LWYLo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aAyxcFZx;
	spf=pass (imf23.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794232293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6YcYOdC7iHosICJsNPvA6c1/PmSp5VhjSW9aX6UnLmo=;
	b=U5fuS7IGymBWntW+6xChIpg269U1NN4sob9HsZEkS6qr8F+Gt7WpeAWYX5x7UttGVSkU8D
	QFGiFPc74+jbYqqghLfts+eX5VmTRhVB5/CPY42qr34E+u0FEIzzUzP0g7cSU2smfV1qzd
	jxU2PBcgfWfLprUFS/Q0Y7lQULN58j8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 59A4361417;
	Mon,  9 Nov 2026 13:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C791F0089F;
	Mon,  9 Nov 2026 13:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794232292;
	bh=6YcYOdC7iHosICJsNPvA6c1/PmSp5VhjSW9aX6UnLmo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=aAyxcFZx4CjOcZ9lwqhVvPvhAJ9SWod3FcQZMUQhUdwuQjNS/yhPOF8u894Qxd/Q4
	 EglLqS7QJBn0G01aZn2nlWw6k0rpgMY1GwD/ce50b/82D6OayUUcv9KW2gc+x02ee3
	 dAJfStZMCyQkgHtAR8aSKWPSo8cymgby0XFYMkIPsTnK3boYWaKmj9Y9neWRQxaOV2
	 JR1NpakwROrC+QXRgxlLXusTIb93xnw9NAalDFvgKw1CQu8ADzRMmbnhPvwU+M3Xdn
	 dmNaYtSAp4/GVxpjcWerxnVYzkoAd3Kk+TYXhvoOyDo9Vl3YDEuWvQCfuq30LPq8BD
	 eYYWPHfQSg6Uw==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Gary Guo <gary@garyguo.net>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng
 <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Alice
 Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo
 Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Uladzislau Rezki <urezki@gmail.com>, Daniel
 Almeida <daniel.almeida@collabora.com>, Tamir Duberstein
 <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, Onur
 =?utf-8?Q?=C3=96zkan?=
 <work@onurozkan.dev>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v3] rust: alloc: add per-task memalloc scope abstractions
In-Reply-To: <DMQOAI3KE9UD.3KOEVJO02ENM4@garyguo.net>
References: <20261109-gfp-noio-v3-1-a573e7be9c44@kernel.org>
 <DMQOAI3KE9UD.3KOEVJO02ENM4@garyguo.net>
Date: Mon, 09 Nov 2026 14:51:22 +0100
Message-ID: <87v766qfj9.fsf@t14s.mail-host-address-is-not-set>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 6ggx9iwgb75h4opyedthjod814kx7a43
X-Rspamd-Queue-Id: 158BF140002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794232292-623351
X-HE-Meta: U2FsdGVkX1+CLJjmRKEpJmQG/YnLnPIzqfuLHNyjeaOenHD3ImlRJklnDp9BPSfTroeoG7l3UcfeRF+mV0SFyWJeiZh6UU/xd6l1kQ5T5CibRBrX50Y29jAt8fQjb0iC5gNyh6KWS3jSRNjijPJKdR1K1imzBwrzF/FsYERZCT35Dvdo8Xe5bKHAlT+Fl1UyfZCbuKUX6fNAUiNP0gmNUIwc8XXV1nGhN8qwYqzj4sFBdfl3HRD2gU7t9LoJlKogcPoWMWMk3l3t+m4TP+trP795PeAv1cdQ2tsdVRLQDCgiTgrtnyM3Bby6xKNs9cSYSWshGL/pITKQXW1SScxrd970fF5ZyzGPSOAvMHh7qsdNVu/Yj0T3yBg6hjKMp3ZqFJQ4KeFGQIomw8XuuYrW58AnaG54ssRTPN3ZOhRmzN9TsekXKvX5AlqXfUdHBvsHX1whgHyO/vSBOMhNj8k/OGPgZGZrI4XndNODi5rKrz+lzME+QziullHaP951B7afKyQkt87mA9GFdPntSQRIy2y7pAEr3Wydk4Q6eKKLBfAM9x+94n69u4TgYS+d6AYtEAVW78hC6G4h7SWpvn5xLL5rl6YYzQHpRGZ5Ng8flQC/Y2KK8qm0pMnNpQfbLdERw2+642JTs6Zn9aI/0KT/iJoiciYWOr9zXByEbyqgZMY2HpkR3vPzl0A5HTl1e5XfOe07MkUzAEi6+mxfOgQOq7m1bHYD89wIaflg43K2ea72KCuzGW6Ek6yeDN2o8U3nvDRy2PqW6dxqeC6dI0lu2A5jQm3/iHSX9wjylPhQTN5nxPf6pPbSey5i06x7jBLiGF5Xg9va4Euq0VxZEMPD+HEUKMUHp5T2DKKHFx5Fo5hroO7IEUJkgr9G22CHXIC6QDF4hE25ejc/33XI9hJFT5m7n591wNYVUNzQMygbZCOHLUe4i+kyOrXx1JPuyG3fPTDd0FN5Tse9WgztvjM
 K+6tcp1+
 RRSUtpodX2zjDvVi9PApS6qpvrl5B7P7UGPIAfb//aYWq7hhKE5EchXZnStYcWLOBfUoFFYsAeSNcv953luE2Q1rhdkdVcFiS58ilZWGY8AMc5d/6AR0/lenKIgjESv+vUvZe8v9EfN3wDJ3wF3X4ABn77grmU1XfK4EXzFb5eX9LM+AVcumGPHy+HShuySYUfMQIMrzp2NNpll7s8gfwn4uGgbuArXdFsOgUKUgW/pWJesogXlM/NTFg/4lYPxtdvhG+c5fc0J9ufXsBI9ZX2kTyP/tE0kAEIcyQawIaitueUiZkdXR2IAr4FFx3Kc1KoedUol2+d9J76b46W5ce66PpB0crfeGwHgZpcLY3jTkqK5hhQi8ZmrpRFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"Gary Guo" <gary@garyguo.net> writes:

> On Mon Nov 9, 2026 at 10:37 AM GMT, Andreas Hindborg wrote:
>> Add an abstraction for the per-task allocation policies exposed by
>> the kernel through paired save/restore helpers in `linux/sched/mm.h`:
>> `memalloc_noio`, `memalloc_nofs`, `memalloc_noreclaim` and
>> `memalloc_pin`. Each pair sets a bit in `current->flags` and returns
>> the bits it added, which the restore call clears again. The pairing
>> assumes strict LIFO nesting; restoring out of order corrupts the
>> per-task state.
>>
>> Expose each pair as an implementation of a `ScopeKind` trait on the
>> tag types `NoIo`, `NoFs`, `NoReclaim` and `MemallocPin`. The trait's
>> provided `with` method saves the policy, runs a closure and restores
>> the policy before returning.
>>
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>> ---
>> Changes in v3:
>> - Rebase on v7.4-rc1.
>> - Replace the pinned `Scope` guard and `memalloc_scope!` macro with a
>>   closure-based `ScopeKind::with` entry point (Alice, Gary).
>> - Make the doctests compile and run under KUnit instead of `ignore`.
>> - Document that `NoReclaim` has no effect in hard interrupt context.
>> - Link to v2: https://msgid.link/20260605-gfp-noio-v2-1-cfa2e236c2a3@kernel.org
>>
>> Changes in v2:
>> - Rewrite the patch to use scoped allocation flags instead of exposing
>>   a `GFP_NOIO` flag constant.
>> - Link to v1: https://lore.kernel.org/r/20260128-gfp-noio-v1-1-9a808fc49b44@kernel.org
>> ---
>>  rust/bindings/bindings_helper.h |   1 +
>>  rust/helpers/mm.c               |  40 ++++++++++
>>  rust/kernel/alloc.rs            |   1 +
>>  rust/kernel/alloc/scoped.rs     | 171 ++++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 213 insertions(+)
>>
>> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
>> index 3791af0aadc7..df21b5b129a4 100644
>> --- a/rust/bindings/bindings_helper.h
>> +++ b/rust/bindings/bindings_helper.h
>> @@ -86,6 +86,7 @@
>>  #include <linux/refcount.h>
>>  #include <linux/regulator/consumer.h>
>>  #include <linux/sched.h>
>> +#include <linux/sched/mm.h>
>>  #include <linux/security.h>
>>  #include <linux/serdev.h>
>>  #include <linux/slab.h>
>> diff --git a/rust/helpers/mm.c b/rust/helpers/mm.c
>> index b5540997bd20..1e490b57057e 100644
>> --- a/rust/helpers/mm.c
>> +++ b/rust/helpers/mm.c
>> @@ -48,3 +48,43 @@ __rust_helper void rust_helper_vma_end_read(struct vm_area_struct *vma)
>>  {
>>  	vma_end_read(vma);
>>  }
>> +
>> +__rust_helper unsigned int rust_helper_memalloc_noio_save(void)
>> +{
>> +	return memalloc_noio_save();
>> +}
>> +
>> +__rust_helper void rust_helper_memalloc_noio_restore(unsigned int flags)
>> +{
>> +	memalloc_noio_restore(flags);
>> +}
>> +
>> +__rust_helper unsigned int rust_helper_memalloc_nofs_save(void)
>> +{
>> +	return memalloc_nofs_save();
>> +}
>> +
>> +__rust_helper void rust_helper_memalloc_nofs_restore(unsigned int flags)
>> +{
>> +	memalloc_nofs_restore(flags);
>> +}
>> +
>> +__rust_helper unsigned int rust_helper_memalloc_noreclaim_save(void)
>> +{
>> +	return memalloc_noreclaim_save();
>> +}
>> +
>> +__rust_helper void rust_helper_memalloc_noreclaim_restore(unsigned int flags)
>> +{
>> +	memalloc_noreclaim_restore(flags);
>> +}
>> +
>> +__rust_helper unsigned int rust_helper_memalloc_pin_save(void)
>> +{
>> +	return memalloc_pin_save();
>> +}
>> +
>> +__rust_helper void rust_helper_memalloc_pin_restore(unsigned int flags)
>> +{
>> +	memalloc_pin_restore(flags);
>> +}
>> diff --git a/rust/kernel/alloc.rs b/rust/kernel/alloc.rs
>> index 68d80f3fa6c8..5e4c142b5682 100644
>> --- a/rust/kernel/alloc.rs
>> +++ b/rust/kernel/alloc.rs
>> @@ -6,6 +6,7 @@
>>  pub mod kbox;
>>  pub mod kvec;
>>  pub mod layout;
>> +pub mod scoped;
>>  
>>  pub use self::kbox::Box;
>>  pub use self::kbox::KBox;
>> diff --git a/rust/kernel/alloc/scoped.rs b/rust/kernel/alloc/scoped.rs
>> new file mode 100644
>> index 000000000000..6745c06d6725
>> --- /dev/null
>> +++ b/rust/kernel/alloc/scoped.rs
>> @@ -0,0 +1,171 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +
>> +//! Scoped allocation policies for the current task.
>> +//!
>> +//! The kernel exposes several per-task allocation policies through save/restore pairs in
>> +//! [`include/linux/sched/mm.h`]: `memalloc_noio`, `memalloc_nofs`, `memalloc_noreclaim` and
>> +//! `memalloc_pin`. Each pair sets a bit in `current->flags` and returns the bits it added, which a
>> +//! later call clears again. The save/restore APIs assume strict LIFO nesting; restoring out of
>> +//! order corrupts the per-task state.
>> +//!
>> +//! This module exposes each policy as a [`ScopeKind`] implementation. [`ScopeKind::with`] saves
>> +//! the policy, runs a closure and restores the policy before returning.
>> +//!
>> +//! [`include/linux/sched/mm.h`]: srctree/include/linux/sched/mm.h
>> +//!
>> +//! # Examples
>> +//!
>> +//! ```
>> +//! use kernel::alloc::scoped::{NoIo, ScopeKind};
>> +//!
>> +//! // Every allocation inside the closure behaves as if `GFP_NOIO` were set, even though the call
>> +//! // site passes `GFP_KERNEL`.
>> +//! let b = NoIo::with(|| KBox::new(42_u32, GFP_KERNEL))?;
>> +//! assert_eq!(*b, 42);
>> +//! # Ok::<(), Error>(())
>
> I think this usage looks a bit strange, especially that you have to import the
> `ScopeKind` trait which is a bit awkward API.
>
> Any reason to not just have API like this?
>
>     memalloc_flags_scope(MemallocScopeFlags::NO_IO, || KBox::new(42_u32, GFP_KERNEL))
>
> Added benefit is that you can just define different scope kinds as bitflags:
>
>     impl_flags!(
>         #[derive(Clone, Copy)]
>         pub struct MemallocScopeFlags(u32);
>
>         #[derive(Clone, Copy)]
>         pub enum MemallocScopeFlags {
>             NO_IO = PF_MEMALLOC_NOIO,
>             NO_FS = PF_MEMALLOC_NOFS,
>             NO_RECLAIM = PF_MEMALLOC,
>             PIN = PF_MEMALLOC_PIN,
>         }
>     );

Sure, we can do that. It's a bit long to write, but I guess that is OK.

Best regards,
Andreas Hindborg





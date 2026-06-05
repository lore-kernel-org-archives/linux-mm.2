Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AF59CD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 11:47:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8563F6B0005; Fri,  5 Jun 2026 07:47:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 807166B0088; Fri,  5 Jun 2026 07:47:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71D876B008A; Fri,  5 Jun 2026 07:47:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 634E16B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 07:47:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0E3D51C278F
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:47:24 +0000 (UTC)
X-FDA: 84845683608.03.5FF2962
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf23.hostedemail.com (Postfix) with ESMTP id 342EC14000D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:47:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=p4Ys+lXf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3SLciagkKCJk3EB57KRAE9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3SLciagkKCJk3EB57KRAE9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780660042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b/IlIx044+gP0+18N3h3jc4/lRTkHNLG0jx4kZyUe48=;
	b=wvbr4gxZwq3EoJPgXcWMiJvO5qSNQcBT6leRH7jlatGMxV1yaaW9P0ENYCEWKauitfj94q
	etk5SBs1HKYGO92J2Wr5wy07DqXDWOHAEkZzcjaeIG9o2ApQ6v6DiF6DagFvpEDtYybLSQ
	pNlQrXfUSv0SLJchzYbaE0vgL0/h65c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=p4Ys+lXf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3SLciagkKCJk3EB57KRAE9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3SLciagkKCJk3EB57KRAE9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780660042;
	b=mbjLsI/1HqltmVM6yO+W1ES2cy2akWNsfpOpAOcrQYtnXcDmE1814ZYFEA6vd/WJM5r908
	ztQ8zbomWJvi+AGcTceirGSFU748nGA4YYBer5MBII+8eY0mrW+MGADxFfEA02QLgqDmxi
	qezVwygS3iZdRLR0JdedZAms2KWF5I8=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490aadb1386so13920135e9.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 04:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780660040; x=1781264840; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b/IlIx044+gP0+18N3h3jc4/lRTkHNLG0jx4kZyUe48=;
        b=p4Ys+lXfkYsS0Vbr1JZiTo6DLtkaHJfvQBsx7KPchUJwUJ1secmFadfX60X/CYW/LL
         LotkMnR/FN91TTZfN51pgvXZyN1nW3MNlLrsUj/gB3r0wksKOMsSHz//128EBQ20GeNr
         y6rx1Grto3ORwWYIKILaZfj64r73DJQACqADX2RlLP1nvmWDRJU2C4F0hjsk7I0GJCy2
         jdy2hEyOTOQD4QfMETmAyJ/lzh/r2IwVbuUDZRgUl7ULMmp+onR+dKj2Zh0ofuav6QpL
         ZaYB6ybDydg8eA/5plgNpkb29P1lEqXc/6NECG7Zjs324une8mXXZqKyGlNPAV8y11BB
         Ogfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780660040; x=1781264840;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=b/IlIx044+gP0+18N3h3jc4/lRTkHNLG0jx4kZyUe48=;
        b=ic6tSnRlthPnMphQgR8Ip49/GHZJpbfoe2RBpl+hyCVQTdKzAWaZj174WaOsDTpVtt
         YFHvUUX4JyK60DdayvQo6RNLL4SowBVYlBDqfIsia7HnPbebkGnNhZEd+IhoJYesfaAV
         1GWZAqNyZMLqt0gYoiH1lazrtd3LH4zusUBlqdh8FWe3v/lGjwsqQV8r7X7+CWU0qEQf
         iUZBLvQJfYiFyWzO+G23u8O5kwuSZ/WdYBquG99lKgrDESo1V4iILjcFp7X2V3ZSzBKa
         qgMyq7z4F8sBTX/IEPK+TEGwk9BUdE4Wt/EbKUjiCWHmosVCNdthhGbAvYaF2/1fT/Jq
         qCug==
X-Forwarded-Encrypted: i=1; AFNElJ+nGcAdO1quENaIcbRUVBc/vJxmgdq1Mb6YJuoNg0hfi+E4sjQg/xRb36YggSehmoHPYx1cYhaqOA==@kvack.org
X-Gm-Message-State: AOJu0YxJaOUq18hjkME+V3fML2l13gdEwc0D1fpvcudZ2JyWLbBWdEiP
	lC8QDaPDOTSgsebClMw8UYcUMP9/n5wGQSufkSlQV8CB8xWgnmNc3RUC/ia7Pkba5demQbk5WTt
	VSM0lDe+yJKLkJ7VH0w==
X-Received: from wmat17.prod.google.com ([2002:a05:600c:6d11:b0:490:af39:1573])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6096:b0:490:c1cb:48f4 with SMTP id 5b1f17b1804b1-490c2d038e8mr32041095e9.12.1780660040223;
 Fri, 05 Jun 2026 04:47:20 -0700 (PDT)
Date: Fri, 5 Jun 2026 11:47:19 +0000
In-Reply-To: <20260605-gfp-noio-v2-1-cfa2e236c2a3@kernel.org>
Mime-Version: 1.0
References: <20260605-gfp-noio-v2-1-cfa2e236c2a3@kernel.org>
Message-ID: <aiK3R1yRHj8zcGuh@google.com>
Subject: Re: [PATCH v2] rust: alloc: add per-task memalloc scope abstractions
From: Alice Ryhl <aliceryhl@google.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Boqun Feng <boqun@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 33tie4odsamyq68krdtb3apaaj1meffe
X-Rspamd-Queue-Id: 342EC14000D
X-HE-Tag: 1780660041-389237
X-HE-Meta: U2FsdGVkX1+pZ9P5ZpfEYW7eQFsEtWzJbxuQ5poTbIy0hsXbYbiWRnuNhEmcO/icElAs2yVLnlRGo78TA/TyJ3GVHZ6YwOaZGYsK1ikvUNVhd9t0mahW4tUPNRXCOhUyIcMzIHudIaq4VncKGJv4AETFmbC4/QYtE/fOwmDvdDou+3PkrxUk68DgUINQZFpdoVz+WYUUuxa1U8qvoBLAZbpJ1FfeTDFgUuske1UxpKGzC9+jGcf1kq2nW1am6FY2zIt1E3q8a/rRK+pfo6T4To7Dk7FbCZO0TXbimXosWtpQvGgDVVj35ecTrDPOD4uluml1yWRJTpwZwFgyM3UDMYXp2kGB6TNglLL2UAuMRQA8VFppX1Y5+NdRzJLR0C66yCbC1SVUQ6Sqi4RngHURk2GbbHe2f7Fv6kKEZlDC/Xd/d6CL+y1KucyzU7V9tL5bG48YvweP1JYu53bj50QGFOJP8SsUMfE1glBrphSootU/LaARpdcUjpTWBbqsAn0gFtKNDbBtZB7AWIzup8NvTTyNTN/KUqBCCBWGd+53jIygbdwXkGnuRCAngbT67ldsEwT38SE6f9wAL6ymmqvgt3iXOHRUJdAUjhKcJH48BoXcsHvLajRQ8sOQLK3dOnNC0msfQhnzoWn+5B+rWTe/foYFP/9tumpL8kiU1UXXPcHDLjFtpBmazJW4kPbUtn9lMc2uL6x7F0gOYGZfnYNIhSL6ZcU7CqoTj2CaoR3T3avv4jUh/kKJrUy16kMeJlZsFc+67CgE2/kAXvG2akTv58ge1CYOkw3yb/Xsl03YGz3PfTQdt0J3oWp72gw7sYeiS/5ghCSuVpqnMR1iqr7iPInrBzcQLTTZmNsJXIFk6CjsP6SDzvoLrCp6P6wiSLQZ3ozl+acnCNcXNtYDnwTTFwb8UgEpe+wt5Rq9JQeOPmhmoQ5X/BsgSABrtrL7IMPpE8abA/QdSjBkRcRWAN5
 P5aCb+1r
 W2pEBNoYHSzoiZi3BO80NKOtG6Pxkrxbswt7uAYei35N/kzdDzrXtWEOM4rc9jdkEit5RlTbvK5p6Nl+gXaoYDy5rlbdE2z6fuEG9cEG2aqoX+9ydVJ/I+w21prYLP89QUkrZTKx6NfwOvWIKRk3mm+6mF8kskp+dOL6RicvVWumzLy0vmb5ElkKUIN/XcDvTqYkGEJAswZtzOijTC/78nmYjzlaLzKmqo2xGsJ0+lOJvAgxNiFg9N9eoFEOCujRx0NtxjbbF48NAbQs6o/yOMOrpz5MLuxPSb56Q7WNvB07+yuO1ci/pwpBbiBYi7UTTjX0HxlLO9uhlEfhkYptdygRyFGV9BcWXN3Zb9vWAUJLmP0CyBsPyyc/uv4oxpUbBquJC+U5oujD+yCTq3Ggrd5yMM6RH0j4DAXz5JPXHUeWZnSyPdrE7gR4LwHk5xpYCl9dPg5OfYXBxp7pqoHioyBtYs5yZa0RMXzdUEleA/iLcHyyqKS4EGnii0/OJ7HG2AxBvXufFCZo096ztsHeZO4gsaDgtUMtUQc6S4Q57cjKD8XTX2ezWJmZRvAF08/YtnV++t8grvaAxP6i//e5PClgxyCBX+ZopV2r/rg0wVZwPk9qrXiX2LzY6RzimnyGxPYKQTt9EykxICYH8eBJacOvJZ8FzOPJyzfmAOTVPzw5LFcbKi6C8O4fk0biww/Evw4I4WL9vGr1C8NP5EbdvTM0SViorzFTvEo3yAWxzSoYiRVcaUX0wmZYeqli2i7e8GeOPHnm48Yqe7L+kPlRAJuaUx7MQ0Q9TtlK4Gt3El0jSfPNBHQfv8vGmBIdhdshb7lWSNPDv1bLoWHLWjIn/HcTU0cLkRuXwNSUKP6KuGrfQvT1plUcsWSU5zrEpI10+3GT1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 12:54:41PM +0200, Andreas Hindborg wrote:
> Add an abstraction for the per-task allocation policies exposed by
> the kernel through paired save/restore helpers in `linux/sched/mm.h`:
> `memalloc_noio`, `memalloc_nofs`, `memalloc_noreclaim` and
> `memalloc_pin`. Each pair toggles a bit in `current->flags` and
> returns the prior state for a later restore. The pairing assumes
> strict LIFO nesting; restoring out of order corrupts the per-task
> state.
>=20
> Wrap the four pairs as a generic `Scope<K>` guard with a sealed
> `ScopeKind` trait. Tag types `NoIo`, `NoFs`, `NoReclaim` and
> `MemallocPin` select the underlying save/restore pair. `Scope` is
> `!Unpin`, `!Send` and `!Sync`, and is only constructed through the
> `memalloc_scope!` macro, which binds it via `core::pin::pin!` to a
> hidden stack slot and hands out a `Pin<&Scope<K>>`. Safe code
> therefore cannot move the guard across tasks, drop it ahead of its
> lexical scope or otherwise violate the LIFO save/restore discipline.
>=20
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---
> Changes in v2:
> - Rewrite the patch to use scoped allocation flags instead of exposing
>   a `GFP_NOIO` flag constant.
> - Link to v1: https://lore.kernel.org/r/20260128-gfp-noio-v1-1-9a808fc49b=
44@kernel.org
>=20
> To: Miguel Ojeda <ojeda@kernel.org>
> To: Boqun Feng <boqun@kernel.org>
> To: Gary Guo <gary@garyguo.net>
> To: Bj=C3=B6rn Roy Baron <bjorn3_gh@protonmail.com>
> To: Benno Lossin <lossin@kernel.org>
> To: Andreas Hindborg <a.hindborg@kernel.org>
> To: Alice Ryhl <aliceryhl@google.com>
> To: Trevor Gross <tmgross@umich.edu>
> To: Danilo Krummrich <dakr@kernel.org>
> To: Lorenzo Stoakes <ljs@kernel.org>
> To: "Liam R. Howlett" <liam@infradead.org>
> To: Vlastimil Babka <vbabka@kernel.org>
> To: Uladzislau Rezki <urezki@gmail.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: rust-for-linux@vger.kernel.org
> Cc: linux-mm@kvack.org
> ---
>  rust/bindings/bindings_helper.h |   1 +
>  rust/helpers/mm.c               |  40 +++++++
>  rust/kernel/alloc.rs            |   1 +
>  rust/kernel/alloc/scoped.rs     | 231 ++++++++++++++++++++++++++++++++++=
++++++
>  4 files changed, 273 insertions(+)
>=20
> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_hel=
per.h
> index 446dbeaf0866..1931b131345f 100644
> --- a/rust/bindings/bindings_helper.h
> +++ b/rust/bindings/bindings_helper.h
> @@ -83,6 +83,7 @@
>  #include <linux/refcount.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/sched.h>
> +#include <linux/sched/mm.h>
>  #include <linux/security.h>
>  #include <linux/slab.h>
>  #include <linux/sys_soc.h>
> diff --git a/rust/helpers/mm.c b/rust/helpers/mm.c
> index b5540997bd20..b8e7492512e8 100644
> --- a/rust/helpers/mm.c
> +++ b/rust/helpers/mm.c
> @@ -48,3 +48,43 @@ __rust_helper void rust_helper_vma_end_read(struct vm_=
area_struct *vma)
>  {
>  	vma_end_read(vma);
>  }
> +
> +unsigned int rust_helper_memalloc_noio_save(void)
> +{
> +	return memalloc_noio_save();
> +}
> +
> +void rust_helper_memalloc_noio_restore(unsigned int flags)
> +{
> +	memalloc_noio_restore(flags);
> +}
> +
> +unsigned int rust_helper_memalloc_nofs_save(void)
> +{
> +	return memalloc_nofs_save();
> +}
> +
> +void rust_helper_memalloc_nofs_restore(unsigned int flags)
> +{
> +	memalloc_nofs_restore(flags);
> +}
> +
> +unsigned int rust_helper_memalloc_noreclaim_save(void)
> +{
> +	return memalloc_noreclaim_save();
> +}
> +
> +void rust_helper_memalloc_noreclaim_restore(unsigned int flags)
> +{
> +	memalloc_noreclaim_restore(flags);
> +}
> +
> +unsigned int rust_helper_memalloc_pin_save(void)
> +{
> +	return memalloc_pin_save();
> +}
> +
> +void rust_helper_memalloc_pin_restore(unsigned int flags)
> +{
> +	memalloc_pin_restore(flags);
> +}
> diff --git a/rust/kernel/alloc.rs b/rust/kernel/alloc.rs
> index e38720349dcf..8ebb8c9f3e67 100644
> --- a/rust/kernel/alloc.rs
> +++ b/rust/kernel/alloc.rs
> @@ -6,6 +6,7 @@
>  pub mod kbox;
>  pub mod kvec;
>  pub mod layout;
> +pub mod scoped;
> =20
>  pub use self::kbox::Box;
>  pub use self::kbox::KBox;
> diff --git a/rust/kernel/alloc/scoped.rs b/rust/kernel/alloc/scoped.rs
> new file mode 100644
> index 000000000000..0251792c9f3c
> --- /dev/null
> +++ b/rust/kernel/alloc/scoped.rs
> @@ -0,0 +1,231 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +//! Scoped allocation policies for the current task.
> +//!
> +//! The kernel exposes several per-task allocation policies through
> +//! save/restore pairs in [`include/linux/sched/mm.h`]: `memalloc_noio`,
> +//! `memalloc_nofs`, `memalloc_noreclaim` and `memalloc_pin`. Each pair
> +//! sets a bit in `current->flags` and returns the prior state, which a
> +//! later call restores. The save/restore APIs assume strict LIFO
> +//! nesting; restoring out of order corrupts the per-task state.
> +//!
> +//! This module exposes the policies as a generic [`Scope<K>`] guard,
> +//! parameterized over a [`ScopeKind`] tag. The type is `!Unpin` and
> +//! constructed only through the [`memalloc_scope!`] macro, which binds
> +//! it to a hidden stack slot via [`core::pin::pin!`] and rebinds the
> +//! handle as a shared pinned reference. Safe code therefore has no path
> +//! to either move the guard or drop it ahead of its lexical scope, so
> +//! nested scopes always restore in LIFO order.

Your scope trick only works in normal fns, not in generators such as
async fn.

> +//! [`include/linux/sched/mm.h`]: srctree/include/linux/sched/mm.h
> +//!
> +//! # Examples
> +//!
> +//! ```ignore
> +//! use kernel::memalloc_scope;
> +//! use kernel::alloc::scoped::NoIo;
> +//!
> +//! fn process_io_request() {
> +//!     memalloc_scope!(let _noio: NoIo);

If we're not going to access this value, then I'd just do:

fn process_io_request() {
    memalloc_scope!(NoIo);
}

or

fn process_io_request() {
    memalloc_noio_scope!();
}

> +/// Selects which `memalloc_*` save/restore pair a [`Scope`] wraps.
> +///
> +/// Implemented only by the zero-sized tag types in this module
> +/// ([`NoIo`], [`NoFs`], [`NoReclaim`], [`MemallocPin`]). The trait is
> +/// sealed.
> +pub trait ScopeKind: private::Sealed {
> +    /// Begin a scope on the current task and return the prior state.
> +    #[doc(hidden)]
> +    fn save() -> c_uint;
> +
> +    /// End a scope on the current task.
> +    ///
> +    /// # Safety
> +    ///
> +    /// `prev` must be the value returned by the matching [`save`] call,
> +    /// and the call must execute on the same task that ran [`save`].
> +    ///
> +    /// [`save`]: ScopeKind::save
> +    #[doc(hidden)]
> +    unsafe fn restore(prev: c_uint);
> +}

I think all this doc(hidden) + sealing + defining structs via macros is
unnecessary. Just make a normal trait. Or even just define four structs.

Alice


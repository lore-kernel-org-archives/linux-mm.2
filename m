Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F000606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 14:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bVPRAS4I
Received: by kanga.kvack.org (Postfix)
	id 86A556B05B8; Mon, 16 Nov 2026 09:22:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81B616B05BA; Mon, 16 Nov 2026 09:22:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E8C46B05B8; Mon, 16 Nov 2026 09:22:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 48CAC6B05B8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:22:51 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C9576A08ED
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:22:50 +0000 (UTC)
X-FDA: 85441198500.21.AD83B06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id ECDCB100004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:22:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bVPRAS4I;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794838969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q7YX+9dyGFWJKdiMqruL3+Phv2nda7J1UflyYeEe154=;
	b=63plok96uZwciSH2AUn9N9c5w19iBKGXRvJTOMEIoMlNp9eRo97M54FBrhUm2gCyNE0MIX
	nGay9BMkPtYTowSLB/2z+g899wNrR8aEqpYOU/LDMc7PGFEo0v2Mhsg2i5c9GwU0Nnf09j
	Z01vwS5NvCzRZAH+81YLMz1oOocNrVI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bVPRAS4I;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794838969;
	b=eIm01Qv/Ii+2FrTelvU6+0+7bs94nTZA7xsQUwD2DPjRE+maAJIQP5spHeDnJKbPuhCjgH
	UyJDGtbat2c3fGZn0MBmusOHmoOaU4PWcXsZM+m/BcKow9P9dWREetnYHKfyPdylxRKJwP
	aDYtYY28bz7t9zqHELNCHCOYiOUUpiU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 371624622C;
	Mon, 16 Nov 2026 14:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861C61F000C6;
	Mon, 16 Nov 2026 14:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794838968;
	bh=q7YX+9dyGFWJKdiMqruL3+Phv2nda7J1UflyYeEe154=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bVPRAS4ISi9Cr2SBiLu6me/I8F9XD9Hpialqs+coZLPP28SGn9gZK21XIm3lOKBIR
	 kmQo4PtlExYpD2KbEtu4soUCCmjrnXA8e/zQSdtLV9mD1rQ/55YDjSVQ1Z1UoE+REq
	 abhkYY7Vx55IKsBOYLMADsS/Ye/ZtZq7EvuTHBD/4szmRycUyNLpRmxu5lUAiah6ts
	 hD+6Zkg22O2QlAUNpaV4EGenX5nsL7Dfbb/xJmvlzhzV84+wuwr2BEK+Ubaiyyxq7a
	 B+5wbtnOKHVokksWHZTNor1ZaS/q5jp03VgA23DNM3qTUuYXckYWtJb7WxnldCJoot
	 SDLApDgmB8KWw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Nov 2026 15:21:02 +0100
Subject: [PATCH v22 5/5] rust: Add `OwnableIntoShared` and
 `OwnableTryFromShared`
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-unique-ref-v22-5-12029383206d@kernel.org>
References: <20261116-unique-ref-v22-0-12029383206d@kernel.org>
In-Reply-To: <20261116-unique-ref-v22-0-12029383206d@kernel.org>
To: Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Lyude Paul <lyude@redhat.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Christian Brauner <brauner@kernel.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Dave Ertman <david.m.ertman@intel.com>, Leon Romanovsky <leon@kernel.org>, 
 Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Igor Korotin <igor.korotin@linux.dev>, Viresh Kumar <vireshk@kernel.org>, 
 Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, 
 Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
 Michal Wilczynski <m.wilczynski@samsung.com>, Ira Weiny <iweiny@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Johan Hovold <johan@kernel.org>, Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Dave Jiang <dave.jiang@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Saeed Mahameed <saeedm@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, 
 Jonathan Cameron <jic23@kernel.org>, 
 Markus Probst <markus.probst@posteo.de>, Ira Weiny <iweiny@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, 
 Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 driver-core@lists.linux.dev, linux-block@vger.kernel.org, 
 linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linux-fsdevel@vger.kernel.org, linux-pm@vger.kernel.org, 
 linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org, 
 linux-usb@vger.kernel.org, linux-media@vger.kernel.org, 
 linaro-mm-sig@lists.linaro.org, linux-serial@vger.kernel.org, 
 Oliver Mangold <oliver.mangold@pm.me>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=11966;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=U9CWmU2KxA6SD/7pzz6JtYT0G1kYb/XvuXZ3sOh5A2E=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBq+xFUzcZPAnIxHgyNzn2PeEv3uGP5en1owdIyk
 aMs1oXMX3eJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCavsRVAAKCRD6UCkIqsW9
 0MFnD/42wEwNeIf1NU0r09nz9qdVmvVP8T1iODIvQPVxG6o6qsvWaUGik5RKaxg7dEnUp0R4Pt8
 nqC/Wne/5CFweHQRKW8sKdygZnCNDDuci9XGRiFn0LH3T9OLnCtw09S9asidVg0Ws6vcWuIlzGC
 5JdbAy9usEClEZuc4wY1K3UjzjW1brNQtpP9D9l3FgGzQclyJ+y6SAgCjRsmMUzMvhpG0CjaT4A
 gD7B+AugqORe1uyF3QtF4Z+8A3wHOA+qqBGIgFB/INtng1yAax6FDg53WfVmvsMxxmduj+YM21u
 Uc6EUnAv7zRIk+nxWOGTdxf0UG3dROcHVeo84d84vblMRLyKcC8mdOXWc1dHD9QWCD9GfvZwHni
 RKJk9yVEntHj+ktqLImzX2W4YKLP35PgGopMMEqV54cabfuyDRHAFguGhKHW50Cizo7Q3pRNvWH
 JdMmqU0YK4GNfxYPiO4X82yFb5IshIk+lqagNeyEcY7HfpNIUeRbw5IOThz5OwDiTP86dOdRPU3
 IpYjoGI8WrnmlEZvPsS5HfxovuLH9Qk06C+NEsrCNfLPuWAz3kKe7hinxCJSyPrUkRnXchOdMVg
 /iSX66c+ktrph8xuxiqLvXAqp0DMRef6MPBhQpKkgTiDLyQm8nekLSPkmbkI4KQBnIKr8k5Hhxt
 giA4OqQHTERJM3g==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ECDCB100004
X-Rspam-User: 
X-Stat-Signature: jsb4qstz4zmgq96hmt5r1c38bjqryur3
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794838968-617348
X-HE-Meta: U2FsdGVkX1/TH9u0+wLCgs+WjuB+hBXiUSduW+M6weX1sRkAo0OnrrBF1s5tdkfWK9MkcmFIxBA8/dlxO3Er8FzIB5otvZpybIlDLoowKUzVtwj8yQ2HfpsyuOWdye8k4RmorAihkAIX4NFBx/EJrl0BIk2A+na3uDBGyJh9q0T5LrciLcSxTWERWDoFMFohwdv4dNeqyaMlobIZ6Y9eFWv//enjT6VL7zOn5Q6fQLOnzLwCT2AuSmQy++utFOkYBM81nHs9MPniB1/hMKvZG348k4YXRCx0BZGJatp6tzFcKLIVh3Dth7iJRwB/leqRaRHJ+LKtBa2KdTXTWLr2U2TZwyHu8OE4FUdyy7C6c9fO9U/mOok15Ny1GtNql27Eo6/laFCb7fBv/KUim1zCj/m4mVXp/yMZRTLhcZMYfHvdQlLZEmFRldUnJybcrsG1cJblCWFIJS6ObIRNrYZnTqE/qPKh62nUYllPwV0oOF2HDLgC5Gn5pxACMOtuxvXd6zm4kD+FLiredWJ/yUhrRrNcZDQcMDR1Wn+Fv5+Vvs/dseZbA3o48R/ndWfgQ0bf/CERreZ6eLOxJRQLUItOuz+PfzroWuOLBsUFqaWiOmEzFmtLi12teWKWbN/1FqmlN7HFGK0Yy0tfKl6I2pPHZLNOFVGL50riSGH49X9w9TN0n/Cq3iqn4cINd8pB9mss8Ykl4mKAmBBgEf7OcqdGTsHq3cM6pH6/aTG4V826k4HwW17sPvJYqnkpKmARlru+iANke+gJUJWvojukGu/SlG/Gf3P6eizS/3nFdMHImz1MnLRBSi5JwI3aQJZ0EyB7PEeM1u7CQAl9OnmgBQ8CMB50ly4owB7ho09Sznp2QiXDGaSAzeLNmZ6rCVGFvYEE4MQ87kMiCExpExbf5XRrdcvn+FkKaMmGqvY09XnILKS9+bYtpGHkLCvXitXHlgtSCI+ou9cVzNL4F3JS+QZ
 krMo22mu
 p6LirmUxnlZsluptaM1ep4XSBpKGeuM07HEnfmqa3+0csKu1MmUu1m4wJQJc9Rn6nD0goi5Qawk+SXN9PQZzHQHTgQW2AKgN362fQ8UNasvrFgZ+uj51sp3PFGZn/7rHqB/E4UejSiSZXx6v+0llT6cJxmcQzhtvCESXhZMNuY7/Ctu0kElpOK3ObJooz+SGP6dqNPPyGkganK3L2Ah1DIbOD+0/ZBT0SzJV5HOtIJhl9xlyv4Cowbdylo4ka1jqsoFLWJwo6CeRXpY/DI1BAPmPPvgMikiSMT2SL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Oliver Mangold <oliver.mangold@pm.me>

Types implementing these traits can safely convert between an `ARef<T>`
and an `Owned<T>`.

`OwnableIntoShared` provides the infallible conversion from `Owned<T>`
to `ARef<T>`. `OwnableTryFromShared` provides the fallible conversion
from `ARef<T>` back to `Owned<T>`, which succeeds only when no `Owned<T>`
exists for the object and the requirements for creating one are
satisfied. For a type that does not allow other references to exist
together with an `Owned<T>`, this means that the `ARef<T>` must be the
only reference to the object.

The two conversions are provided by separate traits because they have
different conditions for existing. Some types can never become unique
again after having been shared, and such types can implement
`OwnableIntoShared` only.

This is useful for types which generally are accessed through an `ARef`
but have methods which can only safely be called when the reference is
unique, like e.g. `block::mq::Request::end_ok()`.

Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
[ Andreas: Fix formatting, update documentation, fix error handling in
  examples. Split `OwnableRefCounted` into two traits. ]
Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/owned.rs     | 165 ++++++++++++++++++++++++++++++++++++++++++++++-
 rust/kernel/sync/aref.rs |  16 ++++-
 rust/kernel/types.rs     |   2 +
 3 files changed, 181 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/owned.rs b/rust/kernel/owned.rs
index bfc52bc7f645..5b71d264477e 100644
--- a/rust/kernel/owned.rs
+++ b/rust/kernel/owned.rs
@@ -14,6 +14,10 @@
     pin::Pin,
     ptr::NonNull, //
 };
+use kernel::{
+    sync::aref::ARef,
+    types::RefCounted, //
+};
 
 use kernel::types::ForeignOwnable;
 
@@ -28,7 +32,9 @@
 ///
 /// Note: The underlying object is not required to provide internal reference counting, because it
 /// represents a unique, owned reference. If reference counting (on the Rust side) is required,
-/// [`RefCounted`](crate::types::RefCounted) should be implemented.
+/// [`RefCounted`] should be implemented. [`OwnableIntoShared`] should be implemented if conversion
+/// from unique to shared (reference counted) ownership is needed, and [`OwnableTryFromShared`] if
+/// conversion from shared back to unique ownership is needed.
 ///
 /// # Access model
 ///
@@ -329,3 +335,160 @@ unsafe fn borrow_mut<'a>(ptr: *mut kernel::ffi::c_void) -> Self::BorrowedMut<'a>
         unsafe { Pin::new_unchecked(inner) }
     }
 }
+
+/// A trait for types that support converting a unique reference [`Owned<Self>`] into a shared
+/// reference [`ARef<Self>`].
+///
+/// The conversion consumes the [`Owned`], so it cannot fail. Implementing this trait does not make
+/// the opposite conversion available. Types that can become unique again after having been shared
+/// can implement [`OwnableTryFromShared`] in addition.
+///
+/// # Examples
+///
+/// A minimal example implementation of [`OwnableIntoShared`], [`OwnableTryFromShared`],
+/// [`Ownable`] and its usage with [`ARef`] and [`Owned`] looks like this:
+///
+/// ```
+/// # #![expect(clippy::disallowed_names)]
+/// # use core::ptr::NonNull;
+/// # use kernel::alloc::{flags, kbox::KBox, AllocError};
+/// # use kernel::sync::aref::{ARef, RefCounted};
+/// # use kernel::sync::atomic::Acquire;
+/// # use kernel::sync::Refcount;
+/// # use kernel::types::{Owned, Ownable, OwnableIntoShared, OwnableTryFromShared};
+/// // An internally refcounted struct for demonstration purposes.
+/// //
+/// // # Invariants
+/// //
+/// // - `refcount` counts the live references to the object, so the object is valid while
+/// //   `refcount` is non-zero.
+/// // - `Foo` does not allow other references to exist together with an `Owned<Foo>`: while an
+/// //   `Owned<Foo>` exists, `refcount` is 1 and no `ARef<Foo>` exists.
+/// struct Foo {
+///     refcount: Refcount,
+/// }
+///
+/// impl Foo {
+///     fn new() -> Result<Owned<Self>> {
+///         // We are just using a `KBox` here to handle the actual allocation, as our `Foo` is
+///         // not actually a C-allocated object.
+///         // INVARIANT: We initialize `refcount` to 1, counting the reference held by the
+///         // returned `Owned<Foo>`. No `ARef<Foo>` exists for the new object.
+///         let result = KBox::new(
+///             Foo {
+///                 refcount: Refcount::new(1),
+///             },
+///             flags::GFP_KERNEL,
+///         )?;
+///         let result = KBox::into_non_null(result);
+///         // SAFETY:
+///         //  - We just allocated the `Self`, thus it is valid until the refcount drops to zero.
+///         //  - No other pointer to the allocation exists, so this is the only `Owned<Foo>` and
+///         //    no other reference to the `Foo` exists. Thus access through the `Owned<Foo>` is
+///         //    sound, and it can be used from any thread that `Foo` can be used from.
+///         //  - The `Foo` is not moved until it is freed in `dec_ref`.
+///         Ok(unsafe { Owned::from_raw(result) })
+///     }
+/// }
+///
+/// // SAFETY: We increment and decrement the refcount each time the respective function is
+/// // called, and only free the `Foo` when the refcount reaches zero.
+/// unsafe impl RefCounted for Foo {
+///     fn inc_ref(&self) {
+///         self.refcount.inc();
+///     }
+///
+///     unsafe fn dec_ref(this: NonNull<Self>) {
+///         // SAFETY: By requirement on calling this function, the refcount is non-zero,
+///         // implying the underlying object is valid.
+///         let refcount = unsafe { &this.as_ref().refcount };
+///         if refcount.dec_and_test() {
+///             // SAFETY: The refcount reached zero, so by requirement on calling this function
+///             // no reference to the object remains and it will no longer be used. We can
+///             // reclaim the allocation by passing ownership back to the [`KBox`], which frees
+///             // the `Foo` when dropped.
+///             drop(unsafe { KBox::from_raw(this.as_ptr()) });
+///         }
+///     }
+/// }
+///
+/// impl OwnableIntoShared for Foo {
+///     fn into_shared(this: Owned<Self>) -> ARef<Self> {
+///         // SAFETY: By the type invariants of `Foo`, an `Owned<Foo>` holds the only reference
+///         // (refcount 1). We consume the `Owned<Foo>` and transfer the reference to the new
+///         // `ARef`.
+///         unsafe { ARef::from_raw(Owned::into_raw(this)) }
+///     }
+/// }
+///
+/// impl OwnableTryFromShared for Foo {
+///     fn try_from_shared(this: ARef<Self>) -> Result<Owned<Self>, ARef<Self>> {
+///         // `this` is a live reference, so the refcount cannot drop below 1, and it can only
+///         // grow through an existing reference. Thus observing 1 means that `this` is the only
+///         // reference to the object. The `Acquire` ordering synchronizes with the release
+///         // decrements of references dropped on other threads.
+///         if this.refcount.as_atomic().load(Acquire) == 1 {
+///             // SAFETY: The `Foo` is valid and `this` holds the only reference to it, so we
+///             // can transfer this last reference to the returned `Owned<Foo>`. No other
+///             // reference to the `Foo` exists, so this is the only `Owned<Foo>` and access
+///             // through it is sound. The `Foo` is not moved until it is freed in `dec_ref`.
+///             // INVARIANT: `refcount` is 1 and we consumed the only `ARef<Foo>`.
+///             Ok(unsafe { Owned::from_raw(ARef::into_raw(this)) })
+///         } else {
+///             Err(this)
+///         }
+///     }
+/// }
+///
+/// impl Ownable for Foo {
+///     unsafe fn release(this: NonNull<Self>) {
+///         // SAFETY: Using `dec_ref()` from [`RefCounted`] to release is okay, as the refcount is
+///         // always 1 for an [`Owned<Foo>`].
+///         unsafe { Foo::dec_ref(this) };
+///     }
+/// }
+///
+/// let foo = Foo::new()?;
+/// let foo = ARef::from(foo);
+/// {
+///     let bar = foo.clone();
+///     assert!(Owned::try_from(bar).is_err());
+/// }
+/// assert!(Owned::try_from(foo).is_ok());
+/// # Ok::<(), Error>(())
+/// ```
+pub trait OwnableIntoShared: RefCounted + Ownable + Sized {
+    /// Converts the [`Owned`] into an [`ARef`].
+    fn into_shared(this: Owned<Self>) -> ARef<Self>;
+}
+
+/// A trait for types that support converting a shared reference [`ARef<Self>`] back into a unique
+/// reference [`Owned<Self>`].
+///
+/// The conversion can only succeed when no [`Owned`] exists for the object, and when the
+/// requirements for creating one are satisfied, so it is fallible. For a type that does not allow
+/// other references to exist together with an [`Owned`], this means that the [`ARef`] must be the
+/// only reference to the object. See the *Access model* section of [`Ownable`].
+///
+/// Not all types that implement [`OwnableIntoShared`] are able to become unique again after having
+/// been shared, so this capability is provided by a separate trait.
+///
+/// # Examples
+///
+/// See the example for [`OwnableIntoShared`].
+pub trait OwnableTryFromShared: RefCounted + Ownable + Sized {
+    /// Checks if the [`ARef`] can be converted to an [`Owned`] and converts it if that is the case.
+    /// Otherwise it returns again an [`ARef`] to the same underlying object.
+    fn try_from_shared(this: ARef<Self>) -> Result<Owned<Self>, ARef<Self>>;
+}
+
+impl<T: OwnableTryFromShared> TryFrom<ARef<T>> for Owned<T> {
+    type Error = ARef<T>;
+    /// Tries to convert the [`ARef`] to an [`Owned`] by calling
+    /// [`try_from_shared()`](OwnableTryFromShared::try_from_shared). In case the conversion is not
+    /// possible, it returns again an [`ARef`] to the same underlying object.
+    #[inline]
+    fn try_from(b: ARef<T>) -> Result<Owned<T>, Self::Error> {
+        T::try_from_shared(b)
+    }
+}
diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
index 6bc58aae38ed..8a029d124fa3 100644
--- a/rust/kernel/sync/aref.rs
+++ b/rust/kernel/sync/aref.rs
@@ -23,6 +23,10 @@
     ops::Deref,
     ptr::NonNull, //
 };
+use kernel::types::{
+    OwnableIntoShared,
+    Owned, //
+};
 
 use crate::{
     prelude::*,
@@ -40,7 +44,10 @@
 /// Note: Implementing this trait allows types to be wrapped in an [`ARef<Self>`]. It requires an
 /// internal reference count and provides only shared references. If unique references are required
 /// [`Ownable`](crate::types::Ownable) should be implemented which allows types to be wrapped in an
-/// [`Owned<Self>`](crate::types::Owned).
+/// [`Owned<Self>`](crate::types::Owned). Implementing the trait [`OwnableIntoShared`] allows to
+/// convert a unique reference into a shared one (i.e. [`Owned<Self>`](crate::types::Owned) into
+/// [`ARef<Self>`]), and implementing
+/// [`OwnableTryFromShared`](crate::types::OwnableTryFromShared) allows to convert back.
 ///
 /// # Safety
 ///
@@ -193,6 +200,13 @@ fn from(b: &T) -> Self {
     }
 }
 
+impl<T: OwnableIntoShared> From<Owned<T>> for ARef<T> {
+    #[inline]
+    fn from(b: Owned<T>) -> Self {
+        T::into_shared(b)
+    }
+}
+
 impl<T: RefCounted> Drop for ARef<T> {
     fn drop(&mut self) {
         // SAFETY: The type invariants guarantee that the `ARef` owns the reference we're about to
diff --git a/rust/kernel/types.rs b/rust/kernel/types.rs
index f97b8ab6dad5..8905dd1c6c4e 100644
--- a/rust/kernel/types.rs
+++ b/rust/kernel/types.rs
@@ -21,6 +21,8 @@
 pub use crate::{
     owned::{
         Ownable,
+        OwnableIntoShared,
+        OwnableTryFromShared,
         Owned, //
     },
     sync::aref::{

-- 
2.54.0




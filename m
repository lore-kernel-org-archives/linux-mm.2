Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86D0FE9B24D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 11:19:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6FD66B008C; Tue, 24 Feb 2026 06:19:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E31116B0092; Tue, 24 Feb 2026 06:19:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3CF56B0093; Tue, 24 Feb 2026 06:19:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BB89A6B008C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:19:33 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7066F160477
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:19:33 +0000 (UTC)
X-FDA: 84479104626.02.07CF83E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8C9F714000F
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:19:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rSIs5xaY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771931971; a=rsa-sha256;
	cv=none;
	b=YiZytyWjMtW07FaYyKht6EXJImiFHxdlsLr+LLtcZbiM1xLN3qL7YvaJ7WZ1zAr++7J/S8
	cbuS9yCZqX006qmOQZWT9TGpZOu8pBQitRUE7Vla4SYz278k3ZuYiaJnN3PCTRCTGh+eWH
	+TZKaCxF3/ZPP7/lBgS69PvlVlLeExE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rSIs5xaY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771931971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Prhn1oEzFX4TO/bR9hne2JK394R4AOJYTdfHgDRvUM=;
	b=MX4QK0+wXsMaMmKN95L6hLvDC15zgQZSwNITdGlqSOBen1VSgxNs5VjpopTs9K+nNjIr8h
	r/en3MDxoqtybxgfZfwiwEX6+omfXmzszaHOXWQE53qXKgCOpuZ3qgj+P9mlAvoxFAEvYK
	Ghkhhu9Jwm3f5K/aTAfMMqTGRjHyPq4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 096F06132E;
	Tue, 24 Feb 2026 11:19:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145B2C2BC9E;
	Tue, 24 Feb 2026 11:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771931970;
	bh=vsbKnA/MqIcTGDzEOIbnd0zjHmEAks3lbNLt2RyB7cQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=rSIs5xaYwbO5bV7v8Fd9jXQHDqD1BtoGXO0cKq94E3mv00JGkBy4JIxudPQzenNMI
	 HPxAqq0Lm4b2+I6NCv2CTMYvcHsaFanOnvhBDXTcY8RmBPMZPhGv645Y5GlvI69/pY
	 oON4gMp27HHpgc3Uta97xstv9G2bvE8BvKYENLp//cx0w8YYNtq0g/6D3xuoi/8SyX
	 ccFUI8GVPnmUp9xPFNnpEoJSXw52iXeudZrCuDcfNFjvRgKOTzM5Bq52dtvp4xCkfo
	 03IrqVwPaSbEF2zTJS29fLDVFygFHtUC29gSL9VPhhyjIk+gwYHE+TpZ9UhhtwJL4x
	 3Rqpyrwjcn5Ag==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 24 Feb 2026 12:17:57 +0100
Subject: [PATCH v16 02/10] rust: types: Add Ownable/Owned types
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260224-unique-ref-v16-2-c21afcb118d3@kernel.org>
References: <20260224-unique-ref-v16-0-c21afcb118d3@kernel.org>
In-Reply-To: <20260224-unique-ref-v16-0-c21afcb118d3@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 Serge Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Igor Korotin <igor.korotin.linux@gmail.com>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
 Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
 Uladzislau Rezki <urezki@gmail.com>, Boqun Feng <boqun@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, 
 Asahi Lina <lina+kernel@asahilina.net>, 
 Oliver Mangold <oliver.mangold@pm.me>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=10433;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=t20FLxM+uzXpAHcpcxVIpgEft5jpKX8+J1Yew1bC0XQ=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpnYj1/GeK2UnMGGaWmFO3qx7xN6IcSm5HMxR0M
 5KazgtSMa6JAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZ2I9QAKCRDhuBo+eShj
 dwW1EADCes/KZywz5ZPjVovKtSjgO6zrEQxUF0rmxbpyo53QWGEmM85gKhsm+MK4tMKt46pY9YA
 QAspBuLPArM1uD62f2ijqru2/wUcL1XwYRO8BPin0+Qb9E1qmTasIj+q9K+/KKa8j6EviTylola
 8AmYFe+Bdd1aNEa3bsa+NWtpMab5LadsRVv4ZKfZwj1A4psSmL6nco/8A+0zsa2gWWjqIoqkNcb
 xzvnyW7aUqkOn2R4+4B9uS4Do92bSTTieFqBTfJnH/jPfxQ/sW65TQHZL+tGn3UfEHDvCCeNPbT
 0lsBZqayFdfJVexiuOE/CNzThWoLh3i7TN+AJ1QnSauY48/PLRLceuBQp438n7FeQTp/FMGl4sa
 5yNqdVrHs6IEVEXRg85Vnx8gHQJ4KJgK++t74+pfx+fgu4Uk/uLiJXhJdG16M8JeY+xfcyti8b1
 kpBkE0OZ41RzJ79DuN08oBiR5GYQMk2JUAaD8ubckWB1+ZyTZ8S8luKUKZDPdlbp4P4HUuQxKon
 TDI9GxlwB2vR4rC0i9csouooPmMuuhCixWLHDU/errKfpZhV1S5vHt/E0isliSvN6QuKpz3MjRZ
 yx/s/ffY5RBpkdhxUPeQs/WyS2c7jOk8QY7jv+RYxzAW8gNaqeodFXRr7tjq5VD4FHXI8Jb57dM
 XWhQiJY7qHFCIMw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8C9F714000F
X-Stat-Signature: m3rntqc5prtqm4cdtaxees6c679wsu61
X-HE-Tag: 1771931971-176158
X-HE-Meta: U2FsdGVkX18/IVqQykNfqg1o0hVC7OJuErG8x85I6adhfBRLoOYfNMQMwQ+eMyECPiQfY4UFTsXa19Vaztv7Y+Cv9fVf9CoGmeDQ6tcN4MO5eKY+z6Kq3uig897IymQ+2V+Dyyxg3bPqfI1GYewGw52esSUgit7gbOzwCstd/ZKSfRfmOr/mUsdlwbqi4xH9HhECmjOMObNxsAme6c5pY14xj9/vXI6Gx4ljwVrsG4wwZx3U8JMT/6QfPJsz2iuvu1TCZJG1XyFxwLYy4YSeMOyE6ULSSUDO5il501mvio+qkM/I+LRnCiVHSxvpFpglW2WZM3k5IzoIQrDE4yJWA8OTpQAuwqweor9cZgT3dCXCBTuVNFCIBHbxIe9F3mZA9h5HYYib+M8zeEyqhpZkU7kRDhcpinZ8FqtgFDxR3l258LFb2cs8sLeHRsBqaqLC/+0de+95X+C135jGUCzwaUiBYX5xcbW+whqEtduaHcTLjyjtnkwqr6e21Yl829465rQtJb7/a8+8KYTagdy48yBxo/uh842W5EYGgIQQ5Xic+mAOTsM9Uar18ta/QyjgiLVPTdL6ywikkTSMTEN9orcMUuYy6e5eigujUUBv0Nf9wZ86pfp/YMa3ByQ7OaqG2bO3neHX5Nkjo/D5l/J41+N5EDu8foHCP38DG2mhjkw2XwAx5nB359sHBzJaVmY2baFNUqz4oBhsdPtT8Pbgus57IIKwD2YdvhJ9qNSD90hwm4yroFlfN6zJzVbTCT/eYy4r/NkawJLM51prjRdD9hj46PLyAViNopEpebH4XLoDF+Ec+WlBE+JWjKEQZuGhwJGNyQ1zX+aTXrPy0cogU+d1jL+ozqenePjEtd10U5Za/WbojR0eTqQTNNAaMSXnLJVPlKglQKOr4o8ttXLYkHtK+VHW/+LQoaMv2YlIJZ/Sk2jYvY5BQKLMPG/eHWAuYfThhdebuTe1DZKhON+
 bzVdzm4a
 +9Kd+SUw4WHdWfXEHXG0N1lOWyjqNWGbHeqXZwhPXm7x44nO/CVV/IZIbnCc5wiUC5QtbnmL4d3PEeefFDJtEreCnnvVrDk3d9kEger5uK0Q0qJDIYoebIxjmsB1lpwo9lMwjggvvaWw1n9hN2AZzfUIrFRBc/XIY6PV5YhBSrdm4tw9Cz00qmjvHxJSp9RQYZqbZ0e3KewPdGh6yQWHCUmxN88i2rEQDkz+J9iqHRpagFD3PGSPUzUP8DQjvAvUDwdghK5K1DyqG/9shxo/p0lTrJ3fjdmfix0L9tL0BYOozYgLcnkfMBi+aEtF25PfgApAHB8xI/3ZlajYurwrPTNOyTQlKkjTvWUPJXk2tGegwaDjTFgvKKK6N/GL4uUVrAJ4GMl5+SDQuTEdpnvg8FCwBh/5MYkzG/D7N1IlJ0tEZWFwjWretlS1V1o8Uj9gTBZHd9Og0dbyC/ecWnoxLapDwEDj9I3gdgqQbeeaUzFqVByDgBfQl4s6wNKmXNshSo7VjsRWiJy8Llyw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asahi Lina <lina+kernel@asahilina.net>

By analogy to `AlwaysRefCounted` and `ARef`, an `Ownable` type is a
(typically C FFI) type that *may* be owned by Rust, but need not be. Unlike
`AlwaysRefCounted`, this mechanism expects the reference to be unique
within Rust, and does not allow cloning.

Conceptually, this is similar to a `KBox<T>`, except that it delegates
resource management to the `T` instead of using a generic allocator.

[ om:
  - Split code into separate file and `pub use` it from types.rs.
  - Make from_raw() and into_raw() public.
  - Remove OwnableMut, and make DerefMut dependent on Unpin instead.
  - Usage example/doctest for Ownable/Owned.
  - Fixes to documentation and commit message.
]

Link: https://lore.kernel.org/all/20250202-rust-page-v1-1-e3170d7fe55e@asahilina.net/
Signed-off-by: Asahi Lina <lina+kernel@asahilina.net>
Co-developed-by: Oliver Mangold <oliver.mangold@pm.me>
Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
[ Andreas: Updated documentation, examples, and formatting. Change safety
  requirements, safety comments. Use a reference for `release`. ]
Reviewed-by: Gary Guo <gary@garyguo.net>
Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/lib.rs       |   1 +
 rust/kernel/owned.rs     | 181 +++++++++++++++++++++++++++++++++++++++++++++++
 rust/kernel/sync/aref.rs |   5 ++
 rust/kernel/types.rs     |  11 ++-
 4 files changed, 197 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 696f62f85eb5f..a2bec807f03f1 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -121,6 +121,7 @@
 pub mod of;
 #[cfg(CONFIG_PM_OPP)]
 pub mod opp;
+pub mod owned;
 pub mod page;
 #[cfg(CONFIG_PCI)]
 pub mod pci;
diff --git a/rust/kernel/owned.rs b/rust/kernel/owned.rs
new file mode 100644
index 0000000000000..26bc325eee406
--- /dev/null
+++ b/rust/kernel/owned.rs
@@ -0,0 +1,181 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Unique owned pointer types for objects with custom drop logic.
+//!
+//! These pointer types are useful for C-allocated objects which by API-contract
+//! are owned by Rust, but need to be freed through the C API.
+
+use core::{
+    mem::ManuallyDrop,
+    ops::{
+        Deref,
+        DerefMut, //
+    },
+    pin::Pin,
+    ptr::NonNull, //
+};
+
+/// Types that specify their own way of performing allocation and destruction. Typically, this trait
+/// is implemented on types from the C side.
+///
+/// Implementing this trait allows types to be referenced via the [`Owned<Self>`] pointer type. This
+/// is useful when it is desirable to tie the lifetime of the reference to an owned object, rather
+/// than pass around a bare reference. [`Ownable`] types can define custom drop logic that is
+/// executed when the owned reference [`Owned<Self>`] pointing to the object is dropped.
+///
+/// Note: The underlying object is not required to provide internal reference counting, because it
+/// represents a unique, owned reference. If reference counting (on the Rust side) is required,
+/// [`AlwaysRefCounted`](crate::types::AlwaysRefCounted) should be implemented.
+///
+/// # Examples
+///
+/// A minimal example implementation of [`Ownable`] and its usage with [`Owned`] looks like
+/// this:
+///
+/// ```
+/// # #![expect(clippy::disallowed_names)]
+/// # use core::cell::Cell;
+/// # use core::ptr::NonNull;
+/// # use kernel::sync::global_lock;
+/// # use kernel::alloc::{flags, kbox::KBox, AllocError};
+/// # use kernel::types::{Owned, Ownable};
+///
+/// // Let's count the allocations to see if freeing works.
+/// kernel::sync::global_lock! {
+///     // SAFETY: we call `init()` right below, before doing anything else.
+///     unsafe(uninit) static FOO_ALLOC_COUNT: Mutex<usize> = 0;
+/// }
+/// // SAFETY: We call `init()` only once, here.
+/// unsafe { FOO_ALLOC_COUNT.init() };
+///
+/// struct Foo;
+///
+/// impl Foo {
+///     fn new() -> Result<Owned<Self>> {
+///         // We are just using a `KBox` here to handle the actual allocation, as our `Foo` is
+///         // not actually a C-allocated object.
+///         let result = KBox::new(
+///             Foo {},
+///             flags::GFP_KERNEL,
+///         )?;
+///         let result = KBox::into_nonnull(result);
+///         // Count new allocation
+///         *FOO_ALLOC_COUNT.lock() += 1;
+///         // SAFETY:
+///         //  - We just allocated the `Self`, thus it is valid and we own it.
+///         //  - We can transfer this ownership to the `from_raw` method.
+///         Ok(unsafe { Owned::from_raw(result) })
+///     }
+/// }
+///
+/// impl Ownable for Foo {
+///     unsafe fn release(&mut self) {
+///         // SAFETY: The [`KBox<Self>`] is still alive. We can pass ownership to the [`KBox`], as
+///         // by requirement on calling this function.
+///         drop(unsafe { KBox::from_raw(self) });
+///         // Count released allocation
+///         *FOO_ALLOC_COUNT.lock() -= 1;
+///     }
+/// }
+///
+/// {
+///    let foo = Foo::new()?;
+///    assert!(*FOO_ALLOC_COUNT.lock() == 1);
+/// }
+/// // `foo` is out of scope now, so we expect no live allocations.
+/// assert!(*FOO_ALLOC_COUNT.lock() == 0);
+/// # Ok::<(), Error>(())
+/// ```
+pub trait Ownable {
+    /// Tear down this `Ownable`.
+    ///
+    /// Implementers of `Ownable` can use this function to clean up the use of `Self`. This can
+    /// include freeing the underlying object.
+    ///
+    /// # Safety
+    ///
+    /// Callers must ensure that the caller has exclusive ownership of `T`, and this ownership can
+    /// be transferred to the `release` method.
+    unsafe fn release(&mut self);
+}
+
+/// A mutable reference to an owned `T`.
+///
+/// The [`Ownable`] is automatically freed or released when an instance of [`Owned`] is
+/// dropped.
+///
+/// # Invariants
+///
+/// - Until `T::release` is called, this `Owned<T>` exclusively owns the underlying `T`.
+/// - The `T` value is pinned.
+pub struct Owned<T: Ownable> {
+    ptr: NonNull<T>,
+}
+
+impl<T: Ownable> Owned<T> {
+    /// Creates a new instance of [`Owned`].
+    ///
+    /// This function takes over ownership of the underlying object.
+    ///
+    /// # Safety
+    ///
+    /// Callers must ensure that:
+    /// - `ptr` points to a valid instance of `T`.
+    /// - Until `T::release` is called, the returned `Owned<T>` exclusively owns the underlying `T`.
+    pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
+        // INVARIANT: By funvtion safety requirement we satisfy the first invariant of `Self`.
+        // We treat `T` as pinned from now on.
+        Self { ptr }
+    }
+
+    /// Consumes the [`Owned`], returning a raw pointer.
+    ///
+    /// This function does not drop the underlying `T`. When this function returns, ownership of the
+    /// underlying `T` is with the caller.
+    pub fn into_raw(me: Self) -> NonNull<T> {
+        ManuallyDrop::new(me).ptr
+    }
+
+    /// Get a pinned mutable reference to the data owned by this `Owned<T>`.
+    pub fn as_pin_mut(&mut self) -> Pin<&mut T> {
+        // SAFETY: The type invariants guarantee that the object is valid, and that we can safely
+        // return a mutable reference to it.
+        let unpinned = unsafe { self.ptr.as_mut() };
+
+        // SAFETY: By type invariant `T` is pinned.
+        unsafe { Pin::new_unchecked(unpinned) }
+    }
+}
+
+// SAFETY: It is safe to send an [`Owned<T>`] to another thread when the underlying `T` is [`Send`],
+// because of the ownership invariant. Sending an [`Owned<T>`] is equivalent to sending the `T`.
+unsafe impl<T: Ownable + Send> Send for Owned<T> {}
+
+// SAFETY: It is safe to send [`&Owned<T>`] to another thread when the underlying `T` is [`Sync`],
+// because of the ownership invariant. Sending an [`&Owned<T>`] is equivalent to sending the `&T`.
+unsafe impl<T: Ownable + Sync> Sync for Owned<T> {}
+
+impl<T: Ownable> Deref for Owned<T> {
+    type Target = T;
+
+    fn deref(&self) -> &Self::Target {
+        // SAFETY: The type invariants guarantee that the object is valid.
+        unsafe { self.ptr.as_ref() }
+    }
+}
+
+impl<T: Ownable + Unpin> DerefMut for Owned<T> {
+    fn deref_mut(&mut self) -> &mut Self::Target {
+        // SAFETY: The type invariants guarantee that the object is valid, and that we can safely
+        // return a mutable reference to it.
+        unsafe { self.ptr.as_mut() }
+    }
+}
+
+impl<T: Ownable> Drop for Owned<T> {
+    fn drop(&mut self) {
+        // SAFETY: By existence of `&mut self` we exclusively own `self` and the underlying `T`. As
+        // we are dropping `self`, we can transfer ownership of the `T` to the `release` method.
+        unsafe { T::release(self.ptr.as_mut()) };
+    }
+}
diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
index 0d24a0432015d..e175aefe86151 100644
--- a/rust/kernel/sync/aref.rs
+++ b/rust/kernel/sync/aref.rs
@@ -29,6 +29,11 @@
 /// Rust code, the recommendation is to use [`Arc`](crate::sync::Arc) to create reference-counted
 /// instances of a type.
 ///
+/// Note: Implementing this trait allows types to be wrapped in an [`ARef<Self>`]. It requires an
+/// internal reference count and provides only shared references. If unique references are required
+/// [`Ownable`](crate::types::Ownable) should be implemented which allows types to be wrapped in an
+/// [`Owned<Self>`](crate::types::Owned).
+///
 /// # Safety
 ///
 /// Implementers must ensure that increments to the reference count keep the object alive in memory
diff --git a/rust/kernel/types.rs b/rust/kernel/types.rs
index 9c5e7dbf16323..4aec7b699269a 100644
--- a/rust/kernel/types.rs
+++ b/rust/kernel/types.rs
@@ -11,7 +11,16 @@
 };
 use pin_init::{PinInit, Wrapper, Zeroable};
 
-pub use crate::sync::aref::{ARef, AlwaysRefCounted};
+pub use crate::{
+    owned::{
+        Ownable,
+        Owned, //
+    },
+    sync::aref::{
+        ARef,
+        AlwaysRefCounted, //
+    }, //
+};
 
 /// Used to transfer ownership to and from foreign (non-Rust) languages.
 ///

-- 
2.51.2




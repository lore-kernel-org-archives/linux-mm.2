Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F44DCD6E77
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 20:13:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FE336B00A3; Thu,  4 Jun 2026 16:13:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D5B86B00A2; Thu,  4 Jun 2026 16:13:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C4776B00A3; Thu,  4 Jun 2026 16:13:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4AD7D6B00A0
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:13:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF1991C0AC7
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:13:16 +0000 (UTC)
X-FDA: 84843329592.15.256C3B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 283411C0006
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:13:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d7+DGx4k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780603995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FyqbifIs0gEb+brR0HRbFPYYe8b52/vPAxEVwbskZ2U=;
	b=FxLlD4GKOs7hla2EHhyx/wQuRseekw1hlT6F3yZcXbdsDTRGxwxUAi1Im4P2KCK/uQYTDD
	HMChwnjJib0A1RZQGnbJh4hJD7Hy85J9uHe7cf1cYejUaGSoLI/UWdvngGLtVZB42xJnyg
	Qwbq0TiKljz4i4un7PHP2/7IGR/N5cM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d7+DGx4k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780603995;
	b=QgqBbzG8ytJHtnGGVoU4n+06RbOW7iANw3O8IKBdlV9bF7NfRZMJ0B1DhkBhfINKgHz5Px
	2wmiVlve/fQoPLVVl8sB4jW3UFxbjpXc408+4JBL/fT5qZtDruxqsYencMHM470Ch2q2KH
	eudC+noXyy1dD/B45sLMvxg/TnOn05c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 55A7344244;
	Thu,  4 Jun 2026 20:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B489B1F00893;
	Thu,  4 Jun 2026 20:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780603994;
	bh=FyqbifIs0gEb+brR0HRbFPYYe8b52/vPAxEVwbskZ2U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=d7+DGx4kRvBF22JK7YfD6UvK3MZe3cZ/G1pHGIQ/3H8UfQSOg7Ieg0mx1bvLq8xYE
	 stPU76+2J+5djPEJUrJ1IJm9wxEsW9K1zFRweb/+eze4ZwWaK8HxgXzLBfo8ZCB7ex
	 E6JVc6TzkG/cwill6Ag6itwfXLT+HjIzQS4e2j4JAEXcKLJ1ea2ES/Y2Aixk+6YMcV
	 +zPKqF7gU8duISScX8HUFNycYk6Q9tClZy4tbVRZfiMySzFe/DI/+aarw/vw5bQ+zy
	 sK5VJR26InjGBY29wYKn90akDlQ9bsTfZNRrgTc8VLd0dHkUdyQeYrz3ziSwEvPitl
	 Du+Cpa9aaWiug==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 04 Jun 2026 22:11:14 +0200
Subject: [PATCH v17 02/10] rust: types: Add Ownable/Owned types
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260604-unique-ref-v17-2-7b4c3d2930b9@kernel.org>
References: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org>
In-Reply-To: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org>
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
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
 Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 Igor Korotin <igor.korotin@linux.dev>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Boqun Feng <boqun@kernel.org>, 
 Igor Korotin <igor.korotin@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, driver-core@lists.linux.dev, 
 Asahi Lina <lina+kernel@asahilina.net>, 
 Oliver Mangold <oliver.mangold@pm.me>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=10553;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=ofZDFIhDjpLPpUbpvtXo6zWuRmODfjHMDH0JWHuSFdY=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqIdvofKBkFboGfACnM0viGjPeiixT1NxDQcbNU
 MsW74xazMuJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaiHb6AAKCRD6UCkIqsW9
 0DEkD/4gf7Ho/vS4edp6caiLITOv/bLkSQN5bDrgSo/Dqw6VjWYilBwVVAiLblnteDI9tSnZAz4
 evcQDaMvY7IrsQilUAtM8OixDbWtvlR+x/eslY/TZ3XhvbZhSLsMnQ8UkkHAOto8tCBTvl53I5a
 G8FmcHac+ptW26zaW0XNDXoedp4ZU4w/MElpuhCWopnNx578V/5+/Kd0++KK9AJdewxigY+O09R
 XKMuyGtiteZwpDtUCDrndWu6LUELJFBk8DlTERSF7P+OV3b/Z3bb9nsbkjC2dNa6SG0WmIUu3OP
 QeyC4cPcKPSTzIGcS8ecFZzwJp5ChQN+O3DEGMwV9NTEV9WrrGRGEeqcW05Jd8akGmDILrPT9uw
 7PPhGLGSGJvPJ94joJDKzhWeGGQKN4Ypt7eKVQMrFp9Ydul9sXRxfanYsRd7xUsVCJsXHe0qRhw
 axz+zRqxcYG96KESp5w1DAN0DXXjeDg5Tip6/Di/vvvoZrcnl66TJxO8IaBQoKUir/7KAjhvDKh
 6sAopNMKeJY/bAeb+sNVhiaT50U9xhsI6ME1e6JBNS2dFoe68qSHt4tpl0mNEtS+P2FRcWnIkw8
 9wvr6lwo2ivn1lb6ppIFBpmHrqozyBAsxUj/60/7Ugd0+pXRJQrGpGnYAMRg8JMKgAIEIQN+hgo
 Di9hhF085JUUMWg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: cx1h198478kby5cuqi3csdbyj3ohghbd
X-Rspamd-Queue-Id: 283411C0006
X-HE-Tag: 1780603995-974669
X-HE-Meta: U2FsdGVkX19YBi+Ra08rLSNnR2X8nxLWX0LK240ddRHwR/QhMOuK4ZT+ZCWjMXLs2yaOzO/F6hdyobKVALREnjBhutoq06vqkv8s918aiAoGsPDbtGH/Pup7lszlzcYEo8RsUcwG7cDzby52N+q9ywcGq5GnFY3XWx9sGwrYIuzKF0IqjsraPVsc3obghugd24ORgfEkaS8pOWjaNv3XSBMfft6JxuZRtXzSB0NICo4M+/jN2vLFbzvJAwII62awp5ht3/YT1WIkmviAqBZQSTNXj63C3Jz9F9qizqljtkvry2oaqUc9pJZsMlDjt13rGR6MTIsQ16IzOKK1ugRHmYGxkGJ+H+xl2hkBxTXUXFk1i6V/zfzDc8H+ZhFftxHLQS1wxKeqanXLUGwZ42nbSoGkICkDFujWF5hLnbKB3Q7Uhi1IrywFeS6OSGewUBhD0R6onNQh/tI3xshAnK4e2mYDfSle/hevkstuTULhYIdWzw52fnGKXX4nd9WkK49Bbn1YshotgSqzc/AYcIVhyVNKX/fiCfvdCy7yUX5tMOkacFNuiXvyM/kVm2WfD4qmxwy/OIRINdvbBRLZ73HUyQJ/ukr1Y/vK+qpTehzg7Shq60d9tettQurHO9ou4tHPYsX+smMcYBswTI9RvcENX92UiCaJOtj6tQQiJlbIIRMLz2Zs/BrV9wSUMA7iAzMIfoU2xTTvEtTX6ZHnZzT1yYy6do0NRjXVh3/t9f2KeWpwJ4EbjTT1wh9U9WU74L8bcXQMIpKu4sKGNRxPuIP2AD6cw1IG3Gsk+INh3bQsyU2c1y7y5C8jbAAQi3kv2W7G/Cg2JDHryn0CFiuCZ9os6xRzkpkmsltmaVgjgHpNjE0NJgyFpTKmndpNVBBvHCDqVAIJ9FDDymwHLQIfLfQRpytI9J9jacW7K3eZX8aEfOQQqSmZv7OU1MYhg3E+ZU7heSv8vSE8CjlBmeyJD+4
 iMMb1eXp
 COKexPCaugK21HdO0O77uHGKzX9+WXNRhOCa78W9jtGd8p/ynHR2pqM/GWuCF8I6DoFPjgbpA1m1BE9uXsjMtssToA0c6BRniN+Fbg25N+LeZ2KfkYon/CGiWTMCa2mPmV95D9V+QdSV0nn5wsp+5Bxpjky0YDGrVo10HHsAl8X0cDupO/d9Vs72sdNvV7jZj7F4eDQj3sNjQ2jDq+lBlnAuP9NSKoa9wK/eYXOXN6OqCKz3sVK0kYIfN+YKYH8f9WBduBqiolU7WL1Sp7lzSmEwT+sA/KWUse/LCJZCA3S8do1lJMSBN4IO/ivVppmaIlevTZbkDvL90006PfzuQYbeI92QNm2wVR/2X7LK7uklsbZIvlrNfHkLcHxytFrrlh+L0r//wtXVD5masFlEEy2sWMIHbdvn1urTT2Au//05q/9PzON9APooEG6qxD+P4uPai90YY7TL1M433cJ6tcOx+PsxQbBn8jPdGLD5bgJ44y/HFKvah92j4dJXmQr9eQZsI4e35qgpvWZeVkILoQXr/r3ZNsEfBVnnW3Fz8PM8jvovWP89WWnoqwg==
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
 rust/kernel/owned.rs     | 187 +++++++++++++++++++++++++++++++++++++++++++++++
 rust/kernel/sync/aref.rs |   5 ++
 rust/kernel/types.rs     |  11 +++
 4 files changed, 204 insertions(+)

diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index b72b2fbe046d..d07759eec799 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -100,6 +100,7 @@
 pub mod of;
 #[cfg(CONFIG_PM_OPP)]
 pub mod opp;
+pub mod owned;
 pub mod page;
 #[cfg(CONFIG_PCI)]
 pub mod pci;
diff --git a/rust/kernel/owned.rs b/rust/kernel/owned.rs
new file mode 100644
index 000000000000..456e239e906e
--- /dev/null
+++ b/rust/kernel/owned.rs
@@ -0,0 +1,187 @@
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
+///         let result = KBox::into_non_null(result);
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
+    #[inline]
+    pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
+        // INVARIANT: By function safety requirement we satisfy the first invariant of `Self`.
+        // We treat `T` as pinned from now on.
+        Self { ptr }
+    }
+
+    /// Consumes the [`Owned`], returning a raw pointer.
+    ///
+    /// This function does not drop the underlying `T`. When this function returns, ownership of the
+    /// underlying `T` is with the caller.
+    #[inline]
+    pub fn into_raw(me: Self) -> NonNull<T> {
+        ManuallyDrop::new(me).ptr
+    }
+
+    /// Get a pinned mutable reference to the data owned by this `Owned<T>`.
+    #[inline]
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
+    #[inline]
+    fn deref(&self) -> &Self::Target {
+        // SAFETY: The type invariants guarantee that the object is valid.
+        unsafe { self.ptr.as_ref() }
+    }
+}
+
+impl<T: Ownable + Unpin> DerefMut for Owned<T> {
+    #[inline]
+    fn deref_mut(&mut self) -> &mut Self::Target {
+        // SAFETY: The type invariants guarantee that the object is valid, and that we can safely
+        // return a mutable reference to it.
+        unsafe { self.ptr.as_mut() }
+    }
+}
+
+impl<T: Ownable> Drop for Owned<T> {
+    #[inline]
+    fn drop(&mut self) {
+        // SAFETY: By existence of `&mut self` we exclusively own `self` and the underlying `T`. As
+        // we are dropping `self`, we can transfer ownership of the `T` to the `release` method.
+        unsafe { T::release(self.ptr.as_mut()) };
+    }
+}
diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
index 9989f56d0605..4ee5fac0e0b6 100644
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
index 4329d3c2c2e5..4aec7b699269 100644
--- a/rust/kernel/types.rs
+++ b/rust/kernel/types.rs
@@ -11,6 +11,17 @@
 };
 use pin_init::{PinInit, Wrapper, Zeroable};
 
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
+
 /// Used to transfer ownership to and from foreign (non-Rust) languages.
 ///
 /// Ownership is transferred from Rust to a foreign language by calling [`Self::into_foreign`] and

-- 
2.51.2




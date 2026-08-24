Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A57FFC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 11:20:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFA306B00A4; Mon, 24 Aug 2026 07:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA9F86B00A5; Mon, 24 Aug 2026 07:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A72A66B00A6; Mon, 24 Aug 2026 07:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7A5566B00A4
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:20:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 144EE1204B8
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:20:04 +0000 (UTC)
X-FDA: 85135918728.23.5FECD40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 26E2C180009
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:20:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k9Ss1Imm;
	spf=pass (imf24.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787570402;
	b=r9qCBsfInGN28TYpsvuC+exitV8xBo1MxaRuLDTD/LKrmJguKeQ9sE6MY0ZnbaM2lWfO9l
	ImpXgXOBTm7w/pek5wFm8cWoho/5qtv9VqE2mVaqI0Sw7TYk89EBpD3+KNWLyL2480ublS
	1YaMHRIVA4M9AlPLbY0+qKWkCflQQzs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k9Ss1Imm;
	spf=pass (imf24.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787570402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nW0Gvd41fIKfum8lv47xbr88JVN0R0Y3bAVxdgTJ0C0=;
	b=sTpaM/esXUeJiY7mn9oOLzkIIEOdFXM+9CWpQWCY87xaeTd9NoKY8PLi13ZUSnKi9cWtUk
	S+x12bjZo05KhJhDJDxoLOO/OKBblEHLjrNY5dEQx0RyN/x6l4u1zFO9n0TDUrOqwtIiPX
	3TsKynU6hx98pYtHA8J184JT4QYuSVk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D5DA407ED;
	Mon, 24 Aug 2026 11:20:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F4E1F000E9;
	Mon, 24 Aug 2026 11:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787570401;
	bh=nW0Gvd41fIKfum8lv47xbr88JVN0R0Y3bAVxdgTJ0C0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=k9Ss1ImmnTp+BNiJNQZZ1ogLaSj2TK3mGrEp+cfMzZa4dLWPVFQQuxdLWtQufl3t/
	 c97tCZshgvAk+N3/c7q4EFEW3QVe9BZAnEDz6SdSCW46ca8AnlglvoKt0wapYtiY5n
	 FDAqcwST7FZOUw3rYYksuz1dvdeaBy7fIQMZ4chh3vfK/XQyURqRS1nPnR3w+zpG+a
	 URubS/a5Qt3Uz2vcweFTiRSnrPW1Z0Ns/f3sbZtrNRHxUvfV1VrzB3fbu4Zgcsu695
	 2lwjWs/5Fd1nBPLSqmLNLCPyQv6QvXFtBIrGZVh3KK7LBZhDLM0uVOwmx+Puz1/9D/
	 +Zvpf4i+pVn7g==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 24 Aug 2026 13:17:54 +0200
Subject: [PATCH v20 2/8] rust: types: Add Ownable/Owned types
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260824-unique-ref-v20-2-490735672187@kernel.org>
References: <20260824-unique-ref-v20-0-490735672187@kernel.org>
In-Reply-To: <20260824-unique-ref-v20-0-490735672187@kernel.org>
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
 =?utf-8?q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, 
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
 Carlos Llamas <cmllamas@google.com>, 
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
 Ira Weiny <iweiny@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, 
 Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 driver-core@lists.linux.dev, linux-block@vger.kernel.org, 
 linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linux-fsdevel@vger.kernel.org, linux-pm@vger.kernel.org, 
 linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org, 
 linux-usb@vger.kernel.org, Asahi Lina <lina+kernel@asahilina.net>, 
 Oliver Mangold <oliver.mangold@pm.me>, Boqun Feng <boqun@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=10621;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=GO++Qeu4a7kF68yEw+Vn2C+P9gU67mXjb8+4Ea2xpsk=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqjCiBdMlT+SR0TYzYvvg6VCUOxiI5R9GJUJyUK
 HV55E54nEGJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaowogQAKCRD6UCkIqsW9
 0O0+D/9qBRK1TCio6k/0Tta5g889WaW728AnR/eO41sejRdpQpqDaI3a0o+Y1GFvN+pRg0WKTrZ
 R54Yp2LuDujUdHqQ8Syzo2oqWCXFq/eahqpkuZOYzuXrOdkgaw9K2vtVdKHV1YB38ry8X0gwfGy
 PovKTCmGojSGX/T9zv7y9JNH1aqGNB/VDObHwWbFAGNTiwZvuCOMq9sw3UsZC/JAyw9xW1bfUT7
 Yhrls48eNxQ7lXUvT3ScVCQp6rADcg1fpR2QMdR72J36osQv4/yVTlqOH2ncZ03bp7Vj6RQPMdE
 t0ZcqPpTno5JultwD0VnueS3mR4bzbc9ZKfd3ParNPokfnmb7UONiTTYHukeB926IY1yl/WJeA+
 9v0V37erUsVUJQSWpaXZmDSkRxiyR6qBGG22LGljugJd+kIMOzRFmMWf1g8VzkYy4StbMU2bnJi
 s6axtmCIBrIl4rxAHwtZ1YG+Kij//5I2r4h4wMFNvON7YQRH0N89d0ccf8K3x948UMp1bfJTlvW
 FBNp5JqhH24rzGY1i6e1kIBDKSd7ea2mQmbXqMwgX3mP7z586EWo6GqtuA3Z0wmLCgyWsZUR3iv
 w6/GfvX5jwnyDCttAHEaXPvtuvW27YHe0WLGHE4NEh8BNuvw/uAB8PXRsDV0MkZdzApTt0QO0Ra
 y+xRkgSiP1RBm0A==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 26E2C180009
X-Stat-Signature: 6rrohgh8934o5da64mw7hm5z3514hceo
X-HE-Tag: 1787570401-171784
X-HE-Meta: U2FsdGVkX18BRiipN+YlYcozhES8T8KktkMxsifT7Mfdf6uv151jLsBBS8huVLki7iq+nLADLwZL3r28yUDH2l2j491ghzgSgT4FupRftbKLPbz9hxU+ZjlVAkO9cyCijgL/qZ/HYiB3P6Tu+iYzSj+9pOqKhYUGyd7cqNoVluM3/2rt8Zzw+7yQEPT6dqtjhzm5Xq6TtmZN4jI+NA9PYcLnBGLi9Cwv3bFej8mt5VRs0f+48fKtaceAAEHiq5I+bfb6Q4Rz+9+RGdJkwfg6YMFmFMvjSVEikmqzlkP5f+c3n7YZVTRCB95FVopJoxi6lE4kQHdxbSNl+BRtblNk+qxXTa0IxMIcedFWx3AwF2NsDhRQOoaDFpFXLkLByRJyVWmvPqpMc8uXzbU+sY9rqGNDVg5OvCpe8AwLszVoWg67/qkbKBIvqlLFryNdYMCh5Jq16RgfGSWxzF+YfpbL89voFjk9KvmVcUEIR2h//a6ubWnD+PbpLvzHL3jXyRYkBZ9yqQnAQQ8XKIpZkzeec2amFeiZEHcn0ugztXj5QL+IYUeR/IDMgllrByaIYwVTItnZbPtMJKbolj+/iXLyo3A7XLrh04A0zofIcQ+n9nAIJ3JoWkDGYdsVoFzl6ddNRdPUAhESqDNAgKPOnPW0TIJxJQ13RSc3Z0IhuXq+Vb8RQDI1H1rgU4FEjD2QGCHMyxr16YEQPxmECAvQz3umLefcYjpZBohNWZcaU9NVEIBMFDNIufStGI/WfFieQ1Y7rv6X8HpFeagqw70JCxrXlz7SB3xhTSyFJ1BVmff48+PqLfwA2izp4P+Wtln8shfBCRjIJAlV3wI1JnPC50zVU5GHMrVf1R5Lw6176ctQ+hDulxmI26miiTbavPcgsresKu6KdMhoXt0to1ntCt3zou2XlBT9YLq56xmVr6Fm+c8s3X3k6OQsrGKtCLde2hmzxC2lr7xL8UX9/zXK7Eg
 +nWdogac
 z0pBlvIp3pzH7hs650S5UrVfpXQAwLQwzEOwfgntcU/ofg/O113wmqQiq/ohNkODe94/k82fJSds9y/vvjTL42Kd9NB28Bh2nwJS/yTyrhgeZaGKTfzheFs77HSHXPgSMk42xLl8DUub0pgA+Abv70F4k/QhUgWnofiCFO0iKemA0FMecdJLv+WDVJVlULsHPmV7ASmcW77xiS3nhwIcsgIgtmL79Ny6ZQQYvfbeWNAoZLQMHoBbaCf1bU+OfjhMc3lhH+KL6POwAWvVrksZ2RayoZqBGg+LBsTV3bBol0PSll1h41Sht5WdN0JBgQolALKiUvSo5kvnEq5dx+bqWsEtFoUCrtCEwDaZ1nFGXvycFHgi/yrfTS14wbOhxw6P2Idw+4H7ZZiN3SuuYvHpuhH22lxZdsDYaoiYuh9qin7RriaZvSXRNgid7zOgd3I+zYqaoTr7Lq0EFUiUuEVxZOlhUDfn+5B4fxUXDiGSdmVQxjrgsVBRe8Jo39tUWsXALCJJBz32mgiLXLl50OETpF+LtfsDURQqe4gorPUnFnjriZBFc1ey63DZ9YZcZxvtflhCzYwuG+nG3mok=
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
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
[ Andreas: Updated documentation, examples, and formatting. Change safety
  requirements, safety comments. ]
Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/lib.rs       |   1 +
 rust/kernel/owned.rs     | 188 +++++++++++++++++++++++++++++++++++++++++++++++
 rust/kernel/sync/aref.rs |   5 ++
 rust/kernel/types.rs     |   5 ++
 4 files changed, 199 insertions(+)

diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 9512af7156df2..eb5256204a174 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -101,6 +101,7 @@
 pub mod of;
 #[cfg(CONFIG_PM_OPP)]
 pub mod opp;
+pub mod owned;
 pub mod page;
 #[cfg(CONFIG_PCI)]
 pub mod pci;
diff --git a/rust/kernel/owned.rs b/rust/kernel/owned.rs
new file mode 100644
index 0000000000000..7fe9ec3e55126
--- /dev/null
+++ b/rust/kernel/owned.rs
@@ -0,0 +1,188 @@
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
+/// [`AlwaysRefCounted`](crate::sync::aref::AlwaysRefCounted) should be implemented.
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
+///     unsafe fn release(this: NonNull<Self>) {
+///         // SAFETY: The [`KBox<Self>`] is still alive. We can pass ownership to the [`KBox`], as
+///         // by requirement on calling this function.
+///         drop(unsafe { KBox::from_raw(this.as_ptr()) });
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
+    /// Callers must ensure that they have exclusive ownership of the `Self` pointed to by `this`,
+    /// and that this ownership is transferred to the `release` method. `this` must not be used
+    /// after calling this method, as the underlying object may have been freed.
+    unsafe fn release(this: NonNull<Self>);
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
+        unsafe { T::release(self.ptr) };
+    }
+}
diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
index b721b2e00b986..3bd5eb8a1a526 100644
--- a/rust/kernel/sync/aref.rs
+++ b/rust/kernel/sync/aref.rs
@@ -34,6 +34,11 @@
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
index ac316fd7b538f..c41eab0ec983c 100644
--- a/rust/kernel/types.rs
+++ b/rust/kernel/types.rs
@@ -15,6 +15,11 @@
 pub mod for_lt;
 pub use for_lt::ForLt;
 
+pub use crate::owned::{
+    Ownable,
+    Owned, //
+};
+
 /// Used to transfer ownership to and from foreign (non-Rust) languages.
 ///
 /// Ownership is transferred from Rust to a foreign language by calling [`Self::into_foreign`] and

-- 
2.51.2




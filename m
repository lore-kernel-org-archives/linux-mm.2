Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71191CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 11:55:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 336E56B012A; Fri, 26 Jun 2026 07:55:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E6A46B012C; Fri, 26 Jun 2026 07:55:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AE926B012D; Fri, 26 Jun 2026 07:55:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E10586B012A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 07:55:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 63A43A042D
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:55:10 +0000 (UTC)
X-FDA: 84921907980.10.40A0344
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id A3F02A0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:55:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G68sawEu;
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782474908;
	b=R/O9XvCftffaDzxTfnEEXL98It39NLUXlredIJJEZuB1MV43EVdj2kQhdGQSriOeiKIVZD
	tRsC0gXidDd5Rz1F63G1uM78Fn0FvvPibmdU4itNgAV/dhEl6cwFa6/bbr/qqqOlWNFue0
	7tIsSihchBkhJR2kv1Hb58eZLhPZME8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782474908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nW0Gvd41fIKfum8lv47xbr88JVN0R0Y3bAVxdgTJ0C0=;
	b=Eyrp/etFVRqsXrqIGwaJemXvr+L4L5IP/7U0nwhqwqOGhuCXD0HCxEq8femltlcjApBlBS
	WnKEjz+2fChH7n78Ey3ZhMq37zO1Js+zbnXbKfFx7AR+QrWmS41xhEGgHoo7Y1kyPftH27
	0YJJotaqEYkZZbMofTSxCc4WgQh9SdA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G68sawEu;
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 27C20600AE;
	Fri, 26 Jun 2026 11:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82911F00A3A;
	Fri, 26 Jun 2026 11:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782474907;
	bh=nW0Gvd41fIKfum8lv47xbr88JVN0R0Y3bAVxdgTJ0C0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=G68sawEuw+gEvqSfSgurM7H8cAkWAHHc6igip6wdMvPx6CefxPsB/T2xUn2kCSied
	 ZmSRemfer+uGIJh/z4JgqMrkcwvu0XpteGfHapJw0qfiRwoWvby8q03TQliyFOjjm0
	 ZHancFmG7ACiJdcmiBLfge7bmJnJwUmMQO4yjgS1hea4gA/9HrrCOVeqWhKltu0Gm1
	 TI7xYOuH1sMW55p8gfHH8LO4FKT5m3FO0z9jASrwCtYWJ6nbg6DgnKXRBQHbLhHZIq
	 PLiJSME3FXBcswt7d7RGbWQ331j6AukmnKqhpTLmgq6UY9QpT3kMqTrMRtv3lWM8AD
	 ptkP5B81t14XA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 26 Jun 2026 13:53:59 +0200
Subject: [PATCH v19 2/8] rust: types: Add Ownable/Owned types
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260626-unique-ref-v19-2-2607ca88dfdf@kernel.org>
References: <20260626-unique-ref-v19-0-2607ca88dfdf@kernel.org>
In-Reply-To: <20260626-unique-ref-v19-0-2607ca88dfdf@kernel.org>
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
 Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 Serge Hallyn <sergeh@kernel.org>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Igor Korotin <igor.korotin@linux.dev>, 
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
 Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
 Michal Wilczynski <m.wilczynski@samsung.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, 
 Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 driver-core@lists.linux.dev, linux-block@vger.kernel.org, 
 linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linux-fsdevel@vger.kernel.org, linux-pm@vger.kernel.org, 
 linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org, 
 Asahi Lina <lina+kernel@asahilina.net>, 
 Oliver Mangold <oliver.mangold@pm.me>, Boqun Feng <boqun@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=10621;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=GO++Qeu4a7kF68yEw+Vn2C+P9gU67mXjb8+4Ea2xpsk=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqPmh1e991thBmNS1larSf58N6lP82euFt+uGl4
 /Nen0uyLP2JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaj5odQAKCRD6UCkIqsW9
 0LtiEACjpG+/YAYTyEyB97MqMW3AK9a/VdW3xvgboml23uZ0sLTW7YL0ZrVRGBTcyEpowCalfk5
 VPA10IRd0mO1LTk7pH7nmC08j8BpjFJAUd+YP0V4G5m4+DIpk2tM8uCGMckFA6zd3EdTL5KG2N1
 VnB++2B7UAYyvoh3d9/7rTsdxgdue/c6KrVy5UmYZQ712dYCnMi101z1Bg5g48EKVDkS9Z3fcQb
 z9+oLWFrFbtfrgNDoACvW+2EbDDdic3ZFC7hfe3F0nbVskO89kqoNP1AE2cnCvF/T0Lx/K4FM9Y
 I/buCan9NnPiN9XpDp2hGfRxcmwkwSxCKh3pKqMd86ijJe+E9RZBvIoiCVasLNAZcOD96+fjv4D
 1+oGBLvncLjDS9u7OcqDmVV+F+Fz6qqiY2ipMFVXtkAz4k1GlqEMxpj1WMZOiWH5xMuzhn22dWd
 bU4zHkW5N2ILFifY6Sxip97LBzXIiTJ9aMtm6pcFlXW9UhjPUIaDPlOpfKaG7s2F921bcuVXXT3
 K0V+F5CDojDbbMAu+f/L9T0Cq+M68EcV/OowMGgQgrdgs9HBKTnPJi6eakLH2TcKtcQSBQQVWQk
 HQHFxG/S+rjupRoK27Li0WMX1JULcawxDUNY5t62O3Z3Vd7EeoD8ZNccEyMV+OQc4sXCn1CW1OA
 YYLmizDpaAmO/SQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: yuqbsrgmysce77cjthmot6yspiyt3b4p
X-Rspam-User: 
X-Rspamd-Queue-Id: A3F02A0005
X-Rspamd-Server: rspam02
X-HE-Tag: 1782474908-356620
X-HE-Meta: U2FsdGVkX18l53kgCMUWf2ovNqhO8I1Fk9XI3nvFi+cfDO99KHTaggTK1N0BZlcx/Gjzs+D4TzbGv3qUukc9vC4+UM18OaElM88Vh/jwQe2UCD+0q/SmaDa3aUk7MdwvKXaQuwDJCZG+7PH2m1ZQa+IkG07sxeWdBj8p2bjGPUj2ePKaHLbxcIgCw+2I+W+DIZN8jPqBZeH4INM7vEt/D+M/+oEeqVnnp04o+OxXbpcpdkSbnVCLEg2BRls0Ui7UvQUb/hXTh+JVP4s8MoFWEm0R18ikpw3w5TJC4SncDjzHL7Hb0GHelUQCoDZfhdqEPGopv8CfISzSAwlh3PhMCYyARjrchoCG3sIA2mzRphZxs1PuLasx1A7E5cnT5nzxpgK8Q6sjEL87VM7G57+5wVBpDocyjX1pETnApiHYX4y0C/AJOQWeQNxRQwf54doHGZmz8sBCOSRM7Ew25W1bF0OZHsJb9J4l8PPqtd+paOVGdbNxGyLT+ytpgw6OXf8Nwnp2XYiVqUOTBXXBcuiUnQamlsvOAuZ4sUREU1WjF0agvQIu0aBr9dM+Xbd6FiVxw5ehlfGhGYM76EWZQIWtxCa3ZOa0KOdKCVJRiHZh1Qc9s4p8Jhp4HuFNenBxXY0MceD1JZ6EGZJByLlLBks7dNBN1PX/Ec2ixZSnAb+knlVaRoAfWVPlvrD3IvtYhtPA2K7syAb8/St91jywN+xtuDtlCNuQd5vxzvynAx1JpwTjKRTpvFfAxu8M6Uw17QRtR2mToHkhiSfNqWFhrnjE0B4X0Hh3lzS/kcfqem2H2VMfKFGoUAIi2QLencC2mINs2NVe0dW97NwDSVD87Lk6L90PdCtgv9wt5A4un4RFJ1/7W/FUMGfrgSMpmP2achdN1lactEygDXyMNbuI0KTwCmBUjOdHhct0C6PePcdl3yhJcu+GYDpxtrlOPizFHv2canWRS0JDWyXugewFcod
 V0I2stdA
 D+rOBbyd5858noIoWXH++pFXLGJeuBGDVJ+dtvpu2suJ4XqVTz6DTRfCWVc68EX3tei5AfET4RkM4yBPTM0HGAvF4mcjWCOqvXxnQYRIx7Ri0+jzc+WeFbyfKH9HZHF2XgkTx+BCFYHjHet8LHC9tCVschIEN1yC61Ol70NGzZKZbcL8X56e9altaQGxQA7ggdzxVEIWdMcbd8SVGsHCSfbJTN9UCSSsRy2WoUpe08uqE/P0i12b64q195uhPvTH/+wvVMjNek3xV1xrvZQgv0CyBHWmJ6e7l2wfQBSum8eLyEU93HG1qcZi8fFnEJr9Fpno6JqkppcwaKk/Ws/mzxbImBQa1ByuBO7NS1s6q917+YDPTUQEksE0qeD421O3Zze9Nyppik/ds6OuuHRbuYdaXEhmN1j07EDDZs7U4mRUUcByMznjK09RvduHmc7wZ/0KKM72KPha0m2ZDLnAKXVqbK1KvvkxRgqdKPOReEOxDZ0qWCEcmF/Gi5su5Ohr0+C9ou6vrvsJl7oNX/KAqv9zAghMbRCnasEMqFpUYU5ZBpVTEIu/IQNvLic//pMQhEikD6ML9FmKBlJgk0icB8QFjRQ4Idia7QwZmPjOpI0+bRqP2PNL97Wd1yvExbBpQ6aXNIXuWn9IxJ2fctVou6SLtHBBgc4PaXnb5HWZ+cbxtiNARCvVDEWMXw+FDB6jtZFfc
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




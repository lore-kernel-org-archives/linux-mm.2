Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E10D9CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 13:35:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 860BC6B0092; Fri,  5 Jun 2026 09:35:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C52A6B0093; Fri,  5 Jun 2026 09:35:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68E846B0095; Fri,  5 Jun 2026 09:35:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DBD46B0092
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:35:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0408A1C002B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:35:55 +0000 (UTC)
X-FDA: 84845957112.14.2FAE1F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E10C32000C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:35:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KC+dlDQu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780666554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J7xoJI8ZQKXEZmPwD70InQg1kBZths2uP7Ky23DxVzU=;
	b=K56dfyKLeqElZdAljsGLjDT/dhtF+ZfyFwm6pQuQ0Irxa4Nt0TWo5EOgh90y/zbsz1pw3n
	TQokRlSy1lEP7l0DucUJ/UJrH6AJNHKUV+iyHaUx0Ex86mL5Tolq7WIzBpm39s66J6QxR9
	1OxQjDPxhS1pl2ctoA++57kYzY1p7A8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KC+dlDQu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780666554;
	b=MW6uJTda3zwTUGkyGmyaufT/UI1YRv53TZiXAkmAwx9qMbJGux1MQepKFSKAUwSji/5rox
	lkOTQ1y8hUMdSOezRiV1GCiIfKFSUJSoXuz5egsjzD1b4WZ9RTr6/q7G01O+yx4LAiIUZP
	2jbkDYROlu9DfpCmeUrNcSkYGPVy4Ao=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2CFB34397B;
	Fri,  5 Jun 2026 13:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159A01F0089B;
	Fri,  5 Jun 2026 13:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780666553;
	bh=J7xoJI8ZQKXEZmPwD70InQg1kBZths2uP7Ky23DxVzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KC+dlDQuLqP3rCxErxpehrd3GNGE3Vr0cTPgWZSw6PUJxdbN+0G0p0UdThXjimlJn
	 +LYiEFSfMV678aDl9NPwnj0wiblRyUXunenVKEUldJerWiCpV/M0DtOGalY/xbTI4K
	 R8L/WJeyh567HlbuTzPiCpo7V4GakqK/hScoGCp57ji37Wm/1b8dqWxkHG3KYg4hrX
	 umGAXuRN4afcDy7tMpplcZXMK8SR2/Jpx/k400iGbVaU34s0BdQ84Sr2zg3K9g1lXX
	 YZ0AeI/SKm48a+e4vqlaF3Z/S6GQr+TdDBkC65NOIfGNOod+po10Hd5gMvW0BRsKa+
	 To3F+BJJQLjRA==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 62C58F40073;
	Fri,  5 Jun 2026 09:35:51 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 05 Jun 2026 09:35:51 -0400
X-ME-Sender: <xms:t9Aiai47PuS_pOtnW8X385FiiuUmYlH9UHzqY1Jdra5sGYVxX0gGxA>
    <xme:t9AiaoUHom0ziRQ-x-W6GD0aPRh6hdPO6mACneZWpgQqetcPHqctBGnm9jH3GBRol
    gvUw2_oG05hnpFe3OAaGzH2IV1RKiZb7_6oZFNNRVx1wcHC-b5dxQ>
X-ME-Received: <xmr:t9Aiaov8OJAxJZXuy0B4_U3zmlzdHuIIX1An3H4HJ4xFDOLHheWlPIpgjPM>
X-ME-Proxy-Cause: dmFkZTEiXmK80I+r4b+5zY/r99GUAlO/A1JeBVvrzdPJND7AxnXROcGIdrV5+IW/GIICbk
    HTeSUzo2jG7T3ubuXDYawvMsJmw7SeRzXaVjmYhKpesaWDi/jHlBwDSw7cUJtOL4Zml+HR
    MdH91GjghnCvkbpZdNzjjo1bSZDmeAE+i20ut4ugSeq7SenIcQ9DZOfghRt4xUUc5uh5PM
    SgAN181ZxF1oco7PoJ9ho3wb1kPOXsEzQT5UZv0CFFx1JIqpGEiANmmsdwoALURinC3es0
    +e8I9nc2247wfagtNBtbgyVV8BvBRc03DGsTzzDlNTrxNmxxQ9+IH7k1Xg1Flh6mzaY9bd
    AEOM693ILT2slEnUuoWD3iq+rjQAzyNUfHpc9WNRNUfsHLrNji0x8w3uLNBc6+3ow07+Dk
    SThl9X6VaY++QguKiFA37qMh2ASMDg/GN+HC+gkV+Enk9JIe/G8JD8fL7COLcBvKe9Pd4Y
    Y/pz1AXQuX3+LyaSHVKaG7PbY1QP84DdL2fbreWykz7+tMN/L34WkvzRSUoArdQLE3Izbw
    /NzdSmSLSeIeQ2A9wGqAKXuMlS0s5vywlwasYjNUKfk7zqhTktXnUqE3hD0nBt8EVGPDLe
    Xr7K221pN74VQYwYTrRRAfbbXvcTzF4fhG8Q7jry/h9aW3T2dWU6y2Gz2Fog
X-ME-Proxy: <xmx:t9AialqFobJD1-taIGqQ5rF803ibYvZq_Iq0GsJv22jARJixrT2a3w>
    <xmx:t9AiamYIcHsEru1uYBPmLtrirdTHb7yBIQmr_B77-_VdfLfwtSiTzA>
    <xmx:t9Aiamwux77QC8130QWbZx17oP84KxvLQ-tSATGr2lt8bv9TpqsiHQ>
    <xmx:t9Aias_A9XY1vi_DeAv_qtz5krRhwii5tWkVhnkjIn66ocpmIuiU6Q>
    <xmx:t9AiasWUe1TFw5eR3R8kiNLbOaSJ0Ot-SgFrWRCCVzvsI7TVCKz22o2X>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Jun 2026 09:35:50 -0400 (EDT)
From: Boqun Feng <boqun@kernel.org>
To: linux-kernel@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	rcu@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>,	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Ballance <andrewjballance@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,	Zqiang <qiang.zhang@linux.dev>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	maple-tree@lists.infradead.org,	linux-mm@kvack.org,
	linux-media@vger.kernel.org,	dri-devel@lists.freedesktop.org,
	Philipp Stanner <phasta@kernel.org>,	Lyude Paul <lyude@redhat.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>
Subject: [PATCH 1/3] rust: rcu: Add RcuBox type
Date: Fri,  5 Jun 2026 06:35:38 -0700
Message-ID: <20260605133541.22569-3-boqun@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260605133541.22569-1-boqun@kernel.org>
References: <20260605133541.22569-1-boqun@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 73han5ourmcbm44sk8bwdxstbrxgcazp
X-Rspamd-Queue-Id: E10C32000C
X-HE-Tag: 1780666553-843038
X-HE-Meta: U2FsdGVkX1+u4Hk0qoojBoTnhu5aNkjsA1rLKSNZ2SeLGCHyYtrSJh4NcY4xPIg7I2TYykHPF5FSmTNZJJcNmOm19cCsVqtpSm08QGaH1z64f7Y1RRBBn+p/36sd5roiCpuVpqtSn+63KWyjRTZ5Zi1gGJwg8M3YIhl7DFRY9m2bCjNPZpefdBeqMa5XpYifG1sOFGFg56SQEBfBVlkFVESIwjQHlKCNPypLym0Djk/iUTGhrMNM18S4TBUYhcgsAJJWc0a6QYxElBo9upzCNeaqGijBAIYJdtWMXdNhjWeN0kRxRkE4HsVLVUS1fOZT2rKCUMWKd/OsNXJ8937gvGd+diu0rGbV7LVP/neGnJe2l84VhkJf4900ROeME+331bVVSNy9GVo1IVe2f3Z1c6/rWGpvc5GAQd9w6s4nK7U2GeqiuiEmgZfexLCR+e0iXkngXa3NhHlJydNUZwqwRLORc7sR9SK5zWTvWUhMN/Cq+ULA7vvWs6JMABMeb1r1p5Td4DaG+LmH/h6Yy0EzpclBbuGM7ErzAeLYaFlsvWGKj3Wj12grccaxAK2EuKjk8YD41JYyB5chlNhF60xrXK/LjGvQjVmYzlYq1X8u/bqjMt2fFw5z/I3E6s0Rpvbtxzbr0x5awPpwsg160O5sipjldusHl1+fs9VLtZjNLsfvBb91fljF6OYR7SFpbnOWUWhblZbKv5BqcYl5NDDMooKW1oOjiNED6Mw4ZQGFiyHvlRsTDUcMXfrNK5jA1btxHF+5Lz2+X/x62Mn2U3nfLccV9RffYuZdSGBJ5PnJtsI6UWNK0Rcaa6mrRmXthtAyy5mWxcKdrx7wyrG1/SeV+dpMdrdw3HwIEDRb3Cv6MA2LY8zIvGBESXGcP6Jp3DRDiD09qQsx2z4ZpRvSEHcLynhkhAB5qVSMtQYQnMm5+Gz890W3kBWeIdhNo/wMieXnEiKPy32zWgMh8QE1/vp
 TtTcOmQx
 2NlbrwMBpNXQL3wKPy5uymmCtTAFnTaR+jDM5Ek3QQIFKb9W9CJ7My+BppqPUnIkMwOKF8YNO4z1SZGsE7MIw7mltZR0vSAfwWEeACIykYkNxAKCJg8h2mFCHxUOqNIUeWXsYTTfwrbQXsey5IiWofO3MM9oiwiwPWGP0FYjTfdcpGjITM+z2v/A5Zt8CfLzHQOQqofrIERmGwACcC2b9b/KLU4JuBUGjtOlG0iEtYRo7N312HdcdWVV7HZe47NEgOlWr8s9toDcIkHJ5ZVnUQUB83oFY14uvsj2w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alice Ryhl <aliceryhl@google.com>

This adds an RcuBox container, which is like Box except that the value
is freed after waiting for one grace period (via {kvfree_,}call_rcu()).

To allow containers to rely on the RCU properties of RcuBox, an
extension of ForeignOwnable is added.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
[boqun: Make RcuBox generic over Allocator and add tests]
[boqun: Add type alias for Rcu*Box]
Co-developed-by: Boqun Feng <boqun@kernel.org>
Signed-off-by: Boqun Feng <boqun@kernel.org>
---
 rust/bindings/bindings_helper.h |   1 +
 rust/kernel/sync/rcu.rs         |  34 ++++-
 rust/kernel/sync/rcu/rcu_box.rs | 230 ++++++++++++++++++++++++++++++++
 3 files changed, 264 insertions(+), 1 deletion(-)
 create mode 100644 rust/kernel/sync/rcu/rcu_box.rs

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 446dbeaf0866..2011645c7cfb 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -80,6 +80,7 @@
 #include <linux/property.h>
 #include <linux/pwm.h>
 #include <linux/random.h>
+#include <linux/rcupdate.h>
 #include <linux/refcount.h>
 #include <linux/regulator/consumer.h>
 #include <linux/sched.h>
diff --git a/rust/kernel/sync/rcu.rs b/rust/kernel/sync/rcu.rs
index a32bef6e490b..7da6b8d22277 100644
--- a/rust/kernel/sync/rcu.rs
+++ b/rust/kernel/sync/rcu.rs
@@ -4,7 +4,19 @@
 //!
 //! C header: [`include/linux/rcupdate.h`](srctree/include/linux/rcupdate.h)
 
-use crate::{bindings, types::NotThreadSafe};
+use crate::{
+    bindings,
+    types::{
+        ForeignOwnable,
+        NotThreadSafe, //
+    }, //
+};
+
+mod rcu_box;
+pub use self::rcu_box::RcuBox;
+pub use self::rcu_box::RcuKBox;
+pub use self::rcu_box::RcuKVBox;
+pub use self::rcu_box::RcuVBox;
 
 /// Evidence that the RCU read side lock is held on the current thread/CPU.
 ///
@@ -50,3 +62,23 @@ fn drop(&mut self) {
 pub fn read_lock() -> Guard {
     Guard::new()
 }
+
+/// Declares that a pointer type is rcu safe.
+pub trait ForeignOwnableRcu: ForeignOwnable {
+    /// Type used to immutably borrow an rcu-safe value that is currently foreign-owned.
+    type RcuBorrowed<'a>;
+
+    /// Borrows a foreign-owned object immutably for an rcu grace period.
+    ///
+    /// This method provides a way to access a foreign-owned rcu-safe value from Rust immutably.
+    ///
+    /// # Safety
+    ///
+    /// * The provided pointer must have been returned by a previous call to [`into_foreign`].
+    /// * If [`from_foreign`] is called, then `'a` must not end after the call to `from_foreign`
+    ///   plus one rcu grace period.
+    ///
+    /// [`into_foreign`]: ForeignOwnable::into_foreign
+    /// [`from_foreign`]: ForeignOwnable::from_foreign
+    unsafe fn rcu_borrow<'a>(ptr: *mut ffi::c_void) -> Self::RcuBorrowed<'a>;
+}
diff --git a/rust/kernel/sync/rcu/rcu_box.rs b/rust/kernel/sync/rcu/rcu_box.rs
new file mode 100644
index 000000000000..943fe3e8974e
--- /dev/null
+++ b/rust/kernel/sync/rcu/rcu_box.rs
@@ -0,0 +1,230 @@
+// SPDX-License-Identifier: GPL-2.0
+
+// Copyright (C) 2026 Google LLC.
+
+//! Provides the `RcuBox` type for Rust allocations that live for a grace period.
+
+use core::{
+    marker::PhantomData,
+    ops::Deref,
+    ptr::NonNull, //
+};
+
+use crate::{
+    alloc::{
+        self,
+        allocator::{
+            KVmalloc,
+            Kmalloc,
+            Vmalloc, //
+        },
+        AllocError,
+        Allocator, //
+    },
+    bindings,
+    ffi::c_void,
+    prelude::*,
+    types::ForeignOwnable,
+};
+
+use super::{
+    ForeignOwnableRcu,
+    Guard, //
+};
+
+/// A box that is freed with rcu.
+///
+/// The value must be `Send`, as rcu may drop it on another thread.
+///
+/// # Invariants
+///
+/// * The pointer is valid and references a pinned `RcuBoxInner<T>` allocated with `A`.
+/// * This `RcuBox` holds exclusive permissions to rcu free the allocation.
+pub struct RcuBox<T: Send, A: Allocator>(NonNull<RcuBoxInner<T>>, PhantomData<A>);
+
+/// Type alias for [`RcuBox`] with a [`Kmalloc`] allocator.
+///
+/// # Examples
+///
+/// ```
+/// # use kernel::sync::rcu::{self, RcuKBox};
+/// let rb = RcuKBox::new(42, GFP_KERNEL)?;
+///
+/// assert_eq!(*rb, 42);
+/// assert_eq!(*rb.with_rcu(&rcu::read_lock()), 42);
+/// # Ok::<(), Error>(())
+/// ```
+pub type RcuKBox<T> = RcuBox<T, Kmalloc>;
+
+/// Type alias for [`RcuBox`] with a [`Vmalloc`] allocator.
+///
+/// # Examples
+///
+/// ```
+/// # use kernel::sync::rcu::{self, RcuVBox};
+/// let rb = RcuVBox::new(42, GFP_KERNEL)?;
+///
+/// assert_eq!(*rb, 42);
+/// assert_eq!(*rb.with_rcu(&rcu::read_lock()), 42);
+/// # Ok::<(), Error>(())
+/// ```
+pub type RcuVBox<T> = RcuBox<T, Vmalloc>;
+
+/// Type alias for [`RcuBox`] with a [`KVmalloc`] allocator.
+///
+/// # Examples
+///
+/// ```
+/// # use kernel::sync::rcu::{self, RcuKVBox};
+/// let rb = RcuKVBox::new(42, GFP_KERNEL)?;
+///
+/// assert_eq!(*rb, 42);
+/// assert_eq!(*rb.with_rcu(&rcu::read_lock()), 42);
+/// # Ok::<(), Error>(())
+/// ```
+pub type RcuKVBox<T> = RcuBox<T, KVmalloc>;
+
+struct RcuBoxInner<T> {
+    rcu_head: bindings::callback_head,
+    value: T,
+}
+
+// Note that `T: Sync` is required since when moving an `RcuBox<T, A>`, the previous owner may
+// still access `&T` for one grace period.
+//
+// SAFETY: Ownership of the `RcuBox<T, A>` allows for `&T` and dropping the `T`, so `T: Send +
+// Sync` implies `RcuBox<T, A>: Send`.
+unsafe impl<T: Send + Sync, A: Allocator> Send for RcuBox<T, A> {}
+
+// SAFETY: `&RcuBox<T, A>` allows for no operations other than those permitted by `&T`, so `T:
+// Sync` implies `RcuBox<T, A>: Sync`.
+unsafe impl<T: Send + Sync, A: Allocator> Sync for RcuBox<T, A> {}
+
+impl<T: Send, A: Allocator> RcuBox<T, A> {
+    /// Create a new `RcuBox`.
+    pub fn new(x: T, flags: alloc::Flags) -> Result<Self, AllocError> {
+        let b = Box::<_, A>::new(
+            RcuBoxInner {
+                value: x,
+                rcu_head: Default::default(),
+            },
+            flags,
+        )?;
+
+        // INVARIANT:
+        // * The pointer contains a valid `RcuBoxInner` allocated with `A`.
+        // * We just allocated it, so we own free permissions.
+        Ok(RcuBox(NonNull::from(Box::leak(b)), PhantomData))
+    }
+
+    /// Access the value for a grace period.
+    pub fn with_rcu<'rcu>(&self, _read_guard: &'rcu Guard) -> &'rcu T {
+        // SAFETY: The `RcuBox` has not been dropped yet, so the value is valid for at least one
+        // grace period.
+        unsafe { &(*self.0.as_ptr()).value }
+    }
+}
+
+impl<T: Send, A: Allocator> Deref for RcuBox<T, A> {
+    type Target = T;
+    fn deref(&self) -> &T {
+        // SAFETY: While the `RcuBox<T>` exists, the value remains valid.
+        unsafe { &(*self.0.as_ptr()).value }
+    }
+}
+
+// SAFETY:
+// * The `RcuBoxInner<T>` was allocated with `A`.
+// * `NonNull::as_ptr` returns a non-null pointer.
+unsafe impl<T: Send + 'static, A: Allocator> ForeignOwnable for RcuBox<T, A> {
+    const FOREIGN_ALIGN: usize = <Box<RcuBoxInner<T>, A> as ForeignOwnable>::FOREIGN_ALIGN;
+
+    type Borrowed<'a> = &'a T;
+    type BorrowedMut<'a> = &'a T;
+
+    fn into_foreign(self) -> *mut c_void {
+        self.0.as_ptr().cast()
+    }
+
+    unsafe fn from_foreign(ptr: *mut c_void) -> Self {
+        // INVARIANT: Pointer returned by `into_foreign, A` carries same invariants as `RcuBox<T>`.
+        // SAFETY: `into_foreign` never returns a null pointer.
+        Self(unsafe { NonNull::new_unchecked(ptr.cast()) }, PhantomData)
+    }
+
+    unsafe fn borrow<'a>(ptr: *mut c_void) -> &'a T {
+        // SAFETY: Caller ensures that `'a` is short enough.
+        unsafe { &(*ptr.cast::<RcuBoxInner<T>>()).value }
+    }
+
+    unsafe fn borrow_mut<'a>(ptr: *mut c_void) -> &'a T {
+        // SAFETY: `borrow_mut` has strictly stronger preconditions than `borrow`.
+        unsafe { Self::borrow(ptr) }
+    }
+}
+
+impl<T: Send + 'static, A: Allocator> ForeignOwnableRcu for RcuBox<T, A> {
+    type RcuBorrowed<'a> = &'a T;
+
+    unsafe fn rcu_borrow<'a>(ptr: *mut c_void) -> &'a T {
+        // SAFETY: `RcuBox::drop` can only run after `from_foreign` is called, and the value is
+        // valid until `RcuBox::drop` plus one grace period.
+        unsafe { &(*ptr.cast::<RcuBoxInner<T>>()).value }
+    }
+}
+
+impl<T: Send, A: Allocator> Drop for RcuBox<T, A> {
+    fn drop(&mut self) {
+        // SAFETY: The `rcu_head` field is in-bounds of a valid allocation.
+        let rcu_head = unsafe { &raw mut (*self.0.as_ptr()).rcu_head };
+        if core::mem::needs_drop::<T>() {
+            // SAFETY: `rcu_head` is the `rcu_head` field of `RcuBoxInner<T>`. All users will be
+            // gone in an rcu grace period. This is the destructor, so we may pass ownership of the
+            // allocation.
+            unsafe { bindings::call_rcu(rcu_head, Some(drop_rcu_box::<T, A>)) };
+        } else {
+            // SAFETY: All users will be gone in an rcu grace period.
+            // TODO: We are luckily since `kvfree_call_rcu()` works on both kmalloc and vmalloc,
+            // maybe a new `Allocator` method is needed.
+            unsafe { bindings::kvfree_call_rcu(rcu_head, self.0.as_ptr().cast()) };
+        }
+    }
+}
+
+/// Free this `RcuBoxInner<T>`.
+///
+/// # Safety
+///
+/// `head` references the `rcu_head` field of an `RcuBoxInner<T>` that has no references to it.
+/// Ownership of the `Box<RcuBoxInner<T>, A>` must be passed.
+unsafe extern "C" fn drop_rcu_box<T, A: Allocator>(head: *mut bindings::callback_head) {
+    // SAFETY: Caller provides a pointer to the `rcu_head` field of a `RcuBoxInner<T>`.
+    let box_inner = unsafe { crate::container_of!(head, RcuBoxInner<T>, rcu_head) };
+
+    // SAFETY: Caller ensures exclusive access and passed ownership.
+    drop(unsafe { Box::<_, A>::from_raw(box_inner) });
+}
+
+#[kunit_tests(rust_rcu_box)]
+mod tests {
+    use super::*;
+
+    #[test]
+    fn rcu_box_basic() -> Result {
+        let rb = RcuBox::<_, alloc::allocator::Kmalloc>::new(42i32, alloc::flags::GFP_KERNEL)?;
+
+        assert_eq!(*rb, 42);
+        assert_eq!(*rb.with_rcu(&Guard::new()), 42);
+
+        drop(rb);
+
+        let rb = RcuBox::<_, alloc::allocator::Vmalloc>::new(42i32, alloc::flags::GFP_KERNEL)?;
+
+        assert_eq!(*rb, 42);
+        assert_eq!(*rb.with_rcu(&Guard::new()), 42);
+
+        drop(rb);
+
+        Ok(())
+    }
+}
-- 
2.51.0



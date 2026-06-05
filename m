Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AF4DCD6E74
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 10:54:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 436216B0005; Fri,  5 Jun 2026 06:54:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E7876B0088; Fri,  5 Jun 2026 06:54:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D6046B008A; Fri,  5 Jun 2026 06:54:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1AE966B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 06:54:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE4E6120A33
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 10:54:57 +0000 (UTC)
X-FDA: 84845551434.03.CF34C78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E3E8B20002
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 10:54:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YrB79w6Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780656896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/ySj8GIA4lhAt7ViwLme/WzVh84VfLjeXK3EUx/ivHg=;
	b=gpT7m9km0KZPEa0alrR8tQT2kZlmbN9WWW4ELpO656V8J/RUODZmC7FvUQqULyoKY1rX5b
	Axv2UfM5WMNEQU5WZ6DhuN9EZmCjqWeOLftUs7PYgvi4fUSlE7eOaEAOh9ANr6iubiAbmS
	/WTE1yKPlPjjfcT6ndm3kW6fqgf7W3U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YrB79w6Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780656896;
	b=ZU1b6k62n5zTEgQupwZyJ9xB2KYUUOBZ1MGH1UV37NgJEXtWTehIZWqL0qYl2vEQpF9t0L
	7GzaAHxYargHcYwGThSZD5U3qNFTseiFLRk2fmMmvEVlQ5CJbsKjaTk6LCo/K2t2uPAHc5
	rIJ0CftgQ9dRU2h7fJZWOcfWjIMG0Bk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0384542DF5;
	Fri,  5 Jun 2026 10:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BF91F00893;
	Fri,  5 Jun 2026 10:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780656894;
	bh=/ySj8GIA4lhAt7ViwLme/WzVh84VfLjeXK3EUx/ivHg=;
	h=From:Date:Subject:To:Cc;
	b=YrB79w6Y5UzCmU3PFi8CW3Ol1Zzqeu61lfDcEAMP6Y9ac1vYf/0PrmAejMF0443Yj
	 TZdXZ2YcMuwmR+6QKlNivFUI0BnDTOdVjnOTg5CkFLHy0OTM5zVXYZoE1fcXqialTB
	 vb7CmSQGqc6j8zJKcfbw/2mdK81hzmhH0gTJSPdCivSbVzMa+vvjlQIX305VIaIrYT
	 vOiCeXh94mA4ob63mTgwYUdeG/1dMManwPGnb4tOzhFKj1b/HOfs/swevV4cGhSUK5
	 IvOM55+r5qZcL+Uo1L24OeZbYUtZVoRkrlEqBNGyWTZROlHCOhSKUxXAEqHEaJa3jN
	 fVcasbrJTLKfA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 05 Jun 2026 12:54:41 +0200
Subject: [PATCH v2] rust: alloc: add per-task memalloc scope abstractions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260605-gfp-noio-v2-1-cfa2e236c2a3@kernel.org>
X-B4-Tracking: v=1; b=H4sIAPCqImoC/23MywrCMBCF4Vcps3YkiVFSV76HdNHLJB2UpEykK
 CXvbuza5X84fBtkEqYM12YDoZUzp1jDHBoY5z4GQp5qg1HmorRxGPyCMXFCP0xWkz6dlXNQ74u
 Q5/dO3bvaM+dXks8ur/q3/kFWjRrb3innR9sO1t4eJJGexyQBulLKFzai8EShAAAA
X-Change-ID: 20260128-gfp-noio-fbd41e135088
To: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Boqun Feng <boqun@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=12308;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=CUjYW/9FwZWAZgTnb2SrR9Ka7U+reP5ZumzvbhdTFm4=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqIqrxPTV5m7kRKo+B12Qag2hZXR/FLiM0EmKvP
 Az6xIGmVeWJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaiKq8QAKCRD6UCkIqsW9
 0F4SD/4uO6pxwTWgUs+FRQI2+VxQXgmlFaRyDnQJBLDEilIIOkkLe8YB9g+sND540snZwPK9U0K
 bGH5BgbSNRDLSCNaz3uGlSnMP+u3OMc4UNrB3WfL1ho7RiTQ4xGNQr90EJXwdIMSOXvZtXS+QoH
 f4dpiFq+w1vUlt0pDq/HQzIola6P5Kahn/J9CHej4w0Ks77DZ8yE/1zi9IxlStfu9KIBCYYrRRz
 aMjNerTEhxlBzavChfv9byiJFApRo3glL15opufAEsdiyfxyaS0FrYc75FBKTsIMHJDtuRFenR+
 Meu04crvSPcIg1foyfkxc8Id4imTSW561UZhZEKDYMt0mSwBAs+l2Sv/RFCqR10oSwIERvmCTv6
 1FdB/qZVaumZ+NyUXQFCcLtjTww4UkzGo9YfZeudBkkZa9NGwkBYg7uWzFBJeg3rtyHsAa5Ph9e
 cQdPfVjn1TwaiJbMenYPvvsWfRJZiXun5UTHHT+Ysdx3zMoOs2sa0m+jU1rBHOwQqZcUJsycH4i
 jSE4oY1vjpti2+NhxeeBa5S0kYMdRSYA61KnAsoKgpMyKbN1LV8oMM/bhBOJSo862mPPE8w0U4E
 Lx1j0UBmG79kaWXq1aisgmIqXmedszEFfLdrjSv1DqR7g/IkzduJJxn89KQLZyOV19WIqYQUFDZ
 CZH6kOerFXqcHVQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: ue3gx53ntr5ggpfyha61xnnoab147fe5
X-Rspamd-Queue-Id: E3E8B20002
X-HE-Tag: 1780656895-956962
X-HE-Meta: U2FsdGVkX19YX+hCb2ZX4iAyNn8udIGczLgcpheFXkgOFgguA+vShYwqiP2EOXrF+8tQfGDm2FBI4h6e+ipq9qXBS3jj+uUgK0rBHyR9uz81U258iiJWkopoUBXCirLQzrjLTbNYeoUgBbVYcGD6ftrB2hj2TYWFFoK01A3RwCqegBBdA20n1WqU7b1T5SXQ2dI206PVol7NxRhx8Lk/ZSMtDradfXVVHu270FTb+/otT4OqMSfDM3jGpJ2WHIRuTC7h2Jz+mU28ATXdgwvxdE5RJpW0PAw/ggP0PJmwPiMU7xpt+lgH07Dg+YJ3zmMgLzXd++vujHI+fxJl/Gg7f4LlYupw3GrCe0l2XdRzP6FO3mICMH8lr2nrBqoNic6f7RoCOf22gUCuaLTLJWztLlkMpauNtHisUXPJdT3wKw2zCKoKwSGMSFbnMcUyYcbgM6XK+X4FkcWeWAY+9JWbqMM+1k/qs3HBeGa+H09J+n/YUA/q1wU5atugtJhFU9TxDLwN1xhkWs45dXlMh2kafNoX9BuCQSSwd/VXSjFJCaDlX2ZSJdKU9zjzUakQDubW36+kgVsYHf3v1xjnzP6jx516qFnSK5P7QHOhCW2XKr7myKvs8cgTo/Yfoh/HNjIInJOk2IK2uk4UaQzK3hYsw1voJdQL3N0I/bl73gNbUe4JcUy26x7ltppOURlof3DkU/7vyAw+3YsoChLb8lXW2lINM0ZshAFML9nBLPyZ9r+ot2Uhi6uw+BjopEkQYjsPiB0cVTws++/AnrUX7Jh2T4kSVGO46IzwQBOW9ob+TrejE/v4AzBAdMyByz4+I+OXUCm5Ng+cQOXV01GRG4RWV+PV3Efk6yao0SW8oOm/I11+loBhP58Fjjlilie4oZB8tuEehH8SBnEha1w5av/NQfRgx59UYm6H89PVo8rDgCHgZxpX6a779RU+DxFjYb0ToDURKLcbCJOX4UIlmLP
 w72uRQt0
 Dn/hwQUep5D1fgvJducBMGFo9wqTbR+aAMpanWfET+p2xlSKEWS+0Jb4rzPZKobjAuJLkiehBe56khnpufOpFlZ1mMoEBTN+/nMiaozNs/4De8rC5Xxtx9Jamo+fTZlDQnSJJFtDn77yA8LHM1Dp1E4s9qAq3eB+tVMfSZ1gy5URLsgDB39VnTIuXcC4MvPbrrSU1v94DGZQtohZHwb2VKzCvLDg49nua/1shi/mQbl5SL0xQ//l2OfHzzrxDmbTUrJ/5NQpW8qQ/AbtVja6cbofb0u5dKK/PUBNw5rluuP7lVcHnSKZUPhsu+95wIZ0LrxMY6ckMxl32g6pUAEAsDSsu0LlcfC/jks4m7py9gxuS5mlrOsOIZRMTN4ToW8kUmBcZptAZoKO2sN7s29lEPxwembdiVvFzvU9f+LCyflL3wj2rwdyGOhBN0l5u4U4v3Ubr8ryOXds9WNhGKlux8O2YGJWNsCkKaGyip0e9VDAtw4iWBzRFslIgHS8wlvOgwyvHJaLMBbFIasWo9eFBVLlOda4PQxr3WQ0DHUQdUl8swPhVHpZp+ZbVVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an abstraction for the per-task allocation policies exposed by
the kernel through paired save/restore helpers in `linux/sched/mm.h`:
`memalloc_noio`, `memalloc_nofs`, `memalloc_noreclaim` and
`memalloc_pin`. Each pair toggles a bit in `current->flags` and
returns the prior state for a later restore. The pairing assumes
strict LIFO nesting; restoring out of order corrupts the per-task
state.

Wrap the four pairs as a generic `Scope<K>` guard with a sealed
`ScopeKind` trait. Tag types `NoIo`, `NoFs`, `NoReclaim` and
`MemallocPin` select the underlying save/restore pair. `Scope` is
`!Unpin`, `!Send` and `!Sync`, and is only constructed through the
`memalloc_scope!` macro, which binds it via `core::pin::pin!` to a
hidden stack slot and hands out a `Pin<&Scope<K>>`. Safe code
therefore cannot move the guard across tasks, drop it ahead of its
lexical scope or otherwise violate the LIFO save/restore discipline.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
Changes in v2:
- Rewrite the patch to use scoped allocation flags instead of exposing
  a `GFP_NOIO` flag constant.
- Link to v1: https://lore.kernel.org/r/20260128-gfp-noio-v1-1-9a808fc49b44@kernel.org

To: Miguel Ojeda <ojeda@kernel.org>
To: Boqun Feng <boqun@kernel.org>
To: Gary Guo <gary@garyguo.net>
To: Björn Roy Baron <bjorn3_gh@protonmail.com>
To: Benno Lossin <lossin@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
To: Trevor Gross <tmgross@umich.edu>
To: Danilo Krummrich <dakr@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: rust-for-linux@vger.kernel.org
Cc: linux-mm@kvack.org
---
 rust/bindings/bindings_helper.h |   1 +
 rust/helpers/mm.c               |  40 +++++++
 rust/kernel/alloc.rs            |   1 +
 rust/kernel/alloc/scoped.rs     | 231 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 273 insertions(+)

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 446dbeaf0866..1931b131345f 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -83,6 +83,7 @@
 #include <linux/refcount.h>
 #include <linux/regulator/consumer.h>
 #include <linux/sched.h>
+#include <linux/sched/mm.h>
 #include <linux/security.h>
 #include <linux/slab.h>
 #include <linux/sys_soc.h>
diff --git a/rust/helpers/mm.c b/rust/helpers/mm.c
index b5540997bd20..b8e7492512e8 100644
--- a/rust/helpers/mm.c
+++ b/rust/helpers/mm.c
@@ -48,3 +48,43 @@ __rust_helper void rust_helper_vma_end_read(struct vm_area_struct *vma)
 {
 	vma_end_read(vma);
 }
+
+unsigned int rust_helper_memalloc_noio_save(void)
+{
+	return memalloc_noio_save();
+}
+
+void rust_helper_memalloc_noio_restore(unsigned int flags)
+{
+	memalloc_noio_restore(flags);
+}
+
+unsigned int rust_helper_memalloc_nofs_save(void)
+{
+	return memalloc_nofs_save();
+}
+
+void rust_helper_memalloc_nofs_restore(unsigned int flags)
+{
+	memalloc_nofs_restore(flags);
+}
+
+unsigned int rust_helper_memalloc_noreclaim_save(void)
+{
+	return memalloc_noreclaim_save();
+}
+
+void rust_helper_memalloc_noreclaim_restore(unsigned int flags)
+{
+	memalloc_noreclaim_restore(flags);
+}
+
+unsigned int rust_helper_memalloc_pin_save(void)
+{
+	return memalloc_pin_save();
+}
+
+void rust_helper_memalloc_pin_restore(unsigned int flags)
+{
+	memalloc_pin_restore(flags);
+}
diff --git a/rust/kernel/alloc.rs b/rust/kernel/alloc.rs
index e38720349dcf..8ebb8c9f3e67 100644
--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -6,6 +6,7 @@
 pub mod kbox;
 pub mod kvec;
 pub mod layout;
+pub mod scoped;
 
 pub use self::kbox::Box;
 pub use self::kbox::KBox;
diff --git a/rust/kernel/alloc/scoped.rs b/rust/kernel/alloc/scoped.rs
new file mode 100644
index 000000000000..0251792c9f3c
--- /dev/null
+++ b/rust/kernel/alloc/scoped.rs
@@ -0,0 +1,231 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Scoped allocation policies for the current task.
+//!
+//! The kernel exposes several per-task allocation policies through
+//! save/restore pairs in [`include/linux/sched/mm.h`]: `memalloc_noio`,
+//! `memalloc_nofs`, `memalloc_noreclaim` and `memalloc_pin`. Each pair
+//! sets a bit in `current->flags` and returns the prior state, which a
+//! later call restores. The save/restore APIs assume strict LIFO
+//! nesting; restoring out of order corrupts the per-task state.
+//!
+//! This module exposes the policies as a generic [`Scope<K>`] guard,
+//! parameterized over a [`ScopeKind`] tag. The type is `!Unpin` and
+//! constructed only through the [`memalloc_scope!`] macro, which binds
+//! it to a hidden stack slot via [`core::pin::pin!`] and rebinds the
+//! handle as a shared pinned reference. Safe code therefore has no path
+//! to either move the guard or drop it ahead of its lexical scope, so
+//! nested scopes always restore in LIFO order.
+//!
+//! [`include/linux/sched/mm.h`]: srctree/include/linux/sched/mm.h
+//!
+//! # Examples
+//!
+//! ```ignore
+//! use kernel::memalloc_scope;
+//! use kernel::alloc::scoped::NoIo;
+//!
+//! fn process_io_request() {
+//!     memalloc_scope!(let _noio: NoIo);
+//!     // Every allocation in this scope behaves as if `GFP_NOIO` were
+//!     // set, even when the call site passes `GFP_KERNEL`.
+//! }
+//! ```
+
+use core::{
+    ffi::c_uint,
+    marker::{
+        PhantomData,
+        PhantomPinned, //
+    },
+};
+
+use crate::types::NotThreadSafe;
+
+pub use crate::memalloc_scope;
+
+mod private {
+    pub trait Sealed {}
+}
+
+/// Selects which `memalloc_*` save/restore pair a [`Scope`] wraps.
+///
+/// Implemented only by the zero-sized tag types in this module
+/// ([`NoIo`], [`NoFs`], [`NoReclaim`], [`MemallocPin`]). The trait is
+/// sealed.
+pub trait ScopeKind: private::Sealed {
+    /// Begin a scope on the current task and return the prior state.
+    #[doc(hidden)]
+    fn save() -> c_uint;
+
+    /// End a scope on the current task.
+    ///
+    /// # Safety
+    ///
+    /// `prev` must be the value returned by the matching [`save`] call,
+    /// and the call must execute on the same task that ran [`save`].
+    ///
+    /// [`save`]: ScopeKind::save
+    #[doc(hidden)]
+    unsafe fn restore(prev: c_uint);
+}
+
+/// A scope that imposes an allocation policy on the current task while
+/// it is live.
+///
+/// Construct one with [`memalloc_scope!`]. `Scope` is `!Unpin` and its
+/// constructor is hidden, so a `Scope` only ever exists pinned to a
+/// stack slot owned by the construction macro; safe code cannot drop
+/// it out of order or send it across tasks. The C-side state is
+/// restored in [`Drop`], which runs when the stack slot goes out of
+/// scope.
+pub struct Scope<K: ScopeKind> {
+    prev: c_uint,
+    _kind: PhantomData<K>,
+    _pin: PhantomPinned,
+    _not_thread_safe: NotThreadSafe,
+}
+
+impl<K: ScopeKind> Scope<K> {
+    /// Begin a scope of kind `K` on the current task.
+    ///
+    /// # Safety
+    ///
+    /// The returned value must be pinned to the stack frame that calls
+    /// this function and dropped on the same task. In practice, only
+    /// [`memalloc_scope!`] should call this — the macro arranges both.
+    #[doc(hidden)]
+    pub unsafe fn new() -> Self {
+        Self {
+            prev: K::save(),
+            _kind: PhantomData,
+            _pin: PhantomPinned,
+            _not_thread_safe: NotThreadSafe,
+        }
+    }
+}
+
+impl<K: ScopeKind> Drop for Scope<K> {
+    fn drop(&mut self) {
+        // SAFETY: `self.prev` was produced by `K::save` in `Self::new`.
+        // The caller of `new` upheld the contract that the value
+        // remains pinned to its construction stack frame, so this drop
+        // runs on the same task as the matching save.
+        unsafe { K::restore(self.prev) };
+    }
+}
+
+macro_rules! define_kind {
+    (
+        $(#[$meta:meta])*
+        $name:ident, $save:ident, $restore:ident $(,)?
+    ) => {
+        $(#[$meta])*
+        pub struct $name;
+
+        impl private::Sealed for $name {}
+
+        impl ScopeKind for $name {
+            fn save() -> c_uint {
+                // SAFETY: Updates a per-task flag and is documented as
+                // safe from any context.
+                unsafe { bindings::$save() }
+            }
+
+            unsafe fn restore(prev: c_uint) {
+                // SAFETY: Per the trait contract, `prev` is the value
+                // returned by the matching `save`, on the same task.
+                unsafe { bindings::$restore(prev) };
+            }
+        }
+    };
+}
+
+define_kind!(
+    /// `GFP_NOIO` scope.
+    ///
+    /// While a `Scope<NoIo>` is live, allocations on the current task
+    /// behave as if `GFP_NOIO` were set, making them safe to issue from
+    /// the IO completion path.
+    ///
+    /// Corresponds to `memalloc_noio_save` / `memalloc_noio_restore` in
+    /// `include/linux/sched/mm.h`.
+    NoIo,
+    memalloc_noio_save,
+    memalloc_noio_restore,
+);
+
+define_kind!(
+    /// `GFP_NOFS` scope.
+    ///
+    /// While a `Scope<NoFs>` is live, allocations on the current task
+    /// behave as if `GFP_NOFS` were set, making them safe to issue from
+    /// a filesystem critical section.
+    ///
+    /// Corresponds to `memalloc_nofs_save` / `memalloc_nofs_restore` in
+    /// `include/linux/sched/mm.h`.
+    NoFs,
+    memalloc_nofs_save,
+    memalloc_nofs_restore,
+);
+
+define_kind!(
+    /// No-reclaim scope.
+    ///
+    /// While a `Scope<NoReclaim>` is live, allocations on the current
+    /// task may dip into the memory reserves. Callers must be sure their
+    /// allocations will help free more memory shortly; see the kernel C
+    /// documentation for the full contract.
+    ///
+    /// Corresponds to `memalloc_noreclaim_save` /
+    /// `memalloc_noreclaim_restore` in `include/linux/sched/mm.h`.
+    NoReclaim,
+    memalloc_noreclaim_save,
+    memalloc_noreclaim_restore,
+);
+
+define_kind!(
+    /// Long-term pin scope.
+    ///
+    /// While a `Scope<MemallocPin>` is live, allocations on the current
+    /// task are restricted to zones that allow long-term pinning.
+    ///
+    /// Corresponds to `memalloc_pin_save` / `memalloc_pin_restore` in
+    /// `include/linux/sched/mm.h`.
+    MemallocPin,
+    memalloc_pin_save,
+    memalloc_pin_restore,
+);
+
+/// Bind a [`Scope`] of the given kind to the current stack frame.
+///
+/// `$kind` must name one of the zero-sized tag types defined in this
+/// module: [`NoIo`], [`NoFs`], [`NoReclaim`], [`MemallocPin`]. The
+/// macro shadows `$name` first with the owning pinned slot and then
+/// with a shared pinned reference, so the value lives until the end of
+/// the enclosing block and cannot be dropped early by safe code.
+///
+/// # Examples
+///
+/// ```ignore
+/// use kernel::memalloc_scope;
+/// use kernel::alloc::scoped::NoIo;
+///
+/// memalloc_scope!(let _scope: NoIo);
+/// // ... allocations here behave as if `GFP_NOIO` were set.
+/// ```
+#[macro_export]
+macro_rules! memalloc_scope {
+    (let $name:ident : $kind:ident) => {
+        // SAFETY: `pin!` places the value in a hidden stack slot and
+        // returns a `Pin<&mut _>`; combined with `Scope: !Unpin`, safe
+        // code can neither extract ownership nor reorder its drop
+        // relative to nested scopes, so the save/restore discipline of
+        // the underlying C API is preserved.
+        let $name = ::core::pin::pin!(unsafe {
+            $crate::alloc::scoped::Scope::<$crate::alloc::scoped::$kind>::new()
+        });
+        let $name: ::core::pin::Pin<&$crate::alloc::scoped::Scope<$crate::alloc::scoped::$kind>> =
+            $name.as_ref();
+    };
+}

---
base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
change-id: 20260128-gfp-noio-fbd41e135088

Best regards,
--  
Andreas Hindborg <a.hindborg@kernel.org>




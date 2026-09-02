Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BDFDC624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:27:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 106916B00B7; Wed,  2 Sep 2026 09:27:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DF166B00B9; Wed,  2 Sep 2026 09:27:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0FBB6B00BC; Wed,  2 Sep 2026 09:27:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C41EA6B00B7
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:27:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1E5A01A0209
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:27:28 +0000 (UTC)
X-FDA: 85168898976.08.6C41F8B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 60DC7180006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:27:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oveZxi0S;
	spf=pass (imf24.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788355646;
	b=Gp9Luw23ORAIzeVFo2HulrdDdGUcWdc4MYFuZWtfxfdRDn0WFZPzqnCDbuo0WQq5jsk21n
	/tycmjMarH+mo/RJoRKbZ/zQKbaedvup7xCbLxRoBHD0NW5wDooYfoSPOczoaczXGilcwm
	6zi1t8pnryfbSTdxnt1aOFYMWq+Q2WI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788355646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EKD5ZTJn8sxqNRm37VbuPZ2kXqgx5R9J/beNmFemwCE=;
	b=kj97EesrVBbX0SkHbpg2nSmzQWLquCeDdY6AVL8CnN+cbttGbrNXTO45GMRB/P2Td8LEqx
	4oD5x8uzSdW9oeMxFottQYBp9B1kMCVHbTbGfdkmrHpYPjC64wMzflrFlENPKx6xa2s7On
	dV/Ngxp36aGjKpST5tP120Kfbw5hkI0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oveZxi0S;
	spf=pass (imf24.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 065E8600D1;
	Wed,  2 Sep 2026 13:27:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8161F000E9;
	Wed,  2 Sep 2026 13:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788355645;
	bh=EKD5ZTJn8sxqNRm37VbuPZ2kXqgx5R9J/beNmFemwCE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oveZxi0SOjjDyrwpWs84Nhn2Td1BAXYmQoz6FklO2UR0iJhQkks2zxuIIIoTx4dIW
	 mB/ynoQf1I7b/Q2Wm2ePI54e6IyVbPSgWQUC6aF6kARqWi4pEE0UvRFm0uR8tXp9Wm
	 Sslv5qHcO8HuYb/kkv6mFFgXms05h9NkymV+JyQVbTYTun/X2fLK30qY6fR5WvW2IQ
	 knOH+a2Sb9goYrT+Oqhf3Z9bHTdW/dGZqj3XCcpQCoC0dLAuA6W4ki2wCWcM3FGCkj
	 i9wodQ/KX2cdPKFSrLHxHa2sXxuXiPCOOWNy8VvsAIllEvK2NQ943gSQt16XBlfX9Y
	 DeBW6EVp71PkA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 02 Sep 2026 15:26:00 +0200
Subject: [PATCH v5 04/12] rust: xarray: add `XArrayState`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-xarray-entry-send-v5-4-d18adae40708@kernel.org>
References: <20260902-xarray-entry-send-v5-0-d18adae40708@kernel.org>
In-Reply-To: <20260902-xarray-entry-send-v5-0-d18adae40708@kernel.org>
To: Tamir Duberstein <tamird@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Matthew Wilcox <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, 
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6538; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=uIAZTAMI6EKyFLH4zWLpCBUlLxJgzsKNrPDLyyXwmL8=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqmCQccl8sgPMa9QSqMPBIn7AuzBniR3mDYRUEL
 AaTUAdQd5aJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCapgkHAAKCRD6UCkIqsW9
 0NkhD/41qhOo1fHzwGL3+jOmJ7ywFgDg5h7zJNwQTLsTStKSuLg31/UpCMzC3l1pdRmfZnux7dZ
 N2uO5YzXyP4c2TzDESlyUAV25BuVM704cLmS0zdnBrTF/PEuom4ROealCRoakjn85163ngBqyDF
 yytVrxSmjG3ScF13r7UVPaVgI7xxMb5uT/7mKgEyYNTY5h1oaZHcPCwP5YeKK6C9txcxkDM6fXr
 wp6SxyQwlZ7w5ijdgJS2PJPHoH/xl85DA1+rEBPVTVwPuArk7uEWPBlV+BOX1nEmloMVA1YV8Of
 wHCcRfD0xMZJVGUtqKRZF7ZCKMJ20fFnXiuAugYmANVfIsXthDyAxHBYBkNH0btI/lmGBr8vXfL
 xNeYKA2od8U22fxjGS740BeoadmsDL2XcIryu4fW18xHvuY8KCH9q+BN7niyoDA9mphkMajKgZt
 BFn82CkJl1WtmTC+km86lK42BeOReHf+Q+m/CAglszQZ3uKbJzLknZ1tMr5JvXPPtduhjRYwR8V
 s/0S8gSir18/YPTHSOnXEBb269y0mVyZH2JzqXirkQe0LZ31p6VWvGz36MDqas4pOcQ8NYQcGK7
 nLlHdBNaZg+7RdfcLLRjQ84Z0QUrwTZ33jm/qHVVQIjJdlo+QOMlB1iIcn5wuO+yWi/Tn8rWilF
 d21t2nfy5D0eZ9w==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 60DC7180006
X-Stat-Signature: f647g9cwaptbcazug7tw1ioxxqociogx
X-HE-Tag: 1788355646-750577
X-HE-Meta: U2FsdGVkX199G+Jdl7wdZ2arnz+KbnXRH316bBmT1vQr/CI6t6feN/jk1HFdN+by5bINAesoe9KiKf17yLhAI28ZwQcBf7l7oY2FwCX9tqqNaGNShNLRREOkZK0rtYliobWCKgDXdbsR1XAwhWL1F4VcOZQ92veabwnEliDbhZCpB1rDuSH6Wqz4Rw0p+lnotHCwJT9mq3BEH5cRwu12du/aAAKfi0Ml7G6v/XB8AIIfES/iiW5v/9bSf+zJrDNkMtMEUQBXNTcZaXKTQJuwNUsILsxhVphwRXyZhoFH0rExBBvVLUB6ML8SCk/Cl1VyfPASvtKWUjR1mzvXVqC4eVtdelmmMlYEkCxsB3IT14za0rUaYmvOFkwciJUtTN1xksU4bykI7P5/WqkaTEVeEPJ1dMzIU99jkOZMnIsgcCMa2zmdvL2GXf7jPl5v5O+iRdnEjEsd8HoGHq6iDXw4X2kqJr7XVgaWto4HWjBjbc9Tl4k0PqotyTjLS/tsjiEGTbtaIV29HSt0xzx4RWdKIyRU4mkHTUUs+f9xASCwsYiFinBlPWlrlXc4oO5wlRK/Hd/u/FmuCi8rWErSQjHePklHcbcr7FnBN/RD7FoffzXKq7PCI+9K1GwQmKpjcSCjkm8S/0ymud2j8lTKolQKwt7OB2TAhymNOSWw3o2N0pAIkUR+b95OeDwYzV5nDhBA6HFll3AdnVKPHvCdxA+WppqF3lHzut+P2QjtlvVJ2A22uNUt0OfTiaqeWLPwDvXxPYn0uxBi4mucfORaoO0LJ7q1nU+D+Up6U5XJscxBonjZIN5m6CEp2LEglTfcLZNovxI1G4VhGjCNp1nxaQDl3aJ3owimmqRSqFpgQM+SnYsK/EUI2fKSbwNXCuwyTSuC0Ylh89PN9jWXte6RoaybQ4uR/huc/I8Lre1Mpx7r8V7ROpM4w60gPaCurjWkQbiC9L9e9puM3yHKsotsJX3
 sNDVTq7H
 Eipp5GC2SNruVgilIbvvP0k6AlxORGtkMjMsaq+01q9CCoeGrEqsWYRdhNpZElGvlHaUmzAzTGshS4hNK0L4UpBOO63wt1f8Uwhr4cHZig2b28IaoKKGDXCPXJD+2kveRsbD0tgJRYBjIKBqzbV/jWIWci3AAdX6u47h+EIvfoSeZo+jndcvIlQw3uNTLq6PQJ98jScZVHe1G/bhkBwHCi2+4T8M9z6tkA8oRsHtmMZoERzEgN/cIESgaLxDDhNkmwkPVOgYv2BcpjW4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add `XArrayState` as internal state for XArray iteration and entry
operations. This struct wraps the C `xa_state` structure and holds a
reference to a `Guard` to ensure exclusive access to the XArray for the
lifetime of the state object. `XArrayState` is generic over the guard
borrow through a `Deref` bound, so it can hold either a shared or a
mutable reference to the guard.

Use the new state in `Guard::load` by replacing the call to `xa_load`
with `xas_load`. The `xa_load` function takes the RCU lock internally,
which we do not need, since the `Guard` already holds an exclusive lock
on the `XArray`. The `xas_load` function operates on `xa_state` and
assumes the required locks are already held.

Unlike `xa_load`, `xas_load` does not filter out internal entries.
Arrays created with `AllocKind::Alloc1` store `XA_ZERO_ENTRY` at index
0 when they are expanded from empty, so convert zero entries to `NULL`
like the C normal API does, exposing the `xa_zero_to_null` helper for
this purpose.

The `XAS_RESTART` constant is also exposed through the bindings helper
to properly initialize the `xa_node` field.

The `guard` field of `XArrayState` is not read until a later patch
adds `into_guard`, so it is annotated with `#[expect(dead_code)]`
until then.

Assisted-by: LLM
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/bindings/bindings_helper.h |  7 ++++
 rust/helpers/xarray.c           |  5 +++
 rust/kernel/xarray.rs           | 74 ++++++++++++++++++++++++++++++++++++++---
 3 files changed, 81 insertions(+), 5 deletions(-)

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 1124785e210b3..419e6b74fedc3 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -124,6 +124,13 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT = XA_PRESENT;
 
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC = XA_FLAGS_ALLOC;
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 = XA_FLAGS_ALLOC1;
+/*
+ * `XAS_RESTART` is `((struct xa_node *)3UL)` -- a sentinel pointer value, not
+ * an address. Cast to `size_t` so bindgen emits a plain `usize` constant; for
+ * pointer-typed macro values bindgen otherwise generates a `pub static mut`,
+ * see https://github.com/rust-lang/rust-bindgen/issues/3347.
+ */
+const size_t RUST_CONST_HELPER_XAS_RESTART = (size_t)XAS_RESTART;
 
 const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE = VM_MERGEABLE;
 const vm_flags_t RUST_CONST_HELPER_VM_READ = VM_READ;
diff --git a/rust/helpers/xarray.c b/rust/helpers/xarray.c
index 08979b3043410..79799c55c3d73 100644
--- a/rust/helpers/xarray.c
+++ b/rust/helpers/xarray.c
@@ -26,3 +26,8 @@ __rust_helper void rust_helper_xa_unlock(struct xarray *xa)
 {
 	return xa_unlock(xa);
 }
+
+__rust_helper void *rust_helper_xa_zero_to_null(void *entry)
+{
+	return xa_zero_to_null(entry);
+}
diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index 4335caab8ccae..e8082df2b4797 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -8,7 +8,10 @@
     iter,
     marker::PhantomData,
     pin::Pin,
-    ptr::NonNull, //
+    ptr::{
+        null_mut,
+        NonNull, //
+    },
 };
 use kernel::{
     alloc,
@@ -214,10 +217,8 @@ fn load<F, U>(&self, index: usize, f: F) -> Option<U>
     where
         F: FnOnce(NonNull<c_void>) -> U,
     {
-        // SAFETY: `self.xa.xa` is always valid by the type invariant.
-        let ptr = unsafe { bindings::xa_load(self.xa.xa.get(), index) };
-        let ptr = NonNull::new(ptr.cast())?;
-        Some(f(ptr))
+        let mut state = XArrayState::new(self, index);
+        Some(f(state.load()?))
     }
 
     /// Provides a reference to the element at the given index.
@@ -300,6 +301,69 @@ pub fn store(
     }
 }
 
+/// Internal state for XArray iteration and entry operations.
+///
+/// `R` is the borrow held on the guard: either `&Guard` for read-only callers
+/// or `&mut Guard` for entry-style APIs that need to surrender the borrow back
+/// via [`XArrayState::into_guard`].
+///
+/// # Invariants
+///
+/// - `state` is always a valid `bindings::xa_state`.
+/// - `state.xa` aliases the xarray reachable through `guard`.
+pub(crate) struct XArrayState<R> {
+    // The borrow is held to guarantee exclusive access to the array. It is
+    // not read until a later patch adds `into_guard`, so silence the dead
+    // code warning until then.
+    #[expect(dead_code)]
+    guard: R,
+    state: bindings::xa_state,
+}
+
+impl<'a, R, T> XArrayState<R>
+where
+    T: ForeignOwnable + 'a,
+    R: core::ops::Deref<Target = Guard<'a, T>>,
+{
+    #[inline]
+    fn new(guard: R, index: usize) -> Self {
+        let xa_ptr = guard.xa.xa.get();
+        // INVARIANT: `state` is initialized to a valid `xa_state` whose `xa` field aliases the
+        // xarray reachable through `guard`.
+        Self {
+            guard,
+            state: bindings::xa_state {
+                xa: xa_ptr,
+                xa_index: index,
+                xa_shift: 0,
+                xa_sibs: 0,
+                xa_offset: 0,
+                xa_pad: 0,
+                xa_node: bindings::XAS_RESTART as *mut bindings::xa_node,
+                xa_alloc: null_mut(),
+                xa_update: None,
+                xa_lru: null_mut(),
+            },
+        }
+    }
+
+    fn load(&mut self) -> Option<NonNull<c_void>> {
+        // SAFETY: `self.state` is a valid `xa_state` by the type invariant. By the same
+        // invariant, `self.state.xa` aliases the xarray reachable through `self.guard`, whose
+        // lock we hold.
+        let ptr = unsafe { bindings::xas_load(&raw mut self.state) };
+
+        // Unlike the normal API, `xas_load` does not filter out internal entries. Arrays
+        // created with [`AllocKind::Alloc1`] store `XA_ZERO_ENTRY` at index 0 when they are
+        // expanded from empty, so convert zero entries to `NULL` like `xa_load` does. Retry
+        // entries cannot be observed here because they require concurrent modification of the
+        // array, and we hold the lock.
+        //
+        // SAFETY: `xa_zero_to_null` only inspects the value of `ptr`.
+        NonNull::new(unsafe { bindings::xa_zero_to_null(ptr) }.cast())
+    }
+}
+
 // SAFETY: `XArray<T>` has no shared mutable state so it is `Send` iff `T` is `Send`.
 unsafe impl<T: ForeignOwnable + Send> Send for XArray<T> {}
 

-- 
2.51.2




Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81F4C606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 19:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nb2PMwHa
Received: by kanga.kvack.org (Postfix)
	id 34EB46B0AA3; Wed, 25 Nov 2026 14:10:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FEC46B0AA5; Wed, 25 Nov 2026 14:10:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EDB06B0AA6; Wed, 25 Nov 2026 14:10:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C19736B0AA3
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:10:44 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E9F2EA8FE2
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:10:43 +0000 (UTC)
X-FDA: 85474583166.10.30BAF36
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 20AB140009
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:10:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nb2PMwHa;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795633842;
	b=gQEc1+t6CSffuX4PbIgSIpFFGDfv0o4I+EE19UrfZXU0FEA9Q1S/gbeD6maifv/vAd1JL0
	rdY6GF0WcAgSrwILkZJ84r6jY8COV0Qc3bXoJicDhJ66yti8/NFZPJQ78ga8VljGY1R3ly
	44EWiWFBD+uDPtsBGduCc6+wf7RWmMQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795633842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gdJT2ccAmvh0rOqxKnPGiTdo4RGbeB5XvNplqFwpnbA=;
	b=AnYCmzgSLQnNpOLxD7UeIjmwwyUo6lyDEW5aP76anjhuJEtTPO1B/awqyXntegwuMMy+AG
	j9cZ3RYMWjJJxl9S7lbPf9cCfKz7L99jxNJ/mghI1k/VaPDO1wmoGn5/0oOvzBiDsKsr8X
	xJpgH3hzk7QCNTO5dLxBDJKmQl5cbhw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nb2PMwHa;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F077B622DF;
	Wed, 25 Nov 2026 19:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5AE1F000C0;
	Wed, 25 Nov 2026 19:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795633840;
	bh=gdJT2ccAmvh0rOqxKnPGiTdo4RGbeB5XvNplqFwpnbA=;
	h=From:Date:Subject:To:Cc;
	b=nb2PMwHaKL2ly+Ltwwy1U5Gzjyv+RAE8sNl/e6s6Mt8D1RST8Ps8U1Fl6HI70fFwV
	 kPGhOwFmIL1kSaEM5K0/mCTn1jgP5hoQNvkV8jxTEB35wr9kW6kLSWEppBTi9Ai/H/
	 oPAy71k3Qh3W1y5A1N2DuDqbdKV1TrQuD0HSgsiMsoTo7zZ8Lx/lDX6a9Vztbg6BQA
	 arbmN8lcHFZNAdOyNQvdj9QyEeqVNMXVhYAPEhZaVrW9yMZq/J8IKjuBcFatUYUeN5
	 XvTHWU/kI5hTcHEok0MLosHMWcxZtlbidvbJMvdHczQKha1OxSxxGCXuFFzSActlY0
	 I2HnaKo/IL4Bw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 25 Nov 2026 20:10:08 +0100
Subject: [PATCH v4] rust: alloc: add per-task memalloc scope abstractions
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-gfp-noio-v4-1-0f67ab9895ab@kernel.org>
X-B4-Tracking: v=1; b=H4sIAI8yB2sC/23NTQ7CIBRG0a0YxmL4awuO3IdxQOmjJRpowBBN0
 71LO9BGHX4vnMuEEkQHCR13E4qQXXLBlyH2O2QG7XvArisbMcJqQpnEvR2xDy5g23aCAuUVkRK
 V52ME6x5r6nwpe3DpHuJzLWe6XP9EMsUUKy2JtEaoVojTFaKH2yHEHi2VzD6yJtVGsiKN1QwYr
 w3T/Efyt6SUqI3kReqq4dC0oMzXn/M8vwAmVIzkFQEAAA==
X-Change-ID: 20260128-gfp-noio-fbd41e135088
To: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9565; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=0YRhhuKoy9a8ZWo6v32rODo4LhAbhlvxZN1lEYkVOw8=;
 b=kA0DAAoB+lApCKrFvdAByyZiAGsHMpaj80yAAtDs2/HBL2/2iD6q8ROCtcVTm1LX5MyAqVdUY
 IkCMwQAAQoAHRYhBFeK2cjZZnYmKsBqhvpQKQiqxb3QBQJrBzKWAAoJEPpQKQiqxb3QlTAP/jS0
 MAELtG5ofjnYaNxy3Zg4S6rkf1bzZqmQWh0LhRjU8lnlCSpWaRwHQ9NHjE0GYShtZ+pdtKfdhM4
 UCzm4UcwFaL6JZujqUBBe9NsEZzrYsWkLmDzE8bY0Q10XqYd1d5PzjJFozIeWbL2GKvC60WktZc
 26miCJc2hvSlN7nrK6oVMeNOIPInSIGh9rJMEBqTfPVqucBFxaGDONUOix5pRFoehTb/HNKQ0L7
 5sLh0P/pOtkmD3qjwNTP3OTcMkXnWeZYuZVCeYQAJFbxEl+6juzRX8vP0C0Z3XAgNNcontLJuI5
 ACetC5iqfwZ1y4lw25ADlJKahTIZLGcWjIBKM+Kke47HFabgVpy3ugRtHosX3cM3Y4gHRXt1L0N
 BdfwZvzZy4PLi+q0+Q89Ks07T4uqkg2v1XGAakdH5dZ4tthG1CeN9f2RHADb1FJ0FH5GBQnQAAd
 IwkN3iCPlhRCF1b8P9uC/qfF0HrpK1pyPq8dGRNmIAvm7WqN8o+ujrE5Qe03nlezM7fv8c5DVWn
 7q/vl7vA+Pa5jUcMRNfC1Pff0N4BeEyd6JhDd98VM3X1JTMNmMLRePiPILpSzilLfih3QRM5Xt2
 5wAuSIO5+t+z/v2ClX3mcky9WNcdl2c9R/6dlWRTNOES3A0xZ3Ci8ygIjy+cMTZci68kt0wd8/A
 w2ple
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 20AB140009
X-Stat-Signature: gfr68pfwifx9hpry1fg79nd15ciizr5g
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795633841-90137
X-HE-Meta: U2FsdGVkX18HvcDrqJmlgJMeRoxtZryUpfT0Z1iRQefMbridh2LzI9tgPUsViJ+Ms1E68/uIwOJ02GgBReTSSqUDlxtvShhVqp3RMkkOOYoFu1SOxxU1oNV9ZvNO2lcE5Fj5K/p5pZ2XbMaQGDMOODvviwfM+GA0SfTe115Cwr/H5PiqaUVjbYHIflsDDYdXOo6Nsh21qaWXRlk0k8IlAKPVjUMdluS9fOikN0Q8YZVLR9jaO9bYPwONKYTVK3w+11CFYCTvoDSKCwQT5vI4nhxi6Tr2VuDtOXrBoIRyTPFc3659GQir8PEr78tGB/w3cOdDOntc3W2SxogI2a00CTO+ekJd/dSj8IDEzdbAh4CgGbQpu2qbmx/3b2GhykRfPpshAwyc6Q6JF14JIg1TCFb3/3CUU/jG6X7QdV1LCUJnhVNuYWBM6+BvE0cdlTYoO7tdtvp8f8LgKLvs7swUqLezVRE5+e00JjW2Aq23HAHEsR2QNBMzinpnXX2m8CejQYRK3bvh4FLaxRat8XffEEmPVKe98O7OBI5449wzAI38et/FRWQ1AN0R8ugX7tT/ZCzAgUmV7vbKOV3xErDPtt+I8oCjC+U+P0jpvQMlJFTs8KfhjRda7LRTHnDsdSvSGL7gO54jvm/freiH5EpA43j9Z6rvHEVdhFJHouBNItdCCji0HYtfMIWS8CxK7B9woyj/+lNra4Exxx1xN8CCiXW5hk2/ag/As3ATl5kOijqr2s3vNWcXAjDr6yrPM/8S5uG0GnK7bkKD7HBwwMblKew5RrBZpO34b6fnzryum1PAlDF8i8hn2EjLJ0SvCNKUewkqvcTaNADquMH60v68FUdB6joZ5H7AFi8COtxA5W/kfVEYV1difAas4z9kWCgaS1c5ZAHJ+635+ij9rCKY6Q+M1R+vo/ig5aRyJXZJqZfr4YT9Bja4cDZN815aO/MtWqm7ratrt/7j18dUyY9
 TnLUAvWc
 gxbse7YxJLrwwh9tV7Y0nCfb6SKL053N04q3XcixP0D2EO134SBazhInCGJeNjYXdOduKbCLbiS69KfRWb1C+7abWCuEJtGONevIONLX9RR0mFJ0yMOMq3ULmQYRVSn3aDtUccKr6K1Hxj6oFD2xRBtPmCVlAM0ScyGdFyVwO1bKFxpEoTwFTX/J+Ktjc4XyDBmNACyVV5uF0UJmWrP0ynJDG+aXIAVGQwo13b6v+jiZ8FKorDHaOpYcJ5gkKrjQJI9ZrJQKCawVVN0Smn26gx3fsRzucskIORv+ETwKKOlYg9T/Evsf6//uzIjPNmNneunCiNAAqmXr4tH0BuBctykvf3nIIk8ffCKFNw7Qrfnq/sVjqVubm8GpCN6eSNErtYG0NJlxSbmPDgEvOULEbCy8GPj+U/oMGpLRGDqZjWcfHesoxLImT6X+Mk+z6/2BDxWycQTxnS3De8g/PctcHMXprD8iyLnAIjvtYINIkDBf+lvv5N0Gvhwvf97VAEeBpUegJyTgEENKcJ4i7G1PvJP9NZXJFA8ccXXYXrZWNeI+8KrQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add an abstraction for the per-task allocation policies exposed by
the kernel through paired save/restore helpers in `linux/sched/mm.h`:
`memalloc_noio`, `memalloc_nofs`, `memalloc_noreclaim` and
`memalloc_pin`. Each pair wraps `memalloc_flags_save` and
`memalloc_flags_restore`. The save call sets bits in `current->flags`
and returns the bits it added, which the restore call clears again. The
pairing assumes strict LIFO nesting; restoring out of order corrupts
the per-task state.

Expose each policy as a variant of the `ScopeFlag` enum, with
`ScopeFlags` as the corresponding set type, both generated by
`impl_flags!`. Add `alloc_scope`, which applies a set of policies, runs
a closure and restores the previous policies before returning. The save
and restore operations are not exposed on their own, so safe code
cannot leave a scope open or restore out of order.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
Changes in v4:
- Replace the `ScopeKind` trait and its tag types with an `alloc_scope()`
  function taking `ScopeFlags` built with `impl_flags!` (Gary).
- Replace the per-policy C helpers with a single `memalloc_flags_save()`
  and `memalloc_flags_restore()` helper pair.
- Do not expose a safe/restore functions public (Sashiko).
- Mark `alloc_scope()` as `#[inline]` (Sashiko).
- Link to v3: https://msgid.link/20261109-gfp-noio-v3-1-a573e7be9c44@kernel.org

Changes in v3:
- Rebase on v7.4-rc1.
- Replace the pinned `Scope` guard and `memalloc_scope!` macro with a
  closure-based `ScopeKind::with` entry point (Alice, Gary).
- Make the doctests compile and run under KUnit instead of `ignore`.
- Document that `NoReclaim` has no effect in hard interrupt context.
- Link to v2: https://msgid.link/20260605-gfp-noio-v2-1-cfa2e236c2a3@kernel.org

Changes in v2:
- Rewrite the patch to use scoped allocation flags instead of exposing
  a `GFP_NOIO` flag constant.
- Link to v1: https://lore.kernel.org/r/20260128-gfp-noio-v1-1-9a808fc49b44@kernel.org
---
 rust/bindings/bindings_helper.h |   1 +
 rust/helpers/mm.c               |  10 +++
 rust/kernel/alloc.rs            |   1 +
 rust/kernel/alloc/scoped.rs     | 134 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 146 insertions(+)

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 3791af0aadc7..df21b5b129a4 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -86,6 +86,7 @@
 #include <linux/refcount.h>
 #include <linux/regulator/consumer.h>
 #include <linux/sched.h>
+#include <linux/sched/mm.h>
 #include <linux/security.h>
 #include <linux/serdev.h>
 #include <linux/slab.h>
diff --git a/rust/helpers/mm.c b/rust/helpers/mm.c
index b5540997bd20..42424583e7b3 100644
--- a/rust/helpers/mm.c
+++ b/rust/helpers/mm.c
@@ -48,3 +48,13 @@ __rust_helper void rust_helper_vma_end_read(struct vm_area_struct *vma)
 {
 	vma_end_read(vma);
 }
+
+__rust_helper unsigned int rust_helper_memalloc_flags_save(unsigned int flags)
+{
+	return memalloc_flags_save(flags);
+}
+
+__rust_helper void rust_helper_memalloc_flags_restore(unsigned int flags)
+{
+	memalloc_flags_restore(flags);
+}
diff --git a/rust/kernel/alloc.rs b/rust/kernel/alloc.rs
index 68d80f3fa6c8..5e4c142b5682 100644
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
index 000000000000..7fec1c974192
--- /dev/null
+++ b/rust/kernel/alloc/scoped.rs
@@ -0,0 +1,134 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Scoped allocation policies for the current task.
+//!
+//! The kernel exposes several per-task allocation policies through save/restore pairs in
+//! [`include/linux/sched/mm.h`]: `memalloc_noio`, `memalloc_nofs`, `memalloc_noreclaim` and
+//! `memalloc_pin`. Each pair is a wrapper around `memalloc_flags_save` and
+//! `memalloc_flags_restore`. The save call sets bits in `current->flags` and returns the bits it
+//! added, which the restore call clears again. The save/restore APIs assume strict LIFO nesting;
+//! restoring out of order corrupts the per-task state.
+//!
+//! This module exposes each policy as a [`ScopeFlag`]. [`alloc_scope`] applies a set of policies,
+//! runs a closure and restores the previous policies before returning.
+//!
+//! [`include/linux/sched/mm.h`]: srctree/include/linux/sched/mm.h
+//!
+//! # Examples
+//!
+//! ```
+//! use kernel::alloc::scoped::{
+//!     alloc_scope,
+//!     ScopeFlag, //
+//! };
+//!
+//! // Every allocation inside the closure behaves as if `GFP_NOIO` were set, even though the call
+//! // site passes `GFP_KERNEL`.
+//! let b = alloc_scope(ScopeFlag::NoIo, || KBox::new(42_u32, GFP_KERNEL))?;
+//! assert_eq!(*b, 42);
+//!
+//! // Policies can be combined with the bitwise OR (`|`) operator.
+//! let b = alloc_scope(ScopeFlag::NoIo | ScopeFlag::Pin, || KBox::new(42_u32, GFP_KERNEL))?;
+//! assert_eq!(*b, 42);
+//! # Ok::<(), Error>(())
+//! ```
+// # Implementation details
+//
+// Since the closure used in this API is synchronous it cannot contain a suspension point, so the
+// save and restore always execute in the same call frame, on the same task, and nested scopes
+// restore in LIFO order. The save and restore operations are not exposed on their own, so safe
+// code cannot begin a scope without ending it.
+use crate::impl_flags;
+
+impl_flags!(
+    /// A set of per-task allocation policies.
+    ///
+    /// Build a set by combining [`ScopeFlag`] values with the bitwise operators, then pass it to
+    /// [`alloc_scope`] to run code under the policies.
+    ///
+    /// # Invariants
+    ///
+    /// Only bits that correspond to a [`ScopeFlag`] are set.
+    #[derive(Debug, Clone, Copy, PartialEq, Eq)]
+    pub struct ScopeFlags(u32);
+
+    /// A per-task allocation policy.
+    ///
+    /// Each policy corresponds to a `memalloc_*_save` / `memalloc_*_restore` pair in
+    /// [`include/linux/sched/mm.h`](srctree/include/linux/sched/mm.h).
+    #[derive(Debug, Clone, Copy, PartialEq, Eq)]
+    pub enum ScopeFlag {
+        /// `GFP_NOIO` scope.
+        ///
+        /// Allocations on the current task behave as if `GFP_NOIO` were set, making them safe to
+        /// issue from the IO completion path.
+        ///
+        /// Corresponds to `memalloc_noio_save` / `memalloc_noio_restore`.
+        NoIo = bindings::PF_MEMALLOC_NOIO,
+
+        /// `GFP_NOFS` scope.
+        ///
+        /// Allocations on the current task behave as if `GFP_NOFS` were set, making them safe to
+        /// issue from a filesystem critical section.
+        ///
+        /// Corresponds to `memalloc_nofs_save` / `memalloc_nofs_restore`.
+        NoFs = bindings::PF_MEMALLOC_NOFS,
+
+        /// No-reclaim scope.
+        ///
+        /// Allocations on the current task may dip into the memory reserves. Callers must be sure
+        /// their allocations will help free more memory shortly; see the kernel C documentation
+        /// for the full contract.
+        ///
+        /// The scope has no effect in hard interrupt context, where `PF_MEMALLOC` does not grant
+        /// access to the reserves; see `__gfp_pfmemalloc_flags()` in
+        /// [`mm/page_alloc.c`](srctree/mm/page_alloc.c).
+        ///
+        /// Corresponds to `memalloc_noreclaim_save` / `memalloc_noreclaim_restore`.
+        NoReclaim = bindings::PF_MEMALLOC,
+
+        /// Long-term pin scope.
+        ///
+        /// Allocations on the current task are restricted to zones that allow long-term pinning.
+        ///
+        /// Corresponds to `memalloc_pin_save` / `memalloc_pin_restore`.
+        Pin = bindings::PF_MEMALLOC_PIN,
+    }
+);
+
+/// Run `f` with the allocation policies in `flags` applied to the current task.
+///
+/// The policies in `flags` are applied before `f` runs. When `f` returns, the policies that were
+/// not already in effect before the call are removed again. `flags` can be a single [`ScopeFlag`]
+/// or a [`ScopeFlags`] set.
+///
+/// # Examples
+///
+/// ```
+/// use kernel::alloc::scoped::{
+///     alloc_scope,
+///     ScopeFlag, //
+/// };
+///
+/// let b = alloc_scope(ScopeFlag::NoFs, || KBox::new(42_u32, GFP_KERNEL))?;
+/// assert_eq!(*b, 42);
+/// # Ok::<(), Error>(())
+/// ```
+#[inline]
+pub fn alloc_scope<R>(flags: impl Into<ScopeFlags>, f: impl FnOnce() -> R) -> R {
+    let flags: ScopeFlags = flags.into();
+
+    // SAFETY: By the type invariant of `ScopeFlags`, `flags` only contains `PF_MEMALLOC*` bits.
+    // Setting these on the current task is sound from any context. In hard interrupt context
+    // `PF_MEMALLOC` is ignored rather than misinterpreted.
+    let added_flags = unsafe { bindings::memalloc_flags_save(flags.into()) };
+
+    let ret = f();
+
+    // SAFETY: `added_flags` was produced by the `memalloc_flags_save` call above on this task. `f`
+    // is a synchronous closure, so it has already returned and any scope it began has already
+    // been restored.
+    unsafe { bindings::memalloc_flags_restore(added_flags) };
+
+    ret
+}

---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20260128-gfp-noio-fbd41e135088

Best regards,
--  
Andreas Hindborg <a.hindborg@kernel.org>




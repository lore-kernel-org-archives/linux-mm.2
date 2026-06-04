Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D2D2CD6E75
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 19:59:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C66526B0093; Thu,  4 Jun 2026 15:59:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C174D6B0095; Thu,  4 Jun 2026 15:59:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2E1A6B0096; Thu,  4 Jun 2026 15:59:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A48E66B0093
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:59:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4C2031C1178
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:59:57 +0000 (UTC)
X-FDA: 84843296034.16.A8862D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7167F140002
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:59:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=erNGeM2b;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780603195;
	b=h/nTFkxcwDB8Wt1Z+jgj9x5Q0GkSQJqx3bbvIAwaYfdsOUndw8m73FJjGpoBfltcn5sQeI
	PYTWWqUcnBK6I9sJniBBnO5KgBMzFBjMImMWAKS44NJhKqgHMoqjpZJlN2piySpvdHklWV
	Uzmiug5RIyCK2rtmb0OYEMXBHRClxeY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=erNGeM2b;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780603195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ixi+QJOhPBvaKKM++NPOJdur0t/SwSTk/yHnYjkZNng=;
	b=cdEUAw4fXdMPx6fkGtHDe7QY/i7wWi8dvZqbIp0oKnDASmHpbAVTR7afiixbiDitwUI3ff
	RrXwOhCzrk9bw/gqygwMl13CMT0iGtl5XXjuudQtT4x7NamzGdFw8LCw1haBBW9HPgVnrn
	wU+534lob7LfrtEPmXLKzBSh4krKNXY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D8A760123;
	Thu,  4 Jun 2026 19:59:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE141F00898;
	Thu,  4 Jun 2026 19:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780603194;
	bh=Ixi+QJOhPBvaKKM++NPOJdur0t/SwSTk/yHnYjkZNng=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=erNGeM2bqlTFuHgqScFLsIgo9udKdgieAvty5VzUEKsfA2o3xirRR5x0ULJkbEsH7
	 T/hpr8VKTJ2ckcJIH6SfKpMRTQtgd+CoENYNfiDZs6CVoFQUdcNdsD8t4K+yWK14Tn
	 RhuktW5+RgVpp5DQ95jqYMGl+0KxOOp0xh+KtnvdWjjy9kwwqMNq30iPX6N6O+Oyhr
	 AmxmA2Va+XSxhOYAloOKe1QVLD6Zu5gkwWcQwCNvS1sMuF2W1wAnBmTCLK6JwOFp/C
	 BjTNimW2xa3V/8X7kQrHYS9g69PB96U8s9nmdoAzkOP3jxZ7Qk8dSdVa9nvsBVrDX4
	 JChl3U7TC+Iaw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 04 Jun 2026 21:58:09 +0200
Subject: [PATCH v4 03/11] rust: xarray: add `XArrayState`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260604-xarray-entry-send-v4-3-965f6028790e@kernel.org>
References: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
In-Reply-To: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Tamir Duberstein <tamird@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Tamir Duberstein <tamird@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>
Cc: Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4215; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=wW3dDYAPEV4zxCchJaOgHpoU9SxK5JCQAEcaobGW2ME=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqIdjsiRRLOBz8U2tFyUbjDABp9LNAcfFnMAacB
 q/TryPb/ISJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaiHY7AAKCRD6UCkIqsW9
 0OYsEAChP21SQ0tJK1PcYeptIDAx+bvYcOm3teBt0ihZgYnh6nYrnTdBGHf2kMuIvfs12QTpp+T
 zfNl/w5+U5C0LlK4b5tXCvMMtUaocbXe+5Zh/rSN00zoJs4lDVVneujrjMjLCludaNgUxiSCee2
 zQYlDt53i82yVNaMF61aUtErkLrQ8l4jlOanqN5wbz2oYGH9PYNgxgOwKHWzCayrWq9k5kBtSf5
 9aEe26/crBBXnrPNSZFNe7wSqZ/pzzhblbGRLGs9Qu8DGpy1kiXB5Hs1q55np19W1HOjP8C4E/X
 qr1bWj5mMZVqW262zqgRr87XmdAiOgKsT3zEqbbnCcJPNM8Z8cnaNCWXAqGouU8I0m9XKVMp+xe
 BLveGRujcqD4FAn22ZeIJhbrc3PcL5rwpDxpPycTJcQt5K84ullP7MSDR4U4sZxqZNOtJJj3D4Q
 qXhGXu9eKmJ6NkLWNfg+t7DKg3FhxPZVT0TrnYOOXXIkl6fxkP3C7ajQqy4CihoJjHm3lgeVbdC
 PzNd7/RQ5Kv+5mwaFlptrzXy/7L+CmnKQuk2lnYX3N3L9ZEpfvCcGYcYGzb4yJJbAbyYQrPZzbb
 xxOWYE7RQfr8JjTCqUyV4K6WWYACKR+hYc6utgnsyOw4gn1H57G5rWBG4VinID/419rAnxs/hQP
 rXW2fFRBvTDAMPQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 7167F140002
X-Stat-Signature: wmwcj4xfcb8tcz9cfegn943fzpozd47i
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780603195-842212
X-HE-Meta: U2FsdGVkX1+y5wJZhejPtO0hNLMmhHic9Fr42oDy2M6tf62/1Nc44eDHei2fHvzF7LdCLskym7a/490QF93xtAhytud15KMGpbw9rVWni4nBHxRMtV3w3zIjekeCn2nQ/8kpzWHRkx5KTA36Zp4R/Ch5SleiVt0Evt6Df2glO/yLJqqeUV7REf6JQndC7HtGljjdflzUJHTqMu80v8p94rBGuqABubmgnlnoUT110igoFAc5WXO+j1fvSAKM/wCVyIdBlC6bHSDlE9bNCCdf6Ue9AZ+6oyr0uDUX7Vinqb+e6R72EQzo0qxBctKlKbNdJ6+BP/fvkI3LR//f73owvyebOwTw1AqiY3IgS7+Ca4V64DZIz5lis65QTlpmyERKo01/P17uC3qv7YBH8aZBxRHPkJIC1e8Zr/OHBzWebIzCl0n6RjJKIa6bOv2tLjAKPOOF1i1t2fghpQEdgjodKx04lI+JKtMpPo8CT40+bY4e6Wt1YNWN6fU38/LYnJobbSx9Z7fSImwHL2d0h9Cn11GjDGA+J28fLHVDRrVqAWbuwpf42d1DiAwpeP4BFAcnJ7oRpYPOfXvHWI1s82BHY0C07amcGUwW9or46j/N19LqHYR2uNGH0NL4RnAobYlFbuotCPf0gQhFESpl2hL4cdFRxM/I9y13TWTvqxSwceGK+kUcwhhGehQJd9CqEkaF0K9TygeMZKCpNJcwJYf0jvmL5ksiCnnm9JLfKvghDqWxfl382q2TcG9SCrJ2hTJYUWq8MbzCuec2Li3M1zqWaVP45ijEfu0bRsa7T7vqUDaI2BTSLZdox/ctgh4/0TSs+KGde0hkU+nNlRVtsaHpv+ps7PZ0e0Rn1UHmDF/PkKFmZgKkNSyWFBxQyiCaoy/rTH9sgdetNtTpIqu5EhMysw5oRZzWNkvUqn22cS1lAt1XwAVjQh9OQEgpPDBhfkk/rN5Z0eSJNI6qZsHQwMf
 +9IPfMQ7
 VWKY+WI5Leh+inTNEqtJ18GKAnhaa9v9CqmGx1rTcsaib8cV7lEC9p9LOzxrKUETBQdlMdamMOWKcx7kPROF9VJk5Qt7RHIL8EoSnNTLwCCslXc7vxiGcasMbx22azol/MlFzJiUEkPpJg4rQcy/qkCgHAVOZ5/BcYGqTVjZsHd23bFyd5qE2Uci5apWx36W1E8NcgxUT2yUxTwJ3s8cn2CXYhaojZJl5f1opdLaAk6Yp14/LIPXeF7nJDLVpnFMgtr/BEoRkdAOpPWlGdkvmv4GAa8NOAoO5dVQjm5ENdjbBV/JISNSbHwSVcFIXcGw7Ryz/T/IQr0lIFMp5ZggA0G+8Xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add `XArrayState` as internal state for XArray iteration and entry
operations. This struct wraps the C `xa_state` structure and holds a
reference to a `Guard` to ensure exclusive access to the XArray for the
lifetime of the state object.

The `XAS_RESTART` constant is also exposed through the bindings helper
to properly initialize the `xa_node` field.

The struct and its constructor are marked with `#[expect(dead_code)]` as
there are no users yet. We will remove this annotation in a later patch.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/bindings/bindings_helper.h |  7 +++++
 rust/kernel/xarray.rs           | 66 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 446dbeaf0866..d4093367a4a8 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -123,6 +123,13 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT = XA_PRESENT;
 
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
diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index d54942aeb201..6d0d4905004a 100644
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
@@ -299,6 +302,67 @@ pub fn store(
     }
 }
 
+/// A reference to a [`Guard`], either shared or mutable, that exposes the
+/// underlying xarray pointer and the value type stored in the array.
+pub(crate) trait GuardRef {
+    type Value: ForeignOwnable;
+    fn xa_ptr(&self) -> *mut bindings::xarray;
+}
+
+impl<'a, T: ForeignOwnable> GuardRef for &Guard<'a, T> {
+    type Value = T;
+    fn xa_ptr(&self) -> *mut bindings::xarray {
+        self.xa.xa.get()
+    }
+}
+
+impl<'a, T: ForeignOwnable> GuardRef for &mut Guard<'a, T> {
+    type Value = T;
+    fn xa_ptr(&self) -> *mut bindings::xarray {
+        self.xa.xa.get()
+    }
+}
+
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
+#[expect(dead_code)]
+pub(crate) struct XArrayState<R: GuardRef> {
+    guard: R,
+    state: bindings::xa_state,
+}
+
+impl<R: GuardRef> XArrayState<R> {
+    #[expect(dead_code)]
+    fn new(guard: R, index: usize) -> Self {
+        let xa_ptr = guard.xa_ptr();
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
+}
+
 // SAFETY: `XArray<T>` has no shared mutable state so it is `Send` iff `T` is `Send`.
 unsafe impl<T: ForeignOwnable + Send> Send for XArray<T> {}
 

-- 
2.51.2




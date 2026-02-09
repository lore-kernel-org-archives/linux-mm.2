Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA50BE81BD1
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:39:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 395C06B00A5; Mon,  9 Feb 2026 09:39:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34C6D6B00A7; Mon,  9 Feb 2026 09:39:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26C7A6B00A8; Mon,  9 Feb 2026 09:39:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 121456B00A5
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:39:38 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C1FE213865E
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:39:37 +0000 (UTC)
X-FDA: 84425176794.08.0624AE2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1901BA0008
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:39:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="f3/6c+CD";
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770647976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z+oMqxkPsm+SeIqFusF5Rf52C4m7bRaa8kb5aIAwKdU=;
	b=xOQnuQMbhdUa+N8uQgggH3SOOo6GpfpoH+HD71Hcv32/jMmvVYEJ4dEe/GnOhsgGKaDEaQ
	Daus0AxcdplSui5mGaOa/L1Xzd6WBDTmOX7Ot2Byv0yNIg/T4F5OcTV/FlxXMIqFgma0vL
	d28vDOxv95SNRdQ1Ust1oZ5ANJ/hl0c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="f3/6c+CD";
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770647976; a=rsa-sha256;
	cv=none;
	b=AgTOc2zaUxAv9JK3bWTZoPl6DT+7jHozPUMRm9taNTVyr6GplI/fG+/aYzOxz1V6+DNi6t
	lZRAuIpSuMbwubIGm6AF2XI2Vbyqr6TaDpIkDCmkdPgJJtRm46s00+hFQ3+hoxskKpcBrB
	sGGo3Ek8AeXv5NBRAWjxI6FdjL4r5BI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 958FC6011E;
	Mon,  9 Feb 2026 14:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD43C19423;
	Mon,  9 Feb 2026 14:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770647975;
	bh=2aA6TsP5TqOXxamqOrEM+ulf/tg/RPrxh0tZsqKQ8Qk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=f3/6c+CDPCNHcWfMSeuShETnmdtjswhGYyK9abyIPkMMLBHgipbzcxoFAn+ZhIw3W
	 THwWkaLF5zs+2Cztg1ctGv0W03mRF8jvkMYsIUASGbyiOP/xL59u2z/vTd6hmaCsvZ
	 aYCrroCi8cfkdVD6cJgS+mfq3Sxq1Au75al6b4C7EkPFqtJtn5ze1qlaTysLNVdmNR
	 vVkuuhB6gkY5RQrr2akrRTx1196traXRoI3MPRJCkZIFN6dOzKNdnYu3cuGZNhouDD
	 UX0hU8WZNM62DlEpSrxc0BAf635t9Rz3J9c393HtV7fOIkWOixLT0PFrJ7EttiYPC4
	 WhHTWO4b4ppnQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 09 Feb 2026 15:38:09 +0100
Subject: [PATCH v3 04/12] rust: xarray: add `XArrayState`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260209-xarray-entry-send-v3-4-f777c65b8ae2@kernel.org>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
In-Reply-To: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
To: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3142; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=2aA6TsP5TqOXxamqOrEM+ulf/tg/RPrxh0tZsqKQ8Qk=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpifFY1Yb/s0Cx5dL+ceTrbgCsO2VEgXHKl81NG
 XaSBz9rJQKJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYnxWAAKCRDhuBo+eShj
 d6GqD/9zwzHqTXewAxq/4Wup8VvXE1kLNVxZpeJpW/OsViwlFsajqwWV7FfAutYCIWFTcnPkTnj
 0KKlFWUqLdmeYmIhfzpePwVrz2E5PlCGWXKO1XlVgVp0Q8iinr6dpXyEQxvsz8pYWXlWCkQSQZL
 eR44WTMOlaPhzuCALGKg+ijVlbokb4zq/j21bPjYozplxqlXPZud2oHZC/Rl2FOchlj5Zn5SVn1
 bgu9ICVxaFx1umTR83cLpYv5sZLz1+I285ESrQwJG4faCrDcA0GrB6nllbYOuf/3mTZC7tem+B6
 1tY7L5iEy8CZKLz1m6GATAeqapHo94gkhOt13tuX08sI9dONC0VOBl6VCUWS5lthQX6j2ousEhA
 S8j3JKNfWmBtsjn9btygkJeN2mVG4sDN3iYuWnMxe/CNtrxMG6jHP/JFa97Ic1lMVbDZoMqXsAq
 n5qlRo7XpyBq+sYqYobnMzRXtKBl092PLTVDY0aY4dCKscf+MhHxF2GnyEuDR7UlMWSvHMwPfVu
 vuiZY7nQXW4LoyQXPak9P5Ot59iYBk6xlG2vB4x+f7MPFVwyQVOq3fNC0iOnsrtEd9Q36ZvV6op
 yazBSX4V79D0JXg+QCpSeCtGjNqI9IfmR26sZGs+X8DCdO8HerDf8MEImi1dwbbM54y1yQe6oZx
 uh9A7d6F+FrrOow==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1901BA0008
X-Stat-Signature: jmbrnxwr934xmngaaedodb614ic94udi
X-Rspam-User: 
X-HE-Tag: 1770647975-557621
X-HE-Meta: U2FsdGVkX1+MhDcmOEU29AvASeGvs9sDj7H+VJOokhXcRhdCp5YCMtuOXRdfRYkERok4ZRvlH1Q9iX3YYx6wVIgHtA29z3PXYDGi3n2mWrl33Go4y0FGCjVU+nILf7wbBcnN7EY6jQWMGFFTvwMwgZ/wetFHdNa+wRxyPuQ8f/J61d+iuqW8u2ZMIeVvDwpRc8C9wCKqz9++u2guLZQemg7vFOW5jFzhTa5PX6EMY7M87fo2xZ8NcwEF9ukAEf2kECUpan3mE4C6S0TBgE6ipuZek7/vsiLer5dMbN82gJV0bJexrbWYzZzP6EtIX0t0QFlfalAww4H2NKL3Y6idHyTHNlyEvKaRAM/iXIg0H8zs0iiLHtfRwdrQk14MVp2lxnxy5xIyj6oVIBo5Wy5SQM7rKGl2Of3HST6DhDPLA35jd9lx9op3c1YTPcbfKSPy2Q5nqyHywpbTRMefi6OctMIO03mZVJEs8M3+iLlFPk1vmVjRAA8CE/PzLedjoreQ0APjkBmVfEbf/g40m1RFNC0t3H7V+BbsUXP7Ze0On5q7uQcLf1r9X/vVPDIQz8VXGP7b79rsx60sofitM3iedN3dpk9quROGYxDjvX2a9jWizcWP4KdNo4G75FDl21eKmXU+uDCa3fIG5+kzLiYcR0++hzbhLFet+qQJWCndAFT5qJ6KVMJyVilWNPpdGODw59F68NvMT9YElx0ijDLqGtKvXyHFR0EcJ6mIz7RNn3GDsuzICYREcDSIUH4foMeSPH595zc01zIbFgJpcwlHoHUNz//+Y+6+bXW6sOoV1OYMuQKY1bFLxTAheWkKkikvb73NX7du2MMqUzOfn3bwBk8q1O1K5HpQtKboITiZ4rzeTeL228Xr8U0dP9XeRgxaYqw5s99EefMk9IzT1A2TgqNw9fbVcBYc2An2NsORRYA0lek8s6bPKN/GP+//sQImDf2Hck+wO873FjQMZ84
 UdqmBei6
 S9XMEFZPE8wDIbqC+eg3y+8fRNJtbGe37oa+Wfh+r4Jnr8otulPt3NdZmIpNm9p5JEScOhfF1Yfw5/LgkVjMKDFnNBFS+0S1dUVJlltIZ8m26r9Kqg1dQ9W1Xt4JTTKY20lrohhSuiLPI+njxUAAiAwxG2QKrcwB3Vr/XW8GKUMXQjUwCVPaYdNxb8vFgzdlwO/f3pYfLdxaq5phaTekdTi1hSOQczvH4EbP+BciF7xaqdRttp+S9tNV2u+ndKdACGy/S984B0rBs70VujpfvgCBw14rNVDiL8OuUuzRyXq9xRhGuutan0KUYZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 rust/bindings/bindings_helper.h |  1 +
 rust/kernel/xarray.rs           | 41 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index a067038b4b422..58605c32e8102 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -117,6 +117,7 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT = XA_PRESENT;
 
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC = XA_FLAGS_ALLOC;
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 = XA_FLAGS_ALLOC1;
+const size_t RUST_CONST_HELPER_XAS_RESTART = (size_t)XAS_RESTART;
 
 const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE = VM_MERGEABLE;
 const vm_flags_t RUST_CONST_HELPER_VM_READ = VM_READ;
diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index ede48b5e1dba3..d1246ec114898 100644
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
@@ -319,6 +322,42 @@ pub fn store(
     }
 }
 
+/// Internal state for XArray iteration and entry operations.
+///
+/// # Invariants
+///
+/// - `state` is always a valid `bindings::xa_state`.
+#[expect(dead_code)]
+pub(crate) struct XArrayState<'a, 'b, T: ForeignOwnable> {
+    /// Holds a reference to the lock guard to ensure the lock is not dropped
+    /// while `Self` is live.
+    _access: PhantomData<&'b Guard<'a, T>>,
+    state: bindings::xa_state,
+}
+
+impl<'a, 'b, T: ForeignOwnable> XArrayState<'a, 'b, T> {
+    #[expect(dead_code)]
+    fn new(access: &'b Guard<'a, T>, index: usize) -> Self {
+        let ptr = access.xa.xa.get();
+        // INVARIANT: We initialize `self.state` to a valid value below.
+        Self {
+            _access: PhantomData,
+            state: bindings::xa_state {
+                xa: ptr,
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




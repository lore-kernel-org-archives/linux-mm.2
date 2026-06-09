Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C73CCD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:13:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92A646B00CF; Tue,  9 Jun 2026 15:13:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 901C36B00D0; Tue,  9 Jun 2026 15:13:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 819096B00D1; Tue,  9 Jun 2026 15:13:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B99B6B00CF
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:13:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3245A1A073D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:13:30 +0000 (UTC)
X-FDA: 84861322980.07.A770590
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 647BE40002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:13:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HR+32Ab6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xna1WpbAQAdejm6/MlRFJZMGV7MPhzRJAHMLP9ok4LQ=;
	b=iEF25ScpoE6Mr0inZ5A8S62N30MKfhNM4IImWAZJe7Gu4xCRYHJFrIigsB2JBomT4g3Feo
	gQv5Uwn8yn7WUob2NhoadqzP30Mpfe9YyepmGIk3/wfzMPGOAhty/Jo7wgTj0j76Qd5uSj
	e9OL6YFs6oajLCTRFwHfi40SrLw03Yk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HR+32Ab6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032408;
	b=8AYhAHUM5VVHu8bRDp+9iGVoqoarRM0CReM/J3JlKBoTifP8DLhEYTju4pQemIUJl9vpvx
	ZjmoR/NTiPnxPGYmOBfWlY9yqSOKNQVO4cH5GF8URbkWNLe/tLZGBv3y+u1+fvFK2OZd7P
	QDL9B+A0Vnc+0CM/8jvpKoooyRnnkeE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A99EE40368;
	Tue,  9 Jun 2026 19:13:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F731F00898;
	Tue,  9 Jun 2026 19:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032407;
	bh=xna1WpbAQAdejm6/MlRFJZMGV7MPhzRJAHMLP9ok4LQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HR+32Ab6FJNQWMIb7U6W0t84SUfNsrnH6DGh+nZ5jR3jKeOZDMoi2NN7ru0iGIivv
	 ojFZBQZyObM0wn0qIkh1Ik7/AkFCbtSKDLhXp0BqbkAV6hYL56hn3qJAmJcmBP/GYb
	 DiAkf0wFTGLKrUYKRDCITHXPSTdQc3br+nCd0d8Vvo0aTGKdYldr5x2PESNkkIEATu
	 J7CzUGWP7O4/NrpxW+RR4r6dMlyKnFQ1Oae6hadu09e/9iMWby7zz1V9O1P2RXxI7g
	 pNlpfUdilM9Znj9uzxr9U8OiQI5KWU8qkcpUfrDB0o6BKYHAmK/ptKPj51djE83+aY
	 WYlcNcCyylXHw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:07:46 +0200
Subject: [PATCH v2 07/83] block: rust: change `queue_rq` request type to
 `Owned`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-7-82c7404542e2@kernel.org>
References: <20260609-rnull-v6-19-rc5-send-v2-0-82c7404542e2@kernel.org>
In-Reply-To: <20260609-rnull-v6-19-rc5-send-v2-0-82c7404542e2@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>, 
 Alice Ryhl <aliceryhl@google.com>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Benno Lossin <lossin@kernel.org>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Boqun Feng <boqun@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 FUJITA Tomonori <fujita.tomonori@gmail.com>, 
 Frederic Weisbecker <frederic@kernel.org>, Gary Guo <gary@garyguo.net>, 
 Jens Axboe <axboe@kernel.dk>, John Stultz <jstultz@google.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Lyude Paul <lyude@redhat.com>, 
 Miguel Ojeda <ojeda@kernel.org>, Stephen Boyd <sboyd@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 "Liam R. Howlett" <liam@infradead.org>, Boqun Feng <boqun@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 rust-for-linux@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=18998;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=OdnzBNU31O2ZnfIiXoHm34uCgI6yyOystzxqjcmD7w0=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGS67cn9N194bV1gIXZ48CMQNOsMI0JrrRTqg
 m7uBzydPyKJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihkugAKCRD6UCkIqsW9
 0EJXD/wIYrkihr2QLiwhOeo6NswKQa+vORjWQxmP1BRHjf7Xee9gLeBWtQorc6SXtfFK8kegEOo
 4ogIkzViCmtG5hMI9u5GKt38TyUy7LqOjZY5v/5Q4SZNGs6orjDbyW0SWM1D3xic/RZs32aBHWy
 N8XYyYN7oy+SiUdYPVIHCkEC4ZNbprMRd4aNQH5ddnkxpUwtCyddEBZ4w/G8OcO/g+6B3rjDvhz
 9Xw36Skbfd7s+wRo00JctLwsEYAlItWN/Ky4wzrx25S237xa8Lo7SueZ4uuIqjkZT/T6ndhFYK2
 bUGOyo44TcF9NOATDxLJB9xPec6nF/TF3UOD8qLxtBt8Zc7nij/rBRL+UjUBXyLxzfnp5Ksbr7P
 ExnB9Zn+C8qM4rLX54pbsmD5WkHKfSyQVTnInQQEiP/irWwTtqAt3VK//+qr1Qwu0QiupQkp5mx
 TGS1XnmBfeRcYYGWhWjl8sUWIFbYlDtuc4Lwo7zpes6Mq8oRhHsmFbtKvAUMk/6Yb5uUrpT1hdg
 i36z/hsFcqzQpAgIonwFU6LWfec9x1WCSX/fR/ayB/SWJScGrH+bth71ZmcCgHeh0/PHvOwsOb4
 ZyqpLSqMrGtLqNQfw5NFeDhG/zebTIizuBmqYfr473kTETlMHXjr7wbtLQngj4e2F0S7N85VnJk
 aNIlTh7JZ72Ng/Q==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 647BE40002
X-Rspam-User: 
X-Stat-Signature: egbzykyyycn18jgi58yrr3ry5c8gpjsw
X-Rspamd-Server: rspam09
X-HE-Tag: 1781032408-222519
X-HE-Meta: U2FsdGVkX18U+dXm04R+uoT0MNuzq8L9a69pL1Igv5z5EVetlMSnLu9BnC2Q0h8UY8vKDniedORUYmRnzEA1LcOoO8GSk4qAEdI2m++1foFbsfcDbY7sKejaLKTjNvUXnw/ULT9gjlbRSIyLuDLBoFGhOeSlKUWPZfs0loeV/dBCrsweye59wLY8zdTNdv754TBcvZZbiFtqMwVcLfq+L1kCXbJVrSCG5bt+qexuK9xEp+tiu1yZd0Kw9XxpGwrw4fIKD3ajoGOhnq+D+R484wrnCLatRmCkyco/4VQsG2SRi+TYs0ZJjh4m9XerG5Pl8mVwQavp6nT9MrxzAwHMvBZjpmwlX8JxDnAgvuJv0S+rtCEmKDD4aamI1HmF/S/ndB2Oonv/L/IgirjRYJnPVrWt25Fog9QWZnFDpqCMxOlvJmLSuF0VSkvoEp8GEwWkh6mYScP/qumLHNRdgmexaWhbXg13K1lFYymzL90+qF1fZoN9ZE/lUiW2NUhRVft9FwdT3drEs/MjpLSD9WjLXOtr6nJ0ZqltL08YsOgvf+93LJn2QBplIYMkafehVWBRwF7GGyMYSCJtn/WtdWgtYf/NDTpf/mr/OwbfjBQ3q1RNCSwGyeDE7ZNJH6qDGQwKdznRbML3ZMcBNwbY84/tSKGzZirU68muD2xHdW+P9mel+X9h0sDUaCwsuhVKPmIQj5JRC5HABQcj6arXda9dhy3cqLk5t1ZORr6wtjJEYCVT8SVg5Eq5jehGTlTBHuTLbr+D+LxWPwOIwWVnjp/VGEp5fpwJd47MhCJzgSG/XAj+QDjXRMl4kkN+E+64kuCkTPzGO9oShfCqLcCEVp1t7AMwX2P8j3hMHnwA4XBEU6nszEIt12ljpfk2czf5exDE5RXcciPZGMjNAPJXVOzOaz8aDW9sU/df/b4bxhFlGYEye8kjA1Fa2aeagUeeMTcXE1lMrWjzKIKMSG8DPJc
 JIVtlKet
 9l5nQ1+MUrsclQMCvNmO8lRRUTyWT4lcI6I32vKnNqiReS0JFRDM0SfXPYfHca7qJCHS1WU1y+kgVar5c7L4NtnIGlFwSIEuwfgtcz7bGOe2Y7bH3ryWvn8iYPs2xeLRnueevMLhjx7WJwNbD2z2rCfwJ4KJKoLjvKtVCvNVFwefqs+NQ8kumAprcC8EI3GwRXcfpdj8rIwOVqJWUfo1qBnPfS4VC+GFoAq1StIBxbM7Rb2YD/XU69X0bH9WEsAyCq+J7C7GDF2P2xvox4GPgO72A1xF7B6D7kcZLhA1w5NUdMQLq4GL7WapZrsW53pRmp4zEAfMjcuTVg2vwuecnwnkegvzriR/YLvJ2bcLrNJRf7PosRbwsLo4Yxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Simplify the reference counting scheme for `Request` from 4 states to 3
states. This is achieved by coalescing the zero state between block layer
owned and uniquely owned by driver.

Implement `Ownable` for `Request` and deliver `Request` to drivers as
`Owned<Request>`. In this process:

 - Move uniqueness assertions out of `rnull` as these are now guaranteed by
   the `Owned` type.
 - Move `start_unchecked`, `try_set_end` and `end_ok` from `Request` to
   `Owned<Request>`, relying on type invariant for uniqueness.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/rnull.rs       |  26 ++---
 rust/kernel/block/mq.rs            |  10 +-
 rust/kernel/block/mq/operations.rs |  32 +++--
 rust/kernel/block/mq/request.rs    | 231 ++++++++++++++++++++++---------------
 4 files changed, 176 insertions(+), 123 deletions(-)

diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 77ccc6850961..69cf62475446 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -19,7 +19,8 @@
         },
     },
     error::Result,
-    new_mutex, pr_info,
+    new_mutex,
+    pr_info,
     prelude::*,
     str::CString,
     sync::{
@@ -27,6 +28,10 @@
         Arc,
         Mutex, //
     },
+    types::{
+        OwnableRefCounted,
+        Owned, //
+    }, //
 };
 
 module! {
@@ -129,15 +134,10 @@ impl Operations for NullBlkDevice {
     type QueueData = KBox<QueueData>;
 
     #[inline(always)]
-    fn queue_rq(queue_data: &QueueData, rq: ARef<mq::Request<Self>>, _is_last: bool) -> Result {
+    fn queue_rq(queue_data: &QueueData, rq: Owned<mq::Request<Self>>, _is_last: bool) -> Result {
         match queue_data.irq_mode {
-            IRQMode::None => mq::Request::end_ok(rq)
-                .map_err(|_e| kernel::error::code::EIO)
-                // We take no refcounts on the request, so we expect to be able to
-                // end the request. The request reference must be unique at this
-                // point, and so `end_ok` cannot fail.
-                .expect("Fatal error - expected to be able to end request"),
-            IRQMode::Soft => mq::Request::complete(rq),
+            IRQMode::None => rq.end_ok(),
+            IRQMode::Soft => mq::Request::complete(rq.into()),
         }
         Ok(())
     }
@@ -145,11 +145,9 @@ fn queue_rq(queue_data: &QueueData, rq: ARef<mq::Request<Self>>, _is_last: bool)
     fn commit_rqs(_queue_data: &QueueData) {}
 
     fn complete(rq: ARef<mq::Request<Self>>) {
-        mq::Request::end_ok(rq)
+        OwnableRefCounted::try_from_shared(rq)
             .map_err(|_e| kernel::error::code::EIO)
-            // We take no refcounts on the request, so we expect to be able to
-            // end the request. The request reference must be unique at this
-            // point, and so `end_ok` cannot fail.
-            .expect("Fatal error - expected to be able to end request");
+            .expect("Failed to complete request")
+            .end_ok();
     }
 }
diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
index 1fd0d54dd549..b8ecd69abe98 100644
--- a/rust/kernel/block/mq.rs
+++ b/rust/kernel/block/mq.rs
@@ -62,6 +62,7 @@
 //!     new_mutex,
 //!     prelude::*,
 //!     sync::{aref::ARef, Arc, Mutex},
+//!     types::{ForeignOwnable, OwnableRefCounted, Owned},
 //! };
 //!
 //! struct MyBlkDevice;
@@ -70,17 +71,18 @@
 //! impl Operations for MyBlkDevice {
 //!     type QueueData = ();
 //!
-//!     fn queue_rq(_queue_data: (), rq: ARef<Request<Self>>, _is_last: bool) -> Result {
-//!         Request::end_ok(rq);
+//!     fn queue_rq(_queue_data: (), rq: Owned<Request<Self>>, _is_last: bool) -> Result {
+//!         rq.end_ok();
 //!         Ok(())
 //!     }
 //!
 //!     fn commit_rqs(_queue_data: ()) {}
 //!
 //!     fn complete(rq: ARef<Request<Self>>) {
-//!         Request::end_ok(rq)
+//!         OwnableRefCounted::try_from_shared(rq)
 //!             .map_err(|_e| kernel::error::code::EIO)
-//!             .expect("Fatal error - expected to be able to end request");
+//!             .expect("Fatal error - expected to be able to end request")
+//!             .end_ok();
 //!     }
 //! }
 //!
diff --git a/rust/kernel/block/mq/operations.rs b/rust/kernel/block/mq/operations.rs
index 6b2fcd76372e..bb23a32f3983 100644
--- a/rust/kernel/block/mq/operations.rs
+++ b/rust/kernel/block/mq/operations.rs
@@ -17,11 +17,18 @@
     prelude::*,
     sync::{
         aref::ARef,
+        atomic::ordering,
         Refcount, //
     },
-    types::ForeignOwnable,
+    types::{
+        ForeignOwnable,
+        Owned, //
+    },
+};
+use core::{
+    marker::PhantomData,
+    ptr::NonNull, //
 };
-use core::marker::PhantomData;
 
 type ForeignBorrowed<'a, T> = <T as ForeignOwnable>::Borrowed<'a>;
 
@@ -45,7 +52,7 @@ pub trait Operations: Sized {
     /// `false`, the driver is allowed to defer committing the request.
     fn queue_rq(
         queue_data: ForeignBorrowed<'_, Self::QueueData>,
-        rq: ARef<Request<Self>>,
+        rq: Owned<Request<Self>>,
         is_last: bool,
     ) -> Result;
 
@@ -99,16 +106,23 @@ impl<T: Operations> OperationsVTable<T> {
         // this function.
         let request = unsafe { &*(*bd).rq.cast::<Request<T>>() };
 
-        // One refcount for the ARef, one for being in flight
-        request.wrapper_ref().refcount().set(2);
+        debug_assert!(
+            request
+                .wrapper_ref()
+                .refcount()
+                .as_atomic()
+                .load(ordering::Acquire)
+                == 0
+        );
 
         // SAFETY:
-        //  - We own a refcount that we took above. We pass that to `ARef`.
+        //  - By API contract, we own the request.
         //  - By the safety requirements of this function, `request` is a valid
         //    `struct request` and the private data is properly initialized.
         //  - `rq` will be alive until `blk_mq_end_request` is called and is
-        //    reference counted by `ARef` until then.
-        let rq = unsafe { Request::aref_from_raw((*bd).rq) };
+        //    reference counted by until then.
+        let mut rq =
+            unsafe { Owned::from_raw(NonNull::<Request<T>>::new_unchecked((*bd).rq.cast())) };
 
         // SAFETY: `hctx` is valid as required by this function.
         let queue_data = unsafe { (*(*hctx).queue).queuedata };
@@ -120,7 +134,7 @@ impl<T: Operations> OperationsVTable<T> {
         let queue_data = unsafe { T::QueueData::borrow(queue_data) };
 
         // SAFETY: We have exclusive access and we just set the refcount above.
-        unsafe { Request::start_unchecked(&rq) };
+        unsafe { rq.start_unchecked() };
 
         let ret = T::queue_rq(
             queue_data,
diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index cf013b9e2cac..7444de3c8522 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -7,39 +7,45 @@
 use crate::{
     bindings,
     block::mq::Operations,
-    error::Result,
     sync::{
-        aref::{ARef, AlwaysRefCounted, RefCounted},
-        atomic::Relaxed,
+        aref::{
+            ARef,
+            RefCounted, //
+        },
+        atomic::ordering,
         Refcount,
     },
-    types::Opaque,
+    types::{
+        Opaque,
+        Ownable,
+        OwnableRefCounted,
+        Owned, //
+    },
+};
+use core::{
+    marker::PhantomData,
+    ptr::NonNull, //
 };
-use core::{marker::PhantomData, ptr::NonNull};
 
 /// A wrapper around a blk-mq [`struct request`]. This represents an IO request.
 ///
 /// # Implementation details
 ///
-/// There are four states for a request that the Rust bindings care about:
-///
-/// 1. Request is owned by block layer (refcount 0).
-/// 2. Request is owned by driver but with zero [`ARef`]s in existence
-///    (refcount 1).
-/// 3. Request is owned by driver with exactly one [`ARef`] in existence
-///    (refcount 2).
-/// 4. Request is owned by driver with more than one [`ARef`] in existence
-///    (refcount > 2).
+/// There are three states for a request that the Rust bindings care about:
 ///
+/// - 0: The request is owned by C block layer or is uniquely referenced (by [`Owned<_>`]).
+/// - 1: The request is owned by Rust abstractions but is not referenced.
+/// - 2+: There is one or more [`ARef`] instances referencing the request.
 ///
-/// We need to track 1 and 2 to ensure we fail tag to request conversions for
-/// requests that are not owned by the driver.
+/// We need to track 1 and 2 to make sure that `tag_to_rq` does not issue any
+/// [`ARef`] to requests not owned by the driver, or to requests that have a
+/// [`Owned`] referencing it.
 ///
-/// We need to track 3 and 4 to ensure that it is safe to end the request and hand
-/// back ownership to the block layer.
+/// We need to track 3 to know when it is safe to convert an [`ARef`] to a
+/// [`Owned`].
 ///
 /// Note that the driver can still obtain new `ARef` even if there is no `ARef`s in existence by
-/// using `tag_to_rq`, hence the need to distinguish B and C.
+/// using `tag_to_rq`, hence the need to distinct 1 and 2.
 ///
 /// The states are tracked through the private `refcount` field of
 /// `RequestDataWrapper`. This structure lives in the private data area of the C
@@ -66,6 +72,7 @@ impl<T: Operations> Request<T> {
     ///
     /// * The caller must own a refcount on `ptr` that is transferred to the
     ///   returned [`ARef`].
+    /// * The refcount must be >= 2.
     /// * The type invariants for [`Request`] must hold for the pointee of `ptr`.
     ///
     /// [`struct request`]: srctree/include/linux/blk-mq.h
@@ -76,72 +83,6 @@ pub(crate) unsafe fn aref_from_raw(ptr: *mut bindings::request) -> ARef<Self> {
         unsafe { ARef::from_raw(NonNull::new_unchecked(ptr.cast())) }
     }
 
-    /// Notify the block layer that a request is going to be processed now.
-    ///
-    /// The block layer uses this hook to do proper initializations such as
-    /// starting the timeout timer. It is a requirement that block device
-    /// drivers call this function when starting to process a request.
-    ///
-    /// # Safety
-    ///
-    /// The caller must have exclusive ownership of `self`, that is
-    /// `self.wrapper_ref().refcount() == 2`.
-    pub(crate) unsafe fn start_unchecked(this: &ARef<Self>) {
-        // SAFETY: By type invariant, `self.0` is a valid `struct request` and
-        // we have exclusive access.
-        unsafe { bindings::blk_mq_start_request(this.0.get()) };
-    }
-
-    /// Try to take exclusive ownership of `this` by dropping the refcount to 0.
-    /// This fails if `this` is not the only [`ARef`] pointing to the underlying
-    /// [`Request`].
-    ///
-    /// If the operation is successful, [`Ok`] is returned with a pointer to the
-    /// C [`struct request`]. If the operation fails, `this` is returned in the
-    /// [`Err`] variant.
-    ///
-    /// [`struct request`]: srctree/include/linux/blk-mq.h
-    fn try_set_end(this: ARef<Self>) -> Result<*mut bindings::request, ARef<Self>> {
-        // To hand back the ownership, we need the current refcount to be 2.
-        // Since we can race with `TagSet::tag_to_rq`, this needs to atomically reduce
-        // refcount to 0. `Refcount` does not provide a way to do this, so use the underlying
-        // atomics directly.
-        if let Err(_old) = this
-            .wrapper_ref()
-            .refcount()
-            .as_atomic()
-            .cmpxchg(2, 0, Relaxed)
-        {
-            return Err(this);
-        }
-
-        let request_ptr = this.0.get();
-        core::mem::forget(this);
-
-        Ok(request_ptr)
-    }
-
-    /// Notify the block layer that the request has been completed without errors.
-    ///
-    /// This function will return [`Err`] if `this` is not the only [`ARef`]
-    /// referencing the request.
-    pub fn end_ok(this: ARef<Self>) -> Result<(), ARef<Self>> {
-        let request_ptr = Self::try_set_end(this)?;
-
-        // SAFETY: By type invariant, `this.0` was a valid `struct request`. The
-        // success of the call to `try_set_end` guarantees that there are no
-        // `ARef`s pointing to this request. Therefore it is safe to hand it
-        // back to the block layer.
-        unsafe {
-            bindings::blk_mq_end_request(
-                request_ptr,
-                bindings::BLK_STS_OK as bindings::blk_status_t,
-            )
-        };
-
-        Ok(())
-    }
-
     /// Complete the request by scheduling `Operations::complete` for
     /// execution.
     ///
@@ -234,27 +175,125 @@ unsafe impl<T: Operations> Sync for Request<T> {}
 // matching reference count decrement is executed.
 unsafe impl<T: Operations> RefCounted for Request<T> {
     fn inc_ref(&self) {
-        self.wrapper_ref().refcount().inc();
+        let refcount = &self.wrapper_ref().refcount().as_atomic();
+
+        // Load acquire, store relaxed. We sync with store release of
+        // `OwnableRefCounted::into_shared`. After that all unique references are dead and we have
+        // shared access. We can use relaxed ordering for the store.
+        #[cfg_attr(not(debug_assertions), allow(unused_variables))]
+        let old = refcount.fetch_add(1, ordering::Acquire);
+
+        debug_assert!(old >= 1, "Request refcount zero clone");
     }
 
     unsafe fn dec_ref(obj: core::ptr::NonNull<Self>) {
-        // SAFETY: The type invariants of `ARef` guarantee that `obj` is valid
+        // SAFETY: The type invariants of `RefCounted` guarantee that `obj` is valid
         // for read.
         let wrapper_ptr = unsafe { Self::wrapper_ptr(obj.as_ptr()).as_ptr() };
         // SAFETY: The type invariant of `Request` guarantees that the private
         // data area is initialized and valid.
         let refcount = unsafe { &*RequestDataWrapper::refcount_ptr(wrapper_ptr) };
 
-        #[cfg_attr(not(CONFIG_DEBUG_MISC), allow(unused_variables))]
-        let is_zero = refcount.dec_and_test();
+        // Store release to sync with load acquire in
+        // `OwnableRefCounted::try_from_shared`.
+        #[cfg_attr(not(debug_assertions), allow(unused_variables))]
+        let old = refcount.as_atomic().fetch_sub(1, ordering::Release);
 
-        #[cfg(CONFIG_DEBUG_MISC)]
-        if is_zero {
-            panic!("Request reached refcount zero in Rust abstractions");
-        }
+        debug_assert!(
+            old > 1,
+            "Request reached refcount zero in Rust abstractions"
+        );
+    }
+}
+
+impl<T: Operations> Owned<Request<T>> {
+    /// Notify the block layer that a request is going to be processed now.
+    ///
+    /// The block layer uses this hook to do proper initializations such as
+    /// starting the timeout timer. It is a requirement that block device
+    /// drivers call this function when starting to process a request.
+    ///
+    /// # Safety
+    ///
+    /// The caller must have exclusive ownership of `self`, that is
+    /// `self.wrapper_ref().refcount() == 0`.
+    ///
+    /// This can only be called once in the request life cycle.
+    pub(crate) unsafe fn start_unchecked(&mut self) {
+        // SAFETY: By type invariant, `self.0` is a valid `struct request` and
+        // we have exclusive access.
+        unsafe { bindings::blk_mq_start_request(self.0.get()) };
+    }
+
+    /// Notify the block layer that the request has been completed without errors.
+    pub fn end_ok(self) {
+        let request_ptr = self.0.get().cast();
+        core::mem::forget(self);
+        // SAFETY: By type invariant, `this.0` was a valid `struct request`. The
+        // existence of `self` guarantees that there are no `ARef`s pointing to
+        // this request. Therefore it is safe to hand it back to the block
+        // layer.
+        unsafe { bindings::blk_mq_end_request(request_ptr, bindings::BLK_STS_OK) };
     }
 }
 
-// SAFETY: We currently do not implement `Ownable`, thus it is okay to obtain an `ARef<Request>`
-// from a `&Request` (but this will change in the future).
-unsafe impl<T: Operations> AlwaysRefCounted for Request<T> {}
+impl<T: Operations> Ownable for Request<T> {
+    // The `release` implementation frees the underlying request according to the reference
+    // counting scheme for `Request`.
+    unsafe fn release(&mut self) {
+        // SAFETY: The safety requirements of this function guarantee that `self`
+        // is valid for read.
+        let wrapper_ptr = unsafe { Self::wrapper_ptr(self).as_ptr() };
+        // SAFETY: The type invariant of `Request` guarantees that the private
+        // data area is initialized and valid.
+        let refcount = unsafe { &*RequestDataWrapper::refcount_ptr(wrapper_ptr) };
+
+        // Store release to sync with load acquire when converting back to owned.
+        #[cfg_attr(not(debug_assertions), allow(unused_variables))]
+        let old = refcount.as_atomic().fetch_add(1, ordering::Release);
+
+        debug_assert!(
+            old == 0,
+            "Invalid refcount when releasing `Owned<Request<T>>`"
+        );
+    }
+}
+
+impl<T: Operations> OwnableRefCounted for Request<T> {
+    fn try_from_shared(this: ARef<Self>) -> core::result::Result<Owned<Self>, ARef<Self>> {
+        // Load acquire to sync with decrement store release to make sure all
+        // shared access has ended.
+        let updated = this
+            .wrapper_ref()
+            .refcount()
+            .as_atomic()
+            .cmpxchg(2, 0, ordering::Acquire);
+
+        match updated {
+            Ok(_) => Ok(
+                // SAFETY: We achieved unique ownership above.
+                unsafe { Owned::from_raw(ARef::into_raw(this)) },
+            ),
+            Err(_) => Err(this),
+        }
+    }
+
+    fn into_shared(this: Owned<Self>) -> ARef<Self> {
+        // Store release to sync with future increments using load acquire to
+        // make sure exclusive access has ended before shared access start.
+        #[cfg_attr(not(debug_assertions), allow(unused_variables))]
+        let old = this
+            .wrapper_ref()
+            .refcount()
+            .as_atomic()
+            .fetch_add(2, ordering::Release);
+
+        debug_assert!(
+            old == 0,
+            "Invalid refcount when upgrading `Owned<Request<T>>`"
+        );
+
+        // SAFETY: We incremented the refcount above.
+        unsafe { ARef::from_raw(Owned::into_raw(this)) }
+    }
+}

-- 
2.51.2




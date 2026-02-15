Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6F79E63F2A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:17:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 498046B00B6; Sun, 15 Feb 2026 18:45:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 467E06B00D3; Sun, 15 Feb 2026 18:45:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 357B76B00D4; Sun, 15 Feb 2026 18:45:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 613146B00B6
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:45:30 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DABCA1B4F52
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:45:28 +0000 (UTC)
X-FDA: 84448325136.08.D2A3CF8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0770880002
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:45:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aLfTZApU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199127; a=rsa-sha256;
	cv=none;
	b=n9hl6+JvseAXLrP9I3VvuAzWivfKKyofxG8zREVux3Y8iSc2THT8atVD47kIwKtB8zvhQo
	slsRvmtrub2CDTjwfVwOLD96eK26VSLv7dqTG/aZVexKlMYHvc+/HAB1iidua2M+7l41bG
	bgBfUnTbzboeSNaUnLPUZr244kap1mw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aLfTZApU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ukf301PTniExoNJa/MYUeEA4OcAI6pTqEyWXbEJPwU=;
	b=Qs9Gu12B6eA18vDaST1Irc0I6VDVp55SnLQYsYYqPVR7ED4poqfja+6A849r0+9rbA95a4
	NDT+aN+YS6bM1KHP/LWg7sHjkrYeXEc/dJuzvtUGzXK9fpnT+G0cWY0fkChZ5764u7ACpj
	KvAUiPzAxR06twmX7rb1yGqSvO/snpE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3213941B3F;
	Sun, 15 Feb 2026 23:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7EDC4CEF7;
	Sun, 15 Feb 2026 23:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199126;
	bh=ItbNPma/0Fj+fEER3LzQBO101WvqRQL7byAlGzOg91g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=aLfTZApU4RCDv38xz/C3FJeWGS/5MFxpm94QlC5LnsiF5wjh3bsfW8EnpImz9W1ym
	 3uQ1dUM5152vHSoo89+z8dadHhf7DkNQTi9MDF1KCKYgfJ+vYSSGEB5JNJixHUiZgM
	 vZogYhr3wIOju46gr3UVu/97q4bE3+vwZ5LjysxN/Op0daUprhTg9OnmgT7Hh7vlca
	 I3worT09vUEWqBc4PCoc/H+vl+vFhYy41dnne9dCnvrxgMksAzF1OJqRrgR93OO0rd
	 6noWN2IfMUml5u08GO9fBbqnQRGOG3oaRoCuxJQd8WyEjNuy1mgZwDeFgSxd89RzYW
	 OZXUOEvSFjv3Q==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:34:52 +0100
Subject: [PATCH 05/79] block: rust: change `queue_rq` request type to
 `Owned`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-5-de9a7af4b469@kernel.org>
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
To: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
 Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 FUJITA Tomonori <fujita.tomonori@gmail.com>, 
 Frederic Weisbecker <frederic@kernel.org>, Lyude Paul <lyude@redhat.com>, 
 Thomas Gleixner <tglx@kernel.org>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: linux-block@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=18850;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=ItbNPma/0Fj+fEER3LzQBO101WvqRQL7byAlGzOg91g=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklgg61yucg5HYfS/fmA4cKT/mjPfS44FFkQTV
 DD6Qkde0dGJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYIAAKCRDhuBo+eShj
 d2ZWEADAEyUV2yhMxSfOurSomvof5QE0iaB8WCk61pomynEOh/dIKA7iq4Z0CUGHF1VXdHtb/KM
 Meql91hcHpAsyIu6nwdJLOlt24l2ZgIbuS84OyYLu4vlV056pQ9Dm+wUCuTfrkBjTD9wMVUxaU0
 e8tvy40UW7OxWPOFqng/7c/2ku1lX4e+RtQWJIVewkdniPIN739pj/TNcXtOi6hCIxDlAyOk9NQ
 auLiBOst2Xwa5RdGYa8W63Vh/xFqh+cDS0fYL2PGy5fCnIdy2FYeUw8H9egQ7c1Qxr8lN0lu6kO
 1APjc4q2IhsfQNFXyiav/YjEuia4XvoLK7VaTZbVdAvCbi5CiQ8PDFD7SJWwVV+XKcOoqAzC63I
 AnFC9Fsfygrr4iB1pLiEHsLSJkKsuXDymra4UxRZJF6lTV6SCWJgWNj882F5ZuvaktJd4LpgEkC
 4k5LSEkW8aqUc8Nbk+YjMR5k9U/9N9O+/aFUfq7DBWGH8WYU9bij5j27Cp9CKVlpSTGGMmtpK7l
 dubFrE4j7gbMq/AjjgWBdQtL++8dfkDiQhewIIq+b+ypWOCS9uTu7bybt41eqXUZp/o8JrSuTvn
 1hmcZjF5K4Bkvre7mCY3VZ+SF3paHezpVJu7ijl38W4TL6It3A90DTuAOtVw1Ytv9VmRaW4z9VG
 Vo94xF0yiC9ja1g==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0770880002
X-Stat-Signature: rgkjb487uckjxz5k8hchjk5piwzixhk6
X-HE-Tag: 1771199126-302402
X-HE-Meta: U2FsdGVkX1/bieEv2+qxPHlACxpQ6R2uX9h/0XIn/e7ch4/3yYNfSRa6BoHcEGsY990el8/5hNML7Mqq7R0+VLhaQDM7AyAZK0FC1ZyCBZd2A+JTr9lH/2bYB4XUYHJHpWNiEwaMN+FLKuAQuecWw5ft6JKLl0Maq9nxiQh6ZGuL1GnYib8lEr+Czu63U3VM73BkYcB5aL3vvwus+TzavS8MPiqdIsmtondkvlA1+WmaEDWjWAOas5jJ+rg+9iHuTbU2zPwTzkBS+72HAa+zjvTFUHbUcpMbuwAMKWtDS3MMRMp6V2k2qUVyjsTAEiXHoswNXZ942FoXqdSnsU5TrLP1cQVcQ9Rvmn+U334Kvk33oXIwMDFbKwlQcWkWM2l713zeipNpefPU8ku/fmvdkQGVFbVbB9D+C7slCVvHr03zAsGIP83fmwzPvr6Awh7oXwg8dtbky5mmE4rbWW1BbX8L2IZSLvE973RyjFX0m4TDyZPTSc6/p4m11rF+iu1ALQlvMFiKrKkrt+7gJq3jz0kCZJ0I16cjkag4Y4e8c2wFgRQzYCq8OhVQHVu6tuYZJoi3l5xIqGnh9X2zns3nDUucCBzGa6rXoH0Peu/1G26s61ujNLp2renSdfcoPtxizatYcRm5hefAZvUp92Rq2gHd7sL2vfzxR22Ai+C+3g4tYiJAM2C5B5/AB0/kqfABk3ve0/AWAcKHYroIURi8AKoKWjuvUK6ncAxqcwHf70ribNkh51AAutnx5sSHsl1AKUh0vIo+wA3lQHLuRsqZKqpbX7+ogkSylNhba8Tx5ybU7iKoJ3xUrrbHqLsoaia39aJKZm8IvpbDvyaHCVPG/ILFnDG24a0/Ffk6I/t6mfYWHGzxORQeQPEnc42Im71JkJYOsNS0chQRDiETlF6Oo4UBWlSogmKP57Yg7i4cjR9f5td2ie9vVFIWbkqkuyMmhVeHP1u5PCcSV1I9sxd
 ekbKB7xo
 jSHd2fw3mhVew8mXi0u9cPSOwLEIsoSkzT3PTXn00MdFSQ/D3s20BrGe2bsYAuyBUmafoYEapOxqYwBg/fpImT0fPdaENlqV+NSLz5ZvlYzgBPTkfe4/neoPZBcHKeGhpNxsGFrqgWj4ZqYiI0ES5en11U6bJn8FfbeVqifBawZRJS+SpXtMaAJTSBNBcj8d3QK9xV1thCdWQ4id7XLBg7Iczkeh36hvgfODvjLxkr/lYX1+bWo56/3t7S4qjQyrM5cY0zlhWgs0UORZjbWjSZ0upxr6fXXm8ey9yufkk3G7tGdBS5DDiLP75RKGI5Snh4+BW1aIw83krq5Xl5JTDizF926RnAMwHvbsDlxU6EdL/PLw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 rust/kernel/block/mq/operations.rs |  27 +++--
 rust/kernel/block/mq/request.rs    | 218 +++++++++++++++++++++----------------
 4 files changed, 158 insertions(+), 123 deletions(-)

diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index bd883a5061cab..6a7f660d31998 100644
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
 use pin_init::PinInit;
 
@@ -131,15 +136,10 @@ impl Operations for NullBlkDevice {
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
@@ -147,11 +147,9 @@ fn queue_rq(queue_data: &QueueData, rq: ARef<mq::Request<Self>>, _is_last: bool)
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
index 1fd0d54dd5493..b8ecd69abe980 100644
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
index b68c0208efc66..3dea79d647ff7 100644
--- a/rust/kernel/block/mq/operations.rs
+++ b/rust/kernel/block/mq/operations.rs
@@ -9,10 +9,10 @@
     block::mq::{request::RequestDataWrapper, Request},
     error::{from_result, Result},
     prelude::*,
-    sync::{aref::ARef, Refcount},
-    types::ForeignOwnable,
+    sync::{aref::ARef, atomic::ordering, Refcount},
+    types::{ForeignOwnable, Owned},
 };
-use core::marker::PhantomData;
+use core::{marker::PhantomData, ptr::NonNull};
 
 type ForeignBorrowed<'a, T> = <T as ForeignOwnable>::Borrowed<'a>;
 
@@ -36,7 +36,7 @@ pub trait Operations: Sized {
     /// `false`, the driver is allowed to defer committing the request.
     fn queue_rq(
         queue_data: ForeignBorrowed<'_, Self::QueueData>,
-        rq: ARef<Request<Self>>,
+        rq: Owned<Request<Self>>,
         is_last: bool,
     ) -> Result;
 
@@ -90,16 +90,23 @@ impl<T: Operations> OperationsVTable<T> {
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
@@ -111,7 +118,7 @@ impl<T: Operations> OperationsVTable<T> {
         let queue_data = unsafe { T::QueueData::borrow(queue_data) };
 
         // SAFETY: We have exclusive access and we just set the refcount above.
-        unsafe { Request::start_unchecked(&rq) };
+        unsafe { rq.start_unchecked() };
 
         let ret = T::queue_rq(
             queue_data,
diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index cf013b9e2cacf..148348b4ef245 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -7,13 +7,12 @@
 use crate::{
     bindings,
     block::mq::Operations,
-    error::Result,
     sync::{
-        aref::{ARef, AlwaysRefCounted, RefCounted},
-        atomic::Relaxed,
+        aref::{ARef, RefCounted},
+        atomic::ordering,
         Refcount,
     },
-    types::Opaque,
+    types::{Opaque, Ownable, OwnableRefCounted, Owned},
 };
 use core::{marker::PhantomData, ptr::NonNull};
 
@@ -21,25 +20,21 @@
 ///
 /// # Implementation details
 ///
-/// There are four states for a request that the Rust bindings care about:
+/// There are three states for a request that the Rust bindings care about:
 ///
-/// 1. Request is owned by block layer (refcount 0).
-/// 2. Request is owned by driver but with zero [`ARef`]s in existence
-///    (refcount 1).
-/// 3. Request is owned by driver with exactly one [`ARef`] in existence
-///    (refcount 2).
-/// 4. Request is owned by driver with more than one [`ARef`] in existence
-///    (refcount > 2).
+/// - 0: The request is owned by C block layer or is uniquely referenced (by [`Owned<_>`]).
+/// - 1: The request is owned by Rust abstractions but is not referenced.
+/// - 2+: There is one or more [`ARef`] instances referencing the request.
 ///
+/// We need to track 1 and 2 to make sure that `tag_to_rq` does not issue any
+/// [`ARef`] to requests not owned by the driver, or to requests that have a
+/// [`Owned`] referencing it.
 ///
-/// We need to track 1 and 2 to ensure we fail tag to request conversions for
-/// requests that are not owned by the driver.
-///
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
@@ -66,6 +61,7 @@ impl<T: Operations> Request<T> {
     ///
     /// * The caller must own a refcount on `ptr` that is transferred to the
     ///   returned [`ARef`].
+    /// * The refcount must be >= 2.
     /// * The type invariants for [`Request`] must hold for the pointee of `ptr`.
     ///
     /// [`struct request`]: srctree/include/linux/blk-mq.h
@@ -76,72 +72,6 @@ pub(crate) unsafe fn aref_from_raw(ptr: *mut bindings::request) -> ARef<Self> {
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
@@ -234,27 +164,125 @@ unsafe impl<T: Operations> Sync for Request<T> {}
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
+    }
+}
+
+// SAFETY: The `release` implementation frees the underlying request according to the reference
+// counting scheme for `Request`.
+unsafe impl<T: Operations> Ownable for Request<T> {
+    unsafe fn release(this: NonNull<Self>) {
+        // SAFETY: The safety requirements of this function guarantee that `this`
+        // is valid for read.
+        let wrapper_ptr = unsafe { Self::wrapper_ptr(this.as_ptr()).as_ptr() };
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
     }
 }
 
-// SAFETY: We currently do not implement `Ownable`, thus it is okay to obtain an `ARef<Request>`
-// from a `&Request` (but this will change in the future).
-unsafe impl<T: Operations> AlwaysRefCounted for Request<T> {}
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




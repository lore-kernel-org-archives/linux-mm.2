Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A9F2CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C5FA6B00D3; Tue,  9 Jun 2026 15:13:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09DA86B00D4; Tue,  9 Jun 2026 15:13:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF5E36B00D5; Tue,  9 Jun 2026 15:13:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD36E6B00D3
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:13:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A61729161A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:13:47 +0000 (UTC)
X-FDA: 84861323694.08.05BD10E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id C7CDD40005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:13:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AfnLzzTx;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XPdx1oCo+cDGKHpfIjN0PVTLlY+JG6MdSS1fHOHa1sM=;
	b=zAu9L7SMQIWUguvwx7J/UaFSdatTqXtGR50ILRKzypwPtx7yA66CBUM6jcv1i/nlUN4roH
	UrB3MIpfigMZcQIY3Q9V7Nt5ovb3iV84U6uAP+UYvd04udh39WehxeiFRqRZgr49y0G3SI
	hrmEy5/IBpD39E9rZCDJzRfMfMyilhY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032425;
	b=jewUK1NYiLd4HKkoh2Y+B5KYF4TF2s4mg5KdppAOzsuz3jzH4R6z7m8j2G7/ECpUIqLXZQ
	RoWAPNjrilL/6mCEITcqZHdVI48+270AT2kN5S3FCy/F9Yw54RAfO29TaywJ+J7D+uAw0F
	GZBHFrLmq1prxDFR0lkKEuavhbjBaDY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AfnLzzTx;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2744A42D65;
	Tue,  9 Jun 2026 19:13:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E3A1F00893;
	Tue,  9 Jun 2026 19:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032425;
	bh=XPdx1oCo+cDGKHpfIjN0PVTLlY+JG6MdSS1fHOHa1sM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AfnLzzTxPZjO9ehKPb9b2SbLpNUEFeuH3N5AStrAtc1iU7GQOokbmWJ0vrkEep7me
	 LYGxii8ZJ1Lweycf+53XWBXkQT4k/aN1MjrknxAdDKgx1zDZfW+Ogg4XyOgy11UwHp
	 uEzRtPDDHT+hjlz+GCUjrAE9d4qnc8G1pgLrgXeb2f1p6ZZuJT22q5ISlmqFLe4TGv
	 Mf1Dxv0FEx96l56ZNL9N9o+rMsa7uf9L2sWaWrK/2P6N1PKnbZ8l/9/r4qglqLBJ+G
	 aPyiTFjSGKLYnBoSMjZwdUHOo/7pANnZ7IJMwayibLplmz+zpKji9NvtoV4xOd+5nt
	 RvpDS3daO9tjA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:07:49 +0200
Subject: [PATCH v2 10/83] block: rust: allow `hrtimer::Timer` in
 `RequestData`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-10-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8262; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=MxU/avvgu0ObO+hSiIzPv5Gh1hPwXbxknG4ZgL5JR2I=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGS9QazYsxgfYMLVHCHgKKVjzrf3FJbLdn8ww
 +/TN93edpaJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihkvQAKCRD6UCkIqsW9
 0FJGD/97Fixr3jGIlPgmEP6cWYHvaI4ONk7ITRFh7/tfq5iF7O4OiQV58e9R+Br+J80W8kv8t72
 a9tF07TjgAHAz5j2CtgAghAX2Dog0PE2Y9kPETYarm8PqqG56T43ctr0Z3icnQUGTx8v9OAPJFY
 HezJ/hX7TrE7h/AZlpX02lgY4DAXCpXkqbmoKvTubJRoau5weN4ESUs0OwmZ9hk2fnCgZab8FDN
 eOASHKr+srZAMT8DQM7RU1cfj1UlwYE6smitL195w03eRdDC16SM4O/AbUgEJ+hRq7R2Rq5Fk4D
 DMlI5L9fow6PzL0kU/7IdYYZiF85VPgTqdHwEsRjmYVDlGT1SfgAxlmvsuJdheqAFU0UojAdiAs
 hofFoQj18th6a//f9AtAZMupTeMIF7pM0rGb5LGqyG4A8f94XgtCA0tTNbeJziyQJLR7KcCmQiw
 /fgLN/DbRyt0lojLLFTZMDqGdAi3y8VdlvVxY2txEXn+eL/4n1nVIXQ4F/X5wsAdHdM3yLWS6ri
 NAF6l8ns0rcGkHdC1xNkIwVR6FeAjV661vXf9xEyStqI3OOygyGV6GYCZeA2G3EvlpMMyjLt6wt
 gzFUzDE2E8DVZdZddM9+dzNCXN28y51+7uIjXQF6iJ6O7NMjYY2GbJVl62xBqcCfbDdnxmcmn0E
 CWQNJg/g0Pwbo6w==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: C7CDD40005
X-Rspam-User: 
X-Stat-Signature: janw95bnktpr8o6npxxeyi4mujgxemju
X-Rspamd-Server: rspam08
X-HE-Tag: 1781032425-717906
X-HE-Meta: U2FsdGVkX18BrBNKPJB7uUTYDLnNKQxb1IgVPzySOQlqqZE06oku8lgLOewYfixZGNxgKcQl02z5M3J3nnCLIxmrHCezX4Y90y0OWAQUE+i3nrd23EJU596h+bSpun1YX8fBo+4Z6WPlJ8jhMm9U1kD2nEuTwVJcDY+rBjDzzRp6vGd1puRLDdMw3Wy46IHDFbrUooFTRHZoXHdgM3nnbj+7A6RgpE62eJYCGXPN+jEJ4XUFPM5L6WEJoq+NmO7gv74S3z2l4uDOo+I0VErt/hW55l3ZAOgjehO5DyCu3VspPD9Y31vjWBglGSCvF0mBOGoo3r+bMsKLsbtA+Ln5zoycPuDmdFGXvq4VKFo7kzjZ0rogtogof/1YKdFCMR4pKiDWnaqpaAn9UuCv10MnXKBhRpB4S6ckMEcpfPHtlsdBT517IWYTa7a/S5n7iQHww6gAYlqWANN1KIb4RpoUpYzUWZVO9e1gXdtK2+9t0VEuMy3r3UdrEKLDbczrhSpAPo/jYfQz6p7DgK1wmXwpmYbP1qbQ4WImx81241Uld7DayJA3/rAGrva+HQ63Kf4D0azKzA6NXVmU33J1BVU2thCNqa+pQqq/lu5Mt5WP5enJGC9t8gDzihzJEn+Yy+AzidslYetSSHX9sMEsAgsPvYvJkU1D+tK7IlBfLC1vBQjl+Qlx9nYXN2quzLQ4LJQuWZdwLkCUOMbkxaDIXdxtSLlbFRj7YxLr9nIX4Agjtt3acvECZfmXBil8eAiBTIjmGD0QdqH71cxO9RpYKu1BiiT+48RQYs6LQoWZLnRYmze5QC9tbbWO98KnlEOTii82YHiACMAkOUAgt8zTCuUDl1GDP+j2P0F2StHIRBtV98x+qUiZrCIpMh+9EVKebdr8OO1xgLptoOm0Ap1YJ8BS6/Xa0/6J/IWh5zkLy7PyW1PLI2ayVArtjREz9Ydl5l2JloMwz7CgCVQ3XYWLEa7
 LNFy9qGo
 3FERIG46+7TuhZwgYZ99veBIhrw6izNzZHGpWZ6tjDYBchZiIFP60P4+TxjyAaq34mHFJd/l5SF1W9logojG1E47W+APzMU/ttznL3hePflgMFv0PanFOyXqW9h90DbeKYSrmmox/ymed/dT+rdVbc2lL6IGOFAx1yvr+1BAQOubRcp8Z4pDl7I7Q9gy/B2k8AJuo92AjA0+hKo6zbIn5mWEhEC4f6hVyKbogne0stlwZ4NE6LQve6fcAax0ftWZanuypMJFhWLUmzx43QIZpx4eXTRL5dqbILfmvPYYUWrTJf+0HtedLgoggtphHCLd//l0c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

`Request` is essentially a smart pointer that derefs to
`Operations::RequestData`. To use an `HrTimer` in `Operations::RequestData`
via the `Request` pointer, we must implement `HrTimerPointer` for
`Request`.

Thus, implement `HrTimerPointer` and friends for `ARef<Request>`.

Publicly export `HrTimer::raw_cancel` and `HrTimer::into_c`.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq.rs         |   5 +-
 rust/kernel/block/mq/request.rs | 142 ++++++++++++++++++++++++++++++++++++++++
 rust/kernel/time/hrtimer.rs     |   5 +-
 3 files changed, 149 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
index 7718b106eb49..a03d46d274a5 100644
--- a/rust/kernel/block/mq.rs
+++ b/rust/kernel/block/mq.rs
@@ -107,5 +107,8 @@
 mod tag_set;
 
 pub use operations::Operations;
-pub use request::Request;
+pub use request::{
+    Request,
+    RequestTimerHandle, //
+};
 pub use tag_set::TagSet;
diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index a6e757d8755d..0b14f584c9d9 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -15,6 +15,14 @@
         atomic::ordering,
         Refcount,
     },
+    time::hrtimer::{
+        HasHrTimer,
+        HrTimer,
+        HrTimerCallback,
+        HrTimerHandle,
+        HrTimerMode,
+        HrTimerPointer, //
+    },
     types::{
         Opaque,
         Ownable,
@@ -23,6 +31,7 @@
     },
 };
 use core::{
+    ffi::c_void,
     marker::PhantomData,
     ptr::NonNull, //
 };
@@ -145,6 +154,11 @@ pub(crate) fn wrapper_ref(&self) -> &RequestDataWrapper<T> {
         // valid as a shared reference.
         unsafe { Self::wrapper_ptr(core::ptr::from_ref(self).cast_mut()).as_ref() }
     }
+
+    /// Return a reference to the per-request data associated with this request.
+    pub fn data_ref(&self) -> &T::RequestData {
+        &self.wrapper_ref().data
+    }
 }
 
 /// A wrapper around data stored in the private area of the C [`struct request`].
@@ -329,3 +343,131 @@ fn into_shared(this: Owned<Self>) -> ARef<Self> {
         unsafe { ARef::from_raw(Owned::into_raw(this)) }
     }
 }
+
+/// A handle for a timer that is embedded in a [`Request`] private data area.
+pub struct RequestTimerHandle<T>
+where
+    T: Operations,
+    T::RequestData: HasHrTimer<T::RequestData>,
+{
+    inner: ARef<Request<T>>,
+}
+
+// SAFETY: The drop implementation of `RequestTimerHandle` calls `cancel`, which cancels the timer
+// if it is running. `drop` will block if the timer handler is running. This is ensured via a call
+// to `HrTimer::raw_cancel` in the implementation of `cancel`.
+unsafe impl<T> HrTimerHandle for RequestTimerHandle<T>
+where
+    T: Operations,
+    T::RequestData: HasHrTimer<T::RequestData>,
+{
+    fn cancel(&mut self) -> bool {
+        let request_data_ptr = &self.inner.wrapper_ref().data as *const T::RequestData;
+
+        // SAFETY: As we obtained `self_ptr` from a valid reference above, it
+        // must point to a valid `U`.
+        let timer_ptr = unsafe {
+            <T::RequestData as HasHrTimer<T::RequestData>>::raw_get_timer(request_data_ptr)
+        };
+
+        // SAFETY: As `timer_ptr` points into `U` and `U` is valid, `timer_ptr`
+        // must point to a valid `HrTimer` instance.
+        unsafe { HrTimer::<T::RequestData>::raw_cancel(timer_ptr) }
+    }
+}
+
+impl<T> RequestTimerHandle<T>
+where
+    T: Operations,
+    T::RequestData: HasHrTimer<T::RequestData>,
+{
+    /// Drop the timer handle without cancelling the timer.
+    ///
+    /// This is safe because dropping the last [`ARef<Request>`] does not drop the [`Request`].
+    pub fn dismiss(mut self) {
+        let inner = core::ptr::from_mut(&mut self.inner);
+
+        // SAFETY: `inner` is valid for reads and writes, is properly aligned and nonnull. We have
+        // exclusive access to `inner` and we do not access `inner` after this call.
+        unsafe { core::ptr::drop_in_place(inner) };
+        core::mem::forget(self);
+    }
+}
+
+impl<T> Drop for RequestTimerHandle<T>
+where
+    T: Operations,
+    T::RequestData: HasHrTimer<T::RequestData>,
+{
+    fn drop(&mut self) {
+        self.cancel();
+    }
+}
+
+impl<T> HrTimerPointer for ARef<Request<T>>
+where
+    T: Operations,
+    T::RequestData: HasHrTimer<T::RequestData>,
+    T::RequestData: Sync,
+{
+    type TimerMode = <T::RequestData as HasHrTimer<T::RequestData>>::TimerMode;
+    type TimerHandle = RequestTimerHandle<T>;
+
+    fn start(self, expires: <Self::TimerMode as HrTimerMode>::Expires) -> RequestTimerHandle<T> {
+        let pdu_ptr = self.data_ref() as *const T::RequestData;
+
+        // SAFETY: `pdu_pointer` is coerced from a live reference to a `T` and this points to a
+        // valid `T`. The reference is valid until `T` is dropped, and the timer will be canceled
+        // before this.
+        unsafe { T::RequestData::start(pdu_ptr, expires) };
+
+        RequestTimerHandle { inner: self }
+    }
+}
+
+impl<T> kernel::time::hrtimer::RawHrTimerCallback for ARef<Request<T>>
+where
+    T: Operations,
+    T::RequestData: HasHrTimer<T::RequestData>,
+    T::RequestData: for<'a> HrTimerCallback<Pointer<'a> = ARef<Request<T>>>,
+    T::RequestData: Sync,
+{
+    type CallbackTarget<'a> = Self;
+
+    unsafe extern "C" fn run(ptr: *mut bindings::hrtimer) -> bindings::hrtimer_restart {
+        // `HrTimer` is `repr(transparent)`
+        let timer_ptr = ptr.cast::<kernel::time::hrtimer::HrTimer<T::RequestData>>();
+
+        // SAFETY: By C API contract `ptr` is the pointer we passed when
+        // enqueuing the timer, so it is a `HrTimer<T::RequestData>` embedded in a `T::RequestData`
+        let request_data_ptr = unsafe { T::RequestData::timer_container_of(timer_ptr) };
+
+        let offset = core::mem::offset_of!(RequestDataWrapper<T>, data);
+
+        // SAFETY: This sub stays within the `bindings::request` allocation and does not wrap.
+        let pdu_ptr = unsafe {
+            request_data_ptr
+                .cast::<u8>()
+                .sub(offset)
+                .cast::<RequestDataWrapper<T>>()
+        };
+
+        // SAFETY: This request pointer was passed to us by the kernel in `init_request_callback`.
+        let request_ptr = unsafe { bindings::blk_mq_rq_from_pdu(pdu_ptr.cast::<c_void>()) };
+
+        // SAFETY: By C API contract, we have ownership of the request.
+        let request_ref = unsafe { &*(request_ptr as *const Request<T>) };
+
+        request_ref.inc_ref();
+        // SAFETY: We just incremented the refcount above.
+        let aref: ARef<Request<T>> = unsafe { ARef::from_raw(NonNull::from(request_ref)) };
+
+        // SAFETY:
+        // - By C API contract `timer_ptr` is the pointer that we passed when queuing the timer, so
+        //   it is a valid pointer to a `HrTimer<T>` embedded in a `T`.
+        // - We are within `RawHrTimerCallback::run`
+        let context = unsafe { kernel::time::hrtimer::HrTimerCallbackContext::from_raw(timer_ptr) };
+
+        T::RequestData::run(aref, context).into_c()
+    }
+}
diff --git a/rust/kernel/time/hrtimer.rs b/rust/kernel/time/hrtimer.rs
index d57276496ed6..096b18523c73 100644
--- a/rust/kernel/time/hrtimer.rs
+++ b/rust/kernel/time/hrtimer.rs
@@ -496,7 +496,7 @@ unsafe fn raw_get(this: *const Self) -> *mut bindings::hrtimer {
     /// # Safety
     ///
     /// `this` must point to a valid `Self`.
-    pub(crate) unsafe fn raw_cancel(this: *const Self) -> bool {
+    pub unsafe fn raw_cancel(this: *const Self) -> bool {
         // SAFETY: `this` points to an allocation of at least `HrTimer` size.
         let c_timer_ptr = unsafe { HrTimer::raw_get(this) };
 
@@ -900,7 +900,8 @@ pub enum HrTimerRestart {
 }
 
 impl HrTimerRestart {
-    fn into_c(self) -> bindings::hrtimer_restart {
+    /// Convert `self` into an integer for FFI use.
+    pub fn into_c(self) -> bindings::hrtimer_restart {
         self as bindings::hrtimer_restart
     }
 }

-- 
2.51.2




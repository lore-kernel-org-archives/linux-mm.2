Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF5D7CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:13:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50B2F6B00CC; Tue,  9 Jun 2026 15:13:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E2D26B00CE; Tue,  9 Jun 2026 15:13:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F9326B00CF; Tue,  9 Jun 2026 15:13:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E5DD6B00CC
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:13:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DBE61C221B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:13:12 +0000 (UTC)
X-FDA: 84861322224.25.28D3DD5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id F1D77140008
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:13:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QtO4XsWE;
	spf=pass (imf23.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dn/nL+HhqyPcXgr06oBLyldQr9p2+VExm2qADQKL/c4=;
	b=yfX1//SENIxiPugVZZXoNg0/V8sZn7BNEmMQbPRp2oSBkfdNdarxOumf7KbfA0DdB6Ac1f
	MEscrbqveEkS2hgyeapGCrwRiMSUKfdfEqHXv0LKplql52DXR1dAQUhQqHUya9jgVy0H0J
	C+KBn3M9lBkZhmeqv0ssVMfbPw3ZbRs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QtO4XsWE;
	spf=pass (imf23.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032391;
	b=3y1rVbuLNwzZEszjaEy9ca+VU9DL3bNcc7GgwxcBI0VSSX4jtTYbkF4LqexcID11QHvdyO
	g44jsspsqEtpx8djh9uIOiFwrayK0sxzbe5/iymEDe+LChsERhrMM33Rn3RYjhK9I8l0xz
	6X4fj5Fm88UT9cb6ib3YaRVrDIJDrZc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 45EF641969;
	Tue,  9 Jun 2026 19:13:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD981F00893;
	Tue,  9 Jun 2026 19:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032390;
	bh=dn/nL+HhqyPcXgr06oBLyldQr9p2+VExm2qADQKL/c4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QtO4XsWENZS24EnRtrb4kQ3MF43G5qGXqVTqEsOStmos6LyIm8rXYbjg3lMFCJUOU
	 ihtIQzB+NNni2RjRBE1Qfv/ob2U1TIWZPG8WOCFxX2DrSlzCwKd35Ca4aL7tuxREix
	 Y+b6m4mcolq3oWycMqsbHU6eHuuCBsLhNNHpoCHSnk4Pj+P4cjU1PF5GdJTD3uczsZ
	 lOBfFiuPyeTvOzqyqQUVZ0uSqO4pG6J06+G+Y70cH5//tRpiUDayhFDW7y9l4Ixip0
	 hT3WsVKSf45F6NNBgyaqg8pu3E9WQ1dSduQQ4e4y7o2vdbPF3dhdme52QfBBuiMu3+
	 XU1QjPGs0022w==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:48 +0200
Subject: [PATCH v2 69/83] block: rust: add `queue_rqs` vtable hook
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-69-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5877; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=lKoE7hlYKrSKMR83Axydp/oZ8JxoEi389NiL+WfBOgg=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTz/hgE7XP0crSwcvBFBVmKr+7qEbSg5PbSp
 rkcv2WYM66JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk8wAKCRD6UCkIqsW9
 0B3mEACAadrp+g4DQkLAhdcEFJwFR75ItPB0hUabotPIhZK5V5Q5SvRq/T5bCACBqPPZNgOqfr1
 OhGSpXn865qPZ9ouSWUKid24gGCK2utocnxXKRHVVZRFGeODLCTrEd3NEO65tqy7Zdk6D26k8LW
 ssZ90yNJr6SfKJMu40r+lJB2EoGK8BpbP4GXxDgXT8X4/v/j7r4sbTioXpSlUjAaGiOghB+tv1A
 hy7jbRN0LrnJoL8IXRDQJVFaphqnlHbLp0y1naclIJC03+TTX/rutvScSOwmrsqs2um/YyWzlyh
 mwXnGv/uFB6wkAZ4ay2oIveL/WvYqGeaPmP3t896vdNch1iR4MeQRvu80BqffDTkHkDOgmlGuWA
 IF+aa+mGIR0ISuGBothqKGPTXPzBHDNXEljaorTHRLUtwDaUBUayTOjgZwPKxrpZ9mf83b57UCv
 orrVTck6xR9WbwJhGP3vEYWPsaUqPC6nR2XKnxJ8vIqQfoze5AGWccN36OwGk6ZcdOIYgnAg2d1
 pXxuMJvSmgonvpmN4xHw+HfdozFeUOWdVCjTY0keLijweNbKgC4HJvRA4WYpOxST3TxQvbRnwCD
 ypWTlnSYyEJ3Sfskk/teOGnrZ36Qd2jrpgncwNWShm4cuFdWoL5OR/zvJfd66LgDMBiSFRuofXW
 KCDInu/jCoWWJYw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F1D77140008
X-Stat-Signature: xnr1kmra7jpnys1hhhg5feauth4jmgfm
X-Rspam-User: 
X-HE-Tag: 1781032390-943938
X-HE-Meta: U2FsdGVkX1+F/N58OC2yQ6b26bLGNNF1DI+K1lxbNR3nMQN+M1TfvRfcLaXt0XXi7xAeE6jAfZWno8hjGLmXBkUKx60BoPbRIlsvxPLk03mg3IO6SSdsMYB2NTS2XeRPywCKj6zj/2uHtMMx+x1SdyyMpA/Vx2K7O5BN5k4tIKC/CbVq6GWq5rn9GWG29F8At6ol4MvH9Zd68YNi0WxvPSkTQKNdRxmjQiXHfPM3c5kTYimMd/X4tkogHpZ3ULGdX3NeLcVQcfHqjizHp1JDfmL+GIb+Ta53lHNkqzg6BZUZTSOv3eA8IIxojo6L/xe2yFYhQrGvxhh+hAETN7CZTdmTTq+bol9NGHXi8vjimMtxjl906W0FSbwNvmx/LjhYOD4GVZ/WrREpVKur9aKiACtGXwRmK8cQZ7mc80Lw+6j5FXam3F3BsHwHnoYGxTQ26m6Ls0joyOiSDaiJPQLtOc881ibkihMFwUVqzHEz6bnwcnOrGMt2aihg3WVU6PMFVj1RmH/wL+kEkvKsqu+IoxbXFWsT+pVw3nqGkKZSCsaL1vVuQyz5bg07UiuAMEkJFe+OxrcNf3e4uq+/38Z4YfnQakszb/qzXRHG2E4jMe6SYd+Jrne44Y4kCYOemxa0Q/LSOb1UgL3iZUqzGn8y1werVSZ4viy17J5uEMSBarLPhJ5RHCdXWug+0RAj44ODV4HZUeyybJgBza/YkmffWT4TAhivpD3ZuvBHnQQUWVg8x2l/Y6GdLS1e5aZQXElpRNRYi8m6fcLkjzhme//9ObK9PNErDn/UA+bTot1hneCWjtboJkJlkFvMXxYcEs5s/hdHMGvA0WEZfB3PEQUKUkj2fpfBHvsocWKEeSz8a/0okd4/R7fnElVeG/novUYx39JGWf8YRSkaQWvIWk6ojjXOVrhEoC0ouBb4H590EsUWfwJ6NpPoM6BmVB/yU1ixjcxaL02oq5kZJHy1Bc9
 83lHsi4w
 kMW0Uiurpwrdv4KW4jGjLG718YVajcXzxVbB985cPN2o9CNgYhZgwiqcEGPa1ElYP50EGrl3vuGUXlKLY3e9XSts4oD9i4/IQTCAN/mufDFvwbv3/z8MauVrDYn69hMxb8i5VC/7vpDN0nyjt6Svr7IBmv2wZopLxzi13K2wmQ5ZcjbPtDznmXLFfqMpGoFTHNXygN+GHiDG7ihGKUqcHfVkpuf/tTLmhpVfnI/ou/AmLms8bZOqom7p8uklDahnbl832s/7reKRa3hP1AeNo/wQUrH5TMlzOrXRMiI8J53axQqWmaxRlVEae81F4KS2K936yDlZJEtCwc5ey1Ovr0sTkKHfzb2RJuOxtdmhqZRjXhPnWRkOZO08ONn5fCwosN2i4B3S5GrMmGw5fvKKcaTQAQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for the `queue_rqs` callback to the Rust block layer
bindings. This callback allows drivers to receive multiple requests in
a single call, enabling batch processing optimizations.

The callback receives a `RequestList` containing the requests to be
processed. Drivers should remove successfully processed requests from
the list; any remaining requests will be requeued individually.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/operations.rs | 61 +++++++++++++++++++++++++++++++++++++-
 rust/kernel/block/mq/request.rs    | 26 ++++++++++++++++
 2 files changed, 86 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/block/mq/operations.rs b/rust/kernel/block/mq/operations.rs
index 1be4695ca944..505e7d2b2253 100644
--- a/rust/kernel/block/mq/operations.rs
+++ b/rust/kernel/block/mq/operations.rs
@@ -38,6 +38,8 @@
 };
 use pin_init::PinInit;
 
+use super::request_list::RequestList;
+
 type ForeignBorrowed<'a, T> = <T as ForeignOwnable>::Borrowed<'a>;
 
 /// Implement this trait to interface blk-mq as block devices.
@@ -94,6 +96,15 @@ fn queue_rq(
         is_poll: bool,
     ) -> BlkResult;
 
+    /// Called by the kernel to queue a list of requests with the driver.
+    fn queue_rqs(
+        _hw_data: ForeignBorrowed<'_, Self::HwData>,
+        _queue_data: ForeignBorrowed<'_, Self::QueueData>,
+        _requests: &mut RequestList<Self>,
+    ) {
+        build_error!(crate::error::VTABLE_DEFAULT_ERROR)
+    }
+
     /// Called by the kernel to indicate that queued requests should be submitted.
     fn commit_rqs(
         hw_data: ForeignBorrowed<'_, Self::HwData>,
@@ -234,6 +245,50 @@ impl<T: Operations> OperationsVTable<T> {
         }
     }
 
+    /// This function is called by the C kernel to queue a list of new requests.
+    ///
+    /// Driver is guaranteed that each request belongs to the same queue. If the
+    /// driver doesn't empty the `rqlist` completely, then the rest will be
+    /// queued individually by the block layer upon return.
+    ///
+    /// # SAFETY
+    ///
+    /// - `requests` must satisfy the safety requirements of `RequestList<T>`
+    /// - All requests in `requests` must belong to the same hardware context.
+    unsafe extern "C" fn queue_rqs_callback(requests: *mut bindings::rq_list) {
+        // SAFETY:
+        // - By the safety requirements of this function, `requests` is valid for use as a
+        // `RequestList`.
+        // - We have exclusive access to `requests` for the duration of this function.
+        let requests = unsafe { RequestList::from_raw(requests) };
+
+        let rq_ptr = requests.peek_raw();
+
+        if rq_ptr.is_null() {
+            return;
+        }
+
+        // SAFETY: By function safety requirements, rq_ptr is pointing to a
+        // valid request.
+        let hctx = unsafe { (*rq_ptr).mq_hctx };
+
+        // SAFETY: The safety requirement for this function ensure that `hctx`
+        // is valid and that `driver_data` was produced by a call to
+        // `into_foreign` in `Self::init_hctx_callback`.
+        let hw_data = unsafe { T::HwData::borrow((*hctx).driver_data) };
+
+        // SAFETY: `hctx` is valid as required by this function.
+        let queue_data = unsafe { (*(*hctx).queue).queuedata };
+
+        // SAFETY: `queue.queuedata` was created by `GenDiskBuilder::build` with
+        // a call to `ForeignOwnable::into_foreign` to create `queuedata`.
+        // `ForeignOwnable::from_foreign` is only called when the tagset is
+        // dropped, which happens after we are dropped.
+        let queue_data = unsafe { T::QueueData::borrow(queue_data) };
+
+        T::queue_rqs(hw_data, queue_data, requests);
+    }
+
     /// This function is called by the C kernel. A pointer to this function is
     /// installed in the `blk_mq_ops` vtable for the driver.
     ///
@@ -475,7 +530,11 @@ impl<T: Operations> OperationsVTable<T> {
 
     const VTABLE: bindings::blk_mq_ops = bindings::blk_mq_ops {
         queue_rq: Some(Self::queue_rq_callback),
-        queue_rqs: None,
+        queue_rqs: if T::HAS_QUEUE_RQS {
+            Some(Self::queue_rqs_callback)
+        } else {
+            None
+        },
         commit_rqs: Some(Self::commit_rqs_callback),
         get_budget: None,
         put_budget: None,
diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index 84f8b2c17f85..9c451583e75d 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -173,6 +173,32 @@ pub fn queue(&self) -> &RequestQueue<T> {
     pub fn as_raw(&self) -> *mut bindings::request {
         self.0.get()
     }
+
+    // Return a valid hctx pointer.
+    fn hctx_raw(&self) -> *mut bindings::blk_mq_hw_ctx {
+        // SAFETY: The requests is guaranteed to be associated with a hardware
+        // context while we have access to it.
+        unsafe { (*self.0.get()).mq_hctx }
+    }
+
+    /// Get a reference to the [`T::HwData`] for the hardware context that this
+    /// request is associated with.
+    pub fn hw_data(&self) -> <T::HwData as ForeignOwnable>::Borrowed<'_> {
+        let hctx = self.hctx_raw();
+
+        // SAFETY: `hctx` is valid and `driver_data` was produced by a call to
+        // `into_foreign` in `Operations::init_hctx_callback`.
+        unsafe { T::HwData::borrow((*hctx).driver_data) }
+    }
+
+    pub fn is_poll(&self) -> bool {
+        let hctx = self.hctx_raw();
+
+        u32::from(
+            // SAFETY: `hctx_raw` returns a valid pointer.
+            unsafe { (*hctx).type_ },
+        ) == bindings::hctx_type_HCTX_TYPE_POLL
+    }
 }
 
 /// A wrapper around a blk-mq [`struct request`]. This represents an IO request.

-- 
2.51.2




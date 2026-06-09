Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15714CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:15:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6951B6B00FF; Tue,  9 Jun 2026 15:15:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66C916B0101; Tue,  9 Jun 2026 15:15:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55C236B0102; Tue,  9 Jun 2026 15:15:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 456316B00FF
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:15:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 09C1040752
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:15:41 +0000 (UTC)
X-FDA: 84861328482.13.C57643C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id BEEBA180009
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:15:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XCNyr4Ju;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DQaitxpNA51/3rHHdgAAaeOKOYDYafiFasueOGXY3OQ=;
	b=1IzoyjkgrCC5SankOwu56Zmudlk4PlubU4TII6YYLmeo/IYdSCH5mDLjGti4lMpy6rQPnv
	hQIv4P13FDjHO3cHoZNnkigPOTp3Aix8QLbmECFx67o3g372zvDRHKBCJijnR7mEqWnsZq
	XqGfCKzC2uT25PLnx5knUxZ+tVUK13Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XCNyr4Ju;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032538;
	b=dt2eHQFEoryzCAorLVPOZgN3wizuIDOk9WFN1+mjsEuROjPTHwTvjfJHKt/vHadUxF42kd
	3kNBnfjra1tv5jBgQyzssXfM6iCOiRn0JtO7nJTDgfiF/HdEoQLphwqHyxADnMVS5h9wRn
	tH7i+wd6MR/YZG5ldXxrlQ56bL9w7cM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ED5D3402AD;
	Tue,  9 Jun 2026 19:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A811F00898;
	Tue,  9 Jun 2026 19:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032537;
	bh=DQaitxpNA51/3rHHdgAAaeOKOYDYafiFasueOGXY3OQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XCNyr4JurIsv41OBXAtAuO/k84pBtoNQEWQ5PF3mC/KuhrTmfNh5K1S/BqKvioNbC
	 3h/BKwqGFI7MVQWDF3UzHSS7cP83EsnGqPHLzg3uulZr8lkLuF3OJXqPgyQIH29etr
	 V3Ii4X5e6Q/l1xyPtDiIkSTWSAzFDX9Tbs8NEEiy2YwiYfH2QzHaQGJPJE5SXAdfvJ
	 lnuZ03AeL8IJyt2sTbfiWzB6vXEal4kxHh40iqhNrd63JQuUlMGQw/GpVSuoBtvq86
	 oRzljUW8hmoqECP1aptnMXf35hEaFnUJff4mwCOWJU5iIbzAh68yjaymwv0ZMun4Of
	 UkT9UXb/qIieA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:52 +0200
Subject: [PATCH v2 73/83] block: rust: add `TagSet::tag_to_rq`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-73-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4610; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=4OiBFQGmKFx0gHrsLZFCxFqfXlZh7LnoMq7hJUvpKfY=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGT2zkh/Q8CgSEFyUkKpGV9RCrunuLVdbVgq9
 vD6EgNAjT2JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk9gAKCRD6UCkIqsW9
 0HP4D/wOTaFywqxSb/E8W41kcuSGxbImFnwDDJAFeKlSlQ5jetbEzO3M98Gk6NOpFL8zha+hBPd
 5wuvIgS4Gknn6JxldU/yvZl2RUKkZrG15tNNEezVsvzVz2ZmmFQ5JWs+RE+bQ1D6ZtMY7q5kbE9
 kMIJSK2g7DTFR1kdC1Q1xJ517sy+wq12RlrhepNpA2x8rYLwTsLpIWS1Rxdw0bYH9u6xwSYiWG+
 qE7CvRB1Z1RylJ1aSURv5iyltcrpqdsRQ7D5s1dVmWENhW/6EodN4WAqkVw9xJpKz3qfHS6v2ec
 ePTDI3X5aFW+k6HWR1JB7B+D8DaBAUOeqz0pmsU1PBrd8S3QH8+qugx8HU0464yvCnGzruf/STC
 kuXPhBvxMkT5Wf/X9h0yXeskbKt9gRQBAv3hb7Zfal7kDsdRPh9fQ3M3jT9xdmz0F3JckxEeF2O
 UV1oI3XcxgWOcGFHWRSHNHITtVjSx9SDDJPiNsSzYdcSZFLZoIJzwxQZXfb5A6Fwr4vQ9d2606X
 da6Cj6Q0DolEIA2oaxmwNw9xlLMh4Y9Bu93LaBRuoedijwXl7BUOQEi6knVCcJ26Oo9dLoSPzFS
 Kmt2Gyr7hhKxp50XsSLvbnRXsV0SlXU56U1kgS99dg6iwOXN4KIVKLw8W2b3H7kkB4S3sioYtNQ
 AoEfd5Rj6pG+HrA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: wtzwducog8zawn1orcw45ecbxby5m3bw
X-Rspamd-Queue-Id: BEEBA180009
X-HE-Tag: 1781032538-832609
X-HE-Meta: U2FsdGVkX19JNpINOKk/6TJ9Q9Rt3Ko8EOL+gbJMEsf3NmDJMNuyO6tzQwXKgl6VAHfIM/cIEXVyM2jiyJCuV8ctHILXmG6wj88wiuej1U1/Dgp7qs+dEADHI6kPpSyzfeM98bBziJIvpex54/s0RzW1/91LCIe1iW2vAY2MvlWRL+fDKWNHZCjjZi2sqfwYIZw7zSMYAtrNJ9RKUF/bI66Q7ubV62wyt3PKBVYViXTRGD1ExPJVgt6p1QATs6dAuuHM9zXvxgDIrs2jzURTi/4OKOlUpyMrN+i67BpPcxGZsiKTHvGoNuX8gIfh1Of3i6MYkgBlbrCfIdgbxYCw15vQCoFRsXRVByAH88ozSLTkJxSWG04gV0X6gRdVMghxwqS7B7lwCxCA/Md9dE+XMquGjkw608DOJuV058m3RhoJ0sD8QaL6BJAY6zsiNzTXAu7lrYUv/zEc81qpyDBdLAGPk4I9pcSj0tE9WstfDSLyQ0ARRfBlxAh8wwb3C8h7SwiG1rmwgVqmERHFBq7NPbD/92e+LirG+4XuC8hL3/C3NO2c+5f0wxxNTR9roCcSSHWGqPlPGw0P/41izBbkVT69UHw5mMWtmomk7l7oxwNgg7wXmMoaQOAxBVO7G/MUf/twq5SaM87r9bkIMiRHfMm+YH/7RTM+sFwHatN93zBkuRhxxFfsqe7SW4R7UeUcqMieHUFpMAm5li7GMXDnzi62Q9YTZn6Ayi7vbmNU0QplR2pWUamlRcMAdjJJPZ93+DBy0Nn23XYh8p59d8tbSF+M3e7nIgsWpee19/x0vOo8omEDvXrW8vjU1jRy4VZ5MwHRAuDm5BRqBzmmWqxnocuQci9a0lCU+MrtZKHPa/PLSTz9sHLEfkr2zISdJyia7Jr5+jX5ygh8bMAKKvk3/m7IIiaundVoiniy062u7IbwaxxPcMke8bzXQkCL8sBh1wvoUDw2QOB8kjFZpAm
 5XLdKlnK
 IEntFS8LDuy7hCnqTKnXKqyu7MyEQsGdLBihZ56CSGtBYOaJWXzqrjOc/QpZNYgvRjz8gC6EpGVh92Y6Gd5Xrrrq0ialy125ugXk3FjeUSxILgH5Lu5/OWAQhKE6pemQgr9J5/6sPdCGyXW22znr/tu6i9YZvZamt7X7F1aEaFL6QbkbZc5zzi54Kx/wUnVbQA3JmPKYCnzw9OQQ16stOLvYYVKxAfYrbhZCh+vy4KVG96h0ilcsYP+nczLUlvqLk5IxfhuuekhdxxAjVtAZeV/dlcRqaNNky7Nolt5g/z+PPFHWXv3wo8twdy5fNjIqClAJW80byVQmunwiHUFxLfFhpYArBf0BzMqVUmCzuB/JQdSO+wDWUfo8PWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a way for block device drivers to obtain a `Request` from a tag. This
is backed by the C `blk_mq_tag_to_rq` but with added checks to ensure
memory safety.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/helpers/blk.c              |  6 ++++
 rust/kernel/block/mq/tag_set.rs | 66 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 71 insertions(+), 1 deletion(-)

diff --git a/rust/helpers/blk.c b/rust/helpers/blk.c
index 422289d617ae..1f3e5c661096 100644
--- a/rust/helpers/blk.c
+++ b/rust/helpers/blk.c
@@ -53,3 +53,9 @@ __rust_helper struct request *rust_helper_rq_list_peek(struct rq_list *rl)
 {
 	return rq_list_peek(rl);
 }
+
+__rust_helper struct request *
+rust_helper_blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag)
+{
+	return blk_mq_tag_to_rq(tags, tag);
+}
diff --git a/rust/kernel/block/mq/tag_set.rs b/rust/kernel/block/mq/tag_set.rs
index e89c76987b54..66b6a30a9e66 100644
--- a/rust/kernel/block/mq/tag_set.rs
+++ b/rust/kernel/block/mq/tag_set.rs
@@ -6,7 +6,6 @@
 
 use crate::{
     alloc::NumaNode,
-    bindings,
     block::mq::{
         operations::OperationsVTable,
         request::RequestDataWrapper,
@@ -17,7 +16,9 @@
         Result, //
     },
     prelude::*,
+    sync::atomic::ordering,
     types::{
+        ARef,
         ForeignOwnable,
         Opaque, //
     },
@@ -39,6 +40,8 @@
     Flags, //
 };
 
+use super::Request;
+
 /// A wrapper for the C `struct blk_mq_tag_set`.
 ///
 /// `struct blk_mq_tag_set` contains a `struct list_head` and so must be pinned.
@@ -193,6 +196,67 @@ pub fn data(&self) -> <T::TagSetData as ForeignOwnable>::Borrowed<'_> {
         // converted back with `from_foreign` while `&self` is live.
         unsafe { T::TagSetData::borrow(ptr) }
     }
+
+    /// Obtain a shared reference to a request.
+    ///
+    /// This method will hang if the request is not owned by the driver, or if
+    /// the driver holds an [`Ownable<Request>`] reference to the request.
+    pub fn tag_to_rq(&self, qid: u32, tag: u32) -> Option<ARef<Request<T>>> {
+        if qid >= self.hw_queue_count() {
+            kernel::pr_warn_once!("Invalid queue id: {qid}\n");
+            return None;
+        }
+
+        // SAFETY: We checked that `qid` is within bounds.
+        let tags = unsafe { *(*self.inner.get()).tags.add(qid as usize) };
+
+        // SAFETY: We checked `qid` for overflow above, so `tags` is valid.
+        let rq_ptr = unsafe { bindings::blk_mq_tag_to_rq(tags, tag) };
+        if rq_ptr.is_null() {
+            None
+        } else {
+            // SAFETY: if `rq_ptr`is not null, it is a valid request pointer.
+            let refcount_ptr = unsafe {
+                RequestDataWrapper::refcount_ptr(
+                    Request::wrapper_ptr(rq_ptr.cast::<Request<T>>()).as_ptr(),
+                )
+            };
+
+            // SAFETY: The refcount was initialized in `init_request_callback` and is never
+            // referenced mutably.
+            let refcount_ref = unsafe { &*refcount_ptr };
+
+            let atomic_ref = refcount_ref.as_atomic();
+
+            // It is possible for an interrupt to arrive faster than the last
+            // change to the refcount, so retry if the refcount is not what we
+            // think it should be.
+            loop {
+                // Load acquire to sync with store release of `Owned<Request>`
+                // being destroyed (prevent mutable access overlapping shared
+                // access).
+                let prev = atomic_ref.load(ordering::Acquire);
+
+                if prev >= 1 {
+                    // Store relaxed as no other operations need to happen strictly
+                    // before or after the increment.
+                    match atomic_ref.cmpxchg(prev, prev + 1, ordering::Relaxed) {
+                        Ok(_) => break,
+                        // NOTE: We cannot use the load part of a failed cmpxchg as it is always
+                        // relaxed.
+                        Err(_) => continue,
+                    }
+                } else {
+                    // We are probably waiting to observe a refcount increment.
+                    core::hint::spin_loop();
+                    continue;
+                };
+            }
+
+            // SAFETY: We checked above that `rq_ptr` is valid for use as an `ARef`.
+            Some(unsafe { Request::aref_from_raw(rq_ptr) })
+        }
+    }
 }
 
 #[pinned_drop]

-- 
2.51.2




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FD86E63F2A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:17:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DACB76B00B5; Sun, 15 Feb 2026 18:45:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8E4F6B00CA; Sun, 15 Feb 2026 18:45:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C843A6B00D0; Sun, 15 Feb 2026 18:45:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0E9ED6B00B5
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:44:22 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13D12C346D
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:44:19 +0000 (UTC)
X-FDA: 84448322238.15.5D6C809
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 59809180006
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:44:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hVURXEpM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qgc67zui6iwY6738HCCeY8wNZsf03NVd1InEV03rSd4=;
	b=YQCz61WwDGTaSj6O/LA1LK/KItjDCKiSQB3+ZOyJAZtkC00yYWiktpvrZrzzKkHEsfrevh
	BkmUdpzETRn2UAxp7p67uvqh0HzWEV8V/MAXQY7JvCOUX1efYgqMNuYHBjuve2c6r8xSES
	orP4p1VBqP14ywqjcd1WVxzS7lwH0uk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199057; a=rsa-sha256;
	cv=none;
	b=XY3C1k751RiFFvMWWyxPyWseGutGzwza7hbmrTJZFgTOmxvf0XeBNWmpfjAHjva77yXawB
	gZEGfc3NakIXFDpLnxJI15tkGLOPidcYxDC1CTKYs6OOqM7OeZDrkYEcq1e/aTffbjQ0Zv
	CwuCG79v5Y0tumtc0UEd+4woaJdN4bo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hVURXEpM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E301D6013E;
	Sun, 15 Feb 2026 23:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E680C4CEF7;
	Sun, 15 Feb 2026 23:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199056;
	bh=xsuee6tClF6ul/R2hOJJBKg96Kg6jLAUBRXV2md3X00=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=hVURXEpMGTCXVTv4Qbca31zfmkrG1iMKdGHLBXWlmZn0eELWfU2kmGrJxfn7LmVs3
	 dhJZGDMrOPlnWyoGb87RZapywHqdffeccBVFLRyjYT2OybgqJ5pKrPOCIKbp566yk2
	 7XdTsdcCyJWN0BVB9KdLVAVjSTZyjIl8cFYUVKwtEwngqWYQrdgehuhgfUcYARzeuX
	 azF40DpUsFPaDDLvntX8NfM9EHqHn2Y9+sA7We7+90WcaxBfriS7mawIdjp6sepSIk
	 tF45wFln9tbI0fVOh9AGTrGRDlJbLPZp541Ymdbqi03FI7swQ1ZuCeaeWCj0DTOdSl
	 cpV7xkZPj90bg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:56 +0100
Subject: [PATCH 69/79] block: rust: add `TagSet::tag_to_rq`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-69-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4873; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=xsuee6tClF6ul/R2hOJJBKg96Kg6jLAUBRXV2md3X00=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklha+tACecSgfGcA74oxyxwExIZbOFlH6RcN8
 vImZ0IJU9WJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYWgAKCRDhuBo+eShj
 d0inD/4kp0vvFFgboOoTGJtTryqDsVSVhkR4f4NyCAQSJe4Mv0PHDrewUkhuP7ETdRCQxOscW0p
 4bb/kt7j8g0NZ92mou8bo7g/hxtvcmOVweBwHlcuFJFsDAN4bSjtZyWsCLD9HB+7Q5RX7ULYHMG
 8oSrX89dqRNl3Lqg4HyVAbCASaeCkEsggONxCzQYGHxXKUCpJpPJhguYEFvqtasXM0WQvAEnd1y
 AF2Z4+u3LNrFW0t6BiwSKEz4Jonru68Kh0/PnrGRfu1OIj/d5at0S6ITzVNyNi0i/eEYpw3W3rC
 ePSEanV2UQCB7nQCiPlASeK4kdrKSsAF8ACEvO5KzIMLKSLBuAX30N925EkU9Dn5fVNtSbgtCHr
 8LTLhFp+kUDKn7J8kPbIiqesdRdONnb2n+cHp/fFLn/5sWUJMbSgLC4teV8eFiECYKyMCElw2wn
 Fx03k/syqs9gj/z1XxuCOWxn6cqdgUoNPU0t1HSR1+VIUBC7ccTbSnRYTF7FC1v1WeAszR08AVc
 JR3WcUk6WcunP7n9tFmA0uKDOU7POL53QK3WXt+i6ca68WOWRtQZco4AGPNdPoSoZORROiYbzd0
 d9C/ihn4wMeheqaU7IMEEGycGw71PxbdX/wmWdZDmCbnQ7LYBXlU9D1BRYjbIOh1m0bZdbtbrst
 +cDXK7WthYA8csA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 59809180006
X-Stat-Signature: csetjjqomni3dri538gtmm3nkcnsjufc
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1771199057-646366
X-HE-Meta: U2FsdGVkX186RU14Y/ku9g0MIldLPBz/8ZcvRrKIwViXolLHKeCpSvu+he9njhd7Fc1bzYPkABNFeJiNoxg00N+3z9B37CI2celd0ZTLDGdxMNFMMXkWdxFQiB1j29QhdZQatq4s0MPN9fiJblpkFwMN+ulDRWZRhOrWtHC/mjpzYOdLvHGPq7u+XjEQTOnJmzCCTcuddfMMCQhDBCvZPy8OnWGLW0Fa+Tc9iaLREWD855XaDKzSaODeQqScVUWMcUNzFvYQXRlPcWqgLfd9IzuCvDlzR382p4YYUouxmEiKWpsJFTuMdhcVw+OV/mtqg7hHy4PxRX9EIhEfo55GyeJK3pj0eg+/6JDmTWvKrgR0He2l2YpAH9SJ87lQbqqwelij0dwlOvl20eXxyVKzXH27GBq+lW5u1pznskzfFjc9+WLfhNDnwhrLvQ4iuctTMvNzCEiYF1cOqW+MYSuk1zhxjm7Tz57VjIH6bOIuFP1L9LiAVXMe3fNSCpVvN8ZUBTmSFkkfCTwnSpnTtzXVj22tz/ehSW6U1KZHePHk8CuaNPhNxBLgMOH/N3KNYGviFRvYi42Go6GwhQyG+IZ5LCrRzcPFCTF61sUbbDZvmXospnqFHTP8lmxTgokzBZFmb8T6ve5o7hgaPBe49Uw3HcnUS7BfdpA69+qBzOeN3Y4NlbiwRn2ur4h1iTW1YqSV0A2fnX73AT7SwWd7GnBQ2GxaQEGcZe45FtUieTa7mGTc4OEoK7waQuXsoK57sovDzA+SpNLObuOGaVFJw7KuiXteOK4+holZ2EHZEeAdDeHZcfD2rq+anL4ZBnQYa5aMQCvOdTXV29DI9SZn0hpPXfWfearNBx79pNlGyyKjpX/AAxy58rUZNi2P8X0v5m5yF/Mr/WyOP3E0gM0T72ITlfyKiVDmHGcb0/j3tuNvJCyIVArj2VeJ008bsXc7pF6llPWuLyQzeXufsbt9CIO
 LZcifbYX
 T0hM1sKHghEbthwWsz2sQZpiyLnK36MR3EFiKpiVl1N+MEP7aoyjmud0K7Zp7BxnOEwyi2xJ6tskBQYYiQs0UwddxBhzG8IOcFlCEQE8M1gZkkIG+7AukbIm5hTFP9eS4PtpsCkUy/oocxan0WkBJ1FDYwaFUCe9rJseyrIOrTXKpJuhtYIPVh6Bxgxt0xz4FnQJEUlRwgaQe6YsxHpApyjb8pCRhIKwlccGSoGrH/cFlhPTeV+nGIcEhbhbAnswyiJuPbTVM4m5y2y6nL3/bjRCDNiQvBzobYNaGV+G522y1EGsxW6ozrvkU6gzxVawpr9isZwhNx0D4bxKzmEYzONzcZry8TYFX6vTcvsiFSxnIwHY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 rust/kernel/block/mq/tag_set.rs | 72 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 74 insertions(+), 4 deletions(-)

diff --git a/rust/helpers/blk.c b/rust/helpers/blk.c
index 0db567dfc5d53..bb77af6dca9c8 100644
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
index 47a162360e628..e7d7217da8922 100644
--- a/rust/kernel/block/mq/tag_set.rs
+++ b/rust/kernel/block/mq/tag_set.rs
@@ -5,12 +5,12 @@
 //! C header: [`include/linux/blk-mq.h`](srctree/include/linux/blk-mq.h)
 
 use crate::{
-    bindings,
     block::mq::{operations::OperationsVTable, request::RequestDataWrapper, Operations},
     error::{self, Result},
-    prelude::*,
-    try_pin_init,
-    types::{ForeignOwnable, Opaque},
+    pr_warn,
+    prelude::{ENOMEM, *},
+    sync::atomic::ordering,
+    types::{ARef, ForeignOwnable, Opaque},
 };
 use core::{convert::TryInto, marker::PhantomData, pin::Pin};
 use pin_init::{pin_data, pinned_drop, PinInit};
@@ -19,6 +19,8 @@
 pub use flags::Flag;
 pub use flags::Flags;
 
+use super::Request;
+
 /// A wrapper for the C `struct blk_mq_tag_set`.
 ///
 /// `struct blk_mq_tag_set` contains a `struct list_head` and so must be pinned.
@@ -166,6 +168,68 @@ pub fn data(&self) -> <T::TagSetData as ForeignOwnable>::Borrowed<'_> {
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
+            // TODO: Use pr_warn_once!
+            pr_warn!("Invalid queue id: {qid}\n");
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




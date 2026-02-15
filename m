Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55031E63F1F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 00:06:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABCCB6B00B0; Sun, 15 Feb 2026 18:43:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A883E6B00B2; Sun, 15 Feb 2026 18:43:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A8336B00B3; Sun, 15 Feb 2026 18:43:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8A8CD6B00B0
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:43:41 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 30F7013BE8F
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:43:29 +0000 (UTC)
X-FDA: 84448320138.24.37415DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8042140002
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:43:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CEh1yGSV;
	spf=pass (imf11.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bOdrGEMLKJg5m4mImyVY8HreuBybufK5v7Druynozj4=;
	b=NZ/G543EqDUDACZXV4Xmx/0AnkrreyOqcld00CNHLVWgTJNF3wDN07ZiDeoIDkS8OfXyz4
	2ion6P04HWDaDY47wKQcESM38spcszla4GjFKTdRaxRIJ1IfikKTFzOBs/0rm9ZDHNDhw0
	zhgE3fbf2YIkDDp58zFv6mVIMCDvZHs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CEh1yGSV;
	spf=pass (imf11.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199007; a=rsa-sha256;
	cv=none;
	b=r0dmJVrZE4a3NM5Mt0/QJMjg2RWUm/eg1AO6L7iY+IO96eWlkZsage6nSaI9g6cxz7DZz1
	zEuKt4hvGPbzgATuOjDWiA/0X+bePbzb5dfny6c1em202WWQLdmxvtG5jk/Qf/CwWeKuUB
	W75OrMwcCuxWH9It8GwptSrMdn8Mlfc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 15F1D6013E;
	Sun, 15 Feb 2026 23:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868A8C4CEF7;
	Sun, 15 Feb 2026 23:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199006;
	bh=GOcUVkfhEDgQ6ums41j+Tcm2cMd8mS+PY9bUD8N/Dz4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=CEh1yGSV4a2uzg4l1d8GdZvR6yZGxx7P7Qp19et8nDKk87JP6n/W2djZHGYWtxMjg
	 xw+EaAHFULi6Ck4l0KLmPK8pBNcVTQ1HM1Ab5oGi/gq2AUEr7zkVw2ZhQ9LYOXu0VD
	 kjsv2DUxGLa+M7WN+pzvKRqMI9CY7cBRPjqpNc5ntnQ78nmbXR0hVh7VIm7/rVO0IR
	 1gZwASzgkhoLJTgr/yss18vkijvUai4uQBP52xl7Q8Qv/G7i4FQ4fEay4vViDKa44J
	 L1C5fkCHhFRhJrLwQgyWqtt3jiRYxaHp2A6yB3a2ZGwnM/vgcWwnbtp14j/EEFdhvo
	 /KtnHR0r+p0ew==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:22 +0100
Subject: [PATCH 35/79] block: rust: add a request queue abstraction
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-35-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4571; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=GOcUVkfhEDgQ6ums41j+Tcm2cMd8mS+PY9bUD8N/Dz4=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklg7bfZv+rauUSPeVBEpQwOIbacR5CrbTYZXo
 PobSHvGjUuJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYOwAKCRDhuBo+eShj
 d3NJEACHSSyaGc+RMfkrlUmWfU1AtFHObfNulQGbxBg6L2E1hcP0cdHbohuIIy2z9/jsqfse9qF
 FbfpGQewVILxCWZezHYlNWhoF9B3ljJCtWHX8p45y9jpY/cfFzWD0gHqfw0LkgDUlDWuTlWeIwP
 7QO4vFDpWeLnyP9BzQbomsIqrMFPk+E8LBE9PPp5B4303uUZ6smVXwjzO+IPqoyHiAwlcg6DYPp
 FRevzPnyuGu4QJ87rYrEiItLuVPx0hMrFZ1gTa+dUVUll6pT7CndefvgPnodZIE+aTLBtkOtC26
 ibv92WGg+ijvchbPSJEr6o19Dk7D5ZPfWkowuIHQQaaHHax1wi3P0c8mHMWWqFN9XkTZJlwDIuh
 ysBlapM5bvHDWwaUzfDgKgfAwYeZtUypFUvuiSCI2V9fB1wf827jlp2KACfjODUJBdmthe7Psyb
 qsbnFaoexmSUli3fc3O40lsjpMXXTYdzipL5J1IGaa9pxVoPszg8ktZ3op6kHZrGnvzpc7BoB3G
 Gp6f5u5qfIuqZDYil4kPxy4jHyvUQ+RmN5spsToBgI5vanTJ+p1ezvCzG856V59k5Gkp06R79vL
 7YVT/u4ZZRUkUdezMF26/PyB62LyLS3JL3Oc+RBGEZvLcpUzM8KApphdSE/Fme9GLs806hbi5KL
 kalmWM7O0IJ19/w==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8042140002
X-Stat-Signature: qunkhknjzwxt8ic9wc1z831enhdupfgp
X-Rspam-User: 
X-HE-Tag: 1771199007-279687
X-HE-Meta: U2FsdGVkX191iEhSQrY50C3sJ6MpJ/TPpBFJ4luGwdIbJLeLhCG6YQ//kNkZeAY5ciBn6q3WhEOD0zhnexLAUYrD0GtFY+/klYvKGysK78NIfXQp3S7ANGvQIJRBovMXUlYTboO8TCln2vL11qVGT0Swbfpk8s7eEWq+INVRWQ0Psgr3jJptW3E5YnYD2jG/d4+q5QkK807s2m8+EdNWJxgnxrCK+Nn9JkBqQEAM2DtxsIBpghpGRhFVD7xE/LBLbor6YyolPqxNCtHs+YI0kkIScVU7Ekrrk5SN/23H/kZFHKhgXGaV+ptHQWRD0eB0MY4lFt39t2e3egJ30NP3OjI4XVy3L2wIrO7svLgYlLfrdw97RE8B55I86LsRsceJtPvSlmBoxhnl8q6+81MqV6Ej3F/Le4sxQA/nQeOw87qUazMI2tbZSSrjhXRrjRY01ZX2JHz1Lwbaxo0JW72oAplSrUgXX2A6Zi1eSWc1OfMfujSTA5Fnha6vXtDLSA9Pc6MXe/t6cMTRS2Cz+8/DEeCiuSaRcneyvOz09CYsl6GekVlfEW+0EMMqQvauD8pYjzBURllJHz8m3KrvH2yN8BPxU7YT6y8hU30v4xag/tcIqL1gvRvvFcvnUV903J6BQrHYrN12Gpg2uVwc8ichExj+xEkRejWl5yA38r1v/zI9KSfZaIpz01YcpD+kQX7HScPNuAz8SqKEiHGmgiLmR+NBP+FUSEqZQhJp1Tyx2xM+UqW7Jdv68bDFn/aXWfKvnj+P+GC2giJ+rYiThYy5XN7s+oUU35+8uVb4Y4wsIL9atH/BNTa2L4dC2vAY7I+wGwhnE+Aam17Y/3AFzhTG/8Il3SEvlPhew6jLaH7YTEX9ov+IpU1HqDqH2zzX8Ld0ekDTWjtPScxZBaHGeCWPtXqDNKfuzebMM2fcH0m7EESQa+NTlMantc10dCa0fu0A0s7XO5dwqtrfDSk+rll
 z29BhGN8
 F5AEIyx5L1sxCtIwGl47zgYOZTSI12ID+BYmf6KOYxjm0ly2sNYgXQCJQUhOxIpi3AwAEQdK9wqZ+LVc38Qwx2EfacqgmKIwIx14n4vFMcJJpjsUJAJ4uRex57mh+WIQUq2aRVikobA5LFP+WMQspYRhyhAUoZffWESi4f4biiCm1P/zXSgtr/glWUA5oKyFYUQZ9VQTQjHT0OtLeyEiM7TtAMJ/4VE0bKCoMtC8KH4dDJONKCFR72ofmnts3//sLD37Y+aJHhvReem/pVonYF2nXyS+rWiQwyuYXT98eEaztB7EqCeciRkEJIWi8Fu+cWQUD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the `RequestQueue` type as a Rust abstraction for `struct
request_queue`. This type provides methods to access the request queue
associated with a `GenDisk` or `Request`.

The abstraction exposes queue-related functionality needed by block
device drivers.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq.rs               |  2 ++
 rust/kernel/block/mq/gen_disk.rs      |  8 ++++-
 rust/kernel/block/mq/request_queue.rs | 57 +++++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
index ab493bd91af4c..a898dda2635e5 100644
--- a/rust/kernel/block/mq.rs
+++ b/rust/kernel/block/mq.rs
@@ -127,10 +127,12 @@
 pub mod gen_disk;
 mod operations;
 mod request;
+mod request_queue;
 pub mod tag_set;
 
 pub use operations::Operations;
 pub use request::IdleRequest;
 pub use request::Request;
 pub use request::RequestTimerHandle;
+pub use request_queue::RequestQueue;
 pub use tag_set::TagSet;
diff --git a/rust/kernel/block/mq/gen_disk.rs b/rust/kernel/block/mq/gen_disk.rs
index 8d39bb70725b0..8a22767f1b916 100644
--- a/rust/kernel/block/mq/gen_disk.rs
+++ b/rust/kernel/block/mq/gen_disk.rs
@@ -7,7 +7,7 @@
 
 use crate::{
     bindings,
-    block::mq::{Operations, TagSet},
+    block::mq::{Operations, RequestQueue, TagSet},
     error::{self, from_err_ptr, Result},
     fmt::{self, Write},
     prelude::*,
@@ -240,6 +240,12 @@ impl<T: Operations> GenDisk<T> {
     pub fn get_ref(&self) -> Arc<Revocable<GenDiskRef<T>>> {
         self.backref.clone()
     }
+
+    /// Get the [`RequestQueue`] associated with this [`GenDisk`].
+    pub fn queue(&self) -> &RequestQueue<T> {
+        // SAFETY: By type invariant, self is a valid gendisk.
+        unsafe { RequestQueue::from_raw((*self.gendisk).queue) }
+    }
 }
 
 // SAFETY: `GenDisk` is an owned pointer to a `struct gendisk` and an `Arc` to a
diff --git a/rust/kernel/block/mq/request_queue.rs b/rust/kernel/block/mq/request_queue.rs
new file mode 100644
index 0000000000000..7d846ea423730
--- /dev/null
+++ b/rust/kernel/block/mq/request_queue.rs
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: GPL-2.0
+
+use super::Operations;
+use crate::types::{ForeignOwnable, Opaque};
+use core::marker::PhantomData;
+
+/// A structure describing the queues associated with a block device.
+///
+/// Owned by a [`GenDisk`].
+///
+/// # Invariants
+///
+/// - `self.0` is a valid `bindings::request_queue`.
+/// - `self.0.queuedata` is a valid `T::QueueData`.
+#[repr(transparent)]
+pub struct RequestQueue<T>(Opaque<bindings::request_queue>, PhantomData<T>);
+
+impl<T> RequestQueue<T>
+where
+    T: Operations,
+{
+    /// Create a [`RequestQueue`] from a raw `bindings::request_queue` pointer
+    ///
+    /// # Safety
+    ///
+    /// - `ptr` must be valid for use as a reference for the duration of `'a`.
+    /// - `ptr` must have been initialized as part of [`GenDiskBuilder::build`].
+    pub(crate) unsafe fn from_raw<'a>(ptr: *const bindings::request_queue) -> &'a Self {
+        // INVARIANT:
+        // - By function safety requirements, `ptr` is a valid `request_queue`.
+        // - By function safety requirement `ptr` was initialized by [`GenDiskBuilder::build`], and
+        //   thus `queuedata` was set to point to a valid `T::QueueData`.
+        //
+        // SAFETY: By function safety requirements `ptr` is valid for use as a reference.
+        unsafe { &*ptr.cast() }
+    }
+
+    /// Get the driver private data associated with this [`RequestQueue`].
+    pub fn queue_data(&self) -> <T::QueueData as ForeignOwnable>::Borrowed<'_> {
+        // SAFETY: By type invariant, `queuedata` is a valid `T::QueueData`.
+        unsafe { T::QueueData::borrow((*self.0.get()).queuedata) }
+    }
+
+    /// Stop all hardware queues of this [`RequestQueue`].
+    pub fn stop_hw_queues(&self) {
+        // SAFETY: By type invariant, `self.0` is a valid `request_queue`.
+        unsafe { bindings::blk_mq_stop_hw_queues(self.0.get()) }
+    }
+
+    /// Start all hardware queues of this [`RequestQueue`].
+    ///
+    /// This function will mark the queues as ready and if necessary, schedule the queues to run.
+    pub fn start_stopped_hw_queues_async(&self) {
+        // SAFETY: By type invariant, `self.0` is a valid `request_queue`.
+        unsafe { bindings::blk_mq_start_stopped_hw_queues(self.0.get(), true) }
+    }
+}

-- 
2.51.2




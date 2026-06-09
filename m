Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ED7BCD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E566D6B0098; Tue,  9 Jun 2026 15:11:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2E436B0099; Tue,  9 Jun 2026 15:11:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D44436B009B; Tue,  9 Jun 2026 15:11:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1B1E6B0098
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:11:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 89BD41C2F82
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:11:05 +0000 (UTC)
X-FDA: 84861316890.11.72C5DF3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id BA4F91C0007
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:11:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Q00rT/I4";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PS2VkUNd369JJf7ucum93WJqs0QoezRjkkbireGl6Qc=;
	b=etSXAejtXB0/GvGhoB/UQlXKU32Trz8hjGEP8m5zIEZVf0yGVld9TNf8wuT7Vyebh/jis8
	7ytYf7Ezzj6GsToBNb1efO+3XdQ/MAcgfjifF6kfhL9jhdZg7BIX1BdhTjBQfu0FxrPz1j
	kprLQWl/iDLD5cbZgOSAdl9YgXnCB2w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Q00rT/I4";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032263;
	b=uCM/+UJUQDcZf3zjX5uhqdoMqE4mUT7YjoW9MjCG0nHS9/wLD8Xx3gc4we2ViFWKRgqZl0
	AoF1dcvVXE6rHoL0TwpGMjx8lUu6+R1n2iHNdA0MJ/PL6nyfIiykwDEdkEa8XSsr5gWUOk
	sRhRumv1ODCI4iNY3yO21a2vcyU5150=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4CE22602CE;
	Tue,  9 Jun 2026 19:11:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052B21F00898;
	Tue,  9 Jun 2026 19:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032263;
	bh=PS2VkUNd369JJf7ucum93WJqs0QoezRjkkbireGl6Qc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Q00rT/I4IRrjIQkppmOTatg2ODde300ODDsVgZck3pnItEIKRYQ1fjMjWRjEg5jKy
	 hs3C97xkNLaYC8fB1xltqdWpZPJBIGJYQwDMx145u1ZoC66OHw/EGu2ety+Zo+vGVG
	 LMJX7ngWW36omMtZKnfh1rUf0IvCsxrNkHUyFe4CSWA6UaiSm71LhlbsDT3ULR1wcS
	 jOJxSN0qiMTrMLW1tOdtuDMxZEaTXDchUKarZTJbXn1eIMd2oD1SU3eXK6SZeDNrXN
	 yZ5+tUohuQp1vCZEjKKWBvGNmO4qTIHITHAQ3zvzW7Y2bItALkXpZxxt3QDUj0aNMw
	 XuqEs7rTXHwWw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:07:54 +0200
Subject: [PATCH v2 15/83] block: rust: add `TagSet` flags
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-15-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4659; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=DINncKwSuL7mJVmDgVRSZcLatYZj5+iron/JtJAzd08=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTCt2lO9pNrd9xgsB1ZZBoV+xLyOTEIyMITV
 qniUELa4O6JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihkwgAKCRD6UCkIqsW9
 0KLZD/0QWgWovCM4gbcQhcPZLiCELO1QvVZhElbrfYyNm/BG39ys+cP95Ms0QeFoszLrvo2utWP
 o8jUQ7WsPfvhFyho27hGT8W3RxxdMzeZIaPeLI/ukpoxn6tQDbalVECoeMj7R6v7dHvIo+IvuI9
 n5gkRjBh18GmuOrb/w8TsnTU0dUTC1KDS7XhvmXJKzd935LFDwavGqrw5hOkl+t6ZdGPuyfbBbW
 tSP2xid/fY5AuWkDYzEmAKFu1v79Cvn+FPej52mDFLWvOmrUmSZtCtiWS9eXWxa+Xoad2qpMsPC
 gG9Rao+SSazio3jF/VfQW7HOyWgLQSn/WEtengNJTG9kVTuyckt0bISduRzdSDHVDX2zwKXG/Im
 BT8yi0IS37hL225IWmRukLCc5IeoWAPlrkuAmh0bck35x91bImVG0oTFkSp+0A+WWwQvXDCwg/+
 fsiFOI+m7ltGPF1R2XxCBpgHL7TUB2vNV63oGWHH+ZSjrA7cMmNvnxyOtIVEZjGvk7Mp8LeXr3B
 0u2BCV39WJ+D3wvhsuMIMluYRb2XBkQg4m4bgBhfvVc6ovo7+zhA5RCyzoySk03Ne2HGZYmZeL7
 R+tpuZ99WJc1Xj2RpK/MJUmYujM4yhf9RihfZfBtKXVzrZmpFMOZ9tHBDtFqfLUaddbf5i4WWAx
 9p4Xn7qvIOow7Iw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: BA4F91C0007
X-Rspam-User: 
X-Stat-Signature: xwwjoo4a6ots4sjktx9wt6kedop54aus
X-Rspamd-Server: rspam09
X-HE-Tag: 1781032263-159352
X-HE-Meta: U2FsdGVkX187mqb7Tbqxaaw+cfIFh0KzkBwnVNpqfdshE53i9m4N7QryANSxfPW129e34V/Y6FRiN29i1cujS/nqpeZtAa7L7zV4cUVeZ0k7PK/Rf7bmJFdWNZvQznzZ4a+yLVeJY0rVdsVw2YrGXzjpXXKR4Q53enXpHwPnMJBU/oAWUw7bQkI6NmxtQeVxAihRj0yEruFjvm6s8vYSN0DumXbL+dGvOm83lFZc3Lg+Pfk4DmE3THLCGIm1hAqo8ZgANL/UlHzI/Vf+PNf3QN0nqy2W+j6M9cVF19pR5j9f2fZADlvStkseLfHJRBnZUIfTCHxKILOlvjumvg7ZkpD9PfOHGulGiSWaJpZF0H1BTGJElXzAR2J7ldm1CMxXvGJAe0NR3MLqW9Pgq8Ma0QSzhfTEvXdCwhNurM1QjaEjk6RzKKfEWuQS3kHQCs+F8IUHoVcJcmB2tnlSzSgqoZC9Tu7760cc2u13jgnAcEtJcuP1BXnfVi9ddE/mHHs2ADOC3z9DayQi/WVr4+T0W13AEE73Mm/C04lV4yRGYZAOthuBupz1Zf+GyLuR8zIHQVsNPWM7LvtqEnZD+XCAI9HHk9G7fmcpk+mAFY26AUfSbwbbQOFFWX6RSyWvGORA/xgzGC5eBhP7vx7N3XuI3NZHBYmGtdvb3f5J0xqHm9UQJLSAmWzI2v+KKXnNVUqV0SykCVoqfTfDuZb3Ktqsa5Khk02WcqSH4wYeQM6F7KdfDxeouJcPhMDFEx8V1+Hg3nekApYYYHHuiHjouxS/C7C9ZKmyh/6yxLO4S+T1rWFRy9YjeStg1HvK5WVMxZBzsnqwqHjwh3fPOyZxQi3d6xz17pPE/MPwDh0OO8KyN3Ily1TPNTtBi8+u7e1MQTCozYvBREkhXfA1kdhS3jhTWfSBFSDnOdsnO9EsxYv/oXFsch+DOFp0yfb2SHiCE0CjfWDZ/j5/bezE1lLD0jE
 eglbx1JB
 U5VO5o/tdeg0WGvpQa1XkcbMERKfDRZAKB2WqdsZUv0AW9ufpRre6egYVbOH58/En3h/TUGxF3+H/haT1RWsfJYPFH1sddXB//cYzKo3FR7hB/raId0JVYNAPxmgArUa7YlcT4A908iR5kxouq+c1WM82NZDx7OAvdmntydTEGlzgP4XCiWaKi+huS2lJ+yxqANTSDjOYEJu2nZuX8yTuWxsbMGwSM+sA4314s9iYkwzH8mKlAI8e2kfily/0lSeR4AoMlrGr63Y0kxjubkmHitvNBia4+k8I95vJfwht5bI5FCg4g9vkZyALtHKTlYYtvnR0ybEWLzl8Ntua8HHeRPjejQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for `TagSet` flags by introducing a `Flags` type and adding
a flags parameter to `TagSet::new`. This allows configuring tagset
behavior such as blocking vs non-blocking operation.

The Flags type supports bitwise operations and provides values like
`Blocking` for common use cases. The module documentation example is
updated to demonstrate the new API.

For now, only a single flag is added.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/rnull.rs          |  5 ++++-
 rust/kernel/block/mq.rs               |  6 +++---
 rust/kernel/block/mq/tag_set.rs       | 13 ++++++++++---
 rust/kernel/block/mq/tag_set/flags.rs | 21 +++++++++++++++++++++
 4 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 3e7a47e6d0e5..746ddadd11f0 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -128,7 +128,10 @@ fn new(
         irq_mode: IRQMode,
         completion_time: Delta,
     ) -> Result<GenDisk<Self>> {
-        let tagset = Arc::pin_init(TagSet::new(1, 256, 1), GFP_KERNEL)?;
+        let tagset = Arc::pin_init(
+            TagSet::new(1, 256, 1, mq::tag_set::Flags::default()),
+            GFP_KERNEL,
+        )?;
 
         let queue_data = Box::new(
             QueueData {
diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
index 23660817df29..e556b3bb1191 100644
--- a/rust/kernel/block/mq.rs
+++ b/rust/kernel/block/mq.rs
@@ -57,7 +57,7 @@
 //!
 //! ```rust
 //! use kernel::{
-//!     block::mq::*,
+//!     block::mq::{self, *},
 //!     new_mutex,
 //!     prelude::*,
 //!     sync::{aref::ARef, Arc, Mutex},
@@ -92,7 +92,7 @@
 //! }
 //!
 //! let tagset: Arc<TagSet<MyBlkDevice>> =
-//!     Arc::pin_init(TagSet::new(1, 256, 1), GFP_KERNEL)?;
+//!     Arc::pin_init(TagSet::new(1, 256, 1, mq::tag_set::Flags::default()), GFP_KERNEL)?;
 //! let mut disk = gen_disk::GenDiskBuilder::new()
 //!     .capacity_sectors(4096)
 //!     .build(fmt!("myblk"), tagset, ())?;
@@ -103,7 +103,7 @@
 pub mod gen_disk;
 mod operations;
 mod request;
-mod tag_set;
+pub mod tag_set;
 
 pub use operations::Operations;
 pub use request::{
diff --git a/rust/kernel/block/mq/tag_set.rs b/rust/kernel/block/mq/tag_set.rs
index ec5cac48b83f..5b1a5bcc978d 100644
--- a/rust/kernel/block/mq/tag_set.rs
+++ b/rust/kernel/block/mq/tag_set.rs
@@ -17,7 +17,7 @@
         self,
         Result, //
     },
-    prelude::try_pin_init,
+    prelude::*,
     types::Opaque,
 };
 use core::{
@@ -30,6 +30,12 @@
     PinInit, //
 };
 
+mod flags;
+pub use flags::{
+    Flag,
+    Flags, //
+};
+
 /// A wrapper for the C `struct blk_mq_tag_set`.
 ///
 /// `struct blk_mq_tag_set` contains a `struct list_head` and so must be pinned.
@@ -51,6 +57,7 @@ pub fn new(
         nr_hw_queues: u32,
         num_tags: u32,
         num_maps: u32,
+        flags: Flags,
     ) -> impl PinInit<Self, error::Error> {
         let tag_set: bindings::blk_mq_tag_set = pin_init::zeroed();
         let tag_set: Result<_> = size_of::<RequestDataWrapper<T>>()
@@ -63,8 +70,8 @@ pub fn new(
                     numa_node: bindings::NUMA_NO_NODE,
                     queue_depth: num_tags,
                     cmd_size,
-                    flags: 0,
-                    driver_data: core::ptr::null_mut::<crate::ffi::c_void>(),
+                    flags: flags.into(),
+                    driver_data: core::ptr::null_mut::<c_void>(),
                     nr_maps: num_maps,
                     ..tag_set
                 }
diff --git a/rust/kernel/block/mq/tag_set/flags.rs b/rust/kernel/block/mq/tag_set/flags.rs
new file mode 100644
index 000000000000..b7eaccd200a2
--- /dev/null
+++ b/rust/kernel/block/mq/tag_set/flags.rs
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0
+
+use crate::{
+    bindings,
+    impl_flags, //
+};
+
+impl_flags! {
+    /// Flags to be used when creating [`super::TagSet`] objects.
+    #[derive(Debug, Clone, Default, Copy, PartialEq, Eq)]
+    pub struct Flags(u32);
+
+    /// Allowed values for [`Flags`].
+    #[derive(Debug, Clone, Copy, PartialEq, Eq)]
+    pub enum Flag {
+        /// Indicate that the queues associated with this tag set might sleep when
+        /// processing IO. When this flag is not set, IO is processed in atomic
+        /// context. When this flag is set, IO is processed in process context.
+        Blocking = bindings::BLK_MQ_F_BLOCKING,
+    }
+}

-- 
2.51.2




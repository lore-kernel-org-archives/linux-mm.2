Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7C4FCD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:14:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A9336B00E3; Tue,  9 Jun 2026 15:14:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5804E6B00E5; Tue,  9 Jun 2026 15:14:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 496936B00E6; Tue,  9 Jun 2026 15:14:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 370FA6B00E3
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:14:23 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E1F4C915C9
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:14:22 +0000 (UTC)
X-FDA: 84861325164.06.3FFE67A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 183441C0002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:14:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UK8qLP51;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aU3etQORaY46jYoSyqScYvf6b4+RP+R/4DsnBtOMojA=;
	b=BtrL4Nfg/HXBxHyH1Aj1nH5AIucrkqVpjLA+yZMO4NPf4MlCrjgF7xB6gPHJTXU457OsOD
	FEFaV5FAn0JibsS5Sb4bTIUPdcXOcavmZkXDbiv4wnneUfGxU+D48zy3fs6lxocdnDnxCj
	Olocio/z0Jtc2XoiPUMdvquLjpy3CuU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UK8qLP51;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032461;
	b=uMRNaUCMd4nOlwqF7HGe6JVqrBhKWq29t97RSOQ4FSKX+n0J+8ihnV/SmLfAjnqvhfxNzV
	DT9w4Qit0o+vtlygMKeEzlZg5/5lYltCWSWTkBsPiWU2dElEBJK2Xy1+6Y++OcCgCKUZN0
	IcemlkiDrJwh8jdVwIFg4AcDeOZcWZw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2DECF4183B;
	Tue,  9 Jun 2026 19:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48C11F00893;
	Tue,  9 Jun 2026 19:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032460;
	bh=aU3etQORaY46jYoSyqScYvf6b4+RP+R/4DsnBtOMojA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UK8qLP51dGiAHHqYJNrAAu4gqz9LbJnT1abn0iB1tN10CWSgMOXM2WHUkBuVqwprn
	 DAVdOdrbUNzNNmXxmIMyFVrnn7/AsWnCmjFeJpZjs/O2nRVbntEp81Z30KMiAZSAIB
	 998Hsvm0FhjYz2KnJlg9AvjGA1eBiiucYgpW8+K0xooG5sDie9pGXGGtVBTWdcY7KP
	 ZEmvHizkHOwxqG5BOIebpXaZe7OTSSOBKGfU6WH0jYzLTW4MUSt9B+B/XqjTaCuPr6
	 DWLt3B4V7u4OrSIqyhrvnRLh9YNFYfiWcbfHtfE9tAL/V2/28zcuCpeBxei5KXA47L
	 LjCTTS5k/lt4Q==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:07:58 +0200
Subject: [PATCH v2 19/83] block: rust: allow specifying home node when
 constructing `TagSet`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-19-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3058; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=rKHqlbFiDQot+ZmlglcKCo/ua2u/3jUgradS2liawPs=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTFc9bXf/EXOOGGprjUbeDTFs4TcTazosGSi
 AAATe1MXLSJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihkxQAKCRD6UCkIqsW9
 0EwTEACc0x57IjxoSWw17YFWmZ1nV5wtXGPR5ov9KpAor1CoF8ZnBF3cyjr2dewCH7eSzjwEA9F
 Yfk+ESoiBRMnHdyje1lz3SCriO/4Vb8YConPJcu4AY8HUuhcepOJkl6VMLTYd33cAYVhIku7h+H
 OB1Emtf9lOVAMHkHFTftNCMu3+4MK8nUZQNf4mUXV3BpsyGGJ6CXdAj5gqA/osH2pwU/G4u4D5L
 A/GYIrZKUyrIvLkjSiDV29/5dBBin5+vDLhpUVY6X3OnhtToq3CnXEbje+rxGbCqLZ9VlB+lu1m
 CH/VEHjcI+V3Fb1lLBhpy7id7+DrNqJ24GdvMGVoy8XwfQpAFt7f0Q93gHdSPIFEmC51KHiYAgN
 YJgR2OZAWcpPmRTym9OGXl1cFRMUz37yjNyYJNUD+Ev9406YcJ126JM02/O/TfumwdIO4hSeEqm
 Iq6IihHZ9BYODl1oDDSKwtIaPmrss2DD9th4AsvlnaSSO4wxwRQJFOy7a2aZ2FMnGl81IuoXOpW
 V+uYlzSqrUX7DFW828I7UOUsYr/aFziabmI90FsDQ0V2yiiO0AQV1OqNv6F+9UKaMNCdMTUMoUu
 ZNkSD5gMmFewkyEHVpnbi45VlDgxxer+vQdKV26NDyRrNpM1at0y0DAiMwzbNp9OGZ2nYKU2vTv
 Zj7VqK0IxKW8Upw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 183441C0002
X-Stat-Signature: dz8wfq1zg9d4qnxtit8twxak4dyi9zdg
X-Rspam-User: 
X-HE-Tag: 1781032460-800301
X-HE-Meta: U2FsdGVkX19qi2eZ8RTmHvkO42BHhhldHdis/nkXROr2DHiFkxp8gVZ1RuowVitOtOYruAPvK46NUgD9EkdSAFVAp2m0Z/xAFac+IbfJZOjqvuMio+l3AWZcHSN4/KIkqWCssZneIsWeqLLm6yN+ltLneY2TglMpMaw+I0uD5BUddwsC4sU8yiwSReRnpYGkfQWM7KpVuggvDmyCiP9gzA6ZOmfnjLAYCQZ8RxNk22cHei0iUZVxP4mBhG/fMSsEoPkZOcVT1US3OTC8emVOYyxUBhCoYGVFUyw5/SK9zm7U+tdipijulHDUT1Or6N4H9VDeVbW2aBRLpFENDxLLhB5wToQpABDa5BQOh+buWG8XY9z+WNNhpyMarM8dJ+3eV3Dsuhq0m+qCfCTmputkLm21xoBXpFxeTZQeSGyadOKpVnrb1mFFpMKiz7tBztVJlcQPR8Ox//4fHP88RnLwj1B1MvH5Lknynk2gufporsQPi2bs+akA7CzO+DM4J/sw7jXnycvnmWJ4ipDt2uYKCdpV5iaP/nI7J9OxUYwtgo3iDoYCfZuucXSGHO9XB6pz2mJZJ2Eg7HN0cKt4lzprOBGN4jmqaCzI45kevx2A6ip0GNMx7AYNPlHAJwcX9rhXB7o/bJtI3Lxp+i7C9Pgwit64Wj6BxP0OOtcLAi8o9HGcKXSGt6GHZiVNy1Q2vcKQ4AhzZnTayCsJe7x6cSRMd6wdaunh6C8YQBJg/VwNNEFecsaHF45RHagX0bx4FsEkB5iLeyqNq9fymbWtyE8/AjaOp0H6WcZF5nJJ8v2rIYe2lWy0r98l068O5fHz1kkSM6K0OfssVEZYs7NPjZrArWUHL8CAVYIIpvEBE/9wXYq+Zq7IG1exaOpim1RSjxdU04TP3Y5bYD7NrCIj5ljU87cfKNYw3mVXd88BTZrddpzWQzItO8LULpIrpc+ETQMs8XhXllodrRQrAeJQdoS
 xK6of6W6
 bfKUtNbTgsn0vLvdSaHljlsWOuwq5VsHPrxUeUktVwm8vgntB44DzR6KRg7j3oXOlN138vmyRdNbQLhzpKVwBBYNcMoOSHofAES3umfPaZKdeKSeCNRYnqV16mcgXOhReuztZRD61H4xviPgpgHJol0dmd50tcoha+K03aaBMK6Lll2rZy4ttysJYwD3RTrYDdBb/ZNlzSGB5oBc2AMsa6nzzp+UTwknkS+acHTZBn3gjdW8p+GC7mYwzJLHYUxJFGlHecT/7BA7YNlXuTEJdn30wClT7Kgsj66s8iMNKQyQGmXbE94mzC4055mGm0b8b0bMk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a `numa_node` parameter to `TagSet::new` to specify the home NUMA
node for tag set allocations. This allows drivers to optimize memory
placement for NUMA systems.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/rnull.rs    | 11 ++++++++++-
 rust/kernel/block/mq.rs         |  5 ++++-
 rust/kernel/block/mq/tag_set.rs |  4 +++-
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 30de022146ec..6323327d4a5a 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -174,7 +174,16 @@ fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
             mq::tag_set::Flags::default()
         };
 
-        let tagset = Arc::pin_init(TagSet::new(submit_queues, 256, 1, flags), GFP_KERNEL)?;
+        let tagset = Arc::pin_init(
+            TagSet::new(
+                submit_queues,
+                256,
+                1,
+                kernel::alloc::NumaNode::NO_NODE,
+                flags,
+            ),
+            GFP_KERNEL,
+        )?;
 
         let queue_data = Box::pin_init(
             pin_init!(QueueData {
diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
index e556b3bb1191..bac15b509d90 100644
--- a/rust/kernel/block/mq.rs
+++ b/rust/kernel/block/mq.rs
@@ -57,6 +57,7 @@
 //!
 //! ```rust
 //! use kernel::{
+//!     alloc::NumaNode,
 //!     block::mq::{self, *},
 //!     new_mutex,
 //!     prelude::*,
@@ -92,7 +93,9 @@
 //! }
 //!
 //! let tagset: Arc<TagSet<MyBlkDevice>> =
-//!     Arc::pin_init(TagSet::new(1, 256, 1, mq::tag_set::Flags::default()), GFP_KERNEL)?;
+//!     Arc::pin_init(
+//!         TagSet::new(1, 256, 1, NumaNode::NO_NODE, mq::tag_set::Flags::default()),
+//!         GFP_KERNEL)?;
 //! let mut disk = gen_disk::GenDiskBuilder::new()
 //!     .capacity_sectors(4096)
 //!     .build(fmt!("myblk"), tagset, ())?;
diff --git a/rust/kernel/block/mq/tag_set.rs b/rust/kernel/block/mq/tag_set.rs
index 5b1a5bcc978d..d6d104adf4aa 100644
--- a/rust/kernel/block/mq/tag_set.rs
+++ b/rust/kernel/block/mq/tag_set.rs
@@ -7,6 +7,7 @@
 use core::pin::Pin;
 
 use crate::{
+    alloc::NumaNode,
     bindings,
     block::mq::{
         operations::OperationsVTable,
@@ -57,6 +58,7 @@ pub fn new(
         nr_hw_queues: u32,
         num_tags: u32,
         num_maps: u32,
+        numa_node: NumaNode,
         flags: Flags,
     ) -> impl PinInit<Self, error::Error> {
         let tag_set: bindings::blk_mq_tag_set = pin_init::zeroed();
@@ -67,7 +69,7 @@ pub fn new(
                     ops: OperationsVTable::<T>::build(),
                     nr_hw_queues,
                     timeout: 0, // 0 means default which is 30Hz in C
-                    numa_node: bindings::NUMA_NO_NODE,
+                    numa_node: numa_node.id(),
                     queue_depth: num_tags,
                     cmd_size,
                     flags: flags.into(),

-- 
2.51.2




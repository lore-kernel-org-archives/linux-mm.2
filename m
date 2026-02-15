Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D94F9E63F2A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:16:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59D326B00FD; Sun, 15 Feb 2026 18:51:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 567FA6B00FF; Sun, 15 Feb 2026 18:51:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45D426B0100; Sun, 15 Feb 2026 18:51:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with SMTP id 2BF586B00FD
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:51:28 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 80DFF8C86F
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:42:31 +0000 (UTC)
X-FDA: 84448317702.01.6764038
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9C727180009
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:42:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hcNBsaOU;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771198949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CUBCs7uOHUttUUd6AU1F0frInDSfTMjaXds/clf0duQ=;
	b=yyHFRpe6PSq20pdhIRlzF4GvolnYubIUW1gz9iS2SJO9cPfefNbhiw2t5nB/W3o/jZqckb
	w51huisdG+hWWCiWjGrxaXBXrICGlxGGMfL2eYP+LHItfUfAeN/FsNhtXEf/bHSEZgO38v
	3+dhLKXnsIK4g0YuMGEnkiYBh4p8xyE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hcNBsaOU;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771198949; a=rsa-sha256;
	cv=none;
	b=U5ySK29vSHK59wWTk4KS027lBHW3sCqFelLKgV++NbAwcy4vDX3EbaHzZ8HWrB9uS6A0vd
	MNQ46vIQ5fahnb3eomZzBBMj0/rtxAeBhS4lK50pP3tiTJJCic9ctessxtO4K75EqpR7yA
	FBIXY0wlQtigTmAnbCD8W1D0IxTLh40=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CA38B40298;
	Sun, 15 Feb 2026 23:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A372C4CEF7;
	Sun, 15 Feb 2026 23:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771198948;
	bh=3w4qnZwh2+aU+MMv2rWpFqX4lbRY4HhOYDulfwtiM5M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=hcNBsaOUM934DH9Bn9Bt2eXMRFTjwTsogGjvGEoqIobTgU/yhXBgCW+djhbrod562
	 cotXZxz70B7WGOdbqDoyoRkCajfzwkKHrLswK0I/GXkWYW4EAy8zdjNCRojo+4EBSY
	 nMI9JFDO46qVxu0S0dJJH0Wk0E3pZEummL/3uZeM9ieDl3tYUqxpYL2ZVOqr4nRqAE
	 tvhlweYgaY5yXc+hpVGVN2U3k6cBwCQeYgYUGrpD6WkagJZO/ZPv69kh/TrThfiw93
	 dswZKTI/pyRE6JxRKOToSWKg4PXwe4oOhhIOuPFELLh0429JTk6gL6qhOmPrOcMX3l
	 fxW8qyqfqpbBQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:03 +0100
Subject: [PATCH 16/79] block: rust: allow specifying home node when
 constructing `TagSet`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-16-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2776; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=3w4qnZwh2+aU+MMv2rWpFqX4lbRY4HhOYDulfwtiM5M=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklgq/QYUe8bZ2utIQqjhHTdAHO+CoJMp7AuDq
 tKoe/uOJg6JAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYKgAKCRDhuBo+eShj
 d07ND/9tv906O8JV5IQLXSRDJsUM5zCW6KhC6KwqGSY4R86jRB+711HKXUg03JJQDCLhm5B1odN
 g5QNE1tI6Keo/Rlim+cgJ4C0MTNOFejGDuccLgjBur1v1qbhRtouw6LvcJhG8troiQXNaLo95Sh
 N4YJ1E0nvmwmxrrI/LnQZNCgwmyEzkipgRoWL3ii5hAa6JVBiuZFlheUXC9yUId42wJVfQrbyPG
 YcbY0u8K1j+ejkox7kq83opF2JANf984yHH5OC3PxPRrdXygZKUqKIKRG3Y7Z9MKfC11FHSzfXD
 bltiQQFd0bBP81hoCG2rNMg3gbY95zq8MxhhGVpndJA8yI6K0KkwuJv2Jp6lsrVOyLkBoJs24/4
 8BFVbkxpRuoQv6ll/Bx+0XCfRq/COAOYxmIX60aqJ2M8q38PqYxCIB65sUizUlj2PN/+QCruQwR
 HInNKE7a+lLXj8GN7lo3X2z+jCyhoz1bebAowt6EWF6qWXD/n52dwMSpc2WBW2IMC53VYLHNopE
 xH2efg0tHDD8dX8CtvqT6ryGyT6oLFHGZB0OE2bnCSQuiS3iAJe0g/akikOI/b3ae1yLKsx99aL
 B5mslJIRkZyXSkcCXEy36iRF+6W26ki8gRLBy37mk0RcC39eLJZ4qPtzM8027gJ4xsyoEe5tHyT
 T5x6R19UphlS3XQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: 13eznjrq1xmjpdi469r4nmoj5t7youfz
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9C727180009
X-HE-Tag: 1771198949-522667
X-HE-Meta: U2FsdGVkX1+gMc0EF5nvWVXk+aSVTKkTAzCFoME7MZbD8Ou4+vy5rtFBFv0/qX1DdKLLOxWP1L5c6LgdkT35ZqPgRAFkMieF3HSlBZHzIUmTTxx0JEp5iQUhHOMxUV4X6gjzSLtRjYWkkYLfRDre9E7SjzJg2uTkc1RfLYRtXB//0rofz9zagmNP3iyleyqyvI/xZJZn6mFiv03hFPI/3RPDXJ3x1Gs9gMCTWraJB0aqHbZGDA9G0liC6iuLneAXlLO4fNRXcYBByy/VwMGsP62LDwVSj5ueHNC2EK98CVetKwjBT2ITI7CSHgmLdJ9AN1CIQEhiyL6oE3b5AiMidgpP3ITppwJl6UKHIgOpK5vgPWGsAOzCAwYv0R2DbAUqHLKXWX0TrGZlxFpGWK9mOfuBbue44uW9VJelh1ljXGJapf8BQ+HtgFnsMbiI+P2aS+BpIqW58mDXkSqE7mK4VRc/8B34T7YikB/1V1H/pkBavjgIpWUCF8VU/ZGepMd/p4Jbdd/rYTmeodlbcvhTnPtruiAul+I9BRBi/xdaPLwpJENrKugSlS0O3ZesTgbbn6+7r/MhGHncVcG+vLOWAT3J97MGthAOa0SE4JdTGea/mbk7mmgKvxVqHR6agIVBt/a3WcEzKnU1D1sRsAFcNvonBESGGsr8n74u6NDZ8mcKpE2EKAr7svj5Y6tFSdwt+4GShkoqSwCy6dT+u+HSLznGV1ibKBn+Vi9eqwimbVkDop/1674peIyPd4htM9g77eWQY+YI+pPUdAWLfxsRlcgpx4yNEPxPPEVzjHQb36e4Su76wSTwKnMvx/jkpBEuYAPm+5I1zj/vPL0U4Hr1pYBdP92colJ3z/1cp5Pg5GfpIz9y2whzM5Q+VjmG63OOcbu1/s6J3GRKU/XX5dXIMqQjJEDXI0CUwu7F/NSg41JHL3aoegNXNy4WkK5YGHzxah+9KbdRgwMfTJT99Wg
 kb5MJVxx
 0Psn7dUX2/UyoZmNIPs7udKFMwEpfuRbiaUUvsS/Cr+iAUGgd/PbIIY0M3fYCvcL2R1S+Ta3FZI0AR7fcBCf9cUyUrR4LnnPBy4PXEjhEXv7NVb8kdSzSI9ewNnINyu1wbWAT+cU3BBZGXujiZoIMg/e/zlt1VTtLogePUKY0hRUIzScHqSfmXYBl6mUcTs8QAlVXpKT4rRXLS+jT7H5aYYDaBoZxzkj+XcNQ1wWcJYrn829lJBMzgP+ngCwoneY9Pq+51q7nvl+IkF9IflhjFW8pae7Qns10DeRJSKZytjSPqVu/Xsg3ATQZO2s9OJAWamvS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 drivers/block/rnull/rnull.rs    | 5 ++++-
 rust/kernel/block/mq.rs         | 5 ++++-
 rust/kernel/block/mq/tag_set.rs | 3 ++-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 990dfcf95c9de..278f75d886fd9 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -176,7 +176,10 @@ fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
             mq::tag_set::Flags::default()
         };
 
-        let tagset = Arc::pin_init(TagSet::new(submit_queues, 256, 1, flags), GFP_KERNEL)?;
+        let tagset = Arc::pin_init(
+            TagSet::new(submit_queues, 256, 1, bindings::NUMA_NO_NODE, flags),
+            GFP_KERNEL,
+        )?;
 
         let queue_data = Box::pin_init(
             pin_init!(QueueData {
diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
index 76e790cdb1f8f..d3957f2fb1a66 100644
--- a/rust/kernel/block/mq.rs
+++ b/rust/kernel/block/mq.rs
@@ -57,6 +57,7 @@
 //!
 //! ```rust
 //! use kernel::{
+//!     bindings,
 //!     block::mq::{self, *},
 //!     new_mutex,
 //!     prelude::*,
@@ -92,7 +93,9 @@
 //! }
 //!
 //! let tagset: Arc<TagSet<MyBlkDevice>> =
-//!     Arc::pin_init(TagSet::new(1, 256, 1, mq::tag_set::Flags::default()), GFP_KERNEL)?;
+//!     Arc::pin_init(
+//!         TagSet::new(1, 256, 1, bindings::NUMA_NO_NODE, mq::tag_set::Flags::default()),
+//!         GFP_KERNEL)?;
 //! let mut disk = gen_disk::GenDiskBuilder::new()
 //!     .capacity_sectors(4096)
 //!     .build(fmt!("myblk"), tagset, ())?;
diff --git a/rust/kernel/block/mq/tag_set.rs b/rust/kernel/block/mq/tag_set.rs
index af214f7dd0c10..e9b36d6329b9b 100644
--- a/rust/kernel/block/mq/tag_set.rs
+++ b/rust/kernel/block/mq/tag_set.rs
@@ -41,6 +41,7 @@ pub fn new(
         nr_hw_queues: u32,
         num_tags: u32,
         num_maps: u32,
+        numa_node: i32,
         flags: Flags,
     ) -> impl PinInit<Self, error::Error> {
         // SAFETY: `blk_mq_tag_set` only contains integers and pointers, which
@@ -53,7 +54,7 @@ pub fn new(
                     ops: OperationsVTable::<T>::build(),
                     nr_hw_queues,
                     timeout: 0, // 0 means default which is 30Hz in C
-                    numa_node: bindings::NUMA_NO_NODE,
+                    numa_node,
                     queue_depth: num_tags,
                     cmd_size,
                     flags: flags.into_inner(),

-- 
2.51.2




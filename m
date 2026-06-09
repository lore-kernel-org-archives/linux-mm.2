Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E24D4CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:14:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 533026B00DF; Tue,  9 Jun 2026 15:14:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50B0B6B00E1; Tue,  9 Jun 2026 15:14:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 421506B00E2; Tue,  9 Jun 2026 15:14:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 313306B00DF
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:14:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EFE8E164FF9
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:14:10 +0000 (UTC)
X-FDA: 84861324660.02.563DBA4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3FF62140005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:14:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zjlyuyx8;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x2PxxA3MSPDESp6PPRlNFBFe70vLv/38gregfZpEU1k=;
	b=DmanxJa/GpZc/L8voEUh7rioa/DL0HdLrKCy6aRJzHFRMM1XnGQfvoHkEHoGMjWutqLqRS
	jO0yP6VoSyORZ27dDmHigBwmFrAytuo6VJpKbOWPLNQRLoUk5tL7BBrjQYOrZ64ty6bdvC
	cRiyy2axHvdxheeTe8OlCEGvTzffMdk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zjlyuyx8;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032449;
	b=UVGdnJlhIgTNo1dM6pXj9rbfpKl1ne1jEqytNn9+yy55IjeCCsD4FhadgffgNxo1gn9SmC
	ip+pr7FJgT/Bhey/+gR7ZUNEuu2U6NvaofbcIrTiBHGRb/6Q/PaUbBucXjZzLvosd2Gyh8
	oTyfKH0YbyMdVwEmk6KMWhVLuX3V0mE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CD6D2602CA;
	Tue,  9 Jun 2026 19:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB8C1F00893;
	Tue,  9 Jun 2026 19:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032448;
	bh=x2PxxA3MSPDESp6PPRlNFBFe70vLv/38gregfZpEU1k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Zjlyuyx8bYL/2Qw4pNRLmAEHI0GjtXrDc1K8a2ffnCDtsJKoZFEUWFTPw5PIPVTCX
	 5+Dt7qmtIZ183zEAPDo/azahSlF81GVi6ROKQcaRe0nw3b2a+2p9gjQqbjky35oFLO
	 XD7KRmiIGvuYUSIN/vxnscSb0sVUIo0MtsZQ/BVEFxwxHoNvSSQx+1t3iHQ7wTlw1n
	 LktGX1Rw5Fu9Firh01MDlOSQuf4Pgng5clcQPr37BPO/TSXsABkdM/VzMgjrxRhf3S
	 E6m0gNa8NKgkt4f6tNYgeDngM246bQ9W/ZRLYeCZ5wTaSqnO9EKfafJ25tHWnTfAtj
	 GuAEmxBHcXrFA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:21 +0200
Subject: [PATCH v2 42/83] block: rust: require `queue_rq` to return a
 `BlkResult`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-42-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2656; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=DdV/NLJR9VTmPqZyVaI6uzyHec586erqdAzY/0l2Nn8=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTaruS+IOkE14zFQtyt0+NF5/WYzKnu8ZDWM
 tiGv7qIRIaJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk2gAKCRD6UCkIqsW9
 0B7yD/wOR8PPlgBri1+hwHQY+XDM3u3f1pRkc8cj7TuKaXgHixWBdzbLkqsIc5cdFkOgiBSAc5N
 pfnFEgZ7b267KmCIrTUViibhwJ9jmlH2J5D/bdZlWKKLLrBhoxoqh2OEiMO0feNI76lzcNmps/C
 Hqcmlql6GDiMD2qzQbpOmwMTv7VTPB7y5F3rUIE82SFcSk723PdvakjbKmpLTXp8lScT5QRnEuY
 06m5hQPXoRHNuNnrIZcVB1k/8A2DkXoy8xvRcmh5/aP35iEe483vHo02SMTutUEyaxQSsANxbmW
 c/dIWCHfMHesodP5gH3QGt7HTnKYnzoJYfnscdsnepM0oGXrQIoW0tQnLVzWLNlnMN/Ekj5ti/b
 Jov7ZRf577FRhmu+xXe/8oT0boTu1rRoj6DePhfwAoXOuTzZFH8/xzdckSiNEy/dQOa0r8zRYOf
 SSfMFSQylDoWRPmBjRXMPATHYLcf5Z2CxZj5w8T6dU+uahBumZbiIKRlgzOQcjLCAKOajj5V1+Y
 uL8mYOZmcIBJilixB9XJhB7x+Wp1RZJtJlNsvLs55CH6c68XWISE8iMMeptSBBNCWram6eBqQr0
 ugbcSrBoHnaNa3lniFssKZqkH/8FXV9JljrSy/X4gZCoAWLR+U+vUpBSghlDSMJiVh9xOSlocNB
 hx5UUvhdKFemNiw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3FF62140005
X-Stat-Signature: tot9hd3r3egge56onkzk989mxfwign5o
X-Rspam-User: 
X-HE-Tag: 1781032449-921518
X-HE-Meta: U2FsdGVkX1+Mym3eIEXo6+Dh+LaMaYz/cRCqK8UhoZPFyUNQHOvFggahBvpeQXu5yzg+F5hoaj9foKvaZNTscLD1NjtyC++ycxcWHYsZljvdFMvgkZlWhuZRjg1qjIHV7mqfCpnx4w+iIVQl5UWJ3oDAU9OyjVFjsAGqiyJCDfpzfd8g9bcxl9VzHvPAV4TyZjxtEG7uO7VRO5z2f4Qkp79FtJXn04DCIzOUWshUyofkRJPYTGwnW5c5KILk3mhiKhAUdxS6klS56jrZBTnhF7vB2SLnvUx7cDz7fgUUDPRjmOUiGxQY4/dF56jeQ3loadY39RGqUSRbN3wSI0+/NTjTOcTrOKyxlRaKkIpZfmgYb2m7/sTGpGr7ii3FLpNGwdJ69jG9IqspoYXyKJ33BMlF6UTq0QYeTpn56HjxFAqgzMkdmje3fOkv3RJm0dloQjyVA+eGEcYBVrenL3hAuUW/Q+IO7GC3vRqeZuxzmk+wBKW0Yj0A1Xv9uGHwyC/NnRWcqO/gIdMp+eMmjGIslCUbxoJCjJBdFuqVG9Q7TI+Eo2A9QmN4fXHsMlVlx2g9/jK8nxmRh7WtCCCaiIvU9tJTmfMbZOuc+BQakuO6BJYxd232uUX2Z/CYRhCY7HtBsB5s+c6OGQt6j/eljTWgavzoL7v3ezpb2KRP7qN/Ee0OC08oi37OOqH5dfhLtP8yIpAzNMUGA1xGEta/awNCBnADNrEAdVnHzk3cRDEwd+igRez6ghoqP5816zQsY6VA3NFNoKUPkNzR/jPzTBzaNFv4jKVjq/BMfp0TV+b+bZG2AoOZahU0aTZprwT8qxLvqWCEX2y+pAgtvbbFwMh7c68RUkGnHgWi+YBwBKPZlFjYviw6UnBb8A+tuVIIt/J+JxVmcUgNjtUo5rE24fFd0MVasXzUx3QM49CO2Ikse+5TsMa3fvOOnENtM5aChH9VZxOM22ajI5TJwrzfK1O
 gH4p1xoN
 qmih/KpO5CAkJIrhRsjWJvLxeQ3oeHNXMtn4y+zixXTF9M10oJ0hhuKSwzRM3PyBHyY6xg3DywBla8PzHFkMF2KeqwKWmu9eIhlXoxyrJvYkTiVABsCVkVf2R4aB3OPNirh3t1/u8+JTY1Xhksh77uvyDNngHgUTegme6VcTqFcIpQfRPh7uAW/hwI8GPlvahGgcQjsZcMCXyWfJzxgxBCJemYmPAOuG+4LcAOCY97kOFh/6xqF7i1EvLHLwP0TqxZdTufhB/Q4viloqmC+zNs1WpwaFMi65lWD4Gb1FThIx1a2jn2NGOqbpJnzX364oayqouF5rpAeynEV3PJaOckrH3DDFADUBp+5ePSSFLCp3tkKy/C3H8F9RJvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change the return type of `Operations::queue_rq` from `Result` to
`BlkResult`. This ensures that drivers return proper block layer status
codes that can be translated to the appropriate `blk_status_t` value.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/rnull.rs       |  3 ++-
 rust/kernel/block/mq.rs            |  4 ++--
 rust/kernel/block/mq/operations.rs | 13 ++++++++-----
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index bb8c4df08218..6ceba23a4d3e 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -20,6 +20,7 @@
             BadBlocks, //
         },
         bio::Segment,
+        error::BlkResult,
         mq::{
             self,
             gen_disk::{
@@ -595,7 +596,7 @@ fn queue_rq(
         this: Pin<&Self>,
         rq: Owned<mq::IdleRequest<Self>>,
         _is_last: bool,
-    ) -> Result {
+    ) -> BlkResult {
         let mut rq = rq.start();
         let mut sectors = rq.sectors();
 
diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
index e89eb394001f..503623267b19 100644
--- a/rust/kernel/block/mq.rs
+++ b/rust/kernel/block/mq.rs
@@ -64,7 +64,7 @@
 //! ```rust
 //! use kernel::{
 //!     alloc::NumaNode,
-//!     block::mq::{self, *},
+//!     block::{error::BlkResult, mq::{self, *}},
 //!     new_mutex,
 //!     prelude::*,
 //!     sync::{aref::ARef, Arc, Mutex},
@@ -90,7 +90,7 @@
 //!         _queue_data: (),
 //!         rq: Owned<IdleRequest<Self>>,
 //!         _is_last: bool
-//!     ) -> Result {
+//!     ) -> BlkResult {
 //!         rq.start().end_ok();
 //!         Ok(())
 //!     }
diff --git a/rust/kernel/block/mq/operations.rs b/rust/kernel/block/mq/operations.rs
index 01917ef213d1..b9a2bf6592b3 100644
--- a/rust/kernel/block/mq/operations.rs
+++ b/rust/kernel/block/mq/operations.rs
@@ -6,10 +6,13 @@
 
 use crate::{
     bindings,
-    block::mq::{
-        request::RequestDataWrapper,
-        IdleRequest,
-        Request, //
+    block::{
+        error::BlkResult,
+        mq::{
+            request::RequestDataWrapper,
+            IdleRequest,
+            Request, //
+        },
     },
     error::{
         from_result,
@@ -82,7 +85,7 @@ fn queue_rq(
         queue_data: ForeignBorrowed<'_, Self::QueueData>,
         rq: Owned<IdleRequest<Self>>,
         is_last: bool,
-    ) -> Result;
+    ) -> BlkResult;
 
     /// Called by the kernel to indicate that queued requests should be submitted.
     fn commit_rqs(

-- 
2.51.2




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DADC6CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:17:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EA4C6B0122; Tue,  9 Jun 2026 15:17:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49A846B0125; Tue,  9 Jun 2026 15:17:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B7246B0122; Tue,  9 Jun 2026 15:17:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B7346B0122
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:17:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CCC1DA0712
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:17:23 +0000 (UTC)
X-FDA: 84861332766.19.8A5EFFC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0F6DB1C000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:17:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XRZMzO2n;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=67YOcpbRpSvyeMAWDdHjO8J84Lo+TPp/ZYE9AcqGdYc=;
	b=ylY0vTArOk+XU2yy5lm3DUOOjz+lbaFg9+qwjFsQcxkWAsqhkI5BsRI98m6vD7C18vy0Xa
	nVtdy4oXy83TTeExmHAsAttNWDP18l3VjLk1Ju38odbJ1b4Jz3kUP5vgzrDmNZMdQO6rJO
	bWwrXVEwepHYmTMYXlerzsd8BN7FbD8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XRZMzO2n;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032642;
	b=FnJOtpiJPaJoYW0HFT04z1Oxdq14GY/qMv/b/ABH9yMAuBxEtwF8dKC2SBinaWYQ9DHJcU
	YOBOEAg8awfw/GZ/PzIMQs05L/L75lTbrk61b3j5c/5i0aKBieZHEWQWCYNS6D1paG+EzG
	N8kH/2rVv8Tv5gPTdvaB6SzJJcrjpFo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 649A643982;
	Tue,  9 Jun 2026 19:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E801F00893;
	Tue,  9 Jun 2026 19:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032641;
	bh=67YOcpbRpSvyeMAWDdHjO8J84Lo+TPp/ZYE9AcqGdYc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XRZMzO2nzYm/oXccW/HVI5Dk5QvbHo+TtdY3/UR6W3/B08le5NVKnk551rf9JD85Y
	 5LTO9PZTcuWeC8lUNCkMTwYZazubh9vN0OCO78aOBhXmKkds3ilmrKFObR0ZDY865T
	 yZJz7FAbsCVk1N3mDDlXCcHJg+liy+vXk2QRmWD7flbbPJO/mJT37SlvO3+xHV9DvV
	 XnqNOhi3ANXS3m/GB1H+XxwB1BYDfiuIaywBqfOWrDsRuSUijJEGoWVNKWyIu9VTIs
	 kjqF+7h2oqA9wncI7Smy3PRK1TQnKdSv+yrdMXHMx1g3Z34NfCrdb5adK8sXvtzyxD
	 xO0iGaW3vjokg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:04 +0200
Subject: [PATCH v2 25/83] block: rnull: add no_sched module parameter and
 configfs attribute
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-25-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4147; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=O+jl2F2xzeizmKeEFp6OfGRrahz8fj9S64rA8TqH02s=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTL8JCj0D2bsrjx8If5DE09F4g67MwSLHApp
 73TkQ+1MHWJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihkywAKCRD6UCkIqsW9
 0J9pD/0ZofgGrMZ//q3Xy/zRBs9l2Vn3GJKNw929z8MAETbFVoorBU4y/U2yUDQdOC/XDmdXoWe
 4Nad5uh/xRXZLpOBiImot9EG5hP6Thp9W3yxSZid30wvFnEQmd6AFD4aeT6XxuZCKQo39OI4dVM
 ARB1aecc9qrZoBbKU1ENcIcdx62S/9bYRzzNb4rHA2k2ud8A1qLJOpTHSY/nhLm/tUd7RyyT4wg
 +R+I6e0hBErrB8mvUDaWQqwH5PJ3XbO/ZpJLnPzjyTgaIO0rOvRdnSBAs3tc5Rv1rKWDSSk3tDs
 G8g+HH+/i6eikJIifHkiCzoz57AUBNGhuoSdcPuXIKF93tV78JMecTIeTt1zHa/F8ww5WE9GFlz
 0weMV4RIuJDvJ8j2DibdYfEBBit84BFLl3cDiqKVDcdwn0fyrPPatCCMWKnO/uEf4LbW950oFWT
 YAmEGjCQrE3TEs8aB6Y8MR1fUOvEkT4MVsHWlTL3LKbgfImUIaZFxI5rgVYF3f/QImdzmCgbFhF
 JMOmNxi6kPiilGy/70601nmr17+xmJ438F5FASSqQ0w5UPM/xinWQNrjAiyQcZHaVukg/uVQ4ni
 VnVwDn8bBaoX5wZc618giL/7vqrVikGfPITYl6S9Zw7UC9rA8WMOlGk3O41AWuSmGlIj1mDiKu8
 aypOiV//2X6dgCA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0F6DB1C000A
X-Stat-Signature: dqx8zx4ttetp97e4ehogimfh8xbs5uht
X-Rspam-User: 
X-HE-Tag: 1781032641-460765
X-HE-Meta: U2FsdGVkX18Kogruqnzy1qoP+aMsUeEPyPjWE9Ghur08Co+niaufYcpUofpMVca+fWWn2ftBqD7eHS7G1gICwmclyz7jSVrYrRHwAs8k8uPja1YmJftzWA0NImOLnnMG66YXJ7eNE0ZXABTJl3DfikxKvxokdiBnyNeF5muLAQlKQ+j97DOZOUWLBqx2HAuGIKbz8qlg5QH++vE+Igg07njweqRyEAte3NsiRvMYrGzQq6cJdQt8j3K471Q1iPZ0qk9Pk9pTopTblVKE4TQ+6y8vk1C2tbN8ekgLWbkoVR2P2hvY0RIjEzm3C4z0ZAkncqosTAA9EkLELGCpTABNM/f+3eIgpDh1Iv06PWsyR/1Nk4epSJcb1MvqGgVP9Lij/JbVgRLaVrcW9SdA30PxZixt8r7DIVQfojyG/djsRzETRBMq9vayRiFDr/L5eKwTfaOMZE4bXeW7u9vW/n8hncvB9UpQaWj0/Lu8R7SSYLrfnRkiSe6tqlsy2M2vfEO+Xf/NhzZ7YukAj1Lwd9+qhMZvq+0ooSB6Oic8NE7U9tmy6Q9mZSINTYcYGcWpCJpBpkCcI2G4a5icPB3Vao7uKsWevx690atRkbGoy+45DMMzZGBt/U+oAoR4Q9j7JlgHr9O0ZwgHI7Cz4PicfXj7csE0oBvR0m2Tq2tRAgsyo/aab6VL8knw8EbCU24EGtTH7DfLAHltEJaCMKBGRmv1YjKsw32uUhWLfpmzmLV+iJ0RnuUIj4lTZyt5gE7NAqBZtB3/Zf1N88guZJ/YOxw3iihP8na1X5/Gw7FhlruBoMr0xQbYIhCIhc9SotBc0bFJ8dqnj4mJKyxjZNk5mbXRDwxWNgGcJr2tILsm36+VXBgko7W3bj2EJ2KxrIBsfQ1PIAF8J1h4xUhM/OXi7yTvu/5SsbdmajMJpUPEUtxoU26K0XQLQR8GsrShLT0Wn1AzqBqA+WykH8qXTobh+pv
 jFM5tQah
 38Gv2wUX3pLhxTBZpuySq7GcgzDGRuKIH6rjU8BxOu0Lg3QRNk5KzPHwU1SdjpmaS2x5/dtZEBYS2KluJ/qv/kPL5vVDMLqkF8mFNxUd/nalT5jKOBcI4FQGSKuxqGPBXrMWjDnaKifQfaVF5L0XejDFu31ZtbLK48kkLRZVNoI+ELf2dlJTu9KmpqcNenigt/jasZBwLc7EKyIMphT+Prj1QTabymyKd2sOa1VlqAtmIEK+4XOzGg41FGwtrjg4kxrDISHMgzWmYW1UApkwwGMEPUfN1KozD1c03yaEzZBJoiVBHd4YfDhKH7DApIodbjFpS6scoosVAIrO02kTIxUzMwywTUvwG2udiIF/knRJ9rymBLlVoisCAww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for disabling the default IO scheduler by adding:
- no_sched module parameter to control scheduler selection at device
  creation.
- no_sched configfs attribute (ID 11) for runtime configuration.
- Use of NO_DEFAULT_SCHEDULER flag when no_sched is enabled.

This allows bypassing the default 'mq-deadline' scheduler and using 'none'
instead, which can improve performance for certain workloads. The flag
selection logic is updated to use compound assignment operators for better
readability.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs |  6 ++++++
 drivers/block/rnull/rnull.rs    | 25 ++++++++++++++++++-------
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index e47399cd45a4..d9aead646ae0 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -94,6 +94,7 @@ fn make_group(
                 use_per_node_hctx: 8,
                 home_node: 9,
                 discard: 10,
+                no_sched:11,
             ],
         };
 
@@ -115,6 +116,7 @@ fn make_group(
                     submit_queues: 1,
                     home_node: bindings::NUMA_NO_NODE,
                     discard: false,
+                    no_sched: false,
                 }),
             }),
             core::iter::empty(),
@@ -183,6 +185,7 @@ struct DeviceConfigInner {
     submit_queues: u32,
     home_node: i32,
     discard: bool,
+    no_sched: bool,
 }
 
 #[vtable]
@@ -217,6 +220,7 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
                 submit_queues: guard.submit_queues,
                 home_node: guard.home_node,
                 discard: guard.discard,
+                no_sched: guard.no_sched,
             })?);
             guard.powered = true;
         } else if guard.powered && !power_op {
@@ -322,3 +326,5 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
         Ok(())
     })
 );
+
+configfs_simple_bool_field!(DeviceConfig, 11, no_sched);
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index bdc05b3f6072..cb5b642f68e5 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -30,8 +30,8 @@
     new_mutex,
     new_xarray,
     page::{
-        SafePage, //
-        PAGE_SIZE,
+        SafePage,
+        PAGE_SIZE, //
     },
     pr_info,
     prelude::*,
@@ -110,6 +110,10 @@
             description:
                 "Support discard operations (requires memory-backed null_blk device).",
         },
+        no_sched: bool {
+            default: false,
+            description: "No IO scheduler",
+        },
     },
 }
 
@@ -148,6 +152,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     submit_queues,
                     home_node: module_parameters::home_node.value(),
                     discard: module_parameters::discard.value(),
+                    no_sched: module_parameters::no_sched.value(),
                 })?;
                 disks.push(disk, GFP_KERNEL)?;
             }
@@ -173,6 +178,7 @@ struct NullBlkOptions<'a> {
     submit_queues: u32,
     home_node: i32,
     discard: bool,
+    no_sched: bool,
 }
 struct NullBlkDevice;
 
@@ -189,13 +195,18 @@ fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
             submit_queues,
             home_node,
             discard,
+            no_sched,
         } = options;
 
-        let flags = if memory_backed {
-            mq::tag_set::Flag::Blocking.into()
-        } else {
-            mq::tag_set::Flags::default()
-        };
+        let mut flags = mq::tag_set::Flags::default();
+
+        if memory_backed {
+            flags |= mq::tag_set::Flag::Blocking;
+        }
+
+        if no_sched {
+            flags |= mq::tag_set::Flag::NoDefaultScheduler;
+        }
 
         if home_node > kernel::numa::num_online_nodes().try_into()? {
             return Err(code::EINVAL);

-- 
2.51.2




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 500AECD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:11:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B98716B00A6; Tue,  9 Jun 2026 15:11:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B702A6B00A8; Tue,  9 Jun 2026 15:11:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A85F26B00A9; Tue,  9 Jun 2026 15:11:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 971496B00A6
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:11:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 57CF01C2752
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:11:28 +0000 (UTC)
X-FDA: 84861317856.11.AD6BC1C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 82ABDC0009
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:11:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZXDYoeVZ;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Genwro56cY+UIXWxa1GkqiC9jUD33al3dVJcd/tkiNo=;
	b=Ffpk3WWqBw+8IpuKOO6gjBoat962oP5pVLDQYu+QX+ontf7VFY+L2+Xr6UWH4qW+g6ggyi
	d45SMzexPqdnWxrkeVDoySbKNLV4IUvXcD5YO/8i9a5Ngh85OY52UgWQqI440739j5aV00
	5tZPe3zog6fDtphYbjZPK6xm/CdNzCI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZXDYoeVZ;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032286;
	b=LLYqG4s4ir+kgBqrszyAWX0mTWx/bTsyswTQgg1m5cAYK21OJfbkUR9z45LZP9uil0o2Dk
	/TNIpipmcsJWbQcy0W/WMBGSO+ySjbDiBw4b9Ko/5ehyYWPP19fRqpQmDuHYUbvexD4zbL
	e2eTCLwsnMkF4Z4SeJeIpcRgo0a0aXM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D372B43A5B;
	Tue,  9 Jun 2026 19:11:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C771F00898;
	Tue,  9 Jun 2026 19:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032285;
	bh=Genwro56cY+UIXWxa1GkqiC9jUD33al3dVJcd/tkiNo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZXDYoeVZKI30KjnBvSohk8mjBZd6jwRPYFqkUn6nNY0zNisn6gre1LlbDLVxtgxmf
	 RcGpnkt3BgKupb9mb0Y/848Os7fo6XAmFreBrYorbRAogCKdFwYtGRqH3fEVOMntj6
	 o+Hgu7cbfGCyJiY7bN7CQFgvxaCns0ZUIeGv5p64GnQBuOIWZhw73oAJw4xnaTOka6
	 3S7I+6Z4RB8UWZtVdQAzUBXdDzRVMhf/4yz3nMPJTt0znjKbaD+Z6y720cdZo8Cvzm
	 IJZwVFC0UFK+a6xGbaWv75tNxuAwnyeBy8tn/fRC7fkY47aYPTjyG7xaf9Cgc2kN8B
	 oiS3/7pGuo5hA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:09 +0200
Subject: [PATCH v2 30/83] block: rnull: add badblocks_once support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-30-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4985; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=qZlgs0sK+HX7M/TrC9q/wYE8rUGAPlyTT8AOUXdX4Yk=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTPGfHlAiKSZ2KoOX7dAG1VcEApOjObDwOa2
 1pRADm+b/iJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihkzwAKCRD6UCkIqsW9
 0LTZD/wKvry2ERjhKHe30Tz0FYhDCvD5njsXCp7hpiJ+vTZbjExI1h7XCB2ebt/+VCJz/3m856v
 A8nO+NsPm8ezrty4X/Pv++6IRkoxFQJI8NDKjqNQde1FrPl1UY/5uxlhtXgEKqDy57jDFjs3Wfc
 y3n6Xae60waSpqvVrOH5T9Fkk6AQI7loOr+L/4CQuSDeFKVblEhugCUFC7voOocOx6sMSvC+6gS
 n7LI/bqtdL7SOoe3iD7APjUqn0ulJ/7/imTZqsGIEPaSdD8UE8ft2709LldeVqHMVtduZm9cROI
 +qXh4ariZkXnuOengqFXoPHFSUfiboSdjFmuyf6gk+xN8ZFfopfuwDLBjzzwG30KFbFcjzFFzcq
 SrVliLC8au1PDN1SPHSquoeHq4RL0wZEMLt8B/HhyV53jqgVJMRL58iL9a0dACn1eRG7w7gPwo9
 NihFdSZNh2q5gBHaE9e4D3hp84UqHfcPQnFiyimsfjVujTs0KIFsC7o5TzZ60v2W6ZRtwFGhDJQ
 fw31v3XM/B3kVAc3oaK8S30Ioy/ed8H7xbRSv8eFWVn1+vTc5qnF/OGzhJSBtPvpZCJpuJHyJm/
 wL8myMhgNUsDHAw90318RVeRb76yA0xxrb2DWdBLEDcfMQ5NWCqAQmTcG2jGnUlXhxV3JrqT5u1
 xeFKzNyVK8MqfHQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 82ABDC0009
X-Stat-Signature: 3fs91qdaa4hie86riptp1qnpzn6p5x14
X-Rspam-User: 
X-HE-Tag: 1781032286-708513
X-HE-Meta: U2FsdGVkX1+hiLVrpTlrFEBp2ZiVzeqTEmohY6D4bU/25Ns1GXfcYgpbJDFy2ayWG5v/Yair719cTUN/tYDZXNPSXpUXLYFPObfmHZQZ8w1s1LcnzF48DwX1MiEIFAmGTnghCud9y+4z9loQYQbM66K9q1HClYApN9QKpspypCAhwGmF9IyPVdPRUrtu1ehUVM8YB6AQ/IMuRlT6dhexF/N8a0w+QuMjxJnoKl2tvIJB3Cea/hqD1s8y+8fsIx4UxlVtOrtRrzjEgn3Kd2SxtlDLxMs6b0r9xRCuNLFdAXRw4zzN9/InzJ0l8cAqn/J4OeK+kuI44Vjx672SIVXJWu6Ny26sSg8OBszlmsAnoGTIyVkvaao/mPAMt5il5wdOEW8dnRoNFMCy5/zGi6uibNb5W+ge21KX1sBT/1ZDiWEVChdRDsjTn8uqxiBnh11yVgg+4N1VrSp/kiDeVucp+TJog97j7fmVevofnV/RF4BtU28Ps4oLs2NxCDNFtZPjSea0bNyKf1ro/dsa42vSyaHDiMm8fBct/gaIhHMhFgSl7ofHfqQ1H9pk3VAqEzs84xpWptA28poLMsnpwZCiFoyU9EqtBigTXDybFUh1nPXEVP1xwZN2+kTciId4wGOolxdpO5QCaPqditdSZKw0yBt0pQr84jhZ115hWlh27jUu/LoEqhhveh+asGa45uwJ/67OCFI7t7RzlojGEQaqjq/eurgjCrLtZq17ONOvuwgk2L5XB/7IMQU8+u5Im5W8LEzT7hk4zM4bGfqJZHiyLamuViwaz3upBo552pUD9W2nG1gbcv72YzioNZXBRBTKCKDiQir1VZEdDAeWiJL+avhSa8UQn6co29qMgwHB4xjGoolCQtdaeqRvhMNrusdCltBJQlqQKkCWM4BkXWy0XiAZ6iNfSYmaipbubndnmfFxDirKwxv+K9D04/QOr/Ksc9FAYt5KqkQVkk20Qn6
 8Yjyz6Gt
 M35Yv7M7nskHblaodSZ/3niN+Kzjbn1Yd8LAhPu8rL/IFpUwTvA6bUJ0t1g5hHDGZaaRbV0s7PRnFE9rm7j9FMBhqsQGj7AbmQB4nu8zJwzW3lqAn8mNEFXYOW7uC9c/1E7rrR6DDFeqxaYe0tBIErRLNzMgvMxoaaM7h60hCo7/bekFOKkSwEfVMLF3RJVuEkLxFRJ1DgjRJ539pKpJc2IIR5EtrBbIiqFinWmvwLUNwc4vJRRXdYvnMjEnboVd7DhKWj9m0n7j4XSgT9UpiqjyqmAP4tBetWZ07Z7JZls77rw/S9LD0nGnvzOFi9hyDABAAT/Mj/jMAXULayRhBofwA0iJmIGl7j7Zn+aXWNE1W2W6heVRk+W+oMOWTuJ5KdBWN2fZtRHx21gRpPqd6kUW+g3jISdjTR7qt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for the badblocks_once feature, which automatically clears
bad blocks after they are encountered during I/O operations. This
matches the functionality in the C null_blk driver.

When badblocks_once is enabled:
- Bad blocks are checked during I/O requests as usual
- If a bad block is encountered, the I/O is marked as failed
- The bad block range is immediately cleared from the bad blocks table
- Subsequent I/O to the same sectors will succeed

This feature is useful for testing scenarios where bad blocks are
transient or where devices can recover from bad sectors after a single
access attempt.

The feature is configurable via the configfs badblocks_once attribute
and disabled by default, maintaining compatibility with existing
behavior.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs |  6 ++++++
 drivers/block/rnull/rnull.rs    | 21 +++++++++++++++------
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index 4db3ba26c2d1..05229ba9173a 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -102,6 +102,7 @@ fn make_group(
                 discard: 10,
                 no_sched:11,
                 badblocks: 12,
+                badblocks_once: 13,
             ],
         };
 
@@ -125,6 +126,7 @@ fn make_group(
                     discard: false,
                     no_sched: false,
                     bad_blocks: Arc::pin_init(BadBlocks::new(false), GFP_KERNEL)?,
+                    bad_blocks_once: false,
                 }),
             }),
             core::iter::empty(),
@@ -195,6 +197,7 @@ struct DeviceConfigInner {
     discard: bool,
     no_sched: bool,
     bad_blocks: Arc<BadBlocks>,
+    bad_blocks_once: bool,
 }
 
 #[vtable]
@@ -231,6 +234,7 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
                 discard: guard.discard,
                 no_sched: guard.no_sched,
                 bad_blocks: guard.bad_blocks.clone(),
+                bad_blocks_once: guard.bad_blocks_once,
             })?);
             guard.powered = true;
         } else if guard.powered && !power_op {
@@ -383,3 +387,5 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
         Ok(())
     }
 }
+
+configfs_simple_bool_field!(DeviceConfig, 13, bad_blocks_once);
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 90dbf318c2f8..5486eb6dd921 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -159,6 +159,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     discard: module_parameters::discard.value(),
                     no_sched: module_parameters::no_sched.value(),
                     bad_blocks: Arc::pin_init(BadBlocks::new(false), GFP_KERNEL)?,
+                    bad_blocks_once: false,
                 })?;
                 disks.push(disk, GFP_KERNEL)?;
             }
@@ -186,6 +187,7 @@ struct NullBlkOptions<'a> {
     discard: bool,
     no_sched: bool,
     bad_blocks: Arc<BadBlocks>,
+    bad_blocks_once: bool,
 }
 struct NullBlkDevice;
 
@@ -204,6 +206,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
             discard,
             no_sched,
             bad_blocks,
+            bad_blocks_once,
         } = options;
 
         let mut flags = mq::tag_set::Flags::default();
@@ -246,6 +249,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
                 memory_backed,
                 block_size: block_size.into(),
                 bad_blocks,
+                bad_blocks_once,
             }),
             GFP_KERNEL,
         )?;
@@ -416,6 +420,7 @@ struct QueueData {
     memory_backed: bool,
     block_size: u64,
     bad_blocks: Arc<BadBlocks>,
+    bad_blocks_once: bool,
 }
 
 #[pin_data]
@@ -465,12 +470,16 @@ fn queue_rq(
         if queue_data.bad_blocks.enabled() {
             let start = rq.sector();
             let end = start + u64::from(rq.sectors());
-            if !matches!(
-                queue_data.bad_blocks.check(start..end),
-                badblocks::BlockStatus::None
-            ) {
-                rq.data_ref().error.store(1, ordering::Relaxed);
-            }
+            match queue_data.bad_blocks.check(start..end) {
+                badblocks::BlockStatus::None => {}
+                badblocks::BlockStatus::Acknowledged(range)
+                | badblocks::BlockStatus::Unacknowledged(range) => {
+                    rq.data_ref().error.store(1, ordering::Relaxed);
+                    if queue_data.bad_blocks_once {
+                        queue_data.bad_blocks.set_good(range)?;
+                    }
+                }
+            };
         }
 
         // TODO: Skip IO if bad block.

-- 
2.51.2




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77E53E63F1C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 01:02:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C2426B00D7; Sun, 15 Feb 2026 18:46:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0803E6B00E0; Sun, 15 Feb 2026 18:46:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE2756B00E2; Sun, 15 Feb 2026 18:46:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 383166B00D7
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:46:24 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A87D11CDA1
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:46:23 +0000 (UTC)
X-FDA: 84448327446.13.0BAE241
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id DBDB3C000A
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:46:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kjCDYQsR;
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GubGWexe98VLKWkuzrpnQwrAcjU6Xv7tmoXXxOPIYCo=;
	b=OPbYWqD4iY9fTDaXXjOJaHmB4j6njS0G6ZvWPpMCCuM0v7ANcowu7w1VkSaSH/KOXqEeCb
	yUDm9kutV0XQw80Oe2uKwI41dB+shkUXgr47+ENyUHQwCJK567hMtwxr9Qwzfts1UzZJga
	gj3HP69GB5PuF7S0qG4SJXQ1hdwCKBw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kjCDYQsR;
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199182; a=rsa-sha256;
	cv=none;
	b=059u2g7HOiLhXdZAajz/oRdgVJoPSqjaYLanxVcjCf1mXqVYneFHczY3kOAZKjtdHMa1W+
	VkkMZwhYTMUEue7lgJQvRhFMMyaaSTAra5skXAIItYNtur+3w8kdrraxo/OMK1hcKPIphu
	OHf6sNSB3qyDrn/UY2mtCdOVNwgQlNA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E8A641858;
	Sun, 15 Feb 2026 23:46:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FD6C4CEF7;
	Sun, 15 Feb 2026 23:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199181;
	bh=9wLxYaTCPfOG5uonTZ2h8ocU8FWs+hSDrEKcM2sv5z4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=kjCDYQsRlhCQN6obSBw1ii95Qd4xqZ2D3oZ1pMKrFWp3LbPJEa068zb6SNYsrLyzl
	 RNtqfQABlx0D/geY5TXUSQ0unzKd7ZTFl8WrcQ6ptjFu3A7zKaqi2rHelGAxlnSd+D
	 J3eLNHh7W6AAppxKG9zzibmJ3iLxifuLzA7d+yJ7P4tFY8tPnGTRQKZ30Y2RvuxtbT
	 5aAU2fp1DgwaHG2wxFp/FdWtUMtAu/NBUq8CY2UY5lei5riX8DMBInCnZ5ry7D2sfd
	 9iQrZXLs9GlIXjr3wAh1d/iIpmUWJ6nvaC/yLvGJXKLavrqTYsAvNxCt1mLq6iK4Sp
	 nSEyBV6LaEO/g==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:36 +0100
Subject: [PATCH 49/79] block: rust: add `map_queues` support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-49-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3879; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=9wLxYaTCPfOG5uonTZ2h8ocU8FWs+hSDrEKcM2sv5z4=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhHteQM6fc3Iu+s7ErTmW5+zxHdbuM7v9MUt
 WW0qbMjDayJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYRwAKCRDhuBo+eShj
 d82UEADCFQq4xg0GLRoFbDArGbCjq1pYimjtXweH1jUHAlgJbGGDkikwcOVePhVAnaq0cdE5BuY
 FST4N7wGwn5uDWVPQjXpCx3F0A00D312QyAmD8cvTc3vOP3J4jJptfyTx18my0TG3l/QpGh2k6+
 VRnt/4++OOUgxoE8WyWXsHSiexrgbP5JGRTRiN48GSZzVsD+hMHSp/+pgp7Xcl0BR+8bGdFiCQm
 LGiYwXAUL5k3Gqj/IYOdhE00o/x0U8DPQMfes514MGFteRl7clkgSvYEFKWth04xf/u7Ko2u7Ku
 9RZFRbrxsRa66tuTEpsFIA6IX/RwvMKZoXDegWKZ8M0TsY7LUUI2V7aNC7bnV2Xv0mertjEooNo
 Ua16efkXqh+Tx/mi18AdzA0+qemfM30vBYaWJ9xQDcAbSVCfSq+gB9EFg/ft+MzN7AS9w2UdGdt
 EJyQcDaAUyDI4zCU7pPSm/5GHu52+/vVcaHnTHT8vGfMk1tFZQ4t5d9DTiAS11OUgBMHJqhQEPX
 F2LkCpJ5bsvfp0U5L+/nuiphEGkRmHRxMhE4MQ2vGaAWhI4jUEAeiJC76C5ficBetddzfL4fS+U
 ZIk5m9JLWOTZyF3nP1DNE0C1fLiAMjBgV3OOwQg8Bp5j7v0btIbGpJUHAd4dzkHYMBmRMjTb/gX
 QQhP/zLigZgzM0g==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DBDB3C000A
X-Stat-Signature: pfjjeciz978to4tztue8dbfk78chzob4
X-Rspam-User: 
X-HE-Tag: 1771199181-635426
X-HE-Meta: U2FsdGVkX19xWOi0Lt6w+YqOxBK1om4BBM/B3u/g8Phm82TF3erG4OUBrG7kfB/JRw9MJxNNH2DhNQuaCHxi9uVohuxxfg7j7w8hC7gqignIWtSXfEHdtgXOyMhdzTh4enb487S9kM8bNMDUDntwW+fExTqMkBhHb8KnSd1j0XgyVy8boaORTaPxSneNzyl4A3aP5ojQGwlGeRKwi6pH9YPPUduKfoExZSSa7SsnGJGZV5UMS7AxoaUr65qxB25A1EyEDJVARjYbDhzhGn/BXseVTCI6Fl1pacSyOK4aDByU0MxxWsLZT6U2BIcLkhebQx0lTn6gjunsguGUoMfkxH9KsKUs6HQETNbBQ03Iq2mp1ZLEDPDpYS0Ma/z3TzQJrkj0avflz0QsdB0H8QV9ubiv8nLuzcKyq1Lbr/AIYNW/KDKRlEeel/mmDaKv2LK0GXsISzHkeg+eYivRhE0Ly0FHg6CQlYui1dVToEyOGbLYrj6m8XwOclBRGb74k7SQoLJY1qtVz3nJtYiBecrD0KbtnlK4sApV7lDvdqYjEwDLG/MUbqX0fT+JSlSRz7yZc+06ly1xn9HAQzzmLMfxLwMvUQDDFXiIRho1j5jdL91pGDShQt6t7HCgRhqhsS7ekuWFXdwKxcsQujU/eUuCQksJy4akCkf3gB7jFTFC4vVNdRPoeQ51vUq/qnvLQa0h6izomLisIiWy+S2RrhHRZa0N93K/F6cYxIwX9eY1m/dM5idtWTdietxhHf3yzLXHem379xkIJ+qFFjIksRR5A1bvNYHp52gi2FmnkDrIH/7qWb4DEGf8Lb7OqDiGP/XhVUDPVABOWbFB0iMoZC80PaqUd7+9XGhlaAVAag3az3lzOkwabbsYZLqkYLSPIm30ze7sSwN+5Fn2YpfEpbimGfgaU8gr/av5rAi12zgPwTJsEROOo26ZZNp0WT2nVwtOpDmKYBbPCpE4t7ZxaEf
 ue9rr2ek
 VeigV8C9qDONIALjZd1FlYcMKIyhgC3MrDJWVkv/GqceOQFRqNAmsO26LGxJTlC/Hf/BjO9XXjOqheMkhfW9B5OzmmJ9iETKAUMgONhsWEnjwnljnH/kuitkQNYgWT0bMTwcy+LHBIh/bdWIDxM6g/9S8Heg+oD6Qp90zW+umdEF44FAtaDQYoy5u6HtMZxHPPNH7aUArE1GgyolJbg8LJO/ytpJgmMG/6OlNJsVFAfIJ3qpQxIg+NDGQbUIEd4tQXAXH9kYuhigvajB4n11eS0N9OyG0NJ4ey5Z0TvNqmFsieDJilL2jXz5y6MONkdFetumOSuE9t2fQoIwXCIOSHI44CuGse+c4VVy+aSW77RrLb7CV2MNFOrb6K21+HmHLmVdSUSWTfsQIiT4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for the `map_queues` callback to the Rust block layer
bindings. This callback allows drivers to customize the mapping between
CPUs and hardware queues.

The callback receives a mutable reference to the `TagSet`, and drivers
can use the `TagSet::update_maps` method to configure the mappings for
each queue type.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/operations.rs | 28 ++++++++++++++++++++++++++--
 rust/kernel/block/mq/tag_set.rs    | 13 +++++++++++++
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/block/mq/operations.rs b/rust/kernel/block/mq/operations.rs
index 3f84ebadec86b..017fad010d174 100644
--- a/rust/kernel/block/mq/operations.rs
+++ b/rust/kernel/block/mq/operations.rs
@@ -8,7 +8,7 @@
     bindings,
     block::{
         error::BlkResult,
-        mq::{gen_disk::GenDiskRef, request::RequestDataWrapper, IdleRequest, Request},
+        mq::{gen_disk::GenDiskRef, request::RequestDataWrapper, IdleRequest, Request, TagSet},
     },
     error::{from_result, to_result, Result},
     prelude::*,
@@ -101,6 +101,11 @@ fn report_zones(
     ) -> Result<u32> {
         Err(ENOTSUPP)
     }
+
+    /// Called by the kernel to map submission queues to CPU cores.
+    fn map_queues(_tag_set: &TagSet<Self>) {
+        build_error!(crate::error::VTABLE_DEFAULT_ERROR)
+    }
 }
 
 /// A vtable for blk-mq to interact with a block device driver.
@@ -394,6 +399,21 @@ impl<T: Operations> OperationsVTable<T> {
         })
     }
 
+    /// This function is called by the C kernel. A pointer to this function is
+    /// installed in the `blk_mq_ops` vtable for the driver.
+    ///
+    /// # Safety
+    ///
+    /// This function may only be called by blk-mq C infrastructure. `tag_set`
+    /// must be a pointer to a valid and initialized `TagSet<T>`. The pointee
+    /// must be valid for use as a reference at least the duration of this call.
+    unsafe extern "C" fn map_queues_callback(tag_set: *mut bindings::blk_mq_tag_set) {
+        // SAFETY: The safety requirements of this function satiesfies the
+        // requirements of `TagSet::from_ptr`.
+        let tag_set = unsafe { TagSet::from_ptr(tag_set) };
+        T::map_queues(tag_set);
+    }
+
     const VTABLE: bindings::blk_mq_ops = bindings::blk_mq_ops {
         queue_rq: Some(Self::queue_rq_callback),
         queue_rqs: None,
@@ -415,7 +435,11 @@ impl<T: Operations> OperationsVTable<T> {
         exit_request: Some(Self::exit_request_callback),
         cleanup_rq: None,
         busy: None,
-        map_queues: None,
+        map_queues: if T::HAS_MAP_QUEUES {
+            Some(Self::map_queues_callback)
+        } else {
+            None
+        },
         #[cfg(CONFIG_BLK_DEBUG_FS)]
         show_rq: None,
     };
diff --git a/rust/kernel/block/mq/tag_set.rs b/rust/kernel/block/mq/tag_set.rs
index 600c9c6249123..330ff28c91507 100644
--- a/rust/kernel/block/mq/tag_set.rs
+++ b/rust/kernel/block/mq/tag_set.rs
@@ -89,6 +89,19 @@ pub fn new(
     pub(crate) fn raw_tag_set(&self) -> *mut bindings::blk_mq_tag_set {
         self.inner.get()
     }
+
+    /// Create a `TagSet<T>` from a raw pointer.
+    ///
+    /// # Safety
+    ///
+    /// `ptr` must be a pointer to a valid and initialized `TagSet<T>`. There
+    /// may be no other mutable references to the tag set. The pointee must be
+    /// live and valid at least for the duration of the returned lifetime `'a`.
+    pub(crate) unsafe fn from_ptr<'a>(ptr: *mut bindings::blk_mq_tag_set) -> &'a Self {
+        // SAFETY: By the safety requirements of this function, `ptr` is valid
+        // for use as a reference for the duration of `'a`.
+        unsafe { &*(ptr.cast::<Self>()) }
+    }
 }
 
 #[pinned_drop]

-- 
2.51.2




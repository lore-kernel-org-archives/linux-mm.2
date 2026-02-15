Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAF79E63F1F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 23:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D9D26B00A6; Sun, 15 Feb 2026 18:42:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B0306B00A8; Sun, 15 Feb 2026 18:42:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C7B06B00A9; Sun, 15 Feb 2026 18:42:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F3656B00A6
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:42:12 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BAC5B1B1A4B
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:42:11 +0000 (UTC)
X-FDA: 84448316862.09.E53432D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id C3183180006
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:42:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CU27ZXms;
	spf=pass (imf24.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771198929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lfCWFz44Z29iUxzWfdc41d1nko7Rqw6DJ9fiCfqwBNQ=;
	b=1S80wmbjLfd9HyimXN+WJsRJW54jFPElhbpiPy7cFzfxSpSiRL3bIi43JPVFA7dQIfQR8K
	I1cAqtKxKNArwzmnm0T0rK7AdsZ7FAdF3ldAQtknBy8g6GGk3dQcjdAl7E5Ecqyl7trskL
	O+WdaxxhAjGXNNfO2p4OvnxzRUeE0cA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CU27ZXms;
	spf=pass (imf24.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771198929; a=rsa-sha256;
	cv=none;
	b=LYue5NaCqM7MFGUm78GYE4jOnvMwJ3vvYXbF/2fr+XTIDEuaIS/eh0g8dh7OlwPMiQxES1
	YDjk6QW2o26TF7gFmf6KntugmNCD2L8HFbbjW/rVv9ulf7ZwWMNCF7jt4jUrtdpSQmaPSW
	IDmGb7Lj0YkkSacncWhQIquACDkAfY4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D51DE402AD;
	Sun, 15 Feb 2026 23:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D6AC19425;
	Sun, 15 Feb 2026 23:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771198928;
	bh=uYEwg9qVRQ0NhWZcmlYe0zv8laqBKSDqB2tGW/RMct8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=CU27ZXms6kIrV7G19DfaAaAOwUelhCVipFwQDeCbX4VWn6wVJPDLJ3grDPzSnCtK+
	 KiuMpnyzd8owICPC2W0nqFdb5DrMTnIxEomPXMeWMm3QGk8Qp3tZcdom0FXNbB1OF3
	 xwp2ycZjZvwEnm0SbXFmmEx8fPkYkZN5dSSwlKMe1WpNA3bGiOWZ7mHerhivkeXudH
	 otqNDMK90oSKhrl57Wv9F0Iq4PyNxVeEhkJujbCXcvaVMxk2fhM7WPYnmy0J2J2rSd
	 omkM1H18JL/cwXlob4zMsBQ7RMTfe/1XOx5TpA5tlAHEbRBQbiQIXRYlM4rP29ymMY
	 h+cIgNNxzckGQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:45 +0100
Subject: [PATCH 58/79] block: rust: add `Segment::copy_to_page_limit`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-58-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2840; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=uYEwg9qVRQ0NhWZcmlYe0zv8laqBKSDqB2tGW/RMct8=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhPD1Vd13GaRkq5agX96n72Np4kCvlo5WLCD
 fk9Egr801WJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYTwAKCRDhuBo+eShj
 d7efD/wPEHMykdNbgIQEgFjD0g5u2LBnODSA52TqS+8dh9ONb7dkKxO6CM34Xdd5hZN9vKMUaJ5
 oyXEeVDHOLxk95g1hPvhVpYZ1QVVxOEySidpbAGXoIucHyW3bNa/75cg0df/ymrsxTT2vsZbVoh
 aWjyFDqwMSw0k6Dn0E1nMfxMPlP2IGXS/G8AxSz/Y/1NjDs/ln6V27Menk1/1K4/WfWpa2g6jtT
 i7LiKLwqGTtRBXq/9T4PO6TuRJedJ/2IAUxbftcIT0mUbMSxTM2rnJVl7s5NouEgt6D2YSdgKoV
 S2I0ax8k7WECCBLHwKmcmPI8WX9CqSjg0X5BLpIVT3c7KNLcrCk88REdnMIszn21mE34J1gVp21
 wujZR9oktHlgM7OSn/hcmXEmq7G05hqdOO5nyvDruUebu7pdNJfDrg0czUEbX9hOpJBHOInTLyI
 ysttQjhHvQkaNthtvcRF3/nI7va/qZfjWTcMZPnv8whDNEXUA+xip5OJ2v0stNbB1kGlkUeQuUx
 OcJI0uds2mDLTZpGXcOPYOCNutpX8eCzUMGFi9z3oTCF8QhQxfRs9QI9uV0ApIqO9FUsZIAdhG2
 Kmzp5QHauxc0nuXi7kddfnCSwPO9b2rR013RDTJA4cu92ljKeaL85sobd0WH5Dc2H0W0HHVTO1K
 fM4GmOTX+d+pGvQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C3183180006
X-Stat-Signature: 5jtftuxanzmksienae3qwip8thy119pz
X-Rspam-User: 
X-HE-Tag: 1771198929-383910
X-HE-Meta: U2FsdGVkX197vO7EehENeJ2fO2GBqmzJiN/CNWfBo0Rr5MA4G93wPQuWgzKO7GDjY1M+mtz27D3Mdo+G2upm/mDg8gijPH2IxttBraFS9dy7+xteikiyHgoDqew5zdYu4dYE9LAa0cYsSogo5lmJC9OFETFZdP0V39DjzRb1AF22VXMfUJIyDp8KDJzYlJeV8aXS1ik18trlnEVXCYSqF1hgksuoB+WL57ioFeAlZsKvsj0ZbDz0GhPrJvF4ZVGYZxhESKUiKsgQLk6uGzQUHsqvzpwHl8drMiTS8eNeSk/hagsjV9jEF7KLCB/4gP3dgEv88ms36jWNcn5elYwepfmvPbwPasBz349LLarXqimxgtuL8gIECyT/fG36U5cUKEu7J9bcJgywdN6KxTmg0icbFQFvqDJCAfIP4vTIcEUCFozq+KO7j2FWpKax8qaqPMX8FDs5CbLohhCEm0G9AfFXtESMjL+znsxs0Yr6oiXBZPTkuwsy0cRtt4svTYDu3TMI8KUYORiKoqHE0AFVLZsE7tAid9c+iI95OTNHrprZkeFgLEjXPV2mFeLl1sYs8Vn3mh9M4IzjjVXMJC0cS4ci6O58nfkRVSUDY+PFdb/fgmGChh3ZYlgQ5zccHeaz5zYW74NJMaJjf9yS6NPUomOMMsb1iJjbKgFFZfZLAoub4OnFFlAMvat/6AZBcTM5cFr1/1OmDQgM+7qeChaK6Fc+ZBLI3QJbdwAV/PPOZbvh2AE1Huf6aJHGkGwBPYcZidJXE4Q7PDmfwqxavghooZO+jrTlJCKBTWGJ/aCn2koFeDqoK/5M3gpLV5flWGMozc03XCUUM/2mRxOZ6FQ/5K2ev1yR911w9tuWxXA9sqUOqojISEq7/txVAKCj39mE3n8jS1MgyKMns43/4HcgoPQmyy4FIj6TeUDLkDpqLuMNRdjyaBupXsm6arFnoO5d3JKI/KJYpAMsII11X0Y
 BAe5x/m8
 r2mA1PB/aAlzK4k0Sd8Zskdlrkvnafdedz98qrISaaaOuPv+cLjr6Yc7unLG9Fa+geWCSEtJPaE7F2tseNhRct1s7pj6KMpng7cM6C/F0gG70TaWZOVWyWy9IE67jcNfAlQXcmeuRGPn6FWJIBJEskO7ZZ+T/HxGyZ8bG1Z87I3JYg6DUOckr2TNFUd/sojHU2RwT7cyMUt0pJUG7tbnIYDIRuI6mZuiQ/ccJtdDqjLgybMb4dYtDEIPEDd8KoaYeoHjWFwaHZF9wtQWuGbfl6jcmO+/+PQ/SSyU9kIY/iGG9Rb82VehLi/h6c/ff/VXasp2Kym3/Eyo3u/MhKJ6RFvS2wuJUKnYUF8/NjNLmDh6u68pRxbuBDjO757L0nIw7gezLTO77+RlCwS62JdLrXUtDuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a method to `block::mq::bio::Segment` to copy a bounded amount of bytes
to a page.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/bio/vec.rs    | 27 ++++++++++++++++++++++++++-
 rust/kernel/block/mq/request.rs |  3 +--
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/block/bio/vec.rs b/rust/kernel/block/bio/vec.rs
index 20cea478050b9..ed1c1374c9c76 100644
--- a/rust/kernel/block/bio/vec.rs
+++ b/rust/kernel/block/bio/vec.rs
@@ -79,13 +79,38 @@ pub fn advance(&mut self, count: u32) -> Result {
     /// Returns the number of bytes copied.
     #[inline(always)]
     pub fn copy_to_page(&mut self, dst_page: Pin<&mut SafePage>, dst_offset: usize) -> usize {
+        self.copy_to_page_limit(dst_page, dst_offset, 0)
+    }
+
+    /// Copy data of this segment into `dst_page`.
+    ///
+    /// Copies at most `limit` bytes of data from the current offset to the next page boundary. That
+    /// is `PAGE_SIZE - (self.offeset() % PAGE_SIZE)` bytes of data. Data is placed at offset
+    /// `self.offset()` in the target page. This call will advance offset and reduce length of
+    /// `self`.
+    ///
+    /// If `limit` is zero it is ignored.
+    ///
+    /// Returns the number of bytes copied.
+    #[inline(always)]
+    pub fn copy_to_page_limit(
+        &mut self,
+        dst_page: Pin<&mut SafePage>,
+        dst_offset: usize,
+        limit: usize,
+    ) -> usize {
         // SAFETY: We are not moving out of `dst_page`.
         let dst_page = unsafe { Pin::into_inner_unchecked(dst_page) };
         let src_offset = self.offset() % PAGE_SIZE;
         debug_assert!(dst_offset <= PAGE_SIZE);
-        let length = (PAGE_SIZE - src_offset)
+        let mut length = (PAGE_SIZE - src_offset)
             .min(self.len() as usize)
             .min(PAGE_SIZE - dst_offset);
+
+        if limit > 0 {
+            length = length.min(limit);
+        }
+
         let page_idx = self.offset() / PAGE_SIZE;
 
         // SAFETY: self.bio_vec is valid and thus bv_page must be a valid
diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index cebb30fe9b3bc..bc655d202ca01 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -7,7 +7,6 @@
 use crate::{
     bindings,
     block::mq::Operations,
-    prelude::*,
     sync::{
         aref::{ARef, RefCounted},
         atomic::ordering,
@@ -18,7 +17,7 @@
     },
     types::{ForeignOwnable, Opaque, Ownable, OwnableRefCounted, Owned},
 };
-use core::{ffi::c_void, marker::PhantomData, ops::Deref, ptr::NonNull};
+use core::{ffi::c_void, marker::PhantomData, ops::Deref, pin::Pin, ptr::NonNull};
 
 use super::RequestQueue;
 use crate::block::bio::Bio;

-- 
2.51.2




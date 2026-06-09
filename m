Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB175CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:15:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F5036B00F2; Tue,  9 Jun 2026 15:15:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C7A36B00F3; Tue,  9 Jun 2026 15:15:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1FC66B00F4; Tue,  9 Jun 2026 15:15:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF6976B00F2
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:15:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A072E1406C3
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:15:01 +0000 (UTC)
X-FDA: 84861326802.14.385B0EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id DE2CE40003
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:14:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HHAC1mMS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mrJG8KiUxKUHfvXwMNkNGZhqS4gsQJoMju1kYZYGQYk=;
	b=fzk6aXxuQm49l38qXLmqj0w2LTrDnchRZ6vgbFOAzNsckqHFnq0+SDE/PLkNQRXjRa6rwy
	wIywLOdRdlwxclrczd4q9524QMZZdt/JveqsTOw8EAUnmtgjpI0BEabbZaVzGgQPhhKLCh
	aTF6sKbdD6+35Q2OUE9lIDEkEW/raRc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HHAC1mMS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032499;
	b=LRPT6Kd+1C+ua61u2cmdqLLKNc97xKU36R1LH2DHoGn2gz2pegpnrMl3IJV3UL9Biny8B6
	TkjjUQZQ5t6ukgVx2iYK4FrWNopatpzbHayEJYevuC1rjLNGbWCBHuAV7Hc7i175llTGdC
	rMbLh0GAsflfaFjprTLeXlW817Jrwbc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 77E01602D3;
	Tue,  9 Jun 2026 19:14:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366131F00898;
	Tue,  9 Jun 2026 19:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032499;
	bh=mrJG8KiUxKUHfvXwMNkNGZhqS4gsQJoMju1kYZYGQYk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HHAC1mMSrZnRSEnk724VpwowU20c+RummkN3EX1Wk7AmLhuBnHQwz4ky+nR7DScgd
	 sUIpXnqZuhzZmyH4K56+t0kuwhbQpfND8xQDxHmMrOu9OYvXCsZat41IvOYIVn90st
	 mPoG82a+TP6gJ8uXM8wtqwfwJFnllYZRYBsmhEssGX1sVIEesB9M2rpsakkaz/jm9V
	 lZDBM8NHls/nCoAJWk6Yrw0OSbFxsaAoNRgNyHy+3P3MBKBcZ2Driuiky8/i/IfnjV
	 kDV86hLZ+dBFl7ijvCoZP3X2BIEbsFWmvPdYAmx3/glcjO8IxuLGNHO0FZtxGMVjaz
	 DrbPd4rWTf6ew==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:01 +0200
Subject: [PATCH v2 22/83] block: rust: mq: add max_hw_discard_sectors
 support to GenDiskBuilder
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-22-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2897; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=mKAY/8gcmYnV4CeK9ErSKMBIuQ/5EOAccvACmxqa5ao=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTIgHAgY6l2Ttz2UGa4fGnWqQhoUxmiEEF/z
 54xXUGsE+mJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihkyAAKCRD6UCkIqsW9
 0Bj5D/96wH2IqvfrEeXl1taIlDXI8bvB6U+cgPclaot3GKF7pKW5w0nNNbMXmAuzSnikbTtXAwN
 3FZjaf2kUe4pntQwnEQqVRw2Yg199oPewGn4uyUpmTRdT13CQ2+SzkBRevnwKW7cywDI0oIgOHW
 qRkdpzkSUK8nzHXsXCqA9EOdzKCmCuiFwQZQ9lKF/eXMVpQXdvuOWSRRNHV2xtFk1n1ALFsxAdw
 spdqpARcO9SjoZrIM9I4wi3VWfSjgPP2/6QLumakyvOtXTNASaDUY71bxSHA/tkuDUR4jhLwV18
 tAEBl/iwJQxOlAQRcyU0rd1mToig1Y+SLoeq+8LXTW+IWTbj3zxWj6hJB6FRN324/4scjob/j94
 8g7pLaVTjlxeiLl51KFrNwnmxrqB/p/IUA9RTxUXbkbjsCzE8ppjX9zY8yJCs8/PxCdpXE389sI
 LRUKc/I34zz0ttv7WAyjTau8f++O5Elj/wfnJn0fx/8c4QBpBXk/8az74W1QDwrIqVTg/D+plXo
 u13K7NvAzzAQw1Hvgqv8Do5vbuG/Q9ijMn8qCuYLn1vDgCeSrTxGwT33vmKUegXVVojj0coZank
 s/R5IjGAl2SvsSdbu0Lk+8xboJZvOi/Cl5KSCtyBBYlZYnd7OZA6tfT1KlzDxT2VksKI/y2Mq4q
 WXaE27QIK7CyMYA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 5ws6ke9mwq99m4efqyzsi4ui9ryg64nz
X-Rspamd-Queue-Id: DE2CE40003
X-HE-Tag: 1781032499-628880
X-HE-Meta: U2FsdGVkX19Ty1u2segRdvABhMzm96RI4wZUAIs1ys1rKjP8PnmdXaJcEZemxT6p/6Luz8/Pj+B9FUZvLqkeUFGQu621Js89+3z+8GpKkLAgGwrYOgjMSMJrk6er530oJyP6nJR8CffV3AluyshXGb9EoyOOPxyzID8zqeX3x69Joyf7tSq9WnIXLqa9mmu24W5q/xbTtaLUnWpzmcPuJK30i4tCxnL3uBgcb4RNP35KWsNaNmtbYfozuD5RjbX64AEZ4T7YXRBk+v60vvVN+Ofb5cKgpUjVCZhPg7CHat4zufckhxB+4aYfZORTDpSS2VHVvg129xFt2N6oVj80QFpRCnokks1gBB2rVhE/WnFEtWhZpVmBDX6hcgk7YNdKcwxxCOuUap1VdqsGcjZ89wj0jOS+w4L7v2h6KN+eZOviBRWRJbi5YTSyPvrtQIrRv6rb7GvREkeq6l+14SOlLLQqndifCGRXh2Wn7NxQPOqAR8voJ9fRYUO5v1kPKXFDVg2Zz0/7SY4J1g58RXZt+Pnd0VoWoJa8J/S7BtoqD/10qBXY2xT8w2gft4StLev1FxeS20eUB6vJyJW0zB6QaFGdcQnj7M6xpK+LH4srBovri0y2f8RnsUCPJzjVsgvVWk+7onTo/m0E8JfrdTqkxB4V+jeSpo2dm9bEN7wFYzvo4YSxNgvF5xs8siSUXGELvG/lm2iz0F8xuwuopjt7+FXWzUc/ImcBoy7kCI7NQoF90cQZJQ8XHCPyfRMBV71YbUHTZViZN5Abtqmlj+PsAL9kYD6fkAjkvmEmZywavxTg5a3WOo0wbOWzdYZoqhQohQUZ2kxSxRyNg4BKwO+kzFtWqocTfGeXQailZrBpnwxqMHuxp1iKG3ao6yoMDBJphLWFRGpDTCbUl6mcAT+33fJAS/8N2F8FLGeEbkMl70a4UV9Ic/CefpL0LevPuM7t1kmnQ1kmU8oFAWfLyp6
 GhGR1D5W
 VejfsxK3s2nIob0gi70iDW2j9Q77KxrVCTrQWebOFkIw6UfYxi/F0TohZFv2fjz8pNs9o+/hGz94hjlEGPYaRp1xLJJ41QNFQZ77WJxe9kZfrjQFXrt0Fn4StqZAJvbJPcGnrMnbpGwOLnluWWnqyAksQN6F7gsh0vLQkoFpZBjCfp1GcdpMM4E4veQQXbkatGGDLQx+EDIgOeyt5ZtkfUZ8JTTjkeMzUVdozWP6uTJYNaHXcc0RQmwb9SstJsmzSryeQBpwZMokFGTwGConUa+lfmQU/MXSrqYbRIuj2vbb0tjPlecU2QM3iBmmIes2hU6soPF+0e4sgWrvxWndf3nERlTRVvcb1g368nX9MfugKUmxCcP93U4QtHXkf5atsiBCwk4dvhO/BdCg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for configuring the maximum hardware discard sectors
through GenDiskBuilder. This allows block devices to specify their
discard/trim capabilities.

Setting this value to 0 (the default) indicates that discard is not
supported by the device. Non-zero values specify the maximum number
of sectors that can be discarded in a single operation.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/gen_disk.rs | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/rust/kernel/block/mq/gen_disk.rs b/rust/kernel/block/mq/gen_disk.rs
index b36d24382cc3..2b204b0ed49a 100644
--- a/rust/kernel/block/mq/gen_disk.rs
+++ b/rust/kernel/block/mq/gen_disk.rs
@@ -7,14 +7,27 @@
 
 use crate::{
     bindings,
-    block::mq::{Operations, TagSet},
-    error::{self, from_err_ptr, Result},
-    fmt::{self, Write},
+    block::mq::{
+        Operations,
+        TagSet, //
+    },
+    error::{
+        self,
+        from_err_ptr,
+        Result, //
+    },
+    fmt::{
+        self,
+        Write, //
+    },
     prelude::*,
     static_lock_class,
     str::NullTerminatedFormatter,
     sync::Arc,
-    types::{ForeignOwnable, ScopeGuard},
+    types::{
+        ForeignOwnable,
+        ScopeGuard, //
+    },
 };
 
 /// A builder for [`GenDisk`].
@@ -25,6 +38,7 @@ pub struct GenDiskBuilder {
     logical_block_size: u32,
     physical_block_size: u32,
     capacity_sectors: u64,
+    max_hw_discard_sectors: u32,
 }
 
 impl Default for GenDiskBuilder {
@@ -34,6 +48,7 @@ fn default() -> Self {
             logical_block_size: bindings::PAGE_SIZE as u32,
             physical_block_size: bindings::PAGE_SIZE as u32,
             capacity_sectors: 0,
+            max_hw_discard_sectors: 0,
         }
     }
 }
@@ -94,6 +109,16 @@ pub fn capacity_sectors(mut self, capacity: u64) -> Self {
         self
     }
 
+    /// Set the maximum amount of sectors the underlying hardware device can
+    /// discard/trim in a single operation.
+    ///
+    /// Setting 0 (default) here will cause the disk to report discard not
+    /// supported.
+    pub fn max_hw_discard_sectors(mut self, max_hw_discard_sectors: u32) -> Self {
+        self.max_hw_discard_sectors = max_hw_discard_sectors;
+        self
+    }
+
     /// Build a new `GenDisk` and add it to the VFS.
     pub fn build<T: Operations>(
         self,
@@ -111,6 +136,7 @@ pub fn build<T: Operations>(
 
         lim.logical_block_size = self.logical_block_size;
         lim.physical_block_size = self.physical_block_size;
+        lim.max_hw_discard_sectors = self.max_hw_discard_sectors;
         if self.rotational {
             lim.features = bindings::BLK_FEAT_ROTATIONAL;
         }

-- 
2.51.2




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9899BE63F2D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:10:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B29D6B00A8; Sun, 15 Feb 2026 18:46:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07E9B6B00E5; Sun, 15 Feb 2026 18:46:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDFBE6B00E6; Sun, 15 Feb 2026 18:46:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with SMTP id 6D6F16B00A8
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:42:47 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 14A4D5C464
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:42:21 +0000 (UTC)
X-FDA: 84448317282.20.BD36BDE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 69BE24000B
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:42:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kcb1swnd;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771198939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JcXX3vUhEqQ5NrV/azgBnZlnM18XBuR+5hXlbNd7xU0=;
	b=eXUMIgZHz+6CR+lzmUXT/5m9XTF8UzJr/rFhB3u8ZmiNLqrx04s4N+A0cjzz3uV1/xez4r
	WQaUpS7BfKa5ivfyhCsuB1zoPzLIVUnx8TynrVmjpjldjbZ4nLVd5otHB3QJrnAGUqC9AO
	e6D93+QoxUoCz1AuIOP4OlVYo1ll6bY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kcb1swnd;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771198939; a=rsa-sha256;
	cv=none;
	b=k1Y2I27cMv7vFUR43I16076KR37dl34E/iS7TwQiAWV7e+r5wKa+eOPCcHbixf+DNefdUw
	J0T0W9ry7LcSqy2Q2YmdXPXj7YXkKPaWHjl2ZLQrvrf0LZ4ul/P3WBKgVwVq9iBZ627d/M
	i199N02wU4dcF+uIoCefydpcLMetHic=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E130A61119;
	Sun, 15 Feb 2026 23:42:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350C8C4CEF7;
	Sun, 15 Feb 2026 23:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771198938;
	bh=6LAOeUSwUtS+ZAfhWOk/dU6VGMrvdfMVJxYHu0ElVWg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=kcb1swndbwEz60aKfQ99++Rx9ZSn4aB6GXhSvIWTAtBLl+Gei2BTtnc0kzm3a7S0/
	 ZEFK3Z/FEEJBNBU/1853eTcF1/WaLL5LIzC5aL/DY5xSwYWNBVPmfhSlCsa7L1g0EA
	 s2M9buM51ruySlwcLy82Ty4vaqCXrRc2Xd165o0hXHjbsqBwLpRYRbo4NUcyAa+zTG
	 IOrz5tLX6DqRxU90SXXemi3PAyj1TiSpW2Bc1cdQUy13U9B+Iooibo5xtPJGa/hlyx
	 krgIJqFyXDL+10P2EqvACbuSXgjkgWocQEBfYfbfLy+N+Xny7G/B4I4dNE8+ax/k7t
	 ZIJOiPjGtEneg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:06 +0100
Subject: [PATCH 19/79] block: rust: mq: add max_hw_discard_sectors support
 to GenDiskBuilder
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-19-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2183; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=6LAOeUSwUtS+ZAfhWOk/dU6VGMrvdfMVJxYHu0ElVWg=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklgtNy3HVqeMKx/bZtfhBvhyhrqQKDLf+61b+
 q5GOgtGnQCJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYLQAKCRDhuBo+eShj
 d9IBEADCxuBV98p4EeEhXjdQG5XWMxSpvLsVbj3M0E2kKiIwcrxpa9AJxkVUursKhIi9rUDxdXd
 NGWZ8HSlmyqls7Y3hpUwFYndcQuW4nxAIZWt42FirgHrX0NCX16lx5I5/+eo+IiCe4ccRoHMgEq
 01JXhX/piAGvhuN76Mw1mnLR5cum7zQp7ycaIRJ4K4/UMpTsEF3OfLWykGYO5K0WPyk+KEbqEm9
 sgiwnrbXmxW/bSIdx/1FPpb3hBkpCM2zn63p7d5iA80VcNj7gIlcujiu0fHe1Y1ReypylwCgQzs
 P1D7ypmft0pyj6sUvKE3DpC5IP5Mw4drtUI1vuNg3gA4679X3QodH4030qzOSKOZc365A865dmg
 GfRFkfTBC+7EpHTNS5k5/Yxjv9Gm3kF86NLFSsIKsceTL94/dhP3rKEwbkzqG6HmyS7Bv/kF0RB
 5QkWfbIieVe+VA5YZz8BywbkcyjaDfWQG7QKSXjZywbVUM/iU6+1Mw/RCtFmSaB8sNcGTKLIQ+H
 9ECe9/cLh7S9dHdjxSGMNER1PxwGSyywJRieit8ZRWY1dplVI1K+zBzDgYH9mNOTOSODhSau8rs
 gpAckvS/+VSaabzfijTBrBxcN45a6FbRcjIFeDm1mzmlEjyk1hONveYVeINnK3BBzTQXtb3VABW
 l0QslnlC7NVHN2g==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: 33qd6c69fikq5673p5ckyenmhure76g9
X-Rspamd-Queue-Id: 69BE24000B
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771198939-406625
X-HE-Meta: U2FsdGVkX1+6r1d0diDkkURghkV/H4RGwSeBsJcjPZdsLvYj2prpT/A1Zy9Ps7917lZzYYXJPeYwRJgQE3AXbE1sowocdO/5EGDUtyuGqcyuqLpTzMiu9HszcBxAAj1WnFH0GT1Uq2Cq5F2q+EGOjpGtsOd6sEn6tGaY7qCDzYBhR3nLo0hd5tmWAXl4EyraOJy+6BOhmwjG7HWjBVHXNBtENVQFjThsjZJSQmUtempBKwChdaiQJA1kOwFtsTcQWg1Uy4/k6KUGdLs4uEoPWUf5TFtJvhx+DLWUtQO6RKQB8KT05DK0crIzylc2X3ph9ijZQjEAR8gbUnuSv+tU0Noiq3Np4IEJkDJoN5uh2iNeokgTmMucQjpJKulVCRZaYl/ryZ58aP/YpiMIs8URAai9FhFioEnck8NAJS2BvKE1owSsuHxuKeeCkvhK8LdZVYmXUQQVWIobdFyVlrZ72z7NxB7bUVsslWzEp4es1r+fBs6w97YhyGGI9liUis8CG7qWMQ88bqw644Sr+zNMOdsjFuvm2uXQDznfux7JXWJ6PMQrAqfEQhYt3dR4tbI+gSl8hNRdoHSZAT+yg3aOG3wcKHgzoFPRAvSmL1JK0/JmT/D+rDx53+rAPYBMt/4vwhwHgZnH+cJkS2u+FJDp6bo6WiPf5kRKd+76IS3IHnOHf0UzArilom+W3PJayhZqVc5bIAjUphX2DHZqbpOwfMuF4DUi1hCj3TqtdL0ubQNhJKAPGY+Qp9LW4yOx6eTpcJn5CBsZTPgi+zYZAmeskE/fBtiSmC9cMJQi7eMGOcxr66gAdQMXB3yvx9cvwGY1eSPHf9a9roOeB+APZDafIShmQbmRclMvVJEOA1DyrNjQK6zDJaE2L0QjunOYZZlmUGmQ2DGeOY1Ed6s/9OpzfcfOY7x9WJh7joJzVhGtRcheuFL6rGKdjEHJIyIffx17+uJ9ssVRQBoDkbW0DZx
 vqrVge0/
 Z2AYHtGDX09YuG7/8v5lVB1PaMPVYP1mmeKLmXqwWN6X/NqqxCYlLdzHlhg/ZAOWky8PeDBhYJw7O5LfE87ZDSmOZ/Jhvini7uiUFS9WPUINv5H3AXIfgRPcgGdA5TUOSMPkWai/P0mt7t52ql8MSjUMBNOyycvYSliHib0CbIkIiN0Dh5u1LFgCMRghUqA9oRR37Z6rT4lQvp5FXerBAchN35YbZgjwHd5ljqSqO0BuFSgzGZkZR8vuSs3CbFax5Hhq1Kq+aTZM9MsrjuRGJbOivWiAI47EGVy/AgrSMvJ4ZOpgjjDTHH80bGI9aG8O20DpC3yM1PjUfYlo+m4RRzM6j4AZoF5ndtQpSqnA9ZDO9oU4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/gen_disk.rs | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/rust/kernel/block/mq/gen_disk.rs b/rust/kernel/block/mq/gen_disk.rs
index 1ce815c8cdab0..75968d6a57639 100644
--- a/rust/kernel/block/mq/gen_disk.rs
+++ b/rust/kernel/block/mq/gen_disk.rs
@@ -25,6 +25,7 @@ pub struct GenDiskBuilder {
     logical_block_size: u32,
     physical_block_size: u32,
     capacity_sectors: u64,
+    max_hw_discard_sectors: u32,
 }
 
 impl Default for GenDiskBuilder {
@@ -34,6 +35,7 @@ fn default() -> Self {
             logical_block_size: bindings::PAGE_SIZE as u32,
             physical_block_size: bindings::PAGE_SIZE as u32,
             capacity_sectors: 0,
+            max_hw_discard_sectors: 0,
         }
     }
 }
@@ -94,6 +96,16 @@ pub fn capacity_sectors(mut self, capacity: u64) -> Self {
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
@@ -112,6 +124,7 @@ pub fn build<T: Operations>(
 
         lim.logical_block_size = self.logical_block_size;
         lim.physical_block_size = self.physical_block_size;
+        lim.max_hw_discard_sectors = self.max_hw_discard_sectors;
         if self.rotational {
             lim.features = bindings::BLK_FEAT_ROTATIONAL;
         }

-- 
2.51.2




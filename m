Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0117CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:12:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D1076B00B8; Tue,  9 Jun 2026 15:12:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ABC66B00BA; Tue,  9 Jun 2026 15:12:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BF326B00BB; Tue,  9 Jun 2026 15:12:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 198086B00B8
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:12:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DFCA41C27F0
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:12:17 +0000 (UTC)
X-FDA: 84861319914.28.05B2073
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id E014910000E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:12:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NYqk0bMX;
	spf=pass (imf05.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032336;
	b=MnahIkry6EFE4n/HPgl6WWCMTgHjyITrcY4Ebirb1mvZenc9eboW7NHEBhRI1aBN2wo3UR
	uGwRxyR/MwoBkfHNoK++Nmt19vstce6cUR0VL8KILaXgdROwgzMJh89KN92bFrJyk97FHf
	ahNCOl0QRb0s9ePoL5EWz1cTiyfYN9Y=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NYqk0bMX;
	spf=pass (imf05.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a3jbJNIkhOwxGOU8DfYtnfANfNVtK2eFGYBWmXLcybk=;
	b=T0wzCgGiSkKttYATvW/07mkzDBhWWt50ELIVFGS3a8USIUTzzG2hrh5FXK8N9CtRDMP5mw
	M1KvaiD82MzLCw+7DAxqoqIT4G4NyCVGuJo+rum4GSr8c5HFX8sThlc3xVBTW3rm/tzjXr
	GLIDFaxm6bk2XU8NN4CVHv2dJNI0zcc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 52A0E402BE;
	Tue,  9 Jun 2026 19:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691CD1F00893;
	Tue,  9 Jun 2026 19:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032335;
	bh=a3jbJNIkhOwxGOU8DfYtnfANfNVtK2eFGYBWmXLcybk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NYqk0bMXBfzUx40NJEmhqEjCWQBmirujxeYo80SxHV6ohWkmH97SeEqumLNc7LQyZ
	 dbp+zuf7GJroLJhHQj69de+gY7gADe9ctRVyXOn4H90BqAX8MFSZxsMoWFs3jY3UOX
	 Poq2EMSX3lstrGtLG8lzXVIBH6ccWxPvMWoaLYGCLG4brPsT8jEGhpMGAUuL4N3V1T
	 qpsExMA2wKtorI0q19REki41bI63shSxBDRzKFtkWvlyEfL5zDA5bLcC5prlbBNb4S
	 zIaWeVCu+hhBhSRDz9KnLwandfGruIhCw45gX6Q+IVEw9YscNKiHPr7S34u3KTd9t+
	 UjXvFYZShbjhA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:27 +0200
Subject: [PATCH v2 48/83] block: rust: add an abstraction for
 `bindings::req_op`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-48-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6975; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=cGlJTpA6F6McVlRWYLS3sRK+tr1wvcKBW9jQZlkWj+Q=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTgxZOVEJMK7I40lvqteErFqI2DYzSNcD5mb
 96fFobyPEqJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk4AAKCRD6UCkIqsW9
 0AcoEACvXt+Fpn1SP/zeWsAm6kzE6hADdYR61zFif7WrXX2R8MnVpdfi44Qm1pQX+NC8/NrD51P
 iL6dJThG+xn7f327yeKNTKSCjQ5Z4VDpFWft3dFT3LuuOG+d71+vhEQduwMJPsicGf7D/uchYXa
 832XLg5qdGT/7yZWn9VmuabH1J54pYc5T47AOXypstsyyXW25mNE53JWmegX8zsPET3dkW9tGiQ
 HBCvk2qLSnvzgU0L5ms4SwMiq46GRHjkZJKDq5hPPLNy4M2l9085b53eYe+cyTWJIssY17OctLM
 grWIcE7baIw7oE0EJ3sk2RNRvNJ2e/eZi5ECOISb7Fk5r2OMoUJpVSdmo5cJeuESQ++Lu0gQDro
 NfSkpM6Ltj3lwMgw/OuEd34FJtzaM/eYk3qXtLS1VWvft0mp4r31kcU/3bIKzkz3Vyfp9D2ilpw
 XR2ljhF0TCR+sBwU5oRtGEnDSVdjSbTdFgBcURfXEjJiryySP5BxbXU/M0lhxRyrD/KPAVOSu7T
 Y7YYq5PSBKuBFlGYF6T0jguUcHFINNQ4hpP2Hsbr4yoUN78SjWzWtzk7uROW3CXkn+y3avJiy1/
 bJXaDSAcnSJOXt4r9MFq9d8zdiCh57OAgpIA4GDUYnESFSqOyv5qO9JMwqAwVrQy5Izqiw1C+7j
 V1uHlVY3vP7PZqg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E014910000E
X-Rspam-User: 
X-Stat-Signature: nezm9hzzmpnh8e8ranzyx4pdk6te86xt
X-HE-Tag: 1781032335-847403
X-HE-Meta: U2FsdGVkX19TFoayVbmPKYVZ1SjD8R/Bn2cjzDsS+pEP86f6OyI4FRZhQOsx+XNuxJz+smBeUp1l8U0jnYwGB5tuZ7B4Vs2Al7dpJqSBH1mqJvaAznMH7SW5xcbUbiIEsc/NZ8ENN4H4dufONIxJUMQ9k2tFEMurTO3cg/85flzSpAX1+ddj3nsKbXHApUy5dR7gsCAxhkQgUd1v2M6YjYKwltAniB4MK0W2hYy4vWRAQrCxgAAQgG66m9L+z6ffmtKM87RWoJ85F8tatF0msGHo49H2pik5iVuIGPvjS5ZK1uuMsmmSpgqyI2v+/rp/8lYWciDK9cviNFxDAh1e74896kITBGkj8YIBaeRuaoBp5e4PxPdZslwacCleMbsb/c+ghCfn5kbCTIdcx7Y7IQC1J4jMML/PohewRo9HN2EYDWn9mkG6w0+KUJKD5wQWUo39Gm6BfFbRXyk/snRcU+d2Nkvc+qof3KKhwYruWxhoW7BsUK8Rl/jpnLI+GQmJHtPWfjBkNfoDikdWXXoAnGIM8r9Rjom96LBee11w72kF4J++kS1rzcL+PEYg/TXRMxkxlRCQgWxoW1Vq0GBRmA1c5e1AFYKY6/p70mrYYUF6DsbZ8bbUGCE3Lul7VhHO5wgvcV1GnonmAscTDKMyTQscGvGa98oTQWlQymzD0et4sCOkewsZ5ghCTxOYlGr6doW9bzQJwRs4zSOrmnLbp022bf3oV7HamqN0dcvWVuMu+h/jdgLyRNnbt3l+8/48t/mmYSUs+n1yFd9wUvuvC1uJ2ubEGlw/Vqx5uW5dazL9pW5zuhPj4Vn5OD/RsRwjxdZM0AAnFETTjTAZxkSAnm+aG4jxcb4ZeOcGgnxLJe3oCHFYFv0qtqgBz/uO9Z3SNxJkhYTFJNRi4+3fUnkLEIJ0ccuoOSrRQupEv/U6jJvTHmm4Q4EtQ5GaTEEqq6YXl/hu7KwlU79Drl90OC4
 yw2CtAUI
 5xOs3UCYb80DexKcaOaitzoCkCDHrxBawQdBN5fiHKsi/WeK9lJOvR6u/OfU1n/KsnumA20GU5P61uHWZT2rdOUiMboEtPVLXo7Xu+V4Vz1PiHF/0+3oAEfRn4wjNaakF02PR9TfLL4uc81Za9WJw1PhOrcjYoOftJPC92AgcpI9Shp9kJ7oe0F4h0EIRFmeLxiE+7o99TPcLuXZdhUzt1RCDXFw5+SOaR8z5plm8OA0/TqXc+qUc556jKEYDozil354IV3nched/oEL/EagbDPQHx27Zk38Hkn9NsEzhEX517UAWaRuviTF+uJE9hPDk4OFqagr3V/dbYeOwwnJFf99ZiOJZRgh0QnbBk8g6QtVvEsiFgtTxcCikZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the `Command` enum as a Rust abstraction for block request operation
codes. The enum variants correspond to the C `REQ_OP_*` defines and
include read, write, flush, discard, and zone management operations.

Also add a `command()` method to `Request` to retrieve the operation
code.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/rnull.rs            |  6 +--
 rust/kernel/block/mq.rs                 |  1 +
 rust/kernel/block/mq/request.rs         | 18 +++++----
 rust/kernel/block/mq/request/command.rs | 65 +++++++++++++++++++++++++++++++++
 4 files changed, 79 insertions(+), 11 deletions(-)

diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 491979daa50e..5ec17a2674b7 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -547,10 +547,10 @@ fn transfer(
                 let length_sectors_allowed = segment_length_sectors.min(max_remaining_sectors);
                 segment.truncate(length_sectors_allowed << SECTOR_SHIFT);
                 match command {
-                    bindings::req_op_REQ_OP_WRITE => {
+                    mq::Command::Write => {
                         self.write(&mut tree_guard, &mut hw_data_guard, sector, segment)?
                     }
-                    bindings::req_op_REQ_OP_READ => {
+                    mq::Command::Read => {
                         self.read(&mut tree_guard, &mut hw_data_guard, sector, segment)?
                     }
                     _ => (),
@@ -743,7 +743,7 @@ fn queue_rq(
 
         if this.memory_backed {
             memalloc_scope!(let _noio: NoIo);
-            if rq.command() == bindings::req_op_REQ_OP_DISCARD {
+            if rq.command() == mq::Command::Discard {
                 this.discard(&hw_data, rq.sector(), sectors)?;
             } else {
                 this.transfer(&hw_data, &mut rq, sectors)?;
diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
index 503623267b19..5bf2cf2736a5 100644
--- a/rust/kernel/block/mq.rs
+++ b/rust/kernel/block/mq.rs
@@ -132,6 +132,7 @@
 
 pub use operations::Operations;
 pub use request::{
+    Command,
     IdleRequest,
     Request,
     RequestTimerHandle, //
diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index a05df2351c2c..63e248970ab1 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -45,6 +45,9 @@
     BioIterator, //
 };
 
+mod command;
+pub use command::Command;
+
 /// A [`Request`] that a driver has not yet begun to process.
 ///
 /// A driver can convert an `IdleRequest` to a [`Request`] by calling [`IdleRequest::start`].
@@ -111,11 +114,17 @@ fn deref(&self) -> &Self::Target {
 
 impl<T: Operations> RequestInner<T> {
     /// Get the command identifier for the request
-    pub fn command(&self) -> u32 {
+    fn command_raw(&self) -> u32 {
         // SAFETY: By C API contract and type invariant, `cmd_flags` is valid for read
         unsafe { (*self.0.get()).cmd_flags & ((1 << bindings::REQ_OP_BITS) - 1) }
     }
 
+    /// Get the command of this request.
+    pub fn command(&self) -> Command {
+        // SAFETY: By type invariant of `Self`, `self.0` is valid and live.
+        unsafe { Command::from_raw(self.command_raw()) }
+    }
+
     /// Get the target sector for the request.
     #[inline(always)]
     pub fn sector(&self) -> u64 {
@@ -242,13 +251,6 @@ pub(crate) unsafe fn aref_from_raw(ptr: *mut bindings::request) -> ARef<Self> {
         unsafe { ARef::from_raw(NonNull::new_unchecked(ptr.cast())) }
     }
 
-    /// Get the command identifier for the request
-    pub fn command(&self) -> u32 {
-        use core::ops::BitAnd;
-        // SAFETY: By C API contract and type invariant, `cmd_flags` is valid for read
-        unsafe { (*self.0 .0.get()).cmd_flags }.bitand((1u32 << bindings::REQ_OP_BITS) - 1)
-    }
-
     /// Complete the request by scheduling `Operations::complete` for
     /// execution.
     ///
diff --git a/rust/kernel/block/mq/request/command.rs b/rust/kernel/block/mq/request/command.rs
new file mode 100644
index 000000000000..70a8d67fa35c
--- /dev/null
+++ b/rust/kernel/block/mq/request/command.rs
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/// Block I/O operation codes.
+///
+/// This is the Rust abstraction for the C [`enum req_op`].
+///
+/// Operations common to the bio and request structures. The kernel uses 8 bits
+/// for encoding the operation, and the remaining 24 bits for flags.
+///
+/// The least significant bit of the operation number indicates the data
+/// transfer direction:
+///
+/// - If the least significant bit is set, transfers are TO the device.
+/// - If the least significant bit is not set, transfers are FROM the device.
+///
+/// If an operation does not transfer data, the least significant bit has no
+/// meaning.
+///
+/// [`enum req_op`]: srctree/include/linux/blk_types.h
+#[derive(Copy, Clone, Debug, PartialEq, Eq)]
+#[repr(u32)]
+pub enum Command {
+    /// Read sectors from the device.
+    Read = bindings::req_op_REQ_OP_READ,
+    /// Write sectors to the device.
+    Write = bindings::req_op_REQ_OP_WRITE,
+    /// Flush the volatile write cache.
+    Flush = bindings::req_op_REQ_OP_FLUSH,
+    /// Discard sectors.
+    Discard = bindings::req_op_REQ_OP_DISCARD,
+    /// Securely erase sectors.
+    SecureErase = bindings::req_op_REQ_OP_SECURE_ERASE,
+    /// Write data at the current zone write pointer.
+    ZoneAppend = bindings::req_op_REQ_OP_ZONE_APPEND,
+    /// Write zeroes. This allows to implement zeroing for devices that don't use either discard
+    /// with a predictable zero pattern or WRITE SAME of zeroes.
+    WriteZeroes = bindings::req_op_REQ_OP_WRITE_ZEROES,
+    /// Open a zone.
+    ZoneOpen = bindings::req_op_REQ_OP_ZONE_OPEN,
+    /// Close a zone.
+    ZoneClose = bindings::req_op_REQ_OP_ZONE_CLOSE,
+    /// Transition a zone to full.
+    ZoneFinish = bindings::req_op_REQ_OP_ZONE_FINISH,
+    /// Reset a zone write pointer.
+    ZoneReset = bindings::req_op_REQ_OP_ZONE_RESET,
+    /// Reset all the zones present on the device.
+    ZoneResetAll = bindings::req_op_REQ_OP_ZONE_RESET_ALL,
+    /// Driver private request for data transfer to the driver.
+    DriverIn = bindings::req_op_REQ_OP_DRV_IN,
+    /// Driver private request for data transfer from the driver.
+    DriverOut = bindings::req_op_REQ_OP_DRV_OUT,
+}
+
+impl Command {
+    /// Creates a [`Command`] from a raw `u32` value.
+    ///
+    /// # Safety
+    ///
+    /// The value must be a valid `req_op` operation code.
+    pub unsafe fn from_raw(value: u32) -> Self {
+        // SAFETY: The caller guarantees that the value is a valid operation
+        // code.
+        unsafe { core::mem::transmute(value) }
+    }
+}

-- 
2.51.2




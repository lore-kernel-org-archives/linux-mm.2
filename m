Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36BE7E63F25
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6A2F6B00E9; Sun, 15 Feb 2026 18:47:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B26CE6B00EC; Sun, 15 Feb 2026 18:47:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1B656B00ED; Sun, 15 Feb 2026 18:47:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A2DE96B00E9
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:47:07 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 70FC31B4F53
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:46:58 +0000 (UTC)
X-FDA: 84448328916.25.4270655
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id B3AEDC0009
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:46:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BmQjiPkM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OA3X03lfYudr4bdXqz5vjTi3xJt2t+2l47X8R4c+gMo=;
	b=Jfckdd1e0GNKNU3OjB7GP5AUwFW4wkVX8mXVUKFdQ6YSiXVFB2QXFgJYF+2vFE2NN6gTW0
	R6Qb6aw/MdGtuCoTTuTyoejdBtFSk03ZNIMCEJPtj9llz21F1fS4r8QkEGXJgYwwpGxQIL
	4rHwOuAmOkr7+24WlwJrfWHtnrGM+Jk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199216; a=rsa-sha256;
	cv=none;
	b=ucQ1+wXlBNlYZvhlKNGN3Wda5+/juIw/KVvB7W5EH1flrNDaxjJWN7caoNwie8ikZ74fXI
	f9UGKeM8AlgfCsTwzP1uqPRrdSXqmPCOG1vp2IUK4W8wqOpB/fa9hTJGp5u+vU10ciKacs
	+lCg4pWhbReCAfpfYoASGvOmuIbJ4V4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BmQjiPkM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3AD856057A;
	Sun, 15 Feb 2026 23:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CFFC4CEF7;
	Sun, 15 Feb 2026 23:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199215;
	bh=pHTvVkZRFYcjiaGREx9N7FRfc2mqdwNLh9peaN0Ub0Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=BmQjiPkMGbCMCCRWpIRKmUkMrdGCR9uHTSwgOcA660yGX9ktAN30df2PCPV3s1HZk
	 6CEfKyzgEVdxnIQWZU2sAQGCS/S5FdfVQVx0cD/mKtl8lag7yrZ8mIUEs/tcjl+jas
	 tssEjIRSACRWsCVEMNjHKPKw1d/9YnUX5GO5JjL7vJn6UA0FNu/5BO4te+G6TLLUiQ
	 HzbZ8HZG8ZWn206d5cPypIxHAoQtaq4lhGaTNVkvT1CLAR88iFZsgYvzaUWz3IW4DZ
	 ukKxIk36VgGppMIBD5qzeXu/6eheDOcZsDLM1PwpEyM2bT1EGdmd7VcKD5s0+Beoq5
	 Pyi7Orb/Ucqhw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:31 +0100
Subject: [PATCH 44/79] block: rust: add an abstraction for
 `bindings::req_op`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-44-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6414; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=pHTvVkZRFYcjiaGREx9N7FRfc2mqdwNLh9peaN0Ub0Y=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhDEeCdW/yi4dywjzU/1Nk+MWm9S2xIIH2Cn
 V0G9M1w7xSJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYQwAKCRDhuBo+eShj
 d/D6D/44ecuU5yS9H5GCaAuZSVh+YOzWJCcgz/rVCkktg1rouPSSpD6CxPVUon461IFCjG00DLA
 G0FKsh7baTRApFzDessKhoxB+9+5mm5uoe3KDBZka+ZtKw6XmL13kwSE6QDe4izJo2fXWh8ZECc
 T88vr0uJG817P2hEkIKdE7sfywllU2Boyaxc256EgmJko0htOudxKOPi0nX2tGTWC2quFmMbBnj
 5ZR4gxFx4OewOOIf2Iyt1vcRNuDuTTJRa38dGXbjwgF/KTExWRKIikmoN/0HKJgOYgsHtGvyCLS
 NrEInkyirWFL29VlZeTQAEcIuc5yYEBJwCaXeckvuyEk7pivpurH2atUKKpy1Qn/QshXpDuIBFA
 5cNc6Vu2ZlFJrGZBXaOjXwcN8Ra7nLJ6wgs82RQJ3RQP+CjK7FjLMFXceHE4cgluDKQtECeD3pl
 raa/er7bmW6GL7Q5ZQurcZJ6sptVEQC4uq/pWVwnC/IwZfCLGTQjFmhyYBLaxNqrNUx3u40ll9v
 /8ylEGx1cgYdBcnRaZSV90oIGgrAB8nipQus1bMtJV2hsXIg9jnAEa9dTHZTXuqbK2Aqw/2SmS9
 cXooL5FmaBASTDq6ifdv1QwvzLB+mS6rmIPRbTiD7s0baqG2g9Xpk8t7etiq84wChnJIRI1LA76
 32fIHtKfsDlyO5g==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: B3AEDC0009
X-Stat-Signature: 9oy6nss8tqmhbgy7s67rxd9ukjhtbydw
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1771199216-481252
X-HE-Meta: U2FsdGVkX19rAzVf3IMHU3ywqXirprVAR+I9X2tLlzmFXGov4gXLqbufp5r0GhtQsgSlRi69zoZVkAq7EQzpxmNU9mxyZJpTAF1c/L4CibxksuGvrg+MoANp52pi9WMOWm1y3mESNk4gG7j3Dj7/tbYUkJ/nnLQq7L6N6Ln6bDQq9oFGvChBrfDzuN1lMO6jMFncJ5UvsyFujikaWTt0BDE3HeNdAhpKyBBkrgKEc805yehZZ0A7KJ5rPey/3zxIQINZuUM4wsN7SBqxJfAkzVbtrR+fypnwDqtwICOp90lectl5/3ztHp+4kWORfl03NcslIRaxADBplYjPtwY+LdD/rF5KOWRm+ihFZHJ0QrzpfX/HHpEMxhBSIJGX5zq5Q55LbS1JWLkgXhMcoJNx3JvuzU57ekqCJ7SgPDj2j0gkKIHzR8oD5CfmKHBfYLJCSnEs3Ndafzgx0NBPrCkgM+xG2v0e/K8kKZci7PPQazaP19wrrXA+of1x8AkrWQNI4hUs4BGnxl39ymJPQfAiFDf50dyqMZ9KwMNBDsu3jENouG9XiEZh1xr+Nx8EUlFQiXz4YbmL7VQeBuWHiRJEcLVvRiDObTF/8mSncL2qw8dQZgD/I7Ap1ARISPumWEESk7bJbwtr9kRguz95m3Jtzv9rLwHmaGODheSO+tJofr3Vy9czQclHlM0vHmfFcPoOsmdf0KeNtTfTwb61P66dAI3gxIp6PuKbQBjvF8rL+zWxo+9UCoy7pVIZx5PHgUYCmuZNQLn5H5h/iqAANwtLZ1fDZmxqdDktLzVpXLq7rzGbFciOQM9q4kd6XvIohAcfAYU+mSfrh0JVEElIn8ke1y3RyoOus0GOGDAQ4Fs6d7jW/Znwt4N38lNNblyiO2xu4MjDV4U4ouzaDFpdn+iW28Eh+65wYxgTarnNqn7hbFN9232uIqsK2oLKFLP2p22LfBFMNqfMgu7tLVA8xQS
 5/PJEuBT
 ONbP2cQkYC45XVfjZWi3qWAcGpTzkC+XEokC9Se5FArEjMAvcu5ARBh0j/9bq6fwda7/jxhtSI8kZ6V25/18YawtZ+s/UEJG4IpY9cw0jt8Arh3Cx03lQcgamxj87I7hxWYLtohoLSoKmNrpXkzCRqQUnqQ5lKPZTAWLNwiOt9P6eTjSx6OybNtF6w838zxMrK4dfwVsjTOidcdaLpSoaMUl94TXakwaiVjf60Ss6XPF96uDyHaPVf3rfRF5xETfUhRkCePQwdts8h1+pkdh07Sy3N3mj4uTHjMmmZW3L9zXWdwtxUWj6iBDxiA7t5N0cjTAmt28LiaVh4Z6a7rlkhmjSx6SanT74HL2aJ/tUEwKQqlA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 rust/kernel/block/mq/request.rs         | 11 +++++-
 rust/kernel/block/mq/request/command.rs | 65 +++++++++++++++++++++++++++++++++
 4 files changed, 79 insertions(+), 4 deletions(-)

diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 3fb19836ce6ff..9383b82f9a736 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -508,10 +508,10 @@ fn transfer(
                     .len()
                     .min((end_sector - sector) as u32 >> SECTOR_SHIFT);
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
@@ -703,7 +703,7 @@ fn queue_rq(
         Self::handle_bad_blocks(this.deref(), &mut rq, &mut sectors)?;
 
         if this.memory_backed {
-            if rq.command() == bindings::req_op_REQ_OP_DISCARD {
+            if rq.command() == mq::Command::Discard {
                 this.discard(&hw_data, rq.sector(), sectors)?;
             } else {
                 this.transfer(&hw_data, &mut rq, sectors)?;
diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
index 02738f52389ba..057a5f366be3a 100644
--- a/rust/kernel/block/mq.rs
+++ b/rust/kernel/block/mq.rs
@@ -131,6 +131,7 @@
 pub mod tag_set;
 
 pub use operations::Operations;
+pub use request::Command;
 pub use request::IdleRequest;
 pub use request::Request;
 pub use request::RequestTimerHandle;
diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index d6f3ffde1c5c4..4e47419776e0f 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -23,6 +23,9 @@
 use crate::block::bio::Bio;
 use crate::block::bio::BioIterator;
 
+mod command;
+pub use command::Command;
+
 /// A [`Request`] that a driver has not yet begun to process.
 ///
 /// A driver can convert an `IdleRequest` to a [`Request`] by calling [`IdleRequest::start`].
@@ -89,11 +92,17 @@ fn deref(&self) -> &Self::Target {
 
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
diff --git a/rust/kernel/block/mq/request/command.rs b/rust/kernel/block/mq/request/command.rs
new file mode 100644
index 0000000000000..70a8d67fa35c0
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




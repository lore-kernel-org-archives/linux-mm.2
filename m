Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41798CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A64646B00E5; Tue,  9 Jun 2026 15:14:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3B566B00E7; Tue,  9 Jun 2026 15:14:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 951606B00E8; Tue,  9 Jun 2026 15:14:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 81C256B00E5
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:14:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4E9071C23CD
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:14:28 +0000 (UTC)
X-FDA: 84861325416.01.83042E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 837BC4000B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:14:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jeEioYzD;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032466;
	b=P5uW3pKlyRGd8rxDkt0/KtH6pJgs1F8EV4jM2cqfrkrvOMhpbph7d3EG5Aihv6z75rQ1Ih
	NE+sCZX7ktgLSByyi3DJ199PR/kOVAJfGrnJ7NPzFtn555C2sylcG8ZyiR1Se7CmWifojK
	a3BMXuQOzaqnGVUuXpxVZT2+qQwf0R0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jeEioYzD;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rKt+bDrtCj1DKU9/OW9168On24x2YpG08Y7m0jWTFgI=;
	b=KvXC3bsA1NfBMavyTRfFV+tCSNo3YyKRfpiG+zj77+d+58iDhNTv6SL7aVwRWSAnV9EWtn
	B7dVWHBoKtYSwjEb38OhaQIDjUQxszWseHjJPEA8c//IViwzXGrrTVsAC5pe28U64aNpBu
	MSLG/xJ6vg6+uV5R5DrXyWSTG4s2+Fk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CEDE3408A5;
	Tue,  9 Jun 2026 19:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF62F1F00898;
	Tue,  9 Jun 2026 19:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032465;
	bh=rKt+bDrtCj1DKU9/OW9168On24x2YpG08Y7m0jWTFgI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jeEioYzDsBVnFZz1f7uZchjHzy2ohBa9zs7YA/cJD5kOF1lrs7CVudTkTHKw+6hV5
	 ihTcY5u8I7KzaFuX9xZgRL4zh/x9C6gAUqcWRDY/CWHHg+wE4aJKA/cDlR3Dc63bVZ
	 px203EI+zb6fNR6NoWi7+gKpyo/4HT/ybi9l+wERZlK5JufBBc0VwnfJCzaMb+rb8k
	 LYRf6wbOg8GZ10omn9TvIP0bkn09NN+46i/o+3pbiEPqzkJPCGG+2A4xxEfEjkRuJs
	 D25J+L/BWlw13P0lQ4vfSDwS9Bi+9DNjiu7sKjoOqrcpYj4/+mdbpBzh9auoUy6aFa
	 +ejbEWXuXUUgQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:39 +0200
Subject: [PATCH v2 60/83] block: rust: add request flags abstraction
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-60-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7083; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=fLt09kZRej3ghugW4pGzb6NaQOUJAAVoOulRRHYHWZE=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTq7g3559Rf/Oj1KcJo1QtcNpHwg/t23j1fe
 80+a4/wDNWJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk6gAKCRD6UCkIqsW9
 0EWBD/wNxmiVpxV8R1QZyoHjba4mwA5SmLxaiVRZLxopUWiap1d7rLXHJZleSQqtdRwARZXPZ7V
 2XMXiq0hUyS41VXfsW7mPfKTx3zxQd6m1E7cPXQ6Xt0TKGrNlfb/WZKssXw5iRTEqjU/2GKs2oD
 fHYxFiANODiKaOA7xK7L6i6+HBovzHlVm2+aXfgry1DLm3XLQ0UELzcOqCWlBP/p0rziOZY9sAj
 P1pB8AEymKThXy0WPRHUHbAKwYD3p7C0vD9NGDysXOQN7WwhFSYwt8oc4MqimlJtSNb86MSMHLV
 sxx0jJR9VBo87/mzgMNa4zUl/LmCRBJhy8uNr35/xdsqo1ieMs/O9a1JQb86r8nmLzvSl42mE0L
 uPCdWaeLPcq2gyhr6gCcQs8Ber/iQv6ZlO6Ebeh4lOS/RsHmiWzaKysllWEwA5+u9DsECUDKy3m
 913rU11wXlUPcUi9+2L+MfcOnnSe0ZnEhMxURzqz9nPaZtNHtxhoACsKWtTBpI26fVUm4JzW4OV
 I9akjGe0wvT71EvQ25iVIz7Umj+deMF12pPAjfZWSzqK2YvjkG2KBOj+78ySP/97oUooS1tUb4j
 uGTmvuCBtPghmG/1Yxcp6Y3s5iZsd+XQwJOAMGZSRbuxJglhee0D+RBF8F0yBl6+m/UyYQFUW7R
 e+QntWip+kGV0uQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 837BC4000B
X-Stat-Signature: rf5pp9kxpu9ht9zqgezpsb5rtbxy1nw4
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781032466-81430
X-HE-Meta: U2FsdGVkX1+S5u/I2tVRbvcXGzIDIel2fKVoD8L39kV8Fn61HfLkg+yXmko8zeQN1c1cEPQvzq4BS+ywLy8Q6NRgAzgBFJnVH3fxkkFCz5e7XVsUMy7WtPD6TYiO4Y2tHyX8CpC3gg0Fh28/xfvQawgUCjeWl/p7fpkz5mXaUd0BlK4Si13+nNEPREbYRfwdmTDrLFMKzsRQItbmtIaM4xAYcWbx8t7PqM310c1KexHB3d7tjZqMZv/3EYK0zp5/ttfon4tKpf3824rB4wSt0YFrQv2D5ZpQDLht9/4JOY/ZEQ2KnN3qb4FTDDzeRGsIGihzJBZLy42SUiyL5KUCji0kj3HcGtJ+cRyFgXw7CMkyp0oGm7MNGzzKjdbpFOhlZxykW4srv2OBknCDmDJPiRIfjLW3vVN5XqURIWMRc3qpb9Y5jCI2Ils1UqngewB7rtK+apDLFzWtbCxr0TbsF8SWuoUtZi7KpEZbsDkihCSnDc4RadVHEtYV2TDqSS6GQiFtsVkNGI5RpS/1dv67mIcdU7gnNr0YsWKZe1UFHGuMy/3unKZTTAVHI2kJkW/lR5jDZyfM7U3fAS1XeAzgG/30Z9fAwwhqMayhJI0xF9pxcvO3NpRm4DaarcX2eEzJ2Q2UnPxBrnxtVxWHoO4asuSfOikHQLqIPEmyR1w+lbcI4HgzAOGWZoKs9CSIX96sg0n/dJm9pmcUHeJYalsA/Inkxji5BDzvCDStMtkGnJQMMLjCesuRND/ZePVL3846QRXyaXLozFXO8OlOK8rrPOz3xkEbw9lBYGGguTTfkGaHt6zUq+enCQ4t8cLtq/8m25xTxUX0vLb1gxeljfsEnjwAWgMdAJ1IM/mPtogD5Od7Z/FyKaFipuSeDoXbk2X1a6oUOyqR7Esnf/yXyYQXJpaaMy8iKoszBjTN/gD6hv4X6MUzXjsEYiFnMIPFRWVkAlrMu9Qd1p13qjC0LU8
 jcZdqFR+
 sTK4lyq/qJv21mYgsAEuMIEcFTssp70az4kXPCuzVwuJbKQO7v4PQ24YaqauuvU/2gRQcuzmuncRjqYy9pieeNQBV1PejQ9qixv/vwTYA6Elf7+8j7ilgecEKDd74pD0DGpWaNqe2KG+w0jkhu8T9HzP5w+YcieRrchLGoFuOrCDxUJwqaIHCg5i08ZrFJ85kFE8GjEdoVOxc5pTWPNyLtkTU9GUyJaUK7jU1P9dR1XPZpCv9k8/5XtkztuAKoWNhNa+OOyCye9qzG2sWxsev1roECZNJXQqfk9hsfow/q+tGGEpeA8PFIU7ia+DVYgxi9cgv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the `Flag` enum and `Flags` type as Rust abstractions for the C
`REQ_*` request flags. These flags modify how block I/O requests are
processed, including sync behavior, priority hints, and integrity
settings.

Also add a `flags()` method to `Request` to retrieve the flags for a
given request.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/bindings/bindings_helper.h      | 21 ++++++++++++
 rust/kernel/block/mq.rs              |  2 ++
 rust/kernel/block/mq/request.rs      | 12 +++++++
 rust/kernel/block/mq/request/flag.rs | 65 ++++++++++++++++++++++++++++++++++++
 4 files changed, 100 insertions(+)

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 2a69c17bf271..7acda3ae9725 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -140,6 +140,27 @@ const blk_status_t RUST_CONST_HELPER_BLK_STS_OFFLINE = BLK_STS_OFFLINE;
 const blk_status_t RUST_CONST_HELPER_BLK_STS_DURATION_LIMIT = BLK_STS_DURATION_LIMIT;
 const blk_status_t RUST_CONST_HELPER_BLK_STS_INVAL = BLK_STS_INVAL;
 const blk_features_t RUST_CONST_HELPER_BLK_FEAT_ZONED = BLK_FEAT_ZONED;
+const blk_opf_t RUST_CONST_HELPER_REQ_FAILFAST_DEV = REQ_FAILFAST_DEV;
+const blk_opf_t RUST_CONST_HELPER_REQ_FAILFAST_TRANSPORT = REQ_FAILFAST_TRANSPORT;
+const blk_opf_t RUST_CONST_HELPER_REQ_FAILFAST_DRIVER = REQ_FAILFAST_DRIVER;
+const blk_opf_t RUST_CONST_HELPER_REQ_SYNC = REQ_SYNC;
+const blk_opf_t RUST_CONST_HELPER_REQ_META = REQ_META;
+const blk_opf_t RUST_CONST_HELPER_REQ_PRIO = REQ_PRIO;
+const blk_opf_t RUST_CONST_HELPER_REQ_NOMERGE = REQ_NOMERGE;
+const blk_opf_t RUST_CONST_HELPER_REQ_IDLE = REQ_IDLE;
+const blk_opf_t RUST_CONST_HELPER_REQ_INTEGRITY = REQ_INTEGRITY;
+const blk_opf_t RUST_CONST_HELPER_REQ_FUA = REQ_FUA;
+const blk_opf_t RUST_CONST_HELPER_REQ_PREFLUSH = REQ_PREFLUSH;
+const blk_opf_t RUST_CONST_HELPER_REQ_RAHEAD = REQ_RAHEAD;
+const blk_opf_t RUST_CONST_HELPER_REQ_BACKGROUND = REQ_BACKGROUND;
+const blk_opf_t RUST_CONST_HELPER_REQ_NOWAIT = REQ_NOWAIT;
+const blk_opf_t RUST_CONST_HELPER_REQ_POLLED = REQ_POLLED;
+const blk_opf_t RUST_CONST_HELPER_REQ_ALLOC_CACHE = REQ_ALLOC_CACHE;
+const blk_opf_t RUST_CONST_HELPER_REQ_SWAP = REQ_SWAP;
+const blk_opf_t RUST_CONST_HELPER_REQ_DRV = REQ_DRV;
+const blk_opf_t RUST_CONST_HELPER_REQ_FS_PRIVATE = REQ_FS_PRIVATE;
+const blk_opf_t RUST_CONST_HELPER_REQ_ATOMIC = REQ_ATOMIC;
+const blk_opf_t RUST_CONST_HELPER_REQ_NOUNMAP = REQ_NOUNMAP;
 const fop_flags_t RUST_CONST_HELPER_FOP_UNSIGNED_OFFSET = FOP_UNSIGNED_OFFSET;
 
 const xa_mark_t RUST_CONST_HELPER_XA_PRESENT = XA_PRESENT;
diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
index 23bf95136bc1..9bad95d79230 100644
--- a/rust/kernel/block/mq.rs
+++ b/rust/kernel/block/mq.rs
@@ -137,6 +137,8 @@
 };
 pub use request::{
     Command,
+    Flag as RequestFlag,
+    Flags as RequestFlags,
     IdleRequest,
     Request,
     RequestTimerHandle, //
diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index dbe657a80324..84f8b2c17f85 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -48,6 +48,12 @@
 mod command;
 pub use command::Command;
 
+mod flag;
+pub use flag::{
+    Flag,
+    Flags, //
+};
+
 /// A [`Request`] that a driver has not yet begun to process.
 ///
 /// A driver can convert an `IdleRequest` to a [`Request`] by calling [`IdleRequest::start`].
@@ -125,6 +131,12 @@ pub fn command(&self) -> Command {
         unsafe { Command::from_raw(self.command_raw()) }
     }
 
+    pub fn flags(&self) -> Flags {
+        // SAFETY: By C API contract and type invariant, `cmd_flags` is valid for read
+        let flags = unsafe { (*self.0.get()).cmd_flags & !((1 << bindings::REQ_OP_BITS) - 1) };
+        Flags::try_from(flags).expect("Request should have valid flags")
+    }
+
     /// Get the target sector for the request.
     #[inline(always)]
     pub fn sector(&self) -> u64 {
diff --git a/rust/kernel/block/mq/request/flag.rs b/rust/kernel/block/mq/request/flag.rs
new file mode 100644
index 000000000000..01f249269803
--- /dev/null
+++ b/rust/kernel/block/mq/request/flag.rs
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: GPL-2.0
+use crate::{
+    bindings,
+    impl_flags, //
+};
+
+impl_flags! {
+    /// A set of request flags.
+    ///
+    /// This type wraps the C `REQ_*` flags and allows combining multiple flags
+    /// together. These flags modify how a block I/O request is processed.
+    #[derive(Debug, Clone, Default, Copy, PartialEq, Eq)]
+    pub struct Flags(u32);
+
+    /// Individual request flags for block I/O operations.
+    ///
+    /// These flags correspond to the C `REQ_*` defines in `linux/blk_types.h`
+    /// and are used to modify the behavior of block I/O requests.
+    #[derive(Debug, Clone, Copy, PartialEq, Eq)]
+    pub enum Flag {
+        /// No driver retries on device errors.
+        FailfastDev = bindings::REQ_FAILFAST_DEV,
+        /// No driver retries on transport errors.
+        FailfastTransport = bindings::REQ_FAILFAST_TRANSPORT,
+        /// No driver retries on driver errors.
+        FailfastDriver = bindings::REQ_FAILFAST_DRIVER,
+        /// Request is synchronous (sync write or read).
+        Sync = bindings::REQ_SYNC,
+        /// Metadata I/O request.
+        Meta = bindings::REQ_META,
+        /// Boost priority in CFQ scheduler.
+        Priority = bindings::REQ_PRIO,
+        /// Don't merge this request with others.
+        NoMerge = bindings::REQ_NOMERGE,
+        /// Anticipate more I/O after this one.
+        Idle = bindings::REQ_IDLE,
+        /// I/O includes block integrity payload.
+        Integrity = bindings::REQ_INTEGRITY,
+        /// Forced unit access - data must be written to persistent storage
+        /// before command completion is signaled.
+        ForcedUnitAccess = bindings::REQ_FUA,
+        /// Request a cache flush before this operation.
+        Preflush = bindings::REQ_PREFLUSH,
+        /// Read ahead request, can fail anytime.
+        ReadAhead = bindings::REQ_RAHEAD,
+        /// Background I/O operation.
+        Background = bindings::REQ_BACKGROUND,
+        /// Don't wait if the request would block.
+        NoWait = bindings::REQ_NOWAIT,
+        /// Caller polls for completion using `bio_poll`.
+        Polled = bindings::REQ_POLLED,
+        /// Allocate I/O from cache if available.
+        AllocCache = bindings::REQ_ALLOC_CACHE,
+        /// Swap I/O operation.
+        Swap = bindings::REQ_SWAP,
+        /// Reserved for driver use.
+        Driver = bindings::REQ_DRV,
+        /// Reserved for file system (submitter) use.
+        FsPrivate = bindings::REQ_FS_PRIVATE,
+        /// Atomic write operation.
+        Atomic = bindings::REQ_ATOMIC,
+        /// Do not free blocks when zeroing (for write zeroes operations).
+        NoUnmap = bindings::REQ_NOUNMAP,
+    }
+}

-- 
2.51.2




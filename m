Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C2F1E63F25
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBB5E6B0104; Sun, 15 Feb 2026 18:52:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B65176B0105; Sun, 15 Feb 2026 18:52:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A91D76B0107; Sun, 15 Feb 2026 18:52:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 353E16B0104
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:52:36 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43D4EC35B1
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:45:53 +0000 (UTC)
X-FDA: 84448326186.25.BC9991B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8B80D8000D
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:45:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jKuMyOSF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y1WFjMpMok/GlDAAFwHSMuvpxnXPXIB8AZFxuLG0QQo=;
	b=ca5AdVOGbeIaS9viiWUZcCZpDWsPWXK98MT7VMpT5tHKmbWfOd2gI6pYfuNdAcxCk+mk7o
	z65jRIugB5rzntoQervvtUP9FmmMacp8UAGa8+19d0HdZP6M2ymJ9eoq8HgeCn2e+l7g9u
	4ooeC1PAHz79ycsyqe905gahkhTAi0E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199151; a=rsa-sha256;
	cv=none;
	b=R/SCGuyh6OcgkhsOi8KELvBdOpaLKVvs8EfDdW/24xLRcoLMRiLOfujNdC4RLoRP/tGJrc
	PfPEhUx9TO0A88XGrl3ovVpV89vf7AWwt5sQQNqdWx6uKBKWYcxa0NjgHsYnMrp0CtdtaF
	7KTMTo0KUqljyyTlRET1bvd5Xh5JiBE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jKuMyOSF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 057AC6013E;
	Sun, 15 Feb 2026 23:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6295DC4CEF7;
	Sun, 15 Feb 2026 23:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199150;
	bh=Cd90Kd9HZBS+t07qweteZVt5e7ejNNo7uFQ2B+yelCs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=jKuMyOSFwHX0iejhTs6DSzYtDAHi0TVVWOXrm312C8vhFHJSLdQ3Qle0ezUBJQsw/
	 BSjBS9FT9sjz2iinpGKkXF+uXTaJcMDWxTE1PpXiRwy+F01l/qjyqwi8qoNi9kXhiv
	 z2af+M/GRndl5ZsexUd9sVl++PujRwZvbxYVVw44vVapdsfjxyFKx50JAVRdT/X/ih
	 ZF67rBtRb8vcjHOIa8k9Z7+IEvvKLtMWk/jUoRlMlgxs0DHOpCm2EbmQB/3oJ/Xav2
	 64j1uyqB/P/qRkcufIMYcor/n3SQyW1s/JdFk8MwOP5FaY3Nq79eBCloOG5bQ0zP1N
	 pdALkPc3DGxsw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:42 +0100
Subject: [PATCH 55/79] block: rust: add request flags abstraction
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-55-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7161; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=Cd90Kd9HZBS+t07qweteZVt5e7ejNNo7uFQ2B+yelCs=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhN/gQhzHqP+13Aj/SzVGlQW5wV04BcO9cf5
 o5yh0IrX8eJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYTQAKCRDhuBo+eShj
 d17mD/9bbJUdmA/hnedCkeHucvwcMhmYMNx/PApRtG54XNFS/o5+Z4hGXSUFO8b2BSrr3Av7LoK
 LrfBvkr3pORY0mA4uOssbPoIvhuyYniEuNyjdp7eaujRBCwz+4hA6a2pMu0lRxG3288s/7TnrK0
 uM2oZsPIMyw+KIHeMmArlVqsHDo/WycktYLXetrMx9B9ZOgdNmfkOj5sxH2jWzXG1/P1Blxb5DQ
 38JvKPe5DiihDyGnTVtK2GYhUuD96kum8ZU4jsS9MYZCIC3N4PhwaaBbmFV/zFiL99/xJh1lqdj
 QcHNVaiIhCoo071CMXZGCQqySMsiof0WmtZmybW+wS14ubNvIEWv6hkFep1+ji2iR6s0orB5egx
 jjYO1ZM/K5EIoiN1YPkW4AtySA+kG2GnpuoUnaamv+lLEliQiUjmvRqQzsP1C37SiPiD7gldCVO
 juSzBOu/wITj/idLDHbNv8IxdV1muTtWds7JzF4gOHBnGHm33L6rIVx/kMgPKhgzB5O8vn2cSIi
 ABvkS4pBH7SQFR5Ckkl7pescdpJ9+CAcr1Ph/O829WEFjsi2F3DVkqfJZkTBMJnAGvX1v7bT1ip
 M7ozfp78KMpSkVceNkwDEZOPxXJQLpvbKyqxtuUzxB5l17pLrV2y5dvpQtvFBGgZ1J5MgAIQP9U
 N888I4Cln+wpFxg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 8B80D8000D
X-Stat-Signature: frzcgpcypt3fy9hkxd5rer9sccahj9k9
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1771199151-790227
X-HE-Meta: U2FsdGVkX18+9jpgYifvmPDadqnt35Srm6SuBuR07XlUkp1iHfPB+9shRrdbHrOsG5xdEsvhj7znMaxTjnn3W9nikqkOgw5c1ATKtWZUhDIVQmHbGgMo12Gt2VPFh3t+XZpOm1D5dGOk0ItMD1wBdzG3l66N7boNs/jeX0WaJCH3o3YqMQvUNVn3Aaf0zd3AY5ScigXRuJTz/ld3w41AJr+6z7sHLBHqtW7D/TrPrh2aQHtf0rDdFRplhHx+c8qiy0hO7RiHS6a6mLGM/Nxbhz5rXmGe+/PYXXcMcBbD3h96vXXNXpX+I4oUkOwsnfMlKOErWrdRXG0JJe9PG0Hms3zMRjJP7s0TQg6Wy9wW6PLMSIrRKwKKGBYocBd5SG83pHn+/TzNFhAs67JAjlVyoH7UNiKOohLlc0f6TEDVYjUlfCYT6iXCeeja0aKdj/CgklWIebkgjUXRA732q1etVC7xT84D3Uu2pKNvdoPGKFuBh0xtfBu1p0y43tv4BaoB7u7ceieN1Eke0Jpk5fkp29qhS8Qrb8ccErJIoqJT9mwQ7UTHGGqaxm0IXEv3qhvrZS9kyLjaCf3ROIoVSSP6RlRmeYyMhfrs1A6uOtMtMQumwqzdpREcRRYRDVA0mFvvd7HWlCVQRm5nvCGcD5D9k1MBQVzYmz0t5FBzhSOpyukw6e4T2nVZCALDiqxD+ouxeMN+yjm/HTtyyFJWQE9ZNKMPz+lCShar8Bl2FriL+uEYWhqVM1InMc4Ou666Zv4hb6gRBeXYe0QXPR8LUJkbyvjrUu0vlm8ng/nat+gsJ6yenT8iE0BmkbQ3zI1dgrJEBvnk5eWlcHWeA95E6VM0HuXE6ialGjuzwnZ3Xpmns4ZimuInYmIkjQj6izZBaDoZj3fI3xteKMgIOB3Kj3JML1ROfeC5l1eRjffhHurdkxlR786rlkZ/7SkdQxb5MDFeXN52QcdCuTidDbYnvJb
 10iEJE+X
 qyCGxT7xrW7ODRi9J+Dwje9qpskbStkp5cXLKK55XvbBmhmfzC3jkeKOAFmtjcuvW3kZ8nMtQopHBG5qHOASUYIbKCUPv42c1RfQRSyV+9cTQe1/jzC3LHb4jJ7u/oLVusxaMuR8R692E+x8MtPgx0gvuXW75DI2xVSRO1ddc3U1p5KpLDb3tkNJbeC7gWtgOgWgReUZlzbEBe6nzowJfNEsvUEA979h0Yb5SEO8JL/Kbt9WPLLRlewEcV6s9K3pBozqCSeZ/V/o5V3gUFLR/0JxILGzwtCgYmCo7EJFgjTcjXPDDuI+o5Y58Xqrz1umUwgFD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 rust/kernel/block/mq/request.rs      |  9 ++++++
 rust/kernel/block/mq/request/flag.rs | 62 ++++++++++++++++++++++++++++++++++++
 4 files changed, 94 insertions(+)

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 05133a78ecf95..b8c2f3eadc730 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -134,6 +134,27 @@ const blk_status_t RUST_CONST_HELPER_BLK_STS_OFFLINE = BLK_STS_OFFLINE;
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
index 1d58eea971bd7..5a1c8e914bb9e 100644
--- a/rust/kernel/block/mq.rs
+++ b/rust/kernel/block/mq.rs
@@ -134,6 +134,8 @@
 pub use operations::IoCompletionBatch;
 pub use operations::Operations;
 pub use request::Command;
+pub use request::Flag as RequestFlag;
+pub use request::Flags as RequestFlags;
 pub use request::IdleRequest;
 pub use request::Request;
 pub use request::RequestTimerHandle;
diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index b4f5a98a97b16..cebb30fe9b3bc 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -27,6 +27,9 @@
 mod command;
 pub use command::Command;
 
+mod flag;
+pub use flag::{Flag, Flags};
+
 /// A [`Request`] that a driver has not yet begun to process.
 ///
 /// A driver can convert an `IdleRequest` to a [`Request`] by calling [`IdleRequest::start`].
@@ -104,6 +107,12 @@ pub fn command(&self) -> Command {
         unsafe { Command::from_raw(self.command_raw()) }
     }
 
+    pub fn flags(&self) -> Flags {
+        // SAFETY: By C API contract and type invariant, `cmd_flags` is valid for read
+        let flags = unsafe { (*self.0.get()).cmd_flags & !((1 << bindings::REQ_OP_BITS) - 1) };
+        Flags::try_from(flags).expect("Request should have valid falgs")
+    }
+
     /// Get the target sector for the request.
     #[inline(always)]
     pub fn sector(&self) -> u64 {
diff --git a/rust/kernel/block/mq/request/flag.rs b/rust/kernel/block/mq/request/flag.rs
new file mode 100644
index 0000000000000..47d25224a1ab4
--- /dev/null
+++ b/rust/kernel/block/mq/request/flag.rs
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0
+use kernel::prelude::*;
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




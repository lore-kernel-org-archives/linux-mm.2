Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35317EF48CC
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 06:43:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BBED6B0005; Fri, 13 Feb 2026 01:43:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2696C6B0089; Fri, 13 Feb 2026 01:43:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 141706B008A; Fri, 13 Feb 2026 01:43:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 05CCA6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 01:43:11 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 79FAE58951
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 06:43:10 +0000 (UTC)
X-FDA: 84438491340.07.DE43B26
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id BDAFF40003
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 06:43:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aLknHnHW;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770964988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qMyxpRUusn7oNBfTF95R67X2upGkFmt6HUs4Zd1DSBE=;
	b=enpWY4xRAwWSmOa6G69xS4NEsXrQvfsfKMRxn8JNAeuzO7V0ZnReTMzhp+L6GBNb5XjLZ7
	cuJ5uHl37I53wQ5qBOHrZI4C0Qs/9C/AX9fehE+tZMj/9ib9V6yOdbkx3NDZimVb8lL6gB
	UWsqMQj1O/N07KbpIyBmZFayXti+giI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aLknHnHW;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770964988; a=rsa-sha256;
	cv=none;
	b=KjqCB5QMu3g5e8yy6nGt1hoK5E4VMk5Ft1AWsyUWgjE4uhwSJZgcOH7vKNmCULcd/yulqB
	c/zISN6MGuIqNMTrtrhZ2yQVSKEy/5uDcGrQ+QhX654jQPSaV0MwiPDIk87A3MqP23WVBO
	zWVe1E3xXvGaT7+Jsg+b8JuMDsiDEn4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D4D360018;
	Fri, 13 Feb 2026 06:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96301C116C6;
	Fri, 13 Feb 2026 06:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770964987;
	bh=rkRKmejGZTKsqv4gfmca2YCfS5O5A6zUCPL44REt0Ww=;
	h=From:Date:Subject:To:Cc:From;
	b=aLknHnHWc5pxfedQscnIvN967e30fMYR1Wb6x0cNQm3iipfnVqiocDAbCddF7ZzNR
	 AC2BXnAT8fNc4ZKVN33VwBY9d1JY61hNO30b6vw+yOBYZz+/EwdughU6ZgmTFRSGne
	 250OU7KC8IoM9hbvXQiv+8VowNnpzm8Zc75F75kpohu06DJVktAdDgssrSMMJNqB0B
	 tRrEi1UWlsdubLi3pfyC1rmmZB0c998A2VZHUtx+wtWgwGF82WNFeODLSORHPDqT/Y
	 2B4lSMLe6vzPTRVCBxgY2oJPxQ6zH8auAT9BmLxn/j+WwBj1xRtPva8wEGBNX8DulT
	 iDX+2cMkTPP+w==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 13 Feb 2026 07:42:53 +0100
Subject: [PATCH v3] rust: page: add byte-wise atomic memory copy methods
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org>
X-B4-Tracking: v=1; b=H4sIAOzHjmkC/33NwQrCMAwG4FcZPVtpU7o5T76HeKhtuhXHOtpRl
 LF3N9tFBJGc/j/ky8IypoCZnauFJSwhhzhSUIeK2d6MHfLgKDMQUAupBJ8MdSUOZg4DLSMX2nv
 dai0apxidTQl9eO7k9Ua5D3mO6bV/KHJr/2BFcprWK6fw5KHWlwemEYdjTB3btAIfAST8EIAEo
 2p7bxsntYUvYV3XNwnOXNDzAAAA
X-Change-ID: 20260130-page-volatile-io-05ff595507d3
To: Alice Ryhl <aliceryhl@google.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=8748; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=rkRKmejGZTKsqv4gfmca2YCfS5O5A6zUCPL44REt0Ww=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpjsftWL0YJgnkOH5vzTT47x9cfDPFsxWkwUt6X
 BEOQP7VTd6JAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaY7H7QAKCRDhuBo+eShj
 d+YlD/40kXJBDnl9Mx6RcvqgV2jhQENDzLqHVZFYcKd/9JZkmHgUUOJsLhRV6IjIrig/4Ee2IJF
 OoN4NMJnNDQHxmdniDm1qvwDYoPC9oLr0FIB2Uis6Tu6ZGYOFVOjvR9DsGjTEkyVXM2zixY33VK
 slczOXBICbgAybs4whuEzPg8VrBVdoyOr3A310njCTKbvkz07CHRB/x+NKTtmSh65S7IdaDRXFM
 jbR7X0JxttyCnCsJq1PG5o1tEpwTEKGU9qFzY8JXcxC1cGBJ1zN6Ewo6KHR7O3y1jGVal7tofw2
 GehBZ9idotgzD8W2ZBjCvmmK6saKRCutQVQ9wzKTVIS1eiwza5gLaEatxoHbD36PJrxeJ4lwoKm
 oo69p3sMqUd12ziQ68e/ncNMAC+d/WPwOrf3rDo11APQBz2c8YVVnW7oluiXVgLCPc8yAsHvnMO
 sEEHyNVnu0DsR2RLqXWq2duwTS/SPy2tBWJhLw8Jt9yJnL56c/zBYQFx6MPZRERr8fBguvCvuE5
 zqcxRbRLmORyqlYle9+vp4sdR0GFxVr7cbX/T5MNY2xjMuWi2EyhFIIJZgx37LrB8+TS+AkjNcZ
 aTN1ntPlmaePNRq3rb4AyMKH8XtjBqMi8lQqbxj2DFueH9Q/+G7mdyz64U0pAOwGx5398YJYDTp
 LUfp6lftEo9D3jw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BDAFF40003
X-Stat-Signature: 3iacfm3a945nq9spqpnpd1qsuhtxk6sq
X-Rspam-User: 
X-HE-Tag: 1770964988-139755
X-HE-Meta: U2FsdGVkX1/YGXwqn9MlohcjlOC1zndYu8FQU6ovv88/t22jchMT6kTgDP8waSFRTgifEs2+oKLC1z5epCH+aGEIjHNi7zsjeWj6LgxSfZpelpfFVWMHWIvDzpERrmJ2DL9FFwSUvuV1+qYRp94IF/t+dU8EuTfxpc80qbxGjFMazhLJyueIZvCZKuPryf+WH6Ps9tBvaKyTOA7h0zvR4VEX0XwBaZ13OBDEYquuKjXj/bkoQn0FVs0ULUZ0yPBDJtTJTEX6KBeba0pXtHtU9MRwa9oj256ZWtZIUG4BEDNpmxHGpBOMQvcUut5WyE+pUxFj6PHhbixEyrI9QB298lXRVCtOn/IqOb3nV/u7iEj51s6TN540GcO4NQtHewufHEK9cNipC97r4AS7G+ZayI0nEAdwCIBevHw+CeQ+RpUHFdcgWSLvaz8w8Lh/pOYprvb029woCLG+AsLybwCJC9Qj4ZtC06OiHcffaVv0QSK1OB/o06au8OJb7dNoNWZIuW6iOPjH5kj5qjHgepwxGBKC9DwdrUHBWLN83bnb1E6usj0myg8aHKW7s/G90Er/tI1wtSwpD4/T1Z9fyo+lwYCe18fshMMpOO6PMFa/3sDA071rzlJBTSM97QNH7KGG9Z/0OAWXMRnMnate8lkK6rkiLJNARBiECxFW40MNK8qa8uapoU7gIPenJQ4/2iQphEuPYUV3tsvCrxE8Q8yfoQb/yfHzNKH6x2Lx98ZosUoFNme6EtWHMaFR3tO2+lt6OdndoJPdZsx1fZcFo3mvUan1eucrdZRRb0TJJDgQ5Sg6rxxo5B2UXizH8c7AW8Z+QKBIlFFV0HU4MdXhifESeD1HBA7Ujm4K7gK3yd8RxCNwHv88J96NDAAsJsAdYQJtPIwg5ztahgNnm8IYDxsNbA0eaq93fucP7IO8q9Kdu0Ojj8NwT1nztde9y1xppIGOhhgRDHj8nbtGQqwcgf2
 1fE5pysp
 ALkBRQ8DOkSaHSGLoy80b6U3qbvVisHQe7hA5XyxgaSFblYHOHCLPZMqCoY1YvqREZUwGwD4ajbSlgGYyspF/b5AoaUEHJ7KjFMeBugJb5ox3S9wW5yJglJjHd3o5LP3ln1GvgIAZYOCjicM0DNaOWE5P+jYq3BORbEm6INW+1aQnLFC7fSbSFkE3jBUZdO+ivZyG0oNYNrzzYu14wIiy/3hde3CdqQsja1DzeaMcERGKv9zDZFPP95/G7Lv3NKElGsdyVRvkmhK9XBfClKQucZECcR/+r3NefEDkmtAtppbvAot7j1ttu73/GKfK/Yvxavher4Gf6Ul+T0iV29I98AGu0XNZuWjZ030XXXoL7MfJtXi02iTositFA9H0icTKqchh3HYQjrAvGJI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When copying data from buffers that are mapped to user space, it is
impossible to guarantee absence of concurrent memory operations on those
buffers. Copying data to/from `Page` from/to these buffers would be
undefined behavior if no special considerations are made.

Add methods on `Page` to read and write the contents using byte-wise atomic
operations.

Also improve clarity by specifying additional requirements on
`read_raw`/`write_raw` methods regarding concurrent operations on involved
buffers.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
Changes in v3:
- Update documentation adn safety requirements for `Page::{read,write}_bytewise_atomic`.
- Update safety comments in `Page::{read,write}_bytewise_atomic`.
- Call the correct copy function in `Page::{read,write}_bytewise_atomic`.
- Link to v2: https://msgid.link/20260212-page-volatile-io-v2-1-a36cb97d15c2@kernel.org

Changes in v2:
- Rewrite patch with byte-wise atomic operations as foundation of operation.
- Update subject and commit message.
- Link to v1: https://lore.kernel.org/r/20260130-page-volatile-io-v1-1-19f3d3e8f265@kernel.org
---
 rust/kernel/page.rs        | 76 ++++++++++++++++++++++++++++++++++++++++++++++
 rust/kernel/sync/atomic.rs | 32 +++++++++++++++++++
 2 files changed, 108 insertions(+)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index 432fc0297d4a8..d4494a7c98401 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -260,6 +260,8 @@ fn with_pointer_into_page<T>(
     /// # Safety
     ///
     /// * Callers must ensure that `dst` is valid for writing `len` bytes.
+    /// * Callers must ensure that there are no other concurrent reads or writes to/from the
+    ///   destination memory region.
     /// * Callers must ensure that this call does not race with a write to the same page that
     ///   overlaps with this read.
     pub unsafe fn read_raw(&self, dst: *mut u8, offset: usize, len: usize) -> Result {
@@ -274,6 +276,40 @@ pub unsafe fn read_raw(&self, dst: *mut u8, offset: usize, len: usize) -> Result
         })
     }
 
+    /// Maps the page and reads from it into the given memory region using byte-wise atomic memory
+    /// operations.
+    ///
+    /// This method will perform bounds checks on the page offset. If `offset .. offset+len` goes
+    /// outside of the page, then this call returns [`EINVAL`].
+    ///
+    /// # Safety
+    ///
+    /// Callers must ensure that:
+    ///
+    /// - `dst` is valid for writes for `len` bytes for the duration of the call.
+    /// - For the duration of the call, other accesses to the area described by `dst` and `len`,
+    ///   must not cause data races (defined by [`LKMM`]) against atomic operations executed by this
+    ///   function. Note that if all other accesses are atomic, then this safety requirement is
+    ///   trivially fulfilled.
+    /// - Callers must ensure that this call does not race with a write to the source page that
+    ///   overlaps with this read.
+    ///
+    /// [`LKMM`]: srctree/tools/memory-model
+    pub unsafe fn read_bytewise_atomic(&self, dst: *mut u8, offset: usize, len: usize) -> Result {
+        self.with_pointer_into_page(offset, len, move |src| {
+            // SAFETY:
+            // - If `with_pointer_into_page` calls into this closure, then it has performed a
+            //   bounds check and guarantees that `src` is valid for `len` bytes.
+            // - By function safety requirements `dst` is valid for writes for `len` bytes.
+            // - By function safety requirements there are no other writes to `src` during this
+            //   call.
+            // - By function safety requirements all other access to `dst` during this call are
+            //   atomic.
+            unsafe { kernel::sync::atomic::atomic_per_byte_memcpy(src, dst, len) };
+            Ok(())
+        })
+    }
+
     /// Maps the page and writes into it from the given buffer.
     ///
     /// This method will perform bounds checks on the page offset. If `offset .. offset+len` goes
@@ -282,6 +318,7 @@ pub unsafe fn read_raw(&self, dst: *mut u8, offset: usize, len: usize) -> Result
     /// # Safety
     ///
     /// * Callers must ensure that `src` is valid for reading `len` bytes.
+    /// * Callers must ensure that there are no concurrent writes to the source memory region.
     /// * Callers must ensure that this call does not race with a read or write to the same page
     ///   that overlaps with this write.
     pub unsafe fn write_raw(&self, src: *const u8, offset: usize, len: usize) -> Result {
@@ -295,6 +332,45 @@ pub unsafe fn write_raw(&self, src: *const u8, offset: usize, len: usize) -> Res
         })
     }
 
+    /// Maps the page and writes into it from the given memory region using byte-wise atomic memory
+    /// operations.
+    ///
+    /// This method will perform bounds checks on the page offset. If `offset .. offset+len` goes
+    /// outside of the page, then this call returns [`EINVAL`].
+    ///
+    /// # Safety
+    ///
+    /// Callers must ensure that:
+    ///
+    /// - `src` is valid for reads for `len` bytes for the duration of the call.
+    /// - For the duration of the call, other accesses to the areas described by `src` and `len`,
+    ///   must not cause data races (defined by [`LKMM`]) against atomic operations executed by this
+    ///   function. Note that if all other accesses are atomic, then this safety requirement is
+    ///   trivially fulfilled.
+    /// - Callers must ensure that this call does not race with a read or write to the destination
+    ///   page that overlaps with this write.
+    ///
+    /// [`LKMM`]: srctree/tools/memory-model
+    pub unsafe fn write_bytewise_atomic(
+        &self,
+        src: *const u8,
+        offset: usize,
+        len: usize,
+    ) -> Result {
+        self.with_pointer_into_page(offset, len, move |dst| {
+            // SAFETY:
+            // - By function safety requirements `src` is valid for writes for `len` bytes.
+            // - If `with_pointer_into_page` calls into this closure, then it has performed a
+            //   bounds check and guarantees that `dst` is valid for `len` bytes.
+            // - By function safety requirements there are no other writes to `dst` during this
+            //   call.
+            // - By function safety requirements all other access to `src` during this call are
+            //   atomic.
+            unsafe { kernel::sync::atomic::atomic_per_byte_memcpy(src, dst, len) };
+            Ok(())
+        })
+    }
+
     /// Maps the page and zeroes the given slice.
     ///
     /// This method will perform bounds checks on the page offset. If `offset .. offset+len` goes
diff --git a/rust/kernel/sync/atomic.rs b/rust/kernel/sync/atomic.rs
index 4aebeacb961a2..8ab20126a88cf 100644
--- a/rust/kernel/sync/atomic.rs
+++ b/rust/kernel/sync/atomic.rs
@@ -560,3 +560,35 @@ pub fn fetch_add<Rhs, Ordering: ordering::Ordering>(&self, v: Rhs, _: Ordering)
         unsafe { from_repr(ret) }
     }
 }
+
+/// Copy `len` bytes from `src` to `dst` using byte-wise atomic operations.
+///
+/// This copy operation is volatile.
+///
+/// # Safety
+///
+/// Callers must ensure that:
+///
+/// - `src` is valid for reads for `len` bytes for the duration of the call.
+/// - `dst` is valid for writes for `len` bytes for the duration of the call.
+/// - For the duration of the call, other accesses to the areas described by `src`, `dst` and `len`,
+///   must not cause data races (defined by [`LKMM`]) against atomic operations executed by this
+///   function. Note that if all other accesses are atomic, then this safety requirement is
+///   trivially fulfilled.
+///
+/// [`LKMM`]: srctree/tools/memory-model
+pub unsafe fn atomic_per_byte_memcpy(src: *const u8, dst: *mut u8, len: usize) {
+    // SAFETY: By the safety requirements of this function, the following operation will not:
+    //  - Trap.
+    //  - Invalidate any reference invariants.
+    //  - Race with any operation by the Rust AM, as `bindings::memcpy` is a byte-wise atomic
+    //    operation and all operations by the Rust AM to the involved memory areas use byte-wise
+    //    atomic semantics.
+    unsafe {
+        bindings::memcpy(
+            dst.cast::<kernel::ffi::c_void>(),
+            src.cast::<kernel::ffi::c_void>(),
+            len,
+        )
+    };
+}

---
base-commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
change-id: 20260130-page-volatile-io-05ff595507d3

Best regards,
-- 
Andreas Hindborg <a.hindborg@kernel.org>




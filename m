Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0654EE3692
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 14:51:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DD2C6B008A; Thu, 12 Feb 2026 09:51:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2838E6B008C; Thu, 12 Feb 2026 09:51:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15FBA6B0092; Thu, 12 Feb 2026 09:51:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 05C656B008A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:51:46 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A7F4856338
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:51:45 +0000 (UTC)
X-FDA: 84436093770.26.A2C22EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id D09C51C0007
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:51:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="H30/4GJH";
	spf=pass (imf21.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770907903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UM3n37TzH5ugrDM0ITmu/IzVA9zdA5J+00OlckuGAAs=;
	b=aBk+u+UVOtB0NFSs8uRJnYAa7N5s99NmYF2yBx3DvxreLTkK80cVLMzGqbwkh6BcEE1kkE
	JfmD58OdzpxbOjpk78p1TZDnQqofCIFYlT2yvlEJGODExZdf7LA7sp34hH46xWVoOv5Oiu
	rQNIHEHlTj8rE4fTxuHH0Pbp5MtHqtI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="H30/4GJH";
	spf=pass (imf21.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770907904; a=rsa-sha256;
	cv=none;
	b=5E0lrjoKQhKF72LoRp8LuzOg8tO7YOI2Gs58ON8o/XYpHWZ8Df+cpCy7JHCJaZwgzKNhIx
	tbjSz8s/sg454YqUi7J9j463I5BZE5yOOmHyjQENeCvdAmbHEnyRsv7OTEkSTisJQsnOzR
	gZxKWplf/htDJYCCGCtnElTO4ckH1Ow=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2463060051;
	Thu, 12 Feb 2026 14:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A36C4CEF7;
	Thu, 12 Feb 2026 14:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770907902;
	bh=MSoxOO/aajimGBe8zSRRwjtwt1Ctq+tdq12YYd+aCkc=;
	h=From:Date:Subject:To:Cc:From;
	b=H30/4GJHvmb2ovRLb7mfvVV4WxcxrD2JQvwhZskCY8xgRnyl1vkg417pq0BTaA+D2
	 nSWaAdmTMoztVfG38s+mf8y0yAHDktQ6yFgthdyvIML3ohhL6V9gzwZIgCNf16Ykuv
	 LHeQBbg86SqPTL3k7KxxjywNVkvDHRfaZeQrYaUGGlUuHpFONbQPU4+m//qjNxnxHF
	 BffF9V2yuxMexU28LSjYTB42rIV2XlftQ3C1KXFDKwPb5w7N51hubuB6ZAvEBexHox
	 t7IzU819lV66jiuplRZo4GuljKdvUSqIR21kq0W/6P1JhpPR2uULDwSnwTq507nk6U
	 WCaOQbpsCZtGQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 12 Feb 2026 15:51:24 +0100
Subject: [PATCH v2] rust: page: add byte-wise atomic memory copy methods
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260212-page-volatile-io-v2-1-a36cb97d15c2@kernel.org>
X-B4-Tracking: v=1; b=H4sIAOvojWkC/32NQQrDIBRErxL+uhajmDZd9R4lC6nf5FPRoEFag
 nfvbw5QZvVmmJkdCmbCArduh4yVCqXIoE4dPBcbZxTkmEFJNcheS7Fa9moKdqPAYRLSeG9GY+T
 FaeDamtHT+5h8TMwLlS3lz/FQ+5/7Z6z2gjV67TRevRrM/YU5YjinPMPUWvsCmJDiw7EAAAA=
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7789; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=MSoxOO/aajimGBe8zSRRwjtwt1Ctq+tdq12YYd+aCkc=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpjejsNojknJFrAiG/CbKml6BEsNEmgecCiaHNR
 Q8PBjVx1YqJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaY3o7AAKCRDhuBo+eShj
 d81YD/0fIbnhnOMjfFl69SJjgreHTO81HbH3GkxN/cUdkLp3WBi+jEh+Qs4oEJIogwzqKB1JyH9
 QvN/JH+tXz4mAvAz1v9vhwiIq1CvCi7y/BkCLPU7GOXjVWM2uzWoxtcnsQBGxgD5GojTfRR7zG9
 IrnexWOCWvoy3WcN3SDLLK492CU3lknEoOfEhcHY6KI4DEsK6ZOm9Yj1y7Z6aVx3X/dzb+1d1mR
 1rBuA1451N1ju++qvqFGsu2wkOnZYhz+rf7YGt0QvvbdxaDfT4KqEs5NYnCpsYlh1lag3Hq+hTX
 AlAi5uEAhpMhL+/T0wsv7ui4g0pqw6TcCskdEsAVWTsnaTu6ub5Mt42D4lb68qi+DL85qk3Mq/x
 HxXhrGpnM+Pc/VSLsy9GK0HwEcX4DxY5vKxv2AvFCI1B4ym2n7NM2tLlcfwuwSDFEtl+v7mJXmP
 x/WzcQYYKY9e9tyleqQOFcvTUx1l6M8ojxZtvdo7NS2G+lG1d6QRWnxttUFanHfcpkeXjermxw5
 eNfiadTQOc55e+JbSX9lZWzLJmIzSo8ilRoXxYa1VUpLb9m+XWB00Nzn6HhNsWu9sWIwoaUqAo0
 NKLaJINCrYWBzQpeInF98rNwfam/7GvRLtJ2RirSWUp4kpUKyrSQPtff2aK6nOOWAusKGyqEzyw
 eYjNBk7vVVkNS6g==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D09C51C0007
X-Stat-Signature: 51t6bjubab87aznurrdcqenpse37qkmr
X-Rspam-User: 
X-HE-Tag: 1770907903-432326
X-HE-Meta: U2FsdGVkX19k2ZaXZIjuQE/KKkpcYD07/KHUkXL6PpDu/5dXa21bmqOQjgTK4qSylGhZtKpEo6zMtm6Yoc+465itObc8Z19fnWwKBxIAwbl1kWZq0PedcidwBuCPrvnPkZLoZx1qBlzDmvF2QXL9VEQ+JYI/2NqjQzvaDbk4ghg6No2i9yZ3jZfnZKzT33nLJuWNNBT+DwbFXD+vo1ahfo+nC7LGFHtfM3YNOCbffjp22BDs84ybD+ZF1wISk+3Istu1M+59fwhTtzrnd2jBiRdCnCYo25fKCLUexxmF4SpAbczcIjSfgebl3IrO2dgZbG9uO4WHZkeWYAuddZW7OKfrBEspJs2uK7rcr32QUWnoP7PyoZZTfYNqpO2+uMDRwCSjFB6wo6+/x4GwQ5UpYyi9adkjI3PcVEQ8okF1/U6XkNbYP3EOjSSTklkj/rUbPD69xhlvBW1pFYNnz2tCb6Zj4ixLHrNR1iZUUtLAZNOobz6IFuXJKOr6vcm/OuH8oEIheMK53z6YVF+bNO0AcJLURMt1p1Ef7gsv3BUWoXspzsYIrd8Ods9cWuYb1Br8/TtFWD7D15M9shSB5S3SjsnpVj1sJ4p7tqq+P+F+qttncVTtgJZk8xVEpS/shaPrFN+cdmSxepS9ZPpeVYFrvfpDJfFLQYMYuftfOhTxLZjyeNQiUANIeICCsrvOKmdTqcltVNyuZBnfjXZqPvmyfdsfBSkjaDTk/oLWEGhraK77xnOVeFYo8pen4CkRZcIMqD105VAKQ2CshBrHQMODoYpR01+n/r+DQgYreALDoLCVGMlHLTC3kgQWxGSjRrrLFaSpkwBH7KvF5Mr76EilL3iAro8A7bQ3kNJC0Bl5FCJnmLcUdgO6lgbHzo6weNMZamhjQlAfXcWcW7Vd0HflJve02GGr/P/iI6NTG7SZs+zqsSo0XazXnxBclU4/EOH8W/iiU+mAISXemip1Bhz
 MP4vVvmS
 QaeB1P50af19mbA8yeIxmaBMZ1p3YnloR34yQUTqrSRyhRgw8/ftgTljWa/Y/AitxdiiCdhlcBWYxFKH3zGD7nWn3UtqnBKNpAcAwt9nKhKvqIZIlsvL4ytA77G+Ax/78MguY/ZssQA4jQWuJ6jjWDs8gvF+zUZlHZA9KEoa30Iyi9vDbe7R87DxSPIxnOscL6T62ze4MUoXSznj+k8kEl9xVTptbzlkL9Gitf4+plNHUa45yhTFNNGLc77a5K/HiCJ0PQduzQROYRF18zckX7mfHEfyXoPosyI8benxZdxoRxbR2j2fjiJsrId/Nd+F/3DZc3aWFVLLpz6te/R12rB6sSFjro0NeRlNh
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
Changes in v2:
- Rewrite patch with byte-wise atomic operations as foundation of operation.
- Update subject and commit message.
- Link to v1: https://lore.kernel.org/r/20260130-page-volatile-io-v1-1-19f3d3e8f265@kernel.org
---
 rust/kernel/page.rs        | 65 ++++++++++++++++++++++++++++++++++++++++++++++
 rust/kernel/sync/atomic.rs | 32 +++++++++++++++++++++++
 2 files changed, 97 insertions(+)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index 432fc0297d4a8..febe9621adee6 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -7,6 +7,7 @@
     bindings,
     error::code::*,
     error::Result,
+    ffi::c_void,
     uaccess::UserSliceReader,
 };
 use core::{
@@ -260,6 +261,8 @@ fn with_pointer_into_page<T>(
     /// # Safety
     ///
     /// * Callers must ensure that `dst` is valid for writing `len` bytes.
+    /// * Callers must ensure that there are no other concurrent reads or writes to/from the
+    ///   destination memory region.
     /// * Callers must ensure that this call does not race with a write to the same page that
     ///   overlaps with this read.
     pub unsafe fn read_raw(&self, dst: *mut u8, offset: usize, len: usize) -> Result {
@@ -274,6 +277,34 @@ pub unsafe fn read_raw(&self, dst: *mut u8, offset: usize, len: usize) -> Result
         })
     }
 
+    /// Maps the page and reads from it into the given IO memory region using byte-wise atomic
+    /// memory operations.
+    ///
+    /// This method will perform bounds checks on the page offset. If `offset .. offset+len` goes
+    /// outside of the page, then this call returns [`EINVAL`].
+    ///
+    /// # Safety
+    /// Callers must ensure that:
+    ///
+    /// - `dst` is valid for writes for `len` bytes for the duration of the call.
+    /// - For the duration of the call, other accesses to the area described by `dst` and `len`,
+    ///   must not cause data races (defined by [`LKMM`]) against atomic operations executed by this
+    ///   function. Note that if all other accesses are atomic, then this safety requirement is
+    ///   trivially fulfilled.
+    ///
+    /// [`LKMM`]: srctree/tools/memory-model
+    pub unsafe fn read_bytewise_atomic(&self, dst: *mut u8, offset: usize, len: usize) -> Result {
+        self.with_pointer_into_page(offset, len, move |src| {
+            // SAFETY: If `with_pointer_into_page` calls into this closure, then
+            // it has performed a bounds check and guarantees that `src` is
+            // valid for `len` bytes.
+            //
+            // There caller guarantees that there is no data race at the source.
+            unsafe { bindings::memcpy_toio(dst.cast::<c_void>(), src.cast::<c_void>(), len) };
+            Ok(())
+        })
+    }
+
     /// Maps the page and writes into it from the given buffer.
     ///
     /// This method will perform bounds checks on the page offset. If `offset .. offset+len` goes
@@ -282,6 +313,7 @@ pub unsafe fn read_raw(&self, dst: *mut u8, offset: usize, len: usize) -> Result
     /// # Safety
     ///
     /// * Callers must ensure that `src` is valid for reading `len` bytes.
+    /// * Callers must ensure that there are no concurrent writes to the source memory region.
     /// * Callers must ensure that this call does not race with a read or write to the same page
     ///   that overlaps with this write.
     pub unsafe fn write_raw(&self, src: *const u8, offset: usize, len: usize) -> Result {
@@ -295,6 +327,39 @@ pub unsafe fn write_raw(&self, src: *const u8, offset: usize, len: usize) -> Res
         })
     }
 
+    /// Maps the page and writes into it from the given IO memory region using byte-wise atomic
+    /// memory operations.
+    ///
+    /// This method will perform bounds checks on the page offset. If `offset .. offset+len` goes
+    /// outside of the page, then this call returns [`EINVAL`].
+    ///
+    /// # Safety
+    ///
+    /// Callers must ensure that:
+    ///
+    /// - `src` is valid for reads for `len` bytes for the duration of the call.
+    /// - For the duration of the call, other accesses to the area described by `src` and `len`,
+    ///   must not cause data races (defined by [`LKMM`]) against atomic operations executed by this
+    ///   function. Note that if all other accesses are atomic, then this safety requirement is
+    ///   trivially fulfilled.
+    ///
+    /// [`LKMM`]: srctree/tools/memory-model
+    pub unsafe fn write_bytewise_atomic(
+        &self,
+        src: *const u8,
+        offset: usize,
+        len: usize,
+    ) -> Result {
+        self.with_pointer_into_page(offset, len, move |dst| {
+            // SAFETY: If `with_pointer_into_page` calls into this closure, then it has performed a
+            // bounds check and guarantees that `dst` is valid for `len` bytes.
+            //
+            // There caller guarantees that there is no data race at the destination.
+            unsafe { bindings::memcpy_fromio(dst.cast::<c_void>(), src.cast::<c_void>(), len) };
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




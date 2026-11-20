Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9002606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GRvzZSzs
Received: by kanga.kvack.org (Postfix)
	id D96456B05B0; Fri, 20 Nov 2026 05:27:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D471A6B05B1; Fri, 20 Nov 2026 05:27:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C36476B05B2; Fri, 20 Nov 2026 05:27:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 970C06B05B0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:27:45 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B8A89A8C23
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:27:41 +0000 (UTC)
X-FDA: 85455121122.24.D22D761
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id EBDBC1C0006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:27:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GRvzZSzs;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795170460;
	b=hcXvN2fZYktHwHJu12I4KbApu3cvLCBGpz4LKMCbTcc59cUG8hZdx8triHg4cl6LnVUk11
	1HfyPLsudra10i17DnjO3gsianLTHWt1IgYjOSH3Vcx4km1VodLiIJEYrMqMRhJS1BBaEH
	U3+yMMLuj5vpbtDLKLoLirmLrge04lU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795170460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g59A01+nT81rmoGrrt0KAwfxYB65M8vKSb7GrPuEl1M=;
	b=5JBenEmBOUfkR3mff9ba1Iz890l2MSDK+NlNAWmYQc0Z8ZG4hFKg/Hvk/m5Qqfbrg/Ax/p
	8WbLajZC4LgEU3yqhOLl2Tvx6KVEDIuLfKiXp3IRG36XeeI87K39rQR0iMu2A2e2k5WWTK
	OOC0ZU4vRTWy9omhU25u5uMUIzuyFMY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GRvzZSzs;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D792245EAA;
	Fri, 20 Nov 2026 10:27:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2D51F000C0;
	Fri, 20 Nov 2026 10:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795170458;
	bh=g59A01+nT81rmoGrrt0KAwfxYB65M8vKSb7GrPuEl1M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GRvzZSzsZBC5z/3rmX5sZ0B/X9qJ7qZ0gmGYh0a1Pk0dM89zQ5qB/qXZTWeKQ/PtX
	 L3vyhOOPonnpMY/+zKPoCQ+4wk0ljq98rAYQnPO2TWeKlduN8KuEDHzK5XxwgYaDB1
	 U5k/auXMn5LQLnQvxmHghyG9P/YdLXtZUbXIk4wFG9fTDLeod5Y177R39JcWH4QqU2
	 VSHiW5xSsg1riyBLUm8GKkdhJSPuzyHSCArVLv8S87wQgT4F7AN+/siGIgqp/jHGBZ
	 eYGmMkyTn22vpB2bLTe94qQz+3x1AFb8oyEjGioJwVSV1EPP1tHidV9lX86HFS53S4
	 gSytm1/obJ5OA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Nov 2026 11:27:04 +0100
Subject: [PATCH 05/11] rust: uaccess: take a raw pointer in
 `UserSliceReader::read_raw`
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-page-shared-v1-5-66f8c4c62822@kernel.org>
References: <20261120-page-shared-v1-0-66f8c4c62822@kernel.org>
In-Reply-To: <20261120-page-shared-v1-0-66f8c4c62822@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Mark Rutland <mark.rutland@arm.com>, Lyude Paul <lyude@redhat.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 =?utf-8?q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, 
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
 Carlos Llamas <cmllamas@google.com>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7215; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=7Usj2yHs1j7uEe8QYeazPmySsi+qcWhq4l4WxUVPh7c=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBrACCGQ2GsusZYa/SRpvegY1XKVuTb+D2T5c2Ud
 My4dWTvY1uJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCawAghgAKCRD6UCkIqsW9
 0JL8D/47AJiHUud8qB957cvnHaQWcJk0uz+HIWg4nbLoy9COaTTPo9e6lgCeWuLXT6Je+Qf6Z19
 v3vt04QUIDCCZqDw/9lncvwC8FRV2goO5KSwEnb4Rz9iVfkG9WcRCdzcqa0zM+w0pNKki6AymeM
 MDJ/40GjYOh84FsHZAKkeSDZnA6tq9/rf3pXT/MXLPqhMMz2Ex5z4b+3yPDRwln+EdZqdFGp1Y4
 SH+81N/i190qkwhDCKCTbAooEjLfWKZ13Nri35/04tKpIgeVBlhVoFRGn0sqaRaYWDZ6MDe9v4D
 3G4XWpdNa1hMx4ne9FdjmbfX+R1LeFSuoRYIJhTJG2F3GceVpr62TXzE95B4DlE7DdJRigkcOpt
 x/X7Umf2FGSRC6qz4pHmPtSNxim3t1t7Iei+U2t4sKFmBjqhyCnaLtfZHL+Zd7WFISaWhKqdr9h
 JHWAVKPyTmmSjrmqHSquNgCjagOVEIc71vTUI/HuFdgBJItvSGcAe7Sqmjt38Ya4qziXC1GCn3w
 ubZzZWx1KFmDQP50sCZ8It4A/vtE3Mm4qA7Sz/+0Qfrl7YgA82Ar3eGGxyY6+6XwNWtAtlemp5Y
 tUFTL6oKDO4DjYkXeGUqTdQCmedvTWH15n649pziTEgUHBgijyzF8UBz5dzX6iNYlPbHQJftpaZ
 MfDSyq5Hz1aWb3Q==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User:
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EBDBC1C0006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: mas66dq86h9rtry9y3qxxxd9it3e1ue8
X-HE-Tag: 1795170459-806450
X-HE-Meta: U2FsdGVkX1/4G6So6nLaakoyzDDZQymt505KdX0S7kzx2qn4Q2ZTAF9ECMTHRcYGABQQ6yjXkGSA2xPvvVe69SxFm7nB/0kkUVTuWQhchTeS3r1V4dWCmEd4uUCAnD60/7JCvFxX+GdYWKdynw38IMhYlosizqgpwHsl0sLuf1lPrIakyoQesx2BDsb+eKekI3OqTICzwUVU7MKIwB/95mqHu96eLi5MJZ6XnRALUvTcfkeBZ3Y84myRj2Img16H3NNDnO2Ht2A4iqHvaZrvB4Hoc9OoYKY0YVo3mw+GT3cZxIHospB8RoRI+isQ1Snc94+2AaIVUD1izt6cCp1E6o6Nv/iBJMX/IU/MRqCkWOP37tzn8uxiQ5X1I1FYtWFJLIPYyZcDB+OFrtqq/gc/tIxyZkE3fs6PFfBEZeBvP3H34gZ8Q1HJRhSPJvY9pw6s1Ni7mm/ycRko7LccGFIyVGRnpRYsWISh2ZJNobYg9Y+3vbTQPXqMIq7AVP2Iz1KXsUoiMNCo/zTLfnAx02WLpkjCJtnqoNiBwfEetl75oI5x9xu7cDmAc+2LeFv0JcRbJucHuiPrW6J7FIzK/hvFDCE2gS7tJLUKs+hyPbXYJVRlrO6OMFWKheJ4dO1rK8OEWX+EuZ3mtmfLG7ziqjtKtzoXPTGgpHT2JmqbYYJVLduNh2IFOVo4GBp74bNKmG3K2AOWh+vJv+VSO3uHOZl/g1zFTcK8eHREVvOGey3VVG28q+tR8ah2M4LUbBM03jK5MkQHlI9wqqKIgkoVMS1bL79KbBEUdbI3FWfthtju+eWdjkWKL6lxvMayp1BT2Ys/0hTaDiNtJXJNk8MtneVCy1G0WC82J5+1Vqc8HqIlPUZEQ9gtbYN10jT+TdG4tehBObGBblFGAiaA6PWykfT3nLVjK7mAC5La7NmdQtNf8Q2UWfkWobPt0aJG5GIDosVOKk9ywlTFd+GpV5Afkb6
 Ly4fV0IJ
 I57VWuSV8+gEJ818VB7sJyDw5BNcXuQNxpS5hGcSmZxUeoj08/aSvcG4xIuka1L+DAfbDa0wu4EmtSwTUMRDaLZ5f58kvLW3n9/WT8Tk4h7jg6pHJ7JrNG1LhOhTs8NpHt6BOESF+cD4vwfNv7AIV9o8ZIE7SOQyzdr+nZ1v+bkkSNsUlhJj6iKP9tBOjNhlcBDKb0L6XjHeR+3U16PNFnKoACeZetcvf7K7l2+YW7kkyB3eMZZ66mMkaxBetvN9dCIo69uUWu/vkgtZtpGiCKYUkPDoeNNVuWqaRrG6fpdlrHVEsFfQl+/IGSmA14+OV5+xAYIt+1mcTzo0whNV8WHPH8tBiEjF0+e/lBXwYDo+Ir7pyFtHBEmn5KThKcbQjY3nbWuM7Q32Tlap+V3P5ZN1vtheUpfqE2+rf+UG1m9FGwwb8wt5jUxWMKBWM2G+zTLUUxMTQK0OF0BsIr1g+ECHR0NiUE1oCMNYyHoRghkz0mW4zCXCuGACrhANcPPRLWztxJ8Gi+xMaFlh/r6x/ghx10dRoyYCGnt9Ph4LaHsS+N1A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

`UserSliceReader::read_raw()` takes the destination as a mutable slice.
Thus, it cannot be used to copy into memory that is subject to concurrent
accesses, such as a page that is mapped to user space, since a mutable
reference to such memory must not exist.

Change `UserSliceReader::read_raw()` to take the destination as a raw
pointer and a length, and make it unsafe. The copy is done by
`copy_from_user()`, which uses byte-wise atomic store instructions for the
kernel memory, so the destination only has to be valid for atomic writes.

Update the callers. `UserSliceReader::read_slice()` remains as the safe
method for copying into a slice.

`Page::copy_from_user_slice_raw()` no longer creates a mutable slice of
the data of the page, and thus no longer writes to the page with plain
accesses. Remove the remark about this from its safety requirements.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/page.rs    |  9 ++++-----
 rust/kernel/uaccess.rs | 47 ++++++++++++++++++++++++++++++++---------------
 2 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index ff191bfcd3f9..643af7cfbef4 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -600,8 +600,7 @@ pub unsafe fn fill_zero_raw(&self, offset: usize, len: usize) -> Result {
     /// # Safety
     ///
     /// * Callers must ensure that this call does not race with a read or write to the same page
-    ///   that overlaps with this write. This includes byte-wise atomic accesses, as this method
-    ///   writes to the page with plain accesses.
+    ///   that overlaps with this write.
     /// * Callers must ensure that no reference to the data of the page that overlaps with this
     ///   write exists during this call. Such references can be obtained from a
     ///   [`Page<Exclusive>`], see [`Page::as_slice`].
@@ -613,9 +612,9 @@ pub unsafe fn copy_from_user_slice_raw(
     ) -> Result {
         self.with_pointer_into_page(offset, len, move |dst| {
             // SAFETY: If `with_pointer_into_page` calls into this closure, then it has performed a
-            // bounds check and guarantees that `dst` is valid for `len` bytes. Furthermore, we have
-            // exclusive access to the slice since the caller guarantees that there are no races.
-            reader.read_raw(unsafe { core::slice::from_raw_parts_mut(dst.cast(), len) })
+            // bounds check and guarantees that `dst` is valid for `len` bytes. The caller
+            // guarantees that there are no races, so `dst` is valid for atomic writes.
+            unsafe { reader.read_raw(dst, len) }
         })
     }
 }
diff --git a/rust/kernel/uaccess.rs b/rust/kernel/uaccess.rs
index f1aecda7a90c..b1df79500b98 100644
--- a/rust/kernel/uaccess.rs
+++ b/rust/kernel/uaccess.rs
@@ -252,25 +252,38 @@ pub fn is_empty(&self) -> bool {
         self.length == 0
     }
 
-    /// Reads raw data from the user slice into a kernel buffer.
+    /// Reads raw data from the user slice into the kernel memory at `out`.
     ///
-    /// For a version that uses `&mut [u8]`, please see [`UserSliceReader::read_slice`].
+    /// The writes to `out` are byte-wise atomic, so they are well-defined even if the memory at
+    /// `out` is concurrently accessed by hardware, by user space, or by other kernel code using
+    /// atomic or volatile accesses. For a safe version that uses `&mut [u8]`, please see
+    /// [`UserSliceReader::read_slice`].
     ///
     /// Fails with [`EFAULT`] if the read happens on a bad address, or if the read goes out of
-    /// bounds of this [`UserSliceReader`]. This call may modify `out` even if it returns an error.
+    /// bounds of this [`UserSliceReader`]. This call may modify the memory at `out` even if it
+    /// returns an error.
+    ///
+    /// Implementation note: this is implemented by the kernel's `copy_from_user()`, which is
+    /// implemented in a way such that byte-wise atomic memory store instructions are used.
     ///
     /// # Guarantees
     ///
-    /// After a successful call to this method, all bytes in `out` are initialized.
-    pub fn read_raw(&mut self, out: &mut [MaybeUninit<u8>]) -> Result {
-        let len = out.len();
-        let out_ptr = out.as_mut_ptr().cast::<c_void>();
+    /// This method only writes initialized bytes to `out`. After a successful call to this method,
+    /// all `len` bytes at `out` are initialized.
+    ///
+    /// # Safety
+    ///
+    /// Callers must ensure that `out` is valid for atomic writes for `len` bytes for the duration
+    /// of the call.
+    pub unsafe fn read_raw(&mut self, out: *mut u8, len: usize) -> Result {
         if len > self.length {
             return Err(EFAULT);
         }
-        // SAFETY: `out_ptr` points into a mutable slice of length `len`, so we may write
-        // that many bytes to it.
-        let res = unsafe { bindings::copy_from_user(out_ptr, self.ptr.as_const_ptr(), len) };
+        // SAFETY: By the safety requirements of this function, `out` is valid for atomic writes
+        // for `len` bytes. `copy_from_user()` is a byte-wise atomic operation on the kernel
+        // memory.
+        let res =
+            unsafe { bindings::copy_from_user(out.cast::<c_void>(), self.ptr.as_const_ptr(), len) };
         if res != 0 {
             return Err(EFAULT);
         }
@@ -284,10 +297,10 @@ pub fn read_raw(&mut self, out: &mut [MaybeUninit<u8>]) -> Result {
     /// Fails with [`EFAULT`] if the read happens on a bad address, or if the read goes out of
     /// bounds of this [`UserSliceReader`]. This call may modify `out` even if it returns an error.
     pub fn read_slice(&mut self, out: &mut [u8]) -> Result {
-        // SAFETY: The types are compatible and `read_raw` doesn't write uninitialized bytes to
-        // `out`.
-        let out = unsafe { &mut *(core::ptr::from_mut(out) as *mut [MaybeUninit<u8>]) };
-        self.read_raw(out)
+        // SAFETY: `out` is a mutable slice, so it is valid for writing `out.len()` bytes, and
+        // nothing else accesses it during this call. `read_raw` doesn't write uninitialized bytes
+        // to `out`.
+        unsafe { self.read_raw(out.as_mut_ptr(), out.len()) }
     }
 
     /// Reads raw data from the user slice into a kernel buffer partially.
@@ -372,7 +385,11 @@ pub fn read_all<A: Allocator>(mut self, buf: &mut Vec<u8, A>, flags: Flags) -> R
         buf.reserve(len, flags)?;
 
         // The call to `reserve` was successful, so the spare capacity is at least `len` bytes long.
-        self.read_raw(&mut buf.spare_capacity_mut()[..len])?;
+        let spare = &mut buf.spare_capacity_mut()[..len];
+
+        // SAFETY: `spare` is a mutable slice, so it is valid for writing `spare.len()` bytes, and
+        // nothing else accesses it during this call.
+        unsafe { self.read_raw(spare.as_mut_ptr().cast(), spare.len()) }?;
 
         // SAFETY: Since the call to `read_raw` was successful, so the next `len` bytes of the
         // vector have been initialized.

-- 
2.54.0




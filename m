Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6374D60A262A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RoMd+8ZH
Received: by kanga.kvack.org (Postfix)
	id 7304E6B05C3; Fri, 20 Nov 2026 05:28:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E02F6B05C4; Fri, 20 Nov 2026 05:28:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CF436B05C5; Fri, 20 Nov 2026 05:28:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2FB016B05C3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:28:50 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B8047A8E70
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:28:49 +0000 (UTC)
X-FDA: 85455123978.29.F19C186
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id D3FAB180006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:28:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RoMd+8ZH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795170528;
	b=nto0ZWqtQIPz0tj8AtE6au7ZDeBXEzTIoRkp5GO6bzvtTaq2SCkL7zgq05BiWO43HxCYBj
	oA86NbCMcqdGzPqP7hS1nALub1XmbYmRQBN1MKq8liMzLU2C+jtAipWBhf5Qk6os7MrGp8
	wgEZSNxBQetgR5UBZG6Vd76OUlh55co=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795170528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ZQM0iSlIxsidYD3H8Z/IU2JU/hIKwWZ9ucju8JfOBg=;
	b=mYWGDh8Z6uRl4xur5pY9wQIdYCOGyhY6YVnVPCFhGeDGF+dyPp8vAwBxG7ObKawi7xlM0/
	bYtPRpxhRo00Td69K4iNP/fJ2nc/jZgbGwr15OGAy2wMNUsAS9Ggc7b3EsX2ojBV2gZRs8
	q9atMo8mXEUggBGxiQBUbcmYgSIg8LQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RoMd+8ZH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B156465AD;
	Fri, 20 Nov 2026 10:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198451F01573;
	Fri, 20 Nov 2026 10:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795170526;
	bh=5ZQM0iSlIxsidYD3H8Z/IU2JU/hIKwWZ9ucju8JfOBg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RoMd+8ZH3/J/Xtvft7++A1c6QdngHDk1A86GwkjsTsJdZ72QsooE7SuHwkZd/nlVP
	 w3CEam6GOM7EchFEbRrYCeQYJyCubp72PjZTb4VSqFGb8EFhQ89Mbsh9kVEryaYxQ4
	 1C1C+cJxy2SdqVCm6GKFrjiKyyh5WyIz+ezBVp8zltzWdH/Kst/TGYNy+ftemVhzuJ
	 DAW3MrkaFsETjgz4Ul5dBjO1wGLWEkIogzDQyimd5bqlGsbweq1aZmzyc4kHGiuC/H
	 ylN+7cBNvcsX3AIL3T1Dm9p/AGFjqqirE+QX9RoEPhrTUY5JDgMmthf7Ipz8EKgCEy
	 7KqOdcCREReEw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Nov 2026 11:27:03 +0100
Subject: [PATCH 04/11] rust: page: use byte-wise atomic operations in raw
 accessors
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-page-shared-v1-4-66f8c4c62822@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=16831;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=+saz2pIcMWoUznANU/SqKeZHrhc55d/T5RtE2muYx0g=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBrACCFfQwjV/qfKjV2NhXVGHmqVZ2GI664G9/Rw
 ub6zMkGNEeJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCawAghQAKCRD6UCkIqsW9
 0GSAEAC298ZHO1Mn9Vl//CX8hI5wCHFQ9mTd+7e5FBHxKdyk/qD7x9Q4k1TwFDvCvIN0copAH4m
 9b7opdKu7j6I+q9kefxa3hClLfWDP8qVXZ64dz29IbCeFvplySaJYDO8GD+MBS3V5Cn8lJ1BCOR
 jCGvMMntkkxdDK/UvzVuHbl44RJ5zkZXbJ//xBxDp0+fxR5LByPNd0bQwi64S3f0MYI12UZy3j8
 1GULbN8Ue7uIe+aWnATrriON34iT/k1evDqNx0KlrAbusB+RbOTIeQjiiHx34jfTvPSRmH+2cm3
 yIpxeB+RRCSuFxrbgd464W569kOCNCXRiKHHhgc4GovcauTB8QvmCTZtUpiOlEqzXXoXONt9mde
 tuvdwB8lFK6gieFOx7aALxKKg0E3jK8QqzAVdYJXmvr05icl4eI7x2dyJHna4YPs6ThTuf7p2AO
 1rksirpoOKe/L+MfsQhMELQTk27sdtp984dmCnYhKbRIEpa1cDRh4ixKDoZvfNZRDunEKXZItCJ
 f5Bymhcz0AqQ0NJttOJQUhy1PO8I4k8TMATEehF5nejgdCpO2SNLyCotZlT/+YTJ4Fxna639JIb
 0rDTbc19thlO33zfwOS1TtuD5rahgK9a1QcE9Iq5J/FKaRqRgJ2GwXv5Q+AwYJTAiTLyZiDf5CF
 mqyy6D/bb6arxVQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User:
X-Rspamd-Queue-Id: D3FAB180006
X-Stat-Signature: w651sncts7d1u6bpwzadc6qc53j6ny77
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795170527-747486
X-HE-Meta: U2FsdGVkX1+CmjqP7f1ej9fpNbKjPwa3tRXA7LOcgcrhzypOqiGWuG1XfdDrl4NF+FTiGnZle2dMU38EWbl5thBf1KMtbsaejWwu8EsqSpy3vWFHl1lGmXaGDs+lfevKNWTQ6FyGAzQgBKX2Npguk8U3uxNKjD43q39FENcHZh794rH8d4pyUjZIk0/EHkSV+saup2LJiaRMun6IUOOFoUrFC2/RQShrFIZXzR7/2zUi4KmCJ2QNFkXCl/lStYCjHiErTH0KjcLUOihPzjSeqZXzHLcBy+ZkLq03ik7HpIiAXmurYIoZjWV2lF8hOgoB0KwQ/wRPa8pTieZSN/aUifyk7TLlVdY/C/M5byGXrRjobX4qvVSEtCuVIw0E5X+1gjiGUdS3XuWMH4ABgQf2Pf5Dhin1ncDd/FJg29lCvkEbPPxdc4pwKwpn0xEntP5qDxeWH6t8qpuHDMdzBqBEwMz1NkX9V4lZ6+vYy8Xv8tCMe6F+WUihfq3uaxd/jPNfToXLuY1B1nZOyA2WBNoDv2hOxPcbta8nuSQHRbk77BOvXwpasWI23dMw8PSfQgIccptJWS3nQkuxQaCRGkdJNSFd84SiUioINqRo3azul/NYIAXXey6OpKr9SYpfUtErI2lDWbsbhymqob0MUCN1/1CMarrU1gCTm/ClYbRfFr5++5j1mDTCDzaeHzDw83kSB6/USV7HsildouaMsmYhViOfRL7v4rGtiGWNETL+HeLKdc23UHh4QkkTC0q2tPVUtLwvjlt87toDUvUKT8/C7/pHhBb79pvT47JooC5JZSMVgmByEK872g/DY7sgmJp351ZRcmbOW1uO70aWXOM5h8UPQRzigX39a17SQcBrCVytZMsIKFDdETdbFJyN52ifVyXoSksf0umzUYCfVQl6Un+622wDegzMCrYE1bVOBWpeutjIly82Ux1AgYfDI4eUjcen6GWfEGA3MOdON/M
 CiTRljqH
 vu4kuIesSQEoLTiBL5JExRwmedTcEIvmvbXt6AyDeVhTs3hv4JEZiMHnK8WmO9Enq8cdfQZu3MifRwq+KnnqFc3QWDFzdzpwalAOEBKDBPsQx0ubBsRMPUDqytx3n3zatSZm2pOBBA4wbf9PmrZ/nRGtz9LAsxbsEN4ON1EAl8UZ6eBT26H2gLT7Son2uqm7cH9g4FC7Gcokomvwh+vYOqDvDH0U7DLz7Tfh4YKWMW0JcofH7uQaAT2N/KcuTVWoIW94yoR2QfdW1Xb2VFLQh2Q9bZPrblpOR9sER/18OZAR1/67jPUIRmlotTTR3oxycOzbbhpGi6BNaH1VA5hMqPBRekzHWdq6pg58TkG3Msqvgky4Qt/v7LUantv+ZFfdVcTtYSI5fq8aNuvgd5nf3kPihNKQ858cZ2MHAbSBDBT2jgemLzEMQp+DxHk36HlSS1wLRic9n6e6osKdAz/Xc9tJjR6oYdC4ylQcU87ziiTSPEF/k98cBScLQdDLVFERDzyKOnSFjaFfwqMx44UPJAalGhxluUIwMzM+1SAJfwes9fMBeRgP/7Elg5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The raw accessors of `Page` are used to access pages that may be mapped to
user space or shared with devices. A plain access to such a page is a data
race when the other party writes to the page.

Add the private method `Page::with_page_as_sysmem()`, which maps a range
of a page and passes it to a closure as a `SysMem` view. Access the data
of the page through this view in `Page::read_raw()`, `Page::write_raw()`
and `Page::fill_zero_raw()`, so that all accesses are byte-wise atomic.
Zero the data with `SysMem::fill_zero()`.

Narrow the safety requirements of these methods, and of
`Page::read_sysmem()` and `Page::write_sysmem()`, accordingly: a call must
not race with a plain access to the same data, but it is allowed to race
with other non-plain accesses.

`Page::copy_from_user_slice_raw()` still writes to the page with plain
accesses. State that in the safety requirements.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/page.rs | 153 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 107 insertions(+), 46 deletions(-)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index 3c48ecde4d14..ff191bfcd3f9 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -334,28 +334,74 @@ fn with_pointer_into_page<T>(
         }
     }
 
+    /// Runs a piece of code with a range of this page mapped as a [`SysMem`] view.
+    ///
+    /// If `f` is called, then it is called with a view of the `len` bytes of the page that start
+    /// at `offset`. Accesses through the view are volatile or byte-wise atomic, so the view is
+    /// suitable for a page whose data is subject to concurrent writes by hardware or user space.
+    /// The view is valid for the duration of the call to `f`.
+    ///
+    /// If `offset` and `len` refer to a region outside of this page, then this method returns
+    /// [`EINVAL`] and does not call `f`.
+    ///
+    /// # Safety
+    ///
+    /// * Callers must ensure that no plain access to the mapped range races with an access
+    ///   performed through the view, see [`SysMem`].
+    /// * Callers must ensure that no mutable reference to the data of the page that overlaps with
+    ///   the mapped range exists during this call. If `f` writes through the view, no reference to
+    ///   that data may exist during this call. Such references can be obtained from a
+    ///   [`Page<Exclusive>`], see [`Page::as_slice`].
+    /// * If the page is a [`Page<Exclusive>`], `f` must only write initialized bytes through the
+    ///   view.
+    /// * Callers must ensure that the view is only used on the current task, as this method may
+    ///   use a local mapping.
+    unsafe fn with_page_as_sysmem<T>(
+        &self,
+        offset: usize,
+        len: usize,
+        f: impl FnOnce(SysMem<'_, [u8]>) -> Result<T>,
+    ) -> Result<T> {
+        self.with_pointer_into_page(offset, len, move |ptr| {
+            // SAFETY:
+            // - If `with_pointer_into_page` calls into this closure, then it has performed a
+            //   bounds check and guarantees that `ptr` is valid for `len` bytes for the duration
+            //   of the closure. A byte slice has an alignment of 1.
+            // - By the safety requirements of this function, no plain access to the range races
+            //   with an access through the view.
+            f(unsafe { SysMem::new(ptr::slice_from_raw_parts_mut(ptr, len)) })
+        })
+    }
+
     /// Maps the page and reads from it into the given buffer.
     ///
     /// This method will perform bounds checks on the page offset. If `offset .. offset+len` goes
     /// outside of the page, then this call returns [`EINVAL`].
     ///
+    /// The copy is byte-wise atomic, so it is well-defined even if the data of the page is
+    /// concurrently written by hardware, by user space, or by other kernel code using atomic or
+    /// volatile accesses. In that case, the data that is read may be arbitrary.
+    ///
     /// # Safety
     ///
-    /// * Callers must ensure that `dst` is valid for writing `len` bytes.
-    /// * Callers must ensure that this call does not race with a write to the same page that
-    ///   overlaps with this read.
+    /// * Callers must ensure that `dst` is valid for writing `len` bytes, and that this memory
+    ///   does not overlap with the data of the page.
+    /// * Callers must ensure that this call does not race with a plain write to the same page that
+    ///   overlaps with this read, see [`SysMem`].
     /// * Callers must ensure that no mutable reference to the data of the page that overlaps with
     ///   this read exists during this call.
     pub unsafe fn read_raw(&self, dst: *mut u8, offset: usize, len: usize) -> Result {
-        self.with_pointer_into_page(offset, len, move |src| {
-            // SAFETY: If `with_pointer_into_page` calls into this closure, then
-            // it has performed a bounds check and guarantees that `src` is
-            // valid for `len` bytes.
-            //
-            // There caller guarantees that there is no data race.
-            unsafe { ptr::copy_nonoverlapping(src, dst, len) };
+        let copy = |src: SysMem<'_, [u8]>| {
+            // SAFETY: By the safety requirements of this function, `dst` is valid for writing
+            // `len` bytes, which is equal to `src.size()`, and it does not overlap with `src`.
+            unsafe { SysMemBackend::copy_from_io(src, dst) };
             Ok(())
-        })
+        };
+
+        // SAFETY: By the safety requirements of this function, no plain write races with the read
+        // through the view, and no mutable reference to the data that is read exists. `copy` does
+        // not write through the view, and it only uses the view on the current task.
+        unsafe { self.with_page_as_sysmem(offset, len, copy) }
     }
 
     /// Maps the page and reads from it into the given system memory region using byte-wise atomic
@@ -366,14 +412,14 @@ pub unsafe fn read_raw(&self, dst: *mut u8, offset: usize, len: usize) -> Result
     ///
     /// The writes to `dst` are byte-wise atomic, so they are well-defined even if `dst` is
     /// concurrently accessed by hardware, by user space, or by other kernel code using atomic or
-    /// volatile accesses. The reads from the page are plain accesses, so the page must not be
-    /// written to concurrently.
+    /// volatile accesses. The reads from the page are byte-wise atomic as well.
     ///
     /// # Safety
     ///
     /// Callers must ensure that:
     ///
-    /// - This call does not race with a write to the source page that overlaps with this read.
+    /// - This call does not race with a plain write to the source page that overlaps with this
+    ///   read, see [`SysMem`].
     /// - No mutable reference to the data of the page that overlaps with this read exists during
     ///   this call.
     /// - The memory region of `dst` does not overlap with the memory of the page.
@@ -393,8 +439,8 @@ pub unsafe fn read_raw(&self, dst: *mut u8, offset: usize, len: usize) -> Result
     /// // way while `dst` is alive.
     /// let dst = unsafe { SysMem::new(&raw mut buf as *mut [u8]) };
     ///
-    /// // SAFETY: `page` is not written to during this call, no reference to the data of `page`
-    /// // exists, and `buf` is not part of the page.
+    /// // SAFETY: No plain write to `page` happens during this call, no reference to the data of
+    /// // `page` exists, and `buf` is not part of the page.
     /// unsafe { page.read_sysmem(dst, 0)? };
     /// assert_eq!(buf, [0u8; 16]);
     /// # Ok::<(), Error>(())
@@ -405,8 +451,8 @@ pub unsafe fn read_sysmem(&self, dst: SysMem<'_, [u8]>, offset: usize) -> Result
             // - If `with_pointer_into_page` calls into this closure, then it has performed a
             //   bounds check and guarantees that `src` is valid for `dst.len()` bytes, which is
             //   equal to `dst.size()`.
-            // - By the safety requirements of this function, the page is not written to during
-            //   this call, so `src` is valid for volatile reads.
+            // - By the safety requirements of this function, no plain write to the page races
+            //   with this call, so `src` is valid for volatile reads.
             // - By the safety requirements of this function, `src` does not overlap with `dst`.
             unsafe { SysMemBackend::copy_to_io(dst, src) };
             Ok(())
@@ -418,25 +464,34 @@ pub unsafe fn read_sysmem(&self, dst: SysMem<'_, [u8]>, offset: usize) -> Result
     /// This method will perform bounds checks on the page offset. If `offset .. offset+len` goes
     /// outside of the page, then this call returns [`EINVAL`].
     ///
+    /// The copy is byte-wise atomic, so it is well-defined even if the data of the page is
+    /// concurrently accessed by hardware, by user space, or by other kernel code using atomic or
+    /// volatile accesses.
+    ///
     /// # Safety
     ///
-    /// * Callers must ensure that `src` is valid for reading `len` bytes.
-    /// * Callers must ensure that this call does not race with a read or write to the same page
-    ///   that overlaps with this write.
+    /// * Callers must ensure that `src` is valid for reading `len` bytes, and that this memory
+    ///   does not overlap with the data of the page.
+    /// * Callers must ensure that this call does not race with a plain read or write to the same
+    ///   page that overlaps with this write, see [`SysMem`].
     /// * Callers must ensure that no reference to the data of the page that overlaps with this
     ///   write exists during this call. Such references can be obtained from a
     ///   [`Page<Exclusive>`], see [`Page::as_slice`].
     /// * If the page is a [`Page<Exclusive>`], callers must ensure that the `len` bytes at `src`
     ///   are initialized.
     pub unsafe fn write_raw(&self, src: *const u8, offset: usize, len: usize) -> Result {
-        self.with_pointer_into_page(offset, len, move |dst| {
-            // SAFETY: If `with_pointer_into_page` calls into this closure, then it has performed a
-            // bounds check and guarantees that `dst` is valid for `len` bytes.
-            //
-            // There caller guarantees that there is no data race.
-            unsafe { ptr::copy_nonoverlapping(src, dst, len) };
+        let copy = |dst: SysMem<'_, [u8]>| {
+            // SAFETY: By the safety requirements of this function, `src` is valid for reading
+            // `len` bytes, which is equal to `dst.size()`, and it does not overlap with `dst`.
+            unsafe { SysMemBackend::copy_to_io(dst, src) };
             Ok(())
-        })
+        };
+
+        // SAFETY: By the safety requirements of this function, no plain access races with the
+        // write through the view, no reference to the data that is written exists, and the bytes
+        // written are initialized if the page requires it. `copy` only uses the view on the
+        // current task.
+        unsafe { self.with_page_as_sysmem(offset, len, copy) }
     }
 
     /// Maps the page and writes into it from the given system memory region using byte-wise atomic
@@ -447,15 +502,14 @@ pub unsafe fn write_raw(&self, src: *const u8, offset: usize, len: usize) -> Res
     ///
     /// The reads from `src` are byte-wise atomic, so they are well-defined even if `src` is
     /// concurrently accessed by hardware, by user space, or by other kernel code using atomic or
-    /// volatile accesses. The writes to the page are plain accesses, so the page must not be read
-    /// from or written to concurrently.
+    /// volatile accesses. The writes to the page are byte-wise atomic as well.
     ///
     /// # Safety
     ///
     /// Callers must ensure that:
     ///
-    /// - This call does not race with a read or write to the destination page that overlaps with
-    ///   this write.
+    /// - This call does not race with a plain read or write to the destination page that overlaps
+    ///   with this write, see [`SysMem`].
     /// - No reference to the data of the page that overlaps with this write exists during this
     ///   call. Such references can be obtained from a [`Page<Exclusive>`], see
     ///   [`Page::as_slice`].
@@ -483,8 +537,9 @@ pub unsafe fn write_raw(&self, src: *const u8, offset: usize, len: usize) -> Res
     ///     )
     /// };
     ///
-    /// // SAFETY: `page` is not accessed in any other way during these calls, no reference to the
-    /// // data of `page` exists, and neither `data` nor `buf` is part of the page.
+    /// // SAFETY: No plain access to `page` happens during these calls, no reference to the data
+    /// // of `page` exists, `data` is initialized, and neither `data` nor `buf` is part of the
+    /// // page.
     /// unsafe {
     ///     page.write_sysmem(src, 0)?;
     ///     page.read_sysmem(dst, 0)?;
@@ -498,8 +553,8 @@ pub unsafe fn write_sysmem(&self, src: SysMem<'_, [u8]>, offset: usize) -> Resul
             // - If `with_pointer_into_page` calls into this closure, then it has performed a
             //   bounds check and guarantees that `dst` is valid for `src.len()` bytes, which is
             //   equal to `src.size()`.
-            // - By the safety requirements of this function, the page is not read from or written
-            //   to during this call, so `dst` is valid for volatile writes.
+            // - By the safety requirements of this function, no plain access to the page races
+            //   with this call, so `dst` is valid for volatile writes.
             // - By the safety requirements of this function, `dst` does not overlap with `src`.
             unsafe { SysMemBackend::copy_from_io(src, dst) };
             Ok(())
@@ -511,22 +566,27 @@ pub unsafe fn write_sysmem(&self, src: SysMem<'_, [u8]>, offset: usize) -> Resul
     /// This method will perform bounds checks on the page offset. If `offset .. offset+len` goes
     /// outside of the page, then this call returns [`EINVAL`].
     ///
+    /// The writes are byte-wise atomic, so they are well-defined even if the data of the page is
+    /// concurrently accessed by hardware, by user space, or by other kernel code using atomic or
+    /// volatile accesses.
+    ///
     /// # Safety
     ///
-    /// * Callers must ensure that this call does not race with a read or write to the same page
-    ///   that overlaps with this write.
+    /// * Callers must ensure that this call does not race with a plain read or write to the same
+    ///   page that overlaps with this write, see [`SysMem`].
     /// * Callers must ensure that no reference to the data of the page that overlaps with this
     ///   write exists during this call. Such references can be obtained from a
     ///   [`Page<Exclusive>`], see [`Page::as_slice`].
     pub unsafe fn fill_zero_raw(&self, offset: usize, len: usize) -> Result {
-        self.with_pointer_into_page(offset, len, move |dst| {
-            // SAFETY: If `with_pointer_into_page` calls into this closure, then it has performed a
-            // bounds check and guarantees that `dst` is valid for `len` bytes.
-            //
-            // There caller guarantees that there is no data race.
-            unsafe { ptr::write_bytes(dst, 0u8, len) };
+        let fill = |dst: SysMem<'_, [u8]>| {
+            dst.fill_zero();
             Ok(())
-        })
+        };
+
+        // SAFETY: By the safety requirements of this function, no plain access races with the
+        // write through the view, and no reference to the data that is written exists. The bytes
+        // written are initialized. `fill` only uses the view on the current task.
+        unsafe { self.with_page_as_sysmem(offset, len, fill) }
     }
 
     /// Copies data from userspace into this page.
@@ -540,7 +600,8 @@ pub unsafe fn fill_zero_raw(&self, offset: usize, len: usize) -> Result {
     /// # Safety
     ///
     /// * Callers must ensure that this call does not race with a read or write to the same page
-    ///   that overlaps with this write.
+    ///   that overlaps with this write. This includes byte-wise atomic accesses, as this method
+    ///   writes to the page with plain accesses.
     /// * Callers must ensure that no reference to the data of the page that overlaps with this
     ///   write exists during this call. Such references can be obtained from a
     ///   [`Page<Exclusive>`], see [`Page::as_slice`].

-- 
2.54.0




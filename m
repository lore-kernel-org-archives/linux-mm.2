Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10616606A880
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 13:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GJ29nQ6W
Received: by kanga.kvack.org (Postfix)
	id 1A19F6B06BC; Fri, 13 Nov 2026 08:15:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 178B96B06C4; Fri, 13 Nov 2026 08:15:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 041326B06CB; Fri, 13 Nov 2026 08:15:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C8D936B06BC
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:15:43 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AD5831C06CD
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:15:41 +0000 (UTC)
X-FDA: 85430142882.29.B373D47
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id C1187140014
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:15:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GJ29nQ6W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794575739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yvhlxOGFoi+F89HZb81WEWWCtAriKN/yesL9fE1W0bc=;
	b=N0/COf1SIsc7SIFGr5/cL6SQRAwiUzBOZt1T86xNjux0KiRgLMNsFATcIJzGQxA2BZrbw/
	2OD3Qplu4ZLzcOYLvnEQN8cmewgYyVji+KS79bLz7gsGiai88S/zRvvy3OMpv1qdaQhYt7
	y9rT+sw1Z80dOJBQYtvBq5l0HDdpRLs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GJ29nQ6W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794575739;
	b=NJESQV1emPRSF+Hjfd1d+7eP3AxBcL6FmQY+OIzRcIf2fj0JQ5NS7Qt6hpTaQSyhfnD7w7
	6bH9hQc47MpCxlOOi7WObqal9X5wA+xXXQ9iHThVs9tmIp0mN18ktRKoZwqPmvZytLULQy
	eRtRKFTeU3crFUigcH8Bocz59Iqjze0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 176B4448BB;
	Fri, 13 Nov 2026 13:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7B11F000C4;
	Fri, 13 Nov 2026 13:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794575739;
	bh=yvhlxOGFoi+F89HZb81WEWWCtAriKN/yesL9fE1W0bc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GJ29nQ6WIGvF8JVYs2JZMcTsWEkzImBzzGDFzX8r0fDxClOuANRbRSPcpsJ99LUjo
	 UXzWh61HO+AoMseZGTUTag/cgVVqxw/kGh+g3Nv0nGedjCIgCBFB1f6m4zO/S40x0g
	 Ckg72tcAKRCalaWOcq6C7K/iQ/jX4FJnWe7rG8OUCKVVh9l4ACdiX/i35YYIHDbL7V
	 iD7q8lZsOnah1LvHLWuZcTJJGXaBUQhrpWqu830Vl4OFpqRkJec4/l1fqdjJKiVgOF
	 m+9EXEcjx0Sboo3hWL34Is64MFZjMuHKaYnaCGuew195N2wJqP8pmDYqsjidUSx8S3
	 fxCcWZbFpwEAQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 13 Nov 2026 14:15:11 +0100
Subject: [PATCH v6 4/4] rust: page: add byte-wise atomic copy methods for
 `SysMem`
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-page-volatile-io-v6-4-5603e527c919@kernel.org>
References: <20261113-page-volatile-io-v6-0-5603e527c919@kernel.org>
In-Reply-To: <20261113-page-volatile-io-v6-0-5603e527c919@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Lyude Paul <lyude@redhat.com>, Abdiel Janulgue <abdiel.janulgue@gmail.com>, 
 Robin Murphy <robin.murphy@arm.com>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
 dri-devel@lists.freedesktop.org, Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7076; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=KOumkcBKKQnKcYp/427flD2XnfNuZuXlo0hy9wCqDLs=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBq9w1ixJUlB47IAs5cIvFmX7PsOHf0fQsjlvpao
 08Z8uXo/1eJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCavcNYgAKCRD6UCkIqsW9
 0KsxD/0UwZ+rTNEFCanJl5VjcEZ5cUWxEBI/aCZZuuadlZDob7YoQq4L5tqhvyKdRHCclshmn1I
 +ADU3PoBbQvkLS5OyCMiznxR9+FrxF5/ruOao1+HkU7WPXVBFEZ8BTJta6jHFHWdnfxfZMIbtUw
 jOQkbSXZ6g5GT7W+LOcozBKBcg5Gc6cWii49/1hNUdJIqZD9o+9OFqa4F/DUQo3gpSLB//yF6m5
 rB7+UGO6EpeEoxj/S8296z2u8Zo8LWuHDuQgEcU3IGcSAk888mXgA20/CTTTK3Pv44sRy4q11oY
 PFAbrvxo9JDMvzSozJrIb0NF4qOgwN403X6DR7z0F7Dnu30huERQuQ79DEkRyX+oWmHB90FYfRc
 PiXB3jBeL0SaoNcjzbtDm5DLGrUSwXQJ37V9xvlaB6/I+p/A/9B/+/BoH2KdrmqV+3/KnaP2VJQ
 8oy+JpB8VuGmHVWaebupbTxt4tVQbLCQks2W5zUp3dy0no5EH5yYWxSH0b/luHqQwLKzB0obA0s
 EKoit2r43/A3ovHRDqyPJKLV3NcNS4pDdKL85HfH2IixMNYiIm6Quv1iT9shzPqHSyvGQKlKoqF
 NZP6KHs4vN62kmbizXw9u8KvtFEuBUAiGEx9J2Ho47KeM9hb1rqBId96dYpTVgl4cDgIds9fWXU
 nFN9KL8VSCw5IVA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C1187140014
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: csp555ccfetsuc7bgtm1pjn7thomzi5n
X-HE-Tag: 1794575739-392494
X-HE-Meta: U2FsdGVkX19qmNOjPeg3PurVkC8/rDUo9ukT9MLDDK9e0aSlwkb+FNw3nzMtmwSEf8Hx8vCw3ZAaauSk64lNeo27x/YGKWV5+P93QfRj0Swz3/BlLVI1/UqcvxkbKu0Yef12xkcDFv+3+e3nP3xRgX3LBRTwCClU4GAWBkzkI/kX7qrAYDRN+xwVYEnSyBhurvTSNY4ivWkQqQceLnBBQLFBJu0DWfTMYKPDEceTNXv1OuIydEz14oNv88EU6xFPkqRgGNeJIwrLQUjEwfAyBt7SIaXU21y6PKK10M1+0TjpTmiiNosBS+vGVOw0y+Mw71xbjk87F92xZSOAbE7Iqhx3N6KBcJXOx3j4mZRPWPWonGiZZ1pwPqb2Hcu6u0gJBsMfVhRLw7BzHKvIDEAhv6/FoRlNk8bfnH2Aj5xgN7hCWoUt82il75rVdZ8Rfhnq8HflYmpOy+Wsq07gZQ6CDwzeDk7zaO9TyiRGSY/8afrNX/HFZNm5bZK7dvkHgK8+tKEOONl+DKLIOooYfiDemXyzarShMm2b0Fk3bQ+Vk0JDPB8XTkrtZqGkkgUlbAZThqfn/njojmRABbD5fg26PKmM6qX0feUEpSNPY5Mi1CNK/evRNQ5lFcexKYUWWObluQWvslRDu6EMmc3xIdgW1cmzTiJvd2PYQETNuIEsdxFSsA5gQKrsfCPdp49p4WPmZ8vIHB8z12DTc15EqVjYYVeSk5PP6FSKYQOm+XGPMBB0e0DiPSSbxsDXa9N2IgaV4wxOMglB8TRtFU8VfoWZv2ZydTZb0nXZ9s2AxfBDVux5VqxFLMjh2jBYCBN+o2zSDsMtQtX2XVeAZWPuAtD2BduuXAimEd+c8Tla2b1oXD81C2JosHpmmADAnTNqQoQFDWmAcLpe4kmxl+oS0/VUaZ0voGi9qDH/T9USKEFUxnWYLq81DMSdDfVKmrn2DXn1CnTFlv7iU8UifOz4fgI
 cs5VoTxZ
 ZMVtUrubxr6TwS/TM+KNdI0SefnnT/houZp7N5GVtlp6T2E1GV6bHlPETrsD3nwjVz5eTPEjs+uMZcxVckG/IgrHDX0Gu+TyZIFPfBQEErmzUUqHsL6goAi3o9CtwO1KGCuSjgz625DD8mbh8S3mESYXORMs2EIy8OSJQ9oDKdIs7f3JGD8egFvAuieYxJ6wHD4EkHhOWpKrBlzzW59AEjOGNEn3f/tJ5e+RHZol09DG1xUI3Dp3NabGqCHo+eb/RpjxeDCCTfLgRiM6pheP370gc7pXnCLAQ+u4ilxCewlsOK6XYTNqWeBr4mRq9PoY+V+I3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When copying data between a `Page` and a buffer that is mapped to user
space, or otherwise shared outside the kernel, it is impossible to
guarantee absence of concurrent memory operations on that buffer. Copying
with `Page::{read,write}_raw` would be a data race in that case.

Add `Page::{read,write}_sysmem`, which take a `SysMem` view of the shared
buffer. The accesses to the buffer go through `SysMemBackend`, which uses
byte-wise atomic operations, so they are well-defined when racing with
external actors or with atomic accesses from other kernel code. The page
side of the copy uses plain accesses, so the page itself must not be
accessed concurrently, as is the case for `Page::{read,write}_raw`.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/page.rs | 121 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 121 insertions(+)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index 1c0796ea229f..e96e95182406 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -12,6 +12,12 @@
         code::*,
         Result, //
     },
+    io::{
+        Io,
+        IoCopyable,
+        SysMem,
+        SysMemBackend, //
+    },
     uaccess::UserSliceReader, //
 };
 use core::{
@@ -305,6 +311,58 @@ pub unsafe fn read_raw(&self, dst: *mut u8, offset: usize, len: usize) -> Result
         })
     }
 
+    /// Maps the page and reads from it into the given system memory region using byte-wise atomic
+    /// memory operations.
+    ///
+    /// This method will perform bounds checks on the page offset. If `offset .. offset+dst.len()`
+    /// goes outside of the page, then this call returns [`EINVAL`].
+    ///
+    /// The writes to `dst` are byte-wise atomic, so they are well-defined even if `dst` is
+    /// concurrently accessed by hardware, by user space, or by other kernel code using atomic or
+    /// volatile accesses. The reads from the page are plain accesses, so the page must not be
+    /// written to concurrently.
+    ///
+    /// # Safety
+    ///
+    /// Callers must ensure that:
+    ///
+    /// - This call does not race with a write to the source page that overlaps with this read.
+    /// - The memory region of `dst` does not overlap with the memory of the page.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// use kernel::{
+    ///     io::SysMem,
+    ///     page::Page,
+    /// };
+    ///
+    /// let page = Page::alloc_page(GFP_KERNEL | __GFP_ZERO)?;
+    /// let mut buf = [0xffu8; 16];
+    ///
+    /// // SAFETY: `buf` is a local array that outlives `dst`, and it is not accessed in any other
+    /// // way while `dst` is alive.
+    /// let dst = unsafe { SysMem::new(&raw mut buf as *mut [u8]) };
+    ///
+    /// // SAFETY: `page` is not written to during this call, and `buf` is not part of the page.
+    /// unsafe { page.read_sysmem(dst, 0)? };
+    /// assert_eq!(buf, [0u8; 16]);
+    /// # Ok::<(), Error>(())
+    /// ```
+    pub unsafe fn read_sysmem(&self, dst: SysMem<'_, [u8]>, offset: usize) -> Result {
+        self.with_pointer_into_page(offset, dst.len(), move |src| {
+            // SAFETY:
+            // - If `with_pointer_into_page` calls into this closure, then it has performed a
+            //   bounds check and guarantees that `src` is valid for `dst.len()` bytes, which is
+            //   equal to `dst.size()`.
+            // - By the safety requirements of this function, the page is not written to during
+            //   this call, so `src` is valid for volatile reads.
+            // - By the safety requirements of this function, `src` does not overlap with `dst`.
+            unsafe { SysMemBackend::copy_to_io(dst, src) };
+            Ok(())
+        })
+    }
+
     /// Maps the page and writes into it from the given buffer.
     ///
     /// This method will perform bounds checks on the page offset. If `offset .. offset+len` goes
@@ -326,6 +384,69 @@ pub unsafe fn write_raw(&self, src: *const u8, offset: usize, len: usize) -> Res
         })
     }
 
+    /// Maps the page and writes into it from the given system memory region using byte-wise atomic
+    /// memory operations.
+    ///
+    /// This method will perform bounds checks on the page offset. If `offset .. offset+src.len()`
+    /// goes outside of the page, then this call returns [`EINVAL`].
+    ///
+    /// The reads from `src` are byte-wise atomic, so they are well-defined even if `src` is
+    /// concurrently accessed by hardware, by user space, or by other kernel code using atomic or
+    /// volatile accesses. The writes to the page are plain accesses, so the page must not be read
+    /// from or written to concurrently.
+    ///
+    /// # Safety
+    ///
+    /// Callers must ensure that:
+    ///
+    /// - This call does not race with a read or write to the destination page that overlaps with
+    ///   this write.
+    /// - The memory region of `src` does not overlap with the memory of the page.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// use kernel::{
+    ///     io::SysMem,
+    ///     page::Page,
+    /// };
+    ///
+    /// let page = Page::alloc_page(GFP_KERNEL)?;
+    /// let mut data = [0xabu8; 16];
+    /// let mut buf = [0u8; 16];
+    ///
+    /// // SAFETY: `data` and `buf` are local arrays that outlive the views, and they are not
+    /// // accessed in any other way while the views are alive.
+    /// let (src, dst) = unsafe {
+    ///     (
+    ///         SysMem::new(&raw mut data as *mut [u8]),
+    ///         SysMem::new(&raw mut buf as *mut [u8]),
+    ///     )
+    /// };
+    ///
+    /// // SAFETY: `page` is not accessed in any other way during these calls, and neither `data`
+    /// // nor `buf` is part of the page.
+    /// unsafe {
+    ///     page.write_sysmem(src, 0)?;
+    ///     page.read_sysmem(dst, 0)?;
+    /// }
+    /// assert_eq!(buf, data);
+    /// # Ok::<(), Error>(())
+    /// ```
+    pub unsafe fn write_sysmem(&self, src: SysMem<'_, [u8]>, offset: usize) -> Result {
+        self.with_pointer_into_page(offset, src.len(), move |dst| {
+            // SAFETY:
+            // - If `with_pointer_into_page` calls into this closure, then it has performed a
+            //   bounds check and guarantees that `dst` is valid for `src.len()` bytes, which is
+            //   equal to `src.size()`.
+            // - By the safety requirements of this function, the page is not read from or written
+            //   to during this call, so `dst` is valid for volatile writes.
+            // - By the safety requirements of this function, `dst` does not overlap with `src`.
+            unsafe { SysMemBackend::copy_from_io(src, dst) };
+            Ok(())
+        })
+    }
+
     /// Maps the page and zeroes the given slice.
     ///
     /// This method will perform bounds checks on the page offset. If `offset .. offset+len` goes

-- 
2.54.0




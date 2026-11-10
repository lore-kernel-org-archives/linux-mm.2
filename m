Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C1EE606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gMq0XiiY
Received: by kanga.kvack.org (Postfix)
	id 51FC86B00EF; Tue, 10 Nov 2026 09:45:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F6CA6B05B0; Tue, 10 Nov 2026 09:45:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40D676B05B4; Tue, 10 Nov 2026 09:45:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 17D616B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:45:35 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 81301140903
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:45:34 +0000 (UTC)
X-FDA: 85419482988.03.7C8069B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id B94BDA0009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:45:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gMq0XiiY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794321932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nxsf4aqPpWbByTWy4qgF4wCWfY6HdQuZno5SuvcTfA4=;
	b=rFYnaDC1BhFbrcAu259D+VVVQp7pIkALyYub2TxmiuCrRVBpCkFe486Hw/IOvzNklziDzB
	YCx8QXEOTASMfSrc8GFqwkBRBGHjj1mKc3Y1vil8OdbmbLtgS2teY8NbFmgpW0nZDLq/DM
	jGemhkr0+5lMYfRJIklgcWteE4yIPpw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794321932;
	b=VrJvy5b3/4Z8rTLCtRHaL/lQvXO7q5vo7HVzp5kVqNECz1hXttiO6xSjYv+vKqTwMUpnQ+
	hfNJyX5zq5LpWJneUBUOXf5stwdJ4ThyhuBnn5xGdzt4Wz0aeVA1ebCYWLH3jiYjj+snCI
	qsJVSk2YgCCzP5/0J5ezBAIEQUxYRGQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gMq0XiiY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 90F89639D0;
	Tue, 10 Nov 2026 14:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A886D1F0089F;
	Tue, 10 Nov 2026 14:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794321931;
	bh=Nxsf4aqPpWbByTWy4qgF4wCWfY6HdQuZno5SuvcTfA4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gMq0XiiYjFsCGAfnWkgRhZOskIKpU2I9gUCk9jukF20AmtPKoEGlRgbUUPgizde06
	 oD2E3939NbrV1tjsIbmos++atRL1kj+O4dUDN6mIbrolTOIfBjS1XGmbLAb5A/Xy5B
	 u3gCJTZxcA5jLgMDCWWhuFAkWrkl1oAutbtBFzylE3KCHeKc6Rdqlfo3bckuvOKE11
	 g93sXoJzxZtBvRPlRHsmY/jO6+AoVWv7o7xdnHduN1zEvfIu3ALLuHvSGdbrd0KPV7
	 5yO0U6TxqWiUEISMWTLHc/+4Of6Rkkyonyy1GbOXbiDUgTWnz/HhlRARgPDMEwFDUO
	 DNr1G8aAoNFXQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 10 Nov 2026 15:44:22 +0100
Subject: [PATCH v5 4/4] rust: page: add byte-wise atomic copy methods for
 `SysMem`
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-page-volatile-io-v5-4-a91ef252c24b@kernel.org>
References: <20261110-page-volatile-io-v5-0-a91ef252c24b@kernel.org>
In-Reply-To: <20261110-page-volatile-io-v5-0-a91ef252c24b@kernel.org>
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
 Lyude Paul <lyude@redhat.com>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7130; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=0Yld6Xn1ZAuuVlcl8F4kf0vlZbzxXdxmJTVFWA2EiHY=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBq8y39HfY8eyoOIJboqBscbDsAohXqHM82iKpnX
 AT2dCkacSqJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCavMt/QAKCRD6UCkIqsW9
 0GXPEACS4z32suEL1KhuaK+bOQTuHnPxNwc7zKFUr2QC1tUwUt9Os76/aTEhR4E+HkbAK2/q6CK
 CWTYxmYdxxEL0yWgDnA72JBZopYvVfS9pMmePful3IHftfnuV3aueV7Uov6vraNfySJiaGRXTNe
 bWJePVAucXTMdvTrq2Htk//gRQuR/H9oRgp+nHh8ooeKlZgvnxzQOWMloDINhXURtvBRKC7vM+4
 svH10lFQLEKrc2wQn2dOw5nTJ1Hf8Jxr6UlvVB/7IGsyIvayUEUnVBGv6D0yIeIwTnpP0O+RK5B
 7E8jlK1OSJkxSt9etuBUbIsS4X+kP7EKMNMOt8o4J6WAKNxMEnc1MFdgYnjguCMYPLPC3blIiJ+
 RNZy7aqU8lB1GSLv36nLej6Yw1j5lYEeu8mjP5M84C6ydTODxo0S/qIWiE/YyRFdhxMCaK6lH5g
 C8yDHLsNoITMq+Sn4VNffVHMHaM57BENV2JJJMxBiqVphxK4kM7jOxegIUExXRjYhlPdDZQAntW
 FS8XHpbRH4M77BfnA9b8i0gsW8/lsb9nkkwI3E1624uPAVUkNdR7+cou0SXdIto5TD9eo8T1tcd
 XJRxG2A7YKoEYY6+ohS6jlhmrnG06fLlrKokMcufdvO180Xf9IZKY/4QkjKU1qQhkuSVmew7meY
 mJOSPyylnea/PEA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: 9zm4w66qz5ezt7x6dewt9bgodoiki9i3
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B94BDA0009
X-HE-Tag: 1794321932-154286
X-HE-Meta: U2FsdGVkX1+Vl36xC9UXyzOOR95MJ9ICfxwK4UP5ylEgja825JeYbcstSsMH25fe+tKUfc72zm/lxMIpMZt7HR1CybRpz+8aMm4/xguyiij3BQhpBGK1AKE/9SoTv4M+Rthdp06DancN4IKLrzV92erQ907PVEs0Jc0lvXmLEP3y4/MaM71fH+KXy6hws2aIGQxO2L+y5iNQvjxcXJK6W+V27cAkuz0S6R/FGu+ytyPVdbWuhcp1CF67J+jtRz29x9fUdlvWUmVCCnQelWNDHMiVwfX8M2A5O+WmGmb5y/xUstqWrbh6J0y3ElHhzQ4LG2qIow1Wlaq0QxG9Nbx80ov0wPIuwdonEqPajuI7JWB7EQMw5dyBmeAZQK81mIRUX5ack+XcKSp/bC0gC0aOCixZpXKogxEkDwiumkqc2Iu39I9ZbSvypse8+J+5uXg1Sz6Xy1yWnYJ+pPT1sHz7PGr6e/5wo54TXl/voQxvxkyQKsauYNFeT7a6c6eascsA/jK/3tCOzw8p2lXoOjztvyDKQDYEIjBmRg8ZDVMDODEMLb79bFObJuE66iUrYnWYttVJ7VvbuXS5fD/rwftoDSEbSOPytAJdkg3+Hx25VRoqL2rNUo/+Uzzfc38JAA3TYqYEkHbAGWmJ3pGz+0kqpFeWHvwnn9S91eut2A8jBwjUc6H6IN8PP5DbCDi629/iH/KMgMNUQwXOwnjUDj/MxWwJffBRTLj+NaCWRilNzV/c0x/X/PP5xevJn7pUL78k1kpXAUIvJ9IJTyHc9NWedrxnoT1EnKU3hwgSGHqmjGrNXAwnlcHu4Dnt8ylg9XSW0siZeyuGXaTJ21SNP8a0319u9QgDfyX/PK5fZPkoQ2QRChKHUYfAoD7cDN4DU2pXudcFvLmaYWu5H06UQN/89nu7z0Sk9ZlZ401aQokxvj1AVgdynJ7Duum3t+l6xPBVv1eNHVpWipHqqPxd+EJ
 c5Y5f9U/
 DcqOIcRvSSD89vf0j9IFZsVB2j+roFWVK3VjbO2cR5YLFmlmoiuRPeFELmdb3hG6h+V253DihqiyVcPkiYaIEvfXmmmakMY2D1pyUTb/9ASLW5kIt/nokZBXU45JNySzR6mgE8Zb8dVac8dmUTlikbto87/UpVWRA73vqcotTQuCW7iADNu0/uMVJqrm6YCqt8hA1XS+684NXketSglm9c4usuhO/DAo5W7Y+S2XpeDAWdlhQcT3URPoOcA==
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

Add `Page::{read,write}_bytewise_atomic`, which take a `SysMem` view of the
shared buffer. The accesses to the buffer go through `SysMemBackend`, which
uses byte-wise atomic operations, so they are well-defined when racing with
external actors or with atomic accesses from other kernel code. The page
side of the copy uses plain accesses, so the page itself must not be
accessed concurrently, as is the case for `Page::{read,write}_raw`.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/page.rs | 121 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 121 insertions(+)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index 1c0796ea229f..92486d312b0c 100644
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
+    /// unsafe { page.read_bytewise_atomic(dst, 0)? };
+    /// assert_eq!(buf, [0u8; 16]);
+    /// # Ok::<(), Error>(())
+    /// ```
+    pub unsafe fn read_bytewise_atomic(&self, dst: SysMem<'_, [u8]>, offset: usize) -> Result {
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
+    ///     page.write_bytewise_atomic(src, 0)?;
+    ///     page.read_bytewise_atomic(dst, 0)?;
+    /// }
+    /// assert_eq!(buf, data);
+    /// # Ok::<(), Error>(())
+    /// ```
+    pub unsafe fn write_bytewise_atomic(&self, src: SysMem<'_, [u8]>, offset: usize) -> Result {
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




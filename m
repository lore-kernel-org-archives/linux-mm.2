Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B58BD606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OTr+KOep
Received: by kanga.kvack.org (Postfix)
	id D21CA6B05B1; Fri, 20 Nov 2026 05:27:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C84D86B05B4; Fri, 20 Nov 2026 05:27:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFDE96B05B3; Fri, 20 Nov 2026 05:27:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A4B16B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:27:48 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 00AF880ED0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:27:47 +0000 (UTC)
X-FDA: 85455121416.30.3651A84
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 44914100008
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:27:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OTr+KOep;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795170466;
	b=eTla0v9g5dnozJ01IlJIh/R7Q1It8h8/G4IB1XvcJEdcc0xuVp7EX+vVGCfw0w4DdvM+M7
	hH828dRu3FUy7HfNhrLRHRENAYwhO4w7d1crkRjW4GDFDFuZ7QDWsmz77sQSdzEn8qVy6e
	bLvgpeoaXfJTdUazCEmisrEqjaI62hM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795170466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7KYA+Wpno+xuUNw/akK40o3lUtGmWfphuhg/Z0TTQEU=;
	b=VOAAO+TgUBZRAq5L9vomHOHd7ZRh5gjBffFOnner4obTbzEo7K4Epf2UXAnlgtrxGdw36P
	Orv1x74p1o1uNnJeGxCcZp9x+xNFlEUxoHKO8tQaX4l9FdEjiqNoMhsFVlE/tqEx/+UBGv
	8F6XEOX4zQVpjbdW926/QsouwOKf+3w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OTr+KOep;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D68C1612FE;
	Fri, 20 Nov 2026 10:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CE01F000C4;
	Fri, 20 Nov 2026 10:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795170465;
	bh=7KYA+Wpno+xuUNw/akK40o3lUtGmWfphuhg/Z0TTQEU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OTr+KOep8g60MLBAKQCrEshBEPchmuOMXSSzNiDfYDzaJXqu3HxRZAVq4UpYUvfrp
	 BNEWDZppGHEYx3KsdFTiuOAupbVB7yhzegpneLPjiZa8LebnXShTZjUv/RC0wiMJqe
	 HhUTKJTEVXitq5/jU5VbeXW+ATBPZRzmigXNw7XcGdqDaiMA/jTm1NzgzyYccgo2Bj
	 ugd37PTPuQbQ3xWv88POKnwSektKKfK7p3gayOFgEIrEG/ZEnFsUWfE15xgZq2bPc7
	 +V370vwF4XpjnyCan5Imfr7uq9vRzd9E3jvEXc715B4PouGmDhMLRXnusdTr2ikE2U
	 ahE5THF+NfdMw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Nov 2026 11:27:05 +0100
Subject: [PATCH 06/11] rust: uaccess: add `UserSliceReader::read_sysmem`
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-page-shared-v1-6-66f8c4c62822@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2452; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=b1mLSMDHWh0RGqI8T/vhs/+oAuod9tIIBQMnZx+FI0o=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBrACCHctLDXQh/2A0OKD/teF/RQ7jo9N+QogxBc
 wj1N5Sy+GaJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCawAghwAKCRD6UCkIqsW9
 0AraEACwrqzkBN6VbzQE/bna+s/lAmsmvCkw068qGULDg0rL0SrfI8L2dJEM+QIrkqGV/67c8dg
 CDwxid9i/mGZHPcHm/hmNj1CvWjjWD32/WrqKDUPjiowbbXVel2TsHoz25a/wdIG9hvmyy/wdc2
 BbYIu6Bs4rGNrKAYF7Ubbgjf4rCBvP/4XuRsNnOOypJbUqJ7mU2VxEAAcJX8RvYBWcxZUNSdXw/
 0rNMkMtWTXF8188m9RP3X2UaaWpEhtbNSpzqiw8pIyd7Nlwl3ZszRwTWCQjLvVWQFAAtNT67CeA
 PaDzqJrC/jKrzKGAVgG+C4WLNKRig5N8sh1MzTXCbdzQzc8srTu7CezF0z6tzwka2fpL6/12gd3
 OS30Uxmblw2V8904LwlB/rszDV5S95GsvDqpVQ/0hrDElGUcQ7FeChIJdSsOWbx8b1j4+tGTjvj
 moqZWHug+GJMHGDNvcLB8d5ve1/IJ7ooZdqvMC5B/MGHrr6m2qVb6WsfBs17pho6eOuxdHTiwMN
 1+kGeRqCqOcdfDJPeZOPf6iRJts9Ivyvz5oxOQaLPTxQaYwWDazQxvhvs6GPPzSAlsq+l7+ZnXe
 5rwQUWoV2sx5w1W/jHR2rOveusbcQ3GIfnLWgpfA3MRiU7azXz6sVY2mg0oICEK0qN3EfLXtOUT
 tZz6+S8H8oBIB8g==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 44914100008
X-Stat-Signature: oatxgosqnok4755zke7wti5uaibeyjio
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795170466-891873
X-HE-Meta: U2FsdGVkX1+xKk+vx/P6oztALyPLPUDhaDLjPWfD+Q6HRyTK8+dCjFka9GwDgE0gSw7yps+gLO5iySfjsCkWFm6FIWtWqJLK4336/DU+5UzOfKloDS4y2MELShwSx1dVykURMqgq90wnKAiucQgfgXp8x5Hv+zScR95gA4NQGCIdd6uUzYgR+/jcO+uZWk1Jwa68+DrKRrEsenfxVBn4gl5Dk8GdhRDmTmgLGFbEu8zUjdZFHGu3AQIQdXr36FJYNcwBnCcWGFO6Ra8s6UcmtXjC+PzWgnsyRHI+Ki79AesAHE+/UR6MyqHpFBYNoJ5QJVi/kEBP6FNtjO9n8oNKFDteaP8z7QdQM+6Q3iqXGJ9tRLxzIDJSwd6nDiBeZAo/z4m/3M2EgDay8+xGETMNbiK4kxUYpCCBGaQjFs1/dL+X7D0DIgYJKkeGCCDNqFOhR3ZAnjVWtypchLmwNJkpb0zrGzuds8vRP7vHCeqLvaibbOJ0UBRMehb/wvoDKKyj4O0/uX7hhcfcFX7L12pKZ4CEx/BA7HxrPoT7XmBNsKep2lpCVsl58cv2hDgEGKs7L+hTQ456TBufEPea1uBd0WYaHP8H93YS83ksFs5r/Qmky+CvgtjpzAjbgX8yz83MLvSf2TnuxpHqutS3KqHnI2HxNkwAZfwtV9h5jOycjzKhYV0PB/SVzC60eYBx4ttLt+RV6M1MfRlZEUEuQyVB5KRHBcM81VXWmYBfApfXznd+gq0eS5YD2TSfV4x5S9qWS7VLGYy1OwQOxGgzvwmPrO5uMlgDAzAIL9jmyvP9jQDNL5QfsHFGxkQgCG9nCD+hUdreFI9oBXUFkJ+vjzlmzXCRiuq8Y70BaHiTj7qv/39aRJLMXNCVn9V+DQa8tZJPdHjoTBIrFPLFxRwYRw5JqF45PjbEZeVsQtHCgJxbr4AsX/6cy60ZEgrZhqWBpsTXozFc7kfewWDjMnq0YwI
 STToHczR
 EwlN5TMEfJIHekoj/6baPal/9oGRm3WaQWDXWFKe96XZ3BQjHAb/WmY3i1FtVpsSngrVai/TBtwekiDpAqwBGO5E9sJOreXzQYfHr3wedAa0Bw5opn5kRTgxdIYrHBOfWV/DxyyHeqtqPfZ0v4WmZRNkRNEtuukOJQAGP/rDnV0SCvMsNfBfzzEu8mrV+uSxCyC5dT7uY8Fn6L721kx/ccbr1xEO01ySVdvl2mBmIdJdK+++OOGRo9C6YLuZFF4p4myUG3YXRUjBw5M1A6hR+DhA/ao1tYC6uknfs+JAY/2oQMuNAP4Cr2X18c+em3MoA+cKMCauvSFBaBsOwL0pi9/bPC6vA3u2+q1o08JW0pTefw6StYJ59FEKAFugdiVHWZ5Sbt1tegFXw+6xYwUccclwYIF7PPi4z1kCBVZbN390sCa4gIZ5A2P36xcaLTXHk6wamNCR0r5CPEYc/KZUF8EhJfmyEX6eOr1wdKB5GvDIm5XLkf4Hc1Jbo9WJo8qynUM5xfcfltKwVxVI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a safe method for copying data from user space to a system memory
region that is represented by a `SysMem` view. The copy is byte-wise
atomic, so the destination can be subject to concurrent accesses, such as
the data of a page that is mapped to user space.

The method builds on `UserSliceReader::read_raw()`.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/uaccess.rs | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/rust/kernel/uaccess.rs b/rust/kernel/uaccess.rs
index b1df79500b98..313479d80834 100644
--- a/rust/kernel/uaccess.rs
+++ b/rust/kernel/uaccess.rs
@@ -11,6 +11,7 @@
     error::Result,
     ffi::{c_char, c_void},
     fs::file,
+    io::SysMem,
     prelude::*,
     ptr::KnownSize,
     transmute::{AsBytes, FromBytes},
@@ -292,6 +293,37 @@ pub unsafe fn read_raw(&mut self, out: *mut u8, len: usize) -> Result {
         Ok(())
     }
 
+    /// Reads raw data from the user slice into the system memory region `out`.
+    ///
+    /// Reads `out.len()` bytes. The writes to `out` are byte-wise atomic, so they are well-defined
+    /// even if the memory of `out` is concurrently accessed by hardware, by user space, or by
+    /// other kernel code using atomic or volatile accesses.
+    ///
+    /// Fails with [`EFAULT`] if the read happens on a bad address, or if the read goes out of
+    /// bounds of this [`UserSliceReader`]. This call may modify the memory of `out` even if it
+    /// returns an error.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// use kernel::{
+    ///     io::SysMem,
+    ///     uaccess::UserSliceReader, //
+    /// };
+    ///
+    /// fn fill_from_user(reader: &mut UserSliceReader, mem: SysMem<'_, [u8]>) -> Result {
+    ///     reader.read_sysmem(mem)
+    /// }
+    /// ```
+    pub fn read_sysmem(&mut self, out: SysMem<'_, [u8]>) -> Result {
+        let out = out.as_ptr();
+
+        // SAFETY: By the type invariant of `SysMem`, the memory of `out` is valid for writing
+        // `out.len()` bytes, and no plain access races with this write, so it is valid for atomic
+        // writes.
+        unsafe { self.read_raw(out.cast(), out.len()) }
+    }
+
     /// Reads raw data from the user slice into a kernel buffer.
     ///
     /// Fails with [`EFAULT`] if the read happens on a bad address, or if the read goes out of

-- 
2.54.0




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16A0BE63F10
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 20:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 611446B00A2; Sun, 15 Feb 2026 15:04:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BB886B00A3; Sun, 15 Feb 2026 15:04:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AA9C6B00A4; Sun, 15 Feb 2026 15:04:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1E4AA6B00A2
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 15:04:05 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7DA1C1A0B08
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 20:04:04 +0000 (UTC)
X-FDA: 84447767208.14.11DF3F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 966FF100009
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 20:04:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cMXvGZMq;
	spf=pass (imf05.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771185842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Bqu9m05sjzlpyJUJnyd2aqBdGOztVwRqnsP+JxmcVs=;
	b=ZVZwxy/9W5v5lkMp+/HEicmyQizdgYcxIoDRgwgNZX7EFeihfEgEEv+1zqsOHvPRRutXmu
	XTuOQJeyauGSzklRgyfiaVgJGG0b+UoRD+WjSFtuv8gwRUhj03gA4CLSCGDxISQBWzn6/X
	Cs2W/qsvcXJnZfZPdnQvRNz4MtLN6oA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cMXvGZMq;
	spf=pass (imf05.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771185842; a=rsa-sha256;
	cv=none;
	b=OfY2iwoJFACXeGhUiHQVXtI7riszDAY/2FsXRKU8khpmfeCua+0QF2PQd0jZKrLHCkrFCR
	MY7+XgKf3JrKwzsYePBZnt9VsNYcG6EDv3vKPw45rTMvXc/k9u/TJ02HM7v9gWwb7Uoe2R
	EiUP5VOl01EfvrkbY4DXIp98SyNo42s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AC44743AD3;
	Sun, 15 Feb 2026 20:04:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADC8C4CEF7;
	Sun, 15 Feb 2026 20:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771185841;
	bh=keDSI8hUCY4PU4tsUid9Cm310OHD3rGoQ1qvgeBe3jw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=cMXvGZMqSbb3H1E1orqeKhIgGNemexD7tvGuuZGM6d+budX3QTZ/xHWrKHL+RicO1
	 O/GZwyAX+T2YeaoB6D/AUd6p01xZvXX9algQaaDiTxsjN2BaWVEuD1Odh38HjZoOVw
	 eZAsR+QTUxH7WTw6L+kfRg+LsCO+E0QBAqbt9Btu/ASWzi0iBHW5dHv2EVq1A1/FAh
	 iP3e5TG54b4MULbXWpEqjP8P9zUjLmSLXoFqvjwkhleD3sJ0h8xzC07Iz6okFdGfjw
	 oLPezNnaa2PQvDqRnMWNhuxtmzMtgAFnes/BBG/C6OwCmDjmxgNZKJGLeWfYIK9xPa
	 4O1FM220wvstg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Sun, 15 Feb 2026 21:03:31 +0100
Subject: [PATCH 2/2] rust: page: add method to copy data between safe pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260215-page-additions-v1-2-4827790a9bc4@kernel.org>
References: <20260215-page-additions-v1-0-4827790a9bc4@kernel.org>
In-Reply-To: <20260215-page-additions-v1-0-4827790a9bc4@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2629; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=keDSI8hUCY4PU4tsUid9Cm310OHD3rGoQ1qvgeBe3jw=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpkiaeYS+HXhpLqK9Z0/QglR/jmX30qpmQQfnyp
 vTsEPxB4tmJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZImngAKCRDhuBo+eShj
 d8HtD/9Gy/trD4chBL3hhYL8hoXvK2+y1y5jO15NehAmZ+QMXdKTXcrtBwBpZLK1Uu71LrEn6sw
 iE0/RqKrzqpqgeVNLOw0JXsOvsZf/opVCS/eTeQguZtLnjhLahQuLHn80309GLeznizxoINX36Z
 gjgKn6OAw5baj0c4zNNP7TR4SIxxDXv0xlOyThEhC7B7ZUPKuAe01KvcHd+nXWkZoWJB4V+GRuW
 fd1Kpia6RPKfas9rC0WNGPJowp3dFDVHkCoIOcVgmBt1YiH0wt3yAiQl96p8ffjbhQPjlU9GUCG
 R+NxYB7M5Flch05oZ30GPYKUQPTbHuW6QHcehx09ZGN1Nu+v7RDpdCEEXqly0jxNfKoAiZ1DQix
 zJxGXGgU758LgUj2UsJ7Nbx/bdkqMqvKidRs2FofEg1EotVC6jRHw/+cfr5DeDOzK0fwrN4SpVL
 BOR6Abn/ojSIktoitVLefg7AJjC/hxyrKlvgBm3gp+WPnFxznw1kgNLRnSr4RJHb9WES6TLcOiE
 Sl9JG5v/pOSLI6UDrYGV9f0kct2QrZcjzxqvvjMuaCjgy5/mRs7u3AVQab31oanPen77jZIQqn+
 n5O7cK6y5a77TtT/QxHKBEVmnwGIbt5he2YU82WgCxAuKx26StqhYeUyxcuXN+//f1mP0zpeBGI
 DAchxpdo3t49o0A==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam12
X-Stat-Signature: 4dr6bsw7wd8z3ai3o1hj7aqsu8onhqin
X-Rspamd-Queue-Id: 966FF100009
X-Rspam-User: 
X-HE-Tag: 1771185842-792467
X-HE-Meta: U2FsdGVkX19Aj1A8mNIcRsZ4E0DLLR/w+vpVe0zACF2dcqZPX+7MW3iwLCi9Bp9nnh1kh3whvs0To0DlHDBh28bX56iRh07KZaxGFhihSIwKesZ3gJJpbvPHkyR4dXfSLTDZb+/3m2FLgV2jGBEM3d846jjLUGEHH0Y6kmXPO/b8vs2bdgiDmVwkKSHzB73aWztCxrShZ83mINug72PndHY5rQ5LYWuKg+FRsXNnrKrNf1/jnkV4dqP0uYZAZNnJO+EI20y9uRVcbGmuelVfMgqXu8IW23vQVntd3br+VUd8XyHlK08KP5Wy1O5wGhvLPugbyZQwl8ozmPSVGwVe76lCHfA+oxphAxCVrN/JXzMcH1/rMsFfIRVW8hMefIlCTrm0HTfdXrfTxCu0lI8Xru/s7+1vMWWUzV+orZ7kDUDacZmVA5dus8XJcg5B2OuaJGLXdTSa4iESRbGONx/STb3ynLvd+kknpUW3lxY+hX8gkB96/dVEtHQvMGJCCehHL7rwgrB7Ge0Gn0zYViGvWLG5X4f0LdCArJ3cOokCPRwWoAp/QuhwvaMuCqOOy8tDlenmFG5dYZfguTXB7ia1IJK5PBIIZOl2wKuWJPhindoucQ1Zkz34MpYDlxm6KN60Co7pJ5TfOQwhFEQJuPVMK7RJTcb9pgLrUotmAjH10MalAe5RgPjSuSZ4SwZE10aGTrU5VITCO/LFVrnWFU7pndnvFDT+FdSKnafRibq3IqDW72SmPwMAk4NGF19+gtoleFZGeSSXs2I+FuxFo5ujyVNHW7XdT5wU7D30dkPrCDFKn1hZrrOtkwaLUc+lRTpDvYzi4MDw3ajUQnlHu3yFCxJU+QgIQXZ2Lv+ENESTRUouv/BSpKXaKpTy8qHt/ywByD3K33vLcxM2/inuPJ4pE48ZUzWrh+nABgPxW3d9xTyi7oOYsuRlqUSmBPXv/KyhrtG1Y1QEGgl7XY8eXiJ
 G0A3n/eT
 w2BowoIweAR3einNcHMawuotx8D2DMzYVK7q9m50L8CdMQIvohpKg5Dd+y8A8I/sWpPdEVb15eB+vOYBCDCul3aWs4dtGhK1YC7gPtJsqSgIjR1CpEJHy1Vz8nTjufO0Lksq3lQrq9xSYb3YVK5BIduxBeA1iAxUx6UPDzZkk2F2E/jvaWvUbMHi8vR00OlZBpPNGbooZTHTBFTGtoskfbpCOIHgawb4NXDh3W29lQd5ODMvi4lVZGQjNN6kFwpDOsITuSlbjAmZxaXIommx6ZlEKqrlvMh3dkF/TH0zkNz0QOVYaiUwZHpW+oQjZQG2+UU2c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add `SafePage::copy_to_page` to copy data from one page to another at a
given offset. Because `SafePage` cannot be mapped to user space or shared
with devices, there are no data races and the copy can be performed using
the existing `with_pointer_into_page` and `write_raw` methods.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/page.rs | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index af6d2ad408ed7..c780d10bcf909 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -23,6 +23,7 @@
     marker::PhantomData,
     mem::ManuallyDrop,
     ops::{Deref, DerefMut},
+    pin::Pin,
     ptr::{
         self,
         NonNull, //
@@ -407,6 +408,38 @@ pub fn alloc_page(flags: Flags) -> Result<Owned<Self>, AllocError> {
         // Since `Page` and `SafePage` is transparent, we can cast the pointer directly.
         Ok(unsafe { Owned::from_raw(page.cast()) })
     }
+
+    /// Copies data from this page to another page at the specified offset.
+    ///
+    /// # Arguments
+    ///
+    /// - `dst` - The destination page to copy data to.
+    /// - `offset` - The byte offset within both pages where copying starts.
+    /// - `len` - The number of bytes to copy.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// # use kernel::page::SafePage;
+    /// # use kernel::alloc::flags::GFP_KERNEL;
+    /// let mut src_page = SafePage::alloc_page(GFP_KERNEL)?;
+    /// let mut dst_page = SafePage::alloc_page(GFP_KERNEL)?;
+    /// src_page.copy_to_page(dst_page.get_pin_mut(), 0, 1024)?;
+    /// # Ok::<(), kernel::error::Error>(())
+    /// ```
+    pub fn copy_to_page(&self, dst: Pin<&mut Self>, offset: usize, len: usize) -> Result {
+        // INVARIANT: The following code makes sure to not cause data races.
+        self.with_pointer_into_page(offset, len, |src| {
+            // SAFETY:
+            // - If `with_pointer_into_page` calls into this closure, then it has performed a
+            //   bounds check and guarantees that `src` is valid for `len` bytes.
+            // - By type invariant and existence of shared reference, there are no other writes to
+            //   `src` during this call.
+            // - By exclusive ownership of `dst`, there are no other writes to `dst` during this
+            //   call.
+            unsafe { dst.write_raw(src, offset, len) }
+        })
+    }
 }
 
 // SAFETY: `Owned<SafePage>` objects returned by SafePage::alloc_page() follow the requirements of

-- 
2.51.2




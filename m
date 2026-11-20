Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07445606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TE3DoABs
Received: by kanga.kvack.org (Postfix)
	id 18A526B05C1; Fri, 20 Nov 2026 05:28:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13B0C6B05C3; Fri, 20 Nov 2026 05:28:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02A906B05C4; Fri, 20 Nov 2026 05:28:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CDD026B05C1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:28:43 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B112DA0E97
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:28:42 +0000 (UTC)
X-FDA: 85455123684.23.A1CBE12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id E090580007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:28:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TE3DoABs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795170521;
	b=KIpdA6Fa0oapztnsvMummUDohN+B3QADemSB8YBxSsDEnlADB5dh+pFdKKXMNUUi+FKon8
	ngY5yNZu9CYdcmrowwvxMsSb0PMmHxrGD//CQN7zXpmbS7PBNTgILlLlfgK57OEFtkxjoB
	B99Vzx0HQAPy0YaKYA7PYFmY1GjTlx0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795170521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4CgRzJqEpozYdtfooGGK8vO5/mhcOc1oY2ASDM+A4Y8=;
	b=SClfC0DI4U424mqmsYsuE0CgXrHaaepfFwPs9adaZP6gsbZz+FwnjlY5OHqyORWG6cf6gP
	QH2oA1YSKmNsCNxVjkIuKzQXOIl1dgW7/SW0WQspz9xqRoiPmqzZBysaQc5Xu2cdOo7biZ
	hGLNku2Msn95P2sGNk3Eo5XOAuHh9zk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TE3DoABs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 41ED742E43;
	Fri, 20 Nov 2026 10:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669361F00ADE;
	Fri, 20 Nov 2026 10:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795170520;
	bh=4CgRzJqEpozYdtfooGGK8vO5/mhcOc1oY2ASDM+A4Y8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TE3DoABsetFmiGLQRbnkFNlVMuhNO43XVPdNZWmKh3FKhdpH+hhGnf2Q/hqQitH13
	 978n1hhvAk+HdkiJFeT+T9svsUZnwIqPR9d/6z0FNhP3ctJz3oMKPl9lCWqVx7OgkS
	 azo0JE4vfqnaQ+Ga0s0q8mtyu63ZQPo85RevTmLkAgjvkLAoFLDS4l7wVBAJJpasUm
	 gROZQg/nA0+kcJCb++Od9KI0O/jua8h501RXmrJnQVLnbTm7wKPe8GMUxrSIYs+o76
	 /KWvlEgEJAsgQGGRSRALIlAxusEvsRUkSPu5sKsya8ctgMYoJ+Uw4RkqTODz0oBI6E
	 N7QLGUBPrOFRQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Nov 2026 11:27:00 +0100
Subject: [PATCH 01/11] rust: page: tighten safety requirements of `SysMem`
 copy methods
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-page-shared-v1-1-66f8c4c62822@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3044; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=SEmUKaWSirshMZNhFKAa6XD1FMrLGE2pgSxpI+8ilKM=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBrACCCvNGTm5okCaeQwkmLXdu/rlqIT+sC5ohTS
 kzAeoYXjYOJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCawAgggAKCRD6UCkIqsW9
 0LBnEAC3BwBnfGcNsqqgePf0LBDFq5c9O1unwZ/ZKtEH4IY22gEgrLiQVbxyq0tD4/4fD+WKJid
 X8CcsZCdr09obivkErnkRLd9CQCIFopCjlhd5no9MgOAYHmQNhy8xDZeCEDqsG6/I9jcv5wmkQ8
 OTL6sD9/3+hdv1CP44TyYVxUd5cJsuk6CG06ttDtHfg7fh14fo07IWQ3rEJNV/5Roo8kAjr7mVy
 BVGbGeZvk9Bsrd5x/4mULz+5ZE5x7Ny+04atr4VjWaXfEx55nL3GML2D1zDraiiyc65OQufh5H5
 ceDkLDUXU77PSUEZ6a+bscAQmYgfXWGSnIC6q7YK00I4uf4T9216sb88cCVg6YRY/WRhW7udoU/
 VLgd+meakaYxWCA3liBK72qyFi2E3bFJMv9Yh3kEX1F0xgTd6AIT/FTGp9OGB2wPPhG0MCnxaRA
 RigFx0HUH9BcFcEOD4KuNam4jiPtEF+2px8DFVnCfJI9Z/G+5semJQB75CiIR7eflO761DJNtCJ
 rmPUUUirheB7jZQvmat0C922Ib0E1ec8sR5YmMIv1LrhGuY1mrVYwcg5/OghrxQxEdOX8+QCkvC
 L8tRWakO1j0yaE5qxJaNMPnmSZslF6Qg0M8caU61RrlC0eSyjFDhjzLgA96k+bx6TtBFdm2I+OQ
 BrncguZsQuvLWIw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: bzr1c18s5cyq9ra57cpctzmtc89sy945
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E090580007
X-HE-Tag: 1795170520-988100
X-HE-Meta: U2FsdGVkX1/FH7nHXQ/a9InUsg/cOT0d9SF6PAtYzpv8Q4WtHeuz8fxHgMYWy9mhUD5tkgAzy+lWUA/z4k55exSUpQblTxSyTsD5TEOvOWs3GkR9vFS7x0zyN/5jEt78o8RSTlmqjBALLBbAy8Co7IMjbgSctbZkffmlQQMKzxaowpfs1ZbBgbdHvKpuIAJK+pmuRZK2KY7VF9UFn2ujQlWAWD3bDXUttOIxwYYdzHQPgiglsCYUxgsHgFFPb7ehdfg1ilSO/6EDGlCrmVbLun3LtM2/Th5hzc8cqECRwLXHNGkRJY/AvW6fe0W9SxlK8LnCafDXrjf+z77zkeDaCd1kU2F3I5SAqiTOy2v3D+MtOd7Jh8hSR9NYXxF4UHpu+W5CxcUlsEmxNUPfChsalUeLuHX6lu/vL6PELZgLv0HJfmfjElKLC71ySR1EuxB863DpN132kJZIlQqAbefWR1ynBcW581BwLe8XUoqwtt/iGsQI9JxrY98XCLXQO69is+yd3CZ6SIubpA4om6kTCR4+wCRqMkprv1yLw+Btw52UWSd9z3F07N3d1hXNSMjz6axlf/nJSpUa+7Y9/obRL6iDxFE7rAKmGlJ3F5Gf5+KoatIDTA3nB44UC9dV1JGRf7oslJe5pxm7e6Vk5tqemOj4eMtS7UbFF1YMtW0FbfkIev6IQPB8vh9ma9A8+Oe58dvNnqwtYJZWuyQp2cgh4ihffpuKATOZsZnwCL5O86dK/O/iP3fUXnsNzyk6aAbGWMU2LKR4evLmj1AyMueKe1AmToKEAdXWdNBLaRGNn4uDOHda8E7Za/i2c2Q8887K3KBzXXecrxAQk3ZdEiuxTcIXyKQx17NCMih1e4Q7hiPeAJBVRq7fHcrrNQjtDh9sQMEYgXY+i2FgnRs8MK4oqHFNBGe+SXVSnIjX894ODibhhVUi/1M7N4wgsEPxDGp7YRGgdkxPk9wbpJ6pmEs
 JlIDXGua
 Pid/49III9g0w/2PD65W6/NwOKIyk4m6ETLFxMr1N1JFmCgMONUMQARROr3lAFI7rZO+oML/Wt+dlryjBfUH2HVUp7XAZivFSaG3YTv03JaEdABxWEmGrIUBoxkWRBC27rqGcJp9tZFlwKm+cm/h+R9hdOhiqIo0OWT0/xWduwI8kwUlslps9f8z6jII7vNJqoXbGDF/L6sFOSywcwd+uIzsax0T8whIvYwKYrN8OSi/antdXFKSqKmsQhqUqlRaulXI32J6TBlVuk5muOsT0KEerdq/JtZv00mUPzumKk6wyzbcly0Yb8Hv6rRRRv0T8cmiVk73unt2HqM/puSpF4PrzSE8DSIHl7TenDQ1so+b6jNcYtk8P222nFcy/o8pgApu8LFRC+QtR3PU2KTLf0FklbZiSOx26q6zwo8UE6A6RGo2x+2S3aiJrew9D8I35y5rhZvGAfTVF0tOZknqJBSf/Tx2Vi1aGhmE7/qqiCJfbVhin8SSjVi+hv/aoxa4Uka6p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

`Page::read_sysmem` and `Page::write_sysmem` are available for all page
kinds, so they can be called on a `Page<Exclusive>`, whose data can be
referenced as a slice. Add the requirements that the raw accessors of
`Page` have for this case: no mutable reference to the data that is read
may exist, no reference to the data that is written may exist, and data
written to a `Page<Exclusive>` must be initialized.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/page.rs | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index 4ea7368b4699..3c48ecde4d14 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -374,6 +374,8 @@ pub unsafe fn read_raw(&self, dst: *mut u8, offset: usize, len: usize) -> Result
     /// Callers must ensure that:
     ///
     /// - This call does not race with a write to the source page that overlaps with this read.
+    /// - No mutable reference to the data of the page that overlaps with this read exists during
+    ///   this call.
     /// - The memory region of `dst` does not overlap with the memory of the page.
     ///
     /// # Examples
@@ -391,7 +393,8 @@ pub unsafe fn read_raw(&self, dst: *mut u8, offset: usize, len: usize) -> Result
     /// // way while `dst` is alive.
     /// let dst = unsafe { SysMem::new(&raw mut buf as *mut [u8]) };
     ///
-    /// // SAFETY: `page` is not written to during this call, and `buf` is not part of the page.
+    /// // SAFETY: `page` is not written to during this call, no reference to the data of `page`
+    /// // exists, and `buf` is not part of the page.
     /// unsafe { page.read_sysmem(dst, 0)? };
     /// assert_eq!(buf, [0u8; 16]);
     /// # Ok::<(), Error>(())
@@ -453,6 +456,10 @@ pub unsafe fn write_raw(&self, src: *const u8, offset: usize, len: usize) -> Res
     ///
     /// - This call does not race with a read or write to the destination page that overlaps with
     ///   this write.
+    /// - No reference to the data of the page that overlaps with this write exists during this
+    ///   call. Such references can be obtained from a [`Page<Exclusive>`], see
+    ///   [`Page::as_slice`].
+    /// - If the page is a [`Page<Exclusive>`], the bytes of `src` are initialized.
     /// - The memory region of `src` does not overlap with the memory of the page.
     ///
     /// # Examples
@@ -476,8 +483,8 @@ pub unsafe fn write_raw(&self, src: *const u8, offset: usize, len: usize) -> Res
     ///     )
     /// };
     ///
-    /// // SAFETY: `page` is not accessed in any other way during these calls, and neither `data`
-    /// // nor `buf` is part of the page.
+    /// // SAFETY: `page` is not accessed in any other way during these calls, no reference to the
+    /// // data of `page` exists, and neither `data` nor `buf` is part of the page.
     /// unsafe {
     ///     page.write_sysmem(src, 0)?;
     ///     page.read_sysmem(dst, 0)?;

-- 
2.54.0




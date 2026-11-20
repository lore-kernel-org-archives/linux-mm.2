Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A0D260A260F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HkamTiQD
Received: by kanga.kvack.org (Postfix)
	id 7094D6B05C5; Fri, 20 Nov 2026 05:28:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6934D6B05C6; Fri, 20 Nov 2026 05:28:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55B226B05C7; Fri, 20 Nov 2026 05:28:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2881D6B05C5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:28:57 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6BACB120DB0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:28:56 +0000 (UTC)
X-FDA: 85455124272.18.DB80C91
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8830640006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:28:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HkamTiQD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795170534;
	b=ZaTSW8SflpuISeoVa/DRjT31wXsPfqMybkhnX9dpk9M+ArHHiU2AylUIbDVtR+9RY3mVf9
	Iliv4ZfTTKn+jyrTTzFwvA6pWNQ7fQOMrupdnRuPTsWwLHWoczdE6nhF4vS3GZimmgMDEo
	gdxJcEvl01eC3L/pK5OeIFL0bIN3La8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795170534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j/szci0MGX9JxJDp7fsrmoE1Wtd7fkA0Bt+dBF1YzqY=;
	b=Eof0yz2mNx/uTKTl1qxu0JQs9q/0Evku0bkxOA8GlDgo1nReFA8Vqz0W3tPVnaKmON5lmW
	wHzVwwcxP6dZVojAAF4JtTZPkwkvbNYTnj+VkfY+ujH1rUsUU9emsP8Uv3/EAQOZo4kIhe
	2A7mqmocpOTwmZnHFzqhxAFTCE3NUv8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HkamTiQD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D6E6342DA9;
	Fri, 20 Nov 2026 10:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093B71F000F2;
	Fri, 20 Nov 2026 10:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795170533;
	bh=j/szci0MGX9JxJDp7fsrmoE1Wtd7fkA0Bt+dBF1YzqY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HkamTiQDnW0r0OVWszd8gG7YutWttg7et++C/Shtqvc6hwN8edzlV4JV/2e48Zb7w
	 WScbCPd1xmT9lH6zAFlrgoEWd6AYHzLnUlzT2quPEHKPwaHiKymjDzu6gW1Ep6gOvO
	 qmc6pc1KKfq14g6wN+shhcEiLMsgukiCE3dCN1mK5FJB6PeFeR3fW4EZKjdKuhxdUh
	 5zPtFUg5p+i53pz9EqDOxtVcdcFyZqLq2uPsvrOOOXxTrdd7dkmJa0Q04fo7UriJFN
	 zyXXuJDXJrhlS2ZzE6izpmHdvn7xAzIA2bJUXu2/H/5q6R/cC5TvMqKlNP65rcH92G
	 O0PgnzHhn7e6Q==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Nov 2026 11:27:06 +0100
Subject: [PATCH 07/11] rust: page: add `Shared` page kind
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-page-shared-v1-7-66f8c4c62822@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=15462;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=5jlwB/z7RgJAQSAn2c0WNg81s6RfGzaMZlrq1wgzY7w=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBrACCHrdBD1Vmr1KW+YNvndSYcvPP780PjhbXGT
 Y1YydvQPcqJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCawAghwAKCRD6UCkIqsW9
 0F7tEACBAig1D0HOYOgRzFJPq6cglZMGGk9IgSkD2+pcbUStfw9OMvQ1/ppeAVh+/JbXD8/f2lw
 drEgng/rAT24jr1KBdwmxqxzb8qZK71Vr0tSJNTlAPWstDmKRwIw/gz1UsAwXc5VR7JE5EeR3R1
 kB3zd/6JWIlS77QsmKJRoZq8Lkoj93+NGritC5Q8TbXHlTReIjGC2QL0w0YtPygpVyC5q2+FAsc
 lkdq3JdU5NvFtBAO7BA6d1dcYnqbb69HiM3YTZL3BLc2+dylq3OX/LqmW/gfGvvm2CgGgFo3DLy
 owjBgK0vJEX7tX3cm9fpX/87qSebKgdp/JG6/+c0eHXTTpbCqBurCYcE0Xy6T7AVbzZ7UOPgLas
 IfmMgdGS4ymISKjVTGMUTgRwF5mom4syPkeNaZcuy0rx3kNJ88gvvZdf4ELixMamYad8JttVZ9O
 aVVHBSZFjhLgrrCJjM0qYQyhh3Y/91mjdafXoOn/AZJW45QTwcEc6EzgL5J9ESWhOM91YtW1ntn
 Z9aao0LV7anAnl5Ohh6e9Kpwpe2yCVm/z80Bi+++DsNxG7OiTmqCdw+H5jiwhaeOhc9Hc9xICZH
 XxrV1iLGdDzlZhMqpplN3AUOE4jPTlLXcrTdjPqhpvjrLypa5Gg8Tuxphey8aWE0+mPDmzXVMO4
 bPZXJiE339/X1/w==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8830640006
X-Stat-Signature: 5zesf1bk67nxgi47gxee8m1ksm7k6ezp
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795170534-269359
X-HE-Meta: U2FsdGVkX18jgH7ClUz42vvVbz1rAabtMcPaLijqjFN77ehrmR29PkO1NMUt0TN2ls7y0wWfomLRNhcMGDvY5ggheGBGNumfxTZmFc2JWx3wSMn2WzzH6MZnc44TLGl49yjfQpqF+6IXds2ttk4OCwbip5+Pn4jRoydJDSEdZufPMrVcNKj8wZRyw43kR8rzNlfz++/SNld+xqR0DoQpPJ0le7JPa27YR7RcpGikgHwQOMKzfaaGpBcqpb2Cw/1ZlksvCuRE5wQHaVEYhXxZJ/OVBbIy75kwkvvLbuFdYs3PlNb4yWv1ItiBlHIGF3kKGhB1v1FCAMBH92XldywS/0ZfiSnaiHERbZ1MUmwUcNDhxjlX+KLgt/3PhS6ttswAs9e7+81YzV6Nrc2ZmBwsW0GBPabkDth4qYwtJBYF2izT1qU/Co+iEUNNMHXkY9hPTv7eRZsb5smTMtGluhbX6F9uedwXBNYO0t/cxr9LTUpu5QJna83rjw81mNeeTwbI/2iUi4mx+rlivVIO4Y5MDicsWYlPQ1OxilolCMMWFoBZnE5xf7NgDxdOqot9J64ud0PLUUjUqy/Bb/8AGroh3O0Kremc3RwLvH7ZvyY+mAfl1KPZNXVIvusxIQL5ptvH8BmPsIJLOHluADb0xTfwGdbM2UuFaBnv2gwhihwoI4mXnDKbu6ztR/2l2c3Io/YacYGjo2JLK+ATpiRT1Eon6SreFNlUE9x3rxCSkm9u6a1GTzFj5HaoHRYXY/iRvn3rXQWALDIEjKUlgKP+K/OCgUyT4QIs8BSDK3zmMgXpgJEUdGVQl4IGDVO7Pra/orXdKuS4aswypyW8Ed7n27ymQLOUG5PcSpOf09FxwOi0NsZzc9lNuWgklO4hct4in2syc1ACMuZ5EP5Hdbd/0/xVKOcTxWTH4f8gPN48ATaUNIDTGK2ickijZugBWQWxdqfgKKynn6j1tVYJylx+Cfe
 OJKZFDhu
 d90UEJxxv5VeOoGOtwwR5OgPh9cRPWqqqP79vw39OhX3UspW+mrf0NkfdRs3lYJLCb1tZC7h1zD3PfNb9KFg6O1Y+OgnQsmJBadJuPQpD0IlscSQJz4wPEwE+DzKVVpn93qgiyo4bs1NaLdFB/tDk6em+Gt+lz9TQL8PktTlkh8rgSQC4LMuPdDpeEmtUA53t7RWc0LPuukGpCPRyy7WS5NZyiypkUFPGDDAfJ3oLA8Q0KDup0T5PicrYrLxAMHnVIlI82sAbH7tYojcRkRuoCv61eQ69L4udLaiCwgOEvnVfX2zIW80KcsICzviJzG5d2pxrNYzkpcniC7PYF903hCzbAdtTKtAL11hDBuU6/Kw5Emy6j9OUSUTb3KUS2X9t615HYg5pD6LBqzdiQp5PJ/KAXCoT013D45slUFjNDAjkT4IaDKEbh7wihh5ybZcFXpSzd7lsBQdWjLG+kl5BODX08suDLKb0zRJ1aa09zjQMwZDQgPoTFQc6Hcdl7r2p7P/tG+1VLe0t7E1W05oZeBPRrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A `Page<Exclusive>` hands out Rust references to the data of the page, and
it dereferences to a `Page<Base>`. Thus, no safe method on `Page<Base>`
can access the data of a page, since the access could alias a slice
obtained from a `Page<Exclusive>`.

Add a page kind `Shared` for a page whose data is initialized and is not
referenced by Rust references. This allows safe accessors that use
byte-wise atomic operations to be added for this kind.

Let `Page<RefCounted>` and `Page<Frozen>` dereference to `Page<Shared>`,
and let `Page<Shared>` dereference to `Page<Base>`. `Page<Exclusive>` keeps
dereferencing to `Page<Base>`, so it does not reach the methods of
`Page<Shared>`.

Force `__GFP_ZERO` in `Page::alloc_page()` and `Page::alloc_frozen()`, so
that the data of the allocated pages is initialized.

Require the source bytes of `Page::write_raw()` and `Page::write_sysmem()`
to be initialized for all pages that are referenced as another kind than
`Base`.

Add a TODO in binder, which writes objects that are not bounded by
`IntoBytes` to its pages.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/android/binder/page_range.rs |   6 +-
 rust/kernel/page.rs                  | 109 ++++++++++++++++++++++++-----------
 2 files changed, 78 insertions(+), 37 deletions(-)

diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binder/page_range.rs
index db0853751993..bddc4538745e 100644
--- a/drivers/android/binder/page_range.rs
+++ b/drivers/android/binder/page_range.rs
@@ -588,8 +588,10 @@ pub(crate) unsafe fn write<T: ?Sized>(&self, offset: usize, obj: &T) -> Result {
                 let obj_ptr = ptr::from_ref(obj).cast::<u8>().add(obj_offset);
                 // SAFETY: We have a reference to the object, so the pointer is valid. The pages
                 // of this range are `Page<RefCounted>` pages, and this driver never creates a
-                // reference to their data, so no reference to the data that is written exists. As
-                // the page is not a `Page<Exclusive>`, the object does not have to be initialized.
+                // reference to their data, so no reference to the data that is written exists.
+                // TODO: `write_raw()` requires the bytes of the object to be initialized, as the
+                // data of a `Page<RefCounted>` is initialized. `T` is not bounded by `IntoBytes`,
+                // so this is not ensured for a `T` with padding.
                 page.write_raw(obj_ptr, offset, to_copy)?;
                 obj_offset += to_copy;
                 Ok(())
diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index 643af7cfbef4..85c710fa3dfd 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -104,11 +104,13 @@ pub trait Sealed {}
 /// Marker trait for the kinds of a [`Page`].
 ///
 /// A page kind describes what is known about a `struct page`, and thereby what a [`Page`] of that
-/// kind can be used for. See [`Base`], [`RefCounted`], [`Frozen`] and [`Exclusive`].
+/// kind can be used for. See [`Base`], [`Shared`], [`RefCounted`], [`Frozen`] and [`Exclusive`].
 ///
 /// A [`Page`] of any other kind dereferences to a [`Page`] of the base kind [`Base`]. The
 /// purpose of the dereference is coercion: a reference to a page of any kind can be passed to code
-/// that takes a `&Page<Base>`.
+/// that takes a `&Page<Base>`. A [`Page<RefCounted>`] and a [`Page<Frozen>`] dereference to a
+/// [`Page<Shared>`], which in turn dereferences to a [`Page<Base>`]. A [`Page<Exclusive>`]
+/// dereferences directly to a [`Page<Base>`], as Rust references to its data can exist.
 pub trait PageKind: private::Sealed {}
 
 /// The base [`PageKind`]: a valid page with no further guarantees.
@@ -126,6 +128,29 @@ pub trait PageKind: private::Sealed {}
 impl private::Sealed for Base {}
 impl PageKind for Base {}
 
+/// A [`PageKind`] for a page whose data is not subject to the Rust aliasing rules.
+///
+/// The data of a [`Page<Shared>`] can be accessed concurrently by other parties, such as user
+/// space, devices or other kernel code. Thus, no Rust reference to the data of the page exists.
+///
+/// A [`Page<RefCounted>`] and a [`Page<Frozen>`] dereference to a [`Page<Shared>`]. A page that
+/// is managed by other means can be referenced as a [`Page<Shared>`] with [`Page::from_raw`].
+///
+/// # Invariants
+///
+/// For a [`Page<Shared>`]:
+///
+/// - No Rust reference to the data of the page exists, except for the duration of an unsafe
+///   operation whose caller rules out all other accesses to that data. In particular, the page is
+///   not a [`Page<Exclusive>`].
+/// - The data of the page is initialized.
+/// - No plain access to the data of the page races with another access to that data. A plain
+///   access is a non-atomic, non-volatile access performed by kernel code.
+pub struct Shared;
+
+impl private::Sealed for Shared {}
+impl PageKind for Shared {}
+
 /// The default [`PageKind`]: a page that is managed by the page reference count.
 ///
 /// A [`Page<RefCounted>`] is accessed through a shared reference or through an owning
@@ -138,6 +163,7 @@ impl PageKind for Base {}
 /// - The allocation of the page is managed by the page reference count, and the reference count is
 ///   non-zero.
 /// - It is permitted to take additional references to the page with `get_page()`.
+/// - The invariants of [`Shared`] hold for the page.
 pub struct RefCounted;
 
 impl private::Sealed for RefCounted {}
@@ -148,13 +174,14 @@ impl PageKind for RefCounted {}
 /// A `Page` is generic over a [`PageKind`], which describes what is known about the page:
 ///
 /// - `Page<Base>` is a page for which nothing is known beyond its validity.
+/// - `Page<Shared>` is a page whose data is initialized and not referenced by Rust references.
 /// - `Page<RefCounted>`, or just `Page`, is a page that is managed by the page reference count.
 /// - `Page<Frozen>` is a uniquely owned page that references cannot be taken to.
 /// - `Page<Exclusive>` is a uniquely owned page whose data follows standard Rust aliasing rules.
 ///
 /// Operations that are valid for any page are available for all page kinds. All other page kinds
 /// dereference to [`Page<Base>`], so that a reference to a page of any kind coerces to a
-/// `&Page<Base>`.
+/// `&Page<Base>`. See [`PageKind`] for details.
 ///
 /// # Invariants
 ///
@@ -174,7 +201,7 @@ unsafe impl<Kind: PageKind> Send for Page<Kind> {}
 // them concurrently is safe.
 unsafe impl<Kind: PageKind> Sync for Page<Kind> {}
 
-impl Deref for Page<RefCounted> {
+impl Deref for Page<Shared> {
     type Target = Page<Base>;
 
     #[inline]
@@ -186,12 +213,24 @@ fn deref(&self) -> &Self::Target {
     }
 }
 
+impl Deref for Page<RefCounted> {
+    type Target = Page<Shared>;
+
+    #[inline]
+    fn deref(&self) -> &Self::Target {
+        // SAFETY: `Page` is transparent over `struct page` for all page kinds, so the pointer cast
+        // is valid. By the type invariant of `Page<RefCounted>`, the invariants of `Shared` hold
+        // for `self`.
+        unsafe { &*ptr::from_ref(self).cast() }
+    }
+}
+
 impl Page<RefCounted> {
     /// Allocates a new page.
     ///
-    /// # Examples
+    /// The page is always zeroed. That is, `__GFP_ZERO` is added to `flags`.
     ///
-    /// Allocate memory for a page.
+    /// # Examples
     ///
     /// ```
     /// use kernel::page::Page;
@@ -199,21 +238,17 @@ impl Page<RefCounted> {
     /// let page = Page::alloc_page(GFP_KERNEL)?;
     /// # Ok::<(), kernel::alloc::AllocError>(())
     /// ```
-    ///
-    /// Allocate memory for a page and zero its contents.
-    ///
-    /// ```
-    /// use kernel::page::Page;
-    ///
-    /// let page = Page::alloc_page(GFP_KERNEL | __GFP_ZERO)?;
-    /// # Ok::<(), kernel::alloc::AllocError>(())
-    /// ```
     #[inline]
     pub fn alloc_page(flags: Flags) -> Result<ARef<Self>, AllocError> {
+        let flags = flags | __GFP_ZERO;
+
         // SAFETY: Depending on the value of `gfp_flags`, this call may sleep. Other than that, it
         // is always safe to call this method.
         let page = unsafe { bindings::alloc_pages(flags.as_raw(), 0) };
         let page = NonNull::new(page).ok_or(AllocError)?;
+        // INVARIANT: The page was just allocated with `alloc_pages()`, so it is managed by the
+        // page reference count. We allocated with `__GFP_ZERO`, so the data of the page is
+        // initialized. The page is newly allocated, so nothing references or accesses its data.
         // SAFETY: We just successfully allocated a page, so we own the reference count returned
         // by `alloc_pages`, and we transfer that reference to the new `ARef<Page>`. Since `Page`
         // is transparent, we can cast the pointer directly.
@@ -246,8 +281,10 @@ pub fn nid(&self) -> i32 {
     ///   the [`PageKind`] types.
     ///
     /// Note that the invariants of [`RefCounted`] do not hold for all pages. For instance, pages
-    /// owned by the slab allocator are not managed by the page reference count. Use [`Base`] for
-    /// pages where nothing is known beyond their validity.
+    /// owned by the slab allocator are not managed by the page reference count. Likewise, the
+    /// invariants of [`Shared`] do not hold for a page whose data is referenced by Rust
+    /// references, or whose data is not initialized. Use [`Base`] for pages where nothing is
+    /// known beyond their validity.
     #[inline]
     pub unsafe fn from_raw<'a>(ptr: *const bindings::page) -> &'a Self {
         // INVARIANT: By the function safety requirements, `ptr` refers to a valid `struct page`
@@ -352,8 +389,8 @@ fn with_pointer_into_page<T>(
     ///   the mapped range exists during this call. If `f` writes through the view, no reference to
     ///   that data may exist during this call. Such references can be obtained from a
     ///   [`Page<Exclusive>`], see [`Page::as_slice`].
-    /// * If the page is a [`Page<Exclusive>`], `f` must only write initialized bytes through the
-    ///   view.
+    /// * If the page is referenced as a [`Page`] of another kind than [`Base`], `f` must only
+    ///   write initialized bytes through the view.
     /// * Callers must ensure that the view is only used on the current task, as this method may
     ///   use a local mapping.
     unsafe fn with_page_as_sysmem<T>(
@@ -477,8 +514,9 @@ pub unsafe fn read_sysmem(&self, dst: SysMem<'_, [u8]>, offset: usize) -> Result
     /// * Callers must ensure that no reference to the data of the page that overlaps with this
     ///   write exists during this call. Such references can be obtained from a
     ///   [`Page<Exclusive>`], see [`Page::as_slice`].
-    /// * If the page is a [`Page<Exclusive>`], callers must ensure that the `len` bytes at `src`
-    ///   are initialized.
+    /// * If the page is referenced as a [`Page`] of another kind than [`Base`], callers must
+    ///   ensure that the `len` bytes at `src` are initialized, as the invariants of those page
+    ///   kinds require the data of the page to be initialized.
     pub unsafe fn write_raw(&self, src: *const u8, offset: usize, len: usize) -> Result {
         let copy = |dst: SysMem<'_, [u8]>| {
             // SAFETY: By the safety requirements of this function, `src` is valid for reading
@@ -513,7 +551,8 @@ pub unsafe fn write_raw(&self, src: *const u8, offset: usize, len: usize) -> Res
     /// - No reference to the data of the page that overlaps with this write exists during this
     ///   call. Such references can be obtained from a [`Page<Exclusive>`], see
     ///   [`Page::as_slice`].
-    /// - If the page is a [`Page<Exclusive>`], the bytes of `src` are initialized.
+    /// - If the page is referenced as a [`Page`] of another kind than [`Base`], the bytes of `src`
+    ///   are initialized.
     /// - The memory region of `src` does not overlap with the memory of the page.
     ///
     /// # Examples
@@ -650,7 +689,8 @@ unsafe impl AlwaysRefCounted for Page {}
 ///
 /// Unlike for a [`Page<Exclusive>`], nothing is known about who accesses the data of a
 /// [`Page<Frozen>`]. For instance, the owner can share the data of the page with a device. Thus,
-/// the data is accessed through the unsafe raw accessors of [`Page`] only.
+/// no Rust reference to the data of the page exists, and a [`Page<Frozen>`] dereferences to a
+/// [`Page<Shared>`].
 ///
 /// # Invariants
 ///
@@ -660,18 +700,19 @@ unsafe impl AlwaysRefCounted for Page {}
 ///   reference count is zero for as long as the [`Page<Frozen>`] exists.
 /// - The page is owned by a unique [`Owned<Page<Frozen>>`]. No references to the page exist
 ///   together with the [`Owned<Page<Frozen>>`], other than the ones borrowed from it.
+/// - The invariants of [`Shared`] hold for the page.
 pub struct Frozen;
 
 impl private::Sealed for Frozen {}
 impl PageKind for Frozen {}
 
 impl Deref for Page<Frozen> {
-    type Target = Page<Base>;
+    type Target = Page<Shared>;
 
     #[inline]
     fn deref(&self) -> &Self::Target {
         // SAFETY: `Page` is transparent over `struct page` for all page kinds, so the pointer cast
-        // is valid. `Base` has no invariants in addition to the ones of `Page`, which hold for
+        // is valid. By the type invariant of `Page<Frozen>`, the invariants of `Shared` hold for
         // `self`.
         unsafe { &*ptr::from_ref(self).cast() }
     }
@@ -680,30 +721,28 @@ fn deref(&self) -> &Self::Target {
 impl Page<Frozen> {
     /// Allocates a new frozen page.
     ///
+    /// The page is always zeroed. That is, `__GFP_ZERO` is added to `flags`.
+    ///
     /// # Examples
     ///
     /// ```
-    /// use kernel::page::{
-    ///     Page,
-    ///     PAGE_SIZE, //
-    /// };
+    /// use kernel::page::Page;
     ///
     /// let page = Page::alloc_frozen(GFP_KERNEL)?;
-    ///
-    /// // SAFETY: The page was just allocated and is not shared, so there are no concurrent reads
-    /// // or writes to the page, and no reference to the data of the page exists.
-    /// unsafe { page.fill_zero_raw(0, PAGE_SIZE)? };
-    /// # Ok::<(), Error>(())
+    /// # Ok::<(), kernel::alloc::AllocError>(())
     /// ```
     #[inline]
     pub fn alloc_frozen(flags: Flags) -> Result<Owned<Self>, AllocError> {
+        let flags = flags | __GFP_ZERO;
+
         // SAFETY: Depending on the value of `gfp_flags`, this call may sleep. Other than that, it
         // is always safe to call this method.
         let page = unsafe { bindings::alloc_frozen_pages(flags.as_raw(), 0) };
         let page = NonNull::new(page).ok_or(AllocError)?;
 
         // INVARIANT: The page was just allocated with `alloc_frozen_pages()`, so it is frozen and
-        // we own it.
+        // we own it. We allocated with `__GFP_ZERO`, so the data of the page is initialized. The
+        // page is newly allocated, so nothing references or accesses its data.
         // SAFETY:
         // - We just successfully allocated the page, so `page` points to a valid `struct page`.
         //   Since `Page` is transparent over `struct page`, we can cast the pointer directly.

-- 
2.54.0




Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0DAF606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 16:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RsfWkpgD
Received: by kanga.kvack.org (Postfix)
	id E5D5A6B05BB; Wed, 18 Nov 2026 11:19:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0DB66B05B1; Wed, 18 Nov 2026 11:19:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFC086B05BB; Wed, 18 Nov 2026 11:19:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 94A516B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:19:22 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2D99AA8512
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:19:22 +0000 (UTC)
X-FDA: 85448749764.28.F1F70E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 57F4D1C0005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:19:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RsfWkpgD;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795018760;
	b=lNBcZzKk1SwG2qPNunxPL8FAi2JGsuGQszWwjfb2n6OguGZx7FskA+u/OJeSshWhErb04A
	+LcV+dloOETeh0K4oXlRaUAUCxlmoMTznp/7jOL51PsXw6Ygne1VKncKJSM1XDiA67w7W7
	rD+4jrafjSCC7yMJX6Sg1eyQBEwCPrg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RsfWkpgD;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795018760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B3/C9Gq7wR7AFFJJ/O6DHxX08MLwJ2b7auylc1SLKLo=;
	b=SgO3mboaP2AR7uxW4fpklcG61VOwmxQZEAxcsk1CXz7WtCMXb5CmM1hcpYaBGe2mnfMA3Y
	t3XQfpQM+l/UOqtT6gBTgYYRvTEK5gVMIjq/cXKi3ZQai7CM5TEG6xtuDprrdrog4V/+r/
	nnHllmSbjBdjFUucEteKFFmqtBkwmNE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8FFF9409FE;
	Wed, 18 Nov 2026 16:19:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F0B1F000C6;
	Wed, 18 Nov 2026 16:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795018759;
	bh=B3/C9Gq7wR7AFFJJ/O6DHxX08MLwJ2b7auylc1SLKLo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RsfWkpgDLp1mCjhaNligmLWmgxBb5kY1ZGpwk2QKIjpJU0PyMPKIHdu+2FbDu2pP7
	 veZvae8ECkaTr3EnIw5zQjqv94cbE+quQ/yYL3JJnIh2Q6+mkXgQ9dqLu4c/HB9Py5
	 aIhzX83c9IUyrfuLValnUJck/o7xoTfXqZPLkKBBLkmedgPNc5MVmPE4oMcpOPb/7U
	 hziGnXN/+DQVEFqpDq3RZeNY+8+0RF1H6Fc1ZCiqt+PCG7t2/y0HD68iuIkeD7TKmx
	 M7thuTJDf5GoPDLWXp9K+8FQEVM3+vNvf0ej94fc6RB4bVStI32dGCS/YSCN6B2e0t
	 fu5T3lMDz9vjA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 18 Nov 2026 17:18:21 +0100
Subject: [PATCH v22 5/6] rust: page: add `Frozen` page kind
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-page-ownable-v22-5-d63ff73f4075@kernel.org>
References: <20261118-page-ownable-v22-0-d63ff73f4075@kernel.org>
In-Reply-To: <20261118-page-ownable-v22-0-d63ff73f4075@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, 
 David Hildenbrand <david@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Mike Rapoport <rppt@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Wilcox <willy@infradead.org>, Danilo Krummrich <dakr@kernel.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 =?utf-8?q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, 
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
 Carlos Llamas <cmllamas@google.com>
Cc: Igor B <igor.b@beldev.am>, Vitaly Wool <vitaly.wool@konsulko.se>, 
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6418; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=Vw4L8gIAfErZqGCBSVgqXqrFyw9e8Tx+BWAmaOIHTt0=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBq/c/yGLmpTN6MVE81epUxMfSmozWD0gj9RVIwM
 8pzLB0S2CGJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCav3P8gAKCRD6UCkIqsW9
 0LQ/D/4qFDkHHYuNbKZFNk28mwu2XI0qWlvZb+yKZysjypoPr4fOmrZ52fDhIYrdb4eToGSX2pG
 sLZYateZ/XLI8/ShJGeVVXvty5PamrB53EBrFHry0pfIXTyhhvUHdtyMhqFV0zPOncen7wzZuMc
 sh4iMH6JXsFaWh5EjOpi7yIuRsnfo9dP3rFNJydZG4bYTwmmElB1suffnRljJEpv4Fog39s14fP
 sEzyj+M5hM4Lv3Ce8acqYBXahS7sYcDIHxbx+MyDDgq3SlK7MaaCPBBPoloAwK36C0pHDIQuo4N
 YMQzOHiwA9jGFiSjuuv7kHiPA99sRACo3j4WSrO1z7HMqAn0SXgYC6h2XaP/RmwF4CfvSIN4uFf
 M45sKyol8xfrYPaAwdddKfMu/+wtz/cOUEWnB+WJlVp+OUt0DIsPk8sNoTB3bVwMVJhsxZlP0da
 fB8lWj/iQrSAF6HkhDvmkztUYToSBhDlKhNisMYc2nYT18YzQp9utP3tH5a3PDq8cMDGN2KYnPe
 7Sr9jKuGg76FnsQULzx1Rr5VxP3KV9rpM0gft+GAaq7qxry5xGlQ93jqYT8n87mf/JCAm6RHxGZ
 G6y4hiqOJubqTspteKAReaNroTHo92wf6I+oCinvXU314YT3MhOn3dlGiWb8GcUMx+mToEN5KZv
 WzWZmET0WYr76zw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 57F4D1C0005
X-Stat-Signature: 11tiugixq134h618h99jb5fw1pqx6te7
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795018760-659380
X-HE-Meta: U2FsdGVkX1+ChL7r3Ze8MLYcj0g5pjpuWNsWUs1ilndFDcombnThCz3JxJyFXjRBI4fvYp6RGZP3Ov3W6d+9hhmCm6XUsP+qUVyFmG2opT8xG92FHEi1hLfgbqnpZLV4271qCBe89He47aoIs6fef71R5qodl1nO2yFrerm8dOsUkaYduEILfndp/ZhQu6TPsbe8o9yBLsTURBPlKsUZzemYkWzcSUYD/+h2XooJeGKzCd5IvTbinRULAmII7oECLLunHZHmD/MjTebk5wnw6sslbAv4tAYlCua1ocJBpzJ1H/w60oFWYFSMzU7cIcdKtado1G4km5CcfpUsDNiH5tnT2EdeBp8VeYj2Jm/P6by1Mm2WROtOQ2fJUsbQKVRzSIEY+npMgJjQsMm/EnECVWsskqiUW+YUWA88ndhxK4BKD1/Ieqvr38iX2SHkH1DA8DAR9PYfhK4Tw79y6GyNUnz9/+hdqmX09jYIftqI47atzhyp7skSt5QUI9rN2jnatwZx4esvbHRG2iwyluB0+GdgBqD/1GyBBrmJNC5PZk8ycTuR1YxPgoX73z+kLfMO/3P4lrGe/17zEwsoSKidTAYNg001iiykvGMjiER0RPJXv9sqx4+LUdh9UuKPaMSbBZmUYaZGUBoT5oq8Ua6lKHOSPVkGDpqlqWwjVnsra0upylBI9MGYxqyQ6j70Da6WGa6iGKMDETV4Ni7txX1B9zcHRrO5SFeBgYA/pc2LzKkKdSfmAiqoHEhgZYSenwbEUB6kP3qZsYYgBjJmEPdLCsLO9V+BCrbTQiZQuWuNesEVqjY0Ep7cGXl4T9CUJolzNi15NA1JGLAUblehUxRO3EBVbtQrGXbfinotKWf9oDzs/ROEZDESHmXOjLJQVfwiIvkjUIjOP5466k+kBw/aSM1kYYfU0stCFqQXeVYVUWqTwNNQ+LBm87bJt17bWVqgEYxxOS+hVoWOBjPBQus
 cSh370Jm
 37hGUbUy0+YFpgLyZtckebl1euDVE8eO/oGn4QV9NFvzDdKAmxQbv1eROK8RUxsK8MEquRZizOODZHKupFnww7CyCbQtn4PkaVIMyFurjmmubLBVLu1EQESa6aiH/8YK2HrNpZWAvIlE3FSczMcYrWj3+DcgpK+DQhd7d7gS6k5zGTgYWQctYbeAzj3gbfsrAymqgbn47WxLO4eRNIXsLzUjW1obB6qwJdnQcct97vKv7qcJ+MLcWQS1Eb3nWKusldApY12nrb5OgtKGQTbzv10H5TcT50g//+NGVHjGzVOQwRqkcoM2AW4jZKHmuJTcymMdX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add the page kind `Frozen`. A `Page<Frozen>` is a frozen page that is
uniquely owned through an `Owned<Page<Frozen>>`. The reference count of
a frozen page is zero and references to it cannot be taken, so the
ownership is exclusive.

In contrast to `Page<Exclusive>`, a `Page<Frozen>` has no invariant on
who accesses the data of the page. The owner can share the data with a
device, and thus the data is accessed through the unsafe raw accessors
only.

Add `Page::alloc_frozen()` to allocate a `Page<Frozen>`, and let
`Page<Frozen>` dereference to `Page<Base>`.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

---

This currently has no users, but I add it here for completeness. Let's
discuss if we should keep it or not.
---
 rust/kernel/page.rs | 90 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 89 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index c885bcf4f886..c629764f773b 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -93,7 +93,7 @@ pub trait Sealed {}
 /// Marker trait for the kinds of a [`Page`].
 ///
 /// A page kind describes what is known about a `struct page`, and thereby what a [`Page`] of that
-/// kind can be used for. See [`Base`], [`RefCounted`] and [`Exclusive`].
+/// kind can be used for. See [`Base`], [`RefCounted`], [`Frozen`] and [`Exclusive`].
 ///
 /// A [`Page`] of any other kind dereferences to a [`Page`] of the base kind [`Base`]. The
 /// purpose of the dereference is coercion: a reference to a page of any kind can be passed to code
@@ -138,6 +138,7 @@ impl PageKind for RefCounted {}
 ///
 /// - `Page<Base>` is a page for which nothing is known beyond its validity.
 /// - `Page<RefCounted>`, or just `Page`, is a page that is managed by the page reference count.
+/// - `Page<Frozen>` is a uniquely owned page that references cannot be taken to.
 /// - `Page<Exclusive>` is a uniquely owned page whose data follows standard Rust aliasing rules.
 ///
 /// Operations that are valid for any page are available for all page kinds. All other page kinds
@@ -435,6 +436,93 @@ unsafe fn dec_ref(obj: NonNull<Self>) {
 // non-zero and it is okay to obtain an `ARef<Page>` from it.
 unsafe impl AlwaysRefCounted for Page {}
 
+/// A [`PageKind`] for a frozen page.
+///
+/// The reference count of a frozen page is zero, and references to it cannot be taken. A
+/// [`Page<Frozen>`] is accessed through an owning [`Owned<Page<Frozen>>`], and the page is freed
+/// when the [`Owned<Page<Frozen>>`] is dropped.
+///
+/// Unlike for a [`Page<Exclusive>`], nothing is known about who accesses the data of a
+/// [`Page<Frozen>`]. For instance, the owner can share the data of the page with a device. Thus,
+/// the data is accessed through the unsafe raw accessors of [`Page`] only.
+///
+/// # Invariants
+///
+/// For a [`Page<Frozen>`]:
+///
+/// - The page is an order 0 frozen page: it was allocated with `alloc_frozen_pages()`, and its
+///   reference count is zero for as long as the [`Page<Frozen>`] exists.
+/// - The page is owned by a unique [`Owned<Page<Frozen>>`]. No references to the page exist
+///   together with the [`Owned<Page<Frozen>>`], other than the ones borrowed from it.
+pub struct Frozen;
+
+impl private::Sealed for Frozen {}
+impl PageKind for Frozen {}
+
+impl Deref for Page<Frozen> {
+    type Target = Page<Base>;
+
+    #[inline]
+    fn deref(&self) -> &Self::Target {
+        // SAFETY: `Page` is transparent over `struct page` for all page kinds, so the pointer cast
+        // is valid. `Base` has no invariants in addition to the ones of `Page`, which hold for
+        // `self`.
+        unsafe { &*ptr::from_ref(self).cast() }
+    }
+}
+
+impl Page<Frozen> {
+    /// Allocates a new frozen page.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// use kernel::page::{
+    ///     Page,
+    ///     PAGE_SIZE, //
+    /// };
+    ///
+    /// let page = Page::alloc_frozen(GFP_KERNEL)?;
+    ///
+    /// // SAFETY: The page was just allocated and is not shared, so there are no concurrent reads
+    /// // or writes to the page.
+    /// unsafe { page.fill_zero_raw(0, PAGE_SIZE)? };
+    /// # Ok::<(), Error>(())
+    /// ```
+    #[inline]
+    pub fn alloc_frozen(flags: Flags) -> Result<Owned<Self>, AllocError> {
+        // SAFETY: Depending on the value of `gfp_flags`, this call may sleep. Other than that, it
+        // is always safe to call this method.
+        let page = unsafe { bindings::alloc_frozen_pages(flags.as_raw(), 0) };
+        let page = NonNull::new(page).ok_or(AllocError)?;
+
+        // INVARIANT: The page was just allocated with `alloc_frozen_pages()`, so it is frozen and
+        // we own it.
+        // SAFETY:
+        // - We just successfully allocated the page, so `page` points to a valid `struct page`.
+        //   Since `Page` is transparent over `struct page`, we can cast the pointer directly.
+        // - The page was just allocated, so no other `Owned` exists for it.
+        // - A `struct page` is never moved, so the page is pinned.
+        // - `Page<Frozen>` allows no other references to exist together with the `Owned`, and
+        //   none exist, as the page is newly allocated and references cannot be taken to a frozen
+        //   page. Thus, it is sound to hand out `&Page<Frozen>` and `Pin<&mut Page<Frozen>>`.
+        // - Pages have no logic that relies on them staying on a given thread or on them not being
+        //   accessed concurrently.
+        Ok(unsafe { Owned::from_raw(page.cast()) })
+    }
+}
+
+impl Ownable for Page<Frozen> {
+    #[inline]
+    unsafe fn release(this: NonNull<Self>) {
+        // SAFETY: By the function safety requirements, we have exclusive ownership of the page, and
+        // by the type invariant the page is an order 0 frozen page, so we can free it with
+        // `free_frozen_pages()`. Since `Page` is transparent over `struct page`, we can cast the
+        // pointer directly.
+        unsafe { bindings::free_frozen_pages(this.cast().as_ptr(), 0) };
+    }
+}
+
 /// A [`PageKind`] for a page whose data area follows standard Rust aliasing rules.
 ///
 /// A [`Page<Exclusive>`] is accessed through an owning [`Owned<Page<Exclusive>>`]. It has the same

-- 
2.54.0




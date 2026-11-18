Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3CB7606A32F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 16:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YLaPgAOp
Received: by kanga.kvack.org (Postfix)
	id 869116B05BF; Wed, 18 Nov 2026 11:20:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 841AE6B05C0; Wed, 18 Nov 2026 11:20:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70C076B05C1; Wed, 18 Nov 2026 11:20:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BE736B05BF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:20:03 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A1A7B1607EA
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:20:02 +0000 (UTC)
X-FDA: 85448751444.07.B2FC096
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id E99FC16000D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:20:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YLaPgAOp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795018801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5PFXXPSsfMDJDlYp7yb67baZRulWZFU5L1adTXgGMhE=;
	b=7CN4Ahpp1Bv1UbBFctShrVIhNsST+y8UqXlLk7EhsnF28OQnbfgNk8YuZ5FY1shVXcLDZF
	TRxmmiqpBTisOkgvT2K6dlyA2H83ythP3mu1HReT3uYfyZrn6P++Cr6DQNRiSXMunxQwU4
	J8VE2yuBHHQKN7v6qInFlfPE0Orz/Ao=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YLaPgAOp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795018801;
	b=GVBI5F9hmEZOIg7FnHh3RqV/njsbFANtt8dL1YaokxI7OOKyXPTCmukG89t5RHB74k/rKF
	GHqsBOJWkjO+sSynUzI+htzp3feBsUb8f8csl18i36hwmtpDsGo/ps+KgeMoecaYDKHX03
	6cbqP7nzw+0vy4L54nMOgJni1ZngBcA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 73D3C62876;
	Wed, 18 Nov 2026 16:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96CE1F000C6;
	Wed, 18 Nov 2026 16:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795018800;
	bh=5PFXXPSsfMDJDlYp7yb67baZRulWZFU5L1adTXgGMhE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YLaPgAOpZSeqiv/GBBQHaselm8XF/xJSYxOVtQMhFqqMYSqetL9go2WuEgQ0VoDYv
	 zY5kSp+O/lVbcAldahcH8g4jzTHZviWlt9YrIV0fQ1yRFsygzubCyq2l/lq4+KpFbt
	 /njypUKsnCWRoXYZ0sGcRr8B4qE24ncqa6mz/ikixkEtIXR0b8yfKLfZ48YADiZ8YA
	 uN0W1yo4/lbfDm0baixN9COrdSphJp5lToB1l4U6REi3HRiEp/FYItmRS/LbzVodTE
	 8fIFKjZSo9y7WI4B/fIc26zKn54i5MITMj1X1vPRxLAKW7yj+HC4KxhuB4KYXBXuJv
	 KYC62EhvxTz6g==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 18 Nov 2026 17:18:20 +0100
Subject: [PATCH v22 4/6] rust: page: add `Exclusive` page kind for
 race-free page access
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-page-ownable-v22-4-d63ff73f4075@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8167; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=xY9RyFcPl4honuAuuINh1RrHDHvkwLzV3ZF38f/rZhw=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBq/c/xpYsMcrhEizFw2WVSRB7xWSGK+Ui8ul2+B
 jEGczZmMiSJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCav3P8QAKCRD6UCkIqsW9
 0HMXD/9zu76ZNSF8FD1SDk3zbkc8OAq5R3/YxNFgifz0KcGKmxzJ2nLeKvGHiRBAg8N04n4Xqxx
 xrNOsVsIn0Arlu335s0FvlE0xBczWXQUC3jlbGTvO8ijEcIT3RFir+mEMeW8cEBI9MahFxJ/3ej
 ylfJOej+4g1fAXjc54iMbNgnbZlen3WwGN9CfunPlMrd6+t0h1hmCflK2gqs8fG7+ABZIAnotsp
 uPD1Hwz2S4tHUwwb7QsJLuZKaMdL0tKVEVbdosWg33iTp1kZ2fwtoIs23hfIRQugMKMeTT+dV+o
 XK2M3dgkWP9bKvnbcC4LIlD/AqgZWbu8+KOvda+bnQJXsdKCMXabMnhHGIh9+rrzFf2391O0prR
 8upDtDGK2CTuk3K5DSnRETPEHHoLtf+Fj0RZSn5fBT//hn0G89bDLoBwwfYxNJiDasLAGuKRuqH
 HN9g5KisLYB2wCctgtvxXBABg5mG21guJH5rlm32P4cb45NwJzZFgc/0jSZuhkex9Ie9LyY4Kj4
 u/0I1Cs5Xkkk4S+cyeNaYTSc2IgMoKZJXsEt/swm7JRJ1LyCBjxgPpp71vxI2ohi6DYnnLwPq2z
 lpUjztYtArOcyXPOJA1UtnyBtyxpGXOd1k5cLi89NdCcEFHu2srhUrwzcfLozhX0EukdmS/lmmg
 mn2iTTMQn8aCRGg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: g35az8iciouup9h6urymurfe6b61yeik
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E99FC16000D
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795018800-709888
X-HE-Meta: U2FsdGVkX1+15b6W6ORtN4wW5n9nNeHrgH2tRFeGBoYMPTWHoiQXScPT98DN3ARGtYeUt+RfZdz8zGTU+VgOAD7TuuTCrkXwdDz9h2pJGdPTNDD/NjPdgJzGgNWGsC0q50LFwjjuiiPAdsWqv4+ZGx/baUw68rzPHhwUaoGoCgyPeKWQjGBF+R/8zf+GxRYHxDEbQUJZuXWAPALeXHmFISE9ep6MH78fJO+5eYGC2XmXWeLSZg1ZuvATo2h1t42M9H7GACkyZgeOrf8C2UjqqUiYLqJXDxVRWReeIJ2OZejlZKiefFnaEOE8XFADWGqfXWXIgFc7MPrKkmUTTuJ1kLzGsofF21l9VigrCORUiT/9gsNZZmLLzNmun0UiNIBc6NLOxcVE+tm4CMxphuWOxgdIIwOdBUJ/ueSdidr2DCXV2iv6sFkYRYT33kkm71a+0JRNWw7IBj7SnnQVpQfoCHMYSGh0aLhkmotA7UqThBaJC83N8JMrf3tPVfKWMKft26myixAw0mthYvWueq/Tly/LpaGgoVedVNTb/nQh5krlTY2AlO7YNV0Dkb+q6GhOvxaYmlDt3KhOVbnZDmkjxSpP6O7qLzeN2FXUeofRgOYw0J0yMUd1M5a/2B5Nd37/3dOJgAPSdvBQMgT27T8uuQmw3kP2fHMludgC9B//h8CKg4fWdp5Ka/ZftbNTXlxLJjj53E6ieKcDZcOG8Ym+bbc0BVEcfOlwOQQduatCuJNFASEqlL76jPlQzuRq+7LhRj7IoRAcf4rHbo0jhk5pzmbvG/s275104me9Xdnpf5zGtogqmVZhD3TbddGExCpG97NZZSu8sbNFBohBA7j6OtybzadkvtHWaqCaWQoOImFw1u2hjTok/xKb14b8I6+7EJNj+4lcx+sli4cTXeriK+QT0ip4ey7BQ6AsIFNiDfrRbemug8RDPCm9QCRQKaVQhCZZP17T1Qe7UYzcTk9
 ucPiMBLa
 3riZTsdX2mk0HnDTuzVmf8O9Wv6Jpp4tLGvfRfb3pMI2R8CZT5SYRu0t8HalXZVij5zuW4W5gw0PtzAb3FeIeZWFQcyJmnCOEAVOUlqJAbD9khYIOXR4lUh2+m+aqm+GoVfDRRuCXBWWke6xhvrL/aa7v70FInTGNsI3GtJ5cJh2xrH4FvfMhDooPhqMb9KBMzadQSYGtGn3xhpJ+3tfeDaja55PMUTBpmH1cd0TIkKKH4iuN+lwzlSqYg5necH8AUlb3299CqHcAnFKWnl/xedfFrHrxbRe2EbUNLlSmsonxeD41qDcgAkG1GumryrsetVw5C1jAJANp3Op4CboRDjrIiomyHGz9hZCiyjxSIW5CU01wk5C+P1IXbxz5MhARW1PV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add the page kind `Exclusive`. A `Page<Exclusive>` is a page that is
uniquely owned through an `Owned<Page<Exclusive>>`, with the added
invariant that the page data area does not incur data races. This means a
`Page<Exclusive>` cannot be mapped to user space or shared with devices,
and it becomes simpler to directly reference the contents of the page.

Back `Page<Exclusive>` by a frozen page, allocated with
`alloc_frozen_pages()` and freed with `free_frozen_pages()`. The reference
count of a frozen page is zero and references to it cannot be taken, so the
exclusive ownership is upheld by mm and not only by the Rust type system.

Add `Page::alloc_exclusive()` to allocate a `Page<Exclusive>`. The function
is not named `alloc_page()`, because inherent functions of the same name on
two page kinds would make the call `Page::alloc_page()` ambiguous.

`Page<Exclusive>` dereferences to `Page<Base>`. This does not allow
safe code to break the aliasing invariant of `Page<Exclusive>`:
`Page<Base>` does not implement `AlwaysRefCounted`, so no `ARef` to the
page can be obtained, and the raw data accessors are unsafe and already
require their callers to rule out races with all other accesses to the
page.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/helpers/page.c |  6 ++++
 rust/kernel/page.rs | 96 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 100 insertions(+), 2 deletions(-)

diff --git a/rust/helpers/page.c b/rust/helpers/page.c
index 906eb4b18f02..8f9f624ea141 100644
--- a/rust/helpers/page.c
+++ b/rust/helpers/page.c
@@ -10,6 +10,12 @@ __rust_helper struct page *rust_helper_alloc_pages(gfp_t gfp_mask,
 	return alloc_pages(gfp_mask, order);
 }
 
+__rust_helper struct page *rust_helper_alloc_frozen_pages(gfp_t gfp_mask,
+							  unsigned int order)
+{
+	return alloc_frozen_pages(gfp_mask, order);
+}
+
 __rust_helper void rust_helper_get_page(struct page *page)
 {
 	get_page(page);
diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index 2ceeac0237d5..c885bcf4f886 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -17,7 +17,11 @@
         ARef,
         AlwaysRefCounted, //
     },
-    types::Opaque,
+    types::{
+        Opaque,
+        Ownable,
+        Owned, //
+    },
     uaccess::UserSliceReader, //
 };
 use core::{
@@ -89,7 +93,7 @@ pub trait Sealed {}
 /// Marker trait for the kinds of a [`Page`].
 ///
 /// A page kind describes what is known about a `struct page`, and thereby what a [`Page`] of that
-/// kind can be used for. See [`Base`] and [`RefCounted`].
+/// kind can be used for. See [`Base`], [`RefCounted`] and [`Exclusive`].
 ///
 /// A [`Page`] of any other kind dereferences to a [`Page`] of the base kind [`Base`]. The
 /// purpose of the dereference is coercion: a reference to a page of any kind can be passed to code
@@ -134,6 +138,7 @@ impl PageKind for RefCounted {}
 ///
 /// - `Page<Base>` is a page for which nothing is known beyond its validity.
 /// - `Page<RefCounted>`, or just `Page`, is a page that is managed by the page reference count.
+/// - `Page<Exclusive>` is a uniquely owned page whose data follows standard Rust aliasing rules.
 ///
 /// Operations that are valid for any page are available for all page kinds. All other page kinds
 /// dereference to [`Page<Base>`], so that a reference to a page of any kind coerces to a
@@ -429,3 +434,90 @@ unsafe fn dec_ref(obj: NonNull<Self>) {
 // SAFETY: All instances of `Page` are reference counted, so a `&Page` proves that the refcount is
 // non-zero and it is okay to obtain an `ARef<Page>` from it.
 unsafe impl AlwaysRefCounted for Page {}
+
+/// A [`PageKind`] for a page whose data area follows standard Rust aliasing rules.
+///
+/// A [`Page<Exclusive>`] is accessed through an owning [`Owned<Page<Exclusive>>`]. It has the same
+/// usage constraints as other Rust types. Thus, it cannot be mapped to user space or shared with
+/// devices. This makes it safe to reference the contents of the page while the page is mapped in
+/// kernel space.
+///
+/// A [`Page<Exclusive>`] is backed by a frozen page. The reference count of a frozen page is zero,
+/// and references to it cannot be taken. Thus, the exclusive ownership of the page is upheld by
+/// the kernel, and not only by the Rust type system.
+///
+/// # Invariants
+///
+/// For a [`Page<Exclusive>`]:
+///
+/// - The page is an order 0 frozen page: it was allocated with `alloc_frozen_pages()`, and its
+///   reference count is zero for as long as the [`Page<Exclusive>`] exists.
+/// - The page is owned by a unique [`Owned<Page<Exclusive>>`]. No references to the page exist
+///   together with the [`Owned<Page<Exclusive>>`], other than the ones borrowed from it.
+/// - The data of the page is accessed only through references to the [`Page<Exclusive>`],
+///   including the [`Page<Base>`] references it dereferences to.
+/// - Safe code reads the data of the page only through a shared reference, and writes it only
+///   through a mutable reference. The unsafe raw accessors of [`Page`] can write through a shared
+///   reference, their callers are required to rule out races with all other accesses.
+pub struct Exclusive;
+
+impl private::Sealed for Exclusive {}
+impl PageKind for Exclusive {}
+
+impl Deref for Page<Exclusive> {
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
+impl Page<Exclusive> {
+    /// Allocates a new exclusive page.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// use kernel::page::Page;
+    ///
+    /// let page = Page::alloc_exclusive(GFP_KERNEL | __GFP_ZERO)?;
+    /// # Ok::<(), kernel::alloc::AllocError>(())
+    /// ```
+    #[inline]
+    pub fn alloc_exclusive(flags: Flags) -> Result<Owned<Self>, AllocError> {
+        // SAFETY: Depending on the value of `gfp_flags`, this call may sleep. Other than that, it
+        // is always safe to call this method.
+        let page = unsafe { bindings::alloc_frozen_pages(flags.as_raw(), 0) };
+        let page = NonNull::new(page).ok_or(AllocError)?;
+
+        // INVARIANT: The page was just allocated with `alloc_frozen_pages()`, so it is frozen, we
+        // own it, and its data is only accessible through the returned `Owned<Page<Exclusive>>`.
+        // SAFETY:
+        // - We just successfully allocated the page, so `page` points to a valid `struct page`.
+        //   Since `Page` is transparent over `struct page`, we can cast the pointer directly.
+        // - The page was just allocated, so no other `Owned` exists for it.
+        // - A `struct page` is never moved, so the page is pinned.
+        // - `Page<Exclusive>` allows no other references to exist together with the `Owned`, and
+        //   none exist, as the page is newly allocated and references cannot be taken to a frozen
+        //   page. Thus, it is sound to hand out `&Page<Exclusive>` and
+        //   `Pin<&mut Page<Exclusive>>`.
+        // - Pages have no logic that relies on them staying on a given thread or on them not being
+        //   accessed concurrently.
+        Ok(unsafe { Owned::from_raw(page.cast()) })
+    }
+}
+
+impl Ownable for Page<Exclusive> {
+    #[inline]
+    unsafe fn release(this: NonNull<Self>) {
+        // SAFETY: By the function safety requirements, we have exclusive ownership of the page, and
+        // by the type invariant the page is an order 0 frozen page, so we can free it with
+        // `free_frozen_pages()`. Since `Page` is transparent over `struct page`, we can cast the
+        // pointer directly.
+        unsafe { bindings::free_frozen_pages(this.cast().as_ptr(), 0) };
+    }
+}

-- 
2.54.0




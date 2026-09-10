Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 947CFC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 09:01:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAE606B0092; Thu, 10 Sep 2026 05:01:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A86486B0093; Thu, 10 Sep 2026 05:01:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99C236B0095; Thu, 10 Sep 2026 05:01:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 711986B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:01:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B267FA4C61
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:01:03 +0000 (UTC)
X-FDA: 85197258006.28.AB1939C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id DA6534000A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:01:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M3BerBbv;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789030862;
	b=0CQUKsu5pl8Wx1zROZGd1shFT3oRNTbL47Bih96utEDmxYt6yga6r84XZjhtpF4phlXt8C
	WoozR9zn9695wOIr4q8AumHCeAXm+z9UuxIlOuFKhshAe/Qhq5kF4CZe/krGne2voFeAg5
	2HSVlwTcfr5ibIa7Oo7TKuDqBaGGw48=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M3BerBbv;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789030862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wg/k9xgyZfA9ou1Djuuw6WTAhRSTMUQxS2X1MvSzmrw=;
	b=JRQxWUq38tNml4xB7YTwo9j434cR09bnYu1Op8iDhB8vIS0wDtLetj4KohGbGLRCA60eVa
	StkxBsTmirUY/aYgSwFrS3R64FGW9RrI7bDK32KVwjyBWylK4q4gqx52knCzv0WTnvoSvm
	4KWTM9wqy6UTjeNVU5CmQgkFLmIYaTI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ACB3D4367E;
	Thu, 10 Sep 2026 09:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B481F00893;
	Thu, 10 Sep 2026 09:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789030860;
	bh=Wg/k9xgyZfA9ou1Djuuw6WTAhRSTMUQxS2X1MvSzmrw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=M3BerBbvMzXCbqj1EM09oZC1x/XqtdFtYXby2y7p5INcP1rT/onE38lD3s9fbAPt1
	 dTM3owMdOb51VKsqIS7ZY4Jwd+kmExADj4SdFBpqtRitNVsuPob0zCPz/YCbvq/NWg
	 bKEUVq61CO36E7mG2RaRdMSHyjZ7cCks9P0bE1iIUh50r0w6bwX3IzKb2uL/bCD0J0
	 XCJ+26ItEf7z37CManyUaT30zxZl0HKA6kD+wNWZ99EgI8FR8q7xtGE26//BdQyFY5
	 r/Vf5yfq3gWNKI5fBzX4eKcDmkrgIXN0SXzDQwGZVe6/iwbjS5wVgAkLQVgjI7Wj+N
	 34OcU8MdNduOw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 10 Sep 2026 11:00:13 +0200
Subject: [PATCH v21 9/9] rust: page: add `ExclusivePage` for race-free page
 access
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-unique-ref-v21-9-e83257373062@kernel.org>
References: <20260910-unique-ref-v21-0-e83257373062@kernel.org>
In-Reply-To: <20260910-unique-ref-v21-0-e83257373062@kernel.org>
To: Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Lyude Paul <lyude@redhat.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 =?utf-8?q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, 
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
 Carlos Llamas <cmllamas@google.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Dave Ertman <david.m.ertman@intel.com>, Leon Romanovsky <leon@kernel.org>, 
 Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Igor Korotin <igor.korotin@linux.dev>, Viresh Kumar <vireshk@kernel.org>, 
 Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, 
 Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
 Michal Wilczynski <m.wilczynski@samsung.com>, Ira Weiny <iweiny@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Ira Weiny <iweiny@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, 
 Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 driver-core@lists.linux.dev, linux-block@vger.kernel.org, 
 linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linux-fsdevel@vger.kernel.org, linux-pm@vger.kernel.org, 
 linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org, 
 linux-usb@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4137; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=mGjHroTCuk5mK+JJ+qPXVN3JjYkyaG93c58j6hdhhAw=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqonGpjFpIGLMETXkqUNOBWFFizecM/26XuOncT
 XS44dh5H5CJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaqJxqQAKCRD6UCkIqsW9
 0LrMEACOm8qftJlk0GIO4ABiC6zoPZAx2wOPesrHLpI3yWQgcGB9ibsYkXK02yOfxuQMd5U1XEy
 kbzCsSAVhUUTuRLhFIUTEOpjgX/MXvSnmXJxnZogRyVBym3A6Je6rXWsgU4Je3qDsRWaz7kFXUk
 R1drGj+gxmakDZaVaxEoWBkzuRr7ZvwKHWUIJxhzkDb5psCDVvZOY6A1xcTwC5rate+r3NPo516
 +iVFq6MqVlAcHnwGGMGsCkBBUt9aWLt/Hiunh84LwSYOTzrIDtFEQoSr450gCDwK9FTjmcpoHXj
 94+1SOEu5P9+U2V3aRAQYVVOJAL5tAaLDeLcLNvP9OY9Z9iZmx9BOHShqepoaOf/E+sG3s5hDgB
 dwqZVd5fHyf0EuSdKGM/fNhQiRwPJ4aAL7pONHTSNWJTYRIT4dmS5Zspd9WlBHs0KP64c5Jbee5
 wmnyR4QPIDeyzzTkw9d7GDN+Dg4409ufq3emr5PX6XMRdxHiScv1MJ5x6fLF62b+xZZtP04ahI/
 UJPJHdQKHsuZoK1JYSiGqLBv01CXdiSuV3oDAlLBqcSBCdj3jmNlD3RyWwimRU3WsP3JyBSMSla
 2VTyzkCqWTXDpUa5HncvNKHmXLW4Hb/YlycVtlU1KkGP0vZIYslkDWvSezPQAc2SODRqlPkf8uz
 cvfoyXcSbtziopA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DA6534000A
X-Rspam-User: 
X-Stat-Signature: 1eub694b3iqzixndyg46gfm89rquauti
X-HE-Tag: 1789030861-585348
X-HE-Meta: U2FsdGVkX1+UWUIZ0kXAuFlBusLD8aP1LBBunNhWVRIXQjXu2SLWvn+ms0nJYL61ic+MKiH+kYxGj+e80FCyiojN2vR+wgoTu3zZ8jv8FaIGb286W3+fB8SDX4pvmc1o11moLIqaoLtXDtjkLguDoM0dwRS3pGMsvMaPXPBiWTbFUJcEllrfeayxFjJiuBHprwf0vAYYACXjHON19qbUU4/hTreB3dncJgf91ONzgbQLcP5Qu+JfOfbv7OMshSsL1TKQQ+H6Cx4E1I61A+I2dkw4gS67yg10h7JP5N/sXHQJHh96gtnLIrvkh+0LRUUJgK27KsEuoDPPy9Cpe+7KFEN1I4QqsxnHpH25KTJVeeEXwMjqmocw4L29f2tx1H/0lcsRLMgnDj993gT3102XYB+qZ7zqRh73D+7VoNQ4JXh12aorQmm5B1mybLvh72/GGCGtvbCs8iZh5uHpdIMzZ6o4xLt339RcYORxNXEBThPt8SSEFmOl1jRl+3FbBr3PuDqwLw1ID9QcToVXKnYbeviOl/c3NVJhtJUs8TxTAx9rFxHnHEiKHYfYRIrUO1ijWDuugOH9sny+j4TpLnPZV8PvE+q8PM1KD5aQdpMVYu1wqXxw5W+W7G9m5Vusr9GelrfAkGk5314abyqG6ZcGTZoyQe927ZCzsmEwXGSf9wiCvCwBjwNwhDx1e2nfyNM3MKBl/lWw9s+WkTOLCb50Q19Uogfns/Y3aC1ZRMaKZSNdwrrkYuhqbEZ5Cn3IBXgYquOgcnoGAXMTEDcKCxW2qGlUBFDhEODwbuduf62QGJ+Mb5emp6enSoN9r1E3aojXXRFAkGX837WoTULT+bXxy6mNvnIP7Sz1KLUROrBsCeUAL2AABYgI1dLVwkPbk6ZYKFFu0IUGjERpHJn+BF4mbTx+BxQ6Ko05meQKvmlN/Rv4pG9vcldg8ay09pWMSR50zdJY20GvrG6R94w+6jY
 DG+wFU2e
 Q5WfNGa0KVjFfBKu+08lqputLwnMmMZi1gLkSHzQ/ms7q7/fXObzpioirtBbRqowUZdwqWxpI+NJxo9t5CXIJlEeC9gztNej7qPSAcRVO6vnzS4dJllYFcUyk2UaukgTbQG8Ryh+gYArnSsIcNQk3m5rdJ6R7wr4koU+yxHgIsFBt42HXWHR6PVobNvComSN/vda1+wZc7MkCYeS7gH0J0bV8ZP3YPHd/9ytZ0MUDXHL7R8t7ImC/7xbJJHBbhcGrvLknrhmQ2XXuKEhaQ668klYArk293WyxPMGk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

`ExclusivePage` wraps a regular page but adds an invariant that the
page data area does not incur data races. This means `ExclusivePage`
cannot be mapped to user space or shared with devices, and it
becomes simpler to directly reference the contents of the page.

Since `Page` implements `AlwaysRefCounted`, handing out a `&Page`
from an `ExclusivePage` would allow safe code to obtain an
`ARef<Page>` to the page and break the aliasing invariant of
`ExclusivePage`. Thus, do not implement `Deref<Target = Page>` for
`ExclusivePage`.

Assisted-by: LLM
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

---

This patch was previously submitted as part of a different series, see link
below. It is included in this series to provide an example user of `Owned`.

Link: https://lore.kernel.org/r/20260605-page-additions-v2-1-03f04c8fdbbf@kernel.org
---
 rust/kernel/page.rs | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index cd394b0656c0..4e5b1c2f4346 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -17,7 +17,11 @@
         AlwaysRefCounted,
         RefCounted, //
     },
-    types::Opaque,
+    types::{
+        Opaque,
+        Ownable,
+        Owned, //
+    },
     uaccess::UserSliceReader, //
 };
 use core::ptr::{
@@ -349,3 +353,52 @@ unsafe fn dec_ref(obj: NonNull<Self>) {
 // SAFETY: We do not implement `Ownable`, thus it is okay to obtain an `ARef<Page>` from a
 // `&Page`.
 unsafe impl AlwaysRefCounted for Page {}
+
+/// A page whose data area follows standard Rust aliasing rules.
+///
+/// [`ExclusivePage`] has the same usage constraints as other Rust types. Thus, it cannot be mapped
+/// to user space or shared with devices. This makes it safe to reference the contents of the page
+/// while the page is mapped in kernel space.
+///
+/// Note: [`ExclusivePage`] does not provide access to the underlying [`Page`]. Handing out a
+/// `&Page` would allow safe code to obtain an [`ARef<Page>`] to the page, which would violate the
+/// invariants of `ExclusivePage`.
+///
+/// # Invariants
+///
+/// The data of this page is accessed only through references to [`ExclusivePage`]. While a shared
+/// reference to a [`ExclusivePage`] exists, there are no writes to its data. While an exclusive
+/// reference exists, there are no other reads or writes of its data.
+#[repr(transparent)]
+pub struct ExclusivePage(Page);
+
+impl ExclusivePage {
+    /// Allocates a new `ExclusivePage`.
+    pub fn alloc_page(flags: Flags) -> Result<Owned<Self>, AllocError> {
+        // SAFETY: Depending on the value of `gfp_flags`, this call may sleep. Other than that, it
+        // is always safe to call this method.
+        let page = unsafe { bindings::alloc_pages(flags.as_raw(), 0) };
+        let page = NonNull::new(page).ok_or(AllocError)?;
+
+        // INVARIANT: The page was just allocated, so its data is only accessible through the
+        // returned `Owned<ExclusivePage>`.
+        // SAFETY:
+        //  - We just successfully allocated a page, so we hold the only reference to it, and we can
+        //    transfer that exclusive ownership to the new `Owned<ExclusivePage>`. Since
+        //    `ExclusivePage`
+        //    is transparent over `Page`, we can cast the pointer directly.
+        //  - The page is never moved out of its allocation, so we can treat it as pinned.
+        Ok(unsafe { Owned::from_raw(page.cast()) })
+    }
+}
+
+impl Ownable for ExclusivePage {
+    #[inline]
+    unsafe fn release(this: NonNull<Self>) {
+        // SAFETY: By the function safety requirements, we have exclusive ownership of the page, and
+        // by the type invariant no other references to it exist, so we relinquish the last
+        // reference count and the page is freed. Since `ExclusivePage` is transparent over `Page`,
+        // we can cast the pointer directly.
+        unsafe { bindings::put_page(this.cast().as_ptr()) };
+    }
+}

-- 
2.51.2




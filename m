Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75169E9B24E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 11:20:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4CD06B009F; Tue, 24 Feb 2026 06:20:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D18596B00A1; Tue, 24 Feb 2026 06:20:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C44926B00A2; Tue, 24 Feb 2026 06:20:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B09E36B009F
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:20:36 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 785C01B6B0C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:20:36 +0000 (UTC)
X-FDA: 84479107272.03.5B97E00
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id C57631C000D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:20:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=diiRtWQG;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771932034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tK9GGgmsRqfAwiLiRhxhhEamHoPIO4YXEiTVR7LJRbk=;
	b=EC//Xt0NBtCq2Zp4mD7fOM2wLRpvy0zAqx3OWvN5nGl2v/lzblWGEexhuYx7hxLpkIDXbk
	KFiYesjP2Ku7ZoiKJaIwXRR6TcUiAizvlL2VQVbYHF8m5OUBGzus4b3H4LK2wLhT/J2+Zc
	QELOHx2ici5fWU1FTaPo8h/8vfj8Nc4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=diiRtWQG;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771932034; a=rsa-sha256;
	cv=none;
	b=3aQRVvj9u6qeKRrIPP1W6Ce5r2rZOCF2caB2RB31GFkXQFrtrPKtx1aCdoFw/dnwc78oCG
	2hKt98MWeRf8Yvce0cLZ7TP9632W8CVwxDnVwHNm3p//bVLsmknX1suqm0rYMAipt3GwPd
	i9d59WKVgzLabk+UNR520K79uc7O0lI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5268A6132D;
	Tue, 24 Feb 2026 11:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCD5C116D0;
	Tue, 24 Feb 2026 11:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771932034;
	bh=8blkgRGad5yywyXctIGzlJVTqzYWum47B0ORZDHUOHs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=diiRtWQGbNsdc0h1Enpi/pVNcSAaCWR19qvAIJoesAE0mu5EUaR8gi6E2meijCd3l
	 97m65gcugi/MEpeLuoE/El+ebtQwyFcqdyp15jnsHJkkBIDPu1Kgk4LkUufqBenC1c
	 UR3PJJ+hys5NdZ2nbMk43WX7u9weWHc2W4hh20fReiF4KkuRcqpf232RVYMMUpfBOT
	 sufS5qXIN0A3yfDCqynIeneINu4gSc2NH6Xbl3ER2z7OAPwIkka8a27jugFup+0bRf
	 MOW4Xg3d4YH05H0TJJ4S2hVRhnqjSVnOV3XT3525keF7NACqpz7ed4h4T18APxCRpI
	 sB5T08oMsNdpQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 24 Feb 2026 12:18:03 +0100
Subject: [PATCH v16 08/10] rust: page: convert to `Ownable`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260224-unique-ref-v16-8-c21afcb118d3@kernel.org>
References: <20260224-unique-ref-v16-0-c21afcb118d3@kernel.org>
In-Reply-To: <20260224-unique-ref-v16-0-c21afcb118d3@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 Serge Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Igor Korotin <igor.korotin.linux@gmail.com>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
 Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
 Uladzislau Rezki <urezki@gmail.com>, Boqun Feng <boqun@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, 
 Asahi Lina <lina+kernel@asahilina.net>, 
 Asahi Lina <lina+kernel@asahilina.net>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4409; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=7QArePJ/pjN7cnWoG0Oe4tA+Fg7KV4ZTWL57uMIfL+M=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpnYj6lI/S2fx31p6OdqYp54cwV/ZbM95Hj1Ip+
 BqHsBArEFuJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZ2I+gAKCRDhuBo+eShj
 d+jAEADCyxHHAeQ9w9chDL5by1fVQ/N2FPpmL6SwLswTZkGUfXNDnAk/H82ilVO62oy5hZ8KaRu
 OsXJgrKn/02LDtIGs2dErMz/Xm62Qw5RikfQFgd9ILpgPHQVjUd0Ca+NiFC0tMiwf1M3TzX10oy
 2yJ9a35fdQZVecuk8gGwNztfDXC23g11XjYUzukzr8/UWRzywluZ14HPZn9o6W5mhLO1LYimTiH
 VlMKHqHyUtOyQ6p4LP/hQInN6A7D47XFx6TIgiMk7ZVKHIQJQQY/ViRDDdrAeAKPp1gZo+xW/Xl
 4bOBdBlhIm48CYKt1te/GksCvwE2aAcqV8I5r9hMUrrkDYNxK7UEYiKWGPsQ53aALJMQJSA5XDi
 GxVnZA+oOSsx9RzjngNovD1jQjVKTOGiL86/RdGb4XjSoqtZBX949dgVrJgW8bWMUvo9a3r5uy+
 ldnSR7x9fOoPEo2o1Cge0zxUDTim5d/ze7bCnukyq16eD+03/qtca55aDF45XNeEjR6hpoqERA7
 9JRoT/7cP19VcrIwkeZZwE6R8oqhoQUcNdxjMVkbxpWASF76Ml63W3g58rOQphacvZGhixvI2tO
 gwE7QuRGxSCGpSYFerpnwT0LxJnhUo+JtZUCQR7AlZC7pGrkFNCOJChGHYLZQfCP/45/0U7y8AC
 OtZo8io7bnV4TnQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C57631C000D
X-Stat-Signature: iqepcbjy8rchtj8satfskbkaemocppkf
X-HE-Tag: 1771932034-657714
X-HE-Meta: U2FsdGVkX19m15yOadVG+hPRgu2tw+UsfKV+01MnkxoeaNsih9MjArb+YWsGJWv6DDf4nghZwAXFcPM+hOS79DDFXkscgM+7qOP0JzBjdlBWm+LvoyHPOpw8unI9nXEZM9scwaE9EDwM/fn0LnmX4cKLsFuAWRdoenl+25Q79NIJQxHk5mpZ6Ifu5pMYthCoJOn7ROyFF3qa8bmKAzm9mFZASYmMNR54s/oVN/4v1GgCZpb5N233+cRklXqXh/JXAcT3M3QSwZ5VjAzC/2hT97Dh84GtCC+haXyzfy3qoqyZ1Qx3ZZW3ULgcLLVI+qkR34QHj9Wh0oxWiRXHx4R24oEwIeGSPtr8j/dgexSVeI/1VeBwNONw9BOfqk46e7SkJg769cpxzLMnSo9QDYPRb52vTOuoGUpjJVlBnlMsqhTHxtQwsIsYZ/aL6Xfvxm6FYTp6YMhp3qAgtNyG7MrH4hMg831MTKlyWKMiYBKRRikm9u8uDNdeFU0KfaROw/3nNvJ0KXoNy2+SS8TRhfmHJhIGqsnCw9kH/v3K5FzCdz8yA7jbQ0c8PlzzuA5Vt9badebpiXNu9sJ+yWB22G5woHyOoapPeHDrMiV7SsmjjqXoxdyzLPpXObG5PrCthqF2X3oX3mzialNix3ov4aerZjV1Yz/1Nb23UpCpZ6a3bYBcL/E5xdT/qLo6jnskiRGVX2hDZjm2qOu4Ij5W/AXpwyV/4n7li3YrVIpM4nYwF4cMYrtkqsS/CQTmRHSYhDxwKjqkYmmaTJmRQLipnqgYJuU3Ru1Rwu4T0Qh2y7mvDUrCAtVA5gbzDBuJhh83rB0msxavUCXf0QFM86QySJMOUDXsvU6vGc0Do6rtagDXPx2sZqkJooZnFgGRoMRGg5wKWzliRrGOJl9bXtiMLZ+vV45qW9PbF0s/u+gNUfnyDongq2Hw1zr8O3HqDPXLba5BlnacsFLkJML6enZGmeV
 wQKKnhRn
 +h8POqi/FdqttYZvfuvZpaYop+OAdVYl08UhI991oX/jy/n8bFMhE2xBAW/+gvHiVDjusq7yYgr5t/AI/jGPTu7uQJdSkUen/WQYGG4ZnjqvunJn6aizUQyLrcPSA5kY+6iRd1Zy/PucBDaD2xRgOUGietqp68AY2kgLrTCIGnzJ7uw33VWrRDJTvKakaEqLthVybqrK+e5k9ve4jCAWvaUdjRZaew3GmJIF6xV2rqNx2WsMemIG/AhAcaA5yFqTyCeYlikIKkqORvU8YAG1g2gC4D0SXjwQIE8b14btU5Dt3U6WIoOhDMEbLiTr7tctUEmJtpJ8wd84Uoilo2jqA+ftodCueaOOqlyAnalScgFRClCyrt8+KvVjOLmT7SJuGnyzE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asahi Lina <lina+kernel@asahilina.net>

This allows Page references to be returned as borrowed references,
without necessarily owning the struct page.

Signed-off-by: Asahi Lina <lina@asahilina.net>
[ Andreas: Fix formatting and add a safety comment. ]
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/page.rs | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index bf3bed7e2d3fe..e21f02ae47b72 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -10,6 +10,11 @@
     bindings,
     error::code::*,
     error::Result,
+    types::{
+        Opaque,
+        Ownable,
+        Owned, //
+    },
     uaccess::UserSliceReader, //
 };
 use core::{
@@ -83,7 +88,7 @@ pub const fn page_align(addr: usize) -> usize {
 ///
 /// [`VBox`]: kernel::alloc::VBox
 /// [`Vmalloc`]: kernel::alloc::allocator::Vmalloc
-pub struct BorrowedPage<'a>(ManuallyDrop<Page>, PhantomData<&'a Page>);
+pub struct BorrowedPage<'a>(ManuallyDrop<NonNull<Page>>, PhantomData<&'a Page>);
 
 impl<'a> BorrowedPage<'a> {
     /// Constructs a [`BorrowedPage`] from a raw pointer to a `struct page`.
@@ -93,7 +98,9 @@ impl<'a> BorrowedPage<'a> {
     /// - `ptr` must point to a valid `bindings::page`.
     /// - `ptr` must remain valid for the entire lifetime `'a`.
     pub unsafe fn from_raw(ptr: NonNull<bindings::page>) -> Self {
-        let page = Page { page: ptr };
+        let page: NonNull<Page> =
+            // SAFETY: By function safety requirements `ptr` is non null.
+            unsafe { NonNull::new_unchecked(ptr.as_ptr().cast()) };
 
         // INVARIANT: The safety requirements guarantee that `ptr` is valid for the entire lifetime
         // `'a`.
@@ -105,7 +112,8 @@ impl<'a> Deref for BorrowedPage<'a> {
     type Target = Page;
 
     fn deref(&self) -> &Self::Target {
-        &self.0
+        // SAFETY: By type invariant `self.0` is convertible to a reference for `'a`.
+        unsafe { self.0.as_ref() }
     }
 }
 
@@ -126,8 +134,9 @@ pub trait AsPageIter {
 /// # Invariants
 ///
 /// The pointer is valid, and has ownership over the page.
+#[repr(transparent)]
 pub struct Page {
-    page: NonNull<bindings::page>,
+    page: Opaque<bindings::page>,
 }
 
 // SAFETY: Pages have no logic that relies on them staying on a given thread, so moving them across
@@ -161,19 +170,20 @@ impl Page {
     /// # Ok::<(), kernel::alloc::AllocError>(())
     /// ```
     #[inline]
-    pub fn alloc_page(flags: Flags) -> Result<Self, AllocError> {
+    pub fn alloc_page(flags: Flags) -> Result<Owned<Self>, AllocError> {
         // SAFETY: Depending on the value of `gfp_flags`, this call may sleep. Other than that, it
         // is always safe to call this method.
         let page = unsafe { bindings::alloc_pages(flags.as_raw(), 0) };
         let page = NonNull::new(page).ok_or(AllocError)?;
-        // INVARIANT: We just successfully allocated a page, so we now have ownership of the newly
-        // allocated page. We transfer that ownership to the new `Page` object.
-        Ok(Self { page })
+        // SAFETY: We just successfully allocated a page, so we now have ownership of the newly
+        // allocated page. We transfer that ownership to the new `Owned<Page>` object.
+        // Since `Page` is transparent, we can cast the pointer directly.
+        Ok(unsafe { Owned::from_raw(page.cast()) })
     }
 
     /// Returns a raw pointer to the page.
     pub fn as_ptr(&self) -> *mut bindings::page {
-        self.page.as_ptr()
+        Opaque::cast_into(&self.page)
     }
 
     /// Get the node id containing this page.
@@ -348,10 +358,12 @@ pub unsafe fn copy_from_user_slice_raw(
     }
 }
 
-impl Drop for Page {
+impl Ownable for Page {
     #[inline]
-    fn drop(&mut self) {
-        // SAFETY: By the type invariants, we have ownership of the page and can free it.
-        unsafe { bindings::__free_pages(self.page.as_ptr(), 0) };
+    unsafe fn release(&mut self) {
+        let ptr: *mut Self = self;
+        // SAFETY: By the function safety requirements, we have ownership of the page and can free
+        // it. Since Page is transparent, we can cast the raw pointer directly.
+        unsafe { bindings::__free_pages(ptr.cast(), 0) };
     }
 }

-- 
2.51.2




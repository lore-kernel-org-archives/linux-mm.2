Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08894E9537B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 11:57:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 593C06B00A0; Wed,  4 Feb 2026 06:57:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54A656B00A1; Wed,  4 Feb 2026 06:57:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46A146B00A2; Wed,  4 Feb 2026 06:57:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 33B4F6B00A0
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:57:50 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D5B395240A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:57:49 +0000 (UTC)
X-FDA: 84406625058.25.7E36EA9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2605740008
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:57:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Itkw+GCN;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770206268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tb8JW9JPEachGIm2llkrEDVUyBAPphq8yqh+qpyCAKg=;
	b=UBg/XcWKX/GJ6EhN5EIemxCcH2iZWqb8yQ2nIveXkJk08CPUD5ePvImZ2CMyNzp3jK/GN8
	dQg1Y44NtqOlnPw+pWS2wnLvwyTRac3kOWZhkXtwvRH/25H17za4UTcXEfrwWQyCKcSncS
	s6F4keV94cA/p8PYet1iwhFVsCmgluM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770206268; a=rsa-sha256;
	cv=none;
	b=uUN2dwocP+b1lhvdRsQFEXI9mjVM/WVnvOy6Ni5Ro7pz9y7Njws/88yM/ox4ouzAVmcnV5
	KWKKfzluC1UA88bT1qm6cG5l7jAF/lbPE9Q0iHVp15NlTU00AcNv2YQ3m6r2ilklcZioFs
	sqD9Ou+x2l207BDFoBy8Uv2rxuWfVm0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Itkw+GCN;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 47425437CB;
	Wed,  4 Feb 2026 11:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E66C4AF0E;
	Wed,  4 Feb 2026 11:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770206267;
	bh=xYW/EeCkC7WedEcSi5MqPHN0tL67nyGJDfMj502jbkc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Itkw+GCNuRyDWXobTgUJcS0pi6d1d1IBIwP+ooRlXy0f3+lPDetjhnmjZeS9VJgHt
	 r0yLrn7GditsJD2Tm1N1gbCQN9s+9IUvKv+et91wsaWYk3qwciisdi/+iCDbxHrROQ
	 wiNXxV37ZbzioI73sfI7hl2MbwGmKU+oxHIVm/pl4lah4z2qmWPuRA0KZ1Lp1sqJnr
	 E4BMpjqZqXsjZHvQiO/iq/7sEudkcmLBqaFL2tsdS7WyAEjlPz/Uw9ze+TegewBRRe
	 RhJYceIJMBvayhDJ6sZrJ2AzSrWAH0c5De27h1++JVNt20VygfPsTBEoN6/Uz5WkaD
	 lqBWsvmAuVsKw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 04 Feb 2026 12:56:52 +0100
Subject: [PATCH v14 8/9] rust: implement `ForeignOwnable` for `Owned`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260204-unique-ref-v14-8-17cb29ebacbb@kernel.org>
References: <20260204-unique-ref-v14-0-17cb29ebacbb@kernel.org>
In-Reply-To: <20260204-unique-ref-v14-0-17cb29ebacbb@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
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
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2835; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=xYW/EeCkC7WedEcSi5MqPHN0tL67nyGJDfMj502jbkc=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpgzQFB4UxUyi+TEbDKWq5K/ySzEfM5XJVGiPel
 DNbl61aM+mJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYM0BQAKCRDhuBo+eShj
 d8QnEAC7f+kfpFQ8VLvycQ5Uf37pSzh9CYSYLkEq9ijS1CiF4hKH9X3nU3Jh81xadjC2JLKPzWO
 XhZrVS7p05z3yuXExsxLGrfdzQMdGZfmg9tz4wSK3Kqp7zkSV842fbhhHF+1Sv282MFdRUkypLM
 TtXX4NRi3xI334xjlcthZgupM0rUmr16rmKrB9ftOZ8apraAqlOLUTmq80/rC9P2cIYbZufq6Ue
 WnVWMmbo4mZaPLhlxtSg5zW7+1NveUwbbhfbUt8iWEZN3xH5F+ZAo7xV5LSyw2T2kim3dUDy07I
 Mdvgncb8HdJ35ird6WIQTOCi0uWHGsB+377g0ILl4Q2Cwd/rg5R3BhB+ssit3WwMN0wAVlqpBs2
 pkmVCrdCTGZG66fHJhioyeIl0jWzpBYEmBhwjnDwCjjiJRkqRGCUx/xm61UB/CSRV4Pj1omlZ8d
 qq4cmZhByK/hOGcEnn9GSxNaNFE4GOIrpueIw/DrBR0i3MEFbhsvzIISSq+IvHqzYgTBHNZx+IV
 dIyYk9FkYSmd/xopL6yAlO+RCfDEfdd9RIehEPoNy67J+egJGn82xW2nTOba4kLHA4p13PQeiPc
 hJm/5hN4Jk/emxqkuTYm7z0c3EHsegKGgDQz7+X5xcwk1sHkRLP3YmaH/E/6xsWw/HkG6HVV/M+
 eaj7ey+B3OL2jXw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 2605740008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: bz64yefcckm68wxxruya6szd13mg7g6e
X-HE-Tag: 1770206267-72064
X-HE-Meta: U2FsdGVkX19McoLfBTkb7kbiG+yZ3grZlxfdRiauOW87Db6wVWx1eWz1IAv7QO+PUUu+xBcKVvuFSYBat1i+3gTJQgyYufbAUAxBFBlNjV9uWb9q1GCIiGZ46+ygVLEUo04w6ZIuCQqqbQBaFmAqu7dnnHAgHUlThzlTyGR0wM1Up6mYsfeYfwjeKs2yMVSVvyT80iiOaQkcZ7i8iySwP+nfDcEsXPjyoVZxyRTgPl1wN9BLp9/adAhpi79x9FLioyxlnvrNZ0ANQp3jGXvdRi+nfKBj9jyNf/sswKmUTdsd/TE2Yn7OUiuacWMnZgwv//xZFNfO9U2tFAwWqxad5QZ7AcESxAp24FQp6ChYAN8z3tZpLKNP33qbmzSYYD8LHyxQ3miE+n6dAWytqHujQ0krAY2YmwJA7I0tiiSqh7mqkuc8ZFgYXzK1/381T5WTI2XKtyTlpdKrKwoLvX8zeGbbMtyLr0EBr2N7LuOVFph17dX10vcKLJ3Er0OAf4XGti9fQVBy22HslwCM9zbjEOikkEw7um8fT2B4RUuZbLGctt+R5mp1xseQS/K5VqZJ9Om1mHIvBz7G0WEVasAvdHNzL/N4rznnRwo6L5mhG6vU3+qUhEEiQWalj+qcOvnZd6oNoBlSv8y3+IDs81k6DuTOvwthuSKySGap+KGL9X8plUTSk4/lrdHKR+kTTMdhx1mJFjxTdYYIDzx3nDqZAg1QQkpsWqTA6N1L+YA1F5JkZDqhfgmHEF75NaF9gkf+0096vXCTpFkvUA3OGW7VfCUciIjjoyFAIflc0yr71lzZZndM/2TdqD9IknWxfkGgPH+w1uzkR74jIW+5QNuxXbZa9uUMb/m4p3n9jlqII5Y5Ys8iNyonOJfvQqz9kxSPYYb0POJ9Ub+69Hrf9sZMR3AsmLhFwbwUuIUT4BAevsmSO1ur233PJkdsZGKq6drixht2zb/4HeFB63Z43fh
 R1Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement `ForeignOwnable` for `Owned<T>`. This allows use of `Owned<T>` in
places such as the `XArray`.

Note that `T` does not need to implement `ForeignOwnable` for `Owned<T>` to
implement `ForeignOwnable`.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/owned.rs | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/owned.rs b/rust/kernel/owned.rs
index 85251c57f86c6..0b22de4aaf584 100644
--- a/rust/kernel/owned.rs
+++ b/rust/kernel/owned.rs
@@ -16,7 +16,10 @@
 };
 use kernel::{
     sync::aref::ARef,
-    types::RefCounted, //
+    types::{
+        ForeignOwnable, //
+        RefCounted,
+    }, //
 };
 
 /// Types that specify their own way of performing allocation and destruction. Typically, this trait
@@ -120,6 +123,7 @@ pub unsafe trait Ownable {
 ///
 /// - The [`Owned<T>`] has exclusive access to the instance of `T`.
 /// - The instance of `T` will stay alive at least as long as the [`Owned<T>`] is alive.
+#[repr(transparent)]
 pub struct Owned<T: Ownable> {
     ptr: NonNull<T>,
 }
@@ -201,6 +205,45 @@ fn drop(&mut self) {
     }
 }
 
+// SAFETY: We derive the pointer to `T` from a valid `T`, so the returned
+// pointer satisfy alignment requirements of `T`.
+unsafe impl<T: Ownable + 'static> ForeignOwnable for Owned<T> {
+    const FOREIGN_ALIGN: usize = core::mem::align_of::<Owned<T>>();
+
+    type Borrowed<'a> = &'a T;
+    type BorrowedMut<'a> = Pin<&'a mut T>;
+
+    fn into_foreign(self) -> *mut kernel::ffi::c_void {
+        let ptr = self.ptr.as_ptr().cast();
+        core::mem::forget(self);
+        ptr
+    }
+
+    unsafe fn from_foreign(ptr: *mut kernel::ffi::c_void) -> Self {
+        Self {
+            // SAFETY: By function safety contract, `ptr` came from
+            // `into_foreign` and cannot be null.
+            ptr: unsafe { NonNull::new_unchecked(ptr.cast()) },
+        }
+    }
+
+    unsafe fn borrow<'a>(ptr: *mut kernel::ffi::c_void) -> Self::Borrowed<'a> {
+        // SAFETY: By function safety requirements, `ptr` is valid for use as a
+        // reference for `'a`.
+        unsafe { &*ptr.cast() }
+    }
+
+    unsafe fn borrow_mut<'a>(ptr: *mut kernel::ffi::c_void) -> Self::BorrowedMut<'a> {
+        // SAFETY: By function safety requirements, `ptr` is valid for use as a
+        // unique reference for `'a`.
+        let inner = unsafe { &mut *ptr.cast() };
+
+        // SAFETY: We never move out of inner, and we do not hand out mutable
+        // references when `T: !Unpin`.
+        unsafe { Pin::new_unchecked(inner) }
+    }
+}
+
 /// A trait for objects that can be wrapped in either one of the reference types [`Owned`] and
 /// [`ARef`].
 ///

-- 
2.51.2




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86952C61CE3
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 11:19:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B3EA6B00A1; Mon, 24 Aug 2026 07:19:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 764626B00A2; Mon, 24 Aug 2026 07:19:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6535F6B00A3; Mon, 24 Aug 2026 07:19:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A2936B00A1
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:19:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C1BB91604D9
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:19:40 +0000 (UTC)
X-FDA: 85135917720.24.A5657C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id EEBA418000E
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:19:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k4gAMO5B;
	spf=pass (imf24.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787570379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FUl4cpxwoEAMk39ePpTbKQbCsCUQnhH3/2ILTsycWVk=;
	b=sLqeqIOdRUOdVAYflXbeKSYGi8yroeGWTcZrqdGcZWUJVO9dAzGWSTOI0OG6boz2Ge0e+B
	uO7CODo4HOog9ARERVVjiFcZ6r2kwvp3JTpc5XYLPfcxsAIh/CdtZoTGR9X47VAolUH8Le
	wbCIFk4eSchiaG4selkZouxKKd0Z2/0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787570379;
	b=dr9bbkSUlx5R7F7+EvmILJI5lIHjUSKKeKPcW6L8lGRlRREtHxfuWMd62Bi6wSzW70s0jD
	VpnvjXTgOEbPdhitMzh+HMzOOy0MO1MBUomC00+r5cNzNNY78cbKWXMdz1CYGWdI8lUSih
	e53Ez/qbf+6Iayfaj0d++9RvwgI5tn0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k4gAMO5B;
	spf=pass (imf24.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 51F8843B16;
	Mon, 24 Aug 2026 11:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACAD1F000E9;
	Mon, 24 Aug 2026 11:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787570378;
	bh=FUl4cpxwoEAMk39ePpTbKQbCsCUQnhH3/2ILTsycWVk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=k4gAMO5BvwRCt6he2XnMfQcxhipMLBwDNolB13eUen1E2wn7fAu3MBJqkfNdJr30p
	 KtBtxAdupxFiZDW1l3khlIZo5i166WHgK9Pn+A7sa/vSe0+LeDbm8p0/efMQ/maOqb
	 hFezxfgre2Rzvka0kHj7n6QCtLOkxvS1Bhg8inibr4T+JjjYrvDkZMTqYAfmi3k8j6
	 4oZ3KfuTIluGjYRLDL3kpp5vQXxd0TrKsfEdrDg/46DEbmuJqIMh5WqnKUbNs6hYOp
	 zCXrqyY2xBjvOlklJqNgAt31S5TnrB+Usy8srISghFadNqdqLbUUZaoejrbb6VneEk
	 HBGz5hSJfgoxA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 24 Aug 2026 13:17:55 +0200
Subject: [PATCH v20 3/8] rust: implement `ForeignOwnable` for `Owned`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260824-unique-ref-v20-3-490735672187@kernel.org>
References: <20260824-unique-ref-v20-0-490735672187@kernel.org>
In-Reply-To: <20260824-unique-ref-v20-0-490735672187@kernel.org>
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
 Ira Weiny <iweiny@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, 
 Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 driver-core@lists.linux.dev, linux-block@vger.kernel.org, 
 linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linux-fsdevel@vger.kernel.org, linux-pm@vger.kernel.org, 
 linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org, 
 linux-usb@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2774; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=2rKgaZ9YnwK1gJkiYXVWR75zXX3xU5rSz64pVhI43qg=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqjCiCraxhcJ+w4vvZV1SY4iZnHh7vyhYoBDHKn
 QKMW9sWhP+JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaowoggAKCRD6UCkIqsW9
 0B6WD/96ff4wxEK2+JhzJICtEMa7fDp5dNRnYJUPIXjrv2eWMvj/7PONFiDRsfxAKSkZRZMmnB9
 O8A0AaNhAuNv8rwfY1LPeVRWoOiCTsp1FtojPmOmZ8dURwpe5dEv+/YqdstPb2rvHEig/phd/z5
 NCWuo+l2Xrvz1UlV0ptcV1qvzkuHDDb9C4gdkt8O/or/0CzdFXUOvC7/ur8ccqxXbWjF2IbURHF
 oMHferZlysAgx2DAbuQvX83sEfBBqNF5bRU5mfV6ggL3IrKaybaJfh68KWrqtqIZilPrQvRgBap
 OWErwdXMZDQeb577fnBxvQw4QdwJmJ5yw/Wpv1USJjvFeaUoYn8NTL4nDhOIyv2k2J1f5a23npA
 PFFqRK9rTt1ZeDkkXVMwlw31/NUmu10MiiyLigWpyvfNrLfhNrDQ3QPxLtst2VmNQPIwlQgJTDi
 4lgouA4IUoJ1/4cU8GMhSBGKiZYBLOZpa7FRvBOSz7fsmYljgCaD7lv30wlzIsMNnyBs7iXj5qU
 HUf5FqukUr9Mb/8kinmk7pIsCIaUEtRk9+rP7VO7tiZAbTp5Sn7fHOELtHTTWMLaNvbvqC0tYjT
 RMDYuRxK7Mjj/sV7REuFDiPZVGd5wZseUkzphLtK8XVVo0kHdyhHjWzqqaR0WCiSV7grNLz1RdX
 m9njpTvrY5w7MyA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Stat-Signature: k1fsudpy98pz7skxmyrfoqc3r8t8xwn4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EEBA418000E
X-HE-Tag: 1787570378-479311
X-HE-Meta: U2FsdGVkX1+pbZ2ZB795UNj9+ujQ3vbA9bs98WGcOM9iJ6EiiIC7cLAVPfrj5BD8UNGRbaByJOrvg05K1ipHX0/NZgSHvNZqMT31vaXpp2Q/3Do+epuptnqx0IIIZjD6iEUNYXB0V28uRDvVY2+mGJI8NS7VzJnCjRYKqTBX02WcyqVW2M4Ntj0YscZcHr5HGoGTy7vGAX26gLVmCJvejR86VIGQ1NVHrSl6kPf5UNac5hv98gXVhdAAU0lTkIgIOqcmA/aqwTVc5wlJjh3xHGt5T1wZtrDWY+PxcsaAtAKWgorA/7on0J4P8WPjCYm8IdFKky+B1JRvoeQqQN7hT4VjnSVfPSl83R1bqYoqeEe1fSmr0LTaGf+aA9OEeBH9d1XpAJxNZSawZFw5e79BQ6mWPKDenYU4c87esxWhFNhHNja0ekdv3ZZfEdBT6D4RRw5hnhTgNDvaA5PFGWUnqr7fCZO7SzpwGYV+gyyhHPUqxjOCQH1ik+3ytErlZpEk8UpEUiZ1dY3XoN0wRPN3S0c3EkYfyYojwLdwuwzlC3QQ5ab0El+pBByA0TMfA2b0wTsp9uIEGpqQeaxYeU/M+SpZ7RCtqur6/Q2Qod1OYCWPBYZhjZUNWXHAKEyZhTLVNQGsRwLUSZrhkanDZlT2obf2sP77mvjv+x6QYKf2N1mODu99zP20FsVs0+YDZB4Tke+VfMWoeNlrSO4BTQBLK9JnI7+zeisngD8UvRzyYr+lFguJqFtmd1ZSXJuJyIckOp5CMmXRmYabZDmV0PSmgvkqA7My+CDLaGoRSUFfsLmxzJcud0fAvpvHoeb6odcqMnwrXnMY8i3QVtU1H6Z+frJGRc4zpoTu4SEbVyMV7fuz71rPbmRucOboA6NcShuup6qtMl3F/Rz2dZuVvXp75uxRqTjJCioorkjy3Gp1LQKylchHSBY6LWpxROTrxPXW500Hqyyu/3QurGbYkbE
 Vboww7Vm
 Q2en1BzPpANyxBUrd0khoJKrmijS0ws98EkXXn6OpkluTLOU8RZgyDDaDQi5MQK8ROVrtol632n/H6/ZYTmIdQFcCWfzgL2wi9JglB26G10mc8bAgcGFkYyWPAOIEQTJmQlhrBRVp2aYLbHGylqPpHgo0Gl1rZNat85yTNpX/QoWVmFaxWhLNfV5l/nT+oQkgWCI1uJqycCkHtD0Ghj4p+0e5aZzREPLNGEjvmIMLaXOpBYxkwMf8HsGtIMSR7eeSq4pEkN6f/ATaGWTTqFa2n/yyJdTvb0D9ie3yr9CAGqU29XmAEp9/k17ZD5vFyrppA/8jccOXNLNMlHXrf8S9gAw56D2QLZYFp91sFeyTB7iNucg=
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
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/kernel/owned.rs | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/rust/kernel/owned.rs b/rust/kernel/owned.rs
index 7fe9ec3e55126..93a5dfcc1e6f5 100644
--- a/rust/kernel/owned.rs
+++ b/rust/kernel/owned.rs
@@ -15,6 +15,8 @@
     ptr::NonNull, //
 };
 
+use kernel::types::ForeignOwnable;
+
 /// Types that specify their own way of performing allocation and destruction. Typically, this trait
 /// is implemented on types from the C side.
 ///
@@ -186,3 +188,51 @@ fn drop(&mut self) {
         unsafe { T::release(self.ptr) };
     }
 }
+
+// SAFETY: We derive the pointer to `T` from a valid `T`, so the returned
+// pointer satisfy alignment requirements of `T`.
+unsafe impl<T: Ownable> ForeignOwnable for Owned<T> {
+    const FOREIGN_ALIGN: usize = core::mem::align_of::<T>();
+
+    type Borrowed<'a>
+        = &'a T
+    where
+        Self: 'a;
+    type BorrowedMut<'a>
+        = Pin<&'a mut T>
+    where
+        Self: 'a;
+
+    #[inline]
+    fn into_foreign(self) -> *mut kernel::ffi::c_void {
+        Owned::into_raw(self).as_ptr().cast()
+    }
+
+    #[inline]
+    unsafe fn from_foreign(ptr: *mut kernel::ffi::c_void) -> Self {
+        // SAFETY: By function safety contract, `ptr` came from `into_foreign` and cannot be null.
+        let ptr = unsafe { NonNull::new_unchecked(ptr.cast()) };
+
+        // SAFETY: By the function safety contract, `ptr` was returned by `into_foreign`, which gave
+        // up exclusive ownership of a valid, pinned `T`; we retake that ownership here.
+        unsafe { Owned::from_raw(ptr) }
+    }
+
+    #[inline]
+    unsafe fn borrow<'a>(ptr: *mut kernel::ffi::c_void) -> Self::Borrowed<'a> {
+        // SAFETY: By function safety requirements, `ptr` is valid for use as a
+        // reference for `'a`.
+        unsafe { &*ptr.cast() }
+    }
+
+    #[inline]
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

-- 
2.51.2




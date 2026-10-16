Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ACE6CCF2C1
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 13:30:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ED946B0096; Fri, 16 Oct 2026 09:30:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C5B96B009B; Fri, 16 Oct 2026 09:30:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 400036B009F; Fri, 16 Oct 2026 09:30:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0F4C06B0096
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:30:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 98E49A0447
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 13:30:33 +0000 (UTC)
X-FDA: 85328573946.28.29B1AE4
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	by imf14.hostedemail.com (Postfix) with ESMTP id C27E9100003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 13:30:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l2YJg6fy;
	spf=pass (imf14.hostedemail.com: domain of 39SbSagkKCOgKVSMObiRVQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--aliceryhl.bounces.google.com designates 209.85.221.69 as permitted sender) smtp.mailfrom=39SbSagkKCOgKVSMObiRVQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792157431;
	b=YVIUTSK2F0rex0OxJ21XMco8bPxHj+PWR1NdAHE90MIHiK7/+MrIeF04HPGrlkUVb0Zajq
	BoLGMOOgV81HnIzk1teSzn1/eBBL4bkLunPkrIAgTZK9s4gB3W9VWEiEq0Alx/MSaW/GYZ
	e8mNz2RkdNUnXWvbe0u1aJvc5O19ZMY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l2YJg6fy;
	spf=pass (imf14.hostedemail.com: domain of 39SbSagkKCOgKVSMObiRVQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--aliceryhl.bounces.google.com designates 209.85.221.69 as permitted sender) smtp.mailfrom=39SbSagkKCOgKVSMObiRVQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792157431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rZIpAdLqjWfhWgBtyxJ71j9kLYaSyELhA3AyKnuBJJU=;
	b=327lXwr8Q+miQHyP/UmmrGt4M3AewywDvfemthG5rX/+nd7/Ge2kcOxl5lCTIeoD9otr8T
	Mu9Nikm87wGHMH2sKCx7qD4wnmAFo2Jlm+k47/Ps6MWpSagtvkLtT2z5kWn6pKy1r5yEO1
	tD+8YRAhRi4wsCqpkV44wjRC3KRbrSg=
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48b00febba3so5033614f8f.1
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792157430; x=1792762230; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rZIpAdLqjWfhWgBtyxJ71j9kLYaSyELhA3AyKnuBJJU=;
        b=l2YJg6fyS8y4myABqphKrgX38Ces6xNDjO0iOmWelZUIYg+fN5lQNP4OmXVFDYy2sx
         6Q2iwV9oKW5E3VeqaPMrphKIUGPZBA3h0Wa28GaywwKD2Biv3UxvX17UhtsATp1g6krJ
         nkWEFnLz1kAWvyWAT8ieNNEKGRqXzzxu18Z0jzXoCtVmlJlJEDJ0cubotwHsbWdSsfs1
         YUeeWWuW8B9V+ba4q8yka/+zAkqFV6i0pyE5hWUK6MGutCAmfpBf/dCYLgUsVYUfLjhS
         nA3+2FJbB15qTO6i4ktpVqziWG6lCWq5diJze0u/NwwlT5DOGNC7qHE4DSTGqxnVZRbX
         dfSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792157430; x=1792762230;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rZIpAdLqjWfhWgBtyxJ71j9kLYaSyELhA3AyKnuBJJU=;
        b=DGGHqG0pzyakC/kLj+lEtunhyt5HwTfe4/SCmvrdHy/Vb2sLdA50JtjwARXj7rdStU
         jnN8TB2peJ9+5kAakinzXCoYy3gXXec1MFX8Af113l4SOJM1BZcqzo7W/nvP5Cu4OKq+
         9Z1lrfLeckJGxdTpzlkHQMOif6FL6W/W/g2JAwgxe4unvHq/lD6Tfx45JETYMrkczeB8
         FLRDMqT5o+9MLY71sU65uogNbZtRpnNAoRBRn9OkObxwVsIcnn5ieEuZvvPVK4pxPCGq
         9z+hYIPXhunKRAUxUFETsTqycYMQFKTpEHaXSyHveCmCr0y92JT1ai9XnlGJLbuRLPg0
         thfA==
X-Forwarded-Encrypted: i=1; AKwUvBztqYPYeG/qnRI2ylXiYpfomb1wXyfsQuvG5wS8DWKFLExij2XEVoNhSJJPgtwfeNJY7Oodl5FcMg==@kvack.org
X-Gm-Message-State: AFq9FYJaePRTv8Uz/crGQ8ahXKYUSDqJIXQh643kT7PYPWJApxZY1ZEe
	IRQTMaSnljv6aNrj7DOm7gQiefwVyk1GttzOS3YDkFWTGoPaYTTwrrqPLgHlSqsA2QUYK9uwvi4
	dvaL4BGSeeJXTsEZ7eA==
X-Received: from wmom10.prod.google.com ([2002:a05:600c:460a:b0:4a1:d08f:5d06])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6384:b0:4a1:7741:ec43 with SMTP id 5b1f17b1804b1-4a18e4b8966mr419166625e9.26.1792157429802;
 Fri, 16 Oct 2026 06:30:29 -0700 (PDT)
Date: Fri, 16 Oct 2026 13:30:16 +0000
In-Reply-To: <20261016-binder-memcg-v1-0-d659b8ae088b@google.com>
Mime-Version: 1.0
References: <20261016-binder-memcg-v1-0-d659b8ae088b@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=4127; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=e7El8JVzuCckJxWrAaf3VRho7SDEP+z8OekEMMCb2Po=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBq0ibxm/pJuRR/eaxLabVg+WYFOjq8PzLjg9HGN
 Ng7jx+oXHCJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCatIm8QAKCRAEWL7uWMY5
 Rt8wD/4xV9Q8bXw1mZEz2tsam7qfZZT9L5xuUK/uWtKOZSPmrZ9L6tmK+BOCdREdBSP3X63WSiA
 JKnX7sqftIvrgPKBGh8vUyzcsXp+UEiF6ihLVo45bSVeDCyKhSBl7FKyIPNExKxAQdFDelHBe18
 n8tu7hnyH0npzscKCagq1CUJwQ/pWzrp81/wYlKVuOLHO2Vro7BePj37Kvtk9CspMezG10zZFXN
 nyCoC8Ko4gReoZ27GguonsWAWmM+iA4T3hNM6g7Fx6zwVdrISzXRrHAb49597uRD4xUltrP/Rgm
 /hfV3ydUKXoABK+qiNgXJdLgLx6Ym2s/0sG3M5x/aJm6vkmLSPyS9HppD18hnCNFXL0f3APap2x
 PXkUwa0mWKY5G1opKxqyjk4rA65T1s9lh7my0g2MCqfW7d6h0v4qpxXqnSb2fitsO0pdgKR7Ibp
 hgwB6qcwKcCvjrILG1Nf+ufsDUzI8gcLEVTwNm56SdPU1CaXMMS6+gt+AkI3tD70ghpMVFuFhF3
 jmvWPbB4MdM3HW+zNOIeFA9z0euJrjLkLBj9cPYIFcddjkQADFJbPCbBI3cAXM/LXU13UgBC82U
 slMx4quFUCar82bLqoYoGl4GJFKTJdptU5xKkLD+GYC+ukwanzPGLFQQ1SsBzSqU8HmBS+mJFpu nQ1TaHrIsOkuDEg==
X-Mailer: b4 0.14.3
Message-ID: <20261016-binder-memcg-v1-1-d659b8ae088b@google.com>
Subject: [PATCH 1/2] rust: page: add Page::alloc_page_memcg()
From: Alice Ryhl <aliceryhl@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"T.J. Mercier" <tjmercier@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	"=?utf-8?q?Onur_=C3=96zkan?=" <work@onurozkan.dev>, linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C27E9100003
X-Rspam-User: 
X-Stat-Signature: nw1xfu9ci8y1gdjesc5scipygm8c9fe9
X-HE-Tag: 1792157431-677645
X-HE-Meta: U2FsdGVkX1+KztNQauJtjYG9mQVZTHClLhcPHGF4x+Cry6Vdb6BPZhb61TIInNaCJYLh2ChK6Igs1GzCa++Src+1Le1o/23iIwQa56KOJT1fJDOnmvl/UVFEMNwm29FFDaSe7PZdLA8VJSJGk76qHhg/DFIjnwvEH8qTTZNivZFYUNiQNHiy+oqYIbS0yjp3cpPKOszin3TtcupwQNnSQ52tDzC09EddLNgA7pNEkKOmLM+ZCsK3SI9fPrltrpQ+q5rR7PBmofqT7hv3IfmzGZXT9NIk4Eu+ZlNiGptAmarcNlsFlUUI2+ApCikstD1WZw80IA2lojn8Ryf3D/05xtLbHlEFBXttSD/UTpyI75naTfhnDQ7zYJF1jOFMc62rKU9QDrkWfNFuM9s2dzoctio0WN3gYVwf+9SNQP1vNtsAPZ4NzTYV16a6qQDgseM5+ys5hwkuL+4oMseBOu811re+E0LTMNI6TAkgX0W1Yl8eMF83npSTy59EAGyUstpJUPvZgcYEDr1XYWnSmCWEbWGmBCXSH1B8mVvBfJ9ROYcUFTcLADrCYbF29bTsVXRuUVhAiaB/9+SpNBFb4RwI/IO5OWqeuo7zBbw5tk+c/ci+XtCo6+RTSPrHDP2UN1CWH3geFhBbNoPZJ2YuBqx5SgxA2OrEk41WSOM5tTtaa+B4PRcCA2WhKsGylp45NhNNYiS0RvQqM36wScfrN9c2uJ+zt2tZVy5GxPl7dJ+gfKg+Thhg3KxoQoTzSNlxrwDKstdndxI3Xuj4bCXdypfVf1J+H/l0NW4lmCay+75qHfrhou47VsqdC8XovsS9IIlZx4k4BzLwc0DhnBLw8n4so3jUEbVY5E2Sb/uDNf77iaTo0wsuOalJzunu5ig3kw5XZVVMqs3wH1TTl7z43gqTT76+MVoCB+HTeCzlVezBVWqwEWwoJmrWHuyT3YcycgrLzUNlooi2YOVbbbmEEMS
 Vcd/bIn4
 qgkKxl3dGH3lIEIBLGsssXwgPE4AA2eqt+kx1r4Q4A7mU0ubULr7o6T0TxEZM5TGTbJI76b5l7c0ys7RkzX6omrnMJHjSzllTrBmMCqkjCwF9UnCmtNqsePWrRiJ/WEB47TQ7aWNxAVqEHLcK94BJhYjC/tjeooNYANAq2FrfCwoGDVYEictfB3A8ontvupugr4bDMBCaCKfIV3Sg5iTzCZflJjMfVVZXNSMmIpHaKZ4DBwJhCk9hilmMoyRM4p9PcjMtn7TNUESNWNV0gSuYxXUGE17jgD9NYHKNtDEgPPMgb8h39JLiW9OAdrimv2dcqJ1AHbel7LcdnVuZAFcLtgf2MiyqaVluW0UuPqYiQgu941F92s2jL8P3PK1s37DfV1iJ3ElnZvarH7zjbpxQttDU4dF57xDZNv23rKsyx6OIyub/QlXYWfAM1l5sdD0TImcrDK592B4fW8JtqM8cXfjO/bzsRRNp3GJACBrhwUG2kxIlsRM6XcKo4FPfunuOkNZhGmJl4xWXSoCV3OsUxm4kaIgF5ME6ZrxqrBO2qJdzfrlb7m+PBVDvPaeeoIUdpDccvpF6J8GWRQ8KZPOp4bLgbKOztlWufUwvUNh6/ULr22LZlLJnkbZgRkQcKZOrp0hQraD8FP2NC0pv1QBbm1drv58LwcBXG4I9UBNaiEFtk53kXNYaFzM/0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pages allocated on behalf of a userspace process and mapped into its
address space should be accounted to the process's memory cgroup. Thus,
add `Page::alloc_page_memcg()` to charge newly allocated pages using
`mem_cgroup_charge()`, and switch `Page::drop()` from `__free_pages()`
to `put_page()` so that charged folios are uncharged when freed.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/helpers/page.c | 17 +++++++++++++++++
 rust/kernel/page.rs | 50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 66 insertions(+), 1 deletion(-)

diff --git a/rust/helpers/page.c b/rust/helpers/page.c
index f8463fbed2a2..145758a8a954 100644
--- a/rust/helpers/page.c
+++ b/rust/helpers/page.c
@@ -2,6 +2,7 @@
 
 #include <linux/gfp.h>
 #include <linux/highmem.h>
+#include <linux/memcontrol.h>
 #include <linux/mm.h>
 
 __rust_helper struct page *rust_helper_alloc_pages(gfp_t gfp_mask,
@@ -10,6 +11,22 @@ __rust_helper struct page *rust_helper_alloc_pages(gfp_t gfp_mask,
 	return alloc_pages(gfp_mask, order);
 }
 
+__rust_helper void rust_helper_put_page(struct page *page)
+{
+	put_page(page);
+}
+
+__rust_helper struct folio *rust_helper_page_folio(struct page *page)
+{
+	return page_folio(page);
+}
+
+__rust_helper int rust_helper_mem_cgroup_charge(struct folio *folio,
+						struct mm_struct *mm, gfp_t gfp)
+{
+	return mem_cgroup_charge(folio, mm, gfp);
+}
+
 __rust_helper void *rust_helper_kmap_local_page(struct page *page)
 {
 	return kmap_local_page(page);
diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index 1c0796ea229f..7a36b7dd6c9c 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -10,8 +10,10 @@
     bindings,
     error::{
         code::*,
+        Error,
         Result, //
     },
+    mm::Mm,
     uaccess::UserSliceReader, //
 };
 use core::{
@@ -195,6 +197,28 @@ pub fn alloc_page(flags: Flags) -> Result<Self, AllocError> {
         Ok(Self { page })
     }
 
+    /// Allocates a new page and charges it to the memory cgroup of `mm`.
+    #[inline]
+    pub fn alloc_page_memcg(flags: Flags, mm: &Mm) -> Result<Self, MemcgAllocError> {
+        let page = Self::alloc_page(flags)?;
+        // Note: Charging the folio with `mem_cgroup_charge()` only works because `Page::drop` uses
+        // `put_page()` (which uncharges the folio before freeing it) rather than `__free_pages()`.
+        //
+        // SAFETY: `page` was just allocated, so we hold the only reference to it and it is not
+        // yet charged to any memcg. `mm.as_raw()` is a valid pointer to an `mm_struct`.
+        let ret = unsafe {
+            bindings::mem_cgroup_charge(
+                bindings::page_folio(page.as_ptr()),
+                mm.as_raw(),
+                flags.as_raw(),
+            )
+        };
+        if ret != 0 {
+            return Err(MemcgAllocError::Memcg);
+        }
+        Ok(page)
+    }
+
     /// Returns a raw pointer to the page.
     pub fn as_ptr(&self) -> *mut bindings::page {
         self.page.as_ptr()
@@ -376,7 +400,31 @@ pub unsafe fn copy_from_user_slice_raw(
 impl Drop for Page {
     #[inline]
     fn drop(&mut self) {
+        // We need to use `put_page()` instead of `__free_pages()` to properly handle memcg
+        // accounting.
+        //
         // SAFETY: By the type invariants, we have ownership of the page and can free it.
-        unsafe { bindings::__free_pages(self.page.as_ptr(), 0) };
+        unsafe { bindings::put_page(self.page.as_ptr()) };
+    }
+}
+
+/// Error returned by [`Page::alloc_page_memcg`].
+#[derive(Copy, Clone, PartialEq, Eq, Debug)]
+pub enum MemcgAllocError {
+    /// Allocating the page failed.
+    Alloc,
+    /// Charging the page to the memory cgroup failed.
+    Memcg,
+}
+
+impl From<AllocError> for MemcgAllocError {
+    fn from(_: AllocError) -> Self {
+        Self::Alloc
+    }
+}
+
+impl From<MemcgAllocError> for Error {
+    fn from(_: MemcgAllocError) -> Error {
+        ENOMEM
     }
 }

-- 
2.56.0.212.g129ede20d9-goog



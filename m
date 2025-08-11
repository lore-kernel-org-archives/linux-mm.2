Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE67CC87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 12:32:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 071458E004D; Mon, 11 Aug 2025 08:32:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021A38E0045; Mon, 11 Aug 2025 08:32:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E52408E004D; Mon, 11 Aug 2025 08:32:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D40478E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:32:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 98EE61A0152
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 12:32:09 +0000 (UTC)
X-FDA: 83764413978.04.61881D7
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf25.hostedemail.com (Postfix) with ESMTP id A505AA000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 12:32:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rhS6MNtj;
	spf=pass (imf25.hostedemail.com: domain of 3xuKZaAkKCD8bmjdfszimhpphmf.dpnmjovy-nnlwbdl.psh@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3xuKZaAkKCD8bmjdfszimhpphmf.dpnmjovy-nnlwbdl.psh@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754915527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EeF3bGUOa7e9fi1mYtzUmovCQl97kCDgwj4UAdIAQzA=;
	b=vDrfqiTn/BJTL0/G8P8AK9L5RMEKz5RWqiQAawKBFuRXN7c6Abl/2M1myifqxWXJgS0Y9Q
	ELEShEl5AVxg07DU69at+wUiS3v8+DicpXyl1I74UT1f4HEj3lGt0xjNbLZw3IAwPAakuu
	2Eci2Gh+C1C+vQKFYilD5L8cYjrJIuk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754915527; a=rsa-sha256;
	cv=none;
	b=JBcslRG2mgYQENRQF8Ra+8dp69uhgXiXB8/1igIM/NPLc/3sI4L+U5mE2GnzGBGnacekz4
	v+LX6qvg0MuB6BDtAStfchpp588GvVTSh3uLl7sL3OqcjSelIR2h24/90thx1vxfDA8x9N
	Cs6tjPVkHIXhs2vwbvgdiOR5K67cZss=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rhS6MNtj;
	spf=pass (imf25.hostedemail.com: domain of 3xuKZaAkKCD8bmjdfszimhpphmf.dpnmjovy-nnlwbdl.psh@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3xuKZaAkKCD8bmjdfszimhpphmf.dpnmjovy-nnlwbdl.psh@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3b8d62a680bso2358161f8f.0
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754915526; x=1755520326; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EeF3bGUOa7e9fi1mYtzUmovCQl97kCDgwj4UAdIAQzA=;
        b=rhS6MNtjYpZZFTvDZ25kIvkh2AZUHE8DxFUQTKBKhF/bQfsUj4r3xbkJpdO1xF+OU+
         5kjZAb4VGPX0av4MGYb7HBNbkRFRbyxhzdyHDeQB+fAXt8fRYp37qBHgJb0uWk+1bVOC
         NcrFkkkerKLcED+Yv1XwnyUyExS7v0W+vCDHQc1qByl8bajQ29obGsjFdocPBh1LucDk
         r7jM93oqhxj8l50eRlBBsfOWZS67e0bA++gXTXbLZKBS5BCThjoLlcw7XJgPv1AFxsqR
         UeYBRHDyVkYqGdKTXz46U9oajMMmAHEU88pu5dmhl+7X2UWEFNS3tyPJYdzwgGipwRzj
         hoaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754915526; x=1755520326;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EeF3bGUOa7e9fi1mYtzUmovCQl97kCDgwj4UAdIAQzA=;
        b=qy6Rcu/otQcOSrsssqeME22SEzC3jbXeCSVCsTsU/0QVyUNHbTdXBRagTK9HOYdIm2
         Pr1LDRvMg4HsoDYHIUG3FbasFjwaFTFNRpnaDxwCxSZFSkUPkTnwhS+guhM1A5PW/qTS
         iAk7sMfVwL4SZaYuyyRYpdwBR8KG9q+oMyef+TjPrfeoksOn01VVzizH4wp8mqAlbFF0
         PtpNW/5fkVTdJg6lXKwrc2Y+uYpvn1TNFT0OhQN8o5fNK64q1PygeJ2I9anSPka3eiuS
         LWpTSlIhSUb81mtOF0py1mGWOB9bYuZBk565NVZBTCd5PI3Y8iZdrbNB4yliWM4sWPYk
         Ap0A==
X-Forwarded-Encrypted: i=1; AJvYcCUvKD6h8/R9TyHsNG2xKQbbAsL3waeFbYE0VR4logYbkY3QKfStispkn4yleVCm55tQl2MQKWnk4A==@kvack.org
X-Gm-Message-State: AOJu0YyyCKjBk0DVJoqv5EoqJ/6gmZr+bbRABwpgWmzSfkLCWHVA8w8a
	Ua2cATVOBTT3nUx2XirtO5bLKci22zabJAETvEgc9ZFkdZe5qmoCztITLmYcu7F7c0I0wRt3D8e
	iEyuGBM51ZViOBGVjFA==
X-Google-Smtp-Source: AGHT+IHuDZSpEk8s4TEttjba6L2NvFtGfFsONeAGvCghisyrKanTpyDc2apiIaxwNjc3et8Cs5h0CmJDe4Mrfv4=
X-Received: from wrbeh10.prod.google.com ([2002:a05:6000:410a:b0:3b7:d75e:c4a7])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:18a6:b0:3a4:f7dd:6fad with SMTP id ffacd0b85a97d-3b900fdd6femr9908384f8f.14.1754915526236;
 Mon, 11 Aug 2025 05:32:06 -0700 (PDT)
Date: Mon, 11 Aug 2025 12:31:50 +0000
In-Reply-To: <20250811-align-min-allocator-v2-0-3386cc94f4fc@google.com>
Mime-Version: 1.0
References: <20250811-align-min-allocator-v2-0-3386cc94f4fc@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=3229; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=xrRdYUi/ackTh+GxFSroXvpaNgAFYJLwSEWSCNu0Vh4=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBomeLDLapzSgRvvWowdCWxONAxAhx/5FT2Y5YJk
 gx+2bT0DGyJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaJniwwAKCRAEWL7uWMY5
 Rt1QD/9YADVnV44goF9lcDd9dHPZxmydoBRcrufELmZmXlCQlrzMOEHsw0sBYEc6FhjWrVW46vm
 Kb8ps8JkxIQFAla48r0G19xim2rb3zCBUhfFqpE31VZRkl8dDghHjNMP/hMLSWb+8E7AMH9ZlU2
 jHcDfkxJFqvQW9qHe+vAJUKx2POgZktnewhvHWUMwn4HFKg+etyqSloAV0CZ/lzm9GPTVCt7Bpv
 SsjsqBfcVoTjxXEiG/LjL20spSbiv2Uf2LcSm/zKBQMC/Y6goWtowLiBV64uRztcYQaNqdsLsQD
 L6SKhK53K18XdvSltKZaXVvyR/ckouWMtnIVneZblav0IpnoG0EibcFhzslXngg5izAVmqMaHLG
 VEBFWqRt3eCT6HXp7Y1KKhW2nj0pvEhwvgtG0fSM0UT/279tGzCSkc4Ua4VyX9Ule0Dp+lof8wV
 TD1LA0+PQWUvYMTArKetljTUSiJmoXCuUiJtlQ9U+uAWRi9qiU9sjbFDrRQ7epQw0QS45DmkkMy
 AvKsMjuMyoQKwTf3LYsXLUlzx1NqgxMOld0YahE+Zl8wmjy2mK5i7ERAIBo9mNecm/sF55tBidr
 rZEeeG+fR23ufyG4H2hvz6VhTXvpklJDtZ/cWudrSt4ho1ok4OAVPTqWq9mCEJEE4Q8I0+AxIsR WYeTU9cOEOY1jfQ==
X-Mailer: b4 0.14.2
Message-ID: <20250811-align-min-allocator-v2-1-3386cc94f4fc@google.com>
Subject: [PATCH v2 1/2] rust: alloc: specify the minimum alignment of each allocator
From: Alice Ryhl <aliceryhl@google.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Danilo Krummrich <dakr@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Tamir Duberstein <tamird@gmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Miguel Ojeda <ojeda@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: A505AA000A
X-Stat-Signature: geyqtf959iwkc5r5no9gbhmf8s7xgbju
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754915527-947060
X-HE-Meta: U2FsdGVkX19VQWlCTT4huddaXt/PrhJYKf2YQY4MY8KTFIlP37nUg/KOTax78Kbhs6R2mEedLWXYwPVRbVZOzfEQzrLAZ5sFuiW48SEumTkHQHhfKgNiM4iJLYE0NE/kHLV1RuGGRRuZlb9I4mPUChhlGUIIwdcv5xdvfloixRWzPc6a4vvrasui+LC1nG/Pp/xE2JYIvq0prAlqW2Y/VX3zLroU6R15zMwke++xqr8C97Zq1BiIkJG5uj6uNsoc2EyhlRVBIS+XrBPcTEyuiTQibT6iqKlo1qiPFrNFMAlxYYbbKcv14CmrcTuV068A0MG5ZIfogyb2xTkOZ0arRyYTrHxa56ptC7Fc8gS5fTWnSNcg5yQ1GuE+U2/x1kevyYtMmux2a597DlchncAqq3qKf43I3f4qxpCNHKaO7EeCBfWpUNI5Nx93o9iEYCkH8nqMpEkBBwfVli9sW/9zfjOzKXvblLppqfkao2dIltEIQvQvoseDKV33z+5NJg3y1Y1WQEahCk8K8E5hrxeKhVoF3E6s8SUsW2YFmMPuepFgmNS30egyqJZQwHx+VWm/cI0ljnP3zF6a0M2TIIJ/GGqINIz4rcdEzCROdy55glL6Qm+r9BYKsRLQic1uL4w0uG7QWupnx5QYkk1vKcz8SCbw5T7b2c+zObOrSdPaCXDCq8GFsd8C4PMFLbVk8CHIcHIhyM2JuFvskgB3MKwjwJsQTjTXJuxS6A6zByzTo+N1QxtSWfmahmfy0X5MD7Um+RkvuWlAHBgap8scFotTdNqvk7WCbqM6dZWy+Th+RjF5lFTauVGUiRJCrOcDYfBFNwrO630s1yCV29tbkDF1InR7NROm/hpAMZvr2jhGfdpePRj3Vki2LBbNG9dm8jkofdVnvmRV+s80AaCJgMP8zjFan36I+SNGRE+i6VWuxbYQ+n7yysSj7UbiQAkG5unlJOIjqxuNKCMZRBXadb+
 h/7fw7dv
 KM0wRqQJ4KkN1NlK+ZcCbrtCt2dVtgJK5rsFfGIWgMUWZ1H2QZKzhPDrmeORrGR4SpOZg/G20A5e2/HCNkPHP/SwAQVrWJCJoODYj4SPAryMLJSY0SggTtbueE3goSeOOmOHuJ6l0tabIhD7E1h9+5hmSLSa6JUmuhouStIlmmBXOZZ5fDBur39vyc1oletPIcnZGLqtPapxg2YYZOD9tB9Rq9HUMPzn0AIz5Qaqsp91LUCPEjcdLjNy8/XOXh2R97pDiWYP6dP4LoNiTtxAcVEUr0b6jwWW4G70XNNEXYlJ5ArmMdci99Gy1ClNdamFJ/yjC1lIeDYLMG/uwioLo40LPtcARq/KZkThnrBK86W3UMw+AMwgM0jeqQw8QUcrVjlAh06BvCP0ovbT/nlSwZFfmIPn3X+y15nZvmyo3adsCqaAmo7gP4qbVuGWJtlNPrud3RWmGtaspDUsAxW20NxU/+sXVm5j5VIQLSERvrhQ3CtydqCfkiU0mSd0qSaZG+CpgK0tz9oucYM5cK/fS60FJaqiyQnNmoNaLa3W4q9v+Frz8V2I3zE55bSISnURa8BkSBkKIBwDlXY7dV50kLYfwjJxNkWHo09gacIqEHPB/keln4MyxfK0kBJK1U+8T/NQiHE8oDV6pVeNdYMooIsKHynQN/uJeCBuj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kernel's allocators sometimes provide a higher alignment than the
end-user requested, so add a new constant on the Allocator trait to let
the allocator specify what its minimum guaranteed alignment is.

This allows the ForeignOwnable trait to provide a more accurate value of
FOREIGN_ALIGN when using a pointer type such as Box, which will be
useful with certain collections such as XArray that store its own data
in the low bits of pointers.

Reviewed-by: Benno Lossin <lossin@kernel.org>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/kernel/alloc.rs           | 8 ++++++++
 rust/kernel/alloc/allocator.rs | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/rust/kernel/alloc.rs b/rust/kernel/alloc.rs
index a2c49e5494d334bfde67328464dafcdb31052947..907301334d8c111eb26719ad89700a289e03f037 100644
--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -137,6 +137,14 @@ pub mod flags {
 /// - Implementers must ensure that all trait functions abide by the guarantees documented in the
 ///   `# Guarantees` sections.
 pub unsafe trait Allocator {
+    /// The minimum alignment satisfied by all allocations from this allocator.
+    ///
+    /// # Guarantees
+    ///
+    /// Any pointer allocated by this allocator is guaranteed to be aligned to `MIN_ALIGN` even if
+    /// the requested layout has a smaller alignment.
+    const MIN_ALIGN: usize;
+
     /// Allocate memory based on `layout` and `flags`.
     ///
     /// On success, returns a buffer represented as `NonNull<[u8]>` that satisfies the layout
diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/allocator.rs
index aa2dfa9dca4c309e5a9eafc7da6a8a9bd7b54b11..25fc9f9ae3b4e471a08d77130b374bd1397f7384 100644
--- a/rust/kernel/alloc/allocator.rs
+++ b/rust/kernel/alloc/allocator.rs
@@ -17,6 +17,8 @@
 use crate::bindings;
 use crate::pr_warn;
 
+const ARCH_KMALLOC_MINALIGN: usize = bindings::ARCH_KMALLOC_MINALIGN as usize;
+
 /// The contiguous kernel allocator.
 ///
 /// `Kmalloc` is typically used for physically contiguous allocations up to page size, but also
@@ -128,6 +130,8 @@ unsafe fn call(
 // - passing a pointer to a valid memory allocation is OK,
 // - `realloc` satisfies the guarantees, since `ReallocFunc::call` has the same.
 unsafe impl Allocator for Kmalloc {
+    const MIN_ALIGN: usize = ARCH_KMALLOC_MINALIGN;
+
     #[inline]
     unsafe fn realloc(
         ptr: Option<NonNull<u8>>,
@@ -145,6 +149,8 @@ unsafe fn realloc(
 // - passing a pointer to a valid memory allocation is OK,
 // - `realloc` satisfies the guarantees, since `ReallocFunc::call` has the same.
 unsafe impl Allocator for Vmalloc {
+    const MIN_ALIGN: usize = kernel::page::PAGE_SIZE;
+
     #[inline]
     unsafe fn realloc(
         ptr: Option<NonNull<u8>>,
@@ -169,6 +175,8 @@ unsafe fn realloc(
 // - passing a pointer to a valid memory allocation is OK,
 // - `realloc` satisfies the guarantees, since `ReallocFunc::call` has the same.
 unsafe impl Allocator for KVmalloc {
+    const MIN_ALIGN: usize = ARCH_KMALLOC_MINALIGN;
+
     #[inline]
     unsafe fn realloc(
         ptr: Option<NonNull<u8>>,

-- 
2.50.1.703.g449372360f-goog



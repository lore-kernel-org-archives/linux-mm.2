Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D650CD6E75
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 20:14:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D42776B00B1; Thu,  4 Jun 2026 16:14:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D19616B00B2; Thu,  4 Jun 2026 16:14:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2FE16B00B3; Thu,  4 Jun 2026 16:14:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B10DA6B00B1
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:14:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E9701C0A73
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:14:47 +0000 (UTC)
X-FDA: 84843333414.24.053199E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id B2E0A40016
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:14:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L1KhBYKa;
	spf=pass (imf11.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780604085;
	b=y2QsUA0OMOhUVA3ZQpjOopb4HtJBBBs+I7dr4o4qznwRjilk93Tm2P7/BzjoglbdTg32vI
	Prit8HRbvr6QqALHfRpHRP7e0u7gtNMdNRVRoEzMMmxAwQdsaocroXnN3LSCq3i8gW8CT/
	KwfSTJ/ug6GhbW/VRnCLgLn8FtSbC5k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L1KhBYKa;
	spf=pass (imf11.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780604085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hN3l3BdGf/2AYaP03yQUTPwUIONO7SBS5tD05SJ/lgU=;
	b=rFYGtT4IqLOrex916exhgodYZKx7sKFOsurHg+Cr1m1fqXuWf8FUQc2wfEH/q2c/2ijVph
	jVsB1RaHMF4EyCxkVTBALf6fVDFvE3mAkHAwdHEn0F0v2toSsSXr+CqRCC49qFsjLAVmLg
	nmhAWoGFaNGaHY8gucgarwGUPERou+I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 404EC6001A;
	Thu,  4 Jun 2026 20:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEAAD1F00893;
	Thu,  4 Jun 2026 20:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780604085;
	bh=hN3l3BdGf/2AYaP03yQUTPwUIONO7SBS5tD05SJ/lgU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=L1KhBYKardL4WLZ1hxlsOwhksTaRQTGI+GRdaf7u+5MQLYeqW4lEoJFDK5PY8udEi
	 OgD8pgWy26+xr++oM7Eas5xkaFfFQVWQF0gfnE/F5TPP3XfvNea3Mz2VTe3tTpDBeP
	 1bxU43ejnz6I/o5682xm0l7UOqZ79U5PkaIjHZv+CUzCOAngWwGH0ZvEcQGeYsQjKK
	 0F4rK27NUH9tegKW2KFdA132RgpjWZg1P1S53KoP6Z/MZy+yzc98gRrwDxVmDTiYFe
	 kDSJcR75jkiLmb+QjuR21BLBIU9xRGCNr3KPvMstFAKl8aKJzXXN6D8QTD5Zg2oVcn
	 fIEFQRiqEI/Pg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 04 Jun 2026 22:11:15 +0200
Subject: [PATCH v17 03/10] rust: implement `ForeignOwnable` for `Owned`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260604-unique-ref-v17-3-7b4c3d2930b9@kernel.org>
References: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org>
In-Reply-To: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org>
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
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
 Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 Igor Korotin <igor.korotin@linux.dev>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Boqun Feng <boqun@kernel.org>, 
 Igor Korotin <igor.korotin@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, driver-core@lists.linux.dev
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2733; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=wiR/tjsjZUc/szwoZmoCjaXgIOvvjFpABHNna2O4ox0=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqIdvojMJS3KEQLaRggiy/IympJ139LRe+De2u3
 A92SMSRv/eJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaiHb6AAKCRD6UCkIqsW9
 0EKxD/40KjICAkhQszkmSwLgDHYHvBdMURq9hW/tlw+Ez08KtTHqNDPCkZkXsfpdsApuKNQ52UY
 heVYe2Yx5rTJP9GY1T2tzh/4qCJcYe5U8yfWfpDPvYLgePHgSOnQbWO1MSJV4IDC2qfkuecSU6i
 ClrnIWqCB5Yd9DMGk36B2kktJPrDCXH+brMTD93I6IMz/2J87PsQRvQ4qubjvCa84SEGjlPd578
 KvK0wji01jfUpXS0QX8ccaXUELffUfenAKI38ilen48Wvfx28oqWGJoEDbtq/65D5iYOo+9DHMp
 GIgDlOzszni4/tUFObbPb6jT6bBa4E8O9wKm8UjQflIOdHbF8QetJbsVaDkoPOq1qcIO8LKJ003
 nl+kT+DMCM7PUpWagcDVIcAqrL4U/t7j5koXNEGeIa8UEQa2Z8aYquOZuof61j4uCgyGCzy1jZE
 7XDIK/8L+icsgpd8LLw7wUA5Amh0VcC28HvhGDK2yNUqIiMCXJuknR487j5nUawXyETew8AdwWn
 GfykSQUfGIUCawqJiakE4IQbS/kIXDbCQAdcBUxxEG/nv/4Zj2NUTuEk5Ld4CXZ1i2kkBir5Rbn
 EatZvAMk+OKzHVMWpEI4lfthHa377Jq6ytw19hLZoMHp/i2Ja1l19oLBy5I/y9Ko0JM50AxQWaj
 Gkz2Qjxyvb6xu+g==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B2E0A40016
X-Rspam-User: 
X-Stat-Signature: ma6ctsisdf9on6k33x9sr954wszeupth
X-HE-Tag: 1780604085-924984
X-HE-Meta: U2FsdGVkX1+fdKJMc7Aqh0F9LsqH6bRYWTZJ5sxe+4HevYSm9rvMYNDx79W4z6QYtFisMff5JuKoUYkTyyW6TnTC0/yIfs+cSAtNkR2DYpTrn54VGx8GBiS+3Nv9mzRx8K98ce4ApewrmRAQGQZdw157j4ERaHR9QAu340MFgZ3B8TuZexxXnRAMXhY6omI9gMH5J+x4+tDFM4RUe2RaXo115j63zfosMRHnjzQDLznso/S07CmzdABBtDqBAvx5/bSoudlyfTPBJdXVBHlduspJer5HvSdxH/dQUFLfnxNU2YxFszCghjVLQtd32a9B6Ojwy22EO9XIEiRcmAkxgUrwmehqTRGgNgTYN80zWYzsWDWyXbpbh5csB8xlxr23DquZPmky2tAAkicl4feYY/unrUT24eo83gv48iW2P+NhgoUr9P5Oy8vHKQHD+mXgg+QKFhO+2QHKaEQMuh1SKxlSmU+ftT32zv9dskLTxFdV/euOC4H2oAqkpGqOqIhsg9K7MLeGhxny3/Vpyb8IzTb5p7Zf95pU34SY10/4SAj5AxNqntE2/bdViOAHT4uRCkXFkNC85lkSNTH7bn/bsLGI3HBjuEDVgmZ7dqEZnfzWfZBOSfqy9rfEjBLu/Cab3QPcNkUEZxSgmq3jtRPkMY2njyIpzqrVe/bhVqAbMFWKsmL0/mCCbNXPjLNE3L5knmxLtuB0jGb+JLhfUAUhKUPp9xOeNAnbhH2fn08VqdHdevIm4eHUykE2P8rrSYcPyzpixglxPnk61ERjLBmMViVzONiEq87erp8L41qVOHQb6aWdS5DmP4MuhzP/oR1kbf87WOPbD9164+4saqHtgA75Os+bSa0o6qdwb6/jV+9K/duW6s820lvJ0CzDzaDDv5ZHOqcATgueAbXvcOMiW4e9LeIFCpc1weI4PHQg9H6+0tG5qkizk/nehck4swpB2MM+GrrrLkaG9s+Ry1G
 g62araJs
 Xi73AMLiQojs/Gwb1cA4BWRcwUlRwAOaiXJ943mlo23WsPkIECTFvjvj03vbjMsQ9ncuuJloBQIUZX6h7CTcSqx3Nbg5ts4fs4ZjRJKx74ymvB12eFuVwbl/cYa1ps/PVKo21+HKvwe4khJIMuehWlvRziuztsxnmRNc48Vpiz3Ya+/zvRpJZu6TurLIeDSor3Qt2C7FsiJ0kFm8klTFf9+LqmKqUVwmt8KAZvunOFrZMhFFAH9vX2zR/Pk8PJvd7KvdZuiTWk207RTyZpeUvEgXWEwSTuXA/eD8/
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
 rust/kernel/owned.rs | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/rust/kernel/owned.rs b/rust/kernel/owned.rs
index 456e239e906e..5eacdf327d12 100644
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
@@ -108,6 +110,7 @@ pub trait Ownable {
 ///
 /// - Until `T::release` is called, this `Owned<T>` exclusively owns the underlying `T`.
 /// - The `T` value is pinned.
+#[repr(transparent)]
 pub struct Owned<T: Ownable> {
     ptr: NonNull<T>,
 }
@@ -185,3 +188,46 @@ fn drop(&mut self) {
         unsafe { T::release(self.ptr.as_mut()) };
     }
 }
+
+// SAFETY: We derive the pointer to `T` from a valid `T`, so the returned
+// pointer satisfy alignment requirements of `T`.
+unsafe impl<T: Ownable + 'static> ForeignOwnable for Owned<T> {
+    const FOREIGN_ALIGN: usize = core::mem::align_of::<Owned<T>>();
+
+    type Borrowed<'a> = &'a T;
+    type BorrowedMut<'a> = Pin<&'a mut T>;
+
+    #[inline]
+    fn into_foreign(self) -> *mut kernel::ffi::c_void {
+        let ptr = self.ptr.as_ptr().cast();
+        core::mem::forget(self);
+        ptr
+    }
+
+    #[inline]
+    unsafe fn from_foreign(ptr: *mut kernel::ffi::c_void) -> Self {
+        Self {
+            // SAFETY: By function safety contract, `ptr` came from
+            // `into_foreign` and cannot be null.
+            ptr: unsafe { NonNull::new_unchecked(ptr.cast()) },
+        }
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




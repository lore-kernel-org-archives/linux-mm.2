Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77091C55183
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 09:52:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D56B36B008A; Fri, 20 Feb 2026 04:52:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD9DA6B008C; Fri, 20 Feb 2026 04:52:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDC9C6B0092; Fri, 20 Feb 2026 04:52:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AAB1A6B008A
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:52:01 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6B2FD160C49
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:52:01 +0000 (UTC)
X-FDA: 84464368842.06.AC9F05F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 84CAE80016
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:51:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TBlUoq08;
	spf=pass (imf30.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771581119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fEYMJwatXgPu+YWsD6k99uwLF7wZEliuaUYi50HKU1Y=;
	b=A2Rtcwbb3JIjVeKekqOM0wglOF0PneSYqjLyjnb+kEqier+dxSZYYPPNs8ALD0kjMayrtk
	8Ro9AzMh2XfaM0IASTnojoGrHQYDA/zN3SWMS5SJHd635N5tkMky2MUlNwmVLjKYjUoURd
	oNlR635HQpKIV2pzwMFGBMININIkRDE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771581119; a=rsa-sha256;
	cv=none;
	b=ZlGlZwdOddu/WPBS8Y6rw2XhUIx/OVCP4XmOkYUjanGze0caU4pw0NmowcqkLEpVYbEGvz
	iP9urox5vO/kJjC1OlvT4eh8DVlwOTsfCwoc6cn67vlYQdtV6hkz/TUrmzRKCGSUJyuAFP
	YQOvPZscaMPzW96l2VRtjxxRg9lsJZo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TBlUoq08;
	spf=pass (imf30.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5895943BE1;
	Fri, 20 Feb 2026 09:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC2AC116C6;
	Fri, 20 Feb 2026 09:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771581118;
	bh=B5FbaZHoWu3lXzLWsvxiL2xffXnxnFX4nBQhSLyFXlg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=TBlUoq08h8THjyqgOPa5qFuSUJ9EA2rl/GDN9uRVQwt25XUkK2RxR0vWqjtTL+7yR
	 cxoufxtl3dRE9KagTQfI7RkbgRykxBYpq8jJ357TWuSs3n6WeNy78TnJ/OsGZlbPKT
	 Thm6Otw7Q8bFXfFocqjTXBUKiV7Vq5W/wpQDQS4W6T/s8x/iBPpgcY0S/jf3hOLE33
	 0EliLnOFmz9t6PWADdrJir83Vzp8lwr1ATpcd8KGS9kH3OtcrnuhXChO/0fBhJkudy
	 zok60YIdfXuLJ3TKGwePrpf4o1T+iRXL6mZVb9VWayQRcEU3mgx8PQfbIuGjqMAxUD
	 GWwJKsOvDrPrg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Feb 2026 10:51:17 +0100
Subject: [PATCH v15 8/9] rust: implement `ForeignOwnable` for `Owned`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260220-unique-ref-v15-8-893ed86b06cc@kernel.org>
References: <20260220-unique-ref-v15-0-893ed86b06cc@kernel.org>
In-Reply-To: <20260220-unique-ref-v15-0-893ed86b06cc@kernel.org>
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
 Boqun Feng <boqun@kernel.org>, Boqun Feng <boqun@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2835; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=B5FbaZHoWu3lXzLWsvxiL2xffXnxnFX4nBQhSLyFXlg=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpmC6lQ8ViWhXfTBxkBwYXwCvpZEQQpsFdLjSWt
 Z/0DPcp01iJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZgupQAKCRDhuBo+eShj
 dynCD/wPCHcbzgHFtI1xHdF07F3Sl7RvyuqebxX7QafkNthmS2wK+6fYvfrTUdnL1z/OBT1a29v
 Ekv+847w5ksZlRBgGMKWxazpNxfKF5eWQvBoKPWlYxkyWDMvo5kyar5hxw0w3x3COrfeu9QKl56
 KhsRSpsbaevfgdJSut7YliqvTpAiGKoUhon8VZJN9MfpgxHFA8h4daaTbVL7VknN+9j2z7j7sy1
 Sgk87Kl23zumku0CP8xCTL/v2iQdTZkeAo0DqBaYMIqW99TDPpzpfzfY0vMKWUdz3CKfi0NVOL1
 ha+JjyDc1y9rbdiDLBax6CvmSMa3YTUcETVRBpfR1iK9Nv5jfwJ/ahTThdwfuq27a98NOsjeZM7
 xSMg0DOPOZm2bogbOUFEwQxYUeZawSZw5998KQzSnn9YHKJwKEyRhqKqLDSfv8O35BgPsTCYfZx
 ulAarVM09f3S8iZXGFdpWCwIIZXvoyMEV5vsnhvNxrcgESzwem5PCkmknWlGyJB4BTjaB7CVwu4
 EhB+2yo3w2A6G3YxFFEK2Y+4pBEXalKlRTVLSKaOAPoKkXmw4MtJptUOgpKFlnAlWsJJPvDVAPX
 Zj4fG0pZkGwmYQf3x8c6EhW/QFvUIWp3kCah+QYzszA1iz7lJcu0LsCpfHpmCOqa9mFhCq4JFVx
 H3Cwg/+isbapMRQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Stat-Signature: b59b7364f4cp7y3tjw3kjokm8qnj9by3
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 84CAE80016
X-HE-Tag: 1771581119-559713
X-HE-Meta: U2FsdGVkX19NVT+FuqEJY2reiH2eYJCJzmn/lU+5rjs2NE1R7M+77lF/8Kvl5+tAttjoTDcCULpttDcctOPpzt3dyweTRc35nUAZPqrJJnr59AVQQHs6y8kGe3pOGaForbjaGkI8OxCYDpRBNOAshGAoCUdpe8BVi067H4SkurI606b3eUQN89a8Qgab3LDfES3IrnnJK+CvLhXIj8TdJ2dxTYJCK7L5VvgOARjetnFFC1/9kDElEu8xhX0LkS5CzpZh3+JRCCFOiP4XIFLjW4Ksh44VeM/SOMrmtIY2I1m62QQyqdbtCCmixF3+qj0g6udFAgvTozV306YbrZHpKx6aggRhGzZiuVYggDaIT2XXEe6V3sre78X0Ay4BGLXmwsKqY2I3CA68JiZMPjW6w1EN87kR4YwwXjpomv36tmr9u5V2+VNxYABkTwD2LqY0dfceuae+tLiPSReQuuNyj74XbVWgMxnXxxRwK1wYzcDstcx47DjSriav0aY47PLAGmQAPvYZpfn7LVzwCVjq1TBnffi9h6Y+jvUbGyrUhCYvuVomlzpRVRdM+PskmG9ch+/EXD9NnSuz/Y8LUmKiPD4icEPRMHwqcX6S5HJAqi+bb7Z804PNNdyCEckms8XWB/67YgPBGO8JorEOGEvR89u3bujtNKtxANOU8cT1EOb4Xe/VsNjt0NyjAdTMDRewiMMhBkhQCgnfUjilNBFJnEnUY9xgnBsCHiRi47s8q8Rg+h15Y+1IPmnQTk8f6ArpGA6p+f6McQygJBH2pJN4+DdxkZDfpc6jYg8/St8zdBnamFy8Z/FQBqByPSIoAc1ykrNvg00co8D08zEWYsSaKlpJXHm14HRqRGuIOaHJiw0AohvmwJBmwaQeTLNoQ3MTNQjdUHPM9PhFJYt5WxH6/Q/ab7el4urLUyzPx2lXlvNZ7ZFl5MNv166p9/dcBsLEsxDlfr1QWzzl+2nEJ1G
 Iw4gywFS
 WzAjm8H6rFxrRjIbqnhKlpN8tl9YHxghDeLa3TqES1NQXvkLV+w5ucpA/7VntREpOxPBhLilqp/nSVnH3aFIV2cJaPn4zodQy8/Ad82C7klEtkSc6lqVgKXAc6wte2Q9G49p851w3M2aKI6J4Ll+FwPm7qJOMv9cJCALzGj+8TINe4SmIUiurDAMw8XS32CTLYb1v13A4K+kcUO6FHQ4lZjIM84HeA7DXugTuShaR5DSQbO9jvmtqZ9h5653b59qH9gJ1Tu+K/z1tK7xW9PjB67QxgfteCPuTVu9uNbDHR4c7D/OzQccixExwPSeYirMZPE4W
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
index a9bc871e07ce1..b115b4f3db6d0 100644
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




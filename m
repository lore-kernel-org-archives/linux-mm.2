Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08D93CDE00C
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 11:55:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD4EB6B012E; Fri, 26 Jun 2026 07:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C84B96B0130; Fri, 26 Jun 2026 07:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B005E6B0131; Fri, 26 Jun 2026 07:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B98F6B012E
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 07:55:32 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0FF2A1A0412
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:55:32 +0000 (UTC)
X-FDA: 84921908904.01.3C2FDF9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5AA841C0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:55:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mKqjad42;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782474930;
	b=tQBmb9EI8sNMO4bhuFyM2PydzUaRTYffhLx8QZTa6sYM2Bhwse4GxZnBj9vdNOtpoOcEcp
	klAiooxU3JwKZXir+SZRRYl9FsG1kYsEIFxRTohNgua1DwG1eYKU7WITCdWSb9Z2YkuoWs
	QUaXKdm+GsBGJVkcRDkFa+HqygfjypY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782474930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HqYVmoPun9uThSi6e4i4mienBqI4nWoqt5vN59RnpsA=;
	b=ghJuTio3+JU+YEoF4K+9TUoNdQB9HNPqmYuYx5mGBk1whG/U1D7OB8Rbx56kuTeFdsrX+y
	nlf9QrlLv3nsE73rNtxWnKE31ROPDigGIQnABo+tACY6DLYMV1ppSwxpzwe+rpdH4W09SO
	a2RMgUJC8ZB6/uUf7sVdumvCpI//B2I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mKqjad42;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DB6B2600AE;
	Fri, 26 Jun 2026 11:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE671F00A3A;
	Fri, 26 Jun 2026 11:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782474929;
	bh=HqYVmoPun9uThSi6e4i4mienBqI4nWoqt5vN59RnpsA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mKqjad42xYAZRLbtP8kQKjVT+kMZDvm4fSe5dDNcFTDtHA+DeVzUwint2IRD+Q5Mg
	 bTyykVvfOMCyyi0fFgjAwDaQLjgJE+6HqZgjidFgpU+gClN253nuwYH7gg98QEYUcI
	 SMASWXZe/TDARjw5RxOar6hvszN+EYdFT3adc/bZo6KF0fVuYV2wvwrx0SEb87SnQY
	 O8/A0bgzp2tdZOvxAu6BpaPIRMCc6w18v+7RK+/AjIDavqzGu+oywzABLKtczpJane
	 6wlUHbr+HK+oVBoxw8a+CDhScUZmo/wqVWDn4dhDkvi6+VHgW4oFv3I/4ETXAtRYUr
	 1AG76K043EKcw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 26 Jun 2026 13:54:00 +0200
Subject: [PATCH v19 3/8] rust: implement `ForeignOwnable` for `Owned`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260626-unique-ref-v19-3-2607ca88dfdf@kernel.org>
References: <20260626-unique-ref-v19-0-2607ca88dfdf@kernel.org>
In-Reply-To: <20260626-unique-ref-v19-0-2607ca88dfdf@kernel.org>
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
 Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 Serge Hallyn <sergeh@kernel.org>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Igor Korotin <igor.korotin@linux.dev>, 
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
 Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
 Michal Wilczynski <m.wilczynski@samsung.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, 
 Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 driver-core@lists.linux.dev, linux-block@vger.kernel.org, 
 linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linux-fsdevel@vger.kernel.org, linux-pm@vger.kernel.org, 
 linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2726; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=rxFg/OxNn7Iq2MJWs1wke7ArbvlV7NG8RuAFMsQ/1ok=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqPmh2mexRRMoFN1jy1lxkXcXvUPvmvPHbqJnCj
 QAUGGC7f7qJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaj5odgAKCRD6UCkIqsW9
 0LrCD/93GVgfFyjgmqz4PMTBC6DC/QsQMpzEyq47kxne8s0C3CmAbCGQvd4mAcI8HSxqbwOjcFL
 OBDHo542xnGwDB/Bfgk8ZJ36Yp3PK+stZX0/+AFnICkNrNSqcJmhhHjdo9Tu7mV5bwpTyv3nC+C
 uj74AWk015g/E8FCrteSPOFOBGMSpal/pjGzSMsfpToOrxzxqQ8ThXzd6U7NE01vCWjJ5Nq/PD+
 QP/IpqC+sXlkzjL2Dh3xl5vES+tBXeVFF97zq/7jfWtVddoEEJPYcwbsTFDhB+hFwVHQ5ti1+EQ
 5PpYGdSk0GoVfIdBz251SFJuvtwmKa1xBMr/TU6UlazoxdbwHohI3mhrlz78g5SyUqyjgiahy90
 +jB6ontwnaZZmTwallmY+6mowMat/7VB0RpL+RTMQqpvRWoNFF65ILwaLa7w7QYHY3fzDJvYuJn
 kWADzpzeZAO9GkNC5RRmCCobtIQBcbekBQj8O7eO8RBKHSuFvmBeUmoiG3SUSeNj3eYg7pKmvEa
 rwHJf8DWKqz4lWTKGDNqFeWEWHnRxPHqZBMITllCI6hpe2UxiuVRBUrao7AzseLD6qXGFth8/pE
 cDQm/5nPJMMkgAPTn7hMpZ0wfDTE2Rsq0bT03XgHYN8T/equKYrQVk8vTBgLp14kaEmAAS1kebW
 SBN8VIqJ/Bt9/gg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 5AA841C0005
X-Stat-Signature: smn9wehqm9sdutkrcccrh4h7udr7qczz
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782474930-260115
X-HE-Meta: U2FsdGVkX1+0/4I6qCkB+ZREIKK5g1z2VHVyh4UCvxsYFcPBZseQp9TuC7rNdQJqun3gKGBrsq9ymjV/SklEgs+JHLb1TlLs2Vj5RxDAwW5sGw5fa/m4oymW6Oz4HLi3kpS6C3k+O/kOsq+RxdisCT5VCGv21vPGB+0fOCZVHCLCVwgqhcIac/Js2JyT971EvpOLTcz5RmnhQ7SApdLwppM7Zu1NtRrj3tN27im+yLoh/ToE+epEVHBdkvL01xtVt3NsxHRBdmnzNjFXIpeOybGPx4KP5eNQx29VBBvPqJpdHa+9WhKJw0M0YOfg6HgJSFoBOiW69zGP+xXbc5nIS9/AbIXN+SqSkvARoqlEhqeN5OgrJKMWIH9Dk+Sfjfrf+C4DmmWql/XabKLUIN75TuvrPOrCTkHowzkIS6duh4OlZRzj103OcHFkVipJgoSvNtUPND/VwG5+3L0Gka5a6N+DRO1P9fzmTa5a21SO5xEq/zoypHzSZ7DwoxNMWuJWkdS4+Bgv7tu78z434nMbcCNzSuYWu1M24otYXs3j3tlYBVQ/h6MG6/h2bOk4NVW177TUWu2NtsbU6X7YFnXGZyi6GgGHSEqW+rUXDiR4s4mfkDFHXGlpD6ga+7mE/zCs+fkkjVjGXHni8N0pwuBI3ZpWpBFcZxwomxQ6O8vXBdkhdnHobuqPvVJx+b87uqgvnAe+6kQhYmVdhdQhmN96CLR8IV2vq7n4TLw3mho5lqfwZ7C1gwAdiynv+1rGSI9YpQkI538nuWxYLxV6KLU3FwFmsUcixAfnzWynU3ASJQPD/cs6v8Y1CVvBwFwx0EnD6jfRGwmTcbxwy4d7ajSp2iJZPXIGWGS6xYDUVtgRV3TSham7IJ9x7Qe63mH6OfOzOYChxvu3GZJV4znFDy9R2JJhfnvl61/E1OEwc7EOyf7VLhb/0VbuI4HGsoD5f9Go14LvxPBPzNOWkmc5lTO
 vtU8lFmN
 7h6D1bk/Bl0+XcvlOTEIbO+mSbGDZnZERhWCp052uNvNmz3A/DRbauY1MC7t79FGc3FDD3a0idjeZ8cnUD+z+C+qsu9EtEqQ/pM6K9R7SquPQ2Dx7S4WysykgGzP2jGabpMtFDTgMDymv0MbYubV+T9TJ4kmQDyInVF994A4B8+n3wJAqlsGrioOHp9upF/xzxE4t7RoAfE8F4WOrI0mhmQiLW22o/3Bum/uMuHuF3svlyGyPgnKkjArVCGeQBhx6UE3H9LkycOPUazDPjkgMY02EU7uAx5smj+jy2fV9Q6HImbr6UPS/NVkQMg==
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




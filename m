Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 398F5CDE008
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 10:17:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 256B76B00CE; Thu, 25 Jun 2026 06:17:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22E7B6B00D0; Thu, 25 Jun 2026 06:17:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 144AB6B00D1; Thu, 25 Jun 2026 06:17:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E4B5C6B00CE
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:17:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7A5C916773B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:17:02 +0000 (UTC)
X-FDA: 84918031884.23.53C813B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id BC7A316000F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:17:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jYxaoRRA;
	spf=pass (imf08.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782382620;
	b=G27I4HnVDEd1+A3K/KP4+AVpb620iD6Swq8A9Yq/ADERmd0iH5JTPbARQ/eDoJ97FePVOT
	UdOSoFJ7kWk/CD8uEA04XuvOqOV465WY51XeWpJZxzx9NceQ4Hw3Ko++3jyk557liO48ym
	0hoAUvgwWE3sFRSznBFz7pMgaAskGUg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782382620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+v8tXru/D0w0PKV+e5hV801eQgcBm9LlNDFLEctuGws=;
	b=uuKACsAUfjFAnoTGMY6Qq8/ewfzpicRbvxOvuYfQI2FcTx2pT4wOEm2Qrt8rWOSXC3MejU
	f3Am/BrYk/5DZH4RlfN3Kb/5A4YWiZbs6CQYjmbStkXc+svwc4C9qnhOQ0vn+L6bAX94Pv
	yJ1b5irna2xj7VpqVlpxFeA62qaa2FA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jYxaoRRA;
	spf=pass (imf08.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 49EF7600C3;
	Thu, 25 Jun 2026 10:17:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952B11F00A3D;
	Thu, 25 Jun 2026 10:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782382620;
	bh=+v8tXru/D0w0PKV+e5hV801eQgcBm9LlNDFLEctuGws=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jYxaoRRANa1V9m1Udg0IJYabnSuaCxetxr/YmRrom5K1twHlGQtaKL1531OIV7wAY
	 pzwOh1YRvOHiKYfTdxkjLQA/CLlySN8LOBGgo+3PloSsKinE32HQNSyHvYY4WOqIVu
	 c3sQ4A6CaesjKsG+X3b8AP+jyZ5qfRgCVtRReY7aU5xTdLouWWDtH2V1oYU9AEscTl
	 zbknBtLBODE8kn/+r8HmDWoxKlQXYHI7/lVcR4xHzFUsAi2nlFzSvmugykgRXAf5sT
	 GbTf9AIUdsiupJjfIL6iCoTjxE7Lx6X+TnbOmaiUE14O0SwEGS+XJvlnxLM4161bD3
	 WR1CCy3HrouxQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 25 Jun 2026 12:15:05 +0200
Subject: [PATCH v18 3/8] rust: implement `ForeignOwnable` for `Owned`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260625-unique-ref-v18-3-4e06b5896d47@kernel.org>
References: <20260625-unique-ref-v18-0-4e06b5896d47@kernel.org>
In-Reply-To: <20260625-unique-ref-v18-0-4e06b5896d47@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2740; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=D+6ZIO4nHj4bYi8QyWJ7VF+q64oBcwqsig25+zf52rU=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqPP/A588eWpq8cK1DRyaFAdMoB9e5cPLUYXExs
 SGI+rLwcwyJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCajz/wAAKCRD6UCkIqsW9
 0NM9EACAfry4mvmz0WEAXt3dU0TCMRWt9+gIJhpWptZYdwb8WMOAwcNnme8eSmq2p2U0gfzP8VE
 2VsVzmYEAzMBqZuzatO9TfGSJT1jnY+0EC+wvlaf+FlAv4FxEHcMjbCOLYBcj5wu/GiTkXqw4ma
 NTtWKRmxYdxOkvu0ldB7OXQOfizUkoFDPfsNK28vZQW/5Hk/DTd8Msi4uUlHLUS061XqyJccspU
 HawCI/kZVOBYQV0glwtnKomLlYFNAXS6C78fH+AyBogljYuxFEl4S4edRrqC3yI7osArfqs6nf7
 T6H1UlTJVArV+EO44OmgxFS7zg6K4wJurHCnAxl/eXFDMwdEqkozukWftb4xYqJ7gNCCnojyysX
 +61K1axqWU4I5JhBp0IRuchOfPgthzXXI8tnz4eUXQx76i2LAykcJzC72ciMfaURzB07tOxLtEc
 T2COSqW5+dmQ8lzmcovWSH6agGSWValKC+jg4dZjbm25rGXTEcb+p5mFOpprvuKEvIHgbjOEP4E
 g1A4zLfJYeg3gFKKJIOqWqqn1r+Hj/Sa5UuATYbyW7DP0tIhRyQeCjeWYyrxhgSv8/ZFz2Cq5uO
 J/fOcUhnmrLBlZBvDM1EidMhai6Sx/tccPxmFEKgs1afbTBeLEcNJNspDYEviwoNF7/I6IOnPrn
 COk4sGbslMpyd8w==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BC7A316000F
X-Stat-Signature: rjw8gcswkg5wcpcj1pbibhp87sgb9qkd
X-HE-Tag: 1782382620-985682
X-HE-Meta: U2FsdGVkX19p8iFLu0KHDykhrdcjPnetQqooDR0U8MpQDCFtA3/zuWg1cGRg9kVLGPfH9oekn0k0u7kVY8irL9vYWPeVXyns7eZQM0W8VNowFySioKxJEb8XNS2iXuBZ0rzTt6nlZKUZHDazX7UDWsCYWoysvyrT9J2hqUw4osQn8qk5HPRt2Geh3a/nzDejKhdosMXO3rAZ66HvAjqtd2tm31UYkKzuuQcjYFTHHPFbVLHYW4suVOiRcyxGUK4PG/vQa9ejVipFefuV6yu6udE2cEqM2Q8CXj4tjmVgieOeZcdgpFVmNlWa9KM0rF7CAC52ozCDvs4VLcQkVxtzDPzGIE9YTSZbu7enRqeoqzWsuuTXUvT1WIs//rAl5d1qxBAvLPEyzmJNi1XFQ0N/V9FiyUI45g+75FZw1eKHdZx/OTAg8hoUw0lAK1KyFXgQ5MPrJ/fX2l726FdvVBAOIAaEJyNvMlznPAnKzyMSSjtVi26UVH5rh9CNG0/Z+L88PYb6Ykt7r3RsueYrL8g2/1HcVthBDJeqR7xnrBaNcuLJ7Jyh3+cMv2MmhJSsCZXml4VoJclqvSFyhiq36I6X1REK0wLJODDjsR2Zx2jvPeUksdGp4SZIT2IrCM5f1yEEvf7TWX5VrpqKwS29303RV12ls8gc6e3WVqAMuTXqhw+qPKQfJWq1Lb7SIb2VsrPqi0vRRuNkWaBfWUuBVnW15r4PoYawZJZtUy+IdxXoAwdV8nzq2/VLZv0C+pFpkoULTyGuD0C+ncghPr7RhzOmTUaWJqo6Je675GC/rGmLHXDMl+veF1ts5MiNYpKqCytIGRbpKdtzvHb/5O0pMmT2E5FuZ+dP+fXq2d/eNe34iQO9+AXxoCvfe661CfLEzA0InAjQz0jocUn0wNM8ukyNpwtISO0N0xnzyBG5vD2xvzYNNE3uDtzoBvx2Pzjp9eUUEWO/fKhKkoh4ICw0Kbd
 BBaEXqkI
 BCMWOH1M+Os2dSqZ7RDtjTAb45XXssr9XJLWmBaJ7IfmjleVb1D9mpz3c16U0nD0h3I7pGxIJgaBZWp4PB4RIfCQCb+peaQjZMGIuM25ooOx/7vYxefkFc27egl+7FUjhzySgkdAnVH9xn/oDSRMMgzhjMDRv8ySmTRa/b5x1Y/aP4N4Tu1f9pc9FZfDjPX0oPZ1gOxUyWeyWR/f46ytzFXRwZ862jIWiSL/lX2WX99lLdgc1KbdV5lEWqybWBw3gpLvvXYb50SIjuaypK4+7ZAcQ0A==
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
 rust/kernel/owned.rs | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/rust/kernel/owned.rs b/rust/kernel/owned.rs
index 7fe9ec3e55126..9c92d4a83cc1b 100644
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
@@ -186,3 +188,54 @@ fn drop(&mut self) {
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
+        let ptr = self.ptr.as_ptr().cast();
+        core::mem::forget(self);
+        ptr
+    }
+
+    #[inline]
+    unsafe fn from_foreign(ptr: *mut kernel::ffi::c_void) -> Self {
+        // INVARIANT: By the function safety contract, `ptr` was returned by `into_foreign`, which
+        // gave up exclusive ownership of a valid, pinned `T`; we retake that ownership here.
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




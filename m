Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A0B7C88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 09:02:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 447446B009F; Thu, 10 Sep 2026 05:02:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F8676B00A0; Thu, 10 Sep 2026 05:02:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C7C76B00A1; Thu, 10 Sep 2026 05:02:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07FC96B009F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:02:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 378C5A47FE
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:02:13 +0000 (UTC)
X-FDA: 85197260946.30.9252C83
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 67ADDA0009
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:02:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jZe2GdwO;
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789030931;
	b=CYoGw6d0u+UKqs0WZb9Wx0ItHox7HoIJHzjAFK3zZVm2yqtGBjm7obGHRF5fk07hjK6L8l
	HelggAlAhRQgK1TAjTRRKzslXhV+U5XdPJ51lzvqn6ExePKowBLJVMsn2b4Nquyleng6TX
	lAqxq0/B/QkE0q7QOU40KPDyxtF1xWs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jZe2GdwO;
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789030931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nMuMfZ5oOT5xSQNE2UbnqHDsN16Vf+j3KeZtRcXbj5Q=;
	b=a4IIbiLZa6IZppovV+Wye5TrycvGylQ0nBtPE5H/PTfCXtt/iILRv6UGLvhA1CVscOKWIf
	y4EZd7HMkYbBs6x394cj1Y4eJpWZJh2RNa2kzWVr8VS/FTNIMv6yqwO4Fy2PbT+i27PjX2
	SumrEZdvt4bfNOWk9uU0KtjJWtTxZtA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B74C343CD1;
	Thu, 10 Sep 2026 09:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B707A1F00893;
	Thu, 10 Sep 2026 09:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789030930;
	bh=nMuMfZ5oOT5xSQNE2UbnqHDsN16Vf+j3KeZtRcXbj5Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jZe2GdwOlAtK2Y/DOgIkQVr++reMQhah0vlgv6xXz1IeuoFD6LxcNE0jRYaUZrkqr
	 Nh4Kfb6H0sjZ/vWlR09a9d/t7FmyuRr5lwq8BQQpuWgwcbSBs3gYCszxCc6opuexwl
	 rI12KdSLv4BUZH0JjgRbkTrNcz2peyBAc2gL6KF7JEyYm2WT32wELiGPU/hSO0w/Hi
	 YQ0/qtRVZxZCkxXNXHXP/2x8/msUwDKOJH+kwguKlwEyCxrLfIdng7SiuzDxmJYWQE
	 FHq/Vv64FeSeWdF1pQvfMfjuR90V4qVR8eWlUfgzF++JnUnK0avT4qUXVkZmXXpudm
	 5kRP7FdZovV8w==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 10 Sep 2026 11:00:07 +0200
Subject: [PATCH v21 3/9] rust: implement `ForeignOwnable` for `Owned`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-unique-ref-v21-3-e83257373062@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2790; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=O2wzGYJMYAkc/T2itapqXFBmX/u7K5ttf1JgBR/HfM0=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqonGjQYuzzLPzVcDFmo/+nPkuUnB8xRZWr6uP/
 wqulSxov86JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaqJxowAKCRD6UCkIqsW9
 0AeWD/4xQAImVQJWGybdMjjzNA5J/mQ//XrWd8nl0WREOfKnkBJ5A44YG9C3TPFyt5i++gERKuU
 cfW3tb2jUIisOMF9GnvwnRpDoGb36Wfz0h2an+YSgiEzrFpsE3tK6u4RI4TF9GAx6YMnuqXjNiF
 0Vfl8fQjrSZxR2Ym5O3DIZjCrwYtOVdDxpygxWu6TKL0pdI6vq+LKduP9hqXBhOUPlRgaVgNiBL
 97Ggf0jMjmag0lqML/jN10MQFyLATAWhQnxJDAsRMLL5cctk0xrQQX4U1bV67D/NPS2gOtyb9ny
 RS6v6yaTlmmrF+xfuO5k4ZlKJ8/Q+XNI6HqEHYFCg8KUG0FPZoOfW5bbL40whtN9cqBHyu0uTvc
 GKWLJxaizTo0hqfGi196tFw0K76kzTRS5IVr/jrGkdsVO9Z7aFICi8t4DRqehZOiLqa8/Kgc1qS
 fz2gm5J/3wBIHTS5EtZSWUcuXYB6p9u1UcuiKVmt0hPcd2kVOonaHsn2oF2cgKeWG2LAtTlQE/j
 iOtBj660fPiupzl1yKm+ulg9UvkMrWGYJUwQJ0SdwOS/2wd4SgSrdOqyiDCCgu1VoVHxAPa4eBc
 gd/3hd5BB9l/mZO25TBpArMYuKfUECI2bGD/Rz1k6Cr/KkOdqTw2QInQHRguGnD2w6NXoeJTqQx
 Wg1ZeU9c+ANsrIw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 67ADDA0009
X-Stat-Signature: 7i5nrhchqbr6kpcznpjgsdkn15rafh38
X-HE-Tag: 1789030931-136833
X-HE-Meta: U2FsdGVkX1/YBx1oPjenA+UPf9g7Fsk5HpRCKDdTvxEMVLb+ZjM5b3QrdHoceu66fFh65l67wMSOBtFI3Px90lEB9tSf2E4iZCEGFys3YlTvyeGsmbEHp83Vp/8FIq+cNQkvrl46V+Q6GkpPRxTXvKWZ9jwNRgOjDeQGDHhuIUs0NVpmxsbjfF7v+8q22GpgfwoSjXQOGbKIxtUQx+QnTd2UuV4Cz2qJDGNflbXoEIXGEdyMztoBKDOsftknzp0J29ZQADaSLdiuEKpfe4z8y0uTFrD1f8sYw3qO5z4FpJP4MXCR4KI8FYsqgGYOuVGW6YFF31Hju2EcX4wpFs5gNtC42eRQqDOAbK1Vv6a58TteSeMXeiGvcN0HhruKRMOLI+JjWdahGyhCTpZURGrE4RMudAXtUMJksD79IzJ2c3yp39m5PniJaBzm0go6wWCCN3zrfMPrhzp9QktztWxWGM6nQC099exEpHF6r0xfRx4BhL6I0rIQeNtMFrt02nl568RviaT2zlyota3007XCmW9JyutZ5kVp/hU2tIbEFSC0jCtDe1pA3OO3QE1W3jSrlwypjp/pmyUmRDdg5Twc1vx+y0/iIoZ41CIYIAoC8N1tHXYNSW3KofG0Q80sUwt0TStZtP+qYvccOdtXm5YU3495o1+7Pu/V5PTCPB6xpKoX6HlpVsGS4bThOAHAjQMWVMGHHDA5ljFC4zahI/tUevmm/Sza5wcOeylmcRtvRSLaGtTSZF3SN4reUJqIkenKtKwOcCK996BDWTeHT55I7SlLU71mU3t166n+014onWyJeuZPReyXwimSeFIpNJoPsXr3V7MNrmxDNZSb+qONQKmNwR3JBsMIgqVxPHYQXNtAoh+imeM0df7fIPA1x9DdeLFctp6Hik4d2Sb2VjGy1XX2rJDcisjfSKTx84OUxoZcc2uQjTNRgnpAfC7uAUywkpuTUit5bpYRG2glgO3
 zrRsMxE/
 tdZKpE/sjhXTm5EL9GH2rXVlO0caxoFFNthLM1nTpHYlWgEMvMaqgeEF2KvQ+LitcsK52pQTQ8NLVwCHn85ywaxR0G3JAoXpKy+WB5SAbngYTbQDll15jiskzYKxhinWPjodP23Rw+ohKIeXe/A8EkZdcKGFgKfuVJrLXX5XSLd7EpgS/utJXlkBsMc8Zj9t+LyX2UeALxy4WFkt/Xj+4aUlqU/3aLGcJ4Mmr6mnQliHKn3qTOuDE4kUnZJDXDKwOvaZFXGoi6oeHx6DxRujeZnGO9BY7UpA7e1UIyboTinid0nyca3eA+hNWzGW1rc/i4AvAQrrByHqu5lSZadVGnA+hddZ/s+OTJ7jPK3VKsV25HD8=
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

Assisted-by: LLM
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/kernel/owned.rs | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/rust/kernel/owned.rs b/rust/kernel/owned.rs
index b76edd7c4151..e54a058d65cd 100644
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
@@ -189,3 +191,51 @@ fn drop(&mut self) {
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




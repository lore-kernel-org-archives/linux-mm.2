Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8373E9B251
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 11:19:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 527EF6B0088; Tue, 24 Feb 2026 06:19:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BBD96B008A; Tue, 24 Feb 2026 06:19:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C22B6B0095; Tue, 24 Feb 2026 06:19:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 26F4E6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:19:53 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A229B14055E
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:19:52 +0000 (UTC)
X-FDA: 84479105424.22.F118F4B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id A881518000C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:19:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dDpqaaZj;
	spf=pass (imf24.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771931990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fH3R2cmeEIB2gPAkQWfs9E/OqttY1p4wDSkyU9WCeP8=;
	b=vVJs4HOnt26MtzT1ipG0fKTxdqored5EV4IKVUabjv3E2Wqb+nY73zGUN3MRSaB4HGXZ1T
	WrlSmCh4PrFK6dFq5HD2LI/bQhOBWA1MrlTINc61bV2xAlrh0YLiIlPNKVfvrn6SUxDawW
	9Pefvmzw9lu34LED1bjh1fZnKPLoeC0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771931990; a=rsa-sha256;
	cv=none;
	b=jXn2gI0GZlduUMOS5wUFf2zDiv7k0JL4WC+c0kYr4qlMQG+HJZmX1jZVNLG3LzckBTpqfV
	GK0oaZsLquBaxsb4777NpDhGm/MEjBs55thkXgdferc0DApx8hPrs247t7lLhQ1Rf1ThCh
	tx+DREVmuoiT2Cy42+vFkF7Va47f1F4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dDpqaaZj;
	spf=pass (imf24.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CCE6940ADE;
	Tue, 24 Feb 2026 11:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FE0C116D0;
	Tue, 24 Feb 2026 11:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771931989;
	bh=ZXVxYHlu0zHczyQ9RV4gzKJTzAnDzspoUnWv3esNFwE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=dDpqaaZjsrKAAuBigQMTjSHyxPwyewaJ+Kh431pzCvN3W/5M0RWV/9LsDjrc8NJAn
	 ji8U2nnjIczOlsmv9Cc8A8/xV2GqUP5ESuXy4HSP6AgQdIH6Q8oYe45W47lN8bPXWy
	 dYy9O/c+OBIQAmB31y7RS0nduullT7ZOft6gWwXrfyBcNTM1LXOndDBQcMGZdltFCt
	 kblbrFJuhKDqAQxsaH0YxOn7BGEr/kRvVDvQlDVo5VToqaNaIw5A9B4B2yN5sWcz62
	 jzbZSa9w5/3bCsNch90KohlPX2hcU2oWOPDfWIc7OQeB8SrVG8zCEdClApUuvgU7+4
	 MhoQkxKQ68UDg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 24 Feb 2026 12:18:04 +0100
Subject: [PATCH v16 09/10] rust: implement `ForeignOwnable` for `Owned`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260224-unique-ref-v16-9-c21afcb118d3@kernel.org>
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
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2791; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=ZXVxYHlu0zHczyQ9RV4gzKJTzAnDzspoUnWv3esNFwE=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpnYj7ybE9TfHosMN/v3D3om/fVXrbbm9j9l/ed
 /oqHH++SfWJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZ2I+wAKCRDhuBo+eShj
 dyh4D/4seiQJBYM348GadM5XGPLQ2AkZegX5kl5/dCXU3YauTHjS275rRpJntm2vV2eW/wX4Fz6
 I1vb5+83Hx2A47fK+9mEi/LG+DaNNVI0qsjDismLwy7V7Yf6z5qVr3Ds6gcMrdJ0hFGGOnMZXks
 j7xsnNXbvg1HgxnWNbz9QmWQyFXDdI/FPHe09R9WUkuszYtFJ6qlaZQdDQ+pvsCqN4xFC7UsKWu
 sQl1MmCT3Q+1hIHi3ZRrSJGt2CGuXKmrozMQmciIRuPtoMfLbKAz7lkc1alwqFtIaRuVnS68GS4
 dggi4hKlQl8QBTRR4CJQbohp5P/tZtnyBtAmFfLuCUJUBcZmoXKlflQTZiLJlrcdqOlWvIdx8y1
 gkz87chPU0yBGd4aT6TQJZDZzBWa0fGffmvzrdVSUyHT9YreCKsvCEke4GTJArXO7EuthJtMBbC
 Vs6Aysbti08nBgBd4lvF2FhwN5A8dMJprHs3joAecEV7pDVW2w4lEwJ+1prv8vz9B1E+2z8BGwC
 V+7yKZGJYnbUBKB47yqVr1MB1+6MqPRX/7WGPTuKF8MYcKTweCSf8OEgYbXPnA3yzm4VM9iQzGO
 PQXZTqVa3Oj1y5UELjmLwoh6RupeHLk7qDU84qKlFWCv66hFoQvwVTVJ1U8574/2NN/ArwwjTyv
 BK4RQHMK0lR4VdA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam09
X-Stat-Signature: teh83q59566chy6z3ie8fkdaqtgmmui1
X-Rspamd-Queue-Id: A881518000C
X-Rspam-User: 
X-HE-Tag: 1771931990-892539
X-HE-Meta: U2FsdGVkX19CwD7VOc0mKusjHe+E+6S7Q70E+sMDMtP4OSfECobPhc5fzmc7yuQZ0bZ/+PRJo61s3pPrmWtCD+YXY56zWzqmXphK1b+GN8EbdP48su1U2rD+3ym20LAA/qTXddyOmD2/+D85C/IbsSK1cu9pmugYWloxhOdbzkbD3ACZKkYZzq0/pCqSoAFnuvpFm5h7GpnrfO4Nq+kL1wtry5xHL6fsfLVMYpyxoEaPG16EJnADyz4+IXIeV6uYYY9ixgIBd/jHvhNQcp6cLN42IXBuIckSnur0lx0et9UOOMds/7toH6hAUwnD2p/57u5x8AIYeIW/ZlP9OPrOIPZPyhJ+nYWktGPqpozg4cW/9Wf4jZW6hpHbktDQ+oKfpXuZXV9mr6xjO3BFS2tMXFDzrUdim6iuuqG4fy0Bc2m9qtAHxt31ohHpHG/mTkbnPM37rhnr1sq3rdO4rNvH3GseGQmh0k9z2j17MTW15DaWI/zdLIfPTrTcbl92Lv39jJ3qZqMLKURjXmm/+nKdhpWe3RehWh8M3PfcfTtSr8MAzAHNhemQ5YM95aU5dknXP2bjvh/kbV0djmIbK9IW1ofPQCZ+4JK6O16jVybedNBuJ/obYfaP3Y+AhJ/yWjZJNWtZX1SuZxqIklXvNCvsEWrXVUfUJ4VE+T7Ey7GyAcHr/vjo5oK/s2Jq0NLkt5UecL+EMW11wbxC1v2tmXWchrHZgBuZVvVRiZHy9v77QRqU4lxV0tA8dcEiPLjL2A5hcp5sniKrKxaGSx97/sgHbdoV2Obq1Ys2jvOd3N9WvDIP0Y3FRBPvNycj578kBqqkd1NS3xblvcIYGbzfZQ/jA+3N4c919ynL6syffqqPDCq3Dd/6kcQicj2EdXj9uvCVnuFMGZ/HFMZA+02lcQ23HhdIG9H6zxUIdc60em7v4jKZO7BpeAOYunEAps/xXYzwIjLPTGi1yMb4pT9qh0l
 UCjAoY5T
 HqTdJ+08voJXJXZyxvvqttmIj5S6tQJ4vRodRtZfRjrULhBdzg95A1JZGNnG2UwB+MGPNh8tPc5TuiQr/kTbbbN5iMuCQYEMHp8i5qVK+x2FzprfN8KgePlEDN/0Nqm1v++BzmPpVETtjq4ByIL5UUJ7H/9s8dignML8Wd3gSG3RsJSuoMXVsk6PojtHAjKK/LPo8JwWvaXPwd9AjuMSZc0twtOcw4ne3ztJW2UsLfM+b1Z3IJioWVgFiT/bY6/e473LZkN4eSGHcllvkDNaTTTQxKWWGKsnGSgsLNNZ1V9N9ZuIOhUvjRshJ4eaz6EfpLEPW
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
index c81c2ea88124b..505ac2200d2d6 100644
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
@@ -114,6 +117,7 @@ pub trait Ownable {
 ///
 /// - Until `T::release` is called, this `Owned<T>` exclusively owns the underlying `T`.
 /// - The `T` value is pinned.
+#[repr(transparent)]
 pub struct Owned<T: Ownable> {
     ptr: NonNull<T>,
 }
@@ -186,6 +190,45 @@ fn drop(&mut self) {
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




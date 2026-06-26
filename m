Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F243FCDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 11:56:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0FCF6B0138; Fri, 26 Jun 2026 07:56:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBF7C6B013A; Fri, 26 Jun 2026 07:56:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB1346B013B; Fri, 26 Jun 2026 07:56:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A3F7D6B0138
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 07:56:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 22081A0422
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:56:27 +0000 (UTC)
X-FDA: 84921911214.06.A7480D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 571BA40008
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:56:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HkuZ7XBk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782474985;
	b=XaxPODUOS4RwIDdhK15SA+AbKqgn9twKVsrBHeUfx/pBqVr+vaQ1BP+vsCWPRROc4jLASg
	M36f/Nl2ZvIBKzFOzHl9hLokG4a8keFA+MOWGnwz2bFQn1HE8HIZzrCjmbdz9SS4fA1WcA
	PvtNYr4C9jKjBmMh4XGLraHv4+e0QPo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782474985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9MHwt/piGbHaBX1U0Ciw0A9tLdy3GnbZtG5V2/pNbH0=;
	b=HD//Zxi7+viRhAUlAQn98hT1sIZAIbiU4VZOAGZOT5LSzRkTGL0LU0MhIgecYgcaGj9WLb
	lhqZa4GA7FrEaFEvVbMmeDzvtoKF2y2IGxO1YirKwmJUgpSsQD6vjYz1KxUh091HfRAmZ6
	MPxUohIxakTaEmtPwZ30slb8GqsR+6g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HkuZ7XBk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E902760098;
	Fri, 26 Jun 2026 11:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32BDD1F000E9;
	Fri, 26 Jun 2026 11:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782474984;
	bh=9MHwt/piGbHaBX1U0Ciw0A9tLdy3GnbZtG5V2/pNbH0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HkuZ7XBkNBbPpmNh0jHv41Wuw70A+GdUFYjWET1qmXcQIKjTVrIaymEhyhQxZiJDQ
	 OYQaC+YTngeDtEXGcTZg2nrhdNP6R8cyrSArn0Vcg4mmq7Hto8gxALTcWSWfRU8kgb
	 i1NX1hBZ94yWCUrkJOY2045ItoVFnZTRZkQr1dHUJS9nY+rKTbTq6HIwWBAr/01JNd
	 oDiP18WI45XFmDdzBNkxdUAOofCB8I9OwzTdx5AOBXno0NZp0mktQRseoVeUXD9ds/
	 Ea6yM6KoBk2H/UJkJmv+1gH1PriKePYHNbY2wWHbjbguzGKMCCtNXrSSLLiaCwHwV6
	 ioGjyljtNEVjg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 26 Jun 2026 13:53:58 +0200
Subject: [PATCH v19 1/8] rust: alloc: add `KBox::into_non_null`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260626-unique-ref-v19-1-2607ca88dfdf@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1170; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=L57zDm7ALp0lZWMW+Cln/Gg2DuJozYQVYKA2SZ2s83c=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqPmh0T9NXm2ekfnSlVS5q2a5Nkx3elel1Z+sUE
 lVzxvaywm6JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaj5odAAKCRD6UCkIqsW9
 0GQwD/kBPhAfqhuRT/wPQuyxM0apWmNdKJ15rz0l+MH0DxUqynfkKds77p9Ba1hBaXZEiIgHmCH
 pDIBbcmrQR3ZzjLNEC27ic8X6+BdCVjQKsQBQWJ7NKui+imMc++MYWVIYyM0r0enlZe2kmN8hO5
 neGpUe0IvwQ3Lj6UWc6ACsUoOIJ/VSSl4SFZNnkH2SbWvbImu4RPT5mmyv3heMJ9g65NMAedvle
 tw99mHlW+RMWghmbVY1G0CFXcrMFX/ICi7lpll6iz01cgmdWZ00Zk2kIk1MDSePNSLkiHcviPYo
 eujIyeR9+opejbUdjMsWAJIqUz1K+CusSsy+pMB9t+0TM36BK03TehWUHzki1rXsWQby8KUOQx5
 JtTsLGUeCdq8jj5LJh7ikHfha1V5+4WAgb1NU6rWbu0HAaCDeoUfacnX5DMEVlA2YDZYl6lGSYy
 LTe2rZntwugKRllSVNPfbq+vpbu4eh/00OZ+rZuo6jg4qjxcaF8bpEujK1QOVaT6mqH0SIO6fL7
 dafroHQszbX998/omhRnZ/sCkPDELv4EwBaAlkTH7N3G0DsXiUEUx3nko9wa630BA3dS1kWBvKn
 cRx4J3Tc31/zybazPxJ7yei5pHjMTfOHDnSsGrWwiXODWfvRUZiqgEWUO3S3KJWIZpG2VabKArA
 vHegIagDX5flLQQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 571BA40008
X-Rspam-User: 
X-Stat-Signature: hzims49ofs39wqsshjj5ckwksf4e668p
X-HE-Tag: 1782474985-728207
X-HE-Meta: U2FsdGVkX18k3Ji+Bj8QUHeuBQaYRA/eSDmkVbHpZAWKWST6xIAmdB2sRuMSIV6mdMy2V+k5Kkx1WOJwbRj8gm8g1yqR+tUA/ffjwBACdxegXOLI+gC7EpOtb0CJLGdhkvEkrjLyWGy4XYY7/MZ/GlaR5/o2gxGNW7h48ww59j3eJda5KaREiRANoQEv+dBlc75Mfmda59ApiGhOBp8CS9PCxkXwj0VxcELH41ev7duVCFEGxYmyEvm9dsB+qzjct7LtxLe8Dj74kgx8ceRQbivfmMhOhxrh6873Z+1zvakfN9M7ucyH+2wwrpJ/tBDZbzv1Y6zdV0DFZtUwpfpTcklnvUy6xj8Q5kq0K4lyLBn2PevA4g42GZCboDEw57UypmggKKMwxsElJjcEITj5GGnSt/kyH1886K/u/CURZDOkNuv6Z0Ehx8NsM2PPdzfSUPcUevxpKB07+0+PdsLBQ8yY/M13Ft5ue4qSss2zOwzKkTosebj4Glo6p/CcMVXH+5oZNhDN0DaXBUqXSaaHePjypmA/Sh6I9o8yweIU0mXbop6+pa4GHfA25GIotg9jfYFgCGgd8lknYmfTWg6vSoXy/u4ZZa1hvtIPjXygplc5acPMH5ynMZ+c0HVyyZE8RL0Zf7/BNfFRyMYidINPYcG2oZF7fjUDkEKCUMPboZh32tq70KHVN+oEj3gu5Rnxgn7ctv+WlDnabGQPb4FcvClEysKmV5iQch2rZJdB177HuX9MM9wJuM8jFv+W1r3Ww5YJIjFQMUBmeFXC8u4XUt17hiuHTwWAlXT2YXHTCd3qwXrJt8e8RqnodBxlittB9U7+KSMeH/3tCq+49D8ANEbEPNQ0hHYuttcSxzTMhwPnSqGm93xrrfubne+XrLoq6zlBQtRTcXHqpZCFGRaqu2YZ2SYvDlJipUXGoeZTzrHVFx4CfoUyvzcw3wlur+fwKHj2B/f9S0k9ANmrvRU
 2GnNddiT
 tdFgdvGZH4GYNZ29izHGHBqNsxK8JWFuD6AZaGkhpIQ6X9FELOASNs9CvaZWzzTDsHUaQGbhu3Cie0/646U9nm5CsW0saG4SWQDQdAQ/fx2M90U/QHcTcslIOWvYdWN/6poJT5K/wj0WsODHdXRbAhHdDWgI57DvNRxWCxTxVQmcu+Ndc/kNACCo8j1IITADkvANh72ixARxnz+R9kNblsdHdEgLsLpIrhopD++rBMB7KOHYot4vUpY5l3UXNbYSuoJoLBgZi5j+hlXz3mIopJeHKFY4je9zMHyfNDTK6th+OijOIgaEYoRDSZWMuAUgBioyW4r4hyqNjCPx38Uf9U4zh48efoJdlrBb2gEu9CfPTrzN1zy7eLJOn0fo8X0ybcbu1QaDLPLQ5HlxD/I8k0Ef3Sa09L/hcDALSX+REep+XNew/a2bzwukKljo3QpeHhbzDqhW6tH2nLWQTvWyFvIZptqZ5bILE0nxLJV/m6sZcN8Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a method to consume a `Box<T, A>` and return a `NonNull<T>`. This
is a convenience wrapper around `Self::into_raw` for callers that need
a `NonNull` pointer rather than a raw pointer.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
---
 rust/kernel/alloc/kbox.rs | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/rust/kernel/alloc/kbox.rs b/rust/kernel/alloc/kbox.rs
index 35d1e015848dd..d534e8adcf7b3 100644
--- a/rust/kernel/alloc/kbox.rs
+++ b/rust/kernel/alloc/kbox.rs
@@ -211,6 +211,15 @@ pub fn leak<'a>(b: Self) -> &'a mut T {
         // which points to an initialized instance of `T`.
         unsafe { &mut *Box::into_raw(b) }
     }
+
+    /// Consumes the `Box<T,A>` and returns a `NonNull<T>`.
+    ///
+    /// Like [`Self::into_raw`], but returns a `NonNull`.
+    #[inline]
+    pub fn into_non_null(b: Self) -> NonNull<T> {
+        // SAFETY: `KBox::into_raw` returns a valid pointer.
+        unsafe { NonNull::new_unchecked(Self::into_raw(b)) }
+    }
 }
 
 impl<T, A> Box<MaybeUninit<T>, A>

-- 
2.51.2




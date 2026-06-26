Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CF6FCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 11:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92C8E6B0132; Fri, 26 Jun 2026 07:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DC486B0134; Fri, 26 Jun 2026 07:55:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CD106B0135; Fri, 26 Jun 2026 07:55:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F9B06B0132
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 07:55:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C51184044B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:55:53 +0000 (UTC)
X-FDA: 84921909786.09.86098BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id F13B1180008
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:55:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FiipJjEX;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782474952;
	b=HUNiGqNVjICLzO1T+i1SCr9oWColYa66eRe44matbPN7mw3DZPkwPiDdVqs73wLEyub/72
	0x2UDGAyjKUO4NFnCICIlLuT+fvE1H8TTnpMOCPIIqj4xXWUvSBK2fGDdUAbEAmi4Aw5Z/
	p97bqeFW+dcDG/CXTVmz/78gLpTrya0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782474952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vL9knM2sUgbCQ85ffU5z6/s6VECuwJ6C1a0TUUfpb00=;
	b=Qnad4WaptDxvXEo3eSOcVNiE8eCsLU5a0UpEXpuE8Xy+EAGrHftfp/gQrVv5OaDFBSdEdl
	CbwRblvcLUnqZBCotnkoVKlN6rxv83acHKnwMpYbS7TzjpV8ke+UAuZH4YHaIrgGKvsy62
	d0sE/uXn+EtiQXTV6/4vAhv7WloS3K4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FiipJjEX;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4286341B02;
	Fri, 26 Jun 2026 11:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ACD81F00A3E;
	Fri, 26 Jun 2026 11:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782474951;
	bh=vL9knM2sUgbCQ85ffU5z6/s6VECuwJ6C1a0TUUfpb00=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FiipJjEXIfzROm8Rj72S4kZbA2N2xxNfWgPz8qlLyZkwrxZDSeqHQJZ1nsFenldGj
	 tWAeDPq4ViIib6znioJ1YDV40N4/fDRIR4XEVYUr7PCcBk/cmpHIKfk9oyXHcuZXKl
	 a//DiKyx/pD6SgHukdZRldMDbxAwwSNLmE2L5/uieAxdHx+QL+0nEP9fEXpxPuFpSy
	 AiicdSl595hg4y5Jee6UmXtWWodjgj40XIz2EoZj7oyfrNIRheyZoj0LiqGFa7fgIZ
	 HwED5pjCaHPJaeuwX4RKtqfR/Mite71yOPDpiSBLYd+n/d5RS6FETeyBfte78Ut12A
	 7WpsQU7clOk3A==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 26 Jun 2026 13:54:03 +0200
Subject: [PATCH v19 6/8] rust: Add missing SAFETY documentation for `ARef`
 example
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260626-unique-ref-v19-6-2607ca88dfdf@kernel.org>
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
 linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org, 
 Oliver Mangold <oliver.mangold@pm.me>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1545; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=Ze2x5FAumXdrYYXBmcLdm4zoQ8i0F4uXb1KFrUnACjQ=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqPmh5c0RI24LrPZqVYg0Qx/n7FDb+Aok1GaRha
 0/ilzrOjxuJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaj5oeQAKCRD6UCkIqsW9
 0PXyEAC23Ea6LyXAN/vBRnS7DE97krNCqsfydxgaFROXpDBNURjHZXj31Sg9Y9erG7mlTtA97Gw
 iZD6mAFVeXU9IMvhvCOIKXmdpVoRgFwfKI9/DUonOzTp8xJhDY5gOv9HtK87T576QMcztAszcV7
 /wMDeks1wYkasVZVNZN9s/O2Jj5f53J0aMqbuFUBR/NXPlCgZhvkGmAyVYQAfxggorCSwswCMa3
 jTpCwRwxUyixOPghBItB+SJeP5g1jkfQSoKtrXYmDE3Ospvl3F/QKrlca5nOD2WZVBXOykd+eWN
 W+Yo6O/7GY8aUFLlqvkKJOR70V5tpF9WbYgZIJJBfV4X4C8tL973ay+P+s9ALXSivgXAYo4Hpxh
 LtUDPxjvcumLWA3ZVZ+7g9DoI+g470yRQIWZuICvGHW3kNmyC4x3Dzp9STvG//SeyCbzRqv0Hjd
 RZMLYvoHZbQHptlGTRvwvAF/ptDrYzdebxRBuTfU1QdsWLJvx6cYT80VRCvLe+EZl1VOsvwPwuQ
 AlyisIhRWiJciTyCkYIQoaG63qxA4PS5bQ3kJ8juifTWSp+5bPU9eeNv4LxJqHe0GsnMAb0CuX3
 wdjTRgcuXTXNZZxEYRLnQQC+QOck8YxtWPw2OIB3ZPUfxIjpvhXNzn+wyH4lyqE38I2KJrba09V
 8ov5/+T4CdIxqTQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: y9ux5x6fyiqq16kqe8s8bqz9nbnrhti3
X-Rspamd-Queue-Id: F13B1180008
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782474951-863211
X-HE-Meta: U2FsdGVkX193G7GnRmmszyKDuyo8qp56ZZ5ZvsMKQbh3jStXRUew51kx4VzXzdsbw03k9jdkVRz5Wnms8XrqxQNhbpAk1nvb6l7Xlb1JKEYph1953gh0cMGCjObK4uluhSrUHk0ww3eb5iX7NW6iDW/oReASleFztrAfgqS/qLWlVo1XbDR7j9g8C6tWtzuzSvW24rz9YHdqg7/xyAc4RxqW/OABuol90o9RK4cs+Yx6sNGKQl7T44xFPvARs4giVdq+BW4whC3+bc2kK6U5u5mrJTiKnydiwn+S6gp6r/fxzaRUB+A1t9PADL7Y2aRpvtvP2U7IJTPPHcV1SO5lXH4pOq7nwvfDe3WiRnu7CIjLQra/GT4cu0tLBITjJdOYl1DcXJANFKfYXKkjDqZ+0/WygGWigZ29iZjVJBEUA8Aik+RH+5QAZEYvRVHwLeJx2YAC8qpcetEOmna/CD0Gtnxl0sX1gLWLhuutBUzckcrBlBao2RficpghI99DX7soSCB41Bo7WfZL1NFo7Zi9jjPfoOsfvd/Qt3AaL/v7shi3H8B1uU4fNKJnB+dcHPGLA/DTV+8b9TBkYRtAgDqh/+hA8R3Zz8fqYqrsOoJ37RQTvwzK+t2PfWEOh1cpZKSHt63Wi1CQ7he67m3EihSDQagZKuUHC4H3nXlshDFmmyS8bxKxiHQg8Rtk+9HLK2MotQGzUaoM+MbYCepbjMmbWxoi2uJeR5eP/56Sxn7dypeGJhQ5VooEFZXrExS87I1VvYvARB3+3BKK9zCibGtOUGHbEo/fWS5JsQ9JxSZ5+MviYXWpR/qOlAN1AcDrgw16/r+EE4sv5N7xHfPNOc+DabTFhPq3sfljUxbfaOyWMnDgIyelIgkyD0hjJz9l5NOvLQJin819kWc7p6cWV+dr+dKk0Vn+lCLbE/inkUQEJv+4IcFKjuPH90lm3rLhBO9f/bYIxvGfS9N6S9ioDU7
 2AakAphB
 ouxc4l/+zRs4NfuX0vhZeS+xrBgZikDAyvs4uLwkG6tmKOOsQqCVUug3aVv8b3YwKJu08kxRgvut2GxsmfJyceGd5Mi6W+2eKaE22XEzV9FphodNNNl4NVweFaBC3ITrN9GVtiSk+S28gLX0dkTzESKtl3MmG3Jf4ttQiwZh3R/p+Ltq1DgO0E7gcKJ6a7nypy2sfjB1eFbb3OIH+WmjOHUe01xiX4MnZ/GkJI6GcE+3swBgTvKHmZj5aUx9LxUbBQK9LUkiYoYvlHkGBWsCx2kazV0PFCHJ6HNqqzKla5MBNrtVqNo4M3g8FWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Oliver Mangold <oliver.mangold@pm.me>

SAFETY comment in rustdoc example was just 'TODO'. Fixed.

Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/sync/aref.rs | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
index ea5a16b8163a6..f26ca39b84d0d 100644
--- a/rust/kernel/sync/aref.rs
+++ b/rust/kernel/sync/aref.rs
@@ -142,7 +142,9 @@ pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
     ///
     /// struct Empty {}
     ///
-    /// # // SAFETY: TODO.
+    /// // SAFETY: The `RefCounted` implementation for `Empty` does not count references and never
+    /// // frees the underlying object. Thus we can act as owning an increment on the refcount for
+    /// // the object that we pass to the newly created `ARef`.
     /// unsafe impl RefCounted for Empty {
     ///     fn inc_ref(&self) {}
     ///     unsafe fn dec_ref(_obj: NonNull<Self>) {}
@@ -150,7 +152,7 @@ pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
     ///
     /// let mut data = Empty {};
     /// let ptr = NonNull::<Empty>::new(&mut data).unwrap();
-    /// # // SAFETY: TODO.
+    /// // SAFETY: We keep `data` around longer than the `ARef`.
     /// let data_ref: ARef<Empty> = unsafe { ARef::from_raw(ptr) };
     /// let raw_ptr: NonNull<Empty> = ARef::into_raw(data_ref);
     ///

-- 
2.51.2




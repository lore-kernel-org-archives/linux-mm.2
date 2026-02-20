Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52D33C55178
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 09:52:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0DAC6B0095; Fri, 20 Feb 2026 04:52:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADC2A6B0096; Fri, 20 Feb 2026 04:52:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D1906B0098; Fri, 20 Feb 2026 04:52:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8A6526B0095
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:52:33 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3D8808CEAA
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:52:33 +0000 (UTC)
X-FDA: 84464370186.15.A1DFD00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 44860A000C
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:52:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d6XvHSje;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771581151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bnJ0Siyl4b9++XwG/VYOMp+rtBOaQV9jgeYmZeiwiS8=;
	b=d7tbl4sAIweo7M6kFk6EGD0t/o6aLDHSobpBOhRW1jmVWIBsE6HDjf3mqvhLE/6X3GXYF6
	i+mh6r3g2ZpZYQHS+vZUtna0w63ZHogabzB4ZT/W1EnSIn54vmPsaUFFYxJd3qAb3XLc9x
	kccAZJpg0N8HEUhRE5da8QB30bmMg6Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771581151; a=rsa-sha256;
	cv=none;
	b=gonZUucyWUyfIYf2rNAzTd1UIjtPZxGHF4zQH7KWsCbNxSjGIeNrpd/QLK2Dr/gKcq3e0T
	NgTLXCo5X3qOgm3531UCV5cZfdX6u0w/pYH10rVTIJLpmgsXwexz7zrFua2Mmj+g5RMe3g
	5sWlyEHd133VqVbPsRP213ZN56nkawU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d6XvHSje;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 46B0F43BE1;
	Fri, 20 Feb 2026 09:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF9CC116C6;
	Fri, 20 Feb 2026 09:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771581150;
	bh=p1tAAxGtFcTpyH8kJIKfeUGx7oWCMIhnPZTORNKDSkA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=d6XvHSjei+/LwJ6azNn0RPBMuwdHY2AUX0AF3emYW7STF/HogUS8+EUDj3T/d19XL
	 M63tMOohnyibTXmGAA8TjFTHjntaGwGgaWECiP1PdArTlNK6cF+a8rn77fraqEu+l9
	 rn4fJ/3HCn2AgMP6t4ZiM/z1B6w0A1LmozVngj7jLLVZsyjZdW4/HiMQDPyiE6cNMI
	 nfC64/bFJMDvOeTurZ43+8l5zYJaQm2IBou+xxGbOSbBAnkOr723pFGtHUjzOeMbfI
	 a92ibJGQDcq5yHyAYOwdM9XEoJFtH8+0zVarlQ9bdDXdTxUaadxXKkMTGrInY8ibAE
	 X3eDPCS21Z1EA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Feb 2026 10:51:12 +0100
Subject: [PATCH v15 3/9] rust: Add missing SAFETY documentation for `ARef`
 example
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260220-unique-ref-v15-3-893ed86b06cc@kernel.org>
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
 Andreas Hindborg <a.hindborg@kernel.org>, 
 Oliver Mangold <oliver.mangold@pm.me>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1777; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=0VuAJevCkYFZAUYzbU/zIm1O124y3qethT0WcgbappU=;
 b=owEBbAKT/ZANAwAKAeG4Gj55KGN3AcsmYgBpmC6g+5r9c8hNIwBUmEKkWqrvZg384pxiRXLng
 +3sV++OUXmJAjIEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZguoAAKCRDhuBo+eShj
 d5gpD/jlKR4PuCzBrXKPcsSwhxSkegz1CUJdeYgrGfzZ9wRiOA/5ps4xbsU55RhyGnWoOb0+UvN
 QLyLhxhnDxODib1nUdt+EH74woUiQ1+tSfuwhD/bmb2FztVhX3YKoEIkULGbHAx7bZMUJVOxEKa
 FTaTy3ZNbg3E9hVWN3t0ZptiN7JGgd+inoLuRa9KrdX9z+nRozTCjZvNFqLryaBWUjuFU86k5UB
 ndhZG3zO3CHLHZ3z+qqqDH5U/qFXlhUm5dto71y9MBC57gO+G/fnEPs1340ZkwHrJUrSZ2RRhng
 vOz2ypc4kr7lIgN8Tn7SoifY0uYtm/8mKwDLDehcon3lIy6oZMQalCOO8kvFlSGwHiblbqE/Ibk
 FP+61QHkX7mYrBRbYPsNJqbi25f/rIUbNGNMfHo18A/2rmSA16Ds2/5vlwny+0hxv96/dQXcNXa
 2JpXulj0V+7noIw53LO/jknBTxQuYwd74HeM9KGf5ilIhCgdD9cQBxuvEPa3spLHS4xCVcSKCW5
 ukWuT4E7G7nRnUgSvozkeLAmTJqIWoNZFw2ZCTbmePW9Kbta+NjprXLwLR+a7Jrv1ch2bGyV6dK
 oUFVz73j3T569jm9Nl4Fyf8gsz/VEi/Q1MU5ShzSbfQjtr5+AfgxWjMQb9XxQkSWc4kBeFvYT0a
 wHpjkhcaZd+5z
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam09
X-Stat-Signature: uk8ag5853y4kqc97nb1h37esiug7hmkc
X-Rspamd-Queue-Id: 44860A000C
X-Rspam-User: 
X-HE-Tag: 1771581151-645530
X-HE-Meta: U2FsdGVkX1/7tCpX4d4zcCtcB1eAvmez+wq5GQ6KXhIUlvJj9/IYMvFxciWvnrtf85Sf/CVDB4+k80c70W8T65FwSYGTMA6JxGm9yGwObggnFdtWT2hhs7HaTSwgt8xKLtouANdzJLhlRSUoWjgg4KxqiyTq5k62voTd16P8P8zOKRXOlBtz7ZX5FD1eaNPHNNjn3LPDuSCAg0AyI8hWixz5CKUJDSNa8XJGt+Pqr1b83enlVkhZWEMfrHHtM/7AgIgDn+gL3GtoXgkAf7l+jrRyCXD8Xd5/bBvm+8jB9imx3yUi1UGnuF9kMQpm3MtljIGUgr+WMvjiZjz6tWp4R6G7CU8chZwMnDsa5hgWqfjyyXDUhjIMhiahjHtYeG98QUG9NTr2LSoK5HkTMNbLX0M/o5QZkvE89Je1TncOWOh4yKcvYWeZAaqUS7bW85vdr+JDvfImVhZqXx5R76FqmFIqn7TE+lknzpG+ujjFymzA4sz2XPBMkMrlCZciriuBw9gMKRmBM8kELl3xkq474c1tvP7t0hMp5fSSQFis3n7XCHnq+GxzqNJh5IVZVheXYCCL7HE78sUU01PKHUsXfKgGJM5EUGVRZ0PHJbyY7c1sL/MGw5kFnMt/QRGNH2XymFBx8AJi6vSdVKbWvXnPkwzXMFcwNqiXAZsVAYXg+9Ofn3bmv0nVzTYT0EQptZ/fIRPvbUVhJ4ltZLZtzD3g7xzmP84dtuSbABGcEDM2GyB8zi9/L8JHVa18ifRaX0exoIHYeNcMeJykYMxr244BYB0P6IysZc1Qms2lSg7Htp+CAv9R5pIXS0UtSxm/iUPTolTzIpiaO9wqM7uy49I2U6CWDF6P77NSIaSkhX11lB7jkftjnbAGjt/EVgU4RWQoFm/Lk45bXTfYJJ+j/50/eZ32S9I1q/y0S9pB0T9i8JS0mdExWMKToSlGPoQRVn9qG+eWX/5eLBHdZSCol0/
 6+4xbXFK
 Pi9kwmro1eAzSlwIQCgqEprZ/76wyZnohGP7rlzkRIQ4pg5T5jbj/wOLdka8+Etucmb62plcTYq+DCQ307orYyGO4vrdlAsIvrKWfXri5lePJzhKGOw5V29lkn+P5udScplAjQixUmQlKudqG9fUSFi6ORU6UGSCVg2yGg5bgIFYy861CmaUAaPcsKZKzoFUdnogju0PfB5vDbOJlCT8T90h0QBCkJDPKdauTmfcz5u5ytNOZE0fQXus3M/aoirzo8ONogaFtYX4g+64Sv/LtqVjfZsbRtbL7KBKoBkI/COc7T1egakPY2ylWa5GtK5BgWLGse0OW9CeLvgqtz7HdskC99B7lkS0uVY+EY7kzZJ4C54PlqN4Aid3PxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 rust/kernel/sync/aref.rs | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
index 61caddfd89619..efe16a7fdfa5d 100644
--- a/rust/kernel/sync/aref.rs
+++ b/rust/kernel/sync/aref.rs
@@ -129,12 +129,14 @@ pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
     /// # Examples
     ///
     /// ```
-    /// use core::ptr::NonNull;
-    /// use kernel::sync::aref::{ARef, RefCounted};
+    /// # use core::ptr::NonNull;
+    /// # use kernel::sync::aref::{ARef, RefCounted};
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
@@ -142,7 +144,7 @@ pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
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




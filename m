Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE67FE9537B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 11:57:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07F576B0098; Wed,  4 Feb 2026 06:57:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02D096B0099; Wed,  4 Feb 2026 06:57:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6DF26B009E; Wed,  4 Feb 2026 06:57:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D2EC66B0098
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:57:22 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77039C023C
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:57:22 +0000 (UTC)
X-FDA: 84406623924.17.B1BC4E9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id BB50C180005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:57:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pac4HwXD;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770206240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=abpWLae2V17Hr5QG1OHwl086kYIKU5swWRHjEpW9O5A=;
	b=pyh9EGvo4JkKMs0dkI071auK2yM6f/N+3cKdu8Y1JS1ZmPCU7uK4GbefzruoHofImPt9Tk
	xVgPU5KcBialR/f1VaEiCHEm97doBJP7ZQ8FSjT6FVikh/zMZe5Le7WP4WTdGY7xKK8cEY
	77f4QkgSnS2+0mvAwHAA0DRXz5HEioE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pac4HwXD;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770206240; a=rsa-sha256;
	cv=none;
	b=oVy0ZOoDgGdoUbBTPps8tWvPlJGpZ639gEe9wGu9xVfjvrVUI47YEzzEGs835AmClI3kxl
	1KVBxly4+0u+XHXLsCPrt4z35iybrHvtYyNWFpYCHeIg2ob2CmMM6RNV9bJvpHmkps14w5
	/JH+qKroTnX+gppl3GSZGhMqYm6cblM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 37BC6600C4;
	Wed,  4 Feb 2026 11:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92374C4CEF7;
	Wed,  4 Feb 2026 11:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770206239;
	bh=3669cUuITKf9u7tNBrqzpeq3tWTkH+jHDiuw+zCYrkE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=pac4HwXDEvkjtpqH3duQWkwwKzmPV6AGkrzzuHZe0O5AELAb9TK6GCTXHIbhsOZ8Z
	 q8tneEGcvwedeY277RW6MH/iRB75j9wIsomGma3B/1dNp6pdbowEdwUf/XLaePwge6
	 1a/kNPutWgagecr03ZdMjHBr1mwWyGLAS1dP+0OrrtdDLzMoBbYiy5JJrFfLi5bYkY
	 Qk/78O6ReZYYANDU2/O7DOup7Nd6dBU8JzT2UF/PL7x2m/RL8kHvJGJ/aHtW9IO8i6
	 C6boOy8YxHr7RQvGBbsTVJrgM1MK3OP3WbAQRBzeYhbp6fSkazlcrPQSn6jn4fG2XM
	 taOND3Q8Nn4yA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 04 Feb 2026 12:56:47 +0100
Subject: [PATCH v14 3/9] rust: Add missing SAFETY documentation for `ARef`
 example
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260204-unique-ref-v14-3-17cb29ebacbb@kernel.org>
References: <20260204-unique-ref-v14-0-17cb29ebacbb@kernel.org>
In-Reply-To: <20260204-unique-ref-v14-0-17cb29ebacbb@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
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
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, 
 Oliver Mangold <oliver.mangold@pm.me>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1810; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=OkPeSjQsIxKohCmbfrAmRiZJb8MRdSOGkBDNdfIpHoA=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpgzQBBW2YqZGe4r2rWgHunfjy7egLqvEkgf7uz
 37O8ZRA0baJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYM0AQAKCRDhuBo+eShj
 d8ySD/4oYFBz5VsAwkAc/58oE1gXZfwyx+fXfX6bgRFe4iQKQGVEtyYJSzETywutuMaGAmARdAi
 4UDKl4ygsICYVqLTt539ppsrWo2lF/YHT01wrCKlG2Dj7yIB/TagCsgMMn8n65juI9wGfW1dGrV
 1ClAkZ2fSD3EuBAP/SB9koV3O3TQB50NTF3q1rm0twBv/iWQuKmpJgdVzfIMGu99ZiHTN0EHd+I
 aTSOdg0c2U6QRfvXa4qxLoF2nSseFVbXsFRlFt/hma2dzLbj4+uZSVeyh64pc/1DMu4FjigBTeZ
 TYpF39r5j72xpLegzF1hOSbCSFWb93osfqan6YO38C++oWm81Jne2RQO8vlCSDipEYwwLKn+/RI
 WqFAwZDSecHK2y6sTxytNBFK2HKp36t2br3edIiMZ93JtPAOeeYJxw+EvmlbeVYSMYmSI0MBAiy
 aCF9eSlo4E/n6UGTZ7BX/R5+Gz0nhkjUnTv0/WM78JvEdHFXzg8eJEPmbl20x74aGx4AsZteFq2
 FIIDipB4dmtWFMEVPHavrNIAzTGz0e846BMYnBe70K35ixMEigNxsF3QYjrLcXtSXQXoXeQKsM3
 hlOlLb+hoGE5ZACH8lEcrepeFUuRy4HGujzE4WIH+nr1EMmTQtYMc63npItj/L5iX55R1rv1Tq6
 FXC4PDR6u4FX/Mw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: yy7ok3ee9kkpko9kxxc1by1ge3fuy9d7
X-Rspamd-Queue-Id: BB50C180005
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770206240-704155
X-HE-Meta: U2FsdGVkX19Dn0taLhHOMciWeYiTuexGauwDajxNzSuceZ1Z3k1A5S5suyOQWSNHgKGDp3Rvv3/amLc0uLOiL+kmpyq3Lqk9MGNlhZfaBX77zjjoHhGY4AYvxToIbEvHfI6Io3nGTHE7/LZBO3N/B9S4NAkrMQ3Jr7MsoP/zYLwLznH9AfJrRlowKgjIBB/6dhnmYOIPKB9rkp8GG2EGT+NQnNHdj5cNDBqV0QZoNHRMmqL+3S6O/yf/tGmnk3DjZN/3MfcqnwYSquHzf9E47DVa5A9wBFXWcDIQC7gdsNQ9hnppQEFeY1c2SRI5BL6Egp08CRkCsx96koOHkFKiEYlfhEIqmDN8e4T2KPiwY8iar3RdpfY+hR7it1VZkKCz5xYbf8PvXCyPHaZzAJW/Gms/DukPWjeHGHhOrqcfAJvlX94DrXzZWbQRGVMOOtF174WbUylX8rBPKYT6quE96Tfuyw+jawoOv0N6U0r5bYAqkdF3VgMaGW3URZKUl093XPaPl7DzoisTgxhA5qgpJtZoLzwxrPs4UmzKjgGF3lhgcpsu2AX0e/U4RYD/7qGyRzgvcdmePbLiMCqG4QrSPjWhXvpETXhYcEzdhdzyxh2fkBMQDMJ3NRj/xmdn65Qj5tjsyExN10i0Jj/sh8gNizFDNpLGJ6+VQXB/ZC0H/7DM0rANpZd+A6efhll4dbkJQxklWdIyXHiRr9FUy/HY/cMSwkHxCXlmr+O0+A6uYlLcqHAWvNOr1vC+HFr1pYnL5KZogLsgL7OsUpmfOstx9aT463PcldyXF5IP4cWcw3H0oENwDUaD/TGjBGF57LbITpT4Rh638KCFuitjAUEDMgDW4w7IXe5nQi1Tb3uvEH1qlcsPFfp+jp8JTK9JeRJDI+J+he6XjXhj3ZlcDE2hVru2pFT7OlGxSvdnNTgyZJnbPUFqcMoxmsQSLKfyv9rFbxp+7DHLGvd6EnlaoMw
 PADIf0y8
 noSJagGyDUJoL/EzCp3kZ54r+p1H9Yy96H5237rIv+48HFC6rvoCNnWJWjOQIyBsHfRoogbjp17GxLo98MqVtarsC3vfzC7XA57mG8CHCK9V2270VspJ55LaTlksoHZOwUkJwcaC1ISDZp4u8hbHBoiRWXX2iNET7fr6x67tBPus0RNqr+Pf4T9Zwvu3hARY9tqxufg8/PyV7Rzo2mvDKpl/uk5+D3nlGpXRruHAdbL7KPV0PpYlRKI4VXhBLv2sFZkF4ZJ+57iJOh1aHdZnmesgKMq1kZj45qXjh6YSl+YJsjsh5YlSEMVX16oGgR31+zBNp1WND00ATNUkeYT79rhNsPClySGsuktUepZq3D0mx+KoQtAvtuL0sJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Oliver Mangold <oliver.mangold@pm.me>

SAFETY comment in rustdoc example was just 'TODO'. Fixed.

Original patch by Oliver Mangold <oliver.mangold@pm.me> [1].

Link: https://lore.kernel.org/r/20251117-unique-ref-v13-3-b5b243df1250@pm.me [1]
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
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




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52852CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 10:08:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1AAE8E0015; Mon, 17 Nov 2025 05:08:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF1878E0002; Mon, 17 Nov 2025 05:08:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2F5D8E0015; Mon, 17 Nov 2025 05:08:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DA5B8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 05:08:23 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 552B012F760
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:08:23 +0000 (UTC)
X-FDA: 84119674086.18.6925896
Received: from mail-10631.protonmail.ch (mail-10631.protonmail.ch [79.135.106.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 74C7240012
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:08:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=qfqQACR3;
	spf=pass (imf27.hostedemail.com: domain of oliver.mangold@pm.me designates 79.135.106.31 as permitted sender) smtp.mailfrom=oliver.mangold@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763374101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pb28HdCGm3MdNVkZGIzE5Ia1bSAczOh9PTgSydObUhU=;
	b=ymFABWPPOzRRAOqo+XS0/wMv+zxyYQXI5e2lF/8cPsfi3G1z/+jnhQllJJPfZ+AnKoiXil
	qwHB2OVRzc5ItkVxgRCOv5YKaeS6icY3iVgIallaYAqSttjDDnL8/1SnEwaoPKrMKhtNUH
	xlnel1KlIt/tVUkCkRnv19VmBIrQKqY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763374101; a=rsa-sha256;
	cv=none;
	b=Fjb0kcgQyYvcjay/zXnaDGRKVfnX4NU897EDUHMLfjcmyBffEG26B+AKpjvTbJxxhTW0AP
	wat5Uz4u4BAj34jIEiyxTrJdOmz770Y6pkrpotGPNp+NDl3sf349MKGkHDPf7H7VhCaedg
	melWSFppzXOQTTg8+tbl8Wo2EU2hGYs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=qfqQACR3;
	spf=pass (imf27.hostedemail.com: domain of oliver.mangold@pm.me designates 79.135.106.31 as permitted sender) smtp.mailfrom=oliver.mangold@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1763374098; x=1763633298;
	bh=pb28HdCGm3MdNVkZGIzE5Ia1bSAczOh9PTgSydObUhU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=qfqQACR3EMQ/VXj7DdMIeOQSJBOKwkz0YVM7Rh7/Aqt7XHToWwDO5+5h8e9p71Od8
	 fww+ZzgZ5yh+Athct4PLzqZwBrywuoLA5ytS1Bj97PrO5su4sMCq60gBj2NV3e9txR
	 PkIdmBHcyF5l6sGl8PPxLA2X2Mdz/s26w1btXKgC2SjWy2GdCmxzQ/mwAgPfdPktJg
	 PK8MflXGO4dO2gl2DdF0z7CFNgxrSNMIw4wcXDrk1cxZ+I28dm9SYACznAajqXCckt
	 XZ+//7HDASX1RKh6xtp6IUA97jHNNk91dqbzJxt4iwCjYx4tD3nfpn5/Z9N5sdEdEP
	 NF26T+J6OGmtw==
Date: Mon, 17 Nov 2025 10:08:10 +0000
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, Leon Romanovsky <leon@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Viresh Kumar
	<vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, =?utf-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, Asahi Lina <lina+kernel@asahilina.net>
From: Oliver Mangold <oliver.mangold@pm.me>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, linux-security-module@vger.kernel.org, Oliver Mangold <oliver.mangold@pm.me>
Subject: [PATCH v13 3/4] rust: Add missing SAFETY documentation for `ARef` example
Message-ID: <20251117-unique-ref-v13-3-b5b243df1250@pm.me>
In-Reply-To: <20251117-unique-ref-v13-0-b5b243df1250@pm.me>
References: <20251117-unique-ref-v13-0-b5b243df1250@pm.me>
Feedback-ID: 31808448:user:proton
X-Pm-Message-ID: ae16d73f393bc00b39a87ca6f2993d137d719ee7
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 74C7240012
X-Stat-Signature: a41xppi68tsfe5hsna3saib8na6e318u
X-Rspam-User: 
X-HE-Tag: 1763374101-147150
X-HE-Meta: U2FsdGVkX19KFFuUkI8O+tm1E6/trGGHuijfX+FF/4YL18gkbzEPivUrtwMtmkJLs/ZjbPk911vKQfTsBH8ykh/sFhfrkTNeQMRj3L7lyeWExqh/8xV7un/qfnsOCxZvo0+KT+KnDJaufCKhrFUgDLYYoAiYB7t1pNKQWSxUCzOnm22agt05PAS7I/rjqmJT5PndjyHS8YJ2XPlDcIW8oeG4BWDIg9J/5r9tiunv0VIXa4d4SSELUy1ob6Xy1wrBBtcWK8G5jfVFY7i4wVN0sd/TuUc4jVlGTVoWg0T3fkD2Lxm6NacwBr1XT/AJtSkqY75IQP+3NrathZ9jYoUKzR/f6Aafz1x1ud1t86ZCJmt1Ls2sMRLioIQXPmSa7AjMFfwQ70KJRpbSps0GeYLUkq/vjIm1SILP4+RvQN9cwqqQuEPWPi6A1/yOkPgwS3NA9ht6jTssjqOa9WnoZ0uja5VrhIfozpXbrOJBbmbBaBiGkRcfEDjp4v4e51TyXK8eig0xQrzXIV2okbxgiYckw5nUEtCV0eubm50HYMm98fk1UzzRbMmHZGICSQh0OeIKq/H6JKg1dTgBcWoiZFOG+1DqLi4PdCyCgyrvloP2vJ3F8qHlHfp44HtutnRkCWECO0oVqmCx8Uiyxf5zPJK/6NnYQah2mjo4qPWJYziMCliAxpi6RWP3eQK25TZDcmvCGO0Ak+4ETXTPLeSBvry5v7aXXO0qW6DSuMseerCTSyDhhwW9kB9gKPwMzppsJPEvQWMc52vA3WZBM8BYfRPBKTufza+8GjGWvLIsVyYEaT5hS852jtQ1dPLfAF4Bm2wIEuHM+hGH1Fq2C+HpoTO5s+bDDeBMO5TNQs92xNHpYZyGpAmpU+8Dp1mQZbaXPxufc2zswGdVvNCUsf1v6sBLHtvKf9fsgFkTCVSaUBeEFbjMhmYtLgrENfWbPt7wnATjfErIF/2EY3RnkYAE+6M
 rtMmru07
 R2Uk/CrpyKj6EeRI5HIQjIhKBW5qFJX2oi/yK5NRFI9br0cU5AZMJoCwQIhtksDXMY2VSetYLN0u0LzzErPWKK9F8/zdzzrFdZDB0Y9NjQPhu8HIS6o8SdMS+J/AEPyffpd19ly/7c8RzyYFwbmin357PBThxqQiCIfrxUAThkmOHZBDvlmzs2u8+DxxBT9lT2Y0om2a1BNsWieyaTeyznLX2pSK+TRtQ3+1v6roLyxoG23W8SkMdhJVMwQ0xVlp1yA6ybtJq+JKtch8eHkizeRzvjUPhkXfefnsViuZ6nUf7HaU2NRP5eZtZ/eoafd217GH/rLJnq739XJchh3xBnfT/bIOFDK9ZUhhS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SAFETY comment in rustdoc example was just 'TODO'. Fixed.

Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/sync/aref.rs | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
index 4226119d5ac9..937dcf6ed5de 100644
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
+    /// // SAFETY: The `RefCounted` implementation for `Empty` does not co=
unt references and
+    /// // never frees the underlying object. Thus we can act as having a =
refcount on the object
+    /// // that we pass to the newly created `ARef`.
     /// unsafe impl RefCounted for Empty {
     ///     fn inc_ref(&self) {}
     ///     unsafe fn dec_ref(_obj: NonNull<Self>) {}
@@ -142,7 +144,7 @@ pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
     ///
     /// let mut data =3D Empty {};
     /// let ptr =3D NonNull::<Empty>::new(&mut data).unwrap();
-    /// # // SAFETY: TODO.
+    /// // SAFETY: We keep `data` around longer than the `ARef`.
     /// let data_ref: ARef<Empty> =3D unsafe { ARef::from_raw(ptr) };
     /// let raw_ptr: NonNull<Empty> =3D ARef::into_raw(data_ref);
     ///

--=20
2.51.2




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A77FECAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 09:04:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DDFA8E001A; Wed,  1 Oct 2025 05:04:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 040688E0002; Wed,  1 Oct 2025 05:04:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E99248E001A; Wed,  1 Oct 2025 05:04:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D52678E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 05:04:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9DDEFBC44A
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:04:25 +0000 (UTC)
X-FDA: 83948959290.14.8E85997
Received: from mail-24416.protonmail.ch (mail-24416.protonmail.ch [109.224.244.16])
	by imf05.hostedemail.com (Postfix) with ESMTP id D29C8100016
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:04:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=oMmk1RTJ;
	spf=pass (imf05.hostedemail.com: domain of oliver.mangold@pm.me designates 109.224.244.16 as permitted sender) smtp.mailfrom=oliver.mangold@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759309464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fssLc+fEIJ9sBuAHQfTYDJPSK2dP+xUCFgdJy3AY7go=;
	b=IJ3RvN7Q2/hb0dohzqNThh3MAMcDbG3eEpWP+X7h1S9V/mdxpGdNvFskzFcLVbcsgxTQNY
	N41MspM058lCGDf50MBX1oLzrO6MOldyhInex4jdCqDXv99gSmIDENRHHoypdfO7Cjos6l
	to8wHTQf5ByKgmxWHcqWuGpVk9sddPQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759309464; a=rsa-sha256;
	cv=none;
	b=uymCEEh5zVlgbAH0X2Kx4JuYjYergP91tK+0JEKOs7Urmz31gitptAm5jQhwxJTWKynr5c
	gNjZYRsnrI5ESGaFaDFRycHMx6bV5tyUbq2yY5pHBMutZWx1FsOgPvCaFdD+9r/y0PwgNw
	j4PfURjFqJvWV5EUCyVt5XMBoerht5g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=oMmk1RTJ;
	spf=pass (imf05.hostedemail.com: domain of oliver.mangold@pm.me designates 109.224.244.16 as permitted sender) smtp.mailfrom=oliver.mangold@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1759309460; x=1759568660;
	bh=fssLc+fEIJ9sBuAHQfTYDJPSK2dP+xUCFgdJy3AY7go=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=oMmk1RTJ8/wiD0SCWtIOdeIspDkJJb+oBRz3PvNzwvBuuSWFNAG4caZHfOeJaFUc2
	 kXlrgCZwBtLMcYpGvTnk2fePqEC6kdvvNTCzu/XTWGWRHaZyWIe9UF5kGa/+OyD2iy
	 BppGHvJeSbsyQ+iv2q7y34i2tO42AdRmjc0G1iF0If85oHo38oHBrTE8C+6Rnry2Gl
	 BxXLON+Ls71xPHV66jpCjIGoXsldN6TgHhlbO/5WyWWR2o74PpvSz7ww+iwTMjWVR9
	 1YoxJV2BH41U+HLHnz/UF+VYijBHXNgzOOfDd8W0tjNQMJX19L2uvKwDSl8uvRyH0v
	 GLO0p6eNKGVCg==
Date: Wed, 01 Oct 2025 09:04:11 +0000
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, Leon Romanovsky <leon@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Viresh Kumar
	<vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, =?utf-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, Asahi Lina <lina+kernel@asahilina.net>
From: Oliver Mangold <oliver.mangold@pm.me>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, Oliver Mangold <oliver.mangold@pm.me>
Subject: [PATCH v12 3/4] rust: Add missing SAFETY documentation for `ARef` example
Message-ID: <20251001-unique-ref-v12-3-fa5c31f0c0c4@pm.me>
In-Reply-To: <20251001-unique-ref-v12-0-fa5c31f0c0c4@pm.me>
References: <20251001-unique-ref-v12-0-fa5c31f0c0c4@pm.me>
Feedback-ID: 31808448:user:proton
X-Pm-Message-ID: 8ab9517ccdb9c0bc9ac966b0661995277141b944
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D29C8100016
X-Stat-Signature: muny3tzpc4zzt1smsy8s5q45qpoqr7me
X-Rspam-User: 
X-HE-Tag: 1759309463-312602
X-HE-Meta: U2FsdGVkX19r0ZZ6El0VbNyyxbDZlv0LSov/K6D/PYmvyiShFDCcYsTMmseTdOQ75BaLY9D7an2qWFgdkbOR3Im1lk8E7lofpnsXKkVXREuWjMory5PkoDc8KUdWqZkhErrU+rG5j4669oCqtrFVvjw9TnPoF29qAvsMAHSsMMXaVl5b68tTNEnFKv4ps9onYbplmyCITXQm0g/lTl9GXwguspmLN9oCjiTQxhn+rNSSmmzyOU9OIV6CDPGoajC0zSM6PyIh1dlhfDAXiGJN2BGP1h4V27KxsBojXV6X73WOKvOnn6pRSsQXGMRsptFSettNv0ep59lOX3MfzEOsBIVJyGz0iTUfIej+oWIFMzQTgYNawNSDK37MKsgMQjSxDFqIkMcGJjRmbYdtPG44x4nD3qgzofU2vmat/tDAihKFtO1lAn3lA9XiF4NWAQpVh9eeLwQRbZjH0TPiY3TfHsmi3kkBPIA6s8PqklShUCOWidyGWxiiC4+7hmg+pohNrHecc3ar+gx8gU9vYVrMFBinlwEU47yqylBlTZwdY7Pg52v3NpEe+QySX6ElmFFSLt9bUO2ka05cfGRG1Ba3kDzniwiFzN/taOxHczdFxj4jKYanc1NPL2P1GjDz91DrW8flL/F/Eu25PwB4pXPZNAM3mzPrknhF1E6jpQAKIhHQ9arBApPeytN+8ou7gnwQ6PWPfWCQe/Xf0SaWUI6M2O4A+4E9/3CSCHf2wkpyesRfpob+Mk2DV32czJB+8r+l7ia9/jS5EeTmG+73O6tG0+/GPVZPltFg7wSsEW+AL6FAS/vY+GUmAx8m8g5cHzCwC0VxfORAe3t+1rjJPTKXPKdWLDdOcwPrAAiBDeov744ISFXwe1onPmxEFFLTZXe2Yr3a1UW18yfD3FOALocowcRO9soK3zBkWVcThh8tcT3WUC6AXYjx0Pk9E+2gHXC3CNFT/RlhHHKBZfSBlQ9
 gLMWXGTk
 Kv40rapR3TqGWGyGx9sKeQSRwhkVFtZBV018522SYLQuEGrTNUcVrzi4CJl26f9cDKKBtjjcZqqE6hg1MGHv/wxElNR+MkmJuMNwmpg2nr7bs5kwWLdfJVx6uR91D9AImZKAsjDARtjnlp6hpo57GX2xNmygARpUVP1Ee0fTl6haR4dVwwdbGrl5pVRkOpsfElgsHetbyLULLytYpUJKZWUuUnZkC/S1+n+Kzfuw4yKpfH9aDO2iAooUwEFhnvf0/G0YjIson/lg62bf5spMh6ahovU8gMyaOvA7E
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SAFETY comment in rustdoc example was just 'TODO'. Fixed.

Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
---
 rust/kernel/sync/aref.rs | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
index e029b4c046449a6b0bb61bb6369ac26f9495b2ad..97cfddd9ec2ad788a4a659f404a=
9b6790da08e29 100644
--- a/rust/kernel/sync/aref.rs
+++ b/rust/kernel/sync/aref.rs
@@ -119,7 +119,9 @@ pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
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
@@ -127,7 +129,7 @@ pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
     ///
     /// let mut data =3D Empty {};
     /// let ptr =3D NonNull::<Empty>::new(&mut data).unwrap();
-    /// # // SAFETY: TODO.
+    /// // SAFETY: We keep `data` around longer than the `ARef`.
     /// let data_ref: ARef<Empty> =3D unsafe { ARef::from_raw(ptr) };
     /// let raw_ptr: NonNull<Empty> =3D ARef::into_raw(data_ref);
     ///

--=20
2.51.0




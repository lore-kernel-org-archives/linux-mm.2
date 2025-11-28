Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DF68D116EA
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 17:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 051AC6B008A; Fri, 28 Nov 2025 12:50:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1D086B008C; Fri, 28 Nov 2025 12:50:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D972A6B0092; Fri, 28 Nov 2025 12:50:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BF3396B008A
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:50:54 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90C54C06CB
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:50:54 +0000 (UTC)
X-FDA: 84160756428.12.0B4A96C
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf25.hostedemail.com (Postfix) with ESMTP id BAAD0A0005
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:50:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=JLkiHJgR;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf25.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764352252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CSvU9cF2EFsAjALyezUXtFWtkOVH0bcqxKUZhyUrvCM=;
	b=lFobIfXZREmH4+x7PR96Owj2vn6Lnnt3QKxya1AZ8TxdTtMbPOFF4h7WUjavd62hJPv7Dn
	VzJNHv+1s54AuTSvrtAMa7WHy6HtxW4uxTP5F+l/OTr2empw+994+laTS531aQRw9lnF3s
	s1jMF1PG0Z/uolGkwh6uj469w3bseE4=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=JLkiHJgR;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf25.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764352252; a=rsa-sha256;
	cv=pass;
	b=xMq+XPRSWgkSKZlhwOo2omWvzAGYuNlwMSda04FLo/lpHPkpgFwz0kVeUdyeL1CjWH+WJE
	xs3wmxH1Czku3CK1cSUsucgCj+R2FcJG9H+jicmrbHp6TnmbK42Dd2rcSSg+lD66kl0MyS
	pjjtlQGZfBfGfd5DRLwJmlnZFqnn/PE=
ARC-Seal: i=1; a=rsa-sha256; t=1764352242; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=jD1ZKYLI2d1J3n7Nn8PEelO5qXEL36eak47f/IL7PSnywyFON56Cz6XgCW6BAIRpNIh7z8XrJq41OJJmJMPAuyS7xa4B/oc8hxL4cIZy57+klHWD4IyeeRtIHckf1Eizx9HROuF9ooTM0ogOD94O51JZQjj7uM3etGKFsh/RmCU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1764352242; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=CSvU9cF2EFsAjALyezUXtFWtkOVH0bcqxKUZhyUrvCM=; 
	b=hlWt7Ul8JWfnS5es+gdb3ogNyD1wyqlkaLaWdMm61GW/7kBYctfSbVqSjj9RNklpyw4fYmQA4s6Iv8VAeihZgRkxkO9HkOVZopXkloqHJzRaGg9fN/jroBYneUN8K6/E3/RQVYeEv/UUkp2f5jCJ8LPncQis3ZHBpGQYbcGGvks=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1764352242;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=CSvU9cF2EFsAjALyezUXtFWtkOVH0bcqxKUZhyUrvCM=;
	b=JLkiHJgRDZgOdpKVEbGaoTfTGM7cuUbG17mJn/6NMuYT6u06OPec0sZe6nT3/+Fo
	lhUdjv/UJIHSKjH8Cqh4iCDSYbq56Gg4UDmparCStPUdkcm/T1803IpgjoIH0GBQaSi
	6b4WuqAHjpec+TxDUK+qmFyq8X158V9inSAayWOk=
Received: by mx.zohomail.com with SMTPS id 1764352240347383.8438430122677;
	Fri, 28 Nov 2025 09:50:40 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH v13 3/4] rust: Add missing SAFETY documentation for `ARef`
 example
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20251117-unique-ref-v13-3-b5b243df1250@pm.me>
Date: Fri, 28 Nov 2025 14:50:21 -0300
Cc: Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Andreas Hindborg <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>,
 Benno Lossin <lossin@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dave Ertman <david.m.ertman@intel.com>,
 Ira Weiny <ira.weiny@intel.com>,
 Leon Romanovsky <leon@kernel.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Viresh Kumar <vireshk@kernel.org>,
 Nishanth Menon <nm@ti.com>,
 Stephen Boyd <sboyd@kernel.org>,
 Bjorn Helgaas <bhelgaas@google.com>,
 =?utf-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
 Paul Moore <paul@paul-moore.com>,
 Serge Hallyn <sergeh@kernel.org>,
 Asahi Lina <lina+kernel@asahilina.net>,
 rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org,
 dri-devel@lists.freedesktop.org,
 linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org,
 linux-pm@vger.kernel.org,
 linux-pci@vger.kernel.org,
 linux-security-module@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <06C410F4-8534-43B4-8DE1-039F70B26E5A@collabora.com>
References: <20251117-unique-ref-v13-0-b5b243df1250@pm.me>
 <20251117-unique-ref-v13-3-b5b243df1250@pm.me>
To: Oliver Mangold <oliver.mangold@pm.me>
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BAAD0A0005
X-Stat-Signature: q984zds1ea3aa7zomkdw8t91tkeikypy
X-Rspam-User: 
X-HE-Tag: 1764352252-877133
X-HE-Meta: U2FsdGVkX1+oK7BeR43dLR0oebb3+IWPeBmTRocc2P1cKZqHJKAdekAF0C/TXqsUbULBoLGMtzCR12zzDdHR/OfyO3a3i4vnHEiYLvVc6NbII2jP00LsWPAfnJa3qOc9Ue0oe3CfnepHhRF2sfQJSePjb+HLMA/Oyn5iDmRNXCOr8w8uAiesME4N+dxgNPKkj3Ky99rdhetII9bSgnkzdmpKTpP3vHAUxdhTWm8HAeSnvjlxaJ6pha6NoBQxrVnCV3zFlyzjNzUL32MzyOW2QRv1P6pdybjvw+QHrW17QWJrofimLoP2jEXAwm7vo4XDoWBDzsCFy6t4fU78FxfphYSTHqS0TDT7DQqKs6Lb02QHOMsl63t0NSS+y98l0nRC5SuhH+zKMh6SbwwYdFTLkJLiw5CsRKmA5hwgmE+zE8Nv9BELfNSYevQDzTQkabkwbnzMgfj7a29rdKozclNht0A3NpThl5Yso7T/ySMQiLcD+PlmcqIqIFGJLQCdPZLnhvmfTxp4iI61dQ70IiWR4RJRbdHnKmQtM57DtmLAAlzxu9b2W/bTP+UmXI6MA6qCQ2tAF4vAeDeY/XuureRU/zK+T7oMpLpVqIOHuC/ZnCgkKGAQJwkNmyGz6PWagqsKwBd+UrjsPPspP2zuEe30IzvOr61tXtVpQS12XbLttN6OyNalX9UIUWWkzkwXY/lTnYziWljImKKbKwTqqm0NhErJSHtSlKsOUpsdRmUFWeVpYAPfhQ/v8nvd9bTueuvvLg7l//oNLD40C1ShSq98aLjFg682Sm/yVyP93IsW/pIPnniCpzNTqMVSCaJGfjEFmv6J04d/ufQI7AjNlSHaCPXzdd6JioqygVS3pEu+RhDVJBCVhwtJefM621ViDbL7PkD6gU2vhqcyAIdE2DXOf7IMcKtCq+JXmvlzYXatfekuoMVwD1uKBUJn0UrLMF5I/4kQsgxGM+zHLJmahI7
 zJ95FDTt
 bLQ9RDIDEllJIDjU3ODVLbOMIMQPMCNYfvH1r4bRTXI8yg8S/BWhiSPr40CrFPg85EHtblgcbBU3HoILzRHo3jz6cPXwrav+HqXqxSrVPzq2oTLhMtQHMAsig+C61d1pTL1sLWetjxzK+8iceENWnEFbvWh7q4snQ3O/q7Cxbx2MGcK6DbawsL6eweTEnxukOkf+5F8EDS2hvGwbhx9PaKbtEkbgShE85gktUN+8wZuAjmxIjRWDgjw9cqjIhInJ4sn0UJUCM2SWhdJ5F7fPrQyfDzn9Eh/i3qJ+sM7cC+rYMdVI8+LdqaQCq44gAeSjxgH9VUpD1JkaXAyybZFH9VanoAJtX5IXa8gOmU1l8dBgCNSoKmZMS1yBK5bkcCc8lqzqFD/d8US9Ec8DlG0rnrHKbLnrgrSJQh2NBF2WDnkR8RHvv3UAAq5Db18E9KF4N56uTEYr1isINK/vCgzDkTV0Gdd4hqAAiL/o+Ka10uW01TGD5wU98SjieTV+sZ4DNG6qp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On 17 Nov 2025, at 07:08, Oliver Mangold <oliver.mangold@pm.me> wrote:
>=20
> SAFETY comment in rustdoc example was just 'TODO'. Fixed.
>=20
> Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
> Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---
> rust/kernel/sync/aref.rs | 10 ++++++----
> 1 file changed, 6 insertions(+), 4 deletions(-)
>=20
> diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
> index 4226119d5ac9..937dcf6ed5de 100644
> --- a/rust/kernel/sync/aref.rs
> +++ b/rust/kernel/sync/aref.rs
> @@ -129,12 +129,14 @@ pub unsafe fn from_raw(ptr: NonNull<T>) -> Self =
{
>     /// # Examples
>     ///
>     /// ```
> -    /// use core::ptr::NonNull;
> -    /// use kernel::sync::aref::{ARef, RefCounted};
> +    /// # use core::ptr::NonNull;
> +    /// # use kernel::sync::aref::{ARef, RefCounted};
>     ///
>     /// struct Empty {}
>     ///
> -    /// # // SAFETY: TODO.
> +    /// // SAFETY: The `RefCounted` implementation for `Empty` does =
not count references and
> +    /// // never frees the underlying object. Thus we can act as =
having a refcount on the object

nit: perhaps saying =E2=80=9Can increment on the refcount=E2=80=9D is =
clearer?

> +    /// // that we pass to the newly created `ARef`.
>     /// unsafe impl RefCounted for Empty {
>     ///     fn inc_ref(&self) {}
>     ///     unsafe fn dec_ref(_obj: NonNull<Self>) {}
> @@ -142,7 +144,7 @@ pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
>     ///
>     /// let mut data =3D Empty {};
>     /// let ptr =3D NonNull::<Empty>::new(&mut data).unwrap();
> -    /// # // SAFETY: TODO.
> +    /// // SAFETY: We keep `data` around longer than the `ARef`.
>     /// let data_ref: ARef<Empty> =3D unsafe { ARef::from_raw(ptr) };
>     /// let raw_ptr: NonNull<Empty> =3D ARef::into_raw(data_ref);
>     ///
>=20
> --=20
> 2.51.2
>=20
>=20
>=20

Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>=


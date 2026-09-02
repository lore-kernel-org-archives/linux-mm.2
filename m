Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 715EAC624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 12:58:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F64A6B00E3; Wed,  2 Sep 2026 08:58:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27F396B00E4; Wed,  2 Sep 2026 08:58:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 147466B00E5; Wed,  2 Sep 2026 08:58:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 92AF76B00E3
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:58:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0386C1C07A7
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:58:12 +0000 (UTC)
X-FDA: 85168825266.22.355F14C
Received: from sender5-op-o11.zoho.com (sender5-op-o11.zoho.com [165.173.182.11])
	by imf30.hostedemail.com (Postfix) with ESMTP id 02B4F80004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:58:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=d48l6CX7;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf30.hostedemail.com: domain of daniel.almeida@collabora.com designates 165.173.182.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788353891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yOJpG0Rfo6IlzDSpX446zUyUkwOc+K8U7rIyIPg3QS0=;
	b=GdzHLwrPkczGWCXloTWqiIE/IZm+iAZq5OpkPGjkik4XQNIdZdt9MJ3BvKsSnfJuFuS/iL
	Cf16Oc8tHJIKU0K5R6Jpt9yboJh/HvpZrrY8d2OkFXBhZ8GfRnhjqbGTqYtF6snnl11okf
	IUwysBHscrvM8O/a0ZzwGZH8fNgeCeU=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=d48l6CX7;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf30.hostedemail.com: domain of daniel.almeida@collabora.com designates 165.173.182.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788353891;
	b=y3ZG9su2tVhCUpQm+oHTN1J1Iy+jJ6yK2VOCTQVnCiAtVRdpAR4DB3a0IlikTfjdeDjQQC
	fLHjipDr/Vrd1xGp/4dY+nkR08xwWmF2AJGCHaTStIW4dzNnOgIAcqF7GCri3P989Jt9rj
	lugi5b0RmBtDswlISfPQaMSR2l3knxE=
ARC-Seal: i=1; a=rsa-sha256; t=1788353881; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=TNfp49qO7PvOKNrTb6rndr+1NMxKl8IzE8OWTqpiduwHmBiqwHZu77OMJzQLoyz3PJB+m2ETbNBw+pv4/t52VKTZ0vTMn9yCEa1ExY8rnSeNfuSrJ+UNRKZDtkuvLBCBC4VbSeNJz0l4Ae0Oyx9RP5J3KREsjxDm4gMfEQcu7nA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1788353881; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=yOJpG0Rfo6IlzDSpX446zUyUkwOc+K8U7rIyIPg3QS0=; 
	b=AV+jSc3gRzrEMCHUncWW7+ysFtx3SZmYHcLgRXlbdQmssLzIGTAM1nOHPONIFrLm2w2AvJCp3E+tyBHllmY2P5jnLyUvPk4mxIUrvrQ3WUjQF7YeBPqG1heA5odwGnaY7ihzN+kjgk78goh4rF+3reBje8BnfbPmwtW11pIhy4k=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1788353881;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:To:To:Reply-To;
	bh=yOJpG0Rfo6IlzDSpX446zUyUkwOc+K8U7rIyIPg3QS0=;
	b=d48l6CX7/B2l24rgs+6vOh9aeKM9cm/DHx9PAp2TYn2ySkldkxFkjjMPlTUfzJEK
	ru01TAWEMCPhB6NaP9PLQW3uQMimZNTRjiReYBEomoI92TcwQXjvvbAXtfg5wcl7ySz
	UIAIe2cHFjzuSw79RLntBIQ/S0o4fhYWJI18WYvY=
Received: by mx.zohomail.com with SMTPS id 1788353879250420.3222580292204;
	Wed, 2 Sep 2026 05:57:59 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH 1/9] rust: sizes: add SZ_4G constant
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20260902-tyr-ioctls-v1-1-e0fdbf8bd108@kylinos.cn>
Date: Wed, 2 Sep 2026 09:57:40 -0300
Cc: rust-for-linux@vger.kernel.org,
 Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun@kernel.org>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 Tamir Duberstein <tamird@kernel.org>,
 Alexandre Courbot <acourbot@nvidia.com>,
 =?utf-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Lyude Paul <lyude@redhat.com>,
 David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org,
 Alvin Sun <alvin.sun@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <39DEB659-59A2-43D6-9B62-805DB3715F49@collabora.com>
References: <20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn>
 <20260902-tyr-ioctls-v1-1-e0fdbf8bd108@kylinos.cn>
To: sunke@kylinos.cn
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External
X-Stat-Signature: xofqcfhpsdkeao1qu1snysoaps4h5ydi
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 02B4F80004
X-Rspam-User: 
X-HE-Tag: 1788353890-939096
X-HE-Meta: U2FsdGVkX1+I1OFq7EyjBxlVZmVurTMr3aIpxsPoAh0jyNc/9ob6QZG262PHabiNtJMTvl7d0+cen4pU5jRJY965bmVlJZqLt6QRia/28SNdxqr7YUFJs7Zg/Lp9T7DuTmyza1RBQeYoQfGCialSSSSziT6LQV1qSlAyPde79zEtrvKE1CBmZntlJiqTy4Pc9hKIEY7AUWqoqKlcyfOW4Wf4gl35ujGmTEu+BONOxA8V/sqVJhZrYI/T9hWgnWYp0lOSpUGYjKywIslEEgEmAWO+Gmcn4XjSoxGzjlsVoiqqzhKpJJWoLQ3tH9fxBuGj1b5gMsEVpslD32OBX/guatJvBSLHb1Y2gPlI7hj6JS+cy6/MZwtrnnzV6n+BdDZBF7gu7RpY/an70pS9LJYyexrJRnx8G1eK2KpvanzN5V7lzTTRsKzZUAma1Q+Zog1n1j7WAeOWEtOcWeqy3WpvTk2UwZma0RP61Wz/PiyuAlrLixTtFI2T8n7htLHM1eZcUHAM+2jc1S+FKdOmkAdP+bvD5Hj/nzobTuLoG6ACwwRXShCvGwrDraQ9csgxQTUow8Vy+Ax6o3X5Btp6lwtnL3anCfzD3wqJ1vPpqT758Q9cp8dm32xuK/xQtDGz8PJGnGnX+j6aUZnXYkuDFipFOwv+nZes0A6zbN9XeAlbWG7XcjIamAaeoQpBF/B1XY3GBFEl62pD6iOOOkE/6eDiZw2GpRYBCf8s4hPxM0TwcLdwMVuKAdJxZHy+YE110gi5iZZBiaoeytCnp91iquB6pXUWJFEdFqesaaULyqLb3Htx1ljyTuNxEl/wm+XrUq+WG2GlPKIAaO3LcE6hD4/QfztdcarvQYIJ8ooVte8CVwEHMXSacesC/0635NWYv4J5NYmp0tLpz4QLWVBvKWukm8rQJ5g1FqZe/FCAfCF3BZUG7LWfUbQDTgGrP5AlygRqZxbvuLdUNzC4bvnGph+
 oyiul9dF
 qv7sU7ZuD4fk+Yze4AG7wc8eEqh7d1ER7oDyUhJoYEhUN0yXJ7GMwCAXq1p1Tj6H5OiMG55ti7hITeCmLHhpw8SSvgf+LU7lj3Aznb6GbhtQUS4IBZmwkse/me453HlsEU5lNFdXD3f4laCFPJRYa3Pfl1OAbxrLN7XhQkfKpbqfY8rDB+2osBpnaEyq0npi4RwXX8HgWPc00lfC1YMu/CUBW1CfQ5ZiMQyw9e1Gk998l2crPdOM38SASpTfL4kXMJ/fwyopVRd6Y82xoWIfZq/ilCh1daP1PooGk4SeKfKAlndw05E3/83yA37aaK226cGvisbMNrZekLfW0wYARvkieDy3u+eg4D7CUwuK0TkC8Lq/r+8cFSJgvQLfof02nDXgILsPZJXd7Kbm/7Vh43swGvvrWVUOw3irHfDaBwKyj3ZVdaGKiuZ4BjasS+sBPcIDDtcf3/ttFZdWDQY7RzIPZACdMCLMAJUtA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On 1 Sep 2026, at 13:09, Ke Sun via B4 Relay =
<devnull+sunke.kylinos.cn@kernel.org> wrote:
>=20
> From: Alvin Sun <alvin.sun@linux.dev>
>=20
> SZ_4G is used by the Tyr driver when splitting the GPU VA range into
> user and kernel regions.
>=20
> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
> ---
> rust/bindings/bindings_helper.h |  1 +
> rust/kernel/sizes.rs            | 12 ++++++++++++
> 2 files changed, 13 insertions(+)
>=20
> diff --git a/rust/bindings/bindings_helper.h =
b/rust/bindings/bindings_helper.h
> index 1124785e210b3..3c37993991b1e 100644
> --- a/rust/bindings/bindings_helper.h
> +++ b/rust/bindings/bindings_helper.h
> @@ -110,6 +110,7 @@
> const size_t RUST_CONST_HELPER_ARCH_SLAB_MINALIGN =3D =
ARCH_SLAB_MINALIGN;
> const size_t RUST_CONST_HELPER_ARCH_KMALLOC_MINALIGN =3D =
ARCH_KMALLOC_MINALIGN;
> const size_t RUST_CONST_HELPER_PAGE_SIZE =3D PAGE_SIZE;
> +const unsigned long long RUST_CONST_HELPER_SZ_4G =3D SZ_4G;
> const gfp_t RUST_CONST_HELPER_GFP_ATOMIC =3D GFP_ATOMIC;
> const gfp_t RUST_CONST_HELPER_GFP_KERNEL =3D GFP_KERNEL;
> const gfp_t RUST_CONST_HELPER_GFP_KERNEL_ACCOUNT =3D =
GFP_KERNEL_ACCOUNT;
> diff --git a/rust/kernel/sizes.rs b/rust/kernel/sizes.rs
> index 521b2b38bfe77..b236573f0792e 100644
> --- a/rust/kernel/sizes.rs
> +++ b/rust/kernel/sizes.rs
> @@ -132,3 +132,15 @@ impl SizeConstants for $first {
> }
>=20
> define_sizes!(u32, u64, usize);
> +
> +/// Large size constants (=E2=89=A5 4 GiB).
> +///
> +/// Only implemented for `u64`.
> +pub trait LargeSizeConstants {
> +    /// `0x1_0000_0000`.
> +    const SZ_4G: Self;
> +}
> +
> +impl LargeSizeConstants for u64 {
> +    const SZ_4G: Self =3D bindings::SZ_4G;
> +}
>=20
> --=20
> 2.43.0
>=20
>=20

Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>



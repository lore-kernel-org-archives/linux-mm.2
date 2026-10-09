Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81E0FCA6019
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 14:29:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C7266B009F; Fri,  9 Oct 2026 10:29:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99E826B00A0; Fri,  9 Oct 2026 10:29:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DBB56B00A1; Fri,  9 Oct 2026 10:29:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E8A76B009F
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 10:29:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2A3EE1A0416
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:28:59 +0000 (UTC)
X-FDA: 85303319598.27.8DC5A00
Received: from sender6-op-o11.zoho.com (sender6-op-o11.zoho.com [165.173.180.11])
	by imf16.hostedemail.com (Postfix) with ESMTP id 39116180003
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:28:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=W3TNU13c;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf16.hostedemail.com: domain of daniel.almeida@collabora.com designates 165.173.180.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791556137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zVbWP16VRMrWp/DvVtxAnr3TU+v7W0tYlq0ED/T4l0U=;
	b=cBojAyM/IoOPSvNvd58pjbbmRuy/xH/Cpb1SjEjhaNkBq30+0QhoItIEm6oqtWiR0Ay+Aa
	zShAUH8WP0+idsLlF5bH0RxrdoXODryqg4QY8ozlgIEk0tBvmir46pX7+4d3hIfeNP58DI
	v0Ky1cu/QVPSwSXC+Zp+P4rhG7BTGEE=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=W3TNU13c;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf16.hostedemail.com: domain of daniel.almeida@collabora.com designates 165.173.180.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791556137;
	b=uVJ+6JrYQlzdBmf8QjNMmhdBup04CjzpkylX7+xCZDb/A3Z3xRtTTeITdT91bwOIUBzfNo
	BKbm6kQ7TRgxH5HtdDNoqq6hU+dzWg3Rv31d9fYjkEkZLsOGVAbwuQy6BfXZKB4ZXsUTUI
	x7jf/N5z1M00Yyv/39Mdsdp7LwCFPxc=
ARC-Seal: i=1; a=rsa-sha256; t=1791556129; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=fEpcfuCdyTuAeNVDN5w3gTdg4iVSczsygLIQjzPSzP2cQiuZBlRjpPBYY11ebxXvTfdmaVyb4KDAcDpv443k7DkPjdlZCbprA4YXWoNnt9F+Cdgh9hqmup+dHCgrWJz8uLkRsNsjIYboC18oaEhjmkf4BAiWcwqwmwv+TbdPGxA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1791556129; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=zVbWP16VRMrWp/DvVtxAnr3TU+v7W0tYlq0ED/T4l0U=; 
	b=csy4qDpmoMmAT/bHWKkhtnFb16J1DpyFESqr/Yc9HJ68+x549k8mWsSMUx/FW+9c93e9qASItOCLZmrhoN8qZEdp+YDebB/M14jpjBW0EhLLXCQEht0vmQSfgVsheiV5b+f/VQ3SOE/onJ3sPh9jas1GziXPc7mrjt37Sa+bkVA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1791556129;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:To:To:Reply-To;
	bh=zVbWP16VRMrWp/DvVtxAnr3TU+v7W0tYlq0ED/T4l0U=;
	b=W3TNU13cRQ1sXBYnikNHNpwESMYtfMCVCptTvukXjQopCaVz30kYiRXXJwSxKmWt
	a8dRgoGRAb866GgHV73oe93zM/xKV3cXEK73TfAOIR5IW2Mw35SlQVBtsJKV6XRXN2z
	FluNH19L8taDBquVPfhF/o56pqbKYYIpOhc02YRU=
Received: by smtp.zohomail.com with SMTPS id 1791556126179586.2419855994772;
	Fri, 9 Oct 2026 07:28:46 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH v3 06/11] drm/tyr: add BO creation and lookup helpers
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20260929-tyr-ioctls-v3-6-26955fb111d5@kylinos.cn>
Date: Fri, 9 Oct 2026 11:28:29 -0300
Cc: Miguel Ojeda <ojeda@kernel.org>,
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
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>,
 rust-for-linux@vger.kernel.org,
 linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org,
 driver-core@lists.linux.dev,
 Alvin Sun <alvin.sun@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <84ADA150-9E7B-4EF9-ABD0-377E9746E293@collabora.com>
References: <20260929-tyr-ioctls-v3-0-26955fb111d5@kylinos.cn>
 <20260929-tyr-ioctls-v3-6-26955fb111d5@kylinos.cn>
To: sunke@kylinos.cn
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-ZohoMailClient: External
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 39116180003
X-Rspam-User: 
X-Stat-Signature: od9ydpy9sax7bwrgzfmi5q3ktn4sqzpo
X-HE-Tag: 1791556137-315481
X-HE-Meta: U2FsdGVkX18OONa2cyHofhPIeUemJjI5xecEx+l0rT99xY8ZPBByRRGDCUbnvmmTXqhg325bZe3L+Kk48bsaEJqmybN0C/F2Sxc7BchbPVv7Q2Y4FT5tOYxuJIJekGk7L8U6BRBrwkTIPcqtcWRBt3hhoebS9MqBAob9QWYhRvY6FBpgpXFZqtLFNlC9qawdz22VSuY+1hulA0HL1VI+M4xxNfuqGaCJlQsdbunSOuno20pdA0cpcXsoS5+NjHKfHqjz6w5qZ7B3+Aqj04UEYyFfM23LKeHbSi4qAYzo4/kwDezr4Jb+tOJSSbATgGbJPqjKWY1FLF6BaD5QpW27Ifs2u+TfA+nlgmTxQLnzH5+35kC6v4K3vS/QXpyAaKAR/+O35gNwRqi4KvCxZszaF5NxBH+N4IBidbd+z4doKpA4wsr81DHIPYlxFBz353bJjM6Gg5y6a7VOGM7rnz+/VAWwwU1fKgPWUd/RhGD1PuD9h1Uoz5tOrJBntNRAQ8MNyt6UcImaL33K9B9C+FiyCgdlmf/iYY9539NmrLhEbagywCpWIUQV/8iE7kRaxgmyFiEhzfpwF+1rVnXXs4MDhQtBIg9VUsHoXX9sEL6R5/qgBri1nnP0He5YAkfWv/D8YZ6mARNKsEtLVvAV79TFCcZ3eQ+B/QuZYt17cp50vSX1YA7NR2IWxgKWlkhHgP0rZg5SE0nIWGJ7PJTob7QoxUSkdA/T2fro+BGpBVkKY5t2CUwzoNjWPsMI/l2elgTqTfgVdUQEdcwj+tr9ZEh0B/99X0JXUtGYAxvvL7DsLPYzolxFEuysOB6LFO6QK9l5fXJUzEb01w8YWOaThRVV2uyrzcqXcbMx5baYI3bJ+Z3kzs0cD+K5F6arG0zxBgqwM2D5gPlSsAS/qkGKvk+yNIB+DNIFabyJGo2cA/vdb8Jttr47NHSaVU+Hrj1X14hRxYwahda5Sd1TYHEM7gV
 BWsw6U9h
 HR8YlPMa0b8MISqIpemCmvhnZ6UhZz9ok60ds0OssSSPnCbVcBcTw5+rd60g+uyUHxvaxS1K9QE6om7gyStxDtKdRXv6xkoMTUqnUAUNP7imPB63ZlzwFZkgK1doyTOBrhMGF36qpdo9bAxgc2AupkzF7CJI+ZVbh7F5L5q8CFXrEjMgemgK7g2NDIsm2OogZUF0osPLFLTq0gsLNWA434AEeFAlEZSCaiAwCISpTOgNG/xs7Q7ul4p61+4Sjc/j4eHpzJtEG2f2QYuGYfkOXRZJCdyAGDz7inP8+500Q28nHU5INWyEJsABit2ruZ+8Y2rB21HR7mE1D8n8QFVs7p0HmTCH8bYeHYFu1EB1+a/HdJym3XMVQCzQi8EDYY74XivLKszvDGmeonRjtfoihjsJCKaNbxGUbXcmc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On 28 Sep 2026, at 23:15, Ke Sun via B4 Relay =
<devnull+sunke.kylinos.cn@kernel.org> wrote:
>=20
> From: Alvin Sun <alvin.sun@linux.dev>
>=20
> Add helpers for the BO ioctls: new_object() creates a GEM object with
> the size aligned up to PAGE_SIZE, and lookup_handle() resolves a =
handle
> for a DRM file.
>=20
> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
> ---
> drivers/gpu/drm/tyr/gem.rs | 31 ++++++++++++++++++++++++++++++-
> 1 file changed, 30 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/gpu/drm/tyr/gem.rs b/drivers/gpu/drm/tyr/gem.rs
> index 3bf3787f5c3fd..0e0989a48678f 100644
> --- a/drivers/gpu/drm/tyr/gem.rs
> +++ b/drivers/gpu/drm/tyr/gem.rs
> @@ -9,8 +9,10 @@
> use kernel::{
>     drm::gem::{
>         self,
> -        shmem, //
> +        shmem,
> +        BaseObject, //
>     },
> +    page::PAGE_SIZE,
>     prelude::*,
>     sync::{
>         aref::ARef,
> @@ -23,6 +25,7 @@
>         TyrDrmDevice,
>         TyrDrmDriver, //
>     },
> +    file::TyrDrmFile,
>     vm::{
>         Vm,
>         VmMapFlags, //
> @@ -53,6 +56,32 @@ fn new(_dev: &TyrDrmDevice, _size: usize, args: =
BoCreateArgs) -> impl PinInit<Se
> /// Type alias for Tyr GEM buffer objects.
> pub(crate) type Bo =3D gem::shmem::Object<BoData>;
>=20
> +/// Create a new GEM buffer object.
> +#[expect(dead_code)]
> +pub(crate) fn new_object(ddev: &TyrDrmDevice, size: usize, flags: =
u32) -> Result<ARef<Bo>> {
> +    if size =3D=3D 0 {
> +        return Err(EINVAL);
> +    }
> +
> +    let aligned_size =3D =
size.checked_next_multiple_of(PAGE_SIZE).ok_or(EINVAL)?;
> +
> +    Bo::new(
> +        ddev,
> +        aligned_size,
> +        shmem::ObjectConfig {
> +            map_wc: true,
> +            parent_resv_obj: None,
> +        },
> +        BoCreateArgs { flags },
> +    )
> +}
> +
> +/// Look up a GEM object by handle for a DRM file.
> +#[expect(dead_code)]
> +pub(crate) fn lookup_handle(file: &TyrDrmFile, handle: u32) -> =
Result<ARef<Bo>> {
> +    Bo::lookup_handle(file, handle)
> +}
> +
> /// Creates a dummy GEM object to serve as the root of a GPUVM.
> pub(crate) fn new_dummy_object(ddev: &TyrDrmDevice) -> =
Result<ARef<Bo>> {
>     let bo =3D Bo::new(
>=20
> --=20
> 2.43.0
>=20
>=20
>=20

Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>



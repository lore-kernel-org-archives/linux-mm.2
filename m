Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A58E5C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 12:26:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A74B36B0088; Mon, 24 Aug 2026 08:26:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4CEA6B009B; Mon, 24 Aug 2026 08:26:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93B3B6B009D; Mon, 24 Aug 2026 08:26:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 579636B0088
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:26:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C1E838011A
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:26:16 +0000 (UTC)
X-FDA: 85136085552.08.A43965E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 36AC9120006
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:26:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PwNPX2NR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ukleinek@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ukleinek@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787574375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=upukaXZkr84gwak4ggRO0ndAK9t7zaBT3owzkfM3Fdk=;
	b=KBUqSRCWxP3cU7IJ0d2fr7PeTbUd2rVMWc1gkaDzVwu9jcfqgeEdrp0JDApQFjrGvZ92Ln
	0lb3ygSsG7qR4N5k5z+O+4sJsZwjAJBcKGIgIFqBeb5GVAcQIOOaK7QS5sIndEH5JwKVfJ
	unaYmGfYB/87ugrbrkHS4ALVH0s2SjM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PwNPX2NR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ukleinek@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ukleinek@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787574375;
	b=auZ/2dsveXzC8uGaoBeTGthAg98ThDuY6K+r3aBYbvLXcRcpY80xZtfv9fFlC5iITBG2Cq
	iCVwyANYXyOqFrTPm1HiYBBwRyDxcQBfbmGvcDyXjygHCFymYUbu3Ymk+goFk+Vp3JAYMc
	aCQx+o190CbKsLVpgubyNDlZYPFnNw8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 676C4601E9;
	Mon, 24 Aug 2026 12:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 874ED1F000E9;
	Mon, 24 Aug 2026 12:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787574374;
	bh=upukaXZkr84gwak4ggRO0ndAK9t7zaBT3owzkfM3Fdk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PwNPX2NRFVN0Bz+S6KhhJDxiLSSZueaI23ct1PXVX8KFblpux4F/bG76u6TxrwCtv
	 UBlSiGxKVvBTRYKxoEml8G+yJNr5LUcxCVHAJkkApNdp1pLMOe/M1VjBTgCXwU7U6V
	 5IgTBRfAEyOLQqvyJJiMl62FQy0LIfHZ1uydX9Y4AhNiRmTr2057vOspY1cC7nY6+Q
	 qZ3KAqtRYMVxL80qEDUwO6SUdJGBXEpXuEZNK6b9Z8cRlU4tajvzt2DKIM8cr4Vboc
	 q/Ct4jN9XMSxR0SxukEoUtbJdV8txAyM9aXphiu3NaGi6TMPM5g8mGMXa0XMTMt2gj
	 F9NjqiDJeK5BA==
Date: Mon, 24 Aug 2026 14:26:11 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
	Gary Guo <gary@garyguo.net>, =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	Onur =?utf-8?B?w5Z6a2Fu?= <work@onurozkan.dev>, Lyude Paul <lyude@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
	Carlos Llamas <cmllamas@google.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Dave Ertman <david.m.ertman@intel.com>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Igor Korotin <igor.korotin@linux.dev>, 
	Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Michal Wilczynski <m.wilczynski@samsung.com>, 
	Ira Weiny <iweiny@kernel.org>, Philipp Stanner <phasta@kernel.org>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	driver-core@lists.linux.dev, linux-block@vger.kernel.org, 
	linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
	linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org, 
	linux-usb@vger.kernel.org, Oliver Mangold <oliver.mangold@pm.me>, 
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH v20 5/8] rust: rename `AlwaysRefCounted` to `RefCounted`.
Message-ID: <aow36NjRc5Ig0hG8@monoceros>
References: <20260824-unique-ref-v20-0-490735672187@kernel.org>
 <20260824-unique-ref-v20-5-490735672187@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nwuv4cl3v42iarkt"
Content-Disposition: inline
In-Reply-To: <20260824-unique-ref-v20-5-490735672187@kernel.org>
X-Rspam-User: 
X-Stat-Signature: 47x6xexhmqjysz3x8ju84srwhbc8m1nn
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 36AC9120006
X-HE-Tag: 1787574375-933372
X-HE-Meta: U2FsdGVkX1/5pBFAtYP8ELwM+FletOhra+6HXm04eSLL4D/gKaNvoTE9J5wEXkMd4G7+IKM2FLdDDTl3Tv5GzlOzxejif6eXe1GFNNMX2AD2N6H4a4Akj0jZt92Dk0wej6P5XhZCgEJ1khqyRrw/gq0Amwzhv6JfsWWMC3JTTuhMu7+gg5A+7puPC5D8vcpYh4RCi1ftth+nfpCdIv0TU14cCptMAjqdNH9yH8kkzN5kQ2mqGR8HZ7SNPvBlLceQWIdu9vqbcp68iwBGzQOeGRKmslXXJxlkKlVdYm7nnAahuz9nypXY3XHzdYADtcoqKbyRc4xV2Z+07RqF6NwfsolJxezgzGj48YMpN/PXiRhstzuALc+WwepMN9/GSCS97cfYX9L2nD2WmE7F/KLoEPD9BA+0GQ1LHD2lYLXS9fXe3k0z+QL/FSLF/5/vNWtzSUtp4aSw8bxLnofEPV0Mcyezv3h7igfw8/3PCWjA8jMhbAtlinnVvbQCVGpoxuS2zEaVVWk23fs0WIUyKGUCPgOsROe1bM6dOICxeT8HhO5tUCiwhW9xc61qLWrOCgtlMWUEUjq0kksHjTc/uaZjpEZcHXF/c+HlgRc+xBh+l5Hxi8jVCFBtmsRLZfwv5QMy/hwRp9QCoazz8qPWOkp2l9P89B7W1SccEEYjFkjFj1mjnUrrtDGu68yFQSPLiPkmn0P7VVCpNP60ZOkReIa6GTamD3RQqbFnVtx6EkpHAnHnv4h+ccWDX1B478etgl6li+vULQnpJL0h108L48un2Q2GFg9DDVT4fpmnvZ+Ihhrv3YYXf71mWClWd6zoiw4pveeiFoTSCdf+rmCgyEDBfoGt22fSq5g5aycc4nto090X8l3225X9uMbE1MsYaAC8MW/O4fATuia/izZkZIFeHyx2TjTMVlVdGO/98DPEBqkp2nCXVGah1Ipu2NkhglvEimlMotwpcYxcSsDpx/O
 fVyI9y6p
 XuRIPCIeWPr/8HYxJvSc0Pdfo1BljsIQ2X399jhbRbLPB68eYji+vYGiGLWv3yc8dLfEjkUyyLhy+j1Q8ZgCreSBcz0pMtXBL95YUiKbbro55nJFA43wuQmHDeTEd2zGTWzcU/dr951wSu8qMFGpSgSb7htRmLthF283Sro/gnuCII5i3tJaJTM2wpXBoW1jeFvXJIkSu3M3COQMej/DvmnkAmYv1tZvI/5SufD26cwy93DveMq9/efBYdE/Sg9sRcAfr+jwCiGw6aJpGZjf6NEMVniYPzdRx73UnLLiTY9PDna86UI3axZKsFMq40UoWetP9C5UE81ugvBi64s91hoAPMcbFhAHT5yUkdzb2SwD5sF8HwIOuHpSeuMYHxpNdDC8r7z27wYCx8DY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--nwuv4cl3v42iarkt
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v20 5/8] rust: rename `AlwaysRefCounted` to `RefCounted`.
MIME-Version: 1.0

Hello,

On Mon, Aug 24, 2026 at 01:17:57PM +0200, Andreas Hindborg wrote:
> diff --git a/rust/kernel/pwm.rs b/rust/kernel/pwm.rs
> index 6c9d667009ef7..2d1cd74dd98e1 100644
> --- a/rust/kernel/pwm.rs
> +++ b/rust/kernel/pwm.rs
> @@ -13,7 +13,11 @@
>      devres,
>      error::{self, to_result},
>      prelude::*,
> -    sync::aref::{ARef, AlwaysRefCounted},
> +    sync::aref::{
> +        ARef,
> +        AlwaysRefCounted,
> +        RefCounted, //
> +    },
>      types::Opaque, //
>  };
>  use core::{
> @@ -629,7 +633,7 @@ pub fn new<'a>(
>  }
> =20
>  // SAFETY: Implements refcounting for `Chip` using the embedded `struct =
device`.
> -unsafe impl<T: PwmOps> AlwaysRefCounted for Chip<T> {
> +unsafe impl<T: PwmOps> RefCounted for Chip<T> {
>      #[inline]
>      fn inc_ref(&self) {
>          // SAFETY: `self.0.get()` points to a valid `pwm_chip` because `=
self` exists.
> @@ -647,6 +651,10 @@ unsafe fn dec_ref(obj: NonNull<Chip<T>>) {
>      }
>  }
> =20
> +// SAFETY: We do not implement `Ownable`, thus it is okay to obtain an `=
ARef<Chip<T>>` from a
> +// `&Chip<T>`.
> +unsafe impl<T: PwmOps> AlwaysRefCounted for Chip<T> {}
> +
>  // SAFETY: `Chip` is a wrapper around `*mut bindings::pwm_chip`. The und=
erlying C
>  // structure's state is managed and synchronized by the kernel's device =
model
>  // and PWM core locking mechanisms. Therefore, it is safe to move the `C=
hip`

I don't understand that, but if this is considered ok by the Rust folks,
I'm fine with merging it via their tree.

Acked-by: Uwe Kleine-K=F6nig <ukleinek@kernel.org> # for pwm.rs

Best regards
Uwe

--nwuv4cl3v42iarkt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmqMOGEACgkQj4D7WH0S
/k7Eqwf+MmntLyABjsJ6u3n0tfvFXtT43FkhKWBYTvfrSkkGSwvZSD/ZY5rm4TJa
bXNvGj/meY+tjoiL+lqEl91gKDUE91djmvVcfXDoceliQzIKh2cKRqYubSng7etR
4cjqGN+2sGoPMqw/DE4AHSt6FjN7PW9atWXCHSqgj1X59q+Il9zzPvJoUf5LoJGl
M03B0IF/eZP8vEHvwBR+bKlVqdJnU8LD7vn7fYKS9w8EcXVmRNet0ARjs8XnIUhd
mRyFbmkqewycYxQaQdFwYsqkvc+ZdQfjXofOkRIorYXk2OXiZy3oqy94wwwiGntm
xaLKESdeyy1mp9Q0CzYXHqcQr8nU5Q==
=h9TM
-----END PGP SIGNATURE-----

--nwuv4cl3v42iarkt--


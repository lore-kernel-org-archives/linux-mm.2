Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52489E9A03E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 10:57:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AD7F6B0088; Wed, 18 Feb 2026 05:57:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45B556B0089; Wed, 18 Feb 2026 05:57:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33C9F6B008A; Wed, 18 Feb 2026 05:57:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21A7A6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 05:57:03 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 926E216051C
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 10:57:02 +0000 (UTC)
X-FDA: 84457275084.15.77E71CD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3A48A180003
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 10:57:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Sv3K2P0t;
	dkim=pass header.d=redhat.com header.s=google header.b=Q8uMN6Ml;
	spf=pass (imf06.hostedemail.com: domain of mripard@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771412220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g5EhFzRS9kh8aYP/2UGoHhJQm5CJn7dpEnQsAb/ZMSE=;
	b=bJLFg8GbOckNEMjvYZNm7k3vkI52I0E/Wy0+ULSLsQZ9EeHuEDEy00z95CGUlm9ekQ8byV
	rulO+2otByD6HOiMiO9yqXOobXI+EAvfy/20iv2DCMk4O3Jrr45uNwSgDfO+yjcsoB7/h9
	mvYVCO9w0rog4o/hGt5BC3SF4kH3mQw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771412220; a=rsa-sha256;
	cv=none;
	b=k8GMpwn+2dq9ApV7qe72gF55OYRrTbaboQ2C94VYMYi/cniu9D/dojEtCaXmhEXuGYKEyb
	U/R5p8hc+G8q2xbSRSEbRm1RL73XRsCWc1OYxjEfod9RBHFIt065fh7tU9jALYYiu66qmc
	gtaerg0090NpvGVdDi3/ghdER2W80i4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Sv3K2P0t;
	dkim=pass header.d=redhat.com header.s=google header.b=Q8uMN6Ml;
	spf=pass (imf06.hostedemail.com: domain of mripard@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771412219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g5EhFzRS9kh8aYP/2UGoHhJQm5CJn7dpEnQsAb/ZMSE=;
	b=Sv3K2P0tLjp/fD8MTvs6Qtr339S07Etzwh3yEteoclMgMcwz3H1YIl0dNPdgiAeazYeFPf
	qIiu2VHdnfawPYCZgQUMEBGgdoM/mwif/vLfpSEnZQhKYF/S31SJP+BlJwd/osWfhnCrv9
	eMbaYNVBd07yJBcOoXmnSAZBZYZ9dmk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-8G3dsfVsOCGXkHPbGPj-OA-1; Wed, 18 Feb 2026 05:56:55 -0500
X-MC-Unique: 8G3dsfVsOCGXkHPbGPj-OA-1
X-Mimecast-MFC-AGG-ID: 8G3dsfVsOCGXkHPbGPj-OA_1771412214
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-435af2d3144so3720396f8f.3
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 02:56:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771412214; x=1772017014; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g5EhFzRS9kh8aYP/2UGoHhJQm5CJn7dpEnQsAb/ZMSE=;
        b=Q8uMN6MlvmESCEHa0eJTj6HwMDP2nTmJdz3EZpvbrBtmuQEcFW5BEw+e0dPiYeOkzu
         rjKjwFQAwEo+jPS00pjP3QGAl/7TCmaymDxVbCmt4hJ3nUes8lKtV3a8hhIuusRMld0W
         SfkxYjIVrzEsoQewOi2VtT2eXOl7mJHMkpeYxGGDFJ6UV/5yX5i6wclyea6pGCrXcky/
         adtBb03mINyMaP3612r547aO9LJRB1SyL7LQqIj0G2+fyReT49SUW3/7YS44svndp1XK
         59/R1W4lmJ5f8sulel1EZ3NgYMoWTAS6NuCNG+GVOd8qSmnkm9puSzEGCcaBsodZj8qV
         foFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771412214; x=1772017014;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g5EhFzRS9kh8aYP/2UGoHhJQm5CJn7dpEnQsAb/ZMSE=;
        b=ePFfib3N1dTKbVS8W/sMayPRiKVETp2Xm6LbBSQpzZ0IoHWb7mHwEnQQjx5xr4fAZr
         RSBbL0G4HV3+Sx9Iwn6oTkZIjilTHQ7P3I+T0x4KZfVDzXIyW6JVNDBTntftzEofXp/d
         3Hey1Gbg27dJ7cuKonlfAEHHyEEPiz1JU2DUnJiWhGnE+Hbj71Q8xvbyJKotoNpIBdta
         bEpcPnJ7QdALAgw36Ch3QqPHbbZ/WcZvHzGO5sDroiEsjNJpP8AAWRif1q7eeJRfzPpp
         mj3XKp2EJYSkRtu8DuhUkrMIX4WfAKxec0wsN1yRqJ0X6MhMIEeqyYxzjWQR2mvJs18x
         VFwg==
X-Forwarded-Encrypted: i=1; AJvYcCVGnJYphqZY6TjbIPEbsiugEnSXL7lzISbmrJrlVWnDfXg+lP7Jdw4+4XaUAon2ys+VMVKZGATjlw==@kvack.org
X-Gm-Message-State: AOJu0YyW1RWdyiU1tea5PUkVte+Gn/+i3amPO01q/wyPCfKshsdPZdkb
	X8D+Tgch7hovWEQrFJCs/9XNCEa6Vkzldta0Kk3CDzRJISyy/lkGw4wbtukY511LgFFBQ24bm+B
	14YJZaRUE9bOBWyUaZHbgmT4bmYi4yMhLrUe8eUThGjClJxLys8QS
X-Gm-Gg: AZuq6aLIn3L1EgEkeZUep2ajPRanKDEesCA6xjtapWNMzSFRNCjvrV+zyZ0qbUeZIi9
	+O6U6W9Xpa2nLGFLXoTwXke/RfFQpmBeSz4R1y4TSBaJZ4j7XLsbhWtDbuS0p+LZsYKx1VLA8iS
	dQuWx7gjLvrABL2n2w6pWoPT1Ti4NgT9SGt/i1J1wM+cVp89LOffFBeFwHlDQaBGZQH5VPF6Wss
	CibRAcGTaFpX60Uqf4RL4XJ+J5YbxxyzVkbjkjV22Mgyp8GsjIXHKz8sfX7pnbdAXzP8/z/m+p4
	NEVBvfx9D2uM0OZH4HCr55xcNhzS02mVZdDebprJD4hYelWxxvnZ4VrTov13mpMJ0NgWvoJWmg=
	=
X-Received: by 2002:a05:6000:2c0c:b0:437:8ff8:fea3 with SMTP id ffacd0b85a97d-4379db66593mr24384206f8f.21.1771412214106;
        Wed, 18 Feb 2026 02:56:54 -0800 (PST)
X-Received: by 2002:a05:6000:2c0c:b0:437:8ff8:fea3 with SMTP id ffacd0b85a97d-4379db66593mr24384146f8f.21.1771412213558;
        Wed, 18 Feb 2026 02:56:53 -0800 (PST)
Received: from localhost ([2a01:e0a:b25:f902::ff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796abc85csm40735722f8f.22.2026.02.18.02.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 02:56:53 -0800 (PST)
Date: Wed, 18 Feb 2026 11:56:52 +0100
From: Maxime Ripard <mripard@redhat.com>
To: Thierry Reding <thierry.reding@kernel.org>
Cc: David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
	dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 07/10] arm64: tegra: Add VPR placeholder node on
 Tegra234
Message-ID: <20260218-magnificent-flying-coucal-a4f1c0@houat>
References: <20260122161009.3865888-1-thierry.reding@kernel.org>
 <20260122161009.3865888-8-thierry.reding@kernel.org>
 <20260123-slim-seal-of-luxury-bdb58b@houat>
 <aY3oyMhkbxhgMbfi@orome>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="3lkrnqpcfmpi4l5q"
Content-Disposition: inline
In-Reply-To: <aY3oyMhkbxhgMbfi@orome>
X-Rspam-User: 
X-Stat-Signature: rdtwunntsw15f7guhywuyha845qcfj4c
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3A48A180003
X-HE-Tag: 1771412220-10864
X-HE-Meta: U2FsdGVkX1+5XoCqUIO98dHbkPN4pBmV6QZ+E0kBj4oNKg7j37GTJUhdq8YWJYGKG69EOBPplasQhtxrmkoxHfiSi9YsyDVeheGNEpYmFH4ppJsCnf5bOMQagH4SNfJbXAz4C1S0EBol5YE5jBxxcjxLWlo2cE6WSikocw3BklGSiqxXnjkAdDTIVROhObICpwpFp0Y/eYGy48z3pbJP9D7m6QjrTbrE2b30vT2KwetpRWHiTRLi9t08hKQ6uT8XMzBDlATAs6qehTtQwNIN+q5CWqFWC4E026vHEDHO5L3uusz2PgrwXTrESlosChy61+/XvFgHlUc7VPcmDJoJgIIPPx9ChBKk1ED1QBr1P3xU/VunniQmDjKHzN8IBP4YIqcI+dDlZc9h9um3mOK8M2UEsvOF6y0tbEthQ1fgKRmWBRxMvRJCVoMI7WV5v2xAgM3BSa4g6aCieNBZqeclSovXlC6n3leuN/mT9TdX4i8Q+pzbUkcfOG0JGCrKj/DZrUHLCBIOAQqz12zs0R6YNB0DMMC01u2Xe11jRJGXhVkkphUPmV2ReNP2EZ2nGHPXVZv0jjlTaOiGceUqYPgONJLccOKFdirdBrpc08mzX8i6Xk1uLRJykX7LaSiX8DAPpuVJ0N0Chll73UtKkA2aorNLWgmGZRJMMSZZlsByFoI7M56tjzlsvze6GebymEOMAXn3cQO4ILVI70KsD1Oep30AaHu2EcbwioqwUuYZ3HQMyYjrS1KlQZeYrvIKsemQnWYWHX13ufXk0Zak8Ml81lgAAeXmabJY3OesEg0rkSGibLMy41Pmc/5CPRf7edPkDi3KmCqDnCwVFpknZWzhSY7ankBJTZZTHAmGSiLS/3om3najp8KV3A76Dxq7A/vaUf/F8PGMtvotIgO1wt50f6jfWUAj9+zDPfcgGgVCp5nKTq/WmPZoxeIYbeJIJbERNoFPHuWxkPz4ewpDlNQ
 hbbtzsTK
 RQ3GeY+ijRAJBdu87OYTtG/Q/qb4HUigHzBO3MxLigOUlUyjVaELzEQTqXuPzSoPJYF+FMzH+r3K2hBjxKaKGGAkVVym7DSAWuwx+LbmHab8kdE2mHDzkab0Xml8xnM7fNr26RrNliPpcH+WXsYpccWt6kq4b+PvHnzGHfsYkuBZ5+1sVKtjAYgPoeyPG1DJM2DwrOuGhYd/S7AvTTfg8o6AK7Fqvv0XOITsPpruYnkD8Q6QQuaw6PnSgocOxGSF4tfMPohW6ek+6O5dJCEoKo8RvN6lNWn+4g/juCaswp63T1yaPlvf5oU4+6U/Az0ZjF8DjJorc2kz6p5QDOCXQPZe6lOUBQ0XM2d+gS8nKjovU7xqnA4B4kmSeXx+p0q29CD9rJjQpMQKm0PASTkZ6JfexPwKLghpIYWVB/a0a+orCA27ydoM/NKTUv0HhN5p2wa+b5rP6jaSZfeW0+Y6caeo4xzpmf9Y+gij+ybToQVMzN0JllABBZPV4pB+cGUp2nLVjpibKshX2GUgceO/ShU+aqEm2U3bSPE0g3cTYcVbnkxSymSL0V612GxCvPa/KiZVQXBIPBp95qNSv9IQNRXoJ+eTParyl8/lzJH4UDr4oHKUUnLogI0mkHGUW32F7uh+0mTBsqDe0U1pqCZ6+oN3xxAV5QuBhPpgED8iung94grXJblgyDqqNA1aeWX+rfiQ77g0yHyGwfq15/LMlM5NuhOUXmqI5Ajjbh8XLgXeM4viDHNs4xLfCDS1l+n4hRKHT3as+fLqrX00/MTqCYt5JIw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--3lkrnqpcfmpi4l5q
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 07/10] arm64: tegra: Add VPR placeholder node on
 Tegra234
MIME-Version: 1.0

On Thu, Feb 12, 2026 at 03:51:29PM +0100, Thierry Reding wrote:
> On Fri, Jan 23, 2026 at 02:28:50PM +0100, Maxime Ripard wrote:
> > On Thu, Jan 22, 2026 at 05:10:06PM +0100, Thierry Reding wrote:
> > > From: Thierry Reding <treding@nvidia.com>
> > >=20
> > > This node contains two sets of properties, one for the case where the
> > > VPR is resizable (in which case the VPR region will be dynamically
> > > allocated at boot time) and another case where the VPR is fixed in si=
ze
> > > and initialized by early firmware.
> > >=20
> > > The firmware running on the device is responsible for updating the no=
de
> > > with the real physical address for the fixed VPR case and remove the
> > > properties needed only for resizable VPR. Similarly, if the VPR is
> > > resizable, the firmware should remove the "reg" property since it is =
no
> > > longer needed.
> > >=20
> > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > > ---
> > >  arch/arm64/boot/dts/nvidia/tegra234.dtsi | 34 ++++++++++++++++++++++=
++
> > >  1 file changed, 34 insertions(+)
> > >=20
> > > diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/bo=
ot/dts/nvidia/tegra234.dtsi
> > > index 850c473235e3..62a5dfde9e38 100644
> > > --- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
> > > +++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
> > > @@ -29,6 +29,40 @@ aliases {
> > >  		i2c8 =3D &dp_aux_ch3_i2c;
> > >  	};
> > > =20
> > > +	reserved-memory {
> > > +		#address-cells =3D <2>;
> > > +		#size-cells =3D <2>;
> > > +		ranges;
> > > +
> > > +		vpr: video-protection-region@0 {
> > > +			compatible =3D "nvidia,tegra-video-protection-region";
> >=20
> > The heap name doesn't follow the documented convention, see
> > https://docs.kernel.org/userspace-api/dma-buf-heaps.html#naming-convent=
ion
>=20
> I could change this to protected@0, which would make the name of the
> exported heap "protected".

protected-video would work too, but yeah, as long as it's unique, this
works.

Maxime

--3lkrnqpcfmpi4l5q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCaZWa7wAKCRAnX84Zoj2+
dvUhAYCm3FfvWk95XHH2FpeLOwuwKc6yGIbEd2DSsZvfEyoEj29SyLApBrBuUbbF
1e/ifR4BgM0QdBWXEmJb3YcqxnY/OdqsBvatOWUWz2hoGC3/GAFLKTRWhVfS1lbP
wk++E+B39w==
=Z//1
-----END PGP SIGNATURE-----

--3lkrnqpcfmpi4l5q--



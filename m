Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 149F9D74EC2
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 13:28:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56F756B04CC; Fri, 23 Jan 2026 08:28:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53D886B04CE; Fri, 23 Jan 2026 08:28:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 440976B04CF; Fri, 23 Jan 2026 08:28:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 33FD56B04CC
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:28:59 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EED9AD22B1
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 13:28:58 +0000 (UTC)
X-FDA: 84363309156.01.E5B2AEE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id ACB6C40008
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 13:28:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q1twZira;
	dkim=pass header.d=redhat.com header.s=google header.b=tmnZdsHj;
	spf=pass (imf12.hostedemail.com: domain of mripard@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769174937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ffNID3lES/rvD/wRrz1/dUM8poewF7Ay9LgcS6R1JVY=;
	b=vmQxVU0gwSgHr5v9elIA8Fs4NTPcD/Besq46uCUbgZ9RmxQS1sPjdqAFEozhWlN6S8JJt2
	Oa0xOAUnV7ZjWdsydlecjcfdKt6nDI77t5/gVZrLxCcPmAENV3Oe8fplcB9beQncXhCOcR
	OQU0dzLa/TOzsW/82YfPFCdeV2e9SlM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769174937; a=rsa-sha256;
	cv=none;
	b=Mek7Kl22eXse+BJV6lPqc4PI9jkI9IIhU7n/TNMO4qSJXP0sAjHPdbKghC21u0zZeb0DCX
	R9IrOCHlDfl5rC5bowIadgJCXEo7H6csZcaNq49yZ6/TlMB+qV24BK1PPBQeQ+ukYmq300
	utqycwp2HlCZ56/t6WEL4axn7lvvE0k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q1twZira;
	dkim=pass header.d=redhat.com header.s=google header.b=tmnZdsHj;
	spf=pass (imf12.hostedemail.com: domain of mripard@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769174936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ffNID3lES/rvD/wRrz1/dUM8poewF7Ay9LgcS6R1JVY=;
	b=Q1twZiraPs7FqQ/SobgPmXYypetOMCERhDJYgRg9PP/P76vWTJpR0+eUlrBU/tPhfi30gI
	tj6CH4lmiQX1CkeqfrnFfI28b0kEl9HuRBmYe95Wzwu9blyMo9qyt2/ZAtJhJfcSumb5Lm
	CouniMGSHT6ZQ1Rz3AacZ7pRl/8ep4w=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-371-OYUNAZIOP72S15uuZk3FHA-1; Fri, 23 Jan 2026 08:28:53 -0500
X-MC-Unique: OYUNAZIOP72S15uuZk3FHA-1
X-Mimecast-MFC-AGG-ID: OYUNAZIOP72S15uuZk3FHA_1769174932
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4801e9e7159so18779445e9.1
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 05:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769174932; x=1769779732; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ffNID3lES/rvD/wRrz1/dUM8poewF7Ay9LgcS6R1JVY=;
        b=tmnZdsHjp2Cn8jF+x0mSlLC3FlSHVLHr8FuMRsB8EO4nN7dehlMI8tzKQSrspFoQww
         C3q1TurO8w7VeTNRSovSfaUJ7RGitUbHvFsRCCy3OOAaJSRXRYD5+uZoKYx9xl3gAsY8
         xx72WYbEkBLZHlYOJJTFLG4tl0FIz0q5EZ7Riajvhmk1welGVb1kGIrV+g9KeVe0reLq
         MAkliVQQCAEyOlYpb90o6zEVNAp5Vtx6s/vyHjxQNqreQrmsEj+kE3pOeCpm+roHqzME
         Trk4IhWkLVnosOrQjQJGafXW3IxBYWVYD+D9TLSdu+SqjdX5NlsrSrrqrBCb+u/5jcuj
         42yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769174932; x=1769779732;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ffNID3lES/rvD/wRrz1/dUM8poewF7Ay9LgcS6R1JVY=;
        b=HkSxMdvzsLp1d8jxaM6AQBCNhtfKyUyS9NU10YK1AkPDPx19jyBKX0EMjcr7YsNeKL
         IBTXTEroJxs+q6hVHgdw/DM8JWVE65v4uE3Ncesuj11AQiR4PshapiMMKbK09aCh9QHz
         7apMB60vjujlHf7kL7xSSkpj0rTSolD6nc2U05U7tNs/NTmk1TfZmX47FqIzO5dtiR17
         LQJfZ3wd/cDATNs6ub7mldLSOFaiNwX7R3ucxbNKfgqMMwKUlu7gfmmzxnUWitdfnVj3
         SOaCaUGsXE+oQAXxsxH61NU6jkZJ1WZTwjDJq/i2uZmqBlsRaD+OKa5H5gFsW6NHa7wW
         dxKw==
X-Forwarded-Encrypted: i=1; AJvYcCU227qH8uslTjo8EQW/kYrAM/M6pqGqQ+dv8fYOIGn2nF0EXx0zKFhD3XZ9uuDe9aBqkZ09yYyL+Q==@kvack.org
X-Gm-Message-State: AOJu0YytLOzXe/T9d7YIJgQIRwEo1vSdRGZI+hAfM5K16fnz/LewX9Nh
	4zDi6haTeKHT04wo6h2wmrCWxhfp3VO7BCzKSn9ndy7OnzbFMhxurLbN8kUsSc7XoEm65cpoBlD
	sTT6BEyLo25AvY1kQiLy+MHQdKhX1t1tuyYuN3bH/AS5C9IrqAsDc
X-Gm-Gg: AZuq6aKP8rOt3pyO05s8B+23mMqopzb7yDG8s9+C1WRb6TU8F4IngqVF9rXFMl3cuUj
	X0ev7UezeShoswOEYNJbk3vzoKdnU9F4ZzAQK7q3vW/B6rgtgq8xUoJHODSqrw1XvBM1JJrtURc
	OXlNwzK0P9u68iDyF+PuNjUxjuePJqYneG2UXVSi9ZntTAFuNE6sfaXPWmzC6F/TiJ9sKHzkKD0
	GuXk+UsUeOGkKTFHkBkW6oGdH5N4V088LXWE/6PVACPYRwSr2tTywQzcV4aRFPLJmta7jnsgwEg
	xxUBBdM0KQfjhUPdax5NpZFppjCaOTZVKgzsCbST9Ka6Ne3V/JcNGaebUVwJGA==
X-Received: by 2002:a05:600c:35cf:b0:47e:e952:86ca with SMTP id 5b1f17b1804b1-4804c94550emr57737955e9.2.1769174932348;
        Fri, 23 Jan 2026 05:28:52 -0800 (PST)
X-Received: by 2002:a05:600c:35cf:b0:47e:e952:86ca with SMTP id 5b1f17b1804b1-4804c94550emr57737405e9.2.1769174931899;
        Fri, 23 Jan 2026 05:28:51 -0800 (PST)
Received: from localhost ([2a01:e0a:b25:f902::ff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4804dbe1fb8sm20935105e9.20.2026.01.23.05.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 05:28:51 -0800 (PST)
Date: Fri, 23 Jan 2026 14:28:50 +0100
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
Message-ID: <20260123-slim-seal-of-luxury-bdb58b@houat>
References: <20260122161009.3865888-1-thierry.reding@kernel.org>
 <20260122161009.3865888-8-thierry.reding@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="cj5dkpv3cmq4mgtz"
Content-Disposition: inline
In-Reply-To: <20260122161009.3865888-8-thierry.reding@kernel.org>
X-Rspamd-Queue-Id: ACB6C40008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 1yd3fa4hxwd87xf4rkk45gp7gfxdjg91
X-HE-Tag: 1769174936-522951
X-HE-Meta: U2FsdGVkX18tyvrcdjizuYox51vOIqFrr74GeGnjZjHpgnK1g4N+s/BzBkyQs+M7ujrzjIZLCwp5sBMM5/isLq9j5xOK99yh2CSdcuedhXRNzm7+nGfg4koG+OMz5i3hGDbqRmmVLXjcBkmOETS2QRvLJsAoVd4LOvuau8AOeI90R8Sfo2Hx8vjCvybJgWLcznK8qPHH1knZluUYeXtrUNRta1kakBn8W3Y+djb+8GAfG6mZC92OJmngkKrH05Nw/maLPa6s7Xaen7eDmEHesUSWr3BMKPD13v7eT1aeButuob3sS0LJZu52JSzRKpSkcaX/cpvVg9JZ9gXzsOUVDxadllUFsk0rCyp0CQi3Iw4D4Ptqbs02hh6jvxL1BOqC19bV93A+16iZ3gHAFriFnkVTQl2tys4wMYH+PFJ/e8WCMDG+186I1BkF7nvHyv2XWssw945nwv9UCUI0wMBZuaagPy6CAzoJf8P3cMmjtA7nnK5pWf+t1n19zUa2ZDnaW/yB9VZZiBilwucQfAVRPgoFhEVobkFEknHvx1Zj7Dfffq2YQNiqEg2zEvtFGK/WeSOuXhUc0pGeeKVaXHliOHp2mOAWraMvzWVkMDBQwK74lwh3gRHAHNKj0cQZFulcnp1KhWZIvJba/olN+gZl2IYh8W0kE2Nx6E5XbhaW3zdQ9Wd594lnUTO9D2lwAY15mXmCcYMklYRaca3Ecx6pUMf90EgkNNJgtg/pCsv0VxDTS2fRYtSwZAbej4gCKRzVOaxO+Q853igy+IkRMnNDCzwh6bS+m0qTzzIBYOrB1mgbWm38w6Lpq7iZEfd+ZobsaOKhbVLu5AjXkti9Oz7csywhLR9GQim/3lItFCq0Ji09z0a926yXkFoCenPNZJxZby7WycCqyZU2lgDtxXgvoAMWEZaEQC1OfI9cqvLPBuBmJXbj/DgemOQgASCKeH7t3CyFBsWQWFrtq3Tz94Y
 fQ9pOByq
 5UIVu6vywTS15MT5olfuPdcJ4AP/CyuvCtQdmMDiS+KjepJr3dUU4g8KCHHINucVwmP6WyKTgRerDm4GnJd6OguXELj/u50oOWkhYnt+vTGhA5bQjs8g/EwqZt4KQd01wXk15fhxCWgvTz4azyO2RBjgjnDjosuzWep5VFVzM5jfGKTqyN6++0xhFOU4Yh9LsdO2h0TBW1LF0XTZIc/xNPfBC8zlhaboEShxdcN6NVqW0RCiO8ADzSgOvsK9qK8LYmQdPTJ1P1e4HeTK9umkzAvDQz2gW9xhL05wlqDd+22hoWZ4g7tTLDv4vY3TU7DwfNK4Hwprj1m8luPyIE7YFDrUs4ZbniEfSSCDZODEUnnp9FxDS8Y9Glx5Yl2StPqjuCAhFuOvEhSIJtSq+R9xgp8J7/iYfUTLFCi9WrXIfR3l4d659crgPyYzti+890XXwVp7Hxnm049LYNcxsKipDDQQfEc/fkpEcK4XUAsUMqAQbSxmZ9BNxGMEKwS2XJaAS13bPj4TelyIe8tt/1QQh6CRGB0nnDPRW/Ui6z024M8njdR6BK50EuQaqcSVhBvcC/8zOCyuwp1tZSk1KLiyTEg68qOW7L8F2N0ocgCqRFimVCFi9A3kDQyz7W/KYJEDateYKxe28Hbfpd7lyP+Ksroyq3Hi74wK3ul6suq+ospn5ExDfz3unhCt48yNfdKGlfviOpfV5xvNWZ0qm7sb+AW9w5WXYGUWWZ8g3WRSJUFtSSfdo89jdjyQm31HqSEehWxYLivVhX1n8uuUwUozPSrTncQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--cj5dkpv3cmq4mgtz
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 07/10] arm64: tegra: Add VPR placeholder node on
 Tegra234
MIME-Version: 1.0

On Thu, Jan 22, 2026 at 05:10:06PM +0100, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>=20
> This node contains two sets of properties, one for the case where the
> VPR is resizable (in which case the VPR region will be dynamically
> allocated at boot time) and another case where the VPR is fixed in size
> and initialized by early firmware.
>=20
> The firmware running on the device is responsible for updating the node
> with the real physical address for the fixed VPR case and remove the
> properties needed only for resizable VPR. Similarly, if the VPR is
> resizable, the firmware should remove the "reg" property since it is no
> longer needed.
>=20
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  arch/arm64/boot/dts/nvidia/tegra234.dtsi | 34 ++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
>=20
> diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/d=
ts/nvidia/tegra234.dtsi
> index 850c473235e3..62a5dfde9e38 100644
> --- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
> +++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
> @@ -29,6 +29,40 @@ aliases {
>  		i2c8 =3D &dp_aux_ch3_i2c;
>  	};
> =20
> +	reserved-memory {
> +		#address-cells =3D <2>;
> +		#size-cells =3D <2>;
> +		ranges;
> +
> +		vpr: video-protection-region@0 {
> +			compatible =3D "nvidia,tegra-video-protection-region";

The heap name doesn't follow the documented convention, see
https://docs.kernel.org/userspace-api/dma-buf-heaps.html#naming-convention

--cj5dkpv3cmq4mgtz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCaXN3kgAKCRAnX84Zoj2+
dgbuAYCUCaHUWqJPUhpJEcWkq2uLIaAHUBUCBbdSNPF5dpiFWDp+QSk3hILjtrCJ
0RNZRFsBfRAntBAG5/xlnModxB1enPz3Z9TuAC/80PaW7OVoKyjeBvgxqbNMjc+5
iM/+K++lbw==
=V4o/
-----END PGP SIGNATURE-----

--cj5dkpv3cmq4mgtz--



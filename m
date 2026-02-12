Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5D6EEE3691
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 14:51:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C4696B0089; Thu, 12 Feb 2026 09:51:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A5D66B008A; Thu, 12 Feb 2026 09:51:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5776B008C; Thu, 12 Feb 2026 09:51:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EFFC46B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:51:34 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A6DD9137BE4
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:51:34 +0000 (UTC)
X-FDA: 84436093308.16.D2FFCF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id EF7E912000A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:51:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SsZRt9FG;
	spf=pass (imf29.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770907893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qigA9suiFDRnEMnJyqo65RghH2UffIJKLsLxPzU0+Ks=;
	b=JMFe3MF6sogkKj6bYkcw+RmfvjnHKo32u65BupmJvpm5S6XDKOP13s9o5Z29N78zZfZhi+
	lkMQ49A2lUtGDTDVzCW/il2fMHhINuvA+s4wqxixPRO6JwhvfYHQMEcnamIy9M6oXCOw4q
	qTi+jH3u45/3VFPkf6uPNRJrfSunr+Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SsZRt9FG;
	spf=pass (imf29.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770907893; a=rsa-sha256;
	cv=none;
	b=6J29N4DnYYln3Kq8+5PUlhmL7Dz1Z77UHfPZ/4cMzERhQZXw7pfELAVEVrTBZxitUhdd0a
	uU0zEW1EilY35ViFov32WLt0kUPI7sDQ1mLTylEzsEsRq+El35w+KlHxl9z75l0ZZkN2H3
	MyoKO3kSltiaA8TzFFLOVdLPAppKIN4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F08994177C;
	Thu, 12 Feb 2026 14:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7322EC4CEF7;
	Thu, 12 Feb 2026 14:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770907891;
	bh=pM+ZBj8nZh9g0uFqM8SzCpSYe+CFpO7ZaK1fqC0vN2g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SsZRt9FGKIJy9cJ1wQWyR/28uRX1LANQWaZcQKBt7mk9BoRmGOMSuDWEyHEfbBbkA
	 NAg+s4IfzaIR/3yhHXy8/UUfmXcM+1j/HAVcgzU8WK57T8Aq869RnfbkudOvbMpJCb
	 h7PfzKfnF7TDSVbKHKCEZgKN7jQwXlHCdLyLzSfk1OioajwXZ2dJJVCAx/kljcxam4
	 qnmwQ++/Qm+yWyZanGeYtadTfgf55lCsylxDmLH4nAblqXNMcVwtZacqp9GpPSXLm8
	 hR1jVWwZ8O8Dvjg1UEydj6WvqCodQTzNW0FGr3Ccydfm+P5sVl2HrwCYzSsow/EyKH
	 Jvvs8MoxtAySA==
Date: Thu, 12 Feb 2026 15:51:29 +0100
From: Thierry Reding <thierry.reding@kernel.org>
To: Maxime Ripard <mripard@redhat.com>
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
Message-ID: <aY3oyMhkbxhgMbfi@orome>
References: <20260122161009.3865888-1-thierry.reding@kernel.org>
 <20260122161009.3865888-8-thierry.reding@kernel.org>
 <20260123-slim-seal-of-luxury-bdb58b@houat>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="m5e6dmw2rrzidhli"
Content-Disposition: inline
In-Reply-To: <20260123-slim-seal-of-luxury-bdb58b@houat>
X-Rspam-User: 
X-Rspamd-Queue-Id: EF7E912000A
X-Rspamd-Server: rspam07
X-Stat-Signature: cozpffmmnjyw6n1ja8exyqw1tr1egkx5
X-HE-Tag: 1770907892-621801
X-HE-Meta: U2FsdGVkX19iM9u/NLMbARaYlWUvLUks2Ek//UvHhLk3Aor0bMUkzohenBwdjBNlXvNxBnrwAfUVMGRRYdiXz5gFQxIOzP3/SIQAfrViFbK0BL9RNUlEKesgznrxgz57Pzmq2nG2JJYpM4AUh8cIpunn5A6cTe0jyA50RVl8vTg7H7gtzv6sV5PAGPXOVU1/dqVBXKNtYsXBmzYwRczud8tOH1pNwoWFvPXXmzfDWQlbw+withMopLyEZfGA//Sym9/oye9wjn5OZYmP7bYgs+naMNjZWPynhwvDPnf4cTRA1lFLIFqPgvxDlyQBMyHMBoHsObmnxZng5Q4ZUKZ+ehrrHaPt+BgT4Qe3tv7FAsvNc8smvZbWnPY7vkRD4lASOwb7VoD0+/WfP2ojkE5WAfxtu1nc3OZKjBfXvK2CyXztlJYl6XcfLahYX2Pnohk6qr/iak5SOhQ4hW2EI1C5I1fViWvr9XRB/GimqlkHz5CrAYbwn8x2dYF4tw+5ep2UlHttDcLIZFa+3nvuiotos9lY+detkgV4+O2gyXKJNvOHDRpZ4aBYdrC9Zh5x1hhCEC8j2/GsVrVHMwLGOg/wAVVk2WIojccVWNEsttQj3K/12LSbN+j7W3sAe9GDhTe9BX5QlB8v0jpd5B1qBSrRww+JZLLCzeNdy8GXGg0u7gy3A6EOn1rMob7oHbZfyhTZ/rfGAOuBsI6rlHNQ2Os2qOTagauGjhtajW2ho8E5IyKI/+ciuIek2reQEP6lJNGigAdfl59MIU4FhVmdrQLbOpcOkwxl0QKD9QbEKOOv4gC1r4Psa6PYr72WrsUbHdRmPOCOL/bwGmw2nZDH1H6im2bt+0uE4ZiDTork7kt2LyQj0sxaOjoq5A43Rrr9S18fygSqDWaz1mCFY98W+D3aFQnMmoCccoJauPlpw9nmaupioHuMItlHUm2UrFonXGdG6IQZbpo6SIBFrLYxjVC
 0aK/6b/G
 DRFjtHKQFTdhX+jA19q59ST6QvKfeEO9Gx5FRyOW1AGqsvVsEIYWq7sqOaCChnZje9yDbfCszN+c6f1Gz6a+9fCCNlmfxamdsDyhwpfzUOMVs060OoZKbBCRGE00kocLbsnZ+SUIZlUtZ7QtKNO3dtb/Pb5i6KD4zkWYl3VL5Z1wMxRD776HdGZHPHYoYUmDyDWdhmTRlEtY+cPtVg4XoS5kHD35CAmYOMIPADdZRXCu1/yr/fTQp93fpvJ97jFY1xvHGADiLfXMNwDFbXt9eE3vzriLnqYoYOCc2f2uZh+ZYAJMRHFt9x1yllUW2wV7r9SiCtpTYy+Y3AxeoW9pDLQMtsJ8Pivv9mitrDYidDiTYlAej+9HEfURWlwxKv6cgKCO48sTug0C1yxzBx5x+iX+6R/bP7+5Q5R8MVTxs6H6brNl8kRkFZmx31XxXKzb7mZGF4wnIKXg8cXpXaC+xvefZl37fE/n480OauWgDmIG9rCdm6tYDwVUScg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--m5e6dmw2rrzidhli
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 07/10] arm64: tegra: Add VPR placeholder node on
 Tegra234
MIME-Version: 1.0

On Fri, Jan 23, 2026 at 02:28:50PM +0100, Maxime Ripard wrote:
> On Thu, Jan 22, 2026 at 05:10:06PM +0100, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > This node contains two sets of properties, one for the case where the
> > VPR is resizable (in which case the VPR region will be dynamically
> > allocated at boot time) and another case where the VPR is fixed in size
> > and initialized by early firmware.
> >=20
> > The firmware running on the device is responsible for updating the node
> > with the real physical address for the fixed VPR case and remove the
> > properties needed only for resizable VPR. Similarly, if the VPR is
> > resizable, the firmware should remove the "reg" property since it is no
> > longer needed.
> >=20
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> >  arch/arm64/boot/dts/nvidia/tegra234.dtsi | 34 ++++++++++++++++++++++++
> >  1 file changed, 34 insertions(+)
> >=20
> > diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot=
/dts/nvidia/tegra234.dtsi
> > index 850c473235e3..62a5dfde9e38 100644
> > --- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
> > +++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
> > @@ -29,6 +29,40 @@ aliases {
> >  		i2c8 =3D &dp_aux_ch3_i2c;
> >  	};
> > =20
> > +	reserved-memory {
> > +		#address-cells =3D <2>;
> > +		#size-cells =3D <2>;
> > +		ranges;
> > +
> > +		vpr: video-protection-region@0 {
> > +			compatible =3D "nvidia,tegra-video-protection-region";
>=20
> The heap name doesn't follow the documented convention, see
> https://docs.kernel.org/userspace-api/dma-buf-heaps.html#naming-convention

I could change this to protected@0, which would make the name of the
exported heap "protected".

Thierry

--m5e6dmw2rrzidhli
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmmN6PEACgkQ3SOs138+
s6E1XxAAmwl7hhPeCdqx1mcrn7uzeLWV1oZBmlvYPVr+MM8LEkJAxxK4xle8BSau
c4DKNkwInqzqBz1HcZZ8CnubRENXfhhCQNsoJmGAnkt2fzjrkN5kJoUwMjxS8/jF
5c/J+g5k7X+JFnTW1IjI0bVFTlmYd+0rA2Vxfk3KwQI/mmEuReTC4UikaeMSvGS3
a08c0pw5Hd7018tbuPxVNFEfj5xnhJLycb/ZHwwSYGlmP1iZf3lzponRBpx2V5hI
BHbs8EFDYfnHNT6sK4zcXVDhD2+3gX+7J5xP/HUV2XQjWjAyqAcse4BGCt7tixKK
4id8MbZ8315lGMpXEzg0G3Rd2E0p9+qvhIFhd3HbinTPBZtV56c8fhgQNfUF6sfc
0w+FofsSyBVJuO37FYSKHq3iY7sGJ9zCG3txXcQsdmOqQhBFDU1ap3T0FXoq7OVA
jGlq/wkUoyH/2HtZbz7wGer7RqDuaFPosR32jB2SmfNY9P8OBF8IlWaH0SLFS9gE
oH9HoR3ZgA8ND6Jrr0M+kUYhFsX5VYkuwA8/9MW6yngJtEEQh3/lvXoBdEEzPMK4
6rAi57CPu0ulNpkvjbiXOSR9vwZnlnIPnOK1ch0ikb/2JmyLZQZ62djjYggjBF5s
VYE0AphNbLhGg0crZ9y0O+yPxMU0gBQ8vlD1ZYvr2wi2SgKr494=
=aSiq
-----END PGP SIGNATURE-----

--m5e6dmw2rrzidhli--


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11AA2CA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 15:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ABF08E0009; Thu,  4 Sep 2025 11:31:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65CA98E0002; Thu,  4 Sep 2025 11:31:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54C198E0009; Thu,  4 Sep 2025 11:31:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3F7448E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:31:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DFD4285653
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:31:02 +0000 (UTC)
X-FDA: 83851955964.13.147716B
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf23.hostedemail.com (Postfix) with ESMTP id D6E8114000E
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:31:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mAmwsLMj;
	spf=pass (imf23.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756999861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8xE4rmjGRisIQDV5Gl3u0Fv0zsZRWzQtHGzTA13lIgs=;
	b=J0bJJpH2+HNr4RCaMJEqGsce5d2FtiHDjLMGbsbI/dNUg/Fy1y+QKzlJlRpawFqRFthOR+
	79ZgvZq1EkVSnTToukiifyvVhhLRud7GH/DxsjBeTSfr+KZXNK2Srhq1uRzmo95x+lEoYd
	k/mXhrVK6Mz+TgfRLrFLJN1aK0sCCd8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mAmwsLMj;
	spf=pass (imf23.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756999861; a=rsa-sha256;
	cv=none;
	b=UFV9sNJ9yoxr37pGw1oWbs2SRgN1YsZfRRagYDc4n4rz4YJBQ2aMkUUL4FPwtnuMeh6Qk2
	DiJ7CQVBEeI0+zN/r5wwra4Ev37L7aT1AW17gjSOV+xuwwn6bf6MpBRi/r5tqm99q9UNgl
	V+qpAmvn8UFPFcWyO3pWtP+XKgC37Ko=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3e2fdddd01dso7127f8f.2
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 08:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756999859; x=1757604659; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8xE4rmjGRisIQDV5Gl3u0Fv0zsZRWzQtHGzTA13lIgs=;
        b=mAmwsLMjlauziasX42uwRqBneLImFOkHnA8xwC7cyQ+cRFXc6epbMTDwJq3/YuWj1Y
         FlORm26XKRqj5EHK+RkZXGlOWMurILkF7G7Wz6DUg+hFQsENkPcGcZwBRFJ8kMpetCL0
         PTgdv+pabqcnPj3gHCrjrdd2uAmp7tKkRnK5uWSlULgKA9grw8vbdWX7K5uHg5w/ZBjh
         /GRH1M9kC+HRjjjXlqE3X1JcNV3iYZ1DfcfZMdsKrehFqU2qLv1ZDPknyJtH0I3bHQjH
         o9B6qkvy6h7wtxn+5NONqbf7Kiy069iaBRIvyMizkZoLxJPPnw1HfptM5wmIXizB6nIo
         +FnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756999859; x=1757604659;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8xE4rmjGRisIQDV5Gl3u0Fv0zsZRWzQtHGzTA13lIgs=;
        b=jC7cY6c6Jhlp6aZfSWSNWdr9kBF6jYXmDqq2XNNT3jXAIUXoHpoEQ6SC3a6ioZOPaT
         51Km+6VAoKZY9zrY/jjvfeMDwObojIQTzn42IErGXlp3rww4I5e45mgwtjGf9KXVyK17
         8yX/ZunQYWy5RA3+AG5F+HutwOsKqQu+fG/XsR00/Q20yl4UBeSdE/m8astb0Fsnk5K0
         wHW9cpuwUAUZhdxmqbYylH0tBtwOEBf4ea0qySBPy3ExRi+VmnVb+IeYm3EeitpxfO8H
         4v1J8hJNTyYFycTa4ywEtt3w2TfRuxy8mytesncKs+iT6QFYcOi+xUHfroGlv7X7s80P
         aDpw==
X-Forwarded-Encrypted: i=1; AJvYcCUZBWKtW232TJa7jULWr0RmeMvGtX0Lug7pzXe6nPw7CiLYlDienU8W8JxDea++1pq0Yo2Oum1fyg==@kvack.org
X-Gm-Message-State: AOJu0YxmzkvF8+1N0go9GlH32KusYlEKizBnbin58qEvpPjVPH8tce9F
	c+csQ5X+JFdUTroeALrx2taRcio5PLIYELP7Ays9Wp6c5uBIXgeiCvXX
X-Gm-Gg: ASbGncsr8PYRM0/JfFD3jWz7yBciG6p1Z9MFYFPJ2+AWyl3sATlG4x3oR4Pcuktrduw
	P6jnmTAzyRW7235xdnCkGTkxD6fclsWPz7d0wXh7EOPe/8hXiv1zppcAQXCrbJcC/3jd/ARMywr
	MErZIiYj73aDjjCqcOx4V+CpkRRDzGu0oEV6o1ectDfL6WKvyfMGEWSFPglA1r1nZgrTlr7Pn89
	petvNED5QxOHmgA9iRHuvqzNpOIHy37hBlkjWIeeYTrDAlBKvrt0X1rDBn1iX3NvuLWnz95aNKN
	MI9NsAX4DPUEWX4249Bmz0Eqxt/Ki3jwjw9aJviI7Y+AoQ3GQnHQwkkZ056OrfVsAO4MQXROyQq
	FL3tmOpBpZbWwda1olfO32dgAVyvKjqBYYGou8ZEX+/qgSPt96mv9s0COZTAjwb4Ag3hLcixVsq
	D02+SYLwfu
X-Google-Smtp-Source: AGHT+IELB08VGh3VAq+KT32lgs3tsogmI3gmF9iQ69mvKEfdnKdejg4TzGBR9ruyPEVGthqdMWy/EA==
X-Received: by 2002:a5d:588b:0:b0:3dc:1473:18f3 with SMTP id ffacd0b85a97d-3dc14731977mr5762689f8f.41.1756999858759;
        Thu, 04 Sep 2025 08:30:58 -0700 (PDT)
Received: from orome (p200300e41f1c4d00f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f1c:4d00:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d0a1f807f9sm27264155f8f.38.2025.09.04.08.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 08:30:57 -0700 (PDT)
Date: Thu, 4 Sep 2025 17:30:55 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>
Cc: David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
	Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
	"T.J. Mercier" <tjmercier@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>, dri-devel@lists.freedesktop.org, 
	devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, linaro-mm-sig@lists.linaro.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH 6/9] arm64: tegra: Add VPR placeholder node on Tegra234
Message-ID: <dzbefkymgrtyxfgfcdu4kq7rmgpa6khfqyhzz4a6y3qqonc4gj@yfafsqwnloia>
References: <20250902154630.4032984-1-thierry.reding@gmail.com>
 <20250902154630.4032984-7-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4xtz2xrto4fsphdg"
Content-Disposition: inline
In-Reply-To: <20250902154630.4032984-7-thierry.reding@gmail.com>
X-Stat-Signature: ysuecjycytjpp9hxw9fmoh5hw8comeaa
X-Rspam-User: 
X-Rspamd-Queue-Id: D6E8114000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1756999860-84363
X-HE-Meta: U2FsdGVkX1/Wp1yrHaMYbUQHdPlwoeC5XVLkurdbg/iUIN8sTxawGr0zc7e9Qlf/v5eTyoZSQVccKH3+MZye1+QFQfGHGF5i5GV8xj5U2I5JgifoejvdoMu1e7rXfrIqCVNu3Y2OLtAFwfvCa1A7PSRhai0hCOveeYRew11dw2t92IJKIEDQJk1hmXt6HebQBPn/km6cXu3QoY153gg6CY+YN2RvXQavRCA+c0jnbBKmhNQGd4fuiU/DKkEaF5CnkQDwi3vECbK+10oRtpxOhGcYE7WObmyZICmpX1JmDS5Tf7jxEs8ZPd63UZH3DYuuLfih/mD2svM/ullsZ8IYwZ7Lx45QPsMi+WWp/nlp8VDS6m7WmM0KBXMw4pUmDqmE40f60ywOYuuAaF3a4VHpIhTa/FO+nGEPsnNREgYKlxaWxkcvaj9jh8Lktp9jaYNWjShm9viy7CZ3yMvvNU+dv5N1/iY/Tz/H+RperNMdceqP1FfamOAvn2fKdRrUbW9ibkIZ9lo372gfKmUeHAl6QrOR2vGconYcjbCSNRQXlY2AJVxmaZzn43TdbqNCy8lu0iqu/FqUwNIPFOdj+wlLhtwupxA7lZslDHnXVu+QzgLYeAPigSf02k8Eqq+UbXwRNje43l6GltRHUNDYZX7L1APOGGwntHJUDTP20mSLVvyCtJUevBw2TClLeUbcqkqU37WcAmhfNHQ7itnd8WSu/N50WGKq+qfDf+ltm7ecAk63nxMIXqKxk5oDqnshQbDnTVfP/Seae0qY/+UKMDhN63E9LJYpBKX2Mv9PWR6BVM82UQsEbzVnFmTcuBnp810UcyXCbdn8YpWztCIkpLORMBLxcAUHcozzrUjnVa258kq3GH4V6RQjCDiGsqge5XKESvIcNlGOvphkusm/qcvUCQHXn8Ko3gua+c9+NTwWJgdfEqdum+ekXdeS8mET+7onWZdIrG/eagjwXAXFe6n
 nsR17QOf
 k+t4jkEQ1tNYqchbltad4TxX0+0NkLjp2Xh/14NTsqYmFTK4eh11jaMy00B1jJC6LHR/X6bG5ttYd1PZc+a0zYBXnKSC28DDMUgtoCRpfjAmqeJUbOY2D39e2aC/3/KAFEgSmA1yeO3UbNMOmgXt1VdlHFIRq4sdBa6C0ExyjGai7MiOUDkKHRW3TGyXHKcLbXR5zhvqEKauU828UVfZzbG7aTSdS/edhjV7HypGzcQY+a6n58T51W65MRVrRlBp3+z3ELZTZ7QY61UawEhLlmLhAnf/XhnrddwiUWmLHdkLLeLQDxAv3nPeC6mmHXhMfMdnX5k1Wu/Mle9QUa4kRvWfqHNBsyn+T21nj1lrxI2+xWrKNCPj0YpotAhclzqHYal85atpcvy1pXisJMS2B1jFFebV1AWIiqwrjgxCmt/11EzP4/Vy6o0LP8qdZD8CHzh71IwvCqNj17hmkM8I6VBtAaBxV0biiKkp86jyOf6KOTkKQFzlIrcNiLGKls08iU6RkHu0ddT1AD8/4/fFf3sh5sGTdxo9kKcrBb2Ox6IqZz7QtVOcw7YwetXSbhkfGfuO93aFuzqIqmK8cB628Le5Ag/xAwQOKrmFMLRHE5j/blyUnwwZmPDa0afRyOy1rqwoGzIofdQJwxlIQI8mN/YMhkQFG6KxJNewPWtHqP8gKXSvj8+H8LMIbYILGYDtiE7KKkcs9WaP04us=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--4xtz2xrto4fsphdg
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6/9] arm64: tegra: Add VPR placeholder node on Tegra234
MIME-Version: 1.0

On Tue, Sep 02, 2025 at 05:46:26PM +0200, Thierry Reding wrote:
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
> index df034dbb8285..4d572f5fa0b1 100644
> --- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
> +++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
> @@ -28,6 +28,40 @@ aliases {
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
> +			status =3D "disabled";
> +			no-map;
> +
> +			/*
> +			 * Two variants exist for this. For fixed VPR, the
> +			 * firmware is supposed to update the "reg" property
> +			 * with the fixed memory region configured as VPR.
> +			 *
> +			 * For resizable VPR we don't care about the exact
> +			 * address and instead want a reserved region to be
> +			 * allocated with a certain size and alignment at
> +			 * boot time.
> +			 *
> +			 * The firmware is responsible for removing the
> +			 * unused set of properties.
> +			 */
> +
> +			/* fixed VPR */
> +			reg =3D <0x0 0x0 0x0 0x0>;
> +
> +			/* resizable VPR */
> +			size =3D <0x0 0x70000000>;
> +			alignment =3D <0x0 0x100000>;
> +			reusable;
> +		};
> +	};

Hi DT maintainers,

I wanted to get some feedback on this type of placeholder DT node. This
doesn't actually validate properly because it contains properties for
both the fixed and resizable VPR variants, which are mutually exclusive.
However, the way that this currently works is that UEFI will remove and
update whatever properties need to change during boot, so the booted
kernel ends up with the correct, non-conflicting information.

The reason why it was done this way is because it simplifies the code in
UEFI to update this node. Also, without this being a placeholder I don't
know what to put into this. There's no "default" for this. One option is
to not have this in the DT at all and completely create it at boot time,
but then it becomes quite difficult to create the phandle references.

While at it, I'm not sure if I properly understand how to correctly name
a reserved-memory region that is dynamically allocated like in the case
of resizable VPR? It doesn't have a base address during boot and the
kernel will allocate memory where it sees fit. Do I just leave out the
unit-address in that case?

Thanks,
Thierry

--4xtz2xrto4fsphdg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmi5sKwACgkQ3SOs138+
s6EL1w/+O3vMzwflDNuAsOeJT5PO30EnSdPQtwSfs1kegW1Z0O7O+SxPDRbIOumH
ZtXCWjmHUA0x4A4tV1KHYusXEpLe8kdgMeaFYK3XECONFcW/xto7lbOk9ujNo4B0
RSBU+KmbKVeHe3JQ8ENftNYUpQqLHdBEi/FZVlgjZW8KLe+MuWHnvoZsutLTvLim
edJeSpS/ms98AYPqE+MACLkqG92b1y0jgGhsa3dymQhX6RYbJxLTzO3SCG9WKpFL
OkfgV5XwyRYgsBQDIkJnBu4+CtPOO2mJeUQGuHgvSlfv8Ulz6jYKIcPQj5hhJ8KZ
qtqV5vMoRauXf76f97vKenJ86SPlWymUWCj5/K88mqtDm9EUoTtMT0LfGhCsIfIX
TNBYgIz79w16UvFuZ/CmD2MEUPi00WpA5b2UyifcHKKnORwL08lBhLD0r5UWMf/H
qUqNt0qtK2EuPjOeUMwB8YN5VPZCP4oWEWoSVCF3cbjUitjx2ogJRMgeazsAZdmP
x1+CSVvTpQ1RqXIn3ezRgBkPLQ2d1KJIJdv+pdQn1zcFTuqd0nP5yFS52TiWsJ8/
cczmrWcs3r30Aoaw3e0rW3OQHghuXLaavcm6FmLVFGs4VDlpRbFnESuLbynzAbAk
7VfAJwgPBaLVqs2UqkC5ezADL7wV+VxmrcPUry4JBO+17jVwwBk=
=p0GH
-----END PGP SIGNATURE-----

--4xtz2xrto4fsphdg--


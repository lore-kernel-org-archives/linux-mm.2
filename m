Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D6CDCA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 12:04:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA5FD8E000E; Thu,  4 Sep 2025 08:04:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7E1A8E0001; Thu,  4 Sep 2025 08:04:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 993F78E000E; Thu,  4 Sep 2025 08:04:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 883CD8E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 08:04:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 50BC61DA5D9
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:04:13 +0000 (UTC)
X-FDA: 83851434786.11.21C17F5
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf17.hostedemail.com (Postfix) with ESMTP id 560ED40010
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:04:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X677gz0i;
	spf=pass (imf17.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756987451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CYiE/pA9YF+I4gC3nqqr/NiV56Cz+ejODJOLdKJjvLU=;
	b=fN38ThTe/HAedBIlmQB4xfou2CYVsARRg7p2yx8a52ggfxw0r5Ie+fqwxMOyPDoosN166r
	3WDFf6WcMKs9kObsx6DFp/LLqx+zRPXG+hQo6YNcQmkhyH4hFciRWBV0fisr/KmGjgOFyf
	dGVR48u5pbzjngGps/DSImD8fGBWKbE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756987451; a=rsa-sha256;
	cv=none;
	b=Rk08GeQLH8C1DnsWXaNKcmFBd0ZQDoGFSKw9VlZuXoB2RWSmAsDsRamjZhLIFznul7AFit
	Z3zYpF+ItstmS/oWb/8TTzwkB7a6+CnWF4x4OGgmw00lfoMha1UQV/H9jJ2myC8o433ODR
	hWjjb3QourhUaHGSl8kh6S51iJqybZ0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X677gz0i;
	spf=pass (imf17.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45b79ec2fbeso6699085e9.3
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 05:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756987450; x=1757592250; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CYiE/pA9YF+I4gC3nqqr/NiV56Cz+ejODJOLdKJjvLU=;
        b=X677gz0iiMmEVn3FNg16WaNq2QVAuPMVb2ruW/lSjDfwUdu1TqS10Q135ZTC0+0Xke
         i/W01j5UEW6CzPa/SzNcdbbgDk1Egmi3aePbXneYsQyiA3otRtebI0l6PyBU0hwqJ3At
         DAQZXPHPjvEPUGxDvmhBgJ7qpJRm3E/1GFA5WkbxLC4GyAuR4Dn+ev/de9/aiVzCaG6+
         9i/b41AkMf3OZCJTgCABP+MKfCyTuzJCP7BItvKWmRdqiTwhj5evytz/TI2EnXN44prP
         /S+047il+tyMZpKLw1KZdxE+L37KMUOxEpVOR6uVzgBBOIedlgaETwxuOjeCjVI8TToR
         RdbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756987450; x=1757592250;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CYiE/pA9YF+I4gC3nqqr/NiV56Cz+ejODJOLdKJjvLU=;
        b=VTx/erCuJqDzp/O/BOCv4vCUkx0IJieyZgQ3xtcc9+i+2eSkRqudFPQCLgQSvGWVSA
         DneEQ9MdmUbiCt4wXpPBFaMqPvG2Ay8hh9xrMsjZxh8HVuhvDUn17evJGPjf3lWMiI+N
         60QZG8VMhb3wNY5KourqkfGBQCM+pFP5+Rh49S4hTMfJP5R9UeoLwSdyVGInanjCzTS0
         bgpr21aY2Pt+eGSk0fi1guOHY6U8n5V3H+X5LeDOFlDHOcydSHLB3S5+3MUKMqcjgZ4b
         epqhlG4B3MlsLdnYpcYIU9xY5cWwtKENGOoa73I3SG9y6DTYRPS/9resQCjaJl3t97YC
         6nJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJ/SF+eZj4GSmRIMs7y9uEFXhisE9PQm+TNiIDArhaBzck+g99D1vD0GBEtUZkL+Qho/2Gh6wNCw==@kvack.org
X-Gm-Message-State: AOJu0YxKHXeCTUVzCav2TwEOyVSP4sZlrzXOvPnk3rrSrZPDQ2lZ+K0Z
	HxXMWYIeYHGfkSoJ6+9AFsrR2ieOH9k4NfgXauj41cewpBlyUQowr1eW
X-Gm-Gg: ASbGncuZWQrjC1FfkgwHANRYp6iezCRGuLXse3ckJqs6WqWENeL64JyY16S1Vh5xZ2v
	OHDWjiSHklyINsypwc7MalNOfaV5zXbOTeaoCaAMLatQWgxNJrqN/xaJTYefAftqVYIjii5hWHb
	mrSdOpmJ+X9GTr35ngfcHOGtcWTRTc/SL1NsatQuOrepqVzQFVwDB5wGWghYmV/7yq06FtVerv6
	MFS1zMqHWaU1BwTpo6Bmq0jsqQg0gk3a0GiZS3Cv7Z28FxsFFUePe2xzMLD4o5X5KOukwEHEk+6
	+fC+ebw3jAHhWq/NncIIsIyAtgJHcmM/ZxfuZzXWfaQ6OmYGlRLqVenHaBLAyEDglj3V70sKasq
	vrGkc1CLmqHAbJPaYpZFO43Ht5W/rKi346FwjtKpElCmjzP4KGQh8KCJfgahOvXYAnWcHaa6Q2o
	+rP11H73wLXrF1sLEXDT0v4suQN35Ybw==
X-Google-Smtp-Source: AGHT+IGVHgAQ3rYyWGpANjjI/b4lpqEcMAsgs+SEt1MbrHmOvH15O1otXHYn+//vwM4FBU00m/l7Ow==
X-Received: by 2002:a05:600c:1c95:b0:45b:8abf:4583 with SMTP id 5b1f17b1804b1-45b8abf46edmr100558005e9.19.1756987449310;
        Thu, 04 Sep 2025 05:04:09 -0700 (PDT)
Received: from orome (p200300e41f1c4d00f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f1c:4d00:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45cb5693921sm79929805e9.0.2025.09.04.05.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 05:04:07 -0700 (PDT)
Date: Thu, 4 Sep 2025 14:04:05 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: John Stultz <jstultz@google.com>
Cc: David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	"T.J. Mercier" <tjmercier@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>, dri-devel@lists.freedesktop.org, 
	devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, linaro-mm-sig@lists.linaro.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH 4/9] dma-buf: heaps: Add debugfs support
Message-ID: <sb76bsg5d45r5qgq4zy3svbh42ydkk4vrh6a7vh73eibvqbfjd@3r4exdhogde6>
References: <20250902154630.4032984-1-thierry.reding@gmail.com>
 <20250902154630.4032984-5-thierry.reding@gmail.com>
 <CANDhNCoM4RFX-QccF7xT=+-tduGj9OZ_8SgrTVyRucMwyVc73Q@mail.gmail.com>
 <e6twhwxi55eesb7xirei7wezzb77qjiji2mccgqlziisjzl3q5@3ny5e6lbgebz>
 <CANDhNCrO21O_URa1iHuroOoG-g61DL7uvECTwVxiuitCTi=i4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="n7xt7eiet7j4nzny"
Content-Disposition: inline
In-Reply-To: <CANDhNCrO21O_URa1iHuroOoG-g61DL7uvECTwVxiuitCTi=i4g@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 560ED40010
X-Stat-Signature: 46arkd61uzhdg4a5kcyof6dspwgs88w5
X-Rspam-User: 
X-HE-Tag: 1756987451-756802
X-HE-Meta: U2FsdGVkX19sRJo7t+zOCePFYYWprpDmnRGxjkw3Ow7iF30NF9niQID+f2s8ugRS1Q7e2jlPzyWB3VuVRZvNvqbDLZNpFkizSpgQVbeKEeR5A0rFgp477HWS+6KpoA6FCYl5MgwsY7oe4r9iEqbfZc5fpzbXT3Bn6xHVY0VAIJlP/xwSD2AN2hdZkVLWNhGWVBJK2CXsHuz775r0krve0JF/ZnX2AwkXrJzlI6oq7YPGRh5AJnqxlGEXIw9cwiFQhpAJuE3ntoTcPtkXrlVHajyqz/sEKmRGboTv84ZHr/V7QU/VG2cN7UVC9cIJWEr0NDG7GvdGKQjdOGipqpPgwQXSukjEiQMwbfcTkMXCbm4eGR2hWCA3V+TAXoZiJ5cRaEbU/kcM06NDdsUWS0X6pCZK9ul2Nw1g9fj2XoU05mmUrcYTs146DHfhPew6nuwRCU5kPENns1V2RP9RPBQPxCbRV/N6IMsjhlWbA3a6cRUj7DgRCF5BpAocMTHCH88lPX/aSbAcG//yD9MH/E0QLDk4rvUr7ftupqQ1rpCfqDYlR1J9kwUN5JI/Ygiw3H5t9hyC7IM1dPgfI1pstqs54jLNPDNL/NeQcyp2LVFr68sy6N4JExtqmqV4QUuct7diJI2s3PzovGdNCqOpnRj6HsQYNqxdlsj5iWJMnfsUs56rzHHsR7awtqfuJl3FNhXm3826q07JPiHP7JzcNB3HmXwHvKNt94QDzmYRulByALQ32LZ9nA50G14aVA5mKgtQi6Sgfd+HbtUxmefu0sSphnke3y0pGQDvHtN7NnY+/bVD0zaM7nVEc+TVTrXFk9AhgQNxwg+wBb3BDrNJkgKsi95dFrP31yPXl9AkvgTB0OMKZnaEa7ayTEhQrlIUy8lpehM/H7pLq9b2yfOUAlrqoROb7CtX+qR7DTp4XkEowrCAKCQD1zMc2dUw0SJFOVawDDdLOawRwXF1tob+6LZ
 sokIGkdV
 wcOhpZs8oYcVy2m6m0F0gI4PBLeYpOnLjDJNpXL/PL616H3Rn+eVXjJEODLJe73yi/iC1gjkQ88Ifq+L0l31kk01oMkK9uLcEMIqvdYn5CWc13DLuM6Gr1fWqowO7zyWp59Zh+Q28Ut8yJJb0Pxrvb8R7/wKNq41TBB5gQIbpTF2n+RrsiV8vu7q4pLXbkeZA92xsbrvjScVvqK+CvekNw1fxgUy5QxACT97VunObmxdTBtsP5wDSeLtQv99x+MxsXGmOArbRoVdGVuCSHmwNx+yzIPjWtFLbRELugi2R/IjThMUWvYmwj9qyk9PXqKXUnJWWDS/rAsaboClIq+zoWQArCjPRLOebKqTfZ58DIWb/4PCn+n9SQvSjiGtdqFAkmLWk99TtUcRLRn9sxhdzxDYFMvzgKIupYcJ2acP1WB5jLI0BeR+sHp9Q/wYHDOLf8Iv5o9ZGfx9AxyEVHj7oolI6ERco7xl6++hHDvGIQ6bKjOqNj73mVUgkS8Y+6QAhS1fPIb6BSQqBagFj3Z7aCmfFiW3rquaNtp7htnU/Bpl3BaYczU8QdG1I6Ilf2wSRBX7vUeHjV89PtlWJgoAs7Ea9/MHVXqdVDaFhfT+zbwSoaI+FwANsPeEEKuwYFRFfX4IuldRl00Du6biji4fsiYeGOV3oIPaYwtZue0u3GWZua325bdU80BdpE348LoiHhGEh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--n7xt7eiet7j4nzny
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 4/9] dma-buf: heaps: Add debugfs support
MIME-Version: 1.0

On Wed, Sep 03, 2025 at 11:48:38AM -0700, John Stultz wrote:
> On Wed, Sep 3, 2025 at 8:38=E2=80=AFAM Thierry Reding <thierry.reding@gma=
il.com> wrote:
> >
> > On Tue, Sep 02, 2025 at 03:37:45PM -0700, John Stultz wrote:
> > > On Tue, Sep 2, 2025 at 8:46=E2=80=AFAM Thierry Reding <thierry.reding=
@gmail.com> wrote:
> > > >
> > > > From: Thierry Reding <treding@nvidia.com>
> > > >
> > > > Add a callback to struct dma_heap_ops that heap providers can imple=
ment
> > > > to show information about the state of the heap in debugfs. A top-l=
evel
> > > > directory named "dma_heap" is created in debugfs and individual fil=
es
> > > > will be named after the heaps.
> > > >
> > >
> > > I know its debugfs, but this feels a little loosey-goosey as an uAPI.
> >
> > Well, the whole point of debugfs is that it's not really an ABI. Nothing
> > should ever rely on the presence of these files.
> >
> > > Is there any expected format for the show function?
> > >
> > > What would other dmabuf heaps ideally export via this interface?
> >
> > I've thought about this a bit and I'm not sure it makes sense to
> > standardize on this. I think on one hand having a list of buffers
> > exported by the dma-buf heap is probably the lowest common denominator,
> > but then there might be a bunch of other things that are very heap-
> > specific that some heap might want to export.
> >
> > > Is there some consistent dma_heap-ish concept for it to justify it
> > > being under a dma_heap directory, and not just an independent debugfs
> > > file for the driver implementing the dmabuf heap?
> >
> > Well, I think just the fact that it's a dma-heap would qualify its
> > corresponding debugfs to be in a well-known location. We could of course
> > pick some arbitrary location, but that's just a recipe for chaos because
> > then everybody puts these whereever they want. There's really no
> > standard place for driver-specific debugfs files to go, so putting it
> > into some "subsystem"-specific directory seems like the better option.
>=20
> Ok, I guess I was thinking if the files are organizationally cohesive
> to be under the dma-heap directory, they ought to have some
> consistency between them.

As far as I can tell there's not even enough information in a dma-heap
to add any common debugfs snippets. As I mentioned earlier, a list of
buffers allocated from a dma-heap is about the only generic piece of
information that I can think of, but we don't track these buffers in a
generic way. None of the existing heaps do so either seem to be
interested in this either.

It's also not like it's very useful information most of the time, it's
mainly in this driver so that it can be inspected at runtime to see what
the allocation pattern looks like at various stages and maybe help tune
the division into chunks.

Thierry

--n7xt7eiet7j4nzny
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmi5gDMACgkQ3SOs138+
s6Fs+g//UOYEclDiMQaLHjmLrIy415HNAOvJ45jAQXSXODXhEWUoeeT6VpX4alVY
nX8oVWTi6ne/gxdb5ecijq0xe98suaGyb0ExszrPDOsykvikNhAMO8+hGNgfvnU4
L/lvQqTxM8wGz/D1A7z3CyhBipu8GNIYxlF64O9ejq22NqDZGLykvHupw8SubU4G
LQRHuwu39Yb2Hj+r8IMiSXCjWPHtelnA4HXM7hnURUkRNIKkoSp5g9UQJIlw84Y3
U+4zSs9x9IOUr2l35QMwJEq1R168TIAj6gm1G1eSKxGDlIc5DgU4Ei4QTmki+Qhj
hvToHncu1BTaA5YvpgcFKmgCD1jFX93fx2to90mPpWMonySn4EyL0wAqwycfUuC7
D4mKmRF+Dj5RGmrRATN2yZ+2l+N2GgCzJ9EoNNacTl0fFy14FHVwiqn6OVlrIMVl
+olxYn2Ta8T9EMnKrQquQtoEbFJT1mfXUfAlHFDGJocYgKrO+o1zpFzZtEGd92sZ
hpSs5qlYH7hLQaj7P2Pb29mfloQZ9XK3YSNcttTbnFU2dyEahlPvx/VJTCCQvNeY
g03SAA1priYhlLGKdaa19fDxICteA6dmc9Ba6ejSvKXLHejTFlLooK+hkSmufJIu
3DdzixdgWcOsgxrw2vvHlU0U5bPvKnfbiUJUL557Iwo9vw3KKHw=
=G6AW
-----END PGP SIGNATURE-----

--n7xt7eiet7j4nzny--


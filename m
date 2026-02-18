Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0E59E9A03E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 09:42:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 582BC6B0088; Wed, 18 Feb 2026 04:42:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52FD56B0089; Wed, 18 Feb 2026 04:42:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DD426B008A; Wed, 18 Feb 2026 04:42:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 280066B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 04:42:31 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A03CCC1C97
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:42:30 +0000 (UTC)
X-FDA: 84457087260.23.9232186
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 680AAC0007
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:42:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gWI4KHde;
	dkim=pass header.d=redhat.com header.s=google header.b=Li3FvkDB;
	spf=pass (imf22.hostedemail.com: domain of mripard@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771407748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pbLBL9om1fu4jfoAPaZMybNUHZLF4uVBzJp7dWB+x3o=;
	b=LUv1EEUNUc9d9cVpKW7xQfg02M2xtpglRnk4EogJZEcBoYMFFAKgAR4/zNWTn5MLGYkvbA
	Ty6ITHHoqSjZ2FWpMcIojDZvBzVt1mKgwnl/FDgtv/CdLb9toUKuNcGVjbGfMUc361Vc9J
	Mv++1WhYrRCwdzr5lXT3JYNHdpqZr/A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771407748; a=rsa-sha256;
	cv=none;
	b=oxPsogXWusrCiZKe2Eh5qRltVVuNBj2/Wm8IXrZxRJjk6VPqMTP0dL/9k/LGbWj+j5I+uK
	jwQd2PpGsWLHiNrrhQrjiyp3EmDWjVOyCGm12pqXs1eN9N1l2J85JlnllHMJnmwHapS3wQ
	ZMcwcFpeBhCOM4lScbG9WZEduleixSk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gWI4KHde;
	dkim=pass header.d=redhat.com header.s=google header.b=Li3FvkDB;
	spf=pass (imf22.hostedemail.com: domain of mripard@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771407747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pbLBL9om1fu4jfoAPaZMybNUHZLF4uVBzJp7dWB+x3o=;
	b=gWI4KHdecNmAia8vYNTqcTYziVBtrSBhv5mK57KrBb2Gp/AIxtZ8lDxaFGa7W5mxJxUp+W
	Vtf2GXETglFQL7X5YlXCWePhnejw6ow3gDQ30kggVuRjdoHy24MjG/nxKs0Wkv2jXR7Z60
	gChheR+MrRXP5YxUy35/43om8efDvKQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-529-LDZjIKHwO42iYqSgKnASLg-1; Wed, 18 Feb 2026 04:42:26 -0500
X-MC-Unique: LDZjIKHwO42iYqSgKnASLg-1
X-Mimecast-MFC-AGG-ID: LDZjIKHwO42iYqSgKnASLg_1771407745
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48069a43217so50489085e9.1
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 01:42:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771407745; x=1772012545; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pbLBL9om1fu4jfoAPaZMybNUHZLF4uVBzJp7dWB+x3o=;
        b=Li3FvkDBqRyj4M8pvNgmjw7nk4o/+jObXT/X46Sz9qOH8r0TMtudbcdjmLcger0jTi
         j8s1/M00wjQaP11/lM3/Jv1cSTMA51TXmUtzR5sFdr4QfdHL9tuSLIpiXWVPtcDh5FoH
         aIYTWrCwdmBvhJeLO8CpVYpMTXaWtGc2XMBS8x3U3Ml+i1JWxGf5VKC8x4t8eHnpGv1v
         NYGjuhvoPZUf3bFsurlZxV2m4oCiaH0179VpTvHkpgOog3o36xrbnI3PPEjMrT1bcme/
         Qv9NYSMsQQhcIgtXn0aFvYgsZbQ2n75hJMLjSZNZbyiIgDc6jsFjaZosOrBRjK8ciSRf
         s+rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771407745; x=1772012545;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pbLBL9om1fu4jfoAPaZMybNUHZLF4uVBzJp7dWB+x3o=;
        b=cxXIKnssaIRtqL/jTn/YgbCESF1v3zlq8aCkyXUGHzEVMNP3ZQn03EM0P0nDZnBBrU
         sMLieNsRmoFnjrm7PphVIZ8cG5KuWG/57F1w9v3Ml82am2lB5mfivwzYLNKAQHXGSyj3
         Gj5NPC1qEJOXg5W99dZSpGpeRat6DhZpt1t7N0ZaywD/a32oYzuZ3T84IpIuFypzbty1
         IW9MPfN+RsrEdAu8oEl9evefJO5JADzN0ZNsjGDdDOuVpvOgSIMyEAHwZxszdWewhTuM
         AiPuXysTcUUhVhctCR7nmh6sXkcSGiCgFAF67ccKCtDeiPu79u3Wk/f1+fdSpaWcKqa7
         uhjA==
X-Forwarded-Encrypted: i=1; AJvYcCVBr1c/rKAtNbJQjDJSk6axxW+66feZafZ7Y4hW0oxtfWwzJSO9g3I7zG+AW8U+Tm5vX3gZDYD7QA==@kvack.org
X-Gm-Message-State: AOJu0YwhVP3cPyqYslnJlnxB87m5qyh5hK07aWKZ/QrJ+e/AC9D95rkd
	4BTqQfgauWiIcSVlwVC9FoBd1WutbQKwnFBaR3VPOud8tUT04MUK2ThJ8YcY6j5FHVbDWoacAkg
	5qge0FtmX+sWkCK3B6UFy7kc/GAL5AhHSrSK1jvt0uExcSvIyemCH
X-Gm-Gg: AZuq6aKzdRFa5J3XUXxX6+pvy/kh9HY5BFhLyEAOFfLuQrlYgPeW8Hroqn0N9Jt1SKu
	vEbFQs61Z0NvDHUqhW3oc3XCPcGWsyyOXB62DNl7mIhqe5JyXKMRqcz0DmGhQPQhghsIL9xj6X4
	Yyk0ZPMtjFXM/8QvVAJvvGSwN9VtRsUA2XqUQvNFF7HxrQjMgzwkRQzr/VuDKmHjM0g1V8TuEzL
	4/8wRPXpC3kgT8GZ0F3ONxC7wCMCuW+bkKu4R+Z2jco/Q2FzCiYDce4MDyDneoEDYgz13BCiiFT
	gLnm+R9J9+7wA+7J3CqNUCsY4Xh725QI2OKIJaKm1wVN9QXUhTUMXPW4bK9pYuHqR3C7X2asfg=
	=
X-Received: by 2002:a05:600c:528f:b0:483:702f:4641 with SMTP id 5b1f17b1804b1-48379b8c45fmr250986195e9.3.1771407744685;
        Wed, 18 Feb 2026 01:42:24 -0800 (PST)
X-Received: by 2002:a05:600c:528f:b0:483:702f:4641 with SMTP id 5b1f17b1804b1-48379b8c45fmr250985705e9.3.1771407744101;
        Wed, 18 Feb 2026 01:42:24 -0800 (PST)
Received: from localhost ([2a01:e0a:b25:f902::ff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4836ff00332sm354774195e9.2.2026.02.18.01.42.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 01:42:23 -0800 (PST)
Date: Wed, 18 Feb 2026 10:42:22 +0100
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
Subject: Re: [PATCH v2 06/10] dma-buf: heaps: Add support for Tegra VPR
Message-ID: <20260218-voracious-orchid-malamute-febce0@houat>
References: <20260122161009.3865888-1-thierry.reding@kernel.org>
 <20260122161009.3865888-7-thierry.reding@kernel.org>
 <20260123-meteoric-butterfly-of-imagination-fd691f@houat>
 <aY3nov29aBGWw93Y@orome>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="4auwmrzja7jm6td5"
Content-Disposition: inline
In-Reply-To: <aY3nov29aBGWw93Y@orome>
X-Rspam-User: 
X-Stat-Signature: etw3s9psw5k6bhciasn96hmf4cbf4sdh
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 680AAC0007
X-HE-Tag: 1771407748-439320
X-HE-Meta: U2FsdGVkX19wtFMrxqEQuYYkMAAkufEYu6VYB8EFgS8C+Yo8PSVDGUSA/jwWzZYIY94ogcZGbYQ+xo/uKIGbM7O1Fk0kkBGlFUPwWpYtZhCG1eZz4VD2e44/YiH5GENSacCnttlnutvTGDc0PUc73Ji6vsoMh0jGbbKdIJX2UoRLGVCmivKapzRZiYIgEN1RkdlTF3skJPGnxaA6IHctrs2nAcBvZVb3wo9xHYIX0WllrpQG20eP1C5EJavGa+s8ajYxd+rqRlfc6IDDo5INHAlBg0+hYkeza3tU17t4OcaHTeHC0N6ym47UDGPjVh/OTHVWqKjt1t8popETpXlN+bzy0Ho0IbhBaySaVrgjYGQaPEHhVRyFh2zbFzu0KdNvo51p6DAQjIclaG8IZp57KBeiiX2tlowyan9iU1xzL8zK45N1SPczHjImFawgsPDwT5ZIwc+bCF2GkHX0k6CTN4v4wviSDVT1gjmmk9MoJeU5beRzlgB2PcPJ0ZTS+IBlCVbOTzpZHFpNFeaJ1WpTlCmRAqrV9L7xEc2FrKrfzge1eR3u0u5PkOmsXzm1J7aMDtLgUkpV3x8Ok1WvjMQugPxmEbtNhSvbXJ3BGcPYvjI0gMGnToaYJWHk5XTvro+HqvLRDKn0XPP+sdAX8Jo9Y44F7wM5qjrO0nVmu79FU0QgWpEhUnO8uEIZXck/IQe2UVn8YEqwsW04qdiEL/7X5Cwgz5RXwYhUOKgxnilj+NrVIHf6jGU+rtjA57qvQqV4SRhNEt6TBNLMcL8NsNfTKDxcq5aeVEgMiaxA20mzswI9ChOndOBdMpo7qRoT00h283ISZL181FqBtk4j8Y8a0l2mpbaP62pgl7VoCrcxXvIK2ZZQ/L2C7zrtw1pwRaDmY3NEDnT13wEEjlFsLRQvk+oIOV3HmNLVSJWjm8F8oDjIFxh3CbZ58nngRlmtJeM8z/RC/TF6lMJWtuFspzy
 QFSjwH67
 YAFqrocDKLaBtpZQEPljBqM7DbGByr8Y+yv8nZjhCDllYFDiLdl+ytn4ekCH3F5MFEtYVfdAjtLV7iCyLDfLWhQrfVVvuTR0RjLH0aiEGK0nzzkiFuRdvCty1+CICxBlMq9G6/kfh0DHSnz+4hGp876tmTw1x4kFjr+xJk7bKbGdzxD/IVBb5A63+wMoGWgwG2+AJLILXz/cJCWwuP8Kogvy+Q+1urF3tFhNmCN5FhamNk2g7ZJufzVt2H11Y0WlRDbKN7rgUW4H4IQwkUGuf0Ex7QxIaBfA7TsCqjveqSGvCJ2UEPSIN+/ZbWVkHHV4nDKNLhuQe6rbpMSZZnH1i8Bot0XUvZkH1E8Tt+adsyjnbrIevEWyIj5GYTGGFzIpqo4WgOaejTulJA562RtM67be21V79XLWaW12CYujk47Ie2wPcq+1tMU2KQ9BAm7oqR7qo9gpW9d9YyrCDcZ7uGBdgTXXMCAgn3VyHVvW5prhrHpIePFjN3z5Rnm7D6hhc7weGPH4xvpAIgH/+LYzJk92eQ8vmkaoL1h7tRTz1sVZ8CJZqyeGIPNqj/1QONp5fMhXrQLcnF64YdOkcOPvztJMZnw6v3HtEjWx0U7kRQW0RLrgCyJrwJ9HXRe54D7+aR/1Dqtdbm23AriDKE49KIl3s0c23PuvrkD+9FGhs25ITTR+BwYUY3cxM6e50Bsl73TXO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--4auwmrzja7jm6td5
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 06/10] dma-buf: heaps: Add support for Tegra VPR
MIME-Version: 1.0

On Thu, Feb 12, 2026 at 03:50:09PM +0100, Thierry Reding wrote:
> On Fri, Jan 23, 2026 at 02:30:14PM +0100, Maxime Ripard wrote:
> > Hi,
> >=20
> > On Thu, Jan 22, 2026 at 05:10:05PM +0100, Thierry Reding wrote:
> > > From: Thierry Reding <treding@nvidia.com>
> > >=20
> > > NVIDIA Tegra SoCs commonly define a Video-Protection-Region, which is=
 a
> > > region of memory dedicated to content-protected video decode and
> > > playback. This memory cannot be accessed by the CPU and only certain
> > > hardware devices have access to it.
> > >=20
> > > Expose the VPR as a DMA heap so that applications and drivers can
> > > allocate buffers from this region for use-cases that require this kind
> > > of protected memory.
> > >=20
> > > VPR has a few very critical peculiarities. First, it must be a single
> > > contiguous region of memory (there is a single pair of registers that
> > > set the base address and size of the region), which is configured by
> > > calling back into the secure monitor. The memory region also needs to
> > > quite large for some use-cases because it needs to fit multiple video
> > > frames (8K video should be supported), so VPR sizes of ~2 GiB are
> > > expected. However, some devices cannot afford to reserve this amount
> > > of memory for a particular use-case, and therefore the VPR must be
> > > resizable.
> > >=20
> > > Unfortunately, resizing the VPR is slightly tricky because the GPU fo=
und
> > > on Tegra SoCs must be in reset during the VPR resize operation. This =
is
> > > currently implemented by freezing all userspace processes and calling
> > > invoking the GPU's freeze() implementation, resizing and the thawing =
the
> > > GPU and userspace processes. This is quite heavy-handed, so eventually
> > > it might be better to implement thawing/freezing in the GPU driver in
> > > such a way that they block accesses to the GPU so that the VPR resize
> > > operation can happen without suspending all userspace.
> > >=20
> > > In order to balance the memory usage versus the amount of resizing th=
at
> > > needs to happen, the VPR is divided into multiple chunks. Each chunk =
is
> > > implemented as a CMA area that is completely allocated on first use to
> > > guarantee the contiguity of the VPR. Once all buffers from a chunk ha=
ve
> > > been freed, the CMA area is deallocated and the memory returned to the
> > > system.
> > >=20
> > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> >=20
> > Aside from the discussion on CMA, it doesn't look like the heap defines
> > anywhere the attributes of the allocated buffers this heap provides.
>=20
> Attributes like what? Where would you expect the driver to define this?
> I don't see anything in struct drm_heap_export_info that sounds like
> what you expect, nor does the allocation ABI provide any means of
> reporting attributes.
>=20
> There's also not a whole lot to this, other than that the memory
> allocated by this can't be accessed by anything other than a select set
> of devices. You can't have any CPU access to these buffers (the hardware
> will refuse to let the CPU read from this memory) either, which is
> hinted at by the fact that no mmap() operations are allowed.
>=20
> Can you elaborate what you're looking for?

Are the buffers you're getting when allocating cacheable? uncacheable?
mappable? physically or virtually contiguous? etc.

See
https://docs.kernel.org/userspace-api/dma-buf-heaps.html#heaps

Maxime

--4auwmrzja7jm6td5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCaZWJdwAKCRAnX84Zoj2+
duX+AYCJXsCjOrlEdYQB6RhYNSa4Pv3CLkFQFr1nVSSBelNLtgkkxbQHuCJrRHFs
/M4ii7YBgMXgh8YAl2SPDy/1KeWGMmlbxnWoeLENw02uUWqVixSx2Xv05JLfe8V/
j/WNZ8aHOg==
=vKsS
-----END PGP SIGNATURE-----

--4auwmrzja7jm6td5--



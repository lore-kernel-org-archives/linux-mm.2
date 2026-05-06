Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B72ECCD3439
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 09:51:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEE536B008A; Wed,  6 May 2026 05:51:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9F576B0098; Wed,  6 May 2026 05:51:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8E646B009B; Wed,  6 May 2026 05:51:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9E866B008A
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:51:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4868D120107
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:51:06 +0000 (UTC)
X-FDA: 84736526532.30.E177400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 09A43A0002
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:51:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RI27SDbK;
	dkim=pass header.d=redhat.com header.s=google header.b=lqfJ8hNa;
	spf=pass (imf15.hostedemail.com: domain of mripard@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778061064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vfrATgQHWoLdism2lue+ijTptYIlhESry+/AqSEnFWE=;
	b=JHYvWI+VmNuFoQXBf8KjXY4KGI0ebHHxtamrdxGKbUowFTL6Q4C+n2vrvLSVkakcNr1PI3
	iZPl90+PE9JgY981QZDZt9QuNAvklYHZEmlfWOa8UOu7cvvxdPTWs4HfSAqEZ+PKhwrLvW
	1j1Ow8qGTpk7/2oE1TodFDYuH3+QZ6k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RI27SDbK;
	dkim=pass header.d=redhat.com header.s=google header.b=lqfJ8hNa;
	spf=pass (imf15.hostedemail.com: domain of mripard@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778061064; a=rsa-sha256;
	cv=none;
	b=1W6hxwANtWYI2jCLErV3eJb48cIlOlKQepL6SwxntPyObpTOc/qnroXataMo2p0tXduZqr
	vr3/HYqkpm38C0HgyCzKZsVQoR23pa89b6SfR2O5ZVg+UYRxqeGZQcnUSbo0wq9nDN3Vrr
	b2dFpry8XP2bIAguOBmtk5lOHGW50XE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778061063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vfrATgQHWoLdism2lue+ijTptYIlhESry+/AqSEnFWE=;
	b=RI27SDbKKDguoKKMbbzFH5qRa0MoeviY4xlJbsMLl7Jt2poMo0opihyY+5fM0OXw/908LH
	q/xE0FtLRnYeCQ12+/v9O6t3tHmcJJlYGKjnmSlZ/9egSs6XULXLM9/6AwIzW8uIald+Pq
	jIwPdQqSoD6Nn9J29NX6ai1uqB5WTng=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-133-GoUOL_DAO9u1_cxvG30XQQ-1; Wed, 06 May 2026 05:51:01 -0400
X-MC-Unique: GoUOL_DAO9u1_cxvG30XQQ-1
X-Mimecast-MFC-AGG-ID: GoUOL_DAO9u1_cxvG30XQQ_1778061060
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-44f56d5523eso1992825f8f.1
        for <linux-mm@kvack.org>; Wed, 06 May 2026 02:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1778061060; x=1778665860; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vfrATgQHWoLdism2lue+ijTptYIlhESry+/AqSEnFWE=;
        b=lqfJ8hNavXoKSLySVUtNOfBH1OVPzWyLJv4qCLIVHo8Jx3i1Hd82/eHc28tNV1DwyH
         +O7ETSGqsfdeAuc4mOzDK7Amvf2+0QsLYOdMmV+aKKUc3jJWEGle9/zorOz4AfGD4gO7
         lNeIB9NsfZRU7R1kCvAOHUrqhPV99JxCBWg0nhvp+Xb+kIjXr8U3D2BjPBdL+XwXUpv6
         dqNJRbgTAMUt6i1S190KLxNzsE/W2IRHNdvm2DfK9RWcxWGbVq9G1k6iX1kzgirAmLoD
         r72tmF5hl1A2ETCZ63zqRfD0xqBNz7GcMb4ut+ADaqkTopOFDJMCpTXmlfO2zKTwL96j
         Cymg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778061060; x=1778665860;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vfrATgQHWoLdism2lue+ijTptYIlhESry+/AqSEnFWE=;
        b=VNq71jRqMwopOGGC1bqi7FPEBzaS7sF6Mw3R2dJOFjkN6v8tdy2N8Xq80NPUBr6pSD
         xkEjggYSroSQlMAkz4P23SDxM3q9dvW8845UBFmxDpNrwKnssiAL1vyxD+51npsqW1Mz
         7WW+152Vx110W5W+Zoi33zgMQ5tg1Om7uqayCw/S9U5MBIuPu/fGWpSNLHsrNNVzxjXg
         ejmBOdKB+dsnQ5TF3/DP5tzeZK6razj2To+YvB3ebkmW+Ud87h2Lf48CE6YooXe7vrFq
         7987E6r4J2uxHx4sgPdFsS9/PqJrGQIL+rrRaKKm81Z2r4cemBRr3kLJTgWWyJ4TyC+v
         DzTw==
X-Forwarded-Encrypted: i=1; AFNElJ8e5slWZv6ATORbBA8X88h3iZWw5D10yh+rJILXEgO6CBPy3CH6e/okgBGo0RjZgpjSqcGo3F/3+g==@kvack.org
X-Gm-Message-State: AOJu0Yzl8OT3ImuDV8Z58m9bKDaZ3UbrXkJjYuF9rwlLFzh3bl9oKIlQ
	AmACUp1z6K+DKMms1TNdBrQ1+Jjm6JukIPFtFu+NKSiul8SntrLSkQjkSsUU0HrbL/+7s6Uht2l
	b6yIFFD+yl8a6/ZmbIG6Nv8JA3siiGQs7tcbB/xQY5YYMN04sdRvX
X-Gm-Gg: AeBDiesNCEu3H95XwQZr7Drim8d9Q3lAxxT76xBoUIIfbMPq1CU+XSUttPeCueGFXws
	ZB32MK+A7kxyjjbaipSA5i28V5QcnjalIb0qT46mAlTMjIaBagPgi/+2LW458hn/mVgabomz/dT
	jwYtVzfQp6GdwF9Xuw1o4/Z6AKY6YR0ehjlr/qViwlLcepZazM/lrrnzLxwwQ1HEFezFtVM+dKr
	OPoexGnRPixARIoq/slG3KL6oTsbbwruZft/EwFkl4GoKvbsPw0+zr2HUfq9dyL4FM+r3slZJ5K
	qxUuvHEJYBU/DDogd8hlBH/lNfp7S1R0KzWqfZAEsXKzcMKchNFr0lCyS85Cd2uViwfYsFQpfVg
	M/JQCCZ+N
X-Received: by 2002:a5d:5f83:0:b0:446:ef9a:8f41 with SMTP id ffacd0b85a97d-4515da970a0mr4473809f8f.40.1778061060029;
        Wed, 06 May 2026 02:51:00 -0700 (PDT)
X-Received: by 2002:a5d:5f83:0:b0:446:ef9a:8f41 with SMTP id ffacd0b85a97d-4515da970a0mr4473777f8f.40.1778061059498;
        Wed, 06 May 2026 02:50:59 -0700 (PDT)
Received: from localhost ([2a01:e0a:b25:f902::ff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45054b02abbsm10793056f8f.18.2026.05.06.02.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 02:50:58 -0700 (PDT)
Date: Wed, 6 May 2026 11:50:58 +0200
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
Message-ID: <20260506-tentacled-unicorn-of-typhoon-cb4edb@houat>
References: <20260122161009.3865888-1-thierry.reding@kernel.org>
 <20260122161009.3865888-7-thierry.reding@kernel.org>
 <20260123-meteoric-butterfly-of-imagination-fd691f@houat>
 <aY3nov29aBGWw93Y@orome>
 <20260218-voracious-orchid-malamute-febce0@houat>
 <afJSQbArB8USb6mt@orome>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="sztjivasnlwpybgk"
Content-Disposition: inline
In-Reply-To: <afJSQbArB8USb6mt@orome>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 09A43A0002
X-Rspam-User: 
X-Stat-Signature: 95znwodbd8cnm9tdcxfwp6oa3jc1c56x
X-HE-Tag: 1778061063-863134
X-HE-Meta: U2FsdGVkX184l/9mG5BZk3KVMugaQ7OGD+OYB1yanT1prcbKncyOCJLQ069om6KfPYr8vMNh79dBjbN0ai+qaULW26oDiHMMEztys2fFIl2/elTkIpZQFTkkBHuQRV3klNTXOSrj/XUcU/6wNYb57q0NjKvPh3EDNOTogZBbXSMAhyvY9kLKcSGDiwpLPUc0Ny9W1dG+jsfmKd6F3kIItRzpyHpXbU8i+H3zx558x70UZJBwyUfWj7h+rKD6UeP63nTTeNQc/ncrUOOG+BU6VeOZFqRVrjA/zru99zDDj1G0UrsW//dZLElei16fvDOx/CyorLVQp/th/D2aZ/umFtzmUwQU76NGrIWWPNnRCutaeyFSMN/iZ0FLuxXtS/m9PCvyZs0qLrnpnfd3JImT+BCwk2c2zS1WtGtNQJxrSGqR+wSStPtsm5HYybz8aWhSxNgJXrzs8oSBO8XWunEodZA4lP1YhzSWvn3I9ekiHecuZujnbyBJNNuk6hQGb+x6pO2Mdby+RnY+znBtUrD+x4+8tBOH6jeJIPB7r7dOS3vGEwtaPw8BPZk6wLCgURT2plhgM8yA0Ko3KOvxxJsNKZ7liixUheJXvqP6adJbMRkyxXIaotUnPLeS/p2RwtiO8gzPxlk5D7E7UjkKqep5gKfN8FnZl3fJb1JT8DEUV6beT4/pHvMPsDOAoqVicVRT2S4/cED9T8DAWPt8wergwe+m0b5+gmhPbwBGNY/y7pjEHla48yWflmtVQYvyprmhmGricRcj6WGNFr0dn2OYcAsfa6o29wfEDyrusf7BjY5QlDer6v3dStcfyut1/snzfmW1qpJKaQC9lCzUcGJa2pFDk/tP2xjV6sPjS67eDCbDcyRfwE3KsgII8Bs7zHPDTl7JyHshNBijMM9XOH806/ewJtev8DOGJW00pPxtPrtb0DXdhgMYbjPl+PdPzpK6uEb26y6y4rqq0qoKZaR
 356rkiHz
 TrOmQpwRmbwtXKyxWEHy0kvsGSPFKPpaw4rli5gOAvemiAKuC0umqd43pSx84r30wRZ1VqPO9RVO8ee+lJi4dzDGKRXPkQM2mA0qWqAmrtG4GiriqrVOdOD1KnfncMoBYAKk3Xqdgz5Ac6fOWrPXYBYD+Di7yWMF26JkxZnotfzYHSeW3q/IjCxFp0HopnmDTT0qzuJwhCepALfGk1rpzWqPJ7qs3ZCFtGlphf8gSsaroCErPj1+S3g8PYCZKgna0PMLv7Z+TsY3Frk8h/x+HiebXFt848Npee+jecE6qX6cpszFpKVjqap+Bdq8AJbdaGmcI/xV4bkItUz0m8gMVUJkcIyj6kWGqJwjyleMMY5J9f5Y8fViP/I7tk6LD9P78qKsNC9yiKB1r5KfYDJAAMuAXWGkA0Ggs7Pt1brk/vBBFFepU9kDiFzZKA7VUdKQgG4RGVR7IHYMurqJjc+H0IcfaXmPp0HulNF2NIYOw6cxvF4AonRix2TtzVycqJ1irfuWJMjssDeVflE6Z0XssLyU+VNzaxHa+SpeXjZFaoooq85g6ksH2xHc52ownzjuxP7dStM/9cL8XjWecParntd2QA9EmywINxhbGAjRNuNrNXfc6ZPRkYTzJeGT0RGuXzqFL0VQegB/Bs5rOZu/4PXg7VebQ8EFrRhoFP77ct9bJZZQxOVhdTUXrGDvUTj6X85xR/GVbMqPGTK2YHwTSZJhAVkgUwhXMp4GoSKD/9z5ik0MbhsKZdFu4HQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--sztjivasnlwpybgk
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 06/10] dma-buf: heaps: Add support for Tegra VPR
MIME-Version: 1.0

Hi Thierry,

On Wed, Apr 29, 2026 at 08:49:58PM +0200, Thierry Reding wrote:
> On Wed, Feb 18, 2026 at 10:42:22AM +0100, Maxime Ripard wrote:
> > On Thu, Feb 12, 2026 at 03:50:09PM +0100, Thierry Reding wrote:
> > > On Fri, Jan 23, 2026 at 02:30:14PM +0100, Maxime Ripard wrote:
> > > > Hi,
> > > >=20
> > > > On Thu, Jan 22, 2026 at 05:10:05PM +0100, Thierry Reding wrote:
> > > > > From: Thierry Reding <treding@nvidia.com>
> > > > >=20
> > > > > NVIDIA Tegra SoCs commonly define a Video-Protection-Region, whic=
h is a
> > > > > region of memory dedicated to content-protected video decode and
> > > > > playback. This memory cannot be accessed by the CPU and only cert=
ain
> > > > > hardware devices have access to it.
> > > > >=20
> > > > > Expose the VPR as a DMA heap so that applications and drivers can
> > > > > allocate buffers from this region for use-cases that require this=
 kind
> > > > > of protected memory.
> > > > >=20
> > > > > VPR has a few very critical peculiarities. First, it must be a si=
ngle
> > > > > contiguous region of memory (there is a single pair of registers =
that
> > > > > set the base address and size of the region), which is configured=
 by
> > > > > calling back into the secure monitor. The memory region also need=
s to
> > > > > quite large for some use-cases because it needs to fit multiple v=
ideo
> > > > > frames (8K video should be supported), so VPR sizes of ~2 GiB are
> > > > > expected. However, some devices cannot afford to reserve this amo=
unt
> > > > > of memory for a particular use-case, and therefore the VPR must be
> > > > > resizable.
> > > > >=20
> > > > > Unfortunately, resizing the VPR is slightly tricky because the GP=
U found
> > > > > on Tegra SoCs must be in reset during the VPR resize operation. T=
his is
> > > > > currently implemented by freezing all userspace processes and cal=
ling
> > > > > invoking the GPU's freeze() implementation, resizing and the thaw=
ing the
> > > > > GPU and userspace processes. This is quite heavy-handed, so event=
ually
> > > > > it might be better to implement thawing/freezing in the GPU drive=
r in
> > > > > such a way that they block accesses to the GPU so that the VPR re=
size
> > > > > operation can happen without suspending all userspace.
> > > > >=20
> > > > > In order to balance the memory usage versus the amount of resizin=
g that
> > > > > needs to happen, the VPR is divided into multiple chunks. Each ch=
unk is
> > > > > implemented as a CMA area that is completely allocated on first u=
se to
> > > > > guarantee the contiguity of the VPR. Once all buffers from a chun=
k have
> > > > > been freed, the CMA area is deallocated and the memory returned t=
o the
> > > > > system.
> > > > >=20
> > > > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > > >=20
> > > > Aside from the discussion on CMA, it doesn't look like the heap def=
ines
> > > > anywhere the attributes of the allocated buffers this heap provides.
> > >=20
> > > Attributes like what? Where would you expect the driver to define thi=
s?
> > > I don't see anything in struct drm_heap_export_info that sounds like
> > > what you expect, nor does the allocation ABI provide any means of
> > > reporting attributes.
> > >=20
> > > There's also not a whole lot to this, other than that the memory
> > > allocated by this can't be accessed by anything other than a select s=
et
> > > of devices. You can't have any CPU access to these buffers (the hardw=
are
> > > will refuse to let the CPU read from this memory) either, which is
> > > hinted at by the fact that no mmap() operations are allowed.
> > >=20
> > > Can you elaborate what you're looking for?
> >=20
> > Are the buffers you're getting when allocating cacheable? uncacheable?
> > mappable? physically or virtually contiguous? etc.
> >=20
> > See
> > https://docs.kernel.org/userspace-api/dma-buf-heaps.html#heaps
>=20
> The CPU doesn't have access to the contents of these buffers, so
> cacheable or uncacheable aren't really meaningful, but I guess they are
> unmappable in that sense. The buffers are physically contiguous, but I
> think "protected" is the right name for the heap since it most
> accurately describes what the purpose (and access pattern) is.

Yeah, that's what panthor has been using too:
https://lore.kernel.org/r/20260505140516.1372388-1-ketil.johnsen@arm.com

--sztjivasnlwpybgk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCafsPAQAKCRAnX84Zoj2+
duZVAX4rZKstjm4yGIoK4/qxMtpVXLGWXrhCS66Fx3Nz2VUdigwaNxKdo0VUnHgz
6sVzgJsBfRq2AlW+F/stHpXM0fMsHUXere2S6tyHKPw8gwt6dAO5rXziaIeIl7HL
rUTTJPnxiQ==
=nQPK
-----END PGP SIGNATURE-----

--sztjivasnlwpybgk--



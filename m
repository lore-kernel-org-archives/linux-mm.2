Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C8F0CD13D2
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 18:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BC876B0088; Wed, 29 Apr 2026 14:50:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46DC66B008A; Wed, 29 Apr 2026 14:50:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 383856B008C; Wed, 29 Apr 2026 14:50:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2772B6B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:50:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AEC7C40336
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:50:03 +0000 (UTC)
X-FDA: 84712483086.04.39BB709
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 06F7DA0007
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:50:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZiKs4+Ko;
	spf=pass (imf25.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777488602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SJYZ4NAfB0jKA2r12K3oUXg2EYSzdPCWQ44kjGJMgLo=;
	b=zDtmVDCa1ano85i5THqKonVpF1STQxZ+82/gkAXPgeIO8wCdccEY7W8jf5vTusiC9EZyT8
	7vPDAAPNlRcyuRNYYWA3fdcyUx9pTXfNp91k6NfEhb5/eT7TMKsk+f1O+ddRccjIma/NhL
	eNah0kqRmo1xHolaVGDxs1eRJ/hLOpc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZiKs4+Ko;
	spf=pass (imf25.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777488602; a=rsa-sha256;
	cv=none;
	b=hA93/bdaujPUhVk8O86UxGvrFOBko6KbLwqmbvtZ0DgByXxjcycVC44fJX1Lag85LQLxsq
	2T2TPhN//XgzlV28jHMg6t+L4mODzUiGCgy45wI+v7Q+56d4Rn1VcJuq2MzN/yGJYnnp7Q
	kFtcD/yrdpS3piY/2CaVYAtIdg+oV/4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 349D36015B;
	Wed, 29 Apr 2026 18:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BEF6C19425;
	Wed, 29 Apr 2026 18:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777488600;
	bh=SJYZ4NAfB0jKA2r12K3oUXg2EYSzdPCWQ44kjGJMgLo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZiKs4+KokO+v2SHr7cJRFjeswZtDWAzjDIi7YJZLFDicOWa42t0FtJ97scrmoiUiL
	 YsjvGJNaROhTcz31Xxw3IN36HhQVVkTcvWofiM/u+JdnNoCJi51qAjuL9iY8yXa9Cz
	 Lb9/EVcoz/DZ+6UJcQJsHcrbjdeaCuXDVqP+XDLo6nc+fEiZO+5RR09YgxNVqmsRE6
	 f2xwQcVnUTNF42WTKHXUSjGizaJUfdHMQHie5vUwjbIFkMu4R84ualDCvczf7C1DBq
	 GgfoEPpj4WRW5lJCJtmyi77fcvlk4IwucF/VAif6QEZdu8VOln9b5y5Cz4cpHWGcEl
	 285blVyaIgMGw==
Date: Wed, 29 Apr 2026 20:49:58 +0200
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
Subject: Re: [PATCH v2 06/10] dma-buf: heaps: Add support for Tegra VPR
Message-ID: <afJSQbArB8USb6mt@orome>
References: <20260122161009.3865888-1-thierry.reding@kernel.org>
 <20260122161009.3865888-7-thierry.reding@kernel.org>
 <20260123-meteoric-butterfly-of-imagination-fd691f@houat>
 <aY3nov29aBGWw93Y@orome>
 <20260218-voracious-orchid-malamute-febce0@houat>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="d2myfaz5io3m7bs5"
Content-Disposition: inline
In-Reply-To: <20260218-voracious-orchid-malamute-febce0@houat>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 06F7DA0007
X-Stat-Signature: opr7zyfhfqcfxjdy8n99yqp1tc57w4y7
X-HE-Tag: 1777488601-898146
X-HE-Meta: U2FsdGVkX1+3qMkCh0v+hh6HHh0ICu7/IPCm6BhWeDrBjjmO81laEVYo6t9s01LpxJwLcrcZe9EZa3XHwJ2bkLP/S6B9uZX5w0YoTraVTPes32PvKWR2S0UOIxOcGQJzaPBWs4RQ5od9zE733U3CGlLqPa2iX+qa0muPL61lUsPFC3POAupHi5XMFWZ95mNdXjGzK6t3/U8iTC9aqFe8SzlxYllXDfeu8Eys5h2c7QFzS+t5G7Ci8TaLqxGhCba8mEztRgw4iEY1FQEGEZHGtFf0iOut8MzAJjqjeaEmyqYPPT4M6cSbZ6jaBUG/zC58YHX6RtgziaMJb7AG1/guGRszq7kkplpVySgv4OW9WxDPQn5Ky3AnamUlKrJF8YGdTkHeq6qUtSLtfp2hvqDPuMRTIWOsBeR8lzcf7EVSxzEbtDSKNnhZM5mMfoJZKx9oXwrA524ry++v4EPKBbdp/d78YkKmmOiITUNoTWdtcbGc4AaSVd+eGnOi1xeIu/Uaq/0wn9VptV+IxNBO47yoQma3Lo19wEMnhYG5/3svtxbv+yVIBNrsjLqwb0YHCMC8hU99nuTg9Zkn7ET1i+Gq8doWkGZj9zAWjs5/oUPygxXOupOsnNiyE1TjmKSEmjhL1B80PAo/XAA68YlJGSn+rBe/jSy/obBhgspvJHR/fVbHoSEvQ/4U37H3PiJv/pjaCH7y9HbcdKa77R8rYVJNqh3xQgqjYL5cu+1/yrzR94GhGFMcKX4yvdt7wNfN7BdJyi3P2+Jg5MJSLkLAGLW9GOGFke/GAQT2hmicjGFrZOwwv3oAOM9NgYjsNYOg+I6RQTnUyoMdaTUrPG1aooFcZCDVD4oRlOUAOSfiqZ+NJLyymQodqU+0GkbfYiHEiFn5lqAcPea9k2z4hDaxNPMAXeuPYw5n0TPOi2Fl7OuWnoQs3+7zGj5DDP+XleAEFnaIJmByBNZZrTvbfC5ThpS
 UuffwlDa
 NyCTg05ZqByYtpRa2m15FnutlMonYFLqpR/pkBr/MVR8igh79umeK99XuPA2/vsPggNY/xvvcZnrd1kOmeFwxqv/xh6Crw3WOhvSHAPu36jgi9Vlrsce1XFTknqGO4KMK7wRaJW531egmjEMuRcnIClbsW7yf2Xna0z7VJVO0U3rPhs+Idr97Mfm3JI1RPxYWj/IgrZehiHOruRDxIeah8SxwyezkzLO7g5SoAaJvg2Nj7+fK4/T55yE7nTmr6AebwmmSdmAVEPBQIuE3vLG/xEhUU/sH/H1XR1VHZ8ah2mKZvAicMnLHzn1jnRQnmkM5dbXskupkZoUrlNFHx96L0l314KtxCOP8TYoau8Vt770vldFG5fqKE+Uv+d14VDRUqOR1i9NmrxT6ff8PcyVYkmBimNqom2ge9r/s1ZyhaiOCMxuvyKz4fZ3DWgo1mws8fIYEjbh1ILdYT5b1ejfU6XS+Su7UeQoZF/ultPS2wrDrZ8p6Is3mUiK0VQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--d2myfaz5io3m7bs5
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 06/10] dma-buf: heaps: Add support for Tegra VPR
MIME-Version: 1.0

On Wed, Feb 18, 2026 at 10:42:22AM +0100, Maxime Ripard wrote:
> On Thu, Feb 12, 2026 at 03:50:09PM +0100, Thierry Reding wrote:
> > On Fri, Jan 23, 2026 at 02:30:14PM +0100, Maxime Ripard wrote:
> > > Hi,
> > >=20
> > > On Thu, Jan 22, 2026 at 05:10:05PM +0100, Thierry Reding wrote:
> > > > From: Thierry Reding <treding@nvidia.com>
> > > >=20
> > > > NVIDIA Tegra SoCs commonly define a Video-Protection-Region, which =
is a
> > > > region of memory dedicated to content-protected video decode and
> > > > playback. This memory cannot be accessed by the CPU and only certain
> > > > hardware devices have access to it.
> > > >=20
> > > > Expose the VPR as a DMA heap so that applications and drivers can
> > > > allocate buffers from this region for use-cases that require this k=
ind
> > > > of protected memory.
> > > >=20
> > > > VPR has a few very critical peculiarities. First, it must be a sing=
le
> > > > contiguous region of memory (there is a single pair of registers th=
at
> > > > set the base address and size of the region), which is configured by
> > > > calling back into the secure monitor. The memory region also needs =
to
> > > > quite large for some use-cases because it needs to fit multiple vid=
eo
> > > > frames (8K video should be supported), so VPR sizes of ~2 GiB are
> > > > expected. However, some devices cannot afford to reserve this amount
> > > > of memory for a particular use-case, and therefore the VPR must be
> > > > resizable.
> > > >=20
> > > > Unfortunately, resizing the VPR is slightly tricky because the GPU =
found
> > > > on Tegra SoCs must be in reset during the VPR resize operation. Thi=
s is
> > > > currently implemented by freezing all userspace processes and calli=
ng
> > > > invoking the GPU's freeze() implementation, resizing and the thawin=
g the
> > > > GPU and userspace processes. This is quite heavy-handed, so eventua=
lly
> > > > it might be better to implement thawing/freezing in the GPU driver =
in
> > > > such a way that they block accesses to the GPU so that the VPR resi=
ze
> > > > operation can happen without suspending all userspace.
> > > >=20
> > > > In order to balance the memory usage versus the amount of resizing =
that
> > > > needs to happen, the VPR is divided into multiple chunks. Each chun=
k is
> > > > implemented as a CMA area that is completely allocated on first use=
 to
> > > > guarantee the contiguity of the VPR. Once all buffers from a chunk =
have
> > > > been freed, the CMA area is deallocated and the memory returned to =
the
> > > > system.
> > > >=20
> > > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > >=20
> > > Aside from the discussion on CMA, it doesn't look like the heap defin=
es
> > > anywhere the attributes of the allocated buffers this heap provides.
> >=20
> > Attributes like what? Where would you expect the driver to define this?
> > I don't see anything in struct drm_heap_export_info that sounds like
> > what you expect, nor does the allocation ABI provide any means of
> > reporting attributes.
> >=20
> > There's also not a whole lot to this, other than that the memory
> > allocated by this can't be accessed by anything other than a select set
> > of devices. You can't have any CPU access to these buffers (the hardware
> > will refuse to let the CPU read from this memory) either, which is
> > hinted at by the fact that no mmap() operations are allowed.
> >=20
> > Can you elaborate what you're looking for?
>=20
> Are the buffers you're getting when allocating cacheable? uncacheable?
> mappable? physically or virtually contiguous? etc.
>=20
> See
> https://docs.kernel.org/userspace-api/dma-buf-heaps.html#heaps

The CPU doesn't have access to the contents of these buffers, so
cacheable or uncacheable aren't really meaningful, but I guess they are
unmappable in that sense. The buffers are physically contiguous, but I
think "protected" is the right name for the heap since it most
accurately describes what the purpose (and access pattern) is.

Thierry

--d2myfaz5io3m7bs5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmnyUtYACgkQ3SOs138+
s6FR+g/+KsYWfQUZ129aKCUNsoLuGu/cyN7j8T6Z/3ilgL0EC9R58tbva6UNIcs8
8r2onzdPn4w0huB+6STgpihIyHcmj/Uz+Oe99KMc9dtsU9ZJQ3ZXimgI74FU+Rpw
etJC0iu8ZzUj4E46mO2wUxhq1Hw9v/+ozBlejV1Z2+07PrfxYANnB6AfrJctpWfR
oHSChS/KXwfgBN4VJUcDr9Oe9ldyzolQp/8zUNYjfIn7U8y/RzJrm/qk6llDpqmX
JVnqBG6sPty/tCi48FH6zyrD3xTi83Od3oxpLVTPk/wIOJANhJ1EMDXWicQwrWLc
eeGvG0WWTNx7+8Ej95VB/LPguytkBN3QwJwZb9d9gBOYKewiKLM41fSMhSpIjz+j
3g0DhGqKSSlk4mVqw1BQik6+wIBGCSQSZxXnqjtwOoCy7XREJbU+POiSKnczfm7/
5+YVt7Se5070nu3fc1Pl9m0vlacUB6PfYKpR47BJE8KbT5hcyDUpAK96Spo4d1L0
B+mC14GNVj1/cAV9X82JR8MhB+IsZLgWKoXV7VKQOmrQmmN7WF78iCiiYWQ0/1CY
f98vLHUgPFfpyp2laMldeuILA1YYOX73cANruKUqSz2baWdNV/YEAkShnVJxDynq
sUPyc9EarzQeCDHok0jWlg+/+IlZJoXgOHIt3ToaY3R0kns97JI=
=hyUh
-----END PGP SIGNATURE-----

--d2myfaz5io3m7bs5--


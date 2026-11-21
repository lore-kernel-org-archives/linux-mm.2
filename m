Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FC06606A6B4
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 01:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XOvFYE+T
Received: by kanga.kvack.org (Postfix)
	id 14B5B6B05C7; Fri, 20 Nov 2026 20:09:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FCA86B05C9; Fri, 20 Nov 2026 20:09:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 011856B05C8; Fri, 20 Nov 2026 20:09:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C822F6B05C6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:09:53 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4B19A1C2154
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:09:53 +0000 (UTC)
X-FDA: 85457344266.05.7541648
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id B65A0C0003
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:09:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XOvFYE+T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795223391;
	b=p/p5YI1MI4RO0ymzXmAr+ChaHkmMEMWHzzirXqfuejMtWdyQ/ekl2U1plgdHfIoSiYN02F
	AhFrjq38an3nxThBT2qILt8lQtsBqv/fRUlgEtVIiMun5xyKv5+iIsHGrivu3oE0NnKm41
	o7r6eQsnWQB07Xhz/eZXrkvfwUlsiZo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795223391;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/38Y+FPoqQ3SbAvRSfYDCuRB1k1ZW6XJrfVH+lgoa8I=;
	b=ErovCgN+JS8/G5cBWW5GWLm62+c6KOZSZEVExzD/o1Xy71gVTIRcRnOLpuGg+8HRxThPI1
	wW4ZhW3faVhilVReRc782yh0T5ms5BdoAQcmPGx8xDrykj9/yC0V4Nq4aNS9jqLsuZco/S
	0OpVVG8vWx58i/lXVtHyUzbQl4/ulEM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XOvFYE+T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4BC75618F0;
	Sat, 21 Nov 2026 01:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEF01F000C0;
	Sat, 21 Nov 2026 01:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795223390;
	bh=/38Y+FPoqQ3SbAvRSfYDCuRB1k1ZW6XJrfVH+lgoa8I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XOvFYE+TKF4ncba6LRm+ewmC0sPpea/5RsJ2T2vvSoB/IaVP0kN7zf6LAeH5q82Fh
	 cl88WcTzvE8oGjD+oMsfX+x4NOcyLo66extSXvnu2xZ3Cs+DcWjascLrtVNsUOuZ/p
	 vQ0WZEfhQe1hSzahS8hxvbbltEqHAgwNStG7IuynRAI2lujjUiP8Lrnfl5gvO4M1cv
	 BSL28+suu6+G0QEew+XEtArRpryVAD1/g+LCBNunl4NnARQGWAZJkZcCiyN1Tur6Tp
	 c0C8/zg+Yn8Ldi8FzKt9oFmpZZDbPjoM646gEbqgXsRGJot/Lm/BYK7iK3ocsrhlAe
	 oAlhqZxG0RpJA==
Message-ID: <sashiko-outbox-226484@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 20/25] arm64/mm, mm: Support decrypted PISA pages
 in Realms
Reply-To: sashiko-reviews@lists.linux.dev
To: "Luigi Rizzo" <lrizzo@google.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Joerg Roedel" <joro@8bytes.org>, "Will Deacon" <will@kernel.org>, "Robin
 Murphy" <robin.murphy@arm.com>, "Marek Szyprowski" <m.szyprowski@samsung.com>, "Jens
 Axboe" <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>, "Luigi Rizzo" <rizzo.unipi@gmail.com>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Zi
 Yan" <ziy@nvidia.com>, "Harry Yoo" <harry@kernel.org>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Hao
 Li" <hao.li@linux.dev>, "Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Jann
 Horn" <jannh@google.com>, "Catalin Marinas" <catalin.marinas@arm.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Simon
 Horman" <horms@kernel.org>, "Jesper Dangaard Brouer" <hawk@kernel.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Willem de Bruijn" <willemb@google.com>, "Kuniyuki
 Iwashima" <kuniyu@google.com>, "Joshua Washington" <joshwash@google.com>, "Harshitha
 Ramamurthy" <hramamurthy@google.com>, "Alexander Lobakin" <aleksander.lobakin@intel.com>, "Christoph
 Hellwig" <hch@lst.de>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Dragos Tatulea" <dtatulea@nvidia.com>, "Naman
 Gulati" <namangulati@google.com>, "Pranjal Shrivastava" <praan@google.com>, "Mostafa
 Saleh" <smostafa@google.com>, "Randy Dunlap" <rdunlap@infradead.org>, linux-mm@kvack.org
In-Reply-To: <20261120010655.467825-21-lrizzo@google.com>
References: <20261109182533.3594984-1-lrizzo@google.com>
 <20261120010655.467825-1-lrizzo@google.com>
 <20261120010655.467825-21-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 01:09:48 +0000
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B65A0C0003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: buy6pozu4p6ucq9bh1tzh5gikho933z7
X-HE-Tag: 1795223391-712528
X-HE-Meta: U2FsdGVkX18aoHl1Gk3Z6Bf6+FWqaV5WRdQwpTs1+H249Q774MRVqG9d9bnrNhNe7G7z/hB5u6TGR3xK46OitijfDS7jyeAYY7V7gXB2sh/T0HEXnTf1FZ7wA32kU54/3mHMBiQeLAXMtz21ychJ8WfIE+BZAqX12MHwNs+dbgFuVYQJnJhHKIapdX8785ZHh71ojWY18Du1MBfK+tQGMeoYNIlibk5dS6j5NCX8yBveWqZiaImzALIvucnYCJgKJpPCrgCAMyd1infjmj/zPliYli45vrM2UR3B8oMrolx+0rbWkmySK0x4gazARLuNrvXDZXzCQoHLvWQB7BK77CiCAk0HkxffXY5nKT4R4hBTYTjXeFlBVNR4cJDE2ToO/6QHdBrKy/SUml35UH4vZs4PHd3DwgEuiwvZ9Pxp0aylEgum3J6rGKWZzUGEONq4pAN1naOHv+tp09mBbM5vKZj3mSVvxBeQhXUXpYn7e6R4BmNPu2UeHLsilsQsRxCgnElsdAo8DsjoJtWKjjeCrzZVbfvzfqpStZYOP83NlNQtnL+eyUuikDaWgqNgRS3/9sFG1nvc62eO2sMAfltt7DZGtzLvpJlqUTOH/LyxhXeIBGDJ2QyfOvJAwV0QWhCLQzkmegwI53qeq3mfIfaYWIEfzg/fA9/xk6DT9R4VIByN6yP+1Zo3wdOM0vQiBpioi5V+l967gmv4ndA5dgn+PTEgOUrMjAO1s4lSUhL2tJrxDnsiP7x8CjY7/FTsb2R/gCXDhNwDlmwoawS9eMyl5WMw5mwDrsdVnIdIufswVOwkXMW1LSGdNu0f+QtXVnmVuMUnZDtOQsx8unCgyOk61f/NgqUloluJ0k4LRxeFSjKaL47106Xb73tgU550mh9TdAof1lZwZjtRYSdUQ2/nXmyDekymdTFoENcu5gZwjjK+Z0Ej24nbSHKz+YpXEidCmHxaqErAFTUslTBJwRi
 cfYqL6f6
 XTnoUB0LLIATjY+DbKk/gWiszibCDGljmfU6h8W2JJtk60oRkKJxs/MaB3X4bNbu9LzcKwocy0BcvOaSWi4VxLIewSP/RDV21JhQWnzh/rY8MAGJBYw1YQ0FwV9RWXiTe/LkHkerM3QvMfa5KTPp/Jb8EY/AmxLkj6GaX8REjWusM/dbE0gbra6k4baS0iUI6oGrCcoFxZvP4PXwSPg/ojZsVuSTveo+q5dtLVwxUCxE2M7xB+frGF/2kb6sEMDNRW3U4ssjVIq9umoj1j2Q0P2FsrJQ2WFTih/OZ3OsIDWKAM4a5TFsKCdbEK/pmo5lDO54mYtY1OV3Cz1cLi9nWNCEpq3TvN+NamrU4Zh98Zg8CWUJUZHlOM9BhurIexchr9B/Zm2MzT6MI6Z4zbSi9/1lIZPwmHC++RhCKrFLXL7cJr7PIwGx/yLqijqr+F0uEhuyZixFt2OZjI5OpYttQxLF+zQoU+Z88nUWJuZFN/ya66F5IpCGV1qin1+NQfKiybZvybwhjN1IB+4g/n8X+oPYmmwbpphIxCyjQbORILo+kVMj6xOiBRw9qx4+sLjUFDgpe+Gqa1o9xyG6qZ8B1frahzCNN66bZNbBPQj7cxGx5OKrOeckB8V8PGEAO6iTOlzZRvVYqZ9Hex5q0qp3YuGBogqISQ3/az/12IVLf6sYaVheI67hAA1yjqFsapkJgvyBtk/oyeTiiaZ1TULOunx+kKxJSIsmMtgMlAyu9WlPiOSsrInmN/I6i5PZO9bMvbNTSxp+MhpPA0UgcMosfJTdQpBAz70wG6C35NU4gWvmFNo2EiVY5V5GXXRKkb8LHX3LLcuTx5p+/rJHVu/Ps0i1zN199jFA3pVQRva5sJim2khnhKphfsMObK9KBrbJfoXcx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/pisa: redundant arm64 CC_ATTR_MEM_ENCRYPT check in
  pisa_coco_guest()
--

commit 4bc8313e88b22932cffa12afb0c2ba3b273c8641
Author: Luigi Rizzo <lrizzo@google.com>

arm64/mm, mm: Support decrypted PISA pages in Realms

This commit enables decrypted PISA pages in arm64 Realms and strips
PROT_NS_SHARED in __pte_to_phys() when translating PTEs for decrypted
PISA pages.

> diff --git a/mm/pisa-node.c b/mm/pisa-node.c
> index 12fbb617c342b..aa4f8759ae5e8 100644
> --- a/mm/pisa-node.c
> +++ b/mm/pisa-node.c
> @@ -36,11 +36,16 @@ unsigned int pisa_reservoir_max __read_mostly =3D 16;
> =20
>  /* Enabled in CoCo guests by pisa_node_init(): new PISA pages are decryp=
ted for DMA. */
>  DEFINE_STATIC_KEY_FALSE(pisa_decrypt_key);
> +EXPORT_SYMBOL(pisa_decrypt_key);
> =20
> -/* A confidential guest: PISA pages are decrypted for DMA. A bare-metal =
SME host is not one. */
> +/*
> + * A confidential guest: PISA pages are decrypted for DMA. A bare-metal =
SME host
> + * is not one. An arm64 Realm only reports CC_ATTR_MEM_ENCRYPT.
> + */
>  static bool pisa_coco_guest(void)
>  {
> -	return cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT);
> +	return cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT) ||
> +	       (IS_ENABLED(CONFIG_ARM64) && cc_platform_has(CC_ATTR_MEM_ENCRYPT=
));
>  }

[Severity: Low]
Is the CC_ATTR_MEM_ENCRYPT fallback in pisa_coco_guest() needed?

On arm64, cc_platform_has() handles CC_ATTR_GUEST_MEM_ENCRYPT in the same
case as CC_ATTR_MEM_ENCRYPT:

arch/arm64/mm/init.c:cc_platform_has() {
	switch (attr) {
	case CC_ATTR_MEM_ENCRYPT:
	case CC_ATTR_GUEST_MEM_ENCRYPT:
		return is_realm_world() || is_protected_kvm_guest();
	...
}

Because cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT) already returns true
in an arm64 Realm, the extra arm64 check is unreachable today and would
misclassify an arm64 host as a CoCo guest if host memory encryption is
added later.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120010655.4678=
25-1-lrizzo@google.com?part=3D20


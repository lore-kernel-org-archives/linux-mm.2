Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B962FE9B243
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 09:43:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27C416B0088; Tue, 24 Feb 2026 04:43:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254776B008A; Tue, 24 Feb 2026 04:43:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1570F6B008C; Tue, 24 Feb 2026 04:43:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 019326B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 04:43:45 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AFD8BC1E05
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:43:45 +0000 (UTC)
X-FDA: 84478863210.19.2ED9078
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 79EC14000D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:43:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RAYzSEBu;
	dkim=pass header.d=redhat.com header.s=google header.b=oQaImNWa;
	spf=pass (imf27.hostedemail.com: domain of mripard@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771926223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GW7PmuG1ndcDHaBwm6NFGZKZ71cFJAjRs457FXMTnxM=;
	b=h91W7nRcDJXHtC0lmrYEOJCutQgb+eOkISOoaglNv6aVWua51z8PFwIWL/l5DGtranuzWY
	+wOZSBx0pL//W9XRDzlkMHxvcPHiVutkf/+1TvLFV+zjyjdazKhpZGpm1QDXHE9GYiDAvA
	onK+pfgUbjrzjln6FXyjQqRYzOxG2fU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771926223; a=rsa-sha256;
	cv=none;
	b=5yBsXOaXrV9oXOCofliCKyeI/pRfeFfhDYfrMdQ6QL9ntlTnkdl5RA59Ne5O13ZttcpDOo
	UFFx7OPoabhC2rFslKDT3vNM28vz8quyIbYs6xt/EpPG1d/nT+MKHnJ7Oe9TW3yxOZJ6MH
	jz78WuqkQ1iNCmghvKa/dKMMqrpg+HU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RAYzSEBu;
	dkim=pass header.d=redhat.com header.s=google header.b=oQaImNWa;
	spf=pass (imf27.hostedemail.com: domain of mripard@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771926222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GW7PmuG1ndcDHaBwm6NFGZKZ71cFJAjRs457FXMTnxM=;
	b=RAYzSEBudNaJRBuL3PlbMRjQX9UnKjMaRmF2dJbz5rbB1kPIY+Kh42caLJ1eQSiJ2m/mmM
	TkgV4OT12+xfF9P9jKyEgewscj+87andWrUHxc/C1Lu3kaPtCwmNX+ypwxU8yx3mPMMWcJ
	fLScCZ/LNxXeQTYcnhHqPPEsJuSxNHg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660-EvqBQyrZO3GI7dzC10Grlg-1; Tue, 24 Feb 2026 04:43:39 -0500
X-MC-Unique: EvqBQyrZO3GI7dzC10Grlg-1
X-Mimecast-MFC-AGG-ID: EvqBQyrZO3GI7dzC10Grlg_1771926219
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4837107e0a9so38766275e9.0
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 01:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771926218; x=1772531018; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GW7PmuG1ndcDHaBwm6NFGZKZ71cFJAjRs457FXMTnxM=;
        b=oQaImNWa48BK8GTueKd3Kb8XmTmKuCYtGcPcPuevm+xXkSk3zir8fe0n7hQ7u35Oxb
         LT6HHOkRju45GnFwyQ6FtE78IqHtnrwZjN4sXs06sHwXZm11FBs3HwwA7/qzxb1yzAmW
         j0P8H9cOmP1zX9/+B9oxz4fFFzGpexF9poZxmEHBCiG2vtvTRFMKSLhT9cu6TRTV5GfJ
         3VVvHFtMBBaAPI67ZNyz4DJPwY4ImS/vi4KFzbDepI5W5ANEztH2AUV2v5h47E0Gl30L
         VXAqPW12RCdiUnSafXbgXa1ZBLQeTOTiZFFfjM/ayAKwn+q2FooYY/b5V6ML7bpoYx4q
         NLKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771926218; x=1772531018;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GW7PmuG1ndcDHaBwm6NFGZKZ71cFJAjRs457FXMTnxM=;
        b=vmGBbE7tuND1DeyC8ANwkJdBh89JvLUdhWKIP2JKobL6toMs5/1FqrVPIsoMnpOmuv
         kUqPxQAq6zrpFM96SoJFtjhbPUJw3aQRSyy0T7Yup08Fv5urLjFrg0MNBynicRryyuL3
         wB6HQ2Ifi5J0ciZLFHr/TDNjjfrJ3C4Hc5gJ5rgG1uS2dcrEhGnWQ6qJsTZoeCrIu2L7
         SLEO2OY8pXYuS3dISjeO6hHfh/3q0eNxxDrCUiLFW68ZI0Ut6HM6jwlWXX3fpXdsPXLK
         dXqko+j2Q5ClFfMYRQXrfQeJjl7onHtGlwFLnO8dGaDYlHPuZxgvJbByxZdr1zPx5+jG
         MK8g==
X-Forwarded-Encrypted: i=1; AJvYcCViAZqX3yzssXrjfyCFe426Qjy1Y7+GR6U9KgmxUAjOg/OlRYLElVtWWrgUCCyLgb1PElJtcsMIcA==@kvack.org
X-Gm-Message-State: AOJu0YyTuHn3ZYAEcnZNyBQO/nfMkhhDXi5jwE5OXDDDjv1d4N4pOFMT
	9swIXTIrNOoeAvSEQ8EcrejYJ6oyxc1FKyAKNiKsSwrYE/kDh93NFp8U7MXR1MQ3rG+vOEZHwkD
	PzS2FqwSxp9uTo34GPQAdBbQDjimRv7SlKP6uODfUbDYlOa94UTkn
X-Gm-Gg: AZuq6aJki37mVUdAtllRZVwGfnM2B3RloqV73Jw7vbL8q/5PrTsLe07GBzCblvmLXPf
	u8WRwewo+LisjOYx4FLlYiG3pbxFydDVczq+hv15mgkiUVToOc5AQs3k89DxzdKvqJst0AwefXQ
	Isdsu8bYEwShoNM19sp2sbmOzUS+hPzwzCWCDBlYggwpbLjcm6lDA6zolQiXvn4uGGkEW6Kj/65
	yz2SVTmsHX0797mkvsb+hlhHvRHLC+xhc/JXwajIKbTaKk7yYalcG9tib3Bg+Sg87c1lajlmNMo
	jKJ5PlDF32GJv+gwGzHVE9kuDGfZ4/bdIbpFkLLQYmzAg/QH59YZdtJzhMM0TbMEj1EV6oloPw=
	=
X-Received: by 2002:a05:600d:8444:20b0:483:afbb:a086 with SMTP id 5b1f17b1804b1-483afbba1e8mr88663335e9.29.1771926218460;
        Tue, 24 Feb 2026 01:43:38 -0800 (PST)
X-Received: by 2002:a05:600d:8444:20b0:483:afbb:a086 with SMTP id 5b1f17b1804b1-483afbba1e8mr88662945e9.29.1771926217928;
        Tue, 24 Feb 2026 01:43:37 -0800 (PST)
Received: from localhost ([2a01:e0a:b25:f902::ff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483b88f9584sm14864105e9.12.2026.02.24.01.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 01:43:37 -0800 (PST)
Date: Tue, 24 Feb 2026 10:43:36 +0100
From: Maxime Ripard <mripard@redhat.com>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: "T.J. Mercier" <tjmercier@google.com>, 
	Eric Chanudet <echanude@redhat.com>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, Albert Esteve <aesteve@redhat.com>, 
	linux-mm@kvack.org, Yosry Ahmed <yosryahmed@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: Re: [PATCH v2 0/3] dma-buf: heaps: cma: enable dmem cgroup accounting
Message-ID: <20260224-solemn-spider-of-serendipity-0d8b94@houat>
References: <20260218-dmabuf-heap-cma-dmem-v2-0-b249886fb7b2@redhat.com>
 <CABdmKX0LpKJ9tw48oQh7=3CF0UR5uFtgo0OMwQhHBB40LnijyQ@mail.gmail.com>
 <a446b598-5041-450b-aaa9-3c39a09ff6a0@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="yylhp6jgdgqsuz5g"
Content-Disposition: inline
In-Reply-To: <a446b598-5041-450b-aaa9-3c39a09ff6a0@amd.com>
X-Rspamd-Queue-Id: 79EC14000D
X-Stat-Signature: 1cror1fztr7anta88knjrdu1nkhitpdk
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771926223-529538
X-HE-Meta: U2FsdGVkX1+02WwSkMn4aoV95I5rmav92lQ9dld2BPBBN2U4w62ipVjImJN1A2+fUK4pUQUEQctaK+4FcNLD6dDF3Y7Z+UHEfQeSlyeaa5B8nzLtszpGByudxLKY4+++N4OgjQjts5O4ejXs1WgLD6FHt6d2wlcd/oL3uOEPdD60gzXM5LsJ01nWkIyiTpGYYlAV0h2nI7ni1tBt994IX1UwVz/bFEHkl6EfgofhMNeoUhljOBrCsreHCffU3QYrzeYhgq+7O/ZmG2u+nozN8Y60DbM9H+1MDSJXK6Ob/W7Ve/qdlrra/uyZKU6n3x+0AdKTKUkZOGU/3jObyX16K7MRMoKjsby+nnaJrxRnmnuSB3av6e2ivj9nI0xi6WcA3+3kjje/5mlta/UOzqy7e9MeD46gEmMZHeFggVb/Mn6+e9xxNPAQzcpUZ0draXc4p3YchfcIF4rOYE4OjbpwdqbVgJ404ZecN+4Zp71I5pXX26NHB9pzDxMtbd9pAPS3vidELMKNasfH1WnYOS4wK6dmeEc337ToqdlJFYQcDwXvwmBnk5X9kSYH1KNjAtGQSFs+DNn6xxGrch0ADtPthR8W+teoJR5H2Fx+vgSrr+8hikVlgzWLB3SYU5+WxVFEjJywrB2JbBRUnV1g2C52id8TPSjRF6MDPaIcMTzLCTLcIAfnqYTzVmpmlM8UfLUAzC6+2/40g4sxDE90p2yl3JUALfiVw5g0IMbmgXNXbIzl/PSbxWDkt9lK7nAks7a35HoNCPc6AWpqZlAuxcVdD/18BXg0CrAHYQfYhNDvpqiSh8nDAc6gM93+jYWW7pQn13hkcpamHOL21LJOe1OmcTcFkAckVKWaLWGiX9mAhIhIgLUvSOjODfFfyOfsenflW1CP/W0m8Pz1wlvRR/5KlIBpGaRpyrfTFJnaqT99zoHkSUZ7KOZWDODOND8lIS5RUgHxM4OgGr0C2p3Ojts
 uUdqiWpN
 J8Xm7Fqec/BQvzpaAMflDtJ403BvmraCzGDcczssGOYeHb1d09EDaBIZTSYOAvVULxeUTR1DO1WqG7mOgjHU5uscKZ5b3EFpnIpWGUdVBGaOTJF9Ktsa1F8msb3tet8zRpPdsOKQupnCL+IbNMstLkvONIoJc1TkF63AHdPr3r2EtyGGlXy8LAIybPSUXCuaLM+9HGV/isAq/0cjrpjb5IV45yO95jvHDL9OwWPvn/PoIO3Ed+Hjvc8Ncnv5iymntwSotlLsUPFJq/dvglIIGoWv1BNLqb9VZSVtPcRo/fL/RIM+GDUzmZab8+fuPtzB8by1kboWYlvNIb9qgw6+wU/fq/i2lPgHhOELJO11Z0XQCYh78rRwnrJV2wJF0A0cIjfeqV1FhRjyUsWECvS9KaEvGTgun1B9FXPdBau6BcU8MoM0pSqwC489eFJ44MU0UBLYZWJ6JFuUped4NN++Tf4lTqH5EFt+bMhEJvHzFWj9cPSO4Z4aqEJk06uya3K6F7B6SBQBPCZ0LHQ4w/c0RK4QZC/AvqJMjaAGq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--yylhp6jgdgqsuz5g
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 0/3] dma-buf: heaps: cma: enable dmem cgroup accounting
MIME-Version: 1.0

Hi Christian,

On Fri, Feb 20, 2026 at 10:45:08AM +0100, Christian K=C3=B6nig wrote:
> On 2/20/26 02:14, T.J. Mercier wrote:
> > On Wed, Feb 18, 2026 at 9:15=E2=80=AFAM Eric Chanudet <echanude@redhat.=
com> wrote:
> >=20
> > Hi Eric,
> >=20
> >> An earlier series[1] from Maxime introduced dmem to the cma allocator =
in
> >> an attempt to use it generally for dma-buf. Restart from there and app=
ly
> >> the charge in the narrower context of the CMA dma-buf heap instead.
> >>
> >> In line with introducing cgroup to the system heap[2], this behavior is
> >> enabled based on dma_heap.mem_accounting, disabled by default.
> >>
> >> dmem is chosen for CMA heaps as it allows limits to be set for each
> >> region backing each heap. The charge is only put in the dma-buf heap f=
or
> >> now as it guaranties it can be accounted against a userspace process
> >> that requested the allocation.
> >=20
> > But CMA memory is system memory, and regular (non-CMA) movable
> > allocations can occur out of these CMA areas. So this splits system
> > memory accounting between memcg (from [2]) and dmem. If I want to put
> > a limit on system memory use I have to adjust multiple limits (memcg +
> > dmems) and know how to divide the total between them all.
> >=20
> > How do you envision using this combination of different controllers?
>=20
> Yeah we have this problem pretty much everywhere.
>=20
> There are both use cases where you want to account device allocations
> to memcg and when you don't want that.
>=20
> From what I know at the moment it would be best if the administrator
> could say for each dmem if it should account additionally to memcg or
> not.
>=20
> Using module parameters to enable/disable it globally is just a
> workaround as far as I can see.

That's a pretty good idea! It would indeed be a solution that could
satisfy everyone (I assume?).

Maxime

--yylhp6jgdgqsuz5g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCaZ1yyAAKCRAnX84Zoj2+
doacAX9OV+qF5kysBD7VpKcr5kj6qlD3tVyHVcMdeBEkYAtzN36MFGozyNSliCjA
/lA6uL0BfiAOlFg02H8ElnCXHrx1z+Noa4YFNUJ9SeZZcTsz4JPvSJFejlvUlYrT
iKqij7gXqQ==
=qfni
-----END PGP SIGNATURE-----

--yylhp6jgdgqsuz5g--



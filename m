Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBC15CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 03:51:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F1526B0249; Sun, 31 May 2026 23:51:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C98E6B024B; Sun, 31 May 2026 23:51:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 006256B024C; Sun, 31 May 2026 23:51:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E307A6B0249
	for <linux-mm@kvack.org>; Sun, 31 May 2026 23:51:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 932601C1AC5
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:51:52 +0000 (UTC)
X-FDA: 84829970064.14.ADD0718
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id F2F0540004
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:51:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U6dkxNLw;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780285911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sLmB4YlFf93jmDEEnyM+0JFZP8CSdyLVyUdrZ5eW/1M=;
	b=3yyTpFz3DzEZQzExZRjPYucl3JZeN4ERoPdX8eMdoDEEwd6tqD+BwmU65qdF0M+mwK8QXH
	uRMFSbyhANI0Lhjv7GUi1zk2z1wsWvrb+hZ7AkBI0wQsJPV2vvAkJ7niQRN0IQAt6Z44MX
	tmob8iayHOTFebd/WadVec7rGK+8F1M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U6dkxNLw;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780285911; a=rsa-sha256;
	cv=none;
	b=g63Cp0Gtz1RNg+yexZB8A1GUWP7d9Uwf7eCTeaw2+W+G75Z9etloRw4LGgC3+iiFHLWAjC
	MzETP3hEX08ygLv/nF/XnlRy6pEp/FeOB3IrPzdi9YTbi+YCg3NlvXRX02PQ99aKJJ3R5V
	Kzxk/xhI3Ydm1o2zEPri1kSxx4y4OBg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C9C160018;
	Mon,  1 Jun 2026 03:51:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6712B1F00893;
	Mon,  1 Jun 2026 03:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780285910;
	bh=sLmB4YlFf93jmDEEnyM+0JFZP8CSdyLVyUdrZ5eW/1M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=U6dkxNLwNu0+fchGsJZOSzyeZe6uHp985VHCDSp/199wRKqvBK/t1dXV8SSpO6LEH
	 WUWVtFposvQtXckX5XsUW1TYzTHSXGROYIT9CvlaEfiKWENY6nbZYz0ix0eyYSATzC
	 pAPFVpsCrTAI55c78o68MMxu1XNZ5oRrM4wNO4GNZlXY5GJ16HQUgYSr256UY86Mji
	 tOpABJfDzXaWcgv6dfjcJsPDCmVBJzm7yK0nahuVCFn9kYOy0qNR9pjQylKBbY2aoI
	 z//xKRKZKoOYtpmtPDsVHDTA5LpxwJ1Zoh+bBFSXUsYpOZfHc6qTYS4vsYf+V0xY5Z
	 2qbutT5UHdi8w==
Message-ID: <fca0e08d-a00c-442c-a0d6-447bbd5a585c@kernel.org>
Date: Mon, 1 Jun 2026 12:51:43 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] mm/slub: detach and reattach partial slabs in
 batch
To: Hao Li <hao.li@linux.dev>, vbabka@kernel.org, akpm@linux-foundation.org
Cc: cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260529035120.81304-1-hao.li@linux.dev>
 <20260529035120.81304-3-hao.li@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260529035120.81304-3-hao.li@linux.dev>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------m0RuxEGm2eLyNYdpYZza8Crz"
X-Stat-Signature: jfrk6ugqas6pwf3r3jssbn1pysucqwfo
X-Rspamd-Queue-Id: F2F0540004
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780285910-781651
X-HE-Meta: U2FsdGVkX1+iecz0FpQUIdZLU4qcWk1K4ENZfW0oQZQZYEtKsxEfRALurDGNQpMKxopteMLW4dIJbLLcEjahzk/1ql2pMwWOBHnk2dt5onO9wxMa/T6kDuT7w3tceP9pHkfFIhZxSNLDIKzutrL7vUa/GdAx7IjHheRDWr45c02di/+Z5fD5mXqkqy1sLCeoNTm4xs+qWP4SVSps6gC/ksuhvhTVLeksAsr2bWk02XfifaFGDF1kGVrqXTnvgihWS5Yr4w8xXJNyj6eb/z4yBuuJz/mtqdJG0rXilHtc3W4xsTZYAmLHNRsiNOy2Lbub7g/60Bp7UnUs8HJvxEaB3vnnHtJy2PRfQ6ByRaNT7vFSHsMAvfIrup0ccEpTNu5BRLSUNyvavfwcZLoZJtjelIPE3GfOdyONt5NUNLwGYsO7KNzR88EcL8DQcPli1S/uJ4nN4wbRwEmV2XiXUpTXmdY7jStKCuOOfi3QkQU8v3+oRMKuutVpJclMu+JFUXYRfiFDP+Oy65XsMNTlHKuT0PPFQiJJhpHtTwSabxvTq4z8FZa7h0RCR39T9WQ6fyZ7V8CqCrX/wkMyK8wY3tVjSbot/+mD0fIWG0E2zGChwi5//k33YjGu/lcQomq5mn9fA59n3k/8ZSQ/bPbxhLqEOCfBxOH2jqLsYXTCyulwsRkE/FmnoF9thSZE1ZG1Gcy5vn2FrxNCq5I3L6G716ndFdicbaFeGc5jQLdyRvL4MWBJ7Llz/XV0tv2qPXeG1N+XTmh3o8KZCznj74dfZiB1tHxZ4oGTwX9iJrvv/H5szpXRIYPuxg3kkGIOVKfG4Nx9NtqHPONaRUx4VHyhl8WqfsktcUr7YXKofqtfMBJoHHfrU0wq37/9OT+X31AWmZJV6izBpmJXtwsIhjN0Dd5QYQpRs/+7l1/d5+L829hY+b7eepSOO+sS+GsExYPIKkNeTvxF+0bkiprhF5zksLr
 HCeRpZsd
 DygLgSb6dGGleraMLw5m7mEkhjBFSDsP+GrKmcvt/r/EHd3t/iuYI+2qWQSOFcDLpXt+u1WflCCxIjSthCwfaNCy6aEb8J0AG5l+Pqzz8Db3dDvZTGfbLlZaJ2sXU5Y+m7m11QsYNVj3wAb6fMZHCz3QD4CjOkFEh0g/6bzo3/f6RIwSnysT+7zwsr5ljG1+hZgwIZfCI3NcA6PihD06U/sJI4VznXm42/1uzyKjcMwYyBLDs15bzfsYtrMqsMcEYw3FQ248DZzvNd1m+16huhV9q8r8tcwDAcExHiYmY8pSY9LrdTUWoejanNEfC0FWJcMnBQIoq2PohN8QzUvteLxNSsMVEa02mHC9ptPVGOQKrUm2ZqvF3d9fj+0XpeFmK9Ued/2mAMuQzNphFpu9BIgJ0hYLfMgZctFACgmzqN/tSwiWCZNtRp9CrF+jA7AUCEeZAvlfdH1wiYrDch4clhVEmYrKashrBf8j/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------m0RuxEGm2eLyNYdpYZza8Crz
Content-Type: multipart/mixed; boundary="------------qMU0BPtEeznEhoMt3ZIa9oKo";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>, vbabka@kernel.org, akpm@linux-foundation.org
Cc: cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <fca0e08d-a00c-442c-a0d6-447bbd5a585c@kernel.org>
Subject: Re: [PATCH v3 2/2] mm/slub: detach and reattach partial slabs in
 batch
References: <20260529035120.81304-1-hao.li@linux.dev>
 <20260529035120.81304-3-hao.li@linux.dev>
In-Reply-To: <20260529035120.81304-3-hao.li@linux.dev>

--------------qMU0BPtEeznEhoMt3ZIa9oKo
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 5/29/26 12:50 PM, Hao Li wrote:
> get_partial_node_bulk() moves each selected slab from the node's
> partial list to the local pc->slabs list using a remove_partial() and
> list_add() pair. In practice, the loop often detaches several adjacent
> slabs. Doing this individually repeatedly manipulates list pointers
> while holding n->list_lock, which causes unnecessary churn.
>=20
> To demonstrate this, the counts below show how often single vs. multipl=
e
> consecutive slabs are retrieved during a will-it-scale mmap stress test=
:
>=20
> consecutive_slabs_count        frequency
> =3D 1                            277345324
> =3D 2                            335238023
> =3D 3                            175717884
>> =3D 4                           88862337
>=20
> The data confirms that retrieving multiple contiguous slabs is highly
> frequent.
>=20
> To optimize this, track contiguous runs of matching slabs and move each=

> run in a single operation using list_bulk_move_tail(). This reduces lis=
t
> pointer churn inside the lock critical section.
>=20
> Apply the same optimization to __refill_objects_node() when reattaching=

> leftover partial slabs back to the node's partial list.
>=20
> The will-it-scale mmap benchmark shows a 2% ~ 5% performance improvemen=
t
> after applying this patch.
>=20
> Signed-off-by: Hao Li <hao.li@linux.dev>
> ---

Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------qMU0BPtEeznEhoMt3ZIa9oKo--

--------------m0RuxEGm2eLyNYdpYZza8Crz
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCah0BzwAKCRCGXBN6rc5S
1qX1AQDwvcX4DdLopuDVFfCQt2rqBy/krXFrTCgCRBFMF3z9ZAEA3npXuTwPm7Rk
zvyVNP4WB19wUGPjjRduxsgT9hmZMQA=
=wKA2
-----END PGP SIGNATURE-----

--------------m0RuxEGm2eLyNYdpYZza8Crz--


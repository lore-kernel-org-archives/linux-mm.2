Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82C75CD6E74
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 05:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 715A26B0005; Fri,  5 Jun 2026 01:59:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C6576B0088; Fri,  5 Jun 2026 01:59:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 608856B008A; Fri,  5 Jun 2026 01:59:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 513F06B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 01:59:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EDCB414089C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:59:36 +0000 (UTC)
X-FDA: 84844807152.02.A9ED0B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4636620004
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:59:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=afXQTfY7;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780639175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VZG9no7GTW408RV/60BpZX7jKUvr/kEIeLtGBvYuZZ0=;
	b=cLegcQp1zHvVNz6ybQwJK91vFAdpCsFXPmEqdkrXDwcNnL4wKemkv2jWQNn6QyImVff5DN
	2U9rptIGXIz/+dBiki4BBkp68OgqM2NNJxv4ATEba1o4bhahUSXmbbMy+QK43DphdCQ/h1
	FXnrX1Bdp5WmA+lRt2UZ2MD/zgRcH9Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=afXQTfY7;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780639175;
	b=ggmTdn8hf5ZCUfjGPj0xsgk3baDEo55j/Yps68m4LUzqhWKnjNWeztCOKoq8t9GqjA0WT2
	2msYn+W2OYc92emaDnLFioJDNUDTy98FFCJtQEqu2r3hQ3uTboKt2PgrPmAvFEdP6N3/Ib
	qq1CwmoXG8gdz7qzMh8Qe126a+2l6mM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 40561423C3;
	Fri,  5 Jun 2026 05:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42AE1F00893;
	Fri,  5 Jun 2026 05:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780639174;
	bh=VZG9no7GTW408RV/60BpZX7jKUvr/kEIeLtGBvYuZZ0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=afXQTfY7mlWhg66Vp8DQgnBNBuw1R80YdSq++am4RaFjH5i2h1K/w9tWb1CCQMA9n
	 B2+xwhktTQ3oczmJe/BO3NKZ9nOROjxpaaGuvQCMt2EUiUrYilQNF0N9GsBtIZYEFM
	 0NhWFxTTiNAc1f/z2ck6N1neKifOxCk39hprXyWSTrcUJA/iZjlraVBanBY2DjRT8O
	 AyxeP+SnxAHgkRjI9YLUDopGnScNZiTxVg5ZjYHAyBFcXPDd7MfvbSYcDJphLcpDUs
	 e935zO9VR4bVKaRzo+zWWHwk+RcvqJD9+pARw3BIcYc1l/Cuu39wEsD0ufUS9k48Yu
	 keK25jwAMDxPQ==
Message-ID: <c452e1a6-f577-4b72-b034-827f83387448@kernel.org>
Date: Fri, 5 Jun 2026 14:59:22 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/slub: preserve original size in
 _kmalloc_nolock_noprof retry path
To: hu.shengming@zte.com.cn, vbabka@kernel.org, akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, cai.qu@zte.com.cn
References: <202606042027323804pk3MRY42Jy7y42OHAhQZ@zte.com.cn>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <202606042027323804pk3MRY42Jy7y42OHAhQZ@zte.com.cn>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------mvMhvM0STHKjAKiB8hmyrDMn"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4636620004
X-Stat-Signature: gjnos5qsdzehhnrrqpk5thssg3xt5835
X-Rspam-User: 
X-HE-Tag: 1780639175-542832
X-HE-Meta: U2FsdGVkX1+u+mZgq13bFXYhUXVTxHrxDSAnyuGbhNmEFQLnbPDSaipSAw+4iwZvY+KqkvdG21b1HEmw/oYSZn2VFR0qIGYIInF5Pmm3qwIOpl3ikn1n7ZqRGE92jv+jXRhj2VPtGKe/lTVb9WYPcDcmwtX+mLvA0KMYHjx3h9W/nuyPHK5XZlztaA6Upm+7RGOeBBAfRE2H8IjxnRJ5urDk+DgqrcrIokNpi1VANAbnZo0tj4ga6DeviQDIE+Zbkm6mfXlnDwHeGOswYzxgaWnIJPdoWcgkxSENd3ZDEwzY7OUfBJTT/gQkU005enX992JPxnlf5tBW9vGoaxn8qgNUGchh64T6WmGRgLfOvlS6RD1wxcl0vsb11+OPtSjOeMQHPxlyDNawYgMugaKT3froQholEfgJelxpX4XUg+yDSFFdR+cTOhdIq3TOZhY2WBTHgeHfI+gzNMtflrVscSyUHQXTzTK7FHqovym//8/MJKx9FrO1z3PtIywGTSJooNSHK7wEYBDtXvCV8/mcNGDIvvgrT2hAn79xDRinmVF6AtZP3HyfTiipw7XYySosdbhx6Nw0cgoIwpTPHM3z2TwofPAJiE3KIK25yl537a//CJhZ33oSqFCHkCw2xG7jWUstHh9v19cMBD76uKfz12qk7nlvdh4aI3d3rRZzRJI60SoRyFOh7F7U7vs9gWLSNl2F/vcBudXrV3lq6Y05IsAhahucwcTz1eCPVindyp6uRJsEZ9PVP5ItpVxWjjsdrnc5bvXyI3dOVBZSYVr7xKhn7a34qa0dV4PZ88OyVmkAAfXXKOegb3BL29yusmZ1KeNJeFaus+WNJXY1H/J7LDryv3ZdZMU8CKI5KFgqgFbPcTxtHo2/9OqaL0coW7ZFZxMDa2wxVOcDVcozVpCQaXtBQqTO8Na56wMDMsv+nqa6+MmGopKWYEjlCQjcwD0cm6TVKsAaWCBgtypvMFu
 g+MZTOG1
 GLXsTb1JdMBxD7wSv1Kica/IlG4CGebH0Xzls9x7Y9pqsPytTQb6CTu7HTBudFu+lwIUP074ITzuAlXJxWCFDGgmC8pqIrmI8gQwmMDKb/0o7wwEUdd9GDwV1TlTo4idQRRqYjRUZLKkwpCWdtzAT0F4ChbuoyaR4MIZbMuAMARfvmcu1edvlXa0cjMccH+TKpBig68lTQ9POIUpFTp7iLxZ+1JA3nZQ9hDzwJWSwxkAzfudxdTdkuv9LZZa62nSt2+LFJYlGcygM4l/gxzZTTH1npW2lUFeTpgJXROEfDyE5EdxiqD1nMlldZz54MacBfNgxnbAUkiYyJLTel5J6+JErKWkdiwVMbBqoCU4kEc6J3tc3t3Ov19bFifNsXhrBARvaDZJNj5vTfGXbWPnE951g6bbI1Nk2TT4PsWaA7e3fmWMkrislG/ZIpXH4ajbhyUys0R6GNBgd15JFTOfztEWF7y40fd9nJBmhmpLOSNH9wg9PpBE+Qnn6L3qaykxbdtRWubTbOAlCmObAS5hR0n1rmDdfP3thj/D2fDM2qHeaAzuf43WSYbazZqBSmDt8nG+dYgcxqb/nUDg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------mvMhvM0STHKjAKiB8hmyrDMn
Content-Type: multipart/mixed; boundary="------------UaqwdqBkjfBUljnSAbpOsztD";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: hu.shengming@zte.com.cn, vbabka@kernel.org, akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, cai.qu@zte.com.cn
Message-ID: <c452e1a6-f577-4b72-b034-827f83387448@kernel.org>
Subject: Re: [PATCH v2] mm/slub: preserve original size in
 _kmalloc_nolock_noprof retry path
References: <202606042027323804pk3MRY42Jy7y42OHAhQZ@zte.com.cn>
In-Reply-To: <202606042027323804pk3MRY42Jy7y42OHAhQZ@zte.com.cn>

--------------UaqwdqBkjfBUljnSAbpOsztD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 6/4/26 9:27 PM, hu.shengming@zte.com.cn wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
>=20
> _kmalloc_nolock_noprof() retries from the next kmalloc bucket when the
> initial allocation fails. The retry currently reuses `size` as the
> bucket selector and overwrites it with s->object_size + 1.
>=20
> That value is later passed as the original allocation size to
> __slab_alloc_node(), slab_post_alloc_hook() and kasan_kmalloc(). On a
> successful retry this makes KASAN/slub-debug observe the retry bucket
> selector rather than the caller requested size, potentially widening th=
e
> valid kmalloc range and hiding overflows.
>=20
> Keep the caller requested size separately as orig_size and pass it to
> the allocation/debug/KASAN paths. Continue using `size` as the retry ca=
che
> selector.
>=20
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock=
()")
> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> ---
> Changes in v2:
> - Use an explicit orig_size variable instead of bucket_size, as suggest=
ed
>   by Harry and Vlastimil.
> - Link to v1: https://lore.kernel.org/all/20260603211011530GqLSXP_rgcuQ=
dR47IGQLL@zte.com.cn/
>=20
> ---

Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------UaqwdqBkjfBUljnSAbpOsztD--

--------------mvMhvM0STHKjAKiB8hmyrDMn
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaiJluwAKCRCGXBN6rc5S
1mDiAQDMsuhI+fb3bj0yV2uXPZmU7SL6rZGXaVTpa+0qqfyOXAEA4c7/8ULItr0w
L8g4FZ2T8JQFVYrjv1BlKTwU2h5EdAY=
=ADM0
-----END PGP SIGNATURE-----

--------------mvMhvM0STHKjAKiB8hmyrDMn--


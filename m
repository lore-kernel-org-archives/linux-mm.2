Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2154C531D0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 03:55:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 637106B0088; Wed, 29 Jul 2026 23:55:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E86E6B008A; Wed, 29 Jul 2026 23:55:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FDE76B008C; Wed, 29 Jul 2026 23:55:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25E3F6B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 23:55:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8A4DA1608D7
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:55:54 +0000 (UTC)
X-FDA: 85044079428.28.2400951
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id F0A6040006
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:55:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bwYmmaMu;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785383753;
	b=Wt+A+bEj+gooGUi1qqKWQF6VMKp9TcQqbxN+GJVz/dJVagX13ftKVFWwqS5m6wHxWqCMMv
	rsYRf6k1tHxSWR7ZqBp+kjfeU2ZU6aKG7Yans0QEQiiAhtiLwlD5OUDTE6JNDTN3oWJuWK
	viikYEmXZtoAgj7gjN7EhbO9lU++aqY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bwYmmaMu;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785383753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jL29vjJ77VLrRPv/DZmmHHNOBf84TNgv+nTdSJjkQvo=;
	b=HvCwSpJiIh06gJNx3HVwZqRga4T8sxCxXD5xY4IMkgrTfFVdDe3GeBYj7vcfuSkK8EZ3d3
	gISWuW80IjS76DO/ouYrasaPYTGjgLo39bE6WH+iCMKH+TKZFTSazF9boFZOLam5AGVqiC
	0AzxjHcug21ZIMvv/+ZvOciuSr9q6QA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9489D600AB;
	Thu, 30 Jul 2026 03:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD9B1F000E9;
	Thu, 30 Jul 2026 03:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785383751;
	bh=jL29vjJ77VLrRPv/DZmmHHNOBf84TNgv+nTdSJjkQvo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bwYmmaMutasiKGCW3lMAx/RWsUKidEdyk7bHcb+ezqybzVcbC1EZaV2wEqfA5w8E5
	 K5OEmEZ/FALpeYixasyUzvcH87KSuiNV/gvrvOkfqpKVazo6pxmu2GaFPLVBVBNG4w
	 gJpkY54hNabxZoY7LJaT96ImlO6le+E8q+gQcmhJLf07x8JQVA4J29Pg8/sDxCHF1Y
	 gft58FE7Sagc1oyYNrkhLHI1lsuwzkmkL5u7Ijii22xkZSswUqqgyzGo3td2mF70aX
	 2FJ6NU4b+Om+kA/oIJx/gEXyGiepkRKJ64qYzABV6LEWbeQBAr+t9LiKDRz1f3lmvU
	 eEb7x2s07bgGw==
Message-ID: <dd0b5122-896a-4513-9a93-e3fe04bc3f73@kernel.org>
Date: Thu, 30 Jul 2026 12:55:41 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/slub: fix missing debugfs entries for caches
 created before sysfs init
To: Li Xiasong <lixiasong1@huawei.com>, Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, yuehaibing@huawei.com,
 zhangchangzhong@huawei.com, weiyongjun1@huawei.com
References: <20260729101849.3734287-1-lixiasong1@huawei.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260729101849.3734287-1-lixiasong1@huawei.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------U4bzCzUcpYSrc5aXCF3vg0O0"
X-Stat-Signature: 8u3j4u5g7xs5j7qnjtwai887xxrdtqhp
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F0A6040006
X-Rspam-User: 
X-HE-Tag: 1785383752-113958
X-HE-Meta: U2FsdGVkX18wlQDP+EPwUm/fG4ZnFELWSurmVcc6xf1SWtzOGqU0wVRtr/cB4IwO3mVFk6/LQh7fQEY4zURPsa1XGIJXghztUXOZzGLzDWQrKu4y37wBMQAXtd5uaK5XmP5GnB8QjkmP+bO0xq9OSZmJVm6f405yT9h4SUzzYAqh+0zOtuJq7dH1/lroCzl8BOk69yPDMoUwE/thDutIXfbq67698CNT0Gcckr5Qb+DdlV28NkrRKld0pyIjNBQf/VSKYJDhm6uPjRwcHg5q4TmOjmDOnLQ7GNedrAtp54574ar0yPIaoiw0G6JvN4L2Zh63nf215J88J98CnGYoiUKOjPijESh/zH1qEdAhf++IE9eoxjt+kkWZtv9MKKj08rVJcdWz2QamSXuQCHMNegXlf/f76q3T1hvOH+p24s7FPbDBGl2HsbMymz6h+J3/Mp0x/Xox1pQI5+oKWSs4UM8X+z446U1wZoqqpSj53J652hCeHyayVL20fkdb3B+q3a4s0gcw+hKtrV1GVU5RBE4fORR02WDv9lsLFP5PGOGXKNMiAJU0Sn4tTNCygKAFodgNZD/ITnxFucjxGklcIPMoIpXMUA48V/HAgf7aXPwGAo7JwuNxfHZ2uA6AAh/kBtXKRjLNqnK15QUDp4OG+hNaRYqfeRI+CdFmJWGzZkY+0zv9I+NBrLDFFXvpJChSa7QLLp+xeQbOd8ZcIjtioKNKJ0GwhAawJ4mrYQnAWB+jkYoIxxQNOlhrW84ijWEPU+4UDBgLZSNwcOeFWHUIarzOci7STnltUByVTF4GE92yOTGAtLfp/+bU2nRpAstf8txWXcV2ua0KG2X8ycc/qjUMlN2aIJ+isKDzmE3LxCVCI/30tuH0VhE3Jhuq3W8Cg2tlr3NeHVdAuSzgg886ayLpo/2E3SUY9ex8JuX89ksKY32AS2rpN/FSu7z1mYjXDUHTTfgGgAVCIgWsH0F
 Uz/c1r87
 4HyA7dKTC4y93hJSmyR9HDFVIpxfvlxmEqByImGIYQbxUbGjQaPN4pyRywVzE8m4E5FvnEe8Z55hVcrFBpP7xumY/yAjL+YiBECq/AUZBSvkfM3ASEbRSdEoJoNzguNdOGwPe/+MlvkZZHM6/l3z7Y8QbOStCwi2gWrAALNSQ3OFy67n+BKWu3ijsIrONFzBeOobZUrFcbssWyOrV5N9OlAV9Rxazv+jutjmDlUoYVBgZAiIYICVVbN/TnF8vyS+DDfhz4gaET/0y6y/fld+zU/NSvgbRomeIjgu70HpDFdu9npNgcACohxUK8gVw48MXcw9+0eyiPDACiDVTPQP1WHbea2rNv83qWWrvxfSunMWvCjsqmGfO1ba7URWt838/fFfXeMo6qvwDkxrplNfHaIpj49uFe7/IWQQFgOFgFSRS+8Piqmmx1cczCk1t7XMF47D9aXhBuUciB14PpdIOpgKnWOeOD1ARceqcI7rM2EFekvJ1ZO37Vujoog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------U4bzCzUcpYSrc5aXCF3vg0O0
Content-Type: multipart/mixed; boundary="------------9udFvOgVqgbui5kv0H8J1YIY";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Li Xiasong <lixiasong1@huawei.com>, Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, yuehaibing@huawei.com,
 zhangchangzhong@huawei.com, weiyongjun1@huawei.com
Message-ID: <dd0b5122-896a-4513-9a93-e3fe04bc3f73@kernel.org>
Subject: Re: [PATCH v3] mm/slub: fix missing debugfs entries for caches
 created before sysfs init
References: <20260729101849.3734287-1-lixiasong1@huawei.com>
In-Reply-To: <20260729101849.3734287-1-lixiasong1@huawei.com>

--------------9udFvOgVqgbui5kv0H8J1YIY
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/29/26 7:18 PM, Li Xiasong wrote:
> slab_debugfs_init() creates the slab debugfs root at device initcall
> time, while slab_sysfs_init() moves slab_state to FULL at late initcall=

> time. SLAB_STORE_USER caches created in this window miss their debugfs
> entries because do_kmem_cache_create() skips debugfs_slab_add() when
> slab_state <=3D UP. This was observed with MPTCP's request_sock_subflow=
_v6
> cache, whose slab debugfs directory was missing.

Ouch, good catch!

> The affected window is:
>=20
>   slab_debugfs_init()
>     slab_debugfs_root =3D debugfs_create_dir(...)
>     list_for_each_entry(s, &slab_caches, list)
>       debugfs_slab_add(s)
>=20
>   kmem_cache_create(..., SLAB_STORE_USER, ...)
>     do_kmem_cache_create()
>       if (slab_state <=3D UP)
>         return without debugfs entries
>=20
>   slab_sysfs_init()
>     slab_state =3D FULL
>=20
> Initialize the debugfs root and add debugfs entries while holding
> slab_mutex, walking slab_caches exactly once and handling both sysfs
> and debugfs entries in the same pass. This gives the sysfs and debugfs
> initialization an explicit order and prevents caches from being
> created between the debugfs scan and slab_state reaching FULL.
>=20
> Gate the new slab_late_init() on either sysfs or debugfs being enabled,=

> with the slab_kset creation and alias_list processing factored into
> helpers that have empty no-sysfs variants, as suggested by Vlastimil
> Babka. On slab_kset_init() failure, slab_state stays below FULL so
> kmem_cache_create() keeps taking the early-boot path, matching prior
> behavior.
>=20
> Guard debugfs_slab_release() against an uninitialized debugfs root,
> since the root is now created later and a cache may be released before
> it exists.
>=20
> Fixes: 1a5ad30b89b4 ("mm: slub: make slab_sysfs_init() a late_initcall"=
)
> Cc: stable@vger.kernel.org
> Suggested-by: Vlastimil Babka <vbabka@kernel.org>
> Signed-off-by: Li Xiasong <lixiasong1@huawei.com>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------9udFvOgVqgbui5kv0H8J1YIY--

--------------U4bzCzUcpYSrc5aXCF3vg0O0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCamrLPQAKCRCGXBN6rc5S
1v+LAQCGTC8YVdB3hRg3AfCDHJVmxbhhis44MtfJ8l9+dz/lGgEAp/UqMuKJOrY9
bw+qmoUwrTnDKzuWN9moPkZ9nVc1aA0=
=DIZv
-----END PGP SIGNATURE-----

--------------U4bzCzUcpYSrc5aXCF3vg0O0--


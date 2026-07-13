Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA466C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 06:08:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD7306B0005; Mon, 13 Jul 2026 02:08:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C87DF6B0088; Mon, 13 Jul 2026 02:08:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9FD86B008A; Mon, 13 Jul 2026 02:08:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 93CB86B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:08:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F4140A0A2D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:08:03 +0000 (UTC)
X-FDA: 84982722846.22.5A2D082
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4A36120007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:08:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WLF9tnBC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783922882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H1des+LVbw6lhuT1ysuivk1WMn5ZEGWn284WG3CxnpU=;
	b=tqaPCDpmbyhERtHzFVRqwlnniKHVh41rdhHCc6XexZ7Sfu1oRemQ3vswB6Amg/TS/4LFax
	wbEC6ldvOSZBMjpEd2tADt3U/sslQjM0JhTmk8W8Wus2dOhyycuBN6TGaxc5F6O+MzeE1g
	Pb4xVy9u14mltHaj8VBb/oS5ejKlTDY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WLF9tnBC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783922882;
	b=ud59v9kwCIOzBc1gj+KW5b5fsq2TnQOIKw+1MKoMIYPip/WNRnx9W9sSRMaDg7pyGBCFf4
	CdLFgP1luu/tboUexZbddGMrDztQHuJNWjAUfv2zC7DtYWPoTmkrdkHY+iEa+uelUUhDc+
	xKxxm33qsgIMawW8CHR8UETXhY2Pia0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 281F841735;
	Mon, 13 Jul 2026 06:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1837B1F000E9;
	Mon, 13 Jul 2026 06:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783922881;
	bh=H1des+LVbw6lhuT1ysuivk1WMn5ZEGWn284WG3CxnpU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WLF9tnBCCCfwUF7aH1Q2bSfpGAqsSh+zRoPizUboAXBmnb7QUnXgEit58Vgbbu+HT
	 30y4lkAE1wz6YsOqSmc89o3OcKScHH5/z+VTFxlwLxzgNUxs0kNaOJcQRYaY4jqmnA
	 e732PpDnvKf6zV93ZT4nocT9srZQXcNpvS0vUX9FDxDp+X0RT9GFxJbI1UeN4Wpe8/
	 8wGllpXvHSpt8/W+bC7KJLrjm94LZTp1zriPusCxWI8E+bFa3bHQJgw5b5FqugldfQ
	 BM6CD43o9tce1SdpIDS2bvi10Yagufv65Y2YJvrVCn9sYtGw/GQg8cj3tSYQp6m82l
	 AVmwDUFni1RJw==
Message-ID: <bbadc488-e5b1-4868-9da8-26e2cecd93b2@kernel.org>
Date: Mon, 13 Jul 2026 15:07:54 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: fix kobject leak in sysfs_slab_add error path
To: Hongling Zeng <zenghongling@kylinos.cn>, vbabka@kernel.org,
 akpm@linux-foundation.org, hao.li@linux.dev, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, vdavydov.dev@gmail.com,
 davej@fedoraproject.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhongling0719@126.com
References: <20260713055829.127864-1-zenghongling@kylinos.cn>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260713055829.127864-1-zenghongling@kylinos.cn>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------QkD6sNHryRPp7GhYmc0ogbyC"
X-Rspamd-Queue-Id: 4A36120007
X-Stat-Signature: z34pbsamsbt8mw4fjk9xigbrxrxz5ndm
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783922882-659342
X-HE-Meta: U2FsdGVkX18BwCAvkopy8ABL58Jgc6PnDWOz/DS5P5vc602vNGj2wcSQLu2tHj3TX3pqPrYipaqnh6G7SydehJLIxFBcy82qf60Wm4vmfenGaGLV4GUoY9Os/X6C42knuSeRuKqETMPdyTuehQAo0P7zdXxVD26QuGNZvMYoDWxeC4A34okOGZBwQZn4USaH6ReUb9KTZ75IPnAhO5QPZkar1Q7gn0hfL34HpPD5ZoixjAfgukFdKLCZglbVc5HLC/aqr6VYeSSOe8BOvqANqROsQl+8a1+lXkgFmdv+ctCErOy+OLOVSw6kfXkkJQoCY2PSnI0guR+b6WFP6V2ch7eFZqyjbyxI32o8qTEcq2eOGpNsFr7uwsofExC2qWerYmJZ8wkcjPb9iFezFYptiRs5YCmlA251G+cFm2c9l/1ZrS8OV5hzrxjWluJ+JlXV58EaBZcPo4JDJKVsa35tNwW++4lENO9RDUPA51V6OKzkMePMF6J3kGgUdNf8z2f1cYonH2kprXu/kNKt/suZOegABdCc9oc0pgUbDS0wDrCoqcD50a5P2RiBsaFsG38TyL8U7A4//xI//RlkTC/QVXHv6YVmAzQowF9UqI9Mk6P3KzN9463p4+bL/8rGxX6JQYzYIw86Oi/ne4h0HRpiQ8Xf1/WgjJkiuVi84EwV5EconkyZu4neyFuZE2FMC2LbAvwFLF0D9zdhljsoN7llieQ8n4Lcb2wYGtsL7FqTcjSSYaZSIcszKHEoH9kYrtxkiNLhaAOf9WAc7naDwzFb0eCSAREmYHyTfuhEh8cnUw51VB7hBTH2Bbxj3P8XuMin+fGri7E+a3w+cQEMVrZFZpJkZSYhw9y4kz9UoP5iTiOJMoUnQY10usu+IZz1UHHlf8qljvTe8xE9LWAl3K3o7PI5Q+sf0E4LVG4dysxb0MovR9wMpwQTFc7SH/8vNbobWRe0WNCXfXdVA+bdgWK
 BPBI+5XS
 +aPgBL/sVqPgYhL3yM7Wbrr//arCZRWqvFcgmO8mloBhiS3sKLRwvdY4LxIiyHLykuNbStdz7DBvzABkg/by9iikCVmhlkpHpjawqk6+Qjksvste+OAlNwtaKRlHYN0YZG+yjMdi7F+A41mWG6Ap/oPXPDmm/ZJupYS+BXPqF2az1FQKru916ed5qCyQtPUjguE8mBQnOAzq6NtzkA1txbpseldWU761Lxb24RzXsuhu0UOV13AB3hYaiF/jy4OznqPwfk6hTe2wNuEzIx07U9veHb4z6qd7JTDDBXhSFvRpwQO8QAAWnXv+xqEwEl2f+m+THm+CrkZS4zp6V9fbQ+dlwInpcvb8yKlnXR8mQ2/1c3UzK+d48EkJEKO9omTxHasz88q7UJQk4o420Ug4oiO4I/ZKj0ofviMrtV/nhN9KDNtphyBG8K5dHIJCB0qB6wBmG5s7ctCjiURSNoa5onZpHje+Yj/rPhKpDKv7lUctoYdbA3oQyEN7/pvTov9WsvbtyxA3ZTAPERkZXXZxof4oJt4vINhqS7bXgWRPbeF3WexaHSh59Vz3VAtGP7RIzgwUlau6+gIKyLDQnfJfr7V5NDCqa2eqajYwJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------QkD6sNHryRPp7GhYmc0ogbyC
Content-Type: multipart/mixed; boundary="------------hgucM73EFMWBf00Sp10C1CQm";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Hongling Zeng <zenghongling@kylinos.cn>, vbabka@kernel.org,
 akpm@linux-foundation.org, hao.li@linux.dev, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, vdavydov.dev@gmail.com,
 davej@fedoraproject.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhongling0719@126.com
Message-ID: <bbadc488-e5b1-4868-9da8-26e2cecd93b2@kernel.org>
Subject: Re: [PATCH] mm/slub: fix kobject leak in sysfs_slab_add error path
References: <20260713055829.127864-1-zenghongling@kylinos.cn>
In-Reply-To: <20260713055829.127864-1-zenghongling@kylinos.cn>

--------------hgucM73EFMWBf00Sp10C1CQm
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/13/26 2:58 PM, Hongling Zeng wrote:
> When kobject_init_and_add() fails in sysfs_slab_add(), the kobject
> is not properly cleaned up, causing a memory leak.
>=20
> According to the kobject API documentation, when kobject_init_and_add()=

> returns an error, the caller must call kobject_put() to properly clean
> up the memory associated with the object. The current code only frees
> the 'name' string but forgets to release the kobject reference.

This was intentional, please see commit 2420baa8e046 ("mm/slab: Allow
cache creation to proceed even if sysfs registration fails").
> Fix this by calling kobject_put() before jumping to the error label.
>=20
> Fixes: 54b6a731025f ("slub: fix leak of 'name' in sysfs_slab_add")
> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
> ---


Uh, there was a similar attempt recently...

https://lore.kernel.org/linux-mm/gimwkjjpvwu2sg5625b3eeatw2vhv7rs6enm3vep=
dduhcefbf5@xen5iec7sn3z

Sounds like we need a comment saying it is intentional!

--=20
Cheers,
Harry / Hyeonggon


--------------hgucM73EFMWBf00Sp10C1CQm--

--------------QkD6sNHryRPp7GhYmc0ogbyC
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCalSAuwAKCRCGXBN6rc5S
1vsbAQDs4Lw4Ek8Gn4jlJt8wBRwcRV7RGW3vinWpQ3r41+qVOgEAl98i7EfRDvbp
Jr6Y3PPHuaApvEw85RpyULz+SElaPwo=
=0KHw
-----END PGP SIGNATURE-----

--------------QkD6sNHryRPp7GhYmc0ogbyC--


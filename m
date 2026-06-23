Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68C1FCDB466
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 00:29:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49CFE6B0088; Mon, 22 Jun 2026 20:29:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44D216B008A; Mon, 22 Jun 2026 20:29:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33DC06B008C; Mon, 22 Jun 2026 20:29:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0DA436B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 20:29:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 76452A0305
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:29:07 +0000 (UTC)
X-FDA: 84909292734.03.A2D232E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id B2097180002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:29:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mwd+82e1;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782174545;
	b=ZMOdTFzfRUY6D9gP4tiZW6oJwwy73tgmJH64z6Io3wBb0JjkbCqNKMPLW+wN5pJvRyUGbO
	2IrQKausdnih9WJY27XM3wEIaZe3jkC7aTBiMgT4Le/YrA2LS28VTJT16nlBw/Uyrgd4hl
	PPsvbZVXIf5oc0fN7v4aSGaWq3ZGpiI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782174545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eK03vkkuyEwvtYJT6roqYFJxffy2Bhftb2nbg6xVsZU=;
	b=I78XibiqKA3swx00P5ees86kLvsle2F0XIJU49+8IfsCBmgHwwBYKV4s04fszujR/2Zqr6
	p1oE3J/jqn6u1iDoz4QdknP1cYrO8Y6tnluVnaqAI3h0FmyJdf5hdUM7MCkCbFkUUW8M9/
	kOxV4dVK3addse9jmxA/Tj+68P5SOcw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mwd+82e1;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CF9184028E;
	Tue, 23 Jun 2026 00:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D821F000E9;
	Tue, 23 Jun 2026 00:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782174544;
	bh=eK03vkkuyEwvtYJT6roqYFJxffy2Bhftb2nbg6xVsZU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Mwd+82e1EzaV3w22I6l+SlqzIz/Wi1uZWOCYPOu8bbxZOTC3/h16/v+eXyOre5tEF
	 b0N4/ZT38HIetJhbF6a9c3awp27F3tlQSPhi2TCHkZF2DSN5EJS5LRlflFKXprFJt5
	 fRW1Npm41jV+UB+r5LQZrwUkxTVmfbnQBo4FYvcbrQ0RCyNJhJKnjvIpQCY9GtJDsO
	 nY/QMIrx5MYqfgBO5KmZSEM+jFuWT/DXTTf1UitxJ/RYlGQjPjkFdcx2NM+EVkdNCP
	 ZHgOWlkOsGtSta4t1yn5+JJnt9a2g74DfnyKe7Q+QrGlHrDhvEW2gtVIIeoeib6jSC
	 691bcbnOt8XbQ==
Message-ID: <2f4c0914-1459-4895-bc64-345b80afad2e@kernel.org>
Date: Tue, 23 Jun 2026 09:28:59 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: Add Lance as an rmap reviewer
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lance Yang <lance.yang@linux.dev>, David Hildenbrand <david@kernel.org>,
 Rik van Riel <riel@surriel.com>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260622155913.280355-1-ljs@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260622155913.280355-1-ljs@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Y1cniXBnvQmmPIIYzS5Sh721"
X-Stat-Signature: bg7aqhym8map3q8nyb4p5makzhmcznai
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B2097180002
X-HE-Tag: 1782174545-923515
X-HE-Meta: U2FsdGVkX1+2+fVa2BX0EoUUlDj5NsLGHt9lkWYzy3iob7Z0ajPRT9OWJPmdi6A+JPLxhPQTA1FvbQyJHbZsZu5+BQTgdSj1eDeXUxX3l0So7Gfls6V1zVcuMVC/AW8T4YFHW6Ex2hUrHo/tn5nEjCDsb5gNEKaK/IjZwO4H2YQXdWF8ovdjqVKEsV38w/Y5bfMt0sKMf/ytFWcnrH5A3d/+mz/Y/fSUFtkWnJApY3IUoF1tACo8QXKWxFcQRnTitBjh6gn5jHS9LUQPXfmG6tJssHTHgsbxH+ZEgVRCtVLacrsQYHxu3CwKrvzJiwzLymzuOuYcaaccLzTW3NfSeaYvUE01VmDx1K4erD8zYD+FL4Bztahg/Cr+bY6BEF8sT8CPV4f4xJU4QBnuo4HYZOsg9wgYjrbImF56/B4gsVwKzBuW34+VX+RaXHxOxg6jjL/3KJ2x/pPBrrYSJzkbA2lLxZqntTCTecK1DME3UcneL+9BwXjgNyLlow+xZbdZQ6YxhB/T2deCFWa68+wDAkYKxMwWvCd35omFCg9AX9n/nIMHu8UD6AfE9P2x9s4d5tPz6XnrXnhuj5zQQ3H94OYNwFry4TjhOxFXb/XP8M93wDXSAd1X/IKvbcqlUrvKKeHEvuLFxJ9mUm/A9ny6el0qbmw9U4m57sZQs20B8R2dJ8sIRwBZi5pbgqEmtpkKePnY+A+tF06lTvAc6FvLFVIFEDyexARHNmZMISOFB/52bRP6YlS/nC9T9Wvr8n6epjP10WJWXPCN4OYUSdUvyGNhwFBSczjsxH/Tls3ZA8DWxJ0vESj3tqbobhKDobUXi6GgIXe0nXXEI0ilLWNQcFRn5UtE91O4B2roxVmg8XnEbWSOqNS19to8tIYIEIeM0WUDRVZY32gtiZX3j4lLy502ezvyEXzRbgMUXDB2LeJAx8rcWDDUpKRqSK2VxiRP8KE9VIq1RBr55QCbAEb
 lesSszF1
 EMK6+UV+Xom4br4sRw4CF6j5jh1GYwCxUNxP1f0uiQZOnYWXQ0ZD96cMhQUR1RJj9aGgypvOY4X2viC4BVq5FGIwj0pa9HYeexn6FmDSBXdEhrZHHfAT5dSaUYBo+p7y3BBSEdCHrksc0Ishk+jkWkjnvTljIQYSObVYgbKNF6rhIFVuP/Gwl7o+iuJW/A1KUwV7Cd++Z7p3YuE9THhCXUFTXiS1qsj6ZUJOCHkvFFFVrjt51d6D3fMhATw5wxlsZtws7LvqKwVpyq1RZU103q3EIvLr3tInrKO/qGOc60iJyIeaqzJmItn9LsX2GMTpgIaq8Kgxees/cAAoDMUap0gEtvCWSSGRsQVH0VxBUwkzw+99xCyDw7srSG+BFR4yeWiK9Wh3nyp2iu9wqRBu0Cv9TV71uLoNBcMgDdP1BOWIQL+2AVvK60Dt3/bLEPlc1PnQdSREQJTnWFEr9ay06loOZsrq1na2qBalU/OD0aYQwl6M38LkeHUpfzg7uhcxU1lrQHyZi5j4yeWReyJk/w2xwdtCyymCvf9wAxYAUbm11Y3UBke1m+7kzb0nKG7aqPpiP7nxSP1DE8aaqMZoUp6rqkG4lh0AauhWS7smhassOLAQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Y1cniXBnvQmmPIIYzS5Sh721
Content-Type: multipart/mixed; boundary="------------7HTyjs0BAWD8GdgzJmGY714K";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lance Yang <lance.yang@linux.dev>, David Hildenbrand <david@kernel.org>,
 Rik van Riel <riel@surriel.com>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <2f4c0914-1459-4895-bc64-345b80afad2e@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Add Lance as an rmap reviewer
References: <20260622155913.280355-1-ljs@kernel.org>
In-Reply-To: <20260622155913.280355-1-ljs@kernel.org>

--------------7HTyjs0BAWD8GdgzJmGY714K
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/23/26 12:59 AM, Lorenzo Stoakes wrote:
> Lance has been doing excellent work reviewing rmap series and has prove=
n
> himself to be a great member of the community in general, so add him as=
 an
> rmap reviewer.
>=20
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---

Welcome, Lance!

Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 65bd4328fe05..dd963b72c614 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17024,6 +17024,7 @@ R:	Liam R. Howlett <liam@infradead.org>
>  R:	Vlastimil Babka <vbabka@kernel.org>
>  R:	Harry Yoo <harry@kernel.org>
>  R:	Jann Horn <jannh@google.com>
> +R:	Lance Yang <lance.yang@linux.dev>
>  L:	linux-mm@kvack.org
>  S:	Maintained
>  F:	include/linux/rmap.h

--=20
Cheers,
Harry / Hyeonggon

--------------7HTyjs0BAWD8GdgzJmGY714K--

--------------Y1cniXBnvQmmPIIYzS5Sh721
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajnTSwAKCRCGXBN6rc5S
1t9nAQCkngTYeGWxrp8gqpHof5x7TV1WsqM4uBEIMrk2WAXI2wD+JWU66F/R7xr/
HiqHXR5AP3FS0tgNAvMWJStfTiZg2Qg=
=N6jl
-----END PGP SIGNATURE-----

--------------Y1cniXBnvQmmPIIYzS5Sh721--


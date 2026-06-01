Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D37A2CD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 03:39:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E24BF6B020E; Sun, 31 May 2026 23:39:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD5CF6B020F; Sun, 31 May 2026 23:39:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEB976B0213; Sun, 31 May 2026 23:39:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BEC6E6B020E
	for <linux-mm@kvack.org>; Sun, 31 May 2026 23:39:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 527548E839
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:39:00 +0000 (UTC)
X-FDA: 84829937640.05.826F158
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id B30A71A0004
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:38:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=abmMi7kD;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780285138; a=rsa-sha256;
	cv=none;
	b=AWENqejJNNCgi0xwyq/27iyZwLYPfsxGvY+Ll13VNtT1IQ9PltZ+ZPWmgcBD5Lz0/fjQSx
	9xDLVRu4shua/4Uvl4xSdJk6/owrpVTYLiSyvCIsU+1Gl4VFuywfV9Q+lryuF8Fx9TowOz
	/e+106+4YiWjsp/Je0mXpjhVLzxiAu0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=abmMi7kD;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780285138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O6ttP73ev96TdFerBTl0monlsGmeiqwaQhiYaXkxoCs=;
	b=lgvYf82Lay228a1xTfB1gLRoCVWryekeAXhayd18T23dWdkPsnbFWUSJk7SxuJilq74YFw
	lPXOm9W5yDxTlRdzxycWQ/0qTSeR+L54JG5Ha1FAO5ftgxxDNDnVg/8OJYrwsytbIyc6BR
	nxLmQ8TTITADdjH62rxi9xhFo0TweRg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0FAEA6022E;
	Mon,  1 Jun 2026 03:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E5D1F00893;
	Mon,  1 Jun 2026 03:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780285137;
	bh=O6ttP73ev96TdFerBTl0monlsGmeiqwaQhiYaXkxoCs=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=abmMi7kDRBUcPK25SIbXrrcboQhEijQhzClkdz/m1wMDgFUpnvJd/GAj4m0SHsgKS
	 Ye4yk4L4cwCwouAX85hzGIliWsVcNUMOYfX6LczUOF54OL7L7Q3HUgFyb5iOiHZ9Sf
	 i/vLZ73s7DfrGpyBvck3KacB+zX0LE0ZSyGxEAowDzqkc0amaq4pkpuP55fPCM8zN7
	 R0AovCIeCKZ/KECXEFNNc+AicsDvEJLY68COE/dFn1ZdnLCDUg0VYTYSO0FgPQ07Yu
	 cuuXpWihejYnTTRamokRcgqdWepc/0Sw5lVqc5D/dt8njv0y6G5BucvYR1Ildm7a9B
	 dKPwMmiglR1IQ==
Message-ID: <5ed81b4a-1d18-4535-a18c-1bb31969ae78@kernel.org>
Date: Mon, 1 Jun 2026 12:38:48 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Harry Yoo <harry@kernel.org>
Subject: Re: [PATCH v3 1/2] mm/slub: introduce helpers for node partial slab
 state
To: Hao Li <hao.li@linux.dev>, vbabka@kernel.org, akpm@linux-foundation.org
Cc: cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260529035120.81304-1-hao.li@linux.dev>
 <20260529035120.81304-2-hao.li@linux.dev>
Content-Language: en-US
In-Reply-To: <20260529035120.81304-2-hao.li@linux.dev>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------CNKNMZfV8LoY1cMCfGx7hFIY"
X-Rspam-User: 
X-Rspamd-Queue-Id: B30A71A0004
X-Rspamd-Server: rspam03
X-Stat-Signature: 6nq9g9z4cz4fuwt5c7nq5f7kewh9ijqm
X-HE-Tag: 1780285138-868855
X-HE-Meta: U2FsdGVkX1+uFzKp6lHeT5CDbVu3dTkOkVuEsc4k/OLaiupPEFFMGz20PYKnHRb/HoDYOnLTJH2G14lwdIDyKpBy98u0QviNlqY+ZyJ3wnoW9MIovc7vrxmTfxz4VYFLNWXX22IZYMCGSMAdscbrq5SByiSxOH+m9WJclk0msJPIwQBDEuKgUrAw03LRR8b8VaB2EeMc6uVKdlSPDLMVphDicoLVKFSCLviitEnh0MZvcGXukBvSL2zQcjNSLLTpeXaxQsMsf2Tcz2sKTC4z3os8J2jTLkUw3guHcZpxMdL5xy61uYNLADfDhjM66CVBjOQt5zy541S8qRE6m0BmCq+9tYr+XCeK9TabK4ijJEYjU7NjAY+sv4/q3OvPYcUKNA7qfj/oKCKkzvV27eztZAtE6Qr+nW6UrmsPfpn5HG8eVIFgspF3x8dNnMPU1yG1+bFM7QqX/lb8Wy94DjQlCHy+xAGyluHcrkauILsiRNRv7EXuhpTBbGmmPCQOuHUegUO3VMI4o10ndq3/ukUgreiy3rcR5mu1qOx9k0GTjgY0DjtGTviBHrkR555QBydsLkN0Ag6egprTfPJSvOKcWGEnNiuorSLCgOm16T9uedue/POS6D5qj5KzE/c3oxjMdn9EuYXBNG/me4KPsL5w19nnYfoRbhfRPgBmpDwgI+oL6jphSle2xNuQsyP5zXdXRgZsrHBPC+I+tj5GbT/7bMuWzywtvohDf+g9xY0k7cNCMDnjj5IBZ9mVRHI73B07Y4pNaDI3fzf1lEy20YUXh5xEoeTiZ0klECsYCw/5zvVMXrhrniA5E42NeK/oAtWKe3F8smip77lOrZLEYG0gu4R87b/zShsyZzluM1UTQVwYzZO/1VkmX+e5rMz+Ecl8QsVBf1oSZfebrMwggZfZoIPaCFnsnZfZ+l+KgEDegQ9hDiB8UKPblCtrqpg+gjdK4YY98PzOcU1rsE5xNZn
 iX70OVir
 Nm2/Q/k680PkxPj2LWMMq+yY7+gb/xVWJAtJp+X93Y44LqMLSydOn6wEiJJruo/HOiwBf0aT6oAJCsg1Ngy/4SJJCyj6+mMbgsCFsSipSQ1mP4wZ1tnA8AgsQuEBX2Nn/zHs1zq5QudMetV/Q+iu9uTYHfbBbqe0oRpNKsq9/ziN60ZfAQhYo7ezgh3DyClCwi+a7FPg9XRkdExllx11ccRamVqVIpbp8Sxp7eORPad0NcQ43HrAKVHAUY/At8bX5UEnrNtpt/5SFQa8mjkTI4/JXPhDVwVP07RLvdsvqBtrsrfVX0ywzJrAev1/Y1yh1QrMrGiSSmvIGf3QqYZBTAgFab3wceo6plZBcFSOQmXB/hiINjPPeB9Wq4kStEmPNLDRjY2DrrQdRsF5InTIKfiehkXRg2Xh1jDhxpjPj6WK3a1uexdjtEnnEEzU6fHqvKxWMkumV4BYpjZzw2szTVLNMEQMjWZ6vCgui
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------CNKNMZfV8LoY1cMCfGx7hFIY
Content-Type: multipart/mixed; boundary="------------DqDzYDgKdkP7Ff00j7RvjNtI";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>, vbabka@kernel.org, akpm@linux-foundation.org
Cc: cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <5ed81b4a-1d18-4535-a18c-1bb31969ae78@kernel.org>
Subject: Re: [PATCH v3 1/2] mm/slub: introduce helpers for node partial slab
 state
References: <20260529035120.81304-1-hao.li@linux.dev>
 <20260529035120.81304-2-hao.li@linux.dev>
In-Reply-To: <20260529035120.81304-2-hao.li@linux.dev>

--------------DqDzYDgKdkP7Ff00j7RvjNtI
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 5/29/26 12:50 PM, Hao Li wrote:
> Wrap partial slab count inc/dec and flag set/clear into
> helper functions to reduce code duplication.
>=20
> Note that __add_partial() is called locklessly in
> early_kmem_cache_node_alloc(), but since there is no such use case for
> removal, __remove_partial() does not exist.

nit: __remove_partial() -> clear_partial_node_state()
oh wait, it does exist. Let's drop this paragraph?

Otherwise LGTM!
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

> Suggested-by: Harry Yoo <harry@kernel.org>
> Signed-off-by: Hao Li <hao.li@linux.dev>

--=20
Cheers,
Harry / Hyeonggon


--------------DqDzYDgKdkP7Ff00j7RvjNtI--

--------------CNKNMZfV8LoY1cMCfGx7hFIY
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCahz+yAAKCRCGXBN6rc5S
1pjNAP9n82v/7/klMOjhHsDAacPpcFHOqe15jjq50z+NEDhARgEA66WxRiZc9HpP
Y00zZLC7w/aGLnZX/qdu9sNShy3XJww=
=8rT6
-----END PGP SIGNATURE-----

--------------CNKNMZfV8LoY1cMCfGx7hFIY--


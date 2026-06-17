Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03367CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 09:36:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFDFB6B0005; Wed, 17 Jun 2026 05:36:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D872F6B0088; Wed, 17 Jun 2026 05:36:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C752D6B008A; Wed, 17 Jun 2026 05:36:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98C016B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:36:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 203E6165B67
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:36:38 +0000 (UTC)
X-FDA: 84888899676.30.B268770
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 80604C000A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:36:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iUcZfZx2;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781688996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=apFpL1e7Ohu0dfTLu6wmaybdl1sf57ZeY/cr6ue447Q=;
	b=y3QuwxEVISkFeNiIzNqbCxuCKt0uE6YuE20NktS04+pgf9p8vwuG/kmHh6JGk2sSCvlnsR
	sjVGvXwzVTVIN2aE0VVnCvqNHhXCyB69mw0uKLAESFFpC468ZTMj3I9d0VmhXYx0nT3SQ1
	3Sd5PopjqUsBzLmqmJMSKdQ1FGWXEiI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781688996;
	b=nbSwp5TizlEpcFWbhquNVOPWCHQum9c0DWMO/sQvKLEHnq3snRGCgr+dKtscIpvI10iAX3
	TkqGktoJ9sqJ4eQFsFJ7v0ZS4GcvU03IbwVevBwZHFUHkwP4eTWVnTspkseS8LSSb27emE
	dU2XV2pwFWDPcueRHbxaTyYBu2wjfHY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iUcZfZx2;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F1825600AB;
	Wed, 17 Jun 2026 09:36:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F6E1F000E9;
	Wed, 17 Jun 2026 09:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781688995;
	bh=apFpL1e7Ohu0dfTLu6wmaybdl1sf57ZeY/cr6ue447Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iUcZfZx2htTGVUMnfQK3FveqDTIDwSfOiCNAFKqjTunLhJAA4LbCoZksU57JMWqhb
	 E7zKfLx+KjxB/1F3hRN7ld03Xnd4OOAYpHLxu2GuD0GMG8AmH1LJKd9bS62vKpMj4Z
	 RkdTlxSlkMR+rNu/1d3sQxLXUtfrLURsDYHfDaJ+DlBTcYmit5UP7bkPzmaCU1gn3r
	 O7UY29DgPoZVyu3QpP93j0KtDKpgFGCEEPQFzPVDtEFbA9MRSZfi9rnx1I8KjtN4GQ
	 cNATgsxQvnSC3Fdg+eLYYLKEJcB0OO4RwHDKdAKT0x0/GbdHjjSPFo0U36HtaTIqeM
	 6R6aTf5QR+47A==
Message-ID: <e499bab7-9217-4bac-848c-fb1472cd2c00@kernel.org>
Date: Wed, 17 Jun 2026 18:36:26 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/15] mm/slab: pass slab_alloc_context to
 __do_kmalloc_node()
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-11-ce1146d140fb@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-11-ce1146d140fb@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------rWUE760itSiMGFZhE7U2S0m0"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 80604C000A
X-Stat-Signature: 4bjjk49eqngeasst14eaw5m3atwpswyd
X-HE-Tag: 1781688996-652577
X-HE-Meta: U2FsdGVkX1/XHRL+1egJ1BFs3fdPRffNF1BUJViB4w67q5tsTNTbi0oE8EcC4+P6uVJH7QlTZbi8Gs4OCXioHaGdlGij2HW3VbYWMAHXGQJDyreM+9juSGZrmJwNTjagmjQS4GEFDpqNjeAru7gcG2E0RRxWaJppuOUbLQNH0/TghGTQxrlI2rgYUZwj3Sp66iNWQY1Ydp9MKh68+oQLAQa9e23qsPT9+VJjEF8oQulzNmZy9scQgtngT2xg2UuMmK0uG6l15aFZ19PpCFPd5pQzoOxB0tGm9w6f/2aaCUttdtpgJvz0STm6AC0Q5QLF/tUR3LYGHqoGrmNutuNUuD9mca+uhyHcqpZaE1HLaVKBbd8KPxoHolMleo8XblUsrThWKWRAyZ5lnlceu2NleZG1Bw4FHEgESb37J2xYn+k6/jpBPO6OapcZX73yc1Zrsnf3KYSX+WlzCcZvnpLLMiKSou476vtHR9ERPqhpUCDbS85osQeG11GXCq6a6Q+WBl8pnxAa7/L4ep5hJqGOSzchSqtqxB5D517yy7TzjvVEnLHSE/61sVUsgaenWQFZPVcb1aW/ZMANB/nwkbujBIN0mKX2RyRRhkp/2kRoAD5IyXrDOHUL47SoRMH0260AzV0sY/Rc3vOVBKatuBaKCrfTex9zTRZ0N2EW/54GonoQF12jp5ofrxcxreQZU5V5l15epOjs1/sl/HGJ0nGfsbBJ8TothWS1H8grwYGEIQ2e6kPs3dHMvqHuboYw4gBkTaclSokhNem2LmBUv4/jp0sw5ZN9KK0gWkU6ENvZSVwClT+6rsGdv5AeowmFlufM4Mx+t4ii6QtaciTpLVidmj8c+Qa+DabvGeS6WkqMC8QDQFXFNg+4bNiUINpDYyS47iB6vsUJQJHvTWErNabZ3z2hFZet9AYxtI1/lkfD4Obdw1W2XjeqcatNPq6aOtXJvvukmUJt0s4sdaXsjLg
 ft7w7dhO
 qaj8aKDGXSkS9lHJecNd5+gPjeEgLtn2AtN3w3DHa/tkqsLmmXsEtl34BXOxpqlHY5Ziha0UrbFom7llAtEvUgrK3eUjbeseCaDS+eBBGFxHOudN9rIbGdfrb3vHTGjs8FdEj1l5KYx2Mv8sKqdIwVzmauIthqq7nvVeYPnw6bO7Y/E3Ez6euGpOJA8Eei+zGthNv9IJyC1tSKOOWaaA6LJVthi+eWgjfdqrYM6aBUIpbbDuO3n3Z06vMxd80weYKqdERlHgdeR9uKmociJxl9oiE8j9cEQfL0Tp1qy9i0NrFPk0hTvOPKNlJzz4GyUcILgzTJZx6cvMW9kuGf2giZy6IYQfmGw7I6z2d7C6h6z8iKbrL3jQWnJOL5zVm7wLplhxchmDP9Yy1QOAQAYOCVTiNf07IrGyXN51A7SKdum/rIJUtBQ2dVjMJDkvQAtTuox/S8GZtz5narwtZvLVbxn16b+vAXugKlUe1zD6DBVW150fUDvvyeAEREUSDEEcggNrQ3xuW1fr6IUvrG091iVM7vQFOieuNdcX5SOpMSrz/Asq4H3WkCU/n+sDqaZ5oLDLqAdj8BzZDHT6Gs0RgzhnXfh1brxim4zG4P9/ZO1aSEQw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------rWUE760itSiMGFZhE7U2S0m0
Content-Type: multipart/mixed; boundary="------------0cKAcwBqd61rxD70lkQiPDmz";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Message-ID: <e499bab7-9217-4bac-848c-fb1472cd2c00@kernel.org>
Subject: Re: [PATCH v3 11/15] mm/slab: pass slab_alloc_context to
 __do_kmalloc_node()
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-11-ce1146d140fb@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-11-ce1146d140fb@kernel.org>

--------------0cKAcwBqd61rxD70lkQiPDmz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/15/26 8:54 PM, Vlastimil Babka (SUSE) wrote:
> With alloc_flags usage in slab, we can replace __GFP_NO_OBJ_EXT with an=

> alloc flag that prevents kmalloc recursion. For that we need a version
> of kmalloc() that takes alloc_flags and use it in places that perform
> these potentially recursive kmalloc allocations (of sheaves or obj_ext
> arrays).
>=20
> As a preparatory step, make __do_kmalloc_node() take a pointer to
> slab_alloc_context. This replaces the 'size' and 'caller' parameters an=
d
> includes alloc_flags which we'll make use of.
>=20
> Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-12-7190909d=
b118@kernel.org
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------0cKAcwBqd61rxD70lkQiPDmz--

--------------rWUE760itSiMGFZhE7U2S0m0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajJqmgAKCRCGXBN6rc5S
1iS4AQCLRD76+3wcnQ2tKc8Sv5vzWltn/HT63SdLAQZxDEZHtQEA6UR3K29HgeQQ
r9k7dPVVOUsWaYdcnknjgAp4TiM9dw4=
=zxWP
-----END PGP SIGNATURE-----

--------------rWUE760itSiMGFZhE7U2S0m0--


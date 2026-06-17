Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD91ECD98EE
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 09:24:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66BE96B008A; Wed, 17 Jun 2026 05:24:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61CDC6B008C; Wed, 17 Jun 2026 05:24:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 534C66B0092; Wed, 17 Jun 2026 05:24:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 233116B008A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:24:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 782AE8D5AA
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:24:56 +0000 (UTC)
X-FDA: 84888870192.12.C7000A9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id CD62740006
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:24:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MVKZCXUL;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781688294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ukDROeDwzr3ZoL8vVJ3NTzkwU232sE6vLyeqP7y78jw=;
	b=TpxxNnOgN0Zy3A9zmp7dVYBRpLgyAPGho4c59F3/bd7wSQRx3Kn8YcBiAQqZgWLwAbelFE
	wc3RMZB1Z+KrDzTS554qd4QXRjJpHuYpxAzWl/PzzTaUr8RE4V61GsbVWbG+4S0PiUC3T3
	E4o1HJdvwK5OQAwxWmjqm+NRh5WwWqk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MVKZCXUL;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781688294;
	b=ijtq6sQaykxCmLXM7DSsFpaYA6s2M9m9zseI8R4ZYT76k7OLiC22LJ3llrY8ZomQS+UhWM
	Y0ptmBG0uP0cIRU52V7m6u5FRYP5S8EMH+b9v2wExX3g9JCocvHaI8DzAnDDDjn8Mi8NPx
	upwd1Owx3gKtke3vbM+4fXBNNyRRrlo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 29026600AA;
	Wed, 17 Jun 2026 09:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E2B1F000E9;
	Wed, 17 Jun 2026 09:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781688293;
	bh=ukDROeDwzr3ZoL8vVJ3NTzkwU232sE6vLyeqP7y78jw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MVKZCXULeCc3WHehHQnprURu8tAPLhNcCq/k4c0vi55Vk42y2WoRo6luW4D+o8FUK
	 K8h8MeEyeIg2MhIiiLPh8kRC9LPQynCKhfxaA+aCu+5pUoGLpqSbXAyWlCIOKwLVQb
	 Aec4MI0xzeskZa0VK89aplGsm2o9JhqXjG3GzxyNREu0Yn5ZJdf4z8/ajjeqd/qLk4
	 KZU1/YWovxiWjFxAA+xx2glO8JnUrPStRAiLjKXSikU1+R/91EH3d+fK119lfz9JLZ
	 J0cHUT37Qt0OZHEzXwwNnTOErU36KY60pTySsx75q5njKlFylGee/J/n5grhzSt6CU
	 UiF7wUqT6Kuuw==
Message-ID: <a80d7409-5a58-48c0-8ccb-b568b3e3a1f9@kernel.org>
Date: Wed, 17 Jun 2026 18:24:44 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/15] mm/slab: replace slab_alloc_node() parameters
 with slab_alloc_context
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
 <20260615-slab_alloc_flags-v3-9-ce1146d140fb@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-9-ce1146d140fb@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------tWEfSKJRdmtGLwcIaNnNhpfw"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CD62740006
X-Stat-Signature: njng5sdzyjxm7xfc74f36kt9ydz8cpke
X-Rspam-User: 
X-HE-Tag: 1781688294-144945
X-HE-Meta: U2FsdGVkX1/UaKCnVS2ZiExUw1zUQ/HaFT/xjRE5JLE1kFpUocTSTaiWdkDe54GkI/8AjWEGMTej4JcQTHU1rSAmJF3E6mW9M63bYqkZHUMbjsMARdGEnKSfbGew5vmeqmLofM0gj5/s4apfKMQLgjQECjSfY7TuaVHRm60C7pNfk/i22GeEZnxQozqgTuXoclMIBuaIXCNon+ZddONGCEdaaMSXQ1iS6kvlo6UB9yygquFyMESonwflRHzSs3qlXUAO4E16xywiT39TuUfpC2UUTmRGWNLK47uxzz/kwzF3sMrFQmGLwAo7ySEyxJEvUZlk5kcoVDWBj3yrqdrEpkMtGii3QCMgZ/Bqx2dIzzANVn6SQ0xjm4v70OGqcUJrCSUKh9FMpVM0A7kyCCxXCCAeuiU/GUptycrN6mu+hTIzXx0BdlolYlfA5T89gUPofPMTldQSNO+eXBmDc1DTssQUnwaq5KddqR49Ya6e18tzz8wjl2Br0ZsKi58McsR08TI+hFXsliAbk7dXkRZ6374DWsyPjt2Y3oCaU/3KumbyQH1viFgeMRWww/UHNz/rcteqd55k99sSGXkyT2y6NQ43EzfXvxe/Gic+MmB6uWBTP0eACqIx8eA412fyfFP4SLmMkOO9OmwMTGrO8i4DRs/VRw7U0NyZN7Dv05hmpRmw1A7WxrqYkN8zMbyM5mBDl+trRfbHm85Z9DUXLaZZ7kvMWWurIDXUNK87Gbx0pb+H1NgM3cwpfesk9+MiLDOGRwtdcJvwZw0Dg9eJQ+8LTx8jI37nkQFtuQmTniM2ZLZn9NBOXjbV5DxiidCBVPFfd05QPN6YKIvHeJQeAH/VMndIFxBR5awRmSHBor7s1DOuciMzbNCXpTQ8g6RtNpXjlvp3WdYU2fditzbs8Vn9dvLy3d/sTYJ0AR9RUs6ZrrmztQz/+uNM4y2N4HPcy0ORhtH1uc48iIxXVIZMB5w
 auvK3q/F
 iDfvQhHDrgY8Lv6/LSLu/6NmHRv/JDg8n0e8+AeyEPNYqnN+I8NyJj0ZXUGaoU61f/rEjcEuFYKfy/PD9sSh2UqRAnA9D4SvkMVLzbF0E3pQ1/No+jhAXRY2CNXVNFjz2ov5P++Xmw6UV9hFQHCc7rYNjRtcy2M8OgA39in1gtJL2EOPuwmJK0CvOt1+bUtQZKsxt24OSYiWxv/gIWjwiMKeywizLXEWJSGb5Y1QTphj/Vy9epEaeqUvCryVM7TyDEaq1CQe/GQv8IDSl9ejO0SlTdBF6JfOxM9VDAuDms+vsHr5x3WyfuhWK8a5ALisfkh6VBm50mc0MaQ/wb1B9FC9fM+FvlL9IzItD2pCwsA6IR62Rhzh3gQw9jNTpJyiLdW5b4g5irojX+wm/50cLbGcre96gEoGosTWVc9y5iKWDejjY22egrN1rg0BvASb4oJklynv+6Ez7nOv1ezMVOVQ2No67Q8tg0vBAJIzcdSjZiN2IUKD0tNmTqxUoSPCTwu5q45nrBXXxpr/6Ae4alrswRFv5MZ/7IS8Li72lKwlK/7SLXUye/3Rp1AU5sFUFTIanTiA10v2I2nW0enyxr64m2j6XODug+AqG4zH97l30fpktHbOhVRwOMd/toKcLDXrc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------tWEfSKJRdmtGLwcIaNnNhpfw
Content-Type: multipart/mixed; boundary="------------XVYSd1G00Q7d0rl9kEo4pZcy";
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
Message-ID: <a80d7409-5a58-48c0-8ccb-b568b3e3a1f9@kernel.org>
Subject: Re: [PATCH v3 09/15] mm/slab: replace slab_alloc_node() parameters
 with slab_alloc_context
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-9-ce1146d140fb@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-9-ce1146d140fb@kernel.org>

--------------XVYSd1G00Q7d0rl9kEo4pZcy
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/15/26 8:54 PM, Vlastimil Babka (SUSE) wrote:
> The function takes all the parameters that exist as fields in
> slab_alloc_context, except alloc_flags. Replace them with a single
> pointer.
>=20
> This moves slab_alloc_context initialization to a number of callers,
> which is more verbose, but arguably also more clear than a long list of=

> parameters, and most do not use the 'lru' field.
>=20
> This will also allow kmalloc_nolock() to call slab_alloc_node() and
> reduce the special open-coding it currently has.
>=20
> Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-10-7190909d=
b118@kernel.org
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------XVYSd1G00Q7d0rl9kEo4pZcy--

--------------tWEfSKJRdmtGLwcIaNnNhpfw
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajJn3AAKCRCGXBN6rc5S
1n9AAP9BIM7s05pk3i6+4MllnOO0QTEqYjoecioUKF0ZmLq1KgD/aE3egAllgoSq
jLfLRz8KrH5YC0vg+GWDmTfCQokaEwY=
=xhq6
-----END PGP SIGNATURE-----

--------------tWEfSKJRdmtGLwcIaNnNhpfw--


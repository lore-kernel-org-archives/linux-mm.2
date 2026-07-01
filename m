Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACBC8C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 04:54:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79F3E6B00A6; Wed,  1 Jul 2026 00:54:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 776BE6B00A8; Wed,  1 Jul 2026 00:54:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 666A06B00A9; Wed,  1 Jul 2026 00:54:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D3336B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 00:54:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 900DC120203
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:54:02 +0000 (UTC)
X-FDA: 84938990724.09.A304C14
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id BFF0E4000A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:54:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CWZ/iO/x";
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782881640;
	b=D8tYcbKpKHrUFMEmQjnzvCYsEEkETPDWQAGw/73b+/SuNPwljbmqDkOZzxeJPGyKd/PCoO
	WLGSaCbJhSBfjPAXad+8I2BLfBpqGFEqEzWAoKHHxl8IeTNJ8zqb6DTovowVqCJL5G0GzG
	P6BmV3ew5wnJV8XZYUsncHv95FjDHtU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782881640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PPObPGqbn58a+BSBCY9J0jUKRs+BuD8Ze2qKuyhsnqY=;
	b=4PZ5muW/ppZU+TgMiqrC6RbW4oDRqf5FbLgFO1l6jQLdhV8qMkoXaJbcDg04bixq4lIITm
	f2fdEiKvsKQkXCRiht/9aEB4LyuKzGkf6v9F76BLg3CE3NUkOMK3ThDU8pLjyhteT46kbw
	uHOzI9VbZD0P1I+eesVAISf7+Td5TGI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CWZ/iO/x";
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 90778439B5;
	Wed,  1 Jul 2026 04:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD731F000E9;
	Wed,  1 Jul 2026 04:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782881639;
	bh=PPObPGqbn58a+BSBCY9J0jUKRs+BuD8Ze2qKuyhsnqY=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=CWZ/iO/xxxWxdnqhN1v0bjq/8gJTOrd/6LXlYt/FvCEyNWN6jQwKl6fhJqtNwI+Ka
	 tlF5twq8OQwsrJrd+EPQwH3RRenp8REV6ePIBewX4A6meMloXxnSsoBS1rdXSzSJzG
	 zneKOMqWJkwmlChWIJvRm8h3keUFy64nUf6bvMubuvxxnRNYmI0wle4dwU0Hsx9Bg7
	 7w5ToxoYVIqNRI3zGgJKimOl/4foFGHdm2d8gcxSzgNRcx6X6IEXaealLHwVdBeIvU
	 a0K2bOYSIwsqsSSDj2xia9txJ6og2vlgGFvioNgvaJ65QLztfbr6SGiRZSrwSYBHov
	 wOG1PBdcHT1ag==
Message-ID: <92bf5e21-690e-4a77-929e-5217e0d7cb0c@kernel.org>
Date: Wed, 1 Jul 2026 13:53:50 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
From: Harry Yoo <harry@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Usama Arif <usama.arif@linux.dev>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Danielle Costantino <dcostantino@meta.com>, Kees Cook <kees@kernel.org>
References: <CAJuCfpFanDcpqq5B7eNZbw2HnWOXD-xzcnrdbz-e2gnSM2EYHA@mail.gmail.com>
 <eac2ed38-432a-4d95-8968-2663540d73d7@kernel.org>
 <CAJuCfpF78_5CjLsbJLte+B4MzfaSiAmyeH57VLhgLtj8AXD2NA@mail.gmail.com>
 <62969830-4b1f-483d-8fa9-9ce487568570@kernel.org>
 <CAJuCfpH8ZjBMaOmso=9gZNz=DK2ja5yMS+04OjTGHh5Uc7r0GQ@mail.gmail.com>
 <CAJuCfpFX_sMrcTad-QGJsCV=fNyMWF=Bi6XmoHRqEAzMbWNfdg@mail.gmail.com>
 <39a79576-dcae-4b66-9478-c81dfe676699@kernel.org>
 <CAJuCfpGRC7NPxcODUsb3YS5nV=qG+-SbSYj1Fwm-QPqgKSVWAA@mail.gmail.com>
 <c5c4208d-a6f0-413e-bad9-49be12f12d55@kernel.org>
 <5ebd3c4a-5c06-43b4-ab0a-7a8f0396c84c@kernel.org>
 <akPSjsbjl-UAcdI8@linux.dev>
 <CAJuCfpE4BwDpt08iXtdh_nqRR5TGzGTdHzGZWYayC7t6V1O49w@mail.gmail.com>
 <c4eab53b-c54d-4f1e-a4ff-8d86b8d32503@kernel.org>
 <CAJuCfpE6WSWPyZMheF4b=2mrwx7bPP3JUe9Pwp6QAswSMF4GyQ@mail.gmail.com>
 <9a139365-28e6-4f1e-b35b-7f6091e9aa14@kernel.org>
Content-Language: en-US
In-Reply-To: <9a139365-28e6-4f1e-b35b-7f6091e9aa14@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Kwww120eW5YN9o9Iu8Wli0oM"
X-Rspam-User: 
X-Stat-Signature: m61965maudb6w7stzxw5aijnjcyfdecy
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BFF0E4000A
X-HE-Tag: 1782881640-849541
X-HE-Meta: U2FsdGVkX18BlvpPgyxvJOeKpATbQzsHp9OQTUvY2coEfdEtxX6siAmRnHRD5J03LFa36Wy2pM1aad83kgvEYKeTM5Bzjs50ULZ8PgyHvzLugV00zPEchutC/LBNPSf7RkIfmq40exnl2sQu3PvSjynEe6iw2PXF1W4qn56Zspu9d8RwPGw7cSAQ2k6IlPuSXohN5Mjad4wjU+MJ+kbj6GJ7Uh8m1Ap/CxDdU6YpDIsOa0PJsVMh4Sad3PZk1MzdztbZO81Yr9Z8NRoX0CeiVYm6T4o1AJ5G5BsQENrMfs5Zx03fNYWpdzlzTalKbD1+hnLoNK4R9+KTyEWlrHxQCMe22Ri+yhUBZ7LWZJQFXZl8hf1VTlJwYsBIKvCxOnc9xwJM0dXoOgERvFSkSN9vu97LeQECBz9IHuqBu84trvJRh34UN2mSPIr5XERgzcNg0WvWxH7jsUPFeoVut1C5g8p9QY0inyT2zYHR+P7XowK1NSHUVZNHB8wB8wAF36rkF11ePFIDDCxZYSQSspm5yvzSvhkYzhVxURsAduSjlytTOSfscuyPEX+G3KXzrEktRWdwt4FN8ZIxCvfQctmYKE/PDDCTd3rO8qi2sctUo1vDijZ6Dgu5N5w7yJrQsbY1FgGzwpwqPUIfuXLhOARfA8owLsWCWZ5taTTNEGK0etU+3Te/XTMWXhuX854pRGWXicsSpsCVdsqtioTM67QbTOpI6JtqtDHXfi6H1BtzoBKIg7VkuIkujzo4Nwf0c5o3y2dlVbNDlhWsuq2+hRu1lSPPUdhqEs6mTkC3lF0irJDHZ/JyDnnx8BV5UBD5q96ccdzNWh5Yq0n3FIMoDW1BQ2vBRVEe90RAn87iLPTk0P2wK6OTub3DKaIUHz16AEpVbcUZSD6ZD9XWIVJifD5VM9ULDGqgaGY2uAiWDaOlB61c+FEfQaRNPJCPb/uYir5wgf8qp/DZEt2hSzZKSeR
 +cPa62Hk
 ambzkdG34eyUIlHNdRcLUkug7rReTZckfJ3yFx7sGlgBAWoupsrEF6OiE21yUtsaIQ3tzdpdot1h4+0AAmsLMoPUqJbsini7riicS0RnSuhfdXx1evYcFgWrkhJtaZzCpOBC5i2d+4eHNrdHHSH6higjKvgjm9W3e3xZ5jTLGjJpeC1T3SxWeQ1bOS7VQZVFuG4cf/9+eX6HlYXWX0CGV3WxW7GNBMob2JO+rkQJ73ggrsavhfPcgDsCyyz5cOAS8Z5qdIkgWFizGESg4A/dM3uDy7UEgrrfmtNMZ3buDpKprjMMTazLqGbImbfIP+vonOWwTgg/Qd8dqQ3LG+ywAsZ6DNz775PL76TsqIgBvMZdQWYs9Kc6nzFlp5UbHSNgcdqYJNjn0Pf3DwhkWHX6e/ns19ldrjrTYtJS9dcxuZDee4oug4jFVVMriCNG0lciTPIeBrEsZLkGvl45KsX42ktuTXa1/90UxNGVd6R4wNXTL8JioslWEmS0qsj92zRVVkr1NnPv0pxLS5tS9LVjzH0CRgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Kwww120eW5YN9o9Iu8Wli0oM
Content-Type: multipart/mixed; boundary="------------gIXJXbeJJd2qmAqBY9E95a70";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Usama Arif <usama.arif@linux.dev>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Danielle Costantino <dcostantino@meta.com>, Kees Cook <kees@kernel.org>
Message-ID: <92bf5e21-690e-4a77-929e-5217e0d7cb0c@kernel.org>
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
References: <CAJuCfpFanDcpqq5B7eNZbw2HnWOXD-xzcnrdbz-e2gnSM2EYHA@mail.gmail.com>
 <eac2ed38-432a-4d95-8968-2663540d73d7@kernel.org>
 <CAJuCfpF78_5CjLsbJLte+B4MzfaSiAmyeH57VLhgLtj8AXD2NA@mail.gmail.com>
 <62969830-4b1f-483d-8fa9-9ce487568570@kernel.org>
 <CAJuCfpH8ZjBMaOmso=9gZNz=DK2ja5yMS+04OjTGHh5Uc7r0GQ@mail.gmail.com>
 <CAJuCfpFX_sMrcTad-QGJsCV=fNyMWF=Bi6XmoHRqEAzMbWNfdg@mail.gmail.com>
 <39a79576-dcae-4b66-9478-c81dfe676699@kernel.org>
 <CAJuCfpGRC7NPxcODUsb3YS5nV=qG+-SbSYj1Fwm-QPqgKSVWAA@mail.gmail.com>
 <c5c4208d-a6f0-413e-bad9-49be12f12d55@kernel.org>
 <5ebd3c4a-5c06-43b4-ab0a-7a8f0396c84c@kernel.org>
 <akPSjsbjl-UAcdI8@linux.dev>
 <CAJuCfpE4BwDpt08iXtdh_nqRR5TGzGTdHzGZWYayC7t6V1O49w@mail.gmail.com>
 <c4eab53b-c54d-4f1e-a4ff-8d86b8d32503@kernel.org>
 <CAJuCfpE6WSWPyZMheF4b=2mrwx7bPP3JUe9Pwp6QAswSMF4GyQ@mail.gmail.com>
 <9a139365-28e6-4f1e-b35b-7f6091e9aa14@kernel.org>
In-Reply-To: <9a139365-28e6-4f1e-b35b-7f6091e9aa14@kernel.org>

--------------gIXJXbeJJd2qmAqBY9E95a70
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/1/26 1:30 PM, Harry Yoo wrote:
> We can do that in pre-7.2 kernels, by teaching kmalloc_type() and
> kmalloc_slab() select the new KMALLOC_TYPE based on __GFP_NO_OBJ_EXT?
>=20
> e.g.) Select the new KMALLOC_TYPE when KMALLOC_NOT_NORMAL_BITS is not
> set AND __GFP_NO_OBJ_EXT is set.

Uh, this is bit subtle though.

In some cases  KMALLOC_DMA =3D=3D KMALLOC_NORMAL,
KMALLOC_CGROUP =3D=3D KMALLOC_NORMAL,
or KMALLOC_RECLAIM =3D=3D KMALLOC_NORMAL.

Just checking KMALLOC_NOT_NORMAL_BITS is misleading.

> This doesn't require kmem_buckets and should be much simpler.

--=20
Cheers,
Harry / Hyeonggon

--------------gIXJXbeJJd2qmAqBY9E95a70--

--------------Kwww120eW5YN9o9Iu8Wli0oM
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCakSdXgAKCRCGXBN6rc5S
1mR+AP9Xlm5j7mV0bXzXndD3BUVjxM5Q2kRZbrCfD/VvS8Ld4AEAxRCvXIFVvGM3
leoCa/1kGSjB2HI29YUbII181TMFBw8=
=xFlG
-----END PGP SIGNATURE-----

--------------Kwww120eW5YN9o9Iu8Wli0oM--


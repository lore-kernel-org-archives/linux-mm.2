Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D8FECD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 11:39:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02FE86B0341; Mon,  1 Jun 2026 07:39:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0077C6B0343; Mon,  1 Jun 2026 07:39:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E86F66B0344; Mon,  1 Jun 2026 07:39:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB8256B0341
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:39:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A873012065A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:39:51 +0000 (UTC)
X-FDA: 84831149382.09.F52C55F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 170A61C000A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:39:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fhQbD7Wt;
	spf=pass (imf18.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780313990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5MMXZTkE9Ksy8r/e1+0LdFptK92/DrsLI/CT08d5UQ8=;
	b=tPEo/LJd8NDIHDg4jnkRXUT9PRj1Ul6wGPtRxh+aJERQtgis8u5P7mueTMYQo1dUlxmpbq
	Yda18ULC/8o8hTiNMapmsQOiRkDg/osTrlI1+OJdjl5fWYxq8qQqt+E2kzyo9LoLCU657T
	v4ZQM3qrjY8qcRrPaHUgImc+uTVvHk4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fhQbD7Wt;
	spf=pass (imf18.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780313990; a=rsa-sha256;
	cv=none;
	b=8BFZ6ne8/s9Z541mzYJn6+wIgsO0lqejt5oEiHZB/ShLPIcPFbqIAKQTUjNYJsGkqolLLz
	DTayX2A4hyWKKgLVh0ovH/NMc+o5i1M+wdGRYTzrLV6axtO7kJYYFHi4C6DPZNOEkpYJQZ
	cyTkdfn4I8omvKAxoAvt+y9Y5p/DPTU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 787396001A;
	Mon,  1 Jun 2026 11:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E21B1F00893;
	Mon,  1 Jun 2026 11:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780313989;
	bh=5MMXZTkE9Ksy8r/e1+0LdFptK92/DrsLI/CT08d5UQ8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fhQbD7WtYmzfm3aO27P3MUdk1PYXtWtZRyjEbt1BF4stHyg0uRK+76axAKeOrgWDi
	 +MDRJzoDAjER/TkerBiZ6pMsxnVf+EI5Sbm6Cq3INBW+ZBsyIzYpL3iBZYgt1lB4+u
	 HjQ+nGLuY8hFZur08h5UjnV+3mEoTJiHhdlZSr6qVL4bZzZhLX1zKwlGyj5QD1jic0
	 UkDzGkcO1Z5agDNQLNVSXMQoNuE17jqfJy33oa27Z1JSDerxJk1wpv48niFk3Df/7s
	 W/FrJHStGRgZmeMdYp1ZcncnjGDoCc6TCD43KfzJKdGvUYNlcBcSVthzLF9qDJG5Va
	 qQREa+iz/Gd9g==
Message-ID: <aad27c5f-01a6-4a2a-a55c-c7e411c4dd05@kernel.org>
Date: Mon, 1 Jun 2026 20:39:40 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mark Brown
 <broonie@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Jesper Dangaard Brouer <hawk@kernel.org>, linux-arm-msm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, io-uring@vger.kernel.org,
 kasan-dev@googlegroups.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Boris Brezillon <boris.brezillon@collabora.com>
References: <20260528093437.2519248-1-hch@lst.de>
 <20260528093437.2519248-2-hch@lst.de>
 <5f7f90d8-cb32-4ffb-8f1c-0722aafbe869@kernel.org>
 <20260529135045.GA10647@lst.de>
 <5f3ba603-a6ad-4cf2-9a54-aebc10273c59@kernel.org>
 <58cc76e7-2348-443d-a989-2a06e61178af@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <58cc76e7-2348-443d-a989-2a06e61178af@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------YwQVGEEKxGzkrAPA10HjJL0h"
X-Rspamd-Server: rspam12
X-Stat-Signature: 6xmyzscud4iig17apxe3kdj7qkqqupjo
X-Rspam-User: 
X-Rspamd-Queue-Id: 170A61C000A
X-HE-Tag: 1780313989-388655
X-HE-Meta: U2FsdGVkX1+hCQln0Bc6Kqsqgec+GV1QjcDcrSw84F9ixvAaZqGd54QFr9xG9Z+HcubQ2eyQ5tby3420nT5hTbPCYEsIWjL4yv4p7Ij2nUu9ea/6LmXBO6pcmWCkY/2nHl4IEBQpoAjlaVvk09NR4xciqg63ojAxkCyclLG6H5sEJ+Q8zmjzsdk5Sgee4/d/ntlN9/kymRUmzdC4YbxyYhaYvMf8sfnZUtmUh8xgJdH+CX0b2TJtT0jePGpa5vtcVsQpcKSJxe0hvmgtOVaCW7XFSV5ou9IoUe+5JJbNottTkYRPTGe4NnlhT/MCTeiglf9T7gNc/7fm31wKF61L6gzo6ogUi71pGzyZ1x2ncmcD6wPLMzWBeUOwvOd7smGGzFYwzAnUVhAZbCxkVGkhrxq7ijFygNQxwNufaVJ2+cdfWGrv3ncIC2In2tZthbObsfPBQOWWpH53ixSrZ6T6+OkgCD2Kk1aUzECmFmsUPN1bzYZceYJ3n3CTaoZE8Tqj3Cyxh2HBVDFdz5y6yFCnOLivX4Hd/hM5ACYoDIRgSFFG0kTKR+1zgBm7ZitzPnH15pSCgnasVbFlCYh6uGtiNWagY+OaezqCAnADmrL1kJLTxleA41qrLbbvEbiKF/J/H8QgXmScRP/o324EqCzumwuV1cMpSuB2RV1NETfgdoQ74bYQRxwXFv9DLa0MXvNzADtTG+J4ZAuiCk1dVJ6+1akgKNIyPjryBSy6RgsEzNi3OtxI3n5MAtpWzH3sDz67expmC8TVORlAPBJL6DV6Xr8i1hlE1uHMRUfs49r+jejG6jnzSD7LIDM1Y6lrTYDRnQ2tVgNPtoyG+U9jWOJGbIl2Zwdp/5H0Vz2qNhjr0/89bIpVUOAxFiPyM3R+Fimiffo/GK03Vxa7gpf1rIH47XcCG4sV0+hMDivj3Jvrj5694Bi6+t5ss6A7g4Rvo8pIv3d5AJsb3KJx54emRZr
 zUBFkd+K
 5DQ7RWU4c/MTyxQbA1v9kpN9Tnh0c2R36Z0lldrX9fFx7vagTADHTKeutJNuyui90iEjiYFBaTDhG1vT+SAkzQc8PcJoY0vrI+Qfv7dUcKInN/xLosBRKMNng+PsNGEa51BezX5ahWhifIQUBuou4xnlD/xsQdMxsoy2t1W4HkmKf/etHcCeqZIa4iRFqYoDfCCGR26k26RRkaWsa5P2RPh606nY+nI2xEVhXIl+ye8Ab10PNLVQNpg9BQuZjPbJWburVSiC2hiMaGquwUGDpxpP9Q6zCdLOJPoH7SfftqIcjiJ84hyGU/ejVRc103IG9eHWYm0xA+dCzLNexIRoSoHbDsxechSaSLYxcW3ZGz4vxe4KV9/DtfDxM0qVPd9PQaMtO4Ropl5aF2KDjzonaFE2FOvaD/YGO/Yah0i6mD5xxw9GITmpT0nbAdAkiLQW+TTAXwvnRJ8v6q2BWA0nlboaf/W0BXsx1L3bq49dUk4QZFJeBCyf4ab5GyhiNeQ9T92AnSkKpkcOwuB66TZa5kqNYWM1d3d6fSu2P56IkXRGmAWmgAfRvymALFwIrF5d0FAyFhj0MWRD6dRK/OhvmK6MHgx2QJ+SC11IA4GmXZDfGi/BLRXCJp5ehDleZO+OL5c8yOg1FsI84zTUoSFl0QNERaeNFXNtFJv8t9+2mziHp6QQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------YwQVGEEKxGzkrAPA10HjJL0h
Content-Type: multipart/mixed; boundary="------------Fos0wBgvdCggrd0C0H32WobZ";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mark Brown
 <broonie@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Jesper Dangaard Brouer <hawk@kernel.org>, linux-arm-msm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, io-uring@vger.kernel.org,
 kasan-dev@googlegroups.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Boris Brezillon <boris.brezillon@collabora.com>
Message-ID: <aad27c5f-01a6-4a2a-a55c-c7e411c4dd05@kernel.org>
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
References: <20260528093437.2519248-1-hch@lst.de>
 <20260528093437.2519248-2-hch@lst.de>
 <5f7f90d8-cb32-4ffb-8f1c-0722aafbe869@kernel.org>
 <20260529135045.GA10647@lst.de>
 <5f3ba603-a6ad-4cf2-9a54-aebc10273c59@kernel.org>
 <58cc76e7-2348-443d-a989-2a06e61178af@kernel.org>
In-Reply-To: <58cc76e7-2348-443d-a989-2a06e61178af@kernel.org>

--------------Fos0wBgvdCggrd0C0H32WobZ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/1/26 5:16 PM, Vlastimil Babka (SUSE) wrote:
> On 6/1/26 08:39, Harry Yoo wrote:
>>
>>
>> On 5/29/26 10:50 PM, Christoph Hellwig wrote:
>>> On Fri, May 29, 2026 at 01:54:48PM +0200, Vlastimil Babka (SUSE) wrot=
e:
>>>> Thanks, I applied it to slab/for-7.2/alloc_bulk and merged to slab/f=
or-next
>>>> (it's still yankable in case of issues)
>>>>
>>>> Did some fixups below (the comment was stale prior to the patch; res=
tored
>>>> unlikely(), simplified one line).
>>>>
>>>> A test merge into yesterday's -next found a conflict in drivers/gpu/=
drm/
>>>> panthor/panthor_mmu.c. Commit 1013bf53650e ("drm/panthor: Split
>>>> panthor_vm_prepare_map_op_ctx() to prepare for reclaim") moved the c=
hanged
>>>> codeto a new function panthor_vm_op_ctx_prealloc_pts().
>>>> But it's solvable so no need for a complicated coordination I think.=

>>>
>>> Ok, thanks.  The two Sashiko complains also look like they had merrit=
s,
>>> but I won't get to looking into them until Monday.
>> The review:
>> https://sashiko.dev/#/patchset/20260528093437.2519248-2-hch%40lst.de
>>
>> So there is a user who might call kmem_cache_alloc_bulk() with size =3D=
 0
>=20
> I don't know if it can really happen there, but maybe DRM folks can tel=
l us.

Yeah beyond my area :)

>> (although the comment says @size must be larger than 0!) and
>=20
> The comment is however new, the caller existed when there was no commen=
t and
> the return value 0 when asked for 0 was working there.

Haha, you're right. Didn't notice that...

>> kmem_cache_alloc_bulk() returning 0 was considered a success in that c=
ase.
>>
>> Either fixing kmem_cache_alloc_bulk() (and the comment) or fixing the
>> user sounds fine to me.
>=20
> Would it be wrong if we just returned true for size of 0? Would somethi=
ng
> else break?

I think it won't break as nobody should be accessing an array of size 0,
and it matches the previous behavior.

--=20
Cheers,
Harry / Hyeonggon


--------------Fos0wBgvdCggrd0C0H32WobZ--

--------------YwQVGEEKxGzkrAPA10HjJL0h
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCah1vfAAKCRCGXBN6rc5S
1n8cAQCqp4CsOu+ZPkt9JTKGMEjAbun8lhAPjYEe5ZxQbjlUnQD/Yqc0JkpGdJ3B
cq4AV3Pw4qMLNMrm3+rVRHMdUu9OmQ0=
=RNAw
-----END PGP SIGNATURE-----

--------------YwQVGEEKxGzkrAPA10HjJL0h--


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51661CD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 06:39:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B4D76B028D; Mon,  1 Jun 2026 02:39:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 965D96B028F; Mon,  1 Jun 2026 02:39:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87C516B0290; Mon,  1 Jun 2026 02:39:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A6726B028D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:39:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B23E8F24B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:39:17 +0000 (UTC)
X-FDA: 84830391954.27.5F77F6A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 77B934000C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:39:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=deU2ejyR;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780295955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rKk6j/n9sj1IniX/7VKjNeDlTH/D2W3IN/BVvbihauI=;
	b=C3sD7/q9pqLgirSpYOi4zIlKZpeLMjhoflVkRUDuKoT5qL/bDOYqNvtpRdljDut7kTsI8s
	lzZO+KeQKZ7btSTUbPSx4NIEfG5hX8L5z8VzRlhV33uAlPn9otKVreilXgnQ9/vafQJrwu
	cTvuxhxEv71ohuO68lAjMSpcV3m0JR0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=deU2ejyR;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780295955; a=rsa-sha256;
	cv=none;
	b=An5s/z7NqjeHFba6w9s40efphkl1oMxculegiw6JyQg6L3Yz5mXyZc8pn5xoQr0xE0TjDc
	F7/hE+uIhTmzpyeS697wFRlJNV156sOVr0OP10HupQp1Qfs189hsPdrelOFaptSW6WwNCu
	t1hbn6YXo4sV412nMOmTzKz8QNuPH0Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C506F60018;
	Mon,  1 Jun 2026 06:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03E81F00893;
	Mon,  1 Jun 2026 06:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780295954;
	bh=rKk6j/n9sj1IniX/7VKjNeDlTH/D2W3IN/BVvbihauI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=deU2ejyRoOMJVQywPOlLu1PqH70E+zWfsku4xW3ejYZB8yKEwCBukyd+rzzgKkdmf
	 vGfMeLir+q2+YLlqYJ/AzObbKzdRw866F6HyGjCNfk4XHBFW0DBz7SfQREAKIrqTih
	 eBi6cugoUG+CYfTUshTd0CccN+PQjgSzwSv7queVBc6p52Wolbj/6fOndd0MpYLxG2
	 cWd4oZ+vbxMMcHUxBTZyTjrMsQm3x2s3VngOun20ayrnEQkV5sF8YIYLuI3Ny72DXa
	 BZJwi4+K5b9H+0C3rpQ6FfqPHiUwR1FUO2dIJha1fHRhWnIHL6s3QX/hRpXpWMsXxA
	 Afp4/cf9Y5iIg==
Message-ID: <5f3ba603-a6ad-4cf2-9a54-aebc10273c59@kernel.org>
Date: Mon, 1 Jun 2026 15:39:06 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
To: Christoph Hellwig <hch@lst.de>, "Vlastimil Babka (SUSE)"
 <vbabka@kernel.org>
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
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260529135045.GA10647@lst.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------HMU1xMsen67VgPzLuGJEEdMK"
X-Stat-Signature: 9xh7kf3rroy746hzsqxcs756urqsksyy
X-Rspamd-Queue-Id: 77B934000C
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780295955-520530
X-HE-Meta: U2FsdGVkX1/hZEDqIOEPf4bz07JnenCELJnSSk+BrktBnb9VuTAxErEE6XBy7q4mKQKDyyfk8Jzj7uBXGA9XgxU07n7GUhubklc1N37/Pjfu8miIJYgZLDYEWxtkUGlKXqh/Q6rkobPdrOjAAxTf1TjsKa1RCjVQIJ0ulHLmgng8zlwJ9H2HxyA2WMN1MuaJkuCWQ7qsEtly4q/+avBgrC7x9RQUwN95LMlhjKpnsTbW7ujDeWlZNiG83a8sjwurPGeC971aawRDlrLpeIbR4tpbSi6Sh8FaWILsvBn5suT07Tf4xWTVjOsOLNNktFEsXu1dLhLkAEEDeR/Xr4xfy649fFFsH3/aFts/uqE3edhUmoKHWMwMKGBS0XHihq3iXDBWkfX2zjVloKrNjNTNSo4D1bFfqjHi4GJe/m1/4+ohK+vTQrkfYSqzi6jLIgJAoPsnKoHrFULtCfyKP+EwUX09Bw8JNHV0oklxtfj6zXuI3A8Xqi/Ai4oWclBtCEjuepjQk/nriUJiq0Nf/wifGZgU/mKKDozajVaSN3Gd3QmBDizoFUszqZsRirIsgeZQUzh6Q+MkYbr66t+NfxtyfsAYvwzHT6Ers2f8JooiUGF07jDplXMffOcLzgDzt0c//pl4AKOl5qX6uEWS7WJvVxZjaZNhaPJB3jC3L4qTvRF9MOcfJNykTcxM1b/LWlMEafg6W33+6AIT080VUb7SYrUbcgEfs8H5jqFPlPI353LOZEnIR8MWhWdlvrNAZrkeFmC8Hlo1VsTNYXTyWWG0ZfbV04xA150aafiAyCz3zKnH5bc0aLxmDg78+xqcyQQMXrGNZEXYib1U0uYCsrO8cm70jS+D0Kip+cjaf9mNzTTXDRQ6MUtss466EWXggq7Obmp9re3tZ0wydqMoy3QNHoGb+sHUt2bL9Wz1AT15DcdUBN0CkD9MTa2ykHYWHxjMARVYET9vU+lUzNvIqx8
 gYFmfVer
 Ibvec79XgAaW035xh5+SoU6+4sqjDixPIQFpyrc5kM6pLzPUX/L0Ztr42d+bGe+dLc2urNz2KuBBn95B9xlRtuYNbedKUYXpmFKpNvEUC1Y9a0S9mL3k49mGc2raqCSpz5ztqM7UC6Icxx5RmGMQZUOV5lcRgCa+Wn/JL1VxHXvOaaTL2KiCXA3jnFq1CgFs/Kq1JM3lvTA0RlGYjHsvSrgDYCX7opfxEbmEdc6Dzsueae40QWiJuNlvJQEAEg7wfYTuyAlugrnCMXoO7fnJFMLGmKrnvVtamHj63Z6Opdxiy5iUD0Q4NdWc40x39/jxJQBr1o+ADzr7908/xPJDLR7N1ASHJcSbUU7/S4hkepQpMBAsvlGkvx8BdZdwmrnrFgZA+m1I8add4Uald2EebcLgMiRcUkVUnGyB/97oSxqhkG6nb/hCdYZ2Zy4l4znDXfmqVpoYLLkx9jcViUjbGEJM+/Z5bUhlQCx4059ywSf8Gw6YU4LJDTK+ohYDdHvlFhNnOm+4s05vRWwAAhPrsQnBJnK38UQabBD2rvxNnOSrZHw1R/PHsfrd8/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------HMU1xMsen67VgPzLuGJEEdMK
Content-Type: multipart/mixed; boundary="------------ub6P4aBhniaWwf9dwX4fSUIh";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Christoph Hellwig <hch@lst.de>, "Vlastimil Babka (SUSE)"
 <vbabka@kernel.org>
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
Message-ID: <5f3ba603-a6ad-4cf2-9a54-aebc10273c59@kernel.org>
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
References: <20260528093437.2519248-1-hch@lst.de>
 <20260528093437.2519248-2-hch@lst.de>
 <5f7f90d8-cb32-4ffb-8f1c-0722aafbe869@kernel.org>
 <20260529135045.GA10647@lst.de>
In-Reply-To: <20260529135045.GA10647@lst.de>

--------------ub6P4aBhniaWwf9dwX4fSUIh
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 5/29/26 10:50 PM, Christoph Hellwig wrote:
> On Fri, May 29, 2026 at 01:54:48PM +0200, Vlastimil Babka (SUSE) wrote:=

>> Thanks, I applied it to slab/for-7.2/alloc_bulk and merged to slab/for=
-next
>> (it's still yankable in case of issues)
>>
>> Did some fixups below (the comment was stale prior to the patch; resto=
red
>> unlikely(), simplified one line).
>>
>> A test merge into yesterday's -next found a conflict in drivers/gpu/dr=
m/
>> panthor/panthor_mmu.c. Commit 1013bf53650e ("drm/panthor: Split
>> panthor_vm_prepare_map_op_ctx() to prepare for reclaim") moved the cha=
nged
>> codeto a new function panthor_vm_op_ctx_prealloc_pts().
>> But it's solvable so no need for a complicated coordination I think.
>=20
> Ok, thanks.  The two Sashiko complains also look like they had merrits,=

> but I won't get to looking into them until Monday.
The review:
https://sashiko.dev/#/patchset/20260528093437.2519248-2-hch%40lst.de

So there is a user who might call kmem_cache_alloc_bulk() with size =3D 0=

(although the comment says @size must be larger than 0!) and
kmem_cache_alloc_bulk() returning 0 was considered a success in that case=
=2E

Either fixing kmem_cache_alloc_bulk() (and the comment) or fixing the
user sounds fine to me.

And yeah freeing an object via kfree() allocated via kvmalloc is a bug...=


--=20
Cheers,
Harry / Hyeonggon


--------------ub6P4aBhniaWwf9dwX4fSUIh--

--------------HMU1xMsen67VgPzLuGJEEdMK
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCah0pCgAKCRCGXBN6rc5S
1rmyAP4xYSWajEqm+MA0a6gB0YMw8PYGMERv/Liiv8qq9FfVwQEA0LaAVOUS0vOJ
pFwKYpvxOLNGK+0ssT0N7hdbranbAAA=
=ebwI
-----END PGP SIGNATURE-----

--------------HMU1xMsen67VgPzLuGJEEdMK--


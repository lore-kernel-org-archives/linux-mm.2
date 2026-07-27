Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55A72C531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 05:41:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F62E6B0088; Mon, 27 Jul 2026 01:41:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A7B16B008A; Mon, 27 Jul 2026 01:41:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED8046B008C; Mon, 27 Jul 2026 01:41:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA7606B0088
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 01:41:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5E0131A064F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 05:41:29 +0000 (UTC)
X-FDA: 85033459098.08.8471E8A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id A8AD720005
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 05:41:27 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CckjAe+u;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785130887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KBGxVKBVcPUvP2K8Kq2m/WESxz8RXhfqZ6Mnq5IoEO4=;
	b=in5Wyq1efvSVSfPcNVbzykQ2xVj6gvc3SxM2FQm4qlsGlEhSGXd/bivKjefKy1Sj6snTSx
	YV5d1n5LXS/EyejLqJojdD1mphHYnSYpMDtxBrtz/O5RIXroaXYvscK6enklV0+6MTmuxH
	9BvAa1RZQ9dfVhBFE7qku+RRksokfXM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CckjAe+u;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785130887;
	b=tZ8+6UCHUR8QtO0vb40dz6mjid1SYGxj95d3BVkysGhWVjF+ZzsMhhgNoczglb0hf0UMjr
	v4uzq9MzTiqEI/857iNcyKzmdEY0GUyZzCQ2XHYMevB3YAJAZ2sb3fA5QDGMEIkiKtB5Ma
	/IUIbE6w7itz3n9iKLb6slah12ZgQ/w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 72CC1416CC;
	Mon, 27 Jul 2026 05:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3345C1F00A3A;
	Mon, 27 Jul 2026 05:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785130886;
	bh=KBGxVKBVcPUvP2K8Kq2m/WESxz8RXhfqZ6Mnq5IoEO4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CckjAe+u8aiFdiwdleeGwEQnEKVUjrWDcX6k3I3hMQkAvD/E6HfuB18CvzHDfuZzz
	 idU7A9Z7y6qZNj9IWcFBzLD2rMv8kUbRNhhkgkKHcEjx1Bv52UG8RSIVwcTj3IfHPs
	 zEe2fVv0Hv9fuoKUlUr5M8rQ8zqWioNndRBmaL/RQnqXQV06Q1g7MSka9/ljLUYB82
	 6qHZIVFNsJwpAaoRlPiNOFv96kUqkNo9w3aP5h0VcQvwxXka0wP6C0RE57Vd+Iw8Oj
	 Iaqn5NMjKrSxKNEMxBGwTeyOqP1ct0PWxOxwTUrutpaLFo7cFpV/f8g89eogppZ209
	 nlbm5Wdef5Kdg==
Message-ID: <89662cae-b3d9-4aa4-a7fa-cf5931781dbc@kernel.org>
Date: Mon, 27 Jul 2026 14:41:20 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/13] mm/slab: change struct slabobj_ext to a union
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-9-2fa7c6f60dbe@kernel.org>
 <amGEY5w-cBm4_uhx@fedora> <9b2dadb7-8e3d-4b9b-a870-969be9a7a432@kernel.org>
 <amHkbJsvOjcfUR3D@fedora> <e3f283e3-27a4-4e3e-bc4c-39fafbcfe1ee@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <e3f283e3-27a4-4e3e-bc4c-39fafbcfe1ee@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Mgwd0Ze9mOCZYycSnvRZAlba"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A8AD720005
X-Stat-Signature: f1rr5ma1mk7rfi517xtf7cej9633fxxe
X-HE-Tag: 1785130887-474363
X-HE-Meta: U2FsdGVkX1/Stsv6bfvrPsHF/FNcNLVYTMAJYXmkkGXoU6LwzyOuBS2n/mUBBC6rQ2wXfOolhMt3H8ce2rwbU7NU8LU2cxoyOVR5fQgxJL3LDYQDKW5Ods+CyEqTCBI1hRRjQWfHfqo3lgrSglCjITbKeHGJPvyNbsWhk2J0yZtDB8VrtJeiAm1RC+J4f94jvJruqy/z/IoK0l5ClTgK2kr3rMogKKRFCIa1miiDgYFa3QkCPTE0J0TKmyjvuJVekerUMgoja5UEvMRqwmUzWe8T/U6AIbB/mDpFlm3D87XtYzgoqmH1MMEJkxv4m0LwY93KGQs0QKfIDAMRb5jz+VYWqODZxImGtUoXqDdinmcWNeeqMEvmlNkofQ/mRpOMWYgpUWD0S2q0fkRTwDv4oPArYY15w2omoyCNk0GfibGAHhDydH9ODAaEMx+QT6aRWtiZjdMCoI1vTx6V78vyLI+pudCenbnh9C8vGKFITSi4wiaMCJ2KRwKXvx6WdAmS+tpzsk0t+gbCYe0E0xQv2qWjYkuO9D2m7A8nj4a5RvRjlDjvU5XqDljJ252bpd3iXdAb1LM6N81Xk/6FM79EkMuQgZgsLOeSiAE90T3oENEPGS79h/+agRdVg8xj/9CuvEIeQqLoMhZA7MO8Skk+WZFOiEUOvKys3DutCxIl+tR16e/xvQZCTOIJZYTVp5UoZtOmSQY5p0a9QTASH3FrR8tNleKhJiFyFkimvrvukn+wnz9a/whorgXehB8dx2jMgR8nn3eP9GbTubOH88G8wq92n0f0DWxxpz8xNCvc+BV4GeKw5vutzg/MphgUFfN0oNoXLXe4MqENpxPO50RyZLqofZpIgVT2llNE77TmU5xob8l9BEgdYxBx5/hBmyp9gitgwaEN0xbsKcWVthD77GbG058f2icVRbGzVAmaSyo5Ot9NksyuIJ7V3uqkB7MRg1SEiQvAUwbkMWXSQfx
 c+vF7e1+
 vjhI7AWFSUzyOHTzQ6t8fAhfl3myPFP0dDuel7ru2k8/94CAJbYuv1Dy05UC4GJwedNvba+4MeIMwbiTxj7pUF64t+WasJBSp+NRSOsELLd/YFz4DbHfjroq3J6vCDKVZPHoVfnMiOkxZ/v0L0t4GZbblsmLwbPg5GKu7B87e32JfGNFCKA+CNSvbRujU2hcUs6s9oh0p8UFPG0jXuefGG6jyvOwGkcITVKPndcLxVGSVby02ThcjzXyG6MCP+mpN9mzGKxlDq1pKiNjZ65DzXqQgcHnxwSgUVEF88vZZvAqA3g5a5kJaMDC7nMjuFqVb1MG4mhJNqaj+dIUVmhK/qUDK7bTYewZUbhhLlDYelWo1GjLr6KwzxDxzsrnEYAbW705AZn1jSGOyXSUJegv/GFZGNMMOVK7wUK6/pn/Meas/UMdESYsATdnrUZRCBBPg+P0N79rHWQ/HyKyj6lZnS9PuDwcNfSJsPmV38QtVQRqnCE+cVwTTDt2P5UKEyvMenT5c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Mgwd0Ze9mOCZYycSnvRZAlba
Content-Type: multipart/mixed; boundary="------------xEDZ3aIuuqtyEFJe6gHUB0km";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Message-ID: <89662cae-b3d9-4aa4-a7fa-cf5931781dbc@kernel.org>
Subject: Re: [PATCH v2 09/13] mm/slab: change struct slabobj_ext to a union
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-9-2fa7c6f60dbe@kernel.org>
 <amGEY5w-cBm4_uhx@fedora> <9b2dadb7-8e3d-4b9b-a870-969be9a7a432@kernel.org>
 <amHkbJsvOjcfUR3D@fedora> <e3f283e3-27a4-4e3e-bc4c-39fafbcfe1ee@kernel.org>
In-Reply-To: <e3f283e3-27a4-4e3e-bc4c-39fafbcfe1ee@kernel.org>

--------------xEDZ3aIuuqtyEFJe6gHUB0km
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/25/26 12:42 AM, Vlastimil Babka (SUSE) wrote:
> On 7/23/26 11:56, Hao Li wrote:
>> On Thu, Jul 23, 2026 at 03:27:51PM +0900, Harry Yoo wrote:
>>>
>>> and drop OBJEXT_FLAG_UNUSED.
>>
>> Yes, this idea is insightful and I think it may need a standalone patc=
h without
>> blocking current patchset.
>>
>>>
>>> ...not sure how much we care about this on 32bit though.
>>
>> Yeah, 32bit is a rare arch today :)
>=20
> Agreed with you both. Let's deal with it later.

Sounds reasonable.

> Also AFAICS the memory was already wasted on 32bit prior this series wh=
en
> e.g. CONFIG_MEM_ALLOC_PROFILING was disabled, so there was just 4-byte =
objcg
> pointer in 8-byte aligned slabobj_ext, right?

Right.

--=20
Cheers,
Harry / Hyeonggon


--------------xEDZ3aIuuqtyEFJe6gHUB0km--

--------------Mgwd0Ze9mOCZYycSnvRZAlba
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCambvgAAKCRCGXBN6rc5S
1i+uAP4zMR6KAfExVASA33SIec4hOe1qPSAA+y6SvbztDbmuwwD+O9oxG/LJahjB
u7CQFZJxg9HPyZTA9A2Q25sRF9mC3QA=
=RYZd
-----END PGP SIGNATURE-----

--------------Mgwd0Ze9mOCZYycSnvRZAlba--


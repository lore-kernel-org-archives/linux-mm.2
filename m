Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E87AB606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 21:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OYbJi1EW
Received: by kanga.kvack.org (Postfix)
	id CCE666B05B4; Thu, 29 Oct 2026 17:19:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA61A6B05B5; Thu, 29 Oct 2026 17:19:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE5876B05B8; Thu, 29 Oct 2026 17:19:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B6A66B05B4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:19:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E32C51C3D37
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:19:44 +0000 (UTC)
X-FDA: 85376930688.15.5B505EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4F64280004
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:19:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OYbJi1EW;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793308783;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HjsqR9zZCoxnziF+YFPgg9BG5681YaNVPhEjBVz085g=;
	b=k8+TXuVgrmXXBnVSejthiVm+I4D0FYUrfE4i0F/DkIcbRRkn0p9GJNBn2LUPPl7U3XSpU0
	akqJNjIN8X/PYLrP/aTu20eULoG/UL1a+6H8Eh8i/b+U3F/v8y1ZCxtH4uQ3Iawv4/CReQ
	8Dldtak3IJDXr/AqIa+HstyYevR6Rx8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793308783;
	b=SjZKhvyDC25pgTnfHwgAxa68BJ+560OKQM3JXXOEpwyoY8N18YxW/K8tJ8Xgy74pyCrjCr
	Nl0WQpA5PpdXhdhGXQE7QbjxsVaGEJDi9deABEBsHeCKcnshz1377Oe8nJ4l3ugl2eQRy8
	YL7836KznF+3ZXixj7Jl/NuxEXoi8DU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OYbJi1EW;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 64B58605C4;
	Thu, 29 Oct 2026 21:19:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E3B1F01816;
	Thu, 29 Oct 2026 21:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793308782;
	bh=HjsqR9zZCoxnziF+YFPgg9BG5681YaNVPhEjBVz085g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OYbJi1EWZrrcqWiFG+qDi2Tu4vifUkyETNVIpfnlriTix94hdKrA04vHQqF5zxhSz
	 A5vWXwGji3bcNB2tKxk5EjVYHjNLUCxgvquc2KrghBksGVnJ606sJrNDtqgy9EooK7
	 PERdGDvd0gF57hi0kB5PCPVUfK0rBiSbnzJysYrtwjrD7TCCO+Ev/VGXZrAmE0njjR
	 OZ8y1/vqgTXD7OerJo/d+/w1N6uEcTuvGuYs1Cxb72Y2nRDR3vjTwyXhjp5+30e0JL
	 f8/XnTqrvZZaQHOCYH7RmtfozXxmcCIdnoONQX4i97y29Da5cIG9PuS/t+UWyg43yf
	 flg7RcBRKbTPA==
Message-ID: <sashiko-outbox-189948@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 8/8] mm/mempolicy: read the zoneref slot once in
 mempolicy_slab_node()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?R3JlZ29yeSBQcmljZSAoTWV0YSk=?= <gourry@gourry.net>, linux-mm@kvack.org
Cc: kernel-team@meta.com, muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, akpm@linux-foundation.org, ziy@nvidia.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org, mgorman@techsingularity.net, anshuman.khandual@arm.com
In-Reply-To: <20261028211930.3504634-9-gourry@gourry.net>
References: <20261028211930.3504634-1-gourry@gourry.net>
 <20261028211930.3504634-9-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 21:19:40 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4F64280004
X-Stat-Signature: mwpn5kqizaw6mpn85b1p8sxq8tbfmjab
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793308783-20870
X-HE-Meta: U2FsdGVkX1+D0/pZ+XaTTGoCH/LM5ZrLoS7fOjU9m+Id9Ow9YSD923g93auamGxf4QvGHrXlpE8pywfhX4a7BARhDiivBXOiCYRpBUCuh6P0StmPW2ZWkCK4FDK/nl7syPLx4Fl3TRwHVo9LRnjFoD3DTrDGBzFSBS4EtpLlBpz5/YK0INIjhfiE7RWmLJFUenzakBdrmm//g68k8DXZrx8TrMsqva9fTZ5KGSpzmS9ZkIfpskrAF6/BvoIJTiJoJ3mnQ6nguCGD6NfiCVU6Q1aLp6sgVQiyhdr15coe7k151kqCLEFUvbSouJGyxC0kPFzU2xxsnMSU7ts6uzOUrEVwuTTVh88iOhhJ49PWo2bJSKiEbFTqMXHGc0kkU18MSK9D0vM00qFpa6o4f1PEoygW2FxeTZb0ADdgVP4v4ZjkIUgNHpkEJF2zrdPPakIurueyZnaZsKq1lvYdiuUEoCzST6avuwAcoHMOcnYdccJ8eB/1SNDRVq+hxvN0ZfX1sBkHI9l4/YDOSeDkqVtccMAvPgfhAAxJ64exOxJbqYdGXJxKcu2b4c3IwneqJc+nSOXiNDLm2VQqnLKjnhloGyLy+XWpcmWhA6t/lYKPf3UIwvZZlgN+ASa5670HEb9+EvEyVxIXfKqfcgvecVShDXGqx4LQ6IkOJKRL2prLIgIR3tyx7C8alB8j+2UGGhznG7xjV01FE5s6GDLsc3ozW6/BdtJqkMd8l3Zw67XpXvVrhz3aKdSfV31m44JiWjYLVCyAFYriiq0QXt9JPfMiUByiok/iFiRnpVhLRYyPjt5lh6lz4dQslHv/wpIsM5kLcp7NQZ1QyzDZMyzKo8J17/YjFLt3E5bMy6788SlsAJcI3eTkZtRJZrF8Dr8CoU8fvuOkD5xHj+E22MZfQHN4ZOy6BnYSM4ktOJn8jdtAdxhTu89QqWuxGW8j6S7yS2GdaCY/3hPsWfnRJZO2tju
 nqTGjn4E
 QIeHn2sayHd6GYVFQ0RjgByQNjYJL/xPKWZyg86kzQoy+uWnTV3vCtfPYZBfkeLWSvdhau8poOZxx74nmQn47SAOz5KP6OTHEYBGdaM4LlhMPt90Ejd7Rs2IyBiVIO6f9Uw8ihEEb7i3c2B6dIiWH24WX5shhTmNWVgf0/cY1Whgc1bP1VksoTpkVxBiFc4KnkYdiI+OmTYmJh5fmW72v+Ocdqf9mpEPvvMieBJ3ubSzEnITK7iYsCcwVxpFQhrnctZKzoWsXG0X7IzaSICKBs5JLdgaIU2UG33Q+w7ejAdA6f7x/0iLdyhUpG8EbLsW7UAU0OR9IVUWKhnEZ9JNPWTQUj+3C/bkSP70N+YmpyPZ28XvmNGNa8ClE1v5ndzr6uQY2lbi8n2Txs7de3Gm0v8VQnK2WYt14QolVATQvmjodp2Y46Iwd1NwOemTzg3q3c/e3rjsIeoi6OZPZAsfuvD5Dv/tpbQWsg9V040VqezAvXH58CmYxRNgvN00gBSZjunQHt3kd77jbuYTKi4dYx2ngZJU6xWneKr2nugDXN5hHgGhUMmLsGqHxq3iZwjcW7P5qdag6rMPXrR+8UdXVQ69MpNVzoP5sgB5ZgkX1D89pbYvZjr2826dFkMkYCgTjnUyynIwM24YOIukuzswzoCN97YeolzePNKTQKGtbDOmvZQJhfUUp/ZvKt1ioyzlTBlLkwqxo86t3XV5LHNj5SM0aQT9MbdOD2HDlOMkfWjSLgpsGfZk7l9uxMum7dPb7MhGSYImA9CFhYDNwD9w0rdOKQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm/mempolicy: missing READ_ONCE() on zoneref load in mempolicy_s=
lab_node()
--

commit 4beeef01124c3abac1f730eb599686961d03563c
Author: Gregory Price (Meta) <gourry@gourry.net>

mm/mempolicy: read the zoneref slot once in mempolicy_slab_node()

This commit updates mempolicy_slab_node() to store the zone pointer from
zonelist_zone(z) in a local variable before passing it to zone_to_nid(),
aiming to avoid reading the zoneref slot twice when zonelists are rebuilt in
place during memory offlining.

> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 0884c629670dd..cd63c3e2c029c 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2176,6 +2176,7 @@ unsigned int mempolicy_slab_node(void)
>  	case MPOL_PREFERRED_MANY:
>  	{
>  		struct zoneref *z;
> +		struct zone *zone;
> =20
>  		/*
>  		 * Follow bind policy behavior and start allocation at the
> @@ -2186,7 +2187,8 @@ unsigned int mempolicy_slab_node(void)
>  		zonelist =3D &NODE_DATA(node)->node_zonelists[ZONELIST_FALLBACK];
>  		z =3D first_zones_zonelist(zonelist, highest_zoneidx,
>  							&policy->nodes);
> -		return zonelist_zone(z) ? zonelist_node_idx(z) : node;
> +		zone =3D zonelist_zone(z);
> +		return zone ? zone_to_nid(zone) : node;

[Severity: Medium]
Does storing the result of zonelist_zone(z) in a local variable guarantee a
single load of z->zone without READ_ONCE()?

In include/linux/mmzone.h, both zonelist_zone() and zone_to_nid() are static
inline helpers performing plain C loads:

static inline struct zone *zonelist_zone(struct zoneref *zoneref)
{
	return zoneref->zone;
}

When a task with an MPOL_BIND or MPOL_PREFERRED_MANY mempolicy calls
kmem_cache_alloc_noprof() -> mempolicy_slab_node() concurrently with
offline_pages() -> build_all_zonelists() rewriting the zonelist in place,
inlining zonelist_zone() and zone_to_nid() lowers this to a plain load of
z->zone. Without READ_ONCE(), this remains an unmarked data race, and the
compiler is still permitted to reload z->zone from memory and pass NULL to
zone_to_nid().

Earlier commits in this series ("mm/page_alloc: snapshot the preferred zone
against shrink rebuilds" and "mm/mmzone: read each zoneref slot once when
filtering by nodemask") used READ_ONCE(ac->preferred_zoneref->zone) and
READ_ONCE(z->zone) to enforce a single load. Should mempolicy_slab_node()
(or zonelist_zone() itself) use READ_ONCE(z->zone) here as well?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028211930.3504=
634-1-gourry@gourry.net?part=3D8


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20FBBC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 10:02:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E961F6B00B4; Fri, 10 Jul 2026 06:02:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E46596B00B5; Fri, 10 Jul 2026 06:02:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5CD06B00B6; Fri, 10 Jul 2026 06:02:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A74426B00B4
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:02:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3D742A039A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:02:18 +0000 (UTC)
X-FDA: 84972426756.23.403DD67
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8F8CA1C0009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:02:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NStmKb/t";
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783677736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wd3z5gi9ZC47QyTFTl0PrNt/+R38+SG2Pwn5cKGSZoA=;
	b=Hm0igOfZ7N49zwvlheFKWiWsyWaG5X6UDdciQFeDcvOfgVgsfl6H4tyPBuJ0TJlckV6iWD
	bCl5M+LaOZsSS52eN4XnGc3vvvq+vtHEMSM9ofNp0KJgHWdUGQeLqG/L39Lqr9UCmaJMUS
	gElIebvwCOyZt099MpqANApq3TaWthU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NStmKb/t";
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783677736;
	b=NXmSzJWk+hu0eTskosOBjlPfwX7TqCAT3xlaRGuv+isd4qJArFJVbqVWUG/dhIeoCtnj/p
	xVCwq3U92YkoUUQ7uqesw7+PsQjUahyaMvQtss1B38HB+tkmmkNCPAF6gehYdB7MRg5/i0
	bOk0+smyJn1AkuzWIuWi2iQHBZHCqkU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D72A060051;
	Fri, 10 Jul 2026 10:02:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB50D1F000E9;
	Fri, 10 Jul 2026 10:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783677735;
	bh=Wd3z5gi9ZC47QyTFTl0PrNt/+R38+SG2Pwn5cKGSZoA=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=NStmKb/tZbEEPMPVygxPhonVPyi4RDn5Kix9Z4adjj21L9u7s9esvhbDWTiluRbL5
	 34bskCAwb7NWKzagyv3PRLwpCTl9Th8JsRM5b27bJkJYZAGXF3cmPeTr0L/V2DkO+A
	 1lS7CBGBF2XwBxyrU97dcS5JRonyJb1trEuhQ0dw6bulrZiFqXkmOAsY+QKW3jLbjq
	 MzQP+gGhvDaVAehKoZWp6nGf7KSwWBvD4S41VwKcBvoeF7QFc+6nXqbSWLqNKD4S2C
	 Cn3kF44klvJCdWtW6SVHjjrXh+VT+PJjUxBUCGHHlMCY0tkXGCpo+0DSiP3guF9PNk
	 XuF4RvjDnkr2w==
Message-ID: <5d1bb55e-7dad-4013-9c72-5a43051057d6@kernel.org>
Date: Fri, 10 Jul 2026 19:02:09 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Harry Yoo <harry@kernel.org>
Subject: Re: [PATCH] mm/slab: extract __free_to_pcs_batch() from
 free_to_pcs_bulk()
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Shengming Hu <hu.shengming@zte.com.cn>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260707-slab-simplify-bulk-pcs-v1-1-4850dbe0d904@kernel.org>
 <alB_hIJFVgFM3HxM@fedora> <alCAyjxEDM7PmsRy@fedora>
 <c7768cad-db55-48e6-afb8-5916c1a6f00d@kernel.org>
Content-Language: en-US
In-Reply-To: <c7768cad-db55-48e6-afb8-5916c1a6f00d@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------0iZRncWzsyBwJEE9LOW9wmSR"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8F8CA1C0009
X-Stat-Signature: x1yw4cxefmue8owfiama9ps9gxtud1q8
X-HE-Tag: 1783677736-777527
X-HE-Meta: U2FsdGVkX1+0ei9C9k3j55gFtmTDS6lt+HpcBm8C54Pwiai6/GS94hzmycW9uja8ldM7t380rbniws/LlRMVby7qBr+pLDxotFEYwpM2DrJUkj9ZhNOuAe2Q2kTotgh302vhIfHAkFx+yVqWQ4Ts4I8/+VZpPhJn7DA4CnAfMmDeAYO9TfIcAFTwWbj316Fy00FtzT2cLBq1ZvSGZAZuxgVySa0eYjSwn8saBcwQuWH2MdIDXJrQahLAjRdZzh93dZ6qVAXsOwJ24D9KPV0LZn7ogqTZ8sXuBlZXC3d2/SxB7tDPQTdj+EAfv2uDnGwMEhlXFP1YugyO/9q8vTlet64TghR7g0c5aVB4fjSYWhixH3/a+zkUlVRhe5MIk2wb+NT23fBCwU5yHIwjQegeOGQbp+N4XquRLzvQvx97OJl3VqGZmAcEjLx0d5GZOs8Y+zAhasS3T4wZm27a6QRcEF+X9JrZlWQwudkCgrAusNTA48ITy5xEMwgt7i5c6B19hVjBBcEmep8R04VroOgfukE589uZUngV56RfhKuy39yLLdv+60ralvihJV/rZY7wXsBucNFQJoOE09tv7W+HX/fd5VjAoJ/idP0jTO3EW7Kw5ne6ql29YTnQ0LgBYhaNf2z/9zKH0ZHUAPnpRVqND/F9J3XCF9okUay2Z01H1QgQAVVYxGaa8vg8/FnDAJX2gzui/3H1XJG1g3LPfrUSXfwuCiqVw1N8MkIoEAiGbfdzD91V5RZqKnc1Zbl+NSATuUV7sR928g3v4I8kvQ2EBe73Arb0epFqxVFhP4F6SgS3Al5vmK0HYrf0xJjalDk5Dow0UbqSqD9oo1swPKom/cpl09dnRkLCvzYuLC6Ts3n43YIp/xOAKB0m7LMlni9HuxlRlGi8CkP9nHmiSouM/yafnOxdVvI5uxY8iPyL1quTzsWzAQrmijejIp+HizTWn1ndOJF8YHd0wBhfkMS
 WCiv67dS
 9t51cH3KwOtPpOT/BXTSCYCcRGva1xrBKrRmsvghaNxq3tUKnzoUg0EiPb3VKPkWk4YMKJjPTDKptxPdmmJ6jcush/hbzgLvD7vAhimvUhbHZht0BWvz9JoDGhVtSuc5xAHXXG6elUyS1EeMFCzcSx1Kx1CO06Ti2FRc6IjSDmJUmRn/3gD0ATG0+QQ3bxdUBVmUGlbQVrReg+qjyRRaxLb0x80B6n/hjZvS5p9CoMgzf+ka5VjUpAg7IcaX4rvnT/dyYzhZ/GZRA1CDdfcxIkrOroez2Bh6DV5otwCA5MPWtkaogJp4n7PI7IEKqKCO4t6LByjDOCcrbm2I8jExhxitYBOZlekt59GaEEVWD+pEgDPAxinm2xzmquuagqFStovewXqWXa3xlAEj0Uq5DnoOgWdmEMDfk3koYG0f3N0JXIBUBpcp4222M4xwxOFOIbwcwgYlkPFpadMwmBwHqXW+gDFrqI17lgTexO8FxZ3gpMXwiiVlBRTLiiaKjwHMivPcc9NkB/GuNtWE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------0iZRncWzsyBwJEE9LOW9wmSR
Content-Type: multipart/mixed; boundary="------------32Spjo3a2GL1OUJCFYd7q0sU";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Shengming Hu <hu.shengming@zte.com.cn>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Message-ID: <5d1bb55e-7dad-4013-9c72-5a43051057d6@kernel.org>
Subject: Re: [PATCH] mm/slab: extract __free_to_pcs_batch() from
 free_to_pcs_bulk()
References: <20260707-slab-simplify-bulk-pcs-v1-1-4850dbe0d904@kernel.org>
 <alB_hIJFVgFM3HxM@fedora> <alCAyjxEDM7PmsRy@fedora>
 <c7768cad-db55-48e6-afb8-5916c1a6f00d@kernel.org>
In-Reply-To: <c7768cad-db55-48e6-afb8-5916c1a6f00d@kernel.org>

--------------32Spjo3a2GL1OUJCFYd7q0sU
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/10/26 6:54 PM, Vlastimil Babka (SUSE) wrote:
> On 7/10/26 07:21, Hao Li wrote:
>> On Fri, Jul 10, 2026 at 01:18:25PM +0800, Hao Li wrote:
>>> On Tue, Jul 07, 2026 at 02:16:00PM +0200, Vlastimil Babka (SUSE) wrot=
e:
>>>> It has been noted that free_to_pcs_bulk() is difficult to follow, wi=
th a
>>>> number of goto labels, and this has contributed to two memory leak b=
ugs
>>>> in there.
>>>>
>>>> Extract part of the code to __free_to_pcs_batch(), which focuses onl=
y on
>>>> freeing free-hook-processed local objects to a percpu sheaf, and
>>>> returning how many were freed. Zero means a trylock failure or no em=
pty
>>>> sheaf available, and thus the caller should fallback to
>>>> __kmem_cache_free_bulk().
>>>>
>>>> Make free_to_pcs_bulk() call this in a while loop, removing all goto=

>>>> labels from the function. __free_to_pcs_batch() retains two rather
>>>> straightforward ones.
>>>>
>>>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>>>
>>> Nice simplification!
>>>
>>> [...]
>>>> +/*
>>>> + * Bulk free objects to the percpu sheaves.
>>>> + * Unlike free_to_pcs() this includes the calls to all necessary ho=
oks
>>>> + * and the fallback to freeing to slab pages.
>>>> + */
>>>> +static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, voi=
d **p)
>>>> +{
>>>> +	bool init =3D slab_want_init_on_free(s);
>>>> +	void *remote_objects[PCS_BATCH_MAX];
>>>> +	unsigned int remote_nr =3D 0;
>>>> +
>>>> +	for (unsigned int i =3D 0; i < size;) {
>>>> +		struct slab *slab =3D virt_to_slab(p[i]);
>>>> +
>>>> +		memcg_slab_free_hook(s, slab, p + i, 1);
>>>> +		alloc_tagging_slab_free_hook(s, slab, p + i, 1);
>>>> +
>>>> +		if (unlikely(!slab_free_hook(s, p[i], init, false))) {
>>>> +			p[i] =3D p[--size];
>>>> +			continue;
>>>> +		}
>>>> +
>>>> +		if (unlikely(!can_free_to_pcs(slab))) {
>>>> +			remote_objects[remote_nr] =3D p[i];
>>>> +			p[i] =3D p[--size];
>>>> +			if (++remote_nr >=3D PCS_BATCH_MAX) {
>>>> +				__kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
>>>> +				stat_add(s, FREE_SLOWPATH, remote_nr);
>>>> +				remote_nr =3D 0;
>>>> +			}
>>>> +			continue;
>>>> +		}
>>>> +
>>>> +		i++;
>>>>  	}
>>>> =20
>>>> -	if (remote_nr)
>>>> -		goto flush_remote;
>>>> +	while (size) {
>>>> +		unsigned int batch_freed =3D __free_to_pcs_batch(s, size, p);
>>>> =20
>>>> -	return;
>>>> +		if (!batch_freed)
>>>> +			break;
>>>> =20
>>>> -no_empty:
>>>> -	local_unlock(&s->cpu_sheaves->lock);
>>>> +		p +=3D batch_freed;
>>>> +		size -=3D batch_freed;
>>>> +	}
>>>> =20
>>>> -	/*
>>>> -	 * if we depleted all empty sheaves in the barn or there are too
>>>> -	 * many full sheaves, free the rest to slab pages
>>>> -	 */
>>>> -fallback:
>>>> -	__kmem_cache_free_bulk(s, size, p);
>>>> -	stat_add(s, FREE_SLOWPATH, size);
>>>> +	if (size) {
>>>> +		__kmem_cache_free_bulk(s, size, p);
>>>> +		stat_add(s, FREE_SLOWPATH, size);
>>>> +	}
>>>
>>> By the way, could we move this directly into the loop inside the
>>> `if (!batch_freed)` block to make it a bit more concise? but it's tot=
ally fine
>>> to leave it as is! :)
>=20
> Ah right, great suggestion! will do.

Including the suggested change:

Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------32Spjo3a2GL1OUJCFYd7q0sU--

--------------0iZRncWzsyBwJEE9LOW9wmSR
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCalDDIQAKCRCGXBN6rc5S
1ppCAP0dTWmRJEYiuWr7o3WH3S+iVpYgFhgA5Z0t5uQu3BB2LwEAnH7y7Js/OXM5
lP/HFvFp2ebYjuBUAC9VWpgBdpOWGAw=
=XzdP
-----END PGP SIGNATURE-----

--------------0iZRncWzsyBwJEE9LOW9wmSR--


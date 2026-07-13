Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 845EBC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:15:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EEB96B00AF; Mon, 13 Jul 2026 12:15:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99ED46B00B1; Mon, 13 Jul 2026 12:15:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88D906B00B2; Mon, 13 Jul 2026 12:15:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5DDCC6B00AF
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:15:20 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ECE2C4021C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:15:19 +0000 (UTC)
X-FDA: 84984253158.07.C482043
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4FD8A2000B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:15:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QOMPvtSa;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783959318;
	b=pBJRUcVBj4KiUV3siqEWkL0lQSYRb0XgTn+QHkVJW0QBzS8Fnjdpk67z1qnH3mnBBDgMte
	Wr8ew6p5JX21pBjHVK2Valc/ce8VCQsIJwBonTQyd3RlcS/JkvFi+ijLrthzSL5KCOPBX+
	RRVdLgs709nQkU7EaxhfVP+jnIEHyqo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QOMPvtSa;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783959318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oNIWkoRxlut88jezsElvPH1wV8FkiiBk36IvzZ2BAwo=;
	b=G0R5KbwqVqxLnQ0s3P9WJ1OX8MGh7ZacXB/g9UtKBePkGA6Zfns1Ino1zVrQJlrOowPBok
	e37Z1g6uls9Hs18ESYMerXoj1U/IkcndlCKXoUzrwKEpiq0Qt93s1YxCv3S/oDTjeB+1PU
	6n94PIgStRNDefW6SIAqEEAR7UwIg6s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CCC31600AE;
	Mon, 13 Jul 2026 16:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3321F000E9;
	Mon, 13 Jul 2026 16:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783959317;
	bh=oNIWkoRxlut88jezsElvPH1wV8FkiiBk36IvzZ2BAwo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QOMPvtSaMxX9MpsXzTtiH2pWD1W/+0iiLAHU0QOSAyGHZ3amnA/Bu1/A4lKY5tOYJ
	 Wtiz3ty98R2Fbype7p9a0rxYruVz2pXVagCTCyzX3AKW1F6GKtZhPrOvL4r2TuMu2Y
	 j/JKvmod6ihm10/0FqARNrS4oLdcQDC2tnMtCiDvjkCaz0pFmRo0GezGCV9mVXbq3N
	 J2OgXqfodG4emrSkrdUAAiKr0PmbekyjmeRf42NigHAQlyqR6YaLXkU44ql4Hm8tI/
	 KNUF1VCvsufqBvwNlfGGx7EXWov7p6L/NJ+6NVThcRcO2nSWwZDmQ56sFSRI/2Lu42
	 XNYFs3mM9vTew==
Message-ID: <4c969202-a8ed-41a8-9e9a-281a12f6dde3@kernel.org>
Date: Tue, 14 Jul 2026 01:15:08 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/page_alloc: don't spin_trylock() in NMI on UP
To: Brendan Jackman <brendan.jackman@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, sashiko-bot@kernel.org,
 stable@vger.kernel.org
References: <20260710-spin-trylock-followup-v1-0-affb5fe5ed00@google.com>
 <20260710-spin-trylock-followup-v1-1-affb5fe5ed00@google.com>
 <20260710170311.e22bfd21c658e8357ceddeec@linux-foundation.org>
 <DJXILB94G82L.37YBL62YO9XBK@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <DJXILB94G82L.37YBL62YO9XBK@linux.dev>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------wjfaJTQWd3NhLTT80YxRJH5m"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4FD8A2000B
X-Stat-Signature: 7miz3by6s9rp68wtqt3j7e6phkf8wepw
X-HE-Tag: 1783959318-906551
X-HE-Meta: U2FsdGVkX1/DaHIJDQA4ICjEGXN2vfBnc4NL24OEX7XMC1hhF8encQwyBAa1lkRAfCA4c/5rATIUiITzZy91MITWmLVl5gcf3+0hWDYT3WpoApaNx21roeXpm4H31yfnaaUciVg3EI9EADvJXjQtGNhRmErP3euneJeWntkUE8IhIGWo+i3aAJO/pXPUt3AVEN7sYUEtpgUdDxRhqxjUA4c+ytSErKqFE763/J86Maxu15Sk9RtmthpfxUBrNFHc/+PBFiQhhcvW4w3w64xFTLuFI/Lan5N8xLRzy54xau4E6ph1y93ViWFNuhLpBQ5w+HVOzH0cYIZyArB9PpqZdoPvzsE5Gny86wi4U4lsIv33lw7Nuy1stBkohpB0um9kbNe6W5mJA6EEgHlZ3ozWbA5rcAFHu/DoS4cyK7VsWdLWxemSU28P7SGTI+ksZyQWqbFbVSj676Ufsgoql64P1RGSQscwRM9pPUHs659Zji43G5a1yyVc0ukVDlcoY+WChbKmPYKQcM7o5qHDc8vaza7x21tft6//1eggGjtXfftqPEeezQ+LsyXHDfdk6EyKg6d7PRHUXHqt/Rz30a09GD14diWgJSB/YO8/mpVUtUJj5iQ9RXZ2gMU2iJEWM7TjNKLaQM3oOLgypgAlCuU0WJ6nmp0Gm9Kr8pY+hM6y/B+1wNG/4qXacfli0xCzlpllvOswt/ttBA15m4zlWHgO8TTpygsfkdElRVZ3YGrE0PE6oA8ukOmCqw1KZYUoPkpqxy+7F7kBN7xKJpWeJPffOcQqFhA+QYfyHjl2UkMDY8sUfG5qzknzA829UlAbrXjvmBJCubCrTJpH/VqMRE1o8b2M4rlF8j2yrT6OUjOPWsy6+abAMgOeSwJLcJHqzcK/DuZesy5P9zCva01Xf3CmzisimrKsmZFfDE15gcjcLGwBljPusGLxB6LjCSeJ0r4ohQN3S/1x0MX+JqGZgue
 0JykJ63s
 et2MgSv8xrxd1DjZvU9EqODqtTkvkTJJ7M6kap3z/b2cKR01Poa5uH3DW0k5u/mWE8x8sS+Cl74enwtLHmmOPGRw/r8sZRlYIqa4hFCSyaTSYkDAd3OtNIAPzSG/SmvzE//wpDxAOhKq7xaF/iEIs8cUON/UrKx6yo4MFq057HCKyyQrYznDKjK1lAVwT8FytgGeQzUbtqs3sXRrEA+mYVQJKZ/igFu6mhQjCXAzrORH1O2xNatJQbQAxB3ywOQN2NKeuhsneZoAPuf2l6S2KreAlywu0YlVFoTq5eVE0zEBtjgrobgh2MScoPIkvmzZJR229nCZjWiIB6Rm6L8AH/J1d7NpgSR5u2eMpz/OwBiZJMZDJnmGPdoIEwZqWCknk1r8s7FlZPGMtt4my+iMCMBuchAgC4FLNHxrawR4Ge8j/ohKBu8W+NbfhdbycmkAfFjrZ+Kzr1BM92FqOSH3PM3VU0tETmCii9vYdP0A/GBYYLS5eapnTsFsQYnyw1OXFOmVo/H+HGNqU++iwKKc9cMuQsMGwEY0/GXfbT3oWDWbC6706zoaCLAYWXWed+4UmXyDvjseaumD+x/KjupNVJmracNhLVh3a++LQjBoMn1Tgd9w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------wjfaJTQWd3NhLTT80YxRJH5m
Content-Type: multipart/mixed; boundary="------------nxjIPOFNtOXUEKiJUGKT1hb6";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Brendan Jackman <brendan.jackman@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, sashiko-bot@kernel.org,
 stable@vger.kernel.org
Message-ID: <4c969202-a8ed-41a8-9e9a-281a12f6dde3@kernel.org>
Subject: Re: [PATCH 1/2] mm/page_alloc: don't spin_trylock() in NMI on UP
References: <20260710-spin-trylock-followup-v1-0-affb5fe5ed00@google.com>
 <20260710-spin-trylock-followup-v1-1-affb5fe5ed00@google.com>
 <20260710170311.e22bfd21c658e8357ceddeec@linux-foundation.org>
 <DJXILB94G82L.37YBL62YO9XBK@linux.dev>
In-Reply-To: <DJXILB94G82L.37YBL62YO9XBK@linux.dev>

--------------nxjIPOFNtOXUEKiJUGKT1hb6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/13/26 11:31 PM, Brendan Jackman wrote:
> On Sat Jul 11, 2026 at 12:03 AM UTC, Andrew Morton wrote:
>> On Fri, 10 Jul 2026 10:42:20 +0000 Brendan Jackman <jackmanb@google.co=
m> wrote:
>>
>>> As noted in can_spin_trylock(), using this is unsafe in this context.=

>>> commit 620b46ed6ae17 ("mm/page_alloc: return NULL early from
>>> alloc_frozen_pages_nolock() in NMI on UP") fixed this on the alloc si=
de
>>> but missed the free side.

Ouch, do we allow alloc_pages() -> free_pages_nolock()?
Didn't notice.

>>> Reported-by: sashiko-bot@kernel.org
>>> Link: https://sashiko.dev/#/patchset/20260703-alloc-trylock-v5-0-c87b=
714e19d3@google.com
>>> Cc: stable@vger.kernel.org
>>> Fixes: d7242af86434 ("mm: Introduce alloc_frozen_pages_nolock()")
>>
>> Is this correct?  I'm not seeing anything in that commit which could
>> have caused this?
>=20
> Oh yeah I guess it should be:
>=20
> Fixes: 8c57b687e8331 ("mm, bpf: Introduce free_pages_nolock()")
>=20
> This is confusing coz we have:
>=20
> A: commit d7242af86434 ("mm: Introduce alloc_frozen_pages_nolock()")
> B: commit 8c57b687e8331 ("mm, bpf: Introduce free_pages_nolock()")
> ...
> X: commit 620b46ed6ae17 ("mm/page_alloc: return NULL early from alloc_f=
rozen_pages_nolock() in NMI on UP")=20
>=20
> X is marked as Fixing A, but it was an incomplete fix. I just copy
> pasted the Fixes tag. But actually I'm now changing the free path that
> was only introduced in B.=20
>=20
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -2979,8 +2979,7 @@ static void __free_frozen_pages(struct page *pa=
ge, unsigned int order,
>>>  		migratetype =3D MIGRATE_MOVABLE;
>>>  	}
>>> =20
>>> -	if (unlikely((fpi_flags & FPI_TRYLOCK) && IS_ENABLED(CONFIG_PREEMPT=
_RT)
>>> -		     && (in_nmi() || in_hardirq()))) {
>>> +	if (unlikely((fpi_flags & FPI_TRYLOCK) && !can_spin_trylock())) {
>>>  		add_page_to_zone_llist(zone, page, order);
>>>  		return;
>>>  	}
>>
>> It would be nice to include a description of the userspace impact.  I'=
m
>> suspecting that's "none known", but some speculation on what might
>> happen to someone is appropriate.
>=20
> Ack. I think if you trigger this bug by accident it will probably crash=

> your machine in extremely confusing ways. If you can trigger it
> deliberately from unpriv (depends on the rest of the host setup, e.g.
> what tracing is being used) you can probably use it to get root/ring0.
> Can mention this in the commit message.

Just noting, it is quite niche because it requires UP, and tracing
something that can be called in NMI on UP is even nicher.

>> Also, Sashiko might have found yet more pre-existing issues:
>> 	https://sashiko.dev/#/patchset/20260710-spin-trylock-followup-v1-0-af=
fb5fe5ed00@google.com
>=20
> There are 2 cases here:
>=20
> 1: !pcp_allowed_order() -> This is forbidden by alloc_order_allowed(),
>    quite a bad miss from Sashiko IMO.

Hmm but alloc_order_allowed() would return true for !pcp_allowed_order()
when spinning is allowed, then pages can be freed via
free_pages_nolock()?

--=20
Cheers,
Harry / Hyeonggon

--------------nxjIPOFNtOXUEKiJUGKT1hb6--

--------------wjfaJTQWd3NhLTT80YxRJH5m
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCalUPDQAKCRCGXBN6rc5S
1uORAP95b6ffqA3hjbQbhh4fTA8JO2q/aCxMraAwrw3m7JnqIwEAhA/YJsuRldNh
eHZVy6QNewHI+2W+paQ1iqEOvb1FuAs=
=UlbM
-----END PGP SIGNATURE-----

--------------wjfaJTQWd3NhLTT80YxRJH5m--


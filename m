Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D12E7C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 09:39:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3E0D6B00B6; Fri,  3 Jul 2026 05:39:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C15B36B00B7; Fri,  3 Jul 2026 05:39:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2C246B00B8; Fri,  3 Jul 2026 05:39:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 79F446B00B6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 05:39:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C3B312037F
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:39:08 +0000 (UTC)
X-FDA: 84946966776.27.08ED0B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5ADF220004
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:39:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IIdjRc2F;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783071546;
	b=F4Vg5nvvyCVsXgb/sY7cpW2SYgEelW3iX2sfWFH5YIP6J3l1ABFP4RIpVEAoJQh4Mh4xvs
	l4lfLWGFbPYgKfXg6KD37JJzaNWeT3wEqL6tOKVLPR0QjuHeeV/TsGVF58nChfkTJPvzUL
	GkKyD32dP3qek/KFCaewWxlhZP3aNXA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783071546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/jgWAf5SwPzlqhJKQG2/7AalkDHZJDG2niv0fSajwEU=;
	b=jnbd98OLhKrmBzaHgyXhG3XGHhG+WPTke7I5yuBYwTAoE759onysj8YBzdy85T1VFi/OAH
	6oFIKBE0Ds+yTuf8wU6yf06oNt16lxmPyKBo8ID7Re0xsiPBvK7sfkG+3FN6kYaEn+NXSU
	VgRUuAkagAmyUlp7GPXdVIETCYkbmf4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IIdjRc2F;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9081C40B02;
	Fri,  3 Jul 2026 09:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FAB1F000E9;
	Fri,  3 Jul 2026 09:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783071545;
	bh=/jgWAf5SwPzlqhJKQG2/7AalkDHZJDG2niv0fSajwEU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IIdjRc2Ff/MhGB0w5/vA6UjULptWQXsppua/eAUQJfQd5NdXeRV+p01OWY8Bt3MPx
	 4cCwYAFNdOfbaGdRUnh8JC/PEGaL921tNnsYvSZayZ03ymB3aeVliby82ll+FWzCaQ
	 SIsx2dDAR0T1X9mG4D83sJAUOi+NrbIxNf5WZxypCZ98bPyoxgMMd50YEOi7wKPZTQ
	 u7Q9/JcQ+aC7Aao4EcS84uEFUJCKZOucloXKmc1GFudydK99rNNkqs6AH6O1LYyaqq
	 8ssYDoFNn58jqKcwT3gORSPDYeyUS9bqj8DnoMb93ezoxbBc77dlKC0CeNbveMZYb2
	 A36yiTH0mN0NA==
Message-ID: <21ec3b5e-8e8a-4f8c-aad9-ff9b77bd6d6e@kernel.org>
Date: Fri, 3 Jul 2026 18:38:39 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 18/18] mm: factor out can_spin_trylock()
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Gregory Price <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, derkling@google.com, reijiw@google.com,
 Yosry Ahmed <yosry@kernel.org>
References: <20260702-alloc-trylock-v4-0-0af8ff387e80@google.com>
 <20260702-alloc-trylock-v4-18-0af8ff387e80@google.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260702-alloc-trylock-v4-18-0af8ff387e80@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------hFDyml7LY0WmvWczM3Ou39Mo"
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5ADF220004
X-Stat-Signature: 7mhg7agrmui6iw4u8ak7tie4pr9ozon5
X-HE-Tag: 1783071546-309010
X-HE-Meta: U2FsdGVkX1+vxk2+QhtIZ0xKf5fcg8ncjMFXI8zaMn2ITdF9E4eAQNJ7jGbAYFjgg9TXBurSvWOkjuSD4L8TgK2pzc0rQS8mvuFcRGlgGijQxmT8/08I3NjnfXPkfRMBwur7xqs+aM0q4BR8ASKPSOxM8yPCotoUaNlTSfnyNaVT+GhtAUZ6GZlSs9CrFOyQR81x01knrgKEUFACSQWGFujuREIPNh+YkG3f6sUlC6iYBS6kSSOMAjmpsvMTdZ0YsUXKe7Y9Rrw7NrPBoLnKq2kqNJ4pnYkBJpAPW0SbrYLf2RQso81tCLbUtnoxXjX4BSyioAdG6k+n1Z7tVIKju2AdZ0B7E2gXeeOw3ykD+lPUoAFVasB5K7lYTRd1lybBRLi746VshhpcgjkFOwWt6IpLfdtgOnaHYZZRa4hVIZkV4oCOjLm//wSbY+U0K8d1rHx/E+e4fjABEtVZ7rMzrN8VW8H0I0TyLDGFu1G2UM/yCTdHJ/P9KS6icnhNJmwnud62+Ay7+5t56gyBDNgp7FSKZlm64UX9+p0mvOOWKTRS/DLEwwWN3Bl3EXGfgtswmUMcCvUt1FTSQrnO1nd6T7gs0ZGVkiM/4Q64er8Xn42o/aZV52+oimGUNj/znm03rLQvgx0fKFPaojalXQA3LuZlK/md8VOtAQ3pX6O356N+oLoMAKhqhHb0XjhZhtjbQuBloqTZxarjoBDJmLhohBJqwHFlnhfTqwDmnrbZJORy5912rGsNxh41f6PoTqvTOPwF89J8RYVYKrdrdesDrnS2aO2GaJ/zPk+bBJK5dED2h84MNDaYjr36lU+Bl+HJl0WmqLts+U4Wj81WyEv/wEKtCKW85IHZJ6AITppjnJ/cd+JFkEphjyvvewuBzM6HVCkjA/OjXN8xgCXmQTAkLZnqwctaNoXNSKKaY2gAqhCNcpoMDFLI3r1NZOikd9UcwddsV2xnUkcdn11DcJd
 NgGNJCh6
 YcxWJqDXeDuW3Xfx4/iKzv8KK1mNz1N3/nB8tKlVq1cU9TXuO3dcxCiP/CZ+vTOuC/aZpyfv7WytSVPycAv07mB/Dk599GHyDgFnajgjK+vzKgTSrRbOfYjAbCbW+TSoX20pK+k5tD8GW7JiYcvRRflRRWd2SP0d/cQEOWBN3KFLagVPkM7N3kbryEYLTrvijzfUIEwEMyjdPJEtqg6bvQqVI2vmz0A/JFNUGy09hiWmiMGZyxO+zoh91fbLTsw4VOdEgRzl7ZKyfmqCO8ekL31THk0RN4cW5P582Dq4qKUHq/KPcUdwf5JLmAenykZCoYRaJAiv0gAoJ+0Hx2duFhAyTK+r+bAcNy67e9ZTPmxblvUwQiVnGIWejgr5Jz+U/Zyzgu4sr2K6RTflGyA3Cd8aTP7li4NiSNf+GlmsJQaZOAu8GUc6pO+9rN0pmwa/GfN8ihfKpu0PBnQgciHQkbveoV7fd+nB3s0CMidfUazABjm6cCQ7Vs/JqZcQ60uMCiqk3LmLOkelVRlLdnsGZn8r4T2InC70Hf+FMHD9HIdCTDn0GA5yJT1vXlYqjyXErN7SqMsOb9N5R5btfK1A8GVZw7M2KNq7RtxULY1W5luNEcoMUMXCDlAdMsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------hFDyml7LY0WmvWczM3Ou39Mo
Content-Type: multipart/mixed; boundary="------------EMNg7VfEL9bzN6yUIrxUi2BK";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Gregory Price <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, derkling@google.com, reijiw@google.com,
 Yosry Ahmed <yosry@kernel.org>
Message-ID: <21ec3b5e-8e8a-4f8c-aad9-ff9b77bd6d6e@kernel.org>
Subject: Re: [PATCH v4 18/18] mm: factor out can_spin_trylock()
References: <20260702-alloc-trylock-v4-0-0af8ff387e80@google.com>
 <20260702-alloc-trylock-v4-18-0af8ff387e80@google.com>
In-Reply-To: <20260702-alloc-trylock-v4-18-0af8ff387e80@google.com>

--------------EMNg7VfEL9bzN6yUIrxUi2BK
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/2/26 6:49 PM, Brendan Jackman wrote:
> Deduplicate checks for whether the current context is safe for
> spin_trylock().
>=20
> Does this function really belong in mm/internal.h or is it generic? Not=

> sure. If someone ends up duplicating this logic elsewhere in the kernel=
,
> that would be a shame.

Wondering what BPF has been doing about it...

> But goes in some generic header, someone treats
> it as documentation about where it's guaranteed safe to spin_trylock(),=

> and then it emerges that there are other subtle preconditions that
> didn't affect the mm usecase, that would be worse. So, just be
> conservative and keep it local.

But yeah, agreed.

> Suggested-by: Harry Yoo <harry@kernel.org>
> Link: https://lore.kernel.org/all/397859cb-b127-4cc6-9c71-044afc99bf0c@=
kernel.org/
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---

Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

Thanks!

--=20
Cheers,
Harry / Hyeonggon

--------------EMNg7VfEL9bzN6yUIrxUi2BK--

--------------hFDyml7LY0WmvWczM3Ou39Mo
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCakeDHwAKCRCGXBN6rc5S
1qOoAP9X/oz3Te45ijX+oZqnExbf3F/cLVlMnCzGQzkprL5sGwD/VnLjX0AY95bV
/SjSfOk7aMvj/cla9N9FEs2kf6hCUQo=
=jFVY
-----END PGP SIGNATURE-----

--------------hFDyml7LY0WmvWczM3Ou39Mo--


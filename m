Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89266CD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 04:35:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 750DE6B008C; Thu, 11 Jun 2026 00:35:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 728206B0092; Thu, 11 Jun 2026 00:35:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 665BB6B0093; Thu, 11 Jun 2026 00:35:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 557806B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 00:35:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BE316140471
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 04:35:56 +0000 (UTC)
X-FDA: 84866369112.30.6610739
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 16AB7160002
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 04:35:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jKw6Or8P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781152555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RBtM2K5HAboXGskkkhCTAIlRz7iBBSjZG1WoOi7K0cE=;
	b=efGVXPG3QE2Oyv6qDFbPYsn4N+HvAx64b1okfCArTNpNbYbuKJGrA8YhiZIRqceryCM+M+
	KmI6pFjMJASwLBTORI8CPD1oGAa8c9m/NmRBdkgN9JD5lCFtnxlV3M0RISY/AZjzXEIPt8
	qi0kqBqs8nYdY07BUNTSWSkrTV8m8kc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jKw6Or8P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781152555;
	b=8iqhIhwBXCK3rw8bFoVDPBUxTJeWB68uGBF+Rs8CkS9j9HkQGL4QsWU9gf6fVyWO8SeQ7M
	Xqr1F0di1/mJeJcwhzKKFDpntYY275tnVAc7zz2vSKMb5+913pk93oivxcOSwQ5s01Xghx
	5mjJy82Ats4J3ci6j6m2XxtpNLCwiuQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EF49640328;
	Thu, 11 Jun 2026 04:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FB31F00893;
	Thu, 11 Jun 2026 04:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781152553;
	bh=RBtM2K5HAboXGskkkhCTAIlRz7iBBSjZG1WoOi7K0cE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jKw6Or8PUn8mM8QSyoHKukGjtNmlEqJLvHQXxCKMjvgSAlvbSPoDtHTLOYjUPSQMX
	 NUGcsOnXvnSQEF/D4RZYRH72AtZFetepAJKnJFaN1FEZ7g7HCyUnLnMtcm6u9tXYPQ
	 J2txDzG1CviQKZVz4dEtzlCb2+gdfMWMpgzsAVtrBe3kSoI0sc44MW4S+ABd2tYW2b
	 W2HW+2LV+fu86k7mBZNf0HAtKphWM17UmDjwWB7Km+tLcDq2sBDTdF+hpHZE1+55C9
	 B4Q2y19JfLFCQfy9+KiN88LL7a4COOlpBWE8DaGGgb8+3iCH1aCWlZyZmF671FzsPS
	 gmIH6I0Fm7TzQ==
Message-ID: <bdce3c32-54de-4f07-9321-986f49e47767@kernel.org>
Date: Thu, 11 Jun 2026 13:35:46 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] mm/khugepaged: use slab cache instead of normal
 kmalloc
To: Luka Bai <lukafocus@icloud.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>,
 Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-kernel@vger.kernel.org, Luka Bai <lukabai@tencent.com>
References: <20260531-thp_collapse_hint-v1-0-e7f8c2035621@tencent.com>
 <20260531-thp_collapse_hint-v1-2-e7f8c2035621@tencent.com>
 <d4636be2-d9fe-4464-99d7-b0b9902e6b52@kernel.org>
 <aiooiNyND2Q96b4j@LUKABAI-MC1>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <aiooiNyND2Q96b4j@LUKABAI-MC1>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------s0FuOZXCRkHyas8wwz3tzD0p"
X-Rspamd-Queue-Id: 16AB7160002
X-Rspam-User: 
X-Stat-Signature: rk1fenx5xy9i8xhpskhwmyr1aot6muj1
X-Rspamd-Server: rspam09
X-HE-Tag: 1781152554-288371
X-HE-Meta: U2FsdGVkX1/UvPb6PPdTRuGwTUoj1Sov7JVV1U5etCufV+K5IHo3TJUNjVgw/LlvPME/PCaPvgHspimlsWc6TIht2uLcRo/u/aZS/okcePaDRiRRdLZFK/z6cZ0QPJhk8MUG9d8i/iZMp99BfFjyl6eLaev7EYLYVdzbFBe8JPIx6QvS00YAROVOxbYRGR2Ps51OcyXe6X3mqB/ar9ffPOIBARkP9PiBSLmiNHZiF0dWreTo4heguHabKl8HCTHM4tLDbj913l2UuzGAqjxtS8ugjAMxLSV8J8ZMmzzedD0h2CM2WCFMhYnAohuhCiKxBDHpw5l7igz5KufeQtSDglD8HrjG9oRF24lRF+xan/hmC2bij9MrfIx+rLO8876PUnhfpkYPPVKNFrmgQpkcFcjz+8J8MdoCJGmOA7z2RrOZb7DViYRsglUqNixibKET71WIHG+MbYZjF3mBcjbKLRJVlMfDvWMeBJtizdHinO6G9iWXKuzlNCJ2UO2c3DT/gt9G41pQs+PDpL6tM0m0vjdyseJ700AMvaTJFaYYDv7wSpW7hsNkWpJ8tzIJva9XMUuuCZEdBbP5povaWIVlYOdkXAZm9dhXwii+gMATwzmD/QjOqbHJnBo9G8apVL7tuoGjMAnILiFJuCLNDgJPNT4eL7vUDMpdkSguq9q6+lPpbvT1rC6PnxvWNrmR8IgVKrxiHrRUJzVWvuFt9q6BSDNQOYvqkEBxHhGy7rNW5Kh+q26r0+tLOLGTcqU6pwyPwb/IhTaYEz/Tga+MnVQb6GGrYgiNg9TNb2VHhF/RlId4gfOLwp4esp5D/QHBSHnG/mD/u67giAwtJMxkpnReIX17wYIBbXVZX/qgtGznwwBxqwGTO/iL1DVzEe554j0OsclvdLLXXHhOBs4XPPxPhTDb86hjhJd2tqL7OfOkLzfAnw/lmeP5J9RL/gOO6O7+scIW+P8QL9fqMLBVt7Z
 BAVfYH44
 a4wi7jXZEI6mqw7dAKnSDdO6u03TR8ouaMjpQpAxipV23IcWaAgzB5d3GcIKKWGqk2Ct7v8XJ9/cHGCcy0qrOk6iOxeAwNCi2khJTf2IVVW1jQ8uk7O8XMOaY1WMQf2D4se7AUcWyOp4VnhnQ0Yo0NSf01duN3CEYZdStmvGLKSOO9UsAUOIVJois382C/2GFsRMVEFe8moNpg3F6owVrV9Fjcmf1UZX3FT7+hVJSOXu8ijDqtWPik9xEAMrGD8rPXDdO4co5wg0jIzP3CSvcflUSwJAOEWTfXI3xDhBv+6fWVtqYukZsG1Q3ZrGkxzkORimJug9w3xEUtF2DJ32qJKwPTeNL9g15c/OnMTVd6WhN4+cvfaJLB/Ig+Njw3Bz9Sa6yBPe0rOEVgc4GqDxlHLQDQnuXJ8skEEJJpqCxsszuhSY/8kWjszoUxrTMEdKQt5AU7vMHmJFIK28a8hNKzNg5lOLpID33xw/k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------s0FuOZXCRkHyas8wwz3tzD0p
Content-Type: multipart/mixed; boundary="------------JMw89MqN6K3e0LGsnFwEl6z0";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Luka Bai <lukafocus@icloud.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>,
 Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-kernel@vger.kernel.org, Luka Bai <lukabai@tencent.com>
Message-ID: <bdce3c32-54de-4f07-9321-986f49e47767@kernel.org>
Subject: Re: [PATCH 2/5] mm/khugepaged: use slab cache instead of normal
 kmalloc
References: <20260531-thp_collapse_hint-v1-0-e7f8c2035621@tencent.com>
 <20260531-thp_collapse_hint-v1-2-e7f8c2035621@tencent.com>
 <d4636be2-d9fe-4464-99d7-b0b9902e6b52@kernel.org>
 <aiooiNyND2Q96b4j@LUKABAI-MC1>
In-Reply-To: <aiooiNyND2Q96b4j@LUKABAI-MC1>

--------------JMw89MqN6K3e0LGsnFwEl6z0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/11/26 12:16 PM, Luka Bai wrote:
> =E5=9C=A8 Tue, Jun 09, 2026 at 12:26:18PM +0200=EF=BC=8CVlastimil Babka=
 (SUSE) =E5=86=99=E9=81=93=EF=BC=9A
>> On 5/31/26 06:23, Luka Bai wrote:
>>> From: Luka Bai <lukabai@tencent.com>
>>>
>>> We added a kmem slab cached called collapse_hint_cache for
>>> khugepaged collapse hint, to improve the performance in allocation
>>> and freeing for the hint structs.
>>>
>>> Signed-off-by: Luka Bai <lukabai@tencent.com>
>>
>> Khugepaged isn't exactly a hotpath? Adding own cache comes with memory=

>> overhead, so this doesn't seem like a sufficient reason to do that.
>>
> Hi Vlastimil,
>=20
> Thanks for the review :).
>=20
> Yeah Khugepaged is not a hotpath. But in my implementation we will allo=
cate
> those khugepaged collapse hint structs in other paths like walk_mm() an=
d
> lru_gen_look_around(), which may be called more frequently under memory=

> pressure. I'm a little afraid that directly using kmalloc may compromis=
e
> the performance of reclaimation... What do you think? Thanks. :)

What makes you think using kmalloc compromises the performance under
memory pressure?

> Best regards,
> Luka

--=20
Cheers,
Harry / Hyeonggon

--------------JMw89MqN6K3e0LGsnFwEl6z0--

--------------s0FuOZXCRkHyas8wwz3tzD0p
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaio7IgAKCRCGXBN6rc5S
1iGEAQCcjg+KNn4s7QndYuB9qY/SnSuBzaTEp6GosQ8dG2oEhQD9Gf4bo4jevpE4
1qR5mrl3EDcwM1nWunUMATpFPfo4vwU=
=7p8w
-----END PGP SIGNATURE-----

--------------s0FuOZXCRkHyas8wwz3tzD0p--


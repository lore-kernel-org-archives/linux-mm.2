Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0246F606A325
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 20:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DJXoEUSO
Received: by kanga.kvack.org (Postfix)
	id ED21C6B00EF; Sun,  1 Nov 2026 15:47:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E82A56B05B1; Sun,  1 Nov 2026 15:47:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D97F16B05B2; Sun,  1 Nov 2026 15:47:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A84CC6B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 15:47:22 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5199E160AA2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 20:47:20 +0000 (UTC)
X-FDA: 85387735440.12.912AC75
Received: from mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5D0241C0007
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 20:47:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DJXoEUSO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793566038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u8s1oV2mp7KQi58uDDM1sqtCguGeqDCosYDKttk0a9E=;
	b=GD/a+LO1VfonMF0jf9dmzP3l9xXmabGjx8glxf+KI+fACB5vr3PUXoC7/sVOW/RcMXUy25
	iURb0SZl8XAZTUefCJvYtApwHIm4FshicrFUmM7F9FonyZ4LTvergcA1DUGhN0vA2VV2MJ
	5CHWxDG7RCfZEBWeZTDa8ZdWlcV88Lc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DJXoEUSO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793566038;
	b=dn9Xzk0UVbk19VaylTu1Io2Ul6nWA+wm9V1FPxbO1HlCrFGfrAKUO3Ms4M1K5vlbguidFs
	I3Uu7zoSpLInsScYGQQlzGzlU2nElL5T3pj10gJAJPXu/F34NTO03D4jcGHBF6av58YRrN
	3lLFskjX4+ncY6DnXzqTiVm1y7Zbu2U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=qovG99sxmf29ePlCaMr3QlSqBKy0IioT2VfVp35BzR0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793566028; v=1; x=1794170828;
 b=DJXoEUSOnfT/jJp/HgDXGrGHZj8YmIyliUKGliu/ydashmUvAiKGxU0s0ktV3C/C4TkngEEA
 NmjOwWj6B5KlKMVxBcp2pfbmzKlhsNw7f1FHfLBmKJEycb/a/7qrdxPJGr5gXs1vIWOvEc3i3/g
 gmTQhBHGnDa2UIX9d0jD/CU8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 08bfa2a181e29235;
	Sun, 01 Nov 2026 20:47:07 +0000
X-Mizu-Trace-ID: 08bfa2a181e29235
X-Migadu-Flow: FLOW_OUT
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Sun, 01 Nov 2026 20:47:07 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Shakeel Butt" <shakeel.butt@linux.dev>
Message-ID: <689163a4fbb7a7079d8a68db9888f06566f0728e@linux.dev>
TLS-Required: No
Subject: Re: [PATCH 0/7] MAINTAINERS: MM updates
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Alistair Popple"
 <apopple@nvidia.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Baoquan He" <baoquan.he@linux.dev>,
 "Barry Song" <baohua@kernel.org>, "Brendan Jackman"
 <brendan.jackman@linux.dev>, "Byungchul Park" <byungchul@sk.com>,
 "Chengming Zhou" <chengming.zhou@linux.dev>, "Chris Li"
 <chrisl@kernel.org>, "Christoph Lameter" <cl@gentwo.org>, "Dave Chinner"
 <david@fromorbit.com>, "David Rientjes" <rientjes@google.com>, "Dennis
 Zhou" <dennis@kernel.org>, "Dev Jain" <dev.jain@arm.com>, "Gregory Price"
 <gourry@gourry.net>, "Hao Li" <hao.li@linux.dev>, "Harry Yoo"
 <harry@kernel.org>, "Hugh Dickins" <hughd@google.com>, "Jann Horn"
 <jannh@google.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "John
 Hubbard" <jhubbard@nvidia.com>, "Joshua Hahn" <joshua.hahnjy@gmail.com>,
 "Kairui Song" <kasong@tencent.com>, "Kemeng Shi"
 <shikemeng@huaweicloud.com>, "Kiryl Shutsemau" <kas@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Matthew Brost"
 <matthew.brost@intel.com>, "Miaohe Lin" <linmiaohe@huawei.com>, "Michal
 Hocko" <mhocko@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Naoya Horiguchi"
 <nao.horiguchi@gmail.com>, "Nhat Pham" <nphamcs@gmail.com>, "Nick Piggin"
 <npiggin@gmail.com>, "Nico Pache" <nico.pache@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, "Pedro Falcato" <pfalcato@suse.de>, "Peter
 Xu" <peterx@redhat.com>, "Peter Zijlstra" <peterz@infradead.org>, "Qi
 Zheng" <qi.zheng@linux.dev>, "Rakie Kim" <rakie.kim@sk.com>, "Rik van
 Riel" <riel@surriel.com>, "Roman Gushchin" <roman.gushchin@linux.dev>,
 "Ryan Roberts" <ryan.roberts@arm.com>, "Suren Baghdasaryan"
 <surenb@google.com>, "Tejun Heo" <tj@kernel.org>, "Uladzislau Rezki"
 <urezki@gmail.com>, "Usama Arif" <usama.arif@linux.dev>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Will Deacon" <will@kernel.org>, "Xu Xin"
 <xu.xin@linux.dev>, "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Youngjun Park" <youngjun.park@lge.com>, "Zi Yan" <ziy@nvidia.com>,
 "Jason Gunthorpe" <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, "David Hildenbrand
 (Arm)" <david@kernel.org>
In-Reply-To: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5D0241C0007
X-Stat-Signature: iyjyiq66ysqmmpxuc5edhbzep9aftqcq
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793566036-14349
X-HE-Meta: U2FsdGVkX18JndcZQn180CjSVWsI3xR0PWvA7VCoFeIVVRjM0oOxMSMHJc9kbM+Bcss2QN7SQgF7fdi4YHX7D5LmzX1jwj8USQ7R/s+17XzU9T1k1dFqVfGy5r6COyx6tDNRyc+3hpUqsQldLQAU8OHkZW60mHluKz10Vpqe+kYv+aPGmGFGntTD9dpuv4MQdJk39jLewVuZ2ycj4HSkqp1g2C2Yo9BcVGUGa0ZsyeOluPEWcVrwpIZlQBRddA5bbdyztHLd8blqnSzGTF3Mf88vfr8geaQuuElfi2nBnAiWmIap6B8uBpPczqXFZRXDp0+M0CIoyLdZDy6tHSnrp7ZWKqJ4ia4ar/z/ixd9yPZ3PeaKJ0e0nAaf3EWdib5y7ogCU0x7NtxXHuOZLZxAXprPf/bODxVhG8hsEyH4FXkzUYX5pFQXaqKDT7aXVpAENgvppM54re+ayL5y6pM6311hjl4E0unspCTs478S89G+Q3KYd61O8Pjr+3sPqIa0zrZmY9t6ev6hO032v0flC3nCi1PQHoapKUbLwds8Mhg9K/HbCeZBAjVqkbB6KdZ/LZhY0bkWqyaP2UGH4A6DYT4140choXqMYqcPCJRZQWvzm4x+DSgust+TsfCYstK/UO6HaPTHigebxYsYoyIC6EH5rAaixqMnf7VPe+KMJXvL6walFHbWUx4P8lOE2IoYjSbCeHMuq2ft4MST+ZuQuG08GWamgtZCtk3SHZO4NFOdXuGg3l2bjjWvA7pq7rMDgoIlhp/TSvAoe3K8LQRu06EnivxvUzy2iQZIBRbUk8iudrJLTkr+iNyWuI0cfISbJdJQgOqlzi1GQ6K68kjwxra/sZmeKprdT+3G9E49fULmyWUgSfpfF8lReUegrNId8LXr/RYLyL7YMHNv41X6KUN3Dn/joVddrIEW6SJXrEnKqEp5MVFPiz9g4m5gW6IUlAedO1RFCLLDLTcz84W
 tzoScbyU
 p4VVSeBBhg11nrp9mYimGIwweWgneTfJPMSwytclzfHFr42Xk0WGodaWEW9AMOFkBhqgxItbZz7jy2NbJwRqXf5E5ogw9BJNQ8B0znZ4D/ZMstVNOJXiD0D/ukT9B63fthKYRHFTE7Rh+uv0Q10gB6oG/9Ht4iy0vLC2TI3uekptLbGt8yFaPiE1XACviET/QSaJEXjmFfrx7EPL9Sh9SBWISkaCxjHGtGfINJipmKV2/yUC4INkDevEshy4mP06vcwpjGVroL5xFtREITNEcffb21G0fWF3iuNG+P+zttPs6DH7nuE47xwKJ9f8z3BmzKhRIQ08Mg4chwVktq2qg9LjLiYe7qSzZht80+dToE/LIdddIbHNDKlY1ecmpS50rBaPEV0IB3UZFtEIew9+aZPx1mw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

October 30, 2026 at 2:34 PM, "David Hildenbrand (Arm)" <david@kernel.org =
mailto:david@kernel.org?to=3D%22David%20Hildenbrand%20(Arm)%22%20%3Cdavid=
%40kernel.org%3E > wrote:


>=20
>=20Hi,
>=20
>=20several MM updates:
>=20
>=20Make Zi Yan a THP maintainer (thanks for all your hard work over
> the years and thanks for taking on this responsibility), and perform so=
me
> MM MAINTAINERS cleanups.
>=20
>=20Then, start the next step of the transition from Andrew's MM tree to
> separate component trees that all get integrated into the mm-next
> integration tree.
>=20
>=20Start routing shmem through mm/core.git, adding me as a maintainer
> primarily to pick patches.
>=20
>=20Then, target the following components for the mm/core.git tree that I
> (co)maintain:
>=20
>=20 - MEMORY MANAGEMENT - BALLOON
>  - MEMORY MANAGEMENT - CORE
>  - MEMORY MANAGEMENT - GUP (GET USER PAGES)
>  - MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
>  - MEMORY MANAGEMENT - MEMORY HOT(UN)PLUG
>  - MEMORY MANAGEMENT - MIGRATION
>  - MEMORY MANAGEMENT - NUMA PLACEMENT
>  - MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
>  - MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
>=20
>=20More details in the last patch.
>=20
>=20In the upcoming cycles we'll then route more of the other MM componen=
ts
> through different trees.
>=20
>=20Let's see how this goes, in particular with the continuous stream of
> fixes. But getting these in in a controlled way has highest priority
> right now wither way.
>=20
>=20Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> David Hildenbrand (Arm) (7):
>  MAINTAINERS: mention for-next branch in MEMORY MANAGEMENT - MEMORY MAP
>  MAINTAINERS: TMPFS (SHMEM FILESYSTEM) updates
>  MAINTAINERS: add Zi Yan as co-maintainer for MEMORY MANAGEMENT - THP
>  MAINTAINERS: sort entries in MM sections
>  MAINTAINERS: add missing files to MM component sections
>  MAINTAINERS: rename and move MEMORY HOT(UN)PLUG
>  MAINTAINERS: route more MM changes through mm/core.git

For the whole series:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


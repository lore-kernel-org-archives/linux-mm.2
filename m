Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3B7B606A338
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 06:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VK8Gx9qj
Received: by kanga.kvack.org (Postfix)
	id C1AF66B05B5; Thu, 12 Nov 2026 01:14:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCAD26B05B6; Thu, 12 Nov 2026 01:14:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABCBD6B05B7; Thu, 12 Nov 2026 01:14:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88BE66B05B5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 01:14:13 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 21446401D9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:14:13 +0000 (UTC)
X-FDA: 85425451986.19.56CB346
Received: from mta1.migadu.com (out-100.mta1.migadu.com [95.215.58.100])
	by imf01.hostedemail.com (Postfix) with ESMTP id 25D5040002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:14:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VK8Gx9qj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.100 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794464051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GOjmMfTwWFwzvXb2vdAWJAzj6RNRi2ZVVOIySaF3Bow=;
	b=1yCm+qyu6aNQu9yu69RE7B+FHhsu8ba2XGyccWCiWf7vjLQ4Xs3/10eFtZRQubA3sqASia
	uOoPQXuS2AeweQ88PavR4dZEMxWra9mvQ1WN33w/Tw90PvtW98dQlv7t7C97HKZx3FiNQi
	3ZX9ozDIUF/1CXOFW1baG+2ENKPGvHI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VK8Gx9qj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.100 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794464051;
	b=APqbuO1ZI2mfR9pv08KSW6RmOlSm9ZVReyVvIiEEbe0GSpEprAR2Nv9qwmWMiT0BtRC8rG
	NNpyNVhG4ZsoHjaEDJxT1QKFAIPTNgG6puWZ6Foj/XRcTbZRc5zFhGryTcC1OWTFybHh7w
	CSxCevN1/3IMpqVVKStFbBueH+J0B3U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GOjmMfTwWFwzvXb2vdAWJAzj6RNRi2ZVVOIySaF3Bow=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794464049; v=1; x=1795068849;
 b=VK8Gx9qjg1UfqX+Y7HCzmtNTJ05Pth5kjeiYQrvJj3vK/3a1vXA5pR3YQsshpyW0a9LhqcbM
 9F0v6U5MgLsQk14FiTUk2u9AWQ598/yfYz2Jx20uIwRVO9pEkEmBxrIkzJFW+0fucxrSZoh+fl6
 Efbvlkqn64yIbBHI+gDXT4hQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 6bdb3bd2c51ec464;
	Thu, 12 Nov 2026 06:14:09 +0000
X-Mizu-Trace-ID: 6bdb3bd2c51ec464
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2] mm: list_lru: fix NULL deref when a folio moves to the
 root memcg
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261112061231.2469026-1-shakeel.butt@linux.dev>
Date: Thu, 12 Nov 2026 14:13:49 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>,
 Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Chris Mason <mason@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <46D53C33-558F-43A7-870A-F8BB7F176245@linux.dev>
References: <20261112061231.2469026-1-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 25D5040002
X-Stat-Signature: apdpbkjafrpyswub4a9te3egyyrzft9y
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794464050-251838
X-HE-Meta: U2FsdGVkX18mMJTsaMi6vV3U/YcQ0dQZKPp1Jef4dmPpvVFcaDFlG0KjhMBHzgfmxnLdU0tQYjxX+t4uSZq7QuU1vDx5nPKgB5MVQdGGcedOC1GRTENU7X3+yYE+ZGyZstwlC6rOtVJsARY02ZsoRScljrJgX1ERCEyggTOZ6OHORZ/01x468vexDyNsDOF7O1VFQlVGnln6qCMFhaV2plPbFPqJ35ORx0sXXz/IY11TL2BeeE6HsqV9N16ep5KIH8IM4DQw8+Jj6QJparRUDsZBeFi4jIb2pkKV/UOa2YFBZkEAXU91D03PAHwH50l00KJICM5bzY1MeAw1HxrCvZ0Iy4bl24Rn+9icI5NmSYsZh4CDovLyUVz8ug7F8B+MIJSZ7vgi29+gBHQuhtVCcDjjhL6Ab0+W79KQQWYifvz3CONBGIZFXGk+N1l5wEpKYLX83FHedgDyJ++A1bK/9bKHOQ0O3xXq/C1w43NZkxoZ1hHU/8bgCWHbNwZO6zQhuS1pjJaM3mrV4/LnyTLp/1eXYE0R19dKT76sU8g5eqc2uKSliJVhMt1KhCEiN60ZKDoUH5Nh5DhtmvRLDOBjz7TDWtIs0jid2vAjJY1pp+5ixfcbEgYG25/ePxNNvI/0Zr0kNwEj9oZJAxzugB32EZ0winYti+OaiLVr+eoHyWQIZBqiKXPezf5CaOKr4orF8qcJ1QOUDqqGhU4JiL32PfRit9jBWCFOO6FhD79avy2kRpT/amUNXCqTozZdO1CqV78tvWixpVCsA4QIsexfeLTF16S8uIqFVyeQw18wdy/KTF8bF6GFAMBd2VLN75KoWIuPAWNubUQzIk3+sJ08dpx7PiS1b+OZ3dYMFClrdGV5hOpdqfH0c5Hol+sJjV15DaMy75IcpBNmpogQyaShg7v4rNkK2dZY1ArdeaDRmuA2jrqwPocMOVRy9e5VgTBOprI1lAoUU68nr6anK93
 AvL/J3kl
 axyegdXH5cjHmZaxonf+HmnEfHr7++Q5U9gwOd4c6Rn+WwGNxgQEwVsP1ve/hm7kivFYRXxrkYuIbkcQfB7JcCQEfwC3RO3e7mIx9Ak5EU4lku0KOfWbeMkIEOTpW33M+/4SrEdbaTRjjgrOGN4UzyzwSukf3dmraSlmvzkHNJSNsj7JqhrYAUb0KY7BsQwhhvO+OS7c2IQc+rXC1cBhZ7khM47heYBN7qlTlylpjXNdq7FxYZxW9KlhdEhHGv6b97jWnwlMsZpGj6ibSqykUQOOfdDUpVKEaW8o9bbJp2Kh/Oo0O7Y636gMmT6fxOmE2pR7eE8vy9LE9SDKQexgYdAAXP4KOAXlOOUqNu0eHqcC9+/e/XHcvc2rx5gzS4H17Qpfi+NJMI7/084MnZ7Yo13Erdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 12, 2026, at 14:12, Shakeel Butt <shakeel.butt@linux.dev> =
wrote:
>=20
> folio_memcg_list_lru_alloc() makes sure that a folio's memcg has its
> own lists in a list_lru, such as the THP deferred split queue. It =
looks
> up the folio's memcg twice: a fast path under RCU checks if the lists
> exist, and a slow path takes a reference and allocates them. The fast
> path returns early for the root memcg, which uses the global lists.
> The slow path does not check for the root.
>=20
> The memcg can change between the two lookups: when a cgroup is
> removed, its folios are moved to the parent memcg. If the folio is
> moved up to the root in between, the slow path gets the root, and
> __memcg_list_lru_alloc() dereferences the root's parent, which is =
NULL.
>=20
> Users see a NULL pointer dereference oops while a THP is allocated,
> such as in a page fault, in khugepaged or at swap-in. tmpfs huge pages
> are affected too, and for them the oops can also happen in reclaim,
> for example in kswapd. The task that hits the oops is killed, or the
> machine panics if panic_on_oops is set.
>=20
> The race is narrow: the folio has to be moved up to the root right
> between the two lookups. For example, its cgroup is directly below the
> root and is removed, or has its memory controller disabled, at that
> moment.
>=20
> Fix it by checking memcg_list_lru_allocated() again in the slow path,
> like the fast path does. It returns true for the root, which needs no
> lists of its own.
>=20
> Fixes: ae64f07a6a40 ("mm: list_lru: introduce =
folio_memcg_list_lru_alloc()")
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>

Thanks.



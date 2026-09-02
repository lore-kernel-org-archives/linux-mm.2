Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA882C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 02:25:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 779496B0088; Tue,  1 Sep 2026 22:25:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7503D6B008A; Tue,  1 Sep 2026 22:25:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 619ED6B0095; Tue,  1 Sep 2026 22:25:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 389F06B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 22:25:32 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9C206A0674
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:25:31 +0000 (UTC)
X-FDA: 85167230862.14.79D3B9F
Received: from mta0.migadu.com (out-75.mta0.migadu.com [91.218.175.75])
	by imf08.hostedemail.com (Postfix) with ESMTP id 53D33160006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:25:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fUE0khxm;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.75 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788315929;
	b=ye/4s2k3+/IWDVpJoKSR31glee4jzzLS4ScI07kf5ESh2wPpwteViVb7/q/TRk+8fMhwbC
	9T2XgYiXG9Owcy+qLRJ/fS2dA9V4W7RsxLmLlCNN2ePT/CbE2RjXwyrnmZHauD5ZZ63eIo
	MC5OW9iqBPTFYKBbRmh6ENcjWe90yXw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fUE0khxm;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.75 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788315929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g8YdYj3d0J0mxfIwDKY70cjuetJdE0AgUcbLZxQzXG8=;
	b=tgfMYjWjpG3UeLbuxgiJlnoPjxLaWFLdSMZWoZSr0ghuUq9yEYqDQqzLz8rJNP+JrcpfPT
	exFFTXfn84ncqQdjJYHW8Cso/NjoHsXYEBJuu60+gUl9p7S8jXo6x2fKObtMWATkBr2bhH
	TsAGCooDsDE87jezJ1i0Oze47xg/ZcY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=w9xYexThy6hv38qHzfcNpGrcvAkA/9Do2/qlxN6IaAo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788315927; v=1; x=1788920727;
 b=fUE0khxmFyG+likThwC4wet/JjwniifGVFqYSv0jLQbZKpC7rQVUHsT70zpIjuG92x84luGs
 YD9CLsAM3ZwZqiP7f5bjxygQxmPPERZxcL7puubTE5FcdFrVyIcemmG70CZMj1Spty4SLu6t3w/
 DrgGdQcM+B/ygAGNfY8KA4eA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id d59dde0b280e3ce1;
	Wed, 02 Sep 2026 02:25:27 +0000
X-Mizu-Trace-ID: d59dde0b280e3ce1
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH] mm/list_lru: don't copy stale shrinker id from
 non-memcg-aware shrinkers
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260901115104.2944996-1-qinyuntan@linux.alibaba.com>
Date: Wed, 2 Sep 2026 10:25:10 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 =?utf-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Lance Yang <lance.yang@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Dave Chinner <david@fromorbit.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>,
 Xunlei Pang <xlpang@linux.alibaba.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <6285FA19-9A83-4BDE-84AE-CE2DA91FDA55@linux.dev>
References: <20260901115104.2944996-1-qinyuntan@linux.alibaba.com>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 53D33160006
X-Stat-Signature: zxhc1thxqmpsgyiawweiok5ccbdn9whm
X-Rspam-User: 
X-HE-Tag: 1788315929-91159
X-HE-Meta: U2FsdGVkX1+Wc+9Q05MyQiMcv4oIpTgZvnuXmzbKjV/i/p6dOmUJAWQy1R5Rd/yAjMdOgdOe8RGK2tc/Z/vUuYtOUQift348NyMuhBuUyH7N9cEfFL3bC+G4/vpI8sZCl3B4zK3/r5HRW+oB4ARXvRX+4h9nh+FANulxwRNwP5pQ5OD1vqZHjZmUZX4WW88qtey5T6NjR6xWm7smQcYfLsmQmmqv0tK7IQmEFJrtY/jM+8upxQHQpBsBJN+sf1/EHkcd4WU78AXaRoKtqjk0zBKSHQwEeUCEhLgz7+OLRcMiogaQsUO+w10YHxmgRcQLwEYcFxz9RQERFXkvMiQ3r95vrTE5YW1q/eoj1a0j1qp7k8iX6t9QwPwXSHe4dXOqBDgArLCfBzE1puTOQyz0IxDgaWTgc+vEXoHWJKEVjofyx3kASSYE6x9rC9r3kGONQkTbBR8R6ow/hjfZ7a+XViBJgWeQQE6unTVYxpzXNUmuR5QeceYGuNu67zVjaIVPXUK6ghPj6ox89X+hS/KEjr9Y5ItBETTRhXgK7pRHcty5RUddnbBblGj+YmMzkPgpj9dkFg3jpEI7n04pWwfOd3qAEXfwtZIKd0nGxs3gFZNEFO4MPZWKkBxHgNFeK1wvetSbjLd4/1dJkeQB+BF50dpcvLlGSdasN1oZnWXV/FsRzHfVyO4ICFikLu99jkHJ5v+m1CQuvb23JmQcTN8q0Gitq1nwjwsmAa29/D2zYUoSzr2SDpG7Qm8iWkkGBzNuLNyNrYxaaWpkArJsjKsRdn1Bq4C4NBir97pHaQ6achKvqnoxBgeep8Wj4G5nal4W9CW4hNZVLHflugsfliEtGi5UAv6p6AHShRqvcEsKakCoFXK/mvfiBZxTJkcofxR/O6MTgvlSEt+gvdPfYLu2omgzAROitzsPsqeTSgmmFUNIS0qUNlxy5FKCX0IC04oo0lee5yBeQekzaS1DAoE
 lrzv2zLi
 I/DWuh30oVFgT3uKUbKAS3fIXbSfJwM0c0wE82lOPzH/IBmFKN6DVMBq9/Ev5TDTi4ez0E+YgdnvSR2Jm8xCPRxlP0DCs3GgSgOXiFHzdTCSpEWWC7VtY6mLuNYJ5DiZvfDoLhTDQezV6I3CLahKI8PXrYkRpoHJl5J8JOxa0z06F34yNulKb2VcsUhfyQAzG1Qab3sPLqRmZSMHLCIiH/ip5/PCZGXLZQ0XRMRP+CY0u0LS18WhyxJlvT4+7gKdM0hXaevGhT1SSRlYyqJAHe7ZSBVshSTFQ3hqwxGYTrMyaQ1ZFt8nsTumEzFgQk/OZJbDWvFaBceEtl4/Wuq7G7cnRibllO5BVnOsiJGgpNJYEtrgKbYSQWtbf2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 1, 2026, at 19:51, Qinyun Tan <qinyuntan@linux.alibaba.com> =
wrote:
>=20
> With cgroup.memory=3Dnokmem, shrinker_memcg_alloc() fails with -ENOSYS
> for shrinkers without SHRINKER_NONSLAB, and shrinker_alloc() falls
> back to a non-memcg-aware shrinker.  On this fallback path,
> shrinker->id is never assigned and keeps 0 from kzalloc(), which is a
> valid id belonging to whichever memcg-aware shrinker registers first.
>=20
> __list_lru_init() copies shrinker->id unconditionally, so every
> list_lru backed by such a fallback shrinker (thp-deferred_split,
> zswap-shrinker, workingset shadow nodes, superblock lrus, ...) ends
> up with lru->shrinker_id =3D=3D 0 instead of -1.
>=20
> Under nokmem the list_lru collapses to the shared per-node lists, but
> __list_lru_add() still calls set_shrinker_bit() against the memcg of
> the added object.  Most list_lru users are unaffected because their
> objects resolve to a NULL memcg without kmem accounting, but the THP
> deferred split queue holds user folios, which are charged regardless
> of nokmem.  Since no memcg-aware shrinker can register under nokmem,
> shrinker_nr_max stays 0 and every memcg's shrinker_info has
> map_nr_max =3D=3D 0, so the first folio added by khugepaged triggers =
on
> every boot:
>=20
>  WARNING: mm/shrinker.c:212 at set_shrinker_bit+0x99/0xa0
>=20
> On systems where a SHRINKER_NONSLAB shrinker (btrfs, xfs) did register
> and expand the maps, there is no warning; instead bit 0 is set
> spuriously for an unrelated shrinker.
>=20
> shrinker->id is only meaningful while SHRINKER_MEMCG_AWARE is set,
> and all readers inside mm/shrinker.c already check the flag before
> using the id.  Make __list_lru_init() do the same and fall back to -1,
> so set_shrinker_bit() is never reached with a bogus id.  The stale
> shrinker->id itself is left as is; cleaning that up is a separate
> topic.
>=20
> Fixes: 03375203e1da8 ("mm: do not allocate shrinker info with =
cgroup.memory=3Dnokmem")
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.



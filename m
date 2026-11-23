Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC0EF606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 12:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aqwbha+h
Received: by kanga.kvack.org (Postfix)
	id C92876B05B5; Mon, 23 Nov 2026 07:19:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2C236B05B6; Mon, 23 Nov 2026 07:19:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B41946B05B7; Mon, 23 Nov 2026 07:19:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 904FC6B05B5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:19:01 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2CE01A06B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:19:01 +0000 (UTC)
X-FDA: 85466288082.08.3C8DFD8
Received: from mta0.migadu.com (out-117.mta0.migadu.com [91.218.175.117])
	by imf20.hostedemail.com (Postfix) with ESMTP id F14621C000D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:18:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aqwbha+h;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.117 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795436339;
	b=sJ4gmr6Y7YX4LV94F7/s7y/Ur/e8M4yK5byfMKDZvx2nxWyuZZ+FnNB04f5fGMh983x38O
	Veoy4TtmcD3+NylsxnPmp/0genDo+xFM3vP6H6ho18MyjgmRPhJbOjibn4kWrWxy6gVxjc
	2FHPl2zLuM2wrtxrO7x3MP+GWSPEwNQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795436339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Umx7MqyJTMzSudUEtA+X42/QrmhwHdMbkOzHYe3yn10=;
	b=UjnJOJCpYZiOYbnxSK7lob8c/T0LQem1rpVExIC6YY1oD+Qv0T4rFdjBwQ+q18y1sdED74
	r6ODaxScOQT1r+SFNNm/C1gcNSI3SjKEovilzJWo9YgdNQPR9N4YMeYqSyw5MIP6V96Emb
	OJ/eX1StbNmAZPXwSgNWyDbzw/vbnLA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aqwbha+h;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.117 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=44aP29+UWm9Uwp23yiAW0fp/EtdX6KADHVMxQNJBNNk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795436337; v=1; x=1796041137;
 b=aqwbha+hyfBDZhWUNqz4ZzFxa1xELUJbuhAClHTwlggj7XUGATKcJT2xL9PdrVKmHMbDMfyt
 rAoFc52clIj5jZAEG+cCKA1mF7jcQu1j7vQw6pSA2DR8M0zPS+Ulbq8FQG2iNXd5lPTJVkEUcDW
 U+bt/BXUV7L233IDPzaKJDEg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b23c8eacef55c129;
	Mon, 23 Nov 2026 12:18:57 +0000
X-Mizu-Trace-ID: b23c8eacef55c129
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v5 4/4] mm: zswap: mark the zswap shrinker
 SHRINKER_NONSLAB
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261123105334.2524066-5-qinyuntan@linux.alibaba.com>
Date: Mon, 23 Nov 2026 20:18:41 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 akpm@linux-foundation.org,
 Johannes Weiner <hannes@cmpxchg.org>,
 mhocko@kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 mkoutny@suse.com,
 David Hildenbrand <david@kernel.org>,
 ziy@nvidia.com,
 baolin.wang@linux.alibaba.com,
 usama.arif@linux.dev,
 david@fromorbit.com,
 Qi Zheng <qi.zheng@linux.dev>,
 yosry@kernel.org,
 nphamcs@gmail.com,
 chengming.zhou@linux.dev,
 xlpang@linux.alibaba.com,
 Kairui Song <ryncsn@gmail.com>,
 gourry@gourry.net,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <89133112-E096-48ED-A4B0-E64EE319B53A@linux.dev>
References: <20261123105334.2524066-1-qinyuntan@linux.alibaba.com>
 <20261123105334.2524066-5-qinyuntan@linux.alibaba.com>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F14621C000D
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 5umdkyadwpkuidkd6ef8qmyzk43jbice
X-HE-Tag: 1795436338-368873
X-HE-Meta: U2FsdGVkX1/aCZRzaHZ10e6dA1fRhtA6n4BPPAgLQodoO3Ec8l2hrSCRml/aBQZcKyamqobxBkbnYsjowBBKzUOvcEBx9iU9Xa2vnBzIVqiibzt7yPFaB1GNhVwV44xFpJEfWVYNvJL9Osf8t4F6x942SJ7AJalxe58NlkVYT/wM0LYebXEy4mF/0A2cjB9KaRh/uHGrsqdtqk6VsSr57p5Arrt1e133mC14rdWRbmtzquFH4Zdy9DdqJ1+pCg/xUQcKbWJc7jNAmHJQHtEHEvkcsIq9Q1MJm8cPEijBbPCGPLPLLpZQoLcimZFJ5E3EVTsSn5i77DE8+1x7JCXqQSoqgpNbN3chernrxaDfzXZc2IDaT4TCkIGeto4aezrwZYwyWQ81KctMF3JefdrLT/tNhORuKfYl/8qy0l/VWuROEssdZIYElBcTmcSpxLsxNOZFOYQun9NDmF5lLQQY8Xl5X94NlDQwuQBYMmEaq4M+KnEBI0Zp269MwAwhIap7ahuwi9TI/W9+yIt6JOf2Gy5jBhWntgQvnw0jbsY0oXIeH0WQ5P2uwk3gdJBgBgDgUcvwpLG4n0hL9sm+1GgPJ0Mv3GJJGxB66FZdr8IYpDAWvFwybRRbd6vPsIQlJhM5BP5JSeLPO5FKzJcMmc+I+3DW8lXP1Z+8pQvvBsQIZy6Ici2j6rWIiXQ/tL0nIx/hd95chzXM/LlDuEA5U0gYv2QyZYd1yEtQq1CY3pdjbV5hXrf9eOWoFeSFxwi6XzyobXyPgoJWQsR1vvaS7iexbtasZRtsQRqPl5fn5L6lm2Mv1gljhzcUI76d3z6Uh4DmHjh4WXfIx7K4xewPjHBExAPFE32pn6OXzcsOgptEslDBx3zlSVTJJFOtuLohXlIU1ghVnUYWgagRL4F+uoC+fX0ntj3jy5Qo1+cWvKwbYdHyEyDWB0AfpG8laFSwhDjkBLCZq5/5LWY+gbUzHP+
 CuChz9Yo
 JD35P80tbDFOOPlV3AuyhTIWCOM69BZ96NId1CxKBPOpAin+sPv97QyhYHXya9OC3US9zjl5vSv5lpNVeqy/bDtqrEse5CYKPNjZs70Js887KQQjV3Hwmu57lNJvIwNh8wgw5szJ2ip99HBDqupOCALJdshBtJbQi7upbJFycB6hQ+Houwow0JVP+SiQC9L4Ub+cusm2kJF6yWK8cEfILCxRyIOnfdQKt7NaPVoCQd+boO/fS7zyrptZDLsXQ8oi68cL+D7f94UPZFdfpqVDvTjFqnxRYF2jkap22Hn4XhUTKbZyu+3l9IyPkEpI9dFJZg1EiOvHwOi++lO1p73+CbuElvEi4Ljw5WUJhHIs20b/3uJrQmzZR9WP3Qjo2BkChJLwoVdxpwEfzieXzv18hVjRpmetw1g7oG1Ogt5uejrKtQvuJwc0LqmvRY5/UWzXRhWNjR7cV/N5lHXCRqsSQV8U8qYiTNwNfJZ180iV8MDESWsVvbg184NH0hXz5yNzzye2hPrGkmjoRoP6izrIwfhR3B3JcDYCpBcn3Le+h8qfXXLhvN4+04S+5czhdEUc7siRpKx5Kr5l4jTJfhF3rJSSozdh8URpsnofnUyiimPoZgZBG6u7mkruqcfgFTvDriI3gMgnVFpgdf8hd5HxCZqBm+BAWSXJixaKrA/OP916bQ35fSj9mZspAAiWRU7yWWEnKIpNYTje2zU4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 23, 2026, at 18:53, Qinyun Tan <qinyuntan@linux.alibaba.com> =
wrote:
>=20
> With kmem accounting disabled (cgroup.memory=3Dnokmem), memcg reclaim
> never invokes the zswap shrinker: a cgroup under memory pressure does
> not write back its own zswapped pages to make room; they are only
> written back by global reclaim or once the global pool limit kicks in.
>=20
> The zswap shrinker is registered memcg-aware but without
> SHRINKER_NONSLAB, so under nokmem it is treated as a slab shrinker:
> before commit 03375203e1da ("mm: do not allocate shrinker info with
> cgroup.memory=3Dnokmem") it was skipped by the !memcg_kmem_online()
> check in shrink_slab_memcg(); since that commit it is demoted to
> non-memcg-aware at registration.  But the zswap shrinker is not a slab
> shrinker: it tracks zswap entries and resolves the owning memcg from
> the folio's objcg, independent of kmem accounting.
>=20
> This was noticed by Michal during review of the patch "mm/list_lru:
> don't copy stale shrinker id from non-memcg-aware shrinkers".
>=20
> Mark it SHRINKER_NONSLAB so it keeps its memcg awareness and runs
> under memcg reclaim with nokmem.
>=20
> Link: =
https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.al=
ibaba.com/
> Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory =
pressure")
> Suggested-by: Michal Koutn=C3=BD <mkoutny@suse.com>
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> Acked-by: Yosry Ahmed <yosry@kernel.org>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>




Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1713A60703A3
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 16:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fd8jM+9R
Received: by kanga.kvack.org (Postfix)
	id 3DD266B05B9; Mon,  2 Nov 2026 11:04:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B4DB6B05CE; Mon,  2 Nov 2026 11:04:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F1366B05FB; Mon,  2 Nov 2026 11:04:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E0A86B05B9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:04:55 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6EE8B160197
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:04:54 +0000 (UTC)
X-FDA: 85390652508.27.A2D7881
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id B1C0A40011
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:04:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fd8jM+9R;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793635492;
	b=5hV27D996d3YRygfgSgoho4auG2SdkCxDvhpg23heynyq7uLpRZrpOlQuvoBxT4XO05bvr
	G1WVDk4AzzStfQGv8no9IcTlvdHoYzsG/1n4aPU0xmKIR5ZdKszMTOyVouxOMg74GxOo13
	BAWTZZee/yN9TPbt98b3zLX24eK7zIo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793635492;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D7HT4U2uiDz51OL81GkMtDUF2WFwcL/yrqM/3r32/DE=;
	b=Xr6fYSkFgUmKBCU+5wVlciliMwPirix2s8Z2VdV2yhGZzJK/PSMC8bQwiQKJk5lp+mr2i/
	s4YvOG9iOm7Zev/z4nSDtC+WtZNj/v1k9llMXbV4IA0C6/y2gkRs45xRrIuBItRIU3kTev
	GV1Ug/PA0XY2tQopcV04KmOaaBAt8oM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fd8jM+9R;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A46F437C4;
	Mon,  2 Nov 2026 16:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366411F00A16;
	Mon,  2 Nov 2026 16:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793635491;
	bh=D7HT4U2uiDz51OL81GkMtDUF2WFwcL/yrqM/3r32/DE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fd8jM+9RC79Y8zKIK/O1HR7J2nNN/xIORipny6YB9WVK4uS1POF1Oe2vJXjKFJDI2
	 50xk2YvIpGxt0+Xf5lPoImTpL95UmIJUv/i3KLM/SEpVSuExFw6NFi6oTL60mKUXPt
	 4QrE1SgA5KjdafdmFQgBnR8wNsnayk9ZmWJu0zRHzuXfDx0fC2zc4NKaIZ62Wo4UEn
	 jzH0fqmXp61+AmYRpSNmt98mZJNQRt3fqn4z8hIbX5Di/fcY6D9VzgCLC/8i51HWXf
	 yQ6/Eb0pfmtF6pmvRv9Y1S9aUOB0HvofPD6/vrFKkE9SvPhiE0d/i6ICPUKf05fYJj
	 Ce7pG7iVt6IPA==
Message-ID: <sashiko-outbox-193727@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 1/1] mm/mglru: age when the oldest generation is
 thrashing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Maxim Muzafarov" <maxmuzaf@gmail.com>, linux-mm@kvack.org
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Kairui Song" <kasong@tencent.com>, "Qi
 Zheng" <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Barry
 Song" <baohua@kernel.org>, "Axel Rasmussen" <axelrasmussen@google.com>, "Yuanchu
 Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Yu Zhao" <yuzhao@google.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "David Hildenbrand" <david@kernel.org>, "Michal
 Hocko" <mhocko@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>
In-Reply-To: <20261101160427.85701-2-maxmuzaf@gmail.com>
References: <20261101160427.85701-1-maxmuzaf@gmail.com>
 <20261101160427.85701-2-maxmuzaf@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 16:04:49 +0000
X-Stat-Signature: fwof89ctry81rfm44k56nif3thj6ht4u
X-Rspamd-Queue-Id: B1C0A40011
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793635492-620704
X-HE-Meta: U2FsdGVkX1/qPH195VUJHxjXkC14yR1JpHQRCQwiqjBj2h2AqbAYfDqSn5DGIJXat5wxm/f2dJGWaDBmzmtGw7T1iPkUMFU2FqmsD+roETVbMkXJULRGY+5K8QDnk8Sz0fHuB0tQWIQV0SAipSUm606FN+pwMl2L1vSXz3EbvrpK/CrF5ml/g2a7wLu6Z3035qCKcrTqJjDBSFNpVweufcQnM9DPGYciBwqF4Y/xqp5V4YYC5oqysOhXqc3ZPAItVH6qLveaX6HxO2co3BA3iDvLJWOgKQfHPgajpU9/rDO9zDuuui+t7MATYAVwo6cJR2InKmi3bph+euSHjeeQAP+/CGes0W1SSqUrfw8yXM9F+qdksxi2S/qtVL2XdVfQ+a9gFHECp9XWzIzercGx64ns09BniPd/v1Q7U4Mg9OA4GBfOZKMv5IsZMmVo6LDz1mG4NxhjxnBop9EHiyWTQBdetaz0RoB/s5T1w2AkOgtX2G9qIeXCuvy/k1bCj0Cw2/qOKGgiQAggp83+2BD6u7YHx57ULRhLCZxbshqZUwBl212qmrkJTLZy+qUmtY12SHf6SffXS6i9Du+frh23ToF9MLQYXNltt27K534rbwN6boY7TXBUPoLOSQHL3wfHg6J+Vn1hyxcRUDpWalqLpmMHkNHRJ4l6coxHJe3YkMgUULr5S4+coQ7jZ6J+V0d7saJ/9x9j23+f3cBBOhbVb7IAW0T5qchz86Sz6X7id5rH4YrATVqD44M0t/1shZTBmH6PqMbJzmCpATbtTmYn/QORwYqe0Di9Jh4uj7fyc2w57tiLukijHTrFmpereuW6H5epVbLXsFPQsWKwFJBpWI0A3d+STozMw2Iyt02EBnqbMWiFGNXM2G0263OkUb3vDEXPvCBxiAoCjF0MOFsps8feWOq7TKynfCWaIwv6a5hgm7jrOdZA8EZOyJnVgCLXwR0Z6V5UFr12ZqLEBq1
 CBkW4xvT
 +A5AapIorHv8YNqucxiRy6ASUfP5YSHon963/W8GmXHQMMPN9CU6QEB7Jf1DeTKZj/bV4f8UNFcWRqsg0vKETuooHkI4fSos88NdFCqzhvrYqF/1MXRp1+2AOOyu5kpo2FkrSH9FyFRB+kevl3gT3kDDIUXwxAjY/khwb8e7EOeXOytE4EdUF+NVomIiUU1HYECH4r4e1Pw0Bj9eOuTBL7ge4WWa5yWTevISQt8tsw6Ws2cesG7eG+BEPrbR3mP8M9bZh8JA9kGU+SyimdaRqeOqWmlX39ZnP+DHEBpYmOQjFri+e5C5TlsFPVUBi7xnvOc1GYow/YuczkOtgIVa4sCUqBZWd6SHbCpOG8Qi//12J2RjrujWEnbt9zDYGW3raDExFiT2lIvxs2VY8WerJeLJnHytwyeZM+oIiyc8vAfkMf0+j5EhO0Pg5sMR2DVAaV7FqCTSjr+ap48AhdyxcK1gQ1tcmlzQhnmj8JhekUPzdOhWBxqh5gCm4a8L159ohkq4l0hO/x6j0/t7enjdJJOYwHaOq2AXhzKFh35ePWS4C8hcKm8Zzv7dEUbg7ZrBq11MmpMBycCT3WHaCjx3h0rRgw3XnppP2gsNIgbe61yDeNDupadkRFo+vaZnMBjG2V4n8
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
- [Medium] mm/mglru: repeated back-to-back aging in oldest_gen_thrashing()
--

commit 17216aa0e22cf9bf70e1a34fa529d94d53089f2e
Author: Maxim Muzafarov <maxmuzaf@gmail.com>

mm/mglru: age when the oldest generation is thrashing

This commit triggers aging in should_run_aging() when the number of refault=
ed
pages in the oldest file generation exceeds the total evictable size of the
lruvec.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f11491ee9ed5c..f59b29723ec94 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4966,8 +4966,26 @@ static int evict_folios(unsigned long nr_to_scan, =
struct lruvec *lruvec,
>  	return scanned;
>  }
> =20
> +static bool oldest_gen_thrashing(struct lruvec *lruvec, unsigned long *m=
in_seq,
> +				 int swappiness, unsigned long evictable)
> +{
> +	int tier;
> +	unsigned long refaulted =3D 0;
> +	struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> +	int hist =3D lru_hist_from_seq(min_seq[LRU_GEN_FILE]);
> +
> +	if (swappiness =3D=3D SWAPPINESS_ANON_ONLY)
> +		return false;
> +
> +	for (tier =3D 0; tier < MAX_NR_TIERS; tier++)
> +		refaulted +=3D atomic_long_read(&lrugen->refaulted[hist][LRU_GEN_FILE]=
[tier]);
> +
> +	return refaulted > evictable;
> +}
> +
>  static bool should_run_aging(struct lruvec *lruvec, unsigned long max_se=
q,
> -			     struct scan_control *sc, int swappiness)
> +			     struct scan_control *sc, int swappiness,
> +			     unsigned long evictable)
>  {
>  	DEFINE_MIN_SEQ(lruvec);
> =20
> @@ -4975,6 +4993,9 @@ static bool should_run_aging(struct lruvec *lruvec,=
 unsigned long max_seq,
>  	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
>  		return true;
> =20
> +	if (oldest_gen_thrashing(lruvec, min_seq, swappiness, evictable))
> +		return true;

[Severity: Medium]
Can this trigger repeated back-to-back aging passes when the file LRU has
fewer than MAX_NR_GENS generations?

In should_run_aging(), oldest_gen_thrashing() is checked without verifying
whether the file LRU has reached MAX_NR_GENS generations (for example, when
there are 3 file generations at DEF_PRIORITY, or 2 file generations when
min_seq[LRU_GEN_ANON] lags behind min_seq[LRU_GEN_FILE]).

When oldest_gen_thrashing() returns true while get_nr_gens(lruvec,
LRU_GEN_FILE) is less than MAX_NR_GENS, try_to_shrink_lruvec() calls
try_to_inc_max_seq() -> inc_max_seq():

mm/vmscan.c:inc_max_seq() {
	...
	for (type =3D 0; type < ANON_AND_FILE; type++) {
		if (get_nr_gens(lruvec, type) !=3D MAX_NR_GENS)
			continue;

		if (inc_min_seq(lruvec, type, swappiness))
			continue;
	...
}

Because get_nr_gens(lruvec, LRU_GEN_FILE) !=3D MAX_NR_GENS, inc_max_seq() d=
oes
not call inc_min_seq() for LRU_GEN_FILE. As a result, min_seq[LRU_GEN_FILE]
does not advance, and reset_ctrl_pos(lruvec, LRU_GEN_FILE, true) is not
called to clear or decay lrugen->refaulted[hist][LRU_GEN_FILE] (while
reset_ctrl_pos(lruvec, LRU_GEN_FILE, false) only clears max_seq + 1 when
NR_HIST_GENS > 1, and does nothing when NR_HIST_GENS =3D=3D 1).

On the next iteration of the loop in try_to_shrink_lruvec() (such as during
cgroup or proactive reclaim where !root_reclaim(sc) continues looping) or on
the next reclaim invocation, should_run_aging() will see the same un-reset
lrugen->refaulted[hist][LRU_GEN_FILE] > evictable and immediately run
try_to_inc_max_seq() again until the file generation count reaches
MAX_NR_GENS and forces inc_min_seq().

Should oldest_gen_thrashing() also check that min_seq[LRU_GEN_FILE] +
MAX_NR_GENS - 1 =3D=3D max_seq so that aging is only triggered when
inc_max_seq() will actually advance min_seq[LRU_GEN_FILE] and reset its
refault counters?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261101160427.8570=
1-1-maxmuzaf@gmail.com?part=3D1


Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0328606A329
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 21:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AiJIVafN
Received: by kanga.kvack.org (Postfix)
	id 460706B05B2; Sat, 14 Nov 2026 16:27:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 437CD6B05B3; Sat, 14 Nov 2026 16:27:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34DFC6B05B4; Sat, 14 Nov 2026 16:27:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 023566B05B2
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 16:27:23 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 67A9BA7FD6
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 21:27:23 +0000 (UTC)
X-FDA: 85435010766.07.D946645
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id B15761C0006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 21:27:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AiJIVafN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794691641;
	b=KJY0gsLtj+PhKMMsJx7AKR5ZenZOYFaVfXeIDA3r9PpUU8p2g/vaHKtNhHbJJsBkWSZZQw
	6hK8yRGGxfiZcgqFkwPL/EYqc1fCuSUwnLiFSs+t7cBKS0aWDwg/kQ+3MIjBi54H9Elq9h
	mw0NGlw17ToTHnls5/KZnozZu0iPR3Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794691641;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qZSiupG5iaoOXhGl9HUAM4GxvoxjiY1Ftvd35eyAU+U=;
	b=0xlIcuwbJ1UrH42LvkG4yB9P4KerN7YM2+2HQ9EHC+KeCokv9r8JtIuOeiNn4K3N3vwDdQ
	+VXuh0H+NgBG6NwnBjOlhhE+JOreabrElMT0kxwSDFwsGwoXbbBdeejdEe0CSfLb8hboki
	kAk0lsVBF9FkpD0Hvwtd2ZiFeQg/XX8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AiJIVafN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1306645ADC;
	Sat, 14 Nov 2026 21:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD4A1F000C4;
	Sat, 14 Nov 2026 21:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794691640;
	bh=qZSiupG5iaoOXhGl9HUAM4GxvoxjiY1Ftvd35eyAU+U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AiJIVafNpHHmr9/TMsS3FHrsQ1AxUH/CG9mY6dFxHXDfGV2fut42tegMgJGtYOKNo
	 Ju0rqCjhHvNcDE9h3SH4QoWOf4ADlkbAD9nf5ZBAOeTwVOWkvoaJJYFDoCHPVND6p1
	 hze7N2dbsW38+Eicv7HLaPE6T23/TkJgYB7mCo89rIzxUDdMZ0jNGlYdyZDdlxKxXX
	 b9Oqtc24gYPc+1K6pbFnV3UjffYcbaOMuLn8JYKIyeixvZzwqJgKqPlHeSkUfwizVa
	 pwafCduhB9EwhmJbb2WB0LhClA/Rh6ewpf6N8AizH340vjHvlSdgsAYEoinPW0r5J0
	 SmvZVnemtfAZg==
Message-ID: <sashiko-outbox-215048@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 8/8] mm/huge_memory: walk the folios reversely for
 the release loop
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kairui Song" <kasong@tencent.com>, linux-mm@kvack.org
Cc: "David Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Matthew Wilcox" <willy@infradead.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Johannes Weiner" <hannes@cmpxchg.org>, "Michal
 Hocko" <mhocko@kernel.org>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Barry
 Song" <baohua@kernel.org>, "Axel Rasmussen" <axelrasmussen@google.com>, "Yuanchu
 Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Zi Yan" <ziy@nvidia.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>
In-Reply-To: <20261114-swap-thp-split-v1-8-dfa8d4fa448d@tencent.com>
References: <20261114-swap-thp-split-v1-0-dfa8d4fa448d@tencent.com>
 <20261114-swap-thp-split-v1-8-dfa8d4fa448d@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 21:27:19 +0000
X-Rspamd-Queue-Id: B15761C0006
X-Rspamd-Server: rspam12
X-Stat-Signature: 8tzow57u9o9s38eygb9e7q6d1wnubu1w
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794691641-566067
X-HE-Meta: U2FsdGVkX19U4vMf5QrAyvMoXPGFckPq27LFQzSFeLcZbVj3Kg4bHZeA4NwCwSC+BLH5Iu3WPJ045mRwCgF/VEahPkarFmVp1ebNXyVDPHgCSp50/1HHew4vIG3w6B/0JruxTxtDfHsuRCC2/SSnfRksnQel7o2lZekR/k0AbrCOVZ55hOYB9EHu0jMY076i4Wu1k63O4MBjr65jpMEPCtENdrRBWrnzWRmS+e7V3eBxU2dDGnyjSPzVhXijjchggtWttck9EjUPfV5E2XNwI1AQBO56F7y3HWGPwxHttNd7OfnlNQyF2kI2swqRKsRtv3vho3Tki5gLg86ga8M4+js/yflJH9GSNtSk4QWttJkPIEvK/tWhmQf7ViYkz0tVplpRTkAew6ZLMPxsmOsxltzdbNt7eO2qLf19IfTYUROGMQwXK/+qMDsQ7M2vfMzUF7QvmrbJcnEnSaVamMVzTtZIk9rgl8vz+kcZAQstRt6xbHd0aioG3mQqQfOSSYEvAEEtSgshohyIi9XAQ3X1QvVhmtkKo8pKMvEdIvN3NmTN2sDYVAPTQawy/iZ55Xt2J6AjbBT+nIhZ0el9WLhv/FEXxTMQqWR5+zIFDOKUv91s0o4OKKXGJFq/UAGmjtXPcquOxaTMjY3pq97qLEvNJC5VOjCNAvSuNItshuQrASnQRupa68lLtzZM23+Kw2FOKlDUL8raMJL2l8riKd/EhBTmakuxslN27LkjBk5PFneWbgobXi1TA1c+3KXFp/HeyDmIg7mWHazX/Axr1gKW/A4D+DGFfy2KIxbLgwgNRfxOOllZbt8L2xcQmq47HxTW7JgKs8E3b4psLo31ZHIOV86KIO4xOn7bRpp2xt8sFqgEC/nQunZ7yh7ZaoAkVb2F0xcxV+1/mn4UOfH8u62kyEkj+7nDjQUCtV9k7DJQYjIhtlMOp3YuGq5aBnW9a7D9RM/g0SRUduizC2js2FS
 JT9jbhvX
 QxWoDHQuGjSl06q6v+Ogk1gxE3XqJxlliDBQgLccKHG49Ehdbj5vLoVxC0JjRF3J3heoa7rY93ZrnnaBGR9nKdvp/vFJvrauMY/VHWriw6xpVy3YMl1sbq6IPnISxkuvvMaj167YqVnBKmM0KqHNA6SBnmJu01Hlj6LtbF7gaKRvKoG/LooQ8TFXRQccHJbQLepgH8NL+8s1S0M7BvINI2y4NE0PoPvCca2GHb7P8mGab0QRhLfd6zdjEnMjQAy4qFa+TS101JUWuCDhVZ2xhl6awkPYGxSvoM53IwPRGxr8f2PR9CSy5w72RYZs51IVAjceEt/tOR+n+aCmyMxO6UlumhHwZJqk0433QJm5xtbcgpXuJa/3H8jsOc10Xqe5FQwmlyDpVSAcveUC2SPCzB/i/Ys6prCZlZP+KT6VLDi3B0+pjkV6jYHdFcP8bX2d0NXgPYeF1622i4nPNnjdvBZh+ZpFP2y+nt9zyCv4Zs+Qm56Nn2zQqx3XQzIUqF49VNq8fOdZFL/xgQIzpees93IcNZRJbvTdUGOXs8SU2CPv0aE8CCYdOinOKgsjWGHGHCPJ2PPI4emtHja4qUN5ErNtGjnANSBUUCUfRFJM33pMFPP0+QoJVLqhHV9aussiqAtXxi/D2r3KQSudRNN2l6CtrGKxXA2oQNDqw+BlXFN2mrkEYXBBJZb0sscYweZMrqN8DBiEKOjempRboe/ywero+Vt8Iqdip6RsPdJcWctA1w1fiM2GM05Ke9s8XOpbQ3EDxVuaR799j05EwQsD9ROkguSXKilAzvA3BBRSNcCBG5Et2QReoaCQeNNfrsPmzcVAc2rOOyW3F59M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] mm/huge_memory: __folio_split() skips unlocking and putting
  first sub-folio
--

commit 896336ac7b9114a702349806a3b2f69599192c04
Author: Kairui Song <kasong@tencent.com>

mm/huge_memory: walk the folios reversely for the release loop

This commit changes the after-split folio release loop in __folio_split()
to iterate backwards with folio_prev() instead of forwards with
folio_next().

Link: https://lore.kernel.org/r/DKJSFCLP967N.YBR4DNK1NM2N@nvidia.com [1]

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2ff201a5e5f3b..bb09465a39488 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4366,7 +4366,7 @@ static int __folio_split(struct folio *folio, unsig=
ned int new_order,
>  	const bool is_anon =3D folio_test_anon(folio);
>  	const bool is_swapcache =3D folio_test_swapcache(folio);
>  	int old_order =3D folio_order(folio);
> -	struct folio *new_folio, *next;
> +	struct folio *new_folio, *lock_folio;
>  	int ret;
> =20
>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> @@ -4399,9 +4399,10 @@ static int __folio_split(struct folio *folio, unsi=
gned int new_order,
>  	 * Unlock all after-split folios except the one containing
>  	 * @lock_at page. If @folio is not split, it will be kept locked.
>  	 */
> -	for (new_folio =3D folio; new_folio !=3D end_folio; new_folio =3D next)=
 {
> -		next =3D folio_next(new_folio);
> -		if (new_folio =3D=3D page_folio(lock_at))
> +	lock_folio =3D page_folio(lock_at);
> +	for (new_folio =3D folio_prev(end_folio); new_folio !=3D folio;
> +	     new_folio =3D folio_prev(new_folio)) {
> +		if (new_folio =3D=3D lock_folio)
>  			continue;

[Severity: High]
Does stopping the loop at new_folio !=3D folio skip unlocking and putting
@folio when @lock_at belongs to a non-head sub-folio (lock_folio !=3D folio=
)?

__split_huge_page_to_list_to_order() passes its @page argument as @lock_at:

mm/huge_memory.c:__split_huge_page_to_list_to_order() {
    ...
	return __folio_split(folio, new_order, &folio->page, page, list,
			     SPLIT_TYPE_UNIFORM);
}

When a caller such as try_to_merge_one_page() -> split_huge_page() splits a
large folio on a tail page outside the first sub-folio and then switches to
page_folio(page), the first sub-folio (@folio) is never visited by this
loop and remains permanently locked and referenced, leaking @folio (and its
swap entry if unmapped in swapcache) and hanging any task that later waits
on its folio lock.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114-swap-thp-s=
plit-v1-0-dfa8d4fa448d@tencent.com?part=3D8


Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB847606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 22:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NbUArfCH
Received: by kanga.kvack.org (Postfix)
	id 5E37F6B0BFE; Fri, 23 Oct 2026 18:03:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 594B06B0BFF; Fri, 23 Oct 2026 18:03:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E7E76B0C00; Fri, 23 Oct 2026 18:03:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A13B6B0BFE
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:03:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2CAC412029A
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 22:03:46 +0000 (UTC)
X-FDA: 85355268852.12.13DD2AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 82D3D4000F
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 22:03:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NbUArfCH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792793024;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SYupoWjnvpZHwGcx2h9dhHPsH08GelOdGJLACM2ZLo0=;
	b=M0RgKpJ0sKgDiv/oXbyBa2xcrpGQzdkYGJtt5PwGiy2zdYsFBsrNYkBNcNTyz1su3+T2ua
	f0C1p5Jtq1ai0CvT1lUODU0exkcl3SNW3cFAoQYSDhpdLgsuAyxVSxzYQzPCB2HmexY0x4
	o3KaNjlE/BmfilEat3AGk8hMYD8t27k=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NbUArfCH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792793024;
	b=hDGEw1l2DmxN3YuPqTl+YrT/7S0+yiSELA5TAj0BwQBGkJVlIHnzQZHyXCuoCjRfiP9qOR
	1LeO6gJBUdSUIFfV+mRy1j2ddcpyuz07aTMAMB3yBahU3mwxTfTI74ykcIkkVsCoYQRuO0
	oqNx2bH9TKY3D+hkVae5Xg0wjNc1548=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4DAE6601DE;
	Fri, 23 Oct 2026 22:03:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2A61F01825;
	Fri, 23 Oct 2026 22:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792793023;
	bh=SYupoWjnvpZHwGcx2h9dhHPsH08GelOdGJLACM2ZLo0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NbUArfCHZoEj0CljcKBEqA52ByuPzzhLdeC+nqDcimkbmMF7NyuDN59cTTLuMo7q/
	 Fe47qX8SCyEGRmpFNCKqBChGX+wQ/SF0ocgBDvLQEYF7QJZIWqbeUGMG50nMVYKE4N
	 eqyNhunhrJKBfght/sPbM5JeoO7JTlQ++R/MoetyvpIqXr/4pKBs1gqd71j+zlRSaU
	 75jy1pUvw5kwdE9wvUBph+d7dMx64B9y5pmzHz3sMLBqjQaHmyF/Mx/WqIcfJmUfO1
	 iQV7xRlr1znXvRELXDn6JjvUeXaqJsP8jmET6wRmYof5t91BMGnQ2v5ScX5A4foYTJ
	 yS3U+QbKU4/ew==
Message-ID: <sashiko-outbox-183274@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v5 08/14] mm/mglru: lift youngest gen protection for
 higher priority
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmFycnkgU29uZyAoWGlhb21pKQ==?= <baohua@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org
Cc: hui.zhu@linux.dev, axelrasmussen@google.com, baolin.wang@linux.alibaba.com, david@kernel.org, hannes@cmpxchg.org, ljs@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev, ryncsn@gmail.com, shakeel.butt@linux.dev, weixugc@google.com, yuanchu@google.com, zhuhui@kylinos.cn, baoquan.he@linux.dev, liuxiang.277@bytedance.com, wangzicheng@honor.com, lianux.mm@gmail.com, kasong@tencent.com, liam@infradead.org, surenb@google.com, mhocko@suse.com, rppt@kernel.org, zhangbo56@xiaomi.com, lyugaofei@xiaomi.com, ridong.chen@linux.dev, kunwu.chan@gmail.com
In-Reply-To: <20261022220203.91911-9-baohua@kernel.org>
References: <20261022220203.91911-1-baohua@kernel.org>
 <20261022220203.91911-9-baohua@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 22:03:40 +0000
X-Rspamd-Queue-Id: 82D3D4000F
X-Rspam-User: 
X-Stat-Signature: 5nom3dc3hk8wmthddui9t3chjjkqnn4w
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792793024-997753
X-HE-Meta: U2FsdGVkX1/yAphedgXaTTIEr4q9aGqpUcOLx54aTzjOLwDx9ctDbVyFKE6SWe2Ac0RcqMYIkIq7t6jLfVlH7ZLBQZAc/7om33eW45iNGh7E5nFpOJPxDwKbZ6FlOP2AgAs+ZzsSEfgFDGAg90Uot64m+lN9tWGZ4Ud/tEfuYPaKqETK+hzU90MwN3msNib2V1z6wwMVr86wr1L3iTKrAGp5r/1W+yQbVgGXtf1KqRPdrecUNdyFR1fCDn5Oz/ihE4Cqo4pXoe3SRbYpZ3p73jr7PYH+rSvuZgM5RnVRUMZXgv8METrZ6CPwyK8b35q0LsqPX67nRlGu0+eBKwhU25zSZD5kKMXpAj5MnEse1dAYuBRZLkWDXAlbzeT7YeICFlfaX5T+wrlDMLJcfKOQbgLIBkDLdFIzx4rZohsuCNArRqShBkK504maTgf9rFDjF5ILLnzYk9hrjpwZkYio3Z6nf9kKNyFxNUVuaNnrLeZlgiuaXhc1CsnoZk+lfaBylC+cbTMM7SiCaFFDRr6qeaGmU5c9s9GNxv/LtJc3m7aCLWc7gzPUvy1jrhjKzkYX2xyOlbSbpVakUKKjaykwneKRfMcIpQVpK6CzT/axRp+4W2yycSkbNbE1uKd4PBmOygrzf2Sv1CTgewv+Ckgtbwg7pXOQZg+XkDNk4Mmp4u9RupQorkSDJSMiC3azp2QQNK1oHL/6x+5Gpq8gvkOZJzxa8e3EKcFS1Bicq6tAMOlQMgz4ruWUxTQm/05lOFgwbyoariz9Ty/2fw7qKastxA9cSEW5vy4Mg1q6CmhR9erHEdwy9FLio+Z4rNsl4xcWXSrGS42z11k20XGpg56Jg7LQ+JCV70WXFZtcJmR7JAsMwIWCJCP9VBluv1VRa9tQbfdp9bBhrNWh2Ql/N/iZ4sXkz9cthUOg1t7Yj5zJoSwu8odlZrv2VMbHeSkzPbdTAaMm+X2P+7SmN05GG35
 1uEponvW
 mvMq4yyJ070jODDxnlPI0DQznC4TL0gcnA6eCrPASIaSjU8AHccXR8mApIPRwW6cNqofwuSxvmpy2ZAgZo5wBOvpT8HKxw4nNvE9czGxyYDjqm0IqXi9xZcaETylJ6eQpUc7dHMnVsydDeEnxGnnvYJY6eZ1AWP9KtyYIHNyAU1zWcH5aFYsqqI3FXyUK+/b0KwW9/8nQO40WUiDkg3LBKrmo0b3rETDTZ4Uv+gM5iOso0C7Z7Dtws1yjLnEcHad/Y2Rg2f9Ni/B8Wwcsdk1Zn7dolVDRsM8oLAZ6NkJ8Dr0eZXC+3oysE78FzLRz08trDziZ/poO9F0wr9v7peR+jAL+t7G8JXuc7Hu0U8Ug1vtfQb2awU0PvxWwFs4nIM82N1qwXx8TO6h0RM00EhlCbqm8zVbeL1mHDXW06PGW0KvY4nspYZxgkpF88AWc7qXQAGYtQ939qMAnOl8RTX8ZphrzmIQ4cKPv/4XO5ExZq4iwR4qtRJVs1ZDMWMGU2WuOCjUyYCu5rAB5Xg7iNq+mkEn85Cpc9rf6gB5JX7WUUy9EkiUjGvQFDeS07YIUI1+QeaVqFmSSp3HVTjo7gaCR3eIKbrOQGqBcd8jQCgKfC55zDJLwddxjSEXNj/kdAq+AhzFXdDuYPjs/LpjqvN5EFG2J2w/7yJoO3TFsMmv53d5MyMYg+yt92YdgUuVE6+enZiwXII+/U+yUwZ8BCe0TNGKAtpUnRvkhBKXy
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
- [Medium] mm/mglru: scan_folios() scans expired gen < min_seq at DEF_PRIOR=
ITY
--

commit 1329290ce5f86b7de9b77d6b22e4b265f16348ae
Author: Kairui Song <kasong@tencent.com>

mm/mglru: lift youngest gen protection for higher priority

This commit adjusts scan_folios() in mm/vmscan.c to choose the target
generation sequence number based on reclaim priority rather than using
lrugen->min_seq[type] at default priority. It aims to protect younger
generations at default priority while allowing higher-priority reclaim to
scan newer generations step by step.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index fed39b0422e01..d1e14001f9346 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4930,12 +4930,14 @@ static int scan_folios(unsigned long nr_to_scan, =
struct lruvec *lruvec,
>  	VM_WARN_ON_ONCE(!list_empty(list));
> =20
>  	/*
> -	 * Respect the gen hotness distribution at low priority to avoid
> -	 * aging and scan cost, but prefer to satisfy the reclaimers request
> -	 * when under pressure to respect swappiness more and reduce IO cost.
> +	 * Respect hotness at default priority, and only reach into the
> +	 * newest generation when under severe pressure, so hot folios are
> +	 * not evicted as soon as priority is raised.
>  	 */
>  	if (sc->priority =3D=3D DEF_PRIORITY)
> -		seq =3D lrugen->min_seq[type];
> +		seq =3D lrugen->max_seq - MIN_NR_GENS;
> +	else if (sc->priority > DEF_PRIORITY / 2)
> +		seq =3D lrugen->max_seq - 1;
>  	else
>  		seq =3D lrugen->max_seq;
> =20

[Severity: Medium]
Can this cause scan_folios() in mm/vmscan.c to scan an already-evicted
generation when a type only has the minimum number of generations left?

In try_to_shrink_lruvec() -> evict_folio_lists() -> evict_folios() ->
scan_folios() at default priority, when get_nr_gens(lruvec, type) is at the
minimum (2 generations), lrugen->min_seq[type] is lrugen->max_seq - 1, while
scan_folios() sets seq to lrugen->max_seq - 2 and passes it as max_seq to
lruvec_populated_min_seq():

mm/vmscan.c:scan_folios() {
	if (sc->priority =3D=3D DEF_PRIORITY)
		seq =3D lrugen->max_seq - MIN_NR_GENS;
	...
	seq =3D lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx + 1, seq);
	gen =3D lru_gen_from_seq(seq);
}

In lruvec_populated_min_seq(), because min_seq (lrugen->max_seq - 1) is
greater than max_seq (lrugen->max_seq - 2), the while loop is skipped and
max_seq is returned directly:

mm/vmscan.c:lruvec_populated_min_seq() {
	min_seq =3D READ_ONCE(lrugen->min_seq[type]);
	while (min_seq <=3D max_seq) {
		gen =3D lru_gen_from_seq(min_seq);
		for (zone =3D 0; zone < zone_limit; zone++) {
			if (!list_empty(&lrugen->folios[gen][type][zone]))
				return min_seq;
		}
		min_seq++;
	}

	return max_seq;
}

When scan_folios() previously scanned younger generations (lrugen->max_seq =
- 1
or lrugen->max_seq) at elevated priority while get_nr_gens(lruvec, type) had
fewer than the maximum number of generations, sort_folio() can move folios
with a stale folio_lru_gen() value (such as after __lru_gen_reparent_memcg()
or when inc_min_seq() skipped draining old_gen) into that expired
lrugen->folios[gen][type][zone] list:

mm/vmscan.c:sort_folio() {
	/* promoted, or moved due to reparenting. */
	if (gen !=3D min_gen) {
		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
		return true;
	}
}

A subsequent default-priority call to scan_folios() will then visit that
expired generation (< lrugen->min_seq[type]) and corrupt active/inactive si=
ze
accounting.

In addition, in lru_gen_seq_write() -> run_cmd() -> run_eviction(), debugfs
eviction runs at default priority. If a user requests evicting up to
lrugen->max_seq - 3 when four generations exist and one type has already
emptied lrugen->max_seq - 3 while the other type still has min_seq at
lrugen->max_seq - 3, wouldn't setting seq to lrugen->max_seq - 2 in
scan_folios() evict folios from generation lrugen->max_seq - 2, exceeding t=
he
requested seq bound?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022220203.9191=
1-1-baohua@kernel.org?part=3D8


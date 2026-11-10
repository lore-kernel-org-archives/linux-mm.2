Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 082B4606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S2+tteA6
Received: by kanga.kvack.org (Postfix)
	id 2F4D86B05B7; Tue, 10 Nov 2026 15:56:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ABBC6B05B8; Tue, 10 Nov 2026 15:56:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E3016B05B9; Tue, 10 Nov 2026 15:56:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E6E5D6B05B7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:56:35 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 85F15120115
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:56:35 +0000 (UTC)
X-FDA: 85420417950.24.545F168
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id D78ABC0003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:56:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S2+tteA6;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794344194;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BuDCMt7mnzSy/3clXwZXD7D5oU2sF72XQrd8nxgOyY0=;
	b=ynI7g5/0i85coFfLwH1B0rcIwPFYz0WnCyOPnOYVqFC1yqkIIQ0UdJ0nrc+mxBhvkTL2V0
	3D/+EM1TLL66h7gH5jv1wWLmJsacFPbUcCxFlKiryl6SQR2bklZXMGmJgsKkqreap3FHD8
	xw1oJfklGSBQumL1XBbL9BuAlvqm8RE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S2+tteA6;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794344194;
	b=lHNoJyf+oeyTI8zZSGbxioVv/GeWKtCboG6xW9XTGBMH0MnPJvsZE+A0fhp+CZLsc+/hPi
	pb3jBe50CFQ0AYSSo46OffDFk9DxbMIx4WMBp0MFDtSE8KymAdscGbwOHB3F3lt1X++WLV
	ALK9wejQY2RtWjqcctBMfG6WVKY4EYk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 193B2436EF;
	Tue, 10 Nov 2026 20:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1791F0089F;
	Tue, 10 Nov 2026 20:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794344193;
	bh=BuDCMt7mnzSy/3clXwZXD7D5oU2sF72XQrd8nxgOyY0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S2+tteA6BaysRD3UG5Ero8mlME7bltwykhDFg4keL/R8AVXio/UH7/CxEUf2JqROw
	 uPi/y+5mcJn9hKfZb4BIVxQwGDt+XuRq5FNnytsWjyldmOWrSJbu6UEY1WMTg6eO0s
	 WNWvT0DCdA2PZfEKY7NGZV7bbi0eYqoAleQypPf8quolRR/B+mbWisFg6Uv5iDnJAm
	 vUqmdq6DgiqUyDS+QHOycKuUfQzgAZiZKoqXC73yposS6hJu1zZQ/FKybMmPMDCXqk
	 JLwrySwCTN354Yv5z1FzcJIcSTjYZR/B/GZfPEJoj2wes2JdoWCYSIQGUyoibhydZE
	 +xWsna+31hWeA==
Message-ID: <sashiko-outbox-207742@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 05/15] mm/mglru: skip zones above reclaim_idx instead
 of rotating them
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmFycnkgU29uZyAoWGlhb21pKQ==?= <baohua@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org, lianux.mm@gmail.com, liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn, sidchintamaneni@gmail.com
In-Reply-To: <20261110202025.25736-6-baohua@kernel.org>
References: <20261110202025.25736-1-baohua@kernel.org>
 <20261110202025.25736-6-baohua@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 20:56:29 +0000
X-Stat-Signature: 6frzcbg5ox8jfsjoiu6nshee9wsjr87c
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D78ABC0003
X-HE-Tag: 1794344193-569212
X-HE-Meta: U2FsdGVkX1/a91b2WyCYeXFYxxpVmJlnxaz7VajMqWvbgNJlnIja/Sa9u4XYwBG80JzP9NOUSBusqDO2yXNRoEU0+uRRpWEEZwBehMWN2SiQnA9Bp9zjL/DJpdPpTCqtXxa0VYL+r2JFb5R44qlrVTGl0L7ERLbK8RcSKWNBBn+qCx/4a4Ooo3kr5yj+ZsRFTmBaK/koXxgEaOXNo6PTEOZGXX+OArzQZBXmD+8j4CkJoMXVz+RgV3DzAwqHRs9gEztOfYa+DXzGWv2DAiZuawMbrdvzRvXAr8oBguaI/9t6KbKlRNBvx62suM/8tvyZt7dmp+EYITXH1DVivNtBmdtzA6qCvCV+dAdziKrNQnmzGN0IcSaFB6YMFnOoAWcXLlTspmdkO8/uZC8kkw2rbq9Wbniixapw1cT6GzYahH8BqVZuICOVVXAyhaX9d6HVbWTzgFs1rUtpUg9/sjb4Lxx7DmjNEBkkeZJt6YUNxTNZDBidXi2GhFakM2ILOIkMm216zJJxvLEE/NFVmuVgJVCeOX9C5GHXmFHkBnMIdhy8DyVq+z3qrLeFPpcux6iqPD13BIoocdkq7+FlWCOY+VKPCzjRdiJyKlWj4hUYQ3egeJMnyQJ50fW/q4VHtbgtAqu1GIF0kD5qcG7KpfyVbWFj2tU/ucFTCJO6JV/RbDpNWfSxbrmX+eJdiM1S8WqIorkQaQ+NGFwblnO6rUYnTHI9GEAfcX0NJfBTWrLGViprONm7OzUlCX1SPuF9Ga3qUXGVCIX1ZH1+dulBdbTfCuxQcuCzGwdw7Tp8r9LR9XCpQVIaBp5HVbyVDM23DwE/84lFE2Fbn2+T2nc741nHlvI6WzolRKoPtVJ2zVax2nnOaF2LOA22gbaSuGHKA6tOKMvTH8iZ7QbfCEx6Qa/6WhD+Ek3+8WDQSVIMHWK5fcO2mf4Ea1/2B7fC52PQygk0r7iOFeer1igs4webo8B
 vj18yHk4
 Y2b6isXhlK2wZ9mDrWaX4hIPKP/qkqbIbA0VGNtHNW4usXHJwYIEmZ/+hfct78WmUKRISi3sGHSXKfAZF2sXXaLJVpPG2cG1Q4yR4An0h7mBTtT6jaipx8KatNmZkX79pC3sUFpM4S03CSPwwS10EPQ3ueEXwrHTamHPgDMQY4m5tl3tV8N1b5XScXSSe2a6Yi37iwrvkcOSLLZ5H7QZSxJjmaMkYa88B2tWsWYt2nSHmMGzFUj29B5dZZAJg2zY5NcnCmhUni+U0tLMpNYTTjnFo+9TGT+d3BuaCf4mFLK8iehvJI3c6mWjyfdRhD20Vhq95T102SOrqXxXknGH8op4wcFf1Zjvin9b123zbhfVKyge0rgjX3HCnkvmOml1VGdGtcf17J6piPtHgqkGyq0qm5FoP/AuFyA/SbefwYJQjVJqjQyuSu1pgS6X6BttBYvKPbznlY/yvelPzlxSJ7rOX1g1fQtavVzTx23djiODJA7sL2HanvF+T+wjEMxBgE+Rq3pohWklGbzoBnJT7vpt4ByGrJOHEfKKH2eEDJv2Mkva+gfL3na/LHUpkf85dOzclmke13Gukq1txdCMLLrSLCZ9mvtHeszYTV376SRC+rJMql/dDPm7xcKZnc96iH89U6uwWOgy/imbePgDArfiID90U5odXl6ReEGDLKuCVR8N09EW1U2tETxHYlK9KJYV7tC2J5LN9E+0eKMSdwRTDAkCy4TLmyHD8AYzG9cNpV/yy9oCUabHg8OhPofApZFz7DRBFKO8QNwg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Medium] mm: inconsistent PGSCAN stat accounting in scan_folios() [1]
--

commit 91b0962145533fb9dabae36c077150538170ace0
Author: Kairui Song <kasong@tencent.com>

mm/mglru: skip zones above reclaim_idx instead of rotating them

This commit restricts scan_folios() and lruvec_populated_min_seq() to zones
up to sc->reclaim_idx rather than rotating folios in ineligible zones to a
younger generation.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index db0a8a3e88872..6b16706779744 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c

[ ... ]

> @@ -4758,16 +4750,17 @@ static int scan_folios(unsigned long nr_to_scan, =
struct lruvec *lruvec,
>  		       struct scan_control *sc, int type, int tier,
>  		       struct list_head *list, int *isolatedp)
>  {
> -	int i;
>  	enum node_stat_item item;
> +	int zone_idx;
>  	int sorted =3D 0;
>  	int scanned =3D 0;
>  	int isolated =3D 0;
>  	int skipped =3D 0;
>  	int gen, max_gen;
> -	unsigned long min_seq;
> +	unsigned long seq;
>  	unsigned long remaining =3D nr_to_scan;
>  	struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> +	struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
>  	DEFINE_MAX_SEQ(lruvec);
> =20
>  	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
> @@ -4779,24 +4772,22 @@ static int scan_folios(unsigned long nr_to_scan, =
struct lruvec *lruvec,
>  	 * when under pressure to respect swappiness more and reduce IO cost.
>  	 */
>  	if (sc->priority =3D=3D DEF_PRIORITY)
> -		min_seq =3D lrugen->min_seq[type];
> +		seq =3D lrugen->min_seq[type];
>  	else
> -		min_seq =3D lruvec_populated_min_seq(lruvec, type, lrugen->max_seq);
> +		seq =3D lrugen->max_seq;
> =20
> -	gen =3D lru_gen_from_seq(min_seq);
> +	seq =3D lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx + 1, seq=
);
> +	gen =3D lru_gen_from_seq(seq);
>  	max_gen =3D lru_gen_from_seq(max_seq);
> =20
> -	for (i =3D MAX_NR_ZONES; i > 0; i--) {
> +	/* Scan eligible zones in descending order. */
> +	for (zone_idx =3D sc->reclaim_idx; zone_idx >=3D 0; zone_idx--) {
>  		LIST_HEAD(moved);
>  		int skipped_zone =3D 0;
> -		int zone =3D (sc->reclaim_idx + i) % MAX_NR_ZONES;
> -		struct list_head *head =3D &lrugen->folios[gen][type][zone];
> +		struct zone *zone =3D &pgdat->node_zones[zone_idx];
> +		struct list_head *head =3D &lrugen->folios[gen][type][zone_idx];
> =20
> -		/*
> -		 * If there is only one gen left, rotating the unreclaimable
> -		 * zone become meaningless, just skip them.
> -		 */
> -		if (gen =3D=3D max_gen && zone > sc->reclaim_idx)
> +		if (!managed_zone(zone))
>  			continue;
> =20
>  		while (!list_empty(head)) {
> @@ -4806,7 +4797,7 @@ static int scan_folios(unsigned long nr_to_scan, st=
ruct lruvec *lruvec,
>  			VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
>  			VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
>  			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) !=3D type, folio);
> -			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) !=3D zone, folio);
> +			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) !=3D zone_idx, folio);
> =20
>  			scanned +=3D delta;
>  			if (sort_folio(lruvec, folio, sc, gen, max_gen, tier))
> @@ -4825,7 +4816,7 @@ static int scan_folios(unsigned long nr_to_scan, st=
ruct lruvec *lruvec,
> =20
>  		if (skipped_zone) {
>  			list_splice(&moved, head);
> -			__count_zid_vm_events(PGSCAN_SKIP, zone, skipped_zone);
> +			__count_zid_vm_events(PGSCAN_SKIP, zone_idx, skipped_zone);
>  			skipped +=3D skipped_zone;
>  		}
> =20

[Severity: Medium]
This problem wasn't introduced by this patch, but should scan_folios() pass
scanned rather than isolated to mod_lruvec_state() for PGSCAN_KSWAPD and
PGSCAN_ANON + type [1]?

mm/vmscan.c:scan_folios() {
	...
	item =3D PGSCAN_KSWAPD + reclaimer_offset(sc);
	mod_lruvec_state(lruvec, item, isolated);
	mod_lruvec_state(lruvec, PGREFILL, sorted);
	mod_lruvec_state(lruvec, PGSCAN_ANON + type, isolated);
	...
}

Folios that are promoted via sort_folio() or skipped are counted in
scanned, but passing isolated here omits them from the PGSCAN vmstat
counters and underreports the scan rate compared to the classic LRU path.

[1] https://sashiko.dev/#/bug/linux-ebd28175-5aad-4454-b9f3-a9510e3c4655

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110202025.2573=
6-1-baohua@kernel.org?part=3D5


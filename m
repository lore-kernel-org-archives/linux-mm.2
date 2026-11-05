Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C5D4606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CW6sfdBQ
Received: by kanga.kvack.org (Postfix)
	id 818866B05B0; Thu,  5 Nov 2026 13:39:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CEED6B05B1; Thu,  5 Nov 2026 13:39:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E21E6B05B2; Thu,  5 Nov 2026 13:39:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D08B6B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:39:16 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C0A6A807B9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:39:15 +0000 (UTC)
X-FDA: 85401927870.09.B74D0AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2B70FC000C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:39:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CW6sfdBQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793903954;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dAdsYWxYciD4mJHsgcy6uD7C0HtcURhpnUwcNxdpHIE=;
	b=BxcN/ZRiY/5btpG7I+3RJSBDuDpJqQ28IgFUF3Dfpdxj/eWTDmmaG5QzSmOfn3o+pUSJdt
	ariAcpcQWrcZ7Bwfxr4kyFSeZD8n7AvsKsQEyGpMCHM80FCjrhmmb1+ppvAuItuxsYOouW
	cU7Bm/9m5CzjpArIt6VYhJU+vX31lDA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793903954;
	b=Bd7FfU6eO0/ABKLMOqhNDcIx5Ok+JVw+wopy7O+3pSd23/rHEDoIjTh9t7geT2qlJrPKNf
	w+0PsEOB6v8GmZTlnRtBqwri0n+9zn1lyKBfKS98GDhk7ZMKNVqXhUaNoI262T/3H9qNr7
	gdqwptnceJido1d9r9mbBWVZHjSkIZ0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CW6sfdBQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 97F6A600E4;
	Thu,  5 Nov 2026 18:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B307D1F000C1;
	Thu,  5 Nov 2026 18:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793903953;
	bh=dAdsYWxYciD4mJHsgcy6uD7C0HtcURhpnUwcNxdpHIE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CW6sfdBQ3z63MIVEldOGnUg6d1s7+sarG7iW+R+LVx4StCn+4LMjTZd7Zlx0NOduR
	 sOmM53Lvpd9/hlgqh21U0aIm0P82SBiW78TPXHzLUlEemVo85/JMDLfCWw9tNirbDv
	 xXHKG7XNfuljEftE/EP7eei3H2NJh4sRai2vC4CVTNG2f7pX9NnvNht21EqTsT5Zvm
	 COjBgN8QYhFGWIqhQE8Q3G1E0AZ0F8Jr8/phFgSfSzII7K1YbuGUJPS9/CW/dw5xe9
	 UM+MFf8qfUMW4ohoJesvuaw/K+d7KyuuKI4KPheTssNox3XlpZnDg1CE5UjBkZMySR
	 kPcfHOcD3mq+g==
Message-ID: <sashiko-outbox-199783@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm, vmscan: make kswapd unreserve highatomic pageblocks
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?Vmxhc3RpbWlsIEJhYmthIChTVVNFKQ==?= <vbabka@kernel.org>, "Johannes
 Weiner" <hannes@cmpxchg.org>
Cc: "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Zi Yan" <ziy@nvidia.com>, "David
 Hildenbrand" <david@kernel.org>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Kairui
 Song" <kasong@tencent.com>, "Barry Song" <baohua@kernel.org>, "Axel
 Rasmussen" <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei
 Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "JP
 Kobryn" <jp.kobryn@linux.dev>, "Frank van der Linden" <fvdl@google.com>, "Thadeu
 Lima de Souza Cascardo" <cascardo@igalia.com>, "Andrew Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org
In-Reply-To: <20261104-kswapd-highatomic-unreserve-v1-1-38be5106adf5@kernel.org>
References: <20261104-kswapd-highatomic-unreserve-v1-1-38be5106adf5@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 18:39:10 +0000
X-Stat-Signature: jst3dhrnw7qoi5wd8gktpz6dst69zb5m
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2B70FC000C
X-HE-Tag: 1793903953-12738
X-HE-Meta: U2FsdGVkX19r+dObIhtQf7H89Z3GZXCRux1De1RAsViCF4GcqhNmb9UaeDEOBeOl2YPN1Un/bTP7X9REDZvLgegtQBrExEHPOyShGsadiRihTbQT1XjkKy33OZyhdloyRqll7QRPI+Vw/kFaDAKQge0h4jtRGiMpy8QP/uFpN/6QBueMGF7u/AlQeBp7WfO7Ddtozc+WT8mUGYqBEXft7MQraKBBtbyWUFh112rQ79p7OZ7oj/Vb+btkY9NsjQUIdUvBlC9g6CodM/DO29NKG5z+EeThmaPmiUP0FXBDmOIMdbOHn+WQO2OZMppEaZGdn8YdUMjfL3iDKpgroby7qhG10HgxeOrbQBB/VKt6Vdj3Q1COvuHaG3EJPG9APl/ezWbBi/ERV6N+sPyqhKFH77S3tMp8fHqjqniV4fdMhO1CKz1BaxlUwewNMefUsG01komzmpoBYpNSjxtgoVD4x/HTvMYR9/9yi9SEGjnhpMKsOQnrxnZYxZAEiqKGpjeoKMrYvWOnpdIqD5dGx2l1NXGbPrhBhR+YHLf5guU77yRhOV/nCwOBHDxouZfk1TYEdTd4S4nLJYR1F4BWt33PPac4X/VXMTLbV3uy5ag46uyQCJ5fTBSVZYnxXziETOcKe1ggKq/oLVzBNO6dBE8pdrom+Apg5dcF9mlUSmjioUJIUjMZh+hcbYcK1uSiMxY5gBi1tz8TD5OtFr61JpHeR4kNM/O0K494Xzs1OT2rjh8hnj5lT6cFcphyOnmt1wLFMYTD+qr6G6x+TM8JgBsLdg5EBuwaS4uZ7Cy9KtyfTMe4iPQkKXGfkGqqCysCaovgjZn5z6jwhDNQRobtTVJPGGiS1+ZDQvrC/ZqltlJHuV+7zSLgxSHAZ3VxyR6rD/VDZe6UHi0OV0k7d2C8jn3n+PgmGEl5L2uo46uxDqmI8e/HHYr1HRaybZbWfmoLp7W2HjLZ8kkq9uCXIcaL801
 z8MQnInn
 d9wROuLURnTc0Uz8y694OOowY+lW9B7R+iownyeKOYwcHoP8BW2CIgE20vhYLp/vdyJMonmm1pTWfOpvkb84P9TpPAT7K94/kdLf3YnaMItt5IfsLOmpnO8yCdoMvRD0ulQO1M+4Jb5xWqrC2eGxxohn/PAAZwvkMK+sXYMz1FbSqle0IWNf1XxoQw8Z/oBCmmYBPA6rqKgdh4sBRGuxAZYBZxiSDn4YbZxIy/XgF06eqf9zlp6NtxxwrwrtLpFyyarRT9kgu1IpOIF0665TCucN0jJXCViUj4dqwtM36YMarnhnttF1K0ItuEL9xmetPbZL2aNdcvRmRqobdXyeMg94U1fOJoh2HM31ZcLVAZFFZ0VbB4ssQj8hYdoFYe265GKvVbzbErN+L35XvwBg8NMZutqpHqhvpoTEzHXFuryNJ1Tb9pwDOtJmEeXsvs/y5GB/BV1v86w1zzJaZVWgEwaMHnBaDSGyLqpbpWgvsyLgtghbK4zcVRUnyY6DRyuPcZFTCfhTgejirQNiYO8RD/kCwalMLi0N7ptwF1MA7mddfVmsBpNGEadAFZVo72g6/dp1vi4XJA1LCZNo86vLdmi+mCYxZ9JOSJ7TftX4hg+aqmuLg2ZiQ1jfgxLN56ddedQmt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] mm, vmscan: premature highatomic unreserve in balance_pgdat()
- [Medium] mm, vmscan: incomplete highatomic unreserve in balance_pgdat()
- [Low] mm, vmscan: contradictory migratetype comment in balance_pgdat()
--

commit 9f34d95b6ce713649b203e410b246f2a907d1814
Author: Vlastimil Babka (SUSE) <vbabka@kernel.org>

mm, vmscan: make kswapd unreserve highatomic pageblocks

This commit extracts unreserve_highatomic_pageblock_zone() and calls it from
balance_pgdat() when kswapd raises reclaim priority or reclaims no pages. T=
his
allows kswapd to unreserve MIGRATE_HIGHATOMIC pageblocks on nodes where dir=
ect
reclaim does not run.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 9959ca158ce83..91c622068d991 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -7460,8 +7460,22 @@ static int balance_pgdat(pg_data_t *pgdat, int ord=
er, int highest_zoneidx)
>  		if (nr_boost_reclaim && !nr_reclaimed)
>  			break;
> =20
> -		if (raise_priority || !nr_reclaimed)
> +		if (raise_priority || !nr_reclaimed) {

[Severity: Medium]
Will gating this on raise_priority cause kswapd to prematurely unreserve
MIGRATE_HIGHATOMIC pageblocks during ordinary, successful reclaim passes at
DEF_PRIORITY?

In balance_pgdat(), raise_priority is initialized to true at the start of
each loop iteration and is only cleared if kswapd_shrink_node() returns true
(or at DEF_PRIORITY - 2 during watermark-boosted reclaim):

mm/vmscan.c:kswapd_shrink_node() {
	sc->nr_to_reclaim =3D 0;
	for_each_managed_zone_pgdat(zone, pgdat, z, sc->reclaim_idx) {
		sc->nr_to_reclaim +=3D max(high_wmark_pages(zone), SWAP_CLUSTER_MAX);
	}
	...
	return max(sc->nr_scanned, sc->nr_reclaimed - nr_reclaimed) >=3D sc->nr_to=
_reclaim;
}

Because sc->nr_to_reclaim is set to the full sum of high_wmark_pages(zone)
rather than the deficit between low and high watermarks, a normal pass at
DEF_PRIORITY that scans lruvec_size >> DEF_PRIORITY pages and reclaims
enough pages to balance the node (or aborts scanning early in
should_abort_scan() under CONFIG_LRU_GEN once WMARK_HIGH + MIN_LRU_BATCH is
met) still has kswapd_shrink_node() return false.

Since pgdat_balanced() is only checked at the top of the do-while loop (and
is already true during watermark-boosted reclaim when nr_boost_reclaim > 0),
a first pass at DEF_PRIORITY that makes progress or has already balanced the
node will still enter this branch, unreserve highatomic pageblocks into
MIGRATE_UNMOVABLE across all eligible zones, and only then notice
pgdat_balanced() is true at the top of the next iteration.

Should highatomic unreservation in balance_pgdat() only happen when
!nr_reclaimed (or after rechecking !pgdat_balanced() when reclaim fails to
make progress)?

> +			/*
> +			 * Similarly to when direct reclaim is retrying, try to
> +			 * unreserve highatomic pageblocks on the node. Convert
> +			 * them to movable ones as kswapd doesn't have a target
> +			 * migratetype, and passing unmovable should lead to
> +			 * least permanent fragmentation.
> +			 */

[Severity: Low]
This isn't a bug, but the comment says "Convert them to movable ones" while
the second half of the sentence and the call below use MIGRATE_UNMOVABLE.
Should that say "Convert them to unmovable ones"?

> +			for (int i =3D 0; i <=3D highest_zoneidx; i++) {
> +				struct zone *zone =3D pgdat->node_zones + i;
> +
> +				unreserve_highatomic_pageblock_zone(zone,
> +						MIGRATE_UNMOVABLE, false);
> +			}

[Severity: Medium]
Can a node filled with unreclaimable 1G hugepages still fail to balance in
balance_pgdat() and hit kswapd_failures exhaustion with this change?

There appear to be three related cases in this path:

First, unreserve_highatomic_pageblock_zone() preserves the last pageblock
when force is false:

mm/page_alloc.c:unreserve_highatomic_pageblock_zone() {
	if (!force && zone->nr_reserved_highatomic <=3D pageblock_nr_pages)
		return false;
}

However, __zone_watermark_unusable_free() still subtracts all of
z->nr_free_highatomic, including free pages in that last reserved pageblock.
Unlike direct reclaim, which follows up with force =3D true in
should_reclaim_retry(), balance_pgdat() never passes force =3D true, so if =
the
single remaining highatomic pageblock keeps usable free pages below the
watermark, pgdat_balanced() will remain false.

Second, reserve_highatomic_pageblock() can reserve up to 1% of
zone_managed_pages(zone), which includes 1G hugetlbfs pages (for example, up
to 320 pageblocks on a 64GB zone). Because
unreserve_highatomic_pageblock_zone() unreserves at most one pageblock per
call, a full balance_pgdat() walk from DEF_PRIORITY down to 1 unreserves at
most 12 pageblocks per zone (or at most 6 under CONFIG_LRU_GEN when
set_initial_priority() starts at DEF_PRIORITY / 2 because reclaimable is 0).

Third, unreserving highatomic pageblocks does not increment sc.nr_reclaimed,
and if the final unreserve at sc.priority =3D=3D 1 balances the node, the l=
oop
exits before rechecking pgdat_balanced() at the top of the loop:

mm/vmscan.c:balance_pgdat() {
	if (!sc.nr_reclaimed && !boosted) {
		int fail_cnt =3D atomic_inc_return(&pgdat->kswapd_failures);
		/* kswapd context, low overhead to trace every failure */
		trace_mm_vmscan_kswapd_reclaim_fail(pgdat->node_id, fail_cnt);
	}
}

Once pgdat->kswapd_failures reaches MAX_RECLAIM_RETRIES, kswapd stops even =
if
unreserving highatomic pageblocks was making progress or more reserved
highatomic pageblocks remain.

Could balance_pgdat() pass force =3D true at low priority, and avoid
incrementing kswapd_failures (or restart/recheck balance) when
unreserve_highatomic_pageblock_zone() succeeds?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-kswapd-hig=
hatomic-unreserve-v1-1-38be5106adf5@kernel.org?part=3D1


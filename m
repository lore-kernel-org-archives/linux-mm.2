Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA676606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 17:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IJrect8G
Received: by kanga.kvack.org (Postfix)
	id CD5146B05B0; Mon, 26 Oct 2026 13:41:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAC366B05B6; Mon, 26 Oct 2026 13:41:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE9F16B05B7; Mon, 26 Oct 2026 13:41:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 929DC6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:41:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F7D8120818
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:41:20 +0000 (UTC)
X-FDA: 85365493920.23.178D207
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5E59940008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:41:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IJrect8G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793036478;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0BceteKFIZmrpR2GKFFTTB8WWb9Hq0TCYKNKPvQ0FEE=;
	b=jXURJpsnggMzeRT+gognRZa+nYn+pj0rwy7zsD8r6nioGecEQ4kvsUKB+gWIrrPexUAbsj
	zlUtVcEKOURP/slQBYNOwbwREEH1T3Pgp/rGRL9KH12Bg+p5el0SS4/adA15oN4h5WYoNu
	gdM+/c9Nk2ovQOWg2JM6M/gH1WziFxs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IJrect8G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793036478;
	b=fQ9xxI3vz+rHQsHd3TCyv7fQbeJeyVxjeS+GOzt20alGd61kXSXQYng3SgFboMlv9NcN2q
	jN71Xil+GALiTzAi9qwWGgFqB1W1LkQnfNeoa/FjYjEHqOwGHCKiXAORcFTHvu3H4bbNYl
	KR6i1+Etc3IxpKRI1VWXqfIKPzv5JMw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CD68D601EF;
	Mon, 26 Oct 2026 17:41:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7236E1F01825;
	Mon, 26 Oct 2026 17:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793036477;
	bh=0BceteKFIZmrpR2GKFFTTB8WWb9Hq0TCYKNKPvQ0FEE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IJrect8G0JDD7uJfQDDyZOzbVOYBeULxXPrVViOdLoo/8LPU8Rvhv8F0huqExcZ/l
	 rDH9W4x0jjWDetD7Q6xGh16S3i+HGyE6TibV/aPk4Cuvxsu51jHzDxAVfdK7LXYNry
	 dHnsVByAOCYuv048sFKGxcqx33ATICXfBqqdXR5yOcch0a9/iK74O4WkBwlufCeX6p
	 gIx8m/ysZ8EDSBhEpxiKoErERnDq1/niEI4s/fbit1BtQ+qCDxs0n09xzKaOTonK2h
	 Msm7YBflCSJMb4ySVY15sV5VLlZVuuxqz+dNCNZ1gmVJcw4JpFvmbDKXgWkuqIHwI0
	 Dm1qpkraH7ycw==
Message-ID: <sashiko-outbox-185584@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] mm/huge_memory.c: skip zero-page remapping when
 underused THP shrinker is disabled
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TmljbyBQYWNoZSAoUmVkIEhhdCk=?= <nico.pache@linux.dev>, linux-mm@kvack.org
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Zi
 Yan" <ziy@nvidia.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Liam
 R. Howlett" <liam@infradead.org>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Yu Zhao" <yuzhao@google.com>, "Xu
 Xin" <xu.xin@linux.dev>, "Chengming Zhou" <chengming.zhou@linux.dev>, "Matthew
 Brost" <matthew.brost@intel.com>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Byungchul
 Park" <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Usama Arif" <usamaarif642@gmail.com>, aarcange@redhat.com
In-Reply-To: <20261025-b4-ksm_fixv2-v2-1-8b61ad0491f1@linux.dev>
References: <20261025-b4-ksm_fixv2-v2-0-8b61ad0491f1@linux.dev>
 <20261025-b4-ksm_fixv2-v2-1-8b61ad0491f1@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 17:41:15 +0000
X-Rspamd-Queue-Id: 5E59940008
X-Stat-Signature: 6gxowfk3x7cfkwkfrqrbyyzjs9x9je5a
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793036478-572332
X-HE-Meta: U2FsdGVkX19xG4uXxIskLh/mmawKhYr0eMjwQm8MbCVhklolTXIjgk2wwh1ibUGTJGYRlCluLz0Pm+Y7k48oRTFSx1Cs7KtbRZk7Uz9I2B2BSptAY82pTO+f9cVFLftlJ5RolFdiNsuPH7dzWD6tifLX18CY2BWjAyuv4PYoB8Bum8QQcwQLxTXFUFToYLHA4n5MAFGe72RtDS1KLIUesd+MU8/QxCyOo8cpP9K0trHa0MVhv10VYbLtvSqTI4NITEKWtPK8h6Fld2mMXJ3RDzePqxQul/nUgszZ56wkBDnUG8q0GLeMJajxUfAgYKZj2Jp6ydjxDUSkEiorWKO6ZO12GjiRRlId3va6r5n1WD7XY/C4TWtpn7bGVMp8VsIP1EP7/FoeRhxXGM1lXmlLylQwFt4YQXTH16hv5Fk49qK5J6zHpWUx9aQ39tD8ZnLBPPm8DJiYtdpp9NtsKXSROurbFrkPCFv2u6Un1shBjcbjT/IMGnrZzmnn4RnJQuhGm1QHgxSFOLepmniSkG1QtzjKGD2iIb7/0rIK59eMIdOhC35ZJm3Xc3c4UQvngwiV4BiU7DM3nIDW1t7fdvJNqOGqnVzNtoLYrJc+Y0fvSnck61+zLX8ilebmL6baEYjVb1I6w8v768ALGQWJVy7oCZWBh8UgFzraniXKZ4e1nbfW+D5q88ukxqcrM+ODyvD7YkVzmZRFo4G5LXfstGO+CDbi5xqjHhhe/zyBiKTuasHb/92NX6JFpe6Dp1gG5U8ybriviRh7ycUrB6F9lf4kk5eOB2hUJzuSz4Y3mcikRhpqUDp26GniW+aKIIcHbtseU5tXRVyumeeeEU5inWg6MgwPvUKRHUBOUhICPCj7oWNGFfd816jpsQ/brTRWz36d8fsd0wJVzqDKNvdfnSSAda8UIJ08jDECKR+xwZY+oB9poGfELoXobJSWs/1/jmZbMEqfmT86ErfENZndIIU
 L0UaoHli
 ypN8LZfl0mlvi7RzifrSrk4MduhgbXOXABsfV+lpj5sqIM3GIScylK8N4bfXmdb9PkF6nudjzApKeuu7nHOS5+g0gQS04PZ4AGAZ/N/S8E2GFlRN7Asl1uMKxxaMrrUy6xSdNIbqARhxZj504aWRoITe7zb/g6p1DJa/hYBJFq/HWvtjlF4psxluZxMEGXYo2fAtaYDG+X2qX1vdsjtZ1ZaUe6NvYZatBBk5tDC+eTXgEiLB48pWpORifhAn/T1VFEU798jDxIbtTocDik9qY8Bw9AxRJtr37qlu8DMB05N+odxqqD++x/5oTGA0zwNxsbvxwxJGSR0xVMCkewJFEqXyk/Q3mmTadf7dMibEjtYXHjr8wwTTihA+YLLKi3GeHdrRT19/0XcQnky8sf5oi9gC9lCGR1WXGl4UUUgjorDjJrSYwv0T5qLzR8XjiTKK6Mx4aPlYwnD7WCUubW6g8inlz3HM/ni5xsN+7q1B9sU8RHcmMM3paOXZCQEDKFceUEEBkGNGUqF0ta/w89NW/YBWKioBV9ulK+xoGe26UFF65H751HxZlw+WLJX4LUNvpHHnN9KLs13RrA4BtzU1nB/plDT2LT1w1/b2UsyG5h/4twBO6BiJZggIGDpsfEnsT8iwJ1eIKLMb0makkidzXva+zgxur/rogr+DreeY+cKultj168g/cTGssbKAI6nbQrh8EJaqIfQmabC1AUpzO3bML0iN2oCggatvi
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
- [Medium] mm: pointless underused THP splits in deferred_split_scan()
--

commit ebf8a156b1409b53d86c1c5c41f9ce1ca1b64265
Author: Nico Pache (Red Hat) <nico.pache@linux.dev>

mm/huge_memory.c: skip zero-page remapping when underused THP shrinker is d=
isabled

This commit gates shared zeropage remapping in __folio_freeze_split_anon() =
on
split_underused_thp so subpages are not scanned for zero content during THP
splits when the underused shrinker is disabled.

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index bd44d58e86845..2d56d1bff0eab 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4104,7 +4104,8 @@ static int __folio_freeze_split_anon(struct folio *=
folio,
>  out_no_split:
>  	local_irq_enable();
>  	if (anon_vma) {
> -		if (!ret && !folio_is_device_private(folio))
> +		if (!ret && !folio_is_device_private(folio) &&
> +		    split_underused_thp)
>  			ttu_flags =3D TTU_USE_SHARED_ZEROPAGE;
>  		remap_anon_folio(folio, 1 << old_order, ttu_flags);
>  	}

[Severity: Medium]
What happens in deferred_split_scan() if shrink_underused is disabled at
runtime after anonymous folios have already been queued onto
deferred_split_lru?

Since split_underused_thp defaults to true at boot, anonymous folios
allocated via map_anon_folio_pmd_nopf() or collapsed via collapse_huge_page=
()
are queued via deferred_split_folio(folio, false) without setting the
partially mapped flag. If a user later sets shrink_underused to 0 (setting
split_underused_thp to false), those previously queued folios remain on
deferred_split_lru.

When memory reclaim subsequently runs deferred_split_scan(), the
!folio_test_partially_mapped(folio) path does not check split_underused_thp:

mm/huge_memory.c:deferred_split_scan() {
    ...
		if (!folio_test_partially_mapped(folio)) {
			if (folio_test_mlocked(folio))
				goto next;
			underused =3D thp_underused(folio);
			if (!underused)
				goto next;
		}
		if (!folio_trylock(folio))
			goto requeue;
		if (!split_folio(folio)) {
			did_split =3D true;
			if (underused)
				count_vm_event(THP_UNDERUSED_SPLIT_PAGE);
			split++;
		}
    ...
}

Because __folio_freeze_split_anon() now omits the shared zeropage flag when
split_underused_thp is false, remap_anon_folio() -> remove_migration_ptes()
skips try_to_map_unused_to_zeropage() and remaps all subpages (including
zero-filled ones) back to their split order-0 folios.

Doesn't this cause deferred_split_scan() to still scan subpages via
thp_underused(), shatter the huge page into order-0 pages, and increment the
underused split counters while freeing zero pages? Should
deferred_split_scan() also check split_underused_thp (for example, skipping
non-partially-mapped folios via goto next when !split_underused_thp)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261025-b4-ksm_fix=
v2-v2-0-8b61ad0491f1@linux.dev?part=3D1


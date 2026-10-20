Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA17E60A2602
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 15:52:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C43B26B016F; Tue, 20 Oct 2026 11:52:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1BEE6B0170; Tue, 20 Oct 2026 11:52:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5B1D6B0171; Tue, 20 Oct 2026 11:52:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9594E6B016F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:52:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9E7F5140275
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:52:39 +0000 (UTC)
X-FDA: 85343447238.23.A034EFD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id DC26B4000D
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:52:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792511558;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HmMiSFz7NZzRLrFTMfij7SWn4isTAd5Wnhn6ZjPrWDI=;
	b=oNt+07AHHrGta2usSP3GUITUa7xYGiLSgSRMPuGUVNW9l88+jGPaHo37nA+LygVmSCSW0o
	PSLRqsixYL71pQ1qkgah65Xx7C+6PQzMRanAC2cVE0+lWln1TLowU8lj9p31fz1k9IELME
	ZZM0DVZ9cOs80mhyG7BwtahZWeNcIX0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792511558;
	b=gWOAVjxusvpKbzEKOopwa47J4bFNL+uTBQKLVgjYYuJGRGQaCgOR6o7PhB5BRZfMyJcJDA
	D/zfQS38ueuAHQPzRDLjqQmEteoZbc0svMfBJVcZHOwbBHHDbjZNEQZ0VBNnIxgXacjvZJ
	IzmAclTbCi3tAq7Q5zUdKZrpCQimS3E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 256464387A;
	Tue, 20 Oct 2026 15:52:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F8F1F000C6;
	Tue, 20 Oct 2026 15:52:34 +0000 (UTC)
Message-ID: <sashiko-outbox-179305@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 07/18] mm: free the pages waiting for a grace period
 before isolation fails
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?S2lyeWwgU2h1dHNlbWF1IChNZXRhKQ==?= <kas@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Linus Torvalds" <torvalds@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Jan Kara" <jack@suse.cz>, "Hugh
 Dickins" <hughd@google.com>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, "Miaohe Lin" <linmiaohe@huawei.com>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, "Oscar Salvador" <osalvador@suse.de>, "Liam
 R . Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi
 Yan" <ziy@nvidia.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kairui Song" <kasong@tencent.com>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Axel Rasmussen" <axelrasmussen@google.com>, "Yuanchu
 Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Paul
 E . McKenney" <paulmck@kernel.org>, "Pedro Falcato" <pfalcato@suse.de>, "Harry
 Yoo" <harry@kernel.org>, "Luis Chamberlain" <mcgrof@kernel.org>, "Ilya
 Gladyshev" <ilya.gladyshev@linux.dev>, "Jaegeuk Kim" <jaegeuk@kernel.org>, linux-mm@kvack.org, kernel-team@meta.com
In-Reply-To: <20261019154913.1765974-8-kas@kernel.org>
References: <20261019154913.1765974-1-kas@kernel.org>
 <20261019154913.1765974-8-kas@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 15:52:04 +0000
X-Rspamd-Queue-Id: DC26B4000D
X-Rspam-User: 
X-Stat-Signature: cjuwow9pmghsh8k6hawjy16gngzgkafh
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,T_PDS_OTHER_BAD_TLD autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792511557-465598
X-HE-Meta: U2FsdGVkX1+ANVKAft0VUNpWeVI+Cr3mmbiL2nitMPtIB80nPW2uFoGvHzNVOeYVAorhMTClOkGOzHdia63XlbISS5h1jr7GgFuMDB2tE+ZY7d2dWdkefysarB3mv3l+hWOIZymaz8RgInwXsoREeq0qjs8Dw2ea7PLEYizLX6CmqW6ohxmdIqvHyo9Cj9qYgXMJ3Hs4WQcIATQgFRNu+sg04mjipXyMIoLMjIZyYW8Jq6K23XnPvTbsQH1nk2Zgd/akppO27sEoU3kQRCnmf7LwcdaVfPWUyuk1Eq08HneBRTKfKozVoZUd3m1g2nOc2LQTvZaYFVbF9lJsibl+xHtA55cK7hxz+JbhE0AHrzVAt3RvV/66I0Cz/HS8+/CYOTEvsaILpZuiUiZyEc1GuRW+oKkEW6Vv4clL4+6oNuC4C+MoVC32TkX8tww83lILSvSDd70A5V3Wmvsr2y1DwKb+42oDX0XWoziQYEpv8t8G6cQcmRlkG4QUBE/qO794hSzPHlk6pX/Otgtt0aZ4OBlwWptJQoejUZmWWjJYWktlivxtzZxUD7xpQpTllLXJhjdAIKnH5TrWSDuu2cs9AIPMnU/02kHl3JE1f6KZmvpjIEUfceXMNFHmTnLVp4Re3SFsWY8GEXnZZVYyyxxBZHF3NuolVcCZ+2OBaB0y1cNPGO6tEMVFOZvjdKf9if+Qd5GpYOsnxZm0dy+UhaXUHVGhZlfHEtdly+UiwXoOinRq/v9aRItdwmBwUOIFYiAzu6e10/mphSxeAZxHiEStM7G/2xd7OqfiDkcnHpNzjjgu6RGk9hAHmBCeyKwpS+x1w6bVvFd60rP9gt62ehBY1BP6tyu8TNGK2B4K4AxfncaO2ZnpPGyqh9WvJ9CxbBj8Be/Nq3IMZCZU9sx+7EX81Bc5/zEfuvyWxTs8C2Vyrv+2p3UUv6LZGdx1CRl3naUId3O/E2n5tV3QKuWimC7
 /a/9LHvJ
 lcpK3PkcbFAasA7RqDD4pnjUwQPY9hDAbJt4vhszF+C822D3dOBo2632kb8eYIAmlLIvqyhIVdKZnUd+bsH0qSAT1+0E7WJa13SIMKb6iUmnjZpiYVyjTMFFnkDipiGiKXhwa363PgcOW2xiXq7FSyEJYU4YKRbWzyAupCQUZoBeWjdKUGIR30GBR+b2tgjqY/fUUvk/iO9ZCN2iMEkz3AI+0Y8+iT8Z8+2jPAajcWCnAZNj871yE4UCmgANVhH9+b2zYIglQMa6ghFveQv2VMcwuY21bOMoirKtcThoGSh5SvY0pqbg9OU3pn037jJoVn9tiCsH6FraL6cfcHtqu3Bmf+/4pvLMNjaks1HA9GRY1ysNQd09pOg9LlwyixPo/Ka2Jc1aqzyDFi7smdp0dTRotSKYysX0hHW8CYrd109ygeQTvGh9TMWaaRsOC43I8ywmJNJwGNxLxtBilImQBkYeL/sE93wBlI+TmYG4hR2bleJudA7ZHyyvZNseyF4quOaMYqmYd+Xw09yCXnMaWqRUgHt7HKH0Ji6fHWqXnJfuBrUBxYxrRPWElGHgZspU6ax9Zrp0+XRzCPznb0J3D9zXuWg==
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
- [Medium] mm: premature NR_FREE_RCU_PAGES decrement in rcu_free_pages() sk=
ips sync
--

commit 173a808c17014ff8171f1ae96f92027767d39401
Author: Kiryl Shutsemau (Meta) <kas@kernel.org>

mm: free the pages waiting for a grace period before isolation fails

This commit introduces rcu_free_sync() to drain and flush pages waiting for=
 an
RCU grace period when test_pages_isolated() fails in alloc_contig_range() a=
nd
offline_pages().

> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 226ab9cb078ad..a8f0c95627ee1 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
[ ... ]
> @@ -2092,6 +2095,10 @@ int offline_pages(unsigned long start_pfn, unsigne=
d long nr_pages,
> =20
>  		ret =3D test_pages_isolated(start_pfn, end_pfn,
>  					  PB_ISOLATE_MODE_MEM_OFFLINE);
> +		/* What this pass migrated can wait for a grace period */
> +		if (ret && migrated &&
> +		    zone_page_state_snapshot(zone, NR_FREE_RCU_PAGES))
> +			rcu_free_sync();
> =20
>  	} while (ret);
> =20
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index bec9128d80db8..e63628e64cbba 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1468,6 +1468,23 @@ static void rcu_free_drain(void)
>  	mutex_unlock(&lock);
>  }
> =20
> +/* Free every waiting folio, including those a work took off the lists */
> +void rcu_free_sync(void)
> +{
> +	int cpu;
> +
> +	if (!IS_ENABLED(CONFIG_PAGE_RCU_FREE))
> +		return;
> +
> +	rcu_free_drain();
> +	for_each_possible_cpu(cpu) {
> +		struct rcu_free_pcpu *r =3D per_cpu_ptr(&rcu_free_pcpu, cpu);
> +
> +		flush_work(&r->rwork.work);
> +		flush_work(&r->expedite);
> +	}
> +}
> +
>  static void __init rcu_free_init(void)
>  {
>  	int cpu;
> @@ -7632,7 +7649,16 @@ int alloc_contig_frozen_range_noprof(unsigned long=
 start, unsigned long end,
>  	outer_start =3D find_large_buddy(start);
> =20
>  	/* Make sure the range is really isolated. */
> -	if (test_pages_isolated(outer_start, end, mode)) {
> +	ret =3D test_pages_isolated(outer_start, end, mode);
> +	if (ret && zone_page_state_snapshot(cc.zone, NR_FREE_RCU_PAGES)) {
> +		rcu_free_sync();
> +
> +		/* A freed folio can merge with a free buddy below start */
> +		outer_start =3D find_large_buddy(start);
> +		ret =3D test_pages_isolated(outer_start, end, mode);
> +	}

[Severity: Medium]
Can gating rcu_free_sync() on zone_page_state_snapshot(..., NR_FREE_RCU_PAG=
ES)
miss folios that a worker or concurrent drain is actively freeing in
rcu_free_pages()?

rcu_free_sync() flushes r->rwork.work and r->expedite (in addition to
acquiring the drain mutex in rcu_free_drain()) so that it waits for folios
already taken off the per-CPU lists by a worker.

However, in rcu_free_pages(), NR_FREE_RCU_PAGES is decremented as each folio
is added to fbatch, before free_unref_folios(&fbatch) prepares the pages and
returns them to the buddy allocator:

mm/page_alloc.c:rcu_free_pages() {
	...
	list_for_each_entry_safe(folio, next, list, lru) {
		nr +=3D folio_nr_pages(folio);
		mod_zone_page_state(folio_zone(folio), NR_FREE_RCU_PAGES,
				    -folio_nr_pages(folio));
		if (!folio_batch_add(&fbatch, folio)) {
			free_unref_folios(&fbatch);
			cond_resched_tasks_rcu_qs();
		}
	}
	if (folio_batch_count(&fbatch))
		free_unref_folios(&fbatch);
	...
}

If rcu_free_pages() has decremented NR_FREE_RCU_PAGES to 0 for the last
waiting folios in the zone and is still executing free_unref_folios(&fbatch=
),
those pages are not yet PageBuddy in the buddy allocator when
test_pages_isolated() checks them, while zone_page_state_snapshot() already
reads 0.

When that happens, wouldn't alloc_contig_frozen_range_noprof() skip
rcu_free_sync() and return -EBUSY, and wouldn't offline_pages() skip
rcu_free_sync() on the pass where migrated is true (before resetting migrat=
ed
to false on the next pass)?

[ ... ]

>
>  	if (ret) {
>  		ret =3D -EBUSY;
>  		goto done;
>  	}

[ ... ]

=E2=80=94
=F0=9F=A4=96 Generated by janitor_bot (expert review)
Single-turn review. Let the author decide how to proceed.
Reply with feedback if anything looks off.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019154913.1765=
974-1-kas@kernel.org?part=3D7


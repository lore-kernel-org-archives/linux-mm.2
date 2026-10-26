Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E717606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 06:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=C7mZx1i+
Received: by kanga.kvack.org (Postfix)
	id 28F046B05B0; Mon, 26 Oct 2026 02:27:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2650B6B05B1; Mon, 26 Oct 2026 02:27:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A2DD6B05B2; Mon, 26 Oct 2026 02:27:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E52856B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:27:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 685F8A8267
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:27:10 +0000 (UTC)
X-FDA: 85363795020.20.7EECEBE
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6FA4540004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:27:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=C7mZx1i+;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf27.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792996028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQSTFgbxlxLL9jSJ52YUzd8VpEj4hxBSu+fg6mberfc=;
	b=fgq7DKH0ii5etEe8BT+Q3igcCb/fF2W6dTIKLt+AjYUc0EREraLiQ0w71h+Bn+0pnLQ/TH
	CQkctkQyb62sDYuzJsjRGAO0omeh258hY5NXc7g9sg1Q6HzGKYh4ons+OZvjpDnoODz+60
	jWHTit3ENj1ZDapZr+UV0Xxc/DqN2yg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=C7mZx1i+;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf27.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792996028;
	b=x+1m/p5rh4Q9ZyTDek5WnV/V6xRv1Y5VbNiFhrav1H0rzhzw3p8cD47H79N4us3wMH+aW1
	cWi9nkQBURV88fyMw2mofBZMl+4Tut36FckixrUQuWFcei4irvlSS4fg4VYmbnJfera3Kn
	odQ8p74UPF4OG9qJl1+caZKjbSUYv90=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792996024; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=pQSTFgbxlxLL9jSJ52YUzd8VpEj4hxBSu+fg6mberfc=;
	b=C7mZx1i+GZgsuuAQxPO7LzRyynVq6mzhK0H8f0lr8gIlfAHLFfFAL0fNHkZDKUGpGB/2WYfCjg5CL03jNho/QOgTmo3YgHHEzNAxCmODlqsJp/erHMfrYyQAtKa8Ji0WCnmohR+9t1+73rPop/QooZNl2+Qa7oJTtRt2nlkryps=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R261e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0XDSv6CD_1792996016;
Received: from 30.178.68.215(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XDSv6CD_1792996016 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 26 Oct 2026 14:27:01 +0800
Message-ID: <8fe2314a-ec7c-4ff0-92cf-27f7f8c9c132@linux.alibaba.com>
Date: Mon, 26 Oct 2026 14:26:55 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/5] mm: restore per-memcg reclaim for NONSLAB
 shrinkers under nokmem
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, mkoutny@suse.com,
 david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 usama.arif@linux.dev, david@fromorbit.com, qi.zheng@linux.dev,
 yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev,
 xlpang@linux.alibaba.com, ryncsn@gmail.com, gourry@gourry.net,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261013031221.1997194-1-qinyuntan@linux.alibaba.com>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <20261013031221.1997194-1-qinyuntan@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6FA4540004
X-Stat-Signature: 71zmfyid7e38uu7dfam193krffnoda1t
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792996026-72747
X-HE-Meta: U2FsdGVkX1+TpFfNOHD445TZoufQjgNV+W3QGy4bcj8nyrJPncpXSq4mBtMrDu00Hx/vi0BTGaakHMOGbkIVSag6BXn+oaz4kwVGasnvr6m0jnbCcBrCuYrSuDkSdVpeTvP956xwO9aqwShMNlCsH59riZ6JHr/BoUMWEHxdIQ9/f9V+TcevgxxHO/gpWBVd+5DXbmqjCPN9V8NFM4oypT5OGQf8KXxMGIaJ3/benvtMbCwOgKEe+4qKzWxTrKNE2H4UDUUcBjnUjnUaeKUsyCK8vwyUUK26D0ZAKfPG5AjnR7kyuCBZ8JTstJD3Vd5OIfTTYBSVvgIwSE7hDcABrYYaTTojjqNrA0ER6m8x4Lg6DC+3Rfru4Ws1fafBNqtWHFecPcmFgIT6WKtV0pkAVATvIsVC+w37vuFg41+8jRKaczIVoSeVkgmKMiBMs8aamewE9ue01NgVfrGZv5iROhQuycj9E8nK2x2uXr21XfdEmCj2PHu0QfmYGGimu12qUhGzmYcqLzMC4oh43/0R0zSf8NzuXj+RjGcAd2F4vs48JFSqx2wgmKd2WIVm0SH6oJ8fPdia6UtWwBsAZG/AsQ/Q/dzq4QNHA8dG/HTxaGZowOxiPSbljI8IN/cSiot3sYAsM6D6DEhvDhSOMFkVNP4Er5EEM5lcpCOaeSOtRu9baGke71ZorLzFgIsjOz5ZoZZenZKL6SVfVUswtKxR8ktVSiit/ARJA26CXRAtTqKraI4q7y1iDDqvDmkP2M+SCY0Y6h47/Am8yfkQiOCPkGq0V7exxZO5AYaiiXYhJJlI7BEgXHm7F0GMp45peIdPkn9Q+EEkQIx9u4TC0b5LEXfQZrAxytfSGXLgaFyeeDahJTa0MRbzgyZOEdoiejqq2hpWMO0ykZWDvIuxNaskf/H4ZUjvUBbeF8l/AgPL0UD9Koo57vPHzkRYoP146x/DT+7PmWrGo/1x0ReXM9a
 RPZjDKje
 AV6hEOsn7cxWuspD1WRxS4Dn0+GXNg1+qX/xzdWlLeF0sVE4TzCUMOEGboGdJVv8p7Znk2nDz2r7P/y84l7ulyJtPhCcQI7OVxzm/Kl8x5wjc8XS+ndhXWhZ9CUhGxnFH+QmuNAncmUSEnU/RvP1/uqtSBPsQLmKBXIdaaPnclEXZt2L7i+Ekr7v/PUTIX+xBKlzMsVffkvfe3hu3ynAIG3fSCckwJfxi9/5hestPsX0pznyMJIVlg43y0WoJKN0UN2Q0HJxtQE7kJXk9uFCVB+K+7+heioAN7SzQ98MnOgy9UjqIfJ47ntYpwMOwcKp84FhXvKidgirzOq256YdVNB4anojIjx4aDi8Fn1zXNjbK/0bTXkzDMz8nitcWocVHApa5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi, All

Gentle ping on this series.

V4 fixes the boot hang Kairui reported against v3 -- the root cause
was that the walker reverse-resolved xarray keys as private memcg IDs
after the keys were switched to cgroup IDs, causing shrink_dcache_sb()
to loop forever on the global drain. The fix passes the xarray index
directly through the internal walk path (new patch 1), so no reverse
lookup is needed.

Could someone take a look when they have a chance?

Thanks,
Qinyun Tan

On 10/13/26 11:12 AM, Qinyun Tan wrote:
> With cgroup.memory=nokmem, the THP deferred split shrinker and the
> zswap shrinker are degraded in two ways.
> 
> First, both shrinkers are missing the SHRINKER_NONSLAB flag, so
> shrinker_memcg_alloc() demotes them to non-memcg-aware shrinkers:
> limit-induced reclaim of a cgroup neither splits its partially
> unmapped THPs nor writes back its zswapped pages.  v1 of this series
> [1] restored the flag to fix that.
> 
> However, as Sashiko's review of v1 pointed out [2], the flag alone
> is not enough.  __list_lru_init() also collapses every list_lru into
> per-node lists under nokmem, so even with the flag restored, the
> objects of all cgroups share one list per node: the per-memcg
> shrinker bit is only set for whichever memcg happens to repopulate
> the empty list, so pressure in other cgroups may not even trigger
> the scan, and when it does, the scan walks everyone's objects.
> 
> Before commit fafaeceb89a5 ("mm: switch deferred split shrinker to
> list_lru"), THP had fully per-memcg deferred split queues embedded
> in struct mem_cgroup, working independently of kmem accounting.
> nokmem only opts out of kernel slab accounting; THPs and zswapped
> pages are user memory and remain charged to their cgroups, so
> per-memcg reclaim is still what these shrinkers want.
> 
> This series keeps list_lrus backed by SHRINKER_NONSLAB shrinkers
> memcg aware under nokmem:
> 
> Patch 1 passes the xarray index directly to the list_lru walker and
> drops the reverse memcg lookup that v3 still performed between the
> xarray iteration and the walk.  That lookup was the cause of the
> boot hang reported against v3 [3]: after the keys were switched to
> cgroup IDs, the walker kept resolving them as private memcg IDs, so
> the global drain kept skipping non-empty per-memcg sublists and
> shrink_dcache_sb() could loop forever.  Passing the index directly
> also removes the temporary css reference from the walk.
> 
> Patch 2 drops the kmemcg_id copy, which is only assigned when kmem
> accounting is enabled, and indexes the list_lru xarray with
> mem_cgroup_id() instead, so the index works independently of kmem
> accounting.  The list_lru plumbing passes memcg pointers now, and
> memcg_online_kmem()/memcg_offline_kmem() are inlined into the css
> online/offline hooks.  It also drops the nokmem early return from
> the offline path so these lrus are reparented on offline.
> 
> Patch 3 keeps a list_lru memcg aware under nokmem when its backing
> shrinker is registered SHRINKER_NONSLAB.
> 
> Patches 4 and 5 restore/add SHRINKER_NONSLAB on the THP deferred
> split shrinker and the zswap shrinker.
> 
> The savings of nokmem are preserved: slab-backed lrus (e.g. the
> superblock dentry/inode lrus) still fall back to per-node lists, and
> the per-memcg lists are only allocated when a memcg actually holds
> such objects.
> 
> Changes in v4:
>  - Fix the boot hang reported by Kairui against v3 [3]: the walker
>    no longer reverse-resolves the xarray keys; the index is passed
>    directly through the internal walk path (new patch 1, split out
>    as a preparation so patch 2 remains a pure key switch).
>  - Drop the kmemcg_id member from memcg_struct_check() along with
>    the field removal, as pointed out by Gregory Price [4].
>  - Otherwise unchanged from v3.
> 
> Changes in v3:
>  - Index the list_lru xarray with mem_cgroup_id() (the cgroup ID)
>    instead of the private memcg ID, whose lifetime only covers
>    online groups, and pass memcg pointers through the list_lru
>    plumbing; inline memcg_online_kmem()/memcg_offline_kmem() into
>    the css online/offline hooks (patch 1 as numbered in v3, per
>    Johannes's review of v2 [5]).
>  - Describe in the THP patch's changelog why fafaeceb89a5 dropped
>    SHRINKER_NONSLAB knowingly, per Johannes's pointer to the
>    original discussion [5].
>  - Collected review tags: Johannes's Reviewed-by on patches 2-4,
>    Nhat's and Yosry's Acked-by on patch 4 (numbering as in v3).
> 
> Changes in v2:
>  - Keep the list_lrus behind the two shrinkers per-memcg under
>    nokmem, so the shrinker bits are set for the right memcgs and
>    scans stay scoped to the target cgroup's objects (patches 1-2
>    as numbered in v2, new; addresses Sashiko's review of v1 [2]).
>  - Patches 3-4 unchanged from v1; collected the review tags.
> 
> [1] https://lore.kernel.org/lkml/20260904033503.4067283-1-qinyuntan@linux.alibaba.com/
> [2] https://sashiko.dev/#/patchset/20260904033503.4067283-1-qinyuntan@linux.alibaba.com
> [3] https://lore.kernel.org/lkml/20260910080722.3961351-1-qinyuntan@linux.alibaba.com/
> [4] https://lore.kernel.org/lkml/arNK64PxTXbVEhis@gourry-fedora-PF4VCD3F/
> [5] https://lore.kernel.org/lkml/20260907110111.2286932-1-qinyuntan@linux.alibaba.com/
> 
> Qinyun Tan (5):
>   mm: list_lru: pass the memcg index directly to the walker
>   mm: memcontrol: drop kmemcg_id and use mem_cgroup_id() for list_lru
>     indexing
>   mm: list_lru: keep per-memcg lists with nokmem for NONSLAB-backed lrus
>   mm: thp: restore SHRINKER_NONSLAB on the deferred split shrinker
>   mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB
> 
>  include/linux/memcontrol.h |  16 ------
>  mm/huge_memory.c           |   3 +-
>  mm/list_lru.c             | 114 +++++++++++++++++++++----------------
>  mm/memcontrol.c            |  45 +++------------
>  mm/zswap.c                 |   4 +-
>  5 files changed, 77 insertions(+), 105 deletions(-)
> 



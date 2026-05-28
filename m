Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BC64CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 07:08:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7433C6B0088; Thu, 28 May 2026 03:08:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F46E6B008A; Thu, 28 May 2026 03:08:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E35B6B008C; Thu, 28 May 2026 03:08:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48A616B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:08:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BCEA71C0668
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:08:24 +0000 (UTC)
X-FDA: 84815950128.08.757A741
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2153B20008
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:08:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nsU8QIVn;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779952103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2clXgxZ7c/pvTfwrBOL3xWfVe49AoMGW0QPsabdY69E=;
	b=T8Aoheyu262pWZmUv7+13C65NA3fPbdSuBqjJSEkBkM0cxQkH5g1/qPca+GDmWbOk3IL93
	CQtKHTmOm1ydqCYrbxglfSZp8SDG6Z6ARJbXQeGBK4l75RDerilKt5mQ3BDlBt6bApwJqa
	45HisvEZe1DgA483CRy9BL3ClrN9zNc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nsU8QIVn;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779952103; a=rsa-sha256;
	cv=none;
	b=vi4SAfiN+j4WLEKwpR9E+bfNg9N4ex3sZoFWIQQCPOtDgw+FkbcMg+WPRqMKV1Sw9y5dmL
	/Nmw574EwXXsfgx8+j66rF1kI+si/b8J5YVMqm7D049E/YvKm+iRrm+KbfjqBp/UJoqd2e
	oJhDS+hLuBMZgMWke1IryB/MwihWhpA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 91501605DB;
	Thu, 28 May 2026 07:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8FB1F000E9;
	Thu, 28 May 2026 07:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779952102;
	bh=2clXgxZ7c/pvTfwrBOL3xWfVe49AoMGW0QPsabdY69E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nsU8QIVnzMzyn+e5flwiiHA/nxMSp4B2s5E4s8GCGm9FdqniH/FM2BJVo3BCL7E9H
	 WiczwUgsMG+N40nxLMQfi/hQDfg9FLex9EpkdbyGdeoKHJ1irUaWlj50wNHxxyOjUH
	 eL34XxZW0yowXuinlK4+p2rd1DzgRWxhhNk3Rk+Lxo5foLNd448BKiT8Z+qj4dCgrv
	 ughS2fH+WCB5KapD2thqP/ppjXCPcjt35qn3hOZgKQHnfeuE2kZbp4mrZnXl/40B9M
	 Imq9Z/rPiBimvN6/jy+Yg4A2EGv//iaJ5HXbdGcCSe+qLAbaMsx+Ff5G7+FZnQmnBI
	 aPPm/WjSkNmGA==
From: SeongJae Park <sj@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Kairui Song <ryncsn@gmail.com>,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 9/9] mm: switch deferred split shrinker to list_lru
Date: Thu, 28 May 2026 00:08:05 -0700
Message-ID: <20260528070807.144064-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260527204757.2544958-10-hannes@cmpxchg.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: togk7pyagt8nmb6bg15tjrouema6197m
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2153B20008
X-HE-Tag: 1779952102-468498
X-HE-Meta: U2FsdGVkX19xCrVKbHzzKUKsljDzlxtDqH4mw9Cce4WewVCwFfyK8Q93HD7+969xnbMpaUujn02ocBxp2OaauniOhUr+5HAObcSOIiTBAkamBOxV/u8dTXvw2xMXgdgrH4nUdxQFuA2A3NzPQUl8R851xi+NGvaOven07wGT6VnU3F8o9TLfuWfvHAbdElXnS14FWQsDAbBfM0gt28PjcsoktXj0T/+FNa58aHWYngWq55ZFhCubpRt5h5kN2i4kRTAC/XVyR/SFnVIdSttk9gyZKwN32GZpRaBwt1H10aNaGggyJ3DJbGHH1zIZnnQLdJxZy0MZMen5rDwLae8ArS5bAqZ4+9UetGlMORQ2pqj9jeMfLuwOW5+RzzAnwnmZ7psJF87KCK5+/HTtCJQIBVrxC2a/1GuNvRmUiOasMwd7SmgBKTQf8KhK6MLHLOdEues2cUgM4lpqOI7qMLPjbErsMktf6o2HEhkKV23V306xzN4OKVOMU8Ka6uk7N2pxnn4Xei8YwGFMP4XrU8odvKzenKREhO7qr+lzd5wCM+REF0OVtEcdShr3n4V8LOBT0RcwXPFMmJi9Xsjy1Zka0fClBkAPlBK36mmL7yQmv4EhvFoY1cBtJwPis5G2D8glb0UTILiUZTgrWvqvsvXvfgvQFTLFM3jGZJK3imHmczbrKxSlddDLGyUIeEHp4R5XSC3hxbv+jiGmfA/QkkyzUg9vOZJ0vRAmSmiea09KXkM/D+/ROWy6YtfAht8o4p2Jifk0zxIAaTGZ9vyDfjwOnea3+S4xyO41w9RDYFAFSiVvQTw1OBhKckrr2ZfaE56Rz0KaKwO7VujpjqMM/+6RNRaIWhhJ8lZa4yFN8AMbcbDOLQdEtbOicJqpKp5axno9O3yJqls2v621/KLI1VogJdRBspOAOQQVqmXn4MrKrAkR8RQkE6pzEf2mdwzUzo1wPy/eSYddMnpJOWLzFNh
 jYTviy8a
 czvkeAhngapViqWs5YxUUXoR3Db9/ebpc5I2uWAKzpCMe4BUkLnszoTCdMUuIMlasc8aKHINthFUgVp2KeQ0HJ7X13OGJwlIV5Xtucm5uIMyIGAUGJmS8z3tjccS4Q+7mm1yTD30s5fG2d150eDde3EepykyoaBUN9SqASCOgepZNE9RopcGngWDQHQoHtveSpfNTymKEsoIuNnRqOKbezTIsbj/+CiU7Hp8ODNF3BzrP6mLfUCYd/+4ZQUFabWVdWS0H2S5EQjqQefA3XANv80PaNWHVQyrt/6JjjSNJyIWhmP6bE1Bdim6JE5BkoggWqSsS3jBJ+KBzkcr4nXhn6uvf3kGqUCeGmykL2TeHkx8+67KkoxIOp+VQ0hvKHJ9mqMYtVYWkdZD7RKnvOepcShw0jR8b2NiFG8TSGI4+OvROUhc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Johannes,

On Wed, 27 May 2026 16:45:16 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> The deferred split queue handles cgroups in a suboptimal fashion. The
> queue is per-NUMA node or per-cgroup, not the intersection. That means
> on a cgrouped system, a node-restricted allocation entering reclaim
> can end up splitting large pages on other nodes:
> 
>         alloc/unmap
>           deferred_split_folio()
>             list_add_tail(memcg->split_queue)
>             set_shrinker_bit(memcg, node, deferred_shrinker_id)
> 
>         for_each_zone_zonelist_nodemask(restricted_nodes)
>           mem_cgroup_iter()
>             shrink_slab(node, memcg)
>               shrink_slab_memcg(node, memcg)
>                 if test_shrinker_bit(memcg, node, deferred_shrinker_id)
>                   deferred_split_scan()
>                     walks memcg->split_queue
> 
> The shrinker bit adds an imperfect guard rail. As soon as the cgroup
> has a single large page on the node of interest, all large pages owned
> by that memcg, including those on other nodes, will be split.
> 
> list_lru properly sets up per-node, per-cgroup lists. As a bonus, it
> streamlines a lot of the list operations and reclaim walks. It's used
> widely by other major shrinkers already. Convert the deferred split
> queue as well.
> 
> The list_lru per-memcg heads are instantiated on demand when the first
> object of interest is allocated for a cgroup, by calling
> folio_memcg_alloc_deferred(). Add calls to where splittable pages are
> created: anon faults, swapin faults, khugepaged collapse.
> 
> These calls create all possible node heads for the cgroup at once, so
> the migration code (between nodes) doesn't need any special care.
> 
> Reported-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
> Tested-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  include/linux/huge_mm.h    |   7 +-
>  include/linux/memcontrol.h |   4 -
>  include/linux/mmzone.h     |  12 --
>  mm/huge_memory.c           | 364 +++++++++++++------------------------
>  mm/internal.h              |   2 +-
>  mm/khugepaged.c            |   5 +
>  mm/memcontrol.c            |  12 +-
>  mm/memory.c                |   4 +
>  mm/mm_init.c               |  15 --
>  mm/swap_state.c            |  10 +
>  10 files changed, 150 insertions(+), 285 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index edece3e26985..f6c2531a27a3 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -423,10 +423,10 @@ static inline int split_huge_page(struct page *page)
>  {
>  	return split_huge_page_to_list_to_order(page, NULL, 0);
>  }
> +
> +int folio_memcg_alloc_deferred(struct folio *folio);
> +
>  void deferred_split_folio(struct folio *folio, bool partially_mapped);
> -#ifdef CONFIG_MEMCG
> -void reparent_deferred_split_queue(struct mem_cgroup *memcg);
> -#endif
>  
>  void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>  		unsigned long address, bool freeze);
> @@ -664,7 +664,6 @@ static inline int folio_split(struct folio *folio, unsigned int new_order,
>  }
>  
>  static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
> -static inline void reparent_deferred_split_queue(struct mem_cgroup *memcg) {}
>  #define split_huge_pmd(__vma, __pmd, __address)	\
>  	do { } while (0)

I found this patch is now in mm-new and it makes UM mode kunit fails like
below.

    $ ./tools/testing/kunit/kunit.py run --kunitconfig mm/damon/tests/
    [00:00:02] Configuring KUnit Kernel ...
    [00:00:02] Building KUnit Kernel ...
    Populating config with:
    $ make ARCH=um O=.kunit olddefconfig
    Building with:
    $ make all compile_commands.json scripts_gdb ARCH=um O=.kunit --jobs=8
    ERROR:root:../mm/swap_state.c: In function ‘__swap_cache_alloc’:
    ../mm/swap_state.c:468:26: error: implicit declaration of function ‘folio_memcg_alloc_deferred’ [-Wimplicit-function-declaration]
      468 |         if (order > 1 && folio_memcg_alloc_deferred(folio)) {
          |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~
    make[4]: *** [../scripts/Makefile.build:289: mm/swap_state.o] Error 1
    make[4]: *** Waiting for unfinished jobs....
    make[3]: *** [../scripts/Makefile.build:548: mm] Error 2
    make[3]: *** Waiting for unfinished jobs....
    make[2]: *** [/home/lkhack/linux/Makefile:2143: .] Error 2
    make[1]: *** [/home/lkhack/linux/Makefile:248: __sub-make] Error 2
    make: *** [Makefile:248: __sub-make] Error 2

Maybe we can define the function for CONFIG_TRANSPARENT_HUGEPAGE unset case?  I
confirmed the below attaching temporal fix works for at least kunit.


Thanks,
SJ

[...]
=== >8 ===
From 23b5800dd49085707baee5774b74782c3e424f24 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Wed, 27 May 2026 23:58:07 -0700
Subject: [PATCH] mm/huge_mm: define memcg_alloc_deferred() for
 !CONFIG_TRANSPARENT_HUGEPPAGE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Without this, UM mode kunit fails like below.

    $ ./tools/testing/kunit/kunit.py run --kunitconfig mm/damon/tests/
    [00:00:02] Configuring KUnit Kernel ...
    [00:00:02] Building KUnit Kernel ...
    Populating config with:
    $ make ARCH=um O=.kunit olddefconfig
    Building with:
    $ make all compile_commands.json scripts_gdb ARCH=um O=.kunit --jobs=8
    ERROR:root:../mm/swap_state.c: In function ‘__swap_cache_alloc’:
    ../mm/swap_state.c:468:26: error: implicit declaration of function ‘folio_memcg_alloc_deferred’ [-Wimplicit-function-declaration]
      468 |         if (order > 1 && folio_memcg_alloc_deferred(folio)) {
          |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~
    make[4]: *** [../scripts/Makefile.build:289: mm/swap_state.o] Error 1
    make[4]: *** Waiting for unfinished jobs....
    make[3]: *** [../scripts/Makefile.build:548: mm] Error 2
    make[3]: *** Waiting for unfinished jobs....
    make[2]: *** [/home/lkhack/linux/Makefile:2143: .] Error 2
    make[1]: *** [/home/lkhack/linux/Makefile:248: __sub-make] Error 2
    make: *** [Makefile:248: __sub-make] Error 2

Fix by implementing the function for CONFIG_TRANSPARENT_HUGEPPAGE unset
case.

Fixes: https://lore.kernel.org/20260527204757.2544958-10-hannes@cmpxchg.org
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/huge_mm.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index f6c2531a27a35..055de7b8ed487 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -663,6 +663,11 @@ static inline int folio_split(struct folio *folio, unsigned int new_order,
 	return -EINVAL;
 }
 
+static inline int folio_memcg_alloc_deferred(struct folio *folio)
+{
+	return 0;
+}
+
 static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
 #define split_huge_pmd(__vma, __pmd, __address)	\
 	do { } while (0)
-- 
2.47.3




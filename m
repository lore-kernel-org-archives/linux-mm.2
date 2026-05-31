Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7286BCD6E55
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 08:01:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4E266B010F; Sun, 31 May 2026 04:00:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FEB66B0110; Sun, 31 May 2026 04:00:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ED966B0111; Sun, 31 May 2026 04:00:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7EAF46B010F
	for <linux-mm@kvack.org>; Sun, 31 May 2026 04:00:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 23FF1A0422
	for <linux-mm@kvack.org>; Sun, 31 May 2026 08:00:59 +0000 (UTC)
X-FDA: 84826969038.14.D4A5B56
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2236820017
	for <linux-mm@kvack.org>; Sun, 31 May 2026 08:00:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aSM10HHP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780214457;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FwkGhwJc4adPpZ7Bnkh8nEE7m2fCygkfGd6/PO7C4fk=;
	b=0khNqdaxAfNojD2EE8PISXYS9RTqw2PPCWN7A8WYTa6DMYC7jyYG9UnByPfOM+HYOM9+ZZ
	9JZjXmtQ88sCkJhVuPjuRYlefv8AvpPdDU4hffC6qOnCbJAQeDzJ8R+EZU7SjQlBRCc4xj
	4goEEyr7c/tSzoMCbDAdycHxgNL7nVk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aSM10HHP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780214457; a=rsa-sha256;
	cv=none;
	b=NWxMcTt8uXZXhs3WcMNaTZzc8sdpDW30BydZBPeLtxIY5gwGWNuiNphZb0go8/m5RMPwvO
	k+KD75MS/5bqhSqQuJE+QP07e7KYyBJUuIiIcM7I5KynSNg4uM1+oeFJqdyh+xqU46yzOQ
	ztNgcjp9gWSTk935+XuuLCaaKoA3uzk=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-bec43ee8ff0so50023766b.1
        for <linux-mm@kvack.org>; Sun, 31 May 2026 01:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780214455; x=1780819255; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FwkGhwJc4adPpZ7Bnkh8nEE7m2fCygkfGd6/PO7C4fk=;
        b=aSM10HHP/ZrDDW2aGLBdjAJXaue2FSQyUK+ZLSACq8x28a9JDky4+ZPezken1ddIBO
         Vn/dtxWN8rWdgymPFdybja5sJNmxno/qZAUdNxaYzYzEmrHcvk5AZDuUo12LTdl05QdD
         2Bdk1IBnOpQZvVhX25yuKZplnZQnKA7Vm2MZ6QEujkPhY3vmYiQ85DhWjj6ONfcRPVuE
         NNDScufRNGRiF005poVGRc3+pU6v1eHFDzcLogFeGnGeN+cVXfZWEFzZOIK0cHckyFL6
         NY2SXcD+w7IMzIpK6cgG36YA4mNzpFCT1VFef8rz6N60S/g7cPXxVqsRNlWtYWd5vWiO
         0h0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780214455; x=1780819255;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FwkGhwJc4adPpZ7Bnkh8nEE7m2fCygkfGd6/PO7C4fk=;
        b=Y8oegbqoyhATlSLW+JTKfdVj2zint6tOTnMdRgC4xVGRaUJE00g/zK89l9T/bDIYVL
         JWd71GEk1PexLjyj22YsCE6M4qVZa73QbIRtbJfO39EKFSr8jREH9G2w9KX5AI9sNjIT
         IkSn32476PODhX421zi/gfYHEhZGoXoNBtb/NYuJI+NjR6sNoO8YKvJ73BKNinD4UHv+
         JghNocwwR4H8zCL9DZsKCJQxBB1C6vHyEPQ1NoiGCH6etzzr1HWQ8EnrlHqChBBrH/y5
         P4iK5l2lkQS2IFVbcY/8Si3BHcH7LdYDfobN6bLjJhnvWl1HKVM9uBtcQi3Q8ksf0V6X
         HNsA==
X-Forwarded-Encrypted: i=1; AFNElJ/g8ioK2pZESuwggnGM7tovvy5ILNsJMMzi/7Dqtw4OueBbvFGydgVV3ap69rhcm766/t1bOfB7sg==@kvack.org
X-Gm-Message-State: AOJu0Yz21ur9FSdAj+kwh2s5qo8SJgAn/MYoPSrB1f0GkxjsBnjem+08
	UqgDRvQK3joUTI75nkN9/DvbcszdoGAYmHVwapo6BMFWnXvl350qsodd
X-Gm-Gg: Acq92OGi4yOODtZrd1xQjOOHRBgw9M/JgTC3SiluaeLt4n1F7edBqg4V7H29Sw8h/S+
	uxFcdwuThGNK4o5DQpX2xMbvzfZWT828c1/rJDfowt5sZXwvVqDWVlWGGzj0eUOuKKz6s5wDcKC
	gmbYFyLm5U7Q1PxCVESsCYxKgZ38kGylOX0tKJfPLJFiw/wkb/LEdDK7dgNu5UyHfqMb7yXayJv
	Kmv0WvXYOWaOnXduF4tu/5tDAoHHrL4vZqWehgR3o3kaqA+Ir2O7+avcThMum+LXBuAzvAOYkSw
	inmAOzBxwqP3J9W8Vg2/X1ROmxuKhnGWp90dq/A4R3kQ4ukj6CxUrrCtTFa6hGUAQ7ug7IsFYet
	z16fI9PwkgV0RD2pZjFTeMyBsiWaMaPPR67m5xjazVOilPJXQMphdWLp+vdRjimjIB1drB+AUEI
	se8z9Re5ejI1CjVV5gGWzNeWyv+746P9FJ
X-Received: by 2002:a17:907:d310:b0:bec:ebd7:90dd with SMTP id a640c23a62f3a-becebd7a10fmr24002566b.21.1780214455180;
        Sun, 31 May 2026 01:00:55 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bec5e5be0d4sm41821066b.52.2026.05.31.01.00.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 31 May 2026 01:00:53 -0700 (PDT)
Date: Sun, 31 May 2026 08:00:52 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Kairui Song <ryncsn@gmail.com>,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 9/9] mm: switch deferred split shrinker to list_lru
Message-ID: <20260531080052.guzobbwdvprrmger@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260527204757.2544958-1-hannes@cmpxchg.org>
 <20260527204757.2544958-10-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527204757.2544958-10-hannes@cmpxchg.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: 3p6uacpp1qbqdj1ud7stk79x66ddghjn
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2236820017
X-Rspam-User: 
X-HE-Tag: 1780214456-2967
X-HE-Meta: U2FsdGVkX18qMoYgOCN9Uhy33ZRuBMu2elvJagY2GA/MrLyfrLaPnzBGmRp1a0x1vsPvqqufZ/II2Tr4lkWBCp/OlMSRDUzW9ykpaDk/E+VJ8qC7ZeT85I/bfSn2Ot4xBjZJ4FHQKIdJozAon2jrzvRFk05YTkHWqxyo7buupRpSbNZ2NAMbiPuA2LAg7RFsgaC0j57/redqA3epFM5tEpOT3Mt2zStZPcatSSI4McvszjPzwWD8ER7nrySUv2zbA0W3bMHk81h7wb/GIXkCGeUk0/anfTrZu0QXbcG2hFTpIKFvxRPKPF1kTpx6NCIPggLvufQpGpXulf+JQhkhqQObBnvv89GRVg6xjt0eCQ4pI+IbbJfn5AKgzzRE1OIt66SQcT2XaC5A2kkbI0wHS1DjrcoJjh8e/vW44ubWamualVuC6c6Sh214BQPDzg7/nnDqlwr7Za0NcjNGKhuCzOyYRQyWX+F4LLPc93xZn1rrD+HvHGQveuqV7LwnT9NSWt9eZgtddtip2g8cAKVzvH9wUqpmFV4BviIScIgAD1DKEZh/SWJzl35W9n26L6lTUcXsXF2MnlDqUkgSel3SdbZTPzNCxkrvFEMsctC8NBH7kd2gKdpo38b5G8URgDTEb7PI56FwW2fbpivLLUmr0sfL1ZubH3s3Ub/F5q5QDHJ4Gw8lnustNeP6abkxk+5vw3iwKzNGSxopOXcJpp2psfui8TG9TG5kDr/R47ZZPCIE1ow8R9MHSYk2M/2ky900w/xNfnAdgfcdS/22nxDGib7kk8O1DaA7jd1U+ZfN2VxecUmvKXzlfnwqbNmhLWnCpX0tH2FDqnBN8ZVBGDfe4VWyJ97aQrIgJaLzt+YR/TG9GnZZUDHqLQntMuHFgyb9PWJMzFLB/g/se1WfZujUGnKpbqWZhMl29gR63fABT8dlZO6VVl1tSchLsKURt8lBWKn6swfjR4p2KGCyniW
 ho+CKTDj
 9mTROnAT3sSbjmltnv18FKXIS3aZNt/OHvCUhq3CLj8YoZmgpbkm1wGi9OqUmVwSSraSu7plMH72hx7MCvRmR19Eb+vuZZdOUmNN19hjSeBWNspv6L9Ok4ygD/KkwgnPM/SWltDBbQOaa6CxKMNrF+9q21bhdLCUnrKOk9RHya1tq2XwCBD5ZyELGUDZ4TMkBRPZxJHS6uqdMRRhI/40PE5ulKt23kTiZh2lE5wVUJt/BHj6t9BsWHGDulrqsbNm0p03XOiRKn7j5NXao8VP56UBgAZPrSuQOzqAXz5dg/Ju9ONPQCK/Ot/7OeLRJyu866SsYGoYq6byry6HHHK8UWHC+puVttEHHZbWl2Og1/LhQOh6AA/jr/RBbqKeBlWdXWllrFpZ4WQS9Cwqpr+RNPxDVgKTV5zj/nHJVEK01exnG8qpZ4T0NBZQ/ChLKftyQMKHfRCioB7NL1Z390lLVHgrwPP7G0Dra0TgssSeudIbsoUlelCHzUoptJ8g3RtKHnfsAVZUIwTbJJ/j0/vT9gR3D4AL8jGh8dOyPVVz06s3C1D13X6jyVrJ2F1g7PIAjcGPdkUqrlDBdLU9OOdteie5PNnuxhW7zElqKWz8o4bNZLLylswvNNp/gAe/L3z31phwVDxMywcm1FwkNmCIY0dU2I37w51Gr79J5ZjDHRwwZrkmqCiCDXNLxhEyEPP17AUQnbdvT6ARH1hiEk8R7BP92cMV7qKRyGo/D23yMivlvORYrey/rtiv95cQmxohzB2ZXM2A8TupSml3r+mn+LuyGcJ6ZplB9AKrg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 04:45:16PM -0400, Johannes Weiner wrote:
>The deferred split queue handles cgroups in a suboptimal fashion. The
>queue is per-NUMA node or per-cgroup, not the intersection. That means
>on a cgrouped system, a node-restricted allocation entering reclaim
>can end up splitting large pages on other nodes:
>
>        alloc/unmap
>          deferred_split_folio()
>            list_add_tail(memcg->split_queue)
>            set_shrinker_bit(memcg, node, deferred_shrinker_id)
>
>        for_each_zone_zonelist_nodemask(restricted_nodes)
>          mem_cgroup_iter()
>            shrink_slab(node, memcg)
>              shrink_slab_memcg(node, memcg)
>                if test_shrinker_bit(memcg, node, deferred_shrinker_id)
>                  deferred_split_scan()
>                    walks memcg->split_queue
>
>The shrinker bit adds an imperfect guard rail. As soon as the cgroup
>has a single large page on the node of interest, all large pages owned
>by that memcg, including those on other nodes, will be split.
>
>list_lru properly sets up per-node, per-cgroup lists. As a bonus, it
>streamlines a lot of the list operations and reclaim walks. It's used
>widely by other major shrinkers already. Convert the deferred split
>queue as well.
>
>The list_lru per-memcg heads are instantiated on demand when the first
>object of interest is allocated for a cgroup, by calling
>folio_memcg_alloc_deferred(). Add calls to where splittable pages are
>created: anon faults, swapin faults, khugepaged collapse.
>
>These calls create all possible node heads for the cgroup at once, so
>the migration code (between nodes) doesn't need any special care.
>
>Reported-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
>Tested-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
>Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>---
> include/linux/huge_mm.h    |   7 +-
> include/linux/memcontrol.h |   4 -
> include/linux/mmzone.h     |  12 --
> mm/huge_memory.c           | 364 +++++++++++++------------------------
> mm/internal.h              |   2 +-
> mm/khugepaged.c            |   5 +
> mm/memcontrol.c            |  12 +-
> mm/memory.c                |   4 +
> mm/mm_init.c               |  15 --
> mm/swap_state.c            |  10 +
> 10 files changed, 150 insertions(+), 285 deletions(-)
>
[...]
>@@ -1379,6 +1285,14 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
> 		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
> 		return NULL;
> 	}
>+
>+	if (folio_memcg_alloc_deferred(folio)) {
>+		folio_put(folio);
>+		count_vm_event(THP_FAULT_FALLBACK);
>+		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
>+		return NULL;
>+	}
>+

Nit: we have three possible failure point, and some duplicate
count_xxx_event/state().

Maybe we can have a followup cleanup for it.

Others, looks good. Thanks.

-- 
Wei Yang
Help you, Help me


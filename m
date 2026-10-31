Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4714C606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Za6UBL4q
Received: by kanga.kvack.org (Postfix)
	id 645966B05B2; Sat, 31 Oct 2026 05:08:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F82D6B05BC; Sat, 31 Oct 2026 05:08:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E5576B05BD; Sat, 31 Oct 2026 05:08:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 22E726B05B2
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:08:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 95D0C1208D9
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:08:24 +0000 (UTC)
X-FDA: 85382345328.20.891F7F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0767C20006
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:08:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Za6UBL4q;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793437703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tm5Bg/j5fUgwCZIJXEdNeBM4C4IjSDPmSRohlhbzh7o=;
	b=xxelrHyCLN5uZcVSl54w45jvNJqD76YCDR2uE+WYomQGlRFh5VTow/ZKHIaXzLkLqKgoPf
	JPSkoMS4LmOym+iF+SNYmgBCyxCMYjDSrcvF9APu43MluheHB7JKO6oU9db+0C1n/xotox
	35/E2NyFr2nK3UC1m3w527RIm7Qz0Io=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793437703;
	b=ZQV1EHtXwJkrEDLczArv/wxxvud4DvpgzDpVWCk+EYG+P4KnREuTkbbe9GOTpRG+t6GXkP
	B5Wy9iuEqA8uXLfKL3QAZ37211O2nVUaQ2TUKHUCiEjqkGbXcgEo+qgywvuX23g+uOj79c
	pkj3IPssg6nkRDMhEr0iWitB5AsLwSA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Za6UBL4q;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6FED6600D4;
	Sat, 31 Oct 2026 09:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087B31F000C1;
	Sat, 31 Oct 2026 09:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793437702;
	bh=tm5Bg/j5fUgwCZIJXEdNeBM4C4IjSDPmSRohlhbzh7o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Za6UBL4q5Ycah54CTfxr5+sWHe8Spk6G9/PM8TWndexFEz4xe8Ia9QhE7YgOeQfLx
	 QBjpQpZ7zK42HjwtQcv9q5H9iWUAmJoCvett6ZnZ2h1EPXySuTupdbvUejz6CSLyAv
	 ps+J1YQJbUkNmxcYDEnK42bZy0HyeREwHmwQaWQGcPq11yLz76vkzKY5N8egBtrAvm
	 OuJOqZ+3a0o6YiWKa0H73L8AQNSsOZLegMy9g0P5BpVVnGKvj8I3yOiQDMVp2lPB66
	 /nFghzHltrl/jL2BYEVTXpNGTeHPsu2kQ0zIZ8FEWTGgjsuofVB6JTJ2KsXJdV+9pV
	 9nOGaDV2cw20w==
Date: Sat, 31 Oct 2026 09:08:06 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Byungchul Park <byungchul@sk.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Dave Chinner <david@fromorbit.com>, David Rientjes <rientjes@google.com>, 
	Dennis Zhou <dennis@kernel.org>, Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
	Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	John Hubbard <jhubbard@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Matthew Brost <matthew.brost@intel.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>, Nick Piggin <npiggin@gmail.com>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>, 
	Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Will Deacon <will@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/7] MAINTAINERS: sort entries in MM sections
Message-ID: <auWqPPYNQlwAOAnm@gremlin>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
 <20261030-maintainers-v1-4-97278f8a5f54@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030-maintainers-v1-4-97278f8a5f54@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0767C20006
X-Stat-Signature: mqrgs5qn5h9a1ymxmeuycwedkzy4up4h
X-Rspam-User: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793437702-314346
X-HE-Meta: U2FsdGVkX1/CdB8HvDyMJt6F7SKRiBFQ3WMWtqL9sfKRiW6MJT+pP6ilFdgicZvq9c3Wi+/g9Jjeqq7/ZVC4UGImT468bXSHRxg/XBFcRzZD1TmVml1I7KFQHsYSTIkKg6wNX2S/hQaLH+O1mhOUBxcWMT2XKlpVYrzCoZuZJZgELvaCBLHlr6PhV42p1+sMNUeH1VubGmYzz7qKmYsTXNmhsgeUzamiHNK1CYMzO2wjWUxkrYMqHDntLBBSRmT/b6gec9Ggo2V5+8+t8ZwS5/6p7amd95Ar3iCvSrYODZkfdyOkVpj3BcxPOdWT6cnX7oRln506hR9qRTnnjHFRBbCOSFg+6drz/Y6FtPsa8RTbBdHMOG8fQbDBJWbt0GJxBTuKQc3LTrMjIUwV+yOcThWKX+nW/4/DzWevPA9RfOhG2qnNhSDwolL2pPjX/X9Sb3ysBsLP/xxD2d0Ae3dgo/Gdg1nHptaM+Lq3rJT9bb+CPVhcd0SGxCNx+6ENNCnd40fvnUkm+0KdpQwjpyT16ZUUnPccICTIX7neWJ0wTgBgoTteC4hcc0aW6iccYz+d3S1M7UyDggOosNPh93jmb0H2RbGtQzGUXVPkPicfcd3d5FdSK2ZTE1geOsTaPeGoPlo0kx4kSQIhjoo5w4X1A1t5Ae4s0KVD1X7aaDmRf1s5WKLkrOipXG3efxnjOCqBCbcdzWg4RZZI+VCLwGV/uDs9WVTGH+J/D5cjhsWG5VeoP8TI11aDHXYRn1Kmf4j/vjoQTMpFX5yl/eKNbyvJ7HCry2oEO/g0Bp6yDq3ewzTr+MGWLq0LpZHfkUr+Cmm20PJ2IcfJkR7SC2McRx+3UHHHOout/308RtV1iWIvu8wIWW3htKwhMxunMJjjFgVpMnFccvhHmpulHs5F6F0x7usLOe8R0FsXW9LnAeYoEQBjs5bdO0cfmRdugY3wqpGpYbziI7JU8JXGbu1+CsL
 wWbzvqh4
 EewSFmIML5jZ08/JKIEFo7/TXcDO9/RNQTDIVHEYuiHHaWqAqzFjBVGCGjlY6rLuaW08c5NbA+1xgO/CuTO3Ig+h+O5Usw2l1thDkPcD6SZkdSne7Zyk3Qmld42uheTOXYWJDHVZjYyRm/AnmFrm0RKplqet3X1nW9PI6mdseO89t4cI8X9GNHxPx3o0e6S3UXzug/jL5zh6vP7VO9LqutVxBwdes1ZbvmzonIFmyUwACQa8zH8Kp16Ym6v1KAbNLtqyh+P61ZVYvApkJnnP+LRPj87nPBOSN3jlxQibwdcZN8mN3usPgJQ0VQ8v3UPinWVmv621qDzPHV9PSqJoeZaEeRY4fQzdgHaZbu70xhEj9M2GmmC08fLzBIjBBfY247W2Y7fWiO59znEBJ96oX5NGZtDI+cd/s4HG9heqL8FiroN48RYXHu9pWP1MOy9YBAl3r9tfjSq2M+x7iqKINq35UzLfgLLjGyxAfk1OsP02FsRos4MvZum4AFfVrpkMcoJ89H/hKht1u09MykSK2fJa+gQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 10:34:28PM +0100, David Hildenbrand (Arm) wrote:
> We try to keep these entries sorted; let's sort the MM related ones.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Oh damn, checkpatch warns for this so I'm surprised these exist, maybe legacy
stuff?

Anyway:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  MAINTAINERS | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 02b5b542f81ee..bc82ef545e0aa 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6843,9 +6843,9 @@ L:	linux-mm@kvack.org
>  S:	Maintained
>  F:	include/linux/memcontrol.h
>  F:	include/linux/page_counter.h
> -F:	mm/memcontrol.c
>  F:	mm/memcontrol-v1.c
>  F:	mm/memcontrol-v1.h
> +F:	mm/memcontrol.c
>  F:	mm/page_counter.c
>  F:	samples/cgroup/*
>  F:	tools/testing/selftests/cgroup/memcg_protection.m
> @@ -17429,8 +17429,8 @@ F:	Documentation/core-api/memory-hotplug.rst
>  F:	drivers/base/memory.c
>  F:	include/linux/memory_hotplug.h
>  F:	include/linux/memremap.h
> -F:	mm/memremap.c
>  F:	mm/memory_hotplug.c
> +F:	mm/memremap.c
>  F:	tools/testing/selftests/memory-hotplug/
>
>  MEMORY MANAGEMENT
> @@ -17480,6 +17480,7 @@ S:	Maintained
>  W:	http://www.linux-mm.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>  F:	Documentation/admin-guide/sysctl/vm.rst
> +F:	fs/proc/meminfo.c
>  F:	include/linux/folio_batch.h
>  F:	include/linux/gfp.h
>  F:	include/linux/gfp_types.h
> @@ -17488,16 +17489,15 @@ F:	include/linux/leafops.h
>  F:	include/linux/memory.h
>  F:	include/linux/mm.h
>  F:	include/linux/mm_*.h
> -F:	include/linux/mmzone.h
>  F:	include/linux/mmdebug.h
>  F:	include/linux/mmu_notifier.h
> +F:	include/linux/mmzone.h
>  F:	include/linux/pagewalk.h
>  F:	include/linux/pgalloc.h
>  F:	include/linux/pgtable.h
>  F:	include/linux/ptdump.h
>  F:	include/linux/vmpressure.h
>  F:	include/linux/vmstat.h
> -F:	fs/proc/meminfo.c
>  F:	kernel/fork.c
>  F:	mm/Kconfig
>  F:	mm/debug.c
> @@ -17636,14 +17636,12 @@ F:	Documentation/admin-guide/mm/
>  F:	Documentation/core-api/memory-allocation.rst
>  F:	Documentation/core-api/mm-api.rst
>  F:	Documentation/mm/
> -X:	Documentation/admin-guide/mm/damon/
> -X:	Documentation/mm/damon/
> -F:	mm/char-mem.c
>  F:	include/linux/cma.h
>  F:	include/linux/dmapool.h
>  F:	include/linux/ioremap.h
>  F:	include/linux/page_idle.h
>  F:	mm/backing-dev.c
> +F:	mm/char-mem.c
>  F:	mm/cma.c
>  F:	mm/cma_debug.c
>  F:	mm/cma_sysfs.c
> @@ -17658,6 +17656,8 @@ F:	mm/pgalloc-track.h
>  F:	mm/process_vm_access.c
>  F:	tools/lib/mm/
>  F:	tools/testing/selftests/mm/
> +X:	Documentation/admin-guide/mm/damon/
> +X:	Documentation/mm/damon/
>
>  MEMORY MANAGEMENT - NUMA MEMBLOCKS AND NUMA EMULATION
>  M:	Andrew Morton <akpm@linux-foundation.org>
> @@ -17810,8 +17810,8 @@ F:	include/linux/swapfile.h
>  F:	include/linux/swapops.h
>  F:	mm/page_io.c
>  F:	mm/swap.h
> -F:	mm/swap_table.h
>  F:	mm/swap_state.c
> +F:	mm/swap_table.h
>  F:	mm/swapfile.c
>
>  MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
> @@ -17883,10 +17883,10 @@ L:	linux-mm@kvack.org
>  S:	Maintained
>  W:	http://www.linux-mm.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> -F:	mm/char-mem.c
> -F:	include/trace/events/mmap.h
>  F:	fs/proc/task_mmu.c
>  F:	fs/proc/task_nommu.c
> +F:	include/trace/events/mmap.h
> +F:	mm/char-mem.c
>  F:	mm/mincore.c
>  F:	mm/mlock.c
>  F:	mm/mmap.c
> @@ -29842,9 +29842,9 @@ S:	Maintained
>  W:	http://www.linux-mm.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>  F:	include/linux/vmalloc.h
> +F:	lib/test_vmalloc.c
>  F:	mm/vmalloc.c
>  F:	mm/vmalloc.h
> -F:	lib/test_vmalloc.c
>
>  VME SUBSYSTEM
>  L:	linux-kernel@vger.kernel.org
>
> --
> 2.43.0
>

--
Cheers, Lorenzo


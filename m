Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF9DD606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 10:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=APx9dNUb
Received: by kanga.kvack.org (Postfix)
	id 0C97A6B05B1; Sat, 31 Oct 2026 06:51:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0534D6B05B2; Sat, 31 Oct 2026 06:51:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5DE76B05B3; Sat, 31 Oct 2026 06:51:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6EB3B6B05B1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 06:51:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EDD03808C4
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:51:24 +0000 (UTC)
X-FDA: 85382604888.26.56FE676
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 50A4DC0002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:51:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=APx9dNUb;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793443883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJfWazGdUI7keV3g8AbsyvSUWQ0SKJj/fzlMxSdGma8=;
	b=4S0B5Zwsu+p0cHssPVqFr6E1aLnduzOimSAOH3jJCyaAfwRtWM62DouJqoJimyz1C2QYn9
	JvfmGOBRGhcjxzQGIi50UipC3dhIFY9kdN01+DaVqx3J493HmiWi7Aw48mwuWEWQr4UAxb
	5IjY3Gbu+WvVZ/l6S8DkJJDx7tfIxzk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=APx9dNUb;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793443883;
	b=z4yGTH4xiwQMScjWOiJsggwqOC69mWnE2aieL5rx5e7MHT9EypcM6jUg+J4NJFXA6RSeb/
	9nrqblYKJtA7WrWO9I5El/VvSRecHkQXDzJdDdiGqUimSBSKyY4xk9y2XVuPNlNBUILDG5
	yKwfc2Zxyfqe9yfKz6ocM3sO4xsIiaY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3BC76600AA;
	Sat, 31 Oct 2026 10:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E37F1F00919;
	Sat, 31 Oct 2026 10:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793443881;
	bh=GJfWazGdUI7keV3g8AbsyvSUWQ0SKJj/fzlMxSdGma8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=APx9dNUbT7yZLB/p2GSjvVjuw7LZThTTfcI0IfJOtAItDN44ti8ZXwWN/0c7by3tN
	 p4+LL9UVyELty38TxXOBsRGVLacUu9NNoJ9oB7guKvq1atTb755L6myuZ5PKejS9mj
	 Rz3/jd+XHdmj6hi3rxbOoY+5jOuMqpM+BjAvYjVGqcYCz7hhsPXtO3Jsfgm1LeGFcx
	 2+B5RkkIi9ziKbLkktFBECWAQap7Fe50mAdoFoz65Www1BSZGF/Hp2MNwV1bWbsYbo
	 i9vIOK2RPNuMHhN9Prsw+WbKpA1fT1yy0xXFzs5M9kszTgEl2oWrkw9ag0D2NOkawU
	 eTw4ornuUwqyw==
Date: Sat, 31 Oct 2026 10:51:06 +0000
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
Subject: Re: [PATCH 7/7] MAINTAINERS: route more MM changes through
 mm/core.git
Message-ID: <auWz3J5Jrv3_grER@gremlin>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
 <20261030-maintainers-v1-7-97278f8a5f54@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030-maintainers-v1-7-97278f8a5f54@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 50A4DC0002
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: rk479hyq31wh4drnssj13on78abdkw8j
X-HE-Tag: 1793443883-163924
X-HE-Meta: U2FsdGVkX19YnUDTFrJeuaP/mb5odSOuMs9lPz+sbYo7P7ivz1Y1WlHVvNdD+Fus6dSLSHDGRXO1YuVZo87Dn0PBJk1urkeIBxQtP4o7QR2D9EL7p+aXoD8Rqr3+3ATeEob35i/ERNPw4grXiQjPOcEMqrj0Av/Q5e0kBWuM6kbGmnOnBZxBotUtZqRH5TGurz9JB0ZoAL15vB0fNO9GP3JgkWQGMkMKLaDe3qnI1Th79oEdF3gGUa7HX+PKVhJwb3ih2eUBL+AL2CHGiTHP7gO3bMb8AsSFtB2SewP0BRLmTjR5ltlr0ANc3pZnsP2k+CYKwwYwTNKUNK1jT550pcB4UxsTzLEqpn5aMRghiPDV9PLq+f1/+HEb+qs4u4OXbiP7bSHxSakDaH5wFKp2nd/YIapYOb5HkmVjKLgNRdvm2OofKqk8Bb5mb4091PTkmaOIGWgb7oPHvSm/ZF3BAZ95mQpb5rqYHs1Q2WtjlcYbibqxCztd+GllISiv0noycLxCsQ0R7DZn5Eib9qp1wHeAmCzzy7+iGy1UvFp8heV4wq33n2R2jMV5O9ocfuzcrq05/Nnth+FaOAmPgb6Nl10oxYmR/1wuBfk3EveJJq8v0W9OnYyiG85Blxfi4TMZMQK5R6b4XH4Btqb8oEnkEmzZQyxHXaml59DQsL+WfKs7JYg++tCdnrqsEq+2dy0RgVZtScPCSP4KBV0HDWBgGxJWy+EiX3jx8ahKFZ8CsK8/Cuae73+u/yuovDwICR9z8E+BQ573GocM5mFrKb3VX7pQhzAmq4n/yiLh8k1wCpDpObENVS5RfD/tLMTGrM4xoTCi22cWBAatgb8Va/w6o0MEXFTZsgSQ/uuNuc9ydaA+6I+26ivS5/Qkl9VQpe+OjJlP9ljQma8dimFKuLaJac0G6jk7kFGYxKd4ZaUtRUYk4R36DqKRZPlqX3MYzf4HIMLg9uE0hR+j2Y3Vtth
 tHNj1zzO
 cArjBqTVbw0uzCcj2n8VfZwYMB1VE4L4RjSnlZLpU6NuM9tAnKlrEEwZlItqRYkxqHAA77Ik4ujSSqfiTMle8P3JXguD/oE+fbYBQSq30HG2UtjGsyJwq3kC+KB5MQ1WsKOZatti09cbcTnPk9FUa1GhQaONcENvkSrRxr9yBC0yeHYyPBB2DBlIkmGPiyuxputiUXw4WNKoVRNk9L+ABrLUkZmWbSd0eb6BAMJ8TvkANwfaZ7qW+scfmFhi7e1MqhwzAT7RfgkUfYeaixBOMSF3/zsnZpL9Bm6pYIU1nmhpxFuowTVhHYHQwTDwamebb17gql4BMqpeStaCHp3CuLYLq5Na01zPq1yVl2zppjtEAbIdv/RAp7dqStJW+l/d8iHe3I7TzMku7x1GcZkN/Mo4kxUhCRbNGN12fLNCsbk0dSLpqXpBpXrvpXWV3pugnmLVcSFhodCR46VOD6+zbd/hj1+FwBZWFQQwL7YKbjLo1fMuaftabdQJleMbDT1j4FKHG5i3Mec+0SE8MUIRJZ9nig8Lcs9N60UC+0xBQM4yImRdjJ5Ei9M532RVj4nrK7n3n80jUMCL6kMG30hmnHLP2VeRN6rdjAE+qPxZ80ZcUuTrgUvDEgyji+HgFuxzxQ9YWTb+022uleM3V5fxB7YuHp7W9t1e+rnqeiDyZsy4LOJgzoYC2E6iawW+e8FmO+f6a8SkTE5eU0QUA7p5xFj/lGCXEH3ERQJND2WPKJF+nUOUMOAny57WPvpfmAwKbRbEL8BrOv5nBzPFSKR6mBd+CLWO3u7/x8iUS33piV+mdtBts9aB9p8OLfniB+Ghh2C+cM+stpqrmHj+DSE4uHd8jwfxQ8SfJknvpQFaVhuMiBsp6aYIYDC5tr/FSuGTWAQP162EBYNFBiGm5Mmv9N5kMjZL348Rh5vgL8QRJEAJKA4hZ9PbD1vBTeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 10:34:31PM +0100, David Hildenbrand (Arm) wrote:
> Let's start routing more components I (co)maintain through mm/core.git.
> Update the git trees by pointing them at the for-next branch:
>
>  - MEMORY MANAGEMENT - BALLOON
>  - MEMORY MANAGEMENT - CORE
>  - MEMORY MANAGEMENT - GUP (GET USER PAGES)
>  - MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
>  - MEMORY MANAGEMENT - MEMORY HOT(UN)PLUG
>  - MEMORY MANAGEMENT - MIGRATION
>  - MEMORY MANAGEMENT - NUMA PLACEMENT
>  - MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
>  - MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
>
> Leave out MISC for now.

Aww :(

We do need to move as much as we can out of there over time, is really the
catch-all obviously.

>
> This change doesn't imply that all changes to these components will
> immediately be routed through that tree; in particular changes that cover
> other components, or severe conflicts will require coordination with
> Andrew's tree.
>
> So this marks merely the start of "mm/core.git will start picking
> relevant material for these components".
>
> Remove Andrew from these components to set the expectation that he won't be
> the primary person picking stuff for these components; he is listed as
> maintainer under the generic "MEMORY MANAGEMENT" and will get CCed on most
> changes, and can keep an eye on stuff that falls through the cracks
> (thanks!).
>
> While at it, drop the link to http://www.linux-mm.org: it's not
> particularly useful in 2026.

:))

>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  MAINTAINERS | 31 +++++++++----------------------
>  1 file changed, 9 insertions(+), 22 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0adc674304987..b68bc36267091 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17446,18 +17446,15 @@ F:	mm/alloc_tag.c
>  F:	tools/testing/selftests/alloc_tag/
>
>  MEMORY MANAGEMENT - BALLOON
> -M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	David Hildenbrand <david@kernel.org>
>  L:	linux-mm@kvack.org
>  L:	virtualization@lists.linux.dev
>  S:	Maintained
> -W:	http://www.linux-mm.org
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
>  F:	include/linux/balloon.h
>  F:	mm/balloon.c
>
>  MEMORY MANAGEMENT - CORE
> -M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	David Hildenbrand <david@kernel.org>
>  R:	Lorenzo Stoakes <ljs@kernel.org>
>  R:	Liam R. Howlett <liam@infradead.org>
> @@ -17467,8 +17464,7 @@ R:	Suren Baghdasaryan <surenb@google.com>
>  R:	Michal Hocko <mhocko@suse.com>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> -W:	http://www.linux-mm.org
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
>  F:	Documentation/admin-guide/sysctl/vm.rst
>  F:	Documentation/core-api/gfp_mask-from-fs-io.rst
>  F:	fs/proc/meminfo.c
> @@ -17526,15 +17522,13 @@ F:	include/linux/execmem.h
>  F:	mm/execmem.c
>
>  MEMORY MANAGEMENT - GUP (GET USER PAGES)
> -M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	David Hildenbrand <david@kernel.org>
>  R:	Jason Gunthorpe <jgg@nvidia.com>
>  R:	John Hubbard <jhubbard@nvidia.com>
>  R:	Peter Xu <peterx@redhat.com>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> -W:	http://www.linux-mm.org
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
>  F:	Documentation/core-api/pin_user_pages.rst
>  F:	mm/gup.c
>  F:	mm/gup_test.c
> @@ -17544,14 +17538,12 @@ F:	tools/testing/selftests/mm/gup.c
>  F:	tools/testing/selftests/mm/gup_longterm.c
>
>  MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
> -M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	David Hildenbrand <david@kernel.org>
>  R:	Xu Xin <xu.xin@linux.dev>
>  R:	Chengming Zhou <chengming.zhou@linux.dev>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> -W:	http://www.linux-mm.org
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
>  F:	Documentation/ABI/testing/sysfs-kernel-mm-ksm
>  F:	Documentation/admin-guide/mm/ksm.rst
>  F:	Documentation/mm/ksm.rst
> @@ -17566,6 +17558,7 @@ M:	Oscar Salvador <osalvador@suse.de>
>  L:	linux-mm@kvack.org
>  L:	linux-cxl@vger.kernel.org
>  S:	Maintained
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
>  F:	Documentation/ABI/testing/sysfs-devices-memory
>  F:	Documentation/admin-guide/mm/memory-hotplug.rst
>  F:	Documentation/core-api/memory-hotplug.rst
> @@ -17614,7 +17607,6 @@ F:	mm/vmscan.c
>  F:	mm/workingset.c
>
>  MEMORY MANAGEMENT - MIGRATION
> -M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	David Hildenbrand <david@kernel.org>
>  R:	Zi Yan <ziy@nvidia.com>
>  R:	Matthew Brost <matthew.brost@intel.com>
> @@ -17625,8 +17617,7 @@ R:	Ying Huang <ying.huang@linux.alibaba.com>
>  R:	Alistair Popple <apopple@nvidia.com>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> -W:	http://www.linux-mm.org
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
>  F:	include/linux/migrate.h
>  F:	include/linux/migrate_mode.h
>  F:	include/trace/events/migrate.h
> @@ -17698,7 +17689,6 @@ F:	mm/numa_emulation.c
>  F:	mm/numa_memblks.c
>
>  MEMORY MANAGEMENT - NUMA PLACEMENT
> -M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	David Hildenbrand <david@kernel.org>
>  M:	Gregory Price <gourry@gourry.net>
>  R:	Zi Yan <ziy@nvidia.com>
> @@ -17707,8 +17697,7 @@ R:	Rakie Kim <rakie.kim@sk.com>
>  R:	Ying Huang <ying.huang@linux.alibaba.com>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> -W:	http://www.linux-mm.org
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
>  F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
>  F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy
>  F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
> @@ -17782,7 +17771,6 @@ F:	mm/vmscan.c
>  F:	mm/workingset.c
>
>  MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
> -M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	David Hildenbrand <david@kernel.org>
>  M:	Lorenzo Stoakes <ljs@kernel.org>
>  R:	Rik van Riel <riel@surriel.com>
> @@ -17793,6 +17781,7 @@ R:	Jann Horn <jannh@google.com>
>  R:	Lance Yang <lance.yang@linux.dev>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
>  F:	include/linux/rmap.h
>  F:	mm/interval_tree.c
>  F:	mm/page_vma_mapped.c
> @@ -17850,7 +17839,6 @@ F:	mm/swap_table.h
>  F:	mm/swapfile.c
>
>  MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
> -M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	David Hildenbrand <david@kernel.org>
>  M:	Zi Yan <ziy@nvidia.com>
>  R:	Baolin Wang <baolin.wang@linux.alibaba.com>
> @@ -17864,8 +17852,7 @@ R:	Usama Arif <usama.arif@linux.dev>
>  R:	Kiryl Shutsemau <kas@kernel.org>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> -W:	http://www.linux-mm.org
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
>  F:	Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage
>  F:	Documentation/admin-guide/mm/transhuge.rst
>  F:	include/linux/huge_mm.h
>
> --
> 2.43.0
>

--
Cheers, Lorenzo


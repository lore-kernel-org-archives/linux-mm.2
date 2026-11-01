Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D78CE606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 17:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NW0/ZItu
Received: by kanga.kvack.org (Postfix)
	id 023CD6B00EF; Sun,  1 Nov 2026 12:14:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F17176B05B1; Sun,  1 Nov 2026 12:14:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E06696B05B2; Sun,  1 Nov 2026 12:14:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD83C6B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:14:18 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4557A0847
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:14:17 +0000 (UTC)
X-FDA: 85387198554.16.CFE0963
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 290B4120002
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:14:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NW0/ZItu";
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793553256;
	b=6RSIlJ7xu0CUL4/yJq5Pe4BnuHg1e72Wqi5JvUK77MsRxPQar+VYWCHtW1bG6pADoq5mhE
	1sgRj1Ie9ZcijA4hAoryC3owzsWvp9WvR4WxPzmsrTm0ZX/GUCabhEsm508t/qdU3UHOPm
	sqBbCgD7euRy7jz6lzVUNHQ9GpZT51A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NW0/ZItu";
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793553256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R6gUavSXN8o98nfRqPmDU4mBwMW9oSNT3lHuUTmjbYo=;
	b=csaVX7hJACciKRAWar1uR8+tHIX5wu5be4yQJpoazLN94XveQ57z6310BXIkIDDkl/EZr6
	wxFX0RQEjSMNixPJ0ZO60e3a2YVBvigUwxEIWoobm6p8nNJvibTDSkLLNK6MuR48/boBxt
	vueKqsPp6s8+JQsI9/Um5dySughYuD4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5725D43950;
	Sun,  1 Nov 2026 17:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7622E1F000C1;
	Sun,  1 Nov 2026 17:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793553255;
	bh=R6gUavSXN8o98nfRqPmDU4mBwMW9oSNT3lHuUTmjbYo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NW0/ZItu8ulb85kahpqmxU5Cdhwkdm5fODVcRqYy5093olCiYLGwX7cw1FLgl/Wr8
	 be6fSFpfOzilrkt3Mgrvv3f30APu+WmoLRhr6w5YThqBESoP5fQrAnIRvDI+unlBU2
	 XGY/8ngxF/IMenuje6LAqPjw894hwe+xyz7HmvasyKt/fGFx5myHpXwVbtlwHGIAdV
	 bB06uoPXtIzgtCDJYVFA8LfpKvY5/jU7OOmM4yRQIQRaHCfhUvHo0WMuxWN1NR58rh
	 81Kl3CuXfHLi8oQYLM0CMiFJlqua3DYgG4QBD9lfGheBq5gAgkTK7Ku1qzRr72QTQK
	 Ed8/XYIg/OB4w==
Date: Sun, 1 Nov 2026 17:14:12 +0000
From: Harry Yoo <harry@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Byungchul Park <byungchul@sk.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Dave Chinner <david@fromorbit.com>, David Rientjes <rientjes@google.com>, 
	Dennis Zhou <dennis@kernel.org>, Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
	Hao Li <hao.li@linux.dev>, Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
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
Subject: Re: [PATCH 2/7] MAINTAINERS: TMPFS (SHMEM FILESYSTEM) updates
Message-ID: <audzTEdSflX9iZMg@minisforum>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
 <20261030-maintainers-v1-2-97278f8a5f54@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030-maintainers-v1-2-97278f8a5f54@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 290B4120002
X-Stat-Signature: z9beozqfwh3od3ps9jf1f7gdzwgrutge
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793553256-680815
X-HE-Meta: U2FsdGVkX1/Cr1pd9ULOgh4XTYSnySecTuNp+VkQoZJY+avOstkaTu0zxHbGAtcFUm/uGcY+pb/ahKsj+hy6Ah9/hTiESh8SolR4nI6NT2FUI/BNczGONpNtf6pZJDi5MFCXX/c5LWoDBKY6jh0lu10SnepcJR8ajk6Cd0hGeYIq8508ETQydiY5xEFDJT8GaeJhc2VDQ4Jq3knaMQBizZ8LGPoKM38JRRxOt61xtYeXzP/z9h+m/WF9HCNmNQ7GKtON+IXqYvStE7CSHp/0CeaYku+5AFcAMvYCzSyBhHseVgXevg/EEvhp9LzPAXFVm8iqMVQQOi8y3v54mude23Hf+Ol0udqTLi97lyM17LHFC/aGgSnEA7qQuA9IPjvpjEi+VSAa3IPhJMn8HzYmLqs4D+Mm0MtIyp8OuKHzHrMcUOkKtZZhW+pAimGxXRtxtmYifM36NG/p5crw9VEbAqt103EnCnssOmY7NL/DGvusYq/9/ItX4RukGL/FIEvMsPBOqQ1OS+DlmLYS2OVlymgs0FhEPtJhTH2zoyphCQaC4yyRzhVWoQOBPmZZTYwTPPBiNaX1jWZXm32X4dbZcQ5Um5+WT6k4FJ8LKGOITu3NkDTER4MulPdUy541OSoqrKAPEB6N5P3aCXd3Pc9jEftbiDYKbgTrVJCHG/W5IaZCy7LFYstBKk7jaJGb27bjlyZjitNDay1tNcjoJ/LxGVRKDvNmbKwmgOnP2/3WdlWzbABWzX9x/iSHA8dEF+d/MJOcGw9QkqGc0etk1dBKf8xmBKVWEsLaPlE4bq1nA9GqC+wguC5bb+TvY2es6x0TQHJU5niAgvCRYk324SCc0ozIkQEhN786G0FPBc4hwDB5cYdzFKqQJv9F5eYWx3Bi70V81aZK0IOcWg6DJSB/WNo0AnmjogbZbbspLpFGEgtLDCFznrHPN1xPkGHpYI2irt45tojlX+9V1VlkftZ
 bWbYrObY
 fub4kNy515q708bCMG3+YJrOW6Z/rr4E/tjWjNEpqFF7FzqMQzrLB+HbmVUhc5KFqWU2m+3Iksz1JbQfbt6Us3q6LThgU3qsweAdignIqvX4T+aHP1L2VXgJMV9InSeBcT1Tf/fhHg5pFU4aL5q1edIJ3qzbJzkVq7DqRXD8Mi4xVlxKcX9MnwYV5Wau0rf4uCSGXl7gaZ6fDvLqj0gAbEuJFOKvXcAcXq7OJ4O6/4Ee+fPN8u9InzWxkvewDDAfa9GiRMfjGK6nt3MSfCxkPfooeVDW/Rni6cPEWttIXgC5p0bz9PP60UcQHsoX7SzOWZ1rduxFL40AV/HXY8nCw1hk7S2fnX9ukYBeY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 10:34:26PM +0100, David Hildenbrand (Arm) wrote:
> I am not really the best shmem/tmpfs/memfd expert around, but it should
> be good enough to judge when something is ready to be picked up, to then
> pick it up. I'll have to heavily rely on Hugh and Baolin on judgment
> for the more involved and more controversial bits.
> 
> Rename "TMPFS (SHMEM FILESYSTEM)" to "MEMORY MANAGEMENT - SHARED MEMORY
> (SHMEM/TMPFS/MEMFD)" and move it accordingly. Add myself as a MAINTAINER
> so people know whom to CC.
> 
> Add mm/core.git as the target git tree. Once shmem becomes a high volume
> component we can dedicate it a separate tree and have dedicated people
> pick it up.
> 
> While at it, add some more shmem/tmpfs/memfd related files+directories
> we missed so far.
> 
> There is also "kernel/pid_sysctl.h", which includes some of the pid
> namespaced sysctl vm.memfd_noexec. But that's really more of a proc/
> namespace thingy, so it's not a good fit here.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Acked-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon


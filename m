Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43B68606A332
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 06:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZMQT24qP
Received: by kanga.kvack.org (Postfix)
	id 639D46B05B3; Mon,  2 Nov 2026 01:48:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C3AB6B05B4; Mon,  2 Nov 2026 01:48:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 465596B05B5; Mon,  2 Nov 2026 01:48:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F53A6B05B3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 01:48:05 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7387180A8D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:48:03 +0000 (UTC)
X-FDA: 85389249246.18.FAC3CEB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id A4852160005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:48:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZMQT24qP;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793602081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tARIC+dAqyWZfQ7V1iPzSWAawgTGQCpeaoo4vLHJExw=;
	b=dXBC2d6qV5n9pWhJP3Yqmv1ajcvSiw/Z9vseMsa93KoxbHqR+Dn4eRJ6/kkhSGAGv0yHQO
	AdBQnLmcDMci6sGvAjdM+f4YsnwK2lraZD+Z4uRV1oTyGs/LtVjFPYoLObMxemRempGhpe
	DnEqJ7WazFjsPly3M2hnR8bptkjx/jI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793602081;
	b=5cbNGRVr0HryPuK3nK2VG1K5joeUVdYX0inyLoPZ5CcJiS41DXE0Ac3K2jUwexwL2kL3zS
	VBSas8bOjRecLxkyuYe/21hGYHklP5/xKx2wk9xRatJ55Pik/joR5H7nbzvgYXPh2RCrKT
	EEWhfY1r92dXbR/GYi+N5BuOuf6/lRo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZMQT24qP;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B6BA240545;
	Mon,  2 Nov 2026 06:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC031F000C1;
	Mon,  2 Nov 2026 06:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793602080;
	bh=tARIC+dAqyWZfQ7V1iPzSWAawgTGQCpeaoo4vLHJExw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZMQT24qP57yVV1Fsp6lQWEI+yKTzT7CiP70FBa2wkk3XJBkLivBqhfbLQVU1b792l
	 egkKr+nwcg0yL5I90QDj9SWoJXrPZDfgaU9Ahpw+yeSoGKxW8p+Q645OpGOm+Ou9Rs
	 FfBagOWRyEId8evM2qdx3ErknKAqs74guNA34QRawkHi7rkGXGxU8yXKPYcTHnYYA9
	 wdVQzt7YGtEyqqQmDX1wcHnx6jRr5hRGFqckBAf31Okx6m7VLHkDv/l/TjYBYehsRl
	 65I1ahuEWCW8aBoEA2Bn/7l3v0kWD4b4gH9chLTWw5Hs0b8RvE7YrJAOU/rI1coRTD
	 7Jhsoe/O4ITUg==
Message-ID: <1b4d0299-4232-43eb-9229-7d2a2a7ce2fc@kernel.org>
Date: Mon, 2 Nov 2026 07:47:46 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] MAINTAINERS: MM updates
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alistair Popple <apopple@nvidia.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Byungchul Park <byungchul@sk.com>, Chengming Zhou
 <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Dave Chinner <david@fromorbit.com>,
 David Rientjes <rientjes@google.com>, Dennis Zhou <dennis@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>,
 Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>,
 Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Kiryl Shutsemau <kas@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>,
 Nick Piggin <npiggin@gmail.com>, Nico Pache <nico.pache@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Pedro Falcato <pfalcato@suse.de>,
 Peter Xu <peterx@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>,
 Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
 Xu Xin <xu.xin@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>,
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
 <1c46e678-1da8-473d-960e-5aa22d4d7e73@kernel.org>
 <20261101123025.4d8133d5321820f2202c8f1a@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261101123025.4d8133d5321820f2202c8f1a@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A4852160005
X-Stat-Signature: poxsimux3n6qcfk1kbny8wz3byayqdrm
X-Rspam-User: 
X-Spam-Status: No, score=-22.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793602081-625104
X-HE-Meta: U2FsdGVkX1+lQTNvDtUsrDGOzMAaylVNfKjA/6T2Jn6sLH//k10hQfT4jqIhLgfA0ZIPW6+OPafFMcWQTyIH1FYLTCjqBCxxNb2my/Vw3uou3rnBlk3/exWO631/H61ilk/4WnEBkQc5tG4B5PsXCcSfEux7BJFKsPT+t+2y4RPpvlpoocnB3ptnR2Jp8sfhoNboDsqprWNC3o9n/UK+xcEppJ5+Q3GmA8Elqke9BAFk3PIw67ps4E1vy8PGpOgkHu0WTeAB7etumAqtItFFeTB7Og7py4IJg8ux6ZDUCz55npRa/pyk3hG93LeUXCP41Abp5i3OeF5Fb746SVbdqFKWRkiyoP6dayK688gKWCi6bRD+a1/CN9bAKleeYgA3GVMUoQYgk9+VzE45scP39UA3YxgLRiBCpKfAFBtl+fWmkU51Jn801QCzpAPrHdVhpOOaCb1GGiawmjAeW223w+syi4ya/LM6XvlJpQCIcBVuhRMPYkzV7C1U4pO9QVoT7BoaKC+dutSIGG1tzSTP0j9CUymx1f6MAOGAP5ZPRB8GQIGmOc4xNh90vVz1RHiSl45tMXFdQ+j0A1WbnpiYmTlhIqTpngyT0omOd/Q+F0MsjDEC5vZfgc1/j0+EhHd4YxCp3Jr+Fc4Zh+JQinp83vM3qVuImyoqz/bsaWIsfXCbzHB07aGj5zgsHwwnjP+jhbwhWHgDvNPlLwpUx/IYZaM1wEo/JYFXK57fjyQAazs7RugHS4HNBHvhrtp+u6iEJsSoPPQUtwi5xxsv9+VdL0gHHLCduozw+LUs871Kehxu7Kg9Ak92WcedAZyXO5h5zmxio5rGa0LGzyOPz7O/O8ox0fKZJGDO69VD6xf3xLeBVm5iIsiNxEJ+vJw9GCJpTpWI1I1RuY5l/fmtUHZFHfS7SBDf5ITTiRB6AwmggbkZm9V57GT8bc60qVEAMgrNNd1FEoLmloU0Z0REWFu
 xqi+RhLl
 MvFZ8mwLSmAowjslhNtjNxu/MiFYy4lVYMxumiwWtpOLtL0TD+Pb5PgmqD6WaGTEQfXXjFehMzF+Lca8dF9po6E6wnX/hEvOZymkhB0OPwsN52Mb1OkUCIjM4YN3Yvd4X979GLCwZLrAdVF5Vpt8S3yQsDq/MnZUPuW7PkFVYeAhZ4eTO4JXa/VbvpuxfORplUH19nx6JmUaFd6XzfSowZ3HFtJLNzqLj0epczEgZzgrZNZt11K/4vVPsBStYCXlETG2t01rxBkxenmKzDBj31rVdXzvGTMzZk3IXCa17AUHaKY1Rm/uy2u1uIYlbquThwCq4gw2lj1hBER1MjlM47WbT83uiYlRYd5fOBAK0xBVnw66MshxiOpOuIJz9gcwBwg/wwn/XcocWykSx04D/lRO94OMJiYyHtt0qYo6a5/my2fFzqqbk6+usSSXmzQx90l23RQjCH9OzZqcSH56ztd8pWB9psyf4QpOwSY4juXytgH8cotJ3fk3W1z2B/vUM9wZ9Pixp6nxKd73K4Pt4yvSTsiBJAoCTAI+blUbhqS/0L5s93TDujven8qJ75WEKpcqARRJf6XS/O0yXv5fMTRRR+3UlKYgvO2Qm0vpFtMKesn2QsOy3c6rGLeBe9E08pDJqFZxdXYB9mHkA9QzWgoGYbPa1ZZ2HZvNXX2llVZsDsFrVQ+Si6zaC6LO5F4mMBl9TxNMExhf4gzf1pnXLD0/yf9iboyB2oF0YxQEooAJgzTlaq1sZ28znhrtaZI4JqGbt6XGrE9MBVyCOAYoBmggiebbXMMjse1CcP6b2gJAwjA2dKK1A27UYbSAOujvBkUeHfHM/RUag89A4cWDGPCP72ohpJ0IqQgc/rqtlobf7TwptWV2ubDdCHBhJyjCHvuBM/g3vRxOvBDYm5pS9r5hCM2CoCfvJhXZV3h8hPhSBOuU9L3fNcG8+P5eIMOuCWz/+f1qajbfCYA80NRt9MCSH/3K6
 /p+pnzHy
 vvIV1+mHqCk6Ghd8lzAou5mpKMoL5fQ1XzkV4zP+P918BgFjMjKH6FyT1fFL0weXp5wrJKisVHbYVSrOWx8fGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/1/26 21:30, Andrew Morton wrote:
> On Sun, 1 Nov 2026 14:33:57 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> On 10/30/26 22:34, David Hildenbrand (Arm) wrote:
>>> Hi,
>>>
>>> several MM updates:
>>>
>>
>> @Andrew, should I pick these or do you want to route them through your tree?
> 
> I'll grab for now, thanks.  As a hotfix.
> 
> Because I'm whacking away at MAINTAINERS at present.  First step is to
> consistently name the components, below.
> 
> This is a two-patch series.  The first renames components so everything
> starts with "^MEMORY MANAGEMENT", leaving MAIINTAINERS incorrectly
> sorted.  The second patch only moves things around, to restore the
> alphasorting.
> 
> So people only need look at the first patch.  Please review that.
> 
> After this I'll have it identify the various files under include/linux,
> mm/ and lib/ which can fairly be described as "mm".  That's looking
> like about 50 files at this time.

[...]

> 
> Then I shall have it ensure that all these not-yet-covered files are
> entered in the appropriate place under an MM component.  This may
> require creation of new components for the purpose, tbd.
> 
> After that I needs to have it cover Documentation/
> 
> After that I need to have it whack away at selftests, shudder.

I am not convinced yet that we want that for all tests, which is why I left it
out. There is too much churn that's not really relevant for a component
maintainer POV.

I was rather thinking that maybe we'd want a MM selftest component (likely for
the later MISC maintainer) that picks up the usual selftest churn. Component
maintainers really only have to be CCed on functional things.

> 
> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: MAINTAINERS: use a common prefix for MM components
> Date: Sun, 01 Nov 2026 12:13:07 -0800
> 
> Several MM component entries still use standalone headings, so searching
> for headings beginning with "MEMORY MANAGEMENT" misses them.
> 
> Give these 18 entries the common "MEMORY MANAGEMENT - " prefix.  Leave
> them in place for now so that the renames can be reviewed separately
> from the subsequent alphabetical sorting.
> 
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> 
> ---
> 
>  MAINTAINERS |   36 ++++++++++++++++++------------------
>  1 file changed, 18 insertions(+), 18 deletions(-)
> 
> --- a/MAINTAINERS~maintainers-use-a-common-prefix-for-mm-components
> +++ a/MAINTAINERS
> @@ -6816,7 +6816,7 @@ T:	git https://gitlab.freedesktop.org/dr
>  F:	include/linux/cgroup_dmem.h
>  F:	kernel/cgroup/dmem.c
>  
> -CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)
> +MEMORY MANAGEMENT - MEMORY RESOURCE CONTROLLER (MEMCG)
>  M:	Johannes Weiner <hannes@cmpxchg.org>
>  M:	Michal Hocko <mhocko@kernel.org>
>  M:	Roman Gushchin <roman.gushchin@linux.dev>
> @@ -7322,7 +7322,7 @@ S:	Maintained
>  W:	https://docs.dasharo.com/
>  F:	drivers/platform/x86/dasharo-acpi.c
>  
> -DAMON
> +MEMORY MANAGEMENT - DAMON
>  M:	SJ Park <sj@kernel.org>
>  L:	damon@lists.linux.dev
>  L:	linux-mm@kvack.org
> @@ -12164,7 +12164,7 @@ S:	Maintained
>  F:	Documentation/ABI/testing/debugfs-hisi-zip
>  F:	drivers/crypto/hisilicon/zip/
>  
> -HMM - Heterogeneous Memory Management
> +MEMORY MANAGEMENT - HMM (Heterogeneous Memory Management)
>  M:	Jason Gunthorpe <jgg@nvidia.com>
>  M:	Leon Romanovsky <leonro@nvidia.com>
>  L:	linux-mm@kvack.org
> @@ -12328,7 +12328,7 @@ F:	drivers/power/supply/huawei-gaokun-ba
>  F:	drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c
>  F:	include/linux/platform_data/huawei-gaokun-ec.h
>  
> -HUGETLB SUBSYSTEM
> +MEMORY MANAGEMENT - HUGETLB
>  M:	Muchun Song <muchun.song@linux.dev>
>  M:	Oscar Salvador <osalvador@suse.de>
>  R:	David Hildenbrand <david@kernel.org>
> @@ -12362,7 +12362,7 @@ W:	https://linuxtv.org
>  T:	git git://linuxtv.org/media.git
>  F:	drivers/media/platform/st/sti/hva
>  
> -HWPOISON MEMORY FAILURE HANDLING
> +MEMORY MANAGEMENT - HWPOISON MEMORY FAILURE HANDLING
>  M:	Miaohe Lin <linmiaohe@huawei.com>
>  R:	Naoya Horiguchi <nao.horiguchi@gmail.com>
>  L:	linux-mm@kvack.org
> @@ -17370,7 +17370,7 @@ F:	arch/*/include/asm/sync_core.h
>  F:	include/uapi/linux/membarrier.h
>  F:	kernel/sched/membarrier.c
>  
> -MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION
> +MEMORY MANAGEMENT - MEMBLOCK AND INITIALIZATION
>  M:	Mike Rapoport <rppt@kernel.org>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> @@ -17879,7 +17879,7 @@ F:	rust/kernel/mm.rs
>  F:	rust/kernel/mm/
>  F:	rust/kernel/page.rs
>  
> -MEMORY MAPPING
> +MEMORY MANAGEMENT - MEMORY MAPPING
>  M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	Liam R. Howlett <liam@infradead.org>
>  M:	Lorenzo Stoakes <ljs@kernel.org>
> @@ -17916,7 +17916,7 @@ F:	mm/vma_internal.h
>  F:	tools/testing/selftests/mm/merge.c
>  F:	tools/testing/vma/
>  
> -MEMORY MAPPING - LOCKING
> +MEMORY MANAGEMENT - MEMORY MAPPING - LOCKING
>  M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	Suren Baghdasaryan <surenb@google.com>
>  M:	Liam R. Howlett <liam@infradead.org>
> @@ -17932,7 +17932,7 @@ F:	include/linux/mmap_lock.h
>  F:	include/trace/events/mmap_lock.h
>  F:	mm/mmap_lock.c
>  
> -MEMORY MAPPING - MADVISE (MEMORY ADVICE)
> +MEMORY MANAGEMENT - MEMORY MAPPING - MADVISE (MEMORY ADVICE)
>  M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	Liam R. Howlett <liam@infradead.org>
>  M:	Lorenzo Stoakes <ljs@kernel.org>
> @@ -18728,7 +18728,7 @@ S:	Maintained
>  F:	drivers/phy/marvell/phy-mmp3-usb.c
>  F:	drivers/phy/marvell/phy-pxa-usb.c
>  
> -MMU GATHER AND TLB INVALIDATION
> +MEMORY MANAGEMENT - MMU GATHER AND TLB INVALIDATION
>  M:	Will Deacon <will@kernel.org>
>  M:	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
>  M:	Andrew Morton <akpm@linux-foundation.org>
> @@ -21113,7 +21113,7 @@ F:	Documentation/core-api/padata.rst
>  F:	include/linux/padata.h
>  F:	kernel/padata.c
>  
> -PAGE CACHE
> +MEMORY MANAGEMENT - PAGE CACHE
>  M:	Matthew Wilcox (Oracle) <willy@infradead.org>
>  M:	Jan Kara <jack@suse.cz>
>  L:	linux-fsdevel@vger.kernel.org
> @@ -21142,7 +21142,7 @@ F:	include/net/page_pool/
>  F:	include/trace/events/page_pool.h
>  F:	net/core/page_pool.c
>  
> -PAGE TABLE CHECK
> +MEMORY MANAGEMENT - PAGE TABLE CHECK
>  M:	Pasha Tatashin <pasha.tatashin@soleen.com>
>  M:	Andrew Morton <akpm@linux-foundation.org>
>  L:	linux-mm@kvack.org
> @@ -21829,7 +21829,7 @@ S:	Maintained
>  F:	Documentation/networking/device_drivers/ethernet/pensando/ionic.rst
>  F:	drivers/net/ethernet/pensando/
>  
> -PER-CPU MEMORY ALLOCATOR
> +MEMORY MANAGEMENT - PER-CPU MEMORY ALLOCATOR
>  M:	Dennis Zhou <dennis@kernel.org>
>  M:	Tejun Heo <tj@kernel.org>
>  M:	Christoph Lameter <cl@gentwo.org>
> @@ -25539,7 +25539,7 @@ T:	git git://linuxtv.org/media.git
>  F:	drivers/media/i2c/rj54n1cb0c.c
>  F:	include/media/i2c/rj54n1cb0c.h
>  
> -SHRINKER
> +MEMORY MANAGEMENT - SHRINKER
>  M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	Dave Chinner <david@fromorbit.com>
>  R:	Qi Zheng <qi.zheng@linux.dev>
> @@ -25775,7 +25775,7 @@ S:	Maintained
>  F:	Documentation/devicetree/bindings/nvmem/layouts/kontron,sl28-vpd.yaml
>  F:	drivers/nvmem/layouts/sl28vpd.c
>  
> -SLAB ALLOCATOR
> +MEMORY MANAGEMENT - SLAB ALLOCATOR
>  M:	Vlastimil Babka <vbabka@kernel.org>
>  M:	Harry Yoo <harry@kernel.org>
>  M:	Andrew Morton <akpm@linux-foundation.org>
> @@ -29831,7 +29831,7 @@ F:	net/vmw_vsock/
>  F:	tools/testing/selftests/vsock/
>  F:	tools/testing/vsock/
>  
> -VMALLOC
> +MEMORY MANAGEMENT - VMALLOC
>  M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	Uladzislau Rezki <urezki@gmail.com>
>  L:	linux-mm@kvack.org
> @@ -30864,7 +30864,7 @@ M:	"Maciej W. Rozycki" <macro@orcam.me.u
>  S:	Maintained
>  F:	drivers/tty/serial/zs.*
>  
> -ZSMALLOC COMPRESSED SLAB MEMORY ALLOCATOR
> +MEMORY MANAGEMENT - ZSMALLOC COMPRESSED SLAB MEMORY ALLOCATOR
>  M:	Minchan Kim <minchan@kernel.org>
>  M:	Sergey Senozhatsky <senozhatsky@chromium.org>
>  L:	linux-mm@kvack.org
> @@ -30887,7 +30887,7 @@ F:	lib/zstd/
>  N:	zstd
>  K:	zstd
>  
> -ZSWAP COMPRESSED SWAP CACHING
> +MEMORY MANAGEMENT - ZSWAP COMPRESSED SWAP CACHING
>  M:	Johannes Weiner <hannes@cmpxchg.org>
>  M:	Yosry Ahmed <yosry@kernel.org>
>  M:	Nhat Pham <nphamcs@gmail.com>
> _
> 

What's up with things like KASAN, KFENCE, KMEMLEAK, KMSAN?

I don't have a good question for that.


-- 
Cheers,

David


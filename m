Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A302606A32F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 08:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=DZDJkPcv
Received: by kanga.kvack.org (Postfix)
	id 6BA666B05B1; Mon,  2 Nov 2026 03:21:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 690C56B05B2; Mon,  2 Nov 2026 03:21:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 580B76B05B3; Mon,  2 Nov 2026 03:21:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E2C76B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:21:00 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 518EA1C46B8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:20:59 +0000 (UTC)
X-FDA: 85389483438.15.260B30C
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf05.hostedemail.com (Postfix) with ESMTP id 27AEA100008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:20:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=DZDJkPcv;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793607657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uBfJJilvsrye3sZPINSFwLYLhpZUOxlraaYo4APzklo=;
	b=KpNiS/uELJfGzBaOR58qk/RWfmzu/Rdq6mEAzDgrnx9YSYph9D486zQbt6ILCiwK73OVcg
	cMX5rORN4ORiRLcmzeip/oIHgGlnuDtCo8IT0iqdx+K5xz5ugFuRF8QdcVddt5zS1Zg09X
	e406JGqGqpSFzK3V14vv7rpplI8W1/0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=DZDJkPcv;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793607657;
	b=3IA45x2qcCnzZRkvgGGddMCIHOLhz3RPEmSsVqKZ39BbEpR1pUnPXzOGaGbLn0V0DGH+HL
	02zj0Z8XgEfPnBVjd5m6f5P7NUOukA9autA98vfXLZYgcpFiF+qvRGL9Wjcsz+Z27f3jak
	/D1IbBEcohxTVTGXuMmYJ9PHLD/uZBY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793607653; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=uBfJJilvsrye3sZPINSFwLYLhpZUOxlraaYo4APzklo=;
	b=DZDJkPcvKq4lSwEQ1N7K8DaOIbcYz6j4v6vlwvj73qumkI31dKE5ml30Gcu2Obm4+grlyo0X8AtpYperXeOOJ5QFK2cyzJ9/E4jcTVdpZN+KGgo/mDutDqrIZWH7/yFw6eKon9NtHBMmkU5XRZ3i9ymUDUzu6bxERGMW2vUf6WM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=64;SR=0;TI=SMTPD_---0XDw-lN._1793607648;
Received: from 30.74.144.167(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDw-lN._1793607648 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 02 Nov 2026 16:20:50 +0800
Message-ID: <62268831-f6f3-4666-a32f-a77546b95432@linux.alibaba.com>
Date: Mon, 2 Nov 2026 16:20:47 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 18/47] mm/khugepaged: check if PTE table is empty in
 try_collapse_pte_mapped_thp()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kees Cook <kees@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org,
 Muhammad Usama Anjum <usama.anjum@arm.com>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
 <20261031-fixes_core-v3-18-d6437171ecc3@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261031-fixes_core-v3-18-d6437171ecc3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 27AEA100008
X-Stat-Signature: phh6tw13h761hezcfork4zuxng4jo7du
X-Rspam-User: 
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793607655-516302
X-HE-Meta: U2FsdGVkX1+HkqqgNXxiY3weruRvZXGBbmoNB/D1+8kU20Wj5UGffwvoON+nHxMe3G71CdG3ttovve2z9hVKnQDGQIm+aF0GCnKbd2xCqLO7mCGiGxz2qvtEKhIiAPCWmc1L/wz9p5G48uSSozN1bhyvXVEU5bqzu02lCand2JcDMeF7qFugogBNoAbKV4GaBic4RWmLOReJywgSYnuDHBafBZcSE8QIdq7hJuzwErbQrEjoSMT97ut2PJzOLY13SuVj64fYmZ9pMoTIou9TELRwAC9CoqcrXryARD8SDMFMNKleEW5zxplH6XPRbYQ309ePWiHQ9x4mCpnNmNpVwVRywkhI0oCpxw0JSHhIb36PTZAJFfx6oWZpCzal4zLdj6KDkVVcmQFgdO4O7oEf7ZLIZx6x23cjpKoLf5dQEJKBH05yY1aDSdcUDUlRt6UVh13d8COOJ7xtxsHKde2x3mOn1qBWp3NI6Mub8+oUhHZTLAjOa7jfMel72r2eEChMdWuURxAHAmBuhHTZpst4uB969pssF/n4PuP5smmc2EeOLl5qaShaljWjJUDm+XnLI8v7g3sn6UNt+SC5W0zKy3W1yyrwCzsNPXVaP2jwOlps7zVe68YtNUGkCDw9ypRgKE9dgTdtswYTf29hBsv0J9bfmKsJM9C4VDNXr64A1KZ37Fh5bMEBCuE7isq4j5I+Irtd3HJHAXM7YZxv07rb/+rGhvMr7yAPXCYYzNhGXpxDy54l3BD3KSmbj8KePtUhzjUw/huYRLlQWJIkCxYdT0ljCswCwd9N70jyfRHQ5KAfIFoYSZgQ+TtUAjzrc+nsyAsZgNhz7eM26StAggbIfHB8W7QhpgkszSP9dWJs+KCoY4Ct667az8IC16d69BpgmRSqQ4S3mjuFNITVOiQ4VkgV6Z3sZDm5V4YXjr9KREk8gZqwIg/ZeBTcRt1atEU+JAK9ORYrjOsLuWABErF
 BB3RwUoH
 1YUQYTmrRn3nQp6sH+pXjWdKh37eWjXIi1mUNDLjzpTTveejifEsoF4aSfweQbC04hNAXjjwruIMgtqsDH8DppTH7q4QM60jx8vf7ty98ca36hgMUTGWcs72aYkOwICcss/VxT2Pzny/nEMhYNQdIxYoUbiqlTGh7HspjnmzYBSgpJbQ9apITwR0s7bvXuF8dn1nivx7LbiFcMqpL4YVMp3ettfYisRfs3JKrKamBg77Z0K+ML+GkKQkqQyDHfvpXxfB53uDVWeidmrwhY/8rlrNFiWXPUbsJZUx1o00ydzVyAuiLIAXS/+iWyfPGJD+tGg93KyX2JSoBhXHNB8nHfkXxLsSo6jwNp3oXOk5v9B1FZ9IvWJYUkgIHKnWZf2htTvymrx4zY2nhF5aaYpyQvKm0IjDEMRqlVZKOOaaOigp6q12a08GoF4Al9e1Qwd2ZO2jXjxIas2oVUQJI7EZPC3d1IGhDMdGRUfFEgDbURvnhWOY5vRALYvsiUpjv6fdH6xSh6vwyeO4rKLwNJZ37xACHQbHwGczrdplxbDfywvyC9/Yzc/nKL++CMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/31/26 5:39 PM, David Hildenbrand (Arm) wrote:
> The existing code is rather horrible and already resulted in bugs in the
> past: we special-case UFFD inserting anonymous folios by grabbing the PMD
> lock early, but ignore any other markers (guard, poison through uffd) that
> could have been inserted into the page table in the meantime, effectively
> dropping them.
> 
> Let's just unify and simplify the locking: try to grab the PMD table
> lock and if that fails, flush the TLB, drop the PTE lock, take PT locks in
> the right order and check if the page table is still empty.
> 
> We still perform the heavy lifting (zapping the folio ptes) under PTE table
> lock only.
> 
> Include <linux/hugetlb.h> for now, as x86's flush_tlb_range() macro
> depends on hugetlb helpers. This dependency needs a separate cleanup.
> 
> Both issues this fixes are rather corner cases. Let's not CC stable for
> now.
> 
> Fixes: f807123d578d ("mm: allow guard regions in file-backed and read-only mappings")
> Fixes: 1043173eb5eb ("mm/khugepaged: collapse_pte_mapped_thp() with mmap_read_lock()")
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>   mm/khugepaged.c | 64 ++++++++++++++++++++++++++++-----------------------------
>   1 file changed, 31 insertions(+), 33 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index ce794d9760a87..ad07c8caa3bd9 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -10,6 +10,7 @@
>   #include <linux/mm_inline.h>
>   #include <linux/kthread.h>
>   #include <linux/khugepaged.h>
> +#include <linux/hugetlb.h>
>   #include <linux/freezer.h>
>   #include <linux/mman.h>
>   #include <linux/hashtable.h>
> @@ -1832,6 +1833,17 @@ static enum scan_result set_huge_pmd(struct vm_area_struct *vma, unsigned long a
>   	return SCAN_SUCCEED;
>   }
>   
> +static bool pte_table_empty(pte_t *pte)
> +{
> +	int i;
> +
> +	for (i = 0; i < HPAGE_PMD_NR; i++, pte++) {

Using PTRS_PER_PTE to iterate PTEs seems more straightforward? Otherwise 
LGTM.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>


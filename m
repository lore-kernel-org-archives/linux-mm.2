Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 132B6606A325
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 07:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=vQcZ+K7u
Received: by kanga.kvack.org (Postfix)
	id 20A9E6B05E6; Tue, 27 Oct 2026 03:20:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1955F6B05E7; Tue, 27 Oct 2026 03:20:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05C896B05E8; Tue, 27 Oct 2026 03:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D00266B05E6
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:20:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 632DF80915
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:20:46 +0000 (UTC)
X-FDA: 85367558892.22.91E427F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 317FC100003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:20:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vQcZ+K7u;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793085644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JxvqEmSKUPHSp/dylabMtz9NDYhSF/aiHTeMfx5p0gg=;
	b=BaVGzVxMe6F/dUtIA1t8mBwlar5gpFyFG52IcsXS17xbMbyO6m+f7rHQGGaOQf0WPIIS9Y
	A/GS6+Ec6mcCbvfKP8LTfe7Dtxh9yua4j8PQEnQy4R/PjVw1IMoR/67FHjK7q0cimYTGle
	MSESA8Knjavo0XtfkYAHtH0TUPuI0P8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vQcZ+K7u;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793085644;
	b=JXyMo0ffLikj4MRZqn6bD35TF0JTJX7/gSwcbC4M1mip6uIGFMkWbW5xgSpawziueibPm8
	G2tm57zt4SKbs4y8y4SNojv8x/eL3Ev+Ih/owf0j6l4Q7oIgwkQ2we73f50OlaL1KVNYeA
	HEKYQB/tiBf68vwafh9ewIpyfcNau18=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF373165C;
	Tue, 27 Oct 2026 00:20:39 -0700 (PDT)
Received: from [10.163.152.160] (unknown [10.163.152.160])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EA8A93F673;
	Tue, 27 Oct 2026 00:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793085643; bh=9hjydCMJHH07W+S/5zQJiskTD8rJHnoHE7cyvgQKAu4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vQcZ+K7utjnoFyY/avj8WNV9xYKitfP2P//3Id71b4DAsIKJDegS4COAwYGEiNKT2
	 PrXdAjX60UJjVEs2tZHA6I59AtFq0w29SQQ4rAvE+M4N2PjAlsPToayaOUnEVUpCVa
	 /LBIke5i9dpMnl6JO3d6gq7y1YASHSTdsmqI17a4=
Message-ID: <12633ce2-dc65-4908-930f-b128f525cc8a@arm.com>
Date: Tue, 27 Oct 2026 12:50:19 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/46] mm/mglru: don't use stack pointers when walking PUD
 and PMD tables
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
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
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-1-6f74bec9a5bb@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261027-fixes_core-v1-1-6f74bec9a5bb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 317FC100003
X-Stat-Signature: xcp3xs98di6en8sohtpeaxzxuhg49twf
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793085644-74520
X-HE-Meta: U2FsdGVkX1+zzW1DqqInRs3qfTrsXww/8To38sRfvexY9cW+rUGhgYpqBl72rjipjad5GH0a0oa7C7jbRGbO/zrIcfK0jpS7mWvtQEDnpxhsCSVXP8EWexQVw3/bkzv2nuKPg7ZWtFfmTvzcqUFk5uMcEfiS75vZTxxroHytWLvl8frLORzOZJzDfUkkuQmHbF0Lsgoqo390RzHPJzqsi1zVVBQfAwn0nI63p+mwtnGUSzrOpAHFVsi3q2OpdQFRGqxTmkNSVMwELZnyXWpdTsmiWURf2gdJecRilifxRVJ2C7TPvjE+1JmSjU/ybhGdJG3FGYhooQpY0FZ0LG4FaLrJ98i9zvajMlnWV88F7C1mXh3RSjjhxrRIWY0/QrjSJ/DjDG2McM79YH1eI4VYbQdvxcdW8C0FRwBYUXfV+GAuhg3LT6DXfnmvVOszuLy216W5uqSXizc5RzShN1fwayNZeNyXJhUvFlqIA0J21jmbB17DAI/nOk0lVbsZmXlwBYX027mE7wEynP4k2BpZ93sjrtebv4U43ONyzC2TyKs5xM5KzEATBbnAEw+FDmNNC/oszJGR1TOvzydP2IwVxNX3H2fUqkPTwcIo6sQuPMWWPKoTY+a61gAaQCDx7RFKfvZe9DVzheDsDbKp6NHtTxXflX5m/Zudpqa5vsy92nKpIdG8Z3QQSt5gAgFCw29rDTkcxNRUqbWO6NGTFVuGbEi1387EJ6yx4nGzolA0yp8Xxh03hsbcV9QDzE/QD5xMTNG103nEO+2SdM+EhkIgiTSD44tye7iM7OKdtpmls/S76ul907y5FhFHurwCNpdTRifbVpdLniQscxttcY54tpIGgwxuNy/pkzzCO8e8wtfVNsFGZKotMxKRgP5JcmYaRvES+Ie0SJ/eMzfUMevM1HzPNEG8lCnSWtRle+/MJEOkQhqGYK27F2wumkNwLkKR5sPKLEI9M6Swx8IzylY
 7rFPKwvX
 iOgVTshhzdXAZEkvbZXK4c/JEzZRYGhoikskXgelk9LIEa5cH6bKKm6U9JJxlYa+U26UQaFcMQq6SY+AQHmEurTs84Y8qRm7c9tpuqB5kR/+dsSfAAgEwkqSrYGai8QLgZ6aiQzwv4Lw7CDQuRtXVW1xbOcO6OeSnVTyjXOKCFygb/DjQzOTurOmXOgIZfPkIJEOHJqQ8psOc3BLa4JEFyiVLqdmL7pxwv1UxAETha1oAhXi07eSxv8ZiyIw2FbrBYMnSngqC/ZPUuMHyQ6b/GUhCQpdGLbBpEa+h1bhZD1evfP13zXz/AX2itO+iSBNIPDYnKTfmUEE5QkTNePFO96MNH2kYSgcT5jSDghIWqdTT+x4uaW27MNvwYWZlxblykIyBDchAu0BHYLKXf2X4eKF4EBGxTd2T9IfIUewhfLRQ8zAyb0N27JmUgNIe3E0s4rnK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 27/10/26 4:47 am, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> MGLRU passes stack copies of page-table entries in walk_pud_range() and
> walk_pmd_range() when walking to the next level. These copies can become
> stale when khugepaged or MADV_DONTNEED (CONFIG_PT_RECLAIM) removes a PTE
> table concurrently.
> 
> This pattern dates back to commit bd74fdaea146 ("mm: multi-gen LRU:
> support page table walks"). Likely, earlier locking masked the latent
> bug. Later changes exposed it: commit 1d65b771bc08 ("mm/khugepaged:
> retract_page_tables() without mmap or vma lock") allowed concurrent
> retraction, and commit cf4a65539c13 ("memcg-v1: no need for memcg locking
> for MGLRU") dropped the walker's outer RCU protection.
> 
> The fix is simple, so just fix the original commit so we don't have to
> speculate. To fix it, pass the actual PMD/PUD pointers. This restores the
> RCU-protected lookup and validation against the live PMD. Note that the PUD
> handling is required as well to handle folded page tables correctly in all
> cases.
> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: handle walk_pud_range() as well, clarify+simplify description,
>          adjust Fixes: ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  mm/vmscan.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 9959ca158ce83..6a1af9b92349f 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3911,7 +3911,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
>  
>  		walk->mm_stats[MM_NONLEAF_FOUND]++;
>  
> -		if (!walk_pte_range(&val, addr, next, args))
> +		if (!walk_pte_range(pmd + i, addr, next, args))
>  			continue;
>  
>  		walk->mm_stats[MM_NONLEAF_ADDED]++;
> @@ -3947,7 +3947,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
>  		if (!pud_present(val) || WARN_ON_ONCE(pud_leaf(val)))
>  			continue;
>  
> -		walk_pmd_range(&val, addr, next, args);
> +		walk_pmd_range(pud + i, addr, next, args);
>  
>  		if (need_resched() || walk->batched >= MAX_LRU_BATCH) {
>  			end = (addr | ~PUD_MASK) + 1;
> 



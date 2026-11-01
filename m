Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B3E6606A32D
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 03:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=p/Q4ETTt
Received: by kanga.kvack.org (Postfix)
	id 855B56B05B2; Sat, 31 Oct 2026 23:18:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806716B05B3; Sat, 31 Oct 2026 23:18:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F5AD6B05B4; Sat, 31 Oct 2026 23:18:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 455476B05B2
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 23:18:02 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 891D11A0778
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 03:18:01 +0000 (UTC)
X-FDA: 85385091162.26.8B76AF9
Received: from mta1.migadu.com (out-139.mta1.migadu.com [95.215.58.139])
	by imf15.hostedemail.com (Postfix) with ESMTP id 72B7DA0002
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 03:17:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="p/Q4ETTt";
	spf=pass (imf15.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.139 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793503079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z6x5MIctxHa9/j/zlx7zweNCYHHtp8racH88QViVO7E=;
	b=FausC22Zk+NnEZTOczIOPo/mSacAObxZZ5PRz3Js20/bjEWocEBbNE0t+GBrCoXsQIV2qI
	1h/7SuNEtIIF+93CmntqIfRWEapoJzeIS3o+hIOzyr8gPeuCNxPmgfFtA3ZginPg4syYq5
	RK+ia1hStIa3ra/P1TR36waKbXt0YYA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793503079;
	b=MpZ81QMZOZVRNyFRskQa6AxQLJNR0fNGFETA3Lx46ZoQI3TBCCM0mnhtC32eMeS5sXI090
	n9p8g++kT2S1eZogRdfkR3UCQWNlkElIiQfY/NYhu2r4+/tTEUJ7RY8QM9spnXhwm1wj5B
	BF+Hy67Nf65d2rebGb6RHiuWuwA2ZlM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="p/Q4ETTt";
	spf=pass (imf15.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.139 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VqvV8qpM4mS5SY0ZFKzHPcZcEDmnWQFJ4Ho78vSEfFk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793503078; v=1; x=1794107878;
 b=p/Q4ETTtIC16vjBAdv8+ISuTf0FXF9cgntxqj25Zl5aIfG1jL2F0WbNloasy9A7EoIVpIFOr
 OxNrtrDS+/8yGvz1wt4ceJoaCmPzh5TpOQQ1e5tJ/a9TBWUPDyrRr4BKmkx4z9zaG7vrKKwqfCV
 BxONu9cspI2Vmlgf0XZ8Mkzo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 83615b79e9b3fb35;
	Sun, 01 Nov 2026 03:17:57 +0000
X-Mizu-Trace-ID: 83615b79e9b3fb35
X-Migadu-Flow: FLOW_OUT
Date: Sun, 1 Nov 2026 11:17:50 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
	Lance Yang <lance.yang@linux.dev>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>, Alistair Popple <apopple@nvidia.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
	Minchan Kim <minchan@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Gregory Price <gourry@gourry.net>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
	stable@vger.kernel.org, Muhammad Usama Anjum <usama.anjum@arm.com>,
	SJ Park <sj@kernel.org>
Subject: Re: [PATCH v3 01/47] mm/mglru: don't use stack pointers when walking
 PUD and PMD tables
Message-ID: <auavXi5A57dM-_Nf@bogon>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
 <20261031-fixes_core-v3-1-d6437171ecc3@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261031-fixes_core-v3-1-d6437171ecc3@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 72B7DA0002
X-Stat-Signature: 38j1cmfg9pqu54rf6jfwcue59rg9qwzo
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793503079-67025
X-HE-Meta: U2FsdGVkX1+d+gBwgGF4JCDnEYMSIolV90JnUdH0EQOsbN3GMkxvc4VlWaQSaPfwBC4/DuW+zMym4REKMKWJgMxOkWBvGSJYWgnubrplaKzQyur/RIALOYtoInzpLGCHi4oAAuMGzHmZJ7SxcRHRUUCdknsjY1DfiGb6egE67i5Aa4eJhKmN8d9ecdfL9NTND2prRCgyTRzXNk9aTfZpGrTy++j+W3vmC4Bai7cGv0QasLB1VlrqZBRRiU/IDcxeK36bRHImVUem8G6BfBE7mtOxorRJxRi2mVsSjSxalCF/8lf3tV5GHg/YOifpTpc6zZug0g53KutlUlbl6NwqR0Xh3MY38DCSHDpeY9OrNxo2HIMte4zKqBpExpJIhxYKlRIVepjOPxPLZ+IASwdCdqv/e9gI1ls1jjlKpFxgGsMp2P+T3FfO23IJHtrPEU26QCybBU3CzexNVwtf7O7rGy52Vy9bnlIWsdTWGIECAwJSyhTxoR3HPwEVEIPP3XbADFAk2yGZAbtyZAZzxz7Ku7Hs33LQ9N0RD+265M7nhL2fohjiq4ZQAzvYkFWyCVtMQb09y5zeZSdVgX8c4GrNXHof5twZB7rgIxl4X706zInpxHF9Bya5rcvfploRJYxhXgw6/p1pE3pIed1+btV6eY5zcMpax/KCLW5rRtUJsBx1S8eYNQ3jmelXU0YtXDiGtxoE2CWBFVN1yS9hQ5BOdIPOUXk8IkZ+EqgcZplpEOoVryDZACHTSITfGDIeKu3Edjydet1V5SOU5s7L0eM0K5TF7P/S7+ZeEsQUXX+8lYIQzVh+YClbqb9/yWdwZOrLbABJ+dRwBgBgHqzV3BTlKPpS3TWR3vurKM9qWzo/ryC1tPi527k//CMgvadm1BkcKF0R3Ko7TVu+12G55vw/jl8hl6A6CYOqSXxQmRF8EQRCkMrYxZYDTG7zZw2QoPAXDEEcSAfhfm0rSM8ltik
 yz1Fyw2M
 xc1i+lhQLLQ4RfugZ1jLJn/st1TCHDo1G/HiVjni0nb2Fx2gKgvHYCE1r8IlB0WQ3LIMy1y74rWezIJXo8nMtFQqRd/bM2gFXGZYgaGoxz+MG7OgYxf2X+Axis9KoEmc91AsmZtGHjBFDDwzkMdf9xWVxR3trRseOrU7IkXOraNYiwe6LQgPtebzPTeRJDLjmSAtINamnQ315KBnwCVlgNFExwsfveiiVeknc21NknGkHxGywMtScYjN+Qu1hb8Ui5BBhE50zxjlqwg/g7O6iiUgp8YA3rmB0RTG6pB8axIuYCW1miuYJsHuk0n68LqYmEyHpuUFTrqCnnH08348uSZWnFJDJjwag6ftVvDdbbFzFeYHOrj5VM8bkZh1Dr7CntzWFS8O7LUkhYo75TYoUpA/qToevTgqEFBjCY0R1OPK4ZYrB9Nn+iF+Db3jCxTjl55cAOjY43Sd8zXmpnRcZ9/MNsERelYPgD2nml+XfI+3uSYbt4s5rX1HSko1H7xmz3ij6sOSOK9c4kZ9niCNLzak0h9cmBHHMiFXDZVF0SQ+e8mRbxNszgc7lDuSw3XpbG2LfYpeyPpeBF/SEWn38pJRTiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/31/26 at 10:39am, David Hildenbrand (Arm) wrote:
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
> [ david: handle walk_pud_range() as well, clarify+simplify description,
>          adjust Fixes: ]
> 
> Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: Rik van Riel <riel@surriel.com>
> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Kairui Song <kasong@tencent.com>
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Reviewed-by: SJ Park <sj@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/vmscan.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

LGTM,

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

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
> -- 
> 2.43.0
> 


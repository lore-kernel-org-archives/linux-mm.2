Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36EFE606A323
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 08:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BoIvLyS4
Received: by kanga.kvack.org (Postfix)
	id 2B1A36B060C; Tue, 27 Oct 2026 04:06:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 284DF6B060D; Tue, 27 Oct 2026 04:06:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 175066B060E; Tue, 27 Oct 2026 04:06:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE2C56B060C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:06:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6DDCC1A0908
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:06:51 +0000 (UTC)
X-FDA: 85367675022.18.5CD0E74
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id BD646C0006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:06:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BoIvLyS4;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793088409;
	b=igqywRI+cMu05ghYlVDD2Y7mJLES0zkB7mMeviks0rBP85ADnr60zGhZex4rUp/cUhK2gg
	kCR4DFNgqRtT9D5zMujnQ52yOMCfG+4yVCqOqug0yhW37rkETJ/8pOEfqTE4BN139v7Kz4
	FYNrNzX1Yk1SiSjftDt1zlvgz/CRrlI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BoIvLyS4;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793088409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tGP0LjdymEX/O70OpFiXykL3tGWdkhpJkzQJ0xiHk2s=;
	b=0dA077fpcIwxwGpO+D4hz2efEIn1sipFIdQMYp0w8DmCRQs9uM2mTLv2PH0Q2eqZuxPpns
	HxlyToB17L2oxjwFS9h0anHDtSqMNt18o2q4bL0bZaHfRxX/JdQ6DTtjhRckQ7kYzffsbS
	sr++/42/9OjdaUtfpqkJyeCvUftHQQc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 44F2243BFB;
	Tue, 27 Oct 2026 08:06:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7669F1F01825;
	Tue, 27 Oct 2026 08:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793088408;
	bh=tGP0LjdymEX/O70OpFiXykL3tGWdkhpJkzQJ0xiHk2s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BoIvLyS4BeMWr65hedSikSZ5vE8O9JRgtibUW/piTLatgtmus034g8LURA3R+gHJc
	 ydIDPqS/Oq7d7JsbwgaioD3d1cV8JjOomy7xzfXW42dsVa5rjkstyyKLDXODrEKei/
	 vB2Qwp8dvj5O3AKG6ZMVvpIywISsqf/obj5nk6KOVMT8qLApC1PN0PM0ZrjYBAf2Xu
	 5g6N2XtIXQ3TbybogpP04e5dcBVdBVy+cHCzH1jEUnk9T+8vtYavS1rB+QxhcGQdgH
	 FThLB2pNS03O7e0SOprSN4uGF5bozDM1GQt3OLElmNxQv6g/clWdchbL3nMOAmhEFL
	 j+r5zdUmZqxow==
Date: Tue, 27 Oct 2026 08:06:31 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 01/46] mm/mglru: don't use stack pointers when walking
 PUD and PMD tables
Message-ID: <auBbKP8UNI9talDL@gremlin>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-1-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-1-6f74bec9a5bb@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: BD646C0006
X-Stat-Signature: xcttt1f3ipyjfagfquohz95t14h6c3tr
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793088409-560688
X-HE-Meta: U2FsdGVkX1/eMK4vXXAOl3dNR7JADs3+rPkSCpcs8QfB14g+MgLWTEPpjvX+Mg5tH7HbdksLgZiE260tXFXEWbTSUUpa6lRYkd4og2lzPj+tah8cseieI7W3plmZUfByhgHQByha7lcs5qLO/4uwoRsY4EULy+78oIzF2piMYCdIhA98ie0LsIaXTXuq7GkajYNhWDAG2dgdTBBr/FQ4M7eGftI0gu//TodOoLClzIi584d0iNW3BfiYYGRk828Hoj86QxR3JBjtx3kcenFh63huUlMnMEApw4UjHoL7zpA4YJdAv+ybf7Lbu5UM1OOqta6jeuD3frl/YMFoSsExcC/JaPhS9AfQ5ji4pPipLMJRB93b4sNs6tmAQWNsFuQ0efYmCGhq2Vxmt6d+EyE9BsrbVH2vzpXdMehGam43d5dbUELeEsTBcvs7qlIH4/nAGEqLFFiGc0RlnCC5789zYx30GJlZD85XpUhKftZqM55jnd4FOR4gIqpVcg0f8r6wxKHD39caHZGV/YrzlzrGkGAtoI0aG3FYNAeSM6PopmFy6U46STx8IA0t1GKgpQ0lTsndkZYJB9jx6H7UBEs7ZqYQsaDhib72YrYxip3wWVebSPRXRglJAm1WSsf/odnvNH7kQSHIY4KyqvvTGCbgNUpCkTaiE2z8CYrOtWUIH1uWccOBJc3bSzOC0ANtbt64c5UkHnNndECn80/+B+HZrleyYKBV/De9uuqKV7YRDAcIiRTOT4JKNz0TCYxt2B3aBn/yMx1xOe9B6cCdt6/af/LlcjxZoNRan7YOpWZ+nXOWumYmvMNqLD1CVOQS8fVgr5H86tsknj0XPz+HwwdHuZaFxpPlqGplMcsk5kOvZYnMmcE75J+vk0G4Tm0xqwoSoZUJD8nnO3fBklguHhoZwipxwJyPdPGkVEdzxeEUO4TlhRuUldvZFovYn5HpfCKgDWxzMiO0Q7RlH60tjCT
 53jVRmA5
 I2w0SGOWwQJKlMsCsHBU7YnDQAeSkuwoB2VoxkKQ4L8taRgK3TfPjHJcqNGueaU2qeHdLd8zzlIUu5eeKY02maErCzNQKCtEyhhTj7ofMuQ5Osud3IHin3fbyYlK/TCHDWPqkl0L51myTvfkP3e/ASL6tc1G1R/H0/eS3HMr60YnWOMTR4N8W3JyDaJs4dF/qHVRufH7igRo3wlAAiufhupDil4obYXQuOus6i89FFYq3fBhGW4sngV5JH/koconJamkj8Nrh5Q37JvV6QkMbqtG+i8FbbOiJ7eYntfpRD5PJsUVapWpbsiIOO8kwWGM68nC+t1+NiQT5izG3Q7TKETjxRE/2UMgoqCbrZAeNMxiCkIAXiJiXv76qK2n5PC1ETrelqogzKGw1sO3Qc4DZakkWBKo/E6VsC9MY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:21AM +0100, David Hildenbrand (Arm) wrote:
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

God, terrible. And why does MGLRU feel it needs its own independent page
walking mechanism?... the whole thing feels like NIH syndrome writ large.

Anyway, rant aside:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

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
> --
> 2.43.0
>

--
Cheers, Lorenzo


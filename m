Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8035606A321
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 20:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f/91R5wp
Received: by kanga.kvack.org (Postfix)
	id BD30F6B08CA; Tue, 27 Oct 2026 16:07:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAB0E6B08CB; Tue, 27 Oct 2026 16:07:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC13F6B08CC; Tue, 27 Oct 2026 16:07:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B8A06B08CA
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:07:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EE5551A0AE4
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:07:55 +0000 (UTC)
X-FDA: 85369492110.18.452E54D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6CECE80012
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:07:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="f/91R5wp";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793131674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7GmJ1pURkrI2M4cFdKYZZ2Ya/fgG59abQ7Yb/9UtrSs=;
	b=refKcAz9x6gClZ+D1/h7JHWhlx5ZIuzPD3iXkggRxG5GaGnS/IIkQuHNSWOX5aqn6fq6ai
	Ae8avzkJuF3FGBhaZ+Ib2DqhxHpqYiYv/tzrR8qmL+fj9W8GsCntQ14u0g1fQMpKP7i41r
	vyAL6DVFkjZd06FQf2rNFLqqAtIA86I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="f/91R5wp";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793131674;
	b=NaUQf4VCo1rrs4pTXYh3AKSLkBZ9GWdrNZwnItWrYaOizcphBiTPPbDF5HdAVOvWPVLCW/
	zMhN+H9kParOY6U9eh0W5UDIMHtpLHbAUDICINir00O0fxCSyMpYDc3GJhJLy4C2xvwOXd
	9Hpqq+Udp6ivOf1hl5G7+I1HejGysMo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9C0486021E;
	Tue, 27 Oct 2026 20:07:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5CF11F01825;
	Tue, 27 Oct 2026 20:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793131673;
	bh=7GmJ1pURkrI2M4cFdKYZZ2Ya/fgG59abQ7Yb/9UtrSs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f/91R5wprezD4KJkX2Jx7eMJXK4zGt7nCjRBu4zWgh8B2lozTbjxHynKIIEt9/m3f
	 KmyPkE3l8j/1agfXZbGkBypO2fHwU0XhSfNULcLHjxjA52K9g29144aOXDupqH3gVj
	 OT3eLlqbs0BTCVZVhirng7gxbOWPZ8yfKPk5IvDDERvJBacYahHrZc6ze7rglgM8w6
	 imkuTFKf8yCjOjgLHdSu9sDjLJshaUz/ScopTOXRxeyoDso5ip229Mq5ygKszg6hf8
	 HikkJKqYHXvk2V7qmSpaCnNcIPX5qKKye2psG5orwcoufcMa2jqaetc2Dy2c7kS6jc
	 2bZ5YYFxsJP3g==
Date: Tue, 27 Oct 2026 20:07:51 +0000
From: Harry Yoo <harry@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
	Rik van Riel <riel@surriel.com>, Alistair Popple <apopple@nvidia.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
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
Message-ID: <auEDQlAfJZZzaape@thinkstation>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-1-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-1-6f74bec9a5bb@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6CECE80012
X-Stat-Signature: ab5h7dp8dnq5qwiw4bg5wraym5hdt4rt
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793131674-477051
X-HE-Meta: U2FsdGVkX186WgQtI/euAffhNzLars/tITYqK4gIHPxkG2MwRATF8ou5DKUTD0I+38WlSR4pOIGNUm2mHVTPvKcUfQUKsT/eJTO/gPqKajFiviZdGZc5dkKumDgpG0TTi9A0Po1bQJLWB8sara/k9obykn+WPaymNWyMLo6jO7rkiEoLhZe/6cuQEzGEuHN07agI1YW3QePBvvfZQH7JddLnEfpSoj6Ai5suRpJOFd9Ls/0AG/1JLKAHcciwaUxD2v8x0WQx6ffMRkpdP1fje8uoshtZE/yhaU/soUw6P0fs78JDhpxQZr2p9Jbug0fMyZIZY1K23/n+6HuDhrdXUDuKRGfjd+duKPQcnmcuCMztm00SvMt+sRZT0QZ03dOj6yqBNF0cNRVXSiCTUzG23RkPO/qbV+l07ZS7kib0Jn6DEsSENO5d+goo1D9WT/o3hboJ96narSSyqzbCYsK76K7GRoqoJrbIqVIqSkIaTIMf+K9S0H/Dt5UGk3K5ZwpAp/gQ7XwJizeNusYnFk+7YwBlpq+GQ4Wq0ZQ+iZLaYQXppQ7FEMZERdHqG+q+j7IBMtw3eA+GaYO/bG70/JmSgYKahCzXTA1Yup+Onrkd/en2P9A5c25L4yuWlxpvzl+QZ1kjBxZZjb9j0f0WetC84zX3TgpV/RWmuMnwtT5sSvNjgGbWDPO0QH2uUfVANYJi8aHY8wMQjfWnXjZL/xHG9YxzT8XkERWIZt/JWUfMJZ3Du7M5QGf0oFCf8GNjp+Ak3KgucIagco69RLNetxeMcDwzRZ0fS5At5uAyreJc3G8byvwWyOAzbBQW1QhaSGjbHS44zRi/BzTythnE13sLlWkipg2Jd/2w2OSoVPBidPkPAx2oGXI7TK8ercTm1kRxJ4sijZnlewBmKyDaU/oCkX/NJCI/6eXUxK7s36tZwpaQdPG14JAZ8v6ciLM3SoEmcWD+Hv13/LDQzM+LUUh
 Z2ZqY/cv
 2o5DcsZ3pEcW2PHLrIc/281UN8f5UegAkESi95resfQFNt2bRc6MkMoGT3Rn1Ue3EGlLzkS3sCScffDuheeMuaIPXK+8u76uB29UlJUasMRywanSW5gwuf6OzlVYksaGEAL3W+VdVgFQQ1cmuUWMMrE9pfRXQyDliRLCI9ZPQBZwe1Ctx7uSx8wZ62/Ns3fVQvCrIDQT8v4nBWvmkrURQJEwTM26zhWjWb9+zevfXPXJpiorYCVgOb8m4mqrSTpVPDM6k2GU0fQMMA1ZXSywrb76PLu8GhsjOZQgqD/2DTIwUbehum5kZ1qn/HVizEOvHOeuExbgYI3vVFYU1ozso7HRvEEL/5ZYpcTydgqiE/RnFJkGpq+CrTsd/xcegg9QDIvjVt27/P6C5IWx7iUSK98xeaknQEJKAi3FG
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

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon


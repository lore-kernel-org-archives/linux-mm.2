Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB353606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 07:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=qAO7tgcE
Received: by kanga.kvack.org (Postfix)
	id F03F06B05B0; Wed, 28 Oct 2026 03:52:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB4F76B05B1; Wed, 28 Oct 2026 03:52:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCAA56B05B2; Wed, 28 Oct 2026 03:52:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9D026B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:52:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3B9E5A8A04
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:52:22 +0000 (UTC)
X-FDA: 85371267324.02.013E5CF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 23750160005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:52:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qAO7tgcE;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793173940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C2MebSDm+AGzraIelTihisR4wHMyVkbMMbZmgrZJ7WY=;
	b=fSUfMUseTbCl4IL3f+R6gryZIMfmS2RRisHLztytf1H7PPt+mKLAhu+UgoFEmlBk3oAfzD
	rKljMygXKW9dSvkht6fvM5SD3b5DswIPJfo3gq1ild2jX4yd4C5wbZrUH9lj5vV88oBEIZ
	JTOvxJ2OvdVKE4I2fQWpvuflDzz6JCs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qAO7tgcE;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793173940;
	b=7NwRMt1aDHBpMuDBgJyHSWWqK/Oj2XuhzRtLAA2dsU9n6WSvBxs8j55HEdaurpUIqf+Rtv
	vYKhidPm5acSfjAJc1B5a4o70VACVcsMSjgA8q3lGGEBfXWXIrweRdaSPeAE0dSUOGLljJ
	q9LiOO6ULZz4+IKbzy+JsgN9utY84Kc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 091D81756;
	Wed, 28 Oct 2026 00:52:16 -0700 (PDT)
Received: from [10.163.164.200] (unknown [10.163.164.200])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 046D23F673;
	Wed, 28 Oct 2026 00:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793173939; bh=wGe8fo0LsEeNmyXuE7t5RJoQX1lGKJltqCDxnR+anGM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qAO7tgcEvyo0Q3H3HaTM1nwzy8/QBeW1tnF4JOXa8qF71VXcIH8niSLEX8yBfM9DY
	 y3XuPsTISI5OiWjvg0v6LudaMoMHfe0T+fQRVNRKQDaWP3kjmosTINe/S2/q5eMvvF
	 XylgVFbGPVK2/y+rwaLieJ3EjGQdsqqHDKUNnM9o=
Message-ID: <e32a19c4-76c4-40ba-83a4-781333af7b0a@arm.com>
Date: Wed, 28 Oct 2026 13:21:55 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/46] mm/rmap: handle device-exclusive entries in
 folio_referenced_one()
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
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-9-6f74bec9a5bb@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261027-fixes_core-v1-9-6f74bec9a5bb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 23750160005
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: y19u5u5u9mqee6gz8z6omaxdahk9czp4
X-HE-Tag: 1793173940-344676
X-HE-Meta: U2FsdGVkX19VO4zQqWfkazpXv2IUaETpSpl/fH2hrH0scNmkFih90m+tQ+I4eXNb8Mu1v5dwXv6Gwxiyy6tK7Us08EoyA1JaiMPErh3z8PYeohcqaDEBTZ3Gzn6L1UA9zoyH8iBAZOCsLBuUQQU+7TcbTDbuLeGhO+LzNzaqKlIo6yKZU4fMLoMk1MQhL5NJR+FJyIJHl89qGqMG4Cj7fRI5QvG0JX29ZRZAmLF1BUmFqFzi0XEuhFlheIcfikzUdFlK7I3mrgGDkPNZJeuAgmJ+hnm20BPl5en69T/WLGdM6DOGjYUSCc8k2Fg/FWEpFZKHigvLO0mFqTn4Z3tdQ6PPYcLLgoXFRAiWCvM4pQWHUGfVBcqKeyPp1fjw4pvHIHIQcvShfQsi8SQTaaIKj7CPrL3fok7ORC1Sv99WjJGG9ktEllxSfkWlqd/beWjAMcCu4W5uU+ZVuIH3CmGseMEOnPofVtCh8S5tmB6bV7tdF/qFh4CppOWqURZnN0QZJ7B/TUhcN5ZcppAAN3khBCerTevAhGEn1Gc15DC8EIIcYSCPJVo3cOsuOZMhNF8xTUNorPGf9a+ZVIyVNNWj1sy8wsQcZoXfgOpkNXhjqAAy2EJXbt+8xgO4FrRmEPsBOyC5fUUsuSVE9VkcbN238gQquQiPfsJcolFX/3oK975D+g4eBWX1ekdGlSvQYxiTi+wMfyKRCxJKjN8g8hpftlx7h1O4jxobkRYCxH7CloWPWpcGWQbl63L+1Wg8PNWgeNSRXA13kInk8JA2z5hqG5YQHYMn9WYJoIrgjAesXB23JweP9E8LiKB41X+Gvuyms47DlEeGd8xs6oDzs+w763dy/FeoIcj/tJsgG1C7695oscGtYHXvwBnoijuzULOsNj+0Qi6cmCeduYnMNNzmuSyEZymn4wbYPr4cowvfO2/awDTPCikyQFocOKOfEkRCY9z0LDmz/4flz4dY8Lm
 TxRyqQm+
 O6dONPOdPeGfuCoTtHJ/XXd1y5NykQiU30OqiNPqlg2sOlOtMsn+pALgCfgksAD18XrcRNsLkJ6//rbFygt4+G6PQzcdFtDv1MmcjC/064Hdt3Bfu9H+GAYm+wZDYT6Bq3xJxr2jHMGsjLq3IHXx+wgjulKWq8YvOLP7w5YFWW7/oy9xXMomSyB+PxOMUoeQTJKmaOROry+80V0fcQszBub08658mslJYvxVEg5ViQia5O3AGQB6MbxBik2b3MexKdY2Gr8IXFXks7o68ub+tIWYX4plqDVerSFoA+H/E4iY2hOC45C3XDlKcZyYNuU8kE0gh2ruQPlHumS2vXBKuTMFjm8ELVQUogm4epPwwsQ14rTi7oECaXtZ1lOwM6zvB9LhQAvzGhaSTrxV3frXNsJAYX7GyK+xvdK05yQzJdvdMenCVfP9CzEQsPc/Er+11OLTIyA/S5HDHgyKPKh36wKFkghomme59UCYeFMy5oIvyPhbUaGCy5vG8CnUxbo8+WDxDfQwLB6XAvCUGLzVbtJewTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 27/10/26 4:47 am, David Hildenbrand (Arm) wrote:
> page_vma_mapped_walk() can return non-present device-exclusive entries,
> but folio_referenced_one() passes them to PTE young-bit accessors that
> require present PTEs.
> 
> We must neither call clear_flush_young_ptes_notify() nor
> folio_pte_batch() with non-present entries. For example, clearing the
> young bit on non-present PTEs can corrupt the entry: on arm64
> PTE_AF overlaps the swap type, so clearing it turns a device-exclusive
> entry into an ordinary swap entry.
> 
> folio_pte_batch() will VM_WARN_ON_FOLIO.
> 
> Apply the same approach as the previous fixes to e.g., damon_ptep_mkold():
> treat these entries as old from the CPU's perspective and obtain their
> young state through the MMU notifier.
> 
> Skip PTE batching and MGLRU look-around for non-present entries, and
> don't modify non-present PTEs.
> 
> Fixes: b756a3b5e7ea ("mm: device exclusive memory access")
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Cc: stable@vger.kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>

But nit below.


>  mm/rmap.c | 23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 1131b76bbbc28..0faef46806e5c 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -924,6 +924,7 @@ static bool folio_referenced_one(struct folio *folio,
>  	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
>  	int ptes = 0, referenced = 0;
>  	unsigned int nr;
> +	pte_t pteval;
>  
>  	while (page_vma_mapped_walk(&pvmw)) {
>  		address = pvmw.address;
> @@ -968,10 +969,12 @@ static bool folio_referenced_one(struct folio *folio,
>  			return false;
>  		}
>  
> -		if (pvmw.pte && folio_test_large(folio)) {
> +		if (pvmw.pte)
> +			pteval = ptep_get(pvmw.pte);
> +
> +		if (pvmw.pte && pte_present(pteval) && folio_test_large(folio)) {
>  			const unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
>  			const unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
> -			pte_t pteval = ptep_get(pvmw.pte);
>  
>  			nr = folio_pte_batch(folio, pvmw.pte, pteval, max_nr);
>  		}
> @@ -981,11 +984,23 @@ static bool folio_referenced_one(struct folio *folio,
>  		 * are. —they could be on active/inactive lists or on MGLRU. So the
>  		 * simplest approach is to disable this look-around optimization.
>  		 */
> -		if (lru_gen_enabled() && !lru_gen_switching() && pvmw.pte) {
> +		if (lru_gen_enabled() && !lru_gen_switching() && pvmw.pte &&
> +		    pte_present(pteval)) {
>  			if (lru_gen_look_around(&pvmw, nr))
>  				referenced++;
>  		} else if (pvmw.pte) {
> -			if (clear_flush_young_ptes_notify(vma, address, pvmw.pte, nr))
> +			bool young = false;
> +
> +			/*
> +			 * PFN swap PTEs, such as device-exclusive ones, that

You mean "PFN softleaf PTEs"? Better expressed as "softleaf PTEs embedding a PFN" ...


> +			 * actually map pages are "old" from a CPU perspective.
> +			 * The MMU notifier takes care of any device aspects.
> +			 */
> +			if (pte_present(pteval))
> +				young = clear_flush_young_ptes(vma, address, pvmw.pte, nr);
> +			young |= mmu_notifier_clear_flush_young(vma->vm_mm, address,
> +								address + nr * PAGE_SIZE);
> +			if (young)
>  				referenced++;
>  		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
>  			if (pmdp_clear_flush_young_notify(vma, address,
> 



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0612ECD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:42:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ED0D6B0092; Tue, 12 May 2026 03:42:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C3B76B0093; Tue, 12 May 2026 03:42:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DB056B0095; Tue, 12 May 2026 03:42:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 513946B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:42:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F18F71203EB
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:42:52 +0000 (UTC)
X-FDA: 84757976184.04.07A272A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E1AA21C0007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:42:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="AXMgw/kW";
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778571771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9X6Ff3yD8depbZIBO8iQRidsRYXduQ3SBDQPy2RgJls=;
	b=2lBVihR/n70c6+Jg3v9qy7bkr6fxySS7VX/bHZik3uJxqnUTpqtnBFBBocY09Bjc8sWs7I
	KPVdniIeGtFitgfElZlCmiDeySo2i/Coh/gIW6GimBe1r2x4VcdsX3Ok7bGLJNw3rW+NR8
	o7GMo5HDMWLx6KiHOlxPz7wZOsDEAAI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="AXMgw/kW";
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778571771; a=rsa-sha256;
	cv=none;
	b=mm3thM60HcfvEJzVSdYvLmWbf0EVGQtZ7Q/JScyMYSiutO4iJZVaPhKLbUUvCyOrXWJk0Y
	TXWC5EpoKw80niywjqIc2Dck9oPN6WJJluY4sl280lyezxpd42YfXd7hbC31LRnO6V4qDL
	JejUo0ZvaEciVgh2P5pNZoP+1xP0V9Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D61C144274;
	Tue, 12 May 2026 07:42:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567D9C2BCB0;
	Tue, 12 May 2026 07:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778571769;
	bh=iB8tMCv0MnNsT4JdZSVwpaqxrQgKB7oJIZ1Ch8nbSQE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AXMgw/kWeXATu0nbAK7QZZ8AuBWGNIn0QfGbj0HLOhiUj+fUEZM6qPW+6j0WW+Rh3
	 mJOswvrr21Mk22eRCPWcEmuOtDN9w7/rWEX/cgJ2Z22jGV0Mq3CQNLzjGfzJ5qhqOl
	 Jd+8UCodmDz5uxv/1M9vXs1W4CTu8q0Y2TvZqEEiTAbm3U6DvYhb4S8mdMI03+GSpx
	 HxSvUoofnBHiZHIfwcgWvMqCA+LC3fRWXTQkPV4J1MyCai8N2ds+e+glhrAQp/N2L+
	 2PM5LXPQbTEAPg+cQhNe2zVGPj6lMPMkLuEYE8pf3IewN5wc0p3ruMZHCvXJmDZq/c
	 tYsmkI+ofRRMg==
Message-ID: <fad3ed18-3313-44ef-ad00-3e643b004f25@kernel.org>
Date: Tue, 12 May 2026 09:42:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v17 05/14] mm/khugepaged: require
 collapse_huge_page to enter/exit with the lock dropped
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260511185817.686831-1-npache@redhat.com>
 <20260511185817.686831-6-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260511185817.686831-6-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E1AA21C0007
X-Rspamd-Server: rspam06
X-Stat-Signature: urtgg3fh1zh46kw9ro6pw7k5fmr8dj9p
X-HE-Tag: 1778571770-677215
X-HE-Meta: U2FsdGVkX18IfbWR89jb4U/A5as+g/hJEIQo8qTBhvE1lv3sKgr89PjonifvJXm6injfTUbSu2gdfNrn3UGyjpLNoFrqZnqYv3iXnY35/pHOf1h0mLhsNZXZpmB7pVvMEnJ6arH+xUCM6fvSHvJZ0V6S7+ntcu1dg7Gi0omr9DsfE3G6MlYZzIH6HPw87ACYZIclJKa/xJeFbM0veIxV4JyeJJbytu13Shg1q+0CzsAN6cxiKGKaea4c6ELcAOmvC/0H5C4kMF9g+Yet5kfPB1NFQJlg68covy8kT5aZNheh8nAwGAJEg6D5N/it5YUiC45n9QV9QcZE+P3t57v/fbiUqYs8Yj5HGJWW4Phpaf8+SgclVL/QySd69k+F7wQ1BHi37/Cu5JttRTyM6K9B211wBBD4CIEQNRuSUXSWFCLNtTilv8pWmZJeeiFhgbGn6G+vHouv8E99NiF3xY0K2P8S0xKNhfeg3rNWWG678d2anMzXQncFXVUTF/dxHO2/xyVqierjlGYOTMpMOnhIOQShiMcG/XzNBmowycJImjnzLvX2VqMe84vrgqyPytrQwPG4zejLbb1XC+ThcktXBJQpheKZV+cU/2RF55YR4iITNq5H/7ic70VaTiEHuU1AnOW/orAcpsk349uCt/ihsHipz3CytLHCeD14m1N4d62/pOAXupGb75cxxlj1tGy6hFr/ExWqc1zW98wC9ZYoFBeksc16eNsBzZWsnnHYZmKVJmIMRMlHEMQGPEYkv5Yugx7HX+n6f08sW7OdtjpYsOTfZwWqVNk8v3CMZGi/ZyhI+8G4Xfz0eIIQt9GVCo9Q4wsCQbpXBYHvf8mCvg0Vy7pTEprh5ik3C6B+JGacjv71WCvSXFvvU0NysAoD2LuhNsbNyAl+IQTsZNNF3IFuGMWSunioGY53gGbTFEtn6hoLzaJ+c85VEejLfsGveUjjQq2y/Zic8rf2X3yblLu
 OrZGfYez
 UinyK9eF6yYVxFwEKtaCV0PmL/OxRZeGBriLpPmEFO5v0HicOSd0Xqc9jW36zS/Hk235CRHNBKZCmQ8VtHagC7P+pUty+YoNA+TBkgrXZ0HS2Vqd7WEOTWMaToSxYas1R3WMpZnZL72SOO+0+wJ4hLMj6nV+Uyc+CBA0fSArS2rXNPNF9pe8NCtE2wGtg8JVTgKVpIk05EXHzJwzuP6xbDoEAgZ7QHqSgEuHCSX6Ga+iIX1zRqyAZB47mi3Vuux1zvWchm8hbe+0E767HV4uFjoPHXkRCPFUkjKjscEdN4xMjO3SErKnC/9H6hkLwJgKN/k3izAyKjQ7HGn2wyHD0VyFmQlCuqMSI1yBxjVJ/DUQwP7yxYWhRHqoqQ3ZsyODbwSRYmBZbh+bptiVOe5qO8JWy+jpX/qq6eYI3IdE34gZ/SgM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 20:58, Nico Pache wrote:
> Currently the collapse_huge_page function requires the mmap_read_lock to
> enter with it held, and exit with it dropped. This function moves the
> unlock into its parent caller, and changes this semantic to requiring it
> to enter/exit with it always unlocked.
> 
> In future patches, we need this expectation, as for in mTHP collapse, we
> may have already have dropped the lock, and do not want to conditionally
> check for this by passing through the lock_dropped variable.
> 
> No functional change is expected as one of the first things the
> collapse_huge_page function does is drop this lock before allocating the
> hugepage.
> 
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 27465161fa6d..37a5f6791816 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1199,6 +1199,14 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
>  	return SCAN_SUCCEED;
>  }
>  
> +/*
> + * collapse_huge_page expects the mmap_read_lock to be dropped before
> + * entering this function. 

"before entering." Talking about "this function" after naming it sounds odd.

Also, there is only an "mmap_lock".

> The function will also always return with the lock
> + * dropped. 

"collapse_huge_page expects the mmap_lock to be unlocked before entering and
will always return with the lock unlocked."

Or something simple like that?

> The function starts by allocation a folio, which can potentially
> + * take a long time if it involves sync compaction, and we do not need to hold
> + * the mmap_lock during that. We must recheck the vma after taking it again in
> + * write mode.
> + */

"... to avoid holding the mmap_lock while allocating a THP, as that could
trigger direct reclaim/compaction. Note that the VMA must be rechecked after
grabbing the mmap_lock again."

?

Ending up with something like

"collapse_huge_page expects the mmap_lock to be unlocked before entering and
will always return with the lock unlocked, to avoid holding the mmap_lock while
allocating a THP, as that could trigger direct reclaim/compaction.  Note that
the VMA must be rechecked after grabbing the mmap_lock again."

>  static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  		int referenced, int unmapped, struct collapse_control *cc)
>  {
> @@ -1214,14 +1222,6 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  
>  	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
>  
> -	/*
> -	 * Before allocating the hugepage, release the mmap_lock read lock.
> -	 * The allocation can take potentially a long time if it involves
> -	 * sync compaction, and we do not need to hold the mmap_lock during
> -	 * that. We will recheck the vma after taking it again in write mode.
> -	 */
> -	mmap_read_unlock(mm);
> -
>  	result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
>  	if (result != SCAN_SUCCEED)
>  		goto out_nolock;
> @@ -1526,6 +1526,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  out_unmap:
>  	pte_unmap_unlock(pte, ptl);
>  	if (result == SCAN_SUCCEED) {
> +		/* collapse_huge_page expects the lock to be dropped before calling */
> +		mmap_read_unlock(mm);
>  		result = collapse_huge_page(mm, start_addr, referenced,
>  					    unmapped, cc);
>  		/* collapse_huge_page will return with the mmap_lock released */


Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David


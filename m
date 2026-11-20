Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19D47606A333
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 17:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gZN90VSi
Received: by kanga.kvack.org (Postfix)
	id 0E5A96B05B2; Fri, 20 Nov 2026 12:40:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BEA86B05B3; Fri, 20 Nov 2026 12:40:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F163C6B05B4; Fri, 20 Nov 2026 12:40:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BCFE66B05B2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:40:06 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 34DD8A0115
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:40:06 +0000 (UTC)
X-FDA: 85456210812.08.ADEA1B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 732B51C0002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:40:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gZN90VSi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795196404;
	b=xbVKzfVxQKk55CIDuK/dwpT8X3oi78k8sJraaRhALdHxJrUJfEmArNnr0xKkvF2AVEwEz5
	ywAZy5TJ+HZfdjfR0K4AtUTlzSkBHkN2z7bLCrWqlmcswN8bQO4KRMC9Kcvcyl2B/arKJd
	mChePDizfbO0GVlgdB9E6U6q+VZLV0w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795196404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xJGu1xFkAMb9C3q3yJAs9zMroHTPcUqb/Ezg7HM871w=;
	b=SSSVRtIFngR7irqiRT3Wf2nFiFyHEf64hr+0Y9judQ8CNs2OoOeo3N6ldE7iP3RE9/7ozr
	v0nl5s5v17nZJ6oAPdxX8vaxQIJV5a+gg1It0zFYWlz+/bn1FbZRJrXne2xroWql50IHPk
	4OzcSv7Y6auhZhAGzKt0vX/nZFnu0Fw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gZN90VSi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F245061260;
	Fri, 20 Nov 2026 17:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14531F000C0;
	Fri, 20 Nov 2026 17:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795196403;
	bh=xJGu1xFkAMb9C3q3yJAs9zMroHTPcUqb/Ezg7HM871w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gZN90VSiuDuI5QRn3XAgpiV6CaGn0DYsGHMNO4NUtRFJ8ek4jw+EyCbEGPqiDxyyB
	 Ap5i587VTg9CMfrXje5fcdwCf7r60ChdZVB23AaJ2yyFnhamoWPp/2RG/gDDZXJ7TB
	 ft+YKQhZgqPefw0msVYEczY30YPfTZ/gpaH8QPrf/bgOEMnfKiBODI9gjjrV7Yv8bu
	 qniaKPF2+HeuFy/EiK6kLCnTALKaDAXU3O+wP3NnppgUq1fOA6EJ5a1m0WUgGdGVtY
	 LppWlkieuK489WQF95wAiZyjoJbn1EixdjJv5aINttGigP795LUH02clMDsWa3ClGh
	 GQA88QJd1sdMg==
Message-ID: <bc398517-e435-4e38-a871-dce2d0a9ac44@kernel.org>
Date: Fri, 20 Nov 2026 18:39:52 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm: flush stale TLB entries before installing a
 CoW'ed folio
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Borislav Petkov (AMD)" <bp@alien8.de>,
 =?UTF-8?Q?Cenk_Y=C4=B1lmaz?= <cenk@deepfinresearch.com>,
 Zhang Peng <zippermonkey@icloud.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, Mel Gorman <mgorman@suse.de>,
 Sasha Levin <sasha.levin@oracle.com>, Rik van Riel <riel@redhat.com>,
 Ingo Molnar <mingo@kernel.org>, Peter Xu <peterx@redhat.com>,
 Hugh Dickins <hughd@google.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261118-file_folio_flush-v1-0-e9e739ed14e0@kernel.org>
 <20261118-file_folio_flush-v1-1-e9e739ed14e0@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261118-file_folio_flush-v1-1-e9e739ed14e0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: o3t4jz9ppjeccx3y3eucojanxc1f77u4
X-Rspamd-Queue-Id: 732B51C0002
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795196404-765538
X-HE-Meta: U2FsdGVkX18OTzkf6ZxPyRexYo2ftDsyV71mM9AlZDFNPsGd1BL4e1sV6eSg7xoOsMay9uj+rk/yt4m/LuziE7438gy06TVT7fE8CODoxWxniLa9JhRLNr20zkkYq5r+A6EMDJqGZD7tGn0xd6Akh5/1gZVmRk5339u0MOPO0aYVqIBPqmw6lpOlh5IjE6+dL8ngny9m/DaHlBOh5k5+c8Sz7MZ2FngFc8QjuSkCZNvzi4ZKdUOO4Uw/mwBAi1dn5rYxj8jHxdwR1d8rgTWm24awoi4b9RnSnl3U+mqmJAZux9Fw7RN8JHx1BF7vvLtT9f2eaNgO5/tgFWtiPOTyxFmevMiRSimlDLJJ+ITo2fZXJI8rvDof9GhxIiN7Qc9IJKZ8r8v0wstWIRoiPNUcXu0pAgY1V9vMcmeawfOMJHhw50Mf7sMSclYRImca/zcYg2fUPNuVlfb3Z+dfZP+8APY8ym91b1M7jV1mBcEY7F1nOdh9ApTG7qqloVa2ZwX4+zTgShmA861YuluEbVf7GFvKtsIHkecAv4gtNdJqINbBNzoS6JTKpzFt6eYgcCTLH5fZZoFPQIyihZVTF7dxn9hANHe8AU4pCBPb3Xm2y+/ILRHBM9Soytj9adELnqluxwFljoBs16lA82QJnRMsYbjJacSaDUOAOYpcfp6oTACwhqfWTzJy560TeFqLbyo9j4Wqo0H55P4EXOWpnhObKXn9VwtCdG5yMKmr1gmpKUpDUc7gi0ehKF9/RjyHKJlMbkYVSFeArjzKhwX8hds1II+LwalKcXrLjwOgLDU80tD8YbsoK+WUgxulUEz9FdJPJI90VLWZ7HHttBbWxFGXNq9XznNxEEpjF4VggfadbCIyb7o6BeInPKCKj7yBiFklQlyiZh3qBp6Qh7JDPymQif1pnZg4m/gFo18O6OSw/gbMcTPcbXVdxga68/VF2/+hApXV/4MujztG+6JcgfK
 SoGX+x/z
 bcD0T4R0J+igQ1uzoY/PRUkmxaUBrHiwlNRGZe5e8HTpgfkZKxYyLOC2Po5Q5j3pMKdg3t3TfOy8GNpNYd9tcLLXp1Z1PyQaO+fl2mjXvRwg9GfON5CM90E/qC/2l+REBnjo0Nc3COWosXb7gSi8uytRJbEJoaCqYqdyJ4hauVv6a581k2HRyZbW2NWhNduzerB5EsdTmk35mx+wJMvVAi2qmU9h4NqqABNqbaOBAAPcOWPbM6jG2YWK0R9aYOVXUZigRj8za2UchvMhnewA6PKL6cpXDULe3e0GPcDtyz5ak2n2oVRArmExXALivesauNd+xGksovx1LjBV/y3jLvW78cCooKEJHqvn3O7UMO/qAx7v94x49zRuXo4nu6E2yTPA+K7DaeiW1T+S6fKVqmPTKSWnpreYX9tIaEmSL2VSXjdJFKdmZZd4KyE8Z8IskqKoCMpeh4TlwzqYRL+l/7ML1BNuT/UVMU0t3yutNssotuhNv7t3EhyJ95rH0Zd8mdDdbYoxC/fpQp5Y2sJdvR7HYufLs7mx6Fp8a9Ad5qn921BeiroGKimrb80RATY8AGK13TNmaUtyaASNwx0m2fHdD26gQjWvxMqVQ04ykX/VHzFaM+pVLHRDJuQwYXF8X6UZvfExqCOgqEM6HXNCw+/Z/03mHN8B7hQEd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18/26 10:20, David Hildenbrand (Arm) wrote:
> Zapping PTEs in zap_pte_range() defers the TLB flush until after dropping
> the PTL for clean page-cache folios.
> 
> A concurrent write fault in a MAP_PRIVATE mapping can then CoW the
> page-cache folio and install a new anon folio without a prior TLB
> flush:
> 
> 	CPU0				CPU1
> 	LOAD(ADDR)
> 	 -> #PF
> 	    installs R/O PTE -> A
> 					fuse_open()
> 					 -> invalidate_inode_pages2()
> 					    -> zap_pte_range()
> 					       clears R/O PTE
> 					       // delayed flush
> 	// Other CPUs (incl CPU0) still cache ADDR -> A
> 	STORE(ADDR)
> 	 -> #PF
> 	    do_cow_fault()
> 	    copies A to B, installs R/W PTE -> B
> 	    // no TLB flush: PTE was none
> 
> CPUs with stale TLB entries will still read from the old folio while writes
> go to the new folio, until the TLB is flushed.
> 
> We really must process pending TLB flushes if we are not faulting the
> same folio back in.
> 
> Fix it by flushing the TLB before installing an anon (CoW'ed) folio in
> set_pte_range() if a TLB flush is pending. Zapping itself stays as fast
> as before.
> 
> Other faults are not affected: unmap_mapping_*() users only remove
> folios from the page-cache after their own TLB flush, so until then, a
> refault maps the same folio again. The exception is a concurrent
> invalidation that removes the already-unmapped folio from the
> page-cache before the zapper flushed the TLB; that is an unlikely corner
> case that we'll not handle for now.
> 
> Note that we don't care about MADV_DONTNEED followed by a new read
> fault, as MADV_DONTNEED only guarantees its semantics once the operation
> completed. CoW faults will flush the TLB either way.
> 
> For example, imagine that MADV_DONTNEED zaps a page-cache folio and
> doesn't flush the TLB (but still holds a reference). If the page-cache
> replaces the folio, a new read fault might map the new folio without
> flushing the TLB. That's okay, as MADV_DONTNEED did not complete yet.
> Same applies to MADV_DONTNEED of CoW'ed folios when re-faulting the
> page-cache folio.
> 
> Memory reclaim, which removes folios from the page-cache before performing
> its own batched TLB flush, will be handled separately.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Cenk Yılmaz <cenk@deepfinresearch.com>
> Debugged-by: Cenk Yılmaz <cenk@deepfinresearch.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/memory.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index d2f48d78b0d7b..e1d9759e6fde1 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5888,6 +5888,12 @@ void set_pte_range(struct vm_fault *vmf, struct folio *folio,
>  	/* copy-on-write page */
>  	if (write && !(vma->vm_flags & VM_SHARED)) {
>  		VM_BUG_ON_FOLIO(nr != 1, folio);
> +		/*
> +		 * Concurrent zapping might have dropped the PTL but not flushed
> +		 * the TLB yet. Flush before installing a new folio.
> +		 */
> +		if (mm_tlb_flush_pending(vma->vm_mm))
> +			flush_tlb_page(vma, addr);
>  		folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
>  		folio_add_lru_vma(folio, vma);
>  	} else {
> 



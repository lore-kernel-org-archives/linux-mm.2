Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DCFECD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 12:36:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62B316B0088; Fri, 29 May 2026 08:36:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DC676B0092; Fri, 29 May 2026 08:36:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F20B6B0095; Fri, 29 May 2026 08:36:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44D7E6B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:36:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E2C5A1C0024
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:36:28 +0000 (UTC)
X-FDA: 84820405656.05.DD6D65F
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8554EA000E
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:36:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jjsu6Mlv;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780058187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9lVmfgexspnKoW/3agaiDvDisr/iv75bUoYrdSLOXwE=;
	b=Ewz7SRv8WvhG9EgRMffveT9qZHASeyOlc0UCGPtqGhv81TT7k7r8T2R5JoNcGxkRglt8cH
	BSDhNLkCf8mjApDQeDWEVCB0khWfOe6f5zx9tCo5eMZLgyW5znJzo0sMwMoxljzTN03btT
	3DMPyHhkfkwYUJvCURMr9be6NdFI1QU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jjsu6Mlv;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780058187; a=rsa-sha256;
	cv=none;
	b=5TV1GPQROcX4xo048E54vm4OShSOIMalMgvKYc2ZaU4JWJKM0zOyJZ+w/kA/uCVAOgi3pj
	UILnQ1+gvYJke9A/CUQYNKbgDMXYAYwoWvTcStxkKgDi5FefzbuOvESV/6LDmQtfRBhsxJ
	9i6+7fPc8KZN17lnoRH/mSvdybZjYeg=
Message-ID: <fb47629e-6533-4c87-ac0b-e3a48a890ef4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780058181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9lVmfgexspnKoW/3agaiDvDisr/iv75bUoYrdSLOXwE=;
	b=jjsu6MlvrjBVw8EHwN0hZmMlYdVyXnIGj7OspJTJ4D6N+7yBnvman4zcAHpc1Ij97Gm08b
	r/smJSHm1710yMUCteZUE0tkdOltvNb2M1Yl3SZ4d9zzKBzaKOzUGwE6mp49+rBFiVdWRH
	JYU2SGHM12nodC78Fy/TqrlxlFyboI8=
Date: Fri, 29 May 2026 13:36:10 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v6 2/2] mm: use mapping_max_folio_order() for
 force_thp_readahead order
To: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 willy@infradead.org, ryan.roberts@arm.com, linux-mm@kvack.org
Cc: r@hev.cc, jack@suse.cz, Andrew Donnellan <andrew+kernel@donnellan.id.au>,
 apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 brauner@kernel.org, catalin.marinas@arm.com, dev.jain@arm.com,
 kees@kernel.org, kevin.brodsky@arm.com, lance.yang@linux.dev,
 "Liam R. Howlett" <liam@infradead.org>,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
 npache@redhat.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
 rppt@kernel.org, surenb@google.com, vbabka@kernel.org,
 Al Viro <viro@zeniv.linux.org.uk>, ziy@nvidia.com, hannes@cmpxchg.org,
 kas@kernel.org, shakeel.butt@linux.dev, kernel-team@meta.com
References: <20260528165635.2068012-1-usama.arif@linux.dev>
 <20260528165635.2068012-3-usama.arif@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260528165635.2068012-3-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: uajust1hk36d89e4pbe744i58mo3iube
X-Rspamd-Queue-Id: 8554EA000E
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780058185-427254
X-HE-Meta: U2FsdGVkX1/X6vtRa7hmWgqAoOZWJecfGIXbK/OKnzrKCGGdM7VLAJj7Cw6gQpRYxhydF8uByL/mMZvpA11G0Wmjhoi28FiZ7mRUGABRrA5wySq555HTiEUkLTZ7E6XqOiCtdFl/N+0+DXCuvPt3GJfVxEP3KzQPbj2hIlv33Cu/AltEurehYTfkhoMCb5LUTVcTM6AQ8sDzj0j96L2/uj8iQ0j0rLeLxgoIni4UupJbzX/g/AkYAv/4VMIuQaZgctFK88mCWo6EVqMRAA3RwrexjZnj8mwakr92Uxot8P0UWs6eIVXWbzxehL85T3tmXr2zoYr34t9rzRUB7Ln9tr1fjlF3eiWoggfywkbm+M27ahxuaL+klszqSCR6l11R0j9ls03HMq0BG0zNSTryQxRs3X+c1Ksu+fiuZN28V1Rc66VL+1MrXRIyHZAj33c3QoEi7BvF6drBrcBHsmVbjULX5HFYAg3zIoLO5xHhPOnVI36oGDQ01NOR2jg7u135MdAgWWiT88WhUL6/7qeqPuILcDOeEtp4mXfaLmncy6UQoh2Fc7f6gJ4kCqOBWKkwwMHrSOIGs2LEoOATs+jPC8o5T/7jMQFfF6sdjLvOncK1OHyaviYlNa2hfg7uFw9eBSy0+oXuL5iwd/K2XeJiKOGBLZUT8aa+Ar/wrc9nNX1E9UbCDqlVJJoFM8Cr1V3irovvl5Qttaxor5a919O9YZl3uujzire3dHylqXF3BA1aSLutOzKv0XSzPD5bDu8Sn2hehfozY4es5RcD839vg1xY8T331UF2tUJtKkvEKg7362u+XX118LTaHelw+zd/ZhhrFcBtEpFYsaO8r10GELPzY8d3VOs+DgjA+XMUQXY8SkuR1wHXzRHXmq+PrrOlA6PC9Xka/oSqVvytjpvi0BjW4eJKqyy3jcUKuG7+6plDG64t9QXn2LkXNpHHXE4B/FTUvcLJzXJDRlw1cVV
 /3++jHOh
 9E5/JwcQ9kHqJ0isLWGDi/fmoTHuWILLy03nnWHFdqc0fsnoCime5GKBUfNtMcPbx434UpIVEmkYW4f6b3Fa9MjPt+/2DkTy0vQhuFBbNwdegqrodjQQLtNiNWJOM3kCqcxEWG4SflEMRWfJfRPeR/cF7PQy8AnC4XOC2BvWsXBdOvN1l8WiFXC3roVh08BoaEO/6YoVyGL9pM/ZpB7QcBrYu5n71dzBLLHdreAeINo5S7DE5wqOiT0aHSySPNyTqaKHXcaxRmYFAAFXKmZj4NeQsSIrF2AT/jttZZgVg/vUIa00CJVkox/Pg6aPaUa5II2T8crAq9lPwGzLMAdnHPF/Lqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 28/05/2026 17:55, Usama Arif wrote:
> The force_thp_readahead path in do_sync_mmap_readahead() is gated on
> HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER and always requests
> HPAGE_PMD_ORDER / HPAGE_PMD_NR. On configurations where HPAGE_PMD_ORDER
> exceeds MAX_PAGECACHE_ORDER, notably arm64 with a 64K base page size,
> VM_HUGEPAGE mappings cannot use this path and fall back to the non-forced
> mmap readahead path even when the mapping supports useful large folios.
> 
> Keep the existing PMD-sized behavior when HPAGE_PMD_ORDER fits in the
> page cache. When it does not, enable forced readahead for mappings that
> support large folios and request an order capped by both
> mapping_max_folio_order(mapping) and 2MB.
> 
> 2MB is chosen as the cap because it matches the PMD size on x86_64
> and on arm64 with 4K or 16K base pages, so the size/memory-pressure
> tradeoff for folios of that size is already well understood. On arm64
> with a 64K base page size, 2MB is also the contiguous-PTE (contpte)
> block size, so the resulting folios coalesce into a single TLB entry
> and reduce TLB pressure on the readahead path.
> 
> The final allocation order may still be clamped by page_cache_ra_order()
> to the mapping and request geometry, but this gives VM_HUGEPAGE mappings
> on such configurations a large-folio readahead request instead of
> dropping back to base-page readahead.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/filemap.c | 27 +++++++++++++++++++--------
>  1 file changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index a16b33e0fc71..bfb891d9da1f 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3312,14 +3312,23 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>  	struct file *fpin = NULL;
>  	vm_flags_t vm_flags = vmf->vma->vm_flags;
>  	bool force_thp_readahead = false;
> +	unsigned int thp_order = 0;
>  	unsigned short mmap_miss;
>  
>  	ractl._max_index = vmf->vma->vm_pgoff + vma_pages(vmf->vma) - 1;
>  
>  	/* Use the readahead code, even if readahead is disabled */
> -	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> -	    (vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER)
> -		force_thp_readahead = true;
> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && (vm_flags & VM_HUGEPAGE)) {
> +		if (HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER) {
> +			force_thp_readahead = true;
> +			thp_order = HPAGE_PMD_ORDER;
> +		} else if (mapping_large_folio_support(mapping)) {
> +			force_thp_readahead = true;
> +			thp_order = min_t(unsigned int,
> +					  mapping_max_folio_order(mapping),
> +					  get_order(SZ_2M));
> +		}
> +	}
>  

I think might be good to include the below comment to explain the decision being made
here:

From 6673c04a434df01d449c1bdb9ac8de74e19d6b7e Mon Sep 17 00:00:00 2001
From: Usama Arif <usama.arif@linux.dev>
Date: Fri, 29 May 2026 05:31:05 -0700
Subject: [PATCH] [fixlet] mm/filemap: add comment explaining design decision

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/filemap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index bfb891d9da1f..0a3facf452b3 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3319,6 +3319,14 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 
 	/* Use the readahead code, even if readahead is disabled */
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && (vm_flags & VM_HUGEPAGE)) {
+		/*
+		 * Preserve PMD-sized readahead where it already fits in
+		 * the page cache. Otherwise cap the new fallback path at
+		 * 2MB: this is the common PMD-sized hugepage size, and it
+		 * avoids memory pressure from very large forced readahead
+		 * when mapping_max_folio_order() is high (for example,
+		 * 128MB with 64K base pages on arm64).
+		 */
 		if (HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER) {
 			force_thp_readahead = true;
 			thp_order = HPAGE_PMD_ORDER;
-- 
2.53.0-Meta




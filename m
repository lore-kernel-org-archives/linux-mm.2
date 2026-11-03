Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 514E8606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 09:11:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B9C76B05B2; Tue,  3 Nov 2026 04:11:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3789D6B05B4; Tue,  3 Nov 2026 04:11:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28F036B05B5; Tue,  3 Nov 2026 04:11:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D55936B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:11:56 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 79BDD4036A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:11:55 +0000 (UTC)
X-FDA: 85393240590.17.574358B
Received: from mta0.migadu.com (out-89.mta0.migadu.com [91.218.175.89])
	by imf02.hostedemail.com (Postfix) with ESMTP id C45E580006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:11:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hWhGAMYn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.89 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793697113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L/rwbEY90TsE31orsIbmoYEBsIiiZzgORGDGsve2QT0=;
	b=gfJrA+VdGXIMj3OQxibh1FHHcHKJMk097CZmfGRpe2AXeNkQSNObZRrStT8Pa9lL3sSatC
	kGz3b67dRsvoo57nWDXdsQJIIXmdq8hzhRrZZAsuwcsCLl4MPPTg/JmSQV90jo9d0ci0vd
	M8u4ME6FjOQSPz9QdT0mNDWZUxF1cqY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hWhGAMYn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.89 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793697113;
	b=Jy8ZAIEWBlKoCjdQQl5KkTWySLUxu698hlOM9M3xtuyUf0TBVrTowHGiUbbS0G97RGO10q
	v9/wRyo33P2ZEEV6HU/1nXEuXdW5tjUaeyAU0IP3dBoF0XuBwV9wOmUK/CfkHnh/aS+MEn
	nIo91/rPDuafqlSnD2TfJZ6hZKNvkJc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4izyozmbuMGIzwBXwOGfCjpLSN/9aWgvEh8DalxY9c8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793697108; v=1; x=1794301908;
 b=hWhGAMYnBWhe3NfVoxNafdUdTJ1qC/oGhHK7lSWu2kfOXs8GDMfIUqyVR+Zar7r+naniL2DB
 Y3XdksAVun3fVK6BXo5jmmq7slXW+o+6OuNAlthBKQlgPdr1v4kmMszOtXoaLlp1xSfQS0O/XAI
 Ph57qygITpzKfnDJXgJwcRrw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 736b6edb0d423b19;
	Tue, 03 Nov 2026 09:11:48 +0000
X-Mizu-Trace-ID: 736b6edb0d423b19
X-Migadu-Flow: FLOW_OUT
Message-ID: <d9ebae9f-7a3e-412f-bb1c-f753b83ede59@linux.dev>
Date: Tue, 3 Nov 2026 17:11:39 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm: hugetlb: skip CMA when direct reclaim is
 disallowed
To: sashiko-reviews@lists.linux.dev, muchun.song@linux.dev,
 osalvador@suse.de, david@kernel.org, akpm@linux-foundation.org,
 azpijr@gmail.com
Cc: linux-mm@kvack.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1793692578.git.zhengqi.arch@bytedance.com>
 <325d33655f29a2799a0859c788c48625feeb85f1.1793692578.git.zhengqi.arch@bytedance.com>
 <sashiko-outbox-194875@kernel.org>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <sashiko-outbox-194875@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C45E580006
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ah7qyhqz1tcoffauctty8sefwhu3s1yg
X-HE-Tag: 1793697111-499014
X-HE-Meta: U2FsdGVkX18NWL8xEtFy/wwKFJDtiLOMeRiKoGWRs4mwPvfNPbe2U3NFZgFOkoP/CMpsehEdyg3wG3MOFWPsOo3WakVCArjMqwAdCGmPvRR5sctpOKtAN2GrkFz2xRPQJZ4RdfO5zC2umEaLh1r1DYUrCSCvhPPG+8i04d6WQ+9RWICgDPc/inhGQUw/+c4SKwckp/sWT1UuClJ5Z2/0Z4OiX9RRIWz3ddx9fZEyTVFqkWyQbXaxja+TPZKkYJq/GjGVmUqJEbiJ6ZKCr2TKa+VEZXAukCJFw8LjS14sqf+0IFXVeZLsMoU3TRGs7NT/ffzLGORGXXEdkzIXObRqfpahc6fQffhAGBz9pGJpYoefXeeyVYeAj+Lgsk67j9G25WfhYYuEWj2D+S1Zx8evmxEEhIP/Cc+08ghJu9eIasqBU7fJPCSlPLYtBMuwAy3QimPbSfGsHfKrSWCcl47DMHOiRL9zrpAaTxfRSfNBa9HMY6AZ0x/bx5WUSgI4u+E4cLLFh1v7kApIw/TnXMu4B5ZMdQYsSWae8IMxJuXzJKwYJ6HFJM0cnZpJIfColCEKY3iEkwmWAnhSnyOa7J20luFjw8zgPihM5euQGhIxTnBIZgezANjZ62eMNGZ8AspNdVNpGAwAsC24xuSmLt7CGA8GmmjQ1IuOUKiYVy6/VW38ib3ZVxPtMSgm89AmeTI0Yj5xkc0LNEy82yHCJVUIaFkjS79ffsdy1cem41BoDrI+/IKg8sGz6iSGoXLPdnJq/k6a/MOS6uLLFYCTpRwkO5QqA4Xg7RyFRvJn5sgkxidNbN2VEOXhbrvuck5xYu8k9AgD9P/ifGQYffHtYMzsCDCrLxfMx6FHY0JWUhvtgOsIEzElhZXD4yyfnPZDfbSpOC63NsI8/wjUV7zgMHVq7TPMtubGmG9cjDMoBvksf8hWqtp6BSmac45Y8zcVETqr05WCHisqDsCAYN3KlLM
 5+0mL3pl
 9ENRqKo8/vhviRgUN38Ivl7354pIpq6vWkv/qkE4/hNvcmoWn/jlYy0wEP6OUok5y1nrbVgYJQqMacqc6mB/tbjcxYCDhw6+1U6R6zKVS+BxioU+Ipm/uk8GHydiM0naK5ec4Du2WiGNMqC3Zzkbn0v55CHSm3981DKUtHCjJ29yD0kmCqle0QVCr7g7I2mHvb4ym6vprSXH0+fpARng18xYl75TrP+M2pkv0nCaae+j803F/I9Yhb/Csj3H/75UKdXxST0jhv7ezFEw7BMneEdaId5xVs3PqmXg+kzjo88IoSqY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/3/26 4:47 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] mm: hugetlb: hugetlb_cma_alloc_frozen_folio() breaks MPOL_PREFERRED_MANY
> --
> 
> commit c96d52d66d643a77abaa96a17e392b7ab0f36ccd
> Author: Qi Zheng <qi.zheng@linux.dev>
> 
> mm: hugetlb: skip CMA when direct reclaim is disallowed
> 
> This commit updates hugetlb_cma_alloc_frozen_folio() to return NULL when
> gfpflags_allow_blocking(gfp_mask) is false, avoiding direct reclaim inside
> cma_alloc_frozen_compound() when __GFP_DIRECT_RECLAIM was cleared by the
> caller.
> 
>> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
>> index dde1c866406fb..90f8d718a1f16 100644
>> --- a/mm/hugetlb_cma.c
>> +++ b/mm/hugetlb_cma.c
>> @@ -59,7 +59,7 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
>>   	const nodemask_t *nmask;
>>   	unsigned int cpuset_mems_cookie;
>>   
>> -	if (!hugetlb_cma_size)
>> +	if (!hugetlb_cma_size || !gfpflags_allow_blocking(gfp_mask))
>>   		return NULL;
> 
> [Severity: Medium]
> Does returning NULL from hugetlb_cma_alloc_frozen_folio() whenever
> !gfpflags_allow_blocking(gfp_mask) break MPOL_PREFERRED_MANY for gigantic
> surplus HugeTLB allocations?
> 
> In mm/hugetlb.c, alloc_buddy_hugetlb_folio() implements MPOL_PREFERRED_MANY
> as a two-pass allocation:
> 
> mm/hugetlb.c:alloc_buddy_hugetlb_folio() {
> 	if (mpoli->mode == MPOL_PREFERRED_MANY) {
> 		gfp_t gfp = gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
> 
> 		folio = alloc_surplus_hugetlb_folio(h, gfp, mpoli->nid,
> 						    nodemask);
> 
> 		/* Fallback to all nodes if page==NULL */
> 		nodemask = NULL;
> 	}
> 
> 	if (!folio) {
> 		folio = alloc_surplus_hugetlb_folio(h, gfp_mask, mpoli->nid,
> 						    nodemask);
> 	}
> }
> 
> This reaches hugetlb_cma_alloc_frozen_folio() via:
> 
>    alloc_buddy_hugetlb_folio()
>      -> alloc_surplus_hugetlb_folio()
>        -> alloc_fresh_hugetlb_folio()
>          -> only_alloc_fresh_hugetlb_folio()
>            -> alloc_gigantic_frozen_folio()
>              -> hugetlb_cma_alloc_frozen_folio()
> 
> On the first pass, __GFP_DIRECT_RECLAIM is cleared while nodemask points to
> the preferred nodes (pol->nodes), and on the second pass nodemask is cleared
> to NULL. Because hugetlb_cma_alloc_frozen_folio() now returns NULL on the
> first pass, it never sees the MPOL_PREFERRED_MANY nodemask.
> 
> In mm/hugetlb.c:alloc_gigantic_frozen_folio():
> 
> 	folio = hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, nodemask);
> 	if (folio)
> 		return folio;
> 
> 	if (hugetlb_cma_exclusive_alloc())
> 		return NULL;
> 
> 	folio = (struct folio *)alloc_contig_frozen_pages(1 << order, gfp_mask,
> 							  nid, nodemask);
> 
> When hugetlb_cma_exclusive_alloc() is false, returning NULL from
> hugetlb_cma_alloc_frozen_folio() on the first pass falls through to
> alloc_contig_frozen_pages() on the preferred nodes, bypassing the dedicated
> hugetlb_cma pool on the preferred nodes in favor of non-CMA memory.
> 
> When hugetlb_cma_exclusive_alloc() is true (or when non-CMA allocation fails
> on the preferred nodes), the first pass returns NULL and the second pass
> invokes hugetlb_cma_alloc_frozen_folio() with nodemask set to NULL. Since
> mm/mempolicy.c:policy_nodemask() leaves *nid as numa_node_id() when
> pol->home_node is NUMA_NO_NODE:
> 
> mm/mempolicy.c:policy_nodemask() {
> 	case MPOL_PREFERRED_MANY:
> 		nodemask = &pol->nodes;
> 		if (pol->home_node != NUMA_NO_NODE)
> 			*nid = pol->home_node;
> 		break;
> }
> 
> hugetlb_cma_alloc_frozen_folio() on the second pass tries
> hugetlb_cma[numa_node_id()] and then iterates cpuset_current_mems_allowed
> from node 0, allocating from non-preferred CMA nodes even when preferred
> nodes in pol->nodes have free CMA pages.
> 
> Prior to commit 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()"),
> cma_alloc_folio() forwarded gfp_mask down to alloc_contig_frozen_range(),
> where __alloc_contig_verify_gfp_mask() preserved the cleared
> __GFP_DIRECT_RECLAIM bit so CMA on the preferred nodemask was tried on the
> first pass without entering direct reclaim. Would forwarding gfp_mask to

Thanks for catching this. You're right: in CMA-only mode, this check
skips the preferred-node attempt entirely. The fallback can then
allocate from a non-preferred node even when the preferred nodes have
usable CMA memory.

> cma_alloc_frozen_compound() (in mm/cma.c) preserve both the non-reclaiming
> first pass and the MPOL_PREFERRED_MANY nodemask?

Make sense.

I'll replace the check with GFP-mask propagation through
cma_alloc_frozen_compound(). This restores the preferred-node CMA
attempt while preserving the caller's __GFP_DIRECT_RECLAIM setting.

Like the following:

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 8555d38a97b1..caedd59bde03 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -53,7 +53,8 @@ extern bool cma_release(struct cma *cma, const struct 
page *pages, unsigned long

  struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
  		unsigned int align, bool no_warn);
-struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int 
order);
+struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order,
+				       gfp_t gfp);
  bool cma_release_frozen(struct cma *cma, const struct page *pages,
  		unsigned long count);

diff --git a/mm/cma.c b/mm/cma.c
index a10ea37a261d..c2605967d77a 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -929,9 +929,10 @@ struct page *cma_alloc_frozen(struct cma *cma, 
unsigned long count,
  	return __cma_alloc_frozen(cma, count, align, gfp);
  }

-struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order)
+struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order,
+				       gfp_t gfp)
  {
-	gfp_t gfp = GFP_KERNEL | __GFP_COMP | __GFP_NOWARN;
+	gfp |= __GFP_COMP | __GFP_NOWARN;

  	return __cma_alloc_frozen(cma, 1 << order, order, gfp);
  }
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 90f8d718a1f1..250b5c10d954 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -59,7 +59,7 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int 
order, gfp_t gfp_mask,
  	const nodemask_t *nmask;
  	unsigned int cpuset_mems_cookie;

-	if (!hugetlb_cma_size || !gfpflags_allow_blocking(gfp_mask))
+	if (!hugetlb_cma_size)
  		return NULL;

  	if (current->flags & PF_MEMALLOC_PIN)
@@ -74,14 +74,16 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int 
order, gfp_t gfp_mask,
  	}

  	if (hugetlb_cma[nid] && node_isset(nid, *nmask))
-		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
+		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order,
+						 gfp_mask);

  	if (!page && !(gfp_mask & __GFP_THISNODE)) {
  		for_each_node_mask(node, *nmask) {
  			if (node == nid || !hugetlb_cma[node])
  				continue;

-			page = cma_alloc_frozen_compound(hugetlb_cma[node], order);
+			page = cma_alloc_frozen_compound(hugetlb_cma[node], order,
+							 gfp_mask);
  			if (page)
  				break;
  		}

Thanks,
Qi

> 



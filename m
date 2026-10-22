Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40DAF606A321
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 06:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XXLTTM3D
Received: by kanga.kvack.org (Postfix)
	id 0AAE36B08A6; Thu, 22 Oct 2026 02:24:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05AF46B08A8; Thu, 22 Oct 2026 02:24:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB38C6B08A9; Thu, 22 Oct 2026 02:24:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE91B6B08A6
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:24:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4C73840556
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:24:16 +0000 (UTC)
X-FDA: 85349272512.01.024979D
Received: from mta0.migadu.com (out-131.mta0.migadu.com [91.218.175.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 162D2C0004
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:24:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XXLTTM3D;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.131 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792650254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NyrZtijtyGTQPq4lZyx+gSPus8J8tZcRW7L4bdstfYA=;
	b=u+HRAjI8B6im6/WbsPg5gvleIYRPNLjSLQ8OTGDRgpuxfKcupVJpgsW0jxY/V52x0n3AA7
	pVN5Jm5lmguRNjsHkzstCG25c9jim0nSMB2Zh4yWgqMG6NpjNykQ8qZ4NAEtckX142Q89D
	X70WJlainVQlrhKnKJxa7DAsOBBnSIw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XXLTTM3D;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.131 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792650254;
	b=Ylcwh5Is1g9KXqbvvlM9ArHOsCWKZMfNnmxOiOCWHeGACc0celb0Oju82nDhXKPxyiKBhW
	BFGW5zil9N7YNctTUWn/8Gl4i408Q0PMWQJW7QVjM/WYPUSt9LuF8z3MjvVM6jaTc43jyn
	cTHOwSlCWyBOXsvLrPAboY/5j9eUcqY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0zr077h6eg8GG3MPE83DyOxebLzAcrGd6CAuktOVwoA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792650252; v=1; x=1793255052;
 b=XXLTTM3DTVlB/dRJOBlmhavo5YA9IomhysFwM5JI0srZOJAGfSSNqvAZOP2W+zbvyPsRHkP1
 LY6EsFg9HnihSidEcv+kgMNUEA7SaHKdlg2iPtLvjh2e1IN+4lwsuG2mPQhAVurrqSSj3sd2YoG
 guk3+hYDU2H+qg5YsMuDfHd4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ed6f83f251452fba;
	Thu, 22 Oct 2026 06:24:12 +0000
X-Mizu-Trace-ID: ed6f83f251452fba
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: osalvador@suse.de,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	lance.yang@linux.dev,
	jthoughton@google.com,
	david@kernel.org,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/12] mm: hugetlb_vmemmap: simplify vmemmap head page handling
Date: Thu, 22 Oct 2026 14:24:01 +0800
Message-ID: <20261022062401.62096-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261020115824.823278-2-songmuchun@bytedance.com>
References: <20261020115824.823278-2-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 162D2C0004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: zarkaqrtco8ah1af8hw18yw9jau8rb8s
X-HE-Tag: 1792650253-609343
X-HE-Meta: U2FsdGVkX189TE5NtdbkaM+dpUalJKl/WHyxD+/Yx3+QbJQcGaqprlPBk16+JxunIQuleQ51BDWk6mtfLRz8EDh+5INFtwDNFRax81VFCCKc3mmoeYsGsZi+F/c7TbSJm6/ljlih5r3/wdybNPfHv1r4K70WFmukO4+fuUwqNUOOJVS5MQaiR8LAalcmTY3Hh372YqOUWWyGyIhCidCVmxAG4+m4NLS5vy6vVFzhgwXonFDwg0cDbUgOb2XrdfISpTwuQRUWqVeufLFAaXzbuAFxoSeUwINV3sOw2Y+8ne1+LMXPJzkPfpylfpwn2nfSpOq0W6/bg1G+OHKZ8kbFWwMe4J/HjUvznrIp+sjM3FBM2vhD4NJlhTI70HTfV3WaEyhrVTPQL/OVGGY1QcOLtgnPMF7H5a22BsA/yQbsDlNStay+Ee1XHhy6ZLLPQ8awezM+RmQecjOWJ1i4kgn4qiV4p1hTeJzJFCwiUOp6S5+kC6ueK5h1a8BwZ8DgJfVVlMhyETj/2eqc6ORyvsKtquEA+5tvDroXccjcHQg0BUA2AmqEOY9XQ5oDLzKRLfLUwK+KZgwaHq7STV8kbvS5u1SrKryvt1aSk7K3ms2jAW3iIGNgoLfVCg8W2EtqsW+cIafOgCTXjnSlnvuau+NxN8JAA7aKYSocihthRZWfQsvY8zbGu5yxZCGCfMCZsRSd+6HLQSMoGiDMRIpJnEjS5vfiDSsuNE1ci/sZqgVKpoGhowGjd7P4qSO0lDSS/7e2D2Et0U/R8xHfG1cLCSrSUUjlMIFSnLGcw8Rqb5bdblKgz034WI4vtfrI1qko+n09cAKxiK2TSUliZwYQiDFY8KoaQLVrr6MQX6bz4pkn3qc+U4E9zxonxnKwS+wOeVP/1Dd+lF3Gf8ZIPvqlyF4jby5YJ+DggVun4GxVcvx9AkV36dEnUYmqAMuTcPS5SJPM3CCZ0FLIVcOJVCsn6rL
 QzFyjbe5
 w+5ZGBYkz/gI1GfVqq86+cHyS5apjsRvaTg9CvGkzSwTMBsaetRybCHgorBI+7HDghLb/YrOZw3J4tE+b06x2byt/0lOAvy3F2tdU8i3WK8qlAdZVa3WsFHfXuj+E59NsbVGsJaAbHMhKXzT0xz880GPc172ylfKU4JxDdcv1gdRyGRkgwk4B9d/Dsg0UMIFz/e8EOdIHszlDDKTwbJ/58uL5ggkoDc1T+Y1LVaaBxKkqCErxAnIelChH1Pm5lIHzoDWJGUdHWX5bQFg06KeICJtzyUSVCWs8IqXpb5AhN2BTNssk+gcPlHw06g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Tue, Oct 20, 2026 at 07:58:15PM +0800, Muchun Song wrote:
>The new head page is already tracked on the vmemmap page list before
>remapping starts.  Passing it separately gives the remap walker two
>ways to refer to the same page and unnecessarily complicates its
>interface.
>
>Use the page list as the single handoff mechanism for the head page,
>removing the redundant state from the walker.
>
>No functional change intended.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>---
> mm/hugetlb_vmemmap.c | 17 +++++++----------
> 1 file changed, 7 insertions(+), 10 deletions(-)
>
>diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>index 8b3abb562599..164e93e980bf 100644
>--- a/mm/hugetlb_vmemmap.c
>+++ b/mm/hugetlb_vmemmap.c
>@@ -25,7 +25,6 @@
>  *
>  * @remap_pte:		called for each lowest-level entry (PTE).
>  * @nr_walked:		the number of walked pte.
>- * @vmemmap_head:	the page to be installed as first in the vmemmap range
>  * @vmemmap_tail:	the page to be installed as non-first in the vmemmap range
>  * @vmemmap_pages:	the list head of the vmemmap pages that can be freed
>  *			or is mapped from.
>@@ -37,7 +36,6 @@ struct vmemmap_remap_walk {
> 					     struct vmemmap_remap_walk *walk);
> 
> 	unsigned long		nr_walked;
>-	struct page		*vmemmap_head;
> 	struct page		*vmemmap_tail;
> 	struct list_head	*vmemmap_pages;
> 
>@@ -208,10 +206,13 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
> 	pte_t entry;
> 
> 	/* Remapping the head page requires r/w */
>-	if (unlikely(walk->nr_walked == 0 && walk->vmemmap_head)) {
>+	if (unlikely(walk->nr_walked == 0)) {
>+		struct page *head;
>+
> 		VM_WARN_ON_ONCE(!PageHead((const struct page *)addr));
> 
>-		list_del(&walk->vmemmap_head->lru);
>+		head = list_first_entry(walk->vmemmap_pages, struct page, lru);
>+		list_del(&head->lru);
> 
> 		/*
> 		 * Makes sure that preceding stores to the page contents from
>@@ -220,7 +221,7 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
> 		 */
> 		smp_wmb();
> 
>-		entry = mk_pte(walk->vmemmap_head, PAGE_KERNEL);
>+		entry = mk_pte(head, PAGE_KERNEL);
> 	} else {
> 		VM_WARN_ON_ONCE(!PageTail((const struct page *)addr));
> 
>@@ -289,7 +290,6 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
>  *		to remap.
>  * @end:	end address of the vmemmap virtual address range that we want to
>  *		remap.
>- * @vmemmap_head: the page to be installed as first in the vmemmap range
>  * @vmemmap_tail: the page to be installed as non-first in the vmemmap range
>  * @vmemmap_pages: list to deposit vmemmap pages to be freed.  It is callers
>  *		responsibility to free pages.
>@@ -298,7 +298,6 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
>  * Return: %0 on success, negative error code otherwise.
>  */


/**
 * vmemmap_remap_free - remap the vmemmap virtual address range [@start, @end)
 *			to use @vmemmap_head/tail, then free vmemmap which
 *			the range are mapped to.

Nit: could you update the @vmemmap_head/tail comment too, now that the
head argument is gone?

Nothing jumped out at me, so

Reviewed-by: Lance Yang <lance.yang@linux.dev>


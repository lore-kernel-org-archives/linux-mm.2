Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2ED8CAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 11:52:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26BD78E0007; Tue, 23 Sep 2025 07:52:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21BEA8E0001; Tue, 23 Sep 2025 07:52:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10B488E0007; Tue, 23 Sep 2025 07:52:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECB4B8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:52:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 88604140469
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:52:19 +0000 (UTC)
X-FDA: 83920351998.08.8B210FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4DE138000A
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:52:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758628337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dCAeTeEvIUB7QGUD1yNdtHVyxv+RYozjlDTLNDKvTQA=;
	b=QkSLPnLtGyPQjq3zOpqxYScl2AuqyvGLUVcMOT4z8pQkJ4lrAALQRUtvx14lCvGE6xa5IQ
	8w6ZlPVsSnaHq8z3ZaNPDgsB8g7vE/IQM/aHt/BbQc4nJA2hfaH3QaJOCWyuV+J+Hu3ok5
	4ePJVy1YQ+6OxNqm0AeSQPwBwmCqpLU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758628337; a=rsa-sha256;
	cv=none;
	b=J6Y4OP47uKcQPAEqqTKRJPqhfI61IojzJ3QR5LahAlCSjY1gEQs98K5bYpPjqj5VZvuVL3
	0uc41Q7/Gxr8nGNhhZYvj6o3ZDbiYIJc6XfrSZUG8nL5lTyBb3wgb0Fzaio979V++H6E5+
	68zJO4ytuonBV31OWeJlY/20ZXx4S0k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D922043D39;
	Tue, 23 Sep 2025 11:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2910BC4CEF5;
	Tue, 23 Sep 2025 11:52:09 +0000 (UTC)
Date: Tue, 23 Sep 2025 12:52:06 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: David Hildenbrand <david@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, usamaarif642@gmail.com,
	yuzhao@google.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	baohua@kernel.org, voidice@gmail.com, Liam.Howlett@oracle.com,
	cerasuolodomenico@gmail.com, hannes@cmpxchg.org,
	kaleshsingh@google.com, npache@redhat.com, riel@surriel.com,
	roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com,
	dev.jain@arm.com, ryncsn@gmail.com, shakeel.butt@linux.dev,
	surenb@google.com, hughd@google.com, willy@infradead.org,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, qun-wei.lin@mediatek.com,
	Andrew.Yang@mediatek.com, casper.li@mediatek.com,
	chinwen.chang@mediatek.com, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-mm@kvack.org, ioworker0@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/thp: fix MTE tag mismatch when replacing
 zero-filled subpages
Message-ID: <aNKJ5glToE4hMhWA@arm.com>
References: <20250922021458.68123-1-lance.yang@linux.dev>
 <aNGGUXLCn_bWlne5@arm.com>
 <a3412715-6d9d-4809-9588-ba08da450d16@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3412715-6d9d-4809-9588-ba08da450d16@redhat.com>
X-Rspamd-Queue-Id: 4DE138000A
X-Rspamd-Server: rspam05
X-Stat-Signature: bfybcq57bwmik7kdttpf1oz31bysxes6
X-Rspam-User: 
X-HE-Tag: 1758628337-554411
X-HE-Meta: U2FsdGVkX18kdaUTwq9ioZ11CsaOC4iUw5YjCfWHYBi4vasHxdjtmcJgSq4j6NLYtLHuJryzML8uwvb0ZBihj4UpQ5xdrr1lVwTdtemnXZ0Mvn5i2ozieZx4bNeneyccGO7k5dqcW7N/wX8O9Cc6CflgPwA54a6U7v8i0F0gcOy8LrELMa7mEf/OpmCLBzqpuD48f249NRJpWTTZjB6RMwWiHDvySM0be5BRE/1Xc+Elz1CFYSWd4hK5cAMASQbIBI0/uUwLfShhgSPzy7F0xtV61ei/Dy1uRyRpsu6DfsmKr62PClfgWOLMMIjHorLOTC9hKYagoUK5AUnWZuiWG0hdB56jXBVNzUaQPYc6ZpN794BMLJvSdX8gdp3xtRvd8vmSRPak2TQxKQoOTLtlEy5QabPD+PFU/noRoWJxB5W5y/IVa4H0VCpErqn+nRb1tgNmH8RxH7zfZ29+kOBkspTSSHV/PVN16Dr4PZs9qhMvoQoTqgx5iDRzNyJCWCRk4iBItG4RR3XjByr9jBYt68ljrOw6wvvI0wuh5AscRE2V9gz9ySD/psXYyszQNptycV1dvQ9Y/UzQYCKDMch14qMPzHehMES0HHdswc2QRBQ77/wukLyPgCvibVyWDwqtbd5zwpIN+KxGv8w9v6yOXKX8bwcBCGNMBRA4CVPTzYbvfMpAzs3WkTiguPrgZtzeJz35Wt68hBhewUgyNqTXSonEeaQXb/LH0VSuJZJ7QmtV4yh/JKRc4lQzCFEhMN6IGRbfF+rjgNSoUhwjdrxbvhwV17u8SSH6OaTjHKOvSPt+i53g+7ZvwUzJCJ9AcSR53wMS5lMk5Phw6QEYin5ObKsJm6z6U9rIKqHeYt+8YlRe5M9e92cEKhWt4iWpuQ9SN3kC5WXZkPcueSvEJz0KpKN/vDKDk7PGzEekouvi6hymVwuyF50Pk37reI/TbzCsbJDr5jqYLmWtjteeJD6
 Qg2GODVa
 nryr3bhSzI0vo7ux8NVTO7mUcyuY2jt+1RqpSrqq9SgG86qRHyWCZF+dnTF4cmLk+81wkWbDP+pGwXoq7omMxsrwLqe7gtckDFGPONA6eWFFYIZEfHCxA7Z6n0+THPoKiZA6HDIHffqzMsmG6OvyD37mffmRksFsj3AigGKNC9aR/QO+NBirt5qBE3+LAY37by2LM4QP+O6xV49jPJeIWui3ZmrJ2Cw104gR1jAKj+8aqwwGpRMtCptr8weQsRodeX1Dqbc6cjhz3Fuw85jgBdwTO+/tlsLGAuahM+nuodzazakB2JG1tGeReewm9dSsADz/1UkiC7BwDbDeOgZiDp9dhgM38ufBP53qthfxkcKtETXbx6473gdAuHoCtDJacapOKSHBvE9QkSR5ylXSiLw0AkGskErJbKU87
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025 at 07:59:00PM +0200, David Hildenbrand wrote:
> On 22.09.25 19:24, Catalin Marinas wrote:
> > On Mon, Sep 22, 2025 at 10:14:58AM +0800, Lance Yang wrote:
> > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > > index 32e0ec2dde36..28d4b02a1aa5 100644
> > > --- a/mm/huge_memory.c
> > > +++ b/mm/huge_memory.c
> > > @@ -4104,29 +4104,20 @@ static unsigned long deferred_split_count(struct shrinker *shrink,
> > >   static bool thp_underused(struct folio *folio)
> > >   {
> > >   	int num_zero_pages = 0, num_filled_pages = 0;
> > > -	void *kaddr;
> > >   	int i;
> > >   	for (i = 0; i < folio_nr_pages(folio); i++) {
> > > -		kaddr = kmap_local_folio(folio, i * PAGE_SIZE);
> > > -		if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {
> > > -			num_zero_pages++;
> > > -			if (num_zero_pages > khugepaged_max_ptes_none) {
> > > -				kunmap_local(kaddr);
> > > +		if (pages_identical(folio_page(folio, i), ZERO_PAGE(0))) {
> > > +			if (++num_zero_pages > khugepaged_max_ptes_none)
> > >   				return true;
> > 
> > I wonder what the overhead of doing a memcmp() vs memchr_inv() is. The
> > former will need to read from two places. If it's noticeable, it would
> > affect architectures that don't have an MTE equivalent.
> > 
> > Alternatively we could introduce something like folio_has_metadata()
> > which on arm64 simply checks PG_mte_tagged.
> 
> We discussed something similar in the other thread (I suggested
> page_is_mergable()). I'd prefer to use pages_identical() for now, so we have
> the same logic here and in ksm code.
> 
> (this patch here almost looks like a cleanup :) )
> 
> If this becomes a problem, what we could do is in pages_identical() would be
> simply doing the memchr_inv() in case is_zero_pfn(). KSM might benefit from
> that as well when merging with the shared zeropage through
> try_to_merge_with_zero_page().

Yes, we can always optimise it later.

I just realised that on arm64 with MTE we won't get any merging with the
zero page even if the user page isn't mapped with PROT_MTE. In
cpu_enable_mte() we zero the tags in the zero page and set
PG_mte_tagged. The reason is that we want to use the zero page with
PROT_MTE mappings (until tag setting causes CoW). Hmm, the arm64
memcmp_pages() messed up KSM merging with the zero page even before this
patch.

The MTE tag setting evolved a bit over time with some locking using PG_*
flags to avoid a set_pte_at() race trying to initialise the tags on the
same page. We also moved the swap restoring to arch_swap_restore()
rather than the set_pte_at() path. So it is safe now to merge with the
zero page if the other page isn't tagged. A subsequent set_pte_at()
attempting to clear the tags would notice that the zero page is already
tagged.

We could go a step further and add tag comparison (I had some code
around) but I think the quick fix is to just not treat the zero page as
tagged. Not fully tested yet:

diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index e5e773844889..72a1dfc54659 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -73,6 +73,8 @@ int memcmp_pages(struct page *page1, struct page *page2)
 {
 	char *addr1, *addr2;
 	int ret;
+	bool page1_tagged = page_mte_tagged(page1) && !is_zero_page(page1);
+	bool page2_tagged = page_mte_tagged(page2) && !is_zero_page(page2);
 
 	addr1 = page_address(page1);
 	addr2 = page_address(page2);
@@ -83,11 +85,10 @@ int memcmp_pages(struct page *page1, struct page *page2)
 
 	/*
 	 * If the page content is identical but at least one of the pages is
-	 * tagged, return non-zero to avoid KSM merging. If only one of the
-	 * pages is tagged, __set_ptes() may zero or change the tags of the
-	 * other page via mte_sync_tags().
+	 * tagged, return non-zero to avoid KSM merging. Ignore the zero page
+	 * since it is always tagged with the tags cleared.
 	 */
-	if (page_mte_tagged(page1) || page_mte_tagged(page2))
+	if (page1_tagged || page2_tagged)
 		return addr1 != addr2;
 
 	return ret;

-- 
Catalin


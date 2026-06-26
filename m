Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55E1BCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 07:49:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04A526B0005; Fri, 26 Jun 2026 03:49:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3D026B0092; Fri, 26 Jun 2026 03:49:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2C906B0093; Fri, 26 Jun 2026 03:49:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ABFE16B0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 03:49:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4A9401203B6
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 07:49:18 +0000 (UTC)
X-FDA: 84921288396.18.59D5F50
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1A9DB140008
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 07:49:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H35J3o1t;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782460156;
	b=iV9GdIK3ybLt3MnCDq/YoviUS4tZgDJCI5VujMSs6V8lrFUioCOrXMy1sYIZVgJ2TAqJml
	Z9tXqFzS2bLbGdEgfSFlKqj1P7oFhwKXXNq8GTD/w7gaRn11vRg9gcKD66nub9ThvZ8EGf
	MMkRe5lMUOPBmH3SK7fywS9FeFgYDkE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782460156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Saw4kFCjm19eZ20/zw2nrOG00PSR+Clz1dVZWS52fs=;
	b=Hk7rFaadVoX4lR/atA0LKP7bUhTWvOaH6JlWdO74ox7OaFNzEoIrVsPD1IOaRhlSkOnYpc
	eYarFEbGxaKdsuCCo2yyOuz+ex28mGfHBHEj8b8MGmTerc40OcIAiaa5zKSmB3WrofWr5G
	fA3HNvwpCq7Xpw6SRErniEwKnmzBVjo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H35J3o1t;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782460153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Saw4kFCjm19eZ20/zw2nrOG00PSR+Clz1dVZWS52fs=;
	b=H35J3o1t13TjTi237Lp3SqddEjsRv4f4RSM+qpBCWodWmTU01xwsDYze/P7OXfzjcf8x2g
	L7azLrthFwB7ZdhxgEggy38cPs2ercxpdv9beZWDVQANtMSOQiQChT4wFBsUqAUhMh2/tR
	dSogqoEyYVbj2LI7Bo0ef8Z4euSG7cs=
From: Lance Yang <lance.yang@linux.dev>
To: dev.jain@arm.com,
	linmiaohe@huawei.com
Cc: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	david@kernel.org,
	liam@infradead.org,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	kas@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rcampbell@nvidia.com,
	apopple@nvidia.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	mel@csn.ul.ie,
	nao.horiguchi@gmail.com,
	ak@linux.intel.com,
	j-nomura@ce.jp.nec.com,
	pfalcato@suse.de,
	dave.hansen@intel.com,
	tglx@kernel.org,
	jpoimboe@kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: Re: [PATCH 4/5] mm/page_vma_mapped: use huge_ptep_get() for hugetlb
Date: Fri, 26 Jun 2026 15:48:55 +0800
Message-Id: <20260626074855.97652-1-lance.yang@linux.dev>
In-Reply-To: <20260625112955.3254283-5-dev.jain@arm.com>
References: <20260625112955.3254283-5-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1A9DB140008
X-Stat-Signature: uodda8ddwu3gcb5715pun754sbb75q8j
X-HE-Tag: 1782460155-273651
X-HE-Meta: U2FsdGVkX18zdqiVF1dvvHE9Mc8q064CAxV7uH3ay9xhYRu0pPzyt8Sn2y3qCGSxijuX2aMlJQb0cgxb9LC4UwhvxUEB//kSfCSglGpr4iE2PzV2U7h+8HoaiTm3PajoX1UeRYbg/OjkU6BrjkVKZrjdMun3e/cqEH/HnSbqU4Y6cSoIkylTtkYnfzTZM/abeFJg6IkIm+x9zKyB+Kc8QBr9mc5J+epU3tYNvMKEn0UhxTleJPOhql9MGyQz1JXIJB3a9fc2Q0fUmWBMfTAaRX+xnbDwJeOc2mjZUPIkPUKY1HyU701F6rTRqSnCeHKexi4RCVQmTm6xffSCjpR/zOHHkMSwyGgvIXgUr3qH30HsfjPblchLk8Z8idNJoUOwljgPtMJ/pBQIVPV4GPZi3drbn++QV+ISXnLttczlQdFw9uKH9X6KENMruAqweNQbNkmyYxYX+ODdSqTWz2RR+6Rgd9JbuDvUO7r2w85WLEFiSkYHWZ3pgmpLisJcEf83BpXPVwS7GDol5etfV+3V3uFD4zKGXLoJw7dufWSLNQ9ZFS/bFHoJUAmBYfUEycHMg2EH1f0QYLdBFYFRdt+PU4YjMHmby9ArTe0FmiwRUZt6CVZevbsGitOARWIoJaLjCK+XxJojnq+aX2gQDvGZrQJqcZz1Z2WoG0nndjSdh/DMB2IN4BQundMsGSiaej7tbriLpwOnYrv6VHXZtEQ91y/1n7JI65djJx92gjGV+AtGanfyoumfRE0k9uKeu/6qheEjrhzgo0EbPhOX9U1gs5AmwZR+WNv4q0pmFt7QAPQn7G5dn7G3WhW/DQRYyiD+9rTC64scD1b8WM+BIZKwJUGBBaVmQiobILL9noJ3LlLPH1cZTAL6Y0fSMbfbzUlDILsL+SahpsFznPL7JdegTIzfIOxBDmj9aOWhPvoqUF2PtSJTEKsPW68wjLqXhl+I3TsM0OnItz3qp7Jc/Ps
 g2FKZHdr
 McQnAewxscLjkPM/vpnB31+TYiolZ7wQMw2f0iIp5S8WNdPmkak+3IYpexTuKpai3uuml7+puKSEkm7tPlOBL8HYzXmobdSHydkcvHqoBQ6cbBmLig5pAQVJTpkRBYpNeIFlNW4vOoh0zFZE/K+cjmkGmO638ffqmooOSNkNQxUzEe8zhjC2wcLTwRIcmgnGZGc4/zWGzmmIrTnd53iL/HlPV06EdlCIqVWO+LRA5IDyf0+y+ENVT9dM+2XLXF5AvFzu+vm0AhVOf1kwbfH8pBlGr3U2JV+1KeUCQsrEfduZnljlptvBQpyG4KjNX4kFXkySUqRXjLl5R4/bCqrkGlbZ0daL6jwWkq0WAYJTM+Tfqk9tPiQI1y5TSaJcZiXFPt8bnpyiQEbxcb12YqTlwsS4HANH0f0jX41z/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Jun 25, 2026 at 11:29:53AM +0000, Dev Jain wrote:
>check_pte() is the final validation step in page_vma_mapped_walk().
>It reads pvmw->pte with ptep_get() to decide whether the entry maps
>the PFN range being walked. For hugetlb VMAs, that pointer refers
>to a hugetlb entry.
>
>On arches which provide their own huge_ptep_get() to dereference a huge
>pte pointer, accessing via ptep_get() would cause pte_pfn(),
>pte_present() etc to misbehave.
>
>It is not clear whether this has a trivially visible effect to userspace.
>
>Use huge_ptep_get() to dereference a huge pte pointer.
>
>Fixes: ace71a19cec5 ("mm: introduce page_vma_mapped_walk()")
>Cc: stable@vger.kernel.org
>Signed-off-by: Dev Jain <dev.jain@arm.com>
>---
> mm/page_vma_mapped.c | 8 +++++++-
> 1 file changed, 7 insertions(+), 1 deletion(-)
>
>diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>index 2ccbabfb2cc17..18e1d341f463c 100644
>--- a/mm/page_vma_mapped.c
>+++ b/mm/page_vma_mapped.c
>@@ -107,7 +107,13 @@ static bool map_pte(struct page_vma_mapped_walk *pvmw, pmd_t *pmdvalp,
> static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
> {
> 	unsigned long pfn;
>-	pte_t ptent = ptep_get(pvmw->pte);
>+	pte_t ptent;
>+
>+	if (is_vm_hugetlb_page(pvmw->vma))
>+		ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
>+				      pvmw->pte);

I think check_pte() can pass a wrong address to huge_ptep_get() ...

Not sure that is wrong in the first place. For memory failure,
page_mapped_in_vma() can be called with a poisoned tail page of a hugetlb
folio. In that case, pvmw->address need not be hugepage-aligned.

@Miaohe

For arm64, CONT_PMD_SIZE is one supported HugeTLB size. With such a VMA,
page_vma_mapped_walk() passes that size to hugetlb_walk():

bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
{
	...
	if (unlikely(is_vm_hugetlb_page(vma))) {
		...
		pvmw->pte = hugetlb_walk(vma, pvmw->address, size);
		...
	}
	...
}

hugetlb_walk() then calls arm64 huge_pte_offset(mm, addr, sz). For
sz == CONT_PMD_SIZE, huge_pte_offset() aligns its local addr before
calculating pmdp:

pte_t *huge_pte_offset(struct mm_struct *mm,
		       unsigned long addr, unsigned long sz)
{
	...
	if (sz == CONT_PMD_SIZE)
		addr &= CONT_PMD_MASK;

	pmdp = pmd_offset(pudp, addr);
	pmd = READ_ONCE(*pmdp);
	...
}

So for that case, pvmw->pte is calculated from the aligned addr, not
necessarily from the original pvmw->address. But check_pte() passes the
original address together with pvmw->pte:

+		ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
+				      pvmw->pte);

arm64 then uses that addr again to choose ncontig:

pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
{
	...
	ncontig = find_num_contig(mm, addr, ptep, &pgsize);
	for (i = 0; i < ncontig; i++, ptep++) {
		...
	}
	return orig_pte;
}

static int find_num_contig(struct mm_struct *mm, unsigned long addr,
			   pte_t *ptep, size_t *pgsize)
{
	pgd_t *pgdp = pgd_offset(mm, addr);
	p4d_t *p4dp;
	pud_t *pudp;
	pmd_t *pmdp;

	*pgsize = PAGE_SIZE;
	p4dp = p4d_offset(pgdp, addr);
	pudp = pud_offset(p4dp, addr);
	pmdp = pmd_offset(pudp, addr);
	if ((pte_t *)pmdp == ptep) {
		*pgsize = PMD_SIZE;
		return CONT_PMDS;
	}
	return CONT_PTES;
}

With a tail address, pmdp may no longer point at pvmw->pte, so
find_num_contig() can return CONT_PTES for a CONT_PMD HugeTLB mapping.

On 16K arm64, that changes ncontig from 32 to 128. So huge_ptep_get()
can walk past the CONT_PMD entries, and possibly past the PMD table.

Should check_pte() pass the address matching pvmw->pte, sth like:

---8<---
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 406fd50bbd8f..58463493bd3d 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -109,11 +109,14 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
 	unsigned long pfn;
 	pte_t ptent;

-	if (is_vm_hugetlb_page(pvmw->vma))
-		ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
-				      pvmw->pte);
-	else
+	if (is_vm_hugetlb_page(pvmw->vma)) {
+		struct hstate *hstate = hstate_vma(pvmw->vma);
+		unsigned long haddr = pvmw->address & huge_page_mask(hstate);
+
+		ptent = huge_ptep_get(pvmw->vma->vm_mm, haddr, pvmw->pte);
+	} else {
 		ptent = ptep_get(pvmw->pte);
+	}

 	if (pvmw->flags & PVMW_MIGRATION) {
 		const softleaf_t entry = softleaf_from_pte(ptent);
--

while leaving pvmw->address unchanged for page_mapped_in_vma()?

Cheers, Lance

>+	else
>+		ptent = ptep_get(pvmw->pte);
> 
> 	if (pvmw->flags & PVMW_MIGRATION) {
> 		const softleaf_t entry = softleaf_from_pte(ptent);
>-- 
>2.43.0
>
>


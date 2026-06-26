Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89369CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 02:31:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7956F6B00AE; Thu, 25 Jun 2026 22:31:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76D776B00AF; Thu, 25 Jun 2026 22:31:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6833D6B00B0; Thu, 25 Jun 2026 22:31:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 442356B00AE
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 22:31:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CBA21C1AA3
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:31:50 +0000 (UTC)
X-FDA: 84920488380.22.BFBABF5
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf11.hostedemail.com (Postfix) with ESMTP id BAEE240007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:31:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wJmFW8Rq;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782441109;
	b=UZ1GwzXUvwzQLmoBC5v2ZjyzL1BO/JCcb78XlwsSz9cr3dr+0dTQ39qEahlTimQpynFKwz
	qMsXGxHPdItOIdJhcMxxJapczzHzljH1vrp8hgQiqxKVU/jy9Vph1GNVYpVg9zIQoVJpJW
	47PQt1CdfMbcmqnXzORO1kGg9Z3TqDE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782441109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d48K2vjsdWWrmdOhQW/44VDv65Oy54deGsCoIpejECI=;
	b=wXv71Qr0EEqCTCKRKl9W51MrXZQ4X+8ClyOgDnX2G30XoK3yVF6cixRNXi/Lxwp6bN7Ksa
	YyBVb9DtjecUSWUW5uPfGNjzVC0XOPpsz5H5Ie/PLrHkym8WtSSCATg2E1vJhsf2iojn5W
	TJBg13H9LE217S1N1lbjYDuQWUj8s/s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wJmFW8Rq;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782441106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d48K2vjsdWWrmdOhQW/44VDv65Oy54deGsCoIpejECI=;
	b=wJmFW8Rq8MtufcNDuLj9hiQBZr7FtMot8wz8j/UjOKKVXgJAFQA1+bNovARL0N/3j3ijtV
	issgHAKWSs/2O78CmFu/tLsAcyzZ5o2xW3OCNaoLPlvlAM1iFNuMI5pxxYRMzfn6RF7LJz
	XPdMrkzUPfgKlMJ+N+bq0LECZC2WUbU=
From: Lance Yang <lance.yang@linux.dev>
To: dev.jain@arm.com
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
Date: Fri, 26 Jun 2026 10:31:27 +0800
Message-Id: <20260626023127.60788-1-lance.yang@linux.dev>
In-Reply-To: <20260625112955.3254283-5-dev.jain@arm.com>
References: <20260625112955.3254283-5-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: g9bk1joi1ozp5xdk5sny63ngpd1e9myo
X-Rspamd-Queue-Id: BAEE240007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782441108-580421
X-HE-Meta: U2FsdGVkX19clP7sZP4kpLYSwAj5pGrwxZwt1fpnVA90CvK98AI1rcCUhp3QQuz4Z4ZZWtv98udt+iDI6RG65pmKlgYrS43cxOxqjq6JtI28A+GhxQMb9LM/mv5wuSQTQS3gzOUWAgRGGnEp03xxKTFRTsP41s6Tvq0gKvuo3zGYcUa0sP7JWZ5GLAvSZPObuLXiBy3/FGkhpcqt38toTTPINAdqXApDASx28RijAaCPdZMKn8pjySYKEP8JlulbHewMKazvzR/uvPvIfNWYmQnD8XKUEOcn0fbAK4xgFjrP1Xk+3rqL9Hgzbvux04n9OK6ROOhO5N+lUGyEv8iFXCdRn16GfpT2pX2WDWyXmeVHz9tlDFEYmnPE+vHdoktEzyD2zOPk5W3Tik0VO25c589wPXJMr/AV/I8pJvdeWA1cGuAB5PgoXXQEpTD0y/p7zNJE4+rqmAkTJuY01AuJVh/FH7pNfxqAAJorKULwpZJC+Mz3KsW9sLXnTtUPADe5aIugbVx7BAYkJ+YtCmEXscVod9f4HVkqBmvmMPEKfylFg5viN2Uep3eB2iWRbI4HEbR4+Hk+qTI/9OakqvP097hr1YQ3pZ/ORP8Ob7POUN52gfKfgJeYvu+UoFjJ7lR8pfLav1Mh1JhEPlApMVrhgGHLDJibQyknpIUyjt8eL6eMFZ0hef+PvIxjyB/L4kf9yUqvgT/CqFfjlW0IMk9FDHBw+1p2RwBqNhW470wlqT/SzFQfUpYFeWRhCPsk/QBOY0CuGuI4Q4aw1+Y3n4Et4UWus1YYrKtwC90We+Z8b4bgfvvuVyvaIEHyjo2pKuAg99rE7lrHFLPH5LxFVnSng/QcZT2p8710wyd9mAN1J6bmobh2nKlZ5J1llHiEFMNxkSZqGkWWgJIluFWatgr6/dMsWwFRXX0yjnqzi8gYQ/uu5RgF8JpExZZkRVb5AoKv4ZGMa+GP+bxUkvRU3yk
 UyHp3Cjo
 QZ79OSGzD6a8uy6C/PnlRKzS6CCF+fUqJU/R7hOMNJW0aAcmXBEa69vSh49EaS66FW5IOPU6qylrBSemm9M15LUH5k0hQoKxPZWSLzPTbMQd9TZ5XNgCwb9XKq1vGGx+xYMzUNZIHkuJFTn4C/RZp+9tGp7P02AZTFCSGHwZ/j0oe9GIEHHCphMCSle+ScZ+CSa/aDAPO5jhLSQbyS9C3OE8KDwpFBAriOGcH213igc5Smrf3KMCCpSBjpFWS3670CMubYToiaeNVuErgkvn2Lvgd2g929BZlHIR/Ir0AAXjIG0W3GnsYDwgN/v25KHkQNUIdCcD3/OSQP/ATHMy91BJGQMD+ZafqvN3CG3yTxKv6QNdFt/0GGbE2LauvAADrqGaMnOIevBSPqUE6NYPYEdCsHzypgnu2eaT1
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

Just one ordering thing: should this patch come first?

Patches #01-#03 only reach the new huge_ptep_get() after
page_vma_mapped_walk() succeeds. But before this patch, hugetlb sill
goes through check_pte() (still using ptep_get()).

> {
> 	unsigned long pfn;
>-	pte_t ptent = ptep_get(pvmw->pte);
>+	pte_t ptent;
>+
>+	if (is_vm_hugetlb_page(pvmw->vma))
>+		ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
>+				      pvmw->pte);
>+	else
>+		ptent = ptep_get(pvmw->pte);
> 
> 	if (pvmw->flags & PVMW_MIGRATION) {
> 		const softleaf_t entry = softleaf_from_pte(ptent);
>-- 
>2.43.0
>
>


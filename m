Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F9A0C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 05:44:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AD726B0005; Sun, 28 Jun 2026 01:44:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25E586B0088; Sun, 28 Jun 2026 01:44:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 174506B008A; Sun, 28 Jun 2026 01:44:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E38E36B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 01:44:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B76C8D298
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 05:44:15 +0000 (UTC)
X-FDA: 84928230870.29.A62C4BD
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id 91AA140003
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 05:44:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UbSaXfGF;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782625453;
	b=Ai0o/ji/mWA8dM8cWV6aJ7N1Pv8Daf67pjJKH97y2BAWfAzZK4MvS+VyYOZvjAQ1JD11au
	sfJeTSlB2B3n9/fnMN/NIITihUtLNM3ogoMqOBlcqZ0f8VqGMDYeI2bHWXHkfF25tD2w6c
	QQpBhsyXpTVBKeJKUa66zSiLCNUSKCs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782625453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hh2gd/qWylLtYWmFXLrDcR+MvqoGGuVJgOfm4/cNwnU=;
	b=zWDQGFAbgib5FXF+86OwAOpCZ9yOPOZslD6YU6Fysd1Fue/Frk9haNsXlNKVICF7NiItHr
	l6FN1VJFbn17rbmLPWsZwFMk3Q0/9asOf9mkbCFqO2kutLC46PEfZoSohHHRnRgD3802mb
	Yhky6njPbrolDLZBOnrU0V99P1Sy1zg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UbSaXfGF;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782625451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hh2gd/qWylLtYWmFXLrDcR+MvqoGGuVJgOfm4/cNwnU=;
	b=UbSaXfGFeBZY8DWvD4BZijtH1P+LU+jU7J+yZCcXnK6fzLcMgDZfFgvUOZ6QoZ+3q31NgQ
	RuPz+1jUO6Q6d6PczVunELVw6rDH7vqb9rxNAFzlsoaC8oCQBa633o30AfId7jm4PvZ3jj
	dW1Of102EdtUGtUOHDuvE8cA1aDtamw=
From: Lance Yang <lance.yang@linux.dev>
To: dev.jain@arm.com
Cc: lance.yang@linux.dev,
	linmiaohe@huawei.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	david@kernel.org,
	liam@infradead.org,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
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
Date: Sun, 28 Jun 2026 13:44:02 +0800
Message-Id: <20260628054402.76978-1-lance.yang@linux.dev>
In-Reply-To: <82395f5a-31d4-406b-b7ec-10d1a9d067d4@arm.com>
References: <82395f5a-31d4-406b-b7ec-10d1a9d067d4@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 91AA140003
X-Rspam-User: 
X-Stat-Signature: qk8x7tsyhuiuhyx5dj7znkxeudabpfyo
X-HE-Tag: 1782625453-654880
X-HE-Meta: U2FsdGVkX1/SZYat/Qojn80xw0YdJBCOS5XTDed9MqVbBjYkdPvZxkKAdTxB/GuuVjLI23RlzVyI17dVdtzhYuLMHvDFlPikyJfODIA7WVA1v6YiM6QRkXs4iYr+JyLhUzdA508vWLgx7OAopLvxoTFnQQ6BlMVHYgKoR3jMFwCCB76wVbhxXVIqWg/tjCeRUGyfGRcPvR7vHzDTxtNd27DW8Zo2KpxR0SEj/FQLcFSIPIckQZMYjUy6fnZyhtVlon4ji6iTd4vj8isVXBzVVXf4Lf1/jVXCs2p3lJ36SmLHo2QKVud9s93EFIzc6jSU0QdISp8MxBD0F4oMIznLZ15p0wzOVTPKoOi5SokER92TMGKXpDlMuMawEmbZFysIOwVQaanMWOxaY3cDTrvcCt/cWMbKA9WJiTKB2ayp4oiAtIUNg+xF/7M7aMNXBnAYAcVc283xvLR++MKjiG2b2lbpTQFTT1V4e88HKTgMaw+gHwQCEunNRemYoWGzi7LDFDCffEubHSOa0WaBbc4jPWNiCYk4gpkYXP+BZtDXF3+9H3tC9qZic5Odyee1zKgL9aaXh4xEpYzjOddE8bThr5pvvrORgs0g8I/TchjHnN2lhv5CqHUJmfFXfu/Vqg0PPCsbvdsF2iLhvPtFZXFx8wKY6YHsjUCEmbxG8i0zwrKTViIEPE4jPQ7P0u0Q/ioauWcYYXHW9pn2Qh7IZ9RpGNOa7v5RmuPVImLjukc8vRc2IhGoNdNJXwE6jFMOq7FDegm0kvsCn5LAM66CAvXeCQomwyS53+fFtW3bCJbKSHXRtmC5ouh1Ww3dcxNV4Oh1NMoh6AGFLlBGqlt/1TCdHxZWMZRa5/RTEm+sktq7L1gyN1N5dsBlJG1BOVXxm5IwYelX2A76fgerHS3iPpB2+BUhwyhn6qJkwfBHJTZSXl+2t7ks2nfve/jjccPTW4x6JIjcR3/sqlZ8kc1tMbw
 rTBihPx9
 KVed2FNcszcWC+gKoI7PSg8aI5ZvJqtUpfoQxj4EJDVS1D2gzcCbqbGzBz347CUy3n/T9Wbhoiglo3QWmMqBmdG7pSMOptnU8GlYk5pU9WMFb1jRW1nbmzHlS2nSoy6W5CukwweERWGnRV7wuqkcfJmlmkNopiXhG1l5MH3HvzOzgRQBlizSi4V56vjTtZr3F+njhQ0m2OqC0nTQzaUUV8hyKQC4EWd5i9jMgWbAlPpGl/J3xpbM0+s6/UrnE11FWsOJSufICWQMjI1aJbOlNGtQHknxSaKVmNctdZ7KsKwqDPv2MLmWV13M4qFGsEOu6Lkz1MlQXcbQ9jM0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sat, Jun 27, 2026 at 12:43:31PM +0530, Dev Jain wrote:
>
>
>On 26/06/26 10:16 pm, Lance Yang wrote:
[...]
>> 
>> Just thinking out loud: given that huge_ptep_get() already assumes that
>> addr matches the huge pte, at least on arm64, would it make sense to
>> have a small hugetlb wrapper around it that takes hstate and aligns
>> the address before calling the arch helper?
>> 
>> Might make the rule clearer, and a bit harder to get wrong again :)
>
>Are you suggesting something like:

Yes, that's what I had in mind :) thanks!

>diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>index fdb7bdf7645c..xxxxxxxxxxxx 100644
>--- a/include/linux/hugetlb.h
>+++ b/include/linux/hugetlb.h
>@@ -825,6 +825,15 @@ static inline struct folio *filemap_lock_hugetlb_folio(struct hstate *h,
>
> #include <asm/hugetlb.h>

Maybe worth spelling out the rule as well: 

For arch helpers that use addr, huge_ptep_get() assumes addr is the
address for the hugetlb entry ptep points to. arm64 already makes that
assumption.

Callers where addr may not be hugepage-aligned should use
hugetlb_ptep_get() instead.

>+static inline pte_t hugetlb_ptep_get(struct vm_area_struct *vma,
>+				     unsigned long addr, pte_t *ptep)
>+{
>+	struct hstate *h = hstate_vma(vma);
>+
>+	return huge_ptep_get(vma->vm_mm, addr & huge_page_mask(h), ptep);
>+}
>+
> #ifndef is_hugepage_only_range
> static inline int is_hugepage_only_range(struct mm_struct *mm,
> 					unsigned long addr, unsigned long len)
>diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>index 18e1d341f463..xxxxxxxxxxxx 100644
>--- a/mm/page_vma_mapped.c
>+++ b/mm/page_vma_mapped.c
>@@ -110,8 +110,7 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
> 	pte_t ptent;
>
> 	if (is_vm_hugetlb_page(pvmw->vma))
>-		ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
>-				      pvmw->pte);
>+		ptent = hugetlb_ptep_get(pvmw->vma, pvmw->address, pvmw->pte);
> 	else
> 		ptent = ptep_get(pvmw->pte);

[...]

Cheers, Lance


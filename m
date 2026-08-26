Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E21CC61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 08:41:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DFCD6B0088; Wed, 26 Aug 2026 04:41:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 390DC6B008C; Wed, 26 Aug 2026 04:41:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A7356B0095; Wed, 26 Aug 2026 04:41:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 053436B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:41:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08DD8C02D2
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:41:55 +0000 (UTC)
X-FDA: 85142777790.25.6708EFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5997680008
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:41:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PwreYk+q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787733713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0cadP6y+fdngFsaWBuCdgbwmvj6CFlss1lrEwgi5LSI=;
	b=p/ezGZyTFea26h9rfPCPdz6z4KKKij8R2XIaLsbBSqqVStjjzl4rrXn7ukExOjG5eauMcw
	lvapEbnY0v6tjmAihxcOH+lldGXGwX5MWhNxlBxVR1CiFO94d4TjoZhY3WwbSEy8EztaIK
	kgs6wBM1Lxn3DyXVxmtDeqJf2Q5+Aiw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PwreYk+q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787733713;
	b=Z1LPoRtM/qaST9YB2bI9pnazx7GOxvi8a1t1dWFmSABtkp4ner2jCKLqJzsktoCy6POn2e
	kL1iP1Zmw7TOE6DP+ziQucODD1+0nXFoY+gZLOjmMDD4Z5H3CMv6tokMY7MXu17JuKVT0z
	B6qbw5FTsOdYfTySl1DKq+3vTpB1wSU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D211143B2E;
	Wed, 26 Aug 2026 08:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430DD1F000E9;
	Wed, 26 Aug 2026 08:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787733711;
	bh=0cadP6y+fdngFsaWBuCdgbwmvj6CFlss1lrEwgi5LSI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PwreYk+qO4hSUjg/NtTqnARvQ6Fuid0F33c+ai+MzQlenyUC7YvlQgXHgbmZB5J73
	 O8jhWPgA2wXNHXMW+PAEMtSN9cjjg5NotFLwl+R7AQEiQSXOk3BcaDJqIYMJ2d4kko
	 6yhr4ECsNuzLieja/nhINegjq7tVC2emQGiCJkHIUZN84ecYcexp/hk9FNjjBy5tiH
	 vouDPju3AcpUBB40BfYgUxBi2nJOm5Wwzimy4S+31SmcSL5aces53ERHJJzOQoJLcJ
	 VwS1AZ65H1JZ7/77O1ieDPPvJEyaVDZTw3+3YUyZEHjiiz0OlN8/uwYe7zuLBgVddb
	 BG/GJ2r0UNmaQ==
Date: Wed, 26 Aug 2026 09:41:45 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	usama.arif@linux.dev, zokeefe@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v3 3/3] mm: khugepaged: fix folio is used after
 folio_put/unlock()
Message-ID: <ao6mjpuVwfqXvTyH@gremlin>
References: <20260824092935.73892-1-vernon2gm@gmail.com>
 <20260824092935.73892-4-vernon2gm@gmail.com>
 <ao6e9RxwQ-KC1Ikq@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao6e9RxwQ-KC1Ikq@gremlin>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5997680008
X-Stat-Signature: xyn7m8ynem7j1khc8o44m69cx4ceaynu
X-Rspam-User: 
X-HE-Tag: 1787733713-771851
X-HE-Meta: U2FsdGVkX1/JOM0oFPQ1iRXVMutKcEjaxrTwJ7mT9vjXo5/POj2k3bO60AIlRCyCnr/vWl7nZaC2iR/etcSJRwJnDmAj8YnOaf/PfUy8/tKjjt82aO+h6aQS5Zx+MzjYiTlzpGSIsjt0hODVvLKzIAvoYv6J6s8Esu0iaIM1y1jnv8dKBV5JndhWdLbUKjVLKv77/IUk9HeL2PbeI9CrWktDHwnrQ4P18FsFU6JEQ7/Xf3pfMUGW8cQmNB+WAGmTNDqXklMhw4eCwFOMeWaPvZ21vncAmhO1gtdWmbK6EK8tj60DsxDa3rPo+d1E31DlpXsrdGzmMghB2PjasyX8sT34pOBFlXC87PxT9hJUYlsPdQOjXPCCpefhT+3gPnV57AOlab0bYEDVKKUYTul6ohneG7sQrMSE9hi42/fELR15S8Zn8D2UgZBELE/1Y5UvqiE3Q9GM913lmus6l/uYgUbpjsONVJnFVsq4OTAQf6geYbDVGhyH9cnbULxJ0gdRuYkkDgkbG5AvbYeHjfYi+pjtDxxWxTywfyU8yhZYkVtyxlQpdxaH0VBKIqaZZhrQD9+fh5hLUJWBe2io0koAmAUxRlMmd6PMplTQE6HdmMNLMn1vXfoWcSF3UQRYYTFAcE0fRu17Jly849xN2L1g/sMrrOHF342/NKphuuTFAyEQ9602eS4Az1kK7GmEO0emSXRChyR+w1Od7pkyQ1z28kzpodRVn7i78tb5TWuUbeGLcMhRRiJ+hHjFT/ppAAqP3d56MOn0gaRbUiEc/M5VrYq1TmCaJ1fD4XJrmogtfKC9N6O+JV+2Rib+yZqt/3rHT/vyr0KzqADWG8cXIIS6Ryoe0tB4GRLwTxDgQoAO8eKjsj2S98axGrv4s7oaJGbFfkh8tD25h+0at71TGAoW13kF+RKfiQFsWr/WVicZf52a1cQagenWhwOJfTu3MYDF+SSGFTzO7iDgid1z8fo
 2VikxiNv
 3LvVSfHSlccXW/bv8AR2ta72BfspTK+bn8phRW/haG9txONw4mXlqHr1jAiAj7kVEwaXAskvdTPoUWmfdAe8AW8crw27ZMFEfaPXeLdVrT+yUaTabjNJNZ1QfLcUrZm9mC+v1Vzyoc3IltcXU9Vt6bTrSokaeibj0FjpqAA0MYYss/+qDcNEAz3nMeTE42i+3Usp1a31HzoKO/NERx/rckEogYNx+qesLK+E/qmzCetIH3cPoi0Clr1kIkgQ6aYqR4xcI+ZoRx8/eYyAMi4jSZXM4fhUBWzfWuqowg0Vrx2ELGMK+XiMJTKam7iM22q7wgpF1JtGbLU2eOLU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 09:09:16AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Mon, Aug 24, 2026 at 05:29:35PM +0800, Vernon Yang wrote:
> > From: Vernon Yang <yanglincheng@kylinos.cn>
> >
> > On the rollback path, folio_put() has already dropped the last reference
> > of new_folio. On the success path, new_folio is already unlocked and can
> > be freed concurrently. The trace_mm_khugepaged_collapse_file() is left
> > with a dangling folio pointer.
> >
> > So using the folio_pfn() before dropping the reference, closing
> > use-after-free window.
> >
> > Fixes: 4c9473e87e75 ("mm/khugepaged: add tracepoint to collapse_file()")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
> >  include/trace/events/huge_memory.h | 6 +++---
> >  mm/khugepaged.c                    | 5 ++++-
> >  2 files changed, 7 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> > index fa828967e1fb..5fb4d92cfd84 100644
> > --- a/include/trace/events/huge_memory.h
> > +++ b/include/trace/events/huge_memory.h
> > @@ -211,10 +211,10 @@ TRACE_EVENT(mm_khugepaged_scan_file,
> >  );
> >
> >  TRACE_EVENT(mm_khugepaged_collapse_file,
> > -	TP_PROTO(struct mm_struct *mm, struct folio *new_folio, pgoff_t index,
> > +	TP_PROTO(struct mm_struct *mm, unsigned long new_pfn, pgoff_t index,
> >  			unsigned long addr, bool is_shmem, struct file *file,
> >  			int nr, int result),
> > -	TP_ARGS(mm, new_folio, index, addr, is_shmem, file, nr, result),
> > +	TP_ARGS(mm, new_pfn, index, addr, is_shmem, file, nr, result),
> >  	TP_STRUCT__entry(
> >  		__field(struct mm_struct *, mm)
> >  		__field(unsigned long, hpfn)
> > @@ -228,7 +228,7 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
> >
> >  	TP_fast_assign(
> >  		__entry->mm = mm;
> > -		__entry->hpfn = new_folio ? folio_pfn(new_folio) : -1;
> > +		__entry->hpfn = new_pfn;
> >  		__entry->index = index;
> >  		__entry->addr = addr;
> >  		__entry->is_shmem = is_shmem;
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 4e0fca5942dd..24347f1a94ae 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -2254,6 +2254,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> >  	struct address_space *mapping = file->f_mapping;
> >  	struct page *dst;
> >  	struct folio *folio, *tmp, *new_folio;
> > +	unsigned long new_pfn = -1;
>
> Nitty but:
>
> Could we use pfn_t? I don't love that we are inconsistent with that.

(As before disregard, I was somehow behind on the times + pre-morning-coffee
confused :)

>
> Also the general pattern for pfn names is pfn_xxx so pfn_new instead?

Also since we're using xxx_pfn elsewhere here new_pfn is fine.

Therefore, with David's suggestion applied:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

>
> >  	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
> >  	LIST_HEAD(pagelist);
> >  	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
> > @@ -2633,6 +2634,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> >  	retract_page_tables(mapping, start);
> >  	if (cc && !cc->is_khugepaged)
> >  		result = SCAN_PTE_MAPPED_HUGEPAGE;
> > +	new_pfn = folio_pfn(new_folio);
> >  	folio_unlock(new_folio);
> >
> >  	/*
> > @@ -2671,12 +2673,13 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> >  	}
> >
> >  	new_folio->mapping = NULL;
> > +	new_pfn = folio_pfn(new_folio);
> >
> >  	folio_unlock(new_folio);
> >  	folio_put(new_folio);
> >  out:
> >  	VM_BUG_ON(!list_empty(&pagelist));
> > -	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
> > +	trace_mm_khugepaged_collapse_file(mm, new_pfn, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
> >  	return result;
> >  }
> >
> > --
> > 2.53.0
> >
>
> --
> Cheers, Lorenzo

--
Cheers, Lorenzo


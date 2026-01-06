Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07DDECD0438
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 05:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 318D56B008A; Tue,  6 Jan 2026 00:56:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F12C6B0093; Tue,  6 Jan 2026 00:56:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FC936B0095; Tue,  6 Jan 2026 00:56:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0EFC36B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 00:56:05 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9155FB9670
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 05:56:04 +0000 (UTC)
X-FDA: 84300478248.14.98FDFC9
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf30.hostedemail.com (Postfix) with ESMTP id A97B580009
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 05:56:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MDTCVqTi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767678962; a=rsa-sha256;
	cv=none;
	b=rc71m4VePhKpnl+9cHLtm4J14zbZF4T1eMEekClMcmNzV+yMtWUZK/EfkdQbBNUp5eHZM9
	HDWfSVgtjCrwKc7c8ncau0qO5cp6WGLueWLjEscfB5NyX9jPkyCPgagxQRKOJ8MYdpD8Mu
	TsOkor9O80sC0pJXpTVM434xbnuOi/k=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MDTCVqTi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767678962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BkCmBaf8nAhGe/XehVsJi/EpXcjBFJ/V7Iw1gyLZrME=;
	b=KZ73fbK5uf2YtTontOtbekZXLvGzJVXyjba/Q2s1GlvNM4CA2hyRj49sEfB1p9eGrnxgg+
	EZV6sj0dInDUQRMpJTOMuxMKGRkVLuFolrdtWMxSxt7hU5+RNf44yAAuHcxaL25TW+trhP
	N8ycB2Y239xYVEHaNFzoxj/7JsqGoPk=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7b8e49d8b35so823153b3a.3
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 21:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767678961; x=1768283761; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BkCmBaf8nAhGe/XehVsJi/EpXcjBFJ/V7Iw1gyLZrME=;
        b=MDTCVqTisXkbrTkZkqTow3G9mLmk02fTuH4tyYvtH2vV9wtFUdnWgfiKPrw4kheoM4
         72AnXAkSbrE08etkUVfr6O35RJ9HNi7HTRegC2RkUdpZrn9HqeZPaToRQjRn3hPiaShS
         XFM5OOFPrk4WONAioxjGVYhn7oGMqnY4GUkHNVGyL3w7SW+71XVxMywGC6Nez4BtIU1O
         oiaUyG1hUpJvEuomt3PuU/bv1AhBTkpwHY9DKRbmJe0xKVI6JQ6EeJFKzFxzoTs2Kwch
         lDjhENZR1mJ9VJIBSKsC9ppQyU0eo/wPBbA5P1yOFNQwosjHuOwrLILHaHQzHPtdCZ9O
         tQsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767678961; x=1768283761;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BkCmBaf8nAhGe/XehVsJi/EpXcjBFJ/V7Iw1gyLZrME=;
        b=TdxeXF8+20M2tp0cVb+Uts+KtaTn8WRg5fh28t4VV07ku1uCYtPhbuPUO8R4eUCIIM
         Bd5Y4XiLAGE7VpcqqtdVjFQx4kofVHyrOx+CUgbwxnvb1R9lzc/+zVmKvGJgQvIezXCp
         +twmEeoq0oJ2hZeXWZekuLFACkFhVW1T9wfifYZZKJ6JyPgSgEn7CcWEY+JzdT3dDqpy
         0P7VsOcT5xnEuVH6ETyMY9pajbOvGQaIphyNWEAh254tS+m9JNAIVykr84o7x0Sa9iLZ
         joJ2BCOKuYcdgrdaXJBT+C2LAcQxq7MBzDr1Df2zrqoGsmwIBUGrB4KVpGhxDy42jt8o
         06rA==
X-Forwarded-Encrypted: i=1; AJvYcCViiHeiIHbWiwPUOcmxTtkARQVRkTYOxf+z1toyLNkAtU695wr/zddoYvRW8OfOMWClZQ0O04Du+A==@kvack.org
X-Gm-Message-State: AOJu0YyNjJU/VqfsxBJ9Q7vs/Ib767A90PD4wvZve8p0pHoFBH6drXlJ
	uGe1vwMmfKwyb4CQFVdq7kPTD4SBq1W4apNAOHGRaq8KcK6wpqtDkIdP
X-Gm-Gg: AY/fxX62jcO2mJBO1aF3TCP73i4Hv00fwvtLDfqMeX+nNe6zKT3pd2Wwa2CNthVNNWu
	SCBX65nYCJMEqQ2BItqA57EYPxUXaof+IPXRimSSg9M1Z9CAnDndXIxx/0j2g/VVfPcAggc+Sha
	BEt+ZlmrohAdn+qM1m9O3CDWQMrh204Q9p6K7ppx6leEhxxxPqHZVHfXCBNcco9FvbS/gdGgwij
	ql8ecfFv4gW6YdV5569nuacGC/TiRC1Phpb0j1vemKS9qp0Z9jGmnSX3w98dm3/SvMsgRrUXq4l
	YbLF1cDTyUmrfHzktM6hA3yES0Hm/ybaep9sa3jox2m80K7sCUG6MRRbqWHAFWsaO825jN6D2JO
	H33iVA3I/9VogXmYbqij90QTO7IEJWbvo8nAucAMiyAEZnf41Xd36aW0UWFL9dVcdKLwz5QofvR
	zz9PAP7+pTtnUpDTkdWdOyXBk=
X-Google-Smtp-Source: AGHT+IHhkJOQTD4pfA7Gs34xg7AIc6YAZfNu7WcsDUZ8ACVJoQvvvLrH9QPNNgl2vPSkvHxvZhOsXA==
X-Received: by 2002:a05:6a00:8c04:b0:7e8:43f5:bd0c with SMTP id d2e1a72fcca58-8187f4a165fmr1853088b3a.33.1767678961337;
        Mon, 05 Jan 2026 21:56:01 -0800 (PST)
Received: from localhost.localdomain ([121.232.80.251])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-819c5302c61sm877571b3a.42.2026.01.05.21.55.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 21:56:00 -0800 (PST)
Date: Tue, 6 Jan 2026 13:55:44 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	richard.weiyang@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v3 2/6] mm: khugepaged: refine scan progress number
Message-ID: <zc4yspu5rq4he64std2f6l7mnyua36tudnwj7fgqmk4aioevzw@ungu66emhlgf>
References: <20260104054112.4541-1-yanglincheng@kylinos.cn>
 <20260104054112.4541-3-yanglincheng@kylinos.cn>
 <69c9ac59-4fb2-42fc-a8ae-32f583e47de4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69c9ac59-4fb2-42fc-a8ae-32f583e47de4@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A97B580009
X-Stat-Signature: ytss6khwui9ofma76dax75knwis6dt3y
X-Rspam-User: 
X-HE-Tag: 1767678962-847239
X-HE-Meta: U2FsdGVkX1/3mjwrQpfPL93VZbqtrDLlp/gF2K4jwbmgSo9NJeEd2cS7fUjTqdKwJ7w6tT1r+0+QyeQoHyhBcgWk1AsYa2JrcoSwXvT0xr0UbLUutoUoRKqzRx9aF+YOkvlirEGSa86T3ievUXYEPmoOOehIty01RMqgoKJLhQTI9tHeW5KCXGT4HUCClP0c1HKVlSOnTumGjpRElE3bjXPeoezk0830/zQ1aEBEN+YdsIC0miUo0koGeIpKdnbnEphOGo3KSm+5LA2RDs1P3be7/Soe8hyEiLRffDvkbo3+aM8NKILfkSS8TW3D0NEP2Ra7LMkBOjLhuPXQndQ6YJdI/ghiP2JDwhOxVc6Yghp61bxFgQ2xUqGDW5CPROlCTxs9MyL9zHUvTkrvM7Ah9Nd/YDBBQC6RCyM6CesczhPNxHovdSAyB4fKx0CRopl90XevlXxCaMnFuTIxf0nsKKOUXYn1MpnRfRyddmIZxecfE1tDvRR3LB4RaZViA/l9uizPq7WtzQoOQy2V7qql5jzEOTvqfu055Nc+0ThsOrM54LTb4eQ3lUwDxrxwvqZ9+ifXiUWzkmQxgmfcfW2PUTH/pUUGYg+kI+47uYss6mMIHx+Uwr6H26pKulR+rm3GPirJYwNvl+ojZz38xmhQvSbDrN3CtnkD+SJqtPLpYNxOWRVsYm+uui9zSkgJdc6PQNEceKSDc86F8i+z05rkko519vv4v6tnjXLBJMx8iTlhee5c/vuGyajerKccTfKTgnoyig4Tijr8auYmcayf2/aLO4Gy3/7H0WN7nf4jxnBxNpzP1tWbTgEdbIuGMAYdzHafJs11cjSYFKwo2SFIeBjrifHUBehNNvPO6f2wgnmo4HilCKIzMZ5v+uukEHvBCmLK51ZNFWKH9O3toCkmsbdEf6mX64EiDJcFK4YXTvovPHLMSYWUhnfo+oPtjTwj180WHnEYuLvI8U4Tq+X
 OdoZJkoH
 sMNU9kTcFlDlMUKVMf3SdufKCT20XLUmmkPCvSECGFnxFODMKxwYOFCDkdQmC5gXt7EKHt9aMTvffwzYe8TQtVcLRAlvAlvKWVseSzJw9gEr+YjTMAoXAzap9nGrII5NClkYZbF0QFuIY7X1oC94VIWbegF5R1c3lsbRbZ8r4ouCquzyS4DHgdcAP9zGcnetCVTb4k5C4iazPdoHpwjxOPm0+IUg3OqCAFSWaaHaxh+seS6iesH2IUh1y8G0LQPrTMB6zV2z0NreY9XnCKjvcuQcNt7z90bKgjP7iJrim3pPi+2UhDb0hoiLqcair2Op9c8ssARDD7UXflfrmviJVcqgWH/0KlX35aoGc86+AMeYedJrzM7ke/poxZ0qLpcnwdPq3h+OoCO9U2i/Bvc/aifeC7uNYb24zIcX1AxhcOlSFrZjWxTBF/jxH2gSpMwYnTvKm04ypWiSixZXFEEak3stUbxXUJnPNzMt8DM9un9ZlJwAHDn+Da3llfIJZ2C1eUt9hNTcq93M0qflK+gUig2LYMZuCPGtuTKDY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 05:49:22PM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/4/26 06:41, Vernon Yang wrote:
> > Currently, each PMD scan always increases `progress` by HPAGE_PMD_NR,
> > even if only scanning a single page. By counting the actual number of
>
> "... a single pmd" ?
>
> > pages scanned, the `progress` is tracked accurately.
>
> "page table entries / pages scanned" ?

The single page is pte-4KB only. This patch does not change the original
semantics of "progress", it simply uses the exact number of PTEs counted
to replace HPAGE_PMD_NR.

Let me provide a detailed example:

	static int hpage_collapse_scan_pmd()
	{
		for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
		     _pte++, addr += PAGE_SIZE) {
			_progress++;
			pte_t pteval = ptep_get(_pte);
			...
			if (pte_uffd_wp(pteval)) { <-- first scan hit
				result = SCAN_PTE_UFFD_WP;
				goto out_unmap;
			}
		}
	}

During the first scan, if pte_uffd_wp(pteval) is true, the loop exits
directly. In practice, only one PTE is scanned before termination.
Here, "progress += 1" reflects the actual number of PTEs scanned, but
previously "progress += HPAGE_PMD_NR" always.

Previously discussed, just skip SCAN_PMD_MAPPED or SCAN_NO_PTE_TABLE,
currently in Patch #3, not this Patch #2.

> >
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
> >   mm/khugepaged.c | 31 +++++++++++++++++++++++--------
> >   1 file changed, 23 insertions(+), 8 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 9f99f61689f8..4b124e854e2e 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1247,7 +1247,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
> >   static int hpage_collapse_scan_pmd(struct mm_struct *mm,
> >   				   struct vm_area_struct *vma,
> >   				   unsigned long start_addr, bool *mmap_locked,
> > -				   struct collapse_control *cc)
> > +				   int *progress, struct collapse_control *cc)
> >   {
> >   	pmd_t *pmd;
> >   	pte_t *pte, *_pte;
> > @@ -1258,23 +1258,28 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
> >   	unsigned long addr;
> >   	spinlock_t *ptl;
> >   	int node = NUMA_NO_NODE, unmapped = 0;
> > +	int _progress = 0;
>
> "cur_progress" ?

Yes.

> >   	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
> >   	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
> > -	if (result != SCAN_SUCCEED)
> > +	if (result != SCAN_SUCCEED) {
> > +		_progress = HPAGE_PMD_NR;
> >   		goto out;
> > +	}
> >   	memset(cc->node_load, 0, sizeof(cc->node_load));
> >   	nodes_clear(cc->alloc_nmask);
> >   	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
> >   	if (!pte) {
> > +		_progress = HPAGE_PMD_NR;
> >   		result = SCAN_NO_PTE_TABLE;
> >   		goto out;
> >   	}
> >   	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
> >   	     _pte++, addr += PAGE_SIZE) {
> > +		_progress++;
> >   		pte_t pteval = ptep_get(_pte);
> >   		if (pte_none_or_zero(pteval)) {
> >   			++none_or_zero;
> > @@ -1410,6 +1415,9 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
> >   		*mmap_locked = false;
> >   	}
> >   out:
> > +	if (progress)
> > +		*progress += _progress;
> > +
> >   	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
> >   				     none_or_zero, result, unmapped);
> >   	return result;
> > @@ -2287,7 +2295,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
> >   static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
> >   				    struct file *file, pgoff_t start,
> > -				    struct collapse_control *cc)
> > +				    int *progress, struct collapse_control *cc)
> >   {
> >   	struct folio *folio = NULL;
> >   	struct address_space *mapping = file->f_mapping;
> > @@ -2295,6 +2303,7 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
> >   	int present, swap;
> >   	int node = NUMA_NO_NODE;
> >   	int result = SCAN_SUCCEED;
> > +	int _progress = 0;
>
> Same here.
>
>
> Not sure if it would be cleaner to just let the parent increment its counter
> and returning instead the "cur_progress" from the function.

Both are good for me, I have implemented one version as follows, please
see if it is cleaner.

--
Thanks,
Vernon


diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 9f99f61689f8..4cf24553c2bd 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1247,6 +1247,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 				   struct vm_area_struct *vma,
 				   unsigned long start_addr, bool *mmap_locked,
+				   int *cur_progress,
 				   struct collapse_control *cc)
 {
 	pmd_t *pmd;
@@ -1262,19 +1263,27 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);

 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
-	if (result != SCAN_SUCCEED)
+	if (result != SCAN_SUCCEED) {
+		if (cur_progress)
+			*cur_progress = HPAGE_PMD_NR;
 		goto out;
+	}

 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
 	if (!pte) {
+		if (cur_progress)
+			*cur_progress = HPAGE_PMD_NR;
 		result = SCAN_NO_PTE_TABLE;
 		goto out;
 	}

 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, addr += PAGE_SIZE) {
+		if (cur_progress)
+			*cur_progress += 1;
+
 		pte_t pteval = ptep_get(_pte);
 		if (pte_none_or_zero(pteval)) {
 			++none_or_zero;
@@ -2287,6 +2296,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,

 static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 				    struct file *file, pgoff_t start,
+				    int *cur_progress,
 				    struct collapse_control *cc)
 {
 	struct folio *folio = NULL;
@@ -2327,6 +2337,9 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 			continue;
 		}

+		if (cur_progress)
+			*cur_progress += folio_nr_pages(folio);
+
 		if (folio_order(folio) == HPAGE_PMD_ORDER &&
 		    folio->index == start) {
 			/* Maybe PMD-mapped */
@@ -2454,6 +2467,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,

 		while (khugepaged_scan.address < hend) {
 			bool mmap_locked = true;
+			int cur_progress = 0;

 			cond_resched();
 			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
@@ -2470,7 +2484,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 				mmap_read_unlock(mm);
 				mmap_locked = false;
 				*result = hpage_collapse_scan_file(mm,
-					khugepaged_scan.address, file, pgoff, cc);
+					khugepaged_scan.address, file, pgoff,
+					&cur_progress, cc);
 				fput(file);
 				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
 					mmap_read_lock(mm);
@@ -2484,7 +2499,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 				}
 			} else {
 				*result = hpage_collapse_scan_pmd(mm, vma,
-					khugepaged_scan.address, &mmap_locked, cc);
+					khugepaged_scan.address, &mmap_locked,
+					&cur_progress, cc);
 			}

 			if (*result == SCAN_SUCCEED)
@@ -2492,7 +2508,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,

 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
-			progress += HPAGE_PMD_NR;
+			progress += cur_progress;
 			if (!mmap_locked)
 				/*
 				 * We released mmap_lock so break loop.  Note
@@ -2810,11 +2826,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			mmap_read_unlock(mm);
 			mmap_locked = false;
 			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
-							  cc);
+							  NULL, cc);
 			fput(file);
 		} else {
 			result = hpage_collapse_scan_pmd(mm, vma, addr,
-							 &mmap_locked, cc);
+							 &mmap_locked, NULL, cc);
 		}
 		if (!mmap_locked)
 			*lock_dropped = true;


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BEDFC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 19:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12AB36B008A; Mon, 27 Jul 2026 15:25:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DC496B008C; Mon, 27 Jul 2026 15:25:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F35916B0093; Mon, 27 Jul 2026 15:24:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C97916B008A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:24:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46C86A0182
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 19:24:59 +0000 (UTC)
X-FDA: 85035534318.28.FFE9599
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id 039274000B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 19:24:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=iR3yzklN;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785180297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7emG/Bu3YrbljPGVbZoShTn41m9g5LjbzcKv5pUpsVk=;
	b=hemMb8Uk6YmXYne2tb879XHKDHX7QYW1pndUduAexWKsF5/pTwMLwL/7SsTRQ23T/kUjcm
	2BIOCsyYoMVqqGzmqsILjQ2snqnrxbWIP8PL7vvrFWsxiDPWo6PWoxSrYSBcz+wy5ygn4k
	C7ojs6cN3CfR7hGUaokb8T0KNDnQa8k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785180297;
	b=vNFyhSLJ/snCtP7m0xNp/V3ls6l+4RWx/Ev8gfUdC92nZSdh0EhzkCRpXXfRgZlMuFIkcA
	8xQ/TWIrSFhSHIPtnMrcqnfaQw/DHgxx2FvjX6j552ybRSVRQ+lF89gPr8L2dmWPpGa50H
	xeNNr+J36dltjSaV7diOFQNBXNv8sOo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=iR3yzklN;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7emG/Bu3YrbljPGVbZoShTn41m9g5LjbzcKv5pUpsVk=; b=iR3yzklNb9UCT2hcw6Lnf0nBOP
	9qLjT8AOHqUKvFLV6YXWgneW/EmsUkc+6ES5oCkubbctAUec/DrZmMBBBwq6dM7QuYj9Z5Q18mg6P
	0cbXXTvdJh97l+VIomDxcBr7dOnbKX9Sm8l/cFOGPM1pK2MKDNZls5Gsx0Zb8D8B2oSMn6hzF+57s
	VTv8BxP60JgpI3jEklbeEU73a63fVys1IMusuDw0b4c2zVzE7BYv34kyA/FLWrm1KhPk1zoF2UnRd
	mP4NDB9mi36WTgu4lRY3tOQpNLSzqy8ZhzeDr0bbAa4i/Kys7REvDm2OZ/Wg+zNmKymYKVNNeKtmu
	sZqEgwGA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woQwV-0000000BJN2-1xCB;
	Mon, 27 Jul 2026 19:24:51 +0000
Date: Mon, 27 Jul 2026 20:24:51 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v6 05/12] hugetlb: Use the has_hwpoisoned flag
Message-ID: <amewgw3vDEu6sC2V@casper.infradead.org>
References: <20260727181310.2671972-1-willy@infradead.org>
 <20260727181310.2671972-6-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727181310.2671972-6-willy@infradead.org>
X-Stat-Signature: nmxwtc4ea5mjztd3jyhhmhdt85i73dit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 039274000B
X-HE-Tag: 1785180296-12519
X-HE-Meta: U2FsdGVkX1959xh4syIxEqT6zjI0RXwBWFdw9P4qemBu6xSkDk9z91pqj2HLQcKiCQ9RxlrmAnoZTAD1MTre91Zfw8Qoq3YGORwA67FpEF0i6jeDmMB0Ki4eeB+TrlIaeJjiFeCmUTpx8CpebQ/ZWyZHTP32SWf1jaRnO6vrq2HjwOLLjMqRpy1YOXTuuQo+YWCl4gi7sFk6rqlIID5jwlm73PqgEuZfIxJ/bY6mXc4KtnFO9PTs/rhFti23lMxxinpIwTZ7cm8lTASU8mTV3efz+KXPv+/DvADQfXDS69MEQtYR+uVnoh8jQ1Q3C31XtP6jN8qQp0ggbvjIAg+IGAqUswbsxOGcBqfTLkmq0qYhkgyahMpFIr1JNfBLPhKpyz0lrpwzgyxerPaH12WcDz/BM4cGjqqFZyS624esPVH/OJNDU6UruTqr1wsokReHgSTNvDPKZNh0eS/X0V3th8uhvPTFvB0K/mdM/0X4vuuwAaiJiDH+JWjLhD70p0wxhxlcu2vjBJLcUj52Zp+V9cdJ1hYki+nmu9Ef8Cms0Ojzbu2eftNSbWJ2nRaUbjvpmx3HrdGcD2VnAMSqgmmL5PbVKqSMiYXkHDG+hgfbxTE/DeSStbwwi2noHPMFaz+SxxdaNmiQvTi2NiIbOvdP1y13yC7KdxfKrRHvouaXhtsOyuLdcygjWZYtL+dVKdpJ6MKKRnRqpymGyAkuzcuzJBtyS7MZFEaGctCYGcZAdiSa/6mXEihubMluygxzlDKyG6+lBcBKCgYE67gL3iodrl0cbf3oj1oPdROBoJOF+/HmcPJQy2sVPPE4RdKO6SDptFrZDFcLKchDBhAW4UW1oydxWDFlzomZPARHKBTpMABxR489Tmu3gdv/Xa2ZYnGDonzzGIm2+WjIpVrw3vrRLu1AMdIINfhMWukeJMOw9w+XJRThyPIqbeZkgRBOXyw4v5skQgezaI5pg4Cgetk
 ZH3O0iVs
 nJWnM3tXY2Cbq0wEgv7X11szg9j5oZWIJVvRaKxNjsw5ouxxo8MswXvETqeVifhOfA8oMNQgbtv8rn7aFLBtjJIpaHrOfR8aYjuoZXgUHoiDJKq2OX1yQLonLM9k6sZhluJ6sy9dqCBYIJEyzFPzVGoRopJhy5WCelq38PCutUJEs/yEqVRhdID3y/plnhWu65fq1JZLpFRlXsMx4NZbve0uC944pGN6j33MQFOa07FF/C/onVfZYKci2BuE5H0nkdd5PsNOkWuR3bmNhWYmFe0lDu+y8IVO5v256IHs+G574czLki3YZSmE2IdxgS897IdjGjBuqVfNKoKiDqi1DJe3m1XAoy+/q2/mtpCUUDwx0ZXKYu1jpypDb/04s3XMacN3pHvjhE27VMTSsZUQlOe6DbvlDtl4zeQIgPDLcqDpEhtM+gKyjtDLK40f7qpyE2uOuXlzlBAf+/lU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko:
> --- Patch [5]: [PATCH v6 05/12] hugetlb: Use the has_hwpoisoned flag ---
> commit 0c26849a193942cada35af35e9ebcde14770667c
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> hugetlb: Use the has_hwpoisoned flag
> 
> This commit converts hugetlb to use the has_hwpoisoned flag like other large
> folios, introducing folio_test_huge_poison() to handle racy lockless checks.
> It addresses a gap where previously-poisoned hugetlb folios might not show
> the hwpoison bit correctly.
> 
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> 
> [ ... ]
> 
> > @@ -1255,7 +1255,7 @@ static struct folio *dequeue_hugetlb_folio_node_exact(struct hstate *h,
> >  		if (pin && !folio_is_longterm_pinnable(folio))
> >  			continue;
> >  
> > -		if (folio_test_hwpoison(folio))
> > +		if (folio_test_has_hwpoisoned(folio))
> 
> Can soft-offlined pages bypass this new check and get allocated?
> 
> When soft_offline_page() processes a free hugetlb folio, it calls
> TestSetPageHWPoison() to set the per-page poison flag, but it does not
> set the folio-level has_hwpoisoned flag. Since this allocation path now
> exclusively checks the folio-level has_hwpoisoned flag, it looks like it
> will fail to detect the poison and hand out corrupted memory to userspace.

Seems like a hallucination to me.  There's only one place we call
TestSetPageHWPoison:

try_again:
        res = try_memory_failure_hugetlb(pfn, flags);
        /*
         * -ENOENT means the page we found is not hugetlb, so proceed with norma
l page handling
         */
        if (res != -ENOENT)
                goto unlock_mutex;

        if (TestSetPageHWPoison(p)) {
                res = -EHWPOISON;

so hugetlb memory is already handled first, and won't fall through to
here.

> >  			continue;
> >  
> >  		if (is_migrate_isolate_page(&folio->page))
> 
> [ ... ]
> 
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> 
> [ ... ]
> 
> > @@ -2725,13 +2748,17 @@ int unpoison_memory(unsigned long pfn)
> >  
> >  	ghp = get_hwpoison_page(p, MF_UNPOISON);
> >  	if (!ghp) {
> > +		spin_lock_irq(&hugetlb_lock);
> >  		if (folio_test_hugetlb(folio)) {
> >  			huge = true;
> >  			count = folio_free_raw_hwp(folio, false);
> >  			if (count == 0)
> >  				goto unlock_mutex;
> 
> Does this error path leak the hugetlb_lock spinlock?

*sigh*.  Fixed thusly:

+++ b/mm/memory-failure.c
@@ -2752,8 +2752,10 @@ int unpoison_memory(unsigned long pfn)
                if (folio_test_hugetlb(folio)) {
                        huge = true;
                        count = folio_free_raw_hwp(folio, false);
-                       if (count == 0)
+                       if (count == 0) {
+                               spin_unlock_irq(&hugetlb_lock);
                                goto unlock_mutex;
+                       }
                        ret = hugetlb_clear_poison(folio);
                } else {
                        ret = TestClearPageHWPoison(p) ? 0 : -EBUSY;



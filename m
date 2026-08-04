Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AC12C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 15:35:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 421B76B010D; Tue,  4 Aug 2026 11:35:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D2546B0113; Tue,  4 Aug 2026 11:35:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C16B6B0115; Tue,  4 Aug 2026 11:35:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1218E6B010D
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:35:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 964B1801E0
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:35:29 +0000 (UTC)
X-FDA: 85063986378.21.12024EF
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 965701C0011
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:35:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jP6W4WUb;
	spf=pass (imf20.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785857728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r67WbSGJFOJ3m1cb1BTsiBKOB/G7xLlz+d84UQNgMrg=;
	b=yIlMGJrNrlP3qTUiLd2irD1EpKIuMNXzT503+EfVX5CJR1i5IFd9Gkf+Mk3patXuOx+65I
	pZYIvblkQ3NJ33DsK25duggPo+0SR04tvqAr73sWBTF5lY5sVFNbpkDWqz+//ZaeUPorEZ
	sPOD1kgXNZeqfnWAfFd6y76URwBMyCc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785857728;
	b=EAUCbXSifKSZZE59T3yiRnrDNbzmrgeLZ3i1hzMCfC4Hnbr/AJ851lWnTwG+m3jqynrQFd
	C5Pw6DCjI8hCjGSOOg5enK++HzTdpA/6kuipHw+ytohZfmNwwe2ExhpsJbvGE7/WczmZS0
	NTb0755n7YZfGSlURb8H4Q0haDSU8b0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jP6W4WUb;
	spf=pass (imf20.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=r67WbSGJFOJ3m1cb1BTsiBKOB/G7xLlz+d84UQNgMrg=; b=jP6W4WUbd+BQvlFAif99nMriLt
	QB7Z5FQtFkh9MEJFpTavQl03ecClCBbb+ORaTP287JSk6Wxbwy/GqFhBaM4UosHej5/AgcWkYtniZ
	t+HGWIVJIs+ADEa/x46vd54UfcpKvGLhbXJTnlvIAVXqDJiKXmDr8cG7+PNdYokV8TD3s5JnD2Xwe
	UcRZNBNbhqAnAyU6BOK4CEJoDazO9mHSIFyNkXFQ1u+1AxwnKrn7pjVjKJuFYGhe7kReo3a0CbVSW
	QNn0OR88uSrnYvcM/TCiCOpMf5B7Cxd19YZGYV47wU8d4CsetablOYuc1O2uSF687oeOhsUtqF0fe
	R6vB3+qg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrHAm-000000048FO-2n8G;
	Tue, 04 Aug 2026 15:35:20 +0000
Date: Tue, 4 Aug 2026 16:35:20 +0100
From: Matthew Wilcox <willy@infradead.org>
To: jane.chu@oracle.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: Re: [PATCH v8 02/15] memory-failure: Prevent hugetlb freeing during
 unpoisoning
Message-ID: <anIGuLZ-x2pIb6mg@casper.infradead.org>
References: <20260731200802.574821-1-willy@infradead.org>
 <20260731200802.574821-3-willy@infradead.org>
 <2f5fb8e1-67bb-41ec-af8f-b4da60be4583@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f5fb8e1-67bb-41ec-af8f-b4da60be4583@oracle.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 965701C0011
X-Stat-Signature: m7banjthycgqtxm1or467owdcm7p6w1c
X-HE-Tag: 1785857726-181443
X-HE-Meta: U2FsdGVkX18aY5wtvH9GKCFOLNIruYnPKnDdN70HljtjJIhAqjzdOWbazzvgTBfpnC/+l12WJhmAfFLaOWvJcHvNcYhZslVJ0GN/2nBf6zJ62pizdLeto5pQFCuCNdlb24v0gpQd0O9ovG0znVLmTFWiTLBvyKOz3YZ8furja09kuEu4fJOZy7s6grH5I0MNe4mTQ5jQEpHY4HsTTAPf1MwX1dIsZpvs+0w/QqFWoQ8+Cd/qDh/REJOJoUoLGESdFQk1CnSqaSZ+rjTNIQi8MyoPrSqFOlR6VbIJPSFV//+bD9ALC9v3w9ZFz/cv+cGVyvMclvZBTnm7PJnPLd+t8B9UZCu3PkEHXzx0UI4bvpyfIdEpjGCNSc4s0KcwHyLSBSxjkhZDNN4NzSwN6PH2+SBOSyVs1cGOqMByWuG2SsN99uwsZKjlyFbvifZSWuYHOqwpm0s2TzBfp4jwCrWOvq7Nkv3dXBYgDhRVqmQoBiNR7xSOV+dxLZc43uw0YkEpRMfRQvmvxag7X6+tRaqCBxTvxD+CkXAw07yA/PWx4uFD8csb35x33XqP98soGOin6pefraoYd59pfRNb0d2BOcq/gt5NjBU9c1iIdTLBXCBxRjOL3hLvOt9Rrt59ZAHJHHqEyV7OvudgecD7QRAJyWFuxvGuIaUUD7U3WB7Hm+s0+yfwKwOKq+at5Ud6bMwB9ZHzVxhP9MdAH6EhgMR2jX26UaEo5u1zu7Z+a8f+/VdILC4p4uymOfrmnOWFOM9lSdTxFlhHjg7BByKPiA0A/by/Gbu3SpeorSD6TPqgB9YgJU981c0oFxOqRUu4C22R3Te4lSUCdcY9Z7Ktyv15eWvLV90WKgKdCjkosfZkFtiaFQu8l2dBhHkw0hsOOxXJ+/XboAkc2OScNiPO3hU7vocgE3mHGWu25XaI+bspDz+5e9cPZM5rFBD03KQ0DyiKeZNhWV1iusBo70P6qMJ
 LuQR2vaC
 v2ep45D5mm2n7fZx+TuOvfCr9OOaWlXuL/7ZhnFtr8a8XNzWT+4QZ9l9eBBmzvqMpA+l6K6uujQTp4qU7WTZULSFPVMcljLOL90i5FNUyeSupgr3a+l5ZXql97jKtJGpuGlP8REAmn8ZL2Y5E6buCKgFe9kVufrNbye+gkMd7214/faQ8mM6ZuRfFl6zlETe09HHXDENpAp2rlxK9lTNk1XgB2bKE0Tbea0EkSgBjdvZQDOHgkz1mdQH36hbHQbCSQs55bVu/Y4v/KE9N2wMKa1F25qRiZAAq6j6KrbKupAPfPmdsGsdddOoMITil7V3mJXpJOzkx4649ygJZHyvBYi3FMFEQiy9Mh2eYyL0VzI8t76cAtQsDBMez2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 11:40:25PM -0700, jane.chu@oracle.com wrote:
> Patch itself looks good, so Reviewed-by: Jane Chu <jane.chu@oracle.com>

Thanks!

> That said, there is a pre-existing issue:
> folio_free_raw_hwp() should check HPG_raw_hwp_unreliable, and fail the act
> of unpoison just like what __update_and_free_hugetlb_folio() does -
> 
> static void __update_and_free_hugetlb_folio(struct hstate *h,
>                                                 struct folio *folio)
> {
>         bool clear_flag = folio_test_hugetlb_vmemmap_optimized(folio);
> 
>         if (hstate_is_gigantic_no_runtime(h))
>                 return;
> 
>         /*
>          * If we don't know which subpages are hwpoisoned, we can't free
>          * the hugepage, so it's leaked intentionally.
>          */
>         if (folio_test_hugetlb_raw_hwp_unreliable(folio))
>                 return;

I'm not sure I agree with that, but I'm new to hugetlb & hwpoison
handling, so please check my reasoning.

We set the unreliable bit when memory allocation fails (ie we can't
allocate a raw_hwp_page).  That does mean that if we have a real hardware
error, we can't know which page was poisoned, but for a simulated hwpoison
which we are now clearing, it doesn't matter which page specifically
contained the hwpoison.  We're going to unpoison all of the pages in
this hugetlb folio anyway.

Maybe there's more to it than that.


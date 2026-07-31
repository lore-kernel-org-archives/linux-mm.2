Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75746C5516D
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 13:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F9E76B0093; Fri, 31 Jul 2026 09:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D2AD6B0095; Fri, 31 Jul 2026 09:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40FE76B0096; Fri, 31 Jul 2026 09:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1E6436B0093
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:39:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8EA241203C5
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:39:10 +0000 (UTC)
X-FDA: 85049178060.09.1496529
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id 199AE40005
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:39:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=igU8xHOZ;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785505149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PMsSa8DpHjoOi6gmcOGcxYP4gI70dVR+DdX0H08nrsA=;
	b=n1x9DwsZ9zphkRxyZkBUTAQcaekq35gzFGIS0Y7mFXQpDdGmSWnKD08Cr3qFqooIbdsO/O
	xKe3pio/scoKQ9EemfuokQ2OAqu2SWJofUM/Pb3taAEEQyLmQ8N6v3AG4JL9uaR4v4P7/g
	FihJxnCgUo6YAH46zeN49HpSAADtlX0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=igU8xHOZ;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785505149;
	b=if9OZ4hiKSKOTm9PdVqjfItKos4QRhF7XH+tHA8/Baf+xRC/QlWrkOaka25R/AbfknCRWv
	IYxTEFJiumPYhcpQ3S406VlAsoBAGyZRD2otY9Gh962YRJLinyuczAGrwAujh7JDRfhGdb
	alNw3LMUtU0xmdvjA4hqASbiaJ9Wc0Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PMsSa8DpHjoOi6gmcOGcxYP4gI70dVR+DdX0H08nrsA=; b=igU8xHOZNj8+WBM8T2IIVwmwCe
	gtJ75h//s9qV2OGqD9o4sG187F6HHQeHnWSNY7M3PO1AVW3dZnWPL1FKD2cihapIWAdEFRCCEg8eb
	OVqiw/9BCu/zYeEhQLGl3VqkTF+yhYHdiW1WieoRhngC6Jao6ypH7+6XZHaf4T7EbP8gn1+FfhSGI
	x/kiUQ4Vl6KI4m3dK8iL1f7KQPVWo81uaXr+qfxLtnZu4mWT7aZWURHvBIpc7HW8nGWFqCq3eZm/l
	cJiguOAdO9Lal5tdBWQwRyoo7xfSphC199vM9u0kenu/ARmzPGF4Rptfdpyr5Z5pPmJjtxs0Sz30e
	iMmbv/jA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wpnS2-00000005zwQ-0oaM;
	Fri, 31 Jul 2026 13:39:02 +0000
Date: Fri, 31 Jul 2026 14:39:01 +0100
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
	Jiaqi Yan <jiaqiyan@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v7 01/13] memory-failure: Fix hardware poison check in
 unpoison_memory() again
Message-ID: <amyldelTLZNeGaNQ@casper.infradead.org>
References: <20260728204409.3396238-1-willy@infradead.org>
 <20260728204409.3396238-2-willy@infradead.org>
 <c5b01c38-9c35-468b-9fce-ff7e1e11b03f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5b01c38-9c35-468b-9fce-ff7e1e11b03f@oracle.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 199AE40005
X-Stat-Signature: 4mzr17gk4yuagg1m1jeg1fm9gdts8ij5
X-HE-Tag: 1785505147-954503
X-HE-Meta: U2FsdGVkX19N+RmTpEbtBejvbJGWNlYitIi34JQbujmo86WrwCdIXwF2FZ1Yx6DSpR0Pvk1JNeTx0OmPmo1gU/MOMLjU0oAQgiUFjOc4VCKku/kXDXnlz5U843ZXitwK/ayK/2yJhFjq3Yi2kmh6n8n5rDvP7ywXMp0loPCs3bTp3WB49veurjFdeevsijkfeXX97zuv1T4jrcdgmN3jefV0x3ZhVatfjFn+wc8kVbolUbhViLRcxSvftNIarv+UxGiGyE4ff5MzpM6tm3ykaDnFhK/MtKGHgaBndttXkFEM8Qa0EYmeF1kl8Vyka+x5TvvxcFhlBa7nG60wB14ZA9ergka/U74a25Y1tDTRBEUB8SQ+xzEGApyfH/q+gBA0IEP4BTcMas7ohaP/rkiYLm7K7oDkf4sDGmUXKRgb5oyRueRMEOe9oISLEdMgmxg1cxGNAQyy1GMh5t4KL29c5hxOqX6zTHVDjssQw3LxEcXbqDUXA4jbm48LqXos4Zjws0YU811m4B94/A9sQCFFfdOEkbM+hKBwl6WlHcUV/dib/jZBJFUZnQWBXtdCOia35y2wePvkz5OWPJnHcuEgrWJk140kA5f+X/gQw82pDoqKJs5oglOuIpDBlacyX8zM13060rmokcvvrWB9un86MInfKShmZbOsAVBX6h5geh7SGxk6OC2Ctdm8Lb7/arX3qdcQR2Ytl4V4mFNQrIGTDmBJBrxMmHCaGjVgrtSJVFMXnmKHtBytvN/9zbSU7sbAYZAxrz8yYxsuludJ88dcUJKr5ogUOVpXmJss93wbHGfS83naQoLnGRofw9YYSt/+gU3kwcVLr+s/izBujgjhTBAyyNMA0Oy+kKILzm2KGh6/1sip+VFj0RSVOdNfDRIINxu13RiflxBtlkIUpBdR+x6TAAmDLbCWNap96sCS5ZSsFk/1Hq4gcWU4GZrhvMx5WGd6QXWb8cvESMVCN/P
 TecpLZYl
 vWhZ6dH/bAqddELce8ubj2CO2f5EeXFE+2kFxu41RzZRn384XRDtcUFsMhDpwkiFku1KmyksOJLGy5VUI3/Sc3kZ9+T1KT2hNA4paiplQqlGVhEDUuga5fxeFr3DmTD7pIdHr4h0j6EjqF0cFd4ClUSgIbmSyIzLN6UOmHCd6vVxL4n7H6w+Wozcm6nYwjz/Cf1P/9AgqKK6My0Yl7cqzuKf6aYpU2To32Q64BExFFaWTJ2gOZvW46CN0qxsOuoPNKxMGj3fodnEJIuHYBqxOzeq7MsvKPFvF8sBQ9+lfoVovOP0L8t+H2XZg/Drrb1ZICw51cw9U9iUXD5RxR44WP8s1lFzf6/6xv5dBF5htnJDmiBY0ts0L5+1hvwO/HYFpS3yqKw/ZKSz6saY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 10:39:57PM -0700, jane.chu@oracle.com wrote:
> I think I spot another pre-existing issue in unpoison_memory():
> the XXX line doesn't work for non-hugetlb free large folio because it'll
> just try to clear PG_hwpoison in the folio->page, not the precise 'pfn'
> page.  Something like below could do.
> 
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 51508a55c405..14915718ace5 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2730,8 +2730,10 @@ int unpoison_memory(unsigned long pfn)
>                         count = folio_free_raw_hwp(folio, false);
>                         if (count == 0)
>                                 goto unlock_mutex;
> +                       else
> +                               ret = folio_test_clear_hwpoison(folio) ? 0 :
> -EBUSY;
>                 }
> -               ret = folio_test_clear_hwpoison(folio) ? 0 : -EBUSY; <---
> XXX
> +               ret = TestClearPageHWPoison(p) ? 0 : -EBUSY;
>         } else if (ghp < 0) {
>                 if (ghp == -EHWPOISON) {
>                         ret = put_page_back_buddy(p) ? 0 : -EBUSY;

I think you're right, but this isn't a bug.  That is, we're calling the
wrong function, but in this particular branch, we're guaranteed that
'folio' and 'p' have the same value so the same bit is cleared.

This is the case where !ghp is true.  Here's the code we're looking at:

        ghp = get_hwpoison_page(p, MF_UNPOISON);
        if (!ghp) {
                if (folio_test_hugetlb(folio)) {
                        huge = true;
                        count = folio_free_raw_hwp(folio, false);
                        if (count == 0)
                                goto unlock_mutex;
                }
                ret = folio_test_clear_hwpoison(folio) ? 0 : -EBUSY;

It is my understanding that we take this path for hugetlb memory and
pages which are in the buddy allocator.  Buddy pages aren't compound
pages, so calling page_folio() on them returns the same pointer, just
cast to a folio.

Now, I do fix this in "hugetlb: Use the has_hwpoisoned flag" (because
nobody gets to use folio_test_clear_hwpoison() any more):

@@ -2733,8 +2756,10 @@ int unpoison_memory(unsigned long pfn)
                                hugetlb_unlock_irq();
                                goto unlock_mutex;
                        }
+                       ret = hugetlb_clear_poison(folio);
+               } else {
+                       ret = TestClearPageHWPoison(p) ? 0 : -EBUSY;
                }
-               ret = folio_test_clear_hwpoison(folio) ? 0 : -EBUSY;
                hugetlb_unlock_irq();
        } else if (ghp < 0) {
                if (ghp == -EHWPOISON) {

so I agree with you this should be fixed.  But I don't think it fixes
an actual bug.  If it did, then we should do that first for easier
backporting.  So if I've got anything wrong here, it's worth saying.


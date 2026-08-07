Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5555BC5AD2B
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 01:19:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 724796B0088; Fri,  7 Aug 2026 21:19:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CDFD6B0092; Fri,  7 Aug 2026 21:19:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BD536B0093; Fri,  7 Aug 2026 21:19:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 195E16B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:19:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5129F1402A4
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 01:19:09 +0000 (UTC)
X-FDA: 85076343618.25.EF69B05
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id B2E1A1A0006
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 01:19:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=l3LIcieJ;
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786151947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rMyxG+nPHVxHJ1KM+yO+RxpMBhOYpRjh117VjJdqmNU=;
	b=RoLVaHpYazHMHaeynw770tBXFQuV500WGk4ImWsdgBjzemfIQZtY3UQR+uz8RvIy0IlZq3
	0f/Z1fKGwG1NOFMAeav6bpeKtL53z8nED0Jjl0HAzWBIIv1VA/JgwUU2NPQPDvUyXTCbge
	WOWdL42z14pX/Swv7yh1m3+TAexBTBI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786151947;
	b=cD4L6gSls7Y9w7ZZMXy7ilfTEco0RGGGeMAiHjKbKGijXLFDPKJdu4qX0txagGftoLVR1n
	4LsnMbSI0b7d295uJtdr7hpZa+tQdoIEkdvMT41x9v694K3tcLGXaRedzMArysSmOW8+dp
	O1V0lrRE6asAPf4uMCJXCSt5c6v3Qww=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=l3LIcieJ;
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rMyxG+nPHVxHJ1KM+yO+RxpMBhOYpRjh117VjJdqmNU=; b=l3LIcieJ6AXIOCMvvamI+rcA+a
	XujTAm6DKG3jXmHB+i3ylb9K6h+eYDeuyBYQ8pdC9TyfSKe3/rQXPgufJoCS0XWnne2iyslYPuZWn
	8TwuuMIaHNN+Osyife+4g8Oxsg8MUYkhViFfmcKps9AQ6CAMEJFJpI8p6D8FXRlNQ02O9FcDUSqoc
	0i6zF64R3JZ/iLxFdjb5laolsf3/ZxcYu2+TJ1MokpuXDnzlQStpTNwiBo2mZy6KGcChSvgmBx78O
	1dZLZVllADx/9PPwhvG4yYS0ADp6KtOncFpy8OvY8bEsf8AhBDtrJXDDGUgvsgG11oDXVLKqzanCk
	208+cZOw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wsPsK-0000000Dbim-3pzX;
	Fri, 07 Aug 2026 19:05:00 +0000
Date: Fri, 7 Aug 2026 20:05:00 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tal Zussman <tz2294@columbia.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Christoph Hellwig <hch@lst.de>,
	Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] mm/swap: rename __swap_writepage() to
 __swap_writeout()
Message-ID: <anYsXImJ86OY-IZI@casper.infradead.org>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-6-0899bac3b826@columbia.edu>
 <anYPVB3dwJCVoXVv@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anYPVB3dwJCVoXVv@cmpxchg.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B2E1A1A0006
X-Stat-Signature: b84iht8o9sthqy9oqhou9y83n8ftn4z3
X-HE-Tag: 1786151947-174552
X-HE-Meta: U2FsdGVkX1+kq7CQq5vYvZwSyHHRlAsZMzWsH0z9CJ1Lpe4v1kMh238NU4K3WVZpTrQNDCX8EWDWTOr/3M6XCA/1sHkSJlXtEdKD7dggVhZ4CP8OtEReQLRPQ10sRQ5dKe7h3++WT3iEKaB1Csx4cv8x2d5P9kA47e7BWwZZYmndESWYJ5ua3UIE0XqWRmZCaBnWOwqjT0Xy3hPVYy1AzTjLN0nhhq9RDMh0oTIt/5pZdWbZbQZA+osPLxgGTeZwfbvYIt8aCc3xojWz0tp4zyEJWrVPIm+yK5l3J21oi1t6iWnXH+vk1i/3B1I7iV0mPeQgYGSXu/ZMTSf5Z3Qpx9CiAx+yku+lk53/WKvyNXPBsg3q4aqBN1R8TeJ9rWX0B7ll0BXgBSl+i6YEvHcO4D3Uc3zHO1trb9OsE3bl4qpHSd+oHlUSlNq462HY0X0g7cuZUe3KtB/ay2SZD400T6kMPTnn35IJhFV6+o8V54vwykpeVqQoquOk7sgB+kwtZYxBMmXhrj4sO6BTPUY+kESB+e/8ejkAl8Ic8B61vSbHJezDbslxRM+MrrqRu75RSZsj7T/h3aEpA7uFccWTdVTHJ5XsYFjJ6q9EIBBMPxjexH9W5EPSZ0bbu+BJGwlHmqnHGZ87NDPwMzVyKmO2lVoGieBDqOq6/6BXNyvV8h05mRfgcQizHtDV85DXy0vydewwVPEMzRtsGWJNC+uxBSy0kS0pJ1seMoaUbyokvIIW3IiPxnUfFxRRc1k4DvGKouWNYAMEerldacT18y3RetbSOSnE7koqMgw0BLKnPIXv22M28x4TZfkBhxEdKiPuVxCEqzB7L7eun29/lHaylLseclbCuG/NxWXiGw+xwpJQAT4NdpumXRtsPqHoxNziZ9fN9D/8rXS5cq3CIE5isF7XeY/a/gOeeZPV48fKEzKS4R4iWDWNye+TXDN2/EQwGYHx8iyG5BsxG3nBdxQ
 bG40SVix
 RABoT91MSrHgdhB/il7c5XZNH8s0cOskZGkJ/Wby4zs4ktAk9+v2HOFkyILbLSuEFZ7eFpSK5dNVbU9trz52ReyNi25/uQSqcTFPMkqc8IAtH1R4fGXYclvdfj+AfhMMUihkvz4VoKEEpzcF31+iz3yt3YQCJn0Aw0TKeOAszloT6OYqjAzsfqenEpfle7v5lRu75HptC3mi3Bk4mf92qvN59MR4im1ZXw2TSxD72LFVfImqg3qXqReVsOt6nDueDHUC1iy0ZMzNdxF1OPtTSgL6BR104wkiwwUI4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 01:01:08PM -0400, Johannes Weiner wrote:
> On Thu, Aug 06, 2026 at 06:55:38PM -0400, Tal Zussman wrote:
> > Commit 84798514db50 ("mm: Remove swap_writepage() and
> > shmem_writepage()") renamed swap_writepage() to swap_writeout().  Rename
> > __swap_writepage(), which operates on a folio, to match its caller.
> > Update a stale reference to swap_writepage() in swapfile.c as well.
> > 
> > Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> 
> Looking at that commit, I can only guess that pageout() had an
> influence on the swap_writeout() name.
> 
> However, on the read side of the page_io.c API, we're following
> swap_read_folio* consistently.
> 
> [__]swap_write_folio* would seem more symmetrical?

I wanted to be sure that filesystem authors see this as something unusual
rather than something they should implement as a counterpart to their
read_folio operation.  So it was intentionally asymmetric.  I'm open
to discussion of better names, but my hope is that we get closer to the
'do direct IO' model and shmem doesn't need to swizzle its folios into
the swapcache to get them into the swap system.

> [ At the risk of starting something, should the file itself be
>   renamed? swap_rw.c or swap_io.c or something. ]

I'm not opposed to that either!


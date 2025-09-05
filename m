Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FD0ECA1012
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 03:25:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9476E8E0007; Thu,  4 Sep 2025 23:25:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F7B28E0001; Thu,  4 Sep 2025 23:25:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E7388E0007; Thu,  4 Sep 2025 23:25:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6A6A58E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 23:25:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1E15516010F
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 03:25:20 +0000 (UTC)
X-FDA: 83853756000.23.395BA44
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7BC4B8000B
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 03:25:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fU5nbkX3;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757042718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MesJNkOvq9Wb1HsUV/prYAwe2kfli+4DW5QClvaxYC0=;
	b=WTqSEgJYs51SY3EyyGqjNlEacjBA7pnmbsFD0vR4XitGfN/pCn7WqHaceuimDFhGkkSy7p
	iiaRYp0ShrxC760yXpeuIKxiTfm26yoQzmgCu/C4vVdnHSu32vHEC7FMTqVh7k1cUb8Ib8
	PVn7kjmTZcXmcA2edpiOF21jD5mSssU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fU5nbkX3;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757042718; a=rsa-sha256;
	cv=none;
	b=C/jzGqCib7OVq5XAs8oQDIXU+lvcky/hByYRH2hcLfqTvg+1zHN/DSI1+KspSpMW99eWnL
	gvKxkU/mJwUDZPJHuUpMrWBQVPE6QJHM9/YQXeWuITK3qECaeMq3ZVIJ6si0JOo0GZbY/2
	E2ZmYync/6k3KhHifycRbRX7i/NNk1s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A255B601A3;
	Fri,  5 Sep 2025 03:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09907C4CEF0;
	Fri,  5 Sep 2025 03:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757042717;
	bh=7qJMpdvaIN/eDT1GmnJzpsYiZoU8MetcVjdUONSfLOE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fU5nbkX32e0+VE4qXAWqMKWRgi9ZgIB1nFXjoRReIewPDwY1v/WGVKsi7/c8nUdZ3
	 ES7L0gFLOt9k+9hNKNXYMO4L3DLn+ko8Xp8d8Xp+6ZbpCg7BO/2KenKBhrsgXmfn5L
	 elHpJp+Y6Ty5Rq7qyOfmkap2oPNmTgO1ed3fhVoU=
Date: Thu, 4 Sep 2025 20:25:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, Johannes Weiner
 <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] mm/page_alloc: check the correct buddy if it is a
 starting block
Message-Id: <20250904202516.3e091ef653fe5a2d9adcfc1f@linux-foundation.org>
In-Reply-To: <20250905031129.lgipzjwz2swhxlg7@master>
References: <20250904020654.28689-1-richard.weiyang@gmail.com>
	<D9D94987-8A36-41F0-B0A8-3BB47910223E@nvidia.com>
	<20250905031129.lgipzjwz2swhxlg7@master>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7BC4B8000B
X-Stat-Signature: a97zoutbwjz4k7moa9bj3zmeiu35xuhf
X-Rspam-User: 
X-HE-Tag: 1757042718-283549
X-HE-Meta: U2FsdGVkX186k8qzfZhf2624WzdI7o7sQxVKDWLl3ZdaAw00s+XdAILHvn+A/A61F0MtAOOuH1RW6SqJAeMLW3u1fv4owUetyJ2JLrTZDZD1ZKKNrDKjvA+rDPe1PuraFxtVqCJZlhvw452Fa3JWK519lpwcwOIqyuSZjeNZ8U4hdHOKj8ZVohv3haEwvNiDW9FDf+UwJlikRv/KG3JaN9k7JmpG6mBuZpFL+8cdl0gUtBqOWx/uFHyLTIVTIE6S992FyH0uWjCTVbEp0X/4Kp4rfP0zUGWgoxZwaodCquYhPbEyIjYSnwoqbuuJ58SMlPrBMuQM1H9w0ZPq3o9o5VNebZPnrJbc60uJ7BJIYfRrX6jdoUxwi7naMPypMFAhOgOQdYlbA1JCgy6dsQnmDTyMF/EZVYil+6YjVxnZdXanh1aI/93nDHBhgi+q+MmmxGrbwl3cNohAbJEUiAJLB2uvbD+lSQ76D4wAGVRHOE4vYr6kx2kFE67yX0PKCzwAVOV8yP/jLCPLfW69zyNH94BjJacXTw6Bw9uCd25T+zAtl+ZU7t2/vQgoU82EDai6J76fVt/adgl8VnA7bvkUpAqFu4Ix377qxjZb/0Q1BX6zbnXn2/JyHXq1r41M9XWWr9PIPltmto1pe1OGH2WFYpXfL4JmOk28+OQgQRcKcCmHmlLQza/V220eGpFwcvflJjQVziTNt3hGC9ka4ZjedylZBCCsi2FlgGrCl4qkaADcqRg56TOHaIwKn3w4V79KvVwM+r12QYnpqZBQJqaJP4ZGoKUjCVyVM12UiMhRy/br2TO7twfRQ3xUWPmaSsGofAvbwaMelis/W4X8dS/abr0kedWv0w0CSluFbyG0FHxsl1RgvIaxhsJ/pPK6pj0uDFA/s8uOvkkI+5xhRle9WfWaKvgseOGKWmdALmbZ4KuZrPYANrZ62AIDScQ1t2gSmE3ZwrOx5jdXFFq0LaT
 6XImYFKz
 g4qAd8jsw7h8Bw+nAVaV7XNOQeWbewGjyULdzGQxe92+6q8awaVwuUiyQNcdnPeuNFb4g3axIqLjlKSuWtVqLuDruQwi7A9DPt/su4xGzaiuenWhI32Ih7eKtAqYq9MOGjojZodulOjTqY4DQbQdJZ2cavOYgzZ/mDu2Bwueez0bkzxJqvITQAZpwVjR5a/vKILij7wHNom4qzVcZ9y06+sX6QMtGertd7Ub60rLRdgHcKl6auv0rD4T5MT0x769zI4VLXYgigbIUMlkYFXPcZo/gH/x8qcQUlNPeakRw1Tg7cOmW7+vw9negtGkm4Kp3rvajbXr58sPPQxijqDvEJg7VY27lZ5ViQvhl3SXFfCP+biGZ0lddMGeyPziVUZZhdyRdtcHbQYQbE3N2rAvQcvVLnvest2LRUFn7bmU/SAEdlPVLmRxdG2K+bVtpDLjPuV7KiRRt/mC4mA5CR87y26AuRf0aY8tl24BcE0Vpk0ceRTkeUfZcMC2UMgiQhh5neBfgbR1wuCI3+6TofoYho3UbiCBUulolA4CVM8emNb/bHHl6GpO/l2OODD60v8gJmej2StnqNV31CW4mFYUyRKAWPVA++Xlz/oe+119JX/dMVlTMOc1XX92+Rw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 5 Sep 2025 03:11:30 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> >>
> >> The good news is the page passed to __move_freepages_block_isolate() has
> >> only two possible cases:
> >>
> >>   * page is pageblock aligned
> >>   * page is __first_valid_page() of this block
> >>
> >> So it is safe for the first case, and it won't get a buddy larger than
> >> pageblock for the second case.
> >>
> >> To eliminate the ambiguity, unify the handling for starting/tail block.
> >
> >To fix the issue, check the returned pfn of find_large_buddy() to decide
> >whether to split the free page:
> >1. if it is not a PageBuddy pfn, no split;
> >2. if it is a PageBuddy pfn but order <= pageblock_order, no split;
> >3. if it is a PageBuddy pfn with order > pageblock_order,
> >   start_pfn is either in the starting block or tail block, split the PageBuddy
> >   at pageblock_order level.
> >
> >
> >Otherwise, LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>
> 
> Thanks.
> 
> @Andrew, if not bother, would you mind adjust the changelog?

This?

From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/page_alloc: check the correct buddy if it is a starting block
Date: Thu, 4 Sep 2025 02:06:54 +0000

find_large_buddy() search buddy based on start_pfn, which may be different
from page's pfn, e.g.  when page is not pageblock aligned, because
prep_move_freepages_block() always aligns start_pfn to pageblock.

This means when we found a starting block at start_pfn, it may check on
the wrong page theoretically.

The good news is the page passed to __move_freepages_block_isolate() has
only two possible cases:

  * page is pageblock aligned
  * page is __first_valid_page() of this block

So it is safe for the first case, and it won't get a buddy larger than
pageblock for the second case.

To fix the issue, check the returned pfn of find_large_buddy() to
decide whether to split the free page:

1. if it is not a PageBuddy pfn, no split;
2. if it is a PageBuddy pfn but order <= pageblock_order, no split;
3. if it is a PageBuddy pfn with order > pageblock_order,
   start_pfn is either in the starting block or tail block, split the PageBuddy
   at pageblock_order level.

Link: https://lkml.kernel.org/r/20250904020654.28689-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>


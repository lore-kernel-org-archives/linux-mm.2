Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0B5BCAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 20:25:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21A9B8E0003; Fri, 19 Sep 2025 16:25:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CB298E0001; Fri, 19 Sep 2025 16:25:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1085A8E0003; Fri, 19 Sep 2025 16:25:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 000968E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 16:25:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 87BF2C07FC
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 20:25:47 +0000 (UTC)
X-FDA: 83907130734.06.80F8062
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6C28820009
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 20:25:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LLMYRkHR;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758313546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/81rz7H4kqTaEJg0yrE1nrKWbw0pt0losxc3+BVs8Lc=;
	b=YRdz+1C6B026KZpqepl5FGs93sEJtx2RIHr4bgajN6V3Ep2uDK7koDNQV+cmTnUAMAX4Kr
	KGcGC5hmxkMFY0eHjXprhJ+osl7r4YdwLJXg9E1geemXf3jlAy+2ZeAZ++ayqGGsw2Oq0/
	7Q/mL643wyV+mIfERAYamNVu1tf/5jc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758313546; a=rsa-sha256;
	cv=none;
	b=i5q+GlMxodR3ceCMXfJuOp9K1cS+q+hVSnmbynQZKe4nw8K2nEk5yUEZ0Bj7cwXQvlnwDJ
	8142ZfSNwaff2ptWZjAvyoAEoGv18O89cPLr2PQ7MbUjmQHQSYUh68Z0AN/BW4Rcwpb42I
	ooHvCH94aNtl2/2m5WoD81uKDt4EUuM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LLMYRkHR;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 19 Sep 2025 13:25:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758313542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/81rz7H4kqTaEJg0yrE1nrKWbw0pt0losxc3+BVs8Lc=;
	b=LLMYRkHR5n7vXVAXvJV9hjvFVosmqxbsqFx+Fod17CetTBxu6rA1oalNfEzGU8mnyI2EQT
	1mQdFOvMyEw16EGrH5WucNVGz9a6dEFHl/hswH58yiZALYaMvWiQ12v+SvzBAqtWDJzNym
	C6M+WdHy0QcyYv0sibpKNKcsViJYB1A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCHv2 1/5] mm/page_vma_mapped: Track if the page is mapped
 across page table boundary
Message-ID: <7qkpt4ia3qryjp2xo2ywy7qydav6nijghasr7biwctd5ah7dat@t3epq5dzt2sd>
References: <20250919124036.455709-1-kirill@shutemov.name>
 <20250919124036.455709-2-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919124036.455709-2-kirill@shutemov.name>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: h1m149uuun4zfffqz4iir7aop4pz337r
X-Rspamd-Queue-Id: 6C28820009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758313545-611492
X-HE-Meta: U2FsdGVkX19lD3hbdLFbai4W1GdxRcL/pjsM7vUjVjvUjLv2Ae0XpsjBsdIahKIiF94r+p6AveJC/plC+TUxggo0B4dXTfeHl19NN0a8Rf9dK1keKrh/dknz4D9u3mFP8fS6LNTUcu85uVcxTXfQUHk5K/+WpVu5XV7jbdVs7UlXtIAGDkxUyrRwc7zPgyPJngk+7CXqea6uaXypvQ+qxffrqT17vBZXslJImdlRLGXhJ3X9FE+45E9dgAnHASJ3MCrUdOXoUIZMJdRxOYzqjXVWGsogAPocIyTXiAyp1jn/fbKFJ/8yTtxcieQIlYNsqyNg+VA7QQ+bYVcCSME7zeDUQNJLIDNkTa3CKJ+Z/Df1imaMrh1kZofHkfL5VhZAEZLBYIzeWH3lJKaqTrHMP/9BdBYCV8Pg59IRK9xlKxV9n8101L/rVO7GwL5MqpQEgG8E7zX+dtPk+zxk+zQqLT/CQfRvQW+bTpGF0Lkhxim/SOhCV+/kPQ2Wxy3NESNEw11d6QyDxhAqvKDCLLXbjw0eKQ4unnYGU7pOfue4JqH4u/O9aSa13WhEORglckjOdg+82m37OeJI98oIdSVydDJwd2Dam9QX8eNnGihjgzd7gUanhebcb/WtR83+8VS2VL7GkTCr+02RUw342fBoRszHsrpJ3qvVQ5gtOAzN5HQvusppmXdDEiYSMH1WnasUc2ArlG2nNdLianKXNk70VdqpDW89znE9icEmQ976twL5GNvjGjV0wUImKLRNBzd0FdIAZNf5vh5K0x8yfZNeTL99tCy9TpaA6M0Ff1Xjvr9M/opHu3ybgTRMyCOnzoHvsjlFIYsELfilB2NYNO667unqc5lAzD81czuebjhVJLwokvYt/jVhZCv7RGDmFm0vZ3SEpvNquQ89a2UbFW0JwF+CZowJnZzbaKnGUDb9LOvzLfouBIdBv2Cu8kYW64G0y0BBZSp/S+CFlJagL82
 XGQuhGuZ
 QQV2vPLgFtnlqRj/aYChqIi9qSCu7sO3sdSOJKR+GoDJkVAz2jL6eyxyIPWYm5WlV3BEu1J2AACIydf/E3HGbCjdYAEnm5usmZCgHd79bAGJvXK8NIWTIdozT0mDitXndCbXPB1yDIIlsgKCIxW2p+ZZvn8LcpHdPcRSzRaFyFdkyreS1tqqfAGgWFAImcO+PuXHDp3P2dUv+3hIXsCnChRousP8cthz8GYI5Ha9jKnOz44LAutynL59VQyWI2kYStzgTPpFExRc/nATEBElmMRJDEryJhag4LOZfxKbl3ncI3JFR6nKSbykiZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 01:40:32PM +0100, Kiryl Shutsemau wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> Add a PVMW_PGTABLE_CROSSSED flag that page_vma_mapped_walk() will set if
> the page is mapped across page table boundary. Unlike other PVMW_*
> flags, this one is result of page_vma_mapped_walk() and not set by the
> caller.
> 
> folio_referenced_one() will use it detect if it safe to mlock the folio.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

> ---
>  include/linux/rmap.h | 5 +++++
>  mm/page_vma_mapped.c | 1 +
>  2 files changed, 6 insertions(+)
> 
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 6cd020eea37a..04797cea3205 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -928,6 +928,11 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
>  /* Look for migration entries rather than present PTEs */
>  #define PVMW_MIGRATION		(1 << 1)
>  
> +/* Result flags */
> +
> +/* The page is mapped across page boundary */

I think you meant "page table boundary" in above comment.

> +#define PVMW_PGTABLE_CROSSSED	(1 << 16)
> +
>  struct page_vma_mapped_walk {
>  	unsigned long pfn;
>  	unsigned long nr_pages;
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index e981a1a292d2..a184b88743c3 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -309,6 +309,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  				}
>  				pte_unmap(pvmw->pte);
>  				pvmw->pte = NULL;
> +				pvmw->flags |= PVMW_PGTABLE_CROSSSED;
>  				goto restart;
>  			}
>  			pvmw->pte++;
> -- 
> 2.50.1
> 


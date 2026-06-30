Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80A22C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 02:06:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C4C06B00BB; Mon, 29 Jun 2026 22:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A0A86B00BC; Mon, 29 Jun 2026 22:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B1CB6B00BD; Mon, 29 Jun 2026 22:06:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 250D16B00BB
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 22:06:21 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9D9AE8D24B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:06:20 +0000 (UTC)
X-FDA: 84934939320.28.BF1665A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id D1A3B1C0002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:06:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QCs3NAS2;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782785179;
	b=As9dYTeNmxg+Xl0f7ruG/9eoU08D7yLHzvzfSYLAn1JQ12ybY8tvGa8HAFfAWBDDOpr/r4
	P4z6zWmNbQp4OhC3xo9Ria60C3fgU2HQi1WgovsLbNFOaW5ujKEMjv8oN0OJXBLhci1A5E
	OA8PNWpg2bX1iPdURY6ZleQjt8l5Kr4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782785179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rD5wn3y6pfZZI/1rm2gg6/ulrbyEbDKCWoG+zNkRuQE=;
	b=Oc7xAFGU2nMepwvOtdH8GQV/XJFEHpJTnUW0OBBZXy329MeOvUqstfR03p4nqW7r15HL00
	LcEhw4tzAMIs9+V4eGW3HnTkADfo6ZupS3st26Y1cScZGHMCBQO8b4zD5kMzD1CA8PhcF8
	LYTL71NwYo0arC4qBUcFax8ZVcyDY7I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QCs3NAS2;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F74A60008;
	Tue, 30 Jun 2026 02:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F871F000E9;
	Tue, 30 Jun 2026 02:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782785177;
	bh=rD5wn3y6pfZZI/1rm2gg6/ulrbyEbDKCWoG+zNkRuQE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QCs3NAS2bA36DHr0nJ7QLNItTku3uO9C2kdjRRHdNMz8p7dUw5DWqvjLaZO7k8hfF
	 lt5K7s3uKMQrFCIhHs5DMnGLWqJZnlhUr/HgOKeKT1FNx7WxP4pM3X6jpq11G56JVC
	 hIgiODJRmll5gGyK9GZ+Vi4EHPnoEDImyXs0XkGw=
Date: Mon, 29 Jun 2026 19:06:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, Yu
 Zhao <yuzhao@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: free allocated PFNs if the range does
 not match
Message-Id: <20260629190616.050ab4e309669fae250c6c37@linux-foundation.org>
In-Reply-To: <20260629-free-pfn-on-alloc-contig-range-error-path-v1-1-496ff9ca22db@nvidia.com>
References: <20260629-free-pfn-on-alloc-contig-range-error-path-v1-1-496ff9ca22db@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8cowmkyf1i8iof8wrraugtodxzrt4guo
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D1A3B1C0002
X-HE-Tag: 1782785178-398333
X-HE-Meta: U2FsdGVkX18p51xVDoow/Mo64CrViZPv1BlZS83iLAzCw13xpfGhQvhfUqlVLHNZPTBs9QIva4fniPD6XFAg0dIlcjf/RIKrl2eE47fpyXlhYX3IuDuRRMjyhTveSy7xeKT7o/uPeXfk1NAwktZMVO5WRkiHefpwP/WaEmMLR5gqgwoKLtiI189fmY18j6QpH4E1tvES7GyIdPpJHnt0W6nv1eq/4HtIUJrU9R8M4fyVkkX4fdX48BEwU16CjYc9ax7iECixGxbT0Rva9fIr2qZHkzC3m2//0r/kG3MreVHCDXF0a63dj1XLqDxvZH4D2K6huMtCCAhAlaRL9wEsD/Dbe87jYosu3XYscZcxn/1CeqmP2xZWh+ftYyM4eQrf2QBJJ6M0zvCc8nt0auWCY+HXy+IBZjIge5j32zo106ttVZ6lAgciNb/PiNX5ybEdye2KYcVFXqsECq0VPYnd5QQGpZl+Xyr5fKp7TLEW8VZBLXsaPAHXwRQeoqxMKJrPXztBiXTeXjXvr0LGN1281BLgzBLhs4+jZOEue1BNpU/w5r1Wn+Eq8zF1/758olT+/DrofmRq43SJNDTk4bElfp09PoZHM2an3uhlTqoHnClpp4fm5jfOnvXHBtdImnKzX7haZ7vcBjdN6wyJVaH9y9KMAuggRkAjd84F66DsBCPdXAgSMs5ESsTEm46JBPMHnrKblo8DCD1Mg6KFNHAiMfxe84rrR4+8TzDVrRBUqO2ZXdcVwV5EOc1+rGm0OVXCVogBu1gSL6SPKcCPuYPWAeJqhd1F2uG7pEQbm102IDthNhRH0yEEFEJs00bTaWnr14gk/GKD5TI0McrJyqZbq+IugPV0zlk9MiQeuGF8vHiVqifh7vY/C0IrvObjah0HMdsHCc/Is4k7cExS67TLCc/3Z+C8X76BYHhcpmaDDi/URpqW5mFilJ1P/MIfycnMTZs5OgJ3KhCOqG06L82
 XbDZ+SpQ
 u/T4V+mpFReYGQbXfAD8yC5b+PZnoemXR49o3IXizBqpgKl6mf8LWpfcm6NI1nOzqGhDo2Ih2+RM6mfqmpZlWVBOzOz7Y1rPrzORKi/k0HoUyww7sgulbG311falApWt3EVMgqXsbSHJfFU2YjAkKND72HcGHLjIsHFab23WGWaq36YyZuHxSqL6kbahSqgWeGawzgcJfEV1eky+b4BB5DGCy33m+m0Kd9H6Kk6H+Il9ZplfJkCTPjEGemSxHVKBCgrh7rsqf+ib4PiMJ4dJM6f/cWHKddVhMhiV8mrDW6Om/WwHg0JiyQe5u4zPUwcW7QtKY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Jun 2026 21:35:33 -0400 Zi Yan <ziy@nvidia.com> wrote:

> When using __GFP_COMP in alloc_contig_frozen_range(), if the allocated
> range does not match the requested one, the code errors out with EINVAL
> without freeing the allocated PFNs and causes free page leaks. Fix it by
> calling release_free_list() in the error path.
> 
> The issue is reported by Sashiko[1].
> 
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -88,7 +88,7 @@ static struct page *mark_allocated_noprof(struct page *page, unsigned int order,
>  }
>  #define mark_allocated(...)	alloc_hooks(mark_allocated_noprof(__VA_ARGS__))
>  
> -static unsigned long release_free_list(struct list_head *freepages)
> +unsigned long release_free_list(struct list_head *freepages)
>  {
>  	int order;
>  	unsigned long high_pfn = 0;
>
> ...
>
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7235,9 +7235,11 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
>  		check_new_pages(head, order);
>  		prep_new_page(head, order, gfp_mask, 0);
>  	} else {
> +		release_free_list(cc.freepages);

I wonder if there's a Kconfig combination which results in this being
undefined.

I couldn't immediately find such a combination.  No doubt we'll be told
if there is one ;)





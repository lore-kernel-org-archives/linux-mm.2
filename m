Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5B35606C68E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P/GKaWaZ
Received: by kanga.kvack.org (Postfix)
	id C5A206B05BE; Tue,  3 Nov 2026 03:35:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0C2D6B05BF; Tue,  3 Nov 2026 03:35:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B473E6B05C5; Tue,  3 Nov 2026 03:35:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 952836B05BE
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:35:02 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1F36B1C37D1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:35:02 +0000 (UTC)
X-FDA: 85393147644.22.000A49E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7EDB0A0007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:35:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P/GKaWaZ";
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793694900;
	b=Vo02EALqEQPe+tzGe7F6acI+JukjYSLcZxc0HKYLIfmTBSfuLo784YdMT2fitc0hsYDsZF
	xnXL+jPngdms4yU4aP2Mdy1S5tur8/uaDE4NsGb8AuPlZvgvous6XsEj/H1CbbV6rzI+OG
	ztacBXRXLdg8iebncKWigs7xfCDrdDQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P/GKaWaZ";
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793694900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MbkXDHo1xuZzdIbJLfCFRMeI3qreXHQVaX0Y035ar6E=;
	b=7LZmoZo2smmaLcjYVZliOlAYxK4hUG7UaY7lug7kRJeg5kW2UhGbHIGK1Orb8DvZRsNmOP
	vcSLqrNMKTkDXCZWURKDE4Wy3MB0KHEwu5JvUC7rRIl6//r3muyIHU8QnqSBKsWy1Tk4wT
	/uwk35R1uE1ATeJYZMozYT0mIaYRtm8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B10B540597;
	Tue,  3 Nov 2026 08:34:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97B01F000C1;
	Tue,  3 Nov 2026 08:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694899;
	bh=MbkXDHo1xuZzdIbJLfCFRMeI3qreXHQVaX0Y035ar6E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P/GKaWaZ2XZPjdPtX0xj3DV82aPecbQdBJ09rmkt8WdtG6oEJWZfgDu4oU0v7TGQR
	 DZ4+KCjo3a58PVlZecgdBRRUdjFxTh9NC3jnzhYKSezGnP4oaR5AT6EBUaVhiq/GHn
	 DywN9Ru1M17Pcsw7VPrEkExKy8MY7Nya3VidCc5XAv4dgJje0bJPIvbAgVfEKPKQZO
	 zKNaKOaUvNpkBGXEWrY4VlCBSpAzYfvCIGsfaPWFblJa1imMI0UWvm/UHPmSZ7ziE0
	 sW4G1aSC6kh7MF9rTlMqwf0zxON36NECN9ONOcBW3Xf4XGLAEngsUVqN5dcP2EDQzN
	 NFCacvWwboiRw==
Date: Tue, 3 Nov 2026 08:34:51 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] mm: remove attach_page_private() and
 detach_page_private()
Message-ID: <aumcoUqORACOXqFP@gremlin>
References: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
 <20261102-page-wrappers-v1-4-e7280bdb31f6@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-page-wrappers-v1-4-e7280bdb31f6@columbia.edu>
X-Stat-Signature: 5jrjbpo95ib6thszm99jf1h48koiidcn
X-Rspamd-Queue-Id: 7EDB0A0007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793694900-192644
X-HE-Meta: U2FsdGVkX18jtzHY8HM2KzVewsANSxByj6sWU8xgLjrTVhpA6QobnAAFYs5/SPbLf8U7bFF0aZTszK+V83KNKYf0QZ7qcMM3PKbsjyn262tEe5H1u8SMByjzh78ymBbkjJCuYWmbSCqPO2tto0Ic8BiVoeTp4KdMalSaRKk25jauTyV7SwppYYRP4oyv4+XgzyKuUHnQxFu8ayi4iR4HdGdGu64hYoNgIkkSEvjwYTGXUskjoQp972qI5ndtvBpgaqNOOAFS/YUZveeOZU4l+9nDXyDNU0SYW5JOYMCjZxU/ervvUZdudeNhkpu5T5XU1SpeQnXoOI3WW07CdWWshz8WgEDDUCsdcQibCSDT5i8Jq4206Bnsr1ZLYhyGr3dW8QPKiKFAeiSt7VfcYjrazfepbouraj+SvJrgrQMV5YnhEVeSUpkXjIFxiNKpyoJMWtrhQmzCPIHeF+BxnP0IZ8z7hLTVMnT5DUdhjLmG7ig/aF6UScAH7Biv9CgskFLHIsgEUNHJkXXF9Wl8Uxn7AemFJdCr/U0z2gZJIc2jVNm8et226l1Xr5ia7FjIt4FqZ+vu9nJ+vOoMh5sZ4MVxemR0RXtI6Q6tNlkOUxVWkndCsTDA94h+lmfza9vcH6TBzaQDJ1T1w74rAQ1qXmpveM2AhTKLtek8zGswz0uPZMQGtsnlSCrd8rIsVia5O4sQhmHFqXReIQs9VMhbxyXDIDGgDR6N8iU5FvKJn/Ov+7xkVNVJ3mj4UPkrMFsnvjsqFn77uJXAJOHoOidYNy4cLYF8cVAgeMrGqjybrAHEXIsO/uM+TpdQ9Er7gE0Z4jBGt+Lz5NQO0IqLehRTBzaz79ahUFMPsM9+0A1maWOdvWv+Mg7wq1eN0LGrkA9Tc9E/mUxJqlXAekS62ZnEvt0dN5flIq+F6apWQqS8sryKIt0q3NxT3jCsMDOKV81qb4n+ClHB0hiilW7DQC0W/do
 oNe/wqGr
 vGki4jyqc5I06bdUH+0pWEerqYrPvu9R/OWi8trfb8wHmkU0d144yQQ0kfvTFCjNQC0SYf2GlWUt6x//NNLCa00lhBertlzJa1hUwYMoylz+4kdogTsF7yDh3hj0BuU0EXcuHI/V9X2QETfhsZLgS+WSjOLTD3ifI+Wy3HlG4ZbF20x+bVUR/3/Pkl/gbN2va+9wA2GRXQVj2gGWYGKchrtnE2B4vT4sdcy68TWCY67vAV+38MemPosFgy7bpyb0iNIvqiXkQ5rmQ9wfgjfAgwTKOy6uLDWX4qoUxppHaSvW8lL/QQ7nWGW5tUeMvhDoucZmWAdzOogxFfQtM0I9hZBkXMPwS65OrI2PXDZgoEbrJeXHr4C/kuXQ0hvjcafMULBzOIu5U0I92OULaY3VEVdkm9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 05:54:09PM -0500, Tal Zussman wrote:
> There are no callers left of either wrapper. Remove them.
>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

LGTM!

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/pagemap.h | 10 ----------
>  1 file changed, 10 deletions(-)
>
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 9adfeae2153c..37b7786350c5 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -635,16 +635,6 @@ static inline void *folio_detach_private(struct folio *folio)
>  	return data;
>  }
>
> -static inline void attach_page_private(struct page *page, void *data)
> -{
> -	folio_attach_private(page_folio(page), data);
> -}
> -
> -static inline void *detach_page_private(struct page *page)
> -{
> -	return folio_detach_private(page_folio(page));
> -}
> -
>  #ifdef CONFIG_NUMA
>  struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order,
>  		struct mempolicy *policy);
>
> --
> 2.39.5
>

--
Cheers, Lorenzo


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71F26D7977D
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 15:30:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 902D06B0005; Sat, 31 Jan 2026 10:30:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B0856B0088; Sat, 31 Jan 2026 10:30:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BC9E6B008A; Sat, 31 Jan 2026 10:30:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 674EF6B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 10:30:56 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9714013B9EC
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 15:30:55 +0000 (UTC)
X-FDA: 84392646870.09.EC6B15A
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id 801B91A0011
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 15:30:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ll2TEnev;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769873453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vsqwz7F9b/j0YuC0Xj04np2r/jOowSHbOYUcStWbWks=;
	b=qxhh4vTAjbiYOGsWYqmLwNlVRvoe1NkIDCbkg+vN4OjMVEtFtszD7epC5grEZNjeR20Qwz
	W6z3nk8KY7cUTgnixPO4KjIywIcFKJ0zp4S3GJ/Osqdhkp+Rp7m9dbHhcsi75JV1GQnd8/
	CjxNyncxuv1EClTa31cz1aPJfHvdrqk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ll2TEnev;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769873453; a=rsa-sha256;
	cv=none;
	b=VoNYRPkxUzzdIw4aTe+UQMnL5+Ms/FIMvanLGUsj25TGubANCz8kSAvfWXgifuE0clBsmf
	hk3NkEuPp2qCPSVOHaJaRWR8UXt1SgGQXu49/hgaFsCbnUvaFb1EObyfAdU1l/RsmZ1nlf
	DS0RnVolw3XPKss7tN8gm2A8lIFkUhI=
Message-ID: <b37f990b-cb70-489b-849e-202eae190c37@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769873450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vsqwz7F9b/j0YuC0Xj04np2r/jOowSHbOYUcStWbWks=;
	b=Ll2TEnev9UOge0Djma0Yblote92o8CtIkC88ZTaonMMbe7xVUGE2vMfWZ8sP5y3MI23H6C
	TXRPG23ZFUuyHUKn/olRG/11XBte+tVDXB8aPPaN3LLEwrO3BQcGChPh2TAOnqlkHN9QHH
	Csj0oC5e4Oc8WfxG70WFfxzfNRG12a4=
Date: Sat, 31 Jan 2026 23:30:35 +0800
MIME-Version: 1.0
Subject: Re: [RFC PATCH 1/5] io_uring: allocate folio in
 io_mem_alloc_compound() and function rename
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Michal Hocko <mhocko@suse.com>, Jens Axboe <axboe@kernel.dk>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20260130034818.472804-1-ziy@nvidia.com>
 <20260130034818.472804-2-ziy@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260130034818.472804-2-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 801B91A0011
X-Stat-Signature: uirp95673teqsfjc8g1xbmwao3rjeqsb
X-Rspam-User: 
X-HE-Tag: 1769873453-439252
X-HE-Meta: U2FsdGVkX19J8H5VYVm+4OpNf69DmrPlo1UaqxrRSxRum0in7+lIt8Frfa7RboOEq9Lg/bi/1tzQqfd+1IlCLsG6a/xrhUGX8uBbAv0wsTyFuxqH4fh/lCfHRNj9i4/2u1/D8FssX0uAMM2x/++viONsAX0dsF2ynF5jONX3DRDcCJdXnyVJFLzrLCGZN7+oCHsFlqoKcL9oibVgRqfdq4cmtHcVdJEhqudzl+X3xfpA5qkOtJpzB/PdWSQ+M3Pzy5Ix/sbrTfGbsPAzZy7acEUl0yfY4O5K64HKxEPpVmviJ1yB66XTOjjxehbpw63IXjNap3AHNvJ5FqhcpuypYvaOfX//1YQxMDqOzZx2lOZy1r0ZJdu4lH2FuZTQ2jr0iJxusLscoUa9f/zPfXBbFYCxq3YS+7+ro0p5gaM43OB9YaDWLQl1j/NsODvrQvbOhk0A7+dQMuE4tw/frAbmpRdngAfpEVsNbFBbcOAU7mqcrbn7UFzKGLyFBOMI8m21ThSL+8ATs7jDG1c7buRpJbAuCdIYuaulweA6VwhpxMH8HPIcBrgLS3Ssdl9prVw8/eiIH8goQ/CVhGWVaStGG++eAxBaVRGlbPTUDmo5J9IC7Vwy9yu2l9NPimqwBSEs/zRkBnQBYlVvrQwUrUwKuQeItudTYdfAeKWtFzL8ndqde15uKJy24T99EB/b75kY3ogzleRTCWZjVUTaeTlut3Uo4nFlIHcYuY9b/nDwfL9iRrvKfl6mosYtLafPtE+QUefMtqc8+nKTsO+Xp2YyXc08B0PPzA5SzAlPtnhmHUu1BmsYOHbbudtr2brPFlvyLtExc8GUKaizJVER0RKPPymmjyj/KKLPj5TemBCPByKGyVKY9ddYwmwauwDNLEiQXRgupmKc8ad6426wuti9SLD7rlKg3bNM3CNitHukeEJ8S/OyGKXDfSB6jsVQvHnb1Ig8rYJyNQMAEEJVQiF
 6JQjOlwl
 X+6pwxN8MexXJZ8tTmDysD6VD8MTHgIHm40OP99I8+ShZ1PHo8/py3j8ZSt0wTSKWvzIz4xVeJ75igUBOrnCMnLX7p9EnwxJeH0vskwoqrDTsuOe7xv5+lHxZ25OaNlX+dcV8hUoGUvfUUKttwCG8pTkclgLCNve2nfySjVOuXV8WJyLdkVR6VOhfxrBBTKmjLegFKNP6FDCldI+YVpZVg6baS99lJ6RzZ1sNSRoiRCzqQiU59d1fhGZSicBvrNvSYCWTrH0n5osYLZZ3n7b1Ad/ClA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/30 11:48, Zi Yan wrote:
> The page allocated in io_mem_alloc_compound() is actually used as a folio
> later in io_region_mmap(). So allocate a folio instead of a compound page
> and rename io_mem_alloc_compound() to io_mem_alloc_folio().
> 
> This prepares for code separation of compound page and folio in a follow-up
> commit.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   io_uring/memmap.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/io_uring/memmap.c b/io_uring/memmap.c
> index 7d3c5eb58480..8ed8a78d71cc 100644
> --- a/io_uring/memmap.c
> +++ b/io_uring/memmap.c
> @@ -15,10 +15,10 @@
>   #include "rsrc.h"
>   #include "zcrx.h"
>   
> -static bool io_mem_alloc_compound(struct page **pages, int nr_pages,
> +static bool io_mem_alloc_folio(struct page **pages, int nr_pages,
>   				  size_t size, gfp_t gfp)
>   {
> -	struct page *page;
> +	struct folio *folio;
>   	int i, order;
>   
>   	order = get_order(size);
> @@ -27,12 +27,12 @@ static bool io_mem_alloc_compound(struct page **pages, int nr_pages,

Nit:

>   	else if (order)
>   		gfp |= __GFP_COMP;

Since we're switching to folio_alloc(), which already adds __GFP_COMP
internally, the "else if (order)" part above can be dropped while at it.

IIUC, for order == 0, __GFP_COMP gets ignored anyway:

  - prep_new_page() won't call prep_compound_page() (since order is zero)
  - page_rmappable_folio() sees a non-compound page and does nothing

So no behavior change there :)

>   
> -	page = alloc_pages(gfp, order);
> -	if (!page)
> +	folio = folio_alloc(gfp, order);
> +	if (!folio)
>   		return false;
>   
>   	for (i = 0; i < nr_pages; i++)
> -		pages[i] = page + i;
> +		pages[i] = folio_page(folio, i);
>   
>   	return true;
>   }
> @@ -162,7 +162,7 @@ static int io_region_allocate_pages(struct io_mapped_region *mr,
>   	if (!pages)
>   		return -ENOMEM;
>   
> -	if (io_mem_alloc_compound(pages, mr->nr_pages, size, gfp)) {
> +	if (io_mem_alloc_folio(pages, mr->nr_pages, size, gfp)) {
>   		mr->flags |= IO_REGION_F_SINGLE_REF;
>   		goto done;
>   	}



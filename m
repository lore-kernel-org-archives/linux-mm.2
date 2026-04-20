Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA479F557E9
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 09:04:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6BA76B0005; Mon, 20 Apr 2026 05:04:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1CCE6B0089; Mon, 20 Apr 2026 05:04:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C32986B008A; Mon, 20 Apr 2026 05:04:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B544F6B0005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:04:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6B2911A093F
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 09:04:14 +0000 (UTC)
X-FDA: 84678347628.22.A4B8C4F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id E1AD7C0003
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 09:04:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m52YxECK;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776675852; a=rsa-sha256;
	cv=none;
	b=8I3y8FdRFF3VUJg9OGP6qquFG+JBAWdYlgdgwy7kEnIwWfnBNguIq0BruhjMa2VdDxrjSo
	iy7AGR922ICsER4QLzMsbAaJtr9JN8B9vgTHq9z4CTKw+zdQXsS7vuppCwy+P63OCgbvJ4
	IS4zVuVQBuDFPXQfE9VOAoK+ZiJfpZw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m52YxECK;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776675852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U38VrloW02vTFpjpBXARFdutZwx8YHjIznQGuHYyfiA=;
	b=c3xgr2Cr1xTlJI9Eur8ICEQaYh72NuGSu1UPAQcBzWxOiXwdeELf/yBq4LjAa5piUuG2mt
	E6+tKPqKaS2pXC/60b1Oa13/LR1iEhMvkh5ulJhpdYpATbV+y0gsMs+tgSrPVSyJxFFKtQ
	hSQfPg5fhz6oQU/A9aP6sU5xj/0M+hY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 543626012B;
	Mon, 20 Apr 2026 09:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684C0C2BCB3;
	Mon, 20 Apr 2026 09:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776675852;
	bh=LvA6yjoRn3XU9vfmaoFuNvn1wjFt/ZCsrwm3PZylO34=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m52YxECKeoX6n/aJd/MQyyLYEDAcDiU6qfah2TRvUf22q5ZtBkCn+PWXjPte4+u8/
	 27IGmc0DuXy7i3061Bvdi6EkS6Y4FPfH/X2H/XBNDTQXJVXeg0X4sf6rsSoFibCuzK
	 vvgmUMiSmWbX4baV3ZUq+wYFxs3MljkZwdbH/jlLXVw/Wt7xcBCz+/ryG/Yvbg0Rwa
	 jtuZWXTs8nKz/PwLrVHFhG9SQeGTJ4bTaL1SQRiUadcIEvKvkmha1/+AmX4vIOWA4M
	 5yF4VjXgionb8tj46hMFgoXdK3ODMbHzMOU28pvxomln5Gj4jkq5N4EFXeGij0heJn
	 jiPG5tPvsk5Ow==
Date: Mon, 20 Apr 2026 12:04:01 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 02/53] selftests/mm: khugepaged: enable
 collapse_single_pte_entry_compound for shmem
Message-ID: <aeXsAW3kTujGGu2m@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
 <20260406141735.2179309-3-rppt@kernel.org>
 <a44aa2d7-5eb9-468a-a0ee-ee10b2b73502@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a44aa2d7-5eb9-468a-a0ee-ee10b2b73502@arm.com>
X-Rspamd-Queue-Id: E1AD7C0003
X-Stat-Signature: ugitnwjpsaz31iajas7ggrztctwotcao
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776675852-30544
X-HE-Meta: U2FsdGVkX19RLTEfinjCUSaxcEtZtJXTAXwE6zmBRfbLmSRat0ya5YDhnCJD8jPGZch14p7OvmIx8g8Pc3iYNTd3Ls2JGdO6f9aNpSXFlq9XoDLVcreX9fxs4gBU432Sp9sO+yY7aj104q8LZ09cE67LYB3gwQT1UssSmemgOOicZiYK7r6M/1kaxbwJyLtjgR0F7qzlJoPfw7m2KEL/8PZgjWMHMyqdJ6bUDt9D50PixkhxSEbz2oWCnxDV/FRp8xflcc3yXilp+0kKuWQTB6J6VH8Mwhe1H/kmlc+ycF/GJbCX8j7h7qo/gvUNzRkHoIdV2Csr9d2AdNjYdUEZCxoCZAq9WnPYdm+pG7CtQX+kDa93/ob/8Kiz0+9OnXrFeav2C8HL3fVqDUaAbiy4PQ5G6fOw7xlhpYhC6tUSHlKz2Btl5mhd4Otvzp3lTDe7ZpFuKpGVFCB+JoWl7OeaXQoISh4lyloN5nIOsW7pNLWufcUhBY5HRp6R7xMvBlNPmecwWpter9JWYvrAMJUEXHzSp97mS8CWh8/b30Svyw4jqLEew46tLugdKbNo6U/reQfGiXWLpx9wxvj6x0gwiOyQPDv4OcHcnKKzpO/ZH/PvT80SouOGlniqzH828GKcO21CwbwWvQhG5pLBrq726gp4EAEzjtksRLDAhYGak15pnaBYsFXT5fFIs/H19fFrTPFknDHMNR9L1mUd6BbCwj9LqVr557PsvdPuelbElI7ioT0aD+MvqR1SSNtg/4b2nIgnYpPTIJmzBvAWL52co5cqSFZdvuhXcWKLpDOY90YTAyQW/nid4N5nZDd8zKb6Z/frtd2c496YcU8xfuPeIFdUSawPPE0L7aovS+NYzLa8LFcW+Lc0rIwcKOG2ZnqIOcS+jsqy+WDfWKw8z1IO6QnWRJ/D2oZpL51Zr+MWTmVqhrmEi4dVD+xzH5AvZc/XawOZX4onjFKelg11Xyy
 4GNsZlTi
 FqTVA2HeOxgB5na83tixRs1H50y4FZc6U9zGXlOmY6m90mgRjvEl6Sjw29Rqb3rQHbujJX0LX1esFHMtVr3zYDGhIeAHiJGYpknfGX5biL9DFElZ5c3NJIutxKS5gmwjh+UKd9FyDRESdhK9VNUKLxJDXTAKFGENCpYDCHZNSnqc7qsixUPVeOMvgirit9UHv5dIPpx5vSapZn8tXb8+q42C+gOollvqNdW4ykIJ1LXeIYTFPAg8T16BT8pHazqiud5UV3WkIHaQkvswylLS5TPmGbZGY8YhT8VUIe8aBgZth2+tjzHiPyHo/aT20pqJtlGg+7GMaWLpRTocxPZgSmWndsRext0xsq1m0WYP5shblnrc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 12:20:43PM +0530, Sarthak Sharma wrote:
> Hi Mike
> 
> On 4/6/26 7:46 PM, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > A comment in collapse_single_pte_entry_compound() says it can't run on
> > shmem because "MADV_DONTNEED can't evict tmpfs pages".
> > But MADV_REMOVE can!
> > 
> > Use MADV_REMOVE for tmpfs to evict pages and enable
> > collapse_single_pte_entry_compound() test for shmem.
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > --->  tools/testing/selftests/mm/khugepaged.c | 14 ++++++--------
> >  1 file changed, 6 insertions(+), 8 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> > index 3fe7ef04ac62..e6fb01ca44ed 100644
> > --- a/tools/testing/selftests/mm/khugepaged.c
> > +++ b/tools/testing/selftests/mm/khugepaged.c
> > @@ -783,20 +783,17 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
> >  
> >  static void collapse_single_pte_entry_compound(struct collapse_context *c, struct mem_ops *ops)
> >  {
> > +	int advise = MADV_DONTNEED;
> >  	void *p;
> >  
> >  	p = alloc_hpage(ops);
> >  
> > -	if (is_tmpfs(ops)) {
> > -		/* MADV_DONTNEED won't evict tmpfs pages */
> > -		printf("tmpfs...");
> > -		skip("Skip");
> > -		goto skip;
> > -	}
> > +	if (is_tmpfs(ops))
> > +		advise = MADV_REMOVE;
> 
> is_tmpfs(ops) will always return false for shmem_ops, since the function
> definition does not handle the shmem_ops case. Therefore, this advise
> will always remain as MADV_DONTNEED.

is_tmpfs() will be true for file ops when file is on tmpfs.
 
> Also, I am able to run the shmem tests using MADV_DONTNEED and the tests
> succeed. So, perhaps we don't need to use MADV_REMOVE in this case?

I read the comment and changed the advice to the one that will actually
evict the pages from the page cache.
Looking closely it this and collapse_max_ptes_none() test, I don't think
presence of the pages in the page cache would somehow affect splitting and
collapsing, so apparently the skips for is_tmpfs() cases can be just
dropped.
 
> >  
> >  	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
> >  	printf("Split huge page leaving single PTE mapping compound page...");
> > -	madvise(p + page_size, hpage_pmd_size - page_size, MADV_DONTNEED);
> > +	madvise(p + page_size, hpage_pmd_size - page_size, advise);
> >  	if (ops->check_huge(p, 0))
> >  		success("OK");
> >  	else
> > @@ -805,7 +802,6 @@ static void collapse_single_pte_entry_compound(struct collapse_context *c, struc
> >  	c->collapse("Collapse PTE table with single PTE mapping compound page",
> >  		    p, 1, ops, true);
> >  	validate_memory(p, 0, page_size);
> > -skip:
> >  	ops->cleanup_area(p, hpage_pmd_size);
> >  }
> >  
> > @@ -1251,8 +1247,10 @@ int main(int argc, char **argv)
> >  
> >  	TEST(collapse_single_pte_entry_compound, khugepaged_context, anon_ops);
> >  	TEST(collapse_single_pte_entry_compound, khugepaged_context, file_ops);
> > +	TEST(collapse_single_pte_entry_compound, khugepaged_context, shmem_ops);
> >  	TEST(collapse_single_pte_entry_compound, madvise_context, anon_ops);
> >  	TEST(collapse_single_pte_entry_compound, madvise_context, file_ops);
> > +	TEST(collapse_single_pte_entry_compound, madvise_context, shmem_ops);
> >  
> >  	TEST(collapse_full_of_compound, khugepaged_context, anon_ops);
> >  	TEST(collapse_full_of_compound, khugepaged_context, file_ops);
> 

-- 
Sincerely yours,
Mike.


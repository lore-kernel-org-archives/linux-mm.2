Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BB88CA0EED
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 08:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE2048E001E; Tue, 19 Aug 2025 04:46:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A92C88E0002; Tue, 19 Aug 2025 04:46:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D1218E001E; Tue, 19 Aug 2025 04:46:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 893AA8E0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:46:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1D78C1DDD2E
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:46:51 +0000 (UTC)
X-FDA: 83792876622.29.DE57182
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 48DDE180003
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:46:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="K4AzYtI/";
	spf=pass (imf16.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755593209; a=rsa-sha256;
	cv=none;
	b=TlZWZ7VTVE5P3P8ZUNRgTjQfAGHnM6+9bY9IVlpe2WaF4XJ7M+CmiUQ7Z0y9Ddc/SkGdbc
	/ufaH+oIFOovnxZdHhoKaIt0OhK57OSunb3V2G4yiZa7JB3s5c65hSLJ62yIm1vCVSHvbK
	bI6Bcg+x70yuHawIqluXbnxAIH+8RlY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="K4AzYtI/";
	spf=pass (imf16.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755593209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wabcqhlxUWdDHAf1VDHXtteigfuYakB+3HNj5GOSo3U=;
	b=2MWh0EkqS0+FRThYnsDjyK9q/4J10gRt/4yJuniYBsvSmOrFYuVbNmmRTkUp6MjzcdLNOh
	ebRSTkf1Rw/Kpl5VtA7bazXzWl28wwJ+ICHaR+sLHfqkWwLttHhBsxuQf0Dyz0cTW6FLxJ
	UntLDIQ1snp06tyKPlzI4klctrkAZJY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755593208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wabcqhlxUWdDHAf1VDHXtteigfuYakB+3HNj5GOSo3U=;
	b=K4AzYtI/IUqaIscxPM3SW4dEzgOrpkS0VynuCptkBBv5gaEkTcxQP2C0U7hzl5a/9cRxk7
	VsYhbk/D6mCx2zeQ1sAoULi57rDS4GLX016s24OyVAWJQlSmxPFmFaOQEr4/sOZDzpLGdl
	oQop+ya6kEocUNu8beSReP4wI+nk7mk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-249-oWB1BCI3O82BQTYXh31mqA-1; Tue,
 19 Aug 2025 04:46:45 -0400
X-MC-Unique: oWB1BCI3O82BQTYXh31mqA-1
X-Mimecast-MFC-AGG-ID: oWB1BCI3O82BQTYXh31mqA_1755593203
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A4E1F1800357;
	Tue, 19 Aug 2025 08:46:43 +0000 (UTC)
Received: from localhost (unknown [10.72.112.239])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4938030001A8;
	Tue, 19 Aug 2025 08:46:41 +0000 (UTC)
Date: Tue, 19 Aug 2025 16:46:37 +0800
From: Baoquan He <bhe@redhat.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] mm/vmalloc: Support non-blocking GFP flags in
 __vmalloc_area_node()
Message-ID: <aKQ57ag2odokmwJm@MiWiFi-R3L-srv>
References: <20250807075810.358714-1-urezki@gmail.com>
 <20250807075810.358714-8-urezki@gmail.com>
 <aKKthIZbD4oNywY4@MiWiFi-R3L-srv>
 <aKMlx_sATwnGsXXp@pc636>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKMlx_sATwnGsXXp@pc636>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 48DDE180003
X-Stat-Signature: x5icx1t55wqez79o6rgbpbtdhj9y61ar
X-Rspam-User: 
X-HE-Tag: 1755593209-498465
X-HE-Meta: U2FsdGVkX18C9eAUL6qeHoakUTvHk0cusVZfUAPLHwchczhfgi4Mx0weCOQNTrowFdu9Q86i5iQ0WO5hGw1SfhYlkRl9IRh/00VgcAILdTcTU7bIMN2G6uPnDuayP//esz5VXzpfJ4NRRx1ruDnmsQtTiknZSy1mMgMSJLhvC7EuIOiIkExupzehs3ZSVRfwlWjYNp+XKqlRb0I9rdNAWBKldD+1wBnYGK+inOU05IZx1uOG/NvZZ6fc2m3EXV09Uh0tHctnJ11K+HOBXkpSo9XIViC6vA1GjpmRXojopoJr9D7LlS9tstyAMkFa2fnAH9wxJCBhhzbQVF60Hus3q0j5u9McTcRYbkfz/K5ILOsX1Apdnm1j3PNV9a5QGgCEcXI46r3iJrII3PMR/hEuJEbuPAC3E54bUCVeEo8CFyz4/NqxV4QO0ScbI/qsCbvQD3FOFsDCMpMQfMtRB6m0RWwg1D5HjkE3tOcGkhAGnr4jVwAijOGZRRMpKqsHhfr/Wft8bQkQJ85I95+huJPqL4gFh+oACNEPu8SidYltDBOavbkZwH8V4203h07Tq6pJcVOSASLZ/prvfcdA73eIndptNvTM7B9sQj9XDZoDuUlmShvOGJsvPiQzsoFwHQ28aQaHGkZM43+F2gb+HOfVzAhoPhew6+AmL0slINW9JeyBSiY+mekcH5vfz66XWUKUNiVY/ARG+k1gcjv4odCWAaWl+dLelFRvgMlW6/dNioyUk0AciRmjOzBzQpKCf9rnJUlEtnRBav+c5v3R9yUnOGfKLkjJT7GWyRm+/07q9ODMoxgqoa6xd/aU7rlkdfyskYCzq8/nJmUmXpusRtd1xueXWoV+pyIZdHljiaTH3kXEX8dVi+c9QL4MkB6PjeaydeR+WpwUObT1cXJsPINf6F1MmxKn5h2kHYZKlWAh4lxEfvussOrwOOss/3Xo/QA4VzkPzf901/S0n0OI/sV
 Hhu2F24T
 YzSb4DkvankxF0wBUlJpNofrsEeXJgvG+JBFPbUHmmB97P0M59sQ9JwtZbyqC+94HGDdl8lsKFaJgT4dNuibth6xJZplY03rXjZ46PGI5OJtEpYGoJBeICBBIVB+fejq+CmwbT49BA1JfMgqsAalLsil3ZtmDbnslJs0EgaSSaNcURDx7PfUeEnjcwjhmzVqs+8r76LC/vGEiasso+FQOGk8HRE83ORYZKUSDIxYXQDXq1px7vNLOIYy+Og9qcwDQu2VcOROVvStPsKGIL9nrJg8MtW0IyoVnFeXZUHOLhgrev+3tOgfAuDwVMt1mDA2d29QoFyqJ226cJ8YUKEQNrlYgwi0DdrEvVxKwTkrOIsMH+knuULv3BqGJJWZ5Pj3Zq372++hD58UWaXNy/3GMbTo2BRH/+QWD+fyXg8YiH8ESaUMmdQHJyw6CU3Kq41CJ31cgSZqUCH8fJhM1RCi1BTV0+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/18/25 at 03:08pm, Uladzislau Rezki wrote:
> On Mon, Aug 18, 2025 at 12:35:16PM +0800, Baoquan He wrote:
> > On 08/07/25 at 09:58am, Uladzislau Rezki (Sony) wrote:
> > > This patch makes __vmalloc_area_node() to correctly handle non-blocking
> > > allocation requests, such as GFP_ATOMIC and GFP_NOWAIT. Main changes:
> > > 
> > > - Add a __GFP_HIGHMEM to gfp_mask only for blocking requests
> > >   if there are no DMA constraints.
> > > 
> > > - vmap_page_range() is wrapped by memalloc_noreclaim_save/restore()
> > >   to avoid memory reclaim related operations that could sleep during
> > >   page table setup or mapping pages.
> > > 
> > > This is particularly important for page table allocations that
> > > internally use GFP_PGTABLE_KERNEL, which may sleep unless such
> > > scope restrictions are applied. For example:
> > > 
> > > <snip>
> > > __pte_alloc_kernel()
> > >     pte_alloc_one_kernel(&init_mm);
> > >         pagetable_alloc_noprof(GFP_PGTABLE_KERNEL & ~__GFP_HIGHMEM, 0);
> > > <snip>
> > > 
> > > Note: in most cases, PTE entries are established only up to the level
> > > required by current vmap space usage, meaning the page tables are typically
> > > fully populated during the mapping process.
> > > 
> > > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> > > ---
> > >  mm/vmalloc.c | 20 ++++++++++++++++----
> > >  1 file changed, 16 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > index 2424f80d524a..8a7eab810561 100644
> > > --- a/mm/vmalloc.c
> > > +++ b/mm/vmalloc.c
> > > @@ -3721,12 +3721,20 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
> > >  	unsigned int nr_small_pages = size >> PAGE_SHIFT;
> > >  	unsigned int page_order;
> > >  	unsigned int flags;
> > > +	bool noblock;
> > >  	int ret;
> > >  
> > >  	array_size = (unsigned long)nr_small_pages * sizeof(struct page *);
> > > +	noblock = !gfpflags_allow_blocking(gfp_mask);
> > >  
> > > -	if (!(gfp_mask & (GFP_DMA | GFP_DMA32)))
> > > -		gfp_mask |= __GFP_HIGHMEM;
> > > +	if (noblock) {
> > > +		/* __GFP_NOFAIL and "noblock" flags are mutually exclusive. */
> > > +		nofail = false;
> > > +	} else {
> > > +		/* Allow highmem allocations if there are no DMA constraints. */
> > > +		if (!(gfp_mask & (GFP_DMA | GFP_DMA32)))
> > > +			gfp_mask |= __GFP_HIGHMEM;
> > > +	}
> > >  
> > >  	/* Please note that the recursion is strictly bounded. */
> > >  	if (array_size > PAGE_SIZE) {
> > > @@ -3790,7 +3798,9 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
> > >  	 * page tables allocations ignore external gfp mask, enforce it
> > >  	 * by the scope API
> > >  	 */
> > > -	if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
> > > +	if (noblock)
> > > +		flags = memalloc_noreclaim_save();
> > > +	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
> > >  		flags = memalloc_nofs_save();
> > >  	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
> > >  		flags = memalloc_noio_save();
> > > @@ -3802,7 +3812,9 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
> > >  			schedule_timeout_uninterruptible(1);
> > >  	} while (nofail && (ret < 0));
> > >  
> > > -	if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
> > > +	if (noblock)
> > > +		memalloc_noreclaim_restore(flags);
> > > +	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
> > >  		memalloc_nofs_restore(flags);
> > >  	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
> > >  		memalloc_noio_restore(flags);
> > 
> > Can we use memalloc_flags_restore(flags) directly to replace above if
> > else checking? It can reduce LOC, might be not as readable as the change
> > in patch surely. Not strong opinion.
> > 
> > 	memalloc_flags_restore(flags);
> > 
> I agree, those if/else cases looks ugly. Maybe adding two save/restore
> functions are worth doing specifically for vmalloc part.

Yeah, that is also great idea.



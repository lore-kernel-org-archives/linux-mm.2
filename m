Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBAA7CD37B2
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 15:55:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2905F6B00EB; Mon, 11 May 2026 11:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 241456B00EC; Mon, 11 May 2026 11:55:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 130296B00ED; Mon, 11 May 2026 11:55:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 053576B00EB
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:55:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B55918ADBD
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:55:53 +0000 (UTC)
X-FDA: 84755589786.23.701E9AD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7EB2E120008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:55:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RQavqM0K;
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778514951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vh4TZQwOj1LDvIW+49RnIFBfwPgx5sko4Nvxu6iVtR8=;
	b=39gShlaWVKnEddkVz/b2sBTSXyR42/Nry/RawBqemjD1EgiTqTvCMedHrMXJcUKvjMfkrc
	+M4bCYw822ark5B7Ao7Sxkon00AewnwrlyIwuslzPx5O4lyFlCX3ZeG+fkmqx6kd3AHBbn
	DM+pfQBFNiSpQYuFsgOvfIAwtO5KW1M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778514951; a=rsa-sha256;
	cv=none;
	b=mjc64cJA48zhs1n0L24nlnnYI2nY0Xeud/KWVz3W/Zcmc3FzYCgREZBbZInNG2RoOEc8DP
	6PGm9GzZlL7X+gp+/e15XzzjIHBC+dRt9gOhs6RX+OY8FZn0JtcmK3sighyQKgSqXCkFbk
	zMT9e5m+1xwZFzCqCcZ64SzF3HMTl8U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RQavqM0K;
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778514950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vh4TZQwOj1LDvIW+49RnIFBfwPgx5sko4Nvxu6iVtR8=;
	b=RQavqM0KnbA4RGAbhfMr90gmoCQqqZ88gE9FsdIJIKL5Ymc+0Nejaf1GzeKRpRs+nKwsz6
	NLTm6Ryea86mL2Z+2p9EYGc/ovgtFVMZnZEF4eleA+yitliP0K61KG2w/nHOOrylAEdqEm
	u/5p9lef1TQxWEF0RRhpGiGyjvj5igM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-193-QWwTYl_7OeWuTW25JVcFtA-1; Mon, 11 May 2026 11:55:49 -0400
X-MC-Unique: QWwTYl_7OeWuTW25JVcFtA-1
X-Mimecast-MFC-AGG-ID: QWwTYl_7OeWuTW25JVcFtA_1778514948
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48906aa28cbso40843485e9.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 08:55:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778514948; x=1779119748;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vh4TZQwOj1LDvIW+49RnIFBfwPgx5sko4Nvxu6iVtR8=;
        b=c67FBLkbN89s4zUUIz44REqNXXxONcdci2xucVqlUQo5lXVtyBCZ+YEXNo/HzRxMZM
         9GOruwwL3Rm88CB/ZEKBUqnkwTZeOmJh5gLU+t8F3pDlqTldkK2KoMoXvOrlmKhAXK98
         pNmvPOz2Te3yCo9eSM9qY+3s9pT/IGWAcCJVDXzegHIrrB3Uue9qrXRHcwqxpN9UqHS0
         tPm+6k+XpvyVG2vkKDrAPm83NNXP07SPGRQekveIXgZjq0oB60BiFtTUu7fks84/szYy
         MXjA9wVxv65VBqoqDOb2QLZJL/dX1QcBejMVDFe0Gv1xr8hpYx2Dq/ZwDF7c71ruJ95m
         O5Ag==
X-Forwarded-Encrypted: i=1; AFNElJ9Q0301oajFOTYMYi3VZlWaWsMkB70PyhsogoNxDbcDHhtHrv+pW0uaEV57GPdPhNv/L+64Al9eZA==@kvack.org
X-Gm-Message-State: AOJu0Yz/HmEC97rF8zgzBkUDbtvKGhRy2KgVNMzUGnO53WnpeKsKBFvC
	t7iIXSQx3tbzLguY8XOEg8qACxXiGm/ZSw3hjH1eynR/Tdkt9ZvFZ0K0ntOG/dRv1KqAj4Q6Lpa
	e4msWIMnuYeKJpNv+fZsNNN8sl/RJH6JodGyCSjIkmEJSHOrO5yKY
X-Gm-Gg: Acq92OEkJ8WktOMRQfwfinN61+PjemHuHx1Y5P4/Fmu7z23TFuNOtm7L6kVBpErGvxg
	awYZ2hEUyyjz7WRz+Mv496NrEuyLM9kCZcMVR+pyTxmKxcEQ1PXAZxnt1xd6Ui2o7Zis1TJadiH
	N7ErHSc1HbvbUdJAs983Bo9zGhEXtCYUEwaPZKiFYMB1tef4J0onzkiArG1VVdNy20B9KAdcKls
	vsMoZ769j050D3eVoHV7uLhJQSFKKxJeV+B4UyhZf0NLv7XwMugJ5Qfcgv3sTaPwn1gh53U96K/
	4gtXJeC1Gp6CLJMuwTJR2047TbvdBF/sgtFvvKa+wekLhP+ciGJSGtaMHjf9rIe18DBNRND+uJf
	Ru5NSxOx04o+yJeFSfR5pK55O0+HHMsdNOexgFrwC
X-Received: by 2002:a05:600c:3547:b0:485:3c2e:60d5 with SMTP id 5b1f17b1804b1-48e8e1e6eb9mr1619345e9.2.1778514948282;
        Mon, 11 May 2026 08:55:48 -0700 (PDT)
X-Received: by 2002:a05:600c:3547:b0:485:3c2e:60d5 with SMTP id 5b1f17b1804b1-48e8e1e6eb9mr1618285e9.2.1778514947593;
        Mon, 11 May 2026 08:55:47 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6fff9ab8sm203070735e9.2.2026.05.11.08.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 08:55:46 -0700 (PDT)
Date: Mon, 11 May 2026 11:55:40 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>
Subject: Re: [PATCH resend v6 03/30] mm: thread user_addr through page
 allocator for cache-friendly zeroing
Message-ID: <20260511114853-mutt-send-email-mst@kernel.org>
References: <cover.1778489843.git.mst@redhat.com>
 <9b53972f4854c1064b92cefc464f51949afeb83f.1778489843.git.mst@redhat.com>
 <agH3wceKcPNmixCj@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <agH3wceKcPNmixCj@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HChEGjM28P5JevPgeliOEDp9wIJw5xFQFzXSAlVtCOY_1778514948
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7EB2E120008
X-Rspam-User: 
X-Stat-Signature: jwm3su4w6nstoe8fnra6s4nwyc9t3uey
X-HE-Tag: 1778514951-808979
X-HE-Meta: U2FsdGVkX1/h9AchVHIbClcyWItwS8Imqfvvz0HxkVgtgFAe3kWmBTka8c+eDIG8nlr3EfmgdsYg58Jo+xR/cRSyyUo7gSQnYa/efDNXlqUHVIwJSSUzpqojZQrLOAcu6/mUAHv9tpocBXeJEx0u7USXscWYxs4ZoNg6oXDVWygP+0aC29k35GklN2CCQ5u/3190MeYqZwl/INNkMUgKe1vhIj93WZQ44TcHNrxRwzi7vn+NomWCCTxXOKkAOWlKLtMh9tUbr4D/U3BxtIfQGXXF1c1rF4JLgvVAAqTei9IiKD74UEdA+ZthHYOy70x36ufIFclhMSrfPsRgrw56DRmY+oqOrk4zvsS2SuKQHv80hDK1GuZm4WOX/raYnQ1dlUcaPzf6x0v3XJF3orDM1ci5CUbHbB/f4alsImsF3FbYMU8QCCf5S1Y4+pYPY7oJSZkEL8zohZDIG1zqmCC9crVWU+pjQsXxeEACI7MmWGb1kSzpzql3Dy6cfQh9DCU/pqOKanJY5CrHbnJ2U/WVT8W9aLrb1y6Vk9DfrdkvqSblWce6ussZWEJ2ydnBTcP2y+ZJTm+/eRXoUVkUbJOM7J7uTOAELn91cN1hI/r38qJJsccFkgSafLz94MhshgHTm2tc33J/bUfo3Uj/WoM1rS6UDNKul7NgTpEI53kcAE8kfzyt3+b7nIq9niBcdonNRTFi/IrpvG/Bze/cx6DiICb/Daq9TxvRigWeQJE6JUn5GfyhOUvPBq4YdmM8qJpf1NqklCdl0k/QNK1E51NCnIFlvPAqxa7cekO6d6+fgPyw9/Xpx5FcVe+y4YD12adP5iMqLPODYEDK3UWfv/gUfmz3R0vGoZFEknJfxlX8OMh6MCjEoq4an00+IzorzNcRDaz59Gr7vGYTd+zoPaeKqbpuu5YthD3QuLBEk0CTD2uHrv5uuQ6Ip0o6y6BsXz5HXcvxFYUbKegFmR3JqLw
 BkKL33vr
 hlXIvtt+0yl+JSpvtevYRm7RWDEyUx+R1PfXMqeNGZ6+FyC+inJ4eN9JWoQVLecNq02mwrO1EMV7d1r6+tCw++oC9nudJEldLPjxlrX083OaK+TYN2YD4IQlQJCYhF1mUXhDDvPTKDhwlJJ+dpAGuBjsNoJFz9PAXvSbRGfZEd6bJ2xgBo/h/iTD4/VpTyM8+5lFL0SOc/R9LUNoLocT75Qul7knN31HDGN5OZp6zLIZA6Vwl1rcq9OpqVNg8y8KQQhSC1Tbjka9Ah9Rqpl0S54mQUOJUUkKtQI/qRDJFnwDRQutuF7DyK9QtP5KJIkSONvs9g9ISH+OVxqvNpdJEAw/6drju6DUyLN7SgE162TUfSF5dxG50+v0rM2+si0z23hBzv9KXZH0aDhh3H6Fq+ilthBOkKpkx6Su/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 11:37:37AM -0400, Gregory Price wrote:
> On Mon, May 11, 2026 at 05:01:55AM -0400, Michael S. Tsirkin wrote:
> > Thread a user virtual address from vma_alloc_folio() down through
> > the page allocator to post_alloc_hook(). This is plumbing
> > preparation for a subsequent patch that will use user_addr to
> > call folio_zero_user() for cache-friendly zeroing of user pages.
> > 
> > The user_addr is stored in struct alloc_context and flows through:
> >   vma_alloc_folio -> folio_alloc_mpol -> __alloc_pages_mpol ->
> >   __alloc_frozen_pages -> get_page_from_freelist -> prep_new_page ->
> >   post_alloc_hook
> 
> This is the nitty-est of all nits, but when doing this can we please
> prefer stack style?
> 
>   vma_alloc_folio 
>     folio_alloc_mpol 
>       __alloc_pages_mpol 
>         __alloc_frozen_pages 
>           get_page_from_freelist 
>             prep_new_page 
>               post_alloc_hook
> 
> Claude has a bad habit of writing changelog changes this way, and it's
> painful for a human to try to read.

Sure.

> > 
> > USER_ADDR_NONE ((unsigned long)-1) is used for non-user
> > allocations, since address 0 is a valid userspace mapping.
> > 
> 
> > +/*
> > + * Sentinel for user_addr: indicates a non-user allocation.
> > + * Cannot use 0 because address 0 is a valid userspace mapping.
> > + */
> > +#define USER_ADDR_NONE	((unsigned long)-1)
> 
> Ehm, hm.  Does -1 hold as a non-user address across all architectures?
> 
> What about in linear addressing / no VM mode?


this is used on a fault. I don't think there are any faults then?
But maybe FAULT_ADDR_NONE would be clearer.

> > diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> > index 7ccbda35b9ad..ee35c5367abc 100644
> > --- a/include/linux/gfp.h
> > +++ b/include/linux/gfp.h
> > @@ -337,7 +337,7 @@ static inline struct folio *folio_alloc_noprof(gfp_t gfp, unsigned int order)
> >  static inline struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
> >  		struct mempolicy *mpol, pgoff_t ilx, int nid)
> >  {
> > -	return folio_alloc_noprof(gfp, order);
> > +	return __folio_alloc_noprof(gfp, order, numa_node_id(), NULL);
> >  }
> >  #endif
> >  
> 
> This change seems out of place unless i'm missing something.
> 

Don't remember. Could be from a change I reverted. I'll look.

> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index f24bf49be047..a999f3ead852 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -1806,7 +1806,8 @@ struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio)
> >  }
> >  
> >  static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
> > -		int nid, nodemask_t *nmask, nodemask_t *node_alloc_noretry)
> > +		int nid, nodemask_t *nmask, nodemask_t *node_alloc_noretry,
> > +		unsigned long addr)
> 
>                        user_addr?  uaddr?

ok


> > @@ -1823,7 +1824,7 @@ static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
> >  	if (alloc_try_hard)
> >  		gfp_mask |= __GFP_RETRY_MAYFAIL;
> >  
> > -	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
> > +	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask, addr);
> 
> Not on you, but the changes in hugetlb.c as a whole are :[
> 
> We do all of this to pass USER_ADDR_NONE all over the place, but the
> alternative is having a separate function specifically for user-land
> bound allocations.
> 
> So the trade off is:
>    a) churn the current interface for everyone
>    b) add a user_ variant and know people will just get it wrong

I was also explicitly asked not to proliferate too many new APIs.


> IIRC you said the consequence of getting wrong here is subtle corruption
> if a caller got it wrong, and this was related to cache flushing for the
> provided user address?

Yes.

> Stupid question: Does this not apply to kernel allocations as well? Or
> is it simply a matter of the cache having stale data that could leak,
> and therefore it's not a concern in-kernel?
> 
> ~Gregory


Not a concern since we zero through the kernel address.

-- 
MST



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 185E8FA1FF0
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 20:32:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 559C16B0088; Wed, 22 Apr 2026 16:32:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E3D56B008C; Wed, 22 Apr 2026 16:32:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3841E6B0092; Wed, 22 Apr 2026 16:32:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 22BB56B008C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 16:32:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6D5291B76FB
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 20:32:57 +0000 (UTC)
X-FDA: 84687340794.06.39761E8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id D7915C0019
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 20:32:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Plv3JKxb;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776889974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j2mexCWnAXHTuyUVY4iwTSyRl6JB6J5POTCYS/bdHQE=;
	b=KFh6Em8Z7Uy1k5vuY7xA3ulcyy2BzF1lAUAmTStOqlnFiouuxij+bbWZnS/xFFMciCTN76
	NALUNESO3cbDP2ffshgZZrPgDr5k0wFmFzth2TCjqZbKas4nmKAAdB3ccnQiMHV+EcA5Sn
	011CW2D3GYIpd7RhgO1MWCZwAb84lWs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Plv3JKxb;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776889974; a=rsa-sha256;
	cv=none;
	b=MNmnpdRD8QCd1E14s5cBXWRyT3kv88M8Vxnm+8WzLfqHnZP+qVNil9g+L4danFDPDSLNw2
	32OlTf3hPwZQR1yac2W5hcR6OvKwDn55DvuaYU2nPuaMoCStlUjNRm1HGfOqPlOobVOf3s
	Bvg4keyVYvzfIwBU0MJlExZr4LOnGw0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776889973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j2mexCWnAXHTuyUVY4iwTSyRl6JB6J5POTCYS/bdHQE=;
	b=Plv3JKxbNUmu1D4FYf8cdnWpZ1gG4PeRzQftv9HjFj65ZOLdjPyhg8PZjTvskgiN2bhwQW
	EujrNcsZy0N6mlN5QRf3Lw2OKpJZ2ILRu0oYPl2mL3RdWyVTZ47QKDWdfaWikO1si4oBGC
	uhTy0QIiadR2St0hhMD5YMbcePNZ/dg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-103-BFan3ZO_Mu-tBY6ItvK03w-1; Wed, 22 Apr 2026 16:32:52 -0400
X-MC-Unique: BFan3ZO_Mu-tBY6ItvK03w-1
X-Mimecast-MFC-AGG-ID: BFan3ZO_Mu-tBY6ItvK03w_1776889971
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48a5adc141cso6632465e9.0
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 13:32:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776889971; x=1777494771;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j2mexCWnAXHTuyUVY4iwTSyRl6JB6J5POTCYS/bdHQE=;
        b=skLLvfeyQGOMLmLsiiF4MM4ZAdD8xv4UE4z5R3rvdIYotyQZsD51Mu0Bw00TiMnADJ
         9kAolkwrVDwRvYtyZWdoUku/T82CBsWQrgDKWPvI+NdWPKKkTV7ORfQLTmA1BFjHzxwC
         Gt0b9US9QFFugYmAAqtbA1oYwIIMiLI+7TqrzyTpYJuLucHCm3mYORUiJuX8GoOgxpr7
         ZJFkc9YVFBQ2LDLGU6mWkst6P6NjjRJa/D8SkaYt0Ztj2ns+9VUMOWPbeQxDd4YNUh+C
         Eo3j81x0J49tJ0OpjfnEtS0DJ+9yVH46Av3hmjVQ2ugC7nS76Q4UIoxMbnZGFzeFUrJg
         3OLg==
X-Forwarded-Encrypted: i=1; AFNElJ/j9m5iNVt4RbKn6oCzT13h2CZ5s3rpRLYh94wIv60PfRJlEWEcmeVTi/2G13+fYUMkWMtaK19NKQ==@kvack.org
X-Gm-Message-State: AOJu0YyIy+1qYDJYss5uMtYBp+OlbVci3NJo/t2iOs1fdITNnvp5+ALx
	HUR+JkIVo/fNncIM8jEVZEkwelvFLCW7lu5ZgqY6ufP32AUPYk53tTXuaGDzhp0ibFYy2z3UyoI
	b/ZXw7sO7zIVjse2KsiGCwkTtl0q7XBuCQFOEh7HmNQY6LR1/l5N3
X-Gm-Gg: AeBDieuAasrk+cauknM9MioftwSZaDtTKSCXUve6PXqPndhi4I+fvtv27DxLujA3Ka5
	/sDUgNMzpucDpB4hPMl3oMCZH7Vc7N9N1X81Dy+vDPf+w2rgMLBav7eWx2tvC2/RwBuC7U3ovU+
	NIpn44zw13oXXcj1HH5iwk6dvYEuA/pSKoyyYQwXwmZGq4VALqxqjPmSsXtx2qh+WODmAQs0ZV3
	/lTow/S2n9enqn16LM/VYpRksKTahl9TYWRcpW7cBrvirqWm04UTtn9zNy2Gtl/ruxkjXXqTIu5
	mdLybysa3boX4iJiVdXkyhjlKDi4Vf3ZOIGrr5Dp01m69Bi4ZgNea5d7eAiVMnNcUy/menULdpd
	ND3cDQCcEL2n3l9wMoyl5cXvhoLzZWFpbdFYCU60werG+SQaC0r2Oag==
X-Received: by 2002:a05:600c:2288:b0:47d:52ef:c572 with SMTP id 5b1f17b1804b1-488fb881ee2mr228774605e9.1.1776889971049;
        Wed, 22 Apr 2026 13:32:51 -0700 (PDT)
X-Received: by 2002:a05:600c:2288:b0:47d:52ef:c572 with SMTP id 5b1f17b1804b1-488fb881ee2mr228774125e9.1.1776889970331;
        Wed, 22 Apr 2026 13:32:50 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e4ffa8sm49363292f8f.35.2026.04.22.13.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 13:32:49 -0700 (PDT)
Date: Wed, 22 Apr 2026 16:32:44 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC v3 01/19] mm: thread user_addr through page allocator
 for cache-friendly zeroing
Message-ID: <20260422162811-mutt-send-email-mst@kernel.org>
References: <cover.1776808209.git.mst@redhat.com>
 <9dd9deabd42801f3c344326991d1431c3d8db39d.1776808210.git.mst@redhat.com>
 <aekluxNPxF8CN8fL@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <aekluxNPxF8CN8fL@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: S8JegndGlcF3ku7IGV2QqLIZ5MJyAi7AFpx68Nndk0Q_1776889971
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D7915C0019
X-Stat-Signature: zinxin6mf8ewzqnhuirmu3n6tci3t1nq
X-Rspam-User: 
X-HE-Tag: 1776889974-195654
X-HE-Meta: U2FsdGVkX1/zQ2qiT51l2TNQvGjx+rLFkM1eo6SPR8n4HzzagUd2DPGUpwwf5IrUO5zaSSPymxZbOehtmOGzV3m/bYAb9mRqR3I1H2NrSQoWNvqa0RKP1oMAOlRypTUbgi1r0GF6G/TdW3mkGjUz+BmtcYVt4eyVh9gqRxm27U33o7tFM3ADUl6grDtlX6UynCcUmfMDnbraL85qmqbHuY3ExOgu0oVV36EyjyjJqEhZ9WM7Ir039LZ/9Z+nS9KvJw3co4xsG2o7g7t/RHnjwa1y9FTVIEVB6C6Dzg00HeSmxcTx2bDIpl6AC782lmzwQPEXwJz71SBEJbQzf2GbriceY3IbBiMOjyHWlB6vU94DqNSi0Vuhl0H4uyhCbNfdbzmjdURDC872Vx/ATMSGNrOYo2phntb8AXtOXhZ2bDEc6gdtonKJS4X22JLt3PR5rY1UcGXDYSxwVKRir9EOOGa6WD/MRLyqin8sRq8HEwrcyTRH5PUMzRLJA0VXIfkdyek99YoPlkV+bc/eJRVtjegPIDwKlpbX8+Ej+uEjO2rWfw9+nxk6OHX9U+ckQIg3hw0zRavbzWC+PCKdk9FzZRHuRoE9znDnvBYXl9gz1geooZBarYhnBIZuuxmv5SaDkSLLk6IjklZylnMiYkye9LMsd+dl10CsAscem3MKf2xPl38gBddTz52KfF755+DK5ZoFzF/ryFvPLkpeK77z2EPTN3w07PJ5zjQ4v3j5M8SJheKO/HcXQfwm22upOz/65pWwxB/mAHABP9t/VwKjMxOssySkKJPYNfvT/1YBQxQ4yilh0s6LeUSJg44H6bmc4cZ85J8ESU93LHJNwU1tv4d6sW2HzfTgHFeTPdN3siQ4r3lDCRylTURPGY2rsJ9PjSdP1Xy9n1vbaRlU6GXzJbdfZ2eAU04AhxBnmrbWHBDbwzm0fKtj6qAD2SCke8xg1ebavBjfc5tv7IvglFN
 wllZO8Ez
 bzKceudFCup03NGdHdi40Uy0xDdT6DJJdsr3auHQsifgzkR18zfuDTLwe+eu9ebX3YWkh1mDBVWj/eydicHBk07fl3uAp75e/GaEa7pY9qX3q2nRmRHD1L01bd8uuhl3/qhnBvOF+X14uevfX5Q8ALBE1OpLSkP0CH+AUupgdHzbmH7Y916CoeSbenuwga3HbuDEXlkTda3GuIo69Jccrtp70W77aexfITTyqHuwfldN4fusIEKj8z9rwlu1GnZ937Sz81BaZBYcAO73obAK5Nk/iUCSHKDTg2vkXM0PCDVmrfHmg6Oixu0xKZZPMHnKJlhiAHmu7QQLv21BmHcJk7FdGU8IZpWD+XgNiznuzvkW187+qHy7sy7Jn/Sv9ug12d1yX/GSwOQ9EZfbrto8o0R+Td2VJGhspgANf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 03:47:07PM -0400, Gregory Price wrote:
> On Tue, Apr 21, 2026 at 06:01:10PM -0400, Michael S. Tsirkin wrote:
> > Thread a user virtual address from vma_alloc_folio() down through
> > the page allocator to post_alloc_hook().  This is plumbing preparation
> > for a subsequent patch that will use user_addr to call folio_zero_user()
> > for cache-friendly zeroing of user pages.
> > 
> > The user_addr is stored in struct alloc_context and flows through:
> >   vma_alloc_folio -> folio_alloc_mpol -> __alloc_pages_mpol ->
> >   __alloc_frozen_pages -> get_page_from_freelist -> prep_new_page ->
> >   post_alloc_hook
> > 
> > Public APIs (__alloc_pages, __folio_alloc, folio_alloc_mpol) gain a
> > user_addr parameter directly.  Callers that do not need user_addr
> > pass USER_ADDR_NONE ((unsigned long)-1), since
> > address 0 is a valid user mapping.
> > 
> 
> Question: rather than churning the entirety of the existing interfaces,
> is there a possibility of adding an explicit interface for this
> interaction that amounts to:
> 
> __alloc_user_pages(..., gfp_t gfp, user_addr)
> {
>     BUG_ON(!(gfp & __GFP_ZERO));
> 
>     /* post_alloc_hook implements the already-zeroed skip */
>     page = alloc_page(..., gfp, ...); /* existing interface */
> 
>     /* Do the cacheline stuff here instead of in the core */
>     cacheline_nonsense(page, user_addr);
> 
>     return page; /* user doesn't need to do explicit zeroing */
> }
> 
> Then rather than leaking information out of the buddy, we just need to
> get the zeroed information *into* the buddy.
> 
> the users that want zeroing but need the explicit user_addr step just
> defer the zeroing to outside post_alloc_hook().
> 
> That's just my immediate gut reaction to all this churn on the existing
> interfaces.
> 
> Existing users can continue using the buddy as-is, and enlightened users
> can optimize for this specific kind of __GFP_ZERO interaction.
> 
> ~Gregory


I am sorry i do not understand. Users have no idea if they need
"user_addr step" - it is an arch thing.

the places that pass USER_ADDR_NONE can avoid being changed.

*However* without this change it is easy to miss someone who
has to pass the address and simply forgot to, and this
someone gets GFP_ZERO from the caller.

It took me forever to find all places as it is, at least
every change is explicit.

Because no testing on x86 will show the issue, and it is a subtle
corruption even on other arches.

I think churn is better than a risk of silent corruption...

-- 
MST



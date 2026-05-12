Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC010CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 22:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64F8A6B00A9; Tue, 12 May 2026 18:03:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 627556B00AA; Tue, 12 May 2026 18:03:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53D9E6B00AD; Tue, 12 May 2026 18:03:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4775B6B00A9
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:03:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F23F61A05F4
	for <linux-mm@kvack.org>; Tue, 12 May 2026 22:03:45 +0000 (UTC)
X-FDA: 84760145610.22.4E53DA0
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf03.hostedemail.com (Postfix) with ESMTP id CD40020005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 22:03:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Z2nSGZok;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778623424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fpy4x7dEQdIOgJjvqOzPRDk/nU9rzNx4M+UIRXa20ZQ=;
	b=6QhKDN6XahR2iszkU7jxSsImYKfcu50H29h7mcYNNQG8FNKQe3OYVrGNeuXQvJ3MUgfpGk
	ba5o3w1RhdIQ9Vh2k1Y43GkbJJ3KibVBwdd3LRx4DY8mYv07y2ml3+0nQOBoEkpUspZiat
	yS0M2NPGP40KmhgHCj3IDWsjU3u8Oo4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778623424; a=rsa-sha256;
	cv=none;
	b=2tv1Bka1p89Q6Dtr9ZLb35vt/PRl3xF6zp0h9XRkZPYlTa3YDMc1077iXM+Y35Y0ucw2Mm
	s7rshT6LoBE8jqYxsRByUeyW9qlAs/ApZDZ0Gx2hEG2tpakp6Pr6JfJ+e848r204F3kG9K
	jY1iyxbEboqa/eumSPI1vT4oY/HhFdc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Z2nSGZok;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-512f09ecc67so42755491cf.3
        for <linux-mm@kvack.org>; Tue, 12 May 2026 15:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778623423; x=1779228223; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fpy4x7dEQdIOgJjvqOzPRDk/nU9rzNx4M+UIRXa20ZQ=;
        b=Z2nSGZokIKlN980UzhWKe3LJFCSI/ZOR5EXMGZuTyOPCaIVmQzsdbgud7UAI/1IR7I
         eytcmm0+73MOY7YSdOb53UT59YXWoNw4yuVE8itcrHsM4h8FCml/l+vW1e3cSwAdJpfN
         pxI3zLwYc+RNdVjE/pKfrh1neukeY9srYVo2YjtCLHFgOsME2VCxCD6ysxEBkcPjDpqZ
         ja34ptNCj6kHlCLKtRsVCxfAuXIOwqFnwA9dyuYJ/gReVdr0hToyLFck3SGm06mHUdRy
         88oCCp2P66DBnEKsFoYPl1pmQEvKJ4Bsn0VAxflQo+lBD/V45+19l5Tj6u1bEUdbXtrU
         SrlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778623423; x=1779228223;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fpy4x7dEQdIOgJjvqOzPRDk/nU9rzNx4M+UIRXa20ZQ=;
        b=lOc2QXY+bLH/7Yyu7l3cmjtOPpJceeS9U2bEo4rhwS/kpwxU7GjZvperLRVMC16LvM
         teGsiuaz8ikWM/4N5zo42PTlWU5QdAoU5vvM+Hf+HurkvO3OAAXClBfyXpmEewBkpVNs
         3Ek1Iql608M+99r+ZI91pdBzfew6SUozbrpyZUbfLigOyPTv9NCTgMZBHKvvr7lTVFpj
         pi8k8ciockCloI2/uCybNSroouT8+Wh9M8u+ZmphsdaSlH5nj2IGeaITCWDqbyIY+kRF
         WxVUwaLegCMo/KZIwsMzPY0QICaYkDPvFhH1iLO5N/3gHvMxXrQUNskhfLwdQGb1BgSd
         IZjw==
X-Forwarded-Encrypted: i=1; AFNElJ/t7d2BShhbCzKOZEyG37p2Q5o4RAlMSDCtUjMPnSwEP9Q/pSrnt1OUezbzI3JdgPlMcCODUKiL5g==@kvack.org
X-Gm-Message-State: AOJu0YxtjpdeDaInUHq00omsslsNVnYSkoL1ivMDvBOkPk6YSnL1ZFaE
	IGIuc1o70qRpd2KarqAejUbvn43iyqr8q0gYswXZmMnQ+0bszVpADt1BB/iYAc+XRvY=
X-Gm-Gg: Acq92OFRmLTpgOanbIkf39qBDZmr0Mejy23dvzJRzyW6lESImtKlDs6IG/7bf+iRkfk
	/LYZGs6B53NsFz8CZvRQRYRVJWgPjkeGYGis8+Tz9rP+VLdvYuuMfOWIYgRZx7N8VQGhkhHHx9R
	NbvaIVGjSsD8UuIUQN8v2T8giwXoEmt6ZIIJoHg+D1cYyy44duk1OuhVHbfwpASFBP3vBY2RIEL
	7YT/WQjvG84zbcOX0Alj7BEfUdIXQcvKqwxmN+nrlHwR1q36+kPfp/XRU8aSvBpMJ30jE0o03qB
	WH8UwjIAldHdTaDV52ckPrA3eRgaUiQGSOerq4yL5dTD7f3WmbHBpHW44VO/Dhha0gRATCJlnck
	vb6Qcec/TER2ZZ2iWSsEe0Szw5c+Q4PAJPDccTCakKu69Bq7oYKkzTV5AHbcotnkBY9x0el5j5p
	KLTJITROOuNn0ZWKebp2gLqcjU9N6nwYrbIV169UnnbP5k4xj+4IgieVP6tejubn3WP70SYwFTi
	Ok2OabbyIEdaKT6NAAd1eE=
X-Received: by 2002:a05:622a:11ce:b0:50f:f0be:dc7b with SMTP id d75a77b69052e-5162ff46f46mr3954791cf.39.1778623422619;
        Tue, 12 May 2026 15:03:42 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5148e7c0fa5sm141204081cf.16.2026.05.12.15.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 15:03:42 -0700 (PDT)
Date: Tue, 12 May 2026 18:03:39 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v7 17/31] mm: hugetlb: add gfp parameter and skip zeroing
 for zeroed pages
Message-ID: <agOju4MRXyS7Wp8E@gourry-fedora-PF4VCD3F>
References: <cover.1778616612.git.mst@redhat.com>
 <4039b0b96594b69b15ad4bcd64cbb33de3cec350.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4039b0b96594b69b15ad4bcd64cbb33de3cec350.1778616612.git.mst@redhat.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CD40020005
X-Stat-Signature: f84m5ygkcysej46w48mmazene1uiqso5
X-Rspam-User: 
X-HE-Tag: 1778623423-630908
X-HE-Meta: U2FsdGVkX18MqjBIoJYBpP9n7+WoGxCSOS+gQKuuePHj6VDSyCixPPU9I89RjSmu2JU1I5hR2xZ6GdWmN18eNGeMkowr+eqR4yVwMOadrhqzyxBOTCoBVqgWuSgwRgztp2rt6hNuGYw01645wHnUQoZ573v7XyHrgLoegiaPZyB5VabG97jrDi8zaSLAk/XruxWa8BICJeOOaRCmecfGcWQa4qMzxmUD2BtCfQsck3XJ1B2APd/UfWcc0c/CdhY9JEV3yU36h8TPlypnggym3K8rAeGB2peDKRqBo0x+TeMyPmtWMnqQ0ZNS6/dSGa2uJyXqn4Xjzso69PaANlwciI9tC177YawV6GtLSWoIVMVzCZfZf8+UbUFImhxZTeyGdsDgh42yRMxx6uDn9ukn4w7k+a16p9S7l1I//31y46MSFG5mxrJKLCQZn3wZ6VOCJ5eDeNeVGzz6M9oshsQGkARYcA20NHq9kRVw5HIb9f7uJQzvdizFbJ0Lb/KA/l110A5jBNDP4NuG6KVrAWBVYTKD2YQXGoJpOK2uBXAZ4p2dSpg2GLUUW4JOEAKGxIwAeCKAKkaG0zhgwTWFopfN4sMW2IyCFIQtI7bZA24AVQ422RdY85XlV7WNmAFgsBzBJT9x5nPbbCKO9R4Y0xgSo7ihSOjxwLTaMV/OT0kkpqAwoz2gB4sai0obA5HLYRnYfOep/FyjPLxytTK3pT19LX5RW4G6e/iDe0XLq4feFEGv7U0shp/oA53RkSKOAnL0njdXZ9VA3lsQdVvypQ5XgpE/ZTsROqhbPfKTJMjWX7/q5M1PNLT/aT1W6dpVp1PS+dM/eHW/XL3cOpbdJN7itYex8DLuNkgfi6XIi9leGV8gCH09vs71/+AnBgtsTZHPsS6CB5hWlKuJEYmLMtLhsCh0WYKxtbEMlgbL17dNSeB53E5GdzAuDgtDAzAONc7wigsGo0+yWE4cvkZAwJo
 5YLszY0D
 GAQUozZV23JYC/e2Rzy8vxhq87ol6IE5cZC1JqhQ8QTejgHk6pkRFOj+qpvJtJd10sG+c/pNYcChGejbTVV6GigbUKvRGXzqg4uRJ9fn/fx12xm90hERxsno7JRe4DpEj6R6EKabcS9lo5qqRkZjL0ywuKE1HW9+ncbSIbQlpSAdhy6aP9zRcM3wA0yz6w0aF8rmIiPkBd3ooRkGszsGyNml8oUcGcVkXnFZ4/PQr8m2/e1x+oj/pgAcKvraYadD1QqVtlXF4gbZxJaL2VJp6I4mgt9LnYuYrmnc/6R4AU3kjsjF0rGRjpY3mveGiIUFS0yxBHtP/Y47l8pHB3HZH/NGqsUInll+k4Zpr/m6VC8c5VQbmpvT3+opQu7u8kznr3JWIIeKiir0X7Y7KVQETKLkvbFN6N8rq4Rho07w6qijJQIw2WH2vb1quy1tG53ahp+9b6QFXdGiVVRs5IFY0rot0tgPxH2fdh9vOmagu4Y2+kM4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 05:06:37PM -0400, Michael S. Tsirkin wrote:
> Add a gfp_t parameter to alloc_hugetlb_folio(). When __GFP_ZERO
> is set, the function guarantees the returned folio is zeroed:
> - Fresh allocations (buddy or gigantic): zeroed by
>   post_alloc_hook via __GFP_ZERO.
> - Pool pages with HPG_zeroed set: already zeroed, skip.
> - Pool pages without HPG_zeroed: zeroed via folio_zero_user().
> 
> The address parameter is renamed to user_addr; the function
> aligns it internally for reservation and NUMA policy lookups.
> For pool pages that need zeroing, user_addr is passed to
> folio_zero_user() for cache-friendly zeroing near the faulting
> subpage.  All callers pass a page-aligned address; the
> hugetlb_no_page caller passes vmf->real_address & PAGE_MASK
> for consistency.
> 
> HPG_zeroed (stored in hugetlb folio->private bits) tracks
> known-zero pool pages. It is set when alloc_surplus_hugetlb_folio
> allocates with __GFP_ZERO, and cleared in free_huge_folio when
> the page returns to the pool after userspace use.
> 
> Suggested-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> Assisted-by: cursor-agent:GPT-5.4-xhigh
> ---
>  fs/hugetlbfs/inode.c    |  3 +--
>  include/linux/hugetlb.h |  5 ++++-
>  mm/hugetlb.c            | 47 ++++++++++++++++++++++++++++++-----------
>  3 files changed, 40 insertions(+), 15 deletions(-)
> 

This seems much much cleaner this way.  One nit, doesn't need a respin
unless you feel like it.

Reviewed-by: Gregory Price <gourry@gourry.net>


> @@ -2980,6 +2993,11 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  
>  	spin_unlock_irq(&hugetlb_lock);
>  
> +	if ((gfp & __GFP_ZERO) && from_pool &&
> +	    !folio_test_hugetlb_zeroed(folio))

stupid question:

   if (!from_pool) - wouldn't folio_test_hugetlb_zeroed(folio) be true
   because __GFP_ZERO is passed?

   If not, SHOULD it be true (i.e. should we be setting that in the
   non-pool allocation path when __GFP_ZERO is passed and allocation
   succeeds?)

If so, can this just be simplified to:

if ((gfp & __GFP_ZERO) && !folio_test_hugetlb_zeroed(folio))

Maybe that lets you eliminate the bool entirely?

~Gregory


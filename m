Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBFCACD484E
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 21:48:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31CD16B00AF; Mon, 11 May 2026 17:48:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CD956B00B0; Mon, 11 May 2026 17:48:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 194F16B00B3; Mon, 11 May 2026 17:48:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 04B186B00AF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 17:48:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB40A120118
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:48:00 +0000 (UTC)
X-FDA: 84756477120.20.2A79E7A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4E375C0009
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:47:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=We3Jcm0z;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778536078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H1xQri7WeZK2KoP5ZA3AQxtudqmOYwmsKhoFrsVAKDU=;
	b=Cr0GXzMpPOoAo6G2wgh4lpcTeOCXUJbJTHwHybacSVte376Pxl8W6FMtO5+2Eukm4+aX9/
	u249sodht4I0mR//NTAJh/N8nY4FD7UolXUvszTWrwu/88lOecmksHIYnShpQYLPteCCfg
	oL70OJhOTeUXTUeuGeqlYdP7fepapmY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=We3Jcm0z;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778536078; a=rsa-sha256;
	cv=none;
	b=Dlkp0gZdQc0Vfd4R7aWWgLB7j7/yhw50/zcqBMKjYdmi8hLAXKcvSk0RpRo6Or96HcGBJk
	1ILy0/mQ0b3jrOByazcoES6bDgpE/EJj8pUXTu5ZZWaumv5m5InLMU647qaEeC4d6+f+Rm
	S9eltFGurixQHgA63IFRzNQmbDYGlQ8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778536077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H1xQri7WeZK2KoP5ZA3AQxtudqmOYwmsKhoFrsVAKDU=;
	b=We3Jcm0z0zWTR2lMgmkqZKpcJZCLmyi5HzfpYAf+169bQVb4V5eQ++IiWTv9+mMsVNlfx0
	169+IsQODI7NpOforTUtjg9jL4S8ofaXfbkhDCpyXVxW6XUYkIJ2ZwSQVmHonvkGYn0aWs
	LfwM/gQv8zET5vSledQsSIlIqiDVDAw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-237-WYm08JDSNBq4p9qm9Iksxg-1; Mon, 11 May 2026 17:47:56 -0400
X-MC-Unique: WYm08JDSNBq4p9qm9Iksxg-1
X-Mimecast-MFC-AGG-ID: WYm08JDSNBq4p9qm9Iksxg_1778536075
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48a589c7879so43606805e9.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 14:47:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778536075; x=1779140875;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H1xQri7WeZK2KoP5ZA3AQxtudqmOYwmsKhoFrsVAKDU=;
        b=Bqwt1fh2PPWuOsL1i2Xqt7fkPuxb/V/PeJv7+/IkXRJemSoudwUniBsALy4yhIyMGX
         gCRiopUm/D+9lTOYE/Tw5yJN0Wrkf8FJV8Zx5zCIl+8i3KhZv2dBmkfm/q0fIDFO/Mtu
         JDbuupr27+VYQ1A5/JUSNVGTg9sYXux0MlooseBwCBtCZ4LhOVDAd04z9ENFaungFLp6
         mpIvZ3K8wsjOquKaEslzbhfsuhW3EZFcnZFNlVgSS/nPo9fGPg+J68rUxYTbCaXANzOF
         lpIow7aW6dWUg8m5nQD8+qTKKaevfJE1VR88Pdwu+d5oWp/NR04eDbg/gG3axkK/A1Vr
         L+ZQ==
X-Forwarded-Encrypted: i=1; AFNElJ8w7hZY7SspvwKmuq1Htc4RAYfh/p9nOjcAMvn+zVoetYiB/GabvlhitOVaOlmip1TmW1mgG7TPVw==@kvack.org
X-Gm-Message-State: AOJu0Yz0j1yaFA0FfHy46VW49hiJKYaE2KHSOS8YF5+iJrBvDp9+3Paq
	0u/n7j/xCT0vYnp4pCa1RX/Fk9kqTeVMjz7gQRDwWFdp3cKMMu0qkWjGSy1OV0zM1Wx6x7ec9lA
	Cboyo8Jyn9lNxWfCgITnL6OphjmSnj6WMh3d5vQQqWubQLcMlPxdW
X-Gm-Gg: Acq92OFBKbtUNifjzc+PPB6tOp7SlGrOmrKHp8Ce8dV4EfQxKeDxGCfkLzI4P5xjcvu
	JfAeEsXGneMFUWilAO11qdgWUgIw0hNBmKzu6IAg2IcToLf86hckKLNqaKJgGMukwfJEH/tHnBA
	ier5ZDbWuPLQq9hkoXTI8tasxvSL3vjpnzxXxkSkiDiM4gv6OggRO4Ceg98UmZu4nce6pcGMJs1
	xGA+QTah2Ro0So6M3mIAsYxYn5zpfaMFbA7XATyYe1srFq0h6hLi36XyYoxMIV25CTPa0lVR7wx
	NkmYLv/KuoM+FhoTOwsQAiMO9glk41cugw8sLT1izar/asW9ud3c9qQ35qLOr3S8D2+95z46jkB
	lQKcXYLTRrgbxuXLWsnhAMa+0kq566NcoL6XjCbsv
X-Received: by 2002:a05:600c:3f0a:b0:48a:5339:a46 with SMTP id 5b1f17b1804b1-48e8e208ec7mr17163395e9.9.1778536075130;
        Mon, 11 May 2026 14:47:55 -0700 (PDT)
X-Received: by 2002:a05:600c:3f0a:b0:48a:5339:a46 with SMTP id 5b1f17b1804b1-48e8e208ec7mr17163285e9.9.1778536074640;
        Mon, 11 May 2026 14:47:54 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e8e5dd3e1sm8561305e9.1.2026.05.11.14.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 14:47:54 -0700 (PDT)
Date: Mon, 11 May 2026 17:47:48 -0400
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
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH resend v6 14/30] mm: hugetlb: use __GFP_ZERO and skip
 zeroing for zeroed pages
Message-ID: <20260511174337-mutt-send-email-mst@kernel.org>
References: <cover.1778489843.git.mst@redhat.com>
 <fe1d24d4deafe0f5d1a9c51fcc040d9561c8592a.1778489843.git.mst@redhat.com>
 <agIFq63QZugkWcXJ@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <agIFq63QZugkWcXJ@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wfVGFWFTENOQ5Yy0ezihL4xdlTPrt-twdo9ayXNF4FY_1778536075
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: pc4etn9emhy4uaxcj5wiktttqe91hdt3
X-Rspamd-Queue-Id: 4E375C0009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778536078-76657
X-HE-Meta: U2FsdGVkX1/hQiiNTEy6J5nU3Xc4qWvrbX+8e3kgBMaLMUwurqAqmyPvU8zryg0rF8m1eibZ3lURksYHP5r5RjjmSwV1RkbCdUQdRzzJuvHtqUXJhrdSbxubNu5PkayL42dstro0AVSorKq2BuYZzGS41OjdDx4+LVUkaxEMSR44EF1jRUFthZNhGIKTxtzQC5FMTlUjURTkeH0CME/ynXIo5JahgxCaXGxHGKYYdjVeMdiq5+26g2hWy8CDG04XRNU7jjozDQN1QPQn7s+6r6KPYsWhtznBEdFTsIMRcQSHzQRfYzR5XHk3/d8alka9nRjEWx74mYb+h4MHw5edKY1FJmKkJ4SFRMH7Ydz8CO7yUH2eKdoBZRN2CcFnA9IgQUk0JSklMC0c3bQjGj6F334OVYAq2J5JwjpSbnAcemLE0CtD+XNhrgCT1rvEJri1op7w0NRagbjpV+1UYGgKmdAZyuStJwsU4aLp+6xe8lXdtVjg0lH7FbOYKsXGq2TMo00QZsXAuQAQfwghnaeP9LWU7LmcJyFcY0GJ5r39PQ8ixeEyzeZgAoaXKLZ69maBQv6KJX1kSri5OKx+6O9lmJWncNapZfQt3I3uxiD3QS65MBVapcMkfhKZDv4S5BUVj3ZjjmpE/JfWmmVnjh/+juv/zVfN2qa8ZF+1loRwKrq5TZYGz5cjnXEIUXdjxdjzjePa07NV2HgM3u9nuDVrs+G8EP9k90v2JNaNn9fsQe24c6iHJhmMsz7qi7a1kVGTrUAqj1OCB1HVzGa/VkbPjsnpqSs+SnaMsV2NJhVq88dBclu4VcNEeJxWr7xLiV5ZxJUr2L+I+5ooNwNfeoq+NhfMSjD0BW9/ecASsepnNQmglB3z9lD2gyFgj2Aat9LGIOKW/0OS8a7orF2SfBzrWzirPTAk93a8kj95sCX/TvF1vBmqPcYx3zwfoM7fOEdkIwU87lrQan/PBMHO/sG
 Gazz+TE9
 HneUr9A56ePDCrsbW9wpOmD7BddBigtCM1VNftYdTMNtEZ6wtfQFI/9VrqhIeyLjLxljYThNon1ELGREJRffVAhiYFgDXZ/jrKNA4Yb7orJhP/GnFO+LXvbUGhFO8kztclI/AVdIHAmzwdlfneaCRc+RcLi7HJah6aBEBGVAMQJ7EFeyrWYmGb5Om4ARicam7tGPTOpYT6MY/bhfpkdXOLZr5PSrDmkdm8DCTX+4U7b7YxEnk5nziTgRxsj1rgnolwN5e/WqeZbj4OMMCRt9JtwkX3E/JSWmCnBvxcJXLXfdnrfIFHB2ghjsaLeBia06gYZJCHC2eT6fasJuqVeqkNrzdjMpajSyukeBS6bXiLexfnWtQUNpR2ukFVLjZE2UgTINaHMrrx2DI+GaPFLo77eGudCERJHMbpWQYpZZPsX39l5dlYfAJklV5LA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 12:36:59PM -0400, Gregory Price wrote:
> On Mon, May 11, 2026 at 05:03:02AM -0400, Michael S. Tsirkin wrote:
> > Convert the hugetlb fault and fallocate paths to use __GFP_ZERO.
> > For pages allocated from the buddy allocator, post_alloc_hook()
> > handles zeroing.
> > 
> > Hugetlb surplus pages need special handling because they can be
> > pre-allocated into the pool during mmap (by hugetlb_acct_memory)
> > before any page fault.  Pool pages are kept around and may need
> > zeroing long after buddy allocation, so a buddy-level zeroed
> > hint (consumed at allocation time) cannot track their state.
> > 
> > Add a bool *zeroed output parameter to alloc_hugetlb_folio()
> > so callers know whether the page needs zeroing.  Buddy-allocated
> > pages are always zeroed (zeroed by post_alloc_hook).  Pool
> > pages use a new HPG_zeroed flag to track whether the page is
> > known-zero (freshly buddy-allocated, never mapped to userspace).
> > The flag is set in alloc_surplus_hugetlb_folio() after buddy
> > allocation and cleared in free_huge_folio() when a user-mapped
> > page returns to the pool.
> > 
> > Callers that do not need zeroing (CoW, migration) pass NULL for
> > zeroed and 0 for gfp.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Assisted-by: Claude:claude-opus-4-6
> > Assisted-by: cursor-agent:GPT-5.4-xhigh
> > ---
> >  fs/hugetlbfs/inode.c    | 10 ++++++--
> >  include/linux/hugetlb.h |  8 +++++--
> >  mm/hugetlb.c            | 52 ++++++++++++++++++++++++++++++-----------
> >  3 files changed, 53 insertions(+), 17 deletions(-)
> > 
> > diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> > index 8b05bec08e04..24e42cb10ade 100644
> > --- a/fs/hugetlbfs/inode.c
> > +++ b/fs/hugetlbfs/inode.c
> > @@ -810,14 +810,20 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
> >  		 * folios in these areas, we need to consume the reserves
> >  		 * to keep reservation accounting consistent.
> >  		 */
> > -		folio = alloc_hugetlb_folio(&pseudo_vma, addr, false);
> > +		{
> > +		bool zeroed;
> > +
> > +		folio = alloc_hugetlb_folio(&pseudo_vma, addr, false,
> > +					   __GFP_ZERO, &zeroed);
> 
> This feels like a very odd pattern:
> 
>   1) ask for __GFP_ZERO
>   2) Have to check whether it was actually zeroed
> 
> Seems like the zeroing piece should just be sunk in if you're going to
> ask for __GFP_ZERO anyway.  And in that case, maybe just `bool zero` as
> an argument, rather than GFP (to avoid future overloading of flags).
> 
> ~Gregory

Heh. The reason is that it either allocates from buddy - using gfp flags
or from the pool, in which case it zeroes.

We could even avoid the bool - just test __GFP_ZERO inside
alloc_hugetlb_folio. Would that be better?


-- 
MST



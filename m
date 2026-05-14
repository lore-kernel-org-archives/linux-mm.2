Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E57FCCD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 18:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 483C86B0088; Thu, 14 May 2026 14:00:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45B7B6B008A; Thu, 14 May 2026 14:00:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34A446B008C; Thu, 14 May 2026 14:00:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 242D66B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:00:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E6F0AA073E
	for <linux-mm@kvack.org>; Thu, 14 May 2026 18:00:44 +0000 (UTC)
X-FDA: 84766790808.06.1D95C1F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 51765C0004
	for <linux-mm@kvack.org>; Thu, 14 May 2026 18:00:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W2jMVXVf;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778781642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oQlL+kOZwMBzhWKBZwEOSjeyjgShl8X0ifAvXv35rZA=;
	b=U6nvH0RQq+WcJ/dDlv0nUFBkAX+Uu0IedTHF0DGHuXSJhq5ktjh5cmiOoLIgZl1mm2wlXl
	dKSBAUYnTfaxPyhvlVbGO79jNGU58YQqmqQwSZeKaI/apK2EswOSPnhsHhxkeM3u8/vZRX
	01JMMrzV9hgRtjB3EioPw8QTW39MNCM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778781642; a=rsa-sha256;
	cv=none;
	b=ePRYQJeaOuObfVeO5wbVtibbsk4LRaUj7l+37M2+BIETz/an0gInv+NDAOt+Ah2D9TOrSr
	R2Q2CbnmBzOsQ09xtgPwrBAr7w4oatE7IL6764TF6oLKUbPj2SEOCKeNHf5+cXAt/HIFYw
	fXNGwWTtVUm1FKkT1MWmqXHAzkUciXY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W2jMVXVf;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778781641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oQlL+kOZwMBzhWKBZwEOSjeyjgShl8X0ifAvXv35rZA=;
	b=W2jMVXVf4h9ywGJcWknsH0xoIc5OwRj/01Od4W1BnmcBOSirRaNczybE00h41IT22cIcnJ
	m954TFQz3ODuKl+edihaQ+epBKkPVJnaJGNffghxurKm3sHODQv6OV8p7/dnDXoN1hfx/H
	RPKsCBzq0CvquBY6py6xGYDEYue9nMo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-308-efp7sppTMFyHHspVxDbYiQ-1; Thu, 14 May 2026 14:00:39 -0400
X-MC-Unique: efp7sppTMFyHHspVxDbYiQ-1
X-Mimecast-MFC-AGG-ID: efp7sppTMFyHHspVxDbYiQ_1778781638
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-44d9ace59efso5518759f8f.1
        for <linux-mm@kvack.org>; Thu, 14 May 2026 11:00:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778781638; x=1779386438;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oQlL+kOZwMBzhWKBZwEOSjeyjgShl8X0ifAvXv35rZA=;
        b=ekK9KURIZ2wcHDiY2m336CwSpDz2D+a5xMbrMGrdM8l7H6fEN4DhEJXYRtjsnEVIqb
         EeHY3c7B7lzKHGcl0cas0145ro1RCB4V2roCsfbOyiM0WScX0aY6QyvFEdBwjZ0Xihrd
         05LceITxGkz/p+uvxmSvxwloQGSCSDGfPtJI29zuOVhwm39NCN3BS6w2zgLKv7dSMVTX
         CvNxNonY6Jy/4A/wQf9uK4Ktuh2QhYxgOymGJJMpCnj86ojtcOMPm3mqEXOaXjbu8gNi
         R969ZDhOhSWPWRMlhHBnjSdBDrI8aMjsbkYIugSaZOoeKoS5uCNwCcz2hLMfmdwz0cXw
         ncRA==
X-Forwarded-Encrypted: i=1; AFNElJ8Vv6dsMcivt9Ke1oqrbuVudSuBaHfrZRrNgLFR9Md/kq4OiSSR3956ik17cWZwR0X10s8lFLHEUw==@kvack.org
X-Gm-Message-State: AOJu0Yz1s8lld5ZbRjyYoPH+dDeYAVZMOcbJvTQ4kAYY0e5VgDpm6KuG
	PHGZzPSkX2PCIqD4ATjFwob8BfktARu9vvhyINvG1HSETXV6iw/dzF0Y7FfHHL9x5wiRHsLaNds
	wSREzRPw9ZzD2YklNBmJSzyGP/a5DExAEuh8JVDTSu7Abl7JlVO9h
X-Gm-Gg: Acq92OF2RHR09z6pLVloDhIkS/NcWwNWbIQLPQ/EvYzwSuncXPGO8mzxF4W80vo+Bvc
	7wXszYWjGj3YYV6Px5ep7X9PsmkwqZwo78CKtUrOlsfe6RGQiKkDSCjI3UIw8OGPdzs1W5dem1F
	f6oePINf1HjZV48ppQzp6sGBxAwlJ76tCfWYAY1H89zR9yhnrft5tx3avswmoZiqLlMAGCoOXnB
	gX1A/Q6CxwfKlV7f/ExPWxbIyxtaif6trfYLJw5qgx4afjRUkVm4d3lr8ONdcGicAd1ThKg8Hl8
	1RkzGjhqjfjOYgX0V+6GycuazNkbYkWRfwW5Rx/QKDW4E5Z+e8rZOAR/nmqLmdayJf1SWEWKcJE
	rjs2FrjooNpX8xKURDJ5MNeOjh5LgAW/JshNnoSnn
X-Received: by 2002:a5d:5885:0:b0:43c:f7e5:817b with SMTP id ffacd0b85a97d-45e5c5cc2b5mr128591f8f.19.1778781638118;
        Thu, 14 May 2026 11:00:38 -0700 (PDT)
X-Received: by 2002:a5d:5885:0:b0:43c:f7e5:817b with SMTP id ffacd0b85a97d-45e5c5cc2b5mr128505f8f.19.1778781637466;
        Thu, 14 May 2026 11:00:37 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da15a6449sm7948329f8f.37.2026.05.14.11.00.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 11:00:36 -0700 (PDT)
Date: Thu, 14 May 2026 14:00:31 -0400
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
Subject: Re: [PATCH v7 09/31] mm: use folio_zero_user for user pages in
 post_alloc_hook
Message-ID: <20260514135214-mutt-send-email-mst@kernel.org>
References: <cover.1778616612.git.mst@redhat.com>
 <45d1ea85b574399459a64fdba28fcf04abfa3e7e.1778616612.git.mst@redhat.com>
 <agXS7dMmtJrPhu9W@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <agXS7dMmtJrPhu9W@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iENRhTaPSBz6f1fMK_FvDsl2D9-rwDySuE4LO21q1bc_1778781638
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 51765C0004
X-Rspam-User: 
X-Stat-Signature: 9yd58tk1r9ior3zoong5dcqw8da94izy
X-HE-Tag: 1778781642-594220
X-HE-Meta: U2FsdGVkX18SWA9KT4YPyurpUGK5JvJQO+Lnwg81Oq8P2LlmHT+FRVk1vZFI0pdpRNEw2olCgY+fjYzYPs55dJjq4z07C7hmx+vjLC8YZE1hLxwR4ZAHqGjn5TUIvhYEk8TzqJMyIhRtHkqKsPHiilchPuXBP/SIOXSrw0o2WNzpATA2I27vbsn1YfEwW50xMwOI9DbCiq5HMcHi+9cCq7QXJpyu0APgCbKU6LjRGPw4zATFPzvEMuHYk6zUlhNCYxcAE+t1K8pA4MvGN4j4IOLASEagLEH6fJ9d/8UeKQrXq249adtOhk1AAN3L4dMOPsIRDdiTYXsdYd5CsVdIGdLvPhv+ArQwvQiNplcaKJHsehdNYmYToHaWWs9GJ74jqkH0axUNrFWErQ5X2yrdiMVwAAMSBGYdAioZlTI/aYFisRVwxDeJ1EgrcVl0bXroyvBL+etrov+AWl6Dn4SNXWiUdk4BtqhjXI154dtx7KBkjdbnxfyHRoqaeN7dxDQvIBXO+lLizEx1UBmJJNbFU3OrQR13fX+xBSKVaQTji1a3CFOMiFcKS9d7ZEi1kESloojrJSjFS3rJgj0VclqrqxeDJtQNlqytRHecUc4gQURq1QaX2Gz+BMxq9G2yQNXlJewKv/SxTBJUX8xpYHG3o50V8lZ7wu1l5vE6wIUP1MvqxLJxqxvIDn4Eq+6kff/cTNitY2R8HOztmg08Fe0EW7lqOsZchOkbNLJjs4fgb6TjnXk2hzGUbagae9/2StipLQrzTRKPZvldedgR/87+CVu3y1bNYROf6Miq8DpXF80Zs+itwcuKJzKNc8NwYdO/PF81qajyrDGZ8FS6Sda/b2mL8uUBqBFDB1Cwrn3vh9SwBaoU4JgH74C+kkxby1NWOCdf0qgzOIaJKpjkIrh1ypB2AlOiyNQ14uRNfkZdjFAP9yjGmYrsLyH71wMvajf/uHWxrxHPyma6ZwXMtJT
 WEYU1STL
 fG25Cy4zs3j7nnlvM+jp99QXaQxNvUa1fl9IoUqd4TtxfDLB9dS/Pajb+4NjSFSYvqQE/DXoUE31ncsXO2GvytRI5adYXV2f6kyCaEKYnhJMgzo/FA5vFyD1BCMEswSYBJMNUQKUWxq0j4TFHKhvaSZ4dqopiGLM3/lPlzquhCRLEIN0HM5v+o9V0GS3WPH7ZVlBkvnnsLLt6JxAiPN6OTrhDq9SDJtAIMV4VCfTR152pmZGMtUCv4q+weWa5dRxuijAQdH9/ZqoHR9+cxh3PWT/ZTvHKxmKOJHbBcMFkTEt5Zlha6i29SNxtTyqsJGtlm4pKKf+9YlOKVUIk9PEeTq93koCxphPjxXu5YACQTNpAwF4PoftVZCM1kCueeM07CDt+wcntrJON8QNuD3pKkq+1on4REn1gfA5sLH7x3zy005WRXv88EFPCDg8f+yKnVIVUHM1z14HXRF4qHNkJqmb16KLXt+tSA6o8Ft++VeZEFykmT4z4PM16x499ZaFwpHVwMONDMqibt1k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 09:49:33AM -0400, Gregory Price wrote:
> On Tue, May 12, 2026 at 05:05:54PM -0400, Michael S. Tsirkin wrote:
> > When post_alloc_hook() needs to zero a page for an explicit
> > __GFP_ZERO allocation for a user page (user_addr is set), use folio_zero_user()
> > instead of kernel_init_pages().  This zeros near the faulting
> > address last, keeping those cachelines hot for the impending
> > user access.
> > 
> > folio_zero_user() is only used for explicit __GFP_ZERO, not for
> > init_on_alloc.  On architectures with virtually-indexed caches
> > (e.g., ARM), clear_user_highpage() performs per-line cache
> > operations; using it for init_on_alloc would add overhead that
> > kernel_init_pages() avoids (the page fault path flushes the
> > cache at PTE installation time regardless).
> > 
> > No functional change yet: current callers do not pass __GFP_ZERO
> > for user pages (they zero at the callsite instead).  Subsequent
> > patches will convert them.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Assisted-by: Claude:claude-opus-4-6
> > ---
> >  mm/page_alloc.c | 17 ++++++++++++++---
> >  1 file changed, 14 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index db387dd6b813..76f39dd026ff 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1861,9 +1861,20 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
> >  		for (i = 0; i != 1 << order; ++i)
> >  			page_kasan_tag_reset(page + i);
> >  	}
> > -	/* If memory is still not initialized, initialize it now. */
> > -	if (init)
> > -		kernel_init_pages(page, 1 << order);
> > +	/*
> > +	 * If memory is still not initialized, initialize it now.
> > +	 * When __GFP_ZERO was explicitly requested and user_addr is set,
> > +	 * use folio_zero_user() which zeros near the faulting address
> > +	 * last, keeping those cachelines hot.  For init_on_alloc, use
> > +	 * kernel_init_pages() to avoid unnecessary cache flush overhead
> > +	 * on architectures with virtually-indexed caches.
> > +	 */
> > +	if (init) {
> > +		if ((gfp_flags & __GFP_ZERO) && user_addr != USER_ADDR_NONE)
> > +			folio_zero_user(page_folio(page), user_addr);
> > +		else
> > +			kernel_init_pages(page, 1 << order);
> > +	}
> 
> Open question but not necessarily in-scope:
> 
> Should __GFP_ZERO just be implied if (user_addr != USER_ADDR_NONE)?


There are calls with no __GFP_ZERO but they do not allocate userspace pages.

  - drm_pagemap.c: GFP_HIGHUSER -- no zero. But this is a DRM device
    page migration, the page content is preserved from the source.

  - test_hmm.c: GFP_HIGHUSER_MOVABLE -- no zero. Test driver, pages get
    content from device.

  - mm/ksm.c: GFP_HIGHUSER_MOVABLE -- no zero. KSM merges identical
    pages, content comes from the source page (copy).

  - mm/memory.c new_folio = GFP_HIGHUSER_MOVABLE
    - no zero. This is CoW, content is copied from old page.

  - mm/userfaultfd.c: GFP_HIGHUSER_MOVABLE - no zero. Content comes from userspace via userfaultfd.

  - arm64/fault.c: __GFP_ZEROTAGS not __GFP_ZERO. MTE tag zeroing, not page zeroing. Page is zeroed separately.


> Putting aside how that's done without introducing another gfp flag
> (maybe something explicit like `alloc_pages_nozero(...)` ), it seems
> like a very short jump to just adding __GFP_ZERO to any user-alloc by
> default.
> 
> I'd be curious to know how many callers across the system omit
> __GFP_ZERO when allocating a user-page, and whether there might be
> scenarios where we subtly miss it (seems unlikely and narrow, but very
> possibly something a driver could do unintentionally).
> 
> ~Gregory


I'd do this on top if possible.

-- 
MST



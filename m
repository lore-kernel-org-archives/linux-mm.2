Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ECDDCD8CA4
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 19:55:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F8396B0005; Mon,  8 Jun 2026 15:55:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A96A6B0088; Mon,  8 Jun 2026 15:55:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 897936B008A; Mon,  8 Jun 2026 15:55:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 78ABD6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:55:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3D9CE1A02B5
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 19:55:12 +0000 (UTC)
X-FDA: 84857799264.19.2829E3A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id EB391120007
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 19:55:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E5ikco8V;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780948510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K1EvdDcjngGB9YGnsiekH6IRPqxO13+zTlrf/+W1zqA=;
	b=51rJT65FuQaV7yjtKxMydYFS88X+Dc1lhs4BhFxe8A4dRaYK6bNsONK6evcv2T0Ev+uJAd
	jy2+vzVd/zzadshZYmNjkFmswXT6+50TvOtcrJBScu2jkvXqFJ+ood3YTfyG1dnNAMVaHM
	z5Y7URNkn3Wlt1hfA8k04PGBhC0PBlA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E5ikco8V;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780948510;
	b=Svf4eB26LD6w+9iPj6Ds/Omvn8Y4/7B9Xq9x627s2SHqdeMrTJ0ah3CxOCrfLIdPKQxDVv
	F1cXqSrc5BFAlDMLjuS8cHeA5VayCG0mQ0ykwI57LfBLrfqTaBKUAYPkUqFoHGu46JbvfN
	EQ63WWkr9ygLN+e6OGBJg9xJnFrxhsQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780948509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K1EvdDcjngGB9YGnsiekH6IRPqxO13+zTlrf/+W1zqA=;
	b=E5ikco8Vs5Ubfay2HR/emi18DTrGA1G530CrjJ3Zt4Sl0RM70wq7rcYELJUtvA7oUqNdPA
	HC2jkXCqEbnVhG0gO/Lr5Op1jzEhNoyrWhETve+h6m7ANacsXPydQS1EO9e3el5sQUapY+
	Lx5zxFa8agc4/xaYmR7uYjh1PUSR2KI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-3-k7WjeOgePbavu-IXUzjevA-1; Mon, 08 Jun 2026 15:55:08 -0400
X-MC-Unique: k7WjeOgePbavu-IXUzjevA-1
X-Mimecast-MFC-AGG-ID: k7WjeOgePbavu-IXUzjevA_1780948507
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-490a786f987so53685535e9.3
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 12:55:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780948507; x=1781553307;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K1EvdDcjngGB9YGnsiekH6IRPqxO13+zTlrf/+W1zqA=;
        b=YL8PqjGrcqN8QwzDdqvyQnCke6n/ZX4XPx5DTgQ/dzbkl5zoyPLh7KNoFZt/wksC/f
         O4IrX6rLZ7AfBmIAJbmqCp1lhwxpCrceryt9p6VNcH+17s97DoQ4dR1nDq4hAcEHYDbP
         Ob1FDZmNT9/50GWsieT3Si4VOrD+R7vEAhXhh9mT+AZj7uXCBDVNwsYou8g/F4N3Dn8K
         YMRcbH9kDYEbn2DjsQvypo1dg2dXwK+ranVtzBSBprjT9euqeQCvfjbOYT/Fq/i/L+j4
         +y7/fFh3EFJccvsENJd4J2SpaSJ73gHOBWz7Whca02oVOkY+/d2j4DXTW2bFRcr0FPu0
         Hsxw==
X-Forwarded-Encrypted: i=1; AFNElJ95Hc/RFYSgaBYygBOOfn9fzd93ZlsF+tOW19XB5JWB0Hl6T3LwkHl7jr2zOUNcm2lYkZoRg6BOlQ==@kvack.org
X-Gm-Message-State: AOJu0YzMSViiPLVyzyg4W4ewexHPX79l6eba2frEPXs/OhtEJEH9RYZj
	6c+0b96N6/jUmScLpKAJ3gBUfggSVoUpxb4p9lSCydsK5m4ATILONCXkU+GHPld93uSaPvZ31mu
	Id1AHUoMrlBtWAnpRh8dj/GmliKd7ALB4B0uMKdi1tlLvYLeHlqHQ
X-Gm-Gg: Acq92OEkO4PKf/dy7fKgmwYokVe/2qi5z0oMJPzsgSMTRKCO1VYgs+1CzQmxELa4cbn
	HJ5ktFHbtLsBNeGWubMcejpQmqTmOa0Osec4itkQGJ0JGutO9bElpKSwC6GTBjIZsU+Npj8jZNt
	OcTJfWpg7bkYkF+E+0TNURGClrxlOW4FutRnGIHZoYBXlJsd2oDfD/Y92ivPeG3hQaTUS6BLIhm
	XxHBVWe9iCMDrXwlZFMSk1Sux/sQs8mSSE5/5szwImg2fJ8LVFjBh0TV18jqkdmIFkoE+XqI6U+
	NAQacHiQejnTh023kH9+AVFg9DPao2dUxTRXfY5YJG1Klxxal17xGfGHsmTPO7uOwPYR3PtjVDw
	0Ypk/bdEgFnImgrhgwr7X93dwTnia5eBgV8IvePwnWv9ga1KAK1Ch9Q==
X-Received: by 2002:a05:600c:a117:b0:490:c2a3:23d0 with SMTP id 5b1f17b1804b1-490c2a32441mr202152865e9.35.1780948506606;
        Mon, 08 Jun 2026 12:55:06 -0700 (PDT)
X-Received: by 2002:a05:600c:a117:b0:490:c2a3:23d0 with SMTP id 5b1f17b1804b1-490c2a32441mr202152225e9.35.1780948506137;
        Mon, 08 Jun 2026 12:55:06 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3fd663sm484058135e9.10.2026.06.08.12.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 12:55:05 -0700 (PDT)
Date: Mon, 8 Jun 2026 15:55:00 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Gregory Price <gourry@gourry.net>, Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH v10 17/37] mm: page_reporting: skip redundant zeroing of
 host-zeroed reported pages
Message-ID: <20260608154658-mutt-send-email-mst@kernel.org>
References: <cover.1780906288.git.mst@redhat.com>
 <6a2f93e4447e55ada6ccf0f4d5c64e8d41a848d4.1780906288.git.mst@redhat.com>
 <aias_qh3wR-Xkf6T@lucifer>
 <aibpL3REDdQ8Vhys@gourry-fedora-PF4VCD3F>
 <aicMl3hPJMgOkfSv@casper.infradead.org>
MIME-Version: 1.0
In-Reply-To: <aicMl3hPJMgOkfSv@casper.infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TjB2PJqDTOesD0ULmn67r9i8vlOv00qsB0lWOTMYSbo_1780948507
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EB391120007
X-Stat-Signature: q6h34eic51xk9ffsns78a5d7g9xema1q
X-Rspam-User: 
X-HE-Tag: 1780948509-44655
X-HE-Meta: U2FsdGVkX1+9Tzr4Ft+/Q0Eyi3qzMlx+RUcPz1sG/LcPd+7Y+fKnz8zMH8BkvNnBd3LQ0I7qnrDnNvQnajTQjxaVPAdqTyNl59Lv30XpctXee0ix2kSbzNR9G76/MdXpT/gz44+mA4G3XFeJMyJDiscw9acr+v7p/uIp0fw934W+s44ImxvOm8J90iO3IFbiJUZjzWqy5FpHW1XrBcfculk5gHH4qrQ1e5AXmKMkiG1+SXyVyKzdHSdf9jJfitXCTlaFkw0kTF5e0PuQc3Z1OIFuVAILNYSxfA8vZBPQftYoMdCR6ZGpja85J4GJ/fG0Fwx1wZ6OgHmM3Mn+dgHBskANqV34h6rcx6QGhvJyRORGc505cmINeMHbQ+df6wNEPYIzRat3gIZOkS0IYDo7WKtkusKCZ1AmYZFP4CtC8VufrRW2ztLQTsIFwPasBxIGY2/NzeduAMxB1JW2vs2GaUn3rmp2DUv8mm8fyXAntZovTCW93dqA2AW/BAhCuK0Z/x8To+ej9OolqRAcl6dSRxmRB9pELMsoYcD/znrmTf/Zna8IDjcbi3PEvmEcCktNv7S4whnhzM8Ih7vXkCPgR/pZyszukYYRBQYI+ex7gyfBz1bU+B7wrKhFCkNW4kX9DRKKyzS2z8tOrAnjGDJltIFj+A3CyJdHscXN0dnNXEvN9Y9Hj1mPDR6uitzu9A+27QkSjYipNS/+tohgCnDY/bX7rC3RG85xa1jGsCEkewhsNhKefFwXaV+cTRMWx1KsbMmXcuTvewQhDq+HOmEg2P7hcigRVcYLuuNMp1iAo7ASVZinIHqMBy7SVTxvUZxxcSKzPXv3/5AXxuiv3jeH8Kz64/+RKtEYq1D5GwHVCHClMepmGW6k38O5LHYHw1gKZZc7hCAdMVzQ5fQzRZGqCFWbF9qq+Ql+lWhvHJgVAJmZsgDczcHkZVJ40Z9/04rkmLhifjgNt9zX5AhMguM
 mN5ywkyQ
 C3sJGsUZH41RjZJ5KD+/iY0YSMp49VevLcwzoNMhojv0pSYZzqNyoX9hha7g4olRnbdvfRvBC44aKVCULt1I6sGVHmWhUSfl9gRGygw8OG8Gb/va/AJE+3vNWtVM1UYx4R+ClKfgi6EerFQbQWhrM9pjJBTY6WtmcxBJuKNEMX7ZgDOfuSG7nM0pZwy7xeDpu6kgwCVsVJmssHE44Y9kjfFVzyFFDdAyVG2qOvbMpCj+RiCbZr+y7DRkWpOT/BYs47Q47n2lfZluHQW2tEJimQeS5Wkv1mF17yydximngAO2zNgsu8YMxdXGvxWKxrlI1J7Bt4Kg4E8Y8328+a/CLqPfVb6ZY9WpvG3bg8S5SQ1bfdy2l+S+bpdqSWEttohbLk2ohuL6/VB/NfHALWWn7y47yqddUhXS9cIxUwWhWkltp1hVjRR6LuPdoj7bQkRV/k5kcTVOmsMjG/b8Yj5vtWxCc5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 07:40:23PM +0100, Matthew Wilcox wrote:
> On Mon, Jun 08, 2026 at 12:09:19PM -0400, Gregory Price wrote:
> > On Mon, Jun 08, 2026 at 01:00:17PM +0100, Lorenzo Stoakes wrote:
> > > On Mon, Jun 08, 2026 at 04:37:48AM -0400, Michael S. Tsirkin wrote:
> > > >
> > > >  void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags,
> > > > -		     unsigned long user_addr);
> > > > +		     bool zeroed, unsigned long user_addr);
> > > 
> > > host_zeroed or something would be more appropriate no?
> > > 
> > > But in general do we need to propagate this around, can't we derive it from
> > > the page zeroed flag?
> > > 
> > > It's really confusing as to _which_ zeroing this refers to, it seems the
> > > only one relevant here is the VM host zeroing but that's completely
> > > non-obvious and now everybody using these functions with the extra param
> > > will simply have to happen to know this.
> > > 
> > > If we could find a way to avoid this propagation that'd be ideal.
> > > 
> > > Failing that, making it clear this is _only_ for vm host zeroing would be
> > > better, but then maybe we need to think about how we could encode this in
> > > some other way, e.g. passing alloc_context perhaps?
> > > 
> > 
> > This is unaddressed feedback from 3 version ago:
> > 
> > https://lore.kernel.org/linux-mm/agXYbcuQYooG74pb@gourry-fedora-PF4VCD3F/
> > 
> > We can infer all of this from snapshotted page flags and propogate those
> > around.  This is infinitely more useful than just a single flag being
> > pulled out into a boolean, and more extensible.
> > 
> > void
> > post_alloc_hook(struct page *page, usigned int order, gfp_t gfp_flags,
> >                 uint64_t pg_alloc_flags, unsigned long user_addr);
> > 
> > 		^^^ page_alloc.c internal falgs only
> > 
> > Once the allocator gets a page it wants to return, it can take a snapshot
> > of the flags at that point, and then doodle all over the flags as it
> > goes through the page setup prior to return (include the post hook).
> > 
> > Haven't seen a reason why this shouldn't be done this way.
> 
> I'd tuned out this awful series since it'd become apparent that my
> feedback wasn't going to be taken seriously.

Sorry about that.

> Good to know I shouldn't
> take it personally because he does it to you too.
> 
> I think it's apparent that Michael has no understanding of the MM.

It's a bit of an overstatement but I'm more of a networking guy, yes.
What I freely admit I don't understand is why I have to refactor all of mm
first.

> So we should start again with the architecture.  Let's look at the
> problem that he's trying to solve:
> 
>  - The hypervisor has zeroed the memory that it passes to the MM
>  - But the MM then zeroes it again before passing it to userspace.
>  - We want to avoid this
> 
> Let's make sure that's the actual problem before going any further.
> Because I do have a design that will satisfy that without doing this
> insane level of invasive change, but if that's not the problem, there's
> no point wasting my time writing it up.

Yes that's exactly the problem I was trying to solve. Early RFC versions
didn't do this invasive change:

https://lore.kernel.org/lkml/cover.1776689093.git.mst@redhat.com/


But I was asked to refactor mm first and implement the optimization
second.

Sure, glad to hear what the design is.



-- 
MST



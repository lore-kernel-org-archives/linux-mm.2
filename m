Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2B57CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 15:45:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1042A6B0088; Fri, 15 May 2026 11:45:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B4706B0093; Fri, 15 May 2026 11:45:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE5896B0095; Fri, 15 May 2026 11:45:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DDD426B0088
	for <linux-mm@kvack.org>; Fri, 15 May 2026 11:45:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5ED801C00F6
	for <linux-mm@kvack.org>; Fri, 15 May 2026 15:45:20 +0000 (UTC)
X-FDA: 84770078400.24.BFD9226
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id EEB17C000B
	for <linux-mm@kvack.org>; Fri, 15 May 2026 15:45:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=diX7KA6d;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778859918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bRJQWnIR/vMJOWlGH40eGCuLKFeHnLlb7//zEsKwBIQ=;
	b=IP9ycQIvJyOZJ5dqvJapsZZVTAVPna6woW9lMJsrE/bC4nCuOMCavPcRaZjcB3Y2yaYf7C
	n6g1OkJm3wniEIVgezVKJ73JLBpcPCjmXwlJXotpPh16wBGyX1aWHIx2AlzYhuN2Juk+0H
	oqVEeNXaGtLoCmGX9h9mO3qcBKMCiYw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=diX7KA6d;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778859918; a=rsa-sha256;
	cv=none;
	b=nu8RlCft+KQbABadRgT77gtE0L6hgDN/A6nNdP2zIpcWKyk+xACvbkpS8cX782wnHVh7Ks
	KhYzuA0cWAng3uHCZCAnUhbMT1YHCpIRe/yXO5XxRmlVyAyO2uMrTlnwOofpj6iz8T8ghZ
	kAKdti8cXOs4kCGyuq46nGBixivlQPE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778859917;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bRJQWnIR/vMJOWlGH40eGCuLKFeHnLlb7//zEsKwBIQ=;
	b=diX7KA6dCN5aNaah3L6VfTDJTIAjz4owZ4PdrblEXoxK0gCjrOKKZZd3j/Dc7jSOkVx/kR
	thRcMQcENM+ghJWI2piKTrF5xAJUpy5gNgC1/+fc7TXeBJd8bOuBmmzrmcocgL5CRwh3Wv
	dwBfttemeOeq8yqUvYsHdQzCt3qtdKc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-Efj117PdPNaxrfLrseZgyg-1; Fri, 15 May 2026 11:45:14 -0400
X-MC-Unique: Efj117PdPNaxrfLrseZgyg-1
X-Mimecast-MFC-AGG-ID: Efj117PdPNaxrfLrseZgyg_1778859913
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-44cc3c9b2feso8408555f8f.1
        for <linux-mm@kvack.org>; Fri, 15 May 2026 08:45:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778859912; x=1779464712;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bRJQWnIR/vMJOWlGH40eGCuLKFeHnLlb7//zEsKwBIQ=;
        b=dK3KeL3kbkENHxz8zc6RYPxnh/LYbd0/bWxTolobY2cEBqS6+Nl1SddJLmYEYYLIse
         7a9MyEeaq+nNLfOR0dcVE4LTgdR5VkuhszhhBUgnZ9Y2ylQtabbWgxXTYm+O9Mx697mX
         v4hHBcohK8ZeKZ5fa84xCkTyOaeQyY+6LJCntrIPuKDPpNyGVvA3qAOUkLS0fEuFlvFl
         I8JzBRBnH8TP5HGz/2XRQYP6wpRvBd4Pk3oEMxWtrnm8w/FhRZNwnqacUgrae/GlEsl3
         1UfEYj2DxmoVOE3JwlCt4hy6v9en8gcmv0NYSQT5/iU0QG9B7DaAWiujnPKaWYGtK/Ip
         Dcfg==
X-Forwarded-Encrypted: i=1; AFNElJ/7PwRu+AmSYZ0F2z/e3O/AIy4p0gqVpK2QyXo9EH0YmH8r/f8pIIbks8V28w/KRIdFbhhMmW7zdA==@kvack.org
X-Gm-Message-State: AOJu0YxPNmTg7T8J73Ph/CBlo7b1m26PCbg8c0oVz8sQTx0tTsStEYkk
	kKyRc6kPiLxB3dsxt63e8xaGv/jwVPRapFCCkUnrdW+YDjTI4vbl3l6mPFSokMD9F421U4b21uT
	Hmde91qtPp9WKEaVtf167oxHnJRsZVtWA9JiRwXdhda/Q5++1mRkn
X-Gm-Gg: Acq92OEcTmCYzApc20AjDi5xwLxWKeWEzmg8rpHCZeK2iZcMzLz6UjhRYqW2qOisrQX
	MmuPaG8H/xIhkylAzNcJC/xoZuB1AIdc9gZDcwSpfbTBZiw3Hf9yrhiX2nVW/gp66Olhq/LIxDs
	MzTjIar3I4prhnFBZ5s9MwFd32hHlBXTGN2T6lXEXZ6tDW9KrrkxByFmRZUAWvrPktsd3ktcNMy
	ZZvSWXMJPN7r2e/jL5nDmrFmqsqUPW2rFWxzZejBCeEQDQCP8xUoUWu5n0c181KoaaqcJgZfWd3
	ufyf28rXfadcGJWdVfFOH8qXVEj3Pk1QlQ/K4kwMmpOn8SoVBOWV5am9H74rCMx79LHWSWn9SXX
	hjkOdygnRcIakGHnFb+8QWvrGtTC5V2JE+AHqnVe/
X-Received: by 2002:a05:600c:c0db:b0:489:1ff1:74d3 with SMTP id 5b1f17b1804b1-48fe63223e2mr46155955e9.20.1778859912400;
        Fri, 15 May 2026 08:45:12 -0700 (PDT)
X-Received: by 2002:a05:600c:c0db:b0:489:1ff1:74d3 with SMTP id 5b1f17b1804b1-48fe63223e2mr46154975e9.20.1778859911682;
        Fri, 15 May 2026 08:45:11 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe5ab527asm79317025e9.11.2026.05.15.08.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 08:45:10 -0700 (PDT)
Date: Fri, 15 May 2026 11:45:05 -0400
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
Message-ID: <20260515114250-mutt-send-email-mst@kernel.org>
References: <cover.1778616612.git.mst@redhat.com>
 <45d1ea85b574399459a64fdba28fcf04abfa3e7e.1778616612.git.mst@redhat.com>
 <agXS7dMmtJrPhu9W@gourry-fedora-PF4VCD3F>
 <20260514135214-mutt-send-email-mst@kernel.org>
 <agYa9s5B7OWG-kjR@gourry-fedora-PF4VCD3F>
 <20260514150750-mutt-send-email-mst@kernel.org>
 <agc-KFwvSDxEImVt@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <agc-KFwvSDxEImVt@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: H_ygMcPjhO98Fr5oma3BDeHdoeiPRXYfwpNG182URXA_1778859913
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EEB17C000B
X-Stat-Signature: krrtymj6m15y9cpcdiojc8hrqmzbdti9
X-HE-Tag: 1778859917-192501
X-HE-Meta: U2FsdGVkX1+UY3u47BXFKUpchWPbuWjaN8tIJnGzUy3204vkgB4Lp46mFrxj3OedH4NFlvK9sTty0Bp/jPYC32XidP5bntjj+XoiUM7Q2FZGiw827YGkYrUHEOgKMk8bvTBRJYcNgeMBpCrztktmQmiMOWUEu615rvB/wlVlBUooJChUk3hBvIo7ul1vf9x9R00TBPRalEMnlnWcc9UEhfnzXWpUYauXnc0pG8xjkjdKPO0AWfm/+OBlL6eacQ6Rx8rH4DL14Wpv5+gICtue1vVnW+RJlw4BHzZDXX9Q0LpYm5cSYYVIpRVsLqw/y2J75MTmZa0nP4R+5KD8EFhTr8LqijbB+k8oxBzE1klgkc6coF1yoFtwQKOzCUYK283GoIzat0kjR4zD2T5HTVddbmNPM40a5EncW6Ff8KMB97pXIXxlDZNhCt27jGeM+Xc75t+CdpHtGPwL8wvCL8aIK5TXsZbWhoqglPPXZMJ4CW/2O1YMgUh1C7Agm7scmKkI7kX/g8fPFBFYYrIxM7Ltkb6iwn2ssV5p0rFmaVRHdPL9e6eMsnJTqIzwiSRBAhcd3qxS4AtoO7arMS2F8zudik5GtCdNe6YJbYDt6kiFVj+z60Pxnvxzt/mf2r8FF+EP4OO/Ze80F0rfsmJcPOheykkSz63EiNBbAKn0kGCHoBiRTt3BXAo71ViIZpx0qsM8TTBf4Ws5GZZl+3HMr/XR4Se4zWgUBnU3PRIZmQGwcsom6kFS6o3f+tqC2jmVf20jtOxa+fDHjtqUhPtlhNF/QFnYFOD/FGeeaNVp732tN9+WKiSn+kgjdMHoqj+sOCFkBqhn8D3m7gbngXFg7INmqRjC+ZxjbJ84SIxhZzZxboHBza3jixOJ9BoXNVh3vcLfY0VFbf/SRbgnuqzFktG/VoaPAvOH+muEjXLQ6IG0+MDpvYd6C13HUeEwgvIbsLoxySXpBIEZ0helbAjB7kQ
 y1obe+UL
 4eyW4cQxdb9COXvovG2e2BXFgbcIvqqHFOrZowjLngI0AVJt783FGyS/LF/FW4TprvndMTa55hDoZfF4rmK2tQCoRBkzESPD1exi997XRk5vw7BN+wmt64swKfCHA0SdkpxJs0xh+vbnqPlgrimyGtb67RLJeyCSpcS9oJqZ1WB4wOBUhB7ifHc5ShVwK2dst7RcLe9St2VA+VVgNiqbp+q89rfbWTzWHknwsBeRxmedGRX0/M1qLcUOooac86HChwVGM1p0aYJFvLpmmhS/19SlZWJdwhSEEKfbNyXRIPdkha0HNFNomK8VlgRxj60Ecg9OgpArsFlU/Qte2HNrm6Wqxh+yKWo2oZ4pLKafx2nbqY/iF7Rg3OFuwtLVsLzl2/pvNz2rG4qCKY0rCDXWeOf8KDQyAwMuLMXkD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 11:39:20AM -0400, Gregory Price wrote:
> On Thu, May 14, 2026 at 03:08:13PM -0400, Michael S. Tsirkin wrote:
> > On Thu, May 14, 2026 at 02:56:54PM -0400, Gregory Price wrote:
> > > On Thu, May 14, 2026 at 02:00:31PM -0400, Michael S. Tsirkin wrote:
> > > > On Thu, May 14, 2026 at 09:49:33AM -0400, Gregory Price wrote:
> > > > 
> > > > There are calls with no __GFP_ZERO but they do not allocate userspace pages.
> > > > 
> > > >   - drm_pagemap.c: GFP_HIGHUSER -- no zero. But this is a DRM device
> > > >     page migration, the page content is preserved from the source.
> > > > 
> > > >   - test_hmm.c: GFP_HIGHUSER_MOVABLE -- no zero. Test driver, pages get
> > > >     content from device.
> > > > 
> > > >   - mm/ksm.c: GFP_HIGHUSER_MOVABLE -- no zero. KSM merges identical
> > > >     pages, content comes from the source page (copy).
> > > > 
> > > >   - mm/memory.c new_folio = GFP_HIGHUSER_MOVABLE
> > > >     - no zero. This is CoW, content is copied from old page.
> > > > 
> > > >   - mm/userfaultfd.c: GFP_HIGHUSER_MOVABLE - no zero. Content comes from userspace via userfaultfd.
> > > > 
> > > >   - arm64/fault.c: __GFP_ZEROTAGS not __GFP_ZERO. MTE tag zeroing, not page zeroing. Page is zeroed separately.
> > > > 
> > > 
> > > Right, so in all of these cases, it would be just as correct to pass
> > > USER_ADDR_NONE I imagine :]
> > 
> > Hmm. Are you sure? Isn't the address used for numa policy?
> > 
> 
> You said "They do not allocate userspace pages" - so wouldn't uaddr be
> USER_ADDR_NONE anyway?

That part was wrong.

> 
> Even if they do allocate userspace pages, they weren't passing
> __GFP_ZERO before, so either:
> 
>   1) They did not depend on the buddy to do zeroing before, and
>      user_addr is just a dead variable in those cases anyway.
> 
>      or
> 
>   2) There is a bug, and they should be zeroing the page.


IIUC, it's neither. Consider CoW: yes we are allocating a new page
for userspace, but no we do not need to zero: we are copying
data on write.



> I just see an interesting hardening opportunity.
> 
> Not suggesting you actually implement this, to be clear, maybe just
> documenting the idea on the thread as a potential follow up.
> 
> ~Gregory



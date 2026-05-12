Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09789CD37BE
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 02:49:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 185C26B0088; Mon, 11 May 2026 22:49:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 110E06B008A; Mon, 11 May 2026 22:49:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF3186B008C; Mon, 11 May 2026 22:49:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB75D6B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 22:49:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B73BA0334
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:49:12 +0000 (UTC)
X-FDA: 84757236144.14.CB34916
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5C9D1A000A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:49:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fgcOeZMQ;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778554150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S2BCFtdY8BstYcwPGt1OMwetfWeUvCIyaDq4u2dkV4Y=;
	b=QOAvp2Q68BTHzqrJIoGh+a5kjLOcbyOFP8u7iOw3GJSoRl45aD5GLSwn7pml/pr0kP0k4c
	zij4n8NqlvdLXm8+MZCycgIs2Ds9WNWExMAj29Z71IbGmbP1reBVjcJr7/fTWi4had2Bq3
	v/mwCBw50NOX0RO7oUyoTkXGiUrSClw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fgcOeZMQ;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778554150; a=rsa-sha256;
	cv=none;
	b=B5Nv9y3+CF7ItH7c53lFUgbzFU1Nq48pK35jFkq6R2ddmB3xmNfSv5t6BFU5/96WCA3i5y
	4dDeqJQVQnaIxulZo0F95iDFC4fUTIDiYD5j05CSVUOwgAlTcxdQh3wycgciP4hVliPtCt
	HA5JC7gEkkm6dnpTkQd/ot2HXjBempA=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8ec37d52c0dso719149985a.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 19:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778554149; x=1779158949; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S2BCFtdY8BstYcwPGt1OMwetfWeUvCIyaDq4u2dkV4Y=;
        b=fgcOeZMQzvIMvJpmtMa5pHYtYCXhM2nUr8Lrfj21pkVOLOWgvW/fROwf4PbdjSUfWO
         o6rGcYJE60o1foCORnbevSAWG1heFUGAeKRUxLmTCz8mDEtq+09kX1xKyQNyppDpM7e9
         Mt6t6ceV/EuCq6yhPw7UfKZkCCdoVsXE0BRxu3uLaIcxrpJQZTvZwRke7S/zj/fSKv3H
         l7u5wautmwdEjDmyWUCPb34SvgMWxLJN7+lDnZRh+AJH07t7J5jxSgiwZs+tmVHUERd9
         fy09baUpidcEaD96fPN0rvzGQV1nO9DaowkeNxC0z59327MViIthQ0xPdaOAmJ6bZiny
         ECjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778554149; x=1779158949;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S2BCFtdY8BstYcwPGt1OMwetfWeUvCIyaDq4u2dkV4Y=;
        b=oBCNzzu4W/HTPpNOsuksnl4lSv3fUbDQIuSGhGUGrkZSfH0lpiFA4AIY3A6vf6nw3K
         VdsTVBug5COoiqyDQ2616RP2CHj2cyKfUPBhIi9ZYN3aB1LvpwaT9y8mxXbdwPW9jDZw
         hKdSpg8EHnicairmMUnLbBoj473wtWhFGcJN7PRIkjJCtupbxpr6CvZm+XWFhbYzI62G
         XhWOebRkSVuAe8uAPV+YnKx8zKsGEP8aebn5QUjDHRoaZ+mwc/0LFAiFPaXxUC/5C5x6
         QudelHiFy7K0XLuc5yzCrx0Ph8BCKIfogWKtCDPM0Uv/gah8v+omH1K1ODR9s2JLDVeT
         uT8g==
X-Forwarded-Encrypted: i=1; AFNElJ8Uqas2XtU3twOOKjpJtDVtlGcEfAxRZaLKBrJVtjwzhm4X3maTpjFTVEtFC3VjDpv1v0HuXM8xag==@kvack.org
X-Gm-Message-State: AOJu0YyL4+wN5tjryZHJcejALl+pvq1uJLxKgd3wcYdp9m7xMA4+cBEO
	jsKY3o92h9nrXn4ao4YG8OiOwY3pmtvzXtScbBCzL9DGrUxbvHsoqjUUgUCYbEG8g0U=
X-Gm-Gg: Acq92OEBhUE9IiRsGsuTSfq2RCjUpOL0h6aMIgw6tzwTAywgeWQa5r87hg+ianjLk0G
	QDsQZzTi8TjfhNLYIefMCyxueW9hVL/nn7mnRcnBiZ/AMAy/tyYawsP7D/0dVKh663UvE0NsQ6i
	QKBw1aA0tXctWcvVaiftPERw4bx2Ba2UGmw0+VbGtX5Kg15MqNPJGgXNSYNYiTzJZZrrILAy0Q0
	vPiaj/r0ENAd2cPt+FEzH23UK4dWHneDIXVsAhhKCB7+rkX4+/2NbbkHHndeQrJQ6hO+OiHIMOz
	WIeeX/+CaozL77Z2W1RaP3fYeaY5937UxlDMu0H7gTUw9p6H7BTk7g3l3DmTp7bh7NUClK/EwsZ
	axc+1KGyLDAaJqxOI+e7ocCuFKQ3kh5wlHmahLqRq1NDqbfAak5O5IO3ogQoJQYgpmi90/l/hY4
	G70O14ZgDhp/Li6NzMyCa+s1QaeglX93CtMhqGSgOc9fLpBIDQjGY9tzv4An55HNoqVk21zezcJ
	KbJI6AV29oa
X-Received: by 2002:a05:620a:710c:b0:908:a758:baa7 with SMTP id af79cd13be357-90cfd34a203mr155310885a.35.1778554149388;
        Mon, 11 May 2026 19:49:09 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fc2cd04c68sm3293903085a.46.2026.05.11.19.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 19:49:08 -0700 (PDT)
Date: Mon, 11 May 2026 22:49:06 -0400
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
Message-ID: <agKVIjvNwVajYwjz@gourry-fedora-PF4VCD3F>
References: <cover.1778489843.git.mst@redhat.com>
 <fe1d24d4deafe0f5d1a9c51fcc040d9561c8592a.1778489843.git.mst@redhat.com>
 <agIFq63QZugkWcXJ@gourry-fedora-PF4VCD3F>
 <20260511174337-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511174337-mutt-send-email-mst@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5C9D1A000A
X-Stat-Signature: zx1o8hkb47t8uyxjesoq96r8mzeeydny
X-HE-Tag: 1778554150-755587
X-HE-Meta: U2FsdGVkX1/HtXroMbdynjrgePyAYO50LFnIjbIn+8/e0Tr4mk9KQ3ri4R0QjSI8Bhmh27N+BnMY6mPC7TD7t9NUPkhmUlzjcxNase/f+ngRJ0EgvZeQQniwlw4E1tQadieRT9qPeYbiHMkLzHp3OOJ77Zs2h8EVZIPDai+ITY6kJLDs//yyiyApcE1fB2Jp85VO24SdUIFnWTXTCBzBcXzH0Dh5jV5T0p5SMjBdXYNO26rdMjzAlsH93pKS854sYTb1R0ktSJ6/casxcgafQiz4vBsHHgQa+eeTIi9ag5BoBWPdY5gXFG8zCDZqU3X1R3NZXhsX3Q83/FT/QfOLIwyE1MDnTYmfmMyClSNyumB3brHgfmUVhFgxjtdUY6pYSctRcRcLNTzQCt/bqfcMgXq4jIYbJw8UtQznhlz56bL2f3mFabz8UguKjk5sEyt9Pz5NF8L3/VLQc6UR7s3v+45377EPrfcbZCEqjUREyFvlY6xjYYVhezORVrwTX9FmtgkiPHwTJ4YauMcvCwZA//0sR7ut300Hytm2gHaES2ENyhXGtSNxChtkODCOO+dkZTP5OcvY7qVOOWdqbpJ0sYH0SnB+G4WQogX/YvMOAabqlI0yHIqYBEolWegXiwyNkugSVG3vurzJ1Qkuu65QaPOj3+dsnz1AvoTDW1OwCmXrxYpYvTwzgJ4wh4esLi0Sm4yPgraYWJOyGf2GmCT3hXVJyIZ9plN9Hf7qnpBHr7q1nL7ljUY0wP/+e49Fxgsp3A+v3C0kLCzeEeJW4ekdRx0XSbbdYXdBmrl/US3FCVhb9qKSnJkGjDutJHTOBOgAmKUaBmFknXD6tKsscB/KgkPNF7DdzxrOHSNSUfMaC7okRiclzCBrirrU7JZUSmWHA4AqfUiVIY9leGw28JLYXitzpmflxRRsDZWK0C1clT0zqtYfoIhMNantUMJ96pp0uNI5yuTRJZJ195vBFfK
 T/lwkGHa
 MZG6SxmEaTDSNTCuPzSltwb8h1Hwpv8Np8334I8lffFXwYOHSMNmxddwW+ObFKIYjiFvTy4gd8YqMF//EByfvYNleFuTnfQ7X4uHMEDyO7Frbd/hkPw1lLQsItibYDUy4iZout7AKbycUJaX3wvO0wxYwi5cq6TvXo3cSfSwwn0ZRDW5jaZuvVHVAjeqOhw9ebDC5PNurcDd0zUVf+LIP4f1uLBJWHP1Da+TvdYxmc+Kpa19TXcuCh4MxG4Eh/YCOS6Uy3t5ZcLStrT409ESp3l62sleAd7f8wp7Lk4dD/u4LlRxy7Stqua+Rr8K8k+H+HgtwPCmN144bBCdw91jXqRMWVcevCCemfUsucTgDGI9N41huY8rh85WaSBgHTxLohCSVVrdi7aq7nfq2mML3qyZhqGzZAGbOToIHuEEtG640HrJK9q7NyeYAdt/NkQJXTwNI5/4yF2XM3HpzPbV5PV40ghZvKUUBdQjOP+0zVJ/0aHJQ4gcO/iZAwvo1+u/bLxxZ4rPN9ViqjNu1k1HjXrbFXoNa1c3XPKGLUNW8wveOyg6li0Ju8wX5wQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 05:47:48PM -0400, Michael S. Tsirkin wrote:
> On Mon, May 11, 2026 at 12:36:59PM -0400, Gregory Price wrote:
> > 
> > This feels like a very odd pattern:
> > 
> >   1) ask for __GFP_ZERO
> >   2) Have to check whether it was actually zeroed
> > 
> > Seems like the zeroing piece should just be sunk in if you're going to
> > ask for __GFP_ZERO anyway.  And in that case, maybe just `bool zero` as
> > an argument, rather than GFP (to avoid future overloading of flags).
> > 
> > ~Gregory
> 
> Heh. The reason is that it either allocates from buddy - using gfp flags
> or from the pool, in which case it zeroes.
> 
> We could even avoid the bool - just test __GFP_ZERO inside
> alloc_hugetlb_folio. Would that be better?
> 

Hard to know until we see the full shape of things, but it seems
reasonable if we can eliminate one or both new arguments that this would
be a good thing and the logic should just be sunk into hugetlb.

~Gregory


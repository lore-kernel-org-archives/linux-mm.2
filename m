Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67AF3CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:52:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99A1A6B00A5; Mon, 11 May 2026 12:52:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94A606B00AA; Mon, 11 May 2026 12:52:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 811CB6B00BB; Mon, 11 May 2026 12:52:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B8D06B00A5
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:52:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0F795401E5
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:52:16 +0000 (UTC)
X-FDA: 84755731872.01.0115D37
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2DC36A0010
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:52:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uA0oCh5r;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778518334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O2xFv/znNeupkUwLf2eAcAA4yCdnf8t4om4s5YlKB70=;
	b=BszQsKeQge9SPwCBrX6DhrTAbyBzFCNg+DxpSdJTHKYuUilYEKwBTxnxanWUbWViH5bWau
	mDepXm0lfGivK3i7sHQmFa3siFJFpxVWaNEccK/7liii9345ZeS3zbzda3g+xpwyUlIbuP
	kqfvQMQqbc7jk5vcMZ9KBKcN/syLAZk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uA0oCh5r;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778518334; a=rsa-sha256;
	cv=none;
	b=2bTCPnnRsthz+4uCgvTDZ9aJCaI7Cv7swkcIUs6CxftGZvcJmWFUkr4JBYgZjYSt7ILcDX
	9lMIXLulG4i356B5ba4MppWHJoCnnjbSI3YWJ5cUcaf+0YZiR7tXj/noEgVVO4+fDfZ4xN
	5idbdmurP+vF80EosIGfyhKwcOpCzu4=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5148cbdea08so25667771cf.2
        for <linux-mm@kvack.org>; Mon, 11 May 2026 09:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778518333; x=1779123133; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O2xFv/znNeupkUwLf2eAcAA4yCdnf8t4om4s5YlKB70=;
        b=uA0oCh5rJPr9WXxhi4Bjs0HurceiMjfxdEP8DW1YjPnfSBKLUyC4hE8A3onobv6kRw
         kKn8ZX0PvuEmYgGsTFJdLmtFI6uOvWfG3hsMImsPLgyGfAuakM6mJ+KHyz/I2Lmrk0FC
         IuGRLwFEKMpbjnrYB8GoTlTf2wJMfwCMCykZO6OYixx3wpPZ9kQW901uyzLy9X4GFP3w
         EFYTThTcXphO4JYAOYOYQlEf+nW9cKIzXsN1yHj4mHv6KHYclhMfp4Ce9CB6Hjj32okd
         +mBGKQ1XN6NAc5H0wmdyYnLfcn38D22xWYOwmMGl+0m0LQ/99tHyVCmZf2jQePQp1Yu7
         14OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778518333; x=1779123133;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O2xFv/znNeupkUwLf2eAcAA4yCdnf8t4om4s5YlKB70=;
        b=Ju5F31wx3PNrUFgVcsQinx7BPpuYUTVprl8il+Ft37oLFQjeYcTWlEwlw2qNt1HxJR
         GYCU0mxyYV9AcBe/c6RR55/SPptCRuu7cbmLCz/4EzZEsyDbEflmGyjGIro5F2SgQ8n5
         EqOIEB8Yxebv13XLDGjo3/NUCxzzybxEm4lFV39qcJNGMGgnC5uOeGFGpZKHHtlG0Wd6
         8z+c2TI6eboB2cy2uZMzY2nqc5t9cJl2KmLHozuu6KGBttml9uhGfUYhxsCepYNd/pza
         6lLJIpmTRKugMqv7HfIkr8JcBQ0wNKrzXzpBSX4zFXfr59893mIhPFkxMHef7TvC+2kq
         lPGg==
X-Forwarded-Encrypted: i=1; AFNElJ87wJ3eERYf1MJZhWGCecQ3CnRl3v8Be/tFXSlv5iKlq0jI700NCJO4VnbwRwenZJRAmY02juTitQ==@kvack.org
X-Gm-Message-State: AOJu0YzgbqK1ParfwI3KkQQxAkZMW/6XC8ipnTDNaH+VD3CS6L49SCNU
	BsJ+rv131HkBGCbcS/YoofkqAUviCE4d33/lKcGPn9A0awNvwlzLU5DttBqWw41M7PpG+aDxt3/
	u+hmP
X-Gm-Gg: Acq92OE+geAPkonl7iFaxt70GkOTvN2fDLkRtdHyy/GNTNhXUB071qRSssPXu4qllHt
	x1Vmon4zJ0ORxh0eemhUmyPHqeBlkFu7502ze+rFBdufWWyvoFCHncJZRwkVxCKF54C5sHIkBqP
	ACrpbtZXMmledmeuoVD2ue6frEke8DKdhUduUSMxRaa04mT4UHzxow/1+CbIxagDFLDtNy83+us
	aJHw2XyPeSSHEmW6WLjGRUuGFeCXCOk7SDEfv/wt3ly2g4M/4MfGYbjY9aYRFm44qTleraRvp/K
	FEUVknU1gla4p9+0/DgsfIM2rjwr9D1oOxuIzBH1ViMnBuJCRo8E3K3AeXjtAVI7ofcwoEekWeZ
	gExapQKgQ7dBGSTDn2DEXCvB8tWExZMLUifeNuXyLXK0YMFF9EDN5Dt+ZNWz2oO6hcCrDtL9jyh
	flfBaYHeIJgyq7IdDidVm+j8MzulGeRfWwTbRM6K2f2FI6PnpHNRpxBxWiJmiks5NnB34qg3yFc
	h+Dt63Mwn2G
X-Received: by 2002:ac8:5704:0:b0:510:141d:9d06 with SMTP id d75a77b69052e-514a0a2a364mr162992381cf.10.1778518333136;
        Mon, 11 May 2026 09:52:13 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5148e7bf7e4sm94051171cf.17.2026.05.11.09.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 09:52:12 -0700 (PDT)
Date: Mon, 11 May 2026 12:52:10 -0400
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
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>
Subject: Re: [PATCH resend v6 03/30] mm: thread user_addr through page
 allocator for cache-friendly zeroing
Message-ID: <agIJOkLhTOsvJs1-@gourry-fedora-PF4VCD3F>
References: <cover.1778489843.git.mst@redhat.com>
 <9b53972f4854c1064b92cefc464f51949afeb83f.1778489843.git.mst@redhat.com>
 <agH3wceKcPNmixCj@gourry-fedora-PF4VCD3F>
 <20260511114853-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511114853-mutt-send-email-mst@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DC36A0010
X-Rspamd-Server: rspam06
X-Stat-Signature: jd8ff5qowseamdeixb5kqsowszpbqtkg
X-HE-Tag: 1778518334-811557
X-HE-Meta: U2FsdGVkX1/rzhqRpuCTSVgwbb9bQhD15BUUxXYlvJ35fN4DI4yq61F9hkgEF0/3WeAoapEpgAv50slKin55swRLqcRbJiHUirlDB1Tve06/PDdu8107UAdYDJ2d36vE/0DdcOoRhyd1PuskqdXAWXTlYvq73/JXmzIayOlxzWQUnRnufM5EB8nBbpzsmh+nYAVmGeFKgapmFIpgt/UbKkew5KucKa4tW+Ybz/S8Fqgr1KPEo/DjZhqGbHKPASW2AuBwsAY+bTageVa/TATyyEkhSmvdpl7n+JFITXnVfIewREaQ/pW4Z/aIP18qMeii/v8UxqNldWukXYSRiBDEs2xb2MaWcnIAyg8Fgbogh/1ZsbjLuNkFtFJURj9WZ4leH/OTZ9HxaFoJ3AMSrmZ+JyF0rrHd9wvX5hRgemO8W1NWyf9aTK2tfvj0Pl7KOqAx8YwywWr3R7S2gzl0hRM9meXUXv9gHhH218sEU3c6Yu6P1ck7KueVpIH8JvBZ+xIyXWfVNjk7/nd+PM5HWWUfFyky1lLZOxmKhKoNFrV7L7bUxmBn17yJsGpytsm4tcAsLLapo05KoIoF7iQyFT4dIZu353TGJZIqYPeVJMewUFLlKqzWXylZd0QKQiYauTzJ5njdjLvIEE/RBXi/DKh0BB1LrUI0ogrBJsCKDO8syC58GXvaGVOltHwfsYaY9xlXkzR0PwPDVprco9hTdYmRBdWd6f52BbUdTs/7cUkmPRpXm8/e1trMdGg6zTzJWJNT01Bij3BlNiepywCuL2tKFwleJ/eltQwI2xp5V6I5l1V0cABoHU15XVMU2toIjVoNFPV7u16pkusTWYwzyJi71ZFm5czRF/cKHyJKLBk9zgsALxIIx+NIKsiqtZxMyOW5hrzeKjBY7oBnsssfglRcl8qIte1N8NMLwb2Bkmg+Cp6aRHtL8QRdTzPwQyNAzenVV3pyIIZcomcuAIB5M/p
 /KwGyKsu
 7EJ5GSHYvsvtgRcG/WUEeZQqCgDnufMkVDSg88wkOQqqhMRnjt+/wgG11DfmC6DvBwA23tJJk7khg1RQoIqtZbdyADWdIjfpM0WM5vcRkBKdISj4K76Gt/HP87kE5z5jZbjVQ/Lp/3/T10cD4wtzmWyxKr468Pj6B6YulnbLgGRlWE9kUCQ0I6WqWGwYOPSqmgAeSVGcsfilrECfV4825t9BaPl0ti8dBV/uUEb30p1Z3IDkh+HYzj5aGHf2bbyQ76neo1w8FCaWJRyKpOtBqpzg4t/fXpJLhnj9z4LLNc/mkIniDCDZK+2EmQiiI4xd17JuQZ4xQ8mgNZjQNQa1BLnAlZ6FNVMl3irfQCJOzNiEG/si5kabDyc/fEJPk1S7zKWUIpu1RFgDf0LNiAeei5hLBSpst5SvGB2y25FVUlodjgi7BNv3MiSnfR89xvlUWVdJw6vK2uoHs0qt7hkq2Qc1cJvYAZNi/HNKt2el/7f/harws67dwbVyJHARCDysACZNQRbslcwZtyulZfFAD0N1gdLMlWtdRojsc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 11:55:40AM -0400, Michael S. Tsirkin wrote:
> On Mon, May 11, 2026 at 11:37:37AM -0400, Gregory Price wrote:
> > On Mon, May 11, 2026 at 05:01:55AM -0400, Michael S. Tsirkin wrote:
> > 
> > > +/*
> > > + * Sentinel for user_addr: indicates a non-user allocation.
> > > + * Cannot use 0 because address 0 is a valid userspace mapping.
> > > + */
> > > +#define USER_ADDR_NONE	((unsigned long)-1)
> > 
> > Ehm, hm.  Does -1 hold as a non-user address across all architectures?
> > 
> > What about in linear addressing / no VM mode?
> 
> this is used on a fault. I don't think there are any faults then?
> But maybe FAULT_ADDR_NONE would be clearer.
>

Meh, naming here is less relevant than the sentinel correctness.

My only concern is really whether -1 could end up being a valid address
in some horrid future timeline and this all going belly up.

Is why I asked about whether this is correct on all architectures.

> > So the trade off is:
> >    a) churn the current interface for everyone
> >    b) add a user_ variant and know people will just get it wrong
> 
> I was also explicitly asked not to proliferate too many new APIs.
>

Yeah simply spelling it out, not asking for a change.  Probably no
better way to go about it.

~Gregory


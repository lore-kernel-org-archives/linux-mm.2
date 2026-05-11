Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1520ECD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 22:02:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 702CE6B00B0; Mon, 11 May 2026 18:02:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B37F6B00B3; Mon, 11 May 2026 18:02:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C9AC6B00B4; Mon, 11 May 2026 18:02:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F4A46B00B0
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:02:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EBCE21C082B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 22:02:18 +0000 (UTC)
X-FDA: 84756513156.16.49A5980
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id C396E2000A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 22:02:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dbEGeKC6;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778536936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ik2ijbC6NTpwxKezKUy+hGJC+FJRCeUEYZIMUAfimrQ=;
	b=exrvvgqbMV6uASTEqC0Qd3GbnKyUuu/AlXgytccYrX/nT8WkRdmFN9JdrdQVvVfF5EOyE6
	ZnrYVPm6iNJs+r9Teg1qMyauNEJgrCaam44g+r/Jnd1cRNsC84ootMqg4aAY0B/P5Pm78C
	dLOqRkzbc2AOEFwzXqw1r0l7r21yB5g=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dbEGeKC6;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778536936; a=rsa-sha256;
	cv=none;
	b=AvMLLzugYbFrOhJ/B2Smi0gIKpypVqonGGRRl3TBBev++sJlOQgzS+CwGQUSPFO8ZfzPVs
	gs3+SOWU3DJlTNAnvHaS/WYeMM3VanCYz02vsel5gbaqt50nkz/TcvoQEhnJ8wHxslj0P4
	mKwrCe6aG4mE9AZtqDUT62YgD210K8w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778536936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ik2ijbC6NTpwxKezKUy+hGJC+FJRCeUEYZIMUAfimrQ=;
	b=dbEGeKC605yBsNhYWkn1Z7cjM2L6/Vlh4jOIPYYT7oDLyXFRho5Fi0j2H+eaVkhxHgu7uK
	c7Ze9KyAzjpBPGyDVAwXKlbfyAH2ZHyz5Zhpzmmoc6RQMVL+dABMGU0wmNRYTbVR17nFPN
	cZgE3UbAllFzeArI3rgFKW7miqEanPc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-92-ZWoOgmOzOPG7FY6hX4VNXA-1; Mon, 11 May 2026 18:02:14 -0400
X-MC-Unique: ZWoOgmOzOPG7FY6hX4VNXA-1
X-Mimecast-MFC-AGG-ID: ZWoOgmOzOPG7FY6hX4VNXA_1778536934
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48d121738feso41751775e9.2
        for <linux-mm@kvack.org>; Mon, 11 May 2026 15:02:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778536934; x=1779141734;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ik2ijbC6NTpwxKezKUy+hGJC+FJRCeUEYZIMUAfimrQ=;
        b=EPfNdjE1hdhHO666PaxFUelyFWK/KGGdDjRSkBUvpuk74XVMhzf6np9rymgb7vyKlW
         YGmdeOM1FoM/7aS75FjhyHT0pSovHLhkkfWunbMV07bsW/xH1Uj7WdVaSK+sC9owQ3CU
         RIMn1Yu36krayws+5P8NZ4DJRq+n4sKv4AP8gJ0etuhqRKZE091BaVgT1ypraTSAYHqL
         TRms0la90qVxcdu6FlizN8Rc8O3dpG/NBajylVcBjdPlzMgVcEPcYTuW7RH/RD4YYQeb
         yej7CV+REsvH/PoHTcjnJgOhwbWLvuGUoxRn74DyN6KrzUiRaUHyhM2pYlzyaNa+OLIr
         t10A==
X-Forwarded-Encrypted: i=1; AFNElJ90n+9Ktv1Oea270pb9nhTdfchnQjwHSVPH758fLYFucnNvbaUml+7RfoFPXxsfAYKFnXj89CB2dA==@kvack.org
X-Gm-Message-State: AOJu0Ywtej4mWTxYopMFL7Xc+QZ1FxtEumFcM/C1GiI5uEXWJFBKjUzK
	wkh0BCCSp53fcswbpTYYy3KiyDdhRgZOYFCf4zBaBj/Iw6yhw5zTudgOQhvL5Oh/z0N01Fr99rv
	2KhI+bVavUVculyaVmInWRnIgWX+9oOe+3GaY3Q0ebV3b0WbcDSJs
X-Gm-Gg: Acq92OFy68Htbm5R5j6yIF5mVVtGQmtoY22MaPrn5LqgI3qX9jvaVnoOL6pwmeldA/y
	g8/5j9r+sIxC78KtKH6EiniAeDzWy6kXFfXlvClVM7A6MusthPoQ7Lnsp3oLudjr9An+6J6L5v7
	Z4YKK3BLwv0TpFOr7AgoX0kO1AD1oNyXJZV6D42weN00Uvj6NMr+rhxWxl1XWwuXXoNVIwAcSdk
	8l047RwjPKFV82NWcY2INdtX5a3Dflz/llMpd0un4zrpgAbBNtqZ0hdw3eCkmtsu34SooInmajL
	g6hFLhrNchJKtJrsR0NwaIQE7nLPG0r3kjzv/jscEO8zcueIfq0RNLiCA9h5yY/iTOkL93H1ycc
	aWKDHdTtIzfr5oozstm9/pmPOk9NxLkhhU+ldlXNP
X-Received: by 2002:a05:600c:4c17:b0:48e:8974:c377 with SMTP id 5b1f17b1804b1-48e8974c4c5mr28774115e9.29.1778536933615;
        Mon, 11 May 2026 15:02:13 -0700 (PDT)
X-Received: by 2002:a05:600c:4c17:b0:48e:8974:c377 with SMTP id 5b1f17b1804b1-48e8974c4c5mr28773545e9.29.1778536933039;
        Mon, 11 May 2026 15:02:13 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45491e94c0fsm29095912f8f.32.2026.05.11.15.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 15:02:12 -0700 (PDT)
Date: Mon, 11 May 2026 18:02:06 -0400
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
	"Liam R. Howlett" <liam@infradead.org>
Subject: Re: [PATCH resend v6 10/30] mm: alloc_swap_folio: pass raw fault
 address to vma_alloc_folio
Message-ID: <20260511180017-mutt-send-email-mst@kernel.org>
References: <cover.1778489843.git.mst@redhat.com>
 <369a08b86f51572b2715a9ec577de27ea98000d3.1778489843.git.mst@redhat.com>
 <agH-PrpY269pyuJQ@gourry-fedora-PF4VCD3F>
 <20260511174032-mutt-send-email-mst@kernel.org>
 <agJPpxyu4gKqq8rj@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <agJPpxyu4gKqq8rj@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MnwWVdrWsx27sjHQjtkz5MDSsAUTqMPVO-qZsSGPpYc_1778536934
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C396E2000A
X-Rspam-User: 
X-Stat-Signature: sxuitobotc11mae6df5texpz8stff3j8
X-HE-Tag: 1778536936-471284
X-HE-Meta: U2FsdGVkX1/Zssr+Hhy5AfsqP5g2K5uJwQ5PVCC1FYUlczMyg86hT2JXOTTKWbQfoVCgde9Y1k+YkcekzoyfnnRIpaMu/AYIV08y88g5j9Ppqy0I1gfbtyv9TPs6rDbm86XiVlzKjDHywLsy2HhOIOm9TII24CwwF4my9WHSVU6bM5UI1RRUPD1/ZaFm4dgjXedunQoF8Vs6aT2owfEQlyc5/6Tngc7GxRrAWFsFDVpz1DHINB9zGst0+mf5rR+t2+DgWgDJ+qoYczvSmKRhXnynH8NMEgsGyaNLNfa82jNjRI7TS6SjhR5HFLf8m1Zkd8FOLBWawVT5lhoO/7RKRqw3eUJhEyAK/IF/2plAbjR/WerHP8aPsstKSBjCj0cHZVxZY30HYISJrNeUBviBh2VpY1UeNFD0UZVyxgmW1mrDlFE728PJN+asA2kahFcRKj0lvQoPzpbh2lYxjweYNBx7L/bgEM24VFqVvlBudgp47I65DCWMJbC3gEY69R5PkrwuoOoOFK7s2PWezTc7OIoBBJ0exZPWkRvZzaZrqD0bypoTP6vQKPbo5j3C4HxrEO2XfyT2N9QBh0ZrMyMIOXG7xUFD9OhGke9Fa7yO7JiXolylVn6DrhUYw9UhNEg8OuOIewdYkxRZoJUhfVOBOwP5A3HWj2jubchAPaSV6ZNA5vPgmSbMib/bAEaZejyNZ5dsOEXmA42IeOa3bRmQp9bd+o2cnJQl1qPy2UeRRtoebtYjb9fbha2M0MAiTqmxqkmUzgwq9VflV+fsLthUiuYwlh+EeVIGqC01r3NPtmyAYkXqTmqX/rGjOdo8+fR/+OmQcFfMIqMrYSDkqiH4DmEFMUyKqxswPA5gzAGkAIMtLl4fiqhXGFdrhCAUtW3dRrmYH5WHmrxigyI2YRe/35xrNlxEVqF6zmS1kMvIIkAIT36GYvYRC9FxwnOc5iUeKy2meg/wSnRfJ86XygM
 kStGBEzX
 Lt1tRwLzPaWfLAFjuZFADv2X3hGrcw3Hf2HF1913HeFn+4PwVGz3k0pkjjiuO4HOLDQxiXm1iaCkCRlfq0lOq6AGWBdxpqjbhCknyfL9uBPaO2y4ZTsDbpSjXoMxKfjIhWO9DikKztUkl6QC8ePU7fcCIPR2s6e05Av31O2HfivzVMORr45V+bxa9DYuXisJ5pR4GHZYxotdacNmO4BtUWGxG7Sc8yXGMsQ9RStbV/1QYuEqmr7LO6tSANBrhL9n6d5DxWEZ1HhNEXKu0784HXaEWKhWmBGc/ZI2TSzLFiAoIcq6AYK07SGhpv4zA5jcl5XJMMEDCN0YoqYaA56eG2+pJ2ZzF2QyByrVyRH5lBvtZFBnufO11Zw+lGpmalveCKIYAmQO2kwJwLWkj0jjJDTsfjTpfBsIBOf1J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 05:52:39PM -0400, Gregory Price wrote:
> On Mon, May 11, 2026 at 05:41:16PM -0400, Michael S. Tsirkin wrote:
> > On Mon, May 11, 2026 at 12:05:18PM -0400, Gregory Price wrote:
> > > On Mon, May 11, 2026 at 05:02:39AM -0400, Michael S. Tsirkin wrote:
> > > > Same change as the previous patch but for alloc_swap_folio:
> > > > pass vmf->address directly instead of ALIGN_DOWN(vmf->address, ...).
> > > > 
> > > 
> > > Starting to seem like this should all just get squashed into once patch.
> > > 
> > > ~Gregory
> > 
> > I mean I was told the patches are too big and too hard to review.
> > It's just same, independent changes made in several places.
> > Does it matter if they are squashed or not?
> >
> 
> Mostly i think the ordering of the patches thrashes from one set
> (alignment) to another set (USER_ADDR_NONE).  If all of one set was
> pulled ahead of the other then it would be easier to follow.
> 
> This particular set seemed trivial enough to just be one patch, but i
> don't think it matters all that much.
> 
> ~Gregory

I can reorder and put alignment before threading, sure, that's trivial:
these patches are all independent and cause no conflicts when
reordering.

So far the main work will be the hugetlb thing - it really parallels
what I did with post_alloc_hook, to think of it.
Will take me a couple of days, I'm behind on other tasks.


-- 
MST



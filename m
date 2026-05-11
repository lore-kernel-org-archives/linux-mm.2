Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 453C9CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 15:15:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B59F6B009D; Mon, 11 May 2026 11:15:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38C786B00CB; Mon, 11 May 2026 11:15:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A2996B00CF; Mon, 11 May 2026 11:15:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1B9036B009D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:15:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C282F1A017F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:15:42 +0000 (UTC)
X-FDA: 84755488524.15.5688464
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 80342C0004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:15:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VbxkjBXo;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778512540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pw7Ok457RiSERsUb2kiTq/Cv9uGPdowjG2q0yMpggx4=;
	b=AK7kGgWjaL/jde8IeaRI99isrpKuYqmgwcaH0DKjBXz1dT3/wEnIPayE7oq0clfDPU7Gwx
	ZWgu47NeHSPRCSIKHJf9OPztEqrrYwwqI5rI4tJ8tn/VesUYrPad214A7bAtP2L+3jYRHe
	/CNWiTgrAu69oNxN4wV8aB2iVn3i5x8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VbxkjBXo;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778512540; a=rsa-sha256;
	cv=none;
	b=uX3kuYLsGdjYtuy92eLlni6hhyjE9dC56Mo6F7lHPMavdIjROE6ggPIOja/y1QI2U/9Hbp
	aMmE/bO+VO2GbdIapBDv6xgN8tZcwp4wm3orObizXLPfac+oltW9YAJ0xtTZt/6ZSQfB12
	ICRS284t4iytv3tBLGAxjCw4pkYSCn0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778512539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pw7Ok457RiSERsUb2kiTq/Cv9uGPdowjG2q0yMpggx4=;
	b=VbxkjBXoiIaZNMUxFV6qdJ3bqngnFtOE5XM8YCqFBA6S1mjeO2w5IyZtraDa+XnR7wuHUk
	vWrSCL27bTJelZF0T5DpxhfgsaeOCPjmvJLlLrNteLmYS4x25+mJaBF+5EX4r4ZDzgZpbx
	8iC9ASh5aBeax7NmAL80H9NTU6eYFB4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-JwmIbh09O9ekdcqCfwIEVA-1; Mon, 11 May 2026 11:15:37 -0400
X-MC-Unique: JwmIbh09O9ekdcqCfwIEVA-1
X-Mimecast-MFC-AGG-ID: JwmIbh09O9ekdcqCfwIEVA_1778512533
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6805f45c06dso773946a12.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 08:15:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778512532; x=1779117332;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pw7Ok457RiSERsUb2kiTq/Cv9uGPdowjG2q0yMpggx4=;
        b=Bcd6txzmWXeshz4RiA0HP8dLkIlzvhTFQVMnvjPyLHIucvJDuTfVFtpC7RKq03+edy
         jCODFYK9xbr8J2x8+t750EdiE4k3Wzkjc9hgN4sCsDBKsN/Gitt0TY7ucHXTzbLHeiba
         5Oc/WzSz5gIm6YDTmz+xTRrgiivQDUICz0Iqa0w8xwQzhyvfN9k/FlRM6jj6X1j4/1oj
         nH79gqXVjEyj4T5ZGf8M8b5s6nDq3fqatlfZeJfFC+rsiaLd7dxV2qWJzHCve4LXFthv
         kEYRuQ5lkyppbOCD+V54e4KOHRiz1Kr3sZDvpA2Ip6TigklP57IqllDpLlgeKaGIEGHk
         h94g==
X-Forwarded-Encrypted: i=1; AFNElJ+YoQW+u6pe5E0ItOWCmpRwYvTHhuVoCVkDEc9kbj+F58VgBY3a66TkxXXtfNzsc8i4b5M3i7O3jQ==@kvack.org
X-Gm-Message-State: AOJu0YyoFtNlPusCITzFJRWK2w2nwKDRcKU2R6B/BgQoU2Duj+RXGZLt
	HVU/iYGABMNYZmqzg7CRSaCdfq84yyTmvqFZaUhRiqJ4KRCLIb0MIhMeaLtOsOfqfThgZtRp7ji
	1mtalfiiMgEQxnsGLjllbAoxcHPcIcYGbfKGhCQMZgwY+GiXA/uup
X-Gm-Gg: Acq92OEpqJlYagKzV0b43SEcYxoeVfkLX3Di5u8bk2hM+LqI2YAgA/BXe4Kh2sgCcnq
	ta781bzQ8P4Gx0lDdMkLajEnK3iCkXzo/7FJ/YdXVsjRVssneevBRyCp04kMIIPCgthmsbFhvRx
	53X+J7iQWTSmSVwfpCbogyGQImUsWYLKu0EU42snxsTf+qem24NFV4r4C2LofrTMQ0Ns+FR2fTO
	/W2280T5bJeCXYUcj63LTLiBcjMDFFr3ePbBNyRTTh1ImH3YIjsX6zAIYdmq/UYlbdsCSo4EeF4
	YgwrxuGF5/YJ/A0AC9WOt82B7xOa4ArJpta7ESUvttF4V+f08mI6o5Inbq8qd3aGLhLgLrnWf7v
	7fnwOb9Pas0EHeZ+Yr504DDicxP6IZY2jFpSwRakk
X-Received: by 2002:a05:6402:3509:b0:674:37b7:227c with SMTP id 4fb4d7f45d1cf-67d63aa055amr12708525a12.2.1778512532312;
        Mon, 11 May 2026 08:15:32 -0700 (PDT)
X-Received: by 2002:a05:6402:3509:b0:674:37b7:227c with SMTP id 4fb4d7f45d1cf-67d63aa055amr12708486a12.2.1778512531582;
        Mon, 11 May 2026 08:15:31 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-67ef0b6baaesm3990113a12.12.2026.05.11.08.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 08:15:30 -0700 (PDT)
Date: Mon, 11 May 2026 11:15:24 -0400
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
Subject: Re: [PATCH resend v6 02/30] mm: mempolicy: fix interleave index for
 unaligned VMA start
Message-ID: <20260511111417-mutt-send-email-mst@kernel.org>
References: <cover.1778489843.git.mst@redhat.com>
 <41bd50fdaae943e1a79215ea4000322e74a823be.1778489843.git.mst@redhat.com>
 <agHu4iaL-3By0YuC@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <agHu4iaL-3By0YuC@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: X50VV6zptOyKCHOqFS6vyxfTgD4UeD9fuHpaf06kXqI_1778512533
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 80342C0004
X-Rspam-User: 
X-Stat-Signature: tkjky4nfkj6iwooj3xj7o8o3nbbd8zt9
X-HE-Tag: 1778512540-636416
X-HE-Meta: U2FsdGVkX18QdLrUfP9tIXy78734mq4NIhLG2rqFS4+l+sQ4YOCkhYNJGyc79O0GL1J3we9XFttfmS6520Njjbzx2Bwb8O38SjyEdIZD2UB5vzhLL1REI6t4DQ2o/W8n9eVPCEyW1zVCuMRoCtN5kVw8JDNpRoKTZUlUCAYk3n5IvSnqXeYPzIKywL0XUdpyDiGzJflARYIWOmV5pr+CbkYZYOdy1q33s8ncqYsmkckqDF3NDc1MpBypmpwoztGkJjL9rxgUgXV5Y03i4MmduFtxMPB+htEHL4m4GM3+1wd+nSyuvda/Zks2G07gopbuVp2NbViCra4m9KeIpwK+crG4R2OONhg0/0MJ4kZa6qDwGruldWmyclOocojNoFl8CIECG2NTJbzi6KsZYkTA/y/EDoPHY+eKKJryWXqcETAkCmDTpgJ3GY1JHK3n7xpfjT/a1jEzzw8BEBF58fGjWWuVEVIPQ3XdgoMsZi5v1O5w0jyAZdmXPfYKw4S3CfmJXfT3B/Rr2VJ+On/0xbipeFSRm8F7ooAVlvqg0W0x0aJ28DUZIXyd77sIDBEF5K6fdhKDXVP7MEQ54keVf/Bg6ZpgIyuU6oLlw+XtX27Yc9YSkewDaPAsFBOaM2ONWh0FClql68fJjHWE+mVCqarIDYyqGgdC5VcU6FzM7OvgrzY+OOdaY3gusZXK0k08TWrNYUK9rb+rR0LAcJUrn8DomdcayjSBjyn04+NPOYDRisWJJe5TS+fSMFJdVw0qDNCxGuiqiaHMG20myjjfjcCOHaRrtFHlTUMnpTjFUmeUSEKspDpPYNRW5YhBvzMuVxhIk8NNevOb2fwdest+VID+5gHdhhQkNiryzgNdd0FwuBpDCR2/ri0wV+6LIlZ+RkYmPVPmnfY5/BBYixbOQLpyRFE0R+Ij9m58e7NwSFaA2O+yKIp7MwPRQCeMUgLmOn0KKD1yB5b8Fv7UE6/Ospn
 wPPH8FPI
 WPI4gObg2Zl/CkYlYblJf9hrGcms2+0xlhunGZb5rb87GYAzP5eDVAg16dVVby1wIytxp51SjfI/UgdStmtosB41QGvwh/LYGIANaNbz6gIbUly2clKShFMKHXr32EXfFEbMMmxvspGy/MN2roucaf/a/8/5PJhtwhTdfEZCz1RKVjXlmMo6n2GxB/4GgIUDEa1JsZ+8/dyj3rJcWwMo/HWk+BtU5hpcsMoJNY8T0qjTi/1+HnTLHuj/RQaIXpd05UA+ZgnMIM6qCTheO0oxj9LI17BAuFOP67e4ec0ZlDO4d8ZPsCtPbGLHgdvROFC+ifzkJ0vsG2km3EUJvHmkk5PaLj9MzGd7/7GDmUi4E7EYfkbv0pPFJx0VASrMvnTzi3GnpdUg363t56UQd1jtTO/0Mx1JiRod8PiQZLJlO+LcFVfaAwfJyRcBKm5QftmpelnBKch6ktLdnPDuNjpWNFEYGMP4Olguq4isr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 10:59:46AM -0400, Gregory Price wrote:
> On Mon, May 11, 2026 at 05:01:49AM -0400, Michael S. Tsirkin wrote:
> > The NUMA interleave index formula (addr - vm_start) >> shift
> > gives wrong results when vm_start is not aligned to the folio
> > size: the subtraction before the shift allows low bits to
> > affect the result via borrows.
> > 
> > Use (addr >> shift) - (vm_start >> shift) instead, which
> > independently aligns both values before computing the
> > difference.
> > 
> > No functional change for current callers: the fix only affects
> > NUMA interleave and weighted-interleave policies. Current
> > large-order callers either pre-align the address
> > (vma_alloc_anon_folio_pmd) or do not use NUMA interleave
> > (drm_pagemap). All other callers use order 0 where the old
> > and new formulas are equivalent. However subsequent patches
> > in this series add large-order callers that pass unaligned
> > fault addresses, making this fix necessary.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Reviewed-by: Gregory Price <gourry@gourry.net>
> 
> Should this just be pulled out ahead as a fix (assuming this
> set takes more time to bake)?  I get it's not causing issues today,
> but the interface is otherwise technicaly broken either way.


Sure Andrew can pick it up if he wants. I found a bunch of unrelated other
"technically broken stuff" that I deferred fixing. Will get to it
once this is done.

> > ---
> >  mm/mempolicy.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index 6832cc68120f..39e556e3d263 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -2049,7 +2049,8 @@ struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
> >  	if (pol->mode == MPOL_INTERLEAVE ||
> >  	    pol->mode == MPOL_WEIGHTED_INTERLEAVE) {
> >  		*ilx += vma->vm_pgoff >> order;
> > -		*ilx += (addr - vma->vm_start) >> (PAGE_SHIFT + order);
> > +		*ilx += (addr >> (PAGE_SHIFT + order)) -
> > +			(vma->vm_start >> (PAGE_SHIFT + order));
> 
> There's enough (PAGE_SHIFT + ...) spread around the kernel, i wonder if
> it's worth a define or a function (not in scope, just pondering).
> 
> ~Gregory



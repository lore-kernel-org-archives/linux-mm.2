Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51D4ECD37AC
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 17:51:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 957556B0088; Thu, 14 May 2026 13:51:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92E906B008A; Thu, 14 May 2026 13:51:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8445E6B008C; Thu, 14 May 2026 13:51:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 764846B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 13:51:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 045A4120724
	for <linux-mm@kvack.org>; Thu, 14 May 2026 17:51:18 +0000 (UTC)
X-FDA: 84766767078.05.D9E38FB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id B0684C000D
	for <linux-mm@kvack.org>; Thu, 14 May 2026 17:51:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UHh79TA5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778781076; a=rsa-sha256;
	cv=none;
	b=jUQ9WVThQGrV5cQLgdNMIwZ18mSxjSwups+ySTaDEz0KmSGABvGthBIkJwBn6cScN0SPII
	+gFyD/EC27h9Ya/e/CEjk451veZsLKp+iD2z7lf4FAf7X78asr02c+wZGr0gsJvQtGSXTh
	hhg36v2isjX3ZLMBKrjK2ElCC9RhamM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UHh79TA5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778781076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tLvXfaK1++cjWp5ZEXW7FRO6EgPicPNmdS5WYRImnOM=;
	b=oSAmV7yPdV/h+yBmdaWnapyakKl3opvmTtGUeaEmV5I1ssiRRxG0O/BI2HpqDQv7Slsyql
	GGpKXmlkL4QcxQIsYdP4KyuKuoaTaN/W9jcx/4vfgKJGOdAq6kx5WEqF63wjbpDphhjbuZ
	4i4bx280S38xjEdD4rIiihDYQuqRwB0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778781076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tLvXfaK1++cjWp5ZEXW7FRO6EgPicPNmdS5WYRImnOM=;
	b=UHh79TA5crdsw0vywMe+E8Fv/Q8Tt/2OXc0pb2KH47ar8sYjreMtf4aTN8hz8GPZQ7TgCU
	ld6//rxVMdQ5PIfL5tloUwj7EIxIV42S/gBlB9vIUtW07MYvwrM7MAbAZ5/k5iSTHsbWL8
	RlNW7nPIBh/UM1gSBdZ8U5Hjcd53yF8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-msa5DDMbMxe6wVJfiqAscA-1; Thu, 14 May 2026 13:51:14 -0400
X-MC-Unique: msa5DDMbMxe6wVJfiqAscA-1
X-Mimecast-MFC-AGG-ID: msa5DDMbMxe6wVJfiqAscA_1778781073
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43fe791a398so7495045f8f.0
        for <linux-mm@kvack.org>; Thu, 14 May 2026 10:51:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778781073; x=1779385873;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tLvXfaK1++cjWp5ZEXW7FRO6EgPicPNmdS5WYRImnOM=;
        b=SAiuAH3n58G7ER2mvLeGA3j+2AJaZ8Ann+TPKyNJtNmC/299XtAQA+9ARGGiNh6ORu
         PXhVLsYlEZpjnITRBUKT4n1Jfg+y7IUybU1qkX6AA3pIooa5ZRFiP9eNUNfbT9OI6Pfy
         834R4ykLVXVZbEgvRVVdMsltdT85reOuYnl6NXu+MKi8HtSRpD7vE3ffLp7HDlAT/k/z
         Ci0AsnxU6EhM7OUyHE/IMFqT7PmlzVl/QSCcFlirkgPD/I8LgUOB3uUknkZ1kQs4O9fl
         Els9vUy1rzrrpcXl4awYGAglVmLfE6lv6gZpwAv9dTz5DgEOFXXuKCALoNle0eWGP2eh
         A6Hw==
X-Forwarded-Encrypted: i=1; AFNElJ/wBD8lSN982SRw8dKPb/5eb4q0mxJNzl230XYgyX3R+jzw0z3aQCqss3u96CmFIClD0HEkbp4h+g==@kvack.org
X-Gm-Message-State: AOJu0YzVqYrNQ7+jgxGMMGyk316VFfVm3bTSJ8IKXqKIE2PoROGf0Gpn
	Xcwk0d2ZS9ZxczCJKNtcrRASN8a5/p9yFKBwxLEcmcJPf9YltwI6NVsL4taEEH4hUyB3l3nSwve
	Ugq14SJlGTBVNPLXCZQLNkCjOu+eGKsL3bgaungQgc7zKNNATQJ5O
X-Gm-Gg: Acq92OEfAoEtdY1ouYtMhZy1zjN3pDikYKS2YGSGKs2Dog2bbwclOiDxECNqkTGC4nM
	/zSEeMrt34T8/iRsjA5kaOne6KR/F38hYvyM8qAgcF4PlSde3frjCGcrCip2CBv07OHm9qProzU
	WhcxxNh++zc15ak+C97OQi33zjT+L7BV9VqAbP5s9FJ12cQEq8COzR3sClV+Xw8jmHwX+q+WqUN
	wA7eY7B920cdtHtQp880Sca4FCEKXFTsx9/20rsMjQpENLvk8cQXC36Jbk/oVt32yeJ4obEb5G2
	gyRL3kCnWXcq3Uex4+Qj46Ef/9LRnGDKuAtpTUo7UOBB8ttM/Xf5UBEkbe5wg2wZfuM2dL7Uc6y
	DAnau8IG+O6tVZMlvHPysa9d1GmG7zCbCYhMS02n/
X-Received: by 2002:a05:6000:24c5:b0:45b:d2ff:4d4f with SMTP id ffacd0b85a97d-45e5c612fa3mr65122f8f.40.1778781072795;
        Thu, 14 May 2026 10:51:12 -0700 (PDT)
X-Received: by 2002:a05:6000:24c5:b0:45b:d2ff:4d4f with SMTP id ffacd0b85a97d-45e5c612fa3mr65053f8f.40.1778781072253;
        Thu, 14 May 2026 10:51:12 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9e768c4fsm8568047f8f.8.2026.05.14.10.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 10:51:11 -0700 (PDT)
Date: Thu, 14 May 2026 13:51:06 -0400
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
Subject: Re: [PATCH v7 02/31] mm: page_alloc: propagate PageReported flag
 across buddy splits
Message-ID: <20260514135050-mutt-send-email-mst@kernel.org>
References: <cover.1778616612.git.mst@redhat.com>
 <feab82b370b3e66b58b9cfbc1efaf26fe6061d2f.1778616612.git.mst@redhat.com>
 <agW3JyLAwVsCZ2qR@gourry-fedora-PF4VCD3F>
 <20260514104735-mutt-send-email-mst@kernel.org>
 <agXrCinY2HmJmhT6@gourry-fedora-PF4VCD3F>
 <20260514113337-mutt-send-email-mst@kernel.org>
 <agXtOeuYNin9nYN8@gourry-fedora-PF4VCD3F>
 <20260514114637-mutt-send-email-mst@kernel.org>
 <agYK9JKFInSwKSZm@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <agYK9JKFInSwKSZm@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KSNi0O9fBrQE1Xc2FXB8c8VkRcIB5Tk66QaDiZ_dqUc_1778781073
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: upk4exjfdbhzegfwfhieqs78dhxpqtp7
X-Rspam-User: 
X-Rspamd-Queue-Id: B0684C000D
X-Rspamd-Server: rspam07
X-HE-Tag: 1778781076-38836
X-HE-Meta: U2FsdGVkX1+wBhl04rK2r62EBousNEYhQT46/7OA4eQZKpxUKwryKIL08QExBGL39Bm4Vh8C4uAVXRlsnMiXEq7QsmKATi49nHLnZE8Puqmd0VqpPdTvCLgkBBTfFj9KIp4Rahul3OGSIhK1RHiADVpBf+xH5/AnLJnMchzoCs4CNXEl9URcnLC00CNhiKFAC8F2eGzrY51/Gc/qq4spFxRoLBERacoKXDuc7OK5kc8LP971UhXSOLMRID553iD3YSdyq8qYh7DowPw8YyM+pTKCwu39miX2a1yHxeu4APfIT+3dixBCwytnxJJz7oQ0b91DMHNK4lnq4V0oOqcCiNetfVJI1LPpWsGuTu2gaNCAagxIxmgJWUdtuB+M2Ra1F27mIzgNP1CEg8xP+AmByMSikjJiwzr17cA+BbIvXsngQitTwp+iEI3vZSBYQWKxNDsFCdeON1qaRmmAKmArsTimZqVNU386VV9h26nmCDFEhInKCjkD35oIQ+i7KUV13uWyZLEWaIVveU/o10IGoBLBTsrI5qJgBJCWF8m/usWqRDwoYCUnNEJ30F1c0XYWMXfX024NMcND20V1Cn3ni06aptI7K1QkjuDKdwQc/ZOb1QuXT9NO4bY8nvGKGsv+Ffd7FSXDQ5LLNGUK9UosmjBGs2U84mzN9J94cRwMQNhW611dNRtbzUjWey9XYbgS/W2i3U3nxUrzq0Q1ccBYAzMOD8ad1DmDdv4cFGe02jmnqSC++nCLtoszAnBW2sU9GkjoyQZjJk3RChgDc5ZtuqpJ+OA8mYrmCLQWyFNRH1VcFNGoFhRwW8kz5n7Yu5YD2y4mqyAxuHuboKORmBdvXS8dj26UG7Z+RATZPntCYLWkpv1Ps3ea02Fewv+L6iiMeWraGG8sgZ2FTvgd7yJmYU68bMUayuiHec6bAGSvHwbqoOyuOvEjfpEYqRs0coFQVfUT2K41UZLUdbIgVbK
 NxG/5nrz
 PA2eBMhJ1Y9Qo6tlaeB2siuYQgUFHO8Wnh+8jYiCHBl2IngtN3hReAclCaYylchlui6p4epBmoQ4D0myPj75fOQ6ZxEjryyGFvSh7wFOEC9zQpRXd025plhUFTF0urFlhLb0bsV6HJonQZavCovwrN+BVgJ5JUrhPBj3PK90Fv57w3g050iD94BPUyJ2+4H7chxQFATIu/bzbRgewuka0vazcoLkKpLAZA5ISRP1pt3+FZDd1MG++FrM+EBrAW0DNMvxyjv2QcYuCauE7RGlNmGeFmRPY79cmFSDFMc+Ih0f9Lw1BG8KxQ1ZFXSjAEo4/2Jph4oQoiI8/b9LfY4TSIhMBetMeR+V98LSVhCPSLEGSYEewwTBUJO1Yn+iJ3bPj2/JIxm5L4N+El6SRn0nwmDzGhL8/1Yxnp79fyAZ1Mzbhjuga2C/CXLu7zC0vI0NhXZLCXO2F6UMxDSNqB9UtqbrkSPHDQElqrTH9ZHYbMQQlkQfvaNPYW7m2e18IvBtjl0WRhh1QHQzbAzhmEE4F5wTYrH0rPwvPoZPkSmnMSVsBPSM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 01:48:36PM -0400, Gregory Price wrote:
> On Thu, May 14, 2026 at 11:47:19AM -0400, Michael S. Tsirkin wrote:
> > On Thu, May 14, 2026 at 11:41:45AM -0400, Gregory Price wrote:
> > > On Thu, May 14, 2026 at 11:34:14AM -0400, Michael S. Tsirkin wrote:
> > > > On Thu, May 14, 2026 at 11:32:26AM -0400, Gregory Price wrote:
> > > > > > > 
> > > > > > > Maybe mildly out of scope but worth asking:  Are there other flags that
> > > > > > > should be retained/propogated on a split?  If so, rather than pass
> > > > > > > was_reported, should we just take a temporary copy of the page flags and
> > > > > > > pass them all in?
> > > > > > > 
> > > > > > > ~Gregory
> > > > > > 
> > > > > > 
> > > > > > Not that I can see, no.
> > > > > > 
> > > > > 
> > > > > You do this exact thing again later :]
> > > > > 
> > > > > https://lore.kernel.org/linux-mm/9a22e0f9bbe1278913754db6df76e291a006181a.1778616612.git.mst@redhat.com/
> > > > > 
> > > > > ~Gregory
> > > > 
> > > > I mean yes, reported and zeroed) Just zeroed does not exist at this
> > > > stage in the series.
> > > >
> > > 
> > > More of a forward looking question: if we already know we're adding
> > > was_reported and was_zeroed, maybe we should just pass the page flags
> > > through entirely and let expand() check them instead of passing it
> > > through individually.
> > > 
> > > We end up doing something similar with post_alloc_hook later as well, so
> > > I'm wondering if there's a general improvement that can be made here.
> > > 
> > > ~Gregory
> > 
> > sure, will do. do you want a bitwise thing for type safety? or just a
> > long?
> >
> 
> Can probably just do like:
> 
> flags = stable_page_flags(page);
> 
> plumbing...
> 
> expand(..., buddy_flags) {
> 	if (test_bit(PG_reported, buddy_flags))
> 		...
> 	if (test_bit(PG_zeroed, buddy_flags))
> 		...
> }
> 
> or whatever makes sense.
> 
> ~Gregory

right, that's clear.



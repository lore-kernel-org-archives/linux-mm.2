Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98B73C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 20:16:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CFD06B0088; Wed, 26 Aug 2026 16:16:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 659936B008A; Wed, 26 Aug 2026 16:16:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5227A6B008C; Wed, 26 Aug 2026 16:16:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27F7A6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:16:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7656F140246
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 20:16:01 +0000 (UTC)
X-FDA: 85144526922.05.ECFF271
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 201764000C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 20:15:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bnD15MZL;
	spf=pass (imf07.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787775359;
	b=I02rLcH/rJEcI5LLhfbgklqvP/qJh6v66y/FnGr0dgMRkQmYqop/wi/yNQy24K0tfcG9Ui
	GmLAzUV0q54boZ94BgS0ESXqMbTqAa6Wh75ZPqYAbmKu+CxNCYZxUar+BXCF/8gfehypzk
	YYWjxMylDReL9wCnqpfMI/68bgbnfWE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787775359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5XOoAhfyz9xtKGJKuczZNY14PVIcWN7EMcbfAjCg3O0=;
	b=3361xxcaHVOTwkocmZ7JHAciJqNfD+kH7PsMiowcUvKB6sCq79MbZXdJaG31EnCpnFKBbN
	/0RLCBTL51rsq+izY/hEnu97U193M7ILNzctd3cjl87OlIzKWUIn6qzFcQNswCVr7AofIH
	fxFZeByykcczf8eaf5g/98/4W9Ahnb4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bnD15MZL;
	spf=pass (imf07.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787775358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5XOoAhfyz9xtKGJKuczZNY14PVIcWN7EMcbfAjCg3O0=;
	b=bnD15MZLvhgLAfEQgcoWDNHu42nQC8I1A23KXTndOA0jShNqsL5Iim33yOtfveCs7dYRmL
	t+s5Np5C5fKmKbfcNbAOvvFFxh1gTkt/QqlpXnZ7b1N8uXXlWvxKHYRbUeiy7aHMYFgzjx
	PxOSizYCKjVfqvDMX/TPEscf+M5v+nQ=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-520-pytaszYGOuSzxXZTtpb60g-1; Wed, 26 Aug 2026 16:15:57 -0400
X-MC-Unique: pytaszYGOuSzxXZTtpb60g-1
X-Mimecast-MFC-AGG-ID: pytaszYGOuSzxXZTtpb60g_1787775357
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-9368f2b7b2bso133910685a.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:15:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787775356; x=1788380156;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5XOoAhfyz9xtKGJKuczZNY14PVIcWN7EMcbfAjCg3O0=;
        b=BVPIFY/dx7PFb3lfGUukj5oidAcuTXEETsTCxQ/u/zWtJxzpgvOeY2wPGJa4yiFaxy
         ibFTzEv6V22dz/owEn7rd5UIdcuTUda9OxGcYEmbGh74RoKmw1ojYnqkjhFUKHP/+1Qc
         wbdS+0XprmFaukpLSJnbutyRtOWw01cmKbylMAX6UZT7bM91y24iI8hSMg5gho6xtpXG
         ssJ/iVT10dOQoIS4ix+q/qYUSicIgF5Nqk3jnt74X0kLRqNu5JMHNsIp/+G70yFtzzUx
         PnAXaPlvS0Gx8ZCfLBTeeWw4S6SHeaqy9vhK2dcU0FduNAu4IbeokQsufTmlsOkcB5cL
         qm3A==
X-Forwarded-Encrypted: i=1; AHgh+Rq+t923klHBlrO0mVwaw5IpZP7StBXL5N5M8quVWxUMPYSA7ZQ+rMqZ/mxNud+2NqQWR2yHubpoJw==@kvack.org
X-Gm-Message-State: AFuF++m2GPODo7z8HMs4GKZHRZnrlmMKBelcQf/fpymckux5NjX99vNC
	u7jTre0oFV7ngw6qlJ7mUDZv9bxdxR8Bnyr+sZfONls2D0bAXUYhbVpCbUGZtEMAxVikX1vz1iR
	F5hVZRRTtWIJClk1u4ouQ2klm07u9V7g1d0ulH4zVBqhuhb4wystJ
X-Gm-Gg: AR+sD12gWPJ9tX2/19i613Y35rDhIZo9YNRAF/7F93RRlpLw94/F5motieRdvqmvg7y
	zEOuxFsHC7q+2aN/nzApEy5H8m7enAGYvKFAF5cII1KtwnFwVoWMxyuh7lxOdmvYr4QuyIaou1i
	rl2klwBL5Yrolfle3tErCzvgez5z4+m7BtSMW+RDAhH41Ou20DMRFQ7URlzOyJ9nGabUvyxDJlr
	pKLP3B521tdCTeonyzdvtpxED69r/h+r4oXeVhlBYtWel8Vne5v3Eyh7BJlvIw1itQOhJkXD0mE
	x7/83yNR2W5WY/Xkz6/IXWSut7fVDmGYJALgTnxYbjr7fjeQw3+dXVN6v4o3AUHjgD4skvsKHTw
	DV4QKoRjHU3zayA+4VkCAa1tn6UmmjNIkbVKdHo4Od1/S
X-Received: by 2002:a05:620a:3bd0:b0:936:a407:98bb with SMTP id af79cd13be357-937800f72b0mr763376785a.9.1787775356464;
        Wed, 26 Aug 2026 13:15:56 -0700 (PDT)
X-Received: by 2002:a05:620a:3bd0:b0:936:a407:98bb with SMTP id af79cd13be357-937800f72b0mr763358185a.9.1787775355027;
        Wed, 26 Aug 2026 13:15:55 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9377e30ed19sm292126185a.8.2026.08.26.13.15.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 13:15:53 -0700 (PDT)
Date: Wed, 26 Aug 2026 16:15:52 -0400
From: Eric Chanudet <echanude@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Message-ID: <ao89rgCB4VhNt7n0@echanude-thinkpadx1carbongen13.rmtusma.csb>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <aowHqqaqK7TeexQH@tiehlicka>
 <ao2gA_m3BCBu2esy@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <5970a8d4-fe7c-4dde-bdc8-1c66bfb57f12@kernel.org>
 <ao3CQicH0t-k95NA@tiehlicka>
 <ao3gLqsF4WSeKBIa@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <7e4e9662-d876-4493-a0b3-e31640937dd1@kernel.org>
MIME-Version: 1.0
In-Reply-To: <7e4e9662-d876-4493-a0b3-e31640937dd1@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EosoEpDjtTAE7u_FCVCUpvrKMXxTBlF2yV-66S9aPLA_1787775357
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 201764000C
X-Stat-Signature: dx649x5xkj1tstro84i1jmus9qcswjmd
X-HE-Tag: 1787775358-110684
X-HE-Meta: U2FsdGVkX19bu0BiSywQdsj1kedA2PG62Pyb0crvtzGH5ca8rcZ3/aUPHXA+QskuZwI2Ycrr5M0nw6rd1scr5f7XByb5liwV+Ez/LKYuMoGfmAlLG5rJXbdiQr7IS/g6TFmpr8F7oIRFfQR8ZvvPmwkm/d52TFXggQLfrwqIT2+dGst6bMzMH67bPitRq5G5OP0N4TsteTopNR4vJ2PYZsc/VQyYDcXjSDY2z0UwTFQN55pKGgDgEQlE88VMqod4BwtBdQ2HoWJr9hvNB4Nu/cCLq3zcRHgyDFP1Kij0AlZEXUrZl6MK9+exNkhwWwL7GX6XY1oTh0YuHt/ofSTRMPoZAo8FZGCCIzG0Nfdi9qf7/soCtWb5etaJoAGctE6JS+T19WAmnZ2ISfsiYPG3FPXuJWqkSrWsY8Ncuxr5PzRjZR7LWKFVWvikD2YaeZO+e6sv2kPGrzIvSeY1IkfUy51DN7OTdsBYzvM6QpU2WU33EQFMFiChQvXf7ELpsptzesXLxKC+TOrlKmFm411+6+mfKPP6c10AbEZCEqyjNsT44CiPOHxkLnZ8QMw0hCdZZlK4TZC+j+37UD4aI8W9cBd7JC2LufFGDMf8Q3i67BDJdSCaPm2+PT0LnmOLwWqm6sSQ6Z9oQL7n5TdyZA26CMWU6i2DS71F7SUi5/xSWS+RxddTU2uh3LOF0/E5G+fGTUvhJBTP+p+eOToxkXT0Wd1TnM+1IvYCOS9kNvUtfJ78nPEST+sW8OcRp8yKigOxr/CsqIeKwbxZAI4YAZXsxgtQoRaaeTWa3mxn9YImP4I38Zqm4dUk0hbxEII65UWdMqWFDbAdJ+aRlp8xAfRFE9VDj6/QyP0vf7K+cVj0r4lYpJ3ih/WeaQAFZXTTbAgfXupNOuXs5pMM2cXDor4OdwbSqMdsbSdVCNA8Nwe5aXnFqiUWz6baJXiOa61WsvNpJOkIvyis3+7jicl+3k0
 hVYVjfYB
 J774oMR+CowL/KxClxBlEA5prUMKZfioTzzOuWuLX/2SoGWG4iFN3buETexTWzXBiE0hJIkmqtzC9Ffz62CzWr2RlG2Zoz5PsoJTY3DFPrgpkrxjmNGlY/quDj3D787zcIjJ6B/nLvqu+Zdl3B8cwp19Upjz+Ysbk72FwjiJuFdfxUNQMlbkJmUbe74OaTJD6Q9iYtl9LRjURp1tJhBJeNDIfONRwjiJHemh844nE8RRizFk52/GKD3zu99lE8RuLVT5/cuPe4h8rCHNNyOsZ0qE+F35M+oiVkw+BlCek/IswobH+6YNvjMCBX6nVgss09RXZoKDwrYfcYfCVe8me9o+u2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 10:02:08AM +0200, David Hildenbrand (Arm) wrote:
> On 8/25/26 20:50, Eric Chanudet wrote:
> > On Tue, Aug 25, 2026 at 06:26:42PM +0200, Michal Hocko wrote:
> >> On Tue 25-08-26 17:45:56, David Hildenbrand wrote:
> >>>
> >>> How does this e.g., relate to hugetlb allocating from CMA, to then charge to a
> >>> hugetlb cgroup?
> >>>
> > 
> > AFAIU the system defines CMA areas to allocate hugepages from. For this
> > initial series, I failed to handle it. The intend was to consider it as
> > any other CMA area. It entirely missed that hugepages are already
> > accounted for by their controller (cgroupfs opt
> > memory_hugetlb_accounting) and they are charged when faulted in from
> > their available pool.
> > 
> >>> I always thought of CMA being a low-level allocation mechanism with various
> >>> different use cases, and actually the higher-level users should decide how
> >>> to/what to charge instead.
> >>
> >> Exactly. There are many different users of CMA all with different
> >> requirements. Then there is CMA reservations if an area is shared and
> >> the overall memory consumption. That is why I am really not able to
> >> wrap my head around this proposal.
> > 
> > It is nonetheless available almost directly to userspace via dmabuf
> > heap, or as a result of drivers ioctl providing a contiguous buffer, and
> > unaccounted for by existing controllers, with the exception of CMA
> > hugepages with memory_hugetlb_accounting.
> 
> No. The charging really only makes sense for selected mechanisms that built onto
> CMA.
> 
> It does not make any sense for subsystems that declare CMA for their own use only.
> 
> Like hugetlb. Or s390x's VMCP region. Or PPC KVM stuff. Or the crash kernel area.

I see. The crash-kernel does not use the CMA allocator it would not be
affected, VMCP or PPC KVM HPT use specific areas and do not have
userspace use AFAIU. They would default to the root cgroup that does not
get charged. Maybe it should instead be more like GFP_ACCOUNT, making
charging opt-in when the allocation happens on behalf of userspace?

From the other thread it doesn't seem like memcg is a good fit either.

> 
> -- 
> Cheers,
> 
> David
> 

-- 
Eric Chanudet



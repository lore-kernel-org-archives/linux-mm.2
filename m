Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F2DDC61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 18:33:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E91566B008A; Tue, 25 Aug 2026 14:33:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E42236B008C; Tue, 25 Aug 2026 14:33:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D31866B0092; Tue, 25 Aug 2026 14:33:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A64E06B008A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:33:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 19064140142
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:33:56 +0000 (UTC)
X-FDA: 85140640872.01.4D3D55D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id B8906140009
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:33:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="W/8SbrF7";
	spf=pass (imf23.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787682834;
	b=lWV7HLCgcH/cSgrj7zmibVIo3mfQwmoo3clCkNEIdRnToaWi6p9o58x5WETaFxAE8+Amxe
	qCbra2l6uigB8tPUW8JB10K4FRGjtAleNuEyNEpvk85uUYTZozCcHm391EVoTeMO5knjcQ
	rT4nLSupoEeaEIZib+yrSfPfv3KLz/Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="W/8SbrF7";
	spf=pass (imf23.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787682834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ezRFPRBsxOpDYy/LiqFi78+AQBRMUReYJkZLlaNR3K4=;
	b=XXFozJndeYk8wSxfXS+n/huYHkRYVsV2VrJQD13LQ5ihBIukDkxjNIif7uAD+wclS5x3JM
	92wW60IUX3xlJZnCe+WrUOE4wbH/oks6row9LS5fsVNWnGtn/0ocIcMnuM7ZOjCWoAwj65
	vvflBbulRbU8hLUEI8DniypjmduVO/k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787682833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ezRFPRBsxOpDYy/LiqFi78+AQBRMUReYJkZLlaNR3K4=;
	b=W/8SbrF75mz/Zn8oWiVac3ovOvThYS7LcQubf1KhZG0A30B9KAJFWsL88sXa8nm27Dnh4J
	wtFz4ORgbPryd7MPozFPaY1ggjlUgt5Z7fGWDI7pGPf80DSeT1qXHO4n03ByTWdR2SpR5x
	Z6aGrhXJxyl8+rqRR2eqJk12Ye49lyE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-384-P5ToOGmQMDODHdfj2xUfwg-1; Tue, 25 Aug 2026 14:33:51 -0400
X-MC-Unique: P5ToOGmQMDODHdfj2xUfwg-1
X-Mimecast-MFC-AGG-ID: P5ToOGmQMDODHdfj2xUfwg_1787682831
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-9083b049f73so1902566d6.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:33:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787682831; x=1788287631;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ezRFPRBsxOpDYy/LiqFi78+AQBRMUReYJkZLlaNR3K4=;
        b=IAA1ZPnRFlyShdrBdcD9NVgVj/VLif4o/2Jd1593yE9+p7XkJA6XHESItC8pFuffJF
         FklOYE5MJH+BdEkPG+hpBAMTxCj2vmPOIOqcEnynNchVPYZB9G3c2gmGxfDIXS0hVTUg
         YxrKjCV4GToV7gHLQt4qJKI2eR5+vb98eHWaYa0CCfEARILIrE99SwX+9u2fnSy+J9Dp
         FsMPCHm6Xf91MQWUOPNMJZuTY0vOhTZrClUCzAQTV6Sj5+XjQtedPqH+nsSz9LEaBJeV
         bF0PsDB/iZuqFKDiyUxcS//PqHXEzLskfBmryY5STtq8tUngBBwXBWgKYmJuh/gj+VNJ
         Mk+Q==
X-Forwarded-Encrypted: i=1; AHgh+RplJ2HG79B87z6Herw1GBLumFqNftD5rMZs3BhQiW+ZkVQLI0OOIVQ5q3nJLWT0MhML9nVqeEXkmg==@kvack.org
X-Gm-Message-State: AFuF++lnYkcV6KIpiveGLcHqO0CoKB84eY5P5hoGlQfjSA6Qxep6GSiy
	le8/0uiSnNNVtRyLC9lqh59oh2hRmaUgbdn7VG5xGAlM8vCe9XhN6rac0aoJL9SIJIcwovEKamk
	vA/SYSTlSnD/Mpzmwi7d7lBVPjsRjTRWAnSHKqEdRyhRgEWooIpOu
X-Gm-Gg: AR+sD10dzYS7oULZBA2a78VyaJIiw34NJKUkwowLQbA15LKGq+Pn/fjOjceNe8NF84Q
	7t0joILFTWJfGCdt+gmmIVF5MiLzjm0j7nRu/boljq10WSlrtRibEQ/qInaLALamXnzd0x3yVWX
	x1AkYTA8q4amaxYc4MYbtpiAnwgKTmlW8OklBQ+mHiMqzhQVU/UY/TVyhzIh/ENN+Vub3XwBluL
	Ph+DIq+EvM4KBcoUkzLza9/PGAbuoc6rQGLd/Jhg9LRtNDksubAPebz+EKMYi1E2cVmHyRB6NcM
	gMNc3aP7IXHRqLI5zZYt4qBROH1XE7GiIt2NzukAe9BnI1ntjHeSbd311ApAwdIo05HPVmLHWAV
	5jrZGKrcT+keNr4ZD19PinHobLzri2j/YYvPzZoTy8J5O
X-Received: by 2002:a05:6214:469d:b0:90a:4361:9c4f with SMTP id 6a1803df08f44-90cc790aa6cmr10048366d6.1.1787682831056;
        Tue, 25 Aug 2026 11:33:51 -0700 (PDT)
X-Received: by 2002:a05:6214:469d:b0:90a:4361:9c4f with SMTP id 6a1803df08f44-90cc790aa6cmr10046546d6.1.1787682830292;
        Tue, 25 Aug 2026 11:33:50 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90cc65093d5sm4901706d6.26.2026.08.25.11.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 11:33:49 -0700 (PDT)
Date: Tue, 25 Aug 2026 14:33:48 -0400
From: Eric Chanudet <echanude@redhat.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
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
Message-ID: <ao3UKM5SbxBmxuR0@echanude-thinkpadx1carbongen13.rmtusma.csb>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <aowHqqaqK7TeexQH@tiehlicka>
 <ao2gA_m3BCBu2esy@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <ao2t6HP-Zt5KDg30@tiehlicka>
MIME-Version: 1.0
In-Reply-To: <ao2t6HP-Zt5KDg30@tiehlicka>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3oPKRyMztbBAwUyInLSr1PvW-B-MHmsXok1bCQIi9QQ_1787682831
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: w38wkt6szbezskd4rdbjkonk7jm66j1n
X-Rspamd-Queue-Id: B8906140009
X-Rspamd-Server: rspam06
X-HE-Tag: 1787682833-281362
X-HE-Meta: U2FsdGVkX1/zNTscGZ2k0v2xTGK3eMo9ZAB9DzupZ6uw1XTgKuSLjaFgN6tKRdP+N+BNWMdOKWPWON3AVgNfdGCDIcTiUT6uAH/AdkzGpaqclLZxBPLHh6HvM02ST9PYoLwwjsiCJvgwMOBO/8iO5Ewrcs3W2KPmmNems1IWQhX/LEyDwVM92wxxY+UEKrJT/jU9T0nkGAPyG+afCtdA71eoiUlKWQHeVfLRdxAdmv18LQ7f8lXMyjIanpWI5Ikvpg3ZPabkrGkIKhSqwIDAK2dTWF5IYb0JqKW8F5s9lM+IVrUfSF34efJvfGT81+t8HgMfZlqh2mUnSN7Bv78+SDbsiP4IJWKLuU1WJVplwcM/MABP5XJ0TspGt3jyKYq4spKuGhoLG6H4gMyMw0jKomiSpE20lUJCYBs3kwqjhLjHOCfEPyJ8LBM9D6oKHs74Rk830evtESwiAnU+QddG+EhEb2GR7wYVvaKmk18FbD2zOo43SrKt+TEVQg3UkLb30ngaz1Ha9ash7C9COSc3SM76KKgIdgxzeOhTv3CG9uGZnaU110TWGmiUX2aUSpk7itO1u81YFOhVJW72kRwDrk7CHGrbbQ3aegVe4VebkwKdrX70THMKJqBzsIONJ9zhoRmJuqjjuTS71dOoqLcuX+/kMKnsOTssoUxv+UqaUjQ7320Zb5gz9iiSJLFA7ocDDWJDbVZb0gSn+8tmTtWZHeGdrXcI/Nq/tYDsTi3eTCPnel9NWcrQgIzb/k7RtwPCQbykP1HIqjLd/J2kgxk+86ifFtsNguvbmmHUvRFeF302LI4klaDSjOYr5jdqn4k94S4jl5TpMmtH0RCYy2/TjH3wJ9uT8ByRMfnMKXgBaGEkHnFl/pGam65+7Jnnf2Z/C82zcGFhYelILEbzQMX03L//4nA2vTiDImeAwwLVZulKRUS+L1U5f9so1jicQ+FxM2sWWKIc1VKgpdaR8cw
 7Xg3lTZf
 VQy653CWCaLhy66BBe+ku0VSylUZysqeJAw+Do3M3E/JZBD3t5glcl4WcQE9aokuHmoX3Mi40xLCsiDxLuIRBEK4/LoXaDITvM2s0/hZqgN+/aWf5axGJ5uDSuxuDBXYtUjDURWcD44RvOkuijtCgpC04Rzyq9e3P+U/OqDyAQ8sBQAJ9Odz7CUm9YpQXZhZsQC6+XpNCrCMm9fyn45ttkMTn7JeaN9PTrwRcHnYBpqoidhcuUijioVuTKjIiXJRpgXTUyvgXZjBzVngT90A/xJ1hUmp3ip97LB3P9VQLdUbsJAuQ+OdFrYUJmaJIeXeQtNXjoR0ziFEKhruS8hbj7WSICE9OUOV6VgTrLqCyfhgCxLYz6L+3F11Ch7kYCYYi7Zgfv4OySBnUY0s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 04:59:52PM +0200, Michal Hocko wrote:
> On Tue 25-08-26 10:47:53, Eric Chanudet wrote:
> > On Mon, Aug 24, 2026 at 10:58:18AM +0200, Michal Hocko wrote:
> > > On Fri 21-08-26 14:56:52, Eric Chanudet wrote:
> > > > CMA allocations are currently unaccounted for by cgroup memory
> > > > controllers. As system resources, they should fall under memcg, but CMA
> > > > areas partition the available space for different purposes and memcg
> > > > doesn't have a good representation for that.
> > > 
> > > Which CMA usecases are covered by this work? It would be also great to
> > > spend more time describing usecases.
> > 
> > We would like to offer some usage guaranties to userspace processes
> > ending up doing allocations in CMA.
> > 
> > For example, a shared CMA area is described in device-tree for an ARM64
> > platforms. Userspace components could then, for example, allocate from
> > it through the dmabuf heap, or a device or framework-specific ioctl for
> > that matter, to use the buffer with sensors. The dtb may have other CMA
> > areas described additionally that may or may not be used by that
> > component. In this context, we would like the ability to limit one of
> > the userspace component to over-allocate and choke the other(s).
> 
> How exactly is this supposed to work? How is the CMA access controled
> and opted in for accounting. What happens when memcg limits are hit. And
> many more details, please.
> 

The administrator opts in by mounting cgroupfs with
memory_cma_accounting. At which point the cma allocator will charge CMA
allocations against memcg and manages a per area counter depending on
what area the allocation was made into.

Assuming memory_cma_accounting is set, if a non-root cgroup makes a CMA
allocation over either memcg's max limit or the per-area limit set by
the admin, the allocation fails with ENOMEM.

If memory_cma_accounting is dynamically unset, no the CMA allocator no
longer issues charges. Whatever was already charged can be uncharged
when it gets released.

It looked consistent to use memcg since movable pages from regular
allocations may end up in available CMA regions until a CMA allocation
needs the space and has them moved. So in an extreme case, hogging the
CMA space of a large enough area could trigger system memory pressure.

> > memcg
> > looked like a good fit to achieve this, albeit handling the areas, so a
> > cgroup has a quota in a given CMA resource.
> 
> Please expand more on why do you think this fits into the memcg model.
> AFAIU we are talking about a unreclaimable memory and reservations of
> CMA areas.

Since memcg already accounts for some unreclaimable memory (kmem,
hugetlb), or induces failure if no reclamation is possible, I did not
see CMA allocations being unreclaimable to be a blocker to track what is
otherwise system memory.

I viewed pages allocated in CMA as guarantying special properties while
being otherwise similar to pages already accounted in memcg to the point
that charging them against memcg made more sense than having an entirely
different pool. I can see how that could be the other way around though,
especially with the per area counters, like how hugetlb have their own
controller.

> > This trails from an earlier post where we tried doing this using
> > dmem[1], but I was unable to reconcile the requirement for memcg
> > accounting[2] since from dmem I didn't have memory objects to charge nor
> > the guaranty there was one. Given CMA is always system memory, it looked
> > like a better fit to try something without dmem.
> > 
> > Best,
> > 
> > [1] https://lore.kernel.org/all/20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com/
> > [2] https://lore.kernel.org/all/ahB7pCu_G4vuswc0@linux.dev/
> > 
> > > -- 
> > > Michal Hocko
> > > SUSE Labs
> > > 
> > 
> > -- 
> > Eric Chanudet
> 
> -- 
> Michal Hocko
> SUSE Labs
> 

-- 
Eric Chanudet



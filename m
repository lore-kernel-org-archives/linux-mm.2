Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B892C83F25
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 23:16:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C3D78E0003; Mon, 21 Jul 2025 19:16:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19B878E0001; Mon, 21 Jul 2025 19:16:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08AE08E0003; Mon, 21 Jul 2025 19:16:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EC66C8E0001
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 19:16:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 54D7810E085
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 23:16:27 +0000 (UTC)
X-FDA: 83689832814.15.5636E8C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 34FBA14000D
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 23:16:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YAfHi6Ln;
	spf=pass (imf23.hostedemail.com: domain of airlied@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=airlied@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753139785; a=rsa-sha256;
	cv=none;
	b=ZlocWP+u7c8ZE2p6AuFhIa4zXUdkwfAMk8I6QD9fzBUPSrFSQBprcWlVTKd+xrC0fq9ZAn
	sGuV0ImxNCloBDjrcX3E7w6BJfYg/ufKs6qG05IrwfcxNfEKrHj6ELxVm15w97vYVvt6xs
	kTBrT/hDxaCeDAgESZ0Y+1uZUYxQvZM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YAfHi6Ln;
	spf=pass (imf23.hostedemail.com: domain of airlied@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=airlied@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753139785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0RANPUwLK/+IsiZ6Dm52cZEYEBOxN8znQ9xRdG6vVQQ=;
	b=X5swYnQ5FO5/J3dX/3g7x4CFQ6AYCZR1bzGYCnhD24tkzEz7GyOOkTyF2j+bhv++GE65fn
	w3xr8hEBRCbHgd7lTJwkR674Mp3GKKat0i/w57C+2ZUVdA9RnYP7O+IupBe0ZG+4QlydGv
	zDbAxWs2FRv0zufrYRvIXZyiyNwmYz4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753139784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0RANPUwLK/+IsiZ6Dm52cZEYEBOxN8znQ9xRdG6vVQQ=;
	b=YAfHi6LneK6RXr+V49CyVENa+PXy8i/hZezwgabSIo9ZgKQ0MrEDwSLpVogeM8E2cTcAUB
	Mp54ZIxmlUPxp8EvSclVohLMlTw934FGlf2LMxQFjipu+BqEQIh5RgaXw8bY+HGGVtdwJ0
	eh41QCvdDVoXvu7Qe9cVxRAd73ui0Tk=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-28-WDITMwKLP3a0CsQf7k4S7g-1; Mon, 21 Jul 2025 19:16:23 -0400
X-MC-Unique: WDITMwKLP3a0CsQf7k4S7g-1
X-Mimecast-MFC-AGG-ID: WDITMwKLP3a0CsQf7k4S7g_1753139782
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-313f702d37fso5101862a91.3
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 16:16:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753139782; x=1753744582;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0RANPUwLK/+IsiZ6Dm52cZEYEBOxN8znQ9xRdG6vVQQ=;
        b=ESqDhadhoK+nk+/8ba1VnvhDoI7ycjnuHATSnvw2NktWXuGkLz+amjhVNLKVyMFlBU
         UswZIGlgjJjnFsUJe0hIcuWzqusAWW7CwiHVgndT+qDRVJO+U9Og+juo9WhoSMaxNdyT
         wvEafxxCsk/PQjZhWLvX/jZg5wLLWopE+i2OPaTNsixzqDa64yErSMqi/IUpPZgYtrlL
         +BTSp3JqM2rHkufWcBVRtNkNeX9n1gFIyAvUp63kUoMCaGDk7tyhhZtdN9sTpBY7JjgX
         qSjg6v0Utg6Td/bvWwnVngbAnKKfIpz22CXC/ilRjlX1H9Cio751MbgaBjhDFIxysoCy
         pNUw==
X-Forwarded-Encrypted: i=1; AJvYcCWi9FrxqZTkQAoxWZYWgfI+0WrJMIHZfbDHqIEyaS/PSYcxBe5oAcfQBmUgGm3o2UGuqywdjyUcDw==@kvack.org
X-Gm-Message-State: AOJu0YwIr30ayw5IP9pghZpJY55wmQjPUw//zXCAX8ElbbBRUSKYqp4C
	fVCJrYXv/KCr/YBhrrNGgBK/QEeQaZIcrAlvl0Bhki7gqMFB0F90+kMPPFhuvwKir3vWH3WSGu2
	4fVTD0J5gIGxtEDA2nw8sx69l449CWb3RQvTW4S7PfVXxb+viDM5IlJ9lHfXFD+z5S7uFjKqqxN
	khFzJuSr2Ri6QQsACuEybMMpU9CM/HDcFmmE0=
X-Gm-Gg: ASbGncuO40GmbNIShTatkd6qHgsSt4Hu4jUc6Louvx06/L7mteqymxwB1QBzsG+3jVy
	Hto2xIE4Br6/Y/p27gpCK9sj7TORY7l0mWXIptRHua13pK50jpEPrq3pvoohYH/zcYR1ztl8Tmz
	WFVUrAIADMn78DSstOcXM=
X-Received: by 2002:a17:90a:f945:b0:31e:4112:4031 with SMTP id 98e67ed59e1d1-31e4112423fmr346195a91.30.1753139782045;
        Mon, 21 Jul 2025 16:16:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFVllUE0kmokZ1rSFDEaxeK1PBlFYNYGMDZAa5DZKKR/0uMFkT3Ygqlo2cbqSkCQZHg5Z+MdCRteXwtLMA85Cc=
X-Received: by 2002:a17:90a:f945:b0:31e:4112:4031 with SMTP id
 98e67ed59e1d1-31e4112423fmr346163a91.30.1753139781564; Mon, 21 Jul 2025
 16:16:21 -0700 (PDT)
MIME-Version: 1.0
References: <20250714052243.1149732-1-airlied@gmail.com> <20250714052243.1149732-14-airlied@gmail.com>
 <77949b3a-201d-4e7d-a51f-e77274e4a4be@amd.com> <CAMwc25qP-42wMX4UYhZWiYfvf_1dBVNL9TU9i_Wq7uZPqjQL5Q@mail.gmail.com>
In-Reply-To: <CAMwc25qP-42wMX4UYhZWiYfvf_1dBVNL9TU9i_Wq7uZPqjQL5Q@mail.gmail.com>
From: David Airlie <airlied@redhat.com>
Date: Tue, 22 Jul 2025 09:16:10 +1000
X-Gm-Features: Ac12FXyYV-2PTuPjVu6efxxbgIVKXXIhFVKn9Tqb1n6SV0qyL72jNnhdrGWhJXc
Message-ID: <CAMwc25pyqhcq-8ubGZT5UX5AYroewBYP6oFN-JmjzEkHgFLTrg@mail.gmail.com>
Subject: Re: [PATCH 13/18] ttm/pool: enable memcg tracking and shrinker. (v2)
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Dave Chinner <david@fromorbit.com>, 
	Kairui Song <kasong@tencent.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jWmUtk4uiqzmEWG7FIWx3ix-f4LIxlFsiYLD1zPPVoU_1753139782
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 34FBA14000D
X-Stat-Signature: nwjso3d6m3ebouqogzufkhufbuopq46o
X-HE-Tag: 1753139785-633152
X-HE-Meta: U2FsdGVkX18BUeGoykdPBebcDeG2D9OD83X1fpTRIX+JysmE9qFd89upCqODZcRUWh8JyL94t2heaJiPfW+Gc6v17TogctPkJ73Kbys+x7iSwTQ5ZwPRvh+HDQ8/cuWTcD484culpR22o4NxnrknB6N9u0SODUpcOuNRFj3VoTjbrmGyMXG8dmImsVzeFt7+9O2nOPYaU2uEWJ2Fl3zS+Ln5ghFaJ2PCQoNex0hYU7XHQE25/LvXmTPB48UvD+srtvkTAhzGRJOmv0x2d7AQZW6ZSyIFrYvYA4GjUymRn8nEQ3e/xdYOQu9+xymOP4gfqM5Zq9iX4B870vE2WsQMpjJhA5vd2A8OH5n5g2bspJVB9ZzouQcgsoQ+sKxR7BrKKwpcySQvOP3q1J+QGJQvwIAqH7aEx5z9Pwqj16q4rJg8Bsv2WU7k/2EjD8+Za1CCuM7mqchXjGbfU4ufAruN6bVtqAWZQvTcWjQvEREvGa/v1wC98eT27EXQ+0Sqh96NzphOV4STeohzsbTix4sTCDW0zHyxjAX3Jn/v28o3cvvBMN9UxriSORj6CqOT69xQIRkLnvU9ksckVbnl0FCkytsLxKd1jVrDeOsMZPMR78dlZwJt+VQcLqL5baRhp6yseMo8xZd72r8oNxsLHM4FMb1SpjXJ1Nqbe6WW8Dir931UbCQnF+kYG46zuIqr+0CXk+MZagXTHn6Go5nnYOblg4m60TmwSzU8XSdInC55BoMSDPEirFwmX5ufcB2usTYNDEC1zKOstM3T9Q8l/G8s1KgQDBuWVTQeBQfEuzH97Ct2T5NInrUOToLklVGITLgip071Fw07fAUyUvd3SBRXan8WLYOlPWlqNDVZzjrtAU+cTqMGgFG3F+TzhKdVGQsqDceU3xFyztnUXEzMPIyirZG2uvHrNQEH1/52auHQZaTrwAO92Wyw2GikDi2VfKc3gowc5Q68wGefqIXUyoc
 A7Tbc5rZ
 xqI83uDyphh+DpdUCAS04Jtv/Dwtz61C9xPLkcG/bFsiKLbBpWzWkWXfWGjVZMTVQl2SfZDgle2o9Ee1lm8BfWZzhXb15vJo1/PJIjPdqUkc9ssmkAHPEHuYB187xrzVTeks5B8NN4ZOc+2Cp+iOZdZcA72CzpaCZLrnjzh7HlC/iFatvdphxv8CwfihMtpK3xY2uxlAUYiIdGHgwV8nxYJyp7sZvFNHvEkWcqeT7GMopt2hOu48xffb3g38fqpwBVRaULPamsZX3qIRu6/wA41zFWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > On 14.07.25 07:18, Dave Airlie wrote:
> > > From: Dave Airlie <airlied@redhat.com>
> > >
> > > This enables all the backend code to use the list lru in memcg mode,
> > > and set the shrinker to be memcg aware.
> > >
> > > It adds the loop case for when pooled pages end up being reparented
> > > to a higher memcg group, that newer memcg can search for them there
> > > and take them back.
> > >
> > > Signed-off-by: Dave Airlie <airlied@redhat.com>
> > >
> > > ---
> > > v2: just use the proper stats.
> > > ---
> > >  drivers/gpu/drm/ttm/ttm_pool.c | 126 ++++++++++++++++++++++++++-------
> > >  1 file changed, 102 insertions(+), 24 deletions(-)
> > >
> > > diff --git a/drivers/gpu/drm/ttm/ttm_pool.c b/drivers/gpu/drm/ttm/ttm_pool.c
> > > index a4f4e27c6a1f..1e6da2cc1f06 100644
> > > --- a/drivers/gpu/drm/ttm/ttm_pool.c
> > > +++ b/drivers/gpu/drm/ttm/ttm_pool.c
> > > @@ -142,7 +142,9 @@ static int ttm_pool_nid(struct ttm_pool *pool) {
> > >  }
> > >
> > >  /* Allocate pages of size 1 << order with the given gfp_flags */
> > > -static struct page *ttm_pool_alloc_page(struct ttm_pool *pool, gfp_t gfp_flags,
> > > +static struct page *ttm_pool_alloc_page(struct ttm_pool *pool,
> > > +                                     struct obj_cgroup *objcg,
> > > +                                     gfp_t gfp_flags,
> > >                                       unsigned int order)
> > >  {
> > >       unsigned long attr = DMA_ATTR_FORCE_CONTIGUOUS;
> > > @@ -162,7 +164,10 @@ static struct page *ttm_pool_alloc_page(struct ttm_pool *pool, gfp_t gfp_flags,
> > >               p = alloc_pages_node(pool->nid, gfp_flags, order);
> > >               if (p) {
> > >                       p->private = order;
> > > -                     mod_node_page_state(NODE_DATA(page_to_nid(p)), NR_GPU_ACTIVE, (1 << order));
> > > +                     if (!mem_cgroup_charge_gpu_page(objcg, p, order, gfp_flags, false)) {
> >
> > Thinking more about it that is way to late. At this point we can't fail the allocation any more.
> >
>
> I've tested it at least works, but there is a bit of a problem with
> it, because if we fail a 10 order allocation, it tries to fallback
> down the order hierarchy, when there is no point since it can't
> account the maximum size.
>
> > Otherwise we either completely break suspend or don't account system allocations to the correctly any more after resume.
>
> When you say suspend here, do you mean for VRAM allocations, normal
> system RAM allocations which are accounted here shouldn't have any
> effect on suspend/resume since they stay where they are. Currently it
> also doesn't try account for evictions at all.

I've just traced the global swapin/out paths as well and those seem
fine for memcg at this point, since they are called only after
populate/unpopulate. Now I haven't addressed the new xe swap paths,
because I don't have a test path, since amdgpu doesn't support those,
I was thinking I'd leave it on the list for when amdgpu goes to that
path, or I can spend some time on xe.

Dave.

> >
> > What we need is to reserve the memory on BO allocation and commit it when the TT backend is populated.
>
> I'm not sure what reserve vs commit is here, mem cgroup is really just
> reserve until you can reserve no more, it's just a single
> charge/uncharge stage. If we try and charge and we are over the limit,
> bad things will happen, either fail allocation or reclaim for the
> cgroup.
>
> Regards,
> Dave.



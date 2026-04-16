Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1A53F8D756
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 14:54:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13BA26B0005; Thu, 16 Apr 2026 10:54:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EC8A6B008A; Thu, 16 Apr 2026 10:54:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1DC96B008C; Thu, 16 Apr 2026 10:54:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DFC086B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:54:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 81FEA1A095E
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:54:43 +0000 (UTC)
X-FDA: 84664715646.16.34E2E7A
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id 81E5A18000F
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:54:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20251104.gappssmtp.com header.s=20251104 header.b=RSloyeSw
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776351281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h9ArDot26j/SH+ZznkdYubmynXqAUZSHKndJja+UouM=;
	b=gldaFZkSEDJdIpi4t0RyLYXejj6/WtsnbrBRcNniF7qfN9g1MbqqFIKm1Fi7VQPbZwoErS
	PaOUUg+Fk0yy/lnsJ6KYthwKWtrIM3E90UH1rRqvl7oWtHwTTQ22qp/WJATzD8vQ8+ogDc
	UTvQ5+G2+ItaxomvQOwuHPRiK/k9bVM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776351281; a=rsa-sha256;
	cv=none;
	b=oCLozUiT4pcPCpEoP/esRP8cDSktPuQ+m1+VlXmIQBZWid2xoPG+2grhxq7Qjw9ZEO4Hzb
	mrHYAyVNCf/2FlQV4Pw57pM4Ges6WFwROkfVbOEF3F4YNkleOmL8/sPzLX9804gW1SHHP6
	ZnrLGbInr2dTnv/8nLGii6pyUbI/alw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20251104.gappssmtp.com header.s=20251104 header.b=RSloyeSw;
	spf=none (imf06.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.221.51) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-43d72875729so3306449f8f.3
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20251104.gappssmtp.com; s=20251104; t=1776351280; x=1776956080; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=h9ArDot26j/SH+ZznkdYubmynXqAUZSHKndJja+UouM=;
        b=RSloyeSwSmFOTeytAD8isAlJxw8dmnVWHupHdLmI0pMWtAZF/FwxjAwpzD/eRcWXFv
         pda4FuGOrVUkJG2YnBxdkguyNXa5iWUnKOlrDmFyDm1+4fTq4t5NvBKsjgGhZ7FF0EW1
         DT196AqfcwkITfxltpPfZtZnBROWvzFgNmxywsLwnwgQsfdj/1Q3RNhLpfug/L0Q49rF
         oFkuj0FlFmVQteooyMdhvdL0aqfFlfuoak+Kn25tRNi8oKA7uCKoevrYPcC+c9Me71cY
         91q6YBsxDDvxT6zfxf8WLOqRP6N8bqI4UsDbUs8ePVWqsXUCrmK1OqlsTT9lf1bgomUY
         i7MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776351280; x=1776956080;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h9ArDot26j/SH+ZznkdYubmynXqAUZSHKndJja+UouM=;
        b=QCG2YJZlRQdawMSXkguXcFjxrdb/FVIsUFNCPVUk2yVuDdY33SaAQLSpihbUSY7/95
         kS96cFLq/qp/WXbTPQMWIK/uPIoxowgnxZH9A+GXPLdWqptJnPoLNwiVuk41E2TVfoMk
         CHI8epuQpsF/HBPGpwcu7dWGiOdq6Se5CcZjZI5tWDTbL13ZIuAkuwBpgYG/XtnSmsZJ
         M366hhEvI+zZV2x9BnDvwmqiT4vTTQXlVSn0P6OtnjbdIH4JgRVx/xxC3usCDJ9hMzNO
         7e03uJPmrgHQmXNG0NdZJi2kY6KlysT7bJWjE5/cuvImT0ejPIMfs9wcn5E0QZ7d70S9
         n+Aw==
X-Forwarded-Encrypted: i=1; AFNElJ/0kSpOpMamkQ9iLPkqFDoLzrCZiCNE0O96sfpCrY8BeNMGHjNaDwJzUPI2pSnwmnxKibQYSsuZTQ==@kvack.org
X-Gm-Message-State: AOJu0Ywy3nlGJgGniEv1yveu4VAhV63tP1AfZC74SkCauwg/SWQ2QTPz
	U5w16+kcSUpBMFNjKcmt09VQRHB5WemIF+1/zfGDqVym2LXaxa6UI5X6nRxV/FAuMJs=
X-Gm-Gg: AeBDietQKK3WJ0Ao21yYm7Gs5mLkCvKVeW/kZrDwNV0dlVMu8EHcAsKrMPPfe65ejIU
	YD2YDdLI1OtxTGDxWiiN+P4ULF4wFxdsZDigth3E+PWngtn6u48xbWRqQIhV664u6eGBIAnCeEy
	IvSlqJf/Vq2x+WBKsjQIvb/ka6O9NaQ1c2GdfAxfF9qnB/FnDhEL3XwNQb9BXMkNMybrXBx5/l4
	vUvUfLu4irvsecUiy52qdLmC6oSReXfhxEVazsDAWxj0vBSvm4fAsWsPElEGU5YgP2kxSXjYLpS
	8C3Xc3KgSPcmlp+LGG3djb9PIDM8SY1y2IcBzyJ+i7uuP1d1RH5H18CqH9bT00H89AvzgqwCnRU
	juHgnHyr3iC6o6BIhrravy1IHSPG6oCbXClbVWJXveWHEDar4DVXfMdCz++9qSBF6NcxtCh3SOv
	IJRtWqaXX/bRMqd5yEOw==
X-Received: by 2002:a05:6000:2503:b0:43e:b0f8:66f1 with SMTP id ffacd0b85a97d-43eb0f866f9mr6366546f8f.43.1776351279910;
        Thu, 16 Apr 2026 07:54:39 -0700 (PDT)
Received: from localhost ([2a09:bac6:37a8:d2::15:40d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43ead3e00b3sm13211504f8f.27.2026.04.16.07.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 07:54:39 -0700 (PDT)
Date: Thu, 16 Apr 2026 15:54:38 +0100
From: Matt Fleming <matt@readmodwrite.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Minchan Kim <minchan@kernel.org>, kernel-team@cloudflare.com, 
	Matt Fleming <mfleming@cloudflare.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Require LRU reclaim progress before retrying direct
 reclaim
Message-ID: <aeD3beNiGDas2WXK@matt-Precision-5490>
References: <20260410101550.2930139-1-matt@readmodwrite.com>
 <aeAtOUIhFv5hXOyb@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeAtOUIhFv5hXOyb@linux.dev>
X-Stat-Signature: 4qyjnyf4yek1tuag4x171mu7d5whigqo
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 81E5A18000F
X-Rspam-User: 
X-HE-Tag: 1776351281-204115
X-HE-Meta: U2FsdGVkX19xdeyA7PfFwqNcSpPXuam5A97APnZ09cjamQwmcglPtmghXta7bywxvTe3/q+3RwkgJtn/cZG7wG5S9nT0ldFE95GnbREskbNCmAs5Oh9/cyapbF5dCS3LMRAJM2c1YygvaZ0aPDPljx5IW6iK/xH+wzpeN1UCLvBFqIERH/k3RUY4zax5keJ9pjz422k+8IG9eZXNyg2DO71E8iUWw9/oXYjwyJbfnzbRyj6vjVxFTcdSMGh9I7HRDf3rCEmOUnZryMfa7Ddz+0FQWrkQaFB+MltPSAiWCpea3IO0mnQyawqTsVZsSkoqCYiR3MSu1m0lsDEcYe94iyjIdl1Iuf3X0K6xyBVrEF3Dn1Hzizuv1hz1NB+ND88fPdV9glfYBlT5oYwAuAOZLw96om68DY1kZ5AtL4gFAecYlOjECS2xGY7CNv15x/tM8zSy6XdUty/5DLW5Gq7tfGq0WEC4TJWWpQ0d/HTl748Y9fWaECTzjnk1mgVsJ0YHZ487Xovla1teZR9QL3b/057nIgsVQeBFURfuQ0ZKeJWQw3ludfRRlxkgoWaJo3LSx1RfyuKKuxvBWZVYtvmCisUEZJFqbEub94jX4gHhaML9f3MTzhzUdqKp/srXFDxkVuicpFU/X3Ehniidd2mRgOWzQ+CFILMiV3nSbmcADX/t5bVJ82DDgx2AGD4ARp958g6bTavIXOm2ZcKoC2kfmLUZUM/SawN3hj9Tw5pm6z/zeE8VuPEH+haZQuM/OKVzJvLh9aKsDL8wK4MKoarOYM7XEia5fYkG8ZacVSBGwb/oDCTCrCT90zsW4YxpOSeo8AO//mIOgf08oqoJKIKvVEMYwGHvPqoVoMeDqrRhqR92W+hhINtCCirg5K/fXYRaflcNVJb76CcyNnBUMduqPAILZoJiyAKXEfGlTItpoqdhoVDAgIyA2bJRZmb88d3EFK4ZTPSl7mJFFYKG+hM
 LdQV+REP
 z0aEHE2Yfw4XbRIk4kABoytv7KUXvGb5xYdJ8I404eft9JOlah3WkHYf5i6sjb+C0LHLYNCL0wBDnXkZVe0SBX3OfEM9GUXmuiKNAKRLuzN7SIOW/u7rsgwl9csoJZZNOxUq8wEvoUogXQJ74QwDeV/8+vlL5KZemEOnUvmO2IYtHGjtWzPl/9AuAwvGob5GBnxSqNW/34LdcnjE6O7ngOuqhVPOgrUmZCV/Mhz81s3osjpHR5r56QaguQJ3W/n/44Gzas9LioVOG3zMB0YnnHgLZXx3bSKDfMEsZsKH2DFLUlKZsUM2KGNHRF8Oj8OdnSvdqc4QbE1coemC+CmThlSrYSPeJQ9LhSCIBQPwjEFHfSts7Cz6XvTM6Q96MVC0X30Qa0CSNXiCCV3lbtkuPHCXPFKOuUh2TTOYg2yL8hx8z0Tw6kPwYlb/rIEPZr/d0bb4m1X59IsuRbEDby9UvLvU6ZBtva/o/CyHJevO11zeJR7oJxmsMotvtU4pIY1NJ1aiM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 06:01:54PM -0700, Shakeel Butt wrote:
> On Fri, Apr 10, 2026 at 11:15:49AM +0100, Matt Fleming wrote:
> >  
> > @@ -4637,7 +4672,24 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
> >  			!__cpuset_zone_allowed(zone, gfp_mask))
> >  				continue;
> >  
> > -		available = reclaimable = zone_reclaimable_pages(zone);
> > +		/*
> > +		 * Only count reclaimable pages from an LRU type if reclaim
> > +		 * actually made headway on that type in the last cycle.
> > +		 * This prevents the allocator from looping endlessly on
> > +		 * account of a large pool of pages that reclaim cannot make
> > +		 * progress on, e.g. anonymous pages when the only swap is
> > +		 * RAM-backed (zram).
> > +		 */
> > +		reclaimable = 0;
> > +		reclaimable_file = zone_reclaimable_file_pages(zone);
> > +		reclaimable_anon = zone_reclaimable_anon_pages(zone);
> 
> Here we are getting the current reclaimable pages.
> 
> > +
> > +		if (reclaim_progress_sufficient(progress->nr_file, reclaimable_file))
> > +			reclaimable += reclaimable_file;
> > +		if (reclaim_progress_sufficient(progress->nr_anon, reclaimable_anon))
> > +			reclaimable += reclaimable_anon;
> 
> And here we are comparing the current reclaimable pages with last iteration. Is
> this intentional to keep things simple?
 
Yep, that was the intent.

> > +
> > +		available = reclaimable;
> >  		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
> >  
> 
> Another heuristic we can play with is to also pass through the vmscan scan
> count. If for couple of consecutive iterations, we continue to see low reclaim
> efficiency, go for OOM. Also maybe compare the scan count with the watermark as
> I expect we don't see much difference scan count for consecutive reclaim
> iteration, so, it is a good representative of reclaimable memory.
> 
> The reclaim efficiency heuristic should handle the swap-on-zram or
> incomp-zswap-with-no-writeback. Treating scan count as proxy for reclaimable
> memory should handle the overcommitted memory.min case.
 
Nice. I'll take a look at this.


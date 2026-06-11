Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A560CD98D2
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 09:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 474976B0093; Thu, 11 Jun 2026 05:55:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44BFD6B0095; Thu, 11 Jun 2026 05:55:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 361FC6B0096; Thu, 11 Jun 2026 05:55:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 267976B0093
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 05:55:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5D6FD1C2373
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:55:50 +0000 (UTC)
X-FDA: 84867175260.16.1C1F29B
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6EE0B80003
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:55:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="G/nruvca";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781171748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tBvYm/s0hw58xWqKn+eEEcbOKzsibd728KGSv9bkZoY=;
	b=Us9MitoQTCF2MGu54kBQV0mzgc08Gmq1KxZ2SEt5Fd1a60+yiXZfTCP9C7ncj/iS2RMyhc
	ujULx24zbTTxIm4JNnCgIpiJQQfsJFYkZ11xfIEF1Zcc4GqvH4dMmoV5+O1v5ve1f0Uy+G
	NcPsJm2HhyNwBwdbwMcGu4uARAfcmsE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="G/nruvca";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781171748;
	b=mCU+Dh/UjbFCjDmUIyLXT3JQ1Y+x3sWmM43rSzCUP0PW5eAKx2CbCRpB4Aa7Hwn4IkKm6m
	y3GamuUOrlMilFrhRKq9ixE8CvnfZ7HGvzgmBzGlxy0XyJnt1w1zyOhw5UV8BM+gS8LkDI
	3zBARIdI4u+oEVsneslIqdbcrQ0P9fA=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-68c1630159bso8820281a12.2
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 02:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781171747; x=1781776547; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tBvYm/s0hw58xWqKn+eEEcbOKzsibd728KGSv9bkZoY=;
        b=G/nruvca+4mnSJcLQIvcuQFTsZZNWuIkwI2qHu0IXvNw2gndE+kwTwDIQFm4HM/kfY
         zGfhoq2qLG6OrEOkhzBSzjDfn5CvoFOLbVKN3xI1ek0aTNu7kHwiIqqKu9V2SOBi7D05
         IuDOEOQGiwibinfMcEi3mQqaHfMlSKVYk0GBxtY3lQL/tFz5+Id2I50Iaw+lLo0HBjAh
         rqOvwERRe1sWWeUsHBpyZIcR/J74RXbsjLXt5xktCTQ0AupnEBuC25KBkyBIKDSH87zV
         PVpjf1JBfyuEL5OBsFNTYil/Ffs7GIqrhxGX3FrvxLrW/9NGTB5yA/hrDrTf28WeJ+sp
         qmpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781171747; x=1781776547;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tBvYm/s0hw58xWqKn+eEEcbOKzsibd728KGSv9bkZoY=;
        b=LVk2IXrXuppw3HI8i7EXFX/TlzIBkdVwDW8r9bnIPxi7utyxWaqVz/HJmfcEJGHpsu
         DGDrNNgDCBRidKTFTb1a5gtK48NmxWj5aX9DJFS39JjkY9OwhXtAD4l9DQmHpEWMOUrX
         XIW0l4ZiEHp05sA8NYLtNpUq34wE0202GKaSNl01zI00i6Qzws4/d8LiBa5xVKZa/Gk4
         uQoWUFYaRQe2FUezgMMhhkqLo7iVdzZeekRKp/IbiNjDWSRJxji3vpBf9IjW9Q0yoJ+o
         bl1valJ9APRWSk6FHhVAhzkHHo3CH2eFuwD7mgqobaskdcxXp40pyVRLfiEt2HVCw3ka
         8TdQ==
X-Forwarded-Encrypted: i=1; AFNElJ/K66qsPJTkICJjrlF3jIdkc1onV8gfWiLU1oIE5IFCgCWs0YQiAHDl8nkxcN3pSTyRtlRWYq7AeA==@kvack.org
X-Gm-Message-State: AOJu0YzKanDFd1ouatbdOoun4jZ5cCG+F2JysmFNpJLJPLQPiGAF/m+R
	81DQiINH47DAUpi3uyQXV9jfvNcM0+R7cUzgeFVX6Ke3RMvsMvH33Jzi
X-Gm-Gg: Acq92OF8WoJEzi2h/7w0t8bs3XOsU0Q92Gbf1IwnU56pM+nFAes85YRr63280o6RZPc
	yplmRIvyQI3Bn1eUwTOICEltSRAskL/9xkQYmGzm7q+SBKXDrjpK68Aj+QsSK5zFOkEa24QBfgY
	2bCsGi/HHqbrvex9HH0QkRN8T9LmkPUMwp+nxA/oD7jhdayF6P1nUIq/mVZI6SVxRvsp2u7dvIz
	kkJBT17h/lPi7OoTAxEcpSDaYsZNyuKSmDxH9iI7aMDQMfrIzdBMmWQBQKE0LaDDL3I13xEaU6V
	zZPh1wwHpEBBgbJ4WutciUWd9QIOSYnn7pJ9CALOgJKeOS4aQSMpVU/OTTyAuAfaSTpzVaJ9902
	nDGnF1SdUWcRxPhH1HEKckDFCsHvIz155HBKLqw/x/9rRzdhfqFSCn5QeoHd6v0Y7TQWEWmTslb
	WiLgKJIcxgyy9/9nE/Y4wu4+cU86HbPIelwug9qxpXWSnFLoebtDxzVqofuZ5/Crk0nGA1qfAmS
	OBLXdMkoyF0SKlLzYmou+4R4O5qAdQPYMP5NnHBqC1gDQ==
X-Received: by 2002:a05:6402:358c:b0:691:b5aa:5a6f with SMTP id 4fb4d7f45d1cf-6930e29a9fbmr821311a12.12.1781171746570;
        Thu, 11 Jun 2026 02:55:46 -0700 (PDT)
Received: from localhost (pat-125-253.wlan.net.ed.ac.uk. [192.41.125.253])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68e65c542c7sm11230916a12.31.2026.06.11.02.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 02:55:46 -0700 (PDT)
Date: Thu, 11 Jun 2026 10:55:37 +0100
From: Karim Manaouil <kmanaouil.dev@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: "Garg, Shivank" <shivankg@amd.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	akpm@linux-foundation.org, kinseyho@google.com, weixugc@google.com,
	ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
	willy@infradead.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	dave@stgolabs.net, Jonathan.Cameron@huawei.com, rkodsara@amd.com,
	vkoul@kernel.org, bharata@amd.com, sj@kernel.org,
	xuezhengchu@huawei.com, yiannis@zptcorp.com, dave.hansen@intel.com,
	hannes@cmpxchg.org, jhubbard@nvidia.com, peterx@redhat.com,
	riel@surriel.com, shakeel.butt@linux.dev, stalexan@redhat.com,
	tj@kernel.org, nifan.cxl@gmail.com, jic23@kernel.org,
	aneesh.kumar@kernel.org, nathan.lynch@amd.com, Frank.li@nxp.com,
	djbw@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/7] mm/migrate: add copy offload registration
 infrastructure
Message-ID: <20260611095537.cyljpqekjbjc5jqw@wrangler>
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-12-shivankg@amd.com>
 <9145ae5b-a33e-4092-8cb5-efa18ae61287@kernel.org>
 <70ee3800-0469-4c3d-8a1c-bb6594c64f42@amd.com>
 <f35bc7f9-c75f-e6d1-df3a-d536047e9461@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f35bc7f9-c75f-e6d1-df3a-d536047e9461@google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6EE0B80003
X-Stat-Signature: 3cn73jgnp8tmcbnkfh6srxjrojctotka
X-Rspam-User: 
X-HE-Tag: 1781171748-889589
X-HE-Meta: U2FsdGVkX18uEHzvPvHwzIz4t5qCfsJiYik93gJ3CdeE/b54zrvGuWH5/jdn1uIr3UOA0eOpVqJooUcSFWPeHGlRQEr28ATeTHvVjwTogcLPrz2+6UA9P3ZceiIQa/jozTFGLVE296TUl5NPsXTmeU8mLoq+AM7plRHBtKf9+tJ2cbibBSXCyMexOjvmtQju0FR/hDb9/a/RYl9RrPobnR1lRLcNEk+kBM242iD/Cd+kEF6Hp3Vm52h0okg7mguo/DNnI6W5Zw2CZdxI0NoumWad7n2V3kb8rygzZiujDa/ChxY/6t5Axft1iv9BlQjSDUK2oSE7GDjSZmhbQIzBVuyhbG34bUvkFhSoQaajclGUfXTBtA37uG+cmIl01W4I7gdr8PNkKB3faby4qPfjWAdZax5bzdqm8lZweGhxqakrhGN1+6DjCzp0Ul5fxdgKZ1l1igUYD1q5WQ35iBFHwPfb5R3E4SAx1cclbgTJrxeik16TV4i8rcBWygKW87fANDx6rOzSuqjKu7f9psn59pldsAeUssLTa6CVygXeC/ewp1Eo/RmuuNpco6TLe/Kl8TS0dAOGOpXYPhcQjX4ANf/tMByLxvkrEjM/Fll2HyXnvpQ5GGw0XDvSp4Wd6ropXwtrVKGnGw723WRzsdeatIoDF5sySaYbLHwgxT+QckNncpfEfJ7ero9gKw1u7cIA1Nhqp4tY6cnvZ/A9so8kL+sogxtJR/h+wDJnXz2FFHQ9nnLpxwnn75d7/QRFvwoJt7oqqOdmyDhVkeaRbH1Gw5zw3RefmwJxp1KiWkJl8zpkAquO2bJmPZ0CxpMh61uaF1w66A+04N8/1jG305UGfPX3+6/gWJFgp8IKU29BhDxAQonCajWJPRpnSYEswos3Xr/AZXPr9g6O/3qrfUNAxSkL+hOBYs0NwDVHoGpA/UT1uVQyY+pBio/vrYZ4EfhCrEGtQeF1SgDlg17K5f8
 rSKFbG33
 TaHSDIWNdGqyUM1qW6ipMkHKqlB1ifLdq22qT7KyTgovRQIrM42m3gjTv0yqTnVhnGav2t4FJAqFc/irxl74TJLtrVk/Oatj80XTn9VRObKL++zd4iBhV0+Z4bZYsu8qVbJ/6RerRGdMwCQr6ViJkFVU8Qscr1OziQCLDw1JjX3DMNa7Amzq20cU53BemRl3WrMCs1s60ytg4TBOpwJTnj7DftVFX6ByQhms+DK7scGkD9WF6nJN2NbcKI52PxUs1wWy8+OEknhJEj6cSXx2WAvcNsFglbHneJ9T65lv3/APYqlnXxXLrqL2xfdKMm1WdWttHyT4IiOUk7ni821onRLeTQsMB30UMRiZ8VbjYKTwyht+wb6gW8Oxvhg9DCGTTujS4uKKoTLq/fVzYJXWxogEx7J3PRm0ME607P535cUjmofrXJw+dEflskUz6BbawTL8jnJWw3PJoUd6urFgRJNq+c8Q/133W6u4LcyUFhYvkTTnPmumybr0MemHZF36ngEusFsI7V1UNctZLAXhNZZ72XXDSVMilGyrk0nXmnzueQZ0q/0Lzv8cL1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 24, 2026 at 07:16:55PM -0700, David Rientjes wrote:
> On Wed, 20 May 2026, Garg, Shivank wrote:
> 
> > >> +static bool migrate_offload_do_batch(int reason)
> > >> +{
> > >> +	if (!static_branch_unlikely(&migrate_offload_enabled))
> > >> +		return false;
> > >> +
> > >> +	switch (reason) {
> > >> +	case MR_COMPACTION:
> > >> +	case MR_SYSCALL:
> > >> +	case MR_DEMOTION:
> > >> +	case MR_NUMA_MISPLACED:
> > >> +		return true;
> > >> +	default:
> > >> +		return false;
> > > 
> > > 
> > > What's the exact reason we don't do this for hotunplug etc? IOW, why do we make
> > > this depend on a reason?
> > 
> > Reason-based filtering could be a requirement for some users who want only specific
> > use cases to go through DMA offload.
> > 
> 
> +1, I think this makes a lot of sense; not all DMA offloads are created 
> equally and we may prefer to unburden them from being contended by 
> migrations that they are not intending to accelerate.
> 
> > For the RFC, I introduced a placeholder to enable further discussion on which use cases
> > should allow migration offload and whether offload users actually need this control?
> > 
> > Your other point also makes sense: "If someone migrates a handful of folios, latency is
> > likely more important (and batching less beneficial)."
> > Based on this, we could either fully rely on batch size. I'll think more about this.
> > 
> 
> There are, or will be, some offloads that must be used for certain types 
> of page migrations, like Confidential Computing.  That's for functional 
> reasons, not a heuristic.
> 
> We want to use certain hardware assists solely for promotion and demotion 
> of memory for tiering.  We certainly wouldn't want those hardware assists 
> to be inundated by users doing tons of move_pages(2) on their own or by 
> best effort memory compaction in the kernel.

One of the biggest arguments against using memory-offload accelerators for
generic page migration is that user-mapped memory migration is dominated
by rmap (unmapping before migration) and remove_migration_ptes() after
memory copy. In my experiments with Intel DSA on Sapphire Rapid,
assuming you're copying 4KiB pages at a deep queue depth (64/128 pages).

	1. A single instance can achieve up to 30GB/s when counting
	   only descriptor submission and polling for completion.

	2. With DMA mapping overhead, which you usually have to do when you
	   are behind an IOMMU, it's about 23GB/s in IOMMU passthrough mode,
	   and 17GB/s in translated mode. That's still more than double the
	   throughput achieved by a single CPU core at around 9GB/s.

	3. The throughput drops significantly when measuring the
	    completetion of the entire migrate_pages() at barely 1GB/s.

Unmapping is about 50% of the total time and remove_migration_ptes() is
about 40/45% in my experiments, which leaves only 5/10% on the table for
the actual page data copy. You're not bottlenecked by memory bandwidth
to justify using a memory-offload accelerators and the CPU cycles you
save from offloading is too small to matter.

So any discussion on accelerating promotion/demotion using these
accelerators is useless to me, unless I am missing something.

Like what kind of use cases do you have in mind? What kind of workloads
and pages you're thinking? Especially, via migrate_pages() which is
largely involved in scenarios involving user-mapped memory (anonymous and
file pages) and thus heavy rmap involvment.

> I think the use cases should be configurable by the user if at all 
> possible so we can control what has access to being offloaded.  These are 
> often shared system resources and can be contended like any other 
> resource, so configuring which migrations can use them vs not use them 
> seems important.

-- 
~karim


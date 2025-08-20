Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 418B0CA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 23:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA1838E0040; Wed, 20 Aug 2025 19:15:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B790B8E0031; Wed, 20 Aug 2025 19:15:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A67D48E0040; Wed, 20 Aug 2025 19:15:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8F0678E0031
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 19:15:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 06087114B3C
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 23:15:12 +0000 (UTC)
X-FDA: 83798693664.30.D4780F9
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id 199121C0006
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 23:15:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Akj0hnyP;
	spf=pass (imf20.hostedemail.com: domain of klarasmodin@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755731710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UV6v+hA7ETw4OnW1K7B2JjLnbGY2L5npfHyuCaE7NdM=;
	b=ku6YKEoUDwksyTgtkmJhmY0M8LS+i4hd4TsdcbV4m7EvOB8sHRYHovdNLi+5/FkIyVu3cV
	0ewgyuGIJwbc3rEFHrj2EpPVeMXH5is7QQV1Rg0AB1Q9nUPx1lhjeY9Nwyu5XHVlnw1jwr
	6+YvVCrk7Xm2JocodoInjrDN8Q5sbiw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755731710; a=rsa-sha256;
	cv=none;
	b=jUPqPe7oBqFgQZpNtMbZqnltT0dsX7UB68G/O2sxHmN1Ow14AaedLq0LNQtubsd863T+hT
	sYvWLiW3bqSTUNPsZioJhS+CK+xjTeojmVFOUcigfT8FOPgzBM/ZZTHFY6qwbrCVK4cqhR
	RYc0vjksjm3xK5XRdUzRLTg5T3yqSb8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Akj0hnyP;
	spf=pass (imf20.hostedemail.com: domain of klarasmodin@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-afcb7ae6ed0so56198966b.3
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 16:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755731708; x=1756336508; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UV6v+hA7ETw4OnW1K7B2JjLnbGY2L5npfHyuCaE7NdM=;
        b=Akj0hnyPMqkS+bUA744d6Uiq3W8bWJ3smrtmM2+NcAK8PP6PgIgK3lRNvk623TrKxO
         E5H2PIiI/bhEgc5zPqnzqeeH3oqAtsE1UPDXv57ddI2ukq9UMOP+NjpLuFz5hvWucQg3
         N/rbK590qXmAVuVw6UGChWmwyKOmwXwUcCfAgGIcD3sOMMELy7C4E6e9Mk3k2DnuDg/j
         UM4tsxO7+KhGA/QLCH317CfXYKEE+kDtzBYw3ZrFnG5ekRWuT0bQ/UxD/FgT3kEdboEs
         rVzqU6IHJPvwuiaFPpLwV32Q5XTiK/WeMM0mG/9Cpc5qkT8YssLiVXsByP5qNFUteOzO
         TR3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755731708; x=1756336508;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UV6v+hA7ETw4OnW1K7B2JjLnbGY2L5npfHyuCaE7NdM=;
        b=jOQ6lYVtiouIRnK/rNI39D5WroeRKwhRoxqIOVCX/tCZDnxX5KL4tU/CaowTaCkPJr
         /Bvlj0dyHdr7SGsV44WHbqAEPO+8sbwEsF6iafB40dncZmsa9zef2jY1FnAqT8wv0fy1
         zn7cFzRjRMD+Dn5ySbDYNKVWTjzmz75lxzoTRnEPgMdz/xGXOP1bVv66M6x1nJ+1M2xl
         EFNtVnHy9q3UyMN3KhrGbsdyoxEat0QZ9IamCxAJ30Gr//M9nt4S2WmGKigx5+a8UoRY
         yWyAYhfeIgCcyxluKcynk+NdjOnzpRFvg4hRdMHKVNCJ9bWYvG91WbhYR9VzU3diykmE
         R8Aw==
X-Forwarded-Encrypted: i=1; AJvYcCUzrSdtn+T6u0tGymQBmF4A3Xo+tcoz7FK18/sv9Nk5ZY+8dEj40J+dEQwH2KXVPDkdLeAPhRLCXw==@kvack.org
X-Gm-Message-State: AOJu0Yx814CMWbBiTF6DfIiYIYwBacCuXp8Dummot6uMdAkfwkX52Gqe
	G7Ed6G1EVb9LXX5ojdnnqJjtqXjusMsHlimfXdRlxpTvc/3hTCvNrf3I
X-Gm-Gg: ASbGncup3M64HfrvNg7YFYxFGBoyWEABUiciwAHw2B/CNvZXSxNAvFbXbnH4s4GYcpR
	qszCUe3s4nZkB8JMn/97gXo2/LRMkYchfvumyl3EUbsH51IdE5S6ZpWZ6/MoeFgQYU2hMW6Lzth
	+BgTaDFwxvSfLVNZRnIlAlNloL1+rmlGfeaHNLhT5YuxRi96EtVfuR+nUrQ7g86h+3U6WQ1JjDg
	2m30GIScv9fULzrRMI4zNmV9FTh7b4NAp8EcKoa/6LVo6qN5TXNebhB4EgZ6GVyzLgMs8mpvxqa
	AiAQXnTk0mgXkwgKxMJtEZ+uIO94fSxgQ82YQVE+K39KPCuMdVGvKJuqT4b4E5Rr/+6BJLhx0by
	BGp/nOs0qMirIWIRlNjXKx/iEdGQ0taNyYhEyGNek/wIQDLY=
X-Google-Smtp-Source: AGHT+IE95DMlWsMOOkaL7V1fyRiNQ52ythYky+7mNXcwgfPGGRtcFwV9dSv+UJfeXogBRMwgzQmgbw==
X-Received: by 2002:a17:907:7254:b0:af9:116c:61cf with SMTP id a640c23a62f3a-afe07d40350mr43722066b.43.1755731708104;
        Wed, 20 Aug 2025 16:15:08 -0700 (PDT)
Received: from localhost (soda.int.kasm.eu. [2001:678:a5c:1202:4fb5:f16a:579c:6dcb])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-afded478b13sm272533766b.71.2025.08.20.16.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 16:15:07 -0700 (PDT)
Date: Thu, 21 Aug 2025 01:15:06 +0200
From: Klara Modin <klarasmodin@gmail.com>
To: Boris Burkov <boris@bur.io>
Cc: akpm@linux-foundation.org, linux-btrfs@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, kernel-team@fb.com, 
	shakeel.butt@linux.dev, wqu@suse.com, willy@infradead.org, mhocko@kernel.org, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, hannes@cmpxchg.org
Subject: Re: [PATCH v3 1/4] mm/filemap: add AS_UNCHARGED
Message-ID: <rhnvd3ohg3hludr4auyhezfiut3qdbdzxdfggpzehtmojxsym2@kfczkgovrtg3>
References: <cover.1755562487.git.boris@bur.io>
 <43fed53d45910cd4fa7a71d2e92913e53eb28774.1755562487.git.boris@bur.io>
 <hbdekl37pkdsvdvzgsz5prg5nlmyr67zrkqgucq3gdtepqjilh@ovc6untybhbg>
 <20250820225222.GA4100662@zen.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820225222.GA4100662@zen.localdomain>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 199121C0006
X-Stat-Signature: nci6cirjfe8bt1g37ciwnf4rez6hrc9y
X-HE-Tag: 1755731709-752868
X-HE-Meta: U2FsdGVkX19EoFekMShg0/2MIRCqoScJaBHVKqW85eYun+cCv2XyCv1ErrgvhvAEKWHXU0/Dy2emy/h/hep1HbGGqf+Jg34m6WiC2LfT3PwCsH0IdWZ89yhX1sqgSkLZBZTqY5ka4SAUykOnD8zsqq8NZki78/nzrLgjtX5csIm5R7i2QOu118plytgFDfj9Hha3ZMxq/sLi0amoruMVIfhm6b9GM9CvoOpBJmUjLOLaC0+UiczZpowje6J200+vPKU6opvTRihcBwP3zeQJJj0qD4xr1mkC1i8+BaqikEs5+qfBQSNB11ctEmg5/DqrkedDKQsrxtvyaZVJYHVByj/bnfU7FPOe5YzP7RmsPAFHhPUHw+hbPFWvV8+MBT4WImxClVYq05R0SuDuKSSABbWCziQt4YiqKi/tbYW/2WyV0zOal7yER/7A8QIdav3sRY+6TNc+84jkZ/t4qeKc2uRmnvDYGNlG2XzgklSBIqkcSiJy5yBFe5u5i+BVANOVCsW/IFMI1NUb09RcaDt6wwLzfDJhyTu6nZHt4alSQTDYbD4ClfVHnIvv+v1xMQWknatklny2qLPHsAm52y95sVpLUk7bC3i0VX5gxT7g+uVI0VDXV25Eq3fcxQCGVCPtnbciwuZzyBp/C/U1qrl5h/JbaHo93fchqE6wziSSzDEwZ4hboInds/nLK+Q2BPTvCoI1crKMvtK9Ys87Qt2rGsnUDCdcQ5DCFGuKof3bEVpOH0w8NB0QfV4EyYdhug6VbMBETpQ0JXY+cymkTQXi2Ov2tGhm/3cpDVp1zDfrE+24x30vtLl9t2VYLB4Doh2WJfn0HKWA0Y8QqR/pzY2sGUWmiJ0ueacSc/k6ZsNWNMImHvBRgVUC1Hm1BoCm0ZEoIj1Zkc+c0M01giMBpmwpAX+fjQE4pbtH+At7ml08Bg+t8/tYUCIlqWIvMWjFrpC9yc2Bo2jP/RqGxv2sVAm
 mCXSkdeN
 Uq8xBwYmzFxN5geDZGHXAK2EyYw3uWhB173nHWFE3VvUX8jS0wNVrn2+hAjH59t4/XuDMrGlbfvFtk/uHdInx7FlcTo2ceVECIrMHnuinuG/RP5tDoVpJBrCejZBAnpkNI/KyIfTOAqxd+XcNUDOQSaNrRxy7O+LfrQ3lgTdqesuTZV/goN1WDCt+FJuMbpaTbJ1N/55K5o31Ko/bCBycJWmo0L+BQ7GdXc5XGAtyO/q4j2z8KqS1CbADUlYKaIm/SuM9NYhrVxcCJNNZO7BV6IrW7UzLLU/ETGce3cnXGnHm/7ikbCmiO+eawVebHySISh8L7c9kczTot3Vv49oQxY+aAowGZte0sj01xmRSeX1v/k8J6Z8MY41fMjcJh4WYvlOnbDfvu+NaQsHisOssYiw9RYvnYNWzJVj7UELZzCxRq6SAOavN0JHK89g9zonQcssl8FWdjUh3dDYcpx7FHKp4RJXSklrVK60K0SJ1eVjopfhL0Idk9KO8BL2yatmus92+xREX2wwzniUJr80ysx6tbGA3bq62Z630H64AxbiBK3I7ymQ36R8EXzDGXDuPMq5+ycxSmtdvPplLvAT8xIoW6mlM66W1L7LyQg9/dxhgvPjrvxrSJ9PS+LoVlGXsxJfM957oWQnV6u2tciQbMD/hS+n2kWV7piNMQa7KQ0ZFLyY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 2025-08-20 15:52:22 -0700, Boris Burkov wrote:
> On Thu, Aug 21, 2025 at 12:06:42AM +0200, Klara Modin wrote:
> > Hi,
> > 
> > On 2025-08-18 17:36:53 -0700, Boris Burkov wrote:
> > > Btrfs currently tracks its metadata pages in the page cache, using a
> > > fake inode (fs_info->btree_inode) with offsets corresponding to where
> > > the metadata is stored in the filesystem's full logical address space.
> > > 
> > > A consequence of this is that when btrfs uses filemap_add_folio(), this
> > > usage is charged to the cgroup of whichever task happens to be running
> > > at the time. These folios don't belong to any particular user cgroup, so
> > > I don't think it makes much sense for them to be charged in that way.
> > > Some negative consequences as a result:
> > > - A task can be holding some important btrfs locks, then need to lookup
> > >   some metadata and go into reclaim, extending the duration it holds
> > >   that lock for, and unfairly pushing its own reclaim pain onto other
> > >   cgroups.
> > > - If that cgroup goes into reclaim, it might reclaim these folios a
> > >   different non-reclaiming cgroup might need soon. This is naturally
> > >   offset by LRU reclaim, but still.
> > > 
> > > A very similar proposal to use the root cgroup was previously made by
> > > Qu, where he eventually proposed the idea of setting it per
> > > address_space. This makes good sense for the btrfs use case, as the
> > > uncharged behavior should apply to all use of the address_space, not
> > > select allocations. I.e., if someone adds another filemap_add_folio()
> > > call using btrfs's btree_inode, we would almost certainly want the
> > > uncharged behavior.
> > > 
> > > Link: https://lore.kernel.org/linux-mm/b5fef5372ae454a7b6da4f2f75c427aeab6a07d6.1727498749.git.wqu@suse.com/
> > > Suggested-by: Qu Wenruo <wqu@suse.com>
> > > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > Tested-by: syzbot@syzkaller.appspotmail.com
> > > Signed-off-by: Boris Burkov <boris@bur.io>
> > 
> > I bisected the following null-dereference to 3f31e0d9912d ("btrfs: set
> > AS_UNCHARGED on the btree_inode") in mm-new but I believe it's a result of
> > this patch:
> > 

...

> > 
> > This means that not all folios will have a memcg attached also when
> > memcg is enabled. In lru_gen_eviction() mem_cgroup_id() is called
> > without a NULL check which then leads to the null-dereference.
> > 
> > The following diff resolves the issue for me:
> > 
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index fae105a9cb46..c70e789201fc 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -809,7 +809,7 @@ void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
> >  
> >  static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
> >  {
> > -	if (mem_cgroup_disabled())
> > +	if (mem_cgroup_disabled() || !memcg)
> >  		return 0;
> >  
> >  	return memcg->id.id;
> > 
> > However, it's mentioned in folio_memcg() that it can return NULL so this
> > might be an existing bug which this patch just makes more obvious.
> > 
> > There's also workingset_eviction() which instead gets the memcg from
> > lruvec. Doing that in lru_gen_eviction() also resolves the issue for me:
> > 
> > diff --git a/mm/workingset.c b/mm/workingset.c
> > index 68a76a91111f..e805eadf0ec7 100644
> > --- a/mm/workingset.c
> > +++ b/mm/workingset.c
> > @@ -243,6 +243,7 @@ static void *lru_gen_eviction(struct folio *folio)
> >  	int tier = lru_tier_from_refs(refs, workingset);
> >  	struct mem_cgroup *memcg = folio_memcg(folio);
> >  	struct pglist_data *pgdat = folio_pgdat(folio);
> > +	int memcgid;
> >  
> >  	BUILD_BUG_ON(LRU_GEN_WIDTH + LRU_REFS_WIDTH > BITS_PER_LONG - EVICTION_SHIFT);
> >  
> > @@ -254,7 +255,9 @@ static void *lru_gen_eviction(struct folio *folio)
> >  	hist = lru_hist_from_seq(min_seq);
> >  	atomic_long_add(delta, &lrugen->evicted[hist][type][tier]);
> >  
> > -	return pack_shadow(mem_cgroup_id(memcg), pgdat, token, workingset);
> > +	memcgid = mem_cgroup_id(lruvec_memcg(lruvec));
> > +
> > +	return pack_shadow(memcgid, pgdat, token, workingset);
> >  }
> >  
> >  /*
> > 
> > I don't really know what I'm doing here, though.
> 
> Me neither, clearly :)
> 
> Thanks so much for the report and fix! I fear there might be some other
> paths that try to get memcg from lruvec or folio or whatever without
> checking it. I feel like in this exact case, I would want to go to the
> first sign of trouble and fix it at lruvec_memcg(). But then who knows
> what else we've missed.
> 
> May I ask what you were running to trigger this? My fstests run (clearly
> not exercising enough interesting memory paths) did not hit it.
> 
> This does make me wonder if the superior approach to the original patch
> isn't just to go back to the very first thing Qu did and account these
> to the root cgroup rather than do the whole uncharged thing.
> 
> Boris
> 
> > 
> > Regards,
> > Klara Modin

For me it's easiest to trigger when cloning a large repository, e.g. the
kernel or gcc, with low-ish amount of RAM (maybe 1-4 GiB) so under memory
pressure. Also:

CONFIG_LRU_GEN=y
CONFIG_LRU_GEN_ENABLED=y


Shakeel:

I think I'll wait a little before submitting a patch to see if there are
any more comments.

Regards,
Klara Modin


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EAA9C44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 16:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A3656B010D; Thu, 16 Jul 2026 12:56:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 554516B010E; Thu, 16 Jul 2026 12:56:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 444B86B010F; Thu, 16 Jul 2026 12:56:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A1D36B010D
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:56:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 87EE6401CD
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 16:56:03 +0000 (UTC)
X-FDA: 84995242206.19.E784FA5
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf04.hostedemail.com (Postfix) with ESMTP id ADA1240008
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 16:56:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="tfe0dR/n";
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784220961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=08EQSxLVtNW+I2h2PWuzuRsz9aErjHxxHAiZ5/B9N7Y=;
	b=yYZ6pW3hov3cZN3EwuBWSbBoCbMyWPQZVTpsjsK19ZcXPCr5DY3DOYkzunSPPmCmZ0xuK5
	WyNvdm+LDTyciJItsevlDO9XS4rAYroEZcMWrNXkJkJzc3chEfRrD3q5GxGa6BctrMN0lB
	Wiq5XOX0wXUQ+aqDTnEIdJxls3TaolQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="tfe0dR/n";
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784220961;
	b=8KDEI2bPLYKMMdLWeMBZ14Ua4GFFBmjbWDEgwcAzLQT7Toj3CPM+j72us1KZsALtWo109P
	w2nG9DoC6XjmcL7dNdYECdHDe2KsD/cBlrLutcFeH92CWbZGAuofSgABpkLK2P+L2FK8/T
	KKHPmd5iQkWHEKnqZE8ucNOMiSlwNNQ=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92e5c92c389so382589185a.3
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 09:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784220961; x=1784825761; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=08EQSxLVtNW+I2h2PWuzuRsz9aErjHxxHAiZ5/B9N7Y=;
        b=tfe0dR/njQeNejsQIj9LA/HjRJ/NfnykhtLKvJh5Ttv/KwWR3W7sIeOhZxth5t4g9G
         c11HM7YOe2r1yhsuDml8OmljpJqj91YWxiAn/y0XuvysGV2V5y41AZs27YSB4VJ/pSCx
         V9Et/vhXNWw6iPAYLkk7KTVSWdyvJOfO/hYRcaScMYFd1iUcPMJh2yO8zMKjttUe+Hbm
         zwvwWUjUZFj7znY/u7M4ZsHxBAwMbWZklWb8Pocel4G17JGk+Wwi7tFRk/CuK432PQxe
         momnFDLI/GfMEmzbXAXvJrytIDDbE2OfBpYzXE4PP4xGBvPQLVyreQsSaBoqFf9azk3Z
         xSSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784220961; x=1784825761;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=08EQSxLVtNW+I2h2PWuzuRsz9aErjHxxHAiZ5/B9N7Y=;
        b=Ms1a5K3mmlKUU2pLn9N7viMWDGL0xozADKSVndxzHCh63+3jPsmWRM7+GjXn7ptRD1
         QHDjgY/LEo6ar4JkSmcviR8xWBT10Yiul0+QK1paZA5t4keaAIU4wNER3VD9qwCmTlkD
         lCpJTUDYQM0kPRDmsWXSZoRTKhFEpUKBzdcTA+rKq+j80PpWafKsQn9zoBb8CDbugQZT
         +PplQLBBJYJveBZ5S0Z5MZTtA80a8U4NEp6LLIbawS/v0O4pSrUEf3da19/tLxwMMVFR
         InV5SphOUcs1kWmzkvRgKoSm3hOR5glBHWk6Xw90+DLYrpHPFWRfL9jGqG2wv6EshOxL
         OGTg==
X-Forwarded-Encrypted: i=1; AHgh+RpsnpaVTmewNAqDA8sx0XGnmWLe5IAbHLCsC+8QADBXqcFNHobWtaQ9zrB7qRWUtFlk9X5ukNgUnQ==@kvack.org
X-Gm-Message-State: AOJu0YxQlJORIgv1frqOBU9THv5FFelBjO/hWYt1mi8k7Z0cNmJUtFYJ
	0WTzX+R13g/uecyXYan2xznF/S4d9zL7C1C6zYa89TuT3zBShuWkSpDtyhc7KHtLJd4=
X-Gm-Gg: AfdE7cm9jdjZ0JL336TwDIQGB3eqyax7UNYvp8sHXiEA0bp5FsnkoEMIzQ/yYW1nu+3
	XHJwTYPo0OMQL4WEiBoqQIxNodTMdy0PvI8MTwn/LGZNJkLj/15WZmSXlLbHX7iqHibaFfKWzuG
	9/TDlG/Ycc/ykU502nkNuOpSHPf9wNBd2fI1ISAfjnl9lRnhNSElXBIde+ZfEjeVqR5Q/tLW//w
	wyZl9d5/6/GRXJrN9P3N+ElEycAx3ttcGMtSIz2MYdvUUFbAIR8izcJ2y3Aun2CIvGf1L9oUMxj
	JFBSo8mK0QPkKvTj1tVKv95de2U9fDKDrwgNsiy8JykcVxr1r2KFFSB5EA8Dw40rODV3aXOdqig
	GHk8rdducNALZCuP6X3PN3KnukpV4527YvfjNZ1YboLeJSvNnFt+AXU/mQM8KfL8Ao0A/QX2y6N
	JKlbhNh0XVzqNpveA4cm2aFeqJNB5WB0a2Any43ZO3WSsVG5nxFdxtuFaM9A==
X-Received: by 2002:a05:620a:262a:b0:92e:6b16:6a09 with SMTP id af79cd13be357-93086be1fefmr1190451185a.49.1784220960589;
        Thu, 16 Jul 2026 09:56:00 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930759c63fbsm956033285a.22.2026.07.16.09.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 09:55:59 -0700 (PDT)
Date: Thu, 16 Jul 2026 12:55:55 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>, linux-mm@kvack.org, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Koutny <mkoutny@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Kaiyang Zhao <kaiyang2@cs.cmu.edu>, 
	David Rientjes <rientjes@google.com>, Yiannis Nikolakopoulos <yiannis@zptcorp.com>, 
	"Rao, Bharata Bhasker" <bharata@amd.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [RFC PATCH 0/9 v2] mm/memcontrol: Make memory cgroup limits
 tier-aware
Message-ID: <alkB4tnJxOLyVCi2@gourry-fedora-PF4VCD3F>
References: <20260423203445.2914963-1-joshua.hahnjy@gmail.com>
 <3ff8b23a-479d-46e8-b820-a23697587f01@kernel.org>
 <CAN+CAwPK4cW6k6LazZsbuvewswOwzM8VJgPvcg0jef7FwfF1qg@mail.gmail.com>
 <a8a0e540-414b-4174-a9f9-2c501fb46130@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8a0e540-414b-4174-a9f9-2c501fb46130@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ADA1240008
X-Stat-Signature: 9mmfy19mh3ohjfssa6yjjkzkh5g1ockt
X-HE-Tag: 1784220961-922167
X-HE-Meta: U2FsdGVkX1/yfUR0zArp0E+IwMGabMz7drHjtzcTOQk3MhNBu6jKjkFXqsmnANwfkLe0Cb9kmfhPTeWrC4Vd3zJAamU9k6B4DzvHX0V+LcmUUVzvm/mzTp2VFWjzZL6Na2NcfSm3LCddG+St8kV2mKIf/qhT0gx3xK49iA+DZacc+8KWZ+UJ7y4b5vMoGWJg59nvU6J2gpB35uDgIFEKobysWlQZ6nNnX8omerYozoHsmuaMygz2VROpuxSPt+QaYhQe2J/YAYBgeLbsnd6j/bc6sVmR8aHF5YQorTZsYzV0qho3cJNseBM3chtbQuoa/6vaGHafRVfoyPpxgLcGnS+9x0yiRvmuC2wvuJu+fAXAcAExAx0brjGqoDXt/2kAZPIoAULVW82UIiKbEDUHdawrFf9aARoYEUzT1O90lzWg8szvKyNunle0GLWtCDFw1r1ghow8D9TJFIYgxxg4BgqXcGSQ5r/uIu5MUVcZb3EzBGly7wFyX5mWuqSOIu2ofqOyzuBHbyp8PsguU80P6HgyXdN98QthVFSjhCSA0OtK5bwb1cBqq0zuXKU/UIAcUjEqipOTq89zVb5DYoGU8oPzH26JP1ACT2vLzRhzx1nH3Z3yLoCEfnAvLS/9aaw6o+01G0tLlkLycusmW4eUpvZSGGjwAwptBFlDi77Z3ovAWyb5tEo68fAUkXvJVTFp1Ig/M35Db82LgXnQ5Sktci9VeO2fgKzV2GN9JqcvmOop/NYn1ydTlW2jwRkbTkPNDumIUXgqBv7z2Mxr/EJHU+47VTS//mz1AQ5HRQY9qhDIg+Kflylk7ThwPdZ6Xu+eND9H3N41R3IazKz7SQ8OhvBcwbBGFvR+yPh0BBK3b5HncD1X49iimnG55l4UbjJ4wCfNUnIjBug34pnQdoJM2FzMgi70VyXI9Z564mzBsJvBHwosVDXc7G7qOxZ3H5ZzBp1/St7gW9xbVP9c6jX
 JBUAr/e1
 8P5r2J1wXn6DouvZRW1xbw6/g3OzuLTMssXJtA4OUrdWy3t8sgsDhWi0lGBi6zc+PcVRwI+veVg3SoF4WbOeORhNsCxN4SEuG9BInOtJaCV0dsi0mqTrsVJbaICHvLai6cVYmXFcQ966EOd9YE27lmkdT1HgHbepHUKYE65Zh8cRg7Vpz+bYn7236Hwe07wmkU4FDC6EpHB4lGMs9c6zEXhG1Wi4K9IZRKSoWXUaxlvjFPmPbwLiCJF40dZT1q3KZZNAqP1GzN4wCXAkAe2Q8r/+eN9NG8N8eLqJlKxQvum4n5Awa/jukTkKCvK/AONTR85Iq8/uzzaBxtajW/nyPxNoUamfY/8LIAXkI1qci3Cq2fxl0ane4sXE+8kC+NY6KnKFym9lUBubsNaD3qWooIMFgaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 03:11:30PM +0200, David Hildenbrand (Arm) wrote:
> > 
> > First, for the multi-numa-per-tier case, I think this is already pretty well
> > handled by my series. Once we realize that a memcg is consuming too much memory
> > from a tier, we trigger reclaim from that memcg via
> > try_to_free_mem_cgroup_pages,
> > which as far as I can tell already handles the multi-numa per memcg case.
> > Other than restricting the scan_control's nodemask to target the nodes
> > from that tier, I don't think there's anything else to be done.
> 
> I am not really sure about the "toptier" notion, in particular if your memory
> hierarchy is not static.
> 
> Imagine that you have only DRAM in your system. Then you hotplug some slow CXL
> memory. The you hotplug some HBM CXL memory.
> 
> The meanting of "toptier" changes, which is rather confusing to me.
> 

I think this is a naming problem.

Maybe we should start calling this "initiator tier" or something.
Maybe tier is even the wrong notion here, but it's the best we have.

But I agree "toptier" naming doesn't generalize to complex systems.

> > 
> > $ cat memory.tiered_max
> > tier_0 20971520
> > tier_1 31457280
> > ...
> 
> memcgs are currently not NUMA aware, so this could be one possible direction.
> 
> But is "tier" the right abstraction? I really don't know.
>

Really I think we're trying to classify 3 general pools of memory

- Precious:      HBM
- Preferred:     DRAM  (initiator preferred targets)
- Non-Preferred: CXL   (fallback and demotion targets)

HBM nodes are already weird in terms of fallback ordering, but ignoring
that for a moment.

Non-preferred "tiers" are slightly different than preferred "tiers".

Under normal operation (assume no mempolicy or cgroup weirdness):

1) Direct reclaim NEVER targets non-preferred tiers (kswapd only)
2) Promotion NEVER targets non-preferred tiers (promotion -> toptier)
3) Under total system pressure (direct reclaim on top tier), we swap
   directly from the preferred tier out to swap

So non-preferred tiers don't have the same reclaim behavior associated
with them.  In fact i'm pretty sure we could summarize non-preferred
tiers as being managed hyper-lazily in the current scheme.

(if there's space, have at it - otherwise you have to wait for kswapd).

In my head, I think what we mostly want is:
  - Precious      - controlled entry,  Private node?
  - Preferred     - semi-precious, fairness desired
  - Non-preferred - not precious, lazy managed, no fairness

Just some food for thought.  I've been poking at making non-preferred
tiers less lazily managed, and I'm just finding this results to massive
regressions.

~Gregory


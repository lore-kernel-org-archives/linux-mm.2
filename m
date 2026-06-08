Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40927CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 16:09:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A53786B0088; Mon,  8 Jun 2026 12:09:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2ADE6B008A; Mon,  8 Jun 2026 12:09:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 941076B008C; Mon,  8 Jun 2026 12:09:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 87E856B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:09:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 525A3C02E9
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:09:25 +0000 (UTC)
X-FDA: 84857230290.04.37DDCE3
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5CF45C0009
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:09:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=RVYiKz+0;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780934963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vod/HHC1D5DZqL91Z7CA35Tz9UyVxNBY16ghjiAxtAU=;
	b=p1aTCIzmWii1YYXcO5P/7HPSRlVtpOJncZV/YDxun/eYtLjTf/QRkaFIppkEN5ZgHUT2mO
	jr/jwibtgKUJb5QGCydTUxRBy+oB0PKJlS6LEmUkXAy2P7/5tSHAXxPD2gZwU1TgG6QtYH
	4dtr0MZv7KcYSP1gs7RMabBQXjrmjtY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=RVYiKz+0;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780934963;
	b=HWiyuO6ZwYW+3F68k0Jt1mFdjX4wtz8nzqqZURjEH5xkX1AaLuxZHT7gZcb9GFWCM0nCki
	zXGGuw7vTb0rKvJ5lpi8KhHuYhYNLYqNKH0A/ef3a3eiK8Qo2fq0KD6v1czsWrKIfarQwA
	dcpfN9YFm76LcJI5FR3mO3rt5U6Zjhs=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-91563abd6a9so205337785a.3
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 09:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780934962; x=1781539762; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vod/HHC1D5DZqL91Z7CA35Tz9UyVxNBY16ghjiAxtAU=;
        b=RVYiKz+0OSOIu4xLC0PENYDRXZUK8OEJWSrCOLF92MH+JOatwZSqg6URojWbN/PPRw
         3PwEyDBvCzX0UDyFu9uiyZJNxxZoG66oGfp6dbsQTVBbFaAzUPJG11+zEq9LnKHqOJTk
         m6ty/R+SYhJpduLeIyR16n33td4VbIye9PU3lWGOiUg5S6B6pL21K9NFHJe2pIURwAkD
         SfKhMzu2AGSf9eGITuzNdYm+pOnjRtW0i2Tmig6SkV7ZD7KrbuDO5JuG++gsoI0GynJ/
         1WiDgOENDGUT0FItxNDBPOh3Z8A7luTva39aBPqdrXG9/uS390HtfqDafZitrm31pSjn
         Xp3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780934962; x=1781539762;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vod/HHC1D5DZqL91Z7CA35Tz9UyVxNBY16ghjiAxtAU=;
        b=IudPx9nE6MXa49+5sYRVJkJsHGKIchtYzr9blieRdRl0bLcbX8TAgfY/tYuLMySt5h
         BQ/TtRXRJBn1hks6pE4fQ6NSGUfuAUq5oDNQzcA8axqa/Nc8HcVRLMjH1xdOuorwxzw3
         UqFEf4MW/lOu9+wEXt8znEp7MWpFLxk2KBhnsUcceGKEg34lAkG/Yc3YlJomSO3XZrBm
         1izlkVoYw/Yv09T03r2Vf3H9XAX/duXYCIAtextmrJjsusNng0jdJt72YctSst7tiq+U
         WcLEUNfWRrPWQ9xZp0cxbQ1EjsWwJVWwERwdKmk7LgG2Xotql4D+GxEgjGNfBFKHSoUI
         RcKw==
X-Forwarded-Encrypted: i=1; AFNElJ/hz+mNFPm69ZemYf4ilOLavUmwn2O6EFY/u7d29s08HzDk/wYLAkGExWyqeWlX3g6jgRBNtgi6WQ==@kvack.org
X-Gm-Message-State: AOJu0Yw56B+BWg8pAAXERjMWG5oYpj/LHTUYLGOhT2NIg4Xs0VPEYOpP
	m5JtQ0NP8/tt3k0H6UfZ4xt0TieBpc0CtP/uoL5/jk3F5D8fRM9Nv2O7L/7kIV2IdZM=
X-Gm-Gg: Acq92OGMVtkUyGxGF6ycScQlbe14G/NhkOB+fxWdbzPBrtjtZoT2vW7M+QioVYT6r7/
	VaI/l6qhz6yUW4jPHoHRLaDgEq2V6lP/5VjG5ErC90YP2qGY3OawYV7OVodvcFqbVHH+CFerCf8
	GgiZj9zFF4C0vODvuFJDYjt793MoTsBPLw9qKRE44OgDdMm/G132FfmbhR/+roEfHsc+ZRbHM9f
	B1r8eUdu624qAxWNGNhITNm3/nTPKhye/ABD/ParBVw2DktRBBhm9S1fMcAu+H5bE3wFyQU/gWg
	JoQnWLLOweQhaKb7qRil95+f2i6eZqOQAzVRncpfM4Ekjlxawp4jekBaLnB2kbmoSw4wgK5AtG4
	zmYeGyCiTrKlVDK6enWv+tsJ2lmwagDYaQ4mvECkgsdzQektw1bERB9CX8lDVot1gRmsCOUZWdX
	5LBt8Ic+D0LxyRcQfJ2tSuyim0ioQdRWYpUpxKobVPsFPUXANM5wAsueqOatKpCftKGV69X5xpR
	IK51Fk1bd8GvOHa3Q==
X-Received: by 2002:a05:620a:2a05:b0:915:8f08:5fa7 with SMTP id af79cd13be357-915a9db4f9amr2567293085a.52.1780934962358;
        Mon, 08 Jun 2026 09:09:22 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a22dbbesm1751766885a.13.2026.06.08.09.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 09:09:21 -0700 (PDT)
Date: Mon, 8 Jun 2026 12:09:19 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH v10 17/37] mm: page_reporting: skip redundant zeroing of
 host-zeroed reported pages
Message-ID: <aibpL3REDdQ8Vhys@gourry-fedora-PF4VCD3F>
References: <cover.1780906288.git.mst@redhat.com>
 <6a2f93e4447e55ada6ccf0f4d5c64e8d41a848d4.1780906288.git.mst@redhat.com>
 <aias_qh3wR-Xkf6T@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aias_qh3wR-Xkf6T@lucifer>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: xisep4jtn4dnb6kk4zcfudmonwdxfx5k
X-Rspamd-Queue-Id: 5CF45C0009
X-HE-Tag: 1780934963-19230
X-HE-Meta: U2FsdGVkX18rAa1Vcg+ot2r+/16SbrteuSL6UGoy9eHnIM0Zjk4jo3BVbRALUVc7J91xyYQhZ5ya3OccOOKGm04uq8r+S3TYdaPAznk9npzvhf30zvvkqcJYGqI6nBaZW9AvIYtFhMdsjNqi/m76rxkBUyhXOM8/vVT2DFPk9t7jJUpp1WuAakC4Wx4JlXRnqx04+U3VS5lnCEjecvTnMhi4e0hlrmawE43Hk0LA2QIiTXTQg+2dXVshKhnJ+bt+3ibi41CVr+K2+zAA/xg+pZjmZovsFwCdXwgDAijXw9Kc1wpDS1qzFWZRpHAg/h4SU5r7ds8iLVMeNYdbCWBDbxf9G/alQnuBPrsIRJZBivL7QRLyn+8dHYbcWf/N3mn9/nE4VMzW+JL0iRVu8uwUXCFe/MVcbGn15WdFIBJL5pZWoIdQdxfrm4XODr6suWvpsQd0WFIZKjZsm6JJIZM0zjVMtaCRTtnU6prd1VeUvqCIw54ZjJceN9IHSTbvks7yuHlS5ll0NULl5/fRKJrFIP2CiNKYriGaDRGqwON8i8z6/t1bb+uMDkVUIfucb9M7lsHlYF+yIoR4Cclgx/IoYqcG1Nn89gTYEVDhf2LesdKlm9Hdh7X5LljeM8S536i/7kyoIC1GNXBi/RsJU+voqiDpxXq3O49DFDB6BDpaD2HEdsFcWdB8cs4BQ+8/X2hv0G6oSmje3O4onAL8MBWuhHIKQFPkUnqgz7n6RgzP0AiYWraihA7uRSfOB3YVnRa1dmybqLMNt0cFu17bi6/XoyXcai2D86Y3QiWQgZ87336x4k+X9PsSmXDZ9icMUPKUEbQTf6/RcWIQ/2Jt+nsfFdqu6Y+SqKjED6BSqWnYF7k6f5KHziDmiSfJAbIQwL6MKHLL+Y8eTBwiB+q2C2QWUam6x+1ZZ260u889YXZP5X9f4IKsO9djjdJNQB/f0hm/ruSBEtDxVchCZ42rb7L
 a8t7+BtE
 k/ovlx635s1Zr1a6nePjmq+4MMuxJxigob7yNa5Sffo4jpt2d5pMkqohxyDAjOTfeGy7wKVAyjqyvsBBSQlX7UpbfFbcGRA7eloxED0n+4e/N7oqXZl1otm2TObLAYcMmJjdNIYWsfLQs0489RyBW00a49KdXXgOceIloT/6MnpzBhNm4/40Hi3fdjzj0TZf5J8KOPMBHZmLPzs/d23ofw2IVCx3G2tehLCLHAT1j4W1p4vtNUSETrtGq543IwUt5A4HE1eyKjKtCKDOBWujj+hjkRa+o1zWmmbnttO4/cBKOnOt1WOsmHXNu8e4qnIityjenuxVyf2Q96RdG93sCPb0kpIjRv8sNt6GVsXhr3H6YyXMTytWKfFLmnNb84Cae7Rc5Xbkk5PVKj+a+eSR1kRU7dt0YK6Wn34KuQO5dBbazerle17LENXlcpv9RuQIOVYr6ERP9K2uiO7mX8xpz4k/VuP1oAWTdcstw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 01:00:17PM +0100, Lorenzo Stoakes wrote:
> On Mon, Jun 08, 2026 at 04:37:48AM -0400, Michael S. Tsirkin wrote:
> >
> >  void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags,
> > -		     unsigned long user_addr);
> > +		     bool zeroed, unsigned long user_addr);
> 
> host_zeroed or something would be more appropriate no?
> 
> But in general do we need to propagate this around, can't we derive it from
> the page zeroed flag?
> 
> It's really confusing as to _which_ zeroing this refers to, it seems the
> only one relevant here is the VM host zeroing but that's completely
> non-obvious and now everybody using these functions with the extra param
> will simply have to happen to know this.
> 
> If we could find a way to avoid this propagation that'd be ideal.
> 
> Failing that, making it clear this is _only_ for vm host zeroing would be
> better, but then maybe we need to think about how we could encode this in
> some other way, e.g. passing alloc_context perhaps?
> 

This is unaddressed feedback from 3 version ago:

https://lore.kernel.org/linux-mm/agXYbcuQYooG74pb@gourry-fedora-PF4VCD3F/

We can infer all of this from snapshotted page flags and propogate those
around.  This is infinitely more useful than just a single flag being
pulled out into a boolean, and more extensible.

void
post_alloc_hook(struct page *page, usigned int order, gfp_t gfp_flags,
                uint64_t pg_alloc_flags, unsigned long user_addr);

		^^^ page_alloc.c internal falgs only

Once the allocator gets a page it wants to return, it can take a snapshot
of the flags at that point, and then doodle all over the flags as it
goes through the page setup prior to return (include the post hook).

Haven't seen a reason why this shouldn't be done this way.

~Gregory


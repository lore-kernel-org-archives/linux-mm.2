Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D12B606D251
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=RyRQg0yN
Received: by kanga.kvack.org (Postfix)
	id 9B9776B05B3; Mon,  2 Nov 2026 07:25:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9697F6B05B4; Mon,  2 Nov 2026 07:25:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 830ED6B05B6; Mon,  2 Nov 2026 07:25:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 53FFF6B05B3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:25:34 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D68ECA8B55
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:25:33 +0000 (UTC)
X-FDA: 85390099746.10.75F4946
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf12.hostedemail.com (Postfix) with ESMTP id D84A240003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:25:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RyRQg0yN;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793622332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l+OOSIpi3LwKea2AwltHwR3lhfsf+u1HzeM7nFR6cqc=;
	b=f99/vOw9npadUU25VSMs9BuchStbfhVGdsgHqAV90wpsMgTkDD197girdJqEKFF1ds2FtD
	ypXwu2FYOsdhsIr0u06g5X+ppbKOalgHpsMwjkWFNZorkEiuobhTca0EvFkGEVd60fTDox
	KECdNkqD3dSSyEFkNPoMgHeRndextIQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RyRQg0yN;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793622332;
	b=zGkeFZ3tNL1qc5ZYpWopzCd2RcdaL4Laq2LJ+TSvkpNJQJlZkaqczeGJsLqWZGaz8e1/O9
	2jwUA6By4nGdCVsAfGi+3Av457fiTIHr95HFY/N2RV3+jSt9Y1IgdlhIa2ThUasuwYSL6e
	qUlljQPIODTEzr2xtO/BVGBzbmvtNxU=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a35ac4475dso20300825e9.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 04:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793622330; x=1794227130; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=l+OOSIpi3LwKea2AwltHwR3lhfsf+u1HzeM7nFR6cqc=;
        b=RyRQg0yNrDLWFuodCt/Wh3LF9JT1zWlTcxhpusg0Zq9u8HaR6qyLNuneNl+pTAt5lF
         0z7ohGyX/3F9vXBMmJkm+hoG/tLKa1BwSX3jZHz9XTxZO8ncQbtcIjp3HCkAiomlM5ap
         5V5Uatx/tqosGT4De2M5w4i4EeyVRYaTP52BPhfJEWjpzEx9adWId/2mhvVs/kkgSwfd
         HpZhCKB2iJjhyL2+RZnxE9L8xThw1DAwl0714j97tBsxPV4O1/yTThtLEXXpf3z6+EcY
         IZcrVkTuLoXSRlXP73QRpnuZDIOgQ1yS9RgLdKTqzSYITxiWG8tHAvLpXeC/rMqA9PeX
         yVSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793622330; x=1794227130;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l+OOSIpi3LwKea2AwltHwR3lhfsf+u1HzeM7nFR6cqc=;
        b=o0GVpddI5z4KZ3bTzV98N5En5AK74/sngEek9yXnV8cxdyqiDhDcMiNSg+Lnn2vbWd
         wCcvdN56x/OC8aIQWArGuRH+iR0L9zR5UkVtY9G2v0M8QQ45UbmguoooxEMtC7gWtpGS
         A+JxF3Q2JqgVlvGUFxLZ6bmy1b595A4oxQvFnkUCm6AH2d3lG5pDyXGxxxkxA7xnduay
         7GtWrjASzrWWrNU9flJ1XJQnrVMTZM0zECoWiM5bxFSCphHp3XgTUAV5QAomhtQZgfQL
         ORlXoLOgF41RAObv0V7p8pB9RvUsuR0pwwVCGCsVMf2pWpcmubdgxYaMPsMnf69T35K8
         2WPQ==
X-Forwarded-Encrypted: i=1; AKwUvBx87RBPgd41BVI21qBWTB6b0mG1AtQE9Wt72JLfIaFNXSwNV/rvXUa5b4LeOnW8Nf7umyFn+fg71g==@kvack.org
X-Gm-Message-State: APuU4Z+5kOWGrcZVaAKOJQ8QGrrMXRXtPVrbXRzxYXY6PmMkeH713T2V
	Zy8E+hqMolPAHqWpA8PiF+Pl8yTrBg2TOee+lWrHDrPTk6jULc0aJ5RVQY0isjG/5Pw=
X-Gm-Gg: AYBFou3BIY0ceIhL1JEgzINJfbKXCCw1UDjRFvg39L/xxTVZHlbxANYoBpRHYSKoDFB
	z5OEAflk7XWp+eLVr8YLKV8EYq/LSID85mkrfbHzUyoMgsjlHH6pqJq8q5X026h+I6qNsH6jv2Z
	PdFiFf8kSX7V4R8W3OAvZ+9cvM3ihcpUNHtzx9YrkYkzp37gS7uOWIZdlf/7DOizD7iWDTJinOg
	pNYTdpzk60rbPaQBk/+GuEOghB8+bhYJCD0eIOdB++qZaZGlRIWFWlcKoWJMxmSgz7AvRMlhSCD
	6aVOBg2uqGF6tYsnaxpb1BKJ7Jt7yrMgOA1W8LgPhjUxrgj+AC2QFrnjrc7l9/uZpxmn9L13KKH
	3pZh7pI9wfHGZyP3393iGMMmzhuohE2UPuI0iCIXfI4OWunfIu3V2esu37CaFR1MbWebSQx/ESz
	6rLyghXTNW3jRdJ998XyIl5RE6lPHpcyPIohS1DxXkgvMmNJuLBa1B6mhhEOklA/EV1xXMoccSU
	S7JW4V3Fb/IpGy+kh1qASVlPbs0NiE4S7bBFAZyEXQKPnmB4Mb6c/dnh7H9z+aMIG/6ZGscaV2H
	d1K8vHvHpdF/Cv2OmmUZM6jNrHwmlHG78XJVMcvGC3AF/erPWB9lLqgk7yKx
X-Received: by 2002:a05:600c:3554:b0:4a1:f7f4:7cf2 with SMTP id 5b1f17b1804b1-4ac1737c474mr214634185e9.17.1793622330354;
        Mon, 02 Nov 2026 04:25:30 -0800 (PST)
Received: from localhost (109-81-32-81.rct.o2.cz. [109.81.32.81])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa820492cesm371193245e9.13.2026.11.02.04.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 04:25:29 -0800 (PST)
Date: Mon, 2 Nov 2026 13:25:28 +0100
From: Michal Hocko <mhocko@suse.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v7 0/5] mm/page_counter: move stock from mem_cgroup to
 page_counter
Message-ID: <auiBOBfRIiup8Aob@tiehlicka>
References: <at8XfoqWwe9HSL9y@tiehlicka>
 <20261026155937.1235453-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026155937.1235453-1-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D84A240003
X-Stat-Signature: uxuykau3t9ems68fnaobos6e9cotgqbu
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793622331-23699
X-HE-Meta: U2FsdGVkX1+bwHD/y4nGjD8biIWKWSX48Hr91R5at3Dx1Rry9JMblKD3Xc3ohUXzShqO+nOYxyatMNRMUCFEW0wk+zZ8h0peqYsuZkFfg5hn1NdNOWMPUA4DbjRU1D7RcMKafvVn9OQz/P/WMQpuXgLxnJpQ3dIWzskLuigqc1eZqoF+L5YoJkfb6DRUqJpjKbCmT+SjISIcYNmSoUbBXka0U2Q+GThxHmwrcNJThORUDUUFNHRSc0c+YbVfSJgytwbnV4p9zB27mcqOxPKgBL5SKmLWREx1+46XE7Gm77BSBR6JqxarfGzlh9oAW+lhaogakqmCFMRludxNo2Aj4P5Bbv2tHCR7rEyNp7eYP8LghMaqA5fdO4RJrtmT6E9aW7C9QkqHxo6tsYd/aMaUUx26DTC6Q/r1suHCenpoDZeJe4XEhZywIL9Bwf0MfIJWmysTim9ckJIAe8rwaFPQA8aWsCbU92KKGH7NK41lpIOr7vN2V9IOvnzdhqYgoE8yqob8K80JDEsb1E+OMbWGGP244+z6s+dTsnb4LOGBBGFbCuLomNQ/+Zb31kUTef52hStIFJJGcw32WYAwEWQBwHrP/bOO8sISzqAwLIpNxT7L8qbR0/koNSLibwvxLKyfa2k5Ek6Pt37ERQOo4FXB2E//M+YplYOLiorwAZtxMfudZWs2aRwExW+u22GEJdlGOoq1UZTUUTYLFlOtqaqLtRLU1swz1BcdVrektwoQZ9pjPn//o2mA6dX5cpMJJzsRkqCCfaNM59wMWWGh+8QwTIVDkrM4ybW9Ml5OzjHkAAY+3+h4/2nuBTxGaj8dumFs2XZr+9oUnh0f8nfpNd6rGWMkaUc9RYh5Bjw49h1a/XY10RuAVK5GgEQU1pzGVWL/LDhv2WWoelZH915LxG0cWG5uS3UTCQwP3W5EhB0I80MqG1CRY10BwJH7ujo1QEdL4aQ9bdK2eti3L/GpiNq
 UC/yyFtn
 HHoJ6eVG/1eQcYrgvuSzGOYTdxS+6A1+2KRzTGkEhk850Y+Uk+8mPXB81OOCfkabC+TXCkEImSiwbkCYhXhGGh+6S5KAAjdRQyN/fEERioInX97SzVJKXbyUaemdIoaoUVaZwgPNVO1GbCgOHexjd7BPiDks3Ci+9pRIbfqSfQMIM4lFQ0AO2ZI6w70R9HPsOW3fkIdP/JCzljv2ZoeK6n+Y/bjCKY2O9wCQbW+8u3+16HM7pYyx9M9LDm8B/vORiFukKcyZKgEvw5WhJv8ZfRLp7gvICah6lWHVb/NBBL0/Sh6lq/+DXzWWquDabC2o3VikfAFetRh+F6gC5r6yMeDP4QYTWrHk6lB0ZmJwEf0Qv/MJ0ihKWrt32rRW5uyqA4FqLIzu9X033bb2AK+ZStT9SYKR2aOyhjjYVm7jd803itHh0Hp8wqTGa5BwakZT5pCtL98A9jYUcl2uzxByhuUy1KsfkaVn8pCRXXqXn7V8Hsq6D537xTOmqr2Jmvrrgg6tr9n2PczhMDHlvOrOm2e73wSb53ePjcs5b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 26-10-26 08:59:37, Joshua Hahn wrote:
> On Mon, 26 Oct 2026 10:03:58 +0100 Michal Hocko <mhocko@suse.com> wrote:
> 
> > [Sorry for coming to this really late]
> 
> Hi Michal, no worries at all : -) Thanks for taking a look!
> 
> > On Wed 21-10-26 15:55:09, Joshua Hahn wrote:
> > > v6 --> v7
> > > =========
> > > - Preserve two cgroup v1 proprerties that previously followed implicitly
> > >   from sharing a stock:
> > >   - memory.usage_in_bytes <= memory.memsw.usage_in_bytes
> > >   - Reclaim does not swap when memory and memsw have equal limits.
> > > - Wordsmithing commit messages for 4/5 and 5/5 to document the
> > >   cgroupv1 divergence (bounded) between memory and memsw caused by
> > >   independent stock.
> > > 
> > > INTRODUCTION
> > > ============
> > > Memcg keeps a per-CPU stock of precharged pages so that small, frequent
> > > allocations do not walk the page_counter hierarchy every time.
> > > Today, the stock implementation is within memcontrol code, even though
> > > the operation it caches is a page_counter charge. This makes it
> > > difficult to add new page_counters to a memcg and preserve the fast
> > > path behavior.
> > > 
> > > This matters for future work like my tiered memcg limits series [1]
> > > which introduces multiple new page_counters to memcg. Without making
> > > stock a page_counter-level property, it means that every memcg charge
> > > now goes through multiple page_counter hierarchy walks, instead of
> > > being able to cache these charges.
> > > 
> > > To make future page_counters scalable and performant, move stock from
> > > mem_cgroup to page_counter so that each page_counter can opt into its
> > > own per-CPU cache of pre-charged pages.
> > 
> > What does it mean that each counter can opt into its own per-cpu
> > caching?
> 
> So right now for cgroupv2, there's kind of a 1-1 mapping between
> page_counter and memcg. I say "kind of" because there still is a
> page_counter for swap, but it takes a completely different charging
> path (i.e. not try_charge_memcg).
> 
> This means that currently stocking charge for memcg is equivalent to
> stocking charge for the memcg->memory page_counter.

correct

> However, one of the series that I'm currently working on [1] adds new
> page_counters to struct memcg to track the usage of memory
> per-memcg, per-tier. The goal is to (1) track how much memory of a
> cgroup lives on which tier, and (2) to limit the usage so that a single
> cgroup doesn't use up all the fast tier memory alone, and shares it
> fairly with all the other cgroups on the host.

Right. I guess you have layed down your motivation quite well in your
original cover letter.

> When adding a new per-tier page_counter to struct mem_cgroup that gets
> charged for every memcg_charge, I cannot use the stock fastpath since
> the stock does not distinguish where the memory resides. It would
> essentialy boil down to this pattern:
> 
> try_charge_memcg
>    \__ page_couner_try_charge(memcg->tier[0])
>    \__ consume_stock()
> 
> Where every path still has to do a hierarchy charge to the tier it's
> charging to, whereas this patch gets us:
> 
> try_charge_memcg
>    \__ page_counter_try_charge(memcg->tier[0])
>           \__ consume_stock(memcg->tier[0])
>    \__ page_countertry_charge(memcg->memory)
>           \__ consume_stock(memcg->memory)
> 
> So that we can avoid the hierarchy walk for most charges.
> 
> I'd be happy to submit a new cover letter which better explains this
> idea!

I guess I still do not understand what you mean by opting-in to the
caching. I believe you should focus less about what you plan to do and
rather explain what _this_ patchset achieves and how it works.
Also focus on describing why do we need to keep caches on all layers of
the hierarchy.

> > > We get an added benefit of simplifying try_charge_memcg(), which now
> > > has all the stock management handled transparently within the
> > > page_counter layer.
> > 
> > This is quite a large change and I believe it will be really benefitial
> > to have some high level design overview in the cover rather than trying to
> > chase it in respective patches.
> 
> Sounds good with me. I can add the call traces above which should
> explain my thought process a bit more. Hopefully the problem I am
> trying to solve is evident there.

I believe I follow where you are heading. I am not sure this is the
right path but that is a separate discussion. I would focus on whether
moving cache to the counter makes sense on its own (without that future
work) at this stage. Quite honestly I am still not convinced this move
is the right thing but I would like to fully understand the mechanics
first. Having discrepancies among different counters just sounds like a
potential source of future problems.

-- 
Michal Hocko
SUSE Labs


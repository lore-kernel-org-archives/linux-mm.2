Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B6A4CD8CAE
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 06:19:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E39386B0005; Tue,  9 Jun 2026 02:19:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E10906B0088; Tue,  9 Jun 2026 02:19:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D26C56B008A; Tue,  9 Jun 2026 02:19:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C26A46B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 02:19:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 196291A042E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:19:03 +0000 (UTC)
X-FDA: 84859371366.23.73AA268
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2AFE9160002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:19:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DnEOyoT2;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780985941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WyHS2mdLzaoQuFPek2z//fxHK8pVAjskPhevZrWWAyg=;
	b=mrBVw6pxpbMKepVob+Eu3c4NF9Q+ZJQ89LVQ/h4QZNalxjQEGfkrqAfdFQjMmIj5SYBKQx
	hyxrkjDC1LSI4H7N0eHukpMN2CJRH1HmT6ApMboC3gN7GnJRwfQNMtG5usZSlMh+ujK1dr
	/JWQQPVNRbYOytbmVilVaPQHX7MvKds=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DnEOyoT2;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780985941;
	b=7r3hv2KnloXqn8RaqxC0srbTnOz3afaMMpLgfmm3sOB84eYa9Mgyyjo8RbYZ+jBt6lrqjM
	AS/xysem00sZrg3spkTf3Plt78D3JjthwjEIj5UGS93DhlP30PmllKxKhyYzZCeNCWRAa+
	yRqVAXgX94jER2W6UOVy2icvcmvnq94=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-915d64fead9so166568485a.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 23:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780985940; x=1781590740; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WyHS2mdLzaoQuFPek2z//fxHK8pVAjskPhevZrWWAyg=;
        b=DnEOyoT2ZfyyZHe8cw52lN5yIgYr6FpIFu0tyuVMql7qBBRm4eZHZAwvTPV5CvEBH9
         iy2LGC8oqxjuerJNVJiZ2/vk+fdF4DJZLpw15JTr5krq02Uk3OFF30laJNoemnQoLCT6
         3RWJVsz+MD6V7+mg3ajDdJYm706W9dz8VYhZ3xwMvJx1IT3Onq684WIAokOkXvpgQ1TZ
         xc/yLLJ5g2RaPggfzrJWWZ8SDdnacqT5tWNhb9C5VTzLxlIOepc80Cl1JVDm/zBtulxF
         3uhwiXmJlDPSuS2+TULRJBzeEbCPVV+3orwE0ar7zfkjS7ay0jlMBmcodIGMLFGdSyoq
         52zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780985940; x=1781590740;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WyHS2mdLzaoQuFPek2z//fxHK8pVAjskPhevZrWWAyg=;
        b=nFlLN09YGQ6XMz/aFZHGK5IPlgCpFpCzLLSy+qiEK1eFa30PyuaSa4nHHakhNbANY6
         /PwHGlBsVJNg1AIY3QQuXZk8Pt4p0DhpV53yVCdBq4Jx6UE7iDyV2uAMjOQHGeAN/eC7
         f6SQvmgT/lrtw5DKD3d41vCHUIKGLzaH9jTXTrr6cbkG6hAXajj04tkaI1PIMNFEcJ1p
         sX3Afu61C02Xf+x7jeE14g+9loFc0PO9Z2PFF4ZseHBdZ9E8ODP6hTF7Je+Daih4jQad
         eSXEqcH/zpjr+Qs+3Sc5Xa8WNKU/+ZbY0btwEdFPuxrz38Z2jhE3J1qRM1ao+5TWBKdE
         figA==
X-Forwarded-Encrypted: i=1; AFNElJ/vFox+t3hKOEdl4tjqsFA+HIde6GkhGIO8VE2x8ASVUqJa5ZaI4ywxgMwkj9uJM4WAthXROpnFFg==@kvack.org
X-Gm-Message-State: AOJu0Yz/pw81PiUKRyIa0iVhnGxFRjmCeHiqq9nlmDqfi2mV5Dj6iryT
	jkKL4rexPPtMGkxrWbQ3d9ToC7EDWIHKuQAEVgs/ehL+8peyJMIZCD6BYKp6SW4WhS4=
X-Gm-Gg: Acq92OEveCblALZuchkxeJD3zF48ONBMqBFRq/pns/CT/TY3KHkiqGCd5OWacb9nYvV
	9Xx8QPGvxXx5y10tqmMk0hvonn0mlU8AS1Vr3GtkjswaDA1xqFX7l4/pNOYtI8JOQSLDiSjweuo
	ya2Jz4Kfv6YKM1VzVK5GK4dKFABbH3paCjWpPVtvm7tnY7hFfItMfyT7gKO0EcmcfsGIpz3iIpv
	6toEPSJ81iaBH/oEPzg4CauvxqAo/nfCoJIIXvq3zg/NXVpqH4uza3c9U6hp/G8FVvsTQMvudS3
	h3Ny7VklFBaMF3LAjR3MgAW+gowQZ6EWo/4aI1SU3qEhzfQSXykLceZM1SXTe425JoFGtoOYteP
	jEpyquclJWIhbXQCX9gQozopIaZkVyX9k69ZsFdOKefFCiVAzqkKhRdN2KrlJIBSrekP4CoHp4+
	4J0At0FvE1bsEIi5lzHX7iISaLVAqeUESTBAbgLSvkR/kQXt+3j1JRfLKGkhH5CHbHrMJqHFSNQ
	6NlLhT0TYKfsThzUw==
X-Received: by 2002:a05:620a:4511:b0:915:9931:3a3e with SMTP id af79cd13be357-915ad1c091bmr2206391685a.27.1780985940133;
        Mon, 08 Jun 2026 23:19:00 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a2465e7sm2045397885a.19.2026.06.08.23.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 23:18:59 -0700 (PDT)
Date: Tue, 9 Jun 2026 02:18:56 -0400
From: Gregory Price <gourry@gourry.net>
To: Matthew Wilcox <willy@infradead.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
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
Subject: Re: New design
Message-ID: <aiewUFBRyDNoAMGd@gourry-fedora-PF4VCD3F>
References: <cover.1780906288.git.mst@redhat.com>
 <aiePVsiV-w-IZ8A4@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiePVsiV-w-IZ8A4@casper.infradead.org>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: q8yqtbmghqqjxddoa4d3fkq41kq5q6af
X-Rspamd-Queue-Id: 2AFE9160002
X-HE-Tag: 1780985940-885632
X-HE-Meta: U2FsdGVkX1+ca5p/pPsLZDczn05JT30k7LVCowhABMa44WuuIgvnyJkw/2bc1hT5XUTHrPz79C7MWF7AyMW1Kmh1R4jMIvyRVztmWFS1ZEwYp4iIxYCURlQb34t/xdiPmolQhbSRNEkoG5EtnGOdxASOn+vv7NL1OU3vtU93zKjktHy0V0HztYLNzuiwq9U2rEcfFC8F8VSBplRy5T66L8zV7iUcBLFsHTgFGC1UCtRFUM4vlVQU3MwXDt0DATUDUXTIGJPv6nW+UmXROUGcH88+KipFqEYL5NY5CbN/3Mat5oi8tqiWxTBbmrMltQL2wR0JMZoXXh08PzPHMFVHpy/lSXHFF56qWQRmtjms2jmxBvnDqhvFZS7QaZcYJrjWm5iXOkGSYTIo5KS92WTs80iv46ZmS/NcGlmvhtvVeZWN21053VwlvtP+XRKf0km7ArPavZXUOHo2YQZk6tonfZGql/jjiBrGHZFAUA92Vl1sHlDKeoqz/i2trlvhQ+a4D+dxGHzSF1t1YbZp6wpP9OwXgpi3fdMHAfMp5J498h4PqZ+aGjCMM5LsFpP1CBc904j/xQyhl+A/hhYvIOkpVucv1iE+RRPKFRiWtG8nbRgvo8GfXtm6+bcRyi/aH8ulsPon+kHo6y3TMkN7L14XURoKcoo8U6wpR+zhjE0oZDyN3dRvVlWQE+uzuugN+dGYwkO+GclsLxSRq1jR6zeliKx3pMQBojPcXwoTIwImsH/jqjamxcqj+Nhb9c9AU/md8pQ18MlHNqTomyAH2bwgAiedtcdq6CBVadDNY47XBaSAVrQynmO7/afZZhr6PQdK+pGBCeqEGt7TgZFGAALM+HnkTdgdTJDa6fVQqXB6zhwpAOFq9rJHFiXZ80Q76Qd0i6N1Gi073OrW2qpogcrnQsJIvC026RThGKHRL1N6PqiIJ/JpmvDS75ix86OjVgaNCVmaSeWl7HNIVJFr3AM
 kh9/6eX6
 sszdBa5S2NoOgqyWiMhySpZ8gLpuiSyZLQiqYGk10dfwKOZDshKrOvTD9LHCfNR+/PrtOkq6RjGoVe0jF6bIfAe5saDe1TCwDZjVZq+wHgjR9JTJSSUmse8tbBOMuSW6lQc9Ghmw1TNrpaUMOQ5bNquNWLgkR/AQoE5FPj6SR3I69JeUjVrH/s0QLY0zBdIpOtD7IRWz95PQuUUIvsUqM/s+jl2Fzt3qfRzrXaSD9uEnciSnVuBwR+UHbgPcAzqGHX/IA67Kz+lEIhXKTnMBYSIYw0LoiA/nCN1fxeMSi4aEuJHjXz2YaM+qbUrnWIMPMQlboBUOEq8MKaFzKhln1PGbcBOke4yLubRwtNMnbkBF+RMPF80PWliUnfnK1X0z2N+jiq6tM8rctAb7d43hvWnC4OkJ46awixQCmPEmaXxNOyFKIQfQhy1CbmmSi2rzvvXgK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 04:58:14AM +0100, Matthew Wilcox wrote:
> OK, here's how I'd structure this:
> 
> 1. Introduce PG_zeroed for buddy pages
> 2. Set it if init_on_free is set
> 3. Set it from balloon driver
> 
> https://lore.kernel.org/lkml/c7094de807c0e963526686e1d245bc76193b1a92.1776689093.git.mst@redhat.com/ 
> 
> but add FPI_ZEROED instead of an extra bool parameter.
> 
> 4. Introduce page_is_zeroed like this:
> 
> static inline bool page_is_zeroed(const struct page *page)
> {
>         /*
>          * lru.next has bit 2 set if the page is already zeroed.
>          * Callers may simply overwrite it once they no longer
> 	 * need to preserve that information.
>          */
>         return (unsigned long)page->lru.next & BIT(2);
> }
> 
> (you'll notice this is similar to page_is_pfmemalloc() but it doesn't
> need to be in mm.h)
> 
> This step is going to be a bit fiddly.  We weren't expecting to return
> multiple flags in page->lru.next, so clear_page_pfmemalloc() just sets
> page->lru.next to NULL.  So somewhere we need to make sure that
> page->lru.next is definitely NULL, and then allow both the zeroed and
> pfmemalloc flags to be set in it.
> 
> The important part of this is that it allows the zeroed flag to be
> returned from the page allocator without introducing pghint_t like you
> did in v2.
>

Are you suggesting leaking the flags out entirely, or just to the
boundaries of page_alloc.c (__alloc_frozen_pages_noproft and etc).

I assume the latter, but worth clarifying.

Otherwise this seems reasonable.

If we're just going to pile more stuff in lru.next you might as well
either add the alias to mm.h but keep the bits defined in page_alloc.c
to prevent them from escaping (even if they end up set, nothing outside
page_alloc.c knows what any of them mean).

Unless my read on this is mistaken, let me know if i've misunderstood
anything.

> 5. Now you can start skipping various zeroing steps higher in the call
> chain.
> 
> I understand David's disgust with vma_alloc_zeroed_movable_folio()
> but that is surely a separate cleanup and nothing to do with this
> patchset.


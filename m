Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEDD7606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 21:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CUHClqeC
Received: by kanga.kvack.org (Postfix)
	id 0123F6B00EF; Wed, 28 Oct 2026 17:26:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2C026B05B2; Wed, 28 Oct 2026 17:26:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E69606B05B3; Wed, 28 Oct 2026 17:26:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C0C746B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:26:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E825C1C24CE
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:26:53 +0000 (UTC)
X-FDA: 85373319906.04.52F2974
Received: from mta1.migadu.com (out-77.mta1.migadu.com [95.215.58.77])
	by imf03.hostedemail.com (Postfix) with ESMTP id B23AB2000A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:26:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CUHClqeC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.77 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793222812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/J9wEIeLE4ZJ7O0wWIXrxQmkBuEUQ1rOLWQcVC/fFww=;
	b=pxXIq1rXzYyM9rZ+GZCKjO9zuWtJ6gzblYFq7FGunV+u0lBh8sHXDZkl53Dfz8ZlGjI5eh
	vBdGKhG7I4320mjzj7vW6OwhyXM2NhxMpWv8UXg0E/C673zNZH538AmaZeNZgKTD8e/6VX
	jlE4AJjewKj9IQhkiW5HKaP4Owq7cmw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CUHClqeC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.77 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793222812;
	b=e+oeX937iEuEm0pxnoHr2u22/Ay2/uH1azTo7tKxYmlcYZIGXnSS5yqQyvLW5Q3DkCDaKZ
	kek/y/cMUwgDwQwXZ3oQTY8iZwqCguCQkuBBZRjwZ1a5G1sDG4VyMQKw5qDqwwH09DPFBe
	3W3CSFRYShlkYnlj699H7EK+i5BBWXI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=8F0gRoTDGoVFu8bo3a+K8rm9Kp6TB1BB/3NGjQEiZs0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793222808; v=1; x=1793827608;
 b=CUHClqeCl2ph+QIaksafxl5S7tzkKFduDKLeExLRvd+TF8/tkIChg9pDw/JPanybKhFT8QmX
 qOYoNvUN71OXWlKDZUq/OY4ayjvG5fkpmeIvbYiNLOeNvM8kS3GNG4YZXl7wfCAMV0onoJVoXF6
 3YqRVtK0Yd4QsLNWJzz9bQVU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id dbab2fe7e9187359;
	Wed, 28 Oct 2026 21:26:48 +0000
X-Mizu-Trace-ID: dbab2fe7e9187359
X-Migadu-Flow: FLOW_OUT
Date: Wed, 28 Oct 2026 14:26:47 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: roman.gushchin@linux.dev, muchun.song@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/vmscan: remove redundant !mem_cgroup_online()
 checks
Message-ID: <auJofiDEyRXOzcf5@linux.dev>
References: <20261028010611.3929937-1-tjmercier@google.com>
 <20261028010611.3929937-2-tjmercier@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028010611.3929937-2-tjmercier@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B23AB2000A
X-Stat-Signature: yk8hyqutd31m5u91tuihohxekhossbr3
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793222811-404800
X-HE-Meta: U2FsdGVkX1/0byWSihPggp0vFYDL7k9QgU0c8i1FPh8IUmNPzEFZ/Ge4RCcSPz567em9pVIzJmVSBrc1xqimGBeUZwIxcVJrE4MQRH9wEhHEyV0tPKzlrNCDZddnjGEYXHHKWcIdH4bCkY5A0x3YSiAL7H5kq4IyzdwcOW3Ka7vzP3JynGiC3mAyxAoIQnkHtCt0l8N+2lSXn0Me7ybwDjHYhnCTKdRPyqkXl3e52YHmXj9odjZQRGuGpbHsH66jl3reeOQIm6bBGFv8jrg+wQ7feeUYtehl/qXp/5kcsCsGDS0nT6QacRt9hKOEtmQBPehs1zZljqo0o2OZK/BCkLdx5O6vZcWCmk+iALmYBlZfYjAukEoEbiDUqxx0AKc3QI3p5PBxXb1uk8XHmgERh8rBDsmoRwMLFhZhJRulhWy/U/aOq4CpEWtRGGqms4vJXYEJk2u5kuDL5m6tWwpyZNCXyLgtaW+JmhWyUGuNGbfEQ5utM6wQIUr1Y4Ye1nIqwQUP+kxslXxtTqprAb+337XQUKAI7/AC7HMYayHnDLjnqR751jxKVRJF32FptLSSMGCZ9smwgeIH9zbBVEnqZGEaBseOFpsPtK1+gc/vIoagsIl42kO/3rL1ogvQyU2ucXzoOpqC5e9lMBdwNEzSpzhfq73ZW5huLzzP71521xYtiQRbXNRG4V+2YuhA3njwnbXRLXZr0RcfRS4oMoetYTfSPGgBMelMxCAw9N7cQhWWA+ssh28aHqb1F0mExvp5CejKWBKYJBPPWglDsImkr5yzVB6ui+VwBI+gaYQ9BvNBJGqL+cBwOgLeDOeEsKitpiO4e69PVouXlkpmpSjhfI+fEQK5RtKxs4MEkm0oLAfDHUgu5zcPV75mznD93n3JkmXl+8qDRJN9zdkODTjLYIW65TQ67UrVypnkKSCBHdtYyiA7FYaUvXYO+uc9ZRusQApQ960CtEoMR2ezVKl
 e60OluJ9
 v3lK6/SdEXEpiMl4It9LygM6FZOeK90Q8aWvbQ37O/MU6XYVrLiUYm4fsziO2m1X5+FQgjO3oAugGS+jsuaWQb4KfAd/+RtK5oeqQNtWQtmqSP356qepCB9h1GJTb3OBM9opW0h1hpuiAlPOAg1aZ1GMQE1n1tDvg/e13zXuQS/4tYU4u4gsebcxsThP6HmL62gU5Y6y9y8Y/8eb3Pz0UWzIl11DmuLYPPUYAVFq6NHcsj/DXna8IRYfI1a1yV9ylBsLtlTWiWXrYLTZyXvyne1+5g1fJzzKgFavj2xZxmlODFnY1AaKm6qq5Gt/67Q+PFbmJc1Z68fnRJM+dg2tanQzIZ8U7DR3ec6oFXe/iEEq0V99801q/4IrcWMzTcyaPNvfa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 06:06:05PM -0700, T.J. Mercier wrote:
> Since commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
> dying memory cgroup for LRU folios") and commit 0e0ac326c511 ("memcg:
> move LRU size accounting on reparenting instead of copying it"),
> mem_cgroup_css_offline() reparents all LRU folios to the parent memcg
> and zeroes the child's lrugen->nr_pages and lru_zone_size before the
> memcg is offlined. Nothing can repopulate the offlined memcg's lruvec
> afterwards. A folio that is off the LRU during reparenting looks up its
> lruvec through its objcg, which now points to the parent so it is put
> back on the parent's LRU.
> 
> As a result, lruvec_lru_size() and lruvec_evictable_size() are always 0
> when !mem_cgroup_online(memcg) is true, making the offlined memcg special
> cases in get_scan_count(), lruvec_is_sizable(), and shrink_one() dead
> code. Remove them.
> 
> With the get_nr_to_scan() special case removed, an offlined memcg that
> still has stale effective protection now has
> apply_proportional_protection() applied like get_scan_count() does, so
> the MGLRU and traditional LRU behavior is now the same.
> 
> Signed-off-by: T.J. Mercier <tjmercier@google.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


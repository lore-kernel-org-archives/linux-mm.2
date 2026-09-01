Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D65EEC624D0
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 18:34:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F25DF6B008C; Tue,  1 Sep 2026 14:34:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFDF36B0096; Tue,  1 Sep 2026 14:34:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E13ED6B00A3; Tue,  1 Sep 2026 14:34:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C1CEE6B008C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:34:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 50CE5160480
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:34:55 +0000 (UTC)
X-FDA: 85166044950.21.D4C1659
Received: from mta1.migadu.com (out-140.mta1.migadu.com [95.215.58.140])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3C66420002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:34:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ksBLc3Iw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.140 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788287693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bFvzdJ+vmOz3/LRA8hSn3Ym3XS5Gm7Jm1h2XNwZCvZ8=;
	b=zMtypUN0FZLub2P6pYkG4BM6IQEx4S0I1THaYcEAirz/gqXagbjdDrISaz7eI2b4IzvAbb
	71ZF55AWhFuK9WQxY1YC8WYD73sUxyMIPmy9yWu0w6WUjD0zbMYSwMhmkepy4S8qFMoM+W
	U0SrATYZ+Zwbqah74erCdz70PJaZMgk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ksBLc3Iw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.140 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788287693;
	b=77gjWzyGhLlnjR+qclu/r3Rxen7FrfpVkRMeJigS4ZZusj20I4JKeKJGXTPmWADaLMZcpI
	axB+PIdtqfVxqFzWkrgOM0JL7m3HcZQeUjle8XI/EUGdJeDHsnj+d7EEP7UdZW+zaepQKO
	5ltiTZYHZ1hCdhjxaaJN8BtoLTHZgAg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=i8KGEh8F0loJtG5JjmD9+5HBTb4SrwJLAbH39rt2vZY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788287691; v=1; x=1788892491;
 b=ksBLc3IwcOtRrtNbP4D3rgHZC0o6pEEunOy0nsQ9HMIyQ9rQ3CC9FDkiHRRqxSqdlYsbWuFq
 3EHPv/GUDNgYak34Kkt9N1O/4LAaz3ZM+iEC+udNNziWhEop+N1QIvpDNN20s5SK72tJDqa3oyK
 tuVFbs80JuBDPU1G6+XyNb0Y=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 031645a98e7cbdab;
	Tue, 01 Sep 2026 18:34:51 +0000
X-Mizu-Trace-ID: 031645a98e7cbdab
X-Migadu-Flow: FLOW_OUT
Date: Tue, 1 Sep 2026 11:34:50 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/6] mm/memcontrol: make lru_zone_size atomic and
 simplify sanity check
Message-ID: <apcalL6-QoWVVdhv@linux.dev>
References: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com>
 <20260831-mglru-flags-cleanup-v4-1-2d15dde0d7ee@tencent.com>
 <apZVe8UHZ1CNo4r1@linux.dev>
 <CAMgjq7D6V4eTZJ1Q1Xf2J6yTCq=JjvzT-W-HHX6EnMfzm3BK1g@mail.gmail.com>
 <apcJgcFLHKZfI40m@linux.dev>
 <CAMgjq7C=k_nzwiM_MTcjVjWMTGf=s8oRaUBY00dCvLbP4EiHnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMgjq7C=k_nzwiM_MTcjVjWMTGf=s8oRaUBY00dCvLbP4EiHnQ@mail.gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3C66420002
X-Stat-Signature: tjuqic1yzh43af1b4f8e3o4ru8ok5ptc
X-Rspam-User: 
X-HE-Tag: 1788287693-531359
X-HE-Meta: U2FsdGVkX189H7FpDj+KneUhgYzr0IXznvwWi/92tXw1BFUySr8nB2E8u8umcK0aFp4VQqDAQd+0NVWsufmPHDsjJodGm3MrEZcXxDKtf18hlkM626OLUg7624D3JbpeKgEEr0bqOWcm3+VT7kMqquQbV1Y8QRnK896drfHer7D32BbmjWdDtXSD53HBM61XhsaLL7yZtPF8+F6dUZh4c0UA3QjaiKHnL6XKMtO5Qvdxe5tZjrSd+po2OQy/PVQ2g5aqC+M8cKziLeSgnuuti9ln6sBs9+JC7xosdgX0v5f2JkIhA0dps9YY25R1y1Jg51mrwfQHqDy/WtfOyiFjYl4ey2vHhYcGyaEQ08jYHibyDpyZJoP1bgASNJF5m7dfkctqXVcJCSYRBNcRZsKlqf6LVFIZsKT+dy/hEDTzCz9ZYKn5YmAzGCdhw8SSJSIPktItO9l6QbtTWdgIwgzz1jb29/JB9F0NBkPHOr23TOPkfWgdTeGBaewP8xjhI2e5X6L5JD8yvHKU3MFl+o/fZ+k7y/kQNgRMILhIpmYQaF5gIDllWr818+wj/uZ9Wmyweq8/nSbZLuvR/b8f+Vnm3Hu7/P67aF0A33JcmVZI5WnK2VDCxcxgMVmUrLsX/4byZroY6Qmapkyvk2GkmLX85i8gOfRa6I2CRMioJJgcr2Kv/zHhgB28pQe8uriTYrw99bMHdoi8PRmAc1TFu4BzfGK5yooL5gI9V2yA2XQaDKQXfnmlApxbA0jhe87LfrEPCJ4BHT0IV5v56ed06VPdkkJQACHmn2q5QVcjtkuy5W0KPWoG53BfEUGnuef2rOlgcchhBQhm1mBXre+wzK3TGWJMnig4RJWYxiW0qmwreEWICox6Rjk6H0aWxEQ16BZTqjBk++Cu6tezltof7Mrxc6YA6KTr6aMxiTZD47YK7oGjx6/1/p5l+1eJ66Ntj2zZmUPUoV4aREQeJqQiMqe
 XLLUJOHj
 9Jt4Sxpne4XU6xkxkOXGjVk13KHlko0jbC/vOvTTc4zhP6EPRllTQ0Wgw8Dm5wi95UA4uZWs/j0M7wGrvGz27+3O4oF2RAfqZbh4Rt6RqEGzP1MZ1rhJ64/bByht+BGpucIVNeVaEu8TIC/ajDEO7AevcXLtz/d5k4uneiNxfXA6ZbUPAu4sHHIrIrXQ70xKsMQTAbWpV3BoF7VAK9+uogHLixb/9VjEkFY02oZWMf2VHQgxhBIXbVrs9p478QEz245OvP0oEEW9SVnIdJaMH9kfP2VYi+Nj2oLLWAoiHsOKvKqkFNv64005o3z9XvTOJXsa/yP0T5oO3L0AW02unUZEzj6ocfT4iS+FPaTA2ebanbcIZ2Xy9jeNvF+8eZQv8oQQ/NrGEaW+7cCU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 02:11:24AM +0800, Kairui Song wrote:
[...]
> >
> > Another question: why is this patch part of this series? Just some orthogonal
> > cleanups or are they related?
> >
> 
> These were all part of the MGLRU-FG prerequisite, so I sent them
> together. I can split it out.

Nah, this is fine, no need to split.


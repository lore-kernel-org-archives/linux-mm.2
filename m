Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADFC0C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 03:53:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 904306B0088; Tue, 15 Sep 2026 23:53:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B6A26B0093; Tue, 15 Sep 2026 23:53:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CBCB6B0095; Tue, 15 Sep 2026 23:53:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55A6E6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:53:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2AEFD1405FA
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 03:53:36 +0000 (UTC)
X-FDA: 85218256032.11.5BB95EF
Received: from mta0.migadu.com (out-14.mta0.migadu.com [91.218.175.14])
	by imf06.hostedemail.com (Postfix) with ESMTP id 06B0C18000B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 03:53:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iNoxY8Sx;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.14 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789530814;
	b=YKByILZp0chDhbsN0u+IA9de5nV6lfpVRO7jncTO1Bbxw7I8tc61Ni4D6lJriI0yCFu6w6
	g12djdHDqvtargP2q76ojochndEeerUsejHCVGYvCMfPqCwQLD+CHn6SpQ9h+4Tta+sqim
	mUpV8sO2pK1HhCeGrxmBVHxyl6+4lhU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iNoxY8Sx;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.14 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789530814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4OGRIcrkDvzG+2zg+zRHqicriRXDcKsyM3rbJmwsxz0=;
	b=dNY+ZqHMr+VqizMDBCsuX6LwPvnoSvXkjFp2U8Lnoh90rWfkYVGEVrvWJW/d4UqQZLeCbE
	NT9etyFRc6rQ0zMfjXvNK12luIRiO9iv9BHTLqCkGobuIt7vmWuhyxRpT8icASSMGPt/JL
	FyL84pO55scIaAGqWQdAQsYh/2HqSQU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=iD1Zr44c3eJx/67Yiq6Q4RmBQIq6pGG8QPAJW2oa024=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789530812; v=1; x=1790135612;
 b=iNoxY8SxpHy695fXnlSdZY6m3si2qLDQzkUoY4LsdXf+VN88/8n+kAvbC/0HgodAP7Nn1WT4
 SznAK2yX64pLIqtA/FWch8Cpw0WJ5MT6iqqaD2lhyFs5kjQcuKTUStykIxtH3nTWU58bqN4vBs2
 ArcWkfD98iASnqZZ6eYA0Ga0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0948599592bf7fd6;
	Wed, 16 Sep 2026 03:53:22 +0000
X-Mizu-Trace-ID: 0948599592bf7fd6
X-Migadu-Flow: FLOW_OUT
Date: Tue, 15 Sep 2026 20:53:10 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/11] mm: memcontrol: constify the read side of the
 memcg API
Message-ID: <20260916035222.GA19557@shakeel.butt@linux.dev>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 06B0C18000B
X-Rspam-User: 
X-Stat-Signature: 15xemut6dyz8n6qegpwe8psw3obhogjy
X-HE-Tag: 1789530813-902999
X-HE-Meta: U2FsdGVkX19+I0m4nahlK8PMHitlN0xWIoqNmfOhb8oXxjOVEsxd5IhLmIz+VurkHeDCDCgctT3Il+aPfsAFF1yjxlLwvKDG5bDfxy6CgjGxCMeENGN1Re046fB6jJF62J8i+BE6uD86LbTwjUqYccy98Y2+pcasJ3S4xwNs0K1hQWiIVEgL/tsIxYchzlgPHSU4VFMQHEGpwWSyDMbngR6/dfd5LWS9BRu2cc2sYKP563/7PHqovOkqodCOrLYcHlx7J+RZACx9tw8GtienfvR4wOcBwA4oj3BZYmpGt+qg87GpQYQf5p5HmXoy/LwybsuB33c6F1mZzrS9jYL1a6v+9gN+8AK4SujuAnVGN3R9IrPNnK3tuBhOvzhRK3kgYhNHlf1atMMWhyl8dECGWEl6ft1Ow1BHmILola7ct+WTn3J7uGMBDuGL+UETWg1gCUs0Vaphp/0YOlVD9FkPSMNsEG+Dq8sPNy38GIdpaHyrQdWYmPybG/5jv6N1hk/NSvXoroE4l9ctKLZ5GfSRzT57mWGIjWL6rymfjWclB3QAirc4Cf4zm8Zd1miRFiHZohiyOBsEEtMJKv4lhaVDfOs/v8zFqTA+3CYZOZwxYMPKL4TDjrgD2PGJ1gSVT9TwyY4Zeoilj5O7Kq3a2tI+UWMv6AeJTRqPSjRsHDlOlH7LMeVGoHE85rqyOf0641PVqwG7Vhs6WqVzd7sHpV0+LyN9kXylN3iK+t/JqIW3rAS67jH6Y/hsjoP0xgznPKL7o1YOWjDT1kQkuxQu04rzlhe71l1ctT9gmxSUvvZo3UpOVblB6u2yF4YNhY7pntyC5sbOcyLrWk4JvbkFnXaA9peMd2vlCP6BBIgn8OBnvKXM3FsXagwrhAH02YvR/BwisF5bnQ4aBcMNujNJ7R6hAv6fH0gxymz34qHi7Ysi5un4D5RMEjJ1vHxcXXrE1V0qvlvdaR+UOtOlVCeiscG
 gJgoajbz
 HWFy7qwMNIysQ/x+/GDNG0g3xBeBrNqa8fiKehZdqOEISnVGnbtVXKx2OOKjUc13jWO51FOPaYdPWTjPV1BnJlyRKIzqVEqb5hnU1HgOwoG/juQXXEVkHtpbpBnBdP3D8i3tiiah1DXgrjHNfQF6qeJxYkDBaqA04vMDruQNsoromrd/pKGi8jgPe6TtyWIen4HHoazFldFKnJYQv6wYqdyr9u6pE06Oj3D3hJsSD8XUKcD39m9dhJtkcpkvNtN3ERdL1rn/ZmJJBOjvP2e1rhQSQWBspPUjN3vTLhveLMPrreLedPNue3mxO7P+CTE7scQ5C55lt+dHlaTm9I/qZz2gz8QlIIHuAuL98
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 07:20:04PM -0400, Tal Zussman wrote:
> The memcg accessors, lruvec helpers, and stat readers only read from
> the memcg, folio, or lruvec they are given, but take non-const
> pointers. Constify them, along with the page_counter readers and the
> swap I/O blkg helpers along the way.
> 
> This started as a follow-up to [1] that quickly grew in proportions :)
> 
> [1]: https://lore.kernel.org/linux-mm/anYqSDnC2BbJXv1h@casper.infradead.org/

For the whole series:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


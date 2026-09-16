Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B294C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 02:33:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 142496B0088; Tue, 15 Sep 2026 22:33:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F49D6B008C; Tue, 15 Sep 2026 22:33:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F26896B009E; Tue, 15 Sep 2026 22:33:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFE106B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:33:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 69206A5B32
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:33:42 +0000 (UTC)
X-FDA: 85218054684.19.1A5DFD8
Received: from mta0.migadu.com (out-142.mta0.migadu.com [91.218.175.142])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7A214C0003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:33:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rOeqZ7Bu;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.142 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789526020;
	b=vJGpI+N9yGJ9buyBsozzZLuFwhTkgC1X+/c9unsdUnXoKv41ESivIrlYZL8KuHcGfp97ll
	KuLdxS+tPWqUJ+jZUWoHXyGzQLy2072Zag92Rzg9LHc1MwdlM9dCAu5RQQjFlnzd0V4liA
	GsGBT/YXA1nwBNKY2QovPvFlX3QO9BU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rOeqZ7Bu;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.142 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789526020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x2iUFdw6vv/AVU991hJBFSBJo3gcDKSXamLwQN8bSW0=;
	b=zjayceSwGmt5XyqaLSp4iVWptJgcerFEhrpc+apf8RAwKpXziQchTQ+zTbcTp2DA3xpgmq
	HXaPSIt3YmOBuV8UM0JqpbWkouyOlSFF9TO2BVXwRTUnilGgAZa/ABxJXVCegsC0Xi4lXK
	S1Ce3/AqrOr0p9ZTTSJvdSB9X4UX9ok=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dmqLGPHS5kHvLWv/Z4DZUWftUs7Vfj/dSFIQY//nWpA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789526019; v=1; x=1790130819;
 b=rOeqZ7BuPfCy7fiZIessAox8kfg6ipSycY01FTv9St7OaBWI2Xriy23DwEEpvAY0ZUva5I6j
 V1JxZqDu9YrlHZSucw4j0vi0RaF//CcBH45xWztVu41wldeH13tWf6iIFiRhQiPW1MhNur/7WC3
 KDunnhEBfqs6KJI8k8wokjqw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 92a6ddf91915ff06;
	Wed, 16 Sep 2026 02:33:39 +0000
X-Mizu-Trace-ID: 92a6ddf91915ff06
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v3 06/11] mm: page_counter: constify page_counter_read()
 and page_counter_margin()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260915-folio_memcg-const-v3-6-c239a6010b58@columbia.edu>
Date: Wed, 16 Sep 2026 10:33:18 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <84761082-E7FE-4984-A7BC-9D2065642280@linux.dev>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
 <20260915-folio_memcg-const-v3-6-c239a6010b58@columbia.edu>
To: Tal Zussman <tz2294@columbia.edu>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7A214C0003
X-Rspam-User: 
X-Stat-Signature: 5yow3e7hp4y1uhhm4xbddcxwy8fcqfes
X-HE-Tag: 1789526020-295389
X-HE-Meta: U2FsdGVkX180pdQAM/5ugJQo5qzcUlJQd/zogjUOonGDIdRvXBjET8YJ8ZaqYul3k24C+f3oe56gRGh1Jdb4PO7/yetHbzXi2okI+5XEOSh4xyrhLhsakZH2J0iDfrXRfXVKtGiTkslgHSjlrs48B6D4Ng/TJkP6i+IWXNccTIt0FJj4YekwJoWbp7BHOOQEFbyeA+Zvtdb3BR+BmwEj18kkCdnQHD2RRJKoHyeaLPA08Lnn0Mv+wHOb0ow9dreZNgI/jf9Cwa7kCVcqMVCU4iBD6SfXkBKKzBe8EJMQhVDOMXt5xbhRI6/novH3dFwmh2e414Ne+F7883NI46Qh+b8QLwLWqq+0ujbD6W/GBH/oQxdwtUUOriVaS8XF3z7SbgKgSB0NMmp0h2bIqR0Qzfwo7jVYAa5EDMZeOMnI8/Ck+xmlfugAyCTAQM2EFEAmJKR1VW+VtMIdKJoqB+bRnEoFdWVwItrO0vt1un8dKnXIa8RqMjt4phMlCIesmOklSkHzCRIIsaWwJOa3gUVMNmAoKUEreaYVywu2kQIL0POUJFSeIw9hnOJbgv0TfI06rptxK4m/hAGISh8Z1gerzOtXlp/RiDk3jt3nfaTBjlC6QvHq741rt08kgRH6bbzallDWmNqgphJa/lGC40Ub3AGDU8bhO9+JBeAqvW5R8QdvD0C0qh6DXwsJsXY7uicEdusHt2zHio+n+9S1dEVhg/z9tAtQwpU5EPl25o6C7GgKWOl2AftbajiotzuAv1U1tdhaErCXT5YQPiSC5VZ8k7aaXe9kdpN5vl3frj5KOe+mcwAD4wWXw8QBjbbrNQSHpU5UwxwrSRKGEbC9rGQ3BmdpVaBBARA/waZ/sBkdFLJwsIugjShbOn+AdCfvey9X0wm4dX14FwizB932RtTj+gIJdDB2SOBGv5ABGSx6skbeygOvTn0221x/VzfAeI4EjsbVitLBwdsp57mXJwE
 RAQ+m8Bg
 1aCnCqZHYAsed1wwEHq67QrV+AsOd/l5uRlMC6pmgDRXlEpFzpKewKStWMfJouvjAS03hUz5c9R5KAE4YLMCe9uQG6FuKQFSsRDR38RxIs/kqkfa7xaGp/nmNNbYrkEThhbaYLKOYdcgA8ssJXHnris6nlzV8pPniyNfqxlM7aQnmwYdFstbnBcFZvTkYaqzSXD4Z5Zpqd3Lscj4fhZW2fInITAi4KdwpSjYOsD768PlHid+Ak6gAGvaXM1W2R+z3DoW8S3xGYHRv/GcByos3jfEoiuO8FQCrk915tlnGx2HQGDRBOO1ox1rXXnqpAUrvL3ujqhqc51v4woqB+twLDfJssg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 16, 2026, at 07:20, Tal Zussman <tz2294@columbia.edu> wrote:
> 
> Both only read the counter. Constify them so that users can read
> counters from const memcgs.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Muchun Song <muchun.song@linux.dev>



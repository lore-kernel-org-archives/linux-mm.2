Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D95EC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 17:54:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4DAB6B0096; Thu,  3 Sep 2026 13:54:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFE7F6B0098; Thu,  3 Sep 2026 13:54:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B173A6B0099; Thu,  3 Sep 2026 13:54:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8ADBE6B0096
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:54:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 128FC1605D6
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 17:54:05 +0000 (UTC)
X-FDA: 85173199650.18.AEFE40D
Received: from mta1.migadu.com (out-162.mta1.migadu.com [95.215.58.162])
	by imf17.hostedemail.com (Postfix) with ESMTP id 06EDA40002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 17:54:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FvDTBfMB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.162 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788458043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qT2qYW0N+WxwUHGLlGOyKzK2nTUWNVxdE9YchYI+J74=;
	b=nPmL0Y/xLKxomB/3+MtGUBT8nPDjJvOvOlzruNHoDkXMI3cCgHuQdhKQc+mwpFpEm/k8z6
	ydOORdLoTRGDkTkLQ0XYdn22yCd6nD2To6w55LkxEcGCi5oSo/0WbnWyEj2l+uUc60Z4tj
	LOhNozYiapZlFSKeK+Op4IijhR1PTbs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FvDTBfMB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.162 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788458043;
	b=hJiYFg1Q8xjH8qqN4NEXRlh5B06pGCyILytD73WM76M/IILgs37n22jmhgz2577L2bZLRV
	6JUMc6rYK4odVpQ4U48qdRnsk102vXRtEr/LC59mMwpos+uHrGU2z8pSRjgQMFsWbgis8k
	aAyWsQIXNzFHfoCvyabXiYpwOIb9W0k=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/eZlZaJfS4LJcg0pLq7HbNjDhmQoWNJgwHrvMq66Eng=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788458041; v=1; x=1789062841;
 b=FvDTBfMBAPR3E5rQJesArpC1+6I2a5k3R7ke2YHpHtwqOmcgYmz3+S8/Q21YFOfvCWW2A+v7
 ij7lyzDx3AdOpXp+YqG0U2vaLjoWfuyhK9sbVPK4BBYjc79TiQG9YCesktDEbF++WvoxJQVDy+Y
 dq+PUHsXlUJBdv2FxE3y99H4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 280e3003281bdd8f;
	Thu, 03 Sep 2026 17:54:01 +0000
X-Mizu-Trace-ID: 280e3003281bdd8f
X-Migadu-Flow: FLOW_OUT
Date: Thu, 3 Sep 2026 10:53:56 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH v2 0/3] mm: workingset: fix the shadow node budget under
 MGLRU
Message-ID: <apmz3SGJ-kH0ppAn@linux.dev>
References: <cover.1788169145.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1788169145.git.zhuhui@kylinos.cn>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 06EDA40002
X-Stat-Signature: eom4694tymahj6xsjdco7fe66tqyn4k9
X-Rspam-User: 
X-HE-Tag: 1788458042-271014
X-HE-Meta: U2FsdGVkX18/nxKZMgEZUi0CZ8RvcJKTRXMcp/Sfi2kj3Kg9653K2GCHCSiIrbitiWDmIV6/5wITZ6cfz5df1GDjJCySs0z4w7U1eG4D6t272KRlJMhkNtkav1aeMeeKfCDuF2i6OLD3J1mYNtBpuriZ3bgmQpIJiAfSw4u6UWEjKfXvrgA5pazC+38I0mM1NZM+j20cZofspYuPAcjieNyv870Esec+wkwsDu5bR44aCBOUqM5DO3JCUItAARy+JqII5iMZjtRCi9GYU3fIfBk0XESqnXe7PPbbxft2Yv29HtsdUK5jqu9opymBsGb+c9Ujm2z6W2NS8c5GHEw9bbUkgitBCUV7bDJpwBAx2ZTDXzsdKCbRvIa5KYLPF6QyS+LmlxafdhUYSqz8jlzzR+sVu1iipLAANEGg5cnxxtpmazNXbuPll90aWuDz5IMz9Rxee0KEVG7DlxsCql04FETjr8kAIDkwjw0XSBHBmA/GjsRK1efmxqWuItfODn3uerApAoNzEjYFiBKuwW0SBZxpQwVRNlD0I/Guu4kdJA3z3XoI7HMBec52X7oOc/SpYWlVaK1BLP9elClfX9uEiMxVV5ejYT+bjXaog4VhSsYSxaREJxyQkqTkvrD+jnCNijgVkgi8O+v8t7Nv+al0rN3pATpml6aSUmJDQfcFktxs9xboWewtk5ZrJ5Rdh6YBvqwnagEWM0q7Zkc/h9VoHhq3SANkdLwcHxAacZJgli/u5MC8XB36bCxUwO9Q5vL2hHsNzaYw2wlrXU4dSOT/uon3IyA3LDlrR5db9fdzXU/gA9sYHbYBzAdbv9AwTFkSYHHVzLWyiU1lgPb7kYR2UB/J6+1wjJP+Tf3/rRTpcK+8toxX/ZtHvzxNrC8o3DQ9P4L9AgeBT3o/7YcR7tnSm4zTNXHnFL+x958Q4zaH3yV9ihrdR35awj5CtL5kOUgTiYyLvze9YYgKnRB7gxJ
 nVITif7C
 BvoofPBtItoL7tZy1GxUyuNkpEim4XticYpdc6C64V56nnLXY4Jm8xhesP3u1nFvqOAjm5BFBc1YrQLTYGF59TzC6BtCdhPw7Ud8ZlhoAWfFF5eh1AUWwErhYwhyFjZmHKiDf6CGkb6icmFRq1OGlHNiXbEfBq5GMUNm5Gff0Nx2MVKs5t5hQclGK2BBBlobi6KvzGZZPE5BiSnaaD41eGQSxTzSQLi38N7lTwFFjePNcy3c94mviYP5Zu+nze9D2dNQCWSVKWVNpItMaiwRwWGWvGxhRwP0wOVencS+B3PGY6K4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 05:46:08PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
> number of lru pages") broke the workingset shadow node budget under
> MGLRU: lruvec_lru_size() reads mz->lru_zone_size, which MGLRU never
> maintains, so count_shadow_nodes() sees the evictable LRU lists as
> empty and the shadow shrinker reclaims eviction tokens almost as fast
> as they are created, losing thrashing protection.
> 
> Patch 1 switches count_shadow_nodes() back to lruvec_page_state_local(),
> which both classic LRU and MGLRU maintain.
> 
> Patch 2 addresses the reparenting race that motivated 7404bd37cfbe:
> patch 1 makes cgroup v2 read state_local as well, so extend the
> dying-memcg stat redirection (previously cgroup v1 only) to all
> hierarchies.
> 
> Patch 3 recovers the performance.  Patch 2 added an unconditional
> rcu_read_lock() to the stat update fast path; patch 3 moves the dying
> check out of the RCU read-side critical section so the lock is only
> taken on the rare dying path.
> 
> Performance testing
> ===================
> 
> The test script and the raw results are available at [1].
> 
> Environment: 10-vCPU QEMU guest, 8 GiB RAM, cgroup v2; 7 runs per
> configuration, medians reported.  Workloads:
> 
>   w1-anon-churn: single-threaded anon fault/charge loop in a memcg
>                  (MADV_DONTNEED + re-fault, no reclaim).  Every touch
>                  is a real fault with charge and memcg stat updates,
>                  so it stresses exactly the fast path patch 2 changes.
>   w2-file-churn: file read loop under memory.high pressure
>                  (reclaim-bound, noisier).
>   w3-reparent:   reparent accounting sanity check.
> 
> w1-anon-churn (pages/s):
> 
>                  classic LRU          MGLRU
> base             4393028              4377122
> patches 1-2      4385996   (-0.2%)    4352887   (-0.6%)
> patches 1-3      4381832   (-0.3%)    4377053   (+0.0%)
> 
> w2-file-churn (MB/s):
> 
>                  classic LRU          MGLRU
> base             8277                 8226
> patches 1-2      8226      (-0.6%)    8123      (-1.3%)
> patches 1-3      8157      (-1.4%)    8294      (+0.8%)
> 
> w3-reparent passed on all kernels.
> 
> Patch 2 alone shows a small overhead, most visible under MGLRU (-0.6%
> on w1); patch 3 brings w1 back to the base level in both LRU
> configurations.  The remaining differences are within run-to-run
> noise.
> 
> [1] https://gist.github.com/teawater/32f373ec41d185d840455eb167321a5a

Thanks for running the benchmarks as well. I think we just need to order the
first patch after the second and add CC:stable to the second. We can ask Andrew
but it might be simpler for Andrew to just resend with the correct ordering.



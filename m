Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E275A606A327
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 06:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=moeCmSUU
Received: by kanga.kvack.org (Postfix)
	id 16DEB6B05BD; Thu, 29 Oct 2026 02:09:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F76D6B05BE; Thu, 29 Oct 2026 02:09:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 034CF6B05BF; Thu, 29 Oct 2026 02:09:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D5D8B6B05BD
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:09:15 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 523EBA7C04
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:09:15 +0000 (UTC)
X-FDA: 85374636270.12.A4C473A
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 46EE0100002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:09:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=moeCmSUU;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793254153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WifFjtHgZkJ4eUGZzP2SLgCkpK+TLdKe5MTWOWYju04=;
	b=hUuqgDa+VEaSBl0QIjxy0T1wySXTidVihk8wp494wSBqh30kv4UxFpNBBBooIYNl0zmsd2
	tBVRC++J5x5NP59SLJynWYfBkyl5Tc8a/RIZnkKcZUPb/QzPbLjRwi7WYiZLYHi4KdmoKF
	HYIDqb66PWq1exTr1/llfYu+zn4RjjI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=moeCmSUU;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793254153;
	b=ueXTYQtlgWQeVZCTOjVmKv8Twb4gEC6kW5pL1YxaxQ4/1DAv4WjGkaOieMd/zbnuKuvl0a
	Wy7vBLofGjvbnt987WeI16wiuJZHZgbD7s945+l9lzVbnCsyA61TeiLh8b+5BOgmwPv9I4
	haV25jzaXpT6MQj2ML8xEPwZ2kLdhMo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793254148; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=WifFjtHgZkJ4eUGZzP2SLgCkpK+TLdKe5MTWOWYju04=;
	b=moeCmSUUz0cGN4SciBL6cdYb8yCl+siZPQuDlFqAWqqsOE5QErRI/FP0iJc/lUZ7Tf5vliSl3AQboiDrZ5MTXI5/LMFynyGQCk86aKVsXoRL74ple/E87KEuKTDVvWb0pLcQBwn4eyDqaQRH4GPN45s2IpvA06D79bxAPE3SMIQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0XDiZZYp_1793254146;
Received: from 30.74.144.149(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDiZZYp_1793254146 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 29 Oct 2026 14:09:07 +0800
Message-ID: <62b92624-9d64-49a4-a67a-ad54ca6d9be1@linux.alibaba.com>
Date: Thu, 29 Oct 2026 14:09:06 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/mglru: stop rotating offlined memcgs to the old
 generation
To: "T.J. Mercier" <tjmercier@google.com>, roman.gushchin@linux.dev,
 muchun.song@linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261028010611.3929937-1-tjmercier@google.com>
 <20261028010611.3929937-3-tjmercier@google.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261028010611.3929937-3-tjmercier@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 46EE0100002
X-Stat-Signature: yqa1nay9sm6hj6n775fe4cnetjc3t839
X-Rspam-User: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793254151-238666
X-HE-Meta: U2FsdGVkX19nJO2Ck5y6Gu6shTjSSWM20BTy1TSbPAAowpLk1x5QmzWb0w4iqxXCOaOTSAB+zBQKqlQY+geeOW4GKfbeq9Bb3mebLhzFaZrXKdmwLviM0ABwH0cmS5XCDWkI6m9x8QLN80pf20R69KNoHvb2JBLQpbIcu19hj5o5ulwDJwAs+Ni/pSGEOHIQsJncvhUP1J+oulqPSLR3UaoKmH8mVSn4MphwP/FViA5aidWzGNiLTCLg3U/3wS/ftSJXEN9//mXHzVjSHoqr3nEZm64iXn986QbsTzOUBXDvUpwR78OjIRLct8CxhQxa3EzFp+ammzgbqOxI1eQTJPGj8jNuoYPzXSgNHDzSi4aj9PqYa9HVRaoii396YMScBf88U6jx04E5PvgkS0FhmhgPqxA0Iqnzu9CYTqgzxJhEQsPmW75owsZlIlQCCQjW4TvT6YAjVLJgANQmNTxuLICRMMQWKjQcmrijJiHXpB6QmQxnIRXv/PaMQZIWTBapj9r8KCl5gegvWZvCuusl+530qOI3B6mXYACooMbODI0nsNenzAHxd+WJZid15bLsgj/ahdmFUa6uWpoAH7JbPQP4DyEOz3o99mbFkKLq4GlRJb/IMP6GTjk1ZHaUMVwOJD4AEzVzQLTugBxiSRjfdJZvH5Y6+6+ZfX2T7RAfMiNsqn0RNi+/WUtqqiU63SJpWdURsgVuujFWXd+TXxgxx1mevhiKsb27+pDrnYPq4cgG1eSEJRGJYkAVQcxAsT8HZsvG4uiUDyRH1KEQihKqj9HMFGtePKV6NmdPx1wjrF4pkAOCq/UCtUOmM+cP8jH/ARuNSdLEJ4CgR+LT0eT/8aav00HDGgMzrHQmdRAQhtSJvMSspDqICvwoGV3P/RMwx4aKyIsK0rrrIQfFcQAZJnSDWoxKh2BflpI5cJs9WA4+T2apa2HmXcgITV4I3SZ8dYrNRmgWgDmDuAWN8VK
 f1cQb36M
 Z4TSaUpV6OYY8EqSLxC7Sn5OQxxLrg9vcUk8/bFmI74nDj12XzKzBu6rp+yPnLLDqWiT7N3hWG5L1bbx84T1D6ed5Wxvtyv0ZBXWbk/npPtRWmcg/39R506txZlT1vq2uxfz0YG3V/lR/GxPI6nlsYwRkiHMJhcQitfgZd4muDKx2INc4LS+zhPpaB5PZ5NczfQ8WBFdxuq1EzMQURIZPpTKt8pTPuo1kvUHRzJiMV+zD7oRingZfgsjCnUjJKsldkglA4HpyDn7J5dvyl4qf6gHZB0SE6WbOJOzzwHdr0KjuNg+IlS9U3jvdg+kxsLj07VA55I7An5bNVwQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/28/26 9:06 AM, T.J. Mercier wrote:
> lru_gen_offline_memcg() moves an offlining memcg to the head of the old
> generation of the memcg LRU (MEMCG_LRU_OLD), so that global reclaim
> visits it first and evicts the folios it left behind.
> 
> Since commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
> dying memory cgroup for LRU folios"), those folios are reparented to the
> parent before lru_gen_offline_memcg() runs, and nothing can be added
> back to the offlined memcg's lruvec afterwards. Putting an empty
> offlined memcg at the head of the old generation no longer serves any
> purpose and only delays reclaim from the memcgs that still have memory
> due to additional shrink_many() iteration.
> 
> Remove lru_gen_offline_memcg(), so that an offlined memcg is rotated
> like any other memcg below the reclaimable size threshold until
> lru_gen_release_memcg() takes it off the memcg LRU. MEMCG_LRU_OLD has no
> other user, so remove the op and update the memcg LRU comment as well.
> 
> Signed-off-by: T.J. Mercier <tjmercier@google.com>
> ---

Thanks for the cleanups. LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>


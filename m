Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72121D41C12
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 09:35:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAE8A6B0005; Thu, 11 Dec 2025 04:35:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5FAB6B0007; Thu, 11 Dec 2025 04:35:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A756E6B0008; Thu, 11 Dec 2025 04:35:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 986876B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 04:35:26 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3275913BC97
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 09:35:26 +0000 (UTC)
X-FDA: 84206682252.14.70C11B2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id E945CA0006
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 09:35:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765445724; a=rsa-sha256;
	cv=none;
	b=QU1nQe4oBqk+N3HDhUTGKBhUpPg7Cy5+VAahr8KW9qgS4uAq3zJa/RoRNOHB3GFJ3KzVWU
	ztBG+EauFbJyJvlkhWD/0v2qhp5uiXf9cxFov9Ibuu9pRYtkXtuMuiAjhEpHqmh/F1R/s7
	UUBTry16HU4wYFujlGVv5aysaHw+LGE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765445724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tGs75aWCICkC7j1ezUu35CuPpgnIOUGAf4M8+kinw7A=;
	b=xHuGLm4mguVUBRMhYzEtLRgFywtmgZ1Ug1oGKIe00t85b53zcBP+Ru8kU8R1GtdPb7+2Ua
	lCRJdDom8f5Y/JWQRTEneuHHlbBgauunRPtij4/bCpJAK2CcmFzsnUdbOHArGSbQtb/G4L
	Q1o45AMmAXLowDJNswjh9ELi97nJrak=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8C8FB153B;
	Thu, 11 Dec 2025 01:35:15 -0800 (PST)
Received: from [10.163.80.88] (unknown [10.163.80.88])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3AB273F740;
	Thu, 11 Dec 2025 01:35:18 -0800 (PST)
Message-ID: <49d00536-bf7b-4bc2-b771-c708f36f9407@arm.com>
Date: Thu, 11 Dec 2025 15:05:15 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: memcontrol: rename mem_cgroup_from_slab_obj()
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>,
 Michal Hocko <mhocko@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251210154301.720133-1-hannes@cmpxchg.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20251210154301.720133-1-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E945CA0006
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: pa1wff4hbqibffwce5o74gkabxbxiouf
X-HE-Tag: 1765445723-266207
X-HE-Meta: U2FsdGVkX196uZ2ChbbS1O8qHgUozMYXXF9q+gWXKETTnWGsYB8xQa+WrnIl3y53jQlJe/M+p8Osg/ObUMvLccQhdpCPa+1Xrdm99OIh1nJ5w4lzQ/EaZ7pJMzVWrS0UOdRMju8pc9wc+rvuAdgiQ+2WR3y6cioMo2p79CSyqyK04YIAi4RJyqYg/7axgeeTEq3Y8XbTEaEWceq7n8IPUyp6T/GrHxelI0pOXKVRUMkSdQ9a7ZOLAEMmOrO2zLjKNxAq+1oUDI+wVC8a7VnYs7w6XrAnlpPHmLKuEJQPwQT+YEq7KKmJisWIpDybnPw+SQ8Nhz4DkR+NS+sZ6AGWfJkfQElNnrmytON1OdPRqwgtBqRLWot2rkDE9rz4kVhSwOiPLV1lxRNu0loNfi/J+SbDfVOg3H/rQS1SrdXtV3Hi1SsI0bfU8cJtO9zPpT20bFuV/UJTT52/RLUO3ey2YSiVvfVZun+7wjn8TNvWjE2YTuyXfuMpSutoRCm6mDqKmXU5F7MuBB/vJ94aXQsv7qhwxnnls34P5+TW+od0loKSOFhQVI6vgUMJ+4aRmS/sklK70+2OZie9YxMVmL5tJnEzopcwa6YbuDN22JaQ1JAVC2fWghc/LF+On8ZP8/31xWLGwRlv3BBI5slZ//jDxuk4LJJYUy6hsSZlNFqdLGN5ZE8fM7aLkcANVKPyqXnh5cLsPmh7wCYwKBXKUZVlO50x5eRbL+d2jHWIVR0Q3uNEhIvcNX915CB03pR2RA115zwogQnvaLbuI4Hy64SLYs6lZ8ORNTJ2n/xu5wZqEKXLsu9+wwDU/b1QICZDgOLmFBBn31yq45qNKBLIzRzKKlLF5NqGcg+1TPzA5TFM6TAY+k1+w6cCBfQ/wuaTiML61CO2mtu1AW2olch3Os1BRh8YfFwoNlxPPoHmmurobNMW8m33rlmzbm15CZ4dEt75fBBZNJ0DoR8iDy77NwZ
 7VB0M0No
 yyDbIZ/NWIvGPRL7LVWDv/vQr4XJJ/avU6jRv7wy5RBGh7xBp523RJu4cWHZ89oXloZg2F5uu9JZnu4HV+WdZpn6m81KKaHlxqVQfjJGj7d8hfBioW8om2iAIGZ6d9AzB+TwsByMhQRMZTdvQuD1WwWuLV3ZDrifOk7gX/KdNMQO3Bn7Kzc+46CztodixL1JqWhw1rno6uXwyOm1h/Jd8cmHsI6NpFct7aFk9+CYLe9TXSesYkXhnj3P6iR/NAPTsu4k+HY6+jnfNM0vMHJRyGerkUd+zr6A5h/w0q/ceYg5lcWJVL2aV3CafNeYSdJARDl/M4QANP+ZHT6Cjd5aKbsmHok93LWVUwKXlMdpd+lz7IBw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/12/25 9:13 PM, Johannes Weiner wrote:
> In addition to slab objects, this function is used for resolving
> non-slab kernel pointers. This has caused confusion in recent
> refactoring work. Rename it to mem_cgroup_from_virt(), sticking with
> terminology established by the virt_to_<foo>() converters.
> 
> Link: https://lore.kernel.org/linux-mm/20251113161424.GB3465062@cmpxchg.org/
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  include/linux/memcontrol.h | 4 ++--
>  mm/list_lru.c              | 4 ++--
>  mm/memcontrol.c            | 4 ++--
>  3 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 0651865a4564..17ad5cf43129 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1727,7 +1727,7 @@ static inline int memcg_kmem_id(struct mem_cgroup *memcg)
>  	return memcg ? memcg->kmemcg_id : -1;
>  }
>  
> -struct mem_cgroup *mem_cgroup_from_slab_obj(void *p);
> +struct mem_cgroup *mem_cgroup_from_virt(void *p);
>  
>  static inline void count_objcg_events(struct obj_cgroup *objcg,
>  				      enum vm_event_item idx,
> @@ -1799,7 +1799,7 @@ static inline int memcg_kmem_id(struct mem_cgroup *memcg)
>  	return -1;
>  }
>  
> -static inline struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
> +static inline struct mem_cgroup *mem_cgroup_from_virt(void *p)
>  {
>  	return NULL;
>  }
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index ec48b5dadf51..37b642f6cbda 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -187,7 +187,7 @@ bool list_lru_add_obj(struct list_lru *lru, struct list_head *item)
>  
>  	if (list_lru_memcg_aware(lru)) {
>  		rcu_read_lock();
> -		ret = list_lru_add(lru, item, nid, mem_cgroup_from_slab_obj(item));
> +		ret = list_lru_add(lru, item, nid, mem_cgroup_from_virt(item));
>  		rcu_read_unlock();
>  	} else {
>  		ret = list_lru_add(lru, item, nid, NULL);
> @@ -224,7 +224,7 @@ bool list_lru_del_obj(struct list_lru *lru, struct list_head *item)
>  
>  	if (list_lru_memcg_aware(lru)) {
>  		rcu_read_lock();
> -		ret = list_lru_del(lru, item, nid, mem_cgroup_from_slab_obj(item));
> +		ret = list_lru_del(lru, item, nid, mem_cgroup_from_virt(item));
>  		rcu_read_unlock();
>  	} else {
>  		ret = list_lru_del(lru, item, nid, NULL);
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index be810c1fbfc3..e552072e346c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -806,7 +806,7 @@ void mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
>  	struct lruvec *lruvec;
>  
>  	rcu_read_lock();
> -	memcg = mem_cgroup_from_slab_obj(p);
> +	memcg = mem_cgroup_from_virt(p);
>  
>  	/*
>  	 * Untracked pages have no memcg, no lruvec. Update only the
> @@ -2619,7 +2619,7 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct slab *slab, void *p)
>   * The caller must ensure the memcg lifetime, e.g. by taking rcu_read_lock(),
>   * cgroup_mutex, etc.
>   */
> -struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
> +struct mem_cgroup *mem_cgroup_from_virt(void *p)
>  {
>  	struct slab *slab;
> 

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16E70CD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 17:17:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 776946B00A0; Thu, 21 May 2026 13:17:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74D7B6B00A2; Thu, 21 May 2026 13:17:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 664816B00A3; Thu, 21 May 2026 13:17:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 532F86B00A0
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:17:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 09CCE1A04DA
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:17:49 +0000 (UTC)
X-FDA: 84792084258.22.4C7D748
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6CA8BC0002
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:17:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=TvW4VxNY;
	spf=none (imf10.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779383867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uuz2S8ezS9r8v7TY5V+0JhTDDl3lzIZ4VZXXv/MWTDg=;
	b=foUQe1h2gE4NLXG53GhZEy/xSVk6VdsIX1gzB5azpcXI1jqaT/K9gfTeYC30rJXqu3QZqN
	h6szEL28TOZ2UTMjFmlqHtEtirOmeuPuDGggPWde2gflP2tCNLcdggi5ahFbjEdthMlqoB
	zMAe6rHNWr1ZtH081VWMO5SofzOORDU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=TvW4VxNY;
	spf=none (imf10.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779383867; a=rsa-sha256;
	cv=none;
	b=yv1bPkL+h8gSleCmt5SRobBTCp/t9t/+MG7C0EU43LSkJvsVf+HFZ2D6ELhtK6QYzXZfsl
	sPbKJ2w3ywhmjHObznvY5Jiq2eBHr3zjdCUqw9fr2hJUPV6p4aNu1A1FOOaAbJmS3KXNSk
	TPszCO8acxf7xIfXhO8AqaJMsfmDVKk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uuz2S8ezS9r8v7TY5V+0JhTDDl3lzIZ4VZXXv/MWTDg=; b=TvW4VxNY1zCujZR5KM6s8///6Y
	3cRidQGrGu4ppzmn9pMNxb63DtXe22OP8+DYICHa1xHLjG9pGtJOq88eHb5RTvCx0ehUotuTQxwHU
	b3c1P4VQ9g7jMXmWIp6FIXuqvmAOM7JX6vLJp6GTZVz1iGS3xutc5SSpeI+9V4rufT1WGWx3uhjhM
	idEwOxheRyplFT+d7xZqN37d0B0R8UCZgo9ihP+r4kmITf+cky8Oq+2IeNuASZP4rB3x1cIMVKAoI
	Hhtzgfq6AbELPW3kSPWc8j0+HK8DT4Q8mJF4jpG8jOIlc2pmOv5vhKAT/lnTdhdsv2ZTlMuDmHf4+
	VUjdDOSQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wQ71i-00000008buJ-1MFp;
	Thu, 21 May 2026 17:17:42 +0000
Date: Thu, 21 May 2026 13:17:39 -0400
From: "Liam R . Howlett" <liam@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Dave Chinner <david@fromorbit.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Kairui Song <ryncsn@gmail.com>, Mikhail Zaslonko <zaslonko@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/8] mm: list_lru: move list dead check to
 lock_list_lru_of_memcg()
Message-ID: <aqihmycbhhj2uzzpq53wczbb3wg6yajpz4nuswzrkgzykbfrog@gsnlohrtkdnd>
References: <20260521150330.1955924-1-hannes@cmpxchg.org>
 <20260521150330.1955924-4-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521150330.1955924-4-hannes@cmpxchg.org>
X-Stat-Signature: 4xk3cty637e4mr3wgjng1zotyyagy7m7
X-Rspamd-Queue-Id: 6CA8BC0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779383867-756896
X-HE-Meta: U2FsdGVkX1/etyPGC7Y5XYx21k24NGx2Kzl8ePpuNorhezC6tvk5TWMkDHihQFGUeiWusupAMGpZTZ+iXOd0hR8VUmtWG3JEGEyRg2Ov98WNH2zmueUrazBp1S8rlF+bTjueRVPhCxvD3dIqdrtRFnl9Ow+0VV6X7tOzKv6oyrOJSYkVfJxeCY07xQL0FbHYh32336oMJdnWt0RQORN7b/KpJgaMbH815KkLyhCWluM3hPJQezvDCy8MO9P1RD5V2yHvmOtJJYg68PHrQ8MoCIkgpWrN4uYn4V/HB6+2PVMduC7Bb1ox6NckBtcDyTutKhqobMxpz+nqETIaFZXeEA1Yz2vOTkPnjzFyThOBB0sAqxDBwroy4q0GLaqsp37/A3ferEYt+kbS6wiZM4TboL45VJlNXw/ogYFNNLa8dv0s/1dMhEyOtgC7sXeWIUcLu6AYlv6eOIlS7neD+OctDxUVAyy5hOpTO8iHu7N+XtWaRT1t7eWN7VTW06XmjKHjVZBLfuCncbMCq38aN6MFxqxPaFYWiWon3VfRWZeqsOh00Kr6mgHPkG826WVuTqPG+wPm44xliocc9W9sSznaaW3I8U+o0saheymWpbFh/yJl9fp+i1tiDS2HpiAJ5mLLjkbBMQsPz9yquALIBWTcE/hfW8UBqNwgEQPvi+qdXC3Fjzbj8SJcgpFfbfR/vJGZpxmyfC9jvMAw7JwCMUwHMnkyCrLw2eIQUX+YZ0gxpfvusiVp6gOPqOaje5MaetjvdC3soPkvVbOECa5Zvc9SiORh5xpMx4MJtsfRbyADF3bvGq57yY5fWSt0CFA+TLvI5Ld1Dq6AQviMX1M7Z9XmaGx1xZN0Uo3AHelMbyi8BCKGs76/UvESVCwTCPZWso0D+8rViJV7Esqf73Rw6xa8n8epaK46XdI4IHhvbn3ODsLQPxv7mSCFSfKHDk2iVuEgAjnTj5WB2qmG+Gg5aIl
 kvNVNfPi
 4HLp5WIp5uk3a0TvYOaAhvjZI/UzzjXR8kpTc48dzaltey4hjpCR2kcKx5YiVVL+jlzAi4BzG4S6CPRggEN9AMFUKMpv/AD5/upvA/Q2uf6k/v7C6u/vJ0w5hkATW4FJRFwe9x8Bx6OOJkKh6RyBYmHZ1T5M2GzYYnnBmhZCJcltefHsqMw2o0MELYZvHcPSch+e6NsuL7r3JTLxMdJn0OGS+2Hmsvt9tpJ2sO2BNPTu1HrBwWSwo+iIIdU1zPn6+Bg+wc5CQNkIWMHCWTALjPqcTBpZxd2iTG9poFiA37YF8+oqngFCKtv0ru7wlQvpU7kFn75mxSqi1PtrxvB92nMobyN8G1Zn998VAKlXwrrgDW52uNzQlVbl7+taHFoXYJ+stWAHa1WpsMyH0NGQtwic0IPMmeaQAOfbr6MpTXE6IDTcE8zPL+VanjFfqM4Oc5N36amHi1R0rRPdnC5+fsqYr3hNzTcgGy8Pb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/05/21 11:02AM, Johannes Weiner wrote:
> Only the MEMCG variant of lock_list_lru() needs to check if there is a
> race with cgroup deletion and list reparenting. Move the check to the
> caller, so that the next patch can unify the lock_list_lru() variants.
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>

> ---
>  mm/list_lru.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index 9a68177619bf..9da6fce19832 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -68,17 +68,12 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
>  	return &lru->node[nid].lru;
>  }
>  
> -static inline bool lock_list_lru(struct list_lru_one *l, bool irq)
> +static inline void lock_list_lru(struct list_lru_one *l, bool irq)
>  {
>  	if (irq)
>  		spin_lock_irq(&l->lock);
>  	else
>  		spin_lock(&l->lock);
> -	if (unlikely(READ_ONCE(l->nr_items) == LONG_MIN)) {
> -		unlock_list_lru(l, irq);
> -		return false;
> -	}
> -	return true;
>  }
>  
>  static inline struct list_lru_one *
> @@ -90,9 +85,13 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
>  	rcu_read_lock();
>  again:
>  	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
> -	if (likely(l) && lock_list_lru(l, irq)) {
> -		rcu_read_unlock();
> -		return l;
> +	if (likely(l)) {
> +		lock_list_lru(l, irq);
> +		if (likely(READ_ONCE(l->nr_items) != LONG_MIN)) {
> +			rcu_read_unlock();
> +			return l;
> +		}
> +		unlock_list_lru(l, irq);
>  	}
>  	/*
>  	 * Caller may simply bail out if raced with reparenting or
> -- 
> 2.54.0
> 


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94F63C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 18:19:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B3096B008C; Fri, 18 Sep 2026 14:19:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 962CE6B009B; Fri, 18 Sep 2026 14:19:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 879356B009D; Fri, 18 Sep 2026 14:19:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67A186B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:19:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9F1FA4077D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:19:20 +0000 (UTC)
X-FDA: 85227695280.26.C4D9A69
Received: from mta0.migadu.com (out-206.mta0.migadu.com [91.218.175.206])
	by imf04.hostedemail.com (Postfix) with ESMTP id 061384000B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:19:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LiSjmj38;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.206 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789755558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I8MVWd+FUrhvkMxBPtV15prS5up5E9sHkXtKKhaNAOU=;
	b=uDzCQDhdZt7PEjYguMVuP/xox6+TGAp/Vp+Wr7tf3DS27AJeu2YwNbkst0pLod6PZWlNPO
	zsO4SSp0GTcA71Yhu09YKjhUppYwPoDh43BG13Q/ToHntrDA9KvWmTG7xqUDbainnDbYB3
	aNoBEm8FjMqxzyirYwRB+cAPenZu2eY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LiSjmj38;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.206 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789755558;
	b=Efg4bRpqPstTkPk6WeSo2IhWz/Z7FVd03lx04+FQAENLZYIb3BjUIaPI3bRqV+v3WG3M/u
	m8CDhW5xha24IiBusOpBSUXeOCmn72NAOKwPKWSAMqj6lIbxOWYpJ2y3RJ+rgIXcCEP0mo
	Y1mqSe69jdX+LHo9UL8o4TKTUQTTeAg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=iHCQilQ4x8FlNnS2IkgCh0INwKZKlX5mZWBCxqEI+cs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789755554; v=1; x=1790360354;
 b=LiSjmj3811D0sEQOkFqhqCslxtDax7X1LstUpScy0vbMDuBGjoX52NzwJM61BtguLCzlpZIO
 BPxpEGi6Qi3facgpZxEptn53a2H32/9PBQnF10xG20NBJhNu/QhIe/8PFFUC+8JiySfgRfASJVK
 mVQRrX4GuIeYOOgNpxkVkEQE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8db66427678445f3;
	Fri, 18 Sep 2026 18:19:13 +0000
X-Mizu-Trace-ID: 8db66427678445f3
X-Migadu-Flow: FLOW_OUT
Date: Fri, 18 Sep 2026 11:19:08 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: bingfangguo@tencent.com
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Bingfang Guo <bfguo@icloud.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] memcg: move memcg private ID refcount to objcg
Message-ID: <aq2AUmRISe3Nmfft@linux.dev>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
 <20260918-bingfangguo-memcgid-rework-v1-4-5bbf3220d88f@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918-bingfangguo-memcgid-rework-v1-4-5bbf3220d88f@tencent.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 061384000B
X-Stat-Signature: 84fm5rr7noy9dx7myb1ekebsis1qbn34
X-Rspam-User: 
X-HE-Tag: 1789755556-676985
X-HE-Meta: U2FsdGVkX1+pXJKb3ClMrNWy0FQD7nUt2tYB27HyZ5xgIoDvutk/CG0KQJZW4/TG+2qJKa8wg+Q0MISSnqhmtsI5OZzKeXBbknuWWizz1z/SfrhXyugglPMXM0ATqwPap9fW0X+iOZ6gKCKHpW3++IDaNZK82VxQJ6NwFAwivSdlr6RUlS+Re8XSI9TF6Vby/8ErVMEc6A1BhdtRTg5eGGN4n5LewaxEqLB8XgQ+pDuUkOvChUxRV2dluwI49TI/JgrAvDF9pcV5o3FZXZ+HhVO7v4T2IybCSDQjrsNubOX4dnfmA8CAoXWFhAUoVohwqQhJMvVR3U++GsG6/phxuDwi2VT4q3QIITiWgvlnQQ4CGqpWtWfvmcaSgS/tqq7KjGEtQwalqbBT6UB8sZPtSxBTY14JzTqH8krDXJKFf7Pdu2DoAj6z9bdWtTzw5uKlp+nhfNmcM+Z+1gKF7iWB3a4N3pFPOPoOhqcrhOUEeDIPVOaaVMNhsiIrOJOb5+JkB0dQlgcUF0tsKQRwxOvSEQHT6Zn1o5x0LqEd6Vcb3mnDC1gK4pmSGoHXwQk066oIuswh59UvJT5+oX58qECqh+uOu0wMLCdY/ogNUyGOUU4hCJ8MlMaFppyrlGSwAGhNbfop5whThRJ1dxEFD4iU6hGPw/mLwj4IzoT1z6NQzxAMW3PbbnyYPqwTFd4+BlMjU+dFvn4CqeZH/mBJnIQxM4EEJbItNRYHgN3q7TNs9914ZxE7+oXU1d5ugGqE1siPaY3tOlMhH9Pu0PNVqwGGc3ayV7Q001aNpvnR+i0gQGDn1zO5GIvKS+LqUlFdJg24mNSGiwMU318I+lbVCwruvbTjL4Qh+As4+dIGFj10gkkn+8nog9d2WLKhHqoXt+iu0JZA8E0eAUMywiRtollcUoJM0Y0/dS8S87YDdaikt3IEbUwY8LpwLrLmFIq4FOj82khUgTffmREeYAWKcLE
 krXkPvAl
 r/va94RzdcRDEH8So5pG5jqhGCplu0WHZ+tJnj3tLGDTREwcAw0LiJOU4qXZa9Ng8T037ytYE1iRPkasydQfNdEFeFKLbgtYBkbx8xQXNhWMwWmM3XmWy7HvKN4UwJ9zgnsvqx+jWd/aIRLIrKKqTJ+0R4UyBoCcBqIpjBNG09+EXWm3qcc8mBGdyhTsnprzvZwHsdDgE9zlzeVOiVNDwMRAbl7sksiKfaRwWF5bbu6EkJb3gK0D9SHcfYoYwZBzxnKCdlOG9oR2+SBDwCTvF+8x1Yvkh08DmrfdO9oJTeZbgkeg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 05:18:43PM +0800, Bingfang Guo via B4 Relay wrote:
> From: Bingfang Guo <bingfangguo@tencent.com>
> 
> diff --git a/mm/workingset.c b/mm/workingset.c
> index 8412f4840ae35..7e4fbc5a786d6 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -281,6 +281,9 @@ static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
>  	unpack_shadow(shadow, &memcg_id, &pgdat, token, workingset);
>  
>  	memcg = mem_cgroup_from_private_id(memcg_id);
> +	if (!memcg)
> +		return false;

You can not return here without initializing *lruvec as it might be used in the
caller. Also mem_cgroup_lruvec() can handle null memcg and will substitute with
root_mem_cgroup.

> +
>  	*lruvec = mem_cgroup_lruvec(memcg, pgdat);
>  
>  	max_seq = READ_ONCE((*lruvec)->lrugen.max_seq);
> @@ -470,7 +473,7 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
>  	 * configurations instead.
>  	 */
>  	eviction_memcg = mem_cgroup_from_private_id(memcgid);
> -	if (!mem_cgroup_tryget(eviction_memcg))
> +	if (eviction_memcg && !mem_cgroup_tryget(eviction_memcg))
>  		eviction_memcg = NULL;
>  	rcu_read_unlock();
>  
> 
> -- 
> 2.43.7
> 
> 


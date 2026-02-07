Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6E07EE0AEC
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 22:26:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1CC06B0092; Sat,  7 Feb 2026 17:26:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFE336B0093; Sat,  7 Feb 2026 17:26:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E20AC6B0096; Sat,  7 Feb 2026 17:26:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D55576B0092
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 17:26:01 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7DBF6B98F1
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 22:26:01 +0000 (UTC)
X-FDA: 84419094522.27.1887746
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf25.hostedemail.com (Postfix) with ESMTP id AE8F4A0004
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 22:25:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CZWJUqy6;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770503160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I8cXVRM1MjFfGCcn+LNSZCYqmTLiBCqB1rk+ZLG2yCg=;
	b=DpWuPZtjYnwqVSIvja+eT6s4PcDKDBY9YNAy9EsIBMQEFF2M4ZgkoO7yWE3SHiNs/Zszmv
	jROzQGcB8d3WwbsElmlfRrz9Jt0Mk1j+9GrKlcJqtVMKWOpsccY2lTpkYBpZbZUDZXd6AA
	b2NnBXNMcP/rSyKrTWkM41i+HdsT28U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CZWJUqy6;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770503160; a=rsa-sha256;
	cv=none;
	b=7RdDIoakt4s/RjdJ+f3f4Qz12jj/eFltVIXVHtiVLIX6Qf5QRBfCjnrV43oEDUfx3mtGoR
	8r85gh8FWjy7NxD8UnzF5EZCDWgH0oKSVadA0C/h5qeUtrqd6uKmI2zIzUSkYlz6f8w89M
	6B3odoavwpPA36mMU8UR8NnUF6IjaeU=
Date: Sat, 7 Feb 2026 14:25:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770503155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I8cXVRM1MjFfGCcn+LNSZCYqmTLiBCqB1rk+ZLG2yCg=;
	b=CZWJUqy6/yKNBaJCV3jQG5wIJgpFGE3jFQP78cj+VIkpdIep3G/EdI/645wXW5i2tjSdO6
	COmIl5rITOG2hfiDTmEKWffT0Cwa2GgBnL5TvE0P9RQkCisyfIojCXPv5Z3BRsqTnaA2Z4
	YWjEtGtFYl31TUlJAB75veIdqP74V7c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, bhe@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v4 30/31] mm: memcontrol: eliminate the problem of dying
 memory cgroup for LRU folios
Message-ID: <aYe1R2MMcXbPVYUW@linux.dev>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
 <9e332cc8436b6092dd6ef9c2d5f69072bb38eaf6.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e332cc8436b6092dd6ef9c2d5f69072bb38eaf6.1770279888.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: rimrdgc7pkap73c3yaj9kdkazqxjwi7r
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AE8F4A0004
X-HE-Tag: 1770503159-36311
X-HE-Meta: U2FsdGVkX1+eTkK+LZHsYv4uNujb45aiKm98WrduSir+BvtLlWdqIPwnBqLELXCu+S4IG8QkwbtRHRfBTjWA/peYLbU2l367GHXR2BbYVSJ9K2kbI/bA0zNp05xfkZXgpfqrHSbo+sNKqBdVKzcO3KpxQUoUGkVRGVgsjtLMT6ctX5K10cU8+XEXeXl6Hrc8lRM95XC5oVlHR53YRQPdjxIO7I093m686S33NN2/Xd8xnj68Mwm1efJUkXgWiIItk3nXy3kk1FC1zZdEy883dXnvFVrqUCRLXWwcFtuqg8DwGwaD5U3QOP1BOyC3o8cOj1dF+ptVTV3Q7Ke/HA9TGkCdQxQQ3lZ4tprmkFBL30bLZTn/GKA0LZhU2/vNf1YpltK7YieSV15JMi3YvD42Bu8kIf2wF+v+oNs6LyC0S1ANTAJ0tRa1a2xSid2nT2RrhzAwDjtWmtMLDVbQgByFwG5gpQaI7/zVyg9i+1PmFlWqd/SZZDth52xr/0aYmKCabUO10J8MGc5efwzUYXq1xUAVkKFwKKsVaa3X0BshCaYu0OVnKTeOwyfRdo5YjLObNcvzV3wRmzZawURDztohZquWleCbvI50wSuHi2kVNPhRKtD9E4WBIpf6BxF6dqB/iYPjLfFA67Y93Ic0E9SiW8NEt4R6P2ncAc5eNhIf48b3UPvIxQMSaVhqK7LhgphiGhRR2pQ4PQllGmzoC7mqNG5dAPifdmygU/tcOscDngKtKMOmeKTB3LlImi5Y4u9KXB3ojSsz8BBM01AguPACPCtCZ8aAJlca5wuILqvdAv6M/3gi0a8vOA1MINm/oh2zPiuUOAasERIgz3+oYBsa91BC5VY3s7YY8kxuWJYrXdwflyBPsvkJpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 05:01:49PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> Now that everything is set up, switch folio->memcg_data pointers to
> objcgs, update the accessors, and execute reparenting on cgroup death.
> 
> Finally, folio->memcg_data of LRU folios and kmem folios will always
> point to an object cgroup pointer. The folio->memcg_data of slab
> folios will point to an vector of object cgroups.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>  
>  /*
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e7d4e4ff411b6..0e0efaa511d3d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -247,11 +247,25 @@ static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgr
>  
>  static inline void reparent_locks(struct mem_cgroup *memcg, struct mem_cgroup *parent)
>  {
> +	int nid, nest = 0;
> +
>  	spin_lock_irq(&objcg_lock);
> +	for_each_node(nid) {
> +		spin_lock_nested(&mem_cgroup_lruvec(memcg,
> +				 NODE_DATA(nid))->lru_lock, nest++);
> +		spin_lock_nested(&mem_cgroup_lruvec(parent,
> +				 NODE_DATA(nid))->lru_lock, nest++);

Is there a reason to acquire locks for all the node together? Why not do
the for_each_node(nid) in memcg_reparent_objcgs() and then reparent the
LRUs for each node one by one and taking and releasing lock
individually. Though the lock for the offlining memcg might not be
contentious but the parent's lock might be if a lot of memory has been
reparented.

> +	}
>  }
>  
>  static inline void reparent_unlocks(struct mem_cgroup *memcg, struct mem_cgroup *parent)
>  {
> +	int nid;
> +
> +	for_each_node(nid) {
> +		spin_unlock(&mem_cgroup_lruvec(parent, NODE_DATA(nid))->lru_lock);
> +		spin_unlock(&mem_cgroup_lruvec(memcg, NODE_DATA(nid))->lru_lock);
> +	}
>  	spin_unlock_irq(&objcg_lock);
>  }
>  
> @@ -260,12 +274,28 @@ static void memcg_reparent_objcgs(struct mem_cgroup *memcg)
>  	struct obj_cgroup *objcg;
>  	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
>  
> +retry:
> +	if (lru_gen_enabled())
> +		max_lru_gen_memcg(parent);
> +
>  	reparent_locks(memcg, parent);
> +	if (lru_gen_enabled()) {
> +		if (!recheck_lru_gen_max_memcg(parent)) {
> +			reparent_unlocks(memcg, parent);
> +			cond_resched();
> +			goto retry;
> +		}
> +		lru_gen_reparent_memcg(memcg, parent);
> +	} else {
> +		lru_reparent_memcg(memcg, parent);
> +	}
>  
>  	objcg = __memcg_reparent_objcgs(memcg, parent);

The above does not need lru locks. With the per-node refactor, it will
be out of lru lock.

>  
>  	reparent_unlocks(memcg, parent);
>  
> +	reparent_state_local(memcg, parent);
> +
>  	percpu_ref_kill(&objcg->refcnt);
>  }
>  
>  

[...]

>  static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
>  			gfp_t gfp)
>  {
> -	int ret;
> -
> -	ret = try_charge(memcg, gfp, folio_nr_pages(folio));
> -	if (ret)
> -		goto out;
> +	int ret = 0;
> +	struct obj_cgroup *objcg;
>  
> -	css_get(&memcg->css);
> -	commit_charge(folio, memcg);
> +	objcg = get_obj_cgroup_from_memcg(memcg);
> +	/* Do not account at the root objcg level. */
> +	if (!obj_cgroup_is_root(objcg))
> +		ret = try_charge(memcg, gfp, folio_nr_pages(folio));

Use try_charge_memcg() directly and then this will remove the last user
of try_charge, so remove try_charge completely.

> +	if (ret) {
> +		obj_cgroup_put(objcg);
> +		return ret;
> +	}
> +	commit_charge(folio, objcg);
>  	memcg1_commit_charge(folio, memcg);
> -out:
> +
>  	return ret;
>  }
>  


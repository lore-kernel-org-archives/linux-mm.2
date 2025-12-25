Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0275DE7AD40
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 06:23:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 958046B0088; Thu, 25 Dec 2025 01:23:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 905496B0089; Thu, 25 Dec 2025 01:23:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E7956B008A; Thu, 25 Dec 2025 01:23:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6F5B96B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 01:23:58 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EFFA8C1966
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 06:23:57 +0000 (UTC)
X-FDA: 84257002914.10.C0EAD54
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf04.hostedemail.com (Postfix) with ESMTP id E61324000A
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 06:23:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766643836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IbP2f/R12TjaQBuX1hHYDesZu4tjuOgvj8f+46cIh+s=;
	b=8dnbmSQFeEQ+pjTM/Lfhl8H6Hj2WRy9z9GjuwCJtGhg8tOWkrUk7Iw4NQc6ChgIKHLIV9j
	03/9ahovy8snRsKksVGtv1/6t/DM+N1JfXe9qH/ILspy59K0a27GsCU36KAAdyyb41e9d1
	5+fG5jmnL41GrZB0qa7Qteu//qz8aMA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766643836; a=rsa-sha256;
	cv=none;
	b=T2mz1WpyIBEfchupNE0++4n1LWaU3W4kzDFlzV8xeEgWLgPJarMIqVJELy5eyxltJ8142G
	70HxY6rc1z9IhW4D2bBF/87dsicGDMhOY0QoZ7Mrhv4q2KxUx2x2MRJocZpXZk1nc0cuOU
	EMMCOSwJQ1lJuwzh+/JAjI6CQ3k0TRg=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dcJbH616hzKHLxb
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 14:23:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C2EC640590
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 14:23:44 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgAn1vZv2Exp596fBQ--.65098S2;
	Thu, 25 Dec 2025 14:23:44 +0800 (CST)
Message-ID: <644493f5-46df-45f7-a071-9ae7faae1f5c@huaweicloud.com>
Date: Thu, 25 Dec 2025 14:23:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/28] mm: memcontrol: allocate object cgroup for
 non-kmem case
To: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <897be76398cb2027d08d1bcda05260ede54dc134.1765956025.git.zhengqi.arch@bytedance.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <897be76398cb2027d08d1bcda05260ede54dc134.1765956025.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAn1vZv2Exp596fBQ--.65098S2
X-Coremail-Antispam: 1UD129KBjvJXoW3Ary3CFyrJw4rGryfZF4kCrg_yoW7Ar1kpF
	sxGFy3Aw4rArWUGr1Ska9FvFyFka18XrW5K34xGw1xZrsIqw15tr12kw1UAFyrAFyfGr1x
	Jrs0yw1kGa1Yya7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	s2-5UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Stat-Signature: 9n6da3ib3jjzwiif9nb88cmkzxr3g4gg
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E61324000A
X-HE-Tag: 1766643829-381140
X-HE-Meta: U2FsdGVkX18s4ODwOQYNNsJHa5iVQTYzsjG+JZfTzTp8bMOJSffTuLvdruCZ4fXfbivTRRLtE4c+hoVMepOpreX1JcmGjlP0HzXuztUr2DHbMv9hyZ1AyNs+ZrIDOKD4LSidvs9yG8ZygpluLECTCfrbtMbqfBL+fAWH2QHfhHPYH/qrBWBJGS+TI8ZGr/NKoVw0m7JJCzaYd+5obDLLLBk2pToxnvA6yT8sAXf1uT1n7TZnvwlh3yHsdrF6+vIdZ9vwTQzY3eO+4IALEVjc2r5YGjvP/AsehQVSRgTG6pJ9jzHGt2ECKGKjdLuSP92nvwI6OeYIIXBg8gEP2ZBC/2O0MhzZg2v+2OS4oVk+KwvNhEw6hXW6cgH17BMP+ZEVK3Pe+FsOLU1mpT4yt0AGQT7sW/crX6K7mHnWCyeTlxOMfEV3ZrjugBzf0W9Ax/E5AJvccDgsXDHj4vQECTIuPlMOZR0q9HWVzF7kkRWpdVZYMnjnkdj+yNKsixpZifzyrB9ZdR7cmXf8i5QvhDGutOYJ+Vu00biSGivhLq2bz7uWM1KgDFAuZMbWpzsyzw3cIjTcF/0rHYfGq18EgWcdB0QzQRkziilyhtb4sZ49QjFRSr+H5P+O+6rSUY5RnHLBAPLCDe+OfdacF3jGXU88W8wAcYP1vGn4YIdojae9eLZjjwFrYgXI5D2OSgLgmni6UmjsygYpfQnZdAjZikSWS+Pg8s2qHyN1a+oOAIy12oQhtPQ3RxonicN0HRqhINmkszw0tg7iE9f7/FdG5zc2e96Ow8LMYqVNwknG8Ae+DqhI0StWyKMw4Uc10NY8+xaU7CjOdFLwbaLtFdrKBNNbZafg+m4wKV7dDrdHOLhM+0GrFEwxspP5uWQXWfe49FI7gTpyTSGqXtxgE8tFYeW7K1cLkPHOI2nUVpOt0Es9y6RdnKLyF/WBFcri8tkcEKA30s/tcure65wm8INhll/
 BAU8+g9g
 M+z0SM+710HbSfcDOWpHiRtNlECUbdBxamqrM3llpvZ8BIeXC6+ZJwf5FeD8hRwWL5FbQjjvAqJmZRVN15+2RMAbS99/VQGzttwMxa0Bu/FOnEH2lbsiVMZSu4SRPtXZLd/X3EIZzU0EMc2FRupNukzIl+4Hdm3VZUAA7RArA6v23H5+ay0Cl/1fEKl+JPYqtXOIs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/17 15:27, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> Pagecache pages are charged at allocation time and hold a reference
> to the original memory cgroup until reclaimed. Depending on memory
> pressure, page sharing patterns between different cgroups and cgroup
> creation/destruction rates, many dying memory cgroups can be pinned
> by pagecache pages, reducing page reclaim efficiency and wasting
> memory. Converting LRU folios and most other raw memory cgroup pins
> to the object cgroup direction can fix this long-living problem.
> 
> As a result, the objcg infrastructure is no longer solely applicable
> to the kmem case. In this patch, we extend the scope of the objcg
> infrastructure beyond the kmem case, enabling LRU folios to reuse
> it for folio charging purposes.
> 
> It should be noted that LRU folios are not accounted for at the root
> level, yet the folio->memcg_data points to the root_mem_cgroup. Hence,
> the folio->memcg_data of LRU folios always points to a valid pointer.
> However, the root_mem_cgroup does not possess an object cgroup.
> Therefore, we also allocate an object cgroup for the root_mem_cgroup.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  mm/memcontrol.c | 51 +++++++++++++++++++++++--------------------------
>  1 file changed, 24 insertions(+), 27 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ae234518d023c..544b3200db12d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -204,10 +204,10 @@ static struct obj_cgroup *obj_cgroup_alloc(void)
>  	return objcg;
>  }
>  
> -static void memcg_reparent_objcgs(struct mem_cgroup *memcg,
> -				  struct mem_cgroup *parent)
> +static void memcg_reparent_objcgs(struct mem_cgroup *memcg)
>  {
>  	struct obj_cgroup *objcg, *iter;
> +	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
>  
>  	objcg = rcu_replace_pointer(memcg->objcg, NULL, true);
>  
> @@ -3294,30 +3294,17 @@ unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
>  	return val;
>  }
>  
> -static int memcg_online_kmem(struct mem_cgroup *memcg)
> +static void memcg_online_kmem(struct mem_cgroup *memcg)
>  {
> -	struct obj_cgroup *objcg;
> -
>  	if (mem_cgroup_kmem_disabled())
> -		return 0;
> +		return;
>  
>  	if (unlikely(mem_cgroup_is_root(memcg)))
> -		return 0;
> -
> -	objcg = obj_cgroup_alloc();
> -	if (!objcg)
> -		return -ENOMEM;
> -
> -	objcg->memcg = memcg;
> -	rcu_assign_pointer(memcg->objcg, objcg);
> -	obj_cgroup_get(objcg);
> -	memcg->orig_objcg = objcg;
> +		return;
>  
>  	static_branch_enable(&memcg_kmem_online_key);
>  

Not about this patch.

Should we add?
	if (!memcg_kmem_online())
		static_branch_enable(&memcg_kmem_online_key);

>  	memcg->kmemcg_id = memcg->id.id;
> -
> -	return 0;
>  }
>  
>  static void memcg_offline_kmem(struct mem_cgroup *memcg)
> @@ -3332,12 +3319,6 @@ static void memcg_offline_kmem(struct mem_cgroup *memcg)
>  
>  	parent = parent_mem_cgroup(memcg);
>  	memcg_reparent_list_lrus(memcg, parent);
> -
> -	/*
> -	 * Objcg's reparenting must be after list_lru's, make sure list_lru
> -	 * helpers won't use parent's list_lru until child is drained.
> -	 */
> -	memcg_reparent_objcgs(memcg, parent);
>  }
>  
>  #ifdef CONFIG_CGROUP_WRITEBACK
> @@ -3854,9 +3835,9 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
>  static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
> +	struct obj_cgroup *objcg;
>  
> -	if (memcg_online_kmem(memcg))
> -		goto remove_id;
> +	memcg_online_kmem(memcg);
>  
>  	/*
>  	 * A memcg must be visible for expand_shrinker_info()
> @@ -3866,6 +3847,15 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
>  	if (alloc_shrinker_info(memcg))
>  		goto offline_kmem;
>  
> +	objcg = obj_cgroup_alloc();
> +	if (!objcg)
> +		goto free_shrinker;
> +
> +	objcg->memcg = memcg;
> +	rcu_assign_pointer(memcg->objcg, objcg);
> +	obj_cgroup_get(objcg);
> +	memcg->orig_objcg = objcg;
> +
>  	if (unlikely(mem_cgroup_is_root(memcg)) && !mem_cgroup_disabled())
>  		queue_delayed_work(system_unbound_wq, &stats_flush_dwork,
>  				   FLUSH_TIME);
> @@ -3888,9 +3878,10 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
>  	xa_store(&mem_cgroup_ids, memcg->id.id, memcg, GFP_KERNEL);
>  
>  	return 0;
> +free_shrinker:
> +	free_shrinker_info(memcg);
>  offline_kmem:
>  	memcg_offline_kmem(memcg);
> -remove_id:
>  	mem_cgroup_id_remove(memcg);
>  	return -ENOMEM;
>  }
> @@ -3908,6 +3899,12 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
>  
>  	memcg_offline_kmem(memcg);
>  	reparent_deferred_split_queue(memcg);
> +	/*
> +	 * The reparenting of objcg must be after the reparenting of the
> +	 * list_lru and deferred_split_queue above, which ensures that they will
> +	 * not mistakenly get the parent list_lru and deferred_split_queue.
> +	 */
> +	memcg_reparent_objcgs(memcg);
>  	reparent_shrinker_deferred(memcg);
>  	wb_memcg_offline(memcg);
>  	lru_gen_offline_memcg(memcg);


Reviewed-by: Chen Ridong <chenridong@huawei.com>

-- 
Best regards,
Ridong



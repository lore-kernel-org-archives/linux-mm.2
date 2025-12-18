Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBEC5D6D224
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 14:06:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EC6D6B0088; Thu, 18 Dec 2025 09:06:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 299AA6B0089; Thu, 18 Dec 2025 09:06:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17B6A6B008A; Thu, 18 Dec 2025 09:06:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 074F26B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:06:55 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A36895647E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:06:54 +0000 (UTC)
X-FDA: 84232767948.23.BE7E2CE
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7AED5140007
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:06:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=VWC0wSP7;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766066812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sR30ixwBE7Y68ILuHxMSkeae6AHX5P9JPZmuAQuOZlI=;
	b=Vr7sDDDEsXU6DKmECTLgqmerZHqWW3YY99AR3O5eZCup6LZS+z6nsqCTArM6I+IBVUfaQW
	OwH/J1YGb92Ngj38XFea6gLKbhroDsCYFFfPUSWwNK7AsmY62Nzdsfi3kHYi1phjU57kuz
	dDjTm3Dfn1DE+HXBN03P+CPSbvF/DM0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=VWC0wSP7;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766066812; a=rsa-sha256;
	cv=none;
	b=YU1FXbmdw9sxurtunMlj8uQTCxzXjjmbZcaBCMcqNQYm9tJCRBNde30dg5NnlRYOLzqJw4
	OSCif2kxvO7NJjeklztWk6GJ3KA3I5eK4otEMaud/CBZpD4ix/p3oaJdcIj5oXe6DnwXBi
	1r1VwBS/GVWwJFQ6L+ZW5Ebu5jjzF74=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8be92e393f8so69584385a.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766066811; x=1766671611; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sR30ixwBE7Y68ILuHxMSkeae6AHX5P9JPZmuAQuOZlI=;
        b=VWC0wSP79v9Nevc4IVgINXuJ8EtltgdkEcIEFl/neZOg2xo2j5/R2gTjCEKRxq1SZE
         myWu6R36MEe0d38WsO72LE9gPs2nm+WzCypEgHqAy8SwkrqBTwkv/NP7AD8b2an+kf0J
         T6TcKaIx6bo72bK8QrUHjHIfAP3mgdCGyojMswpwELvlM7XD7H2vOECcem2Q2GYvhA+L
         Qiej19eYyekIWSzv32oOs3EkIld18mNqup5K4h03hJ3DbnlFcSbuAMLKyNM+H7vUcKfe
         gEbUla5CIqbHkBtcRha8rVGRnWiRJfaoqGPZHCgP8WOCI9x/jsE5Sv4NWgNqnayYWaSt
         pZqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766066811; x=1766671611;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sR30ixwBE7Y68ILuHxMSkeae6AHX5P9JPZmuAQuOZlI=;
        b=kzIptFNRP/cKqP/K1vro9s6pOqJLjYU2Iilisz18FbpKNGjxxzec1yhD6WlPgV2B3Z
         sHQgGibOkGbTgr60ZQlumi25quuw+8BwsVifu8rlZT7Sj9KfUAe/wG7vygtAtzL2FyzW
         6k/w9ua5yR8CkxdW8ctIbPQVJazYzJiUSn3UF/Zd/nr2qsvYBVqdHXPJimEDzmW77zAR
         6RdLNM/lOewXDxqI+pv9WGnraB/+ekpuV7ByN1d1+nK2qQ9uF/stnL3PlxIMmhgxcB8o
         SuuuwR3QNx7QHiABFAnz6hW6cl0I+dfMe6kOgq9VhaElm9qBW8+kt6NX/0w281mYavBq
         RmrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQb+9xbGSybC4SKo0L5qEhdPwdmkDLCDj/137M08fdHQmD1XDJpWWQ8NN9KbVAp0qN8tioNvUc0A==@kvack.org
X-Gm-Message-State: AOJu0Yyj5t6oXAaYbkNj1ZbGNeHxn585J3dbvHLEq1L06JR/+ZoxUWIq
	Nar3O6QK5p2CHXB+fkIi9ZxCySB5nuvnoQ7NlFVj0bEgQsJo0VJLNfzfQVJzbO65jr0=
X-Gm-Gg: AY/fxX4QaqxWDi8FtloORl597I2HfEypbScaWPX76I0wEHZjBQd8bCmaYfV/jZmB9WY
	XFrC5UxQ3LND9ptUF6JV6IhaYuxj7i9eYrYRoeXwkh433e7Kf62yU58o5qLZyxNtkexAEIbz3SL
	ljPZUgzTxV8L2SJW7x+T4KXq/8wkEFabguy5t2EKKVNGzrzqxuWDV1vJxdyHgfH1nUeVKcFfPpR
	hf0qB1/4t+QTlz5ni7yORhAZGq+8BCTPKTLVKytKMdM8Htovm7ONQ6ZtkN+uBH3vYG2dw0R7v5e
	w1PJEPETPjTfwHzKhpDCOqcHMyVaHSnYqxlxXoNlmBpzUR95zG44+FTa4JI6tODQsdfmVvxLFBB
	VO/vU763RUHwSMkONHB6d4h9LEcSasVaSx/9p4FK4hWv0HbSgEHK24bJ5clLiKoU1HhiumY1AFw
	pYDM90rqum2g==
X-Google-Smtp-Source: AGHT+IHGiY8Hg/MD1OdXod9gyMroAAQViBd9bZlpYzLebqdk9FpWA5fcGAjVIG5zyNvPrE0drHPDtQ==
X-Received: by 2002:a05:620a:400e:b0:8a3:90cb:9224 with SMTP id af79cd13be357-8bee670c438mr434656285a.2.1766066811117;
        Thu, 18 Dec 2025 06:06:51 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8beeb5f2911sm168014685a.17.2025.12.18.06.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 06:06:49 -0800 (PST)
Date: Thu, 18 Dec 2025 09:06:45 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 27/28] mm: memcontrol: eliminate the problem of dying
 memory cgroup for LRU folios
Message-ID: <aUQKdZsMclicBDYx@cmpxchg.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <c08f964513f9eb6a04f80f1a900e3494a99b7e0d.1765956026.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c08f964513f9eb6a04f80f1a900e3494a99b7e0d.1765956026.git.zhengqi.arch@bytedance.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7AED5140007
X-Stat-Signature: fimc8wgrwha34g883sug5zmqhchwwsk6
X-Rspam-User: 
X-HE-Tag: 1766066812-745949
X-HE-Meta: U2FsdGVkX1+akHMOZbzYRWWH6zsdKegSA2eHYe47lMU5IZ7dGZRgZ0f+L8e21wqJrVGIJsJ+rVXKPfDwVk1mItJFEeLuMwCLHcxOV+hiMZaG0N98XKh7jJX7hBMKdMf7MdVZJGuSR+7LoQgzanCt+Z3kYk/gCd2xLXauDROcG5DCP1VWaEc+KGCYBe1bIWA1MBJdp2pCd9HdxhJxiVLZvAqk7fp9uSO3VmVsT0jsUG0yoPeXZiJRXse48Q/TTianzSqd2x8inExdVrHfgXzgFHd/qPImDH11HBfv0BxgTwY3wgHuWuvfg7UVsCfMgwP58lnq9ei1OIl6yp5KCA/urDuaVVOeXRPSXyJn/rrAK884xdLnuTLfpRRQ8ydGO0FAydf5zzZH9Vq8lFL9TLt6BhIrzFApOWeE2aRnlToRZWLbs6fl170c7odCPmIqNsPEgoN6tQqGurQIlBAm8ZhPeX5sLIoz2eN8rQtUArVocJ+s3O41A6UgOsMa8PnTgKxoq7NNrj4L1R/+JNfRE8N7CPLcN1BEvraPj6LrexvbnpqM2VROn0/oJ8Fd/8YQxk7j9LdV/XOa33utPvpLvgHo3VlFVnRPfqjtOV8UupzObvw9X4o0moA593LkMYqig3o2COfIzLew8Yzl4H20d5RdVm14yUvjTIaEM4OxanbIfLhGBI5cA5oYuHsDWGN5W8vQwMtsrdq0dSPownQCQk9q4/WiMn3tmR4xC5dHyNLlHYXDBgGtTsbY4U/qG5njTjaa+P33MLmge//Qkr2Nk8KvowjoZ0G2rwoZVYA1djaFTF4BkH+n40BD2QNLqbl0eQQW99XZvn4WQUg4F9KZwe6QWSA2NoDLScFY5zNTlWuS+c8Skr2xageGXCznC4C7IM1+V2zhkkZh2zfQGpWvMHWARneTXSMFYn1hElB9ylGhaVPuR0moej6b2zyHNKncjTb9/jb2wn2aoqNAl2mWybg
 7kZjJqEh
 0kS7qizVOCse2vSOhj20vvoiNU5kY5xanak3l0AdARquIUSxuExTQ3DXtnQIa+Q7wIzPX9PAwXkUhJKMsZzXgVo8LVuxNawQ0qRAJbnXGBmSnO5lw3unyz6oRlK3+T1jT9iC8UbzM54enH4//HfbyZJhHYU9gfga/MV0065VtfKOeA/5Pm1i0j6jbVnKnrHq7LvUCsbbtSe9OKGS/X3AzMi4KoPEXeHQgTMUUyl+KYRfqmB+QTV/jXYb+NX8WMZaLCRZhns/8cCgJDh/KD13z4o3JfHjxj/O+kBeu1FJeAwSZRn/20jaSvb+PqfrQvy2KVtEbzkCJlbG4K03jjouXR226Yik9J/68UbXoeXW0zy6O6+e71qLZUyyO+OujXpgeEOEj3ws49WU+FzcsoIXxt0AX9V9w0KLXqXZrswrw8KkBxhI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:51PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> Pagecache pages are charged at allocation time and hold a reference
> to the original memory cgroup until reclaimed. Depending on memory
> pressure, page sharing patterns between different cgroups and cgroup
> creation/destruction rates, many dying memory cgroups can be pinned
> by pagecache pages, reducing page reclaim efficiency and wasting
> memory. Converting LRU folios and most other raw memory cgroup pins
> to the object cgroup direction can fix this long-living problem.

This is already in the coverletter. Please describe here what the
patch itself does. IOW, now that everything is set up, switch
folio->memcg_data pointers to objcgs, update the accessors, and
execute reparenting on cgroup death.

> Finally, folio->memcg_data of LRU folios and kmem folios will always
> point to an object cgroup pointer. The folio->memcg_data of slab
> folios will point to an vector of object cgroups.

> @@ -223,22 +223,55 @@ static inline void __memcg_reparent_objcgs(struct mem_cgroup *src,
>  
>  static inline void reparent_locks(struct mem_cgroup *src, struct mem_cgroup *dst)
>  {
> +	int nid, nest = 0;
> +
>  	spin_lock_irq(&objcg_lock);
> +	for_each_node(nid) {
> +		spin_lock_nested(&mem_cgroup_lruvec(src,
> +				 NODE_DATA(nid))->lru_lock, nest++);
> +		spin_lock_nested(&mem_cgroup_lruvec(dst,
> +				 NODE_DATA(nid))->lru_lock, nest++);
> +	}
>  }

Looks okay to me. If this should turn out to be a scalability problem
in practice, we can make objcgs per-node, and then reparent lru/objcg
pairs on a per-node basis without nesting locks.

>  static inline void reparent_unlocks(struct mem_cgroup *src, struct mem_cgroup *dst)
>  {
> +	int nid;
> +
> +	for_each_node(nid) {
> +		spin_unlock(&mem_cgroup_lruvec(dst, NODE_DATA(nid))->lru_lock);
> +		spin_unlock(&mem_cgroup_lruvec(src, NODE_DATA(nid))->lru_lock);
> +	}
>  	spin_unlock_irq(&objcg_lock);
>  }
>  
> +static void memcg_reparent_lru_folios(struct mem_cgroup *src,
> +				      struct mem_cgroup *dst)
> +{
> +	if (lru_gen_enabled())
> +		lru_gen_reparent_memcg(src, dst);
> +	else
> +		lru_reparent_memcg(src, dst);
> +}
> +
>  static void memcg_reparent_objcgs(struct mem_cgroup *src)
>  {
>  	struct obj_cgroup *objcg = rcu_dereference_protected(src->objcg, true);
>  	struct mem_cgroup *dst = parent_mem_cgroup(src);
>  
> +retry:
> +	if (lru_gen_enabled())
> +		max_lru_gen_memcg(dst);
> +
>  	reparent_locks(src, dst);
> +	if (lru_gen_enabled() && !recheck_lru_gen_max_memcg(dst)) {
> +		reparent_unlocks(src, dst);
> +		cond_resched();
> +		goto retry;
> +	}
>  
>  	__memcg_reparent_objcgs(src, dst);
> +	memcg_reparent_lru_folios(src, dst);

Please inline memcg_reparent_lru_folios() here, to keep the lru vs
lrugen switching as "flat" as possible:

	if (lru_gen_enabled()) {
		if (!recheck_lru_gen_max_memcgs(parent)) {
			reparent_unlocks(memcg, parent);
			cond_resched();
			goto retry;
		}
		lru_gen_reparent_memcg(memcg, parent);
	} else {
		lru_reparent_memcg(memcg, parent);
	}

> @@ -989,6 +1022,8 @@ struct mem_cgroup *get_mem_cgroup_from_current(void)
>  /**
>   * get_mem_cgroup_from_folio - Obtain a reference on a given folio's memcg.
>   * @folio: folio from which memcg should be extracted.
> + *
> + * The folio and objcg or memcg binding rules can refer to folio_memcg().

      See folio_memcg() for folio->objcg/memcg binding rules.


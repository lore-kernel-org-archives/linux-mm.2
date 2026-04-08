Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57735105D999
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 02:40:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F4026B0088; Tue,  7 Apr 2026 22:40:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67D866B0089; Tue,  7 Apr 2026 22:40:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 545446B008A; Tue,  7 Apr 2026 22:40:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F4CB6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 22:40:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D7A2D1607E7
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:40:32 +0000 (UTC)
X-FDA: 84633835104.28.9607897
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 15A234000C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:40:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YQTM5ksY;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YQTM5ksY;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775616031; a=rsa-sha256;
	cv=none;
	b=cfxDP2ZA0GE56ZLByp/GfbtOGrDHfW3Vj40zTvLhHQF8fZAPlraxuqQQF3kgm1249oRYBl
	8AdYF+1KthNuQj/Ro1unKjjxzPHGFz3p11FjaO3CuAYWYGNiRCL0g3Ra6AooERNAHgn1Zl
	ZFnbrohQI5sx5f5KNMzVsAMdeS31VyQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775616031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tIfwAjkIZ5kzYGnsoXX7VGO6FjtcXNqioX8S8AQDjvo=;
	b=kmvWxJZek6eRh4LJqIXj7J7/aIqIkiiPVwt0J9dneT+YRI4PKGefIzwTJFvFcQC0cv7Nd3
	LH8Cfw+bmQ3k8hecaYYSJqJHJ4ZuyVdOXMNidp9xXsV1E/zRrNkWNbmFRq5X1l/cKrUPuk
	VXJ6suZkW25CtJVEnYVlhqn7yVfyzJs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A42D4418E;
	Wed,  8 Apr 2026 02:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93949C116C6;
	Wed,  8 Apr 2026 02:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775616030;
	bh=EUzf7XILl/73QfjDDoALzxB1Kjg3AYvxj5Nc0rcI6wY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YQTM5ksY/zhLyKmTxaZ1GRwI6jIeVneI2kjQUcsN/o5ADMABGMhtZCUK1M46ink0v
	 BryrEsxfwPmUbf+Gvm2ojjHaaWpnfN86ju3tLvcQH9nXrUB3RNzHQ4s1aO1WFOY0B/
	 rxNTqQzvsLUFn6xnCF1exq3eL5qffV+ESyGbinSEZ/zyxdS1eE3RDg/yj+Iv1tu5Oj
	 qKhaT68or7BNSfk/eTsZRnagEaNJGSz4Fm+vS5K++j2iR7vbVkHW+DPy9Mfjr/OdA6
	 D6aiilcxvPA7PE32tFziJiHBdfVpA41IXwHtFZGpCdP+XQ45y8C1TJfmrelyNZq35m
	 qINs1+gtkboFQ==
Date: Wed, 8 Apr 2026 11:40:27 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>, Yosry Ahmed <yosry@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm/percpu, memcontrol: Per-memcg-lruvec percpu
 accounting
Message-ID: <adXAG52R6WVHd0n9@hyeyoo>
References: <20260404033844.1892595-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260404033844.1892595-1-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 15A234000C
X-Stat-Signature: jqs5h9sui5jjd6kdpzc1psyddeo9o7nm
X-Rspam-User: 
X-HE-Tag: 1775616030-872325
X-HE-Meta: U2FsdGVkX18tlGR7WmPd37CKMD6ldBMz1Of+AyKLo3hz2ZzZMVq3AkpJvY3KA54YBTkRBrwJkdB42WsqZoR+o+38rJhrRR0+nXQn7hDJPdJqc6mevB1gg//cn7OWgaqXHJBLefYVe5RwINOlE9T1z7pbOBz1JBFA3d1Zszr0768q1xeogfHeNfTBJ2Bk2BTB74IJRnS9bgvf60AvSnphx7S9aIH+NWLjrPRRmoGmBA+Lz9VDjofegS1yLcsavweNJwA7ZLedBK6V5DEGVrHd/JV/KWoIPakBM72JMfHNQ33GlPlXAcosHGDRrIT8a4UCwslek4GwmAfWEa1FH4Dl0lG9bKtqoRM8kitAbY+g/objyJAJVUQQQbmjuTbCqOWqJlpIhO6V9fnc6/zBmviWaUvREonZHm+YFO+9D+ZfAkhDdKeKE6CBhDMEjN8PvHZh4D0zD+B3RI4nFzrc0q1wci9YX+hR+OymfkgGvGBuI9S2KlZXm2bD+UxpD0B0RjCGZEp1zcZ4VgxSwxywoTIKDLShwCmSF+1A9zkHC9nDZPjRr/GbrFaeyKvvNOVh65mi+kO7S8Qcsuarg3PL0dgmP/Mkv0MPsCNM7YWkHfABvgFhmK748wT51eXvlIiShLk5BGCX379xY51ZtHFpJ4kdeza0eCtPodHskizeozSk68IAYgnWycuj2jLBciMcygT+ue4OUY80DVuD9UTSkkrANoxt5010VFodLxqHEpNdiRLBvB08R33U1mzA3b/saqoVsXOo7SQkLT7JpJIDRUUhtUJeZ2GnUxQBTask0RBvQlvX5XpnAsz8BxiYdID8G5DfyDf83185clIsDPYZuFiuPgPjZk/MCk4dmziYgMppc7SaJjKP4vHc0BbofvDt9nfn/PgC/2ceXV+yi6SLCNHdGZcDUePOEW+Wpy89zSfkdrqFQDAE0mweP00iX6hbZo28t/VQUsdyUbGgWCw9zKL
 kdUGLhqz
 N6VyD1qrgsosnB7QTQBjSCfu72QO10RvqJuJF/YqCb1nzJ+/l+5BO4+jKDWysujKHV9Dfd1/8dqgsjbbMEm8KAPyA4ZfrAhrVnnwthO/K0ArPN7IkRRIRgWCnkfESCumhV0kgjS8YY4LtdkV07FJ98WtdWIiAV0b1z2FA6lLKP8FOxV6Ngqk7uLznETvrj0uJhDMutNjshBHORnfsJIUlVhOwhr6e3OZznPrJCDcyMLX3mrFRcDU87KADH0VrYjp2cChGoaBcm4Kd10vysVrCl204M1gpv5t5gWm6PeqZcYJQnQBSLGBUrImjZbifg9zwMOiOoCfp0I9zdW02vAREoBlqdDWh/SgfNgmx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 03, 2026 at 08:38:43PM -0700, Joshua Hahn wrote:
> enum memcg_stat_item includes memory that is tracked on a per-memcg
> level, but not at a per-node (and per-lruvec) level. Diagnosing
> memory pressure for memcgs in multi-NUMA systems can be difficult,
> since not all of the memory accounted in memcg can be traced back
> to a node. In scenarios where numa nodes in an memcg are asymmetrically
> stressed, this difference can be invisible to the user.
> 
> Convert MEMCG_PERCPU_B from a memcg_stat_item to a memcg_node_stat_item
> to give visibility into per-node breakdowns for percpu allocations.
> 
> This will get us closer to being able to know the memcg and physical
> association of all memory on the system. Specifically for percpu, this
> granularity will help demonstrate footprint differences on systems with
> asymmetric NUMA nodes.
> 
> Because percpu memory is accounted at a sub-PAGE_SIZE level, we must
> account node level statistics (accounted in PAGE_SIZE units) and
> memcg-lruvec statistics separately. Account node statistics when the pcpu
> pages are allocated, and account memcg-lruvec statistics when pcpu
> objects are handed out.
> 
> To do account these separately, expose mod_memcg_lruvec_state to be
> used outside of memcontrol.
> 
> The memory overhead of this patch is small; it adds 16 bytes
> per-cgroup-node-cpu. For an example machine with 200 CPUs split across
> 2 nodes and 50 cgroups in the system, we see a 312.5 kB increase. Note
> that this is the same cost as any other item in memcg_node_stat_item.
> 
> Performance impact is also negligible. These are results from a kernel
> module which performs 100k percpu allocations via __alloc_percpu_gfp
> with GFP_KERNEL | __GFP_ACCOUNT in a cgroup, across 20 trials.
> Batched performs 100k allocations followed by 100k frees, while
> interleaved performs allocation --> free --> allocation ...
> 
> +-------------+----------------+--------------+--------------+
> |    Test     | linus-upstream |    patch     |     diff     |
> +-------------+----------------+--------------+--------------+
> | Batched     | 6586 +/- 51    | 6595 +/- 35  | +9 (0.13%)   |
> | Interleaved | 1053 +/- 126   | 1085 +/- 113 | +32 (+0.85%) |
> +-------------+----------------+--------------+--------------+
> 
> One functional change is that there can be a tiny inconsistency between
> the size of the allocation used for memcg limit checking and what is
> charged to each lruvec due to dropping fractional charges when rounding.
> In reality this value is very very small and always lies on the side of
> memory checking at a higher threshold, so there is no behavioral change
> from userspace.
> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  include/linux/memcontrol.h |  4 +++-
>  include/linux/mmzone.h     |  4 +++-
>  mm/memcontrol.c            | 12 +++++-----
>  mm/percpu-vm.c             | 14 ++++++++++--
>  mm/percpu.c                | 45 ++++++++++++++++++++++++++++++++++----
>  mm/vmstat.c                |  1 +
>  6 files changed, 66 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
> index 4f5937090590d..e36b639f521dd 100644
> --- a/mm/percpu-vm.c
> +++ b/mm/percpu-vm.c
> @@ -65,6 +66,10 @@ static void pcpu_free_pages(struct pcpu_chunk *chunk,
>  				__free_page(page);
>  		}
>  	}
> +
> +	for_each_node(nid)
> +		mod_node_page_state(NODE_DATA(nid), NR_PERCPU_B,
> +				-1L * nr_pages * nr_cpus_node(nid) * PAGE_SIZE);

Can this end up with mis-accounting due to CPU hotplug?

>  }
>  
>  /**
> @@ -84,7 +89,8 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
>  			    gfp_t gfp)
>  {
>  	unsigned int cpu, tcpu;
> -	int i;
> +	int nr_pages = page_end - page_start;
> +	int i, nid;
>  
>  	gfp |= __GFP_HIGHMEM;
>  
> @@ -97,6 +103,10 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
>  				goto err;
>  		}
>  	}
> +
> +	for_each_node(nid)
> +		mod_node_page_state(NODE_DATA(nid), NR_PERCPU_B,
> +				    nr_pages * nr_cpus_node(nid) * PAGE_SIZE);
>  	return 0;
>  
>  err:

-- 
Cheers,
Harry / Hyeonggon


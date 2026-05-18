Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95942CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 06:33:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00EBA6B0095; Mon, 18 May 2026 02:33:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F28B66B0096; Mon, 18 May 2026 02:33:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E65DC6B0098; Mon, 18 May 2026 02:33:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D4B1C6B0095
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:33:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 965EB1207BD
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:33:06 +0000 (UTC)
X-FDA: 84779573172.03.FE61C86
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0AA18C000B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:33:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A3vbnwtY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779085985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8hoVVQX5GGfVZM3bJC5rTA6C0DO6UtYhorjVBYvKY9o=;
	b=Wd0t62W0qL+rAfzDej7iZMl+FWU1zpAdcmMtj3LK+sPo//TL2m+Uj6c6eq+klyfSOYlQfL
	7XA4Hg3+nkRFvWUrcO9cIjhyc7IfJvMeZPoky4T79i1cZtgPf4hRRJTxKCaGE9p5h8QFVX
	GyaHQYtCUIcccE4NZLLLlJ+lFbOBsE0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779085985; a=rsa-sha256;
	cv=none;
	b=wBzMIvgZufLbqmWuh07bdNR5nFWO9TM5xR2WvkKMH5KkCiNiAaKcC2wq/eJm84cEltF4pV
	edH/M0m8+LYHokQCWMR+U5KEhFK6yWy65yI/lzuaZwyt6YlAK4X+eaDU+H59ABN68fj0na
	fCH/d9g+sYmTxLHk23StW+QUOUdFEHU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A3vbnwtY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 73A3C60125;
	Mon, 18 May 2026 06:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D55C2BCB7;
	Mon, 18 May 2026 06:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779085984;
	bh=S2sClfE94ut5IkvWCJnZ59x+EGHZ68WYDg9Kv6DqmJQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A3vbnwtY1jjob8OB+9vfc+m48DDecf8TZJhaI+N4f3RrrLwJHp/4Tug1PFa+XpC5F
	 pm2bqTF26qb+29HPgfCbtfimbDEpQ810OrtiD2Ic0aRdx2T+HgPhUZELfT/ucfCXbC
	 0F5Jig/3OUfsNIff63F1zc0Gq0kwYCUK+E+5X7N7eOfZmxW8oRULsyn56z40rP0xLO
	 SKN+6oE2IOuh1dWyBzSx/ULcbvNfyz0hXDpXbs2MNBXKxWKkiD/yIzkfgf9eW+6xi7
	 L7xR4PUvkcTl8FGh/hrjI3nJrsXrUuXalZ9bkPlN+LTFscIRfEaDPDJsn8gmRGCHRy
	 T64q9br6Bv4Fg==
Date: Mon, 18 May 2026 08:32:53 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 08/69] mm/mm_init: Defer sparse_init() until after
 zone initialization
Message-ID: <agqylYzVJIz-81GL@localhost.localdomain>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513130542.35604-9-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513130542.35604-9-songmuchun@bytedance.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0AA18C000B
X-Rspamd-Server: rspam04
X-Stat-Signature: 766w1g513x5ngrztp5itoni7hjasfg3e
X-HE-Tag: 1779085984-612905
X-HE-Meta: U2FsdGVkX1/tM1pb08I/3IwkDXvTtslYUpB/a1JOEXvO/YbKFLSlz5vfqjFjJDb3nJn4jOsKE/tlrpFxSRP4CYcb1CpcYOLjdf46vPoi16cBbceam6zkMOEEfoB5YaDF5xQo79W9T7sPxO3uJhV0dNL6rDmCmG46VD9+vDk6wyRcn/hFupi0nDcuWh+NEHuMtJaNHYCGJmpfY1EutzZJ1N61eWpGUUWk/PC2Zp6ouBXo6ApVvxvs2Kqc0neR1kozKCdDZ4byHisb8+ZGlZlI3svbSihnESVfbhca3SmV7MxOZpbqQLzWlkfimZoQbTAZ06K1PDKoLuuuJZ3CN5HsZvo24icnzOGW3OyvAjd+NtKKx35eg/pvj8aHox4POIC7J9NnLidAnkMhmQoSaeBhLb1WBQG+Ro55pVW+FDdRJPPTvi1F0OlTZvltdA8JlDgRnbrzhOXENommXf7xrDAxtzvQgAGDgo5b/2b4b+JjIlkAonumwkP900I+QAg9iqKWXUzhTb25x4PCVMgAbCX+nZ+J+AHxg6OyA4KKQHVKsCDKJWsTMPtTI6WL4ftBzg1mskWUyPuAHfnnazMQmEaCsFO+g+CtKJAXwEJHUuT+hjULZubflmUn5xeW3dNZCdvQ+XqE78E2hI0BJsFBiKYACjXbMtdeTcZ4jHyBUca51Ia06fSQI+jY+URaKdlZf0vpMc8pEGaTT7fuxNQzilbM37/+YkU/mnuhq20DdogKFl3HzMtDWCav/xDv2GXQncPVKcS/rBgz3JRNgFk+Kkd1dZeSf13hzedEYPz/YKcyaUdtKtPOFBNJKWqv9gzSf8IPUT47ztMzrzVgrwzyv02dyv72g1xy7CU1lpdqu59F0hRfuZxz5cj3j3TTsA9MLHkwrsUNABmaTJyCz+YTkwuS7oV7zNxOBmoAVASiuaUjr1nbkp0UW0Dxu2IRkmIEvHU+68uSUjTRCGxubTrJCB4
 K474Fu49
 8ECnU0vfnEOqsO1Eqpap8PIb00fFgJIliNOTOZf2vZmz0f/RK/pRTVpauNVUIY9kji23LUKNOXSQZltFMa258PA67KMJMYi68N8lirxVngQ+Ecs5QCWIeNrMsxHN8cCix18npfj4Hc4aZtbt9Bmw28oZvmXG0WOpHzPBk/HdmPGz5cOnhZxR5ouRQfVSpLFimviMiOWcFy2h9Tal1bmwmHL9TepGG+PdZ6PYQbm35qcmg6lFcW666sQ3108fMjV7TKu+HPOvrCIoS5tBKqAtojrjC5DG9W+JvArIGSAvrqJbKJDQJA3bWrKjSBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 09:04:36PM +0800, Muchun Song wrote:
> free_area_init() is responsible for initializing pgdat and zone state.
> Calling sparse_init() from there mixes in later vmemmap and struct page
> setup, which makes the initialization flow less clear.
> 
> Defer sparse_init(), sparse_vmemmap_init_nid_late(), and memmap_init()
> until after free_area_init() completes, when zone initialization is fully
> done. This keeps free_area_init() focused on zone setup and ensures that
> sparse_init() runs with the relevant zone state already available.
> 
> This is also a prerequisite for later hugetlb vmemmap changes that need
> zone information during early sparse vmemmap setup.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

> ---
> v1->v2:
> - Restore the set_pageblock_order() change suggested by Mike Rapoport
> - Add Mike Rapoport's Reviewed-by
> ---
>  mm/mm_init.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 12fe21c4e26c..c14491c2dad3 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1826,7 +1826,6 @@ static void __init free_area_init(void)
>  	bool descending;
>  
>  	arch_zone_limits_init(max_zone_pfn);
> -	sparse_init();
>  
>  	start_pfn = PHYS_PFN(memblock_start_of_DRAM());
>  	descending = arch_has_descending_max_zone_pfns();
> @@ -1915,11 +1914,7 @@ static void __init free_area_init(void)
>  		}
>  	}
>  
> -	for_each_node_state(nid, N_MEMORY)
> -		sparse_vmemmap_init_nid_late(nid);
> -
>  	calc_nr_kernel_pages();
> -	memmap_init();
>  
>  	/* disable hash distribution for systems with a single node */
>  	fixup_hashdist();
> @@ -2691,10 +2686,17 @@ void __init __weak mem_init(void)
>  
>  void __init mm_core_init_early(void)
>  {
> +	int nid;
> +
>  	hugetlb_cma_reserve();
>  	hugetlb_bootmem_alloc();
>  
>  	free_area_init();
> +
> +	sparse_init();
> +	for_each_node_state(nid, N_MEMORY)
> +		sparse_vmemmap_init_nid_late(nid);
> +	memmap_init();
>  }
>  
>  /*
> -- 
> 2.54.0
> 

-- 
Oscar Salvador
SUSE Labs


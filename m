Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44799CD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 17:26:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7034D6B00AC; Wed, 13 May 2026 13:26:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DA966B00AD; Wed, 13 May 2026 13:26:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C9FF6B00AE; Wed, 13 May 2026 13:26:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 477266B00AC
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:26:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB86FC1354
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:26:36 +0000 (UTC)
X-FDA: 84763075992.26.13B1BCF
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf26.hostedemail.com (Postfix) with ESMTP id A4818140003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:26:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf26.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778693195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YmdJyBD2npGIbt/vPatMjWOfxgvZmddpOd7Ocmz5NXQ=;
	b=wzaz9kELRvVYVoITxzZ1AGMiur1yHFiCqrtvECDRl9IcXCsbwbEa9srHPzJtLPDt/HrEhI
	szoud1SgEp3AHgwb4EppzraZNdxpkS+V6bjgcggBBxhzgn7E0BVCqv/9k8dogjwI44wlid
	7QcWKo48w07v1+tCkgCRKW5frX85DiM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf26.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778693195; a=rsa-sha256;
	cv=none;
	b=GDNTeqAeJ/JOmDGdYEsdBq/h95QoHE/Qtwa9VbQVmfdzrmV2GJLeVSMdDDIMGgKEjEgKKr
	cq8UEx4cg0pAhIeFwhzmhqd2frOqJ7veiueiTyR9leOySuj4K8Y6VpbXPfFraKzj35ZUFu
	6btByAE9Ihm83tHqmGU0qoaebk0CQt4=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 14 May 2026 02:26:29 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 14 May 2026 02:26:29 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, Yosry Ahmed <yosry@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>
Subject: Re: [PATCH v3 04/12] mm, swap: add support for stable large
 allocation in swap cache directly
Message-ID: <agS0RbXpVMcYMI3g@yjaykim-PowerEdge-T330>
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
 <20260421-swap-table-p4-v3-4-2f23759a76bc@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421-swap-table-p4-v3-4-2f23759a76bc@tencent.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A4818140003
X-Stat-Signature: t6hg5tm54wur578t968ih9rw4pa9in8g
X-HE-Tag: 1778693193-256998
X-HE-Meta: U2FsdGVkX1/coICOEO4lZbHI78TO5WINUJmRsT7KeLwA64wnVIYE+WahXYdcfDccK5uXBqFp7GokEaRXVRfmBXlDDNjmVj0MmUHpCYcT93Q+MuQdn4elOZWWm765bhuCpEtGWNYqX8MYvf82D057VyDQ3Y3mwkGBzbfx63EFFoH+e+Y6VpyK9K5vgKB0fkWVh2DSb7Ioy7/zhkTxv+gNxaZH8MS20mwVHpp5gNMeRYwwVIK5VATOk3gLK4jEsyviZS9/uNAooKyp3qDtU2zlclUZvxopJu360/sSIc6qcdFh+6qU0JM5s937c+G4Q08X6YdfVqxjPe85iws+tG5d71gilcMZzvgzmePYr52H0dNZWbGgePrCm51ESHL+RobF9d3x3eDhFf+K3R2h+JPNjWFwp3pwAkOJbj9t+e7mMAWZdyPxDjovwxGxdZLSywoRld2QJP3TA0Iqc0krkipYGQW+WsFg0XrMIiGbW9sdurd1pR07SKG6vAn04J6bR6V10qPsagPcDh4pKt36ajxpqFviDMvHJeLK+malCoAxDBNgJX03Pa0da2XloXKCw8dc/Z/laVCP7thOcg8oOhnDNOcQj4ld0T9ARp9ofuBYGGIPYzhDMhfnp1eFiKh2ge84r7pfLwMadSQjD+kzdzjKURjx4zB0W4TOB0evWYdVNLDjWUM3vHtDNUoUIz+Wwybyvlb14kM+Sk+3ybU9bD29lz25t1JO/BkNuLzRpL5VfbT4YP5jpRIoUaJWrMawG52S0rCfPjYzkRV3D/5qZxOBI4XVpKXcvD9cLNsDpnD9//8DHfWaSujjWVWkwyIuUP3TK/SwsWB+6UdJg+7SrsOCruMwILG5TIroWf2e2Eh/mmqs2CVexrnVC7y3nJtoxQ5UXPhWLUrETP7ptKPA+NAJ+HBpglNdtr3rUxB8KdUvRLxmeDvGGWNqAhMIc0dmcQn+uF5TTW6FxEkJ7swePXH
 X1MKnnmS
 BqOlXGL724oawPQAO1fyi7Vgk+n+mO5I79KOB4SXwucKzU/HlHiCd33b/yvU7ErN5BO8B11xiaxjOLtFIG3P66zFwhfTb8NQVyYS/uytbjlWa3MJDbdArit4l+WDFArF2BgHw8qH4q6bvBmptRj+xdal4munZlrrg5qhjBqiH+qrF6yEahJ4eZcOcU4lzNnfU5nY1S95yPAAAukvPTle6Ophd0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 02:16:48PM +0800, Kairui Song via B4 Relay wrote:
...
>  static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
>  					   struct mempolicy *mpol, pgoff_t ilx,
>  					   struct swap_iocb **plug, bool readahead)
>  {
> -	struct swap_info_struct *si = __swap_entry_to_info(entry);
>  	struct folio *folio;
>  
>  	/* Check the swap cache again for readahead path. */
> @@ -594,16 +700,12 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
>  	if (folio)
>  		return folio;
> -	/* Skip allocation for unused and bad swap slot for readahead. */
> -	if (!swap_entry_swapped(si, entry))
> -		return NULL;
> -

Hello Kairui

With the swap_entry_swapped() check gone, the swap_cache_get_folio()
above the do-while is now just a duplicate of the loop's first
iteration. Might as well drop it (and the now-stale "again for readahead
path" comment) here.

Best regrads
Youngjun Park

>  	do {
>  		folio = swap_cache_get_folio(entry);
>  		if (folio)
>  			return folio;
>  
> -		folio = swap_cache_alloc_folio(entry, gfp, mpol, ilx);
> +		folio = swap_cache_alloc_folio(entry, gfp, 0, NULL, mpol, ilx);
>  	} while (IS_ERR(folio) && PTR_ERR(folio) == -EEXIST);


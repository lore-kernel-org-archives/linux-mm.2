Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47D70FED2E4
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 08:45:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AB4D6B0088; Thu, 12 Mar 2026 04:45:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 358CE6B0089; Thu, 12 Mar 2026 04:45:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22D836B008A; Thu, 12 Mar 2026 04:45:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 111F76B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:45:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 984F9BBD94
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:45:08 +0000 (UTC)
X-FDA: 84536776296.16.79A5682
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf03.hostedemail.com (Postfix) with ESMTP id 87E4620008
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:45:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Q5Sv0Iyr;
	spf=pass (imf03.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773305106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=966D9VqSpR8mhRgzEnKy0sCC3UBCuari06zJH9AlaQk=;
	b=Nbi1StOzaV//5gMFVeandhudQ78mGY7fGejKTb8G347XMDELAV1r2IBidoGqbKkuHiOe+7
	W3SJ0gOS+I1rMbBQptbxUq5GzzmzN1dJjj+nClNpijSn5r8+Vbka+pdj3KC0zoC9aDaf8k
	vtJHJlCyhBE3Vp+7F7ZiE36Hg4cIlpQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773305106; a=rsa-sha256;
	cv=none;
	b=0XQeKxPfjrHuEg7MGfBUHygu60MPl3Ecvya1eWV8lDidzt6861mLFBV1BgRZKVB4pNB1Rv
	Tpqnl7PUPBtb5MM/HBLKRMRfqRWb96nf9fA21pZY/l5bbqBDaeTT0ctEESkBdVqzn5K4FN
	wfIedq6fPqai2EnJA+f1bWFsfkPZq7A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Q5Sv0Iyr;
	spf=pass (imf03.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62BMW9QR2279034;
	Thu, 12 Mar 2026 08:44:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=966D9V
	qSpR8mhRgzEnKy0sCC3UBCuari06zJH9AlaQk=; b=Q5Sv0Iyr3sEHeusRWXuAaJ
	zOcXZPItrahX3Jm7BUDz4UgfcWg1H9FA/0/PJjEiC+qOmFC/HlQZZcJw767h8dXH
	rrDFPz9Tbw2pUYI/UGifP0AEO1b6tumfT7w33gjtLstUFuhXfcACtYvs4iCf9AUy
	0TljuEJIc6pJoNBsPR7BP7HZJPGqrGYwQ98vbNXs7kS7jTqFfHZEka1N1ZAwllqf
	COlt19iraX4bvy+uNVV3DjZm9qNKzApQ8ISpLWIBK7/l8QSc2eVwnob0qixkac9K
	PREjkVk9sZ9zU1GkfRzqtDK+80JD3vxVyHJ0bhlh51FkBI23jD9Iy1LpPaSVS3AQ
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh91hsd0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 08:44:46 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62C4KEwP025691;
	Thu, 12 Mar 2026 08:44:45 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cuha89mdm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 08:44:45 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62C8iiO6852884
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 08:44:44 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 852145805E;
	Thu, 12 Mar 2026 08:44:44 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E235E58059;
	Thu, 12 Mar 2026 08:44:35 +0000 (GMT)
Received: from [9.109.215.162] (unknown [9.109.215.162])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Mar 2026 08:44:35 +0000 (GMT)
Message-ID: <b2543019-5489-4968-be77-226e356b855c@linux.ibm.com>
Date: Thu, 12 Mar 2026 14:14:34 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm: Move demotion related functions in memory-tiers.c
To: Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org
Cc: alexghiti@kernel.org, kernel-team@meta.com, akinobu.mita@gmail.com,
        david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
        vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        hannes@cmpxchg.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
        axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
        gourry@gourry.net, apopple@nvidia.com, byungchul@sk.com,
        joshua.hahnjy@gmail.com, matthew.brost@intel.com, rakie.kim@sk.com,
        ying.huang@linux.alibaba.com, ziy@nvidia.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20260311110314.237315-1-alex@ghiti.fr>
 <20260311110314.237315-2-alex@ghiti.fr>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260311110314.237315-2-alex@ghiti.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: PVd15Je2JiKyRx4cJTb0tflFhQJ7jUlW
X-Authority-Analysis: v=2.4 cv=E6/AZKdl c=1 sm=1 tr=0 ts=69b27cfe cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=tHa68p0SAAAA:8
 a=VnNF1IyMAAAA:8 a=EaoAdP5EAfkfoGP2U40A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=ufIsyHvWW7FwcMbVRpPq:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDA2OCBTYWx0ZWRfXxQn0Q0OpysCc
 /6m+++wZnozRLwPiFHeCiSAlD/foaEn4YRtl7eTdFV6rWWFo5vD+3S1lmeK9jngiNyl90Z/gdON
 F1RB4Pe1wBwKsQ+EyHGspi+sEqh/GfyASllChWV0SidQc4bZJBs0c2tgzLVrx/RBKuR5IORucsy
 CrQkyaAQso6AfaN/0RNYRrtaXVIFqnN/+hjb+AJq+K9YCIKs9KdbCFUXrztyjuCtre4Bh1CI6/t
 vW1Z98p2CpG+QVtwDAFj4TzcAT7uPlzt6h4hp63tSgeyufg1x6QJiXdAGJzW1Hdrgz6RdTHp9No
 GMG1Fi1S/tn4Gp1hu4Y0UBZSPAPlszSD9CkMcl55Xrm/9TY3ucdM6u3q97SVv4LarQ1PdIc5cyP
 23+xhmsRerc3hlUtnvwS7H4MzGHF+FZiCLE2s3++scmti7hf6aCbrgQRtKcyPlmhHdl0qVJrhxV
 zZB5QMV/+DL+0l14yjw==
X-Proofpoint-ORIG-GUID: yowdE4SIwHFOOnFUpDfGhQaydE27Yo5s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-11_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 clxscore=1011 malwarescore=0 phishscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603120068
X-Stat-Signature: ctw8s3dq16s3idyjw4nqtbg8h6ozkzjt
X-Rspam-User: 
X-Rspamd-Queue-Id: 87E4620008
X-Rspamd-Server: rspam12
X-HE-Tag: 1773305104-725652
X-HE-Meta: U2FsdGVkX19u9leqaofyBwvTGL/xGHbepRAU4Wu1OVS3iC1+wNa6EdFwInndeZdvG0uHT6Tl4G1XRpm7nYxT8fTmA8oeCLeZE5RbjCWFmoxBPQGn0JLORtXlwK91N1CK+2wt3FkHaxN3MCWwwXVIrTCI0tg2/1qFOVczq9ZdXGMhUFL7RkfSK+JZQJPya+iDsHbSGetXorV7zI2OgaoC4KWMpfDc2xL6psTSaaf+8aZFc123irVuPTz52otDECvh6PZfPCQZNjlxN5OIMaaphRF7rc/uFvZebSkue3d+H3Ls+KLRAP/KK0oZX58N+wNEboj50TJLRUnuNabaUGleBFSwy/igOoeV0KSQUTKcMhiojeWvCRz8i5XAEoid6BD/6K1KETxCe07OqXTnT6WcjLVQbvjeAmh3JFbARSqN/WU7I6n3dqX479wvNd/gF1RTyrIq4JPsQf8EIHYQFaf23CHWNk8ywbTLVCSuKjmFiZ7oIqmql97M+7eNRsQEEiVWKlp92Imm24R/zjErnDE8TiA4qDYwOXvgBmpk2nwDhRIoRG0ynLaYGV6cSe0cBotQMvMUIfHbsddkbARbzB28zJZnjJZ7Tf6tmyobk6iFn+vDV4i6wQIzA+7ytJTUCy2YUkYiAQx9+Ob6s0iKY13A8gJWMlgNNqB7M2Boe0SwzuQzzEAVLqgpAnjmcdsU7hUGc5tB/q2VUZrNdzAy8W9RL20wEjzyaOMfFnGqUoa0YqgvzgwLKvPhhxl4K4t5v1cVXFNtSiJyslHHwL8n7c0mOpCCDx8aEKCo44ysWZk7AfN/Y5IuZSFdlUyftijLgUvjMohll5iuUOtVrpGnaS+KKiq76+Fh7kNM7xohEmnTipilnRRQ6HWQWqsx1WmbpuNGIxHLox01v0zyWbRaH/HS3wBOg1R5ciiSU4xbleyqFvwGF2c4xVG88lXwR6eAtWvaHshs4UXY53nptouCame
 T6I7zZFg
 2NFby3LLIp3Qj7tISVEgrZMVB0ezJaPDeZeOh0vVYcxnFLrNJI29Pr7En+yIzo6oFpFQ16ao9NMgFfYsFKasS2vP+5nj5SBS1VPaBIQG3x1q/ms4yxYy4qLv95oRMq9N06XLyZf/i4vFS0vtoBL5NBuc4SGSyaLFFbFBm7ig1ZKck/oAXP5g/4PAmJrji+pLAxiIFzjntkbaBNSB7MHhvIk/9xOREZ2VWc53z7wnj4TKbZRv/xWMjv8nwcwq0Bb7qmUPPTuzCmzaoceNyiqkLHZohbd0pBw4aHNz2yXCA+XAjv7Z0lkbNILYMtpnp/vo4eauYl9/7BSbQQwNyiHyelLOX8obR8FHdsMYbi8riBHVnkk/qdHfTpd1Qa2TOA7GnL3RXu08n4zDcXg9eJr5O3NF4v01CyTVWrQ1GBQOP5VIKFp2lFzRbjvsijW/XuteD4su77FneIKonnQ46T94KdaVdHUI1YFJl3UbcQ24G3Grvlevy/cQq4eDoEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi Alexander

On 3/11/26 4:32 PM, Alexandre Ghiti wrote:
> Let's have all the demotion functions in this file, no functional
> change intended.
>
> Suggested-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>   include/linux/memory-tiers.h | 18 ++++++++
>   mm/memory-tiers.c            | 75 +++++++++++++++++++++++++++++++++
>   mm/vmscan.c                  | 80 +-----------------------------------
>   3 files changed, 94 insertions(+), 79 deletions(-)
>
> diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
> index 96987d9d95a8..0bf0d002939e 100644
> --- a/include/linux/memory-tiers.h
> +++ b/include/linux/memory-tiers.h
> @@ -56,6 +56,9 @@ void mt_put_memory_types(struct list_head *memory_types);
>   int next_demotion_node(int node, const nodemask_t *allowed_mask);
>   void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
>   bool node_is_toptier(int node);
> +unsigned int mt_demote_folios(struct list_head *demote_folios,
> +			      struct pglist_data *pgdat,
> +			      struct mem_cgroup *memcg);
>   #else
>   static inline int next_demotion_node(int node, const nodemask_t *allowed_mask)
>   {
> @@ -71,6 +74,14 @@ static inline bool node_is_toptier(int node)
>   {
>   	return true;
>   }
> +
> +static inline unsigned int mt_demote_folios(struct list_head *demote_folios,
> +					    struct pglist_data *pgdat,
> +					    struct mem_cgroup *memcg)
> +{
> +	return 0;
> +}
> +
>   #endif
>   
>   #else
> @@ -116,6 +127,13 @@ static inline bool node_is_toptier(int node)
>   	return true;
>   }
>   
> +static inline unsigned int mt_demote_folios(struct list_head *demote_folios,
> +					    struct pglist_data *pgdat,
> +					    struct mem_cgroup *memcg)
> +{
> +	return 0;
> +}
> +
>   static inline int register_mt_adistance_algorithm(struct notifier_block *nb)
>   {
>   	return 0;
> diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
> index 986f809376eb..afdf21738a54 100644
> --- a/mm/memory-tiers.c
> +++ b/mm/memory-tiers.c
> @@ -7,6 +7,7 @@
>   #include <linux/memory-tiers.h>
>   #include <linux/notifier.h>
>   #include <linux/sched/sysctl.h>
> +#include <linux/migrate.h>
>   
>   #include "internal.h"
>   
> @@ -373,6 +374,80 @@ int next_demotion_node(int node, const nodemask_t *allowed_mask)
>   	return find_next_best_node(node, &mask);
>   }
>   
> +static struct folio *alloc_demote_folio(struct folio *src,
> +					unsigned long private)
> +{
> +	struct folio *dst;
> +	nodemask_t *allowed_mask;
> +	struct migration_target_control *mtc;
> +
> +	mtc = (struct migration_target_control *)private;
> +
> +	allowed_mask = mtc->nmask;
> +	/*
> +	 * make sure we allocate from the target node first also trying to
> +	 * demote or reclaim pages from the target node via kswapd if we are
> +	 * low on free memory on target node. If we don't do this and if
> +	 * we have free memory on the slower(lower) memtier, we would start
> +	 * allocating pages from slower(lower) memory tiers without even forcing
> +	 * a demotion of cold pages from the target memtier. This can result
> +	 * in the kernel placing hot pages in slower(lower) memory tiers.
> +	 */
> +	mtc->nmask = NULL;
> +	mtc->gfp_mask |= __GFP_THISNODE;
> +	dst = alloc_migration_target(src, (unsigned long)mtc);
> +	if (dst)
> +		return dst;
> +
> +	mtc->gfp_mask &= ~__GFP_THISNODE;
> +	mtc->nmask = allowed_mask;
> +
> +	return alloc_migration_target(src, (unsigned long)mtc);
> +}
> +
> +unsigned int mt_demote_folios(struct list_head *demote_folios,


Demotion will happen only when different memory tiers are present, 
right? Since demote_folios() already implies that the folios are being 
demoted to a lower tier, is the mt_ prefix needed in the function name? 
I’m fine with keeping it as is, but I just wanted to clarify.

Otherwise it LGTM

Reviewed by: Donet Tom <donettom@linux.ibm.com>

> +			      struct pglist_data *pgdat,
> +			      struct mem_cgroup *memcg)
> +{
> +	int target_nid;
> +	unsigned int nr_succeeded;
> +	nodemask_t allowed_mask;
> +
> +	struct migration_target_control mtc = {
> +		/*
> +		 * Allocate from 'node', or fail quickly and quietly.
> +		 * When this happens, 'page' will likely just be discarded
> +		 * instead of migrated.
> +		 */
> +		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
> +			__GFP_NOMEMALLOC | GFP_NOWAIT,
> +		.nmask = &allowed_mask,
> +		.reason = MR_DEMOTION,
> +	};
> +
> +	if (list_empty(demote_folios))
> +		return 0;
> +
> +	node_get_allowed_targets(pgdat, &allowed_mask);
> +	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
> +	if (nodes_empty(allowed_mask))
> +		return 0;
> +
> +	target_nid = next_demotion_node(pgdat->node_id, &allowed_mask);
> +	if (target_nid == NUMA_NO_NODE)
> +		/* No lower-tier nodes or nodes were hot-unplugged. */
> +		return 0;
> +
> +	mtc.nid = target_nid;
> +
> +	/* Demotion ignores all cpuset and mempolicy settings */
> +	migrate_pages(demote_folios, alloc_demote_folio, NULL,
> +			(unsigned long)&mtc, MIGRATE_ASYNC, MR_DEMOTION,
> +			&nr_succeeded);
> +
> +	return nr_succeeded;
> +}
> +
>   static void disable_all_demotion_targets(void)
>   {
>   	struct memory_tier *memtier;
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 0fc9373e8251..5e0138b94480 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -983,84 +983,6 @@ static void folio_check_dirty_writeback(struct folio *folio,
>   		mapping->a_ops->is_dirty_writeback(folio, dirty, writeback);
>   }
>   
> -static struct folio *alloc_demote_folio(struct folio *src,
> -		unsigned long private)
> -{
> -	struct folio *dst;
> -	nodemask_t *allowed_mask;
> -	struct migration_target_control *mtc;
> -
> -	mtc = (struct migration_target_control *)private;
> -
> -	allowed_mask = mtc->nmask;
> -	/*
> -	 * make sure we allocate from the target node first also trying to
> -	 * demote or reclaim pages from the target node via kswapd if we are
> -	 * low on free memory on target node. If we don't do this and if
> -	 * we have free memory on the slower(lower) memtier, we would start
> -	 * allocating pages from slower(lower) memory tiers without even forcing
> -	 * a demotion of cold pages from the target memtier. This can result
> -	 * in the kernel placing hot pages in slower(lower) memory tiers.
> -	 */
> -	mtc->nmask = NULL;
> -	mtc->gfp_mask |= __GFP_THISNODE;
> -	dst = alloc_migration_target(src, (unsigned long)mtc);
> -	if (dst)
> -		return dst;
> -
> -	mtc->gfp_mask &= ~__GFP_THISNODE;
> -	mtc->nmask = allowed_mask;
> -
> -	return alloc_migration_target(src, (unsigned long)mtc);
> -}
> -
> -/*
> - * Take folios on @demote_folios and attempt to demote them to another node.
> - * Folios which are not demoted are left on @demote_folios.
> - */
> -static unsigned int demote_folio_list(struct list_head *demote_folios,
> -				      struct pglist_data *pgdat,
> -				      struct mem_cgroup *memcg)
> -{
> -	int target_nid;
> -	unsigned int nr_succeeded;
> -	nodemask_t allowed_mask;
> -
> -	struct migration_target_control mtc = {
> -		/*
> -		 * Allocate from 'node', or fail quickly and quietly.
> -		 * When this happens, 'page' will likely just be discarded
> -		 * instead of migrated.
> -		 */
> -		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
> -			__GFP_NOMEMALLOC | GFP_NOWAIT,
> -		.nmask = &allowed_mask,
> -		.reason = MR_DEMOTION,
> -	};
> -
> -	if (list_empty(demote_folios))
> -		return 0;
> -
> -	node_get_allowed_targets(pgdat, &allowed_mask);
> -	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
> -	if (nodes_empty(allowed_mask))
> -		return 0;
> -
> -	target_nid = next_demotion_node(pgdat->node_id, &allowed_mask);
> -	if (target_nid == NUMA_NO_NODE)
> -		/* No lower-tier nodes or nodes were hot-unplugged. */
> -		return 0;
> -
> -	mtc.nid = target_nid;
> -
> -	/* Demotion ignores all cpuset and mempolicy settings */
> -	migrate_pages(demote_folios, alloc_demote_folio, NULL,
> -		      (unsigned long)&mtc, MIGRATE_ASYNC, MR_DEMOTION,
> -		      &nr_succeeded);
> -
> -	return nr_succeeded;
> -}
> -
>   static bool may_enter_fs(struct folio *folio, gfp_t gfp_mask)
>   {
>   	if (gfp_mask & __GFP_FS)
> @@ -1573,7 +1495,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>   	/* 'folio_list' is always empty here */
>   
>   	/* Migrate folios selected for demotion */
> -	nr_demoted = demote_folio_list(&demote_folios, pgdat, memcg);
> +	nr_demoted = mt_demote_folios(&demote_folios, pgdat, memcg);
>   	nr_reclaimed += nr_demoted;
>   	stat->nr_demoted += nr_demoted;
>   	/* Folios that could not be demoted are still in @demote_folios */


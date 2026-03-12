Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CE29FED2F0
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 08:46:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDE616B0088; Thu, 12 Mar 2026 04:46:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8B3D6B0089; Thu, 12 Mar 2026 04:46:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6D906B008A; Thu, 12 Mar 2026 04:46:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A2DFA6B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:46:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 589901A0915
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:46:48 +0000 (UTC)
X-FDA: 84536780496.09.4B1BE92
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf03.hostedemail.com (Postfix) with ESMTP id C130020004
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:46:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=bBWD1nin;
	spf=pass (imf03.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773305206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CXovpFI5wad5gk4rfDJvLgYAX9jw9tWKGQFjv/n9Jks=;
	b=y6u3Rn+5HJYH4siDy0qcplHBnNbrqHR25ZSuoz2Kt/FiovpASJXhfBG2K9MAJDVFZkibXg
	a4Yz3jj0UjRsQ7miP+3BCsg3xqM4JGlZ12EVR+YqfYDgMhLp6A6W3vYFJagkW6DrnsnDl0
	fLmeNdF6e9Ua/FT5rumZbrxC+OvwTC8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=bBWD1nin;
	spf=pass (imf03.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773305206; a=rsa-sha256;
	cv=none;
	b=H0KfNK6YKeyK6VMSSIfDqmmHlEsu1Fn+pjg+pRnSZKZtjYRsixSggoernzyKuVq3f/sR5D
	76meHHDYNb4tXg2i46Kxh8fszoACrpTIQieS40CVFuXAFEdy+pJmUg2Jx2JSfkxgWXPiDh
	kFdtqlP2v5NPl1UnhniRpy7RVIjXA3M=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62BMVbmG2277765;
	Thu, 12 Mar 2026 08:46:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=CXovpF
	I5wad5gk4rfDJvLgYAX9jw9tWKGQFjv/n9Jks=; b=bBWD1nindgtklu6MtQOHWl
	XNyd5Zh648btPJ65kg4lvQ9Udo3AipzeAHTxa5DudywffTRTG8vDT+idNQDUBysX
	CsERf8KfcQQSwofYAC7t+00Y4iezCA8akH+E+zZ5pCvOqAqAi1ndh7yjwF6Y9DpT
	JzrcelvRQgVXl3itL0lrAjcWHpQ9Bc9VgEFsoRICGw+fZcSsceOwHF0rZd6yfi2p
	XzuFhjdtM+TRXk5Qq5VvSL2EOCtOKXjSnXYFUUooKKmibkGlwtu3AfHU+66PmCyj
	LEGnJJbk6kOmTlUqCvWkS+SoLeHy0YEJGhPGdelLxRrRH1EVKUphs79tS5tlIUWw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh91hsn4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 08:46:27 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62C4QNP2018897;
	Thu, 12 Mar 2026 08:46:26 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cuha81mbh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 08:46:26 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62C8kPZU33423962
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 08:46:26 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D8A9D5805C;
	Thu, 12 Mar 2026 08:46:25 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 242BE5805F;
	Thu, 12 Mar 2026 08:46:17 +0000 (GMT)
Received: from [9.109.215.162] (unknown [9.109.215.162])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Mar 2026 08:46:16 +0000 (GMT)
Message-ID: <e33da5cc-fcb3-4f5d-ada3-d494269deb42@linux.ibm.com>
Date: Thu, 12 Mar 2026 14:16:15 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm: Rename node_get_allowed_targets() to make it more
 explicit
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
 <20260311110314.237315-3-alex@ghiti.fr>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260311110314.237315-3-alex@ghiti.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: -JT3zblOnAsJJjK2Jmvz10dHBiT41iBI
X-Authority-Analysis: v=2.4 cv=E6/AZKdl c=1 sm=1 tr=0 ts=69b27d64 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8
 a=Z4ipdR8nfIi2rop9YuoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDA2OCBTYWx0ZWRfX4JYLxrHLDSqU
 ZpZpY2MibadiyxjjV+W4GzPwTC0qcyXmtIdBANQF/bpT6rMzDTHzMhMuc7grjE9Aml2y1cKZPQw
 VE2tCS3I5tUzqtjs2Lpi+dLWqSqjvCF2zImj8hpv7zspr6L8VETZ218D26v0J8t9Xm+n1xrhfYE
 S65FnH1sxPGyYAqktjZ3/zoMIAfNOIIWjOZGf5cId/Ak6vYEBsPI2cjSFnlNz8upIJ2prBxpCyt
 oF6Z6Xz4QlXqF7UzE5iD4B4s7KU6yXndz3j2W7oluzEGf8O51bvJh3+g9PEM1nSOLkrzSD3o/sf
 7liTjIkawRfgwkm3Ns9oCQlWQ1ImM8PnUuWU8x+4ExW+zcdh8VLF1GzGumnMbgwwVHoNvdR1hFB
 u5P2goLseAEP6QlM5RvS1Enu4BReh4VhbSIYg7jeBM7hZ7tbXgSo+64oTA7MYCb6Za3s7rcx7Vs
 PMXcpjlIuvXTjntSjfg==
X-Proofpoint-ORIG-GUID: Ab6KONgjHEqd5CNZBIedg5S8z582UqEw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-11_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 clxscore=1015 malwarescore=0 phishscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603120068
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C130020004
X-Stat-Signature: zmdg9iafemx4181jium5how445bpfe15
X-Rspam-User: 
X-HE-Tag: 1773305205-68909
X-HE-Meta: U2FsdGVkX1/TYjYRp/PCyBkQDNGDuWOnEuxTcbpsQSnjYVmN8LinjG+SNrfLS/RcTB78USqJG8xFlHnU+Mv1y5/LLcsanndbKAQZ3Rn6X8hQ3i6s81SzMdRrJzZQBbINrl04zNHifkV1iK2WxdPwg6HvzQzm7wRLf9D74hmIcXFtuFn3mMeFTC+dMJNwheXgGxdSVW8RA2gcCLhvTviAsHI7K98Mx6+87LsEZTXHdBx2DCWZFAemxL+NF5KkH3JtxoRT5RT25PaUuyby586AHHreNUjt9NS2lR4i5gWixLOM46W+aAUDHkWG1DQLS7ETD/LyoSG7WHdvLB5AoFNDysxO/EBQ7zbJY4TdwlKSCKQAYLDjy2+2vRrjE//qectQnVYNbcFoTe4IeOcx7Ofwyyr8KBsw0bv94J4DE+WVPYIB0jqxdBAcujANz/IkTjATmp0EiIUJuJNfg/rI9Vxuroz6f0gzBBY2OZo6OlwICxMV2JJz4SBhmXR7eIByRSk+U2OsRNYl+Ki4PpgQS/nxkInJit9zenR0j7yU1Zw4smIQITH091Kn/Gg9S9g8QA66sth6l9Y9B90ANhk3s3SywQachDk1XTlE4Ckj+Lu8AV9XMztDdsZzsfu56dENfEjPAGKuDYT4mBYARCyt3EvhSXVpPe+1/u1hlFxPhDLIvV02wc+x6RrtQK7bcAv87NynralX3la896W+zPToqgKG1thFGNH1B4qriofijMofJuJWg3hAl64NGperLCBJUzGzGlRsoUHV0nsAQzAfNVrIBgdVW4eVBLkv9SDwSGg9Y1/AJ8G0jvOAvgQpevX7ALfH3AtPw34g1Bh+IPx1yUyi3yFhUve7GM0Ja377nVv0sMC3x5P2ARjjmdbuEoKn9IE9vIpvpQbVPezPrrJOOxlSDyPGEnUbsWovGqvuOY7Wd5Jg2BvBn+f9nroACgytEJVyISASRXJXIkTEKM04c6N
 iazf2bdI
 eZmDDPOgvt7HaG7w8JCj0WzEwrcILvEQhxc6sy7FZMMMvIijqdII2WmkMcRSGy8CmbmYXc1N7qO4UkRU7jVusIjpTma5SanlJzXaFG/6kuqYLk4ye6VtR//ygb2pwQnonDMewTxlR4DE54NATROBqoiQ/Dbo+tL2MUi1IN2W1E6O2nO3objG9lsqku9ZxBKx8dwJaaLLgf50ot322vxZcF64VTL0fYmysDmgzxqiKw302pllx3orFRRurAbGyI3z2yL9tFAkVzKVDAzSoysrOFk/4cug7eluOahy++rgbUsGERyJ9VynLa/RDchZcEKLBzTLO7DQEdRpHdqLhBU8xQXXfd4gV6cdE0O7qI3aQ/WmSpaEpEW8oJ++oFeW7VKVCCA3JQyvEfGPD/1c0iNPsiZfjphHdktKNLiH76Lq5AR1bmUlrBWNDjlYaLTdn+roTp+9DAsEwxYRWfQ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 3/11/26 4:32 PM, Alexandre Ghiti wrote:
> This function actually returns the tier nodes that are targeted during a
> demotion, so rename it to be more explicit.
>
> No functional change intended.
>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>


This looks LGTM

Reviewed by: Donet Tom <donettom@linux.ibm.com>

> ---
>   include/linux/memory-tiers.h | 6 +++---
>   mm/memory-tiers.c            | 4 ++--
>   mm/vmscan.c                  | 2 +-
>   3 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
> index 0bf0d002939e..ec39dc3c39e6 100644
> --- a/include/linux/memory-tiers.h
> +++ b/include/linux/memory-tiers.h
> @@ -54,7 +54,7 @@ struct memory_dev_type *mt_find_alloc_memory_type(int adist,
>   void mt_put_memory_types(struct list_head *memory_types);
>   #ifdef CONFIG_MIGRATION
>   int next_demotion_node(int node, const nodemask_t *allowed_mask);
> -void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
> +void node_get_allowed_demotion_targets(pg_data_t *pgdat, nodemask_t *targets);
>   bool node_is_toptier(int node);
>   unsigned int mt_demote_folios(struct list_head *demote_folios,
>   			      struct pglist_data *pgdat,
> @@ -65,7 +65,7 @@ static inline int next_demotion_node(int node, const nodemask_t *allowed_mask)
>   	return NUMA_NO_NODE;
>   }
>   
> -static inline void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
> +static inline void node_get_allowed_demotion_targets(pg_data_t *pgdat, nodemask_t *targets)
>   {
>   	*targets = NODE_MASK_NONE;
>   }
> @@ -117,7 +117,7 @@ static inline int next_demotion_node(int node, const nodemask_t *allowed_mask)
>   	return NUMA_NO_NODE;
>   }
>   
> -static inline void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
> +static inline void node_get_allowed_demotion_targets(pg_data_t *pgdat, nodemask_t *targets)
>   {
>   	*targets = NODE_MASK_NONE;
>   }
> diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
> index afdf21738a54..19ecc9b6bbda 100644
> --- a/mm/memory-tiers.c
> +++ b/mm/memory-tiers.c
> @@ -300,7 +300,7 @@ bool node_is_toptier(int node)
>   	return toptier;
>   }
>   
> -void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
> +void node_get_allowed_demotion_targets(pg_data_t *pgdat, nodemask_t *targets)
>   {
>   	struct memory_tier *memtier;
>   
> @@ -428,7 +428,7 @@ unsigned int mt_demote_folios(struct list_head *demote_folios,
>   	if (list_empty(demote_folios))
>   		return 0;
>   
> -	node_get_allowed_targets(pgdat, &allowed_mask);
> +	node_get_allowed_demotion_targets(pgdat, &allowed_mask);
>   	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
>   	if (nodes_empty(allowed_mask))
>   		return 0;
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 5e0138b94480..11a97ee8f583 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -351,7 +351,7 @@ static bool can_demote(int nid, struct scan_control *sc,
>   	if (sc && sc->no_demotion)
>   		return false;
>   
> -	node_get_allowed_targets(pgdat, &allowed_mask);
> +	node_get_allowed_demotion_targets(pgdat, &allowed_mask);
>   	if (nodes_empty(allowed_mask))
>   		return false;
>   


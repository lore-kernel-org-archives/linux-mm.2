Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F6F21061B16
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 16:37:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 727F06B008C; Mon, 30 Mar 2026 12:37:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D8326B0095; Mon, 30 Mar 2026 12:37:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59FFA6B0096; Mon, 30 Mar 2026 12:37:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46B976B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:37:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1E839E0E3F
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:37:22 +0000 (UTC)
X-FDA: 84603284724.11.7AAFF8A
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9AEEE160003
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:37:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ktQC2QPy;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf08.hostedemail.com: domain of zaslonko@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=zaslonko@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774888639; a=rsa-sha256;
	cv=none;
	b=l+Zizx4sjtBvDSxmpYyjkeR6KDnYer31gpd6yS86iuNCJNPmhIdcuNHg7TqbM6b/IOsoxy
	3VSOgNdyPtmU/9SEzgZAfV5GaVoS2MEc5hiWX5rA+4UvhbNzSFKGaoMINimyZ88dj3hCGJ
	sBHkFIpRkG2+Mwsxx21lXTtrxXkWl1I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ktQC2QPy;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf08.hostedemail.com: domain of zaslonko@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=zaslonko@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774888639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s6XzCHUCYy0063Hw4rkyZJE4koDVmdyQJ2vzf9wYqFc=;
	b=fEAbYTWgdtPknclx+9U9X+lvEY4NuKOMkpWTJAyAai0fm4RZqbsPav1Lwq7XdKXBjPqVpg
	iVBc/z5+TqQ3dDmH22Hqwfu++Fp3tGVKuqwOuYyJY4MGCfiTXy+2kJodbkQUiZReSMWrVU
	s4ln1T/5PDqViwDvhxd41sWUv24fYmw=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62UEJFGS169440;
	Mon, 30 Mar 2026 16:37:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=s6XzCH
	UCYy0063Hw4rkyZJE4koDVmdyQJ2vzf9wYqFc=; b=ktQC2QPyN3HT1A8XqF6euf
	Np8GGf26Tld5RzE4EpHokMUcFdXKm/42RiNzGONVu00z5KITe5Z6kTLi58q1VUUe
	NP9rlc1gUBVbt42Al/9vXegsJp6bIvs7Wr22bvw4w7k+ptlym5GOiMRChaKDuqYo
	LxqowoPbX8m69Q+G/xkQsHgieIZUVt5Bk3arkiqWnuhZvmMjJu7Op4EYvk4jgako
	Esw/LhpUO0jCShaXGBQ5px9+/poM+8ulUMW0BZbAJV4ooNNnPUBUb3Qy1POqmrNP
	qtKgDxJBSW9X2jJUsRXtxhb0VeQTXIKkV29pQf9PK5DTA67t7VNWAHkAAaO0zAiA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d66q2yr1b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Mar 2026 16:37:09 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62UEBftn005977;
	Mon, 30 Mar 2026 16:37:07 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d6spxwr5v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Mar 2026 16:37:07 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62UGb6TF30802624
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Mar 2026 16:37:07 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CF0345804B;
	Mon, 30 Mar 2026 16:37:06 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5204A58065;
	Mon, 30 Mar 2026 16:37:04 +0000 (GMT)
Received: from [9.52.221.31] (unknown [9.52.221.31])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 30 Mar 2026 16:37:04 +0000 (GMT)
Message-ID: <4d3f8d79-3593-47df-9de8-f94f7f09a403@linux.ibm.com>
Date: Mon, 30 Mar 2026 18:37:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/7] mm: switch deferred split shrinker to list_lru -
 [s390] panic in __memcg_list_lru_alloc
To: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Roman Gushchin
 <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        Alexander Egorenkov <egorenar@linux.ibm.com>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <20260318200352.1039011-8-hannes@cmpxchg.org>
Content-Language: en-US
From: Mikhail Zaslonko <zaslonko@linux.ibm.com>
In-Reply-To: <20260318200352.1039011-8-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RtBz-yBpIESA1MQsj7Rs__MxNrlVWA7g
X-Authority-Analysis: v=2.4 cv=frzRpV4f c=1 sm=1 tr=0 ts=69caa6b5 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=ufHFDILaAAAA:8
 a=ZF9803qmpQwKPYjtCbQA:9 a=QEXdDO2ut3YA:10 a=ZmIg1sZ3JBWsdXgziEIF:22
X-Proofpoint-ORIG-GUID: RtBz-yBpIESA1MQsj7Rs__MxNrlVWA7g
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzMwMDEzMSBTYWx0ZWRfX1vzJKkfdf0yR
 3jDe5/grP2zuisvztQhPX3CjTbHYgWfJu8pgspAEQwC0RodjJ3S9xShjmZZJwhSsdRaynaN8pa+
 guQKnPaO/fRJb+iIjNSZ5uYB2K6swuftLEKH8qNztT2dV7fOgPHpt+ZJWs6LqwjsvKIolcGpM75
 RNdCCLAeeV1RdhN5hpJr0UECyJp+niTKvDwAIZc8694+Clu/TwwXFbEFztMt6Mv/mwWUcJj5hpJ
 +cpcvk2BQKVn/u7hI9p7LgTLqfoIhU3P+lmoYN9z6fx9olxgRJWzI7EyJ4hZ15fXCVycFXRsDEJ
 31wX2Y6s+GUSn7E1UHBV6d1vWIuWqt5Av3+q0mYPykYP04zpKOqm5Ii9DGzLyWAG/1/puN/yo5V
 QpxbBAq8rg0PnMoMLoZdV0Gnw/XyXOAtdK3dCcrEiW/nK4KnLr5TWNy208l82YwlNoIY7G23s1O
 pUVJX+qjcxtlBhCZSlA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-29_05,2026-03-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 clxscore=1011
 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603300131
X-Stat-Signature: ah1n93xobpprao16175m8ybig5nn17bm
X-Rspamd-Queue-Id: 9AEEE160003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774888639-869546
X-HE-Meta: U2FsdGVkX193q6nQHV1PzoVxnEI2WsM5yY7DGgIPL0uB6C3GRkIc7MhBYORoRdkMY4irAF7KXn0vESvm1Iuzgodz1drYJ7vdnkHkTdAD8eX3//Z5GUzrYQ/1dkbcxBjVnrKXZBV7v2kvS9i5KEtfXf1eiyfP9a2z0AzFwYxpW45AmS5jD308283vsflt8h+rO02jlvSTCtXPY6tExPdveT694DevbyTcsH48dCOBboR66S8vofBdkJdRxajarUEjPwQV8wd4rBV80Qyh+TvyDTygklPXdDQfcvPYyreOeMhVknWEW7p+dLLBOxJQqz3vu3Clvz6ViOZuuqaC/flO8u1YAyDL/3mmppWOirsS9oPi8zt2b3Xrq3wzOrA03JFOpzo1fCbtRN4E/xnoQUbPdOv54vtaTSnu8DaAv8/CrzKMuVAEblKxmi92UqGYkgRsLX4vZjcLtvzNe+wXd28fA36qBvOouwNXC/+0pD1OpxDhWK4oVUKRG1p19T9yNgc6vMMuJnT93gCfRlow8846jruj9lZD7rsoKd90E6JuyStX1vanjvtZMqlTOdFOSoV4OS5cPHFil9abiIOQYPI4Abhd80eoDN1SAdntdlD33CQNTz1ug2bPGC8Ne+lobx2XuA5Qa8pGo3hxtJONgPr4U2C06YdfEqS8fS7LQ9nYJbUybcNMGLUKSqVmUOjQpOvcBHX9wPDMAYsdsCtamZN633gYjS24uKiYbwmAPaaRMpBePaKJSMqSiPVibwMDBwbg7/crXmgu6V8SBa+e5JFmqtsNYfOz+/falCGBJnmeZuKoO6IzhSL297MvC6ld7TgL76ZpvYlovYZwaYc0AvHeD1xfyNnDjiVepHu4tvLO9JJJS6on4uue6P4lzdvT5311vU6T/nveLHCW/v5eGxx/uNi0vHlurdqkSRXnuEt2tpr4EGbIT8Zrsm+3m01WwHZsuFrVn3hZjj3IRsyjz7J
 MkF5COkw
 ooSuXaUGGhDjMqsmTW4bvBeflzXGvqf5oanGUQI2DRO1p6/RA1IBwxlmzRYic8m3IV77IDbIePbIwbdoxeabRs893rAA6CLk7YKWOQyeI62T2goaOUrLLClE5dxtC0eCnW5RxV1KH5nNJrtBPKRnOKJGW9Lvojy2X3aE+pv/0BCn41hAFpW8/hLZrlQcp1h6lMTnOCj9r77WdPJg6XPmXc7vcheqx4PLy8dH42ynnt/kd1qticS+wMfRaWU11rysYx//uDpAV5k4s+l/NETGYDNbEtYHfST/1WBcbonJkbySCfWld0S2wlGTofZvG7KOMfC6IfA12sjf92JjMNIjO8WjlcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18-Mar-26 20:53, Johannes Weiner wrote:
> The deferred split queue handles cgroups in a suboptimal fashion. 
> The queue is per-NUMA node or per-cgroup, not the intersection. That 
> means on a cgrouped system, a node-restricted allocation entering 
> reclaim can end up splitting large pages on other nodes:
> 
> alloc/unmap deferred_split_folio() list_add_tail(memcg-
> >split_queue) set_shrinker_bit(memcg, node, deferred_shrinker_id)
> 
> for_each_zone_zonelist_nodemask(restricted_nodes) mem_cgroup_iter() 
> shrink_slab(node, memcg) shrink_slab_memcg(node, memcg) if 
> test_shrinker_bit(memcg, node, deferred_shrinker_id) 
> deferred_split_scan() walks memcg->split_queue
> 
> The shrinker bit adds an imperfect guard rail. As soon as the
> cgroup has a single large page on the node of interest, all large
> pages owned by that memcg, including those on other nodes, will be
> split.
> 
> list_lru properly sets up per-node, per-cgroup lists. As a bonus,
> it streamlines a lot of the list operations and reclaim walks. It's 
> used widely by other major shrinkers already. Convert the deferred 
> split queue as well.
> 
> The list_lru per-memcg heads are instantiated on demand when the 
> first object of interest is allocated for a cgroup, by calling 
> folio_memcg_list_lru_alloc(). Add calls to where splittable pages 
> are created: anon faults, swapin faults, khugepaged collapse.
> 
> These calls create all possible node heads for the cgroup at once, 
> so the migration code (between nodes) doesn't need any special care.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org> --- include/ 
> linux/huge_mm.h    |   6 +- include/linux/memcontrol.h |   4 - 
> include/linux/mmzone.h     |  12 -- mm/huge_memory.c           | 342 
> ++++++++++++------------------------- mm/internal.h              | 2
> +- mm/khugepaged.c            |   7 + mm/memcontrol.c |  12 +- mm/
> memory.c                |  52 +++--- mm/ mm_init.c               |
> 15 -- 9 files changed, 151 insertions(+), 301 deletions(-)
> 

Hi,

with this series in linux-next (since next-20260324) I see a reproducible panic on s390 in the
dump kernel when running NVMe standalone dump (ngdump).
This only happens in the 'capture kernel', normal boot of the same kernel works fine.

[   14.350676] Unable to handle kernel pointer dereference in virtual kernel address space
[   14.350682] Failing address: 4000000000000000 TEID: 4000000000000803 ESOP-2 FSI
[   14.350686] Fault in home space mode while using kernel ASCE.
[   14.350689] AS:0000000002798007 R3:000000002d2c4007 S:000000002d2c3001 P:000000000000013d 
[   14.350730] Oops: 0038 ilc:3 [#1]SMP 
[   14.350735] Modules linked in: dm_service_time zfcp scsi_transport_fc uvdevice diag288_wdt nvme prng aes_s390 nvme_core des_s390 libdes zcrypt_cex4 dm_mirror dm_region_hash dm_log scsi_dh_rdac scsi_dh_emc scsi_dh_alua paes_s390 crypto_engine pkey_cca pkey_ep11 zcrypt rng_core pkey_pckmo pkey dm_multipath autofs4
[   14.350760] CPU: 0 UID: 0 PID: 32 Comm: khugepaged Not tainted 7.0.0-rc5-next-20260324 
[   14.350762] Hardware name: IBM 3931 A01 704 (LPAR)
[   14.350764] Krnl PSW : 0704d00180000000 000003ffe0443a82 (__memcg_list_lru_alloc+0x52/0x1d0)
[   14.350774]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:1 PM:0 RI:0 EA:3
[   14.350776] Krnl GPRS: 0000000000000402 00000000000bece0 0000000000000000 000003ffe1c17928
[   14.350778]            00000000001c24ca 0000000000000000 0000000000000000 000003ffe1c17948
[   14.350780]            0000000000000000 00000000000824c0 0000037200098000 4000000000000000
[   14.350782]            0000000000782400 0000000000000001 0000037fe00f39b8 0000037fe00f3918
[   14.350788] Krnl Code: 000003ffe0443a72: a7690000            lghi    %r6,0
[   14.350788]            000003ffe0443a76: e380f0a00004        lg      %r8,160(%r15)
[   14.350788]           *000003ffe0443a7c: e3b080b80004        lg      %r11,184(%r8)
[   14.350788]           >000003ffe0443a82: e330b9400012        lt      %r3,2368(%r11)
[   14.350788]            000003ffe0443a88: a7a40065            brc     10,000003ffe0443b52
[   14.350788]            000003ffe0443a8c: e3b0f0a00004        lg      %r11,160(%r15)
[   14.350788]            000003ffe0443a92: ec68006f007c        cgij    %r6,0,8,000003ffe0443b70
[   14.350788]            000003ffe0443a98: e300b9400014        lgf     %r0,2368(%r11)
[   14.350825] Call Trace:
[   14.350826]  [<000003ffe0443a82>] __memcg_list_lru_alloc+0x52/0x1d0 
[   14.350831]  [<000003ffe044529a>] folio_memcg_list_lru_alloc+0xba/0x150 
[   14.350834]  [<000003ffe04f279a>] alloc_charge_folio+0x18a/0x250 
[   14.350839]  [<000003ffe04f34dc>] collapse_huge_page+0x8c/0x890 
[   14.350841]  [<000003ffe04f4222>] collapse_scan_pmd+0x542/0x690 
[   14.350844]  [<000003ffe04f65b4>] collapse_single_pmd+0x144/0x240 
[   14.350847]  [<000003ffe04f69ce>] collapse_scan_mm_slot.constprop.0+0x31e/0x480 
[   14.350849]  [<000003ffe04f6d3c>] khugepaged+0x20c/0x210 
[   14.350852]  [<000003ffe019b0a8>] kthread+0x148/0x170 
[   14.350856]  [<000003ffe0119fec>] __ret_from_fork+0x3c/0x240 
[   14.350860]  [<000003ffe0ffa4b2>] ret_from_fork+0xa/0x30 
[   14.350865] Last Breaking-Event-Address:
[   14.350865]  [<000003ffe0445294>] folio_memcg_list_lru_alloc+0xb4/0x150
[   14.350870] Kernel panic - not syncing: Fatal exception: panic_on_oops


Environment:
Arch: s390x (IBM LPAR)
Kernel: next-20260324
Config: (can provide if needed)
Reproducible: always
Steps to Reproduce: 
  Install ngdump to an NVMe device partition via 'zipl -d' and initiate a dump (same issue with DASD ldipl-dump).

I have bisected to this specific commit. 
  good: 230bbdc110b3 ("mm: list_lru: introduce folio_memcg_list_lru_alloc()")
  bad:  b0f512f6e36c ("mm: switch deferred split shrinker to list_lru")
Reverting it on top of linux-next <next-20260327> restores normal Standalone Dump operation.
 
Let me know if I can provide any other data.

Thanks,
Mikhail









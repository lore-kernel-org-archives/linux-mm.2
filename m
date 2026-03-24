Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CF69E9A75A
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 10:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97FE26B0089; Tue, 24 Mar 2026 06:31:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 957E76B008C; Tue, 24 Mar 2026 06:31:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86DAC6B0092; Tue, 24 Mar 2026 06:31:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 784766B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:31:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 24C5E5FB64
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:31:12 +0000 (UTC)
X-FDA: 84580589184.12.7F8C85B
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9E20F180008
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:31:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="h/ofw939";
	spf=pass (imf24.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="h/ofw939";
	spf=pass (imf24.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774348269; a=rsa-sha256;
	cv=none;
	b=duGAeAejgqNixkOIX1ViIRiiKtWlfyy8OIZWwj8qH1dRAuEowktVPNNQ9ouT8vS/R3+jDj
	YFC+sJG67d6Okq6HJWVtJe394NlUItVNNXB5vKbmWdznnrtKcATkmB+mP4shHSU/Ku3yMK
	luRXc8PknhrrxDxE9Hwzhwdtqe/5Pg4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774348269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6iXIw53oyhD/Aef/QSnh/ofsx6KC9wdBYMSA1aRZItc=;
	b=uwmoUqPUChHdx7NdMPCiJWMoDxFVXFczj2BNmsH2GDoUBDSvVeQ+7qSpo/chcD9UWzB1Bu
	uY4SVH/2Nl/4ipWRpooxMzfKkwUaewfsjqaHDez5/1bPQte5ZRW54MFGdEIm7kKpAmomkL
	BdS7Czyx77xNEd0YJTglq+dDbf/SGRI=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62O56Hn54107185;
	Tue, 24 Mar 2026 10:30:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=6iXIw5
	3oyhD/Aef/QSnh/ofsx6KC9wdBYMSA1aRZItc=; b=h/ofw939k37erIJe5u4z3R
	eBu3vCzadRsJg37tHGd8aEE+6s0SbAbyaNmGYtsfWZSCQvppzGf0DjY4X2C7Gi/C
	urowuGeX/0P0FdLBEeZqJSPdFVj/xH/BssaU76QMsB1/wGRKwQ67mzrnlMx6ykvy
	jthJEbksaF0l7pdradAt/cRfi8DMTasCyzwvFrX3kSogZGvRx3hNC1+kodMnkT6x
	JJVI7eV7ir19DAhzboL1VWrBZ4M+xLsZ0BhfNt4Gp3Xxiyz6POpOrylRIiblW/lZ
	Cit3f2nHo+7DnwEvrODMKKklZipuhl1cYcTXUVpFNNHmKv3WRJq509UWAyAK6KpA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1ky02b1f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Mar 2026 10:30:46 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62O7vE1M009118;
	Tue, 24 Mar 2026 10:30:46 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d26nnhdp9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Mar 2026 10:30:46 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62OAUjQ124183378
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Mar 2026 10:30:45 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7D0B95806A;
	Tue, 24 Mar 2026 10:30:45 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 91CE55805A;
	Tue, 24 Mar 2026 10:30:36 +0000 (GMT)
Received: from [9.39.25.178] (unknown [9.39.25.178])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 24 Mar 2026 10:30:36 +0000 (GMT)
Message-ID: <13eb0f7a-95bc-4337-9d38-a06db0700777@linux.ibm.com>
Date: Tue, 24 Mar 2026 16:00:34 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/6] mm/memcontrol: Make memcg limits tier-aware
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Gregory Price <gourry@gourry.net>, Johannes Weiner <hannes@cmpxchg.org>,
        Kaiyang Zhao <kaiyang2@cs.cmu.edu>,
        Andrew Morton
 <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>, Waiman Long <longman@redhat.com>,
        Chen Ridong <chenridong@huaweicloud.com>, Tejun Heo <tj@kernel.org>,
        Michal Koutny <mkoutny@suse.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@meta.com
References: <20260223223830.586018-1-joshua.hahnjy@gmail.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260223223830.586018-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI0MDA4MiBTYWx0ZWRfX0CTPOOC1Zm1v
 4lRGIFTJqv5V3iNKjljty85RhDvmxSLU2vUg9VdV0V1hb2ill7s0ooGwSd7tzNJ3MyiC2g52vdg
 EEanT3WAdIdkXontpWKaGN+luglvDKK2qmigff07g3u9wC9aDlqdQb4HmTZVt4t1t8qFtWn4arF
 wNGHVeN7GscNx/t2qKnKJ5aCnZkw44g1QA1qqpfXhQ37reacpP0Xd9T6Uia+jVMTNhuKYRX3xMO
 OD/pW8D5paOgt+u8AJD6ufooATXj71PLMFT90PTADxyybYbp6iFkw4JH8ntOddPFD+6AD8cwila
 IT7V0y05ijuOLl53txbJMLKTB64mckkPZz855Bs52ZvoS3u6v2pDmTLM6bLrHiue+elT8QM+I6Z
 ORVAkI140mb1XKlKyFd08eZvTilAvmpBuKMhcheGBJorRzmZTBLVvvqgHQG2vSMyQj9uFHpMN8S
 M+iQWjAZOmJVy38IHqw==
X-Authority-Analysis: v=2.4 cv=JK42csKb c=1 sm=1 tr=0 ts=69c267d7 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=fF_EyESyzUftjbdG5NEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: J0bk_dztsoTudpoyrmkDyQbQXHpsaTgG
X-Proofpoint-GUID: YB92z70LugWcJaHc6vSFk8bv3anhVpNC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-24_02,2026-03-23_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1011 priorityscore=1501 malwarescore=0 adultscore=0
 spamscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603240082
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9E20F180008
X-Stat-Signature: w1cd37911b77izkqcc5xjconabz4p7j6
X-Rspam-User: 
X-HE-Tag: 1774348269-809544
X-HE-Meta: U2FsdGVkX18RWWhxS/S+FhGANLM9ZPq7+5YS1+VVTS5rYPFHsWZ9OWAwn2eLx86BkAvstBWcQau21fTrU3ifLprsry9lILHCR+uLqdn9TBSzsNv8uisuo54UqUxwqLn9G96XJXllSNl6Tr0CjUbb5J0xJ0Y98xWb3viUL6XpHdTBszdc+PXE35U5ZI0yhQuoOk8B4wneLP9+Z1tL9B0cmFZYip1dLmKNlMxtsOJDIc4r31/8kdsLZNLt6zsOOjxA3tvjlmngmbkd6BRXTWjpK7H7hYq/aAk2eDrQ/BTY43MW+epnglZzjnNukRaUfIhteoOyK512cI77MXjcG6pm8OCPmP4/ejUcwrbQhWkNazgFPwtJZCkENSii5rlbEFqAttAjs2G+O9mP19vgqDs5n/A9OilF49yFK0lwbWSl1WYOvKj2opl8W/I8SmRfLdauB5HgLMNwzykk+Iy2FjZyMamOgP2CBPKxUFZEadqETb9jUuJrXUxUYzNmiItomWBH3nw8FcFvSlUyb3zfofJG7DhFDgw5FhWChV6orbPrxwHQ5GlvyJtf1AiN4+mkNca+n+IWCG82/wRoXF92ancvv2orbXdrl88MfZaJspQQPjKpNW6kTV58beMJ2vMrOb6bbJag3vm06X7V+GiwY0r3iATPTa/bBlLpo4P43LO5zb+WBWEnVR1f9s/8ygEqnXbDKlDEXtGdOVhEECK9jkVx8Fza8Yn+9wrFp1P4JKQ+gYdVco6SctOOfy6hZLQ9YqOFrx9CseWJ1+TyhYqG0AQHEFVpTNUF/f1jKPmghtpxB4+0FTmHeu0SAnoSadINjiGooUi/teei0TuvlvD1M1YukFlXTrzxXmkeHbagpir+iik7OuM7xW0F/WAXtIHRvXir9DCtv2auksOKRTvVILpjPwhQOGCbgPgyYyaLaafPBjXrS6cAwr66n2yJhknA+U8m8wVU6ES0gsrCT4ddzxz
 Y5znbNn0
 NleD1VP1DJH4U6hHd0mLVkPIvRAdoLHp14LgoAyJKkF5bpfGd4rYSI0Lz1wRwiHuWPoc64v9GUwUyEiK8CaIr5IZo40hWus95VO5r/UwrreypQtCmFOQYne7rQWHitlL+WEvaRvxM8xSz2LUJOmq4Qng9lMsFMjrgUweBFnIKe3pw3OhjDLiYPj70kzPSfmMw1vMOjmZ2S7xdnID5SXzA69SnedYuPK7ei3roKvmBD4TN5sPQBEOuj34nrBctkSq+DW7cjvFlIFmEhL9PHANplB4a6qt6vktMMtBxEeBvSDSZFtduW6iCvPxilEQG04WTMkAT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Josua

On 2/24/26 4:08 AM, Joshua Hahn wrote:
> Memory cgroups provide an interface that allow multiple workloads on a
> host to co-exist, and establish both weak and strong memory isolation
> guarantees. For large servers and small embedded systems alike, memcgs
> provide an effective way to provide a baseline quality of service for
> protected workloads.
>
> This works, because for the most part, all memory is equal (except for
> zram / zswap). Restricting a cgroup's memory footprint restricts how
> much it can hurt other workloads competing for memory. Likewise, setting
> memory.low or memory.min limits can provide weak and strong guarantees
> to the performance of a cgroup.
>
> However, on systems with tiered memory (e.g. CXL / compressed memory),
> the quality of service guarantees that memcg limits enforced become less
> effective, as memcg has no awareness of the physical location of its
> charged memory. In other words, a workload that is well-behaved within
> its memcg limits may still be hurting the performance of other
> well-behaving workloads on the system by hogging more than its
> "fair share" of toptier memory.
>
> Introduce tier-aware memcg limits, which scale memory.low/high to
> reflect the ratio of toptier:total memory the cgroup has access.
>
> Take the following scenario as an example:
> On a host with 3:1 toptier:lowtier, say 150G toptier, and 50Glowtier,
> setting a cgroup's limits to:
> 	memory.min:  15G
> 	memory.low:  20G
> 	memory.high: 40G
> 	memory.max:  50G
>
> Will be enforced at the toptier as:
> 	memory.min:          15G
> 	memory.toptier_low:  15G (20 * 150/200)
> 	memory.toptier_high: 30G (40 * 150/200)
> 	memory.max:          50G



Currently, the high and low thresholds are adjusted based on the ratio 
of top-tier to total memory. One concern I see is that if the working 
set size exceeds the top-tier high threshold, it could lead to frequent 
demotions and promotions. Instead, would it make sense to introduce a 
tunable knob to configure the top-tier high threshold?

Another concern is that if the lower-tier memory size is very large, the 
cgroup may end up getting only a small portion of higher-tier memory.


>
> Let's say that there are 4 such cgroups on the host. Previously, it would
> be possible for 3 hosts to completely take over all of DRAM, while one
> cgroup could only access the lowtier memory. In the perspective of a
> tier-agnostic memcg limit enforcement, the three cgroups are all
> well-behaved, consuming within their memory limits.
>
> This is not to say that the scenario above is incorrect. In fact, for
> letting the hottest cgroups run in DRAM while pushing out colder cgroups
> to lowtier memory lets the system perform the most aggregate work total.
>
> But for other scenarios, the target might not be maximizing aggregate
> work, but maximizing the minimum performance guarantee for each
> individual workload (think hosts shared across different users, such as
> VM hosting services).
>
> To reflect these two scenarios, introduce a sysctl tier_aware_memcg,
> which allows the host to toggle between enforcing and overlooking
> toptier memcg limit breaches.
>
> This work is inspired & based off of Kaiyang Zhao's work from 2024 [1],
> where he referred to this concept as "memory tiering fairness".
> The biggest difference in the implementations lie in how toptier memory
> is tracked; in his implementation, an lruvec stat aggregation is done on
> each usage check, while in this implementation, a new cacheline is
> introduced in page_coutner to keep track of toptier usage (Kaiyang also
> introduces a new cachline in page_counter, but only uses it to cache
> capacity and thresholds). This implementation also extends the memory
> limit enforcement to memory.high as well.
>
> [1] https://lore.kernel.org/linux-mm/20240920221202.1734227-1-kaiyang2@cs.cmu.edu/
>
> ---
> Joshua Hahn (6):
>    mm/memory-tiers: Introduce tier-aware memcg limit sysfs
>    mm/page_counter: Introduce tiered memory awareness to page_counter
>    mm/memory-tiers, memcontrol: Introduce toptier capacity updates
>    mm/memcontrol: Charge and uncharge from toptier
>    mm/memcontrol, page_counter: Make memory.low tier-aware
>    mm/memcontrol: Make memory.high tier-aware
>
>   include/linux/memcontrol.h   |  21 ++++-
>   include/linux/memory-tiers.h |  30 +++++++
>   include/linux/page_counter.h |  31 ++++++-
>   include/linux/swap.h         |   3 +-
>   kernel/cgroup/cpuset.c       |   2 +-
>   kernel/cgroup/dmem.c         |   2 +-
>   mm/memcontrol-v1.c           |   6 +-
>   mm/memcontrol.c              | 155 +++++++++++++++++++++++++++++++----
>   mm/memory-tiers.c            |  63 ++++++++++++++
>   mm/page_counter.c            |  77 ++++++++++++++++-
>   mm/vmscan.c                  |  24 ++++--
>   11 files changed, 376 insertions(+), 38 deletions(-)
>


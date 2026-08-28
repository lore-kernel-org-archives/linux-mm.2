Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF7D2C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 01:52:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 831EA6B0099; Thu, 27 Aug 2026 21:52:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E2DF6B009B; Thu, 27 Aug 2026 21:52:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D4666B009D; Thu, 27 Aug 2026 21:52:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39F256B0099
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 21:52:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 95637140228
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:52:07 +0000 (UTC)
X-FDA: 85149002694.18.DA71199
Received: from mta0.migadu.com (out-198.mta0.migadu.com [91.218.175.198])
	by imf05.hostedemail.com (Postfix) with ESMTP id 86E91100003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:52:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Ff5/NPe8";
	spf=pass (imf05.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.198 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787881925;
	b=b5EF4CYdo9pK+krj5v2KLd+tBdzrJgSs7RkkPomvAEj+wgGKHvPzibRYFzkr6lp7aW87TP
	Z2s4qeex/eFQ51YciSqeZEp8m4D9igBmjt8az6xgPXiORcS3vDPmtYfHT1qrizddrAhDb9
	EKO4GXjX5IjP49DYRGlNyhlQ3O3zVjw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Ff5/NPe8";
	spf=pass (imf05.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.198 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787881925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R6F1Cbiw/se1WXBK2l7zlGWjfCScgXF4DNQXIDardcY=;
	b=5hkQTriz1I2iD7GH24lpnT2xASdwGqN2jx1PV6GJ90l7MvRSArMCkLiCa9ij4e6Bm7WLzO
	ndxi9K3E13rZ5xg21nb/Uv617NBPuyxoPQigtC5k3UqTgam0fFfZoD3/clCH73zOIBEyYD
	t5aBo39+XdtrFlSqs1XevwC/A4JlrBQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=y7yB0bB4nuU8iui0WepOTzhFkm2WtSs4RSCP5Ouvwks=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787881924; v=1; x=1788486724;
 b=Ff5/NPe8hoo92rcRwqW0841g7IcPUpQDb+WPq4vz+gZjaDI5v3c4Qs8Aoi3H+ir3FbAynx+v
 B+J1oVRNdhfJtFK+yC/iXY5Ym0iy77CGWRGvUSMTATd75e+lPMzPhI/X9MSlj9Xlb4JKj1b7rlM
 /HTMB8teWPQXSQnnjspd/AcY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e5cd93c861d874df;
	Fri, 28 Aug 2026 01:52:03 +0000
X-Mizu-Trace-ID: e5cd93c861d874df
X-Migadu-Flow: FLOW_OUT
Message-ID: <02305fa3-775a-42fd-a53f-9e611d5cf3a1@linux.dev>
Date: Fri, 28 Aug 2026 09:51:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/mglru: fix ineffective memory protection for
 non-kswapd reclaim
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <linux-mm@kvack.org>, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>, stable@vger.kernel.org
References: <20260826133054.88529-1-ridong.chen@linux.dev>
 <20260827172141.GF3004@cmpxchg.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260827172141.GF3004@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: fezaiahbj3q4cp8eoqpag5xhmymoykis
X-Rspamd-Queue-Id: 86E91100003
X-Rspamd-Server: rspam06
X-HE-Tag: 1787881925-276395
X-HE-Meta: U2FsdGVkX1+xWGRHLEOGqsYDlAsWS+84VDdmirQFJgagola2pD22DM+YGLxa7RhszDFbH5zkRIDlhBLKhubP6ijeYAMaODXoOKAWqxYN1LEWnOJRUWhm8DOiHa1GtBHsxW+ZYBrMecKaU8T1OvaXxyD2NsprhAH2qbk/wGkwSj/TK4T6U5NADuTuzs8zoJNsOeovx9Z1HTWJ/x9vLALYyknkQlK2735/jSRtPoVvoB8o7JC8fTTfnmVb8AysFlufQ9jsJe8DKoInOZhO0qm/Lb6glJcl5LihOVjWMZk3TDxlw5COeP/3HrVHceAHH9SSF67SZ6cWXSKmsUiZeEyVqvHLniv1oAeVVvKuvgtLWLkqYJP4Ju6RwBtjr7+hbWap5vBm3q+6UDXW8Qr9Brh04GzkhErmoYMe03tgvv9l54GutG6eIQXWm7/CaPV1eYyuMIwdvMx8CwtcQj8F7D56Z2SB7fWMfvTCAltEv0nxOtOZhM1Jlytv96YDkEBvLx7YPmRRTxTG92MULk7FKa23WWQqQmaegYNxjEa3hYouwxc6LFDcmSsv6cv9rylnBa3hKmlTZMttHfifYIkVDvv/Fw11UYT9otf9dakhQx2kci3I/0S+/FY5Jv1crsoMqV7Uf1EIhmkxfeVEf5xDxVpwJqIzXBPh4JCk0mjqDnZZznUn0BZkE6Qdrel5nfSu3sk+YyzEVYGQJNz64RbUcRdc1kT6LeY5v/6EU21tW/ukBVqQASiqDZ4zFGKe2UceVg+GhWdHKJQh5Vg4A60JrJcXKbm3013eefkK/pzZlqTksx15EbSwZTcJJMl4VJAtSD+MXmo+VnX45wbBFeLL6/Pm9zIuenkSF0fmDotuOn7KTAeUXk/7eWuW1qKeo2Cuy7Hv/wF9YpMYGILEXzzjLKThF5L2GOLZ1I1jQEgU00qDJXiMqSMTtFmyuvQSnyreATPD1KAFmqFfPNNqhy4+JsS
 dgrygsXY
 5Bw43l8imND2gNaZLu7ioYI00VneKVH/VrpZodI2Gw+CDl7X3hyjfk/qhSfhtzgwOgJ3OZmBrvbbuz4z/9vaSXA+5LrfO17Ig33lOON8gxiCip33Pl0/Q3TzLjqfeOBjxx5OPGUNw7A05ZuqcmxjXl5bASc8eyRSJqdtmh52XCx/zAybrUHWf+Qh+X3HKc9w7f32Iqxe7z4wYVN6xgYWYudU7bMqZUM09oAA1yfnkVrb02EtrJn0Mpwiai8n6SM1I4DjpEQfoeegnNlYBo/4zY7hMv1gDb7xxIvmWtQJ2j3BdFlK/8lO/f8B7y+zsKb3owWfy0+C871c2nWlc0fgdsSyNCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/28/2026 1:21 AM, Johannes Weiner wrote:
> On Wed, Aug 26, 2026 at 09:30:54PM +0800, Ridong Chen wrote:
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> memory.min/low is silently bypassed for MGLRU during global proactive
>> reclaim (writing to the root memory.reclaim) and global direct reclaim.
>> It can be reproduced as follows:
>>
>>    # echo 7 > /sys/kernel/mm/lru_gen/enabled
>>    # cd /sys/fs/cgroup
>>    # mkdir -p a/b
>>    # echo 100M > a/memory.min
>>    # echo +memory > a/cgroup.subtree_control
>>    # echo 100M > a/b/memory.min
>>    # echo $$ > a/b/cgroup.procs
>>    # dd if=/dev/zero of=/tmp/testfile bs=1M count=200
>>    # cat a/b/memory.current
>>    222650368
>>    # echo 500M > memory.reclaim
>>    -bash: echo: write error: Resource temporarily unavailable
>>    # cat a/b/memory.current
>>    6070272
>>
>> memory.min is 100M, yet reclaim drops a/b down to 6M, breaking the
>> protection.  The traditional LRU path is not affected because
>> shrink_node() calls mem_cgroup_calculate_protection() for each memcg it
>> visits during a top-down tree walk.
>>
>> Commit 30d77b7eef01 ("mm/mglru: fix ineffective protection calculation")
>> moved the protection computation into lru_gen_age_node(), which only
>> runs for kswapd.  Non-kswapd global reclaim reaches shrink_one() through
>> lru_gen_shrink_node() -> shrink_many() without any protection
>> computation, so emin/elow remain stale or zero.
>>
>> Introduce mem_cgroup_protection_path() which computes emin/elow along
>> the root-to-target path only by iterating through the cgroup ancestors
>> array top-down.  This avoids the full tree traversal that would be
>> needed with mem_cgroup_calculate_protection(), limiting the cost to
>> O(depth) per memcg - typically 3-5 levels.
> 
> Right, because of the memcg-lru...
> 

Yep, that's it.

>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -5198,6 +5198,48 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
>>   	page_counter_calculate_protection(&root->memory, &memcg->memory, recursive_protection);
>>   }
>>   
>> +/**
>> + * mem_cgroup_protection_path - compute protection along root->memcg path
>> + * @root: the top ancestor of the sub-tree being checked (NULL for root_mem_cgroup)
>> + * @memcg: the target memory cgroup
>> + *
>> + * Walk the ancestor path from @root down to @memcg and compute the effective
>> + * protection at each level.  This is safe for isolated queries because it
>> + * ensures parents are computed before children.
>> + */
>> +void mem_cgroup_protection_path(struct mem_cgroup *root,
>> +				struct mem_cgroup *memcg)
>> +{
>> +	bool recursive_protection =
>> +		cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_RECURSIVE_PROT;
>> +	struct cgroup *cg;
>> +	int root_level, i;
>> +
>> +	if (mem_cgroup_disabled())
>> +		return;
>> +
>> +	if (!root)
>> +		root = root_mem_cgroup;
>> +
>> +	if (memcg == root)
>> +		return;
>> +
>> +	root_level = root->css.cgroup->level;
>> +	cg = memcg->css.cgroup;
>> +
>> +	rcu_read_lock();
>> +	for (i = root_level + 1; i <= cg->level; i++) {
>> +		struct mem_cgroup *cur;
>> +
>> +		cur = mem_cgroup_from_css(cgroup_css(cg->ancestors[i],
>> +						    &memory_cgrp_subsys));
>> +		if (cur)
>> +			page_counter_calculate_protection(&root->memory,
>> +					&cur->memory, recursive_protection);
>> +	}
>> +	rcu_read_unlock();
>> +}
> 
> Please wrap this in a #ifdef CONFIG_LRU_GEN block.

Will add.

-- 
Best regards
Ridong



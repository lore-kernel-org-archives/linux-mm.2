Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F319C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 10:13:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C02F6B0088; Sun, 30 Aug 2026 06:13:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16F4B6B008A; Sun, 30 Aug 2026 06:13:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 085736B008C; Sun, 30 Aug 2026 06:13:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C4B7A6B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:13:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3563CA029D
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:13:38 +0000 (UTC)
X-FDA: 85157524116.21.78D9DC0
Received: from mta0.migadu.com (out-245.mta0.migadu.com [91.218.175.245])
	by imf27.hostedemail.com (Postfix) with ESMTP id E6C9F40002
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:13:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hV9xK6G+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.245 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788084816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PHKJUx/v87vn2rRT/cCDlfgVC+ElcN14sQeQkxTybd0=;
	b=Y2dMXiU9UjcKsW+E6SWouce5PUMZuCowIKdofZsbhYCFm3A611rctBHDv3ncq4x6m3snkn
	Zfgtry1lo9nghUBWzc1hzzrLnq4TUFRaSgR1VkTb16tOt6sU96Pdc75+FiIPzxwH5E6zI8
	gCgTZHLSWYappTboIejWESkCRar0YEM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788084816;
	b=yx7eiUkFs7U7Svlbki3EvPqvTfILY98y+HbddMK6Mt4Rn3AvAhovJgFpbQhEG2I3LmcqSd
	xTTpJGj0lAuTGR4EvO199Vdn4MCJFLzZRw+PG2qC6KRpxqOAeip9drqY+Cvbx/LwAANFWk
	sJWUQMKO/kQL8ZLvFzBlje8G5ahIwi8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hV9xK6G+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.245 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=orh/j8jOJpiqrKlrLd2jKhjQfJBswjC/3RKWNPcbXdI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788084814; v=1; x=1788689614;
 b=hV9xK6G+s2tQILnyHfaicHJCKWu8j6ovNFFtf2xsQxXkp2ZITHcQNBjt9+UjsEvwE1aB2E0G
 +GzIb0G0qqZiCT0C2SSiqZj/7RNHTtSDxSB9PZlZOV7cZAsDmkEvVIjAErRVY6bBrzrBp1+oVPk
 WYn6rh9a84SOeEBHvOG/Gg1M=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e5d5919426a8fdc3;
	Sun, 30 Aug 2026 10:13:24 +0000
X-Mizu-Trace-ID: e5d5919426a8fdc3
X-Migadu-Flow: FLOW_OUT
Message-ID: <c0a32c3c-bff8-433c-8552-f0723e3a07b7@linux.dev>
Date: Sun, 30 Aug 2026 18:13:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/mglru: fix ineffective memory protection for
 non-kswapd reclaim
To: Barry Song <baohua@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Chris Down <chris@chrisdown.name>, Tejun Heo <tj@kernel.org>,
 Yu Zhao <yuzhao@google.com>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <linux-mm@kvack.org>, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>, stable@vger.kernel.org
References: <20260828110919.1324028-1-ridong.chen@linux.dev>
 <20260828110919.1324028-3-ridong.chen@linux.dev>
 <CAGsJ_4ws6edtcToqJQ0azJPTymAYj41nzdGJvBqEM+gROiJtRQ@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4ws6edtcToqJQ0azJPTymAYj41nzdGJvBqEM+gROiJtRQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E6C9F40002
X-Stat-Signature: r431ci894gbsg4trwcpbe8a8wutb9ygj
X-Rspam-User: 
X-HE-Tag: 1788084815-909183
X-HE-Meta: U2FsdGVkX19s1J5lvpz4MslgiBjJXkmXXDtzF6+H70AF5ka10c93JtwzFxowqVJPPnun0AmNUnUrG3VAn1EnK7FSu/78h6vIIGJmbsdnvxWv69cm3xuje+uk8OPNkv7RanI6+IKCL+OmY4PnQiAqeEjG5B9472hCw2azeyxyp0/+9rAwaCJDm/okYBdn3A3aeq4DfbH70kytrWTDkLB+N4UzEpPP0mx0A6/DZndO0SGxtOgFqraQtORxAvRYJZPBwpMb5Ui5CwJME7zgGYpPrJhad14XEllBXSyL4qItwz3o0yUf+OdA1r7lOPBNAN3/TXw19z10uQPb7A9aOslHP6iPt5Lg3e6gwhoKAW+/me7Zhvbmu4GKgXUzFO9IILEFnardN800bdr8izBQYb7NBKjP+Hm2/N1xXdbdx5iox6U+jDthu6jT6FeTmMlTSw37ZmqDPTjNW0YcPWFfvZ9Oa4yGjCDHmDCjYY4UQFjEUCZagND/obDlfTJtl7duSGEv5Ix9VV59FUBzrXR5hBPcADGAc4V2uH8GnXG1x+JuBpQKMd5BGf+AGyAjyXFvrk1NDRbvNRhtNNW+WS22LvpASNrCyRQE2QHO5m5zjK5kDqeW9krvEzn4LCBV628MhaBIsIEx20sXv2L6umRNW6YHKhvVyEBl7URjhVDLjxnye3z5d/AoTJJaUmwYDdWRDBM1CaS1gTKG6INxF6bL/gTcpfGbNbUAqRKY8mssLrpoC6ThUIhse4831Nv4N+GH86+7oT//eE6BlPWFBCGYqq/Cj3GWswMxA9lDBE6AEkcfOwOOWN19w05cj3qLfu40hmPQefJlK5j/8iMs/bQH4rhtmQBAOsmaxF1pK6cmGlelSP99/9LsYqRPw70DUw7tmxZyKBJd7RkxBdVll5aNSszoGDhBSxIBzBi+wlat5vo50Q3UtBDk0uHuUmWi5NBrWwwl0TZdOP/z1uieNzjFdxG
 4kR+rhaO
 mbYc5/0CY0TcXGxm2JCro6cktIcVWx1rylG14Pn6gyQEk2s7+8sHGElDxiWF0zOR7JlYRV1cE7+ZqvIBhGYJe8vMBbjlK4djltMv6YICK63QzOgdN2UIvQdV3xYjvpjOXwOFwac7HWh12NGaN7/MxFxpoV9uKviuO3wNiS1+d1xiEgVrB5rMfOqCFsKkZAstFDMyV17UsGqPcZhuiJ7wPmH7Nl0nyazwLuB4eS+NIO1vEXpzlxJLbDl9ST4nMjVRPZeRN6ZrYg0fddWn8WfI2I6z1lDyx93jbrOMeZexsMCpaVS39mJQlX0gVmQ1YOE11uf6bY7ru9LQ1gKnSXaavim5sKrQ0dL1A4zim
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/30/2026 3:53 PM, Barry Song wrote:
> On Fri, Aug 28, 2026 at 7:10 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> memory.min/low is silently bypassed for MGLRU during global proactive
>> reclaim (writing to the root memory.reclaim) and global direct reclaim.
> 
> I guess nobody is silently bypassing anything. It's just that the
> effective min is stale data. If kswapd has run at least once, should
> the protection have been updated already?
> I guess we need to update the changelog a bit?
> 

The children's emin/elow are derived from the parent's min/low settings and 
children_min_usage, both of which can change over time. As a result, emin/elow 
may become stale, even if kswapd has already run once.

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
>> protection. The traditional LRU path is not affected because
>> shrink_node() calls mem_cgroup_calculate_protection() for each memcg it
>> visits during a top-down tree walk.
>>
>> Commit 30d77b7eef01 ("mm/mglru: fix ineffective protection calculation")
>> moved the protection computation into lru_gen_age_node(), which only
>> runs for kswapd. Non-kswapd global reclaim reaches shrink_one() through
>> lru_gen_shrink_node() -> shrink_many() without any protection
>> computation, so emin/elow remain stale or zero.
>>
>> Introduce mem_cgroup_protection_path() which computes emin/elow along
>> the root-to-target path only by iterating through the cgroup ancestors
>> array top-down. This avoids the full tree traversal that would be
>> needed with mem_cgroup_calculate_protection(), limiting the cost to
>> O(depth) per memcg - typically 3-5 levels.
>>
>> Call it from shrink_one() for the non-kswapd path so that each memcg
>> about to be shrunk has correct protection values.
>>
>> Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
>> Cc: stable@vger.kernel.org
>> Assisted-by: Claude:claude-opus-4-8
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   include/linux/memcontrol.h | 11 ++++++++++
>>   mm/memcontrol.c            | 45 ++++++++++++++++++++++++++++++++++++++
>>   mm/vmscan.c                |  8 ++++++-
>>   3 files changed, 63 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index 7d1c0ce189a8..8066b798a759 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -605,6 +605,10 @@ static inline void mem_cgroup_protection(struct mem_cgroup *root,
>>
>>   void mem_cgroup_calculate_protection(struct mem_cgroup *root,
>>                                       struct mem_cgroup *memcg);
>> +#ifdef CONFIG_LRU_GEN
>> +void mem_cgroup_protection_path(struct mem_cgroup *root,
>> +                               struct mem_cgroup *memcg);
>> +#endif
>>
>>   static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
>>                                            struct mem_cgroup *memcg)
>> @@ -1133,6 +1137,13 @@ static inline void mem_cgroup_calculate_protection(struct mem_cgroup *root,
>>   {
>>   }
>>
>> +#ifdef CONFIG_LRU_GEN
>> +static inline void mem_cgroup_protection_path(struct mem_cgroup *root,
>> +                                             struct mem_cgroup *memcg)
>> +{
>> +}
>> +#endif
>> +
> 
> I wonder if we could follow the zswap pattern?
> 
> #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
> bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
> void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
> void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
> bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg);
> #else
> static inline bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
> {
>          return true;
> }

That is fine for me, I will update it.

> ...
> #endif
> 
>>   static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
>>                                            struct mem_cgroup *memcg)
>>   {
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 1271d390b617..095050d4296a 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -5198,6 +5198,51 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
>>          page_counter_calculate_protection(&root->memory, &memcg->memory, recursive_protection);
>>   }
>>
>> +#ifdef CONFIG_LRU_GEN
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
>> +                               struct mem_cgroup *memcg)
> 
> Can we rename it to `mem_cgroup_calculate_protection_path()`?
> 
> BTW, I see that the only caller is in vmscan and it passes NULL as
> `root`. Do we need to keep the `root` argument if the new helper is
> only used for global reclaim?
> 
I'd suggest keeping it as is. This function updates protection along the path 
from root to memcg, and could be reused later. Note that 
mem_cgroup_calculate_protection() assumes the caller has already performed the 
top-down walk, each level's calculation depends on its parent being updated first.

For mem_cgroup_calculate_protection_path(), it can be called in any context 
without such a precondition.

-- 
Best regards
Ridong



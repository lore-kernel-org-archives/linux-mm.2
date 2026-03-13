Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2EF0105F7A6
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 13:45:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFC5F6B0088; Fri, 13 Mar 2026 09:45:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBCC16B0089; Fri, 13 Mar 2026 09:45:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE96A6B008A; Fri, 13 Mar 2026 09:45:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E2F56B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:45:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3A3E91C089
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 13:45:20 +0000 (UTC)
X-FDA: 84541161600.19.24F60C0
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
	by imf28.hostedemail.com (Postfix) with ESMTP id 31160C000B
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 13:45:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773409518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SGJvo0KOJ3q4bbIocPj2xmOsJ6iYlbudNXH1vsm0u0s=;
	b=P5GDB8unPtFD7/jJ/NxIAaybos9wWhwHSp5j4NJCtiYFZT9lDKhZitSNJGeBZ/IJ39TS7G
	8QMjUtu+j+ndH86uhAjOoy5iJ8uKrOcp5FvppFJVonTdhiH7ZzKS1D9b7eATelMnzOINfj
	t5VxwsPmvntG7Gcr+vPrBOOXji2zd0U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773409518; a=rsa-sha256;
	cv=none;
	b=Qccol2xrR4VdFsBYceJbuZkzKL7rNdU9n+2wEcVtR9fDu+yivKOVkqZd2Hx/+rYMUPGt0r
	65VZr0SGex2I/YGPcXCBubZX3He87mncn7rs4Gzm3ex0CWVZTieIQV7rnegL5jISVFKZ0Y
	o4IKleHyAcdW+P5KillDjIpcVlDVkvU=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 70DE53EDDB;
	Fri, 13 Mar 2026 13:45:10 +0000 (UTC)
Message-ID: <f8191eca-2671-4916-bdc7-c4b21b52002c@ghiti.fr>
Date: Fri, 13 Mar 2026 14:45:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm: Move demotion related functions in memory-tiers.c
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: alexghiti@kernel.org, kernel-team@meta.com, akinobu.mita@gmail.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 gourry@gourry.net, apopple@nvidia.com, byungchul@sk.com,
 joshua.hahnjy@gmail.com, matthew.brost@intel.com, rakie.kim@sk.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260311110314.237315-1-alex@ghiti.fr>
 <20260311110314.237315-2-alex@ghiti.fr>
 <c679971c-fd4a-4c92-9301-67392abb1c8d@kernel.org>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <c679971c-fd4a-4c92-9301-67392abb1c8d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeelkeduucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomheptehlvgigrghnughrvgcuifhhihhtihcuoegrlhgvgiesghhhihhtihdrfhhrqeenucggtffrrghtthgvrhhnpedthfelfeejgeehveegleejleelgfevhfekieffkeeujeetfedvvefhledvgeegieenucfkphepudefkedrudelledriedrvdefkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpedufeekrdduleelrdeirddvfeekpdhhvghloheplgdutddrudeguddriedtrdektdgnpdhmrghilhhfrhhomheprghlvgigsehghhhithhirdhfrhdpqhhiugepjedtfffgheefgfffffeupdhmohguvgepshhmthhpohhuthdpnhgspghrtghpthhtohepvdejpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegrlhgvgihghhhithhisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehkvghrnhgvlhdqthgvrghmsehmvghtrgdrtghomhdprhgtphhtthhopegrkhhinhhosghumhhithgrsehgm
 hgrihhlr
 dgtohhmpdhrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhm
X-Stat-Signature: mitbe3i9dtciabi4ju1ktebuontu1d17
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 31160C000B
X-HE-Tag: 1773409517-508961
X-HE-Meta: U2FsdGVkX1/z4VPsHJWhSXjQccjDEmc7IQr6cp8MnpoHCahBVOeZmQeH9aADN7IFGGDAolaq5LSrBQUdYJN5s5Ks8v6Care53kiJrI1Q8DCFYujD/vcr4VQg0zsobw38i13R12/SLZaY31kHuQ3QN90SLP27lmGeNfdRufuzI5X7cmkSU20f693yannCdgClBupSwclkT+JaFs2tFZJEJAmGjY3kor4aqc43y/NjQPE8o6nOC1mnhA3KgHx01bg1QyayGe0Cya4REUvQHy7jcdE8LT45YIEMbMeKaHhtaoJQZ3aApobaH1OX2dA05Krmk2WIswKDFlA4IqPwtir0btnCFnPGEXgLsJaMUiRpd8plNw2ewBRByH9Zi1qG7nk8dMhZ5t5vePT6bx3NNQZK7AcOlm8oQ0Nlv7XObxFwF0H55LWs3vzR7At/a9fVi2R4x2iZcybmBn/AF2i1CNEJIH74V+rCvfG3Uyf6+T+/v0whnmX7yqBgQGFUcZo6sZfg1pz8eg/VsrsqALQUXah+AfEoWE5dWu0vr59J9HKXYd3pditDEJLIJXUZfRomuue/8/oie/aTNY7e1V5NtfrRvd4QKuXy0d/wcFC2JHz/De3k7vkaZFaIzL9cQXEocd4TYA7Vlr1iUC75yx9dSYpW+JeoCY9AEezYQbd1mzv3OJRmITu741H8hD+T5e52EfPlirZzanYq5gvLZ0UjUoPChunBlAAPMsIlsouDxvz0dZVpuhmZ4pySqPh5XfPACSo5KMiPHv7XHSeSef4KukKh5LnT+I/ELogne5/chXR7EEH+D8pRClxj98kQHjwShyPOwOSfkMN81DINftqLOklG/fFJ/7SuktD/6RPQklTmP2NE43YsCvmHS5puLIY2Xn28XT0wWmNibm6RKUv3c5LLUvW0+HAYy5k3Goy4qOilv2nncGV4EIHqZIXJmCItgocca5P5fRRoNx3fA8YZfyg
 mSKNM66X
 ktRZm03tHM5icXEbk82jEzdB9iDHwbV4XTTG3Z1z+2RRQfAL8JZML3AdPz1m7nqHW+Ffh+pdsUqQMB+P35aIEEqdvrenaiqVdU9yM1ORlugMru+qOcQywAururlzxfPRdoOwNG9Huzi8Gi2h+61tpvYrSQBNYmHxSriazRs7TdpomQBkozLg3X6x6GTM5MSfNpisecJwypt5hy7GF6WlJyxt13xS8d/LdLLBT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On 3/12/26 13:56, David Hildenbrand (Arm) wrote:
> On 3/11/26 12:02, Alexandre Ghiti wrote:
>> Let's have all the demotion functions in this file, no functional
>> change intended.
>>
>> Suggested-by: Gregory Price <gourry@gourry.net>
>> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
>> ---
>>   include/linux/memory-tiers.h | 18 ++++++++
>>   mm/memory-tiers.c            | 75 +++++++++++++++++++++++++++++++++
>>   mm/vmscan.c                  | 80 +-----------------------------------
>>   3 files changed, 94 insertions(+), 79 deletions(-)
>>
>> diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
>> index 96987d9d95a8..0bf0d002939e 100644
>> --- a/include/linux/memory-tiers.h
>> +++ b/include/linux/memory-tiers.h
>> @@ -56,6 +56,9 @@ void mt_put_memory_types(struct list_head *memory_types);
>>   int next_demotion_node(int node, const nodemask_t *allowed_mask);
>>   void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
>>   bool node_is_toptier(int node);
>> +unsigned int mt_demote_folios(struct list_head *demote_folios,
>> +			      struct pglist_data *pgdat,
>> +			      struct mem_cgroup *memcg);
>>   #else
>>   static inline int next_demotion_node(int node, const nodemask_t *allowed_mask)
>>   {
>> @@ -71,6 +74,14 @@ static inline bool node_is_toptier(int node)
>>   {
>>   	return true;
>>   }
>> +
>> +static inline unsigned int mt_demote_folios(struct list_head *demote_folios,
>> +					    struct pglist_data *pgdat,
>> +					    struct mem_cgroup *memcg)
> use two-tab indentation on second parameter line please. So this fits
> into a single line. Same for the other functions.
>
> Just like alloc_demote_folio() that you are moving already did.


Will do.


>
> [...]
>
>> -static struct folio *alloc_demote_folio(struct folio *src,
>> -		unsigned long private)
>> -{
>> -	struct folio *dst;
>> -	nodemask_t *allowed_mask;
>> -	struct migration_target_control *mtc;
>> -
>> -	mtc = (struct migration_target_control *)private;
>> -
>> -	allowed_mask = mtc->nmask;
>> -	/*
>> -	 * make sure we allocate from the target node first also trying to
>> -	 * demote or reclaim pages from the target node via kswapd if we are
>> -	 * low on free memory on target node. If we don't do this and if
>> -	 * we have free memory on the slower(lower) memtier, we would start
>> -	 * allocating pages from slower(lower) memory tiers without even forcing
>> -	 * a demotion of cold pages from the target memtier. This can result
>> -	 * in the kernel placing hot pages in slower(lower) memory tiers.
>> -	 */
>> -	mtc->nmask = NULL;
>> -	mtc->gfp_mask |= __GFP_THISNODE;
>> -	dst = alloc_migration_target(src, (unsigned long)mtc);
>> -	if (dst)
>> -		return dst;
>> -
>> -	mtc->gfp_mask &= ~__GFP_THISNODE;
>> -	mtc->nmask = allowed_mask;
>> -
> I think this function changed in the meantime in mm/mm-unstable. Against
> which branch is this patch?


Against Linus v7.0-rc3. I have just checked and you're right, I missed 
this modification, I'll rebase against mm-unstable.

Thanks,

Alex

>


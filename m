Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18D2E606A320
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 10:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c/cVKUWw
Received: by kanga.kvack.org (Postfix)
	id 1CC856B05B7; Wed, 28 Oct 2026 06:07:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A36B6B05B9; Wed, 28 Oct 2026 06:07:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06B976B05BA; Wed, 28 Oct 2026 06:07:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CFB826B05B7
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:07:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BC68FA0C73
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:06:59 +0000 (UTC)
X-FDA: 85371606558.13.4C8EC1C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id E25E7A000D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:06:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="c/cVKUWw";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793182018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aMKBLsxYHUnbIfVjoYx3Vq17ZceYoUGDZhH0VX3zlo4=;
	b=Snh03LO6gtVqmG9+kpoWysZM4McNHTCOnB4He22yEXZ8ASxumx6fFBqyP/NEm56ZPST2tQ
	+bV96x9QVfU3uW4c8bPWp7KUemDM3v9msXjIMzXn+jB3G+i1kcCyhZrdRjn/zL6y82NWs9
	wHDbqkp9P37UVAMmVCIEH9MbYL+jXEI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="c/cVKUWw";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793182018;
	b=Jb3/SF52c/sd2aAkEPAyR8uXk8MmI4S/ZSM7gVNkl4txG6tqglCsePYo6+nrhQ3gZdAvRe
	fRsH6xURTy22rWpFeuyJIvAzgo2sQLtKa6iKNxRGEf651xHFi+FbLH8rNvWZxjHXBPsTD2
	IRgT6W/9BkPjS5aaDle48LL+4X704DY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1790443BA9;
	Wed, 28 Oct 2026 10:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674FE1F01825;
	Wed, 28 Oct 2026 10:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793182017;
	bh=aMKBLsxYHUnbIfVjoYx3Vq17ZceYoUGDZhH0VX3zlo4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=c/cVKUWwvHQlXN8u4cB6G6LD5VOsTXkW1mYttiSFtfYQOC8o6gttQiR/PM29yMxre
	 retigVXoKJ0F5JJV4gU29i4c5I8lxwG24QQOku1iOAaPHnINtOyviaNmPdB3cihQ+r
	 wplgUCifRTKChtG7AS25gs2Cc31HDdxs+utyIqtN6UWTL+Su+Hg4DWIuUuz3tdvk37
	 S6dAoU+2qxiJBWwT3CkJPokw3/yMy5yTf2Bo4s9TqXC3MNAGSmNypMdYE/dcdJxfMW
	 rUzy71vmkFD+RmCUeyTTEUPa/4Y/3gNmOAilwn8aH0wiVczPw0scLV+4C3gMLftYC2
	 F7YXslqJKpYGg==
Message-ID: <11c6fd13-d2a2-4497-8417-d2176f1b5ecf@kernel.org>
Date: Wed, 28 Oct 2026 11:06:46 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/15] mm/mempolicy: charge shared policy nodes
To: Balbir Singh <balbirs@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>,
 Carlos Maiolino <cmaiolino@redhat.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Stevens <stevensd@chromium.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>,
 stable@vger.kernel.org, Pedro Falcato <pfalcato@suse.de>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org>
 <20261028-fixes_shmem-v3-1-4ce3baf2db4b@kernel.org> <auHINbCObZYzpNqC@parvat>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <auHINbCObZYzpNqC@parvat>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E25E7A000D
X-Stat-Signature: yjfeyrfw19yto1xw4zhb6g6byc8jw18c
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793182017-584680
X-HE-Meta: U2FsdGVkX1/+mQRfAgw+bnm1IVcbF85KG84ETYNU3s3QdL6II5uFssNan62uAPyv0ILCAIJB1IlmQL4YqJ+UD6NX7TklYAUt3OiOznjQDcq0TI/mISRD6zAe4atRe1Ji4ISzYgEt6kWjN5yeYFO/D3J+Z7FFCkqQj2IDZ3/KFPlnGdrm3MKZfyt7woIxgj0XpWOkOk5oCXr9czuQnPRLh/VXPBKd/sTUosS1juEDM7fTmq3FzIdaATSbMNysZTofBAp7f8XPcvJY0R9lNX4j9Rj9arP4LTKQSWffs0/ugQJm/i9bf1zVlBYtn8xl3K/lEBpzQq82GMN5OR/4bAZZdt93bW5Pp/aeF42OaR4kDbvsKL+J7RhN2W4vBtjtRjTvTZibLTW5GVIQTezq0g7VwBnKHaF+qSCFUAjY6PwgoAQfFf1y5nWIK+keY4jQTd8ezRuzLfk68ZGmBVmqz7MNPsmcMGiVzqAL6mgAAHeOQiXYPW1vENC3lhXH8NExQXeUsGMb7YgvsDvJR0wY1wmVXXtFZPZyKdRV6dTi2Q1UTXtcjc5amUEo291HbyXZRr3uG70W2PNjkQDj4rpTU7Ld+UQwh6wbI0Kyma8j5Fw+rWc0nR042U/zVc9SQ5fqfAmQnTGn119vYSR3244ITwNB9PiyhmN/1bLj4eAZjMPxtWdiEZ4aPhQ2Q52xzokMbxE+qWGM9R7W/BEyZgSEkOC0kve3c7X2LIm60AFBSqVwKD1RAbTPnqirOunUx1K+olUC0VFfeuSz91sogDUUndgAvbIRckjMc+7+IulpUvnzdChPS1TpoKgImUJI0WzIrcu6nDykLAnwRuqHh7aOebbxAQbOVpG4InnNlRNJFe+OVUqqS18m9Wx8ldcIslGS39Lht6vX2vmi/6tk+WtvjQj5oPguqNrS8+TJqR1uUUQsp6lSh09NrOtkPJi1ZPUqz8l2BxeaGH/Q2RclyBhdslN
 hei93fqp
 uhG+uUcE0faMFYg+sihs57wI+exwiftZ5k69mwYB2+I/2Bi94+FGWKuw43py1emt7Ft4q+6EdjiM1vA0lrqVAmunF+SGh1bHZi2NUEIZVtnEG6SYBsw56CVRGLspgcG8QDgmXKCe0BIkUc4GxGBTieopREvsPN1qyKYs/zej8s67wEDskYNvv29gr7nK7K4K26k1MEhSxxs5GrcjVpRqPmotKRTHCCkmmrBgQI8cpJV0Myjp7dMOownxB+es5L7osFnBpzEL9/hBGXnZvLkCQI35BZxlGI/bMHADDk35K8B+KKlvIKBqjNIvdRIJCkB/ts8gJtJEekynH+VVkcl1qLi8iZ7TFi6e75DxyzjcruBgYMWURtKCnBZ2DtZGEBXN9/CPBUgCzg07ZC68bJ+9oNckgQ6fBYPAxu34+tMbzYV25jFFeOmtaFHgKTkto+y6vBMSbJjWmCPUxYgfo23Hg1/XR0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/28/26 11:02, Balbir Singh wrote:
> On Wed, Oct 28, 2026 at 10:54:59AM +0100, David Hildenbrand (Arm) wrote:
>> From: Chris Mason <mason@kernel.org>
>>
>> Any local user can bypass memory.max with mbind() on a tmpfs file, and
>> allocate unbounded kernel memory.
>>
>> mbind() sets a NUMA memory policy for a range of a mapping. If the
>> mapping is of a shmem and friends, the kernel also stores the policy on
>> the inode, in a tree with one entry per range of the file.
>>
>> Each mbind() on a single page of a mapping can add one shared policy node
>> (struct sp_node) and one struct mempolicy to that tree. They outlive the
>> mapping and stay around until the inode is destroyed. The tree is not
>> bounded by the file size, so the file can be empty.
>>
>> Memory that user space can allocate must be charged to a memory cgroup. A
>> slab cache does that for all of its objects if it is created with
>> SLAB_ACCOUNT. numa_policy_init() creates the slab caches for both
>> structs without SLAB_ACCOUNT, so they are not charged to any cgroup.
>>
>> Reproduced with mbind() on single pages of an empty tmpfs file, from a
>> cgroup with memory.max=8M: the global OOM killer killed tasks owned by
>> root, and the machine panicked.
>>
>> Fix this by creating both caches with SLAB_ACCOUNT. This change implies
>> that mbind() can now fail when running into memcg limits. Further,
>> the policy_cache also serves task and VMA policies, so they are
>> similarly accounted now.
>>
>> Note that per-file limits are not really helpful, as the user could
>> simply use many files; having limits per user is tricky as well.
>>
>> Fix generated by an LLM and submitted by Chris Mason in private.
>>
>> Fixes: 5d097056c9a0 ("kmemcg: account certain kmem allocations to memcg")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Chris Mason <mason@kernel.org>
>> Acked-by: Pedro Falcato <pfalcato@suse.de>
>> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>> Acked-by: Zi Yan <ziy@nvidia.com>
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
>> [ david: smaller description tweaks ]
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>  mm/mempolicy.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
>> index 0884c629670d..4da1cb8777f6 100644
>> --- a/mm/mempolicy.c
>> +++ b/mm/mempolicy.c
>> @@ -3372,11 +3372,11 @@ void __init numa_policy_init(void)
>>  
>>  	policy_cache = kmem_cache_create("numa_policy",
>>  					 sizeof(struct mempolicy),
>> -					 0, SLAB_PANIC, NULL);
>> +					 0, SLAB_PANIC | SLAB_ACCOUNT, NULL);
>>  
>>  	sn_cache = kmem_cache_create("shared_policy_node",
>>  				     sizeof(struct sp_node),
>> -				     0, SLAB_PANIC, NULL);
>> +				     0, SLAB_PANIC | SLAB_ACCOUNT, NULL);
>>  
>>  	for_each_node(nid) {
>>  		preferred_node_policy[nid] = (struct mempolicy) {
>>
> 
> You have many of them already, but anyway
> 
> Reviewed-by: Balbir Singh <balbirs@nvidia.com>

I love it, thanks to all of you :)

-- 
Cheers,

David


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C142ECD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 07:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B462C6B0088; Thu, 14 May 2026 03:46:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1DF86B008A; Thu, 14 May 2026 03:46:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A33A36B008C; Thu, 14 May 2026 03:46:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8F6926B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 03:46:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3D1921C0473
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:46:34 +0000 (UTC)
X-FDA: 84765243108.14.0003170
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2D21F1C000E
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:46:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LnuxCmOE;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778744792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7BXh7Wq3QIg5RrVVGGpiWPGFI8Di4Dx49OSkadeSPsk=;
	b=ysgDgfA61jRmRXnQGmiPmLT542r4WUUPKkflb2Rao4lr5q3YKciDIOGuLDWTCuvUoMefIJ
	JAsbw5iJ16GjK1HUgleYC/ZzHqVevCzh/+qvUoWzL6hdkWGPeKOnQRykZJnehiEVVN80CW
	MAeEmbe0qycZ7CVUwUwlJnkqI+XWMHk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LnuxCmOE;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778744792; a=rsa-sha256;
	cv=none;
	b=Z56oxjMgvAa8Q19pgrEEli4xFwumDx/SGRVUDnCbzp8HN3LP8PVXuMGG4ZdLZue0diWTLV
	XwmVGm4QyfkFxLv2/d23SWd9nRvDUsoSZioKy+OwJtkwz404Q+sv5KzyqIKqU2Dk8YgsBw
	B1Bl8msnfDOFcgikdD/oT+IRTCnq0aA=
Message-ID: <46e9f5cf-34cb-466d-a53a-5778768af4d9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778744786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7BXh7Wq3QIg5RrVVGGpiWPGFI8Di4Dx49OSkadeSPsk=;
	b=LnuxCmOE/Gt9rOs6iQDfu++nrJdD3Dr7snau9TxwVon6wjjgXBsx51tlvO4SmGP6EL18mF
	UfdVt2E/i4rSLYRU1nZWUUFNi7Qc81c236yHMNGcbcyDu4gUdcTv30xImxIisvC0R9zWkW
	Qx+0qbUp/x29Tjx6uP8IyFf1sgCBAfA=
Date: Thu, 14 May 2026 15:46:06 +0800
MIME-Version: 1.0
Subject: Re: [linus:master] [mm] 01b9da291c: stress-ng.switch.ops_per_sec
 67.7% regression
To: Shakeel Butt <shakeel.butt@linux.dev>,
 kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, David Carlier
 <devnexen@gmail.com>, Allen Pais <apais@linux.microsoft.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Baoquan He <bhe@redhat.com>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Chen Ridong <chenridong@huawei.com>, David Hildenbrand <david@kernel.org>,
 Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
 Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>,
 Imran Khan <imran.f.khan@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Kamalesh Babulal <kamalesh.babulal@oracle.com>,
 Lance Yang <lance.yang@linux.dev>, Liam Howlett <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Muchun Song <songmuchun@bytedance.com>, Nhat Pham <nphamcs@gmail.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Usama Arif <usamaarif642@gmail.com>,
 Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>,
 Yosry Ahmed <yosry@kernel.org>, Yuanchu Xie <yuanchu@google.com>,
 Zi Yan <ziy@nvidia.com>, Usama Arif <usama.arif@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org
References: <202605121641.b6a60cb0-lkp@intel.com> <agNO8G8tPnPuVrGq@linux.dev>
 <0e1b8994-944d-4dda-8966-3cd43661796d@linux.dev> <agSAT4ldp3dzKWPl@linux.dev>
 <agSJ4ulNDZ17ah8H@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <agSJ4ulNDZ17ah8H@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2D21F1C000E
X-Stat-Signature: mko83t1qy968jd5qd943zxfp8g1gw3y6
X-HE-Tag: 1778744791-214282
X-HE-Meta: U2FsdGVkX1+JepxUbjZXAVGipwiJCditdSWoxSPOHwF2cyt0kAHxPvwD8qZbcrLHPrV2MWeGtPmu1tENew+ggKkOPMhRlVyTGD5wqOHW5eadDSnOw2NjiubsxAP+LLe/KIuevmwzmwg7X7856ZK37eqOSK5gSAlPXUpeunPXczi8RSCTiCWxTgqdFfw9ut93Q6aV3PZbOkP52cdOL1Lj/IjzscCzfavy21wlqt9MWF9LJeh/qJdH5VI7kBHdTbGVUXKDRIp/B1O3pS3ZzIldK/KSDhSxn77PIzwkHHb9UZJ81Nak3OjagnmHocFAFYD/W9vxs5mxcBB5L5IA8NNpA98/1STp9OtTH96rKQM0ZkoGExZ0nDqwf7oiM72n3HS7cxxcKOXJtZlHjShgWxl9iA+kUI2hpbtW8r3kzodGD7xZaZlky7Bm4DBAHi9NMhGPBzCWG3jlU3o/5ihiqnfEjzovKW3VHTOs4q91t+EUvGebX8FiZUwpd17lDHUSbJxQXutH2Exi66NXnrC5Jod/wIj9wGnpi4tZRScNsiBKTNNU5hT9O0UawXpElJzdB86W5KgTiP/GlcimKuTh/GjSiq23/IhhUfq5ozjq/cawc9lm4FyLOAiqtMZOncg69M4JDwUd74jRIRP5lvZzJsnXnvkCUKeePWcvrdP6tinpuSZk07iQe09sCP8jpbr6E9N2xf8ygwPkC5ZanLV37TBtcqCr5vzPr3hUfNu6nRHebDS+zqqa2s17qelD4T870eCnUrTXNxCHkCwFKzAn6a39BIfBag2RsvCpv/xED88dkldPYUD/TSxgeAKczyxprccTIiHnONwxVrtJMb22U1DIm3sfQFwUfQ1cxpfysaMwvXPnBdRBRPa6GM+8L3FpaOBZF39L4+zYlQpzZPyh7ifqNuGx7tAC9ZcWuLf8WxTfzZwK2hAV3ZKtylPfR5/+pLU3cITMfp6+9hMHWEy0jSD
 TR77vErY
 ch6uunmxmR9f2ZhQFBTPlpuPnh/KK/1ddCjNxr4hUnM8dkEvu6yXKR0N1jbWwpbuo5/umdaL+6GTujslVOysdB4Ev5as+MDViNDXVjVVA/qZS2P2cQM2Us9uKFCgbB6W8IzLavaXEukSBfEftCD189p+DCUghRmpfwujsdXVgPnXRz4lE2Qw4KoGbtGIKq9C53sYbt9w2i/+9zbFJ+D/QaLoyNWzY4mfG5XAzgth4Fr3ZQXI1dz5S5rz41LZCezkiGDpWc3+u26HJ6YbM+NGiH2DdaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 5/13/26 10:27 PM, Shakeel Butt wrote:
> On Wed, May 13, 2026 at 06:49:45AM -0700, Shakeel Butt wrote:
>> On Wed, May 13, 2026 at 10:10:34AM +0800, Qi Zheng wrote:
>>>
>>>
>>> On 5/13/26 12:03 AM, Shakeel Butt wrote:
>>>> On Tue, May 12, 2026 at 08:56:52PM +0800, kernel test robot wrote:
>>>>>
>>>>>
>>>>> Hello,
>>>>>
>>>>> kernel test robot noticed a 67.7% regression of stress-ng.switch.ops_per_sec on:
>>>>>
>>>>>
>>>>> commit: 01b9da291c4969354807b52956f4aae1f41b4924 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
>>>>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
>>>>
>>>> This is most probably due to shuffling of struct mem_cgroup and struct
>>>> mem_cgroup_per_node members.
>>>
>>> Another possibility is that after objcg was split into per-node, the
>>> slab accounting fast path is still designed assuming only one current
>>> objcg per CPU:
>>>
>>> struct obj_stock_pcp {
>>>      struct obj_cgroup *cached_objcg;
>>> };
>>>
>>> So it's may cause the following thrashing:
>>>
>>>   CPU stock cached = memcg/node0 objcg
>>>   free object tagged = memcg/node1 objcg
>>>   => __refill_obj_stock --> objcg mismatch
>>>       => drain_obj_stock()
>>>       => cache switches to node1 objcg
>>>
>>>   next local allocation tagged = node0 objcg
>>>   => mismatch again
>>>       => drain_obj_stock()
>>
>> Actually I think this is the issue, we have ping pong threads running on
>> different nodes where though theu are in same cgroup but their current->obcg is
>> for local node and thus this ping pong is thrashing the per-cpu objcg stock.
>>
>> The easier fix would be to compare objcg->memcg instead of just objcg during
>> draining and caching. In addition we can add support for multiple objcg per-cpu
>> stock caching.
> 
> Something like the following:
> 
>  From d756abe831a905d6fe32bad9a984fc619dafb7e0 Mon Sep 17 00:00:00 2001
> From: Shakeel Butt <shakeel.butt@linux.dev>
> Date: Wed, 13 May 2026 07:24:55 -0700
> Subject: [PATCH] mm/memcontrol: skip obj_stock drain when refilled objcg
>   shares memcg
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>   mm/memcontrol.c | 14 +++++++++++++-
>   1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d978e18b9b2d..01ed7a8e18ac 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3318,6 +3318,7 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
>   			       unsigned int nr_bytes,
>   			       bool allow_uncharge)
>   {
> +	struct obj_cgroup *cached;
>   	unsigned int nr_pages = 0;
>   
>   	if (!stock) {
> @@ -3327,7 +3328,18 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
>   		goto out;
>   	}
>   
> -	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
> +	cached = READ_ONCE(stock->cached_objcg);
> +	if (cached != objcg &&
> +	    (!cached || obj_cgroup_memcg(cached) != obj_cgroup_memcg(objcg))) {
>   		drain_obj_stock(stock);
>   		obj_cgroup_get(objcg);
>   		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)

This change looks like it should be able to fix the ping-pong issue, but
I stiil haven't reproduced the performance regression locally. I'll
continue testing it.

Hi kernel-test-robot, could you help check if the patch above fixes the
issue on your end?

Thanks,
Qi




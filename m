Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B228E9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 18:02:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C4E16B0088; Wed, 18 Feb 2026 13:02:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81E016B0089; Wed, 18 Feb 2026 13:02:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 729CC6B008A; Wed, 18 Feb 2026 13:02:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5BE186B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:02:35 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E1DBCC163D
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 18:02:34 +0000 (UTC)
X-FDA: 84458347428.30.C2622B0
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6568F40016
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 18:02:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pIrisjkg;
	spf=pass (imf04.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771437753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cx1YFMXeXn8Jw1SsA/vK5p52GVwbuIAqyFb1QuBwKqE=;
	b=WCr3WtuBLRMaCTKw1oL/Y0i9iJLNiB6hTqvypraJMXvkLRIWMVzcjqB2Vm5DE2tXjxe/ya
	XxURbKD0Bguk1keskIOelQmknPN0EPp5A2g8Kn/PFX0Mxtlw4ktmBHe0BMdUyGidjnyQr8
	PZCS/ZbuY8+/qkV0n1ZOj2Mf/rMokgc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771437753; a=rsa-sha256;
	cv=none;
	b=FbR46LhyDra9BrqK8ECOg1oE5lKwqLW1+KJMh4r65ucGY7ISvTiUAFB6OhTHErNivPcwEr
	a71G1ColtWTz3ZOeEgmhcGd1T/PPa/UPQ7rJ0NcMpCG90XWuokxo7Iwi9NGO1mCmxYLHKe
	V1NjxG1zt+ik9xv/C4cBMOkGXwDm9Ag=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pIrisjkg;
	spf=pass (imf04.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <fbcd6770-f555-443c-b5f2-fe5e73722118@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771437748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cx1YFMXeXn8Jw1SsA/vK5p52GVwbuIAqyFb1QuBwKqE=;
	b=pIrisjkgRvEhyzm7mm89uxk+UXLZ3lxBEZan3dCK+yy0F568+BiAbZu8NBsKky8pzCkCCT
	uUW9PM9BMQvrw7vEkEVZlCqeTiQ4DXVLb5kwHS4v2KGbO/FRZ97l15af7lOF568zsJcNJd
	ZDigBiY/QGr91OsSfQbgpnzWCW/+E/c=
Date: Wed, 18 Feb 2026 10:02:15 -0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm: move pgscan and pgsteal to node stats
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, linux-mm@kvack.org,
 mst@redhat.com, mhocko@suse.com, vbabka@suse.cz
Cc: apopple@nvidia.com, akpm@linux-foundation.org, axelrasmussen@google.com,
 byungchul@sk.com, cgroups@vger.kernel.org, david@kernel.org,
 eperezma@redhat.com, gourry@gourry.net, jasowang@redhat.com,
 hannes@cmpxchg.org, joshua.hahnjy@gmail.com, Liam.Howlett@oracle.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 matthew.brost@intel.com, rppt@kernel.org, muchun.song@linux.dev,
 zhengqi.arch@bytedance.com, rakie.kim@sk.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, surenb@google.com, virtualization@lists.linux.dev,
 weixugc@google.com, xuanzhuo@linux.alibaba.com,
 ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
References: <20260218032941.225439-1-jp.kobryn@linux.dev>
 <10434f89-fe2a-4cfc-9b29-1cd2ed2bbb7e@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
In-Reply-To: <10434f89-fe2a-4cfc-9b29-1cd2ed2bbb7e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6568F40016
X-Stat-Signature: tkrzyujt9seazfkcoskk766zcte65wgg
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771437751-704584
X-HE-Meta: U2FsdGVkX1/RCjjBRB6xMQipUrBaQCh3AkM/asihWOMMcinnvYlKET5/Gldh/2iQe8U6+6MPpfoVR79g24FH5DGyA4BjKqX0si6MQDIU/esfrRyqCB8HHFUECFH0mcQWDhtR3YEbyDV/WOCnRyaobGBhhId2ehdU2FAigIWtrLO7GjaAGoD23PrM/Ej5nxUWaGfDtIIdgQCQb5IWs3imeEoHbltEuX1lu+L0wGEOWZRx7NT15zdD+9RFF9rGHrpuIMsp8bhAz0Y6G6oJAVt9fSTeMgMD83Kih+ZJ+UCC9TqPSpTaf/nWgTUHzy93HNNNDHjE2DMLZugPKRmeX70vGNQO/uBiNIPgSM8THsShIgzq0ygNfrODa/bBgR4lIKcQKN4TimLpJ9pc7BBw+QMkSI+49sMmy+bsUO3Gw5ePtLsL6iUag2/sgmKRJ1yy3Os7lcBtWr7q0yP6OiCe27NNaNfe2e5niEdp2HKbB9CgTPrT3UM+MWKbv23mUy0JYB9GOtIOeyqAYmRGsQm5X7vuXQ3LaI+k7/eCFlRVB7C/q7mdWgeiqIfqkftbNS5D0KGTT187QnJXNJTPgnU9kv2Jz9mBieASMVirzqcV4/Gur3OwNJsZhCy+ox7qPotDpliC5oqjqT1fvRHFhF7BII1YOKpksRBvb0Ds/APmJxOs3qLhH8E4wcQoLY76ZqhmTy6DQaM2JmqRyKhDQD5r74aL0OTjEMi5EawRCIeCEWmESU8KSlzdyTaILtjrkDdqayZoQA2XNqNq+yM+NWr7miRU7Wj3GlL+ousHBynqAfqqxQO9+OBPxAEhq3pCzZokeWcJwOWljKyI2LKgT2U4mPYzlnTXEEBgQY+mauqC/x8XIUrvGTN//7YuKsQF6Sd/2VIp6NbM+VODQRsR1O9RIm62zWW7tm1N0HL5WSMf4Ptdb2e8Bq7CQ9OcIjeza3g0/G+C0rkcwePzg1t+hHBCjWW
 1nmtj01R
 ptMuGl18GaVZgzBOhyDMZvWvd515jOYvQ5VFNmws0vEG3R4HBdj0UIiKkhM+nQr7avAt2Sqbd8n2hEJPZIuTEuTAsqAyLYhb1wDNEvi9WgcvbCoalhCK2AhxTClMgxWT78IVXH/279FIAkGbtukC8Hpvo6Q08tP1VvVjMGKZf8zz3fiMrtpB4pjGkV7m6yXomL71nPkRPfRXOMIplznX3WxNW45hXokWF7X+X8vja/2exELy3UxodUl4tGKGx+uSAUDrfAcyzIh2AqRd7PwlBPspFtg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/18/26 12:54 AM, Vlastimil Babka (SUSE) wrote:
> On 2/18/26 04:29, JP Kobryn (Meta) wrote:
>> From: JP Kobryn <jp.kobryn@linux.dev>
>>
>> There are situations where reclaim kicks in on a system with free memory.
>> One possible cause is a NUMA imbalance scenario where one or more nodes are
>> under pressure. It would help if we could easily identify such nodes.
>>
>> Move the pgscan and pgsteal counters from vm_event_item to node_stat_item
>> to provide per-node reclaim visibility. With these counters as node stats,
>> the values are now displayed in the per-node section of /proc/zoneinfo,
>> which allows for quick identification of the affected nodes.
>>
>> /proc/vmstat continues to report the same counters, aggregated across all
>> nodes. But the ordering of these items within the readout changes as they
>> move from the vm events section to the node stats section.
>>
>> Memcg accounting of these counters is preserved. The relocated counters
>> remain visible in memory.stat alongside the existing aggregate pgscan and
>> pgsteal counters.
>>
>> However, this change affects how the global counters are accumulated.
>> Previously, the global event count update was gated on !cgroup_reclaim(),
>> excluding memcg-based reclaim from /proc/vmstat. Now that
>> mod_lruvec_state() is being used to update the counters, the global
>> counters will include all reclaim. This is consistent with how pgdemote
>> counters are already tracked.
> 
> Hm so that leaves PGREFILL (scanned in the active list) the odd one out,
> right? Not being per-node and gated on !cgroup_reclaim() for global stats.
> Should we change it too for full consistency?

I'm fine with adding coverage for the active list side as well. For
completeness, I could also include PGDEACTIVATE.


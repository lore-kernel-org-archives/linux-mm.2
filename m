Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D739D4A5EB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 03:24:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E28EE6B00F0; Sun, 18 Jan 2026 22:24:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E004D6B00F1; Sun, 18 Jan 2026 22:24:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFEAA6B00F2; Sun, 18 Jan 2026 22:24:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BDDDC6B00F0
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 22:24:50 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 70F5A1A0655
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:24:50 +0000 (UTC)
X-FDA: 84347271540.13.A2914E0
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id AF81040005
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:24:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OskWVJCa;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768793088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/u7bgCCXQygRKXDqWsDO9xgbjYn7erHByh7PdAeVAHI=;
	b=h3OOw6uTE1tzdSbZ3dWxyIcZ4IqKH8ESjiVXwwh3tvYFMVOQMSehs07HObqWTKf3cJpm91
	P3afdGOKx2MwQXMmKj801RYMuCuOYiWE0LppMOf/uDv/QU21uIwy8KgQIyYMbzzX1T0ZrO
	iRbJNe5UY/c5WGuTpOBmVZnLDL+/4CU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768793088; a=rsa-sha256;
	cv=none;
	b=FWmO5Zbk1smLQTztxN1tjOoIh/WxWvFY4QAuz/TbSf5cxTFL7eCiTC/w2ES+O8b/s7q16l
	9cq8Od27eAk3dkDUZBB1gfPhOKgMlXEBmOQcifGn4MH2UdRd/i1lAxacXwSZ539EpuE84a
	Hv6jbZr9C2EQTEnSYBsk0Ny4KY16bas=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OskWVJCa;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <4d666f52-1494-4a93-b541-b02b46a887e3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768793086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/u7bgCCXQygRKXDqWsDO9xgbjYn7erHByh7PdAeVAHI=;
	b=OskWVJCaxAXJlAIn800rXjaLTv7UE7fT/d6va/GzZJ7d2syED6eSb5Xu1Z+9EZAk+4B0YH
	aGRijvZNaPzjg5K3vMcPaLahpdM1ZodPqVONh11wLhj/ivSymTcMcUFdLdJW8RlqcdxYzT
	7mos5S1EPq9w+NQZx/lxjE/iGikc11g=
Date: Mon, 19 Jan 2026 11:24:22 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 25/30] mm: vmscan: prepare for reparenting traditional
 LRU folios
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <3adb367000706f9ef681b34d0a2b0eb34c494c84.1768389889.git.zhengqi.arch@bytedance.com>
 <6hlbucao3tfp2bxyaekcrvhqclji4hyhq4wen4sccc2qcdr6x2@rtmqrfwfsy4s>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <6hlbucao3tfp2bxyaekcrvhqclji4hyhq4wen4sccc2qcdr6x2@rtmqrfwfsy4s>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AF81040005
X-Rspam-User: 
X-Stat-Signature: 4qf6yahuucrf3egignf8r1qbhq5aosbm
X-HE-Tag: 1768793088-341418
X-HE-Meta: U2FsdGVkX1/13m6KwocZdoyYiQlvLpCrSHh5kQNdHDeOwEHNRPxZCqnLT+QJ4/JVFq1NYY8f8HADEPb0uxA1SruQE57WXAbcTOUGR8kD4EQIu9Q6bsky5asJYBx3qjtmHgF1XbcICKppNXnBzZzchcDN1PCozKXiwlz0YTERS8yrMkWTalVHFd0dVbeJ+Vb1uIzqLKEkY6cU8p0NBJXTvaNA606882YEAt9+ttjidBGkFfaK46nVtVQYXgi6ishJIvuHbwr5ETvraxLqHcXZD/rYrCYBfiqKqfaJafutKsHUEROtvtnFAGTy/NO3DbzxUXokoq54xulSqvNCUaNH7RNuzsiO6xukGLehAQtm4+aJcLlj8VfGnYdzq+6NYmF+D303w47Qu4LF7J/We73RBCQGSVH8djO75i2Kg1GpL9bAH9kFNlikIaxpxCVEQ9sGl3ckzr4eTn0TRhIsqAuyIUxYW6H2VtbC/w3BfStfnj0aLWqJzJmPYSxSFfj26MGx3sjMUfcthAAUTRl6iXj6R8nuf1lx6GJvEY/Pqn1YhbEc8N8NsZj2hl08SC686j6l/lM7uohrRnrufWSx1gAwTZiQawhTxy7GecYxpwIQOiHWWQgCcC5KjpGSkQkBauFZ/79Ril2laSChZ945Litzerukc9D78YrMcWDnj74PLuU5990SQV0lrEmPwK8sXyrfxqHW+dnr0XeJVQRl1WzbocpbwPTJrew5ad5PUsEMSoaJOdC+ZQM0dFt3K6XTM2un6uDdv1WJjHgllahnaGQO+0D8nt38+isff/ydPgcoAs/JhbKBejY9PT53/XaQO4mIapyr8bBv/NiNZBFvOZXhW6/sE8wCwipXdoeRJvi9s5m5FQ1ng3mOnkD50ddVoM3jKM1Ft1+2QzbtsQsS+VIx0Bpk+wX7b2/u48yc27UrJMSRQxQ8Q0vPNCdbpBlBuGY2kUl5yuNnd1W4sNWNPfl
 NS3uoBeF
 OocgJ0Vm+ZFC5cktOUpMJUtj4EoXaNdwg+R8x4Ty2IrrTQd0qdG3jMrgq65jdU4uU6jmaUAtCK22ortXekUsddTdeXBe8HZYa7igHCGTT8YLdpPNWt6G4oELqdLx1DmJhCXXaUKPUiCfL4WW8CaqoEF8CXWftwNd2xf/3+pG/j8Y/aXAbSMnqv9e4uoSr58uvnXcCk3PJKDnzRU8JbIpu75nqNtYHXtUbS8NV+TWhK7MSpB64ZWDyliw21Eiyk3y7NSdxgCIyrncbmZTjlh7Z+UquaNYTp7w1RiP2USBDFuKH3FvfdPiqloEOwzdN3c3qoulO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/18/26 9:11 AM, Shakeel Butt wrote:
> On Wed, Jan 14, 2026 at 07:32:52PM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
> [...]
>> --- a/mm/swap.c
>> +++ b/mm/swap.c
>> @@ -1090,6 +1090,43 @@ void folio_batch_remove_exceptionals(struct folio_batch *fbatch)
>>   	fbatch->nr = j;
>>   }
>>   
> 
> Why not define the following two functions in memcontrol.c?

Ah, Because Johannes previously suggested [1] putting it in swap.c:

```
Lastly, vmscan.c is the reclaim policy. Mechanical LRU shuffling like
this is better placed in mm/swap.c.
```

[1]. https://lore.kernel.org/all/aUQCfdnoLQDLoVyg@cmpxchg.org/

> 
>> +#ifdef CONFIG_MEMCG
>> +static void lruvec_reparent_lru(struct lruvec *child_lruvec,
>> +				struct lruvec *parent_lruvec,
>> +				enum lru_list lru, int nid)
>> +{
>> +	int zid;
>> +	struct zone *zone;
>> +
>> +	if (lru != LRU_UNEVICTABLE)
>> +		list_splice_tail_init(&child_lruvec->lists[lru], &parent_lruvec->lists[lru]);
>> +
>> +	for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1) {
>> +		unsigned long size = mem_cgroup_get_zone_lru_size(child_lruvec, lru, zid);
>> +
>> +		mem_cgroup_update_lru_size(parent_lruvec, lru, zid, size);
>> +	}
>> +}
>> +
>> +void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent)
>> +{
>> +	int nid;
>> +
>> +	for_each_node(nid) {
>> +		enum lru_list lru;
>> +		struct lruvec *child_lruvec, *parent_lruvec;
>> +
>> +		child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
>> +		parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
>> +		parent_lruvec->anon_cost += child_lruvec->anon_cost;
>> +		parent_lruvec->file_cost += child_lruvec->file_cost;
>> +
>> +		for_each_lru(lru)
>> +			lruvec_reparent_lru(child_lruvec, parent_lruvec, lru, nid);
>> +	}
>> +}
>> +#endif
>> +
> 
> 



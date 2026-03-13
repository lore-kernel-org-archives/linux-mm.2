Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F882105F784
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 09:46:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 380356B0005; Fri, 13 Mar 2026 05:46:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32DAB6B0088; Fri, 13 Mar 2026 05:46:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23A156B0089; Fri, 13 Mar 2026 05:46:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1346B6B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 05:46:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7BDCF8C750
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:46:21 +0000 (UTC)
X-FDA: 84540559362.26.4D3723D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id B547518000B
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:46:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F4nu0SdS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773395179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hb57Nj1RMX0UNoraIglV9XmKSWdqtyTmPeBbGZkF0J4=;
	b=BNd+fPqDWV5jwqs67ozXbGryK51FMoJ2jhrm0VvhLtbgqVB9GapTJX/ofFUef0mE8kqiPH
	6f9WJfTJCpGL8INjCpFq+98BC5I123fBkN2ESgJ+St55yUfJNugEjJqwNKDSaP/zE6w/mU
	KEEUFaC1ZIeK8WZwGzb5lKW072NAMdY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773395179; a=rsa-sha256;
	cv=none;
	b=eqIr+5kqamzSJ3/lAuIsJAH4WR6oez+mDdfMufynMvbF4gn6YZkzcjdJj3vYY96Y/sshcs
	0uGTNdFIGAOza2vHXuzyJObfoSQACnbFwEtS6llHeqgnP4T1bQjfZSqaJuPP5dV6kRvUoG
	gEgIu+xW1MHUsnMNEi9SQQMxjkLDDBY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F4nu0SdS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 07F956012B;
	Fri, 13 Mar 2026 09:46:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0702AC19421;
	Fri, 13 Mar 2026 09:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773395178;
	bh=eT7S5UGDFQybEveqjDWuZ6ct7J1Kr6WUThqpPDxzJnw=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=F4nu0SdSgFBEzn6o6+oNrlQuLG135cNvyhQYIDgRsQUK+F7DrNz1Zcqd8jYSkU8DU
	 6vcL8dKo5ivufAP+wN24W/BtE5lfRnQ+2h4p7tg82jFaUcBvqTKaWvMwrPzyvLnhKH
	 SzQ0ZZaF79lv4go65JrioUojE5ON6/+66a7vW77C88/a0dOC0S10tKls2pO6G5NZtv
	 YP4fOMVHRmmYNbtDx7bH2owseWaURPy8ErZcC8K9x53u7oFccKeGmz2Lkzu3IcPLZg
	 6zEGLvF4mjK0KZ3BeaqJkqBRqDa9KkuGeYzaQNLk55JFWdKqjOiqSuGxytxppQyD3q
	 4wrUhvkoyBSUg==
Message-ID: <94d89d84-c009-470e-a401-1ac75228cd92@kernel.org>
Date: Fri, 13 Mar 2026 10:46:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [PATCH 1/3] slab: decouple pointer to barn from kmem_cache_node
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Ming Lei <ming.lei@redhat.com>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
 <20260311-b4-slab-memoryless-barns-v1-1-70ab850be4ce@kernel.org>
 <abPYaocgFylosUCf@hyeyoo>
In-Reply-To: <abPYaocgFylosUCf@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B547518000B
X-Stat-Signature: swdo8hrmdr4mqcyjasnnupcxqxmgjwr9
X-Rspam-User: 
X-HE-Tag: 1773395179-165705
X-HE-Meta: U2FsdGVkX19/OiTaLbba2/PWDD3M0yFJE95tofppS3IM4LL1Lrwax/KKqDD59g539/o+ErfoHpLZ3i3gkj5plFuurdW3TGlq3VTQNj61zaSslYhiF9FGb3UStu+tJenKciHfCBGRyswa0t2YBj2tKy1kQ4N/TtXudSEFWWLgpZUIeT2c/MWRWFvZANPouTrcrURGq0rr75OSK+24WQfVEf7jWzwIqZDuXq/byJ7NYSY6LThC3RRFDQWjoDO4qwsIrxS5L8Z1raXGICKFp17cVsB0LqPXxN6tXPYoNlVC3OquFcQ0N3ry1ML5DiMulDNa8aatY1EIODyVrIYKe+l2Kvg5NBAiwN0Evha0RUy+zfRNjD/IM2RV40S+jKgWn3fjZ63NpSwRzx71zxWk9vfUxEOFQIXpkw3y/+wrFXSAWeb1qung2W/pMH5KRsyPKguodz5EJILCGjtaj83RRD8WEn3914PEVKri5v5Z4Jov/0lAu77yj1SM5DcRzfZAcXUcVw0qtKL4hz3KTjEwBPwLzRNnw1WsP6ARKSK7TDyLdtiTUnYupDzPOHd56XjhdinVJxRot6rcK9U/FLphfsd3XJXPjlSIYBloKO2c1fumf1PbkVVOyr4YOixHBBijI3xraxfqOMopiLZo6Q4gFuDuBIM1Iz2vVRWNT57uUAXtCP+rt406gULtz3V6gfc4QxG9824ptzhsFmNhMKjFlS3OBm4t1s8ZJIm8BSlYTP3wDV9xei5s4WBQ0Sfxmp1oNPkSrA+cO2HMDxC01L6qn81Il1//YcaSX2ZRNx0T2pRK8AGp/FMr5MtIjg9zcpOhsAAyIlvDKNPFrCD56S26hmArttVmr/uyQXxKFcmdNMtGva3WTymIyrerW5vNlZirqIKU/PkZbP9PZuzcXqdXIKCzbfUmXrtoH5LNqd4CmBgeVSDcYA2LyWt+9rWPluwinATt2zbfWeuM91gmkt5Vikr
 LDVpI7ni
 isfhpaJ1FdIH8FlPQIoO2qdZ0ZcyW9yRI/tXbPr33+34SXzc80knHbXi7SRCTVCPyg4zFs1uAZoFwky8P69DKABbZ5vPwo0TGEItAVD5GUia1a8w+oDfU9XSmC8lspt/cH5J5WYERPLkLVo3i5kEQHft6kjkBMlhBcI16z/TKdlDKprumSLdvhucWl7/QyAQKGjp6wNZ7Svx9URy1wCFI6+NPUAtQKThKUfAa4r/8YgOuBxMphJ4guTzVfcGB3YLLcGoI74K1otGdv2UjJCzi50MCtIBGnmjD9QcWXDvNqEKxcbbfW2Je6WHTtMwDGoYLN6u8ez+KprB2naI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/13/26 10:27, Harry Yoo wrote:
> On Wed, Mar 11, 2026 at 09:25:55AM +0100, Vlastimil Babka (SUSE) wrote:
>> The pointer to barn currently exists in struct kmem_cache_node. That
>> struct is instantiated for every NUMA node with memory, but we want to
>> have a barn for every online node (including memoryless).
>> 
>> Thus decouple the two structures. In struct kmem_cache we have an array
>> for kmem_cache_node pointers that appears to be sized MAX_NUMNODES but
>> the actual size calculation in kmem_cache_init() uses nr_node_ids.
>> Therefore we can't just add another array of barn pointers. Instead
>> change the array to newly introduced struct kmem_cache_per_node_ptrs
>> holding both kmem_cache_node and barn pointer.
>> 
>> Adjust barn accessor and allocation/initialization code accordingly. For
>> now no functional change intended, barns are created 1:1 together with
>> kmem_cache_nodes.
>> 
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
>>  mm/slab.h |   7 +++-
>>  mm/slub.c | 128 +++++++++++++++++++++++++++++++++++---------------------------
>>  2 files changed, 78 insertions(+), 57 deletions(-)
>> 
>> diff --git a/mm/slab.h b/mm/slab.h
>> index e9ab292acd22..c735e6b4dddb 100644
>> --- a/mm/slab.h
>> +++ b/mm/slab.h
>> @@ -247,7 +252,7 @@ struct kmem_cache {
>>  	struct kmem_cache_stats __percpu *cpu_stats;
>>  #endif
>>  
>> -	struct kmem_cache_node *node[MAX_NUMNODES];
>> +	struct kmem_cache_per_node_ptrs per_node[MAX_NUMNODES];
>>  };
> 
> We should probably turn this into a true flexible array at some point,
> but that's out of scope for this patchset.

Right.

>> diff --git a/mm/slub.c b/mm/slub.c
>> index 20cb4f3b636d..609a183f8533 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -436,26 +436,24 @@ struct kmem_cache_node {
>>  /*
>> - * Get the barn of the current cpu's closest memory node. It may not exist on
>> - * systems with memoryless nodes but without CONFIG_HAVE_MEMORYLESS_NODES
>> + * Get the barn of the current cpu's memory node. It may be a memoryless node.
>>   */
>>  static inline struct node_barn *get_barn(struct kmem_cache *s)
>>  {
>> -	struct kmem_cache_node *n = get_node(s, numa_mem_id());
>> -
>> -	if (!n)
>> -		return NULL;
>> -
>> -	return n->barn;
>> +	return get_barn_node(s, numa_node_id());
>>  }
> 
> Previously, memoryless nodes on architectures w/ CONFIG_HAVE_MEMORYLESS_NODES
> shared the barn of the nearest NUMA node with memory.
> 
> But now memoryless nodes will have their own barns (after patch 2)
> regardless of CONFIG_HAVE_MEMORYLESS_NODES, and that's intentional, right?

Yeah it improves their caching capacity, but good point, will mention it in
the changelog.

> Otherwise LGTM!
> 



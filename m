Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BD98103E168
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 12:12:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 622A86B0198; Wed, 18 Mar 2026 08:12:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D37E6B019A; Wed, 18 Mar 2026 08:12:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E8ED6B019B; Wed, 18 Mar 2026 08:12:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4116E6B0198
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:12:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 07EB41406AB
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:12:08 +0000 (UTC)
X-FDA: 84559070736.12.D3F8A8C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2709C40012
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:12:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kVTfzGBL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773835926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ngWHmMiI/B2TpdxBcQ3CpDvIjvhvkyGbI2cI1LZxnoU=;
	b=xzN62v5olH84Az7KJpQsvxcFi1Peqs+oxJrrZO4Jn+F2yhbfp9SdE67oX+mnee6SZxKvhI
	PHUCNs9rilBJYgktaK45+hgDbebd7JaqSv6Z4Xtqfi5vHpPKy/jQYE4BH8hkrq1+pMxZB5
	brIYtxa2vPlodDmankopiIKDJzGZ49s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773835926; a=rsa-sha256;
	cv=none;
	b=3+emznIm1XUuxG02xk2qe2W+oeHefm1E0u2WcVA83Pra9SpiWdSh4QDp/e8g+808qqSQjJ
	rxv12c2mt0uAZop4CyB+THL2cGQlEoyKyG8M7BUAgWx+fbXLFzZiG3azBtGKtYNfW9vQba
	I4YyxW5w5lgRcRjfI16uMu1JzQDGhO8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kVTfzGBL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8499441758;
	Wed, 18 Mar 2026 12:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E764EC19421;
	Wed, 18 Mar 2026 12:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773835922;
	bh=ZMYbeHXn5zcZyLE7ospsCFai3TF1Q88zpyazKVHp95c=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=kVTfzGBLiLfFZZLfDcB7uMhQXM6phIcJMoOUvNZkUbV0grhPwH3kOkp+KJvXGGl6O
	 wt04L80HUJ1EjG7ELX8/nMRIiZv/Eg41E0I95mIwx1eHr/QMbBlcVKhU6mKIn2ly4o
	 xOn0UVITpVe9bURrSCD0vJQ5OTZpwNME943JPU149h4z9G//vQkhgvFNdFdHRSHn0t
	 noO5kPzor/Thi26xccF3eDjlhtT4PdVT9HcTtpDaijjWgSc4VQ+qP20UqFjpV0Ati7
	 sz+pD3v93INrBTR1RgE71vkb9nsdqeVnuI1rWDvQ5vke/gOQsNJ0hSOH/xhFhgXL28
	 OYkSV3BT5XRUA==
Message-ID: <4659c675-6949-4295-b385-1ab26921a975@kernel.org>
Date: Wed, 18 Mar 2026 13:11:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [PATCH 2/3] slab: create barns for online memoryless nodes
To: Hao Li <hao.li@linux.dev>
Cc: Ming Lei <ming.lei@redhat.com>, Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
 <20260311-b4-slab-memoryless-barns-v1-2-70ab850be4ce@kernel.org>
 <4xvvslwdcqafc2yfthpgv7panejdgmbdoueqiqkaeikohjutgx@3imnb6zlk6ew>
Content-Language: en-US
In-Reply-To: <4xvvslwdcqafc2yfthpgv7panejdgmbdoueqiqkaeikohjutgx@3imnb6zlk6ew>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2709C40012
X-Stat-Signature: ctdhrkn4t4qsrmq5dw6f6k1t6quck9fs
X-Rspam-User: 
X-HE-Tag: 1773835925-379598
X-HE-Meta: U2FsdGVkX1/PPUDJIPgAbX6GBhJqHEfme3Dd0vL6piSShwqiri6vb3vZvbxO+kMO5XpyYiNLXx63EcTidnUTbK1D5ItWW7jaIxXpm9D59nSrsMvi5cWSUOmPfx9f1yQLCd5JGG+uNtwsUBzqy0wamuqkkdZvbCoKz2V2+gxy68fanie4P8/0ame0Kg+WqO5f1eyg3hmPqHQ5rOY+RPXlNUNm2FdNUlnqSpF1rACRVgT24B2xBcP2ZrxFO5/7gL2byHbW4CXCyPPWgkwAqgVt5SLjmX/jn4WCM4wow5GZ9IHtuBaWvhU8PCE8szfhfs+TbhkMNuYvDilsuqXjwi3zQEvjLfpoLuoDIMChyI34Ob1KvHNKX5R/iHy/ueyIoCxxZc1Eg7h6ArQduOhncPDxv5oLAeGMLN5wuL6pt3LqSiSE20kIynHuu4PdaAu9iM8c0u2ANv+5ZrRwP3a/WEh/9bl9r96enrfPwxNAtjoaQv2J3YWjxgKdOvRz3J4wCJwne5O+D59Y1mGSQLLYiQpZxpOWfgKr8wG6wmhMmEqYybcb1LKdRsL4icCcTM3WVR+FArLJax6YLBdFp5NjGJB5AT1a2GVzNEu50ms3N+CybGbsltWo1OJncSN4sI5gGMYWpv2Jk5M9J/ZMHsVe1ncuKtL6LT8w0eRLHp0tw8CKIAPOx+uDpiG0nYlvZXoOODP6D35VjFBcKYmIcqi8Uc300XsMU1LvoYBnU6lvtPSAI+xwuwcnlvK79EqLHmAyUlPcxiCG0kODKuVBp3VaHuCYpvTcUXQaP2+YChl1yTiKnmCm3Hu2HpzqtpM/MkrYtnhFQ/728wpT+fCzBmaNAggGKhwwAOvwomdNbgZgwaK2YfbXu4ZxNwoOtQpM/VWJYPZANaanv8e34k7Ws8t3mb9cep2Em2cD6nBjXUz6+BHWgWLO1npMIwXYfZalYIOgWff0gJsUxbD208o71CdQkLl
 O4j6smTK
 Gjnh9ipLmW0kfnIx51gqbOzE6yBvLnHOUAmNLoVf4v7mW5b7TiYbGstB+fZubAJEK5vODJLl1VgcGTPX/ix1L81CvttZm8erqGFWZPgA7MvUxEnEsMbeB0yA/392cCMxMmw0LCTdatkMLJ7YLQ3rQp7BqUrPY9eEc/cQhzNpd1IegRq2LKPp95ZJWsRExPoO+XOXnnOvp0sQnxRrPTHCWEfwNTusq/tP2B081bSr4QDIT4cAdhuxV6xpLiC7lVdmaAWIjoKDTbNWzkDtcRnj78wjoZy7mfNHbPq7/HnQgInTwkfs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 10:27, Hao Li wrote:
> On Wed, Mar 11, 2026 at 09:25:56AM +0100, Vlastimil Babka (SUSE) wrote:
>> Ming Lei has reported [1] a performance regression due to replacing cpu
>> (partial) slabs with sheaves. With slub stats enabled, a large amount of
>> slowpath allocations were observed. The affected system has 8 online
>> NUMA nodes but only 2 have memory.
>> 
>> For sheaves to work effectively on given cpu, its NUMA node has to have
>> struct node_barn allocated. Those are currently only allocated on nodes
>> with memory (N_MEMORY) where kmem_cache_node also exist as the goal is
>> to cache only node-local objects. But in order to have good performance
>> on a memoryless node, we need its barn to exist and use sheaves to cache
>> non-local objects (as no local objects can exist anyway).
>> 
>> Therefore change the implementation to allocate barns on all online
>> nodes, tracked in a new nodemask slab_barn_nodes. Also add a cpu hotplug
>> callback as that's when a memoryless node can become online.
>> 
>> Change rcu_sheaf->node assignment to numa_node_id() so it's returned to
>> the barn of the local cpu's (potentially memoryless) node, and not to
>> the nearest node with memory anymore.
>> 
>> Reported-by: Ming Lei <ming.lei@redhat.com>
>> Link: https://lore.kernel.org/all/aZ0SbIqaIkwoW2mB@fedora/ [1]
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
>>  mm/slub.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
>>  1 file changed, 59 insertions(+), 4 deletions(-)
>> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 609a183f8533..d8496b37e364 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
> [...]
>>  
>>  	/*
>> @@ -7597,7 +7648,7 @@ static int init_kmem_cache_nodes(struct kmem_cache *s)
>>  	if (slab_state == DOWN || !cache_has_sheaves(s))
>>  		return 1;
>>  
>> -	for_each_node_mask(node, slab_nodes) {
>> +	for_each_node_mask(node, slab_barn_nodes) {
>>  		struct node_barn *barn;
>>  
>>  		barn = kmalloc_node(sizeof(*barn), GFP_KERNEL, node);
>> @@ -8250,6 +8301,7 @@ static int slab_mem_going_online_callback(int nid)
>>  	 * and barn initialized for the new node.
>>  	 */
>>  	node_set(nid, slab_nodes);
>> +	node_set(nid, slab_barn_nodes);
> 
> I had a somewhat related question here.
> 
> During memory hotplug, we call node_set() on slab_nodes when memory is brought
> online, but we do not seem to call node_clear() when memory is taken offline. I
> was wondering what the reasoning behind this is.

Probably nobody took the task the implement the necessary teardown.

> That also made me wonder about a related case. If I am understanding this
> correctly, even if all memory of a node has been offlined, slab_nodes would
> still make it appear that the node has memory, even though in reality it no
> longer does. If so, then in patch 3, the condition
> "if (unlikely(!node_isset(numa_node, slab_nodes)))" in can_free_to_pcs() seems
> would cause the object free path to skip sheaves.

Maybe the condition should be looking at N_MEMORY then?

Also ideally we should be using N_NORMAL_MEMORY everywhere for slab_nodes.
Oh we actually did, but give that up in commit 1bf47d4195e45.

Note in practice full memory offline of a node can only be achieved if it
was all ZONE_MOVABLE and thus no slab allocations ever happened on it. But
if it has only movable memory, it's practically memoryless for slab
purposes. Maybe the condition should be looking at N_NORMAL_MEMORY then.
That would cover the case when it became offline and also the case when it's
online but with only movable memory?

I don't know if with CONFIG_HAVE_MEMORYLESS_NODES it's possible that
numa_mem_id() (the closest node with memory) would be ZONE_MOVABLE only.
Maybe let's hope not, and not adjust that part?



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63E6DEB7EB8
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 10:15:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A71D06B0088; Wed,  4 Mar 2026 05:14:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3F816B0089; Wed,  4 Mar 2026 05:14:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 956076B008A; Wed,  4 Mar 2026 05:14:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 880AD6B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 05:14:59 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2CDFF8BDEB
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:14:59 +0000 (UTC)
X-FDA: 84507972318.16.252A0E9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id B8F7C8000D
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:14:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rE4OXscT;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772619296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i9s0RTt9vhjt8pLOOU3JRWp/gv3SJInrBta79vszhUQ=;
	b=hgqycdNJVWPwqdvxFhSxDsSRb5WkGUKvnUNtSTbNqyOJbOq6CRzAXmKyJ+0RDvlC+++wIz
	Sek79mNvjuRlY4ARRnXczGWDbbbxyasc2Wo2ZfkzrGqUxQ9BJU7ora6qofv0tzmeU/07mA
	OkH5mwfpfdpmAJHHVgKmDD8WlfJUA8A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rE4OXscT;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772619296; a=rsa-sha256;
	cv=none;
	b=L53QXLffG+tVY/AxqeRJaOFo4s/bbsycuZ5lqZe52eAjIKq7KAmCVXgZh4qUl9JQu2s8GR
	3qKBl2AhgbC4cC8XThRevcT/3qvsRcEOfKwvqC675jX30IpX3AVCxflRuL4eH/rK53tPYp
	8iRbrjOngwNsASQOxA/GBJffkRAySBc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A07860097;
	Wed,  4 Mar 2026 10:14:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7A9C2BC87;
	Wed,  4 Mar 2026 10:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772619295;
	bh=f4x5Ge09xSX0WhI/oZyLC3lQIV7bEAJU87hp3mFCPQg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rE4OXscTNYbnNi9ELKgfREMotQQC5NyjiHov9DdYxz9cL5iaukV3wWASBt9cgSMs3
	 Vqx+iDkBkCXOzl5qy40hA+67NsRTUfhCwCQXI5gQR/yrraafpTXk8S+N4smFxYgSt8
	 Io8ogr9IviUP3tH6+O3yRPl3SWg5wROicFKM3Ewk3szNnOQD7kmy6ICtIm0GYhpeFU
	 4hYLhLyeuj3AJ9ZVET36shyQ8cxVH3JosWhrKqHPz3VZTh2SCiULE8d7rnpxCiFSBl
	 T288fqD8VmBlgd8l/v9mxAAj2q0fCDRZTxBQou1j1BSygg71gntwcQdX7UvT3cNJUn
	 ZwE7+aN5dgXeA==
Message-ID: <3952b84e-9342-4628-9778-92ae155e9727@kernel.org>
Date: Wed, 4 Mar 2026 11:14:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next-fixes] mm/slab: allow sheaf refill if
 blocking is not allowed
To: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
References: <20260302095536.34062-2-vbabka@kernel.org>
 <3at546the4zbun7g7aoeqrirh46iwsw3vj5ncc4fjhz26gfbb2@tsgplt5o2ybu>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <3at546the4zbun7g7aoeqrirh46iwsw3vj5ncc4fjhz26gfbb2@tsgplt5o2ybu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B8F7C8000D
X-Stat-Signature: 3oeboym45a3j6kciq8a39wt7an8jcxth
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772619296-580728
X-HE-Meta: U2FsdGVkX1/PW2KIrZ140duzvEWFiTiPjrkCTFIaASggLfTKHIYiqsO3cQp5uKkCz8jN629xul/uI+w/2YesgzuGNbVDD0oc8kUbr+kH5KlnVEM43JOTKputEmxAJUKxl5Cm0vInHj7y9URGtdlV43GoHFdRicHHf5CAbqXov5D4VQt+BYctTkOP3LjTbpIzBYjlWNz5OmM9ieMJ67vp+1EQ3k4omlFEmWigDN/kQgVn445vz5yAC6WavpT/bPIqr6gDdPDKX/lH1gZ4pfdsTGcBkF2IQCG2mo0PoPXMGRoSjt3tjw8UympPYUYntB/zMapiufqygkXaUSxOIe7wNmqvqGg76s7gy3120Dp0k4GKe8BrUaUuKvV5i9b5e189nKWXmZkqBZMUR46FBBXMahL10kMZJr9vU3IAqWKmM5xBeh9T4gPaNv5mWavPnR9GZmMHRGW00zTz0fZzK3UAc/gzWFs+3O4/MEU6DY3uijNC2GVBeL+RAQb/C7vdUtUrm/CYZvH89X0IXQDbx+JgUzlZlCSP69lBgVyhuoDdNaHgNN1NsjLNK76iUOc4kztIfXSbYrWEHbPKlXXl2n2yqpdnw2lw6RcvGXEu9oP7CcwJn/OpeVXHiwDVfHyZFaiyX/Et4LlzXdCfLSfih9r1qK917N0Ed2IXcldCwAaS3E1yUNgPMhsqRWsPKvc9YkBiefsPl5EQi6QqOFsRZUV5fKw/7dWkF8luqYU1F0QSW7VksgB8SrkOcJ4+lOPD35pFCSDtqe9Lom3da/L1OPT3lxV2Nz8q1wZ5rzyGK5PKN0I7xgbcebyP/uk5CKcvF0uVj05B4/Bdi1yna7Q2rvSLWEvh97OO8i/8yEQR8o7eowwIhSLRUdrkPDfTd5VX3eEQbe50veBUWCDfN8NA9D8WjUVi7roGFGSAjeI/9IR/g26pExUMiFcbZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/4/26 8:44 AM, Hao Li wrote:
> On Mon, Mar 02, 2026 at 10:55:37AM +0100, Vlastimil Babka (SUSE) wrote:
>> @@ -4632,11 +4631,8 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>>  	if (!full)
>>  		return NULL;
>>  
>> -	/*
>> -	 * we can reach here only when gfpflags_allow_blocking
>> -	 * so this must not be an irq
>> -	 */
>> -	local_lock(&s->cpu_sheaves->lock);
>> +	if (!local_trylock(&s->cpu_sheaves->lock))
>> +		goto barn_put;
> 
> A quick question to make sure I understand this correctly.
> 
> My understanding is that after this patch, there is now a new case where
> allocations with __GFP_KSWAPD_RECLAIM set (e.g GFP_ATOMIC) can also reach this
> lock-reacquire path.
> 
> If we were to keep using local_lock here:
> 
> 1. On non-RT kernels it seems fine, since alloc_from_pcs() already does a
>    local_trylock(&s->cpu_sheaves->lock) check.
> 
> 2. But on PREEMPT_RT, local_lock could potentially schedule away, which may add
>    latency. So the idea of using local_trylock here is to fail fast and return
>    without incurring that latency - is that the intent behind this change?

Great question, thanks!

So the main intent is that lockdep would complain if it saw this
local_lock() happening in e.g. an irq handler. It doesn't know that it's
safe from deadlocks because we already succeeded a trylock before and
thus the irq handler didn't interrupt anyone holding the lock.

Trying to teach lockdep such things leads to the complicated initial
design of kmalloc_nolock() before it could be simplified by sheaves.

On !RT it makes no difference as the trylock will succeed always. On RT
it may not, but indeed they may prefer avoiding the latency as you say.


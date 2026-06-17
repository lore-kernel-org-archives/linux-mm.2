Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 772F6CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 08:57:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43C476B008A; Wed, 17 Jun 2026 04:57:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5B26B008C; Wed, 17 Jun 2026 04:57:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DC1E6B0092; Wed, 17 Jun 2026 04:57:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 088FE6B008A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 04:57:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 834181C3CDB
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:57:50 +0000 (UTC)
X-FDA: 84888801900.30.947EE2D
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7F968C0004
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:57:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G6zDIISx;
	spf=pass (imf22.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781686668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LJv33QYNn3uul9I11VO5bijTdE4dZbcs1/oX8cvoHKE=;
	b=GZKq7HsLHbDoGUSl1P/bF/4PuevStGZVUzRAx0y1F3Zk5NZFawwNJObfESr6wnxF4UNjab
	lBPESfrqLlKEFhcitFZxGkxxrqCuCqKjMzQnexLTXYWyhXCylfi+zHtrdCMbodr1+OTcBP
	OTsD61uvmyZwAE4V4fA84cJu6WW2eG0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781686668;
	b=ztCsKyyjgIYNs1eeKY0EbWMy2VQ5McKp2jdkJ3QXk7/7VsV5RnV0lRbSATfw/FmJ2Xyjsp
	uZnpBIpZt2IY56lxtroDDW1exsz1+r7W6zRBbfGToFcvkq94wu1xtqAtec2OH1UGfXsOKY
	X7FTn4xP2LYcszGixB3hRrnfNDFs2IA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G6zDIISx;
	spf=pass (imf22.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <def64c45-bbe0-426a-bba1-9ac9e4db672d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781686666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LJv33QYNn3uul9I11VO5bijTdE4dZbcs1/oX8cvoHKE=;
	b=G6zDIISxunkBVC1of9TkL8OfBK4o7OBby5JNOZDMEgIOCcKY7o0KinIEcyGmZSIhVa+bC0
	AFCmsquCrexm2aEivFGneGwasore4AZAdRNchMCQtYo3oBwmSIq1swY7HIO7L3+BfdPt5B
	yR43tg3gf/O3Sh6pe2dHrhWaYepnBik=
Date: Wed, 17 Jun 2026 16:56:56 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 3/3] mm/percpu: Avoid IO/FS reclaim in backing
 allocations
To: Dennis Zhou <dennis@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Vlastimil Babka <vbabka@kernel.org>,
 Michal Hocko <mhocko@suse.com>, muchun.song@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260612022648.13008-1-kaitao.cheng@linux.dev>
 <20260612022648.13008-4-kaitao.cheng@linux.dev>
 <ajJETfcD2XzzpR8w@palisades.local>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <ajJETfcD2XzzpR8w@palisades.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7F968C0004
X-Stat-Signature: 78ddyyx4kyyxrsfowezua66bixubp3th
X-HE-Tag: 1781686668-860810
X-HE-Meta: U2FsdGVkX18ZVk0fFfFvUu6fGyDVopSN0U1b1uI1GJ0kZg9L3WRCVKPtz+gnMwkW7E1WydgDy+8wOkJlyq3dHiGYavkkM0N6nROeTv/3iCINsPjO6xKIOvKKoxQW5VMTmQC551p1EtpRrIzTQh/zomiYNajVEp5zu/JeHcNPlxO+RnXt4zpOlAPdeRu2snKkhWbeLlSf2Cl6nyotvVc7rsOKMjpODw62/NSqZb32a0dC0FHFkL49I8mO6JpADBGhD1utmiMR53opi8tDoM9ErbZaFgArfgRzTjGqhG9jWJnjM69IP7336/gt5cWveOolhxetE2hC8WWXJiaWfK4i6bVQ6aGPaftatI2Nj6k1K+1PezKyOSJhz94wJ3D+JH3PSq/2U5xvsFZRdvdQE3bz6Ct7vjqiupzS8zltpqZ5eJM5ZlyyS4/kLQgfEYG5JcrUFerIRrMHzNjsBffs4iSpsbolgv60BV41+eBl8sy+aa6vRU2mKXZRfoROSv6KDfJqWDLRe/oeqm6HBNPBlzXbOJfXFoFDc9QS+I6JuXQ+AkVSt5yOleU/kC9g9UfcDdJmGDsDabqOFlZoTEDQMdG/ZbBucVUOFg4YvtGvdaf55dnWPI8B/xO5PfaQJaYF1apcWXL1o+kparEgV3xjGG5AasR9BU/Q9DRYWE1OjgpyszSxgrt6wSuz/sswP8KLlWcFG+6MVlTC7MbK/AgD5RCzINvwx1ZOy2D2R0/iisSeAn7WkkVPZPlv01Y7quXMCgrwmuQu59Zcz5HsGJ06RdC7Oz9sudfh5WgRskAJMVXmHqLMTz83+DRQRLGWZ9etdeQ8+ZCYhASKOHTWV0NBSUCbYGDIok0u0Xq/bw+kasHTRjvQPaYP3NQrSJ1apcUMRE8kJdUivElF3jZloRoFoUo728oHcxSBRdH9WY9y3D83hYs39wXWh4OlUrWJNqvE0vh7raJXYixsrgcawf06Tys
 1MAUoInY
 CLYL19am0q6f6RcrZOdcm0PqF+T3ZVvkWrXaNhKJExAjtYKnIcptGWOCPi5SngOoo3WEN0NBAiFvoNWVViBtcUrgNDCOMYzrsDtzBd4lJgX2O5OPqaVioA52lPOlYOaHSpPozSbV5MqLc5wAglzr/IvplnFkG3jIndDxIs0U4c/JnGnX1VL5ZoLgqKYmAWK3z4pKHU627tl03N0wuqX/h693aC2UnGTMJhj0n6z7jtkfaAX9h3d4H3I7jRxOL3opVdFI8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2026/6/17 14:53, Dennis Zhou 写道:
> On Fri, Jun 12, 2026 at 10:26:48AM +0800, Kaitao Cheng wrote:
>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>
>> Commit 9a5b183941b5 ("mm, percpu: do not consider sleepable
>> allocations atomic") allows sleepable GFP_NOIO and GFP_NOFS percpu
>> allocations to take pcpu_alloc_mutex.  This avoids premature allocation
>> failures, but it also makes the mutex visible to callers from constrained
>> IO/FS contexts.
>>
>> Thread A calls pcpu_alloc_noprof() with GFP_KERNEL and takes
>> pcpu_alloc_mutex. Since the internal allocation is not constrained by
>> NOFS, it may enter FS reclaim while still holding pcpu_alloc_mutex,
>> creating a dependency like: pcpu_alloc_mutex -> fs_reclaim -> FS lock
>>
>> At the same time, Thread B may already hold an FS lock and then call
>> pcpu_alloc_noprof() with GFP_NOFS. It will try to acquire
>> pcpu_alloc_mutex and block, creating the reverse dependency:
>> FS lock -> pcpu_alloc_mutex
>>
>> This can still form a potential deadlock cycle.
>>
>> Avoid the dependency by restricting percpu backing allocations to GFP_NOIO.
>> The public allocation still uses the caller's GFP context to decide whether
>> it may block, but the internal memory allocations performed while
>> pcpu_alloc_mutex is held cannot recurse into IO or FS reclaim.
>>
>> Fixes: 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations atomic")
>> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
>> ---
>>  mm/percpu.c | 16 +++++++++++-----
>>  1 file changed, 11 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/percpu.c b/mm/percpu.c
>> index 4d89965cba16..47824061a701 100644
>> --- a/mm/percpu.c
>> +++ b/mm/percpu.c
>> @@ -1726,9 +1726,9 @@ static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off, size_t s
>>   * @gfp: allocation flags
>>   *
>>   * Allocate percpu area of @size bytes aligned at @align.  If @gfp doesn't
>> - * contain %GFP_KERNEL, the allocation is atomic. If @gfp has __GFP_NOWARN
>> - * then no warning will be triggered on invalid or failed allocation
>> - * requests.
>> + * allow blocking, the allocation is atomic. If @gfp has __GFP_NOFAIL, backing
>> + * allocation failures are retried. If @gfp has __GFP_NOWARN then no warning
>> + * will be triggered on invalid or failed allocation requests.
>>   *
>>   * RETURNS:
>>   * Percpu pointer to the allocated area on success, NULL on failure.
>> @@ -1749,8 +1749,14 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
>>  	size_t bits, bit_align;
>>  
>>  	gfp = current_gfp_context(gfp);
>> -	/* whitelisted flags that can be passed to the backing allocators */
>> -	pcpu_gfp = gfp & (GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
>> +	/*
>> +	 * Allowlisted flags that can be passed to the backing allocators.
>> +	 * Backing allocations under pcpu_alloc_mutex must not recurse into
>> +	 * IO/FS reclaim.  Otherwise a GFP_KERNEL caller holding the mutex can
>> +	 * block on reclaim while a GFP_NOIO/NOFS caller holding an IO/FS lock
>> +	 * waits for the same mutex.
>> +	 */
>> +	pcpu_gfp = gfp & (GFP_NOIO | __GFP_NORETRY | __GFP_NOWARN | __GFP_NOFAIL);
>>  	is_atomic = !gfpflags_allow_blocking(gfp);
>>  	do_warn = !(gfp & __GFP_NOWARN);
>>  
> 
> I think GFP_KERNEL -> GFP_NOIO makes sense. It breaks the cycle.
> 
> For __GFP_NOFAIL, I think my concern is that a chunk can be quite large
> and might need numerous pages. If we allow __GFP_NOFAIL, then we could
> potentially churn and stall out other allocations for quite some time
> while GFP_NOIO tries to reclaim without access to fs or io paths.

__GFP_NOFAIL is actually unnecessary here. The main reason is that,
for now, I have not found any in-kernel callers that pass __GFP_NOFAIL
to pcpu_alloc_noprof() or its wrapper functions. The reason I added
__GFP_NOFAIL was to address the issue reported by sashiko, and I
provided a detailed clarification in the link below.

https://lore.kernel.org/all/3de3a89b-92f0-4cd2-9f41-8e853eae4e78@linux.dev/

We should probably revert the current patch back to the v2 version,
and then add some comments explaining why pcpu_alloc_noprof() must
not be passed the __GFP_NOFAIL flag, as suggested by Andrew Morton.

-- 
Thanks
Kaitao Cheng



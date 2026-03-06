Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A7D3F01815
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 08:47:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47CB86B0005; Fri,  6 Mar 2026 03:47:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42A4C6B0089; Fri,  6 Mar 2026 03:47:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 336296B008A; Fri,  6 Mar 2026 03:47:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F8A96B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 03:47:34 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3F90140412
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 08:47:33 +0000 (UTC)
X-FDA: 84515009586.29.AFFE56E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 16CDF20008
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 08:47:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZD+3ATVl;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772786852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=obDw+bOmDISLxmVcFTl0G6SaqYadBXSHOXLGZDZzmK4=;
	b=MbZsg8toAugfeSpVn1TmaynWK9E03zltExeFJCqze4T99g5ekJKFfnjlfKBkqRmdjG56hN
	x8KvWVAijSCmGAPErPp5nGKwEdVSPvjvKWvy9uNWbkD4+NpZX2wnvsBLGjMak5OquSsp5v
	pHEE0PU8Mxyha7PUwASUJh3ROLEDBCk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772786852; a=rsa-sha256;
	cv=none;
	b=2xltXn0PID4SoTeNWIcjbptG2HMKPQkubtDS/J/bBxMIXe2SIFFYr/hx4EWT+eVE7ii9pX
	LpiYRrzi18YgSlln6r4HEwIXAxnnvA6KLCf2rp81tchIr5SzKTT2QnWgewqin+UgyeelvU
	bD3U2xeIyLVmuNdFTr75l/VaUP+OvhE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZD+3ATVl;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 89D5E60127;
	Fri,  6 Mar 2026 08:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76698C4CEF7;
	Fri,  6 Mar 2026 08:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772786851;
	bh=P8nU/WJbN/Jf3BgOGTYFKVnRv0oHKTBEQGlPM2nnzoU=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=ZD+3ATVl1pJ3uEdzvM15SIpkrqOOzYDO11TTEpC2BsmycrnP7BoaxN21uLxAzuUZR
	 7u4QgDMN2AODukfOS7d2POc9a9xwrj4abCw1OJOWuHVXyeuWq8mcvS0G8QqhvLI3dO
	 IP2XVOHerZGabKg7BdnItPk5PMzWPNx9cKSvPQ2H+y04TxOUj9pOKP/aBal2ZObVLz
	 Wb7cIMC7DCSUt+LCVI3O/kDWh0qtVtf8xRGrxpa7Q0aUiIrmZNTh588Z2sVlZY1kG8
	 9tEGIb4yKmF/j4ImmaFeawM4YTPgJr9YrUwR6jRDo1dfdx+nYwuPzEp6KnoeQVci0B
	 +jH7x9zOTlaBQ==
Message-ID: <d5cd4eb4-1703-41af-9c71-842ae33edbdf@kernel.org>
Date: Fri, 6 Mar 2026 09:47:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [Regression] mm:slab/sheaves: severe performance regression in
 cross-CPU slab allocation
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Ming Lei <ming.lei@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 Hao Li <hao.li@linux.dev>, Christoph Hellwig <hch@infradead.org>
References: <aZ0SbIqaIkwoW2mB@fedora>
 <5cf75a95-4bb9-48e5-af94-ef8ec02dcd4d@suse.cz>
 <724310c2-46a2-4410-8a5d-c69dcc8de35d@kernel.org> <aZ7BbosIr2FvZFAe@fedora>
 <c6a01f7e-c6eb-454b-9b9e-734526dd659d@kernel.org> <aapeVb_L5zohWRRe@hyeyoo>
In-Reply-To: <aapeVb_L5zohWRRe@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 16CDF20008
X-Stat-Signature: bxjrx31t3meoo51wp7xkco1mutyatc5o
X-HE-Tag: 1772786851-844605
X-HE-Meta: U2FsdGVkX19OG6MNAvodlF6/78Lu+LM3eOpo8DWJTB7zmOsbE14jAtlvNq8dzoEE/fXIIgzmd7YDR+pwYGmP+6zvelAHL1zaOEd61pwQQ/cB2i4QwGD2naorEmpcHnyWwK4N2fq3YWqOwYnnqU/hJJTNIis1TDBm+S6GIPdHhi3W8KbLf9kF+Xw8bjq77ldgBtm5q1teO/5ZJ1qDvUHaMPSaUwk6Npa94K6DMhdW1sYhv47KFLNLJn/lUFTO5ZuD3hFl+C9TofUuSbEJQbNjetBn7QJSxi03jOF4CLXT5Y42oYSqYOw3x/VqwSfiUAajyVRpH2c1KMHpvwMmfge+PUuZK2xpEntOTYBEgxUm4rb2Az3jkViAmnnY4OO5p4CRqk7tPucCpJ6FUmvzBX/66efcbhR212YqwRFrDWfIWbQZbDwx2epqu/no7hSWpM2kTvru37QCtQkpip3H1rYob8/tBqkoYnYik4tAhcQlLG1vkH1cnY3cK6HiCFX+mROVUTKfvlwLzOPBWhEcHQ6LUorH4XNKwsjrIyUgt/oNDfkDhT3xlTBigNi85M5YCN9oeDogy/ZbooW48/lNn6zWDqug0YftRtwYCkIN+Uq6LgRwA72m2FzemL4/4zbIJqZfXhciN44kUzT0aI39FjhRqShsMlrn2msQwKeYz9mL2VyifJngngso3QRp48q9AkVOIAHdHty03BUPAl3Lsgssl2qNqobN1DNS5QAQJdEMrxOQYdEVrhuCMSuJFBe0v/hVSEZKjXOWBj7oROAjM5DePMIBpsWYHuDBfiEIgEyl+edG9NyocrsVY6QJwu1qon0ZUb6eChAao2I+ZHW+9+pCycfwXWHCOJo5lMTlVOsCO9k+mf060vU8bSQM1XNW7Hkb4mE0BeEb0QG5DUI8veSGwUmmEV28jygyQaVS+p+/tIQYeJRgaefMZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/6/26 05:55, Harry Yoo wrote:
> On Thu, Feb 26, 2026 at 07:02:11PM +0100, Vlastimil Babka (SUSE) wrote:
>> On 2/25/26 10:31, Ming Lei wrote:
>> > Hi Vlastimil,
>> > 
>> > On Wed, Feb 25, 2026 at 09:45:03AM +0100, Vlastimil Babka (SUSE) wrote:
>> >> On 2/24/26 21:27, Vlastimil Babka wrote:
>> >> > 
>> >> > It made sense to me not to refill sheaves when we can't reclaim, but I
>> >> > didn't anticipate this interaction with mempools. We could change them
>> >> > but there might be others using a similar pattern. Maybe it would be for
>> >> > the best to just drop that heuristic from __pcs_replace_empty_main()
>> >> > (but carefully as some deadlock avoidance depends on it, we might need
>> >> > to e.g. replace it with gfpflags_allow_spinning()). I'll send a patch
>> >> > tomorrow to test this theory, unless someone beats me to it (feel free to).
>> >> Could you try this then, please? Thanks!
>> > 
>> > Thanks for working on this issue!
>> > 
>> > Unfortunately the patch doesn't make a difference on IOPS in the perf test,
>> > follows the collected perf profile on linus tree(basically 7.0-rc1 with your patch):
>> 
>> what about this patch in addition to the previous one? Thanks.
>> 
>> ----8<----
>> From d3e8118c078996d1372a9f89285179d93971fdb2 Mon Sep 17 00:00:00 2001
>> From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
>> Date: Thu, 26 Feb 2026 18:59:56 +0100
>> Subject: [PATCH] mm/slab: put barn on every online node
>> 
>> Including memoryless nodes.
>> 
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
> 
> Just taking a quick grasp...
> 
>> @@ -6121,7 +6122,8 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
>>  	if (unlikely(!slab_free_hook(s, object, slab_want_init_on_free(s), false)))
>>  		return;
>>  
>> -	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id())
>> +	if (likely(!IS_ENABLED(CONFIG_NUMA) || (slab_nid(slab) == numa_mem_id())
>> +			|| !node_isset(slab_nid(slab), slab_nodes))
> 
> I think you intended !node_isset(numa_mem_id(), slab_nodes)?
> 
> "Skip freeing to pcs if it's remote free, but memoryless nodes is
>  an exception".

Indeed, thanks! Ming, could you retry with that fixed up please?

>>  	    && likely(!slab_test_pfmemalloc(slab))) {
>>  		if (likely(free_to_pcs(s, object, true)))
>>  			return;
> 



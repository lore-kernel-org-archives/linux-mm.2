Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9791BCD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 04:35:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0373A6B0005; Wed, 20 May 2026 00:35:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2AA66B008A; Wed, 20 May 2026 00:35:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E40216B008C; Wed, 20 May 2026 00:35:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3E1A6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 00:35:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 69EF4140140
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:35:13 +0000 (UTC)
X-FDA: 84786533706.03.1BBBB5D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id A9B0C40002
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:35:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BnRzqq5O;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779251711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D+KrNjyuJa7ESBMWINTdASPtDIBlZuk36q7PQc9bb7c=;
	b=Q7am2d7lzaHCwY9LGorM7neQGV0/xG0xapzuuhJne9PJuY15oXKAmit4W2Dr78KeR8jaD6
	xjQ7Z1QmvdrTTlsPGZrx+SGOGm5TTQjKahsjcAJnLrr+NBoz50rUMHicsAph/GbAV312WX
	gO761scVK019s7RSwkGwgp9lmlUByVU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BnRzqq5O;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779251711; a=rsa-sha256;
	cv=none;
	b=Hl8ZgM/6NmphjehXj9GDWiwtdbaqG0XR2ypv/vyhXfcbUxNPx5QYTQ7fs7B/7e6JH9kOrE
	NZXGELz7tjdQImx7hE9uEc1f/rCA4d9+mHEWSkjxgWkq5IE9CuYuI8J6KJwemOS/wq3A9B
	HHe1iDIRSspEwroKiOrOr0RTz7fruDU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 18CB660120;
	Wed, 20 May 2026 04:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CD01F000E9;
	Wed, 20 May 2026 04:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779251710;
	bh=D+KrNjyuJa7ESBMWINTdASPtDIBlZuk36q7PQc9bb7c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BnRzqq5O7cuKjfAmBZU3gZkvYJpuSNdKpHuoPs6+RmYSOmnvHXgYghagiLjy0sLva
	 8a+WJFBVlia+iIBfWGYX8CJKZEeMeG+xYWM5JEwmV338KeWaSl2CEY/GOD3yjLWqBc
	 wa6P/+uthgAA875bYKlOi77vHkyME0vF1aE9zbvtKwLx6Ps/DhB2iXlawx2nmf+Lrb
	 zkq1nYAojXUeCjpoTg+7fDzvKwsbMiYGC0Yxt1T9pWN83p5niDpe4oGkEjeMNE4ii2
	 sALDIQrrT7YqueWFDDfFHqcj3jRlc2k+HqK8H20H/mzN7HmuYkGsErHOF2s0IVuXC/
	 03bmJ1qHNyGKA==
Message-ID: <682945f5-2d00-4bc8-8e23-59189b4472c6@kernel.org>
Date: Wed, 20 May 2026 13:35:07 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/8] mm/slab: enable runtime sheaves tuning
To: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <liam@infradead.org>
References: <20260516-sheaves-tuning-v1-0-221aa3e1d829@kernel.org>
 <agr8Nzr8rnDBTuVX@pedro-suse>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <agr8Nzr8rnDBTuVX@pedro-suse>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A9B0C40002
X-Rspam-User: 
X-Stat-Signature: 6zu9jb4faa7bkkx15bqrckjwo1ymfjjw
X-HE-Tag: 1779251711-982889
X-HE-Meta: U2FsdGVkX1+sbPCf9KcV21VpF500a04BS82550nxhoGvXnqvsyRr4Ijjurmuoi3XURhDVKehE2IH5yJrXiOiOsbd5abzpQnAwZ2fGYxNvSftBbOLFThI+wlsLafH4rIO0usfsOcxxyc8Dvrx4HlmtN8AjYbzbuUTcIPbuZSuCpMCvdQ/Ft6UHRMoeZM+Mk5Fc440jDXD9MqCzflPIhxw63oTLRQJpoDS1So8BWLeqxAEAm4Hl1CFUDrj+LMzhxDIo9K/X5OOLxi/7sHmoXfnBPc0ALltCSK/d8CY2Ecnj1mlehVzrRTf9i3H9FQfyAYXDjMtq3V2FRubIn4hEWyQ+qs9g5lvwLPQZgP1Jm3LaCvGwrsUltJHzLUR7mlSkDdFmcfi5CUSgX2KVJjhpFURBek/hFxpQ5X00saz3Ko8oP3CiWJwIYJKHerECblEllNV5ImpZTIjG6mluKWG99XNqrw44DqqxUp/EzQdxRkCBO5TsHr4TBxYcPPQow63ULBhnHvozwJPSyi8HLl/r0Dtc/geqzsSf1fSyPcWr0JXmRN+1i6SCC7cMrk5Ncu8cqqBBr8ZK7fBi3sUJfCKzM98QYfqyX2lzplVKede4qwOEgh0MszmHs0RND397wzDGl0l9HafvfNMBWYhUrhWf8iTJDb2qQKFjR4W08ScxNiP5Qn/PZ0XGzcDfuaGxwJYc45QhBVkeYPwzwCbDA7V3atlgarRPLxzFRPlkWb6Ubz576AKTZIAIu6KK1JM4oOL71HgXmOg6kywWtzir3Ow+kc1+coPlipHp89hymno2MGFRwF408w5Qvx/DK//VA9FcYiIhByLMYLFcD0PHUG387EcdtZcpvkOhM1OxxJnDVMWl3Mtuaiyppk67qMVMHmglhr5BOrboVYX9hyu5DQhGcMXR1kky6ytQHlOKKM7AWVu6mmfY/oyPNDwhlBjFTJlrsR62QQmxm4x/XGzz7Gi155
 OGi78tZm
 hTrlYgpUG7jAvGSjbMf1/fdMky4ffiApX5fWJDhS3jfHFBJ7hdsjlKB2dXbG9pmt6+RHH7CcFVSIy0AyKraLTqE0MiUQYRUXLJtScar3R5uzcDi7ac69xdEgyglFVWW6KOux0yy5pk1WAWBljhanSHcacIQrplRgKi/Yul3aRuzKS0DUyh+nuAZgW2iMDBQU51QVsX5ASyxiR0e4yTw6avWb3529kCa1ED1UFFDZkni4xkHAwu0YnxVrWFKSeBBU0WyQB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/18/26 8:52 PM, Pedro Falcato wrote:
> On Sat, May 16, 2026 at 01:24:24AM +0900, Harry Yoo (Oracle) wrote:
>> Background
>> ==========
>>
>> Sheaves were introduced in v6.18, and starting from v7.0, they are
>> enabled for all slab caches (except for kmem_cache{,_node}). In the
>> pre-sheaves era, there was a cpu_partial parameter to tune the number
>> of objects cached per CPU. However, sheaves don't have an equivalent
>> and the sheaf capacity is determined in the kernel code.
> 
> What semantic do you need from this?

The intent is to allow adjusting sheaf capacity to mitigate per-node 
barn / slab list contention on the slowpath (for servers with many 
CPUs), similar to the 'cpu_partial' tunable in SLUB and the 'limit' 
tunable in SLAB.

However, the semantics are slightly different from 'cpu_partial' and 
'limit', as changing sheaf_capacity also affects the number of objects 
cached in the barn.
>> Challenges
>> ==========
>>
>> 1. Allocations and frees can happen concurrently at any point between
>>     these steps, and we cannot introduce heavyweight synchronization
>>     mechanisms on the fastpath.
>>
>> 2. Currently, cache_has_sheaves() checks whether a cache has sheaves.
>>     This works now because sheaves cannot be enabled or disabled once
>>     the cache is created.
>>
>>     The question "Does this cache has sheaves?" should be split into
>>     "Does this cache support sheaves?" and "Does this CPU actually has
>>      sheaves enabled right now?".
>>
>> 3. Once the sheaf capacity update is complete, no sheaf with stale
>>     capacity must remain.
> 
> Why? I don't see a huge problem with having multiple sheaves with different
> capacities, as long as you adequately, opportunistically kill the sheaves
> if they don't have the desired size (say, once a sheaf is fully empty).

Haha, you got me.

Right, enforcing a single capacity at any given point introduced so much 
complexity that I started wondering myself about whether this is really 
essential.

My main concern was that the performance characteristics would become 
too unpredictable, but actually, users can avoid that by disabling 
sheaves, shrinking it, and re-enabling it. So that's not an enough 
justification.

When I first started, I was quite cautious and obsessed with the 
invariant because many parts of the current implementation assume "a 
kmem_cache has only a single capacity, and it doesn't change", but 
that's also addressed by this patchset. So that's not a big issue either.

I agree that it is worth trying to allow sheaves of different capacities 
and hopefully that would be less intrusive. Let's see.

Thank you, Pedro.

-- 
Cheers,
Harry / Hyeonggon



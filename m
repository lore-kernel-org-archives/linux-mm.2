Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58BF6CD98DA
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 10:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4927A6B0005; Mon, 15 Jun 2026 06:14:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4428D6B008A; Mon, 15 Jun 2026 06:14:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 331BF6B008C; Mon, 15 Jun 2026 06:14:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1E7AD6B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 06:14:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7366CA0987
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 10:14:31 +0000 (UTC)
X-FDA: 84881737542.08.EBE0889
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8B64F14000B
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 10:14:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SMyTsyB4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781518469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T2eZ9nicY2ugL7ZhQhUMhUTF6916IovA3mkaq4lvaXQ=;
	b=DRc8DFI5HVgj57AIsuRjNO9DmznzNO0UNXGWm9vOtniQVyHdZRiCPw4Nz0rSor27wahxUE
	REHWPvoqGD5gQdiGH8iU5s8iQR0Vdtm7ufoUjvf/NA0lAkZSWuE7dH7kZ0P6RR5vzn7W1Z
	QY3YQmxKBxHNQZpesNdC5IqLI7J6Twk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SMyTsyB4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781518469;
	b=jE+FGEOrlN0cdm3nQnSVFp/zFCrtg95vb8KlwTNQTeRoGXj3JWcgJf7zfI49sMtcfO03TE
	OhkwyRlx4tT2yEIOhkpCydrajT22tH9Dx3vOpx7T6A/oRUdnsrwh2lo79KMFu6n+ZGeW+X
	U91CBwBIjQtJZYqEj7vNmNO5H8vYsM4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 872ED40236;
	Mon, 15 Jun 2026 10:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECAD01F000E9;
	Mon, 15 Jun 2026 10:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781518468;
	bh=T2eZ9nicY2ugL7ZhQhUMhUTF6916IovA3mkaq4lvaXQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SMyTsyB4ltrLipBSuP0C8l+bwRDWSEU8kLkUu3IZFNMNtDlBEECikDD7LhyvijU6/
	 vhQ+DM8JhL7di73ZhtNnlP3vASRDKZuEAYGK45GD1KfRCD4M49tR9ICRlmBQ6k539+
	 3kVjBCWjy6QvLFtduPqVzFr5X9qdXVvvK+rbuI11cyr+6/OL3k2IEiv8yhCCrVmNLT
	 vhrog67BSpEEJZTdC9V+n02oPykFZ1kAyMW5AXPcwQim26LKaEmXySqsV/xv0UY7Jw
	 dv5Yxv+YBN5C108+p6CgA8yiKv0qfkTKFJXoOJ09YSJvDNT2c6+TFVe6bjjWmC9l0X
	 H8Xcd2iTnrBWQ==
Message-ID: <3f454a59-71d0-4354-87d6-85afb91a4ae2@kernel.org>
Date: Mon, 15 Jun 2026 12:14:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/16] mm/slab: pass alloc_flags to new slab allocation
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-8-7190909db118@kernel.org>
 <49ca905a-0303-4fad-8257-485b0ed47c8d@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <49ca905a-0303-4fad-8257-485b0ed47c8d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8B64F14000B
X-Rspam-User: 
X-Stat-Signature: x816baiqyw5n4xxmqoqe3385pckaadsg
X-Rspamd-Server: rspam09
X-HE-Tag: 1781518469-319039
X-HE-Meta: U2FsdGVkX1/8ACbxuJozeK+QaGt2uarm1ZxYmJgJZXQFltIvifPloBtbzICO+ZIpfUx5mwcDJipv3CqGfvW+Bgupu4dxtQivNFEPN0RO5KzVqQVfzLVEPaAst81fafQQQa0+rkNqLzugeakO0z7BVNJXyegT4DzUGN4WkD2G5WozRAFpQSXxnCSH5Jlv3WtnY4flj51wBSUJ8UbjFmIhLcIunq9/fEb2aJtKOenVGRpoFIbn5K6LFnWEB5b/eNbUkD1mXoViL5zGfkoh3hj3Mh/vAKupTg6kmnW0qnG1WUavore71MI3tftyoarSO9FvK8CmRDtfg5XnKSqV7ZtC78ocC9Vc8fggQEbJRXUgsS0RxHft1xO7KrdOx6RqwTZuv0+Pz+8Rea3ziapb7IiwAHbyZKAft9SQU9Mt5/Cq0u6nLeoXtAottIQ9QX20Z9bNd+xHCdawQIubDSCTJ2yr7w3VwPgEmxoiJGD/q+6PIfCNvqHZwwsQbe8RJjVkHdrfBFAOPA9UOGfTf3GRilmeOgP8beXK5ZMxmUvYcs9RpMuiEvbRhOu7PplaUDkAXrebeWX3+zlT28xFV4ZzaKB0WqHC/Zp0GuNp5uwDn2t7SPA5Gnmtc5U7udrFTtwbxLLq/KrSrMjyVcpf9m1IlENVLYbxQd68L+rPD0IAHtc1qvoHA+26zJx5zlURB+g+4KZVhJu1zEiNoSxWqtiiPUASGtZjuVk+sU8Xc0EhjP/4dVohE2nVdUKFjHzdRq7ytOevD3ozX1gbdeevfjbXEtNfKIcts7/M6cg+/2arGJ9A6MK/JvvdAIdD/4mD9FjzDmUaVTW3awdfAntvjWEb+7tzv3tTehyMy5kwgIdhHcCoxWTgKy3fDn4Tv+D7/tdnll5HEP+1rdE6AZCalNv+revbB2J6aVHrSoeFAmq/hAdUAPbk4sKEFNMogvXEuwbTjwv03tVroh+KjBW7PrhTtON
 sh0k2RDx
 RRwDuSp8g4dVegXS3HAhHQfUl5IovWWNpGr9t4dXkMunLmwE6kKJSt3sP0xEZutfRUBkqCvwhSC67BM02Ln7lJeij7JKE6rlXj/Ny9d9Yj27VlKNsWDEp72yUIbwnv65Sq+EWp7bIA3wAPsjHMbPLartZHT+2hWUmYJ9mBc9P+d+O1/O9UZLrTbFUzzWFnrvVx8nQyESLABrLc6f8r6qQHeYscMvOd8nXGGhSxtYXrqtvwV6nJGd/lWnx2H4LZc4RwFBiXf1/T/VBxJdLT2/I+FVRcd0/FfQu6ppW+8POXrrLrLSjJ2RxiAbqHcXqGHoEd7N2Ms10KPPce7U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/11/26 09:52, Harry Yoo wrote:
> 
> 
> On 6/11/26 12:40 AM, Vlastimil Babka (SUSE) wrote:
>> Add the alloc_flags parameter to allocate_slab() and new_slab()
>> so it can be used to determine if spinning is allowed, independently
>> from gfp flags.
>> 
>> refill_objects() passes SLAB_ALLOC_DEFAULT because it can only be
>> reached from contexts that allow spinning.
>> 
>> Also change how trynode_flags are constructed in ___slab_alloc() to
>> achieve the same "do not upgrade to GFP_NOWAIT" by using masking instead
>> of a branch. It will now also not upgrade in cases where gfp is weaker
>> than GFP_NOWAIT (i.e. lacks __GFP_KSWAPD_RECLAIM) but doesn't come from
>> kmalloc_nolock() - which is more correct anyway.
> 
> Wait, debugobjects intentionally avoids __GFP_KSWAPD_RECLAIM,
> but we have been upgrading it to GFP_NOWAIT?

Actually, we have not been upgrading it until patch 6/16, which made the
upgrade trigger by starting to rely on alloc_flags? Because previously it
would be !allow_spin due to lack of __GFP_KSWAPD_RECLAIM.

So I will move that flags adjustment to 6/16 (now 7/16).

>> During the masking keep also existing __GFP_NOMEMALLOC (pointed out by
>> Sashiko) and __GFP_ACCOUNT. Previously the hardcoded GFP_NOWAIT would
>> eliminate them, but it's not a big problem that would need a separate
>> fix.
> 
> Ack.
> 
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
>>  mm/slub.c | 28 ++++++++++++++--------------
>>  1 file changed, 14 insertions(+), 14 deletions(-)
>> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 98b79e5e7679..8f6ca3d5fdfa 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -4467,25 +4470,22 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
>>  	 * 1) try to get a partial slab from target node only by having
>>  	 *    __GFP_THISNODE in pc.flags for get_from_partial()
>>  	 * 2) if 1) failed, try to allocate a new slab from target node with
>> -	 *    GPF_NOWAIT | __GFP_THISNODE opportunistically
>> +	 *    (at most) GFP_NOWAIT | __GFP_THISNODE opportunistically
>>  	 * 3) if 2) failed, retry with original gfpflags which will allow
>>  	 *    get_from_partial() try partial lists of other nodes before
>>  	 *    potentially allocating new page from other nodes
>>  	 */
>>  	if (unlikely(node != NUMA_NO_NODE && !(gfpflags & __GFP_THISNODE)
>>  		     && try_thisnode)) {
>> -		if (unlikely(!allow_spin))
>> -			/* Do not upgrade gfp to NOWAIT from more restrictive mode */
>> -			trynode_flags = gfpflags | __GFP_THISNODE;
>> -		else
>> -			trynode_flags = GFP_NOWAIT | __GFP_THISNODE;
>> +		trynode_flags &= GFP_NOWAIT | __GFP_NOMEMALLOC | __GFP_ACCOUNT;
>> +		trynode_flags |= __GFP_NOWARN | __GFP_THISNODE;
>>  	}
> 



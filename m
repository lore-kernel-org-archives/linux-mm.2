Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2C55CCF9FE
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 13:09:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20C808E01CB; Thu, 30 Oct 2025 09:09:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BC428E007D; Thu, 30 Oct 2025 09:09:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ABAA8E01CB; Thu, 30 Oct 2025 09:09:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA01C8E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 09:09:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 82173C0146
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 13:09:52 +0000 (UTC)
X-FDA: 84054813024.13.EE09998
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id F1E7BC000F
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 13:09:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=u35zjXeH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Pge26f7a;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=u35zjXeH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Pge26f7a;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761829790; a=rsa-sha256;
	cv=none;
	b=tKcXBU/IxNe5s66QqPwZvmgtgHpE9ES7fDdbgI/X7J0y8DLC2yoITwpoNMPu3+MNzxinGs
	1El/7ChG8OPe5vujSyt6qtqQF0diHzQxusXDJtK8xjcAf88pAZ1B9u6PKTTL2oou5tEIYI
	ofje/YZOBZfP0mdGM+D4agC6eVC213c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=u35zjXeH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Pge26f7a;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=u35zjXeH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Pge26f7a;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761829790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nEBccaffx0laznQLZDcBToe4Zq9sfm7DWgMbpIyXv10=;
	b=e6GOQntEiEbvwP+7I9EkVF9Hu6ybS1jZBFRac8EGPGe5EjGAjuDnP5pHlw0NO+lXma6SFe
	EyadvPWkTyo1iberU/ndZbpnZvzFAz4W+2zivgA5S+Reo2vJIrYKwgjJFz4vye2EITyfnD
	eBYGNQt5ezGkv+a4tyuOX9GjbOSnHrs=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 16A611F6E6;
	Thu, 30 Oct 2025 13:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761829788; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nEBccaffx0laznQLZDcBToe4Zq9sfm7DWgMbpIyXv10=;
	b=u35zjXeHu2kJ9F+ybi00dh4j7fiUPK8ZhSGhvQGRVntWhm3/5R3by6+9Dxvbrh3k1ief05
	5OpFlSzUmeSaKW6YreidSTPZdrJMktG8CkvQOhKyk5UWhdT1G7ZkclN8d2KZKuGSVCHXCg
	nEeGuxcDMBzwPV6g969Mc//4FANEsEk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761829788;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nEBccaffx0laznQLZDcBToe4Zq9sfm7DWgMbpIyXv10=;
	b=Pge26f7auOvqPNAgoaI7CjnBKzT34GmrqBe0vfWo4dU6aT/6Sf/jzIfPgwa2nij+Ov+1Ky
	8py5HvLxvHvevhDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761829788; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nEBccaffx0laznQLZDcBToe4Zq9sfm7DWgMbpIyXv10=;
	b=u35zjXeHu2kJ9F+ybi00dh4j7fiUPK8ZhSGhvQGRVntWhm3/5R3by6+9Dxvbrh3k1ief05
	5OpFlSzUmeSaKW6YreidSTPZdrJMktG8CkvQOhKyk5UWhdT1G7ZkclN8d2KZKuGSVCHXCg
	nEeGuxcDMBzwPV6g969Mc//4FANEsEk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761829788;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nEBccaffx0laznQLZDcBToe4Zq9sfm7DWgMbpIyXv10=;
	b=Pge26f7auOvqPNAgoaI7CjnBKzT34GmrqBe0vfWo4dU6aT/6Sf/jzIfPgwa2nij+Ov+1Ky
	8py5HvLxvHvevhDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F0F0B13393;
	Thu, 30 Oct 2025 13:09:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PQNuOptjA2kCUQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 30 Oct 2025 13:09:47 +0000
Message-ID: <06241684-e056-40bd-88cc-0eb2d9d062bd@suse.cz>
Date: Thu, 30 Oct 2025 14:09:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 10/19] slab: remove cpu (partial) slabs usage from
 allocation paths
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
 <20251023-sheaves-for-all-v1-10-6ffa2c9941c0@suse.cz>
 <aQLqZjjq1SPD3Fml@hyeyoo>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aQLqZjjq1SPD3Fml@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F1E7BC000F
X-Stat-Signature: nzgu5qmf7gjay3tg9z6f3jiw7ysn8ej6
X-HE-Tag: 1761829789-572788
X-HE-Meta: U2FsdGVkX18iclIAnyaqu5jnvHWPdOuzpkkR7gSrxtsBTLwntHLsQtOXD+w5od3zC+BVqoURxfGX77QYlG/+2jUKmNkfuWCVOrpbPf+OStGO938oqzpL0V/t6gOJJmyYUjD6Iyd0ZNns1/CUln2dk78YhXfDc93vMg50mqB6cteLa6Wa6M8B75eyghxCbrDHDX9r5CkeDTLk/Uh6rGQUVU8uDJisW0hupYq3fFh+Po1LGlHLHE3zyY0e8zxHl76kBcEKs7u5NcSpyXMvn+copWR/5FP/biG3Rj63DPhA5iwm/SKzKssMSx3anqnY1bQZBZgcA0/pw00XoE6slInCtq+H//sxnqy2Z23+idPGfsDnTuNjLyKuM+Abv3Iew3HkkxZ5htwkASPU2sTqGJJYrakSk8AuX+ahUqa0TT22qggVZdzhvUvYGIGGKuVAL/5XxY1xXFFq3ntnfRodE4CVGYNPBxKpeaL7gWXKf7qAHvSTI5W28C9kAUQhnV+doHGy85VF15g6n7SUod2+S/i6V6YVH3AY0XVyXygtTNSvsTIA4f7GqsP1QV/NbA9SjV2jjEQ34OZgYrNixZH7KCW3mKg+BDvmWEtvjn8IiNK7W9ZxQB2mxYxp59iOzA0PoR3m+PS17WjFAzs0vpgYTbCUgnv31CrPJxWzJaCD9znvYQzl6+xTpiWtw+rQtFApGPXd/l6ZB946MbD5BG8ucPAEipLdGKxM8QTmfiLrs5u4vkLO5oMsNNoTWvS2lzvBx9kd8R30AQ7dj+q5ynoO5anK9prvzFiebNIHpkcI4V0uSUnIRdGqeWjVdpRHTm6GZ+3hzTkSGzSRSaBU/7b+hEHRzlwjI75cJnO6dI4GNqmzs66fMz7D5USihienUCuCRo+YDPr12W7xl5j3yN6jRFgxL2hinTNPENnS3jIzzB8SQ/7pFa8Y6e0mHmtJLt2UYlk5OkPEnlFS954bd41QCCF
 b7wcuQ2z
 U5cjuTD3UiNl0kEnpqirXCmDzp0lubJsVzVsimnp7DEq5xOMoiLU3B5pJTs06sX8rO1LAFudyYAGHJuG/tiVy/BxbETaZMmxfCC2LuMdPVgu7JK0xjN9nvzURFB5azj1t4di6e8suxHN0eSXyubUxflYRYiB5qsxlqFcQKPWP5kIu1BlG+MCGnPS1gEVSHBD76LfDh4dFFKt1nT8m8X+Qvy8pjHkcI495k5+drG6FIb1UBWOAj5tYBrQpCWAXzT0vQT9gThVrj31eixoC8u7mD2n5OJ25Q7V6rAFj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/30/25 05:32, Harry Yoo wrote:
> On Thu, Oct 23, 2025 at 03:52:32PM +0200, Vlastimil Babka wrote:
>> diff --git a/mm/slub.c b/mm/slub.c
>> index e2b052657d11..bd67336e7c1f 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -4790,66 +4509,15 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
>>  
>>  	stat(s, ALLOC_SLAB);
>>  
>> -	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
>> -		freelist = alloc_single_from_new_slab(s, slab, orig_size, gfpflags);
>> -
>> -		if (unlikely(!freelist))
>> -			goto new_objects;
>> -
>> -		if (s->flags & SLAB_STORE_USER)
>> -			set_track(s, freelist, TRACK_ALLOC, addr,
>> -				  gfpflags & ~(__GFP_DIRECT_RECLAIM));
>> -
>> -		return freelist;
>> -	}
>> -
>> -	/*
>> -	 * No other reference to the slab yet so we can
>> -	 * muck around with it freely without cmpxchg
>> -	 */
>> -	freelist = slab->freelist;
>> -	slab->freelist = NULL;
>> -	slab->inuse = slab->objects;
>> -	slab->frozen = 1;
>> -
>> -	inc_slabs_node(s, slab_nid(slab), slab->objects);
>> +	freelist = alloc_single_from_new_slab(s, slab, orig_size, gfpflags);
>>  
>> -	if (unlikely(!pfmemalloc_match(slab, gfpflags) && allow_spin)) {
>> -		/*
>> -		 * For !pfmemalloc_match() case we don't load freelist so that
>> -		 * we don't make further mismatched allocations easier.
>> -		 */
>> -		deactivate_slab(s, slab, get_freepointer(s, freelist));
>> -		return freelist;
>> -	}
>> +	if (unlikely(!freelist))
>> +		goto new_objects;
> 
> We may end up in an endless loop in !allow_spin case?
> (e.g., kmalloc_nolock() is called in NMI context and n->list_lock is
> held in the process context on the same CPU)
> 
> Allocate a new slab, but somebody is holding n->list_lock, so trylock fails,
> free the slab, goto new_objects, and repeat.

Ugh, yeah. However, AFAICS this possibility already exists prior to this
patch, only it's limited to SLUB_TINY/kmem_cache_debug(s). But we should fix
it in 6.18 then.
How? Grab the single object and defer deactivation of the slab minus one
object? Would work except for kmem_cache_debug(s) we open again a race for
inconsistency check failure, and we have to undo the simple slab freeing fix
 and handle the accounting issue differently again.
Fail the allocation for the debug case to avoid the consistency check
issues? Would it be acceptable for kmalloc_nolock() users?



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08E5CD167FA
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 10:11:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 590196B0088; Fri,  9 Jan 2026 05:11:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53E076B0089; Fri,  9 Jan 2026 05:11:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41EE66B008A; Fri,  9 Jan 2026 05:11:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 32A0D6B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 05:11:31 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C560C1AE7A
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 10:11:30 +0000 (UTC)
X-FDA: 84312008340.30.315F8EB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4DCCB180007
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 10:11:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jYDrvCuk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pO1wG4vq;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jYDrvCuk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pO1wG4vq;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767953488; a=rsa-sha256;
	cv=none;
	b=EMdt2+/wfZuYW03lUm33ujE0MggDlEXU27yjggICRjFnF9Zrzt9A+IZgbzjknT1EFoiAcV
	yMEASuYHwwDOrf3FIhmarj659ND4rQhqIgdSzuTxz5M0ahKyTuoHvs7SzAFHWlrZqFkAEa
	nqGx1J4tnuMuXtwTpRjCE91PJdT7HoI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jYDrvCuk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pO1wG4vq;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jYDrvCuk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pO1wG4vq;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767953488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OeuS+cvfUoQlEy8DHNi+SqxMUrSUL35iDWvtyKO6N2g=;
	b=8E7ubjMoQdI+k0V1RzDtw36t7hNf5SsDqX6/H0ek/4/ZGwpwK+3ZTdPPsnBLq0qLfWfb5g
	UE+BQ1XEhAIppGSu8FYWHqrHOVWfEABus93ZVbYpkxxAMeqGos2m1adwldEplHY/2WAviR
	VA3T7oUIshou+lIFJ4XVWH71/8iAyTY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BCDCE33A6D;
	Fri,  9 Jan 2026 10:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767953486; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OeuS+cvfUoQlEy8DHNi+SqxMUrSUL35iDWvtyKO6N2g=;
	b=jYDrvCuknmTbZ4Km+702ira2OKx+LAwxW4LTam+Xo/k19G2yIZcR+AllLxC9lNHA173kjD
	aGn0yew/MfXHnNWV2kAcETbTaLtsewot5R5N4SAQBY1iTSZXIWOjONuZnyIEboM4t0WRpt
	uzy/DONnntfAve0X49ZsgnYQ2gBN+SQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767953486;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OeuS+cvfUoQlEy8DHNi+SqxMUrSUL35iDWvtyKO6N2g=;
	b=pO1wG4vq3OVgIos0y6jNT8kWxPk8vQ8meQuCU0dF5qv/XdzC4HvyI3zTQFlBRGwKRwwzpU
	Thrz//jivolVMUDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767953486; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OeuS+cvfUoQlEy8DHNi+SqxMUrSUL35iDWvtyKO6N2g=;
	b=jYDrvCuknmTbZ4Km+702ira2OKx+LAwxW4LTam+Xo/k19G2yIZcR+AllLxC9lNHA173kjD
	aGn0yew/MfXHnNWV2kAcETbTaLtsewot5R5N4SAQBY1iTSZXIWOjONuZnyIEboM4t0WRpt
	uzy/DONnntfAve0X49ZsgnYQ2gBN+SQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767953486;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OeuS+cvfUoQlEy8DHNi+SqxMUrSUL35iDWvtyKO6N2g=;
	b=pO1wG4vq3OVgIos0y6jNT8kWxPk8vQ8meQuCU0dF5qv/XdzC4HvyI3zTQFlBRGwKRwwzpU
	Thrz//jivolVMUDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9FA133EA63;
	Fri,  9 Jan 2026 10:11:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gTGnJk7UYGlzLQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 09 Jan 2026 10:11:26 +0000
Message-ID: <4fca7893-60bd-41da-844f-971934de19b6@suse.cz>
Date: Fri, 9 Jan 2026 11:11:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 14/19] slab: simplify kmalloc_nolock()
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
 <20251023-sheaves-for-all-v1-14-6ffa2c9941c0@suse.cz>
 <4ukrk3ziayvxrcfxm2izwrwt3qrmr4fcsefl4n7oodc4t2hxgt@ijk63r4f3rkr>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <4ukrk3ziayvxrcfxm2izwrwt3qrmr4fcsefl4n7oodc4t2hxgt@ijk63r4f3rkr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: z17a97botr9f6btj59iufbhhw5uciwz6
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4DCCB180007
X-Rspam-User: 
X-HE-Tag: 1767953488-854456
X-HE-Meta: U2FsdGVkX1+CkoyrmgFG+52ScCHSMKDJBgAD/0S3dQBh25QhhTtXTOlPsNhuquNBen6Ia9fmgkceBASHSHjheLW50ZT/ApHrVLCnVcM5qiD9Rys8WD4306dqcQQV0fznrNd+QOXQNj1Rl0mvTUVSF/Ifno0nC8OB3M2tF6JtnJS1E/HMc1DuTkSEzlxmYb2X4MO+WGc5uXzgR87owr6sT4d1nbZWWJ236Pq+k8uOwmUZARyNAhpkiU/EsEz9p5u6T0sa2lkVsn0pKGHIhj8KRyIwrtTuCABhDiI8PZVpEkBDdADuODdno3PeLX3lApc5PiKmun/3SoryRTkTyRsbdM3Juki3fXQDUYVWlVz/R0MswpeLlz+At/jAwi1MxqloL9AflqsSqlMw6tGKu7Q/tdQ8oXx06P/ijiXQBC9OFNimTtaFxMtufZH7PcME6QjF6VkEPTMstR+3pf/HN1JpuA536YfrPnL56+ZzlJ3vo1tUgVLEIFinmIixVt7diAWd9MSTmH0v9jnwpjw2tJXuZwTPixo+wAokLP/t5nn2mUBcLASY99aJ7VQfCD3Rv5DCpfEYp/Y8x/fj0HZ36+maczGt0d29GqxWP7BHv2rMIMoJXQOGEG9iJZg8U4bzzp6GZNs/3UNb7bMheDUaVfs1EkJoNaUlG/0Q2HY0p1iUxTX/JuQu3WD5ey2NcpAJ3rt8QMk/1C8D+pREUfJVYrMo6TlUPOQpgzPWrBlQ8imEJYaekY3Jmz04OLDeFuBhvEYGCS6DFGe9eiDbCm0+iOmYPX6TzE2Lg4mcxPn3WkYtVq7dSAFild4FkgPseZK20uxwVhzhXjA28rp7ugz3+VAJGvS+TpBWV9y3SeiUWE7jnYoSQOQ9qPrSoh80Nd+tl1zuYcZL13dKBMDHoXrf2xL5ejjSQv2ygTS1oyjksFgb+1S7VjGkVh3pxRmOrNLbCcB7hB/wXdxzbO72KWE/0hk
 7ks3EUk1
 0SiAY7rZk/sCVpMXauizUy2NnxnZkMII28QRFYlrh/F9+nCOIF5ujusQps7ixC4nfZGrDnwDIO40CLG2WTjeWFd+ZZ1Aa5SQS6wzlVx+1O0wif2+aAzinenELOXnmzWFDc/3AvvwK4sE+NhSEO/B2byWtN4WXWo6c6Mj2qmprc3jmqkDXXtJhuZylxPEJ0D6Q5nmBWmCqi5gZyNPeytazqufERxwT0YnU93eGSSu4z/Vulp66Lo2hSVikpmyqPstrli7/M9Y34JkNgl3kKsiaEuzHxhDdI9ettJ9fOVwwCEaZ5mAN65Qk2xdLzGmvJ44XlAR+Reyfsms+maI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/16/25 03:35, Hao Li wrote:
> On Thu, Oct 23, 2025 at 03:52:36PM +0200, Vlastimil Babka wrote:
>> @@ -5214,27 +5144,13 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
>>  	if (ret)
>>  		goto success;
>>  
>> -	ret = ERR_PTR(-EBUSY);
>> -
>>  	/*
>>  	 * Do not call slab_alloc_node(), since trylock mode isn't
>>  	 * compatible with slab_pre_alloc_hook/should_failslab and
>>  	 * kfence_alloc. Hence call __slab_alloc_node() (at most twice)
>>  	 * and slab_post_alloc_hook() directly.
>> -	 *
>> -	 * In !PREEMPT_RT ___slab_alloc() manipulates (freelist,tid) pair
>> -	 * in irq saved region. It assumes that the same cpu will not
>> -	 * __update_cpu_freelist_fast() into the same (freelist,tid) pair.
>> -	 * Therefore use in_nmi() to check whether particular bucket is in
>> -	 * irq protected section.
>> -	 *
>> -	 * If in_nmi() && local_lock_is_locked(s->cpu_slab) then it means that
>> -	 * this cpu was interrupted somewhere inside ___slab_alloc() after
>> -	 * it did local_lock_irqsave(&s->cpu_slab->lock, flags).
>> -	 * In this case fast path with __update_cpu_freelist_fast() is not safe.
>>  	 */
>> -	if (!in_nmi() || !local_lock_is_locked(&s->cpu_slab->lock))
>> -		ret = __slab_alloc_node(s, alloc_gfp, node, _RET_IP_, size);
>> +	ret = __slab_alloc_node(s, alloc_gfp, node, _RET_IP_, size);
>>  
>>  	if (PTR_ERR(ret) == -EBUSY) {
> 
> After Patch 10 is applied, the logic that returns `EBUSY` has been
> removed along with the `s->cpu_slab` logic. As a result, it appears that
> `__slab_alloc_node` will no longer return `EBUSY`.

True, I missed that, thanks.
Since we can still get failures due to the cpu_sheaves local lock held, I
think we could just do the single retry with a larger bucket if ret is NULL.
Whlle it may be NULL for other reasons (being genuinely out of memory and
the limited context not allowing reclaim etc), it wouldn't hurt, and it's
better than to introduce returning EBUSY into various paths.

>>  		if (can_retry) {
>> @@ -7250,10 +7166,6 @@ void __kmem_cache_release(struct kmem_cache *s)
>>  {
>>  	cache_random_seq_destroy(s);
>>  	pcs_destroy(s);
>> -#ifdef CONFIG_PREEMPT_RT
>> -	if (s->cpu_slab)
>> -		lockdep_unregister_key(&s->lock_key);
>> -#endif
>>  	free_percpu(s->cpu_slab);
>>  	free_kmem_cache_nodes(s);
>>  }
>> 
>> -- 
>> 2.51.1
>> 



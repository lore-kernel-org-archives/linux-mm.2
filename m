Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ECB7EB7EAC
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 09:59:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 994376B0088; Wed,  4 Mar 2026 04:59:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 975986B0089; Wed,  4 Mar 2026 04:59:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 877C76B008A; Wed,  4 Mar 2026 04:59:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 74F996B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:59:04 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2550C1A04D9
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:59:04 +0000 (UTC)
X-FDA: 84507932208.07.B49B515
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id BB6168000D
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:59:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="u5m9iG/n";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YMMx98SB;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K9xwdbCp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mDBXZ1Ir;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772618342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TW0tb752ym3mdQ8KAhXlAy2LYICbeb9RJEvsuJMVJXg=;
	b=ujFy+xoocf5xj2lNzapdk+gHZZKDXVKm1dvTFa2SfN5SR+uTJBknh6b6TXWB0iE7VtWzIE
	ueNe7OEsbZ9ZpNhPWyL/CdVXGeiLHXZzafF/MhOAqtezFP0WQ4t5JAIkmP4U0fMYCz4RpL
	nahLGhBHl5vM50JDQ/eKJ10PcroAZ4A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772618342; a=rsa-sha256;
	cv=none;
	b=yub8CWc8Bc/1yrp+ISWl2L20j8q9ofTjTIIoPyhuYl7bNCI/+LdofAL+jA/hbQlY4zsyfE
	yceq+T1yim2dJRKAbvgLOY5rkboagjC6K1LWvPMIzAc32NZks/DbdkdYnrklz5t3H4e5/0
	qy96pKyKpSmP6c2XI/scEMiPAObs/0c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="u5m9iG/n";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YMMx98SB;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K9xwdbCp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mDBXZ1Ir;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B0F463F8A9;
	Wed,  4 Mar 2026 09:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772618340; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TW0tb752ym3mdQ8KAhXlAy2LYICbeb9RJEvsuJMVJXg=;
	b=u5m9iG/nk2+pmRd+EhwGdJyXAxL2o9AV3NSerNoN3hWe7GdwhZx+64dTOXUOTcd6gmYJgN
	vpG1lH2E7FhAR0qIvdV+XuoVOJU07Bt6svmozjTvUCI+8o+NOXUCNXad6vOI5svlBsbo+g
	VzKPaDM0uWq4CEDU4x87uyJEJ0CuQGc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772618340;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TW0tb752ym3mdQ8KAhXlAy2LYICbeb9RJEvsuJMVJXg=;
	b=YMMx98SBYtiE72CVRLbviY0ORLil7T6MYmZ8jq+vK06fjZWLcwz4YcMxc+djU2mSSBKfg9
	8f0XpeWgWr2OF7Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772618339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TW0tb752ym3mdQ8KAhXlAy2LYICbeb9RJEvsuJMVJXg=;
	b=K9xwdbCp5okzsB/pwNOIYoe1W7usKDLo7EJvLz/VIm50WbpohyL/yKzEWeJQpRU7pkc8am
	f9C+zANE4DyoptzpAmBU4Jq1trRtZ0x9RY3yAOc6vU1JJXyTl/IbTG3bb9j/RzP428m+D5
	VXw/jVasKfLKTSQnX3ylcHx52nfD2Wg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772618339;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TW0tb752ym3mdQ8KAhXlAy2LYICbeb9RJEvsuJMVJXg=;
	b=mDBXZ1IrV2BfviAEbMO6POHM2o3iGeZPDFcpwb8p6XzUOU/wdrdoFMt/+KOD6vUchcytyH
	C0bHtyKJq7swezBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5D6633EA69;
	Wed,  4 Mar 2026 09:58:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id g2OBFmMCqGlFbAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 04 Mar 2026 09:58:59 +0000
Message-ID: <a7494308-cec6-43c7-aa17-a438747b50c3@suse.cz>
Date: Wed, 4 Mar 2026 10:58:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next-fixes] mm/slab: allow sheaf refill if
 blocking is not allowed
To: Harry Yoo <harry.yoo@oracle.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
References: <20260302095536.34062-2-vbabka@kernel.org>
 <aaehb5EwDKygrXGW@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Content-Language: en-US
In-Reply-To: <aaehb5EwDKygrXGW@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BB6168000D
X-Stat-Signature: y7hg8onsj3r7drrhcdkqgffo7au6q6hy
X-Rspam-User: 
X-HE-Tag: 1772618341-704134
X-HE-Meta: U2FsdGVkX1/QP+EbsxIqSi4xHF0PencxSciPmxrCFz1BKcS28N5NGpBSgDvet0vu+ihTwQ1K7Ot3Gu7SPJnrf+MGt1qv76KEu7cmD10mAunFEvGfdvbGwcd+Yv2UwfQAxA6Pa6+ElIUUrHPRahPbKuWAzHcUfHU0i07/DTRzzqtTC9FiHIDIp9dUouHmZyY7dibVDz1qcV0YedJ3tlEHNUUVoddWOVRpYBUpiSxMCdHmi0+9NehIIMD8WpBkitN2TFmdYiw2SVJ/hIL8fEltkQ2jDW8Fl3Sb1du93A1/NMRqssDiTx4axi/xocqKE4O76cBR+/NowLldDxVXZ8cbiKxtikMFkvCK+igFxyDrBg/RVW38IOgMLt6GmhAdsl+3yPeooTj1Mxfdn9aXpciqs3BEKqd4eI5O7DA6vlqXQuEnzss7vWFH2kmbg0ov95DjT68x9Qqs9P5eSP1QwulNahIQ0ebaccVXhCVYAJlNCms6O5QcT07+nbPkRrDkwZBiZDg5JuPy4kfIaK3o5SkwM+sU9Ci0kbUui4B4Jw6FAO5pR+Ly8XDYLuHa/B7Z14KU/mpnL/D8er36m/6Y44EfY/RFU/95JFmOo2jBqpsjG2oiKNwRfiw9xhvIoCwrlBKwY5rM8l7KSWO5fIGAip7ri/OagpNPweI+SmwASgYmvQ6aBOadNPIyL4sQBkGHIpE0ro6JhrE8t39fobiAYyUjQxISIWhpTG8oVUh0D9HSfWdZybrhoQvrSI6I7UxKdQ15MJxixdH22fGzdGhwUC31KG+mc3r5g7KSMuPtifz6w6CnngswqAQnwba3AvowGjdeH4vvccGsVzwI38tEZkMWwjLttJgdxzR51KRyy58fjWY05QyKV5/8o7ggfVgjrcldBbgvhm9Ai/DiVWP3d3poOeWvyw8OC3fTdIge6ITDvLU738kifDXpaRacx+XOdfzf89e/4Y0A9LFWvH5ZGin
 bkLEwN6k
 TmGDBqIIRZfYje3GzNhVb47HY0SNyVESX71IMMfHktx/p9CLdV+fsEd8MJe7mIN9oO4IkYtHXEdj8oNiJuIvN3go+6vYTw4PjLVkdCYpTPereZSHiwyIlBDEVRaytKetKcqKOIgUbC1fsgt2PutnyVnx3wDLuJ1+xWTI34MK5xXne5xOYB2RjuqFqClqJXSjSc/7Izlck4JJBVeQzUgWQ1+SItDtGwwemYlOprodcdaznb9YbX0cBS6clXfUuILFD4Q5Z8lZbz88kNaclJq7sA6RpmHzCcZbGHgDE6h/7d4E4CMHwEaZVFuxf2td8ceG4uIiceaYHG45Z2jw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/4/26 4:05 AM, Harry Yoo wrote:
> On Mon, Mar 02, 2026 at 10:55:37AM +0100, Vlastimil Babka (SUSE) wrote:
>> Ming Lei reported [1] a regression in the ublk null target benchmark due
>> to sheaves. The profile shows that the alloc_from_pcs() fastpath fails
>> and allocations fall back to ___slab_alloc(). It also shows the
>> allocations happen through mempool_alloc().
>>
>> The strategy of mempool_alloc() is to call the underlying allocator
>> (here slab) without __GFP_DIRECT_RECLAIM first. This does not play well
>> with __pcs_replace_empty_main() checking for gfpflags_allow_blocking()
>> to decide if it should refill an empty sheaf or fallback to the
>> slowpath, so we end up falling back.
>>
>> We could change the mempool strategy but there might be other paths
>> doing the same ting. So instead allow sheaf refill when blocking is not
>> allowed, changing the condition to gfpflags_allow_spinning(). The
>> original condition was unnecessarily restrictive.
>>
>> Note this doesn't fully resolve the regression [1] as another component
>> of that are memoryless nodes, which is to be addressed separately.
>>
>> Reported-by: Ming Lei <ming.lei@redhat.com>
>> Fixes: e47c897a2949 ("slab: add sheaves to most caches")
>> Link: https://lore.kernel.org/all/aZ0SbIqaIkwoW2mB@fedora/
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
>>  mm/slub.c | 21 +++++++++------------
>>  1 file changed, 9 insertions(+), 12 deletions(-)
>>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index b1e9f16ba435..17b200695e9b 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
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
> My AI buddy says (don't worry, I filtered it):
> | When local_trylock() fails above, the function jumps to barn_put and returns
> | pcs without holding the lock. This appears to violate the function's contract
> | documented in the comment at the beginning of __pcs_replace_empty_main():
> | 
> |     "If not successful, returns NULL and the local lock unlocked."
> | 
> | The caller in alloc_from_pcs() checks for NULL to detect failure:
> | 
> |     if (unlikely(pcs->main->size == 0)) {
> |         pcs = __pcs_replace_empty_main(s, pcs, gfp);
> |         if (unlikely(!pcs))
> |             return NULL;
> |     }
> | 
> | If the trylock fails and pcs (non-NULL) is returned, the caller proceeds
> | without realizing the lock was never re-acquired. This leads to accessing
> | pcs->main without the lock and later trying to unlock a lock that isn't held.
> 
> And the analysis sounds correct to me.
> 
> perhaps it should be:
> 
> if (!local_trylock(&s->cpu_sheaves->lock)) {
> 	pcs = NULL;
> 	goto barn_put;
> }

Thanks a lot Harry. In fact I realized this mistake after initially
sending the patch to Ming in a reply, and fixed it locally (same as you
suggest).
Or so I thought, because the fix got apparently lost.
So I'll do that now in slab/for-next-fixes

Or actually I think a more robust way is to set pcs = NULL after the
unlock, unconditionally, so I'll do that.

>>  	pcs = this_cpu_ptr(s->cpu_sheaves);
>>  
>>  	/*
>> @@ -4667,6 +4663,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>>  		return pcs;
>>  	}
>>  
>> +barn_put:
>>  	barn_put_full_sheaf(barn, full);
>>  	stat(s, BARN_PUT);
> 



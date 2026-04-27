Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFDE4FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 13:53:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C19E6B0088; Mon, 27 Apr 2026 09:53:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 998F06B008A; Mon, 27 Apr 2026 09:53:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AFAB6B008C; Mon, 27 Apr 2026 09:53:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 792706B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:53:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D6E40C07D4
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:53:15 +0000 (UTC)
X-FDA: 84704477550.15.5037E25
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2441B120005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:53:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hwi/JY4+";
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777297994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aL54TPtAXbvRbkPUpZdgk8C9I2SyPxx12T5ZhiXZUj8=;
	b=sAwLsYUT6IAo3H4zZYIigt1exdT8o4IuZjo5V9u8NJVz4W1OgHAhkvmPLNLHCndfBdFsOr
	4puW5t6sLh+fu5z9iwtsFgd09u2KS7hWqrtIq9kADFHLpfF2Knr4oBeEJgpVZ9RfYnzPwX
	Bf5nJh3A/Gr20U0wvgfz9/S+SroNOAs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hwi/JY4+";
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777297994; a=rsa-sha256;
	cv=none;
	b=d/g2L4zIeUt8WTBYIVmPCqomIomx4GpLRLFJElCbk5YEVzAzyBmMsH0rcMDL41FGT/oRLW
	4bWZSVwz+YCH8o8v9OiHNvjUEq8Hmy8D5ayFJ24I3biiotp6HXBxee4LWv0Qxxv82do3gJ
	a67h9k64VzphhGTHQXTCBVgRXDduXsM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 907286014B;
	Mon, 27 Apr 2026 13:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FE2C19425;
	Mon, 27 Apr 2026 13:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777297993;
	bh=ddHWZll+/l4Y6yaG2N+pebqPLgYmW4+I+mmivss745w=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=hwi/JY4+SVHsumZdfuyjG7FZ7O8Eo+BNs44kEekYy41QrAVPXqAnDJRUG910W3o4O
	 K2rPCo25lUdTtRJkcVHi2fKwBuOAR8hCcBCiqC+wgcSKXC6dkP/EtEEwdHsQBz4abc
	 AATXAkKXtKhKtOcc6cPwhjTHxrRf+4Xf3pCd0m8tJnTRrxJ+tgXUCGyfyGK3b7foUw
	 rwbh0BuBbQFePyJYlLBQKCZJtJLbJ2g/ZF6Lk6LayixQIaA0CrORNNggdxVnj4zWH9
	 h/FPbIbRPCK+w5bFjMstGP5PIL+NPCzUDwYupDuym3f5EjbjLHXwe0O0O27PdmWx9R
	 Jg8ujmmuTPgTg==
Message-ID: <7101d55e-ba43-4df9-a345-2af579f8e940@kernel.org>
Date: Mon, 27 Apr 2026 15:53:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/8] mm/slab: make kfree_rcu_nolock() work with sheaves
Content-Language: en-US
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
To: "Harry Yoo (Oracle)" <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
 "Paul E . McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Zqiang <qiang.zhang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, rcu@vger.kernel.org,
 linux-mm@kvack.org
References: <20260416091022.36823-1-harry@kernel.org>
 <20260416091022.36823-6-harry@kernel.org>
 <56381493-214b-406d-9121-f80be7658445@kernel.org>
In-Reply-To: <56381493-214b-406d-9121-f80be7658445@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c5pmqz9jarnjkorr56tngpaekqtcr7j4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2441B120005
X-Rspam-User: 
X-HE-Tag: 1777297994-543114
X-HE-Meta: U2FsdGVkX18DeLcE8tvvHzu2gXBRUmzLsEgq9W4KowYXKT1iDICpNdJmtsCywkzxCV/45C0XQ6maBwGUKm6o+L2xBxjR2GnLIIAjHKod0NP0N/sE9+uiaq5gZNF1puxozzf3dpRCCO5AYJIhUF7Dh6Ej2F96lVuGyAADbNoX5TaSXCd12tE57w5Oo2vGaI0LFF78bRsHAEIZpm0PbFTEnfP/BkQga8/nlOVKrxEPuzNeJXCElkbvToLdcz6ogSLvbw7WjZN26i2/FVzKk8XNOJfBp+paIZsLyKYcBmRJptfmqeF0TFK7sF1FaYO3gaHlZu4uGDwdAhvnJx6Z2ScP1yAVfHqLh3rScvionh1VKS0u/lymP/8Gr4N3n5ISj+p9w8Fs447LWMvhFnNFCMnedLH7hhaSi7zqJaj8E74PRFBLk9OUQ0El8RIqo+WopZtvHGYDu0eu71BREz7JC0Tir/bGy9ShM2J6nN4uc8U2CDpJm+GL3o3AQMPVGp5C2WIBxIbnMWVOha1LMxawBqMJgJbvTRY5Oie7Q9rjkpzuqujc+8V2liLFaX655JAv6Qa/DH8hWmFUNe2K/ViyCFfjb1O86pPKW0Ls7DUTu+FNEhKS5V0QDc9FGHngDJrgBBs5Gr2l0D8/2oMBxa4IWB0txbgvxolsdd6bd/z3/G1Po0HZ2q3dSd1ZFtpfjUfz2GL0KrqIOcNpZ3hBlYrCsRtRC0zXYF9yuD6NwtNNE9XJDu4pscMaMuIigNTTd4iF0S0j1QP3vdl+HIAI65RJzrC5/b317dimPXehskzHkfyts6epjfkxGjVePvu7VmLa5ZgnVnBG/6famUC6OHNemRXNn7ccdeJynoK19SAm5PTJSklsDjkShz/wDzCoM4MLv3QivHfMM2d4/2HdXtCZr/GoBgWDCy5Jw9AocUyFyPkuah9lfKveJwE3FpGRrZ5NclQFaCTwCHwqlhy5SyG6sMj
 2NFhSMon
 dtNg1OXgpInki/WlY5Ckj0oSjHkC+6M7wXaKakOiKslKJDYwPUhgv8v9JWBgcDLJvU5N6SLaL9PkFECQ90uY6D0X/f0vFCyaugar1MXNcGO469swDk/mYAXr1/iW/E7WcGQoV7OZVe/4BoNRfbQSAO9bvLIyl4Suj65g8JxA8z2QF1XRJvHg5/LOAZQZTihn47H4n32QCKsnAuQN3FiQ5mI/314lnqSc5CgqcXoy6tHIdwTdaDh8dyXAJv2/jc+hT7ZJzW2GFSXmj2KIXyYhFBaDpzCPfgppLxG37ftC85CM2Swc+v25dOQNT5xQYXyDe6HDSLn6h/bUkuPs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/27/26 15:32, Vlastimil Babka (SUSE) wrote:
> On 4/16/26 11:10, Harry Yoo (Oracle) wrote:
>> @@ -2111,8 +2111,7 @@ void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr, bool allow_spin)
>>  				IS_ENABLED(CONFIG_DEBUG_KMEMLEAK)))
>>  		goto defer_free;
>>  
>> -	if (!IS_ENABLED(CONFIG_PREEMPT_RT) &&
>> -			(allow_spin && kfree_rcu_sheaf(ptr)))
>> +	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr, allow_spin))
>>  		return;
> 
> I wonder if this patch is enough to drop (or reduce a lot) the PREEMPT_RT
> incompatibility? It IIRC came from Ulad's review point [1] that since RT
> spinlock is in fact a mutex, it's not unsafe to take it with e.g. disabled
> preemption, and it's also why kfree_rcu_cpu uses a raw_spin_lock_t, etc.
> 
> But with kfree_rcu_sheaf now having allow_spin parameter and only doing a
> trylock at most with that false, it should now be safe to allow it for
> CONFIG_PREEMPT_RT, only pass allow_spin = false unconditionally there?

Oh I forgot about...

> [1] https://lore.kernel.org/all/aL_uhPtztx7Ef0T2@pc636/
> 
>>  
>>  	// Queue the object but don't yet schedule the batch.
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 6f658ec00751..d0db8d070570 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -5895,7 +5895,7 @@ static void rcu_free_sheaf(struct rcu_head *head)
>>   */
>>  static DEFINE_WAIT_OVERRIDE_MAP(kfree_rcu_sheaf_map, LD_WAIT_CONFIG);
>>  
>> -bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
>> +bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin)
>>  {
>>  	struct slub_percpu_sheaves *pcs;
>>  	struct slab_sheaf *rcu_sheaf;
>> @@ -5933,7 +5933,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
>>  			goto fail;
>>  		}
>>  
>> -		empty = barn_get_empty_sheaf(barn, true);
>> +		empty = barn_get_empty_sheaf(barn, allow_spin);
>>  
>>  		if (empty) {
>>  			pcs->rcu_free = empty;
>> @@ -5942,6 +5942,10 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
>>  
>>  		local_unlock(&s->cpu_sheaves->lock);
>>  
>> +		/* It's easier to fall back than trying harder with !allow_spin */
>> +		if (!allow_spin)
>> +			goto fail;
>> +
>>  		empty = alloc_empty_sheaf(s, GFP_NOWAIT);
>>  
>>  		if (!empty)
>> @@ -5973,6 +5977,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
>>  	if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
>>  		rcu_sheaf = NULL;
>>  	} else {
>> +		if (unlikely(!allow_spin)) {
>> +			/* call_rcu() cannot be called in an unknown context */
>> +			rcu_sheaf->size--;
>> +			local_unlock(&s->cpu_sheaves->lock);
>> +			goto fail;
>> +		}

... this part, so an unconditional allow_spin=false on RT would only fill
the rcu_sheaf once and then stop working.

However, can we condition this on in_nmi() or something, and pretend the
other cases of "unknown context" exist? Installing BPF hooks
allocating/freeing memory into call_rcu() internals sounds crazy, no?

>>  		pcs->rcu_free = NULL;
>>  		rcu_sheaf->node = numa_node_id();
>>  	}
> 



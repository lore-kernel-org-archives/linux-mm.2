Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F351CCF2D2
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 10:23:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A38296B016A; Mon, 19 Jan 2026 05:23:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A105F6B016C; Mon, 19 Jan 2026 05:23:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F1FA6B016D; Mon, 19 Jan 2026 05:23:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F2A46B016A
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 05:23:09 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4252416058E
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:23:09 +0000 (UTC)
X-FDA: 84348325698.04.B643412
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id EE811140003
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:23:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rzUalRp0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xdVn+Odm;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rzUalRp0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xdVn+Odm;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768818187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9LPIZza5xMgwGATkmayqvdDkw9ZyBilQW7+UyjARpNY=;
	b=jammf8X0fxjju692+gwVEe5FLKNmQL3mfAZfg1KT0dzWdLCRfJ+YcMHiWVLaFynHYNyZJv
	Zw4SvEJ5GJMKZf6RMtazFhyw6jUoXJXQHG5lpNIB01P5lRGpX21YqTn/osSQr5/YzHk48M
	eZcPEVTaAyR5dQf0rtn7yZ1D2jKU41Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rzUalRp0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xdVn+Odm;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rzUalRp0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xdVn+Odm;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768818187; a=rsa-sha256;
	cv=none;
	b=LGMS5Lv3YwcYKBzERu74s1he7VegBsH+WukB5yS3FU4XOFrLBGPsfbF0ohyowljcirdeE8
	xMZb3SyK0cbCU2HF2wj3kd9eDBEiYRZwM9rj/etwbNpwRzUP28ZpMCGQ2lM7uor1eIeVY7
	JIsVt8i+B6QVdmz2kDwKfRupwfYqyp8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3C9EC5BD46;
	Mon, 19 Jan 2026 10:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768818185; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9LPIZza5xMgwGATkmayqvdDkw9ZyBilQW7+UyjARpNY=;
	b=rzUalRp09kee5sr8ZFuI1lgJr6EK8JBi15qaXu+kUBZ4CtSuZB1OcWVhLzShsxTbGsUuxG
	GePSHXy5RmUkoNyPCKPzX11nqYzN+ve1qJJfkG3991BBnyK6lfJ96rICXYqOLjcj6TvnYm
	XWJomZhEMIeJOtCZTfEaPvQ21w6iEE4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768818185;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9LPIZza5xMgwGATkmayqvdDkw9ZyBilQW7+UyjARpNY=;
	b=xdVn+OdmAYjUzGFcMNsvGNDylenSebc///2AqjL1VA9Wrg+eWwutL1AwqD/rOkg0NTdSNR
	tNs1goZjAKpaRpAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768818185; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9LPIZza5xMgwGATkmayqvdDkw9ZyBilQW7+UyjARpNY=;
	b=rzUalRp09kee5sr8ZFuI1lgJr6EK8JBi15qaXu+kUBZ4CtSuZB1OcWVhLzShsxTbGsUuxG
	GePSHXy5RmUkoNyPCKPzX11nqYzN+ve1qJJfkG3991BBnyK6lfJ96rICXYqOLjcj6TvnYm
	XWJomZhEMIeJOtCZTfEaPvQ21w6iEE4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768818185;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9LPIZza5xMgwGATkmayqvdDkw9ZyBilQW7+UyjARpNY=;
	b=xdVn+OdmAYjUzGFcMNsvGNDylenSebc///2AqjL1VA9Wrg+eWwutL1AwqD/rOkg0NTdSNR
	tNs1goZjAKpaRpAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 07B923EA65;
	Mon, 19 Jan 2026 10:23:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jRWXAAkGbmndCgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 19 Jan 2026 10:23:05 +0000
Message-ID: <008029ff-3fd8-49cf-8aa7-71b98dc15be9@suse.cz>
Date: Mon, 19 Jan 2026 11:23:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/21] slab: make percpu sheaves compatible with
 kmalloc_nolock()/kfree_nolock()
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-7-5595cb000772@suse.cz>
 <aW2zmf4dXL5C_Iu2@hyeyoo> <e4831aab-40e6-48ec-a4b9-1967bd0d6a4c@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <e4831aab-40e6-48ec-a4b9-1967bd0d6a4c@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EE811140003
X-Stat-Signature: 4i41qnh71ewcdnxatznyxfomk484541a
X-HE-Tag: 1768818186-171233
X-HE-Meta: U2FsdGVkX1/SsWhzF+ArBZv97eBvPp+oPnhXBLsqTg8wrAtfI3YFdmTPU78sb+j3VVvYWfovKbdBxK19MLoieifPEd+TXmJdSPhgMVV7FqhEa0cyIT6zgVaH1Iq+JKzXzTb/y+idoXBnwz95uSMk1wY5Gt2iFqDsQ+NN1NnIgp7GQ9B7GAHRjkL+d8XNVYFXUZ8b5qd9pLi8TOW0A+rhOJ4/cZkCR3scyq6Epw5y48rNhb/bNFW7v+rmbI7ffirsAiFNRHN5wbeCGAAFOEtY4CwzRt7U8Tu00j4RVJlTQEMSb7jWjDFjYIpsxEEW8BXvauiwTpsIC8MvE6925Lfs3/fkb4nVXPFJlKWjVGSMYFAPhXaDSt8cjMQZkGaLieiEcdoB0PqcxYVO85Y/Ieu4p4ydeEp3X5paK/9F/QqULmzYRLjyi1EvfNk/cJ6Z+v7y64CQnowiA9P3Sz9ob5WTsmb670qojcbPz3eSwSvQjiuYgFBzzV/wa8KDD3KGCIwqL/+8rkzXBwO2IwR5Q5Ph5bKv5Q4fuZEmJStHWy9MnjwSVFzOvpXIhcccNNRbTWFZiLQSF/9/VYo1V1en+itaKf5r9g1DaLIn7jQ5LPA/3IJ8f6l4Xer0XF/JXWmXkTbcRcvAzLsZPA1VvCUzCliwfVae3hQyISy60f9aNjsxKRx3J6r4j9zwJZXH7zVBDb83IolsS1/HR8iFhjFueMZZLDS7NC0biVnVEULGqW0gRcPxGw/9miN4gsIxy86zia5qLAPJB0xv+CwEAMBYf1mBJ3KWsUNtp9TbXbDtJiFH6aPrcffjFwHGxN+JxpLFFiz6BUXKzO1K0ouQdqNbKgZAkpVimazqItg11c+TdUolMGJLy7Oyj7c3Vc6VB4I4cP2AEIP9bAiSGipv6vv/Le37ACWGiatrSt0zZEpteDVXFF+IaMwSL1m5DeLOdO89t5aRPIli9MSK9NbdRv7s0x9
 ECz6H8op
 qf2hk5KrPsifGGf8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/19/26 11:09, Vlastimil Babka wrote:
> On 1/19/26 05:31, Harry Yoo wrote:
>> On Fri, Jan 16, 2026 at 03:40:27PM +0100, Vlastimil Babka wrote:
>>> Before we enable percpu sheaves for kmalloc caches, we need to make sure
>>> kmalloc_nolock() and kfree_nolock() will continue working properly and
>>> not spin when not allowed to.
>>> 
>>> Percpu sheaves themselves use local_trylock() so they are already
>>> compatible. We just need to be careful with the barn->lock spin_lock.
>>> Pass a new allow_spin parameter where necessary to use
>>> spin_trylock_irqsave().
>>> 
>>> In kmalloc_nolock_noprof() we can now attempt alloc_from_pcs() safely,
>>> for now it will always fail until we enable sheaves for kmalloc caches
>>> next. Similarly in kfree_nolock() we can attempt free_to_pcs().
>>> 
>>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>>> ---
>> 
>> Looks good to me,
>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> 
> Thanks.
> 
>> 
>> with a nit below.
>> 
>>>  mm/slub.c | 79 ++++++++++++++++++++++++++++++++++++++++++++-------------------
>>>  1 file changed, 56 insertions(+), 23 deletions(-)
>>> 
>>> diff --git a/mm/slub.c b/mm/slub.c
>>> index 706cb6398f05..b385247c219f 100644
>>> --- a/mm/slub.c
>>> +++ b/mm/slub.c
>>> @@ -6703,7 +6735,7 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
>>>  
>>>  	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id())
>>>  	    && likely(!slab_test_pfmemalloc(slab))) {
>>> -		if (likely(free_to_pcs(s, object)))
>>> +		if (likely(free_to_pcs(s, object, true)))
>>>  			return;
>>>  	}
>>>  
>>> @@ -6964,7 +6996,8 @@ void kfree_nolock(const void *object)
>>>  	 * since kasan quarantine takes locks and not supported from NMI.
>>>  	 */
>>>  	kasan_slab_free(s, x, false, false, /* skip quarantine */true);
>>> -	do_slab_free(s, slab, x, x, 0, _RET_IP_);
>>> +	if (!free_to_pcs(s, x, false))
>>> +		do_slab_free(s, slab, x, x, 0, _RET_IP_);
>>>  }
>> 
>> nit: Maybe it's not that common but should we bypass sheaves if
>> it's from remote NUMA node just like slab_free()?
> 
> Right, will do.

However that means sheaves will help less with the defer_free() avoidance
here. It becomes more obvious after "slab: remove the do_slab_free()
fastpath". All remote object frees will be deferred. Guess we can revisit
later if we see there are too many and have no better solution...

>>>  EXPORT_SYMBOL_GPL(kfree_nolock);
>>>  
>>> @@ -7516,7 +7549,7 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
>>>  		size--;
>>>  	}
>>>  
>>> -	i = alloc_from_pcs_bulk(s, size, p);
>>> +	i = alloc_from_pcs_bulk(s, flags, size, p);
>>>  
>>>  	if (i < size) { >  		/*
>>> 
>> 
> 



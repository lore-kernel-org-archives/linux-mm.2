Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03582D277EE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 15:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54B5D6B0088; Sat, 10 Jan 2026 10:41:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CE186B0089; Sat, 10 Jan 2026 10:41:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 386976B008A; Sat, 10 Jan 2026 10:41:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 23F6B6B0088
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 10:41:20 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BC67DC04AE
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 15:41:19 +0000 (UTC)
X-FDA: 84316468278.22.3ADB60A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5C2A220002
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 15:41:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="cAZlr1/q";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wNsGH+7G;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="cAZlr1/q";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wNsGH+7G;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768059677; a=rsa-sha256;
	cv=none;
	b=iTINCYSh7a4TkTbvzLIrqBqZPkTXO2QNNL89PaXvKCzayV09kMjlA4tI75/NQL4UPoy0+x
	rs4kVZWWqPinx+pVfMFEqvKH+WJU1its0Xv8bNK8HQOYgn6XFoEMG9pKBo/ZsEdMrqbRFm
	JMZdV/OaGjkzAK/qpSASg0wSrNpdunI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="cAZlr1/q";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wNsGH+7G;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="cAZlr1/q";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wNsGH+7G;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768059677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DMaASs04EH1I7HUqtZvbF7q1RZcgi+PtUryM4O8whrk=;
	b=MzMym8ZjtdbBMjKSiGRKHxgZzvNswCZWED90pB77H+srupF98rbSlWu033BDeQNXc3URnl
	qWs5aXm8aGHP9r9IaCfbHpOZzUsTe66RMbfx4u48j9+TDfAiLT1UUZ4G0LpxI0tlvynCp5
	Hah0jOj2vkXLfKwsvUi+YGkhulD8lnk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2D3F55BCF9;
	Sat, 10 Jan 2026 15:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768059675; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DMaASs04EH1I7HUqtZvbF7q1RZcgi+PtUryM4O8whrk=;
	b=cAZlr1/q6mvAbPN7LBM8pdU8zIRaw0pLkwrT65nKFHaa5sUtuP9gkcR4wlHqaDhk7DXAmo
	EjDC7ALn5UoCRdoZympBKtXSgd2ssOcPL3SX2Ir84BQV1MyTjGP5LWJOGGnh5TFFsN1IZx
	AzRnj6kuIRBFKZODCY5hDzPluoh4oa4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768059675;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DMaASs04EH1I7HUqtZvbF7q1RZcgi+PtUryM4O8whrk=;
	b=wNsGH+7GfFgmC33WbycxXp23WRqqV4aK/Lt9vtpwZc66eG9E4DQ0MZURT/g36t8zct7tRj
	hzUH5YR8uNjbFWAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768059675; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DMaASs04EH1I7HUqtZvbF7q1RZcgi+PtUryM4O8whrk=;
	b=cAZlr1/q6mvAbPN7LBM8pdU8zIRaw0pLkwrT65nKFHaa5sUtuP9gkcR4wlHqaDhk7DXAmo
	EjDC7ALn5UoCRdoZympBKtXSgd2ssOcPL3SX2Ir84BQV1MyTjGP5LWJOGGnh5TFFsN1IZx
	AzRnj6kuIRBFKZODCY5hDzPluoh4oa4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768059675;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DMaASs04EH1I7HUqtZvbF7q1RZcgi+PtUryM4O8whrk=;
	b=wNsGH+7GfFgmC33WbycxXp23WRqqV4aK/Lt9vtpwZc66eG9E4DQ0MZURT/g36t8zct7tRj
	hzUH5YR8uNjbFWAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F3E5B3EA63;
	Sat, 10 Jan 2026 15:41:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wxerOhpzYmlFPgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Sat, 10 Jan 2026 15:41:14 +0000
Message-ID: <01cf95d7-4e38-43c6-80ef-c990f66f1e26@suse.cz>
Date: Sat, 10 Jan 2026 16:41:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 10/19] slab: remove cpu (partial) slabs usage from
 allocation paths
Content-Language: en-US
To: Chris Mason <clm@meta.com>, Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com,
 Petr Tesarik <ptesarik@suse.com>, "Paul E . McKenney" <paulmck@kernel.org>
References: <20251024142927.780367-1-clm@meta.com>
 <28e6827e-f689-45d9-b2b5-804a8aafad2e@suse.cz>
 <9a00f5c2-7c9b-44c3-a2ac-357f46f25095@meta.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <9a00f5c2-7c9b-44c3-a2ac-357f46f25095@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5C2A220002
X-Rspamd-Server: rspam06
X-Stat-Signature: 3ynngyxfystrmdx3btuag49p1wzy5jhb
X-Rspam-User: 
X-HE-Tag: 1768059677-202942
X-HE-Meta: U2FsdGVkX18Y8OKbpz0xfA2IT7MvMCbvbzo6TA2HBETiDoWNKRZF7WwuglSH5aHdTr/50yMa3OcFKeTqGrbuKXmOCdxwSM9LFZTlFde+HjX8raF0nZZInVc0YIv1ATBpvQFNROjDn5gr/pmU7ztfWksg2TeqirXWWXXpufL3r7Nr/0JR1SZqikLwlHTVYXJp4zm/wlXpq8wPUoHfabP1lCcSSYKtA1QMDETkRwbxGJxq4x1ENqtMr8X8KPgU4SsIVrX4iP0G6Wkd/FyWCmfitcP4QA/+kRWDlKULtpPJXEqpzvxKPg77jhBmBH7JFsGwf8l1zJXbfBMa39hCFn2a7iq3b14EHIRlryuSqxLIKIXH6k2wFid2Tk9HRb70PaNGePig09KvMxcM+vMWMnboFfzNKtUDAj62NddeJ50nAnX/eV8+Bj+ClBQtByToj+DzR33XPOdhsMKP1C+9tyxGPtFiOEoAtdCTBHOPqk+knroU8d93NhiP/mVWoQCTRY4yWHZWrWbW/1cfkQkBT6Cssvw0VxNOU2OsQxVLWs0SbGUzGnWMm7ymDe/SCn/B99sUhxnLImbY3kgD9DOv1f1JB48kd6Fly2UWQrr60VRieCZO9GweT4th28UxDhulp/NTHTopBKH4nuVZbUn6V0Ahst9RGNNvMIlmFjgCtdRr+pWXxmBb58KWGY2EGlkZO8zheWoHbCx8QMuGkL0PmOkn8UqKd34i5iJGiK19cdmAfK2z/3k8wBY3LogMHNUOR9KZyl4WRkq3MN+fGdonBzW9vp2P8Yxrfy+UKQCTOuLz3ao5lrGx62+eb3P1MoUNPOh9e3jApVmmrARzCRU3ePtGPvDVq1+Z4BPj3N/Y6VhkOG/hw2BSUrtj0UN+vE0xDPoYQ36yK7COFwF14SThjHytRSN2eQA8mo4mvxzKAVytrzPzCj12aHW3l7m0U1nDDu7x
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/10/26 14:20, Chris Mason wrote:
> On 1/9/26 3:16 AM, Vlastimil Babka wrote:
>> On 10/24/25 16:29, Chris Mason wrote:
>>> On Thu, 23 Oct 2025 15:52:32 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:
> 
> [ ... ]
> 
>> By the way, there was another bug in this patch, causing a severe memory
>> leak, which the AI unfortunately didn't flag. Petr reported it during
>> performance testing and it took me more than a day to find it. Oh well :)
>> 
>> Wonder if things got better since then perhaps, and your or Roman's tools
>> would find it today? :)
> 
> Yes and no.  It didn't find the leak until I changed the prompt to say:
> "there is a leak, find it".  I'll see if I can improve things...

Thanks. Hmm even if it has to be done like this, it could be a substantial
time saver vs finding the leak myself.

>> diff --git a/mm/slub.c b/mm/slub.c
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
> 
> [ ... ]
> 
>> @@ -3592,54 +3549,53 @@ static void *get_partial_node(struct kmem_cache *s,
>>  	else if (!spin_trylock_irqsave(&n->list_lock, flags))
>>  		return NULL;
>>  	list_for_each_entry_safe(slab, slab2, &n->partial, slab_list) {
>> +
>> +		struct freelist_counters old, new;
>> +
>>  		if (!pfmemalloc_match(slab, pc->flags))
>>  			continue;
>>
>>  		if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
>> -			void *object = alloc_single_from_partial(s, n, slab,
>> +			object = alloc_single_from_partial(s, n, slab,
>>  							pc->orig_size);
>> -			if (object) {
>> -				partial = slab;
>> -				pc->object = object;
>> +			if (object)
>>  				break;
>> -			}
>>  			continue;
>>  		}
>>
>> +		/*
>> +		 * get a single object from the slab. This might race against
>> +		 * __slab_free(), which however has to take the list_lock if
>> +		 * it's about to make the slab fully free.
>> +		 */
>> +		do {
>> +			old.freelist = slab->freelist;
>> +			old.counters = slab->counters;
>> +
>> +			new.freelist = get_freepointer(s, old.freelist);
>> +			new.counters = old.counters;
>> +			new.inuse++;
>> +
>> +		} while (!__slab_update_freelist(s, slab, &old, &new, "get_partial_node"));
>> +
>> +		object = old.freelist;
>> +		if (!new.freelist)
>> +			remove_partial(n, slab);
> 
> Is there a missing break statement here? The debug path above breaks out
> of the loop after successfully allocating an object, but this non-debug
> path continues iterating through the partial list. Each iteration overwrites
> the object variable, so previously allocated objects would be leaked.
> 
> The commit message says "Now we only want to return a single object" which
> matches the debug path behavior, but the non-debug path appears to allocate
> from every matching slab in the list.
> 
>> 	}
>>  	spin_unlock_irqrestore(&n->list_lock, flags);
>> -	return partial;
>> +	return object;
>>  }
> 



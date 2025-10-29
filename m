Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 666A8CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 21:31:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC0378E0108; Wed, 29 Oct 2025 17:31:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A97E08E0106; Wed, 29 Oct 2025 17:31:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986BD8E0108; Wed, 29 Oct 2025 17:31:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 870A38E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:31:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2832289032
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:31:38 +0000 (UTC)
X-FDA: 84052448676.07.15DBD73
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9930A1A000A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:31:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tDtOAFjD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zk+WWgRL;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tDtOAFjD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zk+WWgRL;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761773496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=teyx4ePeKu0+OEWBtNCRjoDpTuwA8U7pzqN5XpR9ge0=;
	b=N2N1o/4gORb3bPUehx9sYbe0uF6MfLCCaqImm9Vr3cccdkLEWpd+qerUNdyjjc4nsZPjR9
	P+taJExLXnTagTwyaxnC/HOripbj8YnGpJciDPayqsO+ZrY58o9M6xFP82LTRTJ2PUkgU2
	/VzPiPRNWhEfxtdU1b4P+TuzxZgKxVo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tDtOAFjD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zk+WWgRL;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tDtOAFjD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zk+WWgRL;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761773496; a=rsa-sha256;
	cv=none;
	b=MMw50imBJEtrYTeTSTTLqFQFkXAnoNeDSPcE1ZWaihmK5P7xu8YM/yMl2bTdl0jfjMq6U8
	fhhyLw/0jQ0OIhRj4o8XcpfQcM1vm5e5dIAYyzeIFqnL4sNwW19DO1UQkq8YGXKAPRdTgj
	zifOT4qbX0klIgfAbNHu0xUW/hkC1dY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A9F7220F8E;
	Wed, 29 Oct 2025 21:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761773493; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=teyx4ePeKu0+OEWBtNCRjoDpTuwA8U7pzqN5XpR9ge0=;
	b=tDtOAFjDTC95aJlzqGCZtBDCTtXyDJDvNe7BSyhTXjfgS9Btwhzqa7HKZ/Uqi+TMvh5o1z
	Ghzk6Zm0lhmtV19DKA+rmzV9URw18yPWMQfse+uk5ga12DB1G+JJWj5V0v57TbCvxEHjh9
	9wZ9zKp4HW5g9M5jgzirPV8W1/Dafp4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761773493;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=teyx4ePeKu0+OEWBtNCRjoDpTuwA8U7pzqN5XpR9ge0=;
	b=zk+WWgRLOBTo1LBqsH/D5dTCiY158Xtq0oGg553QeFJVMavQRDywRGi0JG2L40PRJ3XMvC
	byuLrBCPzTy2lnDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761773493; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=teyx4ePeKu0+OEWBtNCRjoDpTuwA8U7pzqN5XpR9ge0=;
	b=tDtOAFjDTC95aJlzqGCZtBDCTtXyDJDvNe7BSyhTXjfgS9Btwhzqa7HKZ/Uqi+TMvh5o1z
	Ghzk6Zm0lhmtV19DKA+rmzV9URw18yPWMQfse+uk5ga12DB1G+JJWj5V0v57TbCvxEHjh9
	9wZ9zKp4HW5g9M5jgzirPV8W1/Dafp4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761773493;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=teyx4ePeKu0+OEWBtNCRjoDpTuwA8U7pzqN5XpR9ge0=;
	b=zk+WWgRLOBTo1LBqsH/D5dTCiY158Xtq0oGg553QeFJVMavQRDywRGi0JG2L40PRJ3XMvC
	byuLrBCPzTy2lnDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 881DB1396A;
	Wed, 29 Oct 2025 21:31:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bKLiILWHAmkGTwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 29 Oct 2025 21:31:33 +0000
Message-ID: <937b6cb3-27d5-4416-8152-df12b45979be@suse.cz>
Date: Wed, 29 Oct 2025 22:31:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 10/19] slab: remove cpu (partial) slabs usage from
 allocation paths
Content-Language: en-US
To: Chris Mason <clm@meta.com>
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
References: <20251024142927.780367-1-clm@meta.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251024142927.780367-1-clm@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9930A1A000A
X-Stat-Signature: 3y8r7ps1fgd4ejbe1ohbxgmm1aw4415d
X-Rspam-User: 
X-HE-Tag: 1761773495-645298
X-HE-Meta: U2FsdGVkX18+ggjuJmuws130zXfTHbANX/frjH4NmL7NhwHwr1i/4hy2ORj7OXYaINrqiEMw8hRzSu/SZLMg3y3R3v+NetNd5+O7BGaJkvtJ7iX7lDqioKJBVlg3b1DcQ3lTMAET0jJ66KiTm4gF3tc2Pa+rDMeimzpTED+XwF1EmZmHNc3DiLITv+Ctabjf+9djXTESlhpVfuK2xUaia0hX9noPeL/Sj7vhgA8bVqaAmiaGxePMNMDmQYihyiX+hLq78MEoScBMaCc2OmGJN/wGqwr1s8vVUXq+vBz3uOGHFJwAWQWjpMuQLZiaSMmpyFfcd0mAJ/2mK6eerEwvAxNzV7L0BrTJWB6Oh8w4RxzIoCtM0O0uyzxnKKZ81LaJpHYmE4aqgZgHTPuNPF94gRd2gCuzDwpZ5qDQhDHGPJFhRkw6qvbMwp99nMCO0+1p6Pw9QtUcil2CP2g59Me5YQYPt7ABMZOz85tf1OoM7e7S31L+jhlxD0geuPK3KJ8u+Aw2n3bBiG6K0ZDuQcU07q1qDE+vTKed8nOpr0fi+mK9GxSNVmH27vOr0KZFlJxajhMOFqu2QijdJ6Dwjboy9CEywvsS/yff2B98agsAkYiH/TlzXRmimThzHTdGFmYYG2A3Wp72k/oyJXZiY1E2iw38+Pk7qitp5H4KL23yYEXV3mR0vZqITkq2//qPNallg6+L4GxDK5TS6k4jMtwQ2sW8qqPh6e0gVz93Icm+wzL8WkWa1rcpjwc44pBw2H/bdKL8Xyk3b2D174rgntcEa/stpom24+fak2gld4QIiMyWTR4Qx4Gs5PseqnCw/nDQnPSCnu0an7cbfYlaD5t+cH6Ul2+M9Y61DTJsmZrVJYo1UZxoZSkEtRy0pvGRn3r6Zd6kmZHoyFqrIAw1PQBVbcEWxagXAD2ixjLbEJsNjVpAW7Hf0gK3SItfHDc3fCkBugeBtngVxy395a8tR7f
 N02SOVmp
 S9HitCWe2VOhS1PVhRcpgxdQfTGWamz/XnGhn8tRsH63GyNjCrKX7Vz4wRCZuV7knPcxt6hauLHmuMZev7iD42c4LKLabk/mnid2/TzegCu7uLC51wm49uLPbVLwkJdo8zXlyDESms8utFue5iu9C5yTFAO3+4OcVyZ2Tp1wzP/BHLXwXlw9SFR+28lkY6kMqEWbRB4ju6iDUrksDRRD2JjjVHlBgYDP+/QLtdYt7nNQJgaPIOuMT9ugYJnmsYMdjhYf38bgnO1GGZ2NvmGiaHTkDneyGO4F3zk30
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/24/25 16:29, Chris Mason wrote:
>>  	else if (!spin_trylock_irqsave(&n->list_lock, flags))
>>  		return NULL;
>>  	list_for_each_entry_safe(slab, slab2, &n->partial, slab_list) {
>> +
>> +		unsigned long counters;
>> +		struct slab new;
>> +
>>  		if (!pfmemalloc_match(slab, pc->flags))
>>  			continue;
> 
> Can get_partial_node() return an uninitialized pointer? The variable
> 'object' is declared but never initialized. If all slabs in the partial
> list fail the pfmemalloc_match() check, the loop completes without
> setting 'object', then returns it at the end of the function.
> 
> In the previous version, the equivalent 'partial' variable was explicitly
> initialized to NULL. When all slabs were skipped, NULL was returned.

Indeed, this can happen. Thanks!
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
>> -		remove_partial(n, slab);
>> -
>> -		if (!partial) {
>> -			partial = slab;
>> -			stat(s, ALLOC_FROM_PARTIAL);
>> -
>> -			if ((slub_get_cpu_partial(s) == 0)) {
>> -				break;
>> -			}
>> -		} else {
>> -			put_cpu_partial(s, slab, 0);
>> -			stat(s, CPU_PARTIAL_NODE);
>> -
>> -			if (++partial_slabs > slub_get_cpu_partial(s) / 2) {
>> -				break;
>> -			}
>> -		}
>> +		/*
>> +		 * get a single object from the slab. This might race against
>> +		 * __slab_free(), which however has to take the list_lock if
>> +		 * it's about to make the slab fully free.
>> +		 */
>> +		do {
>> +			object = slab->freelist;
>> +			counters = slab->counters;
>> +			new.freelist = get_freepointer(s, object);
>> +			new.counters = counters;
>> +			new.inuse++;
>> +		} while (!__slab_update_freelist(s, slab,
>> +			object, counters,
>> +			new.freelist, new.counters,
>> +			"get_partial_node"));
>> +
>> +		if (!new.freelist)
>> +			remove_partial(n, slab);
>>  	}
>>  	spin_unlock_irqrestore(&n->list_lock, flags);
>> -	return partial;
>> +	return object;
>>  }
> 
> [ ... ]
> 
> 



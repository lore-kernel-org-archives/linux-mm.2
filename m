Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B054D232EE
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 08:16:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C16E6B0088; Fri,  9 Jan 2026 03:16:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 799606B0089; Fri,  9 Jan 2026 03:16:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 650456B008A; Fri,  9 Jan 2026 03:16:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 52B076B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 03:16:43 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DEA55C1AF8
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:16:42 +0000 (UTC)
X-FDA: 84311719044.11.EF0BB1C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5B675C0010
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:16:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FkPvOdy0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=VpF9TpUl;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FkPvOdy0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=VpF9TpUl;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767946600; a=rsa-sha256;
	cv=none;
	b=hoqNLNmJC8A8rrqXqv7MUEW6A740lBhqwxWtSPohEu9NuZharSjthbdm2xQYMC+wCOYB+G
	JvUiFXgG7KRtSpaz7U58YU0jU1/CYezR9smbUJxiPp6ysr2oepnv7s9koH9HZ7ixgiRWcN
	2wpGpthUDFlWlmYwGUlz1+Ku3yulwsQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FkPvOdy0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=VpF9TpUl;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FkPvOdy0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=VpF9TpUl;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767946600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G1ZOpYG1RRBOh0980GoYceIDOSrHq5NcrrJc5uKkl0U=;
	b=5D/xZ8CUqkc7UvjaH6mtKv081qy8it4jBoJHbmkSpxjhq69VtAhAKRHFvvDw83an6sgQDF
	IGNxKUfydwAgRqt/xq5zt6Bj/0p7UfIk5O6m7TPz6ik2AmhdDxaopfLeJxsRBcY7fTPCH4
	8kA6tv6ZP2UPr0oOc5ZA97tC61VrYz8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5C7B55D26F;
	Fri,  9 Jan 2026 08:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767946598; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=G1ZOpYG1RRBOh0980GoYceIDOSrHq5NcrrJc5uKkl0U=;
	b=FkPvOdy0sQddOf6QKdCSucqMynteBedhjGe6uj9PAiZ+ZmNNI0oCkifZLBtrU7HstPOTJJ
	l7YWlb/769veZh12glwpf5g9xHUMT0KzR7UmJj3Kl0icR9BRH/QXS6yfXyeMuVb8PKnf86
	++LEsCh4NhnkwqPQE3llKVxPbJJMnUs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767946598;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=G1ZOpYG1RRBOh0980GoYceIDOSrHq5NcrrJc5uKkl0U=;
	b=VpF9TpUlE4adfKB6l/UFaCwK2gdFSlC9NRGvz2X73c3sPaXQ4QRI3AarSUs0Ww5IX7FoDu
	GwM6mM4bmajdHVAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767946598; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=G1ZOpYG1RRBOh0980GoYceIDOSrHq5NcrrJc5uKkl0U=;
	b=FkPvOdy0sQddOf6QKdCSucqMynteBedhjGe6uj9PAiZ+ZmNNI0oCkifZLBtrU7HstPOTJJ
	l7YWlb/769veZh12glwpf5g9xHUMT0KzR7UmJj3Kl0icR9BRH/QXS6yfXyeMuVb8PKnf86
	++LEsCh4NhnkwqPQE3llKVxPbJJMnUs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767946598;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=G1ZOpYG1RRBOh0980GoYceIDOSrHq5NcrrJc5uKkl0U=;
	b=VpF9TpUlE4adfKB6l/UFaCwK2gdFSlC9NRGvz2X73c3sPaXQ4QRI3AarSUs0Ww5IX7FoDu
	GwM6mM4bmajdHVAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3D9E33EA63;
	Fri,  9 Jan 2026 08:16:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rTO2Dma5YGnkOwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 09 Jan 2026 08:16:38 +0000
Message-ID: <28e6827e-f689-45d9-b2b5-804a8aafad2e@suse.cz>
Date: Fri, 9 Jan 2026 09:16:37 +0100
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
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251024142927.780367-1-clm@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: d7u5un1k64stym5rbb9ty1hbeq7g643g
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5B675C0010
X-HE-Tag: 1767946600-53367
X-HE-Meta: U2FsdGVkX1+Fe1OFqt3DHuRaBr8/oIRCiohKHYo9A+4XJGlMCMNwjnlN9XwhpqOSdn34f9fKGJk3545lHIRVLZ6nKPyveT9noFq3Pbwe2PkMlE99leWw0TLu5LsFOtX+7WniBEslpFCxcUCEQsB17aeLMCcQPjVbrAmky4sdHYEdjgG4/cY136/hMHYpG3s5r3YLH7KfIE4Hd/ONvSMjfNGJgdUEaIcC2XoeuAHeu+w+wo3H5FiArNvMw1mXXJiZ6X7AXyaBkKHwSRzcG1a2jb256eGheLb0diS7xh363AH6kTKcDbc/ACf8gsrP12QCQsr++avh0uvt3khEnjUCiTTB6qjrVpAlkncQHALRxS5IcXb01drfAK2payVcVzwfTfOG1lIjyIFqQPMxUJU5C9JtAkVwYu0cL8wDPmQVm9pm1Il98/JJCYxzKm7DD8+pB8sliaMB52OW24vPfOA6B6KzSa/GpXUnfLO7DRee4mFJHGKlNR9AL65NRglsFbTbouaQuVqwjPFr8xcQiqZZ033ETvShi4yXdyCrTkcF8bdXv/Pd0vvvqTz/60NUzIqmVnovt9XQ8EOLSEBldMgCtZFgcMUGDzaswfXwYNgeMm3pbhVvDOASCsUsqo3opqp/SoOalW6VR7rrxack6SbUUQ8aBu4iV7OynSGv7pUpM7FA13WEFqOCMZn7g/9fOPJWOxFVCmvWNDsPQRpGMAe3aOPeZRayMbILEefdakTbA0b65KFhgyCrQDwsqsrTbDSe/ko7lsITNnRyOu5ZUQQzklnxdVCcG40pl38aUOQrHkQo+VjdvOsNtXTIzFf1w0qKIZzq4b9Td47r51SBWyYB3EMTvhiOprBdx5aBzl1whDdSvKpnAO3DO9RC07PYAHRNka0nLB+Yoae3L3kpEGNDbrbp3qaY16jLhNyZhr/LXnImbJncicyktwkT/CcSkggf7KZT7+xfx1z81yEqeOX
 GzVyZ8Gy
 XlLltKaWw8BymBosdPbg8M2TL/HMZZCljt8oktH9xuBNRPj4y5NCXdNOJ2H0G7QP/hxPQTrwsVGyYiDr3LeeiVIz7Ca2UBnewjYyIAspGOIuF0J/2iBmkGf6H05kIt8LYj4BEIZRWeqWQTfgUpN1mc2hnHu9h8qGFoSl5dw8GLdktLjZD56kPgGtSiWKLzZfMsZc1ueJwBCr5Ico+NoWqYM3ThHTyfALVxCmioqqbLhJT875JIBiqSIO6z7cjPn1TsEitZoEn1aiavJDjUFXm6+PpS9mUWQJPRSUM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/24/25 16:29, Chris Mason wrote:
> On Thu, 23 Oct 2025 15:52:32 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:
> 
>> We now rely on sheaves as the percpu caching layer and can refill them
>> directly from partial or newly allocated slabs. Start removing the cpu
>> (partial) slabs code, first from allocation paths.
>> 
>> This means that any allocation not satisfied from percpu sheaves will
>> end up in ___slab_alloc(), where we remove the usage of cpu (partial)
>> slabs, so it will only perform get_partial() or new_slab().
>> 
>> In get_partial_node() we used to return a slab for freezing as the cpu
>> slab and to refill the partial slab. Now we only want to return a single
>> object and leave the slab on the list (unless it became full). We can't
>> simply reuse alloc_single_from_partial() as that assumes freeing uses
>> free_to_partial_list(). Instead we need to use __slab_update_freelist()
>> to work properly against a racing __slab_free().
>> 
>> The rest of the changes is removing functions that no longer have any
>> callers.
>>
> 
> Hi Vlastimil,
> 
> We're trying out the AI patch review automation on the BPF commits and it had
> some questions about a few of these.  Since the goal is to actually test the
> automation, I'm putting them in unedited, but I did try and make sure they
> were valid before sending.
> 
> This one seems pretty unlikely but still worth fixing:
> 
>>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index e2b052657d11..bd67336e7c1f 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
> 
> [ ... ]
> 
>> @@ -3575,15 +3532,15 @@ static bool get_partial_node_bulk(struct kmem_cache *s,
>>  }
>>
>>  /*
>> - * Try to allocate a partial slab from a specific node.
>> + * Try to allocate object from a partial slab on a specific node.
>>   */
>> -static struct slab *get_partial_node(struct kmem_cache *s,
>> -				     struct kmem_cache_node *n,
>> -				     struct partial_context *pc)
>> +static void *get_partial_node(struct kmem_cache *s,
>> +			      struct kmem_cache_node *n,
>> +			      struct partial_context *pc)
>>  {
>> -	struct slab *slab, *slab2, *partial = NULL;
>> +	struct slab *slab, *slab2;
>>  	unsigned long flags;
>> -	unsigned int partial_slabs = 0;
>> +	void *object;
>>
>>  	/*
>>  	 * Racy check. If we mistakenly see no partial slabs then we
>> @@ -3599,54 +3556,54 @@ static struct slab *get_partial_node(struct kmem_cache *s,
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

By the way, there was another bug in this patch, causing a severe memory
leak, which the AI unfortunately didn't flag. Petr reported it during
performance testing and it took me more than a day to find it. Oh well :)

Wonder if things got better since then perhaps, and your or Roman's tools
would find it today? :)

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
> 



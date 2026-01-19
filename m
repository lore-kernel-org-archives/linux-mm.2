Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B6A1CCF2D9
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 10:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B54046B015E; Mon, 19 Jan 2026 05:09:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B01356B0160; Mon, 19 Jan 2026 05:09:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AB886B0161; Mon, 19 Jan 2026 05:09:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 87B756B015E
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 05:09:42 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 21C4C13B8F6
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:09:42 +0000 (UTC)
X-FDA: 84348291804.24.1472705
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id 90A15A0005
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:09:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ScKxdrxs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KnLaTSQS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ScKxdrxs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KnLaTSQS;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768817380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RR3eb3DfGsCtOFcgHqGdbhM1TC4Knm+6+G2KfNqmCNA=;
	b=roxZ7LPchwLv/XUyW9yTurog2Fqnr8fuZ2xEwCdk38mQCpsaGEpvcK2R8FSeBSvcqqcaQy
	UzTjYxJJ/7Xa9PGdqW91J73II8VD9YRZX0Eb5JsmG9cEYpOQMGxuIGPaT7lOuS9MyEI3vE
	3zVnXhT49jjkSY6Opzy5Fkgc3CVs/Q8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ScKxdrxs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KnLaTSQS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ScKxdrxs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KnLaTSQS;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768817380; a=rsa-sha256;
	cv=none;
	b=Nb1Z3bku/Ch5vgyAdQ4jtpXsxn5xcp9Bi5D2sj2Xoz+kUj2ax+aFHCTphOhhanqxDhgw0L
	IG8S8bbaz31XA7AMu6HCk6JDY9Ew7y5iaHFm9j8HGqs8Jr2+dfQMEmexWGG4fUyY6I0Ji1
	j9/Cim0er4MbUEvqp70eX9LVisDpBvc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BAD5C33717;
	Mon, 19 Jan 2026 10:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768817377; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RR3eb3DfGsCtOFcgHqGdbhM1TC4Knm+6+G2KfNqmCNA=;
	b=ScKxdrxsWr4y46QIUS/b2VT4jBKGFr22KckRo/8uICidHqDxVxTmpKSIr/zac3mfQzL4Kq
	ImLSwUX2coYXAdwl6xa+6H2wtE3ZMorJ8QbPQNPLk2qRig3F+rtrxCOPEeCE+B0WnRRa7R
	a19cWdc4l7EyAzLHcEe+NdwUGrWPrb4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768817377;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RR3eb3DfGsCtOFcgHqGdbhM1TC4Knm+6+G2KfNqmCNA=;
	b=KnLaTSQS4aGSvnPykhlO0rU279T4t1/MsPdeB7UqKBjwZe/j6dztMipwtRwkQqrFKmPG/5
	fyOnDu3PT32jy6AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768817377; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RR3eb3DfGsCtOFcgHqGdbhM1TC4Knm+6+G2KfNqmCNA=;
	b=ScKxdrxsWr4y46QIUS/b2VT4jBKGFr22KckRo/8uICidHqDxVxTmpKSIr/zac3mfQzL4Kq
	ImLSwUX2coYXAdwl6xa+6H2wtE3ZMorJ8QbPQNPLk2qRig3F+rtrxCOPEeCE+B0WnRRa7R
	a19cWdc4l7EyAzLHcEe+NdwUGrWPrb4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768817377;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RR3eb3DfGsCtOFcgHqGdbhM1TC4Knm+6+G2KfNqmCNA=;
	b=KnLaTSQS4aGSvnPykhlO0rU279T4t1/MsPdeB7UqKBjwZe/j6dztMipwtRwkQqrFKmPG/5
	fyOnDu3PT32jy6AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8A61F3EA63;
	Mon, 19 Jan 2026 10:09:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id juptIeECbmnrewAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 19 Jan 2026 10:09:37 +0000
Message-ID: <e4831aab-40e6-48ec-a4b9-1967bd0d6a4c@suse.cz>
Date: Mon, 19 Jan 2026 11:09:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/21] slab: make percpu sheaves compatible with
 kmalloc_nolock()/kfree_nolock()
Content-Language: en-US
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
 <aW2zmf4dXL5C_Iu2@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aW2zmf4dXL5C_Iu2@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: ai5dma4tbcrwktqc34i3xd9bntbag8m3
X-Rspam-User: 
X-Rspamd-Queue-Id: 90A15A0005
X-Rspamd-Server: rspam08
X-HE-Tag: 1768817379-323843
X-HE-Meta: U2FsdGVkX1+ReErx3L2ylUypiYFIWQdc4+WdsahoW8f/QRrPOA7sB0aP3nPZtKndvr/3xbtv38gxg/yfmj3x+Kg04G8ZI4yh9bOqGG0JpB7b+4VBeG6a8crbWjp6PaUQkRItIEvaoriQQLpjhYsdNkCBB12B/CJWqnH9/dcTJkZor96gnvMde8B/DGlp+tEefk8byRPsXSXvMk/S07z1ZJ3tGlHgCpRu9wOX/eolspGSiqzunqjkxcTr1T9Jb8OntuySB4aWrXZToEKpEccmR+FTIlPJkcx51lbsj/J1eKA36pkDYBvY+Tc/tNaxjCNlkRKlR9gbj/VHiBo9Sby72SXoVlEU1gfJQJNzBjxXIHRHHGqDE/fyXtx1Ja5HWpJ5urfAWvizeBt5pObMb7SuRsYuyeyn4kqddOyt/smA884jSDODvfqy3o9vRJYABpZmxX91FqAzn7Zv0dS8DW3C96CIlQEk4swYnnDmy1GWf+UO0jGvcoWFnDdm1QqJhcggMly0Azdsw+W2r2Im4PZFvJgJ1CGswikThwxzIRHPWW3ptvbFU8VjZIyDX4mQXz9J7n98PAxT5EsurOo3AOKgJC790izYvvK71Iix4j7s9yc3UvgquMy3VVym37XSTbHoTtzXce5ltLFy4GKE99eBMlJZ2YJjGZI6aFMh77BqdQaFkf0C6MNLtfJfB5stRqfFTjZv2bxW1uvwNAAlgkO32nm/ld9NbT11zLdPaSoMIe+dj/EyL//S8s4sGpIGUkYHa/bh7k2Tvo+UnW6JhMGDyjESF53pY9QTLsEp6+27w88FV5qPt3QNGYKgLyeeG8Aq435yrq1g4vOH6jeYS+d6rx5757vlZSlfuvxzDlvzZKlHBQvPV/+X9rVAhFxJDV+s/6+5hJrbdpywS3ifRyv6PJIq7q6je0q3uaCW04qWajlpvL8DkKZR5bymLriWEQFqSNSejXcLKO85vUaBCqC
 iG64AlD4
 ndsF3XEmliMJiwFZGNh8Ik8d/dLy9IhrRpIoY3/M1Yl79FyVCcCand+evk/hr0vBrACurWtJyIOS+H3EjgbIz1HyQzfVuyDc51W0YiCeByRl7mOl8Z0wOlhp42FZrIT6SEsyTGvHoU0zQ7jkVX2ZZ7z/FDSEtETHPDgZOL+6DQ8ChJDx9HWvQm6a6TmTg6Hy2tL8TzP9HzM+NiUN5lztCXo0zr+IXHZrBZKg+jYWrttglJ14DzxnGDtC/PMJC5VkiWgR8/wqMS34HyvdLAwUCYFMQtw2bI92PBzwg7I2OFE5WGJ6LgvrRiyUDYTmuUf3luwoFSQNDDul4XkFr30Xq0fIyZthZJb4LV9SElK/82rO5rJI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/19/26 05:31, Harry Yoo wrote:
> On Fri, Jan 16, 2026 at 03:40:27PM +0100, Vlastimil Babka wrote:
>> Before we enable percpu sheaves for kmalloc caches, we need to make sure
>> kmalloc_nolock() and kfree_nolock() will continue working properly and
>> not spin when not allowed to.
>> 
>> Percpu sheaves themselves use local_trylock() so they are already
>> compatible. We just need to be careful with the barn->lock spin_lock.
>> Pass a new allow_spin parameter where necessary to use
>> spin_trylock_irqsave().
>> 
>> In kmalloc_nolock_noprof() we can now attempt alloc_from_pcs() safely,
>> for now it will always fail until we enable sheaves for kmalloc caches
>> next. Similarly in kfree_nolock() we can attempt free_to_pcs().
>> 
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
> 
> Looks good to me,
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Thanks.

> 
> with a nit below.
> 
>>  mm/slub.c | 79 ++++++++++++++++++++++++++++++++++++++++++++-------------------
>>  1 file changed, 56 insertions(+), 23 deletions(-)
>> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 706cb6398f05..b385247c219f 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -6703,7 +6735,7 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
>>  
>>  	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id())
>>  	    && likely(!slab_test_pfmemalloc(slab))) {
>> -		if (likely(free_to_pcs(s, object)))
>> +		if (likely(free_to_pcs(s, object, true)))
>>  			return;
>>  	}
>>  
>> @@ -6964,7 +6996,8 @@ void kfree_nolock(const void *object)
>>  	 * since kasan quarantine takes locks and not supported from NMI.
>>  	 */
>>  	kasan_slab_free(s, x, false, false, /* skip quarantine */true);
>> -	do_slab_free(s, slab, x, x, 0, _RET_IP_);
>> +	if (!free_to_pcs(s, x, false))
>> +		do_slab_free(s, slab, x, x, 0, _RET_IP_);
>>  }
> 
> nit: Maybe it's not that common but should we bypass sheaves if
> it's from remote NUMA node just like slab_free()?

Right, will do.

>>  EXPORT_SYMBOL_GPL(kfree_nolock);
>>  
>> @@ -7516,7 +7549,7 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
>>  		size--;
>>  	}
>>  
>> -	i = alloc_from_pcs_bulk(s, size, p);
>> +	i = alloc_from_pcs_bulk(s, flags, size, p);
>>  
>>  	if (i < size) { >  		/*
>> 
> 



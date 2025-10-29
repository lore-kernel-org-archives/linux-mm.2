Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AF7FCCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 17:46:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67E5C8E00B7; Wed, 29 Oct 2025 13:46:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 655AA8E00B2; Wed, 29 Oct 2025 13:46:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5441C8E00B7; Wed, 29 Oct 2025 13:46:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 435BE8E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 13:46:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0F0871A0910
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:46:13 +0000 (UTC)
X-FDA: 84051880626.14.D3D90C2
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 816752000D
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:46:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Y0vqg8o/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TIYQS9PU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KxFlbH0u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PVXWs+Ih;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761759971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F0sZF9w7yuT5ed92au3G/YD+ry/VcKsoeWBjNEV7kJ8=;
	b=he1LIJeEYQoNkZ/ezugylsr8G1TyApu8DEncHVJxtndSPHJblbxRaqcECNvNtOHKdb5CU9
	tnB+cdFRs7qsb8tKCd7+wbxj9ezEqU2V7WUDJl/Tq/1ukNpt7qroz/QclYLR6TJGT7MKjI
	VuURZYy+OIijGkDAuEMSsVfbh4J1VtA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761759971; a=rsa-sha256;
	cv=none;
	b=Rtt3/jNf1kBKEe0B87r8FXvYasB12sCYF3BUNzYWHjjZiw/bes3LR4iFa2zTuvQg9rZuvh
	Pb3Iq4KZS9zfLUHLL+mvb7G6JqEsbHPNBXP5EKll3YFMnsIyOmtJEddYVGHUR9JVBM/O8q
	bSOncVe5Ixz2VRrgiHYqZ9AeYeJaHhw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Y0vqg8o/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TIYQS9PU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KxFlbH0u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PVXWs+Ih;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E93E85C054;
	Wed, 29 Oct 2025 17:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761759969; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=F0sZF9w7yuT5ed92au3G/YD+ry/VcKsoeWBjNEV7kJ8=;
	b=Y0vqg8o/+/JbOnAy7svA98jCfAtDVcIrVWZGFjaXE8C4I+ZvMjDT7ao6pUJwf9KavZ6Cb3
	mTeY37WqnScNB/L0wHpY9X94kxAg1diT43U2uMqUOHp6BayROLRQkQ1+kcchJUMR8DjWoh
	NZW8S7ze1m4IRguBVr2+xmC8QnEPntA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761759969;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=F0sZF9w7yuT5ed92au3G/YD+ry/VcKsoeWBjNEV7kJ8=;
	b=TIYQS9PUIs1pZ7o1xAwcHj1o6+c8sDTqcE6W5rRJKR3na5DMmv+8e3CbSDsSDrG1NVgc+0
	d/LL5SWPJt3P11Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761759968; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=F0sZF9w7yuT5ed92au3G/YD+ry/VcKsoeWBjNEV7kJ8=;
	b=KxFlbH0uPFeacv9q3oLovNmzHznYMCZOPW1+LmEWFYVDf0X0f3EYn8DM6GB06jVj1YUsBS
	Y8SzKaSOGQtXlXdUBLA/Z/1jxVcbAU+ubbwGsC1VtE9ad1GmaRQH27JL/89Sxhg/PfMT4a
	l5z1AirgWqvhEZfVINX1UDLwSSN2hGI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761759968;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=F0sZF9w7yuT5ed92au3G/YD+ry/VcKsoeWBjNEV7kJ8=;
	b=PVXWs+IhvehSNLG3C6mqLJFVOi0uWoPLEMmeFLIIr/HvNWban7eV+VWnNlMqp2VPVTz/ro
	LsRw6EJxaCP6oeAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BA1A61349D;
	Wed, 29 Oct 2025 17:46:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RUQaLeBSAmkkdwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 29 Oct 2025 17:46:08 +0000
Message-ID: <8a8271f1-a695-4eeb-9a98-3d6268ed0d45@suse.cz>
Date: Wed, 29 Oct 2025 18:46:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 07/19] slab: make percpu sheaves compatible with
 kmalloc_nolock()/kfree_nolock()
Content-Language: en-US
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Chris Mason <clm@meta.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, linux-rt-devel@lists.linux.dev,
 bpf <bpf@vger.kernel.org>, kasan-dev <kasan-dev@googlegroups.com>
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
 <20251023-sheaves-for-all-v1-7-6ffa2c9941c0@suse.cz>
 <CAADnVQLAFkYLLJbMjEyzEu=Q7aJSs19Ddb1qXqEWNnxm6=CDFg@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAADnVQLAFkYLLJbMjEyzEu=Q7aJSs19Ddb1qXqEWNnxm6=CDFg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 816752000D
X-Rspamd-Server: rspam02
X-Stat-Signature: karmnj5ff7pu96ce9nu4ueutgzoxghbd
X-HE-Tag: 1761759970-157300
X-HE-Meta: U2FsdGVkX18ZkbhBRPwbpSyL+JOxqikGv7txK9rzjLip4PvE0bYn1Kwl2vEOR0y2FFUQUgDyLegCETnvmgT/ii4l9XvOTYL24RzE3fofucmrbHFRQIqNNo1vMThAsJWPQkLZhjW8IHIAPDAvhc3bx9TcmZoLjVVIteS3wUwake+Cz9htyDVD89uDpk752aiU7EEh8iFnS6cQWlZ3ZzclCPZfp1yrD7qsRyVVQ5zdSF3xZigymbzVuITbAXeDjExwjfUbyEAiU0zV10MF7RzSyPju/WF0I40RgyoAQGTzIDvJQD2QrruoUQ420m5ez2amgUoxTCACVnaq1qgfGJX+3woGcQoFp9xJk0a3/C+gpgbyGSlvHHw+KCIGRx7+1w1ew6ynxNEOgAOHU2yUSUcVKvBOuM54/jv4Fug882pBouK2qOp9TSKKWu946gbA0c4Yx2n/5F8apmhILOSxlMes825RDny0pEDmBmLxd+4xoX8nxTJ+vpOtjSL7NYs1dVgUHVT1cUx+b+OFy0xVjFjee0EOwtHM5OtlhscFFhR3tF50nnlvEhmtsDmRKc0awSLtEtq/PfmBB/ZI73DsBWpHgmPxSgKlKJJOBqmOxKV2zbWrC0CAWN3+W70c9QQanJl0A2SSSr6r0Qm1usrJlaLRkOzXEMTImpzFSIYPhg7sR7ghzE0fISbGnKndNZWBise/5BXAQMX0DU+fwF4IbgiCrx61I8t+SpOd89DzTTgVjID5IupZeY7HR2JBUUvcYKa383bYq8CWtBCyqFGIgSv0ieyAywDG30f9R53nAItIPlo8MbTlyPBJexcEtoaQIdchp0f80hf/WvndbzSsA9KgQmsTAvycBu+CATF9g+FiZq4grp0XoNlNfBDU87AfTByamPn80s/KvhSpNqztCVO42gKoklozpApptWePnJtpIhJcwwooNPN6bSHywG+4pzfRblersMgqBsAJOOvqcJI
 LG5dawfC
 lj6s1yMTEd8JWTU2lLoRccbRY6uAgDGcPtFC9vLTVStnxFeK4Lavx4jG7AqrpVSJ2Gy7PU759DCUGR5lWDy4QWj02M2E9QWS+QfUItgG2mhEkHDgySOxDrMyNCAchqzf3vCK87VTDoqdLRbj9p/Zu//C0C1+/6GgyXSpPPpn4NvwdbfMEbR5jIdzrnaAaEN2C0SrU0FGNLYV5pdTbT7FQvNRLe27pi2gm05yM5nGwuq8mx3vDmINLIbpQ5ZJike3CLpw+jgP+j8EeW2/s3NKdXd19IlEB2HuWQJDYcAYuK2LqyiwAvA4mbzUh85liQFicfKZ54DcfmOFyscoY8l4y5w341PgWLbcPV6TnPpMjSybEiQZb4It3AiBbWPOep4t0VJLYth9JaLJqLE1k/IY6K37pEeZf/w3hTzjRLvyJhF7Uss8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/24/25 21:43, Alexei Starovoitov wrote:
> On Thu, Oct 23, 2025 at 6:53 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
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
...>> @@ -5720,6 +5735,13 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t
gfp_flags, int node)
>>                  */
>>                 return NULL;
>>
>> +       ret = alloc_from_pcs(s, alloc_gfp, node);
>> +
> 
> I would remove the empty line here.

Ack.

>> @@ -6093,6 +6117,11 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
>>                 return pcs;
>>         }
>>
>> +       if (!allow_spin) {
>> +               local_unlock(&s->cpu_sheaves->lock);
>> +               return NULL;
>> +       }
> 
> and would add a comment here to elaborate that the next
> steps like sheaf_flush_unused() and alloc_empty_sheaf()
> cannot handle !allow_spin.

Will do.
>> +
>>         if (PTR_ERR(empty) == -E2BIG) {
>>                 /* Since we got here, spare exists and is full */
>>                 struct slab_sheaf *to_flush = pcs->spare;
>> @@ -6160,7 +6189,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
>>   * The object is expected to have passed slab_free_hook() already.
>>   */
>>  static __fastpath_inline
>> -bool free_to_pcs(struct kmem_cache *s, void *object)
>> +bool free_to_pcs(struct kmem_cache *s, void *object, bool allow_spin)
>>  {
>>         struct slub_percpu_sheaves *pcs;
>>
>> @@ -6171,7 +6200,7 @@ bool free_to_pcs(struct kmem_cache *s, void *object)
>>
>>         if (unlikely(pcs->main->size == s->sheaf_capacity)) {
>>
>> -               pcs = __pcs_replace_full_main(s, pcs);
>> +               pcs = __pcs_replace_full_main(s, pcs, allow_spin);
>>                 if (unlikely(!pcs))
>>                         return false;
>>         }
>> @@ -6278,7 +6307,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
>>                         goto fail;
>>                 }
>>
>> -               empty = barn_get_empty_sheaf(barn);
>> +               empty = barn_get_empty_sheaf(barn, true);
>>
>>                 if (empty) {
>>                         pcs->rcu_free = empty;
>> @@ -6398,7 +6427,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>>                 goto no_empty;
>>
>>         if (!pcs->spare) {
>> -               empty = barn_get_empty_sheaf(barn);
>> +               empty = barn_get_empty_sheaf(barn, true);
> 
> I'm allergic to booleans in arguments. They make callsites
> hard to read. Especially if there are multiple bools.
> We have horrendous lines in the verifier that we still need
> to clean up due to bools:
> check_load_mem(env, insn, true, false, false, "atomic_load");
> 
> barn_get_empty_sheaf(barn, true); looks benign,
> but I would still use enum { DONT_SPIN, ALLOW_SPIN }
> and use that in all functions instead of 'bool allow_spin'.

I'll put it on the TODO list. But I think it's just following the pattern of
what you did in all the work leading to kmalloc_nolock() :)
And it's a single bool and for internal function with limited exposure, so
might be an overkill. Will see.

> Aside from that I got worried that sheaves fast path
> may be not optimized well by the compiler:
> if (unlikely(pcs->main->size == 0)) ...
> object = pcs->main->objects[pcs->main->size - 1];
> // object is accessed here

only by virt_to_folio() which takes a const void *x and is probably inlined
anyway...

> pcs->main->size--;
> 
> since object may alias into pcs->main and the compiler
> may be tempted to reload 'main'.

Interesting, it wouldn't have thought about the possibility.

> Looks like it's fine, since object point is not actually read or written.

Wonder if it figures that out or just assumes it would be an undefined
behavior (or would we need strict aliasing to allow the assumption?). But
good to know it looks ok, thanks!

> gcc15 asm looks good:
>         movq    8(%rbx), %rdx   # _68->main, _69
>         movl    24(%rdx), %eax  # _69->size, _70
> # ../mm/slub.c:5129:    if (unlikely(pcs->main->size == 0)) {
>         testl   %eax, %eax      # _70
>         je      .L2076  #,
> .L1953:
> # ../mm/slub.c:5135:    object = pcs->main->objects[pcs->main->size - 1];
>         leal    -1(%rax), %esi  #,
> # ../mm/slub.c:5135:    object = pcs->main->objects[pcs->main->size - 1];
>         movq    32(%rdx,%rsi,8), %rdi   # prephitmp_309->objects[_81], object
> # ../mm/slub.c:5135:    object = pcs->main->objects[pcs->main->size - 1];
>         movq    %rsi, %rax      #,
> # ../mm/slub.c:5137:    if (unlikely(node_requested)) {
>         testb   %r15b, %r15b    # node_requested
>         jne     .L2077  #,
> .L1954:
> # ../mm/slub.c:5149:    pcs->main->size--;
>         movl    %eax, 24(%rdx)  # _81, prephitmp_30->size



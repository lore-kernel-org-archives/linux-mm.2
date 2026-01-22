Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EA33C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 08:16:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A782B6B0110; Thu, 22 Jan 2026 03:16:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A25E06B0111; Thu, 22 Jan 2026 03:16:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 907AC6B0112; Thu, 22 Jan 2026 03:16:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7B3616B0110
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:16:09 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0385613965B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:16:08 +0000 (UTC)
X-FDA: 84358892058.03.EC56C83
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7BAB01C000A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:16:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="T//lM8Gz";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SkLfFGUb;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FejGHDEr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Vmkm9l5p;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769069767; a=rsa-sha256;
	cv=none;
	b=nhoyuo0YQMKw6ZbvTLSGBZylJggCFm2TR7HzweXF44ZA0v7JdkPyE7+ZTNDwdYFKoJ6Xse
	8uPuWWWBAK+y/Bx1p8Vs4qp9SJuz4kbaU7HkO4XEQeh9SOxmrw4E8QbkqT+cNbKXLqCRRu
	+tEZe4dZ9x3q35EQmLKiOfZf1b04MUQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="T//lM8Gz";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SkLfFGUb;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FejGHDEr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Vmkm9l5p;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769069767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zw7POV/9HzgQ7yJajz8n3KLlnlgcqjnTg/uCdgtJ8J0=;
	b=OVCNc0teOM4B4+FXSMmFGqaf3Zd1Vezc24uTsLsMKLyM2nKNVU5iY4wA7wNO6gm+B1nqmX
	hbXKCGqktrkljVqDm1QcvGIRR/GoinSbdKBzku9G99IaV8wfGCuml2NL4MH6Unl0WF4ZgL
	KZYe1qwi0rR9zWTaArTGan73J5z2Rog=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D36A65BCC2;
	Thu, 22 Jan 2026 08:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769069765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Zw7POV/9HzgQ7yJajz8n3KLlnlgcqjnTg/uCdgtJ8J0=;
	b=T//lM8GzKt7TmLJv3z4XB9qZ3ycAsbi8HyMzzLDnR6F0pd3QpDZsYQ7HKU6b/UkLm046VO
	dujoCN4qfZl8xkznzqduiS+4aJwS7kyO+z9YGgMf05/3+K3dg3AZjSF3fx33TUsGYC3Ozt
	wdzF9IidZiiNXx2Pt9A/P/xLeEm9pT8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769069765;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Zw7POV/9HzgQ7yJajz8n3KLlnlgcqjnTg/uCdgtJ8J0=;
	b=SkLfFGUb1iD++h8+I4L4mBaAU7XCVY4WCbZIFB/GeLiOfJDmsuFPOzVCLtgRe01GiOVaCs
	MxfRyhegQjfZWPAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769069764; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Zw7POV/9HzgQ7yJajz8n3KLlnlgcqjnTg/uCdgtJ8J0=;
	b=FejGHDErbHK1DFmtGvDb1InlbgjTaNK7blqk+p7ezadmAd4O63JhQIRdX6+T+A4i99dJFt
	Q4uJUE/W8/Vs0Gegs3hvRadCvwiggfbipOCxC+iJYF3WeoOKMsPLqOwH5SFltoIaMgy/NZ
	iC+aMruJ7AmCCSRnyp2lOlVcy7dkS0E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769069764;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Zw7POV/9HzgQ7yJajz8n3KLlnlgcqjnTg/uCdgtJ8J0=;
	b=Vmkm9l5pfjU2NjrbUbtRw0JFxfMfy2DvcRKHBsdhe1h/9M1BTacdvF8b/13m2kRjmlQIf5
	K/OnrsIBtDF5WaDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B20D33EA63;
	Thu, 22 Jan 2026 08:16:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DJObKcTccWlZWgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 22 Jan 2026 08:16:04 +0000
Message-ID: <3aa8d400-fa6a-48bd-b9f2-3bd6f37e523d@suse.cz>
Date: Thu, 22 Jan 2026 09:16:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 14/21] slab: simplify kmalloc_nolock()
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
 <20260116-sheaves-for-all-v3-14-5595cb000772@suse.cz>
 <aXGC_JRmz3ICjMHW@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aXGC_JRmz3ICjMHW@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7BAB01C000A
X-Stat-Signature: d5o19bitiq5qtfp6gyrjc3kggt6gfzdy
X-HE-Tag: 1769069766-881072
X-HE-Meta: U2FsdGVkX1/TdNZ0kuy7leN9lrWEq9cWuMjBkCLSLSrjH/c6E/kmC0XtskvRPeaoiwph66tYMCPTYWdr4vcOgT+GboJKqbGpFhc6fss5h4AZNCa2tK8t+m75J46akajJXVYLtA3l5iuLKwiHp1cnaXiNVL99YHIGHUfKSCNINZ5HKZkvQAlGNkjkKwEMVZ9xf0QXSaHSFxLFNxZTVjTpwfFb6AgmhSuiKRHEI6ATGAK6efGQEab/ityGL1OEe/BXOVx3YTdas1nNaXuGj4jHH9IVR6a9pAIUB0mnUcCFCP/GkNco/TckPoJqOKgRcuKVb/PDBPA99qBnngSIR7g13m8HZkC+qdBL1L8GbxTi0EW4+jMk2G1VZNHzBUuGXvgg++KpQ4oHZn2LVSNlJYBVe42Lsv/YGZiDLRyV0McV/BTvBphEF5EN+Q10lJJ1KTpm5Za5fIVRM1ppPwtI4wnTMel8uEGExNr0dXJszqbjR3qHrB0APOR6UosnyGc9DaR3V2WwHRa2YWZiEgHGTAEIONF3gP1jvE6fh7Z9yMPXIC33BXnyfI9k5UYJ2/5B4whEw30tsKUSCLl5Esxdf8b0VfPNYztQUuiaP7K3l3+I6A0KI6RI4sIi8H7ObDBTNgD+VdpUvkuq+HgumXoqIJQOCOUdxL2RDHJVm/r481zbolTci8yQCuQbkyVaD9QClLJlSwf93eKiWo76DOXyhdnFYCeAB2+BvzhMVcOWU5r9ozXGtsaGG7ZeSx9pkRbMnEXPUBHTw8lNo8J1t1nj9Kkg765eVp+g5A4/7IRpC/ETR7voMCkKa1nALVJAbLoy9tsAwBMeQkYGYOnNnhfq17jwrUhP5+fOYmb17b4ThEAng+paGQwxKLpTQSdENSfRfvYM3sFEF6EPtZocDEs7vmv/zXumi6aTlYnCDThMKIJtAo3GTZ8s5wWhS443hTNIdzhkfkGEVfuv/JEjIG+AP6M
 Y5YZtgdy
 WQyhR1PiLZvTS0n5kjJq7g4VBS3rn8MsEgOdFEV23VGfaSV2HFo7kFBkDjOp8hnjqAndGYhURxaV2ywo8W8FmhOmpX1fWAQBG8AZkYkKLW9IXR4GXFp2ZXIQOz+0qenTtJDYA88bK7G6IThzU0OrM9UYHGXirnxVL6ciI8ZLJcz3W6DDtKHhXj1as/ZyTQZKl94GsHeqhlhx9ybNyUU2DVtMJye3tqCvYlSnzCNNy8BtWEQatO3yG5kkmkYwtnWxLzl2wUnz3H3P4seUjWhlXjXT5kxZWXUCCYzs1j3e4tb1rwaTOmEph2hqOKjPjQT/jjNKoTgs//kMJCc3V/NNw6HciwasjhU/joPrSvcHhAvouT58=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/22/26 02:53, Harry Yoo wrote:
> On Fri, Jan 16, 2026 at 03:40:34PM +0100, Vlastimil Babka wrote:
>> The kmalloc_nolock() implementation has several complications and
>> restrictions due to SLUB's cpu slab locking, lockless fastpath and
>> PREEMPT_RT differences. With cpu slab usage removed, we can simplify
>> things:
>> 
>> - relax the PREEMPT_RT context checks as they were before commit
>>   a4ae75d1b6a2 ("slab: fix kmalloc_nolock() context check for
>>   PREEMPT_RT") and also reference the explanation comment in the page
>>   allocator
>> 
>> - the local_lock_cpu_slab() macros became unused, remove them
>> 
>> - we no longer need to set up lockdep classes on PREEMPT_RT
>> 
>> - we no longer need to annotate ___slab_alloc as NOKPROBE_SYMBOL
>>   since there's no lockless cpu freelist manipulation anymore
>> 
>> - __slab_alloc_node() can be called from kmalloc_nolock_noprof()
>>   unconditionally. It can also no longer return EBUSY. But trylock
>>   failures can still happen so retry with the larger bucket if the
>>   allocation fails for any reason.
>> 
>> Note that we still need __CMPXCHG_DOUBLE, because while it was removed
>> we don't use cmpxchg16b on cpu freelist anymore, we still use it on
>> slab freelist, and the alternative is slab_lock() which can be
>> interrupted by a nmi. Clarify the comment to mention it specifically.
>> 
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
> 
> What a nice cleanup!
> 
> Looks good to me,
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Thanks!

> with a nit below.
> 
>>  mm/slab.h |   1 -
>>  mm/slub.c | 144 +++++++++++++-------------------------------------------------
>>  2 files changed, 29 insertions(+), 116 deletions(-)
>> 
>> diff --git a/mm/slab.h b/mm/slab.h
>> index 4efec41b6445..e9a0738133ed 100644
>> --- a/mm/slab.h
>> +++ b/mm/slab.h
>> @@ -5268,10 +5196,11 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
>>  	if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
>>  		/*
>>  		 * kmalloc_nolock() is not supported on architectures that
>> -		 * don't implement cmpxchg16b, but debug caches don't use
>> -		 * per-cpu slab and per-cpu partial slabs. They rely on
>> -		 * kmem_cache_node->list_lock, so kmalloc_nolock() can
>> -		 * attempt to allocate from debug caches by
>> +		 * don't implement cmpxchg16b and thus need slab_lock()
>> +		 * which could be preempted by a nmi.
> 
> nit: I think now this limitation can be removed because the only slab
> lock used in the allocation path is get_partial_node() ->
> __slab_update_freelist(), but it is always used under n->list_lock.
> 
> Being preempted by a NMI while holding the slab lock is fine because
> NMI context should fail to acquire n->list_lock and bail out.

Hmm but somebody might be freeing with __slab_free() without taking the
n->list_lock (slab is on partial list and expected to remain there after the
free), then there's a NMI and the allocation can take n->list_lock fine?

> But no hurry on this, it's probably not important enough to delay
> this series :)
> 
>> +		 * But debug caches don't use that and only rely on
>> +		 * kmem_cache_node->list_lock, so kmalloc_nolock() can attempt
>> +		 * to allocate from debug caches by
>>  		 * spin_trylock_irqsave(&n->list_lock, ...)
>>  		 */
>>  		return NULL;
>>
> 



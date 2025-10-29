Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 182CECCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74F5F8E0091; Wed, 29 Oct 2025 11:51:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 726C78E0045; Wed, 29 Oct 2025 11:51:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 615A18E0091; Wed, 29 Oct 2025 11:51:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4AD988E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:51:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0CC74140891
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:51:07 +0000 (UTC)
X-FDA: 84051590574.15.DE014C0
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id 75D4480004
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:51:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1Uxy6L1d;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rVQuBd41;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1Uxy6L1d;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rVQuBd41;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761753065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=38XVem9V9R+8KoeP3WL2xrsbd2vq05h7o4o1fLwBkic=;
	b=2CV5THnPrOVpJqTwsyXsbMGvxlhRacwjRdIGh3ixdqtSxRkw6ZTMoq1R/19IA1IVA9O5n2
	kOsTDLenO20COnf/n2W6w5SVL8izah+8dLoZtB5aWmcCJpHQII7XHuPFydngRpJymbv4oM
	bkHDq4yPXkyTwV9vXmfcwZqSq+MQTRQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761753065; a=rsa-sha256;
	cv=none;
	b=0cBXe+7YmvR4bL0+Y7G89QQk3hw4Gb0zRpqwsIypWnlYd+l61BMHOnKfolUxbTIS0HmOOd
	nJF3DrBuNAD6VWE1TXnbouxa4nkSf8GkHg5R5gmp0VGX3vu31P2UDZb8sn4lsUJElqokUZ
	TgR1EuyHrKSGtJdQtm9YwPJBzYPRsBg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1Uxy6L1d;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rVQuBd41;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1Uxy6L1d;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rVQuBd41;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 00D5D33E4C;
	Wed, 29 Oct 2025 15:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761753063; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=38XVem9V9R+8KoeP3WL2xrsbd2vq05h7o4o1fLwBkic=;
	b=1Uxy6L1d7Um7O6aes80HVn1FkXOOB7KchA42iMzhSLJCMHr6WnfT2l8g5tm092KJkHfq2T
	OHvV6rA+Hxis57GReUprFeYcF0PJHufgCFBszl2vYzMuvJKGJ+8zSSx9vcuXevhoQBMBDz
	/LNHbLfYkiwsnHFNHzmE/6TdbDAABlQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761753063;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=38XVem9V9R+8KoeP3WL2xrsbd2vq05h7o4o1fLwBkic=;
	b=rVQuBd41DVOdI0CCV7dfWawL/cFnURsv7gYJbgrGTN6p4XIUfOK9lXn2TYlLOlFQ9uh80F
	Wj4NkDG0OLK9E/Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761753063; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=38XVem9V9R+8KoeP3WL2xrsbd2vq05h7o4o1fLwBkic=;
	b=1Uxy6L1d7Um7O6aes80HVn1FkXOOB7KchA42iMzhSLJCMHr6WnfT2l8g5tm092KJkHfq2T
	OHvV6rA+Hxis57GReUprFeYcF0PJHufgCFBszl2vYzMuvJKGJ+8zSSx9vcuXevhoQBMBDz
	/LNHbLfYkiwsnHFNHzmE/6TdbDAABlQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761753063;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=38XVem9V9R+8KoeP3WL2xrsbd2vq05h7o4o1fLwBkic=;
	b=rVQuBd41DVOdI0CCV7dfWawL/cFnURsv7gYJbgrGTN6p4XIUfOK9lXn2TYlLOlFQ9uh80F
	Wj4NkDG0OLK9E/Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D34461349D;
	Wed, 29 Oct 2025 15:51:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hcnzMuY3AmkcBwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 29 Oct 2025 15:51:02 +0000
Message-ID: <48e0bc5b-ccee-4fce-8a89-a32f79228bb6@suse.cz>
Date: Wed, 29 Oct 2025 16:51:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 06/19] slab: introduce percpu sheaves bootstrap
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
References: <20251024152913.1115220-1-clm@meta.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251024152913.1115220-1-clm@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: 43winrjzi7sgofiq6pr6i3g3gjoz33yo
X-Rspam-User: 
X-Rspamd-Queue-Id: 75D4480004
X-HE-Tag: 1761753064-182308
X-HE-Meta: U2FsdGVkX1+Tu3oUjMbulfsrsOsT0WHbTto590B9c/N+rViuY3gRQB1nFN20NyvozJf/djPwnqnIbHEqTnTFW2r/R9p+q83K8K3o61bRZXaak1mLnyDw7vWbxIvfNDSSBJJWxqtA656qUChJNICF4NuGAIurrj2ZE29Plc06PCynaNCmqqQBJ/HvCS8ixo40MiqF9EETpYHwHY3Abullov2r+gg+ROrLvOCS5Zo5F+Bb7rRvxjl6AWyq/QOxnRgULl/w1Jp7hXx034XqRRFX0JZaZbBJy6yUty2Nfjc83NQyVeM25VCOG+cp6QKkXw27eYHO+O+7LUJUIupD4Ix6WYLB9xdS3zXRcUHbM4B9wKyldwB0WLJVji9KJMCq/UBzFg3j7gyRouCyw/uV6oeGBVnsQKioXPkXpDGfg9MWrBpxlWpy5VNuHlsLmJq4s6JFllVmwVkIiNmWVduFzV9fn+Fomgs5m5T4GX1BhI74/rVQENCGdzigPaySG6++Q3BfS06/2fJFK2pCWMHb2fae0mFsl1J41gmeDd1Nen7roRcBrXwhmMpJ2Vnf0mJUZ1JwqU2Xn31PIXsrciqoGYB2r0n3XjSjTSupC5DYgOzPT7jZO3QiePvfKdjAviB1HTTl22IQ7GrgDPOeDF2IYJhspVSS2LYs8xM8zP8viW8xqfvayR+dGNITaCnbfGrBRLqvWnIveqRT9PXVzKtEk/uzwN+v6LtUV2yJ7wTYnk8Qz9xCfUrYPT+uj6mTNzn7Ohw1bQPHNvolC5EQ47pwx52FuBLqIvY9X52TVAxs0KWNW46BraVyKGdlUL9HHqcVq43ASN/RjhUiQLCHBa3qknReyGXH1Pg+cchIkUd8vI+XUidjaabEhsYj3y9pvcgKr1wpVYSFdGEB15bJXUkEfdxsd1EZnGT0v3Qb6eVweGMNhCWAYse3HJGTueVxpcgUbKmgXi8LImKexSedfi1wHbV
 qXppk4ZX
 FiNeaVdebpA+6RpsmaFykPKcrAe29/kpJ+3+nz1Zm76xHra7sHdXF6JQr57I21Tv27xjF6RJZHrqCYlIdcey8b8EXpn8jNPbSyyPR6vWsn/pYa+1OZQuj/gE2am7bQzzaiUQ0C7pkwDR7/8F5JVwMeOQnbS1nqC4tOBCdR4DvySSFMM1F5Zpj6ESXTC5BLSo8CgrSUKFJRhwtBpL7TACF2p5CZVCLKrhtNCcFChT3euk1l4D0P+7VUEeA7v3C8v998XLmVWmdfy3rrUh31dSnH4V5VR6ec/QyTgZp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/24/25 17:29, Chris Mason wrote:
> On Thu, 23 Oct 2025 15:52:28 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:
> 
>> Until now, kmem_cache->cpu_sheaves was !NULL only for caches with
>> sheaves enabled. Since we want to enable them for almost all caches,
>> it's suboptimal to test the pointer in the fast paths, so instead
>> allocate it for all caches in do_kmem_cache_create(). Instead of testing
>> the cpu_sheaves pointer to recognize caches (yet) without sheaves, test
>> kmem_cache->sheaf_capacity for being 0, where needed.
>> 
>> However, for the fast paths sake we also assume that the main sheaf
>> always exists (pcs->main is !NULL), and during bootstrap we cannot
>> allocate sheaves yet.
>> 
>> Solve this by introducing a single static bootstrap_sheaf that's
>> assigned as pcs->main during bootstrap. It has a size of 0, so during
>> allocations, the fast path will find it's empty. Since the size of 0
>> matches sheaf_capacity of 0, the freeing fast paths will find it's
>> "full". In the slow path handlers, we check sheaf_capacity to recognize
>> that the cache doesn't (yet) have real sheaves, and fall back. Thus
>> sharing the single bootstrap sheaf like this for multiple caches and
>> cpus is safe.
>>
> 
> Hi Vlastimil,
> 
> We're trying out the AI patch review automation on the BPF commits and it had
> some questions about a few of these.  Since the goal is to actually test the
> automation, I'm putting them in unedited, but I did try and make sure they
> were valid before sending.
> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index a6e58d3708f4..ecb10ed5acfe 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
> 
> [ ... ]
> 
>> @@ -7733,8 +7782,7 @@ static void free_kmem_cache_nodes(struct kmem_cache *s)
>>  void __kmem_cache_release(struct kmem_cache *s)
>>  {
>>  	cache_random_seq_destroy(s);
>> -	if (s->cpu_sheaves)
>> -		pcs_destroy(s);
>> +	pcs_destroy(s);
> 
> Can pcs_destroy() handle a NULL cpu_sheaves pointer? Looking at the
> error path in do_kmem_cache_create():

Good catch! I will leave the condition in __kmem_cache_release().
Thanks!



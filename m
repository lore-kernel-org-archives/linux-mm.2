Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E4EED44C5A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 14:47:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C17D36B00B1; Thu, 15 Jan 2026 09:47:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C02D86B00B2; Thu, 15 Jan 2026 09:47:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD83F6B00B3; Thu, 15 Jan 2026 09:47:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C1916B00B1
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:47:55 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6C8C316038E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:47:55 +0000 (UTC)
X-FDA: 84334477710.01.4087D34
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id E136B180004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:47:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ao7OxHHt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=If0rrow2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ao7OxHHt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=If0rrow2;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768488473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MU58J6Us5GE6JKgk7JVJzcX719EO56GJyTLxcovO0Lo=;
	b=H61pbj+Oi8vy8osOPYlbjAEaGtxgq+Zi7fL6TbN6pntOa5+1QP2OH6/1pLO/SYiSDhRTic
	QHimlWzYD293PZNsXf52SI1PgmDl/RIWUQYiV3WVNDeeVjRJXJcqW62VMQyhA8NbOCGzd/
	U+XObUrBCrQU9UIJq/bvAAxe3wi/2Yk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ao7OxHHt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=If0rrow2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ao7OxHHt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=If0rrow2;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768488473; a=rsa-sha256;
	cv=none;
	b=KYFHa38RUsC0EVZlSej3V7aWTMJqdF1JDMhMn0FPePMAMxcqPsKqqTKrDBbKrC42XdnvLM
	0m7wY+mYBknF77Mi0q9lIYL0pI3yiginKUAkHJZZWieO/CvDEs6FCEez+T2pYcKCaw12tN
	8KdRsMB1YX6m4yTCY/KLohsVI/bKDVI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5EF7D5BCF8;
	Thu, 15 Jan 2026 14:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768488471; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MU58J6Us5GE6JKgk7JVJzcX719EO56GJyTLxcovO0Lo=;
	b=ao7OxHHtrYTwA6wMgD4Df0/Iqu+VhvFLu8RFmh5HXD6vNZYqfkndxNXpdNyQe1BGD1wqKW
	zBkwPkCBt42DgIIrJTRqwUKVIzG7o9Vf3yDmg2GyBzu8HWfyLcYds7GUPWaB4Q98nWoGcb
	AufWmjM5YPa7IbBKdLpQTFHgkD1ToVM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768488471;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MU58J6Us5GE6JKgk7JVJzcX719EO56GJyTLxcovO0Lo=;
	b=If0rrow2dADYxa0SeDk6R7z8NuZtBrf8UfwNlUPKpYjFRednCKjk9M7reE6mu5upT2VxG/
	JeOjSnvRxS+VjOAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768488471; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MU58J6Us5GE6JKgk7JVJzcX719EO56GJyTLxcovO0Lo=;
	b=ao7OxHHtrYTwA6wMgD4Df0/Iqu+VhvFLu8RFmh5HXD6vNZYqfkndxNXpdNyQe1BGD1wqKW
	zBkwPkCBt42DgIIrJTRqwUKVIzG7o9Vf3yDmg2GyBzu8HWfyLcYds7GUPWaB4Q98nWoGcb
	AufWmjM5YPa7IbBKdLpQTFHgkD1ToVM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768488471;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MU58J6Us5GE6JKgk7JVJzcX719EO56GJyTLxcovO0Lo=;
	b=If0rrow2dADYxa0SeDk6R7z8NuZtBrf8UfwNlUPKpYjFRednCKjk9M7reE6mu5upT2VxG/
	JeOjSnvRxS+VjOAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3D2C83EA63;
	Thu, 15 Jan 2026 14:47:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SIeZDhf+aGmCeQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 15 Jan 2026 14:47:51 +0000
Message-ID: <51761d10-2ad4-4c5c-8bb1-5463d42aa31e@suse.cz>
Date: Thu, 15 Jan 2026 15:47:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 12/20] slab: remove defer_deactivate_slab()
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
 <20260112-sheaves-for-all-v2-12-98225cfb50cf@suse.cz>
 <sofeahffu5jj5xbre422lelbisfclwdul2i42j7odth3j4yzil@nyxfavdhwmuz>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <sofeahffu5jj5xbre422lelbisfclwdul2i42j7odth3j4yzil@nyxfavdhwmuz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E136B180004
X-Stat-Signature: 1dy584q9mnqmd8x17t7y4j7bbdasi3b8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768488472-409302
X-HE-Meta: U2FsdGVkX1+4YKrpFDKvoNW/Jr50Wt1OW8fLUU6EwQXAzXZnubA7cDgT+lQIpnxLhyTEojXg9Hp3hwE5ymaMYXoW4Lhdq3L3EhyDAGPg1BCa/4HGwX1C+LO9u5Fu1Te19LEJWAWPgGTTh6F+m/TzKOgAXnPbN5kDTgWKrKQe4vYawP883gpTRyNQypE4POWRkSe7a2mwfAqGJu53lqplfgo+syU8Zg21fE2KmbjROo8rEw7s8ZzPWGaLOjUb1qGvjG1Gl+O4u/ldlSZe9bndY7mTvgxhK+54RCvth3rQb499G78kpDILjoFvnswrSb09E2UUGgHxgvuuQchMOiD+9H7SNr/hU5jXayWvB+7XS5rugEdynVsjhrv0lnCXnJWCz4lzqBW2GX70AKqhNaUeUewOZYrJqYts9+O7GsjJ5ErLKs6pW3xLt4DdVVx1nHbI7o4AqEZGC1vAIR61N4ezTeDzCQATsvXGGhIrPMfk10WSvfwBxYuqc106J92g4ALrr1rhQdoImK9hHI2RPDky7wwlanQ8UhdF/iITYOg+/j9hdLv6YP6GdP2yIhP2L/Gh9uREE/YfmOxjM/ZpXBMojjATR4QvViFHhoHFS/7YKF5SRc4uHwphrvA4ip0cn1W7O/3ezcuNWOrGwG551sZDO+5Lnabrr/tRlbpp1k46PVqcCafVlzGhdP/ybKQNM0Agg3H9hnyFaej7AwRYUVOgMF8mwijczZb6TLYEn2WZN4clbs42YAOZkVIflt6n0Olf6LkRm4bysMpffhV/DzhyjWd56Kle70eKhoEaGEXaGZNbIKEu3gd3rVdUsg+OARB6smppimAjyAArI3ihhflL6E6DND1dCFq0csCdexlLS98d2h05oTXws8iFSsai+hPLbYruOmArJOSy9P48pQJCWHb3Ctfl9ERk6neYjR5ztfxgZVf2BeB1CoYa0wcrIPGs8kQSctCt844nNrZNREz
 IKkuTOIf
 Mf32vZTqUTUs7lr9hh8h0s91hWIR5nnKp15VOVq/Uv4WXG7tdiJc80J06BfUGWcDiIyv0xwJ4eTLVRBErLwDrDfeYubrq1GAe4QUhwOgPj7BJdiCbLaFQ4M+eYwNA2Rz//mIiIyZAVsJ8buLf1LHzu2jcRZozRTYxLvb/N14rxth8mKU01Mfl9oqycuuyuZ3BcVMtAorFj+yUH7jhOg8Kx5zuBuM1UcaY++TGtQpU+zUf/Ao+LKo0YKuXyzfVod0AOsLNWYeeQDBxZXspQKMGlfYGlf8PHNQ4tR60nLYxmxduxh0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 15:09, Hao Li wrote:
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -3248,7 +3248,7 @@ static struct slab *new_slab(struct kmem_cache *s, gfp_t flags, int node)
>>  		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);
>>  }
>>  
>> -static void __free_slab(struct kmem_cache *s, struct slab *slab)
>> +static void __free_slab(struct kmem_cache *s, struct slab *slab, bool allow_spin)
>>  {
>>  	struct page *page = slab_page(slab);
>>  	int order = compound_order(page);
>> @@ -3262,11 +3262,20 @@ static void __free_slab(struct kmem_cache *s, struct slab *slab)
>>  	free_frozen_pages(page, order);
> 
> Here we missed using the newly added allow_spin.
> It should call free_frozen_pages_nolock() when !allow_spin.

Uh damn, the first RFC had it correct. Where did I screw up with git? Sigh.
Thanks!



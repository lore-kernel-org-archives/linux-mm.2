Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D220DD5B842
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 15:20:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31C956B0007; Mon, 15 Dec 2025 10:20:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F4096B0008; Mon, 15 Dec 2025 10:20:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BC1F6B000A; Mon, 15 Dec 2025 10:20:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0DB486B0007
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:20:27 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ADAA51402AF
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:20:26 +0000 (UTC)
X-FDA: 84222066852.10.23A0028
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 230EB1C000A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:20:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ekZ3+tR1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sg57+0Ug;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E7lDI2Ut;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1EAHA+2Y;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765812024; a=rsa-sha256;
	cv=none;
	b=Ml5AZ5GUbIe24RTt4OTel97WCmlAd7bnY8rEAwBIMk9/ksrbubFa5p/eGbuQwC7riQ3Hm+
	AgIB/gYi9ezOUWczS2NTYxHLMcgEpZSEnLOtakWDmQbUwOuKY/qvaUnpr1Q60OGQy5YIKG
	Ep2tWz+98SFLCllF7NO7k2AsCc7tUWM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ekZ3+tR1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sg57+0Ug;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E7lDI2Ut;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1EAHA+2Y;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765812024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FmO7Y+7Jh332+Soq1KGuWIcarbnspe5a6pb6NrIblac=;
	b=Oj/Pc688Vmw993HUwiN/HTmn9CgYb9wHh+4m88pXHMNimOzekB9208CuquzLK+mFr6X/R4
	fjhtp53p06+9spFjAW7HCj/87Ew8TJ9g0Q2hBln4uaX4LrpwHR7qXpkZUjJUiwvXLD+hsS
	AeA/kejbHqRU/WalV/QdphT1jwbzuKU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0E12F5BDCB;
	Mon, 15 Dec 2025 15:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765812022; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FmO7Y+7Jh332+Soq1KGuWIcarbnspe5a6pb6NrIblac=;
	b=ekZ3+tR1lRk24H+v+tjhvVPREDqkIJOuckcBTaRsGGbfvnb34kdw6uYuo1RCjEGc46dvR5
	uAjNVEZL38mCgLPO+qA22LJSyjD06Mkc6d+zeMzZBulI7syWqdzk1aGCUWY9nTO89tdGuZ
	uGWl92lKiz6JUK9e6tqy58pNePkcnqI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765812022;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FmO7Y+7Jh332+Soq1KGuWIcarbnspe5a6pb6NrIblac=;
	b=sg57+0Ugg3R6+623EwKu7Sr7XBteCFOGCF/zon9eLZcY9iOBYa95tN1xtaxP3zD0xxI0g4
	FJyu+Ld1p11H84Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765812021; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FmO7Y+7Jh332+Soq1KGuWIcarbnspe5a6pb6NrIblac=;
	b=E7lDI2UtPy2HKR5vDPGmH186dCr37Own3iUaFxIGkHsoAfpkJgppePcpiTNNMillLMBH+6
	jZHWllPxDKMVxBG78O0j/OrclWg//JHiALPFOYrFLfxrZYcfpJHHJA9DELphr3pztt4woE
	NV1dV2mU34ZVIPCkxeMcoeTSkGNSyUc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765812021;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FmO7Y+7Jh332+Soq1KGuWIcarbnspe5a6pb6NrIblac=;
	b=1EAHA+2YAMxbjwBBdAK9NrQbCkZlHtwsi54dSvOccKN/v8/p4xADJlJw17BOZ6pWOhZ2PJ
	OjM5hw/oV+SCfQBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DED283EA63;
	Mon, 15 Dec 2025 15:20:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nsa6NDQnQGk5TwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 15 Dec 2025 15:20:20 +0000
Message-ID: <5153dc10-c041-4283-9722-b93a76c44a20@suse.cz>
Date: Mon, 15 Dec 2025 16:20:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 06/19] slab: introduce percpu sheaves bootstrap
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
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
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
 <20251023-sheaves-for-all-v1-6-6ffa2c9941c0@suse.cz>
 <ct5pjdx3k4sxw5qjuzs7rsblkxpkah3qdx6kbhe2oeuaontaii@fwgb6ovi36zj>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <ct5pjdx3k4sxw5qjuzs7rsblkxpkah3qdx6kbhe2oeuaontaii@fwgb6ovi36zj>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 230EB1C000A
X-Rspamd-Server: rspam04
X-Stat-Signature: bhzts8oehptfpeh9tt9pwu4oyks7wsia
X-HE-Tag: 1765812023-346285
X-HE-Meta: U2FsdGVkX1+5LHtgc4MFtxG8xb0XRprHbGjAFOhHaKkSIzMiiX9a7DrLfO06NaWxTaTM4nihNXyAuCzc0zPqcb6VNoP1TzO+BXwPNpSOBOqL8gGw4/pjwSh86vZI0IFfls5vuin4YrP+ysbVQaqZwpijAyqtWHmpKBVqPR4r24NYDeSGx+weR1+T+XdO8nZc84pWY3ktkI2KY2FVQ5oBZUAIFuUH25De9mfcTXB/9qGP60FIDHapMSBbIniX82awzMAGOvwm/kVcak2xRcl/3WpBOpazW6Rp49dbQTAqqCj57TDnw8UmM99jP/LbXIMErCPjNi5qKcgwEBrncbS26ii+roHi+q4LBKfTG8zbOrRwNzkcbrBelMT3R1F4Y44SbeqLVwV80iSAiTKhOYi/B22NfOe9xjCtpIt3KG6M31lCDmbwhcyyIlc6kf6wSyCuNhd9ubUuHMOG433xF4djTALWUG1DSo+KjZH17gmV2jaySKKIT7mxVTs9dSWnFg/Q07WRqxPPjdEFKkUgn6CI1lTZHSYJ1TXXNxVySUgcbgCPw5qXGJqRXWJYNXw09kTck4RzdnANxdN7a2vImujgjlcaVHDslSp4go7skSjd7P5C6zWkhJSk3NEYszuWCcgSWiNDq74VkNYxr4kKhhwgfv+s9y9Wm4IuM4GfLlGB1b0iA4MLIb+Xs9n6MyJKBCrNoewdfnqoRr6waLlKVO6rONW6+/Zt2evjgQK4oTyVtMMcZsPV0oecMx4Kx9RN4q22eSI9LI08uqQumGKFZNjNxDQBcrlnkpIJq0mXtuAXbUbcOXSmiDGZv8l5FTt7O9chvY72fXU+os9pr7T3lefzSLu2InpPEC3WbBNKYMQs0PCVZyl6BinHv2gesc4hrwFz2Dio1DF6uhnMMKV1tLtxjQMeuoEtFW8Gl9rMFD05rb5f2DPY0yD31lhkBfBqjjIEuOfNHUdCVeQIz/aX1rb
 H5FuANiO
 ydmwv1QfWcq/5BFP5XFh0BQmGY3Elosdf4TI0oPUrTQAJFgfME6yI9CESf52nts5Q4CWnApHTQn7WbicBKdWybVsg689ysYlsg+gd0GmKivv4+4lfSpyirZziotBUFQHH8T3w9EEVV4TjFrVdOB8pCFKc6U37HejPICbJYkRJUZNhR1Ir7INlOcUR/nhT+E3Iw68HQWc3wHo08NDX4RvMG8o9wug0p63bdITV7UCNVf1tnIUgAYanInUtMcvGiIhIa2lYz0pwGgmqtTJizrD3XuvIZdUwK9s5G7XE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/15/25 13:17, Hao Li wrote:
> On Thu, Oct 23, 2025 at 03:52:28PM +0200, Vlastimil Babka wrote:
>> @@ -8608,12 +8656,10 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
>>  
>>  	set_cpu_partial(s);
>>  
>> -	if (s->sheaf_capacity) {
>> -		s->cpu_sheaves = alloc_percpu(struct slub_percpu_sheaves);
>> -		if (!s->cpu_sheaves) {
>> -			err = -ENOMEM;
>> -			goto out;
>> -		}
>> +	s->cpu_sheaves = alloc_percpu(struct slub_percpu_sheaves);
> 
> After this change, all SLUB caches enable cpu_sheaves; therefore,
> slab_unmergeable() will always return 1.
> 
> int slab_unmergeable(struct kmem_cache *s)
> {
> ...
> 	if (s->cpu_sheaves)
> 		return 1;
> ...
> }
> 
> Maybe we need to update slab_unmergeable() accordingly..

Yes, I meant to do that but seems I forgot. Thanks for the reminder!

>> +	if (!s->cpu_sheaves) {
>> +		err = -ENOMEM;
>> +		goto out;
>>  	}
>>  
>>  #ifdef CONFIG_NUMA
>> @@ -8632,11 +8678,9 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
>>  	if (!alloc_kmem_cache_cpus(s))
>>  		goto out;
>>  
>> -	if (s->cpu_sheaves) {
>> -		err = init_percpu_sheaves(s);
>> -		if (err)
>> -			goto out;
>> -	}
>> +	err = init_percpu_sheaves(s);
>> +	if (err)
>> +		goto out;
>>  
>>  	err = 0;
>>  
>> 
>> -- 
>> 2.51.1
>> 



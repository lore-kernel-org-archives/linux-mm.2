Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 146BBCCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 17:30:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60B4F8E00B6; Wed, 29 Oct 2025 13:30:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E34E8E00B2; Wed, 29 Oct 2025 13:30:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D18F8E00B6; Wed, 29 Oct 2025 13:30:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A4648E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 13:30:05 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DCA7512B32D
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:30:04 +0000 (UTC)
X-FDA: 84051839928.24.D6CC69A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4B07B180010
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:30:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LVEIVOaQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ctF9xyK7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LVEIVOaQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ctF9xyK7;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761759002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oRycsl2hppTtVF2hMtZZwaQ8XfejV47sf0TtOJTd2k4=;
	b=dPRI+dAv4kwTEDToi1MT+xUSphEpjx1FqTwAMknYzlB9+xObyo/3LbCyADyxnK2TsdNB2c
	3A6YgVFroHFGf9IVHC+rVlYezBPw8uqlkvtGucKH8K8NtsRAtiBg5kVM+EVQj7snsXKxaB
	tyFGM/ilUyXZZjIhMhQL7UYElclKqHw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LVEIVOaQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ctF9xyK7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LVEIVOaQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ctF9xyK7;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761759002; a=rsa-sha256;
	cv=none;
	b=bc1SRF/5pBUTwOAbUvFpYgnHnq6s2/wg8BTas40+c/omyg9Ca5gdqVkNWkiS8mD2LOliHY
	t9Np5SM0AhkA+7SuQsCcL+vPestSCJd2lqhnv/mkUEecnDLF6RTrkz9IzjkP6PbCC54DUy
	iPDDIOXUlLlCGOPbcip8OWIcLi4DEUk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9C6873410D;
	Wed, 29 Oct 2025 17:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761759000; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oRycsl2hppTtVF2hMtZZwaQ8XfejV47sf0TtOJTd2k4=;
	b=LVEIVOaQiQihyyVUrP032S89inzygkFWyPglGyhCVKJys7tNMO6HUJzV4u69AGh6ilDhGs
	MkzoCxej3zPDuphsnF+Hp1VA2ZsYuV14fngmFbHOhu0qDjTL0mVq3oUguLEh8loNejGcqJ
	0G9uHfoch0uFMiMIsjFJtTWHalG0q0I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761759000;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oRycsl2hppTtVF2hMtZZwaQ8XfejV47sf0TtOJTd2k4=;
	b=ctF9xyK7ak253elPpv+mWxgHFLYAJ390A0negsSyH/lt8REDr2T6ttS1j2ikK1D5xSvd54
	AiwoEjokQlAAJLDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761759000; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oRycsl2hppTtVF2hMtZZwaQ8XfejV47sf0TtOJTd2k4=;
	b=LVEIVOaQiQihyyVUrP032S89inzygkFWyPglGyhCVKJys7tNMO6HUJzV4u69AGh6ilDhGs
	MkzoCxej3zPDuphsnF+Hp1VA2ZsYuV14fngmFbHOhu0qDjTL0mVq3oUguLEh8loNejGcqJ
	0G9uHfoch0uFMiMIsjFJtTWHalG0q0I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761759000;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oRycsl2hppTtVF2hMtZZwaQ8XfejV47sf0TtOJTd2k4=;
	b=ctF9xyK7ak253elPpv+mWxgHFLYAJ390A0negsSyH/lt8REDr2T6ttS1j2ikK1D5xSvd54
	AiwoEjokQlAAJLDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7E70C1396A;
	Wed, 29 Oct 2025 17:30:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sfBnHhhPAml+ZwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 29 Oct 2025 17:30:00 +0000
Message-ID: <1e4e6ddd-e4a4-4f3a-ae47-93b69d25ff88@suse.cz>
Date: Wed, 29 Oct 2025 18:30:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 07/19] slab: make percpu sheaves compatible with
 kmalloc_nolock()/kfree_nolock()
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
References: <20251024140416.642903-1-clm@meta.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251024140416.642903-1-clm@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4B07B180010
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: y8sp8tysi5ifk59byzoc9m1m9tayzhfx
X-HE-Tag: 1761759002-563546
X-HE-Meta: U2FsdGVkX18I7huFFXtnHI8R4rcJF9KIu2F23P+9hQYTdMzarnHipLLTAWZVbk2bh809Pgd2APMXGIY26mN5AAyqu+UZuEpAwqngGeLx+cc9rffwn3ZSU7D8XE+SZ/sxhXE94Rp5ATU2HjtQG95paggbBbmVbXRoPuQPXMz7tIDj3bqenuAQVKdc6N+/gRBSXjM/Lo44sZi3WZpA4vg8f1nwkOpvDlEmqM8nmtMSxvcsmnb9VoQLmHTQ2SJvA1Hnh79kQui8XIQHG1cB6Bg+7gGnW9dT09uYObDWciS9FDEvAqLt4d09vtqiPnqcA7OOqCyBQcCAJzGP1RiKHkiUU8v9XDeQ/M21LbpSr927xamTdkCUFSQKkvANc9gIqkX6J9fW61JxCF5fFYVBtYswh2PO+PZ6kePjr3nLCk1mlSqGv6bPM5BSR2fb4ET8wMhdILNDRsLul3oLfaFN8KNL33P0phvIFuDRshApZYGIyvOeYGPq/zbz4P7ORBVu0Pvk9EioIYAu56Pui1UmFgYZ2FD7fxdmgSlqGxg9HyhIeHmJn8Cu/PGx7mK4mj94psDBb98gGh0GIwjllggO9akkffy5ofLuoZS8lF19svthYXaMke/rOhkuwYrZ/FznBSczoFpD+A3naZaDfwAVV2A3VSCe8i4f7SrqT3t6yf9E1nzObEvxQ8pOgI4CXO5riYRkPlAw5gXTmcJ0p81bwlkhMeR+Q3yFx2zMbPdVYzhIULDHpjdERf7gEcKZTUXphqt71QwmYAv+Xxs553K8w0F+tj31lOn1Ie8S7BQzJT/V5e03rd+xXYA84xt1fv/fA73H51ctdelqSJmpgki/gTMrP85dAkbqIfGDsJUjgqqgNU27pw3f1sM0Dbr+1lPSd3CrRIwJdKofxUkGOaDtUAgaJf+M9rC5DskcT07LHcckom6WhD1Ec/2pvqOf1RyYqDIPSKwF0WDNo+g2klFJKqC
 X25Nokx+
 U3WQzQ8bVRy7rrE2sT36z/6LVUcS+sbl409zpC+ZM3ARe3s5gE9kgHjrX4/HNDkXt9eCmipbvGkmbjnFT2dw78oxG6dp7KbRSQJH4QSLQ2X7C6ztj0vBzPbnSiKwgUP0IRsOyDL7Rpe7dbsnu9hCdEK2Thm8fGo2cH5I5SeU5qRHDl9fEAFkqgaKwYDvhKaM7LfT6xYLg0Q6n2KsPkCtET1kH/wALedw5Hnx5nLPp29iX2ow0yQpHHyeHvdlrFYeJDVU0VEvvHrclexBEJxzjQfzPE5flSiXdPQA8cD129T0cqq1bQl1yyampFokFuEl0pFN6fannilOu8tA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/24/25 16:04, Chris Mason wrote:
> On Thu, 23 Oct 2025 15:52:29 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:
> 
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
> 
> Hi Vlastimil,
> 
> We're trying out the AI patch review automation on the BPF commits and it had
> some questions about a few of these.  Since the goal is to actually test the
> automation, I'm putting them in unedited, but I did try and make sure they
> were valid before sending.
> 
> This one is a little verbose for s/NULL/ERR_PTR/ suggestions, but:
> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index ecb10ed5acfe..5d0b2cf66520 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
> 
> [ ... ]
> 
>> @@ -2990,7 +2998,8 @@ barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty)
>>   * barn. But if there are too many full sheaves, reject this with -E2BIG.
>>   */
>>  static struct slab_sheaf *
>> -barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full)
>> +barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full,
>> +			bool allow_spin)
>>  {
>>  	struct slab_sheaf *empty;
>>  	unsigned long flags;
>> @@ -3001,7 +3010,10 @@ barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full)
>>  	if (!data_race(barn->nr_empty))
>>  		return ERR_PTR(-ENOMEM);
>>
>> -	spin_lock_irqsave(&barn->lock, flags);
>> +	if (likely(allow_spin))
>> +		spin_lock_irqsave(&barn->lock, flags);
>> +	else if (!spin_trylock_irqsave(&barn->lock, flags))
>> +		return NULL;
> 
> barn_replace_full_sheaf() now returns NULL when the trylock fails, in
> addition to its existing ERR_PTR(-ENOMEM) and ERR_PTR(-E2BIG) returns.

Good catch, cool it can find such bugs.
I'll return ERR_PTR(-EBUSY) which should be compatible with the callers.



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E808D44C4C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 13:53:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCFA96B008A; Thu, 15 Jan 2026 08:53:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99C46B008C; Thu, 15 Jan 2026 08:53:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA6E96B0092; Thu, 15 Jan 2026 08:53:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 96A156B008A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 08:53:41 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 592AE5880A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:53:41 +0000 (UTC)
X-FDA: 84334341042.04.1576186
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id BDF3D180006
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:53:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BGvS6CKB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0i6hcDdq;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BGvS6CKB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0i6hcDdq;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768485219; a=rsa-sha256;
	cv=none;
	b=Fi267Xiv92KoxhjDMj+l83+JPOXv31zxbLs6df5HGIrQyz4uWwzzfOZNnws7KzpopVjkve
	OYbrcvpIxKalEW3Ojt6PgIubGw9kyC/nwKX1iFxBGzwt98RquOkr9rq/cepH1W7om4KWZk
	0grIqpNRWLYgy3BY7CwoAoXzl8ozrsI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BGvS6CKB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0i6hcDdq;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BGvS6CKB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0i6hcDdq;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768485219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T6ReUDa8OO9JhozmVpJl2INs7RyRAxlBOkfOTzlca2k=;
	b=WXfxcWzIEOIVwJ3Jy5jAWyuL+wxu+Q2YaR8eZv/T7UHrSn+2bhtPRiPGGZu3aJxVwFkTbN
	9qKHAVYluhSNX2F8AUgwnsAQsKW36X2kggBouYpRPdpNmv/CeOUudolx2BjcrdboLC4r8Z
	/96R+Lomgh3mRCQCYb12B/4NW8zAwfM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2D2535BCDE;
	Thu, 15 Jan 2026 13:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768485217; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=T6ReUDa8OO9JhozmVpJl2INs7RyRAxlBOkfOTzlca2k=;
	b=BGvS6CKBxykqWxnxPbblt4fcLzBnTqHy0PO+2o+x8BJ8lHTjvZR4mccehwZZycNZXhZ3+t
	96Xi4R9LcRH4/mGJ25xYKQr7ppsqiU6kIiBezYKOHMq5c6p2X4WqL0+HVR5qbAcwBPfWFb
	lznVEwdq4tWXoOrZ2cd/cB7cxZpBxFU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768485217;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=T6ReUDa8OO9JhozmVpJl2INs7RyRAxlBOkfOTzlca2k=;
	b=0i6hcDdqMW1dnPXUN04/qK0mRx6YE16ZZv4+SLn4ktdd28hdoSGfcZEWJZAkajcaXl3mJa
	lNnDtJwaU81se1Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768485217; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=T6ReUDa8OO9JhozmVpJl2INs7RyRAxlBOkfOTzlca2k=;
	b=BGvS6CKBxykqWxnxPbblt4fcLzBnTqHy0PO+2o+x8BJ8lHTjvZR4mccehwZZycNZXhZ3+t
	96Xi4R9LcRH4/mGJ25xYKQr7ppsqiU6kIiBezYKOHMq5c6p2X4WqL0+HVR5qbAcwBPfWFb
	lznVEwdq4tWXoOrZ2cd/cB7cxZpBxFU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768485217;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=T6ReUDa8OO9JhozmVpJl2INs7RyRAxlBOkfOTzlca2k=;
	b=0i6hcDdqMW1dnPXUN04/qK0mRx6YE16ZZv4+SLn4ktdd28hdoSGfcZEWJZAkajcaXl3mJa
	lNnDtJwaU81se1Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0D9363EA63;
	Thu, 15 Jan 2026 13:53:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kNb/AmHxaGkrRQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 15 Jan 2026 13:53:37 +0000
Message-ID: <3aa7a303-677d-4ef5-8df1-b3c0fdfcc787@suse.cz>
Date: Thu, 15 Jan 2026 14:53:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 09/20] slab: remove cpu (partial) slabs usage from
 allocation paths
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
 <20260112-sheaves-for-all-v2-9-98225cfb50cf@suse.cz>
 <3k4wy7gavxczpqn63jt66423fqa3wvdztigvbmejbvcpbr7ld2@fbylldpeuvgi>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <3k4wy7gavxczpqn63jt66423fqa3wvdztigvbmejbvcpbr7ld2@fbylldpeuvgi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1fgxnnuujjhk7xyfui85f6ke6ere8m65
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BDF3D180006
X-Rspam-User: 
X-HE-Tag: 1768485218-792561
X-HE-Meta: U2FsdGVkX1/NJ6jlGdU6d4Jr6DyoQiUdD5yFUfEDEfPpW0A2QuccfOe9Jl/TdkYb/hjz0ymjvmstUwd8alO/i3az5zEHZlTHjPvnCkNDH7Cn3lIUelSxhwsi3cyILXPXVNdHhULA8PnvAWT+YquMGGKCcdhYN+LnMSe1ShxR43IFeQonydASLb3K1NSJNHZd2PGJR8doHYF9h5uYptJebBcyHiuGzcIdVdeIWvN2ZXmDecSw0AcLvbsvlJ0z3ySPnblr0lp2vjmZcRsvQwBUGT7wp0kpMHT7tl0ZU0Uv7/FlwJgQmNlcllkPChcqtl/Ym9Q6Jw/lxbfqCx559XBhX8uUtqtpRp1S04StPnqyhHbIaU5AD4TgkjiGw1FgFKSujuoR+9/nbDRVpztcxP2n5xfwxSoJvrw/Gp5hR+3Bi7xHaNE71mEnPTfMTRPTyH8DjmchaJ6l/UW1fTft9c1jYvRRk8P1uvbkKxmRQjUWj0W52Gwp/B9tbRf8Z8K+TmBReIfYH/gz7zw/uE7Q8RFiB4fG2sQF1a18i1vYuM7vuoO+VSiBIDoG9XZKrgPFklSCMOSr6yOJ6UatcwrqE3t0i3fh758J9VqSmRmM5g91Du8LJOTf3qF4Gf7AVny0HHf39RnopgmtqS7NdtinLoWCpsjJFsMLj5+TOcAK6v1jE3Ue2qYA2r0VJ0Fw6QMd9H8fxrIpc95CrMcIYsVQsGcmoI/G99w0scqSXI/e0DoUoLosrsaXNArXD/Ro23Gk6mBRpGCh8B4EYchQ+IzR8f+koy5YeNXl2KJubcPKOcWDkHcaLzihHk+4a0idrbxjKI+5dxKqw4u27t5LRSSjkmT6nDuJkPDNnfB2CK2J1ep5Xd8NZ16Z5KRDlBnhf918YecaXbnk5KfU33TjiAg/KgMiQ8ps2lzQHqoS5ELD4y7MNICpsNoMssS6Ew5E1H7Hva7h3MXdqiYiDwLtjh61KAK
 w7hKZ9Eg
 9/uYIBdSg5ofI+b8DCbYdr03XpJG+RcdGU0/QyIb0aWgWbU4oZDaK+C99dbu7E3hDTBTeDuIcG9Udzsp/rNh9WEf9b7fQEA4FAHfgAxHoPs/NjnF4YCuM0a1Qdv9g+lWg9zwOLEFu+3vg2/EdqR7F/dR4DNx7ALzzeUruXp31CmuHSwVmu0V6Hkhz9nbtVGXYXCTcSuyExyWt5LodoVsnlLQFi1A6DHmdRVfLZN6OWZ6ztxIH6NdmNR4nW9JgTuBe02zxO/fNLEcjI5YIUzQnEtuIKGVpN/w7Nw8s
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/14/26 07:07, Hao Li wrote:
>> @@ -4836,68 +4558,31 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
>>  	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
>>  		freelist = alloc_single_from_new_slab(s, slab, orig_size, gfpflags);
>>  
>> -		if (unlikely(!freelist)) {
>> -			/* This could cause an endless loop. Fail instead. */
>> -			if (!allow_spin)
>> -				return NULL;
>> -			goto new_objects;
>> +		if (likely(freelist)) {
>> +			goto success;
>>  		}
>> +	} else {
>> +		alloc_from_new_slab(s, slab, &freelist, 1, allow_spin);
> 
> IIUC, when CONFIG_SLUB_DEBUG is enabled, each successful new_slab() call
> should have a matching inc_slabs_node(), since __kmem_cache_shutdown()
> rely on the accounting done by inc_slabs_node(). Here
> alloc_single_from_new_slab() does call inc_slabs_node(), but
> alloc_from_new_slab() doesn't. Could this mismatch cause any issues?

Great spot, thanks a lot! Yes we should do inc_slabs_node() here.

>>  
>> -		if (s->flags & SLAB_STORE_USER)
>> -			set_track(s, freelist, TRACK_ALLOC, addr,
>> -				  gfpflags & ~(__GFP_DIRECT_RECLAIM));
>> -
>> -		return freelist;
>> -	}
>> -
>> -	/*
>> -	 * No other reference to the slab yet so we can
>> -	 * muck around with it freely without cmpxchg
>> -	 */
>> -	freelist = slab->freelist;
>> -	slab->freelist = NULL;
>> -	slab->inuse = slab->objects;
>> -	slab->frozen = 1;
>> -


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0637CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 14:48:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03EA68E0002; Mon, 15 Sep 2025 10:48:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F31C48E0001; Mon, 15 Sep 2025 10:48:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF98D8E0002; Mon, 15 Sep 2025 10:48:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C9DD48E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:48:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 78B841A04DA
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:48:56 +0000 (UTC)
X-FDA: 83891766672.21.2BC7B75
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id F28C240017
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:48:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=I9O0Sdmh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="AGoRAb/g";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=I9O0Sdmh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="AGoRAb/g";
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757947734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ap6nhA3/+gtoJHuI04qrOYozdQiOul79wCfN91QZhnU=;
	b=A2Usdooi1TB8k0OyXJ4tyML0+zGIefFw+jm49VMDxexhAPcLaSxdOTxNk174+J2yKymkyr
	dDp5YRpUZ9CkgdoOfBIvTcvsynZe9BpVu/ddkCxdlY4IHl84jhFShxCKeh3in589NDPSyj
	ag5KdgxNCn/bPzeD+I93kgW5EPqHDME=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=I9O0Sdmh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="AGoRAb/g";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=I9O0Sdmh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="AGoRAb/g";
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757947734; a=rsa-sha256;
	cv=none;
	b=oyWoXqeCPYHweSrljbtG5oaOlELc8r1vDgtHGORB08fifKhkBcNzDnhRDRKmhB3w9FieKB
	K+ALgKB8+vNm5iPsJ9zgPH23chH2IJOTYjUf3ipahLcy4xdnQGFxakvw3Zii7j8hy/M84V
	ZIX2Bv3gilCCvsYBuqukGektvywqcME=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 66A27336BF;
	Mon, 15 Sep 2025 14:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757947732; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ap6nhA3/+gtoJHuI04qrOYozdQiOul79wCfN91QZhnU=;
	b=I9O0SdmhFZfMKjoBS4nVHp/f3tB8zWPxrX3W8eGXWi0pPT7OaQJ0/eScpxX2VDv9dagloS
	IeTwmYd3gC7DOw4/s1o9ZMOYWH/aEqPQRISD8mxWU8WdayqQYiG38HZDf3UEZf9+ngRj1k
	1vuNzKlIcdYY2V5J3Wp+FhVK5dfLvy4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757947732;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ap6nhA3/+gtoJHuI04qrOYozdQiOul79wCfN91QZhnU=;
	b=AGoRAb/gfJHfSIapcuEOVPx31VTepMneWehKeaG/KwKsVvSNrdqJ2/73SmYoTmQLHvpDZx
	f//KV9sF4ZGndTAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757947732; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ap6nhA3/+gtoJHuI04qrOYozdQiOul79wCfN91QZhnU=;
	b=I9O0SdmhFZfMKjoBS4nVHp/f3tB8zWPxrX3W8eGXWi0pPT7OaQJ0/eScpxX2VDv9dagloS
	IeTwmYd3gC7DOw4/s1o9ZMOYWH/aEqPQRISD8mxWU8WdayqQYiG38HZDf3UEZf9+ngRj1k
	1vuNzKlIcdYY2V5J3Wp+FhVK5dfLvy4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757947732;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ap6nhA3/+gtoJHuI04qrOYozdQiOul79wCfN91QZhnU=;
	b=AGoRAb/gfJHfSIapcuEOVPx31VTepMneWehKeaG/KwKsVvSNrdqJ2/73SmYoTmQLHvpDZx
	f//KV9sF4ZGndTAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5176D1372E;
	Mon, 15 Sep 2025 14:48:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wZ1oE1QnyGg9aAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 15 Sep 2025 14:48:52 +0000
Message-ID: <ba26b2e3-0f90-442d-adba-af04829b0f3e@suse.cz>
Date: Mon, 15 Sep 2025 16:48:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/6] slab: validate slab before using it in
 alloc_single_from_partial()
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250915-slub-slab-validation-v2-0-314690fc1532@suse.cz>
 <20250915-slub-slab-validation-v2-5-314690fc1532@suse.cz>
 <aMghx7WTJP9NHoNe@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aMghx7WTJP9NHoNe@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F28C240017
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: bfhro7erfdek4erq4j4hchpds17tzfpp
X-HE-Tag: 1757947733-486360
X-HE-Meta: U2FsdGVkX18eeDUywicRP0ov6SklJ8BhytyGoDD4iiOS+vlrdWbF3O31rWV7klvsKeFEYWfbs/joHSn/q3ibHv88f59fvLOjlzqaJGIwU2LWfeu5104Wps3xrPToaai84D8NWQzMRVy2+PCytHdtehnFBhiWgtnLj8DoLQU9ns0W+8Fvb5i3m4vH5b4coo3XSJ2MqlDZGY6zAH1gephjxmZvPoEbeBy4ifqaQlmO3WbP40EabC/OEcpPbcU75MyumUU7VDWimKgtTlK8hmstDYBlAQ8nk6g1zFJeSPQ2CEMqX2b1vTlueK5zESGGVuO2CNwco/c7ntgJbrr2OpfDQs7bqr96Hzv7e3oeeCg1Xn/Kz23ABaOTh7md3B1kej0WjIpLjThgGp0hXtY8Naf66id/XQGcF7FGsrW1uQgQJDvEkgzMlVPLM+5EH/URO6WGcYNrFEv4hj2d9qdy/RNqZ2oLzeDiYxylXMQsW3LuLCCYofQTwpX0u+zbox803fwYJyGP3BLRVQ1JvqGfu/w1AKGWGxKdzESi6cTl6cVbQWY1OLpL2pmASB5T6lQQ8FQLYHgkAx9V49GXGkO84uxyU+qRm6FoQSzPUBJkL+BZOIDoVOYwqsA5CZU1DaaUqOQI+WxCgLV4myDOfL1EIOF3MIYk2kHVYq45Mfkr5lSqBTIbwss7serAQ8DVz2ZTGEmYanr957avSMPL5u7O6fXciFL0MgMRb0EcKtbvhvM3apmgAcl1pjeFvgIIP2GpKqC9C+kAYr8xz16B8EsnrGmo40ClRsESlNDC23MqfQQ8qWNK1jXHjSCwQ2cMsb49E0MOojxxAfq0HM759STVFNoeRzleyC/Vk9Go6I3z5rjHXJPHPYtxb6SxPF/aLC6SrlBt4RCaG/z7jc0ZK6zrv6B3FoZ556hPZ/4VmtMFpRy/6sLYs7Wy7SJZm+VJ45s3n8yrioylCuNetCQhVQbgnJQ
 3/eYdX9m
 2+Fr2ZaHMuDIBhUW+9ALUTRvasdtD2ZQFpkzMznY6T3yxe+YGLfcXChyBW8g2M1cGBfsSuhab0cs964QlxcMWjFKlcoVDG6a/SBEYznJaEhBNsNCCTPmlXswkRZLc6GXA06n74z2bImJnIG6gtdrR3P5fLAFV2H4gzz83YlRnnRHY6Kf8FGRIgWAPZwdJmsxHZ6QzcsHuye+b75zMsgusXkAiTcs1ZWW/a+umpfv4c5OdAQ3T6YdOokLxfJUdUIjwnW5kB2QvC3//cD6nGiAIjvLTk8k6VqbEFn3xAS9AtcJYPBGwQHc84FMRk+2BcO5csrRrexxECeBriueGR2XlLXprW+P/zIx/p3pM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/15/25 16:25, Harry Yoo wrote:
> On Mon, Sep 15, 2025 at 03:55:12PM +0200, Vlastimil Babka wrote:
>> @@ -2825,13 +2821,21 @@ static void *alloc_single_from_partial(struct kmem_cache *s,
>>  
>>  	lockdep_assert_held(&n->list_lock);
>>  
>> +#ifdef SLUB_DEBUG
> 
> I'm sure you meant CONFIG_SLUB_DEBUG ;)
> 
> With that adjusted, looks good to me,
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Doh yes, thanks a lot :)
>> +	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
>> +		if (!validate_slab_ptr(slab)) {
>> +			slab_err(s, slab, "Not a valid slab page");
>> +			return NULL;
>> +		}
>> +	}
>> +#endif
>> +
>>  	object = slab->freelist;
>>  	slab->freelist = get_freepointer(s, object);
>>  	slab->inuse++;
>>  
>>  	if (!alloc_debug_processing(s, slab, object, orig_size)) {
>> -		if (validate_slab_ptr(slab))
>> -			remove_partial(n, slab);
>> +		remove_partial(n, slab);
>>  		return NULL;
>>  	}
> 



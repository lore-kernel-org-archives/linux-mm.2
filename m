Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69687CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 10:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7AE08E0013; Mon, 20 Oct 2025 06:21:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B52818E0002; Mon, 20 Oct 2025 06:21:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1A598E0013; Mon, 20 Oct 2025 06:21:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8CE6A8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:21:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3D30C1607C5
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:21:10 +0000 (UTC)
X-FDA: 84018099900.06.40A76F6
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 996C91C000B
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:21:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lN2mc2KO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UJMIOlIQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=T0qJbGFi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hkAfbvCP;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760955668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jUAozH+dPZUUrBmwzJTPk2StlCwJpqlVY9Dw4T6M7g4=;
	b=ojYr9yf/daZYtmXJpmyJn4lFF3PbQ2PbTL72IWI26bUxjMI/RLcgF+VVZ9iZ0Ym7g/n3kw
	6Lq0lIoJfURN0gOwNfkLRtJ9g4NRcUkzDqq00To56m1V2X+s2j0s1XhS1864swVksS+HVx
	Anz01Zq/3Qs1Wy8PXOLeOLMhEN+YNJA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760955668; a=rsa-sha256;
	cv=none;
	b=wnDjfecdqSEG2W9EWmvOZoUn8wXDOuRPlou2xjqBirZhcg6kWyK4tU8sroYoCFB/WUv7+t
	PU6aN/SxyBg+bitK+n1HleIqyIOsgGPs32twXCnk1QZsWCk7bc52ijve1za94AULKBCC+Q
	opZunVFSjMqZn2AkdvDLp6d8wtlf5+A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lN2mc2KO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UJMIOlIQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=T0qJbGFi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hkAfbvCP;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C86DA1F38F;
	Mon, 20 Oct 2025 10:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760955661; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jUAozH+dPZUUrBmwzJTPk2StlCwJpqlVY9Dw4T6M7g4=;
	b=lN2mc2KONJR7OIEadeeVC34Xb3W5qmc9KJht0YTFhIu2mxkS2gJlP0MUkxSmucNZFHWMtR
	EgPz5BP2CTKqODpLptN+7zHMlvjLOquIIVaFf4NRUUIp6Bf9hnQFJ9AnFMl+isET+64BQT
	KzuRPFBgRNm3FsY0VtWlh3VsBfgPuUM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760955661;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jUAozH+dPZUUrBmwzJTPk2StlCwJpqlVY9Dw4T6M7g4=;
	b=UJMIOlIQyctsRp5TJnuRD3Dma1n6/DZj8lV2glNd5UZ2brPQ8PbConWbgtMh81788a6Jjr
	DdfMrrosgL15FmDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760955657; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jUAozH+dPZUUrBmwzJTPk2StlCwJpqlVY9Dw4T6M7g4=;
	b=T0qJbGFi10XyZt+NCDaMVl8kIrYLt48atJhTHhQioKzTMPT1Wj6Cgk1JHPaGTgMqhJO9/s
	0p/AS/Rx7fJT2g9EkTMXRcCLmWG3js0AVqkdo+BcpbYAO83FZVgFiCqWvH2WFZsuRYWthB
	KOdc7Ti7DRDroev6GUskK2iz4MBKrFw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760955657;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jUAozH+dPZUUrBmwzJTPk2StlCwJpqlVY9Dw4T6M7g4=;
	b=hkAfbvCPDP2GLehs9wd+fnGsOElSSDBtXtgyWci1Vyk0+wIBgpjqqOptoGY7Jf3fUMjiff
	kYJaPDsnH4S8HqDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A39A213A8E;
	Mon, 20 Oct 2025 10:20:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AxfgJQkN9mi1NwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 20 Oct 2025 10:20:57 +0000
Message-ID: <da90b3a5-a256-49f7-a640-6585f2cce340@suse.cz>
Date: Mon, 20 Oct 2025 12:20:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: Avoid race on slab->obj_exts in alloc_slab_obj_exts
Content-Language: en-US
To: Hao Ge <hao.ge@linux.dev>, Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hao Ge <gehao@kylinos.cn>
References: <a9ca7cc6-f4d1-4fba-a9aa-2826b9a604bc@suse.cz>
 <8F4AE1E9-7412-40D6-B383-187021266174@linux.dev>
 <7791b2b8-5db8-458c-89e2-49a0876c13a3@suse.cz>
 <CAJuCfpEWGujJe3JOjmiKLOUr49Hw_3smT6iatY7kaRBPPCWpNg@mail.gmail.com>
 <3efc2a94-54c7-48a8-a804-c231d06b5ed5@linux.dev>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <3efc2a94-54c7-48a8-a804-c231d06b5ed5@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam01
X-Stat-Signature: nuzhwiaeotbn7mddo8ip4q1fqeu83te4
X-Rspam-User: 
X-Rspamd-Queue-Id: 996C91C000B
X-HE-Tag: 1760955667-2483
X-HE-Meta: U2FsdGVkX1+XhuosRRHRSnMArOcD5hpl5dyRUO0I1lPAh3r8ZrC8+Q3dU13w7dC3jq3h0fh5abBRxdnyMC6GnkhlBlDhwSZANS42nuRrg1omok6/sxYXbljiTyFioHvFVNG54jqNmtQYxvJjruyK/39fevY8eVV1VM0F/rxpezkIGip906GuUeQ1lnvnn0TrhEHNJt8xRVZ6/5hd6uybQeDfJad4lnTvtGPZQQ2K7+jj6OoedQt8sXVnuY7if/pagQ9rxHA6cBJCO+6dJEBN6vg7L+A7W7dL+U4NqMf4hLecvwOT1ixD6cBP+VBUc5zUd2r5i8GtPI1oDZ9b+TuKOFCLCs0lEAjoWUqKmSY9pGiZUDg9o/H1SD9k6Kp1X2qrRP0kTL3evTf/A5CeMlHnpIwCLwomBpGGf9obvpfT6/d7pcBBGVUw751fUEUd8bvbX66RRr07yl5A9JDJVNMQo65WrwHNmBjyjMwUFYsPuhHRUEuS1oW8zCIn4PQtTRtutxuf8oWl8wrl+6GkGGvpwSgEAmho7374J9Jl2InqmEekatCLf94NAgyRFTW5oM+qmaRGqhOp9XSz4O8dmr6jdQIg3hEE6suOQpP8ZVd6oDD+4JwuyfyVGWE1pKT8adngkVo/inMsLdLY4WOCER8qGwcPdiEo8y+YG3/Yqk5KIS9rtVU4PAAZVW57VBNyjdipqpWj+QhUi3lGUsbMqZFLh/sk+CayHGm3tUGU2a6jFoPoeZOLm5uBwerrlZ110fiAEXx7KgaqpPjiO7CM6IkObHzXnp7PqX4OTC7TXVzA9667F1XiGuCtjVotXIUPxG2XeixdluzRiaVGGeyO2Ys4OQRla63H89qmkbTNzYKKj8/oi5AqKEb9lWtA4ZO787ZJ46KaxRHuR1etzxXeKKjQz8pGIaG4JFG1sw5OgsBF53ltztnbO8Nu3A29/Vwbj7NyzvYwnS9X51pH8V3LyvA
 eA1/o1/q
 VF6LJs0vn09c7dQrc2abQXHYOlUsGp8n0UaIsSb/RwXzxvrTDzd3y9a2On1WbOthsmqYNLvlX2U/6ByO3GLEe62rZ2CqgixWlvrfo19/eDEi9Sa72bENmQcfU+AHgZofFx9h76D8tTUvcKFpbSprV5KO3pOfVM7/z8z9DkXaORREFS7o1ydfGGucu/mmx1z6ceatOOpG2OdFuxdksb4v/tS0K8LcuoAoDlpbEtUbRRJMQN2asiYrn4bLhqq3a8/BekGWJ8wDCIXhuSge93Ec6xreJSVzgKmv206gXDP5lLVaYgkBOwbQ/Dt6oj3CaS6tbk93rGlhl4N6LW2Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/20/25 04:01, Hao Ge wrote:
> 
>> I think retrying like this should work:
>>
>> +retry:
>>           old_exts = READ_ONCE(slab->obj_exts);
>>           handle_failed_objexts_alloc(old_exts, vec, objects);
>>           if (new_slab) {
>> @@ -2145,8 +2146,7 @@ int alloc_slab_obj_exts(struct slab *slab,
>> struct kmem_cache *s,
>>                    * be simply assigned.
>>                    */
>>                   slab->obj_exts = new_exts;
>> -        } else if ((old_exts & ~OBJEXTS_FLAGS_MASK) ||
>> -                   cmpxchg(&slab->obj_exts, old_exts, new_exts) != old_exts) {
>> +        } else if (old_exts & ~OBJEXTS_FLAGS_MASK) {
>>                   /*
>>                    * If the slab is already in use, somebody can allocate and
>>                    * assign slabobj_exts in parallel. In this case the existing
>> @@ -2158,6 +2158,8 @@ int alloc_slab_obj_exts(struct slab *slab,
>> struct kmem_cache *s,
>>                   else
>>                           kfree(vec);
>>                   return 0;
>> +        } else if (cmpxchg(&slab->obj_exts, old_exts, new_exts) != old_exts) {
>> +                goto retry;
>>           }
> 
> Agree with this. If there are no issues with my comment above,
> 
> I will send V2 based on Suren's suggestion.

Great.
> Additionally, I believe the "Fixes" field should be written as follows:
> 
> Fixes: 09c46563ff6d ("codetag: debug: introduce OBJEXTS_ALLOC_FAIL to 
> mark failed slab_ext allocations")
> 
> Am I wrong?

I think it was safe before this one:

f7381b911640 ("slab: mark slab->obj_exts allocation failures unconditionally")



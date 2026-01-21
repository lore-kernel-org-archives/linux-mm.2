Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D90BD262B0
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 08:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAB5E6B0005; Wed, 21 Jan 2026 03:12:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2F846B0088; Wed, 21 Jan 2026 03:12:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E6DD6B0089; Wed, 21 Jan 2026 03:12:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7A9D36B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 03:12:40 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1AE3313BBD0
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:12:40 +0000 (UTC)
X-FDA: 84355254480.15.8525CC2
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9BEB280005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:12:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="kqJ/CP+P";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YvJgkb5U;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ienWLs4A;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Q5L4a/06";
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768983158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9oU749SDo5J3PWFW4FxuIHDE7h+Fsbj9bTexCfG3H1s=;
	b=BKpxPZaJEv7TGC4KVlYIypoaR14uekM8SSDJlTeWYdhUM6ynx7zYPk+ahXyK5qfEGceNc3
	hGM8eOQQGv3/PYExIpnOtAAGieuRIOghI75/kjO/01GgVfJucaCZu+IN3Vut3CG5BkmgWB
	qMUHgrV3tk8o+ebKVXw5KKvwXw+VnkU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="kqJ/CP+P";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YvJgkb5U;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ienWLs4A;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Q5L4a/06";
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768983158; a=rsa-sha256;
	cv=none;
	b=5pUK8H0uUcFsCUZElCRsIEC+/dXKwMzOJf/V4Uokd+JigrUdmhIKbi+ysy6oHvm2AIyYiR
	s7jQaMeIFrTDmVOdRRJutnFPGe8mddQF8lhlRjxPu21jwnyb0DKJO439Qm+Cem4aZYP4zE
	9m7BRq03/LvTwibCG+jS4SsUlIg4ivA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 46A9933689;
	Wed, 21 Jan 2026 08:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768983155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9oU749SDo5J3PWFW4FxuIHDE7h+Fsbj9bTexCfG3H1s=;
	b=kqJ/CP+Pktx6e602m6cvlKbPgAVg9VP9RrujSSl+jZqMT3VMQfZ8qfEulidEVwkLVA2y5+
	mA/kLM9hwKszqPKMyaGHRRKoVJyEX7AxeY43I8V4NxZx+6H00JguOMTbb2/h7avwtrm5Rh
	8mkThsKwJ3xItMwsv+7gUogQ0oJo8q4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768983155;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9oU749SDo5J3PWFW4FxuIHDE7h+Fsbj9bTexCfG3H1s=;
	b=YvJgkb5UXrfzIg+6PQt8h4uOcE57/eAeQPFVrh3veDutRvH5WJUCBv20XMk2UUhjnkXTZN
	Vb1dNV2GZAFWaVDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768983154; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9oU749SDo5J3PWFW4FxuIHDE7h+Fsbj9bTexCfG3H1s=;
	b=ienWLs4At+iLfuIx84Gz88i5wdkz4QOzFeWfZGVtu0d3kyJRqFlTOouISNtq23x3AFkBC9
	YBilL56bYYVsokkVlO/Y6p6AB67ufm6MpY1aGdZ3/JhmKpa42lUqWHXg5FS6Ewtidou+L/
	hUz63gRsfCV82OqI30pf7GO1/SNLHn0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768983154;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9oU749SDo5J3PWFW4FxuIHDE7h+Fsbj9bTexCfG3H1s=;
	b=Q5L4a/06+3mu6X8TEe2kRFn2tOnQtTAsGGPoPy4/uVqJYnCP2h7o3OXUHe+VMrWHumL4zZ
	WEMZaow4O7jlcyCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1D5983EA63;
	Wed, 21 Jan 2026 08:12:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LzYMBnKKcGlibgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 21 Jan 2026 08:12:34 +0000
Message-ID: <89a3304d-ee46-4498-8a04-fe48d4644b75@suse.cz>
Date: Wed, 21 Jan 2026 09:12:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/21] slab: add sheaves to most caches
Content-Language: en-US
To: Breno Leitao <leitao@debian.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
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
 <20260116-sheaves-for-all-v3-5-5595cb000772@suse.cz>
 <aW_NK2NXVgtuzCVH@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSBWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBzdXNlLmN6PsLBlAQTAQoAPgIbAwULCQgHAwUVCgkICwUWAgMBAAIe
 AQIXgBYhBKlA1DSZLC6OmRA9UCJPp+fMgqZkBQJnyBr8BQka0IFQAAoJECJPp+fMgqZkqmMQ
 AIbGN95ptUMUvo6aAdhxaOCHXp1DfIBuIOK/zpx8ylY4pOwu3GRe4dQ8u4XS9gaZ96Gj4bC+
 jwWcSmn+TjtKW3rH1dRKopvC07tSJIGGVyw7ieV/5cbFffA8NL0ILowzVg8w1ipnz1VTkWDr
 2zcfslxJsJ6vhXw5/npcY0ldeC1E8f6UUoa4eyoskd70vO0wOAoGd02ZkJoox3F5ODM0kjHu
 Y97VLOa3GG66lh+ZEelVZEujHfKceCw9G3PMvEzyLFbXvSOigZQMdKzQ8D/OChwqig8wFBmV
 QCPS4yDdmZP3oeDHRjJ9jvMUKoYODiNKsl2F+xXwyRM2qoKRqFlhCn4usVd1+wmv9iLV8nPs
 2Db1ZIa49fJet3Sk3PN4bV1rAPuWvtbuTBN39Q/6MgkLTYHb84HyFKw14Rqe5YorrBLbF3rl
 M51Dpf6Egu1yTJDHCTEwePWug4XI11FT8lK0LNnHNpbhTCYRjX73iWOnFraJNcURld1jL1nV
 r/LRD+/e2gNtSTPK0Qkon6HcOBZnxRoqtazTU6YQRmGlT0v+rukj/cn5sToYibWLn+RoV1CE
 Qj6tApOiHBkpEsCzHGu+iDQ1WT0Idtdynst738f/uCeCMkdRu4WMZjteQaqvARFwCy3P/jpK
 uvzMtves5HvZw33ZwOtMCgbpce00DaET4y/UzsBNBFsZNTUBCACfQfpSsWJZyi+SHoRdVyX5
 J6rI7okc4+b571a7RXD5UhS9dlVRVVAtrU9ANSLqPTQKGVxHrqD39XSw8hxK61pw8p90pg4G
 /N3iuWEvyt+t0SxDDkClnGsDyRhlUyEWYFEoBrrCizbmahOUwqkJbNMfzj5Y7n7OIJOxNRkB
 IBOjPdF26dMP69BwePQao1M8Acrrex9sAHYjQGyVmReRjVEtv9iG4DoTsnIR3amKVk6si4Ea
 X/mrapJqSCcBUVYUFH8M7bsm4CSxier5ofy8jTEa/CfvkqpKThTMCQPNZKY7hke5qEq1CBk2
 wxhX48ZrJEFf1v3NuV3OimgsF2odzieNABEBAAHCwXwEGAEKACYCGwwWIQSpQNQ0mSwujpkQ
 PVAiT6fnzIKmZAUCZ8gcVAUJFhTonwAKCRAiT6fnzIKmZLY8D/9uo3Ut9yi2YCuASWxr7QQZ
 lJCViArjymbxYB5NdOeC50/0gnhK4pgdHlE2MdwF6o34x7TPFGpjNFvycZqccSQPJ/gibwNA
 zx3q9vJT4Vw+YbiyS53iSBLXMweeVV1Jd9IjAoL+EqB0cbxoFXvnjkvP1foiiF5r73jCd4PR
 rD+GoX5BZ7AZmFYmuJYBm28STM2NA6LhT0X+2su16f/HtummENKcMwom0hNu3MBNPUOrujtW
 khQrWcJNAAsy4yMoJ2Lw51T/5X5Hc7jQ9da9fyqu+phqlVtn70qpPvgWy4HRhr25fCAEXZDp
 xG4RNmTm+pqorHOqhBkI7wA7P/nyPo7ZEc3L+ZkQ37u0nlOyrjbNUniPGxPxv1imVq8IyycG
 AN5FaFxtiELK22gvudghLJaDiRBhn8/AhXc642/Z/yIpizE2xG4KU4AXzb6C+o7LX/WmmsWP
 Ly6jamSg6tvrdo4/e87lUedEqCtrp2o1xpn5zongf6cQkaLZKQcBQnPmgHO5OG8+50u88D9I
 rywqgzTUhHFKKF6/9L/lYtrNcHU8Z6Y4Ju/MLUiNYkmtrGIMnkjKCiRqlRrZE/v5YFHbayRD
 dJKXobXTtCBYpLJM4ZYRpGZXne/FAtWNe4KbNJJqxMvrTOrnIatPj8NhBVI0RSJRsbilh6TE
 m6M14QORSWTLRg==
In-Reply-To: <aW_NK2NXVgtuzCVH@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9BEB280005
X-Stat-Signature: hnrw1mnqbpdpigbsdg3dtwtz887o9rmd
X-Rspam-User: 
X-HE-Tag: 1768983157-564319
X-HE-Meta: U2FsdGVkX1+9BdCkdtlYsv1uaR5NP31qm8wn1vTa8jyGZDhsogd7UoYhX390dJktDlVM7dTEi2e9/pUQ/CXLb9PT+9pTet9BtP/S64tIsoxJbLb2CBc8cKlio6a06k36IoOFxLQxxi87dt2teo1J/ZjxBkL/wRE3YEClk0egL0LArknfSIhAyvLgMfYkePmte0wW7qpb2fN8pNZLxMtalOU8eIOJn0mxIcn/CbznIe0nWl3t9LKgTgZu17l1+CbJ/tIabKjaF5zNtmuoLNA0ZNfHrszgSQ/0yxYOyN7whh3dMmDhimTZsq71ffftTP61rUohYmM4kuOKOnbcGIHAnAwgQd82gEiOBdB0WdUVfzh2nA+7ucBJU1IDo11Qj2iMGBBc0fyF7okxXAsXxmnEdGQ/LeSEJUWhQ7QEvLpm4VLYN/6hH+XHabRbsvADAQgd73GSyEBSFO5AMaNOQ21vae8UYl5zMg7FpfnslstdfjjAyy2l5qCk3zA/Ghf3zEv72vI/FQ5bbpbUoIyAiJKAw1xUkNt0JsC4PxSI8tdgad9Mjsy9LLY+k0C9Tmna8aLwXeqCeM/uNJY/4r57pmeSAz24bXs24L/PZYo0larIDKWYvlT7+Sueug0GSjJSm2UKYPAB5d6YiG7CiH5+tOAta5Osv6zwJsHR6z2/xojh71m8Zd+bbalH3fCFRbNmew7LAYJU9xmBDFRFRRSFLONP6NJjjta7zP8lri8Lda33dVyagyuPehcLVyR/jzAUFAZFCG1aCofhVTpH0SHHV7Du+n1LClLnrd59lD+vQw4ElDrMVjtNQGNEF5Dfl1oqyurpkazbyHJGmkU7dZADC6dWyvXrCtP7rgwq2lyl3zlqT7+mwl/3vdHu4KAMfiqY9E4NJvQl1es0Pnw3Nun5cnvoB44F57wCiDxqCd23VoMcSNL72eZ2JkedydSwwnzY49EYk4OuoJx7lW5ueESIU+j
 wfmooFsB
 h4NZjRiSxixP8a+/hn3WhHm/uejF2XY/DH8IJ+H3vhsAK/NifEg0VI7v/rexnBA6efCbRgbSV9J2MtGOUhxN0/f5EavNsr5AFNwNXhjK1MdBkSHdgAr25tmYYOg+xH9uvsPtcu0D/adEJLhonJ5YjzY3md/X/sGsSexmxCvXbu8coAmAIN/+XurUdTEwdZmLBid92gSbAuCPbh6hsidAZ8lrde8RSnL03sZdllteqLUwBS6ESdVN4eemID7S8XcFPyNksFjYq3sIFVl6sTZiBJtB75RqfslM4lKwY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/20/26 19:47, Breno Leitao wrote:
> Hello Vlastimil,
> 
> On Fri, Jan 16, 2026 at 03:40:25PM +0100, Vlastimil Babka wrote:
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -7863,6 +7863,48 @@ static void set_cpu_partial(struct kmem_cache *s)
>>  #endif
>>  }
>>  
>> +static unsigned int calculate_sheaf_capacity(struct kmem_cache *s,
>> +					     struct kmem_cache_args *args)
>> +
>> +{
>> +	unsigned int capacity;
>> +	size_t size;
>> +
>> +
>> +	if (IS_ENABLED(CONFIG_SLUB_TINY) || s->flags & SLAB_DEBUG_FLAGS)
>> +		return 0;
>> +
>> +	/* bootstrap caches can't have sheaves for now */
>> +	if (s->flags & SLAB_NO_OBJ_EXT)
>> +		return 0;
> 
> I've been testing this on my arm64 environment with some debug patches,
> and the machine became unbootable.
> 
> I am wondering if you should avoid SLAB_NOLEAKTRACE as well. I got the
> impression it is hitting this infinite loop:
> 
>         -> slab allocation
>           -> kmemleak_alloc()
>             -> kmem_cache_alloc(object_cache)
>               -> alloc_from_pcs() / __pcs_replace_empty_main()
>                 -> alloc_full_sheaf() -> kzalloc()
>                   -> kmemleak_alloc()
>                     -> ... (infinite recursion)
> 

Oops.

> What about something as:
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 26804859821a..0a6481aaa744 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7445,8 +7445,13 @@ static unsigned int calculate_sheaf_capacity(struct kmem_cache *s,
>         if (IS_ENABLED(CONFIG_SLUB_TINY) || s->flags & SLAB_DEBUG_FLAGS)
>                 return 0;
> 
> -       /* bootstrap caches can't have sheaves for now */
> -       if (s->flags & SLAB_NO_OBJ_EXT)
> +       /*
> +        * bootstrap caches can't have sheaves for now (SLAB_NO_OBJ_EXT).
> +        * SLAB_NOLEAKTRACE caches (e.g., kmemleak's object_cache) must not
> +        * have sheaves to avoid recursion when sheaf allocation triggers
> +        * kmemleak tracking.
> +        */
> +       if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
>                 return 0;

Yeah that should work, will do. Thanks a lot!


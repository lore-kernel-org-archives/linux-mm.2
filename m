Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 658E2D4A604
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 07:32:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A17276B0088; Fri, 16 Jan 2026 02:32:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99A1C6B0089; Fri, 16 Jan 2026 02:32:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8514D6B008A; Fri, 16 Jan 2026 02:32:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 72BB56B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:32:08 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F2EA51ADD7A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:32:07 +0000 (UTC)
X-FDA: 84337008294.22.A94DAC9
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 06036180005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:32:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="hL/jJS0K";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=VbiDfBAZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pWRLH+sp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yYaTRxrR;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768548726; a=rsa-sha256;
	cv=none;
	b=eEPnmpykwipIcHOPiGqHlzQvoNODb3LjTjaHuTXh/2eBayQmklXetymqY5z8ukQ9fPvC8k
	Vmf+14dL9Cawf5TF2dvEvxtw9n3kP+v1JLk0j2SM98A9EcP1UM6448gzoeM3/sVPmfWnPd
	yjY2/GjBgLYtRJ2Bu6FNvfq7carzPcU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="hL/jJS0K";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=VbiDfBAZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pWRLH+sp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yYaTRxrR;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768548725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J2wMFYYHoLIThQowW1m8IBwEmgJ9j6LTflF8fZXK/As=;
	b=5Kjj9AaAPxBCAGXIHsTPGZK+m6qWq2ZQxpEKsDMmXsf5l4h+TkkdxUABXwAIvodVISXhJB
	jTI9YakckKNaiYVCDsL4VHoMbVFUCBCalmjCVz3+ZNOJUmZdJkTGyYoucGwTIc3uFQoPTN
	1yah7QCcDW6ZNIxisihVeF74KF3f6wM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9F9D23368D;
	Fri, 16 Jan 2026 07:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768548722; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=J2wMFYYHoLIThQowW1m8IBwEmgJ9j6LTflF8fZXK/As=;
	b=hL/jJS0KTC2jbJHdoBF//DpqTjKeB8QXjauyPkmUBdYycD18rietaH1qXesIeuj0pOGXpU
	3gKFjCDN7+209wweEh2lwBfZXosK/72g3eqaEP1GJqgoazLFlcEBia4sy6I0NL5u41ivbT
	BiLlFGi6KE8iLmswGYdSNA3244LghV0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768548722;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=J2wMFYYHoLIThQowW1m8IBwEmgJ9j6LTflF8fZXK/As=;
	b=VbiDfBAZit/VibmjpApls2s/VKBpsq4qZV66Pe5cjvQpfFea9IK2vi9Gu2HOey/KyHHWIE
	pNfzjyCdzdgyL/Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768548720; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=J2wMFYYHoLIThQowW1m8IBwEmgJ9j6LTflF8fZXK/As=;
	b=pWRLH+spXqtExwaW6Va5t+kWsGQFZancyDdB1ooHaZyGXsTmq1f4ToFA6/rHxyehQnfpKd
	oHQV71Pwj/mfetNBS5krPZqeC1pjwWFTkpO8qJGnXxhmcToDJQ929heAup+YslyoLQ6/eS
	hKKmeAZgzxaSZ/yMIefQ7/+kCW9Iz+Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768548720;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=J2wMFYYHoLIThQowW1m8IBwEmgJ9j6LTflF8fZXK/As=;
	b=yYaTRxrR3IzxX6QikSaiombwVAayWwW/4zyaAQLMXXw0jSwZPZXKWx7Tk36yzCJ98pl+gF
	7h1SE9+poq0AfCAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 788233EA63;
	Fri, 16 Jan 2026 07:32:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jQHIG3DpaWlfTAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 16 Jan 2026 07:32:00 +0000
Message-ID: <bb58c778-be6b-445e-a331-ddaf04f97f0e@suse.cz>
Date: Fri, 16 Jan 2026 08:32:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 08/20] slab: add optimized sheaf refill from
 partial list
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
 <20260112-sheaves-for-all-v2-8-98225cfb50cf@suse.cz>
 <38de0039-e0ea-41c4-a293-400798390ea1@suse.cz>
 <kp7fvhxxjyyzk47n67m4xwzgm7gxoqmgglqdvzpkcxqb26sjc4@bu4lil75nc3c>
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
In-Reply-To: <kp7fvhxxjyyzk47n67m4xwzgm7gxoqmgglqdvzpkcxqb26sjc4@bu4lil75nc3c>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: w9ho9b8kd5fiw6hxwch49hxtxdt95796
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 06036180005
X-Rspam-User: 
X-HE-Tag: 1768548723-437008
X-HE-Meta: U2FsdGVkX1/egLQzCIPBoyxKGv0JZ+m87QLkLXD/PQeQImL7zrTagIX45tMsPqX9EvfDir3M6xq0ye7tF+MgDai2Jjfq7DgjhlHokOYX0xEk/qqEYI1bMEVCYGqc52caLBKcl00UJSGp7Kf3uLp3iP6xkK4ni1cb5+XMutFS6MbF19rx+6ftTOLtsK0e84flxn6c78KLgkloz7aTen/nkIx/dNsY9wsULOtuM8l5TRV57ObR4My+t9XrUD4fLgRtYZ8puDcQ+LLijZUWxsKYydWKAVCNPkVRNjrQFCUgT8zi71tq1wTFujVl3ZkejFwB1JFMvnmVmfo9kT61jjW7zkcg5Ym8hZxprcntgEevuDaiGMc2SWYpOIRnr6g3DcQbm0U1JctRAMt0xsugX3vkuqRv+6duiYeN+0ZwC2J614oyJn7LdpDPsfyy1HmElIDA8E36/KtGAz78HmaFkcM1OOKoSS+BUAiwP3ThPKFF+6gP5H2pYIBWero58PlgFANoUf696qF74CeyWAEhpWh12RUYhfoEcSj/ypJTntCWAJXilxYAmO8j7r8IjKBmxLRNqfLjU8YOf2HzmO5x9HH86nFLvk0hl2wdDsPcn9UNHRjroGGWd27JLRU9SwGE2BlFAppgfEApkxF4uo2xdbsqT2Zt6yaq9M12iK/LenIViLWiwiEbc7mgL0Zx9r92yAbRMl8pgQrp8wjhyI9BkmmLf8xUbGlbIbc5SZyRFxZWG18cXhmUiXOOhS2iNwFed39fKXqleRh0VdvKvGALHe2jBPtX4lE/3nbOAbak9n5YE++4M1CyqU71zn2fwjQzhA4pEX5VlwJwkXwF+3Ut1ETkADmhslMgP5fkiiLAnt6Hs/Gs+ATe4KCmmLsLiJhKc9eN7DjSBCRF+dXx/DjyoUXSLIvxURP3Uh47/sjHfhlJqnHNa+GL+TcPOlVg/wL0Zda+ZASldO8Us3mlLRR0HMc
 0oxHOssG
 fb/vlqiUIFFcLs4iRfA/NZexbbhDGUubFHQGV/urCPMtP6PDQQlCicNj7gyuCMg3vdBadKpdlR0ZT7aQOKiAJJ4k5PCcKdtGIucAxW4zuWpp8xnHjjC1fb8cYmlKsbZc68YGMAWjkcymh6opz9GH5btKehpA3XxJ36ikINYL6vF3ro/Y1rM9gQ2PdXplKz8IOUNYowVdP6y7h9fxKRNMEHE8XB6RH6oJ2HKq1YSorf5ED22fctwjRwLGWgV0+Fe7Lx2qWYpxyWFWSE1e9zFuT4NCvWogX3+o6L/gR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/16/26 07:27, Hao Li wrote:
> On Thu, Jan 15, 2026 at 03:25:59PM +0100, Vlastimil Babka wrote:
>> On 1/12/26 16:17, Vlastimil Babka wrote:
>> > At this point we have sheaves enabled for all caches, but their refill
>> > is done via __kmem_cache_alloc_bulk() which relies on cpu (partial)
>> > slabs - now a redundant caching layer that we are about to remove.
>> > 
>> > The refill will thus be done from slabs on the node partial list.
>> > Introduce new functions that can do that in an optimized way as it's
>> > easier than modifying the __kmem_cache_alloc_bulk() call chain.
>> > 
>> > Extend struct partial_context so it can return a list of slabs from the
>> > partial list with the sum of free objects in them within the requested
>> > min and max.
>> > 
>> > Introduce get_partial_node_bulk() that removes the slabs from freelist
>> > and returns them in the list.
>> > 
>> > Introduce get_freelist_nofreeze() which grabs the freelist without
>> > freezing the slab.
>> > 
>> > Introduce alloc_from_new_slab() which can allocate multiple objects from
>> > a newly allocated slab where we don't need to synchronize with freeing.
>> > In some aspects it's similar to alloc_single_from_new_slab() but assumes
>> > the cache is a non-debug one so it can avoid some actions.
>> > 
>> > Introduce __refill_objects() that uses the functions above to fill an
>> > array of objects. It has to handle the possibility that the slabs will
>> > contain more objects that were requested, due to concurrent freeing of
>> > objects to those slabs. When no more slabs on partial lists are
>> > available, it will allocate new slabs. It is intended to be only used
>> > in context where spinning is allowed, so add a WARN_ON_ONCE check there.
>> > 
>> > Finally, switch refill_sheaf() to use __refill_objects(). Sheaves are
>> > only refilled from contexts that allow spinning, or even blocking.
>> > 
>> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> 
>> ...
>> 
>> > +static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
>> > +		void **p, unsigned int count, bool allow_spin)
>> > +{
>> > +	unsigned int allocated = 0;
>> > +	struct kmem_cache_node *n;
>> > +	unsigned long flags;
>> > +	void *object;
>> > +
>> > +	if (!allow_spin && (slab->objects - slab->inuse) > count) {
>> > +
>> > +		n = get_node(s, slab_nid(slab));
>> > +
>> > +		if (!spin_trylock_irqsave(&n->list_lock, flags)) {
>> > +			/* Unlucky, discard newly allocated slab */
>> > +			defer_deactivate_slab(slab, NULL);
>> 
>> This actually does dec_slabs_node() only with slab->frozen which we don't set.
> 
> Hi, I think I follow the intent, but I got a little tripped up here: patch 08
> (current patch) seems to assume "slab->frozen = 1" is already gone. That's true
> after the whole series, but the removal only happens in patch 09.
> 
> Would it make sense to avoid relying on that assumption when looking at patch 08
> in isolation?

Hm I did think it's fine. alloc_from_new_slab() introduced here is only used
from __refill_objects() and that one doesn't set slab->frozen = 1 on the new
slab?

Then patch 09 switches ___slab_alloc() to alloc_from_new_slab() and at the
same time also stops setting slab->frozen = 1 so it should be also fine.

And then 12/20 slab: remove defer_deactivate_slab() removes the frozen = 1
treatment as nobody uses it anymore.

If there's some mistake in the above, please tell!

Thanks.


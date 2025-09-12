Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EB8ECAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 11:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DAD98E0008; Fri, 12 Sep 2025 07:34:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B23D8E0005; Fri, 12 Sep 2025 07:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87A0F8E0008; Fri, 12 Sep 2025 07:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7795A8E0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 07:34:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 311E611ABE2
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:34:14 +0000 (UTC)
X-FDA: 83880389628.27.046DBAF
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id 475904000A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:34:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zf7Oej6B;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EQV0Qu9k;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zf7Oej6B;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EQV0Qu9k;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757676852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4X2W5Z+TjYnsv3B3buYTBJ72l3+aaTmtUZSpQraAFL4=;
	b=5mdUx5vdd6+RQgcIptPI3cC7Syf7WhCMB5wI86QoXPi5iMvpLzk+ugctME3DbGFYxFyUQb
	jrxcTsxxImWXasF0qY8BEq3q9PvUmQ6Jk8d+bnHyhqXHzOxtoqIfGuLIlVgvfj5dcUnhuS
	u5tunAD23tnPOrvFVGCFpvKmmxt7lfY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zf7Oej6B;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EQV0Qu9k;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zf7Oej6B;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EQV0Qu9k;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757676852; a=rsa-sha256;
	cv=none;
	b=JdExNnS8U0nuwCb+EMmAi/N9F3nbip9A0oprGBF5RkDFwb2jqbz5ekJpLnMsLoHjZDNXKR
	Tr3SPyz8n+erNckfw1MFK/vop2zxqYDkfmJsWNKSQ4EVa/5ibu8UhkDA6EThKtWbHXYaDO
	aK1mZU7HkMZXN379DS9MRtuahHoqPQk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ACD905D6F3;
	Fri, 12 Sep 2025 11:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757676848; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4X2W5Z+TjYnsv3B3buYTBJ72l3+aaTmtUZSpQraAFL4=;
	b=zf7Oej6BR+qhl59ldyrIIBOR0zLY6mqy/pEaCt2cFQiK2dRzNqFeO3WpVh04je+S6tHmkY
	KbkmA6/F4Z2fg7h8aG3xNdLxxVsQ8Nc3vFussH7Ch7MFvvxPqicIit73MOL/0ITDd1tvHU
	Go9n8oGC1IrEbJoaURo9ZjBKH7TFt8U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757676848;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4X2W5Z+TjYnsv3B3buYTBJ72l3+aaTmtUZSpQraAFL4=;
	b=EQV0Qu9kAqGNkY1fn1+2AUAl1Z9RGx3iOktacBXLf2J7dMz2w/Z01tjfFwsv9scrMr/zX3
	buTkUEDJKUQcaXCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757676848; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4X2W5Z+TjYnsv3B3buYTBJ72l3+aaTmtUZSpQraAFL4=;
	b=zf7Oej6BR+qhl59ldyrIIBOR0zLY6mqy/pEaCt2cFQiK2dRzNqFeO3WpVh04je+S6tHmkY
	KbkmA6/F4Z2fg7h8aG3xNdLxxVsQ8Nc3vFussH7Ch7MFvvxPqicIit73MOL/0ITDd1tvHU
	Go9n8oGC1IrEbJoaURo9ZjBKH7TFt8U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757676848;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4X2W5Z+TjYnsv3B3buYTBJ72l3+aaTmtUZSpQraAFL4=;
	b=EQV0Qu9kAqGNkY1fn1+2AUAl1Z9RGx3iOktacBXLf2J7dMz2w/Z01tjfFwsv9scrMr/zX3
	buTkUEDJKUQcaXCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 99ABF13869;
	Fri, 12 Sep 2025 11:34:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ReskIzAFxGhEagAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 12 Sep 2025 11:34:08 +0000
Message-ID: <96ee75c2-d561-4e9b-977f-72a3b056a08f@suse.cz>
Date: Fri, 12 Sep 2025 13:34:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] slab: validate slab before using it in
 alloc_single_from_partial()
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250911-slub-slab-validation-v1-0-8b67eb3b3dc5@suse.cz>
 <20250911-slub-slab-validation-v1-5-8b67eb3b3dc5@suse.cz>
 <aMP6f_fJ27flhdSq@hyeyoo>
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
In-Reply-To: <aMP6f_fJ27flhdSq@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 475904000A
X-Rspamd-Server: rspam05
X-Stat-Signature: 833o37up8xqwdj79skybjqscywwf1s8f
X-Rspam-User: 
X-HE-Tag: 1757676851-957701
X-HE-Meta: U2FsdGVkX1/5Tz/wb5zyNV4ZYnoluhfpAz3x3vd7WYoW8sIo9UtwmeH7xSTl0uPj5WwIbjFHQVHCk5g+HRwNdTf4kZ0zhAvj5OfbroBQuqj2rcUuwB8Dkj8fLk+YuLKyCtjkFtkP9h8Cao2S3RMX5qkF6k1mGG9LkNCJ3JXWZzU3k3QghhyMT0wtbm6FDJNFyX/azsEOmaEZccRzwf3fZaZxv1onSKpmO1yaCwhK9ZuQAFIvQYt3JvItQ4QbLxBoSh3hJH52eOuplSD0U5nwPjW9HzKOoG8prjj3tUjiZxGx8CacoPRsYERlSjJTwoYyMMDMgzF6jwqe5ZlBSabFg9LAuQyXFcKCh4rnKMKYc/CjZjvDRDnV85ResK11ls4ei5zbfYf7TXnJov3T7ZDffHTJHa/BecrTabtN4Isg6eKxiy6qxa0YGgT4N3JJeDxkzPdGFbfJEWs3evsTGQiDdUOe1gNdv+cK0nC7gP1VtGiXWWT3TJVm6QSgyxCbjCIMMgNHFzQ1icKYoJgIRl/xpDrPTN8eeAG2j3aMSmF+7wrrb163EoJa9faCkkKX7IvgqkywWnctNsjLJ27QY5vsWjGpnKFuzO+RON0rzHo2RFLU57ex3GyLXBvkQbB9NxrlXHaqcWw7TF4xi2A2eRU24NU21V21haG0lMV260dDWpUuVD9u8Yz6r/FnzkSNwgNbaGdEj9kPhu1uzoWWLmYwehPp2J+kidrR5XgLD1HkSkXRqNenAi7puvXDcqcPu3mHThqmCfFy1V3zu3yDJEg7sghUhYi7gKYJA9TDXNHaT/2VDEsSeFcGNlBABWchYwm5PdKXLZcQwNoKb8n/qbpqtAmswgCfMZ23GKEP+3dGKGA5Qs+4U4lagJ7Waun4fMHFJ86OqmeqkqL0swNyog/tDe0hUcMH9vUrByga9t++KnVFfkjHXa9N7YPLhrtZRz5eTdZJUTwe4mKux3pCz3C
 rizI56nD
 yxSZesVK73U+znA0arg5ZXMUG2GM/vR+DYjIPAZPQautbWsUTdaE+huoBkEIpZ7fM3ZDHWIVVBIZQIWnwYOjAYIf0x/kpRbmSNOKABUcac0cKkhASteUDRLc7fUBTFDosFEHnwZsG8E0bNNiAjxFr586t+mEmnJuyD02YJCuIsZUGUbScIvhIns2Fv/jXtvj1nH1/Je8nOmgTjZ+gGJLwzKF8VHTjcJZOcjObNkP4GOfFMjxPYZuzxzwzQOw6aAQKBj4V8VICgAnrOM2EqRs1qdJkC1ucLMCzmsosC4CaBXfEKyKRzts+Kfbd5UThQXiL1IBU7fsnJzLMf9Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/12/25 12:48, Harry Yoo wrote:
> On Thu, Sep 11, 2025 at 07:02:38PM +0200, Vlastimil Babka wrote:
>> We touch slab->freelist and slab->inuse before checking the slab pointer
>> is actually sane. Do that validation first, which will be safer. We can
>> thus also remove the check from alloc_debug_processing().
>> 
>> This adds a new "s->flags & SLAB_CONSISTENCY_CHECKS" test but
>> alloc_single_from_partial() is only called for caches with debugging
>> enabled so it's acceptable.
>> 
>> In alloc_single_from_new_slab() we just created the struct slab and call
>> alloc_debug_processing() to mainly set up redzones, tracking etc, while
>> not really expecting the consistency checks to fail. Thus don't validate
>> it there.
>> 
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
>>  mm/slub.c | 17 ++++++++---------
>>  1 file changed, 8 insertions(+), 9 deletions(-)
>> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 909c71372a2f542b6e0d67c12ea683133b246b66..93df6e82af37c798c3fa5574c9d825f0f4a83013 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -1651,11 +1651,6 @@ static noinline bool alloc_debug_processing(struct kmem_cache *s,
>>  			struct slab *slab, void *object, int orig_size)
>>  {
>>  	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
>> -		if (!validate_slab_ptr(slab)) {
>> -			slab_err(s, slab, "Not a valid slab page");
>> -			return false;
>> -		}
>> -
>>  		if (!alloc_consistency_checks(s, slab, object))
>>  			goto bad;
>>  	}
>> @@ -2825,15 +2820,19 @@ static void *alloc_single_from_partial(struct kmem_cache *s,
>>  
>>  	lockdep_assert_held(&n->list_lock);
>>  
>> +	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
>> +		if (!validate_slab_ptr(slab)) {
>> +			slab_err(s, slab, "Not a valid slab page");
>> +			return NULL;
>> +		}
>> +	}
>> +
>>  	object = slab->freelist;
>>  	slab->freelist = get_freepointer(s, object);
>>  	slab->inuse++;
>>  
>> -	if (!alloc_debug_processing(s, slab, object, orig_size)) {
>> -		if (validate_slab_ptr(slab))
>> -			remove_partial(n, slab);
>> +	if (!alloc_debug_processing(s, slab, object, orig_size))
>>  		return NULL;
> 
> Is it intentional to not remove the slab from the partial list
> when alloc_debug_processing() returns false?

No, good catch, will fix. Thanks!

>> -	}
>>  
>>  	if (slab->inuse == slab->objects) {
>>  		remove_partial(n, slab);
>> 
>> -- 
>> 2.51.0
> 



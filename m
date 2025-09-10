Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DE2FCA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:06:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90F6D6B000E; Wed, 10 Sep 2025 10:06:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BED26B0010; Wed, 10 Sep 2025 10:06:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 786F98E000C; Wed, 10 Sep 2025 10:06:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 628D66B000E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:06:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A7D51DEBF0
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:06:01 +0000 (UTC)
X-FDA: 83873514522.21.BA22DE1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id B1C2EA0016
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:05:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WXxp6nGS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JoGezYcE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WXxp6nGS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JoGezYcE;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757513159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hZEHsKM44S/61xauwqwuUCCyyHuNSS8fLwXg/3sXeN4=;
	b=0xz41Iu43Co8clfkPdzkUFd4DhB8609CrqbTrJqu6uko+7DOcLWW8ShRuSCd+Cd4tl5Ziz
	Rp7uJ5mJvhNBytePppdMA//+Q12LsKgxTSroSgHVsGtDLhMgSIDDAq2K5jzuurf6SamXHj
	+OL6u4jLy0XA/Sn20rz2FKHfNW8NaOE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757513159; a=rsa-sha256;
	cv=none;
	b=UWTSERp8meokClCzp68ELixxFkNT3LtZcEwJnYvShlykvQkszzmd21lPntMxaqpNbXTqO4
	RuHs3bGG1SpG9isx4PZ/4t3IcaZDPqq77yRojQle3Hno1xO8I8xQtmiO7FQiWTpCuoYu17
	sHdB99X3cy/8iFcofvt91iMLpKLCEZI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WXxp6nGS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JoGezYcE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WXxp6nGS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JoGezYcE;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E1490203B9;
	Wed, 10 Sep 2025 14:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757513156; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hZEHsKM44S/61xauwqwuUCCyyHuNSS8fLwXg/3sXeN4=;
	b=WXxp6nGSsBFctSwZFxG1FJU2t2UVKGFCrhIAt+2FeOAO9Q8oQnAeOq5BzGh29kEHac+S8A
	OU/qZgl/pv/x3LAwBSpnVCAkig7cGEETFWweQO49NUEAopBWrabDSvYqoXH1G7fyHiTNbz
	xAXdX1B/ISKQrZm0b09BsTj4s1K8ik4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757513156;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hZEHsKM44S/61xauwqwuUCCyyHuNSS8fLwXg/3sXeN4=;
	b=JoGezYcErz9jzLarANV0TtzyjPfah4l6dlOautN1rtvrnaPPmmI2QAKZoRhrSh4NPyZOP9
	2BhS0neIzZPTWgBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757513156; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hZEHsKM44S/61xauwqwuUCCyyHuNSS8fLwXg/3sXeN4=;
	b=WXxp6nGSsBFctSwZFxG1FJU2t2UVKGFCrhIAt+2FeOAO9Q8oQnAeOq5BzGh29kEHac+S8A
	OU/qZgl/pv/x3LAwBSpnVCAkig7cGEETFWweQO49NUEAopBWrabDSvYqoXH1G7fyHiTNbz
	xAXdX1B/ISKQrZm0b09BsTj4s1K8ik4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757513156;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hZEHsKM44S/61xauwqwuUCCyyHuNSS8fLwXg/3sXeN4=;
	b=JoGezYcErz9jzLarANV0TtzyjPfah4l6dlOautN1rtvrnaPPmmI2QAKZoRhrSh4NPyZOP9
	2BhS0neIzZPTWgBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CF0FD13310;
	Wed, 10 Sep 2025 14:05:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gp93McSFwWhCHAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 14:05:56 +0000
Message-ID: <a3cec625-1df6-452f-a475-9e49e9aa93ee@suse.cz>
Date: Wed, 10 Sep 2025 16:05:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/22] Prepare slab for memdescs
Content-Language: en-US
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org
References: <20250910115507.1991829-1-willy@infradead.org>
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
In-Reply-To: <20250910115507.1991829-1-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B1C2EA0016
X-Stat-Signature: pwnx8737s8e8nyshsuqhz65arof5duyw
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757513158-259708
X-HE-Meta: U2FsdGVkX1/xb9rPARC7wz641Pc0WpP1BktUOkf/p5d7Ye/q8YDQtmhUDeVUgWnntLeaiVqamVgqSBA9mHxt94MoB/RaeBwu1TVgoRRZNTdzZ389LHiSRGblmXwe0BeOnO725WW8CVIPVzwYNqVCRTVHkYDuaI9OAhNGErrSjOkjvoAmvosuLWyjzDDvNHZ2QPV9uwttcytaI+fjh5zCKyjbo6O7A5nPuTLBaVhUtTXj4KW3AR6w3kqXYkp+EAHoolsshRyih+1BSWQrEHIMeLLDjdL6VbWA7zz6ZAD0H6d4sR9Gd0mZ8k2UE3HJe/FBiFiJA7rL98Mni6YzZjZPJr3WMvCi+aMEkF/VzA/YLn+x5lPgU1x20r2xE87cQTLrV83CI0DjJhyVvE+s/WccEcCD+PmiZDojUD5T1pVb3TznG/Os8UNkQqmaWZoTBje3mPUhgkBvfkOh+E50HuUPYF880PndzQ/F6mGAOQ2itS2mKbqbn0OWSH9vJSkP5PIg98rB6cXIL7OJU3A+XWTeB4MLttqqvnwP7mh68t8A5cqOFsnnNVIIQhtBr17MTUFSCMRqDkzKKa28sgHpsfkYFlzdIlkmiKSX+B5lXEYPqoHc9uX27F17zwyfEyD2kg6k4KB6ISNzBHnfkZBzDnSJlsACyVg/iCCIBlPF3dGJwRWx2gsw9lQzcr0QYm6OUJFliiW23cFLqwK3WHZ4rZdSHGOu12IeKV9/T+pN71wUuwiG3axHGuMXzAXNWAZkheghFQG+OMDLgtmmfBI0dNmRIvpEwIuDPiBNR9zPZkkBBiJX8c2hVACJy9/KuoCcji4AXZMKG/Do8iOqA7zM5sHjWM+EQHpL7AFr6LzcStxGnfSQeA+2RxZUx8dhGTM4ziVNm+ZgfrGzM8yK811xb9Ywfq4lC6eDc2NF2nxRiL8d7DDVNnMqsFh4bZaa5r265XQ7RAqRgXEuD6rkTsCzD1y
 ifDFaXnO
 T2voX4IzyhdOUA6LliI0HxE5dWtG0a2MFHyHtcwrwpPcVmy7V/W1730XenP7zrQ2jiSN4IWU6yVgiEzlhdSGTuLQW23W1OCC9rfVAhh6dHxfCKnoklDsui7LzE+E0fTGz/gOK3bqIma+OrfKRXhfhZWJl5BwZj1Xu+2ZJaQxr9MAm2adRg6sZynbMeUXrMM20XRYlH227V95p/nYS16P3iqPKEuL0REcjn+ZJslszY46JNreFLPTDXiorNR/FlRJbGx7hmDel5NG/6PEldNZRihQYNynjrKfrLr+y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/25 13:54, Matthew Wilcox (Oracle) wrote:
> When we separate struct folio, struct page and struct slab from each
> other, converting to folios then to slabs will be nonsense.  It made
> sense under the 'folio is just a head page' interpretation, but with
> full separation, page_folio() will return NULL for a page which belongs
> to a slab.
> 
> This patch series removes almost all mentions of folio from slab.
> There are a few folio_test_slab() invocations left around the tree that
> I haven't decided how to handle yet.  We're not yet quite at the point
> of separately allocating struct slab, but that's what I'll be working
> on next.
> 
> This has dependencies on both the memdesc_flags_t conversion and the
> sheaves work (as well as textual conflicts with nth_page removal and
> a few other patches).  At this point in the development cycle, I'm not
> pushing for this to be included in the next merge window.

Thanks, I agree that next cycle will be easier. However seems some cleanups
are sufficiently self-contained and small to still be submitted to mm - I
think patches 5 and 22 (any more?), which would reduce conflict potential.
Meanwhile I'll look at 01-04 to consider adding to slab tree immediately also.

> 
> v2:
>  - Rebased on next-20250909
>  - Picked up review tags (thanks!)
>  - Fixed the bug in ksize()
> 
> Matthew Wilcox (Oracle) (22):
>   slab: Remove unnecessary test from alloc_debug_processing()
>   slab: Remove unnecessary test from alloc_single_from_partial()
>   slab: Remove dead code in check_slab()
>   slab: Remove dead code in free_consistency_checks()
>   mm: Constify compound_order() and page_size()
>   slab: Reimplement page_slab()
>   slab: Remove folio references from __ksize()
>   slab: Remove folio references in memcg_slab_post_charge()
>   slab: Remove folio references in slab alloc/free
>   slab: Remove folio references from ___kmalloc_large_node()
>   slab: Remove folio references from free_large_kmalloc()
>   slab: Remove folio references from kvfree_rcu_cb()
>   slab: Remove folio references from kvfree()
>   slab: Remove folio references from __do_krealloc()
>   slab: Remove folio references from build_detached_freelist()
>   slab: Remove dead code from free_large_kmalloc()
>   slab: Remove folio references from kfree_rcu_sheaf()
>   usercopy: Remove folio references from check_heap_object()
>   memcg: Convert mem_cgroup_from_obj_folio() to
>     mem_cgroup_from_obj_slab()
>   kasan: Remove references to folio in __kasan_mempool_poison_object()
>   slab: Remove references to folios from virt_to_slab()
>   mm: Remove redundant test in validate_page_before_insert()
> 
>  include/linux/mm.h         |   6 +-
>  include/linux/page-flags.h |  16 +---
>  mm/kasan/common.c          |  12 +--
>  mm/kfence/core.c           |  12 ++-
>  mm/memcontrol.c            |  36 +++-----
>  mm/memory.c                |   3 +-
>  mm/slab.h                  |  58 ++++++-------
>  mm/slab_common.c           |  29 ++++---
>  mm/slub.c                  | 163 +++++++++++++++++--------------------
>  mm/usercopy.c              |  21 +++--
>  10 files changed, 160 insertions(+), 196 deletions(-)
> 



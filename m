Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04210CA0FF7
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 08:36:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E2A28E0003; Fri, 29 Aug 2025 04:36:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2935A8E0001; Fri, 29 Aug 2025 04:36:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A8E38E0003; Fri, 29 Aug 2025 04:36:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 021738E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 04:36:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B05491A05DA
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:36:23 +0000 (UTC)
X-FDA: 83829138246.13.246A47F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id 05F52120006
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:36:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xcvIEpzf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gzcoVx2P;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xcvIEpzf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gzcoVx2P;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756456581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eAfAVEKSSJFCwExMyG8hLq1/L5FkKKjfragktAvZw+s=;
	b=4uCVbuGIBLCqdqEbfyFrQoTTYcsg6NQvcibI78JuLYLhKUQJst3uLRIVwE6/D7tBCIWPfb
	N5C9MaqF1uj7cd20WyVeaWZVNwd9eRo2SjLNod48ESFcwITC1emtUOrHip37+IoOeP4KnG
	/84Mv5I89gOGHsB9IZxZpn2BGWjd6AI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xcvIEpzf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gzcoVx2P;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xcvIEpzf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gzcoVx2P;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756456581; a=rsa-sha256;
	cv=none;
	b=yyknnkhPjBlTNNYtMI4rKacpkGMoX44Acy/c/nHseFqxOEkDISSLrvyEAsobvCWAD4arC4
	ttplm66IIKvq6BDvVhBtm/cBbu5Ovo1bMBXjOcsdlIthcZIvOv/1dtOuRzq/TF2VLOkBzb
	OlwLqjZQ/4kn1lpmbPBZDKa2rQczUvE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 101F133C82;
	Fri, 29 Aug 2025 08:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756456579; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eAfAVEKSSJFCwExMyG8hLq1/L5FkKKjfragktAvZw+s=;
	b=xcvIEpzfTaWnC6XWrZi1GMFk+ELmbRkz8Ta6BXn0VVj7F9iYelEjtQttfBNTqWzDIo17eT
	FTEG6izbQMne3GOpYyBp9teHG7I/GIMuQK+ohL8PiP9/8NjiN4eMZx/R8FfOiN/A6xNlRu
	zXzyCIrZCGZP9/nMVYclQYHmh1XjB5k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756456579;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eAfAVEKSSJFCwExMyG8hLq1/L5FkKKjfragktAvZw+s=;
	b=gzcoVx2PpPDSUTwULzYQIRHvOmi3+ariCFO/EmdsWGExWztog3V+v+XF9kB+IMteQQCvuG
	jHULxr6vgLKM3EAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756456579; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eAfAVEKSSJFCwExMyG8hLq1/L5FkKKjfragktAvZw+s=;
	b=xcvIEpzfTaWnC6XWrZi1GMFk+ELmbRkz8Ta6BXn0VVj7F9iYelEjtQttfBNTqWzDIo17eT
	FTEG6izbQMne3GOpYyBp9teHG7I/GIMuQK+ohL8PiP9/8NjiN4eMZx/R8FfOiN/A6xNlRu
	zXzyCIrZCGZP9/nMVYclQYHmh1XjB5k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756456579;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eAfAVEKSSJFCwExMyG8hLq1/L5FkKKjfragktAvZw+s=;
	b=gzcoVx2PpPDSUTwULzYQIRHvOmi3+ariCFO/EmdsWGExWztog3V+v+XF9kB+IMteQQCvuG
	jHULxr6vgLKM3EAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D87DA13A54;
	Fri, 29 Aug 2025 08:36:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4RKNNIJmsWhRIAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 29 Aug 2025 08:36:18 +0000
Message-ID: <10cdada2-f28f-4868-b821-4a13ed627e76@suse.cz>
Date: Fri, 29 Aug 2025 10:36:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: only set ALLOC_HIGHATOMIC for __GPF_HIGH
 allocations
To: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
 linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Mel Gorman <mgorman@techsingularity.net>,
 kernel-dev@igalia.com, Helen Koike <koike@igalia.com>,
 Matthew Wilcox <willy@infradead.org>,
 Thierry Reding <thierry.reding@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, neil@brown.name
References: <20250814172245.1259625-1-cascardo@igalia.com>
Content-Language: en-US
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
In-Reply-To: <20250814172245.1259625-1-cascardo@igalia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: xetqmd9jxk77bzh1izxrwwsn8ep8fwtx
X-Rspam-User: 
X-Rspamd-Queue-Id: 05F52120006
X-Rspamd-Server: rspam01
X-HE-Tag: 1756456580-140690
X-HE-Meta: U2FsdGVkX193aX0+vEOH7Y9z6n+cfcKCEPeKtmhvsb5KZnOqfjXaOHe3EY8+OjS6nllllta9zFU2lfo0K5c07SHrgiuH1U9F9Dxy1/e3SaDWjbZFJmgQOWNbcn7M6Gz+TpNGZDV6qzgCNBE71koFaNRfSReOPNeq83OIS/1ooCSvBHfZPQSzUoRYDDwBuHPWjMdhJCV3vpoLABNpt/tPFuiuBN4uQyAUOHOI6R1+Iu7sWvHp1Y8n/TtX/GdGNBWwdjTvGN8Z5cjouSDbJCBRU8ZhLMx90AXz9Nxi2VUSJeYrZusIaBbrDC3zxEeGx4LggBoAJ3jOkvlIKoD0D983N48lXit7nNe5pGZSq6hpnSKTfTgSmYwe5+w3raIA372fQ1QYchSkIkqKYcK0uyXIH738r6JP/4GxHOXeAexHqkElC9dyw1tQA/K1ZPw3vW24ZR+fAxcwHMiZNo1vvoegtncd2UiGumYASdWt/frGsWiYoBxXv+LDLN2F1pksRD2p+v5OaNhtZQoI2wW29xRNxdvQJxbKT7ytEczt5dJVG3gu8vU4ifzhOKaYJOYIseOzyd4FyGguA6PqekC+NExT6McqpUgM4OUQFithWI5tjZPqh32ITbPEHtgx9GbwYl11nzdUGBI2yNLXSlAw7elZOfETVfzsmSHylcfyjU84d5iUd7t1kBq/KVu1CcUAdCsz+kmV49QkdMWpWIe2iQUOdqwFv9nK0BMG+l71S3hy6pJgG6+wzm43hQ6gSYJbjJ+8msnI/xCopvm0lweHN+bZo/qZkp8k98iIQK6f4IROgWjejRlXBRjQ1rFAQxHddiKQBF+vxhRxYCt5anyW3NWwyGTJnnokc8ECavyIOdA9/sFU1ARNmfykWeRXR+BtF3oFvQj+LNZmVyg+2erX9mWGhxtmkZkXgpD3ABSGbDFob3MlApDQyhYg7olL/e0Du49rkUtpDWO1CIBQDiULTRj
 rgAzutvO
 ss4Kf9L/VyHIl3NlQQN9ZKFrorelgcum2TC55vwFtWBqVe11AuuuUtFIhL/JWN2hS4Fda0CpG9CooMSd0cp35qczVZPAX9fU7zrRkQK22jX4VlSvXFZAhydl0PADpFd45Tz6SbygQ2JgSBYT7+94+hsFS+UY6YUkjy4Ee78qQAdc8TgJn9h4bcddgsFM+voOHL48fhHvkA0eJqTizzOF0Gb7+Z68vOsOj66a8Db2cI0WFJK2agcMm27WRx9wFasKYPUj0nUp35lH0t/p5IDTg+LwBc57NvuFU9EgOW4b+gONEcrD5kLgQMJ0z9zv1JkOl+JERPvkug6YsNWXPwpQ4qX12S9/nIneCoXDTtNYmA9hVh0pFPRxx7DjBFd/lzLpzZjMAEb1+Y281cCqzBxYggsWKNvYkXe/bAD04S6JmHRN9XbKaLORWWd0x2GM2Ash8mwQ+YgT84A6xVr8W0ZWYCigq43ZMamVEWAGq11ey41EHV7SxLETUB/y84R/7x6qY4ISouZikETf47VvpWe6rE47tzDOnrPrF0UFSuW6/zStPmz/6YJuphsUqxnEiq/iokm9MOH0jzjSP8+MhBUNpsuQWPrWlBdAQN5HY9lClSGaJctU5R0NGYqI//SS5ScOZDH13wrDvQOU7lKd93s4CHQ36ircWIuv1pUeI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/14/25 19:22, Thadeu Lima de Souza Cascardo wrote:
> Commit 524c48072e56 ("mm/page_alloc: rename ALLOC_HIGH to
> ALLOC_MIN_RESERVE") is the start of a series that explains how __GFP_HIGH,
> which implies ALLOC_MIN_RESERVE, is going to be used instead of
> __GFP_ATOMIC for high atomic reserves.
> 
> Commit eb2e2b425c69 ("mm/page_alloc: explicitly record high-order atomic
> allocations in alloc_flags") introduced ALLOC_HIGHATOMIC for such
> allocations of order higher than 0. It still used __GFP_ATOMIC, though.
> 
> Then, commit 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH
> non-blocking allocations accesses reserves") just turned that check for
> !__GFP_DIRECT_RECLAIM, ignoring that high atomic reserves were expected to
> test for __GFP_HIGH.
> 
> This leads to high atomic reserves being added for high-order GFP_NOWAIT
> allocations and others that clear __GFP_DIRECT_RECLAIM, which is
> unexpected. Later, those reserves lead to 0-order allocations going to the
> slow path and starting reclaim.
> 
> From /proc/pagetypeinfo, without the patch:
> 
> Node    0, zone      DMA, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0
> Node    0, zone    DMA32, type   HighAtomic      1      8     10      9      7      3      0      0      0      0      0
> Node    0, zone   Normal, type   HighAtomic     64     20     12      5      0      0      0      0      0      0      0
> 
> With the patch:
> 
> Node    0, zone      DMA, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0
> Node    0, zone    DMA32, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0
> Node    0, zone   Normal, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0
> 
> Fixes: 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH non-blocking allocations accesses reserves")
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
> Tested-by: Helen Koike <koike@igalia.com>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: NeilBrown <neilb@suse.de>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>

Agreed with others that this change matches the original intention and it
must have been an oversight. Also found nothing to the contrary in the
original threads.

> ---
>  mm/page_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2ef3c07266b3..bf52e3bef626 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4219,7 +4219,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
>  		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
>  			alloc_flags |= ALLOC_NON_BLOCK;
>  
> -			if (order > 0)
> +			if (order > 0 && (alloc_flags & ALLOC_MIN_RESERVE))
>  				alloc_flags |= ALLOC_HIGHATOMIC;
>  		}
>  



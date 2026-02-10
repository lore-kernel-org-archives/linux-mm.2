Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12AAAEB26E9
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 16:45:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E6326B008A; Tue, 10 Feb 2026 11:45:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C4226B008C; Tue, 10 Feb 2026 11:45:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49CCF6B0092; Tue, 10 Feb 2026 11:45:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3AABB6B008A
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:45:18 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D9492C231C
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:45:17 +0000 (UTC)
X-FDA: 84429122274.10.BB264B5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 752D240012
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:45:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="P/GwZ3bH";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1FRppl9e;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="P/GwZ3bH";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1FRppl9e;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770741915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yeaH7+vlyRcZLcRTTBOYd4ClLWs7uv7EFXOnFep6uuM=;
	b=HWMUAuvfpaxW0usEiJWwjc+1XgnfTeZf5CuEKyD6irhHHWga88ub0TleedTTpezwzxpn2P
	wHW99cvAhCkVMIuJwWKD7OxLiHufZ8oO3MkaFzW75YuCpmHXAarzjAkn8H2HMAHXiiyfN2
	3J9ryFnlzKzRiFekNYs2JJxbDF7FnFQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770741915; a=rsa-sha256;
	cv=none;
	b=QSizyRf5JnwZvshjQdFiXCr1ccatxGilUA/7n+bh4ZsHcYraGtWfIPvbM4jAAT5WYKNVkf
	tvnRtGcUL70GK/mrtkyZOL+9+cnJIeVr+7nZdtovAWBKofJnBM80AZh0v4/I8MDw+7uD68
	xKMLoUM6CeQyprif0cF0ImMBs6ihNC8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="P/GwZ3bH";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1FRppl9e;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="P/GwZ3bH";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1FRppl9e;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EFE815BD6B;
	Tue, 10 Feb 2026 16:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770741914; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yeaH7+vlyRcZLcRTTBOYd4ClLWs7uv7EFXOnFep6uuM=;
	b=P/GwZ3bHN8WQ53C7mFMuQDtS9mEOBKn70al+4Dd/NsxMaNXctyvhHVM8sSK4Osh7P2Yes1
	Mt6BuxPNRcxF+DQHXNVg1Pgq+1Hr6DZvcUwT+rG1DB5dLoYwFMv7fZB4zfMLST7KlEaxow
	mjPNW8mz4hy/StHg/Wf/P3//7xuFc3s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770741914;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yeaH7+vlyRcZLcRTTBOYd4ClLWs7uv7EFXOnFep6uuM=;
	b=1FRppl9eHyXofmsLCOAX+siCbC6Hs9pQmvxyOs29M8FaZgEpXz/FRZDk+GHG2fQUqG01gc
	VGgpSdITMDQ+wIBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770741914; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yeaH7+vlyRcZLcRTTBOYd4ClLWs7uv7EFXOnFep6uuM=;
	b=P/GwZ3bHN8WQ53C7mFMuQDtS9mEOBKn70al+4Dd/NsxMaNXctyvhHVM8sSK4Osh7P2Yes1
	Mt6BuxPNRcxF+DQHXNVg1Pgq+1Hr6DZvcUwT+rG1DB5dLoYwFMv7fZB4zfMLST7KlEaxow
	mjPNW8mz4hy/StHg/Wf/P3//7xuFc3s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770741914;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yeaH7+vlyRcZLcRTTBOYd4ClLWs7uv7EFXOnFep6uuM=;
	b=1FRppl9eHyXofmsLCOAX+siCbC6Hs9pQmvxyOs29M8FaZgEpXz/FRZDk+GHG2fQUqG01gc
	VGgpSdITMDQ+wIBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AC2CB3EA62;
	Tue, 10 Feb 2026 16:45:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1rFTKJlgi2lUDAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 10 Feb 2026 16:45:13 +0000
Message-ID: <abf27055-cf2f-4ac2-a9cc-7b28bf4dbf5a@suse.cz>
Date: Tue, 10 Feb 2026 17:45:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 17/17] mm/slab: Use compound_head() in page_slab()
Content-Language: en-US
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@redhat.com>,
 Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-18-kas@kernel.org>
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
In-Reply-To: <20260202155634.650837-18-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 752D240012
X-Stat-Signature: gke39ckywajnn9j9mjmomdkei1h9ognm
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770741915-161753
X-HE-Meta: U2FsdGVkX1/hgePbkz/tTdl0QgicdU6wXzWkirXpm2bMNzH85eUVdGqQeCcdJp/0ImwMPxKd3aOezlIGVNKvMEBZFPkUB+DqImdeyT535mFec0AuzJdojf36kOeZwdKJQA6dHkO4sxUolQsX+0q97dlTl0/+cP3lJxg0I9fSeStYXQ6ALxzD8GXA2dQGzQN11OQ2LIKiKUFjbQTpqryaLklt7f/NNvvWcTlZup+1NGubUGR7cPr/oAwfBeVMFwH3NPmIkLyEXISWu7xsZ96RJClZcs9ARHBntcoPv3ELl/bOovOfkxH/XVa78rk0fEjYEFwmsANEfft7BpN0KsIAG42JEqQJUGZcleaXLK71kY9YGrOcdY4g4O1VZZY3NbjgOhhw3ZetTZqmrB/eDW/gCiM1ULphpysD8pAoweI4ZC5bGVcsrPlkLoAXWXOoXREzeXLiGha/RNU95bi9tPek6qZeuz4tj3ZYK/K3NUrwMJ6320THlMpUnyHpXixyxjs8jV9KxY2vh5Z1BzAnWLqyAv06lsehft66dvB442BkiX/KQVhRU10uv9phNULXJpDgRhgpZoyx/xeYGdaBHnC9fQWMw5XJD+hCwt+JyP0UoSgYSQM70ZneXWgaHZTdxElHdT6iB2umvaCXLe6h0jlKrebYiwSLlONIDH/zJLNFL8Sn9cnXY0fOd6IhaaODqoZ+2mSq56v+hhY06+xB5emaDAmGFK4NMLBMAdT/Q81rvRSvBLFbE9aqu4zYI1NYhjqEXKmUqWQGcSOYa4GvwfEEfrJ4PEdFCNLdMAJGOwUkhEPtIuNhdqavMarYNw3di5CuiCTnWBTiP7zj21Eb6ArwQz3nqN8l8hbqhRQzvCYhn8OruUM9Vy2pb5uc5qQe7uyzoQiG8JaB8cVH1+asxNdkBVBZQ1nId8g+tHNpqXyKCvqRmu9JYQvisZfz0LnafyWkR3EgFCLqR/f+tlB3iYN
 kYRCcKwF
 JxwsFBM9xlKpwIlV8NVar7bmpjKNbRQYY/0MmRBgtU8seNWoBCh5oSE1Z5o+Pyck0NvevY6vaJhQJQyb1PaTGRzr08G8k5AA5IbEv0iexirx50fk0lkkJpHXgWUbV4fjufQ7RRrHzAp+Ms6fjFNbIDpgExC8qEWjhYv5UojH147YOUDIFsZWt9lPWUdkoKC28+6p7005jGga2/vXToTKvQGETPPaZ+w68TDUyj5vaX3oe0dq8BnhZiHTsHBNbcH4ObQ1KVN3j7+h8LaLtyYoAyacpYrQWPW5EqdsZA54zEFi+Uc979OhIC9XG14l2R9PGeCNssWLmL7UQn7YUOX5nT6OSVok/J0RNatRLcdcB/n1d+Qk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 16:56, Kiryl Shutsemau wrote:
> page_slab() contained an open-coded implementation of compound_head().
> 
> Replace the duplicated code with a direct call to compound_head().
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


> 
> ---
> 
> I am not sure if this open-coded version is intentional and required for
> memdesc transition. Drop the patch if it is.
> ---
>  mm/slab.h | 14 +-------------
>  1 file changed, 1 insertion(+), 13 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index f68c3ac8126f..970a13ac5b8e 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -137,19 +137,7 @@ static_assert(IS_ALIGNED(offsetof(struct slab, freelist), sizeof(struct freelist
>   */
>  static inline struct slab *page_slab(const struct page *page)
>  {
> -	unsigned long info;
> -
> -	info = READ_ONCE(page->compound_info);
> -	if (info & 1) {
> -		/* See compound_head() */
> -		if (compound_info_has_mask()) {
> -			unsigned long p = (unsigned long)page;
> -			page = (struct page *)(p & info);
> -		} else {
> -			page = (struct page *)(info - 1);
> -		}
> -	}
> -
> +	page = compound_head(page);
>  	if (data_race(page->page_type >> 24) != PGTY_slab)
>  		page = NULL;
>  



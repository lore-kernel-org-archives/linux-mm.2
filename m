Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01A21CFC281
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 22:03:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D5226B0005; Fri, 21 Nov 2025 17:03:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AC946B000D; Fri, 21 Nov 2025 17:03:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B846B0011; Fri, 21 Nov 2025 17:03:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ECB696B0005
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:03:06 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9FE5E1A070C
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 22:03:06 +0000 (UTC)
X-FDA: 84135990372.25.845160D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2F992A0017
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 22:03:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RtxKZ+rC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="9vfBP/yP";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RtxKZ+rC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="9vfBP/yP";
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763762584; a=rsa-sha256;
	cv=none;
	b=Py3+XYRVCAiNCHp+i0Z7xBgrWMjqGM577di51tnb1DRNvujwpWRY9UbRGC7RguwV3lCaec
	6GgbKMU1ePtDpaVXmxzCPoWDelLRvKrd/99fuU1g2wvH63AWVoMSvQv/nmep6KRi6y+/hc
	HkGRfcuAGv/Wf+Ngj+RLAvZ8D2RsH9Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RtxKZ+rC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="9vfBP/yP";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RtxKZ+rC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="9vfBP/yP";
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763762584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yw2pxXis/Xz+P4oynkr/Rd16vF8hQAG4sC5aqFVU/w0=;
	b=DATx/PPLfdksDXCuLq+jDWnTZ+Po720ldHe0l93Y/1NUi4uJIaHhwSEyVGfsC83Xi4JOJD
	fD0osnCJxVZLnA14ykpc1nYhTi7uw7RD8zAIktQWMnpJJLL0pcgqdhVE4RwCbTsYnw2VU6
	cbPgvPS/mMax3ixbghs1xI/lN+YnV0c=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5FDD62198D;
	Fri, 21 Nov 2025 22:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763762582; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Yw2pxXis/Xz+P4oynkr/Rd16vF8hQAG4sC5aqFVU/w0=;
	b=RtxKZ+rCkjc+P1J2ddY632Z/XKFO38IcSLMTt2tWkHTgfd46reS1kednob69VeL3EaGGgF
	+SLB0ZOPs2/ehU+1xuXY8ywjgw0y7EVH1BFpwrUTepLzR8jFwhp15NHTsojckED91a1VJP
	BF4zCcXLwYRvTkwnbkxkpYfOnc9IUqY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763762582;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Yw2pxXis/Xz+P4oynkr/Rd16vF8hQAG4sC5aqFVU/w0=;
	b=9vfBP/yPdDXnOzOd4zvbe2TZr9zVEZ1D2NTjHJxsiMrubKiEkO8d4S6u5FPKvZRXihydzf
	gBT9VPUYDa8C3+AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763762582; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Yw2pxXis/Xz+P4oynkr/Rd16vF8hQAG4sC5aqFVU/w0=;
	b=RtxKZ+rCkjc+P1J2ddY632Z/XKFO38IcSLMTt2tWkHTgfd46reS1kednob69VeL3EaGGgF
	+SLB0ZOPs2/ehU+1xuXY8ywjgw0y7EVH1BFpwrUTepLzR8jFwhp15NHTsojckED91a1VJP
	BF4zCcXLwYRvTkwnbkxkpYfOnc9IUqY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763762582;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Yw2pxXis/Xz+P4oynkr/Rd16vF8hQAG4sC5aqFVU/w0=;
	b=9vfBP/yPdDXnOzOd4zvbe2TZr9zVEZ1D2NTjHJxsiMrubKiEkO8d4S6u5FPKvZRXihydzf
	gBT9VPUYDa8C3+AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 40C513EA61;
	Fri, 21 Nov 2025 22:03:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id piAtD5bhIGkaQgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 21 Nov 2025 22:03:02 +0000
Message-ID: <b1ae4706-b56b-432f-bde6-7d76e9b02598@suse.cz>
Date: Fri, 21 Nov 2025 23:03:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mm_init: Pull CONFIG_DEBUG_CHECK_PAGES out of
 CONFIG_DEBUG_VM
Content-Language: en-US
To: Joshua Hahn <joshua.hahnjy@gmail.com>,
 David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kernel-team@meta.com, Kees Cook <kees@kernel.org>
References: <20251121204454.2090245-1-joshua.hahnjy@gmail.com>
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
In-Reply-To: <20251121204454.2090245-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2F992A0017
X-Stat-Signature: h18znk5szd15cw5ikz634httc5hwjkhj
X-HE-Tag: 1763762583-309619
X-HE-Meta: U2FsdGVkX1+luiCkag0lRprihwhdCXnBMpVPb1fiRuhxP+pUGGL1t1fUiA3AE8Oa2GTvE5HLmWszA0kyTOIpK1FCout9thjKX6+95h7TJXrUC0KkDCLS1BpJaKZo06RmwYMmOZ8D9NmXI7jnp/3fufW0lzf3t29M6RryQN7xj0hKFQox0uFieK2qLfro+PUfR3L6doLyuVhn8Y/y+h+SGg23KZmwGV9J4cmiFVwArlXllUYBeUL6UI2RCYNpXPlQb2T1GhcgaAb2SFYjunJfuzMYKQd+gcwizqdJ8DIuoDeqdbkHlIw4Zpdx7iCa4OcR2XYLEt5kz7MVnIw/TUMDY+P7T7s4DVi8oy30nTsD85hpNrql28Mlj50xEOUSty2EaHqU0xpECb7A0ZXWFhu7HYKCL9WNVad6Kg2kLqlptA/gtwhOud7DSxJGJOVrRngLJT/1UArCqMa28X77ndRf472x2jfCfXjGJ/WHaRtbbl/nr6V8s9UBcpZ4u2ZgBXEsVLWW/+6CfNDoI5sp+Z5GHBopOkGv09ZlrrnwBw79nP87PW+oMPUeFiqcY+pjcecDSIpaa1JUwBZzwKFafCeAdM7F5D+mm9708gtFV7Y7qZQwbWf7AySy5RQqGi6tILOwC2cnDCdokcwqECStxIX5grhkXqorIYL5TNtLxOc+kv6FmTSdv1a7lT1cJwOaiEXaoadI7NNgegf+EQzSScQttVbRe907krVTfY/7uJDVsKKpxt2vVW7zuuN94/Qzf5iICQLuTa4e2erYTc3jZTOSbC5gCbsDTJnsMXWXrB+OcjaWYKRZw3XUERbIAK5wnRXvB66Lx8KXfWss8QGDmc92qk+53J1R3dKZxM/n2+D7VDUpizIOjd4Idvl0SEV2STmv1rHDHJzDWAV+QpWQ+1ZejV8rB4FNZvMIWJyt41VU8vGFXThDoAZJ4XoITJZjJVzyZil88/MJgbUxM+BNdgz
 jSyQ7kTC
 o/WOiKwrAUr8lw+WGZALNVfaCWYhtO8VzxpMM0weLrHUH6XNcZjbo2N1zmafymakpiSuTahJPCfHIY6O4Ot0lv7n6pZ4l9vlDrMDUHJ2BNmUTWpIOEAVs1d67oUsT0tWZsMrrfCX26dNTqj4c2zQjqosNf52L96QGS8lKgECtGkErXuYLvqADW56ik2lH3TQpwCx16Xm7CgFU1eKyO9tH+zuG0GmrndqtjP9v76+TtwPHNlmUp+t5a+lhLhEQAL1HgRBd1CQ4ENawxAuk2WKpQN2xaYFvBI3p8mZh+7FIEgtRyL6R4/32+StPNM4FIxihte3FxHxhu04M3VEKFNY+L9K2r34g1j0PNXnkOEzVZoRy8le8O6nDybWoJmtzlMmo/Hpj3YqvaNWveaqFbT26fYzWssnrKBwd9pxBpJFPvXRL0pU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/21/25 21:44, Joshua Hahn wrote:
> Use-after-free and double-free bugs can be very difficult to track down.
> The kernel is good at tracking these and preventing bad pages from being
> used/created through simple checks gated behind "check_pages_enabled".
> 
> Currently, the only ways to enable this flag is by building with
> CONFIG_DEBUG_VM, or as a side effect of other checks such as
> init_on_{alloc, free}, page_poisoning, or debug_pagealloc among others.
> These solutions are powerful, but may often be too coarse in balancing
> the performance vs. safety that a user may want, particularly in
> latency-sensitie production environments.

OK. Would a boot parameter work for you instead? It's more flexible than a
config option. Then we could perhaps also decouple it from
init_on_alloc/init_on_free as it's a bit odd side-effect for those anyway.

> Introduce CONFIG_DEBUG_CHECK_PAGES, which sets is_check_pages_enabled
> with no other side effects. Setting CONFIG_DEBUG_VM automatically
> enables this as well as to have backwards compatibility.
> 
> Developed on top of 7f1dae318f81e508ef59835bc82bdf33e4cb1021 "mm: swap:
> remove scan_swap_map_slots() references from comments" of mm-new.
> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  mm/Kconfig.debug | 12 ++++++++++++
>  mm/internal.h    |  2 +-
>  mm/mm_init.c     |  8 ++++----
>  3 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> index 32b65073d0cc..366abde25026 100644
> --- a/mm/Kconfig.debug
> +++ b/mm/Kconfig.debug
> @@ -45,6 +45,18 @@ config DEBUG_PAGEALLOC_ENABLE_DEFAULT
>  	  Enable debug page memory allocations by default? This value
>  	  can be overridden by debug_pagealloc=off|on.
>  
> +config DEBUG_CHECK_PAGES
> +	bool "Debug VM page allocation/free sanity checks"
> +	depends on DEBUG_KERNEL
> +	default y if DEBUG_VM
> +	help
> +	  Enable sanity checking of pages after allocations / before freeing.
> +	  This adds checks to catch double-frees, use-after-frees, and other
> +	  sources of page corruption by inspecting page internals (flags,
> +	  mapcount/refcount, memcg_data, etc.).
> +
> +	  This is automatically enabled if CONFIG_DEBUG_VM is set.
> +
>  config SLUB_DEBUG
>  	default y
>  	bool "Enable SLUB debugging support" if EXPERT
> diff --git a/mm/internal.h b/mm/internal.h
> index 04c307ee33ae..b8decdfc0930 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -562,7 +562,7 @@ pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address);
>  extern char * const zone_names[MAX_NR_ZONES];
>  
>  /* perform sanity checks on struct pages being allocated or freed */
> -DECLARE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
> +DECLARE_STATIC_KEY_MAYBE(CONFIG_DEBUG_CHECK_PAGES, check_pages_enabled);
>  
>  extern int min_free_kbytes;
>  extern int defrag_mode;
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index c6812b4dbb2e..7f47b22864dd 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2523,7 +2523,7 @@ static int __init early_init_on_free(char *buf)
>  }
>  early_param("init_on_free", early_init_on_free);
>  
> -DEFINE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
> +DEFINE_STATIC_KEY_MAYBE(CONFIG_DEBUG_CHECK_PAGES, check_pages_enabled);
>  
>  /*
>   * Enable static keys related to various memory debugging and hardening options.
> @@ -2588,10 +2588,10 @@ static void __init mem_debugging_and_hardening_init(void)
>  
>  	/*
>  	 * Any page debugging or hardening option also enables sanity checking
> -	 * of struct pages being allocated or freed. With CONFIG_DEBUG_VM it's
> -	 * enabled already.
> +	 * of struct pages being allocated or freed. With CONFIG_DEBUG_VM or
> +	 * CONFIG_DEBUG_CHECK_PAGES it's enabled already.
>  	 */
> -	if (!IS_ENABLED(CONFIG_DEBUG_VM) && want_check_pages)
> +	if (!IS_ENABLED(CONFIG_DEBUG_CHECK_PAGES) && want_check_pages)
>  		static_branch_enable(&check_pages_enabled);
>  }
>  
> 
> base-commit: 7f1dae318f81e508ef59835bc82bdf33e4cb1021



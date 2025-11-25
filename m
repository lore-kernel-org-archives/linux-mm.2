Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C4A1D0EE11
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 18:07:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 782EB6B0031; Tue, 25 Nov 2025 13:06:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75A096B00A7; Tue, 25 Nov 2025 13:06:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 649EB6B00B1; Tue, 25 Nov 2025 13:06:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F7BC6B0031
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:06:59 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F36DA13AA64
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:06:58 +0000 (UTC)
X-FDA: 84149910516.09.3B01229
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3B0D220007
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:06:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="X/ZMQ81b";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Pl1175js;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="X/ZMQ81b";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Pl1175js;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764094016; a=rsa-sha256;
	cv=none;
	b=pb87y+CnomELHViEs8AcnPyuA50wBLr+xy8fEshw3zO1693cLtPAGg2P95aucnoZQDlB6q
	6aoTJdNaHobrj+jr+ZQk78cA4vhps7d21O4UQMtdVyguL0GB4ZplXoS/ruNS1Wkv5EVmHU
	KVRVGeW8+0nQmkLwg2k3iMp9sCS+LMY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="X/ZMQ81b";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Pl1175js;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="X/ZMQ81b";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Pl1175js;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764094016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PoBMvtRuyPn1L+lx0oRz613sdrYJSSZTiHXSKjwJ2ec=;
	b=Wih6fL6JPIzwTvH+tlm2ROjPyyGVcr/PXl68ZhuDmzsn2BgiL3SeH85ko/fX/VIAHjLI13
	WfHdVZbzYj8InzcC6MvD1TZ34ABM2KxUy2zxSi52Chc6Vtj8mZ7O4QWni44YZMgyozbRcS
	7Vl8gHSZq7VwWeptsEdAu+JJIDg7e/E=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7260E5BD12;
	Tue, 25 Nov 2025 18:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764094014; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PoBMvtRuyPn1L+lx0oRz613sdrYJSSZTiHXSKjwJ2ec=;
	b=X/ZMQ81bPp5YhNOurMGqN/N0QlLxCJrRYlRLfQbib3RsTTmFrv36HNtaJ3OVH1aAuE19A6
	Z9ji4892mWP/7j5bFtWq/56pfcJFxitvL+GXG1VJLQMsLMPeuQl+YJgQL7LcBaAhJTFH6M
	4dDZ7Y7cO8Aeuck7VTGFi+jN/Uoy5ZU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764094014;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PoBMvtRuyPn1L+lx0oRz613sdrYJSSZTiHXSKjwJ2ec=;
	b=Pl1175jsbytc3e/eiXZdFdZQpmmwJMppWaaL68/X/K+eCTiXD9hEwT7PlgsK/jDsxZRihy
	HHq0oPqjI5EuH6Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764094014; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PoBMvtRuyPn1L+lx0oRz613sdrYJSSZTiHXSKjwJ2ec=;
	b=X/ZMQ81bPp5YhNOurMGqN/N0QlLxCJrRYlRLfQbib3RsTTmFrv36HNtaJ3OVH1aAuE19A6
	Z9ji4892mWP/7j5bFtWq/56pfcJFxitvL+GXG1VJLQMsLMPeuQl+YJgQL7LcBaAhJTFH6M
	4dDZ7Y7cO8Aeuck7VTGFi+jN/Uoy5ZU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764094014;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PoBMvtRuyPn1L+lx0oRz613sdrYJSSZTiHXSKjwJ2ec=;
	b=Pl1175jsbytc3e/eiXZdFdZQpmmwJMppWaaL68/X/K+eCTiXD9hEwT7PlgsK/jDsxZRihy
	HHq0oPqjI5EuH6Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5D9F33EA63;
	Tue, 25 Nov 2025 18:06:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Or8kFT7wJWnFPQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 25 Nov 2025 18:06:54 +0000
Message-ID: <5d0c582f-7e1a-4623-90d9-1dd6db443473@suse.cz>
Date: Tue, 25 Nov 2025 19:06:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/mm_init: decouple page checking and
 init_on_{alloc, free}
Content-Language: en-US
To: Michal Hocko <mhocko@suse.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport
 <rppt@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kernel-team@meta.com
References: <20251124225408.2243564-1-joshua.hahnjy@gmail.com>
 <20251124225408.2243564-2-joshua.hahnjy@gmail.com>
 <aSVssg5c8mNvyLou@tiehlicka>
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
In-Reply-To: <aSVssg5c8mNvyLou@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3B0D220007
X-Stat-Signature: x6a8yitnoe8uue1xymd93gjdggpexjnm
X-Rspam-User: 
X-HE-Tag: 1764094015-244656
X-HE-Meta: U2FsdGVkX1+3pRAmpE32U+uxrtt6jxwUdc/JvE0vG7kEPjy9rZy1u6+DGM40VjBc9dvyjOAZkN9YuXKEmMqS1KH71kSex0UfqjBU7o/tdqa72qUZDF2BRorsjd6NUoY8l7t20NPYQ2DKf5np4/4iKh4tnt8b1fQvcyy2iBoH+o1X9K2PNxqTpktnuc+iYRN4AWfK4D3fzceZzLMELGw1eWMBemFyWEwS1r3OtyWwLlaR6yd8tEbansZkiFLc9eLfFtBUMGi5+c8WtOALu5Wv9b1mzJCmiIgcdNBawdM1lWfpBsz1Ay+D/r6kMH8Z/7BMShFKQBUOBl47vBIbDgMwMySUjIBmkkUEiC9T8YSLSREG3fPkjGSpj3HKgnYJPQ47LxQcs2EppmBNF6OWqVGhPjJt56al89yjkVKqtZaqAi+bhvIk8FC8XhUn6c6h9XqUoMLdrqixiF2VyGjZmc5Vp6ajMFKWb+RFni6oL3ji2eovrGKSZffBvCxFaeLSW2xaLQiRGZYt3+Ya4X0Q8boJt7LD9+MMgeLxz+mX/xxmh5UgSde/TC5yfHjWarQIpEaVr7eEBKgrzm1wlGXz9J0rSfoDQtX1sDi2sIsNnb3D2LWsfrdGMmnjFnFq0Lo4OUJylbmIYHqCDsjuuy/WupMGte3SopKoUpYPpSQYK5zf0HUq3u4BeOHeuFeiCArC1pLgQ+3vmrnkNsiqoS4ZWX9GbkLRp0WCtBwFVhXOXQKUxMV9tKbjb+YRolU5N2fR4gPfUqVuVk4/TMoxQ+LF69xic7anH5t9o2G1KYOBMtQFQdw6P6XXxy2wfPdbncQTM0tRgVrpXV8VuPUPtsA1K+VPLINihHB2iI8w70/xaMbjAgZ695WIv1p7A+KrERAnDn4UrXNZxhvwVvWzwP/Bs3AljdMsTijJBkXQKcmjUavyjyJCNXIZ5fN09c7Nm+0Zn3OBh/ZlDNIo+1/gd6pZYtR
 rfaCYffy
 GydilX8rB3uX3QlQbzJ5U/mHm17NS2n7/iC1y88BqspQzQgGCZrKu9x9Ujfrwr/kSRrAjxs9D1etmUb91CBiEM3NZU1R7kYVkcrKVK55oxxcxUW4b5qNLYe88sBUbx2VxdpGj6Pq7HTyxtpmipBsJ05k6xhwbZwHDl79CER/oasNzTcpimw2EmOolVLMTM0Opq+Ble774r9+pEAK6VvLwAGUsVmtasq0BSSVRaAd6k4RZQYDH+VKmtNfekQXvA2ZEBORESapfD/Shs5L1UYbtTC8fBPtVaCcgU2EmCbl2oIg0IJu10hsi3wDH8kTrcc2Tvn4B+IuCjecaL085boP42XzjOxIyFlbMwT4OI5MpySZzNAlN6vxp+mMgFdStymAoXp+rDSlzh3gnrDn+AS7C/plM8Rim7H2woDLynCzlI9n2AWXMcJQ2zORiqp8lE040kbYk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/25/25 09:45, Michal Hocko wrote:
> On Mon 24-11-25 14:54:07, Joshua Hahn wrote:
>> init_on_alloc and init_on_free protect the kernel by initializing
>> allocated and freed pages to 0 on allocation time / deletion.
>> Commit 700d2e9a36b93601270c1e15550acde2521386c5 ("mm, page_alloc: reduce
>> page alloc/free sanity checks") removed page checking from hot pcp
>> drain and refill paths, and instead coupled it with CONFIG_DEBUG_VM,
>> debug_pagealloc, page poisoning, and init_on_{alloc, free}.
>> 
>> As the commit suggests, the first three turn the kernel into a debug
>> kernel, while the last hardens the kernel against leaking sensitive memory.
>> While enabling page checking is relatively low-cost and tying it
>> together with page initialization is not unreasonable, it does feel like
>> a bit of a side-effect, rather than an obvious consequence.
>> 
>> With page checking now pulled out as a boot time parameter that can be
>> set independently, let's decouple page checking and init_on_alloc and
>> init_on_free.
>> 
>> As a direct side effect, systems that have init_on_alloc or init_on_free
>> will no longer have page checking enabled by default; they will either
>> have to pass the check_pages boot parameter, build the kernel with
>> CONFIG_DEBUG_VM, or enable debug_pagealloc / page poisoning.
> 
> How come this will not break existing users? What is an actual upside to
> get for the risk involved?

+Cc hardening people for input if they are fine with the decoupling and if
docs for hardening recommendations or something similar needs updating

The upside is mainly reducing the side effects i.e. being more explicit than
implicit. In practice I'd however assume people running init_on_alloc/free
and paying the cost also want to do page flags checking anyway. The more
important patch here is 1/2.



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1D3FCAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 12:35:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54D4E8E0002; Tue, 16 Sep 2025 08:35:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 525548E0001; Tue, 16 Sep 2025 08:35:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43B7F8E0002; Tue, 16 Sep 2025 08:35:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2EABC8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:35:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DCA681D9FC9
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:35:33 +0000 (UTC)
X-FDA: 83895059346.10.A5B243E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6B81F14000B
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:35:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0gE8fCwS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BwoxRnAy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0gE8fCwS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BwoxRnAy;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758026130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aN3GDP1sxLfuXqNUNI8BUA96vurHTxKamsWO8AnEyMk=;
	b=xI9tjYM5UojQ9hHkXuHkkCaul/p9ubSbOybsHbKok0croV01s8QvJLg8P5oTObIFkb1XyZ
	z0LYsGzAhY+0Swnbxdo9XxDkH5dhjAenSF57I6tQgCzReMCnf8paLDU9IyErBFdfK37uOo
	eutNxyFxT8pMex3hM21yAE7Ks4EOyD4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758026130; a=rsa-sha256;
	cv=none;
	b=NrtpT7+DIjbskDpK71FyTK8jtJdjlTwW6VNuyXP7KRSCVrWgmnnUuZzjT2s6gtDIjM71e6
	tMTRUP0/qhszkfP3yhXwj65o7SFEw5KdatsRlFMshKxtJ4SvAcTYVQbPYbujPJ/2evL7ct
	iLNzhxddRaSsXZ3pSRh+nLwCOEpnlEA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0gE8fCwS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BwoxRnAy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0gE8fCwS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BwoxRnAy;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 70A3E22958;
	Tue, 16 Sep 2025 12:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758026128; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aN3GDP1sxLfuXqNUNI8BUA96vurHTxKamsWO8AnEyMk=;
	b=0gE8fCwSXO5ORwUHYBJUurMqzB10EcjBrOeElDwIF96FwhfdfLhq9vakmXGh5rR4eJhIHo
	fdoOMy6Tyf+zDWXk5sUXGg4sbUVSEd2xnbzoczg3uwVVXl8KRpVwa6LM3JUUt4R4F1hKFC
	+OaH89SaYhfrD30H9hTA3JZxrfvbm+0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758026128;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aN3GDP1sxLfuXqNUNI8BUA96vurHTxKamsWO8AnEyMk=;
	b=BwoxRnAy5yjDbp1Ha1eGVATyWEKYPOMvIb94dNvXB9858FETvYNcpTX9r4MZRYwjBYyRxy
	27zoLzT3ELe0tdAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758026128; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aN3GDP1sxLfuXqNUNI8BUA96vurHTxKamsWO8AnEyMk=;
	b=0gE8fCwSXO5ORwUHYBJUurMqzB10EcjBrOeElDwIF96FwhfdfLhq9vakmXGh5rR4eJhIHo
	fdoOMy6Tyf+zDWXk5sUXGg4sbUVSEd2xnbzoczg3uwVVXl8KRpVwa6LM3JUUt4R4F1hKFC
	+OaH89SaYhfrD30H9hTA3JZxrfvbm+0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758026128;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aN3GDP1sxLfuXqNUNI8BUA96vurHTxKamsWO8AnEyMk=;
	b=BwoxRnAy5yjDbp1Ha1eGVATyWEKYPOMvIb94dNvXB9858FETvYNcpTX9r4MZRYwjBYyRxy
	27zoLzT3ELe0tdAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5616B13A63;
	Tue, 16 Sep 2025 12:35:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BrCqFJBZyWiLfAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 16 Sep 2025 12:35:28 +0000
Message-ID: <01108e4b-9586-4147-9b8a-c3435f6a98d6@suse.cz>
Date: Tue, 16 Sep 2025 14:35:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] fixes for slab->obj_exts allocation failure handling
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, harry.yoo@oracle.com, shakeel.butt@linux.dev,
 alexei.starovoitov@gmail.com, usamaarif642@gmail.com, 00107082@163.com,
 souravpanda@google.com, kent.overstreet@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250915200918.3855580-1-surenb@google.com>
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
In-Reply-To: <20250915200918.3855580-1-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: eaf1wpi1gijkgus5z7iof9zb8es6zapg
X-Rspam-User: 
X-Rspamd-Queue-Id: 6B81F14000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1758026130-440200
X-HE-Meta: U2FsdGVkX1/4c+3YsatO/8HUUZ45pdw3JtutSNlerssE6kfuBbFd1ZebcW8g3mlCpAEkxc/hEi/4MZ9Bg1CrXBrK7AYGrTKvgiNBRGAoYpLw2PNEIu3imU392+ciw/uCZXZ6abTaChwNpdGhUq15VbfW6/9/UBp9Rzl/XsRGTIg6GwXN1gSrKoOsCzRWWix/3nI9BtdxnLqKy1mrSfshq6kl4uEfMhovT6L9+Oev6Jm8ZtF/UuHW+yn2KAathOgCMB95/Dv0Om17GfZppgXbuk8RMujuO3HQ8w09lbNKpnivF+f5fQt4MoDd957ZRLfJ12eGIWbG0ZSoX/7E1A5lFxh/ksT95sC6MrrG5rJdQNqmXLF6mre/qdjDCkGOFVh68KtU2tsf0vult3IUFocle79onwXmf7PQi+QIDUNmxTc34z+aNH7pUnlo5ebokHnf1iRmvAAA0I8/SddKIi7OIgBY0EJc99L0EdFlECOrLy9OhU+rY2jK5QA4OQn7QlE1Q+aMgN6N+S4r9CFZ1GJu05wO5Lxap20DaGLeQyZEpfd4FoYBLTN0j/4nVD+F9piArk56CsFJ4/8P17s1SK9nAyfT/lrB782me6D6QoopYbHTxiv6as4GsBMMwPIfgHei1sj7YQ91tl5Tf/HXBSvKjJapRH7GMGnoNd82UnpZFvRvdsbbjEUw4yWO0SZlIRSimW36X1q5qT+gGGFCIpKhk44jMq5bzjUE1Xfl1q0XetHexyPGXysNqmq5aSw/N7fegQMypwrfTBwKrCZIUSCwynTE5Xe69k0pOoYi4fD6iFhE1eObm+ARN6/L5IudXu3tV8Wo3rv4btoAnt8LSLriFDC3rnGr1L/JjKoqjRtE5X2Qxrm7guKa1r/Hu0alpRUR431EWxQS8RkfFWDyT9mYLgL9B/vbt+4gqKAhTUwhK1cv79cJesn0GZuTE2oS0HXc/kLKrAtjwNq1GUJ+tbz
 oTetaB71
 cCmfXmhB/ApdlBlqk3Lfm8N1sqnl0USb7RaVmryhzQ7PL28a6ORAQwCPjJo+/boDvL/OJsxIlEPtLQ5YBSP6FkMq3EJfZpaScAaXFZRvE1MtsiGdZmMJFoTP52pawzbkmTFqEkAdlEfY6VnqwmYOdxvExq8tlNnMx2dQlGUWb0YMRKV7hdwveLTdvdpg8jkmBLjs0qXy1Qworr5qfm067LMBrcAY8MrOLASdD6rAaegobFBEc7R72bmDpzzNt5ap1T0BkZcU71ZpJm/hiojbWUQlCcnGxer9Mvcpi9FWs0uCq5QW/7EC2ILw0oktkOdPjlIK3ew87kpF0WCKxBsXJ2YPDFGSAIVtTN8gFu4Aa07gJexH/MfEfKD1+rRe41VUosvjUclHTVIutcQww7QyTNdrYAgtP/gR14G+9Q+yt/N70i00=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/15/25 22:09, Suren Baghdasaryan wrote:
> Fixes for several issues noticed by Shakeel pertaining to slab->obj_exts
> allocation failure handling in [1].
> 
> Patchset is based on mm-new.
> 
> Please route it via vbabka/slab.git as it's relevant to Alexei's patches
> in that branch.

Thanks, added to slab/for-6.18/fixes

> [1] https://lore.kernel.org/all/jftidhymri2af5u3xtcqry3cfu6aqzte3uzlznhlaylgrdztsi@5vpjnzpsemf5/
> 
> Suren Baghdasaryan (2):
>   slab: prevent warnings when slab obj_exts vector allocation fails
>   slab: mark slab->obj_exts allocation failures unconditionally
> 
>  mm/slab.h | 8 ++++++--
>  mm/slub.c | 3 +--
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> 
> base-commit: 9a9318f95d63805868bd21e1381d68c3a75d03a7



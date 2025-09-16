Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79844CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 10:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B78268E0012; Tue, 16 Sep 2025 06:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4FE08E0001; Tue, 16 Sep 2025 06:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3ED28E0012; Tue, 16 Sep 2025 06:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E9D68E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 06:40:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 45342140974
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 10:40:18 +0000 (UTC)
X-FDA: 83894768916.05.0A5ACA0
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id BE2B31A0005
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 10:40:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=beQ+eKcp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ie8Yk5TB;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gPL876Zc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7Ftz32Ob;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758019216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+0zUffq4lyrZLnAY3kzkip/0U4DyU7W1S2zm2WAdt6U=;
	b=nsdXlngFQmfFc5k2mImt1CF5iI3fgdtAo0ARxd8Swzzqt68IgR8ZRP/9GUPqH9AqqF4avm
	CJm9JCcw12KTStkZ4fyYwiUknm2dX5W6hy5lR2D/MUmi4hQtcfhcpSRhpE72WQHtUNaeJ3
	/2vVHMElS3KWvGm+4El/eW5Ryuw/Rq4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=beQ+eKcp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ie8Yk5TB;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gPL876Zc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7Ftz32Ob;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758019216; a=rsa-sha256;
	cv=none;
	b=czEkkL4mDjzWXDoCM+QxnH9I7GXsWO9DkwZ/h25uAxMT/FtmBDQDoaDq0cSRDtVdV0B+jk
	pWCzp/7WXdytw7yka/6kSsHgJ5wD417DjBUbfJsVWZlsWFpK3uywh+0F+ApOPYmMqfMiYM
	JmPM5u4fph9bfAAT9TRG10Ix8M1ig34=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BAD3321A9B;
	Tue, 16 Sep 2025 10:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758019214; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+0zUffq4lyrZLnAY3kzkip/0U4DyU7W1S2zm2WAdt6U=;
	b=beQ+eKcpHexGReE/VylLXXWMJHASUjLkMfFAmTfIPSVLE/5cvVsHANBlofs13XjjbVWhdC
	nV+kGdoRuGD7XFKZYoxwFU8geVy3DVnq+ZUnD7CdyruOw6tE7+U9R+QkgkHJk63twvwrj5
	iqIiPlu4gEcyXD4aQjXR0GD0XMu8wYo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758019214;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+0zUffq4lyrZLnAY3kzkip/0U4DyU7W1S2zm2WAdt6U=;
	b=Ie8Yk5TBRhX8n0pHuN+03HyqaHTvaeyGjDUlidZp8GdSR8nxE7mx0w07KWO952egZ1RRs0
	5emgUiSrPngumvAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758019212; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+0zUffq4lyrZLnAY3kzkip/0U4DyU7W1S2zm2WAdt6U=;
	b=gPL876Zcrv6wbBrFqjv8WVKcZlo9Apq6imLeoUFc6U+klfLR9ADaTW71xP6a4KtRU0UmTx
	5XmjSSRp3r5AO96I5fqAm8xKsTgT5d6UDs4qVEenVJw2Au1hNjeNqRvd/QLmf/uCLF64Ed
	JtaIUHQJa6w2a4ma+gHbZ4CFb/6Cr0M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758019212;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+0zUffq4lyrZLnAY3kzkip/0U4DyU7W1S2zm2WAdt6U=;
	b=7Ftz32ObL68EouCSm6E7Y2gUhjs4lLKi6zaAlN80wIryYl4V5U0U4EsFZZJGHYK3O4rrDf
	AAHtKu61cjM8ucBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9F57113A63;
	Tue, 16 Sep 2025 10:40:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 94BMJow+yWitUgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 16 Sep 2025 10:40:12 +0000
Message-ID: <47aca3ca-a65b-4c0b-aaff-3a7bb6e484fe@suse.cz>
Date: Tue, 16 Sep 2025 12:40:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab] slab: Disallow kprobes in ___slab_alloc()
Content-Language: en-US
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>, bpf@vger.kernel.org,
 linux-mm@kvack.org
Cc: harry.yoo@oracle.com, shakeel.butt@linux.dev, mhocko@suse.com,
 bigeasy@linutronix.de, andrii@kernel.org, memxor@gmail.com,
 akpm@linux-foundation.org, peterz@infradead.org, rostedt@goodmis.org,
 hannes@cmpxchg.org
References: <20250916022140.60269-1-alexei.starovoitov@gmail.com>
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
In-Reply-To: <20250916022140.60269-1-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: cuc6aehpbk7rx4wonx4zbw669gz6exh7
X-Rspam-User: 
X-Rspamd-Queue-Id: BE2B31A0005
X-Rspamd-Server: rspam04
X-HE-Tag: 1758019215-675309
X-HE-Meta: U2FsdGVkX1/s+MB2tvi5sYtGATQShvOr0Tz6xgg1rQmrANDEUi03ARuEJxbzpv5Zddtof/Nf3DRhvk4fcbcIVufsJct+yzpjoORxBEqoq67OrokhjCmYSzDvosqH+6VLMT45gzXGcCyTMVY7Akur5WrVx+m8GzRS1+w+HRVNi2pj1SqbCBugQpR/Y3iw68Vh9+TQ9vvXNSAN7ZgYvi+iR27zzuP+4MZWoLcdd2GGGdINNYM3rwhwiA4Oex8Ym/X7fnMAuUqFETAzg+D4+eVWdRuHMgyhxOwpfNc/s5BpUx0CTV/vG+wkr3jSIwfb5W6bMw9valZmiILYVH25G3r67fSTIO05a2xUQoO9HvdDPGem0Je7Wc1xxB4eafnslaJhsU+u8eDCgA54Ur4dLtoh9HezkfyviSDnXHPRTkZv9pVyREofrcq+B6pQNuEDr0E6IE/+gXnWpnOy+l5c44cTAVElFLT8REa1txSIGNebnnm4w2uT7kZfyPuKkS/HLRoBW4yw0PP4X/D7Y8ed+kQSS+EpI7o+Vi5rxx1Mu+17leg+V8WaJteMMqOIBnC6SM2fpr2M8+vA2C946h6KzTovwW9e6XoQ3zmZww9bbPZwJQ9WSohvj5GbYGYMcSdkmzbui5vgJi7uwJanlPOdQSi0ldw1LlLZjhGgYQdGm+V8Byg9A1OgjOAQzCSvDZXOkx6cRAO/lv++FcOCO4kc4PiAAGVOQgkqif7GqXVXIhSEqHbqwsPnQvuasLIkFiO2msNI9pbxDjTnz5D8M0tVaJ71WN/k+Mjy4TgOSpvsFvx7eKKF5r2ho+yhJampHQumgTv1Mmjnh2iJ0axrInrDXxmVhJXE+FBklKNi8T5BW4us6J7DoGBtedztFX44o5mnOq4ggG0agOb5lO62jOVHHn84v4oTv+Ev1cIhlB6eyfxFP4oluyPNxi5JHi29d+Uxe8dHCebEObMtJ95FhgG7Tky
 GQCNDGpY
 8GvUz6WR+GfGabOsWTlx+AuMe1w0iXawTRDYTwn5rI2Mvz9JJJtBC2EwgLmza6tL1JV5dyv9+51+i5xvCWgccb1QFztP80yX1sVAZdBbcZm873mOKlwPEKPmM7+TJYPYsPj1mqCefesitJ9coMGU+ZSwuI3nPlhdw5RczQGwoqwmV8cL2afjTJRBX1cFbBjMP2NL4l+05qwTjaznj+jaSkhY2x34Rwx0lgjJtzxe3V4phLe8TOV1io+uFU7393JsalUF0627LnkPjxcxGtQ32PyYzYH1Jns/uNcgEp0v0uoyTzkSEfsuOfJg93XKF7oPdKGseJuHJeoUaK/waWY1tKAKkdazHUm1uT0mxxcud9xbuy8hZIBkf8KGey9zBfnHTqRj2+Ta0bYXcGeNRpbsgp4cPPT8qow00S1B9ATW0PeSDtzEnXTxIDFdpQCbZis09fj8hmA8upP+E+zbbEk2m/7zFjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/25 04:21, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Disallow kprobes in ___slab_alloc() to prevent reentrance:
> kmalloc() -> ___slab_alloc() -> local_lock_irqsave() ->
> kprobe -> bpf -> kmalloc_nolock().
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

I wanted to fold this in "slab: Introduce kmalloc_nolock() and kfree_nolock()." and update comments to explain the NOKPROBE_SYMBOL(___slab_alloc);

But now I'm not sure if we still need to invent the lockdep classes for PREEMPT_RT anymore:

> /*
>  * ___slab_alloc()'s caller is supposed to check if kmem_cache::kmem_cache_cpu::lock
>  * can be acquired without a deadlock before invoking the function.
>  *
>  * Without LOCKDEP we trust the code to be correct. kmalloc_nolock() is
>  * using local_lock_is_locked() properly before calling local_lock_cpu_slab(),
>  * and kmalloc() is not used in an unsupported context.
>  *
>  * With LOCKDEP, on PREEMPT_RT lockdep does its checking in local_lock_irqsave().
>  * On !PREEMPT_RT we use trylock to avoid false positives in NMI, but
>  * lockdep_assert() will catch a bug in case:
>  * #1
>  * kmalloc() -> ___slab_alloc() -> irqsave -> NMI -> bpf -> kmalloc_nolock()
>  * or
>  * #2
>  * kmalloc() -> ___slab_alloc() -> irqsave -> tracepoint/kprobe -> bpf -> kmalloc_nolock()

AFAICS see we now eliminated this possibility.

>  * On PREEMPT_RT an invocation is not possible from IRQ-off or preempt
>  * disabled context. The lock will always be acquired and if needed it
>  * block and sleep until the lock is available.
>  * #1 is possible in !PREEMPT_RT only.

Yes because this in kmalloc_nolock_noprof()

        if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
                /* kmalloc_nolock() in PREEMPT_RT is not supported from irq */
                return NULL;


>  * #2 is possible in both with a twist that irqsave is replaced with rt_spinlock:
>  * kmalloc() -> ___slab_alloc() -> rt_spin_lock(kmem_cache_A) ->
>  *    tracepoint/kprobe -> bpf -> kmalloc_nolock() -> rt_spin_lock(kmem_cache_B)

And this is no longer possible, so can we just remove these comments and drop
"slab: Make slub local_(try)lock more precise for LOCKDEP" now? 
>  * local_lock_is_locked() prevents the case kmem_cache_A == kmem_cache_B
>  */

However, what about the freeing path?
Shouldn't we do the same with __slab_free() to prevent fast path messing up
an interrupted slow path?

And a question below:

> ---
>  mm/slub.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index c995f3bec69d..922d47b10c2f 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -45,7 +45,7 @@
>  #include <kunit/test-bug.h>
>  #include <linux/sort.h>
>  #include <linux/irq_work.h>
> -
> +#include <linux/kprobes.h>
>  #include <linux/debugfs.h>
>  #include <trace/events/kmem.h>
>  
> @@ -4697,6 +4697,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
>  
>  	goto load_freelist;
>  }
> +NOKPROBE_SYMBOL(___slab_alloc);

Is that guaranteed to work as expected without also making ___slab_alloc noinline?
  
>  /*
>   * A wrapper for ___slab_alloc() for contexts where preemption is not yet



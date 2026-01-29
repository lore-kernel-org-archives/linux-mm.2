Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 285A6D358E0
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 08:29:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7888B6B0088; Thu, 29 Jan 2026 03:29:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75CF96B0089; Thu, 29 Jan 2026 03:29:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6352E6B008A; Thu, 29 Jan 2026 03:29:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 51F136B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 03:29:26 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 127AF1B1585
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 08:29:26 +0000 (UTC)
X-FDA: 84384327132.12.70EE260
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4D39DA0006
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 08:29:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZTAUKNzf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XEYImBHF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZTAUKNzf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XEYImBHF;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769675363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K71mXjgjkR+NiF1emSityIsaP4EVwHNubc2/9h7YqhQ=;
	b=aKfMKz2juP/RWkzfZWAEe74wHB9keCikgZqLzVT3RRJ2pgZbfPVw3F6tk39qmKEK1JtwdE
	zqQKh9lMa+Gesj5cotsCfxnaGnFkjjKvQFo2ewXRRSB9DNjwT+n7DSvj6SDpVwM2U6PAbn
	TdpmYDQSBk0WPXQOzKkDSDySg3fczrc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZTAUKNzf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XEYImBHF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZTAUKNzf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XEYImBHF;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769675363; a=rsa-sha256;
	cv=none;
	b=VK4ZLaKHzjBPaabtARJflfQrXHqBseMgOPnW9RRUCL990mNhidoGJEFIVCG9NWPv9CbgrG
	b3AgIQds0uzSynScirkgVdrxFKr9bCLDz5P+tFtk7FxKo19Jz0wX3hEEC+ZGdZJV5Wzo/m
	j3q5McN7pjbuvMmcFdZRp8BJEtKQvDA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B630C5BCDC;
	Thu, 29 Jan 2026 08:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769675361; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=K71mXjgjkR+NiF1emSityIsaP4EVwHNubc2/9h7YqhQ=;
	b=ZTAUKNzfep5Epo9C3B4J7FTkrKx2dTfMbPPNv8fekUPvi3ZEFlodHq+3ARRX+++oQpmqky
	FA8bO5SZhTR0hXTRSh2FEDvTEOTZpCf6Ys+jME6RQdZcGGFegPY2EYR6njXTKlb2hgbc5t
	zhnoExU9fcMhHCswEF0JQ+Ur5FGWTYI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769675361;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=K71mXjgjkR+NiF1emSityIsaP4EVwHNubc2/9h7YqhQ=;
	b=XEYImBHFdPBVineJNXMW348jfK339Kk0tSF/jL1/7GPjZw/44alTSz5atiIZz88Ig8hHqJ
	svLSE9RDDEM59BCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769675361; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=K71mXjgjkR+NiF1emSityIsaP4EVwHNubc2/9h7YqhQ=;
	b=ZTAUKNzfep5Epo9C3B4J7FTkrKx2dTfMbPPNv8fekUPvi3ZEFlodHq+3ARRX+++oQpmqky
	FA8bO5SZhTR0hXTRSh2FEDvTEOTZpCf6Ys+jME6RQdZcGGFegPY2EYR6njXTKlb2hgbc5t
	zhnoExU9fcMhHCswEF0JQ+Ur5FGWTYI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769675361;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=K71mXjgjkR+NiF1emSityIsaP4EVwHNubc2/9h7YqhQ=;
	b=XEYImBHFdPBVineJNXMW348jfK339Kk0tSF/jL1/7GPjZw/44alTSz5atiIZz88Ig8hHqJ
	svLSE9RDDEM59BCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8A8B23EA61;
	Thu, 29 Jan 2026 08:29:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Ua50IWEae2m/YgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 29 Jan 2026 08:29:21 +0000
Message-ID: <b2508639-251f-40ed-9c0d-14b7b128f40c@suse.cz>
Date: Thu, 29 Jan 2026 09:29:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/22] slab: add optimized sheaf refill from partial
 list
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>
Cc: Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-10-041323d506f7@suse.cz>
 <jgmmllqopl4rpihfe4jdnuifzexlffef5gehsocdcdu2xdj62j@xuz56etxseza>
 <aXsPoPXvAWoSizCq@hyeyoo>
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
In-Reply-To: <aXsPoPXvAWoSizCq@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: mrtp5f41oufzqcs5bybiuo9ptsshpzn3
X-Rspamd-Queue-Id: 4D39DA0006
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769675363-964196
X-HE-Meta: U2FsdGVkX186ph2YBZP66QbsdnZnI4uOfjnge68K3h3vxkQbCtWqdSWYXsAzjnZ0qvk6CRrOiCY03uAMzMx0I6A1BMh9zeA6MKBqaDl3jmA0rauc1K626TaYJtLN9Eg0R1lj+x2gC2xwK4b8HBWBE9bD/K5vp3UEM6ghsuUkOBUMsT0RYBzQqXcXEvoO6wi/aoEITXUuVRsKXxI1mcVHEfchsBoivo157YlsZf0VSwu4XECxq0hIF+YllBKrA4viytcxym3ajKOPOn+174AuDE9zd5oZHaf4G6444S0HyIUsowjvuy9eJaCQ87/dB2BliE8F3ofIr7f12s/yun1Mj0olcMdzfI0uyuokyem3RgzdUxFFa4MbAP4LlYcEdt3NeX7seyjTgNAM/Q0ujbDGEknF9jLL30TBBcaUb4VUjQvoWdoo+YRvNeZng2X4sr//OV0KGyKx2f6RM21LKkXStaaBWsj7Zi0opVP6OCkDLzs39+ifkMKb+c0yImravVssWj8Fme6QuskRAMdHRvkzgjKyqnxMsJv3S39+enByujbVPQCLyU0L9Km47ZouEn+Ap32OfVfXHmLgZWt3soRO6QTBYuQyMZuNxLd2ZM4cJ4LJokT222sfIgo40D8cRFIoUHUKgk4Q3djCpHAUagtgn00XwK+5vLLFf7yhS7dQR5pwV7DLcfvymqKUw0F/YTaWwhSQz6FiotMyX1yGryvtBP+VAzLDmDoity34Lth1Otb8/TtWMPRWco+899mQroAUGCW5XKoI8dSkKRZqIhTln18nly5cXBwopm4w2WYKn8mHlpI7og30Agw/71sofELb/C+I7kWLxgOOBF4yJqVcG3tKKjn+hcvM6j4FYkd5dhs6EB3Mj+D0Vlzn3qEajxrzvzPGCf/10yfmW9q+rCZknZyYpnKECjRv9ZfpjyH/48j/1Eg3dWp3mUs3CsLrNkcjTU3pJHmyqx2aEfozW1h
 pMDeeDFR
 X6jraL2noG91TBocaXc8gp5Q7xq0Non13QPE0ZqATGlMczzd6Po7Cp1NR9NzsqdTbH32ztog6qyHyXEkazTuqxNPCGYuDCJCLU2SjBF4OUhniWTWVJ/BqPVZkPSQc0dzXps2LYinmPG+T3vgSXcxoJ73CNhS6fpoQJ34C1uYDdd4aRj0YK4KRXtFw3dXLKZR8doF9viO3rWZAxo3dvYs1Zpchhd+DX5aabVVxD4ofQJGm4PP0kn8fYwXIYH0+6qAqHztBVaHDCstxVKfvR8uBmghFIqpO8xhN2WoI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/29/26 08:43, Harry Yoo wrote:
> On Mon, Jan 26, 2026 at 03:12:03PM +0800, Hao Li wrote:
>> On Fri, Jan 23, 2026 at 07:52:48AM +0100, Vlastimil Babka wrote:
>> 
>> Should this perhaps be WRITE_ONCE(slab->counters, new->counters) here?

Ooops yeah, thanks!

> Agreed, this should be WRITE_ONCE(slab->counters, new->counters);

Thanks both for review!


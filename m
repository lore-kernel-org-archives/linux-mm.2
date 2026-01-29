Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F056D358E0
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 08:25:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC1F86B0088; Thu, 29 Jan 2026 03:25:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99A96B0089; Thu, 29 Jan 2026 03:25:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A2C16B008A; Thu, 29 Jan 2026 03:25:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A4096B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 03:25:24 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 26E98C17DE
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 08:25:24 +0000 (UTC)
X-FDA: 84384316968.24.A134472
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id BF05D40005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 08:25:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FmjRXzo1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=o3oFo3+g;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bBRYT+tH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8rjM4Lsj;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769675122; a=rsa-sha256;
	cv=none;
	b=fy5znynOpZlMHy16lo9Cprmn/9um6TZ8Bb97f6JZgYc0DUbzzPgLKav+76Hj6EtHjm7VeY
	Nikd71khrvG2xqPkl94r6qdwq0G2ru2W2qDbP/bmagzr2D/2dtxPuoTcMDdrqoP/c11/SD
	uOcZUjTtJMSP6+y5o273/R4Kjkqyygc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FmjRXzo1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=o3oFo3+g;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bBRYT+tH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8rjM4Lsj;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769675122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CMS5emY52BtnPbbiJqj2WVHvnKPATN/p7rC618G6cXU=;
	b=thIfdjTrvDs6ITPfieHepQ5QoidR9qoWLduRT/VxO0ZsEMQC24VcRlgOh4sesnxuKsi3NL
	0jr74VdOzFg92hJU4lx6DpSFIoekKf+xm4hCWqVDxLoVMpxkhWPnD02KEEhHVc6dRQdyRp
	2LaY0yEl/vLtNjZ4mc3qrNqq3OesHik=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 01C403402B;
	Thu, 29 Jan 2026 08:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769675120; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CMS5emY52BtnPbbiJqj2WVHvnKPATN/p7rC618G6cXU=;
	b=FmjRXzo1wDOV/B5aFUs7XaHaqH1dJz/4U1KvfOE7aSgtgBHGTAFknLzd5EdYYFGxrEJXb+
	Sj3r1gbG/4lrzsLd9vda0WqbXbCWe3IuHbPdc3cLqtYdUfAgMiuqBnRcBdDh8MmkKxTubb
	8UyKCBuaobYrkHPcDSs9mEIlkUgQ+8k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769675120;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CMS5emY52BtnPbbiJqj2WVHvnKPATN/p7rC618G6cXU=;
	b=o3oFo3+gGwYGr8zY1+kbr3FcYMcFlrPO1DxtQZQiYalIpfVgIynAguV/81MYlQUzQulp9I
	6KfG6fuffYvyulBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769675119; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CMS5emY52BtnPbbiJqj2WVHvnKPATN/p7rC618G6cXU=;
	b=bBRYT+tH7bPSf52Ur+3FfDsk5sVxk1AzPIpP5uH6esgdVvs8VgLw0u4eKVX7Bzj0cEoTDO
	FhjdpCGe27u08VpvTpZeVrHhmAXt4fywLKJQY2t+amUNviScoV3xfa5lZ6dKwEfB2WLXlw
	kUiW0QaYz78gax4vB7O7Opf7v/6br+U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769675119;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CMS5emY52BtnPbbiJqj2WVHvnKPATN/p7rC618G6cXU=;
	b=8rjM4LsjtxxPTqr7R9cfk1bclBJ33YakLLmTqDlhAhBDtvYnbSrR+QgCp7lGAok+Mb6nuU
	4KPnbWWzZyagt6Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C8D0A3EA61;
	Thu, 29 Jan 2026 08:25:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HwewMG4Ze2n/XgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 29 Jan 2026 08:25:18 +0000
Message-ID: <effcb710-122b-44b8-91d3-5cef727ad4fa@suse.cz>
Date: Thu, 29 Jan 2026 09:25:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/22] slab: make percpu sheaves compatible with
 kmalloc_nolock()/kfree_nolock()
Content-Language: en-US
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-8-041323d506f7@suse.cz>
 <7dk5q3mbusqlklpk3ja57upbhkhhg3bpueh4nemuthesmwpgnk@zkk4fqug3cwx>
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
In-Reply-To: <7dk5q3mbusqlklpk3ja57upbhkhhg3bpueh4nemuthesmwpgnk@zkk4fqug3cwx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BF05D40005
X-Stat-Signature: d53muni6kd844o1jxer61bgt7z91bf6h
X-HE-Tag: 1769675121-985762
X-HE-Meta: U2FsdGVkX18Eod4KblAOsUOQUTSrFOX0bdBbE3nS9fmPpSfYHaGDh7qjHLhM4snrSOEXxeIdEbEdCsnqnZ7YzGFZ8+Ne8L42txFZuAtCdQjmFFPfhOycHt40qLklnDoBGlhklDwoWDYWlaP3JRBFfEsnuCIKXqDTcAFSNc8xWymCDIoUJfX1gRh2+d6f190kQxo5qqJDKLwJLsWk9/Uu2gOU08GBLmoQY3L3+l7fFVBcyj6JK88HB5JzcDiP9Z8V7mLPvsyckXl7X1Jg4EtnQKKDCV8f6om4mLDP6HCudYIh3aSRYhhtaM27u5jKgiqcLEIBVqyaltTFw+nY+UH5MJu6Sb53XFOH7nLQSHycolCdI9fl38GFdie1N/4svvQuRcfpNMAr+T+icD7n8sl5TxF/MoZN8rXjDptFd9Sdj8Xg1KvMvmOmsJIR9cHc+Gftq/8EeZufQFOkHx8jbSvBIHAWoxQzFB4TmQQrhfnhvRhh2FfeVWC8pS0/DLZ//ILw2XHI4D+AnB6hDkJMAFg3IVaE5I+qTOmYMtXb3w4Ce8CWj3Sr3+S1ELdwW2yqIVSUtgSD431GLOgDnz7rTZ1eesNIRm+vK0NhH9Q/4YVzH2kkvB+Fy6kDJRCVIVe3/dIAdS2MxOUBj51s6tlVcS0Z12tPbXVJOpfbgXFFqByxQB+i5r8JSbelioWj/J1/zfVNNz7cqjxzj4StgPq/416yte+svS1Skm4sRYSg1xFfEAS8Vq4q65JB4k3hXvzRq/CFA3RVCZ8rRUTvy4MY9egCdQCpd962ovaGOnqPTGNtIhy5Z+8hJKqYJc7wJIKp8btkWckLp1/rFaPpwmDgj4WZz14K2VKqN3C3jHGWD5jGQXmUXKP5nwfo44gslergN8GD8c3w56mM0b7ukJ8na2QdAysEbFNTxGEWFtcjYg0RmMcSfR02c51xR4YXtgujt5/bVZPCz8Q8mjeUYmEJ8XX
 EM+ehyTN
 LEibcq4ZnrwWJ/Whzy8v8jJP8Kq1T+Yx6SEqsgJEvQ6phgmM/TEdlyfA8B+hCs8pbyY5EvlJ2M8mBeTpa0K54HiPoo323z0na5hecfkCDKe2u0mv+eYDvXBQ5dNwQD4408yd4NHaV1yGueiyI4UW/ESy7c0ClKP+RxQzIP1X4WkXqJb8bJpdlm1LpjKl7e6eCqSwvMqE6srMCMAZafaYBZZlxiAh1adipeSk2HkNbbmFlwXLKmdKf2UIWdNEJARq/ru/AxsbhheZ+llGr1Pdf4kRslAiJZlsLf+uqrYu3DqECiAQ4iSrikkNY6BLdWrPXgh7D9esyhX7UQJk4F/TgGMgCroDEaMeXnC+0IudSCdIuBh6EeipQ8ZUxTcUHeRaUv6La
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/27/26 18:36, Liam R. Howlett wrote:
> * Vlastimil Babka <vbabka@suse.cz> [260123 01:54]:
>> Before we enable percpu sheaves for kmalloc caches, we need to make sure
>> kmalloc_nolock() and kfree_nolock() will continue working properly and
>> not spin when not allowed to.
>> 
>> Percpu sheaves themselves use local_trylock() so they are already
>> compatible. We just need to be careful with the barn->lock spin_lock.
>> Pass a new allow_spin parameter where necessary to use
>> spin_trylock_irqsave().
>> 
>> In kmalloc_nolock_noprof() we can now attempt alloc_from_pcs() safely,
>> for now it will always fail until we enable sheaves for kmalloc caches
>> next. Similarly in kfree_nolock() we can attempt free_to_pcs().
>> 
>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>> Reviewed-by: Hao Li <hao.li@linux.dev>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> 
> I'd rather have a helper that _mayspin() or something.  That way, when
> we know we need to or don't want to, we avoid extra instructions.  We
> can also avoid passing true/false and complicating the interface when
> it's not necessary.

Can you elaborate a bit more how the helper looks like and it's used? I
don't follow immediately. We do have the helper for checking gfp flags to
extract mayspin, but that wouldn't avoid extra instructions so you must be
thinking of something else.

> The way it is written works as well, though.
> 
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Thanks!



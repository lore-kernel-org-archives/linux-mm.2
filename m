Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40573D37E37
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 14:05:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DD9C6B0088; Wed, 14 Jan 2026 09:05:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B3D26B009E; Wed, 14 Jan 2026 09:05:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B3736B00A0; Wed, 14 Jan 2026 09:05:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 49FFD6B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:05:40 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EFEE4140549
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:05:39 +0000 (UTC)
X-FDA: 84330742398.09.18F5E5A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1BC8E40010
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:05:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FS5BqfKk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tAT9MaKn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FS5BqfKk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tAT9MaKn;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768399537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7C4MdemR39tmXRA9yl0PqmV94vggPiQ1JGGHQvEbWMs=;
	b=mKX/5QvSqOucDAX7uz+do+IErNHoDhKE7WiBnrUpu0CIK1SjIEEXWmWjw5jibS0LNp72Ge
	Cwc6LbpFZxW2UBFJq6reGCjwBDfyf861FVAj2wjKlw8QIOJMZhdRv/gr2D25OoOsT8i1eU
	7HJvttn8YxVJXMTEL7bVs/ZR+El2EqE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FS5BqfKk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tAT9MaKn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FS5BqfKk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tAT9MaKn;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768399537; a=rsa-sha256;
	cv=none;
	b=A81aTRjWtI8KCUTYsp4+L3v0sp8NL/5s2oai2nJzD3oanQc4XuAFMNMn0p7KiPXd77Jijq
	MqHsepP5OPd2QgYclJSyNXWdk3W3OMfYcZmtk+5viWNdHfj3358KBlRW7cqnZFTxF9LjA+
	b8O7Uxe0TUmaUcSWRVN8aORm7QJumxA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 541695C832;
	Wed, 14 Jan 2026 14:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768399535; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7C4MdemR39tmXRA9yl0PqmV94vggPiQ1JGGHQvEbWMs=;
	b=FS5BqfKkS561EJ/5Zl2nUjX3n/PdgVOOmZ4Bl54k6lUEYIGgk3JYEa8DJJy2CNjd6KBl7/
	qOISaZrOyFAC+U8thd/oyPioqordlQhnaFJQPpeaKP09HDbBSK+54qH/tZfnDxvPtTveAU
	WuGVXVQdCnrnCRKjPovOPVDRlQr+NDw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768399535;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7C4MdemR39tmXRA9yl0PqmV94vggPiQ1JGGHQvEbWMs=;
	b=tAT9MaKnICwwrpVPLeiYCCY+ryZve23Hsgk2WXsbleQlrGufbCbCpRZpVbWUOWEjiRGC7J
	7hOwg7slDDYwCuAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768399535; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7C4MdemR39tmXRA9yl0PqmV94vggPiQ1JGGHQvEbWMs=;
	b=FS5BqfKkS561EJ/5Zl2nUjX3n/PdgVOOmZ4Bl54k6lUEYIGgk3JYEa8DJJy2CNjd6KBl7/
	qOISaZrOyFAC+U8thd/oyPioqordlQhnaFJQPpeaKP09HDbBSK+54qH/tZfnDxvPtTveAU
	WuGVXVQdCnrnCRKjPovOPVDRlQr+NDw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768399535;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7C4MdemR39tmXRA9yl0PqmV94vggPiQ1JGGHQvEbWMs=;
	b=tAT9MaKnICwwrpVPLeiYCCY+ryZve23Hsgk2WXsbleQlrGufbCbCpRZpVbWUOWEjiRGC7J
	7hOwg7slDDYwCuAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2510B3EA63;
	Wed, 14 Jan 2026 14:05:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DBFZCK+iZ2mlNAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 14 Jan 2026 14:05:35 +0000
Message-ID: <d8d25eb3-63c4-4449-ae9c-a7e4f207a2bc@suse.cz>
Date: Wed, 14 Jan 2026 15:05:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 06/20] slab: make percpu sheaves compatible with
 kmalloc_nolock()/kfree_nolock()
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-rt-devel@lists.linux.dev, bpf <bpf@vger.kernel.org>,
 kasan-dev <kasan-dev@googlegroups.com>
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
 <20260112-sheaves-for-all-v2-6-98225cfb50cf@suse.cz>
 <20260113183604.ykHFYvV2@linutronix.de>
 <CAADnVQK0Y2ha--EndLUfk_7n8na9CfnTpvqPMYbH07+MTJ9UpA@mail.gmail.com>
 <596a5461-eb50-40e5-88ca-d5dbe1fc6a67@suse.cz>
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
In-Reply-To: <596a5461-eb50-40e5-88ca-d5dbe1fc6a67@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 1BC8E40010
X-Stat-Signature: 4af5757u5iz8bbiy9kzxp8o8hpogbruo
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768399536-942156
X-HE-Meta: U2FsdGVkX1/fB7Qr3yBZ3aOvQI8Pdh/lmf48H1IYIT9fBAmiyrAKkqLCWn9/vnViQPHSYnr2FN4VQ4fgiZgrZ3vb4fhsTTCyzWhowV3MkiAo7NsKEr+rCodE/vOE4BtR/A2XNDpMhpwk0w/KZmopqEM2rK4eEooMSSnLjpG9amodEe8dkAHtYtHZh6ucyjm1wod2GuGuUnHsNdFCHw/TEW5oDbqCSQZ8B+KvCknXCv5/oV4TI+mxDQzbbXmvwIMYnF4IWM5ncXmaYA6DYU0dea7AUcyhhre2leSp0czQS8/K64sbYrnvlxPDkdVa+3GoW62K35/lzrlJ2OOTDWqDE7ja6zJO6kZCxQcstqQ1KF9Wjcsg/T+IJtHhXeHboS+vdurs8tU1NNyOnfDgEWswerZ1UwCIqxjw6nJBqJT9QwyE+ObebP/6Dvon9tVwLEs1xsW5aO5fW0884BKAAs0uLv8ganOQq+rKCebyFw07GnLp+Q43D0ypZrOFmggq1OinehuXr6JMF4r+f/UcFzMLYtMPItUeiB16b1A8XP0tKqT+jHGsYsYzDSkNR0m8zKh7f9ofv56m2IMBXe7WcuZ++lYQV5dLpYGim/srZ8D8c5EWtPPE12vcyUS/ZAv93EYcEUXB1HtORYTg17L4pNneqdO/HvKVUR27qurNp+cirhseYdVkoR4mW6yGREH/mga/r8HDB5Yr2siW5YVg7+/JJwksrenGhhoBjmI/KFzmoS7jv6JG63wRqPjp+jvgE397seE/9zkWjmswpNK6otyhdTSH/9mwzsn9QfBZGd297gXFTre8UfgYjSSZUz6E6dkQ/t6BiyOHcj75J19wiOHyJNkJsdw8tPxRwwDT5eHERceeDQVXuqkVV/OpGq+phq4IgOn+/gQnOT1Ho4bz29pBcg+GRwZu96W1De8p5tMolRY0F48hDMlr4c19VFLVKfoKafI3tL5ic5oJbifmsyb
 A7XiV6GF
 qtPyqph6misuWLugFkHtm7j+Y+1cLuPfkvPMDOYWnkzrLEQnifUYi9TtTin71gZQFXdQYEWVqIONHKZWKsXxiSF06XgVTl5Kcrea01WLFmzLs63g9WzfBJzgXWq1ClJupv5g0kIBgEZiHKLlSCMnQXS11n/ykbNU2RVwBLpqnIggNZKpl7iuxz3+nsltWYfusIJHlX5oFhdqjIzyHoko/aUAnNGkydQ8izLtOkmIh/lWKTVapqjCdY/LDEjc9ClsbvkBX4u41F7d6Vl7nBfuOwI+TVjIHb0HU/ffh7uk3KBE6MdRkMOlmiwxNJlhLl3vkvgMkwsvla6gBYXxBi2HKVmGu8fMAbSJUaezaf43XD3FatvzMyhaIjI66nEMYQfqWfn1yg+13qhSLDJEljtVabNCNGGKUh2cCTnTYC3QF1BZz125VURgDcx2ep0apD/ID2rMOMHdVfwFsR7/YAwRIT8fc6Uyexz6EaUYn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/14/26 14:57, Vlastimil Babka wrote:
> On 1/14/26 00:26, Alexei Starovoitov wrote:
>> On Tue, Jan 13, 2026 at 10:36 AM Sebastian Andrzej Siewior
>> <bigeasy@linutronix.de> wrote:
>>>
>>> On 2026-01-12 16:17:00 [+0100], Vlastimil Babka wrote:
>>> > --- a/mm/slub.c
>>> > +++ b/mm/slub.c
>>> > @@ -5727,6 +5742,12 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
>>> >                */
>>> >               return NULL;
>>> >
>>> > +     ret = alloc_from_pcs(s, alloc_gfp, node);
>>> > +     if (ret)
>>> > +             goto success;
>>>
>>> I'm sorry if I am slow but this actually should actually allow
>>> kmalloc_nolock() allocations on PREEMPT_RT from atomic context. I am
>>> mentioning this because of the patch which removes the nmi+hardirq
>>> condtion (https://lore.kernel.org/all/20260113150639.48407-1-swarajgaikwad1925@gmail.com)
>> 
>> Right. With sheaves kmalloc_nolock() on RT will be more reliable.
> 
> Yes IIRC Hao Li pointed that out before. We'll be able to remove that
> !preemptible() check that we area about to add by the patch above.
> 
> But I'm not sure we can remove (or "not put back") the "in_nmi() ||
> in_hardirq()" too, because as you said it was added with different reasoning
> initially?

Ah right, it was "copied" from alloc_frozen_pages_nolock_noprof() where it's
explained more, and AFAICS will be still applicable with sheaves. We should
add a comment to kmalloc_nolock() referring to the
alloc_frozen_pages_nolock_noprof() comment...


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B99AD4A607
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 07:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C7206B0088; Fri, 16 Jan 2026 02:24:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 475396B0089; Fri, 16 Jan 2026 02:24:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34D5B6B008A; Fri, 16 Jan 2026 02:24:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 24AE16B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:24:09 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9B6638BF98
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:24:08 +0000 (UTC)
X-FDA: 84336988176.12.5631779
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4662D40007
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:24:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OLUJb7Uk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CP8d3YEF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YhgNMuFF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7p5T4iVz;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768548246; a=rsa-sha256;
	cv=none;
	b=x4gtHKM/w8akEjZlRe/NslllnCS2zlaibw5cDmhRyX6egvvlV8b3mvDRrO2FyT7uwlsi0E
	hH3xYbmVZCKHeLSbpe2wDPv/8nHiRnIOCZ4m6ChdFBkpxrpKjF2NJ3zD/YkEuEgfNZFONo
	cX6/HV8l2C7XvpQWVWVN7JKxipzmGi8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OLUJb7Uk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CP8d3YEF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YhgNMuFF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7p5T4iVz;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768548246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GPiikwMqJqiuLvHyDiQ9rmcag8VASTg2rI5qe5VsjEQ=;
	b=FdusiugHCMDfHbF0JM0jJKJWQBHgQimqIrShZ11iXpLW3kxnkFNfK3zZlU3q3ScT7Y8uSx
	onK6Rvh3aakeXpznrfOATuPoFXeeTFuUczPga1S56lsgOAzySqjuQ7vZfvKkR/VcH2C73e
	r0FkjaAt6WC53fYdIT0YaLuRphvuuKs=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4A5623368D;
	Fri, 16 Jan 2026 07:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768548244; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GPiikwMqJqiuLvHyDiQ9rmcag8VASTg2rI5qe5VsjEQ=;
	b=OLUJb7UkkEMlqEq4/aKm5RIEHyLXzViOa+m5BU3WcroqN9ykpEzjk42ytSyeSyX8OF2/Cv
	lg+StfTSII6LcxnEYndKrwKgHOyoKwf+QKT4zg1FHGbwujIRUASoo+sDyZXJUaNc2RMfKe
	9dqwzk4BYtW4/nFNSndldCNxcDT7QBs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768548244;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GPiikwMqJqiuLvHyDiQ9rmcag8VASTg2rI5qe5VsjEQ=;
	b=CP8d3YEF6wXu5c1Oa/4hixPUJ7DzPYpm6tAw0iqfw7KzDazHnV3CRia56j1O4QTb9Lao/K
	fuGNPGuQ3aoS/mAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768548243; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GPiikwMqJqiuLvHyDiQ9rmcag8VASTg2rI5qe5VsjEQ=;
	b=YhgNMuFFnIOZlewqU17I/agERHDLAD7DUrBK1TNcSvDMXnnA8U68BjgljksypyYxEJGe3F
	ZJMcdtHZhh08p8H/sxnNYF+696DJ2hAIMdULq9VonM/F9Bjgns1bhsk03GqrxgjU4WXCbR
	nDl09sG0Bz52F5+A66ZYDpI8jYKt6s0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768548243;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GPiikwMqJqiuLvHyDiQ9rmcag8VASTg2rI5qe5VsjEQ=;
	b=7p5T4iVzc5NhW/uml1ddBQc6+7+6DkABM943X5gaPEAqWPIXcGdTuyhfEjOnH+4XnkRJsW
	4EiG29bmka1ibgBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 260CD3EA63;
	Fri, 16 Jan 2026 07:24:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iiuTCJPnaWkFRQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 16 Jan 2026 07:24:03 +0000
Message-ID: <4e73da60-b58d-40bd-86ed-a0243967017b@suse.cz>
Date: Fri, 16 Jan 2026 08:24:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 03/20] mm/slab: make caches with sheaves mergeable
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
 <20260112-sheaves-for-all-v2-3-98225cfb50cf@suse.cz>
 <CAJuCfpHowLbqn7ex1COBTZBchhWFy=C3sgD0Uo=J-nKX+NYBvA@mail.gmail.com>
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
In-Reply-To: <CAJuCfpHowLbqn7ex1COBTZBchhWFy=C3sgD0Uo=J-nKX+NYBvA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fxikzjok8n3463t8i1jniic3gxs3xyrk
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4662D40007
X-Rspam-User: 
X-HE-Tag: 1768548246-884964
X-HE-Meta: U2FsdGVkX18OWzqv8z652i4hA3alhHRSjGfUNBYgYcaRnOmIioECUOEUx91hAsUplAF3LBP1iNGR682DxdrJ1DI2KE7zjR91xXXn3NjYAOH9dCaEYLM3gIuo0nR4GDdtplrcO8yAqiaGSNiPzqltBZimp+SJawgAlvOyF80s/Ymry3HKcj52GfwatUEkzFFhRoueNFPvJ47lY3y7kvjUawEGE8g92qJZEpraDZluLmeoarcHKIWmQVRNxSvbY2U1EmJF6WXZUPeaJdZFuV4/EDay3Giz7qqzIpneLwh6cTJA9aakv9W+iPy8DvexN/4mjK5mYozjFgq6iJxTxTXul9/m9NQOR75hJfRzxx1pz2y82i7m+i6ZR0WVPRPPqd0xFgUClI7Nbi5OQiEl+dpuvg0KRDGLIem6lM5ildvQ8zVeW++wQKC7jBihTCh3FiKsKrld8G0CAcc5QM1xZfY/8kG/Qu7/kG4liS6sMrf2NzIjsiqduM8MHBSOx4q9QxcxiBlRzS8xTeqSriChXzZMY935+trHCxZPuwkke3s7ErFPGfXPi1w6UPpeRH68AFUPyrc0+ZTDHd1KYEcQC/XafNBHLCpeoATwxcf86zauT6j6ANaECfm+9v24TPA+sRNbYxBX0E6ucgAWUcmrtQMJnUZ4R1IuvE4+FTWhG0tCc5Anewe1MmA2wAqBtq+7pqzADtF+ENj2IcXs/L/BMUltSBuEX7y2e2qWiVk7MC8HzBDB+pr7oYwEEMvdHsvO9QixZljxHyxi9L2C32H/YX+qA8sGW48EYj+Q4IH9X8toXgAFmWU7cBoikHlvGVx/aT0xE9lSZjuwwdk/9vbBhAn+EFcBMUUjG4nskfIh2Nm63W1GukkrNHAeI4thZ+tvQEyMr0/apMUvHdZaFMNFf57A/FzkRlHZKHZOq/wfn47IxBtr7m3+NkH85CBdTx0mmxdzCGFAKpXKbRAYckz5uLB
 rsql7yJb
 pkRroumpHGfILhH83+WuEbAk8Sy1EEpdQVDuG5GkhvJyXsQ+3zHITePw6IN5Ck7f5flx5FnJQAY2WYWowqsb5aAx4Y4LEswTbCXRFbdKpem1QGn4j/go+VoJVupvT238+IJuCqEnTTWI4hVwnivEbSNBvPyUrpCVaMEvZbyQGhmJGzJeZOr0veHAUm3f+Qk/CO2SUMBJAHLT3FPyGi/MgwJXApiEOMlWONx+Yg8jXCJvYFx+jTdtKc5WO2CIvt8SjwWIKe+94rE7Fr0pd4PRkvWwsVqzZILpHfw2GhzR+xo3SPMZ8vggMBDz/Zw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/16/26 01:22, Suren Baghdasaryan wrote:
> On Mon, Jan 12, 2026 at 3:17 PM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>> Before enabling sheaves for all caches (with automatically determined
>> capacity), their enablement should no longer prevent merging of caches.
>> Limit this merge prevention only to caches that were created with a
>> specific sheaf capacity, by adding the SLAB_NO_MERGE flag to them.
>>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
>>  mm/slab_common.c | 13 +++++++------
>>  1 file changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>> index 52591d9c04f3..54c17dc6d5ec 100644
>> --- a/mm/slab_common.c
>> +++ b/mm/slab_common.c
>> @@ -163,9 +163,6 @@ int slab_unmergeable(struct kmem_cache *s)
>>                 return 1;
>>  #endif
>>
>> -       if (s->cpu_sheaves)
>> -               return 1;
>> -
>>         /*
>>          * We may have set a slab to be unmergeable during bootstrap.
>>          */
>> @@ -190,9 +187,6 @@ static struct kmem_cache *find_mergeable(unsigned int size, slab_flags_t flags,
>>         if (IS_ENABLED(CONFIG_HARDENED_USERCOPY) && args->usersize)
>>                 return NULL;
>>
>> -       if (args->sheaf_capacity)
>> -               return NULL;
>> -
>>         flags = kmem_cache_flags(flags, name);
>>
>>         if (flags & SLAB_NEVER_MERGE)
>> @@ -337,6 +331,13 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
>>         flags &= ~SLAB_DEBUG_FLAGS;
>>  #endif
>>
>> +       /*
>> +        * Caches with specific capacity are special enough. It's simpler to
>> +        * make them unmergeable.
>> +        */
>> +       if (args->sheaf_capacity)
>> +               flags |= SLAB_NO_MERGE;
> 
> So, this is very subtle and maybe not that important but the comment
> for kmem_cache_args.sheaf_capacity claims "When slub_debug is enabled
> for the cache, the sheaf_capacity argument is ignored.". With this
> change this argument is not completely ignored anymore... It sets
> SLAB_NO_MERGE even if slub_debug is enabled, doesn't it?

True, but the various debug flags set by slub_debug also prevent merging so
it doesn't change the outcome.

>> +
>>         mutex_lock(&slab_mutex);
>>
>>         err = kmem_cache_sanity_check(name, object_size);
>>
>> --
>> 2.52.0
>>



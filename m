Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8474DC44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 09:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA7926B012D; Thu, 22 Jan 2026 04:30:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E85FA6B012F; Thu, 22 Jan 2026 04:30:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D67656B0130; Thu, 22 Jan 2026 04:30:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C59C46B012D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 04:30:49 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 84B1B139D61
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 09:30:49 +0000 (UTC)
X-FDA: 84359080218.29.60E1AA6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id 110EE14000D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 09:30:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NiVWaxlM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qTENG00Q;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NiVWaxlM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qTENG00Q;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769074247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/rJjXQryTWxycH0kSD2vmf+7/CeUyLleKA6g8e7aaqo=;
	b=RvnLjaRbzWOF4wN0zcHOvfzcg1Twgl86m6d3CPjsH3zaB9jl7zD5u6H3U6a0KaKaM7/mZS
	pRT23sjJlajYM/Gq0+ESKVik+NLPuW+wQKIVoobUbu+tIFZQ/vtkUXsDvDjA7THi+eM0CO
	sJa7/rPE4lTK+M/vEHT2Ev4fpmsuh2I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NiVWaxlM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qTENG00Q;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NiVWaxlM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qTENG00Q;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769074247; a=rsa-sha256;
	cv=none;
	b=urUElYDo3tJFGCd/gjw2DW+Zkmb2RpOlrHSBo8s2FK+ElO/MC9e8q7oKDGRE79iUtlLJN9
	lkOlJyun6cyHdMN/ASJ9hzs1yGFMIek46Th69DCzexQqrubp6JMRvVy7Fhlf+1gvCAZjVE
	kg0W7vy4JOQPQJRq1esVLg/p/DeH7kY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9766A337EC;
	Thu, 22 Jan 2026 09:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769074245; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/rJjXQryTWxycH0kSD2vmf+7/CeUyLleKA6g8e7aaqo=;
	b=NiVWaxlMr7lM+WTCPDMSAtTbsqoEUTlY2BXEP25+IiRSWIbrSgmCkteB/qIFZSU+llTJDr
	6FX/OwDsLU7ufeCD7X4GolNHej+L+hwqc0KjlYRU7izs1u9/Wmsmm6ZPjheFULDGpFlH9d
	jRa7BdcI7vJ3VnUfYxK6GaIjtzFYLvA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769074245;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/rJjXQryTWxycH0kSD2vmf+7/CeUyLleKA6g8e7aaqo=;
	b=qTENG00QfMVs11xPUbNK+e+nON0gxLjpFH8MFc/NLVSTvkpaczlJMsFaoS1COlCzSEqVj/
	fv/dJP58BcdQVyDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769074245; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/rJjXQryTWxycH0kSD2vmf+7/CeUyLleKA6g8e7aaqo=;
	b=NiVWaxlMr7lM+WTCPDMSAtTbsqoEUTlY2BXEP25+IiRSWIbrSgmCkteB/qIFZSU+llTJDr
	6FX/OwDsLU7ufeCD7X4GolNHej+L+hwqc0KjlYRU7izs1u9/Wmsmm6ZPjheFULDGpFlH9d
	jRa7BdcI7vJ3VnUfYxK6GaIjtzFYLvA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769074245;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/rJjXQryTWxycH0kSD2vmf+7/CeUyLleKA6g8e7aaqo=;
	b=qTENG00QfMVs11xPUbNK+e+nON0gxLjpFH8MFc/NLVSTvkpaczlJMsFaoS1COlCzSEqVj/
	fv/dJP58BcdQVyDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 99D9213955;
	Thu, 22 Jan 2026 09:30:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ehY/JUTucWkoCwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 22 Jan 2026 09:30:44 +0000
Message-ID: <792c6837-137b-4667-8c4e-fdc988ae8878@suse.cz>
Date: Thu, 22 Jan 2026 10:30:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 21/21] mm/slub: cleanup and repurpose some stat items
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-21-5595cb000772@suse.cz>
 <5rmxfyxuhloucetufg2qic5elgi6frd7onjzdsosmhtjdqglij@5htmiqrdhkoj>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <5rmxfyxuhloucetufg2qic5elgi6frd7onjzdsosmhtjdqglij@5htmiqrdhkoj>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: cgmobca89b1emndcggz77dbp5up1ai39
X-Rspamd-Queue-Id: 110EE14000D
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769074246-631695
X-HE-Meta: U2FsdGVkX1/lhpmoL70pSm2TjHI5DtGZhxMNOSjIQmSOA+QcbeuqGVywr5vrWDt9V2BY6w+ttOTj5+WNho0LJGS7urtUFTw4m1JzLS+Hb7qE6PXx8gI4iTLpBpkYn/qa3vrgEzTqBR0QXv/321lqsfJ8RgQerE1TlQNN9uoRy2GIHByWQqyX+C1uvkcdUrx0NOc4ELSN5rxUXXNtfEzJ/ghkniyULvnPho3AKzjNlwik5N5cZmIUq5QmhNF6PXCb54iDN7ZreQ5Hh5imEKPHq+YZfkWzohMbDN5SEW1fj6OYk/Px1fFjD4APab58ekO/6KCIgrWFY1LjRBgFWd3GkkxWs0vtsPy9XLutPo+W5VxoTKcOkMjeVrzVrOM0elI05m2M00hOyANmuxq+IcHtFDQq2p231uN8bxQ3FZeoCiexLJpw/qOjAW8lHKII0cF0TCOEPnAHmAjcD8/7xaYZH001ySZ352yXqstPLFV254tjfo8p19fuPzY7WGE6dzTM3fr/lX279rZ8j4LvwCG3Qevc8BMQ201eifRMPrIrLbmFUzMQtnu9e1EFsX9vSmz8N5Quyn1+9T7FOmXFgd964atfotJrNZVQFZlSQFCGuovZygSlnfmhBzOdJwtMbBt6jevfpcjzT4hTClMEk3uBjvOQ1JGflsiZsDdsogE14Ny+AMA9ck0YJVrGQBQsh2UML2ulI1oL98MIfFWCGtKLxbQ3gWMWMR6qY1rBmgWuqUWXXbwiZdR3adulahhg5msoHKTGNaSY4U41o13WUbrCHzZw8G90pXmrdZ0uTXM3wREsgcxlOeLquCx3rbU7fli7VGzCUEHmlY2Ljdsg53dQJEBy9SCWxn3ON2kvbuQ8HIMToIGOcCF8+AsE7B+ux99ePJXuQS2SQnKCD9mdbsq1BLyKiVANbCtFHeQKkMdW7uWNfO+uwKfSMUN/YLqU5yAGTq4Z/fjheuhM+boDM6r
 V9XyFpr5
 8PVbQSTtEAFgh3pvQ4xygShFHf87+zMBeS2mXqbkfAQFWQAO6Ut1fUgafj4SLiQcOVPlyX7q9vPmDXPflgeiatVc1C4bfeTQ4aeP4n0hRfBivBfFxBWrL/AgcyZLz8u1R6b6yXt+6Sn4cPmc9D81HJ08pNJgJMMU2ETOjFXThFFAI3huwIBriTuNKmRKfPTZ0VnPb+xyOtGAF6aq/G2KOPwJCrXuZcKKHTA66SpkfSBa9gcu23eUpb8J6RTcrG9QxaPxLN5wgRAbJvRM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/22/26 06:52, Hao Li wrote:
> On Fri, Jan 16, 2026 at 03:40:41PM +0100, Vlastimil Babka wrote:
>> A number of stat items related to cpu slabs became unused, remove them.
>> 
>> Two of those were ALLOC_FASTPATH and FREE_FASTPATH. But instead of
>> removing those, use them instead of ALLOC_PCS and FREE_PCS, since
>> sheaves are the new (and only) fastpaths, Remove the recently added
>> _PCS variants instead.
>> 
>> Change where FREE_SLOWPATH is counted so that it only counts freeing of
>> objects by slab users that (for whatever reason) do not go to a percpu
>> sheaf, and not all (including internal) callers of __slab_free(). Thus
>> flushing sheaves (counted by SHEAF_FLUSH) no longer also increments
>> FREE_SLOWPATH. This matches how ALLOC_SLOWPATH doesn't count sheaf
>> refills (counted by SHEAF_REFILL).
>> 
>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
>>  mm/slub.c | 77 +++++++++++++++++----------------------------------------------
>>  1 file changed, 21 insertions(+), 56 deletions(-)
>> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index c12e90cb2fca..d73ad44fa046 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -330,33 +330,19 @@ enum add_mode {
>>  };
>>  
>>  enum stat_item {
>> -	ALLOC_PCS,		/* Allocation from percpu sheaf */
>> -	ALLOC_FASTPATH,		/* Allocation from cpu slab */
>> -	ALLOC_SLOWPATH,		/* Allocation by getting a new cpu slab */
>> -	FREE_PCS,		/* Free to percpu sheaf */
>> +	ALLOC_FASTPATH,		/* Allocation from percpu sheaves */
>> +	ALLOC_SLOWPATH,		/* Allocation from partial or new slab */
>>  	FREE_RCU_SHEAF,		/* Free to rcu_free sheaf */
>>  	FREE_RCU_SHEAF_FAIL,	/* Failed to free to a rcu_free sheaf */
>> -	FREE_FASTPATH,		/* Free to cpu slab */
>> -	FREE_SLOWPATH,		/* Freeing not to cpu slab */
>> +	FREE_FASTPATH,		/* Free to percpu sheaves */
>> +	FREE_SLOWPATH,		/* Free to a slab */
> 
> Nits: Would it make sense to add stat(s, FREE_SLOWPATH) in
> free_deferred_objects() as well, since it also calls __slab_free()?

Yeah.

> Everything else looks good.
> 
> This patchset replaces cpu slab with cpu sheaves and really simplifies the code
> overall - I really like the direction and the end result. It's really been a
> pleasure reviewing this series. Thanks!
> 
> Reviewed-by: Hao Li <hao.li@linux.dev>

Thanks a lot for the thorough review!




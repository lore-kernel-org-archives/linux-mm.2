Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95F85D6554E
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 11:24:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 086E76B0005; Wed, 17 Dec 2025 06:24:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 044F36B0089; Wed, 17 Dec 2025 06:24:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E687B6B008A; Wed, 17 Dec 2025 06:24:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D687D6B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 06:24:04 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7F62E1409E6
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:24:04 +0000 (UTC)
X-FDA: 84228728808.03.C3B08F2
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 03B7C40002
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:24:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hxY7Mgeu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kZSwQUNy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gf0BO2yM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UhhSC2Xw;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765970642; a=rsa-sha256;
	cv=none;
	b=T9TOLRpexXVCPDiijttZkMV13ET1QY8WWIMmpnin4asECv7Vry33OR3oFfXlQ6DOR1PWle
	IYOaIXG5LXZPDuE5qXwwuZaLsfTy9Is1YN+QJ1wcAhPAEj45kmBl4gqvk116uUxFd3drg2
	enwbjZAwQDmijHV8akfTaySmbedVoVU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hxY7Mgeu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kZSwQUNy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gf0BO2yM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UhhSC2Xw;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765970642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=24Kv08jWVabx3GJ5mmA9ddJNB5snzTPzjQMrwzzz9o4=;
	b=WFKM1m4lmtQ2JfxcO7VowIjB0mOCIoEFcHSDOGhIByGnp/MpGZH1+2JrIsEZFhqpWp2ZT3
	wYgRp0gNh4+/GP2ZHH4itWlOSFv8SMRFxYSzLivPMwq6Id8cpy8iSieLoAiQhILrSICmmq
	0tAbaMnMG1zVVf2Vbd5WxN2RrN4Y9hw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 225AB5BCEC;
	Wed, 17 Dec 2025 11:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765970640; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=24Kv08jWVabx3GJ5mmA9ddJNB5snzTPzjQMrwzzz9o4=;
	b=hxY7MgeuHd1R6M2mbte9oVIQilJGN5xgPoO5Wu8sC4h5ZLUB3tSOsi4Mx6+sHW/SMX3Ko4
	eM5/5FI00T0GDANFrllbo+cheKhEeuwos7Z1+at0AL27/PBUzFN/C3x6iOi8BiOCuLRN7F
	/rTOo+dOzSf12HRntNdfCjywWU38FN8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765970640;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=24Kv08jWVabx3GJ5mmA9ddJNB5snzTPzjQMrwzzz9o4=;
	b=kZSwQUNy8mdJpbLEqME4yQ/2PShsC7HN4fGVP7WEtYEwjBrlqb2Y/2cIfWMjK1Lax0OkGk
	LcqIUtt6G5gFL5CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765970639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=24Kv08jWVabx3GJ5mmA9ddJNB5snzTPzjQMrwzzz9o4=;
	b=gf0BO2yM7mWDLCOR1Mvhv7tWeLZp/ive/UNu6zbUCGqkhjeKMaEA1pG8j5vQSPpziDmFDn
	X40ARrr7zBoj1qCibW/JLaIvZb3bJunP7Vqop/XU7ODE4Nfnda+rXdeI1wzTNoH0ukWsn8
	02KrPQ2POSJ2/hdzswDnwb88F2DxCYM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765970639;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=24Kv08jWVabx3GJ5mmA9ddJNB5snzTPzjQMrwzzz9o4=;
	b=UhhSC2XwZw3uGRuJjOrw1Xdz529Ixq3/jxQGJ10eAknqzcowfqiq4ugyEhD5oedvV26tIl
	Nt94lc+Q5OHnluDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 008AD3EA63;
	Wed, 17 Dec 2025 11:23:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MoFiO86SQmmQXAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 17 Dec 2025 11:23:58 +0000
Message-ID: <1c94600d-47eb-40b6-8c7e-fb2cc39e1e4b@suse.cz>
Date: Wed, 17 Dec 2025 12:23:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: restore 0-handling to
 zone_set_pageset_high_and_batch
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
To: Joshua Hahn <joshua.hahnjy@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Palmer <daniel@0x0f.com>, Guenter Roeck <linux@roeck-us.net>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Matthew Wilcox <willy@infradead.org>
References: <20251217060505.681923-1-joshua.hahnjy@gmail.com>
 <1cf7675a-2de3-425f-9938-af97f7c6436d@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <1cf7675a-2de3-425f-9938-af97f7c6436d@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 03B7C40002
X-Stat-Signature: fmmo7b1s8zifquzogmg6mrwb5rnkysfk
X-Rspam-User: 
X-HE-Tag: 1765970641-546163
X-HE-Meta: U2FsdGVkX19nkHXaZ7TQ7P5vczUuI9uDOPPOHsqAIw/ONNDtzrKPesvVoxvUuhh1gGf8mn5Jd/f8fP1o6P72KUHIwXwvogm+csKZI82XNISmNG9Kix41ysFoFecP1yr0Vg0en4g2rapak9J556urkl9VHKlttoEhyPXCqlrHJ36Gx3eewD0n86Wv3n9IF0ina3r0h7ZZ453eEcAD1wp5TVZayr5sGEDah2dH6MArM8THKDqP5xEtELV7GiyE1grcvCtGR6uJ00dZFWhTZ0gBHPJixeBA8YU32dQ59jXRRIuCZ2FcrQWbXhsLfR/8J26yjXbVQHk96NulTDd1tL4yn0xewTnFSlvFF9pkPASy/2KytzNqhRZg837TzdJCZbw5uwb4vLcWSYs307rfDlvyGoO+/+mkFJdL2Wve5T91/gyILf2nyddRCxJZgRC/2kcnQTCmv/vZzS3akxUJHo5w5U7pZISAlPmMBXEpwKv5k5Prfafho9o2A6m7PE+Tit7K20oYId+xkV1QajOG8Hr7UHd4tlEMAadB8LIeqURQNuNe16iukij71/og5yBIRsAYTZizz8UKiq8PtgmWwz36oH5KRiNY58pv/OoD81j5iPipPxE8Z2gDHnxWz5dyAHPiy/PVgeBFv1udLcCn8/8gCqdiLih3pjYk3F25T3CA/RqDuTSwkyZi9qr9B+wkC1vRsabRzHnoZjlOUHxGR63/hgt+v6PjPRWA6r8uW368kdQ+tkk2xjSS3i3lH035LKfS7awFvuvuy0DoV1RBNO38krZ+Zjlgu2Q+l1C1RgOBrg4mNWf34Qqd2Guc9+7SlF9vK4Ifj1irqtICdsNFscCgPuujVCrqFai+bJAcjmIWyhSiD6VmlYH8LhPoyTyiPjQub+wtliKs+qIoNF3xOlRBzdL+iug3VZtoxvLr3/KFoqo/TxV0qtAf8JK9ZL1qp2CcAtpOy9jbIIOTY1jpPOD
 awBow1g/
 6meMz363T2m5+bzZGT7erMakLT9xntBGFeUY7L//5wRr/y6XO4W9+KNysE+nrYVkPKiQwz4gabkaCNdWPWzHLN9H+2RkC7WOcNJIuSSULitKVDw8+exFJCXg277ueMQA+fsjngF0troGMLLuKJUWvrsa/us5hFjol1C53ApoDoi76xoz1Lcx5HzibLlJOHgJAOimdg2j+UKCRyQMzE5YANwWTfNoAHJDWQf+NgG48zmkVxRWqHEaKRl99QIh7+PP2KLcbmgdMl26MPlpMBZvTrxNXz2tgNDdPwqkX8IW7m25ifQYBHJQenGpr3LtmHk2ayJQ7L79EeoGmcWEp/QV5g/1PFNsZb+FOJ+4ojarb+vazbWDIegnhc9f0ycVYmBCe83XPynZeYtumoKJxZndhpQsccvElSDGPtirzX58FDTVteEBjk+emVdl/zu6MYuhCQyjMzcSpsCjkjXQdiShmP0ryAloOtcIb6pr7SowN13RH56N6/MPH7c8xn8Db0E4CRBTF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/17/25 12:12, Vlastimil Babka wrote:
> On 12/17/25 07:05, Joshua Hahn wrote:
>> Commit 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
>> moved the error handling (0-handling) of zone_batchsize from its
>> callers to inside the function. However, the commit left out the error
>> handling for the NOMMU case, leading to deadlocks on NOMMU systems.
>> 
>> Since in the NOMMU case the reported-to-user batchsize should still be 0,
> 
> Should it? The value is effectively set to 1 despite what zone_batchsize()
> returns, because of that adjustment this patch reinstates. Also does anyone
> care, really?
> 
>> we would only like the error handling to exist in the callsites that
>> set the internal value for the zone (i.e. zone_set_pageset_high_and_batch).
>> 
>> Restore max(1, zone_batchsize(zone)) to the callsite to prevent errors
>> on NOMMU systems.
> 
> I would rather make zone_batchsize() for !CONFIG_MMU return 1 instead of 0.

Ah looks like you considered it too, initially:
https://lore.kernel.org/all/20251211225947.822866-1-joshua.hahnjy@gmail.com/

It makes more sense to me than doing effectively two fixups in the MMU case.

>> Fixes: 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
>> Reported-by: Daniel Palmer <daniel@thingy.jp>
>> Closes: https://lore.kernel.org/linux-mm/CAFr9PX=_HaM3_xPtTiBn5Gw5-0xcRpawpJ02NStfdr0khF2k7g@mail.gmail.com/
>> Reported-by: Guenter Roeck <linux@roeck-us.net>
>> Closes: https://lore.kernel.org/all/42143500-c380-41fe-815c-696c17241506@roeck-us.net/
>> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
>> ---
>>  mm/page_alloc.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 822e05f1a964..10c1297fd3ea 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -6045,7 +6045,7 @@ static void zone_set_pageset_high_and_batch(struct zone *zone, int cpu_online)
>>  {
>>  	int new_high_min, new_high_max, new_batch;
>>  
>> -	new_batch = zone_batchsize(zone);
>> +	new_batch = max(1, zone_batchsize(zone));
>>  	if (percpu_pagelist_high_fraction) {
>>  		new_high_min = zone_highsize(zone, new_batch, cpu_online,
>>  					     percpu_pagelist_high_fraction);
>> 
>> base-commit: 40fbbd64bba6c6e7a72885d2f59b6a3be9991eeb
> 



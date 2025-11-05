Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B1A0CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 14:14:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2E5C8E000C; Wed,  5 Nov 2025 09:14:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDECB8E0003; Wed,  5 Nov 2025 09:14:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF4AF8E000C; Wed,  5 Nov 2025 09:14:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF0BA8E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:14:42 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 603E513A9BD
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 14:14:42 +0000 (UTC)
X-FDA: 84076749204.08.850088F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1D7C1140012
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 14:14:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2iEefTsX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eWMGy+vC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QQDOD4fe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lGbBjwjX;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762352080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LtaMTHwoSJ7gdcMsqu34UHmxryFF8g8ckxvwQO3B5rI=;
	b=FMcGzMi490ArEDvqB5JV9Q587wxjwpyrG5tr4UFBHF8/Gls0bdaGN5/JRWsQI63n4xtHwT
	RBMl0ZO6XwPwcsEweU3aP702gY63VFE7lMVoNgbCyxz9/t0Yed/GZ2zBpCRJ5S82P58GyN
	uco74FeTbd5t0KR9i4LqVli1nNRFnhk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762352080; a=rsa-sha256;
	cv=none;
	b=SzY22rPey9RDR0g/map6zjE19bSXMmL+ishT+6Nv1jP+V5bUE/af5UQM8ID1aV5hmUwc3g
	Q+8moic7/pkYTSpuIMFSY3v03QIwi2WRatx8DDKSjYiBSCPorzsH/LXl4gxoWkBG8y2cEm
	zAsSlDI7Jv+ZrO6l4js+Sc6I5gjlE2c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2iEefTsX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eWMGy+vC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QQDOD4fe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lGbBjwjX;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4862F21168;
	Wed,  5 Nov 2025 14:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762352078; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LtaMTHwoSJ7gdcMsqu34UHmxryFF8g8ckxvwQO3B5rI=;
	b=2iEefTsX1euMaa+FNxmPl3nh8idQbUXy155AilvmFKxhdcoKyM8RVpItV1+cLjVDxWU/rl
	WqleS1kf36xOENWqiGBHqbAcD7Vu0KdpI5HHHweoVuO7zy/zKFTtki3Ud94bQYtsK6tv4E
	aK30ma/I0FwXWB0URQAi1fFINqqe/mY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762352078;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LtaMTHwoSJ7gdcMsqu34UHmxryFF8g8ckxvwQO3B5rI=;
	b=eWMGy+vCWJugb+xfZG9LFToPeHdco31qNkoCouiIXae4gwP5xUJA+4oQ7XTlmuvvsDgRaB
	gLMiuDHm3Ek42MAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762352077; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LtaMTHwoSJ7gdcMsqu34UHmxryFF8g8ckxvwQO3B5rI=;
	b=QQDOD4feMN1N7I5KKQ7uf7egbepTkcg0MudYHAJCcd8aBoJGVUhHtRmG/Fdpq7ov3NDVjX
	KSHGcg0iYWFa91NbtGTMJXL7q8ZGiF18Ldm56bHraveLUhGaYY9FvccaSOq+BmQUjhKX/p
	5EYWEZ97gIxb25oJC7G22Gn+HY71RIo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762352077;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LtaMTHwoSJ7gdcMsqu34UHmxryFF8g8ckxvwQO3B5rI=;
	b=lGbBjwjX4eLt0ZDDfuREv71QYeCKsPcfsXFAwPYFBa/koic5cINLJMFOz9q129ZzSuInNK
	XXNdoCfsH8g9Z1DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1DAA413699;
	Wed,  5 Nov 2025 14:14:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id F+nUBc1bC2kQPgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 05 Nov 2025 14:14:37 +0000
Message-ID: <1b76a8c3-fefd-4bb8-b86a-f715e014bd6d@suse.cz>
Date: Wed, 5 Nov 2025 15:14:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/9] mempool: update kerneldoc comments
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Eric Biggers <ebiggers@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, linux-mm@kvack.org
References: <20251031093517.1603379-1-hch@lst.de>
 <20251031093517.1603379-2-hch@lst.de>
 <c6dbd7f1-0368-4ab2-83ab-e51b2b3e92b7@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <c6dbd7f1-0368-4ab2-83ab-e51b2b3e92b7@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: w9u1out18bgg318buckgwakrypeqwgy1
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D7C1140012
X-Rspamd-Server: rspam10
X-HE-Tag: 1762352079-835407
X-HE-Meta: U2FsdGVkX1/G9RL3Hbt3N4RCYvvOYrj0NehHHb4nt2vlLvfuf/HPelIYAVb+GW3ui1ldHw4J53r9fIKB71dEOv2itG+Nssr8b/hPPddPwGNCboKUM7sgqyoBZhFQDyH1plkRzNpomBIaGoAt3bW+qF554kdjhajjU3MKcUVoiYPFcoRcV0pzfvhPJwlX9kibbfYL58riOZNpckfV95K/S+jiALfnLNwxidHeXkco1Qoo6toxtzTXzn2KqfBwjRWOXyDiQqMiuU0pvgVoPV7EBF3VNyExhVqC32RIJ45e/xG+Vw0AFNyR8bSp2RwKulsF8dFwx7x/5hoCMbxn9rPtqEe8aTR0bzAJLO/Z0Kfd1ryrZsuHTIcUUJ7XwVpSOse00Amq+CMijB++JZUQOAiqPsOeOEPy3lEq2RIcWD2B57INEHB+WdFJw+61usLm8Yd4dqciwO8bsUeODiPUfptaYU/W3DGdfBaNWRH76ERQP2qBaJ0B25xdJV08qwmj8s862JrWUvu+JcV/1jDuY5xeqmU+Y4PpKJFDk1hQ4yF8A50uI1PVHlpgSjIkoTl3dVoY/xwsFaVRq8rDeV3kDr1bhjaHYDyUkGeprA6ET9WGUJYk7lZdwtIdZBh0uj4doCBQSE+GCl3HxOldns0HiWAj44ogC8ZiR8sP3ONk7RYRSxK2UxX/RuM99jVkeHQb0Fow/KeKoUZNOx7goin+9/hHrihGnRL3HJd0rxB/PFr8IxxPbBIT0WrASnpSaVMEUK3YCxggasyJO0o0GNgSgd7Eyjq2ZpLf5djNVPEO2230QgQbH8o5PGK080zm9UVcd5zCw6nHJiy9xoAvdtjuyJVsvT5PNHa1oaeRA6HIzOC0Bcr1zTf0hosFvViJqlTE9uhG3TWvM4fKqcZGS4U01zmZUsVtPEPze/wEx8inqqSZkFhwrONNE8WgWf1argwnLIz+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/5/25 15:02, Vlastimil Babka wrote:
> On 10/31/25 10:34, Christoph Hellwig wrote:
>> Use proper formatting, use full sentences and reduce some verbosity in
>> function parameter descriptions.
>> 
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> ---
>>  mm/mempool.c | 36 +++++++++++++++++-------------------
>>  1 file changed, 17 insertions(+), 19 deletions(-)
>> 
>> diff --git a/mm/mempool.c b/mm/mempool.c
>> index 1c38e873e546..d7c55a98c2be 100644
>> --- a/mm/mempool.c
>> +++ b/mm/mempool.c
>> @@ -372,18 +372,15 @@ int mempool_resize(mempool_t *pool, int new_min_nr)
>>  EXPORT_SYMBOL(mempool_resize);
>>  
>>  /**
>> - * mempool_alloc - allocate an element from a specific memory pool
>> - * @pool:      pointer to the memory pool which was allocated via
>> - *             mempool_create().
>> - * @gfp_mask:  the usual allocation bitmask.
>> + * mempool_alloc - allocate an element from a memory pool
>> + * @pool:	pointer to the memory pool
>> + * @gfp_mask:	GFP_* flags.
>>   *
>> - * this function only sleeps if the alloc_fn() function sleeps or
>> - * returns NULL. Note that due to preallocation, this function
>> - * *never* fails when called from process contexts. (it might
>> - * fail if called from an IRQ context.)
> 
> Why remove this part? Isn't it the most important behavior of mempools?
> 
>> - * Note: using __GFP_ZERO is not supported.
>> + * Note: This function only sleeps if the alloc_fn callback sleeps or returns
>> + * %NULL.  Using __GFP_ZERO is not supported.
>>   
>> - * Return: pointer to the allocated element or %NULL on error.
>> + * Return: pointer to the allocated element or %NULL on error. This function
>> + * never returns %NULL when @gfp_mask allows sleeping.

Oh I see, it's here.

Acked-by: Vlastimil Babka <vbabka@suse.cz>



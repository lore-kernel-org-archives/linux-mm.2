Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB99DCA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 10:13:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6D1F8E000C; Thu,  4 Sep 2025 06:13:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1C9F8E0001; Thu,  4 Sep 2025 06:13:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE5038E000C; Thu,  4 Sep 2025 06:13:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B29678E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:13:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2F02AC0AFB
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:13:28 +0000 (UTC)
X-FDA: 83851155696.15.9DBA979
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id CA4BB4000D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:13:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ADMeXip8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="tzuvLD/f";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ADMeXip8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="tzuvLD/f";
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756980806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2X+C3ZZNjZ4YV3oyJvmZaV0E/yUjqNpHuzGBIGNUEg4=;
	b=BEnOOo/Nb+uVeIXhOqwkLvrK+AgzYYy1EL4FA3QeF2x+zFC6+SEs818fq2K40omzJuHY4A
	GFoo8F1oyob9gptaIBkRwygh/7LtQaDd0d9Ve8zyGZtO6UtZQLE08jem2xCnbGjbnxTi7v
	2P8ghS9Ib2B5cIpgAGGG05LMg7d7gfs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ADMeXip8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="tzuvLD/f";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ADMeXip8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="tzuvLD/f";
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756980806; a=rsa-sha256;
	cv=none;
	b=JrXJIBYDDnlI212HycGchEtfTvP+CXo7OERNCyJnC7Rc9f4TBBydnlVC/BTZyg1SAYj2CT
	TINE8ifGpmvdxFgzwiWRj43sEtSXSosCL3Heqro1RkPwNtngwYhPoE1cC/qzEiBgNaGtHw
	PvRCkjCmzLazIMlaIQKtXk1qyYRH/vo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 140BF3442D;
	Thu,  4 Sep 2025 10:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756980804; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2X+C3ZZNjZ4YV3oyJvmZaV0E/yUjqNpHuzGBIGNUEg4=;
	b=ADMeXip8ilmTbst4zCAEIzTvtwV1rbeDu7Yv290/EhnP8tg4RwrnVjYhaMJefp/I3CCA+W
	IeRpgtEfR7wuXtftXxxkZBVPIE+9iQS4kSBaaiUYxtHpVEkNlnM/rZ7cfiqdvAFyu6h6LV
	UkX6+KFdmJc0VuDMEKpHP5ycxWGTcAk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756980804;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2X+C3ZZNjZ4YV3oyJvmZaV0E/yUjqNpHuzGBIGNUEg4=;
	b=tzuvLD/fqKgoCoqkPa0KGOor5sFp3O5/m7IBSzvfx15OzSOBkzg/TKRPjF2RyD83ITmsW+
	ayrm0NJtXKwhHRBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756980804; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2X+C3ZZNjZ4YV3oyJvmZaV0E/yUjqNpHuzGBIGNUEg4=;
	b=ADMeXip8ilmTbst4zCAEIzTvtwV1rbeDu7Yv290/EhnP8tg4RwrnVjYhaMJefp/I3CCA+W
	IeRpgtEfR7wuXtftXxxkZBVPIE+9iQS4kSBaaiUYxtHpVEkNlnM/rZ7cfiqdvAFyu6h6LV
	UkX6+KFdmJc0VuDMEKpHP5ycxWGTcAk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756980804;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2X+C3ZZNjZ4YV3oyJvmZaV0E/yUjqNpHuzGBIGNUEg4=;
	b=tzuvLD/fqKgoCoqkPa0KGOor5sFp3O5/m7IBSzvfx15OzSOBkzg/TKRPjF2RyD83ITmsW+
	ayrm0NJtXKwhHRBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 068BA13675;
	Thu,  4 Sep 2025 10:13:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HqRIAURmuWjnKQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 04 Sep 2025 10:13:24 +0000
Message-ID: <7b1ca42d-1b89-44f4-bffb-e6b09f86fdc5@suse.cz>
Date: Thu, 4 Sep 2025 12:13:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: remove zpool
Content-Language: en-US
To: Vitaly Wool <vitaly.wool@konsulko.se>, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Christoph Hellwig <hch@infradead.org>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250904093325.2768507-1-vitaly.wool@konsulko.se>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250904093325.2768507-1-vitaly.wool@konsulko.se>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CA4BB4000D
X-Stat-Signature: irstfd8gog4boons76bagb36s3hxz4pw
X-Rspam-User: 
X-HE-Tag: 1756980805-969372
X-HE-Meta: U2FsdGVkX18GccUhT5MZ7DP346rjldvRu5wCa6oIGeABj4bWBQOG8pErbZmiBQjmGQRj56NUUPRi3QA9+bN934lbuFpyGovvrEGq/5wyGhl7a8V2jfHCE9mc3XnRsYiCZRamul7tqWaeexV9qCqnGRLU4tckoOxXKugXlC3YosMRI5wQLRwboJ04z+fm2/JhTVrW9WIRudg2jwSlc+3w8U2NwqCFh+iihF6MDUqTmSe359YX4JZO1seZL4N2SnJGq5BXAR4OilTKVasFMw2TmaBw/O1h4gJeO+FlRTzH0tRh8eZ9z7CGsPPwDgtU4c0Dy0eNGrb/x6RTF2urTrFE6uEXXYOEBA9YxJrYVxtIsGuhcUgwO99x9lCkp6YiS2HLtJE8lmRmxV2iOUiByraZmrzmOLBFmGTEn91Z30wsZFLbAfDYY8cxgAhaNzh0FvrSMnUcziCEJi+71jP7ZVcitrXBip9jbj2pUdWqwTjE0TOJOAxbrj2zHd46fNfJo+LQimq+lKheuTn8C2MnkN4bwdt9CdsC9uESsnpmpgVBABHJPockBk1GQ6bFXjgsA+fnIW1Ici1+yvqrmujW+wafZy66FyRKXpuQbWhU2/g/+D5L6d7acmLFfAsykCTJ07LQ8CrBZP76Nl5goLQtRKny8scfjRKaPtZxKmNeW30+Unp6//4kyk1hNMp8jRakPuDjjHNEfzl/SFmscP1F5zDltTAKJPK9B5Y/eC2qM4b5RaGQVqNFnjvDthPcEnPRVmI6Zj97wsM3yyzwErqyVdzxwWzzSTjFtcZ8d2SSsnBpC81kFebmgPkwk8PpgxrALe1JuDEmj8ZGZ7CMH/O6zLNY3lHEpk/yVqc4o+tc7MwjjhjquzRdY2L6lI+RTn9ZRWsV71NyuLayBjSc31SKL2Ab1hhGXVDY/FGr1D2uGDp5131EBo0vzOetLhPgADDDcuYmoxNZzF15BYXMvfBT3C4
 TpZyFG5u
 EDZViHYP+uif6nCxgY29BNiLtW75lznV6G3bVV76FLY8kqQLWS/tw3M08THIJdYhxZKu7CqKQysFZ3e2YGKkfmUh7vnoCRLTpTOeSUPB/9OC5s2kKfKSDuljUPrj/49BBQA4AhVtENlEitqJW8qB1JX4Oi55G91Zs5ykEuAV3T163RsU6FbLJ8MaXQX6XPmpJGF6OnraRI4aWIOvCLn2A/mBw/ggMOab5E2QbdDRNvIHIGeMm7uw+gRU5yidbtCm1XTkej3Khy16lG4a3OGpqdSVCoYDHiMmJznU9Kw48KwaTXXsqlTnr7y9MT0PFY7dTeZ72/0Nkne1g6l3uEMcfOD+MGHJFXTnMWGMCOgFqf6mqY/AUZJwfrVO2GA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/4/25 11:33, Vitaly Wool wrote:
>> With zswap using zsmalloc directly, there are no more in-tree users of
>> this code. Remove it.
>> 
>> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Per the previous discussions, this gets a *NACK* from my side. There is
> hardly anything _technical_ preventing new in-tree users of zpool API.
> zpool API is neutral and well-defined, I don’t see *any* good reason for
> it to be phased out.

AFAIK it's a policy that unused code should be removed ASAP. And that's the
case for zpool after Patch 1, no? It could be different if another user was
about to be merged (to avoid unnecessary churn), but that doesn't seem the
case for zblock?

My concern would be if the removal breaks any existing installations relying
on zswap. Presumably not as a make oldconfig will produce a config where
nothing important is missing, and existing boot options such as
"zswap.zpool=" or attempts to write to in the init scripts to
"/sys/module/zswap/parameters/zpool" will cause some errors/noise but not
prevent booting correctly?

I mean if we were paranoid and anticipated somebody would break their
booting if writing to /sys/module/zswap/parameters/zpool failed, we could
keep the file (for a while) and just produce a warning in dmesg that it's
deprecated and does nothing?

From Patch 1:

> Note that this does not preclude future improvements and experiments
> with different allocation strategies. Should it become necessary, it's
> possible to provide an alternate implementation for the zsmalloc API,
> selectable at compile time. However, zsmalloc is also rather mature
> and feature rich, with years of widespread production exposure; it's
> encouraged to make incremental improvements rather than fork it.

With my history of maintaining the slab allocators I can only support this
approach.


> BTW, remarkable is that you didn't bother to CC: me to this patch.
> 
> Anyway,
> 
> Nacked-by: Vitaly Wool <vitaly.wool@konsulko.se>
> 


